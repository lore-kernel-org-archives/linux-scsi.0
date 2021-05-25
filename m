Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A47C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F4DD6140E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhEYSUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbhEYSUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIG1qm122166;
        Tue, 25 May 2021 18:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=75cFGpSkp4kTZYhKnpulbxl+qmSwsO7M25rHfB3ci1I=;
 b=bn2CoLCgqqsGg2QpxA+GKze7xkk1+t0///UubtXlD4J26yecl1pyOz0QLRPWmSG8umTF
 PwEd5QR6r+d3PHzOSuOG0MJw922mcb+xohXfD7P5jCz6HO+di3J4DCMpzyfrbdnO6ocy
 YjQ3cojhkQJAQLOvm8hyJF6b5bdyZK2XDM33XPCNc09BMTUTuX7mQ73HpwjLhz09pVDM
 +Ge75EoS6YKzDUKiBbUcgwj0OfLYAIXrhVsPtyNaxbgSZTeQmJdrWLJffYbX+wKfaKWT
 XSEvh96h214dhPrRWUgm9MD2BQJldWFsvuKO8i6tEhQP8i6Lc9Pd+IoifyCaP89BqRY1 Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38q3q8xcw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFGMm104688;
        Tue, 25 May 2021 18:19:02 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by userp3030.oracle.com with ESMTP id 38pq2ufk67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX+wgMFL2DX0QJFskcFPTu9N6eypJMNr2ORPPNM4oXXaC5ELECvLYhZMw8pFA39bzoRlA9HQ2NdAsuICcxgcck9yZMQkq0sYbdnZ1coUNR11MJSTb3pCMUMISvvj8aXW3dFErZ+lOStoW3cj4JMfWboNh7zcLSe6kAnyXyOkWdOnTuHV3MbRD6BvQcvlBgSQVZyjVYhYGwRM8Agb2BJMoKfuTbmTfhXVG1Z8L6u9Oy8R0SnfIr97Gp1JWw70bqN4erp3Y42hp3ZwEeUhFHYfcM0Sp+PFugqLMemZ7StwSBrLvTr1JFa66c4zrwo/sBvaEyrxD5XAmZBxbwLkMXwsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75cFGpSkp4kTZYhKnpulbxl+qmSwsO7M25rHfB3ci1I=;
 b=Gn1H5rAcgpgO00I+cBlMEz3yvh0o3Gu1rfLvffmX4EeZmTi26MlrUQUzg13x1JNc5EvfiYWb4uOepO6JDYHZwe9QgPt6BdpC2qciEPTw9LCmEtrfAOfiJcixqiN+BT1qG2zOlQ9lchAa0+cNkrBkfJkP72hx7CMUrvvRygiBW+yoDy7/xDUhSja0qAZ6eCpnejN2XTO+grVF1Wipnr9R37JInye0WPM/QswNf5HG1niFcSzS0Eab3uouOA9uDpwwdygXfstL6zS1z6GRDbVZlVRGWhr6rlZ7naMI9ik1Oydc0nbim2h+Pwty2pEbwPeS0xQeA8JLJRBxbINgvvpskA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75cFGpSkp4kTZYhKnpulbxl+qmSwsO7M25rHfB3ci1I=;
 b=WEVgnSVCCTDN4ALeqCPKUm3grTKk2S6MyrJUfNt2B+KN+NVqnDUx/NRd3MWaCOgFEKNC4jO3wbudQmx8Gn5s+1DxAUqzZ9FPUusT42+gmeNB4lZNlxnVODEWHs+T7CCXBIGr3D20iEzRzCn+CXRRAkOknf+f5CWM3E5+uPU/+o0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 24/28] scsi: qedi: Fix TMF session block/unblock use
Date:   Tue, 25 May 2021 13:18:17 -0500
Message-Id: <20210525181821.7617-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f5f1c75-60bc-4b2c-949f-08d91fa98e8f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891B1957DAC23B08DC5E005F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: thnU2Py+oNhDUdGvQOgruuc56OQmKeRa5ow1eXZzNOGdOWuILhJ5YFsgXOsZgAOcALnWwAdAi5eG9UL75kqpUXDfZ9hrVX7Koy2qI9ydVEPCHqt0l0vE08uTmfJypEruKe5BGQVOPOpNE41oTG1ZTAR0R8etSzg+M8VdLFJ27AfwvkfIzmAg/ejqPr+vvyLKrsJtCVnGq1IVtpxyoZ7uEG0IJEH61SNlDoBQ0bUdPpRXtD8lqtGpLFDQ7rxbQjjmKpmIMdcbOlIdxdEE9qZ/F6LlF3cHaW1EPCKIKBKMWlUWZZCEAs9rTkgLMuptt0eSIx8hMRUnBuk8mQsyoHnuwDeQc8NoEL2HwY84DRgrft0ARocjTFNogHCpUCsO68EIdmHs0jsxGjDt/yB6wPy9ZKYc6TD4urkmmz4IVjtzLwKoNB5VDThMs9D/wxgKLGR+jBK11On79QN9sCSTF5VL06oHEdqGZR5cGShg2NKwndtmtCvC3myMPIdV+U25konj+N4QWOG0i5chIoRa8DHhJSA9onFzmR/pwntqW230Z2V/ibADV7Tg9LZXDetO8uoUWd5AP7ZeTdX8RJW1oKbiY8H5HCPG87nxe/lJ7mILgQBzZwRkZj5bKszroKvvKHY1OoxkuRkW8WF418TuAs08dec1sZE2Lc9We172excs1cpDn3CX8kjBuGUo1Cal6bra
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4JrsyVlTkzxPf7M1guA1ihDJDNF96oU+uMgZ7AiqeyLlLNZhtY8XXNJOjU7J?=
 =?us-ascii?Q?ydCmW5DFB4H16gqRUKNTp/kFVKvcpPVkJ/EjXNhZT1CFkkIweRFdc1M0DCtm?=
 =?us-ascii?Q?U1ymGayuH+ku5h22c3aPE49nk4cPcpZ8UKcMJBAsNEOjgO9CBJZJZs/fuJuD?=
 =?us-ascii?Q?fn57mlU1zBapoZbcVzD+TbN4dC91nm4wuBmPJ3oQGIcgek1qJNf+6Uq8O14D?=
 =?us-ascii?Q?ic+szSxA75SprG+7sl9khlyh6a9OAIXBqlIxHekc+ZhUOJnA/A0ZErToWmEM?=
 =?us-ascii?Q?8JUYyyDcrpKbcnbqfuq5KbAZTJEWbLbn0CHvaNCdwMihdQbZ1Bn1tBXor9B0?=
 =?us-ascii?Q?X1/maOweG24SvfHrTSEKq9lLVztkro/SnzzrxJMuUBajpRVuFmIl9Us0Zi6B?=
 =?us-ascii?Q?D6poXqmgeLbDXtNNJRoOKq9iAaxcL8TBeJTWkZoE6OZxMUb+EKzzQwMjTGeP?=
 =?us-ascii?Q?MaWLiAoAjifWHZaevR1cCYbYTWsQv/6PbFRUxkKLgx726HxGS7VCA5ceDuur?=
 =?us-ascii?Q?wXAdAMOJUgNjYEjpFunNEUyH4KkI5GcJBNGB+W5QQLxq782ASBc1YqBJEgTR?=
 =?us-ascii?Q?ken11z/zbPvjzKbW/E7ihRs1pbfbPEAw3xcvCgdiZ5GnSRHPuow8l9BjWdRu?=
 =?us-ascii?Q?/2dKDO4p9Q8vJJuj1t63eTeCMg8k9KZgWP9n/mpKdEdzze7Q+ZjD+aSWJ31q?=
 =?us-ascii?Q?78TzwcHoEKXI/o9YT7DpTEXTVpAlaEOMT5DgrfZeXw+1CO83IxBftUZq8NqK?=
 =?us-ascii?Q?I2VyItKlIUI62zXeujy8wDJpOqi42nbwFRfjeLwefQjtUm5LJqrbXreNV1JG?=
 =?us-ascii?Q?RG774lvgalQwIhzLtzBo1NIBsTzGMXEVNPp8+1mQdg184LtpS4OJFZdFPHKD?=
 =?us-ascii?Q?RvwyRMAcMwcuedtFGe2wf6BTjuRRJfDq7Iyx0YntftABNSSFMzr2+9krs4KS?=
 =?us-ascii?Q?Y4bfVMfIsoqCo0pY20cNmvelbE7SqTgMPz/as/cXPg4uKgt/0MbyIZ9/Z5UL?=
 =?us-ascii?Q?kbsBWucJ3FZWb98loe7fHHXi6Ps5H8Y3XjuPrQkbRMQ/Pb5tULVk1HEAJKx/?=
 =?us-ascii?Q?omk+v0B6VQnDu+/Eaio3dxwTN2zDyX/s+mbR/De4Y/ZquDipGoQ4ww3/UFw7?=
 =?us-ascii?Q?lCzsjhGjoYkvBWVc6IBkCJ+XH0XwOEN1S69Kbo0W5qTEao/ogYFQbbxo1GSG?=
 =?us-ascii?Q?cyRftoCKETtIWCRqBqzlXrl7kAScvKwq1biwivEyXzfNDFzoU/JScfBUd4Jq?=
 =?us-ascii?Q?Fvl5eWXl1d3e8peprgwnIO93Eyn/3NKGn8SmqmeWCh+Wkmemqaq/Rt1WRN72?=
 =?us-ascii?Q?kQhCNArKrsqWpczJIKQ5p2R5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f5f1c75-60bc-4b2c-949f-08d91fa98e8f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:55.3183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dM67XH0dDjMSnx1eOYa9f4Jw4OPsKUxsNGsskntkvmpu3eUwdQ93CHGmYv/UekfZH4cH6AEFfHTDHb2EvNTaWGeTAGY6CrBfAu3/NCTMNyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: wYMU4dohyxXSaXIxkObq_Mxdm2CYYhSL
X-Proofpoint-ORIG-GUID: wYMU4dohyxXSaXIxkObq_Mxdm2CYYhSL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for tmf handling
because the functions can change the session state from under libiscsi.
iscsi_queuecommand's call to iscsi_prep_scsi_cmd_pdu->
iscsi_check_tmf_restrictions will prevent new cmds from being sent to qedi
after we've started handling a TMF. So we don't need to try and block it
in the driver, and we can remove these block calls.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index e82c68f660f8..f08fe967bcfe 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.25.1

