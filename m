Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B5EC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD15124654
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576079111;
	bh=tj9wfogutwTq7jhUxlzPs51lqLar4v91elPNG30PenA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lAIBCyvwCOtnSc9W5ALOBpyDyKtTQt2Z4XWHuQTUXZju9nCCyY0nBQ5pdjRfEmeeY
	 OhCuDOGMS6sUbJhVbJuQwRC8V3A/FJYktm4HYFRdLsxsOw6owPhfLwF+ELbkvS/49z
	 TUlkz+uvAiNnE+YU+ninFVi3PqGUy/+Z6/xDucgc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387809AbfLKPpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733271AbfLKP1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B8122527;
        Wed, 11 Dec 2019 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078033;
        bh=tj9wfogutwTq7jhUxlzPs51lqLar4v91elPNG30PenA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHQIX2Dmte15qtiZT6+UfxvcW+qO6NwMeWN+I3H4NDGTXYQIyqrh/PvzMafkfNUDx
         //vVcXedqMQ1kZ+Oug7QpyvJMP02Ps59/uC8L/bcHh4Ip9A0KMKSBeG16pCkW2Vj+j
         hw3UX4zbeb0y22+8Ue/XlCQL5PtVj4FJOwndgXcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/79] scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
Date:   Wed, 11 Dec 2019 10:25:51 -0500
Message-Id: <20191211152643.23056-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 7cfd5639d99bec0d27af089d0c8c114330e43a72 ]

If the driver receives a login that is later then LOGO'd by the remote port
(aka ndlp), the driver, upon the completion of the LOGO ACC transmission,
will logout the node and unregister the rpi that is being used for the
node.  As part of the unreg, the node's rpi value is replaced by the
LPFC_RPI_ALLOC_ERROR value.  If the port is subsequently offlined, the
offline walks the nodes and ensures they are logged out, which possibly
entails unreg'ing their rpi values.  This path does not validate the node's
rpi value, thus doesn't detect that it has been unreg'd already.  The
replaced rpi value is then used when accessing the rpi bitmask array which
tracks active rpi values.  As the LPFC_RPI_ALLOC_ERROR value is not a valid
index for the bitmask, it may fault the system.

Revise the rpi release code to detect when the rpi value is the replaced
RPI_ALLOC_ERROR value and ignore further release steps.

Link: https://lore.kernel.org/r/20191105005708.7399-2-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 51b06b8a1dc72..969e0c176ed1d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17875,6 +17875,13 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 static void
 __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 {
+	/*
+	 * if the rpi value indicates a prior unreg has already
+	 * been done, skip the unreg.
+	 */
+	if (rpi == LPFC_RPI_ALLOC_ERROR)
+		return;
+
 	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
 		phba->sli4_hba.rpi_count--;
 		phba->sli4_hba.max_cfg_param.rpi_used--;
-- 
2.20.1

