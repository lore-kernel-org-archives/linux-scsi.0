Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CEBC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 19:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiLST6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiLST6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 14:58:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E703511C22
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 11:58:37 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJIxEj8014646;
        Mon, 19 Dec 2022 19:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Yhjj95Isgwr7UCIj54jVOBNBT0usumFguDdBaMfPlQM=;
 b=1L4i3PryH7SVXKORJ4Bqf3gcgWNbdwBBJfea21B263PR2M30828Q1oEursG95XMEahqT
 hlqvHEPy/Tx4OpT6MaXBYTmC/ksqFVFiTSIWp78a38jMsDOxi+0bstCblzLBWqYUwhIP
 OEYCC7p2gegxclPMNDgktNXuU8nIbH9ewPl4GyEAFlbWLulVySJ3TLz0zOBpHxm9DO9O
 N2BDHynoTI5jPwwacggPCYCrkCZFM4K42lxoz7gBzJx/RN8l45GYoR15DIgydp5uo1/w
 n5L7guVI4Gcm3qAwtTIpkJZMdJgH1wG7GImPmKc5h0JY1qgph4fqWUFotNOl4qjNSxzT Gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tsuu64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:58:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJJfWkD027610;
        Mon, 19 Dec 2022 19:58:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4740brs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:58:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuzez5ub1mQre/t0yoTSPEnnAl/VdXsWr242jrC+3qPWwoe81Wz/hH6vh2qwzWGUaSZ/qPeBXK6otHAdLa6LmoQ3757+xY7318tSo9Tj9lny2juBcJWq8iERnd3SZVI/TAW8eeiKWrfEWoMvLrSOd3ZnchpyyKLMaYrGMQHZniGhNP9lLhHgt+iWaA327Sty0uJQR1Fb+ZTID/HOzj9jfV+Kj3wuOCpn7/DzkOGnxkF+akVG8eqFZ0rPIqQWIvP+feLtEEYyTOgY2a1nHZNA/oRFfCGsCGWia968TrIIw0X21ZTa8QGsV2ND2p43Ogdzmq9LQUKa5EEAt/wzdb2kfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yhjj95Isgwr7UCIj54jVOBNBT0usumFguDdBaMfPlQM=;
 b=L/VNbe/7TbP74bVnbDM2fMJLhaiPGAMYh7MNIrlvnQbO17tHYJsc9jGVCbZtwI8K9VYm+/CjRxT7QWOT4IbpOryb/MQ8Hp9XSOHQjpEo4XpFaCONArbLvdKV5plHJ6/rMUZSjiCXNHTJrfMi8fdFTQ1ubrPEiPMpFTIS7h92/EHM24NnG+VQ61431jfH2Gb1+J/KoZU0PzO4yY0oIqBMab6hFXNyGnceA1xU+Sx3OHkPeBKN79WZdPVkprMYqaJGMGunud3LBJuhh1r5XUHH8ps45zmv46vSBow5iFLJ18Ex9t+LeZN9tm6c1tMEOBcvoto8afLSN2lGPYcpJMDzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yhjj95Isgwr7UCIj54jVOBNBT0usumFguDdBaMfPlQM=;
 b=mqwanbVOHb4t0uUohvhaWl9gGzrU/tiirGMpe4vgZvwTEqSUCcURb0/G39eYio1dlnZiFGTiwKaCmTjzBbuPNxwrX4MWVzwkb06bXrVetUFtR+9q9kKnBd/Tls2sVuf4G6bpPzNYJTGCKlG4CNZrorBb0JU4vq851AJd3SxKi4o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA1PR10MB6661.namprd10.prod.outlook.com (2603:10b6:806:2b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 19:58:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 19:58:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     dinghui@sangfor.com.cn, haowenchao22@gmail.com, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/2] scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress
Date:   Mon, 19 Dec 2022 13:58:17 -0600
Message-Id: <20221219195818.8509-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221219195818.8509-1-michael.christie@oracle.com>
References: <20221219195818.8509-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0405.namprd03.prod.outlook.com
 (2603:10b6:610:11b::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA1PR10MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 73455d38-fa24-450a-41f8-08dae1fb6218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JkihiBUw/M+CgvEZVHlEcjEO88NSA/Mb6VUu3EMfyWm62Tt1KnJByXGJ+ROmPA4vGRo9PHQrjE3EW4yK6Oa5aydJoOK1s4PrZdaiesxFLkTLRz5FO6aa/HbjqQRL9Kam/NqrJw94LqAkYo1IQVbPM/Ans6FgiCcl+Y1OTbD2tHKnOF8FlVOCtZH386ePqLAKTZz7nMRjtQEDoCfpAtFeQ4RtWAUnnSHKU/VprEPYjZseuDWFruz59NlRCDxRase7eldcuzuqlS3orki4GNbYcwYzQAE87lmsSr+5wCZBHHpeySqHBAel9EzB0Di/IToxTXJnSl4KKzjLmy+A1cZp131VsSQl250xI1/UGmYOq5zrymXn3Z4UAuks41C9D+qNXY7z+G75K3GlYDl/xAmIm0jBgxntbSoFuj16QTNruJTo5xj9t0ycByB5sLVpzdinpdbBDeJWqiVGgItGfSyXBe2GvwPS0ZKolIS9uurIGWZKTs9etjQM57BZLZn9D9VnqXQQd5imy8/BRyvlLBZYSPb8ciuMcX1DT5ukOb6znwI/2+WzQ8AbGkmQArEeiGJmb4Aw/jZ7kHlFTL2i2W0WL35B1MPJWe3mK7oqs86PhQXBX7GsXhkBW3xW3I/JFn22zZrREqzYDG28u2DfjRzlxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(36756003)(8676002)(6512007)(26005)(4326008)(186003)(66946007)(66476007)(2616005)(41300700001)(478600001)(1076003)(2906002)(86362001)(5660300002)(8936002)(6486002)(83380400001)(66556008)(6666004)(107886003)(316002)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/GYRtpOMDXci+hGFTkVM0Z5aDKUW/zEFJwIZwgJk68T5aJ1rt8M+VNb4d8M?=
 =?us-ascii?Q?W+BiGNp8FuHCBOEyY3US3waeCuNwPCnUFgBRXxOThMDEGzm/2G6sZ+OYrC5/?=
 =?us-ascii?Q?StHmE258nYNnm1OpxfGaB0w5MVbfHpT+tJB8n1Bmi+owuGcj0cP54CPiZXs1?=
 =?us-ascii?Q?TW16edaTWTFmYm0hmF1Dk4fmBO/X0ZXcv07xwUe3eo1nR3a/Q4+QYkopgBQM?=
 =?us-ascii?Q?YaWouX7x5gVCXNcvveGMoSt8L7jqr9VHqPfMrempKcUkB4U3Fm+z9JSemap6?=
 =?us-ascii?Q?p77yb7bo+n5gD0VuOzmHMnqeKvB783uRWoRHVA0mMn6gFykEeL1F8PRyF96e?=
 =?us-ascii?Q?1ZWNUxcsxmdf1iufBd7dpGuP/+CNUrF0zTp5Wsu2B2uxqb5Wa3PdYSOUce86?=
 =?us-ascii?Q?gqH5gO0qfY0Wo+VJ1GFvRn6hKChlVt+z+krfHr34xnYPLRPJRMShzvfOg00U?=
 =?us-ascii?Q?aITGnN7zoM8F9R6av+xD6E42vogAKUKeSvLq2OO5GprDdBbbCKEzEA+7bBef?=
 =?us-ascii?Q?yJM+m/E0iNrA1pqxyRFCBXrMfo6ohgAMRSRRBxU68nDlTnSBl46cmdfNBAYl?=
 =?us-ascii?Q?Tvb47yOX/nz/JpIr6J014Pzjoh6N8iU1GjhQc02M1OwuDVBed30OGpmUuDUQ?=
 =?us-ascii?Q?rH71Rw5PWyPRu6biszFqn8i2CGPwM81OFmBnNOocnGbrdk9SBcnmSqZiReUu?=
 =?us-ascii?Q?a155N6esnPPHrudOGPbpGRBGLhS5Tol5BKXO6GvULNHfN4eU3xjDcyh6o9sC?=
 =?us-ascii?Q?oJ7Oea9wl8QfpGXoEsAx1l9+ZvEQBbiqHy46zNyXVhaehqByCc561Ieag8fz?=
 =?us-ascii?Q?rNbqgTNNQQW7QwWFDshlT1gYd3sCNtW1X8YHCcacgIqTdeJVTadoQkm+zAww?=
 =?us-ascii?Q?CJxpVKbjY5GkIu9JaSJSwVrIy6X5Wbsv8TgfhKfM6YCThrmgQQIijjoLur4X?=
 =?us-ascii?Q?SVExnNH6da4T/gqHibhZoP7Iguj34qiSGM5EeJfCyJXRW8h08n9mNLUieV52?=
 =?us-ascii?Q?cQgV2jzhav5cGxsIT45uuJOJdMcElys3E97DOf1bu1GWWJNsmjJWpADG7X5s?=
 =?us-ascii?Q?3JwyPCySI5W5IsgDTLunSw+JafoB28FkCgsmB+Kmzkr1kNpUEoqL7YaPNja0?=
 =?us-ascii?Q?JQDheDDH+48b8NoMXBcLuNJo9M/mpP3KVmGfQWbjg262nAkOiQnCmNP8Xacp?=
 =?us-ascii?Q?2dA//f4bcxtQg7XKMDpWM9lhT7lDTwe5uie5W2i2mBGczE7E8hvoK38KNy8T?=
 =?us-ascii?Q?2TRXfOoeFolt71T4JMoNYqapkGN70W3TT+BEkF/9qamdLbDTCisjpF4NeULS?=
 =?us-ascii?Q?ep3SB5c4xQTZmGvEOoLhp9YoUmA1Ak+Rpy0a4C7dYLT7Kp1pwQrAwVl8V5bj?=
 =?us-ascii?Q?bKwftKZOxK+9/Dd8iK01ELY9UmJETSAYWLU2x2S6tMXaPL/eF0fTVMk7YGiY?=
 =?us-ascii?Q?BqHcYCnfxAtSlgLCVvgYx7gNUw+FwJD5CxLaRHBwLqoStCsHFxqof/RuUCeS?=
 =?us-ascii?Q?yVdTpywk6z8A0RAdnTXhvYWBvxPNdXu2nkGqoE/Qua/QudVilhHrNF8ag0/j?=
 =?us-ascii?Q?XCenupNyNadbLWO/+PfZiOny4Tnbddxs9vn+L/fTzo+vn2OBvXUmDiNfE5Dt?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73455d38-fa24-450a-41f8-08dae1fb6218
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 19:58:22.6706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Mj0r5rJPfOM1eDn9N7KPxU+cdrEVxr0FtF3OFxfGI25mvK6NYso1zRxToScZ9+mZ/ZlwhsbCRUb6aYwTUNmB132URT4k/h/O64WbscUwf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190177
X-Proofpoint-ORIG-GUID: HduKZMd3zkP6B5m3TNpRFCc0q_qli5MA
X-Proofpoint-GUID: HduKZMd3zkP6B5m3TNpRFCc0q_qli5MA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bug report and analysis from Ding Hui.

During iscsi session logout, if another task accesses the shost ipaddress
attr, we can get a KASAN UAF report like this:

[  276.942144] BUG: KASAN: use-after-free in _raw_spin_lock_bh+0x78/0xe0
[  276.942535] Write of size 4 at addr ffff8881053b45b8 by task cat/4088
[  276.943511] CPU: 2 PID: 4088 Comm: cat Tainted: G            E      6.1.0-rc8+ #3
[  276.943997] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[  276.944470] Call Trace:
[  276.944943]  <TASK>
[  276.945397]  dump_stack_lvl+0x34/0x48
[  276.945887]  print_address_description.constprop.0+0x86/0x1e7
[  276.946421]  print_report+0x36/0x4f
[  276.947358]  kasan_report+0xad/0x130
[  276.948234]  kasan_check_range+0x35/0x1c0
[  276.948674]  _raw_spin_lock_bh+0x78/0xe0
[  276.949989]  iscsi_sw_tcp_host_get_param+0xad/0x2e0 [iscsi_tcp]
[  276.951765]  show_host_param_ISCSI_HOST_PARAM_IPADDRESS+0xe9/0x130 [scsi_transport_iscsi]
[  276.952185]  dev_attr_show+0x3f/0x80
[  276.953005]  sysfs_kf_seq_show+0x1fb/0x3e0
[  276.953401]  seq_read_iter+0x402/0x1020
[  276.954260]  vfs_read+0x532/0x7b0
[  276.955113]  ksys_read+0xed/0x1c0
[  276.955952]  do_syscall_64+0x38/0x90
[  276.956347]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  276.956769] RIP: 0033:0x7f5d3a679222
[  276.957161] Code: c0 e9 b2 fe ff ff 50 48 8d 3d 32 c0 0b 00 e8 a5 fe 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[  276.958009] RSP: 002b:00007ffc864d16a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  276.958431] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f5d3a679222
[  276.958857] RDX: 0000000000020000 RSI: 00007f5d3a4fe000 RDI: 0000000000000003
[  276.959281] RBP: 00007f5d3a4fe000 R08: 00000000ffffffff R09: 0000000000000000
[  276.959682] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000020000
[  276.960126] R13: 0000000000000003 R14: 0000000000000000 R15: 0000557a26dada58
[  276.960536]  </TASK>
[  276.961357] Allocated by task 2209:
[  276.961756]  kasan_save_stack+0x1e/0x40
[  276.962170]  kasan_set_track+0x21/0x30
[  276.962557]  __kasan_kmalloc+0x7e/0x90
[  276.962923]  __kmalloc+0x5b/0x140
[  276.963308]  iscsi_alloc_session+0x28/0x840 [scsi_transport_iscsi]
[  276.963712]  iscsi_session_setup+0xda/0xba0 [libiscsi]
[  276.964078]  iscsi_sw_tcp_session_create+0x1fd/0x330 [iscsi_tcp]
[  276.964431]  iscsi_if_create_session.isra.0+0x50/0x260 [scsi_transport_iscsi]
[  276.964793]  iscsi_if_recv_msg+0xc5a/0x2660 [scsi_transport_iscsi]
[  276.965153]  iscsi_if_rx+0x198/0x4b0 [scsi_transport_iscsi]
[  276.965546]  netlink_unicast+0x4d5/0x7b0
[  276.965905]  netlink_sendmsg+0x78d/0xc30
[  276.966236]  sock_sendmsg+0xe5/0x120
[  276.966576]  ____sys_sendmsg+0x5fe/0x860
[  276.966923]  ___sys_sendmsg+0xe0/0x170
[  276.967300]  __sys_sendmsg+0xc8/0x170
[  276.967666]  do_syscall_64+0x38/0x90
[  276.968028]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  276.968773] Freed by task 2209:
[  276.969111]  kasan_save_stack+0x1e/0x40
[  276.969449]  kasan_set_track+0x21/0x30
[  276.969789]  kasan_save_free_info+0x2a/0x50
[  276.970146]  __kasan_slab_free+0x106/0x190
[  276.970470]  __kmem_cache_free+0x133/0x270
[  276.970816]  device_release+0x98/0x210
[  276.971145]  kobject_cleanup+0x101/0x360
[  276.971462]  iscsi_session_teardown+0x3fb/0x530 [libiscsi]
[  276.971775]  iscsi_sw_tcp_session_destroy+0xd8/0x130 [iscsi_tcp]
[  276.972143]  iscsi_if_recv_msg+0x1bf1/0x2660 [scsi_transport_iscsi]
[  276.972485]  iscsi_if_rx+0x198/0x4b0 [scsi_transport_iscsi]
[  276.972808]  netlink_unicast+0x4d5/0x7b0
[  276.973201]  netlink_sendmsg+0x78d/0xc30
[  276.973544]  sock_sendmsg+0xe5/0x120
[  276.973864]  ____sys_sendmsg+0x5fe/0x860
[  276.974248]  ___sys_sendmsg+0xe0/0x170
[  276.974583]  __sys_sendmsg+0xc8/0x170
[  276.974891]  do_syscall_64+0x38/0x90
[  276.975216]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

We can easily reproduce by two tasks:
1. while :; do iscsiadm -m node --login; iscsiadm -m node --logout; done
2. while :; do cat \
/sys/devices/platform/host*/iscsi_host/host*/ipaddress;

            iscsid              |        cat
--------------------------------+---------------------------------------
|- iscsi_sw_tcp_session_destroy |
  |- iscsi_session_teardown     |
    |- device_release           |
      |- iscsi_session_release  ||- dev_attr_show
        |- kfree                |  |- show_host_param_
                                |             ISCSI_HOST_PARAM_IPADDRESS
                                |    |- iscsi_sw_tcp_host_get_param
                                |      |- r/w tcp_sw_host->session (UAF)
  |- iscsi_host_remove          |
  |- iscsi_host_free            |

This patch fixes the above bug by splitting the session removal into 2
parts:
1. removal from iSCSI class which includes sysfs and removal from host
tracking.
2. freeing of session.

During iscsi_tcp host and session removal we can remove the session from
sysfs then remove the host from sysfs. At this point we know userspace is
not accessing the kernel via sysfs so we can free the session and host.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 11 +++++++++--
 drivers/scsi/libiscsi.c  | 38 +++++++++++++++++++++++++++++++-------
 include/scsi/libiscsi.h  |  2 ++
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5fb1f364e815..9c0c8f34ef67 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -982,10 +982,17 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
+	iscsi_session_remove(cls_session);
+	/*
+	 * Our get_host_param needs to access the session, so remove the
+	 * host from sysfs before freeing the session to make sure userspace
+	 * is no longer accessing the callout.
+	 */
+	iscsi_host_remove(shost, false);
+
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
-	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost, false);
+	iscsi_session_free(cls_session);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d95f4bcdeb2e..6e811d753cb1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3104,17 +3104,32 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
 
-/**
- * iscsi_session_teardown - destroy session, host, and cls_session
- * @cls_session: iscsi session
+/*
+ * issi_session_remove - Remove session from iSCSI class.
  */
-void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+void iscsi_session_remove(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
-	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
 	iscsi_remove_session(cls_session);
+	/*
+	 * host removal only has to wait for its children to be removed from
+	 * sysfs, and iscsi_tcp needs to do iscsi_host_remove before freeing
+	 * the session, so drop the session count here.
+	 */
+	iscsi_host_dec_session_cnt(shost);
+}
+EXPORT_SYMBOL_GPL(iscsi_session_remove);
+
+/**
+ * iscsi_session_free - Free iscsi session and it's resources
+ * @cls_session: iscsi session
+ */
+void iscsi_session_free(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct module *owner = cls_session->transport->owner;
 
 	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
@@ -3132,10 +3147,19 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->discovery_parent_type);
 
 	iscsi_free_session(cls_session);
-
-	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
+EXPORT_SYMBOL_GPL(iscsi_session_free);
+
+/**
+ * iscsi_session_teardown - destroy session and cls_session
+ * @cls_session: iscsi session
+ */
+void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_remove(cls_session);
+	iscsi_session_free(cls_session);
+}
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 654cc3918c94..7523b6abd8e2 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -422,6 +422,8 @@ extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
 		    uint16_t, int, int, uint32_t, unsigned int);
+void iscsi_session_remove(struct iscsi_cls_session *cls_session);
+void iscsi_session_free(struct iscsi_cls_session *cls_session);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
-- 
2.25.1

