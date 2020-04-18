Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C138C3A5A0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 20:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D80B2223D
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 20:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="DjxMHR7w";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HnnkUL4C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgDRUKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 16:10:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37190 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728143AbgDRUKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 16:10:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 154E68EE0BA;
        Sat, 18 Apr 2020 13:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587240639;
        bh=fxSMBWAcHn46gPyGniIU6pk1DWt9Hm05+Mq6xkW1veY=;
        h=Subject:From:To:Cc:Date:From;
        b=DjxMHR7wn6+hfqFJwYsZaaoPMJEQxp9Ph1ncIpTrZ1nSnTB05q3hSLsGXnJ2D3oU2
         ZOXbqsyvpkRX+/ZzwW2R6qkDH3e9cUYfe9/ubkBC2lrr1bqeUOvX7TzA3Jj3QwCing
         AsBJ50KLIz4HIspkDmSUWTohdzlvUDh+DiLIzhA8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oh4tofBabwqc; Sat, 18 Apr 2020 13:10:38 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 7341F8EE0AB;
        Sat, 18 Apr 2020 13:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587240638;
        bh=fxSMBWAcHn46gPyGniIU6pk1DWt9Hm05+Mq6xkW1veY=;
        h=Subject:From:To:Cc:Date:From;
        b=HnnkUL4CCXrzs1iTreLsyzkqEv5Kch51WXCX2wU5CBV7GcgFANcojRolmRGuj01in
         V4qITew6KX3QQ12Uz0FGCiSP79bKgOvrSa8WaKAkvgpcD4/Wzc0v24IMZM26owZcZQ
         s5jPp7sFFVL7uiq8S3ZIxx8hr45sIBEE/I2dX0vw=
Message-ID: <1587240636.7897.11.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.7-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 18 Apr 2020 13:10:36 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seven fixes; three in target, one on a sg error leg, two in qla2xxx
fixing warnings introduced in the last merge window and updating
MAINTAINERS and one in hisi_sas fixing a problem introduced by libata.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bodo Stroesser (3):
      scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
      scsi: target: fix PR IN / READ FULL STATUS for FC
      scsi: target: Write NULL to *port_nexus_ptr if no ISID

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Nilesh Javali (2):
      scsi: MAINTAINERS: Update qla2xxx FC-SCSI driver maintainer
      scsi: qla2xxx: Fix regression warnings

YueHaibing (1):
      scsi: hisi_sas: Fix build error without SATA_HOST

And the diffstat:
 MAINTAINERS                             | 3 ++-
 drivers/scsi/hisi_sas/Kconfig           | 1 +
 drivers/scsi/qla2xxx/qla_dbg.c          | 3 ++-
 drivers/scsi/qla2xxx/qla_init.c         | 2 --
 drivers/scsi/qla2xxx/qla_isr.c          | 1 -
 drivers/scsi/qla2xxx/qla_mbx.c          | 2 --
 drivers/scsi/sg.c                       | 4 +++-
 drivers/target/target_core_fabric_lib.c | 5 +++--
 drivers/target/target_core_user.c       | 1 +
 9 files changed, 12 insertions(+), 10 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index e64e5db31497..e9a621e9f2aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13853,7 +13853,8 @@ S:	Maintained
 F:	drivers/scsi/qla1280.[ch]
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
-M:	hmadhani@marvell.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/LICENSE.qla2xxx
diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 90a17452a50d..13ed9073fc72 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -6,6 +6,7 @@ config SCSI_HISI_SAS
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
 	depends on ATA
+	select SATA_HOST
 	help
 		This driver supports HiSilicon's SAS HBA, including support based
 		on platform device
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f301a8048b2f..bf1e98f11990 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2539,7 +2539,6 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 {
 	va_list va;
 	struct va_format vaf;
-	char pbuf[64];
 
 	va_start(va, fmt);
 
@@ -2547,6 +2546,8 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	vaf.va = &va;
 
 	if (!ql_mask_match(level)) {
+		char pbuf[64];
+
 		if (vha != NULL) {
 			const struct pci_dev *pdev = vha->hw->pdev;
 			/* <module-name> <msg-id>:<host> Message */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b2deaa730bf..caa6b840e459 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3611,8 +3611,6 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
 			ha->lr_distance = LR_DISTANCE_5K;
 	}
 
-	if (!vha->flags.init_done)
-		rc = QLA_SUCCESS;
 out:
 	ql_dbg(ql_dbg_async, vha, 0x507b,
 	    "SFP detect: %s-Range SFP %s (nvr=%x ll=%x lr=%x lrd=%x).\n",
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8d7a905f6247..8a78d395bbc8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -87,7 +87,6 @@ qla24xx_process_abts(struct scsi_qla_host *vha, void *pkt)
 	}
 
 	/* terminate exchange */
-	memset(rsp_els, 0, sizeof(*rsp_els));
 	rsp_els->entry_type = ELS_IOCB_TYPE;
 	rsp_els->entry_count = 1;
 	rsp_els->nport_handle = ~0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9fd83d1bffe0..4ed90437e8c4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4894,8 +4894,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	els_cmd_map[index] |= 1 << bit;
 
 	mcp->mb[0] = MBC_SET_RNID_PARAMS;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4e6af592f018..9c0ee192f0f9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -793,8 +793,10 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (hp->dxfer_len >= SZ_256M)
+	if (hp->dxfer_len >= SZ_256M) {
+		sg_remove_request(sfp, srp);
 		return -EINVAL;
+	}
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6b4b354c88aa..1e031d81e59e 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -63,7 +63,7 @@ static int fc_get_pr_transport_id(
 	 * encoded TransportID.
 	 */
 	ptr = &se_nacl->initiatorname[0];
-	for (i = 0; i < 24; ) {
+	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
 			continue;
@@ -341,7 +341,8 @@ static char *iscsi_parse_pr_out_transport_id(
 			*p = tolower(*p);
 			p++;
 		}
-	}
+	} else
+		*port_nexus_ptr = NULL;
 
 	return &buf[4];
 }
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0b9dfa6b17bc..f769bb1e3735 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2073,6 +2073,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_tail = 0;
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 
 	del_timer(&udev->cmd_timer);
 

