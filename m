From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mpt3sas: delay scsi_add_host call to work with scsi-mq
Date: Fri, 6 Jun 2014 07:03:06 -0700
Message-ID: <20140606140306.GA21958@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958B051A0@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaFFODJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 10:03:09 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B051A0@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "Nagalakshmi.Nandigama@lsi.com" <Nagalakshmi.Nandigama@lsi.com>, "Sreekanth.Reddy@lsi.com" <Sreekanth.Reddy@lsi.com>, Adam Radford <adam.radford@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Joe Maloy <joe.maloy@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Turns out git-am didn't like your patch, although I don't understand
why.  I just manually reapplied it and also applied it to mpt2sas while
at it, find the two patches I put into the tree below.

LSI folks:  can you look over this?  I also think the sas_remove_host
and scsi_remove_host calks in _scsih_remove are way too later for both
drivers still, they should be done at the beginning of the function just
after setting ioc->remove_host = 1.  Can you please look into verifying
the patches below, and look into sorting out the host removal?  Thanks!


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mpt3sas-delay-scsi_add_host-call-to-work-with-scsi-m.patch"

>From 8f3571a791c7adf633edf4c4d00c7c8fca2bdb54 Mon Sep 17 00:00:00 2001
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Date: Fri, 6 Jun 2014 15:59:25 +0200
Subject: mpt3sas: delay scsi_add_host call to work with scsi-mq

In _scsih_probe, delay the call to scsi_add_host until the host has been
fully set up.

Otherwise, the default .can_queue value of 1 causes scsi-mq to set the block
layer request queue size to its minimum size, resulting in awful performance.

In _scsih_probe error handling, call mpt3sas_base_detach rather than
scsi_remove_host to properly clean up in reverse order.

In _scsih_remove, call scsi_remove_host earlier to clean up in reverse order.

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 18e713d..52e4038 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7431,9 +7431,9 @@ static void _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
+	scsi_remove_host(shost);
 	mpt3sas_base_detach(ioc);
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 }
 
@@ -7801,13 +7801,6 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	if ((scsi_add_host(shost, &pdev->dev))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		list_del(&ioc->list);
-		goto out_add_shost_fail;
-	}
-
 	/* register EEDP capabilities with SCSI layer */
 	if (prot_mask > 0)
 		scsi_host_set_prot(shost, prot_mask);
@@ -7835,15 +7828,23 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out_attach_fail;
 	}
+
+	if ((scsi_add_host(shost, &pdev->dev))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		list_del(&ioc->list);
+		goto out_add_shost_fail;
+	}
+
 	scsi_scan_host(shost);
 	return 0;
 
+ out_add_shost_fail:
+	mpt3sas_base_detach(ioc);
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);
  out_thread_fail:
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
- out_add_shost_fail:
 	scsi_host_put(shost);
 	return -ENODEV;
 }
-- 
1.7.10.4


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-mpt2sas-delay-scsi_add_host-call-to-work-with-scsi-m.patch"

>From 0b48e7f2cce8c1f91eff27dd6d48deadba83f58f Mon Sep 17 00:00:00 2001
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Date: Fri, 6 Jun 2014 16:02:42 +0200
Subject: mpt2sas: delay scsi_add_host call to work with scsi-mq

In _scsih_probe, delay the call to scsi_add_host until the host has been
fully set up.

Otherwise, the default .can_queue value of 1 causes scsi-mq to set the block
layer request queue size to its minimum size, resulting in awful performance.

In _scsih_probe error handling, call mpt3sas_base_detach rather than
scsi_remove_host to properly clean up in reverse order.

In _scsih_remove, call scsi_remove_host earlier to clean up in reverse order.

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5055f92..4f8a45f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7857,9 +7857,9 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
+	scsi_remove_host(shost);
 	mpt2sas_base_detach(ioc);
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 }
 
@@ -8200,13 +8200,6 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	if ((scsi_add_host(shost, &pdev->dev))) {
-		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		list_del(&ioc->list);
-		goto out_add_shost_fail;
-	}
-
 	/* register EEDP capabilities with SCSI layer */
 	if (prot_mask)
 		scsi_host_set_prot(shost, prot_mask);
@@ -8248,16 +8241,23 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	} else
 		ioc->hide_drives = 0;
+
+	if ((scsi_add_host(shost, &pdev->dev))) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out_add_shost_fail;
+	}
+
 	scsi_scan_host(shost);
 
 	return 0;
 
+ out_add_shost_fail:
+	mpt2sas_base_detach(ioc);
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);
  out_thread_fail:
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
- out_add_shost_fail:
 	scsi_host_put(shost);
 	return -ENODEV;
 }
-- 
1.7.10.4


--qMm9M+Fa2AknHoGS--
