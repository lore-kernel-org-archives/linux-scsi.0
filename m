Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C2C26281
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730336449; cv=none; b=KPvDOTcoHgEOTEuhLHwP76Etk/ynGioU18IzRawVv6azga4oIB2/wGw+LImBPBOv/hhbfPEotixHbIB9CZj8xcojcw9H3fwVcyRxosYnDbvyVSLr9MZazarSzZ0EGxMGa1XaX2vuGlTWviQ8Hch4TJ0eXRCLhRy3hWTbGcsKxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730336449; c=relaxed/simple;
	bh=1xOrw5x/CcT82SbwOauUh91G6hlyTArReGPNHUab4C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Cwn63zmpjwibP2cKjZjluI+SFDRDs++wKOcosGYXaaZndIV2o6EShx8rx2g8otgdxkebHNodBCF2pssD6aC7fAY3sdzHKBsXNEtR+FatZ1hV60CJb5OXAztoxG8RBQqgBRENaR/4Y8vruBsUOmfrM1FYwlax7GZrF5Zb3XKQvWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TVkj5SV0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TVkj5SV0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730336446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/iz2+fsE8CNUntTe9v/iSv0zGPEHwco22tORbQK2AKI=;
	b=TVkj5SV06wIhm2RVpOAEcTYB29JAhLMSe0GAb+4bb7az2QeIfIuK0+He7c4pMvfT+Jd9/H
	hpDN4midnHFn+FqpLGBAH0pv3JBwfqR3fDJBh31hcKPcy1P8B/XzpN4fbv/A26KzbKOS/j
	gEzGzN5RxckzGQVAcqS1qoZnjlYGy2Q=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-xE0IXlUrPM6tMxIwMLSITg-1; Wed,
 30 Oct 2024 21:00:44 -0400
X-MC-Unique: xE0IXlUrPM6tMxIwMLSITg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2E231955F45;
	Thu, 31 Oct 2024 01:00:43 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen3.rmtusnh.csb (unknown [10.22.88.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC923195605F;
	Thu, 31 Oct 2024 01:00:41 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: linux-scsi@vger.kernel.org,
	Kai.Makisara@kolumbus.fi,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	loberman@redhat.com
Subject: [PATCH 2/3] scsi: st: clear was_reset when CHKRES_NEW_SESSION
Date: Wed, 30 Oct 2024 21:00:31 -0400
Message-ID: <20241031010032.117296-3-jmeneghi@redhat.com>
In-Reply-To: <20241031010032.117296-1-jmeneghi@redhat.com>
References: <20241031010032.117296-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Be sure to clear was_reset when ever we clear pos_unknown. If we don't
then the code in st_chk_result() will turn on pos_unknown again.

        STp->pos_unknown |= STp->device->was_reset;

This results in confusion as future commands fail unexpectedly.

Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9c0f9779768e..e9d1cb6c8a86 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1083,6 +1083,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 
 	if (retval == CHKRES_NEW_SESSION) {
 		STp->pos_unknown = 0;
+		STp->device->was_reset = 0;
 		STp->partition = STp->new_partition = 0;
 		if (STp->can_partitions)
 			STp->nbr_partitions = 1; /* This guess will be updated later
-- 
2.47.0

