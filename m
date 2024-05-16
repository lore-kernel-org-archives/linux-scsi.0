Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327321E491
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715873002; cv=none; b=sboaJ3koPppWDV7DUy6fNBbmAOj64xIefoURJ5Ym+w039JemNsX7fdPbVGxNOzBD/aIlgktz907ppBvY59WuwNHaQAt6M+hz6LSsfROEqdnCOyGEjOzcoZDtd2fTxDmft4jw2KYgBFT+8jWaHKZ7pZbuEVzeWsbfPXPB+CrfMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715873002; c=relaxed/simple;
	bh=tq70WzKwUV8YjAlCXk3Iorq/FUY/lDcwZh3vNx0PyN4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7EGe1GtxPaYVQnRp+Dy4cTIgbd9sdngYeOxwub3HmMCJo0TAwbldk2if725IyPObunW2RUiYZuhiDNu3hpIM8cq8HEBFZgPE0u1KOSqMVU3dCQxoQWf6TQa+1tpG1I1VeOgktnOSBlNSDMNUX5qJm72wJAfhPCkk+sr/LR/UTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gSbEP1V+; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gSbEP1V+"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6f472d550cbso316683b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1715873000; x=1716477800; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lJ19t3TfMWThGApJUsiDgNrmXhbHXT7rLnignZ0/Rr0=;
        b=gSbEP1V+3JsSWBqsO2+Cfyd+a0E2NBcNf6rXpOPfDxmx7j74lDp09MukMyP/ENgM0w
         Vp/P9y4SgHfmO6j2YP5cD8ne+NTW02CcZMgtpn9QaXpK+bWA4EQXwR95vAarv4H+APaV
         L0XtAyFCMg1i66i/jGVnmKsleK7RONfm3lNQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715873000; x=1716477800;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJ19t3TfMWThGApJUsiDgNrmXhbHXT7rLnignZ0/Rr0=;
        b=PzsEv2whngJn+gNRfgf8gn93xL8sm49kBtZOySkrHRWNnnWC72sqDGlCaItwGMypya
         SsZpaA5/v2rmOu4qcF0QJtDmHmqaG1x/wRbF4dQi7BW/WzmnjWmVIA263WfY5EFY094q
         2qQ4s0Ppdk2tDYvxsz7kYAlpjSdp36guBFVVnd8bcpSfVbiR8gJg7SAx1BiQm8Gak44F
         v0KEGRpfjUc4l+oSFPdK/p+GN6ZXfmSlaUGucotesBZ3AiuXSjpwoPn8T1KKIfpe55jP
         sBHUzfIoLT5Hb/nHgy4VSk+FAAeXCizILkV6i9FiurUbncbn/j9fp6F1r8Le8m0Wb4d4
         pbzQ==
X-Gm-Message-State: AOJu0Yzd+EGr7bxatwQ6KHO7Kq5c33x3BNsFOp0KIOTstDpN6IXrLIoP
	QNjBPlO0zok6/CBmrxEUT0VPc4yndomJ/5FOJET1d2EBDrVt1XK0CsR5KY2r6fYZHetKCDB/lLM
	8UOin5a+/lN8+VxisKZjF1FoQGTNfDSnQUKSI5n44k2zySLmMzcjIPzIRWzan5tbDpl4f4SuLY0
	1dCvi8M7KFyK4z9SoDCV+WdnFzkFleh+6z5mHpkIYGytgPa95d
X-Google-Smtp-Source: AGHT+IHtT7cHSB432fkH+45jS0E7kJ7S/0T6ClSJHcucN0y+LWckinDr67YqP1Es7n/FsnK4E6jtuw==
X-Received: by 2002:a05:6a20:9f03:b0:1af:d0fe:9094 with SMTP id adf61e73a8af0-1afde085b73mr27913531637.11.1715872999852;
        Thu, 16 May 2024 08:23:19 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a83d3dsm13241749b3a.65.2024.05.16.08.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 08:23:18 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v3 3/6] mpi3mr: Dump driver and dmesg logs into driver diag buffer
Date: Thu, 16 May 2024 20:50:07 +0530
Message-Id: <20240516152010.88227-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240516152010.88227-1-ranjan.kumar@broadcom.com>
References: <20240516152010.88227-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000aa4379061893d031"

--000000000000aa4379061893d031
Content-Transfer-Encoding: 8bit

This patch adds support for collecting the kernel messages based
on the driver buffer capture level set in the module parameter
and copy the pertinent information to the driver diagnostic buffer
posted to the controller.  The buffer capture and copy will be
executed when the driver detected the controller in the fault state.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405151829.zc0uNh0u-lkp@intel.com/
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |   2 +
 drivers/scsi/mpi3mr/mpi3mr.h         |   5 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c      | 124 +++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
index 495933856006..8b8b6ba00c7b 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
@@ -10,6 +10,8 @@
 #define MPI3_DIAG_BUFFER_TYPE_DRIVER	(0x10)
 #define MPI3_DIAG_BUFFER_ACTION_RELEASE	(0x01)
 
+#define MPI3_DRIVER_DIAG_BUFFER_HEADER_FLAGS_CIRCULAR_BUF_FORMAT_ASCII	(0x00000000)
+
 struct mpi3_diag_buffer_post_request {
 	__le16                     host_tag;
 	u8                         ioc_use_only02;
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dc7e8f461826..b6030a665ec8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -226,6 +226,10 @@ extern atomic64_t event_counter;
 #define MPI3MR_WRITE_SAME_MAX_LEN_256_BLKS 256
 #define MPI3MR_WRITE_SAME_MAX_LEN_2048_BLKS 2048
 
+struct mpi3mr_kmsg_dumper {
+	struct kmsg_dump_iter kdumper;
+};
+
 /* Driver diag buffer levels */
 enum mpi3mr_drv_db_level {
 	MRIOC_DRV_DB_DISABLED = 0,
@@ -1331,6 +1335,7 @@ struct mpi3mr_ioc {
 	void *drv_diag_buffer;
 	dma_addr_t drv_diag_buffer_dma;
 	u32 drv_diag_buffer_sz;
+	struct mpi3mr_kmsg_dumper dump;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5937054b3cdb..ea489654de81 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1200,6 +1200,126 @@ static void mpi3mr_alloc_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
 	mpi3mr_free_ioctl_dma_memory(mrioc);
 }
 
+/**
+ * mpi3mr_do_mini_dump - copy system logs associated with mrioc.
+ * @mrioc: Adapter instance reference
+ * Read system logs and search for pattern mpi3mr%d and copy the lines
+ * into driver diag buffer
+ *
+ * Return: next available location in driver diag buffer.
+ */
+static int mpi3mr_do_mini_dump(struct mpi3mr_ioc *mrioc)
+{
+	int n = 0, lines, pos_mini_dump = 0;
+	struct mpi3mr_kmsg_dumper dumper;
+	size_t len;
+	char buf[201];
+	char *mini_start = "<6> Minidump start\n";
+	char *mini_end = "<6> Minidump end\n";
+
+	struct mpi3_driver_buffer_header *drv_buff_header = NULL;
+
+	dumper = mrioc->dump;
+
+	kmsg_dump_rewind(&dumper.kdumper);
+	while (kmsg_dump_get_line(&dumper.kdumper, 1, NULL, 0, NULL))
+		n++;
+
+	lines = n;
+	kmsg_dump_rewind(&dumper.kdumper);
+
+	drv_buff_header = (struct mpi3_driver_buffer_header *)mrioc->drv_diag_buffer;
+	drv_buff_header->signature = 0x43495243;
+	drv_buff_header->logical_buffer_start = 0;
+	drv_buff_header->circular_buffer_size =
+		mrioc->drv_diag_buffer_sz - sizeof(struct mpi3_driver_buffer_header);
+	drv_buff_header->flags =
+		MPI3_DRIVER_DIAG_BUFFER_HEADER_FLAGS_CIRCULAR_BUF_FORMAT_ASCII;
+
+	if ((pos_mini_dump + strlen(mini_start)
+			    < mrioc->drv_diag_buffer_sz)) {
+		sprintf((char *)mrioc->drv_diag_buffer + pos_mini_dump,
+			"%s\n", mini_start);
+		pos_mini_dump += strlen(mini_start);
+	} else {
+		ioc_info(mrioc, "driver diag buffer is full. minidump is not started\n");
+		goto out;
+	}
+
+	while (kmsg_dump_get_line(&dumper.kdumper, 1, buf, sizeof(buf), &len)) {
+		if (!lines--)
+			break;
+		if (strstr(buf, mrioc->name) &&
+			((pos_mini_dump + len + strlen(mini_end))
+			    < mrioc->drv_diag_buffer_sz)) {
+			sprintf((char *)mrioc->drv_diag_buffer
+			    + pos_mini_dump, "%s", buf);
+			pos_mini_dump += len;
+		}
+	}
+
+	if ((pos_mini_dump + strlen(mini_end)
+			    < mrioc->drv_diag_buffer_sz)) {
+		sprintf((char *)mrioc->drv_diag_buffer + pos_mini_dump,
+			"%s\n", mini_end);
+		pos_mini_dump += strlen(mini_end);
+	}
+
+out:
+	drv_buff_header->logical_buffer_end =
+		pos_mini_dump - sizeof(struct mpi3_driver_buffer_header);
+
+	ioc_info(mrioc, "driver diag buffer base_address(including 4K header) 0x%016llx, end_address 0x%016llx\n",
+	    (unsigned long long)mrioc->drv_diag_buffer_dma,
+	    (unsigned long long)mrioc->drv_diag_buffer_dma +
+	    mrioc->drv_diag_buffer_sz);
+	ioc_info(mrioc, "logical_buffer end_address 0x%016llx, logical_buffer_end 0x%08x\n",
+	    (unsigned long long)mrioc->drv_diag_buffer_dma +
+	    drv_buff_header->logical_buffer_end,
+	    drv_buff_header->logical_buffer_end);
+
+	return pos_mini_dump;
+}
+
+/**
+ * mpi3mr_do_dump - copy system logs into driver diag buffer.
+ * @mrioc: Adapter instance reference
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_do_dump(struct mpi3mr_ioc *mrioc)
+{
+	int offset = 0;
+	size_t dump_size;
+	struct mpi3_driver_buffer_header *drv_buff_header = NULL;
+
+	if (!mrioc->drv_diag_buffer)
+		return;
+
+	memset(mrioc->drv_diag_buffer, 0, mrioc->drv_diag_buffer_sz);
+
+	if (drv_db_level == MRIOC_DRV_DB_DISABLED)
+		return;
+
+	/* Copy controller specific logs */
+	offset += mpi3mr_do_mini_dump(mrioc);
+	if (drv_db_level != MRIOC_DRV_DB_FULL)
+		return;
+
+	kmsg_dump_rewind(&mrioc->dump.kdumper);
+	kmsg_dump_get_buffer(&mrioc->dump.kdumper, true,
+		mrioc->drv_diag_buffer + offset,
+		mrioc->drv_diag_buffer_sz - offset, &dump_size);
+
+	drv_buff_header = (struct mpi3_driver_buffer_header *)
+	    mrioc->drv_diag_buffer;
+	drv_buff_header->logical_buffer_end += dump_size;
+	ioc_info(mrioc, "logical_buffer end_address(0x%016llx), logical_buffer_end(0x%08x)\n",
+	    (unsigned long long)mrioc->drv_diag_buffer_dma +
+	    drv_buff_header->logical_buffer_end,
+	    drv_buff_header->logical_buffer_end);
+}
+
 /**
  * mpi3mr_clear_reset_history - clear reset history
  * @mrioc: Adapter instance reference
@@ -2767,6 +2887,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		if (!mrioc->diagsave_timeout) {
 			mpi3mr_print_fault_info(mrioc);
 			ioc_warn(mrioc, "diag save in progress\n");
+			mpi3mr_do_dump(mrioc);
 		}
 		if ((mrioc->diagsave_timeout++) <= MPI3_SYSIF_DIAG_SAVE_TIMEOUT)
 			goto schedule_work;
@@ -5311,6 +5432,9 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_ioc_disable_intr(mrioc);
 
 	if (snapdump) {
+		dprint_reset(mrioc,
+		    "soft_reset_handler: saving snapdump\n");
+		mpi3mr_do_dump(mrioc);
 		mpi3mr_set_diagsave(mrioc);
 		retval = mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
-- 
2.31.1


--000000000000aa4379061893d031
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJ1nWPwnffwjRO9Cq+bQErv1j6OXqbKQ
Drt+XgfRHezPMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDUx
NjE1MjMyMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB0HFriBSj579gSZOnRebynTacdNkiBJ8KTy51Ji4L520eODe/k
rvo3Tf9z2Z8iHNRxTKXFiPPOrCenj7Ak+c9B2assgg0i7V+P/nTLl+NmmqUsiIzOi+knVOe+oGJS
Pu3+OpnR61FZZXabjVxV7e1P2e8TIiz3UDEKRpmM0MkPpe/YcXsmKfmxOMIvVcVqK2akYcx3vCZS
wdxg4i9iB/jyLtgQDT7MV92Ivb/QfH+nmzn8Hok03Ia3/PL7S0Zq6XG2pw2R9UZiHzovsiAdIGLV
Vwtqght4aSTzEFeeGUjhjfKQWbAj/cU4z3mlfY1DcXr0pVWWtzEEi+Vv6FJvyMdB
--000000000000aa4379061893d031--
