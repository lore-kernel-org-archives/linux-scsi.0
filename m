Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98F0C4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD1460F45
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhH1CdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35844 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233140AbhH1CdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:16 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RNO6xO001908;
        Sat, 28 Aug 2021 02:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=s2tcZPnZG1uHNpxSRa2uqlhDcqRVMDG/1QTu32THWEk=;
 b=1ByUG/hw3vnTyQ5GQVnikkq9+/stm9byW3xuXrpf/iR+wR6bUhX+bCYLovaiR4O2jJXy
 UcXUrj5luVZ3oO4x1X7r3CIZQ3ttCarER6vJjf3TKr1YUlugjP+RbEJxWr1Dfs54Eo2L
 0bZABFMIL+gJ8t9U6A2WCpIysihDO55HEBJ8mhtkAolL7BJ23qRId0cCzLCmRPkbs2/c
 jztg+a9VbP4mKv7p5WBmiKBt8yqLZP4wHqB10nxZfvISzDGjh0cdfKS+Zgg9nn7VXLjt
 bA/5dBD76qo71NOD2NxTxE6s0lIIE8LaEN31pdY5IioPsNmzeuaOtg16O8Sgc86K+fWw ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=s2tcZPnZG1uHNpxSRa2uqlhDcqRVMDG/1QTu32THWEk=;
 b=SMERn07NC2flIj67cvhY4Sec8AmsKKFSlreleHKARy9H3hQIaNjzMC8ZSfOASAzMEYkS
 yHpiSWzAU546B874tx1X7I01xCymtBxeTg79C2m98d6Q8/SNW4/fTU8iKZvgWdE/sVQ1
 3NjJ7NrFOKhcQ19+D+Esk1titwH4UE8RL61mtCDEGmp0bTfNkDueTLFuQaMsuYl/Szev
 eUCWzDjCs4ne8Rpf4dB0CBVUI6kg/H8nopyaM3G5Fp7otfwpJzCYVGksuwQJDlyXZheb
 e00/ttk8LVi37fhMtMWX6MHkJ2W5e41/U+S/hHguKhjdTFRXJvNMU04kLCTZK1Ashk4C Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq9pmr432-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2Hwnh169952;
        Sat, 28 Aug 2021 02:32:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 3aqa8tnj6n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xhgjjqy4GTMsmqaztxm+O4ujhNE7ngvBkDfR7LIsbgrSq2pzXldRuyVEBy9gLkQ3uQDHhW2r1SlP39s/8HXEigYtSSGmxDpn2J96ro8rILH8coL11acrPzS8kxNW/X/HjE07pZ48ln8ANG7MW/FVSpuuyGbv72MP1B/A5ecu7XyL/mBByE1W35qbzFHcoKMb/VnAQhIgNSE5C55rexVoRvakQJiZIhwXe9JEzHpWFJUuf9qRnDf4vYw49VhziM6kscn0aabrvIfZPKjOESR84qlJuUmhk2+0Ytr2wPYrVE7BZ7S3K3JvZcbGOX/USVrgq3Tgbkxe7H4SMPdYtjZ1Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2tcZPnZG1uHNpxSRa2uqlhDcqRVMDG/1QTu32THWEk=;
 b=HWNjNJeIsCnFfS6Di9mStZ16Gy+Z6n9hdnH1Z9kZXRhAFQKhScr/bJX4uYZiVuCcWJk5mg8mH+noc1Uuye3dZUM5FvSg5Zi2QAdZXo7EbWdtRbSd+YQAuqKNMZouOuZ450K3KEWFyuGX3T5npyPbWOVklVIRt0XxOWQZVpiELEDrNtPpgvInfXQaGiV0iWPvFPS4ORZik7C8IEtIGd+6gKZTTZGkuzJbg/fUKWaKz2525l+n1bzF+xsUVTheeXTXM5FP16vWjD+ortPPqrOa229870CdH60J4aqY0bY3dr3I4HrEKO+1kXDcANwtab6fAGhDy1PEJqrmisajFPXe/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2tcZPnZG1uHNpxSRa2uqlhDcqRVMDG/1QTu32THWEk=;
 b=DTJ5YWSh2fPkJjQyldxPS4LTPRXzr93mmWvmEmGT1txJkcuA3HdWDKtRB4HNRr7o272Efxs6QUtZf7LR1Q/2anmWgwT3RIQx+oHTDgGdqVoGzh7dc9REqLQ6zfitO9pWcfUsZLmh7e6NChnpf23XiVwtG8Prjh9I+LzpHP7C1/c=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/16] lpfc: Update lpfc to revision 14.0.0.1
Date:   Fri, 27 Aug 2021 22:32:04 -0400
Message-Id: <163011776502.12104.12003780530921200225.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c79a977-ed7f-4e1d-4886-08d969cc10cb
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB551514FF4DD0D537AD4C67978EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L94w8sOz4EdV6IeOe3hrrD4HtrnbJAqpvN3C7V7YUzb6eJPkJamRHTft16ACfoLLgLuypyiMQdJUJiNmyFVjxcR9hTUiFJNueij8zMzaOKzOGEri57+sfBLhkJITOZltEJilwVK3E1ve3LLas8Zh1QldUzNvSCpVcCPiQqZQbV0qvPxpmEws+260oBBPZ7ZcOpe3sEhxPWlAs2Y1nAfnH/00DjDCnnQTlSOJTLlmkizhjMhs8+XY55Bl39jf0zXh4Whs3BE+3no76ISwpoeMP/ub1KsRKzi4IjGC0S+WzY8PQv4LmFfwbXKe8H7EG5BTFW647lf2JOh+sYTrDsvqJwgbW0q9E+xvYosaXA/Z/yeT/SB9khKr9cdpcCd27g/ITg4J/DJvhzdZVu0CFZjCIVkHLlwiWKjYCakncAnTLymE0wIZd54PqDeMORJQZpfi4GNxqU9oiyFl7WrkwEU8LxDV+kZjr1kVumnq7/0vmeCpm+3p8RA81aZ2S8X9glKULpuLw1mG3B2s2d+hpGwUphr3/wkwko304LMIcSOVZiUxTikYYRp7RrNLaP5yrOnS+x164i9r7PHklYoJDK+7haiBHw6dJkWYUFvtnp+Wy51Z8DjkEqEwJzNUJm4sJb7S2cZxqHqb12omesWk6/spCSY7Fh8znEPPYJ/umuzYJ/h7jQ5jUHu+fpze5MXHyLNjPAQGi5/Vgr0CgCSQputGu+bAzL9/jNjs+5sK5yG1oJo17W2aZvIwZD5Ah8xVtMKYKBrcAgu1roU3vMk9+pcQRSg+GZmbzn7aAR9s73PYHqaj7i0+VU6kJ2UoQH3KUXHlgG3V4eXfcqNSJtE/Kdt9WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(15650500001)(107886003)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWxCWTdVMUYxbW9qY1RRR3RmZDE3TUFPcllxeGw4bkM4Wk1Sc1JJbEJEV1JJ?=
 =?utf-8?B?b2NkcHpwQjlCWWRYWW5tRWcrR0d2U0t6VXZNdUhlUzViQVZ3dGpYNG1iMUtE?=
 =?utf-8?B?MXpGb0Z0ZktBcVJkT2JHTUdUV2ZzWlJBTUZMcmxnZG5kZEoyTURvZnFKQTdr?=
 =?utf-8?B?UDV0SDE5dWlTVTR4Q1loYnhFVlc2UDRpTk5GYXl4VW1yWXlYenprUHVNVXR0?=
 =?utf-8?B?bU0vTENOYk0xTTJObnRCT1gzYldiSTFvelhnL3RsblZKRHFBa1BWRnRJT2N6?=
 =?utf-8?B?eTJjWFM2b1FFSDAvNGhTbnJGRmVlZVFaUm9SUnpTY3lIdGF1VHp5K2UvS0lh?=
 =?utf-8?B?ZGZEOUxXQWxqWWlHS3M2RU0zZEN2SnBDVHV4cVJ4ZUJJMUZLd25OMVI3dEMw?=
 =?utf-8?B?ci96OFUramdsSUFRc241SmZHNWNLcE1id2RFZGpTQlJBTXA5RUV0clR3eVYv?=
 =?utf-8?B?TCs4azZkOWZiRWFoTzd6b0sxTUZUOFNwcjFVTE5VSzl0ajNPbytHMjN3TVZM?=
 =?utf-8?B?T1RlYUFKK2p0SlVPOHhERlp4THRIdnJEbERtNGtxV3RQdW1yTVp3M0lwckdx?=
 =?utf-8?B?d20xdFU0VEJvWmNZWVR0bXRRVWdlSDJZYmZwZzdQUk1jS1Bwb1FNWFNRdEpp?=
 =?utf-8?B?SWthdnJqRXdrQnJDR21iY3p4T0hyV3VnZDdFbXdwc2pYSmxTTjBmZ01mS0dC?=
 =?utf-8?B?SXdLZWwzRmtXR2dUV0VwQTFoeGd2UkI2UmJpSGpBSWtmLzNkSTlYdkFsZWtu?=
 =?utf-8?B?WEtwM3dONS81MlZaRjRkOE9sZWNrNXBsakZMUTV1NVRlVDg1YklnbnFLK1lr?=
 =?utf-8?B?V0VuT2h2bExZQ1lwYWZiK3g3NGZIQ1NiWFVYVTR6dXE4WjFnQlRyNmc0S0JP?=
 =?utf-8?B?M1pRWU9NVnFVbzJLS3phZ3JmdkpOaDA3VU5MaTNvcTN6S2JEVGdSVnRkOFd5?=
 =?utf-8?B?YVNQNWxERk9rMVZ3cVpIT2ZpNTdWTCtUWUdMampoejFyelhxNUhPRHJlRGRt?=
 =?utf-8?B?ZUF3VktGTzlQZlYxaGI3N2hjSEthQVFjUEJOcXl0YlE1enJQMzY4ajVHSGhi?=
 =?utf-8?B?UWo3US8zTHBPNnAwelRwbjc3ai8wSm8wWE5aaU5HeVo4OFhwTnF6cUxaZVFm?=
 =?utf-8?B?c1d6eDRhV2diL082UHViWUNqaVQvSU55QUpMWDlORU9vYVFCcjN1MTY1Uzgr?=
 =?utf-8?B?RlpHTVNobkNubitJTXZQSG1CeHNhNEdoTDdDRGVRdGZibFNQdVFjck9PNEN0?=
 =?utf-8?B?eVpsL0c1dFc1UUcyaCtuZVRwUzNEaDVMdm0zSU13bW9wWE1YRS85OHZVMUJn?=
 =?utf-8?B?aW9oZlVBU21WNUFqb1Q5M0dQTnJDdEUrK1M1clplRFJEME5XbERkUnFtektY?=
 =?utf-8?B?ZkhleFVtc3FqdUFtWWgvZXNwTnFHTFlZTXRtRWo4YnJUKzBRTGxRL2xCWkxT?=
 =?utf-8?B?dEpONlRvQUtkeUVlZjJqM2Z1aDR1a3hOQSt4SGxhQjFYc2hxdEJTSkhyRk5v?=
 =?utf-8?B?dkhudVJsWEcvSFlnNGhISHRnR2c5STJNVkpSNkVXbEl3ZEtyRDVXajVpMmJF?=
 =?utf-8?B?N1IzdzJ5cWtmN09XSXNKNVpycTN1S3JsL2pKWktReS9DbDR4T202NUp3NTdn?=
 =?utf-8?B?dXRCQi9DZ1hFNWFqbVd6S3l1TDFLbWo2aFYxZDFjWG1OaVBRQ1VkbGdBaXZs?=
 =?utf-8?B?SU5kdk16RVVEU0wzR3RVaVNaOHRDTWJJS1BOZm9HRmI2eHYzTGltbVVib1ha?=
 =?utf-8?Q?i3g+UnoOBKGuKtq/ReFLZL2jOtX1+ta2Bczysuq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c79a977-ed7f-4e1d-4886-08d969cc10cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:22.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9HUGT5s8E9q+ov2quQ1ZwTCS57hEaqfWz0NP/Zxp2thGzyGg1Q0rl7XfaoSPhNjhFsrCvnQ1DPqXq3EiSnyWvfU2I3uhEak8zJ72iDQFbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: KqbgqnDEDKPspDftfTow_UUuIv49cIli
X-Proofpoint-ORIG-GUID: KqbgqnDEDKPspDftfTow_UUuIv49cIli
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2021 09:28:45 -0700, James Smart wrote:

> Update lpfc to revision 14.0.0.1
> 
> This patch set adds support the Congestion Management Framework (CMF)
> which a component of Emulex San Manager (ESM). ESM is an inband
> monitoring and management solution.  CMF performs congestion monitoring
> and adaptive management with roles split between the adapter and the
> driver.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[01/16] fc: Add EDC ELS definition
        https://git.kernel.org/mkp/scsi/c/54404d357284
[02/16] lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
        https://git.kernel.org/mkp/scsi/c/3b0009c8be75
[03/16] lpfc: Add MIB feature enablement support
        https://git.kernel.org/mkp/scsi/c/c6a5c747a3f9
[04/16] lpfc: Expand FPIN and RDF receive logging
        https://git.kernel.org/mkp/scsi/c/428569e66fa7
[05/16] lpfc: Add EDC ELS support
        https://git.kernel.org/mkp/scsi/c/9064aeb2df8e
[06/16] lpfc: Add cm statistics buffer support
        https://git.kernel.org/mkp/scsi/c/8c42a65c3917
[07/16] lpfc: Add support for cm enablement buffer
        https://git.kernel.org/mkp/scsi/c/72df8a452883
[08/16] lpfc: add cmfsync WQE support
        https://git.kernel.org/mkp/scsi/c/daebf93fc3a5
[09/16] lpfc: Add support for the CM framework
        https://git.kernel.org/mkp/scsi/c/02243836ad6f
[10/16] lpfc: Add rx monitoring statistics
        https://git.kernel.org/mkp/scsi/c/17b27ac59224
[11/16] lpfc: Add support for maintaining the cm statistics buffer
        https://git.kernel.org/mkp/scsi/c/7481811c3ac3
[12/16] lpfc: Add debugfs support for cm framework buffers
        https://git.kernel.org/mkp/scsi/c/9f77870870d8
[13/16] lpfc: Add cmf_info sysfs entry
        https://git.kernel.org/mkp/scsi/c/74a7baa2a3ee
[14/16] lpfc: Add bsg support for retrieving adapter cmf data
        https://git.kernel.org/mkp/scsi/c/acbaa8c8ed17
[15/16] lpfc: Update lpfc version to 14.0.0.1
        https://git.kernel.org/mkp/scsi/c/2dbf7cde53be
[16/16] lpfc: Copyright updates for 14.0.0.1 patches
        https://git.kernel.org/mkp/scsi/c/9eb636b639b4

-- 
Martin K. Petersen	Oracle Linux Engineering
