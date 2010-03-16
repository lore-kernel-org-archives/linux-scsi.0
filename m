From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] scsi_transport_fc: Initialize sysfs attributes with
 sysfs_attr_init
Date: Tue, 16 Mar 2010 11:14:53 +0100
Message-ID: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:43959 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937666Ab0CPKOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2010 06:14:55 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o2GAEs9h013057
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 10:14:54 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2GAEsju856070
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 10:14:54 GMT
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2GAErDw014127
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 10:14:53 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

With the new lockdep tracking in sysfs, sysfs_attr_init has to be used
for initializing all non-static sysfs attributes. Otherwise, lockdep
will warn about the missing initialization with:

Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae350 not in .data!
Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae388 not in .data!
Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3c0 not in .data!
Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3f8 not in .data!

Add the calls to sysfs_attr_init for the attributes in struct
fc_internal.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_transport_fc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/scsi/scsi_transport_fc.c	2010-03-15 16:39:54.000000000 +0100
+++ b/drivers/scsi/scsi_transport_fc.c	2010-03-15 16:59:08.000000000 +0100
@@ -777,6 +777,7 @@ static FC_DEVICE_ATTR(rport, title, S_IR
 	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_rport_attrs[count].store = NULL;			\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
+	sysfs_attr_init(&i->rport_attrs[count]->attr);			\
 	if (i->f->show_rport_##field)					\
 		count++
 
@@ -785,6 +786,7 @@ static FC_DEVICE_ATTR(rport, title, S_IR
 	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_rport_attrs[count].store = NULL;			\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
+	sysfs_attr_init(&i->rport_attrs[count]->attr);			\
 	count++
 
 #define SETUP_RPORT_ATTRIBUTE_RW(field)					\
@@ -794,6 +796,7 @@ static FC_DEVICE_ATTR(rport, title, S_IR
 		i->private_rport_attrs[count].store = NULL;		\
 	}								\
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
+	sysfs_attr_init(&i->rport_attrs[count]->attr);			\
 	if (i->f->show_rport_##field)					\
 		count++
 
@@ -801,6 +804,7 @@ static FC_DEVICE_ATTR(rport, title, S_IR
 {									\
 	i->private_rport_attrs[count] = device_attr_rport_##field; \
 	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
+	sysfs_attr_init(&i->rport_attrs[count]->attr);			\
 	count++;							\
 }
 
@@ -994,6 +998,7 @@ static FC_DEVICE_ATTR(starget, field, S_
 	i->private_starget_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_starget_attrs[count].store = NULL;			\
 	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
+	sysfs_attr_init(&i->starget_attrs[count]->attr);		\
 	if (i->f->show_starget_##field)					\
 		count++
 
@@ -1004,6 +1009,7 @@ static FC_DEVICE_ATTR(starget, field, S_
 		i->private_starget_attrs[count].store = NULL;		\
 	}								\
 	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
+	sysfs_attr_init(&i->starget_attrs[count]->attr);		\
 	if (i->f->show_starget_##field)					\
 		count++
 
@@ -1157,6 +1163,7 @@ static FC_DEVICE_ATTR(vport, title, S_IR
 	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_vport_attrs[count].store = NULL;			\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	sysfs_attr_init(i->vport_attrs[count].attr);			\
 	if (i->f->get_##field)						\
 		count++
 	/* NOTE: Above MACRO differs: checks function not show bit */
@@ -1166,11 +1173,13 @@ static FC_DEVICE_ATTR(vport, title, S_IR
 	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_vport_attrs[count].store = NULL;			\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	sysfs_attr_init(&i->vport_attrs[count]->attr);			\
 	count++
 
 #define SETUP_VPORT_ATTRIBUTE_WR(field)					\
 	i->private_vport_attrs[count] = device_attr_vport_##field; \
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	sysfs_attr_init(&i->vport_attrs[count]->attr);			\
 	if (i->f->field)						\
 		count++
 	/* NOTE: Above MACRO differs: checks function */
@@ -1182,6 +1191,7 @@ static FC_DEVICE_ATTR(vport, title, S_IR
 		i->private_vport_attrs[count].store = NULL;		\
 	}								\
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	sysfs_attr_init(&i->vport_attrs[count]->attr);			\
 	count++
 	/* NOTE: Above MACRO differs: does not check show bit */
 
@@ -1189,6 +1199,7 @@ static FC_DEVICE_ATTR(vport, title, S_IR
 {									\
 	i->private_vport_attrs[count] = device_attr_vport_##field; \
 	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	sysfs_attr_init(&i->vport_attrs[count]->attr);			\
 	count++;							\
 }
 
@@ -1366,6 +1377,7 @@ static FC_DEVICE_ATTR(host, title, S_IRU
 	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_host_attrs[count].store = NULL;			\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	sysfs_attr_init(&i->host_attrs[count]->attr);			\
 	if (i->f->show_host_##field)					\
 		count++
 
@@ -1374,6 +1386,7 @@ static FC_DEVICE_ATTR(host, title, S_IRU
 	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_host_attrs[count].store = NULL;			\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	sysfs_attr_init(&i->host_attrs[count]->attr);			\
 	count++
 
 #define SETUP_HOST_ATTRIBUTE_RW(field)					\
@@ -1383,6 +1396,7 @@ static FC_DEVICE_ATTR(host, title, S_IRU
 		i->private_host_attrs[count].store = NULL;		\
 	}								\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	sysfs_attr_init(&i->host_attrs[count]->attr);			\
 	if (i->f->show_host_##field)					\
 		count++
 
@@ -1411,12 +1425,14 @@ static FC_DEVICE_ATTR(host, field, S_IRU
 	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_host_attrs[count].store = NULL;			\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	sysfs_attr_init(&i->host_attrs[count]->attr);			\
 	count++
 
 #define SETUP_PRIVATE_HOST_ATTRIBUTE_RW(field)			\
 {									\
 	i->private_host_attrs[count] = device_attr_host_##field;	\
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	sysfs_attr_init(&i->host_attrs[count]->attr);			\
 	count++;							\
 }
 
