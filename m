Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6DEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 18:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381703AbiBHSzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 13:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiBHSzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 13:55:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C28DC0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 10:55:11 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218I3j6n020210;
        Tue, 8 Feb 2022 18:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=g9RiWf/rfanivJrIpTnOi5h/dpWvEm1IPTLjegvp1tk=;
 b=K6zain77EmPzqEZgf0459glmKAui1jTH53HhQSynOayL/ib+GK4IMAyBmc9vFFkEm4mi
 NX9wE7f0YhgZSmRl+77h6He32LkShzefhzzdm4bEw4Prk1GGqO3LWPMuTonnH0OxGLsh
 Y15aHY0Ohp1L4J7LCHCg3AUhFCOhxVP8KXJo2CtuFPP2EJF8eCYNvE9BB10qfd+Kkt4F
 jfgT+C6iMDZLOKZAlLqvCflMogJHE9IyWY7eAeH5wKvr3HalK1q6sucpQXG883kote6D
 eXFgaYQbw228KbZVce3QZ3VdUw5CJY9M02dODi4Vre8SlEF8SQh2jf945tggGELDjJNa 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e366wuss2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 18:54:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218Iq65Z137558;
        Tue, 8 Feb 2022 18:54:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3030.oracle.com with ESMTP id 3e1f9fvayk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 18:54:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6O11c+KWWv7o/hJIwA/nDqMz20ML2HVHiS5U4OE8fzzFO8SZD43NPNSFMh1xSrT7TwPvZIZ88ECeCMM0f6TC289BO9OUGBqe2f9eRXa+N8ayl4MxgQYbKYn4r8BCF+63CiNpvfj6vdxc+spz9F5YehYTra2QjFHsRpl1AwFnD8p+RCHI0KFhl/3bNVHdj9cpdBQ+ScH7InNL909yhz+Rin0Z3Jhs2LxQ2aqvQa4LsMM6QjjDSw1Zh0D9hZ0TYGEne+V51VW6r37CbMJB29miY6vatN70LUIUusdVj0gH0WN+71OkyKjxO8hMc+RVyq7jET4SM3ui5MsZb66aN33XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9RiWf/rfanivJrIpTnOi5h/dpWvEm1IPTLjegvp1tk=;
 b=iOd+057+9QOnexl91E33G5UVRZUX+lHR0Da9I0YFNI+Dj+P5AL+/7mXJfLhudbJnyIQMBM4+l9JYRyXuXejGrU+Mi+9Xm5t1OvPCE3g3KAmGkr5m0WVZNmiMdUadbFSk8CaPD3PaWGy/et0WsEX5pvFmV4Y7yirKNozjpJaCkR9pU++r+Tiy3rzZ+myYzpIAY6XZ2RGpSgxaKF5ZXSX/09zQ9QNGBKzaxQoIdS3C6TzebYyWXZJBvm9tt0OPzOHcH0g3xyo2oi2COO77dDYC74kVApefhArSUV010LQkqH6+7GAaTVE3Ov5zwuVquhPsP7g0xeWz7NCaSAHYEO0bxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9RiWf/rfanivJrIpTnOi5h/dpWvEm1IPTLjegvp1tk=;
 b=j92HsqsFpoVtHv5SJmSn/unMDt/Kv94ZvVQuCmwJVUsnx4ewMwTKMzrbhFDWcx+kLtLF2nZg5ymHQVrMC5FKs9m1TRQ6XDELeNeKt5Utjemdep4ceQqHCqmwjF6qw6vxHtpNb7WUdJ7uxHvqVl55v5N+z2qr0X2m6xGqUZR5yJg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3116.namprd10.prod.outlook.com (2603:10b6:5:1ab::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Tue, 8 Feb 2022 18:54:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5%5]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 18:54:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, baijiaju1990@gmail.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 1/1] scsi: qedi: Fix ABBA deadlock in qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp()
Date:   Tue,  8 Feb 2022 12:54:48 -0600
Message-Id: <20220208185448.6206-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0123.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 650241b2-6386-4eb6-c2de-08d9eb347f05
X-MS-TrafficTypeDiagnostic: DM6PR10MB3116:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3116550D2620B5845177C7C4F12D9@DM6PR10MB3116.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O28Tp6Zmdfl8XSWDMFA6TuAEiRsnqBM2wCjCdPL45n76fwFLtQONN5dbFMoAolswO/JwNW+In+wwH5Uq1z3u9PaSKxqzZbh5Ym+bFkbq3zGJ34XFdHxgKeVBwBODxiyUL+y/YCe9oYSlgy7SPyzkw7L11q366vtFSGVfWEjFkm2VkvuzXDbjWTwptvjYZNcHmSgsXfq3ktdGLamTck9sEnNKfLwI1YJTbMvMLv1Z6t0otp4SslZXU99468ZO++CxMDw0roZyIXjAgKBslunxcG4Z5xwlyToc4aNt9FlqkUK0JXsYmXTd5JBeR0SFAIiC2vqG9zCma+2Yw9UI2H8ZRFetPvTYUvq8r0ut8EbDjCzpDktD1X61/wfHMatVrxAnjnyCKZNEvwTLXpxw6/zFnSOaGLvvpu4pwVRs260yRKsBbQwH4SskS9KZSB2TEHiEjK28bipwOL3uMeGa3Dtcz5RD8wUxx2pRIRJZbx+Y43ONi5FHg8rg+4819ZXZjHdNnfUOvmKVI4JNYrMhktwIbTs3W2RdCW64/8zBg5rQ7xO2mkfPIBNRnO8Q1NSMeREmZa3akzRRvYmfld2qWVgyTaKRtZ1XwASHrwyp2akcOjPvD1wdDX1XhFwYB5453GFCgZGa09M2yUSlEUeHSRO6nT2LeFh4qDBKKwLnEFLIOCQnSP6pXbbwawf08LKQKctPg5XUAeWsV505G+WG7dTyiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(54906003)(6506007)(6512007)(6666004)(508600001)(52116002)(86362001)(4326008)(66946007)(6486002)(8936002)(66556008)(8676002)(66476007)(2906002)(1076003)(186003)(2616005)(38100700002)(26005)(38350700002)(5660300002)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nzT6GXxu/Jzv5nqF4BcH1OCKjzmwVq1Kxpg2OJoq9pBEoqgy7du9wCXphxLP?=
 =?us-ascii?Q?h+R5ooKb4Ya6SnbM/esEMQD99m/3TSQBylsfkg8Jsyi+NskuUFvDLgfxjfne?=
 =?us-ascii?Q?FcLi3HB4anmn8TdJiXLaQU5plp3nGFJfS+50/J8NYiCBpL9LSB1MMLc/qQkj?=
 =?us-ascii?Q?9h52/FHrKGCgID9g0frqDRxVnpu0GJBmt2v6si8TxOYPKaJwMiB3OCjSwCAp?=
 =?us-ascii?Q?2jqsTYmvZfoery/TDZ/TCvxxHPu9T4NJAsuBLtKZGAiY8F44ei/g6N0TfzGb?=
 =?us-ascii?Q?ymx9zU5elgv4vbRvXAOY+LRr+5hgifwx5/1SUeg0nRS8alzZltoYQVvpAAPU?=
 =?us-ascii?Q?81kpMVy6/EN66sQLtiNn8AjMnPuHEgANjMpqa6I3tygW0FUuF1/Rha5ch8W3?=
 =?us-ascii?Q?sdK0WmLDZYBOH2FE3q9cS1wmMwy6qiqfA16VNaZT3djzhHDn9SWSo66PgEoq?=
 =?us-ascii?Q?SrEeQJ9JB3kmSluAgd9fmUnroJ0rYElthhEaeu+IVUd62dkYe5+u6uCOP64O?=
 =?us-ascii?Q?aCs+qEZVikcvlVW/yLV+hUlz+wdWHTSmqjGj0sZ7NCqpPuQWm/alQDX0mw/e?=
 =?us-ascii?Q?Fq4R3MYXZqcB8VHe/Lk4S4IyIDTsvMhnZKgRKnKoWiqNhRcBs8sLV8ECb+Fh?=
 =?us-ascii?Q?PJux43IvHNwA0AVBP9usQUa9pGLn+eBBjn60TiA3SoWua21vsbHKGAajuf1o?=
 =?us-ascii?Q?EBtFZ8o34zLgdN0I8tPD+atTePgSnUTiKH0oruwuhTwbTf86mNgOLgxZfNME?=
 =?us-ascii?Q?T1wybdD1WXCCI9Htkzi3xL8E0sG0598nGdOLgbMrtUdxd0UXnkL9IPaM1XBr?=
 =?us-ascii?Q?a2GotqS5SUocwbbVgkTUd15YcsMrB/xQ8hOcFIT4eNIK3k32DNc/5squ+OMP?=
 =?us-ascii?Q?E7xuSVnlje0VkYTJ7ISEUqxVmSFkSCWgBwzd+SzBR5fT7h5s5Fickiy5bcFK?=
 =?us-ascii?Q?f8cSgC/ajhvmY9ag0WBRXIw8XWzz53c0ALMbaiP89fzOTTVINQ0KZxbLhrl6?=
 =?us-ascii?Q?hX8tVNa3Tn8WaFbiANUoiypwp+pPapsuRdQiyXZtQoxa9T6JErXptLwQJS+i?=
 =?us-ascii?Q?yx7esvMTjj9XqI89V/k8rDvwr/cd8HEK5G/2g+xABjRHWYvWQXmL9BEeNc9s?=
 =?us-ascii?Q?iyY31Db2/k26NKei0/VM47AB8ydxAWHC4YoNnJFCAiq2nhz4iMNWOSLMLJug?=
 =?us-ascii?Q?TJ/9rGrC1Wug1p9Pr5OhlQuyI8FrWEc73h1kYcAKj1rKs/3iEJNQeqD0sdwk?=
 =?us-ascii?Q?1EJSqwlApOnwZV0CQFdl1bq9TA5cWOSUOdALqfzCxKIEsrjZzeMvMeRBGaQ1?=
 =?us-ascii?Q?IUzsi0r0obe70jKWlGTDMUgNCcVeubycdemd/1asf5i6wmCXDYMiqONJZLD1?=
 =?us-ascii?Q?+DymDgJhZzNuYpdXUBgaVam1Td1nrqRWeJMNKrw1l6VYZPWC0BN58HYCqRro?=
 =?us-ascii?Q?PakjjyNm2IXaCNGD1z7sdE3WjyoN7MqBwLuXUPYutiVq0jPnNb97C08od2LP?=
 =?us-ascii?Q?+9LLB7iECqLFk0xtoF9frs9LINYTq7IgtnxU2Zh+yDbf0krflkTwX7js8x21?=
 =?us-ascii?Q?QQkTyPwllz2jf1fU+6jzJDNHwa5MeWutaCqrhXoMDBwwRLAc7NH48o2LDHC9?=
 =?us-ascii?Q?kEgS7d7hjOAHvaIi7hUvZxAakw1zn0YcnvsfdiRJ7MJMAUe6ER3eGSJnQLl8?=
 =?us-ascii?Q?ceRB0w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 650241b2-6386-4eb6-c2de-08d9eb347f05
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 18:54:55.3265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1YTxEzeRLLWYs+E1W7g14AqjeQ+yWnYPm+fR5iWHwE232/EiU3l4o72BRB0P9AWXa7rDa92Tog5rawVFVA6qaiGemlc0Mz1/JfsWQlxCyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3116
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080111
X-Proofpoint-GUID: FgQ5yUyc0c5MVvLJJiTRUUOHH7NOnmmV
X-Proofpoint-ORIG-GUID: FgQ5yUyc0c5MVvLJJiTRUUOHH7NOnmmV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a deadlock added with:
commit b40f3894e39e ("scsi: qedi: Complete TMF works before disconnect")

Bug description from Jia-Ju Bai <baijiaju1990@gmail.com>

qedi_process_tmf_resp()
  spin_lock(&session->back_lock); --> Line 201 (Lock A)
  spin_lock(&qedi_conn->tmf_work_lock); --> Line 230 (Lock B)

qedi_process_cmd_cleanup_resp()
  spin_lock_bh(&qedi_conn->tmf_work_lock); --> Line 752 (Lock B)
  spin_lock_bh(&conn->session->back_lock); --> Line 784 (Lock A)

When qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp() are
concurrently executed, the deadlock can occur.

This patch fixes the deadlock by not holding the tmf_work_lock in
qedi_process_cmd_cleanup_resp while holding the back_lock. The
tmf_work_lock is only needed while we remove the tmf_work from the
work_list.

Fixes: b40f3894e39e ("scsi: qedi: Complete TMF works before disconnect")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 5916ed7662d5..4eb89aa4a39d 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -771,11 +771,10 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			qedi_cmd->list_tmf_work = NULL;
 		}
 	}
+	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
-	if (!found) {
-		spin_unlock_bh(&qedi_conn->tmf_work_lock);
+	if (!found)
 		goto check_cleanup_reqs;
-	}
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
 		  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
@@ -806,7 +805,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	qedi_cmd->state = CLEANUP_RECV;
 unlock:
 	spin_unlock_bh(&conn->session->back_lock);
-	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 	wake_up_interruptible(&qedi_conn->wait_queue);
 	return;
 
-- 
2.25.1

