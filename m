Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66532C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5249E61156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhIVErb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28208 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbhIVErR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:17 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4ZpDD027991;
        Wed, 22 Sep 2021 04:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zu6MyFG+xBYQGjAbMuCzF9ALOvqwvw1S+aa7TORpUT8=;
 b=X+hEK0KicY6h9BbK36dqllguk00Vygm/muThX5pxiapNn8QLkFqqwoDALDolyNqOiPO0
 CbNXllcfEQrrKS0+dPLZ6aX96AqZkLqgm6SP5kzWWwik2p9x3Ixdg3/uiyaX9DGMoQCY
 LmqKkWeoyTKy1GPubMg5+YFNTsFB3xx/fnr9klmJG67xp0YYn8al2RYl20Z0n8W4PtEw
 HYRomp4Qrbsyx2Pi1VCG4dXCpeDNJI2qus1QqdmK6Y41UegkqVG8+LNApu3ebuMUTiHl
 JKyGQ7134GzHbus847fU5yuIgJiFomZlFzBndk342PN4L6mpEFVEDaPjGO2FL7J56h0z nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9d8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4imvL117636;
        Wed, 22 Sep 2021 04:45:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 3b7q5a3ry1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+LYsQWswU443G7b/mHhHKNq/fgQ/CY0+GWDzCthnR1iGq5WoSAsHwrVdRQvJQ/YIWCJwm+6ZpBC8/gv+KgGYkzY60E2VOdvVwT6EROPIBLh6c5IWe1Xdk6nvFK1WzyGTKwh7N2Ogg37RylzGB/Vx+CZvoYDSIyi6wbkcxDa5ktIHm6E4ZvJmN3/WXAcMgl0m1UgYcieyiKJOILHZvc2WJHNBVKowdiL+3WxlV5JWphr8lGnA4OcU0Vy+6S21uIsDmun2XpBZb0VgAku0YiYVh0DQ51yLBQ7dVAMjre64BUYt6zgcyg6U7PeqIP0jR1BnJ83FkSn3Fks1AN0JiL3rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zu6MyFG+xBYQGjAbMuCzF9ALOvqwvw1S+aa7TORpUT8=;
 b=LeNis/dXZFhv/7GZuk4o3gs0YYU8dfl8rFHG5GZOUTw4N6PWavD7rkqoNLBWPJX+ZneMdN4evNBYRaP1dVM7ocN4NM8Hj3Z4vaTKJcWBOVEjVReDoekGqPTAO3fAIUdoxNGMyPDt+mPDrdgX80mj8KSXoD7AVR7DnOU8PyK0E2FQ3vop7wcE3DufkR2f9hjwGyrx+THjih6bXdh2uBYUmdMHEw1njUfTn5J0q6Hjsn9rbyhaEqN/VV1zI4Otf30Y45q1HKUpHC+y6SMP2ERJnhpvfke8HNE429jVUNNqQ383jGWJmi5wdxdhQaQ61liUcfwaX2YmiZ1JV0j8LR4Hfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu6MyFG+xBYQGjAbMuCzF9ALOvqwvw1S+aa7TORpUT8=;
 b=0M9nF4Su36O350dScqjqLiw5LEX30LqaMtma4CIAw8oSLBRrJHLmMVE/kEeiVQgeqpdgPte8unsDODt5J1Zfr2sqZVXyEn8iJ958SCwrG2/3e2rMFE2FHaF9YdJ2Nl2CXjYleDIAkaTUlgXQy9VeewoKODuyky+WwvGmTb/AT98=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, loberman@redhat.com,
        djeffery@redhat.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/10] qla2xxx driver bug fixes
Date:   Wed, 22 Sep 2021 00:45:23 -0400
Message-Id: <163228527479.25516.3753888645653767823.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43132cff-6fa6-4bfd-0fdc-08d97d83d347
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44560EDA3CE45606C8BA495B8EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +kDq8fYUEnAfXfiy80s3MVmjB2mBuvW0MZtUVMA4YSjbEmNmLxPzhouzd3C7ZY5l6/RThV+3tcQS5PqTtN4euSDmZFj3viP0i00A6ufKjo1AKHCz2d72t71RTY7hy6k/mtMt3oUicPLwZSoVRCkLKpLrGV//bw1JQ2RaIApYQI9W4rrCmSEK5M6J2SS7dQcYdf+O+GAzqEsqdSGjkDcSYzZbPNX8k5cACcAK4S4sp5pQQciBO7dv+Nn0A2EmkpDi7/C2PVqjuTSh0AL3vsZEFQjfQiaIW/pJesQY1sLwBVv2wuj7Keg3ZLzYhyKUgkw2Cn+hamjLmjvNW2GZU+jcuMDJN58gekAYON++fzjRcjkotbUujOxK+BwtfLJUXcACPy/MzWjsUHANaSFTBu34+FcMxUMw7QCJxhfBPYhgU94Oh2GeBjdH1pD+fRaYxwpqIrOVdXiH3cUcshawB1dXqsGNZSMi9bvcP6QNuuVOZDwOgazNAWVbpXkkFc/VR6OOzkDzQQ9N+2uQK0Y/hSNg8497aykczRkcqPDKKvqEI1fF0phSA8KdhIrc1oh3rVLcO4lhrGMumFMSko2ZwS+5nbdbP3ex4jd5fnby8rc3LzO/ACfrlswz8JTRW5Qqj5uYO5g74M8b7wHDbUeI6wZSlplpVftM2M/nFH7J4isyOERoW75TUjN9WoIP4W++SQfh+zGCtMG7SCXBKntDmF3vC8AnpvMvYM0CkuP00TjuB0ZqWBRuyMd2EFD1TnMsf5DPiX993SByDI2MJQgp5P492sksbStjSmyoPNUTeaXIUqNjoUI355Ymq/jSoHPgtCgDp3qdJMsgOdMxHIdkpqFaPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(36756003)(6916009)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(186003)(38350700002)(8936002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0ViUmJFbGRzWTUvVEY4Ym8xYzlSMjUxWnhYQzdhdjh5djdOTVZCdEphd2cz?=
 =?utf-8?B?M3ozdkc2eEE1NVhjUi9Wa1FYeURGSHo4RTE1SzBFL3lBOUZRMGN3bkEyNXI0?=
 =?utf-8?B?cldTV3h6K2NwL3N1UVBISTc1RVpISW4vdkxNczlpWWRxTk93V0lSRXdaTG9T?=
 =?utf-8?B?L2E4S1RMT1FqblBsQ2lCUHo1L0FyMzVMT1B5TC93d21IVGs1Tk5YR1cwcU5L?=
 =?utf-8?B?MldQMDA4bHhIK1IxQ051ZDJOb3NIbGlGYThjb2l1MUUzMENBRDRsVnpyb1dO?=
 =?utf-8?B?NzFuQlp3MW1qeWljYXlZaGNUZnJqRVZlTmZXN3BxVzAyanY5YzJNaXF6dWJX?=
 =?utf-8?B?eUVXKy9DeC9CSW0xTTdFWmRRYlhmNFRyeUtBcGluU0d4KzhIVk9ZTUdzTG5n?=
 =?utf-8?B?RC80OVVkUytPOHRGS2ZCTm82UVV5SU1YYVZEbng0YUNlNnF0ZTE4RHArUUN0?=
 =?utf-8?B?TUVwcFhGemgvRjR2OVU1WFkzNVhVTENoMzRJWXRoVjVTTkZ2VWUvc2ZFdk1o?=
 =?utf-8?B?Z1g3d1pQa2hpbUhBSkhuMTZCb1BaYk1mcVN5RlFuYzhRRDh6WHgrb2RGSzBq?=
 =?utf-8?B?OWg0QTZ2Ymw4M01xQmNseWRQVjNmdTBMYWtUQXQ5QVVCMzhxeVBwNHY1VUVG?=
 =?utf-8?B?dk9LU0FzdnlFL2huai9hNnBDR1NrQ2wyeXowdmMrOGtqeFFYdTRENCtSVDN4?=
 =?utf-8?B?dXEyWk5LOWU4djAwZnViR0xWZWJxTlArSGp0MEVPZjVYU3RzeitEZVZNNG11?=
 =?utf-8?B?OEJheG1MSG0wRG5oNDFhOWZ4R2dSdVQvSG1hOEJKMW51OUZSS3hFdXVaN3l6?=
 =?utf-8?B?VmRMcDF1R1NhRDUxYTZJUlhSYWRvQWUwVC9Bc0c5bG12WE03eVl1WnRoczNK?=
 =?utf-8?B?NkxZY1loT3lsWU9tUXpPQzZMa0xlU1JZckZBeGVvV2FwN1YxR3loOWNySVIv?=
 =?utf-8?B?eWxORXhlSUtWWENVeFJkOURKc0M2bWMvOENnSkNzUFFkZGRaYk9vZysvazlE?=
 =?utf-8?B?MVNjeUlLSEVJQVZQVHp4bWIwMXc4Y210ZUhFamhYcXVLTEhpZm5HbGp2SGRi?=
 =?utf-8?B?blB5TGFKaVc4QjZ1WmpTdXpsci9CUE9GSFBEb2E1WlZhUHJEb0FGQUN4TFl6?=
 =?utf-8?B?SktxWXkrRnVHVUNkdXp5QlhhMmhjOUlxdXdLS0pwejQyU0VzMjliNjlKY01N?=
 =?utf-8?B?d1BMK3F4TmpNajlrVTZnWjR0Rk83V2VuVm5kQmVSdXU5SFdrZjRZUGtYZXpW?=
 =?utf-8?B?NmFPdGoyNHlPTkkwQWpFM2NBMTZNclA0V004N24vM1lMZXZaNTlRVmUyWEt2?=
 =?utf-8?B?TTYzMllqSkVJZmRhMWJ3MlFieS9hMnhPTytBYjVDQllZUjkrSTZlZit2dVF4?=
 =?utf-8?B?bXUreS92cUttS3plalJGSTlBbERWQ2NMM3E0cDd1bWNjaFVtMjZuN0xERzA3?=
 =?utf-8?B?QXlua3EyUWU1OWF2ZmhUYzUxM1dOMEtQcnlZZU5GU1JUMVBQb1hQUGhEajlT?=
 =?utf-8?B?Wkp6dGp2V3lNSzNLeWt5eGlHU2Y2anR3eE9ESHk0R2FqWExPalEwM2Y2NHF1?=
 =?utf-8?B?WXd6QVJGK0ppTk4vNW10bFFzWFVabmxTZDRqeC9Nd1VTVzhLVW4wZDhhTEds?=
 =?utf-8?B?WVhDajEvR2QyU3JTM3IyVFpITXpmK1JiOWlhTWxJK0JmTWd6dUh2b1pWM1E3?=
 =?utf-8?B?NERGcTdtMThmbysvbGFkTDJ5Y05wZE5Vendlb1RzSi8zK1ZIb3JHU051RTdw?=
 =?utf-8?Q?mHYkv1BBfMesCihIr/rPOlJKfC+hT1895n8nxBz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43132cff-6fa6-4bfd-0fdc-08d97d83d347
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:39.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2+HE72lL1vWWb0KgqATmTkGZrg6J7VpwPVOha3qEZ0aQpDDfAm2uX6hzd2s6ozHl7u8+leTQZ/poewzdP9j6tzHlfDRHtwCet8z1G0suHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: 7rLwjJpd6MBPFHrutVvjoAPsJcEtJS37
X-Proofpoint-ORIG-GUID: 7rLwjJpd6MBPFHrutVvjoAPsJcEtJS37
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 8 Sep 2021 09:46:12 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.
> 
> v2:
> - Added Fixes and Cc tags for few fixes
> - Replace hb with heartbeat to make more readable
> - Added Reviewed-by tag
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[01/10] qla2xxx: Add support for mailbox passthru
        https://git.kernel.org/mkp/scsi/c/9e1c3206960f
[02/10] qla2xxx: Display 16G only as supported speeds for 3830c card
        https://git.kernel.org/mkp/scsi/c/52cca50d35f8
[03/10] qla2xxx: Check for firmware capability before creating QPair
        https://git.kernel.org/mkp/scsi/c/8192817efbc3
[04/10] qla2xxx: Fix crash in NVME abort path
        https://git.kernel.org/mkp/scsi/c/e6e22e6cc296
[05/10] qla2xxx: edif: Use link event to wake up app
        https://git.kernel.org/mkp/scsi/c/527d46e0b014
[06/10] qla2xxx: Fix kernel crash when accessing port_speed sysfs file
        https://git.kernel.org/mkp/scsi/c/3ef68d4f0c9e
[07/10] qla2xxx: Call process_response_queue() in Tx path
        https://git.kernel.org/mkp/scsi/c/38c61709e662
[08/10] qla2xxx: Move heart beat handling from dpc thread to workqueue
        https://git.kernel.org/mkp/scsi/c/3a4e1f3b3a3c
[09/10] qla2xxx: Fix use after free in eh_abort path
        https://git.kernel.org/mkp/scsi/c/3d33b303d4f3
[10/10] qla2xxx: Update version to 10.02.07.100-k
        https://git.kernel.org/mkp/scsi/c/b0fe235dad77

-- 
Martin K. Petersen	Oracle Linux Engineering
