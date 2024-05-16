Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427C912B83;
	Thu, 16 May 2024 05:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715838702; cv=none; b=n7bULyCC+5o5Z7/MR7Aobl/LjDPvqOBePc74SNtAB5EkmgeKjAnPuMcvQzk4QkiBsJ1xP05wa1IaC7yBsBQ1SwiZqrpye7czGm/9g/29qLeM2PaKt9CeZ9FXqYkp3gH7j1NDbTNaPwkgy2ai++UIOfuJa/7tsjbT6cl4OiMhfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715838702; c=relaxed/simple;
	bh=yTEfkjiq6HIcCZcRbrgbXTOg/XqjS0pAkcG5SfFtZGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkoQzOfCke4ftOKZVhtkm1Y44tIiKQ7TUtMgi7g3/VON/NlB+fsCM6/asjvDRGFVKkwj5pjDNGz/xLjjoqR5rb8oFjjhpYC3kyhqTJk9i+5vCgIoUw6Kan1T/rP32yXfLGFadi2lzimtrrc5yc3fcOBb3U0+2iV1bUVkj1Oze9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aPfD69WI; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aPfD69WI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715838700; x=1747374700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yTEfkjiq6HIcCZcRbrgbXTOg/XqjS0pAkcG5SfFtZGI=;
  b=aPfD69WIH37UZr/YarVzA5PdJDgpesGNeBaflXeDi8ZE6RwlDSIPYt3V
   ihMA8bo74XWm7HWmjwGznd5Df6tE6aSj+1M0YLwvBv4OBVRUuioT1Vv6h
   XWlf0ZlJYGoKDfLcyQ+Ogll+f5XJwW9V74Pov4fvhIDZZQdLZ1vYTxATr
   MvvP1dECq/SmpiB5nelCHAJtXH7GnrWU+XZ32eQoOIeV/U64lMUjWo7Xa
   VBhLWkpLnw+uVYpxv17dGuUQFFEiHm8QuayBe0lF/oakPXSf9PYiGo4CC
   +At1UH6vhvZ8G1RfskP4sKvW7RuWpdZAD8Z9Or8DFf2FBmqB6vqMMZXsF
   g==;
X-CSE-ConnectionGUID: cs26tttiQxm0e904GH8+/g==
X-CSE-MsgGUID: bptpykfMR2a8BPb4Nj5QnA==
X-IronPort-AV: E=Sophos;i="6.08,163,1712592000"; 
   d="scan'208";a="17296238"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 13:51:39 +0800
IronPort-SDR: 66459157_q9iazH+mDcRK3NR82ZTOlb0K7FRW+hm7URsjiS8t1nyIKgn
 rZB6pcOf7rwJ0DstwLL0ocp66ckr+ILE6YtHpNQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 May 2024 21:53:43 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 May 2024 22:51:37 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
Date: Thu, 16 May 2024 08:51:22 +0300
Message-ID: <20240516055124.24490-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240516055124.24490-1-avri.altman@wdc.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rtt-upiu packets precede any data-out upiu packets, thus
synchronizing the data input to the device: this mostly applies to write
operations, but there are other operations that requires rtt as well.

There are several rules binding this rtt - data-out dialog, specifically
There can be at most outstanding bMaxNumOfRTT such packets.  This might
have an effect on write performance (sequential write in particular), as
each data-out upiu must wait for its rtt sibling.

UFSHCI expects bMaxNumOfRTT to be min(bDeviceRTTCap, NORTT). However,
as of today, there does not appears to be no-one who sets it: not the
host controller nor the driver.  It wasn't an issue up to now:
bMaxNumOfRTT is set to 2 after manufacturing, and wasn't limiting the
write performance.

UFS4.0, and specifically gear 5 changes this, and requires the device to
be more attentive.  This doesn't come free - the device has to allocate
more resources to that end, but the sequential write performance
improvement is significant. Early measurements shows 25% gain when
moving from rtt 2 to 9. Therefore, set bMaxNumOfRTT to be
min(bDeviceRTTCap, NORTT) as UFSHCI expects.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd.c | 36 ++++++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h      |  2 ++
 include/ufs/ufshci.h      |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0819ddafe7a6..c472bfdf071e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -102,6 +102,9 @@
 /* Default RTC update every 10 seconds */
 #define UFS_RTC_UPDATE_INTERVAL_MS (10 * MSEC_PER_SEC)
 
+/* bMaxNumOfRTT is equal to two after device manufacturing */
+#define DEFAULT_MAX_NUM_RTT 2
+
 /* UFSHC 4.0 compliant HC support this mode. */
 static bool use_mcq_mode = true;
 
@@ -2405,6 +2408,8 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
 	hba->reserved_slot = hba->nutrs - 1;
 
+	hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities) + 1;
+
 	/* Read crypto capabilities */
 	err = ufshcd_hba_init_crypto_capabilities(hba);
 	if (err) {
@@ -8119,6 +8124,35 @@ static void ufshcd_ext_iid_probe(struct ufs_hba *hba, u8 *desc_buf)
 	dev_info->b_ext_iid_en = ext_iid_en;
 }
 
+static void ufshcd_rtt_set(struct ufs_hba *hba, u8 *desc_buf)
+{
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+	u32 rtt = 0;
+	u32 dev_rtt = 0;
+
+	/* RTT override makes sense only for UFS-4.0 and above */
+	if (dev_info->wspecversion < 0x400)
+		return;
+
+	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				    QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &dev_rtt)) {
+		dev_err(hba->dev, "failed reading bMaxNumOfRTT\n");
+		return;
+	}
+
+	/* do not override if it was already written */
+	if (dev_rtt != DEFAULT_MAX_NUM_RTT)
+		return;
+
+	rtt = min_t(int, desc_buf[DEVICE_DESC_PARAM_RTT_CAP], hba->nortt);
+	if (rtt == dev_rtt)
+		return;
+
+	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				    QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt))
+		dev_err(hba->dev, "failed writing bMaxNumOfRTT\n");
+}
+
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups)
 {
@@ -8278,6 +8312,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	if (hba->ext_iid_sup)
 		ufshcd_ext_iid_probe(hba, desc_buf);
 
+	ufshcd_rtt_set(hba, desc_buf);
+
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bad88bd91995..d74bd2d67b06 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -819,6 +819,7 @@ enum ufshcd_mcq_opr {
  * @capabilities: UFS Controller Capabilities
  * @mcq_capabilities: UFS Multi Circular Queue capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
+ * @nortt - Max outstanding RTTs supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
  * @reserved_slot: Used to submit device commands. Protected by @dev_cmd.lock.
  * @ufs_version: UFS Version to which controller complies
@@ -957,6 +958,7 @@ struct ufs_hba {
 
 	u32 capabilities;
 	int nutrs;
+	int nortt;
 	u32 mcq_capabilities;
 	int nutmrs;
 	u32 reserved_slot;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 385e1c6b8d60..c50f92bf2e1d 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -68,6 +68,7 @@ enum {
 /* Controller capability masks */
 enum {
 	MASK_TRANSFER_REQUESTS_SLOTS		= 0x0000001F,
+	MASK_NUMBER_OUTSTANDING_RTT		= 0x0000FF00,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	= 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			= 0x00400000,
 	MASK_AUTO_HIBERN8_SUPPORT		= 0x00800000,
-- 
2.34.1

