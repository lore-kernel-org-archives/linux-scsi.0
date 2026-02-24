Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4524E36D4E0
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 12:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771935925; cv=none; b=hFq/O9OY5SJd2TrCuujCQcNL3SZWm6ApNWvDMyjTzjZHYkpoDYWVKpWIo3lBQcB6oYDVYqgrjsVyw1sqrYtKfCt2ECTQuV8d/8+pyUQhoC3hji3VoqTw8rswUgHjYTgu3z5+CIuAVxbpYczZqrE6kTzHgg+zFqzpN89r+y/Udfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771935925; c=relaxed/simple;
	bh=+JGi/R8rMcR9WsKcv6QdgdDJySoTewfTzays3/RH0TI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o223zmpFDL6lv0iDHycKHmizPpMAKD+Lz5RxMT71n2AywHVs7IbhfEkcVLVhw8gpwFA34ozRffFLtzHc4dw8uWC0PdkzxZdpulDpmd5M/bSf9vkigsGXYaNJdCJ9nGsFLpl2Zp6e2p0ro+tyC2GcEABctoYa/5cPtTKqhlO2I5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ois3ACO0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ois3ACO0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771935923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QC7EdP580Jc2JbrFb4S2BBJQ9eN/Z9ppfP8JDlFqYR8=;
	b=Ois3ACO0wXAhweyxcPmeqfhiDpdMQmmEuI1pydvw+oRpzMu2kb02squ02vUFPd9Mp3Jued
	Y1DXVU80korCcxdlN8BH3UfUHwfelq4IsEtALQEMWu+6Ce5AZHJbLFfeX3LKxV37lMs7ms
	vF+CAYc7jwa8mKJKlAaF1Kln4jggFUU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465--Agj7q8kNyC69ggYG0--qA-1; Tue,
 24 Feb 2026 07:25:14 -0500
X-MC-Unique: -Agj7q8kNyC69ggYG0--qA-1
X-Mimecast-MFC-AGG-ID: -Agj7q8kNyC69ggYG0--qA_1771935912
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 027DE18004BB;
	Tue, 24 Feb 2026 12:25:12 +0000 (UTC)
Received: from mlombard-thinkpadt14gen4.rmtit.csb (unknown [10.44.32.204])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6EE2919560A2;
	Tue, 24 Feb 2026 12:25:07 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: kbusch@kernel.org
Cc: hch@lst.de,
	hare@suse.de,
	chaitanyak@nvidia.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	James.Bottomley@HansenPartnership.com,
	mlombard@arkamax.eu,
	jmeneghi@redhat.com,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH V2 0/3] Ensure ordered namespace registration during async scan
Date: Tue, 24 Feb 2026 13:25:02 +0100
Message-ID: <20260224122505.52401-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The NVMe fully asynchronous namespace scanning introduced in
commit 4e893ca81170 ("nvme-core: scan namespaces asynchronously")
significantly improved discovery times. However, it also introduced
non-deterministic ordering for namespace registration.

While kernel device names (/dev/nvmeXnY) are not guaranteed to be stable
across reboots, this unpredictable ordering has caused considerable user
confusion and has been perceived as a regression, leading to multiple bug
reports.

This series introduces a solution to enforce strict sequential
registration based on NSID order, entirely preserving the performance
benefits of the asynchronous scan approach.

Instead of adding an NVMe-specific hack, this series abstracts the
serialization mechanism currently open-coded in the SCSI subsystem
(drivers/scsi/scsi_scan.c) into a generic library helper called the
completion chain (compl_chain).

By enforcing a strict First-In, First-Out (FIFO) completion order for
asynchronous tasks, we can ensure that namespaces are allocated and
registered sequentially without blocking the underlying parallel discovery
processes.

PATCH 3 Refactors the existing SCSI asynchronous scanning implementation
to use the new compl_chain helper, stripping out the custom, open-coded task
list and reducing code duplication.

Original code:

$ nvme list
Node                  Generic               Namespace
--------------------- --------------------- ----------
/dev/nvme0n1          /dev/ng0n1            0x2
/dev/nvme0n2          /dev/ng0n2            0x1
/dev/nvme0n3          /dev/ng0n3            0x5
/dev/nvme0n4          /dev/ng0n4            0x3
/dev/nvme0n5          /dev/ng0n5            0x4
[...]
/dev/nvme0n10         /dev/ng0n10           0xa
/dev/nvme0n11         /dev/ng0n11           0x8
/dev/nvme0n12         /dev/ng0n12           0x12
/dev/nvme0n13         /dev/ng0n13           0x17
/dev/nvme0n14         /dev/ng0n14           0xc
/dev/nvme0n15         /dev/ng0n15           0x11
/dev/nvme0n16         /dev/ng0n16           0x14
/dev/nvme0n17         /dev/ng0n17           0x13
/dev/nvme0n18         /dev/ng0n18           0xe
/dev/nvme0n19         /dev/ng0n19           0xf


With this patch:

$ nvme list
Node                  Generic               Namespace
--------------------- --------------------- ----------
/dev/nvme0n1          /dev/ng0n1            0x1
/dev/nvme0n2          /dev/ng0n2            0x2
/dev/nvme0n3          /dev/ng0n3            0x3
/dev/nvme0n4          /dev/ng0n4            0x4
/dev/nvme0n5          /dev/ng0n5            0x5
/dev/nvme0n6          /dev/ng0n6            0x6
[...]
/dev/nvme0n10         /dev/ng0n10           0xa
/dev/nvme0n11         /dev/ng0n11           0xb
/dev/nvme0n12         /dev/ng0n12           0xc
/dev/nvme0n13         /dev/ng0n13           0xd
/dev/nvme0n14         /dev/ng0n14           0xe
/dev/nvme0n15         /dev/ng0n15           0xf
/dev/nvme0n16         /dev/ng0n16           0x10
/dev/nvme0n17         /dev/ng0n17           0x11
/dev/nvme0n18         /dev/ng0n18           0x12
/dev/nvme0n19         /dev/ng0n19           0x13

V2: create the compl_chain helper that both SCSI and NVMe can share

Maurizio Lombardi (3):
  lib: Introduce completion chain helper
  nvme-core: register namespaces in order during async scan
  scsi: Convert async scanning to use the completion chain helper

 drivers/nvme/host/core.c    |  94 ++++++++++++++++++----------
 drivers/nvme/host/nvme.h    |   2 +
 drivers/scsi/scsi_priv.h    |   2 +-
 drivers/scsi/scsi_scan.c    |  68 +++-----------------
 include/linux/compl_chain.h |  35 +++++++++++
 lib/Makefile                |   2 +-
 lib/compl_chain.c           | 121 ++++++++++++++++++++++++++++++++++++
 7 files changed, 228 insertions(+), 96 deletions(-)
 create mode 100644 include/linux/compl_chain.h
 create mode 100644 lib/compl_chain.c

-- 
2.53.0

