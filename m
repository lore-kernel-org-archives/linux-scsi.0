Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E22489892
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672708; cv=none; b=EqEnaYI19H9hf5KXZSBNrVikWMSzjoUVcufBsBcngUK3M00mx16bbiP9Ft+8EYLlgl6Y/MCdeyni1bplInAwSjcUQseAwbk7jgntWmSXKOZrBolDvnCmhnh5NdTwUVVWtbY8q7jPS4TbV2XVVbVDOiXRvaCFpC8v/mcYNRrChpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672708; c=relaxed/simple;
	bh=H+JUMila7pwBVzRZ/3jnvCh5rOS/N7UkpNWuyVhUBME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjHWLEQPO1uPLJR7k069G7xecwiXqiQ0xr3513mttKcFE4Kvgve5oN9HrFqqC0Bl7ibNez7gQsnnKLM5yxOBAlTvwZWMIetP2uuysQ1Jy29qrWHQZha4+d9b9Nt+GHXG8QjCZy+sgUUKFYbwoW1QZuA+agTYqFJJ8ywQ/00RfLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TkrSy6z5; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TkrSy6z5"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cbedf433a99so4697905a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672706; x=1788277506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gAPv2Y4OwRoLnreBFlxun+B6SF7Hy9Vo25Cq+31n+us=;
        b=C/gGu27EtQdAKKiTFDXFoOKQXebHqeABCLxrtJq1Ke7hNStbadQAIgH4yJIIL+4CkH
         ydMhx+MzXd4owIKHg8cAu8JVbsch6s4sbFN5WyyUm/+SdpljZnVlavMBN6c6ypKqGw0l
         3F8JCHpBFcZIxInAYfOA0TPXdOhLBFTQV06BfgJOe7zcZHmJrt56+X/3ZP5DWsAT/PnN
         iXgcFGo3406sG1EnoWcxVssBloYmGGtj49PC6QbjZS6MRAvC8GUTFjdeNYUzPhHJczBd
         CCG1Utge8o3Q1OwV/m9hrylMBxiD+FvspLZK1LoPrpjeG9Jx5dAD3SjA7IJvM9NXUiaI
         v00A==
X-Gm-Message-State: AFuF++lyQzNNvza5wKmdHmmP8CtJnT/HIE4M8Wmylz2uWP1XOC6jeW9t
	SKMSeScuNbLjdqTek7ZR1hUSgxKCNx7ZsUbKNV81y620bWczEWeaOyMmdD9qadM1+5aN6YwXNrm
	dQ9jouznP2cXeGNP2Fo/Fm07qs1prAIx+SSUNZ0bYm3lxvoKHrB4llsU22VhR6WeV8QYdLnsxaQ
	8aVVxT///30tuIlDoK3fHXhXTRdpmCfX6eaQa93LZuB3LgWDGld4qjv/YH0rzk95SGKCm+bDUof
	4lIgWc2PahYJyLeOwpgjxru
X-Gm-Gg: AR+sD13rzW/ATKq+XfMuAvI34dQiyRUwYRwy58hTl7Nw6r3uG40yFWuMxQIg7YQdlaY
	oR0UiTwadIk5uifHQ5vam95zSGFGtFfoqJPvIGcy4eppOzDVQ4mUk40O1P2cMcQRBwuZTILmkD1
	qlzHZNwHrXQtTbZ39/lra+te5k82Uw2gb6+60SflHlRmJvsgkvLke+8XphdvWsDmt6oJTn0QWld
	LJEapiJGf68VOIJa7A6poFdUF4nWAx92kGaAXf+YP1+tnAHlRZtcvZp/KD7rVrsemdNPtRAz1Ui
	Lpylh+7VQLJaSmQ1/bxTSqSfm5+ljjHBHh9BCEH8ZiePKDOvZ78HpFhlIzv0ym9uMIawb5co4Gy
	nNVCuw/XLamnxQDBShEktkviJZSJ6LPnsLFQNZ4wPuqulWtMJ1QrXEKHMAE8m+q27vSl7hO825N
	DApleme80dC4c2I38gXAM4uUt+beZomL6gAWjU2l6PbfnDtQ==
X-Received: by 2002:a05:6a20:b7aa:b0:3c3:bbe6:95c7 with SMTP id adf61e73a8af0-3cd913c6c58mr17658185637.17.1787672706396;
        Tue, 25 Aug 2026 08:45:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-327f8d662fesm58778eec.14.2026.08.25.08.45.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d63c16fc5bso61176995ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672704; x=1788277504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gAPv2Y4OwRoLnreBFlxun+B6SF7Hy9Vo25Cq+31n+us=;
        b=TkrSy6z5gqOs2h+eNRZOqo68A6BIqo1Zm4cXIprRZ3gnJz0t94IMWc/Kg3sa5ncUz6
         5J+r2r0aPuKmQFKXb3zHnhCZkhfQBjvc2lXn054J8/DP3My91n0nXF/5PssWvf4OSYNY
         CObYIDz/5Eo2Le3llGGIsNx789WwjOXCNgi1M=
X-Received: by 2002:a17:903:2f8f:b0:2ca:d91d:d3a7 with SMTP id d9443c01a7336-2d6dcc5a6a8mr141604065ad.10.1787672703652;
        Tue, 25 Aug 2026 08:45:03 -0700 (PDT)
X-Received: by 2002:a17:903:2f8f:b0:2ca:d91d:d3a7 with SMTP id d9443c01a7336-2d6dcc5a6a8mr141602965ad.10.1787672703090;
        Tue, 25 Aug 2026 08:45:03 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:45:02 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 12/17] mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 26 Aug 2026 02:34:06 +0530
Message-ID: <20260825210411.301535-13-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The phy number that comes with a link change is used to index the
node's phy array without being compared against the number of phys
allocated for that node.

Check it first.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..2afff1a002ed 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1090,6 +1090,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		ioc_err(mrioc, "%s: phy_number(%d) >= num_phys(%d)\n",
+			__func__, phy_number, mr_sas_node->num_phys);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-- 
2.52.0

