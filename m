From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/2] sas transport: ref count update
Date: Mon, 27 Mar 2006 09:37:28 -0800
Message-ID: <20060327173728.GB29353@us.ibm.com>
References: <20060322214119.GA661@us.ibm.com> <20060322214221.GB661@us.ibm.com> <20060325035648.GB19970@us.ibm.com> <1143304763.3049.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54938 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750916AbWC0Ruo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:50:44 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2RHocQb006495
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 12:50:38 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2RHoSRZ237016
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 12:50:28 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2RHoR6i002164
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 12:50:28 -0500
Content-Disposition: inline
In-Reply-To: <1143304763.3049.34.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-03-24 at 19:56 -0800, Mike Anderson wrote:
> > Can I get your comment(s) on this change.
> 
> This looks correct as far as it goes, but it's not complete.
> sas_phy_free() and sas_rphy_free() now do too many parent puts with this
> change (actually, two too many in each case, which looks like a bug in
> the original code).  There also looks to be two spurious puts in the
> rphy (for expander and end device) allocation error paths (again, a bug
> in the original code).

ok, here is an updated patch that covers these cases also. I moved to
using the releases functions in the *_free() cases also as it seems like a
good idea to use the release functions if you can. I have compiled and
tested it on a aic based system, but it does not call the free functions.

-andmike
--
Michael Anderson
andmike@us.ibm.com

Fix puts so that release functions will be called.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/scsi_transport_sas.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_transport_sas.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_transport_sas.c	2006-03-24 13:58:17.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_transport_sas.c	2006-03-27 09:23:43.000000000 -0800
@@ -406,8 +406,6 @@ struct sas_phy *sas_phy_alloc(struct dev
 	if (!phy)
 		return NULL;
 
-	get_device(parent);
-
 	phy->number = number;
 
 	device_initialize(&phy->dev);
@@ -459,10 +457,7 @@ EXPORT_SYMBOL(sas_phy_add);
 void sas_phy_free(struct sas_phy *phy)
 {
 	transport_destroy_device(&phy->dev);
-	put_device(phy->dev.parent);
-	put_device(phy->dev.parent);
-	put_device(phy->dev.parent);
-	kfree(phy);
+	put_device(&phy->dev);
 }
 EXPORT_SYMBOL(sas_phy_free);
 
@@ -484,7 +479,7 @@ sas_phy_delete(struct sas_phy *phy)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
-	put_device(dev->parent);
+	put_device(dev);
 }
 EXPORT_SYMBOL(sas_phy_delete);
 
@@ -800,7 +795,6 @@ struct sas_rphy *sas_end_device_alloc(st
 
 	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
-		put_device(&parent->dev);
 		return NULL;
 	}
 
@@ -836,7 +830,6 @@ struct sas_rphy *sas_expander_alloc(stru
 
 	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
-		put_device(&parent->dev);
 		return NULL;
 	}
 
@@ -910,6 +903,7 @@ EXPORT_SYMBOL(sas_rphy_add);
  */
 void sas_rphy_free(struct sas_rphy *rphy)
 {
+	struct device *dev = &rphy->dev;
 	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent->parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
@@ -917,21 +911,9 @@ void sas_rphy_free(struct sas_rphy *rphy
 	list_del(&rphy->list);
 	mutex_unlock(&sas_host->lock);
 
-	transport_destroy_device(&rphy->dev);
-	put_device(rphy->dev.parent);
-	put_device(rphy->dev.parent);
-	put_device(rphy->dev.parent);
-	if (rphy->identify.device_type == SAS_END_DEVICE) {
-		struct sas_end_device *edev = rphy_to_end_device(rphy);
-
-		kfree(edev);
-	} else {
-		/* must be expander */
-		struct sas_expander_device *edev =
-			rphy_to_expander_device(rphy);
+	transport_destroy_device(dev);
 
-		kfree(edev);
-	}
+	put_device(dev);
 }
 EXPORT_SYMBOL(sas_rphy_free);
 
@@ -971,7 +953,7 @@ sas_rphy_delete(struct sas_rphy *rphy)
 
 	parent->rphy = NULL;
 
-	put_device(&parent->dev);
+	put_device(dev);
 }
 EXPORT_SYMBOL(sas_rphy_delete);
 
