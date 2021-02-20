Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6EDC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A9C64ED7
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBTVim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:38:42 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:14596 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTVil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857121; x=1645393121;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lU6zMaKG8LbhBB/Xn68UjJ1cwLXPMILhA4Tb/E44PSo=;
  b=KkV3y9/xFWD2mJQu6Nui+3Ye5nCWNk4XKWcDXG0lzk1yiL8nU1Z6ZYgZ
   gmgXsY/b8q1dxUWk9OIZK4tMr39HmFWdj95nsMR97A1ZGbxrNrJKPoQak
   vtdvtfNo3kN9OO/TjVemuv22sd9zzbeJlgUGkWA2d4c0W3naX2SJEIiI+
   XqLQ9pZ7uqbHUW3IbXw8XCNepms3eg/aEKn8HNCyu0NtO6UuCXJn8VsnR
   BbaJpzfGuc2XCoRy/JioNeH/2o3ExoTUgjI8q+j7e9kLgOxvuv/cGXaJV
   JT76OX/mBs351DngdrsGKIKUxXEnlaICKt2Z7ya9eEnxgWaVAfZDMIYZ4
   w==;
IronPort-SDR: tDGL93ctwgxP7HtJ8GHtrO8AoTmjBrLuua84sS+UDTXJJcwuKbKDjUqnD072H6Ib/BvrYluRZi
 cLm2Cui5OW7wmMT7VeIFdL9ugY9iU3IvD+gNX/sO8EANonxjpsBvJcjX+X505tR6s/l++fj0ni
 V+JSDT7kYAc+JjqGd5Efsy7P2TCt+Cz5dPDdxGB8GAUuW4Uz+kyFtW40Xs1u0EuNL/S1PlnjWU
 CZhAnCazLhFdhYmzq1+HV+WYE0hsTjFyxHwnqxocm0igf5yoCbzckNDo6Ko303lAPNZYRbn3x6
 Vnk=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591266"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:37:38 +0800
IronPort-SDR: s9EG4MmG1fRGpd9AKa1O67ocJVlQO/KucoyLiG17RVtxwVcnJ+7ldVZzyJzWqTA6vD4ElbRbwv
 g3vpwKhiCNpTcplPxaXrHmjXI/adOT/3bS6zeWh4Zypqa9xxhZFxxbfGpntYSkqoaMRYUvs/OB
 ePJ6ch2p1baLmIsvpCw1KxXMz52p19RZ9Wmbw/zAL0C3oAJxZe3JesDA0kuOymMVH9niGIEBBu
 etQO8PXAKny0FHBEsBqvN3Bh3ogz+WvK3vbq84fxY2+fF8TCGt4oMzUsCHfMNcL37hKxXvpSqu
 Ex05U9qrs+vXRv1ZdMBw4mY7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:21:00 -0800
IronPort-SDR: bi349pejCMqWSK+LAejhoIw7AcXIaBBkgndkUeXWGM7lubbLBgUUfHZWUWJzUqHe9znVDGEG9T
 tGohQibMaMgpRrgT3tLAcvpGtKGC62xoQREea6p0PDvfJVWIpm+6fvwpU1x6F/N0LHIFKMSsbT
 JF8rgIi815uJdY2hFCOP4BwvFGxvdeu19sSwfBJv0GxRu+QX7kT9xFDH4PVRuzFm2sOurJTUiP
 oQ4nmZGYji5OvAYiD3S89fxptCnCvUjMp4SE67MRM3bXH2Rv+TvnAP4xDQL3NR2fOpQNCFJvyL
 bbM=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:37:37 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 04/24] targe/pscsi: fix the warning in pscsi_complete_cmd
Date:   Sat, 20 Feb 2021 13:37:36 -0800
Message-Id: <20210220213736.6488-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the warning in pscsi_complete_cmd():-

    drivers/target/target_core_pscsi.c: In function ‘pscsi_complete_cmd’:
    drivers/target/target_core_pscsi.c:624:5: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
         ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
         ^

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 33770e5808ce..003f6867ceb0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -620,8 +620,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
-			if (!buf)
+			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
+			}
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
-- 
2.22.1

