Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EdsgweIC"
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1ACB0
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 11:16:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-286f8ee27aeso547313a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2023 11:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1701803760; x=1702408560; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HvpPftlvc5hzJYsZK3pE8dYogAS73Lb3IbYkPkQgScc=;
        b=EdsgweICdYxt2Agwa4AA/+FOzw7j4fn49iocZA9CM3xVhiLHnTBqI9XaVsb4coWnKz
         5v0/wDNkLnnPZuUTkg/6BrHK53Ig5QjSppySpQLKi1M/qvLuxffIf5ngeIrZHQaXvQzF
         fOn/WCUIvvkI9/zvMifWkmO0c/XrzQDqa0Yf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701803760; x=1702408560;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HvpPftlvc5hzJYsZK3pE8dYogAS73Lb3IbYkPkQgScc=;
        b=ZLCtTotZqaB2oulHH3P24W6jyNPOBED8e57VXcb8BvJhHVAjaG/SPRy5HtGca8wgGN
         a2iXCizfC3sksmAym59PjLJ44l+8IO0tb51NrZv26hfHFxpCIpfWiMxb4hAlLaPlOZea
         aexW5nXZ4N09yEfO+mhW0BZr7LwoDHJBgBQv78gUZDXDqrqbVnqVVgsf11/utfr7pVeN
         M1v1d2NM2ap6WjfUaTI2WCYGwpaMnOEWYpAE5a7+6HKfwxG59tPrI+yPux6S6E8XFxfa
         tJe9luA+F/zgwn0KIatjK4Ya+l+AO8FyIQ1jH4iBCre/QN25fsiUZDe3mI3prln7GCBH
         zmJw==
X-Gm-Message-State: AOJu0YzqyoHpxNpoU4wE/8LY48J135eeeiLUCe3xeDmGwdTDCVG0f8df
	EBMb6mzVztWGRZD8hH2AjuziwS58OIB/i0E1GJY39EpxM0FzuqfFp8YhxF5OwjcQjvhgV5K3m5o
	WiCILbaylnqPxUj55e+Fg8NvSRN9OhazLgWU8CMAFPCgha5xwKEGzIbSGLtDNKPCeHulem0gQ0e
	wkTOCuEtR+9LYeOubN+Q==
X-Google-Smtp-Source: AGHT+IG3L9qIE5quDaIE8q95/JGWu/TZv8brCbeci2dz9PCHG5e+K7xUn0tsWdBr6O8DvEYdIQEswA==
X-Received: by 2002:a17:90b:4f90:b0:286:e5c7:c218 with SMTP id qe16-20020a17090b4f9000b00286e5c7c218mr1173990pjb.49.1701803760268;
        Tue, 05 Dec 2023 11:16:00 -0800 (PST)
Received: from dhcp-10-123-20-35.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a199000b0028017a2a8fasm10801896pji.3.2023.12.05.11.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 11:15:58 -0800 (PST)
From: Chandrakanth patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	sumit.saxena@broadcom.com,
	sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 3/4] mpi3mr: Support for preallocation of SGL BSG data buffers part-3
Date: Wed,  6 Dec 2023 00:46:29 +0530
Message-Id: <20231205191630.12201-4-chandrakanth.patil@broadcom.com>
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
	boundary="000000000000a2fd4e060bc81073"

--000000000000a2fd4e060bc81073
Content-Transfer-Encoding: 8bit

The Driver acquires the required NVME SGLs from the pre-allocated
pool.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h        |  10 ++-
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 124 ++++++++++++++++++++++------
 include/uapi/scsi/scsi_bsg_mpi3mr.h |   2 +
 3 files changed, 109 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dfff3df3a666..795e86626101 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -218,14 +218,16 @@ extern atomic64_t event_counter;
  * @length: SGE length
  * @rsvd: Reserved
  * @rsvd1: Reserved
- * @sgl_type: sgl type
+ * @sub_type: sgl sub type
+ * @type: sgl type
  */
 struct mpi3mr_nvme_pt_sge {
-	u64 base_addr;
-	u32 length;
+	__le64 base_addr;
+	__le32 length;
 	u16 rsvd;
 	u8 rsvd1;
-	u8 sgl_type;
+	u8 sub_type:4;
+	u8 type:4;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index e8b0b121a6e3..4b93b7440da6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -783,14 +783,20 @@ static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt)
 {
 	struct mpi3mr_nvme_pt_sge *nvme_sgl;
-	u64 sgl_ptr;
+	__le64 sgl_dma;
 	u8 count;
 	size_t length = 0;
+	u16 available_sges = 0, i;
+	u32 sge_element_size = sizeof(struct mpi3mr_nvme_pt_sge);
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
 	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
 			    mrioc->facts.sge_mod_shift) << 32);
 	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
 			  mrioc->facts.sge_mod_shift) << 32;
+	u32 size;
+
+	nvme_sgl = (struct mpi3mr_nvme_pt_sge *)
+	    ((u8 *)(nvme_encap_request->command) + MPI3MR_NVME_CMD_SGL_OFFSET);
 
 	/*
 	 * Not all commands require a data transfer. If no data, just return
@@ -799,27 +805,59 @@ static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
 	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
 		if (drv_buf_iter->data_dir == DMA_NONE)
 			continue;
-		sgl_ptr = (u64)drv_buf_iter->kern_buf_dma;
 		length = drv_buf_iter->kern_buf_len;
 		break;
 	}
-	if (!length)
+	if (!length || !drv_buf_iter->num_dma_desc)
 		return 0;
 
-	if (sgl_ptr & sgemod_mask) {
+	if (drv_buf_iter->num_dma_desc == 1) {
+		available_sges = 1;
+		goto build_sges;
+	}
+
+	sgl_dma = cpu_to_le64(mrioc->ioctl_chain_sge.dma_addr);
+	if (sgl_dma & sgemod_mask) {
 		dprint_bsg_err(mrioc,
-		    "%s: SGL address collides with SGE modifier\n",
+		    "%s: SGL chain address collides with SGE modifier\n",
 		    __func__);
 		return -1;
 	}
 
-	sgl_ptr &= ~sgemod_mask;
-	sgl_ptr |= sgemod_val;
-	nvme_sgl = (struct mpi3mr_nvme_pt_sge *)
-	    ((u8 *)(nvme_encap_request->command) + MPI3MR_NVME_CMD_SGL_OFFSET);
+	sgl_dma &= ~sgemod_mask;
+	sgl_dma |= sgemod_val;
+
+	memset(mrioc->ioctl_chain_sge.addr, 0, mrioc->ioctl_chain_sge.size);
+	available_sges = mrioc->ioctl_chain_sge.size / sge_element_size;
+	if (available_sges < drv_buf_iter->num_dma_desc)
+		return -1;
 	memset(nvme_sgl, 0, sizeof(struct mpi3mr_nvme_pt_sge));
-	nvme_sgl->base_addr = sgl_ptr;
-	nvme_sgl->length = length;
+	nvme_sgl->base_addr = sgl_dma;
+	size = drv_buf_iter->num_dma_desc * sizeof(struct mpi3mr_nvme_pt_sge);
+	nvme_sgl->length = cpu_to_le32(size);
+	nvme_sgl->type = MPI3MR_NVMESGL_LAST_SEGMENT;
+	nvme_sgl = (struct mpi3mr_nvme_pt_sge *)mrioc->ioctl_chain_sge.addr;
+
+build_sges:
+	for (i = 0; i < drv_buf_iter->num_dma_desc; i++) {
+		sgl_dma = cpu_to_le64(drv_buf_iter->dma_desc[i].dma_addr);
+		if (sgl_dma & sgemod_mask) {
+			dprint_bsg_err(mrioc,
+				       "%s: SGL address collides with SGE modifier\n",
+				       __func__);
+		return -1;
+		}
+
+		sgl_dma &= ~sgemod_mask;
+		sgl_dma |= sgemod_val;
+
+		nvme_sgl->base_addr = sgl_dma;
+		nvme_sgl->length = cpu_to_le32(drv_buf_iter->dma_desc[i].size);
+		nvme_sgl->type = MPI3MR_NVMESGL_DATA_SEGMENT;
+		nvme_sgl++;
+		available_sges--;
+	}
+
 	return 0;
 }
 
@@ -847,7 +885,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 	dma_addr_t prp_entry_dma, prp_page_dma, dma_addr;
 	u32 offset, entry_len, dev_pgsz;
 	u32 page_mask_result, page_mask;
-	size_t length = 0;
+	size_t length = 0, desc_len;
 	u8 count;
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
 	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
@@ -856,6 +894,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			  mrioc->facts.sge_mod_shift) << 32;
 	u16 dev_handle = nvme_encap_request->dev_handle;
 	struct mpi3mr_tgt_dev *tgtdev;
+	u16 desc_count = 0;
 
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
 	if (!tgtdev) {
@@ -874,6 +913,21 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 
 	dev_pgsz = 1 << (tgtdev->dev_spec.pcie_inf.pgsz);
 	mpi3mr_tgtdev_put(tgtdev);
+	page_mask = dev_pgsz - 1;
+
+	if (dev_pgsz > MPI3MR_IOCTL_SGE_SIZE) {
+		dprint_bsg_err(mrioc,
+			       "%s: NVMe device page size(%d) is greater than ioctl data sge size(%d) for handle 0x%04x\n",
+			       __func__, dev_pgsz,  MPI3MR_IOCTL_SGE_SIZE, dev_handle);
+		return -1;
+	}
+
+	if (MPI3MR_IOCTL_SGE_SIZE % dev_pgsz) {
+		dprint_bsg_err(mrioc,
+			       "%s: ioctl data sge size(%d) is not a multiple of NVMe device page size(%d) for handle 0x%04x\n",
+			       __func__, MPI3MR_IOCTL_SGE_SIZE, dev_pgsz, dev_handle);
+		return -1;
+	}
 
 	/*
 	 * Not all commands require a data transfer. If no data, just return
@@ -882,14 +936,26 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
 		if (drv_buf_iter->data_dir == DMA_NONE)
 			continue;
-		dma_addr = drv_buf_iter->kern_buf_dma;
 		length = drv_buf_iter->kern_buf_len;
 		break;
 	}
 
-	if (!length)
+	if (!length || !drv_buf_iter->num_dma_desc)
 		return 0;
 
+	for (count = 0; count < drv_buf_iter->num_dma_desc; count++) {
+		dma_addr = drv_buf_iter->dma_desc[count].dma_addr;
+		if (dma_addr & page_mask) {
+			dprint_bsg_err(mrioc,
+				       "%s:dma_addr 0x%llx is not aligned with page size 0x%x\n",
+				       __func__,  dma_addr, dev_pgsz);
+			return -1;
+		}
+	}
+
+	dma_addr = drv_buf_iter->dma_desc[0].dma_addr;
+	desc_len = drv_buf_iter->dma_desc[0].size;
+
 	mrioc->prp_sz = 0;
 	mrioc->prp_list_virt = dma_alloc_coherent(&mrioc->pdev->dev,
 	    dev_pgsz, &mrioc->prp_list_dma, GFP_KERNEL);
@@ -919,7 +985,6 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 	 * Check if we are within 1 entry of a page boundary we don't
 	 * want our first entry to be a PRP List entry.
 	 */
-	page_mask = dev_pgsz - 1;
 	page_mask_result = (uintptr_t)((u8 *)prp_page + prp_size) & page_mask;
 	if (!page_mask_result) {
 		dprint_bsg_err(mrioc, "%s: PRP page is not page aligned\n",
@@ -1033,18 +1098,31 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			prp_entry_dma += prp_size;
 		}
 
-		/*
-		 * Bump the phys address of the command's data buffer by the
-		 * entry_len.
-		 */
-		dma_addr += entry_len;
-
 		/* decrement length accounting for last partial page. */
-		if (entry_len > length)
+		if (entry_len >= length) {
 			length = 0;
-		else
+		} else {
+			if (entry_len <= desc_len) {
+				dma_addr += entry_len;
+				desc_len -= entry_len;
+			}
+			if (!desc_len) {
+				if ((++desc_count) >=
+				   drv_buf_iter->num_dma_desc) {
+					dprint_bsg_err(mrioc,
+						       "%s: Invalid len %ld while building PRP\n",
+						       __func__, length);
+					goto err_out;
+				}
+				dma_addr =
+				    drv_buf_iter->dma_desc[desc_count].dma_addr;
+				desc_len =
+				    drv_buf_iter->dma_desc[desc_count].size;
+			}
 			length -= entry_len;
+		}
 	}
+
 	return 0;
 err_out:
 	if (mrioc->prp_list_virt) {
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index 907d345f04f9..c72ce387286a 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -491,6 +491,8 @@ struct mpi3_nvme_encapsulated_error_reply {
 #define MPI3MR_NVME_DATA_FORMAT_PRP	0
 #define MPI3MR_NVME_DATA_FORMAT_SGL1	1
 #define MPI3MR_NVME_DATA_FORMAT_SGL2	2
+#define MPI3MR_NVMESGL_DATA_SEGMENT	0x00
+#define MPI3MR_NVMESGL_LAST_SEGMENT	0x03
 
 /* MPI3: task management related definitions */
 struct mpi3_scsi_task_mgmt_request {
-- 
2.39.3


--000000000000a2fd4e060bc81073
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
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL43bJh9
zB8rnv0SapnzkGhXaWweohl/GOvCEHHPNveGMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMTIwNTE5MTYwMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAA66e6gjKFHoCxhXCwZXbAEPBr
rT5g9CIW0RUX/aFe0DQxCzbU7Wg55Uv/qkfqAoOVFPG8Z7gebqaaFZ7vG+l2EyjWFemQgBYINLfu
f2cYihsP3W6pHmmYO//kbmqBN50zQPQzIjPVfLMLn2lLP36vsO1IukztNYhqOdP9dSHLxIuc1fZI
9C+sm7LklobkBsgqK0mL2dZ8+XbACpUTHqJqEVlprd5rCzHWvgmuYyR/vQ69iCUXplG0+e4I1r2K
1Yhh2ecPaySHslpYTtVy2Ck7DVDejS4A+GYMxAaJ8/ZWyd0HG7zePqcGNkWlK4dxBuZ/1TMn6gSm
6kbKVI6It+rM
--000000000000a2fd4e060bc81073--
