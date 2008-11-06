From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: megaraid kernel 2.6.26.5 /proc oops
Date: Thu, 6 Nov 2008 10:55:31 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C32D443C77@cosmail02.lsi.com>
References: <20081106174733.GH10247@x-berg.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55467 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYKFRzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 12:55:49 -0500
In-Reply-To: <20081106174733.GH10247@x-berg.in-berlin.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Osterried <thomas@x-berg.in-berlin.de>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thomas,

James pushed the fix to 2.6.27 kernel.  Please see:

Regards,

Bo Yang
---------------------
Your commit:

    [SCSI] megaraid: fix mega_internal_command oops

    scsi_cmnd->cmnd was changed from a static array to a pointer post
    2.6.25. It breaks mega_internal_command():

    static int
    mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
    {
    ...
        scb = &adapter->int_scb;
        memset(scb, 0, sizeof(scb_t));

        scmd = &adapter->int_scmd;
        memset(scmd, 0, sizeof(Scsi_Cmnd));

        sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
        scmd->device = sdev;

        scmd->device->host = adapter->host;
        scmd->host_scribble = (void *)scb;
        scmd->cmnd[0] = MEGA_INTERNAL_CMD;

    mega_internal_command() uses scsi_cmnd allocated internally so
    scmd->cmnd is NULL here. This patch adds a static array for cdb to
    adapter_t and uses it here. This also uses
    scsi_allocate_command/scsi_free_command, the recommended way to
    allocate struct scsi_cmnd since the driver might use sense_buffer in
    struct scsi_cmnd.

    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
    Tested-by: Pascal Terjan <pterjan@gmail.com>
    Reported-by: Pascal Terjan <pterjan@gmail.com>
    Acked-by: "Yang, Bo" <Bo.Yang@lsi.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

has been added to the upstream SCSI tree You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=6b0eea21efed26f92e18741e54a3121cf5cd197e

This patch is scheduled to be pushed for 2.6.27

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on the header:

X-Git-Tree: SCSI


-----------------------

-----Original Message-----
From: Thomas Osterried [mailto:thomas@x-berg.in-berlin.de]
Sent: Thursday, November 06, 2008 12:48 PM
To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
Subject: megaraid kernel 2.6.26.5 /proc oops

Hello,

last month, i sent this report to megaraidlinux@lsi.com, but
unfortunately i get no response. Today we have tried kernel 2.6.27.4,
which still segfaults with cat /proc/megaraid/hba0/raiddrives-0-9

Regards,
        - Thomas Osterried

On 2008-10-01 15:01:51 +0200, Thomas Osterried <thomas@x-berg.in-berlin.de>
wrote in <20081001130151.GN10788@x-berg.in-berlin.de>:
> Hello,
>
> with kernel 2.6.26.5 we get a segfault (userspace) and kernel oops
> while trying to access megaraid's /proc data.
> Our previous kernel 2.6.24.2 did not has shown this error.
>
> cat /proc/megaraid/hba0/config - is ok
> cat /proc/megaraid/hba0/stat - is ok
> cat /proc/megaraid/hba0/rebuild-rate - leads to "Segementation fault"
> cat /proc/megaraid/hba0/raiddrives-0-9 - leads to "Segementation fault"
>
> The error is reproduceable after each new boot.
>
> Controller:
>
> 03:03.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 02) (prog-if
>  01)
>         Subsystem: Hewlett-Packard Company MegaRAID, Integrated HP NetRAID
>         Flags: bus master, fast Back2Back, medium devsel, latency 64, IRQ 21
>         Memory at f6000000 (32-bit, prefetchable) [size=32M]
>         [virtual] Expansion ROM at 88030000 [disabled] [size=32K]
>         Capabilities: <access denied>
>
> Kernel Config:
> # CONFIG_MEGARAID_NEWGEN is not set
> CONFIG_MEGARAID_LEGACY=y
> # CONFIG_MEGARAID_SAS is not set
>
>
> root@db0fhn:~# uname -a
> Linux db0fhn 2.6.26.5-dg8ngn #1 SMP Mon Sep 29 01:53:21 CEST 2008 i686 GNU/Linux
> root@db0fhn:~#
>
> kernel complains (dmesg):
>
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c0208360>] mega_internal_command+0x79/0x12a
> *pde = 00000000
> Oops: 0002 [#1] SMP
> Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async ppp_generic slhc tun bitrev crc32 mkiss ax25 crc16 iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT iptable_filter iptable_mangle xt_MARK ipv6 ipip tunnel4 ide_cd_mod cdrom aic7xxx scsi_transport_spi parport_serial parport_pc parport i2c_piix4 netconsole genrtc
>
> Pid: 8156, comm: cat Not tainted (2.6.26.5-dg8ngn #1)
> EIP: 0060:[<c0208360>] EFLAGS: 00010246 CPU: 1
> EIP is at mega_internal_command+0x79/0x12a
> EAX: 00000000 EBX: f7f559d4 ECX: 00000000 EDX: f72a6000
> ESI: f62e5000 EDI: f7f55b04 EBP: f7f55a58 ESP: f6301ec8
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process cat (pid: 8156, ti=f6300000 task=f6306f50 task.ti=f6300000)
> Stack: 00000000 f6301ef2 f7f554dc f7f55b04 f72a6000 f7f554dc f62e5000 f6301f04
>        f5064000 c0208454 0004484c 00000000 50000000 0000362e 00000000 f71e4800
>        f71e484c c020a06c 362e5000 c020a010 f7f5b3e0 f5064000 00000400 c018b1fc
> Call Trace:
>  [<c0208454>] mega_adapinq+0x43/0x50
>  [<c020a06c>] proc_rebuild_rate+0x5c/0x117
>  [<c020a010>] proc_rebuild_rate+0x0/0x117
>  [<c018b1fc>] proc_file_read+0xd6/0x1ff
>  [<c018b126>] proc_file_read+0x0/0x1ff
>  [<c01878ef>] proc_reg_read+0x60/0x73
>  [<c018788f>] proc_reg_read+0x0/0x73
>  [<c015e4bc>] vfs_read+0x81/0xf4
>  [<c015e8af>] sys_read+0x3c/0x63
>  [<c01037f6>] syscall_call+0x7/0xb
>  =======================
> Code: c0 ba d0 80 00 00 e8 13 30 f5 ff 8b 54 24 08 89 44 24 10 89 82 7c 05 00 00 8b 42 40 8b 54 24 10 89 02 8b 45 34 89 9d a0 00 00 00 <c6> 00 e1 83 4b 04 01 89 6b 5c 8b 7c 24 08 8b 74 24 04 81 c7 08
> EIP: [<c0208360>] mega_internal_command+0x79/0x12a SS:ESP 0068:f6301ec8
> ---[ end trace c8150e49c4aef69e ]---
>
> Another Test after reboot:
>
> root@db0fhn:~# cat  /proc/megaraid/hba0/raiddrives-0-9
> Segmentation fault
>
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c0208360>] mega_internal_command+0x79/0x12a
> *pde = 00000000
> Oops: 0002 [#1] SMP
> Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async ppp_generic slhc tun bitrev crc32 mkiss ax25 crc16 iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT iptable_filter iptable_mangle xt_MARK ipv6 ipip tunnel4 ide_cd_mod cdrom aic7xxx scsi_transport_spi parport_serial parport_pc parport i2c_piix4 netconsole genrtc
>
> Pid: 6871, comm: cat Not tainted (2.6.26.5-dg8ngn #1)
> EIP: 0060:[<c0208360>] EFLAGS: 00010246 CPU: 0
> EIP is at mega_internal_command+0x79/0x12a
> EAX: 00000000 EBX: f7f559d4 ECX: 00000000 EDX: f71f3800
> ESI: f7ce0414 EDI: f7f55b04 EBP: f7f55a58 ESP: f6663e8c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process cat (pid: 6871, ti=f6662000 task=f66c4f30 task.ti=f6662000)
> Stack: 00000000 f6663eb6 f7f554dc f7f55b04 f71f3800 f7f554dc f7ce0414 f6663ec8
>        f7217800 c0208454 0004784c 00000000 50000000 0000366a 00000000 f6393000
>        f7217c14 c0208a19 00000000 f7f554dc 00000000 c0147617 c035a6a0 f66a5000
> Call Trace:
>  [<c0208454>] mega_adapinq+0x43/0x50
>  [<c0208a19>] proc_rdrv+0x60/0x46b
>  [<c0147617>] __alloc_pages_internal+0xc1/0x356
>  [<c0208e8a>] proc_rdrv_10+0x0/0x1f
>  [<c018b1fc>] proc_file_read+0xd6/0x1ff
>  [<c018b126>] proc_file_read+0x0/0x1ff
>  [<c01878ef>] proc_reg_read+0x60/0x73
>  [<c018788f>] proc_reg_read+0x0/0x73
>  [<c015e4bc>] vfs_read+0x81/0xf4
>  [<c015e8af>] sys_read+0x3c/0x63
>  [<c01037f6>] syscall_call+0x7/0xb
>  =======================
> Code: c0 ba d0 80 00 00 e8 13 30 f5 ff 8b 54 24 08 89 44 24 10 89 82 7c 05 00 00 8b 42 40 8b 54 24 10 89 02 8b 45 34 89 9d a0 00 00 00 <c6> 00 e1 83 4b 04 01 89 6b 5c 8b 7c 24 08 8b 74 24 04 81 c7 08
> EIP: [<c0208360>] mega_internal_command+0x79/0x12a SS:ESP 0068:f6663e8c
> ---[ end trace 8e4e31f4cfef4759 ]---
>
>
> Kindly regards,
>
>       - Thomas Osterried
