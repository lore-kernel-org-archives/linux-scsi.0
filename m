Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89ADC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F7660F5C
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhHQDVE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:21:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44998 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233700AbhHQDVB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:21:01 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3BdTx027666;
        Tue, 17 Aug 2021 03:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=igltrmvDrz8uJo0iG5MZO0IMIjA7Zfih+jBYwWkiO1U=;
 b=ENxbzO07CGFc3LrQhi9j0TDIigLqNrmPU4Vab8roOBWXE9AAxV0APQXIg60EdTLQHNMl
 tljcT6IgXlLyDvklbfLDvN+GHRKm3Ko1wEJXJGlPDty7MJJPBVTeKrQY5+V9IL1+JRJr
 3pNANDnPXdZpkeL7taCNSSyNjHlyr2/DCfeCnoihJtqcr4DvyZxLXERYdAcftu9mZZrZ
 4565zDeNUXNrznnHLHJHlkQFcAlWabtVJVHH14l9q0pyWNcgcgLQvKanG5pwYVguK3S1
 kNx6hM7qSIQIz5l1IHbuKIAU6APHjN9qI3qP5C3ZIluSC0eSuh3gdt+wN/ENip9InjP5 +w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=igltrmvDrz8uJo0iG5MZO0IMIjA7Zfih+jBYwWkiO1U=;
 b=mQA89WSzGj7Kcdab3je2FOcbCoeijg/eN4EVQGGEck9mamFfmaiFaq3dyNuqlT7TTgNf
 7pKBuXFCY+Ja92baI+cHUCGpz+WqPLYUQ4NRG+3+liQCFvwuD8PchVN82iHE1GPAqbwD
 x37NugHdxG33BltTdKR5ccTfdqFkBp9b+xgMofyfiJ6uR4uMc+RdgW/w3gA8VVHt42Gc
 iCmaYF6Noy4hrgs3th2tLhnFHiwxhivTNrvcUHxAt2osepxv2LD3Z19k+I6qtM+K8UCT
 7x5vYgQYCpFbH0iP0yVzYbvREM4IKpQ+KZNAFII5kFs3YL/KPS+L3X02lF0hqAH4Zyfh 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af3kxugh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:20:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AxEN092022;
        Tue, 17 Aug 2021 03:20:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3ae2xyaaa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:20:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEJXv4WQDd7WBW/Ul93EhLyHFQ/V+EshAw3o09eWT5fase/8GGzi4Bts/wL4tkZwksfox4IJDEYEYR+heAj3H27JgHLTi672JKmiitTnDiMB92LlDduLx61igaupvzEkCuOF7ZOo0W+5VbPW5IZSND/FL7DpRJWCNTVuTacZJoHkIl3HzWuYzS12C60R6DlYHSPTjkdIiemNMwabbYoHE/Sa8lGIGeDzz9EIYKRpY5Bj4c4wIaE6dEFrfkHcgzyts3vggCakbkmxo/+KM6+6BA29TyfXfd5n1oowE2iWENXpxDslghOE456bKH2wc9emzgHWHLQY/v9UV7RiyRVo7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igltrmvDrz8uJo0iG5MZO0IMIjA7Zfih+jBYwWkiO1U=;
 b=nIYxzGxHg3K+fN/B/4v8rxhBhgrzcnZJlB0GMgZfu95PN7kRtfjNUCTb7oLrcayQ04Yrsy2S29Q1xZgZZHkGVa9uDHZHnH/c8Etukr2oOXcNMKfVbfgjBrpky8kMkkgI94ZJbzpQFhe2vUH0xFq5N8DjZN8JzBbIofKAZX+LLiquHCuo8hFs1eoYSSNvIZOfvuWmlpLESOw2obgqiGS8oPhnxw+3DxlQaxUN9sQh/0L87Y5I4+kVF1JHz8Tnpcn4qP9ci6G8Ux/zwyocgN7pPxzvgFFicErafcxEuzlnAHh/66hAQThIUzOIgA4sCqE18f3NZfU/sIDBJPuVkO/rFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igltrmvDrz8uJo0iG5MZO0IMIjA7Zfih+jBYwWkiO1U=;
 b=vgSvJzp/TwzIdlYyA1YKnpVVfLcVL8KYqBGDlrRfsaw8heJPOHgyvpFRF9BQf2abReB/XRcxbMi/NCbd4E+lTk/A88xKIHcXvIB3Rw65GzNfqvoG5TzKXq7Yh7P8NVkeC4/ngOJGGLala3DAKflKTflbIaiuBOVYiKoo8CyQNAw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:20:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:20:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Add io_uring iopoll support
Date:   Mon, 16 Aug 2021 23:20:18 -0400
Message-Id: <162917038628.25399.11610410321907110333.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727081212.2742-1-sreekanth.reddy@broadcom.com>
References: <20210727081212.2742-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:803:2b::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0015.namprd02.prod.outlook.com (2603:10b6:803:2b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 03:20:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d317fe78-2a7a-4233-bd77-08d9612df2d5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597EA4A6A8D61A4608990DE8EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rs1AISBMyGmbwkPEl1j4m7xeZYWglWMgTQTU68SRp9k/uVt1WZzK7hdo/zYitiXJSbR7MDJzWXq5TIjZpGFDnQBkc1wbldstBjORBx8qcQdSKbdZGf94Uv7hhQ8xp0QbqjGHbSwpBXP4SUyrcc4nWq5cL2KEyNyAlKwdOmx88vkYyxDhYfdNjtAJyVG4tyHnAdUHS+HfVmQZ5OzaZ/siyr67p3bjcs4AyrycFqpOdkgFVfGAchayenCuxQxUk5zi1C9Wv4W6YBSz0yYxRjPE8EOgqX2H7M6Lku0yCLM6vC0cuGpPp1f2ecmpU4+nCVU8f7n9/qGcqaWVLtIya/BJPBJjRd7+e5Wib9IZ5+MQ/TDmeoJ+DzzmM9ly5Ij5j4cMHbtb1KbIPlyctfJUNJLTehjaPQiKVCAXR/TL74S96Sr2q7JDGocW+YJYnoSZz8kjoVns8Ig2ss8Jvim96bcoztW8nA4awWJFQLX7QoDUDwLjZz1tQwfAlRwIV6Rx2H2wVwqtjuNJRsc9Pt59OgdJyz/JD64LuacvkwoHfLvrr9v8YDPVwT7dPbSuDDITiDX01KUo52vSDhS901LqIm0PAo7F6NhuL0Z4ET4L9a0tjmSxw1hDHcoNFWbqTI24BdQmDU2RbbxW0Njk8Bk5hNL6lZgfVPpypnMXyyCTtELbsNMszbIYXCIzZNFXRP16yF9x7nu0ybwsIGO2cf8D9cx3MSFoSkjjBKJmol8HaYIYJGGHRlcFNlXcaBusGzxJ6nKXQYwIlsbFGQFS7nDXbS1vBIghYuZiRyiQ5eZ4tyPJQSc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(36756003)(38350700002)(38100700002)(4744005)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3hrUUVnR1ArQVV4SE5IUGhHWE1rRnJrRzBwOEJHZXBRY2svNVR6ZVl6MFZr?=
 =?utf-8?B?UW1DREhkNWI1MmUwbzRoS3dEcjhVeCszeTNXRjE0Q2E1Qmt2VWpXU21vVHJP?=
 =?utf-8?B?ZGJHdGZjTStpMHV5dmNpRkpkeG84MmlZby92SVNmTjcxMHU5SkFHcENJUHVM?=
 =?utf-8?B?KzZrU3VXNlAvcXdDcTkrMW5mNk1WMlcwVWd4WE9Ga2c5Mnl6QTZSeGpFWTNV?=
 =?utf-8?B?aE0vYlkvbE0xa1lsMW9HL2p1ODhrRDJsL1NBTkEwUktLR3Y2N1pQeDF6QnJp?=
 =?utf-8?B?U1E4Mm9uZEtMOUszMFZGd0d6dmFGRlUvS0JOMXM0RUpseEhDMjR0WkwvSmFo?=
 =?utf-8?B?WjNoWUV4THpJd0RBN3ZWa3REMU1kNC9YL0kxOTFyamZPUWFqTEx0ODV5cWk3?=
 =?utf-8?B?Yk1BSWhOZ3c5MDBPMkhLNGxGNWJ2SGlUcEc1NG52eGlmc2dlaXcxOTlOL2Rm?=
 =?utf-8?B?MEhiWExvRTJjQkUyMGIvOGhtQkpGdWxUWW85NU9mUzFPN3V5R1hhaTV4R1Nv?=
 =?utf-8?B?VmQ5dnZIaHBxTExzcEFwMjlReDZ5VVQrQ1lIS0IvMU9ZbVhPZFJGem52REZT?=
 =?utf-8?B?cVVNNE1vLytPOWhzbFV4RDBDYjhzRUpQSkR2R01TSkd4NmUxTDBYczVDUTBu?=
 =?utf-8?B?aE96VTNKOVo2azhjY2JFS0J0OG0rR3FmcjVtM0kzZzQ4NUFhVUY4Wjh5UEhM?=
 =?utf-8?B?cnVVeWJ6L2h1VnBNSU55Q1VpTWhCRWh5L0RRbHY2RVJMc2djQ0ZVYTZnOUpY?=
 =?utf-8?B?aS80Rk0vZVlsSTQ5RDZvTkJMZCtCeDI0eDhPLy9PaWR0VlI5YzdFUllSWkVU?=
 =?utf-8?B?Z002SkE3VHNqcGY1a2xhV255bU9zUFZiVnplNGVERzUxNWkxRkRLVlBFK0RE?=
 =?utf-8?B?TDVEMmIvYXRwNHZZK3BYS2NTb0w4U1ZyV2dUK3dMalNkVkpVdDVCVnJoTDFC?=
 =?utf-8?B?WWx4MlE0Wk11S1VucXRzem5DMFc3Y3BQMWVGTERvNDZkRFp4dkZpclBaNGwr?=
 =?utf-8?B?ZGF6dnRwWHNKRHFBekIvdHNoUkVVMFF3WU5tSlBocDV4YThySk5YOUxjVVFm?=
 =?utf-8?B?NER1YVV0WkMyMGt3eVhnbVZpeU9aN0hQQ2o1VjloNFlCRnlKYWI0SS85ekxP?=
 =?utf-8?B?REkxT2xjekw5N0NYbXQxOVU4RUNMUUNQQWJTQmhyemtWZG9wakllMFRvZjJI?=
 =?utf-8?B?Tk42Wko3bFpsUkI0UFA0NERPUjMvZnBiRzZQOUZNTnZzZzJwdlFISG1la3J3?=
 =?utf-8?B?TjArMWxiRU9JWTY3Smo0eEI0SnIyMWtuMmNPelc3UzZKTUdaSUF4MG1XdWJX?=
 =?utf-8?B?cUxjQW9lZDNFSkNxRTJpeEdQY1RhRHB6aFRLVCtVeHVXUWtFWndFLzIvNzlQ?=
 =?utf-8?B?cVN5MXR2U2FjU0oyZzFaSENXTFg4aDhkaTZDdVFzYXp1bDBTVWhlVEVoR0Qx?=
 =?utf-8?B?ZlBjMERZRHFTVm5IbUtNemthUE54YVNSeDY3RjVpRjJlbnp3SFh6dzRKQUpo?=
 =?utf-8?B?cTh3VG5TQ09Ba3NENmxQYWRMcWZmODczTEFGRHVQdWFZS1dtUE11b25vVmhN?=
 =?utf-8?B?VTFVdTJBZ2lLYkt1aGM0UTlaL0krbDZmQ3ExV3oyekc1TWphc0ZFN1FsK3RD?=
 =?utf-8?B?QlRYZ0JvemNDZ2xQUCsvSGVHY25FVjBTejMybHh6cjQ3MEJqcERJRFkrZU16?=
 =?utf-8?B?T0xDeURySFl3QmVBTUFnZG1lZndyZ0R6UnN5ODBXUlFqOGVqbE9JbFhBMjZm?=
 =?utf-8?Q?WmBCMHK90vM4cUw6hsVRt0yHTgVoXWhhS3InYvQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d317fe78-2a7a-4233-bd77-08d9612df2d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:20:23.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ViibAeEmJ6L+/8GX4N+GTER91qfuot2Rf0+w1dwNH1vyo0sFq2cDXkRfzghbW6Nz9/tNNkAM+IWXj8z/8QfQiQ/CCzxodroYYxZ6isTWd3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: ssbNFbsOgfOVNdj13u2qc-F46WlmL20m
X-Proofpoint-ORIG-GUID: ssbNFbsOgfOVNdj13u2qc-F46WlmL20m
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Jul 2021 13:42:12 +0530, Sreekanth Reddy wrote:

> Added support of iouring iopoll interface in driver.
> 
> Driver will work in non-IRQ mode i.e. There will not
> be any msix vector associated for poll_queues and
> h/w can still work in this mode. IOC h/w is single
> submission queue and multiple reply queue,
> but using shared host tagset support it will enable
> simulated multiple hw queue.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] mpt3sas: Add io_uring iopoll support
      https://git.kernel.org/mkp/scsi/c/432bc7caef4e

-- 
Martin K. Petersen	Oracle Linux Engineering
