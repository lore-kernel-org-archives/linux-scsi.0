Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515E5C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 265376195D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhC3Dzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhC3DzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3hsoj103349;
        Tue, 30 Mar 2021 03:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tWKOPcnMeo+ptabst79emTl6Hl1lROCk1gs8LRan0Nw=;
 b=MjkKSIiMJUVV1g+6xvK9YSdx/UnPT4q8DFHaf7kiHtgpvHS1H/kGgMlnCfiTEdLwqOPU
 XYuU6jtxU5qX4uNLFhQ5XtuvjweuosTnST4gxnFiF/Rm6ttaIzafD0ihNKHTZAa9Nrfb
 hzDBfEc6942ivTbEElhDhOcXE+ZCmDxQFpSNziXFEVyXQ2Xh+mfKkgUVOZ0E4/y/6Xex
 Chf2ZlYmv2rqgy78aqk4sxGSu9l0vLAsUduL+grs+aKf+kAzEMPakNRE7pW4CM+n8z/N
 EXpD2eVNJrvFYZlmAHVfrb/JK24mdYhSXRKT3UUTxPxsX2PxPQTDh0dR1nib7OQyUY8I +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37hvnm5kbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXHa039539;
        Tue, 30 Mar 2021 03:55:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 37jefrkt4g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbhK/6M+VvQoYJUxy+X4fzeGgwBzzmeZG5CpZqiaO3xZbYOUoq2PEZiNHy2LIBgq3OHlGdZjb5VHVV0tcSXKQzjKWLIuoZEcPuncWZa+2zv49nf1Pm0T6Cay0NhH1UFZTkzGG1Jnyb+KtARWYgsseP1waogWtfsacVEtB8rVXivNCiI1DUyYcLoSjylYy4grl9nS5/PPNXPspv2zdx09hpSVptoTwV+bShbtJoGAltsAzPUe9pPhe6KZLBvul4CiwdOSF0i14ZkaB0dCaHjtLSonK9FzpIht+oLeawHfsjZZd7osDiTwR/9Do+agHLd9u9QBhub5ACgQEtfTkRvopQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWKOPcnMeo+ptabst79emTl6Hl1lROCk1gs8LRan0Nw=;
 b=EG49vcnyMRErdKD6k41IyGVcfpBWHt1Xel2OOLSI6GFXhpKvkkp+TPqqW7sR1dvvACU19Mt4dJczRTFaxNDXfZyknKba968uvQnDzJFIGJ8Jw3gaz5EDhNG3X7CHH/6XNsVmao817sL/oTUgyEX4SmCu2xQ1jB6WekjlYXHsX1//E5nMwFFBBuSM/e0K+zgUYpRg39eq0ZzuRqzAz0woqg8tcnS5rT8QpQ8LRlUs12N3Bu0GwEo3cCcxPJkpYMYkcj0Ons2+Krev0k44JFdMzZDHjYxy/8Xb+ooOBMc2gduIw/Yl9+MPzoTyZdwTCP5Qnf5L1apt6CyX+2sQTb4XMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWKOPcnMeo+ptabst79emTl6Hl1lROCk1gs8LRan0Nw=;
 b=eLQ2lupdkfFrKG78DW+p9sWD5L+ky4ICrLhh2K2+ZcFYD1C3x5aGrbJz0gxRnlQuvIlVIW4Crt/J2pUVcTWvn3p4j8SqzS/PVfq3yuU58EqsLsd75IBGG0KOTxovbOg9XtloTHfa8GDP5wtN3ReDQ03wfvL+SxFI5V5JWDjTpwE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2i: make bnx2i_process_iscsi_error simpler and more robust
Date:   Mon, 29 Mar 2021 23:54:37 -0400
Message-Id: <161707636879.29267.3015658648468166896.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310221602.2494422-1-linux@rasmusvillemoes.dk>
References: <20210310221602.2494422-1-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09a83885-e6fe-423a-a59a-08d8f32f98e2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758981772EF00BB1D502EF08E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oyj0zAxmruvXDbCj0FxlceoKTHMXe51zJxVjMDDCfUQ326xDj/HySGraNu1GKF8wV86J3GlA8Q7JFgYpSk+8IROwLGZCGENxGvFJmtXDAvhZYB/mc4EaezXqn8oj235e1rZ22leJi2IWa00ntqZG5KpK+M9wEOuYVV3/XF0/6jOuYzghfyzgdrVv4SbB6Iz6fMsR17wXLEMNebVybDV1PSwdHTSTlSAdF4O2Y/hW5+i3Ru9arbTG3sxtNmJ+Ee7/SM2/wKHMUCB5VXvdzpR/TDgPfJ65s+0CeYE5Ra4GXVv5AshSu803RPwnGCw5NLRaZCdeQz0ll3Nd2YKlASFDEnmaSrzkdmIPLCIC+hUUTFRqps2vNnjTtDOyC6aaWD2tG9JPrLfqGfllQ3wiW18q0rbd+nRugOWzVJ3lhEetak8zt1sibOr6pDSuHh5r3pbW99AXPi1b48HEzAomFOyOmJ8caipzT00zavNN9dXL8Nc875KER+/4UxCcTDaE+k3LUgOl+H7XwJW+fSfHOmvl7ieGhmn5B1mt8sWDDbKls1oB2IbMm/pINNJiXlt9+kCVvL1XDV1rv3fvFTtO5zYPiNedNSiZJ1U5DYrH1P6zq/2o54QKnr5e+Pavwyjep9r8U/jhqUT0Nlhm1exv+cODsgaQW46MRQOg0estM/FRv+VjtHGvKokvPgV9NgZ3i1u1+nz/89cwTrCuiAP8nWCheAPCGFZHA/8Dw9BF3LW0gXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(4744005)(956004)(6486002)(110136005)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c2VMbVFsb1d4V2c4dVl2TVJsSXBIRVBlY0lxU1BMRm5ETENBaW9zNDJkTm9G?=
 =?utf-8?B?ZWQvbytJZjVCOGYxRzJGVEhBV3U1RnNhTysrL3lsQWp1NkFmVlB6MVA4MUU4?=
 =?utf-8?B?dGZNazZLWnMycHUxVkhrWHJkMzdQeHlnSm5MaVo4eEh0Y2FGUzB4NkhtVFE2?=
 =?utf-8?B?SzJRSUtwdmNVVU04T1g3TGx6eldOcy83aFExNzI0RU5SK2dac3ZhSUpXUFQ4?=
 =?utf-8?B?bDdST05URmN2Z0xjdXRKOU9ub3Z6bVBCMThJc1NDRU95azkwTUptUHZyaDN4?=
 =?utf-8?B?eUlmUUQycWtsbEI5RVEyaGNOWitab2ZZQnBsZnYyckttSjl4MjE1QVBMRTVV?=
 =?utf-8?B?Z0IvNDVRNHNHZ1FCNUhKTnVuYjlEYkFQNzhrWlJDQ1REMFZLbVcyeStnWFMv?=
 =?utf-8?B?MFFXTno1YXZlTFd0aENYbHg2VVd3S3F1cWE5aHBEOG02K0hYQzQ2ZDJSV1Nn?=
 =?utf-8?B?eFZ0czIrWDdGNFZYeHd6Ry9EdU1sUmpHb25GV1pjNTRubkt6WnE0VXhvOWxZ?=
 =?utf-8?B?MGN0aFdNUUlSS0ZDWXpGcmo4S2NXV0FhZjlGZVJ5TCtreXlHYUV0MndManEy?=
 =?utf-8?B?anplSm1TUDc2WEdxYzQyK0VaVG1WWm1qNFBuWDNFNE5WQ2xUWG4zbWJHK0dU?=
 =?utf-8?B?cFJJK1laTkF4dUxIZDdoVDBXblhoUHl4OWsrQkJVVGhsKzhtNmtRSkZYQWd5?=
 =?utf-8?B?SVN1U1RxM3dRMlk3T1N1aWFMYTMyN2p4cXRyQXNZK3JlSGk5MU1WUHlsUWx3?=
 =?utf-8?B?cWY3Z2FqU0FpN0Ruc3BCTjl1c3VCdVkwOWhXS2xhMlljMTREajYyS1J5c3lF?=
 =?utf-8?B?bjNkdjRRNUJ5djVYVU1TWUpzdmhqS0dYelVxbE1rOEs2QVVqb0c0K0E2NWpC?=
 =?utf-8?B?aHozNjJIMS9YV2NTRnQxVlVYUUtnRWMzbDFWd2hoRWZWZDhSUzZhNmp0NHA0?=
 =?utf-8?B?Y2pYZnVUc1dieGpUSHB4VWRSVmlSTktXZzNuNWYyeE5INCt2cEt5bFpqakJr?=
 =?utf-8?B?bHB3YVdOQ1hSS3VMbHRtSkNMVStqRnp2NUVKUGdlMU9ZTFU2dk90TUg4STV5?=
 =?utf-8?B?OGluL2JYK2FWT1BMeGZ2Zlh5cHBOZTAxREhLQmhWTEhYaFUvRnRvMENXZ1RW?=
 =?utf-8?B?WmsxMUJINFBGbzRmMVR4M0d1UTdud0JQWFhlVmZ0ai9FRkNZdWcwOVhyeCsx?=
 =?utf-8?B?T08wMmxncHFTZDV0N2l6bnNWeUZobGJtOVhLSHBCMTNRNGlsU0VvQUNrbmt5?=
 =?utf-8?B?YmFwZ29zMEdRZnNQQTlrRlBURmxEKzFRMXNBZWVUSmVSUm13Qm9zcmY3UGlP?=
 =?utf-8?B?aGhVZnV6S3RkVmk4c1BZendIUlRNQlNldXJ2QzMwUnVZc2NmNXRqalFUUXFB?=
 =?utf-8?B?a1ZtVitkYnVKQlF5VkpCdzF2K0tLQmhKRU1qSHI4Nkw5d3RZRHJxYWRSYmN5?=
 =?utf-8?B?UXhEcjc3ekQ3RmVWSzZKQlV5bkl0MjkxNENmamJrMnRMMzFMVmRxRVFQSi95?=
 =?utf-8?B?czR5WC84eHJCcmhHaDJrSVlKLzJ3YjVyOUJtYWVCUjVuNkljVWhiK3RPbVJj?=
 =?utf-8?B?c3liYzRySW9FNzJRMkdVU1dreGlQSXo2bC9yaHA4RHJ2MHU5VS94bERPMkVx?=
 =?utf-8?B?WUVDQ0FnY3ZQQnlhZVB5NWFtTW1jWFdLNHZQMlMzMkdWNjZCQ2E5MlNkTG9N?=
 =?utf-8?B?UlZ0L1ZXUHhQK1ZvMzZUS3Jwb0hNbTVtcEhuVTdXcHpuOW9TR1dUVlRsWjdo?=
 =?utf-8?Q?2xV9VtFl6VHrJ2Gjsn79GwuTiJML4qxggkEbRJX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a83885-e6fe-423a-a59a-08d8f32f98e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:02.9277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhFM8D2wW+EwTVda6SxwU2LscmtNySGJEIbkTN0ipYQkmIGUypuJC19AD7ldLzfGjPNxl0NtYyjk0siU7QMDQusY4jFNSOtRrBPeWjgYUic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: a19oaBF86VxXro-MY5dFJOg__1d0LdQz
X-Proofpoint-ORIG-GUID: a19oaBF86VxXro-MY5dFJOg__1d0LdQz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 23:16:02 +0100, Rasmus Villemoes wrote:

> Instead of strcpy'ing into a stack buffer, just let additional_notice
> point to a string literal living in .rodata. This is better in a few
> ways:
> 
> - Smaller .text - instead of gcc compiling the strcpys as a bunch of
>   immediate stores (effectively encoding the string literal in the
>   instruction stream), we only pay the price of storing the literal in
>   .rodata.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: bnx2i: make bnx2i_process_iscsi_error simpler and more robust
      https://git.kernel.org/mkp/scsi/c/adb253433dc8

-- 
Martin K. Petersen	Oracle Linux Engineering
