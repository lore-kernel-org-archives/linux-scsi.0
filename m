From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug 1.63 on lk 2.5.45
Date: Sun, 03 Nov 2002 23:43:07 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC519DB.3080601@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080106010907060207050804"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-83.triode.net.au [202.147.125.83])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gA3Ci6o28254
	for <linux-scsi@vger.kernel.org>; Sun, 3 Nov 2002 23:44:07 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080106010907060207050804
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is an addition to the patches on this driver that
I've been posting recently. This one adds:
   - slave_attach() and slave_detach()
   - code clean up looking for a problem **
   - more debug code allowing scanning cmd sequence to
     be seen in the log (when opts=1)

** after several (never the first) sequences of modprobe/rmmod
on scsi_debug there is either:
   - an oops during modprobe when driverfs tries to create a
     directory
   - or a WARN_ON() at drivers/base/bus.c:277 during rmmod
[examples attached]

I'm not sure whether the problem is in scsi_debug, the
scsi mid level or in the driverfs code. Grepping indicates
that not many people currently utilize per driver parameters
with driverfs (i.e. driver_create_file() and
driver_remove_file()).

Doug Gilbert

--------------080106010907060207050804
Content-Type: application/x-gzip;
 name="scsi_debug_163_2545.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="scsi_debug_163_2545.diff.gz"

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
VAAA
--------------080106010907060207050804
Content-Type: text/plain;
 name="sdebug_modprobe_oops.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_modprobe_oops.txt"

Nov  3 17:32:39 fred kernel: scsi_debug: detect
Nov  3 17:32:39 fred kernel: Unable to handle kernel paging request at virtual address 5a5a5ab6
Nov  3 17:32:39 fred kernel:  printing eip:
Nov  3 17:32:39 fred kernel: c0168f36
Nov  3 17:32:39 fred kernel: *pde = 00000000
Nov  3 17:32:39 fred kernel: Oops: 0002
Nov  3 17:32:39 fred kernel: scsi_debug usbtest hid ehci-hcd usbcore  
Nov  3 17:32:39 fred kernel: CPU:    0
Nov  3 17:32:39 fred kernel: EIP:    0060:[<c0168f36>]    Not tainted
Nov  3 17:32:39 fred kernel: EFLAGS: 00010246
Nov  3 17:32:39 fred kernel: EIP is at driverfs_create_dir+0x56/0x100
Nov  3 17:32:39 fred kernel: eax: 00000000   ebx: 5a5a5ab6   ecx: 5a5a5ab6   edx: c0281b5d
Nov  3 17:32:39 fred kernel: esi: 5a5a5a5a   edi: dfdc2934   ebp: e085daac   esp: de353e80
Nov  3 17:32:39 fred kernel: ds: 0068   es: 0068   ss: 0068
Nov  3 17:32:39 fred kernel: Process modprobe (pid: 1060, threadinfo=de352000 task=dd8e0c40)
Nov  3 17:32:39 fred kernel: Stack: c0281b5d 00000077 00800000 c0381304 c0381300 e085da80 e085b120 c01b4318 
Nov  3 17:32:39 fred kernel:        e085daac c0381350 c01b2da1 e085da80 00000042 e085da80 00000000 e1061000 
Nov  3 17:32:39 fred kernel:        c01b3227 e085da80 00000000 e0858848 e085da80 00000000 c034ca6c 00000000 
Nov  3 17:32:39 fred kernel: Call Trace:
Nov  3 17:32:39 fred kernel:  [<e085da80>] sdebug_driverfs_driver+0x0/0x60 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e085b120>] driver_template+0x0/0x6c [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01b4318>] driver_make_dir+0x28/0x30
Nov  3 17:32:39 fred kernel:  [<e085daac>] sdebug_driverfs_driver+0x2c/0x60 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01b2da1>] bus_add_driver+0x81/0xa0
Nov  3 17:32:39 fred kernel:  [<e085da80>] sdebug_driverfs_driver+0x0/0x60 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e085da80>] sdebug_driverfs_driver+0x0/0x60 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01b3227>] driver_register+0x47/0x60
Nov  3 17:32:39 fred kernel:  [<e085da80>] sdebug_driverfs_driver+0x0/0x60 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e0858848>] scsi_debug_detect+0xd8/0x1c0 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e085da80>] sdebug_driverfs_driver+0x0/0x60 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e085b120>] driver_template+0x0/0x6c [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01f7b69>] scsi_register_host+0x39/0x200
Nov  3 17:32:39 fred kernel:  [<e085b120>] driver_template+0x0/0x6c [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01a6907>] copy_from_user+0x57/0x5c
Nov  3 17:32:39 fred kernel:  [<e0859799>] init_this_scsi_driver+0x19/0x40 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e085b120>] driver_template+0x0/0x6c [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01182b2>] sys_init_module+0x4c2/0x610
Nov  3 17:32:39 fred kernel:  [<e0857060>] E __insmod_scsi_debug_O/lib/modules/2.5.45/kernel/drivers/scsi/scsi_debug.o_M3DC4C18B_V132397+0x60/0x80 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<e0857060>] E __insmod_scsi_debug_O/lib/modules/2.5.45/kernel/drivers/scsi/scsi_debug.o_M3DC4C18B_V132397+0x60/0x80 [scsi_debug]
Nov  3 17:32:39 fred kernel:  [<c01073e3>] syscall_call+0x7/0xb
Nov  3 17:32:39 fred kernel: 
Nov  3 17:32:39 fred kernel: Code: ff 4e 5c 0f 88 89 04 00 00 89 3c 24 8b 45 00 89 44 24 04 e8 
Nov  3 17:44:30 fred login(pam_unix)[724]: session opened for user root by LOGIN(uid=0)
Nov  3 17:44:30 fred  -- root[724]: ROOT LOGIN ON tty4

--------------080106010907060207050804
Content-Type: text/plain;
 name="sdebug_rmmod_warn.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_rmmod_warn.txt"

Synchronizing SCSI cache: 
scsi_debug: slave_detach <0 0 0 0>
Badness in put_bus at drivers/base/bus.c:277
Call Trace:
 [<c01b2ed9>] put_bus+0x69/0x80
 [<c01b1ef3>] device_del+0x33/0x80
 [<c01f740b>] scsi_host_chk_and_release+0xdb/0x220
 [<c01a67e0>] __copy_to_user+0x30/0x50
 [<c01339dc>] buffered_rmqueue+0xac/0x120
 [<e085afe0>] driver_template+0x0/0x6c [scsi_debug]
 [<c01f7330>] scsi_host_chk_and_release+0x0/0x220
 [<c01f72be>] scsi_tp_for_each_host+0x3e/0x40
 [<e085afe0>] driver_template+0x0/0x6c [scsi_debug]
 [<c01f7d55>] scsi_unregister_host+0x25/0x70
 [<e085afe0>] driver_template+0x0/0x6c [scsi_debug]
 [<c01f7330>] scsi_host_chk_and_release+0x0/0x220
 [<e085972f>] exit_this_scsi_driver+0xf/0x20 [scsi_debug]
 [<e085afe0>] driver_template+0x0/0x6c [scsi_debug]
 [<c011910c>] free_module+0xac/0xc0
 [<c01184c3>] sys_delete_module+0x93/0x1b0
 [<c01073e3>] syscall_call+0x7/0xb

scsi_debug: [last] release
scsi : 0 hosts left.

--------------080106010907060207050804--

