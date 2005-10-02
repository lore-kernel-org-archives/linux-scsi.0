From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [oops] rmmod aic7xyz (2.6.14-rc3 and 2.6.13)
Date: Sun, 02 Oct 2005 11:16:54 +0200
Message-ID: <433FA586.8020002@s5r6.in-berlin.de>
References: <20051001221746.54d26f43.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37312 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751029AbVJBJRJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Oct 2005 05:17:09 -0400
In-Reply-To: <20051001221746.54d26f43.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, jejb <james.bottomley@steeleye.com>

Randy.Dunlap wrote:
> trivial to reproduce:
> 
> modprobe aic7xxx
> mount -t ext3 -o data=writeback /dev/sda4 /media/zip
> ls -l /media/zip
> umount /media/zip
> rmmod aic7xxx ---> oops
[...]
> Oct  1 21:51:27 midway kernel: [42958200.670000] Synchronizing SCSI cache for disk sda: 
> Oct  1 21:51:27 midway kernel: [42958200.670000] Unable to handle kernel paging request at virtual address e4bff163
[...]
> Oct  1 21:51:27 midway kernel: [42958200.670000] EIP is at ahc_linux_run_command+0x58f/0x6ce [aic7xxx]
[...]
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<f9f7193c>] ahc_linux_queue+0x51/0x5c [aic7xxx]
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c22cb>] scsi_dispatch_cmd+0x209/0x293
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c7c0c>] scsi_request_fn+0x287/0x31b
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02865ba>] __generic_unplug_device+0x20/0x25
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02865d7>] generic_unplug_device+0x18/0x28
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02871a9>] blk_execute_rq_nowait+0x38/0x3d
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0287254>] blk_execute_rq+0xa6/0xcd
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c6ae4>] scsi_execute+0xaf/0xc9
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c6b4f>] scsi_execute_req+0x51/0x76
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02cfbd9>] sd_sync_cache+0x4f/0xab
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02d114e>] sd_shutdown+0x34/0x39
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02d108e>] sd_remove+0x1c/0x5f
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02803be>] __device_release_driver+0x56/0x70
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0280400>] device_release_driver+0x28/0x3b
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c027fcd9>] bus_remove_device+0x57/0x69
> Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c027eeef>] device_del+0x2f/0x5e
> Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02ca764>] __scsi_remove_device+0x2e/0x69
> Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02c9a44>] scsi_forget_host+0x3b/0x62
> Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02c2dd1>] scsi_remove_host+0x76/0xde
> Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f7289e>] ahc_platform_free+0x29/0x148 [aic7xxx]
> Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f679ca>] ahc_free+0x79/0xc8 [aic7xxx]
> Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f75345>] ahc_linux_pci_dev_remove+0x41/0x48 [aic7xxx]
[...]

The solution is probably to add calls to scsi_remove_device() for each 
device on the host as first action in ahc_linux_pci_dev_remove(). That 
way, scsi high-level drivers are able to perform their shutdown 
functions before the host adapter ceases to operate.

More care needs to be taken for hotswappable hardware. I don't know if 
aic7xxx falls into this category. If yes, ahc_linux_queue() must be made 
aware of that the adapter is gone and has to immediately complete any 
commands with DID_NO_CONNECT. Similarly, the eh handlers should take 
shortcuts when the adpater is gone.

AFAIK.
-- 
Stefan Richter
-=====-=-=-= =-=- ---=-
http://arcgraph.de/sr/
