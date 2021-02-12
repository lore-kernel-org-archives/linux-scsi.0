Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C386C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D1664E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhBLH1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:27:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40236 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBLH1n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PNgS016784;
        Fri, 12 Feb 2021 07:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7PSiiholU+bj09wr2L1i6BdRlm6F5FaI6m6nJVktJQY=;
 b=PRdchNX/qapPUcZlD2N3A8KojLyvBKqTGHibdNTpmWlNUhVVyfPQFLaxoDMYo0GQkb9L
 g/tyGu4kN6BOUpdJM+ItUqMdtUbrCAFnEeSLWepJXHff5PTklxcPbrLI0QZXnIWTx8sV
 J7ysT262mjgGNIWW5x5HZC1yHOJXmcKa+HuUDDrCUkNIawhbdFugEUKcACjrVrC1bSQB
 ZJFuTKmV9/9ZZuo/nCXBlI+Kst+4y+a9t8QIQZYMpZT3uJLHTvmW1LPGb33YzYNyYifI
 OyI6GDZplLw7h+j2KH3VB6SbkiACYbmZZduZrZScrCWxAGON4vUvYDnjEQl/0Lg3LhlF Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36mv9dvctv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PZdL022757;
        Fri, 12 Feb 2021 07:26:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 36j5155a2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK79ub6RkrEJJ7JmXyZIZXVlpE4IUg4FXXFIWADeVHsBp60wlg2/9qvVGDE3QGDe0WeNftjz13O6ucjvHnupcigAXwHrDTx7CTjzEVTxtOb6xB+A4lq/twudMqSWySeydLdY/ouzm4x4FUB6eGMSEJTfB7d1VgGF4EWxb4M/pj0fqPlcYX8NKEPZjO/xMozX/gXxeDt9nOyg4z3uCeOmeuYR2unwaa12xfA4aY0O9PG4YD/BSxm6TWP1XecBmFgA4OmR8764LBxCjoNwfPxPY+VYqENXKIe0P2X3Jap3xo9PvOgN+GyP47mXTF0r0iD1ZOxyGUMPOFhaazUVEkUaiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PSiiholU+bj09wr2L1i6BdRlm6F5FaI6m6nJVktJQY=;
 b=A2f59ucCQGB0u9+7JER6PCl/+frkvIG2esXwI7wHaDh/44Fpiy5OZrKKYelMsy1x1ZihzcL4w5Unh1aOvYuxCiCMxsY9HB7RgBXv68eDgEWq0VZv/DOxjLBc2/syjZDXugtbQLZQ8m9hyV+RMMfw+vCBMY8baRhiN29LvmqHqNgHBxiTvSiuDyEjqVoXT0I0IbGeQ1aGavQYpkWGBz+AzRUCIdZumo3bF7qEfuo4oNT6xuTRCphG/uMsztBvBwdqhi7OM1stoiX9xeADB/OaAD56L9BgBKjJhGNwku6KbddnKnffdAE0U6+Y6evrO1mBky+lI+LboDkrNz7NtaqATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PSiiholU+bj09wr2L1i6BdRlm6F5FaI6m6nJVktJQY=;
 b=U0jKsKMTGoMnbIpC+NsLClGPwMoAKmPFcuS9vmheNYiQ3W27iA6VT2hvcGZIsncnv8z9JZ4d5EU1WJ7dFJjxWTYOXZJ9/BUTQCHD2XlNcJsFsulHk0v0SM/PnxXs+/y+n8lWLiTdmFplnHWP9MEHebg78EBgud30OvB9YxMzGmo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5256.namprd10.prod.outlook.com (2603:10b6:408:12f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 07:26:51 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: PATCH 00/25 V4] target: fix cmd plugging and submission
Date:   Fri, 12 Feb 2021 01:26:17 -0600
Message-Id: <20210212072642.17520-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5664f02-feec-44d0-393a-08d8cf279079
X-MS-TrafficTypeDiagnostic: BN0PR10MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52561515A552144E5AD00F3AF18B9@BN0PR10MB5256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cI3ejF/JxZU7wt0TMs2QPPesLcVwnv746DQ8gYkODRqJzwa7bHmEzK11ybMm2+ePlAeJnz3mbPta2eI6BAaVWBVC2rQlJ9zdodAeWQBzsuMUa10NlVb7b9ulB9ei0yyTqYb8+CrXRPmiPpwQjpLezlRvrC+zxQ1ceDkUQVPUWnspDyzzYFx9sdjTpdNkDELb58De882f55eBf/yLkO1Jejjzx321Ik76nFNvKAHPhF2S8inl3xqI+8c8gr5ir0ouUQQV8iRIFg/31KxsqaL8xYPzJTlyaGpV1fHUampgTfZWyg7fKHHbq4HuUyORQKKjRVYO173RS8vhkLYXBwuz3EYCqt2fE7NfW+20Mi5jla/vZLaWqY8m6C7bDfqQPuM65Y3IW1aRWfQJth/unQjgQa2rSQjtfPzLGfXGpf2VK/4CGRpN/fZa78wUjKrSB7MtnI4IIsRYIAL2cAD9ByTWQGRgQR2GpB5xkBePWrQy9+mQHuAHg7Chsyh0jSNRPCfDsxT410vSRFhDrFuz7vwpZnqjrxZzt46ZCUcCC+ZRwqRsB11/wqAXdxRZNeimGTOWi/ofw02GZSAltTsbH93eNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(478600001)(1076003)(6512007)(83380400001)(8676002)(66556008)(5660300002)(316002)(66476007)(6666004)(8936002)(69590400011)(36756003)(86362001)(6506007)(16526019)(2906002)(186003)(2616005)(956004)(6486002)(52116002)(26005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m8GlFlwcj+32+Wh7gFmv40L3LFUwunQzs6bihRxxWlBsuPQiSGkwbM/AIzZm?=
 =?us-ascii?Q?FtgK26RP35hnVcuQiK7DjPqURG4lz+qzbgsywlsCiOSwC59ocHyKnZcMK8h/?=
 =?us-ascii?Q?4J7BCt1qeE79icICl1lQNO6nysH2ILigQIlv7b9tAfL9nYd0qbNlUZCj2gA6?=
 =?us-ascii?Q?I/Yl2Qm4S7iiozKWlNYmVGE/4X36JUaBUJqiZfaiAmrh8Ma1tgVuI3jJLcb9?=
 =?us-ascii?Q?wnvy29Ahkw+0tZ+YLUEGz6a2eqwil//qiubs0viy+ZYf0MtaReNgRo8ILyC7?=
 =?us-ascii?Q?Xh5Qlm1r3X879H9/83tZ7YIgweg3GPuXDHmRFG1q096vZ8ezp+gRACduCyxM?=
 =?us-ascii?Q?QRfX/F3O/w1JrD00Xgcgu4wPYuciOyZdiZQNAgmhb8ZrBeGqOis3vRkAucoL?=
 =?us-ascii?Q?y8aXuld8jERIUhVbLq3dUtGCrjWavvEjdPZ3IgzuLq6ELnY4Yo/6L+mQ/awA?=
 =?us-ascii?Q?THrOMY++NRZfTRQXAvTwzwuqzR6Sd4GdVQKfi2HuYUHiIrAxTC8gKBOwaCsk?=
 =?us-ascii?Q?i8EA8lMKLC9bIz4qjq8X8fuJ8miGUYkg9xxqJfu8LUtwJr4KTKMBQez3HL1h?=
 =?us-ascii?Q?CPYNTxf5Xp7aO31yDXiZYcrgs0qGxz/1z9ZZcIguCczHtpjKAckTRov2lnCI?=
 =?us-ascii?Q?MYVT4lq9xN2Jlgi+MXBSzkvGE3vqSPvzUC8Ep4lQqJD552eoHncUzvoTkhZr?=
 =?us-ascii?Q?mtuhUz4YYjC8srzKhVPZ0s7rMLvx/9l3mymHiOenIRBQwJEnT/m+aivRAFtU?=
 =?us-ascii?Q?vzlGl12jzKm3lP6xGi2JArW6KZ3K1qqHL46LDNNwl5jUB9aKY+Q/rcKCPzua?=
 =?us-ascii?Q?SswmwP1na3g9ZybxJQFdEayZFWI6/kR6VLye/1Z3XxQ78zXiI8W5C9m5H3bU?=
 =?us-ascii?Q?/XezA7Ms+4EPngwD5aI3+E8dXCwSrR4Ajmh5PGGR7/MmXOMFBWkiGQNxwPkR?=
 =?us-ascii?Q?EC+T3hyVzD02Ch77Ko42Hi3s0e2kWSHtFfsDuXAEWPgc44TflIWMEowi/eeX?=
 =?us-ascii?Q?A9m2bnvZ/2dW2zLkeMC10MaOtDus6tCIBdzxJFcRwFsx0yIX/myX9/uw3Ps6?=
 =?us-ascii?Q?+7JE+LHunsE/eurunfYFIXw/9EVS/Mor5lZeNppu7cfQjDDYvk/rr+Fz+127?=
 =?us-ascii?Q?raioBZtDyTYU0EQmXXRngr4VZO0SdhFFN0LCMFT6eGnKW5LLC17xSWXQs+hd?=
 =?us-ascii?Q?/pzlvMQRRubff1QtwzMoJAFtm9FDTLOfNPEqFv8a8oFK8OAAvv+7zY8/7Xzi?=
 =?us-ascii?Q?Wvu/EflHe66RhUjdWvD/G2XTvoIPIFmfff0Z42NIbolGgCrgK5cYx1wWydvN?=
 =?us-ascii?Q?hVYgxYs4tr+ii4bfg7rWEp74?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5664f02-feec-44d0-393a-08d8cf279079
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:51.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HxWF/ZDkG4zlWm8dryrpZdG96V9weh1doEvcH1XMkH+uc4tw8r8PRR1nw+RHKrKRtKHesURQkTxIL4hi4prv5rGZnq19czdXDYhtIxtqFqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5256
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
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



