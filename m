From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ses: Fix wrong page error
Date: Tue, 1 Aug 2017 13:45:36 -0500
Message-ID: <d816c664-5d28-e924-2515-b0cc7ef46498@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33647 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751874AbdHASpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 14:45:40 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v71IcsWV111861
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2017 14:45:40 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c2unmtxdr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2017 14:45:40 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Tue, 1 Aug 2017 12:45:39 -0600
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

If a SES device returns an error on a requested diagnostic page,
we are currently printing an error indicating the wrong page
was received. Fix this up to simply return a failure and only
check the returned page when the diagnostic page buffer was
populated by the device.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ses.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index f1cdf32..8927f9f5 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -99,7 +99,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 
 	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
 				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
-	if (unlikely(!ret))
+	if (unlikely(ret))
 		return ret;
 
 	recv_page_code = ((unsigned char *)buf)[0];
-- 
1.8.3.1
