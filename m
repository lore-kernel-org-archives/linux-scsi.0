Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD914AB4
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715774114; cv=none; b=Auw0QZq8bcdIE5UrKn2zEllKP7XFqTBpCGR9YLZ+k3UtoS5Zy9us+8nGenEEWOEpUesvRPRiaVrp7uFYRZ9pOCwjU8tInDLKu2SqK58b2RkW5NAGopwjW2c5QGmdqNlkSg0neb1FS/xH8CRn2y8gGMoPjY792CSFL8qSL4h7E2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715774114; c=relaxed/simple;
	bh=QAl9mgmDKsNX8HnbX170dNZfG14doDxMOfeognub8g4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQ9A/iwNTOy6saith2ocryrlU7y70J4wBSpPZs6ARfKRnsgJczWCDr8/47IYT648Feue78Butq09+1rg/5bxLjGKKxGlobQvxQXqEPcL3aU+Y3khv7Gwc/QomOHjN3e5ma5bFDSDbvTNDhpdrpk2GKPO0Cm9P9GyNm13JpZIBPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=D54womK6; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D54womK6"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5b28c209095so3040921eaf.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 04:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1715774111; x=1716378911; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tRYsVa7bpUgCIDzU10JXGV3YAe0/enuXMdW65JIRhuw=;
        b=D54womK6+Z8wS0uPu+h+yf20yphe/jA0OTHrzPmXJNdEbt0W39iHsFdbHI3+zhDqSJ
         07x4GviMWk9JmDH7HoYzHae0f9IDLtm984XavB1InF3P1uvk6pWwncWfBpt6bLe5UXqQ
         6vdiicLLNwaKr6aDHvrhevH46K3zPUdp71Qqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715774111; x=1716378911;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRYsVa7bpUgCIDzU10JXGV3YAe0/enuXMdW65JIRhuw=;
        b=BMdqG6Nq9Ra6/MfKxxLO8nZcwmCzVIOUx/BEx1SysVNM8EHuHeY2M5hNxLJ30I4RJU
         Otuu1L7aKZ/mf1Vs3YLMSNq70qW5RW1es3ONcVDBsAowcdwZP56KYYcWt8r2fzEpV9wg
         bv1fqOxVI04GiUvyMEfOZ111VHbpHeM9Ito10WB8euxDZ+wj6Tgf7d66tVS2PUMh1k/+
         lyi3N9ZJSIK8zCiJxcoWYhv8XvDrnSwA5GB3VAsjU23J289VbKgwQ4S2ACd6CwB246DR
         RGgZML1htI0VDi255sWdd7oduqIIfoZP6oQme72K1EfgaAt0lzS0qSBOza1tAegxKOjn
         Cb6w==
X-Gm-Message-State: AOJu0YwHcybCYUHfTii7ZPsKcqthVTpEFvDyXGb0J0IICq89y65Dj6Gb
	7UOnNW0WCUGV8IiHm71EFsZXJvLyq+sjWQQARF/AsxlcFZ6ZFFm89/viJquFm9wzsYReEN48sP5
	aaQ6leMSq41Kp9+45tAwEsEGtzE6yDbtoqOYkNn0MvI7ORd3d0/cfDGLbRp8pauZSYak7+K7DkZ
	DfP5HRYvydIjh1mjprS95gfWDcdjlm5UgMnLNIoh6sNVfVcOzr
X-Google-Smtp-Source: AGHT+IFB5k9d8pa7sQLPzlDwbovHR++C/A9JV7grdo1HUVZlGa7pvL7Lv8vZ9RSaID0+mOAoIyQbLg==
X-Received: by 2002:a05:6358:262a:b0:186:27f9:d725 with SMTP id e5c5f4694b2df-193bb51451fmr1147798055d.8.1715774111006;
        Wed, 15 May 2024 04:55:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-63411346958sm9819234a12.76.2024.05.15.04.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 04:55:09 -0700 (PDT)
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
Subject: [PATCH v2 3/6] mpi3mr: Dump driver and dmesg logs into driver diag buffer
Date: Wed, 15 May 2024 17:22:02 +0530
Message-Id: <20240515115205.75599-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240515115205.75599-1-ranjan.kumar@broadcom.com>
References: <20240515115205.75599-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000727cd706187cca33"

--000000000000727cd706187cca33
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


--000000000000727cd706187cca33
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
NTExNTUxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCrEIQ/bdVy9SGwmpFOyX1UlRc7koxUBhNAd4szHHQneXrt3jbP
IoleokbqyERHdDbFlF6TI2W2ht/n8Jm7r81d3xi9genWWBGer/GZLMCNdh0MNgLYMVBDWxHphmEZ
A0FyuQGdCWtNUB054a9xreJRnxqb3DffvbPR3zFdr8niOlYJgPN3w2Pb7ogFCDAkc/WOc7ck4F4P
JydTpD3muGaZ19XiSbK4qJjudHZZ6AMJiiw2xH6SE41i9uqYU/LTkHR31h7sZr4UU6g8HELcT8yW
ZFTiOrstiP+iGW6e+mXx+8M9VRzzHoXUzD8bCOK7UVnVUgyrGK+sdLgWtrLrDi0l
--000000000000727cd706187cca33--
