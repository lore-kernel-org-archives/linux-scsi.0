From: Aleksey Nogin <aleksey@nogin.org>
Subject: Re: [linux-usb-devel] Numerous problems, partial success getting
 FujiFilm Finepix 3800 to work under 2.6.
Date: Wed, 21 Apr 2004 18:30:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40872024.3080706@nogin.org>
References: <Pine.LNX.4.44L0.0404211041220.1106-100000@ida.rowland.org> <4086D17C.2050407@nogin.org> <20040421173952.A22730@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swordfish.cs.caltech.edu ([131.215.44.124]:40343 "EHLO
	swordfish.cs.caltech.edu") by vger.kernel.org with ESMTP
	id S263768AbUDVBaR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 21:30:17 -0400
In-Reply-To: <20040421173952.A22730@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, john stultz <johnstul@us.ibm.com>

On 21.04.2004 17:39, Patrick Mansfield wrote:

> On Wed, Apr 21, 2004 at 12:54:36PM -0700, Aleksey Nogin wrote:
> 
>>However, is still only works when connected directly. If connected 
>>through a hub, when I start copying files, after transferring in the 
>>range of 100-500KB, the system thinks that the hub was disconnected, 
>>data transfer gets stuck, then it thinks that the mouse (that is 
>>attached to the hub) is disconnected, then it thinks that the mouse is 
>>back, then everything becomes stuck. If I turn the camera off at this 
>>point, it results in a kernel oops...
> 
> 
> Where's the oops? 

Here is what I saw I time during my experimentations with unusual_devs.h:

Apr 19 23:04:21 kernel: usb 1-1.3: USB disconnect, address 9
Apr 19 23:04:29 kernel: scsi: Device offlined - not ready after error 
recovery: host 4 channel 0 id 0 lun 0
Apr 19 23:04:29 kernel: sd 4:0:0:0: Illegal state transition cancel->offline
Apr 19 23:04:29 kernel: Badness in scsi_device_set_state at 
drivers/scsi/scsi_lib.c:1640
Apr 19 23:04:29 kernel: Call Trace:
Apr 19 23:04:29 kernel:  [<e0ab6703>] scsi_device_set_state+0xb4/0xbf 
[scsi_mod]
Apr 19 23:04:29 kernel:  [<e0ab3ab7>] scsi_eh_offline_sdevs+0x49/0x62 
[scsi_mod]
Apr 19 23:04:29 kernel:  [<e0ab419f>] scsi_unjam_host+0x24c/0x25d [scsi_mod]
Apr 19 23:04:29 kernel:  [<e0ab4406>] scsi_error_handler+0x256/0x2ad 
[scsi_mod]
Apr 19 23:04:29 kernel:  [<e0ab41b0>] scsi_error_handler+0x0/0x2ad 
[scsi_mod]
Apr 19 23:04:29 kernel:  [<c01041d9>] kernel_thread_helper+0x5/0xb

Followed by

Apr 19 23:04:47 kernel: Unable to handle kernel NULL pointer dereference 
at virtual address 00000110
Apr 19 23:04:47 kernel:  printing eip:
Apr 19 23:04:47 kernel: e0ab2316
Apr 19 23:04:47 kernel: *pde = 0445d067
Apr 19 23:04:47 kernel: Oops: 0000 [#1]
Apr 19 23:04:47 kernel: CPU:    0
Apr 19 23:04:47 kernel: EIP:    0060:[<e0ab2316>]    Not tainted
Apr 19 23:04:47 kernel: EFLAGS: 00210282   (2.6.5-1.327custom)
Apr 19 23:04:47 kernel: EIP is at 
scsi_block_when_processing_errors+0x8/0xa7 [scsi_mod]
Apr 19 23:04:47 kernel: eax: dbd05000   ebx: dbd05000   ecx: 00000000 
edx: c1a5c200
Apr 19 23:04:47 kernel: esi: d0972540   edi: d80e9300   ebp: c1a5c200 
esp: c40c8f04
Apr 19 23:04:47 kernel: ds: 007b   es: 007b   ss: 0068
Apr 19 23:04:47 kernel: Process umount (pid: 7116, threadinfo=c40c8000 
task=c6cf1360)
Apr 19 23:04:47 kernel: Stack: 00000000 00000000 00000000 00000000 
00000000 d80e9300 d80e9300 d80e9300
Apr 19 23:04:47 kernel:        dbd05000 e0e21621 00000001 d80e9300 
c0167a01 d80e9368 00000000 e0e24380
Apr 19 23:04:47 kernel:        d80e9300 d80e9080 c1a5c200 c0167a9a 
d80e90e8 00000000 db8d7840 db8d7800
Apr 19 23:04:47 kernel: Call Trace:
Apr 19 23:04:47 kernel:  [<e0e21621>] sd_release+0x4c/0x65 [sd_mod]
Apr 19 23:04:47 kernel:  [<c0167a01>] blkdev_put+0x111/0x25a
Apr 19 23:04:47 kernel:  [<c0167a9a>] blkdev_put+0x1aa/0x25a
Apr 19 23:04:47 kernel:  [<c0163f32>] deactivate_super+0xc4/0x1e8
Apr 19 23:04:47 kernel:  [<c017fc12>] sys_umount+0x5d/0x64
Apr 19 23:04:47 kernel:  [<c0150162>] unmap_vma_list+0xe/0x17
Apr 19 23:04:47 kernel:  [<c015068a>] do_munmap+0x1dc/0x1e6
Apr 19 23:04:47 kernel:  [<c017fc24>] sys_oldumount+0xb/0xe
Apr 19 23:04:47 kernel:  [<c02e8d3b>] syscall_call+0x7/0xb
Apr 19 23:04:47 kernel:
Apr 19 23:04:47 kernel: Code: 8b 81 10 01 00 00 a8 08 74 61 b8 00 f0 ff 
ff 89 e2 21 e0 8b

> This sounds like a badness John sent to me about a USB
> cdrom device that gets an error, and when it is later removed hits a
> WARN_ON in scsi_device_set_state.
> 
> Here's the back trace:
> 
> sr 7:0:0:0: Illegal state transition offline->cancel
> Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1640
> Call Trace:
>  [<c02b20e5>] scsi_device_set_state+0xbe/0x10b
>  [<c02ac93b>] scsi_device_cancel+0x29/0xf4
>  [<c02acad5>] scsi_device_cancel_cb+0x0/0x1c
>  [<c0238dd7>] device_for_each_child+0x3e/0x6e
>  [<c02acb27>] scsi_host_cancel+0x36/0xab
>  [<c02acad5>] scsi_device_cancel_cb+0x0/0x1c
>  [<c0344af1>] usb_buffer_free+0x45/0x47
>  [<c02acbb7>] scsi_remove_host+0x1b/0x5c
>  [<c0360bf1>] storage_disconnect+0x39/0x49
>  [<c0343b64>] usb_unbind_interface+0x7a/0x7c
>  [<c0239b46>] device_release_driver+0x64/0x66
>  [<c0239c6d>] bus_remove_device+0x56/0x98
>  [<c0238d40>] device_del+0x5f/0x95
>  [<c0238d89>] device_unregister+0x13/0x23
>  [<c03495f5>] usb_disable_device+0x71/0xac
>  [<c0344451>] usb_disconnect+0x9c/0xe9
>  [<c0346482>] hub_port_connect_change+0x282/0x287
>  [<c0345e39>] hub_port_status+0x45/0xb0
>  [<c03467a9>] hub_events+0x322/0x36e
>  [<c0346826>] hub_thread+0x31/0xd1
>  [<c0111f86>] default_wake_function+0x0/0x12
>  [<c03467f5>] hub_thread+0x0/0xd1
>  [<c0102209>] kernel_thread_helper+0x5/0xb

Another time when I was testing the scsi_scan patch, I saw a one with 
the hub_thread in it, but the machine became completely unresponsive 
before I got a chance to capture it.

-- 
Aleksey Nogin

Home Page: http://nogin.org/
E-Mail: nogin@cs.caltech.edu (office), aleksey@nogin.org (personal)
Office: Jorgensen 70, tel: (626) 395-2907
