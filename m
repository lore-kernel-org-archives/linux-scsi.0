Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399DEC43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 22:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1AA64F6A
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 22:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhCLW1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 17:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbhCLW1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 17:27:38 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A4C061574;
        Fri, 12 Mar 2021 14:27:38 -0800 (PST)
Received: by sf.home (Postfix, from userid 1000)
        id 9FDD95A22061; Fri, 12 Mar 2021 22:27:32 +0000 (GMT)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     linux-kernel@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>, linux-ia64@vger.kernel.org,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        Joe Szczypek <jszczype@redhat.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Don Brace <don.brace@microchip.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Date:   Fri, 12 Mar 2021 22:27:18 +0000
Message-Id: <20210312222718.4117508-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The failure initially observed as boot failure on rx3600 ia64 machine
with RAID bus controller: Hewlett-Packard Company Smart Array P600:

    kernel unaligned access to 0xe000000105dd8b95, ip=0xa000000100b87551
    kernel unaligned access to 0xe000000105dd8e95, ip=0xa000000100b87551
    hpsa 0000:14:01.0: Controller reports max supported commands of 0 Using 16 instead. Ensure that firmware is up to date.
    swapper/0[1]: error during unaligned kernel access

Here unaligned access comes from 'struct CommandList' that happens
to be packed. The change f749d8b7a ("scsi: hpsa: Correct dev cmds
outstanding for retried cmds") introduced unexpected padding and
un-aligned atomic_t from natural alignment to something else.

This change does not remove packing annotation from struct but only
restores alignment of atomic variable.

The change is tested on the same rx3600 machine.

CC: linux-ia64@vger.kernel.org
CC: storagedev@microchip.com
CC: linux-scsi@vger.kernel.org
CC: Joe Szczypek <jszczype@redhat.com>
CC: Scott Benesh <scott.benesh@microchip.com>
CC: Scott Teel <scott.teel@microchip.com>
CC: Tomas Henzl <thenzl@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Don Brace <don.brace@microchip.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Suggested-by: Don Brace <don.brace@microchip.com>
Fixes: f749d8b7a "scsi: hpsa: Correct dev cmds outstanding for retried cmds"
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/scsi/hpsa_cmd.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index d126bb877250..617bdae9a7de 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -20,6 +20,9 @@
 #ifndef HPSA_CMD_H
 #define HPSA_CMD_H
 
+#include <linux/build_bug.h> /* static_assert */
+#include <linux/stddef.h> /* offsetof */
+
 /* general boundary defintions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD	32 /* Max SG entries excluding chain blocks */
@@ -448,11 +451,20 @@ struct CommandList {
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
 
-	bool retry_pending;
+	int retry_pending;
 	struct hpsa_scsi_dev_t *device;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 
+/*
+ * Make sure our embedded atomic variable is aligned. Otherwise we break atomic
+ * operations on architectures that don't support unaligned atomics like IA64.
+ *
+ * Ideally this header should be cleaned up to only mark individual structs as
+ * packed.
+ */
+static_assert(offsetof(struct CommandList, refcount) % __alignof__(atomic_t) == 0);
+
 /* Max S/G elements in I/O accelerator command */
 #define IOACCEL1_MAXSGENTRIES           24
 #define IOACCEL2_MAXSGENTRIES		28
-- 
2.30.2

