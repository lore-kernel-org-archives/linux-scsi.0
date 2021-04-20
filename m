Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC7DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ABB260C3E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhDTCaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:30:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57398 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDTCaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:30:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2OeTj183180;
        Tue, 20 Apr 2021 02:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4ObVr4LUNklCDazU0rJY9/PagalYMFbQ1gf/GpLr7rQ=;
 b=p+TKOkd8F9uMdixeVeN+Fy2pH69EwpfL7aCsRZ8nYXv/i7RrkwcxF6itnTU+ejsXKTtN
 Z4eYiLhfGMZwuz3uD39h/Y6BpVQiGYfwHdB/GIS7KZRbUbW5uiUd7CI/7t+DhmYGEEE3
 w5avfjb08PEonD0nfpvCytdH1cIlZ2NvbmEyY0bLbczJAPN0kl13c3LTGAR2R+6ga8jF
 s80w4aP0xpOS4My5J1lIw92hxMkutIx04eML5xESgCBtHMMN3E+XGP4kAYxWrXCuzdwO
 ekRmHtzNUqHwy82q0lDKjm4Ok+8I6wb4u1geblwyiXbCqlKvVKpBFW3cpE60c5bEth29 xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37yvead8bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2Q4Fn190210;
        Tue, 20 Apr 2021 02:29:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3809jyneu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyZqMsTt1dm3c+LFIsNDBdkoWErPQWtscEKgEoVAW+zbyQqxO9tqH3s8WiY838aOTLAd1rjs4BQeLqmZ+iu5MOrwUUgwVjk/wo8rYOIABiLfykMpgfy/iTkqn9a+Dte3GOqcjIpWudv6WjHH25lOCz6EPnOWB3NcOfyTIGVjuE5G2q0y9Xjp+Cax8rUoqjhhNaU/I1xVNRTQV5YhiO3s6+Jej9tzstZwn13xj3FVFm8gBiwJuqxdG8LtUq37B5eO9YKMgU5wwCRXENHyirUZSj8RQGKvpK69vmxjZZ+opizG5DefNFhEy2lbSigzlWKraOmv7UD5eAh3ILQfP/016Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ObVr4LUNklCDazU0rJY9/PagalYMFbQ1gf/GpLr7rQ=;
 b=ZLtlZ8tHTGJ+5YF5CMenthTlWuodBWRIdNL/Oizq3VmY3/NCQTjq+3VwPTwYb6uV1WYwPAIgQe8VgxLWQhoFajJXrHASm/Ud2dpgnDDZXGn/rxPEyS2bCbV7ETKNESuzQA29HDWJwlGeJFnb5t1XSmfsIZ7DRTqSy/wGxqGY58xcMIhbPusOU+z1kZ4k9lhtNrAHX1pznT9bSbs0Wti7LFEddYXEjbVmuCuHY7GVcSwaMFb4bEvZiZP1onLQAhuTtf90CMufnM04qUuFZP0il5L9RLCgdtCXqdY/L+Sp1hZVMs6scp9RWql/qhkglZ1hmhmfnc8NLuQrS4+R4S/XDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ObVr4LUNklCDazU0rJY9/PagalYMFbQ1gf/GpLr7rQ=;
 b=qttF9DhQzif5o92crts8WJZRE8Xxx1ZJEUYkbCAhxK+0qaiol6300ymSfpU7BuPfanptMpARNoSvJ+tYYSB8eelVOu2O0DCSpu/gQ5+9CvPYXhwUGbf3dOFrUM4LNhkCFPiPCTqUsrHoJ/QYEoZfOa+xM3o7LS1f+sleDpKoyj0=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 02:29:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 02:29:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Yevhen Viktorov <yevhen.viktorov@virginmedia.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/6] zfcp: cleanups and qdio code refactor for 5.13/5.14
Date:   Mon, 19 Apr 2021 22:29:09 -0400
Message-Id: <161888563603.11594.4762592088448632971.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 02:29:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27a5194d-8193-448b-58c2-08d903a4186d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47752F8C495C74D2B7D590EC8E489@PH0PR10MB4775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jUJPAF6QRKhFuzLbB+vfTK/OnjCFoUlsYJxRoqBKZXPTHjKJdj+RERmByVpS6QxFMxQWRAFFd0v0JwpqojZz8ZBqFkgfI7kGecJ7oyI/Bb+1D888td0uTwaa26iT2fSXWqIphYx/bJuZHHtPLxJNJpljP54QCsw68wQ0iFXez4cAPdTKxyNYq/CW0RYreqDGmrqKmcJHnq0uBvosSbq166guFG56/STDiYWDiqU9FInp4SNsK4fSuAQIIfNKHf6JyC5KF4Nc2Q86RJK/2BlEF1mgmyRBjCnvzQLRg08mfHsn26LfDU3HyaTu2h9ztLfK7Dri3+pOgZD8vtpLPgxNRHT6kNH5z17MEhNf1DDLIx7wKWirALU4dyk6T57rN0/mplbNXlHpxAJIzvhOao+nVxF4NuWCbAajb72Do2t617t7Bhr5yQiPtbNHsFCqgyLcPerwUrxG8s3MbNYWAson3JTa9dLmb7iugvhHC9KPQu8zFYvOb+3IEOhNBTCSGEgqRJyze9/E7B9i0JViy36Qx1zxzpa1HdCg9JiiGPbztDJE2tEQGCojV+XrUyqVtWsHGGYBG+RaYGsmROF/Le5p5qY804T0kx3mYHqclE6p7jRCd1eGEsVHh0phACHMpVUoDegRnhvAIaLiegO6xkasqxaBUvUuKHLHB0V51gtusgZT/PXU0O3n1ffuERCv0JlNLLRYJ8v+oP/p16ObG/5hcGwDmPT+QGmhXD3XEeXLto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39860400002)(396003)(136003)(26005)(5660300002)(86362001)(186003)(36756003)(7696005)(66556008)(7416002)(2906002)(966005)(478600001)(956004)(38350700002)(8676002)(52116002)(38100700002)(6486002)(2616005)(54906003)(83380400001)(8936002)(6666004)(316002)(16526019)(66946007)(110136005)(4326008)(103116003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SW1xdjlaY1M3UXgybDh6Wk5ObUs4MlJWSUwvL1FOV3pGd2VhbGZPWEx5M3pT?=
 =?utf-8?B?VnBrNDNzSzJWMnpGeG9zbEpUS1lieVlXTjllR25QeWZzN0JmUDFVZGNZOE0x?=
 =?utf-8?B?aFhCWFZmRFhrNE9aRUsxT045UWo0L0JVQ214OXN0ZElxQnZDZmxEdUpWNnRG?=
 =?utf-8?B?WFRZbm5zZGNOdko0K3lxeCtWV1ZXOTlUbnhBaklqOG51aDM2SFVvbUFvTmk3?=
 =?utf-8?B?M2xXdDdwbFdjQ1kwZ1VqOVJPZEJMeUJWcVdFblRKUGNTdTV6STNCeCtIL2c5?=
 =?utf-8?B?RVNvVVRRYmJvVktYWHJLdXpzcGFxeUlvZUdSN0VaY0h2enloUjVZN0dqM2Jl?=
 =?utf-8?B?amY3V3kyT2trcHI4eWZCaUZ4UllvbFFGT2FoQ0ZiVUx0ZkpqRlUxY2JvQnNy?=
 =?utf-8?B?dndkWUovQnVYcmxNVTVUWFR5Njl1Y1NYQzFYVnRqMC94UEZsaXQ1dFYwdUVG?=
 =?utf-8?B?VHcwN25aVURDblBtYWdYOXVKWmVFTUc1TVA3WHhSbGwzT2FaWWd2MU1vUE9N?=
 =?utf-8?B?aEJFU29oczlQeW05NTdyZFFzc1VWM29NZ3I0Sll1UkJtZ0t6dkkvZnMvNHp2?=
 =?utf-8?B?R0lYcWRmVEhxQS9mVW5GL1g5RUEra2Rya3hmVmxNVjhvSzduOGNVVkVkNElY?=
 =?utf-8?B?ZnUxVC9BRHhvZHlSVU9NWVIvQ3dFUVhvSnp3Yi81Zm5DV2FtN3NNL0JxL09s?=
 =?utf-8?B?TnduaUpISE9iT285OWxhSDVydEZqZ25rNk5ndXpFVG1hT3VQMmFveXhoR3Bt?=
 =?utf-8?B?MytqcDhOKy85d0pSUCtHUmNDRGpxKzNaclNoQkpqWUk2MkJqNEExRXlSenFn?=
 =?utf-8?B?RnE5RW1OZ1N0ZCs1a2RTZTdFd0k2Z0Vtb0ZWdUFEZnNFcFBHaFUvdW81cW1Q?=
 =?utf-8?B?MjhjSjNOZUhOaVZadHFUL1VvWDNPLzBsKzlCOWpkcWhWSlc3SlFwSjBhR2Ja?=
 =?utf-8?B?eDBjZjhGbW5DemNBcXQ5WldDUmF4VVlxbUJnUU52V0RPWkpzTUVZc1RiUDZS?=
 =?utf-8?B?L1diTGVRc3M3U2F2dTdIdDkyS3Jwd0ZGSGVIZWJremE1cysyREJFRWI1MmlO?=
 =?utf-8?B?eVVQT0dlNFFSWHJOcTFOOUllTlBHSDFSTDVVS3RtYkxZc2JReE1nZWU5dHd3?=
 =?utf-8?B?NHh4ZXZmc1ZwNDFSY2hwOTRPbmRqZG9jYUl6Rnk1U0FCRzJ1Rm84RmwvenZL?=
 =?utf-8?B?cmw4NVdNeWloL01zMGhWMEl6d2YzdGdadzIrWkVTQlMrdWp5VEkrS1lPS0xq?=
 =?utf-8?B?N1VUb0EyekN5SjJueHJyVE9oRXVnTUhsblBvRUM5dTdVNG9ZOVF0djhKbFlI?=
 =?utf-8?B?RE56eTM3czlaaWcxSi90M0QrYXhoTEVKZFAzRmUya1N2NWFUTEVCOHE5STR1?=
 =?utf-8?B?SWZ4L29CeWxUTzRUOXphSCtTRmlXVTJKZUlhT2NMVldtcWc5bkJWK0dWVWMx?=
 =?utf-8?B?UnVsMTU0dGxUTDR0b3p5cExyeW55RktRZVRjRE5oZGZXMHBZYnd1d1B3ZE9q?=
 =?utf-8?B?WkxwZHBDcUFHbG1JRSs4c1NicEU2R2dLMGQvOTFRdFFHWVVzOWt4M3ZHbHNY?=
 =?utf-8?B?YkUwcmNWc3kxZ0xLZzQ2RGtwcU1jYnJHTnJ6QzN5SGJtM1cyZ1VGNlRNcE53?=
 =?utf-8?B?TEowZDhVL281QnFBK2xCYU9vaE1YNEtaVDhtb3VkZTRMdVZORnUxbExreEdx?=
 =?utf-8?B?dHF3azFlNVZpdjNtRjAvV29Fb3pBd0tjalB0RlBpMUVpN2QxMzRFVzZNTXIz?=
 =?utf-8?Q?jbj7fYW3LEpWzp0RacVzz0UHjNsNKhcoHd7nmGd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a5194d-8193-448b-58c2-08d903a4186d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 02:29:17.1026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFX8H3omIB/1v+8nhl61XQTXiXM6f5uI9fA5zxT7neGFaxE+4N/DsX5Po3jOQ5yb3SxIUYWwUaE1uxrfeqWF0Dh300T3cpdZTKdVW2cOxWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
X-Proofpoint-GUID: _rTroPerq0jzHkP7O1P3jAlOea4ZkGE6
X-Proofpoint-ORIG-GUID: _rTroPerq0jzHkP7O1P3jAlOea4ZkGE6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Apr 2021 19:07:58 +0200, Benjamin Block wrote:

> I know I am pretty late; we have some patches queued that I didn't come
> around posting yet; its nothing world-changing, so if you don't want to
> pull them for 5.13 anymore, no worries.
> 
> Most of these are cleanups, apart from the last patch from Julian. This
> lifts the handling of our outbound queue from the common QDIO layer
> (common for s390x, that is) to our driver. There is more details in the
> patch itself. We already did the same for the inbound queue handling
> some time ago.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/6] zfcp: remove unneeded INIT_LIST_HEAD() for FSF requests
      https://git.kernel.org/mkp/scsi/c/91cf21ec6d04
[2/6] zfcp: fix indentation coding style issue
      https://git.kernel.org/mkp/scsi/c/8824db894dd1
[3/6] zfcp: fix sysfs roll-back on error in zfcp_adapter_enqueue()
      https://git.kernel.org/mkp/scsi/c/ab1fa88062f8
[4/6] zfcp: clean up sysfs code for SFP diagnostics
      https://git.kernel.org/mkp/scsi/c/20540a5645f0
[5/6] scsi: zfcp: move the position of put_device
      https://git.kernel.org/mkp/scsi/c/be46e39ae3be
[6/6] scsi: zfcp: lift Request Queue tasklet & timer from qdio
      https://git.kernel.org/mkp/scsi/c/b3f0a1ee9e39

-- 
Martin K. Petersen	Oracle Linux Engineering
