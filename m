Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AADC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F4161057
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhDAGP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 02:15:28 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:4666 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhDAGPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 02:15:13 -0400
IronPort-SDR: Y9vgizHD5qIqmwfsyyqc8ACqrrn8cdQL9XzwJKJSJN0Y2wA0XReoUg+GX34MgT+yidypf0CN3l
 hU1PweKYMIijIDxoTnTrCMVNbjaZQkE4a+ZSifp0701DVKxmw4Tm0XOmeQWHguiKS00xJ+y8Oc
 fa5P/w1g42+RjeAjMR7ctj0yLkn+Yf8pbXo4Rdyag8DOrxCQ2mLUk3uzbsadd34eUdar6CZa63
 5ZTZx6MfdOWQvpqAsU0rU0TWztZkmeovOdZo/qesR5x0TkgHY4dt79cp35FcASjw7fKptWcsAb
 jEA=
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="29736606"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 31 Mar 2021 23:15:14 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 31 Mar 2021 23:15:12 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3F29C210A9; Wed, 31 Mar 2021 23:15:12 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] scsi: ufs: Introduce hba performance monitor sysfs nodes
Date:   Wed, 31 Mar 2021 23:15:02 -0700
Message-Id: <1617257704-1154-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617257704-1154-1-git-send-email-cang@codeaurora.org>
References: <1617257704-1154-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new sysfs group which has nodes to monitor data/request transfer
performance. This sysfs group has nodes showing total sectors/requests
transferred, total busy time spent and max/min/avg/sum latencies. This
group can be enhanced later to show more UFS driver layer performance
statistics data during runtime.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index acc54f5..348df0e 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -278,6 +278,242 @@ static const struct attribute_group ufs_sysfs_default_group = {
 	.attrs = ufs_sysfs_ufshcd_attrs,
 };
 
+static ssize_t monitor_enable_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", hba->monitor.enabled);
+}
+
+static ssize_t monitor_enable_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long value, flags;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	value = !!value;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (value == hba->monitor.enabled)
+		goto out_unlock;
+
+	if (!value) {
+		memset(&hba->monitor, 0, sizeof(hba->monitor));
+	} else {
+		hba->monitor.enabled = true;
+		hba->monitor.enabled_ts = ktime_get();
+	}
+
+out_unlock:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return count;
+}
+
+static ssize_t monitor_chunk_size_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%lu\n", hba->monitor.chunk_size);
+}
+
+static ssize_t monitor_chunk_size_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long value, flags;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/* Only allow chunk size change when monitor is disabled */
+	if (!hba->monitor.enabled)
+		hba->monitor.chunk_size = value;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return count;
+}
+
+static ssize_t read_total_sectors_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_sec_rw[READ]);
+}
+
+static ssize_t read_total_busy_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.total_busy[READ]));
+}
+
+static ssize_t read_nr_requests_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_req[READ]);
+}
+
+static ssize_t read_req_latency_avg_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_monitor *m = &hba->monitor;
+
+	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
+						 m->nr_req[READ]));
+}
+
+static ssize_t read_req_latency_max_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.lat_max[READ]));
+}
+
+static ssize_t read_req_latency_min_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.lat_min[READ]));
+}
+
+static ssize_t read_req_latency_sum_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.lat_sum[READ]));
+}
+
+static ssize_t write_total_sectors_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_sec_rw[WRITE]);
+}
+
+static ssize_t write_total_busy_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.total_busy[WRITE]));
+}
+
+static ssize_t write_nr_requests_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_req[WRITE]);
+}
+
+static ssize_t write_req_latency_avg_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_monitor *m = &hba->monitor;
+
+	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
+						 m->nr_req[WRITE]));
+}
+
+static ssize_t write_req_latency_max_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.lat_max[WRITE]));
+}
+
+static ssize_t write_req_latency_min_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.lat_min[WRITE]));
+}
+
+static ssize_t write_req_latency_sum_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%llu\n",
+			  ktime_to_us(hba->monitor.lat_sum[WRITE]));
+}
+
+static DEVICE_ATTR_RW(monitor_enable);
+static DEVICE_ATTR_RW(monitor_chunk_size);
+static DEVICE_ATTR_RO(read_total_sectors);
+static DEVICE_ATTR_RO(read_total_busy);
+static DEVICE_ATTR_RO(read_nr_requests);
+static DEVICE_ATTR_RO(read_req_latency_avg);
+static DEVICE_ATTR_RO(read_req_latency_max);
+static DEVICE_ATTR_RO(read_req_latency_min);
+static DEVICE_ATTR_RO(read_req_latency_sum);
+static DEVICE_ATTR_RO(write_total_sectors);
+static DEVICE_ATTR_RO(write_total_busy);
+static DEVICE_ATTR_RO(write_nr_requests);
+static DEVICE_ATTR_RO(write_req_latency_avg);
+static DEVICE_ATTR_RO(write_req_latency_max);
+static DEVICE_ATTR_RO(write_req_latency_min);
+static DEVICE_ATTR_RO(write_req_latency_sum);
+
+static struct attribute *ufs_sysfs_monitor_attrs[] = {
+	&dev_attr_monitor_enable.attr,
+	&dev_attr_monitor_chunk_size.attr,
+	&dev_attr_read_total_sectors.attr,
+	&dev_attr_read_total_busy.attr,
+	&dev_attr_read_nr_requests.attr,
+	&dev_attr_read_req_latency_avg.attr,
+	&dev_attr_read_req_latency_max.attr,
+	&dev_attr_read_req_latency_min.attr,
+	&dev_attr_read_req_latency_sum.attr,
+	&dev_attr_write_total_sectors.attr,
+	&dev_attr_write_total_busy.attr,
+	&dev_attr_write_nr_requests.attr,
+	&dev_attr_write_req_latency_avg.attr,
+	&dev_attr_write_req_latency_max.attr,
+	&dev_attr_write_req_latency_min.attr,
+	&dev_attr_write_req_latency_sum.attr,
+	NULL
+};
+
+static const struct attribute_group ufs_sysfs_monitor_group = {
+	.name = "monitor",
+	.attrs = ufs_sysfs_monitor_attrs,
+};
+
 static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 				  enum desc_idn desc_id,
 				  u8 desc_index,
@@ -881,6 +1117,7 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
+	&ufs_sysfs_monitor_group,
 	&ufs_sysfs_device_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
 	&ufs_sysfs_geometry_descriptor_group,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 80620c8..b49555fa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2028,6 +2028,64 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 		scaling->is_busy_started = false;
 	}
 }
+
+static inline int ufshcd_monitor_opcode2dir(u8 opcode)
+{
+	if (opcode == READ_6 || opcode == READ_10 || opcode == READ_16)
+		return READ;
+	else if (opcode == WRITE_6 || opcode == WRITE_10 || opcode == WRITE_16)
+		return WRITE;
+	else
+		return -EINVAL;
+}
+
+static inline bool ufshcd_should_inform_monitor(struct ufs_hba *hba,
+						struct ufshcd_lrb *lrbp)
+{
+	struct ufs_hba_monitor *m = &hba->monitor;
+
+	return (m->enabled && lrbp && lrbp->cmd &&
+		(!m->chunk_size || m->chunk_size == lrbp->cmd->sdb.length) &&
+		ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_stamp));
+}
+
+static void ufshcd_start_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+
+	if (dir >= 0 && hba->monitor.nr_queued[dir]++ == 0)
+		hba->monitor.busy_start_ts[dir] = ktime_get();
+}
+
+static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
+
+	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
+		struct request *req = lrbp->cmd->request;
+		struct ufs_hba_monitor *m = &hba->monitor;
+		ktime_t now, inc, lat;
+
+		now = ktime_get();
+		inc = ktime_sub(now, m->busy_start_ts[dir]);
+		m->total_busy[dir] = ktime_add(m->total_busy[dir], inc);
+		m->nr_sec_rw[dir] += blk_rq_sectors(req);
+
+		/* Update latencies */
+		m->nr_req[dir]++;
+		lat = ktime_sub(now, lrbp->issue_time_stamp);
+		m->lat_sum[dir] += lat;
+		if (m->lat_max[dir] < lat || !m->lat_max[dir])
+			m->lat_max[dir] = lat;
+		if (m->lat_min[dir] > lat || !m->lat_min[dir])
+			m->lat_min[dir] = lat;
+
+		m->nr_queued[dir]--;
+		/* Push forward the busy start of monitor */
+		m->busy_start_ts[dir] = now;
+	}
+}
+
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
@@ -2044,6 +2102,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
+	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
+		ufshcd_start_monitor(hba, lrbp);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
@@ -5098,6 +5158,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
 		if (cmd) {
+			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
+				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 18e56c1..2bfe20e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -645,6 +645,25 @@ struct ufs_hba_variant_params {
 	u32 wb_flush_threshold;
 };
 
+struct ufs_hba_monitor {
+	unsigned long chunk_size;
+
+	unsigned long nr_sec_rw[2];
+	ktime_t total_busy[2];
+
+	unsigned long nr_req[2];
+	/* latencies*/
+	ktime_t lat_sum[2];
+	ktime_t lat_max[2];
+	ktime_t lat_min[2];
+
+	u32 nr_queued[2];
+	ktime_t busy_start_ts[2];
+
+	ktime_t enabled_ts;
+	bool enabled;
+};
+
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
@@ -832,6 +851,8 @@ struct ufs_hba {
 	struct request_queue	*bsg_queue;
 	struct delayed_work rpm_dev_flush_recheck_work;
 
+	struct ufs_hba_monitor	monitor;
+
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	union ufs_crypto_capabilities crypto_capabilities;
 	union ufs_crypto_cap_entry *crypto_cap_array;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

