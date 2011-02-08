From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Mon, 7 Feb 2011 21:06:05 -0800
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA563@BLRX7MCDC203.AMER.DELL.COM>
References: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>
 <AANLkTimm-MC6kNGRgvFvrPh+YGTW5M6MPLrEd3C9K4vC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:51789 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab1BHFHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2011 00:07:21 -0500
In-Reply-To: <AANLkTimm-MC6kNGRgvFvrPh+YGTW5M6MPLrEd3C9K4vC@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: realrichardsharpe@gmail.com
Cc: lsf-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org, hare@suse.de

> -----Original Message-----
> From: Richard Sharpe [mailto:realrichardsharpe@gmail.com]
> Sent: Monday, February 07, 2011 9:01 PM
> To: Iyer, Shyam
> Cc: lsf-pc@lists.linuxfoundation.org; linux-scsi@vger.kernel.org;
> hare@suse.de
> Subject: Re: [LSF/MM Topic] SCSI Unit Attention Handling
> 
> On Sun, Feb 6, 2011 at 5:32 PM,  <Shyam_Iyer@dell.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> >> owner@vger.kernel.org] On Behalf Of Richard Sharpe
> >> Sent: Sunday, February 06, 2011 3:44 PM
> >> To: lsf-pc@lists.linuxfoundation.org; linux-scsi; Hannes Reinecke
> >> Subject: [LSF/MM Topic] SCSI Unit Attention Handling
> >>
> >> I would like to propose a topic around SCSI Unit Attention Handling.
> >>
> >> The current scsi_error.c:scsi_check_sense handling of UNIT ATTENTION
> >> consists of explicitly printing warnings for for ASC=0x3f events and
> >> then returning SOFT_ERROR which scsi_error.c:scsi_decide_disposition
> >> ignores because it returns SUCCESS to SOFT_ERROR being returned from
> >> scst_check_sense on a CHECK_CONDITION.
> >>
> >> There are a number of cases where we might want to perform further
> >> processing on a UNIT ATTENTION. For example, ASC/ASCQ 0x3f/0x0e
> >> REPORTED LUNS DATA HAS CHANGED or 0x2a/0x09 CAPACITY DATA HAS
> CHANGED,
> >> 0x28/0x03 IMPORT/EXPORT ELEMENT ACCESSED, MEDIUM CHANGED, etc. When
> >> the LUNS have changed it would be useful to have a recan performed
> >> automatically. If capacity data has changed, it would be useful if
> >> someone could react to that and perhaps resize the file system on
> that
> >> LUN if possible, and so forth.
> >>
> >> It is not clear that any of these items should be handled in the
> >> kernel anyway, and perhaps they should be exported to user-space for
> >> correct handling, but rather than just the raw SENSE data being
> >> exported, perhaps some sort of relevant event should be exported.
> >>
> > We spoke about this in the plumbers conf last November as well and
> the few ideas then was to handle them via scsi netlink.
> > I see that Hannes is working on a relayfs method to handle them.
> >
> > Some of the new problems that we can see with handling such events
> are -
> >
> > If the thin provisioned LUN is snapshotted or cloned then you can
> also get a flurry of UNIT attentions for the same data
> > that has been replicated.
> 
> So, I wonder if adding just the ability for SCSI upper drivers (sd,
> st, etc) to register interest in different UNIT ATTENTIONS is all that
> interesting and whether vendors would rather have the ability to tell
> drivers (via an ioctl, say) the UNIT ATTENTIONS they are interested
> in, and how they should be mapped.
> 

An ioctl implementation would not be elegant.

Even if registering for UAs per vendor was envisioned there are scenarios that can cause a flurry of UAs too..
(I initially opined to have a vendor specific implementation of logging scsi_netlink events from the scsi_device handler, it was gloriously shot down ;-))

Consider this scenario.. 

Above water mark.. --> Unit Attention
Discard to free up space
Below water mark ... -> Unit Attention

Consider a ripple scenario where this repeats..
(Although this can not happen too often it is very much akin to a thrashing scenario)

The UA should be hints for the filesystem to optimize online. Here is where the thin profile can reduce the UAs.

Also, you delete a file - select a good age time to discard the associated blocks(debatable and worth any good algorithm writer's salt).
Now I am not sure if the filesystem should run an inkernel thread to do this profile management.. 

> It might be more useful to allow user-land utilities to perform the re-
> scanning.
> 
> I would imagine that you will get unit attentions saying that REPORTED
> LUNS DATA HAS CHANGED, but what other UNIT ATTENTIONS would you get?
> If you add storage to a LUN, then perhaps CAPACITY DATA HAS CHANGED.
>
> Perhaps there is also a need to say things like, for these ASC/ASCQ
> values, take the device off line, and all the rest are just advisory
> but pass them all to user land as well.
> 

This is a kind of policy that needs to go into the thin profile although Storage Arrays do take the device offline on reaching certain hard limits there is nothing like mounting a filesystem read-only ;-)

-Shyam

> --
> Regards,
> Richard Sharpe
