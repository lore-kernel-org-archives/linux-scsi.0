Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD260C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7498464E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhBJE4V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:56:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhBJE4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4t2ac004861;
        Wed, 10 Feb 2021 04:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=j2y9JGfqtpZ5KkENJ3uazo7kQuS8OfsUCZ6uquF7ACg=;
 b=W/D+3eCkDTwwr6RFvGDi9GX/PNK4Z7yIZprImVeDxTOD0Kq21dLIdQk7BjZ4ichjFrXu
 uYdyZSU/BbHqJDJhSa9lFmtMgu0f5ZsdcU+qX63jayF+c91dwzn8j/1FkBcgyIoF2wlu
 e8OqIch1la2oieHrmPIZZZ72207qFftfIETkb6g8NyglfJYFUhBe+x90Wc/hR3Mh8d7g
 wYU5gVKC6HiwAdEb7heQwcbzoKdKRvLzFVtVKcJq35FD+I6HuQ8u3GsIpTl4LqFq7g+q
 557kQWFVJ5r4moxv9LNqoGVfhdtRAW2msLT90I7PRd6zEONKwVsnJnuIdyXqO3bOqaCM zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmaj0tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB2048727;
        Wed, 10 Feb 2021 04:55:31 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQgOkw0h8aU+wEiKfD8t4MIRd6HRwAFFO8E+YwDr+4CKAXRlV+ULg9EXHCPp5WZ1VhfmC8ke4Jz4omuUuMY/bxCgaBrERH6YQrQiloTYubw9ex9f1BefhIUAKK7udJhpgEDaRo5cgk3yF0VKXP4DyNTwJylND0zdpbuIVQ6MSHfW2HIjXjc/SljTe9mHdrTT8pBuMP+g1RZGB2rBH80cS4IXJQnIcfJDqWe2VITaPKDueyBpx3IWHYBH+3IE7fjqdb3eX7D7s8zxq/XAElL39dG7m8EqaM4X4GFL/Mjz+LRFP4HLPuWKerVSflVERmIBQ4tqW3PunYQzzKsX8aAwAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2y9JGfqtpZ5KkENJ3uazo7kQuS8OfsUCZ6uquF7ACg=;
 b=GKgWvYJeWDOp2iBrBOVbxfHvrikHhLeIdoFfx7Xrq38s7XFUcrCg8kPh343Ux2HohwcgvGKTlW1SEnji5mmf7R8emLG1UOu6wCyfPescC3Sgw8fP/1FKdlYPG7DoKuS58eju2mBAwKHMBvyaqDGJnimu4B48XKykcP93M3KdDD7nQXX/pVbf7QHbY+C+EIcoAw6JskmCNMZGlHyKQgrdtppmWVkbfp1c9ZKcP++B44/8S415F/mpM5x6i0k6iDymKcJdPkaRY3UQHnaqE3vL+kmaFdR4yc67ifxurnVnojbOM+LoX1bZnw7PwX8gEVniTKjvgZ6X2HB6Z/P02rOYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2y9JGfqtpZ5KkENJ3uazo7kQuS8OfsUCZ6uquF7ACg=;
 b=ks1IPbgkbtX55uUL12NU8n3ZcSPnhS5vnuY2+03Z4hFjfZ5B9+5HFP6VhQQZ2865uKwHKzKNSNlYEr8wAU8MpSWY9QneBaQiO8jZ5C+Rx1k7eU/0eztfpvn1v8L1LXKR84+Y4e75GfawAtgoc4kX+A1HxwXEZ49F4L70UAIPhG8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:25 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Subject: [PATCH 00/13 V3] target: fix cmd plugging and completion
Date:   Tue,  9 Feb 2021 22:55:03 -0600
Message-Id: <20210210045516.11180-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9da79362-0be7-4930-666a-08d8cd801444
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366619F7521FF578CD2D503F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cA1aJm+/fbRxnTnkJUEaY3++CIYQdeIuqyL5go8AChzeJbNZ1MNAwBP2sp7lzw4flIC47x6sAztCdFAyuyd8kMxvXkhV1HGwh9Kk10E7kEJsn1GwXJILNFYOLSV1tYdpdZ66DlXz0AUucbVIayxCpjXZv8AVU7LHfL2xS/9EgVJ4x66ym5JFAowQYipaqY8wYm02WSGwLVsPPjtlw+fz4fIROYkJIwsGD590/f0bKKo+4BBvc+OgaoduLbUOnICDQGoEKK99+JXgPlPgEa7+NPvlUgemxhdALmW08PmGZ/Boj8O2eoc1YFEZk4UDhJjx77M62qK/5my6ox5vBW0ER4CdmT8b4wYGAHxZwla4sxCptb+FP1BMBfj5qT/qh1TrAfJvx8Q+emwdcvZharwQf0Ct+V28/1e4ISTJbnh+T7F9cO3FctbNn7agKAuJY6pJpVf4t5Vkw5Uwsqq9r3v53NUjN3WNx2lnpDgOUKm454SURGJ6sQU6IoK/tPXP4JG8mZNSP97rshOiKDr9tELtePoukZHHFjggo3hftFcq+SvJJxeee47isTm56ihdVaGg4c6yXigsb/E4QbBRH5A77ZRJEwhrucKVZwuJDMLC5+vQwPB1a9NtbeylChpIpmJ9nf0gIanLLjN5Jx/sDIIIwfOZA5eEkBR2aRQ6K1N455c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(26005)(5660300002)(498600001)(52116002)(966005)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(66946007)(66556008)(66476007)(6506007)(6666004)(8676002)(2906002)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l1nIs/ZRC4rbJzFj7v1Lm7R3ihwrrOvRi3dIpaWbwTeKdu0/R4gdDOssUjge?=
 =?us-ascii?Q?mdQSGEIqCGekRdk0sTdqxdJo2wQ9L1L/n3Z1oPOmcFYhKZl2pgUtp9EAHjTZ?=
 =?us-ascii?Q?mJwe+6eMIALJqDDnY6JcL5K/RBYW4zMV+9HumDpllGfoAplbayJAr3jCno+b?=
 =?us-ascii?Q?qrYpK4C6xKryW8MR0ubphVlyQiwmLTZFpghy/oeBkuCBB5hwQI9OP2fBnemQ?=
 =?us-ascii?Q?i1j/jFhooJd1spaszmQazto1KCBkBwg+ttm6Pz2Kt0GsiaIgWdM9Kyfnl4t5?=
 =?us-ascii?Q?jhNWN8y7jgJv0QyOyw7j5ygOantYwObji07tGDqWej1ZG6+nGBP1E6qgwtJR?=
 =?us-ascii?Q?aQ0VhaI/pCLDT0J3UNL2bmneBrCa9NCQ7XClf/CqzElbO9jzf1qJLPkpXUwh?=
 =?us-ascii?Q?g8PGBKaElYrlbx4A2lQYElPUc6DBboHwT86sY3RZOCHxdxmC59T1tT4CBFOl?=
 =?us-ascii?Q?qqy8Z1odKbwr/m/QbqKfR605yCz1srdx7nzCZmV7zhEqWTXdzCnYfsRXLmc9?=
 =?us-ascii?Q?kNwcaLvx9aji4mfqusmk/k4NeZq+VBpZUiQMUpVhR/x/F9hQYp8b6OZgLUqI?=
 =?us-ascii?Q?Ryuxp8rvxTze+pOCUnbHhpCDNei/iEHmt6bF9OQWdv2ik7tOxVGsiuwk+0UJ?=
 =?us-ascii?Q?EdTRZDzZ0cvMgD+Zilw+6mhliDHCFNcZOcUm39vIwD/Sk2oCyojVxWzAD40G?=
 =?us-ascii?Q?99d8IFBJ3AkBqqiHGa0oJni70+LL27lZMce+dXr2WD5TrSdKRx2Lo2GGnyrC?=
 =?us-ascii?Q?CavxrI0ltkj89/qpIuH4U8zQ2mEvv50YtUbvUW5hH2S6Qzl5gfMxcs8RxeiY?=
 =?us-ascii?Q?hysVwjWY/sBYU0HRwlwrmB9WqVOe48f72LC7Ur8J2XAZvWP1GFHYqOaBGhSM?=
 =?us-ascii?Q?Qe/040cYcUDA1BY4apK2io686dTfy0NdpeQxWoLGeuv3bgnSV7iRK0AO4pnR?=
 =?us-ascii?Q?XbofDjeEI0jg2w/JcSMyXcjgElgAowJB/Q8cJgZ2FOs8olGYj8m3Yr1abqYN?=
 =?us-ascii?Q?suw4hypDvJEhIDzdFpcamMk3dHNgNis1dCIQeGcdleTwEwhc6DImIxqFdjmk?=
 =?us-ascii?Q?ijJZj8NVKVSwzeCJsnkFkSlkibzwLX55LUghLK7wcT2UgC7oi/vpuuLFVc5H?=
 =?us-ascii?Q?XEyl9Gk+t38T6kZcj3SCjk8YyTxijktCKRv+dOSodLCdXdxJhggLOhX55bcz?=
 =?us-ascii?Q?9Fd92ur28w03kVDPSoBfZxn1/OpNks6FC84HaG6a7OBExkqqaXMSzaX44IKS?=
 =?us-ascii?Q?0wW12fVkBaJgSDa6fauiIxsppu4g6/HGV1ulkBbCvaNAwerOpwvqFVNPAOs5?=
 =?us-ascii?Q?TFJtE/oJNqOVqWhTjIbAhQ8D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da79362-0be7-4930-666a-08d8cd801444
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:25.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCBKWaUCSFkkKpGerYeU82nzr/Apiv9phJ39eDatBhm8zTu5idVtewAikUFwQRvX/W+I/0Os8h3rvg69tT7LYJeLeQWuJvRar4tJjeVAf+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 5.12 branches

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=5.12/scsi-staging
or
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=5.12/scsi-queue

to handle conflicts with the in_interrupt changes.

1. target_core_iblock plugs and unplugs the queue for every
command. To handle this issue and handle an issue that
vhost-scsi and loop were avoiding by adding their own workqueue,
I added a new submission workqueue to LIO. Drivers can pass cmds
to it, and we can then submit batches of cmds.

2. vhost-scsi and loop on the submission side were doing a work
per cmd and on the lio completion side it was doing a work per
cmd. The cap on running works is 512 (max_active) and so we can
end up end up using a lot of threads when submissions start blocking
because they hit the block tag limit or the completion side blocks
trying to send the cmd. In this patchset I just use a cmd list
per session to avoid abusing the workueue layer.

The combined patchset fixes a major perf issue we've been hitting
where IOPs is stuck at 230K when running:

    fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
    --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
    --group_reporting --runtime=60

The patches in this set get me to 350K when using devices that
have native IOPs of around 400-500K.

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



