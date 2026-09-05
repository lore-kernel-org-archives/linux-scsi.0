Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60826377A85;
	Sat,  5 Sep 2026 03:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578596; cv=none; b=VIblfF2omCVZ8mhqQT8lbMVmaGVW3YlzlFMcSJDhAnIABmequdgsDJexFZwxSPdAmBGUHPorBX1gJ2nfVEFcBV4IE1Z515so5IJmbaFR+tcRAmsL/X+r7QAx8iO38UW/B+V1iemjSwWMdZv0E51wDMcsi52Ron48VEnOXhWSLmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578596; c=relaxed/simple;
	bh=07mJ9Q7E+E/x9JtdKDiplYcVwpbNe7GxBLz/JZuQgwc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaK9nWQPAtuee8DykefQ7T0UFNtb61zwbYVedb2CypNjPwZJQaDHe1mGECaCsJvQygXlwpQb09MeHgzLCsKA57Vq5DdNIHmeMxt++7EmAS5X/kKI2IT+3gNkJndyS/xbNh/zHLi6hxPTWaRDG+uNSJJv4UfnsQADNLkam4J9FGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKAGbQYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKAGbQYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2491F00A3D;
	Sat,  5 Sep 2026 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578595;
	bh=xQCsLfEpvhASg+xGUM1bHJgh82C1OkcOP7KeRneJSWQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=GKAGbQYnmwPHRB0w72DXDbOVal7zyT9BjWKCmayYHiHrXG0QwQyMCO73iv+LQZMwn
	 7AxwkIExUAdrZS6cIFbEPq1gN1ILb8Qbh+OaExAMOTlhs6LfD87X50g0qQswFXbuKd
	 BMuqFXzJgmdJzySIljxiq7L9NL9hipA2h6Phnmgj6edL8Pktjxsj7j0+BCet6msQtO
	 jE3J5uKJRgHL3rEj7tm76fZULroakB2Cpvy+I574CweiHV+tMmJjND7wMgabsSwv97
	 IkIMQRJUDJ03RhIG/tTFu4wt2HusZl+l6abbphGi1K9+70W1/ORg6s8a5TEQhPuDpr
	 rE/eWCD4LZwCg==
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
Subject: [PATCH v4 21/40] scsi: megaraid: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:05 +0900
Message-ID: <20260905032224.509860-22-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905032224.509860-1-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
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

