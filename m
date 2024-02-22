Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2B012D1FD
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638349; cv=none; b=NPmWVR3UTa32IinMchUcQ6yEFTC2xkFpajHJ/p+aw8kaLIiiuJfePsRgMJcYuoJvdk+QNH+zydS35aYhdpiJA6pfg2p+gCt92C4pFCOGSkgBvHPiQnN4hVpH6dYuZrDTeVG8X/qgbINm7+Q7E3ID/DH4MZa/1Z8GO6R76DI/Jd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638349; c=relaxed/simple;
	bh=mW+VEHSEMe5NTiO4ammMUexCtbQO4umn8rI2uNjOxkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd0RV57TnYJCeOLQEXh/l8sny4CXJrDRr//fubcfqVyhuu+6Dkad7/Jx+QTCcHc8kUIXlDbegIdsUHBzevnUh0tSgaGvkbu2Yc9Dy/jeITJRy8m2NJP1nRFPiUVVQT8YnJ8bBZw5d6OdSvJxtSKiilO5HzpyjY6UVgmfJLrsvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e34d12404eso86954b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638347; x=1709243147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tbVZNnyK3WhWIR+xZPdP47ThSfpJCvGfnUGz/BJTKu4=;
        b=FHnZyU/1Znv04y59ivlnyc/Jd89A5qeVrrpehah8lfqEnfFAT1GubW34cHPZAbeEcM
         wVWYKLrghoD1Pu1+ladWK4t4t5XRPQTMOnzn2diBy+4Yame6wtdAdlluocHMetRn2DcX
         dMdqb5bW3apyLyoBUfgoxKb16/+lncew3kzW6/q0Zis0o7EzlwpnnQrPWleyJs1m1YeZ
         dG4AgBAy6VyZl2RNUm8DhJvOm01p7EQ7LnVkeYbjFCvmNvW1H7xEFZhUVSWeEvPApepd
         +o/FxnGDjL4J2mpUG2Y+ucV/JZTt62tK8Znhtxs58lRqvG2KdC9LeFq5POHB3KWJTI1X
         xSMQ==
X-Gm-Message-State: AOJu0YzVBGvW7FY0u5w5Dv+s4XvyMgJKxPOFpHBx5iNpnfLJzmTK+K4f
	1/MzHMKvXlfsFwqL/j7AIrsHoNOWx47KlvNKI7gRetlDcMU1SzyR
X-Google-Smtp-Source: AGHT+IH198SnUzC9uexgBweFIPBYov/JuCatyGTYWFWICOwC6qF9ejbHrI9nnHOSHGn+0uSLBmQJcQ==
X-Received: by 2002:a05:6a00:70a:b0:6e3:84cb:3d51 with SMTP id 10-20020a056a00070a00b006e384cb3d51mr117322pfl.33.1708638346860;
        Thu, 22 Feb 2024 13:45:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:46 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 07/11] scsi: scsi_debug: Rework subpage code error handling
Date: Thu, 22 Feb 2024 13:44:55 -0800
Message-ID: <20240222214508.1630719-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the subpage code checks into the switch statement to make it easier
to add support for new page code / subpage code combinations.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 70 ++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ba0a29e6a86d..67a8e6243e5e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2703,22 +2703,22 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		ap = arr + offset;
 	}
 
-	if ((subpcode > 0x0) && (subpcode < 0xff) && (0x19 != pcode)) {
-		/* TODO: Control Extension page */
-		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
-		return check_condition_result;
-	}
-
 	switch (pcode) {
 	case 0x1:	/* Read-Write error recovery page, direct access */
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
 		len = resp_err_recov_pg(ap, pcontrol, target);
 		offset += len;
 		break;
 	case 0x2:	/* Disconnect-Reconnect page, all devices */
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
 		len = resp_disconnect_pg(ap, pcontrol, target);
 		offset += len;
 		break;
 	case 0x3:       /* Format device page, direct access */
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
 		if (is_disk) {
 			len = resp_format_pg(ap, pcontrol, target);
 			offset += len;
@@ -2727,6 +2727,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		break;
 	case 0x8:	/* Caching page, direct access */
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
 		if (is_disk || is_zbc) {
 			len = resp_caching_pg(ap, pcontrol, target);
 			offset += len;
@@ -2735,14 +2737,14 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		break;
 	case 0xa:	/* Control Mode page, all devices */
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
 		len = resp_ctrl_m_pg(ap, pcontrol, target);
 		offset += len;
 		break;
 	case 0x19:	/* if spc==1 then sas phy, control+discover */
-		if ((subpcode > 0x2) && (subpcode < 0xff)) {
-			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
-			return check_condition_result;
-		}
+		if (subpcode > 0x2 && subpcode < 0xff)
+			goto bad_subpcode;
 		len = 0;
 		if ((0x0 == subpcode) || (0xff == subpcode))
 			len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
@@ -2754,35 +2756,31 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		offset += len;
 		break;
 	case 0x1c:	/* Informational Exceptions Mode page, all devices */
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
 		len = resp_iec_m_pg(ap, pcontrol, target);
 		offset += len;
 		break;
 	case 0x3f:	/* Read all Mode pages */
-		if ((0 == subpcode) || (0xff == subpcode)) {
-			len = resp_err_recov_pg(ap, pcontrol, target);
-			len += resp_disconnect_pg(ap + len, pcontrol, target);
-			if (is_disk) {
-				len += resp_format_pg(ap + len, pcontrol,
-						      target);
-				len += resp_caching_pg(ap + len, pcontrol,
-						       target);
-			} else if (is_zbc) {
-				len += resp_caching_pg(ap + len, pcontrol,
-						       target);
-			}
-			len += resp_ctrl_m_pg(ap + len, pcontrol, target);
-			len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
-			if (0xff == subpcode) {
-				len += resp_sas_pcd_m_spg(ap + len, pcontrol,
-						  target, target_dev_id);
-				len += resp_sas_sha_m_spg(ap + len, pcontrol);
-			}
-			len += resp_iec_m_pg(ap + len, pcontrol, target);
-			offset += len;
-		} else {
-			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
-			return check_condition_result;
+		if (subpcode > 0x0 && subpcode < 0xff)
+			goto bad_subpcode;
+		len = resp_err_recov_pg(ap, pcontrol, target);
+		len += resp_disconnect_pg(ap + len, pcontrol, target);
+		if (is_disk) {
+			len += resp_format_pg(ap + len, pcontrol, target);
+			len += resp_caching_pg(ap + len, pcontrol, target);
+		} else if (is_zbc) {
+			len += resp_caching_pg(ap + len, pcontrol, target);
+		}
+		len += resp_ctrl_m_pg(ap + len, pcontrol, target);
+		len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
+		if (0xff == subpcode) {
+			len += resp_sas_pcd_m_spg(ap + len, pcontrol, target,
+						  target_dev_id);
+			len += resp_sas_sha_m_spg(ap + len, pcontrol);
 		}
+		len += resp_iec_m_pg(ap + len, pcontrol, target);
+		offset += len;
 		break;
 	default:
 		goto bad_pcode;
@@ -2796,6 +2794,10 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 bad_pcode:
 	mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
 	return check_condition_result;
+
+bad_subpcode:
+	mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
+	return check_condition_result;
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
