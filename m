From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH] scsi_dh_alua: Re-enable STPG for unavailable ports
Date: Fri, 22 Jun 2012 17:52:14 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B07E504FD@SACEXCMBX02-PRD.hq.netapp.com>
References: <4FE431A2.2050500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:6902 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab2FVRwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 13:52:16 -0400
In-Reply-To: <4FE431A2.2050500@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

Bart,

> -----Original Message-----
> From: Bart Van Assche [mailto:bvanassche@acm.org]
> Sent: Friday, June 22, 2012 3:50 AM
> To: linux-scsi; Moger, Babu; Hannes Reinecke
> Subject: [PATCH] scsi_dh_alua: Re-enable STPG for unavailable ports
> 
> A quote from SPC-4: "While in the unavailable primary target port
> asymmetric access state, the device server shall support those of
> the following commands that it supports while in the active/optimized
> state: [ ... ] d) SET TARGET PORT GROUPS; [ ... ]". Hence re-enable
> sending STPG to a target port group that is in the unavailable state.

Patch looks good. One concern, the spec also says..
==============================
The unavailable target port asymmetric access state is
intended for situations when the target port accessibility to a logical unit may be severely restricted due to SCSI
target device limitations (e.g., hardware errors). Therefore it may not be possible to transition from this state to
either the active/optimized, active/non-optimized or standby states.
=====================================================

What happens if we cannot transition to active/optimized, active/non-optimized or standby states.  
Are we going to loop forever?  From kernel side it looks ok.  We are going mark the path as failed.  
It depends on what the path checker from multipath is going to do.  Do you have any idea about it?

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Babu Moger <babu.moger@netapp.com>
> Cc: Hannes Reinecke <hare@suse.de>
> 
> ---
> This patch fixes a regression introduced in kernel 3.5-rc1.
> 
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 5088209..155fadc 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -691,9 +691,9 @@ static int alua_activate(struct scsi_device *sdev,
>  				stpg = 0;
>  			break;
>  		case TPGS_STATE_STANDBY:
> +		case TPGS_STATE_UNAVAILABLE:
>  			stpg = 1;
>  			break;
> -		case TPGS_STATE_UNAVAILABLE:
>  		case TPGS_STATE_OFFLINE:
>  			err = SCSI_DH_IO;
>  			break;
