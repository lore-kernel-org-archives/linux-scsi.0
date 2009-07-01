From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Add BLIST_REPORTLUN2 to EMC SYMMETRIX
Date: Wed, 01 Jul 2009 19:33:32 +0000
Message-ID: <1246476812.3894.56.camel@mulgrave.site>
References: <200907012018.13695.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39825 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503AbZGATdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 15:33:32 -0400
In-Reply-To: <200907012018.13695.jdelvare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-scsi@vger.kernel.org, Kurt Garloff <garloff@suse.de>, Hannes Reinecke <hare@suse.de>

On Wed, 2009-07-01 at 20:18 +0200, Jean Delvare wrote:
> From: Kurt Garloff <garloff@suse.de>
> 
> All EMC SYMMETRIX support REPORT_LUNS, even if configured to report
> SCSI-2 for whatever reason.
> 
> Signed-off-by: Kurt Garloff <garloff@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---
> We have this fix in our SLES10 kernel for over a year now, I guess
> it's about time to get it upstream so that everyone benefits.
> 
> Patch already sent on:
>  * 2009-05-29

The SCSI mailing list doesn't find it.

>  drivers/scsi/scsi_devinfo.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- root.orig/drivers/scsi/scsi_devinfo.c
> +++ root/drivers/scsi/scsi_devinfo.c
> @@ -152,7 +152,7 @@ static struct {
>  	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
>  	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
>  	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> -	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
> +	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_REPORTLUN2},

You don't actually need SPARSE or LARGELUN ... that's implied by
REPORTLUN2, so only REPORTLUN2 is needed here.

>  	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
>  	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
>  	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},

James


