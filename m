Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B2A263F22;
	Fri, 22 Aug 2025 10:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755857867; cv=none; b=aw8jUUNIHtvIdNNhKoHZ99Auo0LRhMXAQbat4t5Ho+/OaDg6Mo5wlRaGd3Fec7o6kgk92F4sfhv+doDTLjjRYc2pSkRrr48bfJGs3/dzcVdeSY1nud1peErNmKOcz+Ef5fEqGG4M+L+SdkTOZa4NHq52xr44X+nfwG1Z7NgcYHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755857867; c=relaxed/simple;
	bh=Y7qcWVF+D5oOwpZXrzLgBUf38TUjtat2egHfj8C7kso=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=ZD4TQA4ST+6JOGYQQ+Zuncaz5ASuxhhYupsnWYuQAz7gsRZS14G4/ihSj6PNeLpg7h2cDKWRcXAtcP7bwuV4NSltV2DYrPQy2yPNthp56NBckMSJxJBS8D3o1PGo62G5clAbN5scx7mYiMy2CKRjKSOI/pqpyWF4MsseAesSTIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=RKm3mSig; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="RKm3mSig"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1755857863;
	bh=Y7qcWVF+D5oOwpZXrzLgBUf38TUjtat2egHfj8C7kso=;
	h=Message-ID:Subject:From:To:Date:From;
	b=RKm3mSiga0cUfbYV0hYaTnltyocptaKx2duEDo3Dn4iOIfF5fe7W20fTwox0GgBPb
	 sVTJ1AZBc0HQSrQWU4uLmp0QM7A4F+oNHEns4HdvV7kNzihqCiyrteJFucV29W18Du
	 1okxlUqDjXeKTivb/MYhyoUv9rin6mQzMXcTUtDw=
Received: from [IPv6:2a00:23c8:101e:bb01:5bfe:95b6:ba99:a97b] (unknown [IPv6:2a00:23c8:101e:bb01:5bfe:95b6:ba99:a97b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 58F271C00A4;
	Fri, 22 Aug 2025 06:17:43 -0400 (EDT)
Message-ID: <452558f823f5396a3c7a44c72cc0e0fb6b081a3b.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.17-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 22 Aug 2025 11:17:41 +0100
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

All fixes in drivers.  The largest diffstat in ufs is caused by the doc
update with the next being the qcom null pointer deref fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Add support for Intel Wildcat Lake

Bart Van Assche (4):
      scsi: ufs: core: Rename ufshcd_wait_for_doorbell_clr()
      scsi: ufs: core: Fix the return value documentation
      scsi: ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl=
()
      scsi: ufs: core: Fix IRQ lock inversion for the SCSI host lock

Christoph Hellwig (1):
      scsi: fnic: Remove a useless struct mempool forward declaration

Dan Carpenter (1):
      scsi: qla4xxx: Prevent a potential error pointer dereference

Nitin Rawat (1):
      scsi: ufs: ufs-qcom: Fix ESI null pointer dereference

And the diffstat:

 drivers/scsi/fnic/fnic.h      |  2 --
 drivers/scsi/qla4xxx/ql4_os.c |  2 ++
 drivers/ufs/core/ufshcd.c     | 76 +++++++++++++++++++++++++--------------=
----
 drivers/ufs/host/ufs-qcom.c   | 39 +++++++++-------------
 drivers/ufs/host/ufshcd-pci.c |  1 +
 5 files changed, 62 insertions(+), 58 deletions(-)

With full diff below.

Regards,

James

---

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index c2fdc6553e62..1199d701c3f5 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -323,8 +323,6 @@ enum fnic_state {
 	FNIC_IN_ETH_TRANS_FC_MODE,
 };
=20
-struct mempool;
-
 enum fnic_role_e {
 	FNIC_ROLE_FCP_INITIATOR =3D 0,
 };
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a39f1da4ce47..a761c0aa5127 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6606,6 +6606,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(str=
uct scsi_qla_host *ha,
=20
 	ep =3D qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
 	vfree(dst_addr);
+	if (IS_ERR(ep))
+		return NULL;
 	return ep;
 }
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index efd7a811a002..9a43102b2b21 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1303,7 +1303,7 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
  *
  * Return: 0 upon success; -EBUSY upon timeout.
  */
-static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
+static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
 	int ret =3D 0;
@@ -1431,7 +1431,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hb=
a *hba, u64 timeout_us)
 	down_write(&hba->clk_scaling_lock);
=20
 	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
+	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret =3D -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
@@ -3199,7 +3199,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct=
 ufshcd_lrb *lrbp)
 }
=20
 /*
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
@@ -3275,7 +3276,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hb=
a,
 		}
 	}
=20
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3294,7 +3294,8 @@ static void ufshcd_dev_man_unlock(struct ufs_hba *hba=
)
 }
=20
 /*
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lr=
bp,
 			  const u32 tag, int timeout)
@@ -3317,7 +3318,8 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, =
struct ufshcd_lrb *lrbp,
  * @cmd_type: specifies the type (NOP, Query...)
  * @timeout: timeout in milliseconds
  *
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  *
  * NOTE: Since there is only one available tag for device management comma=
nds,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -3363,6 +3365,10 @@ static inline void ufshcd_init_query(struct ufs_hba =
*hba,
 	(*request)->upiu_req.selector =3D selector;
 }
=20
+/*
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
+ */
 static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum flag_idn idn, u8 index, bool *flag_res)
 {
@@ -3383,7 +3389,6 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hb=
a,
 		dev_err(hba->dev,
 			"%s: query flag, opcode %d, idn %d, failed with error %d after %d retri=
es\n",
 			__func__, opcode, idn, ret, retries);
-	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
@@ -3395,7 +3400,8 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hb=
a,
  * @index: flag index to access
  * @flag_res: the flag value after the query request completes
  *
- * Return: 0 for success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 			enum flag_idn idn, u8 index, bool *flag_res)
@@ -3451,7 +3457,6 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query=
_opcode opcode,
=20
 out_unlock:
 	ufshcd_dev_man_unlock(hba);
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3464,8 +3469,9 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query=
_opcode opcode,
  * @selector: selector field
  * @attr_val: the attribute value after the query request completes
  *
- * Return: 0 upon success; < 0 upon failure.
-*/
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
+ */
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
 {
@@ -3513,7 +3519,6 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query=
_opcode opcode,
=20
 out_unlock:
 	ufshcd_dev_man_unlock(hba);
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3528,8 +3533,9 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query=
_opcode opcode,
  * @attr_val: the attribute value after the query request
  * completes
  *
- * Return: 0 for success; < 0 upon failure.
-*/
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
+ */
 int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
 	u32 *attr_val)
@@ -3551,12 +3557,12 @@ int ufshcd_query_attr_retry(struct ufs_hba *hba,
 		dev_err(hba->dev,
 			"%s: query attribute, idn %d, failed with error %d after %d retries\n",
 			__func__, idn, ret, QUERY_REQ_RETRIES);
-	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
 /*
- * Return: 0 if successful; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
@@ -3615,7 +3621,6 @@ static int __ufshcd_query_descriptor(struct ufs_hba *=
hba,
 out_unlock:
 	hba->dev_cmd.query.descriptor =3D NULL;
 	ufshcd_dev_man_unlock(hba);
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3632,7 +3637,8 @@ static int __ufshcd_query_descriptor(struct ufs_hba *=
hba,
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  *
- * Return: 0 for success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum query_opcode opcode,
@@ -3650,7 +3656,6 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba=
,
 			break;
 	}
=20
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3663,7 +3668,8 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba=
,
  * @param_read_buf: pointer to buffer where parameter would be read
  * @param_size: sizeof(param_read_buf)
  *
- * Return: 0 in case of success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 int ufshcd_read_desc_param(struct ufs_hba *hba,
 			   enum desc_idn desc_id,
@@ -3730,7 +3736,6 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
-	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
@@ -4781,7 +4786,8 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  *
  * Set fDeviceInit flag and poll until device toggles it.
  *
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
@@ -5135,7 +5141,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
  * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
  * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
  *
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 {
@@ -5559,9 +5566,9 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hb=
a *hba, u32 intr_status)
 	irqreturn_t retval =3D IRQ_NONE;
 	struct uic_command *cmd;
=20
-	spin_lock(hba->host->host_lock);
+	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd =3D hba->active_uic_cmd;
-	if (WARN_ON_ONCE(!cmd))
+	if (!cmd)
 		goto unlock;
=20
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
@@ -5586,8 +5593,6 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hb=
a *hba, u32 intr_status)
 		ufshcd_add_uic_command_trace(hba, cmd, UFS_CMD_COMP);
=20
 unlock:
-	spin_unlock(hba->host->host_lock);
-
 	return retval;
 }
=20
@@ -5869,7 +5874,8 @@ static inline int ufshcd_enable_ee(struct ufs_hba *hb=
a, u16 mask)
  * as the device is allowed to manage its own way of handling background
  * operations.
  *
- * Return: zero on success, non-zero on failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 {
@@ -5908,7 +5914,8 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *h=
ba)
  * host is idle so that BKOPS are managed effectively without any negative
  * impacts.
  *
- * Return: zero on success, non-zero on failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 {
@@ -6058,6 +6065,10 @@ static void ufshcd_bkops_exception_event_handler(str=
uct ufs_hba *hba)
 				__func__, err);
 }
=20
+/*
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
+ */
 int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exceptio=
n_id)
 {
 	struct utp_upiu_query_v4_0 *upiu_resp;
@@ -6920,7 +6931,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba=
 *hba, u32 intr_status)
 	bool queue_eh_work =3D false;
 	irqreturn_t retval =3D IRQ_NONE;
=20
-	spin_lock(hba->host->host_lock);
+	guard(spinlock_irqsave)(hba->host->host_lock);
 	hba->errors |=3D UFSHCD_ERROR_MASK & intr_status;
=20
 	if (hba->errors & INT_FATAL_ERRORS) {
@@ -6979,7 +6990,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba=
 *hba, u32 intr_status)
 	 */
 	hba->errors =3D 0;
 	hba->uic_error =3D 0;
-	spin_unlock(hba->host->host_lock);
+
 	return retval;
 }
=20
@@ -7454,7 +7465,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
  * @sg_list:	Pointer to SG list when DATA IN/OUT UPIU is required in ARPMB=
 operation
  * @dir:	DMA direction
  *
- * Return: zero on success, non-zero on failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS erro=
r;
+ * < 0 if another error occurred.
  */
 int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_=
req *req_upiu,
 			 struct utp_upiu_req *rsp_upiu, struct ufs_ehs *req_ehs,
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 76fc70503a62..9574fdc2bb0f 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2070,17 +2070,6 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq,=
 void *data)
 	return IRQ_HANDLED;
 }
=20
-static void ufs_qcom_irq_free(struct ufs_qcom_irq *uqi)
-{
-	for (struct ufs_qcom_irq *q =3D uqi; q->irq; q++)
-		devm_free_irq(q->hba->dev, q->irq, q->hba);
-
-	platform_device_msi_free_irqs_all(uqi->hba->dev);
-	devm_kfree(uqi->hba->dev, uqi);
-}
-
-DEFINE_FREE(ufs_qcom_irq, struct ufs_qcom_irq *, if (_T) ufs_qcom_irq_free=
(_T))
-
 static int ufs_qcom_config_esi(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
@@ -2095,18 +2084,18 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	 */
 	nr_irqs =3D hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
=20
-	struct ufs_qcom_irq *qi __free(ufs_qcom_irq) =3D
-		devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), GFP_KERNEL);
-	if (!qi)
-		return -ENOMEM;
-	/* Preset so __free() has a pointer to hba in all error paths */
-	qi[0].hba =3D hba;
-
 	ret =3D platform_device_msi_init_and_alloc_irqs(hba->dev, nr_irqs,
 						      ufs_qcom_write_msi_msg);
 	if (ret) {
-		dev_err(hba->dev, "Failed to request Platform MSI %d\n", ret);
-		return ret;
+		dev_warn(hba->dev, "Platform MSI not supported or failed, continuing wit=
hout ESI\n");
+		return ret; /* Continue without ESI */
+	}
+
+	struct ufs_qcom_irq *qi =3D devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), =
GFP_KERNEL);
+
+	if (!qi) {
+		platform_device_msi_free_irqs_all(hba->dev);
+		return -ENOMEM;
 	}
=20
 	for (int idx =3D 0; idx < nr_irqs; idx++) {
@@ -2117,15 +2106,17 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		ret =3D devm_request_irq(hba->dev, qi[idx].irq, ufs_qcom_mcq_esi_handler=
,
 				       IRQF_SHARED, "qcom-mcq-esi", qi + idx);
 		if (ret) {
-			dev_err(hba->dev, "%s: Fail to request IRQ for %d, err =3D %d\n",
+			dev_err(hba->dev, "%s: Failed to request IRQ for %d, err =3D %d\n",
 				__func__, qi[idx].irq, ret);
-			qi[idx].irq =3D 0;
+			/* Free previously allocated IRQs */
+			for (int j =3D 0; j < idx; j++)
+				devm_free_irq(hba->dev, qi[j].irq, qi + j);
+			platform_device_msi_free_irqs_all(hba->dev);
+			devm_kfree(hba->dev, qi);
 			return ret;
 		}
 	}
=20
-	retain_and_null_ptr(qi);
-
 	if (host->hw_ver.major >=3D 6) {
 		ufshcd_rmwl(hba, ESI_VEC_MASK, FIELD_PREP(ESI_VEC_MASK, MAX_ESI_VEC - 1)=
,
 			    REG_UFS_CFG3);
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index b39239f641f2..b87e03777395 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -630,6 +630,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] =3D =
{
 	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4D47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
=20

