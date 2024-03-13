Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA33639852
	for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2024 10:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710324637; cv=none; b=Oz1evBSavE8HlcKC/L7RUoPc4imTRXNItnhvgZI1FZQf3XkMXMr5/vJCZSSKhdJwe51fpsEdY9BMR6Yu7zWKUJ6nZTQL9qqILpWAhhQMqNp+ITVBWmx2BfXr9IAFpTaAKq5As5wq8jaErtm68OACp0dexomw6bggMokL6b0sFuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710324637; c=relaxed/simple;
	bh=7FtlTpo7AlnGXAc/0e7puLHutyeSinEkcAv4qN8/hI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrC2kmBBr/sxEo8+OUs+zcEznhuxmbrUmDfugzUkEecGK3PXVqNLK1E1jdJHud1LkCI/WxQbtn1nJyJck3fFXaIL6fmwmX8NMJ4VNkDcJavjPLm+aIA1jl38HpcpBzGpp4qgFjqNo0LPy10x1BiG8mofTVJFDKeXcth9oTgDEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cm4E5hnJ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cm4E5hnJ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e649a2548cso4538574b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2024 03:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1710324635; x=1710929435; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=oY+lSWH84MMz8yUW4hYja/GRAZ4UVCdFbjZpT8K0aTU=;
        b=cm4E5hnJyiKhKj99UvTiMX+4ZIXBDEJ1Amvwmj0gh69TdgWzl8GNzBINRtGHjDPS/W
         giQ0tLrCsNBjGutuYldiIphkK9HHfjaHS8tZtwFTZrlK/idRrqbaQ9IaGxXEVnCyNBAs
         P/dpESbE6IAwOS6CLZhw6FUNGrOAAqGj+U/No=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710324635; x=1710929435;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oY+lSWH84MMz8yUW4hYja/GRAZ4UVCdFbjZpT8K0aTU=;
        b=rSW39mZQWLXztG9HDHOCOTIAJEXtaWFkm4Zz1axYpeVItDPhLd6QxIrqPOIHTyG3UI
         hB+GCR3VHl42L4quIHLfCg/Ad1LAENvrUVqeLKIxg/gQniPixtcklkmQz72Mds/PmBWD
         gTKYrtQLRtTv6PajCPUCQBp8TXoQC37EC5e5spl5Hcxoom5ON2f5VtCNfKbc9PGVUBgN
         bsMXasJd/gRrqfnsIZhnEc5JAPFyUj+8VLttufn0K9XfxMopEy4YZMuM9k6SaxgFy0t9
         5wBx/DA5rODWbpDrzPBRPWYMNskxLA68So5dXolpvOFAnsB1o/CGSMSIgLk7GkfbqOvD
         XCOg==
X-Gm-Message-State: AOJu0Yx1BtGOgauLy2r/ubOO4+Mk/WjnqEJycJfpjvZWSCxqmFiSzN1b
	1cq+UF1FerIi0IzhUcd/0lMvA8UDEeCz5CKbxaWghbolUctIsVlgvyrYpvW9ARFVEgg+4o5ZHGg
	Qgh4FbWyMeKELXCI6wtsUXfFZVO2JcAt2fSVuorGRMWfRItzrcldlOR8ZkLfQ4WznvrVym3i4KC
	mvHgPT61VpRy0YqUJLHqH/s0zdA2iZOv5ctCJjFMgNndypRw==
X-Google-Smtp-Source: AGHT+IG3+GwJnOWKE6oT3KdKlXr41bFNEtkSSYiWoy1n1Q1hWxW6hFQ5XJt9KpRPeohkMtJj446r+w==
X-Received: by 2002:a05:6a21:2d06:b0:1a2:f4fd:b1fd with SMTP id tw6-20020a056a212d0600b001a2f4fdb1fdmr2947090pzb.39.1710324634506;
        Wed, 13 Mar 2024 03:10:34 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j18-20020a056a00175200b006e5af565b1dsm7570337pfc.201.2024.03.13.03.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 03:10:33 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 4/7] mpi3mr: Set the WriteSame Divert Capability in the IOCInit MPI Request
Date: Wed, 13 Mar 2024 15:37:43 +0530
Message-Id: <20240313100746.128951-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240313100746.128951-1-ranjan.kumar@broadcom.com>
References: <20240313100746.128951-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000005241c8061387fc24"

--0000000000005241c8061387fc24
Content-Transfer-Encoding: 8bit

Driver is modified to set the Write Same Divert Capability bit
in the IOCInit message for the firmware to know that the driver
is capable of diverting certain write same commands as defined
by the MPI specification.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c     | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 0cb24fc03620..85b91583bacf 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -27,7 +27,7 @@ struct mpi3_ioc_init_request {
 	__le64                   sense_buffer_free_queue_address;
 	__le64                   driver_information_address;
 };
-
+#define MPI3_IOCINIT_MSGFLAGS_WRITESAMEDIVERT_SUPPORTED		(0x08)
 #define MPI3_IOCINIT_MSGFLAGS_SCSIIOSTATUSREPLY_SUPPORTED	(0x04)
 #define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_MASK          (0x03)
 #define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_NOT_USED      (0x00)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index a21fbff60b59..ae0e2c6cd2af 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3302,6 +3302,8 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 
 	iocinit_req.msg_flags |=
 	    MPI3_IOCINIT_MSGFLAGS_SCSIIOSTATUSREPLY_SUPPORTED;
+	iocinit_req.msg_flags |=
+		MPI3_IOCINIT_MSGFLAGS_WRITESAMEDIVERT_SUPPORTED;
 
 	init_completion(&mrioc->init_cmds.done);
 	retval = mpi3mr_admin_request_post(mrioc, &iocinit_req,
-- 
2.31.1


--0000000000005241c8061387fc24
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJrR8st+ay3oxfRpaM3PE9GB5h2K1Jmy
bJ7ZNxgF74foMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMx
MzEwMTAzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDC7uTeqWSNdjQjgpo+c6F6l7aoTppzk76VktzgOcAx8N1g05JB
5GnMdTZgR5Rt7kfkJM8mxyCFUEpEr1e+4cc/YHZvejhYB7fzk4Gsd7HGtk92QaZ9GqFhwnPLM6/T
XqZOgXhaUEnzelkSZa/mUGwoVjd1frb6EiqQR6CUGO9s0amFNNseHUNu1gv+moYD0tj43R5p1WGe
8tM+9hXiq6vc/Ul6O8V7Hp9WWFvf5qGwbjByHcRr3/o+rKhFUKod31LkUSl5SDeKjJI2IaaNXYhA
VSNWvHPXFH2PUs5O9xWActuN/BaZLlSbz22xlIb/5Qu8Zb1V3rrZyzH7Nu+T3gqe
--0000000000005241c8061387fc24--
