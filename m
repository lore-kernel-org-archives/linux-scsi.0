From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill pcmcia driver bind_info horror
Date: Sun, 27 Apr 2003 01:09:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427010945.A23391@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:38920 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S262671AbTDZW5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 18:57:34 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-pcmcia@lists.infradead.org

Currenty pcmcia drivers do a loop on their devices for issuing a
SCSI_IOCTL_GET_IDLUN ioctl from kernelspace and passing dev->type
to userspace so cardmgr can guess the the dev_t and find the
device node of it.

But it doesn't actually use it but only pass it as optional arguments
to it's poor-man's hotplug scripts.  So kill this horror of, we
have proper hotplug scripts in 2.5.  And here we go, the first big
host->my_devices abuser is gone.


--- 1.13/drivers/scsi/pcmcia/aha152x_stub.c	Thu Mar 27 10:01:39 2003
+++ edited/drivers/scsi/pcmcia/aha152x_stub.c	Sat Apr 26 22:27:47 2003
@@ -98,9 +98,8 @@
 
 typedef struct scsi_info_t {
     dev_link_t		link;
+    dev_node_t		node;
     struct Scsi_Host	*host;
-    int			ndev;
-    dev_node_t		node[8];
 } scsi_info_t;
 
 static void aha152x_release_cs(u_long arg);
@@ -227,8 +226,6 @@
     cisparse_t parse;
     int i, last_ret, last_fn;
     u_char tuple_data[64];
-    struct scsi_device *dev;
-    dev_node_t *node, **tail;
     struct Scsi_Host *host;
     
     DEBUG(0, "aha152x_config(0x%p)\n", link);
@@ -285,9 +282,6 @@
     if (ext_trans)
         s.ext_trans = ext_trans;
 
-    tail = &link->dev;
-    info->ndev = 0;
-
     host = aha152x_probe_one(&s);
     if (host == NULL) {
 	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
@@ -296,39 +290,10 @@
 
     scsi_add_host(host, NULL);
 
-    list_for_each_entry(dev, &host->my_devices, siblings) {
-	    u_long arg[2], id;
-	    kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
-	    id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
-		((arg[0]>>8)&0xf00) + ((arg[0]>>12)&0xf000);
-	    node = &info->node[info->ndev];
-	    node->minor = 0;
-	    switch (dev->type) {
-	    case TYPE_TAPE:
-		node->major = SCSI_TAPE_MAJOR;
-		sprintf(node->dev_name, "st#%04lx", id);
-		break;
-	    case TYPE_DISK:
-	    case TYPE_MOD:
-		node->major = SCSI_DISK0_MAJOR;
-		sprintf(node->dev_name, "sd#%04lx", id);
-		break;
-	    case TYPE_ROM:
-	    case TYPE_WORM:
-		node->major = SCSI_CDROM_MAJOR;
-		sprintf(node->dev_name, "sr#%04lx", id);
-		break;
-	    default:
-		node->major = SCSI_GENERIC_MAJOR;
-		sprintf(node->dev_name, "sg#%04lx", id);
-		break;
-	    }
-	    *tail = node; tail = &node->next;
-	    info->ndev++;
-	    info->host = dev->host;
-    }
+    sprintf(info->node.dev_name, "scsi%d", host->host_no);
+    link->dev = &info->node;
+    info->host = host;
 
-    *tail = NULL;
     link->state &= ~DEV_CONFIG_PENDING;
     return;
     
===== drivers/scsi/pcmcia/fdomain_stub.c 1.14 vs edited =====
--- 1.14/drivers/scsi/pcmcia/fdomain_stub.c	Sun Mar 23 17:34:13 2003
+++ edited/drivers/scsi/pcmcia/fdomain_stub.c	Sat Apr 26 22:28:13 2003
@@ -81,9 +81,8 @@
 
 typedef struct scsi_info_t {
     dev_link_t		link;
+    dev_node_t		node;
     struct Scsi_Host	*host;
-    int			ndev;
-    dev_node_t		node[8];
 } scsi_info_t;
 
 extern Scsi_Host_Template fdomain_driver_template;
@@ -216,8 +215,6 @@
     cisparse_t parse;
     int i, last_ret, last_fn, ints[3];
     u_char tuple_data[64];
-    Scsi_Device *dev;
-    dev_node_t *node, **tail;
     char str[16];
     struct Scsi_Host *host;
 
@@ -269,42 +266,8 @@
  
     scsi_add_host(host, NULL);
 
-    tail = &link->dev;
-    info->ndev = 0;
-   
-    list_for_each_entry (dev, &host->my_devices, siblings) {
-	    u_long arg[2], id;
-	    kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
-	    id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
-		((arg[0]>>8)&0xf00) + ((arg[0]>>12)&0xf000);
-	    node = &info->node[info->ndev];
-	    node->minor = 0;
-	    switch (dev->type) {
-	    case TYPE_TAPE:
-		node->major = SCSI_TAPE_MAJOR;
-		sprintf(node->dev_name, "st#%04lx", id);
-		break;
-	    case TYPE_DISK:
-	    case TYPE_MOD:
-		node->major = SCSI_DISK0_MAJOR;
-		sprintf(node->dev_name, "sd#%04lx", id);
-		break;
-	    case TYPE_ROM:
-	    case TYPE_WORM:
-		node->major = SCSI_CDROM_MAJOR;
-		sprintf(node->dev_name, "sr#%04lx", id);
-		break;
-	    default:
-		node->major = SCSI_GENERIC_MAJOR;
-		sprintf(node->dev_name, "sg#%04lx", id);
-		break;
-	    }
-	    *tail = node; tail = &node->next;
-	    info->ndev++;
-
-    }
-
-    *tail = NULL;
+    sprintf(info->node.dev_name, "scsi%d", host->host_no);
+    link->dev = &info->node;
     info->host = host;
     
     link->state &= ~DEV_CONFIG_PENDING;
===== drivers/scsi/pcmcia/nsp_cs.c 1.19 vs edited =====
--- 1.19/drivers/scsi/pcmcia/nsp_cs.c	Wed Mar 26 11:49:35 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.c	Sat Apr 26 22:28:37 2003
@@ -88,9 +88,8 @@
 
 typedef struct scsi_info_t {
 	dev_link_t             link;
+	dev_node_t	       node;
 	struct Scsi_Host      *host;
-	int	               ndev;
-	dev_node_t             node[8];
 	int                    stop;
 } scsi_info_t;
 
@@ -1628,8 +1627,6 @@
 	memreq_t          map;
 	cistpl_cftable_entry_t dflt = { 0 };
 
-	Scsi_Device	 *dev;
-	dev_node_t	**tail, *node;
 	struct Scsi_Host *host;
 	nsp_hw_data      *data = &nsp_data;
 
@@ -1769,58 +1766,13 @@
 		goto cs_failed;
 	}
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
 	host = __nsp_detect(&nsp_driver_template);
-#else
-	scsi_register_module(MODULE_SCSI_HA, &nsp_driver_template);
-	for (host = scsi_hostlist; host != NULL; host = host->next) {
-		if (host->hostt == &nsp_driver_template)
-			break;
-#endif
-
 	if (!host)
 		goto cs_failed;
 
-	DEBUG(0, "GET_SCSI_INFO\n");
-	tail = &link->dev;
-	info->ndev = 0;
-
-	list_for_each_entry (dev, &host->my_devices, siblings) {
-		u_long arg[2], id;
-		kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
-		id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
-			((arg[0]>>8)&0xf00) + ((arg[0]>>12)&0xf000);
-		node = &info->node[info->ndev];
-		node->minor = 0;
-		switch (dev->type) {
-		case TYPE_TAPE:
-			node->major = SCSI_TAPE_MAJOR;
-			sprintf(node->dev_name, "st#%04lx", id);
-			break;
-		case TYPE_DISK:
-		case TYPE_MOD:
-			node->major = SCSI_DISK0_MAJOR;
-			sprintf(node->dev_name, "sd#%04lx", id);
-			break;
-		case TYPE_ROM:
-		case TYPE_WORM:
-			node->major = SCSI_CDROM_MAJOR;
-			sprintf(node->dev_name, "sr#%04lx", id);
-			break;
-		default:
-			node->major = SCSI_GENERIC_MAJOR;
-			sprintf(node->dev_name, "sg#%04lx", id);
-			break;
-		}
-		*tail = node; tail = &node->next;
-		info->ndev++;
-		info->host = dev->host;
-	}
-
-	*tail = NULL;
-	if (info->ndev == 0) {
-		printk(KERN_INFO "nsp_cs: no SCSI devices found\n");
-	}
+	sprintf(info->node.dev_name, "scsi%d", host->host_no);
+	link->dev = &info->node;
+	info->host = host;
 
 	/* Finally, report what we've done */
 	printk(KERN_INFO "nsp_cs: index 0x%02x: Vcc %d.%d",
@@ -1844,10 +1796,7 @@
 		       req.Base+req.Size-1);
 	printk("\n");
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 	scsi_add_host(host, NULL);
-#endif
-
 	link->state &= ~DEV_CONFIG_PENDING;
 	return;
 
===== drivers/scsi/pcmcia/qlogic_stub.c 1.13 vs edited =====
--- 1.13/drivers/scsi/pcmcia/qlogic_stub.c	Sun Mar 23 17:30:18 2003
+++ edited/drivers/scsi/pcmcia/qlogic_stub.c	Sat Apr 26 22:29:31 2003
@@ -85,10 +85,9 @@
 
 typedef struct scsi_info_t {
 	dev_link_t link;
+	dev_node_t node;
 	struct Scsi_Host *host;
 	unsigned short manf_id;
-	int ndev;
-	dev_node_t node[8];
 } scsi_info_t;
 
 static void qlogic_release(u_long arg);
@@ -215,8 +214,6 @@
 	cisparse_t parse;
 	int i, last_ret, last_fn;
 	unsigned short tuple_data[32];
-	Scsi_Device *dev;
-	dev_node_t **tail, *node;
 	struct Scsi_Host *host;
 
 	DEBUG(0, "qlogic_config(0x%p)\n", link);
@@ -273,50 +270,17 @@
 	else
 		qlogicfas_preset(link->io.BasePort1, link->irq.AssignedIRQ);
 
-	tail = &link->dev;
-	info->ndev = 0;
-
 	host = __qlogicfas_detect(&qlogicfas_driver_template);
 	if (!host) {
 		printk(KERN_INFO "qlogic_cs: no SCSI devices found\n");
 		goto out;
 	}
 
-	scsi_add_host(host, NULL);
-
-	list_for_each_entry(dev, &host->my_devices, siblings) {
-		u_long arg[2], id;
-		kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
-		id = (arg[0] & 0x0f) + ((arg[0] >> 4) & 0xf0) + ((arg[0] >> 8) & 0xf00) + ((arg[0] >> 12) & 0xf000);
-		node = &info->node[info->ndev];
-		node->minor = 0;
-		switch (dev->type) {
-		case TYPE_TAPE:
-			node->major = SCSI_TAPE_MAJOR;
-			sprintf(node->dev_name, "st#%04lx", id);
-			break;
-		case TYPE_DISK:
-		case TYPE_MOD:
-			node->major = SCSI_DISK0_MAJOR;
-			sprintf(node->dev_name, "sd#%04lx", id);
-			break;
-		case TYPE_ROM:
-		case TYPE_WORM:
-			node->major = SCSI_CDROM_MAJOR;
-			sprintf(node->dev_name, "sr#%04lx", id);
-			break;
-		default:
-			node->major = SCSI_GENERIC_MAJOR;
-			sprintf(node->dev_name, "sg#%04lx", id);
-			break;
-		}
-		*tail = node;
-		tail = &node->next;
-		info->ndev++;
-	}
-
-	*tail = NULL;
+	sprintf(info->node.dev_name, "scsi%d", host->host_no);
+	link->dev = &info->node;
 	info->host = host;
+
+	scsi_add_host(host, NULL);
 
 out:
 	link->state &= ~DEV_CONFIG_PENDING;
