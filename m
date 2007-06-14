From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] Farther clean up of stex.c driver
Date: Thu, 14 Jun 2007 19:33:44 +0300
Message-ID: <46716DE8.3030607@panasas.com>
References: <466EDFAC.9020104@panasas.com>	<20070613085118P.fujita.tomonori@lab.ntt.co.jp>	<E472128B1EB43941B4E7FB268020C89B0250B912@riverside.int.panasas.com> <20070613194513H.fujita.tomonori@lab.ntt.co.jp> <46716C45.1090107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:57226 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbXFNQdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 12:33:55 -0400
In-Reply-To: <46716C45.1090107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

>From 2b82909202cab8dc35184daef45b4b388f93112a Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Thu, 14 Jun 2007 19:14:40 +0300
Subject: [PATCH] Farther clean up of stex.c driver

 - now that scsi-ml accessors do not allow modifying of sg_count bufflen and
   sglist. The code in question is open coded to directly hack the scsi_cmnd
   structure. When implementation changes the driver will need to change with it.

 - Maintainer of this driver should please review again if we absolutely need this
   read-sense length fixing. What if less bytes are read and 0 are left at the end.
   Also no check is made if the buffer is large enough.
---
 drivers/scsi/stex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index adda296..d784b58 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -719,7 +719,7 @@ static void stex_ys_commands(struct st_hba *hba,

 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
-		scsi_bufflen(ccb->cmd) =
+		ccb->cmd->request_bufflen =
 			le32_to_cpu(*(__le32 *)&resp->variable[0]);
 		return;
 	}
-- 
1.5.0.4.402.g8035


