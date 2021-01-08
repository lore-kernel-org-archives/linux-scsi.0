Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88AAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77412236F9
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbhAHEPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:15:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44438 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAHEPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:15:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849FhV041397;
        Fri, 8 Jan 2021 04:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EzMsIRcjJiNE+E+ovN/6GRph8WGK3m9U8PmccvwQX9c=;
 b=B7F/8aSefvkbzdk1Kb1VKuSRomRfElMAPkEZ1LlsHYfhlvJ6k+WQEtRk+ToWaJ0kxVdb
 ZkadQJb7FGWSLVco9STdY7cXGLA+IrKMA1W2xs6zsqYJp39K53uB+MSUIka/fYuA3CH2
 U26gvL8ppFXtd9CUHHmIxJvQ5/sJ1Y712+YZinzEMW4/TF2qanjJIUUnWo68bOYzEE3T
 OVyAflaOyx+pJGdDxDQltXM8PLTWSnJkkfeAz6i/+vSKNhSvQ2WdRrLe6LiMROelWsEa
 xB4E0LJFtPTbxeb1z1qlyxOhfG2xdh9CiHIcj+9VOwK2rz3GPx2br9HKMYR/kfJJKHi+ CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxyry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:13:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084ATOE040403;
        Fri, 8 Jan 2021 04:13:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 35w3qusvfv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:13:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAvWXtS4qgK//qEgxSOCrrviw9MpxQQbGuET0UKQKGEG34vFM1kP/rxvryj0JtdkzoQ61XrNaJsj6GlHJN+jvOqDg62Oquy/SnPG8d+b+JV0zOaBDHgJLAH69irhI8DpH/QyeDmkXHzIXp7w1DZJuq0s0IkS+kUkcQLhYJM/zgnD0paet5GSKIyJZRZtgpPwOk3JQ1t9TqjqbNtxPxhDB8j/Eazw81Dc1v6cOTak3U/LC2JRlxjsrR9H826cfsYTr4DzF6A/dCPbSVpZnX2SdspqTPrd2LquDhpR0+tWMg2AIYwWN6tsvnQA7Nh7O151tAFSUDvA52A8wn1+HxKEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzMsIRcjJiNE+E+ovN/6GRph8WGK3m9U8PmccvwQX9c=;
 b=D1ohAs5c4tasqqPiYua/nKt0T/W0oYXMiLwKI8s1TflXcda0AF5R3/w/1VyZiEoESotCQVKIfeX/a907k35FX+5pi5oDo+R0IVU+ly19pzL023gR4G+7ayTABrNrLPpAuhUhfm0Tt59h7rkDLXV/IYjhoj/buFBSLe6RB6Jy0MwrrQb+PodEc8vI0kmE75SEy3nJyxHsWcClGmcRBPLz+fkVyTWhWqV7lfBAyCw8FfvqBcnSpwWqmQDqOq2bYaHLRYI3h744XqCS8s13hrWxcO2ch9+ut/UAPjeIBfr8aebGz0L7zT1AXo20iF/rOEZlgICKj2HSkr6Zq7N6VxBtrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzMsIRcjJiNE+E+ovN/6GRph8WGK3m9U8PmccvwQX9c=;
 b=CQm8Y7B6i6l9mJzyeuLqHhc/D5g/oFTkD8Cy8nGVqhtvmvFL5VnwWfJ0Jb4eOqhu7byvrviemBjGIKS2DXyAaH4OZzIJW4vm8wlsgNRQTCTt8JMSBXxOIk7pP2kCm0y3XTHqGiX5p2+OGGo+dStz+A7yyKPcVdUGXhSpilZfjKA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 04:13:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 04:13:48 +0000
To:     Martin Wilck <mwilck@suse.com>
Cc:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3 14/25] smartpqi: fix driver synchronization issues
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtxkax8p.fsf@ca-mkp.ca.oracle.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
        <160763254176.26927.18089060465751833560.stgit@brunhilda>
        <76f8c5cbdd1722eecdda017c46c0d617f5086e1d.camel@suse.com>
Date:   Thu, 07 Jan 2021 23:13:44 -0500
In-Reply-To: <76f8c5cbdd1722eecdda017c46c0d617f5086e1d.camel@suse.com> (Martin
        Wilck's message of "Fri, 08 Jan 2021 00:32:16 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0701CA0020.namprd07.prod.outlook.com
 (2603:10b6:803:28::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0020.namprd07.prod.outlook.com (2603:10b6:803:28::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 04:13:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69291685-e64b-4862-8d17-08d8b38bcc79
X-MS-TrafficTypeDiagnostic: PH0PR10MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45345CCDB8C6EE2B165D00C08EAE0@PH0PR10MB4534.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BXPOBhg3g7hSFXH73C9Zaqz1ovcO5CSZETGZzrGG6e7yj0j9GaathNXKIEzOECsnnzlrjuuzmTyFIK/lwigITXo+LVg15QDpTgUUgDJeoK+FZWO64rWRCVnQTqVU3TnFj1uXfzKJw8S6Hza3tBqOZ7zCLj73/hwC25wx3fbTsYwoDUvy/FhlBXPyqROB5NLC52/qOKm/vMqWxxNaCbaNZL61nrOWubeQiI10lQmOyyICKQj8S5rXo+qQNu2jwTuwvQ+4lNiKuftJ8AgQ1EFQYfQQsaqdv+3rDsrS8o364p/DF15rE1bGVR4z/zLJjyhYKhjOc6o0aYUxiarIoRx2cxnCtbgsYqcHlBSPZ1BSxEMCLT3/NrTfvrPDmdpJI0WmKTK86UMhEbiVHmq+30ePTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39850400004)(186003)(4326008)(6666004)(5660300002)(55016002)(2906002)(956004)(66556008)(478600001)(16526019)(6916009)(86362001)(7416002)(26005)(52116002)(36916002)(7696005)(316002)(8676002)(4744005)(66946007)(83380400001)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FBiEGpYDE3lkDtwMdCfkHxBKTKKmTQ+m7tMIwKMMsJWjwn60N1YU0npTbEOL?=
 =?us-ascii?Q?YxaVkXAM9najadbrFkyqP4oawQfrgWaDVcZ8kX5DQ3soRD0DJhldTme1A9XT?=
 =?us-ascii?Q?2unPtxlEMOabjYXMZmkarT3ulU4BlCY9OSm5eFWc7VCpH+YXKZ3XvG8xlt3O?=
 =?us-ascii?Q?RoHm18pZfkEuPQMc7gjNPoUcwWVeOnEr3KAMi5X0kbllXvvWx3XTs6T1N94h?=
 =?us-ascii?Q?ZaYX4hN5y4l8ynhSxeZog8MR5YGLyL/rjIvOMd6mA+80Ah+j9c9PSPPM0xj2?=
 =?us-ascii?Q?Si0Eg8ic/LaGt58yZLi6J5rpONoBWO/fXY/fMU9DhPTLgS2QjhVkK/oG156Z?=
 =?us-ascii?Q?agncaWY7Kmlbtmeauf/H/57GZE7neCDJVGFp5k4ondzOhsuNA0V6eTHIBNmo?=
 =?us-ascii?Q?9WjQUZgyygzPHKeQbegWtj1FcptuegCkTVjvModivVIocggO84AbX5hWZJbt?=
 =?us-ascii?Q?fdCHsiQ0PwAlrjXQeT62uscvNEpjKJnIu8qsbm1hN1f7f97uwoULCchBFlxT?=
 =?us-ascii?Q?3qJZ94XeokCckEscsDswhbMQkemffxSdvMKTAwEPH/Kvi2gfjT5oxqLg4N2Q?=
 =?us-ascii?Q?UZc36DYh2x58O6xWwTRL+RYpFE7gIBhzLsJAxAMdNNsbyI2Jpf3S11i6S+bg?=
 =?us-ascii?Q?N3t2gFSW6c8uMhKtTRmN3AzXTzyL21jcIVgnuCwvFOT1hTDymTmHw2yqKqL3?=
 =?us-ascii?Q?8+LPNV3yeNBpJDZsuDoC0onFx0+uUgtNXgTt9tkC3BdharfmFjnGJCKJZcbc?=
 =?us-ascii?Q?WYqwE37ZrHihEJ13WRri1iV5qxVps2/qhk9BEenDLXqky4RCHjELMUMBIvVP?=
 =?us-ascii?Q?lSYBqm8tL6LVQkCIkwjssHHGfxoD9qfQNsXaxU8qhpZMFpr6BHt2AdAKFpeI?=
 =?us-ascii?Q?p7GanrmIzHkU6d5qsqV6NCFrndIXMmSySyq92pl9nqTtqIncgtN3caJ9KrgE?=
 =?us-ascii?Q?24oCKPlbKerTMDq5s3vuHGDnKGcILRplSOPDNug7Mks=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 04:13:48.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 69291685-e64b-4862-8d17-08d8b38bcc79
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uAl/9RsRmLhgqNmg3p02Lsvqm8wZo2lzZJFTM/yGaMbUdelPqKKh2+K7T01zi7/Wc1Wj6/KJ5XZeLjjxwFLF2e6oxttYnWycPV9HCQpC0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

>> * synchronize: LUN resets, shutdowns, suspend, hibernate,
>>   OFA, and controller offline events.
>> * prevent I/O during the the above conditions.
>
> This description is too terse for a complex patch like this.

That's a recurring problem with pretty much every patch in this
series. Big changes warrant detailed commit descriptions. Bullet lists
are woefully inadequate.

Microchip: Please read the "Describe your changes" in
Documentation/process/submitting-patches.rst. I also suggest you inspect
the commit history for other drivers in the tree to get an idea how
commit messages should be written.

-- 
Martin K. Petersen	Oracle Linux Engineering
