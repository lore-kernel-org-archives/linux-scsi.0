From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Tue, 22 Sep 2009 17:16:26 +0900
Message-ID: <200909221716.BGC60960.MQOOJFFFHtOVLS@I-love.SAKURA.ne.jp>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
	<7b6bb4a50909212203m19ed8276l5aab1fb4ea58c574@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wine.ocn.ne.jp ([122.1.235.145]:63677 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZIVIQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2009 04:16:27 -0400
In-Reply-To: <7b6bb4a50909212203m19ed8276l5aab1fb4ea58c574@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xtfeng@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello.

Xiaotian Feng wrote:
> Can this patch fix your leak?
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index c447838..b0d3984 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -318,6 +318,7 @@ out_device_destroy:
>  	scsi_device_set_state(sdev, SDEV_DEL);
>  	transport_destroy_device(&sdev->sdev_gendev);
>  	put_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  out:
>  	if (display_failure_msg)
>  		printk(ALLOC_FAILURE_MSG, __func__);
> @@ -958,6 +959,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(&sdev->sdev_gendev);
>  	put_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  }
>  
>  #ifdef CONFIG_SCSI_LOGGING

No. I got slab corruption message for 14 times after applying this patch.
Isn't this patch calling put_device(&sdev->sdev_dev); more than needed?

kmemleak: Kernel memory leak detector initialized
kmemleak: Automatic memory scanning thread started
Freeing unused kernel memory: 300k freed
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
SCSI subsystem initialized
Fusion MPT base driver 3.04.10
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.10
mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 B0, FwRev=00000000h, Ports=1, MaxQ=128, IRQ=17
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
sd 0:0:0:0: [sda] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda:
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<(null)>](0x0)
000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
 sda1
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
Slab corruption: size-1024 start=deb62f48, len=1024
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<c0486122>](kfree+0x49/0x50)
180: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=deb62b30, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 62 6c 6f 63 6b 2f 73 64 61 00 41
010: 43 54 49 4f 4e 3d 61 64 64 00 44 45 56 50 41 54
Next obj: start=deb63360, len=1024
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<c04efd04>](kobject_uevent_env+0x23b/0x35c)
000: 61 64 64 40 2f 63 6c 61 73 73 2f 73 63 73 69 5f
010: 64 65 76 69 63 65 2f 30 3a 30 3a 30 3a 30 00 41
