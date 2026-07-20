Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5D126BF7
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 01:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784511485; cv=none; b=VtVauJYq2cm4GwwtDBvckALgink0+u9imN+mo7+/CUWRY9JRbz3fL8PIVutOGYbdmcaQSp0Yh5OOax6AI7ILzNpHB3WDHVQ7FZhtzzaVG2x47O1uzCDeAvsjLIpWaRlQL2If4zvn5yass7tVAMovlrks9LeML7LIO2VCQNFQ334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784511485; c=relaxed/simple;
	bh=gAacO2mmcEYOP9wL99OjzZaY6nB3pByDN3ZyLSHDcCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YS3PCiJzijJ38PBeKIR722i8mQpMnQnu6yd9tO1H2RYmzCVXFTEADLJMiEvsYNDTwGG1WMi6ryvZJTe8mMymmaO0OA+o2vsqPsxfHKLgBEWzhD+wMRqO08EcgMCN+TRM17MRTRYNQ9fdPLdXboTDiq0QLrYL8P0NlkX0Kl0um1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=epf1Rkgs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="epf1Rkgs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YQPQOwerLERrj25A5pSqR/C7vg/4PN0ez+Twz0ltcXY=; b=epf1RkgsYs8DRm6PzuA7k93pEi
	Otks5iDC5NPaHPd3VrCDbwAf++uEUASL6ZZ/cy5vm3+4fvjfM76e8WxEvhbwtggBDFmwLQn8BL9e1
	+Ze0V0drc6k5ZALaezxKn+HMumyKasGCFiS6AlgDpTQ2msc49HseFH1yP2TwwQN8Bm6W0xvD4En5M
	tVSTm2r+rCEx4YRy0RRpKujnGQv1uUnA+g5qlzI77x8byYrS0WqzLjugA7vDsZNkNwBUb90HfoguS
	zhyQ94XDyyCYC5iGTtaFoPZWJKs7kGi8QvM0smRnSRiEkqv4jF9dHI4A2gwfSuMagy4raG9Va5I7i
	9FxGBZBQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlcxE-00000005ckW-03T0;
	Mon, 20 Jul 2026 01:38:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
Date: Sun, 19 Jul 2026 18:37:59 -0700
Message-ID: <20260720013759.2979593-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- use the correct name for a struct in kernel-doc
- add kernel-doc for missing struct members or correct the name

Warning: ./include/ufs/ufshcd.h:201 Excess struct member 'task_tag'
 description in 'ufshcd_lrb'
Warning: ./include/ufs/ufshcd.h:220 expecting prototype for struct
 ufs_query_resp. Prototype was for struct ufs_query_res instead
Warning: ./include/ufs/ufshcd.h:577 struct member 'suspend_on_no_request'
 not described in 'ufs_clk_scaling'
Warning: ./include/ufs/ufshcd.h:1269 struct member 'nortt' not described
 in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1269 struct member 'trigger_eh_attr' not
 described in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1269 struct member 'timeout_attr' not
 described in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1269 struct member 'lsdb_sup' not
 described in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1269 struct member 'vcc_off_delay_us' not
 described in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1269 Excess struct member 'desc_size'
 description in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1269 Excess struct member 'res'
 description in 'ufs_hba'
Warning: ./include/ufs/ufshcd.h:1309 struct member 'sq_tail_slot' not
 described in 'ufs_hw_queue'
Warning: ./include/ufs/ufshcd.h:1309 Excess struct member 'sq_tp_slot'
 description in 'ufs_hw_queue'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bart Van Assche <bvanassche@acm.org>

 include/ufs/ufshcd.h |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- linux-next-20260717.orig/include/ufs/ufshcd.h
+++ linux-next-20260717/include/ufs/ufshcd.h
@@ -163,7 +163,6 @@ struct ufs_pm_lvl_states {
  * @ucd_req_dma_addr: UPIU request dma address for debug
  * @scsi_status: SCSI status of the command
  * @command_type: SCSI, UFS, Query.
- * @task_tag: Task tag of the command
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
  * @req_abort_skip: skip request abort task flag
@@ -212,8 +211,7 @@ struct ufs_query_req {
 };
 
 /**
- * struct ufs_query_resp - UPIU QUERY
- * @response: device response code
+ * struct ufs_query_res - UPIU QUERY
  * @upiu_res: query response data
  */
 struct ufs_query_res {
@@ -555,6 +553,7 @@ struct ufs_clk_gating {
  * @is_initialized: Indicates whether clock scaling is initialized or not
  * @is_busy_started: tracks if busy period has started or not
  * @is_suspended: tracks if devfreq is suspended or not
+ * @suspend_on_no_request: suspend clock scaling only when no request
  */
 struct ufs_clk_scaling {
 	struct workqueue_struct *workq;
@@ -976,7 +975,7 @@ enum ufshcd_mcq_opr {
  * @capabilities: UFS Controller Capabilities
  * @mcq_capabilities: UFS Multi Circular Queue capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
- * @nortt - Max outstanding RTTs supported by controller
+ * @nortt: Max outstanding RTTs supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
  * @ufs_version: UFS Version to which controller complies
  * @vops: pointer to variant specific operations
@@ -1038,7 +1037,6 @@ enum ufshcd_mcq_opr {
  *  device is known or not.
  * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
  * @clk_scaling_lock: used to serialize device commands and clock scaling
- * @desc_size: descriptor sizes reported by device
  * @bsg_dev: struct device associated with the BSG queue
  * @bsg_queue: BSG queue associated with the UFS controller
  * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
@@ -1053,16 +1051,19 @@ enum ufshcd_mcq_opr {
  * @debugfs_ee_work: used to restore ee_ctrl_mask after a delay
  * @debugfs_ee_rate_limit_ms: user configurable delay after which to restore
  *	ee_ctrl_mask
+ * @trigger_eh_attr: fault attributes for the fault injection trigger EH
+ * @timeout_attr: fault attributes for the timeout fault injection trigger
  * @luns_avail: number of regular and well known LUNs supported by the UFS
  *	device
  * @nr_hw_queues: number of hardware queues configured
  * @nr_queues: number of Queues of different queue types
  * @complete_put: whether or not to call ufshcd_rpm_put() from inside
  *	ufshcd_resume_complete()
+ * @scsi_host_added: indicates that scsi_add_host() has been called
  * @mcq_sup: is mcq supported by UFSHC
+ * @lsdb_sup: LSDBS capability
  * @mcq_enabled: is mcq ready to accept requests
  * @mcq_esi_enabled: is mcq ESI configured
- * @res: array of resource info of MCQ registers
  * @mcq_base: Multi circular queue registers base address
  * @uhq: array of supported hardware queues
  * @mcq_opr: MCQ operation and runtime registers
@@ -1078,6 +1079,7 @@ enum ufshcd_mcq_opr {
  *	field within the Host Controller's UECDME register. Bit[0] is a flag
  *	indicating that the DME QoS Monitor has been reset by the host.
  * @dme_qos_sysfs_handle: handle for 'dme_qos_notification' sysfs entry
+ * @vcc_off_delay_us: length of delay after VCC is powered off
  * @rpmbs: list of OP-TEE RPMB devices (one per RPMB region)
  * @host_preshoot_cap: a bitfield to indicate supported PreShoot dBs of host's TX lanes, cache of
  *	host M-PHY TX_HS_PreShoot_Setting_Capability Attribute (ID 0x15)
@@ -1284,7 +1286,7 @@ struct ufs_hba {
  * @cqe_dma_addr: completion queue dma address
  * @max_entries: max number of slots in this hardware queue
  * @id: hardware queue ID
- * @sq_tp_slot: current slot to which SQ tail pointer is pointing
+ * @sq_tail_slot: current slot to which SQ tail pointer is pointing
  * @sq_lock: serialize submission queue access
  * @cq_tail_slot: current slot to which CQ tail pointer is pointing
  * @cq_head_slot: current slot to which CQ head pointer is pointing
@@ -1508,6 +1510,8 @@ static inline void ufshcd_set_variant(st
 /**
  * ufshcd_get_variant - get variant specific data from the hba
  * @hba: per adapter instance
+ *
+ * Returns: pointer to the hba's private data area
  */
 static inline void *ufshcd_get_variant(struct ufs_hba *hba)
 {
