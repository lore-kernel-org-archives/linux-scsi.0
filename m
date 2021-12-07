Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3B1C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhLGCzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:10 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44990 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhLGCzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:01 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M56v3019273;
        Tue, 7 Dec 2021 02:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=mm+tnd27I62PkwCFrmS0IZJOW/0jGEC/8voBbiTgtAM=;
 b=qnz8NTnWvUzPhqwFMURsk4IYuTBrFa7H2PsarOK7UhVac4bzWyk+Pjwsnz5yAXL2855q
 f9jNY9aqQInHVpUfCjPDFddHCFEqioBlMTls/TBBNJV3ta6PUVOhx+p6idXAyC/e8uUZ
 030C390IvOJG6ZEhg28/wJGsKPTI1QWqR9n9HrsdfqVGB77MF2X8jJQsH9s7i4QTL6TU
 C33JAxULhLuC7jQh1CBGX0zjnfl2xEsd8xgRSPtFVg2auoRGYQtOcKGb8e96g95VbYg0
 SjhIWNAAlS9YGWzFUze67N+9+nBK0shL5R4KZjdJScVMRFldVMx7vukNzccvi5Z2JfI1 /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csbbqmef9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglX153019;
        Tue, 7 Dec 2021 02:51:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg81HeVUoEmV3HM0OhKJTdECzUjzKoxtmsY/Rz1r4Gkp6saWSE2vLImSwiAvTmgk55KrW4H0kfSrUmcP57mRxwSBrLrQPC/BHYIsO283/1uenwC/PcM7x57v28pVUkhPJypGGKXPeuRgWJbhItgIpWqVSg/Zf0wFqGC2yUv9EDIK365ZKsoQYo3vcLIMjUrjuQVlbLbVmIYcw+KwnR9KaLfc2Ts6BYdImJa1DjzkJaZ5ucUuUr9IXoATdjUyqkVzPX8LVvLmIBDou4gOGDPRExTU4tuWy8ObKfmzkLkG4en/s0xS4Hlin/sQw5tFlY5k+U7VNJo7Ms1eHhE7cT1xUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mm+tnd27I62PkwCFrmS0IZJOW/0jGEC/8voBbiTgtAM=;
 b=U7BSDhJglvyiCHC1lUEvvP/iGbICX7wdvqZqizmEjMkOuugnS93bcjAH8BJTXBgmfJQIrp7FYJ4AcT2tdSuSoouOfOYnA0cGME3wmezgfb1cbKpCx7ApBXYD7jeP4va3nuthaIZS9VAOOEOuKgC3eIXdraPY0orF43y0rhRIGZpIYpNx2hoJhKzmIDYNjOBSjiTC/tiky1AJ6HPxQc82OeKDYSyrKNn6sJMptzhIgWe60NmVWl03Qq8EPOeRDnT2EWrPFupzB60tUaSv15m0ldO1e8Ljm+c+Z29Q12GuVfLCF6Kbmx2LtEm7Zg36U64jn332UYLI55QvJZgCYhwjlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mm+tnd27I62PkwCFrmS0IZJOW/0jGEC/8voBbiTgtAM=;
 b=FGSiQV9UrzJa30MX6Ezz10t80W+v8fVPtCpiIw1eTnfla+G2RDP3hBq+zxsx/Id3iLvav80wCUCPPMt6GRBEwXa9i33ERGxfkxZPKYuQuzIpIiKmD4wJHrsvuy59e8UDTY8neHt9Z3NY4TpDfHhHf45FpYrXcPvrweGg2JmqHFE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 02/12] vhost, vhost-net: add helper to check if vq has work
Date:   Mon,  6 Dec 2021 20:51:07 -0600
Message-Id: <20211207025117.23551-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de5552e4-6c14-4095-aed0-08d9b92c762c
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347643300CE476E22EACC72F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9R7cr696L5PzYkRTVkR+n+pw0c4t5BTRPVrlqq4lTGcIYuj51yGsihClK8LtoXgNhn4mXSSI/O/wUaA6QMBBlkeW7feID8DKrBvRlaj/hStx2dW5qMcnrzzvsAsJMl0bx9+hL8UOx55WjJtgOZzPYbHN0M4AgWj8JLVtY3dWFtyFrDGh7fD+fCvXJ1+YNpF0LOjdwkSVoYVS3+2HyJXSYR7huahBYymB7jX51ZMLN+MZXNjaPPBkyLUdvWOpfJmqIlzMfk37pLaLeWyyBV9Nex4jDmdNdts8Kcme5iHAtwYCPOBUYW2DP1NSypyEibrZt3wSGx+naWt4aC2+19PMKNExl/8vmuQyYThZNAzzEOE6fkKUjdbFSk3QEZDZpMjyg+PdWUafMMtKykhqRKpqq7LCaIA76g8VmImiYCY/9qxgQk2SkyOFxMuJJZ2oCQUgiB+VDJN7G7G833OdGrMXCLyeA6OqZjZJ6wUBsCWTDlm0pQewTFaAD4hbl84vEcGLJ66uaaAlv+AyPg1XalF/zwHrB2icFTlUy9fvGRSlOUBlMG7PeEGF0BDFDJOpcqKSTYt2WCEKQZkqiUOqpUpJIRIPMk1yRCqhLFUL3+iCmMXCA55UWhznRcLX7o3DPlvOnMYNIshJK1us2DmgloDCpmDmhn2fKTdr5RjdJzOS4iVnVCPBvBcfcfNG00494fysnEifAA24ITW1Uq7DwTNqow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VhLc5srRCAa8WaFlFhji3XfW7fwnYwOqc8PSFU/GOD9dl1XteKbCxAVLR6BK?=
 =?us-ascii?Q?Ax8UKtTe+v+fOdm8H3Tzi8lqYQkku2t/sfn1NLcoIpk6tD8/4zuDpQv/Zb38?=
 =?us-ascii?Q?VOn9PrIz/mQAd73LwEBaVbZRSCG1EGF4+8mSZBszPEp547PZPWEHMj9MkZD6?=
 =?us-ascii?Q?/Z2WWDehYJbZ6tCG4wgRYrAWcEUS7IQ2RwaOEjs2Gi3WeQ94P8c+4MhefADe?=
 =?us-ascii?Q?qIZfVPvelm0xIosa4m61bCNODz1DOa2OyvYa/TXWl6uJcL+91A8G2z+Wvfk7?=
 =?us-ascii?Q?U5HFC/XNe+Gk95leMAZxUA28T3K3r+kzLq7bfyDJuegnWNU1BmxM7Xz9ihjO?=
 =?us-ascii?Q?dIASN/dQZ55ZZyTBHsR4I5xbMqdHkcuO1DBEFgUQXXNc0TJvQB+fX5vHvMkE?=
 =?us-ascii?Q?37a45YMawY/fErw1UA9mqtad5v0twyfTzlbCWCdua/2NPuAu9veNSX9D9OL7?=
 =?us-ascii?Q?EfCWv3FmssCk3a4dr5HHMtH3Or5d2Cw8q2qZ3NfYJdCRMST5HMbAmRKxpJzT?=
 =?us-ascii?Q?K7w98iV/FgL637nZOIjKgvT1BI97ruiXLGA0b27DNncl5aMRNrNFF5NNfZRY?=
 =?us-ascii?Q?yGYiwfk4ff8/Oc60wGyX4j8METzJr2aK6mJSKmLdyGssKLTFlhyfl7j0lyah?=
 =?us-ascii?Q?x3aMNhqBn7RGVNBvnAPZdXBNMG96eGH9g8U8lStfgUyeyMSjI4uUJQPO8WEI?=
 =?us-ascii?Q?xCxZkiOYczuwZIFIiL4r0BpqpWC5ioeP8Mz8UexwLGKk361eQpd4vgYd5Jw0?=
 =?us-ascii?Q?ITxYUDu3KK3byarw/Gtr2+zNHSO+iuYCq28GffsPHc2ksAzCFOVPkaInODtu?=
 =?us-ascii?Q?CpcDo1eh3Ai9iKOEvKxx29MmFHHb8wCGpTMyeIbF8J64eG5bfnQW8CjKPLKc?=
 =?us-ascii?Q?Z6Z553CCcxuaXqbb3Uy36LJr0brQgnTb1+8uD3JoB1+zc0tAizy1z8LreVF8?=
 =?us-ascii?Q?gchMfe4ALmaA8/6jKGwjOcqZSy/fPag8KiH9wyQX/ulhOTtUzsb/V/nitich?=
 =?us-ascii?Q?nvrgZ+sQaYkzKIFlVsi1zzLnbaRyO+lfG4EjaHdOGc5LllU34ksGQt8YYmlu?=
 =?us-ascii?Q?KT/ovGCa20m1pOn0VGHcY8ANIhwruMd4TEepJAQ/76HUdFoefYPN0w4BAUVN?=
 =?us-ascii?Q?gM0WYVs8h7E5BIUxMcWVE5v0pKPQCAOWW/A67whcdyO67dR18SaFZt3wY0X1?=
 =?us-ascii?Q?Z4zvlbuEx7fzwjODL+RHdVuYDevSy6mNe+zK1CQIaNWoHAYcUTmOdOU411uo?=
 =?us-ascii?Q?oI7ppgkbVT/Ldj7ReyU3nZi/yoyROVzK3rlMP58/dXFZx0LdXnkrYxEeFL/9?=
 =?us-ascii?Q?QrVIIE/R9BE1zMncizuX37tjxSmt57XJ8dCr8v3SYQW5RvO0qqxteekGjZLI?=
 =?us-ascii?Q?jR+nJ+E551HpwaVXrUp9OIrRHnMuDCz9c5DKXYht6/HWlDi3XL4gCMZbueN2?=
 =?us-ascii?Q?9LRE/atRr87K6OZYSpK1qftK/+nAreeh+YMHrczBkxfZfLCmQaM9F6rgJnuM?=
 =?us-ascii?Q?Qoqoi2ZwsDe7VodEO3HENvzCMMZtz71j3lRKTkcuY8MGye7gyjjEyey8S+gZ?=
 =?us-ascii?Q?28fMJY+uB7bW80DlJzGfE/mT4Yy9uMZxfTbfIVsJqzIpuRCPRmNU2gAXUmh2?=
 =?us-ascii?Q?UrEzxs4WwZMZEnqpGn40x4V0xgKr2cIdSNUHnp4pON198mA3+gqmaMjAqKTK?=
 =?us-ascii?Q?upEo5Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de5552e4-6c14-4095-aed0-08d9b92c762c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:26.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXKvWeYZ089nDYgcEy83YfUoRq2q5M4LiistznZKMHQevTMrenpzsVCDdGdxVn9HczqM+IbSi9fb93opTiPMxsF+S0UhHA+kJjJFI2pATGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: kWGfPVaZgfCNpTT6HXEE6Ije65hDEqC3
X-Proofpoint-ORIG-GUID: kWGfPVaZgfCNpTT6HXEE6Ije65hDEqC3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to check if a vq has work pending and converts
vhost-net to use it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   | 2 +-
 drivers/vhost/vhost.c | 6 +++---
 drivers/vhost/vhost.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b1feb5e0571e..f225cb9dcb10 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -543,7 +543,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	endtime = busy_clock() + busyloop_timeout;
 
 	while (vhost_can_busy_poll(endtime)) {
-		if (vhost_has_work(&net->dev)) {
+		if (vhost_vq_has_work(vq)) {
 			*busyloop_intr = true;
 			break;
 		}
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a314f050413a..2fe7c2e9f6ad 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -261,11 +261,11 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
 /* A lockless hint for busy polling code to exit the loop */
-bool vhost_has_work(struct vhost_dev *dev)
+bool vhost_vq_has_work(struct vhost_virtqueue *vq)
 {
-	return dev->worker && !llist_empty(&dev->worker->work_list);
+	return vq->worker && !llist_empty(&vq->worker->work_list);
 }
-EXPORT_SYMBOL_GPL(vhost_has_work);
+EXPORT_SYMBOL_GPL(vhost_vq_has_work);
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 31d074724fe8..f0f2fb334b13 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -50,7 +50,6 @@ struct vhost_poll {
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
-bool vhost_has_work(struct vhost_dev *dev);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev);
@@ -199,6 +198,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-- 
2.25.1

