From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Wed, 29 Oct 2003 08:30:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029083057.A18130@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0310291004230.874-100000@ida.rowland.org> <1067442833.1103.7.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:26622 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262076AbTJ2QdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 11:33:03 -0500
Content-Disposition: inline
In-Reply-To: <1067442833.1103.7.camel@ronald.kuetemeier.com>; from ronald@kuetemeier.com on Wed, Oct 29, 2003 at 08:53:54AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Wed, Oct 29, 2003 at 08:53:54AM -0700, Ronald Kuetemeier wrote:
> On Wed, 2003-10-29 at 08:09, Alan Stern wrote:
> > On Tue, 28 Oct 2003, Patrick Mansfield wrote:

> > > The scsi_dev_flags overrides the host adapter setting, and we did not tell
> > > it to skip page 8. Since it worked it does not matter, but we could have
> > > used (given BLIST_MS_SKIP_PAGE_08 is 0x2000 and BLIST_MS_SKIP_PAGE_3F is
> > > 0x4000):
> > > 	
> > > 	echo "model:vendor:0x6000" > /proc/scsi/device_info
> > 
> > I don't get it.  The log shows there was no MODE-SENSE(10) issued for page 
> > 8, but the MODE-SENSE(6) was issued at exactly the corresponding place.  
> > This indicates that the sdev->use_10_for_ms flag wasn't set.  Why not?  I 
> > thought it was always set initially and cleared only if the 10-byte 
> > command provokes an error.

> Alan, Patrick
> this is what I was trying to say, the flag is on by default, see
> scsiglue.c. Ok I used the word always, my wrong. I meant default and yes
> I believe it can be overwritten but isn't in the current (test-9) case.
> In other words sd.c sees that flag and skips to the end of
> sd_read_cache_type
> 
>        if (sdkp->device->skip_ms_page_8)
>                 goto defaults;
>                                                                                 
>         /* cautiously ask */
>         res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);

And the setting of skip_ms_page_8 via the USB shost->flags was overwritten
via your use of /proc/scsi/device_info, not via any default code or values
in the kernel.

If we wanted to use MODE SENSE 10 first, no mode sense page 8, and no mode
sense page 0x3f, we want 0x2000 | 0x4000 | 0x8000 = 0xe000:

	echo "model:vendor:0xe000" > /proc/scsi/device_info

-- Patrick Mansfield
