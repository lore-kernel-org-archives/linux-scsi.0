Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E01C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139BA64E2E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBKMfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:35:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhBKMam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:30:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCOSvA139843;
        Thu, 11 Feb 2021 12:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=o6Hv2gBirkeYKVwgzTvTppNqSRlSbrrnR80U5rxBOBw=;
 b=gnG3SIqts091n6Bxnq7HEOJrioacq6svALjFG26Y5REOcjJ02502SoUIgLB3X/vEpUBc
 T34kbKDmzrK4lD1dP1i4JGEufvWpusZo1JrDd6YdmADVYiO/x8v0cb7OCXZ/PAfU6oNB
 25VuPs69YY1A6YDmPry9snFjGQ814++4cu1p3L7Gz4+f76SxF4MzREi4SPzBnfybVhPD
 11KSxCRt6ygFhrI31kASXe+dODwZ/kRbu8qFXEO2aZD8fYc4xEb/Fojny71ELKj70Q+v
 GEJ4noFYVcCooOnImDEZCrQx6JZzE3HNpIWaJ5fv7wkRyvwTb5ve8IvMlFEnxczNBD3C zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrn76f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ4nH193915;
        Thu, 11 Feb 2021 12:27:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 36j4prg58e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ5n27nkSSnr7auILVMKKsnsiRayR4BJqgYpDusYntio6mHgOVA4Mdk2rM4xA+7js5UXWxi1mNRMUbLEWWwYhcI7K52E8aCIxdbNbofiCQoLSklc6OV5XEaruJv8n60sBTBQt4VRO4XX6+wuSbO6yC2pcSf4EHUoro4VyqSKSqOG9q1GGa3Af9hSybttOJOM2ow3esagj5Qj0zDUTJ64GnMw6+UH1GxndX1mhUlSnlHefpOeE1+AEjXIx/l3Az5pG9YfVHYl3e0x2VDmIfCmi1YrFj293RCHX3Cc44H4y2FNCjZA16leM9YJfJyc0X02kRypv0lVVfbHC/Y/nQniTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6Hv2gBirkeYKVwgzTvTppNqSRlSbrrnR80U5rxBOBw=;
 b=WF9AH1o3w+K9aI8m2MaP6b05Q3e2ih1r5L618m/oFXsXOQjHg/F4Xnr3vilQnlH2u1xzW7U/km8i7tAXOtdsHfR8Zejx5Gq0v6C1rVXCt9QUTlELsJ3E59jBju9ao+oSGZ/TxWQ0ljhb2LwZbgEnnD882HHH4CYitWpyZ5UuDstdwZFQNL7IOMBEKuU6QMyqOOUnnp4JIAopa8lfi6crvJ3z//6n6Jznz9xKCGL+uREGRk9UrVt6QAAt2djrPwAVwqhtzerYHx62NNqp7gruOXu7QIWCHonVmTXUkWt5Pdedi23r6Fr0bcr9jSia5341wN72gm3dlNa3ggodW84vNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6Hv2gBirkeYKVwgzTvTppNqSRlSbrrnR80U5rxBOBw=;
 b=y2i1FiICKNcQZVIvWWBRybuFjLj6ODoAex2HHngq3oXfNBlrwF8oBGqybSL1ZasPt1XAsCPO/wn8V14ZwDsRQN6Bv5zszne/Tu/NGlEPKLAvVY0TmE84uGbNfXueNfT9frvZzXHscSYeDYQquYxMPrZ48RAJKI8ezHmpFkcbbnQ=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 09/14] sbp_target: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:23 -0600
Message-Id: <20210211122728.31721-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f64c7ec-f532-4301-04d9-08d8ce8871ac
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339E9A934310F5E058BB682F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TrIdeI75KYrYCKUbpT/R3UvpDON7UUGCRBi5qW9+YHBMVX5U5PYq50IJnPCGrYMIrJkG3oR82MA+fLo7YY8wCiFS5cafJisoRwuM19Soq3OdxWhNV4yZOXWnSgxnPd5msfRZSwECCtAZpR+aFzF6Q9mx0bu8LTrZ/0VlLjv6vvDxyWxORXGeuwG5KkQua2utzwZ+UW7T6uUoT072TcX0Pa9a24Nan+0MowgMx5dnKPs+C+sGEETJ6oN1CLLDXNKC16yiqDqgawJEF/2cVrHjpkWu5h+uw0ycPZ3i3KOGPJ/tZv9qsKnXjlIMwSc1fkiMRXQ26tyV8s75eqtw2v/7dvWqkf/lHDwciAk4XEWBxme5nzN8BXgs2taM2C5OzC9vXlBcUKX08SyrZBrQECv2IiD3kR5jHlAMJMVrz5sc8VtqG2kimTB/7qsNdB8gdwP1HWQ8Ck9Qy+TG974danzNSbCBofIPIGRkB2/LsWuVKQdt8DuJkP2lRi4xrDIG5OhIs/P5dB2uQ2qMgs7s3EhiACw8hiQn4q3vgnBcKvMOHIEesSnqPWfkW55y/8FgIUOS/BNRQcJhBrXMhfobczEDMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(54906003)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ks/+Fm0Zq5GsVpksZoCF9p3EGvvLjilxWei/vu1Kk2HcUCCC2vBd1vGQ8MYh?=
 =?us-ascii?Q?rSAX5dP8/7UlqCn2Wjxb6ST4sHj9Xcuribos54nDUQztn93XaoSrszNyj2oE?=
 =?us-ascii?Q?7hB8LU8cegESF4fV9YNWb52tNvrEyFyZLaoR6WWSx5y/hXWQaDem/Vbm2MKy?=
 =?us-ascii?Q?bs4GlSsEvfm+hBpjg4I0mQRu42nspavQbsOysk6735J3lBOtqtBhcaaZMei4?=
 =?us-ascii?Q?9wfnqrdZRLGcGyfyKZu8sE9V5n5CqQajkrexPFGhnrs4zYGrqPBjFegIJYdh?=
 =?us-ascii?Q?NKR/1AcXkr++Ggnbxqhur2aYM0c8D6ZaDR8KBrRsdwdmky71x0bhph2jReu1?=
 =?us-ascii?Q?JxEQd3LkmS4JcelBPgOIy+288e1XzlSjsVfMsY5kn0G+iUNx1XIO/fW0C70l?=
 =?us-ascii?Q?WOMjgS6PNG3pilrDcRyCphMMGj3CkJ9w9seElj4RaCLQxHpnTDUnZv2nlN9I?=
 =?us-ascii?Q?7q3Vo1zvSzVVMUmEcC5oHrxK5+T+e4db4buhDU10ic3zv9oJ2YPyeFpPcNgH?=
 =?us-ascii?Q?0s2e/I8aaHhGvillY5dw1DgrcHYHv1tZ8HleEySMArY3DMvoYbm7Dx1VdwHX?=
 =?us-ascii?Q?wS1sw3fQfNTF0/jYCH6hRfMT8e6DiZXuqzKVql3neGTcDRKyzsGSLQ5TaSoT?=
 =?us-ascii?Q?Z5Xm8zZDaBHPM7+O/+U/Xnne4+3s1OaavumBRupUq0HAeufCJrlQn5Sl5OIe?=
 =?us-ascii?Q?bFepaYUGN517F27ebfkvisIXAfF61HYm2+rOZZeI4kC5CfNZNnhfSXsXcD8p?=
 =?us-ascii?Q?vDHsbaumCqUCrPs5M+iXmL0TZTgrg9RMZs1gv3hUx2fcwdvzg0LrI64nMymW?=
 =?us-ascii?Q?ai45NTr59O6IA7kygaETCIjc9n7bByrjbh3ib5oJJB1GC6TkHR6Sms3HPfzp?=
 =?us-ascii?Q?wIV/JQBPZoYsWGfgBydsa0UT8LgfiaTCAaxhEAlXviyOmeb7QpK2QAwjMn5X?=
 =?us-ascii?Q?ioM9tV/8JV5//8v9Ui9xgzbpsaQ2VEj6UxPWbxufRdUu+++mF5ms1cHenK+w?=
 =?us-ascii?Q?1n3dFbRVhcSmAlzBRcVm6yV77yiRQsBQKPfX5RIHzqhEpPTJsWmAmc/Ra8GW?=
 =?us-ascii?Q?HplT+bR3Kj+16imnUA0oDTLuN8iQzE3Toy82Vp+ePDq7YZlkysMKTODKk+Me?=
 =?us-ascii?Q?hfDZ5eKdmxpfwGVM4JdJBiNBRin2Ne6SrRM2ZmhRBRGc4glg9dUI8PgNyTI1?=
 =?us-ascii?Q?P77bqE5/aBa0iKfrSAVNTA5LnA0im93ggeMCD+rOYY6U6DSpFIw1g6IZDiEF?=
 =?us-ascii?Q?pPx78UVd5rAnYnGACQsI1p+gqT8tmcFzNW+yoGhk92hnaKcAhpxUu/6bAuka?=
 =?us-ascii?Q?3CjIeMLzr8fgW0k3REO6gcgd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f64c7ec-f532-4301-04d9-08d8ce8871ac
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:49.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BQ+Ng0DIlA40BYxw1hYfPljUwLKLAswpjjhbcUb4t1MmspfXhQ0H45zVMBynLsUJkWuBEB970T+L/TiMYu3BrzYxo2ostiRsd417keWau+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Chris Boot <bootc@bootc.net>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/sbp/sbp_target.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9fe3dfb..f467c50aee08 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1218,11 +1218,9 @@ static void sbp_handle_command(struct sbp_target_request *req)
 
 	/* only used for printk until we do TMRs */
 	req->se_cmd.tag = req->orb_pointer;
-	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
-			      req->sense_buf, unpacked_lun, data_length,
-			      TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF))
-		goto err;
-
+	target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
+			  req->sense_buf, unpacked_lun, data_length,
+			  TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF);
 	return;
 
 err:
-- 
2.25.1

