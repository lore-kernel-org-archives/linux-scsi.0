Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3730BEB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 17:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbjFMRmo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 13:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbjFMRmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 13:42:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AB912C;
        Tue, 13 Jun 2023 10:42:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 186231FD67;
        Tue, 13 Jun 2023 17:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686678154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Md2lKFbYYlIFRimhTAFovw3H98C3UoSpAEfzkvqw8/k=;
        b=mrM+ux3vfS5f0sYubjbwO98sq52Jf49ZxcagsIC+vyDL1ivoH4rkrsREzVBRxnKY9XBJx7
        bgcw2ZOL6zNWJY0w1MAlMPMBPDg1e8IpD82ZvPS8Spkl+HZ2T5xERH4yxPFI84yD/NIp/H
        kWSr/AIyE53OTWk3ROB31+vj4HxD54A=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AA36313483;
        Tue, 13 Jun 2023 17:42:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OOB0J4mqiGSWXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 13 Jun 2023 17:42:33 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v6 2/7] scsi: sg: increase number of devices
Date:   Tue, 13 Jun 2023 19:42:22 +0200
Message-Id: <20230613174227.11235-3-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613174227.11235-1-mwilck@suse.com>
References: <20230613174227.11235-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Larger setups may need to allocate more than 32k sg devices, so
increase the number of devices to the full range of minor device
numbers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 037f8c98a6d3..6c04cf941dac 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -71,7 +71,7 @@ static int sg_proc_init(void);
 
 #define SG_ALLOW_DIO_DEF 0
 
-#define SG_MAX_DEVS 32768
+#define SG_MAX_DEVS (1 << MINORBITS)
 
 /* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
  * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
-- 
2.40.1

