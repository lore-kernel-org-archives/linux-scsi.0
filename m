From: Robert Trace <maillist@farcaster.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Mon, 09 Jul 2012 21:51:02 -0400
Message-ID: <4FFB8A86.7000009@farcaster.org>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eris.farcaster.org ([75.127.72.104]:42472 "EHLO
	smtp.farcaster.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJBvG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2012 21:51:06 -0400
In-Reply-To: <4FFB7354.8040809@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: linux-scsi@vger.kernel.org

[removed linux-raid since the md layer seems unrelated]

On 07/09/2012 08:12 PM, Matthias Prager wrote:
>>
>> I've reproduced this behavior on the raw disks themselves, no MD layer
>> involved (although the freak-out by my MD layer is what alerted me to
>> this issue too... Having your entire array punted the first time you
>> access it is a little scary :-).  I'm also on raw hardware and I've seen
>> this behavior on kernels 3.0.33 through 3.4.4.
> This is interesting - are you sure about 3.0.33? I'm running this kernel
> atm for it gives me no trouble (as opposed to >=3.1.10). The SATA disks
> are spun up when I access data on them.

Huh..  I just retested this and I'm seeing really random behavior.

I tried 3.0.33 a few days ago after I saw your initial e-mail to this
list.  At that time, the one disk I tried didn't wake up when I sent I/O
to it.

My first retest (just now), on 3.0.33 with four disks, showed the
behavior you initially reported.  Two of the disks woke up from the I/O,
but not all of them.

Repeating the test without rebooting made two disks wake up, but only
one of the same disks from the first test.  The second disk that woke up
was different.

After rebooting and running the test again, none of the disks woke up.

Rebooting again and all of the disks are waking up.

(FYI, here's the test I ran:

1.  hdparm -y /dev/sd[lmjk]
2.  hdparm -C /dev/sd[lmjk] (to verify disks in standby)
3.  for i in l m j k; do sg_turs -v /dev/sd${i}; done
(All disks reported "Not Ready")
4.  echo 3 > /proc/sys/vm/drop_caches
5.  for i in l m j k; do dd if=/dev/sd${i} of=/dev/null bs=512 count=1
skip=<number>; done

I've been manually changing the skip=<number> because I've seen the dd
command complete successfully without the disk waking up.  I think this
is because the disk is satisfying the read from its own cache.  Changing
where on the disk I'm reading should thwart this.
)

I'm confused.  I'll try more recent kernels again and see if the
behavior becomes predictable.

-- Rob
