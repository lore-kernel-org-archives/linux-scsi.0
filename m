From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi scan bug when peripheral qualifier of 3 is returned
Date: Wed, 4 Jan 2006 11:01:19 -0800
Message-ID: <20060104190119.GA4700@us.ibm.com>
References: <43BB750A.5050000@cs.wisc.edu> <20060104174019.GA3995@us.ibm.com> <43BC13B3.9030604@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:9095 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965270AbWADTBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 14:01:23 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k04J1MDY032663
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 14:01:22 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k04J1Mbx118430
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 14:01:22 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k04J1MVb032077
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 14:01:22 -0500
Content-Disposition: inline
In-Reply-To: <43BC13B3.9030604@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jan 04, 2006 at 12:28:03PM -0600, Mike Christie wrote:
> Patrick Mansfield wrote:
> >On Wed, Jan 04, 2006 at 01:11:06AM -0600, Mike Christie wrote:
> >
> >
> >>But for SCSI_SCAN_TARGET_PRESENT bflags is not set. Is the correct fix 
> >>to move where bflagsp gets set in scsi_probe_and_add_lun so that it gets 
> >>set for the SCSI_SCAN_TARGET_PRESENT case, or should __scsi_scan_target 
> >>be passing scsi_sequential_lun_scan and possibly scsi_report_lun_scan 
> >>some default bflags values?
> >
> >
> >It looks OK to me as-is, since bflags is also passed to and set in
> >scsi_probe_lun(), right?
> >
> 
> A blagfs variable gets set but it is not the same one passed into 
> scsi_probe_and_add_lun.

Oh ... good catch there.

> static int scsi_probe_and_add_lun(struct scsi_target *starget,
>                                   uint lun, int *bflagsp,
> 
> 
> {
>         struct scsi_device *sdev;
>         unsigned char *result;
>         int bflags,
> 
> 
> scsi_probe_and_add_lun gets a *bflagsp passed to it as a function arg, 
> but then also decalres a bflags variable itself. It then passes 
> scsi_probe_lun() the bflags it declared and does this
> 
>         res = scsi_add_lun(sdev, result, &bflags);
>         if (res == SCSI_SCAN_LUN_PRESENT) {
>                 if (bflags & BLIST_KEY) {
>                         sdev->lockable = 0;
>                         scsi_unlock_floptical(sdev, result);
>                 }
>                 if (bflagsp)
>                         *bflagsp = bflags;
>         }
> 
> so *bflagsp pointer only gets set if SCSI_SCAN_LUN_PRESENT was returned 
> by scsi_add_lun. For SCSI_SCAN_TARGET_PRESENT we do not even get to 
> scsi_add_lun, so for this case *bflagsp never gets set and 
> __scsi_scan_target gets zero. Previously, __scsi_scan_target would just 
> pass scsi_sequential_lun_scan the sparse blist flag, but now it passes zero.

So yes we should always set *bflagsp. i.e.:

--- linux-2.6.15/drivers/scsi/orig-scsi_scan.c	2006-01-02 21:52:12.000000000 -0800
+++ linux-2.6.15/drivers/scsi/scsi_scan.c	2006-01-04 10:58:36.000000000 -0800
@@ -891,13 +891,13 @@ static int scsi_probe_and_add_lun(struct
 	}
 
 	res = scsi_add_lun(sdev, result, &bflags);
+	if (bflagsp)
+		*bflagsp = bflags;
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sdev, result);
 		}
-		if (bflagsp)
-			*bflagsp = bflags;
 	}
 
  out_free_result:


Also ... it looks like we should just pass bflags not &bflags to
scsi_add_lun(), since scsi_add_lun() does not modifies bflags.

-- Patrick Mansfield
