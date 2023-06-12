Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F164C7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 16:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbjFLQvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjFLQvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 12:51:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8539AE71;
        Mon, 12 Jun 2023 09:51:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 25A3522813;
        Mon, 12 Jun 2023 16:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686588709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dcQe94NHWKwEfD3MI7AnQAtuXjeqyhqnM1uaeyFHWSs=;
        b=H5az4IrVi4KEYKxi6zHgMDlV+LbLscQ0A4yh3GEZ3RGNXPSTjwlum/u5yJ+PnRoSNeXxSP
        d+Cj2m4p4zbONWyJXqQqwdoaSMCcVe4RzCxXuak6igPAl8vinTLSaCdNyWjctjs26qCiqi
        g3CKtW5WoXcMSomKqr63jKmcjr67SEs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C12831357F;
        Mon, 12 Jun 2023 16:51:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CCneLCRNh2SOXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 16:51:48 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 1/7] bsg: increase number of devices
Date:   Mon, 12 Jun 2023 18:50:43 +0200
Message-Id: <20230612165049.29440-2-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612165049.29440-1-mwilck@suse.com>
References: <20230612165049.29440-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Larger setups may need to allocate more than 32k bsg devices, so
increase the number of devices to the full range of minor device
numbers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bsg.c b/block/bsg.c
index 7eca43f33d7f..c53f24243bf2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -36,7 +36,7 @@ static inline struct bsg_device *to_bsg_device(struct inode *inode)
 }
 
 #define BSG_DEFAULT_CMDS	64
-#define BSG_MAX_DEVS		32768
+#define BSG_MAX_DEVS		(1 << MINORBITS)
 
 static DEFINE_IDA(bsg_minor_ida);
 static struct class *bsg_class;
-- 
2.40.1

