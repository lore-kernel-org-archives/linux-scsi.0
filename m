From: Amit Patel <patelamitv@yahoo.com>
Subject: State Model for scsi device badness
Date: Wed, 19 Nov 2003 17:56:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120015655.30453.qmail@web13006.mail.yahoo.com>
References: <20031118074251.62922.qmail@web13009.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web13006.mail.yahoo.com ([216.136.174.16]:57865 "HELO
	web13006.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264235AbTKTB44 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 20:56:56 -0500
In-Reply-To: <20031118074251.62922.qmail@web13009.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: patelamitv@yahoo.com, linux-scsi@vger.kernel.org

Hi James,

I was trying updated state model for scsi device
patch. I have 2.6.0-test9-mm3 and QLogic 2300 adapter.
While loading the qlogic driver I see lot of Kobject
badness messages. 

I am not really familiar with kobject/scsi code but is
it because while doing the scan of the scsi devices we
have really not setup kobject for the device but we
are sending INQUIRY command to see if there are any
devices attached to the target. This code path will go
through scsi_request_fn and as part of the patch first
thing in scsi_request_fn is get_device. This is where
the badness message is coming from. 

I don't see this messages once initial scan is done. I
am not sure what other information will be helpful but
if you need any more information please let me know.

Thanks
Amit

Badness in kobject_get at lib/kobject.c:440
Call Trace:
 [<c023cd8c>] kobject_get+0x4c/0x50
 [<c0299818>] get_device+0x18/0x30
 [<f88a5b36>] scsi_request_fn+0x26/0x980 [scsi_mod]
 [<f889d64e>] scsi_put_command+0x1ee/0x350 [scsi_mod]
 [<c029fb72>] blk_run_queue+0xa2/0x1a0
 [<f88a41ca>] scsi_wait_req+0xea/0x100 [scsi_mod]
 [<f88a3ef0>] scsi_wait_done+0x0/0x1f0 [scsi_mod]
 [<c015faeb>] check_poison_obj+0x2b/0x1a0
 [<f88a7089>] scsi_probe_lun+0x99/0x2e0 [scsi_mod]
 [<f889d028>] scsi_allocate_request+0x28/0x70
[scsi_mod]
 [<f88a7a22>] scsi_probe_and_add_lun+0x112/0x200
[scsi_mod]
 [<f88a7a3b>] scsi_probe_and_add_lun+0x12b/0x200
[scsi_mod]
 [<f88a8274>] scsi_scan_target+0x94/0x110 [scsi_mod]
 [<f88a834b>] scsi_scan_channel+0x5b/0xa0 [scsi_mod]
 [<f88a8482>] scsi_scan_host_selected+0xf2/0x140
[scsi_mod]
 [<f88a8501>] scsi_scan_host+0x31/0x40 [scsi_mod]
 [<f890a3ee>] qla2x00_probe_device+0xb0e/0xe50
[qla2300]
 [<c01ad923>] d_instantiate+0x123/0x1c0
 [<c01aa9e0>] dput+0x30/0x780
 [<c01e4400>] sysfs_new_inode+0x30/0xb0
 [<c02495cd>] pci_device_probe_static+0x4d/0x60
 [<c024961c>] __pci_device_probe+0x3c/0x50
 [<c024965c>] pci_device_probe+0x2c/0x50
 [<c029a7dd>] bus_match+0x3d/0x70
 [<c029a91c>] driver_attach+0x5c/0x90
 [<c029ac14>] bus_add_driver+0xa4/0xc0
 [<c029b0d6>] driver_register+0x96/0xa0
 [<c0249879>] pci_register_driver+0x99/0xc0
 [<f887305e>] qla2x00_module_init+0x5e/0x8a [qla2300]
 [<f8904000>] qla2x00_set_info+0x0/0x10 [qla2300]
 [<c0150306>] sys_init_module+0x1f6/0x3d0
 [<c039d942>] sysenter_past_esp+0x43/0x65


__________________________________
Do you Yahoo!?
Free Pop-Up Blocker - Get it now
http://companion.yahoo.com/
