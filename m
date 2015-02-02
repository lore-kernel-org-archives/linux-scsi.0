From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2] scsi: NCR5380: use msecs_to_jiffies for conversions
Date: Mon, 2 Feb 2015 08:47:28 +0100
Message-ID: <20150202074728.GA19647@opentech.at>
References: <1422692020-6607-1-git-send-email-der.herr@hofr.at> <alpine.LNX.2.00.1502010957150.30584@nippy.intranet> <d0a6819903df0864d2785bc209409cef@gmail.com> <20150201071412.GA21711@opentech.at> <CAOmrzkL=m2renZ0meMMtjhzUGUU0CfTX0AttZhEr4qY9mxuTiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:59536 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbbBBHra (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 02:47:30 -0500
Content-Disposition: inline
In-Reply-To: <CAOmrzkL=m2renZ0meMMtjhzUGUU0CfTX0AttZhEr4qY9mxuTiQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, ronald.van.cuijlenborg@tip.nl

On Mon, 02 Feb 2015, Michael Schmitz wrote:

> Hi Nicholas,
> 
> >> The values for USLEEP_* are taken to be in units jiffies, according to
> >> comments in NCR5380.c. Replacing them by the msecs_to_jiffies conversion
> >> is in fact wrong.
> >>
> >> Please drop the changes to g_NCR5380.c for that reason.
> >>
> >
> > right the comment indicates it should be jiffies - my interpretation
> > of that was that in NCR5380.c
> > were  jiffies + (250 * HZ / 1000); constructs would be correctly
> > converted to e.g. jiffies + msecs_to_jiffies(250)
> 
> No objection there.
> 
> > And defines like USLEEP_POLL are noted to be in jiffies:
> > * USLEEP_SLEEP - amount of time, in jiffies, to sleep
> >
> > and then defined correctly as HZ indepenedent values:
> > #define USLEEP_SLEEP (20*HZ/1000
> >
> > and thus should be the same as msecs_to_jiffies(20)
> 
> None here either.
> 
> >
> > now g_NCR5380.c defines
> > #define USLEEP_POLL     1
> > #define USLEEP_SLEEP    20
> > #define USLEEP_WAITLONG 500
> >
> > for the DTC3181E card - but without the conversion to ms
> > from the use in the code though (e.g NCR5380_set_timer) it
> > seemed to me that it actually should be jiffeis equivalent ms and
> 
> We can't know that - it's a fair guess, but the way it is currently
> defined will see these constants used as jiffies, not ms.
> 
> 'git blame' is of little help here ...
> 
> ^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  59) /*
> settings for DTC3181E card with only Mustek scanner attached */
> ^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  60) #define
> USLEEP_POLL 1
> ^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  61) #define
> USLEEP_SLEEP        20
> ^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700  62) #define
> USLEEP_WAITLONG     500
> 
> The DTC3181E part dates back to '97. Let's see whether Ronald stilll remembers.
> 
> HZ used to be set to 100 in those days, so USLEEP_POLL=1 equates to
> 10ms, not 1ms
>

ok - thats my ignorance - did not think that far - but it makes sense
to me now why the values would be correct without conversion. looking
at linux-2.0.31 (1998) your assumption looks correct

 #ifndef USLEEP_SLEEP
 /* 20 ms (reasonable hard disk speed) */
 #define USLEEP_SLEEP 2
 #endif
 /* 300 RPM (floppy speed) */
 #ifndef USLEEP_POLL
 #define USLEEP_POLL 20
 #endif                                                                          

in linux-2.2.16 this becomes

 #ifndef USLEEP_SLEEP
 /* 20 ms (reasonable hard disk speed) */
 #define USLEEP_SLEEP (20*HZ/1000)
 #endif
 /* 300 RPM (floppy speed) */
 #ifndef USLEEP_POLL
 #define USLEEP_POLL (200*HZ/1000)
 #endif

but no update for the DTC case that stays

 /* settings for DTC3181E card with only Mustek scanner attached */
 #define USLEEP 
 #define USLEEP_POLL     1
 #define USLEEP_SLEEP    20
 #define USLEEP_WAITLONG 500

so the original timing unit does seem to be 100HZ based and your 
conversion below seems to be the right one.

> > the intent was only to change the USLEEP_POLL and USLEEP_WAITLONG
> > settings for the specific device but not the unit and thus it
> > shuld have been converted by msecs_to_jiffies(1) resp.
> > msecs_to_jiffies(500). The problem with this if it is left in its
> > current form is that the timeouts would actually depend on the HZ
> > setting of the system which is probably not the intent.
> 
> I think it's safe to assume the code in question predates the option
> to configure the scheduling tick frequency, so yes, probably not
> intended.
> 
> The problem with your replacing jiffies by ms is that this will change
> the timing for this particular combination of hardware by an order of
> magnitude. That large a change in timing would need to be backed up by
> testing on the actual hardware.
> 
> Much safer to use
> 
> #define USLEEP_POLL    msecs_to_jiffies(10)
> #define USLEEP_SLEEP   msecs_to_jiffies(200)
> #define USLEEP_WAITLONG        msecs_to_jiffies(5000)
> 
> and make sure no change in timing is incurred at all.
>

well your solution definitely is the safer and from looking at
2.0.31 -> 2.2.16 likely the right one and it achieves the goal 
of HZ independent timing.

thanks - will clean it up accordingly

thx!
hofrat 
