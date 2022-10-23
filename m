Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F0BC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiJWDG5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJWDGe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D1D1EC7E
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tp2H008722;
        Sun, 23 Oct 2022 03:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bKN/3na6/yeB6BRg9V7tGq/OT9G+2mZyp24rh/u+TKE=;
 b=Sx7JU73+cykjF5wlod/yf/ZqxDF6saPOkEloDJWHK0Y/+Cguq4nv625eo+XUXd3/DnjM
 K9thMsQD6nQOwOGwHp8aoml/pb8V+yKvqBozqvNRkRum02uo21KEGW7ZGdY+95vSEg/V
 1CG9Y91nTuJrUGyRmPUzo5KzG89uVJoZFCsFws8zHgQNkUFMmTaCcmq3YrC8Pf/WdNHo
 W4btFrDrX33BpVQ3DkCaTrsDZ/HHJbN2616Pobb7mlNGgimz6EPovULMBLhvT7tBlCuH
 P+KIkiH1W9IcmGs+CQgq/UJ9kfZmzom/rS6gdGRXxHRtfvwKXqZ/AoMGKJvNxOAASbRi 1g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xds4v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJVPB4030694;
        Sun, 23 Oct 2022 03:04:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2ryvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuDT8LsCObAciwmY5Ok6Xedd1qm00tERKzzkV0IoVozWjkGYCAZBKtRTEGGE/uDv7aZ2zGdOgx5HLvH73bPJuy2h4AnMtNNTNPQd1hIm7H9kTxzoj2keu+5Dk+zCahhc6xslsjimdFdDwaON6nSOuMwNEnuHG7DrerzKovNsDio4EO5zZEKpgBQttBadwKjNgNgTAvBes7vRGX4nC/wrV/GM1Fqw0K5C4V8wXHmfO1mgytyYpHxH9NaZOmpU3XE+LHx1bmnklHXU2EpqzFgEIImbEurQAu/SJzv0z3alj1cON5zy3Swgiykcdq7BVbHykwFsLSEfMaBLK8OIR5UIiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKN/3na6/yeB6BRg9V7tGq/OT9G+2mZyp24rh/u+TKE=;
 b=Ue8xNjr3jZ2KJhKdaMANYMGg0O1rjUbJ5w5kl6uNZXc2PUr9Z1dNQH1Y7p7YG18+cLXMYIk+bbz1flr7+/2psEHOhOw+HEmKGiuSxAlr6zh/uJOZh+rbD42fkSocBno3cLhX4Ey9IBc+yv+8wiWLm2+KLrj9IseoH7hS6ChhA8UtkOaQy015YmW7IFVP4EQhqte+2ONg51LKCGo9w4XVHXLk16Tm+e7xC9BDAn9Te48v6/jxRIPFBdGgwBHMS1lqDkcn2qNgBeL0Cn6nwm//52+KgIxdRw4uUTh6kzGeaHrMibxKEo0lzFsVY7Ca7Siexmm0ANcnFxlT4NKKbQy1UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKN/3na6/yeB6BRg9V7tGq/OT9G+2mZyp24rh/u+TKE=;
 b=KmAjW5jVVTrF6slaqBjz/XIh9S6dKRXH9ib2mu8qTmIuKlA4QZnSHP2ErINbQ+RUHMy98cXJxfV+NPm62zl3ncb99ftT+QZKloSSX8lCOP7YfOTzQWaXRdSSMNxCcV9H16v81d5J1S93wY2rvrJ4A5s4foq4xqZd3vNsuSCIFzM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 03/35] scsi: Add struct for args to execution functions
Date:   Sat, 22 Oct 2022 22:03:31 -0500
Message-Id: <20221023030403.33845-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:610:cc::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: c1601f75-4c7b-4d79-61a3-08dab4a3424b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grdeE3a3YGfeEEL5htyytNG6uKSQ5Z/EpfcPKjHzOa7H1bI9Sswecsl383U1ZAbr/Hv/NQlvepiXfSfleo7o1S77A3QPCss1s4lGqopY/Uwcu9SKV+hwKIvtwIVKNTDJS+Xbo+44wlA2fqYMm/zmcFuEUcElK8RA6QXBLHE46kLZ6XAfwasEKC1DT+QXdTSM3gZSzy67dwb7YOON9aeyvEYxxf8LcX2D9vmMWeOW1CDgT/d1s3gymSQKg5Z+0ZzGH/0sQ164ZvCxAqIMgAR8OSXZqdzxb9KZqWjMyopLSLEWrqNV3epQ/JBeasghJCgmSdpolFUlUC3Tr1zCeUWbGWIQQK3wg2OnwqxBSuUmiEGnkAZWOQwhzL3Waubdo8afxXZUDdjphChNmTUNbI6VIHy0UxcXuZnaS7tfKKeb6IQE4S++4r3/Si8iJ32Jo/Ce1A4TbpnULS199sOKTQwWoL7y2lkoBzWyjzLKeGDv1+Gfj2B3C/t4hFdQDOcZyFJnAn/3Jb56j7RhvcXQoYU5jwEvcxhjPuoBE5S61yeuAg+XomDLU7XJE2crtlqDKdaD9UNm+IZhxOI8a7fL26j4zZ79mbLQGGWJcRFRJoZcrdnWs7iMU/+boC7XHx9DXmswAMijw+WEDstvzbqQFMtFNIHkCm52p88kGymJMsWULGTUjWmk/nqKDJcI6Iac+1WtNI/kP9oEfg8dAjwK7T6Jcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FV3jFkd/TE5aR7vGioOGJeHSTQQzxPcKUMW8mhXc8Xx6ZJv8kI+atFCCoV7o?=
 =?us-ascii?Q?+sg/MIu67cqrBXOjeJz7U6+NpcW1KlwsnUcCzSRPG6WyzGcFI5i2CeG1rFGr?=
 =?us-ascii?Q?p6+4FpeerwhTSlmmTmmAmWWau2ySKdbE5QXG7gYRCNQtjKXIszSI8u5ubpuF?=
 =?us-ascii?Q?gwSOqE+ubnPbLOops98iUA9F8LNZg+RDDMS9Q8/2MgUH8tqwXHLCPqcEioXQ?=
 =?us-ascii?Q?2F2LxDbAVkeDcYivxaT09kAPBEv/kvfzwO8wn5a++SfRc4gJUaKaF9bB+cw2?=
 =?us-ascii?Q?KX0M9oeMxLOdLvRnwa/xZAT0X7NDsbwOWpHic8KAVi7S810lkAhxEN3Zoj/y?=
 =?us-ascii?Q?UFuwkPMyv0PiMbJ9rHzcBYADMGw+jINmXL2JUeEQlQ0d61Igzvj+z9wb2Yv9?=
 =?us-ascii?Q?EUAaERYdCOo0+JIjG8jnB7m6rpWzKrnZ9GH9LKo2U3rpuB5Gh9XFgPUv9ys+?=
 =?us-ascii?Q?cmZ9tsy+Bfeg7dKGg8BSsDhgaLQNy9HATTy8ZxFGKrZrJebB80wq0bpLx+Ir?=
 =?us-ascii?Q?EkZ8oooVNzyLgKaKQkTu7kmwPv/DQCSeInp26g1rCsqGLO3wPxRUDdNnHxZM?=
 =?us-ascii?Q?b0MWVDCxpLsHbQa3yiPHtbxLTMMwZQ0+FfxYdhDqGBx/0IHMnBZnEHTPB0BI?=
 =?us-ascii?Q?IYSmazMlfMFVohc2IMj7M3B4zj08bBuvnafvXQjNanNZCjfo+X65eTsJl5yn?=
 =?us-ascii?Q?eLMMyVkLBr4n+u6iAVizQSRSURbON21l+Lk+wYi4PVkIrrb0Is9TAW5CHbjn?=
 =?us-ascii?Q?9tbEens0mCGCSVkpzrMDHmCKMh6gMEKM/YLqH52pBaUDHxaIDsIkdr/LCNox?=
 =?us-ascii?Q?WulqrZydkyGEGO6hog4tE3NoVjm0LVtA0C6brR66iyLobfeXi3StAWMf01bN?=
 =?us-ascii?Q?vI+GyJYS+2E/V/yuvxO1qTcQEtZ+US+zMKFMFvkkDkj+Exa/qGarlxl9A/zy?=
 =?us-ascii?Q?v/jG7txdffQcjSatbDIWZQTcYIQ3m0lT2piGpG9tp5wRUDX7ix9UtWc9jKJm?=
 =?us-ascii?Q?ro/0DlyAcpjgJ8vPXgZ9SnnPu3DCNXRn0sJKkdyicHt47I1oTT2i6p2RAQco?=
 =?us-ascii?Q?YnGzLJgLBxgIgYy/eX+N6V+61x6NKxZQ8iQaj8d5JXmHnv2PD+VKTGbtzmHk?=
 =?us-ascii?Q?j3pqws7BA3f6hrZsR8ecBPASLEapIB+EeE493Wno10FUuCcatp/FP/WDRvdr?=
 =?us-ascii?Q?ADiRH4V0imQqxjyyn0KlvHJqddXHnToNKYInNF7CgAGcAVBOxVGTgI005+zW?=
 =?us-ascii?Q?E3jG2qKf7L9nfjf/MrkT5z06ricwrrZVBk8d6YqhuixzTDehzeNPmDLCncs4?=
 =?us-ascii?Q?Xr0fvt1XKywSOT9+AsoZCzfht3DWo5dJm0NeSh6hq8ul9PzXlBv4r5TlUgqW?=
 =?us-ascii?Q?S1txwYlfCrbFTWWyT6HNMwhIMKF/phHVmGrMoJGp+35KZUsvV9zXx4mXXrJF?=
 =?us-ascii?Q?Q7If7jiQ+9ocbarD3mRAZEvAQ0PaohcusyMz1yRyeYlXUPgI/IRQzu5M01IO?=
 =?us-ascii?Q?3CeIq20AjpcCjehOubA/KEWW5y38n6nLOPj3FIKYdQxt9zHyE9u3mHKvb1WF?=
 =?us-ascii?Q?1yOiPVQlh4KaRs5TbciW03jmqzSWI569Q6cDBfx+NvEY1a2m3yepQvJDl5lD?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1601f75-4c7b-4d79-61a3-08dab4a3424b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:11.2658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxHAWeuW4VckLZazKQPYhq+UyncNAIVLao4nDJDYXIzuY4RVedumx+ePi4xomeo1wiZ4nh7j5eEFQixi8E5U4YrtCLFKaWmA8W7yMN497OA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: 5YmMRLTlYE3p_EihLptF2Dw6zkQMC1co
X-Proofpoint-ORIG-GUID: 5YmMRLTlYE3p_EihLptF2Dw6zkQMC1co
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in args. This patch adds the new struct, converts the low level
helpers and then adds a new helper the next patches will convert the rest
of the code to.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 69 +++++++++++++++-----------------------
 include/scsi/scsi_device.h | 69 ++++++++++++++++++++++++++++++--------
 2 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eae438d53ac5..f0c55e2621da 100644
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
index c36656d8ac6c..d49a7157d7c1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,28 +455,69 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
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

