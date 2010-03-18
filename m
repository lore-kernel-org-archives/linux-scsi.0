From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/12] mptfusion: mpt_detach is called properly at the time of rmmod
Date: Thu, 18 Mar 2010 19:18:30 +0530
Message-ID: <20100318134820.GE22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37228 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab0CROTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:19:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Current design of mptsas is as follow.
MPTSAS will do probe() if pci id matches for available card in
system, irrespective of mode of controller. If controller is I/T mode
or I mode, things are fine. If controller is only in T mode, mptsas is
not doing complete process of mptsas_probe(). It will only make
sure IOC structure is created and IOC reference is available for
mptstm driver. Now While removing module we should take care
case of Target mode only mptsas. If we are removing IOC which is
only in Target mode, We should only detach IOC instead of
following rest of the cleanup process which is only required for T
mode controller. Now For T mode controller, only part clean up is
done instead of complete cleanup. mpt_detach will call early in case
of Target mode only controller.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 977d800..80d7f7d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5072,6 +5072,12 @@ static void __devexit mptsas_remove(struct pci_dev *pdev)
 	struct mptsas_portinfo *p, *n;
 	int i;
 
+	if (!ioc->sh) {
+		printk(MYIOC_s_INFO_FMT "IOC is in Target mode\n", ioc->name);
+		mpt_detach(pdev);
+		return;
+	}
+
 	mptsas_shutdown(pdev);
 
 	mptsas_del_device_components(ioc);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ea68970..04bae41 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1148,11 +1148,6 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_SCSI_HOST		*hd;
 	int sz1;
 
-	if(!host) {
-		mpt_detach(pdev);
-		return;
-	}
-
 	scsi_remove_host(host);
 
 	if((hd = shost_priv(host)) == NULL)
