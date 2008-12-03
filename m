From: Olaf Hering <olh@suse.de>
Subject: oops in ibmvstgt
Date: Wed, 3 Dec 2008 15:58:57 +0100
Message-ID: <20081203145857.GA10070@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbYLCO67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 09:58:59 -0500
Received: from Relay2.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 83561464AB
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2008 15:58:58 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


change init order to fix crash due to uninitalized shost_data
No idea if the patch is correct.

...
running with firmware 'IBM,SF235_214' on model 'IBM,9133-55A', serial 'IBM,0210C3E0D', partition 'vioserver'
...
Linux version 2.6.28-rc7-git1 (olaf@gooseberry) (gcc version 4.1.2 20070115 (SUSE Linux)) #2 SMP Wed Dec 3 14:28:31 CET 2008
...
vio_register_driver: driver ibmvscsi registering
IBM eServer i/pSeries Virtual SCSI Target Driver
vio_register_driver: driver ibmvscsis registering
scsi1 : ibmvstgt
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0000000002d20f4
cpu 0x0: Vector: 300 (Data Access) at [c0000001db4c7900]
    pc: c0000000002d20f4: .srp_rport_add+0xb8/0x1c4
    lr: c0000000002d20a8: .srp_rport_add+0x6c/0x1c4
    sp: c0000001db4c7b80
   msr: 8000000000009032
   dar: 0
 dsisr: 40000000
  current = 0xc0000001de40ee80
  paca    = 0xc000000000753380
    pid   = 415, comm = ibmvtgtd/0
enter ? for help
[c0000001db4c7c30] c0000000002e3f14 .process_crq+0x2d8/0x4ec
[c0000001db4c7d00] c0000000002e4394 .handle_crq+0xac/0x270
[c0000001db4c7db0] c00000000006eec0 .run_workqueue+0x114/0x204
[c0000001db4c7e50] c0000000000700cc .worker_thread+0x118/0x138
[c0000001db4c7f00] c0000000000740bc .kthread+0x78/0xc4
[c0000001db4c7f90] c000000000028ff4 .kernel_thread+0x54/0x70
...
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -864,14 +864,14 @@ static int ibmvstgt_probe(struct vio_dev
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = crq_queue_create(&vport->crq_queue, target);
-	if (err)
-		goto free_srp_target;
-
 	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto destroy_queue;
 
+	err = crq_queue_create(&vport->crq_queue, target);
+	if (err)
+		goto free_srp_target;
+
 	err = scsi_tgt_alloc_queue(shost);
 	if (err)
 		goto destroy_queue;
