From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
Date: Sat, 5 Aug 2006 14:01:03 +0200
Message-ID: <20060805120103.GA22356@lst.de>
References: <44C9226C.6030309@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36483 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1161308AbWHEMB0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Aug 2006 08:01:26 -0400
Content-Disposition: inline
In-Reply-To: <44C9226C.6030309@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Wysochanski <davidw@netapp.com>
Cc: hch@lst.de, James.Bottomley@steeleye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, hare@suse.de, "Kraft, Claire" <Claire.Kraft@netapp.com>, "Shenoy, Raghavendra" <Raghavendra.Shenoy@netapp.com>, "George, Martin" <marting@netapp.com>, nvinod@netapp.com

On Thu, Jul 27, 2006 at 04:30:36PM -0400, Dave Wysochanski wrote:
> Some targets may return PQ=1 and PDT=0x1f to indicate no LUN is mapped
> (Netapp targets do this).  This seems like a valid way to indicate no
> LUN mapped according to SPC-3.
> 
> However, the current scsi_probe_and_add_lun() code adds a scsi_device
> for targets that return PQ=1 and PDT=0x1f.  This causes LUNs of type
> "UNKNOWN" to show up in /proc/scsi/scsi when no LUNs are mapped.
> In addition, subsequent rescans fail to recognize LUNs that may be
> added on the target, unless preceded by a write to the delete attribute
> of the "UNKNOWN" LUN.
> 
> This patch addresses this problem by skipping over the scsi_add_lun()
> when PQ=1,PDT=0x1f is encountered, and just returns
> SCSI_SCAN_TARGET_PRESENT.
> 
> If there are objections to this patch, I can add a BLIST flag and entry
> for Netapp targets but would like to avoid that if possible, since it
> seems like the current code might be closer to SPC-3 with this patch.

If you look at scsi_probe_and_add_lun in current mainline we already
have a check for PDT=0x1f, keyed of a blacklist flag in the scsi target.
The comment above it says it's for USB UFI.  It's missing the PQ=1
check, though.  Can you reassure with the USB storage people that USB
UFI indeed sets that periphal qualifier aswell (I'd guess so as IIRC
that standard references SPC).  If that's the case replace that check
with your version and remove the target flag.

Also I'd suggest using a comment similar to the one in your patch to
describe it, but mention USB UFI and Netapp targets as real world
examples for this behaviour aswell.
