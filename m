Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61607C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D5722B48
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576078292;
	bh=lKfNCLbge06ynSeeNl/69Gff5vv7u1VpkCKKbvmLJHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KEhMIWe+DLeNdvLAkUMAocQsMQS3NdvZAeEXAayjJGsuiKtKj9euc2VPCtULL4O3n
	 /BdwZous9RNYaJdV+4AOFNjjN2ny0LzM2g/8FbFf9KeLGXFn1wFWdAcVTQqGUYUOCJ
	 K5/4ZbvK18BPfateGDa555ewnJkuUTFAKScylKog=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387614AbfLKPb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387804AbfLKP3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:29:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF872467A;
        Wed, 11 Dec 2019 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078157;
        bh=lKfNCLbge06ynSeeNl/69Gff5vv7u1VpkCKKbvmLJHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xw/2L71X7KWmKCpo3bX8mj9GnXmYlNYkIc7i5RU41C9A0SGnX3YUD4kktRVxcdUa3
         39PBnhtI6cO//eEPbCm17eIGHDEh+k/7YtQ7R9VZp3p3mWoEH/2kTAzC2sSj8cj1Ls
         Uk/Fg1hlK3a8+Voo4aN49IkcsaC0fMz1v2wXO60g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 42/58] scsi: NCR5380: Add disconnect_mask module parameter
Date:   Wed, 11 Dec 2019 10:28:15 -0500
Message-Id: <20191211152831.23507-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 0b7a223552d455bcfba6fb9cfc5eef2b5fce1491 ]

Add a module parameter to inhibit disconnect/reselect for individual
targets. This gains compatibility with Aztec PowerMonster SCSI/SATA
adapters with buggy firmware. (No fix is available from the vendor.)

Apparently these adapters pass-through the product/vendor of the attached
SATA device. Since they can't be identified from the response to an INQUIRY
command, a device blacklist flag won't work.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Link: https://lore.kernel.org/r/993b17545990f31f9fa5a98202b51102a68e7594.1573875417.git.fthain@telegraphics.com.au
Reviewed-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 21377ac71168c..79b0b4eece194 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -129,6 +129,9 @@
 #define NCR5380_release_dma_irq(x)
 #endif
 
+static unsigned int disconnect_mask = ~0;
+module_param(disconnect_mask, int, 0444);
+
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 static void bus_reset_cleanup(struct Scsi_Host *);
@@ -946,7 +949,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	int err;
 	bool ret = true;
 	bool can_disconnect = instance->irq != NO_IRQ &&
-			      cmd->cmnd[0] != REQUEST_SENSE;
+			      cmd->cmnd[0] != REQUEST_SENSE &&
+			      (disconnect_mask & BIT(scmd_id(cmd)));
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
-- 
2.20.1

