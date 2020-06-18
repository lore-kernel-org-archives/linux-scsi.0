Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353D9C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C53220884
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446372;
	bh=tTYjXOD8oHPGv57EVtZqi6gCt2pfErDoIHKj/yUv3Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YfTmDICSiE/Ur0czB99K8Gkvjn/Tcz854bB28AMUbuus+XZjuu0sFiuLzz37KskOk
	 FFU7UvX/LPmT0VG4oXGImGxvw4uydyGHuNDwrRIhdef6Ek8WHtfF1PHibYCUgWys4H
	 dCzqr1oYlvjdRrdkN5DlB9ucKiI/OHxT2fwGUDLY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgFRBVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729046AbgFRBVP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC8E20CC7;
        Thu, 18 Jun 2020 01:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443275;
        bh=tTYjXOD8oHPGv57EVtZqi6gCt2pfErDoIHKj/yUv3Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0IC52wJIbYONqY0i5oKZ2CkEqB7Qy47/T9mkGxM16hK//8Y5xnTzKUEtuIdNUMTF
         cZwyWSh1Fep/w5Pao/Z2z1FaTN4sDcZnhgsuSQb+WQ9dRuGSdZ78603tUwqi7BsjMU
         hgZ9hUwKBTqxFKnlm9PSKcYq0ovFG8wZaFt6gUBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 220/266] scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj
Date:   Wed, 17 Jun 2020 21:15:45 -0400
Message-Id: <20200618011631.604574-220-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 0267ffce562c8bbf9b57ebe0e38445ad04972890 ]

kobject_init_and_add() takes reference even when it fails. If this
function returns an error, kobject_put() must be called to properly
clean up the memory associated with the object.

Link: https://lore.kernel.org/r/20200528201353.14849-1-wu000273@umn.edu
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_boot_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index e4857b728033..a64abe38db2d 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -352,7 +352,7 @@ iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_kset,
 	boot_kobj->kobj.kset = boot_kset->kset;
 	if (kobject_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,
 				 NULL, name, index)) {
-		kfree(boot_kobj);
+		kobject_put(&boot_kobj->kobj);
 		return NULL;
 	}
 	boot_kobj->data = data;
-- 
2.25.1

