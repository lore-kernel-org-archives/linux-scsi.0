Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KcsHSEuO"
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D527D1B9
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 11:15:39 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-286f22c52c7so613294a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2023 11:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1701803739; x=1702408539; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uMcbvYIS9+GDt3PATCfxtB2XQDsWuLKQuSDGJchgZ6E=;
        b=KcsHSEuOksckiWUsq7LNpmwvO0lz7vJFjK32f8VUA79TyD1WkKNZNxP0+TQfFSbEhT
         OqBQt6ByzyjS6hYw2E4kBsak/2JltcTgR8cy7U+wCgjSvr4RnDiArxVguz1a+f1DW0PH
         jHReaBIJ8E9AIqSfqfL7PYFWr426WUWgAtFVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701803739; x=1702408539;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMcbvYIS9+GDt3PATCfxtB2XQDsWuLKQuSDGJchgZ6E=;
        b=J4KiM9dijEoM3PoFh2ReJSpe/+sF756h0lsBkT16/ceqYJ6q1JZmpJrcEmzG4hzTOJ
         7lOhwq59FmSnJPZEFzKEvNt9r5MfjjWsXkXOMp+xd0N8mq96HjY5Xrrb6VDq1gKUf5KD
         BnxeuKvREtcTOl9ZvETy7j0m3vG4w1o50xXrYEctqq1KwWUBqTUQkXK+F/N2jbK1vln7
         0q3aaorcENDUZaWCpINhvFdYakx/y86itUmZ+a23XHoNa7h7taExMp3SNwxj3fNGpAV3
         /7wrDt33wxTxXGC/6CAffT/pzVDXr7IoRZ8mWZA4BCAzvjWnUM4dk3ApoILI7cRiLdip
         lgpQ==
X-Gm-Message-State: AOJu0YyDtSVzbbr8RrHKb6QIYmTDnSgpkNuHacQs+62h1ZMT2bNsIQ/x
	xPNR1SUz6EeOd0vJ/0P62AS0k4fTzYUv6jneRiQOVO0S1j3PywXEEyjtxqsx4Q1pAHB8IntqnfT
	t9hLp/ZrRSSv/KrpRgeDke0m/LG/X1st7NkEXjYE9LtmrJuJQkJTozvh5JXZFeB6XOxAp9kIN8/
	oJRHmWUCz/CW1npOKY1w==
X-Google-Smtp-Source: AGHT+IG40Zj/dNTvBy/BitoETz6LCCc694X03YZad9XjyDanWUgwIPXmcvz9cnge/65mXR/PJLMJJw==
X-Received: by 2002:a17:90b:4f41:b0:285:dbc9:dc18 with SMTP id pj1-20020a17090b4f4100b00285dbc9dc18mr1476569pjb.38.1701803738808;
        Tue, 05 Dec 2023 11:15:38 -0800 (PST)
Received: from dhcp-10-123-20-35.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a199000b0028017a2a8fasm10801896pji.3.2023.12.05.11.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 11:15:38 -0800 (PST)
From: Chandrakanth patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	sumit.saxena@broadcom.com,
	sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 1/4] mpi3mr: Support for preallocation of SGL BSG data buffers part-1
Date: Wed,  6 Dec 2023 00:46:27 +0530
Message-Id: <20231205191630.12201-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
References: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000005b783c060bc80f8d"

--0000000000005b783c060bc80f8d
Content-Transfer-Encoding: 8bit

The driver now supports SGLs for BSG data transfer. Upon loading,
the driver pre-allocates SGLs in chunks of 8k, results in a total
of 256 * 8k, equal to 2MB. These pre-allocated SGLs are reserved
for handling BSG commands and are deallocated during driver unload.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  15 +++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 112 ++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 4f49f8396309..8fce57894f8f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -477,6 +477,10 @@ struct mpi3mr_throttle_group_info {
 /* HBA port flags */
 #define MPI3MR_HBA_PORT_FLAG_DIRTY	0x01
 
+/* IOCTL data transfer sge*/
+#define MPI3MR_NUM_IOCTL_SGE		256
+#define MPI3MR_IOCTL_SGE_SIZE		(8 * 1024)
+
 /**
  * struct mpi3mr_hba_port - HBA's port information
  * @port_id: Port number
@@ -1042,6 +1046,11 @@ struct scmd_priv {
  * @sas_node_lock: Lock to protect SAS node list
  * @hba_port_table_list: List of HBA Ports
  * @enclosure_list: List of Enclosure objects
+ * @ioctl_dma_pool: DMA pool for IOCTL data buffers
+ * @ioctl_sge: DMA buffer descriptors for IOCTL data
+ * @ioctl_chain_sge: DMA buffer descriptor for IOCTL chain
+ * @ioctl_resp_sge: DMA buffer descriptor for Mgmt cmd response
+ * @ioctl_sges_allocated: Flag for IOCTL SGEs allocated or not
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1227,6 +1236,12 @@ struct mpi3mr_ioc {
 	spinlock_t sas_node_lock;
 	struct list_head hba_port_table_list;
 	struct list_head enclosure_list;
+
+	struct dma_pool *ioctl_dma_pool;
+	struct dma_memory_desc ioctl_sge[MPI3MR_NUM_IOCTL_SGE];
+	struct dma_memory_desc ioctl_chain_sge;
+	struct dma_memory_desc ioctl_resp_sge;
+	bool ioctl_sges_allocated;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1ad2f88e0528..d8c57a0a518f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1058,6 +1058,114 @@ enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc)
 	return MRIOC_STATE_RESET_REQUESTED;
 }
 
+/**
+ * mpi3mr_free_ioctl_dma_memory - free memory for ioctl dma
+ * @mrioc: Adapter instance reference
+ *
+ * Free the DMA memory allocated for IOCTL handling purpose.
+
+ *
+ * Return: None
+ */
+static void mpi3mr_free_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
+{
+	struct dma_memory_desc *mem_desc;
+	u16 i;
+
+	if (!mrioc->ioctl_dma_pool)
+		return;
+
+	for (i = 0; i < MPI3MR_NUM_IOCTL_SGE; i++) {
+		mem_desc = &mrioc->ioctl_sge[i];
+		if (mem_desc->addr) {
+			dma_pool_free(mrioc->ioctl_dma_pool,
+				      mem_desc->addr,
+				      mem_desc->dma_addr);
+			mem_desc->addr = NULL;
+		}
+	}
+	dma_pool_destroy(mrioc->ioctl_dma_pool);
+	mrioc->ioctl_dma_pool = NULL;
+	mem_desc = &mrioc->ioctl_chain_sge;
+
+	if (mem_desc->addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
+				  mem_desc->addr, mem_desc->dma_addr);
+		mem_desc->addr = NULL;
+	}
+	mem_desc = &mrioc->ioctl_resp_sge;
+	if (mem_desc->addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
+				  mem_desc->addr, mem_desc->dma_addr);
+		mem_desc->addr = NULL;
+	}
+
+	mrioc->ioctl_sges_allocated = false;
+}
+
+/**
+ * mpi3mr_alloc_ioctl_dma_memory - Alloc memory for ioctl dma
+ * @mrioc: Adapter instance reference
+
+ *
+ * This function allocates dmaable memory required to handle the
+ * application issued MPI3 IOCTL requests.
+ *
+ * Return: None
+ */
+static void mpi3mr_alloc_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
+
+{
+	struct dma_memory_desc *mem_desc;
+	u16 i;
+
+	mrioc->ioctl_dma_pool = dma_pool_create("ioctl dma pool",
+						&mrioc->pdev->dev,
+						MPI3MR_IOCTL_SGE_SIZE,
+						MPI3MR_PAGE_SIZE_4K, 0);
+
+	if (!mrioc->ioctl_dma_pool) {
+		ioc_err(mrioc, "ioctl_dma_pool: dma_pool_create failed\n");
+		goto out_failed;
+	}
+
+	for (i = 0; i < MPI3MR_NUM_IOCTL_SGE; i++) {
+		mem_desc = &mrioc->ioctl_sge[i];
+		mem_desc->size = MPI3MR_IOCTL_SGE_SIZE;
+		mem_desc->addr = dma_pool_zalloc(mrioc->ioctl_dma_pool,
+						 GFP_KERNEL,
+						 &mem_desc->dma_addr);
+		if (!mem_desc->addr)
+			goto out_failed;
+	}
+
+	mem_desc = &mrioc->ioctl_chain_sge;
+	mem_desc->size = MPI3MR_PAGE_SIZE_4K;
+	mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
+					    mem_desc->size,
+					    &mem_desc->dma_addr,
+					    GFP_KERNEL);
+	if (!mem_desc->addr)
+		goto out_failed;
+
+	mem_desc = &mrioc->ioctl_resp_sge;
+	mem_desc->size = MPI3MR_PAGE_SIZE_4K;
+	mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
+					    mem_desc->size,
+					    &mem_desc->dma_addr,
+					    GFP_KERNEL);
+	if (!mem_desc->addr)
+		goto out_failed;
+
+	mrioc->ioctl_sges_allocated = true;
+
+	return;
+out_failed:
+	ioc_warn(mrioc, "cannot allocate DMA memory for the mpt commands\n"
+		 "from the applications, application interface for MPT command is disabled\n");
+	mpi3mr_free_ioctl_dma_memory(mrioc);
+}
+
 /**
  * mpi3mr_clear_reset_history - clear reset history
  * @mrioc: Adapter instance reference
@@ -3874,6 +3982,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		}
 	}
 
+	dprint_init(mrioc, "allocating ioctl dma buffers\n");
+	mpi3mr_alloc_ioctl_dma_memory(mrioc);
+
 	if (!mrioc->init_cmds.reply) {
 		retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
 		if (retval) {
@@ -4293,6 +4404,7 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	struct mpi3mr_intr_info *intr_info;
 
 	mpi3mr_free_enclosure_list(mrioc);
+	mpi3mr_free_ioctl_dma_memory(mrioc);
 
 	if (mrioc->sense_buf_pool) {
 		if (mrioc->sense_buf)
-- 
2.39.3


--0000000000005b783c060bc80f8d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDEdtED9Zj45VgZuf5zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTM0MzhaFw0yNTA5MTAwOTM0MzhaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOPMhBafUXswA97gXTj1d5WoUBuCuq3xszdg5lAM1AHavwkVYXn9nKUH
7QgAR6GV/PyPyloLcAeIkTarJRpxB885+xOyR4EAA8zRk9mirwq7GotMjSmRA81Ne5tpqZObHbsv
ELVogt2xoFkQFwDZznRDVQ1RRWO8gLU/7clg4TWqNxSsRF7PfM2U1sk6If8qHVMdtHLukGibl0Tv
4SxjDQ1M8uqWXeJcdYM4lQc+PSKyTNqPy/KLt1enu6lmA236FXBhPFSg3+EeZ9Ma7ZMj++uMpnwz
jLZb2F4wVMfuh/ZTi4ty6G3wQ/OIFcK4EkaKubAqreTT+LEu5XOFi10KHncCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
tI7aNGRrv6gHqOPkFli9EdvR2xcwDQYJKoZIhvcNAQELBQADggEBAI0Px1+MF4ubFWlBurQFxZRv
/K8V2fysp6NhKRpdJ43KozsApD438TU9DdNe8wW1MrCV3sRXZhlEkkukkfppzYRuoemmIdd4Rajh
Dh+uglOx3CYSKKOEWSbVIaDVMBQvVtqfZlGJgLRmLpO2agb8V/eY85IoMoM9hJkTll7OoTo+Lhon
W2v5XKnfV6+4iODhAb65bwLbcNq6dxzr1Yy/fGnIBfoR2qrX9UBDDxjZRpxJGdt7i0CcvsX7p2ia
SgP+hUBq9GTgLiFqCGyh/gCm2DTB/TyYel0QsIP29qWC1F5mG+GOoSjagi/2SxnNI6LzK+4xfgvc
80IlL0UapzuyZFExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHKj+AbR
4ypflvMZm7UnxA9KpcH7taNnJu1Wtr9Kovv8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMTIwNTE5MTUzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAz+fel2bPR9PMbHcGlpDx+Nl0g
B8E24rwtFh63wxruH0ATxAfG67sVvF+RQwZBoVdv/IVD2gOMtQRdIEvyux9f/sHvZOqqF1Zh7918
AMpABxdM9oe6UeZmT3kWTcdBLPl4SAkKMiAQeku93oTzl92Lrf14I0YPU6zR57CDKgi5WuwGrNC7
Q+sFBUQdL7ora8U/66SL4uGP0ctvkWc322rKSDDiu/Xr9LlCrk3IQQLSkIl1nogXZvVJV6AOioem
h/q+aItfxyZk/FwGBQPGEREcwP9KGOZRMNZyHQ8cQU75tIFm2alA8VR4v9djF2xrLYTfEO9z96Bu
xe2UdbQkZTLq
--0000000000005b783c060bc80f8d--
