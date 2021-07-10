Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EB0C07E9E
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 02:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6269661419
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 02:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhGJCaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 22:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233829AbhGJC2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275CD6141E;
        Sat, 10 Jul 2021 02:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883910;
        bh=JPtE6/POe2kzDiNAsnf2rJwrMZwZuBqlLA51f9qPsE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmeREEa1SADrSV3P5GBGeq+y/0yimPz0dpdu6PGid/RSDmAXuKnuGeVaLPSoIGDqd
         rEY7SuUKCXv4f03MY/MVwVorhahf2SYTc89Pv3N5yy0QT1lQKBEEWPOum9x9Yl2KAF
         c3pT2GFzQAJQUs7+P4rT9q7Gn8DCIIL19O/HxYWbI91EsJcKNM+96E7byg6zCmPGCL
         MV258sc0YMKeoeITpEhD7TL3UtROzIP/w/VppaBVcyERlfMhmnifhJ1B4+HTdJBRjf
         799o+M3ZdFO8Lw7M6DIF0lve7CPMZFUFBcLQFpci4cW536lG75Oivd5+Ymm8Xtl4YF
         b/gqfdCLeiSMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/93] scsi: scsi_dh_alua: Check for negative result value
Date:   Fri,  9 Jul 2021 22:23:26 -0400
Message-Id: <20210710022428.3169839-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 7e26e3ea028740f934477ec01ba586ab033c35aa ]

scsi_execute() will now return a negative error if there was an error prior
to command submission; evaluate that instead if checking for DRIVER_ERROR.

[mkp: build fix]

Link: https://lore.kernel.org/r/20210427083046.31620-6-hare@suse.de
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index df5a3bbeba5e..4743317a269a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -548,12 +548,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			kfree(buff);
 			return SCSI_DH_OK;
 		}
-		if (!scsi_sense_valid(&sense_hdr)) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
 			kfree(buff);
-			if (driver_byte(retval) == DRIVER_ERROR)
+			if (retval < 0)
 				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
 		}
@@ -775,11 +775,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
 	if (retval) {
-		if (!scsi_sense_valid(&sense_hdr)) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: stpg failed, result %d",
 				    ALUA_DH_NAME, retval);
-			if (driver_byte(retval) == DRIVER_ERROR)
+			if (retval < 0)
 				return SCSI_DH_DEV_TEMP_BUSY;
 		} else {
 			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
-- 
2.30.2

