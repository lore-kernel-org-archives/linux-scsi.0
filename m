From: Prashant <0xfffff0@gmail.com>
Subject: Re: spinlock recursion in scsi_end_request() (kernel 2.6.24)
Date: Fri, 21 May 2010 20:49:34 +0530
Message-ID: <AANLkTimKlgni60tU66rPru1FnQIYS72oL65QPs7DenYX@mail.gmail.com>
References: <AANLkTilIYz-UITAugWx08u-AvKB5gI-E1M3LORZ55wro@mail.gmail.com>
	 <4BF508C8.9050405@kernel.org>
	 <AANLkTilPaI-b4IUNfUnVKahK299fujgYTXsxC1BROw0L@mail.gmail.com>
	 <4BF54FAF.6020104@kernel.org> <1274369381.4458.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35613 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0EUPTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2010 11:19:37 -0400
Received: by pva18 with SMTP id 18so79387pva.19
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2010 08:19:35 -0700 (PDT)
In-Reply-To: <1274369381.4458.2.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org

On Thu, May 20, 2010 at 8:59 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Thu, 2010-05-20 at 17:05 +0200, Tejun Heo wrote:
>> Hello,
>>
>> On 05/20/2010 01:33 PM, Prashant wrote:
>> > I have a question related to code which is almost same in the
>> > current kernel. =A0I don't know whether this is the right mailing =
list
>> > for the following question.
>>
>> linux-scsi would probably fit better (cc'd).
>>
>> > When a sata drive is unplugged, its corresponding sdev's state is =
set
>> > to SDEV_OFFLINE. Now if IO requests are still comming on the same =
device,
>> > They will be killed by calling scsi_kill_request().
>> >
>> > 1) scsi_kill_request does following things:
>> > =A0 =A0 i) Unlock request queue
>> > =A0 =A0 ii) Increment host_busy count
>> > =A0 =A0 iii) Lock request queue
>> > =A0 =A0 iv) Calls __scsi_done()
>> >
>> > 2) __scsi_done() does following things:
>> > =A0 =A0 =A0i) set request completion data
>> > =A0 =A0 =A0ii) Calls blk_completion_request()
>> >
>> > 3) blk_completion_request() does following things:
>> > =A0 =A0 =A0i) Adds request->donelist to blk_cpu_done softirq queue
>> > =A0 =A0 =A0 =A0 and raise the softirq (which is scsi_softirq_done)
>> >
>> > 4) next sequence is:
>> > =A0 =A0 scsi_softirq_done >> scsi_finish_command >> scsi_device_un=
busy()
>> >
>> > 5) scsi_device_unbusy() again locks the request_queue. This is the=
 place where
>> > =A0 =A0 we can get into the spinlock recursion.
>> >
>> > =A0 =A0 Is this correct? Please correct me if something is wrong.
>>
>> Raising softirq defers the work to another context and grabbing the
>> same lock from softirq handler doesn't constitute a recursive lockin=
g.
>> Please try to reproduce the problem on recent kernel w/ lockdep
>> enabled.
>
> Just to confirm what Tejun says: the design of the cmd -> done (i.e.
> scsi_done) going through the block sofirq handler is specifically so =
it
> can be called either locked or unlocked, so this can never be a
> recursion.
>
> James
>
Thanks for the explanation. I will let you know if this problem is repr=
oduced
with the latest kernel.

Thanks,
Prashant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
