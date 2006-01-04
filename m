From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi scan bug when peripheral qualifier of 3 is returned
Date: Wed, 04 Jan 2006 14:31:30 -0600
Message-ID: <43BC30A2.3090403@cs.wisc.edu>
References: <43BB750A.5050000@cs.wisc.edu> <20060104174019.GA3995@us.ibm.com> <43BC13B3.9030604@cs.wisc.edu> <20060104190119.GA4700@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32646 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965252AbWADUbk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 15:31:40 -0500
In-Reply-To: <20060104190119.GA4700@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> So yes we should always set *bflagsp. i.e.:
> 
> --- linux-2.6.15/drivers/scsi/orig-scsi_scan.c	2006-01-02 21:52:12.000000000 -0800
> +++ linux-2.6.15/drivers/scsi/scsi_scan.c	2006-01-04 10:58:36.000000000 -0800
> @@ -891,13 +891,13 @@ static int scsi_probe_and_add_lun(struct
>  	}
>  
>  	res = scsi_add_lun(sdev, result, &bflags);
> +	if (bflagsp)
> +		*bflagsp = bflags;


For SCSI_SCAN_TARGET_PRESENT, we never get this far. We bail out a 
couple of lines above in the check for PQ=3. Also, for some boxes like 
Clarions we have this in devinfo:

         {"DGC", "RAID", NULL, BLIST_SPARSELUN}, /* Dell PV 650F, 
storage on LUN 0 */
         {"DGC", "DISK", NULL, BLIST_SPARSELUN},


But LUN0 shows up as DGC/LUNZ. When we used to hardcode BLIST_SPARSELUN 
as a argument to scsi_sequential_lun_scan, we could find a least 8 
devices but now we hit this in scsi_sequential_lun_scan:

        /*
          * If not sparse lun and no device attached at LUN 0 do not scan
          * any further.
          */
         if (!sparse_lun && (lun0_res != SCSI_SCAN_LUN_PRESENT))
                 return;


Does IBM's fastt/DS or other boxes have this problem too? For Clarions 
do I just have to add a DGC/LUNZ entry to the devinfo list?
