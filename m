Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8D1C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523AE611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhDKH4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbhDKH4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7oLPm128258;
        Sun, 11 Apr 2021 07:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rTVY5gwUSmjiV+mMIv3DACwgKheeUkYWLyJhX6pOGaM=;
 b=UNwePx68Jv0eP9GYnznhbZ0Gnv1lCXnppaANcq8RAoHlAKwxbu5vwXOChkaSTMU6MFIE
 aEnn9L+goWjI202Z06mfdZRakoxdzfAIBCYmlDHyp9XCdcVRQx2Hr9PED2ajRGAWJhco
 61nUMXu9iCBPHJB5m8GoSMhlLl59zouGcWzLx18z1hC29g/09pipnC/jJV2K/oke97c9
 sdHOikoCTkMO0goATYLSltWHROQADt0ud+YXfF4SjB8QVTGBI7ocJC/EFYVyZ4SINLKw
 pLUNuDLXfk7kgzM1pFnRQIFOWlAo4bgykQg71nyWsMMZruH/LAO3wbsx3u8yqW3PCLVe UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nn998r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tXbM017877;
        Sun, 11 Apr 2021 07:55:57 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 37unww7qm8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nz/1Bfx0jJZxSueBdr8m0cM5ScVo1AeIIcZc4/w3YiWiLdYu6WfuVFN0oE67GSdftzl3ZuTU7IZa7nDeIl7O+LkHH6jMtqs69LlF/vACwpGrH6OI705SOsovcycC7e/Yd6oIVl+VSIroJrjS3PEBsUnYX4M1EAX+X/h/KU1OazuiWIc/z/62D0E1QsUdSoIX7/EfQwFYj/XnXaroeRepBZuQTz2kyqCKm2X3Cd0hORoPJMBdxPN6MtJ+EWalAks845WyEj0+AChD7+zO0VL+Q3TMQF1bNOjFh+a7SHp5rOG299px0CmbOlqAkS/RAevdSq83ugg7Y6QmxsrVWHFoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTVY5gwUSmjiV+mMIv3DACwgKheeUkYWLyJhX6pOGaM=;
 b=MstGVmpGG9+q+MQZx+7VkiLTRK6B5ir8ABI9EYpRLP2mwlg6hN2EgWcZya94Uauv0fWBP7Cgey1KKpJAwjJwVABD97iCGwrZxBZglavv1X/BbW1rLmtpqB6cin3bo343bDzSqcfK6jTJNLIE43zMuQwByHbjj/zl+snq4QeyNYvxpgdZeAx45i3Km8d3yvOYiQv9DWwptSRY3KYaY33KVahxHa6udgyniMtr+1sDr44zIDta6nyPjYX0R0q8QcO6N0Ww3DaJwHfcOtIEwB9sYN86sG9ryrJpa7jQj6JzEb6cztvPE592LF3TuvD2aQF37JSWYhIlM8HWeBA+Mkiw0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTVY5gwUSmjiV+mMIv3DACwgKheeUkYWLyJhX6pOGaM=;
 b=efjkrEkaKIstOBBCcFIK88Pafmr2IS8zazjU9TO8rp3OpaUUJPG//h++OTupk/0Igk+Or6OVO0HW2te1rOJm8sjuVLgb3elVtX/QGPggn70IKD7GOuMGByI3gGnkdb8tMUxVHkZ2mzKxy9O95kyh3Dab3iXwanMn0UB2vdxIXxI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Gulam Mohamed <gulam.mohamed@oracle.com>
Subject: [RFC 1/7] scsi: iscsi: fix iscsi cls conn state
Date:   Sun, 11 Apr 2021 02:55:39 -0500
Message-Id: <20210411075545.27866-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
References: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7af89a59-9544-4bb5-ab6b-08d8fcbf3bce
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3842C65CD81AB3553CCAB702F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LuyuhrYW5mmr1KUv2jA4fHZ+TxyymvN1l7mh6r8nJItJLh+UybGl4mFoIT4dTM2x8bJz+UEAlHX7zqz6nDb5YWggSwXrCxqnOm5bvbZ62F1H3TizOco+1qtACcy04pLp1G4sL/b19tP3EypE5bjIMzOFyNmaygBsJgE0L0q4DXnqi/fnngjUpCKBrUxfV6qHSJNJLyVjroOLMtw1uo02FOq/pnDFbsbsXtn40DXzbraCcJW3Ks56tOM8FwQt81qHOiUf75/Qz8/yXwW6n/IbhTfGV4A3fHo8lIggFa9YyJlaS28EX1y3ttK3iahAMFBtsXf+YsDRJnsrvkQsm1iLZh2EsKrvdmdkXAxKAhqwVv5+818pEhgCvAu1k/GwiNXPiOscI91yh6DpdLU62SJ+nCqoZQhos5A1LfRGIicsjCH9hXimg66z/l1kFuI+41Azb4Qja9fEq2gwH6p4pKpDdnPavBY8W4WsQjQPTlNmiFiYvlUMRM+DQzNkNltlEgrclFpqgpA+yoHfKqOjotdpDsdTChM6gBRYDYNa9+bfKUptNrTzZWWexXJDEgJbyo4AWxkbLJzpBexu3Tg690ti5R2XWEL360wHVKQ6/YmFDzIB8YvZT6Rf5MJH3Gi1MVB0pYiAOsiqOTrj/xm71HYIHvT3AkP7tAwsS9+OFayx/gcvYpdGIMMmqotIHNVKRtjR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(54906003)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dvPJtK0dftFo5ylP+Yh3WOK6u1bCKMlkgBf5qI0pUwx6blSSYboY8foeCO6B?=
 =?us-ascii?Q?FH/u/6/mxOV9uDJWfJvtT3rCORue6ZseXQmL+0TM5stnQSK5/2uH3Lnz9Uuv?=
 =?us-ascii?Q?EbkWZbbHte4t7nPO6PZDOtCK0AUCKP/0cMrXqK8vQERy74PX1XJVAo9z91z0?=
 =?us-ascii?Q?In2xcoBvTTy8ePEVqBrlm2tddG9hV7E3oeitzhnnEi+1Xgd/asamMabiNkR7?=
 =?us-ascii?Q?pITPRG9av08h7g4XDCLZIlTc4OIsyOAT2h/4d3y2+zGNkHznr1Swa7x9jv2V?=
 =?us-ascii?Q?MaYzVqBp7iCncMyXpeM1vmkscZJbQKcdFJfW5wOKC0WVFY8ZfF7+DpjIbi7g?=
 =?us-ascii?Q?kJs4BWlHzbeP4palmpj+vwU0R45SNCj3KnAXi/OZYpNECOq0zfH4PWdpXPBo?=
 =?us-ascii?Q?jP+2gEC6FqvMJLca4pbmF2KPEJoReyuyPHsebD9thhxinTLL0eIsGLxkrBSv?=
 =?us-ascii?Q?CAE9Gf0jnuIAh9i668m06IRZ5ecJyCmqIZ9F5JpUsYvZ6YeORa6rtJtaYk2G?=
 =?us-ascii?Q?tGy9vFokSlYz14jlQgZV13xS+PUepEjCgN6AVUg87QOLnHXLpmqVTxO927VU?=
 =?us-ascii?Q?ST/ACV9SFvcRpTsx2yjRJutG8zx5Oh6/FgB6+CYD6CWzKMygsqwgCRm4tSMP?=
 =?us-ascii?Q?8YInAHgNPS4FoV6haz7slpvelpfXB5HdY25SQMz/9w8A3rGIaPBW13h8VkxI?=
 =?us-ascii?Q?cAIarqPaZh3LZ5pYMh4riJDOOEwyB8sCtD1LuGDeRyuT4bPyxTfU7zxGwxdM?=
 =?us-ascii?Q?WHeiOJX+oEh/sJUX2rh4seFTqnDI3En0B/jhVELSiMoDshwX9/fhG2gtHs8Q?=
 =?us-ascii?Q?XZIJ1g72nOx1/xH7vDKLI6A82SVGlIGtMBccOtvaKDdYd4ovNg99GuYwjxmm?=
 =?us-ascii?Q?A1bUh4k1uAH7U3sCNVS9zs6Krk0j98EQFtJGKExBJeAeXrexzXwIpKj0BuUe?=
 =?us-ascii?Q?ADtdTK7g389CEhVSfy3/ZTY2nTUCRaPk5YcjhF42aK6z6FRnB4VNQTKDD6jB?=
 =?us-ascii?Q?ZkTSFqC7M1wvLI1Lf8etns/I6JDt6rvaNJGtiEJCChjNwfkeHwmYt2G77vaj?=
 =?us-ascii?Q?TofcpTNfIrYHzmtwzW4Rpyo3A5gaIwBMvMpM+HbL+UvXeRyUBWl06Zq/f5Be?=
 =?us-ascii?Q?d4k3LZuDMznXdj+si8/YHAE3teyUrcW6xu56yoVMgM2Hp2YiVSamr7lbdkSS?=
 =?us-ascii?Q?z7Xih5U9EbNR+h7OIS443KwVQj783gZ5KzSYrzySlLm1XIq4bqkKHiKVSVhF?=
 =?us-ascii?Q?UOdRZH72y6hWwVrMpszRr7Q/096DU4WBf4L9rjIwXGyRDrwe5DMoC5dl/GXN?=
 =?us-ascii?Q?5bl+spg1CUqtxv/zk4HgG1v5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af89a59-9544-4bb5-ab6b-08d8fcbf3bce
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:54.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7J14/gWtO+67gLgX0wHbAGTr3xLLFOLFelNcXU3Z4HZn/eV0cwXdhjO2RVeyhGW7aXMh86O25ceoFw4BFG4hkMKpboKKsqWzxHFdOmo0fus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-ORIG-GUID: hnD24suPN5caqpMG5QRSWB3d2tNprKYS
X-Proofpoint-GUID: hnD24suPN5caqpMG5QRSWB3d2tNprKYS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login
and sync thread") I missed that libiscsi was now setting the iscsi class
state, and that patch ended up resetting the state during conn stoppage
and using the wrong state value during ep_disconnect. This patch moves
the setting of the class state to the class module and then fixes the two
issues above.

Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and sync thread")
Cc: Gulam Mohamed <gulam.mohamed@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             | 26 +++-----------------------
 drivers/scsi/scsi_transport_iscsi.c | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..4834219497ee 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3179,9 +3179,10 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 	}
 }
 
-static void iscsi_start_session_recovery(struct iscsi_session *session,
-					 struct iscsi_conn *conn, int flag)
+void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
 	int old_stop_stage;
 
 	mutex_lock(&session->eh_mutex);
@@ -3239,27 +3240,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
-
-void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		cls_conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		cls_conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid stop flag %d\n", flag);
-		return;
-	}
-
-	iscsi_start_session_recovery(session, conn, flag);
-}
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4bf62b007a0..441f0152193f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2474,10 +2474,22 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 * it works.
 	 */
 	mutex_lock(&conn_mutex);
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn,
+				      "invalid stop flag %d\n", flag);
+		goto unlock;
+	}
+
 	conn->transport->stop_conn(conn, flag);
-	conn->state = ISCSI_CONN_DOWN;
+unlock:
 	mutex_unlock(&conn_mutex);
-
 }
 
 static void stop_conn_work_fn(struct work_struct *work)
@@ -2968,7 +2980,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_DOWN;
+		conn->state = ISCSI_CONN_FAILED;
 	}
 
 	transport->ep_disconnect(ep);
-- 
2.25.1

