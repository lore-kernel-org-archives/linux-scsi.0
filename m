From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
 device
Date: Wed, 30 Sep 2015 13:35:54 +0300
Message-ID: <560BBB0A.3000300@gmail.com>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp> <560BAB2B.9050404@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33898 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbbI3Kf5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 06:35:57 -0400
Received: by wicfx3 with SMTP id fx3so190365033wic.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 03:35:56 -0700 (PDT)
In-Reply-To: <560BAB2B.9050404@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 09/30/2015 12:28 PM, Hannes Reinecke wrote:
<>
> Pushing things into the background is typically not the best of
> ideas; actually I've been running into issues with udev not being
> complete by the time the next round is started. So more often than
> not I would be greeted with messages:
> 
> 'write: no such file or directory'
> 
> when executing this line. Removing the '&' at the end made this
> warning go away.
> 
> And actually I'm not sure if the above script is a valid testcase;

So are you saying it is allowed to crash the Kernel with a crappy
script?

> from what I've seen there is no locking / reference counting when
> accessing sysfs attributes. So as soon as you _can_ access the sysfs
> attribute it is implicitly assumed to be valid.
> In your case you will be _removing_ the sysfs attribute even though
> it is still accessed, which of course will crash.
> 

Is that allowed? for usermode script to race and crash the Kernel?

>From the original email it sounds like this used to be fine and it
now crashes (with the &)

Thanks
Boaz

> Can you still reproduce this problem after removing the '&' in that
> line?
> 
>> 	echo "-- delete $dev --" > /dev/kmsg
>> 	echo 1 > /sys/class/scsi_device/${dev}/device/delete
>>
>> 	n=$((n + 1))
>> done
>> --- cut here --
> 
> Having said that I've retried your test script with my ALUA handler
> update, and didn't find any issues there.
> It happily completed about 500 rounds at which point I got bored.
> Of course, this is after removing the '&' in the said line.
> 
> Cheers,
> 
> Hannes
> 

