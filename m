From: Daniel Drake <dsd@gentoo.org>
Subject: 2.6.14 regression: aic7xxx hangs on boot
Date: Wed, 19 Apr 2006 12:32:05 +0100
Message-ID: <44461FB5.8060705@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta09-winn.ispmail.ntl.com ([81.103.221.49]:2991 "EHLO
	mtaout03-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1750892AbWDSLS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 07:18:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Hi,

A Gentoo user reported an aic7xxx regression at:
http://bugs.gentoo.org/127991

It's a bit of an odd one. 2.6.13 works (even in the present day), 2.6.14 
does not. On 2.6.14, these messages appear during early boot:

	<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
	Recovery code sleeping
	Recovery code awake
	aic7xxx_abort returns 0x2003
	aic7xxx_dev_reset returns 0x2003
	Recovery SCB completes

These kind of mesages repeat quickly in a seemingly infinite loop, the 
boot does not complete.

git-bisect tracked it down to this commit:

Author: James Bottomley <James.Bottomley@steeleye.com> 

Date:   Sun Aug 14 17:09:01 2005 -0500 


     [SCSI] correct transport class abstraction to work outside SCSI 


http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=d0a7e574007fd547d72ec693bfa35778623d0738;hp=10c1b88987d618f4f89c10e11e574c76de73b5e7

However, applying that patch to 2.6.13 does not cause the break to 
happen. Incidently, these messages do appear instead:

scheduling while atomic: swapper/0x00000001/1
  [<c0399573>] schedule+0x9c3/0xc97
  [<c0118b49>] __wake_up_common+0x3f/0x5e
  [<c03999a4>] wait_for_completion+0x85/0xca
  [<c0118af8>] default_wake_function+0x0/0x12
  [<c0118af8>] default_wake_function+0x0/0x12
  [<c012cfd5>] queue_work+0x79/0x7b
  [<c012cee3>] call_usermodehelper_keys+0xd6/0xe3
  [<c012cdac>] __call_usermodehelper+0x0/0x61
  [<c025625d>] kobject_hotplug+0x27f/0x2ec
  [<c0195549>] sysfs_create_link+0x44/0x64
  [<c029ecc6>] class_device_add+0x117/0x1d4
  [<c02a0b73>] attribute_container_add_class_device+0x10/0x26
  [<c02a0deb>] transport_add_class_device+0x10/0x40
  [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
  [<c02a0e32>] transport_add_device+0x17/0x1b
  [<c02a0ddb>] transport_add_class_device+0x0/0x40
  [<c02c1038>] scsi_alloc_target+0x1ed/0x27a
  [<c02a0f57>] transport_destroy_device+0x17/0x1c
  [<c02c1fff>] scsi_scan_target+0x62/0x174
  [<c02c21c1>] scsi_scan_channel+0xb0/0xce
  [<c02c2259>] scsi_scan_host_selected+0x7a/0xd9
  [<c02c22e7>] scsi_scan_host+0x2f/0x33
  [<c02dcdfe>] ahc_linux_register_host+0x1b3/0x1bd
  [<c02e0aa0>] ahc_pci_map_int+0x38/0x60
  [<c02ddf5b>] ahc_linux_isr+0x0/0x27e
  [<c02d5eab>] ahc_pci_config+0x717/0x9cf
  [<c025d276>] pci_set_master+0x42/0x84
  [<c02e06b7>] ahc_linux_pci_dev_probe+0x10b/0x14b
  [<c012cdac>] __call_usermodehelper+0x0/0x61
  [<c025ecc9>] pci_match_device+0x2a/0xdd
  [<c025edd5>] __pci_device_probe+0x59/0x67
  [<c025ee12>] pci_device_probe+0x2f/0x59
  [<c029dcf0>] driver_probe_device+0x3b/0xc5
  [<c029dde5>] __driver_attach+0x0/0x45
  [<c029de28>] __driver_attach+0x43/0x45
  [<c029d327>] bus_for_each_dev+0x58/0x78
  [<c029de50>] driver_attach+0x26/0x2a
  [<c029dde5>] __driver_attach+0x0/0x45
  [<c029d846>] bus_add_driver+0x83/0xec
  [<c025f085>] pci_register_driver+0x7e/0x94
  [<c02e0706>] ahc_linux_pci_init+0xf/0x1b
  [<c049564a>] ahc_linux_init+0x7f/0xa6
  [<c0480978>] do_initcalls+0x53/0xb5
  [<c0100386>] init+0x7c/0x19e
  [<c010030a>] init+0x0/0x19e
  [<c0101101>] kernel_thread_helper+0x5/0xb

Any ideas/suggestions?

Thanks,
Daniel
