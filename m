Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277C1C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 063DF61360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbhDCXZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbhDCXZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKOUd160347;
        Sat, 3 Apr 2021 23:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nRVocMsN7iqx5vbwaougkpKPCDoDa3HpVJLqxapjePQ=;
 b=Y6jQxThW7afXAOiFkyuK19wPvvSP6pW1aMzMdSC0gbdHt0c8UNsg45cBEBspuun44LEh
 jPy8f3v5hdeCT5jLxT2k8mp88eeHGbFB+u2wh78XbY8RiJc75gooSIuHtGk+6GsMZcTS
 /J/rE6fCNk91aTV9JTYgueVGpYlJEV922URHyHRPCRM3NgKq2VezBdZx23jBnUbzWD6w
 9p8LHqXlOPj+i0IXSV4RV5EFWXOYqgScvo+3ar6xHK4gxaBIcKizyC0fb4Ta/b7a+viC
 OqDZgAy7FAXm70GX+SGC1aJbye56K1jZYc8Wa4q9dAMUw8Uvw59otJzi9z3ZjB/LdRLm Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBV117020;
        Sat, 3 Apr 2021 23:24:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBKNHwMFKZbAxOqdNU8u3opSGn0YFU8WYeYHXHhW6eoeAKFtsIbCfuBbM5ARYwyGqGeZasjHpF0EXOS/2MHsoa3ccIHgv21zLupmEwVUbaD49FSc5TBr/+ZvgdlEqn4zTx8fDtl6OpYzDcqlMBWcUl+ZlJYobPh5yrInGGZB5TKQ82K9ZtYRzSP9Rur8sFxFRtD9CnIINzpHhrSMct/LGlnlpybkkjeRFrsKxOZk11uWMbb0gFi7CVkz0syFJG3iaNGT0X8yVmpU+DK9zprtwg9C94jVnyJkjG1oEm/uZZgbU/ebKzrUD1alj6mN4Brdckb1YGlEQ4MBRidIEKdT2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRVocMsN7iqx5vbwaougkpKPCDoDa3HpVJLqxapjePQ=;
 b=eaQnyPl6O1X/DGouggqJnVG8Q3TOT9MYhcabei6j0Hfm0sppn8mu/QpnFQCIG1GMsZFokXiZicU50EgT/i5y6DrSG1kM3aJTVQaxPoy0l0fLuBAHh+/rH0fnGQmv7ANkRvRGkBhxt2tP4RfeX4TG+PaUBnJ3KKGX1r7SE9Bw8MnladcS6gI76tROwZwYvQmbp9AjAdAkukr1++58T4jJusVQNwLBlXT36+mXek1uTJsENSWVyaV4qNaHQIpmMtH7a12ssFuIiLlA+wQECeMLkQFvzq1Apk5XVw2XkX+n1mSZxkYUC+M36ZgF4EmgV7ozBRUPaXzcf4fjcdB2Pl/VYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRVocMsN7iqx5vbwaougkpKPCDoDa3HpVJLqxapjePQ=;
 b=b/olkOKhasRo2S4iUd0Yy8iPJTQ0V9J1vuFQMYI+qPsjZpJZwO/8pEayIytPVfZYvKsKuDAJzy0RTn2InT2OL+JoYm4eFzqukGnXADNuYuzNvXrZfEH0JlW5xRFLU0VQDJ++usSFqwevIKe2P/PD6ZTGakSwNG4iytjLGL74DrY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 35/40] scsi: libiscsi: update leadconn comments/locking
Date:   Sat,  3 Apr 2021 18:23:28 -0500
Message-Id: <20210403232333.212927-36-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2298b6ed-cb6e-41b6-20d5-08d8f6f7a1bc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34318E35EAA17CA645AA1CA5F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ynRkwCO7C/lQtXs5TRi64BCuRti3+A7Ds6ZzyeEe0OLLZ70xLxPxQiYhIxAVdJe2RX8B/s7vpxkkagdBRf5QYCd6nMG3unQBde7M6EEg/e04KFl0HxZ85RPjUjbJi0aqWTd/pQOQv+QJMRdSInUDDnhw/l1hoUBDOlAp3AlNG/UDdU+QsU0KAvKXg/2mdVqYvSXiE4sq8M+/6C6G5mtN6OEBdbNjumU7XbM6xEwEtcGPZYJOeFxfF4xx9ZihCHtiitGef81srM9sAAruWTX79ichZ/R/YBLrpIFfzs+WMc2poOTQ+xFQhPzQoGy/hTj2mZpsQPj7nsLFY+37sX95ZY5DjRxrnE2DqQeUS7qbUQzK1F1CumYQqcZJBtnxT4Szk47ns46qv3krM4rmnDQd8NesN11pld/wQwWYi67JE9+Ny+QVAvBIQXPRPLUzRI4qxVgiLQIS0R2LVFF3XcIlK5yO9OH98qi3WKIV21WtoQQTw1exAZLRyDgzLi0NUq8kZ/v4JgyVSjUgX4kkBH9HxMJhMFQvePG03M6BNeJAvaV/126j4AxCrT5cqZx1XUeoXmcJlS2HSnuxDY7Ou6JPRS4DQsq46k1ysGlz3Jar6rS09xKAor15l69yQmgCJDfbFOEq5a2IkE2UrjsXZG+qiP/cISquittkKuxVcKREi70J0aAj38xw286M+vMSZTaeYEZi4F5msS8MGupzOL+D2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(15650500001)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YenIm39+OtB+1M6lDM+oc0O4G6pWmQrgcgnoTor23ch1pSZXyGA2UGHRTvx2?=
 =?us-ascii?Q?ZlBvp6tC5m4IBqvc+1j1Au175dsvGhpfajOnYZ9dZCbEbD0CUaf1jk6AWwkk?=
 =?us-ascii?Q?K4CJTeNCUyqQ0yEsSWOZGETwy8prsOwDpuQMHsCDdVmYNtaX6aOxdxttQko4?=
 =?us-ascii?Q?fafoap0F+FhzygyOamACToYlcvFl5OD5qE0EgjAdvQpSMZZd9kq4+C3sFbln?=
 =?us-ascii?Q?921y9UdqUxXc6qKnBC1OiuoOxtvKB4UFEPwJcYoA6U3CRPqQwLx0W+kVsjTx?=
 =?us-ascii?Q?GqxSSDcPBp7ux8aEDB1kqIrYeaoC+ML0IIqii2lWG4RjFUVbErNOw2QAy6OV?=
 =?us-ascii?Q?LKWtmJ93Ok2NroaH0tc3kxZOXf5VlEzB8iFj1+Qs0t/nCsVeEKBXxESiOopl?=
 =?us-ascii?Q?UAWAP7mz8WFWzvfkJyEYSszoJcE6JeSTooHGzRYYrYp3rw0PHj8esG7teL9m?=
 =?us-ascii?Q?fgaZs1szKRyHBAt9J6zLVutIfGzKU2LrPjTPt1Rk9T1AlElL4j6h4PqVqFYe?=
 =?us-ascii?Q?RMw0vMj1cQ2CgBVlMMbq8XELqdtEgT0lytpv5BMwZH0Pp/u3Ktlm2iKiwE9D?=
 =?us-ascii?Q?gihEc5nhrxLWNQPOYHpMxVCphK44cnVRtyYv0bZMn2m+6GoXYjnYrtJifqSt?=
 =?us-ascii?Q?qShqlNr0zaxDYG5GMHrGZYQVtlK9wU8JVdhyrUkynzvaGYH/yfuBtGB6v2fn?=
 =?us-ascii?Q?vwpBVkPOcnMr5hqtgeIdvtxiFKSnyM4dLb1440MTc4WgKCoP6XhTTNLiRuSj?=
 =?us-ascii?Q?htXPuwPQCDvWuQH8zj2zTkwJpqYFNi8IV8cmlUkZ4jqrplDj7XRlLzE352Ck?=
 =?us-ascii?Q?uwOGpwyF5zR5iNFENjvAdghIxKoQKZfZ59SlKe9sOMShnPExo++16J4v6S4C?=
 =?us-ascii?Q?rG9np3qIU54udhmWPUzo7m61SmhhcQjrd+Ga31Aysh9dY/JJkKmKkoaXb94X?=
 =?us-ascii?Q?xV0LiW/CirLDAVV15uUY5UV6VS1qharpS0g9ZH9sQeWkUzvmwleBr71rm6Yk?=
 =?us-ascii?Q?RC98Qg/JC5QO6lyEBGxyuIF/VlTZhol7nC7BgDgIVfM71MDL/KIpN6W4fBJs?=
 =?us-ascii?Q?mH0z3zKhsVVrPoSVijEb81GQIzAsKpPWrIxqfCr2xonStT41r0KX1I5Iju/K?=
 =?us-ascii?Q?lJzCsDtjAkvit/wktC8IxvniSZlHZm58Dnc56cYcGpL27bDt8DkySmu4QHwe?=
 =?us-ascii?Q?2F8W/juU12VGqtEuYOi1XjEyM5FLIthyTb7t+6NrU5+/oe0wHBBYKv/FSG/a?=
 =?us-ascii?Q?j4M8zmHCekGsdkZWUQ7B7hQfGyYXNedW+qRMq9Qou0fwNYDbbuThprcw5Mbw?=
 =?us-ascii?Q?X59W+RiY/TI87BrIk1z4WTes?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2298b6ed-cb6e-41b6-20d5-08d8f6f7a1bc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:30.6019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTzRyf/fzik3wTSjW8u3HNZtxDT986lhQGQeoOYX2SB7I6QiDNd69iZLvsOPcVRDXk6HQk9kDEgZELei27fZ9vJmkmck0JuREYXVoinNkYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: EED16BBI-ZLp_gT1hf0rYw4YlFJjfm8P
X-Proofpoint-GUID: EED16BBI-ZLp_gT1hf0rYw4YlFJjfm8P
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need the frwd_lock to access the lead conn. It's setup at
creation time and then only cleared during destruction. It was from
when we supported MC/s before this code was merged upstream. We've
only supported the single conn session for 15 years now.

This cleans up the non iscsi and SCSI EH paths. The frwd lock is kind
of intertwined with multiple checks in those paths and I have a another
patchset to fix up the tmf handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 +-----
 include/scsi/libiscsi.h | 4 ++--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e7d1b69c07b5..211c56fc6488 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1813,15 +1813,14 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
 	if (!conn) {
-		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_SESSION_FREED;
 		sc->result = DID_NO_CONNECT << 16;
 		goto fault;
 	}
 
+	spin_lock_bh(&session->frwd_lock);
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_SESSION_IN_RECOVERY;
@@ -3441,11 +3440,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 
-	spin_lock_bh(&session->frwd_lock);
 	if (is_leading)
 		session->leadconn = conn;
-	spin_unlock_bh(&session->frwd_lock);
-
 	/*
 	 * The target could have reduced it's window size between logins, so
 	 * we have to reset max/exp cmdsn so we can see the new values.
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8001c5a26a00..c053de831c2c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -351,8 +351,8 @@ struct iscsi_session {
 	struct iscsi_conn	*leadconn;	/* leading connection */
 	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
 						 * cmdsn, suspend_bit,     *
-						 * leadconn, _stage,       *
-						 * tmf_state and queues    */
+						 * _stage, tmf_state and   *
+						 * queues                  */
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
-- 
2.25.1

