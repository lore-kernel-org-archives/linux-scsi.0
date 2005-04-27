From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: scsi_transport_iscsi.c + transport_container_unregister() oops
Date: Wed, 27 Apr 2005 11:34:41 -0700
Message-ID: <1114626881.20844.15.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp819.mail.sc5.yahoo.com ([66.163.170.5]:58731 "HELO
	smtp819.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261952AbVD0SoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 14:44:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

While adding support for the iSCSI Transport class
(scsi_transport_iscsi.c) to the iscsi-initiator-core stack, I ran into a
problem with iscsi_release_transport() and
transport_container_unregister().

When iscsi_register_transport() and iscsi_release_transport() are called
WITHOUT calling scsi_add_host() and scsi_remove_host() there are no
problems.

When iscsi_register_transport() and iscsi_release_transport() are called
WITH calling scsi_add_host() and scsi_remove_host() the following OOPs
appears in attribute_container_unregister during the list_empty() loop.

I also noticed that that transport_container_[register,unregister]()
calls in iscsi_[register,release]_transport() where added around
2.6.12-rc1, but are not included in the scsi_transport_iscsi.c within
the 4.0.1.11.  

Any ideas?

(gdb) list *(attribute_container_unregister+0x1c)
0x7c is in attribute_container_unregister (list.h:251).
246     /**
247      * list_empty - tests whether a list is empty
248      * @head: the list to test.
249      */
250     static inline int list_empty(const struct list_head *head)
251     {
252             return head->next == head;
253     }
254     
255     /**
(gdb) 

Unable to handle kernel paging request at virtual address 63722d5e
 printing eip:
c029ed5c
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: iscsi_initiator_mod scsi_transport_iscsi microcode
usbcore
CPU:    1
EIP:    0060:[<c029ed5c>]    Not tainted VLI
EFLAGS: 00010246   (2.6.12-rc3) 
EIP is at attribute_container_unregister+0x1c/0x50
eax: 63722d5e   ebx: fffffff0   ecx: 63722d56   edx: 00000282
esi: 00000000   edi: bfaf3650   ebp: f6ed5f24   esp: f6ed5f20
ds: 007b   es: 007b   ss: 0068
Process rmmod (pid: 4501, threadinfo=f6ed5000 task=f7873530)
Stack: 63722d32 f6ed5f34 f886e043 63722d56 f8cf2680 f6ed5f4c f8cd0248
63722d32 
       00000008 f8cf2680 00000880 f6ed5f54 f8cde7d8 f6ed5fb4 c01381f7
f8cf2680 
       00000880 f6ed5f68 00000000 73637369 6e695f69 61697469 5f726f74
00646f6d 
Call Trace:
 [<c0103c9f>] show_stack+0x7f/0xa0
 [<c0103e4e>] show_registers+0x15e/0x1d0
 [<c0104062>] die+0xf2/0x180
 [<c0113252>] do_page_fault+0x382/0x6e0
 [<c01038a3>] error_code+0x4f/0x54
 [<f886e043>] iscsi_release_transport+0x23/0x60 [scsi_transport_iscsi]
 [<f8cd0248>] iscsi_linux_fini+0x18/0x80 [iscsi_initiator_mod]
 [<f8cde7d8>] exit_iscsi_module+0x8/0xa [iscsi_initiator_mod]
 [<c01381f7>] sys_delete_module+0x157/0x190
 [<c0102d33>] sysenter_past_esp+0x54/0x75



-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

