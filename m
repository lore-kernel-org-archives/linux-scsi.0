Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E877C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiC2SHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbiC2SHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E91B0D3D
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsnjx013410;
        Tue, 29 Mar 2022 18:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dSVVvnRo7jDyQF1UEfJ9nfGfuTuhMtgmUInw4qCJyjw=;
 b=AqSUb9zNIhGMKr4Uw4h3Bb1Jl77FgNn5r/eZxDVnprjsROxH8LD0bJtjJP5ELBRXnVVF
 pyF3SKKeobCtTjJ2j13p0PW0zHzMoxWxm++GifFFEs7/fniRVHP2Hn4yJ0kWBCrpaJIB
 JwuJukUDlRkENCYbvcO5sHb4h17hR2Eqc1xXoGuO4OmujxNeGUx2XypVflu6A1Oolcxp
 T0eo3sUjd6/FpswMyf+i5U/u0zaXUpSeYkbmdkOxitTbe6kuil/UE9+qND/HESRdwPmX
 uq1b4Yg9ZeivYGRR6DawI9qP/Kyl2W+Gxi/xpN5X4Ye/5rH1zAfBEXpMiafE1J35otl1 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1uctqf6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJG048570;
        Tue, 29 Mar 2022 18:03:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBjonTz2fQoIFb/nyyMdu7Ze1mZn139Le4VHlp9wSHyxtSrQzK1r0lSbecxANmIdMWf1v3EXeL9MVfIhCBiqw5fhlb0EMhSmXFM9vW7QA7OkYVmlyf0duBihWlXeda/q9HUUl84tHrtBMipWuJzr4Wl0QGVU75kueUy3kubLK0z4xIAEamj6fdiGVRmARx16oop6ZhmMKCG8AheMvs347s01TrXjUHzhE7P4EAwP4TMoXx5Wjvk9ji1zHS8FUIYh/5Fy1sldsz7sXnmprbROzPdJ292sezH7ABK+Hu1cmOlL7GNwVgefthzTNiXdKV2V+rF0IvI+xOdxoCDvKEH3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSVVvnRo7jDyQF1UEfJ9nfGfuTuhMtgmUInw4qCJyjw=;
 b=VBxmuCPcMeCH1ZHwPtyKEiFh+cIdgJq0A6sI5kk5+vJ6iWq0En7yAbQRlIvidn7GV3vuyC70vkyQCUvr4GbdCDlA+VjSOg2rdFVkQzk7znPoQgCAH3jyQUD5Ss/XzE5QC3NCjDJA4hjKu4cJI8l2QOEm35rAx+GMCM4fNEiRQycYK/nmr5zI/40fRtoI+YZudmniq6DG2LWCuntG6gKDntUb6Dhmk+Bmwu5KSZ9PTnkxklggb3Yj1r/oQv4fvjhF3HmvpdxWja3Iyz4yJElZ3Dfe/gCfsQkelmu7oU+52KUVIsyzMW4rEVNh1hLNGkbwT7I9mBwClEEVyEqXRKJ5LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSVVvnRo7jDyQF1UEfJ9nfGfuTuhMtgmUInw4qCJyjw=;
 b=WxSMOmjhdVoXrMKXY/Q344fHAeKAq87OsLc60LnqkJUoQ7n2kSnFbf/mWYddRTzyIEjn0gouWqVYtGcnkpSETw78hoajo6zfoUFZD8Erk9w20hZY+5nHgY+rKD3wn7iy2w85CHDsudECFzo9+6Mpy7VrmMSVs1lQoDcz/E9j3Xc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 03/15] scsi: iscsi: Merge suspend fields
Date:   Tue, 29 Mar 2022 13:03:14 -0500
Message-Id: <20220329180326.5586-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6962e68-8b76-4dfd-261d-08da11ae7208
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584D556EC2A4B4AE8DC93CDF11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHkbashCqeI9KDvwQ0VOxYMfRlc8dKQOuYLvmWACHiFqSjumuFY2oZIm1FkaC+S5Ebyd716e85F38LtbWDvV0GcCKQqir5ogzTqI+iZ2gwvBSRn+srvv4Iq8LffGXP+LKpw5XbzxSqrRtGdJAonfRlIQVujHixeLuB+OIGQgkiM3lYJoqNQXmb4EL2N6fGAuUdGbPB/2HieBe8UTibLhaDki5J/H7ljrKDgpUo9yH1+/Wrxby3fQG1tW9mLCbLa1PtU0wAHfczsdZl3YRGOhpTP7FwfQaMSHwVR/VjobnzwY5W7r0ghQQKfW3RZ64mNMsue+dL4sce3N+gw39Rrcw2jHZ9pRWfB91UXFN4ylC2hY2Us9+FKhqHhN52sS9MoD+w6jz/034UJemyhkckMe+qCmvyal4ZEe2gt/aDhmDVmwYAa2u9vq+IGKNlcj/Hl5YlFnsjgil8y6kWDGqEkWjdEGFCFuRJZ8FRD/FoddvzlBTrwmw59CLq9uRz1FAtmBbwH93tCZgVcdQy0h/UMAgENvpeZFDv8PmQQFeBPv8kVecaMBZIH/u5YdnPch4Ns1zGqhtMNf1iIXRUG9awhfbVizbtGQsF9ro5nzLIsDirXNuODYiXWVjgFd4j28z6riTH8H6GM/oGsgCx0GJpZsMrFqpQsQUK3Bn7ZB+jekVs/2vXE6a2c3IsCoeUXKKaPVjT685xEJavV2kRDuoUTuUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(15650500001)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fz2b/9PYsIwv/CUhL1gcaCeh03ziGdRb70xbG8NsKyRUoT+Rpr/5VkbBdkN/?=
 =?us-ascii?Q?ZhbDgsQLQ6fRPPQD/Ea3oAfUU1M3ymcreSzNe/r006W/jApBdBuH3STTKYSF?=
 =?us-ascii?Q?KL23/HVNKzaVdkXcqqzp82qEm9uiFGZx2DKTZxG2KbwRWRMYKTUVGgWukUZk?=
 =?us-ascii?Q?Cji4RN+ro3GUImN36KUEznUGHw3nqowFRaQQTBSMbghh6BvJ/kU7b5wfXjhx?=
 =?us-ascii?Q?HRU36/08lNYeR1+4jjToJlu83eLcT9SfhgPAy85NtVBwK9yrA4l0FCau+ZaB?=
 =?us-ascii?Q?MKBWcGo5fUsjzNVijplVYKvO/IzhGXZge2bYyrzNRbAgJ1111bkMqfBkvZYv?=
 =?us-ascii?Q?ndjot/mpY9QWKDH6pw1c9c0g5cp0gaSNQVSvzchL3UMlemRaK+4pAvy+HHom?=
 =?us-ascii?Q?Vi8Oe+3AqhFZr0E6jyA2FRFSNzrrhYUMYJyIKAwiiHRMIS8w6jdtTjTmZfQI?=
 =?us-ascii?Q?C42aTQ5zeW+acIYNQR3oVF0DFtRjX+6HqIWR3C3ZRqRH7CJBeGYCm8ipYHp6?=
 =?us-ascii?Q?CQ7RJXEKxyyIlN++dKYfBFndC+fPYUPF/7SkEICPXlcRrLjiJT6tf0C6V2TE?=
 =?us-ascii?Q?eqhTka+SwTXW5gGPguOq+H5buMlOb1X+U3J7Km5jcvIK5ZVx/+aRsp/H4DWY?=
 =?us-ascii?Q?jd1LD/0ptEGegHQkEIgbk16kot/doVKH1TaCOY3NMdLSP5i6JE2+rXRsAfYa?=
 =?us-ascii?Q?prfGCCSxqke2HPnTZ0XzE8MmoXBPWEDxu0YfHryCZjhgmXDpTsN76+V/ghc0?=
 =?us-ascii?Q?aY2+a67/Rqozc3GltFylw3M4GXNpAqBKPvkWyv0J2WSY7b3mHzKsyN/+AA6j?=
 =?us-ascii?Q?CY9ruGzIFLAkhQ+I15IBjdAqYb4kUjR4bbhPENiM61bx8Gr6dI2u7VzoDRzn?=
 =?us-ascii?Q?bw9LtqbLdh6NkbBHkSAJThHsuEKUyQhtictA05oDJ4YA86LQcaKesJe3xPUh?=
 =?us-ascii?Q?yoIkrRXI6ubkAaB8z5VSmSAf2HRHInwiJw/2NeR4cSBalL6kRDvwU0mGqGI7?=
 =?us-ascii?Q?1Zraj4GXXhTYU1r8XSzyVm7wROyVEydGe3/DFcn0SYj/QaYfCZ97dGhzzPd8?=
 =?us-ascii?Q?Pvr1xEglQCw4xbftIUMfaWpgQS7KFjni/8vewVXHQg31WIHwWN3/DJ1nCrfm?=
 =?us-ascii?Q?M8MIt7d3fpZ9K3MXwcTo4RDwMfcgBCzDdF5AVDoGcF+FpP465ekzJqbswEmF?=
 =?us-ascii?Q?nrfwFWIeM3YvdxRbyKVZIKvtqcRPvT0E5HNSFMe1zK0H3aA3uIMpOJLSbHVS?=
 =?us-ascii?Q?6xhV7pgNdH3HDtc16v+7XNxRFKSvEDJVtk73rWXUhDFKL/pUo2IdubQB6Lws?=
 =?us-ascii?Q?hoD5sYpC5Cj7rPieXWOnZrPMS6sEkquIpG1MBTvV1iKaM4mfs0/Oi2qqrXWY?=
 =?us-ascii?Q?ECwFXlWxCizwf/yHd7KYNmV0ffwAAr6wu2iyGNyGMStV8C6rgPLQj/idA/eF?=
 =?us-ascii?Q?P5C4a6ooU/Hfg9zL1jPopWsffn3z928unBpEhW1xMdjcFYXwKP+x6NhCkXwl?=
 =?us-ascii?Q?eh2Ch6E10j9dxjQ2aH5VuxM8raehMWgEf3CxWTXSxt2MqxNlnptyIh0tSEVP?=
 =?us-ascii?Q?jxE9tznlO/3KT814BmhckbnXEDPjyoS27u33xy0MDwTo00W80e0Psosh260n?=
 =?us-ascii?Q?ZccP+hF7+dKPI3TrHjCQhWhszVgkHrteCQg6/4H889n0ABRo3DKJQVNNbND/?=
 =?us-ascii?Q?vZm58sNsS3AOZ5cwfDbPKvwm1v+u+mfRb24mlBziNx5q3G5wvsh42Rwu70EX?=
 =?us-ascii?Q?/MDcOFh6dUBSsdpZdfBEfpmWqR0iZb0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6962e68-8b76-4dfd-261d-08da11ae7208
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:36.2871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KgvMRveLgsc5c2Hh3+kHArYf6ly11/mc7Blc/FWnBD9Uaucq3WTkhqD11K/Uxz1Ugd2Ntsvq+5PlWjrwqjfQWSAcoLYSm1xPw+bR2xfEUhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: i7Ig6aG6_cYVPScQ8eESmT2ubsdONYMA
X-Proofpoint-GUID: i7Ig6aG6_cYVPScQ8eESmT2ubsdONYMA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the tx and rx suspend fields into one flags field.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c    |  6 +++---
 drivers/scsi/libiscsi.c          | 20 ++++++++++----------
 drivers/scsi/libiscsi_tcp.c      |  2 +-
 include/scsi/libiscsi.h          |  9 +++++----
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5521469ce678..e16327a4b4c9 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
 			break;
 
-		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
+		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
 			    nopin->itt == (u16) RESERVED_ITT) {
 				printk(KERN_ALERT "bnx2i: Unsolicited "
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fe86fd61a995..15fbd09baa94 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
 
 			/* Must suspend all rx queue activity for this ep */
-			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 		}
 		/* CONN_DISCONNECT timeout may or may not be an issue depending
 		 * on what transcribed in TCP layer, different targets behave
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 8c7d4dda4cf2..4365d52c6430 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"csk 0x%p, conn 0x%p.\n", csk, conn);
 
-	if (unlikely(!conn || conn->suspend_rx)) {
+	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
+			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
 			csk, conn, conn ? conn->id : 0xFF,
-			conn ? conn->suspend_rx : 0xFF);
+			conn ? conn->flags : 0xFF);
 		return;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d09926e6c8a8..5e7bd5a3b430 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1392,8 +1392,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 	return true;
 }
 
@@ -1454,7 +1454,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * Do this after dropping the extra ref because if this was a requeue
 	 * it's removed from that list and cleanup_queued_task would miss it.
 	 */
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		/*
 		 * Save the task and ref in case we weren't cleaning up this
 		 * task and get woken up again.
@@ -1532,7 +1532,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	spin_lock_bh(&conn->session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->frwd_lock);
 		return -ENODATA;
@@ -1746,7 +1746,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1935,7 +1935,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
 	spin_lock_bh(&conn->session->frwd_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
@@ -1953,7 +1953,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
 		flush_workqueue(ihost->workq);
 }
@@ -1961,7 +1961,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	iscsi_conn_queue_work(conn);
 }
 
@@ -3330,8 +3330,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e9ffe3d1a55..883005757ddb 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	 */
 	conn->last_recv = jiffies;
 
-	if (unlikely(conn->suspend_rx)) {
+	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
 		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e76c94697c1b..84086c240228 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -53,8 +53,10 @@ enum {
 
 #define ISID_SIZE			6
 
-/* Connection suspend "bit" */
-#define ISCSI_SUSPEND_BIT		1
+/* Connection flags */
+#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
+#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
+
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
@@ -211,8 +213,7 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	unsigned long		suspend_tx;	/* suspend Tx */
-	unsigned long		suspend_rx;	/* suspend Rx */
+	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
-- 
2.25.1

