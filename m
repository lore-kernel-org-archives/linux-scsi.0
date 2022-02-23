Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6144C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 03:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiBWDb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiBWDb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 22:31:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5D8BFB;
        Tue, 22 Feb 2022 19:31:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MN51pc028032;
        Wed, 23 Feb 2022 03:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8jHhHeJ4irHuVD/QotFdAfJhuadPribhJ+pFMRkJIfk=;
 b=ViaO57z5i7uPKt80q0Yc9eYnDveDf7+K6U0yA/X7gSCS0Xhusr7eKcQSwJbfDI5o0Q7H
 sRTo/aKAy4crgLuFNVIErNEjT0yiJgwGg9Yg15WKn8PDE9QF/rmgL89sDGG//UWyjTKM
 ymk1b1b98TpHuc/JjpJ1hM+Z0qQLsuergreb+1AmeXIgGQSMHH1l7JeWdUvoOVQyQRrG
 ZJGDIpUDeOtTH/Ct7/R3i4kjMsq+wZJ6Ase/m2B8A+DILPVdfdht7ECaUugmAIkXVGUW
 bVZ/AcBlO0Y1EI2H7RoYtrJqz1rVf0l/hBDu3ZpiY8Ng1RPHhTQ5Mb3418LszKtS5dmS jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cjwcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:31:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N3V74L029204;
        Wed, 23 Feb 2022 03:31:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3eapkgwn4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:31:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6cnySt8+96ld2BoCeUd8MyxvHQuoGcE8ExSoSQoLFhq1pCCTwvqV/5EuU7Tx3q/I/u1Ezm+89BgchOtO+OHzrLB+mJXFmi9ZKpcKvc9HkZwwY3MSvvZbCpBUX1Zu8l1S1CYrokIc9/oCxtktJRuHjg+EUexyfF+iCXu3FgRDb1DkmZYEr8UYb0pYh7rC8SG8Vf3QaR63gN8ogKqCw0+D7Nonw3GukfRD0ddYqaEtd/hh4v6MReRpQ1WwjbD6ckyGRYkINhciW4ko4fpQL7Hn1HXJmgxh/j5IWgdmc8psCJevtm7biy96QMkuJwfZ8mi2E6Muvvsn5QfIFjndjJfyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jHhHeJ4irHuVD/QotFdAfJhuadPribhJ+pFMRkJIfk=;
 b=Gi+nlEAv8cEXT/2EojZStNC1bOcJM0W/A9MoUqNXvjAR/sF9kiT+2rLPFCcGJllKyyl7gVEEs0hwQ6885k07mP7VE1giiNjWxQLf6EqUUkDseA7ZrpEjO1TFQgDdsmniexKTpRfkrO1Ia0DrNJOhKjWG+A22lcCa6WQ8KQQs8qXNEvkau1W2h83+ElY1/fyMru3azF4HuQQL0lSJqawQZgwnpnfnw+/PUnUbmUiWrfGbJVlfAv/aZv2s616voyZjem5jNCDNQTsbbeY7Gdzg463DyLqN2LRnjI6ioMj3FUdEYAy5J8kWAS/3ZW8FAVUXCqCfUpEAuvJLDuLDaj5gUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jHhHeJ4irHuVD/QotFdAfJhuadPribhJ+pFMRkJIfk=;
 b=zWI8Pm7JOmhbTLqAtQHaJygBdNNfWNqZiorbEuKVJTUs2Qqty6zrHLvicnuFTIV1W4+ofekhVN5+582gEfMsySPUAXECRiXITeuF2L2JMEFQ/ybAEy0hOzil85M8p+/0e8UGttCVxC/VG33yjPVsc+WhPuAtzU3FMV+63WtHfGk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 03:31:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 03:31:23 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/8] scsi: remove the cmd field from struct scsi_request
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ley2b6rw.fsf@ca-mkp.ca.oracle.com>
References: <20220222140443.589882-1-hch@lst.de>
        <20220222140443.589882-5-hch@lst.de>
Date:   Tue, 22 Feb 2022 22:31:20 -0500
In-Reply-To: <20220222140443.589882-5-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 22 Feb 2022 15:04:39 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5734659d-4a92-427c-dbe3-08d9f67cf6fd
X-MS-TrafficTypeDiagnostic: BLAPR10MB5106:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5106761BE299DB5B117B65E08E3C9@BLAPR10MB5106.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFu5HH4UladhIUcYdTmwxR4Aq2jsYR5SqY64QWp9efwQw98NLwytk3UnVRJ0OLN0oFOW/yWDr5930nDLCHOrxojNqKoy1Wh+hY35oL+sPmB/Ngu8Atff9x0RtEm/G+YLeqzs/5bxqCG7hvCNQqVuITI5ALefc0hcKQGCpELXgJgLCAEPF/Nf+7WNfL0+NVOL7L5K/Qw+3IBXExJ6CR575LbjZNxR9ZdgIVFa89v7XmDTX35Honlb4nbBT3raifIV3QvSzvyLCzGn3n3G2daHwb0qkMYETdlCczBS9jqcDT01HzD2EQjo1j/e2j7AMwuXIv9Ydsm0ABVLvbcVvJcM+NMrmdNanFx4/+SXKQNwhZnxasCD+i0dBtDjOrhidcF1+B2Yx2q9Ev9nsheb7OBb9/AUx2wRQguBlDszX9tHbIJkE+mTBclcB0OI9QXR3w498GBhQoGbnPxWvlfow/+ejtx8WKi5VEhIGiaZO3vIi4+tuxv7Evtu2HTo6uHIKZJgLC2XWRRA4u97Nerj8riIY9vlb43vmZIcPxLY82lvOikhV/n5eJL7xNOohK+KQTZfeQ0IEScKmVtrl6A7GZG6rPQMtt6n7Al+YBFlpJpyjnXHCspvQsjZ8zqoFsemYOsyZw2pNN/ymiVrOBu8atA6FD9xRuyBdKgP2pxH3h2zj0ONd+THjzqdRhg3XDP6V1mr+A+3aepMiojWsA6LiFT9ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(38100700002)(38350700002)(86362001)(4744005)(6916009)(6512007)(26005)(186003)(508600001)(6486002)(6506007)(36916002)(52116002)(66946007)(66476007)(8676002)(66556008)(4326008)(5660300002)(83380400001)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zmBMYdRpHJO49xkNHDjB3lDji9U6QzT27Sr4KyLrafNWHg4jQCKSgao9QXbP?=
 =?us-ascii?Q?Zm/Fcj84pNpnqnAzz7vTZSsGt5okYroD52KvB+Qqmr/gfcdTQKZxkBLTiOgC?=
 =?us-ascii?Q?vT4Ipqw8MlJA79yrEBPKuAi7TMrEJVVatgSze+Ca/pO+PFCBj71gKKn0/mFM?=
 =?us-ascii?Q?vOUtJrr1ydwsI0uz0e6XCHWMPhD/ohnuXgNvMenSjoe/VfKNogIFWsHdeu62?=
 =?us-ascii?Q?2X5V06PDK4L1e228lk2KpX3J4/bqTDapGRRbM3H9NnNK5FUnkta6skMg4hsn?=
 =?us-ascii?Q?jV9qAKwn7vdTwm1R7iyT7WoA+zmXHZUDT344mPGE8E2j9rQ4FTiApVmQ6TQl?=
 =?us-ascii?Q?X5VD8bKRssPQEOeiUAqNsiDgh6WRcT72TpWFSTDUFzWc6qf6u6T/35ZkiIwC?=
 =?us-ascii?Q?QasJmH9Iseh5X7Qolez6PJE6fIoGbkqhfsV16/2BwWG+bcz+w4fYA1SHyp3V?=
 =?us-ascii?Q?7uVqJwLKZftYrQYxwGuz6nmA1+SvveVySGOMsgeU3TIotRvg1/Afke4wIJOQ?=
 =?us-ascii?Q?GIaCh2aRhUYJuxSG8cKGxHI5Ev824kh5N4ww358GZMilHfUuJz/kNMdQhsuQ?=
 =?us-ascii?Q?tJKrxVo6HAenfCZAdCYocOs3lOk1x2R7ToR3v3ZjLm0IPY4jSpUkQ86+UR/S?=
 =?us-ascii?Q?AW1r88hDrdROpd1iut5diOLA1vEUrAfxC1ckEEzHFaM6W41zwTTg21hDPgXv?=
 =?us-ascii?Q?nyMxWm7Hma55QJcYIN30X+oRqUU+na4JlszgRHc8+QJk8npoqPYkvpAuGSha?=
 =?us-ascii?Q?cQKa/NaNc3XvaTBrnvy7GsYzqIOKq/GPag9NQTcKFotoJTd3449u+qVEtZY2?=
 =?us-ascii?Q?qkd1fqjJ08cGQFM8cUrLJQ0R9P2fJQdbouEkXubRlOzGPGmP97+fbTrCmOK2?=
 =?us-ascii?Q?eH9J8vINa+wgEpjlxPRTsJ+8u02Wdw0yZmT4MpNM56Za1nCkPtC6zgfPkg4r?=
 =?us-ascii?Q?GLAVDV4k5zCuDmV/iB76IV+CsQQVxRRlnh7upeB2o64Q/mMooByBaJ7ar9pG?=
 =?us-ascii?Q?yj3DJJe/WrNPRDOciw4DSv76Of6NVjtmT0AgtS1DfBPgp7Chq1Inc3dbae8r?=
 =?us-ascii?Q?xxdAxL31q4kRWFgeShgjEKY1a6DRQQUFGlKHul4My81J2IXg8SZ8dXBuOCdK?=
 =?us-ascii?Q?ZtEgW2MEV4/uBFS0cMFNP7800lQ7QQ1wR0ljTR3N2obFDyXnYulD4MgLjjLz?=
 =?us-ascii?Q?Ks25fZvDlnCdqwNrOOClbJ70soKP+wz0bt8y32TMDa3s/KnKe9wxeLLYz4qp?=
 =?us-ascii?Q?2ZU1W4HtdLMo+ALp9oC6HYxKfaospWZoJNUh4qPdQvsVnIjicd5AViEJT279?=
 =?us-ascii?Q?db7kzOGnZUtzSPkjzkqf24gyQfGt4RkX/KHv6oH+TZJbZ7EKkPifM7jRN9kH?=
 =?us-ascii?Q?Hu6FS+A/J2GNhb/wWFMVAbE5kx4B8gP2Q1Z/0rdfm41yDS1G7pqc0zFaiX7s?=
 =?us-ascii?Q?GWh8y4Mhl9J8M4p4nW8ro0Xt0F/NJWMnRSnklfrdSIG5KGiBqutRDfuFBAsU?=
 =?us-ascii?Q?BRcp4UMooMcEagRyWY0hkC3JPDRY1f+gUGvs9+Hb2pyFHYGUxzqbB0crzE75?=
 =?us-ascii?Q?bynJqz87U/awD/yzG/8iF/5AD2ReQ7rmd8pQjk1RzvaIc4Dze1Xg/HgYk/43?=
 =?us-ascii?Q?8O17NA+17FFIOd24W7Ft4OGs2J0yfD/LvF31S1eXh8mm7sdWEC14iP+Foyeb?=
 =?us-ascii?Q?4wnTSxKcWO9Fvb+SiVAqb0XfxHM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5734659d-4a92-427c-dbe3-08d9f67cf6fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:31:23.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNGO6pa779kw9QAZJP2pY+M5AM/xn8eLXfbAQVBXtpC054IcC/SodOseODkFygp+3g+q3xq0fjYmbquEV8U2jXVvnPOgZU3nnkuFnyizdNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230017
X-Proofpoint-ORIG-GUID: gHJ7t_d2mu_-hGhdDWpFo1ZuuEwKWade
X-Proofpoint-GUID: gHJ7t_d2mu_-hGhdDWpFo1ZuuEwKWade
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Change all submitters of SCSI passthrough request to store the CDB
> information directly in the scsi_cmnd, and while doing so allocate the
> full 32 bytes that cover all Linux supported SCSI hosts instead of
> requiring dynamic allocation for > 16 byte CDBs.

Been wanting to get rid of that for so long!

> On 64-bit systems this does not change the size of the scsi_cmnd at
> all, while on 32-bit systems it slightly increases it for now, but
> that increase will be made up by the removal of the remaining
> scsi_request fields.

Excellent!

-- 
Martin K. Petersen	Oracle Linux Engineering
