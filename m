Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B542DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 21:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiKOV2v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiKOV2s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 16:28:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D123B117F;
        Tue, 15 Nov 2022 13:28:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFJJqke003865;
        Tue, 15 Nov 2022 21:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7Hg/yN+X096aDjv8xdndTj3B+mW/nmVz9Eo+hoRBoUE=;
 b=XEVol5umqV6NudEmHH2UOfIc7sw/Msga95Ya8E6n/neCw1ANdysxVz7mJa48efeVb8ud
 Lrx68mYACOqaCpOtWPEoPP3RAi8vOi3quo3R38QQ8QHeqKAhWkVEst/0tio5kiNiDl5B
 DGPHlFpnCs/l1ae68Pi13Jw+4KMw3iwgzdYy2kezoPG+VEyH2Rl6Ux2rAet3ROWcmzSA
 o5joQ0BsSXzHp4XKOKu6duZlMR99S3oLwpJdxlTfVIULSu/9INnvfjLN+2D9OtSv3Xta
 WpcfpngQ7gSFM04f1+IM0FdjI1ZV1qCjPjGzFjx74MNIYQozz/AtN30f7oXJ7vxxHUwr fQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3n132gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFK5VVx004724;
        Tue, 15 Nov 2022 21:28:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3k78736-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnKDxNKJpRQO4zKMN7yu8UYoSPZO/CEG2uzC3NHvvEzskQPB3EoreC2X2Oqgir8IHjlLI4w8ARn3OsG5/JAe7cSyLGBXEzimRQHUpwm/tpGLpvZGB6uIgw+GSfc26Ey2RzyjlZc1ddV5U6oeVtphBaoezV4Q+hEOCrMIQwNXiK/ZnZKOdPZRJ7mDCZNmJtY1k6KtDKZyMB+BQkRvL8inx8WYyrciMKEVI1hXfF9MA72Wt7GEbehpxHl8vCAFUnh4JiL+Zg4ubMdeYSgUp8ciJqljjCfQC7YeWEds1zsPYQjmz0mGR8vf9bmpXGKBCor7uyqPxWnDvA2JzzHykPM/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Hg/yN+X096aDjv8xdndTj3B+mW/nmVz9Eo+hoRBoUE=;
 b=TFCTHv60PHxkckOwcK32XmaeB4jSjYao8uKPRs/sP+L176oiSVVynIrMFacJul+EhaBJBv16Seg9UgzJ+/eOr3XD5Deq6GKCygSb+rDBI98BowWiREypvqQsOCupblzeEArfu6qf2qD6xOPat7/bIs2QSgqg1OV863qHj4eZL4e05y9NANzCxjsFTN5ObdCxb/lu/yNQfc2n8IJJ8Pqrgk5TmwGGWs8lebAXnI38kMKSkXWQI1Wf5eb7nd47r8NUgVcOVxPVJXl1wMEYWzsVwRZ0POo2XzNTVgai2lut5cfhsfRLkKMVlKHIA/ZL/kV+PPJW3wqyHgcvaaAxB4W51Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Hg/yN+X096aDjv8xdndTj3B+mW/nmVz9Eo+hoRBoUE=;
 b=rQ2dT8IbQmNb9z+RLfU/CwU1moahiLTzCD/kgC9gjy7MBm9pArIsB5eTv/w828Vh/IpLOvcPID5I+5hr9b3sPLnRQXIkpL1YC1PF+zgVA44vPk8cptDrCuabJ4wuo+r85eivVnB5KrBOROmFYCOmLBYCMJXElz+PZ9DlS8syWWw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5368.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 21:28:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 21:28:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/4] scsi: Rename status_byte to sg_status_byte
Date:   Tue, 15 Nov 2022 15:28:23 -0600
Message-Id: <20221115212825.7945-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115212825.7945-1-michael.christie@oracle.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:610:59::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: b5478438-8dac-4ced-418b-08dac75057a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zA2qkpC1cqt6z7avdKiqAeEcCQ2j01q4GdecGYGqTkeXPBiPSkGmXzLnXuZupRRsA0Ijp0jL35ofe95jldD+ID1B/nsUOkN706TY3bHgg0K2eNfRB0hi2Obi0ksLRjxgWuSJm9Yfn9eIXkcUrSRMbpkVIr/T3eXTxyrya+R4yXLiS2QmxAGKW6c0hfxIgjNpPEIQqPdc7uEGuOAoMTfP80Bql1TgPZu8vKzZ72CJm5zJ1QhCWQBxNRYOSlZr7yeuGEw/n+0sc2tAO4gsiEKQfatf34OlQG+KpG3GYidjgSNuOdXmvMZaYRu6TPitdoFu4i8/ndQaaITneqU6G7YJ6wYjKaLVy3uaxKpWCeZhht0LcH/C+xC7pdF5ev174O7Gx4v24sncVZPYjxoSYNbPbblQl0IgOy1vCBqJvEhlBvVPOSO9CXppQK4f4tBFgr61Oin0K+aurrY1Z5A587UiBXst67xBdbu9BFP3Nmjc0juPtg5UpV3qwuADa9tx43v4VFB50tfqE+0AHZTgqXALa1DfXTNJZyql5Kalg7WzhHE54ZzrIHC1RjUyrMNVJLEPZmCzf5tkrZ6vLlUzR16apRW3fyBnhppgKnKG3GDtCKB8fR24E9iQxHZck9qc7aXedVkVVHZSMQithg0Epm9eQeOZ7NVAEdAaEwCsBB5vb7his6+r7H8/eQSUfXsygnMxLfbXtF04XcfBLpjlTdkReQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(1076003)(36756003)(83380400001)(6486002)(478600001)(6512007)(6666004)(2616005)(107886003)(6506007)(86362001)(26005)(186003)(38100700002)(8936002)(41300700001)(2906002)(5660300002)(316002)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vUpUvchc5QEbYMhC1p3at4DFjaYaDJ99VwgmDWeA84YxzVyCTzVzNHckTl5L?=
 =?us-ascii?Q?SYPDk1Xtr30LD0D7dx9u5MFIt4hvcz0FP/jo6JnrMLo2F7wCV4J4Y/hashi7?=
 =?us-ascii?Q?opGYitz5cAQIvGSRxOxj84O6Q8RChWkE6c9Mhj4qEwX5kSnqu3lxGJBs6c8R?=
 =?us-ascii?Q?g+ZP5cg/eCecfEQVfkajeKwJDTIIyn6Oo7xHT5tLrJf9vifjXPMn/ULvnTha?=
 =?us-ascii?Q?pf3d1zbim2R1rZ8zF5ReyE/wdUyZueJlPJwCqI8c7VptRfoQO1hBHUBAfEyj?=
 =?us-ascii?Q?bjllpSB7ts5StCjJ4gXdmKhfna3v2SQLsjR9m13QzmISvybONOT+vLh7rJ8Z?=
 =?us-ascii?Q?AHvxOviwGk4ogtPPA7wHm88OTupJZoa0xLej+f7rVU3/0z1Yp/u8im5z8AYH?=
 =?us-ascii?Q?WD1T1RC9m1BgLiEjKLh9TdAbvZrYFi0/1D0KYJGpB4hAtqXmSXnP96CC9CtR?=
 =?us-ascii?Q?3/PQ8cY1M7M2O/yuPBGMfBmNDf2XDCFjFLQwkC04HmXkpcy8e/pOmOI5EetT?=
 =?us-ascii?Q?UgcwoUgqRlddDt9gbvLHjRRJ4EP9HZnyIHBr3sNu9rAlJ/yMwsrzBIjZh3dt?=
 =?us-ascii?Q?YiIj4hBatcqHdf0qRc4E/knPOEXCAKZ4YZ9dOiaFcK2Fu7ZMmtCAGAUx+pAS?=
 =?us-ascii?Q?8Vsci0Im9y4l2p59jUs7E+jujTG5/T0VGqQPx0KI0VPZy25ZzG7ljv1Epj+5?=
 =?us-ascii?Q?nCzWvKuWxLyIRwLPAgAKDV56vI3w3vtFkZnKHpqNgycDm92WRjVXFfjHFa44?=
 =?us-ascii?Q?nyD/rJOMTt1GBKg3h7tbu7Ue0EV22ryQcc2xeuvIU0JwB4LTgO6eT5dQUVNS?=
 =?us-ascii?Q?kHvb0XiGhltgiy6tVXHyyq9lLW7iFsYomeFTGdq0o0MqljXcsqyGc6K3gcGf?=
 =?us-ascii?Q?kdGuyH3VGB+YA8Zniwvk/1ZqtKacYEHSi/HgPWp549qbY2TEm9Ooz/UIHO90?=
 =?us-ascii?Q?5mWiAhkOxK4YmJz5I/ojxWBS9kkbVjZZF+DgJ9Lk1LUq4i398Ci5fg1zG7s8?=
 =?us-ascii?Q?Ij1uaa1jtseL7IziqWendMyxXw7HgopZ1iGBzjyNmGRzs7YUGNX6qCpQ+NbE?=
 =?us-ascii?Q?TDk+P4sdTcDT6pScMxu9QAKFiaU+q5T+P9hg8ptKcTIYxQbwA/lMFFHs50XE?=
 =?us-ascii?Q?PaAi9WMt6vLRnDC9WSSjUKtPG4D8sIeh5P0A+BxvzTHdKA5OY5yJwNcAjGjv?=
 =?us-ascii?Q?MHAtJapXxcAMP74GsAqzxkZ641DY69tSPI3BYaIb4vtYLABteQhQmlSRBZ5a?=
 =?us-ascii?Q?zmwqyw2nI1DK6Y7sjsWNHmrmnVTzYB9mBKu2rSCVsuw4vdNzzCpWTzKf6IQb?=
 =?us-ascii?Q?MwmXhn/flMM3CfbpGIg81COhU9qJ6DbifDh7Yy306VjeCP5f25hKy094S+xU?=
 =?us-ascii?Q?KD6sv9prAmjkIy6UFG+JIsVVoM7bO9mi8dfsboHtFcBMZb9tsArhfNrBYnw2?=
 =?us-ascii?Q?2H+9fqO1PlTSOaooq/47lOIY4um/DL3QkEs+yKL/G6ZFOLhtQ16YiCa/uUYa?=
 =?us-ascii?Q?XSI/x2RYo5Oz7k8YpPTKHX2C35dsXia/Imi1DoTLKLfUmXpIK1vmrpgSZKLO?=
 =?us-ascii?Q?AZdlwwj78BzZiGPnuCBdaQOsncBIb3mpMYBYuzR/UtS7yC+V2CAOfzCz8Raz?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pMvDL9F66T1fOVs2PqcHkBc8YN8O6V/eRtqSenMt/1AaU2QUfwVcsqEDIOxB?=
 =?us-ascii?Q?7iKQDFfbJXdpSJV4QTD6BkM/YmW3xWFm5bcYVA4hZIFGJpZ0t53gkeYPiOM1?=
 =?us-ascii?Q?uDKb3IwrDaGIEIR6YY0WeyMHnbOf6cT2yUD3vL/kIh8RrBGfEoLHd2jhIR4E?=
 =?us-ascii?Q?7pC0KihGK1C9QXIMhYpYiSuFVLW4nxtD3WIXJ/CAlXSrkUWrNvUg6/F6ZKP9?=
 =?us-ascii?Q?EFg7SqRyosqdsYR0ZuBmV6mUfLNNYBZYlYeHU5xN1O9YbWVFQTMTw95STrA7?=
 =?us-ascii?Q?e6AlZA6nD1dLAhlq9eEwsJLXi2h6obZteBkM1y+FFjoG9WRsh+T1erVoXzzX?=
 =?us-ascii?Q?5HXSogTd4dfCUCN+aoGs3JzTLq7X7ZgqAYpeTOJKl9TEBTnN5D6MxZDt85v0?=
 =?us-ascii?Q?iZUWeIYeF7E3jYZIv8pI7e4+2KXqFoxQRHW8DlB/+Pj3Nkee3+FRAyB1wdGR?=
 =?us-ascii?Q?3Q6OnqwlQ2/zOFhZNmtZmwVKXFVizkq1qDtONpy6q+b3ZmjjVVDnLShQM+5F?=
 =?us-ascii?Q?NPrd5tf/JpDip6EB/H+mdULN37q8ywAzFKGOlQ9Ie81HbqF4ITcMpA6UjMLA?=
 =?us-ascii?Q?STtWwFEPt2LrzM5sbxN/6dQAWOjuzsOtqfT30oK8x97flYRxfZhoDUYjZqZw?=
 =?us-ascii?Q?+BRxM9+QGZZvN8egKz00PVRSc0S/5+qBLbTg8IX0e7gNDSFCWb5ODu9Rp4tk?=
 =?us-ascii?Q?OR6mW4YbbMUk7d8ijRizCyqb/yaUUY7a4X5jrGDLDyIzfwXAt5cSuJ63GPqb?=
 =?us-ascii?Q?UjMnMI3oBF7Q3Cgu3TtPe6faubLqXpRex6Y1xW1GX9xlEKy63cfObE2621uA?=
 =?us-ascii?Q?f2WcgEi1w2kcI6vLKkE3OGeNCfdriyicQJQmPwgySlGnGP3z5RpI6L7MhSTb?=
 =?us-ascii?Q?oxG143JXsD3ptuszY/jEkZSslpDcvyyQCLvEE3y3Bcdic15FXClUfnZYpFoh?=
 =?us-ascii?Q?pO+3bRe0kQfSK5Pp0RnqurSd7MGVKqc2aefhgfr9SXMlQC50Flc4RMwA3kT6?=
 =?us-ascii?Q?lWPQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5478438-8dac-4ced-418b-08dac75057a1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 21:28:30.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gf8t4TEGU9gUmwDpTh71C9AMxD0j+gnPJ4aCxf8/Wz2wR6yt61A7/7YiQ/zOeKcAtU/IysrXMAR3K2LBO/dghn5sKoNvaoRg8I7Ppkz2WLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211150146
X-Proofpoint-GUID: hjMKoH44cwai2nW40re-UU50g2dOxsH5
X-Proofpoint-ORIG-GUID: hjMKoH44cwai2nW40re-UU50g2dOxsH5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch adds a helper status_byte function that works like
host_byte, so this patch renames the old status_byte to sg_status_byte
since it's only used for SG IO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_ioctl.c | 2 +-
 drivers/scsi/sg.c         | 2 +-
 include/scsi/sg.h         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2d20da55fb64..8baff7edf7c3 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -376,7 +376,7 @@ static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	 * fill in all the output members
 	 */
 	hdr->status = scmd->result & 0xff;
-	hdr->masked_status = status_byte(scmd->result);
+	hdr->masked_status = sg_status_byte(scmd->result);
 	hdr->msg_status = COMMAND_COMPLETE;
 	hdr->host_status = host_byte(scmd->result);
 	hdr->driver_status = 0;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ce34a8ad53b4..d61d8d0d1658 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1349,7 +1349,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		struct scsi_sense_hdr sshdr;
 
 		srp->header.status = 0xff & result;
-		srp->header.masked_status = status_byte(result);
+		srp->header.masked_status = sg_status_byte(result);
 		srp->header.msg_status = COMMAND_COMPLETE;
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 068e35d36557..af31cecd9012 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -159,7 +159,7 @@ struct compat_sg_io_hdr {
 #define TASK_ABORTED         0x20
 
 /* Obsolete status_byte() declaration */
-#define status_byte(result) (((result) >> 1) & 0x7f)
+#define sg_status_byte(result) (((result) >> 1) & 0x7f)
 
 typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
     int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */
-- 
2.25.1

