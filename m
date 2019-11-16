Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDB4C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5796B21844
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920075;
	bh=S6U2qzUqNJVgEYYa4WE0Mi8QIFME/YpoalQe60XZ0+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PFjSLmi7p7cE+JgD8sZGXdwmko/1j97thNtaTuFVT37Tx/gFRH0Ij5avjpJlpfmWp
	 cEOoOUMuG3cghHp5gGwPrPG/ozWDjbNy1MUaA/rNzKQLFYe6KzYyyILfi8BlN4dDV8
	 MjK63K4GSgy/IS68UVusZ4+tSXj0VA2KC7pI7lh0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbfKPQBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbfKPPxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D270218AE;
        Sat, 16 Nov 2019 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919597;
        bh=S6U2qzUqNJVgEYYa4WE0Mi8QIFME/YpoalQe60XZ0+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6DgqJZVkUsEw0e98aMbKducB12bA4MbKw8GIqd17eKuAM/2ySbiIQHKHJk92cjrs
         KqXKoWq2uvK6yEXl98meiy81vVJ1uVW4EL/UabNxSBmA4h/+V1vHo1txj3+L2J8aJc
         h1SysufhnTiAf98A+E8jsPfMFJA4jI+REB5LINZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 85/99] scsi: megaraid_sas: Fix msleep granularity
Date:   Sat, 16 Nov 2019 10:50:48 -0500
Message-Id: <20191116155103.10971-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 9155cf30a3c4ef97e225d6daddf9bd4b173267e8 ]

In megasas_transition_to_ready() driver waits 180seconds for controller to
change FW state. Here we are calling msleep(1) in a loop for this.  As
explained in timers-howto.txt, msleep(1) will actually sleep longer than
1ms. If a faulty controller is connected, we will end up waiting for much
more than 180 seconds causing unnecessary delays during load.

Change the granularity of msleep() call from 1ms to 1000ms.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d90693b2767fd..c5cc002dfdd5c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3694,12 +3694,12 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		/*
 		 * The cur_state should not last for more than max_wait secs
 		 */
-		for (i = 0; i < (max_wait * 1000); i++) {
+		for (i = 0; i < max_wait; i++) {
 			curr_abs_state = instance->instancet->
 				read_fw_status_reg(instance->reg_set);
 
 			if (abs_state == curr_abs_state) {
-				msleep(1);
+				msleep(1000);
 			} else
 				break;
 		}
-- 
2.20.1

