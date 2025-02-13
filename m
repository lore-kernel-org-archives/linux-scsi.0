Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D510280034
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 01:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410833; cv=none; b=rZRzRJd0SQ2+xjyCHCihv0/PTQaTr8tOHzxhY4VV/meZtVJmtyRGV6ycNPCjutx/iwB0Jeh65lm8pt0Kd5lHGDEZuh/BcelaitLcimr9QxVX9px+GrByusfzPcAF/ORCPG1QtuhSy8C7VcVrayriaYqVtF6ZR44PCVbpeb5+Wn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410833; c=relaxed/simple;
	bh=+b+xxworQf8oCW/rqu8wkmimAM5K8AbdPbdbINRs6Aw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=miM2hXJTv9QmQEtJ4uD2sGvhfYdkTYbvSpkzweVSJP9nqAsiwTukljAkj0vSzvGhlH5zAPPKTjQRwv5KGRYTFtWHjMIkD+sZmYYDckcdMtpURGhckno+kpj1NEWcqK6T/Q84GAB7GWxn1vjQ52apmD4fvV5hXwFe0Y8NSTYl9pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=M+R5lx8w; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="M+R5lx8w"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-220c2a87378so4147215ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 17:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1739410830; x=1740015630; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7McbLFUCln5RZrUsl2n96zgHAF5NfFLqrQ1k2f39Emg=;
        b=M+R5lx8wXJd0HI0X/bTQowKToJttfwlMy7pr5wAlikM5sFmlZFVljEcCsKAhucYp5q
         YdA7dNBa3Mr69mIzyp4EdGmKCMDNoL2PgMdP5wMyTnk22V/8X8UYi/gQFm96FA+XJ3Ij
         CacP1F2dAvQHt/OGyiPZT5u2/xb2zUTaygXlA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410830; x=1740015630;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7McbLFUCln5RZrUsl2n96zgHAF5NfFLqrQ1k2f39Emg=;
        b=xNquoRMeAoRPVesTapB86f8LaQ7s9gBF9iU8DNUytdYwiVL3KGPxJy7IfvhMQNhprr
         qOT3XOmGzac6MAcf1486svLWM04cWW9Q6qFWq4e8i7JqnyY/ZQSCETiJNwWrbDFIOhrp
         DuMZzkmFlL8agGSuoZWqwCkZiIdhPJgas/8g+kMWqqLmGGmjQtWa3DTIZ0X+5H7leQtJ
         Yk0lfxiBtx19BMOU4FrMi6YvwckQi+3H+8wm2/Xpd8x098bkKtqog/P/Q0ILG2R0b1Dh
         4kdtSQpMAF8Vgm2YS77g8RUBiwjrUiU1bh0/UbVl0NxtU1xIOnofwlYUwQ3nLV/FIX0w
         XQug==
X-Gm-Message-State: AOJu0Yy8QQtCHINUbln22+Iz2p9TTmpnLY9kyb8RQ9VeWsBW4iLI3CB4
	/TNG6U0J7/6tQDUjUGUB/dXS0Zl9EAQT8KSZhjsXf78jOAoSPwwoZD+ciE0lsNVpm4Rjkd8a83B
	ljL2xz14MBFzexvXqfs/P+ca+99U92kS/+MN6Z8Auh0VMKc1JcL1hghx4HrAMneyEAYvFTPxaR8
	zPyqxBKmhE5cg7x/FJjrhIbRrv0G3dLU5PLACbNz522oIYNUapabq00XScFKVCuaSv
X-Gm-Gg: ASbGncvHCjXjs9UvmspPSD9JVBEeedLBDlO/Jra0QhxYtC4MhC4/Nz8O2QF4qcHFrLr
	B7iZBAmSPGzkY4x25hHM94Ho8XHMB2dq6bmatPUJlHrdoZLTe3bmjUyvptZH+h8SevIFeHuCmnB
	tQMhwPzODh/wV0NQZtKF5+S99r+QsYOgt+xC5aToAmXObiSP8+Yat2M6jcsxaDN7LC0pAh1T1RW
	h+DQpYToCTw4cRAHLJtG7v5S9gqygfBwJ/y1EeV/2iXRutvMDa66FhXpANeFjzxUZprEWYASX5V
	tAPhHDfn1amCR9V6gQyGCOg98h7mXfZZL4K9jPk0O5Js6ieP0O2xEN6vCIJ2XPTdgOh5dy/aXUr
	fOCWZVGjU9HLOJkXU4LUtddU=
X-Google-Smtp-Source: AGHT+IGufLInw4O9quXVi1kQmiObioK9E3UvK1CHlILK9ruRYAah5SKaeSj1Z915D0X8gwHhFOL9tg==
X-Received: by 2002:a05:6a00:1c8d:b0:730:7600:aeab with SMTP id d2e1a72fcca58-7322c39cc21mr8165505b3a.13.1739410830094;
        Wed, 12 Feb 2025 17:40:30 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242761714sm106145b3a.133.2025.02.12.17.40.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:40:29 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 4/5] mpt3sas: Send a diag reset if target reset fails
Date: Wed, 12 Feb 2025 17:26:55 -0800
Message-Id: <1739410016-27503-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

When an IOCTL times out and driver issues a target reset, if firmware
fails the task management elevate the recovery by issuing a diag reset to
controller.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index a731622f2f65..13ba91d21fbb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -716,6 +716,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	size_t data_in_sz = 0;
 	long ret;
 	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	int tm_ret;
 
 	issue_reset = 0;
 
@@ -1174,18 +1175,25 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			if (pcie_device && (!ioc->tm_custom_handling) &&
 			    (!(mpt3sas_scsih_is_pcie_scsi_device(
 			    pcie_device->device_info))))
-				mpt3sas_scsih_issue_locked_tm(ioc,
+				tm_ret = mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
 				  0, 0, 0,
 				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, pcie_device->reset_timeout,
 			MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE);
 			else
-				mpt3sas_scsih_issue_locked_tm(ioc,
+				tm_ret = mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
 				  0, 0, 0,
 				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, 30, MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET);
+
+			if (tm_ret != SUCCESS) {
+				ioc_info(ioc,
+					 "target reset failed, issue hard reset: handle (0x%04x)\n",
+					 le16_to_cpu(mpi_request->FunctionDependent1));
+				mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+			}
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	}
-- 
2.43.0

