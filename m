Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EFC48A8D8
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558475; cv=none; b=prkMuunI4SLXaOrz7clgQI5lOhe2b5tRkYg8eJAl6ZN9wkhQhaUi3k4Mg+gkNhkVSaT+YY6mw4ofoCZa1luZr6UTtoXiA1cGwJXx8ypywwZULFyrSJWvO05dgNK5mB3xRrqo5Y62aypUXOLPsZZYUgN8gGebQwhaO0JU5nsqzQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558475; c=relaxed/simple;
	bh=4n1tlQkjXyTWNqMtep5UugGOyl8D8s0TXsvJkpbQSzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qagkZktH2N2YmmEdYCbCKitTw0rKZnoWJ3gWChrs04KbtjHAoCTtFnXH2YudBJqMKlGLm/C9otRoVf9lZWQZLXMf5/aWreoLlmJj/V/szHZTVyoGiNNPKlCcPHxTvgoJ3/yfs1/s5VZISQg3QtDMv7JGuNq1aGpE7K2CLw2yAxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hncx38HJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hncx38HJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/PkTYmB9Xqmq9DAbPY6/2gP1sruDO+EphGFwKZ0TkE=;
	b=Hncx38HJYyOou9ILV01+hsiJGg6kYAEQUiG8dVW7qF6sAw0R0ucdSNlqr8MZtV8U1v7BwN
	GilF8rQDMEh6liF7I69oMXun9rTJCXgNAO3oIGOyjgLHAUncoVSBgUiDErMitDr2jaGGPb
	4NKUqZkKo0lzq6/gec4FaUcCc2wJ22k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-wKVI966jP82PysGX33rujA-1; Wed,
 12 Aug 2026 14:14:29 -0400
X-MC-Unique: wKVI966jP82PysGX33rujA-1
X-Mimecast-MFC-AGG-ID: wKVI966jP82PysGX33rujA_1786558463
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1000195605E;
	Wed, 12 Aug 2026 18:14:22 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 75607180034F;
	Wed, 12 Aug 2026 18:14:18 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: [PATCH 13/13] docs: nvme-multipath: Add FC-NVMe marginal state
Date: Wed, 12 Aug 2026 14:13:00 -0400
Message-ID: <20260812181300.3712426-14-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Adds documentation for the new marginal state for
NVMe over Fibre Channel. Documents how to check and reset the state,
as well as a description of how it affects multipath policies.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
 Documentation/admin-guide/nvme-multipath.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/nvme-multipath.rst b/Documentation/admin-guide/nvme-multipath.rst
index 97ca1ccef459..8df4235d4d10 100644
--- a/Documentation/admin-guide/nvme-multipath.rst
+++ b/Documentation/admin-guide/nvme-multipath.rst
@@ -31,6 +31,23 @@ To set the desired policy (e.g., round-robin), use one of the following methods:
    1. echo -n "round-robin" > /sys/module/nvme_core/parameters/iopolicy
    2. or add the "nvme_core.iopolicy=round-robin" to cmdline.
 
+FC-NVMe
+----
+On NVMe over Fibre Channel there is an additional state called `marginal`
+All policies will treat this path as offline and will not use it unless
+all other paths are marginal or unavailable. In that case, the policy will
+select the best path based on the policy.
+
+To see the current path state, use one of the following methods:
+   1. cat /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-*/port_state
+   2. cat /sys/devices/virtual/nvme-subsystem/nvme-subsys*/nvme*/state
+To reset a path to online use:
+   1. echo "Online" > /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-*/port_state
+
+The marginal state is caused by a
+FPIN-LI (Fabric Performance Impact Notification - Link Impact) event.
+FPIN-LI event counters can be seen with:
+   1. cat /sys/class/fc_host/host*/statistics/fpin_li*
 
 NUMA
 ----
-- 
2.54.0

