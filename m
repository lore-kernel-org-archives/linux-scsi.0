From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 19:16:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067393780.1469.9.camel@ronald.kuetemeier.com>
References: <1067376788.1056.5.camel@ronald.kuetemeier.com>
	 <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org>
	 <20031028175157.A14803@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:34564 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S261838AbTJ2CQd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 21:16:33 -0500
In-Reply-To: <20031028175157.A14803@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>


> > Even the successful logfile had an odd feature.  The sd driver knew enough
> > to skip both the page 3F and the page 8 MODE-SENSE(10) calls.  But then it
> > went ahead and issued MODE-SENSE(6) for page 8!  Fortunately this worked
> > (or rather, failed cleanly enough) for things to progress okay.  Patrick,
> > can you explain that too?
> 
> The scsi_dev_flags overrides the host adapter setting, and we did not tell
> it to skip page 8. Since it worked it does not matter, but we could have
> used (given BLIST_MS_SKIP_PAGE_08 is 0x2000 and BLIST_MS_SKIP_PAGE_3F is
> 0x4000):
Patrick,
isn't BLIST_MS_SKIP_PAGE_08 always turned "on"?
>From drivers/usb/storage/scsiglue.c

        /* modify scsi_device bits on probe */
        .flags = (BLIST_MS_SKIP_PAGE_08 | BLIST_USE_10_BYTE_MS),

that's why I put the  BLIST_MS_SKIP_PAGE_3F there at the beginning, to
test if it's really a 3F problem, seemed like the place put it.
BTW, if you need a call tree,I most certainly can cook up some code next
week to generate one.
Ronald 

> 	
> 	echo "model:vendor:0x6000" > /proc/scsi/device_info
> 
> -- Patrick Mansfield
> 

