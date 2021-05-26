Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D92C47082
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62076142D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhEZEJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57230 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhEZEJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 May 2021 00:09:28 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q47Wch004780;
        Wed, 26 May 2021 04:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SJdJzdFKTgT7XIiIN6p6etVKpzJzvxd3xEVaqmf5tQw=;
 b=zfjH5KLPQl2onzK3xyjz9LP14caJOLS399mdlTPFvGPU1W3qqieksCDfONi0ehmxBhkJ
 J7f4Iamvqlm1Lstn0aAhtEHIgoyEq33yNH1muZyvnsAm2KtgkpDRXqQZXmanPbdW9YOm
 8c+rXcqfhPx54JacusakmLpKsUuhOOlUwEHWj01EYjzHkOkTV/BEZSRB1Ca9c+d/4mtB
 BRqjLDkdBY5miBAWsemQMl9chj+kFllns0g0WGXOID4emIA5TrkKeDDvxqBz7K/qNK9l
 CRXOH8D0iqTMhJEKhYpJQwJZ5UKXbor2sjqs5yqgEVxE4n2b/to5WpkFHhY0n9uZIqHb Tg== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38qxvxrxpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:53 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14Q47oG5145227;
        Wed, 26 May 2021 04:07:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 38pq2uvw7d-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au8iGmwpaNGJsAiH9FsbUaIk90WYQa9Gjg3e3o9MRwQsE2XLvJDmRwLfjAQxDuJdsuN8tqHOFugRIdHUKugZ8cW+KaO60DzXiNuKt3oSOFYkgjytdnfB4IU85toALl2vzasUmIGNJ8c5iA1XMACgpI8apGA85Qq3MddMovd9V1g3pCKn5IjixeSIV2Na1uoYdRTyR7B81a64g/qOt2clloxD6kXbXLS3VB+RW7I1vkyrJrg++YaUzXfvKDjqKfwdmmW4O0ZydLOAZjO2sFJDMnhQ6e3qWcsZ59OQFlj10PHXThvzdX9irmSkQAf0mbcByJ292KWhiLlqIfOMafrsxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJdJzdFKTgT7XIiIN6p6etVKpzJzvxd3xEVaqmf5tQw=;
 b=UR2jRL8eUlGGeR+VcQ0he7fUASpA87dj0t7rJSojvy9GFxYehvK+fj83k6U+9NvnxNsOllO/huHwyq9T2Df13TpPbJl0pVlBFiMgvWF/OD3wJ8cIyWXXj2uEFxwY0QuoeiLzDyk0r/e9x3hGpwLqeRoRbdSp4UAeVzHgohYi3d7il8+5mb1btrkS5wivSTsHnt7IqhaqBXxuSdyOI0F/1q3M4dcWH2MPVRaaUawKge54PW2EdPBuC1HxsrZAIgdyOqw775Hj50NxV2UeA71YlGjiGLMtnWRBqOkTuQeuZMwj2IcvLTo3ogrL0sKsDttMXA0fqSXDfFHJidT8JLjs+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJdJzdFKTgT7XIiIN6p6etVKpzJzvxd3xEVaqmf5tQw=;
 b=t5awnGw+cK7yLpQLFNbi19dBSUH1Zv4WnHPLwllZ1/kZJZObTKVvKt8faYOGblDcaQEv5JYOus7vdXT56VkLYyrKvw7iHhHo1jZpQh/Dy1wOqFQMhdkF9j95gAoRxgqR3OUt8UzVTmp6QToOGx/oao8AZ3rYgGHGEk0uRCFftp0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel test robot <lkp@intel.com>,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] scsi: target: tcmu: fix boolreturn.cocci warnings
Date:   Wed, 26 May 2021 00:07:28 -0400
Message-Id: <162200196242.11962.9476471574342620308.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210515230358.GA97544@60d1edce16e0>
References: <202105160749.IImZN2gL-lkp@intel.com> <20210515230358.GA97544@60d1edce16e0>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd551476-8179-47e1-67a6-08d91ffbd438
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469FF9B5EFEFFCDEA1345CB8E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZfNaKkLLKJnon0fSSpJvlsl24+ogBJrru80YFYHIkZs3GgENDcYSpcmrJV3FE1iJiOovU7euVlq/0TduH6Vlbr38GVm8wAlinz2s7hfaRp7WGqirVnWwF7vN/Vdz6aLGQoDIeMtUcGwmH1MhNtZn7cEB9YdUKqtjRxFVMiZZIaiV28ceNXVK5EGa4Iw2JRe81gx7dxnDCSjwC5mks4g7e02FSLlf1eE8Nb2dJkZ+0jHJw3l6YTOlx2k50t/1S4JkIA+uui6uO2U3ZWFV7/52V7Pwg1pjissHapUxie7OoxDe2BEP3zt7fF5vXxXJQbHKHJYv21/GHH2chlmkCpWt6IOmCYjdiaUxeSnkfJDYTdJTeSW/ljmBXyF6C9Fvk5qMzelbs/bcqrybuklDfV4m8Z4yBzPM67LpFY54TMa/dux0AiJ7Q9Hhem4CDvssk55jO8cFn1AVMs6P8c3gCoBRyxVGx+U806orNzT1/j9Vl5/o3+okNqe8LCNflAqlFwQszmj593fuTxcZ5S5mu8hzuJtyqhf7AGdVzi7M7rj6o2TvMuCC6KX/j+3VdHYtIGNLMYiU4jCc3W/E3N8M+rc9vEAywqi8ks1FdGNREPVbY0u9nQujSm1deKpEtFnOD3bAdDy3ONUZVjrBNXxfz5XVcbGnIOlOi4/IqKtQm3zoJ4el8sDf+UgLOtjGwR36RUUj9NFZDQDxzcZEIoGxHYU+jA4LO7WSDUXsQdq+EZsLmzVrQfdKO1UYLG61BFsYlr4BY7dGh/2Eo8a4i54KyR018g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(110136005)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SHpzWjZlSzJISC9zSldMb05rSUo5U0FHazBDcGdWakVYdjFmcHlxbUNWaGs4?=
 =?utf-8?B?ajZmSm1UOFlPelAvWUUrWlREQXNvR2g3Vm1tMHVmYS9OZ0NwTVhKZDJvMy9j?=
 =?utf-8?B?S29iMFJIeHNJSnJtVWVTYWczaGdHUS9lbzZ0VXorcDFEWU9FZVdYdjVFOHZM?=
 =?utf-8?B?REw0ZHhHckZvcVhCenQxbzdqdnhQblNPYTF2cGhIZS81SmdFcUp0c3BCaG5W?=
 =?utf-8?B?Z0VuSzVIRVEzWHluUXUrUDFpMExFQmttb0FuM0xoV1BpcHRrKzdYK0N4V2Q3?=
 =?utf-8?B?cWw1NW5JY2dKT3VpQWhlT3hncTZUaTFQWVlmeE1XSGVnMkJ4RTNzb1F6eWRY?=
 =?utf-8?B?cENHQU42QjNjKzlqSExsNUNQK0Z3R3BEZlBTWVFpZFNKN0YxMldXVW93dzVH?=
 =?utf-8?B?RGxKelFhK1pkekd1S0REMnNWTldjNFVNTUtIQnB4b1QzRkhQN1lUUTJJZ2s2?=
 =?utf-8?B?eWZvcGlyN2JKZ3UxelJqb2M4Nm55eGxJdlg5UUJvQ244RnRXSHhqTlV6N1pW?=
 =?utf-8?B?TUc0ZmtyMXByZ0p6MXExMHZ3bnRjS2xLVmY4TlJyU2p0bm9yaWVHYStQakt1?=
 =?utf-8?B?VVhVaDhzZDVzZ2lCd2xsVWFtYXFwRXJWQ3BKL3ZoU0hFZHByWEsreFl6Z25Z?=
 =?utf-8?B?bXhGYW5xU3N5VnhJcW1jWThrNXpCbzQwbW14ZnI0YThBNFQ3K0dxbkFDYWYv?=
 =?utf-8?B?RmlITThjMUcwTWVCNHJ6M3kzaWtQRkNYUlM3M3N3NWxabzVXK1JFVmlHdk8x?=
 =?utf-8?B?S3BRSlBuNVpKTTNaWitTblBnR1lPdktGUnFIQWMvR202TWQ0Q0RPL0RxZ1BB?=
 =?utf-8?B?VWZFOURGb3B2cGVKeXR5bEtudjEyS2lJamhZOUR3MmZwQktJN0MraG5yM2s2?=
 =?utf-8?B?cHVuMUZWS3R1QTBqQklZMzA3MHVmcFR3QkIvejZzbjNnRFhncDhoVnd0R2JS?=
 =?utf-8?B?UkVIMTlCdEg1ekJaZU9pUytqaXljMnJTb0NpYnhMaWFBN1Q3WExLc2xIUnlp?=
 =?utf-8?B?cEFnM0JmK1NldDFLZlptZmZydm04SXJRdXBhNTI2WU5NM3FPOVhmSjRpSXRu?=
 =?utf-8?B?OWdydGZMNmZhZXhyVS9JSDY3OFpoTG5nckQrSVoxVExKVndMaXpnRUEzQ0NK?=
 =?utf-8?B?WDYraXZSWlpvdHl5YzQ4ZHlza280TEg1OSswb1ZheDFJdFA0N255aHNZbUhu?=
 =?utf-8?B?UEU5T3VlTnBQaUlhM0tVK2FvaEdmR3JvdnVJSnIzQXRabDJMMGtyaE9id3Bw?=
 =?utf-8?B?Q3l0RTA5S3BvSUJnc1FUZkdEYTNZVno2cTdLckZNU29qQmVhQ01RUHdTOVZB?=
 =?utf-8?B?WDJBK3JHQ1RrL1p5T01mbXVRVTZTUUdKU2JXOGpmRGk2VEV4UVZMd2dmNEhs?=
 =?utf-8?B?enZLT08xeXUzZjY3bTFzWUd6TzFpU1huL29qTXQxeWd2bTZCMzJ1OUIxSWht?=
 =?utf-8?B?TjhFc2IzZjVVRk1LV3lRQVFuZEhXcDFnZzBid1IxRGkwenE5azM0SEpHNTlQ?=
 =?utf-8?B?endKVDVuc2JyMGdyeC9wWnN1K2pPV2FFTEdWc0R4aUFtVVYwK1JSNFkySlhx?=
 =?utf-8?B?ditvMnRmTmFPQUNiY1JPTGVIc3JUR2FaMjNtbHpwMXpxUEI3dm4yQ2NDbUp5?=
 =?utf-8?B?dlQ2QWN5Vk5zZWJmeTkrbmFWT2xkWm0xdVhDZm1QajlFaTBqRGpjd1ZYczRj?=
 =?utf-8?B?WjJJZ2NLaEhXUnltOTJWbW1IRDlkZnJyN0ZMWFhGa3VtNVp0a1EyaGVycytE?=
 =?utf-8?Q?JrDtN/SDwT4+pnIEw1SA59dXshhFTUo7eTOyaqE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd551476-8179-47e1-67a6-08d91ffbd438
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:50.9355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aH6REQfqy8y05H/8OHGmLefOfgZxw9hCuKW4moQmbQeK8P+8DNZJt27vO4CwuZl2SLMDGvx4Hxqul9y7wwFlDzRpigp3U3LeU3SkDjc0ack=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: aU0u72e9GXqozBMQmDq30hJ6kuVWA-53
X-Proofpoint-ORIG-GUID: aU0u72e9GXqozBMQmDq30hJ6kuVWA-53
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 16 May 2021 07:03:58 +0800, kernel test robot wrote:

> drivers/target/target_core_user.c:1424:9-10: WARNING: return of 0/1 in function 'tcmu_handle_completions' with return type bool
> 
>  Return statements in functions returning bool should use
>  true/false instead of 1/0.
> Generated by: scripts/coccinelle/misc/boolreturn.cocci

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: target: tcmu: fix boolreturn.cocci warnings
      https://git.kernel.org/mkp/scsi/c/824731258b65

-- 
Martin K. Petersen	Oracle Linux Engineering
