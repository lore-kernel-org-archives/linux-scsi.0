From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 20:14:25 +0530
Message-ID: <3e7aae31002250644t4a2fffbdx1f3f6a85c9407532@mail.gmail.com>
References: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
	 <Pine.LNX.4.44L0.1002241123220.2436-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:37804 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab0BYOo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 09:44:27 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002241123220.2436-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, Feb 24, 2010 at 10:00 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Wed, 24 Feb 2010, Ramya Desai wrote:
>
>> I did exactly. I removed the following statement from
>> store_max_sectors (drivers/usb/storage/scsiglue.c) function.
>> " && ms <=3D SCSI_DEFAULT_MAX_SECTORS". I also changed the .max_sect=
ors
>> =3D 2048 in the host template.
>>
>> Then I restarted the system and build the usb-storage without any is=
sue.
>>
>> After inserting my device, I found 1024 in
>> /sys/block/sdb/device/max_sectors. So, I tried to increase the value
>> through echo 2048 > /sys/block/sdb/device/max_sectors. When I do thi=
s,
>> it invoked the store_max_sectors() in the scsiglue.c file and able t=
o
>> see ms (the variable in the store_max_sectors()) is 2048. But, the
>> value in the /sys/block/sdb/device/max_sectors is still 1024 only.
>
> That's right. =A0Writing 2048 to that file sets max_hw_sectors to 204=
8
> while leaving max_sectors set at 1024. =A0The value displayed in the =
file
> is max_sectors -- it really ought to be max_hw_sectors. =A0You can fi=
x
> this by editing the show_max_sectors() function in scsiglue.c: change
> "queue_max_sectors" to "queue_max_hw_sectors".
>
>> When I looked into the /sys/block/sdb/queue/max_hw_sectors_kb, it
>> shows 1024, which is 2048 sectors.
>
> As it should be.
>
>> =A0Then, I tried to increase the value
>> in /sys/block/sdb/queue/max_sectors_kb through echo 1024 >
>> /sys/block/sdb/queue/max_sectors_kb. After this, I saw 1024 in the
>> /sys/block/sdb/queue/max_sectors_kb. When I see 1024 in
>> /sys/block/sdb/queue/max_sectors_kb then I found 2048 in
>> /sys/block/sdb/device/max_sectors.
>
> Right, because that file displays max_sectors instead of
> max_hw_sectors.
>
>> =A0However, this time, still my device
>> received 512 KB (1024) data transfer buffers in scsi_command.
>
> At this point everything was set up correctly. =A0I don't know why th=
e
> transfer lengths are still 512 KB. =A0Maybe someone else has an idea.
>
> Alan Stern

Dear Alan, James, Martin, Jens

Thanks a lot for your valuable information. I will let all you know,
If I see any progress.

Thanks and Regards,
RD.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
