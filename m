Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386D5C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8E2613F3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhEUVCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:02:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32590 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhEUVCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 May 2021 17:02:03 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LKevLu005932;
        Fri, 21 May 2021 21:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lp2D1DnliXlUrIdBj0kJI225w+oz5W5aCX0T0vdxAeU=;
 b=cnfl2EFjyX4Yajm+j/pdSWj7IwCkPnxH498mIX+H8vTiGoJ8qOdlX/5SDMJlO3EX545T
 3zGeUtxtUvdQe8lqRtsiTatMs41Tw3rA3ixVgDIJ9ffOtLgS7gihkNtYMFs/5HNFrHq6
 14wH43l4HjY796DjsKY/ZWSnw/m5R4lZqZ6UWHgqVKQ6Y3Qp0fcstwX4n+jRxSvYx0SL
 SYe2Rrh6k8Wi4rBcXtQLSGCh8LJpNlpRmGPtQGy+U8vXUJ2X/dNC/iyqzShdzd0pdlmQ
 C660KF6rOX3uE7rixYY5nrcuJDEAgaCRO/oUdDpihnibTzQNQN37XxM1WvlZPIILI679 ew== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38nuuwggnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:00:36 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LKgHkK146939;
        Fri, 21 May 2021 21:00:35 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3020.oracle.com with ESMTP id 38n49340tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0aOoyAIPwz6mFEFBTN5bnVuygNTriq9XhRySVuFZB96hzD4YuQpZgn2mySHS8DgZX0R/Gt5l1cKmPFAgCteE5Fsu9QTSorYqOhAHGX37rhnwvp285dSwH3QodOBh+oNUEZkKjG3mno3gU4l9VrEUaplgw9ugnjAuDwX9qySblnNIGfuPQkbaQ4H/MpGZ5QKqwYnQ30t7LWwo5+p9N8Ar67PI00qfwBpEwIyvxNrJFkkyj2k+pGROwL1Req67ltn97jtsWmfKYgoZAr/CAArj6hilqEBEZWiH6GuC9GBEzgJjfzcjNJ/TdYh81lUzfhbjSix4Ro9bb+uA/jsV5cX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp2D1DnliXlUrIdBj0kJI225w+oz5W5aCX0T0vdxAeU=;
 b=TSNgvSAELIBI/wP3CjhtHrw7TETU6gOAaEMerupLi6YpW9wT/1dQjJITbv/kS8onYkosTJYquwHPKfIaJGwkBLumZ5kjviKe7DOaYifbklFMZM34uazrSxSNsLbvgVHDsLFlrxVhkYXnIr1Aq8SUQwS5mKNNMtKXpZzAkFRyr3YzoTEZEsYHUBTUYf9uGprtwKYOHZfN4Iz8fx8hJfuQegUJLXhq9AkAsxzDw3Fs+YVWyWFZCCsX/aVGnkBbe/N1/KGBO1kTNH3n6QyuBLplBPxAGi247Dgwk9g8Ro4Lvl70lhWMQV3+3tv0MydWcIlr7qle0eIXfzhn+JQqzxqyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp2D1DnliXlUrIdBj0kJI225w+oz5W5aCX0T0vdxAeU=;
 b=OYO4/SaRuSXpvaNnQUeCINBf0OqrxYvaedjMjGLckKJOlH9vGinu6HefA8jgCUkiV3UZgZ69i9bhqccEvD5t58Od4UkcJnWI0G0W4df/0z3hqRU5uGLzbF9QWywLgvmjcMelRq3ROoFDMhXoRwpmPX9rjIboP5bmeU5/HsJjku0=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4550.namprd10.prod.outlook.com (2603:10b6:510:34::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 21:00:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 21:00:33 +0000
To:     zuoqilin1@163.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] scsi:bfa: Fix typo
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7iv3iqg.fsf@ca-mkp.ca.oracle.com>
References: <20210521092153.379-1-zuoqilin1@163.com>
Date:   Fri, 21 May 2021 17:00:29 -0400
In-Reply-To: <20210521092153.379-1-zuoqilin1@163.com> (zuoqilin1@163.com's
        message of "Fri, 21 May 2021 17:21:53 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0059.namprd05.prod.outlook.com
 (2603:10b6:803:41::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0059.namprd05.prod.outlook.com (2603:10b6:803:41::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 21:00:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c15c620-e6cc-4926-7c32-08d91c9b792c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB455061F90B0F24551C59B3028E299@PH0PR10MB4550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gq3lDRx8Q54HuC2ljBnzHW9CU6dPnr/dgzaQm6jH/1W0ao+HAiUawxjlj1y4eWB3mbSOvrescvXE70zUnjRafeAMlgyDYvaPYGGGx0Kehmq+3zZ7VdBcUApO2R8pxMcQfN05ZO5SY00Qh4MBDd0GrI5LLMNQSHlUcpvp2n2Hrp9iawA3d/NUZuAANreq4ofaDd5s+Bx91egZ0DKU8X2wmK2omcIGjckKrkBqhm39Prx7tU/n7VG3m56W/oGrcbe6B8zTc6dS/zRHYeTptorpD+2IdygqVFgvSZzcsIkl/9p4UzuhKFRbKIbikbFEP9G/bP18VnxVqn3XJogduU/lMH2jEpPl5SXF2+lHI20nT3kUkwvizRmwHOGW9I3gIHg2GVKBogoX4kmgViCjn/FPfEeN7p4gQdWlShlhUkFCRx4EWq0JeYcXymLyCU1gcFPsmYyOODE/5TWwEERtbrgwJgLM5AcKmsCiQ7TmHQaZwlJTUMdZYkx/XVPT/Uudz1Mehm9Pe0lxcY4I0TLcHQ0SBGQGJCDdD65fL+NCWlLV2m/s8d5P3+ceZjTLwcJArknMCEMMATl5tOMrmo2mRkLlFdqSg824NB8ynlRojFv/KbRHsDSU6OOrm3YVFHIjTvx3dUQyjZgnby9rjKI/6w6vP2iIEWwRSWPj44Ma8FbrdmU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(396003)(346002)(316002)(16526019)(186003)(66556008)(8936002)(8676002)(66946007)(66476007)(4326008)(52116002)(2906002)(86362001)(36916002)(55016002)(6916009)(7696005)(956004)(6666004)(558084003)(5660300002)(38100700002)(26005)(478600001)(38350700002)(1491003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aEdASMM7KNWBOlEAzdRRpI313K3QkoW3R1PmIvkWuPxhuXtBCL7qzxVlMIZH?=
 =?us-ascii?Q?eCCbNTqEE3J0In7diIptUWmMzSZCrrAS/MNJO3MJrtAZHg+d2FC9gAkNwi0N?=
 =?us-ascii?Q?ba4AUpzYu2qvmPe57DZjntLAEjbCWYhcGlUp2+BBG4SblYjpEQrobzvz2wGs?=
 =?us-ascii?Q?Ci0JVzucahxI1i/451Uw7QTY9DOQf28uLVGqjb6CBsjTi9uYMs1Pfnszajwx?=
 =?us-ascii?Q?eHmaseHdMQIvxViXlkaujWCoQN6KYafGu8x462cR1seQB51LMlKyj9kwYlF4?=
 =?us-ascii?Q?K1y6yEYnPcb5yp5Wr0deAk6T6CK3VZwqpywjVCzrNIKptrMhASdb2tNikqY4?=
 =?us-ascii?Q?j7grHh8BPTok8c3ZZg/OrjeJIz2Pgl41uoBmwaeI/xwfTPpHyTdCLq7GN4vP?=
 =?us-ascii?Q?N2bldPP3nNCk9fxY8Hls2Io5BZWpxo20sN7ecRiU1NkfseBfmLQn9VuuxHvp?=
 =?us-ascii?Q?xFXePjN6mbvTTf/SFNDyMIXlQO/K9mo5GsXM4pVDcHOMx1MJInbXFAa1Zs/M?=
 =?us-ascii?Q?pDqttZGxbC1Q7hMlU83wFkE18ayyBcxMcWm9FaiAtblAn8F4z39KQJx9oWbO?=
 =?us-ascii?Q?tHhMX0GyCwONOLPy6eVe8EpG/m76E8jPoK9hoAJhN3/SRc0ru9OEh1dC73BV?=
 =?us-ascii?Q?IEC64NPleoLNpR3HgGnCznxpokkg4kX+/cQ2KIcJj0oCK4YkU2NapQwXaT7B?=
 =?us-ascii?Q?E+2AfO4JWN21gd5k9hJXSCzJbX7IqwxqvPStAuYeRqvaB2aOk2OxW3jopwEn?=
 =?us-ascii?Q?PR8jxTVoB9rhCkv+Y+eX0DMgTQhLkr2apt8d9HbVvTb1wxqXYQ0jTA3NlJ9t?=
 =?us-ascii?Q?Zj5gUOcX6Yu2mVOIJuj9JX2YI4aNqUMM3NVb1YpS7F9EmEyW2iaqVlx6BwJc?=
 =?us-ascii?Q?z9KXPRPJv8Fuemn+7vXXGPDO10pnAT0DATFDxMnvnoInL/Y93xigaeO32bHe?=
 =?us-ascii?Q?Bm+wy9TqbcTC+bFNsVhM99TUn3F3P0ruZiFdyALFrWKmfP9Aq7Q+MtUetawO?=
 =?us-ascii?Q?pSOWkuelh4Wtmnu8pZBvzq1TiQN98PFXGrUBDy4tdhBD+vUWQjEdK5OX7a2t?=
 =?us-ascii?Q?g/w92vNtEyvertck58gsEBwljYB4jqYkK9RDM4e+a9zhZoeCpOfZ8d8pD9ft?=
 =?us-ascii?Q?rBp2SqgXI/21vgVbCcWmZReCg6laFZChlA9VhOOXWa/u8A+RkN8shDsLLYjX?=
 =?us-ascii?Q?n0QskOnKZcjr59kW4fxEgG0A4kaVYrxmENvkPKX0JoDBn6ibT544m6d4dVRP?=
 =?us-ascii?Q?YryE++EwN4gJjGiT1PNV/uw71gtmo1xWmsI6xLLEQOg3yO9WERWLHHQ59DzY?=
 =?us-ascii?Q?RtTY76kxtxOsGi9RswXFcWCc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c15c620-e6cc-4926-7c32-08d91c9b792c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:00:32.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eU6rqEzZgG+pKmR+fY/NUXeF+4/ECCGYnoZVTf7pdw1eyKREEz2PxEwC15SSAWJKLUT4OTeTeSo4pEejjnzBpA/AnUWC4mhghM+oMcN/6EQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4550
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=958 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210113
X-Proofpoint-ORIG-GUID: RADuoQJECi6qM8Wu_Wvrl0DR9s3aFves
X-Proofpoint-GUID: RADuoQJECi6qM8Wu_Wvrl0DR9s3aFves
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zuoqilin1@163.com,

> Change 'chnage' to 'change'.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
