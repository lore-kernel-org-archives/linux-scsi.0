Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24C8C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABDB611C9
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhIVEqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50614 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231686AbhIVEqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4RIJY028916;
        Wed, 22 Sep 2021 04:45:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QG0oEdiOcdj7n1ipR0NJiuWzxCDv6QFd/lBibfNdPgo=;
 b=g1l3Bkxuytm6TsXdZbdccl3Y1rScILf679+Wllwv9GnINl9mslKhY2EaCMNkv1vCAEXl
 bVHvg9UOn4452nc1nsxK5MU02Q7+oy+H5C/VnPOBqLrjxwOSWL2wpHpegOJLntThG/Cr
 imIwGttrRZvpiU3x8oC+R6oHB4Bz2PpH5WlutF5o7chjmDYeRMvKIpY7aCgN4H2jwUO7
 rG5vQudbLgPTzmgNX3CUaWaxLQR8roITPs1EffN8JS2pPFVrOGnKe6V59z5BLnM+UNK4
 tQXrOe1lkrnMdDkMmIQk/KjKAEkegU2sV0NYsjT9RFp55auJaD19bpwSf14hAD0yS09g Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9dmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4iwBl195776;
        Wed, 22 Sep 2021 04:45:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3b7q5bks3v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jP+aTs1QFZBhBCDYGNa0JdugqTxDqt7bXFbIuE06OZl7Ptbg70lHNWawdv68N49UCoFEgTQjJ1l5kyx7whdLUEJ3JOHAD8s6CxzwUQM5ZjEzuR4YBGtBdK8P6LuHjBtlpjwAreBBVbUxPtvaIV+lPG6JBs5ahgo8bzBe9kYYFUDQizoABZ10HvtzmV1RpaML3jDM6LQBzffPgLqYtQyBjw8rWyvLI0nlpZa+t4tc1cvdM4IXWL1jVMhBrzMwmiN+H7fxEwmkn+pUcF+Q5bdBCQJ2zDcsjfLZ9BZiSVjvoKBi37/GAP0KLWIGRg47BHBEgA4w3Z+3tLi7D2bKMV0TLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QG0oEdiOcdj7n1ipR0NJiuWzxCDv6QFd/lBibfNdPgo=;
 b=bTEZSXpqM8F/jniVEimSh34yIses6ygoiwILAqv1oC1bSU4x3cyWVZkvhy4L3i/YUx50FLRQzbzZNzhh+QZbvA7ij81FYBqN3UQXx9krxCES4moow+y+ESZCLPyhGZxpZhHvJgJ3kYHQeTF1rKAVo1wbXhAtjysyaNb3lqZOcpTdzwUQ9123L6vD0zu/Uo7y2YM4dWJVSVTMNRdgxr+oVbKZVvsaosv6/vS3a3QKugEiKoqh72VlXvafAOKqT0bkthoBO8fWFl9l6gXcW54gUPVeY9Asx8mE9YJko4rUCzpJymgXRVhFXKmThDS5cQHyr0w/kUF2Bfe0HheyDGWm4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QG0oEdiOcdj7n1ipR0NJiuWzxCDv6QFd/lBibfNdPgo=;
 b=WSrqUuVB78gJl65iNsmO84IawQX/+XX5PixTYNjWb33bWXnTKVpYASduw+G5u/OEDkc5f+v367NgXpN1QNBs5FnVbsKIgxL7QCFeIaFomfavFfvzghdheodp9gaaWCHyMTE0pgNSinpCEOmKC+5ey8ltuW0NBkncbbTT8DxYaHI=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:44:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:44:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical blocks
Date:   Wed, 22 Sep 2021 00:44:45 -0400
Message-Id: <163228551951.26896.1448511489868595589.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917212314.2362324-1-bvanassche@acm.org>
References: <20210917212314.2362324-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:44:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 452356c2-7494-4737-b730-08d97d83bae9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4518377EF1A8A8CE95B17EA78EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMli1KgocRL8JbvlfDxBdwGy5SuHhuVkMQXexyeD6aZP8fWBueLMIFsfmm/Sz0Bzj977E16PCSbQaLgnG8elYKD+2nZKWlR8ZdCw7/ktf8J45CZ1K+ln3/XE9qIDwViYVoUOGLXfud0+9xig7bER2XN6SzYyZ0H2ai3n4zJDgwiaARlZK5mY/OeDj9KMLyWP/x+cBcRa9XO3HxwIe1V1U9yQWTDB6Wea/0NtRNckQhc5vSBbDA2/l/NZ6d6IdQWA/GQZ1whf/wBzH3csU4AjQ4alchH+zKm6tLyn8PXcxEBmQlwp10fvqPCt403kEw2fH6+bQJ6qSJueUi733iEAcre6VgStHAVQfN7wBjWFzEQeohWr1kBtDBN0unop1702QDvxhiQ4MHSij1oS3UzHVJ82/Ai9DcKSX08XVhLAhA2AgMBIhBPu5gNM1f/oOYGR5xGCYo/FhgEmVd1pUc6BFBT76aaf5E5VvWVrFQIgzmDRU6KwWxFZTpn15uUYZPU/vzLgpz5Le13ywWy7vU8p2CGQ1aMvhZnYJWfVsAhPdPuKygf+BGOztvnXBKAfcfBtYLlJdD9ajZy0KO4vM8YjSUvQcOOcbZS9TgBSXjLugqoVGCTaLpdjOld/mwsHyYtyhx/5wVQYC/9Gtg3bC/ob5eLnqx68od01ApmpEVrkxzMDKSOyK7a2L2hCGorux0xAfkAfo8u/HEcW2VdDpeFAsbBK7Pjh4gLXp8YBS5PhuY/w6McTZkoBpBJfs4iossxBX85Svr7S6FYmePmO4NiHL4zV8HhUOUjTz3n0ffPGhNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(6916009)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(54906003)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eE5zRUVQL0lyaGVFVmJSMnpvdWt3c21hYVVnNjQ5VGpzSmxPTlcyaVkwdFgx?=
 =?utf-8?B?bHVjZWdyVXhMR2lvWThSVHBxMk91UHo0dzNjSGtqcnRBUWRxUHp6OHIySktH?=
 =?utf-8?B?ekdZdkNuUUFocmpjQWZYTGZhVFY2aDlaZkRFOHE5ZmpKWkFtcjNhcGN2THVk?=
 =?utf-8?B?Y3RhR2VvaWs1am8xcnZOUkh1VDluWG5vTjlwbVpHNG53ZnVqUzRsR1Qza3Rk?=
 =?utf-8?B?SEp3VGVnSHlLZzRVdGh0NGJ6N3k0eENGRTJOcHVLVG5EMzJLRzdHcUw5Y1hj?=
 =?utf-8?B?RGM2UE1iOFhGUWt4QmhRSUs0RmpjTnZMZXIxWUw3RmQ3OHBTWEVONlR1WnBJ?=
 =?utf-8?B?VHUwL3d3a3hZU2paMm5BbUgramdtTnh1QjZJS0xNOE5zS092NnFRdUZxVFpK?=
 =?utf-8?B?VFZ6bjVSMURpYnR4UUdxVjBVY1RTWEJRWXFMdFFESVVSRlZwZ055TU1TQStH?=
 =?utf-8?B?TzhxbFVpM2h0b0NGbFNoTEhiODhmNjVWRkUxN1VEQzVpUVNCQXh6RUhqazhn?=
 =?utf-8?B?ZUx6cmIrQnpPc3NCRUdYcWdzUnpPVmh0WnRGekM5OHROK2ZKVXNYU1hCYlVO?=
 =?utf-8?B?aFIxaWt0QmUxNzJrakk1b2t3enRLb25oVS84MExlZ2dEak5neXhlVHFrUTJp?=
 =?utf-8?B?MWMwekhjVjNCcDhJejVjSm0yR0poaVF5WEdTLzFQb1dPYWNkUXJMWk1ZcDhP?=
 =?utf-8?B?MnlyQWNHSEtRK0lNSXBtcnNZU2lPcmdlTEZRNWIrYStONjQxV21UNFQ5UENS?=
 =?utf-8?B?cXEzeVdRVkVhVERLTHhKYUlEcTNKUkNGaHZaVzFlOWtTUXRFQlloc24zRldk?=
 =?utf-8?B?bnhDNC80blZvbTVoc08wYUJPdWVKNUdtSUMwRzg1aUpsL1Bya0hITDFmemVo?=
 =?utf-8?B?cVM1ajN2YWZXaWU4QVRWZ25CejEvcGNPWHM4MFU3eXZ0MFJOS01ubEtnWHNY?=
 =?utf-8?B?UFVQckluRG5VMVRWcngvREJ4UkQxejNwNWtac1hBOHJMQ1ViUnpBUHllRFho?=
 =?utf-8?B?MktiYnMreUFubjV3ZlVXY0d3OVdJaHJ5Zld4NzZVTkJaTWg2U1d2UkhYYmhK?=
 =?utf-8?B?eEJlOHFvS2V4YWxVMTNIcXIzb2VXbzY3Mi9FREV0UW1kNTBrenUzUkUxSXE1?=
 =?utf-8?B?SFAxMm5Fc3N6WExhdE5GZHd0MlhNTnYvWEZIWndaTkIwZXl6cGFmVlpIbk80?=
 =?utf-8?B?TTVHdXZRbUhucEtXM3Y2elVweVJjTmNWZW5VV3JOVjEySndvT09GNFhtdyt4?=
 =?utf-8?B?d0YvSkFLZFA3dnBLNDlMVWpSZ2grcEhaMlRxczVkM0xxV0RNM0lVWVo5eUlj?=
 =?utf-8?B?cFR3WVFSZTZ6c1NWOERkL21Wc3hidFdrZkRGSnlVZC9hdnFhbFhqcEJDc1dv?=
 =?utf-8?B?K0UyU21rcXZvRGFWajBacGFWT1d4NFFoVkhIVVlLS3ExaHI0NENVRzhDMmlY?=
 =?utf-8?B?NW9ZR1YrY21mY25wY20rOGhIdHR0bHVsSXIyMWZob09lT3NYZ3pvVk44V01j?=
 =?utf-8?B?cnNnSkEzM21hUnV1R0pXZFlBYTVKV0wxRzAzQ3hUdHlib204NDdMNHpNT2Fv?=
 =?utf-8?B?RGU0Vm55Zkhaa256UUlDNmh4b1h6eEpGYlAwUWJWN0JIM3lIeCtmZi9xZ0lL?=
 =?utf-8?B?MGtGMGFFWDBNTTB4TlFsYXhZcUpQS0hHWnMwbVJVbXg0L1pTUmV0eUlpM2lH?=
 =?utf-8?B?MzZrSi9qRmpqdHM0enFSVUFUMi95eHhxcnZxeTlyWGlmTFB4eXYrMnZoVE5P?=
 =?utf-8?Q?6NRrVvDXYGWki5oIHzdnrGEQkI69UvVlrRnDB7m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 452356c2-7494-4737-b730-08d97d83bae9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:44:58.1285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8U9SannYXknvNlcUw6qKtIrrjSdcrsfhHqjLvL7cjyy8Sk3FcrAo1tqsKzlb8SpCYgDnc7APGaj3kFXom6+jHRel6aIWgXhp/Iwt55/lC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=842 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: tELuAyu1K-1ibdrt9Yf1z-h8ej0OtWjc
X-Proofpoint-ORIG-GUID: tELuAyu1K-1ibdrt9Yf1z-h8ej0OtWjc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 17 Sep 2021 14:23:14 -0700, Bart Van Assche wrote:

> This patch addresses the following Coverity report about the
> zno * sdkp->zone_blocks expression:
> 
> CID 1475514 (#1 of 1): Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
> overflow_before_widen: Potentially overflowing expression zno *
> sdkp->zone_blocks with type unsigned int (32 bits, unsigned) is evaluated
> using 32-bit arithmetic, and then used in a context that expects an
> expression of type sector_t (64 bits, unsigned).
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: sd_zbc: Support disks with more than 2**32 logical blocks
      https://git.kernel.org/mkp/scsi/c/1d479e6c9cb2

-- 
Martin K. Petersen	Oracle Linux Engineering
