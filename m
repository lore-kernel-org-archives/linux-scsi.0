Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B244A222590
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 18:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750789042; cv=none; b=f+dI8+ujMipwGgprqCCGstfcVsiW5wosUV8SkPs0jOVB+w/jqcK0c/rpPXqgAYy8aJJudUf1RvDG1agRkzqbvZCLhqj9dCvL1tjB38fgj62VCqifor2Bo7ktRQeD5b33qUNgOIZ7B4h15lJJnpukf8XBdFDHgyQue/F8av9iCBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750789042; c=relaxed/simple;
	bh=ztiV/fctnBZOVD3hNM4GilY2rg0BGkA/cD0S74SUf+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W3Ctsdc4qmo1vMDyDKFb8Pi8NZt2PIIuwhGK3rP43lxrSPPi+8bo5NXH8PG/40gVUaHIXvjObmI4tKvWsQ81sJcypmOzFaIXClxxtM4EqYY2kkr1yIZKo4fS76BsvhIQ+6sBSk+OS9LT1glQCB0shSigo4AfwvZ3s7HBmDsn8Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TZtJT6CK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TZtJT6CK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bRY7y3HpszlgqVS;
	Tue, 24 Jun 2025 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1750789035; x=1753381036; bh=zo2gien1gBtYS9vrDzUoqtLK0HVWdbf4NLs
	012SEB4E=; b=TZtJT6CK50z2kfMGBNb/XYf6oyBq6o+Er5ZlIbHhq+h8ONujDNA
	mRGef/Zy7sWnjoHaieF1kkRy+i0vdVkymMpLE/JqueA6tAnhd9A0DQuQiqCA21ps
	JI1h0A7ftNdlGxW1zUscOc6JcT2aL6SCnTlyaQLHUxuPmHY5OUiFQwWhNdXxvUmg
	i3H+phENFh4cisGXBSASrZQM/nIll7MtM6q1qtihQy9FR44vFL0n+u78y/YiXC6i
	SH15QXikqX7e8pg2UW/o/5CPSdzrt4tib8k6VHSVBTyCtK6jsvoVMXePqvnC2KZJ
	f4T4BqIHA9mTl3FTgjrTNXBYdXUv7KkBbBQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iWogqrauCIXZ; Tue, 24 Jun 2025 18:17:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bRY7k0TK8zlgqVP;
	Tue, 24 Jun 2025 18:17:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bean Huo <huobean@gmail.com>,
	Huan Tang <tanghuan@vivo.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Date: Tue, 24 Jun 2025 11:16:44 -0700
Message-ID: <20250624181658.336035-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Change "resourse" into "resource" in the name of a sysfs attribute.

Fixes: d829fc8a1058 ("scsi: ufs: sysfs: unit descriptor")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 2 +-
 drivers/ufs/core/ufs-sysfs.c               | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/A=
BI/testing/sysfs-driver-ufs
index f3de8c521bbd..a90612ab5780 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -711,7 +711,7 @@ Description:	This file shows the thin provisioning ty=
pe. This is one of
=20
 		The file is read only.
=20
-What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_r=
esourse_count
+What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_r=
esource_count
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the total physical memory resources. This i=
s
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 10006ae5ee35..00948378a719 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1998,7 +1998,7 @@ UFS_UNIT_DESC_PARAM(logical_block_size, _LOGICAL_BL=
K_SIZE, 1);
 UFS_UNIT_DESC_PARAM(logical_block_count, _LOGICAL_BLK_COUNT, 8);
 UFS_UNIT_DESC_PARAM(erase_block_size, _ERASE_BLK_SIZE, 4);
 UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
-UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, 8=
);
+UFS_UNIT_DESC_PARAM(physical_memory_resource_count, _PHY_MEM_RSRC_CNT, 8=
);
 UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
 UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, 1);
 UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
@@ -2015,7 +2015,7 @@ static struct attribute *ufs_sysfs_unit_descriptor[=
] =3D {
 	&dev_attr_logical_block_count.attr,
 	&dev_attr_erase_block_size.attr,
 	&dev_attr_provisioning_type.attr,
-	&dev_attr_physical_memory_resourse_count.attr,
+	&dev_attr_physical_memory_resource_count.attr,
 	&dev_attr_context_capabilities.attr,
 	&dev_attr_large_unit_granularity.attr,
 	&dev_attr_wb_buf_alloc_units.attr,
