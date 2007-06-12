From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2a/3] Expose Power Management Policy option to users
Date: Tue, 12 Jun 2007 10:46:31 -0700
Message-ID: <20070612104631.44dab4a3.kristen.c.accardi@intel.com>
References: <20070611184146.448266229@intel.com>
	<20070611114820.5290a903.kristen.c.accardi@intel.com>
	<466DA9DD.8080004@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <466DA9DD.8080004@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Expose Power Management Policy option to users

This patch will modify the scsi subsystem to allow
users to set a power management policy for the link.

The scsi subsystem will create a new sysfs file for each
host in /sys/class/scsi_host called "link_power_management_policy".
This file can have 3 possible values:

Value		Meaning
-------------------------------------------------------------------
min_power	User wishes the link to conserve power as much as
		possible, even at the cost of some performance

max_performance User wants priority to be on performance, not power
		savings

medium_power	User wants power savings, with less performance cost
		than min_power (but less power savings as well).


Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/scsi/hosts.c
===================================================================
--- 2.6-git.orig/drivers/scsi/hosts.c
+++ 2.6-git/drivers/scsi/hosts.c
@@ -54,6 +54,25 @@ static struct class shost_class = {
 };
 
 /**
+ *	scsi_host_set_link_pm - Change the link power management policy
+ *	@shost:	scsi host to change the policy of.
+ *	@policy:	policy to change to.
+ *
+ *	Returns zero if successful or an error if the requested
+ *	transition is illegal.
+ **/
+int scsi_host_set_link_pm(struct Scsi_Host *shost,
+		enum scsi_host_link_pm policy)
+{
+	struct scsi_host_template *sht = shost->hostt;
+	if (sht->set_link_pm_policy)
+		sht->set_link_pm_policy(shost, policy);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_host_set_link_pm);
+
+/**
  *	scsi_host_set_state - Take the given host through the host
  *		state model.
  *	@shost:	scsi host to change the state of.
Index: 2.6-git/drivers/scsi/scsi_sysfs.c
===================================================================
--- 2.6-git.orig/drivers/scsi/scsi_sysfs.c
+++ 2.6-git/drivers/scsi/scsi_sysfs.c
@@ -189,6 +189,74 @@ show_shost_state(struct class_device *cl
 
 static CLASS_DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
+static const struct {
+	enum scsi_host_link_pm	value;
+	char			*name;
+} shost_link_pm_policy[] = {
+	{ SHOST_NOT_AVAILABLE, "max_performance" },
+	{ SHOST_MIN_POWER, "min_power" },
+	{ SHOST_MAX_PERFORMANCE, "max_performance" },
+	{ SHOST_MEDIUM_POWER, "medium_power" },
+};
+
+const char *scsi_host_link_pm_policy(enum scsi_host_link_pm policy)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(shost_link_pm_policy); i++) {
+		if (shost_link_pm_policy[i].value == policy) {
+			name = shost_link_pm_policy[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+static ssize_t store_link_pm_policy(struct class_device *class_dev,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	enum scsi_host_link_pm policy = 0;
+	int i;
+
+	/*
+ 	 * we are skipping array location 0 on purpose - this
+ 	 * is because a value of SHOST_NOT_AVAILABLE is displayed
+ 	 * to the user as max_performance, but when the user
+ 	 * writes "max_performance", they actually want the
+ 	 * value to match SHOST_MAX_PERFORMANCE.
+ 	 */
+	for (i = 1; i < ARRAY_SIZE(shost_link_pm_policy); i++) {
+		const int len = strlen(shost_link_pm_policy[i].name);
+		if (strncmp(shost_link_pm_policy[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			policy = shost_link_pm_policy[i].value;
+			break;
+		}
+	}
+	if (!policy)
+		return -EINVAL;
+
+	if (scsi_host_set_link_pm(shost, policy))
+		return -EINVAL;
+	return count;
+}
+static ssize_t
+show_link_pm_policy(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	const char *policy =
+		scsi_host_link_pm_policy(shost->shost_link_pm_policy);
+
+	if (!policy)
+		return -EINVAL;
+
+	return snprintf(buf, 23, "%s\n", policy);
+}
+static CLASS_DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
+		show_link_pm_policy, store_link_pm_policy);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -207,6 +275,7 @@ static struct class_device_attribute *sc
 	&class_device_attr_proc_name,
 	&class_device_attr_scan,
 	&class_device_attr_state,
+	&class_device_attr_link_power_management_policy,
 	NULL
 };
 
Index: 2.6-git/include/scsi/scsi_host.h
===================================================================
--- 2.6-git.orig/include/scsi/scsi_host.h
+++ 2.6-git/include/scsi/scsi_host.h
@@ -42,6 +42,16 @@ enum scsi_eh_timer_return {
 	EH_RESET_TIMER,
 };
 
+/*
+ * shost pm policy: If you alter this, you also need to alter scsi_sysfs.c
+ * (for the ascii descriptions)
+ */
+enum scsi_host_link_pm {
+	SHOST_NOT_AVAILABLE,
+	SHOST_MIN_POWER,
+	SHOST_MAX_PERFORMANCE,
+	SHOST_MEDIUM_POWER,
+};
 
 struct scsi_host_template {
 	struct module *module;
@@ -345,6 +355,12 @@ struct scsi_host_template {
 	int (*suspend)(struct scsi_device *, pm_message_t state);
 
 	/*
+ 	 * link power management support
+ 	 */
+	int (*set_link_pm_policy)(struct Scsi_Host *, enum scsi_host_link_pm);
+	enum scsi_host_link_pm default_link_pm_policy;
+
+	/*
 	 * Name of proc directory
 	 */
 	char *proc_name;
@@ -642,6 +658,7 @@ struct Scsi_Host {
 	
 
 	enum scsi_host_state shost_state;
+	enum scsi_host_link_pm shost_link_pm_policy;
 
 	/* ldm bits */
 	struct device		shost_gendev;
@@ -749,4 +766,5 @@ extern struct Scsi_Host *scsi_register(s
 extern void scsi_unregister(struct Scsi_Host *);
 extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
 
+extern int scsi_host_set_link_pm(struct Scsi_Host *, enum scsi_host_link_pm);
 #endif /* _SCSI_SCSI_HOST_H */
Index: 2.6-git/Documentation/scsi/link_power_management_policy.txt
===================================================================
--- /dev/null
+++ 2.6-git/Documentation/scsi/link_power_management_policy.txt
@@ -0,0 +1,19 @@
+This parameter allows the user to set the link (interface) power management.
+There are 3 possible options:
+
+Value			Effect
+----------------------------------------------------------------------------
+min_power		Tell the controller to try to make the link use the
+			least possible power when possible.  This may
+			sacrifice some performance due to increased latency
+			when coming out of lower power states.
+
+max_performance		Generally, this means no power management.  Tell
+			the controller to have performance be a priority
+			over power management.
+
+medium_power		Tell the controller to enter a lower power state
+			when possible, but do not enter the lowest power
+			state, thus improving latency over min_power setting.
+
+
