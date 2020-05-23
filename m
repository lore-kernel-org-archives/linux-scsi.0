Return-Path: <SRS0=JddF=7F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE061C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 00:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF5A20738
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 00:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="fDckYlRX";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="fDckYlRX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387427AbgEWAnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 20:43:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36310 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731169AbgEWAnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 May 2020 20:43:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5D41E8EE453;
        Fri, 22 May 2020 17:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1590194622;
        bh=sOKAHK5PnU0iTCaOEaYRSCMn48ivVogoeleYthdNfTc=;
        h=Subject:From:To:Cc:Date:From;
        b=fDckYlRXI/G85hpFaGc1llC/BHjHEncGJpR8sSBiOpEmpYxD+lR/M4DfkcU9gSx1T
         3EIneb9x5t7iv/Pr5yFQCiJxNqspUmDhiOYmUNVGf1ig19PiO617RhSIuP5eVUlDuM
         sYQ4zd1LP1J4SOnG0UYMFgZb8+n+H4MXMUkbDw20=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IT1oRr35ZQsY; Fri, 22 May 2020 17:43:42 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DF7048EE116;
        Fri, 22 May 2020 17:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1590194622;
        bh=sOKAHK5PnU0iTCaOEaYRSCMn48ivVogoeleYthdNfTc=;
        h=Subject:From:To:Cc:Date:From;
        b=fDckYlRXI/G85hpFaGc1llC/BHjHEncGJpR8sSBiOpEmpYxD+lR/M4DfkcU9gSx1T
         3EIneb9x5t7iv/Pr5yFQCiJxNqspUmDhiOYmUNVGf1ig19PiO617RhSIuP5eVUlDuM
         sYQ4zd1LP1J4SOnG0UYMFgZb8+n+H4MXMUkbDw20=
Message-ID: <1590194620.14721.28.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.7-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 22 May 2020 17:43:40 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three minor fixes, two in drivers, one to fix a hang after reset with
iSCSI, and one to avoid a spurious log message; and the final core one
to correct a suspend/resume miscount with quiesced devices.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bodo Stroesser (1):
      scsi: target: Put lun_ref at end of tmr processing

Can Guo (1):
      scsi: pm: Balance pm_only counter of request queue during system resume

Ewan D. Milne (1):
      scsi: qla2xxx: Do not log message when reading port speed via sysfs

And the diffstat:

 drivers/scsi/qla2xxx/qla_attr.c        |  3 ---
 drivers/scsi/scsi_pm.c                 | 10 ++++++++--
 drivers/target/target_core_transport.c |  1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 33255968f03a..2c9e5ac24692 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1850,9 +1850,6 @@ qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	ql_log(ql_log_info, vha, 0x70d6,
-	    "port speed:%d\n", ha->link_data_rate);
-
 	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
 }
 
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea37ecb..5f0ad8b32e3a 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -80,6 +80,10 @@ static int scsi_dev_type_resume(struct device *dev,
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
 	if (err == 0) {
+		bool was_runtime_suspended;
+
+		was_runtime_suspended = pm_runtime_suspended(dev);
+
 		pm_runtime_disable(dev);
 		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
@@ -93,8 +97,10 @@ static int scsi_dev_type_resume(struct device *dev,
 		 */
 		if (!err && scsi_is_sdev_device(dev)) {
 			struct scsi_device *sdev = to_scsi_device(dev);
-
-			blk_set_runtime_active(sdev->request_queue);
+			if (was_runtime_suspended)
+				blk_post_runtime_resume(sdev->request_queue, 0);
+			else
+				blk_set_runtime_active(sdev->request_queue);
 		}
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..264a822c0bfa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3350,6 +3350,7 @@ static void target_tmr_work(struct work_struct *work)
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
