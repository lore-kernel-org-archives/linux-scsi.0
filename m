Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32DAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA9A611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhIVErU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23220 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhIVErM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:12 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M23Z4c013571;
        Wed, 22 Sep 2021 04:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Zt7PtzYqBptXbU7sknBcMaQC/hm5LwY2Ecja4w+0bD0=;
 b=mPYoYmSgOBt4bkXxDs7p2qfpZ6I+VuWZfsE6Y5U7UUeFiJ05x1WOhXMKSb42d7uAMMc2
 fNU44UKZcO/U/d4g4wE6RedSW8GyKHTSQz7+2hDoTjpYxFMzj2MgUhF5rwNB6vWu8UFF
 YNxKAMIq/9Wgap/g1LbKKfZnYS1h2GyBT9btfM0iAOI+hyZlZfOLTeSMtZMN7g4GDrxO
 t2ODqZm+z/1TU4fiTyDA//U/fr32Aiik89XsIKHoBI9vyD9MN6eEJk5h/uzJ5nXuCUIO
 3May1ulGtXDDpVrGt++CkaiKlAxiL1dE0tYdS2nlzX3Htnalamvdmf8/K0HTj+2FdTPa Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4s1b65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs3178811;
        Wed, 22 Sep 2021 04:45:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsly7M7RS5Ld76zF5sSa1kzCITF3ReK5TmNTZ1n3DlL1lRQVYdxbkxL+dcwZOqtUmbWmeb6Zsgic3A/VNtnVEndFRNrXgyD3qoQa0ACxOezzDaUdJBrn75KpusSeT9YnhIXkQ2PQ2PKaJ6HNuIzkz3QXZcw+1sB+iFK9dVLtw2cVx47CGeAyz9/Qq6hUDGSPwsSx1b+JFDCfuj26okbtjdU7hAKNE2FzyzJMHDIvGcPNmma1jHtMYzwi88rKLfO7O3i4B1dqxDKbCl9cJ41szCE9xxCENPFWh10CeDupQSJ4vEQ5LnoLQdNVgbib7rfdv2MQ/rU5Tlx4z8OeNxUmcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Zt7PtzYqBptXbU7sknBcMaQC/hm5LwY2Ecja4w+0bD0=;
 b=CA7Rz/xVw8jOsGNlmxUNPm6Th1wAcIarxg2KlsS9KGK44zeDCPah8nktOz3aRpjDDfhZfXIYlvA9IGGYyMyOeLQdBrydLfZm7uQmkBr5o62fl/rqhFhkaapOIGjPs1mj1OWGI8GdVF9bRWSHsE59pKc9knT7AfsQ+/PmFEPH0csnnpB4URlGFezV6dIQKU0HuINAdSjJr1QE4IAgu9rDJEK4P+O7PxCQYFbef1H5oEnxJllHCP57QPSypoqGEBiMrlABfB8JaJuhAu5MlQt9pXoLNnQm4fN0L7zCj1DlwMFInAh0dvA5RqZ9uYf4GWvzLgnOV5G/AIbP8wMG+/V4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt7PtzYqBptXbU7sknBcMaQC/hm5LwY2Ecja4w+0bD0=;
 b=u4ug5Q65b9Q/5H/O6ximcqMrE3uZ13qXudSSzg0bvUv9Ml9d4rBvRppjKmVkn4DpQRwGWlO5lnB+zSlG2pkoTNLus5qEVIkJpHyfha++TKr7ow8ofVmTv7YRAeDqOWtw43VaoJqgjx2VBdF0ik0Ux1LEfXCfMovRUlRCUPLrEX4=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Colin King <colin.king@canonical.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove redundant initialization of pointer req
Date:   Wed, 22 Sep 2021 00:45:13 -0400
Message-Id: <163228527479.25516.1621309381422725342.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210910114610.44752-1-colin.king@canonical.com>
References: <20210910114610.44752-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3eebe55-4f54-46a1-04ff-08d97d83cc8a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44563374B3C921726D6EA56D8EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2HCfpzDpGAxrI2Svj++uxhiseKXeD1VY7ZSXRJHElq+p8sZHnMTMd+6oIyTh2DjnDJ9dAQHHfzrM4hyKAhjVYNqAglIo6WoHKJoQmiIOK0o4yPVSfxW15Vwi96REceam1Tmgr/ezKDl5mSkQYUVHHK6LM+uhIcatF4Lr19rY33Gsas8dJ8KUAvXX7Rx64mjRN2xhXdXyPM8ktfyWo6fM0cwkK/xXmPUFEVC4swKdMsJaPWZqLeUeZL27xkibiTdy6Jdjir20uDozMchn7RVB90ZOecGT5MfZDI4jRh0DMlYtRhbmEyDA1fvcfQ/6uhwPL4S8JEXaTt/uVk/7s20Dt0OILwBrxiybITSpuvaVX655+K4awsBj5nnb3qcOfW0IwSQBLxIYq+8L6eh04BJhLLS2xBjtNVrxNDupWPcVAU05ZTHpWuFEuWZDox11DtDIpVVv46YBZzV4sgSM9zlVREihlwYBB2ok1OjKE2qs0/76JSSF8u8HwCR9iAO6z/4PtEtD3IuuZTZu1NXeLwFGve4nmYaJBNTjilPKXXTfNoJLDXiQ3ZuglNu+Bflckop1kFbnuKkMgfhB4APq1PLR1o6ZnWnD6n5fOQOsngb9IYqJyrz18PBKY0UgpW9FekMgvjU5YhFkeD4u/oKDd+VDlq1gt+Sb/QVDo4aMCHi2RBQHqZyvLLrqF5HQadA0lFUyyTJvIcG2l9CCwCglol3JT28a5+EaHHRfMtsUQfA4UhvAy1RcONmdHyUa+yZ2g326OXIKos7wW0Hl56Zj8KVjz/RYM2DDr/UmW0itcH5r4Po=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(110136005)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXdLM0FkSzBtanhKUnRuaWhaeWFSQWsycHZzQWFmdktEQzJTZ1FNOFJmWEN4?=
 =?utf-8?B?eEp0cEhEQnh0Z2YwbDRaSVlCRTZ5RGFwY1dxQ0NTb1Q0UmtWTWFuUUlrQUgx?=
 =?utf-8?B?ZFJZVjRyTElZeTVqaEhWVjFRL05Sa1cwZzNwbFlRMnJieW5CVmNkWmEvcFdS?=
 =?utf-8?B?S1FncWt2Y0ZJVVJnTzNXRjBlZjQyblk3K0hWdDAyRW5vSVJOSGpoak1uK1U2?=
 =?utf-8?B?V24vRkJvekJ2VWxPRzAyMDdaL1VDb3RzOG9vd21oaE11bk1EOHNBcXNFZDY0?=
 =?utf-8?B?c2ZnbmdUTWxid1U4MU1MaE81UGJ2Rlh3TUh2amRvT0lZaHZDa3piSmdpelps?=
 =?utf-8?B?Tjg4b2dOcGo1NUhXVUJYa1c0Q0VzY0FKRmRiNmd1ZDVKaWs3QzVGdVo2b210?=
 =?utf-8?B?NDA3WU5DT1dON1o0S1VzTkpyTVJCT0J0NlM5UmVZWDZoOVIyU3hFN0lqOXF2?=
 =?utf-8?B?OEhrRjNyWm41elR1eVgzMXIzSXRsV2grSzJpNCs2Z2hvRzJsUzFFQUV1dTBC?=
 =?utf-8?B?ZUlIaUhzK0dJTnhwWlYwWlR3VS9rT1VQdENJSGlxcTAxS1lPREVrUDlMWk1P?=
 =?utf-8?B?NmMwTkUzaUVVSXY0TlRjTUUzcUN6SDlUWVFuM3Iwc1Z3WmswWG1lTUp2NVpU?=
 =?utf-8?B?M01xbmhhdmEwMEdacjNiRTVTYlVUZW9pTTdtSkJ4clpBcmJGK3YxOTMrVmlj?=
 =?utf-8?B?bTd2Nm81UzFHVHJ6R2NMS2RyYXh5VHdjTGtFbDNLbjVPKytGT25mRFpzU0Fi?=
 =?utf-8?B?T2NYcFNaMWUrRDBoU3JFL3hueW1MVlY3Q09jN3FJeHJYYUUvTVhuUWc4bGVm?=
 =?utf-8?B?ZXY4Y0VFVGJvQ3Fnd2IzeGVRTHpad0tKUjBmWXRwSysyVUoyZzNQMVVrNTMv?=
 =?utf-8?B?a20xRmVCRzhITHlxaUw1S3NkRFZwcFJuZFgzeVBCQWNOaTNHWGRmcng1VFMw?=
 =?utf-8?B?SXgrWDhpcmVucitJOUl6bXAydHViYy9DSVFGWS9icHJBN2JjRXVyKys5UFgr?=
 =?utf-8?B?NElqNXNUOWxta1NIbzNFdFRiWE82eFgxVmdsQzlDUnpBWS9iV0YrTGUwUVNP?=
 =?utf-8?B?Z2QvdzRlQnlBZUZJK0VNaUNaREpMbGM3VWRqa3QrS3dhVmRuRC8yd3lxckVi?=
 =?utf-8?B?VDdTcHNzWm5wdXUvMUMxcitaUXY1WktSUFBpajdCaCt2dTR4QVE1SjJPY05Q?=
 =?utf-8?B?Y0xiVlEyYURlT2Y3WHhtS2QwcG9VbXk0U2xSSk5jVW5GN1Y1TDE0cjVwby9O?=
 =?utf-8?B?ZEEwUlYzVGdUVGY2M2lldXJmSXhrYnV4TTJhd015Y1l0TmFER3JpdXJBYzNi?=
 =?utf-8?B?ZGdRQ0RMWkJJWnFNOS9jYVM3Wmg2amhxOUU4ZVB0OXAzbGxUOUJtNnZPSUNO?=
 =?utf-8?B?VUpYc2xmVFJVRUVsSnN5bExMcEtZOG5RR2hQN0RiT0FxUEE5NFNLQzRkYS9n?=
 =?utf-8?B?RTE1Yjk1L1kvd1JHVEtuSmM3SUVpTER3Q2pURmpjSDBhQlQ4UHgzVnVtVkxk?=
 =?utf-8?B?dW1pN0p2dDRaV3pReHBpV0ZabTBNNkRBREZVc1pHTUFjY0tMbTFoQTNqY3I2?=
 =?utf-8?B?eHdFeitEQnVSUUcwcGlYOTgyUjl1cGZZdklpb29BK2ROYmxxanpkaDZNT1BN?=
 =?utf-8?B?WXl2TXh1bUt2a2g2ZGN4SkR6Zldsa0NoZ1Ywcm1YWFJhcThuVFl3cEd6S3NV?=
 =?utf-8?B?dHJrYzdualhkMUQ5dVVwc3R5L3RaODlOQnhPell0dVJ2b0tKNEpPM09MMVpX?=
 =?utf-8?Q?Eh8KjwA+ctoi1Di5diUbzAQDGiisBTD5kI1Gz0o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3eebe55-4f54-46a1-04ff-08d97d83cc8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:27.7471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieJ5u87AcqreyyUmSlafibcH5pHe8OGeZWRon9rTP34UI09VjANce9xwBVbM+EeCXVrO1hwY76gJdoIpUG00qHpufCl4FKIHUtD3bWmcQF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=946
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: Zy20fhxhClNgdNxQjulEdCbtdbVjopt3
X-Proofpoint-ORIG-GUID: Zy20fhxhClNgdNxQjulEdCbtdbVjopt3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 10 Sep 2021 12:46:10 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer req is being initialized with a value that is never read, it
> is being updated later on. The assignment is redundant and can be removed.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove redundant initialization of pointer req
      https://git.kernel.org/mkp/scsi/c/914418f36901

-- 
Martin K. Petersen	Oracle Linux Engineering
