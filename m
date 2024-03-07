Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C47342052
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824252; cv=none; b=jPIkRY/RFlAII0+/cCTRp5N6s2/ZmPk22H8+jBrvL/uOyqenlo46hlnw5LniGWNS1T+j47P0T8joVAn1ilRJ5Jwql9AI2QAp1ZZDaFlBUh2zDe63k3EOvaA5NnK+o23AOnN7DSIAxOEDQmt0d2PNdlf6xIQhxMbqLNZ5KJ+ufDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824252; c=relaxed/simple;
	bh=IT2Uh+qtJciGwMdkWs+7aTImk1+zqNNFH0miQSBjkqc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iP1yo6VfVmPUvT0vP+o7+t6seeluHLkxrpszxoWgz3NoC173NwASPEb0t2mf9flVmJD1UOBjlUdIqwADBi+/jqYlSKfLUXqpBCb4UB8sBnbrwp6bgi96GHMy13YxKZHvrSaj1YxFf3/F5qXQdA8ToWQcKyy68A1ti0aQylD4prQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VOnrT6y4; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VOnrT6y4"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e6277f72d8so777469b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Mar 2024 07:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1709824250; x=1710429050; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=t2F6ObH7f7OoMNiPnJz4Aq+i55mfMlJFYFepqfMYAeU=;
        b=VOnrT6y4YAP561FySLCYJk0tDVmLXP67m8H6jCG/atskTWgTU99xunsgnhuBMr//K6
         Z3tGR88wa6jptETnDKwRdZmpPM4kY/lYX6q2pcEmvUnTU200u6bBnm5QWWDvnxaha9y2
         HkwTC7Lk5dBpboQq5cOUjziZJbhSIbmF08ylg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709824250; x=1710429050;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2F6ObH7f7OoMNiPnJz4Aq+i55mfMlJFYFepqfMYAeU=;
        b=athGHZqw8MWHXTV42X2PhyKChpzXLDIhr48GAVMVQU6Z1C/0VT3fcEq62SHKPIXl28
         xT9QUBFkYw2LOsdOLWfH3JMdfUEfABpt86IdDLV6RO9dK1S4L5A671YEOz2gq6A436rd
         0Mp25grgisQpdIwzFg0h2UPg75LvA3FW9SIpTj68jVdjk31Y/r/1/zx8eUTePlXqZTNm
         6NtpLo7tDRb++it+F/6/OPjR7+zlj4MQcMFvKNCnJLJZuzsYdNeN6JV4Yt7J2B5bl5Uf
         Q9HHnYRGpLECFCSU1DK3k2wYS4bTC1yxCE6T8w2CDRLMXazENL7WvyCFP0TjCVa43oTO
         8VEg==
X-Gm-Message-State: AOJu0YylDOBGTITr+c9MU8TYaq1H3mDPFodq2GhshwlpbBW16aKtugW1
	5DTbv8fuAP1LJhXIgh9C3jrORmM5lugnfNt6Qtga3DkN2kBnH3e7bkbIUcaGoppDaG+AVyrunjQ
	RUcWkVFOgXHmEOOpcdZ76roBaFedgMbJ1Tmh8He8ak+Y+ZWIUEX+rjp6o3Vk/UXRxvWZ1VouWYV
	GRd+Jcd/DObIx9XVWPfjAT0JBB79ycJ5Hm6xgh14L22VzD1G8P
X-Google-Smtp-Source: AGHT+IHVQ0jX9z/mI1WSrIIeT+BYJwAuJXesSnWkdtMRhAQra6BHr6PiE5bzHOLV5PhfXZpH2EylVA==
X-Received: by 2002:a05:6a00:9294:b0:6e5:56b5:606a with SMTP id jw20-20020a056a00929400b006e556b5606amr21383454pfb.11.1709824249810;
        Thu, 07 Mar 2024 07:10:49 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b006e58da8bb6asm12009906pfu.132.2024.03.07.07.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 07:10:49 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 1/7] mpi3mr: Block devices are not removed from OS even vd's are offlined
Date: Thu,  7 Mar 2024 20:38:19 +0530
Message-Id: <20240307150825.7613-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240307150825.7613-1-ranjan.kumar@broadcom.com>
References: <20240307150825.7613-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000129db00613137b8e"

--000000000000129db00613137b8e
Content-Transfer-Encoding: 8bit

The driver did not remove the virtual disk that was
exposed as hidden and offline after the controller was reset.

Drive is removed from OS when firmware sends "device added" event
with hidden bit set or access status indicating inability to accept I/Os.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 3de1ee05c44e..06359915a48d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1348,7 +1348,7 @@ void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout);
 void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc);
 void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
-void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
+void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_delayed_cmd_lists(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 73c831a97d27..bfd32354b662 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1029,7 +1029,7 @@ mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
 }
 
 /**
- * mpi3mr_rfresh_tgtdevs - Refresh target device exposure
+ * mpi3mr_refresh_tgtdevs - Refresh target device exposure
  * @mrioc: Adapter instance reference
  *
  * This is executed post controller reset to identify any
@@ -1039,7 +1039,7 @@ mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
  * Return: Nothing.
  */
 
-void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
+void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 {
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 	struct mpi3mr_stgt_priv_data *tgt_priv;
@@ -1047,8 +1047,8 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 	dprint_reset(mrioc, "refresh target devices: check for removals\n");
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
-		if ((tgtdev->dev_handle == MPI3MR_INVALID_DEV_HANDLE) &&
-		     tgtdev->is_hidden &&
+		if (((tgtdev->dev_handle == MPI3MR_INVALID_DEV_HANDLE) ||
+		     tgtdev->is_hidden) &&
 		     tgtdev->host_exposed && tgtdev->starget &&
 		     tgtdev->starget->hostdata) {
 			tgt_priv = tgtdev->starget->hostdata;
@@ -2010,7 +2010,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 			mpi3mr_refresh_sas_ports(mrioc);
 			mpi3mr_refresh_expanders(mrioc);
 		}
-		mpi3mr_rfresh_tgtdevs(mrioc);
+		mpi3mr_refresh_tgtdevs(mrioc);
 		ioc_info(mrioc,
 		    "scan for non responding and newly added devices after soft reset completed\n");
 		break;
-- 
2.31.1


--000000000000129db00613137b8e
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEfZy7VGotu3LAsLon420LZOTuY1pvdx
AkTf14NqwqUpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMw
NzE1MTA1MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBtuNiBzRR9p3Ql+1Fs1k+REa2/rES/x9pF4iU9M2xW3S03rPOj
gKYP0LZ1gNXzji+exTzeRcEgqqIX0e2Pl15ZCy8R69T+cj4IhGFMP2+gVAYJgP4cH0X7NDilVAyJ
0BiTYsTJx2wbIoSjC9ON4yM5yNPDZj1K/bj+mfLRlyKHOQqImlvsHS+zWdJxVcXRAzrY9WaL96od
j4eJUsxyHdXBM7JiKk8id6Zybekur9ppHtMw9kYXf6ZUlqG/K8Vl2js6oaTT9HM0NEM2QlzSaIVa
jf2AYSzG4xrNIpjZhuZ6ILK4TtoofmtFQa0JgYhIaDqhiZxFuHc9GginDmGnxJMu
--000000000000129db00613137b8e--
