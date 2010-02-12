From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] scsi_transport_fc: handle transient error on multipath environment
Date: Fri, 12 Feb 2010 17:09:27 +0900
Message-ID: <4B750CB7.4030805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, James.Bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, kusumi.tomohiro@jp.fujitsu.com
List-Id: linux-scsi@vger.kernel.org

Hi

We've been working on SCSI-FC for enterprise system using MD/DMMP.
In enterprise system, response time from disk is important factor,
thus it is important for multipathd to quickly discard current path and
failover to secondary RAID disk if any problem with disk I/O is detected.
In order to switch to alternative path as quick as possible, multipathd
should quickly recognize phenomenon such as fibre channel link down,
no response from disk, etc.

In the past, we've posted a patch that reduces response time from disk,
although it was a trial patch since there wasn't good framework to
implement those features. We did it in block layer and that wasn't
a good choice I guess.
http://marc.info/?l=linux-kernel&m=109598324018681&w=2

But in the recent SCSI driver, transport layer for each lower level
interface is getting bigger and better which I think is a good platform
to implement them. As far as I know, Mr. Mike Christie has already been
working on fast io fail timeout feature for fibre channel transport layer,
and that enables userland multipathd quickly guess that the path is down
when fibre channel linkdown occured on LLD like lpfc. This patch is a
simple additional feature to what Mike has been working on.

This is what I'm trying to do.
1. If SCSI command had timed out, I assume it's time to failover to the
   secondary disk without error recovery. Let's call it transient error.
2. Schedule fc_rport_recover_transient_error from fc_timed_out using work
   queue if the feature is enabled. Also, make fc_timed_out return
   BLK_EH_HANDLED so as not to wake up error handler kernel thread.
3. That workqueue calls transport template function recover_transient_error
   if LLD implements it. Otherwise, it simply calls fc_remote_port_delete
   and delete fibre channel remote port that corresponds to the SCSI target
   device that caused transient error.
4. Once fc_remote_port_delete is called, it removes the remote port and
   take care of existing and incoming I/O just like when fibre channel
   linkdown occured.
5. If fast io fail timeout is enabled, multipathd can quickly recognize
   disk I/O problem and make dm-mpath driver failover to secondary disk.
   Even if fast io fail timeout is disabled, multipathd can recognize it
   anyway after dev loss timeout expired.

In the current SCSI mid layer driver, SCSI command timeout wakes up error
handler kernel thread which takes quite long time depending on the imple-
mentation of LLD. Although waking up SCSI error handler is right thing to
do in most cases, I think it is not suitable for multipath environment
with requirement of quick response. Enabling recover_transient_feature
might help those who don't want recovery operation, but just quick failover.


Thanks,
Tomohiro Kusumi



Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.33-rc7.org/drivers/scsi/scsi_transport_fc.c linux-2.6.33-rc7/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.33-rc7.org/drivers/scsi/scsi_transport_fc.c	2010-02-07 07:17:12.000000000 +0900
+++ linux-2.6.33-rc7/drivers/scsi/scsi_transport_fc.c	2010-02-12 15:16:05.985439982 +0900
@@ -284,13 +284,14 @@
 static void fc_timeout_deleted_rport(struct work_struct *work);
 static void fc_timeout_fail_rport_io(struct work_struct *work);
 static void fc_scsi_scan_rport(struct work_struct *work);
+static void fc_rport_recover_transient_error(struct work_struct *work);
 
 /*
  * Attribute counts pre object type...
  * Increase these values if you add attributes
  */
 #define FC_STARGET_NUM_ATTRS 	3
-#define FC_RPORT_NUM_ATTRS	10
+#define FC_RPORT_NUM_ATTRS	11
 #define FC_VPORT_NUM_ATTRS	9
 #define FC_HOST_NUM_ATTRS	22
 
@@ -935,6 +936,39 @@
 static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
 
+/*
+ * recover_transient_error attribute
+ */
+static ssize_t
+show_fc_rport_recover_transient_error (struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	return snprintf(buf, 20, "%d\n", rport->recover_transient_error);
+}
+
+static ssize_t
+store_fc_rport_recover_transient_error(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	int val;
+	char *cp;
+	struct fc_rport *rport = transport_class_to_rport(dev);
+
+	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
+	    (rport->port_state == FC_PORTSTATE_DELETED) ||
+	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
+		return -EBUSY;
+	val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) || val < 0 || val > 1)
+		return -EINVAL;
+	rport->recover_transient_error = val;
+	return count;
+}
+static FC_DEVICE_ATTR(rport, recover_transient_error, S_IRUGO | S_IWUSR,
+	show_fc_rport_recover_transient_error,
+	store_fc_rport_recover_transient_error);
 
 /*
  * FC SCSI Target Attribute Management
@@ -1953,6 +1987,13 @@
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
+	if (rport->recover_transient_error) {
+		fc_queue_work(scmd->device->host, &rport->rport_te_work);
+		scmd->result = ((scmd->result & 0xFF00FFFF) |
+				(DID_TRANSPORT_DISRUPTED << 16));
+		return BLK_EH_HANDLED;
+	}
+
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
@@ -2156,6 +2197,7 @@
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(recover_transient_error);
 
 	BUG_ON(count > FC_RPORT_NUM_ATTRS);
 
@@ -2506,6 +2548,7 @@
 	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport);
 	INIT_WORK(&rport->stgt_delete_work, fc_starget_delete);
 	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete);
+	INIT_WORK(&rport->rport_te_work, fc_rport_recover_transient_error);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -3157,6 +3200,36 @@
 }
 
 /**
+ * fc_rport_recover_transient_error - Transient error recovery handler
+ * @work:	contained by rport that corresponds to SCSI device to
+ * recover from transient error.
+ *
+ * Description: This routine is used when transient error
+ * (such as no response from disk) is detected. If FC LLD does not have
+ * implementation of recover_transient_error this routine simply deletes
+ * that port just like when FC linkdown is detected. In multipath envir-
+ * onment, if fast io fail timeout is enabled, multipathd can quickly
+ * guess that there is a problem with disk I/O and try to deactivate
+ * current path.
+ */
+static void
+fc_rport_recover_transient_error(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, rport_te_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	if (rport->port_state == FC_PORTSTATE_BLOCKED)
+		return;
+
+	if (i->f->recover_transient_error)
+		i->f->recover_transient_error(rport);
+	else
+		fc_remote_port_delete(rport);
+}
+
+/**
  * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
  * @cmnd: SCSI command that scsi_eh is trying to recover
  *
diff -aNur linux-2.6.33-rc7.org/include/scsi/scsi_transport_fc.h linux-2.6.33-rc7/include/scsi/scsi_transport_fc.h
--- linux-2.6.33-rc7.org/include/scsi/scsi_transport_fc.h	2010-02-07 07:17:12.000000000 +0900
+++ linux-2.6.33-rc7/include/scsi/scsi_transport_fc.h	2010-02-11 22:28:38.988369450 +0900
@@ -336,6 +336,7 @@
 	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
 	u32 scsi_target_id;
 	u32 fast_io_fail_tmo;
+	int recover_transient_error;
 
 	/* exported data */
 	void *dd_data;			/* Used for driver-specific storage */
@@ -351,6 +352,7 @@
  	struct delayed_work fail_io_work;
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
+	struct work_struct rport_te_work;
 	struct request_queue *rqst_q;	/* bsg support */
 } __attribute__((aligned(sizeof(unsigned long))));
 
@@ -648,6 +650,7 @@
 
 	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
 	void	(*terminate_rport_io)(struct fc_rport *);
+	void	(*recover_transient_error)(struct fc_rport *);
 
 	void	(*set_vport_symbolic_name)(struct fc_vport *);
 	int  	(*vport_create)(struct fc_vport *, bool);
