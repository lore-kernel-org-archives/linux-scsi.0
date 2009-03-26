From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Thu, 26 Mar 2009 18:25:25 +0100
Message-ID: <ac3eb2510903261025y5cacc8a3i32ba8ee8896c9db9@mail.gmail.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com>
	 <20090325190137.GA8509@infradead.org>
	 <20090325190321.GB25176@nostromo.devel.redhat.com>
	 <20090325192653.GS14127@parisc-linux.org>
	 <20090325194756.GA26465@nostromo.devel.redhat.com>
	 <20090325203624.GT14127@parisc-linux.org>
	 <20090326144716.GA5696@nostromo.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42237 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbZCZRZ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 13:25:28 -0400
In-Reply-To: <20090326144716.GA5696@nostromo.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pjones@redhat.com

On Thu, Mar 26, 2009 at 15:47, Bill Nottingham <notting@redhat.com> wrote:
> Matthew Wilcox (matthew@wil.cx) said:

>> > Well, in the case I'm looking at, udev is what's loading the host
>> > controllers, and there needs to be some sort of synchronization point
>> > between that and LVM invocations, fsck, mount, etc. Since scans
>> > aren't sent over as events for udev to catch, 'udevadm settle'
>> > isn't enough.
>>
>> So ... if we sent a udev event when the scan list was empty, you'd be OK?
>
> I'm CC'ing Peter, who has some more ideas - it would definitely be a good
> start, but we'd probably at least need to know when the scan list started
> being filled as well.

I don't like to see any uevent send for issues like this. This would
just be a hack around badly designed system services, which should be
fixed themselves and not worked around in the kernel. This hack will
run useless events for system who don't need them.

Something like a poll()'able sysfs file, which other subsytems already
use, and which can be used to wake up a process that can blocks, might
work fine here.

Thanks,
Kay
