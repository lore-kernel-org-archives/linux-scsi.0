From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: 2.6.25-git18 ipr panic (was [PATCH 1/1] ipr: Rename ipr's state
	scsi host attribute to prevent collisions)
Date: Fri, 02 May 2008 08:49:28 -0700
Message-ID: <1209743368.16169.16.camel@badari-desktop>
References: <12094221802009-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:55156 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935704AbYEBPtV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:49:21 -0400
In-Reply-To: <12094221802009-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Gregkh@suse.de
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, wayneb@linux.vnet.ibm.com, pbadari@linux.vnet.ibm.com


On Mon, 2008-04-28 at 17:36 -0500, Brian King wrote:
> Due to recent SCSI core changes which add a scsi host attribute
> named "state", this now collides with an ipr driver scsi host attribute
> with the same name, preventing ipr from loading. Rename the ipr driver
> attribute to be more specific.
> 
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6-bjking1/drivers/scsi/ipr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/ipr.c~ipr_host_state_rename drivers/scsi/ipr.c
> --- linux-2.6/drivers/scsi/ipr.c~ipr_host_state_rename	2008-04-28 17:30:54.000000000 -0500
> +++ linux-2.6-bjking1/drivers/scsi/ipr.c	2008-04-28 17:31:21.000000000 -0500
> @@ -2791,7 +2791,7 @@ static ssize_t ipr_store_adapter_state(s
> 
>  static struct device_attribute ipr_ioa_state_attr = {
>  	.attr = {
> -		.name =		"state",
> +		.name =		"online_state",
>  		.mode =		S_IRUGO | S_IWUSR,
>  	},
>  	.show = ipr_show_adapter_state,
> _

Could this be be pushed to mainline ? I am not able to boot 2.6.25-git18
due to this.

Thanks,
Badari

sysfs: duplicate filename 'state' can not be created
------------[ cut here ]------------
Badness at fs/sysfs/dir.c:425
NIP: c000000000139760 LR: c00000000013975c CTR: 800000000013f270
REGS: c0000000700db240 TRAP: 0700   Not tainted  (2.6.25-git18)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 22002024  XER: 00000006
TASK = c0000000700d7390[1] 'swapper' THREAD: c0000000700d8000 CPU: 0
GPR00: c00000000013975c c0000000700db4c0 c000000000710db8 0000000000000038 
GPR04: 0000000000000001 0000000000000001 0000000000000000 0000000000000001 
GPR08: c00000000073d5fc c000000000649f90 0000000000003ad8 c00000000073d5f8 
GPR12: 0000000000004000 c000000000733300 0000000000000000 0000000000000000 
GPR16: 0000000000000000 d000080080080000 c00000000063b150 c00000006e72c708 
GPR20: c00000006e72c650 c00000006e72c000 c00000007044d1a8 c00000007044d000 
GPR24: c00000007044d070 c00000007044d000 c00000006e72c3b0 c00000006e72c170 
GPR28: 0000000000000000 c0000000700db5c0 c0000000006975c8 c00000006e71a7d0 
NIP [c000000000139760] .sysfs_add_one+0x50/0xec
LR [c00000000013975c] .sysfs_add_one+0x4c/0xec
Call Trace:
[c0000000700db4c0] [c00000000013975c] .sysfs_add_one+0x4c/0xec (unreliable)
[c0000000700db550] [c000000000138edc] .sysfs_add_file_mode+0x70/0xe0
[c0000000700db600] [c00000000031f5d4] .device_create_file+0x20/0x3c
[c0000000700db680] [c0000000003758f0] .scsi_sysfs_add_host+0x54/0xc4
[c0000000700db710] [c00000000036a0b0] .scsi_add_host+0x1d4/0x264
[c0000000700db7b0] [c0000000004cb294] 0xc0000000004cb294
[c0000000700db920] [c0000000002cfb50] .pci_device_probe+0x100/0x170
[c0000000700db9e0] [c000000000322850] .driver_probe_device+0x118/0x1f8
[c0000000700dba70] [c000000000322998] .__driver_attach+0x68/0xac
[c0000000700dbb00] [c000000000321d10] .bus_for_each_dev+0x80/0xd0
[c0000000700dbbb0] [c00000000032259c] .driver_attach+0x28/0x40
[c0000000700dbc30] [c00000000032122c] .bus_add_driver+0xf4/0x2dc
[c0000000700dbce0] [c000000000322c80] .driver_register+0xc0/0x198
[c0000000700dbd80] [c0000000002cfef8] .__pci_register_driver+0x5c/0xcc
[c0000000700dbe10] [c0000000005edcb4] .ipr_init+0x38/0x50
[c0000000700dbe90] [c0000000005c03f8] .kernel_init+0x200/0x398
[c0000000700dbf90] [c000000000023fac] .kernel_thread+0x4c/0x68
Instruction dump:
f821ff71 60000000 60000000 e8630000 e8840018 4bfffdc1 2fa30000 41be0020 
e89f0018 e87e8020 4bf1f22d 60000000 <0fe00000> 3860ffef 48000078 e93d0000 
ipr: probe of 0000:d0:01.0 failed with error -17
st: Version 20080224, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
IPv4 over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
VFS: Cannot open root device "sdb3" or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available partitions:
0100       4096 ram0 (driver?)
0101       4096 ram1 (driver?)
0102       4096 ram2 (driver?)
0103       4096 ram3 (driver?)
0104       4096 ram4 (driver?)
0105       4096 ram5 (driver?)
0106       4096 ram6 (driver?)
0107       4096 ram7 (driver?)
0108       4096 ram8 (driver?)
0109       4096 ram9 (driver?)
010a       4096 ram10 (driver?)
010b       4096 ram11 (driver?)
010c       4096 ram12 (driver?)
010d       4096 ram13 (driver?)
010e       4096 ram14 (driver?)
010f       4096 ram15 (driver?)
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)


