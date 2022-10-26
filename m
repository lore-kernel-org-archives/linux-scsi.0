Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7695DFA3744
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiJZXW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiJZXWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:22:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F151A0317;
        Wed, 26 Oct 2022 16:20:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMJdIG028928;
        Wed, 26 Oct 2022 23:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=q+9wqBdGxgaD5CMqwXkvvDKmHkEroONQuCsOPCDLT8o=;
 b=iV9ThC21/Fi9fYMfT2wf3b1tbtzpn1O/h4+vF1+3Jm2IPXUqk8aUDkwol9mzIPThWR/V
 dyFqAWoh/bnjB4v6bQ3XfgAUD3CqytjiIe9fO8k1pbdzjF/hP1fJRAR8ouaGOjtvIghM
 AFe0yLn7Qs649uF1Xfp29DxGiqewdmuEBaGBsMlmXHV+FK6SyNNrHKBpQrSe+og3hdxH
 BvIfLqE2KWMnAjQ2MjYcSE31LRFzyxUh/as6OTn/bLKBl55L+9T2ps96VYOF6YRfpKk9
 si3uHdBVuXp/AoyekLBNM4RwlXc8F8xyhqtKFwN+WjiOZpzVuj0lPObhS9e30MwDitYR Ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfawrrhf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLxxOH026441;
        Wed, 26 Oct 2022 23:19:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagpdx16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHG6zgQGSSFv7VS+vBjH8ufFSCAOxamtpf7O0/jgf+svihoH6PcXDKurPWzcX1m8+4Jik0T+ncoP7mkUEsgq6AU92CImE0sUnHPcaQkgebxnfC57ZNPHB6vtD+UEqx59YwtGF1psAC/WJOnB++j4iAQcgUz3H2l31bZwG7XCoOLbC7CXh+tbpitaIbbErFicADbo2qYvXuSNoFh3B+C6ppF5j58/LxX4dai1CKyzCu6AbRIGeoV/7prLQyFMIhIYMf9n021B6FQtJaCSJdkUR7F71Sb9knbb47qGiWotEeXNt0uIJTfIJx3ExQPf3+8xgmCnuke92u1rk18arS1Q7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+9wqBdGxgaD5CMqwXkvvDKmHkEroONQuCsOPCDLT8o=;
 b=UdE5umeD7H6v2tF+yPGkIYBb4svz8ofSWN6ywBldv+NGGcYeNpQhW/s7AnFvFU2ZtOzQjAMDRtgbNd3sAuVt1zbgg9UY9qco0kZRuixS/xsXVUgY0KCH0VCANFpN1on5cEq0nX2aPwAgalZoWVuAUv8ie2fTThNoLus48vY/1mLtadmc+KpwNotHJ2bn+XgK/54ZKECyszYeyQWwFO69m3MhdGWOJAwCc73MWizpNlV82pqx0NdbaQ/qe/uNgSUEdD69x0pzYgkGtoiNrcgriI5aDBx0kGY7Cp1MgLu4acLC9WSdfKJbqLlpXUMH7J1TA4DI3YpTisuVosPYTgLxvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+9wqBdGxgaD5CMqwXkvvDKmHkEroONQuCsOPCDLT8o=;
 b=GW5IGWIUSTAqKtO9s20BiBA7Zpbrv2TiBccC6VZpFPXWHqOA+xVhAYSiAym4Pxtxaljkr2neCrBzYn/ljVZgWupS5C7y/oZCBi9oiM0DC0ipZDaq7TU4bOnx6Zo+ju/SPfDYUZ1xNxxFu+f/WIttQIkZ7d/j0ChpbBKXJB79MPI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 02/19] scsi: Rename sd_pr_command
Date:   Wed, 26 Oct 2022 18:19:28 -0500
Message-Id: <20221026231945.6609-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:610:74::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 250e0cdd-9c0b-4149-607f-08dab7a895b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pp78yo6fx9s+NNg24RGC183uPfEh59/ikDjHXAPsJdzWbQScH2DDQ3eVbfUDhFl3ELiFvVCTRLw9yiQ70REAtTz6wWUqhBveyPRmij8f97ntyKB4Sk0ghPbFHXf4+MJwr/Y1K/FHzOuhqxNPruRrEp4ref/I7mnM9/jBw9rmGMoHQwYqvQDzZCdeKR76B9s8oD+nEygtZZRnjA8FZkRTrc4+moCGHS4rF9dp0oaxe+eOl5K0JBxhTeIfJLx5kT97Drgf4PNaNb7KdqPUhNlYpnymlLvKdknSETf6d3IRMmfkhvUHQ3KxeO568TJ/ciDRtnPRxxHN9Y4Zosl8RPjIkFGAkIuhdITxagCNnT+yHkXXqtGm4/a2tDqmls+7WThRgSiyxjOmEX3kZCV/ZcHfcMt4uf9ySg0tMfCxseLmEFLdDm0J9gOnOqOI7oelNs/2O/E4xXWW7g1RVb3iIvx3lX4Wmqpat3D/5KqRwcKgBJmfA623Cg+RxCNakdcqZPWnNmKEAAlPMwefm429tgUm1IQMJPO4zk6hExBM10yx8sj80JgkEVWR7ilXdqclW4lBmWKuUfpJyVf5b+pqevA2X7XbPbNhXHmTef/9cCX68vEIYf35c3KKo2JSlHU1AyJBRNDy6ZJNpni1LrFxuUti2GF+w3yQVTSG8RT9LCLuEt3To5StV3+iqof7HOCgXjJLhdcBSPN/dg/YvLVLCAbccFnlTeDp9k8BbzHD2kxRdbqdk1K9tVrR/d8hGHnqPzZY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jCyh/avGx+ILouEWxWVobd8kLKcgyL/bFfROdxI1Rgfol8SxDl+Vkrs8O3QY?=
 =?us-ascii?Q?9/YtcmS77SLazWBM1wmkDNsFbKHPcaXH2jCKSuKb4tM3V7SL5VWu47T1EKGd?=
 =?us-ascii?Q?JKm7RqistdKFwKYSEBVxClKgkOx2wJ9s1zmuVhRmhUIubUYR8OEFyid7mOFH?=
 =?us-ascii?Q?+4UrxwCvxxEwgf7p/eF2hzKBqY4iawQQA3QJEn5i3pQZwWgmMOAWvBjAD0Xf?=
 =?us-ascii?Q?9qwoaU4thpTiZV7erHOUMzfcSdk0lq0W87pAY2kuOFFcRF9vaCoc/zh3q3rZ?=
 =?us-ascii?Q?yEOtbkNyZAep1pDvf5I+8Ht7UNDJ8sAmviiWbR7+RyfmhOqqcAoCPiHMYW4T?=
 =?us-ascii?Q?mcWX5OF5zpGQCieUwPWZfgmPbZzqOcFsZpfpjWWkEBHEFUAoUYlW2Dje04nC?=
 =?us-ascii?Q?vS1c+8XPIIbUQ613bW/j+D05od4R38Gm0wT+1nGIoDAlD1NZEmcy/np2cJ96?=
 =?us-ascii?Q?0GTopooF+GZBz+t0AkP4Y9PV6vu2POcs90262FtgJFg5QnrtYpsYcEeWuRfu?=
 =?us-ascii?Q?Ek3bt2mE80qfEVnrz8h2IU+/w1HxvvCo+p7dRNgQR0pskwK8OxQ6nTfrIia6?=
 =?us-ascii?Q?7QPb00yJnuPe9FLIJAhC0R8FHpQMNLDNxUeUc0TD8PHDF3SkGQqU7xDZHRTD?=
 =?us-ascii?Q?Z3aktJvn3ZokjyDsq1mk9RiqeLmeRnBuq7vbncBDM/Z7rlicC6CMdc4QFNZJ?=
 =?us-ascii?Q?SLJnKZbD/iKVcu8vkvKATat/CI/oMnsIgyN2gPA82q2lIfnMuNScDjd6cj3I?=
 =?us-ascii?Q?mKk1TuASvfhirTY7IOWUX1xQy/6+iBipqFz8tFwyXxFgAgzc5ZWiolEqX3iQ?=
 =?us-ascii?Q?3KZGgoy3LMSrHuWrVYWWTEbVDkFMFzdKToBHGk5hNEDwjCvWA0YiCgquPEY/?=
 =?us-ascii?Q?1cmLC+tzBKhn63937aBTnFxv/yPZUZk9VDroQ/LjHRtReIbyfwYQJPqaDjUi?=
 =?us-ascii?Q?35whKWma6YmuJMIqXqigFycHQMTct62xk6u1IUcWOQPF6O98d3jSUF8A/hcR?=
 =?us-ascii?Q?NYh/tTTR8z5O/8QL9av0Tbl4JnvdcxM20JVWHhp0W+4gxU3QWjND2vGLCBrk?=
 =?us-ascii?Q?58hckkw0MV+T1JfMGzJouPQ4jEiDuTdHo4cGVR8koVzzCDPfEInLr4to6JGX?=
 =?us-ascii?Q?q8h1W98wefSOBLN9jDx1ioFSFXYXguER+99vykCCL4oOhApyej6cu1dItpTf?=
 =?us-ascii?Q?yGMGHe4WwlIJ17i6ZzqW+cTcyBg7ZGxVC/rAC9xOG9RVPG4Ep/Ef/mDGrbhb?=
 =?us-ascii?Q?xu6nub3jS3oYRSYq0/HfR7gS+EN8Wt5CR0FC3ZzavthEHdD3n3wD2Xxy+v8a?=
 =?us-ascii?Q?KSXe4KAG4eegKzf4U1d6VWsmOgbkudZoTlrv8Ui6H+Ek994r6E8fXH37uVlt?=
 =?us-ascii?Q?LJmgOlf0AbPvcR3Z7ITMxMJ5AC7xx+odXFpFNXDpXR+FI3s7p3n46RFkBT80?=
 =?us-ascii?Q?YJvCghIras0Fk+azd9pFcJpO9r0UM5QMuOVUXwVH7P3oQuclpdTjWG0N85WG?=
 =?us-ascii?Q?B1Kl6+maQkrSDbM4Ro48Cs05eTk3O0qf2loHyR4Tk0DpNYyJAlYVREiWP3wc?=
 =?us-ascii?Q?NJum5eDmFFuY4BqkKp8JGnKdpAJLtyG8Auwk0Tasjcew3fayODRuocVnkC1d?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250e0cdd-9c0b-4149-607f-08dab7a895b2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:52.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWLrEU6nrdsglFp7f+L0JjaFnN6kRLsH5eMag8EV22jF7y4TT1oCC/PQ0J/LRpoZNnh3roOJ8eUPbHiFwymmLrm7RGE9M8kku3yx8FKwrVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: N-aLPPc0VOX8OxDRJQO0zMPmQcqhajev
X-Proofpoint-GUID: N-aLPPc0VOX8OxDRJQO0zMPmQcqhajev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename sd_pr_command to sd_pr_out_command to match a
sd_pr_in_command helper added in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 187b4fe2bc2b..4dc5c932fbd3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1714,7 +1714,7 @@ static char sd_pr_type(enum pr_type type)
 	}
 };
 
-static int sd_pr_command(struct block_device *bdev, u8 sa,
+static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
@@ -1768,7 +1768,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
 			(1 << 0) /* APTPL */);
 }
@@ -1778,24 +1778,24 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
-	return sd_pr_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
+	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
 			     sd_pr_type(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
 {
-	return sd_pr_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.25.1

