Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757C736134
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 07:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719474520; cv=none; b=UBZl1zzwjH+Ym+/Sx4RnejwaFJeIhLEfJnz0pMYv39+4ieuN1yyJoXIcY8dvABhVF559snUIUp7/+9ipM3ifzGfXL12TljihOERLorIDTH2DjQY69TCFaNLb7tmhlw49p+ctysOBXb3izMQ9Hcf7tU6AmSfRMSt8h9M7rzJPS8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719474520; c=relaxed/simple;
	bh=1pCUuRawJS/ZFR7Zmab3pqhIyRGQDzrQaZ2vltUMpdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LurmmYPggNswuKY561CKRuFwUhuH1GHVoccrgKiPWmx91Vb8C+WYVMwtmx31icP91VQMOM4Fz1HJ1Z+6CiIdCWA68mcTOlU45ylNnER3YHCxFqB/PV70uD9oMdsIUWyyk1KnMmk8uKXV7bobSjAIMavIP0YXuhseNrGyt+wElzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FglNjDUB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FglNjDUB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719474517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VElz1Xysk2mv1Tp58XqaKyGM8JMaGEu+z9hxYr/7xLM=;
	b=FglNjDUBuBuUn+UJj9eLm1RAkhtA4QqX5HF6qTliQfPxBgcE+FgnCIGLTpT1LBm30GE2UU
	iOUjlT2d1IWUezHOBPJEeoDy2e5PTRN3NT8SqUG0VEnn+U2Ae+7Uv6aPzL/SLXHAcK5g9l
	GaDxkB6o8XzQgOx4EUWUPoNbBXMhp5U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-K_Z67e4tNNqOef34YaqvyQ-1; Thu,
 27 Jun 2024 03:48:31 -0400
X-MC-Unique: K_Z67e4tNNqOef34YaqvyQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48E531956058;
	Thu, 27 Jun 2024 07:48:30 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.45.225.220])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D66781955D8B;
	Thu, 27 Jun 2024 07:48:28 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	dan.carpenter@linaro.org
Subject: [PATCH] mpi3mr: correct a test in mpi3mr_sas_port_add
Date: Thu, 27 Jun 2024 09:48:27 +0200
Message-ID: <20240627074827.13672-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The test for a possible shift overflow is not correct. Fix it by
replacing the '>' with a '>='.


Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 82aa4e418c5a..a454276fcc4c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1353,7 +1353,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
 	    mr_sas_port->remote_identify.sas_address, hba_port);
 
-	if (mr_sas_node->num_phys > sizeof(mr_sas_port->phy_mask) * 8)
+	if (mr_sas_node->num_phys >= sizeof(mr_sas_port->phy_mask) * 8)
 		ioc_info(mrioc, "max port count %u could be too high\n",
 		    mr_sas_node->num_phys);
 
@@ -1363,7 +1363,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		    (mr_sas_node->phy[i].hba_port != hba_port))
 			continue;
 
-		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
+		if (i >= sizeof(mr_sas_port->phy_mask) * 8) {
 			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
-- 
2.45.2

