Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091C6C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF04A61058
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244866AbhJQCrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:47:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46558 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231351AbhJQCrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:47:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNRbAa014069;
        Sun, 17 Oct 2021 02:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=m1IK0Mfa1otj2KAIXkI5YEwTZ3usl+ZBCOde7LNheGA=;
 b=D/ejQKSP3VQluIsJnpUY9BCn2+wGeFWqjyGTeQ9dAGLJr+Gh4iZef+pi1MtDOn4RYEGY
 LL5/gGkvy94nbmTrNtRpAHuJUUNFPZrqXETotLzBSroaYJp4yR2RhjOBJY5d8dz8eblr
 DVtjVSEhE2XWfdf6IF4UzfBI8A41zEeRVe2s5gLGXfcINsNz3wBtCAlBY3iQGuHRm6bo
 +pKBhPxN9CLUadlXmlI+64YaDgfh0g059flw9336Aldyc5apPGRcKNneeq6a67s6sItW
 EuyAToDEhnx1WGFexeVAurEcRoBktl2+8Ridcldev/xZ+qYggEkh1WULisP1QEX8MpIJ 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqmasrdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:44:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2ZL7I042046;
        Sun, 17 Oct 2021 02:44:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 3bqkutrvvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGnZXH7LMggKBh9Z9TVeQ4I45gdyCodiAJcLGyIU+WS8WKEzauDsAgOKuOJ+nFXkaF5DxGj3rvHg187kPSBpsFdhdKUBLGEKcbFc6oV8Ie/xViIZkMHD4qB4wXK0yrVnDC30GnEx0fhRDxjPc0h+ZHhGq6ssMIAMdPAGYzFUL6G7qWh8FXv69Wr4/KOAd0Rnno+8YyvoHjizkXnpXQaMdHzAjvdnDXOXSRn1Oh297vQpdwHAt814Bk7odiZ2SBjaOcSqylJKwU3Vx1Iwm7+EwcoVNZhzJNTTIJ4iVjaLJ+3TgzQCYTdTTGSvmrstrrALK/bw8KW5zTxcIv2tpg5bUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1IK0Mfa1otj2KAIXkI5YEwTZ3usl+ZBCOde7LNheGA=;
 b=I+vEWtP/xBRSp557f0LsKu76hL508ipoiRLX0J3rd9MX5fyFvU4FXiwUt0K7sCzESGtz1ZHNHia5AyXf/38TXE2HAv1BobWoNbtSuJdUQiYw9Lxm3Aj8Pa6zNZg+V+EAAhG3BqK1xG+izU557eYx9LZVG4q9pH6+bA5kpiaZXJF2Woo3/MrmNoviU5p6coNznzUYASGdf0XT94jIzO6hqxWFbAMzeSUzXmHNcGXT8zX4i0FQq3/d2BPMIW+QpR0Pvnrw7JIfuLYhD0OMDd7dnDVTiX43WJfD/hJPmuDEp0nv7e3dZBuEEE3kjs+A51N7sv9+2ncihXjndShEia79Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1IK0Mfa1otj2KAIXkI5YEwTZ3usl+ZBCOde7LNheGA=;
 b=dz4cBlGT47qnNO9x08k2e7srRKSrjfT39Qs+1EvnM0NTaBrYN9FRwXHpqrvxF5jI0U1y04wLMWTqZdqacrbc/Kp0COWBeZaUrUiYsF00cLXhGxrLfVL7ZqLSXAIQRD7yzahtiVPDBfVZ/Gs8hBQ1aRHCTqUzmqg5hS+w3XCGrLs=
Authentication-Results: chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:44:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:44:55 +0000
To:     Varun Prakash <varun@chelsio.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: cxgbit: increase max DataSegmentLength
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfx0fjz3.fsf@ca-mkp.ca.oracle.com>
References: <1634135087-4996-1-git-send-email-varun@chelsio.com>
Date:   Sat, 16 Oct 2021 22:44:53 -0400
In-Reply-To: <1634135087-4996-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 13 Oct 2021 19:54:47 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0200.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA0PR11CA0200.namprd11.prod.outlook.com (2603:10b6:806:1bc::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Sun, 17 Oct 2021 02:44:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee550c91-9df9-4712-f383-08d991181a66
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55308C359CF76B7FA47D7D1C8EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9w5G5nEj6orCbzZ4+A1lK+dLWmbElb2TdSivFU2Y2RjSH/OnxZ9ZhquRa6dSb6hiXe+EM0movQxxsJPBhBzI2cMeLRjMCjgQRr5y4xAqnCIsNaFJQQtrraC8XgqP1YwhN3ID6nDRihcODgJ8uu+FC11eWQjbj8a2NMt8Q8UQLany4RjXKZ/rHDubsiGchdzkMXc//b+BeQFcCOV2jS6P+xTlQX5msWM+F9EqePH2r55Gr6DCA1K+63uEuD4Cll9mL8LVjS2IAy9MgN0x/KtfmFCyWYAJdc8r0W3tBu7SrCoJuRefBsOwkKTf0T7wUq8m3qsUOSb0gir2SYzHTa6yL6pMitRKYmer4rKoMYr0Y42ktfKCP5UfFFnDqmxah0ecZ7Ce1JmMr4HYJATx0sKQfncSeHuGpWZ8g73ZudKBqxM5woewPFfglDSs8VnPNsMYwRPmFi6LQQDXO/jD2ZwlHhp/DpZE00bH66QOFRQNSQj/HaI6//ItfyiX51MkIOGOUpk+l0qJBukkxgWM9o0RnbIsX7Ph71RqcXzLKgqUKIW75Kt0LQsY3uILs1Xd9AW0webxNa52wKvDQ25VxNqe4x0sp19bX3vujMtsRZSZ3PoCJYIu4/RTY9VWBYoDovRtVNmggWc332+sS3npoyNcVEz07GzJgw7ItkkCEtFrcyYZgaOHFSbOffD7Wog5hEeFXcjkGH2OifxCWms2OKskvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(558084003)(2906002)(8936002)(186003)(55016002)(508600001)(8676002)(38100700002)(66946007)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2oxLg46USjzybHYSJxYUO6cnZRd/jGFKoXVMLJws626D8G6Ekva5jPMgicZe?=
 =?us-ascii?Q?3fRELB2f2A5MP725NmKjCrnnhCQrrSecus4GAtL4k5mGlsRswozk9T156Tvs?=
 =?us-ascii?Q?aehklBEHx+WsAfmWT2oDWZgPwUXkbMv9HKd/3VLRHNazyGSobt2mu0wsPpp9?=
 =?us-ascii?Q?nGx46dTuJojTYXvynvguizfD0vB1epouPhhDS2bXM5J/JVjW2/Huce6x9QR/?=
 =?us-ascii?Q?m/p9XySMD00FU2s9fAI31xLci6tCaX+yPZ+hgWkXZtTMkasz3jfczglWtYqm?=
 =?us-ascii?Q?5APXOdPHx6WOCshoJWNSlyhGzB+WyxGjZNRiFANabip/2kvlbFPA+7N9ltVj?=
 =?us-ascii?Q?I+bNo0lhnTsZEdROqzJ4ogZWnoqvbHAPkC3SCijwROQpZAuXCPNlIjOoEseC?=
 =?us-ascii?Q?yzIGEWLYLiO+wxFtqEQLtcuqsWVtGg8YE2uNKIEqhNofJ5KTuBMjJbdQk7m7?=
 =?us-ascii?Q?NNMy/d9lfJARzTIVEADW7qNN9Jb9b/ke+dVc0vLlM9DfIQEd3wPNscK8LaeN?=
 =?us-ascii?Q?cxjtrVhctPHI1dkoem9FlyWIPJGJdUmjHU6FuzyrIrgrqH70y1N5L0G/bSGb?=
 =?us-ascii?Q?tu0/OGyxArouNxTz9HPQ/s9VRy0AKmjGMgRLkURmeKTJOazAhOYt0mHSfO9X?=
 =?us-ascii?Q?mBTz2y48G4KE9YRFJWQRIMhRMaxW2soWoQ5eNrWa+4Z/peu2mptigk78bQ84?=
 =?us-ascii?Q?oyraZUKrWsCSFRjda0GfmiAOv4esjwpG6qKcr6Tt/N+k+rMFmd7ehaIVSPk1?=
 =?us-ascii?Q?rc7FJWX1kWmDmzNMp6hlZ5+SNT7q1R+3qbXwRb1zxNJQnCdnc+O1+ZRdEGWT?=
 =?us-ascii?Q?Vg7R73eRhiK9lbvCcDSVW26RASq640Q7iuYhnpJy7Edhr7rL1rwv3Vr26cb/?=
 =?us-ascii?Q?cPCOcVaODcyarlqbI1GBQ8qnXeDkZfHbhfkYuGo4DXX5XR6jfs7kVCUvBQf/?=
 =?us-ascii?Q?ty/r+JAGtz2yudLVXijiozFvvmupijMNkhHvv9/SL3umA2mOoKa5e0ONl0G+?=
 =?us-ascii?Q?9M7VEtMCg1RctmpsZ9sFfSaiLMsZbUIp0M7nWgvI6j0HYSpNSPzYK66G0aYy?=
 =?us-ascii?Q?qae5W9Opk0kKF9C3CnbUa+nDVeleilmyMOITRYsr5y6WdTYJMXTOOWohK/O5?=
 =?us-ascii?Q?WkIHLBOlWXVO17aCuUGsTpXRJTNADowNIdVidrO+63Y5WiGim0vvXX6AXt8R?=
 =?us-ascii?Q?KTnUh2x1JknkU3KtvwzaPy/XLBAvRqzZ+MW19QDqILesfuPRJE7tFt1o0vPH?=
 =?us-ascii?Q?fRLVI4bu33yfhksXmtOQ7yIjTsv5YHa6haYIXAsECI0+eioFg/XUDWcAkspL?=
 =?us-ascii?Q?+UQK/ucBupS+fLA7VOcPL6Vv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee550c91-9df9-4712-f383-08d991181a66
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:44:55.8749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: biVdisRaWHcdfLkyKUmpGbVTXnnnKMSrh63WDqPH32n+Ps1cRXyQhhwyFVQvwQzrLtfGNK66lBkYokalJ1blNC81Qo/SrRsIGAPTtTVtY3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=831 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170017
X-Proofpoint-ORIG-GUID: YKZZuK0gTDpAzatyBtU2b0GEzxFdJeAx
X-Proofpoint-GUID: YKZZuK0gTDpAzatyBtU2b0GEzxFdJeAx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Varun,

> Current value of max DataSegmentLength is 8K, T5/T6 adapters supports
> max DataSegmentLength upto 16K, so increase max DataSegmentLength.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
