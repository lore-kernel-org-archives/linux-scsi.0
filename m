From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: ahc_target_state check starget valid
Date: Sat, 25 Jun 2005 16:23:44 -0500
Message-ID: <1119734624.5033.40.camel@mulgrave>
References: <20050622140808.554fae2d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50888 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261338AbVFYVXy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 17:23:54 -0400
In-Reply-To: <20050622140808.554fae2d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>

On Wed, 2005-06-22 at 14:08 -0700, Andrew Morton wrote:
> Nope, Justin has departed the scene.  I think someone at adaptec has picked
> up maintenance, but James dinks with aic* as well.  MAINTAINERS needs some
> maintenance.

Well, Adaptec has more or less abandoned the aic7xxx series of drivers,
apparently, so I've been trying to get the one which I actually have
hardware for into some type of shape.

The patch is functional, but not quite complete, the bug being checking
starg (as the original code did) instead of starget, so the complete
patch takes out the superfluous if (starg == NULL) as well.

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx/aic7xxx_proc.c
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -155,9 +155,9 @@ ahc_dump_target_state(struct ahc_softc *
 	copy_info(info, "\tUser: ");
 	ahc_format_transinfo(info, &tinfo->user);
 	starget = ahc->platform_data->starget[target_offset];
-	targ = scsi_transport_target_data(starget);
-	if (targ == NULL)
+	if (!starget)
 		return;
+	targ = scsi_transport_target_data(starget);
 
 	copy_info(info, "\tGoal: ");
 	ahc_format_transinfo(info, &tinfo->goal);


