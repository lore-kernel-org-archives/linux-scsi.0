Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E65227581
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196166; cv=none; b=ee3/YKfz0DsbGC/QsPFLdaa5ZM+vN0Sji9rdxKeRGr2HzydZ/Qko6FHtxgxTTJjdJEx2D+oi5uJ3oSiyS8TrEILRWM39KOJj9dDFgg/ltXizP932+rzEqhaSJ8rS4y9+ryeH6sTQqgB+QkL0zqhVOWz7oQVqwIhd94AUPBzVid0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196166; c=relaxed/simple;
	bh=wlbYv9yMm97KjU9YzVO6ZfUj5bHkWLptBZY0owbcFPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti6leSjx0i04eqZTJMGysKAwEHHxwXApLXJtjcL+WlFWlXtD+z2KDzSKTF0cKuxkjD8CP3BYtFKK09XHs0YTk/TsnvYTXSTqlPEfJm+uDquud43KzeSW5m/hKx/EHkWXu7Vfvd5tHtukamLi+ZbGT8QPUQx3FEs3avLjiHWcr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXo8MA0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXo8MA0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/4aKbDUmx161WBExvL/83Y9UXD3LJzhQVfV/TVfZzsY=;
	b=iXo8MA0Yx4wKMISsXbasHCMS6UIE9gwfbk6RmluogOlcI+6g/JQkX3A+Zb1pVWwrP1RIz/
	WfS6563nOoOaZ5F9neoMgQnoQK4Z5WgMpxVQ5R5i+pLIdZU65nJ71AJmXAHe6m/RIxzO8y
	umeim3z17rXJrswj7hUU9G/ofup8tp4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-QdvaGtrVPXabIkclE2iYZw-1; Thu,
 14 Aug 2025 14:29:20 -0400
X-MC-Unique: QdvaGtrVPXabIkclE2iYZw-1
X-Mimecast-MFC-AGG-ID: QdvaGtrVPXabIkclE2iYZw_1755196159
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C92F1955BD9;
	Thu, 14 Aug 2025 18:29:19 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0619A1800280;
	Thu, 14 Aug 2025 18:29:17 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 6/9] scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
Date: Thu, 14 Aug 2025 14:29:04 -0400
Message-ID: <20250814182907.1501213-7-emilne@redhat.com>
In-Reply-To: <20250814182907.1501213-1-emilne@redhat.com>
References: <20250814182907.1501213-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 10ba6ec5012d..f1ab2409ea3e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2869,8 +2869,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, lim, buffer, buflen);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
@@ -2880,8 +2878,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			return;
 	} else {
 		sector_size = read_capacity_10(sdkp, sdp, buffer, buflen);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size < 0)
 			return;
 		if ((sizeof(sdkp->capacity) > 4) &&
-- 
2.47.1

