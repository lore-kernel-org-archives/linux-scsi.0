From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in	drivers/scsi/scsi_lib.c
Date: Wed, 27 Oct 2004 01:29:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417F5C64.7090704@us.ibm.com>
References: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>	<Pine.GSO.4.58.0410260947280.22299@boromir> <417E9163.8010904@us.ibm.com> 	<417E92AB.5020406@us.ibm.com> <1098842044.1762.688.camel@mulgrave> <417F4307.7090405@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:15774 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262331AbUJ0I3e
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 04:29:34 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9R8TWJ8381454
	for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2004 04:29:33 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9R8TWd6122118
	for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2004 02:29:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9R8TVw3015225
	for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2004 02:29:32 -0600
In-Reply-To: <417F4307.7090405@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mateusz.Blaszczyk@nask.pl, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>

Mike Christie wrote:
> James Bottomley wrote:
> 
>> On Tue, 2004-10-26 at 14:08, Mike Christie wrote:
>>
>>>> The null state and and oops are becuase of this
>>>> http://marc.theaimsgroup.com/?l=linux-scsi&m=109733573729283&w=2
>>>
>>>
>>> Oh yeah. that patch is not correct, but if you correctly modify it to
>>> use device_for_each_child per Christoph's suggestion, I seem to be
>>> getting some refcounting errors. For some reason the sdev will be
>>> released, but the sd.c still thinks it is there.
>>
>>
>>
>> Actually, he suggested using shost_for_each_device.  The reason being
>> that you can't have nested device_for_each_child (because it takes the
>> bus semaphore).
> 
> 
> Oops, I meant to write shost_for_each_device above.
> 
>> The attached should do this, if someone would care to try it out.
> 
> 
> I get the oops below by doing the following.
> 
> 1. plug in usb storage device
> 2. open device ("fdisk /dev/sda" or run disktest on /dev/sda for
> example)
> 3. unplug device
> 4. close device
> 
> If I stick printks in the scsi release functions I see the problem
> described above where the scsi device is freed and then sd_release
> is called.
> 
> 
> Oops below with 2.6.10-rc1-mm1y
> 
> Oct 26 23:32:54 mina kernel: usb 2-2: USB disconnect, address 2
> Oct 26 23:32:54 mina kernel:  0:0:0:0: Illegal state transition 
> deleted->cancel
> Oct 26 23:32:54 mina kernel: Badness in scsi_device_set_state at 
> drivers/scsi/scsi_lib.c:1713
> Oct 26 23:32:54 mina kernel:  [<c010570e>] dump_stack+0x1e/0x30
> Oct 26 23:32:54 mina kernel:  [<f88314a6>] 
> scsi_device_set_state+0xc6/0x130 [scsi_mod]
> Oct 26 23:32:54 mina kernel:  [<f8829146>] scsi_device_cancel+0x26/0x243 
> [scsi_mod]
> Oct 26 23:32:54 mina kernel:  [<f88293ec>] scsi_host_cancel+0x3c/0xd0 
> [scsi_mod]
> Oct 26 23:32:54 mina kernel:  [<f88294a2>] scsi_remove_host+0x22/0x70 
> [scsi_mod]
> Oct 26 23:32:54 mina kernel:  [<f88e9cc9>] storage_disconnect+0x99/0xae 
> [usb_storage]
> Oct 26 23:32:54 mina kernel:  [<c02fb9b6>] usb_unbind_interface+0x86/0x90
> Oct 26 23:32:54 mina kernel:  [<c02c14e6>] device_release_driver+0x66/0x70
> Oct 26 23:32:54 mina kernel:  [<c02c178f>] bus_remove_device+0x7f/0xc0
> Oct 26 23:32:54 mina kernel:  [<c02c044f>] device_del+0x6f/0xb0
> Oct 26 23:32:54 mina kernel:  [<c0305868>] usb_disable_device+0xb8/0x100
> Oct 26 23:32:54 mina kernel:  [<c02fea76>] usb_disconnect+0xc6/0x2e0
> Oct 26 23:32:54 mina kernel:  [<c03001f6>] 
> hub_port_connect_change+0x6a6/0x6e0
> Oct 26 23:32:54 mina kernel:  [<c0300561>] hub_events+0x331/0x5a0
> Oct 26 23:32:54 mina kernel:  [<c0300805>] hub_thread+0x35/0x110
> Oct 26 23:32:54 mina kernel:  [<c01025a5>] kernel_thread_helper+0x5/0x10
> Oct 26 23:32:55 mina kernel: Unable to handle kernel paging request at 
> virtual address 6b6b6c7b
> Oct 26 23:32:55 mina kernel:  printing eip:
> Oct 26 23:32:55 mina kernel: f882b8ce
> Oct 26 23:32:55 mina kernel: *pde = 00000000
> Oct 26 23:32:55 mina kernel: Oops: 0000 [#1]
> Oct 26 23:32:55 mina kernel: PREEMPT
> Oct 26 23:32:55 mina kernel: Modules linked in: sd_mod usb_storage 
> ide_cd cdrom sg scsi_mod rd
> Oct 26 23:32:55 mina kernel: CPU:    0
> Oct 26 23:32:55 mina kernel: EIP:    0060:[<f882b8ce>]    Not tainted VLI
> Oct 26 23:32:55 mina kernel: EFLAGS: 00010296   (2.6.10-rc1-mm1y)
> Oct 26 23:32:55 mina kernel: EIP is at 
> scsi_block_when_processing_errors+0xe/0xe0 [scsi_mod]
> Oct 26 23:32:55 mina kernel: eax: 00000000   ebx: 6b6b6b6b   ecx: 
> f88ef640   edx: ec5b6578
> Oct 26 23:32:55 mina kernel: esi: e9baa4b8   edi: c17e9268   ebp: 
> e9677f0c   esp: e9677eb4
> Oct 26 23:32:55 mina kernel: ds: 007b   es: 007b   ss: 0068
> Oct 26 23:32:55 mina kernel: Process fdisk (pid: 2891, 
> threadinfo=e9676000 task=ea0c61f0)
> Oct 26 23:32:55 mina kernel: Stack: 00000000 00000001 00000000 00000000 
> 00000000 00000000 00000000 00000000
> Oct 26 23:32:55 mina kernel:        00000000 00000000 00000003 e9677ef0 
> c17e9268 0000006b c17e9268 e9677f0c
> Oct 26 23:32:55 mina kernel:        c0159761 c17e93e4 00000000 e9b98780 
> e9baa4b8 c17e9268 e9677f24 f88ef6a8
> Oct 26 23:32:55 mina kernel: Call Trace:
> Oct 26 23:32:55 mina kernel:  [<c01056cf>] show_stack+0x7f/0xa0
> Oct 26 23:32:55 mina kernel:  [<c0105876>] show_registers+0x156/0x1c0
> Oct 26 23:32:55 mina kernel:  [<c0105af6>] die+0x156/0x2e0
> Oct 26 23:32:55 mina kernel:  [<c011628d>] do_page_fault+0x36d/0x69c
> Oct 26 23:32:55 mina kernel:  [<c01051ed>] error_code+0x2d/0x38
> Oct 26 23:32:55 mina kernel:  [<f88ef6a8>] sd_release+0x68/0xa0 [sd_mod]
> Oct 26 23:32:55 mina kernel:  [<c0184c03>] blkdev_put+0x183/0x1b0
> Oct 26 23:32:55 mina kernel:  [<c01784ad>] __fput+0x14d/0x160
> Oct 26 23:32:55 mina kernel:  [<c0176797>] filp_close+0x57/0x90
> Oct 26 23:32:55 mina kernel:  [<c01768e3>] sys_close+0x113/0x240
> Oct 26 23:32:55 mina kernel:  [<c0104ff1>] sysenter_past_esp+0x52/0x71
> Oct 26 23:32:55 mina kernel: Code: 0c 8b 43 04 8b 00 89 5c 24 04 c7 04 
> 24 e4 d1 83 f8 89 44 24 08 e8 d3 21 8f c7 8d 76 00 55 89 e5 57 56 53 83 
> ec 4c 8b 75 08 8b 1e <8b> 83 10 01 00 00 a8 08 74 7c fc 31 c0 8d 7d b4 
> b9 05 00 00 00


The problem with using shost_for_each_device wrt to the above oops is
that scsi_forget_host sets the state to SDEV_CANCEL, so that when
scsi_host_cancel iterates over the devices using shost_for_each_device
it cannot get a handle to the sdev (scsi_device_get fails becuase the
state is set to SDEV_CANCEL). And, __scsi_iterate_devices does not clear
the next pointer if this happens, so I think this is needed to fix just
the refcount bug in shost_for_each_device.

--- linux-2.6.10-rc1-mm1/drivers/scsi/scsi.c.orig	2004-10-27 00:47:49.904954011 -0700
+++ linux-2.6.10-rc1-mm1/drivers/scsi/scsi.c	2004-10-27 00:42:50.000000000 -0700
@@ -1063,6 +1063,8 @@ struct scsi_device *__scsi_iterate_devic
  		/* skip devices that we can't get a reference to */
  		if (!scsi_device_get(next))
  			break;
+
+		next = NULL;
  		list = list->next;
  	}
  	spin_unlock_irqrestore(shost->host_lock, flags);


Please note this does not fix the bug where devices are not being
canceled, becuase we use device_for_each_child (descibed at the end
of this thread http://marc.theaimsgroup.com/?l=linux-scsi&m=109733573729283&w=2
or shost_for_each_device (described above) too late to be useful.
