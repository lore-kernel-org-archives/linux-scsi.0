From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] scsi: add rate limit to scsi sense code uevent
Date: Fri, 21 Jul 2017 15:57:32 -0700
Message-ID: <20170721225732.311745-3-songliubraving@fb.com>
References: <20170721225732.311745-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754908AbdGUW5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 18:57:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6LMtLDq004372
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2017 15:57:41 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2buqx80k0v-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2017 15:57:41 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (10.212.236.89) with ESMTP id
 ff1e85b66e6711e793410002c95209d8-92e13150 for <linux-scsi@vger.kernel.org>;
        Fri, 21 Jul 2017 15:57:39 -0700
In-Reply-To: <20170721225732.311745-1-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com, emilne@redhat.com, jthumshirn@suse.de, Song Liu <songliubraving@fb.com>

This patch adds rate limits to SCSI sense code uevets. Currently,
the rate limit is hard-coded to 64 events per second per Scsi_Host.

The code tracks nano second time of latest 64 events in a circular
buffer. When a new event arrives, the time is compared against the
latest time in the buffer. If the difference is smaller than one
second, the new event is dropped.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/hosts.c      |  4 ++++
 drivers/scsi/scsi_error.c | 16 ++++++++++++++++
 include/scsi/scsi_host.h  | 13 +++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 831a1c8..219481b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -408,6 +408,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	spin_lock_init(&shost->latest_event_lock);
+#endif
+
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
 	if (index < 0)
 		goto fail_kfree;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f6107f7..58047f9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -436,9 +436,25 @@ static void scsi_send_sense_uevent(struct scsi_device *sdev,
 #ifdef CONFIG_SCSI_SENSE_UEVENT
 	struct scsi_event *evt;
 	unsigned char sb_len;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
+	u64 time_ns;
 
 	if (!test_bit(sshdr->sense_key, &sdev->sense_event_filter))
 		return;
+
+	time_ns = ktime_to_ns(ktime_get());
+	spin_lock_irqsave(&shost->latest_event_lock, flags);
+	if (time_ns - shost->latest_event_times[shost->latest_event_idx] <
+	    NSEC_PER_SEC) {
+		spin_unlock_irqrestore(&shost->latest_event_lock, flags);
+		return;
+	}
+	shost->latest_event_times[shost->latest_event_idx] = time_ns;
+	shost->latest_event_idx = (shost->latest_event_idx + 1) %
+		MAX_SENSE_EVENT_PER_SECOND;
+	spin_unlock_irqrestore(&shost->latest_event_lock, flags);
+
 	evt = sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
 	if (!evt)
 		return;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index afb0481..8aacb15 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -731,6 +731,19 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+#define MAX_SENSE_EVENT_PER_SECOND	64
+	/*
+	 * To rate limit uevents to MAX_SENSE_EVENT_PER_SECOND, we track
+	 * nano second time of MAX_SENSE_EVENT_PER_SECOND most recent
+	 * events. If there are already MAX_SENSE_EVENT_PER_SECOND in the
+	 * past seconds, new event is dropped.
+	 */
+	u64		latest_event_times[MAX_SENSE_EVENT_PER_SECOND];
+	int		latest_event_idx;
+	spinlock_t	latest_event_lock;
+#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
-- 
2.9.3
