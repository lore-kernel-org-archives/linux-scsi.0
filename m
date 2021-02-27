Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47726C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D9364E85
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhB0RLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:11:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhB0REG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGwf3a165579;
        Sat, 27 Feb 2021 17:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=L8jb+INnEUQEiy/B8Eqtle7rIMwmuTWECirmOBwbGy/dOS58yC8vX4zmcgTBzQzZ83+u
 SF65oZ7/VpPOQL2LqZ6VrMpfJK40rnWoP+HM1f0GIJNiT4wf9yD9bKcj4q6KIphLwiRa
 kMnzQVQExxBdXisQV+MtXtFjYfT/8m86Im7rN4VXvFNlRzcXNL9xivQhVkUGVUB9zX/B
 +JdKCE5QZiVzqnLdV9lB3BXQe4m+zSyiTIM55Pjtdey+W81RhpuyvPFdhLOyI3elzFEh
 7T2IYevxuzZrcovF0GxR9UbwzzCNMg4xUB/hWUmQsHHbaTNSL5IJBmjMVlS3fLNXC775 Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36yeqmrpsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmf115709;
        Sat, 27 Feb 2021 17:00:25 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X88r/UGmM+e+jdWYSpyoUIJJVsbcnsddsH3C3hWXaD/+rwqy8hKR5ydN401xZ/NoyTgtIkKqLYMZZV76OvrAIoRSOkioSAwmoOr5G8H/nULXGtZ+VocpbdOeUQ9lfXMaGC08yzpwFvWQf0oFX4heN0925wkLGLjwRAB84FWhN5MyvTiQgVajMY1KvimtqJe1AK2TNFEwSQ6UvauMjAd948WdMH5P4nSWqd4PZU0Py3f4n/HLhDv3aKd1JHpZbJxzBLyTdpnHEFPSwqKkLzaeZAW0Z/VudX3x2oteht6HOsWidPUjhb03Rvjdfrhcu3Ob7zleSlCkbq+9f8zvCHdcEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=IMoCIuGeBntA60N3mRGU+FjCePCyCf2Gzvon4g7gUHOIps7StTs8aKw6sP7y9K2eHantkVJqVHSR7vrPPbuWDMIrnj58mNm/f7f1UxNfHamGCvm7t+5FVEW52cUtZ3n3mQ7IJnarc/RNJr7F09ck9O2XCF/2f8xa0k69wp8fhCqVo4lLkokxvVwvMxpk7XHuzSljOrka8s8ZbazHb28eCZUKM4n3GeZmWiLqqSgzg3hzKYYX9LObB4e0s2NYzn/7UQbprKvCi/DhCQg3Cr0xfn6FwTv8iQGTmPc83eGMTDDjqH3IMdlDR2+NRgQKObL+SSaYBQAvUZJoy8lOu2eQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=p9D6x6gNbbS8BvJZ8+EoN7rFogQsZJFAEcV5WKIw10GE7Kr3P1Cx7+PAys0q0zon2DBYkIP0kziZjdhYdathJYXn8JEshba/ok2tXEw3pF4Jo8soJo1G55y7Gft8CSaOwqxFbbDWPbHUj17LbkN02wlglP4IoQQ/YWvMNBYVSEQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:23 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 09/25] sbp_target: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:50 -0600
Message-Id: <20210227170006.5077-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4236886b-f775-4b2d-fc11-08d8db412c30
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499AE7F19D4A8F3DA54A609F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxTYCKAGA0fvvBQ6ZtaiqglZt38Tu9pBXMkmfVWquBIznT8RWYh3mioMwxcOp4TiAwMj3jrOcgTrsopxPzV4AsZx1NNdiyq6QMX6d2XLTTNAeaxeZ9Pr5+aiZSt0hB2vFWkMCkyCmd/UQ+0+fJJwXrFEpIDPiEaJG8jbiOjipRdoPfYZ0+/nw8D7K+B040fc9BWU4rxyc5gQYRnf2XEtY3BuMpeUndmiklhsccIS7NBBmO48q5RELZ0AjRfmX4T2LUoXjCS73YemzGodJF0Hpf1gbs3wDAPzQFGU5gcMkbkNTfj9bGvA7b3UYHsFzm3shCqC/TdikDh+cJMKMHUjX5m7h8rs9eBc2vKFGwAzY63Al/z0yGSMggbaRAc0310FgIoO6AQ9Fjw2YEK3yLYc+pA8ACa9DnE+cWurvflYxr3KcUEfBKNUBov8NLi3+xGWx9ZedSh2UFt94Psw7OooCrCe8nfIgH/vSBg9nIdgU6njps9ntngfhGrRGWWBujMaUCa7usknnIcNJveuqb0XW74GxnCq5paRe4xKc5K1tJlbW69DxDxwJxbO5N+dsdOkYK9ikU29hlV8zk29bE/rmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W9p1wKEQff3K8AeGHCMOO1KC8KVbrJlfe73spHy8jhlhoXhyj52hY1LafLVf?=
 =?us-ascii?Q?kg1s08kXZrk03MsZSzeQazTnFWyzMKesA7GDzY43sjXyNUv2ecDIrWW9nqpM?=
 =?us-ascii?Q?IWXYTLtTx7rBuzNR1RgFlZxFzJzFwGAnf/0lbQnFzZoU5NVj51LMIU3R9yCU?=
 =?us-ascii?Q?MOatIdTpI1mBwAxv8kDHsvUTrpTzvgUfLXoid+pIG49X1XoaPIie1+aEuMr5?=
 =?us-ascii?Q?xXOU8GBWnu93jqT7Vby16FT4OcHKGk4puN0EBsCKLG6YrRvyHgL5u4vNSby0?=
 =?us-ascii?Q?73OjSkw8kgThJLjZZ4DZmL9I0NpYrqCWfQXwI1j/1aXhmHXQsnYhx5axUn1R?=
 =?us-ascii?Q?xSbKchbm+06ICpdhvX8PDeneViQo+5Pt0Kj1TYq9dK65E4ZRIBG1kDKXtmPR?=
 =?us-ascii?Q?wn6avJEpgVX+WgkOGaKfAU7EgAsgm3UgUR6PmpWb0i0HEm8JOGbM76OkV0GM?=
 =?us-ascii?Q?w6BQlxPn3wp/DjVFtzhc7a4bvmIG5XjI3iigzKgiW/auqJVNg+LGGz0zLmUa?=
 =?us-ascii?Q?zZFC93FbMxrc4ySbIYE/ACiT1gnFG9p8R2oHjjd9/LhM76yNO1Lo6ujjLd9+?=
 =?us-ascii?Q?yXBPjZrCpCfSJQ5ZblQa5whq6dElYfv3nVLB7uU3Zlf1Qx+bp+KpQlX1dDPl?=
 =?us-ascii?Q?BGTfHiuMB8hEAe+T3rKR2wjuYWIqwA2guN6Nl9COwBsBSLNNn/wIWBtLG62B?=
 =?us-ascii?Q?6OuQHeT5VKtQj7+KMC3wfs6N7sEZUMZ2zx/+9BYfHYnTiid8u4Cm/9Ej4+eo?=
 =?us-ascii?Q?qZpK9XIkT08OmUrHx9WszkCdKP2ahc5omFuiaGOaoIYuWzx2ubCze0V3L7ji?=
 =?us-ascii?Q?UqTw9z77I0h6cgm1OhSf1vF9zpH+rQFwimTsTzzn7S+E0ZymIXD8jfA4Cm2d?=
 =?us-ascii?Q?jyt7Tn+RIKPtxBEPfQXV6C4suUGLhWY9mvyclRsP9rfbAJYIM0u2S2BOeicW?=
 =?us-ascii?Q?ldxzPaNs7jIG/zcjKrPZeaFkT6SSNGCwDaJW1GTfppaFGVYp5WkDaH+gFfAp?=
 =?us-ascii?Q?bK3JeIgfUHIUHqpca1vPhZ/Zogi9CHI9EwqXDwIDp0YHun6FpNuX8gbKG76V?=
 =?us-ascii?Q?LHribAeMmwFk2q9M4UHI7O4F+O1iKdqA9vxOk+CjCJ6fu+32paJpL7rojQ4C?=
 =?us-ascii?Q?69+XlbDum871IdjPkdWQInxAvwrB3yntnZ1JLb10232LX5BnCuBpULVUXzE6?=
 =?us-ascii?Q?mLcfmoCZ05zDPRSS4daB2zOOigswkJ82HsZYStFCdhpbH0/K7SAf+oQCz1R8?=
 =?us-ascii?Q?kEe5kgtU5b8KIsyaiacvX1dgdmoYUCQYNe/YQUTNAl5KTJ55UTn1uXp44Qct?=
 =?us-ascii?Q?tj/DqSzWwc+QjNGwoxzUr+OW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4236886b-f775-4b2d-fc11-08d8db412c30
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:23.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZ1nZncLXb56mdEci97T/2HwV0ASNwArGgVN+xIVj0ib//UescKaAYNUtH6zobzZ9YCViCmi9ONP5fjyLVSez9ZAoO+6tAALwLNgFPKwPL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Chris Boot <bootc@bootc.net>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

