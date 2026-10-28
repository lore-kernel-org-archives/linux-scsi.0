Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793192075;
	b=EjWnqCxm6eqa99cacdUO4gO1wk9rlo4N++t9Cj1VwtW/XmzYgeoUktbyJnUVOAoEVcNc
	 EGJsZN8FbHlGzzPaAhz5SjU3N161Gphb5jHJwvbYkIXm4sdqs4gSJYfakMkrGrjdZk8kk
	 N5EWGmTQYa1h/jfX4JD6fM1upzjOIXNrZqPTsPVnz+WNzeiQZUJgVgpoouHbcdIglmNxM
	 uZS8VHy9ImDx3uQWtZtotmScw/dAQgxVPt8Ins/PkdQL3KpPIhoPYypII810bw0P4wrWm
	 qKzauZYW4Uni13vT2yb5kg9FDnvrW5W3Ycom9TkiI6dm8IkPc+fdQpKXScc04CbL5/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793192075;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=tu+eO7nns4BvX7b+E6s7tzt+Km0pkqqyKwMsHmrLMZU=;
	b=SqkJJWvetnJI1nkvcb8XRiWgfashsN8aFpWInpy+XlqFQ81c8uMJA9+CToABWfY8/Enj
	 GcuDiVAb5VDGXC9eb36i9WNK7WI0rbdkBgEWwFZXRBiypSvGwRJXzZ+xWCGxtrf9RIJP+
	 dG5SMsNV+UrrMqbiuCVrFRc+7fGAaNFYAyqCa+kkYfs9kQmg4MjELKwANFtj1WeCRBCSr
	 q0XrvyOal7DN6MgvMrvNJ8gh6u9CqSd4bGukKLzjHaJEU63WJXJSmvm4EKSR584GgZqWm
	 V82HBkxD6/0q6Mgvqarj6X+PjMsuyQmvjja0Uu6IEJMGkLmbb2kkmCkTuCssxfBEzRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=GXHOL+aQ;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC742606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:54:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC742606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=GXHOL+aQ
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so7072055e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793192073; x=1793796873; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tu+eO7nns4BvX7b+E6s7tzt+Km0pkqqyKwMsHmrLMZU=;
        b=GXHOL+aQECScglN9UHqIcLF0jV1XLQEOWn/xcKV1iZwzGUqpi2uDEuGDyf2i6aDXxO
         5xgVY5LkDib0Vi/k/1vQ2jccuvT3JNFwfPCnpvUeBcmi6d9OWLL6ATcjx4pPUiTy+1A0
         RQ9NLOgfwNz32MhdGpBEX5BcQ4sHcLhd3zKcTWCrV0jm3FQI7qXBujnkqNfkwkaMVKhQ
         Ve9GAnjvPvFfVvFLiVq4viKvUrVFW6Wr7iTKF+bE0g4iBrASk17wWP1ycOMLbBB9z8Es
         BR/o3DpYZXXFL8o2J11YZ8VejmaGGFbq+Uc3vjfFHm6ispzTNAxPH5XN1n9v/AumHJq1
         QtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793192073; x=1793796873;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=tu+eO7nns4BvX7b+E6s7tzt+Km0pkqqyKwMsHmrLMZU=;
        b=OX8DGy654aoyXdSGEEMTA4j7ll+yd2KL2WqVi07e85S9PPLe513SzYl00Lf1WHoy6S
         WUM49yvlu1kysbk57raoKWc5a+gZlN/ZZVHz+wAgDtp8AlHA34bgEmoSUvuwTFJJ8MkW
         Bk8YOvn4mMbi9QX0H7NqCtIm7AJyCfQbkoeRokZ5uX/52lZhQx3mgAAGeL/+fBafKLLn
         rnhQO7KBQTVDpgBNa1aJV8bgp9fRzbwvhqrTCLFDMDUNOwYbRA8cBUeFeFsp5vTZigqL
         lmJ+MDwJAA1MW1Rky3bfmk7o3cQNb2+2/WAnGg2hRZctMS1SaZJEs9s38a+PK8p95Dkd
         YbWA==
X-Gm-Message-State: AFq9FYKtEVXtKXHugfyKWrg2tT3bijYd/Ieex4oc/EUGX50u1q1YUsXQ
	iCz5sDyN36C5o1BF8t9B6LN4txfO/H9q/SbuUYnV5sE4ZBUzyQMaEZbgeVQhbucGFak=
X-Gm-Gg: AYBFou3NiOL6HGlZEYg5fw7JhbE2GPFZsQ+pmwyjmrIJ/JKy50eSmTZUsN55SSOSBGo
	YNaOd5TDkaJyh7fTC/EK6vyPs1x9dZgw70SgDDCT9OBb6QGYeAcM939fH1T+3YY31FTY6lSw1jE
	qruiNSOXMnMw8kajvUxQms3QybWd5+z2KxsYHQyqw4gh+FoUXFKuPRctDHpXyGNXpzEKfH/C+5Y
	ZoYI2qwL/399n2ndoljPCSKAOMYynrYMLev6opL5oZ0t2zbxgW2L6d3+8rCMIdgwuNAEdYUDUI0
	n3/nJcdHZ2RG3FmfaVPVevwi3cugv+oFIIKzBXWrUQCpkMX9OpPP1Cu2OPgPvknsqP1K09uc14W
	ZLm9KMTczEI2lszEj1PAtrNSlGwEC5MwdZdRzCTVvqmqmsZ7Edwm7fU2eTQbHEwIigc/4RWqf3d
	OLUZ06cBnsEBdurtJtZ/JSF+DjPU9JR3/ptzJmP1LLu7HA2Q2uSdZsGkGjkGFGgmPwkMutLYyTQ
	ANoLSsrO5Fy3lBMdCv7sn9acMpYKeRwJTiWlRpMazaA5f35xJFG1nGDSOlnh67QhoP8rPM54CNa
	OECQzo6fLmNv3Qw0/4kByeWoziY1OluG51+x+wH9ofnpFWWi0T7DsmrgkhGCMMseTH70hZS0HPC
	+kxKDUoPfqg==
X-Received: by 2002:a05:600c:3b29:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4a997bfaa4fmr37804585e9.16.1793192072733;
        Wed, 28 Oct 2026 05:54:32 -0700 (PDT)
Received: from alchark-surface.localdomain (bba-86-98-194-229.alshamil.net.ae. [86.98.194.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a97c9f1403sm48686715e9.9.2026.10.28.05.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:54:32 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Date: Wed, 28 Oct 2026 16:54:21 +0400
Subject: [PATCH] scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN
 devices
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyML3aTM8sw83ZLSRN3C0syibF2TNFMT47RkSzNDQzMloK6CotS0zAq
 widGxEH5xaVJWanIJyBil2loAo+aODnMAAAA=
X-Change-ID: 20261028-biwin-tua-quirk-4f543fc96116
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
 Stanley Jhu <stanleyjhu@google.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5556; i=alchark@flipper.net;
 h=from:subject:message-id; bh=sPjc0WbtQP3T5OVtFuZlBHejCL2UFm9D19nKEw6dZCg=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWQ9/NA0Ldb70pnC8pXuSZO15+jePJ/ipcw6gX9XwoalW
 S+iDYyOdUxkYRDjYrAUU2SZ+22J7VQjvlm7PDy+wsxhZQIZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkY6xjpGDFycAjDV6iYM/xO3hJfvvNTOF2Jem9C2frn22SJps2f8J79aVGZFhXwJ/cHI0Nxs7vr
 +e1T3zFWXcyZIXvd/qN757GXy/ZKohicP3X5a8AMA
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

With the link off across suspend (UFS_PM_LVL_5), resume resets the device,
which leaves a power-on UNIT ATTENTION pending on every logical unit. The
SCSI core retries the command that receives it and relies on the device to
clear the condition once reported.

The BIWIN BWU2A0526B128G and BWU2A0516B064G do not clear it when reporting
it to a WRITE. Writes queued across a system suspend then fail on every
retry for the full 180s retry window, until the SCSI error handler's
TEST UNIT READY clears it, and end in I/O errors. A single TEST UNIT READY
or READ clears it. This seems to be limited to the particular BIWIN device
family (with 128GB and 64GB variants exhibiting this behavior), as Samsung
and FORESEE ones I have tested clear it on WRITE as they should.

Add a device quirk that sends a TEST UNIT READY to each logical unit at
the end of ufshcd_host_reset_and_restore(), and enable it for BIWIN
models starting with BWU2A05. That function follows every device reset:
on resume from link off, system or runtime, and in the UFS error
handler, which also carries out the SCSI error handler's host resets.

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 drivers/ufs/core/ufshcd.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 include/ufs/ufs_quirks.h  |  9 ++++++++
 include/ufs/ufshcd.h      |  1 +
 3 files changed, 64 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..d52275a813fd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -321,6 +321,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGJFJT1E45BATP",
 	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
+	{ .wmanufacturerid = UFS_VENDOR_BIWIN,
+	  .model = "BWU2A05",
+	  .quirk = UFS_DEVICE_QUIRK_TUR_TO_CLEAR_UA },
 	{}
 };
 
@@ -8265,6 +8268,55 @@ static void ufshcd_process_probe_result(struct ufs_hba *hba,
 			  hba->curr_dev_pwr_mode, hba->uic_link_state);
 }
 
+/**
+ * ufshcd_clear_unit_attention - clear the power-on UNIT ATTENTION of each LU
+ * @hba: per adapter instance
+ *
+ * Send a TEST UNIT READY to each logical unit to clear the power-on UNIT
+ * ATTENTION left by a device reset, for devices that keep reporting it to
+ * WRITE commands instead. Receiving the UNIT ATTENTION is what clears it, so
+ * only transport failures matter.
+ *
+ * Use the device management slot rather than the logical units' request
+ * queues: those are blocked during error handling, and during a runtime
+ * resume of the device W-LU its runtime suspended consumers cannot take
+ * requests until it has resumed.
+ */
+static void ufshcd_clear_unit_attention(struct ufs_hba *hba)
+{
+	struct utp_upiu_req req_upiu, rsp_upiu;
+	struct scsi_device *sdev;
+	int err;
+
+	shost_for_each_device(sdev, hba->host) {
+		if (scsi_is_wlun(sdev->lun))
+			continue;
+
+		req_upiu = (struct utp_upiu_req){
+			.header = {
+				.transaction_code = UPIU_TRANSACTION_COMMAND,
+				.lun = ufshcd_scsi_to_upiu_lun(sdev->lun),
+				.command_set_type = UPIU_COMMAND_SET_TYPE_SCSI,
+			},
+			.sc.cdb[0] = TEST_UNIT_READY,
+		};
+
+		ufshcd_dev_man_lock(hba);
+		err = ufshcd_issue_devman_upiu_cmd(hba, &req_upiu, &rsp_upiu,
+						   NULL, NULL,
+						   DEV_CMD_TYPE_SCSI,
+						   UPIU_QUERY_OPCODE_NOP);
+		ufshcd_dev_man_unlock(hba);
+		if (err) {
+			dev_warn(hba->dev,
+				 "TEST UNIT READY to LUN %llu failed: %d\n",
+				 sdev->lun, err);
+			scsi_device_put(sdev);
+			break;
+		}
+	}
+}
+
 /**
  * ufshcd_host_reset_and_restore - reset and restore host controller
  * @hba: per-adapter instance
@@ -8306,6 +8358,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
+	else if (hba->dev_quirks & UFS_DEVICE_QUIRK_TUR_TO_CLEAR_UA)
+		ufshcd_clear_unit_attention(hba);
 	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
 	return err;
 }
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index e9c59ec1ceae..74d4ca3badb7 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -17,6 +17,7 @@
 #define UFS_VENDOR_SKHYNIX     0x1AD
 #define UFS_VENDOR_TOSHIBA     0x198
 #define UFS_VENDOR_WDC         0x145
+#define UFS_VENDOR_BIWIN       0xDAB
 
 /**
  * ufs_dev_quirk - ufs device quirk info
@@ -109,4 +110,12 @@ struct ufs_dev_quirk {
 /* Some UFS 4 devices do not support the qTimestamp attribute */
 #define UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT	(1 << 13)
 
+/*
+ * Some UFS devices do not clear the power-on UNIT ATTENTION condition when
+ * reporting it to a WRITE command, so writes keep failing with it. A TEST
+ * UNIT READY clears it. Enable this quirk to send one to each logical unit
+ * after every host reset and restore, which follows each device reset.
+ */
+#define UFS_DEVICE_QUIRK_TUR_TO_CLEAR_UA	(1 << 14)
+
 #endif /* UFS_QUIRKS_H_ */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index be62165b785e..6140798ed128 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -37,6 +37,7 @@ enum dev_cmd_type {
 	DEV_CMD_TYPE_NOP		= 0x0,
 	DEV_CMD_TYPE_QUERY		= 0x1,
 	DEV_CMD_TYPE_RPMB		= 0x2,
+	DEV_CMD_TYPE_SCSI		= 0x3,
 };
 
 enum ufs_event_type {

---
base-commit: 151a134a4e6ec66f69db8750c66006f5207f7a9d
change-id: 20261028-biwin-tua-quirk-4f543fc96116

Best regards,
--  
Alexey Charkov <alchark@flipper.net>

