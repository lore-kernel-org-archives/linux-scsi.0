Return-Path: <SRS0=1VAV=WG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D1AC32751
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Aug 2019 21:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E1C2085B
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Aug 2019 21:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LKE/3eng"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHJVTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Aug 2019 17:19:06 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18081 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfHJVTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Aug 2019 17:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565471947; x=1597007947;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vz6doSWrgt+VF7RB1ZPlJqx3Dg2TF1XRt1ORZGZVpgg=;
  b=LKE/3engzjS7Q4q9ycg2MovK4wudv76m3q65XvmSL4VdQQyTntWVQCsq
   4Jxbgis1MSXaMGU/A/Klz/KX/Mlm5nAdO+AD5fcH9hEytEBUfB6aq2s3P
   jVdspAazqGqYr/hE1F7mqmelVRu+Pvca8nYln6szG2UjUBTfOBXDMDBPy
   S1NY64VPoTN0SljNi9GseES4eXQ71RDimG+MA7piQ1Vj0HG5rQas5+Psl
   Anu1GGNLYITzFpUWHVKcsgtE1OPJfxBgf3UL9EIthvekWTo/Wifp7jOCa
   NESbVRRJ+kTn4NbDkoa1AGrJycwujaCgcFtGOJmfs/y+HAldZTnonJmvr
   Q==;
IronPort-SDR: aeO6KRg3ruyq1Oskte7/MZy+BX+WsTYc4vslXafuP/1gl5V1sl4kURuWr+1YOUS8BS72CtlVzA
 6JJxFlJ9/eYhlKbuDlaZA3baUu7Su/ZWBvgelvdTjFEyU8Gg1p4rftAJqhnKnxUrPPz+PA8NSs
 VzeU3sAnbCB4/G50KyrFPYVG4MmMg6SLdZJNk0bawIQF53nQoGTlQKnelcaIFqOh9TQOX4RBI8
 XqNG1WAhBwgP/p81t2Nqcj3d2KR54kLiBz5kxmXyLTc0JepbiA24jJgod2X4v+3rqkNREYAxfr
 i7g=
X-IronPort-AV: E=Sophos;i="5.64,370,1559491200"; 
   d="scan'208";a="116512329"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2019 05:19:06 +0800
IronPort-SDR: 8+DrJLfzaEyNU8plSpyKZvEqcqI26YHexRE4cqOn8aBBniI8oIJPca0MsJ1xFAkV4dkerad7fk
 PZ4zy2MPV4hOcQhN3Av61ZyRhWmk86poUsizOkXK+ekEjPVCW0ckGEb/rtmQPh4YRLc6+kUVRM
 aaejEzWU0M+KbXWacnA5WkEIKxTjzGxRiB8pqDWpdy6Kqn/YlLJ1a+ARilRIJbMhPrv8EHUapP
 +WKE00koTwAO74Waz2pGtNqzDMULGB0nuMWw/zIBBpZiuqtpnfa9HDOz0icJKLqTQZBiksMOgp
 dxIXtuEofsdolrlDdtvLTegh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2019 14:16:45 -0700
IronPort-SDR: SZYSiCS7n1dRqel+x7TOez1Vq1BCLcgZTQTP3YZp3m8P+R8iF3SGxEYdPzz5IupjReA3T1cfU3
 EjuSJWzk8VjUWKgRDaEM0US+EmlC+qew0DbQISgkNk06IlyZBaiRx3lXMezINVdGNATX4qRWhJ
 5jkcX9pHiE5NINtx5NJA7R3u+S+2CQqBmYtHbQA71nVkAtDJhnEB78elwuU+2QI/03SvuXtvAU
 H1s09hoTWKO3FwXNe1YnK6qvDYhO8jsitT22Peh07uN3uQg21X4KFv/V22FqQtl1silKaeYo8O
 XIw=
Received: from dhcp-10-88-173-43.hgst.com (HELO localhost.localdomain) ([10.88.173.43])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Aug 2019 14:19:05 -0700
From:   Dmitry Fomichev <dmitry.fomichev@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] tcmu: avoid use-after-free after command timeout
Date:   Sat, 10 Aug 2019 14:19:03 -0700
Message-Id: <20190810211903.6572-1-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In tcmu_handle_completion() function, the variable called read_len is
always initialized with a value taken from se_cmd structure. If this
function is called to complete an expired (timed out) out command, the
session command pointed by se_cmd is likely to be already deallocated by
the target core at that moment. As the result, this access triggers a
use-after-free warning from KASAN.

This patch fixes the code not to touch se_cmd when completing timed out
TCMU commands. It also resets the pointer to se_cmd at the time when the
TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
after calling target_complete_cmd() later in the same function,
tcmu_check_expired_cmd().

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 drivers/target/target_core_user.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 04eda111920e..a0231491fa36 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
 	bool read_len_valid = false;
-	uint32_t read_len = se_cmd->data_length;
+	uint32_t read_len;
 
 	/*
 	 * cmd has been completed already from timeout, just reclaim
 	 * data area space and free cmd
 	 */
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		WARN_ON_ONCE(se_cmd);
 		goto out;
+	}
 
 	list_del_init(&cmd->queue_entry);
 
@@ -1152,6 +1154,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		goto done;
 	}
 
+	read_len = se_cmd->data_length;
 	if (se_cmd->data_direction == DMA_FROM_DEVICE &&
 	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
 		read_len_valid = true;
@@ -1307,6 +1310,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		list_del_init(&cmd->queue_entry);
+		cmd->se_cmd = NULL;
 	} else {
 		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
-- 
2.21.0

