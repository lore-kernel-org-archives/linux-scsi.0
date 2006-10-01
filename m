From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] enable clustering for tmscsim
Date: Sun, 1 Oct 2006 12:00:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610011148410.4007@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:15027 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751704AbWJAKAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Oct 2006 06:00:46 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.36 #1 (Debian))
	id 1GTy7s-0004Xs-00
	for <linux-scsi@vger.kernel.org>; Sun, 01 Oct 2006 12:00:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

following an email from John Adams <johna@onevista.com> to me with a patch 
to enable tmscsim to use blocks up to 1MB and a discussion on linux-scsi, 
below is a patch to enable clustering for tmscsim. I made it switchable 
with a module parameter, with default "enable" - in case somebody gets 
problems with it. Unfortunately, I was not able to check if this alone 
lets you use any bigger blocks with a tape, as my tape seems to only 
support 1 block size - only "mt setblk 1" is successful, any other value 
fails. OTOH, testing on a P-133 showed that enabling clustering alone 
improves throughput by 10% and reduces CPU load by another 10%, so, seems 
a worthy thing to do. As for setting max_sectors, that might become a 
separate patch...

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Enable clustering on tmscsim by default, but allow switching it off with a 
module parameter. In a test it increased throughput by 10% and reduced CPU 
load by another 10%.

diff -u -p a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	8 Feb 2006 23:08:48 -0000
+++ b/drivers/scsi/tmscsim.c	30 Sep 2006 19:10:53 -0000
@@ -280,6 +280,10 @@ static void dc390_ResetDevParam(struct d
 static u32	dc390_laststatus = 0;
 static u8	dc390_adapterCnt = 0;
 
+static int disable_clustering;
+module_param(disable_clustering, int, S_IRUGO);
+MODULE_PARM_DESC(disable_clustering, "If you experience problems with your devices, try setting to 1");
+
 /* Startup values, to be overriden on the commandline */
 static int tmscsim[] = {-2, -2, -2, -2, -2, -2};
 
@@ -2300,7 +2304,7 @@ static struct scsi_host_template driver_
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.use_clustering		= ENABLE_CLUSTERING,
 };
 
 /***********************************************************************
@@ -2526,6 +2530,8 @@ static int __devinit dc390_probe_one(str
 	pci_set_master(pdev);
 
 	error = -ENOMEM;
+	if (disable_clustering)
+		driver_template.use_clustering = DISABLE_CLUSTERING;
 	shost = scsi_host_alloc(&driver_template, sizeof(struct dc390_acb));
 	if (!shost)
 		goto out_disable_device;
@@ -2661,6 +2667,10 @@ static struct pci_driver dc390_driver = 
 
 static int __init dc390_module_init(void)
 {
+	if (!disable_clustering)
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
+		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;
 		tmscsim[1] = 4;
