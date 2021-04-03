Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7D3C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C989061361
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhDCXYq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbhDCXYc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLQFK160775;
        Sat, 3 Apr 2021 23:24:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=w/7/CtmferOk0ASEUKWPbJwiXYHDgF7B++6tDRC3m80=;
 b=e1ONrA8uPR+f2kKv6TmDz4DeonInlxBl/hXpKp6vhFq4F2qdtH4kokXyZvCaUKXU4dUE
 mL3N++b3TM8a688npPnIZaE3Q1MAvJWiCIcyK14Ii5YqEYCwcC7Bq0UTw3Lgsa942XHT
 6m+d5+GizLyahXj7CmoqYIcNu0bTJQ8DQXr1RvTteMIczPlZyPYoMF369ftRW0tq/L6n
 ctJjRkv/fiqmfd/FtPyZWs+QnZUqlGdam7rEj/Fn8lPqvsqs13r4lcIva36SRtZV3Swb
 Kq1qI60SvR8zP3T9Q/lsd172x6K7nQJEeN0ey260nmvIF5YzC9qAuNO2pcIYDXeZXDTt jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtWm117032;
        Sat, 3 Apr 2021 23:24:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbsrd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7lMvQd8LuXVda+KNlPOgQ5/XIJtXMzcaiaeLYybv5OVutWb3q+c0G8Eqbd6AJJNwElPov9cobVvO9lyh2rtVvGWEC1T96NH2GQ0rzRw0u4pOSsYhJwCjBAFXJ65Za9mjhAxmw7oUZTGfoZWiumEblE99VRcLo6KdcDzs1s/04UtxoOxrku/bMPKk9kCjc91rciplCPca079zvuxKy8MaE2pcJsS6Zflpf5SHj97ZN5oHRfXjavFDcK4Tr8u2OOJGzi/k+6JdkxuiJRL9NjPzYYpuuN4TC3nxd+CBBoVzeysaXbAg7yA4dTkZNx1bajbVCyRkFlKVe1UWwuecLMlmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/7/CtmferOk0ASEUKWPbJwiXYHDgF7B++6tDRC3m80=;
 b=Aqvorqyg9WGSqITkcGENKdkmx6J///rJAzcIpbtkArhwZjFWjt7jTNd2eIjl2swCZW2F7KEgVtpKJM0MguNM5zpqZvUQMn6NWZe5DTadwq9R7TGRAG2FhhnOhh55L12/i+cCNIUbbg1heZU7bvqWgoHB25PtH19K2OeiCP/hkab/jCXM9aHBdhYN20KazHy7FWDV1DKVXyeMg06OKj84YL4MAkIMsVVNWJZCB8w3IWMluKLmtvSKNvGQfUcqDxlzkQ/vdtWCTaEdFeC/+/GpXMOV2lYnVSfdDoA/WeyS3VZ8k7syrUpg5cv7ht6DteodyKGen3/zT7QcKkM+g24zZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/7/CtmferOk0ASEUKWPbJwiXYHDgF7B++6tDRC3m80=;
 b=C1zYUpgVXurJVCp5L5z5VxsncxBmfZyRLVGj+RC11dJTdJ1vHLWr4O40hS0TxjecueG+1jCc3f85lcUzekQnmILA6TxwaxR5ts7t16qRIA+/X2LlWzoa4K4Ey+uflHFayJ6Yagtiu7T35mZVF7clxPADasumwkGdKrjg+bIpD2o=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:18 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 26/40] scsi: iscsi: replace back_lock with task lock for lookup
Date:   Sat,  3 Apr 2021 18:23:19 -0500
Message-Id: <20210403232333.212927-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e30d19f-a13a-4217-a7a2-08d8f6f79a8a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431F5613A2BE58FB5727785F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3oGYjNdQ0/kLUEfaM533ypBbj71p3Jl9bwDEavxWG9jXzCpk4Hzw6EIakh7zpuZIfQOt/YCrk8jJv3tdqk2HJZNU16jxo6PARGPA+FZFbOxM3K2HurxVxPwsPE3RAIv6Tf0znHzt0DFEjYDKxrPHVHx8VORh7SeNZ5BEX8GyV8CUqNEGQrrkpsPHAM7tcTsgv2GYzP1KKAPo1E8ylTujUkTx/+Ckh1WdX5gtt4aasf9WMJLnOPz/myJSsqqEi+CCHt2Xb3COlGkqvdURNa9Rw5o6ROOTvUviHLw7pF0jD1XKfkgHN9PAPJGiqtMyEDJllZgfX95+ZgxBJYgMm2wo53NlBV6rM6wRm3O2L1QFLK69wRhclXrbLPUNalG6LhTCvKqfr48m9qZ1IRnkJHbnt/2CsuJuO3KpsCZACLCAdt618hkN/iNzK8uXAfmyN9WocNtK7dTFlLQHSv/rKFIYr0YbAoXo2TSYuNo0A8DnCYucF6Hp9siGH6gCbXxbkgKp7Rw6bFMz+u5ZvtEmNf7DPYMf7uX1j+gL28RpqReDdA4TXhB6d3I0V5674BzLLLBjHM1Cd4m5gl3Y88ZyQvFHHNVel0PJ0dtx087TvsyWRUgxXi8nr0yx6nZMikL2GT3PV1JeAaUpU1VCRZdmyznA/rpnqkgquaQqMLqafpR5WHEVyGMOYnCw+9sN6drO9P56nIPMH2hKGOFSfGmkR6TYVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(30864003)(8676002)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7e7kbHE6l86PDWhQdgY+yJuzY8jGz7PZULonBE2W9v8wVRJhIcTI5yUlgv2A?=
 =?us-ascii?Q?EFL0hzu+2NPTtjqeBtxVmKECIbvxiUHNXwBzjl6cpArLJ2/89lc/07VPEKsD?=
 =?us-ascii?Q?qIzT7z43DfI3WqbdQArUb/O+k/8x7fVKVsH5RWi3qZeM8VwrAdyG63MXTKNJ?=
 =?us-ascii?Q?ckDPOQRaxA2QtCJaAizOxxYRkTfW0N7BT3etESEJXxHA8tFAdtM1iJrbV19F?=
 =?us-ascii?Q?viDLzS74X39pB4Uw2/czFiB7DuBl4S/0/4G4Ip3ae8Yblflg9DjxkzQsuVwp?=
 =?us-ascii?Q?AEqeeagHbKV9zsSlBek5OHa5rZSIUMU7pH2vpC4rwpARaIK6KnEjbh2NtjJc?=
 =?us-ascii?Q?8kJwYughg3j/F8AIp1sYrSPnurkHbAJ1aikXf5unzGVGTEVcBNxP8DcghZpU?=
 =?us-ascii?Q?gHMwprwULrfCEetULBD8WBhQVYCyegZ8BlyKvx5jcJ4habxNtIhzG06MHfWk?=
 =?us-ascii?Q?BbCzP0/zsaNyCi/ohaJ6is8WyKHB3S9DwJ0lQia2czbGlLnZQc9F7b8EqoeW?=
 =?us-ascii?Q?AR/H7i8b9rS/fuLI2Kn1netaeUQ3P82RNNkjfQrBu5WKG2PoIj8Ps/XUrkEo?=
 =?us-ascii?Q?5wlWpFTj4fBeyDi9UEix+Hci0H1BUyW/mzkMbvgyMK8sqMBo5TSdH785z58r?=
 =?us-ascii?Q?cM+SjUKKoHWAF1ipo++yctLpjArzTkmqOMcCRO2RA3ocYKIhonCy7mkSaqrG?=
 =?us-ascii?Q?v2LIxYdHqtNZDPDnHvyr1npGIEVlBOi0aYEl9jFnErJJWmQitznsLNE1PSMB?=
 =?us-ascii?Q?FeiNLFnGGycc9dnUCtXMzBMWYkkMNx62muc7joSAGAuFgriFp9I6BDiegx0E?=
 =?us-ascii?Q?s4uQftJsKXkrEZgTaVf7RTyhI57KgkXwHvvFhd6e03SVaH/MgvPsdfPhUD/t?=
 =?us-ascii?Q?Ed4P3pXPgkdS3Vhvya4vFqo6oDqg+h/8iv42UQKpQwYS7TNcmwnePWJb1LWR?=
 =?us-ascii?Q?2FLgt7wHSNtcQGo4p6AdrLU9T5eLydqgEdqfIJ0kETxDRBu+8Eh5PyJkZDiK?=
 =?us-ascii?Q?l05tDREqWOzQPfs3skZ6tGbSnLBshVn6Zt3asL/FFf23YWmip6D+Bk2uXrFE?=
 =?us-ascii?Q?maFq1eJgL+4daeJuToGVmaB7QiYyP40KfBpsjuPTXc5Y0JiboCs9x/NMbniC?=
 =?us-ascii?Q?cWzqjAsgi/2wEazLx3n1rCkHAWAJ0pnOPLc96TzdQoFAqFLIVNVGcmW8cncT?=
 =?us-ascii?Q?iMUpc6WbLrYs0dQYPSRskFKI9PJ9ZtrNr2PR//18mXZAlYrl8LsknWla+7Bf?=
 =?us-ascii?Q?GVLTKDkEMus0PM63IfdhQuOR89yf78HwSAFrPV7zQq7G+X5JWDLUNZMPBH04?=
 =?us-ascii?Q?SzCXDdErFSPVjLjgNdMgzdxA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e30d19f-a13a-4217-a7a2-08d8f6f79a8a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:18.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6NBsq17RQFO/bg/F3wKTACULTPgS2T+ZXDk7n7fR00owPWwcdSiqPsKjQkBnEasPP1ng8w/H2kvwGeO9G+vsEJgS54PoWDqdshYTQ7aiWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: tdOfSed9e1PQ3iQL6IVZu2QsLyuutUZp
X-Proofpoint-GUID: tdOfSed9e1PQ3iQL6IVZu2QsLyuutUZp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We hold the back lock during completion to make sure commands do not
complete from another thread but for drivers that can complete from
multiple threads/isrs this adds a bottleneck. We also do not want to
have to hold the back_lock while calling iscsi_put_task from the xmit
path.

This patch adds a per task lock which is used to test if a command has
completed and can be used to get a ref to the task so it can't complete
from under us in the recv paths. The next patch will convert the eh
paths.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |  9 ++-
 drivers/scsi/bnx2i/bnx2i_hwi.c               | 63 +++++++++++---------
 drivers/scsi/cxgbi/libcxgbi.c                |  3 +-
 drivers/scsi/libiscsi.c                      | 42 ++++++++++---
 drivers/scsi/libiscsi_tcp.c                  | 18 +++---
 drivers/scsi/qedi/qedi_fw.c                  |  6 +-
 drivers/scsi/qla4xxx/ql4_isr.c               |  4 +-
 drivers/scsi/qla4xxx/ql4_os.c                |  3 +-
 include/scsi/libiscsi.h                      | 12 +++-
 9 files changed, 104 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 27a6f75a9912..43757b312006 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -632,15 +632,20 @@ iser_check_remote_inv(struct iser_conn *iser_conn,
 
 			if (iser_task->dir[ISER_DIR_IN]) {
 				desc = iser_task->rdma_reg[ISER_DIR_IN].mem_h;
-				if (unlikely(iser_inv_desc(desc, rkey)))
+				if (unlikely(iser_inv_desc(desc, rkey))) {
+					iscsi_put_task(task);
 					return -EINVAL;
+				}
 			}
 
 			if (iser_task->dir[ISER_DIR_OUT]) {
 				desc = iser_task->rdma_reg[ISER_DIR_OUT].mem_h;
-				if (unlikely(iser_inv_desc(desc, rkey)))
+				if (unlikely(iser_inv_desc(desc, rkey))) {
+					iscsi_put_task(task);
 					return -EINVAL;
+				}
 			}
+			iscsi_put_task(task);
 		} else {
 			iser_err("failed to get task for itt=%d\n", hdr->itt);
 			return -EINVAL;
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index bad396e5c601..af03ad7bc941 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -404,8 +404,8 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	switch (tmfabort_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
 	case ISCSI_TM_FUNC_TASK_REASSIGN:
-		ctask = iscsi_itt_to_task(conn, tmfabort_hdr->rtt);
-		if (!ctask || !ctask->sc)
+		ctask = iscsi_itt_to_ctask(conn, tmfabort_hdr->rtt);
+		if (!ctask) {
 			/*
 			 * the iscsi layer must have completed the cmd while
 			 * was starting up.
@@ -415,6 +415,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 			 *       In this case, the task must be aborted
 			 */
 			return 0;
+		}
 
 		ref_sc = ctask->sc;
 		if (ref_sc->sc_data_direction == DMA_TO_DEVICE)
@@ -425,6 +426,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 				 ISCSI_CMD_REQUEST_TYPE_SHIFT);
 		tmfabort_wqe->ref_itt = (dword |
 					(tmfabort_hdr->rtt & ISCSI_ITT_MASK));
+		iscsi_put_task(ctask);
 		break;
 	default:
 		tmfabort_wqe->ref_itt = RESERVED_ITT;
@@ -1346,7 +1348,6 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 	u32 datalen = 0;
 
 	resp_cqe = (struct bnx2i_cmd_response *)cqe;
-	spin_lock_bh(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 resp_cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task)
@@ -1414,10 +1415,12 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 	}
 
 done:
+	spin_lock_bh(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
-fail:
 	spin_unlock_bh(&session->back_lock);
+	iscsi_put_task(task);
+fail:
 	return 0;
 }
 
@@ -1442,7 +1445,6 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	int pad_len;
 
 	login = (struct bnx2i_login_response *) cqe;
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 login->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
@@ -1481,11 +1483,13 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 		}
 	}
 
+	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
 		bnx2i_conn->gen_pdu.resp_buf,
 		bnx2i_conn->gen_pdu.resp_wr_ptr - bnx2i_conn->gen_pdu.resp_buf);
-done:
 	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
+done:
 	return 0;
 }
 
@@ -1510,7 +1514,6 @@ static int bnx2i_process_text_resp(struct iscsi_session *session,
 	int pad_len;
 
 	text = (struct bnx2i_text_response *) cqe;
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn, text->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
 		goto done;
@@ -1541,12 +1544,14 @@ static int bnx2i_process_text_resp(struct iscsi_session *session,
 			bnx2i_conn->gen_pdu.resp_wr_ptr++;
 		}
 	}
+	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
 			     bnx2i_conn->gen_pdu.resp_buf,
 			     bnx2i_conn->gen_pdu.resp_wr_ptr -
 			     bnx2i_conn->gen_pdu.resp_buf);
-done:
 	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
+done:
 	return 0;
 }
 
@@ -1569,7 +1574,6 @@ static int bnx2i_process_tmf_resp(struct iscsi_session *session,
 	struct iscsi_tm_rsp *resp_hdr;
 
 	tmf_cqe = (struct bnx2i_tmf_response *)cqe;
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 tmf_cqe->itt & ISCSI_TMF_RESPONSE_INDEX);
 	if (!task)
@@ -1583,9 +1587,11 @@ static int bnx2i_process_tmf_resp(struct iscsi_session *session,
 	resp_hdr->itt = task->hdr->itt;
 	resp_hdr->response = tmf_cqe->response;
 
+	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
-done:
 	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
+done:
 	return 0;
 }
 
@@ -1608,7 +1614,6 @@ static int bnx2i_process_logout_resp(struct iscsi_session *session,
 	struct iscsi_logout_rsp *resp_hdr;
 
 	logout = (struct bnx2i_logout_response *) cqe;
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 logout->itt & ISCSI_LOGOUT_RESPONSE_INDEX);
 	if (!task)
@@ -1628,11 +1633,14 @@ static int bnx2i_process_logout_resp(struct iscsi_session *session,
 	resp_hdr->t2wait = cpu_to_be32(logout->time_to_wait);
 	resp_hdr->t2retain = cpu_to_be32(logout->time_to_retain);
 
+	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	spin_unlock(&session->back_lock);
+
+	iscsi_put_task(task);
 
 	bnx2i_conn->ep->state = EP_STATE_LOGOUT_RESP_RCVD;
 done:
-	spin_unlock(&session->back_lock);
 	return 0;
 }
 
@@ -1653,12 +1661,10 @@ static void bnx2i_process_nopin_local_cmpl(struct iscsi_session *session,
 	struct iscsi_task *task;
 
 	nop_in = (struct bnx2i_nop_in_msg *)cqe;
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 nop_in->itt & ISCSI_NOP_IN_MSG_INDEX);
 	if (task)
-		__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
+		iscsi_put_task(task);
 }
 
 /**
@@ -1690,14 +1696,13 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 				     struct cqe *cqe)
 {
 	struct iscsi_conn *conn = bnx2i_conn->cls_conn->dd_data;
-	struct iscsi_task *task;
+	struct iscsi_task *task = NULL;
 	struct bnx2i_nop_in_msg *nop_in;
 	struct iscsi_nopin *hdr;
 	int tgt_async_nop = 0;
 
 	nop_in = (struct bnx2i_nop_in_msg *)cqe;
 
-	spin_lock(&session->back_lock);
 	hdr = (struct iscsi_nopin *)&bnx2i_conn->gen_pdu.resp_hdr;
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode = nop_in->op_code;
@@ -1722,9 +1727,13 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 		memcpy(&hdr->lun, nop_in->lun, 8);
 	}
 done:
+	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 	spin_unlock(&session->back_lock);
 
+	if (task)
+		iscsi_put_task(task);
+
 	return tgt_async_nop;
 }
 
@@ -1833,13 +1842,14 @@ static void bnx2i_process_cmd_cleanup_resp(struct iscsi_session *session,
 	struct iscsi_task *task;
 
 	cmd_clean_rsp = (struct bnx2i_cleanup_response *)cqe;
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
-	if (!task)
+	if (!task) {
 		printk(KERN_ALERT "bnx2i: cmd clean ITT %x not active\n",
 			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
-	spin_unlock(&session->back_lock);
+	} else {
+		iscsi_put_task(task);
+	}
 	complete(&bnx2i_conn->cmd_cleanup_cmpl);
 }
 
@@ -1907,18 +1917,15 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 	struct scsi_cmnd *sc;
 	int rc = 0;
 
-	spin_lock(&session->back_lock);
-	task = iscsi_itt_to_task(bnx2i_conn->cls_conn->dd_data,
-				 cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
-	if (!task || !task->sc) {
-		spin_unlock(&session->back_lock);
+	task = iscsi_itt_to_ctask(bnx2i_conn->cls_conn->dd_data,
+				  cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
+	if (!task)
 		return -EINVAL;
-	}
 	sc = task->sc;
 
-	spin_unlock(&session->back_lock);
-
 	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(sc->request));
+	iscsi_put_task(task);
+
 	spin_lock(&p->p_work_lock);
 	if (unlikely(!p->iothread)) {
 		rc = -EINVAL;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index cdaa67fd8c2e..b3960e0b341a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1540,10 +1540,11 @@ skb_read_pdu_bhs(struct cxgbi_sock *csk, struct iscsi_conn *conn,
 		struct iscsi_task *task = iscsi_itt_to_ctask(conn, itt);
 		u32 data_sn = be32_to_cpu(((struct iscsi_data *)
 							skb->data)->datasn);
-		if (task && task->sc) {
+		if (task) {
 			struct iscsi_tcp_task *tcp_task = task->dd_data;
 
 			tcp_task->exp_datasn = data_sn;
+			iscsi_put_task(task);
 		}
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f822c0cd5927..955ca15ecf5f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -454,8 +454,11 @@ static void __iscsi_free_task(struct iscsi_task *task)
 			  task->itt, task->state, task->sc);
 
 	session->tt->cleanup_task(task);
+
+	spin_lock_bh(&task->lock);
 	task->state = ISCSI_TASK_FREE;
 	task->sc = NULL;
+	spin_unlock_bh(&task->lock);
 	/*
 	 * login task is preallocated so do not free
 	 */
@@ -1097,10 +1100,12 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
 				rc = ISCSI_ERR_BAD_ITT;
-			} else
+			} else {
 				rc = iscsi_nop_out_rsp(task,
 					(struct iscsi_nopin*)&rejected_pdu,
 					NULL, 0);
+				iscsi_put_task(task);
+			}
 		}
 		break;
 	default:
@@ -1121,11 +1126,13 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  * This should be used for mgmt tasks like login and nops, or if
  * the LDD's itt space does not include the session age.
  *
- * The session back_lock must be held.
+ * If the itt is valid a task will be returned with the reference held. The
+ * caller must call iscsi_put_task.
  */
 struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
+	struct iscsi_task *task;
 	uint32_t i;
 
 	if (itt == RESERVED_ITT)
@@ -1142,7 +1149,12 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 		if (i >= ISCSI_MGMT_CMDS_MAX)
 			return NULL;
 
-		return session->mgmt_cmds[i];
+		task = session->mgmt_cmds[i];
+		if (iscsi_task_is_completed(task))
+			return NULL;
+
+		__iscsi_get_task(task);
+		return task;
 	} else {
 		return iscsi_itt_to_ctask(conn, itt);
 	}
@@ -1200,7 +1212,9 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	if (!task)
 		return ISCSI_ERR_BAD_OPCODE;
 
-	return iscsi_complete_task(conn, task, hdr, data, datalen);
+	rc = iscsi_complete_task(conn, task, hdr, data, datalen);
+	iscsi_put_task(task);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
 
@@ -1374,7 +1388,8 @@ EXPORT_SYMBOL_GPL(iscsi_verify_itt);
  *
  * This should be used for cmd tasks.
  *
- * The session back_lock must be held.
+ * If the itt is valid a task will be returned with the reference held. The
+ * caller must call iscsi_put_task.
  */
 struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 {
@@ -1395,15 +1410,21 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 		return NULL;
 
 	task = scsi_cmd_priv(sc);
-	if (!task->sc)
+	spin_lock_bh(&task->lock);
+	if (!task->sc || iscsi_task_is_completed(task)) {
+		spin_unlock_bh(&task->lock);
 		return NULL;
+	}
 
 	if (task->sc->SCp.phase != session->age) {
 		iscsi_session_printk(KERN_ERR, conn->session,
 				  "task's session age %d, expected %d\n",
 				  task->sc->SCp.phase, session->age);
+		spin_unlock_bh(&task->lock);
 		return NULL;
 	}
+	__iscsi_get_task(task);
+	spin_unlock_bh(&task->lock);
 
 	return task;
 }
@@ -1709,14 +1730,18 @@ static struct iscsi_task *iscsi_init_scsi_task(struct iscsi_conn *conn,
 
 	refcount_set(&task->refcount, 1);
 	task->itt = blk_mq_unique_tag(sc->request);
-	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
-	task->sc = sc;
 	task->have_checked_conn = false;
 	task->last_timeout = jiffies;
 	task->last_xfer = jiffies;
 	task->protected = false;
 	INIT_LIST_HEAD(&task->running);
+
+	spin_lock_bh(&task->lock);
+	task->state = ISCSI_TASK_PENDING;
+	task->sc = sc;
+	spin_unlock_bh(&task->lock);
+
 	return task;
 }
 
@@ -2951,6 +2976,7 @@ static void iscsi_init_task(struct iscsi_task *task, int dd_task_size)
 	task->itt = ISCSI_RESERVED_TAG;
 	task->state = ISCSI_TASK_FREE;
 	INIT_LIST_HEAD(&task->running);
+	spin_lock_init(&task->lock);
 }
 
 int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 73d4fe20ba9d..b1399ff5ca9e 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -539,13 +539,11 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	int r2tsn;
 	int rc;
 
-	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_ctask(conn, hdr->itt);
 	if (!task) {
-		spin_unlock(&session->back_lock);
 		return ISCSI_ERR_BAD_ITT;
 	} else if (task->sc->sc_data_direction != DMA_TO_DEVICE) {
-		spin_unlock(&session->back_lock);
+		iscsi_put_task(task);
 		return ISCSI_ERR_PROTO;
 	}
 	/*
@@ -553,16 +551,15 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	 * so get a ref to the task that will be dropped in the xmit path.
 	 */
 	if (task->state != ISCSI_TASK_RUNNING) {
-		spin_unlock(&session->back_lock);
 		/* Let the path that got the early rsp complete it */
 		return 0;
 	}
 	task->last_xfer = jiffies;
-	__iscsi_get_task(task);
 
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
 	/* fill-in new R2T associated with the task */
+	spin_lock(&session->back_lock);
 	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
 	spin_unlock(&session->back_lock);
 
@@ -713,14 +710,15 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
-		spin_lock(&conn->session->back_lock);
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!task)
 			rc = ISCSI_ERR_BAD_ITT;
 		else
 			rc = iscsi_tcp_data_in(conn, task);
+
 		if (rc) {
-			spin_unlock(&conn->session->back_lock);
+			if (task)
+				iscsi_put_task(task);
 			break;
 		}
 
@@ -753,11 +751,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 						   tcp_conn->in.datalen,
 						   iscsi_tcp_process_data_in,
 						   rx_hash);
-			spin_unlock(&conn->session->back_lock);
+			iscsi_put_task(task);
 			return rc;
 		}
-		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
-		spin_unlock(&conn->session->back_lock);
+		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
+		iscsi_put_task(task);
 		break;
 	case ISCSI_OP_SCSI_CMD_RSP:
 		if (tcp_conn->in.datalen) {
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 217291e81cdb..e28dc249c9f0 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1469,14 +1469,16 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
 	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 	     ISCSI_TM_FUNC_ABORT_TASK) {
-		ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-		if (!ctask || !ctask->sc) {
+		ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+		if (!ctask) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Could not get reference task\n");
 			return 0;
 		}
+
 		cmd = (struct qedi_cmd *)ctask->dd_data;
 		tmf_pdu_header.rtt = cmd->task_id;
+		iscsi_put_task(ctask);
 	} else {
 		tmf_pdu_header.rtt = ISCSI_RESERVED_TAG;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6f0e77dc2a34..92ef40d755e4 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -384,10 +384,8 @@ static void qla4xxx_passthru_status_entry(struct scsi_qla_host *ha,
 
 	cls_conn = ddb_entry->conn;
 	conn = cls_conn->dd_data;
-	spin_lock(&conn->session->back_lock);
-	task = iscsi_itt_to_task(conn, itt);
-	spin_unlock(&conn->session->back_lock);
 
+	task = iscsi_itt_to_task(conn, itt);
 	if (task == NULL) {
 		ql4_printk(KERN_ERR, ha, "%s: Task is NULL\n", __func__);
 		return;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index af89d39f19e5..754046902141 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3382,7 +3382,8 @@ static void qla4xxx_task_work(struct work_struct *wdata)
 			   sts->completionStatus);
 		break;
 	}
-	return;
+	/* Release ref taken in qla4xxx_passthru_status_entry */
+	iscsi_put_task(task);
 }
 
 static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8d1918590aa6..25590b1458ef 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -142,7 +142,11 @@ struct iscsi_task {
 	/* T10 protection information */
 	bool			protected;
 
-	/* state set/tested under session->lock */
+	/*
+	 * task lock must be held when using sc or state to check if task has
+	 * completed
+	 */
+	spinlock_t		lock;
 	int			state;
 	refcount_t		refcount;
 	struct list_head	running;	/* running cmd list */
@@ -162,6 +166,12 @@ static inline void* iscsi_next_hdr(struct iscsi_task *task)
 	return (void*)task->hdr + task->hdr_len;
 }
 
+static inline bool iscsi_task_is_completed(struct iscsi_task *task)
+{
+	return task->state == ISCSI_TASK_COMPLETED ||
+	       task->state == ISCSI_TASK_ABRT_TMF;
+}
+
 /* Connection's states */
 enum {
 	ISCSI_CONN_INITIAL_STAGE,
-- 
2.25.1

