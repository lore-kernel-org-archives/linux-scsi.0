Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0734C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD7F61156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhIVEqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46426 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231588AbhIVEqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:34 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4QgFQ027984;
        Wed, 22 Sep 2021 04:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=K+IZn1MTSDJnck2cv8NzK9sOM9ZgDbd4pBkHfSnKLg4=;
 b=cKqfMrsQD/AnYliDTRdfWaoTiH9yFEcoFssEp8Jq9ko+hPtKBTiyrAwnKAdlKBs6F3m+
 KFBzuI0tmV7MyvR+7YLKSdVJe+CdCvO8o8Kx38SgNMhiyvAAXFLClVmxuUKXuSVt0EIg
 M2N63T9py+KOlkPa+QeoxABdcFADETpbis+gsb711y9RIKJeXsYGn9lu+7J9//6VKph7
 n4FNgbbNUXqyF34bdJTpUCmgG9QXuKF9EwJP/Q0ENoslhYHIaYJbKVmuL7WJy/WZsox+
 Aj/2DR6zZ8IgaEQhvyJAEeIYk8Ahyye9ik33/CUhRJeKSrEe+BtYxeFzeeixG9/v2qQU 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9d71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4iwBn195776;
        Wed, 22 Sep 2021 04:45:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3b7q5bks3v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCx0kBu2TWOnD82513Y4Xa+QCasvecAjZRUEyK5NyCZIo6ouZy1XRvHMjLmK9JHq0Aw1FHAOomoaF027JsuAXoYyVfRqQYHrwPmDfP0XrAMzEBiWiKUt3/tWxPouaS8mIDOChIfcCFb7zD4lqQLo5xfj+fahcf1eVpQObRUp7ICeSb8h0djRnJL6dxsSM5lXq7X5xm87elGdc9ltzunbvcJ1+cmnm734LFEjjUvqfXHtFulYfk2MyaSurq/AmU6+yFy6vdC3F+C36KVxxdKYR2CvAnwyninkupT/DmuKTCiUbcS0oiTgTsAQlEJDoQg2hf5UM2mRRI2D3hcql0c/Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=K+IZn1MTSDJnck2cv8NzK9sOM9ZgDbd4pBkHfSnKLg4=;
 b=ogsNsHWIX19n9z/dfiD788YYUhXZEUjWwskaYicRLo1zRv5qi77MYCI/MCvN1LlEvjn7Q2WBobvrnRxQHxE+ZoLbWxM0BV7MpfLY/gBhgwU9RfKmlxEysBwbOTOT9QY2EO3EyXvOI0bJoz8SyKTu/zvXIoO4y1mipiudYsoBKN0d9mfe2IQ/iNHOjH5HBLvEPhiBWXVKQlURwfpxlO0lDucakDdgsTPG/M/ZE3HaapaZTgN9cxUqVeYxqSMlfUGVoUeuLuRl38BEq+AudVy0Dn8r1R+8+9SIkWZ+GgmsJBTEhzwGM+tcUOOR+JzQR4v28bkJEfNESDS54Qw5Am8nUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+IZn1MTSDJnck2cv8NzK9sOM9ZgDbd4pBkHfSnKLg4=;
 b=QRKf+VNFmKC9jQkRuQhOTYpdtaIn33xHgjI46nHzuKbDTcti/dWB3EYwsTvPTILBqfdjq76itqX8evL8jzHHIUqXxv9TSk0JY/C6SslXhU3dYw3otVphAvtkbu0sZy1eHjn7AmRT7fAEyw2dNS3YIdksk7nbfTtUuoSdJIlTt5M=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:45:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix spelling mistake "CONFLIFT" -> "CONFLICT"
Date:   Wed, 22 Sep 2021 00:44:47 -0400
Message-Id: <163228551953.26896.2559798529557281213.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210920183206.17477-1-colin.king@canonical.com>
References: <20210920183206.17477-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:44:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bcda66f-a71a-41f5-ef9f-08d97d83bc2b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4518EE597E9A6EA6C73C05CA8EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKUYUAGxUvZcA/qLBs7DhTRnu/rp6+Bfzu2wSqRSN4dLzydx98cESQb/V33QqRJZa7ELoaRnXZYp1MeffsiGlGPY3X0NDyDh6Q83Tj/3zG3J14nQ02oLKpI/h2nA/CZ71+JC4Ew4FRn9wrySqlN8kmYIw7kCfd7LAi/GEojPK6yNIfXg+P3sX6kQI2gIdZDNtUdZxGe4sym00RyVc05mWYZSw/bnEr1h96CYpjc06GmcaNCagZC4w/RhG13j6qO5gbYxWzlAwQrlnaEH9qR3RcXwG3Gixo6z2hycZJlATnpiY8cYnqtsidsdrTlFWi5vxJjlXG1vyGkMzZiDw45mwJkGSfbSabdNR4O6DmeM+u9xb25G2ZH+Us4xElxgYQfm9TmwozbE+mXS2pSzMnALj2Rj6XVEsCPpF1oySCycEeJ4tTIzxy8CgM4C28gnb5gPtQQdnth8iMznFT4oytELzXCuR+U0uj2vBQTIocB3Uccuk9zQ1PeNas+2kPRGpmCOb1JJtIj7xrqFw+vcZ1kGo+hAgLyeUZQmstZwIqGFYyXUm0AH9HH5Nxs8cbBKFjX6+Qyb5Bd17Hszr8un0XHxgPCSvyusk7Zq768XFiVd1flCXpol0/QEcmPvHW7ZsMFwpr0pi86CoeeHHkdMFELXhDue7Yun2fO20lxZpCQvccNQfX5Dl5VQlXM3e+4h73SnaP8Z0zhUBXsfUc89ySouJtQVVcu6REe1+N/X9Sg5QQYoW+ZtfgMAoULwgFUNc1xrCSROvaQABi19NQx/EYDs7dM5Iq7KuTs7kbhk7Tka89A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUN3R0tEdWlteVR5K3dpK3BqOW5CVXByOGtwaGh6QWdlL2pqamUxYXd0SW1h?=
 =?utf-8?B?NHkxUGhxcFFsMG00UFBVMVRqeUxXWWlJT1hrUXBHQUdUSGR1ejdSaitGUXlY?=
 =?utf-8?B?Zk5YSk42WVZBSFBmT2xlU0IzMHpQejBacWtoSDlvcGxMMG0zd04yZXVpZGlm?=
 =?utf-8?B?Yk1pNitkUDM4VWtXR3N4VEhtYUpsOHZhemx3RUQvM3BzZWsvajhBN1JaaVNn?=
 =?utf-8?B?Y2xwTHNYR3FJbFJoWHprc3RnTlNweTlqbHZMa0hXZ2Q3NjkvSlM3anhvQmVG?=
 =?utf-8?B?aFl3RTVQY2FCcWZJbjRZNW9Qb1FnRFQwNTRVcmpPZ2QyUFRsZGVlL0Q4YUN3?=
 =?utf-8?B?anhZS0Y3cmxxYWdXYS8vb3N0QXZJR3NQRFp3U25VOXMxUGk1RUZhdFdvdFd0?=
 =?utf-8?B?L2pVY1JoczMrZjFWR0F0ZHpiSThWNjFLdEFWZUhqcm1MTEdrcnU4MGtBTnNt?=
 =?utf-8?B?WG9vWmRQNExkNys4RCs3UUpSQ3RaSzROL3JMSGxlWGZncDhLeW5iaFJQZWJn?=
 =?utf-8?B?a2tUbExOeFl5ZmdXWW1mS3phU3hOeUFwRXVHRDZXVlhpcVpsS0lwZ0NkcHNj?=
 =?utf-8?B?aFNuVTl4bXYrL3VzV2NHamJEeUpxWDRqRVpweFk0OVhNYVI2d05jTERnYW1p?=
 =?utf-8?B?SkVablV3Rk5PWmttUXcveHI5NEVUcHc2U2xGZFhLRVVndis2QStvUG9UY2Yw?=
 =?utf-8?B?Z2tha3JoR3dEWUxRUnNCWmxsU05tZ2hRVGRDcUFNRVdsMTlCajZJS09hSTFi?=
 =?utf-8?B?S0xHVldUYzQrS01UN0RyYkZ2c1hodmpqbWdWZDQza2hydk1WdmxQZitjZ0ZT?=
 =?utf-8?B?WDVDWEthQlFZV3lrbGY3NnBwSkhSeUMrdW5HV0crR0VkMDVZWTkvc2JNRzdC?=
 =?utf-8?B?dzRVNmNqOHhIMDJ4WGwwT2YrclZWbnMyM0sxelplNGdDeERVQ3VHUVp6R1RV?=
 =?utf-8?B?eTVheEx3RWhibVhuL1F1MG1oVVhNVGpJOUU1cWx0STNlUXRDU1g2b0FSZGpt?=
 =?utf-8?B?UGZaQmlNWndmYzdzMlR2TC9tRnhhTnpKSDUrcGtXU1FBbXJabmtFUVZDZUY5?=
 =?utf-8?B?cXphMGdHdnBzbFIzVDVzZjBYWmhRVmc2NzV6V2xqRWhHSW9yMnV2OVZUVTJR?=
 =?utf-8?B?KzY4cTIvUExKZDk5K2hBQ0dFSDJDd0hYMVZLY1NpWlpCbSsrcy9odU1hUGV6?=
 =?utf-8?B?czFoNmROL1hEVUFWL0h1azZBdzQ2VmRveGZRSDF2bTBQbFFmdTB3V25pTWhE?=
 =?utf-8?B?VGNrVHB2Z2s5SUVackE0VzBjYmU1NXR0VkxJMU8vUjlyMDlJcHZtNk42UGp5?=
 =?utf-8?B?WWtvZDVGNWtIdERYaFMyV2J5VTA0TEp3SDFVNExGS1VFaCtqWmExTnNRNlI1?=
 =?utf-8?B?MVVVcDY4V2dKeU9ya1FURGxKRDFNTERWU2NTNkF4RUNXWGpuSFpYRDRJcFIr?=
 =?utf-8?B?Ry9ZS2NodDFrb0VHZ1NjeWhGK0VvRFk4NHRoK0xBaS9ETlJVSnFyOTBVcjY4?=
 =?utf-8?B?K05TZlphcU1uUlluaFJRZ1ZEUlJZRDhvUlVpdjVaRVRjbnpjNTZDVy84Sit5?=
 =?utf-8?B?SDZlL2FMWDBZUGhqWi9EMG0xemU2MHpCTVBxWE5TdWRoeFpwOXM4ci9IRW1U?=
 =?utf-8?B?cUg1bHljUkx2NXVaOWhidTZDa1hYVFdKSFdYV2NNb1Y2MzZxcll4dkM0bU1J?=
 =?utf-8?B?V25vQ201U24weWU3SSttM016dVZLUUsyL3grVHZnenA5YlphNDRHVGsxNElq?=
 =?utf-8?Q?+FNNBH4Mxmo+szIEFVNnMJrAtMY2rBuVnClUZKE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bcda66f-a71a-41f5-ef9f-08d97d83bc2b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:00.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2loVsMCt3YsExtTUeDVIWFtJoe7Lfw+mUz8e5dy1HeQRlvQSPV6syKYzx6j2WM2630HQjBBPw0MT9XARmnC8NZxwRg2fDXL0SxJbjHLCO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=770 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: R89db7LXS_Em6pWIHMkDf6bb1RTZqdFk
X-Proofpoint-ORIG-GUID: R89db7LXS_Em6pWIHMkDf6bb1RTZqdFk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Sep 2021 19:32:06 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a dev_err message. Fix it.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: target: Fix spelling mistake "CONFLIFT" -> "CONFLICT"
      https://git.kernel.org/mkp/scsi/c/9a8ef2c73c72

-- 
Martin K. Petersen	Oracle Linux Engineering
