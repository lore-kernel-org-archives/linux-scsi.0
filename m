Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F2CC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E986861004
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbhHFDOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 23:14:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3326 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236244AbhHFDOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 23:14:11 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763B4r5008646;
        Fri, 6 Aug 2021 03:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mQ/GZjmzwjhrztS7G5qHC7xLDAtx5Phc7ExaYRanPo8=;
 b=zGP303l5C7l9Ryc9n7aJ1wTLuGmmTMGp0gIvCxOHXLG14xeuSBSXH0hlwk5kLztdgMnF
 aqBlPoGg+dLEZ5U0AYL7FDhFKkJu88QXv+aYtbCiXLbmz6VC2ppih3nmaYm4bioyQAJs
 7bjdN8OUG2qCnVe7K2LSovYuIliPfy49t9WN6TV5/udDvE8x1N9kZPRJE6rmhpZu5XWr
 3IeAFVnrkbBkNoKgPjdDJ8aVBJlJqWdNh0X33iljDp6VoGwSr/1QJliL3ozfxxoRl2bu
 P0uQ0QuEVQeZOBws7vI6EhgvrNV4a3E+6Fa5qj0ulxjs0EBDrSaKR2e2dcGapq5Frjtm uA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=mQ/GZjmzwjhrztS7G5qHC7xLDAtx5Phc7ExaYRanPo8=;
 b=o7rh4f4V2AKH8o51sdEOZfQ7+xTq+dAj3v+CCs5lHWmkBDOd1Y9+hJlclc1dwwixoM5K
 AVVv0odEze6wc+QgL8CWIFGeNMqBYKKUmfPtE/AJy/6Tcd8IG1dI70s+BMK/HqQl5YQP
 9mFpSsUFOtfl3jlY5l15DiZLyEGPgrArQcnLuzO3D6DQMVIGeV0YmsutFiBCiMutdhC3
 6MYEXwUBQ8oj7vSw7pbu1aULeMjAekuUuTiSE0oiJkev/+PCvdJTEB2F9uJXIOZRh6fv
 ArydxOXyDRDrd+GAwmblJelAhLYQqzhujFgjhNCUest7B+6mvudkYBQ9V9D3c8ciqnoX xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubu4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:13:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763A78F135429;
        Fri, 6 Aug 2021 03:13:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3020.oracle.com with ESMTP id 3a7r4av2gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:13:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/oI7P020R8rA+1JkIYNzzKpuu6vy4gpa8AQOvbNsW4cYp2TFsYUMr9YWErSpP8FC3ii//oGgu/mmqLoymkuzlKjp6Z01SY448CvE0hrfgKoVjzvRhqjA4LueLLsG1OsPndSx1bRT8/3+HlqK/iwx0MRSDez1zMaIY+SBqtFGFmFLvcy6c3R5imGzJbpkwYEEgdE6D2CIMXBe/zeMkCknTwTnpwZPRLlTArfUNS82Ztsq0Oi+5hAkmZ/Xspu5yhQ1zaiOomdFg44H96J8yytzCog/m61Xy9VR3QC4yzZ99/x4B0icOSGfe3cEXg4/DSYBBIH2KIEEB6UgPdxXEKwJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ/GZjmzwjhrztS7G5qHC7xLDAtx5Phc7ExaYRanPo8=;
 b=jBOGm43gP5KzsRK+rx/RzMkrJWx0n0acZFeXcShhYy/E9y8UFnttA76sUofLcNOfKYVUSLRsN34pIZt18upvNWFVcC1VdCaO0WxlAOy8SC4iPS5mfc0epJNphqA4JS/ZD9LPW4mucOBUltykB9yvvEx5ktE6pxNQUQuGfKxfKgB4pVU4AzPhTHurIHQYLyxsQCH6RzfVatjcrBpdKY9F1dB0cT5EYuolgjSVBpStR99tnxk2j4RVr/iFJD91wPgLnevCnGJWbWgM+VXk97JBXfdAxuQlonkLofya5pSbsvjXQOpxfr20v5GSGtzAW4kPbAriuHdCBn4cpp2ac+mqDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ/GZjmzwjhrztS7G5qHC7xLDAtx5Phc7ExaYRanPo8=;
 b=fWo6c0g6Y12iwqJRoF76PbMClNTlAlufcuYuNg5Ephe9c3GCEDids8hn+qePN5GaLqnljrGhgRFClM1L2a253WF4dFkBtqqiC0eYhwdyllK++GAo/jP6AvMoONeF3Y+mYIFiWt67FuPqtQdNTV/dobiJTfQ83MVmqIQ1t72zMz4=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5420.namprd10.prod.outlook.com (2603:10b6:510:d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 03:13:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:13:49 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next[next]] scsi: qla2xxx: Remove redundant
 initialization of variable num_cnt
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0kzfeou.fsf@ca-mkp.ca.oracle.com>
References: <20210804131344.112635-1-colin.king@canonical.com>
Date:   Thu, 05 Aug 2021 23:13:45 -0400
In-Reply-To: <20210804131344.112635-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 4 Aug 2021 14:13:44 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0057.namprd13.prod.outlook.com (2603:10b6:a03:2c2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Fri, 6 Aug 2021 03:13:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d6f1136-1438-4aa7-caec-08d9588835be
X-MS-TrafficTypeDiagnostic: PH0PR10MB5420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5420974B03FCF0C4DF35CE678EF39@PH0PR10MB5420.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gPaTsPve21I6IDhUHfPEU36Qs1jnZo6/laJ7ISAgGKyu0LM4grgv/hmWifIJK43CF9iwT+VuudhUryveT2P4SSnW5KDqo0nV7nuPR3YlKvTyAGBMF6Fw/RD0PFcootSaPLZQl5rFny0szIIaehowPhK1TNhcpE+WGRctbmDbbGY/YjTHx8+QA35thabq5VKz8JKwXV3tt3vDu+PwAm5Lo4ynLiG9pko3e7KfJ+eovoHLW7jnSIox9n6gNIbrF71IXDuqnPJbfwrpfpw5kcCuFxFFqGkasH0TAuRGbpAoTjiJUCqPOISpxsWg83K5KwzNfFRzEreSde0f5vDQoI0YfVs+LX9iEWvkzUfOPo/R5k59upDgYBa49F0e7zZ7FD9V49aN8VzzoVSNZ4ICz2Ow4ghr7Ww1V9KS3pEJoHu93TjFAiSLLP2gMYehwCR79Lx9kOh1sC9sx+t3LCsF8tRa7QwqRV0RtLyuPO9D9P18LMxHmq8bD597Rw/cga9UA6dsWhQ80UgrVpJ0SnBSwQK78x2bk3qKtZfd1hZlgObbQ1T+YumOxyiVk9mOX9CB/6p6UOagIuGnt1GOAhL8WuD1RUFOXRUEzI9R9fB+dnAY+pZVN695S041vpanlbk0OrboctJ1C+g6cbSeb4ozKJUOp6xH4YYnmpuNLkHmn4I8q3gQgsNAC784OLiwSFk1214nbQJptfNVGSK0yELtftAhPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(55016002)(36916002)(26005)(186003)(52116002)(478600001)(8936002)(7696005)(8676002)(66556008)(66476007)(66946007)(956004)(6666004)(558084003)(83380400001)(4326008)(38350700002)(5660300002)(38100700002)(6916009)(54906003)(2906002)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/cIPjwvFMTypXmZS+eTmeaQAT46c5IdiUvmsu2JMZSNKJJaec2Vhna5FU5cR?=
 =?us-ascii?Q?S+oebDLxDgvnyptbX4pK35eTTlbt1zKJwRpBRPwrEc2NXrYF1GBrVzkxiCSR?=
 =?us-ascii?Q?mJLjjF80LTeax2+z6zJGFPwIikp97YMG6d/VZX2utU3ZimRY5iX2P7OXdNNJ?=
 =?us-ascii?Q?deXSINaR0ltUlqc0KquOD6fWCf3ZQTEBAyWVLJNThQV3wMcRYPhIoJD/3QjD?=
 =?us-ascii?Q?OZFk/GehDpyx6PK25fFWnB+HO3Kso1A6/JSsbYFxCUoguwdD6NyFHk6+UOIr?=
 =?us-ascii?Q?yAHDIO2z5f7R63NPuZRA+WpUP9cT21IjL38OhO7UEMtktC+5rNXO/CSeBYq5?=
 =?us-ascii?Q?IsByJyTyRpgJq9amhO/9wUvHj8HdmgZCUh0QbmK+MKQ7+6JeKU9YNAeNABqt?=
 =?us-ascii?Q?HoipfHxXDgcn1PIOa7+qiteZ1pLpwL/TWy48gwrnogBh7PwRRqKWgDLQ8auE?=
 =?us-ascii?Q?LURKBpJsD0RoOqWePa0ZnN+2cWCcBAtwoVK1B5TbAvQVQLVKayBY8v9MwxdK?=
 =?us-ascii?Q?eRZ8KKyGHCdYGerWwkGKPSHIlwC3vuw3iUgfXrZtVsb4hf/ch+Ee+Gjw7yCI?=
 =?us-ascii?Q?d6zvMgyhDK6/seiGmtmagG4TkC5aDg2p7xhgoQmsR9NPYw7LlHHgaiF1wA29?=
 =?us-ascii?Q?A2vfw9r2OqvKZVusghPSXwIqpHF28OllaXEf2c/KsVb0Id7k1dz3f4P/crNF?=
 =?us-ascii?Q?bgxdmuynfkHlv1+72V0fScAwt/SAf3GMBGmHGdhMl5pQXXrMxsARGp9QvB8K?=
 =?us-ascii?Q?rKPzpUDylxikVc4lKHT48oQKfkQsX6RywZElNOJgm805e42nitJiu11luX3o?=
 =?us-ascii?Q?qerayzTumga55JpEsLRTdx9EP9KABjMKNCaUbHBRVYCYiEdcQ5IHTfm+SfGz?=
 =?us-ascii?Q?do1lv4nJzObW4Y9fNgo5nlJ4v6FTIUyiAcG70eTlxTPR4gtpt4baAySVqDCx?=
 =?us-ascii?Q?7CCm5vWQ/D80hXhud/LDxBQhaa0bwDZMfiULVPHSE5k9aWYotNSlhUeEy8oh?=
 =?us-ascii?Q?YgNhF3OHZqSue0N/xQAeb1hLFLAEm9Ej0aaTLCEG/HjG5uuhyBzadM/vXasT?=
 =?us-ascii?Q?FGuC5v73tTBDd8LFiI/LA/osNoZOxKMO7C4z0nlDcblRfHTumUte9u83ZYQC?=
 =?us-ascii?Q?WB+LtLSzfkRnAN23pczzeTAQqSZwp3ebXlgXykXUoN/UNEEJMdo4nV+hi5f8?=
 =?us-ascii?Q?brpqrXyHkx4OjXqqWAILWu0pnSmaa1earZD8BqpZKaO8Vp/h1fkUuCR3fUTq?=
 =?us-ascii?Q?HIMr5IYXQmBDiV6AHpnDf446xmn6vnPWzROy2EWkbBdo0T3QSsLoTNw75Vup?=
 =?us-ascii?Q?dspVxp7tZkRZfjvcmprUiBGF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6f1136-1438-4aa7-caec-08d9588835be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:13:49.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGEJIhL8qF3kTJhrzdJ177YxhjfUyt7S9wrFqn1lj4efKvaV0Yrr+t2bHfd86nrEzXLVr0g+yMcyU6JmhBC9QdL4ZhXS5UYfJT57H9muqTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5420
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060018
X-Proofpoint-GUID: UGOSI3-I5-NgN4WBqUAF8lKFU8lmVR_f
X-Proofpoint-ORIG-GUID: UGOSI3-I5-NgN4WBqUAF8lKFU8lmVR_f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable num_cnt is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
