Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DE8C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLIGNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIGNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:13:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB446BCB9
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:13:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIgYp002839;
        Fri, 9 Dec 2022 06:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=xBAewrfjTWCZWX7wI6Jw46kWOGq29W4uYHL9wYKbXJ4=;
 b=P5weAyqK2VzSl4RvSo3CTkGt2dqT5cNWF8kvINOcCCO37yN78fg+bpnvtRsZ8VToEiGX
 BKj2H4S9RF8mONe6+TaBUorid3pAIJcbC+XI6SNf4e3sp5Uo5k81uqK2QEGR0s6qB0w6
 j7Gs89pJ+mNYjnWtuN2XdEovOh6o2EbrxdSNilHwNk6745Ckl5w4s95HHNOF8+tlRodF
 zcBfhXRVBXOiBee/80jmBfjvPOudgjX9EbE/bQF7zbpdn1sLKJs1BTNuXJ2JC4Dr1sAX
 lIxg8BgJ1dot7Sy9LlYtCBRMk5+yZ1UpbqEE4cTeD0k5ZcnPhdudWxFXAWU3FU2Fq6zV iQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkcjds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B94hqNO019602;
        Fri, 9 Dec 2022 06:13:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8jwbc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moMAZeo6ljHCiYa4p33zzUJfPajyBzmhw2PbvdBfLzwdWp28NfPe3Jni37CsyUi6P2TrngYJxbe72eUFBHJU+WkXjRDf7JFYdzgGbwZCfqahQnwcL8yNAM1X4QGSYcu9AS4kMclMWFfOuF/Z7wTlHZmyg1itnUVuftMgBUZr1+gjv9paoZfRVXT/hfBJaUREtZ60lN8WonXWYSXxoyX//74ROLdLP2dgL6rl2jsB52PiDwWs9yCdIJNGVWu2u+tnTY42tW7+F17NGn37QBczIMIG1okN/tqGa91S8tQfLCVjhRsVIOIR1I2z1N4ckqVIWDyb3wSW7FqRo1wXldKMow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBAewrfjTWCZWX7wI6Jw46kWOGq29W4uYHL9wYKbXJ4=;
 b=iBd3r6lmr8xvQgJh77mnDl3dP3E/jseJ2zho8zXNxWjxgr0fRdqw1T659a3bDIQYb1/WXQ0JJeWs3ddr1WPqGwkAtvi2tHhGmlv92RPE/t6VOlpv2PXxdjPWXGRglnHIk8XnWEPXIWpPr6ZEZ+jpc5Xeiv615Eqt2pbMj2lRaN+RUejSBTErvPYnjgQyMACBEkODl62zGjpkFU7JacgHH8KWJ3nYhJtfS4rFtDxbhpJkbvDVAJaZigpSlMHefiMEu/D+Tzphn7lnIIY/GugWRG09eYxAkPU4YdNGKiBKPaVgDA/bImxSkzNXwILLrea43s4zvfZ4SSjLt4JdfhiQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBAewrfjTWCZWX7wI6Jw46kWOGq29W4uYHL9wYKbXJ4=;
 b=Zer4EQpUEyTzDHxfKCYdd+dHr3P7sIJ8QyrYNA7CSD0OgJrBoquGhl2f8NeNvjCNFb+VNOJFRUGeyo2rxr8Btjbz0RGIE/lvjkBFPqx9fpLvjPNCraBbWiCqBnkTTVJBSzGwKu8awPRsMyAVgCANbC1ZhP1lGAUi2/Si5hEMPH4=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:30 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/15] scsi: Add struct for args to execution functions
Date:   Fri,  9 Dec 2022 00:13:11 -0600
Message-Id: <20221209061325.705999-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:52::31) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 550fbfed-c22f-4ac5-7742-08dad9ac7e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+mHK76uc1CRxEQfrYM+vrcSSSZGs3b1j0+6EqbT6vCx8VYpkIeFW14sZdBKQY2+Sge/bqTeXJ3EsxKT+7f3ASj+8umnp3eBF0RgERICWoFaiS1zgzBsmjM2hrgvBb/p/oOLujq2MrPxCFvLZNGO4oArGP8mj9FmlakZWkpjF/LMYFqYpAm6C7+eGfHshzvAt+tgr0m/b9onD8mDXjy0d3sFqHiRGG9paIyNdxH5J4piY25Znka4UsCAGmR2SgQM5uY5ZEj5HrjEndDfna0K3x/4jEckX7tyQupoRbgXwVY60DszgNZrHk2g/UihYFZVzA9DxEozH9umVshP1gioghzOKZE8UtNpzRKkWhP3ztoWe+QpjE/Tts2VNz/2SMVdVSE3v60y5p/CdvJ02KV64dWxevjkuFpJqL071Zi8+xKZL2RF8x9TnImPHByHexj8mBTt3GEt2eR6e/BSc2A310gcmAAg1jcw4BWhcWuuBsoTRKUA5eiKXekA4LoIXlLcxB9l2/AlVFkTBgvzb1BpgO7iHdXZebT3ELF4ZnGEfkfMr4yBiouaZ6X2yQnka8mFvCj/UN4+61IBu0GL+TVXN+6GSSnIFG3oo8lUP9iKu1byPT0TwCQWm0u+F1plATPKz8ad+zuFyJ1pfs91G6ujpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zUMkpzv1ChdmVDcdiPYRyj2zyuKkccZnBFxph3rV3RvjXnZgdbh3J6dNymlv?=
 =?us-ascii?Q?uLt0qYu9pYC1QuMxarKFcplWAhbXUNKuzn5rKRsVbrShHhYIjRtYUHIowXzG?=
 =?us-ascii?Q?pkzbwFpIhk+0dvftegdrN+ui+AbPtqJIVi0s7CyO0wBQWaGpjv/P3WHm6AA/?=
 =?us-ascii?Q?9dkyEWtVeraVNbbJSgwDwYAjCm9x2icaKgY6ngpsj4w/D50o1oGcHVFOVZta?=
 =?us-ascii?Q?aftWZHoOETrhheL8A+rgu+qTwHUAv6SgzR9NJONTcJ50Tur66n0BjFz1nVr0?=
 =?us-ascii?Q?EoyeYwJu/AlcevM0Lu1HKYWpyjpxodURDpwtd1NG0nucz7T6jQjeT2TcrxAL?=
 =?us-ascii?Q?TwUHbTozsPcf/k4JWMJOD+C90l+iZhk+2mHstCdwq6vXo9FkWMkRaJVVjF9O?=
 =?us-ascii?Q?/qGApJoDBoZ+3RJD66dkbaztYKdWgEeynf+zNw3JEeT78GhCAI4lYBW+uo9h?=
 =?us-ascii?Q?Wf1XR+NvtCU2eCx6S2Rf8vEE9l/rWRdxLo6fjiIh+m06Ioji5us+1UFB36MK?=
 =?us-ascii?Q?avmoe4BhkRnEWHsOcH/l530Q3ybMZnqET0ZDOH5/3nJPlC5qxxuTfMn32ixN?=
 =?us-ascii?Q?eRjLf20nHpHb5MDRH2203SO7meQVNMprXSbO9mmF617lpdM68Nkc4qcomCwL?=
 =?us-ascii?Q?/KIadE+W4fHbICEkxAOj07s/dv9IM+KAmEBjikyKdvISvVhQoCC4xxSiul81?=
 =?us-ascii?Q?BC+AOn8Tye1/M163NQM0IMqTQjnzjqZDT4t5ATti609Shkq95aE1tKNNnm2t?=
 =?us-ascii?Q?uAg0XzTvBPY751wguugVBbnAgfT0IF05fWz4v+mJDGQC3uokoNM5ZMcqbUHO?=
 =?us-ascii?Q?DQf09ZdtzyR3H9qNHa3u29MKxaxJvicg4OnLawGfONSpNtq0dN9qXAKq8HbE?=
 =?us-ascii?Q?7kdeLsp5fXqAjvZsuakNHJmcQYA+eZ9msRgfO/dA5BoEHKymL9TBLUuyw40z?=
 =?us-ascii?Q?TZmXgJtFE7HHkTw+ZmqTwzcbU4AEVIYd4PgKQfkQAUgYXTmhLrndExW7MwBx?=
 =?us-ascii?Q?G0N5hEGK8AX+HHHaFy//59t8vSDe+u5a7VmG/DMtLGeGc4AH9YZDeZ+f8rpm?=
 =?us-ascii?Q?Rt/JHgz/QA5FncsPQqNA1PTzo5y3LszTgbfXXtXz9ntI9FTKokhmlWBqT0hD?=
 =?us-ascii?Q?bLsPhipxTyKoDvgId4RpyfH3ntDwIKZu2/5pW3FZvEh8U9FHIYUKTb6KDUyB?=
 =?us-ascii?Q?7R5OmZZ2tI4xqPoHihZkzyfC9pAgijBFpeK1QeBiX5NJ++smE+Vk4+/iaJ7i?=
 =?us-ascii?Q?SX18/qN2XAFGihHuNX1Fa8gwyqTjh5RN22ZBD0XySOYa4gP+ZXSGIr+x4Dnx?=
 =?us-ascii?Q?WbXurirj4vSjGP+JCgPYjzPX9xsN27LV/b5dUBjG6+XvVRpTSS359NmKAftH?=
 =?us-ascii?Q?47UJiTEKwmvGB6q7Mw8lXR7gTm3orxVcthpFogXAaBg2e+CqCK+k+tdqAlDg?=
 =?us-ascii?Q?3Bn/ajlY3S44H+x75XsqkRybKIWZQYKMhN74wt6e7kN60P8HNE97rBbIlYw5?=
 =?us-ascii?Q?qmkvfu9lRpXDfdyFhMPgCwqQO7pkbJ4epn4buetGZHqiMDrCI2RoYCpHM1lD?=
 =?us-ascii?Q?/bUfYe/HTjzgknERZUCrsK7jZvn+0raKXsWjvtnSEkud8gVBCJD4niXRXUtA?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550fbfed-c22f-4ac5-7742-08dad9ac7e28
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:30.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgRcKX7A/FJFZ1qBuO/wcWD6GMd0lcDZwR5LUeHJl60Mt7OYpRgoK81EYQJQU7QMbpq8XnXZd3qPDLgswPLw5zXtpOP022xdNFJ9GgWcjS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: hAEriS362Lpp7PNL98CMOFIVIIRbXPXT
X-Proofpoint-ORIG-GUID: hAEriS362Lpp7PNL98CMOFIVIIRbXPXT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in optional args. This patch adds the new struct, temporarily
converts scsi_execute and scsi_execute_req and add two helpers:
1. scsi_execute_args which takes the scsi_exec_args struct.
2. scsi_execute_cmd does not support the scsi_exec_args struct.

The next patches will convert scsi_execute and scsi_execute_req users to
the new helpers then remove scsi_execute and scsi_execute_req.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 40 ++++++++--------------
 include/scsi/scsi_device.h | 70 ++++++++++++++++++++++++++++++--------
 2 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a29d87e57430..f76acb468abb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,39 +185,29 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
  * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
+ * @sdev:	scsi_device
  * @cmd:	scsi command
- * @data_direction: data direction
+ * @opf:	block layer request cmd_flags
  * @buffer:	data buffer
  * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
  * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * @args:	Optional args. See struct definition for field descriptions
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
 int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+		   blk_opf_t opf, void *buffer, unsigned int bufflen,
+		   int timeout, int retries, const struct scsi_exec_args args)
 {
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	req = scsi_alloc_request(sdev->request_queue, opf, args.req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -232,8 +222,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
 	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
+	req->rq_flags |= RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -249,13 +238,14 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
 		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
 
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
-		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+	if (args.resid)
+		*args.resid = scmd->resid_len;
+	if (args.sense && scmd->sense_len)
+		memcpy(args.sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (args.sshdr)
+		scsi_normalize_sense(scmd->sense_buffer,
+				     scmd->sense_len, args.sshdr);
+
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3642b8e3928b..eb960aa73b3b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,28 +455,70 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+/* Optional arguments to __scsi_execute */
+struct scsi_exec_args {
+	unsigned char *sense;		/* sense buffer */
+	unsigned int sense_len;		/* sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
+	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	int *resid;			/* residual length */
+};
+
+int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+		   blk_opf_t opf, void *buffer, unsigned int bufflen,
+		   int timeout, int retries, const struct scsi_exec_args args);
+
+#define scsi_execute_args(sdev, cmd, opf, buffer, bufflen, timeout,	\
+			  retries, args)				\
+({									\
+	BUILD_BUG_ON(args.sense &&					\
+		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_execute(sdev, cmd, opf, buffer, bufflen, timeout,	\
+		       retries, args);					\
+})
+
+#define scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, timeout,	\
+			 retries)					\
+({									\
+	struct scsi_exec_args exec_args = {};				\
+									\
+	__scsi_execute(sdev, cmd, opf, buffer, bufflen, timeout,	\
+		       retries, exec_args);				\
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
+	__scsi_execute(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
+		       REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
+		       _buffer, _bufflen, _timeout, _retries,	\
+		       (struct scsi_exec_args) {			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.req_flags = _rq_flags & RQF_PM  ?	\
+						BLK_MQ_REQ_PM : 0,	\
+				.resid = _resid,			\
+		       });						\
 })
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return __scsi_execute(sdev, cmd,
+			      data_direction == DMA_TO_DEVICE ?
+			      REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
+			      bufflen, timeout, retries,
+			      (struct scsi_exec_args) {
+					.sshdr = sshdr,
+					.resid = resid,
+			      });
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

