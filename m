Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253DCC43461
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2DE461360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhDCXZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbhDCXZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKOUe160347;
        Sat, 3 Apr 2021 23:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=4wm0Vlg1ct/yjlqnFEJVhyWa56Z8Wh82N99S84JVnb8=;
 b=L1p78LrcUCslqztZyx/wE8s9S6V8ehCEaUeg323Cu5ojSYMaLR2nXWEJo0DhB7mwLVV9
 aM/Jx6JfgPAXZSLyeF1iIm8XUlhWP/IcTWDBsw/xJP3sALyoJ+3sIw60YrE5p+KFgkRu
 sF0qG75URrVenQ943hcgPsGdQTvAQQD6g1tAOFidywNfshv2EKqI0/AEp3oTg0FYErdy
 djPsdnECY/Qmq0JLDgDgtzbrjC8P+gVXi2JQSsxbbxaPexLsr9FAEQEcnQ8EgBMbz442
 c9aleMeV5Tz5Mmhm/zSgCjexYPhmp10Q5I8g2a02ukOGELnevVbDfeGPebcx1FWcvv6J 2A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBW117020;
        Sat, 3 Apr 2021 23:25:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIorZtmZkERKD7ELi1TSUJzhuHCTPARdQ6/Szx8+jE0AkJXOdViAXdu5BbT8SYSx1MQ2P50vhSHqUPb1XDItDeCtO5Kl65Tw6vJCKfolUdiSnOrSAG9ybdRQFAI050y9kyRuMmthXQOwnPpmUSDzVEKrkSPiFzZsDzaQVgYmc8s2byOvCcYlfhcXM5uCPoA71Q6kwPuJ4qUct3AJ7xc7hQ8zF0HWJfVflHiBsQ5Q02pINkCg31mOaunzhhUXf5Bctfww+zvuaCu90ANnMQRp5R62LahGjlrAORf+PrBtvG87i3YllX445NUCeSZFkdIP7ZJwPOatd5R64FScH2JNvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wm0Vlg1ct/yjlqnFEJVhyWa56Z8Wh82N99S84JVnb8=;
 b=Jm0CBBtKXBs18hqwAF6rn1ZH1mfvCt0KeUqGCkrbg/+pGaHlZVolH2n3ZdWXKbfuP3mZejLtLgeedqFJydB9pM6FAXwYQySpzclwh2+5COafT7nnOTh4ujOhwN3NOWma9uBqy3Haa2pGtgOWIt8kjBd5dN9ZMfh9ms2Cy34z0UYrDpsOYDzHu9Y5Xc46kVv6tBe9bQvg8+uZ6LYoGXTK9ExczuCjoLRW27+i4I+lzHbzN26uHz6np2PJfx31JlOkvV2Hiu8QkIWnKGx8NgGG5q7tXFm4nzk543i+4qlFVOqVOtOUmNvlVKQfNzzhZNLBlNWdXtJNkRL7RujL/5fX3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wm0Vlg1ct/yjlqnFEJVhyWa56Z8Wh82N99S84JVnb8=;
 b=hPn/+9LDtQ5bmIKEXm/uj+fXDagJvGRT+doXiTP4jI++XVQQgPUrk08sLjqeoWK3HNyCfDtXB9R9viGIV6GrlfsPeFgwJBQMb2AhGXm9w9YhKid27U/rLw0rH7YOb/AfsVZ8QPxjEb9aDghHCExSJOF+W0kydTHC1U91oQCH1HE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 34/40] scsi: iscsi: remove back_lock
Date:   Sat,  3 Apr 2021 18:23:27 -0500
Message-Id: <20210403232333.212927-35-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76058b42-a010-42b4-eca7-08d8f6f7a0f8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB343132A53E66ECFA9D27CDE3F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHWzbFO09RDVTeSHS8u9ZC9q2hjl1Q+Bjo+Y/1Cfk0WS7BVQUcQXf4CEdoU3Ee/z+sTdgEbOf6VloXuP+rr2WE0KqRSKPAlisB0ZOxm+DwMOUPYXQE52wn6PsHt7dtethS8DeOhv2emEgcWAuQgamzMMzrb39/YYTGWGhn+QcyZTuVnd8F4/0DM4kLC1+4Nm4eOUyilIAVvoPQDSlyMFXdvKfLAEtgEcWOOYZjOCZ+nAQUQDiOebATjL4EHTnHPYiQjrcKjV6tRWWvTxNIJ0eBtxGDHg8ZT3NzAmsRlEg9zdAPV4MrqF05obfka/N9jaYCko0HVbeSxqLUonwwzRfEUSVjgSjbT4yiet9n3ZzR86bR82exkoGtplxXze1gZnDNN5VyRvqqUAWhC5XF4m2l6f5y+DIoco2NiTQRDtckkog3lsv7Tmrp5pq1pc0o+Koj0SzRrb2A8wChD2w9VRPlu9iyPhMfdTATPQjlrgnlLKXgdc7hzykDGR1z7Brt8gI9aI6YPgt3nI9veOm0bgEG3KomyJdVL4DlIfCu6JNclQjre5+j99fx81jw3nP1j174Ke4JTQ+eroUDeWOEVoHHnJ1+KQos5z0WqkDJETTQPW4VStXXx0y37qqa2Uxpr/FMa7y+Znn8rFU6mxuOmmvnvt12Cifu5vOGWwBeEOhN1FPJKfSSHFoUIezXpPd45jG/3Ope8z25NxpufJLRKQyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(30864003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jTzXwMbOR09XATqkwFeWpV8AO/RrKKPvklk+S8s6joAu4I1dlGSfECW4/NI0?=
 =?us-ascii?Q?9nzjyqUNjXjdfR1SBYAqjo+sH4CKsnigEIrEILxPsJ0TcpO/OJScuYR2zVKY?=
 =?us-ascii?Q?gXGmBNElCAsj7x4HjYtc+z9fnSZR3ECb67tYXNcuDkE2cY/z8cM6ctj1bozp?=
 =?us-ascii?Q?5hCCobjCaCE0YFdnZJ4sh5AbW9GH2lITi1XiRqLwYrr99AGnvALj0pab96ie?=
 =?us-ascii?Q?KfysV0vgL0wD3QRwqqNueR/DOHqOr2VCjvL+Otbd13a6k+DbgdMIwOmJTGpw?=
 =?us-ascii?Q?3C9myo5uDHzGf4JFPoUgNDnjGEVTAJK9ulY4Ds7LIaSiAS1DF0hJYzX6MutJ?=
 =?us-ascii?Q?4EZFMAFvaMEK/1wxbJGEGaA3te0Ktj+L6Gax2+IoEyUX2PB+NZxsRwO37GN6?=
 =?us-ascii?Q?3xiGBT8a8T73KZMzi5uXPy4MlSBZ+pkouIA2kydslFAQnIm6/uV9A68Jajic?=
 =?us-ascii?Q?WmeKdIu6OAUTLwp/Y7GuJM2AW/nkO+hyMV1McGzBV8H5jp7hmGXHkNwLDbNn?=
 =?us-ascii?Q?MPsK7uBGUz0FZjB8/+CliR6U/WSFy8qxE6ew0XIJuJ9j9oOtXEeNyQof2+yU?=
 =?us-ascii?Q?3xnsJDOusdxkzTKRUincOCKq5y95XTuOYrPrv8I6jxMP/CcoOeHMClhEFT9U?=
 =?us-ascii?Q?QbfdHGIc+GNd5Nt8t/tYtYyBj68a//gI8B11RE8a9W5bqIjOL0x9Q32lIXFB?=
 =?us-ascii?Q?9wQb4TcM2lHMhePKK1RdkgJjwCgzhagP8EM7MmEztpRbQl0jp+28+9YCA+m1?=
 =?us-ascii?Q?XEc5c5t2nGdgNhKAkDIt6eDmmIe/pixoRwiv0HAzn8qcUCcobMgm/NPqE4hg?=
 =?us-ascii?Q?sRjXb0IeofwNSrKn93U6//+HBPfFa08ompWG4NE9xN9wS1ObNEPicznf9kYL?=
 =?us-ascii?Q?EgYDGOMvdm2FMnqUgmOayzLESc/vPEdZAYRJQnYAUPwN9faTFGvbB6DcHDHX?=
 =?us-ascii?Q?/PM7MrNYngSgHcFNjASfJItcagA1wZ0fy85AFwpopwRwyH5+jiZn3oFbdgfs?=
 =?us-ascii?Q?whPgIAY2D/MS4BX5icBgz8I+hm2zFeLFEa/MHh9fGIzIj517qIua0IQAYhRa?=
 =?us-ascii?Q?Y8oA40fD0O4MKyZfK8I9ql5Vw+VHezIS266l2tFnzoCVLwqmI1BZVFUEDn73?=
 =?us-ascii?Q?9a5DyvU6gQl7wyn2iJ2CAw7U3neEC/ISQS2907mVjjJX7FLGevbGuPsTfDzW?=
 =?us-ascii?Q?JbjNBG8YKMaCHEwlskYqKFiN9JK/k/i5+SWcksbovL4tZFzMu2P3ghgq4yfd?=
 =?us-ascii?Q?KCJuXgN/fB/VBxD3fSJuoijUbJ3aU9yURh5/Tdn7WxBVQgT2GUEZ7N/vMBj3?=
 =?us-ascii?Q?6+PDS854KCFLYP0v5OZOAWPF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76058b42-a010-42b4-eca7-08d8f6f7a0f8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:29.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwJzjg/o1Qrp+r4iqORgErBy6IXBkIYZP8DkNnucuh6g85CQHSrLaNgm0bNuHvtiQS+1z9hgXqhVJbqzYOms3+28Ba7OTxZgC+uuKz+52iU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: G7WippQAM1XaoTMbobOhOk1WhL_RW026
X-Proofpoint-GUID: G7WippQAM1XaoTMbobOhOk1WhL_RW026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The back_lock is no longer used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c |  11 ----
 drivers/scsi/bnx2i/bnx2i_hwi.c  |  46 ++++---------
 drivers/scsi/libiscsi.c         |  41 +++---------
 drivers/scsi/qedi/qedi_fw.c     | 112 ++++++++++----------------------
 include/scsi/libiscsi.h         |   6 --
 5 files changed, 58 insertions(+), 158 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9f1f8b95a2f7..e8e01b83965d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1339,8 +1339,6 @@ static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
 static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 			     struct beiscsi_hba *phba, struct sol_cqe *psol)
 {
-	struct iscsi_conn *conn = beiscsi_conn->conn;
-	struct iscsi_session *session = conn->session;
 	struct common_sol_cqe csol_cqe = {0};
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
@@ -1376,9 +1374,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	if (!task)
 		return;
 
-	spin_lock_bh(&session->back_lock);
 	type = ((struct beiscsi_io_task *)task->dd_data)->wrb_type;
-
 	switch (type) {
 	case HWH_TYPE_IO:
 	case HWH_TYPE_IO_RD:
@@ -1417,7 +1413,6 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		break;
 	}
 
-	spin_unlock_bh(&session->back_lock);
 	iscsi_put_task(task);
 }
 
@@ -1610,7 +1605,6 @@ beiscsi_hdl_fwd_pdu(struct beiscsi_conn *beiscsi_conn,
 		    struct hd_async_context *pasync_ctx,
 		    u16 cri)
 {
-	struct iscsi_session *session = beiscsi_conn->conn->session;
 	struct hd_async_handle *pasync_handle, *plast_handle;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	void *phdr = NULL, *pdata = NULL;
@@ -1651,9 +1645,7 @@ beiscsi_hdl_fwd_pdu(struct beiscsi_conn *beiscsi_conn,
 			    pasync_ctx->async_entry[cri].wq.bytes_needed,
 			    pasync_ctx->async_entry[cri].wq.bytes_received);
 	}
-	spin_lock_bh(&session->back_lock);
 	status = beiscsi_complete_pdu(beiscsi_conn, phdr, pdata, dlen);
-	spin_unlock_bh(&session->back_lock);
 	beiscsi_hdl_purge_handles(phba, pasync_ctx, cri);
 	return status;
 }
@@ -4325,7 +4317,6 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	struct hwi_wrb_context *pwrb_context = NULL;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct iscsi_task *task = beiscsi_conn->task;
-	struct iscsi_session *session = task->conn->session;
 	u32 doorbell = 0;
 
 	/*
@@ -4333,9 +4324,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	 * login/startup related tasks.
 	 */
 	beiscsi_conn->login_in_progress = 0;
-	spin_lock_bh(&session->back_lock);
 	beiscsi_cleanup_task(task);
-	spin_unlock_bh(&session->back_lock);
 
 	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid,
 				       &pwrb_context);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index af03ad7bc941..f41f9f5fe6cc 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1415,10 +1415,8 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 	}
 
 done:
-	spin_lock_bh(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
-			     conn->data, datalen);
-	spin_unlock_bh(&session->back_lock);
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
+			   conn->data, datalen);
 	iscsi_put_task(task);
 fail:
 	return 0;
@@ -1483,11 +1481,9 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 		}
 	}
 
-	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
 		bnx2i_conn->gen_pdu.resp_buf,
 		bnx2i_conn->gen_pdu.resp_wr_ptr - bnx2i_conn->gen_pdu.resp_buf);
-	spin_unlock(&session->back_lock);
 	iscsi_put_task(task);
 done:
 	return 0;
@@ -1544,12 +1540,10 @@ static int bnx2i_process_text_resp(struct iscsi_session *session,
 			bnx2i_conn->gen_pdu.resp_wr_ptr++;
 		}
 	}
-	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
-			     bnx2i_conn->gen_pdu.resp_buf,
-			     bnx2i_conn->gen_pdu.resp_wr_ptr -
-			     bnx2i_conn->gen_pdu.resp_buf);
-	spin_unlock(&session->back_lock);
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
+			   bnx2i_conn->gen_pdu.resp_buf,
+			   bnx2i_conn->gen_pdu.resp_wr_ptr -
+			   bnx2i_conn->gen_pdu.resp_buf);
 	iscsi_put_task(task);
 done:
 	return 0;
@@ -1587,9 +1581,7 @@ static int bnx2i_process_tmf_resp(struct iscsi_session *session,
 	resp_hdr->itt = task->hdr->itt;
 	resp_hdr->response = tmf_cqe->response;
 
-	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
-	spin_unlock(&session->back_lock);
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 	iscsi_put_task(task);
 done:
 	return 0;
@@ -1633,10 +1625,7 @@ static int bnx2i_process_logout_resp(struct iscsi_session *session,
 	resp_hdr->t2wait = cpu_to_be32(logout->time_to_wait);
 	resp_hdr->t2retain = cpu_to_be32(logout->time_to_retain);
 
-	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
-	spin_unlock(&session->back_lock);
-
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 	iscsi_put_task(task);
 
 	bnx2i_conn->ep->state = EP_STATE_LOGOUT_RESP_RCVD;
@@ -1727,10 +1716,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 		memcpy(&hdr->lun, nop_in->lun, 8);
 	}
 done:
-	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
-	spin_unlock(&session->back_lock);
-
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
 	if (task)
 		iscsi_put_task(task);
 
@@ -1765,7 +1751,6 @@ static void bnx2i_process_async_mesg(struct iscsi_session *session,
 		return;
 	}
 
-	spin_lock(&session->back_lock);
 	resp_hdr = (struct iscsi_async *) &bnx2i_conn->gen_pdu.resp_hdr;
 	memset(resp_hdr, 0, sizeof(struct iscsi_hdr));
 	resp_hdr->opcode = async_cqe->op_code;
@@ -1782,9 +1767,8 @@ static void bnx2i_process_async_mesg(struct iscsi_session *session,
 	resp_hdr->param2 = cpu_to_be16(async_cqe->param2);
 	resp_hdr->param3 = cpu_to_be16(async_cqe->param3);
 
-	__iscsi_complete_pdu(bnx2i_conn->cls_conn->dd_data,
-			     (struct iscsi_hdr *)resp_hdr, NULL, 0);
-	spin_unlock(&session->back_lock);
+	iscsi_complete_pdu(bnx2i_conn->cls_conn->dd_data,
+			   (struct iscsi_hdr *)resp_hdr, NULL, 0);
 }
 
 
@@ -1811,7 +1795,6 @@ static void bnx2i_process_reject_mesg(struct iscsi_session *session,
 	} else
 		bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
 
-	spin_lock(&session->back_lock);
 	hdr = (struct iscsi_reject *) &bnx2i_conn->gen_pdu.resp_hdr;
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode = reject->op_code;
@@ -1820,9 +1803,8 @@ static void bnx2i_process_reject_mesg(struct iscsi_session *session,
 	hdr->max_cmdsn = cpu_to_be32(reject->max_cmd_sn);
 	hdr->exp_cmdsn = cpu_to_be32(reject->exp_cmd_sn);
 	hdr->ffffffff = cpu_to_be32(RESERVED_ITT);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, conn->data,
-			     reject->data_length);
-	spin_unlock(&session->back_lock);
+	iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, conn->data,
+			   reject->data_length);
 }
 
 /**
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dbff0ed10e1f..e7d1b69c07b5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -538,8 +538,6 @@ static void iscsi_finish_task(struct iscsi_task *task, int state)
  *
  * This is used when drivers do not need or cannot perform
  * lower level pdu processing.
- *
- * Called with session back_lock
  */
 void iscsi_complete_scsi_task(struct iscsi_task *task,
 			      uint32_t exp_cmdsn, uint32_t max_cmdsn)
@@ -831,7 +829,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
  * @datalen: len of buffer
  *
  * iscsi_cmd_rsp sets up the scsi_cmnd fields based on the PDU and
- * then completes the command and task. called under back_lock
+ * then completes the command and task.
  **/
 static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       struct iscsi_task *task, char *data,
@@ -929,7 +927,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  * @task: scsi command task
  *
  * iscsi_data_in_rsp sets up the scsi_cmnd fields based on the data received
- * then completes the command and task. called under back_lock
+ * then completes the command and task.
  **/
 static void
 iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
@@ -1033,7 +1031,7 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
  * @datalen: length of data
  *
  * iscsi_nop_out_rsp handles nop response from use or
- * from user space. called under back_lock
+ * from user space.
  **/
 static int iscsi_nop_out_rsp(struct iscsi_task *task,
 			     struct iscsi_nopin *nop, char *data, int datalen)
@@ -1103,13 +1101,10 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 * nop-out in response to target's nop-out rejected.
 			 * Just resend.
 			 */
-			/* In RX path we are under back lock */
-			spin_unlock(&conn->session->back_lock);
-			spin_lock(&conn->session->frwd_lock);
+			spin_lock_bh(&conn->session->frwd_lock);
 			iscsi_send_nopout(conn,
 					  (struct iscsi_nopin*)&rejected_pdu);
-			spin_unlock(&conn->session->frwd_lock);
-			spin_lock(&conn->session->back_lock);
+			spin_unlock_bh(&conn->session->frwd_lock);
 		} else {
 			struct iscsi_task *task;
 			/*
@@ -1184,17 +1179,16 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
 
 /**
- * __iscsi_complete_pdu - complete pdu
+ * iscsi_complete_pdu - complete pdu
  * @conn: iscsi conn
  * @hdr: iscsi header
  * @data: data buffer
  * @datalen: len of data buffer
  *
  * Completes pdu processing by freeing any resources allocated at
- * queuecommand or send generic. session back_lock must be held and verify
- * itt must have been called.
+ * queuecommand or send generic.
  */
-int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, int datalen)
 {
 	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
@@ -1238,7 +1232,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	iscsi_put_task(task);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
+EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
 
 /**
  * iscsi_complete_task - complete iscsi task
@@ -1254,8 +1248,6 @@ EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
  * This function should be used by drivers that do not use the libiscsi
  * itt for the PDU that was sent to the target and has access to the
  * iscsi_task struct directly.
- *
- * Session back_lock must be held.
  */
 int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 			struct iscsi_hdr *hdr, char *data, int datalen)
@@ -1280,11 +1272,9 @@ int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 				break;
 
 			/* In RX path we are under back lock */
-			spin_unlock(&session->back_lock);
 			spin_lock(&session->frwd_lock);
 			iscsi_send_nopout(conn, (struct iscsi_nopin*)hdr);
 			spin_unlock(&session->frwd_lock);
-			spin_lock(&session->back_lock);
 			break;
 		case ISCSI_OP_REJECT:
 			rc = iscsi_handle_reject(conn, hdr, data, datalen);
@@ -1365,18 +1355,6 @@ int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_task);
 
-int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-		       char *data, int datalen)
-{
-	int rc;
-
-	spin_lock(&conn->session->back_lock);
-	rc = __iscsi_complete_pdu(conn, hdr, data, datalen);
-	spin_unlock(&conn->session->back_lock);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
-
 int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
@@ -3068,7 +3046,6 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	mutex_init(&session->eh_mutex);
 	spin_lock_init(&session->mgmt_lock);
 	spin_lock_init(&session->frwd_lock);
-	spin_lock_init(&session->back_lock);
 	spin_lock_init(&session->back_cmdsn_lock);
 
 	/* initialize mgmt task pool */
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 53099d560eed..7b66b573882f 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -31,13 +31,11 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
 	struct iscsi_logout_rsp *resp_hdr;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_logout_response_hdr *cqe_logout_response;
 	struct qedi_cmd *cmd;
 
 	cmd = (struct qedi_cmd *)task->dd_data;
 	cqe_logout_response = &cqe->cqe_common.iscsi_hdr.logout_response;
-	spin_lock(&session->back_lock);
 	resp_hdr = (struct iscsi_logout_rsp *)&qedi_conn->gen_pdu.resp_hdr;
 	memset(resp_hdr, 0, sizeof(struct iscsi_hdr));
 	resp_hdr->opcode = cqe_logout_response->opcode;
@@ -55,7 +53,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -66,13 +64,11 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 			  cmd->task_id, qedi_conn->iscsi_conn_id,
 			  &cmd->io_cmd);
 	}
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
 	iscsi_complete_task(conn, task, (struct iscsi_hdr *)resp_hdr, NULL, 0);
-
-	spin_unlock(&session->back_lock);
 }
 
 static void qedi_process_text_resp(struct qedi_ctx *qedi,
@@ -81,7 +77,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 				   struct qedi_conn *qedi_conn)
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct e4_iscsi_task_context *task_ctx;
 	struct iscsi_text_rsp *resp_hdr_ptr;
 	struct iscsi_text_response_hdr *cqe_text_response;
@@ -92,7 +87,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	task_ctx = qedi_get_task_mem(&qedi->tasks, cmd->task_id);
 
 	cqe_text_response = &cqe->cqe_common.iscsi_hdr.text_response;
-	spin_lock(&session->back_lock);
 	resp_hdr_ptr =  (struct iscsi_text_rsp *)&qedi_conn->gen_pdu.resp_hdr;
 	memset(resp_hdr_ptr, 0, sizeof(struct iscsi_hdr));
 	resp_hdr_ptr->opcode = cqe_text_response->opcode;
@@ -118,7 +112,7 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -129,7 +123,7 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 			  cmd->task_id, qedi_conn->iscsi_conn_id,
 			  &cmd->io_cmd);
 	}
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
@@ -138,7 +132,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 			    qedi_conn->gen_pdu.resp_buf,
 			    (qedi_conn->gen_pdu.resp_wr_ptr -
 			     qedi_conn->gen_pdu.resp_buf));
-	spin_unlock(&session->back_lock);
 }
 
 static void qedi_tmf_resp_work(struct work_struct *work)
@@ -166,11 +159,8 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	iscsi_unblock_session(session->cls_session);
 	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 
-	spin_lock(&session->back_lock);
 	iscsi_complete_task(conn, qedi_cmd->task,
 			    (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-	spin_unlock(&session->back_lock);
-
 exit_tmf_resp:
 	kfree(resp_hdr_ptr);
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
@@ -183,7 +173,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tmf_response_hdr *cqe_tmp_response;
 	struct iscsi_tm_rsp *resp_hdr_ptr;
 	struct iscsi_tm *tmf_hdr;
@@ -200,7 +189,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 		return;
 	}
 
-	spin_lock(&session->back_lock);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 	memset(resp_hdr_ptr, 0, sizeof(struct iscsi_tm_rsp));
 
@@ -219,13 +207,13 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 
 	tmf_hdr = (struct iscsi_tm *)qedi_cmd->task->hdr;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	if (likely(qedi_cmd->io_cmd_in_list)) {
 		qedi_cmd->io_cmd_in_list = false;
 		list_del_init(&qedi_cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
@@ -235,7 +223,7 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	      ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_resp_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
-		goto unblock_sess;
+		return;
 	}
 
 	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
@@ -243,9 +231,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	iscsi_complete_task(conn, qedi_cmd->task,
 			    (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
-
-unblock_sess:
-	spin_unlock(&session->back_lock);
 }
 
 static void qedi_process_login_resp(struct qedi_ctx *qedi,
@@ -254,7 +239,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 				    struct qedi_conn *qedi_conn)
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct e4_iscsi_task_context *task_ctx;
 	struct iscsi_login_rsp *resp_hdr_ptr;
 	struct iscsi_login_response_hdr *cqe_login_response;
@@ -266,7 +250,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 	cqe_login_response = &cqe->cqe_common.iscsi_hdr.login_response;
 	task_ctx = qedi_get_task_mem(&qedi->tasks, cmd->task_id);
 
-	spin_lock(&session->back_lock);
 	resp_hdr_ptr =  (struct iscsi_login_rsp *)&qedi_conn->gen_pdu.resp_hdr;
 	memset(resp_hdr_ptr, 0, sizeof(struct iscsi_login_rsp));
 	resp_hdr_ptr->opcode = cqe_login_response->opcode;
@@ -286,13 +269,13 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	memset(task_ctx, '\0', sizeof(*task_ctx));
 
@@ -301,7 +284,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 			    (qedi_conn->gen_pdu.resp_wr_ptr -
 			     qedi_conn->gen_pdu.resp_buf));
 
-	spin_unlock(&session->back_lock);
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
@@ -404,7 +386,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 				   struct qedi_conn *qedi_conn, u16 que_idx)
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_nop_in_hdr *cqe_nop_in;
 	struct iscsi_nopin *hdr;
 	struct qedi_cmd *cmd;
@@ -414,7 +395,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 	char bdq_data[QEDI_BDQ_BUF_SIZE];
 	unsigned long flags;
 
-	spin_lock_bh(&session->back_lock);
 	cqe_nop_in = &cqe->cqe_common.iscsi_hdr.nop_in;
 
 	pdu_len = cqe_nop_in->hdr_second_dword &
@@ -450,22 +430,20 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cmd->task_id, qedi_conn->iscsi_conn_id);
 		cmd->state = RESPONSE_RECEIVED;
-		spin_lock(&qedi_conn->list_lock);
+		spin_lock_bh(&qedi_conn->list_lock);
 		if (likely(cmd->io_cmd_in_list)) {
 			cmd->io_cmd_in_list = false;
 			list_del_init(&cmd->io_cmd);
 			qedi_conn->active_cmd_count--;
 		}
 
-		spin_unlock(&qedi_conn->list_lock);
+		spin_unlock_bh(&qedi_conn->list_lock);
 		qedi_clear_task_idx(qedi, cmd->task_id);
 	}
 
 done:
 	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, bdq_data,
 			    pdu_len);
-
-	spin_unlock_bh(&session->back_lock);
 	return tgt_async_nop;
 }
 
@@ -475,7 +453,6 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 				    u16 que_idx)
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_async_msg_hdr *cqe_async_msg;
 	struct iscsi_async *resp_hdr;
 	u32 lun[2];
@@ -483,8 +460,6 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 	char bdq_data[QEDI_BDQ_BUF_SIZE];
 	unsigned long flags;
 
-	spin_lock_bh(&session->back_lock);
-
 	cqe_async_msg = &cqe->cqe_common.iscsi_hdr.async_msg;
 	pdu_len = cqe_async_msg->hdr_second_dword &
 		ISCSI_ASYNC_MSG_HDR_DATA_SEG_LEN_MASK;
@@ -518,8 +493,6 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 
 	iscsi_complete_task(conn, NULL, (struct iscsi_hdr *)resp_hdr, bdq_data,
 			    pdu_len);
-
-	spin_unlock_bh(&session->back_lock);
 }
 
 static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
@@ -528,13 +501,11 @@ static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 				     uint16_t que_idx)
 {
 	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_reject_hdr *cqe_reject;
 	struct iscsi_reject *hdr;
 	u32 pld_len, num_bdqs;
 	unsigned long flags;
 
-	spin_lock_bh(&session->back_lock);
 	cqe_reject = &cqe->cqe_common.iscsi_hdr.reject;
 	pld_len = cqe_reject->hdr_second_dword &
 		  ISCSI_REJECT_HDR_DATA_SEG_LEN_MASK;
@@ -560,7 +531,6 @@ static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 
 	iscsi_complete_task(conn, NULL, (struct iscsi_hdr *)hdr, conn->data,
 			    pld_len);
-	spin_unlock_bh(&session->back_lock);
 }
 
 static void qedi_scsi_completion(struct qedi_ctx *qedi,
@@ -570,7 +540,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 {
 	struct scsi_cmnd *sc_cmd;
 	struct qedi_cmd *cmd = task->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_scsi_rsp *hdr;
 	struct iscsi_data_in_hdr *cqe_data_in;
 	int datalen = 0;
@@ -585,33 +554,32 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 	cqe_err_bits =
 		cqe->cqe_common.error_bitmap.error_bits.cqe_error_status_bits;
 
-	spin_lock_bh(&session->back_lock);
 	/* get the scsi command */
 	sc_cmd = cmd->scsi_cmd;
 
 	if (!sc_cmd) {
 		QEDI_WARN(&qedi->dbg_ctx, "sc_cmd is NULL!\n");
-		goto error;
+		return;
 	}
 
 	if (!task->sc) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "SCp.ptr is NULL, returned in another context.\n");
-		goto error;
+		return;
 	}
 
 	if (!sc_cmd->request) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "sc_cmd->request is NULL, sc_cmd=%p.\n",
 			  sc_cmd);
-		goto error;
+		return;
 	}
 
 	if (!sc_cmd->request->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
 			  sc_cmd);
-		goto error;
+		return;
 	}
 
 	qedi_iscsi_unmap_sg_list(cmd);
@@ -646,13 +614,13 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		hdr->flags &= (~ISCSI_FLAG_CMD_OVERFLOW);
 	}
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 		  "Freeing tid=0x%x for cid=0x%x\n",
@@ -664,8 +632,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 	qedi_clear_task_idx(qedi, cmd->task_id);
 	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, conn->data,
 			    datalen);
-error:
-	spin_unlock_bh(&session->back_lock);
 }
 
 static void qedi_mtask_completion(struct qedi_ctx *qedi,
@@ -783,13 +749,13 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 		qedi_clear_task_idx(qedi_conn->qedi, rtid);
 
-		spin_lock(&qedi_conn->list_lock);
+		spin_lock_bh(&qedi_conn->list_lock);
 		if (likely(dbg_cmd->io_cmd_in_list)) {
 			dbg_cmd->io_cmd_in_list = false;
 			list_del_init(&dbg_cmd->io_cmd);
 			qedi_conn->active_cmd_count--;
 		}
-		spin_unlock(&qedi_conn->list_lock);
+		spin_unlock_bh(&qedi_conn->list_lock);
 		qedi_cmd->state = CLEANUP_RECV;
 		wake_up_interruptible(&qedi_conn->wait_queue);
 	} else if (qedi_conn->cmd_cleanup_req > 0) {
@@ -1070,11 +1036,11 @@ int qedi_send_iscsi_login(struct qedi_conn *qedi_conn,
 	if (rval)
 		return -1;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
 	qedi_cmd->io_cmd_in_list = true;
 	qedi_conn->active_cmd_count++;
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	qedi_ring_doorbell(qedi_conn);
 	return 0;
@@ -1143,11 +1109,11 @@ int qedi_send_iscsi_logout(struct qedi_conn *qedi_conn,
 	if (rval)
 		return -1;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
 	qedi_cmd->io_cmd_in_list = true;
 	qedi_conn->active_cmd_count++;
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	qedi_ring_doorbell(qedi_conn);
 	return 0;
@@ -1162,8 +1128,6 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 	struct iscsi_tm *tmf_hdr;
 	unsigned int lun = 0;
 	bool lun_reset = false;
-	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 
 	/* From recovery, task is NULL or from tmf resp valid task */
 	if (task) {
@@ -1184,10 +1148,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 		  qedi_conn->active_cmd_count, qedi_conn->iscsi_conn_id,
 		  in_recovery, lun_reset);
 
-	if (lun_reset)
-		spin_lock_bh(&session->back_lock);
-
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 
 	list_for_each_entry_safe(cmd, cmd_tmp, &qedi_conn->active_cmd_list,
 				 io_cmd) {
@@ -1218,10 +1179,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 			  &cmd->io_cmd, qedi_conn->iscsi_conn_id);
 	}
 
-	spin_unlock(&qedi_conn->list_lock);
-
-	if (lun_reset)
-		spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
 		  "cmd_cleanup_req=%d, cid=0x%x\n",
@@ -1392,13 +1350,13 @@ int qedi_fw_cleanup_cmd(struct iscsi_task *ctask)
 	}
 	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	return -1;
 }
@@ -1500,11 +1458,11 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 	if (rval)
 		return -1;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
 	qedi_cmd->io_cmd_in_list = true;
 	qedi_conn->active_cmd_count++;
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	qedi_ring_doorbell(qedi_conn);
 	return 0;
@@ -1599,11 +1557,11 @@ int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
 	if (rval)
 		return -1;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
 	qedi_cmd->io_cmd_in_list = true;
 	qedi_conn->active_cmd_count++;
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	qedi_ring_doorbell(qedi_conn);
 	return 0;
@@ -1669,11 +1627,11 @@ int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
 		nop_out_pdu_header.itt = tid;
 		nop_out_pdu_header.ttt = ISCSI_TTT_ALL_ONES;
 
-		spin_lock(&qedi_conn->list_lock);
+		spin_lock_bh(&qedi_conn->list_lock);
 		list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
 		qedi_cmd->io_cmd_in_list = true;
 		qedi_conn->active_cmd_count++;
-		spin_unlock(&qedi_conn->list_lock);
+		spin_unlock_bh(&qedi_conn->list_lock);
 	}
 
 	/* Fill tx AHS and rx buffer */
@@ -2093,11 +2051,11 @@ int qedi_iscsi_send_ioreq(struct iscsi_task *task)
 	if (rval)
 		return -1;
 
-	spin_lock(&qedi_conn->list_lock);
+	spin_lock_bh(&qedi_conn->list_lock);
 	list_add_tail(&cmd->io_cmd, &qedi_conn->active_cmd_list);
 	cmd->io_cmd_in_list = true;
 	qedi_conn->active_cmd_count++;
-	spin_unlock(&qedi_conn->list_lock);
+	spin_unlock_bh(&qedi_conn->list_lock);
 
 	qedi_ring_doorbell(qedi_conn);
 	return 0;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 3715b3d20890..8001c5a26a00 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -349,16 +349,10 @@ struct iscsi_session {
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
 	struct iscsi_conn	*leadconn;	/* leading connection */
-	/* Between the forward and the backward locks exists a strict locking
-	 * hierarchy. The mutual exclusion zone protected by the forward lock
-	 * can enclose the mutual exclusion zone protected by the backward lock
-	 * but not vice versa.
-	 */
 	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
 						 * cmdsn, suspend_bit,     *
 						 * leadconn, _stage,       *
 						 * tmf_state and queues    */
-	spinlock_t		back_lock;
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
-- 
2.25.1

