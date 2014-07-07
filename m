From: loody <miloody@gmail.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 23:39:05 +0800
Message-ID: <CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw@mail.gmail.com>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
	<20140707092029.GA19630@localhost.localdomain>
	<CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
	<53BAB5DF.5090606@gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1726D887@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40142 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGGPjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 11:39:09 -0400
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726D887@AcuExch.aculab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: Lars Melin <larsm17@gmail.com>, "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

hi David:

2014-07-07 23:06 GMT+08:00 David Laight <David.Laight@aculab.com>:
> From: Lars Melin
> ...
>> sgread is not included in BusyBox but you should have "touch".
>> Create a dummy file on the disk and let cron touch it every 4 minutes.
>
> You don't need 'touch' a shell redirect eg ": >file" will do open(..., O_CREAT|O_TRUNC).
> However that still might not force an actual disc access.
>
> In any case you really only want to do a read, doing a write will kill the NAND memory.

actually I have searched the scsi/usb layer for possible dummy read,
even read sector 0 is fine, but in vain.

I found the read
a. determined by VFS -> block layer,
b. Block layer put it in queue
c. call scsi pre-queue function to usb layer.

That mean if I try to read sector from usb devices, I have to create a
queue and follow above b) and c) rule.
is there any already kernel API I can use?

sincerely appreciate all yours help,
