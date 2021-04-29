Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C34C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931E361450
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhD2DUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:20:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbhD2DUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 23:20:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3DpNW175225;
        Thu, 29 Apr 2021 03:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Zc7R3IyYvZTVjT6vQ+jEV0hboXPNHcjTVapWdTRhDp0=;
 b=VmMzfwPKmDh4rQUeLM8YfZ50r0vFsehhygxwoqkvlpfux29qcKBcY0txYK49CG04NQ3V
 1skCfGyUHEpuXhtvLjZg2ihFOYZh6WGDQaiOiONOh5mUXAmvvZEqd13YThmNZnp0dRJ6
 kNKvWJtrwtn4a+wZ9ytjpP3fjoS7OnvrzealIeSAfcAtgCLO8pFEZ/02LciMFij5S54O
 2y4fV/XolZ9SHYxBv5pQsMAmlYP9KisEmputQi9oOmNcOtk1Ic5SH+VdpS+XH+i9JCSE
 rvzHRtle2VOg6vomN75WlTexSuB0UIfvFr7s3prCsj4BxoPZ2bLcNIyrkqwVO0SI2Tjm Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aeq2w3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:19:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Eq2x154231;
        Thu, 29 Apr 2021 03:18:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3848f0es47-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReJyO5ZmEjyccB/ocrANI3/MF8jPy2B/CmEN/tytCoRk4ngFjtHzxc0ly8p1CJ4kytdkjQuZSTxgzu6qGeTUsvmDKm1a2YDiQ4hRQgWzgMQIrAQJQ00MOvw9X9Ug6SpyZPCf8c+h6r0JkqncGeu8+xl3dML9Ihs9Ooht9zf5cD4EoDL9tO0y1Zj0ywM+/B20d4MCdaJGNanTWC/c36o25DyavUVojBTO912Ko6cuAjquzq+xkKzzsdxRWxudZkXJvqXfnK6jVJaIhji8HSCoMrnE6qLYEoFgh3YiXV1E4im2GiyXUb9VSpU5otr02wWpEbcAPvH26Lsi5Xza3qRnWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc7R3IyYvZTVjT6vQ+jEV0hboXPNHcjTVapWdTRhDp0=;
 b=BcFAsZsbtusDwmWpSb1fZKZihMrjfIhPS3QdeXYUd2zOtw/X6G2C3HrOr5qnGyXJo4TFW9g59GYGbLjxNqJtM/TdP3oIZsUkym5wu4f6xL2gXBKfivkfXz/gYvkYNWLjtq/7sbzweKq7OPxLcGCVFIZmoyO91C+c65BU8ahNG4pN3a7A+/oPodaL1bh329kDWnYXfVi3MZsHDWst24m5QFD38KxzEFKlVH12r29rdgttdUVuXkPT4dhmvDmL6qyYGN+3JraHm/oGyfptW8UqNG5cf+ib0gvdnf86vuQ1MjckThBcropQg1WqE8UboAFUpufVb7vt/lvINyXLMQQJ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc7R3IyYvZTVjT6vQ+jEV0hboXPNHcjTVapWdTRhDp0=;
 b=JyP+frTdO9lPjSQaXEeeuRpbfak0gREEV3JtEHqjc1jj84Qt+3VjIb1ji1hFailRlu2ztpWg+Ocv2i3emeg8x9DS1+ADXtChg05fRLpZoZ7S/hk5K8ybAJjB/hXYFMk1Yl6FL58EuBoyL03+tSGGeivA6sWLzIx3sQBD587H5eo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Thu, 29 Apr
 2021 03:18:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 03:18:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, cang@codeaurora.org, stanley.chu@mediatek.com,
        huyue2@yulong.com, avri.altman@wdc.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, Keoseong Park <keosung.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>, beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Fix a typo in ufs-sysfs.c
Date:   Wed, 28 Apr 2021 23:18:49 -0400
Message-Id: <161966630052.16262.17018262739572953486.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1381713434.61619509208911.JavaMail.epsvc@epcpadp3>
References: <CGME20210427073842epcms2p1efa82e558171ad06c9398ea7c364e7dc@epcms2p1> <1381713434.61619509208911.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 03:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40d759df-d2b8-44f2-bfdf-08d90abd86fe
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805C7BB68475AE1543067048E5F9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVg6to3HbjTM9vIdBQqypqHiTC9t2F9NvNXAukgS3JVEL52LfpJdTpSkgxBheIN52dDmnzUbzLzwiEVJRxUWSNwBSPrn2wk0n9wFd72CQ0wmy35MXGhcEGZvt6tJAxysfo6tJZtC6bcvJnJCckKNWyVR+M52ptJuajZc3J5JDRlSkZU3DTJnfQKOhQcZd52AQIuW4cb0uNhtXGD+/c20nRKM4D1Ob6qfxsjqcCOT0wVvvFCcc9FHc8tXGcIydOQaPbUohNsNDarT+6TGTtP3ouzvhTQazuFoL5BUkc13MXd47Jx64cPiPdYIZ/0R19UArUMlyAsOh4dutP3B5KrHabwLXqsmf5d8UM70jXfelCy3Ggo3F4V1apLpDoCCguGYFcfIv9FN6nyG81kXWNs4JQTmqDQD+Ti6KfetR2uoASzYIX71NKuTxSt+dBInGiL3SkxkmejoL1DdVvY2Td1J3E73di0iCBKHoLROVphBcDZnRX0pupr2oZuT/RdEYDRVwt/z8aRo0UQ/Dpm3QI4HOdONPWRLeheti2yZaZq7xDgXoRCcU9iuR02NBwVlABw2+yrWp5r95iSRVvyUgAx2x/Rc3u1vt4cNqenosPNNZG3FFipCv3YtBlPIcb8Ms66fqT7k8oxwHMAI/+ZDLgLEsCWvZ4prXzUOCKRoGZ5NuBU21SQbJWKBH25g/nWNa8YUD21DciEIqtI93Cn6xHSPayptntFbb1b5sO34YMnaj0uRwg+sHru8DEGziyO3KGnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(366004)(376002)(921005)(26005)(36756003)(7416002)(103116003)(5660300002)(4744005)(110136005)(54906003)(52116002)(16526019)(186003)(7696005)(4326008)(316002)(8936002)(66476007)(66556008)(38350700002)(6666004)(38100700002)(6486002)(8676002)(2616005)(66946007)(478600001)(86362001)(966005)(2906002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TVFoUXZVRFpJSlBUWnRVSHF1TE9KVmdUU25Ubmo3T1dTMkc4OVQyek5LdHBW?=
 =?utf-8?B?MktNcDN2Mm1UcWxNVG5KQ1FTL2N0cDRRS09iL2N1VVBiU2lCQ3RWeWFldGEz?=
 =?utf-8?B?ZWRBL2VkTWpycXQrakZ0bC9oYVoyNTdqN3ZNeDhMaWpMbDNXWEpJN1E3TElt?=
 =?utf-8?B?clZmaUd4TzVaKzlCTW1QSlRiOHJnQ2pMd2ZLUVJ3bmdZRzM0YStNZ3ZKdzVF?=
 =?utf-8?B?MGptcmt6ZDl3TXJuMzE0dURnOGlkUGQ4U3hrSEdDZm9jWC8rRFgvWTBTV2M2?=
 =?utf-8?B?SVBJOC9hTTBzRmdsRmZEVTlmc2N6NFQ4dXVEUkpDRVdxUGN4Q3JsUUMzRkgr?=
 =?utf-8?B?Y3RKODZZcTNHaHlHMkdlTjFrT1hrQjI3dlZIejl2STNVYklzc3lJbkUrRURQ?=
 =?utf-8?B?ZWlRRm1wYytMeWVRUWVvdU1RZVFuN3F2TTlXV2tjZklxbWxzcnVTY0xDcHVn?=
 =?utf-8?B?KzlZTStEUFZSR1VYR0NMb3l0RmlwRFFlRmJSOElsZWdHUm9ZUEM4UXlOV3FR?=
 =?utf-8?B?Q29DTDRadVBsMUxIbmxKejhIRnRzaDBSQVNQcy9OWWRzTEdDamtTNGNnL3gw?=
 =?utf-8?B?VnA4R3lwV1FTRmV1dG1LS2dLN1BoWjRlckh0Z2VhU0M5ZDJqajlpNTVuNS9w?=
 =?utf-8?B?aGlaMnhQd2U1M3dBb3liTGtNdmxEZDg4Y2V1aXl5M09USDl5MjlGaHlFSnVG?=
 =?utf-8?B?Mndzckd2QTcxcWFSbllnZ0o4a3dDbUVscTRCcWhUQ2hsakpXN01wTDAwTzJV?=
 =?utf-8?B?WURqRm12U3F4YWthRXdrNUk5ZC9HTVE1Z3NndkVrbS9pWUlmb2FSbFhjWmNS?=
 =?utf-8?B?SDVLUEk0dzdaQjUzelo5WmtVdDh1elhkSzl1N09YTjV3aE1Rb21sREFpaFZQ?=
 =?utf-8?B?U3Jrb2s3S2Z2dWFDZ3JXYnBabE1nMXdBSHVOWXRJSGdWalBEMDMxQzdiZlZ5?=
 =?utf-8?B?TmgwK1dZd050TVdsempBUVNRME4rbGxpcDBDRVlGTUY3c2tJdnRMUEYrMzRP?=
 =?utf-8?B?VytVUzhIcERkMHBFNE9obFFvVTIvQWd0YW5hQzNjZlpBQUpLd0gwTEpub2g2?=
 =?utf-8?B?WUc3MnZtdG00Z0RnRS96dXZENHNWeThzV2N3Tzl2Yk9aMmY5UFBhN3BTb2xo?=
 =?utf-8?B?d0FVcVg0R2FiZDV2bUZKWnZ1WGVRTldjTXF0dVB1TjlhK3JONkdHbkJHL0I4?=
 =?utf-8?B?RjdwdzU3Yy9GaDk0UGRZZFM0UmUxRmxFa05vNklMWERFNGhDQzBSdnkyck5Z?=
 =?utf-8?B?YTA2eUJ3ZGVlQk1Qa0lYZ3ZIUE9SUy9OZWJybnA0RXVNc1lITjZCN1hieHd0?=
 =?utf-8?B?WUZ2Zy9WL2hLZWpCN0dPMDJPSTVld2lpdFh2TlFjSG1PV2MxQ0xONkVwOFNE?=
 =?utf-8?B?bHFmSjNJcW5Sdi9jOVlJOXlFcVlsUVlDUS84RkNWYmpQbE5GZkhMejNwR1ZB?=
 =?utf-8?B?UXlwTVJPMHczQkNpcGloS1phVWZuREt6UUt0eHF0UVMrV3BMR05qZURaYWZU?=
 =?utf-8?B?aGtIcWRHKzF6WklkaGJ3TDZUczVWMStwYWpVNi9jT1dFTGdwOGJsa3FsenNH?=
 =?utf-8?B?eHZBbVZuOWxvc0VmRWZndmg4ZWdQYmtiTGs5VENmdzRNd08reWNtQ3Q2OEhz?=
 =?utf-8?B?d3ZsMTBKRUZpNGthL0VKZWxMUFBNSitaemdYakZEcjJNYlZHOFhnbUZkSFB1?=
 =?utf-8?B?Ky9xcnBMSnoyR0pibjZTMFNHRjlKbGs4QWVWWFJQN0N3dEYrdXpqRmFLSStH?=
 =?utf-8?Q?LAMLE+sPupb2V/sasU8LAeiX/gAokf2eAK8alwr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d759df-d2b8-44f2-bfdf-08d90abd86fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 03:18:58.1506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADKO1tsaURLC3j8obTbo660SROUuzkPFnPmuCeZCNvrPFrCzxsTnWS67bfhaESH+nXnIPyPjeBfVf+fem3hukq82ekc6m9ekGaDcxnSdMwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
X-Proofpoint-ORIG-GUID: 9TsAE058WEAZbUZl7AIEwpZF6xPSMiXZ
X-Proofpoint-GUID: 9TsAE058WEAZbUZl7AIEwpZF6xPSMiXZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Apr 2021 16:38:42 +0900, Keoseong Park wrote:

> Change 'ufschd' to 'ufshcd'.
> 
> Fix the following typo:
> 
>  ufschd_uic_link_state_to_string() -> ufshcd_uic_link_state_to_string()
>  ufschd_ufs_dev_pwr_mode_to_string() -> ufshcd_ufs_dev_pwr_mode_to_string()

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix a typo in ufs-sysfs.c
      https://git.kernel.org/mkp/scsi/c/2f1137140fbc

-- 
Martin K. Petersen	Oracle Linux Engineering
