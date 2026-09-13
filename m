Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE4274B39;
	Sun, 13 Sep 2026 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789303950; cv=none; b=f1hXQ8ph+hc6b43yMj0udVs568ICQQ36Q8RiBP17Z2sES0Gnnxzy3J2yLzl8RqTOiAADiszKLqVB0oEsz42dMOHgTjCEFjMBp+KRVaXPiGb6c4JXV4OhSW4qID+wj6oM86/91r68Q8Lp7DqNiyKWNsUR6v3LcvQSsWR1bHQg/vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789303950; c=relaxed/simple;
	bh=uxPZD9mRMIe2F4QJaPiKikCzT4JVFp+pjT1VXr2cl9o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E5lMIoG5NVzyojgsO7qqzgvJ9RBTZUfNgi4pXkNV0rUfRr68pBqL2GUO0ilhftCHF6MfCcxsItZQdqKusaiCOHc551jxRVB+3TlgVPGCekFwKcAJ2XRCxEHmgdGRp6p5qPdZEV3pn3PWj3W5XhW1ni6yfSeq1COKCLvi8GuGwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=EDeQ5XE2; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="EDeQ5XE2"
Received: from seu.edu.cn (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d907a3f6;
	Sun, 13 Sep 2026 20:52:19 +0800 (GMT+08:00)
From: Slavin Liu <bolin.liu@seu.edu.cn>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bolin.liu@seu.edu.cn
Subject: [PATCH] scsi: mpi3mr: unwind failed remote-PHY allocations
Date: Sun, 13 Sep 2026 20:52:17 +0800
Message-Id: <20260913125217.110026-1-bolin.liu@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa09ad3610803a1kunmf2a64e972511df
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQ01CVhhNQhgYSxhPTUNPTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0
	NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=EDeQ5XE2g6vNe0Rcakq+ISx9nzDSyveETtRnqna8zf0SVoy6d+BtL/COFX41WuLhz8K6d8NFXeYxtGpxcwicQFerB9UcdtJZxWGTsikFxyeMoAbiapSuSs/xzPCVExvauwslVUgXzh8JJSR0iFguebuRWXY2j6+0uBEUXXatkYs=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=ChQRgqFa085naVZieoL37xuBITK/Ci1LyguWHjRon10=;
	h=date:mime-version:subject:message-id:from;

Remote-PHY allocation can fail after the SAS port and its PHY links
were registered. Remove those links, delete the port and clear the
pending flag before entering the existing private-port cleanup.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 232af978d737..4aa443124ab9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1461,6 +1461,17 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		rphy = sas_expander_alloc(port,
 		    mr_sas_port->remote_identify.device_type);
 	}
+	if (!rphy) {
+		list_for_each_entry(mr_sas_phy, &mr_sas_port->phy_list,
+				    port_siblings) {
+			sas_port_delete_phy(port, mr_sas_phy->phy);
+			mr_sas_phy->phy_belongs_to_port = 0;
+		}
+		sas_port_delete(port);
+		if (tgtdev)
+			tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 0;
+		goto out_fail;
+	}
 	rphy->identify = mr_sas_port->remote_identify;
 
 	if (mrioc->current_event)
