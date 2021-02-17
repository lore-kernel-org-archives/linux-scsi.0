Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BB7C4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F6C64E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhBQU3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:29:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhBQU3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKNeVC190136;
        Wed, 17 Feb 2021 20:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VF/K5VV7D+oSohgOPx/DNJKAjXDTO6lWW0tbfb/SbLg=;
 b=j3alUNvYcrLdSDqPFllQIx8WZSXOWH/A8ekfXZj9Z4Es+sAUi102d7xLZ8ezF0BYb+co
 B2eTexjf2oUI9MyRQRkg80PYAK7/Q54ehEUeahpCXKf/y0CJda+xzbe/f6KpHBayaagZ
 YxgjEyfztNGJC9XDusnPu0LZRx4BSU+XzwOHaHr0tvF0g53It9G3XTdezJQBSqCXFO+Z
 Hst7gF+CHbgUpnJ4TJ925ycSftYPsIImOoQ83A44q/kxJugnzgcfPSd8/gvFYV4pRUOA
 9SR8U0e2C3sz9cpg82X8qaSN07uRM10yUTY1EwMXy3tIZasOOkELPgjD/U80/jncM4Xu yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ab8ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQ6cD111882;
        Wed, 17 Feb 2021 20:28:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 36prpykf1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7bCNbyl6i9b2KGyfiJYSSOCyETUQW6gMPT5g3hes1iLqAGc8kI5k3TwDT0+x0MMHdev7D4b/8/OcIvmPn03xpJzouo7NWW6gAcZhCz9v5Sq4pY0n7WZ/u/TSljmxeqPpKYgERUITYrjGGa/5aQ2zaWp4i85GFIZn+293SGQmViiZV2cLUl7uLZrM63DdUvdWTtLFsnnvtCIYcDZB+Vu7ZTQaGSrlkioGoiQFFyBFiqlWSWh53p7dyJNMSon0kMOdP0UtUIv9FH26UtH0aUQg5HMCH2kO1TAVwh7o476TZyvdbpEmxwUKaV3hoiS0W/SGTxrQ8CnOCKAHd5ecZz7mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VF/K5VV7D+oSohgOPx/DNJKAjXDTO6lWW0tbfb/SbLg=;
 b=IOHN95MY9GhQm8trgfBcybL9USHR4uQ8c1wjz2coNzV+esMuRLpG4Vu2b0dBGnH/7aMgEMCEUh0AE8wrQxY03fpXQh4KUpAXphIA7F/pRS8IohcOKyzQ9VZ99K5S7Tu4IjLggoZH2FKN6zuF9FZuXaOQCSr3LRuo0FAW5E6SlXeZa0iMc5AGo/Ep8mpSrkby74/9FoqDaNO/vdWjamA7oSmg7K3HIj9nL5R/UM4icq5d66BfVETwr011CrdpEWEJ2UpZu4mMBou5xmkFEumiyz7Ty6PpWj1UfdD3N77BrMA40pzDF7jv00N2BfnNEcVSqtRY5kxPLSqi2pSHN81/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VF/K5VV7D+oSohgOPx/DNJKAjXDTO6lWW0tbfb/SbLg=;
 b=vtjIQMbdgB25tyzKjTj4BNfkAdB61xuhLpG4cpFGzQCkypk9Akmu5rmcQo/YUX6mcSQOqU6BipiBQmzvfty95D1Uyz0EpIUQciUgXk8w1MHEmIA1rvNr9dIe/Nf8XYflJRysxVNHqT7OOKAvd6i5Vb9Njr/Gkb8WALRws+IglZM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2677.namprd10.prod.outlook.com (2603:10b6:a02:b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 00/25 V5] target: fix cmd plugging and submission
Date:   Wed, 17 Feb 2021 14:27:46 -0600
Message-Id: <20210217202811.5575-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc6206fa-25b2-44a5-f7de-08d8d3829192
X-MS-TrafficTypeDiagnostic: BYAPR10MB2677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB26772EAEA384DE309B2E353DF1869@BYAPR10MB2677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6kz0B/cFcXFVKLvzjsqRUz3YibDLpWHxZb1mwVZmXDo0p8982sJCSssLdVCLKxlS3rcEphM3abmG5VnOxaIRLgqyNPm6rGj1ArUfpBa6Fyz7KjfziQVc8wC9pL24v3qWmD219YvAuIpF401wlN53ebW9XawLgw3Tz6PlGz+WosGNaWNHSViYcIyuDCWWsnaDwggkhj1bIPD831XbUGfsDaRxngp7NuXg9EX8t4Z1X+hei7USCfsHIESvW9ULXIf0Kir6MR/MQLc5yNH1iP9krO18TqOReWI00y2/kf4Spy5tKqtaWSNV5JZAczyXi/uI7z2gRt4783AJKFV01bttlrTfWv7nurIh07v6KMGBQqsvd7sJ692i+uNawz/RWM6jXOM3nZkajLD/qKtZdO64Sc7XPep3zJ+3ITj+TzXQb1QUaiemMskwClM9OWIc9lYa0rHgZJVJyfMMks3rUaEt8h6cDVshA5kn23PBFx6LNJp8VX8RP5XYpGNz9GsSltwQXMi34rruJj7sbjr6BSaepCHyLF7CqN59md/AIWsu6sA8J943bCmyGEANcATEFTbtj4i2qWXXOb63zYlMcapwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(376002)(396003)(2616005)(8936002)(956004)(6486002)(6506007)(6666004)(26005)(316002)(86362001)(8676002)(16526019)(478600001)(1076003)(52116002)(2906002)(6512007)(66556008)(186003)(83380400001)(36756003)(69590400012)(66476007)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xlcYOrwtGBeXnSBqgO9EDZuwldnfX/bxW7kHs6g6lTZ7pGvSUPgcNczwbT3e?=
 =?us-ascii?Q?PK9lMG+eiE17fyk/8QIRBETxbcGSJi5zvzoKFY7EIsqSVRUMnAKxIsK9KdXN?=
 =?us-ascii?Q?fRWvxnx244oe2+fApQ1ylM2VbFs+peMt+4xX/3E6B6izDe6vGmu5qS5jkpfA?=
 =?us-ascii?Q?rrnIy8/5biqKPAwbWvXO2R7z4O0+WrDfJH7B5FNrMo/qPn80Do2crXIR8AgA?=
 =?us-ascii?Q?5dEI549pgMPNnbxk3IrahQMKO12SdCnzPgvYMsA+8rPeOMHCg6CIUSGRmgMG?=
 =?us-ascii?Q?hfYT2dr66k99vgSRczwlZqfSUiyMUNHjzHsg9yrLt38jbPJDy7WoxvZNNJOM?=
 =?us-ascii?Q?MDDmRUlHcePyVNlb1Lck6LnaAZZSYHhy+2GoTpUB0rHch44Naf0FR0YB8urE?=
 =?us-ascii?Q?oiCl+Ft6s83SoN2iOAojsTAYFU9zR7CBOEFfyrGdD2SBWvVMuYKqIPDqnZR7?=
 =?us-ascii?Q?MzDRF+DrfjAY90ZMj1pXAcFRAguP57g05d2Nm16VwKfvQWNYiuL4Oy5gRAxo?=
 =?us-ascii?Q?rmCR1FqnTjsGNH4Ukbmw9tUGLWmFuVCFEXTsUTxvsLAcFwyC7YTuX5AKjva4?=
 =?us-ascii?Q?nunV3LKHkhjV+XswDQVSB8V5cbs0z791Qy8KcLeTfAO3RJX45xGpd0HP8Qir?=
 =?us-ascii?Q?mDqGAbp//OrMdEWZf8fOGwrVv5g9c9G9Qq/RbGMw/QNGNxPTSxFS3Qat+U5Z?=
 =?us-ascii?Q?3YvWXXHqBu9l8HDGh8UnnF3WjhVc5zOh0JYCYECVriKgYbDYBlFbddZkEOz1?=
 =?us-ascii?Q?LtXyaEqAAMDU/yc3z6jXJnUAJo54uqiQQtHJPXYHbnRRB1QNqXrs+rtWOFYD?=
 =?us-ascii?Q?/fMvItv+CI6uara6NSiFyuLvCrNwnmwwZPVpdqgIRReEJUWfcWrmG1KKEsaS?=
 =?us-ascii?Q?p3KNc7r79jTkv2AYGS4u/mFGbBHzw8pFbCrjsRs53vwgWkNaGlwF4MWcsmml?=
 =?us-ascii?Q?IBLm+/3Avo04CHHH+ZchW1EooJNK8uZaGAOP4CULM/t+q+GLv6Chu7T85ARw?=
 =?us-ascii?Q?iyrFB3pMMRNJl737IVrCJKCxhWQ9sfCD5CcqH5u0/vGIMqn9o1YLZaeSqCx8?=
 =?us-ascii?Q?ssoeZ6boGICnAD41phnmXFtRPYwMWHWLiM9n479JpVua4h5aLvTAgBbKaiZb?=
 =?us-ascii?Q?MDUp9SjCppmREwcSmR5GVdqe6YEm+0TZ31O79tJRT41zBNSrViCQi0amC5UZ?=
 =?us-ascii?Q?XE6mPxRxD+DzNSUwNfgB617VuEogMg7AIeB493Mlc55W4cdBTCXboSjJV0bn?=
 =?us-ascii?Q?O7vRhrczZAUdisRbQc8ZNxjYDkmpCuGi6spYBMrNc2mi3t/YEGZhHAYmdYHH?=
 =?us-ascii?Q?8oRs+5TU5LGhWgstUYO9bJ7e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6206fa-25b2-44a5-f7de-08d8d3829192
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:21.7660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gt1hBoWyHhNWsnQOCwoPGM5VISYhcAUjgdC2VvyCJffWnbx++wLKO8PZMFJGmRrcwValG4dpg4j5LDwIaVQvRwXn5ALinjYFhsNFbxRumkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=882
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.12 branches
to handle conflicts with the in_interrupt changes.

The patches fix the following issues:

1. target_core_iblock plugs and unplugs the queue for every
command. To handle this issue and handle an issue that
vhost-scsi and loop were avoiding by adding their own workqueue,
I added a new submission workqueue to LIO. Drivers can pass cmds
to it, and we can then submit batches of cmds.

2. vhost-scsi and loop on the submission side were doing a work
per cmd but because we can block in the block layer on resources
like tags we can end up creating lots of threads that will fight
each other. In this patchset I just use a cmd list per device to
avoid abusing the workueue layer and to better batch the cmds
to the lower layers.

The combined patchset fixes a major perf issue we've been hitting
with vhost-scsi where IOPs were stuck at 230K when running:

    fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
    --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
    --group_reporting --runtime=60

The patches in this set get me to 350K when using devices that
have native IOPs of around 400-500K. 

3. Fix target_submit* error handling. While handling Christoph's
comment to kill target_submit_cmd_map_sgls I hit several bugs that
are now also fixed up.

V5:
- Add WARN if driver has used simple API and target_stop_session
- Added fix for simple API users (usb, sbp, and xen) for early failure
(invalid LUN, write on a RO dev, etc) handling.

V4:
- Fixed the target_submit error handling.
- Dropped get_cdb callback.
- Fixed kernel robot errors for incorrect return values and unused
variables.
- Used flush instead of cancel to fix bug in tmr code.
- Fixed race in tcmu.
- Made completion affinity handling a configfs setting
- Dropped patch that added the per device work lists. It really helped
a lot for higher perf initiators and tcm loop but only gave around a 5%
boost to other drivers. So I dropped it for now to see if there is
something more generic we can do.

V3:
- Fix rc type in target_submit so its a sense_reason_t
- Add BUG_ON if caller uses target_queue_cmd_submit but hasn't
implemented get_cdb.
- Drop unused variables in loop.
- Fix race in tcmu plug check
- Add comment about how plug check works in iblock
- Do a flush when handling TMRs instead of cancel

V2:
- Fix up container_of use coding style
- Handle offlist review comment from Laurence where with the
original code and my patches we can hit a bug where the cmd
times out, LIO starts up the TMR code, but it misses the cmd
because it's on the workqueue.
- Made the work per device work instead of session to handle
the previous issue and so if one dev hits some issue it sleeps on,
it won't block other devices.




