From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Thu, 03 Nov 2011 13:13:16 -0400
Message-ID: <4EB2CBAC.70003@interlog.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com> <1320126812.7701.17.camel@dabdike> <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com> <4EB0992C.5070309@gmail.com> <CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com> <CAOS58YOVC-dknjK50LHTjMOFFdM3KNyWzRPs8Ru2YRau4QQBWw@mail.gmail.com> <4EB2B468.9010001@interlog.com> <CAOS58YM2rwwaqEBDEHdBy_Mo_3FJsJUsHmdBM=T4hyApmKuOuA@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOS58YM2rwwaqEBDEHdBy_Mo_3FJsJUsHmdBM=T4hyApmKuOuA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: JiSheng Zhang <jszhang3@gmail.com>, Robert Hancock <hancockrwd@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11-11-03 11:46 AM, Tejun Heo wrote:
> On Thu, Nov 3, 2011 at 8:34 AM, Douglas Gilbert<dgilbert@interlog.com>  wrote:
>> That's a pretty poor attitude. I suspect Microsoft care. If so they
>> would be transitioning away from TEST UNIT READY to REQUEST SENSE
>> to monitor power conditions and the progress indication.
>
> I was talking about media presence polling.  We used to include TUR in
> the sequence and there have been some number of devices which worked
> fine for a while but lock up eventually.  Windows only issues
> CHECK_MEDIA_EVENT_STATUS so nobody has tested extended TUR cycles and

Do you mean the GET EVENT STATUS NOTIFICATION command (as there is
no CHECK MEDIA EVENT STATUS command in SCSI or ATA)? If so it is
one of the "good guys" along with the REQUEST SENSE command. And
as I said TUR is not recommended. So looking at MS usage _and_
the standards is a useful guide.


BTW The REQUEST SENSE implemented in the libata's SAT layer is
completely broken (and has been since day one). Is anyone planning
to fix it? An LSI SAS HBA with recent firmware and accessing a
SATA disk is a pretty good example of what a compliant SAT layer
looks like.

> nobody is fixing an optical drive EOL'd six months ago either, so what
> I or you think or feel doesn't matter in the end.  The most important
> thing is we provide drivers which allow proper operation and, sadly,
> at this point, the best way to get there is following what windows
> does.  It's not like we lose any functionality that way anyway.
>
> If windows isn't spinning down the drive, it is highly unlikely that
> missing that harms anything and it's highly like there are a bunch of
> devices which would go "uh... what the hell is this? I don't know
> this. osidfjalekjalkgjs".  So, there simply is no point at all.

I agree. SCSI and ATA define idle states (with some fuzziness in
the naming) that have timers associated with them. Those
mechanisms seem to work pretty well without the intervention of
commands like START STOP UNIT.

Doug Gilbert

