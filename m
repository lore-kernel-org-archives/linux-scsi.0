From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Mon, 7 Feb 2011 21:00:49 -0500
Message-ID: <AANLkTimm-MC6kNGRgvFvrPh+YGTW5M6MPLrEd3C9K4vC@mail.gmail.com>
References: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59273 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab1BHCAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 21:00:49 -0500
Received: by iwn9 with SMTP id 9so5255693iwn.19
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2011 18:00:49 -0800 (PST)
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@dell.com
Cc: lsf-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org, hare@suse.de

On Sun, Feb 6, 2011 at 5:32 PM,  <Shyam_Iyer@dell.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Richard Sharpe
>> Sent: Sunday, February 06, 2011 3:44 PM
>> To: lsf-pc@lists.linuxfoundation.org; linux-scsi; Hannes Reinecke
>> Subject: [LSF/MM Topic] SCSI Unit Attention Handling
>>
>> I would like to propose a topic around SCSI Unit Attention Handling.
>>
>> The current scsi_error.c:scsi_check_sense handling of UNIT ATTENTION
>> consists of explicitly printing warnings for for ASC=0x3f events and
>> then returning SOFT_ERROR which scsi_error.c:scsi_decide_disposition
>> ignores because it returns SUCCESS to SOFT_ERROR being returned from
>> scst_check_sense on a CHECK_CONDITION.
>>
>> There are a number of cases where we might want to perform further
>> processing on a UNIT ATTENTION. For example, ASC/ASCQ 0x3f/0x0e
>> REPORTED LUNS DATA HAS CHANGED or 0x2a/0x09 CAPACITY DATA HAS CHANGED,
>> 0x28/0x03 IMPORT/EXPORT ELEMENT ACCESSED, MEDIUM CHANGED, etc. When
>> the LUNS have changed it would be useful to have a recan performed
>> automatically. If capacity data has changed, it would be useful if
>> someone could react to that and perhaps resize the file system on that
>> LUN if possible, and so forth.
>>
>> It is not clear that any of these items should be handled in the
>> kernel anyway, and perhaps they should be exported to user-space for
>> correct handling, but rather than just the raw SENSE data being
>> exported, perhaps some sort of relevant event should be exported.
>>
> We spoke about this in the plumbers conf last November as well and the few ideas then was to handle them via scsi netlink.
> I see that Hannes is working on a relayfs method to handle them.
>
> Some of the new problems that we can see with handling such events are -
>
> If the thin provisioned LUN is snapshotted or cloned then you can also get a flurry of UNIT attentions for the same data
> that has been replicated.

So, I wonder if adding just the ability for SCSI upper drivers (sd,
st, etc) to register interest in different UNIT ATTENTIONS is all that
interesting and whether vendors would rather have the ability to tell
drivers (via an ioctl, say) the UNIT ATTENTIONS they are interested
in, and how they should be mapped.

It might be more useful to allow user-land utilities to perform the re-scanning.

I would imagine that you will get unit attentions saying that REPORTED
LUNS DATA HAS CHANGED, but what other UNIT ATTENTIONS would you get?
If you add storage to a LUN, then perhaps CAPACITY DATA HAS CHANGED.

Perhaps there is also a need to say things like, for these ASC/ASCQ
values, take the device off line, and all the rest are just advisory
but pass them all to user land as well.

-- 
Regards,
Richard Sharpe
