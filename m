From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 02/22] zfcp: use setup_timer instead of init_timer
Date: Fri, 28 Jul 2017 12:30:48 +0200
Message-ID: <d820492c73697e8a187735b03e14e54657333208.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36969 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751674AbdG1KbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASxaf015644
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2byyg8345y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:11 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAV9uE37486838
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EB0711C096
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:21 +0100 (BST)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01A3311C094
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:21 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:20 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: =?UTF-8?q?Luk=C3=A1=C5=A1=20Koren=C4=8Dik?= <xkorenc1@fi.muni.cz>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Lukáš Korenčik <xkorenc1@fi.muni.cz>

Use initialization with setup_timer function instead of using
init_timer function and data fields. It improves readability.

Signed-off-by: Lukáš Korenčik <xkorenc1@fi.muni.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 7ccfce559034..37408f5f81ce 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -572,9 +572,8 @@ static void zfcp_erp_memwait_handler(unsigned long data)
 
 static void zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
 {
-	init_timer(&erp_action->timer);
-	erp_action->timer.function = zfcp_erp_memwait_handler;
-	erp_action->timer.data = (unsigned long) erp_action;
+	setup_timer(&erp_action->timer, zfcp_erp_memwait_handler,
+		    (unsigned long) erp_action);
 	erp_action->timer.expires = jiffies + HZ;
 	add_timer(&erp_action->timer);
 }
-- 
2.11.2
