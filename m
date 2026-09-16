Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89414749DE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547741; cv=none; b=aXHwF9zqG3iRATxOEqIZtUwo7lc4C0opQnibaPNIMUFrM0/oEGtg53gFzBtK7mO9f92i2eztU/oG6g0H9EoZOvSf/iVb6b6+vDRIARJt2c6Tn8Okikdmu9Vc6AadsZuQIGX6DzpSGhxcCAbs2Q7SWv7neQGG3tXYBVID/r7E7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547741; c=relaxed/simple;
	bh=stjG6sw6jAD23KEs/3UjrQ5Se9ZKRQNXYcKrmPSs49A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGQoK6QyCFJSbi6Px5zJtuqqlGOZD5OAZPq0DDqMcd0ZIcsj+mRKFh9+OhWxs8nLUSfKFF2vCUcmAOTgnuRPXrmlvneu1XSkBDy1AVucODMpV/lAi6O57SOxZS1OrR6J+Em2yHC4GVaM6urdRS/c4PRhdUQP+mLHp9DI6ma+QZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=B3udMOpk; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="B3udMOpk"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2dd479126ddso13024925ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547739; x=1790152539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bIKpG9humFnpTPqQv5b4E+pj4fNVBwBXLlcuMpjnn+M=;
        b=fDJ4J1ax6v58aa8GhxTQZcB2WawFLJKukZe+sXCU0XvE+aHmNfeaeSi8WlsurgTpru
         C+AnUklAQGUeJnDbGyqBdy+p6qO7fVApOjc6MSiQ8nCN890ORInoP7us5pTzkEMChPpl
         bgZcou94x4oXxUF+Hp13oSBbauwydIhr029grGRnGyQt6/Ak9Hmcww0W7KzL0AoUwJc3
         wkiBwyUCtBgmTfW/ke137UaBsm+HsIMpSOn6VdW9SbcWsbpBw5RJYyHwLhyXFYwVNh7V
         LI2dacQwxwlXPePcizw3DWv5vdb1OI/w+k6AjXPchKAi1pifdxHgdFtpDgKwW6KCazbl
         rZCg==
X-Gm-Message-State: AFuF++noidyMC8wzEY+NdoQbDk6ttzQZ2trk4FORjvedd3hg/mlY63Mh
	Tz0jg4kN916ACFOX9A3TEYdS2jp+2/CZTVLzPi+tmW47AA/Fr7tF9i0of+NLWTen9dUS7V0QA0H
	gVBg0fec36bG1mnUvX5odLnJ7RIVdZx10UhbIMMoh+sCQjZN7Oj9hncWAexwv09/bOUw1jDE/iF
	2QwSoj2ZnkFHxtm93o9tWRLCVzSmxh5RLXEQ5QGR/FcENja+UBHzE5FpOlDtnutCA32HXLd+uHZ
	VJFAuDIYWDMVzkT
X-Gm-Gg: AYBFou3O7x/IVLa6MxkzEkreJYWFxTW1yXyL2HMuC8NpAWPsF8hkDmoROrb/nbY0x/9
	OcQTlisR1pWvRIgyKWsoK+M+1MwrmpfZ5bsAulJmedjJF0f5pVM9K0WLfQAgs+gWOM4Xba/1fZ3
	05Ikx03DJz6/0DWZyr4pL6Uo1v84yvQ65zMMuEmVxc3x6F2f7DJ9oVGBCAYxyqCuSFmB+J8RKcW
	ysvehZrvit2AEHtDX5glUW0DQjeTik8WbVQ+7irMGsoKcMxWD+GE577XQQ4mQLFWRfjwZr89uLW
	tbcun/+4fFLZzx1wxGiXbIS0cceF/HlDsWQrq02skcjvFA65+KZGsl2TYO9YwDsF/UpVb9V0xf1
	4rbDhBzuAj7sXB/o3KaCqyozbhND2+vDIXh27izTqvSdJ0VO79wS/9qmaY01IX/st7eQ7+4spg7
	4LHLuvoQsqGdeclJXk8UfXEu1WbGwHriF8FgM=
X-Received: by 2002:a17:90a:58f:b0:39e:21a7:5dfe with SMTP id 98e67ed59e1d1-39e21a761damr2554328a91.3.1789547738976;
        Wed, 16 Sep 2026 01:35:38 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-98.dlp.protect.broadcom.com. [144.49.247.98])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e1c233d1csm220222a91.3.2026.09.16.01.35.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-395543dc382so7352172a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547737; x=1790152537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bIKpG9humFnpTPqQv5b4E+pj4fNVBwBXLlcuMpjnn+M=;
        b=B3udMOpkSZrfOTj4Q+NjGpUb/OAXQT+n9jKyao55Jr7cKqcQQOCxcRgRL29sEyYSSA
         1GCsPqVC/XNrR3UkCkXU22Q6Z2lm/wQvJYSAd+0kxrDktOHoRBwsddYu79nGZFF0er6a
         FMrLOCILeRNI8En1zstUrIpHw0XVqWs4WhnKc=
X-Received: by 2002:a17:90b:390d:b0:39d:f66e:1720 with SMTP id 98e67ed59e1d1-39e1e4907e8mr4136112a91.13.1789547736781;
        Wed, 16 Sep 2026 01:35:36 -0700 (PDT)
X-Received: by 2002:a17:90b:390d:b0:39d:f66e:1720 with SMTP id 98e67ed59e1d1-39e1e4907e8mr4136029a91.13.1789547736143;
        Wed, 16 Sep 2026 01:35:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:35 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 08/10] mpi3mr: Fix SAS port allocation and registration error handling
Date: Wed, 16 Sep 2026 13:57:03 +0530
Message-ID: <20260916082705.44712-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

During SAS port creation, the driver does not verify successful port
allocation before attempting registration, which can lead to a NULL
pointer dereference. Additionally, if registration fails, the allocated
port is not freed, resulting in a memory leak.

Fix this by adding a NULL check after allocation and freeing the port
when registration fails.

Additional fixes in the error handling path include:

1. Fixing similar missing NULL checks for rphy allocations.
2. Cleaning up after a failed rphy registration tried to remove a
   device that was never added, causing a crash. The rphy is now
   freed directly instead.
3. A failed rphy registration left the target device with a dangling
   pointer and a stuck pending flag. Both are now cleared.
4. Phys removed on error kept an internal flag set, permanently
   blocking them from being added to a port again. Now cleared
   alongside the list removal.
5. Could block in the SCSI mid-layer after a stop or reset had
   already begun, the same ABBA deadlock class fixed elsewhere. The
   port allocation path now stops before that call once that is
   detected.
6. The same reset check on the port removal path caused a memory
   leak and a kernel BUG() on rediscovery.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=8
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=8
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=8
Closes: https://sashiko.dev/#/patchset/20260805110634.346670-1-ranjan.kumar@broadcom.com?part=8
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 46 +++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index be794fe8eb7d..0dacfae6fa9d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1436,9 +1436,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s() (sas_port_alloc)!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
 
@@ -1458,14 +1464,32 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mr_sas_port->port = port;
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		rphy = sas_end_device_alloc(port);
+		if (!rphy) {
+			ioc_err(mrioc, "failure at %s:%d/%s() (sas_end_device_alloc)!\n",
+			    __FILE__, __LINE__, __func__);
+			sas_port_delete(port);
+			goto out_fail;
+		}
 		tgtdev->dev_spec.sas_sata_inf.rphy = rphy;
 	} else {
 		rphy = sas_expander_alloc(port,
 		    mr_sas_port->remote_identify.device_type);
+		if (!rphy) {
+			ioc_err(mrioc, "failure at %s:%d/%s() (sas_expander_alloc)!\n",
+			    __FILE__, __LINE__, __func__);
+			sas_port_delete(port);
+			goto out_fail;
+		}
 	}
 	rphy->identify = mr_sas_port->remote_identify;
 
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (mrioc->stop_drv_processing || mrioc->reset_in_progress) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		sas_rphy_free(rphy);
+		sas_port_delete(port);
+		goto out_fail;
+	}
 	if (mrioc->current_event)
 		mrioc->current_event->pending_at_sml = 1;
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
@@ -1473,6 +1497,18 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+		if (mrioc->current_event) {
+			mrioc->current_event->pending_at_sml = 0;
+			discard = mrioc->current_event->discard;
+		}
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		if (discard)
+			mpi3mr_print_device_event_notice(mrioc, true);
+		sas_rphy_unlink(rphy);
+		sas_rphy_free(rphy);
+		sas_port_delete(port);
+		goto out_fail;
 	}
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 0;
@@ -1511,9 +1547,17 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	return mr_sas_port;
 
  out_fail:
+	if (tgtdev) {
+		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 0;
+		tgtdev->dev_spec.sas_sata_inf.rphy = NULL;
+		mpi3mr_tgtdev_put(tgtdev);
+	}
+
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
-	    port_siblings)
+	    port_siblings) {
+		mr_sas_phy->phy_belongs_to_port = 0;
 		list_del(&mr_sas_phy->port_siblings);
+	}
 	kfree(mr_sas_port);
 	return NULL;
 }
-- 
2.47.3

