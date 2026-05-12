Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE625B085
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 19:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615213; cv=none; b=ikklkvCLk2Zn48tcUMYjzDJkAfQDhmcNI3zrVlEnXvgBSQM5JQZvceBrNrogf3WyG8F3YV9sHaiQxBax4u1/tExtQeridc6430uS72Nb6XsggXYFHRKV4cNt2j3pJjB9Saf5h2XCV+s+UUFniFMZ6mNLvJINAkUEhBSFHaYza88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615213; c=relaxed/simple;
	bh=wCtg3/kTH8BEjiDH7cYYbEn4MWmO0MrCK0DJnHRr+cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcE0sI1f4wveRH7Roy9Az8Uj5VSELunL/irRDxAWclh8n1EijhSwGZY//64RWF5Po7xCpXlo7g+JJlDy+JBm8UnGIeuwB7CBw3LHgN5w19iPyLaksSu6lAJZhCBuQBA52Cnvh94awaq/UM/D8809HwWlbvBfL4AG9hxgTbNCSg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Sl+Bf2P5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Sl+Bf2P5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gFRtg4LY6zlfgPY;
	Tue, 12 May 2026 19:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1778615207; x=1781207208; bh=mXrpr
	ukZSrWo/DXUoKEPMkRdQW8oU2utl4dc0hSPoKs=; b=Sl+Bf2P5NWc9OOawZhUXe
	UavlhxyoTpGkC7oApvJoPYaxvXhPyQYymNCJgRwi49e9Q3WUyLQxzKsMZIcK4suv
	2CeCck6kYO721wfhTsrCRzPOLX6/6O5v82+prtWcHG6eDVHCb+nqZcNq5ypm2KyX
	tTEHj/RO9ilwhGPb2z2ulWjMmlUEls+1cPx9oaUNSrZ4HKDJXT3fkCdFS43De4yk
	k7kBxm+eEtfvhplmcBTcEsGvLAhqLSWbrrhJWaFK6eGHzSexcTKY1UeF3JHumGIn
	zUncxAriHzcbalvTGpnjCpR9H+/Ah3JSBjAvFp5szIKoGY09L8P6ISIdRucuIciQ
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z-pypm82-hTq; Tue, 12 May 2026 19:46:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gFRtZ0FTLzlfgfG;
	Tue, 12 May 2026 19:46:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Brian Bunker <brian@purestorage.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] scsi: core, target: Move three constants into <scsi/scsi_common.h>
Date: Tue, 12 May 2026 12:46:33 -0700
Message-ID: <20260512194634.58145-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
In-Reply-To: <20260512194634.58145-1-bvanassche@acm.org>
References: <20260512194634.58145-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for using these constants in the SCSI core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_common.h        | 4 ++++
 include/target/target_core_base.h | 5 +----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index fb58715fac86..f242040ff9d7 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -10,6 +10,10 @@
 #include <uapi/linux/pr.h>
 #include <scsi/scsi_proto.h>
=20
+#define INQUIRY_VENDOR_LEN	8
+#define INQUIRY_MODEL_LEN	16
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
