Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B942C2D0C7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 16:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E742073D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576080079;
	bh=pPZOpeTDPAH4QgP6oGmlTaKoc1YHhiED9ZDWU3vJnSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=P5pE6lW79LvzpmwyS6y2wzIiYs6xgKRMqbS9Vzv4syT7XyPuAPtFCgSlU8irWnLt9
	 6fF58IopbP39JJkYnuaYbZW5Cf3n+mjIABmnSogNYu3eY3iOoGw2nYDp3oM+g/ULms
	 KP/9z/NlcJdCGxkL2EEE3/6gBk3TsqnkMAGZCgMo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbfLKQBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731433AbfLKPNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3623224683;
        Wed, 11 Dec 2019 15:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077211;
        bh=pPZOpeTDPAH4QgP6oGmlTaKoc1YHhiED9ZDWU3vJnSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFgVJhiyNe+EGpHJe86QQRujkdjzIgofeij1iLjUbj1VrUlMxw/XcXvpQS/zW7hgf
         QPr8CnajZ7Qc+/NJue3MPzAZBFXSnMJAW/y/bxxBSoiN0KLglyDEe4jUM0yIaxQ6QR
         pwB2liQ4Jot1ZWUs+0MzCmmbN26wBepi2zVwqIBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 093/134] scsi: scsi_debug: num_tgts must be >= 0
Date:   Wed, 11 Dec 2019 10:11:09 -0500
Message-Id: <20191211151150.19073-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit aa5334c4f3014940f11bf876e919c956abef4089 ]

Passing the parameter "num_tgts=-1" will start an infinite loop that
exhausts the system memory

Link: https://lore.kernel.org/r/20191115163727.24626-1-mlombard@redhat.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9de..32965ec76965a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5263,6 +5263,11 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdebug_num_tgts < 0) {
+		pr_err("num_tgts must be >= 0\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_guard > 1) {
 		pr_err("guard must be 0 or 1\n");
 		return -EINVAL;
-- 
2.20.1

