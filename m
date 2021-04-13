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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BC8C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF0B61242
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348758AbhDMXHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348752AbhDMXHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjwAg130273;
        Tue, 13 Apr 2021 23:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nC2/zbQ2sDMUrsZEo8x7eauZJWzwjzORF6HSCT3Dscc=;
 b=BafMFz76twZXNo+LYVF9BP7dHiWDTJI+N1j/qjVKEjr082Q/ZU97scPI5rrhChf9AlWo
 65YKQF1RBSE2372D6FcT+3rHD5nf8nk6auAcWZV4BidPCbtq7ws0L0F+A5Z3SbjzzgQM
 ilFiiwWnN2Iu+Hss7GnFAeN8rw/lEjGPRSR/6SgEOXjUrpVxkB34zls1aPYRlVqlLVlK
 vVlzFtKgpBW0bNrntADkxcbdC7yqDDsbaBbV/XZkNRMzNM5+rxOF8IxzTJu8MAJ1ETA4
 96akVTp51WmnKfrHqDWil3C1+sN0GWA0WekNtA9w7nJTm7Q55ysXrd3uA9Y6xoyOWPDw Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymgn97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMiLav064242;
        Tue, 13 Apr 2021 23:07:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 37unxxgjba-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWnE68wWt/jqQfF+UDT6u/45W+HDoQm1IKFxR5MDZQDlD/vzRdYZsSpfrg2AVVn5Q5g00UnFeMNCoqYl6VOTOcQaHMxMzLG/4wUvNbsqiUk6dD6js1IKDHrRgJLn3hknUfruEk4di9yi4wHXlvFrYFMCz+CqKC3pfiTOJUHVxW37Yfc72pP7RtgmUqGQ+NNh6ytGnJ/l3YppaLS4Q8mq1xU5krKLkIGm0VOJcjYT4oLdlKWge6I4+ynbXGsik43HCYD4V/lOHFn5MQiCaYEJ2nXgZ1Qp6S2q9UeUBiaEj4Lgq1VODxCyCK1dBK8Omf0L0yMf6rRp/ljcqFHsnVNmTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nC2/zbQ2sDMUrsZEo8x7eauZJWzwjzORF6HSCT3Dscc=;
 b=nG1SleuH6FCPoZGyrhEX2laMTJUVDgNA7/npgB9xDo3ivfGNy1lpfkFRbLl3ZoB+xs9CWpHDwsukahAXdhSYWjJmh3ETBy097syzQSKXjXpXIDsSdKg2R0xXAe4JaDsRufJrZsOtUIRvnMUc9TZJSi5Ey8ceeXSyBEHTN3/AjXN8GZ4fBHHoA5mI7qR5RL20RUwqETPpxm21VwU7Nin6LoOnwCmQJ48e1LUh6EMqU5m8mv6vJP5qf8aoljaYVQWz6BWVDVPGQCEQLlOeUnBpQJI2y4w0UeAFKx+4UU59SknARflg0Ck2gD83u5+wE6KxoekYPVjE5wDJKEypfGEYUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nC2/zbQ2sDMUrsZEo8x7eauZJWzwjzORF6HSCT3Dscc=;
 b=TjHO3/H3HeqSxt+bpiPI3VWWZMFhmDG8BJdPjAcaPD1i5DDuLEmllGC1HkRTQ934N+0NM848vnXCyNans105Rx0MucAHy2pOo6xwuJISCTVTTk3zQAQJwv5pnHX+VSFxcL7oiNOk8UGxEj7PYR6eGfTBRqBlDQa0POziHeJMFko=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3653.namprd10.prod.outlook.com (2603:10b6:a03:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 13 Apr
 2021 23:07:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/13] scsi: qedi: make sure tmf works are done before disconnect
Date:   Tue, 13 Apr 2021 18:06:47 -0500
Message-Id: <20210413230648.5593-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67224940-f587-41b6-7d44-08d8fed0dd5a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB36536402EAA573D7169D0C07F14F9@BYAPR10MB3653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXF5oqzUqPxKex2gs+NIsQfz1/ZqA93YeM4uIJHK/uf0gJf1QPLB66aX8SQGPtB8BntFNzucgQde8Rfj8efKOhMo+oy2ylt5FBXq0Z56x4PEuUQ7ka0QwD3/D5n0VS9VEP1XTZGDKnunn1ivRas68RPme9gk8zbLFgJI9ayPKBRTuVGoujb9ntrcNbgS/HfIFlf+kcEVAo4ydMOcFymXGOxn2ibLzYOETVP/7x/3oj+YvJBjNW4UvCet/MdZlQvOYd+oK/Z9sirMT2G/R7/X7xhsIWTgofWIaQ3o028G6D6yT3rGwinT4h95B2tS0dMvowuaHLK4wqkNiUuV5bdmDM4MFjOsYEo4pUAbV2HBZDi33UzOgu0kaj4of7KxlLEHmHSQT4RfPQNBSZmte3uVTmIEZeWpnl8+PhU/DExHNXE03kJ51Bjr/Cd1YTw5NdYED3GlZTt19tGXaqBuFnJh+VBJhKeq4rRafSs3Y9ikakCLR/8D3b8EpVk5mhrOULH49crxKPh6pKJKtzH+oygOa5Tp8VBQgQtpi1Rfj2IgAfw4/kCX2LaIPhC+zwTZAXz/sKGkZ7sHNOma4PqWmzHNKd/IfAX403iBchoC46TG6ybAGRAqYZRx1iGwFGpTAUZl9tcy1FFzqNFOA7EGpTI/l/dPNt5VFsK8UPJCM8avpi1tTjOlivxofcOPTMAcB/Q4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(136003)(396003)(83380400001)(16526019)(66556008)(186003)(26005)(6486002)(38100700002)(8936002)(36756003)(8676002)(316002)(38350700002)(66476007)(66946007)(4326008)(6512007)(5660300002)(478600001)(2616005)(1076003)(86362001)(956004)(52116002)(2906002)(6506007)(107886003)(69590400012)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NS2Te2HYFj5lR6E7HJIOfwNn8pARfrhjpNdTBjPoKrQ0x3cyMQo6MS+Y2+4p?=
 =?us-ascii?Q?//29u9efqMwp6jYpowYmUBad4sDkU0tZQa59AUAy4JIeA/HCvZYGCviguwmy?=
 =?us-ascii?Q?RZTRBTjjHza8NMXXnWS639J1HsMiQ9D1i8oWqr+GRuiKCzrQAR/cuKTVdMrr?=
 =?us-ascii?Q?+vGuFW3Rv2eWbrSLzKJSR/4T5q0gIvCX259pT/4z1POoY/BXOpX8FwxUHr/L?=
 =?us-ascii?Q?hG1O6FLfQAfWg6X2VmY7Gr04ms/fSk0qyMrfva2E7WDc3TWkOTDvbxM/HJGl?=
 =?us-ascii?Q?2kTMLHlJVWK5PbzxJzbi3S5lx0FJNekQ/IWjutbX1OYpRZvVqy7T7fH/FREf?=
 =?us-ascii?Q?OjhNtN+JRGuUNVhnh3ZV2gh85UrzP9CPKOdsiBVVmlg+YciRYBjn+a60L4Bc?=
 =?us-ascii?Q?twYmBm9HzCcTHzAWCbevwaJVMs7mk04FRSCFtc/RWhQuENxXY4FcqvAJEthP?=
 =?us-ascii?Q?F6GaH7rFswctd09AaLwyU9HC2bq9SkmqTD/6UbCOjv4ClgOzeGbT8k1uPBsA?=
 =?us-ascii?Q?wkZfRAZZ0IP2G1GEjtfcurXw1+y7Wuc81JqFWGQNuJUFps2O7XrdepRwgF2C?=
 =?us-ascii?Q?pg+5Xznov0VgTPl2NFcvUitiKrhyZiXelV/EKQ9TKCqiuhBX4j2dB4dWNVrb?=
 =?us-ascii?Q?Z0U6YU1sGkLy2E2yuSseDPcut/Cy/1WG58O2tqn5WecpXvqnk3gEmdMPHD4L?=
 =?us-ascii?Q?B1pbaf2vy/mhVn37sy4nJUBIm+N9Q0wn2vIHE1qzvM/CYgdtVSHiOyBG824d?=
 =?us-ascii?Q?Fr9jgSfbEz/NxYhmAaolqvJk7iAZgmKsaVG9+RcQ20zIJ/zJnS9HDqaDtnG5?=
 =?us-ascii?Q?u1jZtcVhietmGdr0oovhF0MllxIFxE4xQIAY5DGdFNhYWdTc7ww3Vl5q1mgI?=
 =?us-ascii?Q?3ff55gBRu+qfwBURrA2q4KH1yFaJLhLJ/Sou1q6UrqD1iwLhuXLRtUEkEOGU?=
 =?us-ascii?Q?WzF+rfvydlrVIgKpAEsIXPWOqbDgMfaxr9ufh26ewRx2rgzTb/DZdFP1vovv?=
 =?us-ascii?Q?m0AMFrxqpGlLFgGrrXI8ttScTjbJWs3FjPhwfbHj2RW8/JohNUXQA6g854+v?=
 =?us-ascii?Q?T1dPSNxYXIZgpHJn5HLJ0349Egg02s2TwkiGwQ++3NW0EnkxRSRvAL8d3Yyo?=
 =?us-ascii?Q?lHD58yDdji9rm05ynPFIXiHsVKDFKqyJkCMhfWJ5s1pI0BFIVriWVycmhhRw?=
 =?us-ascii?Q?V/oB+yjUDYFCc1PeV/GAS8L+i3Kg7ndvJFem/bfjJ5G/VdN0DTM5vBTQ1FDi?=
 =?us-ascii?Q?UI5SNSz5RRDfngcapsy0mW1RAsPVwoEzX/nXNleffeQUVmyei9sQsG91BYaK?=
 =?us-ascii?Q?S60bzGPrTOfZF6issSjW1s22?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67224940-f587-41b6-7d44-08d8fed0dd5a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:09.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDslOrShIQm8Qazr/VP6zNQhVv1AOWjYRPV6n/34UWTtCLP2zGcgN1Q5RTdh+Q/44PTPaAeBnZbVENvyoOJreFnmWErMMVKVTRSiceIGxYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3653
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
X-Proofpoint-GUID: Wlncgm_f4XmzMDPqM7UR2xWRGnMCyuqf
X-Proofpoint-ORIG-GUID: Wlncgm_f4XmzMDPqM7UR2xWRGnMCyuqf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to make sure that abort and reset completion work has completed
before ep_disconnect returns. After ep_disconnect we can't manipulate
cmds because libiscsi will call conn_stop and take onwership.

We are trying to make sure abort work and reset completion work has
completed before we do the cmd clean up in ep_disconnect. The problem is
that:

1. the work function sets the QEDI_CONN_FW_CLEANUP bit, so if the work
was still pending we would not see the bit set. We need to do this before
the work is queued.

2. If we had multiple works queued then we could break from the loop in
qedi_ep_disconnect early because when abort work 1 completes it could
clear QEDI_CONN_FW_CLEANUP. qedi_ep_disconnect could then see that before
work 2 has run.

3. A tmf reset completion work could run after ep_disconnect starts
cleaning up cmds via qedi_clearsq. ep_disconnect's call to qedi_clearsq
-> qedi_cleanup_all_io would might think it's done cleaning up cmds,
but the reset completion work could still be running. We then return
from ep_disconnect while still doing cleanup.

This replaces the bit with a counter and adds a bool to prevent new
works from starting from the completion path once a ep_disconnect starts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 46 +++++++++++++++++++++-------------
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++------
 drivers/scsi/qedi/qedi_iscsi.h |  4 +--
 3 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 475cb7823cf1..13dd06915d74 100644
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
@@ -1361,7 +1372,6 @@ static void qedi_abort_work(struct work_struct *work)
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
 	spin_lock_bh(&conn->session->back_lock);
 	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
@@ -1427,11 +1437,7 @@ static void qedi_abort_work(struct work_struct *work)
 
 	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
-put_task:
-	iscsi_put_task(ctask);
-clear_cleanup:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	goto put_task;
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
@@ -1449,10 +1455,12 @@ static void qedi_abort_work(struct work_struct *work)
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
@@ -1547,6 +1555,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
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
index 9a2d9a29fc01..17f1cbb376a4 100644
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
@@ -1009,7 +1013,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	int ret = 0;
 	int wait_delay;
 	int abrt_conn = 0;
-	int count = 10;
 
 	wait_delay = 60 * HZ + DEF_MAX_RT_TIME;
 	qedi_ep = ep->dd_data;
@@ -1027,13 +1030,19 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		iscsi_ep_prep_disconnect(conn);
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

