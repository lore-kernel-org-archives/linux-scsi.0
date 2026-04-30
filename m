Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770843537FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573493; cv=none; b=SvDNkYFZ1C21ve6C+S043/urrfI7I1xF42W0Z4RanwfZliSMWjEjpPOJW9ZuHQEYtBLW+zpVgt5oV/OtHt4HQ4Fjd/VF6MQqPRfD/v7tyEslSmPkhTvf1NcM/LiUVkrQzq3qeIS45Mgwkj8O8FiVDvJ0l2wnCAViZIUwng6puTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573493; c=relaxed/simple;
	bh=mnMsN9029eYqZeaQU162Wa8kx7blIxbw/zG1pl14J3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKlwUpvNYfCDb8VVS2Oey5R7GawxbC7hwBkTpm2RQfajgxpi+4gP1j2EQsMmlbfgVXIri+Y5oCyyaYLQu9Fnw3IfmS3fZLW+r3rWqKqZ5vn7zCfbvavTIP8NI/O06Q87rukai62drosmT6SKZfOyMz6Xnfhs0O9RF571IffQ0a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UySZyteP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UySZyteP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62db2TCPzlfdfc;
	Thu, 30 Apr 2026 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573487; x=1780165488; bh=1vk4j
	Gf210R78kyYSnZGs2t7DF7maJC+x8hnNV+29lk=; b=UySZytePmQsx4LW/8632B
	ExL5GwVHhbitexf8XYOCDyPTPbZnb29bA5F3xJgQU5rAeLy4MXkRNnRHboSZVXUj
	a3eO1wqsSEl5jS3gjGYFGhYuHmuf6X2XKGCYtw4cF4slTiTM/34uKrn4JAAsZzo4
	OMP1L3lqGYSwvsCoJafzZQMUxpVDdqqcEgBdTx4yByyezLtEze9kocFxULiSrDeo
	EHdZ3ek62V5nVq2uRGg2uZ667x08xKHVwmOCV+ETvUY99NI0KC5877j8X8dZmEJ1
	i599jppl9lB5EAizX7WqcPMAMmq/2/9mk0+/DsT0vuKrO/PRddSAnBG6ih1TzN+N
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i_68N_UYi7r9; Thu, 30 Apr 2026 18:24:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dT6LTQzlfdds;
	Thu, 30 Apr 2026 18:24:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 45/56] scsi: qedf: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:15 -0700
Message-ID: <20260430182130.1978347-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedf/Makefile b/drivers/scsi/qedf/Makefile
index c46287826fb8..465982ba5dae 100644
--- a/drivers/scsi/qedf/Makefile
+++ b/drivers/scsi/qedf/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_QEDF) :=3D qedf.o
 qedf-y =3D qedf_dbg.o qedf_main.o qedf_io.o qedf_fip.o \
 	 qedf_attr.o qedf_els.o drv_scsi_fw_funcs.o drv_fcoe_fw_funcs.o
