From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Mon, 8 Nov 2004 16:35:06 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C2D1EB5@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27309 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261303AbUKHXfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 18:35:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
Cc: "Stephens, Larry" <larry.stephens@lsil.com>


On Saturday, November 06, 2004 4:03 PM, Christoph Hellwig wrote:
> 
>  - ioc->sasDeviceList still exists although it's not actually 
> traversed,
>    and quite a lot od dead code to fill it

Yes this is being used, and its not dead code.  Its filled and deleted
in mptscsih.c when devices are added and removed.  It appears now
that you had me removed the CSMI IOCTLs last week, this code will be
needed in other aspects such as sas transport layer, misc future features, 
and debugging.

>  - the mptctl_hba_pciinfo() ioctl call is vetoed, this information
>    can be easily retrived from sysfs, and we aboslutely don't 
> want this
>    duplicated in every LLDD

fine

>  - please don't add TRUE/FALSE defines - Linux codingstyle prefers 0/1

fine

>  - what's that ->last_lun thing about?

This fixes a bug sent to us by Tom Coughlan of Redhat; here
is the description of the bug from Tom : 

"When SPARSELUN is set, the SCSI midlayer unconditionally probes LUN
values up to max_lun in the SCSI host template.  In recent versions of
the mpt fusion driver this is set to 256. The problem is that on
non-U320 SCSI (non-packetized) the identify message is used, and its LUN
field is only 6 bits, allowing only 64 LUNs. This causes
selectio/reselection problems on the SCSI bus, resulting the
configuration of non-existant devices, or maybe worse."


>  - your forgot to kill one MPTSCSIH_DBG_TIMEOUT in ->queuecommand

fine

>  - mptscsih_slave_destroy still has the vdev != NULL check - if this
>    case still happens now that the hotremoval is fixed you're in
>    much deeper problems than this check could solve

Your correct, deleting the hotremoval stuff last week solved this.

>  - if you already changed the boot parameter syntax please move to
>    a module_param for each individual parameter

I will consider moving saf-te and pt_clear seperate.
However no change to the existing paramers that are dv 
associated parameters passed on the same line with "mptscsih".

Eric

 
