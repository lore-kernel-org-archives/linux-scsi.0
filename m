From: Rameshwar Prasad Sahu <rsahu@apm.com>
Subject: [PATCH v2] ata: fixes kernel crash while tracing ata_eh_link_autopsy event
Date: Thu,  2 Nov 2017 16:31:07 +0530
Message-ID: <1509620467-6679-1-git-send-email-rsahu@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.137.200.161] ([198.137.200.161]:39259 "EHLO
        denmail01.amcc.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755337AbdKBLBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2017 07:01:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Rameshwar Prasad Sahu <rsahu@apm.com>

When tracing ata link error event, the kernel crashes when the disk is
removed due to NULL pointer access by trace_ata_eh_link_autopsy API.
This occurs as the dev is NULL when the disk disappeared. This patch
fixes this crash by calling trace_ata_eh_link_autopsy only if "dev"
is not NULL.

v2 changes:
 Removed direct passing "link" pointer instead of "dev" in trace API.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
---
 drivers/ata/libata-eh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e4effef..ea20e0e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2264,8 +2264,8 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 		if (dev->flags & ATA_DFLAG_DUBIOUS_XFER)
 			eflags |= ATA_EFLAG_DUBIOUS_XFER;
 		ehc->i.action |= ata_eh_speed_down(dev, eflags, all_err_mask);
+		trace_ata_eh_link_autopsy(dev, ehc->i.action, all_err_mask);
 	}
-	trace_ata_eh_link_autopsy(dev, ehc->i.action, all_err_mask);
 	DPRINTK("EXIT\n");
 }

--
1.7.1
