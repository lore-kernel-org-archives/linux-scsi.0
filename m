From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Tue, 8 Feb 2011 00:51:10 -0500
Message-ID: <AANLkTinGE6v2DiTSf9VxjFD6EY=3kQz7QCxpaaF=Mr5T@mail.gmail.com>
References: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>
	<AANLkTimm-MC6kNGRgvFvrPh+YGTW5M6MPLrEd3C9K4vC@mail.gmail.com>
	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA563@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37767 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1BHFvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2011 00:51:11 -0500
Received: by iwn9 with SMTP id 9so5391773iwn.19
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2011 21:51:10 -0800 (PST)
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA563@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@dell.com
Cc: lsf-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org, hare@suse.de

On Tue, Feb 8, 2011 at 12:06 AM,  <Shyam_Iyer@dell.com> wrote:
>> -----Original Message-----
>> From: Richard Sharpe [mailto:realrichardsharpe@gmail.com]

[snip]

>>
>> So, I wonder if adding just the ability for SCSI upper drivers (sd,
>> st, etc) to register interest in different UNIT ATTENTIONS is all that
>> interesting and whether vendors would rather have the ability to tell
>> drivers (via an ioctl, say) the UNIT ATTENTIONS they are interested
>> in, and how they should be mapped.
>>
>
> An ioctl implementation would not be elegant.

I was only suggesting an ioctl for informing the driver of the
ASC/ASCQ pairs of interest. To get the stream of UAs out of the kernel
a different mechanism would be used, like, say, the relayfs.

> Even if registering for UAs per vendor was envisioned there are scenarios that can cause a flurry of UAs too..
> (I initially opined to have a vendor specific implementation of logging scsi_netlink events from the scsi_device handler,
> it was gloriously shot down ;-))
>
> Consider this scenario..
>
> Above water mark.. --> Unit Attention
> Discard to free up space
> Below water mark ... -> Unit Attention
>
> Consider a ripple scenario where this repeats..
> (Although this can not happen too often it is very much akin to a thrashing scenario)
>
> The UA should be hints for the filesystem to optimize online. Here is where the thin profile can reduce the UAs.
>
> Also, you delete a file - select a good age time to discard the associated blocks(debatable and worth any good algorithm writer's salt).
> Now I am not sure if the filesystem should run an inkernel thread to do this profile management..
>
>> It might be more useful to allow user-land utilities to perform the re-
>> scanning.
>>
>> I would imagine that you will get unit attentions saying that REPORTED
>> LUNS DATA HAS CHANGED, but what other UNIT ATTENTIONS would you get?
>> If you add storage to a LUN, then perhaps CAPACITY DATA HAS CHANGED.
>>
>> Perhaps there is also a need to say things like, for these ASC/ASCQ
>> values, take the device off line, and all the rest are just advisory
>> but pass them all to user land as well.
>>
>
> This is a kind of policy that needs to go into the thin profile although Storage Arrays do take the device offline on reaching
> certain hard limits there is nothing like mounting a filesystem read-only ;-)

Well, yes, but Ext3/4 and XFS tend to remount the fs RO when writes to
the journal fail as well because the SCSI stack takes the device
offline :-(

If the device has lied in its response to a READ_CAPACITY or
READ_CAPACITY16 that is hard to prevent unless the file system has the
concept of a lying reserve ...

-- 
Regards,
Richard Sharpe
