Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773BFC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4322C611BF
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhDXWHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhDXWHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM4k9r050810;
        Sat, 24 Apr 2021 22:06:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2bVq9vMHj6Lvolc8rkZENDqA/a5Et07MVsyK64uDbXw=;
 b=sY29mVj1YRg4ggJ+loJR8Rlysy2JUxrgWPvYpTV2hyNDoaq3GfuzkWyesGG+IbFxR3vY
 1Txtp/DdkHGk3CAwo4O7fkLpbt3NeOKSbc+Q4OM/7PfG3AfZKq4BaOEl91jrcmxX4e/x
 p+dYad4zHtGsOnSJvNev1NFm01UexdQZ4CO9tH22fFd/cNPJBImjUkpxAQypQI5DhITv
 hfkSG0ZtwQYMGuHXJSFCJSQ/DKHRFEQuDbJN3UuLQQsmNsEmuzQaS1HEQAdG2i73JQPS
 +j9QhpSS4eiTnvz7DOcRh/kmR5hK9517epWfXVOOPJi29rO1Q7Auyx8HxV60oRozDJQn eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3848ubrvdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM5Yew053539;
        Sat, 24 Apr 2021 22:06:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 384b51tykw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fa4M6p0epNOsEyUacNxZcHY6p2F91/Yo0PCOViUzFDOvEZOTbtaFslHj9UY7d98XVvlyjRzsdq4h5lVMo/3VmYAGCa/lk22/k9Xvs9q9dChbIpRIKA0XsxhUNpH7FLl1j9uNnQf51Q/TM+kuEu7CBiha8BgRk0NsAP7v9dPI+Mmuf+10Fmj/Un1stwlEIlrAokc4O/iF4DWASJWGHucqEzjqz9OoA5R2xcTDyCGWsTdqdYGOhnmmh5XM2gX38E977uXY6NTnp6XfsvaJxlXQo6bUTwol7JepFDb9+6VBDl9tIEAfjTD95LxJK926WRGpO3lTx2A4Op11wYkr2cPEpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bVq9vMHj6Lvolc8rkZENDqA/a5Et07MVsyK64uDbXw=;
 b=OK5Z+liz+1ejMdcMTe0S/Di4nAPXyfwcAlUAk2B+cvpNP1VteiUzvxE8dsoZuDB1yHi5mm05gQF8/nrt3lQSvN9sW5sKynfduJI4Rj5bPPPSswjaIfn0qvd6yfzethHZ+aUEOpH5exaZCwllBY6zkTunnr5ENL+GvpZWjA3BdqskLZIkyCbr7e3XZl+k65b69atZbaCypkT2aOzrHIoMJoQKWxdoyS4AQKdAI/QioyZUYI5GEIlivWda6BioZvufkNk9CJr97IfTfejhuRfUkkGs5JOZqACHd9ciKxJdd1CueUGvdhja04b5eGjCJdG9jc8CHrHR77CA+fxiCS4z5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bVq9vMHj6Lvolc8rkZENDqA/a5Et07MVsyK64uDbXw=;
 b=N0Wr0EZ87mgnXd4HFAOP3J+3pOxcHX+B623QGCzpjTxzrHeldgyjZk1q3a4Npl8GEaq80fTj7rs6e7xsEXdMzOq05rtz7HZhFol/SGMo6UDxoUlMOWkpzbXtN4otVyhR2Iga1KEikAGMNqnMZGXIdWNArHghA9CUQ8/ST/w0Ftk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:14 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 02/17] scsi: iscsi: sync libiscsi and driver reset cleanup
Date:   Sat, 24 Apr 2021 17:05:48 -0500
Message-Id: <20210424220603.123703-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 379461d2-e6ad-4256-0284-08d9076d2d6f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317EBA2B661479A55461838F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Py4a99BEYEUetO9Lq2iI2/In9vqpzhR62b4Dh0XcNGCW9CGd1Ygj18JJN3CvYU6pQZktHpRrZCpEbmmQ7A8lK9raDVbqal7x76YU/WuQOC8edCYqaClzGbZQK6UO29h7LgE9ahnNXeGO+cojve6uaWfCV87SMZzyqNQuLInaP4S54go4Vsss7yVsenMFxUVrtBRFCXGojmy2SHY9uR0BPFfc13nX3Pqc9Np4FEuuxn9BZCHu6JMgtDmOwh2Qu9pSUJO/ue31CJbbomyQ3zCm04lFu8THySNE3h+uAJUp8fJnw+ivA0DeQRC7ST4bgz1bjNuk2Hj4R5iF4m9PPABMh3KKDvnfU7JyMXlU+NYPvunwhlSJ1V9s6au4eA/yuMnBZqflnL0Pmpv+ftNImBmtL8NHGKwg212S1ySFkS9vrUYT2hO3fgX7bgpiNIOjO8codiZ77pk2CojhHTqVK6ndsB5FCxwmwCllDJZlzfk+q32JJ5xnUmkkwMk7KZfl4DLok/XB/8E+S/ZvkJsQHUwAESrr7bj2hZ686NF/Qc4snNYW/6SFbI+yh9+tSqHOuxBolXH3iktltAdO0jciys3DBZ5Aj3lSn6tZIlJbWcwQXkgu/4W+juNVwcNm9kwzKxmPbXvHl6L9KhK+P8fiJdDEgp5c8pgNc5cCWGtiZneG3UjwYh8EQNyyYh6fip+HG/x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y/0bMuu0iw6o10jdz8AKrZFdFXMSNmEMiVYWQyh5JEBwliHYClIhIZcQxDIp?=
 =?us-ascii?Q?aGfl9RXsxYv5ZtOl2BOaSvJxMvn4DUP6HpWs4Y7uLWCaVtz4rciLG0ZQ/fh6?=
 =?us-ascii?Q?xA0YBbJMxv2lKiyAYd2BmULpR3ikk8I2iqPW1jOMLf2uzUsOLwk+1DGjVwGb?=
 =?us-ascii?Q?6ppn/PvgvYT4YwnKZkfxCb8jRKmpcmySApComFW+fmFj75wYfXJs8tTGfDLA?=
 =?us-ascii?Q?9U2b7Yj9QgmoYoYfPXgIyuvk7Xq6urSxwITjSCq4CiLhPdooRBNvJTNBvwLF?=
 =?us-ascii?Q?3ocR2L1UzEoYrZMVDBFIXXyv9HNiR9GkBPkFlqxPHtVKpLmNwhqZ3vCdVuDS?=
 =?us-ascii?Q?eqzvZlt9P/kprm++kHs0v/l0bGWQUKUAm7T0H3KmvAAjVfcuePKyqmhN09PC?=
 =?us-ascii?Q?//AbXaMkKVPVrt6WCPv0/YnBtMbGtgeCnarT+JSig87SH1Z1AiqdIzuLT/4a?=
 =?us-ascii?Q?R9jc1tzfA2Zz54QAdosrpVIQk0W3hrqHuE8ZvQfOwXS369zrUy9/EEhwWmhM?=
 =?us-ascii?Q?kyHEdx88UV/XISZBvMJJQxqw9mIhBea8o3NQFb9VIX9IsXPAAfwLX3nxQ96U?=
 =?us-ascii?Q?UahsATQffki6DpemCp0fl/PGCNGvZ8L12cZlfX2+RIYT3tLWmVXH2lxNyYKc?=
 =?us-ascii?Q?KOnPdGHUt7V0A5u0b3ytK2BxQ8d4zFGqoWHrZTbHZIufztmW/TQiKHP0TN3P?=
 =?us-ascii?Q?svULvVHTv34oKdpNA4r/PmSdGHRBgSfjtZWS0Y9z2YrGl50O3sWclUACinV7?=
 =?us-ascii?Q?8RNZAwnOXM4VsDh9CRUoKtAooH7NToZe3dFQmIpGu4jU7wrc35eQzeZbPdnn?=
 =?us-ascii?Q?Swj0CcxfTqkbkSQvcUEMBlKst3mYpb8EX2RlrxjLS/BW1jpfrAqcbrzag2bE?=
 =?us-ascii?Q?LPP5wZFGgXmNHFaFI/l8KmkxLzOB+ROk5m6JyOJgj8L9xuAKAZ2tjjmHeVMw?=
 =?us-ascii?Q?ckaiCzsHykCeEGggmUDWh87+zlxgK807X612a7Gt7bWemnRZYXZd/QQF7m3G?=
 =?us-ascii?Q?dUHDPWHGP1yt0rZSGt0z1+LMS+lhc3PoRmom5F2mc10aBCofJDYxt0+r2Cpl?=
 =?us-ascii?Q?cXtNKEXPGqJCWsQv0OiViSd05iXpYv+n/Nee8utrRvBeFWyga7EXti9qEvrW?=
 =?us-ascii?Q?WgiC/Dfk3Ou829gsb0JI4RTaCOfefpQPLFcpiY0U0kIWJQg1bjdVrJun5KD9?=
 =?us-ascii?Q?ehgyOqCtZmIQ0Qo3vniRwmDSTFHYgRs0/mlc5WDK54Zk4IDpseYXB4A/Kjx6?=
 =?us-ascii?Q?B7qkdc2hyZAnoAVSuozjMrLf05BvqQfaUHx4rFOlM5pPGNFJxkWmqd3OiEK0?=
 =?us-ascii?Q?80EBRU7QEuOZxpN9hz5JsT3u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379461d2-e6ad-4256-0284-08d9076d2d6f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:14.7353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2C1efacX3j/1vVu7Cze2qs/JFF9wCTTZEvsru2TbFvqN1nIGKFr7PMTPUiPxk3NyJlzapbd67oCaUlTQDcLdC4eAqdpuB81KIs2pENqcNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
X-Proofpoint-GUID: 6ltk5oHEwjBLFzboZ6Bb2pev7t4jOMbL
X-Proofpoint-ORIG-GUID: 6ltk5oHEwjBLFzboZ6Bb2pev7t4jOMbL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we are handling a sg io reset there is a small window where cmds can
sneak into iscsi_queuecommand even though libiscsi has sent a TMF to the
driver. This doesn't seem to be a problem for normal drivers because they
know exactly what was sent to the FW. For libiscsi this is a problem
because it knows what it has sent to the driver but not what the driver
sent to the FW. When we go to cleanup the running tasks, libiscsi might
cleanup the sneaky cmd but the driver/FW may not have seen the sneaky cmd
and it's left running in FW.

This has libiscsi just stop queueing cmds when it sends the TMF down to the
driver. Both then know they see the same set of cmds.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 106 ++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4834219497ee..80305b70298d 100644
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
@@ -1707,31 +1689,94 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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
+		default:
+			break;
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
 
@@ -1742,11 +1787,8 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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

