Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710D1C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D8223B09
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbhAOELn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:11:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbhAOELn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:11:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43c88144072;
        Fri, 15 Jan 2021 04:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Mrp3+FUFCV8/6rt9ntv3NttmKesf+Zoyy7EDXT1+s2g=;
 b=UAxCV+y8k090D1dsLE1tAapeGUaAgN6BioISbGVp9LNhRDaXO7aCi1zPaUz8SbtJRpyQ
 rnj3u2IjQmj9/2r1ybpwvruoR1VDxb7VoZuA5LEGFDCXi10hyX7z6dggZogQKIt3DqgY
 EXtIfx5/PbJ9StPOqccwY8hiOo83Npy2zZIHtVheJREcsZp4aEljKR+9HLmRigs3KvxQ
 M5UJfV2Vj3Mh/cb08xCoqnJBEJloVUfi7yeA/sFb0WXat5NCYJb8HEhxM6GCn6lvrcoY
 5D2b/MzC8anyz/WAM23q0U/tVjpU47DEBy/3U0kDYjESqZc3hLB9/b933M+tqbX910Dt Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvkb6rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:10:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46fG3095047;
        Fri, 15 Jan 2021 04:08:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 360kfagp82-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXh60+Mil0w2VFrV4JdI7YGo6vfppPZkv8fMxmOj/ilg3iqhW2P7vcJMxls5c6FEfiStbgDpz/0vuv++KX9zijk4lVvyb3UceO10cyNJoFbmsHixgjyVJ0PXpBbqylRnrGLp6uQ7wOKyjdKCEGg5UtNpdgnmjMmQEMyor7P0tc/hPaVAM60IGqri5gi/ZNqI4uZ4fiozJPveubc0zXSlSQ4Y98Lvo/PRdBKoatW5XGdi9zKuKdouhiW7kSdRI7w5Sm4DpGm+gLqnGODe4cq4yrZzDMrm/Vrx4i25aromWaqm/gkHOwK5fqTixfY6lFpRyTxcEJavxriSKWUuH9INUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mrp3+FUFCV8/6rt9ntv3NttmKesf+Zoyy7EDXT1+s2g=;
 b=Q9q9UNxQZIuaPZI8knd1CzcdRMNn2xMbavH702Uujap/d9q0imw5kDx3vbwYFk5bJyEeEUv2qQ7Lzp7WqYDZ9M7jMfCWiriBgDHG9alnX6lhc9MBYuCubQ+4o4PYQIq1UubjYu+Di/j3kUGIYa+m+oWntF39w9aDWJSawLrIYcqQOT36E2yocxqtAldh+UMiLEqZFeXA+LVwbM5vYTyOmb9uw9kij9ezHUg1ZT3CKFWJ5BGYkTYYlwd3TWpO0TiBuZss7l2Ysfa3ehuXNYGUCt7i2Pfak58/MoUB8CrGy5axjO3eyWubAL4/SOtvfAUOpG0M/c84Fj2j9izrOdnWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mrp3+FUFCV8/6rt9ntv3NttmKesf+Zoyy7EDXT1+s2g=;
 b=p71c22JMJwUQoAS25xBO4GVrMJdP99orvGjAv6wNNYQQBTdn5tcHLbFMfFTONf2vpsf4SNuqxZg7yjkGIA0PGB6YbqtaPm5RihkyydKLHgi5bDdlupaLqJYFVsn4wdZZiQzv/K1lSFf/kOlKh5O8gPvu6jTRvDueVGgrGdIo66c=
Authentication-Results: android.com; dkim=none (message not signed)
 header.d=none;android.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel-team@android.com, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@google.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, cang@codeaurora.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH v3] scsi: ufs: WB is only available on LUN #0 to #7
Date:   Thu, 14 Jan 2021 23:08:25 -0500
Message-Id: <161068333185.18181.7892741699634000269.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111095927.1830311-1-jaegeuk@kernel.org>
References: <20210111095927.1830311-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4824550f-aa61-425f-568a-08d8b90b4170
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568BF67D41995CFAE0A30A28EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMkuS5kOpA7ilS/iPWLbkstI85GYSCeTqzEidaCpz2w1DsAgHlQTCuaMMpquJk2Fj1KRJKOQX7f1GwGM7ho1LhpRUx7rwBKCkudod5YrX3eAj5zhBdmDfOYuxqNGGxQfZCUQbBTyGHQKlyxt04a1Lmz9OT2cPgbL2EwQP5kbU2jfEhz5CC6B52NxP+eqMWy+/iXhgjd8ll2JMfG8yy5elZixt2EqZ81HuT2SjSJN8kJqIozHR2lz24lIrSsTkL0vD/ZWDEOUsB7K2DefgKOaSv2BHKemwZhDwft2vAJoAwsmYHVnslmuhzoLlr670yLrO4spS6G+k9RaIX2mdr/7KluSKwqgeV91Gq0MlmIb+IDuTT06Zwt9XbaP9YFAysn1DvARGGU+VIYftokJ3XT4wB4NrRbByCmPsC4PAwzWGRtA6T9Wo32e8G77Jg/PqbeSMIalPtYts1yCSwHo8lNyZZDBphHzpFuyO37EG9S7LAzNjcWajPsMIylG7wxnu+Hd2D1LO+V12X8xZSoyw81rhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(54906003)(36756003)(6666004)(316002)(7416002)(4326008)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005)(131093003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dE1XKzJRbmNFSEZMZUZac3FWbUhpVmdpMzk0NXdlV0hBS0o2anVQK0xmV0hX?=
 =?utf-8?B?SzJMd3dBeDhscUExbk1wdXJJU2NIS2RRZlY0di9yQkFUUm50UzZtL0tMTTM2?=
 =?utf-8?B?MmNuT2VCTTlBTFZqVjdEdUFEOW9rKzVFNnZQQUNoNHhvWCtEQUJNcUFNcHFG?=
 =?utf-8?B?U1VmV0hxSWJvMG5jaUliZFQ5blJuckZ1T1A0SERHbFVqSFlQUzJqWWpNNWxO?=
 =?utf-8?B?NVJsUmpUUzdQNGxDUUJpTnhpR1MvVkVUTHpTMko0ZHdBZ0VpdkNtSDI4MmxZ?=
 =?utf-8?B?dnUwOG85QUJJclRwODRYZ1IzTzM4OGMyN3IzTVNJb2RVQ3BidzVBQVdaOE4v?=
 =?utf-8?B?d1hueE9leHJzVlRFQ0tZNXdXa3l2OVF0NW5IeUs1UDVQOGxTUmFCV0FQY1pB?=
 =?utf-8?B?cFdzY0RRcEVWYi9kSGtCWlV3UldHVjRFOHBQV3BvZE9oRHRGUXlLU3hKZzVF?=
 =?utf-8?B?d0ZDWUJwcDlHZ08xUGxqVVlSOERmeFZkNGM1VGVTQzEwa0E5ZG1RVTZiVTJx?=
 =?utf-8?B?azBPK0ppZFhWR0l0WE93TVRETDdwK2pSTUZEUlJiZ0Q5VXJDMUdOZ0swc01K?=
 =?utf-8?B?OGhLaUJKVGxKMHBpL2FEaUc4OXFvVlg4aTBCNWJ3WnVLZUNmN2NYd1NjV0FQ?=
 =?utf-8?B?VUV6Mml1SG9rZzJpOVpQekRvT0tqeUNOVjRVaHF6UjBKTjRIaEpNY1ZjVXJn?=
 =?utf-8?B?b25pcnVmRlQyRG40eTExdWJkOTdHZzdJbUpYOThYbUtUQlFYOTk3UmxxTmhP?=
 =?utf-8?B?Q09YQlV5VzlMYVd1cDg3VGEvQjNTZlQ5bnpkOXFoYzAyRmVaUlpRd2RZRjVP?=
 =?utf-8?B?a0xIMEdMbSs5RGVSSnI2S1gxdW5EbTVDVmJLaTFxMUhDYm8vRXh3T3ZrU3RQ?=
 =?utf-8?B?aEZWWnBkbEZtTjRwU3J1QXhOaHdnbFVHZlpibUtyZkhpQWF0UzlONldhOUdY?=
 =?utf-8?B?SnVzNEJBaEwrVnZJRUY0ZGQrNXJXQS9hcDQ1TWZuQ0dQQmt5aUpPb0YwMEhD?=
 =?utf-8?B?Y2k0alE4MUVxWWwxSjlFSHhiOGQ4MkNyUERnQi91bktSaXdwNGxmd1VvRTM3?=
 =?utf-8?B?ZUc5R0VHVWx3T255cXhOTG5vaXQydERPNi80UW5hTXczbUd0YUxLSGlYbmVC?=
 =?utf-8?B?d2xpTTMzS1h6MjJCbVJmTEUvOWRYWEtoZVFUdUg3YzVoZE9DakdMK1RiN2U3?=
 =?utf-8?B?ZndHOHkwWnh4VzNzVmhRcnkwdjhmNkhKTlRvc0U5WlkrMDlBTjUrVVpqckt2?=
 =?utf-8?B?aHBiL0NpK09OcDFMKzh2alhtR3dybjZlb2xYRVV3N0RHMlF0aUtkZnMvbDlj?=
 =?utf-8?Q?5U3u/XliWxofQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4824550f-aa61-425f-568a-08d8b90b4170
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:46.9044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShquPwVDbhrWO2ZZWt9NOX5nIJ7Xb4b48SUUJJwgNd7je46cWUz5HyjJIzjvd0Qk/Em5lvavtq/1cZQwJAiwCgBfz8f7xD4vo0kstAyiVok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Jan 2021 01:59:27 -0800, Jaegeuk Kim wrote:

> Kernel stack violation when getting unit_descriptor/wb_buf_alloc_units from
> rpmb lun. The reason is the unit descriptor length is different per LU.
> 
> The lengh of Normal LU is 45, while the one of rpmb LU is 35.
> 
> int ufshcd_read_desc_param(struct ufs_hba *hba, ...)
> {
> 	param_offset=41;
> 	param_size=4;
> 	buff_len=45;
> 	...
> 	buff_len=35 by rpmb LU;
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: WB is only available on LUN #0 to #7
      https://git.kernel.org/mkp/scsi/c/a2fca52ee640

-- 
Martin K. Petersen	Oracle Linux Engineering
