Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19380C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D944F21D7E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576852582;
	bh=RQzRcBuZsIpg/iLzmjEdBG4fBsc02bPgP9y1jmerNYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aj75Zx/3FahhpH06RfMMpjrAsz3d/5Fqmq+qLGnZTGaTomKyvv0Omf8FfGBXls8kZ
	 4BnP7DqpsheOJwvuzFMq4k8dtsTEywDckxv3O995MCzVKI20ah2r8YecbXA8oOUKOP
	 stksaDJKBZHcdjB3vXmOeBka0/6LnRGlx0R8ttPM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfLTOfC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 09:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbfLTOfC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 09:35:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB5BD2467F;
        Fri, 20 Dec 2019 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852501;
        bh=RQzRcBuZsIpg/iLzmjEdBG4fBsc02bPgP9y1jmerNYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Liy8EPSH6jKpOWa0xTe9mzzLsufd7nxiyYNDPGjRgu0YNaNmbJrIhRQSQpM9nAuCz
         Ro9MmjjWAopTchwFZEG/P6M9f3dgiBtKhtvMGcdDNqZRARCvS7mN0QQGUCj2Z8GTPa
         9y1ZE3WjKV7w+SDevuWbhZoaetevZAwzVattAVDo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/34] scsi: iscsi: qla4xxx: fix double free in probe
Date:   Fri, 20 Dec 2019 09:34:20 -0500
Message-Id: <20191220143433.9922-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fee92f25777789d73e1936b91472e9c4644457c8 ]

On this error path we call qla4xxx_mem_free() and then the caller also
calls qla4xxx_free_adapter() which calls qla4xxx_mem_free().  It leads to a
couple double frees:

drivers/scsi/qla4xxx/ql4_os.c:8856 qla4xxx_probe_adapter() warn: 'ha->chap_dma_pool' double freed
drivers/scsi/qla4xxx/ql4_os.c:8856 qla4xxx_probe_adapter() warn: 'ha->fw_ddb_dma_pool' double freed

Fixes: afaf5a2d341d ("[SCSI] Initial Commit of qla4xxx")
Link: https://lore.kernel.org/r/20191203094421.hw7ex7qr3j2rbsmx@kili.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 25c8ce54a976d..f8acf101af3d9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4280,7 +4280,6 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 	return QLA_SUCCESS;
 
 mem_alloc_error_exit:
-	qla4xxx_mem_free(ha);
 	return QLA_ERROR;
 }
 
-- 
2.20.1

