From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2] scsi: NCR5380: use msecs_to_jiffies for conversions
Date: Mon, 2 Feb 2015 14:04:19 +1300
Message-ID: <CAOmrzkL=m2renZ0meMMtjhzUGUU0CfTX0AttZhEr4qY9mxuTiQ@mail.gmail.com>
References: <1422692020-6607-1-git-send-email-der.herr@hofr.at>
	<alpine.LNX.2.00.1502010957150.30584@nippy.intranet>
	<d0a6819903df0864d2785bc209409cef@gmail.com>
	<20150201071412.GA21711@opentech.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:38358 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbBBBEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2015 20:04:20 -0500
Received: by mail-qg0-f48.google.com with SMTP id z60so45489661qgd.7
        for <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2015 17:04:19 -0800 (PST)
In-Reply-To: <20150201071412.GA21711@opentech.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, ronald.van.cuijlenborg@tip.nl

Hi Nicholas,

>> The values for USLEEP_* are taken to be in units jiffies, according to
>> comments in NCR5380.c. Replacing them by the msecs_to_jiffies conversion
>> is in fact wrong.
>>
>> Please drop the changes to g_NCR5380.c for that reason.
>>
>
> right the comment indicates it should be jiffies - my interpretation
> of that was that in NCR5380.c
> were  jiffies + (250 * HZ / 1000); constructs would be correctly
> converted to e.g. jiffies + msecs_to_jiffies(250)

No objection there.

> And defines like USLEEP_POLL are noted to be in jiffies:
> * USLEEP_SLEEP - amount of time, in jiffies, to sleep
>
> and then defined correctly as HZ indepenedent values:
> #define USLEEP_SLEEP (20*HZ/1000
>
> and thus should be the same as msecs_to_jiffies(20)

None here either.

>
> now g_NCR5380.c defines
> #define USLEEP_POLL     1
> #define USLEEP_SLEEP    20
> #define USLEEP_WAITLONG 500
>
> for the DTC3181E card - but without the conversion to ms
> from the use in the code though (e.g NCR5380_set_timer) it
> seemed to me that it actually should be jiffeis equivalent ms and

We can't know that - it's a fair guess, but the way it is currently
defined will see these constants used as jiffies, not ms.

'git blame' is of little help here ...

^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  59) /*
settings for DTC3181E card with only Mustek scanner attached */
^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  60) #define
USLEEP_POLL 1
^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  61) #define
USLEEP_SLEEP        20
^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  62) #define
USLEEP_WAITLONG     500

The DTC3181E part dates back to '97. Let's see whether Ronald stilll remembers.

HZ used to be set to 100 in those days, so USLEEP_POLL=1 equates to
10ms, not 1ms

> the intent was only to change the USLEEP_POLL and USLEEP_WAITLONG
> settings for the specific device but not the unit and thus it
> shuld have been converted by msecs_to_jiffies(1) resp.
> msecs_to_jiffies(500). The problem with this if it is left in its
> current form is that the timeouts would actually depend on the HZ
> setting of the system which is probably not the intent.

I think it's safe to assume the code in question predates the option
to configure the scheduling tick frequency, so yes, probably not
intended.

The problem with your replacing jiffies by ms is that this will change
the timing for this particular combination of hardware by an order of
magnitude. That large a change in timing would need to be backed up by
testing on the actual hardware.

Much safer to use

#define USLEEP_POLL    msecs_to_jiffies(10)
#define USLEEP_SLEEP   msecs_to_jiffies(200)
#define USLEEP_WAITLONG        msecs_to_jiffies(5000)

and make sure no change in timing is incurred at all.

Cheers,

  Michael


>
> Pleas do give this one more look if the argument above is
> not sound I appologize for the noise.
>
> thx!
> hofrat
