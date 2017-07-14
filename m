From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/4] scsi: scsi_transport_iscsi: constify attribute_group structures.
Date: Fri, 14 Jul 2017 13:53:27 +0530
Message-ID: <1500020610-15973-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  40380	  10422	     44	  50846	   c69e	scsi/scsi_transport_iscsi.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  40764	  10070	     44	  50878	   c6be	scsi/scsi_transport_iscsi.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a424eae..55393b3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -139,7 +139,7 @@ static void iscsi_transport_release(struct device *dev)
 	NULL,
 };
 
-static struct attribute_group iscsi_transport_group = {
+static const struct attribute_group iscsi_transport_group = {
 	.attrs = iscsi_transport_attrs,
 };
 
@@ -177,7 +177,7 @@ static void iscsi_endpoint_release(struct device *dev)
 	NULL,
 };
 
-static struct attribute_group iscsi_endpoint_group = {
+static const struct attribute_group iscsi_endpoint_group = {
 	.attrs = iscsi_endpoint_attrs,
 };
 
@@ -680,7 +680,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	NULL,
 };
 
-static struct attribute_group iscsi_iface_group = {
+static const struct attribute_group iscsi_iface_group = {
 	.attrs = iscsi_iface_attrs,
 	.is_visible = iscsi_iface_attr_is_visible,
 };
@@ -3922,7 +3922,7 @@ static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
 	return t->attr_is_visible(ISCSI_PARAM, param);
 }
 
-static struct attribute_group iscsi_conn_group = {
+static const struct attribute_group iscsi_conn_group = {
 	.attrs = iscsi_conn_attrs,
 	.is_visible = iscsi_conn_attr_is_visible,
 };
@@ -4217,7 +4217,7 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 	return t->attr_is_visible(ISCSI_PARAM, param);
 }
 
-static struct attribute_group iscsi_session_group = {
+static const struct attribute_group iscsi_session_group = {
 	.attrs = iscsi_session_attrs,
 	.is_visible = iscsi_session_attr_is_visible,
 };
@@ -4285,7 +4285,7 @@ static umode_t iscsi_host_attr_is_visible(struct kobject *kobj,
 	return priv->iscsi_transport->attr_is_visible(ISCSI_HOST_PARAM, param);
 }
 
-static struct attribute_group iscsi_host_group = {
+static const struct attribute_group iscsi_host_group = {
 	.attrs = iscsi_host_attrs,
 	.is_visible = iscsi_host_attr_is_visible,
 };
-- 
1.9.1
