From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] update nsp_cs to use scsi_add_host / scsi_remove_host
Date: Wed, 26 Feb 2003 20:26:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226202611.A8526@lst.de>
References: <20030226202005.A8461@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030226202005.A8461@lst.de>; from hch@lst.de on Wed, Feb 26, 2003 at 08:20:05PM +0100
List-Id: linux-scsi@vger.kernel.org
To: yokota@netlab.is.tsukuba.ac.jp
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 26, 2003 at 08:20:05PM +0100, Christoph Hellwig wrote:
> This patch updates nsp_cs to use scsi_add_host / scsi_remove_host when
> compiledfor Linux 2.5 which allows to get rid of the scsi host list
> walks and is a preparation for allowing to support multiple cards of
> this type.

Sorry, I sent you the wrong paetch, here's the right one:


--- 1.16/drivers/scsi/pcmcia/nsp_cs.c	Sun Feb 16 14:30:27 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.c	Wed Feb 26 20:18:50 2003
@@ -128,7 +128,7 @@
 MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
 
 /* /usr/src/linux/drivers/scsi/hosts.h */
-static Scsi_Host_Template driver_template = {
+static Scsi_Host_Template nsp_driver_template = {
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0))
 	.proc_name	         = "nsp_cs",      /* kernel 2.4 */
 #else
@@ -136,8 +136,10 @@
 #endif
 	.proc_info		 = nsp_proc_info,
 	.name			 = "WorkBit NinjaSCSI-3/32Bi(16bit)",
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
 	.detect			 = nsp_detect,
 	.release		 = nsp_release,
+#endif
 	.info			 = nsp_info,
 	.queuecommand		 = nsp_queuecommand,
 /*	.eh_strategy_handler	 = nsp_eh_strategy,*/
@@ -1215,7 +1217,7 @@
 /*----------------------------------------------------------------*/
 /* look for ninja3 card and init if found			  */
 /*----------------------------------------------------------------*/
-static int nsp_detect(Scsi_Host_Template *sht)
+static struct Scsi_Host *__nsp_detect(Scsi_Host_Template *sht)
 {
 	struct Scsi_Host *host;	/* registered host structure */
 	nsp_hw_data *data = &nsp_data;
@@ -1225,7 +1227,7 @@
 	request_region(data->BaseAddress, data->NumAddress, "nsp_cs");
 	host		  = scsi_register(sht, 0);
 	if(host == NULL)
-		return 0;
+		return NULL;
 
 	host->unique_id	  = data->BaseAddress;
 	host->io_port	  = data->BaseAddress;
@@ -1252,7 +1254,13 @@
 
 	//MOD_INC_USE_COUNT;
 
-	return 1; /* detect done. */
+	return host;
+}
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
+static int nsp_detect(Scsi_Host_Template *sht)
+{
+	return (__nsp_detect(sht) != NULL);
 }
 
 static int nsp_release(struct Scsi_Host *shpnt)
@@ -1271,6 +1279,7 @@
 
 	return 0;
 }
+#endif
 
 /*----------------------------------------------------------------*/
 /* return info string						  */
@@ -1763,55 +1772,53 @@
 	}
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
-	scsi_register_host(&driver_template);
+	host = __nsp_detect(&nsp_driver_template);
 #else
-	scsi_register_module(MODULE_SCSI_HA, &driver_template);
+	scsi_register_module(MODULE_SCSI_HA, &nsp_driver_template);
+	for (host = scsi_hostlist; host != NULL; host = host->next) {
+		if (host->hostt == &nsp_driver_template)
+			break;
 #endif
 
+	if (!host)
+		goto cs_failed;
+
 	DEBUG(0, "GET_SCSI_INFO\n");
 	tail = &link->dev;
 	info->ndev = 0;
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,45))
-	for (host = scsi_host_get_next(NULL); host;
-	     host = scsi_host_get_next(host)) {
-#else
-	for (host = scsi_hostlist; host != NULL; host = host->next) {
-#endif
-		if (host->hostt == &driver_template) {
-	    		list_for_each_entry (dev, &host->my_devices, siblings) {
-				u_long arg[2], id;
-				kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
-				id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
-					((arg[0]>>8)&0xf00) + ((arg[0]>>12)&0xf000);
-				node = &info->node[info->ndev];
-				node->minor = 0;
-				switch (dev->type) {
-				case TYPE_TAPE:
-					node->major = SCSI_TAPE_MAJOR;
-					sprintf(node->dev_name, "st#%04lx", id);
-					break;
-				case TYPE_DISK:
-				case TYPE_MOD:
-					node->major = SCSI_DISK0_MAJOR;
-					sprintf(node->dev_name, "sd#%04lx", id);
-					break;
-				case TYPE_ROM:
-				case TYPE_WORM:
-					node->major = SCSI_CDROM_MAJOR;
-					sprintf(node->dev_name, "sr#%04lx", id);
-					break;
-				default:
-					node->major = SCSI_GENERIC_MAJOR;
-					sprintf(node->dev_name, "sg#%04lx", id);
-					break;
-				}
-				*tail = node; tail = &node->next;
-				info->ndev++;
-				info->host = dev->host;
-			}
+	list_for_each_entry (dev, &host->my_devices, siblings) {
+		u_long arg[2], id;
+		kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
+		id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
+			((arg[0]>>8)&0xf00) + ((arg[0]>>12)&0xf000);
+		node = &info->node[info->ndev];
+		node->minor = 0;
+		switch (dev->type) {
+		case TYPE_TAPE:
+			node->major = SCSI_TAPE_MAJOR;
+			sprintf(node->dev_name, "st#%04lx", id);
+			break;
+		case TYPE_DISK:
+		case TYPE_MOD:
+			node->major = SCSI_DISK0_MAJOR;
+			sprintf(node->dev_name, "sd#%04lx", id);
+			break;
+		case TYPE_ROM:
+		case TYPE_WORM:
+			node->major = SCSI_CDROM_MAJOR;
+			sprintf(node->dev_name, "sr#%04lx", id);
+			break;
+		default:
+			node->major = SCSI_GENERIC_MAJOR;
+			sprintf(node->dev_name, "sg#%04lx", id);
+			break;
 		}
+		*tail = node; tail = &node->next;
+		info->ndev++;
+		info->host = dev->host;
 	}
+
 	*tail = NULL;
 	if (info->ndev == 0) {
 		printk(KERN_INFO "nsp_cs: no SCSI devices found\n");
@@ -1839,6 +1846,10 @@
 		       req.Base+req.Size-1);
 	printk("\n");
 
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
+	scsi_add_host(host, NULL);
+#endif
+
 	link->state &= ~DEV_CONFIG_PENDING;
 	return;
 
@@ -1859,6 +1870,7 @@
 static void nsp_cs_release(u_long arg)
 {
 	dev_link_t *link = (dev_link_t *)arg;
+	scsi_info_t *info = link->priv;
 
 	DEBUG(0, "%s(0x%p)\n", __FUNCTION__, link);
 
@@ -1874,10 +1886,11 @@
 	}
 
 	/* Unlink the device chain */
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
-	scsi_unregister_host(&driver_template);
+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,2))
+	scsi_unregister_module(MODULE_SCSI_HA, &nsp_driver_template);
 #else
-	scsi_unregister_module(MODULE_SCSI_HA, &driver_template);
+	scsi_remove_host(info->host);
+	scsi_unregister(info->host);
 #endif
 	link->dev = NULL;
 
--- 1.7/drivers/scsi/pcmcia/nsp_cs.h	Fri Jan  3 14:17:04 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.h	Wed Feb 26 20:19:43 2003
@@ -280,8 +280,6 @@
 static unsigned int nsphw_start_selection(Scsi_Cmnd *SCpnt, nsp_hw_data *data);
 static void nsp_start_timer(Scsi_Cmnd *SCpnt, nsp_hw_data *data, int time);
 
-static int nsp_detect(Scsi_Host_Template * );
-static int nsp_release(struct Scsi_Host *shpnt);
 static const char *nsp_info(struct Scsi_Host *shpnt);
 static int nsp_proc_info(char *buffer, char **start, off_t offset,
 			 int length, int hostno, int inout);
