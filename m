From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi scan bug when peripheral qualifier of 3 is returned
Date: Wed, 4 Jan 2006 14:25:22 -0800
Message-ID: <20060104222522.GA5741@us.ibm.com>
References: <43BB750A.5050000@cs.wisc.edu> <20060104174019.GA3995@us.ibm.com> <43BC13B3.9030604@cs.wisc.edu> <20060104190119.GA4700@us.ibm.com> <43BC30A2.3090403@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:24213 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030302AbWADWZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 17:25:26 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k04MPPPt026689
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 17:25:25 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k04MPPpu117516
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 17:25:25 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k04MPPhu023025
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 17:25:25 -0500
Content-Disposition: inline
In-Reply-To: <43BC30A2.3090403@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jan 04, 2006 at 02:31:30PM -0600, Mike Christie wrote:
> Patrick Mansfield wrote:
> >So yes we should always set *bflagsp. i.e.:
> >
> >--- linux-2.6.15/drivers/scsi/orig-scsi_scan.c	2006-01-02 
> >21:52:12.000000000 -0800
> >+++ linux-2.6.15/drivers/scsi/scsi_scan.c	2006-01-04 
> >10:58:36.000000000 -0800
> >@@ -891,13 +891,13 @@ static int scsi_probe_and_add_lun(struct
> > 	}
> > 
> > 	res = scsi_add_lun(sdev, result, &bflags);
> >+	if (bflagsp)
> >+		*bflagsp = bflags;
> 
> 
> For SCSI_SCAN_TARGET_PRESENT, we never get this far. We bail out a 
> couple of lines above in the check for PQ=3. Also, for some boxes like 

OK :-/

Then like this?

--- linux-2.6.15/drivers/scsi/orig-scsi_scan.c	2006-01-02 21:52:12.000000000 -0800
+++ linux-2.6.15/drivers/scsi/scsi_scan.c	2006-01-04 13:03:27.000000000 -0800
@@ -868,6 +868,8 @@ static int scsi_probe_and_add_lun(struct
 
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
+	if (bflagsp)
+		*bflagsp = bflags;
 
 	/*
 	 * result contains valid SCSI INQUIRY data.
@@ -896,8 +898,6 @@ static int scsi_probe_and_add_lun(struct
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sdev, result);
 		}
-		if (bflagsp)
-			*bflagsp = bflags;
 	}
 
  out_free_result:


> Clarions we have this in devinfo:
> 
>         {"DGC", "RAID", NULL, BLIST_SPARSELUN}, /* Dell PV 650F, 
> storage on LUN 0 */
>         {"DGC", "DISK", NULL, BLIST_SPARSELUN},
> 
> 
> But LUN0 shows up as DGC/LUNZ. When we used to hardcode BLIST_SPARSELUN 
> as a argument to scsi_sequential_lun_scan, we could find a least 8 
> devices but now we hit this in scsi_sequential_lun_scan:
> 
>        /*
>          * If not sparse lun and no device attached at LUN 0 do not scan
>          * any further.
>          */
>         if (!sparse_lun && (lun0_res != SCSI_SCAN_LUN_PRESENT))
>                 return;
> 
> 
> Does IBM's fastt/DS or other boxes have this problem too? 

For fastt, DS and other newer storage, we (likely) always use REPORT LUN
and so would never hit that code.

> For Clarions 
> do I just have to add a DGC/LUNZ entry to the devinfo list?

If they do not support REPORT LUN, yes (AFAIR/CT, my brain is slow ...).

Also, on some storage boxes, you can conditionaly set the scsi level too.
You could try changing that and/or also add a blist BLIST_REPORTLUN2 for
them to devinfo, or just use the sg report lun to test it.

Don't forget you can dynamically add devinfo values via modparam and
/proc/scsi.

-- Patrick Mansfield
