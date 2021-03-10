Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D92AC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 09:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1E2A64FE8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 09:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhCJJtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 04:49:05 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:56389 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhCJJsK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 04:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615369689; x=1646905689;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nBvMeMVIq6Fc4QIoPBCdDIKvFqo3XAJEo/NWmVxLzUs=;
  b=MQ4tgY04ST7K70WJ43tkgHdj2yGLQ2MkPwphCrWfwQyhEfhcYcapuWer
   JH+mQ7oeKdCQO8VUqjKK15H+JQBoUbLvSqiwvaWJDRgpGYD7VTVhRz5Mn
   P5C365WurX82xvYZVOQiqp9Me5XZH6uR+D9+EROsJqlFH9MXP2Ltj3j7/
   fhQ0+EinrPG6PnLxLn05uHBdokK+ZS9hV0mYzgI9+sKR1VL8Mfk5fLEWA
   u7AXj6pNmPSG+OaxFzm66pjrOsqqqkF3KCg7G4t9ms/oLTZOKdZqwYoDt
   k9NtChacDh25+yw5pC77ZGfTE0d87ASPShiD3wuEWsU4MJFAVC0JK0YYy
   A==;
IronPort-SDR: aD5XqCcLfFsqtPLfgjDElD0kKczboP6pFwVdUQ2dGr2fSy+Jv/t12erYJ2p4j+O/GGNT1QEyKH
 o5DFKfRRPY+ZQPcsM5ND/kbRehaSb6onrefkFEcdkXMZs2beUtZKxvwcu9OoAUXv7hmaLloykA
 H9XNja5hLbcUnfKCIHvdFCVpXXUSqzrzez3ts/b8E/NljOanyJMczjZ2copHBgyB0XuIoKNSv3
 oENzZ0WsU6K+PaAXokEtjH/6V5m/xpcAiwlPSjAI3yxITWS2WDeigXqXZ247tDO0rJhuF0nxjI
 Gzw=
X-IronPort-AV: E=Sophos;i="5.81,237,1610380800"; 
   d="scan'208";a="161798511"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2021 17:48:09 +0800
IronPort-SDR: oytX486L85N94KGLMr7Jg4nqDOCkzN0T63FUzSVAuMD6WXrumMxfF5vWOiOeWGoxAQTRCWHjGa
 Rx2K9CDdzU5YeWRQ/QG5gsdzdp2pwL33YXufzMZUm9kprvkiIv2fL7unDuDfYnKffucP7zYSpb
 SUHpf13P62+i5fau78c6DJcj1T7A4Oywme6Z54B6aghsYQtMHDL4cmoGDIl2nXvwcT+V5OoVJe
 IXZh+LfVC+rOtmZTv+M5GqXilG2+0VwLc2hdLKlGgaTV+43v8zVGNv3tPenMnZGQ0G+IzDZmyB
 G5iNpJJtZ1jLuNKLtfC+RXaW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:29:06 -0800
IronPort-SDR: GCAxJ6xyIfWCPN7wfgaUbUDOu+ZxD+F5KVnOktOHmj+9LirfyTP5p2KZmBrzv8GOZXQHQPHqhU
 agWbteU4k8xbv8D+1SoPymdq3WD95sNw30IODRwXga9puVSNz8VgW16aFP0zwzWwKYuXP/bU7W
 RgO60qUtfm0elBK5Me7+6EUbyWsu+7yr8fEcIJI04qhXFI58VjrhptVVCx+Ru0M5BlRfNUFIAU
 BDBDM+r7wVYcYnimbQsUzcc6rBsZD1W93uaiDMWgTuYiE9UprzuYTx8VTrGdSXT152u4rC1pTQ
 ZzQ=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2021 01:48:09 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: sd_zbc: update write pointer offset cache
Date:   Wed, 10 Mar 2021 18:48:06 +0900
Message-Id: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Recent changes changed the completion of SCSI commands from Soft-IRQ
context to IRQ context. This triggers the following warning, when we're
completing writes to zoned block devices that go through the zone append
emulation:

 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2
 Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015
 RIP: 0010:__local_bh_disable_ip+0x3f/0x50
 RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006
 RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013
 RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd
 RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0
 R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200
 R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218
 FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0
 Call Trace:
  <IRQ>
  _raw_spin_lock_bh+0x18/0x40
  sd_zbc_complete+0x43d/0x1150
  sd_done+0x631/0x1040
  ? mark_lock+0xe4/0x2fd0
  ? provisioning_mode_store+0x3f0/0x3f0
  scsi_finish_command+0x31b/0x5c0
  _scsih_io_done+0x960/0x29e0 [mpt3sas]
  ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]
  ? __lock_acquire+0x166b/0x58b0
  ? _get_st_from_smid+0x4a/0x80 [mpt3sas]
  _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]
  ? lock_is_held_type+0x98/0x110
  ? find_held_lock+0x2c/0x110
  ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]
  _base_interrupt+0x8d/0xd0 [mpt3sas]
  ? rcu_read_lock_sched_held+0x3f/0x70
  __handle_irq_event_percpu+0x24d/0x600
  handle_irq_event+0xef/0x240
  ? handle_irq_event_percpu+0x110/0x110
  handle_edge_irq+0x1f6/0xb60
  __common_interrupt+0x75/0x160
  common_interrupt+0x7b/0xa0
  </IRQ>
  asm_common_interrupt+0x1e/0x40

Don't use spin_lock_bh() to protect the update of the write pointer offset
cache, but use spin_lock_irqsave() for it.

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd_zbc.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ee558675eab4..994f1b8e3504 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -280,27 +280,28 @@ static int sd_zbc_update_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
 static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
+	unsigned long flags;
 	unsigned int zno;
 	int ret;
 
 	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
 
-	spin_lock_bh(&sdkp->zones_wp_offset_lock);
+	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 	for (zno = 0; zno < sdkp->nr_zones; zno++) {
 		if (sdkp->zones_wp_offset[zno] != SD_ZBC_UPDATING_WP_OFST)
 			continue;
 
-		spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 		ret = sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,
 					     SD_BUF_SIZE,
 					     zno * sdkp->zone_blocks, true);
-		spin_lock_bh(&sdkp->zones_wp_offset_lock);
+		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 		if (!ret)
 			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,
 					    zno, sd_zbc_update_wp_offset_cb,
 					    sdkp);
 	}
-	spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 
 	scsi_device_put(sdkp->device);
 }
@@ -324,6 +325,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int wp_offset, zno = blk_rq_zone_no(rq);
+	unsigned long flags;
 	blk_status_t ret;
 
 	ret = sd_zbc_cmnd_checks(cmd);
@@ -337,7 +339,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 	if (!blk_req_zone_write_trylock(rq))
 		return BLK_STS_ZONE_RESOURCE;
 
-	spin_lock_bh(&sdkp->zones_wp_offset_lock);
+	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 	wp_offset = sdkp->zones_wp_offset[zno];
 	switch (wp_offset) {
 	case SD_ZBC_INVALID_WP_OFST:
@@ -366,7 +368,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 		*lba += wp_offset;
 	}
-	spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 	if (ret)
 		blk_req_zone_write_unlock(rq);
 	return ret;
@@ -445,6 +447,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int zno = blk_rq_zone_no(rq);
 	enum req_opf op = req_op(rq);
+	unsigned long flags;
 
 	/*
 	 * If we got an error for a command that needs updating the write
@@ -452,7 +455,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	 * invalid to force an update from disk the next time a zone append
 	 * command is issued.
 	 */
-	spin_lock_bh(&sdkp->zones_wp_offset_lock);
+	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 
 	if (result && op != REQ_OP_ZONE_RESET_ALL) {
 		if (op == REQ_OP_ZONE_APPEND) {
@@ -496,7 +499,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	}
 
 unlock_wp_offset:
-	spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 
 	return good_bytes;
 }
-- 
2.30.0

