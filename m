From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: Write-protect checks
Date: Thu, 8 Dec 2005 14:00:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0512081355230.4934-100000@iolanthe.rowland.org>
References: <453E33D54126A643A9757AFD91EEBB3402409ACA@CXOEXC12.AMERICAS.CPQCORP.NET>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:18085 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932203AbVLHTAU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 14:00:20 -0500
In-Reply-To: <453E33D54126A643A9757AFD91EEBB3402409ACA@CXOEXC12.AMERICAS.CPQCORP.NET>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Fiala, Stefan" <Stefan.Fiala@hp.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Dmitry Antipov <antipov@ru.mvista.com>

On Thu, 8 Dec 2005, Fiala, Stefan wrote:

> The flag is set when the kernel/module is loaded.

No it isn't.

> For all but removeable the device must disappear/reappear
> Which fixes the flag.

No it doesn't.  The flag does not get set if the media is not removable.  
Here's the code from sd.c:sd_revalidate_disk():

	if (sdkp->media_present) {
		sd_read_capacity(sdkp, disk->disk_name, buffer);
		if (sdp->removable)
			sd_read_write_protect_flag(sdkp, disk->disk_name,
						   buffer);
		sd_read_cache_type(sdkp, disk->disk_name, buffer);
	}

That's the only place where sd_read_write_protect_flag gets called, so it 
never is called if sdp->removable is clear.

> Leaving removeables, that on user interaction, can change.
> For instance:
> On an RW-optical [use sd], eject current cartridge, flip wrt-prot tab,
> Re-insert. Unless a user were accessing during this sequence
> [sounds painful] the state of the WP bit would silently change.
> Hence the revalidate on open if its removeable.

Alan Stern

