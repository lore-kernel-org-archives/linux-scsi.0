Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92EAC4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE3961205
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhEWR7p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhEWR7j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuCnn181855;
        Sun, 23 May 2021 17:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=8ux4Mx65kd/i1KInSfdt6Xn1YCS/XVlr3/BjEMLV3eA=;
 b=wbXTy+FzmjBn6MCOuNMEHivLk+7oXeG7ah/cvk7jiujCZ6TdogptNs0rPAERxDv0KmCq
 xLJ7bECqoeKeFwkm9Ir81gTkNX8Ph6TOYX1SHXwd+eTDaccOLYTkLPlpXCtQdjbtB7n/
 2Ege/YuT5Hc4qzREsfO/AxJWANb/A1StfIfT6EZJnVJZxezKUNEegy3cujsBKIVf5G3o
 1fF4PR1+WkcfU5hAtXtqBZycDIpycJYMFO7eMM4mYBz/r10nX+Hm8bXzSfGoFUv9YUEi
 yLFFlvgXOcgSXxCTcjK35oMulGtjaA6SbiF1i9Q9D7Qh6IL67Dx7vKJeEsYEYn2EGNta iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8ryy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuctt161854;
        Sun, 23 May 2021 17:58:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 38pss3qbg1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lG7NOIJrBNkOoK892qMWK9bAxbRL7mjPrtoyX/IKbWzwLcXVFz1n6sDUoOMndb/WloD2jRxmgElzI2EZ/uN2sklTYN5dWi+c0w1Z/78DSTjO6IyCDpKARcGndQ2pz9qqr2L6ufCXCoWqhXbru0yVPQK3z/1GCAbc3heWduZchpRRY96sLoNPb5FVrAgwcs64BvHkAMJTcesW8uT26sW+zMcpQOP0nbj0UpBbYxRwfkLBC4trTbuARNRBTW2uzOt0/emqiz2FWK1N3x5WvoAicsSt4+R6ZD7eNtVP+t3F87hFkaD2yuUpSVHdMxU79fbULqFyPX1of9DIK1Rbh+DrwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ux4Mx65kd/i1KInSfdt6Xn1YCS/XVlr3/BjEMLV3eA=;
 b=N3iP76NsPd9efjIGKeHUZ9kc3wr6OuHFXkYtCp2z5YL0PswEkryriuFqN9Lj61QmQUJmy4J3/57GF+yzkBUvtB0f6S4xrRvd7cxp73UfZaOPSICYtbIQpLz9UKu1tqcR7S7ZMPMhnER/1FBhIPpt/tneo81XdpaQFajB9gOB1+s9y8nM/atNTdjkKs6wITkgJNfgnqY2oDJDnyhujANd4NFzKnhkGmCeHkArx6EjBNrSv6IZYJe+2O2++hRa6xdKOwNs76vw94ZRpDjFClF9IzbwGdFJnKEHi86k/BcokINuXPANyGLJQqG3Ux5qvqTGniaIsom40ofKGEv6fkDJnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ux4Mx65kd/i1KInSfdt6Xn1YCS/XVlr3/BjEMLV3eA=;
 b=MbxGBk2kF8yxsSkRG0+bn7ZoLHsqSqehEhUX5rww6jeCJDZWTb2zGWfm612qfjgTw9u0P/lPDonAVfPeUxFOQnwmENnFpoGsypnAXIJ5bFuQrRz2GSGQvm3gg4Neli6q8QXE0m61ucFPC25vj0TeQ/BRCWsmzzvLVu9TMAWi3KM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/28] scsi: iscsi: Get ref to conn during reset handling
Date:   Sun, 23 May 2021 12:57:23 -0500
Message-Id: <20210523175739.360324-13-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0146beb4-8d3c-44da-ccfd-08d91e144eb8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004BF13045A9BEA592B8170F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yn7WpqkuRZb99yTaUbKI2NVexg8TFFxyWvCqZeoAJHJd469cmexSqZEvtp2E00zqPE9rCdb47MXQQkQ4rDB3lv9ik57ei8H3dofHTEIeBlwCysfJC/5r2HvddrUbTCOtVf2oAa8hqOcWnwB3tRHHZ+W5yoofn0+bhrf9odyAeBIE956DAGcZyaXkTQJKJzIEn3SN/gyrySFH7gqkm3E18GhHeKeTKqOYbd10JAtuT+xzTwO+y9H4UTd428kJ0kq8j+MKFTJDTE/y8fnxuJgSZOgFr6zP8Rw1rekpQDsLzP4Bf87hruKJ4MaxhwI4TcfyGuIhUa2NdYnD+cbQ6Sujhvp1vCZix7NAE+2r3YHiQXStu42J92mzm+NfffYHZEkfxR1DO0espaHwjp6Qt0EPqQ2+cRIH2LPqbeoA9OD8wX5sxYXf45fv5Ftv7KKZiHq/BoysuQNQPJV9G/y3YpBQFifo0K/IvUlYOcaH6jq8o90T/sls6J+TSpzLcV7lUmQ1E8w48j6iaSwFE3OP+U8W+m++srdCUUkfF9u1S828w7kHQI+8IbGLVCEt/eXULFpdpngba2NeYx7mhpUTuAtmweloa1jyWGoSuM6uiDKax+gRqGlxttxi9MZB+W5NrX8Pxa4USp8Bd9OskI71Q2+zSG7/3xv8dmTHDDV0XHSMpd3jUL4BVmhpkif/dUjwBbvM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d6Et8YHntJFdbql+kVcIVYgPsKVG6lMi1fOLYgWrVc7eLl1SNGkKuB5woKTG?=
 =?us-ascii?Q?9OlNjaWk8iy4gMd2dsX65YbaHum/KKpizlUxvQ8cq7gwnQfFSs56Fnrppze9?=
 =?us-ascii?Q?vYgblQHKeYj74BYeKL84+Zl/zw5o+MdTrN3ysGxD6bffPZPQo7jVi427Th0e?=
 =?us-ascii?Q?YtJlOc5mxy5AFXuLyPUnXuRxsjRGIW7JY+v0FKNl+bW2puCQGoCbCZe+f0Kl?=
 =?us-ascii?Q?bUJ0+XKDzhpZ2aaGZOHzISslipEb4aSNxIODRprFw5G8GVtU9VnAU2w/e/JH?=
 =?us-ascii?Q?8x4U9DhFcDwG9AdgC+KZzlX56Vwef3EHIbe0LUcqyqO2rOJLEr9GkoFZmAnz?=
 =?us-ascii?Q?/gTsfLjKdy3qqSpVYloMnvApYj3QHfT7JkSnaDi2IEyE6TXC9QaxW3BPYIyr?=
 =?us-ascii?Q?OBbBUyYtDDX7KYdxzYaBqJtEQeBlaK0xJFZ0P1YOEfqHq670xDEUG/mCVcSU?=
 =?us-ascii?Q?4uBWX4bfqtSs0Aiffc8tkYoFmUYo6NW9zAejXS1+kxTxJx2hDj5JcZuZdv46?=
 =?us-ascii?Q?AiAOSvSwbokzqhx/XEymWKNK7+LY3vCfujnrZH35JMNS5txKZUbnTr0BW2Aj?=
 =?us-ascii?Q?7ZBn+ArqkuHrJwZImxE+eYuee3W8oEeZk8FftZBKrHpk96ZR7gLet9BBaEib?=
 =?us-ascii?Q?uQ08/axtqbcb8dcMSvWsQ26B7gFBVXj7Y0k/chwHDAiAE3n8Nf1ptWySSUt9?=
 =?us-ascii?Q?uipQnql6ilE9SKJvYEOqNIiQwznv8K4dH3R11tyUhldiBDDeed2mTeF3Zq1S?=
 =?us-ascii?Q?YiPORk6doyku/YmN2cS0FqIPLstM/uOC/xIv6aJNs1HYB/ec+iKLjuRYqL7d?=
 =?us-ascii?Q?DrGKiBN/D05i0guGY9W2lhh1ChVttDP++/dVFyasogXuu2SGix/T+kxWR7NA?=
 =?us-ascii?Q?W5YwN9WODj/Xx9cdJvZuHViW6N4MTJBhAYMVz8cshHwo+3fS2kwSbEizcZY8?=
 =?us-ascii?Q?z/9IA6CmrSb8dKxVjsdM+rV7ftOZ+NI5KZ6Fxxb9MfJoL/y7Kx6JRnR4AhSI?=
 =?us-ascii?Q?syz4n8tA9M5TO0H6hsGc/3Gy3+TagWt7k60tmlu4Lnbtgnzc4WM3sDDe7M8N?=
 =?us-ascii?Q?Pk/HZ3+iUtnqDS3ovFU47fgZADgzSbT9feHyp3FvyJnj57tYn3uqr0bBeVSN?=
 =?us-ascii?Q?KOesDvWvqhKz25bNGh85iAzDvp81J/KdFJ+gi61ln62Q6GpaYjcyhVzNUatX?=
 =?us-ascii?Q?zrFq7jj5ET2J3x0oo9nvBMqfFavDz+H0FCoZwFMeQ95De//FlYHEYZ6FyWAD?=
 =?us-ascii?Q?RHOUd5TfjgTOZRHGt2uUq3wRLVNB7iN18lagc1l4LE2y1l/wH8ZOymY/wSau?=
 =?us-ascii?Q?P1KraGL/ahDlGMWPcJS43XlC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0146beb4-8d3c-44da-ccfd-08d91e144eb8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:02.0068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0opX6S7scZobGSJxHO2ydn4BfSDSH1kvVo5uOW5XmF+YO+r6PEI06HZ7SlI+PHupdP+2Jlx2P5LDVG63AgRtcupJZiMkepzuh+NPFYg+eaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: Kp7qyCJqsC6KTm1ux1F9wrQrCNLKHkam
X-Proofpoint-ORIG-GUID: Kp7qyCJqsC6KTm1ux1F9wrQrCNLKHkam
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The comment in iscsi_eh_session_reset is wrong and we don't wait for the
EH to complete before tearing down the conn. This has us get a ref to the
conn when we are not holding the eh_mutex/frwd_lock so it does not get
freed from under us.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6ca3d35a3d11..b7445d9e99d6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2492,7 +2492,6 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	conn = session->leadconn;
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2507,13 +2506,14 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
+	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
+
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
-	/*
-	 * we drop the lock here but the leadconn cannot be destoyed while
-	 * we are in the scsi eh
-	 */
+
 	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
+	iscsi_put_conn(conn->cls_conn);
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
-- 
2.25.1

