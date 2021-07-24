Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC3CC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F2CF60E91
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhGXGko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhGXGkm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:40:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D497BC061575;
        Sat, 24 Jul 2021 00:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=gOly5RgJwQW+4ree/ujTW38W0q8unpvwRJ7LE8eZS8c=; b=c//ppHUwJp8vv/1stiSv/Ky57D
        Y8TlFwITw0+WQVAHw56PlWEA7JyxuUT6hRNjjKPCMHnc7n011fc0wXon4sn3nGbM9+9hWuWXb6HG1
        ztigBNV/t3Aael+cGvAMUdPfCFcReNOP6DM+9nVa5LUnY+y7eyZttHLPXffiDvrMIGaGZ/3/dq2Y4
        Z3IL612bOPIbz30N1otDTKVn/SwKd+oIYe/ZFSYSzwZyUW3lqGoByYi+nNR9YL4hqSO/u9mr79QR1
        od96T7cKnzYWZd9kfNK7pTCYAqee/iBwoN4oRyJ+OGRMGUZP51TfFMdaxc5/vSmN7jvKJib8PWBJH
        cn2vgB9w==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7Bxa-00C4wW-Ge; Sat, 24 Jul 2021 07:20:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: cleanup SCSI ioctl support v2
Date:   Sat, 24 Jul 2021 09:20:09 +0200
Message-Id: <20210724072033.1284840-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series cleans up the scsi ioctl handler and merges the "block layer"
SCSI ioctl code that is only used by the SCSI layer and its drivers now
into the main SCSI ioctl handler.

Changes since v1:
 - replace and ifdef with an IS_ENABLED check to cater for modular bsg
   builds
 - rename queue_max_sectors_bytes to queue_max_bytes
 - return an unsigned value from queue_max_bytes
 - rename a few symbols to match their move to the SCSI code
 - scsi_common.c needs module.h for some configs, so add іt
 - use an u8 array instead of a char one for the CDB
 - document scsi_cmd_allowed

Diffstat:
