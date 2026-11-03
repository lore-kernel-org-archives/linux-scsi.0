Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734373;
	b=k+s+DpcSNEFbkquxS1MrcdFXKAiMwiBCYUe6Q2K1eE3V2lm1EkEwd5K7MajrDI3VfN6h
	 FxGtHT2V8zXVVXaeHgjs1Ovrzn9nN8/kZzYKJKwZH0lOCk/p9cqFN+gJ4PHc7b0XJDp0+
	 TXCvkTprGiHXqo6uE9Z3YANqhE6fthwGvcMu7sSZxu5qfO7eaK+jRW/tXTUCIRK+teCz3
	 SpHc4l15no/IzspmRuTdAa80RDcBkooMFHQLvW9CIybj1v3jcf3vsdxXtMSyz50MmJVid
	 T+MlAT0TIpZ/lHhZd3jyHfx+LXT/QKD3moCegf5Jb0HeT/mi4scHEC13ffyMgem9Kbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734373;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=iLoDvYYdW8eYBCuIX6o2n7MweRnzToA5C7UsFYQe97s=;
	b=4cfCZ6GYRg57YagxT8ujhZEtG1Y6RqkYFz1oCZP+EIZGsU77/+P+Vumv9WGSNjQTRuaX
	 oyC+ZfdEtRy7VtTYRMgp5ocDNlAr3XTpXV45ozSqOHFaaLlfrBlzqa2NSg2OF/7QwOSm6
	 9TC9K+kAuKkl2Bk3VNVTB62qTmLEgs4Zi6hqU4Rr4L3awsflJaz6C4feYb6Rmz++UYanp
	 qKWMeQvZBN3rAS4SfVb0LxhF1Xll2CaQro7fSmA/1EImvuwBsh1DdIAjvjlCjcafFTZkr
	 X2t6wmg+KWY1iKiIYrAFUystiQ7aqDuBrPr0p9le/7lV2DhUvOfZsV5CE6I5PvUd4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b0SXsKe6;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D4A606A329
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 19:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5D4A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b0SXsKe6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793734371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLoDvYYdW8eYBCuIX6o2n7MweRnzToA5C7UsFYQe97s=;
	b=b0SXsKe6TBqOxnSegiLWfZO3XcsaIvHYp4y4ToLF6Cw8TaWGm7VJM9JpJ5p6B/qGQgwVR1
	52PQub2E4blSHsh5ghV7xCl4F/kvegCJDb+5Z4kgYrk6EwWhLVrsVmNVvzuhMbvV2nvDwg
	uCe4TiDm4ZzjLYu/n4rtVjlSA7cvQUc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-BL3dVhfFPqqbVS0DqelroA-1; Tue,
 03 Nov 2026 14:32:49 -0500
X-MC-Unique: BL3dVhfFPqqbVS0DqelroA-1
X-Mimecast-MFC-AGG-ID: BL3dVhfFPqqbVS0DqelroA_1793734367
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33D701800659;
	Tue,  3 Nov 2026 19:32:47 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7BD31800347;
	Tue,  3 Nov 2026 19:32:43 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao2@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Will Deacon <will@kernel.org>,
	cki-project@redhat.com,
	jmoyer@redhat.com,
	bgoncalv@redhat.com,
	mpatalan@redhat.com,
	ftjahjad@redhat.com,
	fsuba@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: core: Fix target reap_ref leak in scsi_get_pseudo_sdev()
Date: Tue,  3 Nov 2026 14:32:34 -0500
Message-ID: <20261103193235.1564898-2-loberman@redhat.com>
In-Reply-To: <20261103193235.1564898-1-loberman@redhat.com>
References: <8e4ba1820a7c56867bf7fff07bd52ff3f79573a1.camel@redhat.com>
 <20261103193235.1564898-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

scsi_alloc_target() returns a target holding the initial reap_ref from
kref_init(). The scan paths drop that reference with scsi_target_reap()
once they are done with the target; the device allocated under it holds
its own reap_ref, taken in scsi_sysfs_device_initialize() and dropped
by __scsi_remove_device().

scsi_get_pseudo_sdev() only drops the initial reference on the failure
path. On success the pseudo target is left with an extra reap_ref, so
when scsi_forget_host() removes the pseudo device the count only drops
to one and the target is never destroyed: ->target_destroy() is not
called, and the scsi_target, the LLD's per-target data and the
reference the target holds on the host's gendev are leaked.

With scsi_debug (nr_reserved_cmds = 1) this is visible as one target
per host, at id max_id, for which ->target_alloc() is called but
->target_destroy() never is.

Drop the initial reap_ref unconditionally, as the scan paths do. The
pseudo target is then destroyed when the pseudo device is removed.

Fixes: d630fbf6fc8c ("scsi: core: Support allocating a pseudo SCSI device")
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/scsi_scan.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8aae12fd38f3..9ed52724f97c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -2154,14 +2154,15 @@ struct scsi_device *scsi_get_pseudo_sdev(struct Scsi_Host *shost)
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
-	if (!sdev) {
-		scsi_target_reap(starget);
-		goto put_target;
-	}
-
-	sdev->borken = 0;
+	if (sdev)
+		sdev->borken = 0;
 
-put_target:
+	/*
+	 * Drop the reap_ref taken by scsi_alloc_target(). If the pseudo device
+	 * was allocated it holds its own reap_ref, which __scsi_remove_device()
+	 * drops, so the target is destroyed when the pseudo device is removed.
+	 */
+	scsi_target_reap(starget);
 	/* See also the get_device(dev) call in scsi_alloc_target(). */
 	put_device(&starget->dev);
 
-- 
2.56.0

