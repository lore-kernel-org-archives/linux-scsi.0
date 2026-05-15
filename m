Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCB03806BE
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778878361; cv=none; b=kLYMTY1CrMD3b6H0ElMsg8gPu2yW6Hk9sXUviuuWbomjUb1sADBWJxB3Otf1bbjwS1XxxYesuSlI8ozlPD/HW9q2xuy0vrhxfll8K3e5yEffpB4dDSx9Vu6FDjqBKD+9PUvbKkfNXzavmazx8CSDyWUT5gJCDFpeT/yaXzAoRkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778878361; c=relaxed/simple;
	bh=K3vd2SOX9NWFUpKKaGfl+ur4oaTLNg0x4uKMimtxwjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgzEWKxzHBlWKHhKQFr3ECfq0MZXOK/9uREU0Rt7d55tWc2L6Dk0U9Q4mYOYU9+UhMph9c1IuYpG6GsCa7xRfpJnXt3KGl8OY2tQoNYtS5iFcJfpfVkeowWfVVT3cSrHNTDncImJq39rqaqBGgPXx3+NCBEwpz5LATUV9GYJo5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v+jZMVo/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v+jZMVo/"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gHKCC5jZyzlgwNK;
	Fri, 15 May 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1778878355; x=1781470356; bh=9K/CZ
	/e+PPKOn4/9ksOFqI67f9eUnpB5LRzLZzpSyiY=; b=v+jZMVo/FInbao6s8mqyu
	dcPmMnrqVFZpBQwpUYZbzJjDAuP/gjaRMSJjyAmRpFAt7VUgjhQW53FcFDDMjc5v
	5pb1C9ucMW5x70V9ncKu+r467L/u3yJTrJAw11sqxzLq6My7JANifgnpNB68P7vg
	+hXUgKgcnrsP/kGOvBErwyaM3KZ+TMOsKfajdGYJoqvuloX6IQsQApWoWF/QWBIk
	PkSW0IrYT9qQpNAfAua+iL5zqQG2zOT00V0D1l5HNSm1qPSyzy3wbD0OntbYPvPO
	CXPSZjlJnsGncRiaYxDDGE2YR3udPkCktvBB5n1f5U3Xo1hTRHsbonmi0UnmG/T3
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sCp7ltvcmzZe; Fri, 15 May 2026 20:52:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gHKC62FrDzlh1Rt;
	Fri, 15 May 2026 20:52:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Brian Bunker <brian@purestorage.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 1/3] scsi: core, target: Add INQUIRY-related constants into <scsi/scsi_common.h>
Date: Fri, 15 May 2026 13:52:19 -0700
Message-ID: <20260515205222.1754621-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
In-Reply-To: <20260515205222.1754621-1-bvanassche@acm.org>
References: <20260515205222.1754621-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move three constants from <target/target_core_base.h> into
<scsi/scsi_common.h>. Add three new constants in the scsi_common.h header
file. This patch prepares for using these constants in the SCSI core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_common.h        | 8 ++++++++
 include/target/target_core_base.h | 5 +----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index fb58715fac86..00c8a16d3cd2 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -10,6 +10,14 @@
 #include <uapi/linux/pr.h>
 #include <scsi/scsi_proto.h>
=20
+/* From the standard INQUIRY data description in SPC-6. */
+#define INQUIRY_VENDOR_OFFSET	8
+#define INQUIRY_VENDOR_LEN	8
+#define INQUIRY_MODEL_OFFSET	16
+#define INQUIRY_MODEL_LEN	16
+#define INQUIRY_REVISION_OFFSET	32
+#define INQUIRY_REVISION_LEN	4
+
 enum scsi_pr_type {
 	SCSI_PR_WRITE_EXCLUSIVE			=3D 0x01,
 	SCSI_PR_EXCLUSIVE_ACCESS		=3D 0x03,
diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
index 9a0e9f9e1ec4..002b0fc57587 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -8,6 +8,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
+#include <scsi/scsi_common.h>
=20
 #define TARGET_CORE_VERSION		"v5.0"
=20
@@ -46,10 +47,6 @@
 /* Used by transport_get_inquiry_vpd_device_ident() */
 #define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
=20
-#define INQUIRY_VENDOR_LEN			8
-#define INQUIRY_MODEL_LEN			16
-#define INQUIRY_REVISION_LEN			4
-
 /* Attempts before moving from SHORT to LONG */
 #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3
 #define PYX_TRANSPORT_WINDOW_CLOSED_WAIT_SHORT	3  /* In milliseconds */
