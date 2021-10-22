Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87D1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B66C460E97
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhJVFVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:21:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35276 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhJVFVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:48 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2tEeQ010955;
        Fri, 22 Oct 2021 05:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JGZcUx3juMI26ASTMGBwAZAIdZ3x2O60GnDs5n25Wb0=;
 b=Z0e4WO1EGkC+Hw7jBcox/9XswEb05cPE4438wFsyrlmogjCMRdQIboy4MUeBE7JDenKU
 adJnqnMKVfFvPI72uwfpnwlOdQmHBeDb68VrNFq+7wbVVE5m+luMA6iEHOSkTSiuTX9m
 Jc2ozSyfJT2FhtmJoPw+kg2DAXvOWtnWvQ78h///uAshG0QApcgBwiKzJqmq9jE8OfFz
 Ya4h0e73QrKNSzNCUlASqZD3KW5zF6+F3BVS6bLRYBqo+OPS2oFQI7f+l2/zz49UDUL/
 g4vDA1ixSBPc3QrZL5gD5UFztMDhNmJpedEXOTIWwP1bcYIFGB08M8/CDq1oLa6wsExN uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqyps42g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIY139141;
        Fri, 22 Oct 2021 05:19:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0jSStMiWsMNloImZEjenihlmN7krDzPyRjXL/QpO12hRQEdIZLTclWJux77PSob8UlO4DupPJ5KiaSRBqk177Df/JTAaMXwaciDCgPZS/AeA+NjgAGpE+ar/LkqJ2JTO8CYSH7sXmVXlZQUzoE2gxK5Vh2NM1NIwJfbwnyj/LQx62S0f2eUzcoVneLXCheSq4x0qSeGdZeK67YYfELG5L+XLHHX+WVS8lM+blcMmlBkojfKq24KrK+yoFU2EVXLebgecCIfSkdI32s1ubJpEvmotLP1MM7cLI1h0hCsGK0wwfylQ7WmwSC0akaXz7YfxzAb+4XlutSFKmXJrISC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGZcUx3juMI26ASTMGBwAZAIdZ3x2O60GnDs5n25Wb0=;
 b=VPkyeb5p34zarLOph+oInG9Sxav3ud3rkzjXfyYUjUMwpZbQzNkhgTzrReXBVwX4bxDoWwYgJVzjjF4z9Dj/MQfqeLdHbiC3GR8nefAXGf7vQNtvn9MDJX73WFgQuJda8paIMeMoxGIzoXiEOGKlEYmUEd6Py94gDQM8HNNHazkZk5XdpNZG1spP52Ke6KKUf/tnTIJHoBoW76uH4BXlzLP322Dvi2wi2yclSdMN6wiSQ2x0WOahdhzljzxW2TkAKfmK1jBoKnpaCgwR3bPR1WsJQVPvVMxyMqpQ4aLZg19MhQEMR6GJHMoSdPdHapkclCt/doJ74KI8AYWrODrTJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGZcUx3juMI26ASTMGBwAZAIdZ3x2O60GnDs5n25Wb0=;
 b=kXEzwJo7kgwDenW6JDfHk+d42ddrz6J3MI1aPRGetY0TayE1gbLchlvim7r3SI0Pda5OTCkqa8crExkU1HoqtbJfZsPOVzQpjWojqv3CPDYMXLF1mdl9OYhXeDj+J2mVjZgfItkpOr6iHCshOFb2KvDBTgm/DglV7gpwBlnrtWA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH V3 00/11] vhost: multiple worker support
Date:   Fri, 22 Oct 2021 00:18:59 -0500
Message-Id: <20211022051911.108383-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edd252de-0082-4c91-833a-08d9951b8238
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4974131FB68F49E1268F19A3F1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dq90Xe3m7k/P2jbyMVPFfxT0lGb648W2HpFMzSqmGMsKu8Xe9ibSQDbv6P/VEsArcpv+MCGz8k4FyjB0oxJXRH76QjMdP+QOoxYxOyAkOUad8s1iuxeMHrt3GJl9jH7ssJrn3EIUszJp4/EeWCiHXZ+AxsvjxPL7FxMakZwLcC6bYl6oyryIHfZcqbetNh13avQKK5rmb2WmKPp0lRHWfXk4lSUB045sWXMSL7YaL8krqiHolnfQ+ZVlPDvvba1lKSibueTT3pMvXvwe+wbr6oLgzwjc+/au8PBAJfqJUndoNpMCjaqbrE9CVK28q290AAmZVwJRzhdrdA8RspMRlsGYn4A4CeSw7v1S+NMktaXao6B07dvJSdgP+ju2hUyt+kEX1/bB8TgFnTiNalPGUfNOZYFOh9QEgq6QUibQF/OpaZEjo7Dv/DClwc6s1plTCmh4lDtPGLoR67t/XnuJARY/Ivw2gpx02K9kftB8Yj6tVrqHujRcqeTxxfcm/Y9RPwzakZ9qgACljFwB0KkIR4so1rSRLYoOs2TSw0SaD4VSO4b/ctjTf3t+zGH0Ig/V608pcsmByDCKfTmdM97wRTOrlscrAwfP/JhZ8trHqtoMn5jv5kMFg7wRDi2d0wwARaMgf/ebbM0pqsQ08nnRVVCGRoCpAbPlTpecuBB3djLCBsxfiPldScQUVYlxhDM/OGtiFkFmgZecgi/Ou4Vy+lApvKCTKF4wqWOJ4SNaa7eTd51bKQNofk9X4ilhVfrdZhevL9dmYQSktOK7FHC8Aw30FkTJWZnKLuXbVVoRtJ69jGx7r3wAMkLtZUP8Q6+KiMpS78QAbiebsar/UvUy3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38350700002)(66556008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(966005)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PAQyDP2UxShoV0zbiWiJMj2gZmkpMT+9rgpRw5m4wm+As4YG+ClqcXrJ+oOY?=
 =?us-ascii?Q?hqY5PU3RmHD/n8oAT5ZO+V1JwS9CHFrcd9d5pJcKqcUy8IVWY6jjGSnwZCsg?=
 =?us-ascii?Q?RNO83j1cCksAMM6vOAm9e0FR6PcUIgDkZ1o+4tyrvXUxifxh0PEc6ds32Imm?=
 =?us-ascii?Q?DyAFsErpBZvGt94j9yw5A5RuoVJh5uGs2pdv9oNOGl1+jv6EGMKsAqJhziRG?=
 =?us-ascii?Q?NDZU3bAg4PnIFLM7eWThcmrpwJUoy6oke9PEfk7lGdKAT4xEeWh08UOPqtk6?=
 =?us-ascii?Q?1hV6gvz/Ibw7OOewCcAJezAbZ31oDxnXbbPfs+gvhNV2DSgzd0Z6fpMtvirf?=
 =?us-ascii?Q?vYIBntF6avE/Dq2d0x54xb0tqmbaavLmXqSAenLIUUz0BViE+RZCFuXRrssZ?=
 =?us-ascii?Q?MjMyTCr3hBJjkUWKDoqfx6MiAnx1u4ZgIflEhYgisZaKHgnDJHXxbYNO54lo?=
 =?us-ascii?Q?vz123sl0tgQHLnEeOX1Cx5jT58XokL+IM/rmiTAAk1oBSev27NU3RGVw1Hwe?=
 =?us-ascii?Q?GRwqWBZuvtGLw68F8hKs5r8Ek/wPcnrnBJCcwdw4ks19NbhFneviyxVxiL3F?=
 =?us-ascii?Q?7W3fMCK6OQNK6YIyjEYODR46Mk8ggmPonuJsMW9zLtJnXn96nOcb5sTVpuPQ?=
 =?us-ascii?Q?If48bny0UMB7o+KLIjMXnWpc+IfeIuNn6SwBrpH1GQF3pE6RC0zpT4MgCifv?=
 =?us-ascii?Q?NDKnZAnAORAOx8QEoAmznxotgDyCJILUS3jqZakgLzIdzWjXAwDmHbdoX6Zd?=
 =?us-ascii?Q?ohtz7XBMct7XwetpwRO0r8NVYbzrN86jYKnQ6BpqFCuc5Vlu5axwEHO01jYB?=
 =?us-ascii?Q?zinottkvOSzqFp4fxrz9LAbc4+124sEULReFTbfap+0qWgIO4JwPj4Zp3OjI?=
 =?us-ascii?Q?hSXPUoSrGcbh09TPyUlJrx2ii2vTozToWqXcfP/0SX8uinGkNYCluod2i4v2?=
 =?us-ascii?Q?x9YiGVUPhLAKy1sGx4BEJJZp7QU1EH5qjQHLMGsYEDcmejYS0RcLUFT7sj/S?=
 =?us-ascii?Q?8vb+eQqSdrvrJTipBOYEBVwFkcpllZCOX6v3tQlMVejqc92Dn+IGC05lLc5W?=
 =?us-ascii?Q?BPyq+mtu3Nw97yV268QsngyPgE8hq9RwjawyPW81vaCY20ftkkzaBarrnM2D?=
 =?us-ascii?Q?IPjXnohKTHV1tsN1p84gHUa2yAu7s/ciZRTArTqDiIp8YevndZyx6u1q+MaN?=
 =?us-ascii?Q?6fgMoD+CjNiYVSE0FjybY3BwrLOMyFuE3fNUcKUg/ZLk4rFK8Ov9LinTJpgS?=
 =?us-ascii?Q?83fXIB8jGEgUtluRttEAbdkrEGEzLw9TP587r1Cp/6+a1u6twA3l65dD0DTy?=
 =?us-ascii?Q?NnVGrpppfaC8mKM7hvd3pyt8Kg0ESlFZiIkkDhQUnW7Xp+sdaPqYMuVsjBa4?=
 =?us-ascii?Q?8OTL5+yt5TLt1J4+CSTofhClF96+/1mzVPJ1PCh0TmGPTnJj+GKmNemT7qIU?=
 =?us-ascii?Q?d79NUaElUIT/gUWXodxOejIROVJ7lO3c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd252de-0082-4c91-833a-08d9951b8238
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:23.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220028
X-Proofpoint-ORIG-GUID: PqSkwnagatMde_9s86bwJKf4zZTBpAjL
X-Proofpoint-GUID: PqSkwnagatMde_9s86bwJKf4zZTBpAjL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over linus's tree and this patchset

https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/

which allows us to check the vhost owner thread's RLIMITs:

It looks like that patchset has been ok'd by all the major parties
and just needs a small cleanup to apply to Jens and Paul trees, so I
wanted to post my threading patches based over it for review.

The following patches allow us to support multiple vhost workers per
device. I ended up just doing Stefan's original idea where userspace has
the kernel create a worker and we pass back the pid. This has the benefit
over the workqueue and userspace thread approach where we only have
one'ish code path in the kernel during setup to detect old tools. The
main IO paths and device/vq setup/teardown paths all use common code.

I've also included a patch for qemu so you can get an idea of how it
works. If we are ok with the kernel code then I'll break that up into
a patchset and send to qemu-devel for review.

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

V3:
- fully convert vhost code to use vq based APIs instead of leaving it
half per dev and half per vq.
- rebase against kernel worker API.
- Drop delayed worker creation. We always create the default worker at
VHOST_SET_OWNER time. Userspace can create and bind workers after that.

v2:
- change loop that we take a refcount to the worker in
- replaced pid == -1 with define.
- fixed tabbing/spacing coding style issue
- use hash instead of list to lookup workers.
- I dropped the patch that added an ioctl cmd to get a vq's worker's
pid. I saw we might do a generic netlink interface instead.




