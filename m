Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFA4C4320E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7EED6023E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhH1Cde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7004 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233206AbhH1Cd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17S1uxrG031952;
        Sat, 28 Aug 2021 02:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FtUfSFnch6b3s9JOB90gUMeMR4zzvx0pNPJHYrL+3J0=;
 b=fLJ6rAO9m04qy/0lO9ZFoUiaf+yCJTGPvBbex1Bh6x/tAqU8yYonvaf6YL9sbK61bv4o
 ykXaHCg3b7+Ly1GJ+u5DHdnjkadPgeAAY4tb2iDisutFNWKd+aECo+g4IRLAadky6m5g
 V3B/PjTTHLA2H2AmB01RA+/mnm6gKqoHri9bU9Yif4LA7RIklylNfKZI3b5ouk3S2Gsb
 TwH9rNyzq2pJJG6FshSUiQEIvUDTfG3HY/wHtiO8qgu+kTOjAu82+JaFVzzMcFtaIrQK
 O3+bUbZhlVUTiZ5IaSUoYyYrdS+mY/AeOCnUVI4nbHltog7F63nHcCSmrna1JoUDvjI2 DA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FtUfSFnch6b3s9JOB90gUMeMR4zzvx0pNPJHYrL+3J0=;
 b=bd2sgIJmQb6x826VSZzTXzCqTVpXbqkFpFBFIokIikrIw6KS3pJxnI+kLXDSHAG9uBLm
 ZMHNjylQmppMH/xiTW23b8HSCOaMlxTLdmQDnxRCofeYNJYTjGkkAgWKvqGSaQdOLIFH
 JyJuJxayj/WlJ0WIR5z8S4TuxczKQ8MgPtsHRtm3t8Vy12n3Xc50vh9FAPS7vX4C4pyo
 l4u4AtPkCYlLpQdJOZU7rdqwAZ3crd/c/rxgJ6tkFb/hWfH6Wgf5fq0B1IAw3ELQR3Rc
 5HFlg2m6KjtFe1jZX7eSX2db8/QYq5TFHn6EX8yETMZVORmGSpi3dtqT0TRLLyMlPymg lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aqbx200pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2Hxea169955;
        Sat, 28 Aug 2021 02:32:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3aqa8tnj8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl6WWRTZ+NkGtSAOI08PFiwQ5sEeOhv/jLOZq8ftO9I7XRiobRv+0SFxyPDltc3LIXkDGKowVZyhHLD5zpxbt0jTAu8KLXeI6GH4cLYsLS3KkppQo5n/WPZFFNqOuijuUJtDMjAtsFtjl4YXj4L3Bv7CySFL6BhwxQPqYT2hzxjgaBjrLGS0FjvgCZE6G/oR2EhwOLcaxzR6NdgNvEAmnOr1Bf93x8CgGOpMEQsw5WbQStQVARRwrB8oEufas2ECRg5Li8jf8bWXA16vijjOOYWjo6A7Bvaqlu0X+Pybav28DxSAERSPMG+kJiDWyqhsKCML/fBJXCx+bEHxzXDZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtUfSFnch6b3s9JOB90gUMeMR4zzvx0pNPJHYrL+3J0=;
 b=ZcytsdXDvrb0icc4LpxgHWhOOZkU+xzGFOQhPHEtt9/+aY7jIpA2UdlDAf+EaCosGwWjhI7lQCCouI8o/ESreyNU4LBVoJdcosbax6VQMBkhFHxFkMmS0lHXaD8v21m6Qz9G92KC6PqpvuVs+YRH0gwE7aOqa/axLa0OWafqFg6eUhn9psUUoLUezMzKJpdIF67v+l047VE3ZzUTlLpKe9yFGDykfxPy8VDJE/ueVtzL3ibKPFItUk44aV8e513pGiVJebni3nECSgSEtDnovMnCIqC8dz21ImJwdd93rtcXQqV2BJxQeNX0X4FpYtpE8x3zhe8m6y7YudUnrrK4vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtUfSFnch6b3s9JOB90gUMeMR4zzvx0pNPJHYrL+3J0=;
 b=FpfEB+Ej8FUbo2+zhK/ukILYVFKusCrprqNLJAFr/piP5zlTMsRXK4gbwgOhKd21vSILdT/ZyiH4iK2ZZCYTYaMjmfOMFlw6EfSHsXG9Pr/b0nNgy2Gkkson5wID4xzg8khHnjClNuKw1afobC3yiJGLSTl4zKCvrYDM5oK1O7U=
Authentication-Results: micron.com; dkim=none (message not signed)
 header.d=none;micron.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     beanhuo@micron.com, linux-scsi@vger.kernel.org,
        cang@codeaurora.org, linux-kernel@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>, avri.altman@wdc.com,
        Keoseong Park <keosung.park@samsung.com>, jejb@linux.ibm.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: ufshpb: Fix possible memory leak
Date:   Fri, 27 Aug 2021 22:32:07 -0400
Message-Id: <163011776501.12104.14931866773646198562.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1891546521.01629711601304.JavaMail.epsvc@epcpadp3>
References: <CGME20210823090714epcms2p1e414fdd91582bdbf8170b4cefb8a0f74@epcms2p1> <1891546521.01629711601304.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42f886a0-4c7b-4c63-a968-08d969cc13e5
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55152EE0C778DB9DCD7EC6BC8EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k46DrrG26lwNumIBl0xaiQLvRk8RuXjXoO89CWkvtJC72d/f4H9ouIzcOU/wGjZUhKSdPgjqC00bDhE0Uf4DUvOjMjtgT/K7Zrxe6HXW5nkp0hfjjsKbUZNcIDqWFQIRco1X7PRNmpnIcYAYZP1/lebfRn8pIilini3BRaE0pocbT+fSYZLsCrJDVY/Q7//blmH3IJSknfVeURVmLzgy35Lj8WR/6F+vnz8FY77ytGief96cYzqOzZlHleptIwe32rLq4Pn536WXbGOQxchYcSiIxcEK8ZGH4OVMVK9Xt4E8QAUpBRaLFtvcfJT2nHPliVVkDvD8LCjwDpaNWgzBd+T/RUQyGKTxIYGpnel07UeyZcwRCfnivnuSsY+RL1SPRuo70ktACQ5w+n6vARvlgmtRQLCs1R3dXwHBJP7Bo7C0ZrdUlV071rXL3vaP/50l/UuRzORIrpPpbL+yOdlfkE6pjYSlQikAPZ2lKFxD4TfD/BywdeTwor+mHc4mTzDCS/vMMpJGnL3cmpLhEE3gSShQmmMu0EKsNuwQEVl6ZXVlLlHfBdb7HsFsrZnk3xjalxqze+rp+5Pw03SEJpyDfySx9H8sCg2eUJOJt0AwQasDKhqCD7wlkwiyDYSxEQmVf8gVDUovvbD+7OcUTqhGWb+0TJIjwBJ0KS0pkAeZ4M1WVvhyTcFc68WYsnAA/B4zWppYZQEdPbZ+sZtrbbED4jJvXGLWVnv782gpfqcoYkpEsmZxcEIfYiFF9YqBsTIxDZizLQuy9gahlpmb/5BUFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(110136005)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(107886003)(103116003)(66476007)(66946007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHJBa24ySjA5OS8zTUtlR1o4L2ZBMGlTQVoxNEx5M0VKMUE4VW1ETURsU1hS?=
 =?utf-8?B?QmdtM3VMSENXTEo2ckJpOXdJRnlFQU5YcElRbnQxNG9FOXJ3Z1d0VTVzeTFr?=
 =?utf-8?B?TkJMZ0h5ZVVUODRybXJDMmovTHljZHpGQ2phcmZNTVJpOFNEYmxiVGwvcVIy?=
 =?utf-8?B?aFdHY0QrY281S0ZNaDJCYlpYVzlXdGwrdENUTkorNUlFTzZNYjJuQUFDcWpE?=
 =?utf-8?B?WEdnRkZhUlVGWnZyNU94amdoZkR0S2NBRzh1QjRsYWF4dTJydnVrTHFRRFM5?=
 =?utf-8?B?RE9QSStXckE3QnRHSG9lRjQyTldicUY2SThzSS9xSDFCcGx1L0E2ckJFYTlD?=
 =?utf-8?B?UW9jNVVnd3ZscFhoRlQ1Mm9leVkxOUhHSlVET3RrYlJwS1IwczZzNHJSVFBG?=
 =?utf-8?B?alQ1bVJWTDNFSStQaCtDRlZtMXVnbXNQdnhsemNZOTlOaDJrVXE0anNYd0wy?=
 =?utf-8?B?eksyUUJBTUtVOW5KejFxMzluRzNJRXVSRkJqQVJDb2p5Q1lYNVBuSngwd1h1?=
 =?utf-8?B?eDZaTkllT2ExN1M4cXBmTVJycDIwZWpOWDVEZ203RERzVWlqL3BvaDlIeFlU?=
 =?utf-8?B?THMyengvalgyZEFONkpCdUp2eGlWbVRPdVFWVUhDYTdib3NTTUlSZXhsUUNC?=
 =?utf-8?B?ckJhQnI2QmlqTGNXbUdUZ3FoaU9Sd2c4dVcyZkliZG00MUVXNHZoUUlHRUhr?=
 =?utf-8?B?YXpOajdSdWNFSTBjSTlyajlvUHlab0xobVhpcnhJb1B5bVFuamxHclo4M2hH?=
 =?utf-8?B?T3RJcnhUcVU5Y2IzYW1BVU9vY0hWcWNBUW0zNU00Nm56WEFlVld2RCs3aE11?=
 =?utf-8?B?bUFOQ1pseFRXMFkzcGUvRzNuMjhhaEErZzdzczJXWUV6SGVIM3pMYzVmMGFW?=
 =?utf-8?B?cVUwLy96Y0RJM1p1Y0FDZ3FQb0xRdllFaTNNbmtUbFNURWdoVDNtRm5FRGFm?=
 =?utf-8?B?cit5aUtEZzY5YkxsSGZ0eUs5TFl1NVVIMGJKMUJnRzk2YzFnSHVMVWhHUHJF?=
 =?utf-8?B?cGhZaE05anQyaDIrYjVpVG9DUmtwRXVWeUxWZjV5V25FTTkxWTdWM2tRWXVa?=
 =?utf-8?B?UnZkekxSNG43RjdtUkpkaG04WHhCbG51SVFCTmtNblJjVDJYRXFqNUF6ZG9K?=
 =?utf-8?B?UnlnTk9JZ054QU1JWE9rWktpS0p5MDR4T3ZzMHVGN0xNUEEwNFRCUGZSaUxr?=
 =?utf-8?B?ZVNtQ0RheHhwQk1QQ2dmdUJIQzNUZGtiQWFGTDVUb1RDT0tkK2xMTUUwT2pF?=
 =?utf-8?B?M1JMdUtHQWt2Sm5JVGV2OWpRVVl6L1d2K2xUVGNVb3JydU0xNjFyb0JXaXVP?=
 =?utf-8?B?UHFjcjdzZ2tHOGxwOUdsYW1DeUZLd20rQUJUWStCS2FPNDJhemxkQWRTRElH?=
 =?utf-8?B?eE5TTDJVV2ZGS2FYbWpncGVzdWZCTVlsZUlxM3laNHhLbTBDT3FMdUMvdzlw?=
 =?utf-8?B?RWg0ZHlsN1VtK0p5YmJJL2g3RDkxS0xUcm1idkwvYUhHc1dTb2lVb053R2pC?=
 =?utf-8?B?enBlZGtuWm9zSU5KNFdXdm5veXg2djJ0QzA2VlhjaDVNWmtpMjdNcDZsTXJl?=
 =?utf-8?B?anFkY28xcitiVHQzQWdkbmZzWXFQS290L0NwWHExNWlXdGk0a1VvZ21jWWRr?=
 =?utf-8?B?UWdQSmRVSkkySmtWY2ZWVjhkakl0anNwSVhKbmExa3JrVmVCbXdWdmJMZ2Nv?=
 =?utf-8?B?VnVyRCtzdExsME9GZ3ZGVDFpUk9OM3gxNTE5VlRVQkdvZm9XYms2S1h0d3ZG?=
 =?utf-8?Q?/2bshoykjNFcisV4Fnzl6+UEDlsVSQOAe14KroN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f886a0-4c7b-4c63-a968-08d969cc13e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:28.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nx+5CvMxhh0h0eWkVMt3uUSF3EVgyr/Qcfdlm51Djl/bmfg/wv8brM4fv6QO+GAe5gPXuO17j3vhHsk+Qc7kLnNu+X1NBN5brx0G/EUQuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: QqQT_8EKTd2WqYf1RseKrzxEbm4uXfoQ
X-Proofpoint-ORIG-GUID: QqQT_8EKTd2WqYf1RseKrzxEbm4uXfoQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 Aug 2021 18:07:14 +0900, Keoseong Park wrote:

> When HPB pinned region exists and mctx allocation for this region fails,
> memory leak is possible because memory is not released for the subregion
> table of the current region.
> 
> So, change to free memory for the subregion table of the current region.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: ufshpb: Fix possible memory leak
      https://git.kernel.org/mkp/scsi/c/6c9783e6296e

-- 
Martin K. Petersen	Oracle Linux Engineering
