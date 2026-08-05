Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E742FCB3
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928481; cv=none; b=MWz0FK6Jl8P2KaYDYhPbCCdOLsjz1mEFTYL4tcfohkfoIUDdRMB6QTJz2iylxqx0ROp6H1uFIwhZuihMqbyuwrDMMSNPG/DNr6U4dUrCuFlAM1ABTOGWNCqyII4HyiA+iJ9PHCLP9HCrPRddhpLQmLApiZdIBiCwbh31tj5xeHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928481; c=relaxed/simple;
	bh=SKca8G0LlfQoXXMl18TS5FNaFeBXIQcCk8dDffVBZME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzL0muEY5R+Ko0xVxmbH+Imw1Hnkvc1b8KUEqjuqRquro5UYHamjpTdHBZYX5Oyoa6VyfkWAbpap0Hx33KBdZXwbE9ZtaTeTGIMcUj7abd0T25BRVH5MrJzbo6j9frf/L/fdps4Hqg5LRuw3iSI1Cmk2UWQYWgI8nmNnhnoFEpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bQ4fm8vE; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bQ4fm8vE"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-382ef647e20so895823a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928479; x=1786533279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3tdZJHSOtLJa5wo+nrOu3wCPkHQdIffb/zLiy/3bAbc=;
        b=F8q/xOWKPPd6V3IEToUuHoCIMvsHfralo9xwagHzibbH18nOCQgW9m9MeI9ZA0N74m
         Qo7ZTzr8Ps6AgoOQG5mbhASNVhoSkiuzH4bm4x/eD6r5X9er2tTH29788fkiZ/Pj9T1h
         NrKjYJqbMkhcLyWoYpoWY8tWlKg9x8qrg2/HX6MLS8UTiqWuS+waQDpXoL9URUdzc6yR
         iZm91Ijd8bKqzAzjP1/kGupyEpT6F3/MX3dVFYpX6Wm8q8KXVX5EeLisZOq2ydWCUVte
         zMqhVMsCBx4s6fdAAAfESwQelxffOq6O3egHZPmE/Pfu6sN/2rYkGTG9n9clf1HMp9bE
         +0bg==
X-Gm-Message-State: AOJu0YwMhrrm+zvkH2VWc0xvLhIXwkNJx3nDaD1pcaZo1xL04P5ntv/q
	cKBKGNF/Yfs9gFYniQmGtZBxX8chs2lYwLmBUOBr0WUuxe/UlKFiUzIRDLBAOYSHrbszUNe83jS
	7A3d09hrj5nXGLZVatZuJJpP0YGKuzH64l8iYz6NUlyUnC58G5s/AIU7sWHG+nIJXaGDN4ZgGSS
	+PjSKYLhDh/Exe5AIrFcgoEeG0vVQhpZ/d1CoQznlMZinWiBqI0UwwPUw/QCfmR+/6LKevaRp6d
	Mg6fbDgEo2VpRbc
X-Gm-Gg: AR+sD12RVvwKFtZnDjDwEne8bukocDarRKsdR5zjpMRrm3+sNlU0I8F9FLahsemGW0C
	gIham8OyR6uCVvZzyqHMjjHy/PT0CEDFCowJRBK+2u3AmLNConrW/NrrvdoVkbc79dMqTwH5xM2
	xk3Uil6nsDr0tUb9qY1zcuERn32zd8okCdBmAD/cRpLMVeJZ2dg6CNqmO+N8OKq+6hVWyObe7vP
	byXEp6y7hBlpYpv2BvjY1Bm36l5Uvm1ziuY8utZxxfoJmj9Z4fPNCbkSyeAefjXKSIsxsprxjpJ
	16bTGSnbzaZjPThAqK6iSn8mOzbITvhTxHte/eOQfE3aOnXrPRR2JnBu5o9wPn/S75cgmQFv+id
	AXhM4IlYdjk24na9zBCnNYayVN/Ol8CXRuiTodKjlJgJxdyO3nzzq9QCDiP4dTXc2gfY9p0goRS
	ruit24ptU/7Co3fmwtAFDSsdultZcbhY48OmE=
X-Received: by 2002:a17:90b:498b:b0:38e:7268:220d with SMTP id 98e67ed59e1d1-3903c628176mr6842378a91.20.1785928479257;
        Wed, 05 Aug 2026 04:14:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-13fca8d8992sm525119c88.7.2026.08.05.04.14.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:39 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c85798977dcso1373463a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928477; x=1786533277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3tdZJHSOtLJa5wo+nrOu3wCPkHQdIffb/zLiy/3bAbc=;
        b=bQ4fm8vEadZ72zQsDh9wxKQmo/P6rGBlpXksZc7LvMtOlq3G7J7g3jx8Fq2ElnA2aI
         0GnNgNxoNPxj1UkhQHMWYohlDyfhKYpcJYToNc59p4C/5tyRJiJPFTfUP2OG7TOFmN8M
         /kNuaB01e1OKY5583+nYnhExu7PLoPyoxYNvE=
X-Received: by 2002:a05:6a21:16:b0:3c3:92ba:c61f with SMTP id adf61e73a8af0-3cb85e2b7f6mr7645458637.8.1785928477120;
        Wed, 05 Aug 2026 04:14:37 -0700 (PDT)
X-Received: by 2002:a05:6a21:16:b0:3c3:92ba:c61f with SMTP id adf61e73a8af0-3cb85e2b7f6mr7645373637.8.1785928476546;
        Wed, 05 Aug 2026 04:14:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:36 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 08/10] mpi3mr: Fix SAS port allocation and registration error handling
Date: Wed,  5 Aug 2026 16:36:32 +0530
Message-ID: <20260805110634.346670-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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
   already begun, the same ABBA deadlock class fixed elsewhere. Both
   paths now stop before that call once that is detected.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=8
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=8
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=8
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 50 ++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index b309cfdf6687..db9cb0b03b9f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1429,9 +1429,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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
 
@@ -1451,14 +1457,32 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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
@@ -1466,6 +1490,18 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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
@@ -1504,9 +1540,17 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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
@@ -1600,12 +1644,12 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 			    mr_sas_port->remote_identify.sas_address,
 			    mr_sas_phy->phy_id);
 		mr_sas_phy->phy_belongs_to_port = 0;
-		if (!mrioc->stop_drv_processing)
+		if (!mrioc->stop_drv_processing && !mrioc->reset_in_progress)
 			sas_port_delete_phy(mr_sas_port->port,
 			    mr_sas_phy->phy);
 		list_del(&mr_sas_phy->port_siblings);
 	}
-	if (!mrioc->stop_drv_processing)
+	if (!mrioc->stop_drv_processing && !mrioc->reset_in_progress)
 		sas_port_delete(mr_sas_port->port);
 	ioc_info(mrioc, "%s: removed sas_address(0x%016llx)\n",
 	    __func__, (unsigned long long)sas_address);
-- 
2.47.3

