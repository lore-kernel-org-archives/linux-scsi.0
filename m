From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc transport: Add support for events
Date: Wed, 22 Feb 2006 11:09:24 -0500
Message-ID: <43FC8CB4.2000507@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:10953 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932322AbWBVQJ1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 11:09:27 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MG9Prf025683
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 08:09:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


The following patch adds support for hbaapi events within the FC transport.
It adds the following attributes to the fc_host:
   max_events  : sizes the internal array for the number of events that are
                 buffered in the transport. This value can be tuned by a
                 module parameter.
   event_cnt   : number of events pending in the buffer
   event       : reads an event from the buffer

It adds the following routine for LLDD's to post events:
    void fc_host_event_post(struct Scsi_Host *shost,
		enum fc_host_event_code event_code, u32 event_data);

Not all hbaapi events are contained within the transport. Many events
correspond to elements outside the fc_host, and can be serviced by normal
hot-plug events, either on the fc_host, or rport. I believe I've included
those events that could be posted. I've also punted on anything that has more
than 1 32-bit word of data - which should only affect RLIR payloads, and
vendor-unique payloads. We will address these items once we figure out how
to deal with large payloads in the transport.

In conjunction with the event infrastructure, the module uses hot plug events
to notify user entities about changes. For the fc_host, the only event posted
is a KOBJ_CHANGE event. For the rport, ONLINE/OFFLINE is posted whenever the
rport goes through a block, then unblock. To get to the class_device for the
rport, a new attribute_container function is added locate the class_device for
the device.

This implementation expects the user-space hbaapi provider to deal with
multiple user-space readers.

I've coordinated with Andrew Vasquez, who has sent his approval.

The lpfc driver will be posted shortly to utilize this infrastructure.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/base/attribute_container.c 
b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c	2006-02-12 16:34:08.000000000 -0500
+++ b/drivers/base/attribute_container.c	2006-02-12 17:16:12.000000000 -0500
@@ -239,6 +239,48 @@ attribute_container_remove_device(struct
  EXPORT_SYMBOL_GPL(attribute_container_remove_device);

  /**
+ * attribute_container_dev_to_classdev - see if any container is interested
+ *       in dev
+ *
+ * @dev: device match on
+ * @fn:	 function to trigger addition of class device.
+ *
+ * This function searches the attribute containers to find the indicated
+ * device, and returns the classdevice associated with it.
+ */
+struct class_device *
+attribute_container_dev_to_classdev(struct device *dev)
+{
+	struct attribute_container *cont;
+	struct class_device *cdev = NULL;
+
+	down(&attribute_container_mutex);
+	list_for_each_entry(cont, &attribute_container_list, node) {
+		struct internal_container *ic;
+		struct klist_iter iter;
+
+		if (!cont->match(cont, dev))
+			continue;
+
+		if (attribute_container_no_classdevs(cont))
+			continue;
+
+		klist_for_each_entry(ic, &cont->containers, node, &iter) {
+			if (dev == ic->classdev.dev) {
+				cdev = &ic->classdev;
+				break;
+			}
+		}
+		if (cdev)
+			break;
+	}
+	up(&attribute_container_mutex);
+	
+	return cdev;
+}
+EXPORT_SYMBOL_GPL(attribute_container_dev_to_classdev);
+
+/**
   * attribute_container_device_trigger - execute a trigger for each matching 
classdev
   *
   * @dev:  The generic device to run the trigger for
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-02-06 12:00:11.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2006-02-22 10:53:34.000000000 -0500
@@ -34,6 +34,41 @@
  #include "scsi_priv.h"

  /*
+ * Module Parameters
+ */
+
+/*
+ * dev_loss_tmo: the default number of seconds that the FC transport
+ *   should insulate the loss of a remote port.
+ *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
+ */
+static unsigned int fc_modp_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
+
+module_param_named(dev_loss_tmo, fc_modp_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(dev_loss_tmo,
+		 "Maximum number of seconds that the FC transport should"
+		 " insulate the loss of a remote port. Once this value is"
+		 " exceeded, the scsi target is removed. Value should be"
+		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
+
+/*
+ * host_max_events: the default number of host events that the FC transport
+ *   will buffer internally.
+ *   The minimum will be capped by the value of FC_HOST_MIN_EVENTLIST_SZ.
+ *   The maximum will be capped by the value of FC_HOST_MAX_EVENTLIST_SZ.
+ */
+static unsigned int fc_modp_host_max_events = FC_HOST_MIN_EVENTLIST_SZ;
+
+module_param_named(host_max_events, fc_modp_host_max_events, int,
+			S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(host_max_events,
+		 "Maximum number of FC Host events that will be buffered"
+		 " internally. If this maximum is exceeded, new events"
+		 " will over-write the oldest events. Value should be"
+		 " between FC_HOST_MIN_EVENTLIST_SZ (128) and"
+		 " FC_HOST_MAX_EVENTLIST_SZ (2048).");
+
+/*
   * Redefine so that we can have same named attributes in the
   * sdev/starget/host objects.
   */
@@ -128,6 +163,28 @@ fc_enum_name_match(tgtid_bind_type, fc_t
  		fc_tgtid_binding_type_names)
  #define FC_BINDTYPE_MAX_NAMELEN	30

+/* Convert fc_host_event_code values to ascii string name */
+static const struct {
+	enum fc_host_event_code		value;
+	char				*name;
+} fc_host_event_code_names[] = {
+	{ FCH_EVT_LIP,			"lip" },
+	{ FCH_EVT_LINKUP,		"link_up" },
+	{ FCH_EVT_LINKDOWN,		"link_down" },
+	{ FCH_EVT_LIPRESET,		"lip_reset" },
+	{ FCH_EVT_RSCN,			"rscn" },
+	{ FCH_EVT_ADAPTER_CHANGE,	"adapter_chg" },
+	{ FCH_EVT_PORT_UNKNOWN,		"port_unknown" },
+	{ FCH_EVT_PORT_ONLINE,		"port_online" },
+	{ FCH_EVT_PORT_OFFLINE,		"port_offline" },
+	{ FCH_EVT_PORT_FABRIC,		"port_fabric" },
+	{ FCH_EVT_LINK_UNKNOWN,		"link_unknown" },
+	{ FCH_EVT_VENDOR_UNIQUE,	"vendor_unique" },
+};
+fc_enum_name_search(host_event_code, fc_host_event_code,
+		fc_host_event_code_names)
+#define FC_HOST_EVENT_CODE_MAX_NAMELEN	30
+

  #define fc_bitfield_name_search(title, table)			\
  static ssize_t							\
@@ -223,7 +280,7 @@ static void fc_rport_terminate(struct fc
   */
  #define FC_STARGET_NUM_ATTRS 	3
  #define FC_RPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	16
+#define FC_HOST_NUM_ATTRS	19

  struct fc_internal {
  	struct scsi_transport_template t;
@@ -315,6 +372,8 @@ static int fc_host_setup(struct transpor
  	fc_host_fabric_name(shost) = -1;

  	fc_host_tgtid_bind_type(shost) = FC_TGTID_BIND_BY_WWPN;
+	fc_host_event_cnt(shost) = 0;
+	fc_host_max_events(shost) = fc_modp_host_max_events;

  	INIT_LIST_HEAD(&fc_host_rports(shost));
  	INIT_LIST_HEAD(&fc_host_rport_bindings(shost));
@@ -323,6 +382,19 @@ static int fc_host_setup(struct transpor

  	fc_host_flags(shost) = 0;
  	INIT_WORK(&fc_host_rport_del_work(shost), fc_shost_remove_rports, shost);
+
+	fc_host_event_seq(shost) = 0;
+	fc_host_event_get(shost) = 0;
+	fc_host_event_put(shost) = 0;
+	fc_host_eventlist(shost) = kzalloc((fc_host_max_events(shost) *
+						sizeof(struct fc_host_event)),
+						GFP_KERNEL);
+	if (fc_host_eventlist(shost) == NULL) {
+		printk(KERN_ERR "%s: eventlist allocation failure\n",
+			__FUNCTION__);
+		return 1; /* fail */
+	}
+
  	return 0;
  }

@@ -342,24 +414,6 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
  			       NULL,
  			       NULL);

-/*
- * Module Parameters
- */
-
-/*
- * dev_loss_tmo: the default number of seconds that the FC transport
- *   should insulate the loss of a remote port.
- *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
- */
-static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
-
-module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(dev_loss_tmo,
-		 "Maximum number of seconds that the FC transport should"
-		 " insulate the loss of a remote port. Once this value is"
-		 " exceeded, the scsi target is removed. Value should be"
-		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
-

  static __init int fc_transport_init(void)
  {
@@ -369,7 +423,33 @@ static __init int fc_transport_init(void
  	error = transport_class_register(&fc_rport_class);
  	if (error)
  		return error;
-	return transport_class_register(&fc_transport_class);
+	error = transport_class_register(&fc_transport_class);
+	if (error)
+		return error;
+
+	/* fix any module parameters */
+
+	if ((fc_modp_dev_loss_tmo < 1) ||
+	    (fc_modp_dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)) {
+		printk(KERN_WARNING "%s: dev_loss_tmo out of range, setting "
+				 "to maximum (%d)\n", __FUNCTION__,
+				 SCSI_DEVICE_BLOCK_MAX_TIMEOUT);
+		fc_modp_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
+	}
+
+	if (fc_modp_host_max_events < FC_HOST_MIN_EVENTLIST_SZ) {
+		printk(KERN_WARNING "%s: host_max_events too small, setting "
+				 "to minimum (%d)\n", __FUNCTION__,
+				 FC_HOST_MIN_EVENTLIST_SZ);
+		fc_modp_host_max_events = FC_HOST_MIN_EVENTLIST_SZ;
+	} else if (fc_modp_host_max_events > FC_HOST_MAX_EVENTLIST_SZ) {
+		printk(KERN_WARNING "%s: host_max_events too large, setting "
+				 "to maximum (%d)\n", __FUNCTION__,
+				 FC_HOST_MAX_EVENTLIST_SZ);
+		fc_modp_host_max_events = FC_HOST_MAX_EVENTLIST_SZ;
+	}
+
+	return 0;
  }

  static void __exit fc_transport_exit(void)
@@ -914,6 +994,130 @@ static FC_CLASS_DEVICE_ATTR(host, issue_
  			store_fc_private_host_issue_lip);

  /*
+ * fc_host_event_cnt attribute
+ */
+fc_private_host_rd_attr(event_cnt, "%d\n", 20);
+
+/*
+ * fc_host_max_events attribute
+ */
+fc_private_host_show_function(max_events, "%d\n", 20, );
+
+static ssize_t
+store_fc_host_max_events(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct fc_host_event *newlist, *oldlist;
+	unsigned long flags;
+	int get, put, max, cnt, n_put = 0;
+	int val;
+
+	val = simple_strtoul(buf, NULL, 0);
+
+	if ((val < FC_HOST_MIN_EVENTLIST_SZ) ||
+	    (val > FC_HOST_MAX_EVENTLIST_SZ))
+		return -EINVAL;
+
+	newlist= kzalloc((val * sizeof(struct fc_host_event)), GFP_KERNEL);
+	if (newlist == NULL)
+		return -ENOMEM;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	oldlist = fc_host_eventlist(shost);
+	get = fc_host_event_get(shost);
+	put = fc_host_event_put(shost);
+	cnt = fc_host_event_cnt(shost);
+	max = fc_host_max_events(shost);
+
+	/* if we're not empty, copy events */
+	if (cnt) {
+
+		/*
+		 * if buffer list is smaller, and we have more events than
+		 * will fit in the new buffer list, truncate the existing
+		 * list before moving it.
+		 */
+		if ((val < max) && (cnt > (val - 1))) {
+			cnt = (val - 1);
+			if ((put > get) || (put >= cnt))
+				get = (put - cnt);
+			else
+				get = (max - (cnt - put));
+		}
+
+		/* copy old events to new event array */
+		if (put > get)
+			memcpy(&newlist[0], &oldlist[get],
+				(cnt * sizeof(struct fc_host_event)));
+		else {
+			memcpy(&newlist[0], &oldlist[get],
+				((max - get) * sizeof(struct fc_host_event)));
+			n_put = max - get;
+			memcpy(&newlist[n_put], &oldlist[0],
+				((cnt - n_put) * sizeof(struct fc_host_event)));
+		}
+		n_put = cnt;
+	}
+
+	fc_host_eventlist(shost) = newlist;
+	fc_host_max_events(shost) = val;
+	fc_host_event_get(shost) = 0;
+	fc_host_event_put(shost) = n_put;
+	fc_host_event_cnt(shost) = cnt;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	kfree(oldlist);
+
+	return count;
+}
+
+static FC_CLASS_DEVICE_ATTR(host, max_events, S_IRUGO | S_IWUSR,
+			show_fc_host_max_events, store_fc_host_max_events);
+
+/*
+ * fc_host_event attribute
+ */
+static const char *unknown = "<unknown>";
+
+static ssize_t
+show_fc_private_host_event(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	const char *code;
+	struct fc_host_event event;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (!fc_host_event_cnt(shost)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return -ENXIO;
+	}
+
+	event = fc_host_eventlist(shost)[fc_host_event_get(shost)];
+
+	if ((++fc_host_event_get(shost)) == fc_host_max_events(shost))
+		fc_host_event_get(shost) = 0;
+	fc_host_event_cnt(shost)--;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	code = get_fc_host_event_code_name(event.event_code);
+	if (!code)
+		code = unknown;
+
+	return snprintf(buf, 32 + FC_HOST_EVENT_CODE_MAX_NAMELEN,
+		"%d:%s:0x%08x\n", event.seq_num, code, event.event_data);
+}
+
+
+static FC_CLASS_DEVICE_ATTR(host, event, S_IRUGO,
+			show_fc_private_host_event, NULL);
+
+/*
   * Host Statistics Management
   */

@@ -1186,6 +1390,9 @@ fc_attach_transport(struct fc_function_t
  	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
  	if (ft->issue_fc_host_lip)
  		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
+	SETUP_PRIVATE_HOST_ATTRIBUTE_RD(event_cnt);
+	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(max_events);
+	SETUP_PRIVATE_HOST_ATTRIBUTE_RD(event);

  	BUG_ON(count > FC_HOST_NUM_ATTRS);

@@ -1227,6 +1434,57 @@ EXPORT_SYMBOL(fc_release_transport);


  /**
+ * fc_host_event_post - called to post an even on an fc_host.
+ *
+ * @shost:	host the event occurred on
+ * @event:	event being posted
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ *
+ *      We always reserve one element in the event list so that the
+ *      ring logic is easier (e.g. empty is get=put, full is put+1=get)
+ **/
+void
+fc_host_event_post(struct Scsi_Host *shost,
+		enum fc_host_event_code event_code, u32 event_data)
+{
+	struct fc_host_event *evt;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (!fc_host_eventlist(shost)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return;
+	}
+
+	/* if we're full - drop the oldest entry */
+	if (fc_host_event_cnt(shost) == (fc_host_max_events(shost) - 1)) {
+		if ((++fc_host_event_get(shost)) == fc_host_max_events(shost))
+			fc_host_event_get(shost) = 0;
+		fc_host_event_cnt(shost)--;
+	}
+
+	evt = &fc_host_eventlist(shost)[fc_host_event_put(shost)];
+	
+	evt->seq_num = fc_host_event_seq(shost)++;
+	evt->event_code = event_code;
+	evt->event_data = event_data;
+
+	if ((++fc_host_event_put(shost)) == fc_host_max_events(shost))
+		fc_host_event_put(shost) = 0;
+	fc_host_event_cnt(shost)++;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	kobject_uevent(&shost->shost_classdev.kobj, KOBJ_CHANGE);
+
+	return;
+}
+EXPORT_SYMBOL(fc_host_event_post);
+
+/**
   * fc_remove_host - called to terminate any fc_transport-related elements
   *                  for a scsi host.
   * @rport:	remote port to be unblocked.
@@ -1254,6 +1512,8 @@ fc_remove_host(struct Scsi_Host *shost)
  	list_for_each_entry_safe(rport, next_rport,
  			&fc_host_rport_bindings(shost), peers)
  		fc_rport_terminate(rport);
+
+	kfree(fc_host_eventlist(shost));
  }
  EXPORT_SYMBOL(fc_remove_host);

@@ -1311,7 +1571,7 @@ fc_rport_create(struct Scsi_Host *shost,

  	rport->maxframe_size = -1;
  	rport->supported_classes = FC_COS_UNSPECIFIED;
-	rport->dev_loss_tmo = fc_dev_loss_tmo;
+	rport->dev_loss_tmo = fc_modp_dev_loss_tmo;
  	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
  	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
  	rport->port_id = ids->port_id;
@@ -1489,6 +1749,8 @@ fc_remote_port_add(struct Scsi_Host *sho
  				/* initiate a scan of the target */
  				scsi_queue_work(shost, &rport->scan_work);

+				kobject_uevent(&rport_to_classdev(rport)->kobj,
+						KOBJ_ONLINE);
  				return rport;
  			}
  		}
@@ -1548,6 +1810,8 @@ fc_remote_port_add(struct Scsi_Host *sho
  				/* initiate a scan of the target */
  				scsi_queue_work(shost, &rport->scan_work);

+			kobject_uevent(&rport_to_classdev(rport)->kobj,
+					KOBJ_ONLINE);
  			return rport;
  		}
  	}
@@ -1653,6 +1917,8 @@ fc_remote_port_delete(struct fc_rport  *
  	schedule_delayed_work(&rport->dev_loss_work, timeout * HZ);

  	rport->port_state = FC_PORTSTATE_BLOCKED;
+
+	kobject_uevent(&rport_to_classdev(rport)->kobj, KOBJ_OFFLINE);
  }
  EXPORT_SYMBOL(fc_remote_port_delete);

diff -upNr a/include/linux/attribute_container.h 
b/include/linux/attribute_container.h
--- a/include/linux/attribute_container.h	2006-02-12 16:34:45.000000000 -0500
+++ b/include/linux/attribute_container.h	2006-02-12 16:50:06.000000000 -0500
@@ -50,6 +50,7 @@ void attribute_container_remove_device(s
  				       void (*fn)(struct attribute_container *,
  						  struct device *,
  						  struct class_device *));
+struct class_device *attribute_container_dev_to_classdev(struct device *dev);
  void attribute_container_device_trigger(struct device *dev,
  					int (*fn)(struct attribute_container *,
  						  struct device *,
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-02-06 12:00:33.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2006-02-22 08:52:41.000000000 -0500
@@ -29,6 +29,8 @@

  #include <linux/config.h>
  #include <linux/sched.h>
+#include <linux/kobject.h>
+#include <linux/attribute_container.h>
  #include <scsi/scsi.h>

  struct scsi_transport_template;
@@ -214,6 +216,8 @@ struct fc_rport {	/* aka fc_starget_attr
  	dev_to_rport(classdev->dev)
  #define rport_to_shost(r)			\
  	dev_to_shost(r->dev.parent)
+#define rport_to_classdev(r)			\
+	attribute_container_dev_to_classdev(&(r)->dev)

  /*
   * FC SCSI Target Attributes
@@ -278,6 +282,36 @@ struct fc_host_statistics {


  /*
+ * FC Event Codes - Polled and Async, following FC HBAAPI v2.0 guidelines
+ */
+
+/*
+ * fc_host_event_code: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_host_event_code  {
+	FCH_EVT_LIP			= 0x1,
+	FCH_EVT_LINKUP			= 0x2,
+	FCH_EVT_LINKDOWN		= 0x3,
+	FCH_EVT_LIPRESET		= 0x4,
+	FCH_EVT_RSCN			= 0x5,
+	FCH_EVT_ADAPTER_CHANGE		= 0x103,
+	FCH_EVT_PORT_UNKNOWN		= 0x200,
+	FCH_EVT_PORT_OFFLINE		= 0x201,
+	FCH_EVT_PORT_ONLINE		= 0x202,
+	FCH_EVT_PORT_FABRIC		= 0x204,
+	FCH_EVT_LINK_UNKNOWN		= 0x500,
+	FCH_EVT_VENDOR_UNIQUE		= 0xffff,
+};
+
+struct fc_host_event {
+	u32 seq_num;
+	enum fc_host_event_code event_code;
+	u32 event_data;
+};
+
+
+/*
   * FC Local Port (Host) Attributes
   *
   * Attributes are based on HBAAPI V2.0 definitions.
@@ -321,6 +355,8 @@ struct fc_host_attrs {

  	/* Private (Transport-managed) Attributes */
  	enum fc_tgtid_binding_type  tgtid_bind_type;
+	u32 event_cnt;
+	u16 max_events;

  	/* internal data */
  	struct list_head rports;
@@ -328,9 +364,17 @@ struct fc_host_attrs {
  	u32 next_rport_number;
  	u32 next_target_id;
  	u8 flags;
+	u32 event_seq;
+	u16 event_get;
+	u16 event_put;
+	struct fc_host_event *eventlist;
   	struct work_struct rport_del_work;
  };

+
+#define FC_HOST_MIN_EVENTLIST_SZ	128
+#define FC_HOST_MAX_EVENTLIST_SZ	2048
+
  /* values for struct fc_host_attrs "flags" field: */
  #define FC_SHOST_RPORT_DEL_SCHEDULED	0x01

@@ -367,6 +411,10 @@ struct fc_host_attrs {
  	(((struct fc_host_attrs *)(x)->shost_data)->fabric_name)
  #define fc_host_tgtid_bind_type(x) \
  	(((struct fc_host_attrs *)(x)->shost_data)->tgtid_bind_type)
+#define fc_host_event_cnt(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->event_cnt)
+#define fc_host_max_events(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->max_events)
  #define fc_host_rports(x) \
  	(((struct fc_host_attrs *)(x)->shost_data)->rports)
  #define fc_host_rport_bindings(x) \
@@ -377,6 +425,14 @@ struct fc_host_attrs {
  	(((struct fc_host_attrs *)(x)->shost_data)->next_target_id)
  #define fc_host_flags(x) \
  	(((struct fc_host_attrs *)(x)->shost_data)->flags)
+#define fc_host_event_seq(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->event_seq)
+#define fc_host_event_get(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->event_get)
+#define fc_host_event_put(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->event_put)
+#define fc_host_eventlist(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->eventlist)
  #define fc_host_rport_del_work(x) \
  	(((struct fc_host_attrs *)(x)->shost_data)->rport_del_work)

@@ -483,6 +539,8 @@ struct fc_rport *fc_remote_port_add(stru
  void fc_remote_port_delete(struct fc_rport  *rport);
  void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
  int scsi_is_fc_rport(const struct device *);
+void fc_host_event_post(struct Scsi_Host *shost,
+		enum fc_host_event_code event_code, u32 event_data);

  static inline u64 wwn_to_u64(u8 *wwn)
  {
