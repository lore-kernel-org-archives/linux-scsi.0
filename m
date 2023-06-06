Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19903C87FDC
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 19:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjFFTjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 15:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjFFTix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 15:38:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02C010EA;
        Tue,  6 Jun 2023 12:38:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 94F6A1FD92;
        Tue,  6 Jun 2023 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686080331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=leWSNybkvgM5TIQBj/WwVrrY7dWbgHg5e1qUYq/uf14=;
        b=EAAvmzrNAsQWRMdlS/08G/MyNj7yO3Ovbr/0Z5+b5kWnP47Rk8Zh3DH4R575crn+vzSmtD
        q4HeWneAYjI62F62ycL7fayQjzZ0iW1y8Gzrjwy7dJtrNBwm4Pq83Tcih6aigh7Qha4Owb
        Xg3SK8KxCXnKbPKouHidmv8WecGKs6c=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4016A13A47;
        Tue,  6 Jun 2023 19:38:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qM/tDUuLf2RaFwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 06 Jun 2023 19:38:51 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 1/3] bsg: increase number of devices
Date:   Tue,  6 Jun 2023 21:38:43 +0200
Message-Id: <20230606193845.9627-2-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606193845.9627-1-mwilck@suse.com>
References: <20230606193845.9627-1-mwilck@suse.com>
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

