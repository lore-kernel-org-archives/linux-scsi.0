From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: new interfaces
Date: Wed, 26 May 2004 07:45:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526114521.GA24166@infradead.org>
References: <20040523103729.GA23804@infradead.org> <Pine.LNX.4.44.0405232233490.2248-300000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.217.7]:46344 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S265509AbUEZLpc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 07:45:32 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405232233490.2248-300000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sun, May 23, 2004 at 11:19:58PM +0200, Guennadi Liakhovetski wrote:
> > Looks mostly goo to me, one thing I worry about is the complete
> > removal of the scan_device flag, I don't fully understand what it's
> > supposed to do, but we should be able to always set in ->slave_alloc
> > and then clear it in ->slave_configure when we know probing is over
> > for this device.
> 
> Right, thanks. I didn't understand at all what scan_devices was doing
> there, so, I tried to preserve its semantics in the driver, and "just"
> overlooked its setting in dc390_SRBdone:-( But, wouldn't it be safer to
> just restore the relevant parts there, rather than moving it in
> slave_alloc / configure? Because... emn, well, I wanted to write "because
> it is tested later on in dc390_SRBdone:
> 	     if (pACB->scan_devices) pACB->DeviceCnt++;
> ", but then I checked, where else this DeviceCnt is used, and found only
> initialisation to 0, the increment above, no decrement, and a proc-output:
> 
>   SPRINTF("Nr of attached devices: %i, Nr of DCBs: %i\n", pACB->DeviceCnt, pACB->DCBCnt);
> 
> Whereas, DCBCnt is incremented on slave_alloc, decremented on
> slave_destroy and used in a couple more places. So, is it safe to assume
> that DeviceCnt is redundant and remove it in a next patch?... Then it
> might be already safe to move scan_devices as you suggest?

Looks like a way to go.  I'm not sure what scan_device is supposed to
do as I already wrote, but from looking at when it's set/cleared I'm
pretty sure it tries to indicate whethere we're currently scanning for
devices.  And useing slave_alloc/slave_configure is a much safer way to
find that out then guessing from the commands sent.

> > In dc390_init_one you don't call pci_disable_device on failure,
> > best switch to goto for a single shared error path to avoid all
> > these leaks.
> 
> Done. Actually, I copied this (and other) new function(s) from dc395x, so,
> they have this bug too...

There's quite a lot drivers missing it, because it's not nessecary
on most PCs.

> And, I asume, it has to be done in remove_one too, right?

Yes.

> RCS file: /usr/src/cvs/linux-2_6/include/scsi/scsi_host.h,v
> retrieving revision 1.1.1.3
> diff -u -r1.1.1.3 scsi_host.h
> --- include/scsi/scsi_host.h	19 May 2004 16:08:49 -0000	1.1.1.3
> +++ include/scsi/scsi_host.h	23 May 2004 20:18:31 -0000
> @@ -151,7 +151,7 @@
>  	 * here then you will get a call to slave_configure(), then the
>  	 * device will be used for however long it is kept around, then when
>  	 * the device is removed from the system (or * possibly at reboot
> -	 * time), you will then get a call to slave_detach().  This is
> +	 * time), you will then get a call to slave_destroy().  This is
>  	 * assuming you implement slave_configure and slave_destroy.
>  	 * However, if you allocate memory and hang it off the device struct,
>  	 * then you must implement the slave_destroy() routine at a minimum
> @@ -185,7 +185,7 @@
>  	 *     specific setup basis...
>  	 * 6.  Return 0 on success, non-0 on error.  The device will be marked
>  	 *     as offline on error so that no access will occur.  If you return
> -	 *     non-0, your slave_detach routine will never get called for this
> +	 *     non-0, your slave_destroy routine will never get called for this

This looks okay, but can you please send it to the list as a separate patch?


Rest of the patch also looks go to go in as-is, the additional items
can be fixed in followup-patches.
