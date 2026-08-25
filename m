Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8638223EAAF
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787628618; cv=none; b=ASl51H5wMhY5JZ52YBpwASQuvStbyZqmYKZVKrVZ496OY2szDsQfwy1+P0N+b+ZYm3szvraNE4KB06JEmLt12zXKnM98kOFO0ToroFQz9iNWe9e5H8RNO0r7o421rEYm8LSRg7OtKv3kQbUQeDJ4GNmdOh2lN7rQUxwPocLLCEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787628618; c=relaxed/simple;
	bh=2AhcLjrsIzdCHr80T9Irqs7JkoGtT/A/4BaDwo9EtJc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=B4wAnUrAn7HCsWLYqdS1V3T1y1BvvEzCB3bUfrRzphBwnRf7maXu1IGUPSostiBk2FgdF+e1HeX8ObmDO3fIFUTw4TguAs3DZZWMJU+aFaajoPbS8XJUCMtGo8p6ycgbOZ8VptHIZX1XCLDopDLhe1Y1NHbeb1/vY4ugFUquxL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUMnoaIL; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUMnoaIL"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so5954870e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 20:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787628614; x=1788233414; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/5OOFU01Ir/Kr+JNPLWPtPKMHKr+x+zQ9G28y7INQ50=;
        b=BUMnoaILW6MgBU4vnHg0dEwVKjSjznRVAjKr2A9Wdl/L6D0k/tOGO8AUpMmsPWWW3z
         +ozzbO5L78fkRXgFQ2V92csXhuC8eTycTMKPsM8nWnB1KNLweA5g1VabBi7vhd+RS0tH
         rfBcNrpdTiPt7TidS2XM3BenYovdkg5DDLEmLMyOl9M802KK82i3UUdJR4DTtlJAdJRt
         JAd5dYCNQh5Ju+nq9wwmjFfgWzvPONhQW93jdpRK6hhOa/bhcs4gsl4Wgv9IUS/UHxDo
         eceeUfdE68bBNRZginFKwAuOoCaEtKWbhosB/KXdW8MINa9a8Q8S2qNw9R4ARCgGJMK4
         Clbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787628614; x=1788233414;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/5OOFU01Ir/Kr+JNPLWPtPKMHKr+x+zQ9G28y7INQ50=;
        b=ATgwSBzF9wNTEYAVdr+gXYpbatElbtlBqHQDlcR1pih5fti3rtCoB25LH4/tD7SrB+
         T+BWnSPHZcZB1dx0NOhSjk9leZsKPJJno52uqwV6v6GEEpXv3l6RHt8iT2QPmGQ7m2ZF
         A0wfe3Di4OsrGrPcPy+Sg8wZq7e5Rt7kqamTMKT/RuqBDF8nk8W5m0NvQOAf1p9PSGvN
         LsnQrjEKUbC6HA+/8xHLN4r+/MwlkhF1gGB8vtTTSPYcs9Kr1NYIZFn9+sF+N/zApscq
         fnFQN10/n4eIp+gn6Vwuyle3DPg3tGGR2tNZnhgnAykmWLn3XMhLqv9W8Yd5+krgBhAJ
         n0nQ==
X-Gm-Message-State: AFuF++k9jfUWrFtj3I8niYRQn1PFJWfUmPBET0jAWAcTp+WuKbPKZxxF
	OQjrowNNoOlRZdX7JOaWRIWhiEzsYD9AOjm42sak54cWaSJy1rVTI2cfqoOyOA==
X-Gm-Gg: AR+sD10lBj2MPRjJKmrH8MMWfcaaHzg1lKhHq7sE52dk2WilLcoyTxAMTh151Y/Muvd
	0u4WYO2enJZsHJ4HpynNHZdqapVtauk8GSCOi9G0BgpBOkRx7xnNyDRBQtQVzI6eSdoGz4gt2+R
	U2ZhrASZZ3ZtHp1ebtvXdzjP/IoNNyN3Cz+cdf809LExU9G5FpoP6QVmo1eC5dUCoD3BZzbzbNO
	niiINX3UZS9vEOW+g6A4Sv5eaJhY6g8PEFOzPm/0Tsyqkspkx+/u1ZLt5a8Q6k/g4PFRxR09987
	nliBuThM26xtCGPULvgYH/+p/MMnDDNumLz4k6sryDG+uFOlS8bkNUOE3XXgPg7U1Ibtzlrz/qc
	Pq2I40Sgq8K8Ax4C3ihvwWPCwPr++s0Wc1WzNqVv6Ob9wa4aE1LlPlpqf061rg9l/WZT/V5Huso
	Vcxuj76vm5YVR76StaNt18xv6vZliIbIE25yRlmwG9VJJpQH/REZsx4PjToKpy9fwiDxtLK8FJ5
	VJG6JXipg==
X-Received: by 2002:a05:6512:834a:b0:5b4:7795:8abb with SMTP id 2adb3069b0e04-5b4841f3e21mr7234892e87.7.1787628614267;
        Mon, 24 Aug 2026 20:30:14 -0700 (PDT)
Received: from [192.168.243.250] ([94.229.16.221])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b48cd9ab35sm2179799e87.3.2026.08.24.20.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 20:30:13 -0700 (PDT)
From: Nikolay Kulikov <nikolayof23@gmail.com>
Date: Tue, 25 Aug 2026 06:30:07 +0300
Subject: [PATCH] scsi: csiostor: remove 'state' parameter from
 csio_do_hello()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-scsi_csio_state-v1-1-34921cc9e879@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ5AMBCF4avIrDWpRqRcRUQYU8YC6ZRIxN0Vi
 7f4Fu+/QMgzCVTJBZ4OFl6XiCxNAKduGUnxEA1Gm0JbkytB4TZubSV0gZRFzAarHTpbQnxtnhy
 fX7Fufsvez4ThzcB9P9T0ySBzAAAA
X-Change-ID: 20260824-scsi_csio_state-8cc1d80fcf89
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Nikolay Kulikov <nikolayof23@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787628612; l=3254;
 i=nikolayof23@gmail.com; s=20260402; h=from:subject:message-id;
 bh=2AhcLjrsIzdCHr80T9Irqs7JkoGtT/A/4BaDwo9EtJc=;
 b=sGg2zLKY1Hoif8Rn0H1I7WlXPxHZk0Z/jViXqu0AA2oieTwe2rZo+7bkcu6O1vrfnSGoHqIG4
 4L0yrb03pEBC/i8Ksa/pEJRLIWBLOSm/9hDTELMO3meeJelhREjpjoD
X-Developer-Key: i=nikolayof23@gmail.com; a=ed25519;
 pk=2GWUU1isl5NJpkwSCQ4OG80EinZ3EUZXlrgAg6Pz5zI=

At the single call site, the 'state' parameter holds the address of the
'hw->fw_state' field. However, the csio_do_hello() also receives a
pointer to 'hw', so use that field directly to avoid unnecessary pointer
check.

Detected by Smatch:
drivers/scsi/csiostor/csio_hw.c:1007 csio_do_hello()
	warn: variable dereferenced before check 'state' (see line 954)

Signed-off-by: Nikolay Kulikov <nikolayof23@gmail.com>
---
 drivers/scsi/csiostor/csio_hw.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index df9f81f29950..ea3775161d7b 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -908,12 +908,11 @@ csio_hw_dev_ready(struct csio_hw *hw)
 /*
  * csio_do_hello - Perform the HELLO FW Mailbox command and process response.
  * @hw: HW module
- * @state: Device state
  *
  * FW_HELLO_CMD has to be polled for completion.
  */
 static int
-csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
+csio_do_hello(struct csio_hw *hw)
 {
 	struct csio_mb	*mbp;
 	int	rv = 0;
@@ -941,7 +940,7 @@ csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
 		goto out_free_mb;
 	}
 
-	csio_mb_process_hello_rsp(hw, mbp, &retval, state, &mpfn);
+	csio_mb_process_hello_rsp(hw, mbp, &retval, &hw->fw_state, &mpfn);
 	if (retval != FW_SUCCESS) {
 		csio_err(hw, "HELLO cmd failed with ret: %d\n", retval);
 		rv = -EINVAL;
@@ -951,7 +950,7 @@ csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
 	/* Firmware has designated us to be master */
 	if (hw->pfn == mpfn) {
 		hw->flags |= CSIO_HWF_MASTER;
-	} else if (*state == CSIO_DEV_STATE_UNINIT) {
+	} else if (hw->fw_state == CSIO_DEV_STATE_UNINIT) {
 		/*
 		 * If we're not the Master PF then we need to wait around for
 		 * the Master PF Driver to finish setting up the adapter.
@@ -1004,12 +1003,11 @@ csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
 			 * We either have an Error or Initialized condition
 			 * report errors preferentially.
 			 */
-			if (state) {
-				if (pcie_fw & PCIE_FW_ERR_F) {
-					*state = CSIO_DEV_STATE_ERR;
-					rv = -ETIMEDOUT;
-				} else if (pcie_fw & PCIE_FW_INIT_F)
-					*state = CSIO_DEV_STATE_INIT;
+			if (pcie_fw & PCIE_FW_ERR_F) {
+				hw->fw_state = CSIO_DEV_STATE_ERR;
+				rv = -ETIMEDOUT;
+			} else if (pcie_fw & PCIE_FW_INIT_F) {
+				hw->fw_state = CSIO_DEV_STATE_INIT;
 			}
 
 			/*
@@ -1025,7 +1023,7 @@ csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
 		hw->flags &= ~CSIO_HWF_MASTER;
 	}
 
-	switch (*state) {
+	switch (hw->fw_state) {
 	case CSIO_DEV_STATE_UNINIT:
 		strcpy(state_str, "Initializing");
 		break;
@@ -2511,7 +2509,7 @@ csio_hw_configure(struct csio_hw *hw)
 
 	csio_hw_print_fw_version(hw, "Firmware revision");
 
-	rv = csio_do_hello(hw, &hw->fw_state);
+	rv = csio_do_hello(hw);
 	if (rv != 0) {
 		CSIO_INC_STATS(hw, n_err_fatal);
 		csio_post_event(&hw->sm, CSIO_HWE_FATAL);

---
base-commit: 12e67eb89eb2b9516685c744d3f7de0a2d1bd701
change-id: 20260824-scsi_csio_state-8cc1d80fcf89

Best regards,
--  
Nikolay Kulikov <nikolayof23@gmail.com>

