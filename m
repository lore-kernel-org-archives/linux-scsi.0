Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA78C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJCRxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJCRxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:53:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9CD37188
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:48 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GO9WF029401;
        Mon, 3 Oct 2022 17:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=MqV0MSihMMcXNM/P4R6Jq3SqrHYn5s6HiyWYFR54lmc=;
 b=JQXB2hLv3y0v2jAT2/rUTh8tIvWOdp/59dm7KI6fYFeOUzscK/+StUkbAOFxXrvbh9Ns
 6PlUXmJM+dNAsrtA3oQojIrIHi6c0PODQIwHhqWfHvyXenRuRRXXmK38ZmJSiD5Mp7Ol
 r3yoUQW7IVWl3o2MfX9aI0K4oqJbDjGnROocIwofczsKQsJcsyuXJhqKgPY3K5nl0uV3
 FOEKS7OE3o3BwARwdx37aJyeh2Gapr4Pa8DoxmwC1agSnjJdtmAvCT9PhJcNAetDyjzF
 4XLLNiDha9aVfg49GuFOcWXcPuKJxRHP0JKguSCU3MP7bNoYepk6BncNJ68LU225Q7Cb wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tc91k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xd015519;
        Mon, 3 Oct 2022 17:53:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgVKD7fDkIJ3unchJRAHT3HJ1YD9EDW9Y3gtSys0HQyCSE6FYvcNT9MEE89ihx0vKhJvqFaQIjzgiyMyT885lNQ40rH5nBSJ2pKKYC2HQjFkF5VhnP+Qb/NXuFqW6aPuqd1xHbIh/vr+qQ+KcHvw8G6PMD09uv0y+P4HlNMyjRrxM1U41D3dtky+9cxVYi3UxaPjJf03KPDitaTtuQiJiD6Hmus9B2n3ewAUkWusLvK92TWyM9ZH7xFAFLgBLdGMxY1S9lsWanqqiVOe5F7fF+efj9KOHvDJNVHiIfWbho7IWfoYvql4DtQoycsfotng0erkQDFxmzoa3dNzapW7bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqV0MSihMMcXNM/P4R6Jq3SqrHYn5s6HiyWYFR54lmc=;
 b=EaqaICYdUcNv/od4fQN6vgnsi+FHYKKnQi0sEQEmxSjJX7UHhV1ypIx1nuoR12L9CgOaA4kCNYMpOrvVKgX1eIxbDcfJV0f4eWco3vZJnav5u43C50cqXELISX24Ga49F4r02jyv84UVjrYADUGZrlJRP0c7dkje9gdXCx4ukccFlH3oZhVRTGwu6vmWZZ3Sj9b6yFp4dlYx5w20s8GCzOhCx8icZpLaeG2IB5/4bHe9yWWO/xuNW/dLfo/cEVHkqSP8yMd+jtj4qGf3WWx3Uk26l7DSpO03fM/Z+Y+LN6olux97ABa5yLy30IHMzZPX3gwsco5+OJ1prd7+wGchYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqV0MSihMMcXNM/P4R6Jq3SqrHYn5s6HiyWYFR54lmc=;
 b=qwxFv9GSMFO2FCmhx58JniyRz45LuPzzog4wKRFK63XgGlJXsiN1h47c95lf5HUUI9riCXAvAf8yMz452Umyll4XC+UVGuzTJoH6F5+3FjiE3TATDd3tzXle3wGD1cemVkClnzOvdVlwcWNsSMuqn9ZFuTroWikcR+MLxGYRGCo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 03/35] scsi: Add struct for args to execution functions
Date:   Mon,  3 Oct 2022 12:52:49 -0500
Message-Id: <20221003175321.8040-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:610:33::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 14e74ef2-7f08-42e7-7e1c-08daa5682d84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXGlmLGogfzQ6FdU3QaPQkxEXwL21A+isC/HoLy9MBmilhhy+fRLJ9W9lv55lO6uV3kAbIB3gWjwrUNVhWtUm6CwMH69uSio3Vxrps39UXI10/mZ3FvYy0cTOauT4V+W5cdWhw6kpze6GByrURDqGUE12JrIQ82zwTcsdi2uKJ3B4FQ8dUt+YZhIhOY/tDSeG2O3dhgJ8genjI8LQeGfs9dUEajshtRxSzFTuOVUFa/ZLQseh4/PCQOsE0i+YWkQsqLxtDL3VE3DnmfSoGaNaWvTh7LLDNpUu35gBevi2JL3scg/mbX7LBOxzFeAkInh2a6CVksh8CkwJXaJsBQgTyqiuQPVZa6/9/tQddmJz6ZhDB7/5bJpRdTYDXgjq5X6uTLYrt/umsuJWq0AW0w4c1iXQOYERoEr7lavsQy45ZZH0S8dnetrrDzr+3Yhcuz5B+hJ2iNu8dUh7GAaLILF2eR7yVW++Jko9FEa7y1BujbETePrXR9r6eUzXDB2aG/kfYG6qtPwvRo8PnAJoLy83P9JPb7UcOGwG2bAmqP0vv0eN0TohO3MKJ78KiCj2P7jh5jluq+wN48uCbDGvxdUFFLpC/ZKrMSqWbf0s1pobX36ptLPVFi4LenPO9qsceUUwl4jk/G3Y+iSooGujYW5eiky5CcWX9RXl6HqRgxa80ujOQk89wyBOQ2zQ2myYxDgjz5Kk68YSBpb3KLAB5JmFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eC7NozQsTfXqD4nwhRJmhllXlQdVgdXoyckJMgy8x1Mjdc/is3/rnUxqjizU?=
 =?us-ascii?Q?07/Sxk/iulwzk7SSUuvOQGm2dByrHXPoUjMj860a/P0jEJs1Avau3LB9ZMPv?=
 =?us-ascii?Q?vAidIWPfM+rd8rhjEHYOuphpY4ycVrq+569pmPlaG3jeA0Qk63fjrcK65cii?=
 =?us-ascii?Q?5hgRrAhFcT2cRj19mC5kZLnPCw1MkTfoVp47dncDtdiWbRPiDaxGICTmxIv2?=
 =?us-ascii?Q?X2P+teIVm+3Zlw+cVCBZrGpXRkv/ujO0q52Kb7eyUFjyEapwMz0gCryqsnTO?=
 =?us-ascii?Q?40eIV9NOAGI6Bw0UrzguBdkeqsI0O8A8WPtXHn2VkSvPCgkUsNHvakrAG5TE?=
 =?us-ascii?Q?5daykYMDPoZXB1jQmiX2K/w/6DeHTyTCPjkf5dnQ4Y4w5bCU5VfDO675oWkb?=
 =?us-ascii?Q?oWkdHl0IIllmxnX/qEFplqv9UJzA2J9kYXT1x2QLJp6dDq/vF3PoZr4mmOTG?=
 =?us-ascii?Q?/SyudlNWr4MU9wDrE0AKb646WlFYFk0P6OcrOYgRQEmsLypcy89bSq63E60a?=
 =?us-ascii?Q?YP27JQpbx9VRDjA3BkP5CmzQ8JNLqQcpqxDBTF3ziDSZ7pjFb7tuctXYNjrZ?=
 =?us-ascii?Q?iw+I3/evFsOpjo2GkmOyftyjHVCbU2A6pn83YNTyiQgkp+6DzrxA03zNieKP?=
 =?us-ascii?Q?PuFhKov/xfhKgtsjP27B7+75MTkHwLgCw760H7PvQdqEye+Sn9zVTtd8wSd0?=
 =?us-ascii?Q?RL2K0L91wReY/V5SepMNORAFWI/V0noklLtDbr2zb6CldMdOtrKLRmUDGbLA?=
 =?us-ascii?Q?fs1TsV5zUB0kYC13ln9J/YsB+gQ2WECQR3Ue5fzitxZR/GUY2cg/aBQJ12bu?=
 =?us-ascii?Q?vgB6clAVpEWd3nUhZDJu2uO0BV+NqdH64jwNoKlgOHp5mr4YGB9bvgorf7TW?=
 =?us-ascii?Q?/+beEcf/u/xE7UkUETr4pyhpuhZPUmSVM063FRdDeB5bpe4PuJgisbNwobxS?=
 =?us-ascii?Q?KQlJoRULjheIzlSDEBKQWRE+Thzg2rrQNTkLV9l3jNHMVodGL/YhBhyKZcu0?=
 =?us-ascii?Q?bzSSZGvLjz3pj+CB1x/W4pmwtz8581O0C3DIXFaZ4wIExAEY3OA6ncHkTZhR?=
 =?us-ascii?Q?nQuh1Br7m9VV4d1dpPTkkjtO5FSwpJxKYvAJp+NZTlQKZ0vn/M5L0TIwqXCC?=
 =?us-ascii?Q?QFbB3rsJhvA03+kz1J9OL6lAlE0U7pXwccOO2uYsSa/412T4bY77t+BLoCQQ?=
 =?us-ascii?Q?mZm3q4cAUr+5kiURPtWtSxVP09GY/w3aCiWYTym5k5IPpsyjC2L2PFSAZr0S?=
 =?us-ascii?Q?uNFJuWXacsSvxX6mHe3cXQlI3cDv+iUPCYL3iYnFp7YlnfqWdTvHHX/p3r7G?=
 =?us-ascii?Q?Mv8JcQ2K0CPPEf/MVjz03n98laeqnd1+8+umDRogA29nOuHbx5vlvOU2EJhB?=
 =?us-ascii?Q?azCEgZg1KVwFYBdLEeOJc7ExnFf1DI0iEZw+RBlkKcnbg3urr4O173vFNAg6?=
 =?us-ascii?Q?69r8qRTQkjwj9z0PJEHRskSgD6g0bQ6PIPjIU5UneHGtAQeS2EmhRKPmUTOW?=
 =?us-ascii?Q?jqY5gf6Kve2NYqXzKpCzOAeWz94CP5OTioAniI5+LHaZGrPlM27tP/T+2A5H?=
 =?us-ascii?Q?+mf2ksmtLSVdv1bj11Ag+nwGbulEHAaLW3IMk7kL7qZz55Csy5N60ofVaDeD?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e74ef2-7f08-42e7-7e1c-08daa5682d84
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:28.6123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WG5a+JeGsayV4EAXPoS1hVbTnNTY+T0BBN6Yqm2+vThTf961K2DpEd5wPjqdaBJ6Ep92nYhTKCa3ULY1GuWHCFoeTzzKR8+mDmYTuT7+DYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: J6GBSiXqGY-Fh-mV-OG5qFwSJmPFxLsN
X-Proofpoint-GUID: J6GBSiXqGY-Fh-mV-OG5qFwSJmPFxLsN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in args. This patch adds the new struct, converts the low level
helpers and then adds a new helper the next patches will convert the rest
of the code to.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c    | 69 +++++++++++++++-----------------------
 include/scsi/scsi_device.h | 69 ++++++++++++++++++++++++++++++--------
 2 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 56aefe38d69b..c0b4ef0a2074 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,55 +185,39 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
- * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
- * @cmd:	scsi command
- * @data_direction: data direction
- * @buffer:	data buffer
- * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
- * @timeout:	request timeout in HZ
- * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * __scsi_exec_req - insert request and wait for the result
+ * @scsi_exec_args: See struct definition for description of each field
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+int __scsi_exec_req(const struct scsi_exec_args *args)
 {
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	req = scsi_alloc_request(args->sdev->request_queue,
+				 args->data_dir == DMA_TO_DEVICE ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+				 args->req_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	if (bufflen) {
-		ret = blk_rq_map_kern(sdev->request_queue, req,
-				      buffer, bufflen, GFP_NOIO);
+	if (args->buf) {
+		ret = blk_rq_map_kern(args->sdev->request_queue, req, args->buf,
+				      args->buf_len, GFP_NOIO);
 		if (ret)
 			goto out;
 	}
 	scmd = blk_mq_rq_to_pdu(req);
-	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
-	scmd->allowed = retries;
-	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
+	scmd->cmd_len = COMMAND_SIZE(args->cmd[0]);
+	memcpy(scmd->cmnd, args->cmd, scmd->cmd_len);
+	scmd->allowed = args->retries;
+	req->timeout = args->timeout;
+	req->cmd_flags |= args->op_flags;
+	req->rq_flags |= args->req_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -246,23 +230,24 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 * is invalid.  Prevent the garbage from being misinterpreted
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
-	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
-		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
-
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
+	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= args->buf_len))
+		memset(args->buf + args->buf_len - scmd->resid_len, 0,
+		       scmd->resid_len);
+
+	if (args->resid)
+		*args->resid = scmd->resid_len;
+	if (args->sense && scmd->sense_len)
+		memcpy(args->sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (args->sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+				     args->sshdr);
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(__scsi_execute);
+EXPORT_SYMBOL(__scsi_exec_req);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2493bd65351a..9975d04acd86 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -454,28 +454,69 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+struct scsi_exec_args {
+	struct scsi_device *sdev;	/* scsi device */
+	const unsigned char *cmd;	/* scsi command */
+	int data_dir;			/* DMA direction */
+	void *buf;			/* data buffer */
+	unsigned int buf_len;		/* len of buffer */
+	unsigned char *sense;		/* optional sense buffer */
+	unsigned int sense_len;		/* optional sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* optional decoded sense header */
+	int timeout;			/* request timeout in HZ */
+	int retries;			/* number of times to retry request */
+	blk_opf_t op_flags;		/* flags for ->cmd_flags */
+	req_flags_t req_flags;		/* flags for ->rq_flags */
+	int *resid;			/* optional residual length */
+};
+
+extern int __scsi_exec_req(const struct scsi_exec_args *args);
+/* Make sure any sense buffer is the correct size. */
+#define scsi_exec_req(args)						\
+({									\
+	BUILD_BUG_ON(args.sense &&					\
+		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_exec_req(&args);					\
+})
+
 /* Make sure any sense buffer is the correct size. */
-#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
-		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
+		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
+		     _resid)						\
 ({									\
-	BUILD_BUG_ON((sense) != NULL &&					\
-		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
-		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+	BUILD_BUG_ON((_sense) != NULL &&				\
+		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_exec_req(&((struct scsi_exec_args) {			\
+				.sdev = _sdev,				\
+				.cmd = _cmd,				\
+				.data_dir = _data_dir,			\
+				.buf = _buffer,				\
+				.buf_len = _bufflen,			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.timeout = _timeout,			\
+				.retries = _retries,			\
+				.op_flags = _flags,			\
+				.req_flags = _rq_flags,			\
+				.resid = _resid, }));			\
 })
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return __scsi_exec_req(&(struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = data_direction,
+					.buf = buffer,
+					.buf_len = bufflen,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries,
+					.resid = resid });
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

