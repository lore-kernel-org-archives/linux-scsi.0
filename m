Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFC0C433E6
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311AD64EA0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBGErp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:47:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBGEr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174iOOA107572;
        Sun, 7 Feb 2021 04:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=eLvjdxoSH/zTAbl4x6JLodnVmaUEkNxPVYI0EocdgXY=;
 b=Fh4mBejevCUHQK0meR5dWK+TRPDfbUxjJsALLqC27XQVclbmdBAixPiC0Klu6zf9/pQT
 HLyynIOmNWtHJUj2Gzo6TJKm2p0ztRpccUOPkH18nRDP9zGGAKP4v9JzjsEYcccZZ82X
 gWO+27wtflNyovvFdalIlW9OQtSSeKxE9QHfJkh38V/XfyFmQYnRCLeoD4O0QXr2SmOf
 xkRvg6ESipSIEVyccejtNfVchMZLkXbvcUUSPzE6+BVZE8cALbHMFV9u//fi3zKCgkOa
 UcRo6sD70jRPX1KqPloedlY9vNuNMFCZtqSAoS9BWlKIqUi2ChCoVWD8v5jAXWW/qf4j Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqhbt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174ixmj004585;
        Sun, 7 Feb 2021 04:46:28 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2057.outbound.protection.outlook.com [104.47.38.57])
        by userp3030.oracle.com with ESMTP id 36j51tcnyt-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0NaQ6l2N2vMXjilxiHPnzAmDe/hZwuSATrI/KwZqeGyqIjN4u0R1YjubPpNOa4Xq+EfDPkM8hQsZcgjgNvNCLqa+xwI3svKemmnfH6XRFm+A97cspKWe/5BC3UDZAKLZnbn86JH7U+/edpwm+sBMQp1NLJ0JYHxZZfqUHUj9J447l8CABopsW2/IYXuGXouIFvI7TQxVMSEWKrt8Fbc/7CWUYrg7xmC+18WqH+YhnyA6u06x8mjjVFetPwSYJzQLPaXtgDJ7xQRfBVCuKS2AMNx4Sfl1jBUknPp1k/SWFilgzcoHkqFTi4uPjGg0uZlCxr39RVPFdpJmCTYSTkzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLvjdxoSH/zTAbl4x6JLodnVmaUEkNxPVYI0EocdgXY=;
 b=WK0naZXCnpKPCS2z/72nv+j0Q48pWgfZpE1fztlt65pBFW8oAdS0vzY67mu6kEUZxgUClw0cowZ/VmVl2cz40l6U9QzzK0dCj9jEMoBFSYaao0FlJgar07H3NyW3HHKvx6ZNTuQDx2ftatFFk6iaDGdLIhRuC7Do7QFNCPqnut8SJxuTHexaE+NCIqXU4O7a7VKKaGQnFgeaQKn/h8Sc9iaDMR32HZChO2iDvsEFGMDzoq3Cf9U/NUtHUdOhQgqqWzM5RdrQLWgzW8VVK9sDT76SFn9EOzNeZmwHay8Ss4/Ic4XAud9mDV9xBZUkiEurzCtcZcC6WcFDnoTtN2N8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLvjdxoSH/zTAbl4x6JLodnVmaUEkNxPVYI0EocdgXY=;
 b=TNtV1QiNs6Z8ujL5BF8pBHJmC1yisMmmN2CJKKkMbMoIW+sv9ABkoXWxXq+rIJMBVugEzuPRLUPP1K2Z1uyJh/8ZNn7oO5U7A7LdEw+0lj9/YMqsh0v6wEdHLyP2ymh2YTTqD3nBy6y55TeAQlY4I2yv2Xfv6q3/+6wuKBJ/V+k=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:26 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/9] libiscsi: fix iscsi host workq destruction
Date:   Sat,  6 Feb 2021 22:46:03 -0600
Message-Id: <20210207044608.27585-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 019d56c4-aae8-4307-610e-08d8cb2353d5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34296D48F2C3EE033DD7916FF1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQG7B6AQU4oJX4y41+nX/G9KthV360pZexwKGJwudKjQdMVKZKjStheFoiJ2VQ0FpwRTiZ57uVF5yMZYJfHjazwxXb9eUUNXJuJFlHzsvSmXeU0uUntAZafV3cUcqBnzPZTet8+YdV4nPABVAKZKzYM4GDD1SmhOk6p8lvmw8c9e9dgrm14fS6TsLeN9vP+88HSTTRLK39Q9INNvvSZ4gqCbWvSbJidyfSIOfoTuKgiWSie/q4JONrhsSZHNIx6oVhF2OtBoBX2oKfDO953TEwuFEKd/x0Kv2IFdEhSEVRzL3HE3F0ucOr8C6T1OF8uVsOD+uzD0bDqkLJnZUwIbB1AzBNLCpcmSv9h+eV/hMg3aQnKNmFiKbifLgulwy18NIPNfysmSnWkzsFhLbuWBi5PjTYyKQTEGTGmwWPMndnh+0o6eflC8qaLgCwboggjH0hgAt2F4gSmq6ZkUnktG7Mov+uxkUXjMcjIu2ogd2DtvxQG2Y8/EOHp5hDqcKsdOd3XksiP6ZT4+QYZDSKOr+8s36iT1wazJedX3NbraVz7w1LUiadiaa6XewBT6xzOqp3wDQlu8LsGhdNs17VyBMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(107886003)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oavgv74KrWLmX2WuSjQKNCMBi4c4zNxNIZVsaZqywqEaxk7X8EEYaWIJvPsX?=
 =?us-ascii?Q?G0EOnEo9cs2LHBr/crqr51v7c0muU4T92oWV/flZGJ60O+IQ9JAhfuoXTnox?=
 =?us-ascii?Q?Hi0d++sfKC2MEdtAjD+EdI1PU5oLHaGLK1G49TedOlZs4awDIq4FUBUqUpm5?=
 =?us-ascii?Q?/OT92lmcnLO6cPKwuLVyMqJ2B1QAAn/qXd66uaz/gtP1CZrIYCEGDdKY+Fol?=
 =?us-ascii?Q?CmDvQz8IxZMI4uxmnBKXcy8cQEdDaPO9zStm4rwdpe9U9i+p88339aBNSNBU?=
 =?us-ascii?Q?0GTeSH4AP/F4M/ASBz2ny/MVo+hPR0k4at5nrvt7X9nxuTnLVgQWYeFb3rhW?=
 =?us-ascii?Q?akWjvbmD+9M5BrSH4EzARSqQ7A0mo6zjrQGbyZ6IItUKYFzobGt+px/ZOopz?=
 =?us-ascii?Q?VKw0ujWvdCv0hAYnSc/Ik/61AVWdPiFCHYQ0qH9l+Iyd6sRIZcJvOGfRab9D?=
 =?us-ascii?Q?ffhMFo3Nmgj6T5dTmi2zzniKl2f62b78okpJ18r3vwFWipbmOG903OBecLNk?=
 =?us-ascii?Q?Rbs2KsnZx8Mrbm7CHsNGon9PkQC6Lr5oGo/7557XGrh1xDYK5Kv1StLUxlkv?=
 =?us-ascii?Q?nSHRE9bJiwsGlHKPU1On016JEajruo1BN0LBJ1kPJqwPcHeOtnYOK8JQesfs?=
 =?us-ascii?Q?//8yf4bGCfbdgVNswuuqp8QztEsa4tQ4dk/Dp8/s0mwn1I9Uy3UtEk99ZZu0?=
 =?us-ascii?Q?OdBtb6BXisIrtkINKXYsYtaBwYHesati6MxupPPw6gX4KtjGhaYfH1MY7Pib?=
 =?us-ascii?Q?QSI+qu2TCYHsSmE6vy4GXPRKrXs5gGdZ0rtZCpmUd/+pFsxup/DnXti7LWbw?=
 =?us-ascii?Q?nIPUE7HgXUNAEADGKOPkKim5YtAJWzjK9kvNKHmux0lRyZARZKmlnNQwPcdf?=
 =?us-ascii?Q?LfxsFL8fK4cH8mTpqBfA3ZeOL6l59vzo3bDE2Q3MEZSmX83lswMDvjfh1qLp?=
 =?us-ascii?Q?Xw+CytG5TxbWl3wFg/Ob6SnwJ1kANPlYsQzlRARYSFZgi8v7xKpJCsp7ZXAN?=
 =?us-ascii?Q?C5LVJWp1AF8V1Rhpq224yVCUzjoTCEDv3Qme/NsGeqXuxHkNsQnFHd51KolO?=
 =?us-ascii?Q?3ykaVqc0JSdNUSrPFj/qxJ2ix8OeF9R27+Ue/9WkxevUYWLS7/T3ANfXmQjh?=
 =?us-ascii?Q?oanCz8z6dKIkKiHRfFo2Ue2zfXkuHJtox3GsVeCFZJEvr63FepMOc79NEh98?=
 =?us-ascii?Q?sk42NLBYlpPZGHbEJF0hagXvoinU1doz4ZLngvAtJihyDUVDJAkQxdtAA+Oj?=
 =?us-ascii?Q?v2RchViA/ggJI3V7wwLsJtKUJTiXEAaV78W3IKruFxsbraNsa6ud9JmxlH19?=
 =?us-ascii?Q?P8HFUw0SUYS/gxNblp1HYIvQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019d56c4-aae8-4307-610e-08d8cb2353d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:26.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCZK/8krkKLOTfaKWunWabd2RGlWxgUhUdfP+6v8v+jHtDMnz7oAmaJqejz8UP0SgV4/kyOPZqgHVsAxnz3wSRfgPTV7ikjpFabsDcUT02E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We allocate the iscsi host workq in iscsi_host_alloc so iscsi_host_free
should do the destruction. Drivers can then do their error/goto handling
and call iscsi_host_free to clean up what has been allocated in
iscsi_host_alloc.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ec159bcb7460..b271d3accd2a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2738,8 +2738,6 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 		flush_signals(current);
 
 	scsi_remove_host(shost);
-	if (ihost->workq)
-		destroy_workqueue(ihost->workq);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_remove);
 
@@ -2747,6 +2745,9 @@ void iscsi_host_free(struct Scsi_Host *shost)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 
+	if (ihost->workq)
+		destroy_workqueue(ihost->workq);
+
 	kfree(ihost->netdev);
 	kfree(ihost->hwaddress);
 	kfree(ihost->initiatorname);
-- 
2.25.1

