Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EFDC433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136BB64E92
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBGEra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:47:30 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38672 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhBGEr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174kX4N168289;
        Sun, 7 Feb 2021 04:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pX36xKTyjoZmT8eSx91b73yb4X8qpqrQqg/v2v51m1w=;
 b=YnGQyEDKcq6KX78hwh078+NvFA+9B3O4bqspX0QIZAJ/Q4HR0ncVDsTF75u4RfyGqA4u
 +OLcrEPwj6exbTGC01BAnkYWbrdC2ZLmGUm0cq03M72qEEl05S7e+1BrTBdxDsUtoBXs
 HBFXltbqTyEXYK6AzEXRX4VJnhbQJl1HZzj/cCgXsA/n0lfSvrN5AqVc17qznMirKUNF
 dp59uJEs++n31fC99wz0tNHiRHFgtYEgC84f0j77JpExMAK8NbIMJoBjQI/99aEJ/WRt
 E7aiahnH4/asOFfYI/sJb+wKhi9+7R1CUfcMHPMPbpUDQK1uWyrZaK3DG3NuWNazbfWa jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgma9fp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174inaN004118;
        Sun, 7 Feb 2021 04:46:32 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by userp3030.oracle.com with ESMTP id 36j51tcp26-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKZy+/HQIRisQyLTnxcBj0S7n4IdFK1Of5xdx95e++6PZpDhbhgc6e8bnfLEUjuJY9zqs+ES1Pe6o9i1TX+GYCJAwJNbs+062jnypkUCDILlniVQbaM74dDKRYujxbj9gp+0j+e+U1plqmVX5YsylpErEnCqyQC3DFUPiAtOemXeu+MvuKVsvU3XtgJP6O5MX06DDIWsv9TPztegUCeB8iR/qJkmVhRvdIi3stEY293vK3RE2gL0lmhkRBwd0wCtFAvoaVu0YAkd1b/PWEXXZxScfi26bJ4NgdiLsV2hFMiY3xsujjKDyWMBwiSgzDwZU3urY0HgGO0+qpnymHw9zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX36xKTyjoZmT8eSx91b73yb4X8qpqrQqg/v2v51m1w=;
 b=DiZiLzjUV5GCjxO1DVfVeyRM3ZkiOi5vMAMcEgQIynUNLQKpWSWAk9fiKMC3SfJEjFEPTomZsBtpZ9zkKOIqmR8R0FyaL4nDTez4+8sqe1TvtNPmlwg6AiPEV3peGJuxznE9Iq8D9jEOjBn74HJzfW1DkvVI0KlxcGQFsP7wYzTgWhP5wH5qVIofnGilwLzE5j2ILP4R3qnUQ56st1M/vkNVyZ7TAerRM3USigbH6wQ84eZ6pLRRINHDJ5HrWQH6J2aMvb8TuFeWBo2jse9G73QA1DMBOuFXZYYRjbyVQuzS6LcRaTyUjBhJaQsYtWSnIhSz+NtLY0+7EqBKqCNQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX36xKTyjoZmT8eSx91b73yb4X8qpqrQqg/v2v51m1w=;
 b=N+MitAocDnJApvDFM19LrOXVoMe9cGCwrnmX840QAr9wxsG0FzD4btESGcT6JwX+R2+6kZyAEfalknZMOzWMejnORlRAEuu3z1l9LBAimtOqj3q6c+nwuGBP3J4Kph+XJIBIxDDQ0DzgFszvFBwIRuTvmCeJDzJt+IAqUOAjuQY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/9] libiscsi: reset max/exp cmdsn during recovery
Date:   Sat,  6 Feb 2021 22:46:06 -0600
Message-Id: <20210207044608.27585-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60d523e2-26fb-42da-1b45-08d8cb23564e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3429E96DF1DADEB711A455B0F1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01LnFysvt7TxUOVOZ5rtP4Qf18oIs9uCd6AuNxBGacVMy2qNFxaBWF+55A7ynRD7jE8tRqQBo3uOxIh0J/hJuOigNokv6dN/pAJn+RZKXJSt1VtmglPVeO23D5kVE0Zju6ax9maqQM6K23Kbq7vyX8W4TYyTWlbwoEPH84mN7QX/ggWGj1J8XOPFHNEnik0sHXswlcsuc2KW+OFLJVLhrTsJXfmJvLpzPe0y+4XiUN1zjEE9zeIUc0mWFTotpLXEvosiFWcj5HbuMTkJxxgt2ksoBqt9TtFIMUsGt8Ren9fAhGP4HYfBXmsYFVSriEZxmNkHiwYUs1PgHx8xitoD7aCDMQBb4kNeGbjT4dn5MtiTn6Jwog8/Oep2sWbgNpf2TNloHCG08HUE0IU7I8j691LhxW9wGKfw0bCP/Boj0cW73ml2mB1Hyo6/Zsuzrn7s6VL/jUQ2t4fQxIDkswEmkNP+Jlu00RKtb+1CnGgEsrGQbjoIcM4bPjtCN4Z0wZnt7HvTAJWR91+rin6l3smOer34P3RUEVi3DUtgoZkt2Ef/giQB4f4FaFuil6yOGkTeAw9BbbTov5MFFX2EIqScbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(107886003)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GFvN9DXH612LZq3SOv+JuJ81eeNjl1ANlOE5ey528+SbKUO96aSH8XXFI9+R?=
 =?us-ascii?Q?mC5uDGBWZ9v24tE55qumX33ydeXlj2cJbBrTubpdQVOqWD9M8sEnzHItWOsM?=
 =?us-ascii?Q?CZ86DVGOzDXAShgsd08ZxfOTCFuaER2kHTrSzGxsaIkymcZUzn9oo7OuqqDj?=
 =?us-ascii?Q?nYvTxNiQN6WxNqy5kR04WSJHR7mNhY98EGZ6ZHElRog+TnVvSeRXwfp9LXUG?=
 =?us-ascii?Q?Oa6EVbMm1f1MkkE5K53AfcTpQcEvf05fSBJQEmTTWPY3YHdKPOxCXfxmrR5W?=
 =?us-ascii?Q?P5A0B31nFkA1z++EihCmMkI5QSHtZI8nRQTax9uB7eYBOvDvqlM8z2as731y?=
 =?us-ascii?Q?K/aUdqOMgqfk7VvULkMeQcRlxOYE8ZgQ1Bv43HaWnkkGiU1250VyTrKaBBWn?=
 =?us-ascii?Q?FN5JdR8sBS6T73DQ9Y0boQvkRXkiKDZ3bYadkP8i0Cfb5rT3ogejzYSwJiTw?=
 =?us-ascii?Q?ffx0+EXUFJfm+YgBWIAT4rXHewjfIXzxbdRSC3AJPfzq8SRSfZ6Qd/f8U1QW?=
 =?us-ascii?Q?SuufOCXP7zmAxF6JZ9gk8AA5w4/HNAYkze8vJNhOMsRui0Ce829iyL27PwuX?=
 =?us-ascii?Q?wL1SUO5duOeP4dTNqK7uoFx0zVPjRlPa0xS5MZ+Ba23sX4OdwVhNIi9jL4GA?=
 =?us-ascii?Q?8tYD/nF27re+oZq2I/BRN1r60jdW0I9aOct9IPBognW6OtNs+YakLbQottvz?=
 =?us-ascii?Q?NjGYcYlo0b0eWEhrguhRqVFmEp95fMB2WCk7q91zWQGD4bJfv6z46H1KpBD8?=
 =?us-ascii?Q?VYPFXe8pCxSHJWbDHrlgrCrCPjABuZXjcTNdGCN6mzrHqawqftQSe9mzNE73?=
 =?us-ascii?Q?pzX176cawFDUaiZXYNMZCfaju1jWnV4chB3QfDL9Y//z3J6sajkx/BwJkg04?=
 =?us-ascii?Q?kcR/aKj6SdIQ7ACow9kp+8fB0oAA6bivvZPaaINb3KIU5GD/0+/9MOpFMuyK?=
 =?us-ascii?Q?IC0nfRPW5IZ0N3ih8lCzvrpCSxIdLQMEBGEfybZcYKk8sTo9dUv/7cdBpb/M?=
 =?us-ascii?Q?NlD/9xbBXhBP3brgFiPE65rcALJx5TlVBhrUovzB6GHwbETnia+eOo4yeekO?=
 =?us-ascii?Q?8ZDIqQZY48Clh+xEQO1lx9SVmgAUkoDbxp7Mi+8ieIwfjhjSG/50J4YVAUdW?=
 =?us-ascii?Q?+/hNM4UhVTFHfqXvHSekntVGD7BBp5o+m37vayGDYQcrSNsi/c5qaxI6WEjV?=
 =?us-ascii?Q?OC1bk+ENMPRDicWDerjU3j5rGHMqKHj0SqqsLtgHgRUwC4zDEDArv2ElTCgM?=
 =?us-ascii?Q?luIN0z+W6cpF3DhOIBsnsC0EwOIH+A90kMct9Yhcs4GK1bWUbg0gfb39eKw5?=
 =?us-ascii?Q?WXin//1DZzTNwx3alPUYsaR/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d523e2-26fb-42da-1b45-08d8cb23564e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:30.7217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FVl69o1CuH5RATO2rpSi/ZXcokQTqKjgzVKyAeOLmC5/1jkz52mWWb2T13/3bpVGacVqM+CQC2n/5pFASK7mLOy6u3Pw6hmkxNg+nN1Yuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we lose the session then relogin, but the new cmdsn window has
shrunk (due to something like an admin changing a setting) we will
have the old exp/max_cmdsn values and will never be able to update
them. For example, max_cmdsn would be 64, but if on the target the
user set the window to be smaller then the target could try to return
the max_cmdsn as 32. We will see that new max_cmdsn in the rsp but
because it's lower than the old max_cmdsn when the window was larger
we will not update it.

So this patch has us reset the windown values during session
cleanup so they can be updated after a new login.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f64e2077754c..7ad11e42306d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3273,6 +3273,13 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		session->leadconn = conn;
 	spin_unlock_bh(&session->frwd_lock);
 
+	/*
+	 * The target could have reduced it's window size between logins, so
+	 * we have to reset max/exp cmdsn so we can see the new values.
+	 */
+	spin_lock_bh(&session->back_lock);
+	session->max_cmdsn = session->exp_cmdsn = session->cmdsn + 1;
+	spin_unlock_bh(&session->back_lock);
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-- 
2.25.1

