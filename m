From: Chris Leech <cleech@redhat.com>
Subject: [PATCH v2] fnic: BUG: sleeping function called from invalid context during probe
Date: Tue, 23 Jul 2013 13:04:58 -0700
Message-ID: <1374609898-3901-1-git-send-email-cleech@redhat.com>
References: <1373993705-30767-1-git-send-email-cleech@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab3GWUFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jul 2013 16:05:38 -0400
In-Reply-To: <1373993705-30767-1-git-send-email-cleech@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>

I hit this during driver probe with the latest fnic updates (this trace
is from a backport into a distro kernel, but the issue is the same).

> BUG: sleeping function called from invalid context at mm/slab.c:3113
> in_atomic(): 0, irqs_disabled(): 1, pid: 610, name: work_for_cpu
> INFO: lockdep is turned off.
> irq event stamp: 0
> hardirqs last  enabled at (0): [<(null)>] (null)
> hardirqs last disabled at (0): [<ffffffff81070aa5>]
> copy_process+0x5e5/0x1670
> softirqs last  enabled at (0): [<ffffffff81070aa5>]
> copy_process+0x5e5/0x1670
> softirqs last disabled at (0): [<(null)>] (null)
> Pid: 610, comm: work_for_cpu Not tainted
> Call Trace:
>  [<ffffffff810b2d10>] ? print_irqtrace_events+0xd0/0xe0
>  [<ffffffff8105c1a7>] ? __might_sleep+0xf7/0x130
>  [<ffffffff81184efb>] ? kmem_cache_alloc_trace+0x20b/0x2d0
>  [<ffffffff8109709e>] ? __create_workqueue_key+0x3e/0x1d0
>  [<ffffffff8109709e>] ? __create_workqueue_key+0x3e/0x1d0
>  [<ffffffffa00c101c>] ? fnic_probe+0x977/0x11aa [fnic]
>  [<ffffffffa00c1048>] ? fnic_probe+0x9a3/0x11aa [fnic]
>  [<ffffffff81096f00>] ? do_work_for_cpu+0x0/0x30
>  [<ffffffff812c6da7>] ? local_pci_probe+0x17/0x20
>  [<ffffffff81096f18>] ? do_work_for_cpu+0x18/0x30
>  [<ffffffff8109cdc6>] ? kthread+0x96/0xa0
>  [<ffffffff8100c1ca>] ? child_rip+0xa/0x20
>  [<ffffffff81550f80>] ? _spin_unlock_irq+0x30/0x40
>  [<ffffffff8100bb10>] ? restore_args+0x0/0x30
>  [<ffffffff8109cd30>] ? kthread+0x0/0xa0
>  [<ffffffff8100c1c0>] ? child_rip+0x0/0x20

The problem is in this hunk of "FIP VLAN Discovery Feature Support"
(d3c995f1dcf938f1084388d92b8fb97bec366566)

create_singlethreaded_workqueue cannot be called with irqs disabled

@@ -620,7 +634,29 @@ static int __devinit fnic_probe(struct pci_dev
*pdev,
        vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
        vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
        vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
+       fnic->set_vlan = fnic_set_vlan;
        fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_AUTO);
+       setup_timer(&fnic->fip_timer, fnic_fip_notify_timer,
+                           (unsigned long)fnic);
+       spin_lock_init(&fnic->vlans_lock);
+       INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
+       INIT_WORK(&fnic->event_work, fnic_handle_event);
+       skb_queue_head_init(&fnic->fip_frame_queue);
+       spin_lock_irqsave(&fnic_list_lock, flags);
+       if (!fnic_fip_queue) {
+           fnic_fip_queue =
+               create_singlethread_workqueue("fnic_fip_q");
+           if (!fnic_fip_queue) {
+               spin_unlock_irqrestore(&fnic_list_lock, flags);
+               printk(KERN_ERR PFX "fnic FIP work queue "
+                        "create failed\n");
+               err = -ENOMEM;
+               goto err_out_free_max_pool;
+           }
+       }
+       spin_unlock_irqrestore(&fnic_list_lock, flags);
+       INIT_LIST_HEAD(&fnic->evlist);
+       INIT_LIST_HEAD(&fnic->vlans);
    } else {
        shost_printk(KERN_INFO, fnic->lport->host,
                 "firmware uses non-FIP mode\n");

The attempts to make fnic_fip_queue a single instance for the driver
while it's being created in probe look awkward anyway, why is this not
created in fnic_init_module like the event workqueue?

Built and loaded, tested all-right through probe without triggering the
same issue.  Not tested by me for functionality, as the fnic hardware I
had access to isn't actually attached to an FCoE SAN.

Signed-off-by: Chris Leech <cleech@redhat.com>
---

Patch Changelog

v2: At Hiral's request I've bumped the driver version

 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_main.c | 22 +++++++++-------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index b6d1f92..c18c681 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -38,7 +38,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.5.0.22"
+#define DRV_VERSION		"1.5.0.23"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f09d18..42e15ee 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -642,19 +642,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
 		INIT_WORK(&fnic->event_work, fnic_handle_event);
 		skb_queue_head_init(&fnic->fip_frame_queue);
-		spin_lock_irqsave(&fnic_list_lock, flags);
-		if (!fnic_fip_queue) {
-			fnic_fip_queue =
-				create_singlethread_workqueue("fnic_fip_q");
-			if (!fnic_fip_queue) {
-				spin_unlock_irqrestore(&fnic_list_lock, flags);
-				printk(KERN_ERR PFX "fnic FIP work queue "
-						 "create failed\n");
-				err = -ENOMEM;
-				goto err_out_free_max_pool;
-			}
-		}
-		spin_unlock_irqrestore(&fnic_list_lock, flags);
 		INIT_LIST_HEAD(&fnic->evlist);
 		INIT_LIST_HEAD(&fnic->vlans);
 	} else {
@@ -960,6 +947,13 @@ static int __init fnic_init_module(void)
 	spin_lock_init(&fnic_list_lock);
 	INIT_LIST_HEAD(&fnic_list);
 
+	fnic_fip_queue = create_singlethread_workqueue("fnic_fip_q");
+	if (!fnic_fip_queue) {
+		printk(KERN_ERR PFX "fnic FIP work queue create failed\n");
+		err = -ENOMEM;
+		goto err_create_fip_workq;
+	}
+
 	fnic_fc_transport = fc_attach_transport(&fnic_fc_functions);
 	if (!fnic_fc_transport) {
 		printk(KERN_ERR PFX "fc_attach_transport error\n");
@@ -978,6 +972,8 @@ static int __init fnic_init_module(void)
 err_pci_register:
 	fc_release_transport(fnic_fc_transport);
 err_fc_transport:
+	destroy_workqueue(fnic_fip_queue);
+err_create_fip_workq:
 	destroy_workqueue(fnic_event_queue);
 err_create_fnic_workq:
 	kmem_cache_destroy(fnic_io_req_cache);
-- 
1.8.1.4

