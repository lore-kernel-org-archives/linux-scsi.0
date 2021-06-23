Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77263C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A15B61375
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFWCKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:10:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65522 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWCKo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 22:10:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N27Vsg027810;
        Wed, 23 Jun 2021 02:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TUnTyw61OyKFixET8pKbICoD87ZQwaH2j6WfJJJqJc0=;
 b=mL+pAaD5uMi4/iRBNpJK8y0QN+uezm5OlSWWNiAwNngPqzCxaKZc/R+XvIubKYqjBXSn
 0ao2u1DyXJabjouy7fjRDdTL6Sr0xGcXorXq51151uBQsHtTNEBbI+D/667OLQxvzMyu
 cyKkFi1SWKt73IUug1xv1pFYJZIdjt7GlBZLm6QlkFDQTnvYQSmM96DBVSSv2wufeDkn
 5EVYBuH5t/Ilv65Vf/+/f/fLXfd8hXQ50JsHNTiBd2jECWX/o7tf8XoH2qPGGxQy0rvz
 fNqemq4nlQXTzC+eFKZh6RgWvR0jMIB8RoyNXmFjVALk6GxMjyHzNyGsd451tbeig6mb tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39aqqvvm54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:08:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N21e1C057156;
        Wed, 23 Jun 2021 02:08:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 3996medduu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:08:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIIH2JILxpG13tYWxOA+bB7XGw6e/Mo7Y6HH9pPI1bKMTnCR1CCL/R9B5dfEF8s+Fr6iS4y3XPGayaU8g1ZV8epSfoRs0jJCQHT7U6MYY2pYsjyFV/b1DcL9Difxfkv1VyZ6h4L88WLrpXbVUOZVvIAOOiEUQrTadmeKByJcvYvvCFKC/mj+J1WKH7XyLjjuzLm9a061MGHTjXNj3zlwjeeT4lEc35TX0EJtw8x5+PU8vlMMn56JgDaycomn5SWsu85x+7WOXcBjS4DHb5oiVDF3jEz1S+1W72+CZDcCP4ubObB4up1LrIPtd0PAkk5sp5S6napBl3MuiQovvNrvYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUnTyw61OyKFixET8pKbICoD87ZQwaH2j6WfJJJqJc0=;
 b=UQmBE/Hi5yqH0ziq6AdFmkAJOMY2CQQLOL1ko1QEDzXaxlJonlhnYg0ut6BmlFT+ayM+9VszgWfvlCxAhSBqe15rtWBJGVW8/N9TRHHomZ2YMh2AFZ/+Tyy48n39ja9KIsUAcbmvh2BHvplBiQzCLa7LI90PguRCuYj+e8Zy71FBYEjrKlitQ8uy+geIbjUPljxl4QYdKqurQlqa3QGXPHXJ4XEHhI8Y9B1qzIY//Ho4RgxFo4nQ/D7M5wEpSm8XVbEoEpNQ8YPvESAlirZxoUvrwMyQ16dkNoi6dmGkrYRgB9KniEDrBb1Su5xzUpM27H1oNrjeN48rve4PBWGOBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUnTyw61OyKFixET8pKbICoD87ZQwaH2j6WfJJJqJc0=;
 b=UZ/i39wJrcb4GKkEdg3WizFk/imw6OvKZFyF6noWVEWsnCXAASxJ+UymyXUxn9o7EKFii0QJwk3L+tELJN36xVGMQm5k29tejho/KrqVxOi8vJCvFvN+x3g+RZRZD9YPbsTmAAWTwAkz/rH7p6XI9yrDV+LR6yoodcYHfmRNMWM=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1997.namprd10.prod.outlook.com (2603:10b6:300:110::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 02:08:17 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 02:08:17 +0000
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 -next] scsi: ufs: fix build warning without CONFIG_PM
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnqlqqop.fsf@ca-mkp.ca.oracle.com>
References: <20210617031326.36908-1-yuehaibing@huawei.com>
Date:   Tue, 22 Jun 2021 22:08:14 -0400
In-Reply-To: <20210617031326.36908-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Thu, 17 Jun 2021 11:13:26 +0800")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:806:21::11) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0006.namprd13.prod.outlook.com (2603:10b6:806:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Wed, 23 Jun 2021 02:08:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32354f9c-4564-4226-b239-08d935ebc431
X-MS-TrafficTypeDiagnostic: MWHPR10MB1997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB199763FBE22639FC27BC69468E089@MWHPR10MB1997.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: viwUmzVVQR1+KmEgW5aSUVXFN8BhjOByQAHXKOZh4M4ZtyyASbA9PbPETAOiuHo4qkpGuWIHjpZaKNo28PIdpXSdn0oDOdTq8BTXksCBNAM26A8ceLYBXa8Dr9w2kdO8PnpohkYh/3JzG8ZJx6UGVU9woI5ihuI2EOIOIB4xF6PGbSLYE2b9iCZ1e2ubgFHnBq/ndeHMMtbNSReZ9uvbYOvqmTlnjaE8fEiyUZIlPvrjtLrsNykC6BIugmxeuVPN5QUDavrijs2Rr0ZCCrt2hNQtJ4v7n+0psXC8RMG98TK0RUqzeAeyyOm2GZtY6Hx9xaFcpj3mDWa/Tsq2uIH0VlGd+f4M9zz3bo1lPLsfGyl6eJhCK+4RgIgCZMFix+TgEk3WHoXbie6LmVeKTg1PxEhiOKGbHS6iZNe3ja9dFKFPdYtFznvoY4dhNzlnM4KCYWYXGgz6wcKbxppEayzWt7pBEC/WxWOVdlXVSZb+ak/iCp9wBQDYmIfpVMoSKv6VhK6iVcwJoa/hLtQJ01Hkh4SExFbcTsX2ATkERoZpH1OUUIVZN2lKC43AJhg2ICCGbIq8mcnXJqbBYdLZSIYAV/LYO/DrWGPEc+UIv34h3osGBexBvg0XngBeTgXc//Poty26AgsPWZdDrYEKBbAhqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(346002)(396003)(66946007)(956004)(66476007)(66556008)(2906002)(316002)(8676002)(54906003)(8936002)(4744005)(86362001)(6666004)(5660300002)(16526019)(186003)(36916002)(83380400001)(26005)(52116002)(7696005)(38350700002)(38100700002)(55016002)(4326008)(478600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUExUmU5c082VEhKT3pqaE8ra0FRenJmSThuU0p6NmkrWUVwVDFPbU1zekw3?=
 =?utf-8?B?MmRWSHM4dHIzUXo4anJFTkl2bTl6M3NUOTRLRUN6VktIaGZHOTB1MC9MZ0F5?=
 =?utf-8?B?MXkxaHJ3eW9LaW94RUsyczdLMHRSbHR1alZxU1VNNTdhVDYwdVBxU3lNOWFx?=
 =?utf-8?B?TDFmOFcyQitQK3lwTkFqM1RRYklicGN0T1NtcFEzektNUmM4dFZkb25RWTB0?=
 =?utf-8?B?b1oyb2loUHhDUW9KRzdsYlFLUmk5WXovMHJlV1NzME5vL2JGNk5NQU4xK3R2?=
 =?utf-8?B?NDFrK2hiK05BTFo3WFFwZGJlcVFoT3liT3lCaWExSHcwY1hwTTNEdGkvRElP?=
 =?utf-8?B?RVppWnRGYTVFNldrME1pZnQyUHB0V2ZRTGlKd2ZrSlp0YjhOeWNHbWJMeXlz?=
 =?utf-8?B?TytXMjJ5SmJWRFhQOGVFc2J1ZkJhelZzZmM2RXdteFc2Q1NrUU82dGVwdHV1?=
 =?utf-8?B?LzJ5OXF6VXBxb0p3UW91L3FZVTQzSkpNbFUxMW5qNEhSdkxIcTBVYm8vTDBX?=
 =?utf-8?B?MjhsY2JHdWpySUZZNjduWk5DbG5qVDFYSW1FaENmWlBkcndYQm5iOWVCNm9M?=
 =?utf-8?B?TDNTL1JmRWpxcTlzS2FPYzVkWURhREtSM0ZEUHJFRTNzVHdoR09jVitBRi9s?=
 =?utf-8?B?RVpSOFBpSEVWTllabHhnYjg1cVZUMVZzbndQUGJWaW4wVVNLODBxQkx2ZGEy?=
 =?utf-8?B?QkJHNFdwYmJQZHZsbWIrWUNDRng2SGpkVDhjdDJ3ZzdrUm9EV2FKMFVYdTBG?=
 =?utf-8?B?V1NkUVM5aTJRSU5zWkRjSU5LalpQWTh5N2lNTng1WkJ2dk5XRzFZSVIxbVNh?=
 =?utf-8?B?WjZnUGR0Vm9BM3R2dThDdUI2ZVhFZzczZjA0R2czclRzRElTbEVDNTQ1Ri85?=
 =?utf-8?B?SUVYWkljSzVXQWQ1elJmd2ZhaSt3THFIaVhFTk5JQlprTTQxaXZqQ0FmY0Rn?=
 =?utf-8?B?a2VVNk51NEViY1JZM3FrbVM4clFlRnBOaDdYbG1zOEU2MytkUDhNQ0VpTDlZ?=
 =?utf-8?B?TTZsMlBOLzRINzlmOUROVGdKZHRCZ05peUJQVUpwRUFCVGl0Tk5ZUS9jUzc3?=
 =?utf-8?B?aVhGVDQ5aUR6Qk9FWnBrV3V5RGEvK0ZBVHJ3SDBtQTlBM0hSV3AzOUJUclZM?=
 =?utf-8?B?L0toWkQvd1ZQNEF5WEdlaFZhOXFwcE5xWnIreG94ZWZRdXNRTW9RcjZEVGgx?=
 =?utf-8?B?NUtaUGJVYWdiM3piMGV2WjVFdE1LdU44Z3VOOWxnNm5vSnNYTUE1Wmd1OVZR?=
 =?utf-8?B?THU2WEs3UG4wOTlPUUFsMEFWL1pVc2hJbzFhQnFhQWQ1L3dJOTNEMVdRZ3cr?=
 =?utf-8?B?UFBoZkpTTlB3SDZ3eFkxekVwY01oT0FTS3lFUThXZWFvc0VnTGxPbkkrc3JH?=
 =?utf-8?B?VkdGN2VFaXg2Y09xWXFBUXFiSXRRNmtxUktKb0c3MWNMSzJOc2hlUGZZZ29Z?=
 =?utf-8?B?Z1lnTzFrOVlnSkFvQWtsQmEvTVB5M1VydE8zSUZQMFNhS2xSUzluc1FCeUhi?=
 =?utf-8?B?VGQzMStPRXZVakt3cWpoVDRrNWtZSVh0WElySmJXWHk2V3FOT1dwTmhKcUtY?=
 =?utf-8?B?c0Q2MEtzUklNaVVQQXk5dDRvUU0xYkZQYjltdHlUMmRjWERSSDZ3R3hDTFUz?=
 =?utf-8?B?SUcvZUU1bVhxY280NThWak10TXJIMmQ1bW9OQ2JseGdKUFQ5dVJRVFpNS1kz?=
 =?utf-8?B?NkFNS2NSU3RjTzcrOU9ycXdxblVPNkZ6bDU3WlM2L3kvVk5XZHJ1MUx1ZHg1?=
 =?utf-8?Q?ru49iDV2s7SQoSWBakaNs8eF2klOpY/21nOPnkz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32354f9c-4564-4226-b239-08d935ebc431
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 02:08:17.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clbYi9F2iW45yD5om6Abdq9GxW7rk0J2lggKzYafKQ/k9P2HtV8fEUF9g7mJf5TI3Fo5Luv4EDU79oN2PC5vzxHI/9PxAEl+nuAcwYwvGYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1997
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230008
X-Proofpoint-ORIG-GUID: FAKp86Ax-0-MouaYsrpIl6Fg5xBvJ5lh
X-Proofpoint-GUID: FAKp86Ax-0-MouaYsrpIl6Fg5xBvJ5lh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> drivers/scsi/ufs/ufshcd.c:9770:12: warning: =E2=80=98ufshcd_rpmb_resume=
=E2=80=99 defined but not used [-Wunused-function]
>  static int ufshcd_rpmb_resume(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~
> drivers/scsi/ufs/ufshcd.c:9037:12: warning: =E2=80=98ufshcd_wl_runtime_re=
sume=E2=80=99 defined but not used [-Wunused-function]
>  static int ufshcd_wl_runtime_resume(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ufs/ufshcd.c:9017:12: warning: =E2=80=98ufshcd_wl_runtime_su=
spend=E2=80=99 defined but not used [-Wunused-function]
>  static int ufshcd_wl_runtime_suspend(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~~~~~~~~

Applied to 5.14/scsi-staging, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
