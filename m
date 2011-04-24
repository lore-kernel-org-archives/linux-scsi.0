From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] scsi/libfc: fix mm leak in handling incoming request for
 target discovery
Date: Sun, 24 Apr 2011 10:47:33 +0800
Message-ID: <BANLkTiniTy862jPL=e_FGcRtPO27r8xVEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32870 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab1DXCre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Apr 2011 22:47:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: Robert Love <robert.w.love@intel.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

When handling incoming request, if the operation code carried by the
received frame is not RSCN, the frame should be freed as in the RSCN
case, or there is memory leakage.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_disc.c	2011-03-30 03:09:48.000000000 +0800
+++ b/drivers/scsi/libfc/fc_disc.c	2011-04-24 10:36:14.000000000 +0800
@@ -205,6 +205,7 @@ static void fc_disc_recv_req(struct fc_l
 	default:
 		FC_DISC_DBG(disc, "Received an unsupported request, "
 			    "the opcode is (%x)\n", op);
+		fc_frame_free(fp);
 		break;
 	}
 }
