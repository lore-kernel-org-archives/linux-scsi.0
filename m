Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915DD380FF8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474524; cv=none; b=pCLNbE+CyAJNS2wh6gpo9WCJB0mUEU0q7HkIooVXEhgcXlk9j0OH1dVm3Wxm04m1MnDk7sUG0q74Mp7Wjn2uwDKAtMnzDT9lDukiy2p3wUk3UFwH1TS8dSqPoE/6BodmM6KXujGPVbgy1fMCXFpYXDzaRuhk0QSdltPDrsE8yqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474524; c=relaxed/simple;
	bh=puHPYW3u4oU72VFujP8J1sfjVqb/7L1fuhl6ZvMALOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEBud0COwvXVRzPeF35a/TAmwgh8+tOO8s8sTX1xj3is2vQfYYKUsbtg0bRm/ukTZ8TL0/wfEhf/alL4QK+nw/GtUdXFKTOJXSK8We+YpvZqqLEth/VVJq0tJSTPPIjl6Cfnf4TMthpCJuxyL4RSwdRtBKB7jbLBj2k5VTliZrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YMcD5jCT; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YMcD5jCT"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-66481f17a4cso886962d50.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474522; x=1783079322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H8e7n8DGft+9hLEiNhXLfDJsXwyxoiNr76VVZ9WVl6o=;
        b=F1BtSd829oE5zP/9uCj+i3RgXDaoEj+xXbcRImnzhgz02rJWsOHELwQcZW+FsDt/EB
         SdvS1Mr1uyOADOO9CHHAfutsN4jY0ceIqF9P6yIO9kgI7EDWE7iK88WRUy2TQGTwp7t0
         ulYs8JHafxxf9bioVFgzNiWX4QpQbf2KHHH+Kojkc9BLEP9spFKXSOFXmNEkxxPJAxYD
         XRw87AZCwIu2Mbpeb5i32wJhFxBgz4UErSsfPVJE6QdRfal6lH3uYf8bl3/XZuxTtMV4
         582uYZOdnhg0Txeux5KX8dcQJEkJQFi7cAF5rk2s8qoVD1sykIC6RglZxhFEpnZf9/vf
         yfoQ==
X-Gm-Message-State: AOJu0YyMChezw69pSMWQZyR1ICz69CIGVkZQLr3hWabJlKZOYptrv/uf
	umgSpEltSFLEbX18Lll8ItJ0qhc7xnA/VV+yxYQxvsw19E+g8ibCW+MTmo311IfSS9Zoj0nBEyp
	hyavkAlXBwPyD1pQMAXMmmhZyYZPDWk9G/R6HuTZuZl5i0jY7R2gU94S3xK2tTN8ozB7WM8shNh
	osFfre79iNn8db0zo3ZDcde1lXplHVaxLmbaRlzFeB5ito1KuWjVkGrH/JL1lLc+MVV3IrRokKp
	8EJF4yf3ZBBxNEO
X-Gm-Gg: AfdE7ck8ML6/f85n6zTZmSk2XCasnCfrjBk/zQPSatIlgOtZUI4Pk0PjVGzliyW5fJr
	tPRsGB8ru2TK623ucV3RuZGYEAi+LdvwCte9S4boYfcPfsE0jQ3pDycaf7gV74Q8LTwQLLBAoFf
	IVLxU25KOau3oadegAgaT95H+4aRgtYHvAnUerDIMiLOIvMk1Ze77hEQrco1G6fu2mLT45aBb1T
	2HBBmmMOpzFSHt9fRYgvNjkG7kNzewbheX36syj3s6sfhrOmUT6Iv/PXhIN+/94MhUEu3otn2Y1
	lRmXcYq9aje4xDdeiPk1DNl7ViJ39o3SRqi8pzfaBZpTpq6iwyCqjHJWHurnhZrUGLjKqR+Zza6
	htmSvJ8JpiMbHXxowjcVQrdXbdXqQQbfhxFAVjZ8m55T2atzIEzR40T2105xPigrcb0kzP208yR
	TZ9LlQEIBvx3ZGay4j64Sx3ASWN+vtxjZreNwGnrj1UnGDyw==
X-Received: by 2002:a05:690e:438b:b0:664:ae87:c771 with SMTP id 956f58d0204a3-664ae87cd64mr8331d50.37.1782474522541;
        Fri, 26 Jun 2026 04:48:42 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-664aaa43154sm30547d50.23.2026.06.26.04.48.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:42 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c5b9f6a51so599743eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474521; x=1783079321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8e7n8DGft+9hLEiNhXLfDJsXwyxoiNr76VVZ9WVl6o=;
        b=YMcD5jCTo3JZTUL7J3xa0yfceICzJqq3WEUn66oAJQMpNEZGYGd6aw6QyrPEudE0n2
         KGXSXdCJ0r7G4nHJSwRqsThNqRnBnTxii1wqZwe3mmXV2nAAq6rG1SPvZxNkX7OrsXlD
         WlenPzPfXfI+FAzwA6IHRMwf3h9J/d964BIWw=
X-Received: by 2002:a05:7300:8191:b0:304:ddc3:2c35 with SMTP id 5a478bee46e88-30c85a603a0mr5586874eec.10.1782474520633;
        Fri, 26 Jun 2026 04:48:40 -0700 (PDT)
X-Received: by 2002:a05:7300:8191:b0:304:ddc3:2c35 with SMTP id 5a478bee46e88-30c85a603a0mr5586822eec.10.1782474519445;
        Fri, 26 Jun 2026 04:48:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:39 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 04/10] mpi3mr: Fix NVMe page size caching for non-operational devices
Date: Fri, 26 Jun 2026 17:11:03 +0530
Message-ID: <20260626114109.43685-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

For NVMe devices reported with an error access status,
the cached PCIe page size may remain unset during device discovery.
This causes management IOCTL validation to fail, preventing requests
from reaching firmware and resulting in an incorrect error
being returned to user space.

Populate the page size attribute irrespective of device access status
so that management IOCTLs are processed by firmware and the appropriate
device-specific error is reported.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d2a20f2721db..e361fbb8f723 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1354,12 +1354,10 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		tgtdev->dev_spec.pcie_inf.capb =
 		    le32_to_cpu(pcieinf->capabilities);
 		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
-		/* 2^12 = 4096 */
-		tgtdev->dev_spec.pcie_inf.pgsz = 12;
+		tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->page_size;
 		if (dev_pg0->access_status == MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
 			tgtdev->dev_spec.pcie_inf.mdts =
 			    le32_to_cpu(pcieinf->maximum_data_transfer_size);
-			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->page_size;
 			tgtdev->dev_spec.pcie_inf.reset_to =
 			    max_t(u8, pcieinf->controller_reset_to,
 			     MPI3MR_INTADMCMD_TIMEOUT);
-- 
2.47.3

