Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776C9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250E723B08
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbhAOELC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:11:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbhAOELB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:11:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F44xIg055951;
        Fri, 15 Jan 2021 04:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RS5/K2M/6YNYc3laUHyP8IephpVc8UN6CmrOBF6XL7g=;
 b=FZc9ED7iVYdP+M6wX6NEI7TzFanXV7eIfdKMh4D5T1ItgFH3/SARdLUIyODvUi7xvHcA
 SPvROmWIMdlxUrnBh+VWF+dyHhvN8OJS+Bb0zKVWXLXPLbe7CcQV7I3kGOspYy/j8G/y
 xttwhnKgeDAh3U7fB9/vLflZ1i3ETyDwy2ciGqp9X+aZFpa7t8QoMahCH/uJHQis8wg9
 keAcvK64XkMWyg37FbuHrgGrPZrcKv/4lZoW1LttP4+QYkX2Upr/JmYb8B/VALeozyXK
 XT7iVfC1uBtIvECM2+2cOgLPsTW20ndW00x5hNMI/QSTpIVOd165qOlXg6WUYqiTIekJ Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kd03809-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:10:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45nJd019169;
        Fri, 15 Jan 2021 04:08:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 360keaqqh9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUmeodTIVw3YSfxm+pKTO9txc9/v2hynjpfEcAPYNfzwWHVM9jQeSFsCUvh+76kftZnj7rvtZftDCPU/110aLtiewRtXBiV/Zv9FnTRLLFEtrQfPLgJeCWcTIieMFF5NDmWs8PlOVpT/iY8dQA5Kx/Q/o5JCAIklbVJcWOl/41Eec7VSpmBHSacqPZTefXvnUmGUNtmtABYrpQEF2E9BizoNHZKHmxT7bGCXeqnSHFpJBc6xwXYkmBlCbO2HQ0haqUB3enAnuQ+bhH0q7b5P9kGW3XEl0F4d1h3+IK3qMQJuQetf0AMmYVE/g25ylTyXj2xWUDW6ufcULgSwcTt1bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS5/K2M/6YNYc3laUHyP8IephpVc8UN6CmrOBF6XL7g=;
 b=bVqGXDQGE8TSS+P5zkhTG76vxb88AvHX3lS9I3sUhED9Oy13CS9/xi7bi/LkbX13pI9sVkNqUUEfrhccY1nEJl2kiGLil0FEmVhD16i2BHSpl5P8/5/lB1BLTRNaQCCVEUiye4XzKcBdNFKhmqKs0HRlcCuYcY9Xe4wy/RfTd0dV7bMG271NLgBMBgqIbnf7FjqU2t3AvCICznvsKXIUGzGU5m3F0fyeHnTEYyZpq5QSsXq5DadgB2NBcut/pPh5UMgk5wYoR+fa2tt2n1jAMo5aC1ulqkQgPYYOCtMF36aiQTf7r+9DpBo51QVJm3mKycJjRpZaEfgcemTicmQ8gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS5/K2M/6YNYc3laUHyP8IephpVc8UN6CmrOBF6XL7g=;
 b=FU8464X9uH845bV7lUpDIOZarkdNXLAbSQJ42H/9ivXryVkNq2Eb3CQeSmTcgjcsQViliOovgYJyexjzZPW6ncQjnAUmee8WxiCcsbbnmdUuJQpXKSkip+H6XXMWEFCh5HyaIqhJLV2M9/jXpSmjohpF8xCF1G7H4DHokZwmFnw=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     tyreld@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] ibmvfc: Set default timeout to avoid crash during migration
Date:   Thu, 14 Jan 2021 23:08:08 -0500
Message-Id: <161068343563.2956.9052227812367890176.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610463998-19791-1-git-send-email-brking@linux.vnet.ibm.com>
References: <1610463998-19791-1-git-send-email-brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR13CA0212.namprd13.prod.outlook.com (2603:10b6:a03:2c1::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.4 via Frontend Transport; Fri, 15 Jan 2021 04:08:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c99ad0e7-e2bf-4f21-4bee-08d8b90b2d3f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568E65F70EC20AD79E26DC18EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4IUnzrt/YCiaKyzWFit4j2/goBwokO+ayjA6xNptZ2fqEjR0XHJ9uYYdqgPQ5hKiNc5wd37jb4CL6+YdJ1DZX2b+27uTioCbmEzCY//aUv8ZyQCvpTME9aunmRqrOLRkyPseJ3y7mAqsH54KCM52jTmzBsY3CMaNS50iZ7+uoV4ZDYhvfg02ECRm140zNrVoZFIvktqgVE0MBv4ycWMb9gMDVtzP820k760TSgqCQXG+n8/kjVqNjgUbH4qwoWyEYgoOpW6A1m/MeE0HNAB4vu9zlFTfYdeZ+4RAYJuafr8k4tAL7tp7mG7kYmI97W+x+Ny8X+YxF3SNb0nWi6cXY9aPIskTNOIBERqiw/Bx2sf/ys+ki9QzXfTiC6zzcduYpj7iRkZypwLKpoUMwMuPWH8hBiGci3TYHbDE8kSvAh12kLyZo+9sVy/JGvuZBdvgSMCH+gZxSSemxGawtskqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTJ3TWZaSXJXYkovTHJhMWk3ZnJBYUU0a2tmNG1SOWlrMkJaWC8vdTJob3oz?=
 =?utf-8?B?Nm05eVNkdS91d0srSWltVEIwN2lTMEFXVlpNY0U5bC9pYkVuenZoODdXTkZN?=
 =?utf-8?B?REtieVVJempDRWJYS1pycHpqUGRBV1B4M1RzdllPMzU3MVIrb2h4RnJSSmUv?=
 =?utf-8?B?MVVkU3VUUW10eURQNHJYVUxOSmoxN01lNDdHVWpNakZKaVNhd0Q5dm5KOGpZ?=
 =?utf-8?B?REJoZ1p1Sm9wVkpNYTl5WGNqanp5cFdFTldsM1VvZU1PTytycWNpL0VCTktW?=
 =?utf-8?B?VXpBbERSaXFjUjZqL0taRExFWHVzM1NwNysvMncxN21DT3JzeU5jNnJDU0NB?=
 =?utf-8?B?bjdscjB3SmdHWVJyWnIyZSswclhuRFpCUGJIa0RkTExhTnRCb3RMNlVrR2Nm?=
 =?utf-8?B?Um1QKy9EcWRiM0JnRVVDRUtBZ0s0bFZ4NDZuSWc0WXlibEN0aCtlMUFQbFRz?=
 =?utf-8?B?L2NuNnBiVkhUUGROU0M1cUtpN01Ddi9ESFpQczZzSEJ2NmVwYVdpWWUzc1Ny?=
 =?utf-8?B?MU5SdzUxcEJPT0drRlpOTnlJS1laRGhLR2QxWGVQWnMxZlg2S0drT2Y5YmNj?=
 =?utf-8?B?T2tTcTdUcFVFajdIVFlDaXowcm1Ka2hSYzZsc0hGUUtSenpOMUhVRDNiNktE?=
 =?utf-8?B?K3BrRGY4NExJeUdoTDZUSlhRdkZnaVF5T0ZSZ2lLOHE2UDVFMURaNkVoY3VV?=
 =?utf-8?B?cmdpZTYzc1dkNW9Vb09nVVJ6YUlneGhvWDFXNThqc3NaWm56NFY1UDd3amZX?=
 =?utf-8?B?WnRKbWEwSW5WYmpxTGlnOGtibDQvdmZCOXp3Q0NocHkzQkxvanhrRHRNZFBl?=
 =?utf-8?B?cTh3VXkyOW1xNGpuY3BPV0M2OHF5czNzclJkNFN2bnBkb1NwN0EwNHFGMDFp?=
 =?utf-8?B?TVhCUlozcXZLTjY5NllGZjdXQVVacU1WQlBuekxDd1ZkSmluTXJvY0IvbldT?=
 =?utf-8?B?YVlJeWxPT1JXRHo0NnNvWkcwZ3RBQ2NQUjVrUFlRdEJyTmg4OTI3aVlYZzFl?=
 =?utf-8?B?eVg0L29WSG13TjVSQ3VoMENqcVd0UjQvbWttVmxRTExrSUpBb3l1UW5aQ01S?=
 =?utf-8?B?L3FnelQ3dVhYTkY5VEZyWFhwbU1VVlQ3TkxLMFRtUCsrRjhyQ2dmMG5jSStM?=
 =?utf-8?B?OWx1azhNaUtLRXlUbDRXektBNytManlHV3cwaStDditLNGxXNnk4UldjNEZi?=
 =?utf-8?B?eVY1Uk4wOUY3alp4UEtDdFBUbWl5UXdqbFN3RHQvY0JWR2VOcnE3NFc1aGV5?=
 =?utf-8?B?Y3Q4WHJDVEtseGZKaUc5MGpEa2xrcTZ0NmhsMjdPaHVMbUtvWVl5cFAxVG5s?=
 =?utf-8?Q?1ZMofcTqT+BQg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99ad0e7-e2bf-4f21-4bee-08d8b90b2d3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:12.9897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10CuHb/qRPxEhg36nwSyUkzTiz0XYsGlSRVtb82hz11IzwTNA9ezKUo6+0dgjqzBqRBkwC6TMXNXzY0ga5ht145Fo9GMvp+E7LlViyZTvF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Jan 2021 09:06:38 -0600, Brian King wrote:

> While testing live partition mobility, we have observed occasional
> crashes of the Linux partition. What we've seen is that during
> the live migration, for specific configurations with large amounts
> of memory, slow network links, and workloads that are changing
> memory a lot, the partition can end up being suspended for 30 seconds
> or longer. This resulted in the following scenario:
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] ibmvfc: Set default timeout to avoid crash during migration
      https://git.kernel.org/mkp/scsi/c/764907293edc

-- 
Martin K. Petersen	Oracle Linux Engineering
