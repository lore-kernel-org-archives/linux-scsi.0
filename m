From: ching <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.1 2/16 update 3] arcmsr:  Adding code to support
 MSI-X interrupt
Date: Mon, 12 May 2014 19:55:33 +0800
Message-ID: <1399895733.4349.2.camel@localhost>
References: <1399463548.23184.6.camel@localhost>
	 <536A43AF.6060908@redhat.com> <1399549025.25794.4.camel@localhost>
	 <536CB8EB.3040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <536CB8EB.3040401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

Thanks for your remind again.
The patch 17/17 will be as following.
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-08 17:45:34.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-12 10:50:28.000000000 +0800
@@ -778,12 +778,11 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
-		goto RAID_controller_stop;
+		goto free_ccb_pool;
 	}
 	if (arcmsr_request_irq(pdev, acb) == ARC_FAILURE)
 		goto scsi_host_remove;
 	arcmsr_iop_init(acb);
-    	scsi_scan_host(host);
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
@@ -795,13 +794,17 @@ static int arcmsr_probe(struct pci_dev *
 	add_timer(&acb->eternal_timer);
 	if(arcmsr_alloc_sysfs_attr(acb))
 		goto out_free_sysfs;
+    	scsi_scan_host(host);
 	return 0;
 out_free_sysfs:
-scsi_host_remove:
-	scsi_remove_host(host);
-RAID_controller_stop:
+	del_timer_sync(&acb->eternal_timer);
+	flush_scheduled_work();
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
+	arcmsr_free_irq(pdev, acb);
+scsi_host_remove:
+	scsi_remove_host(host);
+free_ccb_pool:
 	arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
 	arcmsr_free_mu(acb);



On Fri, 2014-05-09 at 13:15 +0200, Tomas Henzl wrote:
> On 05/08/2014 01:37 PM, ching wrote:
> > Hi Tomas,
> >
> > Thanks for your suggestion.
> > I will add a new patch 17/17 at last.
> 
> This additional patch was meant for moving the scsi_scan_host, because it's
> nor related to the ms-x interrupts. Probably  the maintainer will prefer
> a single patch which changes msi-x at once, I don't care.
> To the patch below - you should also free the allocated irqs as I wrote previously.
> 
> Cheers,
> Tomas
> 
