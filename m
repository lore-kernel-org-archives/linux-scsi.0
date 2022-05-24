Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC94BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbiEXGQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiEXGQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DE211175
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D15FC1F923;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9WhpHrhsqLXS04i3ak50HNYi0Ukyuycp5QnRvQGGpJs=;
        b=TbjQSZ6N62auY1XXGHPKkRnOoschMQ3eeCi+4XiUDK8T+vZyhvuk5CFkJXvrczf6xpC4TZ
        aVWmkwxJxu5USXLRYJ2sTRCxplfYgg1xLJnsK/MBzMKGA0k4Ds0P6lFm02snrPQkICEzuK
        OchbWCdiNuFXwJKD2ihVLXiNs8GIEEQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9WhpHrhsqLXS04i3ak50HNYi0Ukyuycp5QnRvQGGpJs=;
        b=qVFV8+pw1itawhrv3t0TGBmFbvdVsjB0K8Fer9CSb1ExQ63Ja2ZuogiT/KQckO+fXjqXFF
        EDPjczckssY+OfBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AC5882C149;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9C8045194642; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/16] mptfc: open-code mptfc_block_error_handler() for bus reset
Date:   Tue, 24 May 2022 08:15:51 +0200
Message-Id: <20220524061602.86760-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524061602.86760-1-hare@suse.de>
References: <20220524061602.86760-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When calling bus_reset we have potentially several ports to be
reset, so this patch open-codes the existing mptfc_block_error_handler()
to wait for all ports attached to this bus.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/message/fusion/mptfc.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index ea8fc32dacfa..654b17d5188e 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -262,12 +262,25 @@ static int
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
+			if (hd->ioc->active != 0)
+				break;
+		}
+	}
+	if (rtn == 0) {
 		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%llu, executing recovery.\n", __func__,
 			hd->ioc->name, shost->host_no,
-- 
2.29.2

