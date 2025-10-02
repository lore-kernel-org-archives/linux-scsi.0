Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F713280332
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433125; cv=none; b=nQ6O7fGzRbHAUVb4K582H8OHfu8PhyuaP1b47qQrf8DBe129ZrG1oNfhWpsFP8Q7S3LshFkWCVmLGRsTw2b+xPv2xeWZfnxcHrsqjAvgrtXSsv1F3bhmm8MqH/b3zgbP/XuEgMJlopHA9hoG37en1+8S+IQIIHBfFUo3Kks9h8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433125; c=relaxed/simple;
	bh=9gJwc2rZeW/t55fmHp5OQkNInGF5BsEul3iFTcOuuVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2yvghRn/jaG3D5mN3nmfaqxI4AsZ1usaptIMLzMIdSIYtqTteGJjD5/ulAGOMSBvFsa0Bih35ieb4X2T3Wfb/Y1HKEY7ylUB2MGeyepEzyolqGnY5PozHuI9Dy1z0xLCPiHCLZHujnz7l1IUzHm2BxLVfi/gACmBfocZZbHPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cpP5gw+J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cpP5gw+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Mqzvys+AEq/qf22KPN1CDpo1NgXc7AOUZpX375dkC8=;
	b=cpP5gw+JDt3IURw23AzlRkxVUh8kbfS6gp29+ZAEZPOv5+LaIgY7KGJ0Cut6uKwitWOqci
	JQJBpLG7jINg4Jj7DiA7uPATetceXeJlui0bVKsngKS2Lu49OK5tjAfkIPIlu6JzJSUdy1
	sa0AKtQyG+0hJDrlEL2jRECAfjYAn/M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-5WBmOrAvO2u5hGHTG0WdKQ-1; Thu,
 02 Oct 2025 15:25:22 -0400
X-MC-Unique: 5WBmOrAvO2u5hGHTG0WdKQ-1
X-Mimecast-MFC-AGG-ID: 5WBmOrAvO2u5hGHTG0WdKQ_1759433120
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D21951800370;
	Thu,  2 Oct 2025 19:25:20 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 680B11955F19;
	Thu,  2 Oct 2025 19:25:19 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 5/9] scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
Date: Thu,  2 Oct 2025 15:25:06 -0400
Message-ID: <20251002192510.1922731-6-emilne@redhat.com>
In-Reply-To: <20251002192510.1922731-1-emilne@redhat.com>
References: <20251002192510.1922731-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d465609a66e3..acd79e9a0d82 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2863,8 +2863,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
@@ -2873,8 +2871,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			return;
 	} else {
 		sector_size = read_capacity_10(sdkp, sdp, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size < 0)
 			return;
 		if ((sizeof(sdkp->capacity) > 4) &&
-- 
2.47.1

