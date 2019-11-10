Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E88C43331
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB52B22573
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573354517;
	bh=wg46qknz9Hf2607OK9IVon7QRzTj/a1p1YRAecuuMHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wpXhqDYwa8W8TLX1pjVCH/MMU5xmID5XOrbwouut1DUibP2jBklshU3UajV/tk4vE
	 tQqSFuYBHihkws9vHUYZ4yoLSMx/LFR1PSj3qu371+2fNfk/oGX/z9qhKmq0AYQL6a
	 BS9UmAnJ1Ch77FgJpW4F8S6VB1h/kB8h5+KEqNkY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfKJCzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbfKJCuX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2C622595;
        Sun, 10 Nov 2019 02:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354222;
        bh=wg46qknz9Hf2607OK9IVon7QRzTj/a1p1YRAecuuMHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raGrTtFep36Pvxw5Di+fOVpNhFHtm5s8h6fl07ojfhtsGcaqCwp0Gde2F2yLUeDEB
         3aWpmtoSMt9qV2JetK+u0IuUpDblLni0OZdwJJ1NTTXRx4553hxORi6jLs+uH4t6z1
         59xgNAP655l/UW+rU8U9huVAHMX7UN3o7g94ADGk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 60/66] scsi: NCR5380: Handle BUS FREE during reselection
Date:   Sat,  9 Nov 2019 21:48:39 -0500
Message-Id: <20191110024846.32598-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit ca694afad707cb3ae2fdef3b28454444d9ac726e ]

The X3T9.2 specification (draft) says, under "6.1.4.2 RESELECTION time-out
procedure", that a target may assert RST or go to BUS FREE phase if the
initiator does not respond within 200 us. Something like this has been
observed with AztecMonster II target. When it happens, all we can do is wait
for the target to try again.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 03f9ddbc37fbb..27270631c70c2 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2133,6 +2133,9 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (NCR5380_poll_politely(instance,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		if ((NCR5380_read(STATUS_REG) & (SR_BSY | SR_SEL)) == 0)
+			/* BUS FREE phase */
+			return;
 		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
 		do_abort(instance);
 		return;
-- 
2.20.1

