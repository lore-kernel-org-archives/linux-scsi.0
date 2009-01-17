From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Can not send SCSI command to the cdrom device.
Date: Sat, 17 Jan 2009 11:40:07 -0500
Message-ID: <497209E7.4020205@interlog.com>
References: <face93d65cecd.5cecdface93d6@huawei.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:35330 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZAQQkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Jan 2009 11:40:14 -0500
In-Reply-To: <face93d65cecd.5cecdface93d6@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-scsi@vger.kernel.org

fangxiaozhi 00110321 wrote:
> Dear all:
>  
>   I have a CDROM device, and after I plug it into the Linux system, the Linux system will generate three device files in the directory of /dev/, such as:
>   scd1: block special (11/0)
>   sr1:  link to scd1
>   sg1: character special(21/1)
>  
>   And I write a c program to send the SCSI command of SPACE to my CDROM device. Such as :
>  
>    fd = open("/dev/sg1", 0_RDWR);
>    ioctl(fd, SCSI_IOCTL_SEND_COMMAND, cmdbuff);
>  
>   And I found that I can send the SPACE command to my CDROM device, if I open the file of /dev/sg1.
>   But if I open the file of /dev/scd1, then I can not send the SPACE command to my CDROM device.
>  
>    Why I can not send SCSI command through /dev/scd1 ?

Probably because you don't have media in the drive in which case
open("/dev/scd1", ...) will block. You might try or-ing in
O_NONBLOCK as in open("/dev/scd1", 0_RDWR | O_NONBLOCK).

If you are using any Linux system made in the last 5 years then
you should _not_ be using the SCSI_IOCTL_SEND_COMMAND ioctl. Try
the SG_IO ioctl instead.

>    What difference between /dev/sg1 and /dev/scd1 ?

The sg driver makes a lot less assumptions about the SCSI
device and is designed for lower-level, pass-through access at
the SCSI command level. The bsg driver in recent kernels plays
a similar role to the older sg driver which dates from 1992.

>    And how can I send send the command through /dev/scd1?

Answered above. BTW In the lk 2.6 series the SG_IO ioctl will
work on both "sg" and "scd/sr" drivers.

For examples on the use of SG_IO have a look at my sg3_utils
package, specifically the examples directory. You may find the
sg_get_config utility interesting to use on a CD/DVD/BD drive.

Doug Gilbert
