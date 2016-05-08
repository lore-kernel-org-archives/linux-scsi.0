From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Sun, 8 May 2016 13:32:42 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
References: <1462668011.32105.7.camel@petros-ultrathin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60293 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbcEHDdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 May 2016 23:33:43 -0400
In-Reply-To: <1462668011.32105.7.camel@petros-ultrathin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>


On Sat, 7 May 2016, Petros Koutoupis wrote:

> The current state of the code checks to see if the reference to 
> scsi_cmnd is not null, but it never checks to see if it is null and 
> always assumes it is valid before its use in below switch statement. 
> This patch addresses that.
> 

There is no sign-off here.

> --- linux/drivers/scsi/megaraid/megaraid_sas_fusion.c.orig	2016-05-07 09:12:56.748969851 -0500
> +++ linux/drivers/scsi/megaraid/megaraid_sas_fusion.c	2016-05-07 09:15:29.612967113 -0500
> @@ -2277,6 +2277,10 @@ complete_cmd_fusion(struct megasas_insta
>  
>  		if (cmd_fusion->scmd)
>  			cmd_fusion->scmd->SCp.ptr = NULL;
> +		else if ((!cmd_fusion->scmd) &&
> +			 ((scsi_io_req->Function == MPI2_FUNCTION_SCSI_IO_REQUEST) ||
> +			 (scsi_io_req->Function == MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST)))
> +			goto next;

That contains a tautology.

>  
>  		scmd_local = cmd_fusion->scmd;
>  		status = scsi_io_req->RaidContext.status;
> @@ -2336,7 +2340,7 @@ complete_cmd_fusion(struct megasas_insta
>  				megasas_complete_cmd(instance, cmd_mfi, DID_OK);
>  			break;
>  		}
> -
> +next:
>  		fusion->last_reply_idx[MSIxIndex]++;
>  		if (fusion->last_reply_idx[MSIxIndex] >=
>  		    fusion->reply_q_depth)
> 
> 

Your patch is equivalent to this one:

@@ -2294,6 +2294,8 @@
 			complete(&cmd_fusion->done);
 			break;
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
+			if (unlikely(!scmd_local))
+				break;
 			/* Update load balancing info */
 			device_id = MEGASAS_DEV_INDEX(scmd_local);
 			lbinfo = &fusion->load_balance_info[device_id];
@@ -2311,6 +2313,8 @@
 			}
 			/* Fall thru and complete IO */
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
+			if (unlikely(!scmd_local))
+				break;
 			/* Map the FW Cmd Status */
 			map_cmd_status(cmd_fusion, status, extStatus);
 			scsi_io_req->RaidContext.status = 0;


I don't know anything about this driver or hardware so I'm not actually 
advocating any of these changes, just pointing out that your patch has 
issues.

I would have expected the 'smatch' checker to detect either the potential 
NULL pointer derefs or alternatively the redundant test for a non-NULL 
pointer. Maybe it has detected this already (?) or maybe the NULL pointer 
deref can be shown to be impossible?

-- 
