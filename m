Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A692C372B2F;
	Thu,  3 Sep 2026 03:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406984; cv=none; b=r+lU2OV3oOT91a7iDhzhaJ+T8j6A1p5n9qvNPqqHYBGqksQUIXsBiQq9fF/Tzbz2vw39OYZrdI/X7H3RNHY7MBLRvXHWxgnHvvm90grwo4w/rWNpA4Vf0Jicrl6WUXCU+yHpvpJ0DCf1HK4+gV4tI+FeJn5qoDAnWELe/5askVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406984; c=relaxed/simple;
	bh=07mJ9Q7E+E/x9JtdKDiplYcVwpbNe7GxBLz/JZuQgwc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldrmHF9NblWFef6ddv2PCH51e/7nE+9pGy9VnsjbrPgW1AFhJtayDpxwLo+Qo8b7dpYNlSoyTpMC+jqAGVe7o7A8D4L0w0alBLDaFRmJPe8M9hJK3UqQ7Abh9jzdg1hs1zt2yEBwV9fxHzp9ze+61kWqGoJ4clIRhb0N/E70HCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTzzshcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTzzshcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201B91F00A3D;
	Thu,  3 Sep 2026 03:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406973;
	bh=xQCsLfEpvhASg+xGUM1bHJgh82C1OkcOP7KeRneJSWQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RTzzshcL9zfyU3XUuzc2hryboVSy715i4LE8RDcgxvmnQd0sRMCAjIpghfrwHsafX
	 E8thAFJHDCOinB8OU/vRGW457iTMog1iytGCIctly+8g1uPTIvHaASqw7UroIViols
	 YxgELylaaz1ff7yW6nNPC67hhc0RCN34VuzUJq4T7B2bwWP0Ildydbkm8KZwoUCxxq
	 25Wtz/bakbKZT0/UhmdpQWE6EwuPs/DcCT731bziMRS2FRxzzUuhlXByZO+uX8MoOf
	 Ygtb5EnvRtYfj7go5qQM8KkE7HSyR7XFo6rpqC8iiJi4F26cNLtvQuIgPOG9iykdfZ
	 4H8H9z0+gwBBg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 21/40] scsi: megaraid: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:42 +0900
Message-ID: <20260903034201.112211-22-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the megaraid driver to use the scsi_set_sense() function and
replace all hard-coded additional sense codes and additional sense code
qualifiers with the enum values defined in include/scsi/scsi_sense.h. This
helps with code clarity as the sense codes being processed are easier to
test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/megaraid.c               |  8 +++++---
 drivers/scsi/megaraid/mega_common.h   |  2 --
 drivers/scsi/megaraid/megaraid_mbox.c | 12 +++++++-----
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9476a0d2c72d..a4079866f747 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1592,9 +1592,11 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 						epthru->reqsensearea, 14);
 
 					cmd->result = SAM_STAT_CHECK_CONDITION;
-				} else
-					scsi_build_sense(cmd, 0,
-							 ABORTED_COMMAND, 0, 0);
+				} else {
+					scsi_set_sense(cmd, 0,
+						 ABORTED_COMMAND,
+						 NO_ADDITIONAL_SENSE_INFORMATION);
+				}
 			}
 			break;
 
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 2ad0aa2f837d..8e58599d5685 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -37,8 +37,6 @@
 #define PCI_CONF_AMISIG64		0xa4
 
 #define MEGA_SCSI_INQ_EVPD		1
-#define MEGA_INVALID_FIELD_IN_CDB	0x24
-
 
 /**
  * scb_t - scsi command control block
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index ce89032a5a74..b7319282e3c5 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1577,8 +1577,8 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp,
 			}
 
 			if (scp->cmnd[1] & MEGA_SCSI_INQ_EVPD) {
-				scsi_build_sense(scp, 0, ILLEGAL_REQUEST,
-						 MEGA_INVALID_FIELD_IN_CDB, 0);
+				scsi_set_sense(scp, 0, ILLEGAL_REQUEST,
+					       INVALID_FIELD_IN_CDB);
 				return NULL;
 			}
 
@@ -2311,9 +2311,11 @@ megaraid_mbox_dpc(unsigned long devp)
 						epthru->reqsensearea, 14);
 
 					scp->result = SAM_STAT_CHECK_CONDITION;
-				} else
-					scsi_build_sense(scp, 0,
-							 ABORTED_COMMAND, 0, 0);
+				} else {
+					scsi_set_sense(scp, 0,
+						ABORTED_COMMAND,
+						NO_ADDITIONAL_SENSE_INFORMATION);
+				}
 			}
 			break;
 
-- 
2.55.0

