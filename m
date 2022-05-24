Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91C6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 05:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiEXF4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 01:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiEXF4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 01:56:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED21BB2;
        Mon, 23 May 2022 22:56:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6DB9E219F0;
        Tue, 24 May 2022 05:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653371805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=naQIfyYNGj1jh99yLG3sNyAz1D0BD52kAYTi1iUqw7M=;
        b=U+wU2N3qlCVAXvXAxfWykfJdeKKZYUu7UpmTqVtj6TFQrLZxr7dEGeCmgzyXofeK+0lfPU
        vOAGbCWKzA0riFTKXdwq5qoIEQgIR4zsi/TeSafiGz7hp0qtqj2kIRvZFt2TkV9oPgNopg
        yFGSv+cwJ5yB54d2znhbvZ8LiDOPSSI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653371805;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=naQIfyYNGj1jh99yLG3sNyAz1D0BD52kAYTi1iUqw7M=;
        b=9qBfR2fcPEd1WkhtjBqGbFj+k0834sNkI67cTAlCNSzwRb9I+xeQIJewcA5O5EGNqobOPE
        5kmoy5iCTyvgPnBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 621382C142;
        Tue, 24 May 2022 05:56:45 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 317A45194632; Tue, 24 May 2022 07:56:45 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] block,scsi: BLK_STS_AGAIN clarification
Date:   Tue, 24 May 2022 07:56:29 +0200
Message-Id: <20220524055631.85480-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

BLK_STS_AGAIN should only be used under very specify circumstances,
so we should better document that. And modify the SCSI midlayer to
not return it, of course.

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  block: document BLK_STS_AGAIN usage
  scsi: return BLK_STS_TRANSPORT for ALUA transitioning

 drivers/scsi/scsi_lib.c   | 2 +-
 include/linux/blk_types.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.29.2

