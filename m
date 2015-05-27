From: yoma sophian <sophian.yoma@gmail.com>
Subject: Re: possible race condition for usb_stor_port_reset and usb_reset_and_verify_device
Date: Wed, 27 May 2015 20:41:08 +0800
Message-ID: <CADUS3o=3R27qA3pYMWur0qugTuwTZLrrCpaaNd7CYgkXbB9S8w@mail.gmail.com>
References: <CADUS3ok_63WuXBufTfnk1NeosmK7eT91k0vrAHZpWSjD5GqmHw@mail.gmail.com>
	<Pine.LNX.4.44L0.1505061406230.1133-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34877 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbbE0MlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2015 08:41:09 -0400
In-Reply-To: <Pine.LNX.4.44L0.1505061406230.1133-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, USB list <linux-usb@vger.kernel.org>

Hi alan:

2015-05-07 2:16 GMT+08:00 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 7 May 2015, yoma sophian wrote:
>
>> > Besides, the kernel already contains a thread that calls
>> > sd_check_events periodically.  Why do you need to write a new one?
>> I create the thread since some buggy devices needs to periodically
>> polling to let it not going to disconnection.
>> Would you mind to let me know which kernel thread that calls
>> sd_check_events periodically?
>
> There is not a dedicated thread.  Each block device has a workqueue
> item that runs on the system_freezable_power_efficient_wq work queue.
> For more information, see the "Disk events" section of block/genhd.c.
> In particular, look at the disk_check_events() routine.
>
> For a typical USB storage device, the system will poll for media
> changes by calling sd_check_events.
>
>> >> My questions are:
>> >> a. is there any system flag such suspend/resume in scsi layer for
>> >> checking before sending command to downlayer driver, such as usb.
>> >
>> > I don't know of any.  In general, the kernel is designed so that no
>> > SCSI commands will be sent while the system is in suspend or
>> > hibernation, so no checking is needed.
>> which flag or callback function we used to determine the system is in
>> suspend or hibernation?
>> udev->state?
>
> You don't use any flags or callbacks, and you don't determine when the
> system is in suspend or hibernation.  Instead you make your thread
> freezable, so that it will get frozen automatically whenever the system
> goes into suspend or hibernation.
>
After reading the kernel power document, freezing-of-tasks.txt , can I
get the below conclusion:
if I put my thread in freezable, it will get frozen automatically
whenever the system goes in to suspend or hibernate.
And automatically be waked up when all other thread finish their job?
in my case, since I didn't put my own sd_check_events thread into
freezable case.
once the system resume, it will cause the race condition as I
mentioned previously, right?

if my conclusion is correct, would you mind to let me know where the
kernel sequencially wake up normal then freezable threads?

appreciate your kind help,
