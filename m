From: christophe.varoqui@free.fr
Subject: [BUG] scsi / genhd badness
Date: Mon, 28 Oct 2002 16:20:30 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035818430.3dbd55be25447@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imp4-1.free.fr (imp4-1.free.fr [213.228.0.57])
	by postfix4-1.free.fr (Postfix) with ESMTP id 493512964
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 16:20:30 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, 
 
I'd like to report an annoying behaviour : 
 
On a server with scsi disk behind an aic7xxx, kernel 2.5.44-ac4, each time I 
remove a disk from the linux scsi subsystem (echo "scsi remove-single-device a 
b c d">/proc/scsi/scsi) I get the following oops (server survive) : 
 
Badness in put_device at drivers/base/core.c:139 
Call Trace: 
 [<c01d12ae>] put_device+0xde/0xf0 
 [<c022c1ff>] sg_detach+0x8f/0x1f0 
 [<c02121d8>] proc_scsi_gen_write+0x338/0x4b0 
 [<c014d6c6>] open_namei+0xa6/0x400 
 [<c01658e0>] proc_file_write+0x40/0x50 
 [<c014047c>] vfs_write+0xdc/0x150 
 [<c014058e>] sys_write+0x3e/0x60 
 [<c010772b>] syscall_call+0x7/0xb 
 
the block event gets passed to the hotplug layer. 
Driverfs loose the $driverfs/bus/block/device/ (and $driverfs/root/) disk entry 
: right 
 
On the other hand, when I re-add this disk, hotplug is not notified and disk 
entry does not re-appear in driverfs. 
 
Other sybsystems are not similarily affected : device-mapper gives the oops on 
device map removal but devmap addition get rightly notified to userspace. 
 
Is it a known short-coming ? 
 
regards, 
cvaroqui 
