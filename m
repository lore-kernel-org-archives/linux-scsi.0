From: Bryan Holty <lgeek@frontiernet.net>
Subject: Re: [PATCH] sg: fix leak when dio setup fails
Date: Thu, 30 Mar 2006 13:15:25 -0600
Message-ID: <200603301315.25447.lgeek@frontiernet.net>
References: <44299306.4080709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.roc.ny.frontiernet.net ([66.133.182.165]:16270 "EHLO
	relay02.roc.ny.frontiernet.net") by vger.kernel.org with ESMTP
	id S1750911AbWC3U7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 15:59:31 -0500
In-Reply-To: <44299306.4080709@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Tuesday 28 March 2006 13:48, Douglas Gilbert wrote:
> Further to this thread started by Bryan Holty:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114306885116728&w=2
>
> Here is the reworked patch again. This time it has been
> tested with a program provided by Bryan. The patch is
> against lk 2.6.16 .
>
> Changelog:
>   - when the sg driver is unable to setup direct IO,
>     free that scatter gather list prior to falling
>     back to indirect IO
>
> Signed-off-by: Douglas Gilbert <dougg@torque.net>
>
> Doug Gilbert

Thanks Doug, this fixes the fixes the sg memory leak and the eventual kernel 
out of memory killer.

Signed-off-by: Douglas Gilbert <dougg@torque.net>
Signed-off-by: Bryan Holty <lgeek@frontiernet.net>

--- linux/drivers/scsi/sg.c	2006-03-20 10:08:49.000000000 -0500
+++ linux/drivers/scsi/sg.c2616dio_lk	2006-03-22 18:26:23.000000000 -0500
@@ -1834,8 +1834,10 @@
 	res = st_map_user_pages(schp->buffer, mx_sc_elems,
 				(unsigned long)hp->dxferp, dxfer_len, 
 				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0);
-	if (res <= 0)
+	if (res <= 0) {
+		sg_remove_scat(schp);
 		return 1;
+	}
 	schp->k_use_sg = res;
 	schp->dio_in_use = 1;
 	hp->info |= SG_INFO_DIRECT_IO;
--
 Bryan Holty
