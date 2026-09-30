Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4917E3B47F3
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 05:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790747108; cv=none; b=ZGZhYyToamoHn0qZ0r/OdGzwnfdPzMTiiuazbQGVTzzV6O+LHzJkWwMGwALI2WmC0u9DZ3Up7KYo+899+7LkWE0I+QYJlSzi3XSwkxtcfgYcKeAyqZvrulbn1t3ddSBYu0IzeEkw2ZcvJN1SBfSZ3cUHcDCsVydnZ6+A6kFxApw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790747108; c=relaxed/simple;
	bh=JC9Rhdr3UCTIEM64GLfW4866UHJeoGlzKo8+dOjr79w=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=ogZwyNa1eX8Gzpc4ezJo74JOPkfTncquJZQtLI9HVjugaxicxrvFnfzzKldzHN1JacGmgCrI0wD+s88Do4g10A9opLftq8hmtjEIuJ+p9FK+YwGQW/ljlPuRDMmZ4umMXnvKMC5ZSZcYq1x/AnYVggskfOBk22eJ3vQ0TS0s+q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tAbs/g+i; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tAbs/g+i"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260930054503epoutp020f348d09100f7d26a92ada4b817cddaf~aAwCpgA8s0099800998epoutp02a
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 05:45:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260930054503epoutp020f348d09100f7d26a92ada4b817cddaf~aAwCpgA8s0099800998epoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790747103;
	bh=zx6U4Qld795H00UpRJO+9AfDMx8Y4SIyOEVUeCLlMf0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=tAbs/g+ivxdAfZesNzZYjQSxSaWPzG4cuh58drzzZWJ6G8npr5v6ByZn8yWRa/T7O
	 sUsXg/I9HTZn+t8hm2tIhDe7bNRk4R1sM/onWkJbvwHqB3FAPNZZqYPoeMA/KVLKUl
	 9D/b5NMfSaQZMuImAh4i2Qqb9SvnaXkoDo3Ah/5E=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260930054502epcas2p3d36f6615f21c280893f58585962b3710~aAwCIrklB1019010190epcas2p3w;
	Wed, 30 Sep 2026 05:45:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hvkXG4SgFz6B9m7; Wed, 30 Sep
	2026 05:45:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2 2/2] scsi: ufs: Serve the device init reads from one
 aggregated read
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
Date: Wed, 30 Sep 2026 14:18:25 +0900
X-CMS-MailID: 20260930051825epcms2p26140c8bfc4d4e349f649026d52ec565a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260930050201epcms2p13ab67182445b0555acc8d27b927cda86
References: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
	<CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p2>

Device init reads several attributes and flags one query at a time. On
UFS 5.0, issue one AGGREGATED READ once the device descriptor has
established wSpecVersion, cache the reply, and serve the following
attribute, flag and ID-string reads from it. Anything not present, and
older devices or a rejected opcode, fall back to individual queries.

The following per-item queries are folded into the one aggregated read:

Attributes (ALL_ATTRS group)
	0x0c bMaxNumOfRTT                  - ufshcd_set_rtt()
	0x17 bRefClkGatingWaitTime         - ufshcd_get_ref_clk_gating_wait()
	0x1e bWriteBoosterBufferLifeTimeEst - ufshcd_wb_probe()

Flags (ALL_FLAGS group)
	0x03 fPowerOnWPEn                  - ufshcd_device_params_init()

Strings (STRING_DESC groups)
	Product Name string                - ufs_get_device_desc()
	Serial Number string               - ufshcd_create_device_id()

(bWriteBoosterBufferLifeTimeEst is served from the packet only in the
shared-buffer mode)

Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 357 ++++++++++++++++++++++++++++++++++++--
 include/ufs/ufs.h         |   3 +
 include/ufs/ufshcd.h      |   9 +
 3 files changed, 351 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d07834fc4646..e4135d4a5812 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3792,6 +3792,314 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 	return err;
 }
 
+/* Attribute data width by IDN for aggregated read (JESD220H Table 14.28). */
+static const u8 ufs_agg_attr_width[] = {
+	[QUERY_ATTR_IDN_BOOT_LU_EN] = 1, [QUERY_ATTR_IDN_POWER_MODE] = 1,
+	[QUERY_ATTR_IDN_ACTIVE_ICC_LVL] = 1, [QUERY_ATTR_IDN_OOO_DATA_EN] = 1,
+	[QUERY_ATTR_IDN_BKOPS_STATUS] = 1, [QUERY_ATTR_IDN_PURGE_STATUS] = 1,
+	[QUERY_ATTR_IDN_MAX_DATA_IN] = 1, [QUERY_ATTR_IDN_MAX_DATA_OUT] = 1,
+	[QUERY_ATTR_IDN_DYN_CAP_NEEDED] = 4, [QUERY_ATTR_IDN_REF_CLK_FREQ] = 1,
+	[QUERY_ATTR_IDN_CONF_DESC_LOCK] = 1, [QUERY_ATTR_IDN_MAX_NUM_OF_RTT] = 1,
+	[QUERY_ATTR_IDN_EE_CONTROL] = 2, [QUERY_ATTR_IDN_EE_STATUS] = 2,
+	[QUERY_ATTR_IDN_SECONDS_PASSED] = 4, [QUERY_ATTR_IDN_CNTX_CONF] = 2,
+	[QUERY_ATTR_IDN_FFU_STATUS] = 1, [QUERY_ATTR_IDN_PSA_STATE] = 1,
+	[QUERY_ATTR_IDN_PSA_DATA_SIZE] = 4,
+	[QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME] = 1,
+	[QUERY_ATTR_IDN_CASE_ROUGH_TEMP] = 1, [QUERY_ATTR_IDN_HIGH_TEMP_BOUND] = 1,
+	[QUERY_ATTR_IDN_LOW_TEMP_BOUND] = 1, [0x1b] = 1,
+	[QUERY_ATTR_IDN_WB_FLUSH_STATUS] = 1,
+	[QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE] = 1,
+	[QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST] = 1,
+	[QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE] = 4,
+};
+
+/**
+ * ufshcd_agg_group - find a group in the cached aggregated data packet
+ * @hba: per-adapter instance
+ * @type: group type to find
+ * @group_len: set to the group payload length on a hit
+ *
+ * Return: the group payload, or NULL if @type is not present.
+ */
+static const u8 *ufshcd_agg_group(const struct ufs_hba *hba, u8 type,
+				  u16 *group_len)
+{
+	const u8 *packet = hba->agg_packet;
+	u16 packet_len = hba->agg_packet_len;
+	u16 group_off = 0;
+
+	while (packet && group_off + QUERY_AGG_GROUP_HDR_SIZE <= packet_len) {
+		const struct utp_agg_group_header *hdr =
+			(const void *)(packet + group_off);
+		u16 next_group_off = be16_to_cpu(hdr->next_group_offset);
+		u16 payload_off = group_off + QUERY_AGG_GROUP_HDR_SIZE;
+
+		if (next_group_off && (next_group_off < payload_off ||
+				       next_group_off + QUERY_AGG_GROUP_HDR_SIZE > packet_len))
+			return NULL;
+
+		if (hdr->group_type == type) {
+			*group_len = (next_group_off ? next_group_off : packet_len) -
+				     payload_off;
+			return packet + payload_off;
+		}
+
+		if (!next_group_off)
+			break;
+
+		group_off = next_group_off;
+	}
+
+	return NULL;
+}
+
+/**
+ * ufshcd_agg_string - find a string descriptor in the cached aggregated packet
+ * @hba: per-adapter instance
+ * @index: string descriptor index
+ * @len: set to the descriptor length on a hit
+ *
+ * Return: the string descriptor, or NULL if not present.
+ */
+static const u8 *ufshcd_agg_string(struct ufs_hba *hba, u8 index, u8 *len)
+{
+	u16 group_len;
+	const u8 *group_buf;
+	int i;
+
+	if (!index)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(hba->agg_str_idx); i++)
+		if (hba->agg_str_idx[i] == index)
+			break;
+
+	if (i == ARRAY_SIZE(hba->agg_str_idx))
+		return NULL;
+
+	group_buf = ufshcd_agg_group(hba, UFS_AGG_GROUP_MANUFACTURER_STR + i,
+				     &group_len);
+	if (!group_buf || group_len < QUERY_DESC_HDR_SIZE)
+		return NULL;
+
+	*len = group_buf[QUERY_DESC_LENGTH_OFFSET];
+	if (*len < QUERY_DESC_HDR_SIZE || *len > group_len)
+		return NULL;
+
+	return group_buf;
+}
+
+/**
+ * ufshcd_agg_desc - find a descriptor in the cached aggregated data packet
+ * @hba: per-adapter instance
+ * @idn: descriptor IDN
+ * @index: unit index, for unit descriptors; string index for string ones
+ * @len: set to the descriptor length on a hit
+ *
+ * Return: the descriptor, or NULL if not present.
+ */
+static const u8 *ufshcd_agg_desc(struct ufs_hba *hba, enum desc_idn idn,
+				 u8 index, u8 *len)
+{
+	u16 group_len, off = 0;
+	const u8 *group_buf;
+
+	if (idn == QUERY_DESC_IDN_STRING)
+		return ufshcd_agg_string(hba, index, len);
+
+	group_buf = ufshcd_agg_group(hba, UFS_AGG_GROUP_DESCS, &group_len);
+	while (group_buf && off + QUERY_DESC_HDR_SIZE <= group_len) {
+		const u8 *desc_buf = group_buf + off;
+		u8 desc_len = desc_buf[QUERY_DESC_LENGTH_OFFSET];
+
+		if (desc_len < QUERY_DESC_HDR_SIZE || off + desc_len > group_len)
+			break;
+
+		if (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] == idn &&
+		    (idn != QUERY_DESC_IDN_UNIT ||
+		     (desc_len > UNIT_DESC_PARAM_UNIT_INDEX &&
+		      desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] == index))) {
+			*len = desc_len;
+			return desc_buf;
+		}
+
+		off += desc_len;
+	}
+
+	return NULL;
+}
+
+/**
+ * ufshcd_agg_attr - read an attribute from the cached aggregated data packet
+ * @hba: per-adapter instance
+ * @idn: attribute IDN (index 0 only)
+ * @out: set to the value on a hit
+ *
+ * Return: 0 on a hit, -ENOENT otherwise.
+ */
+static int ufshcd_agg_attr(struct ufs_hba *hba, u8 idn, u32 *out)
+{
+	u16 group_len, off = 0;
+	const u8 *group_buf;
+	int i;
+
+	if (idn >= ARRAY_SIZE(ufs_agg_attr_width) || !ufs_agg_attr_width[idn])
+		return -ENOENT;
+
+	group_buf = ufshcd_agg_group(hba, UFS_AGG_GROUP_ATTRS, &group_len);
+	if (!group_buf)
+		return -ENOENT;
+
+	for (i = 0; i < idn; i++)
+		off += ufs_agg_attr_width[i];
+
+	if (off + ufs_agg_attr_width[idn] > group_len)
+		return -ENOENT;
+
+	*out = 0;
+	for (i = 0; i < ufs_agg_attr_width[idn]; i++)
+		*out = (*out << 8) | group_buf[off + i];
+
+	return 0;
+}
+
+/**
+ * ufshcd_agg_flag - read a flag from the cached aggregated data packet
+ * @hba: per-adapter instance
+ * @idn: flag IDN
+ * @out: set to the value on a hit
+ *
+ * Return: 0 on a hit, -ENOENT otherwise.
+ */
+static int ufshcd_agg_flag(struct ufs_hba *hba, u8 idn, bool *out)
+{
+	u16 group_len;
+	const u8 *group_buf = ufshcd_agg_group(hba, UFS_AGG_GROUP_FLAGS,
+					       &group_len);
+
+	if (!group_buf || idn >= group_len)
+		return -ENOENT;
+
+	*out = group_buf[idn];
+	return 0;
+}
+
+/**
+ * ufshcd_read_attr - read an attribute, from the cached packet if present
+ * @hba: per-adapter instance
+ * @idn: attribute IDN
+ * @index: attribute index
+ * @out: result
+ *
+ * Return: 0 on success, < 0 on error.
+ */
+static int ufshcd_read_attr(struct ufs_hba *hba, u8 idn, u8 index, u32 *out)
+{
+	if (index == 0 && !ufshcd_agg_attr(hba, idn, out))
+		return 0;
+
+	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn,
+				       index, 0, out);
+}
+
+/**
+ * ufshcd_read_flag - read a flag, from the cached packet if present
+ * @hba: per-adapter instance
+ * @idn: flag IDN
+ * @out: result
+ *
+ * Return: 0 on success, < 0 on error.
+ */
+static int ufshcd_read_flag(struct ufs_hba *hba, u8 idn, bool *out)
+{
+	if (!ufshcd_agg_flag(hba, idn, out))
+		return 0;
+
+	return ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG, idn, 0,
+				       out);
+}
+
+/**
+ * ufshcd_query_aggregated_read - issue an AGGREGATED READ query
+ * @hba: per-adapter instance
+ * @agg_type: AGGREGATION TYPE mask (OSF) selecting the items to fetch
+ * @buf: buffer for the reply data segment
+ * @buf_len: requested length in, received length out
+ *
+ * Return: 0 on success; > 0 on an OCS error; < 0 otherwise.
+ */
+static int ufshcd_query_aggregated_read(struct ufs_hba *hba, u8 agg_type,
+					u8 *buf, int *buf_len)
+{
+	struct ufs_query_req *request = NULL;
+	struct ufs_query_res *response = NULL;
+	int err;
+
+	if (*buf_len <= 0 || *buf_len > QUERY_AGGREGATED_MAX_SIZE)
+		return -EINVAL;
+
+	ufshcd_dev_man_lock(hba);
+	ufshcd_init_query(hba, &request, &response,
+			  UPIU_QUERY_OPCODE_AGGREGATED_READ, agg_type, 0, 0);
+	request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+	request->upiu_req.length = cpu_to_be16(*buf_len);
+	hba->dev_cmd.query.descriptor = buf;
+
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
+	if (!err)
+		*buf_len = response->data_segment_length;
+
+	hba->dev_cmd.query.descriptor = NULL;
+	ufshcd_dev_man_unlock(hba);
+	return err;
+}
+
+/**
+ * ufshcd_agg_read_begin - cache one AGGREGATED READ for the reads that follow
+ * @hba: per-adapter instance
+ * @agg_type: AGGREGATION TYPE mask to fetch
+ *
+ * Paired with ufshcd_agg_read_end(). Requires a UFS 5.0 device.
+ */
+static void ufshcd_agg_read_begin(struct ufs_hba *hba, u8 agg_type)
+{
+	int len = QUERY_AGGREGATED_MAX_SIZE;
+	int retries;
+	u8 *packet;
+
+	if (hba->dev_info.wspecversion < 0x500 ||
+	    hba->dev_info.agg_read_unsupported)
+		return;
+
+	/* Zeroed so a device over-reporting LENGTH terminates the walk safely. */
+	packet = kzalloc(QUERY_AGGREGATED_MAX_SIZE, GFP_KERNEL);
+	if (!packet)
+		return;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		if (!ufshcd_query_aggregated_read(hba, agg_type, packet, &len))
+			break;
+	}
+
+	if (!retries) {
+		dev_dbg(hba->dev, "aggregated read unsupported, using individual queries\n");
+		hba->dev_info.agg_read_unsupported = true;
+		kfree(packet);
+		return;
+	}
+
+	hba->agg_packet = packet;
+	hba->agg_packet_len = len;
+}
+
+/* ufshcd_agg_read_end - drop the packet cached by ufshcd_agg_read_begin() */
+static void ufshcd_agg_read_end(struct ufs_hba *hba)
+{
+	kfree(hba->agg_packet);
+	hba->agg_packet = NULL;
+	hba->agg_packet_len = 0;
+}
+
 /**
  * ufshcd_read_desc_param - read the specified descriptor parameter
  * @hba: Pointer to adapter instance
@@ -3813,6 +4121,8 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 {
 	int ret;
 	u8 *desc_buf;
+	const u8 *descp;
+	u8 desc_len;
 	int buff_len = QUERY_DESC_MAX_SIZE;
 	bool is_kmalloc = true;
 
@@ -3830,14 +4140,20 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		is_kmalloc = false;
 	}
 
-	/* Request for full descriptor */
-	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
-					    desc_id, desc_index, 0,
-					    desc_buf, &buff_len);
-	if (ret) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d\n",
-			__func__, desc_id, desc_index, param_offset, ret);
-		goto out;
+	/* Serve from the cached aggregated packet, else request the full one. */
+	descp = ufshcd_agg_desc(hba, desc_id, desc_index, &desc_len);
+	if (descp) {
+		memcpy(desc_buf, descp, desc_len);
+		ret = 0;
+	} else {
+		ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+						    desc_id, desc_index, 0,
+						    desc_buf, &buff_len);
+		if (ret) {
+			dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d\n",
+				__func__, desc_id, desc_index, param_offset, ret);
+			goto out;
+		}
 	}
 
 	/* Update descriptor length */
@@ -4019,9 +4335,8 @@ static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
 	u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
 
 	if (hba->dev_info.wspecversion >= 0x300) {
-		err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-				QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME, 0, 0,
-				&gating_wait);
+		err = ufshcd_read_attr(hba, QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME,
+				       0, &gating_wait);
 		if (err)
 			dev_err(hba->dev, "Failed reading bRefClkGatingWait. err = %d, use default %uus\n",
 					 err, gating_wait);
@@ -6531,9 +6846,8 @@ static bool ufshcd_is_wb_buf_lifetime_available(struct ufs_hba *hba)
 	u8 index;
 
 	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-				      QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST,
-				      index, 0, &lifetime);
+	ret = ufshcd_read_attr(hba, QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST,
+			       index, &lifetime);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: bWriteBoosterBufferLifeTimeEst read failed %d\n",
@@ -8677,8 +8991,7 @@ static void ufshcd_set_rtt(struct ufs_hba *hba)
 	if (dev_info->wspecversion < 0x400)
 		return;
 
-	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-				    QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &dev_rtt)) {
+	if (ufshcd_read_attr(hba, QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, &dev_rtt)) {
 		dev_err(hba->dev, "failed reading bMaxNumOfRTT\n");
 		return;
 	}
@@ -8899,6 +9212,14 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
 	dev_info->bqueuedepth = desc_buf[DEVICE_DESC_PARAM_Q_DPTH];
 
+	hba->agg_str_idx[0] = desc_buf[DEVICE_DESC_PARAM_MANF_NAME];
+	hba->agg_str_idx[1] = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
+	hba->agg_str_idx[2] = desc_buf[DEVICE_DESC_PARAM_OEM_ID];
+	hba->agg_str_idx[3] = desc_buf[DEVICE_DESC_PARAM_SN];
+	hba->agg_str_idx[4] = desc_buf[DEVICE_DESC_PARAM_PRDCT_REV];
+	ufshcd_agg_read_begin(hba, UFS_AGG_TYPE_ALL_ATTRS | UFS_AGG_TYPE_ALL_FLAGS |
+			      UFS_AGG_TYPE_STRING_DESC);
+
 	/*
 	 * According to the UFS standard, the UFS device queue depth
 	 * (bQueueDepth) must be in the range 1..255 if the shared queueing
@@ -9214,8 +9535,7 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 
 	ufshcd_get_ref_clk_gating_wait(hba);
 
-	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_PWR_ON_WPE, 0, &flag))
+	if (!ufshcd_read_flag(hba, QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 		hba->dev_info.f_power_on_wp_en = flag;
 
 	/* Probe maximum power mode co-supported by both UFS host and device */
@@ -9226,6 +9546,7 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 
 	ufshcd_retrieve_tx_eq_settings(hba);
 out:
+	ufshcd_agg_read_end(hba);
 	return ret;
 }
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 1e6ea87a5dc7..e29552d6acc2 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -707,6 +707,9 @@ struct ufs_dev_info {
 
 	bool hid_sup;
 
+	/* Set once the device has rejected an AGGREGATED READ query. */
+	bool agg_read_unsupported;
+
 	/* Unique device ID string (manufacturer+model+serial+version+date) */
 	char *device_id;
 	u8 rpmb_io_size;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1a5e181ff9e3..53a7573890cd 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1098,6 +1098,10 @@ enum ufshcd_mcq_opr {
  * @device_deemphasis_cap: a bitfield to indicate supported DeEmphasis dBs of device's TX lanes,
  *	cache of device M-PHY TX_HS_DeEmphasis_Setting_Capability Attribute (ID 0x12)
  * @tx_eq_params: TX Equalization settings
+ * @agg_packet: aggregated data packet cached during a read batch, or NULL
+ * @agg_packet_len: length of @agg_packet
+ * @agg_str_idx: string descriptor index per string group, indexed by
+ *	group type - UFS_AGG_GROUP_MANUFACTURER_STR
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1282,6 +1286,11 @@ struct ufs_hba {
 	u8 device_preshoot_cap;
 	u8 device_deemphasis_cap;
 	struct ufshcd_tx_eq_params tx_eq_params[UFS_HS_GEAR_MAX];
+
+	u8 *agg_packet;
+	u16 agg_packet_len;
+	u8 agg_str_idx[UFS_AGG_GROUP_PRODUCT_REV_STR -
+		       UFS_AGG_GROUP_MANUFACTURER_STR + 1];
 };
 
 /**
-- 
2.25.1

