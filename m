Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4053C33CAD
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 13:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C44402084D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 13:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgAMNRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 08:17:24 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8711 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726505AbgAMNRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 08:17:24 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6236633D25C349FB4E2;
        Mon, 13 Jan 2020 21:17:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Mon, 13 Jan 2020 21:17:14 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH] scsi: csiostor: simplify macro CSIO_VALID_WWN
Date:   Mon, 13 Jan 2020 21:12:47 +0800
Message-ID: <20200113131247.141554-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conversion to bool is in macro CSIO_VALID_WWN not needed, remove it.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/scsi/csiostor/csio_defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_defs.h b/drivers/scsi/csiostor/csio_defs.h
index c38017b..c5049e3 100644
--- a/drivers/scsi/csiostor/csio_defs.h
+++ b/drivers/scsi/csiostor/csio_defs.h
@@ -46,7 +46,7 @@
 #define CSIO_INVALID_IDX		0xFFFFFFFF
 #define CSIO_INC_STATS(elem, val)	((elem)->stats.val++)
 #define CSIO_DEC_STATS(elem, val)	((elem)->stats.val--)
-#define CSIO_VALID_WWN(__n)		((*__n >> 4) == 0x5 ? true : false)
+#define CSIO_VALID_WWN(__n)		((*__n >> 4) == 0x5)
 #define CSIO_DID_MASK			0xFFFFFF
 #define CSIO_WORD_TO_BYTE		4
 
-- 
2.7.4

