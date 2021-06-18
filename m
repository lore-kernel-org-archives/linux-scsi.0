Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD476C48BE8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9DF61248
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhFRNpV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:45:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52484 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232427AbhFRNpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 09:45:20 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IDgt13031182;
        Fri, 18 Jun 2021 13:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=lWJgSMNp0rYD4E1FlMf918Y8XlWVaUFbpqyGt1Wza9Y=;
 b=pmH3EfmSEVeJlBEN7YPfo5+pLm/G8NqJ8qqhyULm0UIfV4zf9Kf/heVDAiw4dBifshIt
 c+5biEWzOp4/xqIVpW3Zy/CZrP+jro+5AaBhtU5o1pCs0eQojovQcRkaZG/H3vbBb/Xb
 Upb13cnfDXhrD65X/3FcShKTYqFWfp2TG9ANI3LoNgr1Mw7eQ0R5HsfZe/TpsPcwLWT7
 SCvdnNNLTb1U3Xp4+zuNBRgCR/NYRYeNrJCTatzRjHIMwh4SssqMdTjFQ5BvZOHVPWBR
 eTzJuNIw/C3mc0BflxJbewl7cN1omwUy79s6/0LE9VdfAa8quFtTVQfC+TkrZsR3Etuw WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 398s5p8bgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:43:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15IDfRjS150630;
        Fri, 18 Jun 2021 13:43:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 396wawrd6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:43:06 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15IDfufK151268;
        Fri, 18 Jun 2021 13:43:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 396wawrd66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:43:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15IDh4YI016228;
        Fri, 18 Jun 2021 13:43:04 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 06:43:04 -0700
Date:   Fri, 18 Jun 2021 16:42:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: elx: libefc: signedness bug in efc_d_send_prli_rsp()
Message-ID: <YMyi4LNaVmD7kQEN@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: RVkbTigf1Iz2U5rMFgJnmKgyofI46Nku
X-Proofpoint-ORIG-GUID: RVkbTigf1Iz2U5rMFgJnmKgyofI46Nku
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "rc" variable needs to be signed for the error handling to work.
It holds either a negative error code, EFC_SCSI_CALL_COMPLETE (0),
or EFC_SCSI_CALL_ASYNC (1).

Fixes: 202bfdffae27 ("scsi: elx: libefc: FC node ELS and state handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/elx/libefc/efc_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
index 31a688bce6e9..725ca2a23fb2 100644
--- a/drivers/scsi/elx/libefc/efc_device.c
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -15,7 +15,7 @@
 void
 efc_d_send_prli_rsp(struct efc_node *node, u16 ox_id)
 {
-	u32 rc = EFC_SCSI_CALL_COMPLETE;
+	int rc = EFC_SCSI_CALL_COMPLETE;
 	struct efc *efc = node->efc;
 
 	node->ls_acc_oxid = ox_id;
-- 
2.30.2

