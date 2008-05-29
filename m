From: "Gerb Stralko" <gerb.stralko@gmail.com>
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Date: Thu, 29 May 2008 10:35:08 -0400
Message-ID: <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
	 <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
	 <1212069932.3428.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.243]:44131 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbYE2OfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2008 10:35:12 -0400
Received: by hs-out-0708.google.com with SMTP id 4so2447501hsl.5
        for <linux-scsi@vger.kernel.org>; Thu, 29 May 2008 07:35:09 -0700 (PDT)
In-Reply-To: <1212069932.3428.1.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, May 29, 2008 at 10:05 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2008-05-29 at 00:41 -0700, Andrew Morton wrote:
>> On Tue, 27 May 2008 15:02:43 -0400 (EDT) Jerry Stralko <gerb.stralko@gmail.com> wrote:
>>
>> > Hello,
>>
>> let's cc a scsi list which exists ;)
>>
>> >    This printk was spamming my dmesg and /var/log/message.  Is there a
>> > reason we have this printk?  Can we simply remove it?
>> >
>> >
>> > Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
>> > ---
>> >
>> >
>> > diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
>> > index ae87d08..c37fb1c 100644
>> > --- a/drivers/scsi/sr_ioctl.c
>> > +++ b/drivers/scsi/sr_ioctl.c
>> > @@ -238,8 +238,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
>> >                                     break;
>> >                             }
>> >                     }
>> > -                   if (!cgc->quiet)
>> > -                           printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
>> >   #ifdef DEBUG
>> >                     scsi_print_sense_hdr("sr", &sshdr);
>> >   #endif
>>
>> The answer may be that you need to enable cgc->quiet.  If that is
>> user-enableable - I can't work out how from a quick grep.
>
> That's correct.  cgc is the data from the packet command that was sent
> in from the ioctl.  The user application is actually the one that
> decides whether you get to see the message or not.  Modern apps like hal
> set it because they take care of all state updates and notifications
> themselves.  Which is the application that's doing this (because it
> probably needs updating).
>
> James

So is that printk really needed?  Should the kernel even need to print
a message like that, esp. if user-space is handling state updates and
notifications.  Or do i need to configure hald to be quietier?   FWIW
I'm using fedora core 9 and hald version:
-bash-3.2$ /usr/sbin/hald --version
HAL package version: 0.5.11

thanks,

Jerry
