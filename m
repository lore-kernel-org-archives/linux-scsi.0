From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RESEND] scsi: ips: fix firmware timestamps for 32-bit
Date: Thu, 18 Jan 2018 14:40:13 +0100
Message-ID: <CAK8P3a3u=mKsNUBf3fh7FQ2CqWUjWeuKD5DPhpsMEdBX0AGE2g@mail.gmail.com>
References: <20180117145749.2712957-1-arnd@arndb.de> <alpine.LNX.2.21.1801182000330.3@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:43637 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756283AbeARNkP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jan 2018 08:40:15 -0500
In-Reply-To: <alpine.LNX.2.21.1801182000330.3@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Yang Hongyang <yanghy@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Jan 18, 2018 at 10:35 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Wed, 17 Jan 2018, Arnd Bergmann wrote:
>
>> do_gettimeofday() is deprecated since it will stop working in 2038 on
>> 32-bit platforms. The firmware interface here actually supports times
>> until year 25500, so we should use longer timestamps.
>>
>
> I think that reasoning is flawed. If the firmware supports large year
> values, then fine. The firmware interface is another story.
>
> If you are simply trying to get rid of the old API, I think you should
> just say that.

It's both: I have no reason to believe that the firmware breaks in
2038. We can't know the range of the supported centuries, so it
could break in e.g. 2099, 9999, or 25599 (I should have written
that last number instead of 25500), but we know what the interface
supports, and if the firmware breaks earlier, then it can be fixed
while keeping that interface.

In particular, 64-bit architectures work fine already for as long as
the firmware supports, it's only 32-bit architectures that break
early.

I'll try to explain that better in the changelog.

>>  /****************************************************************************/
>>  static void
>> -ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time_t current_time)
>> +ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time64_t current_time)
>
> Does this conversion assume that current_time is always positive? I don't
> have a problem with that (the existing code seems to fail otherwise) but
> maybe it should be mentioned in the commit log.

current_time can never be negative, the kernel probably won't even boot
if that were the case, as too many things rely on a positive time. The resulting
numbers in ips_fix_ffdc_time() shouldn't change as far as I can tell (except the
bug you found below).

>> -     year = IPS_EPOCH_YEAR;
>> -     while (days < 0 || days >= year_lengths[yleap = IPS_IS_LEAP_YEAR(year)]) {
>> -             int newy;
>> -
>> -             newy = year + (days / IPS_DAYS_NORMAL_YEAR);
>> -             if (days < 0)
>> -                     --newy;
>> -             days -= (newy - year) * IPS_DAYS_NORMAL_YEAR +
>> -                 IPS_NUM_LEAP_YEARS_THROUGH(newy - 1) -
>> -                 IPS_NUM_LEAP_YEARS_THROUGH(year - 1);
>
> These IPS_ time macros are all unused after this patch except
> IPS_SECS_8HOURS so the definitions should probably be removed.

Ok, will do.

>> -             year = newy;
>> -     }
>> -
>> -     scb->cmd.ffdc.yearH = year / 100;
>> -     scb->cmd.ffdc.yearL = year % 100;
>> -
>> -     for (i = 0; days >= month_lengths[i][yleap]; ++i)
>> -             days -= month_lengths[i][yleap];
>> +     time64_to_tm(current_time, 0, &tm);
>>
>> -     scb->cmd.ffdc.month = i + 1;
>> -     scb->cmd.ffdc.day = days + 1;
>> +     scb->cmd.ffdc.hour   = tm.tm_hour;
>> +     scb->cmd.ffdc.minute = tm.tm_min;
>> +     scb->cmd.ffdc.second = tm.tm_sec;
>> +     scb->cmd.ffdc.yearH  = tm.tm_year / 100 + 1900;
>
> That looks wrong to me. If tm_year is in units of years not centuries,
> shouldn't that be,

Good catch, thanks for the review!

      Arnd
