From: Brian King <brking@us.ibm.com>
Subject: Re: SD driver and 8KB HW sector size
Date: Fri, 29 Oct 2004 13:27:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41828BAE.1070308@us.ibm.com>
References: <33829B7061BDB84FAD9EB9EA1F5371B4015AC3F0@tsc.hermes.si>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:6335 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S263458AbUJ2S2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 14:28:23 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9TIS0Ex429226
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 14:28:00 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9TIS0Rw093048
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 12:28:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9TIRxrO007677
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 12:27:59 -0600
In-Reply-To: <33829B7061BDB84FAD9EB9EA1F5371B4015AC3F0@tsc.hermes.si>
List-Id: linux-scsi@vger.kernel.org
To: Luka Renko <luka.renko@hermes.si>
Cc: linux-scsi@vger.kernel.org, Steve McIntyre <smcintyre@software.plasmon.com>, Damjan Lango <damjan.lango@hermes.si>

Please try a 2.6.10-rc1 kernel. There was a fix that went in recently
for a problem I ran into that should fix your problem as well.

-Brian

Luka Renko wrote:
> Hello,
>  
> SCSI Disk Driver in Linux 2.6 on i386 supports only devices with up-to 4KB
> sector size. Large sector size is not supported by block layer as it is
> expected that sector size is smaller or equal than page size (4KB).
>  
> We have a device (magneto-optical disk) that has 8 KB HW sector size. We
> would like to use it from user space via SCSI Generic driver. The problem is
> that SCSI Disk Driver claims this device and registers it as /dev/sd device.
> This is not a big problem per-se (as raw CDB can be sent over SD driver
> too), but causes problems to Linux partitioning code. In some cases (first
> open() after disk change?), Linux partitioning code gets executed, which
> causes Oops (FC2 kernel 2.6.5-1.358):
>  
> sda : READ CAPACITY failed.
> sda : status=0, message=00, host=1, driver=00
> sda : sense not available.
> sda: Write Protect is off
> sda: Mode Sense: 00 00 00 00
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sda : READ CAPACITY failed.
> sda : status=0, message=00, host=1, driver=00
> sda : sense not available.
> sda: Write Protect is off
> sda: Mode Sense: 00 00 00 00
> sda: asking for cache data failed
> sda: assuming drive cache: write through
>  sda:<1>Unable to handle kernel NULL pointer dereference at virtual address
> 00000000
>  printing eip:
> 02143452
> *pde = 00000000
> Oops: 0002 [#1]
> CPU:    0
> EIP:    0060:[<02143452>]    Not tainted
> EFLAGS: 00010287   (2.6.5-1.358)
> EIP is at create_empty_buffers+0x14/0x54
> eax: 00000000   ebx: 030adb20   ecx: 00000000   edx: 00000000
> esi: 00000000   edi: 030adb20   ebp: 030adb20   esp: 06d42d24
> ds: 007b   es: 007b   ss: 0068
> Process udomkfs (pid: 8150, threadinfo=06d42000 task=05236eb0)
> Stack: 00000000 030adb20 02143be1 00000046 09f8b77c 00000001 09f8b784
> 00002000
>        00000001 0218f700 030adb20 00000000 09f8b77c 09f8b6e0 021467f1
> 09f8b778
>        00000000 0212b9a7 00000000 030adb20 030adb20 09f8b778 0212b9de
> 00000000
> 
> Call Trace:
>  [<02143be1>] block_read_full_page+0x4f/0x26e
>  [<0218f700>] radix_tree_insert+0x6d/0xe2
>  [<021467f1>] blkdev_get_block+0x0/0x47
>  [<0212b9a7>] add_to_page_cache+0x3a/0x64
>  [<0212b9de>] add_to_page_cache_lru+0xd/0x20
>  [<0212cb5a>] read_cache_page+0x81/0x110
>  [<021468e0>] blkdev_readpage+0x0/0xc
>  [<02169bb1>] read_dev_sector+0x26/0x7c
>  [<0216aca7>] read_lba+0x56/0x9b
>  [<0216adb6>] alloc_read_gpt_header+0x4e/0x6b
>  [<0216ae06>] is_gpt_valid+0x33/0x103
>  [<0216b1fa>] find_valid_gpt+0x75/0x2de
>  [<0216b48d>] efi_partition+0x2a/0x251
>  [<0212ea1b>] __alloc_pages+0x9c/0x281
>  [<02115ed2>] __wake_up_common+0x2f/0x50
>  [<02115f01>] __wake_up+0xe/0x16
>  [<021189cd>] printk+0x106/0x113
>  [<021695ab>] disk_name+0x1f/0x60
>  [<021696dd>] check_partition+0x8f/0xd1
>  [<02169b06>] rescan_partitions+0x7d/0x102
>  [<02146d95>] check_disk_change+0x3f/0x59
>  [<0a8285e7>] sd_open+0xe3/0xf6 [sd_mod]
>  [<0214706b>] do_open+0x24b/0x340
>  [<021471e8>] blkdev_open+0x1a/0x46
>  [<02140a6a>] dentry_open+0xc2/0x171
>  [<021409a2>] filp_open+0x36/0x3c
>  [<02140cde>] sys_open+0x31/0x7d
> 
> I have looked through the code and it seems to me that partitioning code
> asumes in some places that sector size is 512 bytes. This might be OK on
> CD-ROM or similar as they emulate 512 byte IO even with larger HW sector
> sizes (if I remember correctly), however it does not work if we have a
> device with > 4KB HW sector size.
> 
> I see two options to fix/workaround this problem:
> 1. Prevent partitioning code to be executed if block device does not support
> proper sector size 
> 2. Prevent SCSI Disk driver to claim a device if sector size is not
> supported
> (in that case SCSI Generic driver should claim it)
> 
> We would like to explore one of the above options, but I would need some
> advice from the mailing list which of the above would be a better way to
> support such devices.
> 
> Regards,
> Luka
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

