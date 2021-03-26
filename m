Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40369C433E4
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F7F61A51
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCZF7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 01:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCZF6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 01:58:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4BBC0613AA;
        Thu, 25 Mar 2021 22:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=j+/oBDdloN3o8INq+rDm+PXgibKfwME4qvVJRKkAE3w=; b=LYOlhVtISmUlD5eLhrg1Y3VvE+
        SL+YEpW3Qyc4XafPaldRkFpx8nLUAxvl15mQHgYA52azoulgbrnOCf088Oh5+lENKL9XqE8J4XwC3
        lMPLpeAvdycxqHoVsw1l88o+nHZ0sDmj5Wko1RjN49g++K961oVHLsua/XWU4ySC/RZ5sG03VpFvc
        a05A+Nse+lpgsAOTtiQ/D9qTdajvdp+PQxJxfg/olotehiAjQuyeFpx+p//g2T4SaHKQT1RXbE+jG
        3t2D3d0Ui6EqGYqG2qSRJZkhGGoY1JyYy6Ox5bJIyEXysN5Ec0GFx0rX17mHmsPWvywnca2GFUgzA
        T7BI6hGw==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfUG-005AOD-Dy; Fri, 26 Mar 2021 05:58:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: start removing block bounce buffering support v2
Date:   Fri, 26 Mar 2021 06:58:14 +0100
Message-Id: <20210326055822.1437471-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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


Changes since v1:
 - remove more dead code in advansys.c
 - fix the bounce limit stacking in blk_stack_limits
