Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D168283CBD
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750089926; cv=none; b=aXFblggofskfm0+0unvWsZnZdsdYBAOod3pUxgcJrTzux2DpK/zZkdZogQVK5IaPdfaRcVO1fGEyzc28HXywixfZiNScfs+O1wU6jd/Mta/knWUq7wY5dpsITthljOmTnaFVuCmLs9ugwUklC49vDICzKys1v8cyWrBcMesD6yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750089926; c=relaxed/simple;
	bh=yzG10VZQ/5p8sqVp7TWQ1/IGrYoBt3ptr2EGtWpvuIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bC6hi6dSwQ4SYcO8kP1DlbG4y0ALxr6yl69V0/VCd1o8W4YPJ0gGHrRL1+WjK7niDYQLrAp/VGAd9vm3npTvAW2qi2+Oj+H1m+0OswFXdijOjpRkZPswvTO4bHUDPVnW1XTWRnzjX4qRcATuk/U9V1+IK9BjhDp0yJBZ7lqUmZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ESzN7ngP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ESzN7ngP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750089922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o4HAA+WVSTniXz7q+g/2/Z3lhEqhcm1mcpOyYqlTy6g=;
	b=ESzN7ngPpk+GpAkTUkLr6kOCZuDEc6dv9OtZ0xT55gOsHBBgAzfVxb/Js+Lo50WZlEdUgA
	B8dnzM8cpRV0L9fIZfkDH6aOUZhl4IfXG7jrG2mMykKjAM3Tdu5MGlDcM4KrFYWNtkMLUn
	zgLqMfEZlnNM6sLXZenZUUTbwl3aKbc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-342-UmNW4DqSNcGhKFD2JO3GSw-1; Mon,
 16 Jun 2025 12:05:18 -0400
X-MC-Unique: UmNW4DqSNcGhKFD2JO3GSw-1
X-Mimecast-MFC-AGG-ID: UmNW4DqSNcGhKFD2JO3GSw_1750089917
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F07651809C8A;
	Mon, 16 Jun 2025 16:05:16 +0000 (UTC)
Received: from localhost (unknown [10.72.112.35])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D05418002B5;
	Mon, 16 Jun 2025 16:05:15 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX explicitly
Date: Tue, 17 Jun 2025 00:05:09 +0800
Message-ID: <20250616160509.52491-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Set max_segment_size as UINT_MAX explicitly:

- storvrc uses virt_boundary to define `segment`

- strovrc does not define max_segment_size

So define max_segment_size as UINT_MAX, otherwise __blk_rq_map_sg() takes
default 64K max segment size and splits one virtual segment into two parts,
then breaks virt_boundary limit.

Before commit ec84ca4025c0 ("scsi: block: Remove now unused queue limits helpers"),
max segment size is set as UINT_MAX in case that virt_boundary is
defined.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
Fixes: ec84ca4025c0 ("scsi: block: Remove now unused queue limits helpers")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2e6b2412d2c9..1e7ad85f4ba3 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1897,6 +1897,7 @@ static struct scsi_host_template scsi_driver = {
 	.no_write_same =	1,
 	.track_queue_depth =	1,
 	.change_queue_depth =	storvsc_change_queue_depth,
+	.max_segment_size   = 0xffffffff,
 };
 
 enum {
-- 
2.47.0

