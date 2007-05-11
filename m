From: akpm@linux-foundation.org
Subject: [patch 19/28] drivers/scsi/pcmcia/nsp_cs.c: remove kernel 2.4 code
Date: Thu, 10 May 2007 23:01:03 -0700
Message-ID: <200705110601.l4B6131l008172@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758460AbXEKGJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:09:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pcmcia/nsp_cs.c |  159 +--------------------------------
 drivers/scsi/pcmcia/nsp_cs.h |    8 -
 2 files changed, 5 insertions(+), 162 deletions(-)

diff -puN drivers/scsi/pcmcia/nsp_cs.c~drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -25,8 +25,6 @@
 
 ***********************************************************************/
 
-/* $Id: nsp_cs.c,v 1.23 2003/08/18 11:09:19 elca Exp $ */
-
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -59,7 +57,7 @@
 #include "nsp_cs.h"
 
 MODULE_AUTHOR("YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>");
-MODULE_DESCRIPTION("WorkBit NinjaSCSI-3 / NinjaSCSI-32Bi(16bit) PCMCIA SCSI host adapter module $Revision: 1.23 $");
+MODULE_DESCRIPTION("WorkBit NinjaSCSI-3 / NinjaSCSI-32Bi(16bit) PCMCIA SCSI host adapter module");
 MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
 #ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL");
@@ -83,10 +81,6 @@ static struct scsi_host_template nsp_dri
 	.proc_name	         = "nsp_cs",
 	.proc_info		 = nsp_proc_info,
 	.name			 = "WorkBit NinjaSCSI-3/32Bi(16bit)",
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-	.detect			 = nsp_detect_old,
-	.release		 = nsp_release_old,
-#endif
 	.info			 = nsp_info,
 	.queuecommand		 = nsp_queuecommand,
 /*	.eh_abort_handler	 = nsp_eh_abort,*/
@@ -97,9 +91,6 @@ static struct scsi_host_template nsp_dri
 	.sg_tablesize		 = SG_ALL,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = DISABLE_CLUSTERING,
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
-	.use_new_eh_code	 = 1,
-#endif
 };
 
 static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
@@ -1313,11 +1304,7 @@ static struct Scsi_Host *nsp_detect(stru
 	nsp_hw_data *data_b = &nsp_data_base, *data;
 
 	nsp_dbg(NSP_DEBUG_INIT, "this_id=%d", sht->this_id);
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	host = scsi_host_alloc(&nsp_driver_template, sizeof(nsp_hw_data));
-#else
-	host = scsi_register(sht, sizeof(nsp_hw_data));
-#endif
 	if (host == NULL) {
 		nsp_dbg(NSP_DEBUG_INIT, "host failed");
 		return NULL;
@@ -1354,37 +1341,6 @@ static struct Scsi_Host *nsp_detect(stru
 	return host; /* detect done. */
 }
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static int nsp_detect_old(struct scsi_host_template *sht)
-{
-	if (nsp_detect(sht) == NULL) {
-		return 0;
-	} else {
-		//MOD_INC_USE_COUNT;
-		return 1;
-	}
-}
-
-
-static int nsp_release_old(struct Scsi_Host *shpnt)
-{
-	//nsp_hw_data *data = (nsp_hw_data *)shpnt->hostdata;
-
-	/* PCMCIA Card Service dose same things below. */
-	/* So we do nothing.                           */
-	//if (shpnt->irq) {
-	//	free_irq(shpnt->irq, data->ScsiInfo);
-	//}
-	//if (shpnt->io_port) {
-	//	release_region(shpnt->io_port, shpnt->n_io_port);
-	//}
-
-	//MOD_DEC_USE_COUNT;
-
-	return 0;
-}
-#endif
-
 /*----------------------------------------------------------------*/
 /* return info string						  */
 /*----------------------------------------------------------------*/
@@ -1403,19 +1359,9 @@ static const char *nsp_info(struct Scsi_
 			nsp_dbg(NSP_DEBUG_PROC, "buffer=0x%p pos=0x%p length=%d %d\n", buffer, pos, length,  length - (pos - buffer));\
 		} \
 	} while(0)
-static int
-nsp_proc_info(
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	struct Scsi_Host *host,
-#endif
-	char  *buffer,
-	char **start,
-	off_t  offset,
-	int    length,
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	int    hostno,
-#endif
-	int    inout)
+
+static int nsp_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+			 off_t offset, int length, int inout)
 {
 	int id;
 	char *pos = buffer;
@@ -1423,24 +1369,13 @@ nsp_proc_info(
 	int speed;
 	unsigned long flags;
 	nsp_hw_data *data;
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	struct Scsi_Host *host;
-#else
 	int hostno;
-#endif
+
 	if (inout) {
 		return -EINVAL;
 	}
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	hostno = host->host_no;
-#else
-	/* search this HBA host */
-	host = scsi_host_hn_get(hostno);
-	if (host == NULL) {
-		return -ESRCH;
-	}
-#endif
 	data = (nsp_hw_data *)host->hostdata;
 
 
@@ -1676,10 +1611,6 @@ static int nsp_cs_config(struct pcmcia_d
 	cistpl_cftable_entry_t dflt = { 0 };
 	struct Scsi_Host *host;
 	nsp_hw_data      *data = &nsp_data_base;
-#if !(LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
-	struct scsi_device	 *dev;
-	dev_node_t	**tail, *node;
-#endif
 
 	nsp_dbg(NSP_DEBUG_INIT, "in");
 
@@ -1812,17 +1743,7 @@ static int nsp_cs_config(struct pcmcia_d
 		goto cs_failed;
 	}
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
 	host = nsp_detect(&nsp_driver_template);
-#else
-	scsi_register_host(&nsp_driver_template);
-	for (host = scsi_host_get_next(NULL); host != NULL;
-	     host = scsi_host_get_next(host)) {
-		if (host->hostt == &nsp_driver_template) {
-			break;
-		}
-	}
-#endif
 
 	if (host == NULL) {
 		nsp_dbg(NSP_DEBUG_INIT, "detect failed");
@@ -1830,7 +1751,6 @@ static int nsp_cs_config(struct pcmcia_d
 	}
 
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
 	ret = scsi_add_host (host, NULL);
 	if (ret)
 		goto cs_failed;
@@ -1841,52 +1761,6 @@ static int nsp_cs_config(struct pcmcia_d
 	link->dev_node  = &info->node;
 	info->host = host;
 
-#else
-	nsp_dbg(NSP_DEBUG_INIT, "GET_SCSI_INFO");
-	tail = &link->dev_node;
-	info->ndev = 0;
-
-	nsp_dbg(NSP_DEBUG_INIT, "host=0x%p", host);
-
-	for (dev = host->host_queue; dev != NULL; dev = dev->next) {
-		unsigned long id;
-		id = (dev->id & 0x0f) + ((dev->lun & 0x0f) << 4) +
-			((dev->channel & 0x0f) << 8) +
-			((dev->host->host_no & 0x0f) << 12);
-		node = &info->node[info->ndev];
-		node->minor = 0;
-		switch (dev->type) {
-		case TYPE_TAPE:
-			node->major = SCSI_TAPE_MAJOR;
-			snprintf(node->dev_name, sizeof(node->dev_name), "st#%04lx", id);
-			break;
-		case TYPE_DISK:
-		case TYPE_MOD:
-			node->major = SCSI_DISK0_MAJOR;
-			snprintf(node->dev_name, sizeof(node->dev_name), "sd#%04lx", id);
-			break;
-		case TYPE_ROM:
-		case TYPE_WORM:
-			node->major = SCSI_CDROM_MAJOR;
-			snprintf(node->dev_name, sizeof(node->dev_name), "sr#%04lx", id);
-			break;
-		default:
-			node->major = SCSI_GENERIC_MAJOR;
-			snprintf(node->dev_name, sizeof(node->dev_name), "sg#%04lx", id);
-			break;
-		}
-		*tail = node; tail = &node->next;
-		info->ndev++;
-		info->host = dev->host;
-	}
-
-	*tail = NULL;
-	if (info->ndev == 0) {
-		nsp_msg(KERN_INFO, "no SCSI devices found");
-	}
-	nsp_dbg(NSP_DEBUG_INIT, "host=0x%p", host);
-#endif
-
 	/* Finally, report what we've done */
 	printk(KERN_INFO "nsp_cs: index 0x%02x: ",
 	       link->conf.ConfigIndex);
@@ -1939,13 +1813,9 @@ static void nsp_cs_release(struct pcmcia
 	nsp_dbg(NSP_DEBUG_INIT, "link=0x%p", link);
 
 	/* Unlink the device chain */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,2))
 	if (info->host != NULL) {
 		scsi_remove_host(info->host);
 	}
-#else
-	scsi_unregister_host(&nsp_driver_template);
-#endif
 	link->dev_node = NULL;
 
 	if (link->win) {
@@ -1955,11 +1825,9 @@ static void nsp_cs_release(struct pcmcia
 	}
 	pcmcia_disable_device(link);
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,2))
 	if (info->host != NULL) {
 		scsi_host_put(info->host);
 	}
-#endif
 } /* nsp_cs_release */
 
 static int nsp_cs_suspend(struct pcmcia_device *link)
@@ -2006,7 +1874,6 @@ static int nsp_cs_resume(struct pcmcia_d
 /*======================================================================*
  *	module entry point
  *====================================================================*/
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,68))
 static struct pcmcia_device_id nsp_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID123("IO DATA", "CBSC16       ", "1", 0x547e66dc, 0x0d63a3fd, 0x51de003a),
 	PCMCIA_DEVICE_PROD_ID123("KME    ", "SCSI-CARD-001", "1", 0x534c02bc, 0x52008408, 0x51de003a),
@@ -2030,28 +1897,12 @@ static struct pcmcia_driver nsp_driver =
 	.suspend	= nsp_cs_suspend,
 	.resume		= nsp_cs_resume,
 };
-#endif
 
 static int __init nsp_cs_init(void)
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,68))
 	nsp_msg(KERN_INFO, "loading...");
 
 	return pcmcia_register_driver(&nsp_driver);
-#else
-	servinfo_t serv;
-
-	nsp_msg(KERN_INFO, "loading...");
-	pcmcia_get_card_services_info(&serv);
-	if (serv.Revision != CS_RELEASE_CODE) {
-		nsp_msg(KERN_DEBUG, "Card Services release does not match!");
-		return -EINVAL;
-	}
-	register_pcmcia_driver(&dev_info, &nsp_cs_attach, &nsp_cs_detach);
-
-	nsp_dbg(NSP_DEBUG_INIT, "out");
-	return 0;
-#endif
 }
 
 static void __exit nsp_cs_exit(void)
diff -puN drivers/scsi/pcmcia/nsp_cs.h~drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code drivers/scsi/pcmcia/nsp_cs.h
--- a/drivers/scsi/pcmcia/nsp_cs.h~drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code
+++ a/drivers/scsi/pcmcia/nsp_cs.h
@@ -10,8 +10,6 @@
 
 =========================================================*/
 
-/* $Id: nsp_cs.h,v 1.19 2003/08/18 11:09:19 elca Exp $ */
-
 #ifndef  __nsp_cs__
 #define  __nsp_cs__
 
@@ -227,13 +225,7 @@
 typedef struct scsi_info_t {
 	struct pcmcia_device	*p_dev;
 	struct Scsi_Host      *host;
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
 	dev_node_t             node;
-#else
-	int	               ndev;
-	dev_node_t             node[8];
-	struct bus_operations *bus;
-#endif
 	int                    stop;
 } scsi_info_t;
 
_
