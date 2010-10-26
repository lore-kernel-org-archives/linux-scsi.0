From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: fix stats computation in fc_queuecommand()
Date: Tue, 26 Oct 2010 21:01:36 +0800
Message-ID: <AANLkTimz_LBaPPJ_irEjiBy+f_MPCYYbLvD=oEw=JT-c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51436 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab0JZNBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 09:01:38 -0400
Received: by wyf28 with SMTP id 28so4624378wyf.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 06:01:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems accumulation needed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-10-26 20:52:46.000000000 +0800
@@ -1821,11 +1821,11 @@ int fc_queuecommand(struct scsi_cmnd *sc
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		fsp->req_flags = FC_SRB_READ;
 		stats->InputRequests++;
-		stats->InputMegabytes = fsp->data_len;
+		stats->InputMegabytes += fsp->data_len;
 	} else if (sc_cmd->sc_data_direction == DMA_TO_DEVICE) {
 		fsp->req_flags = FC_SRB_WRITE;
 		stats->OutputRequests++;
-		stats->OutputMegabytes = fsp->data_len;
+		stats->OutputMegabytes += fsp->data_len;
 	} else {
 		fsp->req_flags = 0;
 		stats->ControlRequests++;
