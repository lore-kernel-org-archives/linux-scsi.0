From: "Mun Hamlet" <hamletmun@hotmail.com>
Subject: Re: [SCSI] correct transport class abstraction to work outside SCSI
Date: Mon, 17 Apr 2006 11:33:38 -0300
Message-ID: <BAY112-F3701EC7A4597119EA266AEA0C70@phx.gbl>
References: <1145038797.3520.50.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay112-f37.bay112.hotmail.com ([64.4.26.47]:35732 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S1751023AbWDQOdn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 10:33:43 -0400
In-Reply-To: <1145038797.3520.50.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Thank you for your reply.

To verify the git bisecting result, I did

Vanilla kernel 2.6.13
www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.13.tar.bz2
Your patch
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=d0a7e574007fd547d72ec693bfa35778623d0738;hp=10c1b88987d618f4f89c10e11e574c76de73b5e7


It does BOOT, but it shows this strange dmesg...

25f085>] pci_register_driver+0x7e/0x94
 [<c02e0706>] ahc_linux_pci_init+0xf/0x1b
 [<c049564a>] ahc_linux_init+0x7f/0xa6
 [<c0480978>] do_initcalls+0x53/0xb5
 [<c0100386>] init+0x7c/0x19e
 [<c010030a>] init+0x0/0x19e
 [<c0101101>] kernel_thread_helper+0x5/0xb
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
 [<c029ef08>] class_device_del+0x89/0xf2
 [<c02a0ec4>] transport_remove_classdev+0x3a/0x7a
 [<c0175ab4>] dput+0xad/0x1f7
 [<c02a0ab5>] attribute_container_device_trigger+0x97/0x9d
 [<c02a0f1b>] transport_remove_device+0x17/0x1b
 [<c02a0e8a>] transport_remove_classdev+0x0/0x7a
 [<c02c115c>] scsi_target_reap+0x97/0xae
 [<c02c204b>] scsi_scan_target+0xae/0x174
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
libata version 1.12 loaded.
ata_piix version 1.04
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0xB800 ctl 0xB402 bmdma 0xA400 irq 19
ata2: SATA max UDMA/133 cmd 0xB000 ctl 0xA802 bmdma 0xA408 irq 19
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e21 87:4663 
88:207f
ata1: dev 0 ATA, max UDMA/133, 586114704 sectors: lba48
ata1: dev 0 configured for UDMA/133
scsi1 : ata_piix
ATA: abnormal status 0x7F on port 0xB007
ata2: disabling port
scsi2 : ata_piix
  Vendor: ATA       Model: Maxtor 6L300S0    Rev: BACE
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 17873040 512-byte hdwr sectors (9151 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 17873040 512-byte hdwr sectors (9151 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi removable disk sdb at scsi0, channel 0, id 5, lun 0
SCSI device sdc: 586114704 512-byte hdwr sectors (300091 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 586114704 512-byte hdwr sectors (300091 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1
Attached scsi disk sdc at scsi1, channel 0, id 0, lun 0
sr0: scsi3-mmc drive: 6x/6x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 3, lun 0
sr1: scsi-1 drive
Attached scsi CD-ROM sr1 at scsi0, channel 0, id 4, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
Attached scsi generic sg1 at scsi0, channel 0, id 3, lun 0,  type 5
Attached scsi generic sg2 at scsi0, channel 0, id 4, lun 0,  type 5
Attached scsi generic sg3 at scsi0, channel 0, id 5, lun 0,  type 0
Attached scsi generic sg4 at scsi1, channel 0, id 0, lun 0,  type 0
mice: PS/2 mouse device common for all mice
Advanced Linux Sound Architecture Driver Version 1.0.9b (Thu Jul 28 
12:20:13 2005 UTC).
ALSA device list:
  No soundcards found.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
UDF-fs: No VRS found
XFS mounting filesystem sda2
input: AT Translated Set 2 keyboard on isa0060/serio0
Ending clean XFS mount for filesystem: sda2
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 188k freed
input: ImExPS/2 Generic Explorer Mouse on isa0060/serio1
input: AT Translated Set 2 keyboard on isa0060/serio0
Device not ready. Make sure there is a disc in the drive.
Device not ready. Make sure there is a disc in the drive.
Device not ready. Make sure there is a disc in the drive.
PCI: Setting latency timer of device 0000:00:1b.0 to 64
XFS mounting filesystem sdc1
Ending clean XFS mount for filesystem: sdc1

http://bugzilla.kernel.org/show_bug.cgi?id=5659
http://bugs.gentoo.org/show_bug.cgi?id=127991


