Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D0CC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJWDGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJWDG2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0524A631F6
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2t8VK012741;
        Sun, 23 Oct 2022 03:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hQxVcrJ3Uo6hFBiz0ptcjbcp4kwxOTssETzpyjsjovk=;
 b=uR1DqYoOxPc22zD+rLSmU2uGgLQAeCsTNWM43WS6XYmrhyalO3mZHeoTlQ7LuDtue4A0
 CEFqQMw4/6x9m+Fs8LvVDaRwG+mjOf3+AxYZ+SgGTg+zVabU4pnRhCiC7Tk/8LA50WV2
 hvBNpa7poHEWNKvDedyWm3KT08wxMFlHuZaWrR0Z2yC5x9R3YKG5NsuT+GfsnoVVunzb
 9Q4zsItxv4R21+NNL9c01oPqqkucIq6m/C0vyw0oKYFGIrvlVI6mKP3qGS1Ppx5OMm6i
 9/QE+vAQXQtmaJqcPlOewPH0dV9DvXx+JbC8m5cydXxX+NiyomFYPIsdmstv0SfVmB18 Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84ss3fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKH3st000972;
        Sun, 23 Oct 2022 03:04:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8grye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fb8WOdBVtkuMn2mO1XJYk/w7GLAg6SRTEQFKRRe7C0HMmCAWlobBGizgRvBaJNlumkzAimB559wHMDITuTHOSEYULNJdCLmrH5RnUBM5l06rWRlE8rqxFFoxSuOJIhA/yGXPLKTndx2hNkUnDRvrXKKvFQwoKcX190RnaxMPcwnq5GYd7IOYX2zkie7fP+ooPPWFw8cd6WDnkqh8lGlLv/6A7W15ctbB/aOmqwN3cakR2KQoysZuBh3qxjU34eBOvnSRfN5P5DXRXrokXl9An43fzt4YGne1+Cmj8OwO8j5ZiKxwMhsRtik32v6AaPPg/fhiIT3cpZGnAICaCWU9+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQxVcrJ3Uo6hFBiz0ptcjbcp4kwxOTssETzpyjsjovk=;
 b=RkWHU7qm9GAUvBcCVh3Wx6PPaahnle7qCJ0BaZc9Khj65LZ+BQUEdbuL0qs7BBhLYDKnGareXSXS/jfTHrIo63f+LPMJ4dxXJ3Qicf0FQNmRTUwlcLmsTYv9JEbUK87wG2GNc8Be+6hHTXGdsBQ+w9Y37lZNlOLJXtB17jNQj0g8qwwaGHuw2/G1JF0oygTvhwB1BcwQDEK5mq2mXbJoiFV0aG52Wc6gBemrIfZtdOlB4Qz5/KKTXLA64fBwBherclfu3IrLSPsxpGa/1zlwsYmlCaXzatxKI67cQhtnR0Hfwx4MJcennftFEakSddKChDWEy2uRcEoJV5Kj9MOP6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQxVcrJ3Uo6hFBiz0ptcjbcp4kwxOTssETzpyjsjovk=;
 b=j/TzmZ/BnrX/hHQ9+2DT+K6FcznDYpvkBGxOx4wZJGCGS45NwxIRU89jt5EFPo5gporNONDINgUMxxXkNIMhPHZIEXZ4Pg0mnephw64bqpajOPcGpaNggQIxf3cipq+mH8f4sOKUmNKItHnz+dwbZd6QpHv0dXLGLbiA/Z85PQ8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 04/35] scsi: Add scsi_failure field to scsi_exec_args
Date:   Sat, 22 Oct 2022 22:03:32 -0500
Message-Id: <20221023030403.33845-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:610:54::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a6d8fc-45ae-449b-17a8-08dab4a34329
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fer6U9lIZfmtRww7fnYerRSmSJnpd6OElNkbmf/XA89qSFQ5lKa1/LsTQrRgaL3wAy2G2TBxUDb5pmHBJVHtYNetIjhqotjW3JcEzvr/I7IhiVLTkx6SK/VacTehxEMYKz/0LbmyyJlkfUSkE2R7qT0irx4JjvJWQeyTtOsl/enFW+5O7Jxlt8WZx+ElC6HrWiAqZWPRs3mdpjBwIfPSMhWAKDJGo0rh9Ces5ORKR9lzOGmbVAWnaQEnALPwjPPi/HRfkklOWQMMXzxzEUYOo88IohMtpNdx0ZNr86iGafllTW4ShD4E2Ghc4z+Idu6mbM/tH6dvoQnc5WewJQEc8uCO8xbbrnNTzLlP9RNzFnTmgYWV/YIakfzoM9awOEtwJmG9KxkelfTbGsQonPd5aNSnq/n90DjDaYh0FuHb5WW4JqFBckt0A1sSPC9t1DF/eu3El7Uzt+HeUc0tqRmffs7sdt6P8LmowINoWxipAoUxSUEOdoW09jZxM46TsjVemrVT+mOxmWPq+U19UibshT2lNwMyfJI3s3NpHIEYTH6gzq+G549TdA5zB21z7HJ0qjME0HMTXrG9rYQ40BTI3a9ACQcLyz1ViM+QJaWwskmex8BO1AaMv9zYkmUC0nD+904SAMQijFNhMzoa05kW9zAmud3IucnTObRF0v4oU8LSAOaitsA+Kez0sLk9Cmw0rKGdba+fYTuPRQXDO78nVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wE8xLgzBvUYOomFLhDEPxNmMQbPhB9Y2sRZMzVNSWha2ajBh2UDS0HeZo2Ba?=
 =?us-ascii?Q?ASN1Soj8aYn2hox4zygN1FdUne70oMDYIeUdyfoPPCuOMJ4lr1VRNeXDHMaP?=
 =?us-ascii?Q?MN+xsq3avxxRONXcPq8v8s6pKjvc2HrHl2105IQNGyxaKCIXH9rYAWThd/S6?=
 =?us-ascii?Q?TfWrha1fF9UXZahJO2mKDBM3VTpxiNt8j0aq+MtpbwZ5Y4bkrf3wisc4y5Pm?=
 =?us-ascii?Q?6WjVeipg6fqLBeIAg2b7dO1n6c2wMbgEvxty4jnsodRZFP7AT7h1x05SMgg5?=
 =?us-ascii?Q?pZwmWHYhIoGUws3lnr+NwwKirWoabkqHMWIER0TDljQ05IL0YJUgwkNeTOkX?=
 =?us-ascii?Q?m5ExhlblibRKLFlRmkvqozNjZa5vwNd4p/pxI0hrjdaSuCqJhhm/jOf0kHtZ?=
 =?us-ascii?Q?YdBa7rDjmMsYXQkzCCSiFqUQgb54v2P/500xS47nYAo4NkVOjMQ2Z0NMtA1g?=
 =?us-ascii?Q?/5xfyTnBCGdniYnaa/flThPwe6HEZ6FzUJWuU54uQ+vBKJT/HYroct0jxZg4?=
 =?us-ascii?Q?/6LSSxm9qVkONlf7cqSm/RlgVoiLyI/6G82y+nCYeGpUX68LvU58BiHcNpzJ?=
 =?us-ascii?Q?WyY5FBcrcWMM6H29IWN1/Z2hOmQTedzqvjwGA5Uue1IyQxOXYQJM15GB63l8?=
 =?us-ascii?Q?mtYcHnUj0Zrcq1f3owgFS2h6Q7WlKC1WQuKTqNC1klaETE4F2mLh90/euJXH?=
 =?us-ascii?Q?FCcK5d8+LE/VsVjSMk2Xajj8acrgpGqb8otgHI73oCxJWHuyYysEjij6FUEy?=
 =?us-ascii?Q?D2/UGi6sMxZXsuxKJ8zPML3PTGs6DOVRAqoV5Qmtwc5BZRiWE0noYQOdregz?=
 =?us-ascii?Q?wCV4ey4+JpvZI1edEqMV+2QqiD/HBj2Kzzwkg/7MS/DD1qrR54f7fx4usahl?=
 =?us-ascii?Q?+K6n3p6jxpN8a1QYX2JMJ5LpWk4+C0uS+WoJFzHyA11WgDb/El/u2HCOzqSB?=
 =?us-ascii?Q?74WTdM94EeOjtXYOZ69+pUFTt89fnsH+HKqQ4/S76Fkx7P/N+0d2+UtBqI9w?=
 =?us-ascii?Q?nKfCIe35daR/KAYn50+2DmwFWXhihNJ2fagKRo9iiW9nGRysu4oZLqmqXS4J?=
 =?us-ascii?Q?w5VlcYwqw1J3YsfPkGBiRrlpBzvTrY1T/t5NcunEneg4A8z/+yIbAp9hbmAd?=
 =?us-ascii?Q?Rx2+F2kZcchlilFm7K04JP6VmZ6mptEaCa55DjGWFVLyQYW4Gpu2SzXom0Zu?=
 =?us-ascii?Q?3I4JeCoCyfwHin/gskQFRtEucJvzWEHQgGAaHdQb8BS06kZdvXJAcfKciIcU?=
 =?us-ascii?Q?AkyoPn5nVX82JoVjwh+xKPyq4H2ILTjlXXn4x2v/iATOxG057pPxenskwIEd?=
 =?us-ascii?Q?4vF2CjBp0mq8xIpM2QA24wedXdxw/yodQR4Csk6iyZIs7+1xbzHWwKX9itTD?=
 =?us-ascii?Q?Wb92dMCZYCzJ9n7J41QMYrCOnLYymZNmpMQTXCePJBGXqJm8rpR02MzsYkri?=
 =?us-ascii?Q?9Ic11jy4tZfKJxpERxPIXqjjwYlA4FeWw4hR9PWJgCbZMcibHRxbuSO6eUrm?=
 =?us-ascii?Q?WTlW1Z5U8BCf9OHDWsSRvcVKWBxoWVy/lnt+bGITYTc/oV85ymQ/1X7Yjl7R?=
 =?us-ascii?Q?k56bvKbSFNsmSENxZFQ4S1qYPpkXMtf/4AQizsqMdO8gZwZ7/19awjoCfMi6?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a6d8fc-45ae-449b-17a8-08dab4a34329
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:12.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OY71ugENb89UP1yGiVJ1W9CoHY4E0Pf8fWPxea/cHfFzbJceF7d7Z4f5Uwmk/pJKBABctm0S2ABnZOR3nZ7nysBsfpqOOtyOk6qieo0iStU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: a2WpvdSeyxToN0oBBXZW_7JfQtqJ7aDD
X-Proofpoint-GUID: a2WpvdSeyxToN0oBBXZW_7JfQtqJ7aDD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f0c55e2621da..0ad0e476f2cf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,6 +215,7 @@ int __scsi_exec_req(const struct scsi_exec_args *args)
 	scmd->cmd_len = COMMAND_SIZE(args->cmd[0]);
 	memcpy(scmd->cmnd, args->cmd, scmd->cmd_len);
 	scmd->allowed = args->retries;
+	scmd->failures = args->failures;
 	req->timeout = args->timeout;
 	req->cmd_flags |= args->op_flags;
 	req->rq_flags |= args->req_flags | RQF_QUIET;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d49a7157d7c1..72d1690f4ff1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -470,6 +471,7 @@ struct scsi_exec_args {
 	blk_opf_t op_flags;		/* flags for ->cmd_flags */
 	req_flags_t req_flags;		/* flags for ->rq_flags */
 	int *resid;			/* optional residual length */
+	struct scsi_failure *failures;	/* optional failures to retry */
 };
 
 extern int __scsi_exec_req(const struct scsi_exec_args *args);
-- 
2.25.1

