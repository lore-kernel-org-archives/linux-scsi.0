From: yoma sophian <sophian.yoma@gmail.com>
Subject: possible race condition for usb_stor_port_reset and usb_reset_and_verify_device
Date: Wed, 6 May 2015 14:27:06 +0800
Message-ID: <CADUS3omfQ=4HTMYOZibvZuhcyfqmc8OWonHGZPkQxnLdQQCOkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34985 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbEFG1H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 02:27:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, USB list <linux-usb@vger.kernel.org>

hi all:
I am writing a thread and it will call sd_check_events per 1 second.

1. before system goes to hibernate, the thread works fine

2. system hibernate and restore back.

3. udev->state will keep USB_STATE_SUSPENDED before finish_port_resume

4. during above 2) and 3) sd_check_events keep polling but get
transport error and call usb_stor_port_reset.
    since udev->state is USB_STATE_SUSPENDED, the usb_stor_port_reset
will fail due to unable lock device for reset (error = -113)

5. in finish_port_resume, it first change udev->state as
USB_STATE_CONFIGURED or USB_STATE_ADDRESS. then call
usb_reset_and_verify_device like below:
    usb_set_device_state(udev, udev->actconfig
            ? USB_STATE_CONFIGURED
            : USB_STATE_ADDRESS);

    /* 10.5.4.5 says not to reset a suspended port if the attached
     * device is enabled for remote wakeup.  Hence the reset
     * operation is carried out here, after the port has been
     * resumed.
     */
    if (udev->reset_resume)
 retry_reset_resume:
        status = usb_reset_and_verify_device(udev);

6. usb_reset_and_verify_device will call hub_port_init

7. usb_reset_and_verify_device will call descriptors_changed,

8. if sd_check_events polling again in during 6) and 7),
descriptors_changed may return true and report port resume fail.

My questions are:
a. is there any system flag such suspend/resume in scsi layer for
checking before sending command to downlayer driver, such as usb.
b. shall we add other flag in usb_stor_port_reset to make sure above
race condition will not happen?
appreciate your kind help,
