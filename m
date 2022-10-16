Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967D1C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJPUAN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJPUAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05D523391
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrL015579;
        Sun, 16 Oct 2022 19:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hQxVcrJ3Uo6hFBiz0ptcjbcp4kwxOTssETzpyjsjovk=;
 b=OGhTxiY9v6JW2WgzoKOCocP2/KyQHql2ZvPx/lWOO04oFT4Wbb5o7pfRfpb1N8m0pelE
 D6nW549UueUFf8JpoKpoPQWpNnyI1MdeKJLCeQaoqJyY+6sXxksTiYQ9nn/l5O96NU7Z
 GjbBm5PvFMl7NPnqqzhpb7G83E6lNa1f1LgnBjUmfpLLpt4FJuA71SLHll338c3oJeXB
 Ii1qxC1jWy+KIPZ6OpY9ARnDJbieu7cYIJV+E3h56AIKRajQUi25CkZGFe8KNNmGr3QG
 69SSUry8HT5GWsUb26g+gpmlBHT2NJKEMM0VmHJh4aFEID7Hwjb3HswBqbQNkXGI6Iy7 Gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g79p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCTMgR040066;
        Sun, 16 Oct 2022 19:59:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0nc0ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DndOC21TZImkxUDEo7INRv3Ptg8sct06cyzzcXoydajIF/dP7Etqy/o5WNSQBrDDTJdV9HMV1FNwYKeeMjYxX9jPWtpW3xpG8rH3FUG55fi6eEJZM5Dnu+sATawNVuOqKhdafv8yokAfaqO+Yr6DZ6WnpS0pv7JN4Tdy3G4IbEI8Vd41elgyCx0so6stwJxQke/HCHY/gdRwDf+1dCJ0WSxRotOi959Ap/XUbETXp2LRlZ5BOfDN4E06+FLoDXfBfOUVTcswgdiMW6h/3+Ump5JTAhsILGtDQVGhx4j9Gv55cEDb7lN7KKXC00NAV+x4prlIG1wlETcLWuTXlZo5vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQxVcrJ3Uo6hFBiz0ptcjbcp4kwxOTssETzpyjsjovk=;
 b=HN/2iCLnV13l9luDDCabTEC5Rv3NT4l1TqV8Bc1QPYNkQa47JMexZ9klY9hvKmLJc3Y3BNH1paMbi7CyrrdUP/N5v9lZ1vkiiScKlSGlaTurTqpEH2OLay6ODufimXM+KmjmmB5QTitsFDB9ZSdUO1JsG3xtTuyx11ENqYRSYT3opleygZxRZ9oMkvjtzfj3WsSrLzby6CjHkMZAVfh4Qv2+VQ97k9ZU6bhDmzBVlTtM4mbvOZd8ZSvEQOthJUPzHY+ZPj64Rdoy4ovAlRVgStNERPzARm79K3dpng6+Aqyj0YFtzqkYOWB9LVh9kKSnvLODXve+si7FbikGUg5PSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQxVcrJ3Uo6hFBiz0ptcjbcp4kwxOTssETzpyjsjovk=;
 b=VwPCycBnPn/WNJIsQPHvCsBXb4EkRqE81Cj4zc9huBQ6MMLP9Qt/2GjbctDAXFPU5vz+bu2tDY4teC0iwQV1X6JAHG6EakLNnsRACs+5xVpvZLXpOmv98cIPj2+6aujz0H+hmVYuyslpIqz8QjkIcXSMhTqqe66DL2XdiJ68kME=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 19:59:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 04/36] scsi: Add scsi_failure field to scsi_exec_args
Date:   Sun, 16 Oct 2022 14:59:14 -0500
Message-Id: <20221016195946.7613-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0008.namprd15.prod.outlook.com
 (2603:10b6:610:51::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 540bd1ca-35e0-446b-7b46-08daafb0ff1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSzYzn2kTRONyBwE3Ijqx2ZvwWMuF6nG0SRNQ7eSub/Ajk5tmbA64N86HRPz/MJhrXCIh9sWav3MAIY2Op945zO7siFXZeOajPmlObmpl/YLb45OyfQk22LmzrOClt0MA2VDmwVMcOkR7QokWSJB/eak2Ykl+OzS27TNKPiBCcSqDk+rgjZUDf3dAybbhisK8IOY+CUwk10fpR13qQ3gGWdSNJk12DlR2PNZf1I1XmuSB9h+KNA8mtPS2Ur86+HDvOoLo/Lwyc9BWGBDx492tY1aQgE1RFaI+FFW0TmtC6XAV3vCZImhe4eNJjINkh7/Tm0t18XJM4XLeXIXfx3aWrQ7Zcx2jIV8/Nr04AHHhy08uziZeYm8mqKc/3pDzz/At8F9n8En4/iOzhjPQAyp1mKfGUjX4H5jrD9kFoHbNyZOi8zc/xZXg/EXU1LYS4ZtTOWLvBeeM9jr/DjHYoBGuI19iDLtvtEwMbhjKpMZi6eHC/PqHCm9GZ7GlGPi8UbRlEFsOliNBwzFyLvmbA/7UrTQc8/dLqRgbFfi9pO6gxLE1Yt3cX6QnfUa+XRlK//aOUZxfXzptp4MlfE/ObmUBfIR302vUh2F/dPUZ3qC4L1qmJRtFT9JWHezSO3AyXuKtl6vz+NQQgezMljOhKNatCk5hRTbJ4TIhmmicxk5vQVQMnqYoAtLrr4zkTzb4/gGSnSn+xriICpeewEFc2/3HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mf4hgJhgwygrL+3PQ029eV6Ndd+liH+wqGEMR1/BSuHZYrAu5519520M/UBh?=
 =?us-ascii?Q?7XZ6r5olQtH45fCxaXuWW5eGMfrhnaT695TY1rLkzgnPI7HVPWW1HgB7kdhK?=
 =?us-ascii?Q?46FvFo7s1+CmcuC4ooBF+ZHUlW49zdkPxYp1OR000EWDnH2tFZAKhjl3mSci?=
 =?us-ascii?Q?FmLCNTln7ERJoDDUkKwFC0VbNa0iEVkxJKYpPe+7AukWIBru8qYzhPpeICvS?=
 =?us-ascii?Q?qdlfXC0T84Fn0AElsClBVC/3QNfu+/o8PEPAOI12uboUj68jafrBpL2DW+jy?=
 =?us-ascii?Q?mzTSGJWMevfTYjditCu5RXjsYu0xf2sNcfUJRJkW5H9GkGmznVg177YgGvmC?=
 =?us-ascii?Q?MexHuRmFTk7VwRUSstWF9KvxqGf7fW6v64qf5/PrNUb/8YZWXMGoibzeVLq+?=
 =?us-ascii?Q?L5oyRSfh/26MjbJkfq8sMdFj+5tVNAXfJjFX6Bzj54uglp7eX6jtZ9p9Fkhd?=
 =?us-ascii?Q?lzTlrz7bnzk8deJPYg98+WxiHT/E27CG771Y8T2RQFZkXWaoZSpvEEV5tmVm?=
 =?us-ascii?Q?YT7fwAdpgpF0yy+YyR6xY3joEk8niOV9bHaHfx4TMbaD+SdFW6djjvcVlq5G?=
 =?us-ascii?Q?YRtHHlEr0WvcvXXSB3ZBtMRWVHqj8qFeFofgo6Bdhg0FAeajvPggpVQzS64t?=
 =?us-ascii?Q?U4sMVo09noWWXg0t4ZQRJXgY1YNULQbtqmG/NgBxcoWpLqOTuyjM5au7jq+7?=
 =?us-ascii?Q?DwBOaAyOMpViYWjiIklXShazVqtKdKjuYiGoQdQ+iAj5pRjtiKb3tykceOcW?=
 =?us-ascii?Q?QR1DN1hwGia9+zrW13zhRniiv8UFqu1FtCTOGwvLvPjPF0Dn/Ko54T5VENpC?=
 =?us-ascii?Q?ifgWB86hqG8bYrVY12tMM6/Mvx/IOVs5IgVVqFF8oIP2nxFRzPvXXrcU0pn+?=
 =?us-ascii?Q?SjQeCYHLLQwxkJg+0KBie55fQES8Mn3lHs/ieveGKc9FZfYroraoL05FgW9L?=
 =?us-ascii?Q?NqnORSpmhRrEPodozuavZhzdxR/3n7EimLMS93/wE3nXL5UJhZGU2ynSPKtO?=
 =?us-ascii?Q?Ml3Nn/7us1dU1ZldtrU7o1Gvd47MjD1VppNMF9X/0fI3mM/D5gt418MB0E8v?=
 =?us-ascii?Q?kCiAnVCemkOeZ05jnAH5JcRnUlENfEl0PgapzvXfhE/8RpIeJXygOgZgB4Ky?=
 =?us-ascii?Q?kt/G7HlhFhNHK+FyCIyspEmFAoVBhDU0RyWP2iczdMxTHWdxn39JjO+GrtR5?=
 =?us-ascii?Q?A0VkvD7mc/N88v8brnAJ13BS+dkccuN6VHgXYQuuerAiK4VxpLp+64xRbnjP?=
 =?us-ascii?Q?lanBa5e+TvnIHf5eF/B8n7yu+ymq53xapyb3+kOPGMv1P1kY3c8orUvfJWu9?=
 =?us-ascii?Q?x4ZSkj/dagUtbhl8eVlJnHYLLuB2x5tdpk2iY6ZOosmB6cNTKFle2eLKOF2S?=
 =?us-ascii?Q?Z/qbSDO9GkFJfoKgdcdhubT/fZgXF08ejM1hBzEB/5ni6aI/rhjvdvtCQipF?=
 =?us-ascii?Q?XOBaOwQnl9eCNHR3hq7Vg/ujWnNSgZemMsaVqJcte19Y4XviVu6b0mhx9NZk?=
 =?us-ascii?Q?7x1ruifhfV0fLJAU0OT5CXwZrdAUc9/5T5l1CyO/LuljOXvdHsYdOcAHsCRj?=
 =?us-ascii?Q?W7YKYBkrwXZovceQy42FmS2BNB/k5lpkL/L7Ghj0D/uw3lAMj9QSy7WFt9ss?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540bd1ca-35e0-446b-7b46-08daafb0ff1c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:55.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /g8OCv7owCiMKG2u/q4vejFu9T8xcKIFvh9sj2QoDOlA2EKKe8dweIz0u8FDOaok+CzjNNfMy32gPIMNQas9duie3/iFNnidblNiP8kL2mM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: x8yXK7ba0KL7IGuqqI9o9qpAO71wYAbI
X-Proofpoint-GUID: x8yXK7ba0KL7IGuqqI9o9qpAO71wYAbI
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

