From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Wed, 9 Feb 2011 10:32:01 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA99E@BLRX7MCDC203.AMER.DELL.COM>
References: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>
	<AANLkTimm-MC6kNGRgvFvrPh+YGTW5M6MPLrEd3C9K4vC@mail.gmail.com>
	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA563@BLRX7MCDC203.AMER.DELL.COM>
 <AANLkTinGE6v2DiTSf9VxjFD6EY=3kQz7QCxpaaF=Mr5T@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:11335 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1BIFCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 00:02:19 -0500
In-Reply-To: <AANLkTinGE6v2DiTSf9VxjFD6EY=3kQz7QCxpaaF=Mr5T@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: realrichardsharpe@gmail.com, Shyam_Iyer@Dell.com
Cc: lsf-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org, hare@suse.de

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Richard Sharpe
> Sent: Tuesday, February 08, 2011 12:51 AM
> To: Iyer, Shyam
> Cc: lsf-pc@lists.linuxfoundation.org; linux-scsi@vger.kernel.org;
> hare@suse.de
> Subject: Re: [LSF/MM Topic] SCSI Unit Attention Handling
> 
> On Tue, Feb 8, 2011 at 12:06 AM,  <Shyam_Iyer@dell.com> wrote:
> >> -----Original Message-----
> >> From: Richard Sharpe [mailto:realrichardsharpe@gmail.com]
> 
> [snip]
> 
> >>
> >> So, I wonder if adding just the ability for SCSI upper drivers (sd,
> >> st, etc) to register interest in different UNIT ATTENTIONS is all
> that
> >> interesting and whether vendors would rather have the ability to
> tell
> >> drivers (via an ioctl, say) the UNIT ATTENTIONS they are interested
> >> in, and how they should be mapped.
> >>
> >
> > An ioctl implementation would not be elegant.
> 
> I was only suggesting an ioctl for informing the driver of the
> ASC/ASCQ pairs of interest. To get the stream of UAs out of the kernel
> a different mechanism would be used, like, say, the relayfs.

I get you there. The ioctl implementation to inform the driver will not plug the storage from sending the UAs.

The LUN could be multipathed so then if you have UAs come through one sdX path and not through the other that is adding complication.
Also, if you are using persistent reservations and one of the path goes down the UAs could be going to a path that has been excluded.
We are introducing scenarios for bugs here.

> 
> > Even if registering for UAs per vendor was envisioned there are
> scenarios that can cause a flurry of UAs too..
> > (I initially opined to have a vendor specific implementation of
> logging scsi_netlink events from the scsi_device handler,
> > it was gloriously shot down ;-))
> >
> > Consider this scenario..
> >
> > Above water mark.. --> Unit Attention
> > Discard to free up space
> > Below water mark ... -> Unit Attention
> >
> > Consider a ripple scenario where this repeats..
> > (Although this can not happen too often it is very much akin to a
> thrashing scenario)
> >
> > The UA should be hints for the filesystem to optimize online. Here is
> where the thin profile can reduce the UAs.
> >
> > Also, you delete a file - select a good age time to discard the
> associated blocks(debatable and worth any good algorithm writer's
> salt).
> > Now I am not sure if the filesystem should run an inkernel thread to
> do this profile management..
> >
> >> It might be more useful to allow user-land utilities to perform the
> re-
> >> scanning.
> >>
> >> I would imagine that you will get unit attentions saying that
> REPORTED
> >> LUNS DATA HAS CHANGED, but what other UNIT ATTENTIONS would you get?
> >> If you add storage to a LUN, then perhaps CAPACITY DATA HAS CHANGED.
> >>
> >> Perhaps there is also a need to say things like, for these ASC/ASCQ
> >> values, take the device off line, and all the rest are just advisory
> >> but pass them all to user land as well.
> >>
> >
> > This is a kind of policy that needs to go into the thin profile
> although Storage Arrays do take the device offline on reaching
> > certain hard limits there is nothing like mounting a filesystem read-
> only ;-)
> 
> Well, yes, but Ext3/4 and XFS tend to remount the fs RO when writes to
> the journal fail as well because the SCSI stack takes the device
> offline :-(
> 
> If the device has lied in its response to a READ_CAPACITY or
> READ_CAPACITY16 that is hard to prevent unless the file system has the
> concept of a lying reserve ...
The lying reserve is again a profile/policy setting aka like a SWAP concept.

If the device has lied in either READ_CAPACITY_16 or GET_LBA_STATUS.. then we are anyways not consistent to the tee on the profile. Putting my open-source hat on that is a Carrot and stick bait.
-Shyam
