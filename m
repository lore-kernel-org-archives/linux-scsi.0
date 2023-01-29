Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C60C636D0
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbjA2XpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbjA2XpH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C64B1969A;
        Sun, 29 Jan 2023 15:45:06 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMfjJb015535;
        Sun, 29 Jan 2023 23:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=keuCnTYWfNUQYorkCDlFE6ZRa5IfkVBfsJkrKx+DgJI=;
 b=3Iu54p3GMDu8FlsT/nrDGLqGFYM3tUK8hyBCkzlFUcATFuTQtfVrg+UF6AknA+IEsYN1
 nPAfQ6YdEtm4fzsd0CvOx9dKH+ESUiSeP4iSi7G3Jb962rDnAyIR3LwrTkO2r/2IAr5W
 6AlUOiBnDrzb5ipU7sm8NTE2u2suSQQHRbrYGSTF8pV3RxWJ+tDrhDpf2OOvsgcMwKwT
 xxO8yT8oakOfI6X8xP/oxZhFEeMmdsiu77yHVU1J6cvsA80R/BlVGanqIctw9VSEK+iZ
 aypRJAG/XbnI/hpli/3dl5XYsgASDizi9Qip46zpEZUrDnd6zapZCcgEb3KlNUZ/yY6J Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvr8hrxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TIZL1O019074;
        Sun, 29 Jan 2023 23:44:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53n3c9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8Al3ZtEgrpSLKu4vwpl/kQAgvZgzfeekYmFfVxDPmuRph8MnQfFEj3RFx/jCtErMO2zWauqxOIK7MN7PUp495I2GCuvsA7oyxHnuCjQwyBtjoAXIsgUGSCnxVyiHU6aNx7/sR3BwL4Kevj/focpqXTiEJRT33InDPjKp+ZsoEmV3joJJDGzl1nLH8NgArl0fT3H6lt80+huV73WsTTzfueYnVr0l14AuS4mIwU862vE3ne/aeBKW/P6T4oiW7fMqyymla93+RQl8ag+VGnPznW1q8oCEG5oh2wIUM+z/MW7aoypPLU+7D3LV4/NLJCAYjfL1kDaORpo383sMvv/Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keuCnTYWfNUQYorkCDlFE6ZRa5IfkVBfsJkrKx+DgJI=;
 b=auiFVc1+GX4MOHk7qibAtdbkbBR903FTGGvVpKSpdrFr6DhN5OFNQsv487rOsHZAOT06FX+rWOLmFMTrl/6TwCdmgmlpUtOJzPfIBW6R1UgmMkZJUclq2+AqFntIEIlOGUPZ6mJxD+PXJ9Pfl7E60AAXQao/OlvPxahW1t4DNJAunzKRuT0Nt9XFDqIsobFg17+lPB9TBXsVBldvk8EfHlyLivTbarcwbaIzjL5iLHJGXXhR28UTeENbg/qSWe46nJG9Kwib5lA5KM0tHTYG8b9Ykcjk2tlQyIgfPUtg2iU6EpRO5vG4r7kSBRcLuMUCKOAFBEZeooc1QuD6UcYeRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keuCnTYWfNUQYorkCDlFE6ZRa5IfkVBfsJkrKx+DgJI=;
 b=uPErZV0BBm2HennXfEXavFuCoiSiZnRUmO23KDfxVelc1l6Rpx/OXRx49VrTvi70iWS+7WCrQvi0S4vV67aS8XQ2NU5xpqRl58globI+PCJjZfVhBlxPxABfJ/XTg5djoIAhC5h7I9IDsDPlc00co9eg3s5L336+teeMcOtlPWA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 03/14] scsi: target: Pass in cmd counter to use during cmd setup
Date:   Sun, 29 Jan 2023 17:44:30 -0600
Message-Id: <20230129234441.116310-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:8:57::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f3b571c-b59e-4ca8-7c53-08db0252cf09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMRmu5xaFQc9XS6I+8SCh8dqPa59jFbwG9BqO7X85S7ggnTH9+k+A+G0MgMB0LaAflBVT0QLP6zKua5Ghk+t0SIa7zmhHAhCgigSu6kQzCxlpqFg/eQhDX4IUaxd7ggRGRguJ1y4BM1nUmUtLD5IuHnp4LW3nS0ed1Kk7HvzS2BwlzAUxJFzbjLM6d/eRMQH/oypS1CoePZnWQ9QaJoDJpAqwYECSQ6pdkKmChtqAA4rfN14sXpCEVaF2t3JCkR9Csd98ix0O6bu+CHxfijk7ZqLMtixv2D95Sl7+H8H+3fl2HKkJEjgmmTrh2Kndoe3pd9PZLBK+it9gBCQzy4dw8Eu+S2WAA9YjSb4hN6RcqjXDC6dZruSj0nT3I99WR0kadeKQJuYbBhgDiwLckas7TImXWaUhc1HnX1rFbVSxXq5s8JDlOB1e/gbZsIQm/NBjmeYDLsopLbOiVDOAxatUi/ls2pzFm27uCDkcbk1TDrvmpaJ4Tvb9nc3MSeCD6RPWdh5s2uuWU6+qSjAIFaBoyjoLt2LMr/fgH09y7A2Y70Owk/5Web0nH2CGgM8VkWQIvLqBtrmtWNK/UBwcOHZnGfqAkHwfLt/JZ0vR/5Aq8iU3IOAJ4SZm+RULj2eKyO7H9OktHpjGbCn80pB/R+pHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gN2Dk6TK9gCzKksAuX/deGiOxrTmc2X6Xj+cdGknee4i4nV/jA+gtFQh1HuF?=
 =?us-ascii?Q?XrZe8qmH1dUlf1R27R2+Uq882SnIaCrPG3uUXKpfXeyFxaKwcXP39AILLAfi?=
 =?us-ascii?Q?NaaGv+X1BDdWhIFkFz/BcX9juhVm1oTITE7b4Lczm3gAP9OGbhktOX0ZjSEw?=
 =?us-ascii?Q?jKoY0g3vSCiUxL2xaIPytlgphL1ZMqlix+gYgir6zLZsiQUB/Giz/VCUoce4?=
 =?us-ascii?Q?DuMv/WGjHMNr59Wyu82OWtPUCL4gszrir20PSyQuqOUxlbxrVbktrr9hWhR3?=
 =?us-ascii?Q?QqqpQ/+9T3TgD1g5Li8wdepQ3bq8DbVUgYJSFhuwSlF+ShU/QR4VvnOl7gu/?=
 =?us-ascii?Q?g8FeMxPNN3zC92c3XQntNlnnTPx22mArjieLft/B41kBndOmNNiRfBep31O2?=
 =?us-ascii?Q?Lu5m31whU7AzLJBT+XBKJbPVuJ2ACi/Uo09Yhde6xf+3wD+p9AvqefnNRyga?=
 =?us-ascii?Q?6hFByXTztsSChymh1RxpCMMV92LsqJBcOE4eMEv3SO/SU6y6y02RYPv5aNOi?=
 =?us-ascii?Q?I28WZq7Y/t7+MZlOMCh9WOtCUU1GUk+LCdx0W9Cxhk6YoVVSbF22A9K63IDw?=
 =?us-ascii?Q?QEReHfgnB+wz/W3ygDJ94F0cezFJ+DPxLi5K9foRbaQB+LQDY5F0EVeIBKNK?=
 =?us-ascii?Q?wytFopq6+XMQCqsVt70Sub0CJQm6zpWK1vdFnqVFrvtGGR0V7hh3QGm/b5qj?=
 =?us-ascii?Q?F053tGNLTiu/E1ODuPinin235YIIjUFPEuS1obHJPQNnv/8gsiJBAF0nWYBV?=
 =?us-ascii?Q?NjZrdmAcMVVxRWiM9691vrSdfzU1lr8Nu6OIwjyVQul8TYUqOuPxpWkcMV0K?=
 =?us-ascii?Q?O7wI8GGk/XbA4LYxGppuNh3Rx+yKcmeo0wvQ9nsdcLzW/WG4NieKqoKXX0NK?=
 =?us-ascii?Q?3Gg4/Uhjys7MHgW8X6+Wyui8vJUXEhdVreXiv41wxlqvkrtDo78TawaNF2mn?=
 =?us-ascii?Q?7H/JnT4IIBwH33OpdFl80SdsmZ3QRHiihVeGoAKzS03Ad32mqSK8BzJS1BUj?=
 =?us-ascii?Q?6bNC10BX9E37gbtjwM6PjMvJo86LpADAVHLrdcWqzQQ1XPkTdwrNeD7IaVwu?=
 =?us-ascii?Q?t26n/iaENBdKymI4hJTdAptl5rOBGJIApm0mwLRntYpxCW7jq8cRiOmekLf+?=
 =?us-ascii?Q?nzdAFN2fX/h9Gcl/kOfqngnd+G35VNVOH0BvTk2pSWSFTbEuXgsn35lI/wes?=
 =?us-ascii?Q?0NgS9jvWut5iFD68IeBeOXZNi0dnCUV3Clqw9V9jqDcyLs0QV1nYfGFM2amp?=
 =?us-ascii?Q?bFaSOGnuOpQyrL1q8RsXm5qdau28rgSFyhQVKUW/i9tY83PMBiamGb9QroQL?=
 =?us-ascii?Q?4tdL9nzVSdzd8FdyR0AssYFdMdWNxDdLURY2THHcSR4fbF90Gm69fDjElWOv?=
 =?us-ascii?Q?vNv4QDEUPoeEDryoGdE4qnd71I2rmrOr+qAG/yHwj5PmkBYC5jzfIoZJ2RPP?=
 =?us-ascii?Q?eHerJwVlAhOWyTa8mc9wbWmrcaa0PBO7bSTfs9z4gAS/Z43Pg94FDzbbzlWD?=
 =?us-ascii?Q?QaSqYDQCvA2ln354O+JgrYB8peWpUO8V/HJGrJAktWfUD2MPsQ82Rojnbnkn?=
 =?us-ascii?Q?0O+QGGrtm9rp3QBiFCVtv4v+xrFPwzrUsSnbTrgYcYCJI6xE+mhCuDaoWOVN?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HWDTbBX6C7G04tIUcmRarr++EgY853VM0od5aWhUfuwn8ChChnUnZWSER2LpYlCmT3C/9duIQN112wQ2hRdfxL8iV61FmO5duiWQ8pvB8nP4cWqT4bvdypWBqnk7hBm8SoFHpHGZel6JZR925Ea3RsrMPeFpVXxxOV8EFIx0NFfbkf30xsBgDDPFhmUzCIAvlqJNwmT02OtGMoWClZsbsKlAv0TmZFChbBj5DkhHV5JAuzcxfjQmgui/Sha/nEejnPL4q3cznhxNmtFwbu2aUZcyR+M8RCcXG9hJxlSrcq0oEu7Mym3FdZKNwAhixjVVei/CJdmpNCzy+44qnMvVChVc82DL7+BzGMrEXIvbnwxK3Ur47gakAq/ECLu3BehIphlapgnuOXaZY8n8Z37Q4R7Ha8IanUEgFr9YdfkGYuBF8O9fzBgaBebFgXpspOD/DpupZuPg8xXMasdP3UhLAyOVjhD1dKwl0BGVUpG8geCNgujmf2cRKclKFrqVzb1Aq830/Vl94PLy5nLS5zn52FO5odFJoaMTcxg2f98m/4Or4DiE2NGswrk6CuaPu69rm6r6QVzDwNMf4ukeRz9rwhAxSZDv8nslYyL0xV+Ls8SvPORCEZc2iFPKppD4CNvP2UYkyrwc1WiD4tENE8+OydDi/kqw2dSOnz0C1+82sd+TPWlRdBF5922w7ilRnMiV7w+cq8TBaOWsN9G0AavVTqhlMgBWpnzMOw7ikkomb3ICI9p0xuKZfMdW+VSOUrgAzxZ3sR2cYIQcksqP3Ls5r/F8P+AHA9MnJuqdR+tjejgrvHQXPIZ13uL8ncx0DJ5lZ5tQaR1sKrW/zfwzm4LtqpbUlEkz6Ff/cUfaxLDgLJYrZQeToJzcon2sx0/s6Csm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3b571c-b59e-4ca8-7c53-08db0252cf09
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:48.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQ38jY3QTZiG/Ipy1nD1SYMgj+0oXJKs7ZjTya08y8NqJ3s/1uLo1ZS8koyyXqLA9FjT6Prg9a66uKhnZ/h6f57RwL4JpduX0GqY32lmZqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-GUID: q3P0xSSHZ8w6O1JEA1TNVGX4AcYKnYxh
X-Proofpoint-ORIG-GUID: q3P0xSSHZ8w6O1JEA1TNVGX4AcYKnYxh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows target_get_sess_cmd users to pass in the cmd counter they want
to use. Right now we pass in the session's cmd counter but in the next
patch iSCSI will switch from per session to per conn so this patch will be
needed for that conversion.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 10 +++++----
 drivers/target/target_core_transport.c | 28 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    |  4 ++--
 include/target/target_core_fabric.h    |  8 +++++---
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..87927a36f90d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1190,9 +1190,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
-			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			 cmd->data_direction, sam_task_attr,
-			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			  cmd->data_direction, sam_task_attr,
+			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2055,7 +2056,8 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun));
+			  scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60647a49a1d3..c395606ab1a9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1441,14 +1441,12 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void __target_init_cmd(
-	struct se_cmd *cmd,
-	const struct target_core_fabric_ops *tfo,
-	struct se_session *se_sess,
-	u32 data_length,
-	int data_direction,
-	int task_attr,
-	unsigned char *sense_buffer, u64 unpacked_lun)
+void __target_init_cmd(struct se_cmd *cmd,
+		       const struct target_core_fabric_ops *tfo,
+		       struct se_session *se_sess, u32 data_length,
+		       int data_direction, int task_attr,
+		       unsigned char *sense_buffer, u64 unpacked_lun,
+		       struct target_cmd_counter *cmd_cnt)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1468,6 +1466,7 @@ void __target_init_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cmd_cnt = cmd_cnt;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
 		cmd->cpuid = raw_smp_processor_id();
@@ -1687,7 +1686,8 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
-			  data_dir, task_attr, sense, unpacked_lun);
+			  data_dir, task_attr, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
@@ -1982,7 +1982,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -2986,7 +2987,6 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  */
 int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 {
-	struct se_session *se_sess = se_cmd->se_sess;
 	int ret = 0;
 
 	/*
@@ -3003,11 +3003,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * Users like xcopy do not use counters since they never do a stop
 	 * and wait.
 	 */
-	if (se_sess->cmd_cnt) {
-		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+	if (se_cmd->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
 			ret = -ESHUTDOWN;
-		else
-			se_cmd->cmd_cnt = se_sess->cmd_cnt;
 	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49a83500c8b7..91ed015b588c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -591,8 +591,8 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
-			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
@@ -636,8 +636,8 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
-			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0..c21acebe8aae 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1054,7 +1054,7 @@ static void usbg_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
@@ -1183,7 +1183,7 @@ static void bot_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 65527174b8bc..d507e7885f17 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,9 +151,11 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	__target_init_cmd(struct se_cmd *,
-		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *, u64);
+void	__target_init_cmd(struct se_cmd *cmd,
+		const struct target_core_fabric_ops *tfo,
+		struct se_session *sess, u32 data_length, int data_direction,
+		int task_attr, unsigned char *sense_buffer, u64 unpacked_lun,
+		struct target_cmd_counter *cmd_cnt);
 int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun, u32 data_length,
 		int task_attr, int data_dir, int flags);
-- 
2.25.1

