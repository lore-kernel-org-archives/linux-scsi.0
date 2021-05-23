Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A0AC47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D696117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhEWSAM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 14:00:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhEWR7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvhmV164792;
        Sun, 23 May 2021 17:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=XHUZVJZLbKxexs2JQozxMaBq5DpLnfmYpG19Op+JHuI=;
 b=p7J/whXtZBRcwjed3f/xGJsRi7UV/yGl4ngELOdcVSbrocq2W6IXC3c6NMTFeZE6F/Nl
 B5drSuA65t+CwiSVLh9ism//+OgDApaSnBt136/YrEan2D0O16O8WsZSgghSCuj1QRE0
 HR9Q+EGCm9TCoKzEzQ7SCqPnX4vk0zSI2wn2vSSNE/hSFVDX/yMZm2+84pieePIUoIIw
 /KnPgBkjDYVagfoJDcgMbkbTVZm4Lt5BpdYNo23BMNgd1sDFDg3fLAwDEGLwkWuyyMap
 CsGjwYEc2vttzD74t9HWeIl6+VICwyoAQh1CAVQByzb4b0sSWWNV00KFYmxNnu4rpvtV Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfc9jav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHsrMg188648;
        Sun, 23 May 2021 17:58:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 38pq2snq5p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNP5IZLYC9yfp3F48CN3VwFcZKDHfa0sXptiNo1I2ntSG6HftfT3wFFs0NytygVOHzziapgFXUABTmCmo5IfWJwXltM8VWTLCDxhBMUJ/xCqdxj0Xc/+mPQr1bFduLURHb7FmCv9JYnWOZBAH2tePsb45bp8g8nmZiYOv5OLPWw0ubJTEJf2Upeqg3HZhYuGmN1fflbbNKsiODYJMRq114JSGzaTY+F5Hc9SkARTiUuoNJQ0BIpctdp1CJK0ij96L7qJGudxo/nCRTb3ZVa3LcyyGIucQv0lOAFgXvXX5FMN/Izapy4jGkxE6XkQ9Y6g8zLrFfbTbPs3U058n7c7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHUZVJZLbKxexs2JQozxMaBq5DpLnfmYpG19Op+JHuI=;
 b=kNYumjDFdRpYysdtE5K92puTs6mK60unFDE4sRqOEBqq5GOWfkWYWtXCcGV4D4GczSBiayAstaacaJ+l3c42apMWSyPMxuI5Rm/w9zucNPz1i4kOFf3yCOxTjDJZJFI+iFt1cJtlzxAgwq6eulfh9bCTAkLkAbbViuK0yLNChuyM9V1eI8VEx1NHeFXTRYtaZzaNrUApC+3N4VYBWyJnUDlLr1ku4miM9UkUVqNacQvxX6IMX3f1OGdtPZojqex0tZwBAO9/Fx8jdbsYJYXXIQL1Hn0X82CvEN9SwBxAkf1SgqoadofhJsx/AneOxOEOSLv+6AoplYty+UJc//wikQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHUZVJZLbKxexs2JQozxMaBq5DpLnfmYpG19Op+JHuI=;
 b=iGWAFR92z2KjHf4804ArGUW3rKCGXPb/61o2Wftfkip2y1A69DjCocjKsMzo4GcXLrhxIFwFWHr6AzWPucBurCNFo2ScNuH6Q/gQSOfIAGalTvAO2bUDygC6zHfqM2T0brSTm187Un4Kt3KjMEGTNr8vuH4aucOY+639OE2mzH0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:18 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 27/28] scsi: qedi: Complete TMF works before disconnect
Date:   Sun, 23 May 2021 12:57:38 -0500
Message-Id: <20210523175739.360324-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae63b70d-23b3-4217-3aec-08d91e14588d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32392FCBD95CDBC9716DF181F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIr1mKik+5EiS/atjG2J22ylr92kKRQyB+Cv8b/r5DzBbJSKFVx07DIAzLmcPCdhXd2WTUL1fcC6zECZce4uwQkB4VKSgryjI5CkS87JO59RBmKLle5Oyjh/5aBtc8UOEqqDzwlYX8x5RjXZnt+Lrb0R6FKg2FfjCycX78sP0ziTQ2EkHyroW/Q5HKj6FcYQZAG/2wznzPWjL/MVC/vaSWJ1dDn/Cff2B6XJPiEsegTAoi0n7k1nPkqKXqVk7MpqeLeGKRw3ti/Y0aEzxKDa6dw4ZjYrBFHuGJ5UxI55F2VPULNDtVftDPWAROHCmYUdujhXl2iNK8Zs061HKvtqk1p8KhMfhO4fYrRroS421oCojUwYmV3CanC7bkDHiPr6I/TKzQshjcn3dJcUEpjdJskzbMJoMS5uuq0+6kGl1cHvfWJ6zXbPK/oZKOl+XSH6XlD/Bd6x7o437/4xt0Hh2b6p/B+dT9evcg8kc6ud2nnHN1sFJG19exeHGFI6wj30fjZgB4Heg9K5gfaqHO3LKbKGhRnuDwyyxA49iRcbcz5+TFRnlmiWJi8nKbMeZGKCGFkf9XdEBo+W93ruP5yTacQDPE49n9TsrCpZkA4woj3v6ToV7+M+8Bz3gDkgJ1zsozri2WM2ZexosYAubw5wa725mM0f5XAWZVrU2Sdnldy1NTiQiDAY8vtu5qq9Ws9K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uAnQtvPtUuhBS3HKUw5TMaveatUhddje8pr/Y55VR0GgwhbYBPls2ovUABFQ?=
 =?us-ascii?Q?l4znB0iZSfqo2Kksx0GuEt99QMKzhHsP67Pzosqf0+J5scileegKPRm852Zz?=
 =?us-ascii?Q?9hPMbQAztViHYUCf0ArmhsneYNuwb3OLVisKtu/xarcf4P9LGR/EOkK72iX8?=
 =?us-ascii?Q?kGUsoxKs0QferaXwBez+SgUZXh73S+r828zL9gczzMX92RVRAMiSed1ia1+y?=
 =?us-ascii?Q?OxWc8MgCOhS3ZM32pbjhsxoh5ykIPzHzqoDIZu1hoqes6L11dJI9ocDxrFGv?=
 =?us-ascii?Q?yAO7bYNsPItgqfZZa/hjqFtA11xnYhpbyLIn84PEoer+72Bj+gQr9QYbV0Qh?=
 =?us-ascii?Q?OO9i1wYxKu/xV7MwOTKCuVLIX8RemE5qV6rbbpxu6DesNH9jJk7WnKZjOVOQ?=
 =?us-ascii?Q?ksr6lIkgH+kqsEHgd62VPlL6JXZ3BCnYMKMwDppZEffDveHGVWSQIF5hlDf3?=
 =?us-ascii?Q?cm/3UREZTG55H4mvUZL8Z5a/7mCnsiqKkTOLFKSsb/K9KIQLvJcT7Qfwozr8?=
 =?us-ascii?Q?VGHNhm7QqgqiOK2TXla6eud9OA62Jrrfl3MkMRyAI5L0Q7gEdlqWRzd23fP/?=
 =?us-ascii?Q?xsGQPQ13QnHn0XuFu99BFUP1S9YjlsmIvzLopGfY8EHEMqMpd1IeTfR2oXDt?=
 =?us-ascii?Q?BQJyuoc2rLN7itFGHQTsBnyivvmElbfzN5WPysCloD8ESlAQ6qvHJtBj/iaz?=
 =?us-ascii?Q?gYVWdUXDbk8JZz68Zmqp6vlvkb52OtS93GLjenVdCn5nzodETpEeddXEBvYI?=
 =?us-ascii?Q?hVJ2TPU1FumjU5sFQw/45UYM3POowuZtgbJTjzwRFyHcHxWw0g2mUGd4w/Bq?=
 =?us-ascii?Q?nSJYTygOklD5VxhMZmco60PCk4MplGMQWQbx0Mf/idjvNN5GYlk/e61Spfr1?=
 =?us-ascii?Q?8vH3XwxQheUWjJQtbY5wjMOqwKTtfbv6MgvNBbHvEIzi84dPlDfg4gI57pAQ?=
 =?us-ascii?Q?fhmjJ0mK5ERNWqgaP0eIV3Oj7ayi4TftnUSO0kBeH4AZjXL5Z09aeThPT15j?=
 =?us-ascii?Q?QAdUks3tKeGn6FHTpp9+3sKgPq3Z/mt1VfIfMov07KUXyCva0iWkpjKu6qzM?=
 =?us-ascii?Q?UTPVpZ4aloBzloh+85TQv41zZFt9O/tghUhhTx0zARRXU9xrttKPKSOk96Q/?=
 =?us-ascii?Q?q2Fy4jOWga7e2nc7L0GA46UYyuPRzEpgA0cQC+Y1txOwDsT/kaQjaauwDSSc?=
 =?us-ascii?Q?iU/aIxlLVjsur1wLrS0t2cIsp7V9u3+kIvOqAihlRpgpkshzmx5NDcGbk3YS?=
 =?us-ascii?Q?jq7duy86W+V6s/Cu5MemOUeNUQE6NXECzCNFSR/T3wP8KnkH/xeZsha6kGrN?=
 =?us-ascii?Q?POfoYZ3lIHTwpvENMQj7lk8S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae63b70d-23b3-4217-3aec-08d91e14588d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:18.4665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1bvola1rsfwI7d1DwE/ENkO5XljNmXcN9O59meShj7D6IfVe2D5oLJgN3G3p9s4ug6+MDIvQ1AxiMsJYy2FXUik1FSymq9P4uf6m9LNS8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: CGJtIvrXiZ_qWeGl2Lw7qGfUgLg5ozqH
X-Proofpoint-GUID: CGJtIvrXiZ_qWeGl2Lw7qGfUgLg5ozqH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
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
 drivers/scsi/qedi/qedi_fw.c    | 42 ++++++++++++++++++++++------------
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++++------
 drivers/scsi/qedi/qedi_iscsi.h |  4 ++--
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 4ee1ce1dcdef..3de1422ce80b 100644
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
@@ -1429,10 +1439,7 @@ static void qedi_abort_work(struct work_struct *work)
 
 send_tmf:
 	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
-
-clear_cleanup:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	goto clear_cleanup;
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
@@ -1451,7 +1458,10 @@ static void qedi_abort_work(struct work_struct *work)
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+clear_cleanup:
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask,
@@ -1546,6 +1556,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
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
index ddb47784eb4a..bf581ecea897 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -603,7 +603,11 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
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
@@ -1019,7 +1023,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	int ret = 0;
 	int wait_delay;
 	int abrt_conn = 0;
-	int count = 10;
 
 	wait_delay = 60 * HZ + DEF_MAX_RT_TIME;
 	qedi_ep = ep->dd_data;
@@ -1035,13 +1038,19 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
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

