Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="clBhKzKA"
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AF710E4
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 07:49:32 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6cbbfdf72ecso1004073b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 07:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1700754572; x=1701359372; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ai61vBC5oaCYcx6o+s8gmTglYCyGN/e5Befu1GbxtJ8=;
        b=clBhKzKA2Btd4GgFhrQbrt3pvz4ISGXxdOxGKtqHFlFDdbk5P0Xs6fzmyqYDK84wO3
         FHxvj52YwSwDJBpeddY1LBzvZQOga5f+SqxfbtSIxh8Fiq2Q6QySsw0QywWmwOhAuS80
         77KPnCM6IgHh6SfSKSkn8bQ+foKR6RXEhRsOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700754572; x=1701359372;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ai61vBC5oaCYcx6o+s8gmTglYCyGN/e5Befu1GbxtJ8=;
        b=Cyzh1RIQICMXF3zV1TBPwIZ0pQNHUBzeMAiawtWOxQP9gHKeje1oN+OwbgbIVq1ubj
         yJS9tVUy7MmoriPjxhAHFCfQsNn/LXPcu3XzdTmnF7OjFj97mSwrw4n7ZmokHLmGCuBo
         6jCHYyKmivhbPrOnWNqbfEkdQScOf+uWnXNP+65HRObTsKYp5wyPq6CP08Mx1voW0vFE
         m4OpFl+ijYgt+KwGuzO/24o2b3HqPmCD6rA55tvqCESxP6LS5Ywe3rp4xbIeSDDB+y2O
         YElJXRtVtIcetp8O4GxvHzRrl7UHtLJn3HUqev/bFEpwKGuHHTkza9Yy4PAF9a9drK/5
         OTWg==
X-Gm-Message-State: AOJu0YzB+9fUn5M6baRwfO0ma1u6R4pXYhlfGRf92oL9vSo7AvYPAxI1
	sOBwMMjXohOXMTVT3A9cxfVVUA==
X-Google-Smtp-Source: AGHT+IEbY7fM4JPW9UFWq3vtciOXlR1OJQS8G1VFYO2AlHj5hYdDvhUuL3cr6HYnQhdDBp5+E0Yc6g==
X-Received: by 2002:a05:6a20:728f:b0:187:ee15:82dc with SMTP id o15-20020a056a20728f00b00187ee1582dcmr1376pzk.20.1700754572246;
        Thu, 23 Nov 2023 07:49:32 -0800 (PST)
Received: from dhcp-10-123-20-95.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00134b00b006cb98040658sm1368686pfu.34.2023.11.23.07.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 07:49:31 -0800 (PST)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	ranjan.kumar@broadcom.com,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 2/5] mpi3mr: Add PCI checks where SAS5116 diverges from SAS4116
Date: Thu, 23 Nov 2023 21:31:29 +0530
Message-Id: <20231123160132.4155-3-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20231123160132.4155-1-sumit.saxena@broadcom.com>
References: <20231123160132.4155-1-sumit.saxena@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000257de6060ad3c8e3"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

--000000000000257de6060ad3c8e3

Added PCI IDs checks for the cases where SAS5116 diverges from
SAS4116 in behavior.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f039f1d98647..0d148c39ebcc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1892,7 +1892,8 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 
 	reply_qid = qidx + 1;
 	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
-	if (!mrioc->pdev->revision)
+	if ((mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
+		!mrioc->pdev->revision)
 		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a8d7dbf0159a..91a22e6e5c3f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5101,7 +5101,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
 				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
 
-	if (pdev->revision)
+	if ((pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
+		!pdev->revision)
+		mrioc->enable_segqueue = false;
+	else
 		mrioc->enable_segqueue = true;
 
 	init_waitqueue_head(&mrioc->reset_waitq);
-- 
2.18.1


--000000000000257de6060ad3c8e3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1J8x62/iEVbCstJaE1Nt3oXnL5yBlqX1Ihp8cZLe1weS7Wp/v5Jg2Ks13jeYOKW45xXExpqPPd1f
3meFjTf9K+rGZHb63htWaJtf0NYbE+5yIbXFv21cBxECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUTIFIrhFDaoMEbXuV9O+Y+XgS
kVwwDQYJKoZIhvcNAQELBQADggEBAFyioHqB2PHWcQ5cU8nprPRk37uSWK2x0w7W50jjc0cooz6G
G6pltJ+DvbG7XIzCU8cKHmuyAxoe1+/vhB8yJH78MVdfKDDND7zL/IqfhZedxHcHG5jVqbVH/ufu
H19y4fHxo5bLkybX3UxkN9b3bMsBZ4FFCLSCFgFfjI0BmTx6IoGyi0R89rzD0H1rURy7WTn0ijl1
nERsqENeyGfUTJLcDSURb49qpFqqWweJ7ifC64Iak8wCK2CxCe8lHfTyEgC9MuEa586NMQJDguvw
jlC7kxrgwf4sZ/9Wj/GS2HLzZPkxWCcQIrgNJm2wceHQwPBpM0ZoqL1D2tsFgOA8BvYxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwdgevXLIdo6fbCNI8w
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEIyEoXyp2bld+K/wUlgzLlqlKH4ZfDC
fgcE9/yBcHXBMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTEy
MzE1NDkzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQClqLoFFTaI3BzOOPo6LqRBfuHASeq9i/G8xrk+NlQKL2f7TMqH
K5ea5Qax6D9SeARHtU8PlrktJdaotNq7Ldi8a6fC4BYco1vAH1JbArSadcJnAJJnf5DFx0w5e128
kfIIGdRzMKVR2jXGkfzoCpn4S12d16MUnDAizbAFlicVfvoidRovDw/AOUfeH0GweOXo3dW2ia47
ois4aLJlEawX8SUu9eutJfdFCbUW5/hA7aGwPy2i7vBpQ5WSJjiTLYXsWPXQfAwlakXi9CNzENUp
P5SJcFcYYltbY3PDc+6+N3zY6zXRIx69nDC7htugZCUOmorL0NBtELvLtkRAZdah
--000000000000257de6060ad3c8e3--
