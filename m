From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Wed, 14 Oct 2009 16:29:51 -0700
Message-ID: <da824cf30910141629m1c30521ftd6ee2ed9970a0edb@mail.gmail.com>
References: <2f83750a0910141408m44082639m13cb0bfdb5cbd5cb@mail.gmail.com>
	 <2f83750a0910141413s58df3658k5ed170541e637f1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:39436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZJNXbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 19:31:04 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n9ENTtu9027499
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 16:29:56 -0700
Received: from pxi39 (pxi39.prod.google.com [10.243.27.39])
	by wpaz21.hot.corp.google.com with ESMTP id n9ENTqUS021429
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 16:29:52 -0700
Received: by pxi39 with SMTP id 39so255847pxi.10
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 16:29:52 -0700 (PDT)
In-Reply-To: <2f83750a0910141413s58df3658k5ed170541e637f1e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 14, 2009 at 2:13 PM, Clemens Fruhwirth
<clemens@endorphin.org> wrote:
> Hi everyone,
>
> Short: Attached is an incomplete patch that allows user space to forc=
e
> the capacity of an scsi device to a specific value. Any not over
> my-dead-body objections with that?

No major objection - just the usual nits:
Why not make /sys/block/sdX/size writeable?
    (instead of adding an ioctl())

grundler@parisc:~$ cat /sys/block/sda/size
976773168
grundler@parisc:~$ ls -l /sys/block/sda/size
-r--r--r-- 1 root root 4096 Oct 14 16:14 /sys/block/sda/size


After reading the wiki page[1], my impression is that the block size
gets reported wrong and thus the total capacity is miscalculated for
1GB-4GB SD cards with 1024 or 2048 byte blocks. Two questions around th=
is:
a) Does the host need to know the correct block size for correct operat=
ion?
b) Do the devices report which SD Card Association spec they are compli=
ant
   with in the USB headers?

I'm asking (b) to start the conversation about if it's feasible to
auto-detect this in the kernel and spare all the distro's from having
to frob the device size.

If we can autodetect this case, *and* the device has a valid FAT
partition, it should be trivial
to use the FAT partition info instead of what the USB card reader is
reporting. Partitioning
a new card will probably still need "size" to be writable.

hth,
grant

> Long: I was unfortunate and grabbed one of the cheaper USB SD card
> readers that do not correctly detect >1GB capacity sd cards. This is =
a
> known and common bug. See [1] or [2]. What's interesting is that this
> card reader was sold to work with these cards explicitly, and I
> figured it must have been tested only under Windows, which we all kno=
w
> believes in the partition table more strongly than in what the device
> reports. And indeed, my 2GB sd cards start to work if I simply ignore
> the capacity reported by the device. I have been using this
> successfully in the last half year with all my sd cards and now I'm
> tired of patching the kernel for just that thing. Could you imagine t=
o
> merge that upstream? I doubt that any device will kill itself if this
> interface is used incorrectly.
>
> A simple user space program using the new interface is available at [=
3].
>
> Please CC, me not on list.
> [1]=C2=A0http://en.wikipedia.org/wiki/Secure_Digital#Standard-SD_card=
s_.28non-SDHC.29_with_greater_than_1_GB_capacity
> [2]=C2=A0http://www.hjreggel.net/cardspeed/special-sd.html
> [3]=C2=A0http://blog.clemens.endorphin.org/2009/03/patching-for-broke=
n-sd-card-readers.html

thanks,
grant

> --
> Fruhwirth Clemens http://clemens.endorphin.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
