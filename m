Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D290C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbiECUKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiECUKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8011527148
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 110EF210EE;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaC19SeuiWS9hN6nsljdN0K5RUABPsTK3K3J97t2gDI=;
        b=eZn6HFSKRylV5J11V9QpJDfcRtzWpfWHgu4+Ck9w3EH+c2We4jNaH/JtZWk2zaqma+/zec
        v/w7DLjxuYE2PapzV2dHQ6+gGMlPVBlcHA5PRb0ZqnPBn84PFL+GSWQpRHNomQUjB4NOuZ
        iy4cb6raDLMLgJsbhRhQJVTOGIqbYcg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaC19SeuiWS9hN6nsljdN0K5RUABPsTK3K3J97t2gDI=;
        b=PNhadx7RxJCJHeigtyK3mSXpdj2P2d82HkdmfrFRhCRFSzkCPLlWpmcUKYkot8Vxlfrfjq
        PNaH0HOpaozKPqDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id EC0B22C152;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 0721551941D2; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/24] mptfc: open-code mptfc_block_error_handler() for bus reset
Date:   Tue,  3 May 2022 22:06:46 +0200
Message-Id: <20220503200704.88003-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When calling bus_reset we have potentially several ports to be
reset, so this patch open-codes the existing mptfc_block_error_handler()
to wait for all ports attached to this bus.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptfc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index ea8fc32dacfa..4a621380a4eb 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -262,12 +262,23 @@ static int
 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	struct Scsi_Host *shost = SCpnt->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
 	MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
+	int channel = SCpnt->device->channel;
+	struct mptfc_rport_info *ri;
 	int rtn;
 
-	rtn = mptfc_block_error_handler(rport);
-	if (rtn == SUCCESS) {
+	list_for_each_entry(ri, &hd->ioc->fc_rports, list) {
+		if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
+			VirtTarget *vtarget = ri->starget->hostdata;
+
+			if (!vtarget || vtarget->channel != channel)
+				continue;
+			rtn = fc_block_rport(ri->rport);
+			if (rtn != 0)
+				break;
+		}
+	}
+	if (rtn == 0) {
 		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%llu, executing recovery.\n", __func__,
 			hd->ioc->name, shost->host_no,
-- 
2.29.2

