From: yoma sophian <sophian.yoma@gmail.com>
Subject: Re: possible race condition for usb_stor_port_reset and usb_reset_and_verify_device
Date: Thu, 7 May 2015 01:54:49 +0800
Message-ID: <CADUS3ok_63WuXBufTfnk1NeosmK7eT91k0vrAHZpWSjD5GqmHw@mail.gmail.com>
References: <CADUS3omfQ=4HTMYOZibvZuhcyfqmc8OWonHGZPkQxnLdQQCOkA@mail.gmail.com>
	<Pine.LNX.4.44L0.1505061019080.1094-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37569 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbEFRyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 13:54:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.1505061019080.1094-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, USB list <linux-usb@vger.kernel.org>

hi Alan

2015-05-06 22:27 GMT+08:00 Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 6 May 2015, yoma sophian wrote:
>
>> hi all:
>> I am writing a thread and it will call sd_check_events per 1 second.
>
> Is your thread freezable?  It should be, if it is going to do I/O.
>
>> 1. before system goes to hibernate, the thread works fine
>>
>> 2. system hibernate and restore back.
>>
>> 3. udev->state will keep USB_STATE_SUSPENDED before finish_port_resume
>>
>> 4. during above 2) and 3) sd_check_events keep polling but get
>> transport error and call usb_stor_port_reset.
>>     since udev->state is USB_STATE_SUSPENDED, the usb_stor_port_reset
>> will fail due to unable lock device for reset (error = -113)
>
> That's why your thread needs to be freezable.
>
> Also, it sounds like you haven't considered Runtime PM.  A USB
> mass-storage device can be set to go into runtime suspend after (for
> example) 5 seconds of inactivity.  If your new thread calls
> sd_check_events every second then the device will never have 5 seconds
> of inactivity, so it will never go into runtime suspend.  This means
> your thread will waste energy.
>
> Besides, the kernel already contains a thread that calls
> sd_check_events periodically.  Why do you need to write a new one?
I create the thread since some buggy devices needs to periodically
polling to let it not going to disconnection.
Would you mind to let me know which kernel thread that calls
sd_check_events periodically?

>
>> 5. in finish_port_resume, it first change udev->state as
>> USB_STATE_CONFIGURED or USB_STATE_ADDRESS. then call
>> usb_reset_and_verify_device like below:
>>     usb_set_device_state(udev, udev->actconfig
>>             ? USB_STATE_CONFIGURED
>>             : USB_STATE_ADDRESS);
>>
>>     /* 10.5.4.5 says not to reset a suspended port if the attached
>>      * device is enabled for remote wakeup.  Hence the reset
>>      * operation is carried out here, after the port has been
>>      * resumed.
>>      */
>>     if (udev->reset_resume)
>>  retry_reset_resume:
>>         status = usb_reset_and_verify_device(udev);
>>
>> 6. usb_reset_and_verify_device will call hub_port_init
>>
>> 7. usb_reset_and_verify_device will call descriptors_changed,
>>
>> 8. if sd_check_events polling again in during 6) and 7),
>> descriptors_changed may return true and report port resume fail.
>>
>> My questions are:
>> a. is there any system flag such suspend/resume in scsi layer for
>> checking before sending command to downlayer driver, such as usb.
>
> I don't know of any.  In general, the kernel is designed so that no
> SCSI commands will be sent while the system is in suspend or
> hibernation, so no checking is needed.
which flag or callback function we used to determine the system is in
suspend or hibernation?
udev->state?

>
>> b. shall we add other flag in usb_stor_port_reset to make sure above
>> race condition will not happen?
>
> No.  You should fix your thread (or get rid of it and use the existing
> kernel thread instead).
Sincerely appreciate your kind help,
