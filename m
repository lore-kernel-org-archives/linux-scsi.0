From: Adam Kropelin <akropel1@rochester.rr.com>
Subject: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Wed, 6 Aug 2003 23:14:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030806231359.A28252@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roc-24-93-20-125.rochester.rr.com ([24.93.20.125]:52988 "EHLO
	mail.kroptech.com") by vger.kernel.org with ESMTP id S275091AbTHGDS7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2003 23:18:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gibbs@scsiguy.com, Kai.Makisara@metla.fi

When trying to read from my SCSI tape drive using the wrong block size I
get the BUG trace shown below. I ran into this by accident after writing
a tape with variable blocksize and then trying to 'dd' from it using a
fixed blocksize.

The BUG trace is from 2.6.0-test2, but it's also reproducable on -test1
and test2-mm3. The box is running SMP + PREEMPT. SCSI boot-time messages
are shown below.

Steps to reproduce:
mt -f /dev/st0 setblk 0   # Set variable block size
dd if=/dev/zero of=/dev/st0 bs=1237 count=1  # Write an unusual block
mt -f /dev/st0 setblk 512 # Set block size to 512 fixed
dd if=/dev/st0 bs=512     # BUG

--Adam

kernel BUG at include/asm/dma-mapping.h:37!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<c02b2eaf>]    Not tainted
EFLAGS: 00010046
EIP is at ahc_linux_run_device_queue+0x3ef/0x8d0
eax: dfd88820   ebx: 00000001   ecx: dfd837e0   edx: 00000000
esi: dffa4038   edi: dfd400c6   ebp: dfd44068   esp: de0d3cf0
ds: 007b   es: 007b   ss: 0068
Process dd (pid: 1462, threadinfo=de0d2000 task=dfcf0d00)
Stack: 00000040 dfd837e0 dfd837e0 dfd400c0 c02b310a dfd40080 dfd400c0 00000040
       00000040 dfd837e0 00000000 dfd837e0 c02ae6e2 c03e3d60 00000246 dfd400c0
       dfd8ec00 00000000 00000001 dfd837e0 c02ae6e2 dfd8ec00 dfd362a0 00000000
Call Trace:
 [<c02b310a>] ahc_linux_run_device_queue+0x64a/0x8d0
 [<c02ae6e2>] ahc_linux_queue+0x222/0x270
 [<c02ae6e2>] ahc_linux_queue+0x222/0x270
 [<c01249f1>] add_timer+0x81/0xc0
 [<c029355b>] scsi_dispatch_cmd+0x15b/0x1b0
 [<c02936f0>] scsi_done+0x0/0x70
 [<c0297f37>] scsi_request_fn+0x257/0x320
 [<c025cf38>] blk_insert_request+0x78/0xb0
 [<c025cf42>] blk_insert_request+0x82/0xb0
 [<c0296d96>] scsi_insert_special_req+0x26/0x30
 [<c0296e91>] scsi_do_req+0x71/0x80
 [<c0292fda>] scsi_allocate_request+0x1a/0x60
 [<c02b69dc>] st_do_scsi+0x10c/0x150
 [<c02b6820>] st_sleep_done+0x0/0xb0
 [<c02b9a24>] st_int_ioctl+0x6d4/0xa40
 [<c02b8676>] read_tape+0x266/0x3b0
 [<c02b7bce>] setup_buffering+0x6e/0x100
 [<c02b8a35>] st_read+0x275/0x3b0
 [<c0146076>] do_brk+0x116/0x1e0
 [<c01510ea>] vfs_read+0xaa/0xe0
 [<c01512df>] sys_read+0x2f/0x50
 [<c01090ef>] syscall_call+0x7/0xb

Code: 0f 0b 25 00 40 cd 37 c0 85 db 74 38 31 c9 89 da 90 8b 04 0e
 <6>note: dd[1462] exited with preempt_count 1

-------------------

SCSI dmesg (scsi0 is another aic7xxx but is not involved in this
scenario, AFAICT):
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec 2940 SCSI adapter>
        aic7870: Single Channel A, SCSI Id=7, 16/253 SCBs

(scsi1:A:6): 10.000MB/s transfers (10.000MHz, offset 15)
  Vendor: Quantum   Model: DLT4000           Rev: D473
  Type:   Sequential-Access                  ANSI SCSI revision: 02
st: Version 20030622, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi1, channel 0, id 6, lun 0
st0: try direct i/o: yes, max page reachable by HBA 1048575

