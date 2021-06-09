Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54054C49360
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E9ED60FEA
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhFIDlw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44786 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbhFIDlq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592fjuw083382;
        Wed, 9 Jun 2021 03:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=EkGuDT9l75zkd89BCGj0nOxef1hAxJGQj6gBvkc+MDE=;
 b=LfujkX0jXr7/CV5XuZsXrreQO1HLN3IrvaxtHwF1b1AORMUsEqchkAz3zCjrURp8Ivzh
 DMrwthTTku8a1hg+kAvASoPkMwjYtUB9sZy5GrYWD1YcPrK3XPpH4BU/5TMAk4p+TeHB
 Gq5aURRBedjhfrYnKGMaAXaCIkckjWKwcM6MQ+b3H7fXI4gosRwgASEMXi7EiPgwMJpg
 Zn/VH5dbGkighpFTYaCbzGs3EPxPuk4kS8Hq9mPzlE/0lUEVabGzms49eyJtQ1kWHbIz
 YEuIzx9iqVdNXyyturRovmrQTWAg8Q7bIhd1q4VGb7kxUHuHXv82vgFNupjb7XHCoxC3 MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfrdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 03:39:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z2Pq082696;
        Wed, 9 Jun 2021 03:39:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr2k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 03:39:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7kf/RgO2PqXJq9d7g3lGe9EOAZH2e36u3L+VyctqbiRdPBpCc6MKrhje44BmAqqJRlZ7VRTReiZiipIHzaFC2kuzIeeRGvsBhhgYP+sy+VzSJzuz0P0MJREjNdGnk7YOSgoygrlCZl6iIAE4OaQU2pH9CxRYBnjBOF72yvzXANKEBb7TU+tQO1bZimtPn7Hj5zg3StB051VN1f00NPe/dgwtXPLyS/tFBx2Tv6QkiVudK+F5+18r5cpKj1KRnDvRaxPjfZgF6Cn8fLwbhzLF2TbXmEkLLLbHLCo/gnlMb4QHqMPPaXO2YbDPtszvbFb5O5XjSP/9K6C0OqLOVC+fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkGuDT9l75zkd89BCGj0nOxef1hAxJGQj6gBvkc+MDE=;
 b=GJbEMTmtAiR4vCup2YU7++O2s/P6fbUlPb48io4WHBOq1UXBzbq0QqexfeYgOcZPG+e8x0YcyBvXZu+bx80v0LuaydZI5JpNW6kiuW/z2137NbuZyIf8AwrI7xmPKbTW0o/N3/PI/Vr8ZZgfpvXQWoZdMx6ZekBiwTfjupMDyxshcjzU0ChalIXoFGY5K18EPVD2u8kwW0n+qswexZktizXZbzNmSTyYR7SykJuakc1OuF+UTEmOdJtiBs9m3+pEjPBUIzz7cdWBtOAzWAeWnipGw2Yw8FJUk7KRLmqrzG+S05VQ9ZPrb2Fp+dQvXVqas5siBvpnvDHYuagZV8m9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkGuDT9l75zkd89BCGj0nOxef1hAxJGQj6gBvkc+MDE=;
 b=D+swOHRGFRTIcWN1+SE7RTLsaInMrQfG8sZrKAJjlofQ2kIzNBdaaLpK+ebBa09RGoX69PNVjL/oc7gsVxQXe96OS/0ysd6BEbBnsoatoVMnTh5ptp5PkJYU17eE4uhZjaa666flyiaOtNeFmsMFuLcmNiAsembkNqeXDAYSGGc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 11/15] scsi: iser: Use scsi_get_sector() instead of scsi_get_lba()
Date:   Tue,  8 Jun 2021 23:39:25 -0400
Message-Id: <20210609033929.3815-12-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15a544c4-db3f-4a8c-7647-08d92af8378f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421F0376DF980A955EAD2BA8E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GB0SEmfJUKoheqsEN/GRWrFfwbz4mAR11WsCqxPT9plp21ZXTx8dtjJRbvMI9T5ZfWmws/LTomioGEaEqBjo0eWu3DgIG195k1WE3oM27dyp2LSJ/DSA4mN7xWU4rxeLxERdMLkWLsOkGuTuVsZcvACiZbEZLnK+zB7vpCMdZf4hgFBmIT++zz/J5BbG5uzvlEKljaLNs4YFmgYcW/7PqBpcMqlJaiXYWpxcDaMrxzFU1Z+nKd1K+0gWD2d0I3TjLtRYjD7dFYC30yjxnvjaAHywBS9arUglZU8+MMito/EAbryZlriVcPJPWZJHVyuWk/PwfvjpNg7doJEbbZK9r2kPGPQtf9hXPxwiJVR6Xn0Vt3wnPUerqmp8WcblQl2+CZOcZH+K51V156Q3Pc64VDav320VtuNUFAyiVvm+AoMDB26x+lENAyb15sSLB4tPAFCt2cbj3KbtXiTJ95XNi9fgVlJ7p5atqoiJdzGV8XIrdY8AMrEFq1eCxxVPRzd0lVM7OiNK5QlbpojBBchFwxmvpHullX2mRzhpCrnnJVTOvtvR+TMcIOMzR4hV70YrAUUGbWj3EM2+f9mhvY9V7b80wAfDx6oAvwthMQybZYRD4c8JmvVfou2UShB6naJ/tnqRMeIs0vYKuIsxR1YsvDtHzNHfUVsj166BT6vY7eqj4TtpLAHivoiq1Bp+vQYBorh0H5+QM3mfBFhmshDX/cHmOTW7DDGf22iIln3ERnBYJdMnaldR9lZ0ICDRr4APc/ZozjqZbkxtAt5UFvjBjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(966005)(54906003)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fQXG46G6IGBEsoxfX/5tDY1c3zjvFDlm9jnEM59lfsElOxmbvJ4N4tMS8ntv?=
 =?us-ascii?Q?3ZijykM7am3+JoV7gI0jD+SbPn6nTQ5XkCmak/tBasATtV6A2kOzWXcBIfrH?=
 =?us-ascii?Q?3ebfIPuT4O55kkQsAx79h7aosVksqJHqgRlWDZY4dfkXLaejNrcNCLjiPJzA?=
 =?us-ascii?Q?gTyH4eMtO87Wugmcfx5zFvfuUui+WIs8eqbl181vYF2Ztm66D9PIptsZYTnZ?=
 =?us-ascii?Q?/eUztp879TRf++3iUbM7nG7OJ9n0fmQkdrrl9aPlpm/09Ia9dNJbb2FL5eh5?=
 =?us-ascii?Q?mDd0FUjPKjB28Ouus2VBGFs5TljFxiKQzh3dJHwFBLJwWhaFuqtiB4HKgz9R?=
 =?us-ascii?Q?iBiOuTXZ7e5sBeH69QzLQ7BSrdfZllbPJ78oin7tY9kX3vEktm3wraarbY70?=
 =?us-ascii?Q?4SKoz8lavwP3Upk6NrNvg0TIler3Fmccn2KRlbmeD4H+ONjQy3JK6eHKjtIM?=
 =?us-ascii?Q?l3aF2ux/nwJUM1JUeDgQoC1544QiGtLNtmiD/pkk3onQ3xhWyaq7t929+Bth?=
 =?us-ascii?Q?7caY4jfLXoJSWjjLqJrAcPTlwem+aPTNBxjbc4mArZGEAHhjP2wIf41N8HJD?=
 =?us-ascii?Q?fh0fddATG5yLpMpKyaPkbR8OqTiRAz/4MiGhXbQ/StxCfvrCl3mDmlvVha0+?=
 =?us-ascii?Q?4f9JeGAOn2VZJgT8dZO+yi4IWd7sThyjQtmbgvkhmH60TKxksAbrQuPFXEpP?=
 =?us-ascii?Q?1CoR8JzdLT8xVKo0rs+fpCqQXJd8d0Fcp4O6pGR8KF56XNkmPkbh8uzEh8zm?=
 =?us-ascii?Q?dT52ae/Loy6/r+FIFRFTv2KpRtLwp0iv67RQE1KXA383jgnv9pRLW49pXTLW?=
 =?us-ascii?Q?2w++sHxASJiVLFlNOh+x7tYBhyGbOScm+zfOHx5733ZO8QhYza46zYHEyDMp?=
 =?us-ascii?Q?pGF4TnPWl51bofF9wOn8k3Q9PZ4f0KL/1JMAR29wETwjnvYCtaLLjbpwRJqF?=
 =?us-ascii?Q?QOmaDTewmSOGFZJvRx8vAylT3Ch7cmAzEusFeZeg/UC68pirBvm4Ym3SmIG4?=
 =?us-ascii?Q?ZYiLT7zOu+UqjAhyaooHkKWI1dRSv2xS+KCmZqoo+f2THihzApXUrmCPolpn?=
 =?us-ascii?Q?FSKEMsZ1Rbw/C/DXXvGPJBv+UCuRMU5zRL1QMbaZZxUKDg5mbElWb/WYZ1Cq?=
 =?us-ascii?Q?VB3cqkiQmvs8GzEQ8nrT2qNcNTQ/arw9O2to2rw5BNREJaIMu6P4nER7rD72?=
 =?us-ascii?Q?m43jcBI2oiKv+6muQaFuifBr1VwdbCH5fL5u1oTEf6SjeedLWxun/mn/ukM2?=
 =?us-ascii?Q?p9TQN074sHUtwQ8VYvmg24Ci6zvhZcBt3OWCvFi0bdwlIdn7AnGOsBi3nW0r?=
 =?us-ascii?Q?5FU3t3XMAo6l/nGmgVDoCszk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a544c4-db3f-4a8c-7647-08d92af8378f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:42.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fR7z/vX9UC3U8JIJFMyX4ObU693cR5dFJkysMWv0btPXjypXF0V1hbXo3OHi7FeMX1hpxZFOKr1MTw+CHtH4/zpXI3m2XuGCq+mw4TspW44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: geoNjraMaqjBm0cEB0KF6N_TnSc-L_go
X-Proofpoint-ORIG-GUID: geoNjraMaqjBm0cEB0KF6N_TnSc-L_go
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Use scsi_get_sector() instead of scsi_get_lba() since the name of the
latter is confusing. This patch does not change any functionality.

Link: https://lore.kernel.org/r/20210513223757.3938-3-bvanassche@acm.org
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 136f6c4492e0..d6bbf1bf428c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -949,7 +949,7 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			sector_t sector_off = mr_status.sig_err.sig_err_offset;
 
 			sector_div(sector_off, sector_size + 8);
-			*sector = scsi_get_lba(iser_task->sc) + sector_off;
+			*sector = scsi_get_sector(iser_task->sc) + sector_off;
 
 			iser_err("PI error found type %d at sector %llx "
 			       "expected %x vs actual %x\n",
-- 
2.31.1

