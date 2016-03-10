From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Thu, 10 Mar 2016 18:33:58 +0800
Message-ID: <CAGnHSEkLo7sp5PUqzk74aZi6r30hVDaj2fD-i_cCHWdezZNPwA@mail.gmail.com>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
	<yq1mvq7qdcy.fsf@sermon.lab.mkp.net>
	<CAGnHSEnHG5i3EvwmcGZU5BXobUCQa7P+j+KKNrUyoS86s7d8Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35834 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbcCJKeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 05:34:00 -0500
In-Reply-To: <CAGnHSEnHG5i3EvwmcGZU5BXobUCQa7P+j+KKNrUyoS86s7d8Gg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org

On 10 March 2016 at 12:36, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Both `blkdiscard` with a patched kernel and `sg_unmap` appeared to
> have gone well (checked with `hexdump`).
>
Actually, `blkdiscard` didn't quite actually go well. It seems last
time it just ended quickly with only error on kernel messages, so I
thought it worked.

But apparently it's NOT because of the device itself but has something
to do with the kernel. It will only get into trouble if I set a "step"
(`-p`) larger than "discard_max_bytes" (and/or
"discard_max_hw_bytes"?).

For example, if I use an UNPATCHED kernel and use `echo -n unmap` to
change the "provisioning_mode" sysfs file (this way,
"discard_max_bytes" and "discard_max_hw_bytes" are set to 4294966784),
these work:

[tom@localhost ~]$ time sudo blkdiscard -v -p 33521664 /dev/sdc
/dev/sdc: Discarded 7542374400 bytes from the offset 0
/dev/sdc: Discarded 38415826944 bytes from the offset 7542374400
/dev/sdc: Discarded 37711872000 bytes from the offset 45958201344
/dev/sdc: Discarded 37242568704 bytes from the offset 83670073344
/dev/sdc: Discarded 37577785344 bytes from the offset 120912642048
/dev/sdc: Discarded 37544263680 bytes from the offset 158490427392
/dev/sdc: Discarded 38348783616 bytes from the offset 196034691072
/dev/sdc: Discarded 5673934848 bytes from the offset 234383474688

real    0m6.522s
user    0m0.007s
sys    0m0.097s

[tom@localhost ~]$ time sudo blkdiscard -v -p 4294966784 /dev/sdc
/dev/sdc: Discarded 12884900352 bytes from the offset 0
/dev/sdc: Discarded 55834568192 bytes from the offset 12884900352
/dev/sdc: Discarded 55834568192 bytes from the offset 68719468544
/dev/sdc: Discarded 55834568192 bytes from the offset 124554036736
/dev/sdc: Discarded 55834568192 bytes from the offset 180388604928
/dev/sdc: Discarded 3834236416 bytes from the offset 236223173120

real    0m4.335s
user    0m0.010s
sys    0m0.007s

I even did three trials each, all completed without error:

Mar 10 16:54:46 localhost sudo[435]:      tom : TTY=pts/2 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/bash -c echo -n unmap >
/sys/devices/pci0000:00/0000:00:14.0/usb4/4-6/4-6:1.0/host7/target7:0:0/7:0:0:0/scsi_disk/7:0:0:0/provisioning_mode
Mar 10 16:54:46 localhost sudo[435]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:54:46 localhost sudo[435]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:56:03 localhost sudo[459]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v -p 33521664
/dev/sdc
Mar 10 16:56:03 localhost sudo[459]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:56:09 localhost sudo[459]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:56:11 localhost sudo[463]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v -p 33521664
/dev/sdc
Mar 10 16:56:11 localhost sudo[463]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:56:18 localhost sudo[463]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:56:21 localhost sudo[467]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v -p 33521664
/dev/sdc
Mar 10 16:56:21 localhost sudo[467]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:56:28 localhost sudo[467]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:56:36 localhost sudo[471]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v -p
4294966784 /dev/sdc
Mar 10 16:56:36 localhost sudo[471]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:56:40 localhost sudo[471]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:56:42 localhost sudo[475]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v -p
4294966784 /dev/sdc
Mar 10 16:56:42 localhost sudo[475]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:56:46 localhost sudo[475]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:56:48 localhost sudo[479]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v -p
4294966784 /dev/sdc
Mar 10 16:56:48 localhost sudo[479]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:56:53 localhost sudo[479]: pam_unix(sudo:session): session
closed for user root

However, if I use a patched kernel, the kernel will read the VPD of my
bridge set the files accordingly to 33521664 instead, then only
`blkdiscard -p 33521664` works but not `blkdiscard -p 4294966784`
anymore. It will (usually) be stalled and with errors repeated in
kernel message:

...
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#7
uas_eh_abort_handler 0 uas-tag 8 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#7 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#6
uas_eh_abort_handler 0 uas-tag 7 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#6 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#5
uas_eh_abort_handler 0 uas-tag 6 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#5 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#4
uas_eh_abort_handler 0 uas-tag 5 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#4 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#3
uas_eh_abort_handler 0 uas-tag 4 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#3 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#2
uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#2 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#1
uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#1 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#0
uas_eh_abort_handler 0 uas-tag 1 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#0 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#13
uas_eh_abort_handler 0 uas-tag 14 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#13 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#12
uas_eh_abort_handler 0 uas-tag 13 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#12 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#11
uas_eh_abort_handler 0 uas-tag 12 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#11 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#10
uas_eh_abort_handler 0 uas-tag 11 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#10 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#9
uas_eh_abort_handler 0 uas-tag 10 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#9 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#8
uas_eh_abort_handler 0 uas-tag 9 inflight: CMD OUT
Mar 10 18:23:25 localhost kernel: sd 7:0:0:0: [sdc] tag#8 CDB:
opcode=0x42 42 00 00 00 00 00 00 00 18 00
Mar 10 18:23:25 localhost kernel: scsi host7: uas_eh_bus_reset_handler start
Mar 10 18:23:25 localhost kernel: usb 4-6: reset SuperSpeed USB device
number 3 using xhci_hcd
Mar 10 18:23:25 localhost kernel: scsi host7: uas_eh_bus_reset_handler success
Mar 10 18:23:25 localhost kernel: xhci_hcd 0000:00:14.0: ERROR Unknown
event condition 34, HC probably busted
...

Same thing happens (with either a patched or unpatched kernel) if I do
not set `-p` for `blkdiscard` at all, since it basically means `-p
468862128 (total LBA of my drive) * 512` (see man page of
`blkdiscard).

However this works like a charm:

[tom@localhost ~]$ sudo sg_unmap -vvvv -l 0 -n 468862128 /dev/sdc
found bsg_major=250
open /dev/sdc with flags=0x802
    unmap cdb: 42 00 00 00 00 00 00 00 18 00
    unmap parameter list:
00 16 00 10 00 00 00 00  00 00 00 00 00 00 00 00
1b f2 44 b0 00 00 00 00
      duration=4290 ms

Again, three trials:

Mar 10 16:50:45 localhost sudo[429]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/sg_unmap -vvvv -l 0 -n
468862128 /dev/sdc
Mar 10 16:50:45 localhost sudo[429]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:50:49 localhost sudo[429]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:50:51 localhost sudo[433]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/sg_unmap -vvvv -l 0 -n
468862128 /dev/sdc
Mar 10 16:50:51 localhost sudo[433]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:50:55 localhost sudo[433]: pam_unix(sudo:session): session
closed for user root
Mar 10 16:50:58 localhost sudo[437]:      tom : TTY=pts/1 ;
PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/sg_unmap -vvvv -l 0 -n
468862128 /dev/sdc
Mar 10 16:50:58 localhost sudo[437]: pam_unix(sudo:session): session
opened for user root by (uid=0)
Mar 10 16:51:02 localhost sudo[437]: pam_unix(sudo:session): session
closed for user root
