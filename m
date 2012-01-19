From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/5] scsi_transport_iscsi: Added support to show port_state and port_speed in sysfs
Date: Thu, 19 Jan 2012 03:06:55 -0800
Message-ID: <1326971217-14323-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15995 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2ASLWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 06:22:44 -0500
In-Reply-To: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

sysfs patch to view port_state:
    /sys/class/iscsi_host/host*/port_state

sysfs patch to view port_speed:
    /sys/class/iscsi_host/host*/port_speed

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   63 +++++++++++++++++++++++++++++++++++
 include/scsi/iscsi_if.h             |   17 +++++++++
 include/scsi/scsi_transport_iscsi.h |    4 ++
 3 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index cfd4914..97832a2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2476,12 +2476,16 @@ iscsi_host_attr(netdev, ISCSI_HOST_PARAM_NETDEV_NAME);
 iscsi_host_attr(hwaddress, ISCSI_HOST_PARAM_HWADDRESS);
 iscsi_host_attr(ipaddress, ISCSI_HOST_PARAM_IPADDRESS);
 iscsi_host_attr(initiatorname, ISCSI_HOST_PARAM_INITIATOR_NAME);
+iscsi_host_attr(port_state, ISCSI_HOST_PARAM_PORT_STATE);
+iscsi_host_attr(port_speed, ISCSI_HOST_PARAM_PORT_SPEED);
 
 static struct attribute *iscsi_host_attrs[] = {
 	&dev_attr_host_netdev.attr,
 	&dev_attr_host_hwaddress.attr,
 	&dev_attr_host_ipaddress.attr,
 	&dev_attr_host_initiatorname.attr,
+	&dev_attr_host_port_state.attr,
+	&dev_attr_host_port_speed.attr,
 	NULL,
 };
 
@@ -2501,6 +2505,10 @@ static umode_t iscsi_host_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_HOST_PARAM_IPADDRESS;
 	else if (attr == &dev_attr_host_initiatorname.attr)
 		param = ISCSI_HOST_PARAM_INITIATOR_NAME;
+	else if (attr == &dev_attr_host_port_state.attr)
+		param = ISCSI_HOST_PARAM_PORT_STATE;
+	else if (attr == &dev_attr_host_port_speed.attr)
+		param = ISCSI_HOST_PARAM_PORT_SPEED;
 	else {
 		WARN_ONCE(1, "Invalid host attr");
 		return 0;
@@ -2514,6 +2522,61 @@ static struct attribute_group iscsi_host_group = {
 	.is_visible = iscsi_host_attr_is_visible,
 };
 
+/* convert iscsi_port_speed values to ascii string name */
+static const struct {
+	enum iscsi_port_speed	value;
+	char			*name;
+} iscsi_port_speed_names[] = {
+	{ISCSI_PORT_SPEED_UNKNOWN,	"Unknown" },
+	{ISCSI_PORT_SPEED_10MBPS,	"10 Mbps" },
+	{ISCSI_PORT_SPEED_100MBPS,	"100 Mbps" },
+	{ISCSI_PORT_SPEED_1GBPS,	"1 Gbps" },
+	{ISCSI_PORT_SPEED_10GBPS,	"10 Gbps" },
+};
+
+char *iscsi_get_port_speed_name(struct Scsi_Host *shost)
+{
+	int i;
+	char *speed = "Unknown!";
+	struct iscsi_cls_host *ihost = shost->shost_data;
+	uint32_t port_speed = ihost->port_speed;
+
+	for (i = 0; i < ARRAY_SIZE(iscsi_port_speed_names); i++) {
+		if (iscsi_port_speed_names[i].value & port_speed) {
+			speed = iscsi_port_speed_names[i].name;
+			break;
+		}
+	}
+	return speed;
+}
+EXPORT_SYMBOL_GPL(iscsi_get_port_speed_name);
+
+/* convert iscsi_port_state values to ascii string name */
+static const struct {
+	enum iscsi_port_state	value;
+	char			*name;
+} iscsi_port_state_names[] = {
+	{ISCSI_PORT_STATE_DOWN,		"LINK DOWN" },
+	{ISCSI_PORT_STATE_UP,		"LINK UP" },
+};
+
+char *iscsi_get_port_state_name(struct Scsi_Host *shost)
+{
+	int i;
+	char *state = "Unknown!";
+	struct iscsi_cls_host *ihost = shost->shost_data;
+	uint32_t port_state = ihost->port_state;
+
+	for (i = 0; i < ARRAY_SIZE(iscsi_port_state_names); i++) {
+		if (iscsi_port_state_names[i].value & port_state) {
+			state = iscsi_port_state_names[i].name;
+			break;
+		}
+	}
+	return state;
+}
+EXPORT_SYMBOL_GPL(iscsi_get_port_state_name);
+
 static int iscsi_session_match(struct attribute_container *cont,
 			   struct device *dev)
 {
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 2703e3b..e49b7c8 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -416,9 +416,26 @@ enum iscsi_host_param {
 	ISCSI_HOST_PARAM_INITIATOR_NAME,
 	ISCSI_HOST_PARAM_NETDEV_NAME,
 	ISCSI_HOST_PARAM_IPADDRESS,
+	ISCSI_HOST_PARAM_PORT_STATE,
+	ISCSI_HOST_PARAM_PORT_SPEED,
 	ISCSI_HOST_PARAM_MAX,
 };
 
+/* iSCSI port Speed */
+enum iscsi_port_speed {
+	ISCSI_PORT_SPEED_UNKNOWN	= 0x1,
+	ISCSI_PORT_SPEED_10MBPS		= 0x2,
+	ISCSI_PORT_SPEED_100MBPS	= 0x4,
+	ISCSI_PORT_SPEED_1GBPS		= 0x8,
+	ISCSI_PORT_SPEED_10GBPS		= 0x10,
+};
+
+/* iSCSI port state */
+enum iscsi_port_state {
+	ISCSI_PORT_STATE_DOWN		= 0x1,
+	ISCSI_PORT_STATE_UP		= 0x2,
+};
+
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 2c3a46d..fa7ca4e 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -238,6 +238,8 @@ struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
 	struct request_queue *bsg_q;
+	uint32_t port_speed;
+	uint32_t port_state;
 };
 
 #define iscsi_job_to_shost(_job) \
@@ -307,5 +309,7 @@ extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      uint32_t iface_num, int dd_size);
 extern void iscsi_destroy_iface(struct iscsi_iface *iface);
 extern struct iscsi_iface *iscsi_lookup_iface(int handle);
+extern char *iscsi_get_port_speed_name(struct Scsi_Host *shost);
+extern char *iscsi_get_port_state_name(struct Scsi_Host *shost);
 
 #endif
-- 
1.7.8.rc2.3.g0911


