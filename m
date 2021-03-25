Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B5DC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C8661A1A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhCYCWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:22:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbhCYCWB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 22:22:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2Fsp3165623;
        Thu, 25 Mar 2021 02:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=53TdSzgPUcy+hcQ7B+Rl2lAnJTsAHtKkxigO4I3Eye4=;
 b=jQu+uJz0WQPmHVSWD9fzCdKkn8NRe1H/r5F5blUF595f6zmtR2ViebJScAXnSfKfNZme
 Czot/g0uZCScmOFbfjbcH3rlg3gDO5R4BNWHR/p8ytyihoX/FV7bMF/wfxxoNmuYEWlN
 ZWxPvZzqBIjy89DM8aOQpo6emzkd9hWyfoFU4XelC8DZdsAHDDnIVKbyQlV9CuinEyRo
 THAqSz1mJXWvTomUSFTdjji2Dh6wrt0OC9vttSRcOnNpnh0q/POSsWdcIpwVXee3hL+Q
 SPUJDAMuXoH02mXS4mBSfTqvDeFoprC/DGj31C6JORa6TMr6K21ioxtBkTAJtg7S8t7e Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mmrme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:21:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2KEIx196593;
        Thu, 25 Mar 2021 02:21:56 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2058.outbound.protection.outlook.com [104.47.37.58])
        by userp3020.oracle.com with ESMTP id 37dttu3krw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:21:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9AZOBzDCMDB/Gs+MmrwzFilyf7JDRNQaoJPclwaz194ZNcfVIcJk48TL+oQGqan2jBO9+/xBOwScQ0sm7O73GUxjZL3lNuYs5xYCKHy02ohkNWYkSa+reQaVeq25eQX9D5rHnm8Bbi7/sGHRh+Wsvq1DLBP8FI3k4TFAHBlfb67/1+O1xjSJvP7LTzpj6ePuCBTZfk9OxU/7yhSPFhexC4YBXty+wOqdvRF3kp+28Rbp3m3zGKcBndOVHoIb9Dz6w7wZ/hG5cpESCjS/v5B2JSbC1eBK+mJFYsKSnz4/aDowotaU05wP/NX8lAJLxyRNl56q8DgDpUs/AeNzvXbGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53TdSzgPUcy+hcQ7B+Rl2lAnJTsAHtKkxigO4I3Eye4=;
 b=RFrAntQ8u/JwUnFBU1BTt0UygOkF4VcLXzrOdHUdm+6NWVJf5xbr+NI6AImQJWRz7L3CHxcCWmxEnXKVB+OLZX/yMAeM0SuoB/Z950gIbplZAhmENDEiTeeF472sRAMdqJ09yIEEdecLITQLansUr8UYIUB4AL0LOs69ddAeqedy71zB8Elek0ZzHEmh3H+/Kocht9H1644PjnH2QYHPrZHctyK4KcigrC5ieOy6BLTu9PvTsfIe7Uh5iz4hRH+TSRv4fvqfAsJ36MdtgJ8b8tNvs1aHuGe0kmq+KyY2Foya2tZYBliBV6uXkNnHcDZPdoyslpJ5wricwt16z+BIlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53TdSzgPUcy+hcQ7B+Rl2lAnJTsAHtKkxigO4I3Eye4=;
 b=jvZ/69fFrstjPzf3LSwnbi51pmkS+icIZNoPgjTw1NjzLCinZnpB2ab9grFfnBhRWux8cZzwlzU8mzMzu4yfaYOYLKfWZlUAr15hdUP7ayw7yJa+qCEVxAfr+JaebiWj9LeGSRJXoK6jAibvR2hxn6xTfksMZv7X1l+T0IZGDp8=
Authentication-Results: rasmusvillemoes.dk; dkim=none (message not signed)
 header.d=none;rasmusvillemoes.dk; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5465.namprd10.prod.outlook.com (2603:10b6:510:e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 02:21:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 02:21:54 +0000
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2i: make bnx2i_process_iscsi_error simpler and
 more robust
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1k4km6e.fsf@ca-mkp.ca.oracle.com>
References: <20210310221602.2494422-1-linux@rasmusvillemoes.dk>
Date:   Wed, 24 Mar 2021 22:21:51 -0400
In-Reply-To: <20210310221602.2494422-1-linux@rasmusvillemoes.dk> (Rasmus
        Villemoes's message of "Wed, 10 Mar 2021 23:16:02 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR06CA0048.namprd06.prod.outlook.com (2603:10b6:a03:14b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 02:21:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bbfff6b-c512-4b3e-4dd4-08d8ef34c1c0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54657378109B417F0DC6B9788E629@PH0PR10MB5465.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPFrfPpXK01ku7L7ZSjU/bD7dA5IOgAuWnVxUNjN74Bli27BhZIzafztOxTwyD2iARnhr+NuixaftY8yM854z0sIDcyoDAa8mBJNJkTWVfUSxpGN4dW9U97kTH7MMzObTFRzyLn6q1O5ticswNZLQiTlaGoP/h2neNwYy8kMcaHze/hJ1EHvczArnt2zp+Oej5nGaGbYeydHGIKWSQKfIQkSpYNzJGixp4hL779bpttszBQg1RtKmSYg5UGq4gyMt5qgE6xHOqeN7ALSo4dOcnXpj57xqoiin7I205ke7JaBRoPxqxCh0nuQtIR5tUlXV426PmAlg3Wl3Q30lMn2xunPLS3QQIym2EbY4sqGT/FAitEfzW7ri4Ckdc18Q42bX5O+b3dd2Ex36ulnweLdpMCdrgO5azW30kfjNgedXPqRqCwQUQHlKw6J42bpNI5DoYhGnSc68uxRe3TPf3qaz36yElQc7KxKEv+b7yAyemiK+ayo4eyaP4hsuydmfsKtfMNSikJVYjAt1bpkA51O1C4RlGZTkUdS2azbkRg4jD0ko9SEqCVQBsUZy2loWzvg5eTA8U1G8rsGA5eFbJ9Yfuv+pKMPFkMcfKl9eZlKRgnZmBqVLadt+7czD+qQYnzQX1c6K3PY5s4p9WLmEfLsVfqFcpN3ysRJSkceM0vjoVA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(396003)(136003)(7696005)(52116002)(66946007)(316002)(38100700001)(558084003)(6916009)(36916002)(86362001)(2906002)(5660300002)(956004)(16526019)(54906003)(186003)(83380400001)(478600001)(66556008)(66476007)(55016002)(8676002)(4326008)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5+Xq+pRiZ/muhoIu7h+7J95tea0xaVuSm8wOS4cTvmw22gIDggCKhXmNkV60?=
 =?us-ascii?Q?LB765uTtWo/J7TQzhJXLoAF+v7pXOQOUStmb/zgzm02hs8UxBA34TMHZJVtq?=
 =?us-ascii?Q?tJajX/7+EjMH2FZEMAOr31uQ7EPAfPoGLGcQzezlZg2Qi4vG431qdo7KRzb7?=
 =?us-ascii?Q?OZpO3m8YjMSpLbnUi+uvfvQnXIbdYVyjpZ/doaIensoCnQB6zLdAbsaewLTo?=
 =?us-ascii?Q?VAyjImEn6SAewRxrijL6sC1ROAk9w3tRfMDUEACXuKM2uc4TQUEklrwibOeq?=
 =?us-ascii?Q?7JoqqhEemEDKaUE0QlyT9dk/PDvUq55n2K/zNdq57iXAzVSzttrvgOdN7s1p?=
 =?us-ascii?Q?hO5aa6BDRVLv0GL3q9b7FItjorf8TFkO/wMmAAznJRR5ceqLAoWbt2+Uz8M9?=
 =?us-ascii?Q?B94l6nDWOdYEFYgewqkY58yMW6QjK5oFG4xIueks+ER0A2fkgX6XR8EWSy2l?=
 =?us-ascii?Q?g70xTfDlWpTRWdcyNQCcjSQOmbWSVNu9tcaI1Y8NimwSJ1k6cPdvvTjRaq1A?=
 =?us-ascii?Q?wzHlEzFifG1MetMwWyb3SoA82Fm0IFWfM+37COMJorlNB1QydX5xL92GkqXd?=
 =?us-ascii?Q?lpnShZ9JnVlZkZPVZ3y/8NbQa932gaTumA7meUOlICjVzaAB1H/o42MFnJ7L?=
 =?us-ascii?Q?CtW3LvhpXqVVq4hO8I2PqIuAFeDsyjTW3tOf/wEta8jD5rIS83/LTZzGxAzY?=
 =?us-ascii?Q?VOLk1ilCSdsw6bb9TZHcFMi2IMZIGlpI+Mkomi/zZapAETC80ihrw6YWxPEQ?=
 =?us-ascii?Q?W1sxc5SYSpXtwUote/1SXHWw5g74/G3IAn6ugCrLXRNtlZyDdnJ1J99zom5L?=
 =?us-ascii?Q?iGiUQDgFDZdCs1CFZLEoHa8Q7l0aMQAFoZ0mYZxU53ReC2BV/xSYQI9elCm8?=
 =?us-ascii?Q?VSsXTNEXUUld2PPsIiIUK7v34oy94j8wRD/IxGV/X6246sDG083XZriEBKK3?=
 =?us-ascii?Q?mryrAwulV5w9HKRtAM7JjvbHkJ0I/qEtiPCmjPQ3yNnxE79zwQPWkHH0FrqB?=
 =?us-ascii?Q?Fh+qHvFwqukyggbgUqhRqLMcfnEKdZTzvzgeSZYc0UKSFVXV9NkXLnD4WOnz?=
 =?us-ascii?Q?HXI0SawWpXs54iNPkD4JkPzrC+SMeh3SY986CFIFI1h3stL8e7QlIU9IE5Lo?=
 =?us-ascii?Q?7Mwtkc82KSDh6iYYc/nRrirzMuZTOQCA3I1oVaJVwjMN54XQyt3sLhJdNrvV?=
 =?us-ascii?Q?Wi6+jca/Iqni1cROXFpm1oJ3vTz9voBwhI6HD49DifSjBoD6RZc62JdYOhlo?=
 =?us-ascii?Q?Lch+rPEo3MeYy0sqew6Hs0DMB1RqX3Ak38YnCUZ24rdSPiKs3CRlaRo3Vay5?=
 =?us-ascii?Q?2w3j4R2nPsT4pkf+3S8KWmtF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbfff6b-c512-4b3e-4dd4-08d8ef34c1c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 02:21:54.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haO6Y/edVRV4SvuTCdEGhEX7c46TdrOmwJxjzzuvXHkECKmrwwjZ2VmQKlGZGaWjpnt8zMIS51lemlV9pmoL3aQ6kGPFMpAydE8I2HsCmrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5465
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Rasmus,

> Instead of strcpy'ing into a stack buffer, just let additional_notice
> point to a string literal living in .rodata. This is better in a few
> ways:

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
