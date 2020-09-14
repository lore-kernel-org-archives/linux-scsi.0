Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367DBC2BC11
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D43207EA
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600094697;
	bh=9DiVjW71ekwEdibZggUMrhbwn3fZDsgJ9O9o97eQizI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KWrW08HDmoH47XozAqLUi02yd8Y4ERw3SmspzozspgKqkobAmnm73Ow1hWtVQ+PjV
	 aJ0ET4NWf+xlE9dcnBuz70kI4Ry3cNlk59TS7Q45BIFZ78rCqSyPviYtYPTFwSCday
	 yYxq2r0vg2rG2E/F6OMX1AIHMxYx1d5TpL56GpkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgINOop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgINNF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F372222B;
        Mon, 14 Sep 2020 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088678;
        bh=9DiVjW71ekwEdibZggUMrhbwn3fZDsgJ9O9o97eQizI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1rNB+6pF/cYvwkzc8ADO2WRTs0M9WPJuTbguQjSImyXe3TCwk05FnSECLMJHjHjT
         1vHezq1ZDLkwSUWXkVPurEPsSFy4jme10f5itM6MQuch4R402XBYgfc5bpxf+Ftlv5
         fGXGvr12GggcNzYNzflrjm0NDgSIem0XluRtt+Ss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/22] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Mon, 14 Sep 2020 09:04:14 -0400
Message-Id: <20200914130434.1804478-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130434.1804478-1-sashal@kernel.org>
References: <20200914130434.1804478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit ea403fde7552bd61bad6ea45e3feb99db77cb31e ]

When pm8001_tag_alloc() fails, task should be freed just like it is done in
the subsequent error paths.

Link: https://lore.kernel.org/r/20200823091453.4782-1-dinghao.liu@zju.edu.cn
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 7e48154e11c36..027bf5b2981b9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -816,7 +816,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
-- 
2.25.1

