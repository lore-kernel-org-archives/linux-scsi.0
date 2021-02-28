Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7154C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE6B64D5D
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhB1F6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:58:52 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47227 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhB1F6o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491923; x=1646027923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jV8FsyXd6VoT8Sccl2XFXrDLujX8ZltFvH/C2v8hOWg=;
  b=mxVyZo7jNniqzwoilxzuzI2p+6B8J1SZFz8jKjc7hk9qYXwNsPYk1uyb
   cMz/l5cKIV771cvyxkWOBdtmfBmij73d954a1e2OJpoqbXKjs3E8iIc7B
   WuXEd+q1mB8E90j8LmtWpK8vRj3pnGdsB5ttoG81fv9Xs3o+i3Lef0Ro7
   Ma95KicJcz23q+P+3zv+JMCEDF/RedbKmfcOS9Ka4DcE+GkdkDE6rCN44
   ZjrK/wIeHipcBek+Y8QsEgL6JN1DLtaI9xjlbqZk0WIa7KZbZ1tNTKzoF
   hNKhwDvu21HGiZpeqhPmRrkvo2OFbWWhOevB6B37IByo/heDcNZS5YDEJ
   w==;
IronPort-SDR: stO2vVazMgnNlZZGKY63KB/tuKnwHUaifaJi8WS1LkVMOI4jDvd7g2Rh0fLECRew9cfKoYo6c8
 aC3RRYCBd5+JIGRgtPK9d/5Pj4uQ6RzUQDIJgBsqObIlrl+vMtNGlxKHMCofzRWt3DKPqrfYco
 TdL9Pu/rg+RhJ7cDOlzaCT/Wg+/F/YIlvWo64qSso7GZgDM/SkrPaQ7Vp50MUd+fx2jnF2Xhtd
 lhOK17NuYzhum1ZH4q1An9JcH3/39V3DxhCyLWUtVGmSkh+u0yOlaB2c+HlE1BHTYx8lCSo2/A
 c7Q=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="160999419"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:57:35 +0800
IronPort-SDR: 9auC3s1nJFtvSrv2yZXq7NToNXkpdCHEHHOFErNJg5tqCcKxkWo5qy/3LL9aur2iUD+7TEDv//
 VgJfIPJnaOieY/ZT8LYNx8DuTBQ1iv8pL4oPvzOaGjehYzq36VI6osCz7wVEnH2K5tI/uGmpnE
 v5B8P8RqzNlII/P0uxxhJzh7yMGxyQIP16PthfoDndXCzpibVMUm5QxcP8IuFzfQ2Aaefg+mvk
 Po9fNfXmYYlzxwT+5/iHfZsfV9TwPMzQonNuiTdk0QDFv7rg1TefySUAb4XlFjh1BPSN7mAGjh
 gtqZNY0+UwbdumIJAnKPxPt8
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:46 -0800
IronPort-SDR: OqrDyhJXxB41kGAZRTjcHHoaEhgHapa7bxMVE4rA3Fl8yjSfG9sSLhVH8GgXUToV7L/3eYaZUP
 b4LaK25Fx4yRMa9X9Qqhbu1M1mX6bNWarNlumiUNXICsWWUTDKtmsMvj9/8F/h9AOXj5a864b6
 w6tCiREjRmsk/5daTZP+FfTX3Zq2nkNjbDsbzvENS46Nl98sdM6Wdryzrewd2lVi1jxBDquLRy
 y2CEd4QWM1SJrHLukzfUxOaT/TxB7jpQUzEKd1jfiXo976qTRC21AXkwH1j8Y1kiGpvWGdvLyU
 lR0=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:57:35 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 04/23] targe/pscsi: fix the warning in pscsi_complete_cmd
Date:   Sat, 27 Feb 2021 21:56:26 -0800
Message-Id: <20210228055645.22253-5-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the compilation warning in pscsi_complete_cmd():-

    drivers/target/target_core_pscsi.c: In function ‘pscsi_complete_cmd’:
    drivers/target/target_core_pscsi.c:624:5: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
         ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
         ^

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 3cbc074992bc..689e503e3301 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -620,8 +620,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
-			if (!buf)
+			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
+			}
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
-- 
2.22.1

