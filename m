From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: BUG in libata from ata_sas_port_alloc
Date: Thu, 15 Feb 2007 15:36:45 -0600
Message-ID: <1171575405.3412.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is the bug

sas: DOING DISCOVERY on port 1, pid:2009
INIT: slab error in verify_redzone_free(): cache `size-1024': memory
outside object was overwritten
 [<c010400a>] show_trace_log_lvl+0x1a/0x30
 [<c0104642>] show_trace+0x12/0x20
 [<c01046f6>] dump_stack+0x16/0x20
 [<c0161866>] __slab_error+0x26/0x30
 [<c01619b1>] cache_free_debugcheck+0x141/0x1f0
 [<c016216d>] kfree+0x7d/0xf0
 [<f8966e7f>] ata_sas_port_alloc+0x5f/0x80 [libata]
 [<f893c5be>] sas_ata_init_host_and_port+0x5e/0xa0 [libsas]
 [<f893c2dd>] sas_target_alloc+0x4d/0x60 [libsas]
 [<f8995368>] scsi_alloc_target+0x208/0x320 [scsi_mod]
 [<f8995579>] __scsi_scan_target+0x59/0x6d0 [scsi_mod]
 [<f8996287>] scsi_scan_target+0xa7/0xc0 [scsi_mod]
 [<f8910c9f>] sas_rphy_add+0xdf/0x110 [scsi_transport_sas]
 [<f8936d19>] sas_discover_sata+0x79/0x480 [libsas]
 [<f8937581>] sas_discover_domain+0x3d1/0x490 [libsas]
 [<c012b327>] run_workqueue+0xe7/0x170
 [<c012bad7>] worker_thread+0x147/0x170
 [<c012e847>] kthread+0xb7/0xe0
 [<c0103c23>] kernel_thread_helper+0x7/0x14
 =======================
f707398c: redzone 1:0xc023e580, redzone 2:0x6b6b6b6b.

Just struck.  This looks to be the problem:

	ent = ata_probe_ent_alloc(host->dev, port_info);
[...]
	kfree(ent);

However, if you look in ata_probe_ent_alloc() you see

	/* XXX - the following if can go away once all LLDs are managed */
	if (!list_empty(&dev->devres_head))
		probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
	else
		probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);


The problem is that memory obtained by devm_kzalloc() cannot be returned
by kfree() ... they come from different allocation lists.  The solution
is probably to have a corresponding ata_probe_ent_free(), I just don't
exactly see how to tell if the object came from the devm_kzalloc or not
(unless it gets marked).

James


