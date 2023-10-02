Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599F2E784BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbjJBPn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbjJBPnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30DAA4
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 82D482185F;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81Iz4ODeNk21/VA9LTmzHLWEv4f3Wo1nFl/h9ngSzUQ=;
        b=PvemvUoohEurb4GwXR4I3fH3UegXd3OX2ZsSFVrq49oOsnJEzWi9JekiX3I8OI2yhJhkXX
        VLvK0EQWaFKK946pTO9Q6BZJ1P8k/dxdcR9aHUA7qVe1Aq1agwbYpGFjnm15MdUskG4cQp
        1ISG4slcgSBQ2Y+xk1tI07ZmzVGq/pM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81Iz4ODeNk21/VA9LTmzHLWEv4f3Wo1nFl/h9ngSzUQ=;
        b=1O/quo27ai1eM8YSFZW45o08dushqnLDKj4HJkwceD/7xLRHrSECfq5JJYnupAYp+tmmIo
        qMi1N6PZZkqBTCAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 5DAA12C149;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 56DFB51E753D; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/18] mptfc: open-code mptfc_block_error_handler() for bus reset
Date:   Mon,  2 Oct 2023 17:43:13 +0200
Message-Id: <20231002154328.43718-4-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/message/fusion/mptfc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 5d5563ea90c2..aa6bb764df3e 100644
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
2.35.3

