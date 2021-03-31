Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FA9C43332
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4078C619DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhCaHat (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbhCaHaf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:30:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF51C061574;
        Wed, 31 Mar 2021 00:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=f7NJynLusbV/PThRMSYkAr0uyWNxzLdYZK2fry6rSYA=; b=xWdxFsJKeU9XUqp6sD3FP3dheV
        Nm3D6Sa4HIPwDFY024PvTiQPym+fYlVkPL2l9k1wDL+oNwdg1su0PbszU597P0r9VFrVUFqItxRHH
        7gT/XjmjFS1lvmACHv8eZvvbMvx6DBHy37upcLkY28oh4ztwx8g3Sf5xJgiL/UzdgUdoBp8zzkEw/
        ZS8omguRaHIc3gIR4BuQ/0JjQEK2B4Jmismx9rCbzvKdK5l+OkxZ/3bhAkM6HuR+9A2+/BUW0kVZW
        l3W6/I/Cst7insRE03DCNsHdT2TOBuVKNkxc8OkP9JYxTEqgkoGrPMc+GrQfU35qWFuDFBxARcSka
        A4nwaZ3w==;
Received: from [2001:4bb8:180:7517:3f75:91d7:136b:f8e1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRVIi-009dES-M2; Wed, 31 Mar 2021 07:30:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: start removing block bounce buffering support v3
Date:   Wed, 31 Mar 2021 09:29:53 +0200
Message-Id: <20210331073001.46776-1-hch@lst.de>
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


Changes since v2:
 - remove more dead code in advansys.c
 - remove more dead code in BusLogic.c
 - update the BusLogic documentation

Changes since v1:
 - remove more dead code in advansys.c
 - fix the bounce limit stacking in blk_stack_limits
