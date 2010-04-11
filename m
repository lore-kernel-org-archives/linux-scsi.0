From: David Miller <davem@davemloft.net>
Subject: [PATCH 2/2] scsi: Add lockdep annotations to FC sysfs attributes.
Date: Sat, 10 Apr 2010 21:40:24 -0700 (PDT)
Message-ID: <20100410.214024.228295222.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52761
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab0DKEkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Apr 2010 00:40:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ebiederm@xmission.com
Cc: gregkh@suse.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


They are allocated dynamically, and thus need sysfs_attr_init()
treatment.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1d5b721..5f10ed2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -775,6 +775,7 @@ static FC_DEVICE_ATTR(rport, title, S_IRUGO,			\
 #define SETUP_RPORT_ATTRIBUTE_RD(field)					\
 	i->private_rport_attrs[count] = device_attr_rport_##field; \
 	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_rport_attrs[count].attr);		\
 	i->private_rport_attrs[count].store = NULL;			\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
 	if (i->f->show_rport_##field)					\
@@ -783,6 +784,7 @@ static FC_DEVICE_ATTR(rport, title, S_IRUGO,			\
 #define SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(field)				\
 	i->private_rport_attrs[count] = device_attr_rport_##field; \
 	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_rport_attrs[count].attr);		\
 	i->private_rport_attrs[count].store = NULL;			\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
 	count++
@@ -793,13 +795,15 @@ static FC_DEVICE_ATTR(rport, title, S_IRUGO,			\
 		i->private_rport_attrs[count].attr.mode = S_IRUGO;	\
 		i->private_rport_attrs[count].store = NULL;		\
 	}								\
+	sysfs_attr_init(&i->private_rport_attrs[count].attr);		\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
 	if (i->f->show_rport_##field)					\
 		count++
 
 #define SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(field)				\
 {									\
-	i->private_rport_attrs[count] = device_attr_rport_##field; \
+	i->private_rport_attrs[count] = device_attr_rport_##field; 	\
+	sysfs_attr_init(&i->private_rport_attrs[count].attr);		\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
 	count++;							\
 }
@@ -992,6 +996,7 @@ static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
 #define SETUP_STARGET_ATTRIBUTE_RD(field)				\
 	i->private_starget_attrs[count] = device_attr_starget_##field; \
 	i->private_starget_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_starget_attrs[count].attr);		\
 	i->private_starget_attrs[count].store = NULL;			\
 	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
 	if (i->f->show_starget_##field)					\
@@ -1003,6 +1008,7 @@ static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
 		i->private_starget_attrs[count].attr.mode = S_IRUGO;	\
 		i->private_starget_attrs[count].store = NULL;		\
 	}								\
+	sysfs_attr_init(&i->private_starget_attrs[count].attr);		\
 	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
 	if (i->f->show_starget_##field)					\
 		count++
@@ -1155,6 +1161,7 @@ static FC_DEVICE_ATTR(vport, title, S_IRUGO,			\
 #define SETUP_VPORT_ATTRIBUTE_RD(field)					\
 	i->private_vport_attrs[count] = device_attr_vport_##field; \
 	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_vport_attrs[count].attr);		\
 	i->private_vport_attrs[count].store = NULL;			\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
 	if (i->f->get_##field)						\
@@ -1164,12 +1171,14 @@ static FC_DEVICE_ATTR(vport, title, S_IRUGO,			\
 #define SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(field)				\
 	i->private_vport_attrs[count] = device_attr_vport_##field; \
 	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_vport_attrs[count].attr);		\
 	i->private_vport_attrs[count].store = NULL;			\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
 	count++
 
 #define SETUP_VPORT_ATTRIBUTE_WR(field)					\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
+	i->private_vport_attrs[count] = device_attr_vport_##field; 	\
+	sysfs_attr_init(&i->private_vport_attrs[count].attr);		\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
 	if (i->f->field)						\
 		count++
@@ -1181,13 +1190,15 @@ static FC_DEVICE_ATTR(vport, title, S_IRUGO,			\
 		i->private_vport_attrs[count].attr.mode = S_IRUGO;	\
 		i->private_vport_attrs[count].store = NULL;		\
 	}								\
+	sysfs_attr_init(&i->private_vport_attrs[count].attr);		\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
 	count++
 	/* NOTE: Above MACRO differs: does not check show bit */
 
 #define SETUP_PRIVATE_VPORT_ATTRIBUTE_RW(field)				\
 {									\
-	i->private_vport_attrs[count] = device_attr_vport_##field; \
+	i->private_vport_attrs[count] = device_attr_vport_##field; 	\
+	sysfs_attr_init(&i->private_vport_attrs[count].attr);		\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
 	count++;							\
 }
@@ -1373,6 +1384,7 @@ static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fc_host_##title, NULL)
 #define SETUP_HOST_ATTRIBUTE_RD(field)					\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
 	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_host_attrs[count].attr);		\
 	i->private_host_attrs[count].store = NULL;			\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
 	if (i->f->show_host_##field)					\
@@ -1381,6 +1393,7 @@ static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fc_host_##title, NULL)
 #define SETUP_HOST_ATTRIBUTE_RD_NS(field)				\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
 	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_host_attrs[count].attr);		\
 	i->private_host_attrs[count].store = NULL;			\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
 	count++
@@ -1391,6 +1404,7 @@ static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fc_host_##title, NULL)
 		i->private_host_attrs[count].attr.mode = S_IRUGO;	\
 		i->private_host_attrs[count].store = NULL;		\
 	}								\
+	sysfs_attr_init(&i->private_host_attrs[count].attr);		\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
 	if (i->f->show_host_##field)					\
 		count++
@@ -1418,6 +1432,7 @@ static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
 #define SETUP_PRIVATE_HOST_ATTRIBUTE_RD(field)			\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
 	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
+	sysfs_attr_init(&i->private_host_attrs[count].attr);		\
 	i->private_host_attrs[count].store = NULL;			\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
 	count++
@@ -1425,6 +1440,7 @@ static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
 #define SETUP_PRIVATE_HOST_ATTRIBUTE_RW(field)			\
 {									\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
+	sysfs_attr_init(&i->private_host_attrs[count].attr);		\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
 	count++;							\
 }
