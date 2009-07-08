From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Wed, 8 Jul 2009 20:22:51 +0200
Message-ID: <8db1092f0907081122l7152e8bcyf2fd73d1386f6ac6@mail.gmail.com>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
	 <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	 <1247063244.4159.40.camel@mulgrave.site>
	 <1247069178.5973.6.camel@desktop>
	 <1247071445.4159.214.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:53271 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZGHSWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 14:22:54 -0400
In-Reply-To: <1247071445.4159.214.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Andrew Morton <akpm@linux-foundation.org>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

2009/7/8 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Wed, 2009-07-08 at 09:06 -0700, Daniel Walker wrote:
>> On Wed, 2009-07-08 at 09:27 -0500, James Bottomley wrote:
>> >
>> > You might also try this patch from martin petersen: =C2=A0it will =
print out
>> > the actual command that's causing the problems ... that might give=
 a
>> > clue.
>> >
>> > James
>>
>> On the bugzilla entry ,
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D13727
>>
>> Thomas Meyer indicated it was (possibly) the following commit,
>>
>> 018e0446890661504783f92388ecce7138c1566d
>>
>> I added Jens to the CC ..
>
> So thats:
>
> commit 018e0446890661504783f92388ecce7138c1566d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date: =C2=A0 Fri Jun 26 16:27:10 2009 +0200
>
> =C2=A0 =C2=A0block: get rid of queue-private command filter
>
> What this tends to suggest is that the command filter was blocking so=
me
> type of command sent from user space which is causing the problem, an=
d
> now we're letting it through. =C2=A0Restoring the command filter will=
 work
> around the problem, but the root cause should be finding and fixing
> whatever is issuing the commands in the first place.
>
> James
>
>
>

Confirm. I find some time, and do bisection:
018e0446890661504783f92388ecce7138c1566d is first bad commit
commit 018e0446890661504783f92388ecce7138c1566d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jun 26 16:27:10 2009 +0200

    block: get rid of queue-private command filter

    The initial patches to support this through sysfs export were broke=
n
    and have been if 0'ed out in any release. So lets just kill the cod=
e
    and reclaim some space in struct request_queue, if anyone would lat=
er
    like to fixup the sysfs bits, the git history can easily restore
    the removed bits.

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

:040000 040000 aaaec08cd15fe376286ef07b90eddb60f7dc98a1
5cc15daa4a596dcb97300baf7828e78ceeb40d5e M      block
:040000 040000 f1fbb94e7136c18e0df7d967800073a98901d51d
0d0a6e6e360b75daf9dc673a5ef0b7d745d5718e M      drivers
:040000 040000 e56a6498a1ca54adce4972cc2fe092a6e054165f
1c1e974e56532151cf0c98bfeb1ff05971e5b2c1 M      include

I revert this commit and in -rc2 k3b can see dvd drive. (some
explanation: I have little different problem; k3b can't see/detect DVD
drive).



Regards
--=20
Maciej Rutecki
http://www.maciek.unixy.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
