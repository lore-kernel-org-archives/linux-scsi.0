Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCF0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 03:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbiC3D5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 23:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbiC3D5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 23:57:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48736622D
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 20:55:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22U3L5p5013073;
        Wed, 30 Mar 2022 03:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zelGQ41hnbGidNAD6BcgQpxL91BQbgEY53WJrF6H1HY=;
 b=UkaYGv1TR2IBGTzyPqWy4vt9sqRC73iKEv8+4JbotRn0r5Ed2B6gZ4cKsEBKSVJbeL/5
 4pG1G6z2epTZNF+eK4ZZsch6q3h6HggVYv00rJXMIJkcxZOW67NXvNEBqx8yHD/2Z7Z9
 nVZUWMo4C0xFgGh3xJ7fx2TT9DIrvbp29P8q8ui9rDs0WjKUfeJ726qRjfv0hO53hVWh
 2M9nD7K9Xne/exuZvNk+vdOXA4MU50adPIVifJzb+Bh4a/EEyDHFJRVxdaua//6WGRCz
 1l0xAfuncDnQUDtrAd/Ql4gzHpB4XEZaYJ+XCFuL0pf0TgDOzc9ELe7vqD1Uu1SoNrUn Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb866y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:54:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22U3pNNu143398;
        Wed, 30 Mar 2022 03:54:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 3f1tmyndmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:54:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPDqS/bkP0zJFtq7JfRWKkdC3HUpA+9kX0Hpo2y1Fcpaul+x9Tolo9Oj8w4tWxyue12OR2IJ+m+lyISJwB9MrQn2L2EuNwZNEXJO9uvgyMV2xBDZXQM3V9qab25oZbGyXpUO8dKRZ5CJ5gp7JMj1eMGawjQdHxzaeI+z3WY6nonWN70EyIPvlJX33NuXyEa3T/G7unAuqBzQuIv73yVFcMimeBHbXMSr1E53Nz/qhb93kgpO1E6mvxuVEYKo8bPizp/dSlltholCNLhfc0iGEs7/swvxNy/OJjDZtTMkVPJdluLV2/IeNVRo1k0VQZj02+tbCE8mgoCYpoE6prAOFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zelGQ41hnbGidNAD6BcgQpxL91BQbgEY53WJrF6H1HY=;
 b=VocQU50Czrw5jXzrRsvszJ2XbSuguMPuvVRc+fBTH7ab6Thq6dw+FcPs3z33QeBHmOxDlIV54xVnNSdljTuGW+p1LMGRPkvutvL3tN9Hi600sQbIlm/82182QE7ri9qSL3rKu8PvBX1oRXMJfW+GMNI36GSVO2sxV2peCsi1BOd+jCxcQiXeiqHd+aLo2slDLE8Qm8JegcZMPcKLxAzt93ZU/G9oNOFuVURvAKT+UWclG9NVSvPq55cyXJjtlXXMTXi9S/aSy/bRA/XDx0TKFaBiOwP/U5DWb5Y6ta3VLCMy/AgSENtGhsI56R7tKSVBlDziIM6fidnRRUg5kGc37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zelGQ41hnbGidNAD6BcgQpxL91BQbgEY53WJrF6H1HY=;
 b=qKk/+HWI5P2/qQb2pNyUHBv3Pd9CjtFwUsRhYijmgk0izbbcmNwSk++mstgSLCvoSw/OtTEmaoJX54tQeQ5B+++Ggv3Wln30N3Mtog0lBVnoFsDvEKSr3tlgVWZyvKBp2al+v4pofCdqHUv4rv6n1rdi78Sjju8PFU4qYOkzcQY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB5505.namprd10.prod.outlook.com (2603:10b6:303:160::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 03:54:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 03:54:53 +0000
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     martin.petersen@oracle.com, hch@lst.de, linux@roeck-us.net,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: sysfs: remove comments that conflict with
 the actual logic
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mth8t7r2.fsf@ca-mkp.ca.oracle.com>
References: <20220329021251.123805-1-liu.yun@linux.dev>
Date:   Tue, 29 Mar 2022 23:54:52 -0400
In-Reply-To: <20220329021251.123805-1-liu.yun@linux.dev> (Jackie Liu's message
        of "Tue, 29 Mar 2022 10:12:51 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0129.namprd11.prod.outlook.com
 (2603:10b6:806:131::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e04bdf76-5fcb-4576-4ef1-08da12010c46
X-MS-TrafficTypeDiagnostic: CO1PR10MB5505:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB55053FAE6AE2ADC053A61D148E1F9@CO1PR10MB5505.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRd67tFdvskfztZb+EaXv1hNUb6+VNyPXw4zuIQ91Y5wWXE16hZWhzVzvGBURH+pXpgWz8PxbKsbtwAUaFLGarRLtOlSr+LHaG1s9+yvHiSQNpU2PlB4j4ofdWnys6GOviF9JmbIYfDG83KP+vlwiJJCKAOnQaM5CaaiS0lKBLLtn4H8vQw+5SInGaVy3aQrD3sd0vbDycNb4WRW4mxcxxj2wJjjrdrXBsMssc6UFIK7Wc7rkhsihoddfMlok3qwaASVKeA9VGu2AdO0vTWPpsdgwiHL6MQK6b+cRcq2slyymkwlHXM44+XywDsf+klSjmOZI+wiu1vHIIIQFAuVvoUtvqXqjNBrajLT2k+CIZujs3yDgsHTedW3afzNVnYygXYRJFu15mvPhuBx+mC2JFuIXf9WhDeEsWbXOjMFDXKqMwOW09+a34DQdoCuRxxxlhvGBy9Gao4W+anOn3PWn2g8jxjdYuGv1NpUH7cu87I69Gz0vTwrLfI7JzuydCeh7Fh9BOAZpm9XlfuHNWLlohwK+Y2Gv0drV6NwQ+zCREkpyWNrHiEcpkDTEqC32zXlTsRnpVR5abGCrSWRoBFO/wH4XoD+pVJwu6Af+kt3p/RF63rbRbsevYdwygOxVAqwYhbhCvBEQ+9S5Z5unb1oIUxfa9uxU75Fkd7Q9EfCMWRXYEDQaTdEqXzVIfjGWZqo3zrxoJJ0jge/XPOG16GRSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2906002)(558084003)(8936002)(6512007)(6506007)(86362001)(6486002)(508600001)(52116002)(5660300002)(36916002)(38350700002)(38100700002)(4326008)(8676002)(6916009)(66476007)(316002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fJy2rEhjPP782MT+YWCDPyfc5PPRbV8wbo1HLJcCSy3o+8CJXhwmw2sL0eI0?=
 =?us-ascii?Q?OGZzvet8zZjOexLNhEfVTSwxW4kt183c46vzmG6Mxwdup+9nt8MNGwE+JA2r?=
 =?us-ascii?Q?LIWwlxNK9T3oB8hyuMqEzAMbgZpC2TmiX3xpa8BzySVhf29PGSji5U6Rlhw8?=
 =?us-ascii?Q?awY5m6sOK3LyhjXVWhyB2joXq6eqy5l15krfz4AU+suNURHISu08lAOvqijx?=
 =?us-ascii?Q?tnM9vLMK8jNpYw/oW9NjcCTwZVayuGB9ngIbkVN5cFGNDV+Y1oOQUf9p4MWy?=
 =?us-ascii?Q?rzh8jcNLPSGqoa/FO6ZaEQC0CnsB6ZliGNFhWXFRqGwPyWv3M5xnzPOHccPy?=
 =?us-ascii?Q?HgW0m25h4RBz7kTdM7EPFvzDw2AoeHbT6uqaCoU8HPvfiughtOmB+i8QtLeM?=
 =?us-ascii?Q?agK+KR7SW/qdzqH0QWe8YruY7C6FTTY+hEC2Yc+BxvCGPSRnCQVjOu9xa+jv?=
 =?us-ascii?Q?0zeeqHPY3D1n8OVq0Y4QB4TMKJJnlmtlXVEWLh8dyjFMIhUJPAOhAnalwjI0?=
 =?us-ascii?Q?zbcYCdW2jMc6tMz3ejVCd//KaTgXuG3VOQkAEG5hm1eyf/h2j5Ssgrg7fvTP?=
 =?us-ascii?Q?x734P5H+X5PhDgU4gBcxAWwFId+2Gih3nN+p46x6h9AyRnm5yw9Z6q02JkoY?=
 =?us-ascii?Q?joWOT8ihRPqQeGzmLL57Dg1zF9toPC8BA7Mr5h4WHEQQqWJbsadMU9aeD7Dp?=
 =?us-ascii?Q?Z+FOhQ+z9rNCiodztAwbtsJ2koTV0G01ssa8+WuVyT5rwxj8f9KH7q3N/Mr8?=
 =?us-ascii?Q?70VjKwbaEdPpDvOEdRJ82nPW+ObeVP64Pw/NE6HuuxiJmGidYbpJjn5KRWve?=
 =?us-ascii?Q?Ic/iLVFTf1vACJ7Vr4DZI4oHuahIt1iSaAg4yJSUU/BYPp/8rwcrnOxEI7fk?=
 =?us-ascii?Q?+a9/jWIjghBudndvFoCSQCbRphV9u8mLWPjudvcKedNyRrkMYtLw0VfaeYz3?=
 =?us-ascii?Q?vDo6EGwSq+j9tb5RcBJKSnU5BBhMDLtIZY/vm3xaDv9z+b7pyJuv54uNfPTH?=
 =?us-ascii?Q?P2lO3tVaXLO3YO+GHqjjKDlcRrx+oc3u3dODWyvJ/pUWY4J8TajR1UZG9ast?=
 =?us-ascii?Q?yNSzK3D7fpEqMrYbtaC5YLhK5ysLjPa96c3Q9DSaPHrICEBMief3DPFqt3q/?=
 =?us-ascii?Q?+QrbVdfhtwxLa27O3+MLlfW0/T5D+UzmUEL5mf16sNR2RO8gS2U9fYV6Xpho?=
 =?us-ascii?Q?r3IR8XXgKlYeeVhD1jiPh1IUj4aSPShwSBfCkPCpLVR18FW1zB3XP1jeaA4Z?=
 =?us-ascii?Q?2w1JKJH3uQcjVjPe+468jp6YK5yi3BUXyrZ2ZYK+Vqkqc5qGJUhBzOhges/e?=
 =?us-ascii?Q?3F1qiSrpdb/uDmxX6HfG9gWl6bIYf3BlXVaJ9KyMfw3bYRXov4aVrnvj4fOp?=
 =?us-ascii?Q?dswq9jL6w4FScGC3Dk5086i+B8enOuPQgPCo0o7UunOy+1+SIuOq8V6MPhRt?=
 =?us-ascii?Q?Btr4xJzXfFJKcQsDltt460gYkFqZhg55SGKK8V5/zDTTU4wOGAT63Z1Do6go?=
 =?us-ascii?Q?Dv2CuLZ1/IAZxQQYT1IjIo/BYI3oDU2N2d9felqgrvU3VCv3KITafCfqGP/e?=
 =?us-ascii?Q?SKmhC8lrULfPD1Z9zuQhH4O5VFahy6eFvagVIsOqTAyz2N/8dv5le4HuYwNr?=
 =?us-ascii?Q?Ng4lJBKKSlU4g6KOesjGFLLlXzMHjc+A59BsuxwEx7fKNNZt09Qm7C7BxwI5?=
 =?us-ascii?Q?EmF3x/z6YN9KFyNyk3tKAtuERk6b8z6Fv+KAUI/S6TiTB0Da/l/cs9YpGe9g?=
 =?us-ascii?Q?vv8yf6UmGRKzrMsvqUR+nwqv2QmQHoY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04bdf76-5fcb-4576-4ef1-08da12010c46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 03:54:53.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfLGrxclfqTRmWoTQu4VpvIPKmCH/TvUwjoxIL2tH6XwtQMXYx85BFuMxFCRfdsDJizqNJTo84amuzwsdtO2oobLlNfU1gfxC+JFyJKgxb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5505
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300017
X-Proofpoint-GUID: wYpkgD6qB1IEVUQMNyVSs5aUg8qnpYBg
X-Proofpoint-ORIG-GUID: wYpkgD6qB1IEVUQMNyVSs5aUg8qnpYBg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jackie,

> I think we should just handle the error properly and remove the
> comment.  There's no good reason to ignore bsg registration errors.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
