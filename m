Received: from mail-vk1-f226.google.com (mail-vk1-f226.google.com [209.85.221.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097845FFAC
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075848; cv=none; b=TPyhXJODPV+ytQdo7lNR0Y2e75j5h4vSmAwNMi6WspArHi3lg875jFQLtJkgkwv/8EA/XMCc5enscPyi7KTOHXQkWOWl0WWapMX3wM4YAWM7FK8Yr6KromM6+IiKlr2+pDNkUHLNjtBw+HduSdg5jzlEtmkoPpJTooDcMql6PyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075848; c=relaxed/simple;
	bh=6ziRugLflMJHayMNYe6ZdDUz7u02kvfu3W7+IiKEKkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaYrLvJ12a0BouEtkt4oYuTQ7HBcY8iOAqOJkmpox9ICgGtv05l0ccbLpGnbCGM0zK5mLZaRuws8qQStSDnmrG0+vSrR+QT/POKnuy38fBNezqIOvHs+Z50W8yBc7BcAqQ1nmDALNdRaAdfRNPtvHR4htjQEieiIIlsgHzYfkgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YXk5Prw3; arc=none smtp.client-ip=209.85.221.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YXk5Prw3"
Received: by mail-vk1-f226.google.com with SMTP id 71dfb90a1353d-5c2dbaf828eso64573e0c.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075846; x=1787680646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OSsDuiMdSBAbrK0w67IaYnRXeq0kyEM4pbNev1dsX/c=;
        b=AMFAtXzcNV3+FaCgr/HUvKClTA6gy//KPr7TUDvnUCqt27qXNXjlw9sCkiGP5Edq4E
         85KcvQvSRdYUNVrjOP57JSk0b3xPIAZS+8lExrGLVWzvmze3Q3Umiu56x3usrt37iGaN
         eTjCdb4EHkNv4GYM+iYdXMw3LLPF0QdmKLps166ActavC7m5ZdRzqrtxFOWSGAf+dDZ1
         VWWkfFxv9yYWISV3CNY8UWlpI3V1yPwUCmotLzKGAl95nvbBpaj/yXFZNjbOfWplIsW9
         LmM9wOKev/X3eYsNdZ64a4d55ryIV7WtbiENsT5zltQGYL6Ks3PLCMlM/WlTv7UPTRaF
         4y3Q==
X-Gm-Message-State: AOJu0YwPGlgyKG8gFux4Y+vXTGBnoH+AnrNF02w3Dlm+vptyCsNIoaiC
	ey1o3DyWFPBzoZdaWRs7B1WOpEzQxN4nG1rZdaM8cpbaPbpdOIWfHHK4CcvzhltlrYk4EzOo8BY
	4XMMzaBfDaXkkRSmURiLRpB3px+X0/6780Lf7i7taBkHeqQea8Hk2Tmwv6SlpwjZsRSyjIXu5H3
	uAmkdhTeKuPtV8kxQM2gGpMeEBNtS3qj8wzWomUMvAXitmFAsAUinftNd7AH9O1D+PQByIIorGB
	WZmNjo6nFeF4ppin+J971k/
X-Gm-Gg: AR+sD10MOcj9/+i6RALsbBnD8c88PXG3V1fDRUO52Ruk17ITgzZuD1JTk5koYDD2SL0
	if/oMApW+6AJHL04HdQt/xQCzcDcgl/Q5yyAbj6znUbhsrcXs87TtpH43eovj2bRuk2F8NosDPn
	k6XT2pL6vaW5sYRE1Eo0fV85TbBupRlLVD9ZRc6G1ruoDGRbLSpGrK51c/erjj2QP0aWllPE5AD
	n+0JoRcvoSMSuy62AG6HNJg4nJ/AYCvVKAmrBweLUdEAyifyAiebi0uaCFCSqmnKfI2t7pLbu3e
	a0hl3z5visJvULZ+/11dZ15DwcwjkdOWaDYUzHsAgmERFE27lkC/QodYlL/fGkjF43gdMMxnWMA
	UvdOsNwGCkyciNhF7z+hNcCh/hoRmeF20DkGPg+/+NekZsyNpsi9sc7pNuM3I4JlM8gXkoQkU4o
	DEuyrPaS+CyBmi1XmdaTSqA8uaLrvh9RtDE4SZrdL8dvo=
X-Received: by 2002:a05:6122:4f86:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5c591d13efdmr7986013e0c.6.1787075846183;
        Tue, 18 Aug 2026 10:57:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c5c7826fd8sm1171079e0c.4.2026.08.18.10.57.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so297911a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075845; x=1787680645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OSsDuiMdSBAbrK0w67IaYnRXeq0kyEM4pbNev1dsX/c=;
        b=YXk5Prw3ndN2GTn6vylH0/64fvfCapTUJtrEEk/Bm2ChC6EO4UsLZrs7pDsoLzpBCL
         4CxgZxoKSd4heMtmRBjsECx4bEHCqFBj42U34htsBWEXzbcN7jWqlWrgnBjeJhSfCgS+
         qsFXSrEsm75++W/XuQa5al/j8NlCB2Cp2/9vg=
X-Received: by 2002:a17:90b:3841:b0:380:f34a:6ff1 with SMTP id 98e67ed59e1d1-3933b9483c7mr31037328a91.17.1787075844873;
        Tue, 18 Aug 2026 10:57:24 -0700 (PDT)
X-Received: by 2002:a17:90b:3841:b0:380:f34a:6ff1 with SMTP id 98e67ed59e1d1-3933b9483c7mr31037253a91.17.1787075844322;
        Tue, 18 Aug 2026 10:57:24 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:23 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 07/17] mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 19 Aug 2026 04:44:16 +0530
Message-ID: <20260818231426.58105-8-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The sense buffer address reported on completion is turned into a
virtual address with no range check, so an address outside the pool
resolves to memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5e61448d8dbc..103ce9dd2266 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -141,6 +141,12 @@ void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_ioc *mrioc,
 	if (!phys_addr)
 		return NULL;
 
+	if (phys_addr < mrioc->sense_buf_dma ||
+	    (phys_addr > mrioc->sense_buf_dma +
+	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_SZ) ||
+	    ((phys_addr - mrioc->sense_buf_dma) % MPI3MR_SENSE_BUF_SZ))
+		return NULL;
+
 	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
 }
 
