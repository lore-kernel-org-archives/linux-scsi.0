Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2BBC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1346507B
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhCPDOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:14:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60472 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbhCPDOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:14:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39lmp168096;
        Tue, 16 Mar 2021 03:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DXP+2hW/L7amQTOnBQnaaqhCsToJbgDAjFevKRTngJQ=;
 b=GwD+STshBn6i2K/8fhfLLSZryQSZYnTOwsTkpHYwf55EWjLXJ1kVROYtOB8dhJuYpgvq
 DLzfB/8fOJbneZyMHwO1+LZ501ekS0A4Q8MSg+kVj76by/19mm8zc6pIFr5JZ+IrI91M
 22tc2kz+c3XyIQUbAR1uwRez0p34aryhhgB9q59GRq7G9BfMSB9p8BrB9cIHjqBN/+uc
 V67gmFk6e2C505P4Ncd26Bp+g6zpFjb4Z1iP8UaOAubyjwZZx8o7mVKRCfv2K2mwfGME
 6FxbPzMZBfVU8Pth9qEWvB4fkzKDdc7Ap6b/gLI6AxTyebgZnHnWnTmhUrN0nglTs4wS gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbe7s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39dpU138106;
        Tue, 16 Mar 2021 03:14:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3797a0nadb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWoJx3Jogu0+3HUshJrUJwDy5FkmKhCdBjWME4DJqavaEykShY2JISKZ9noCF3xzUxEWV17S2xolse0UnEzCeXgN7bfci8xwBorz0xE26Wm3kBdsT9+M0omYeLXjSzKjWY7oBRGXpjE8MpBSfOlYPxnkTfRZ6bKF5dXf0fp9KmSFbP/V+Q6IT7yS65Spz/HESjub5S371MrlEz5FF/OXCmle4txs+RP8QpoBIxRJWyvSydao2pPFa4H1JiFLBbsAYsXbATXFIWdMtq6X/lr+twy9UbJK7rJ2WTYuWoyjMmk7VNGifv+xoAMXeReqpRRjwdaXXgYqaqa2vsAovCo2Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXP+2hW/L7amQTOnBQnaaqhCsToJbgDAjFevKRTngJQ=;
 b=Sv8u/aJNjDuUUPRWcCd2sbi5VoRi36HVFmPhLUjcuRNFK3H8BEWckJuLBQwyf++k4CXvdMuuq+KGgU6ro/okL8lPYGZeHEDexNgq329+JykqGeFmTwShrHC048BxOS5D7cXjBOkutvFgW/hsqKyGlj+0xHNzxhfvoIPchvAmsDC5viIeTb5jPsvhY3feMyZDa8MayYLllY+CcysSaNThXKM3G/Kks25cSX4qWzxcKxu0ynOpGrx0JgA8zpEomsNbTrbKspPclT2qfmViR6HazBKeIOEg3mZNE0G5gKLVY1AMDxROLgI2ZpCG4kO3klzz36MmIoRKdJmThAMP1WrZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXP+2hW/L7amQTOnBQnaaqhCsToJbgDAjFevKRTngJQ=;
 b=jiJ2Zq5eI3UL3zfyjijQrBx9E73N65uEbDi26PJq27CCUTTAU3xUgV3+mRIALOITs0QVkkaK66FFU+VpUwpUplEn/X+QPwvAfM1dmKQWCsDH2ahVNWE12hEiUniLIDw3R5GZBIFMrqdPCj6l4ickJseLoDG0qXzwxXfYkjRgD4I=
Authentication-Results: mail.ustc.edu.cn; dkim=none (message not signed)
 header.d=none;mail.ustc.edu.cn; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:14:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:14:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>, jejb@linux.ibm.com,
        Kai.Makisara@kolumbus.fi
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Fix a use after free in st_open
Date:   Mon, 15 Mar 2021 23:13:57 -0400
Message-Id: <161586434245.11995.9802602851023582228.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311064636.10522-1-lyl2019@mail.ustc.edu.cn>
References: <20210311064636.10522-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0119.namprd03.prod.outlook.com (2603:10b6:a03:333::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 03:14:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da8f5db0-57b5-4f1e-8c7e-08d8e8298e8a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47095AB7AFCC409D824986938E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r2VWG8xTuiPxyBjrQB2D1Jw50VxNmvdq4jfuH1RYqVski48z1MNbCprqnFglsxbw3Regc7uaLrRtxZhL5ryVqyRHgpnX6F9o0BhOQlpf3tRtKKEkgclsGiXIyLCRd10ylTbzXlOk0TMyTF5kHnmKaKlG+S9xdJ9EmL/xELOP1vPmcMrzF4Q48BM1VCPldlYSYd3f/llCsqIDhK7ffqzUh+pZOoSauC+8IUpC03X2HDxo3flCMjpFPV7aAjpSN9Vv1eHuuCpv8Jyohc/fDZKB/m2W4IufpDcFg8rlgIypvI+8UrtWs0Wzh22xgb33f+OZHwbVJpsueb8XLduJpRZ+0QtzzTaHhtG/xBYM53hH/kPnQ+mlU3/UGdR1HSxn98PasBbwtCiivJXw6OceTr8PylTCNyCt4Vw8w36s53+e0q7bedWZXQSXYqOy7M46gv+tliu37NcPyj/QMlTUQyogsCIJ7BQZZs6pkUgh8lqafEHKv1alYzWRw49N603lYuD+E2fz0t660twox3k9bOUs0obJklFasbn/4mTISr4d2IE8dAGCSi42PKiKfFYJKhZsLJPZssQJWzZNVUaP9Wn4A0DnM1rbkblqCX9Xq0mBmJdkR8VwH1khtWdCaz7D3m7C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(4744005)(316002)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1dPZlhHTzQvcFZQbXFDSW1qa2hoVU1NZDYvQ0pjd2dOcm02N1pKSTFMRWxk?=
 =?utf-8?B?K09wSXhpbGpKK0VYUnNVaUhNa3JOR29Kb1cvUDJGZkpnZm52VGV5Y3BoS1ZK?=
 =?utf-8?B?MUtnejVlY3dVTW5NdVlxbk5kOWtxKzVpVHFORlJJRE1TaG9UL1oyT3dla2NX?=
 =?utf-8?B?MzZ6K0M2YmVaWVB3K2twNHNlelRyZlE3MXlSQkpzLzk5R0FGdkh3ekdodEJL?=
 =?utf-8?B?UGFkWlE4eHM0OWlyZzB3Ui84QW9QY1RZMk5qYlZxT01uUUxDWVF1WFpEbVRU?=
 =?utf-8?B?RDYwVytMNlZqMWpVdXZ0a0tEZk1GL2dyT0dHMWhNMGJ5UzFnMGtCMjY2REZW?=
 =?utf-8?B?ejAwaFNtakJtamVZSm9JeTR2eE4yUW5tUUQ2OW1RWFg1VmhxTjRBRjU0NEM1?=
 =?utf-8?B?MjBSaDZ0dkh6ZDEvQUZoVmR3ancyQ0FNdnF3YjkxYkZkTEY0MzVLUW9jZGlN?=
 =?utf-8?B?R3EwWE5YR1puK3FtcTIvaTZ6U1NIVytPeVRMTTJzQzJZWTdFUmJmM3ZaOXR0?=
 =?utf-8?B?U05HOEZaRFFGdENMNmJEU0tueFBNVW1wQytqTm1WRExvQU1aWGppZEFJaUts?=
 =?utf-8?B?UTJpckE5dTdacUU2Njd1cEs3bGJPc3hSMVIrZ1ZEdlllNUR1b0MyU1U5WXV3?=
 =?utf-8?B?WEFGK3h6NFVKVE5OTzNMZzNkbzNHd3VtVVVGZVNBMEg3NWxBQ1ZacHRkYmtT?=
 =?utf-8?B?dUVGM1dHUWpFdHRQc1JyRnhMdzBCK002VnBXM1NzR0tSWXZuWkFJQm1WOFZM?=
 =?utf-8?B?V3FXcnpHMy93eUNSNGl3VlFMQUt2blRkTnlPRll3RnBqOUViL0hRcjFmcFNr?=
 =?utf-8?B?U0ROU1dDblZMWk1FT1BrN1kvWlYwV2xOdnBPdHVOb2tVQzNsdWRLZ0hIZDdh?=
 =?utf-8?B?Z2JvOUwxc1NNK1hjVy9UTEFTaFgyRXJ5U2t1Y1RETkd6QXI3dk1OM0xqNm5K?=
 =?utf-8?B?S28zZkNlOW9HbWNyMzcvM3lwL3JuK09EVkhiZkpsRzVXd1k2YmNsK0lJY2hM?=
 =?utf-8?B?UFNTQzQvS1BHQjZQclp5UFFNTGYrbmg1L3ZvNG8ydlF3Y0dESjV3azMrVzNy?=
 =?utf-8?B?K21Wd0VuV2NVZHkvcWkrNGNTOCtoN3FQL25WVGFkRVBIU1ZGN1NSWUJXbW8v?=
 =?utf-8?B?Mlg1YzRCZ3pqalVVd2E5M3g5YlVDZ2lGTWxiVDlYSjRZOERNVS9QdnRHL1hN?=
 =?utf-8?B?MGZMa0tCZXl6YUEwVWJIaG9ROTJMcWtXaXg0Q0dkUXJ4dFN6NTNmV25TQ2ZG?=
 =?utf-8?B?MUs5cmliOVRMVmVFNVNXYVdxOTJCMzA5OGZUdjM3Mk4ybkREV0V4VDg5YjlW?=
 =?utf-8?B?M1pDQ2x0YW9pQUprdDIvSHFtd1p5c1pVbHJyK1doVDV2QVNVVExrTFZyeUF3?=
 =?utf-8?B?VDFqdzZkaitEZjZ4R3BvSDFlazhRVWQyenBJMGFoR1BUNit6Ui82aUxRUXZq?=
 =?utf-8?B?VUcxNWUwVkgzRTN5SjhoVUxIVStGNkVpdm12ZE1EYng2K0hPS1VzT0xPZklu?=
 =?utf-8?B?MGkzZmZsd3FhZWRNMW9lbkZhWjEzQTRyWnlDclFrQUtmbi9CSy9mQ3YvOU1u?=
 =?utf-8?B?RWZ0Tk9XVTlLYk1hRGdzOVVtZmVsUUdVbzVjcEttSHBlWDJvUUdFaml3Tm9s?=
 =?utf-8?B?d08zcWVDemxrcVdlVGRVTHF6SkM3QThWUVJhTE1XTzlVbVBjK1FVR3RqbFFy?=
 =?utf-8?B?eWJFMHVPaDY5QjJHZWJZZHNBWkVJQXdHV04yQ3hTQnl3SDNQdUJrVkpPTlhj?=
 =?utf-8?Q?kcylW5bJGlv8CitdJtnN8OMY5naVx8sIMGY/vBX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8f5db0-57b5-4f1e-8c7e-08d8e8298e8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:14:05.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHLfiGSkTskEiNOINuoCEajo4lWsrQWy1ISGA3Muhb8bhB8wyxc4GGXaIYg41s/1rfB8Mrq3F8I8EkJj3je/DilLgY0Rirm2HxOjF38ljFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=892 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 22:46:36 -0800, Lv Yunlong wrote:

> In st_open, if STp->in_use is true, STp will be freed by
> scsi_tape_put(). However, STp is still used by DEBC_printk()
> after. It is better to DEBC_printk() before scsi_tape_put().

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: Fix a use after free in st_open
      https://git.kernel.org/mkp/scsi/c/c8c165dea4c8

-- 
Martin K. Petersen	Oracle Linux Engineering
