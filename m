Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922B6C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0F264E92
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBGErt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:47:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38662 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBGEr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174kQdn168272;
        Sun, 7 Feb 2021 04:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+G5Eu7GDLLHKB5rOjKvs8+yW6SWZML0wWLAjKD3+zMU=;
 b=XX5jLpTnCBt9wjJNwET7PUT9D+rV1QnAQaXqk/S0VDgju58y7jdyZot1TsOzGbpyyYD2
 kaAfMi3qamAuWZ0gp04Ps3KMp1o/0b9Y3vB2Cw6gjLp+QvsE/uWOhaC/+qUXSkR/b7HE
 /OQjV3piOjPWeZBval4gib2ksUhIeOmiIi94oMwk/dh6daMzl0wHpmtdUSXv9VbMuicd
 OEWi0SRXOOALeimL9JkgeNUF/7j+3HOqkpPIIsFUD29I0hh7bzvSzvG7oc7nCcIemR1j
 1zBPyRIfX5MY7COxINoer3PkKCR7FqP28ztpHHrD+KkWHysw6V3EZZAi5Ct4U/7dTtzK Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgma9fnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174ixme004585;
        Sun, 7 Feb 2021 04:46:25 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2057.outbound.protection.outlook.com [104.47.38.57])
        by userp3030.oracle.com with ESMTP id 36j51tcnyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJREsTcVgwVwE2TGs+9xlMb7y/28w8LgqAOQYNihWvrDjd71/BX1/R0LEjldTzCzFwOqFtmAXKaOgmM2+uwR8o+D79yEYMrTGVvlB8LHGKJ8L0Khzhn4FaKKGtyYGLJemrnnUk3ZugBPqkqlCHSzRDj7Rq/9klfgDbvUMvSwANDJBxvkojPvbeE/wv6sN9c1kniS5YcrUkVudtZE8ITMzs4URJYMIa+pAKUU6vJGtCSOKA+IS/6R2POo3Erx5v8gQRZbTepVSpkW/Lz0D4hyUW5pFhVGzd5rAbt/wa4cCp5AkbrgjWIRbVRFLhdwbKMv30N3m2XQ0fPyPFJJq/rrtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+G5Eu7GDLLHKB5rOjKvs8+yW6SWZML0wWLAjKD3+zMU=;
 b=ehTbVDrGzNOmnJozecSCjV/TksLVqZrWUdDtz0KUcb1Sc4CkcXPi5SAbFOxeBPFLkM5GzZiX8SRXpyAs/EQ+YvU/PINtNcjUyN9uCh1Y3JP7zgF38Tk0rDeKmInEAA+r5uPCeNxp+JryfdP6v/KJrcxGjDCUcfyRRa2ozf5rN6x6BignLW0sXN8HsKpqeLxzH4u34BUQEXWtP5RMdHiALUlKSd3AXqm+SkTN439qsl0b3sSseP1FsKx1Dgk1vKY7XF/kVCEVVanVpU18pcpMGTVGMRxhBuPugKwhBbA6pZLkBSoz8dbpZE9l5XYMFqqHLRYe1dHle2Hc8aSYbL79hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+G5Eu7GDLLHKB5rOjKvs8+yW6SWZML0wWLAjKD3+zMU=;
 b=lnL9RyZFVKhVAOiTJiwY9HrSnwD9JJPZZwpgf3pAhCzAzglm+gfgh7fM5N4+uNutoqJR2X09O5aY3DsIMtJQnlgLzj0k/1zwRWZR4BbJPtu0mcXSYxk7F6pTtXXlhQrMve4wYo9F4EQXyEeZ66QaXb6eWjaiSBL+coJa/xYx50w=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 0/9 V6] iscsi fixes and cleanups
Date:   Sat,  6 Feb 2021 22:45:59 -0600
Message-Id: <20210207044608.27585-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddf81d2e-12bb-4567-d507-08d8cb235076
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3429204E1DE52E55879DF6DDF1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0Wsb0VGEMv6oS6JlBXTrTkZ0vHQnERnbVtuuCTYX/G+5h3MTFOGGmSbu7Po5cb4eOHXPuIWJaDSGtwrE9AwtVtMmKOJL+XTmkx8oYiAdyKY6Qt0SqKx08Y5kd2UPg+NhvIeECwXFN7dB5pAyemVwKJsvONJqoT689AnFYBt7RIM9SrtFHtljBFxCHxMjZT2D8zPXZZ67gNMQYv5TkJR2a9NumzMn2mia5mBt5Ll0GAILOM8MmWUV3fAuJc8babmtwxJbQ1vIFLMNlmyqFyhu3pTxs5ElMCCQUIF1Ww2Ygwsu6QCUHMbNLS1QN/WgeWHOpsy1m26PnV5DofY0Nf2JhCQjiyksedGk6ZZID/sRIjO7UekHvh+zey8QP8+z0DsO8FL2Q0xWKtlpD46dvzMB7caclTCDCjqkL7hwOr5q98weo+KQvcQxDIu8ONmcT6mEabvkRDN3sgt7RBTREhGjoRE0v0wG8SiRgV2CJGsaHza1U93cn37nzbaSWR1344F7if33Ah1Of9CQHvXi/qBVo9kby19vzWLWGAPGps0gcxelMNI+0FDgOW/YuloeR+Gd4gPg2TQN87WWq6OzHdWDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g6epaPqbgQuNST/CI/+Q+0p6DMZwQ+Sj/FU+cQW64c44yNhP30jUcugeuZqx?=
 =?us-ascii?Q?Ud358bqhtdVvq9AgWH27BEnNo/DJS3VE9B1V1fsxLxHYt4sq+9mjMqET/FFs?=
 =?us-ascii?Q?KJPGD5hKUCa+ju91+IGXVZ0uc0Ei0UV2/pybAXzCzpzMFhWxdMJlykBTuNH4?=
 =?us-ascii?Q?KEewNqPoRDg1Hv1zQ6t4pF6ughTcLlJKdze/wM4s1OqIaulL/lGdEwmdhenQ?=
 =?us-ascii?Q?RldhVeUF6SrP/jmVmCp71MuNbYpuZ14WPHpDgbuuoP6dGCFCjEYJq3x55w04?=
 =?us-ascii?Q?RaoISPx4+SqWVI18ibxLxycnxEKjAoVEOhUqPI5bVq1LD/ezPbvMhkzu7+ux?=
 =?us-ascii?Q?HBJEy9iNC1Hq4JpIZsXNp7lb/xB0t3IJzSgZ8IQhGmFqKbwtHxuUhe9Rxw7n?=
 =?us-ascii?Q?oSnMos0OXeeRI0tZ6ySgXlbMe/IFJq4KM/I2YakyAtu7IHLDJooMfPZRsBBg?=
 =?us-ascii?Q?MJpWibgVYEWlqqLB6GCbx9vptkcxeyyvS4hWaDP+DziNFYNJVOc34S0juhR6?=
 =?us-ascii?Q?I0GzpEO88WkkdIohbwv0JC+zWbPFCbNPvx5Bfz5Ngvxh7cUJFIr4VUdqzU1x?=
 =?us-ascii?Q?r4kvyh8yb6uOGkOj8YhfIfA59r1yYa/cbVJH41fMq7WnZL6Noh5NceGjxUg+?=
 =?us-ascii?Q?FqbdQqtVzpjpFlwy1cwMsQo42yLtL1mSEEbbUo2dk5XzdvLdhEXNbi7HE+zq?=
 =?us-ascii?Q?fxlhpkLpW0KTglPeBcdalg3MdoaSpVc3/5nYE9e3WgFBtDQEgIzdXI3WRapR?=
 =?us-ascii?Q?Qv2Pu1nw7d7JkMigvhWXVO6pyXsnf+s4MJXozpprq/3Amc2i9A88n6vJbJ1Q?=
 =?us-ascii?Q?+TSOU2OvZ/Fe4rkX0UiPIH6t7VgfwRrSjMtMQow4dJUEc9oq373JFkHaMRP7?=
 =?us-ascii?Q?zaW27hMyfXP10+3cwOajzItS9bYNX0H2jbSB57DwQmqNhwHQ85iR5LoCoKmb?=
 =?us-ascii?Q?skF/DoRzWcku5im+l92tKUoQzCmR5GnP/43aFu4N9d/RQfFKzDkI9fAG3rj2?=
 =?us-ascii?Q?0dYYlXjPoilVmumSUS+vLbUiRpaE5Br6OjHs6dhtwnXh26bY9FqXitlhpcJH?=
 =?us-ascii?Q?f1c+MkwXxXM8Wq30AjZZy7Rxilh6PePTDuLc9A2PogkKpKoFa2Bl3xG29MyN?=
 =?us-ascii?Q?8Dxla+KpZh2FnxP2aOCw47BiqjQ536RBH6MfmZHlITyv9FpKFNjb15YtXpPP?=
 =?us-ascii?Q?P4uB8oRt0ljQkIQ+nMkmvQwPs03DwbadyNtGaLQjvDlGd9oPaUVxb1FGyMct?=
 =?us-ascii?Q?F+7E2y7LEwuD7aik1KrVYBfkpO7rkDC3nQT+I7hAaBdbvBJzbmAlvCWXCueC?=
 =?us-ascii?Q?K1sMlNDaa0YzoZcDTy8EltP+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf81d2e-12bb-4567-d507-08d8cb235076
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:20.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JoL1ADcRcTZjWmBQJto4LrYcHeE+++zj4D06Gf93mN1R8+0YcWWT68BVVNIvsqsDEtFZRmgT/0d6GBTgteWt7g7Q8fZfaMl+KSeEOnGBI/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=974 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 5.12 branches contain
fixes for a cmd lifetime bug, software iscsi can_queue setup,
and a couple of the lock cleanup patches Lee has already ackd.

V6:
- Remove task->sc check that is no longer needed because the
helper function we use does the check for us.

V5:
- Fix up KERN_ERR/INFO use when detecting invalid max_cmds values
from the user.
- Set iscsi_tcp can queue to max value it can support not including
mgmt cmds since the driver itself is not limited and that is a libiscsi
layer limit.
- Added the iscsi session class lock cleanup from the lock cleanup
patchset since it was reviewed already and this is now a patchset
for the next feature window.

V4:
- Add patch:
[PATCH 4/7] libiscsi: fix iscsi host workq destruction
to fix an issue where the user might only call iscsi_host_alloc then
iscsi_host_free and that was leaving the iscsi workqueue running.
- Add check for if a driver were to set can_queue to ISCSI_MGMT_CMDS_MAX
or less.
V3:
- Add some patches for issues found while testing.
        - session queue depth was stuck at 128
        - cmd window could not be detected when session was relogged in.
- Patch "libiscsi: drop taskqueuelock" had a bug where we did not
disable bhs and during xmit thread suspension leaked the current task.
V2:
- Take back_lock when looping over running cmds in iscsi_eh_cmd_timed_out
in case those complete while we are accessing them.



