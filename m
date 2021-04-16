Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081ABC43462
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D699D61158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbhDPCFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237984AbhDPCFY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xwdc172162;
        Fri, 16 Apr 2021 02:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Q8A2WbSbpHpNPX18bxDHQyE7Ssqo3u/ZDKWnzfbqhKc=;
 b=RtUoYz/VPQGg8kKpJ/576VqiXvVTOCGkKmwqEPEqIBoEoXAxGbKdqsapr+4ZM0DUtWSY
 RoJbT5fZM6M99YM92sr+Fc6CPyJs3ZzV2ubObABHBbH3JZgwhTYNE8DT8FlwXLdKlMaL
 yy1VKRZIDcR5BoOGrawuVTF835hEsrN3PFHeaXHc9c/lDP1oc3njnhBWQXqjEPEvdYdq
 OsqvK8RRTlZQuxzC4O2CLgjW7nKwne48PN3n+TLzjrECyc23ay4batm6rw32bJfccx3K
 hpsuBVlBXqzXg5NVRFfEPO58oO2TSRkx1wzc4o0N31aDE7fTTsRZ/PqVQwXMyYLMvC+f KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nnqmff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20eZF001033;
        Fri, 16 Apr 2021 02:04:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 37unktfb62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=di9yFx4lSnl8goG3pqNxmUzXjVPdkPxuGd7W7xv5yd9wP3VvC131gPwwBOkH3BW0W0ppZRdc4DfQXqI/179RnvkxgZs9fXD+6ixDnZGRI9E2NH3EQQAjh+doK8Dm17ECp7kfA5fYzK3jQH1c+n3OStlIGlC8XT/l6tfAQCdGsCEVOU+kTtL/dxkf+9xw6ifH5aeP7sO2P07a3Q6zxz67NwiRvRgk+b75Pl9nbxs2LmKM0H9mTk22UoUhpsZekn/n3VxmzZdy224eJM0yMt04T4Faa8z+7V8fg4lLi5eOjH9F5So/bPS+qpEAEwUutfofUcjIF2X1L+7np2Sg+ec1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8A2WbSbpHpNPX18bxDHQyE7Ssqo3u/ZDKWnzfbqhKc=;
 b=Avc9Mv+EZsjUo+lqUBkMYvWQWof+Z7BzIYd2QXgTm5KO8jWa5N7yYUycUIegl8r7nr+oQJ41NiSQcOI3vCB98RY5LiwB6HKei35keJo8EPFKi9w7BLkFMAzGXbXsAzgZ1w+4CkAQGj2aHv/8031wg9i9CRv3XyGCtOvY9KzI9BuG7CXDDKea26KQoTGfgmeRPiYZsFhK8yJHjf60RxkleHck14Jraz4c4DRMeWYLCIWqyVlhSKVqGd1uMcsCOuAbv/DtBRqszq+BZI4U5a8pYrZVHD9JoGxPw8g40G2YUusP0x5A0RDy5EzotvrZrdI2uYyhW/8GSp3MQMg9ltRvbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8A2WbSbpHpNPX18bxDHQyE7Ssqo3u/ZDKWnzfbqhKc=;
 b=qwy1+BTz+xdh9jRbROT3t8hT5M77KyVLdcTGXxhbymxBz2jhUFhvl3rIF9HqTPTZ28bsVEgztAM1AUZ+n3mRZ7rOAMuPCzfW7OR+Zq9pFCSHdHcuELbx8VOVYaEDCh4TcdGLjmHTt/k+PAES6S18Dawc8b0JcNNxvGBFQ9t20bQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:51 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 02/17] scsi: iscsi: sync libiscsi and driver reset cleanup
Date:   Thu, 15 Apr 2021 21:04:25 -0500
Message-Id: <20210416020440.259271-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0118303c-1a44-4942-b577-08d9007c0541
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421EEFAEB00ED03C61FCEF6F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QD+tfNgWuWSW/RPlKKhOnQr6JFe74ei20qB39EkIGU1a1oA0tT9H52xj+/l4egmlGIOmbpktuDyLEhRgW/U1bUqrPzfe8u1ec+wWsEWtJi27PGURsTjIPywbT1ASw518+AjXtk3DKa2Er5mmzt2JUwM0+fH+FfPLXpDlVfv0zNtWitx+FYRyV0pal+d1CaJP1xNPamTvU+LNi6QQjpoZQ/FVHTnmIJvCXxsZgkbERVeIfQ5fQ600OWHkYE5+BVf/Q4UVDFc5kktK0wmFKvNsYaC74dZbAby3sa2YDGZ3TXR8W0sMdo/7KciocxuLHqJOpjQRw1MVsIhLMV4GE1IBCc4AT1lBelYZgeKBZc89mhldBrIhfVG//l9yZPOEWmAffvqnb3BKv1YwET7ys1zM6cmHeaELgbI2EgSQuiOnaelxUHCVa27hAEnEAKr+kNF7uQ09ZUBA2G71rPHwdofQ+ubDmzSanCWJU5zprtPQvFl32s14WBeKeTKUmcWOzpU6IzaHKaUQiTcL04jWMgIZxul6UiEmpMsoxaB5OWX5JRxWJBd/g5SLMtg0eLMg660yv17JXYI6dXCRzCXAj7hfFrEYbYP7Cuy0ulIhfmfk/7vpqums0CUHp9UpQIO4goN85d6UeZQzuTt1rpgmU/aPnkD0glTSWEabu+46gfYIEtJLTlhVp5tAsglALxHv0uL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3NDzssDymi/fBw9YaTuFDPmJ/jhaq0boxaZF2My9ad7uRQysfYAnvP8LFfFV?=
 =?us-ascii?Q?FvNcT8hoy4WUoofInXbn2AE/zZxZRhaiFVEC+xZukjjhbM9VZHPhW83IcioH?=
 =?us-ascii?Q?ip4C8554bveFtI6+daQNEY54jHh8dwXmGKvzNKLlTR8mOoTgbeA0Ubj4ZPB0?=
 =?us-ascii?Q?scnYiyNv7R+c4yllMaDSafyGV5LZMMnjfWQAJKdlPqa5Q1h81slY2reEkspl?=
 =?us-ascii?Q?U7EPvv+meGmPCzrb4zCgcdh5iPZnIQY9CgN3GR8seiRoRpgIpOxOC8a6JEyK?=
 =?us-ascii?Q?s9E+FVcp/vjtxhcsFbpCAHbbXoir46+dPCd6k++y9NvMi2JBie446haegDTU?=
 =?us-ascii?Q?0pc5F4r7YUa+L5x8vpb6bI+JkWGp1E3AcFTG4B8AU0+oSebvfriadXF4m4oi?=
 =?us-ascii?Q?SaMwERguKUleIpIVzDdE3oWpMIrP2NgG4oT6pCMRM9jjADgKAVBlqGqTuBVX?=
 =?us-ascii?Q?zllSOc49aWQzt3CJu1ylI3cxX0/tDL8pD7alMYtyD9q2YJZVe4XFF9TWYCnD?=
 =?us-ascii?Q?paB35m5R5ZAlrc80jOGN4w0/e0lwGZI+qsxKWM8wO0DQZZtMNpooxurlkz8t?=
 =?us-ascii?Q?z18BPV19FWfqCsEQOII9u6nvggT30UsCKP/POLVln2iT6owKBvGTpL9Zgq0c?=
 =?us-ascii?Q?D7lLcBUrsUQWc0Pwx/6tLBVj8Yr1mLte75wtc1gul9/sG+cMLKkAzj6c7CWa?=
 =?us-ascii?Q?s17GMWfH0CGLLiOjpf+kIJySiLK6E32NoaAhJRh16JpnkmQq2f5ikJyAfoQX?=
 =?us-ascii?Q?Df9FgCLtkcqrlGUcPfPHms0Uz73SgmOgofZ3D5cXUF3Sfr00hK8mK3DVEoiJ?=
 =?us-ascii?Q?uZi9H1UzW3Cvdc2iHTScNyBpiqHrb4HZgnZy9mp/2sE5bEOGj1t0S2etYYkn?=
 =?us-ascii?Q?KkBmJT3XGiBMDA98AFE2r4KGbIlCLWrMsEqTxYKFs/67DsJ3/O1xzhFk7vRx?=
 =?us-ascii?Q?IBuM8VGqdhZgxaHpYSvSkjbxE6ihe5J6bWjHOiikLxnM6LwGCiruJvkKBES3?=
 =?us-ascii?Q?HqZN/fm+LfDvfZlVnw4mNRzI0fDEBdWUSEOPv7R5jsPUc1OYEmyOSITl8lGI?=
 =?us-ascii?Q?mEF3RZtcRWGAwN1xeE2TjyYB8ptIRGoPZFm7KZw4jYzEt0a0giqp+QUMaOJD?=
 =?us-ascii?Q?s0LHWmWBTHNCZ+flRepXacS7Ng+2iNbyWkGzsrUG2NUg3IjYE8khJfta8tww?=
 =?us-ascii?Q?ovjdYy1NNm3whOaWnBeH65ruGm3+y51U8wVMQz0O8zu1n7VVvghzo6fpwOVo?=
 =?us-ascii?Q?F55hqC7RsQ56cO7Cn1Mk33QArl0YWVCXkyhETGRcYp4Azqlq9yw7lq4thVlh?=
 =?us-ascii?Q?hdvIK+69Kl3yjVJKW7RFf6CO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0118303c-1a44-4942-b577-08d9007c0541
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:51.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQDxrpv3LeXOzy3mQZIbqP2mOBdJWcMzJFFen+OSBTgUdluOcn2gQ1wBIgdNHjw11d+U3rJd/ss2L09bOAPShul4MT6+yqGdNocbDLxOnEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: WRg1M0RtJC1xxooOpBe2qNyfPDst1Kvb
X-Proofpoint-GUID: WRg1M0RtJC1xxooOpBe2qNyfPDst1Kvb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we are handling a sg io reset there is a small window where cmds can
sneak into iscsi_queuecommand even though libiscsi has sent a TMF to the
driver. This does seems to not be a problem for normal drivers because they
know exactly what was sent to the FW. For libiscsi this is a problem
because it knows what it has sent to the driver but not what the driver
sent to the FW. When we go to cleanup the running tasks, libiscsi might
cleanup the sneaky cmd but the driver/FQ may not have seen the sneaky cmd
and it's left running in FW.

This has libiscsi just stop queueing cmds when it sends the TMF down to the
driver. Both then know they see the same set of cmds.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 104 +++++++++++++++++++++++++++-------------
 1 file changed, 72 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4834219497ee..aa5ceaffc697 100644
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
+	 * same cmds. Once we get a TMF that can affect multiple cmds stop
+	 * queueing.
+	 */
+	if (conn->tmf_state != TMF_INITIAL) {
+		tmf = &conn->tmhdr;
+
+		switch (ISCSI_TM_FUNC_VALUE(tmf)) {
+		case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+			if (sc->device->lun != scsilun_to_int(&tmf->lun))
+				break;
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

