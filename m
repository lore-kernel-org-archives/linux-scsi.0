Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0BBC4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD09D61004
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbhHFDL4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 23:11:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41646 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232709AbhHFDLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 23:11:55 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17638v6O010265;
        Fri, 6 Aug 2021 03:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tfLmQjTUBgYCB2GAHE3VgDPhYNfUxaSMZD9rUnmmgFo=;
 b=0A4XRcD/pRFzpG7qbi0fFZK6tRaR/o59ffU0eFsW5/4F/M+jZWmSqkk8juUC7XGXz+tJ
 FaEH/bHgx63xUizNWrh9GyeIAMlv6aYBleEbhIXqbRJbavCN7x2lIEvcfWugrDIYFW/u
 CrxYWpeVzoKxB+9wyess96MBbwRu7+DTJH0tJOEQiOnu0zNXAvCJKfdgL7knsKRo6ERp
 5OZ2vEdgMzvnnpVxvXZ9Mj4whsE42CIuqj7JEDut+Qa5xGwD7q88ftIoYTBB08juLJBv
 KaPFV1J5OrWQDE2vlW42K9iq4TcX8PkwpjmRhuuPycSMtdW0jSMBB56xaTTcE+ddOBr+ BQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tfLmQjTUBgYCB2GAHE3VgDPhYNfUxaSMZD9rUnmmgFo=;
 b=CoJb6wDbYTIijoF3CmT2e6b+xVqU8a0zSyq5WVevPiZFz1yWHuR+Fl+eGcVYJtWhc+OK
 jFeL8qWpme7GuGr7dB4AdjGKnii/OYgYHl2v/2R7UrzuoH5k4yeyNhy7vpIPk3FCQewg
 CbT5SD7STWId8SpQwcWz/xMEmifzshGnun0xSwzg0uCbZnkIQYNTFSiWA44ayKkxnv0D
 gp+xWX8pXLmvL4I9YAWoE6mPKuWzZ1XiY7fhnU6cAXhz4k6P37mVTna3SO00fyYpzYbF
 Z9q/LhOOB8dt566+sMb3x5/p+TlR0ziO7hctCOhMgznjpta57TOvMO4hn2j8235AVPCM tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpnkak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:11:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17639gW7048115;
        Fri, 6 Aug 2021 03:11:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3a4un4yaxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:11:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2+evnKNxHfksR6kBlTHnuMAPmXgpzQd2cX/cmmvq01zaTUgj4Ye8WvRfjsYRhz/8PNZUvTGqovk7Y3VYy8sGLlCEGwooHQYkkNuwJTRBx2Rwlj7+tc/iYfqRiEYA98k26ntpiG6V48StZ9N9KEDtlG7bfsHF9+aAr9Sa7kBawLGYO8bCJjehmtCWcpvnjxwBYflawJROGXddApxH8Qt8FkbesIMooVkLct3PrKNFgPMsX3xB/7yd+zdJgwa9bgy7vStspeSHpwbud51vQlITsMbD4QgzZjW1WewkLzg3gnsMbUbvpxLVnU+pqN8dJyAxr5SJCgBRWfXEb8kKGyd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfLmQjTUBgYCB2GAHE3VgDPhYNfUxaSMZD9rUnmmgFo=;
 b=bbYswZ4Whz/NWOfHuKM510NJzHsdG7k1hwnIp4lADpmgaChVSWhnRA8F4778hSLhMXvXKUF6MJLFSaUTrLWCfgal43PHxmgwleZQOEYdynsqTBhPjadh2rVfk6+s68Sd58pFEousW2aGI50yJAqTK8VbvihNw3HQNc0bWJlS4CHGaNfjjtJ2nfNNCoF3T6ZymPGMBx/rS38qJpibjOTJhqL6uwVIubJVPYkgpWkpwK/x1SlYXEWsglJWux0PFDwJYcE0CFU6gDW01ubNeJIaoj9qxDCB5GhJf4RD70Fjk9sLx8U6SV/Hoa1DLEKEO/14XnRNbtVw0I9/GcKlIuah9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfLmQjTUBgYCB2GAHE3VgDPhYNfUxaSMZD9rUnmmgFo=;
 b=SpRdc5unoHrfGa5qpWXYuvtgTYXQJKQtZYcFwJzqFLPgWDtPmAwP0aTWMK1VqEDe4Hvh6PuHort7UJt1ArvRE6Ywq01HuQn5FhyHv+skiTPnEDSc0Jk4rHYT6sTR+aSEKgcTR5kOOogM8sA6sO1ofF3rNecbJi1sdVLY05Yofl0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5401.namprd10.prod.outlook.com (2603:10b6:510:e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Fri, 6 Aug
 2021 03:11:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:11:26 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Remove useless if-state in
 ufshcd_add_command_trace
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v94jfeuy.fsf@ca-mkp.ca.oracle.com>
References: <20210802180803.100033-1-huobean@gmail.com>
Date:   Thu, 05 Aug 2021 23:11:23 -0400
In-Reply-To: <20210802180803.100033-1-huobean@gmail.com> (Bean Huo's message
        of "Mon, 2 Aug 2021 20:08:03 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0062.namprd13.prod.outlook.com (2603:10b6:a03:2c4::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend Transport; Fri, 6 Aug 2021 03:11:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7663865-4856-45b4-575e-08d95887e0dd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5401:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB540122AB31D9D19CF8214AE48EF39@PH0PR10MB5401.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1YG+fhZey5uEIDGXgxqOE4V9m5YyV6M9sh3g/w1reh1Wr+ZLoKHGSB9A3l19DIeKPfzKWGWeflxoG50fgIwVdrqQyzEDbRPGvE8aYSw/a+rmMmBxg14rU9BKtfR/pLgs0fCN4Pb/qB+sr7RZMPLhqFFJx3ERzQAmxS6rPZCQut7BU94H9Gt0eMt1xb67b5ookOmtVcAyk9BEmGf4J54KpFvRlEyn4fnfcGTNPOACXwKo48N4Hpy8DgM3hZWMBNOSULvnNlsolusNhfGitUOwgOg1emAc1iik0rJX2vlCeEoFYymY0trbVIEfajAi4FKX3pMRXGUv0Ylqr0UKgFoh8hgjo2EhInwnATF1IpWgzLMeKtcNpgSfJNmE2y274xPIj/FcGQeb75LGFLPCJcoyOw5tX/e6/VzdD4GFlPyUd15PTDg8xzPgB1QJke48a+tySz2T9oBoQBAmiiVva7hGSiq40G7umDBmr8tgGrq+AZywe3BhA5+ZLXykajOy3WPb5t2E2qd2+ihkPSpHZT/tWDeqkBlEZ6KZgSIUYxk0tWPjWBsbq13l1TZhDzHirSDeHU4DmSYGF1A1EMTm1ra3ZKKmn8fHU6rY8vs62lts58azncXHlOAZd89P4eNLLVI6Ux+0l9H6aoPyGXYJ4FHUmPZwA0uI/cEsfbKTFMQ4zl5UTOlwCqb7eq5wjCcdSQ15UlLCmepNgJF3M0wGEMPy0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(346002)(39860400002)(956004)(66556008)(52116002)(7696005)(66476007)(316002)(8936002)(6916009)(478600001)(2906002)(66946007)(36916002)(86362001)(5660300002)(8676002)(4326008)(26005)(558084003)(186003)(55016002)(38100700002)(38350700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?btRPdV8AMv+ibqKZxRGWzBu8Ca9yYwxNXXq33DblhekitSGqKiV/IxufxP7R?=
 =?us-ascii?Q?dEaj5rVI/P1vl7ar+fTlkKEpMBpOR7DEPbKz90rDFujsFK6PPneKX9lcrH2x?=
 =?us-ascii?Q?Bqkr2iKfw8u7zRu1qGKNnupq2EvbWAHd22+DB6+AjvVgrRhgZsQn27T8DSgO?=
 =?us-ascii?Q?rw2tsWN1bUOueLRXQb3jfIWjzuMCAdZTmGbWukPRZP3mpToaJyM2pf1ricUx?=
 =?us-ascii?Q?uZMBhuoFXWWcgx6azEsMMS3c0u251dsya06iILB9UKOkxWDFxIJSmtBB+sqs?=
 =?us-ascii?Q?2QN9IosarWfYrwzIbSVWOysRCh9jYM6/BmMAxwl/bBECpUxjsNFO7KVBqNtg?=
 =?us-ascii?Q?BEnIgdFwGiqb2ahyNr1P9nOOXS9pQpZRheUawUCf0KWJJ+014hvzGrZbVN00?=
 =?us-ascii?Q?KkS5L3dnBSPPPrScxJlLSpjaaOpA9JsSoH5fzUXG1j/V5nXemu00vNxkqcaH?=
 =?us-ascii?Q?i65cN2Se4lHs9+yk5ZaE/+egJa73xeZm6gFyT20oF/if2iRrixFffqpPQAXs?=
 =?us-ascii?Q?IGkEOtoli2tMWjke0fukUZ43iPDuKucgaCOBVuIb70CeMyR117dzbbDSErGx?=
 =?us-ascii?Q?nlE1n8SXCOyHhmjBqgcQdexWSuHpu5bbqkT/xbH/Hoomc27lf9w+rcUuXyas?=
 =?us-ascii?Q?8Clt0z7EoNHbfi89nGDCLJeql1ShAr2OL0orxwIvp2X9JalkaegUV5rZFY4v?=
 =?us-ascii?Q?lS2QvLEteCjQz0PoNK+ag/blare9S0FLiV52acwrV4+ArseMy9Kgl/T2lb5Z?=
 =?us-ascii?Q?zqutQg7nUuNm6xNR5lRer9GiYofuG7xOHS6iQe959+DP3eJtOKJAq+cbp5AS?=
 =?us-ascii?Q?Ud/cgfp7/Tloc8undjdwk+420LCrWrLgVxdL4/Lq2E/14dVdOSAiLVj05yox?=
 =?us-ascii?Q?KHyOdzLzrJZnMBpBgPOZGD4uj8fjsbbNen5vDOkHYhbS25E4STTRwWgiZ+tX?=
 =?us-ascii?Q?8ygfRzAWUyjKvjBR0w6fld/yIwostnccLQ5CN/y+O2CpxPVBqhk+G71aC1dr?=
 =?us-ascii?Q?5T0aW5WmOnAV7NLAD8FDBTp2JrFmdhnzBIm6GuQ9nL1cWIJIfMPTDfs0JgZ5?=
 =?us-ascii?Q?/u1j4rWVsAm1yLtqHiQQOzYsHgcjZ7WKtaurQ+G7dRngFG/Imh2KANGzO5rt?=
 =?us-ascii?Q?rKVlzLgekK4pgSB4srv1LgZGusOZWeKCdb+Xh05KiWqAME0u1pq36T9BmGeV?=
 =?us-ascii?Q?mxmjByPogyq8pmHtZP/fOOx8yhZ+Qvko6/itnCjCWylLRMwqynohO5/l6yuy?=
 =?us-ascii?Q?HXy9m5dy1Tyw9iOCtXBOP26u2TCZfvko1caaG3z/MrZS1uqiAl1we6uwPFHG?=
 =?us-ascii?Q?hlqJ+y3jEKp94KTklUiAwZj/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7663865-4856-45b4-575e-08d95887e0dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:11:26.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pucCdhtzdQVihvkGZAUqwsdC1z8/WpxR1+D2FJb+W51lli5Q8VxuS8cwUD6Pl55B1rTsXmj7kO4cBEcmJc/NLb5guanIk2C9kGaZJ5rkzJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5401
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060018
X-Proofpoint-GUID: 9by0wuzJQ_PO-g63McnnONN2poMl6xH5
X-Proofpoint-ORIG-GUID: 9by0wuzJQ_PO-g63McnnONN2poMl6xH5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> ufshcd_add_cmd_upiu_trace() will be called anyway, so move if-state
> down, make code simpler.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
