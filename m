Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F13C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiI2Cyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiI2Cy3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DE1118B00
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1Pupu014141;
        Thu, 29 Sep 2022 02:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=cdqrXtxj9nYkmduY9LXGQeho5wEZ2NZGqMO5px0D0sI=;
 b=r+eN579Cd+Of5LUh0/UZA74VWsttRB/Ffsih0/djY9G4DseZ1CVopV/bry27AJr27TFX
 qA6/ULYnEXylZ1MXHfie0oUZEIgpymalGrpRN5Sr8Z64RXf4/DIMKAjQZv1bCsb7Ppf4
 US6hccBPDgJtI9Og23GUnKTrM4S2nX/1p+0vIrwDP4rAYx0mDSZj4duGS1LmYnzY4i6m
 BV7ZUrgY2vwmniSJn9u682cfDRY1LDZXiyTRgW5qF8FCGaykIAtxhxlHqeVsjXEwJ5WO
 XYeqTgsPkdu+2DX4jHCdGo9NlsUZBxAZPnS8d28/xfGBCIsKhe+FgRcQ72cRU3rTATjn Qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet3ue9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T24r3U039268;
        Thu, 29 Sep 2022 02:54:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpq9jc2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMCfxhjcdoJwh2VSTn5IxiALl8bQaJw3Jg5dhMN6AfziFIARpZtCfgonbSlu+c7F2yIqHNtcOLcpUNduDge3dHyuVIEQM69JpyO8Jd1l+BmpDkP64zkLQexSn9wmEt8IxC7ERQ5VIFfbwLIqfjOkQe7IaX/x8SpYlij5slo3weEbp5E1JYGS+k9Fxy1dxQRvvzpWw/mKy8yOsACrCCmhTkLTr1CsY4f0DAVb9455G0mPSPh78wlJVDA7u37dEyrceXNQ0irB8guJfyNWshjMfLj7myjAZyy1NbDC4cR1bwBDJDWtxvH/Hk5N1JVPwS44ddmAH2ohewG3AmocmgbbYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdqrXtxj9nYkmduY9LXGQeho5wEZ2NZGqMO5px0D0sI=;
 b=X/2ahGv20fRyhgPmaTdoK48wtZm2KDS6CtXT0sWpo58tgNeRh/8DNGowFWKIggKQop7IC9HEEHXIJlVirbPhTgmZbPlS5AQH5gzwcWkdqnop6XlM/L/P0gTElkynKUxQIZEqTlelKi5tbCLi/uDLxn380rKTmsYJWBVKOO6D+XDI1nL5QERKh7XOxqdfki5mS0VHgOxHhm+mRLBGPzEnMfKvihsqGFPO50dZXASM0wwiNt+TLbTZYw6BdLB4bD/+/9Jk70uJIbEiNa5o/Uxg1UQ48pLkfYsvwe2hN2+6tP32O2uo/VqCzdKXacdic6ce81NbZ/XXENvU+q+RWOH+bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdqrXtxj9nYkmduY9LXGQeho5wEZ2NZGqMO5px0D0sI=;
 b=p9w/A4XUNHIBfhVtytLFujtj81qf3y26NoVqMcRUkD0npACN0PzlUviLboaLxnbRYnlkwZQC8Oes4250yXXfxT67EUpdyiAcJiQMO5hq+A6JUrfv3rGzQHURCS29d7URbobsVRwf38Oz9otSddOO09e55TZK7tOHenBjzNdvwiE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/35] scsi: Add struct for args to execution functions
Date:   Wed, 28 Sep 2022 21:53:35 -0500
Message-Id: <20220929025407.119804-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:610:58::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 1783c966-40f1-4a0e-b1e4-08daa1c5e60d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYcUKwfGkyJLNPezGMR6ftSxik1uf8IWRyRxL4AOluzEZa8fLFxr+XiwUPeYLmyS8u/HxACqejmK/PnCi7vFrfl+PPD1TneXhqKOVL5CF5pOzOhlOi1We+hsXuTQ2Fhj3q49nKtUQGUKlQdh1HXgOnUvv7A6065cRs8pEWDZ35ZDgClEED0wm5rXk5QF+A2fVdARRRJqrT1ZJ/cqxjtWIMKxVtbII9BcnkwvgH3qhVzWw3tFZXF5ZvChiBf8WFvPWSk6IHqvnBwSpbJ5R4FnOz+gnVdw2Dow2d2eY76WRm/uGh3H2Q3+KgTwMXE72qlax0Niqlcr3Imkg3nOA1fXQKTR77ZR2H4lVEQ9tQeNpP7sVafTtNEGVgo+FFNuhoKhmG/ko+kNjrWCqOds3NTbN+VBaLFMbIBFEYqGWeYUgMd+9NvuNdYDkS80fhUKi+ROqMprHhKr7HJ+7AcwBa/f2R03NTtTMZIM065OAyjUN2qmMvKtxekQJ6J2tQSHdOq88/G8jYalKQ/yd1YSvWltqzXlMIsBWK4Jr1EoZiEJQRxW6EuHzzLfcqXzbISf4GlPSmjN5Ja4YhykL89xHIISo1RhfBI7dA6OEVw4JDhq/HeaMsdmjLiGXL+OZiNGzGHAJzF/OEKt0xhMm/wfHCOoaTlbnAK9sGkt2PLndMrwdpRRXvAWsGbeTiASaWsBhYpTK2jT3Wc8q4qcTXru/misIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A8xbHTzIDQCu2GL0SLNk5XbeBgzXGiKFRNe2IjzRYytuKHqmE/smvz+wihit?=
 =?us-ascii?Q?X03Ik8A/Z/pqAZlnZ5dIedvRIybu7y1/xjjpqCLjDoy0+5jzYuLjb9g7kHB7?=
 =?us-ascii?Q?4d/CVNC6bGxBqByEK/GvsSe0oPMGunxpNbgIV/fFA8Ew94Ojleq1Pa5+ebKX?=
 =?us-ascii?Q?C6g+uXkmU8CQR9+U1+UexX+8moz4ySZjW4cXhOj9ZndDwEJOaHgCGwjbRqAC?=
 =?us-ascii?Q?HJ4ekWkzKVt91M1abPXMijVOhYnha2Z+8tCYRligViko4XgV9FusSSOFEnFX?=
 =?us-ascii?Q?ZUkL8gHby/C+lvxFViESyZ1oidBfeF62F3/g2OBfjqt1ZPMHTz1VG3BMjOAb?=
 =?us-ascii?Q?zQi3Bd1HUuBbPePYNbfQJ1F23QT2Rzg+mphr4mT+CNKIBhRXS5X+4TSVViYg?=
 =?us-ascii?Q?qNhn33vsli0HC2KBiZHs4xmpSyLNVW4IQxYTn5ARSDenh1RqXNu48W5OjtBT?=
 =?us-ascii?Q?/W6llLRLA4J0+X0ipq9jKu5tPTea825C2A3kftzdamQ1+c3KEt3yu0HOWW01?=
 =?us-ascii?Q?TIgI9BxN/xnSq4QzL13LggAG8AAW2zG8/ZcaaYuK1h6fk0ydVcbfuc+cHqUW?=
 =?us-ascii?Q?/oxIwdFbwJwuFXShVhbIqEQPrHED3u7JRuM9YIBFq0KEk8neK0bagOS+BPWj?=
 =?us-ascii?Q?q6uDewPxI/DZSa0BLu/ISwidnYFWq90f3E+AoGj8fTWHlNXNUy2cQCaj3iNe?=
 =?us-ascii?Q?Ba2cYSs4DH7GKa55oqasUg90sKhkOU5Vypzoeuzk6t/Rl1c9Nu4Pd55FaRld?=
 =?us-ascii?Q?knjr+iNEHU48zvTlBlibUrHb5EA5im3e5XbtVjwpuSTVQcVPnUkBCZGsnVud?=
 =?us-ascii?Q?DcRjWUMobyfpYBff5OOJqAcpXJbtiHMG0HexmGkCUsXS7EDaw8ev9vEDe+CW?=
 =?us-ascii?Q?B1peUu4lxpbtxeAwzxBMzgcLFSAeRkyNiSpS09dQKpumqkH9lhXfuNFL9Bhd?=
 =?us-ascii?Q?/qpFhFPLQOapTfHgMSPNFj3yrdMHL5BLQh/YIz98j5esqs9W5MQhiWCTKtjU?=
 =?us-ascii?Q?E2BIsqXlfii/7vu8Frj8it/wHqI1FOB++nUobJjRfmIsHuDRMGhppggfGo7M?=
 =?us-ascii?Q?f42Se77zx0lyjRhMwGLmIJFEozNR1oVAZNT63YR/HGorXLlz+M7vvvXujUnt?=
 =?us-ascii?Q?trY3mu9OIhB4m11N8xASnKMv/p62msasQoOVHAr+NrB2D1HFrJVqtz+Grl9c?=
 =?us-ascii?Q?6zNQQZQIfbu6MOKfXKyciLUc8VCMSDBuC+nJMjZfmhzcqTQuJg89kZ65SMkx?=
 =?us-ascii?Q?FzRNpMa8U3JD9q+RFbpBhcvflKDe3CA8O+5Nb4iElalGAMOLK9WbU33PjyGR?=
 =?us-ascii?Q?4rWNjyjfPVCaFhI6FVfF9MIAn7GAGCn/0GHnj0fYAh9klAMYI5d7G67fdO0I?=
 =?us-ascii?Q?yzqPnGQDnOgqbvbINvkditS6PWB2tF6JchfSuOZyqRO7QpQi4LGLOcIDjGQc?=
 =?us-ascii?Q?NQ4RqwWLvnQbWcB37183WqGYvQVVGBGY0lvMMFP4i0Wem5QzX9C8wfjpcyCm?=
 =?us-ascii?Q?Lb718LgbVbKPZ7OwiedYjkXQMS1TJ2fsqDIfa0MZhcuYOI3ieE54VkCdOnJI?=
 =?us-ascii?Q?ODHldjERHPVPYPlx1wIebAEmOSa7yBTX39G9kN6xIBQNhjBnawWrMCDbHvY/?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1783c966-40f1-4a0e-b1e4-08daa1c5e60d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:16.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cq6W/CUQ4CC9MuJQwGzNeQGOBarsER2uhUSw2Vd7Tu4LdjeHPYOHGO0Yxafr3YG9O1GmGYcys5k9kazphC1tsPdNb0N7ybjZc0Ia5t9GCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: ty-lO274_efi5GGE7XqFUiIHAq2wtrM5
X-Proofpoint-ORIG-GUID: ty-lO274_efi5GGE7XqFUiIHAq2wtrM5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in args. This patch adds the new struct, converts the low level
helpers and then adds a new helper the next patches will convert the rest
of the code to.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 69 +++++++++++++++-----------------------
 include/scsi/scsi_device.h | 69 ++++++++++++++++++++++++++++++--------
 2 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 56aefe38d69b..18cdcefc7f47 100644
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
+int __scsi_exec_req(struct scsi_exec_args *args)
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
index 2493bd65351a..44e5986b8ab0 100644
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
+extern int __scsi_exec_req(struct scsi_exec_args *args);
+/* Make sure any sense buffer is the correct size. */
+#define scsi_exec_req(_args)						\
+({									\
+	BUILD_BUG_ON(_args.sense &&					\
+		     _args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_exec_req(&_args);					\
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

