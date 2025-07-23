Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C3F19C54E
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753284630; cv=none; b=KhUHLsVudhTqX9Q+lkMFXs8xnYz2Jg6qgDdaiPiJ5f+xYmMgusgYxfTiXPWVeEh3C9IXrSbrSUejmcQrD8mh/Su8UfXybExPHNFzM7GF+oGHJS0v2B2MgGL+cQ/9+M2Z/jkjTGMW1D51QIuGQyRRUGX1bgGOv1qKwTBdCtNT1VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753284630; c=relaxed/simple;
	bh=KdMxcadCLAcssoAJ9r7f5zH1QR42LSE2oCH7ouR2N9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NCoVm9L+aiRw8aptQ28dpyq7IqXN0z3wmpZi6j3j5dDXRH8yPrD8ioX5x4rVlnAU5YWXuHw1drB4SHurqbgMe9aF4KoUuTNAl0hO+HTGIs0aM0cHlAqyBqfdrmSDaqkdI9HHU8IcLuYk99zk3lXRdHr1vsI7zv9ykNADjQlbiA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bu+Rq0/g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bu+Rq0/g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753284626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E0zyhkct9QDrTA0/QDClbT31FtJGEeYwl4SjecNI6iE=;
	b=Bu+Rq0/gftjMVSKDwEDV/LHZKecDiQqH/mviUhN/Njrvy7d+g5tnrOOi9KYWpocfV54ZIO
	R5C2Ilf/kX3TsSVSQDjoCXl0JVbwXkf6SkFJCx9fkysfrDcNuJZTSOHcOQ90nv+JuwTaOh
	SPd9SFvutLa8aGj/ICKml6SUr0TZ2ak=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-rNF0REnQPuystQrJEk0hYA-1; Wed,
 23 Jul 2025 11:30:22 -0400
X-MC-Unique: rNF0REnQPuystQrJEk0hYA-1
X-Mimecast-MFC-AGG-ID: rNF0REnQPuystQrJEk0hYA_1753284621
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C5E71800292;
	Wed, 23 Jul 2025 15:30:21 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.44.32.234])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B71EB18004AD;
	Wed, 23 Jul 2025 15:30:19 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com
Subject: [PATCH] mpt3sas: Fix a fw_event memory leak
Date: Wed, 23 Jul 2025 17:30:18 +0200
Message-ID: <20250723153018.50518-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

In _mpt3sas_fw_work the fw_event reference is removed, it should
be also freed in all cases.

Fixes: 4318c7347847 ("scsi: mpt3sas: Handle NVMe PCIe device related events generated from firmware.")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 508861e88d9f..0f900ddb3047 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10790,8 +10790,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		_scsih_pcie_topology_change_event(ioc, fw_event);
-		ioc->current_event = NULL;
-		return;
+		break;
 	}
 out:
 	fw_event_work_put(fw_event);
-- 
2.49.0

