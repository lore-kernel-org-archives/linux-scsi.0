Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE932B110
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 05:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786944388; cv=none; b=LmqUc9I0wxkZJSPPmkT2+OIqoKW+z5LrDZ7nfleoTjpRipDR+G5+ohaP29x3TqrWRpE/Dn2fCL4M/ZkZYlMFTwUbEjs8zCx+nsStlc+xqHCB5fW4cj5AutG2UcMSu0RpbakiLEvHzui4tSd6E2rfPrLtBVWzSw9t4z13uefSWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786944388; c=relaxed/simple;
	bh=wR8uOxHfGhU0ZK50sDbdEW318fKiig+GLeA0R8rLAwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=momXHujRoCPYOGe4uGZ3KO+jt0h/LC8YRnnMGGywNZZK7X258+5lyRKCFYCIiv7dCWZd2bYoERhgfYJJ+TGgNfyt6M6FUJO6isO2FfhQmiZBX0gyVZ96Jbjsiy/oari3WhtofB9FHQJFa93p4MLSx4c0qAJbbfJzPJnzdV+QVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAmavm6a; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAmavm6a"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84830c774a0so2517035b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2026 22:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786944387; x=1787549187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LCJ96hhAbvo1BoO4jzLY1jRPvpVlGUhbMQS2tTGtXPE=;
        b=CAmavm6aHMomlYXuEOWJiS1ua6TKBZARHYyJNphXP3DASSmrAaxXhqpr+6G90wVTmx
         GAgiiI2ONjjwPQnL5liQ15HK5DVQSCs4qhi2UeaBZmsJTGowkoGm01v6TvO1DxWqlcKJ
         yFHEs3M6IasapE5k9C67jgzm27WGl1XNa7kU2ohBOT6tAOmflNDGTVyCYc117Vf1cByk
         Dw0e+XJr0xKb5BDoh8hpYFNwy7Sp8hYzPUQAR3jYEI5EVJqLzMUW00QsBjTDnmRQdQz3
         o5NeI2JiA0HMlKE452RfAFf0yQrQkIo0+poD4V4Vg4BxPRN5Ymum075IZtu7F8M7GIAo
         PDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786944387; x=1787549187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LCJ96hhAbvo1BoO4jzLY1jRPvpVlGUhbMQS2tTGtXPE=;
        b=S2Cjq8OlQQ7BlHPT9w4ZzCYT3XIU9S21hgoINH7YppLG0UrGUzNRfqb0FlB9dh1iCu
         EHHkH91Yrgyt1WreQ8xEstENSa/XOkw6qp+iOKps3Oz4pbftTitM9mg+D150BoLi6/uE
         /7ltkm9r0cgqfxB3eQbPo4q+0bagBjunJy8AS7MgpdRr5xl5T2X3BJwaFMpEAVTznSjh
         1bfAPG11uggLH7D5NzkSyJ++Ilo8ADWE8YViSfjAIbGyrs+Eo07AFtrNlmthE3yZx/Bh
         qLuf42PzHOW1K44D0PoXXtaQopN2xsGD8PlCH8rrQ98VwEjFhibVIzHiFiRqJKnEO1Ps
         TIqw==
X-Forwarded-Encrypted: i=1; AHgh+Rqx9NntvJoRps5PU2FX3yGdD21tG6R28VF2jHbZPaj1EPyDA6ywco4LI8m1V+f3dDQ10V6lFrn5qSvc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8QBQYwiGB7WrqdRwGfkhm9XK0RcirupnJxs0JMx3bpJHmaSbE
	6zCN5WrX8/abmPYOyWd12Aa6oJjXjD8JbdzKH+6Fq00HtcnYYsnV63g=
X-Gm-Gg: AR+sD131LxXiZaqtZ6Zw08yuGGkIGwsq5gn+1D947YpVGqdXnJCwpNOI46IMYZvzIZO
	tfIhirZQebtjvNx4TvYzU0uKFlA7eDiWarWtxuFpqM/asSwXHZgkree+tJ3GZt+vqABdiJlm8s7
	FQYPbMCg4Ta2DoN8dCVMqh1y5uNA3Q4TcQOvCHF3htvAPVkLsUweLpcpcwCKF/6NHlAU0d6Vg7G
	14L2rTzwyahAvSgtTvUYJ77eOlRXfJCLrVxC8gRox+qIDz+kOwQq2fyJTkEwDRzzjwmsUIRwA1D
	LF2z8iSQ43HJkWx7fe/ZPRW/kbe/RJbCCrZzreXbpLNpAMkM4OPAvR6iIO0A5FtdhKiOCIzNOfk
	WJ1TbAEcQBjaGUKyNFo/ysRT3tpoOiPOAc83g+wZTjCAUtjrOnEqUkX75B6hrik1balwvUQBlo1
	myQDWkS9PAq70e9uOqB0ogI5flN0cfHNjbGlhlRsk3mzhnetz7dXpGItXs1fI=
X-Received: by 2002:a05:6a00:2d12:b0:848:425a:4e31 with SMTP id d2e1a72fcca58-84fde38e8e4mr19894107b3a.24.1786944386764;
        Sun, 16 Aug 2026 22:26:26 -0700 (PDT)
Received: from DL2XHKPB4.dl.net ([103.63.104.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d249b4fsm2115129b3a.46.2026.08.16.22.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 22:26:25 -0700 (PDT)
From: Triet Hoang <triet.hoang.dev@gmail.com>
To: sathya.prakash@broadcom.com
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Triet Hoang <triet.hoang.dev@gmail.com>
Subject: [PATCH] scsi: mpi3mr: Handle SAS port and rphy allocation failures
Date: Mon, 17 Aug 2026 12:26:19 +0700
Message-ID: <20260817052619.810762-1-triet.hoang.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check the return value of sas_port_alloc_num() and handle failures
before attempting to add the port.

Free the SAS port if sas_port_add() fails. Also handle failures from
sas_end_device_alloc() and sas_expander_alloc() by removing the PHYs
from the port, deleting the SAS port, and returning failure.

This prevents NULL pointer dereferences and ensures resources allocated
during SAS port creation are properly cleaned up on error paths.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..2fbfd178c539 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,17 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
+
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
+		port = NULL;
 		goto out_fail;
 	}
 
@@ -1455,6 +1463,19 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		rphy = sas_expander_alloc(port,
 		    mr_sas_port->remote_identify.device_type);
 	}
+
+	if (!rphy) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		list_for_each_entry(mr_sas_phy, &mr_sas_port->phy_list, port_siblings) {
+			mr_sas_phy->phy_belongs_to_port = 0;
+			mr_sas_phy->hba_port = NULL;
+			sas_port_delete_phy(port, mr_sas_phy->phy);
+		}
+		sas_port_delete(port);
+		goto out_fail;
+	}
+
 	rphy->identify = mr_sas_port->remote_identify;
 
 	if (mrioc->current_event)
-- 
2.53.0

