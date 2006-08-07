From: Dave Wysochanski <davidw@netapp.com>
Subject: Re: [PATCH] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
Date: Mon, 07 Aug 2006 02:03:10 -0400
Message-ID: <44D6D79E.3020304@netapp.com>
References: <44C9226C.6030309@netapp.com> <20060805120103.GA22356@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:26024 "EHLO mx2.netapp.com")
	by vger.kernel.org with ESMTP id S1751098AbWHGGDX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2006 02:03:23 -0400
In-Reply-To: <20060805120103.GA22356@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, usb-storage@lists.one-eyed-alien.net, stern@rowland.harvard.edu
Cc: James.Bottomley@steeleye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, hare@suse.de, "Kraft, Claire" <Claire.Kraft@netapp.com>, "Shenoy, Raghavendra" <Raghavendra.Shenoy@netapp.com>, "George, Martin" <marting@netapp.com>, "Nair, Vinod K" <nvinod@netapp.com>

Christoph Hellwig wrote:
> On Thu, Jul 27, 2006 at 04:30:36PM -0400, Dave Wysochanski wrote:
>  > Some targets may return PQ=1 and PDT=0x1f to indicate no LUN is mapped
>  > (Netapp targets do this).  This seems like a valid way to indicate no
>  > LUN mapped according to SPC-3.
>  >
>  > However, the current scsi_probe_and_add_lun() code adds a scsi_device
>  > for targets that return PQ=1 and PDT=0x1f.  This causes LUNs of type
>  > "UNKNOWN" to show up in /proc/scsi/scsi when no LUNs are mapped.
>  > In addition, subsequent rescans fail to recognize LUNs that may be
>  > added on the target, unless preceded by a write to the delete attribute
>  > of the "UNKNOWN" LUN.
>  >
>  > This patch addresses this problem by skipping over the scsi_add_lun()
>  > when PQ=1,PDT=0x1f is encountered, and just returns
>  > SCSI_SCAN_TARGET_PRESENT.
>  >
>  > If there are objections to this patch, I can add a BLIST flag and entry
>  > for Netapp targets but would like to avoid that if possible, since it
>  > seems like the current code might be closer to SPC-3 with this patch.
> 
> If you look at scsi_probe_and_add_lun in current mainline we already
> have a check for PDT=0x1f, keyed of a blacklist flag in the scsi target.
> The comment above it says it's for USB UFI.  It's missing the PQ=1
> check, though.  Can you reassure with the USB storage people that USB
> UFI indeed sets that periphal qualifier aswell (I'd guess so as IIRC
> that standard references SPC).  If that's the case replace that check
> with your version and remove the target flag.
> 
Yeah, I saw that.  If you look at that patch description from Alan, he
states the PQ=0 for these devices:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113951679626087&w=2

Unfortunately USB UFI 1.0 spec has "reserved" where the PQ bits normally are,
so maybe that's why there's only a check for PDT=0x1f?  Alan or someone
from the usb-storage list, can you confirm this is correct (PQ really
"reserved" is 0 for the USB UFI devices)?  I thought I had a USB floppy
lying around but no luck.

Also, it does not look like pdt_1f_for_no_lun flag Alan added is used.
Alan do you intend on submitting the patch to the USB slave_alloc() function
as you mentioned?

I'm not sure Alan's pdt_1f_for_no_lun flag should be used in my case,
since I would want to set it based on vid/pid - most appropriate in
scsi_get_device_flags() - and he wanted to set it in slave_alloc().
Maybe setting it in 2 different places for different devices is ok
though - your call.


> Also I'd suggest using a comment similar to the one in your patch to
> describe it, but mention USB UFI and Netapp targets as real world
> examples for this behaviour aswell.
> 
Sure.
