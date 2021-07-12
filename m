Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C662C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5346360FED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhGLFvr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:51:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A4C0613DD;
        Sun, 11 Jul 2021 22:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=B2Em73l7l5Ir0yQd8Hm94za45pPzP07KxRlNbh3C4CU=; b=nIV8OKLU8YfzjWbYAYijNvKvkA
        hfqu9NG4Yk8ZtTWMPpNbc7mqNsUD1jQD5qiEbb8umhuHYfvMH5xxdRc5EHLMcVmP4uitEkuzEKrqH
        AU7abmv620KlCOy0mCBbcNupduJWSnSLLGUVDx0mDmtL1eOve5X6K3hLKOSPb5NDnkQznZT5LNQ9V
        g4RLlUU5fdVR4zxnghDpKx2xkoZ9nc7G1yXcFBx6tFt80l6RCaFtU8nw5SmGaDa6ek6zYd8fUANxH
        UpICs47j8hsc/RmiMRUgLvwSG4j1/ekM4Tot20zCEMQDIvM3X1khA69/H+kUwwKIfzYGa/61/TEkd
        EeMVUI3g==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2onh-00Guzt-TU; Mon, 12 Jul 2021 05:48:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: cleanup SCSI ioctl support
Date:   Mon, 12 Jul 2021 07:47:52 +0200
Message-Id: <20210712054816.4147559-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series cleans up the scsi ioctl handler and merges the "block layer"
SCSI ioctl code that is only used by the SCSI layer and its drivers now
into the main SCSI ioctl handler.

Diffstat:
 b/block/Kconfig                |   26 -
 b/block/Makefile               |    3 
 b/block/bsg.c                  |  123 +----
 b/drivers/block/Kconfig        |    3 
 b/drivers/block/paride/Kconfig |    1 
 b/drivers/cdrom/cdrom.c        |    7 
 b/drivers/scsi/Kconfig         |   18 
 b/drivers/scsi/Makefile        |    3 
 b/drivers/scsi/ch.c            |   73 ---
 b/drivers/scsi/scsi_bsg.c      |   95 ++++
 b/drivers/scsi/scsi_common.c   |    6 
 b/drivers/scsi/scsi_ioctl.c    |  848 ++++++++++++++++++++++++++++++++++-----
 b/drivers/scsi/scsi_lib.c      |    7 
 b/drivers/scsi/scsi_priv.h     |   10 
 b/drivers/scsi/sd.c            |   66 ---
 b/drivers/scsi/sg.c            |   33 -
 b/drivers/scsi/sr.c            |   74 ---
 b/drivers/scsi/st.c            |   72 +--
 b/drivers/target/Kconfig       |    2 
 b/fs/nfsd/Kconfig              |    2 
 b/include/linux/blkdev.h       |   21 
 b/include/linux/bsg.h          |   11 
 b/include/scsi/scsi_ioctl.h    |    9 
 b/include/scsi/scsi_request.h  |    2 
 block/scsi_ioctl.c             |  890 -----------------------------------------
 25 files changed, 1011 insertions(+), 1394 deletions(-)
