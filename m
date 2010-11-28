From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: megasas: double free segment with scsi-bsg backstores
Date: Sat, 27 Nov 2010 21:45:45 -0800
Message-ID: <1290923145.6216.184.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41895 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0K1Fvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Nov 2010 00:51:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Christoph Hellwig <hch@lst.de>, Paul Brook <paul@codesourcery.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Hannes, Gerd and QEMU+Linux storage folks,

So during testing this evening I ran into the following segfault with
megasas <-> scsi-bsg on most recent qemu-kvm.git/megasas-upstream-v1
code on a KVM host running .37-rc3 w/ TCM_Loop virtual SCSI LUNs.  This
same setup is still working fine with scsi-generic, so it appears to be
a AIO polling READ specific issue in bsg_complete_read() ->
megasas_unmap_sgl().

Here is the bug running in gdb with DEBUG_BSG_IO enabled:

[root@barret qemu-kvm.git]# gdb ./x86_64-softmmu/qemu-system-x86_64 GNU gdb (GDB) Fedora (6.8.50.20090302-21.fc11)
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
(gdb) set args  -m 2048 -smp 1 -device pci-assign,host=02:00.0 -device pci-assign,host=06:00.0 /root/lenny64guest0-orig.img -serial file:serial.log -drive if=none,id=mydisk1,file=/dev/bsg/8\:0\:1\:0 -device megasas,id=raid -device scsi-bsg,bus=raid.0,scsi-id=1,drive=mydisk1
(gdb) run
Starting program: /usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64 -m 2048 -smp 1 -device pci-assign,host=02:00.0 -device pci-assign,host=06:00.0 /root/lenny64guest0-orig.img -serial file:serial.log -drive if=none,id=mydisk1,file=/dev/bsg/8\:0\:1\:0 -device megasas,id=raid -device scsi-bsg,bus=raid.0,scsi-id=1,drive=mydisk1
[Thread debugging using libthread_db enabled]
[New Thread 0x7ffff6c66910 (LWP 18899)]
megasas: Using 80 sges, 1000 cmds, raid mode
scsi-bsg: LUN 0
scsi-bsg: device type 0
scsi-bsg: block size 512
megasas: Reset
scsi-bsg: bsg_send_command: lun=0 tag=0x7 len 36 data=0x12 0x00 0x00 0x00 0x24 0x00
scsi-bsg: bsg_read_data 0x7
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 36
[New Thread 0x7ffff4d7b910 (LWP 18900)]
scsi-bsg: BSG READ Data ready tag=0x7 len=36
scsi-bsg: bsg_read_data 0x7
scsi-bsg: Command complete 0x0x7ffff0034d60 tag=0x7 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x107 len 36 data=0x12 0x00 0x00 0x00 0x24 0x00
scsi-bsg: bsg_read_data 0x107
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 36
scsi-bsg: BSG READ Data ready tag=0x107 len=36
scsi-bsg: bsg_read_data 0x107
scsi-bsg: Command complete 0x0x7ffff0034d60 tag=0x107 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x186 len 0 data=0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x186 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x187 len 8 data=0x25 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: bsg_read_data 0x187
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 8
scsi-bsg: BSG READ Data ready tag=0x187 len=8
scsi-bsg: bsg_read_data 0x187
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x187 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x188 len 4 data=0x1a 0x00 0x3f 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x188
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x188 len=4
scsi-bsg: bsg_read_data 0x188
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x188 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x189 len 4 data=0x1a 0x00 0x08 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x189
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x189 len=4
scsi-bsg: bsg_read_data 0x189
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x189 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x18a len 0 data=0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x18a status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x18b len 8 data=0x25 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: bsg_read_data 0x18b
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 8
scsi-bsg: BSG READ Data ready tag=0x18b len=8
scsi-bsg: bsg_read_data 0x18b
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x18b status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x18c len 4 data=0x1a 0x00 0x3f 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x18c
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x18c len=4
scsi-bsg: bsg_read_data 0x18c
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x18c status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x18d len 4 data=0x1a 0x00 0x08 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x18d
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x18d len=4
scsi-bsg: bsg_read_data 0x18d
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x18d status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x18e len 512 data=0x88 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x00
scsi-bsg: bsg_read_data 0x18e
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 512
scsi-bsg: BSG READ Data ready tag=0x18e len=512
scsi-bsg: bsg_read_data 0x18e
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x18e status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x18f len 0 data=0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x18f status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x190 len 8 data=0x25 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: bsg_read_data 0x190
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 8
scsi-bsg: BSG READ Data ready tag=0x190 len=8
scsi-bsg: bsg_read_data 0x190
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x190 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x191 len 4 data=0x1a 0x00 0x3f 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x191
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x191 len=4
scsi-bsg: bsg_read_data 0x191
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x191 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x192 len 4 data=0x1a 0x00 0x08 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x192
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x192 len=4
scsi-bsg: bsg_read_data 0x192
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x192 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x193 len 512 data=0x88 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x00
scsi-bsg: bsg_read_data 0x193
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 512
scsi-bsg: BSG READ Data ready tag=0x193 len=512
scsi-bsg: bsg_read_data 0x193
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x193 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x194 len 0 data=0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x194 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x195 len 8 data=0x25 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
scsi-bsg: bsg_read_data 0x195
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 8
scsi-bsg: BSG READ Data ready tag=0x195 len=8
scsi-bsg: bsg_read_data 0x195
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x195 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x196 len 4 data=0x1a 0x00 0x3f 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x196
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x196 len=4
scsi-bsg: bsg_read_data 0x196
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x196 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x197 len 4 data=0x1a 0x00 0x08 0x00 0x04 0x00
scsi-bsg: bsg_read_data 0x197
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 4
scsi-bsg: BSG READ Data ready tag=0x197 len=4
scsi-bsg: bsg_read_data 0x197
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x197 status=0
scsi-bsg: bsg_send_command: lun=0 tag=0x198 len 254 data=0x12 0x00 0x00 0x00 0xfe 0x00
scsi-bsg: bsg_read_data 0x198
scsi-bsg: setup IOV: iovec_num: 1, iov: 0x7ffff0034d30, dout_xfer_len: 0 din_xfer_len: 254
scsi-bsg: BSG READ Data ready tag=0x198 len=254
scsi-bsg: bsg_read_data 0x198
scsi-bsg: Command complete 0x0x7ffff00350e0 tag=0x198 status=0
*** glibc detected *** /usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64: free(): invalid next size (fast): 0x00007ffff0034d30 ***
======= Backtrace: =========
/lib64/libc.so.6[0x376a476716]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x59a14f]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x4858eb]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x44dcfd]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x44de25]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x41b8ce]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x434a67]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x41c995]
/lib64/libc.so.6(__libc_start_main+0xfd)[0x376a41e9dd]
/usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64[0x408d59]
======= Memory map: ========
00400000-00722000 r-xp 00000000 fd:00 528249                             /usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64
00922000-00947000 rw-p 00322000 fd:00 528249                             /usr/src/qemu-kvm.git/x86_64-softmmu/qemu-system-x86_64
00947000-01bb9000 rw-p 00000000 00:00 0                                  [heap]
376a000000-376a01f000 r-xp 00000000 fd:00 1223                           /lib64/ld-2.9.90.so
376a21e000-376a21f000 r--p 0001e000 fd:00 1223                           /lib64/ld-2.9.90.so
376a21f000-376a220000 rw-p 0001f000 fd:00 1223                           /lib64/ld-2.9.90.so
376a400000-376a567000 r-xp 00000000 fd:00 1224                           /lib64/libc-2.9.90.so
376a567000-376a766000 ---p 00167000 fd:00 1224                           /lib64/libc-2.9.90.so
376a766000-376a76a000 r--p 00166000 fd:00 1224                           /lib64/libc-2.9.90.so
376a76a000-376a76b000 rw-p 0016a000 fd:00 1224                           /lib64/libc-2.9.90.so
376a76b000-376a770000 rw-p 00000000 00:00 0 

<SNIP extended memory map output>

7ffff7ffc000-7ffff7ffe000 rw-p 00000000 00:00 0 
7ffff7ffe000-7ffff7fff000 r-xp 00000000 00:00 0                          [vdso]
7ffffffde000-7ffffffff000 rw-p 00000000 00:00 0                          [stack]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

Program received signal SIGABRT, Aborted.
0x000000376a4336c5 in raise () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install SDL-1.2.13-9.fc11.x86_64 cyrus-sasl-lib-2.1.22-22.fc11.x86_64 e2fsprogs-libs-1.41.4-8.fc11.x86_64 glibc-2.9.90-22.x86_64 gnutls-2.6.5-1.fc11.x86_64 keyutils-libs-1.2-5.fc11.x86_64 krb5-libs-1.6.3-20.fc11.x86_64 libX11-1.2-3.fc11.x86_64 libXau-1.0.4-5.fc11.x86_64 libXcursor-1.1.9-4.fc11.x86_64 libXext-1.0.99.1-2.fc11.x86_64 libXfixes-4.0.3-5.fc11.x86_64 libXrandr-1.2.99.4-3.fc11.x86_64 libXrender-0.9.4-5.fc11.x86_64 libattr-2.4.43-3.fc11.x86_64 libcurl-7.19.4-7.fc11.x86_64 libgcc-4.4.0-3.x86_64 libgcrypt-1.4.4-4.fc11.x86_64 libgpg-error-1.6-3.x86_64 libidn-1.9-4.x86_64 libjpeg-6b-45.fc11.x86_64 libpng-1.2.35-1.fc11.x86_64 libselinux-2.0.80-1.fc11.x86_64 libssh2-1.0-2.fc11.x86_64 libtasn1-1.8-2.fc11.x86_64 libxcb-1.2-3.fc11.x86_64 ncurses-l
 ibs-5.7-2.20090207.fc11.x86_64 nspr-4.7.3-5.fc11.x86_64 nss-3.12.3-3.fc11.x86_64 nss-softokn-freebl-3.12.3-3.fc11.x86_64 openldap-2.4.15-3.fc11.x86_64 openssl-0.9.8k-1.fc11.x86_64 zlib-1.2.3-22.fc11.x86_64
(gdb) bt
#0  0x000000376a4336c5 in raise () from /lib64/libc.so.6
#1  0x000000376a434f3a in abort () from /lib64/libc.so.6
#2  0x000000376a470bcd in __libc_message () from /lib64/libc.so.6
#3  0x000000376a476716 in malloc_printerr () from /lib64/libc.so.6
#4  0x000000000059a14f in megasas_unmap_sgl (cmd=<value optimized out>) at /usr/src/qemu-kvm.git/hw/megasas.c:199
#5  megasas_command_complete (cmd=<value optimized out>) at /usr/src/qemu-kvm.git/hw/megasas.c:1353
#6  0x00000000004858eb in bsg_read_complete (opaque=0x7ffff00350e0, ret=<value optimized out>)
    at /usr/src/qemu-kvm.git/hw/scsi-bsg.c:289
#7  0x000000000044dcfd in posix_aio_process_queue (opaque=<value optimized out>) at posix-aio-compat.c:462
#8  0x000000000044de25 in posix_aio_read (opaque=0x115a930) at posix-aio-compat.c:503
#9  0x000000000041b8ce in main_loop_wait (nonblocking=<value optimized out>) at /usr/src/qemu-kvm.git/vl.c:1274
#10 0x0000000000434a67 in kvm_main_loop () at /usr/src/qemu-kvm.git/qemu-kvm.c:1589
#11 0x000000000041c995 in main_loop () at /usr/src/qemu-kvm.git/vl.c:1314
#12 main () at /usr/src/qemu-kvm.git/vl.c:3068

In the KVM x86_64 guest running either .37-rc3 or 2.6.26-2, the megaraid_sas
output looks like so, all SCSI I/O is failing from the initial INQUIRY is completing
with zero'ed payloads.

[    4.124179] megasas: 0x1000:0x0060:0x1000:0x1013: bus 0:slot 6:func 0
[    4.129870] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.130557] megaraid_sas 0000:00:06.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, high) -> IRQ 10
[    4.132257] megasas: FW now in Ready state
[    4.132257] megasas_init_mfi: fw_support_ieee=0
[    4.132257] scsi0 : LSI SAS based MegaRAID driver
[    4.153902] scsi scan: INQUIRY result too short (5), using 36
[    4.154582] scsi 0:0:1:0: Direct-Access                                    PQ: 0 ANSI: 0
[    4.178204] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.178880] qla2xxx 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, high) -> IRQ 10
[    4.179842] qla2xxx 0000:00:05.0: Found an ISP2532, irq 10, iobase 0xffffc90001e7c000
[    4.252592] qla2xxx 0000:00:05.0: Configuring PCI space...
[    4.254395] scsi scan: INQUIRY result too short (5), using 36
[    4.255047] scsi 0:2:1:0: Direct-Access                                    PQ: 0 ANSI: 0
[    4.272210] qla2xxx 0000:00:05.0: Configure NVRAM parameters...
[    4.280205] qla2xxx 0000:00:05.0: Verifying loaded RISC code...
[    4.287323] qla2xxx 0000:00:05.0: FW: Loading via request-firmware...
[    4.300759] sd 0:2:1:0: [sda] Sector size 0 reported, assuming 512.
[    4.301491] sd 0:2:1:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
[    4.302233] sd 0:2:1:0: [sda] 0-byte physical blocks
[    4.303464] sd 0:2:1:0: [sda] Write Protect is off
[    4.304217] sd 0:2:1:0: [sda] Asking for cache data failed
[    4.304217] sd 0:2:1:0: [sda] Assuming drive cache: write through
[    4.304217] sd 0:2:1:0: [sda] Sector size 0 reported, assuming 512.
[    4.304217] sd 0:2:1:0: [sda] Asking for cache data failed
[    4.308605] sd 0:2:1:0: [sda] Assuming drive cache: write through
[    4.311367] Dev sda: unable to read RDB block 1
[    4.311906]  sda: unable to read partition table
[    4.312508] sda: partition table beyond EOD, enabling native capacity
[    4.313586] sd 0:2:1:0: [sda] Sector size 0 reported, assuming 512.
[    4.314607] sd 0:2:1:0: [sda] Asking for cache data failed
[    4.315230] sd 0:2:1:0: [sda] Assuming drive cache: write through
[    4.316064] Dev sda: unable to read RDB block 1
[    4.316715]  sda: unable to read partition table
[    4.317222] sda: partition table beyond EOD, truncated
[    4.318464] sd 0:2:1:0: [sda] Sector size 0 reported, assuming 512.
[    4.319747] sd 0:2:1:0: [sda] Asking for cache data failed
[    4.320498] sd 0:2:1:0: [sda] Assuming drive cache: write through
[    4.320675] sd 0:2:1:0: [sda] Attached SCSI disk
[    4.320675] qla2xxx 0000:00:05.0: Allocated (64 KB) for FCE...
[    4.320675] qla2xxx 0000:00:05.0: Allocated (64 KB) for EFT...
[    4.320675] qla2xxx 0000:00:05.0: Allocated (1350 KB) for firmware dump...

So these callbacks are coming from:

hw/scsi-bsg.c:bsg_read_complete:

    ....

    memset(&io_hdr, 0, sizeof(io_hdr));
    /* [i] 'Q' to differentiate from v3 */
    io_hdr.guard = 'Q';
    err = bsg_read(s->bs->fd, &io_hdr, sizeof(io_hdr));
    if (err) {
        DPRINTF("bsg_read() failed with ret: %d\n", err);
        bsg_command_complete(r, EBADR);
        return;
    }

    len = r->bsg_hdr.din_xfer_len - r->bsg_hdr.din_resid;
    DPRINTF_BSG_IO("BSG READ Data ready tag=0x%x len=%d\n", r->req.tag, len);

    r->len = -1;
    r->req.bus->complete(&r->req, SCSI_REASON_DATA, len);
}

and into the megasas HBA callback and double-qemu_free segfault for
cmd->iov here:

static void megasas_unmap_sgl(struct megasas_cmd_t *cmd)
{
    uint16_t flags = le16_to_cpu(cmd->frame->header.flags);
    int i, is_write = (flags & MFI_FRAME_DIR_WRITE) ? 1 : 0;

    for (i = 0; i < cmd->frame->header.sge_count; i++) {
        cpu_physical_memory_unmap(cmd->iov[i].iov_base, cmd->iov[i].iov_len,
                                  is_write, cmd->iov[i].iov_len);
    }
    qemu_free(cmd->iov);
}

So it appears to be something wrt to polling BSG polling AIO reads on this
5500 series system, which is the first time I have tried BSG on Nehalem.  ;)

The same megasas+scsi-bsg code appears to work fine on a E8400 @ 3.00GHz based
FSB system with a .37-rc2 KVM host w/o no major drivers/target/ host changes
with same TCM_loop backstores into Linux/KVM guest, etc..

Interestingly enough, the same TCM_Loop backends with lsi53c895a using:

	-drive if=none,id=mydisk1,file=/dev/bsg/8\:0\:1\:0 \
		-device lsi -device scsi-bsg,scsi-id=1,drive=mydisk1
	
appear to be working just fine at high speed large block tests with scsi-bsg
into .37-rc3 KVM guest. (screenshot here :)

http://www.linux-iscsi.org/index.php/File:TCM_Loop-lsi53c895a-37-rc3.png

So it appears to be a megasas HBA emulation specific issue..  Any idea Hannes..?

--nab


