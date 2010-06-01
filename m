From: Leif Sawyer <ak.hepcat+scsi@gmail.com>
Subject: Re: Fwd: high volume of disk-writes causes disk to 'disappear'
Date: Tue, 1 Jun 2010 08:44:20 -0800
Message-ID: <AANLkTikamz7FVS-1t4LLvBDi9SMZ9BCVNEB3z9iJYKNL@mail.gmail.com>
References: <y2wd4bc8f581004191138ldab84bect8670755200e2c413@mail.gmail.com>
	<w2od4bc8f581004271446md75f0dcbt537956a2e3f9abb7@mail.gmail.com>
	<4BD99BFD.9090202@suse.de>
	<q2md4bc8f581004291011k43d5c03cpb7361473f6de4350@mail.gmail.com>
	<4BDAE41D.6030707@suse.de>
	<m2gd4bc8f581004301627jea793d0ax1e63bc3796458662@mail.gmail.com>
	<i2yd4bc8f581005031143r638b8037ra3778f97e6d2e25d@mail.gmail.com>
	<AANLkTik8917n0yNfc9Y6V9rbG7OOltt_SLcxEu8bzu20@mail.gmail.com>
	<AANLkTimjTiA9wIY_8ES_6hzowXKMVkNQOhg5VBxVu-ty@mail.gmail.com>
	<AANLkTin0XcxnGmyOXdpwW0ow-I61fJkOhWiYNIZ2soX2@mail.gmail.com>
	<AANLkTikvjQyo60XJThK_IZkbcKmF2wNcBFZ1FUUx87pZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56434 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0FAQoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 12:44:21 -0400
Received: by vws11 with SMTP id 11so1240099vws.19
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2010 09:44:21 -0700 (PDT)
In-Reply-To: <AANLkTikvjQyo60XJThK_IZkbcKmF2wNcBFZ1FUUx87pZ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, Hannes Reinecke <hare@suse.de>

Well, good thing I left it running longer.   It triggered multiple
times over the past week.

So I guess it's not fixed with the simple cleanup patches that had
been posted previously.

I really need some help with scsi debugging to get valid log data out
of this, in order
to isolate the issue.


-L

On Tue, May 25, 2010 at 2:58 PM, Leif Sawyer <ak.hepcat+scsi@gmail.com>=
 wrote:
> On Wed, May 19, 2010 at 5:23 AM, Leif Sawyer <ak.hepcat+scsi@gmail.co=
m> wrote:
>> looks like the 75% mark might have been too high of an estimate.
>> Whipped up a quick logger to show me when i was failing:
>>
>> <user.info<14>>May 18 17:08:01 websniff-6036a5 logger: disk: /data a=
t
>> 59% utilization
>> <user.info<14>>May 18 17:09:01 websniff-6036a5 logger: disk: /data a=
t
>> 59% utilization
>> <user.info<14>>May 18 17:10:01 websniff-6036a5 logger: disk: /data a=
t
>> 60% utilization
>> <user.info<14>>May 18 17:11:01 websniff-6036a5 logger: disk: /data a=
t
>> 60% utilization
>> [22563.204037] INFO: task flush-8:16:2430 blocked for more than 120 =
seconds.
>> [22563.224392] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [22563.248117] INFO: task dumpcap:4004 blocked for more than 120 sec=
onds.
>> [22563.267662] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [22563.291359] INFO: task df:14714 blocked for more than 120 seconds=
=2E
>> [22563.309874] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [22563.333593] INFO: task websniff.cgi:14717 blocked for more than 1=
20 seconds.
>> [22563.354690] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [22682.229526] end_request: I/O error, dev sdb, sector 169922743
>> [22682.247345] Buffer I/O error on device sdb1, logical block 212403=
35
>> [22682.266781] end_request: I/O error, dev sdb, sector 170131519
>> [22682.284445] Buffer I/O error on device sdb1, logical block 212664=
32
>> [....... repeats until......]
>> [22682.782577] sd 3:0:1:0: rejecting I/O to offline device
>> [22682.798907] sd 3:0:1:0: rejecting I/O to offline device
>>
>> And from here on out, the device is no longer recognized by the syst=
em
>> until a reboot.
>>
>> I need some help with scsi debugging in order to provide more useful
>> information.
>>
>> I do have a 512mb logfile (text) =A0with lots of scsi dump card stat=
e
>> logs and such, though.
>>
>
>
> Okay, so on a whim, I applied some patches that were recently posted
> here that I thought
> might have an impact on my particular system (anything generic scsi,
> or adaptec-related)
>
> My system has been up since yesterday with those patches applied, and=
 my disk
> has been churning at the 100% utilized (with between 600Mb and 75Mb
> free at any given time)
> with tshark continuously rolling over new capture files =A0for over 6=
h.
> (which it never did before)
>
> the following patches were applied which were not cosmetic or debug r=
elated:
>
> =A0 =A0 lct_data->tid assignment
> =A0 =A0 io_dev->iop assignment
> =A0 =A0 usg use after kfree
> =A0 =A0 gdth =A0goto out_free_ccb_phys =A0instead of =A0out_free_coal=
_stat
>
>
> If there's interest, i'll back out the patches one at a time and see
> which one(s)
> cause/bring-back the most instability.
>
>
>
> --
> "It's pronounced Layf...you know, like Leif Garrett? Don't you watch
> =A0'I Love the 70's'? What kind of retro lover are you, anyway?"
>



--=20
"It's pronounced Layf...you know, like Leif Garrett? Don't you watch
 'I Love the 70's'? What kind of retro lover are you, anyway?"
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
