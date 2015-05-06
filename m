From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: possible race condition for usb_stor_port_reset and
 usb_reset_and_verify_device
Date: Wed, 6 May 2015 10:27:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505061019080.1094-100000@iolanthe.rowland.org>
References: <CADUS3omfQ=4HTMYOZibvZuhcyfqmc8OWonHGZPkQxnLdQQCOkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33756 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752470AbbEFO1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 10:27:44 -0400
In-Reply-To: <CADUS3omfQ=4HTMYOZibvZuhcyfqmc8OWonHGZPkQxnLdQQCOkA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yoma sophian <sophian.yoma@gmail.com>
Cc: linux-scsi@vger.kernel.org, USB list <linux-usb@vger.kernel.org>

On Wed, 6 May 2015, yoma sophian wrote:

> hi all:
> I am writing a thread and it will call sd_check_events per 1 second.

Is your thread freezable?  It should be, if it is going to do I/O.

> 1. before system goes to hibernate, the thread works fine
> 
> 2. system hibernate and restore back.
> 
> 3. udev->state will keep USB_STATE_SUSPENDED before finish_port_resume
> 
> 4. during above 2) and 3) sd_check_events keep polling but get
> transport error and call usb_stor_port_reset.
>     since udev->state is USB_STATE_SUSPENDED, the usb_stor_port_reset
> will fail due to unable lock device for reset (error = -113)

That's why your thread needs to be freezable.

Also, it sounds like you haven't considered Runtime PM.  A USB
mass-storage device can be set to go into runtime suspend after (for
example) 5 seconds of inactivity.  If your new thread calls
sd_check_events every second then the device will never have 5 seconds
of inactivity, so it will never go into runtime suspend.  This means
your thread will waste energy.

Besides, the kernel already contains a thread that calls 
sd_check_events periodically.  Why do you need to write a new one?

> 5. in finish_port_resume, it first change udev->state as
> USB_STATE_CONFIGURED or USB_STATE_ADDRESS. then call
> usb_reset_and_verify_device like below:
>     usb_set_device_state(udev, udev->actconfig
>             ? USB_STATE_CONFIGURED
>             : USB_STATE_ADDRESS);
> 
>     /* 10.5.4.5 says not to reset a suspended port if the attached
>      * device is enabled for remote wakeup.  Hence the reset
>      * operation is carried out here, after the port has been
>      * resumed.
>      */
>     if (udev->reset_resume)
>  retry_reset_resume:
>         status = usb_reset_and_verify_device(udev);
> 
> 6. usb_reset_and_verify_device will call hub_port_init
> 
> 7. usb_reset_and_verify_device will call descriptors_changed,
> 
> 8. if sd_check_events polling again in during 6) and 7),
> descriptors_changed may return true and report port resume fail.
> 
> My questions are:
> a. is there any system flag such suspend/resume in scsi layer for
> checking before sending command to downlayer driver, such as usb.

I don't know of any.  In general, the kernel is designed so that no
SCSI commands will be sent while the system is in suspend or
hibernation, so no checking is needed.

> b. shall we add other flag in usb_stor_port_reset to make sure above
> race condition will not happen?

No.  You should fix your thread (or get rid of it and use the existing
kernel thread instead).

Alan Stern

