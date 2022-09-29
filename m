Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EAEC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiI2CzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiI2Cy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08E527B05
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiSG6020728;
        Thu, 29 Sep 2022 02:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=suqDCWo8s+3gGmwA77bIU2xk+R+HOrcSjIdu5ABO2QQ=;
 b=jndYMPIky/Kn3FxnjSICZQf9f5smbb2rPb4O67xfsQ2jTi3TRzbZZxYySuUXYUQfrUTs
 J7MxzBOJkgy3vBbrxStCvumRsnpd2Ego10aHDPxQIuFAO+ajGV16LbNZ1AKbJsl6Uy1S
 mpJrlEGffXLJjIrzdhidxhZVtPK4XLr7wpGYfY+S42Wmi8y0Rx6cTh4endPn6kRJ53Ot
 1Rm3GS1NsVqmah+OKreFqxNv49MmKCW0vBLo8N9vNYPIQlSaJn9ZcnHAksfNOPBkydwk
 xvp4lBHfo6rAZaS776SUSGUQygGGli2EyTwGNIxu+GtiwFkTi3yQ/TaH3jCrn9cf5B3t kw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SMObfO002234;
        Thu, 29 Sep 2022 02:54:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6v7gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLDQ4e2nD1KrYUufQhSh7QUmrHDaXC6YoKBhSH6h4i9BNdTSrjml9Lp/0X/EiSsdXpCbiNJJ+b5MyCzT4qeafooqxTxX5XFHNG3Ans9eOalxwNfBQmsRWMj6NpeamAQox/YL8qdkxE2eJE5+nm3duoccjY6AEB5CT3qp9vRJFePcV7WuGXoofzhGvoLASZBop0vJnRnN7gAZiaSHvBNkFuzcPI6Ij70IrI6OBt0EVSVeGVU/UuQ8CAGQ7s+11mwXRjxnKTTxzh7yoUs8pIB+VLqYohgHSmNHpvFjYPd+Z8SVZZheQGBZNJCRJv11N/KlSBiLjCScYcB+RGopMXdShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suqDCWo8s+3gGmwA77bIU2xk+R+HOrcSjIdu5ABO2QQ=;
 b=KP93cTaSEyyrgzd/M6373hJtTpk+OJoR/ILc6OJpxpAXa7UPRlG6xzGpGuf7LFgmv2YuLOleVrM3f4xeTERxXB8nRiitbbSG9vhgGAXZxnAEXxBc1pKK2IT7K6FmT0h3WjSn+rzkdhqXZIV4+Znr96Ml4cWsQd1IaESYTGGVvs7gYMao6BBBQO+E4LGHSnXoJCzbfXomoQ7XkEQ24sVJnxs0yxc0Pxud9C5aMY5ig09PCTcqP/HK6SxWwYECOKWlPbvC9ltKJmnuhKE3klX094i1rr5IbT4pdy46YBqsDteLSahyC5yv4ixSjxRjveLp1CoID4govDit4KeyD8KWiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suqDCWo8s+3gGmwA77bIU2xk+R+HOrcSjIdu5ABO2QQ=;
 b=qLeyt9w3sMopZ9ZXTPg7gcTHhspmI/vhOz24xPh/OYbfVN8BkOXrtyCyY5BtFwExQA68mqXl5rj/tmC6IdM8tQnGB2M3vSER3YVNviFMLfMbp7DEiPOJRlN/wrMxRUFLNqvvYn3JIm1tV797s2omtM4W1WyeAd5XAPZIMsIBD58=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 10/35] scsi: spi: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:42 -0500
Message-Id: <20220929025407.119804-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:610:54::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e5a9dc-7581-4bbb-0ff7-08daa1c5eced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DetQt7fskHoBgHuyhyJQq+WGYI29CXLHqJ3d4uYRTYk230G0J09xzvPiP6k9rcGV3OegNhNMH2wzIkZOXD4JL2WIimUKag5OMmwW2XYsoVWxL/whTokCe2vlw50znAxbAXeEEiDUEd9l/aYj0ftr9sgvuCg1uNLV4c1M60F6T66eWOiI91XzizNwVvrxm7vaEnmm9AVrnbk0xOFuNNRCSMhFSdrM7NahHmuKZ/JcUm+QJXCs0sMHDqAg9HWbVxru1oarS07buw3rNLsNUOIrBp6glff9gFRSBjc+rQ4+SbG3rUI+mRMVDlirwrv7uCSxdt4ZA3oT9hSg50lsf3DCFnceIP9kDUou3sG9nJ0uuMB1Eu+eOvAUwOoO2HyKOObR1cfIAqUa4SU6XDEOfpnyRAdV9JECHRPWQ29MLdR3934+seS3fPoVTwregAB5TmnopCZDU0bGfwjuDhJU8ssyJ4Fuu+LgdRdtlfA1zAyPZcIkFu027PiaShCdO0INcaFO6zMHWWaF9clhix/9G2bUe5MNmgNKcS2+r3Kfnaf1JlloTl7qgWUXRy6/TwSTM7jzhHUS8EAytSpvkC2yRzVrYbJTHXQ9sn6IM5VEuJhdH/w4AEuYnw0gVPwOaBAQ5qzMF859dRbwZSVeppPQF84U9GRt21sqzYRZqcyhgKfddGxwJH/cx8r7gOYubOrRWuTkipo0Z5buO0I4u/497c94yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pURoxyNv58rxe4FU1yREOeJUii2+3GyBBK1TVGF1hTtWIZhOKn7Xq5jJ8f3d?=
 =?us-ascii?Q?KMBRj90fM0GdEWWxGn4UNk9k4cuIVYqdyDKV4jvQk3tc1bbpGC07W9+B3M1U?=
 =?us-ascii?Q?RMBKDMW5iXLc+7vdj7O9g54UwftcEhYcvr64OUOULuwLDjzV0ig2lLE8Qtg3?=
 =?us-ascii?Q?bQMUUA8hStXS8JqGl0Iup/uG+F2PMT+wL05IEvMvzdLLRKAgLzCz7uyEnX5G?=
 =?us-ascii?Q?u1ePHSw+aIakT4LUUKTqBg/UyfA58JmNqed2tz+wXQZirPSJdWQaPbbSoAdt?=
 =?us-ascii?Q?lsvrmikaX3FPb44PnyoBCT2zx21gD0QcEYUEK6FuQTSiqPFt+Q6CL6M2Y7BP?=
 =?us-ascii?Q?SmFvY/qLG0WVGzhOzYxoNmbXIlOQPvqjodM1qJtZ/mjCpxfijGzU73iNV4Rp?=
 =?us-ascii?Q?bDdx9ES6aAYs5f/7BFdkRguhKdQkWgzdChoKFgqKg9+VqHVNIp3XgXXkjI+G?=
 =?us-ascii?Q?CggsOPK0UKFrZwaAzrnX087Je2AuBNZO1NQWp6nYUvPPr4LZY0tglN8toV/C?=
 =?us-ascii?Q?cVrnTDhgpqXF64m4b9Yvbj1QDytWaf2kiVajsfWMLVD7yZfKDcnDVA+GmeZK?=
 =?us-ascii?Q?DHLp0+kx2TWZMd7jX7U/1iLnyAzJcc/En31aFFBXoJJ6Fs4mauBcTzBcEUy1?=
 =?us-ascii?Q?mAOZToKGkU6wsQ/hVfwrAHRdyn7/pyGHpYlWUie76+6EhHoR9EWVGmFiwCfj?=
 =?us-ascii?Q?iRo1MV6VJIUOqj2GX+0WsVQEqoXH4/lD9jqqZXP7JB8YMaxP/hiizqWG6Bvr?=
 =?us-ascii?Q?9SlbVKbadOL9HBWoGHAnqRTiMMwhhzVjdyCLa0sDTY2QsvK8bify/lt7Dj28?=
 =?us-ascii?Q?6IWJgOGsFWI30bBh1Q/9TyT90QGXuOoxmjqH+AjPv+XxeJJ6lssiHH55ptX6?=
 =?us-ascii?Q?GajODT9se5DTB6Zao+DD0x0IzryIBAPDUlJfQDgA3NRXCaGcFQHk3RrELMWx?=
 =?us-ascii?Q?myPy1tkzT1FJQiD3HF7cpvRLcNhEtLwzgCwr4uI/vJCSP6gUcmmb7vhSD2QK?=
 =?us-ascii?Q?Tuw0L0ysA0mN+97GsRI9b/BBWxn2wofCmYTU+Zw6mLlRN2bkl300bT9zGl5W?=
 =?us-ascii?Q?//1kUIiF+0l+uT1Yj5rLurglGDfKC7gVNIPOmwfg6p3ZX9PP57Khbu7nzIs4?=
 =?us-ascii?Q?KRAGdf7Ou+KrmLC+q86H7ZsgjGlg9fwVW5otXpQl9UKAm3cyIz02rW3iyypq?=
 =?us-ascii?Q?ZSqgq575xLb0erQY7SlVRxNkAsv9BIeGgB/gWYFQfETwR2RuS396nQWsViNf?=
 =?us-ascii?Q?+EzdC45LPN9rZXdGCEKU06JAULZGc9PX1Hlp+FY66xdeXHglm1Z6R+0APDgL?=
 =?us-ascii?Q?U5fcFw1MrP4zferUdyfz6OgZKCidTETLe/u+bFBlnO/ARs4+yH2yD/gyssR8?=
 =?us-ascii?Q?k3pOa2frygGmJkga1XmToSMCuV+dCHv8du6fhouyC0EgpNrQ62HWOTbHvwIY?=
 =?us-ascii?Q?vgqYBdjAtgyC4rD7YYvj6bdyvii6dR0kb0Sy/Fp7lFn552dIg6JxVkKm6x5q?=
 =?us-ascii?Q?PGO5Y6qVtLii6eiPLFe799poVsIF2j5X5MoCLDiuPN6Jd92bz4UrA17ZHCW3?=
 =?us-ascii?Q?uguhsX78ZJK9As8MfPvnETmVLIGAejovAhkQukQ1N8msTCNtOnmH9zHXZLpY?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e5a9dc-7581-4bbb-0ff7-08daa1c5eced
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:28.3028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6OqqXN2kjZ5/xZHKkcWwrFvbOfXYZr6a4KdIoNff+pV5BjvCnPdtY1NYzWmX5v3TnXlAVwgzoVFRXlBVjTTo9amsKmZdViDZQttaWehFsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: AD26uTDK8KS3f7vhg4SdA01yN4QzN9C6
X-Proofpoint-GUID: AD26uTDK8KS3f7vhg4SdA01yN4QzN9C6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index bd72c38d7bfc..55d9b13b2f8e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -121,12 +121,21 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = dir,
+						.buf = buffer,
+						.buf_len = bufflen,
+						.sense = sense,
+						.sense_len = sizeof(sense),
+						.sshdr = sshdr,
+						.timeout = DV_TIMEOUT,
+						.retries = 1,
+						.op_flags = REQ_FAILFAST_DEV |
+							REQ_FAILFAST_TRANSPORT |
+							REQ_FAILFAST_DRIVER,
+						.req_flags = RQF_PM }));
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
-- 
2.25.1

