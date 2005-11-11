From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/1] cciss: scsi error handling
Date: Fri, 11 Nov 2005 15:41:47 -0600
Message-ID: <1131745307.3505.42.camel@mulgrave>
References: <45B36A38D959B44CB032DA427A6E10640A7A540D@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751240AbVKKVmR@vger.kernel.org>
In-Reply-To: <45B36A38D959B44CB032DA427A6E10640A7A540D@cceexc18.americas.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-11-11 at 13:38 -0600, Cameron, Steve wrote:
> About the locking first,
> 
> So, there's one part that I was a little worried about, where
> it does this in a couple places:
> 
>         c = (ctlr_info_t **) &scsicmd->device->host->hostdata[0];
> 
> (gets our adapter structure by following pointers in the scsi
> command)
> 
> So, if that pointer chain can change suddenly, then my code is bad.
> 
> Can doing "echo scsi remove-single-device . . . > /proc/scsi/scsi"
> cause that pointer chain to break?  I noticed I can yank a disk
> out from under a mounted filesystem with 
> "echo scsi remove-single-device"  It wasn't obvious to me whether
> doing that would affect that pointer chain though, though I could
> imagine it might.
> 
> Or am I barking up the wrong tree worrying about 
> the scsicmd->device->host->hostdata pointer chain
> getting yanked out from under me?

No, the pointers are all held in place.  Even if everyone else releases
their references, the commmand still contains a reference to the device
(which holds it from being released) and the device likewise contains a
reference to the host.

James
