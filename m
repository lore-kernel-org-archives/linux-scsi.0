Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF2CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A68361244
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348743AbhDMXHc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhDMXHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMj92g055490;
        Tue, 13 Apr 2021 23:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=PD8qYoi2TfdNcWnPbGfaKvMwqo+sVE7Z/0+Ou0uvL5U=;
 b=obw2jJaxLn6i0oPBbEH+hy03xp2KrDW5LuBMDzBr/4ACotxIvI63j93aEX+Z1lEok5A5
 hhepzdEUlHQqS96ZDTbXe+RHWkZt1v746d7vwgcoDT/2byWmZtPdpzbPofTC0w8+UZFl
 GzslxaqbYqF33Kltm7bmCpukOY575hTGW+oshiGaT/zRQGfvmWzo2PjuN97BMl5AJk32
 a9h9JwHIS+JP803Ky/NDkqa+QXTT6o+OQ4seHz6KyX+zRo7CUUQX4HM+vS5fyWT6jmWU
 jGIf/y/c8IrxF5JVIYsI7TT3O2/y1nBHJ1mQUq+e6ahebfvvCfDd6lMjWf6oFKyUQ3qx sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nngmya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjTQw105371;
        Tue, 13 Apr 2021 23:07:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 37unst1tvs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luy3epF5WUJPd8xufM3ZT4KVUgt54U1KlVcLhzpGdLd+Y21TcA8xgmsmLXlQMZ1FaP18Pdt/+4QKRMkE9dC8ZwzAkoxW/QrxNJ2hmm1kYlfXat4nq1tz0mcC7TQiwAqKsjkMTY8v9qhpDmUSePsTcW1V/Wf5ZlodSyoz2mnV7+Q3sWne4bcMB/nGMhJ/Zm9hpD4iZL9oSxxT5cArdURizOq9d3fa6p6xqd/XSo7UQmVwNAr4RkViCLVfNzUdwsmTRyVP225b9u3+UfOkuzZgiWng6MFymk9mWEJNpWLOys75T8d4+/Ll3LDP9ty/Xx9iJ9DIHKYXj05/Y06OHZDdag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD8qYoi2TfdNcWnPbGfaKvMwqo+sVE7Z/0+Ou0uvL5U=;
 b=LxqG1sW4vAjiEUkJ3BoAKIKvaukSSN4buwDXZID2k4dSCHPVETZh/RG7eB16HrRTmRIVe4E5NY8lschXZgQeUsWpMjDrM6TdR8GlWdJp1YgYpX6uSKUoEb+Sy66dbKkyb7jNqaE2tsY4M72MHsJxpythqvk/dtZeEis2LiKgwvl6FXksPnZlae5GLAGLxKR6+zjwvsSqax4ZMiBwkijn/f888y7WYsPbYBC7OdScQ/sHVkfstIXv6JuvcwHrLRN270hCQmXEoqBTCEhcuG3n20rL1yVP2Tdw+AueOopMaZHO9u4laz8e6GVm1xQvGtsmJJfKHGWdPfMBNjJAHsmKBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD8qYoi2TfdNcWnPbGfaKvMwqo+sVE7Z/0+Ou0uvL5U=;
 b=fjMkQ3gHGCBIvzjc/PJP3L0LcworhNgbdE/McBf9rkeKJiOMQ3OYvvYick6RVcNBLzHPBEpIy4Py2ZLeMSkbbYCDQS0/wxurnXUGEWJO7dYFyk8X3bXpJ6/Hc7M4fWNDo3iVM1M6jApW4FlN+rOkXHJ1v3AdPhK/5ulsSz2ulxo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:06:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:06:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/13] scsi: iscsi: fix lun/target reset cmd cleanup handling
Date:   Tue, 13 Apr 2021 18:06:37 -0500
Message-Id: <20210413230648.5593-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:06:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: deaf680a-9209-4b66-dd94-08d8fed0d752
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB24695902E133322D7E57F72FF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xtrvW9hKZP3LWgsZH2ln84e6oBiTqm1kC86w8rxR8KJUNQjliLL12PrzlULhHC5Aqct3pfc6OdGy1fB0rPcut2drxwizd3hVsTxn6ZWozC+QUQoKKXKVjvqmCaRekI9h0BeYeCgjwimDFHk28OmxccwQqBpIjZgMBqmrRyElPhqRn79j05SD1NTEd/8piqGkvV5FeiUjydh6T7WKsL8NHU/XNO56Y19Mvb0LBDt4Fktxf6lG4YbV9IAUyEIa94mQzYsmqTt++Acvgtj6p4ueBqebLXuii4YyC6Hgy+e02K36pR+TKYsVIXzWiuGPtLvU7fd33/YtC8PhdjPpEV19CwwtFbHZtUVO8aIvy4RS4PdfjnLGEYxcGXG7kClfumLui6Zl7RaY+S43EOilMmn0RLZ3v7vNDTglD15rqgTYyxiXSAbt/spbSbQbF3Sycm7B1dTJIjEKaW7Y04o30UenxK18KFjaDsKHlHxfGeIEsOjqPkkwtLeJNVTyaSwnwlr71CC4YqB6F8RRyzJBjIm8kcv07SKYyzgKEi7HEwS0EcwWKJyi2JP7sRPrOoEdBgfI1JY2dpXYz2xO6+x7Yx/AHcbClJ2lHuS0/enbqYtp3AoIUelKN1n/x467+1LuxdLhYzcqlf7XE9blnCv1y4aVZZmP+hHdimpihxfoLpMSvGXaVIazoqe50vtc7G0F/VZF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wJar8dErpl63c6KAyQzteJqJqJSV9nMBIWqF5488mAO2NLMb04Ck5utJ+dcT?=
 =?us-ascii?Q?rKPWlYvegcKm59T+6EYyOVyQ5Bn1ujUZI1L9Emr8B7OGrNr7mI/q7pW10WUE?=
 =?us-ascii?Q?+uWrYWsw4irJkSdLNkQLncIIaFZ/ppem77pUDmIFczqKqkw0C1+/Z5/n7eKG?=
 =?us-ascii?Q?GBii6JyZDpYRG0bRMBXFvfgzIYKuyDV8kZIzuPjUCW4bwhQolEez7kvNy4Ch?=
 =?us-ascii?Q?E/+Z98mdo6KefA2PmiIbCqILHCtJLm8Q9XFIXvV/S3iyElCc/ya8dmK8/1O4?=
 =?us-ascii?Q?Bo72A80J6lHbxa0mV8UfTYEzyYtB6/oWlw4xf6lljW3AcT3rw/CoQo8yPdL/?=
 =?us-ascii?Q?67Df4WpAosMIR4xeL8SlfLSdLSHzOLQloRMROd+V3LuYv0vxlRefdVdgS/IV?=
 =?us-ascii?Q?Sh66CdOjV0V6Gz2OjMrcyrYiyqUoQDgZrPMIM2dfMomVy/9iJyo4fBfkgZGN?=
 =?us-ascii?Q?ZM0uRaSq0mAd5AlkwdTT0iXVVbmNwPgJMUrP61PoyyH/mQZuTLFqgaxiU30y?=
 =?us-ascii?Q?hcDRaWu/NVegYIvFWbMl5GyaqlAMIZCkTBZotcT6OOUidcsyTBU1YwJCnzYs?=
 =?us-ascii?Q?anh5+Tffif3QkyJpnVRvebhgH0Bmc+hoFKD1g475XTYi7by6pA3CP3bp87R0?=
 =?us-ascii?Q?CRxs8neK0XyPa9r99oZsRnGn6Cq+nvPPaLqUFWEm1UzuawJYCgydWHvz6A5o?=
 =?us-ascii?Q?JxkZP7OmvZth2sD+skOocJuTIRQxEjjgu2cv1aeO2c58hzrECGtHqim/tqNU?=
 =?us-ascii?Q?uC2V3rJfSbyhxXQOsa66UniVAcKf9eP+eMVk/BUN1HOAsgT2e3o1rqmfYKRF?=
 =?us-ascii?Q?ZpNhEb3iMeLkehzj50kJQoV9T6Ngy+nYoW21EBtGLtTUUSogB1fCwXSQckK+?=
 =?us-ascii?Q?4WhYjcpnjg2IKHqa8eMvd/z0eH1GHsWNfiKCPg3DCwyxVnmCjpP0bjX1P83a?=
 =?us-ascii?Q?bB0+HjK2gdm2qVaEnSfeYIfRBmizMSuAqJOu7UB3aVbbeXFXVqO7NeXzqiPx?=
 =?us-ascii?Q?ceiMhiS2KntLEvIN9BlG6O+FVkefuIigwsKLw0Z9W+8PuNrmNS6+BrQG1/17?=
 =?us-ascii?Q?dADZupfs5HmpwY8jn+F05ZouzgW68vytm53ZCPKBal40vEnoR6qbehlpDlby?=
 =?us-ascii?Q?2+bwhG1tdL2XHJhpZaQ/SKBwYbxXRBAQIHA6VpGMW2hFbh+WtyYMtMXypQjE?=
 =?us-ascii?Q?NUQkjAHVw8oOmRiZ9D0SrR0efhE1nhVcdKOmvbFIE+5saJB/FrEvRcIeEflF?=
 =?us-ascii?Q?LRmAt1t1yUdXnAgO+Zd/E+mVjRwMiIQDo83OgZjj6oqxhBNGWiiHeanAXHNu?=
 =?us-ascii?Q?D2dCoAFTd3ba4M8HAcocN2XY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deaf680a-9209-4b66-dd94-08d8fed0d752
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:06:59.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvpZ9svI/MnkNdSk4A2fi8gqFU1IlJkthy3S80AaqDmyfCJxi43oQ14Evf4MAvDEFQiUjME1DXVFziNeoTj9N6bHsHxX4cjhJ5tKswlJ6XY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: B5koV6EsZgTXL5UPLuaGD8d6IxbNo9du
X-Proofpoint-GUID: B5koV6EsZgTXL5UPLuaGD8d6IxbNo9du
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we are handling a sg io reset there is a small window where cmds can
sneak into iscsi_queuecommand even though tmf_in_progress is set. This
seems to not be a problem for normal drivers because they know exactly
what was sent to the fw. For libiscsi this is a problem because it knows
what it sent to the driver but not what the driver sent to the fw.
When we go to cleanup then libiscsi might cleanup the sneaky cmd but
the driver/fw may not have seen the sneaky cmd and it's left running
in fw.

This has libiscsi just stop queueing cmds when it sends the tmf down
to the driver. Both then know they see the same set of cmds.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 104 +++++++++++++++++++++++++++-------------
 1 file changed, 72 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..3ff440d37a36 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1669,29 +1669,11 @@ enum {
 	FAILURE_SESSION_NOT_READY,
 };
 
-int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
+static bool iscsi_eh_running(struct iscsi_conn *conn, struct scsi_cmnd *sc,
+			     int *reason)
 {
-	struct iscsi_cls_session *cls_session;
-	struct iscsi_host *ihost;
-	int reason = 0;
-	struct iscsi_session *session;
-	struct iscsi_conn *conn;
-	struct iscsi_task *task = NULL;
-
-	sc->result = 0;
-	sc->SCp.ptr = NULL;
-
-	ihost = shost_priv(host);
-
-	cls_session = starget_to_session(scsi_target(sc->device));
-	session = cls_session->dd_data;
-	spin_lock_bh(&session->frwd_lock);
-
-	reason = iscsi_session_chkready(cls_session);
-	if (reason) {
-		sc->result = reason;
-		goto fault;
-	}
+	struct iscsi_session *session = conn->session;
+	struct iscsi_tm *tmf;
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
@@ -1707,31 +1689,92 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			 * state is bad, allowing completion to happen
 			 */
 			if (unlikely(system_state != SYSTEM_RUNNING)) {
-				reason = FAILURE_SESSION_FAILED;
+				*reason = FAILURE_SESSION_FAILED;
 				sc->result = DID_NO_CONNECT << 16;
 				break;
 			}
 			fallthrough;
 		case ISCSI_STATE_IN_RECOVERY:
-			reason = FAILURE_SESSION_IN_RECOVERY;
+			*reason = FAILURE_SESSION_IN_RECOVERY;
 			sc->result = DID_IMM_RETRY << 16;
 			break;
 		case ISCSI_STATE_LOGGING_OUT:
-			reason = FAILURE_SESSION_LOGGING_OUT;
+			*reason = FAILURE_SESSION_LOGGING_OUT;
 			sc->result = DID_IMM_RETRY << 16;
 			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
-			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
+			*reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
 			sc->result = DID_TRANSPORT_FAILFAST << 16;
 			break;
 		case ISCSI_STATE_TERMINATE:
-			reason = FAILURE_SESSION_TERMINATE;
+			*reason = FAILURE_SESSION_TERMINATE;
 			sc->result = DID_NO_CONNECT << 16;
 			break;
 		default:
-			reason = FAILURE_SESSION_FREED;
+			*reason = FAILURE_SESSION_FREED;
 			sc->result = DID_NO_CONNECT << 16;
 		}
+		goto eh_running;
+	}
+
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		*reason = FAILURE_SESSION_IN_RECOVERY;
+		sc->result = DID_REQUEUE << 16;
+		goto eh_running;
+	}
+
+	/*
+	 * For sg resets make sure libiscsi, the drivers and their fw see the
+	 * same cmds. Once we get a TMF that can affect multiple drivers stop
+	 * queueing.
+	 */
+	if (conn->tmf_state != TMF_INITIAL) {
+		tmf = &conn->tmhdr;
+
+		switch (ISCSI_TM_FUNC_VALUE(tmf)) {
+		case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+			if (sc->device->lun != scsilun_to_int(&tmf->lun))
+				return 0;
+
+			ISCSI_DBG_EH(conn->session,
+				     "Requeue cmd sent during LU RESET processing.\n");
+			sc->result = DID_REQUEUE << 16;
+			goto eh_running;
+		case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+			ISCSI_DBG_EH(conn->session,
+				     "Requeue cmd sent during TARGET RESET processing.\n");
+			sc->result = DID_REQUEUE << 16;
+			goto eh_running;
+		}
+	}
+
+	return false;
+
+eh_running:
+	return true;
+}
+
+int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
+{
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_host *ihost;
+	int reason = 0;
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+	struct iscsi_task *task = NULL;
+
+	sc->result = 0;
+	sc->SCp.ptr = NULL;
+
+	ihost = shost_priv(host);
+
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
+	spin_lock_bh(&session->frwd_lock);
+
+	reason = iscsi_session_chkready(cls_session);
+	if (reason) {
+		sc->result = reason;
 		goto fault;
 	}
 
@@ -1742,11 +1785,8 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
-		reason = FAILURE_SESSION_IN_RECOVERY;
-		sc->result = DID_REQUEUE << 16;
+	if (iscsi_eh_running(conn, sc, &reason))
 		goto fault;
-	}
 
 	if (iscsi_check_cmdsn_window_closed(conn)) {
 		reason = FAILURE_WINDOW_CLOSED;
-- 
2.25.1

