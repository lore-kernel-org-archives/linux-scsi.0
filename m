From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Fri, 9 Apr 2004 10:17:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040409101729.A3121@beaverton.ibm.com>
References: <1081518779.2203.29.camel@mulgrave> <20040409095657.A2970@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:35713 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261416AbUDIRRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 13:17:53 -0400
Content-Disposition: inline
In-Reply-To: <20040409095657.A2970@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Apr 09, 2004 at 09:56:57AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

I spoke a bit too soon, a remove module is giving me an oops.

Running scsi-misc-2.6 + this patch. I did not try scsi-misc-2.6 plain.

I loaded the qla2300 module, removed a single lun via the sysfs interface,
and then rmmod qla2300.

Let me know if you need any other information.

elm3b79.beaverton.ibm.com login: Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c01ea4b3
*pde = 33da1001
Oops: 0000 [#1]
SMP 
CPU:    2
EIP:    0060:[<c01ea4b3>]    Not tainted
EFLAGS: 00010286   (2.6.5-rc2) 
EIP is at scsi_device_set_state+0xa3/0xe4
eax: 00000000   ebx: 00000004   ecx: 00000003   edx: 00000018
esi: f416f000   edi: c02eae38   ebp: f3d22000   esp: f3d23e94
ds: 007b   es: 007b   ss: 0068
Process modprobe (pid: 1493, threadinfo=f3d22000 task=f3e6a6d0)
Stack: f416f1e0 c02b5688 c02b5690 00000003 f416f000 f4182000 c01ec39a f416f000 
       00000003 f3e40000 f4182000 c01eba42 f416f000 f3e40000 f4ba0c44 c01e57cd 
       f3e40000 f3e40000 f3e40000 00000000 f3e401c8 f88af667 f3e40000 f3e400e8 
Call Trace:
 [<c01ec39a>] scsi_remove_device+0xe/0x88
 [<c01eba42>] scsi_forget_host+0x32/0x60
 [<c01e57cd>] scsi_remove_host+0x19/0x48
 [<f88af667>] qla2x00_remove_one+0x6f/0x8c [qla2xxx]
 [<f88c9022>] qla2300_remove_one+0xa/0x10 [qla2300]
 [<c01a5fe2>] pci_device_remove+0x1a/0x34
 [<c01c77aa>] device_release_driver+0x46/0x58
 [<c01c77d9>] driver_detach+0x1d/0x2c
 [<c01c79b5>] bus_remove_driver+0x29/0x5c
 [<c01c7ceb>] driver_unregister+0xb/0x1f
 [<c01a6166>] pci_unregister_driver+0xe/0x1c
 [<f88c9032>] qla2300_exit+0xa/0x10 [qla2300]
 [<c012d0d5>] sys_delete_module+0x141/0x174
 [<c01405f0>] sys_munmap+0x38/0x58
 [<c0106b93>] syscall_call+0x7/0xb

Code: 8b 00 50 68 60 4c 2b c0 e8 24 f7 f2 ff 83 c4 18 68 68 06 00 

-- Patrick Mansfield
