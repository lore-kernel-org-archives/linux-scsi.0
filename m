Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6516DC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2824D222B6
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:09:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UWpeHMs6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKSUJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 15:09:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37583 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKSUJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 15:09:24 -0500
Received: by mail-wm1-f65.google.com with SMTP id b17so5307988wmj.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 12:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pRKtlmF/7P4CECFN+ULtxwhjpePgYzSKXjybRoUYkS4=;
        b=UWpeHMs6IZ4U+rUGSULFHXmOC6aI2Thf5MyXCs6y3pNAZuJZYLmroqgStfQHVwR+bq
         WovL39dKt0dleLwOSoi+BqGfsjZ6E2Agoln11UPRh++9NMWq/NJOsUZdLBZsiIKDNUM9
         gZ+Tkca5E1R1WxYjHLwa1umOyXbMRALKAUKgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pRKtlmF/7P4CECFN+ULtxwhjpePgYzSKXjybRoUYkS4=;
        b=O7HBDf/62leDALjBpuX1BAqaTASv6WGUT9Faek9XZZx571qRyCz0avYzN2fGquC08V
         UlnD4L/D/fmPJaaDVmupn9eA7kVswVETfzx3evwpJ6agNbsui5Wp31QTTuFWRn1c/djy
         aLRf6AZ4rnYAzkROfpSemsXro5ej40O6Un84lfWJE5bsPJWFwy9m2YVWNUWdUdFkdAAk
         Oc0xFqMWmT51i7cY3gkIEmIi2CfWU7+8kHHt6zt4awwNCAsF9i2rK79utxwBFAQQj/U7
         DIF0l22YVn7jHjY4etboe5TTmMcBOVNk5zEmgV4QxEJJ1pRCy1RkpDoUvALh45RYf7SX
         NLCw==
X-Gm-Message-State: APjAAAV+3Rzgpi9iQAvj9hPMdjr8CnsW/hix0EOcEr98/4o3Y13R5hY7
        KJTmVSyvlA3rlK71G7+BaUmbqQ==
X-Google-Smtp-Source: APXvYqy+pbzZPCb6TKoNUJQBXj1qrI9B7a0InFVC+1Pinkj+nwbixmx/hsXJ1isbtiARxmp+5wJjjg==
X-Received: by 2002:a1c:6a1a:: with SMTP id f26mr8259965wmc.19.1574194160906;
        Tue, 19 Nov 2019 12:09:20 -0800 (PST)
Received: from dhcp-135-15-167-92.dhcp.broadcom.net ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id x7sm33079002wrg.63.2019.11.19.12.09.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 12:09:20 -0800 (PST)
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
To:     axboe@kernel.dk, linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com, sathya.prakash@broadcom.com,
        chaitra.basappa@broadcom.com,
        suganath-prabu.subramani@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        emilne@redhat.com, hch@lst.de, hare@suse.de, bart.vanassche@wdc.com
Cc:     root <sumanesh.samanta@broadcom.com>
Subject: [PATCH 1/1] scsi core: limit overhead of device_busy counter for SSDs
Date:   Tue, 19 Nov 2019 12:07:59 -0800
Message-Id: <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: root <sumanesh.samanta@broadcom.com>

Recently a patch was delivered to remove host_busy counter from SCSI mid layer. That was a major bottleneck, and helped improve SCSI stack performance.
With that patch, bottle neck moved to the scsi_device device_busy counter. The performance issue with this counter is seen more in cases where a single device can produce very high IOPs, for example h/w RAID devices where OS sees one device, but there are many drives behind it, thus being capable of very high IOPs. The effect is also visible when cores from multiple NUMA nodes send IO to the same device or same controller.
The device_busy counter is not needed by controllers which can manage as many IO as submitted to it. Rotating media still uses it for merging IO, but for non-rotating SSD drives it becomes a major bottleneck as described above.

A few weeks back, a patch was provided to address the device_busy counter also but unfortunately that had some issues:
1. There was a functional issue discovered:
https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG4XC4VHWX5KKDJJI7P36EIGK526/
2. There was some concern about existing drivers using the device_busy counter.

This patch is an attempt to address both the above issues.
For this patch to be effective, LLDs need to set a specific flag use_per_cpu_device_busy in the scsi_host_template. For other drivers ( who does not set the flag), this patch would be a no-op, and should not affect their performance or functionality at all.

Also, this patch does not fundamentally change any logic or functionality of the code. All it does is replace device_busy with a per CPU counter. In fast path, all cpu increment/decrement their own counter. In relatively slow path. they call scsi_device_busy function to get the total no of IO outstanding on a device. Only functional aspect it changes is that for non-rotating media, the number of IO to a device is not restricted. Controllers which can handle that, can set the use_per_cpu_device_busy flag in scsi_host_template to take advantage of this patch. Other controllers need not modify any code and would work as usual.
Since the patch does not modify any other functional aspects, it should not have any side effects even for drivers that do set the use_per_cpu_device_busy flag.
---
 drivers/scsi/scsi_lib.c    | 151 ++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_scan.c   |  16 ++++
 drivers/scsi/scsi_sysfs.c  |   9 ++-
 drivers/scsi/sg.c          |   2 +-
 include/scsi/scsi_device.h |  15 ++++
 include/scsi/scsi_host.h   |  16 ++++
 6 files changed, 197 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2563b061f56b..5dc392914f9e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -52,6 +52,12 @@
 #define  SCSI_INLINE_SG_CNT  2
 #endif
 
+#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
+#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL>>16)
+#define USE_DEVICE_BUSY(sdev)	(!(sdev)->host->hostt->use_per_cpu_device_busy \
+				|| !blk_queue_nonrot((sdev)->request_queue))
+
+
 static struct kmem_cache *scsi_sdb_cache;
 static struct kmem_cache *scsi_sense_cache;
 static struct kmem_cache *scsi_sense_isadma_cache;
@@ -65,6 +71,111 @@ scsi_select_sense_cache(bool unchecked_isa_dma)
 	return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sense_cache;
 }
 
+/*
+ *Generic helper function to decrement per cpu io counter.
+ *@per_cpu_counter: The per cpu counter array. Current cpu counter will be
+ * decremented
+ */
+
+static inline void dec_per_cpu_io_counter(atomic64_t __percpu *per_cpu_counter)
+{
+	atomic64_t __percpu *io_count = get_cpu_ptr(per_cpu_counter);
+
+	if (unlikely(abs(atomic64_dec_return(io_count)) >
+				MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
+		scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_count);
+	put_cpu_ptr(per_cpu_counter);
+}
+/*
+ *Generic helper function to increment per cpu io counter.
+ *@per_cpu_counter: The per cpu counter array. Current cpu counter will be
+ * incremented
+ */
+static inline void inc_per_cpu_io_counter(atomic64_t __percpu *per_cpu_counter)
+{
+	atomic64_t __percpu *io_count =	get_cpu_ptr(per_cpu_counter);
+
+	if (unlikely(abs(atomic64_inc_return(io_count)) >
+				MAX_PER_CPU_COUNTER_ABSOLUTE_VAL))
+		scsi_rebalance_per_cpu_io_counters(per_cpu_counter, io_count);
+	put_cpu_ptr(per_cpu_counter);
+}
+
+
+/**
+ * scsi_device_busy - Return the device_busy counter
+ * @sdev:	Pointer to scsi_device to get busy counter.
+ **/
+int scsi_device_busy(struct scsi_device *sdev)
+{
+	long long total = 0;
+	int i;
+
+	if (USE_DEVICE_BUSY(sdev))
+		return atomic_read(&sdev->device_busy);
+
+	for (i = 0; i < num_online_cpus(); i++) {
+		atomic64_t __percpu *ioCount
+			= per_cpu_ptr(sdev->per_cpu_device_busy, i);
+		total += atomic64_read(ioCount);
+	}
+	return total;
+}
+EXPORT_SYMBOL(scsi_device_busy);
+
+
+/**
+ * scsi_rebalance_per_cpu_counters - balance per CPU counters
+ * @per_cpu_ary: The per cpu array that would be rebalanced
+ * @this_cpu_counter: The counter for this CPU
+ *
+ * Description: MUST be called with preempt disabled.
+ * The sum total of per cpu counters would always be pretty small: the total
+ * number of IO issued to device or host. Only extremely rarely can the counters
+ * have a danger of wrapping around. This will happen only when counters of cpu
+ * become completely unbalanced, one or more cpu having very large positive and
+ * some others very large negative. This can happen when one CPU always issues
+ * IO and another CPU always complete, and this go on for a very long time When
+ * such scenario happens (if ever), this function would balance the values so
+ * that the sum still remains the total number of outstanding IO, but the
+ * counters no longer face the danger of wrapping around
+ */
+
+extern void scsi_rebalance_per_cpu_io_counters(atomic64_t __percpu *per_cpu_ary,
+					atomic64_t __percpu *this_cpu_counter)
+{
+	atomic64_t __percpu *other_cpu_counter;
+	int i = 0;
+	long long this_cpu_value = atomic64_read(this_cpu_counter);
+
+	if (abs(this_cpu_value) <= PER_CPU_COUNTER_OK_VAL)
+		return;
+
+	for (i = 0; i < num_online_cpus(); i++) {
+		long long other_cpu_value;
+
+		other_cpu_counter = per_cpu_ptr(per_cpu_ary, i);
+		if (other_cpu_counter == this_cpu_counter)
+			continue;
+		do {
+			other_cpu_value = atomic64_read(other_cpu_counter);
+			if (other_cpu_value == 0
+				|| ((this_cpu_value > 0)
+					&& (other_cpu_value > 0))
+				|| ((this_cpu_value < 0)
+					&& (other_cpu_value < 0)))
+				goto continue_loop;
+		} while (atomic64_cmpxchg(other_cpu_counter, other_cpu_value, 0)
+			!= other_cpu_value);
+		this_cpu_value = atomic64_add_return(other_cpu_value,
+					this_cpu_counter);
+		if (abs(this_cpu_value) <= PER_CPU_COUNTER_OK_VAL)
+			break;
+continue_loop:;
+	}
+}
+
+
 static void scsi_free_sense_buffer(bool unchecked_isa_dma,
 				   unsigned char *sense_buffer)
 {
@@ -353,8 +464,10 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
-
-	atomic_dec(&sdev->device_busy);
+	if (USE_DEVICE_BUSY(sdev))
+		atomic_dec(&sdev->device_busy);
+	else
+		dec_per_cpu_io_counter(sdev->per_cpu_device_busy);
 }
 
 static void scsi_kick_queue(struct request_queue *q)
@@ -410,7 +523,8 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
+	if (USE_DEVICE_BUSY(sdev)
+		&& (atomic_read(&sdev->device_busy) >= sdev->queue_depth))
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1284,10 +1398,21 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 {
 	unsigned int busy;
 
-	busy = atomic_inc_return(&sdev->device_busy) - 1;
+	if (USE_DEVICE_BUSY(sdev))
+		busy = atomic_inc_return(&sdev->device_busy) - 1;
+	else {
+		inc_per_cpu_io_counter(sdev->per_cpu_device_busy);
+		busy = 0;
+	}
+
 	if (atomic_read(&sdev->device_blocked)) {
-		if (busy)
-			goto out_dec;
+		if (USE_DEVICE_BUSY(sdev)) {
+			if (busy)
+				goto out_dec;
+		} else {
+			if (scsi_device_busy(sdev) > 1)
+				goto out_dec;
+		}
 
 		/*
 		 * unblock after device_blocked iterates to zero
@@ -1303,7 +1428,10 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 
 	return 1;
 out_dec:
-	atomic_dec(&sdev->device_busy);
+	if (USE_DEVICE_BUSY(sdev))
+		atomic_dec(&sdev->device_busy);
+	else
+		dec_per_cpu_io_counter(sdev->per_cpu_device_busy);
 	return 0;
 }
 
@@ -1624,7 +1752,10 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
 
-	atomic_dec(&sdev->device_busy);
+	if (USE_DEVICE_BUSY(sdev))
+		atomic_dec(&sdev->device_busy);
+	else
+		dec_per_cpu_io_counter(sdev->per_cpu_device_busy);
 }
 
 static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
@@ -1635,7 +1766,7 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 	if (scsi_dev_queue_ready(q, sdev))
 		return true;
 
-	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
+	if (scsi_device_busy(sdev) == 0 && !scsi_device_blocked(sdev))
 		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
 	return false;
 }
@@ -1706,7 +1837,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
+		if (scsi_device_busy(sdev) ||
 		    scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 058079f915f1..fcaffd98fddd 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -224,6 +224,22 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
+	if (shost->hostt->use_per_cpu_device_busy) {
+		int i;
+
+		sdev->per_cpu_device_busy = alloc_percpu(atomic64_t);
+		if (!sdev->per_cpu_device_busy) {
+			kfree(sdev);
+			goto out;
+		}
+		for (i = 0; i < num_online_cpus(); i++) {
+			atomic64_t __percpu *ioCount;
+
+			ioCount = per_cpu_ptr(sdev->per_cpu_device_busy, i);
+			atomic64_set(ioCount, 0);
+		}
+	}
+
 	sdev->vendor = scsi_null_device_strs;
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2c76d7a43f67..96e6f3007fe3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -659,7 +659,7 @@ sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+	return snprintf(buf, 20, "%d\n", scsi_device_busy(sdev));
 }
 static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
 
@@ -1434,6 +1434,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
+
+	if (sdev->host->hostt->use_per_cpu_device_busy
+			&& sdev->per_cpu_device_busy){
+		free_percpu(sdev->per_cpu_device_busy);
+		sdev->per_cpu_device_busy = NULL;
+	}
+
 	transport_destroy_device(dev);
 
 	/*
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0940abd91d3c..8fe771c0496a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2449,7 +2449,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
-			      (int) atomic_read(&scsidp->device_busy),
+			      (int) scsi_device_busy(scsidp),
 			      (int) scsi_device_online(scsidp));
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3ed836db5306..3008d90dd36a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -107,6 +107,18 @@ struct scsi_device {
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
 	atomic_t device_busy;		/* commands actually active on LLDD */
+	/*
+	 *per cpu device_busy counter, used only when
+	 *hostt->use_per_cpu_device_busy is non Zero and non-rotational
+	 *devices. Rotational devices still use device_busy for IO merge
+	 *Note: IO can be completed in a different CPU than that issued,
+	 *and thus, some cpu counters can be negative However, total
+	 *summation would still provide accurate number of IO outstanding
+	 *in device. Summation should only be used in non-performance
+	 *context
+	 */
+	atomic64_t __percpu *per_cpu_device_busy;
+
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
 	spinlock_t list_lock;
@@ -341,6 +353,9 @@ void scsi_attach_vpd(struct scsi_device *sdev);
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
+extern int scsi_device_busy(struct scsi_device *sdev);
+extern void scsi_rebalance_per_cpu_io_counters(atomic64_t __percpu *per_cpu_ary,
+					atomic64_t __percpu *this_cpu_counter);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
 					      uint, uint, u64);
 extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f577647bf5f2..799f38a04fb1 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -429,6 +429,22 @@ struct scsi_host_template {
 	/* True if the low-level driver supports blk-mq only */
 	unsigned force_blk_mq:1;
 
+	/*
+	 *Optional.
+	 *When this variable is non Zero, instead of scsi_device_device_busy,
+	 *scsi_device->per_cpu_device_busy is used,that would count out-standing
+	 *IO to device on a per cpu basis for non-rotational devices ONLY.
+	 *SCSI layer would NOT enforce any per device IO limit
+	 *(sdev->queue_depth ignored) if this variable is set, hence low level
+	 *driver should be able to handle "unlimited IOs" to device. However,
+	 *low level driver can still send device "queue full", and set
+	 *device_blocked Also, when this flag is set, device_busy can not be
+	 *used to get a count of outstanding host IOs. scsi_device_busy
+	 *function should be used instead.
+	 */
+
+	unsigned use_per_cpu_device_busy:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
-- 
2.23.0

