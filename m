Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F1DC43460
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235CD6144A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhDXWHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhDXWHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6JL4005145;
        Sat, 24 Apr 2021 22:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=0WpFiECF1DChCBeoJKNdQaZAr6+kpgCVP9s2jRzxvFQ=;
 b=eD37Tn0i03qsAt5Togbv2ygZjt5Yi+9k1qvTKATT0SttYOdVX9sXVhPXAmtWRBTSgT1w
 c7l+gBvqZFkZBSUoG+zTyxE4OFLRdhrjUd5QtuNxGAn6DhaD7Iz/a9uciwVPm1asKJfG
 U7POFKT9LU7ugUSheAA8X/DeZc4svFk8XItu6XJPu8HXnbZMDvy6qosHM0/XvquTMDL9
 sBA2EldGje+mcXLbOS+MFF4UoeZTr/ZQ9O5qEtnzwXVx3ve/GPJQ9eMAuMfEWmSU1kKj
 qUMJMhZ4JUJ3Am/rn34cUg1E/B4Ao1//L3k2333i/vOSuasKFwr7hWPDFKMVLquntQ3N WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 384byp0rkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Caf045579;
        Sat, 24 Apr 2021 22:06:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 384anj7ut9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1RjOaNoxImTeTb9NhrOVSKPc+4BnGYXlmqeCdQugzuBynwmNGAadLCjI40cuQCGSPAKvsI01Bazs0UDiwH3ooWmRWirtZOeaLM+V/2Ykc64ReEh4gof0Tjg30NwPVlzmsiXL7XzRP/0k6QzG5sDllx+BmkYlMcdwQvSJ8QZO/IIaeGVduaHFjzr9MOSQbYN3U9b1IUKQAvZ3Sk6KtdtSyBkBLvhsFRFuZeYGKAdCKCxh+fXfP2ZERLNzzVNgWnn7hvQuygUhL26jrS2r2k0gksrx+VKEHwW3bWi3PcH37TdyFr9Z8j1SA8Mbg5PPiKxZOHf/K+EDfMb1F3vNE3bcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WpFiECF1DChCBeoJKNdQaZAr6+kpgCVP9s2jRzxvFQ=;
 b=kUO6TTTWSr70x1XkibgJFi04fUSt/+hBCga28EFsVWilsaRCoUeChWy9Vo2hvPVH/jPmrJUjFdB4+eoyZtJ9uimVbkjs7/HvZ3LqngWZ7V/F+nKGvib0By+J0845TJfffQ10EFtQvUluoyUkEzJB6rYc7FsrmUZOpIYjryt0n6sKabDBfCgY13FZSOJcGXLvsNpEFeDlNE8N9NMASvPa6+Cw+zyJdD4+E+GjMm0elduxIfITn5l+QhW5Ns7q8vU71vLreJc1pvl3GIy8WQtkfJ+x42r7TTchTDgKCJMML03SepgxdAUQWSpVFd3IGEDZK4IbLnn+GwQI57Q+I2+QTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WpFiECF1DChCBeoJKNdQaZAr6+kpgCVP9s2jRzxvFQ=;
 b=z9llzu5ouSxNGLnG+i1Les6RB/k7AguVIPvQSlAwN68YD+yX67TzCf2IXluqPTnS4ej7blHVntQWEF8ZZr18Th6FzJE7uV1wzdExsNW2Isf6xLnxKyWsFNlcGpN756nFACI5QfiFFOKfkifsU/8tp74E01GWwTN41XJ6h8t2zAE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 04/17] scsi: iscsi: drop suspend calls from ep_disconnect
Date:   Sat, 24 Apr 2021 17:05:50 -0500
Message-Id: <20210424220603.123703-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edf8c75f-0312-4cd0-4fb8-08d9076d2ebb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33177A5F8D55D285273DBBFEF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/QMBIUKGGJXL3RdEkVBEkXJJB77MhfBEbkF1Qz0NKB19WuPF/LvJxjoFiwDZcs4IQP8sLup6Mm0bsG/FfY0kdajwmDc3G6PQWWjDpWrCgCO/SfLgQWnT1vy2FNVnvQ3EEGm+Ky1nsFpAvBahgJe0qQfq2Nbk30DTQtJ9+/h2ALwO9uW9iMCqs31Bb1/8G9/w5Tp3VB03ot4N6TpEo/wQ1bFt1gdZQPyrBwNYynhA9o9DQASO7OsRzsNLH9AGqfk9OwbxA18jLxQydvXuWdY2B1Jyv4p2IbeO4PAgrDjktgV100NyRSOmffPeqd6sIElJdw84+7/k6RP1oSy+j5RFEGMrYPEHn9FhVIVrXbjwa5YCf2GaaVB/apkiaMxCFnmvHHD4k8C4saREr3MeodDDZJ0NVs+vCAakhHZH2MbMGZO/pGEPfZKnzmDf5lFDnTNIlPCcTFsBXntIE4W581Puppr0vpHDARVK2VqwbJ0URjxR/towgvr3b1abTqd+ktsqom/Bav5irztRwsgb0UV1QQE1Bja5zOdwXhQAy/tFjPQ2u9MZPzXO61eWPEr1lRubX8GXqTLdpV813GA9hfQC1urDx+L56FEGTTLrmZHdr/HXZbPHvnMqByiomDHpz7/yLfXYUOtNMhwlTTclUAhi8nv4MhxyjJIj3Kfa1NUu10a8rTeWxVOh9gV0zeJkwLI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(15650500001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IReujx/yihfN3wlVTumd0/mjtsebrXXEJZue2JGifABV05NFI1X/m8YGU8XX?=
 =?us-ascii?Q?971y83/UkMGEmzFPEKT7YmvVphR09XD5WIUkeyFNYTgKUHeLddrCjYes+AVB?=
 =?us-ascii?Q?zQ1t5D+xl4unTJjnYWsR5uI4LnIkktXjEPymK7/1De9U2T9UmIEk5/x7PboL?=
 =?us-ascii?Q?KR84a4Q1QttC9T1pzINCeOfHYOCVJGgTkgzT2bDXUQO/sOnQ1FbeQVEnz2kq?=
 =?us-ascii?Q?0NsKCh/j9f0bUKfGXHfNOlfFzl5VRzjQySPAj+bPyenK5ThQWuEBGeyBPLSV?=
 =?us-ascii?Q?R2RB/N+rdcnKyL/q5uEIw4ryfsWWfss/hsbNtLJM4Qmty+OQg/xyc7axY994?=
 =?us-ascii?Q?VS0bWNMnhN5RrfDKi5RegmZOZ50RLYJ5XaVB5IemBHF7s4O7de/Y99kdZ6Gd?=
 =?us-ascii?Q?PQriBZJKC/d+YfcQv6Tx9g3esfbcDmiOqhULkpYoK/xwu2lLQYWJ1pT4ARo6?=
 =?us-ascii?Q?wQPQMOQUqWgMhNHHBwNJdfkrMSkDLVlFfNCfzzyd/BzUBeix4u5VwOWQ6D1E?=
 =?us-ascii?Q?EUzCAe228mtMyrOzz6lVGOSm0aUZjjZPsvxdCGcFUe6FQSps6Kkf1O2Ksc4k?=
 =?us-ascii?Q?AJ8aAK3KWMXbPh70PFfBCcLqpdHansIBCONpjR8JKzi5juup+VXTO6DmGFJ0?=
 =?us-ascii?Q?o4KTBNRb8tRzuASfVOvRw//+Qyp0rG31jReJZc3lUTKrCxCCZU4Em4HTQ9Ra?=
 =?us-ascii?Q?xZL8j9qmsbNj57PONh4JgVhbvqSLuO/HcUcbJveQrAVIP2XOQObIHI/MmYRi?=
 =?us-ascii?Q?muvpkF0wRJDoET6BbjwqaMtdPEOezrvjRAZzOurC4JZZKzY15tcir44rgFa9?=
 =?us-ascii?Q?KT40R4Q11oQxA96vvjs4WZZpdfuFYJdcG7sD2XI7tj+R5el16CN8a3pVgc1X?=
 =?us-ascii?Q?enG69q0Ynhg7sOU1X+uRczfkRAxN5wKG24L0Uyc1bXPI3JAyUwuzVBV/NnVR?=
 =?us-ascii?Q?dcDZ/anSjq/AWe/MEarOOidhuvs0ln+Gnuu4OImPQXr/9/i7SKgabqbNyLaf?=
 =?us-ascii?Q?fdP/dklNX57R+kzZLT6YVcJD8OGJtuirfK9XXo4K/v20Guh+V5tjRiMWMnkv?=
 =?us-ascii?Q?k76NMc/bNI07Zen+/nTjCeH1mgbdDsEjA3zMvJQ+DSevR0m9vfepHCWggslm?=
 =?us-ascii?Q?YOTA8hzl4nhzvSyCSdqiPIvtmp090xAJsaODU5jivhkcKec6LXupYt1/Pdi9?=
 =?us-ascii?Q?8acBzhFFEzG4uaL+FFYDNQ4SNQXIzCVoDVkju9yYu9Oyg+dVUvlftZZV4G54?=
 =?us-ascii?Q?q3mUqoBywR39YFUzo+NzK+v5y7g5mNA/jNpkdgLwCMqo2IPC3yXq5Ai060Y4?=
 =?us-ascii?Q?3CXIx594GoYLT1qd3qUB8bvC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf8c75f-0312-4cd0-4fb8-08d9076d2ebb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:16.8402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeImv05wm9dgnmKrv3uazHtP+8XOmlwhfneECkzkfkYNcrd8B1e9fQwtndLkk9het3gQUk9nQDcwXkV3lkj9m8j3rBoTQlQ8vs/YpcGWoKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: 4ocWuNl4pcpR56xGV8JiQQAj4m_m3EQv
X-Proofpoint-GUID: 4ocWuNl4pcpR56xGV8JiQQAj4m_m3EQv
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libiscsi will now suspend the send/tx queue for the drivers so we can drop
it from the drivers ep_disconnect.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 6 ------
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 6 +-----
 drivers/scsi/cxgbi/libcxgbi.c    | 1 -
 drivers/scsi/qedi/qedi_iscsi.c   | 8 ++++----
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a13c203ef7a9..a03d0ebc2312 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1293,7 +1293,6 @@ static int beiscsi_conn_close(struct beiscsi_endpoint *beiscsi_ep)
 void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct beiscsi_endpoint *beiscsi_ep;
-	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_hba *phba;
 	uint16_t cri_index;
 
@@ -1312,11 +1311,6 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 		return;
 	}
 
-	if (beiscsi_ep->conn) {
-		beiscsi_conn = beiscsi_ep->conn;
-		iscsi_suspend_queue(beiscsi_conn->conn);
-	}
-
 	if (!beiscsi_hba_is_online(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : HBA in error 0x%lx\n", phba->state);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b6c1da46d582..9a4f4776a78a 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2113,7 +2113,6 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct bnx2i_endpoint *bnx2i_ep;
 	struct bnx2i_conn *bnx2i_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct bnx2i_hba *hba;
 
 	bnx2i_ep = ep->dd_data;
@@ -2126,11 +2125,8 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
 		msleep(250);
 
-	if (bnx2i_ep->conn) {
+	if (bnx2i_ep->conn)
 		bnx2i_conn = bnx2i_ep->conn;
-		conn = bnx2i_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
-	}
 	hba = bnx2i_ep->hba;
 
 	mutex_lock(&hba->net_dev_lock);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..215dd0eb3f48 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2968,7 +2968,6 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
 		ep, cep, cconn, csk, csk->state, csk->flags);
 
 	if (cconn && cconn->iconn) {
-		iscsi_suspend_tx(cconn->iconn);
 		write_lock_bh(&csk->callback_lock);
 		cep->csk->user_data = NULL;
 		cconn->cep = NULL;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ef16537c523c..30dc345b011c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -988,7 +988,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct qedi_endpoint *qedi_ep;
 	struct qedi_conn *qedi_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct qedi_ctx *qedi;
 	int ret = 0;
 	int wait_delay;
@@ -1007,8 +1006,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
-		conn = qedi_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
 		abrt_conn = qedi_conn->abrt_conn;
 
 		while (count--)	{
@@ -1621,8 +1618,11 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 	struct iscsi_conn *conn = session->leadconn;
 	struct qedi_conn *qedi_conn = conn->dd_data;
 
-	if (iscsi_is_session_online(cls_sess))
+	if (iscsi_is_session_online(cls_sess)) {
+		if (conn)
+			iscsi_suspend_queue(conn);
 		qedi_ep_disconnect(qedi_conn->iscsi_ep);
+	}
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-- 
2.25.1

