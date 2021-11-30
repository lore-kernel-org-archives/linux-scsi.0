Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBFFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 04:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhK3EVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 23:21:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4658 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232110AbhK3EVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 23:21:15 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU2gdl5009070;
        Tue, 30 Nov 2021 04:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4i9TqRoe0ldVD5/stIrFpLkf7AyqnXsCuJ3DdUXWRks=;
 b=o2HcZicLjtYMAkX2rEXExrVWyDjOw1Exl5v3X4mtAVwdge3Bjq85fZisZlfZBji8rrHB
 jBbyA6AqUJWp4TEo3iunLQ6zALjYirESwGKdHcdaaYfdAotwa9wIlkSn+ZHIb5iS00F0
 TlCFkwclOgpscItXOvG2m5or0UMSdUJIkV5eZr+hBPpcrurmTvrkFgvq0ni8fLE2z1ib
 k9XvQnk/C66xIKapi+pF7ilTPq9IhubylR2pJSIJOkVkDLIdGtT6+xLj0FURrEJT4BMn
 gkwgDKyWEQMfl9aO4GnBtr1wvpmdFzcjSfiHfbMv4fS62pQaGM46hp8VEMSlIhPg04Qb KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9p962-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:17:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU4FjgY145377;
        Tue, 30 Nov 2021 04:17:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3ck9sxr8jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9y8R1psoArKUXIr9w/FhDx4GmUUPQLcPBjF3YvASk+1KaV+xWd45fSiHDP4QTd0nFSLjuPDT10qwcrACpd///YtqDCHGoUriknpUnc/9QSQlTures6s8EO5PrTVPA39EFHK8/F4q3x/qnBudvOLMB50INz7FjiDhsUJjDDGelEOFmwdUQTSzc/rJwuKq6+L1OeMKSsb/8A8scy969Blgj0Dyn1tkfRAH35etcyw7C2JvkgHUHEdaxV3tcfgf5JCBB53i8+6CeXnYaKRmP4gl9v7TOMJqdyJtjwzas+eqOj9r/Jqq5FOGCAkM9albtj8sNht2aMxswLcJXabkWJv5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4i9TqRoe0ldVD5/stIrFpLkf7AyqnXsCuJ3DdUXWRks=;
 b=HqV3d6KMzbsmq4OZg+KUhJ1ZFtRUjETfiQemiCaW5813Ekidt06ONo+3EV/ZuCxcT3j0IoPQiY4F8U9OT4aFUUyitROzPd7Z0Prc22z3A4n5q9Dqe39n48jqniARNcxkkABe1mOO5JEd1AoVQoXkNIHqRPbz6t8Lsfe7V70SgL4OEVySq4Orvy+UMhE3vQlV1u9Ww45FeesbN5JgIVsLfVxloAybaErF8k5hO36yze6r6ScBh/+OF/Z8qCpBk9mIN5IqX/ALp4kDL+Zaw8X6sYPK64Vm5IdhCoCvtmUQSX6mYu5ybwuUjTFyJQvC5wvCt52UYOAtEoRmRYJ1EDADxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4i9TqRoe0ldVD5/stIrFpLkf7AyqnXsCuJ3DdUXWRks=;
 b=kriOCoCuzlYAv12m1h9gEorEcN6kia2lyqjwFdoFr9+P2uIFD5Bh6d1AhIn91NGpGk8xlu6Kh9GaX+XFuC6LgwUB9grJjuFuz+QXjURJlxkfq8OugzAs4kLMN9DWUVRdOCq12ZmJZLO++7nKNbjuz51qRPcg1j3Hg1pMrJF2ujo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 04:17:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 04:17:21 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y256xp5b.fsf@ca-mkp.ca.oracle.com>
References: <20211125151048.103910-1-hare@suse.de>
        <20211125151048.103910-3-hare@suse.de>
        <1eb99f16-5b65-3150-48c6-353b088818ad@acm.org>
        <239804d1-aae7-63ba-c3bf-ca1dd523df6c@suse.de>
Date:   Mon, 29 Nov 2021 23:17:19 -0500
In-Reply-To: <239804d1-aae7-63ba-c3bf-ca1dd523df6c@suse.de> (Hannes Reinecke's
        message of "Sun, 28 Nov 2021 13:44:53 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:806:6e::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.10) by SA9PR11CA0009.namprd11.prod.outlook.com (2603:10b6:806:6e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 04:17:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 719af296-e26d-4c87-81fa-08d9b3b84dde
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-Microsoft-Antispam-PRVS: <PH0PR10MB443773C08D9A6D9724FA60A78E679@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lD3jgrEem6UAmvTS2pYD79+zdAB3Z9ww1ICFZ+0R9b6/MAZpNjnBrxYFjz/Snpjy0OZ0/e3ljxv9PlY1pvF6+lqt3IWZtGh6Othw9nipGiNmEcWF1stccJSQxhQOvcf/c3EswxemEfp8uuMzM0aqUar2/L/bYcbDEU6fSDb9Pfs8ieQIoMtCsQiwuhOM/6opDTJoulzoXIemtOLbvg3GYE+wbaf9eP2E8OBn7s+r+vyds9sB6OtHppwCCWzUjFiRQMWeZyX+9I2lzkMUzHpJTTkm6bhYtiRYr7VPttDR7uQq+Ey77i+v+15LO868rRG8YA0Lp5T20Ez80XvD0bnz4TLptLQttoToGECJ8KuSErZmNPS3WiJrfsOpoAZGx/ze+xY/CvkuWUo9bUTYSQ7JGsoogoGeHjRDC9G8JBnVvXUqzBg1zcnU0+ewCsTSj3m656wezUVdAq6wJRyyP0kFEXkpFsvpD4OMw0cyUcBR2XyVgs2idcDX+XObrWr+H/ThAY2U3JTxpYo1Xa/AvKDbb7xQ0s2e/GUyrOYOpmdhdTXvtPhcvMVlNbwBaCuEirdX0QF9GikCSnsqMYw3gLbDS1ZnbUJtzmODbSb7a4VLbN4i/vPRy5OXRTEa1MT1jH5vvq3Cakre6o6u89ujzBcCaQMXxHk5qMjmkP95e6HE4OOrHBwUOwKLYoXjTuU7SDZC78AW2vPUoX4HzTJpWFMOAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(956004)(66946007)(86362001)(7696005)(52116002)(36916002)(508600001)(186003)(2906002)(5660300002)(38350700002)(316002)(26005)(6916009)(54906003)(83380400001)(38100700002)(8676002)(55016003)(66556008)(8936002)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nTGz7VBf53shEPdsR4Vbphok1+79KVpYA7w9dTlYis2bTvSbDMT3vCwnMDtX?=
 =?us-ascii?Q?DaqX8blbXi6zaEE/aRyIQyMvkcfRb/vD9o6F0Ocaaj5PGYBASWU/3aMK4+c0?=
 =?us-ascii?Q?ZoqM3AtjRirU14/kWH+eIM3cnvw0lrKXp/UItnP1wgoJDfqhQOh1DrEMHtjQ?=
 =?us-ascii?Q?bRCw0rQ9DXKDriAEJcc1nnYfukuKyRXc/xBccR31tpUdXSjJfh64jd3OogUf?=
 =?us-ascii?Q?yUDtN1w/cPO6w0yFK7AHT3Jenfl16iqhsnpV8I1tD/V6K/kzdkrtDunfeUgd?=
 =?us-ascii?Q?LfuRwM05xgKmw2luOFwyP5i8t6zjCGb5vZWwV8sVcQefe3tFspjHvCtxN+5V?=
 =?us-ascii?Q?TfDZv8bLjFvLw1LU/NHosXMvxpUooM87n0yAfQ1x2Bj7lvu7Q+FQiPCBTJAx?=
 =?us-ascii?Q?rmHqOwQH+TvtE+4vpuPlbBbJcpoIqwTDFK0RJdc+HjiWXM0KJWNY1lW7eyzA?=
 =?us-ascii?Q?LNBUl6xfhCe3b2N7LjzQBxoiV4omcoIUCFPMp8HXoxguhWB7m/Wf1d7rZjw8?=
 =?us-ascii?Q?eH/l3yalkjq8gXFK5TqlFF59uLQ78QPto845a51Fd1qYAc4OyDA6EED33zBU?=
 =?us-ascii?Q?/syPatZ3s0gNP5y+BdMMFnRSYurLrVewiaJHVH3tFfTUmz/iy7nV0RtEV5YP?=
 =?us-ascii?Q?Okg+lcaIwAwsEsd79VcVBQ+wZA76iU/TewoZb0AuG9HCGIe0V4o3FWqGr1kW?=
 =?us-ascii?Q?s+AH4kvx/nMr9qddeTuTUBNa7rGy7NTNQgjuqFaxK6Ki2QyHx68GbBl9zqk5?=
 =?us-ascii?Q?UPLii9KwWGW/TTAECIhEnLA0DlTvmSruvzpgtMSgX4ZXZ5WCBTbuX/LtsD61?=
 =?us-ascii?Q?S4BuH2CuL6dhUeR6dDc9drjdRDBky9Esy/KQD9QEq/N70UvCzgs01ppeNMtl?=
 =?us-ascii?Q?sNNfgziIyTPFpgRhvQ6wiipSHVCywyQh2T/Vk9yLx10DGsKqncz1WPXYCPYt?=
 =?us-ascii?Q?G5Uwc5BU1df9Av45SkSLe/llj8bRBwnK4W1lq4b47TVJmziYrTWhAU4Ttuj/?=
 =?us-ascii?Q?y4ZPbQnZ2jOWLOgtgLmbzUlj4dFq67lJFxvj+BeFeGfBVsiqY/PuDEDdP3Qw?=
 =?us-ascii?Q?27dRFSmkK2AJGwEqjo6WgbsTaqUwpZDeEh4WqRawehhiOOn56osIeBavBG24?=
 =?us-ascii?Q?hS4V2kcRfFFf/GVztIaQyvZhD/OASRHPp3rcg5epg499q9SGm8MIBO2Et9OY?=
 =?us-ascii?Q?fgTM5n856NAUI/yIcbyuSW3xD3BMa/mf+brsOkQYZWu4wyQNEmU4SJON3W5f?=
 =?us-ascii?Q?2xtdAmgmjfo0xQTTeS6x0zhYTll0EWBDdgT5ZpgyH/3RuKTgNELU29zOdVE5?=
 =?us-ascii?Q?6PzmJGyLtWXLxDZ+zCTvG5qMIeWlOEQQNKmMFbO51c9MU0zVktgRk1UmZOdq?=
 =?us-ascii?Q?/NFHbhAdTlITzBzCgCInwsoWsCUXIWC602Ftn1x1dxa14melnblO5kTNGnRR?=
 =?us-ascii?Q?JPkR20eafOmXbrX2wa698//U7BbaW3F9rqBWZSCg+DtJ5TgLJnAVvgSH/BOH?=
 =?us-ascii?Q?MZ7eNPhOo5K7ID2eq2XQ0lO21DGALXnfv7NPYCb+SZ/m9yhMpB76U6M4u5Ok?=
 =?us-ascii?Q?kJJMEkNpSz0LlRukuAPXDz3WP3GhhPUhRkw0AqhCgCPSWSvxMxqgcd0pw2F+?=
 =?us-ascii?Q?NX/w0UWTb1ndtwky6nE/r4qram+X4vE+ZqQDai/60lK5izp6Z31MwNNaJCdO?=
 =?us-ascii?Q?UfzWaA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719af296-e26d-4c87-81fa-08d9b3b84dde
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 04:17:21.2433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8/53ta8fzbgQ0KglMPs8IGIZfuJ/+jUL7fS4PNk6hu/9KIeskc38TXC0s8jg652iIV45aK8Vn6WAuhloHEehZfnToQ9e3xR45C7lGhrA4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=726 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300025
X-Proofpoint-GUID: gEWEeyX4x3gdxO98IvEWA_lIvrk9WBgy
X-Proofpoint-ORIG-GUID: gEWEeyX4x3gdxO98IvEWA_lIvrk9WBgy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> I have oriented myself at __scsi_execute(), which also has
> 'data_direction' as an integer.  Presumably to avoid header clutter.
> Martin?

Just a vestige from ancient times. I really hate scsi_execute() and its
10,000 randomly ordered arguments. The more sanity checking we have in
that department, the better.

At some point I proposed having scsi_execute() take a single struct as
argument to get better input validation. I've lost count how many things
have been broken because of misordered arguments to this function.
Backporting patches almost inevitably causes regressions because of this
interface.

-- 
Martin K. Petersen	Oracle Linux Engineering
