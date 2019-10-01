Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D59C32792
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81DD2075C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfJACm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 22:42:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38813 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfJACm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Sep 2019 22:42:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D2FEB2041AF;
        Tue,  1 Oct 2019 04:42:53 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id El6pTm386Ehe; Tue,  1 Oct 2019 04:42:46 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 65D16204157;
        Tue,  1 Oct 2019 04:42:45 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2] scsi_debug: randomize command duration option + %p
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de
References: <20190927140425.18958-1-dgilbert@interlog.com>
 <743e705b-1314-c8cb-1a75-acc5029ee890@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <74305c57-1d8e-5829-9bcf-db02fc97a7fb@interlog.com>
Date:   Mon, 30 Sep 2019 22:42:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <743e705b-1314-c8cb-1a75-acc5029ee890@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-30 11:46 a.m., Bart Van Assche wrote:
> On 9/27/19 7:04 AM, Douglas Gilbert wrote:
>> Add an option to use the given command delay (in nanoseconds)
>> as the upper limit for command durations. A pseudo random
>> number generator chooses each duration from the range:
>>        [0..delay_in_ns)
>>
>> Main benefit: allows testing with out-of-order responses.
> 
> Please clarify which code you want to test. I think out-of-order response 
> handling in the SCSI core and block layer core is already being triggered by 
> many storage workloads.

Short answer: in the current scsi_debug driver all responses arrive in
submission order. So there is a large class of errors that it won't find.


Longer answer:
Core dumps and log messages often occur well after the misstep in the code
that caused them.

In my case, I was looking for a bug in the sg driver associated with
request sharing for a disk to disk copy (reference:
http://sg.danny.cz/sg/sg_v40.html Figure 6). I ran the sg app (sgh_dd)
for several weeks tweaking this and that without any sign of failure.
However if I ran it using real SSDs then the error would occur but at
such a low frequency (say once per day) it was difficult to isolate.
I suspected the error occurred when at least one response arrived out
of submission order. Hence the patch presented here. In a relatively
short period of time (say between several seconds and several minutes)
the error occurred with 'ndelay=20000 random=1". This allowed me to
work back and find the faulty state transition.

So I assumed this technique might be more generally useful for those who
test with scsi_debug.

> 
>> @@ -4354,9 +4357,21 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct 
>> sdebug_dev_info *devip,
>>           ktime_t kt;
>>           if (delta_jiff > 0) {
>> -            kt = ns_to_ktime((u64)delta_jiff * (NSEC_PER_SEC / HZ));
>> -        } else
>> -            kt = ndelay;
>> +            u64 ns = (u64)delta_jiff * (NSEC_PER_SEC / HZ);
> 
> Has it been considered to use jiffies_to_nsecs() instead of open-coding that 
> function?

I'll look into it.

>> +            if (sdebug_random && ns < U32_MAX) {
>> +                ns = prandom_u32_max((u32)ns);
>> +            } else if (sdebug_random) {
>> +                ns >>= 10;    /* divide by 1024 */
>> +                if (ns < U32_MAX)  /* an hour and a bit */
>> +                    ns = prandom_u32_max((u32)ns);
>> +                ns <<= 10;
>> +            }
>> +            kt = ns_to_ktime(ns);
> 
> Is it really necessary to use nanosecond resolution? Can the above code be 
> simplified by using microseconds as time unit instead of nanoseconds?

The driver follows kernel conventions and does time keeping in either
milliseconds or nanoseconds. A minor disadvantage of nanosecond timekeeping
and 32 bit integers (e.g. as used by the sg driver for duration) is that
the largest duration it can represent is around 4.2 seconds. If one is
simulating READs and WRITEs on a SSD then 4 seconds is more than enough
but not for FORMAT UNIT. Hence the code above. This problem doesn't
completely disappear with microsecond resolution as its 32 bit maximum
(~ 4200 seconds) may still be too low for simulating FORMAT UNIT.

While I agree that microsecond precision is sufficient for logs ***
I find it useful to look at nanosecond precision when debugging the sg
and scsi_debug drivers. Arnd Bergmann warned me that there is a (slight)
time penalty when reading the high precision counters on some
architectures. That is why there are "_coarse_" variants in some of
the timekeeping headers.

>> +MODULE_PARM_DESC(random, "1-> command duration chosen from [0..delay_in_ns) 
>> (def=0)");
> 
> Would this description become more clear if it would be changed into something 
> like the following: "If set, uniformly randomize command duration between 0 and 
> delay_in_ns" ?

checkpatch.pl seems inconsistent when strings violate the Fortran punch card
line length limit. Sometimes checkpatch complains and sometimes it follows
the kernel coding standards and doesn't complain. It complained about my
original effort, so I abridged it.
Yes, your suggestion is clearer (and longer).

>> +static ssize_t random_show(struct device_driver *ddp, char *buf)
>> +{
>> +    return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_random ? 1 : 0);
>> +}
> 
> Since sdebug_random is either 0 or 1, is the "? 1 : 0" part necessary?

No.
Why didn't you complain when MKP wrote that? That is where I cut and
pasted that code from (sdebug_removable).

>> +static ssize_t random_store(struct device_driver *ddp, const char *buf,
>> +                size_t count)
>> +{
>> +    int n;
>> +
>> +    if (count > 0 && 1 == sscanf(buf, "%d", &n) && n >= 0) {
>> +        sdebug_random = (n > 0);
>> +        return count;
>> +    }
>> +    return -EINVAL;
>> +}
> 
> Has this patch been verified with checkpatch? I'm asking since checkpatch should 
> complain about "1 == sscanf(...)". See also commit c5595fa2f1ce ("checkpatch: 
> add constant comparison on left side test").

Yes. And it complained, but not about that :-)
Again, copy and paste from MKP's code (which no doubt was a copy + paste from
my earlier code).

>> @@ -5338,7 +5373,7 @@ static int __init scsi_debug_init(void)
>>           dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
>>           dif_storep = vmalloc(dif_size);
>> -        pr_err("dif_storep %u bytes @ %p\n", dif_size, dif_storep);
>> +        pr_err("dif_storep %u bytes @ %pK\n", dif_size, dif_storep);
>>           if (dif_storep == NULL) {
>>               pr_err("out of mem. (DIX)\n");
> 
> Is it useful to print the kernel pointer 'dif_storep'?

Ask MKP, it's his code. All I do know is that doing a printk("%p" ...) is
useless in lk 5.3 (and probably lk 5.2). Taking the above snippet, if
vmalloc() returned NULL then the existing pr_err() would print out
a random number rather than <null>. Sick ...

Thanks
Doug Gilbert


*** If anyone wants microsecond in syslog and friends, comment out this line:

	$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

     in /etc/sysctl.conf . Obvious, isn't it ....

