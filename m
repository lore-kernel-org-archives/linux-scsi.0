Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C274622577C
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 21:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753478964; cv=none; b=gSANlnVAXRMHNniO1fH7K9RsSJuoQwzOlFVcwiYituBI+e1c1V6a4eDxnMQf6KfS4yrslziVX9yTBfSXOB3ExEDY3Bf1owlj10Cv+YFnTjwsr7FBuT5OmL0P3bJaggn1VdlETw/rXnn45kHV//Fo5bcupjwfPbve9YPVZxO0lhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753478964; c=relaxed/simple;
	bh=o5a02AoTMlYvHmtTwbpwhbVsxO+Mdk4E0d/3W5T6Cpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hjLGbQt31cONfbnZBr4sLq38IYnXvuWfyiitpU7X0Fju3eJGn4o95M9b+F2zmNY/eoLuOdyDekHdexTzSsY8cwQ0Z1A48njMWFnDiWkEfJg7jlTzBJiRz59Q4JFKwfAG7ViT/gAYq/eVWGi9G8wYgGexU/gOad1etCaMSS3rxPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bYUKGpF7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYUKGpF7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753478961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jMM/1NHr6rVVyY/sOYr8j5VpQQPvz3VwMKNj5vmGIDI=;
	b=bYUKGpF7opZPbxv31zh6G6Ij0kTslAj7jDQJB6YIExWRk1h9lWiG9l0VXcolWE1DWlDO8Y
	lqUCcovBQlAKQXFv9jzUOdeIT5kqIF5DwwuQcI7M6fPf1G6m8mGHrTBxse2O00TiDxjfuY
	JkObFu4AZYo80IeX1++/5NUZ2CcBdhQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-340-RbWZ1I4WPxGcJYvq95zKig-1; Fri,
 25 Jul 2025 17:29:19 -0400
X-MC-Unique: RbWZ1I4WPxGcJYvq95zKig-1
X-Mimecast-MFC-AGG-ID: RbWZ1I4WPxGcJYvq95zKig_1753478958
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEBF41955D95;
	Fri, 25 Jul 2025 21:29:18 +0000 (UTC)
Received: from cleech-thinkpadt14sgen2i.rmtusor.csb (unknown [10.2.16.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 292C8195608D;
	Fri, 25 Jul 2025 21:29:16 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-scsi@vger.kernel.org,
	Nilesh Javali <njavali@marvell.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bryan Gurney <bgurney@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: [PATCH 0/2] scsi: qla2xxx: flexible array / field-spanning write issue
Date: Fri, 25 Jul 2025 14:27:30 -0700
Message-ID: <20250725212732.2038027-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Bryan Gurney was running into these field-spanning write warnings while
testing some in-progress NVMe FPIN work with qla2xxx.

https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/
  >  kernel: memcpy: detected field-spanning write (size 60) of single field
  >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
  >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)

I think these changes should fix up the non-standard flexible array
allocations, and fix he warning for Bryan's testing.

Chris Leech (2):
  scsi: qla2xxx: replace non-standard flexible array purex_item.iocb
  scsi: qla2xxx: unwrap purex_item.iocb.iocb so that __counted_by can be
    used

 drivers/scsi/qla2xxx/qla_def.h  |  5 ++---
 drivers/scsi/qla2xxx/qla_isr.c  | 15 +++++++--------
 drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  5 +++--
 4 files changed, 13 insertions(+), 14 deletions(-)

-- 
2.50.1

