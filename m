Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16C5C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 01:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355738AbiFVBn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiFVBn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 21:43:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46DF2FFED;
        Tue, 21 Jun 2022 18:43:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0Iimu002236;
        Wed, 22 Jun 2022 01:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=m9oC/Cz6ISliuW2waAgYSRxgmjVJOQW5TjrQk5j/tvo=;
 b=xAhaxAmEK1IrZbIzjiJj1GXqgifkHjw/JgUbu08Lr8XqnzW/zYwhVCu/c3KA8OXDnD3C
 w8zphLjhI986Q2xm+Pw4JQs67ghYF72Ie36Vl3liQVfRtLGaTYg9AYDNHhNw8kQsbUbn
 WksGy1Hk3LEzZs7Drah2xxDPlfVA6622xh7io0wGdQRyQB24lZrQIOfdVuf7rZHf401q
 NONELArOez6ODSC7MyqrIAVIaXCDi3kf5SghjPyatF9SKEqRIE3070OX2S6vsf36ogQR
 HeZYMVPNP7nmcVhs9/HwAq3wW63YhOhhKpw3pRCufHnXwM9NvwiiIP15q5aZ6gj8DmqG xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0f5gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:43:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M1aXEe011349;
        Wed, 22 Jun 2022 01:43:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usdqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:43:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hn3ScitfjlZ2PkkPTHbzDtckMiBjjC2jXKXYA9H1EeJsx0/JEKlfPQffeRFHisI9NM35BpoAfJ8p5OuY8bjyj0i37Jo576REucyYSEfGBglbE7TqmT6aS08iFe9R1ok1rbVihgCbEyUikhVKAFh1QXZTyYxiCD9cX55JbHGdYVQUtzry/JmPrm9dnauCIteayXpdTx4k6onrkDKwOvo8jZJ42fr6WGYcMK1punpUoHD68QCvsiRc5rlFxxwNgQpjgyb0c56NW9/+zRj1QwnnrIs4BYYC44nkW6lDWJafij004N3HmvyIvaY+VjZUjC1+7ylLuWqqFInogs+cJGFfaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9oC/Cz6ISliuW2waAgYSRxgmjVJOQW5TjrQk5j/tvo=;
 b=E/T/82AmVNErUdxjRhJlI70OypR8c4MN23NjtZsvUC/mxdZcbqsuwXrsfmaHWcnKW4pacSBLHqjnYzru73xTPWPU80gen5yvAM2q5q0vw9m4KzOZ4z/GhY8xV3/6NU5g/ag3qkqbt1JnPny884ahXZnzuID7gPjy22dC3zHdT5wZBcrRykN8vticM8vwBT838Nn+OuJkSMCZR0jI20Ff9F+7MEVASdfyASiLty+ZDX9hG9DtiYyOwArTDCQINPsItxm9AdYflNDcd34gAahKQTDcckZ22HYJ8zM1aXg6pbyPgNG69J1TMqHQ/NczsU9iX26h6S9p47fQZuSz2LDWsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9oC/Cz6ISliuW2waAgYSRxgmjVJOQW5TjrQk5j/tvo=;
 b=V0XkTNT9a2hIgptuicAdNTqL+WfBkx4BEOxONDUJ3D2OHK0pbS+YUhU1XAha01dRc8+dFxPHmtYfIk4jWyiNof9oPmbWAaEeliMjQBcWyBr8/+l5c/nxo8J5rlgjbYuqRN9rjulVd5JuoJhgIirT5MtwgZOW2teRDeruodmOjmE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4125.namprd10.prod.outlook.com (2603:10b6:208:1df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 22 Jun
 2022 01:43:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 01:43:41 +0000
To:     Changyuan Lyu <changyuanl@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        Rajat Jain <rajatja@google.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>
Subject: Re: [PATCH v2] trace: events: scsi: Print driver_tag and
 scheduler_tag in SCSI trace
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkuljww0.fsf@ca-mkp.ca.oracle.com>
References: <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org>
        <20220621181125.3211399-1-changyuanl@google.com>
Date:   Tue, 21 Jun 2022 21:43:38 -0400
In-Reply-To: <20220621181125.3211399-1-changyuanl@google.com> (Changyuan Lyu's
        message of "Tue, 21 Jun 2022 18:11:25 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb9cdc62-ffdc-48b5-68d6-08da53f0a2b7
X-MS-TrafficTypeDiagnostic: MN2PR10MB4125:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4125C93882C4FC67CA7C8BCD8EB29@MN2PR10MB4125.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sRY95d2jC0wApFmmij9TiZCISMyFQq3GiXf23lgvP17vVfpl8YQYaT6OFCCANLrNYLCgPVPAJFFf7sXo9pgn6gujL/2Vk1gpvwFf7nG6ddz/T6vMYWTsgDRY/PFmZ/jpxQvF7HmbumZ//abnbJ5FvNWmYO+pCnNLWa+zuNVCEteU7zapskQNwOnEv2h/9nD+SyK05LAwg7B1Elw9mjYBl7526i9Jk00xUZbqarADBPLcfrCiaPlmuOzPa+0o1hUa+6G9dgI5pzPbGRM3KUiIZa5UeJS4ptnmoQ1pNi529HIxmX48BFaHYNfVU2DYv1fkvh/WuY3UP4LCJcxi5F2tFsMqFusz1IAWAkOFNhTMx9O/XC2/8klyRLOzinVNSOUiU2wpysUXVimRMoa0gdtXWKdr1SMZk6hWpe1tGUqNKs+UWfn6Srwtgxm1IGVKgWdvf3RML6coHxdYLR1AGU+FxaOV3d2pPdZfB5fZioirXfw/HTcdZnNyvtGKVhHnOm7ymZOp6C9RGkcW/58AUVU4aM0kocXaLAcwuajbPH/XYeIOuqO+4vukdZjXBG+3hHF3yafwuTQlyHh7oIuOm0GxRCv30B7R5MNGBVoAstThbS07P/EtAMyeYwFXYbY+nB4Q4PsZXL/VFE6tciPpngbPUpjtX2menNfAxbctKl7RikmQtuG6t2qutp/aMSN8/q2Yio25gjNRutHSskkT6WjTOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(39860400002)(136003)(366004)(4326008)(6486002)(478600001)(66946007)(316002)(66476007)(6916009)(54906003)(66556008)(186003)(86362001)(8676002)(26005)(52116002)(36916002)(38100700002)(41300700001)(2906002)(6506007)(5660300002)(8936002)(38350700002)(6666004)(4744005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bfrR7nmB84TLGiNOh2rclNu3pUriMZHhGi7Iklcqsdk+RGTYANDDDMxDFUvB?=
 =?us-ascii?Q?iHzp39nRoIP0eQZrq5mXFVaf2/ix1oyhu7CXgw19G9m39ne/JXGJLE/NiXgD?=
 =?us-ascii?Q?nz1roH2bv/GnvqhhoOUUzt8UWZgReQDc2TyY4RJ1UAV5lTpVyrI/L7CSkmmX?=
 =?us-ascii?Q?cCs4ogNoCxJJ9Wl9BSlZLxiLVFcmghMT8DAXlbhJceY1j48zazptnM1jPzVC?=
 =?us-ascii?Q?4a/KP2NxttvmWvznG4ca5uNohCVdI6CZ9OEp9BYrqommvUflfk6wbI4pIWkJ?=
 =?us-ascii?Q?SbYTlrSZ81b0Iby2gDcCbMMqlvix56xpZW6Xr4LfRFNMqKEYbvaRsB9iu8k7?=
 =?us-ascii?Q?bBjVO0U89Ltk5P/lSE5rq1f4fK/lyNOenOmc0jX2hsPP5ATPytfT8JKnSFZ/?=
 =?us-ascii?Q?BV0rPZ2SsZklfhUQrHxPrzw+rkNWeCdeo+DsV8gRLVCIKPhf4Id/CN5LjKC2?=
 =?us-ascii?Q?80LcO2Wm0OXT5rNKLfTBa14sgMPSuFzoYLml+6BUHySjFAuR7vTu8A4qnjnD?=
 =?us-ascii?Q?JpvI55glhpVt45neVw7OeLDm2Hy9bb7fpOh6X703Ve89VlL3tADr7Qp+oj93?=
 =?us-ascii?Q?jGxaS+J2If4AVHO0lR0n/yIbwStea28nlKkb4RrE3NGsu+b9h6x2nwek39uJ?=
 =?us-ascii?Q?MNoh7yQwnFDyyDP4b0qttXdEr5IKR/nRfr3bUkXAntalXC/jsDeC3iwL1yxJ?=
 =?us-ascii?Q?Jx41Ujq+m6r7Oi2otO2CeTcQ2FjLev9y7EG93rN2OZiQzDUo6tMmEITNZuxE?=
 =?us-ascii?Q?12veXHqrrWQo2wTtn0bsZhT4HKZsvgkb0oLJruCPu8C4ltGzQ1b5bRrXqhWX?=
 =?us-ascii?Q?U3HNVjzLIVLiBVeQaG54Qa+pJCcceuo9Agc96Elot1tEZP3XHaJKKlaQQadp?=
 =?us-ascii?Q?Anyf/ZueY5kqAUzIICqvvVPySTZ/Z2uQNMaUivzm7QLBBTBtMG/vSNlfiGbr?=
 =?us-ascii?Q?c3xDI79IEqpf7avPgSZtece6E6sFCNzPrSRlsPmcjOu/REEUKBMvu91bty92?=
 =?us-ascii?Q?f6+JO4fhu5zMXnk4OuSoSMPONau4+ODhynvvaAilhtOSovGNwh4dbknqOmQ1?=
 =?us-ascii?Q?tfzdfKhRr6W+9q07yfZ7yGcFyyHiljUT+gBFwLOLBfxFOZ00/myKt7dZ1S3a?=
 =?us-ascii?Q?jjihXSqWjLXmfSfDWultdmB6lOnBY5LtRV+Cmjg0HgUEeBMdzMsN0RXc4kqH?=
 =?us-ascii?Q?iOK4UaOcs7RtDRW34CLmza/iOrBZk7Pwp18GZJEFkts8W4NdcoaPCU68wO6n?=
 =?us-ascii?Q?pU7RjEoLQGYQn1tChdEvtcx0efj89JmM4PrjQB5RC3f855v1ouMt0pJyU6lZ?=
 =?us-ascii?Q?at+WaS9H3z6ChsjBSVqjYpBczW0E4WHK9dL5KIBL3okPCwnzjx74zxC8Qf+O?=
 =?us-ascii?Q?di1yEcgo3STGoLqPKqa+MuqbjcKQV3jop6C0pXBNlVZwaEyeP139KfWx6s4k?=
 =?us-ascii?Q?3e/wRabUBXpdpyx18HF+Y57PBHHIvZEPvA4MkuVgFe9usTvr4Bj4n/2ljPxH?=
 =?us-ascii?Q?yHsiK6ieb80nSDJGj781740dNw9znHhd1vVG9Xh25eMu/7W28PwyyudCGw//?=
 =?us-ascii?Q?87MgfVd6//K6YOrjd0iRw8my99Jn3ypwvpXIRc5KX03BXX7l4cK1c1Z8bUgP?=
 =?us-ascii?Q?V8Rmk+d8xdCWjlYAF051uwNTaqAwkfunDUmSSULWoVtavRf+5UHuUTgpGrGj?=
 =?us-ascii?Q?O5t3b00I7mCflc6lkGHuUAppdC7uCFzfyejsrW7XVM8dPMDjixHM9tP0Zgwd?=
 =?us-ascii?Q?f816HvdfJrz+BkGPz3RkKf4QbgHilMg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9cdc62-ffdc-48b5-68d6-08da53f0a2b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 01:43:41.5094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WQWv1U+0BHhXp/lZf+Zt6Vh7YlEK7MIn2ptJ2zBwd81AjYVfgqQ0UkFj2GV8MFonmZOSDndWqpyIwzbKTHJ4ok43lHUyoa+zIFhitBtLwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4125
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_11:2022-06-21,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220006
X-Proofpoint-ORIG-GUID: 7qIsNb-n-kQZ24Fsxm16Y8ugF2AqMwbV
X-Proofpoint-GUID: 7qIsNb-n-kQZ24Fsxm16Y8ugF2AqMwbV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Changyuan,

> Trace events like scsi_dispatch_cmd_start and scsi_dispatch_cmd_done
> are useful for tracking a command throughout its lifetime. But for
> some ATA passthrough commands, the information printed in current logs
> is not enough to identify and match them. For example, if two threads
> send SMART cmd to the same disk at the same time, their trace logs may
> look the same, which makes it hard to match scsi_dispatch_cmd_done and
> scsi_dispatch_cmd_start. Printing tags can help us solve the problem.
> Further, if a command failed for some reason and then is retried, its
> driver_tag will change. So scheduler_tag is also included such that we
> can track the retries of a command.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
