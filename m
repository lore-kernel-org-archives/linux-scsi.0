From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Sun, 12 Nov 2017 16:42:34 -0500
Message-ID: <20171112164234.48b5185c@Vantage.cJ>
References: <20171110151344.10563-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:53660 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdKLVuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Nov 2017 16:50:18 -0500
In-Reply-To: <20171110151344.10563-1-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Astafyev <1@246060.ru>
Cc: Hans de Goede <hdegoede@redhat.com>, Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 10 Nov 2017 16:13:44 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Just like all previous UAS capable Seagate disk enclosures, this
> one needs a US_FL_NO_ATA_1X quirk.
> [...]
> +/* Reported-by: Andrey Astafyev <dev@246060.ru> */

Hi Andrey,


I notice that you have an external Seagate SMR drive, I am encountering
some trouble and was wondering if you (or anyone in CC) could have some
feedback.

While the drives I have (PID 0xab45, "Backup+ Hub BK") are used
without problem with very light loads, I'm starting to get annoyed when
doing more serious work.
Here is a series of messages (v4.14) I have when simply trying to balance 1
chunk of BTRFS data, ie. write 5 GiB, and waiting a long time in-between:

	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#7 uas_eh_abort_hand=
ler 0 uas-tag 8 inflight: CMD OUT
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#7 CDB: Write(16) 8a=
 00 00 00 00 00 00 00 11 00 00 00 00 80 00 00
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#6 uas_eh_abort_hand=
ler 0 uas-tag 7 inflight: CMD OUT
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#6 CDB: Write(16) 8a=
 00 00 00 00 00 00 00 11 80 00 00 00 80 00 00
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#5 uas_eh_abort_hand=
ler 0 uas-tag 6 inflight: CMD OUT
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#5 CDB: Write(16) 8a=
 00 00 00 00 00 00 bf fd 80 00 00 00 80 00 00
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#4 uas_eh_abort_hand=
ler 0 uas-tag 5 inflight: CMD OUT
	Nov 12 16:15:35 Bidule kernel: sd 22:0:0:0: [sdaa] tag#4 CDB: Write(16) 8a=
 00 00 00 00 00 00 bf fd 00 00 00 00 80 00 00
	Nov 12 16:15:35 Bidule kernel: scsi host22: uas_eh_device_reset_handler st=
art
	Nov 12 16:15:35 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB device =
number 9 using xhci_hcd
	Nov 12 16:15:35 Bidule kernel: scsi host22: uas_eh_device_reset_handler su=
ccess


	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#3 uas_eh_abort_hand=
ler 0 uas-tag 4 inflight: CMD IN
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#3 CDB: Read(16) 88 =
00 00 00 00 00 01 02 53 80 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#13 uas_eh_abort_han=
dler 0 uas-tag 14 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#13 CDB: Write(16) 8=
a 00 00 00 00 00 01 02 3b c0 00 00 00 20 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2 uas_eh_abort_hand=
ler 0 uas-tag 3 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 41 00 00 00 01 00 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#12 uas_eh_abort_han=
dler 0 uas-tag 13 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#12 CDB: Write(16) 8=
a 00 00 00 00 00 01 02 3c a0 00 00 00 20 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#11 uas_eh_abort_han=
dler 0 uas-tag 12 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#11 CDB: Write(16) 8=
a 00 00 00 00 00 01 02 62 00 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#1 uas_eh_abort_hand=
ler 0 uas-tag 2 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#1 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 61 80 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#10 uas_eh_abort_han=
dler 0 uas-tag 11 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#10 CDB: Write(16) 8=
a 00 00 00 00 00 01 02 61 00 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#9 uas_eh_abort_hand=
ler 0 uas-tag 10 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#9 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 60 80 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#8 uas_eh_abort_hand=
ler 0 uas-tag 9 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#8 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 60 00 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#7 uas_eh_abort_hand=
ler 0 uas-tag 8 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#7 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 5f 80 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#6 uas_eh_abort_hand=
ler 0 uas-tag 7 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#6 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 5f 00 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#5 uas_eh_abort_hand=
ler 0 uas-tag 6 inflight: CMD OUT
	Nov 12 16:20:28 Bidule kernel: sd 22:0:0:0: [sdaa] tag#5 CDB: Write(16) 8a=
 00 00 00 00 00 01 02 50 00 00 00 00 80 00 00
	Nov 12 16:20:28 Bidule kernel: scsi host22: uas_eh_device_reset_handler st=
art
	Nov 12 16:20:28 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB device =
number 9 using xhci_hcd
	Nov 12 16:20:28 Bidule kernel: scsi host22: uas_eh_device_reset_handler su=
ccess


	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2 uas_eh_abort_hand=
ler 0 uas-tag 3 inflight: CMD OUT
	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2 CDB: Write(16) 8a=
 00 00 00 00 00 20 00 08 00 00 00 00 08 00 00
	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#1 uas_eh_abort_hand=
ler 0 uas-tag 2 inflight: CMD OUT
	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#1 CDB: Write(16) 8a=
 00 00 00 00 00 00 02 08 00 00 00 00 08 00 00
	Nov 12 16:21:29 Bidule kernel: sd 22:0:0:0: [sdaa] tag#0 uas_eh_abort_hand=
ler 0 uas-tag 1 inflight: CMD
	Nov 12 16:21:29 Bidule kernel: sd 22:0:0:0: [sdaa] tag#0 CDB: Synchronize =
Cache(10) 35 00 00 00 00 00 00 00 00 00
	Nov 12 16:21:29 Bidule kernel: scsi host22: uas_eh_device_reset_handler st=
art
	Nov 12 16:21:29 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB device =
number 9 using xhci_hcd
	Nov 12 16:21:29 Bidule kernel: scsi host22: uas_eh_device_reset_handler su=
ccess


Do you see such things?

I understand that latencies can climb to several seconds as the disks can d=
o GC,
and suspect that the issues (sometimes the USB reset doesn't work and a reb=
oot
is needed...) are due to some unawareness of that, but I don't know.

There are several threads on distribution forums & bug trackers, but nothing
really helpful, and I didn't see much on LKML.


Regards,

--=20
J=C3=A9r=C3=B4me
