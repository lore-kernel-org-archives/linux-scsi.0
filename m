Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3ABC4167D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4EA961051
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhKDTIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24264 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234227AbhKDTH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:07:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IMwHk026082;
        Thu, 4 Nov 2021 19:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ydi6e3nbc7wehSezc9sRB9tCeQ2LzypX4tPr+ry6wl8=;
 b=uQRGRCC0VPvFdhqq4UXhsCdt4ofK5jeuJkBWLXlYjmoONb+BATDmkUMZZeD/oPPBoGbq
 kDGdcOnOJ8FYllp6WfSgJzqZAXmL8PR1YdJaz8UFyTQYHilHCC7EDgHTXevnZFQOvESk
 WEykN6h/sZCSAfTOO9sEFcjxBCPoQaGex964NBx3Xs8bWQssgaF3FyxHfIgW9xWUb8lb
 xu08fEq03fcgTDSDsfAQJZiuaMdJB+YCrjWyOyyw1EC9PxgzECSu0XjvTDg6QcH3eLHK
 0sJmjy50y5fxdcZW7A2uz2KhFTggELRVkoQ3nPmf5yYLt5Sc/2V/pWjsHNGAMek6lc4P EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n9xtfpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J17XX042421;
        Thu, 4 Nov 2021 19:05:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3030.oracle.com with ESMTP id 3c27k94tdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+dFLMlk0xqqElcr8setkKcgJQAXLAoSxrRYxiKHEYe+4EXkD5cfHdO0mI4ZJKa6Y/248wcphQKh3C5vRnvFIkJlo5NgGN/qSFW6YIADUJQA9c561NogBU6JWTROrfTDVd573L5W7ZAgaXqn3mR+e5GX50QKoN5vQwRiNP+CK/LPbHUSY6a1cxtffsTlMZpdgnJX3uZ4ZifjsAuQ2t2cPt+KV+rrogyaoBGx+dRmPVoCYf12Z8FI+amtiouU5gihp3OK+ozNOTHkJ8/CaODb9XcCMsHt0plE/OfuLZp/psKhIiWKevOkmo3WiKxHcS0r7gmut9VtIM2sfP/tB5AMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydi6e3nbc7wehSezc9sRB9tCeQ2LzypX4tPr+ry6wl8=;
 b=CLdXgbRZ/Ab3Mu5KKemdQtElX+VBo3LmppjqUlXG+EceSM1WkeoJmD+Bk3w8STvGCc3ov1WuuREvjTgbtuu0bmr3+ADCxSSMTi3efPDdg/WdBlgl3veqzk5gnkJdBvYqte5yDodvrRFjm76g4PeEa76MnUmWTLBhJR3UqCkyI2YXt/MNVawYKnYsm6AcnFN7yYLe7pt2hmIROaCj73H3R5+QXofs2m3bzxJn6V/CLUdVnq27+CuafJynQJITVrMhyAT0pKYj2XLfZIKRbehWGXZh3L2ACxwOeliAq8zqvcALwPpY5L3887zWbeNC8o3we4EPvMwN9KL7vUEdnF5NKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydi6e3nbc7wehSezc9sRB9tCeQ2LzypX4tPr+ry6wl8=;
 b=tuIsKYcbJUqRx5HYA+yu6B6yozvZhb1eRhPRHqPh3wbwfIa1Ner53x7WRC7SJ0ZkPBScmyTTksVhJyMD6RQGrKG6i6d7GTLhqm3i9sAa0kPRKoe91vooRnZhCIj5d+Ud7mtac3QLBV/F3EqK0bF9SEFvOWI3SWlba8psTjNFIaI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1595.namprd10.prod.outlook.com (2603:10b6:3:13::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 4 Nov 2021 19:05:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH V4 00/12] vhost: multiple worker support 
Date:   Thu,  4 Nov 2021 14:04:50 -0500
Message-Id: <20211104190502.7053-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d0a1e2a-4b48-4ed9-daf6-08d99fc605ae
X-MS-TrafficTypeDiagnostic: DM5PR10MB1595:
X-Microsoft-Antispam-PRVS: <DM5PR10MB15951C2F34AB5E0A80C44EA4F18D9@DM5PR10MB1595.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86JKAzOS6oTZGgBNo5jt+oU1Wk9DTM+NyU7qyCcIislEXE6U/Vap8unk07YbR5Mom+FaL57uROjH20loUaTMH3EyBbPnY90x7NzsUb5ke1uV0z9Z6ituvsu/wBZp9Pdiom8MTluynetTGhhQjscXRavBJ8yfwtMGKVj4GxH/5fYrpONZdhMqhhSQdnqH+7OdWmZymHsJqwkCAVBLIr85qyudc0GI/qaKNmdSOLG0nh4eDeGrK/rqk0B4RTp6UbOZv5Dw07B0b7itva5bDSeQoqspaOdakFd1jiSYcNvK5in3JCVdnDFEewmy3mWhknXZixaj2PvLJ8Gk9vhrzTGXsfsP8KLp6AnD03MQwxeMlRvH7HyTf7J7ufyRR/kCQJVauHpEKJndPiTFa8OIvWrTHEnnqNelES6i5Z8QEV45oDfoOyizBemTQWq3G+vUFMpQ8m5Wkg451wrHPA/aQXS/gY/RTGoCWRJ8B6N5+bFwgXQzvGxF7x+00+DEc0mSz38BRlQ8aiiVQ0YMZzEsYEpg2TOjBcUps2YfAC5aIK5BYlZ5+t2Owb7y1mPgHHOW+bwwpPieO8Wh835UxsrTa3R44VHnjptUCZ9MuaSroE/x4fzMENVyrXxAAgJ5TY419azhfazYfc6HARLA4+9667eRSTD3OubPRwFQlzjiwfCFdkTrTSWv1kmydYJKtQJ7Bo8rMXxfnl1MBgkGLBcu8qPdO5b53XmDQE5dSXYLUg9YxLo1HTDBDlqrsF0w5StQfzM1DIExEC0TAwEGPQXesVCR+1kDHXNn4XKPjbQ20iAqbN1466dPU71J/ILDwkrDn80Y4SGPNb/TQPofgzMX2dniZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(52116002)(5660300002)(36756003)(508600001)(6506007)(66556008)(2906002)(966005)(1076003)(4743002)(66476007)(6666004)(83380400001)(956004)(8936002)(2616005)(186003)(6512007)(38100700002)(26005)(8676002)(86362001)(316002)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tCtaRvVQ/exwOTbjOAvPd7smGFingxFirc0ZtohGlitgVSVDzrCjLM6nevH5?=
 =?us-ascii?Q?QzR+EwnfSzDPb/xE5M5PNtvewfOnCA3Ftel2Q/y2EQmk9sYsL9Pde9vzAQS8?=
 =?us-ascii?Q?acMz4Fwsu7rpxv2TEm9Pj39Aq5p4ZRyLmgr9ron57ypz4T/k/DSGY8gRRumi?=
 =?us-ascii?Q?xmHLTORaHZ6niRAgRPpjjwWqs8jMjpvRk21LqBCV9rk362dXeJrD0SPJd9Ez?=
 =?us-ascii?Q?1+ZQGlWg3eKrgLK3AollI1izdCRKW9Ya0pZbVyUrAT3z2DAvAh642wBsqP/m?=
 =?us-ascii?Q?g/id2G8ctV0a9kEOEoBXWa0/ENY3mAmUXhAtf15pxJAC6wC6lQM7TIjWpQE6?=
 =?us-ascii?Q?24Dyz4Qnj8Vgt/8yBUmwdFIJgkaludXWZ4q1AJv3cU7Oq3vbLnkOH6w+7z6l?=
 =?us-ascii?Q?aYPiYTKTMtwymUXv/t8l8KkpViRmouzfMaj0Z363z3d8NKii72maqJ/h1WTC?=
 =?us-ascii?Q?qhmlFiJWT4V3wJ97auPsoD+t3pO9wWSTBldj8fo1LIwHGOnzWJA7hpaZdscm?=
 =?us-ascii?Q?FkuPnZxnyhU1lIgpC+k8nnsSJUSjHyFtcipVdK2RMIk2oZwR+vAhnPQd/M5w?=
 =?us-ascii?Q?Y4nFIdwyxqWPUl3d3yeMK+1oVEa5Gs5sf4pjCBQgG4A6VcxJcmkDgnbg4z/J?=
 =?us-ascii?Q?MvC5gbtzIr4SvlyqVM2/LhdFLuOhEVPMgVzRxFKlvUl6xLCHTrcSPX1204vv?=
 =?us-ascii?Q?L0OaZLFeblMBvY8Kt0vA/RE38Xa4Kkb1RQPWWEAeshD6y9zsH+5arwIrA0Uq?=
 =?us-ascii?Q?DlGfFZ/CXWzcbQtgDlwIqFPTjQbiByqb2IJcHDaGtjjnvUdA2RqaEyfuF5WY?=
 =?us-ascii?Q?Z3CJ+iZjuXxG54xsUzQr45wJVL3YoLaJ0DDvOmSiZWOgS37aagQEW1qehK7A?=
 =?us-ascii?Q?Mq+uLiDpwjUcbCmexLxxF/zqfxai6axe84hDPBS2fsjYE7z/3Ngm3wwXmT7N?=
 =?us-ascii?Q?rLksXCGwqkn+sIulECDqins+iXjfT1nRCBTABRZnd33ujdO/Q/KPbzoQiy33?=
 =?us-ascii?Q?tJg3cMXLM2YYtfllRAv0wkYagAxE/QzCp6Tr0QWrKiKc+Skr/Zc0B8SE/WYq?=
 =?us-ascii?Q?Kwd8+nByqVKmfigdTBxqqcpkEPcDcEw/bGMtli1Nv98n+BzpK5yph+PnDYvk?=
 =?us-ascii?Q?rwxz2evlvC4kbdK/cv4plyjaU7jDttOvGp3qPP1LcgU8S0AtoLT510NsSmQx?=
 =?us-ascii?Q?hxYJBlP35z1HBZJJU4zvv211P5WePLtvZCVZNjWdKuTqFwJsNPmWihvZm5IK?=
 =?us-ascii?Q?6HoY/peSu56GFB+g8PBLw4T1A9SNIwr6AVYSgN0q0BdXoBKoyDwLH0p9ZjQp?=
 =?us-ascii?Q?KFZIf1NvZ4Mdz2+R8st7/HEPl0RoGG+RQ17tlbS2TadbzydZf4UkDV3itCP5?=
 =?us-ascii?Q?+oO0cQSiGjjRGmJd2lDTyhc4HVH/BIscjipdXMnT3Pe2Rzy/8KQarVHhW31d?=
 =?us-ascii?Q?CFz3Wv1kq9xjTG+FzhU/vsbv0JJwpod2YJqs222b3gP+/KUt2E3sSMVbiEj+?=
 =?us-ascii?Q?qROAq9xEeDWpgf/nHQg/7korsFWGv8Xrh3WnLIOhrJTqEtX8BFQ2ddVIfhfU?=
 =?us-ascii?Q?OCAAK7Ph/bTIBoL6nhp710OBV7zqHoRHrzZ37IRKIccTCRdED8rk2hTEYxoL?=
 =?us-ascii?Q?kqtDNz8crDY32IaaKzhwauEdO0j8Gsk1BKeWh3ctnS1sREf6o8ncWsLIFYn2?=
 =?us-ascii?Q?lgEiMA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0a1e2a-4b48-4ed9-daf6-08d99fc605ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:09.8611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAtBRxDDv8WA7M4OhhdvGuiqY+YRX1FqrUCkgJ+NbOENsZ0sGb7+vFcp2OIAS1eCMmX0O0EJICwrrkmehJ2qz5vI4WYy0Tyd2I2rlyK3FWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1595
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: mq-QW34egCi3VdNCICjI6yD-Oc2L9aVd
X-Proofpoint-GUID: mq-QW34egCi3VdNCICjI6yD-Oc2L9aVd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over linus's tree and this patchset

https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/

which allows us to check the vhost owner thread's RLIMITs.

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

V4:
- fix vhost-sock VSOCK_VQ_RX use.
- name functions called directly by an ioctl cmd's to match the ioctl cmd.
- break up VHOST_SET_VRING_WORKER into a new, free and attach cmd.
- document worker lifetime, and cgroup, namespace, mm, rlimit
inheritance, and make it clear we currently only support sharing within
the device.
- add support to attach workers while IO is running so that config can
be done post setup.
- instead of passing a pid_t of the kernel thread, use a int allocated
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



