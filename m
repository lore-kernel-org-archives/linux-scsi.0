From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: scsi_transport_iscsi.c + transport_container_unregister() oops
Date: Wed, 27 Apr 2005 11:50:13 -0700
Message-ID: <426FDEE5.40408@us.ibm.com>
References: <1114626881.20844.15.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:15004 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261947AbVD0SuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 14:50:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j3RIoL0N031684
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 14:50:21 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3RIoL8q070422
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 14:50:21 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j3RIoK7c003338
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 14:50:20 -0400
In-Reply-To: <1114626881.20844.15.camel@haakon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Nicholas A. Bellinger wrote:
> While adding support for the iSCSI Transport class
> (scsi_transport_iscsi.c) to the iscsi-initiator-core stack, I ran into a
> problem with iscsi_release_transport() and
> transport_container_unregister().
> 
> When iscsi_register_transport() and iscsi_release_transport() are called
> WITHOUT calling scsi_add_host() and scsi_remove_host() there are no
> problems.
> 
> When iscsi_register_transport() and iscsi_release_transport() are called
> WITH calling scsi_add_host() and scsi_remove_host() the following OOPs
> appears in attribute_container_unregister during the list_empty() loop.
> 
> I also noticed that that transport_container_[register,unregister]()
> calls in iscsi_[register,release]_transport() where added around
> 2.6.12-rc1, but are not included in the scsi_transport_iscsi.c within
> the 4.0.1.11.  

The scsi_transport_iscsi.c in 4.0.1.11 is old. That version of the driver
was for before James's transport container code so you cannot use the
scsi_transport_iscsi.c in there with the current driver model transport
code.

Also you do not need to worry about sfnet compatibilty. If your changes
are good/merged we will adapt to them. So do not worry about breaking
us in the mean time.

> 
> Any ideas?
> 
> (gdb) list *(attribute_container_unregister+0x1c)
> 0x7c is in attribute_container_unregister (list.h:251).
> 246     /**
> 247      * list_empty - tests whether a list is empty
> 248      * @head: the list to test.
> 249      */
> 250     static inline int list_empty(const struct list_head *head)
> 251     {
> 252             return head->next == head;
> 253     }
> 254     
> 255     /**
> (gdb) 
> 
> Unable to handle kernel paging request at virtual address 63722d5e
>  printing eip:
> c029ed5c
> *pde = 00000000
> Oops: 0000 [#1]
> SMP 
> Modules linked in: iscsi_initiator_mod scsi_transport_iscsi microcode
> usbcore
> CPU:    1
> EIP:    0060:[<c029ed5c>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.12-rc3) 
> EIP is at attribute_container_unregister+0x1c/0x50
> eax: 63722d5e   ebx: fffffff0   ecx: 63722d56   edx: 00000282
> esi: 00000000   edi: bfaf3650   ebp: f6ed5f24   esp: f6ed5f20
> ds: 007b   es: 007b   ss: 0068
> Process rmmod (pid: 4501, threadinfo=f6ed5000 task=f7873530)
> Stack: 63722d32 f6ed5f34 f886e043 63722d56 f8cf2680 f6ed5f4c f8cd0248
> 63722d32 
>        00000008 f8cf2680 00000880 f6ed5f54 f8cde7d8 f6ed5fb4 c01381f7
> f8cf2680 
>        00000880 f6ed5f68 00000000 73637369 6e695f69 61697469 5f726f74
> 00646f6d 
> Call Trace:
>  [<c0103c9f>] show_stack+0x7f/0xa0
>  [<c0103e4e>] show_registers+0x15e/0x1d0
>  [<c0104062>] die+0xf2/0x180
>  [<c0113252>] do_page_fault+0x382/0x6e0
>  [<c01038a3>] error_code+0x4f/0x54
>  [<f886e043>] iscsi_release_transport+0x23/0x60 [scsi_transport_iscsi]
>  [<f8cd0248>] iscsi_linux_fini+0x18/0x80 [iscsi_initiator_mod]
>  [<f8cde7d8>] exit_iscsi_module+0x8/0xa [iscsi_initiator_mod]
>  [<c01381f7>] sys_delete_module+0x157/0x190
>  [<c0102d33>] sysenter_past_esp+0x54/0x75
> 
> 
> 


