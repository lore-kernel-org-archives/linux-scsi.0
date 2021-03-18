Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20223C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF83F64F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhCRGk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 02:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCRGkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 02:40:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC77C06174A;
        Wed, 17 Mar 2021 23:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=w9eSeMx5GnmBb+ZPo7/G+ahBTYSxETSJHbZaK5M9CNg=; b=tjt8WhyOumzMC+a1st5QIabgtm
        mWxIFHF88awil0Jau6Kai1XE+ICj9X0t/RB/6yta3NqXK84mplZ1KK340torHjDSl0Vby69e1Q7Zu
        hFLKvIAfPz7BHymi8Ci62Qf+1DrvW+Dn9o8XVAbMMAjdRuOQmiICZG9hLZGhhXKBX0IRQw1A6uSx1
        0GXwoWcAAmH4Z10+bv49lrplQzs4M+Gwj993a+RbLU8c2Mlby8DTe97sc0DzwKltJTOPs+fvCEf3V
        9H6YJc5SEqbBcnaDkW3fCFwEqttN+1Nmk7AauaRA77RwMNJk3BoWV8NE/WVX38NWyjt0aQR5CRO/f
        ExraqXtg==;
Received: from [2001:4bb8:18c:bb3:e1cf:ad2f:7ff7:7a0b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMmJX-002evj-Vg; Thu, 18 Mar 2021 06:39:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: start removing block bounce buffering support
Date:   Thu, 18 Mar 2021 07:39:15 +0100
Message-Id: <20210318063923.302738-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series starts to clean up and remove the impact of the legacy old
block layer bounce buffering code.

First it removes support for ISA bouncing.  This was used by three SCSI
drivers.  One of them actually had an active user and developer 5 years
ago so I've converted it to use a local bounce buffer - Ondrej, can you
test the coversion?  The next one has been known broken for years, and
the third one looks like it has no users for the ISA support so they
are just dropped.

It then removes support for dealing with bounce buffering highmem pages
for passthrough requests as we can just use the copy instead of the map
path for them.  This will reduce efficiency for such setups on highmem
systems (e.g. usb-storage attached DVD drives), but then again that is
what you get for using a driver not using modern interfaces on a 32-bit
highmem system.  It does allow to streamline the common path pretty nicely.

Diffstat:
 Documentation/scsi/scsi_mid_low_api.rst |    4 
 block/bio-integrity.c                   |    3 
 block/blk-core.c                        |    6 
 block/blk-map.c                         |  120 +++----------
 block/blk-settings.c                    |   53 ------
 block/blk.h                             |   17 +
 block/bounce.c                          |  138 ++-------------
 block/scsi_ioctl.c                      |    2 
 drivers/ata/libata-scsi.c               |    3 
 drivers/nvme/host/lightnvm.c            |    2 
 drivers/scsi/BusLogic.c                 |  177 +-------------------
 drivers/scsi/BusLogic.h                 |    4 
 drivers/scsi/Kconfig                    |    2 
 drivers/scsi/advansys.c                 |  279 ++------------------------------
 drivers/scsi/aha1542.c                  |  105 ++++++------
 drivers/scsi/esas2r/esas2r_main.c       |    1 
 drivers/scsi/hosts.c                    |    7 
 drivers/scsi/scsi_debugfs.c             |    1 
 drivers/scsi/scsi_lib.c                 |   52 -----
 drivers/scsi/scsi_scan.c                |    6 
 drivers/scsi/scsi_sysfs.c               |    2 
 drivers/scsi/sg.c                       |   10 -
 drivers/scsi/sr_ioctl.c                 |   12 -
 drivers/scsi/st.c                       |   20 --
 drivers/scsi/st.h                       |    2 
 drivers/target/target_core_pscsi.c      |    4 
 include/linux/blkdev.h                  |   38 +---
 include/scsi/scsi_cmnd.h                |    7 
 include/scsi/scsi_host.h                |    6 
 mm/Kconfig                              |    9 -
 30 files changed, 210 insertions(+), 882 deletions(-)
