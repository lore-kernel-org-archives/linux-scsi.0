Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E0BC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B0761A25
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCYDyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38694 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhCYDyc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3mYxY194876;
        Thu, 25 Mar 2021 03:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LIXE3+Z0nRxh+bxn3X3VAweg0lI8/G3vqRAcMJKHBqs=;
 b=He3eDr3IBmHRcqagWW0trXAMkrsq7ln8bYYvA0CXgxL9BTSJiHSQPbpD1mghn1LZ1Ne+
 q2KHBxhUGwIurk1uSTM5Q2jy9Aor+l75Md75ISgS0f+nT4GPXsC96hbyMLA8s1KvIFGj
 BuFlYN2JGmAUMSkU8BTWhMfK0zAY6Xv3AIZVYzwYobOOcQVu0X3G5AWrcX2PRK1aEduU
 9Y/crY9OAcXHHcULspK2X9NOTFjhIdM/lJ+htuHY2I3um9dSS0MES9TARDfk3MQfwOJT
 5BO1Lt5hF6ReiGGN+aJb5b2kLCCTb3hXV6/lNd56/juyKLx/BAlBg7v6v7kHVc5aeXLT hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37d6jbn106-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pFh8134348;
        Thu, 25 Mar 2021 03:54:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 37dtmrmuua-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdeTNlLWFtgfc7q7MVdhP+Se4Dm57KFy55E25h1JkL77EhSOXy3vXr8N6HLHGpVrV3ST4uUfbZMpuwa/6lcuhEwDCCO9yMOUErfXtsIPGNBfztkafuENWvcVhVOjR31Dx5LyZpA3ke0uLSyblrg+fHgVf8tgwrxEdD/XVbN7TjgBEgtTzCgaA83r6RVUsXzS73z2/YeaN9dA4eenfzzRZAEwbnvLr1q7XPatDHeZPRogbfzFTPd/dAQVWax0zjNr82Qq5bwgJW8YvHZxN4uE7m/DmNdjiSmjl/92VguoTUS0c6ZE6lLJv8pJx3Ddk5CQeT7zgK8Sp5Bh7S7iV47YhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIXE3+Z0nRxh+bxn3X3VAweg0lI8/G3vqRAcMJKHBqs=;
 b=FJLIIPl6S3W0fjOxHt9TNnhsFdSStR01f5NVjrF2Yb70oTyIrcy6qqi6WvALj7ObbhsU14FkaodWV/MEk2FoPioETc1fs3AnW1jt/qfCqj/4TrxK9/U+ABV5vbxl8Mjyqq71wvKU4BEFMTqjUDpXRi8GjA68idc8PkMi/Ay4pykj0Dx2/5Li6Vp5KPdBTR8/bpTP7369e07I1Rl+lx5Q91aEoGCS7mc6XkSfjiZM0F/wqrR90KzejY3afs1+Ded6T9Qq8m593n8oW76RGPuqwN3fNZMM8zTV0fj3HUZUXss1lMukMigIc2SsAPd2wLvaSkqj8/HSawYPcqd9T/vZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIXE3+Z0nRxh+bxn3X3VAweg0lI8/G3vqRAcMJKHBqs=;
 b=fl12RvoEpVZ6xRA+C/GsDGG0IXi6e2XoWWbgDtOrT2AbbKm7PvfwVQye/EH4xcW+vc5UF4OqQabWAySLemwpHBAqrljrgm4IyTw/t1kF8O4BXesdhrRlejpV08Kn5MI8pOm/9UN3WFh/shS4w7NvlB7xT7BX4PDBPbY1EdkCnwo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:54:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:54:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] message: fusion: Fix a typo in the file mptbase.h
Date:   Wed, 24 Mar 2021 23:54:01 -0400
Message-Id: <161664421197.21435.346650559849084894.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317101238.2627574-1-unixbhaskar@gmail.com>
References: <20210317101238.2627574-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Thu, 25 Mar 2021 03:54:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf9a409-bd1e-4ecd-e4ca-08d8ef41ab25
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47741F7ABEDA99D9D57C98538E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZbjk4cEl7zqJR7vdacK4yGFk24Eb4GmppJZGBhRbaMdU3E+UAJuWM6TFAAYEjbDo5xxzesDh5jMrfHw+gL1uFprCbSVYMboWb//nEDWSRR44KGZbwC1XF5WuvcmUSx6ebZjMCEXBcY9+Z4JivDIqMrTyg4BWX9pxN3nT05n1WI3yZgUD9dBqQ6L5EEwe8ZrzD8f++ipSJWyRipahPNa39jR1wlM6a8H1L6Wg+8NY34Uv2pFyL+JG4+hzQi7NY/UmMA4zbH3xqg38wQ+BkvCBHY1tNequqCgRt84e+jjk961oKSoysr7xWzZVI8ShLYwVztvOl2sXvFVt0VdPG6N0e76LHNrW4AtTSekRkXUSgU2LzO/TVGRUARdV7JoLxgdyqHuvOhHhxTq9CWX8bpGHd0tgHNHdgw/LV3b/kZSIxanyxJ0gWwJgMSR3WPRvI/ftWBQEkShcfsiCbXnfT5zXHVXjrVZFY4Em2C8dZTNQTHFdxD3pR9ara9I25VbkwsP2t1KNy8dCLHiQoysXc2nbtFulCrXHB7+9FieaxV2tsvnkmR5YoX3beMuKKiU872GheP4YlM+qXQNeU7VwsxOT9y6EQ4wXOho7XTtbOCj9mMNuDBGrdz3CNcQ73GbsCxRvTqVL2kFw4r/8Cj4O9y94SoSixTIknoX3d7JwSB4IAif96pubcVmqqo7x0fvR9+/FrEg/OuAhEEkPEk6afUBibFP2CvjpAczUN0qOtj4+Fw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(15650500001)(966005)(38100700001)(6916009)(8936002)(558084003)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(83380400001)(66476007)(478600001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c1pObk5vTGQ2SnR2ZjMvRkJORFA2eVJ0aVdlT2U2WVZMaXRCZWxTaURmN2J3?=
 =?utf-8?B?QkFTUmNrWFc2T1EzOVhaUjUrQ3dNNlQ3UWxMVTNFTWdhdmFIdU9LNnFEYXVa?=
 =?utf-8?B?M1BKZS80QTJKbklZakc0eGlRRm1pMTErZWVaZWpNQlhSVXNHanl4cXdpVzRh?=
 =?utf-8?B?dDhndFFyczJRRzZIcE1QS3I2ZVVQaDZrb1FzN1VrTDRSOFE2RGpBb3o2TEcv?=
 =?utf-8?B?ZkxSc2VIamxNY2QyZE5LT3E5VFZreDZHb09ZNUxKL1pqeWdJdmE3RGpSM0Fi?=
 =?utf-8?B?RGwwczlReStlWWZLUmZoZm4relZmeVBiRFFORzVsd1V6cnp6dURJMkQzRHhO?=
 =?utf-8?B?eisrZnU2QlFQK2xHK0NjUWNFeXFzV3crU01CSXJ3OWc2VndXbVZKUlczZ0NK?=
 =?utf-8?B?M3pZVGNqN1FBc1l1SjJFejBCTEtCNXlzU1kvNUUzdFFldzREQ25DenhGdW5E?=
 =?utf-8?B?U051UFFnQlFGVEg0TzUyQVdKK296ZkpSRnU1T3FwVWFsWmNjTm9obHkvUHoz?=
 =?utf-8?B?WHpuUmJIcnJrWnF0dmZ6SmFPNkFvZFA0TW50ak1PY29yVGluREhRZytNZmFy?=
 =?utf-8?B?alVsMTdkNUtEOUw3eEExNTlsNXhhM005blJRcXJoTEZWRE9zSEpCTzZlajdQ?=
 =?utf-8?B?citKc2g1bzllU1grUmRQa3JYUWtUbHpUdTYyQzF4SVNtQktWSzZqVkZpUnVZ?=
 =?utf-8?B?TVJVZWJEckFsMUN6OTIrdldpbCtLRVpFVzdyMDVtZ0pQMitGSTlzSlpZRzFs?=
 =?utf-8?B?L2dQeXYvTVozR0ZDSktHZy80ZHltaXJpb21TUDJrWGgxTDFvWjNVYVErdS90?=
 =?utf-8?B?SWMzUHMvOTExd1RTKzJYV0FGMGgrbWU5OCsvK3VsM0IwaFBlcjc2UC9SYll1?=
 =?utf-8?B?dVN0QkpsRXNBVG4ybEI3ZHp6d1ZsOVNzVUJrWHUwOGl3QXVTdUdZMG8zWnFD?=
 =?utf-8?B?K2t1RUxnQ2dUd2M2OEE1ZFVnUTBKNFh5dFJyeXI5R1pjWEZuMlBHNDBCUklE?=
 =?utf-8?B?a0sxTnorK21YQlJSL01BcENoeU9XNW5tR29CQ2RmcEdEMmJHclQ0OWEzUEs4?=
 =?utf-8?B?enhUNVZxYjhCN1h6SEpMcVJWNWF4bFUzMXpGVjJQd2tGMjUrb09mWTNGditC?=
 =?utf-8?B?SmtZdTVqOXBxRmNWNFJyaHNNMUtOTmoydjNrYVJFakpzQVMzMXAwcVEyOXox?=
 =?utf-8?B?UW1TNU5oUmlTbUJaajFFV0trbDM4cUh0YlM4REdmaktsdnlhRm8rVDc4Y1pZ?=
 =?utf-8?B?c2p4SktaYkxXQmtTanhxMjlXVzVkM1ZXV242WkNGdWJHRGRvakVUL2FXc0hy?=
 =?utf-8?B?eDRFYUpUTm02cVNBZmdCZlRqK3p3NlN3SVZubllOL0Mrek8zNXFSR29RQVcw?=
 =?utf-8?B?MFRtdk91MytSV1VxL053cnVJQzkvRzRrVWJzMnhRQkJOaGFMNHZVK2dUYnlF?=
 =?utf-8?B?ZFhTYmpWZ2dlcFM0ZUwxSDd5WnZYd09YN3NRNGZaeDdBRHpMWWlDU3Jld0dU?=
 =?utf-8?B?UTRzTFJ6dWYwOEhoNDl6Z1I1N3NCL0VjZExaL0h1TDdsQ3Q3dUEyWnJaTEtU?=
 =?utf-8?B?YVJ2U3Z2SjVOMDN6K1hhS0JoZWU0UDNJWWtESEk0MDNjcFNUTkpRbGk0RU94?=
 =?utf-8?B?aUoxQ3dnSkxqbUsyQVZmd2YzNklNWjJHK3NFbWtpK3NZcmNFV2xxVjhYd1RL?=
 =?utf-8?B?SHg4c09DWUttSWZYdHNCbHhrSXNBL3lPOEZhZFNqMThYZDg5ZFVkQlV0NGEx?=
 =?utf-8?Q?falb7M1X2AI2PUxz0BwF29+/uQPX/a1mol/JpWM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf9a409-bd1e-4ecd-e4ca-08d8ef41ab25
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:54:19.8306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8sBorrXzr5+44vbGBqbxRNdvsyU2dVj9xqTJVqjvBsVQll85sPAp5qitUr4bU483KHhBSfLOKOuAD5JA3cBWlXhq6XGVsdi8BIb5mxBv5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Mar 2021 15:42:38 +0530, Bhaskar Chowdhury wrote:

> s/contets/contents/

Applied to 5.13/scsi-queue, thanks!

[1/1] message: fusion: Fix a typo in the file mptbase.h
      https://git.kernel.org/mkp/scsi/c/69a1709e2ec8

-- 
Martin K. Petersen	Oracle Linux Engineering
