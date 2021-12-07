Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655F2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhLGCzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44156 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhLGCzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:01 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M56Ak019276;
        Tue, 7 Dec 2021 02:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=5DW0fy3ASL4BJWTAtLm6kjYPzKsIqkihGn7QaPXc3vk=;
 b=WpaWgeKM/SjkiuMtNsJmJjIHhD9/Nq+S6DuddAL28Uzsvp6InNYzP7fC85ag2xHeYAeP
 BGpMMVybmZVvxX+7jOPC5iB0YqmGqSer0xC/h88/e/i+rGg4xLrrbSdBs1hvzwsmu0V2
 TLAAQOx9UcEvL+PhaZMOPbV9EHiRTl7ET8CQ9L61zgYT2LGRd6FMVCJU3mWHvDpqR0co
 b7kzbYDT3+F1c5YsA9Fhl5jLuUgOUiskwOCT5KGpDKc8iyhVRhMfeIM2vwc8ThVVnYk7
 Nfo12M6hnNkXjSctVvJv86iwdnJHQPqMGIyyaBYCYjwIwCUrZCwF0TK44GlKhUnMDEbJ FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csbbqmef8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglV153019;
        Tue, 7 Dec 2021 02:51:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNHqcN/o01ocvxjLm7sTgjwKyFFZZLpeR1qTJ0dqNd1UfKXOz8oP5CjVItLZs+/oVK0Ybg68lrGC6CZSJBvLMhSsKAto6e157Hv5RIJiXBrefy42BUffSjJVbYfEx3n0edlmgP/cbwQsBQGKrshFL+fDmR5uaOCiNLr9PU3TnrcvFYXpAmzOF1PgyWm/B37nyRx9vKWBkX6GHvcPkW3ZHxpeMvLxqAJICl50JbuEEiN/zdAZQ/UZyIAO0sm4zz5ihTEapO46VWnvwhOD8rPEKOoFtWdrkiEiyQbCQcz9s54v0cEXVNrvXjGNRcbeScNRJJcU25cl2MGsy4B84O2ouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DW0fy3ASL4BJWTAtLm6kjYPzKsIqkihGn7QaPXc3vk=;
 b=T1YbDBaIPbDencJ+6kK5x+FkkNQ2EFnuCEQm2x+BU98UICueNlngjXM2VTlljBjiP4NAMLab0Zu1AYWgSv4b6TgTJ4nBcFCF2nA0GjVENDLFCupXv4g1m93rKAgU/fYS4vchGcHMopT3EFVBQ9HsXmB8ViQu7IvvWP8Jt6hXq4KA0KBBzo1jdnCoR+kEamexFuaQ/0lQ/8nFmpyX5zg/AuMlRlgzTCQcaHvrojPkUb8JIyJMCGgjcnpmQvVtpYYe0xCn7uWe6F6AlHiE4iWaNQULKOfCrlC7yYOHaE9muf46Tp9epNQq0WwjqoMbhc8dUIzxZADH9slwDD02TvLifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DW0fy3ASL4BJWTAtLm6kjYPzKsIqkihGn7QaPXc3vk=;
 b=NGMMdNJ0yNWXWgINvp4YNB+aWo6c8ifFlmvVKNDwlxL01Z3UtN6hVHqzEIXMdLLmaA6Xhp51xX2qqOlsdo5Xjd1hpLVcmnbujsvjlCKuX3XtWUfQ5aK/KeJkBfVx3Z/J96ZRrzWaFcaZjVJj00GlD92YDk2d+2n7g3OSK04GUFI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH V5 00/12] vhost: multiple worker support
Date:   Mon,  6 Dec 2021 20:51:05 -0600
Message-Id: <20211207025117.23551-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf624786-5113-483a-0235-08d9b92c75a6
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347AE8B088BA7ED4F328761F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iXmAEZUX+6eEsn8rc6+b+8PaP+DsnZtNMybtWgFlkfz0mags354DZ0tJBFIQqFwBqgqmKIL4EKIK0VkHcreuoMGHlrdhfazXcbrd1QxK2EvpYvblz6wxij1Xz/nSefjR0/SEhXT+5Z6wJVFTX84GVdSPCfspTRmRYWzjopBmvrPQIlwtwSG7Gl1u47TbtymT6fLzYWTLSEaUf6ROlkxDBaVpqt4SnX9PX97j2ziwztF6HjBxb8LtN2EgdQoAeK5aHlYvKQMawEyVuH4TRtKbLXfVyerdDnzbFYIeCDnbDhs3J9ss4ByaRThMSys0/LHTfJDFAfpHmbff/4UA/yT45dyA2fiuJBUguz/w4eWoqh6u0q3tQDJ4B+IPTKrMV5Ut7J7zxV+UtTkeTWZH+8RopyflY4Q8ENxezRjM3vPkSzeGBNHZdWtPOvHSBot+5FhNOl8Ld+4ASG2yDJE8ZvDi5rspvhuqmn1RQS/CI8tOve9EBQEo9S6Q4AAKpENDIbc2Q7BmkWFGxWRZlL3bZ3CCpwL96Z+q+Quh9Knp/dEJBL4SdgPj780c8FNLSMyiv+89yd8UQl0I9IfjjCUcrr6pdkN1ZQWgFkBzqxI0m9kqHHSWcXAwHb6w+8fL0L0h3PATzS2saGBAc2X4uRmNtedM3LnImnM62ThIqzoepMdf2kRDc+buAJzzNyDP3W/D12xV5pQ0HEyQj7Ngw7PmK7M8hW3BLNG9fIP77GdYJ+ZHr20Y24Lh1AvdWye6pCiHu4rRKuNeWFopMNQZ7oVn40S1IEGZP6ErRvNHCiAzanm2ARrOddZncAiieXVOlV2Apl14J6RlOdGFw7ZxIq8Vst/yCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(83380400001)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(966005)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gkz+BRQgN9UQjaTy4MLzZnXyxd7u4ZgqmyBCnQNGq0VImBCMeRSVb79vpF6X?=
 =?us-ascii?Q?YQd4ftY4vEhH37G/7EvZUQaedRx6nZNrrjlHj/NB3/B1tHlQd/8cwJI51MNR?=
 =?us-ascii?Q?Yri6HhA0kTUeXNYPjue0TitdaYrlp4y7mHJRFw1WGs3YJVZszM4bRiVhRf1e?=
 =?us-ascii?Q?ecyhdPryp5+5yW4reLWZUmjI6Px2rSZeVA5z4p9KcaGUOt3AubpGACMaaz2e?=
 =?us-ascii?Q?e8TzP9LW+Tc6ckqzXKDrMsOiqpCpPN7yxwxyU1rHiXapcAjRZO6hC1x4mYIQ?=
 =?us-ascii?Q?0qniHaRzAkw8FYDttann0VZGbULBv2ArcwOiDyJRlgW1GYE63Gk0CpHeIQyf?=
 =?us-ascii?Q?l7dH9R+Yj/YlCbEibqQEDAwInIL/SDmPT88rdo/TAm7DhFYksF91hbw/9L9Q?=
 =?us-ascii?Q?Q1WdBxTCGdzBKQ0GF9yVk065XTyDdRwv4A6b5i99myD2dMgiEGaN7NvCzpGF?=
 =?us-ascii?Q?PiOKzOiA7pXqTxekwF/q+CsQfD/hMOsoQnMZdgrHfr970j11mc8pRnu6i6cg?=
 =?us-ascii?Q?Z773qnvNKdhQ4OfdFI2SO0bEDEfFDf+RJCytbYXNgHFKXYKRu9wTHPDP4JjW?=
 =?us-ascii?Q?EHf5mea1oCCtHhbkpGZKdSG1u5GGIPxnNNFOrbCYGNSr/P+Mys9kEqxj3/on?=
 =?us-ascii?Q?4OQohBmbGxs28ZfzS72r7IuOL2M3k7JEsUsTEnc7V6eiwQLykgdDQWcu8sc4?=
 =?us-ascii?Q?jMHWAhyXWGD0YugEiy+921YonTfkJXLl+6JwvRUnf5FO7N43VeR6FlhdX6Ia?=
 =?us-ascii?Q?Yij7VEN+8XUGFTxTUn1kqKyFNiOykN78Itonoz+XeqtqglKQyC6nJs6B6HhE?=
 =?us-ascii?Q?WvfIfRr085JQzKGA0jEZ1wLU5Rb/ix6NRKHVCCIqhw0mzEcoQk4WpxAg8+UG?=
 =?us-ascii?Q?0XBeEKwA/VYokvFVgjrWIe8W6Tx7EZA0C9tcFzBvebQVY2l9gzjVqsMGZoHG?=
 =?us-ascii?Q?JA+3l9iLplZJEDXhLAuSOLIu69HPOU8+nU9coPuclLzts7E4RD22lm013A+e?=
 =?us-ascii?Q?cz7WTFJudzs4tPHSsO2PR+hv0WcwVLsoq7t3oM9isjHl95c1rL/C5WS2YwgA?=
 =?us-ascii?Q?bHVib3Y698X/6/D7kP6kvHe3hBO/oJeiKRlcwP1DhH1GJ2Kth/OIHDJD+iWL?=
 =?us-ascii?Q?Digc3/I4+oNOl9+sD/SeoFUZRnSYc9OaKOAMjkW3w6TMlmiT0MDBHyauU/sU?=
 =?us-ascii?Q?xv1Y9DjsAZhuZjpBe1lOE+IKnQ42v+QnlQUqHbXRIgVLfxBo0N+M/dMx7vQs?=
 =?us-ascii?Q?68F918DL1z/BeQi3kYORzQswhhm8Qn1WGlzLziYdjT/sULIydl5p2nKgO1/y?=
 =?us-ascii?Q?Z08xqYpFiB8rs+ntRHib92XGPeFoGll3rscsC6s1T4j6M5a0g6AIGTc/93c8?=
 =?us-ascii?Q?BJuQT0/ox9De/AGnAT1IUt+zfdh6LAqXx53hgs30HytYRGGcRIKJhAYIoWGb?=
 =?us-ascii?Q?0g+o3PbopRRwRcUr9X4z3NcLf08I/oQx5jcMqlTu82W/28EKaUz4uDuaUj+O?=
 =?us-ascii?Q?TzH9sOuuAugEkxlffuBk64g4whqqUcX3kieS+/fKOjLmnxt2I0ABuPBRsIsh?=
 =?us-ascii?Q?hqjPEw1mi+Q5y4bCjw6EieMzep0ZvUGsX1+BK2TvFlkKX7ljk71sabjpjO79?=
 =?us-ascii?Q?xXfnegVfLEEGutjgiKe1Gsjww2IrRmjo6W9Ue6Xj8hn4E+c30s/57E7BLlDf?=
 =?us-ascii?Q?k4STug=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf624786-5113-483a-0235-08d9b92c75a6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:25.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMOeMvh1tFlPGTrbWiDemlOz2YGrtVyOGJIu2lMB/iZ4meUNi7A8cnLFiDCD8fK1+1hR3kBUOYg8XK0/iPUhpcV8gb4+QXPoB/vyANSDQgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: pZeebUGd7tLHQTu1uR3oWy9a3LxbrncT
X-Proofpoint-ORIG-GUID: pZeebUGd7tLHQTu1uR3oWy9a3LxbrncT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over linus's tree and the user_worker
patchset here:

https://lore.kernel.org/virtualization/20211129194707.5863-1-michael.christie@oracle.com/T/#t

which allows us to check the vhost owner thread's RLIMITs, and they
are built over Andrey's flush cleanups:

https://lore.kernel.org/virtualization/20211207024510.23292-1-michael.christie@oracle.com/T/#t

The patches allow us to support multiple vhost workers per device. The
design is a modified version of Stefan's original idea where userspace has
the kernel create a worker and we pass back the pid. In this version, V4,
instead of passing the pid between user/kernel space we use a worker_id
which is just an integer managed by the vhost driver and we allow userspace
to create and free workers and then attach them to virtqueues at setup time
or while IO is running.

All review comments from the past reviews should be handled. If I didn't
reply to a review comment, I agreed with the comment and should have
handled it in this posting. Let me know if I missed one.

Results:
--------

fio jobs        1       2       4       8       12      16
----------------------------------------------------------
1 worker        84k    492k    510k    -       -       -
worker per vq   184k   380k    744k    1422k   2256k   2434k

Notes:
0. This used a simple fio command:

fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=4k \
--ioengine=libaio --iodepth=128  --numjobs=$JOBS_ABOVE

and I used a VM with 16 vCPUs and 16 virtqueues.

1. The patches were tested with emulate_pr=0 and these patches:

https://lore.kernel.org/all/yq1tuhge4bg.fsf@ca-mkp.ca.oracle.com/t/

which are in mkp's scsi branches for the next kernel. They fix the perf
issues where IOPs dropped at 12 vqs/jobs.

2. Because we have a hard limit of 1024 cmds, if the num jobs * iodepth
was greater than 1024, I would decrease iodepth. So 12 jobs used 85 cmds,
and 16 used 64.

3. The perf issue above at 2 jobs is because when we only have 1 worker
we execute more cmds per vhost_work due to all vqs funneling to one worker.
This results in less context switches and better batching without having to
tweak any settings. I'm working on patches to add back batching during lio
completion and do polling on the submission side.

We will still want the threading patches, because if we batch at the fio
level plus use the vhost theading patches, we can see a big boost like
below. So hopefully doing it at the kernel will allow apps to just work
without having to be smart like fio.

fio using io_uring and batching with the iodepth_batch* settings:

fio jobs        1       2       4       8       12      16
-------------------------------------------------------------
1 worker        494k    520k    -       -       -       -
worker per vq   496k    878k    1542k   2436k   2304k   2590k

V5:
- Rebase against user_worker patchset.
- Rebase against flush patchset.
- Redo vhost-scsi tmf flush handling so it doesn't access vq->worker.
V4:
- fix vhost-sock VSOCK_VQ_RX use.
- name functions called directly by ioctl cmd's to match the ioctl cmd.
- break up VHOST_SET_VRING_WORKER into a new, free and attach cmd.
- document worker lifetime, and cgroup, namespace, mm, rlimit
inheritance, make it clear we currently only support sharing within the
device.
- add support to attach workers while IO is running.
- instead of passing a pid_t of the kernel thread, pass a int allocated
by the vhost layer with an idr.

V3:
- fully convert vhost code to use vq based APIs instead of leaving it
half per dev and half per vq.
- rebase against kernel worker API.
- Drop delayed worker creation. We always create the default worker at
VHOST_SET_OWNER time. Userspace can create and bind workers after that.

V2:
- change loop that we take a refcount to the worker in
- replaced pid == -1 with define.
- fixed tabbing/spacing coding style issue
- use hash instead of list to lookup workers.
- I dropped the patch that added an ioctl cmd to get a vq's worker's
pid. I saw we might do a generic netlink interface instead.



