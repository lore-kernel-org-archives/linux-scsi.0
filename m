From: James.Smart@Emulex.Com
Subject: RE: [RFC] Allow transport classes to attach to host, target or device
Date: Mon, 27 Sep 2004 14:28:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F1DB@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60625 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266912AbUI0S2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 14:28:43 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


FYI - I've been prototyping host and target attributes in the fc transport using a 9/12 snapshot of the scsi-target-2.6 tree.

I have one issue that I would hope someone with more experience in the underlying class code can help with.

Here's a summary of what's happening...
- If I insmod a test lldd, which attaches a host, passes discovery, and finds 1 device - I can see the classes, and all the attribute files in sysfs. If I never attempt to access the sysfs attributes, I can rmmod the test lldd fine.
- If I repeat, I can access all the attributes in the sdev and starget classes, and I can rmmod the test lldd fine.
- If I repeat, and then access only a host attribute (which works fine), the subsequent rrmod encounters the oops described below.

In trying repeated scenarios, I have the following observations. I have 3 rd only attributes and 1 rdwr attribute on the host. I can access the rdwr attribute all I want and rmmod with no problems. If I access one of the rd only attributes, the rmmod fails. Other than the rd vs rdwr distinction, there is no other real difference. Also - other than where the attributes come from (shost, starget, or sdev), there is no difference in declaration or use of the attributes in the different classes.

Any help in tracking this down further is appreciated. I can forward the patch of the prototype for those that want to look at it.

-- james


The oops is:

>> A NULL pointer dereference in list_del_init() in class_device_del()

Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c01f46fd
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: lpfc scsi_transport_fc autofs4 sunrpc pcnet32 mii ipt_REJECT iptable_filter ip_tables vmhgfs floppy sg microcode uhci_hcd usbcore button battery asus_acpi ac ext3 jbd BusLogic sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c01f46fd>]    Tainted: P   VLI
EFLAGS: 00010246   (2.6.9-rc1) 
EIP is at class_device_del+0x3d/0xc0
eax: f0e1d2c3   ebx: c21d6ddc   ecx: 00000000   edx: 00000000
esi: c21d6ddc   edi: cc91a340   ebp: c9c9e000   esp: c9c9ff3c
ds: 007b   es: 007b   ss: 0068
Process rmmod (pid: 3537, threadinfo=c9c9e000 task=ca094560)
Stack: cc91a38c c21d6ddc c02ddea0 00000000 c9c9e000 c01f4788 c21d6c00 cc9bb14c 
       c21d6c00 cc91c440 cc91c5b0 cc91d200 c012fafd 00000000 6366706c 00000000 
       ca0d2dc0 c0d6d6b4 c014643a b7fea000 b7feb000 c0146769 b7fea000 b7feb000 
Call Trace:
 [<c01f4788>] class_device_unregister+0x8/0x10
 [<cc9bb14c>] scsi_remove_host+0x4c/0x50 [scsi_mod]
 [<cc91c440>] lpfc_exit+0x30/0x55 [lpfc]
 [<c012fafd>] sys_delete_module+0x12d/0x170
 [<c014643a>] unmap_vma_list+0x1a/0x30
 [<c0146769>] do_munmap+0x109/0x150
 [<c01178e0>] do_page_fault+0x0/0x54c
 [<c0105e1d>] sysenter_past_esp+0x52/0x71
Code: 4c ba 42 00 00 00 89 04 24 b8 a0 90 2a c0 e8 2b 5f f2 ff ba 01 00 ff ff 8b 04 24 0f c1 10 85 d2 0f 85 b4 02 00 00 8b 06 8b 56 04 <89> 02 89 36 8b 5f 60 89 50 04 89 76 04 8b 03 0f 18 00 90 8d 6f 

 
