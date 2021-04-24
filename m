Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D81C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D940961009
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbhDXWHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbhDXWHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6XII151687;
        Sat, 24 Apr 2021 22:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=I453EkNqOXHHxU9rVpcwy89WAUEWNMirzkmjh3pEDQQ=;
 b=yXCrQYnW3xvbUeE7iYv9vUletAfQdSbVA4fDjjGmiyUrzrzVL1vSlc4TU/oB3uJmntbQ
 36rV3P5C30EyHwicar7ax/bJqIuGbGJqN/Za6aWbHhWImxv/H8lYoY2yjck+4elEUYQf
 CYiQkH+arPfHD8Z6HctjdAKF3OiHoJSIyErqsS6zZksus0dEsmFI8JZYVmplSiv08atW
 sfaa82J2YQvyNM43nO2aRN+NHHm7xyNHn+0OwYUolT3HnBrR/LcKvgYyG8aZU+khS/yY
 puZrfm1gQG0HiKDzlbLpVlw2dKiHZrGeeIn2yYlsWaGdsspaBCQcx7AU8xsHO8oG7wHY mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 384ars0t15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM655J182233;
        Sat, 24 Apr 2021 22:06:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3849cakfvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRo2El0c9L/SpdW7QoZf6jILsMKxVz+0C5n4F2kkVdWYAowCjMWTe6s2gAWi40AmJVRHvQS0FwpXV7YkdmWwaTHE74X7k5yIkj/dNkbzm93FJcn6Oh0CLAUIwcDCPdoswk4X//72BZtU9ygpcmsl72DN67BnbjwPqHV1XqXy+QZqW+Bo0w4Y3gBryh20QiphY8uDRNtxZT95lTTQ6zNxulCcg7JtyHiP4Fp1DrMi+BVmHegxD0KYISCcUZl2Yv80WICUsPlMdU2Y3h8/eaaxYkQTgyiNjNYoY2OLqJmzxuUmVMIHGMa28KnqzqRwljpu5xNWYn5GAVGtNSZZb9vLew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I453EkNqOXHHxU9rVpcwy89WAUEWNMirzkmjh3pEDQQ=;
 b=LwGiaptu4frotK+PUNhUrNhbxF/7mb3npW9FTE7bPMaGFyWKQTOv5hkdQb95kQjj6P/Tw2nC8lHOVUE0G9GqGD3rS5a6xQ8hjErdH6r5e/6/aabu3nk4JW187BWY2Hnxib2LIK02Ngy+nXq4dsZlBOA1stLDoVfVpbX3pI01G3cB+9TJdgsj7acr8EyGcFz5OlQFlwpAElQLkSQOPinKb3wRN69BRQbNAZBVosVqTLlZDouZp6kRuV0yOc0+JOAH/JcC2Os0LwRRduG0AxsQ3uKgaXvoJNA3iUNOC+JSCMQtdXARoY1swHG30fu8M6uLnIqhMYzWlyVvTwxKbvrSBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I453EkNqOXHHxU9rVpcwy89WAUEWNMirzkmjh3pEDQQ=;
 b=ektM+9mYRTL3AD52QoEYShsPE00ZEmWKqGPFyZT9B/a2BK1lo0CC6W8s2W0tsXp4EWIyQwnsrlR5ZaAyzP8WDRUevASrrskcmZp8nMfQu54mZv+BCjapUQEj1HuDMhkv25Ob4o6qSsb/jjfVv2aexYc2WzhkAAu1dMzHhRUc3ss=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4493.namprd10.prod.outlook.com (2603:10b6:a03:2dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sat, 24 Apr
 2021 22:06:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 16/17] scsi: qedi: complete TMF works before disconnect
Date:   Sat, 24 Apr 2021 17:06:02 -0500
Message-Id: <20210424220603.123703-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21d743fa-60f0-42cb-f375-08d9076d3686
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4493E9EB9E893EEF3BE295A5F1449@SJ0PR10MB4493.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJMaM7khBBNmq53On7y8YYSgvXPZePoLVGXfHqaCRiA/7+GQO7xpYpPoaMq5gEkSMbv26bxtCn6wd5qlA9HR4jgG7Wz4YVfeC+KnpnaeXe10NC7+LIO/qxG6NuKvEF0jANtd0wb8AV9g9tcKCIO7HGAzWO1h9DvZTEdY9iaWLZXWS7lMJ980olGq+a+oOmqQ81GaC+y6UXWSb+ZXbaPEfSxtA+Orh5ad/t1NIBIK/EP6hMxzxsv4ihrI9ZZb94IyMVRCja4OqtAEjrz8Vt1gmFnw1EUo9MUwoXtGKV9/SwgmPN45jClsxO70kojfVTUUkXHTAiSO/HMri2iWDhtuMfzQyJ5cf878iuA2U7GkIdeP6tfrNURcMyjx1dfrGIk3G1U6an8pNDDp7fgEReO3jQ8UMpB+9co+SnDnGIxtVuAgekcO01wu6rQyO5e4rHdpcRgcXSX51HeTErcLVTNIrta7X0G/ZuTCe6cA3588mp2VIDj1S7rqwfiHbo+s6M9kRfQVkx216X8aW+WHESV+A7Kt1KvFYlMqHa7q7UudsCGvpYSZypRCyU68NHSKwSpPlIW3a/pZ2XSHzi5jZiFoeGVfgMXl3y74f1+HaZKiG0F4h9aqNl06c0azSbTMVivTcTcr7dPX+O85nnhJPmXjUejbvrx5ZpAZNXozM/fbK4DvVstossxiJGemxUfNE7/e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(316002)(8676002)(16526019)(66556008)(66946007)(5660300002)(66476007)(186003)(26005)(36756003)(8936002)(52116002)(1076003)(38100700002)(956004)(2616005)(83380400001)(107886003)(2906002)(6666004)(6506007)(6486002)(6512007)(478600001)(4326008)(86362001)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zMBUmgHUYATLAQOFrXrUC9ElIyFXogqe1lugcsPLxxuYg//zcUCQVbtQ9xH9?=
 =?us-ascii?Q?NX82BvfsPsroCTdT4tDk0SFjyLgy7N8PcuFuZluXJ7ihjEnYjCzsUCxIcZdb?=
 =?us-ascii?Q?7PrqPfc1QSRHnFn9ZmuUAEFl60BDp0zaxaulkHjoEJuLU+qNNVQeYl4VE/fs?=
 =?us-ascii?Q?0ZIDeTO1fRMWO+rHF99992+fybQKDGnnTIwoeFJfQn+rwZ4+I+IuamkiEsqx?=
 =?us-ascii?Q?AYjcA4aZ6O5SWFoMHnLRMImIqLGx5uvyPvauzzzuMlhfJbmDrB0Tfxji0Kf7?=
 =?us-ascii?Q?8GsO2C3KUD8pjvYlfpHTkZmglpE9A9I9S0JR6Ao2p7VXCHX/46VaZd2EkZ8z?=
 =?us-ascii?Q?CoWxa1eGa9rOy0iuyjYAtpJ6txdf3ET5W7nulxdVwSglDvYrJaE0iNJHewIh?=
 =?us-ascii?Q?zYmFnBgWzSeBRkcMIqsA2Gu0zlZgevjM4Y/32Kp0BEqOlQ/82nzFvRJ6/OD1?=
 =?us-ascii?Q?lcs3aiHjIFiLyeQQs+2s6OmmjkoPR5pC71eAlZBrmF6UpyvrGTnDLKbVbmxa?=
 =?us-ascii?Q?vSKpGZ7H0IkTumtyNl50T8/TRGchYsPxdcfUGlNBQj9tbs5Nn8voN/TcSHUf?=
 =?us-ascii?Q?6EX1HDICPAaeSqPiCWXqUMvD2dWmhkFWBj8vTpLdK55AjIW4+RCPeVSIgD8v?=
 =?us-ascii?Q?2Li+X5fT4UF/LQfwFj5XmTgPyBo/MlTa3RA87bHSgV/ewlxix3hIqnvJquq9?=
 =?us-ascii?Q?Rw8QOOd5pWbnam+DHwSyKGXmuzVKu5u9B2XX2Rw1erUECJBtxDm17UnJMtWm?=
 =?us-ascii?Q?LpcY/x6xWzhMWtFcaPyzP9TMvJ6VQQjvbfCGIPX23X+mnIcExPljUK+Av0NK?=
 =?us-ascii?Q?/4w1P0oIvtg5RnGn5XZ9IkNCq7bZAtPgvOZMMu1DEa/G5RKh5e8UZUHBSvyt?=
 =?us-ascii?Q?bIuVlLr9AVQxUDYNQI7wG/UPZAaxhhes7vB7XTOq87D/tS8M/QgT29ExekAM?=
 =?us-ascii?Q?gmUwzlUcolK1szKks/ubvYloSB1AU4H1FCU9bzqmj9LhkQQ5n9i0g1q2g7yF?=
 =?us-ascii?Q?KJ7TcStnOxYmz9XAi0rE0PaVmB5RyLdIKLkBN1dPcw4u7R1LJdZv0HFAhjTY?=
 =?us-ascii?Q?BnAUNP1u6q2ZCZQIhKpegeUyAKHZ4pDDqr8ffN7qAZdZyy0VR62EoigVyjLk?=
 =?us-ascii?Q?FODrBmGJshz8b3D5ERX3ocr433xWfhWDFFOgbpDaTWnuU9Eq9rohrhKpMZh5?=
 =?us-ascii?Q?M8aMa0yjdD9KppGgiBQgIKyriQ/gN3oqcNwCM31cKo9aC2h3ErXFa1R/8js3?=
 =?us-ascii?Q?Cdw19hvOW7WNvb3MuPTGydyETUvyaszwiwx/Uf6ZZAxmA12Apl57hKYsX2LZ?=
 =?us-ascii?Q?RXLRUobB7mvVblDwtMK+yb2i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d743fa-60f0-42cb-f375-08d9076d3686
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:29.9947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bU6aUEd94keMJ16goocd4OIdg6DXNzJGApTpXt/vNuhw+9Wj8ZXXj0ipZ8/yfetDWdHxKDZcalkRaWhAru41v+rDYKkozJfbGW2I+SFXZDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4493
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: ufM1WZOTs_7VHRYuqGO7uKkZPQZzmWp6
X-Proofpoint-GUID: ufM1WZOTs_7VHRYuqGO7uKkZPQZzmWp6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to make sure that abort and reset completion work has completed
before ep_disconnect returns. After ep_disconnect we can't manipulate
cmds because libiscsi will call conn_stop and take onwership.

We are trying to make sure abort work and reset completion work has
completed before we do the cmd clean up in ep_disconnect. The problem is
that:

1. the work function sets the QEDI_CONN_FW_CLEANUP bit, so if the work was
still pending we would not see the bit set. We need to do this before the
work is queued.

2. If we had multiple works queued then we could break from the loop in
qedi_ep_disconnect early because when abort work 1 completes it could
clear QEDI_CONN_FW_CLEANUP. qedi_ep_disconnect could then see that before
work 2 has run.

3. A TMF reset completion work could run after ep_disconnect starts
cleaning up cmds via qedi_clearsq. ep_disconnect's call to qedi_clearsq
-> qedi_cleanup_all_io would might think it's done cleaning up cmds, but
the reset completion work could still be running. We then return from
ep_disconnect while still doing cleanup.

This replaces the bit with a counter to track the number of queued TMF
works, and adds a bool to prevent new works from starting from the
completion path once a ep_disconnect starts.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 46 +++++++++++++++++++++-------------
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++------
 drivers/scsi/qedi/qedi_iscsi.h |  4 +--
 3 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 0ce4bf0d16a8..03feabcefc7d 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -156,7 +156,6 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	struct iscsi_tm_rsp *resp_hdr_ptr;
 	int rval = 0;
 
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
@@ -169,7 +168,10 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 
 exit_tmf_resp:
 	kfree(resp_hdr_ptr);
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
@@ -225,16 +227,25 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
-	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
-	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
-	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
+	spin_lock(&qedi_conn->tmf_work_lock);
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		if (qedi_conn->ep_disconnect_starting) {
+			/* Session is down so ep_disconnect will clean up */
+			spin_unlock(&qedi_conn->tmf_work_lock);
+			goto unblock_sess;
+		}
+
+		qedi_conn->fw_cleanup_works++;
+		spin_unlock(&qedi_conn->tmf_work_lock);
+
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_resp_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
 		goto unblock_sess;
 	}
+	spin_unlock(&qedi_conn->tmf_work_lock);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
@@ -1359,7 +1370,6 @@ static void qedi_abort_work(struct work_struct *work)
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
 	spin_lock_bh(&conn->session->back_lock);
 	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
@@ -1425,11 +1435,7 @@ static void qedi_abort_work(struct work_struct *work)
 
 	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
-put_task:
-	iscsi_put_task(ctask);
-clear_cleanup:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	goto put_task;
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
@@ -1447,10 +1453,12 @@ static void qedi_abort_work(struct work_struct *work)
 		qedi_conn->active_cmd_count--;
 	}
 	spin_unlock(&qedi_conn->list_lock);
-
+put_task:
 	iscsi_put_task(ctask);
-
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+clear_cleanup:
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask,
@@ -1545,6 +1553,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
 	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
+		spin_lock(&qedi_conn->tmf_work_lock);
+		qedi_conn->fw_cleanup_works++;
+		spin_unlock(&qedi_conn->tmf_work_lock);
+
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
 		break;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6e4f7c427af1..25ff2bda077b 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -592,7 +592,11 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
 		goto start_err;
 	}
 
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works = 0;
+	qedi_conn->ep_disconnect_starting = false;
+	spin_unlock(&qedi_conn->tmf_work_lock);
+
 	qedi_conn->abrt_conn = 0;
 
 	rval = iscsi_conn_start(cls_conn);
@@ -1008,7 +1012,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	int ret = 0;
 	int wait_delay;
 	int abrt_conn = 0;
-	int count = 10;
 
 	wait_delay = 60 * HZ + DEF_MAX_RT_TIME;
 	qedi_ep = ep->dd_data;
@@ -1024,13 +1027,19 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		qedi_conn = qedi_ep->conn;
 		abrt_conn = qedi_conn->abrt_conn;
 
-		while (count--)	{
-			if (!test_bit(QEDI_CONN_FW_CLEANUP,
-				      &qedi_conn->flags)) {
-				break;
-			}
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "cid=0x%x qedi_ep=%p waiting for %d tmfs\n",
+			  qedi_ep->iscsi_cid, qedi_ep,
+			  qedi_conn->fw_cleanup_works);
+
+		spin_lock(&qedi_conn->tmf_work_lock);
+		qedi_conn->ep_disconnect_starting = true;
+		while (qedi_conn->fw_cleanup_works > 0) {
+			spin_unlock(&qedi_conn->tmf_work_lock);
 			msleep(1000);
+			spin_lock(&qedi_conn->tmf_work_lock);
 		}
+		spin_unlock(&qedi_conn->tmf_work_lock);
 
 		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
 			if (qedi_do_not_recover) {
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 68ef519f5480..758735209e15 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -169,8 +169,8 @@ struct qedi_conn {
 	struct list_head tmf_work_list;
 	wait_queue_head_t wait_queue;
 	spinlock_t tmf_work_lock;	/* tmf work lock */
-	unsigned long flags;
-#define QEDI_CONN_FW_CLEANUP	1
+	bool ep_disconnect_starting;
+	int fw_cleanup_works;
 };
 
 struct qedi_cmd {
-- 
2.25.1

