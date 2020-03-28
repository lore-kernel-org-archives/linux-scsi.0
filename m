Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEDFC2D0EB
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 15:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A233420716
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 15:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ufXO40vN";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="CKm3/sKW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgC1PZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 11:25:50 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56560 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgC1PZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Mar 2020 11:25:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 4D9038EE182;
        Sat, 28 Mar 2020 08:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1585409149;
        bh=7ol25urUbt6cSQxZY2to1Yas4j/y3AL+k7+hznk8G0k=;
        h=Subject:From:To:Cc:Date:From;
        b=ufXO40vNUXvjmP6zq45Oq+xBMt3IYmqyBzxidj4D0WZiREa6hqATUYVX8hA8EVlPx
         +89ZXfN/hTgMdFi3LqI/lxADZApgroLv4qNkq9M6O7Eq1j+caAE42vP57DCB8ezHUA
         P0VsqMNPCoWLNiFFwHaTVFf0ByDD7aGL8l8ajiH8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AHvwi3JfKNAC; Sat, 28 Mar 2020 08:25:48 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D14B18EE111;
        Sat, 28 Mar 2020 08:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1585409147;
        bh=7ol25urUbt6cSQxZY2to1Yas4j/y3AL+k7+hznk8G0k=;
        h=Subject:From:To:Cc:Date:From;
        b=CKm3/sKW+PbI19924tZmS+he76JP0rtTTjXUOJx2nHH9UitI6XztPmbyscq5bXHcy
         +vRDhpyT08zTiBQtxm9d7oIZ72pJDgLLtLv2HUiUnmfSmoxaYUtZ9+h6ubQiDzeRhP
         TDEasqZvQzJb4rhP33mnPUA6xksuEXU0CNHGrDJo=
Message-ID: <1585409145.15200.3.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.6-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 28 Mar 2020 08:25:45 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two small fixes, one in drivers (qla2xxx) and one in the core (sd) to
try to cope with USB enclosures that silently change reported
parameters.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arun Easi (1):
      scsi: qla2xxx: Fix I/Os being passed down when FC device is being deleted

Martin K. Petersen (1):
      scsi: sd: Fix optimal I/O size for devices that change reported values

And the diffstat:

 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 drivers/scsi/sd.c             | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b520a980d1dc..7a94e1171c72 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -864,7 +864,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto qc24_fail_command;
 	}
 
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			ql_dbg(ql_dbg_io, vha, 0x3005,
@@ -946,7 +946,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		goto qc24_fail_command;
 	}
 
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			ql_dbg(ql_dbg_io, vha, 0x3077,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca9299ffd36..2710a0e5ae6d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3169,9 +3169,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
+	} else {
+		q->limits.io_opt = 0;
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
 				      (sector_t)BLK_DEF_MAX_SECTORS);
+	}
 
 	/* Do not exceed controller limit */
 	rw_max = min(rw_max, queue_max_hw_sectors(q));
