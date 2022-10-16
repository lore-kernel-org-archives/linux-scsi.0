Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA18C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiJPUGR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJPUGP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:06:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA0932A92
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:06:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GK13bO014899;
        Sun, 16 Oct 2022 20:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YjrAn5VLPkT2+p7vbcDBYRL77YeE9wnvFdg3nj8EpRU=;
 b=K7l5cLpFtAq8l2ohQfC/4vS6sjgmoeXmZta1aUSyGe0FtPfvXzvtqd4NH1mcGQITAsx3
 1Zba5WioRvZnvSLkNHbsejBrxM1j6g6C0wgoASr/48BQU+gf2d7WNoBwPYD9B6Ols2cQ
 sKah6Q+cAKvNKjpIaBD2zWfEKEU+nAtVqDtLWsuLYXyPM9KNdL9D11mY+F1bZ3gpAOAL
 01VY8wMky3oettO51eMQiVBrihBfyZaZ7vZZoFw5zm3vann5SZR7H1mqAWlBiS03fvqi
 It98jU3cG93X6zXav/cC22bCT8zvZAOpGdlyas2FFuZZpIp1aeKnt/KtoEg1kt8Y7Hph jg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mtyt2g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:06:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBwgx029658;
        Sun, 16 Oct 2022 19:59:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84hqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMhWU46EDsAQfzWJLdEzoWsEmHpfyw5N+J+vzhlEPFljNUkqR3bzAscRczdi10ApgZ3nZ4te46ToQwcL6Wfytl1NblvBuELUb8CDu+/TkG/H9GTEG70J0bgBQIqYKBz0YEyAFXlaDzkdk4k4J2H6buNseH5UpBBlLB7yucinYkXgBw66jcjzChGGI8GxUL5WlnOs4TbOwdRhUzU/opeHLzoJT0zExmrWTGVZPejyNBCnW9DNBRbUBYh9zpvHleBzyfHyWJUd1DT9PbxqHwWX4gGYCbwLSLsz19ZzX+3Yap9Y+3+pI0D2qEEukGjQWxuM8xTrfwKSbnULBWWPHwspIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjrAn5VLPkT2+p7vbcDBYRL77YeE9wnvFdg3nj8EpRU=;
 b=Kwb9P3qzWxx8o0RclJPUdTAkQOD+stQTJOxtgySbzbWUu1HZNAqsVc/ULDX2tOyUYyccPIHa5rXBZogx1zN9XOMwVZiKhsZ8w7+njvv0NBFIZeCoVSNbf5Rv6ok7q0gFNN0lPQvMGfV7oN+NdASPYHHFwrRwcwodOHWSVsZo8PklF0bNqpvY/+GJ3POlxmRiKSL+og/SeWBP69+srrrZixOcgS85iSqH09Hpx1x+sI913EhxR3LCSB+ve420HfR5UbyU2MUMaHQSI2dqmajzrgIDCqshF6ou4itayI0mFkhJWSIECpm2XOfwoX5bRmXE7hnyONVPu51BdWIcFFYNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjrAn5VLPkT2+p7vbcDBYRL77YeE9wnvFdg3nj8EpRU=;
 b=WtVARR//Q5moElaqti6+PWzozk2ADCImRIdQUK5EbIenq4ZMIAJwcnzL8FxDuxGRyLk/WFg4tsdgofbKEbHoIT9HNJeFqyVVkXlPWqfMo1iYLvOIPodpVxZvRwzkfGFX/bL8j04o+zx+haIAFut8rKnpHGp2EFn6H2qL4kiN1yQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN0PR10MB5909.namprd10.prod.outlook.com (2603:10b6:208:3cf::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Sun, 16 Oct 2022 19:59:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 01/36] scsi: Add helper to prep sense during error handling
Date:   Sun, 16 Oct 2022 14:59:11 -0500
Message-Id: <20221016195946.7613-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:610:33::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN0PR10MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: af2ad53a-f8d8-48b4-fb26-08daafb0fc42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jc7FhHWKL0pqTZUUn9ipCJ2nAB5juCiVvpE0DO3WJgjdLRQRCExmUN/IkONF5U2h9IHm75OoA5qcLlRE0WIxmYVBV8T/1gqBsRM1G+KPwZTu/xUyp8F5NDPEb82KK4x1cmN7y0iWLkyj/fZSYTAF9SfRNgnvverVXeKLPEbz1wuwbqcrMuvKdnJ34199EqvxJqV07M8TVOOv6HZZWOy8IwzD9EEjrFJxLi1qFd5MkLQQiCv4uuQtu8pIA/vcIlEhceDGuvRvJzPceurhz7hU6+GrCF2D8uaVgFVcg6g3vNc/ORCncTU4m/gBzBrKw5CTlSi3ew/edtVyL+gcZF2+aJh3fh90kvjrisvlCi/Q5z0O30BgUE5XhntPwhKNTDxnR5SV3oaIHu6yDtg1z46rP3aU/P/ZeJPYVTYyJKZTZNrKIavDZ22BMRIsEmLnfuD/MEcPc6TY5quwegv/Qgmw4iAwhpMWMsa7I+b0tXrdFJjA/L6632q1vEEj7IqGqiAKVcfOblNMMsFSRi+kDNNMGAhhWxuhhu9H4xKuTUoM1z2sCkc2fMqASNOJsyRmGmPalC21nuZ1ZbcLWi3K6xNB1DrV2jvNPq6X6ziZcJxXnae+Y/NsQyF/ieFKe4e2x56PBqhr0itp0GRYdG5fn5nMmz7pnLQKMQU1vVTSb1AmVwuRcaAs+VARiYVKCGfsvyEGAJY/oFlPIO9nKbNK+lYHFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(6486002)(316002)(6666004)(478600001)(107886003)(66556008)(66476007)(6512007)(5660300002)(1076003)(186003)(2906002)(8676002)(66946007)(4326008)(6506007)(2616005)(8936002)(41300700001)(26005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?er1QHryK2F8TFrOI5IKjkKiHFps6wAbYDSfvH4FCL9FukrSg7vGsyr8k0Ydj?=
 =?us-ascii?Q?6hwoLTl38Y+FQ2ruU/mqQj7kF3y9o5ZakFIXo8l56qEtiKYge26OPvOoscG5?=
 =?us-ascii?Q?cXFuWkFsCV69T0rQc3LOzBGlWn4im0E6hpHOZXtjlZMQjX+gkwQzgdYsWZX8?=
 =?us-ascii?Q?xAdEWjmvdHOUOJMTjT1nmC/Z5zfbZ9QAfguHIJqf4h6W6gkN5Jl1aqe8+Rxg?=
 =?us-ascii?Q?2gnxo1GTw2tIRWY4FEwf2e+LQ7XZKzw0P+47k1pnN8qeSL4mm8gRXTJH7ODX?=
 =?us-ascii?Q?MwkJ4kolZ10d2H6T+LOleoH3rgXOA2DLmIBcZCX+lA+nhDbKQ8Kf1/nX15RR?=
 =?us-ascii?Q?78pwe+H/0MT8ZXCdwsR+v05mtphE9eP2tZfpwnoDzBDWZ04NknjTL/dEeTIx?=
 =?us-ascii?Q?7b7dD3O9zGcL/j92rFQMD83HgbNUI75ZVNkQn/nxrgpUgV7zd+Zt822L4t7v?=
 =?us-ascii?Q?SSVlS3SH4yntOj1OWuqYnIcfvyKDrSEojngu6bV2q4OykHLmRlfeU1b23eob?=
 =?us-ascii?Q?+FRNvN9pXCGpQLmwSGKntLb6TBaqRqxWsJsRyfinDBqv1GAjS0y8HJl12/xF?=
 =?us-ascii?Q?0nBC+Z8Ti2mifDjo41OJarn4FnaC7dvspb+hB34O9Ak8bXRCkQeqwK83vZ8K?=
 =?us-ascii?Q?J8ZvyBPHiG/8QLw2iGCpL562vKGMp/ayJi+LTN7VkC2cLs/TPxIT7zOgKxUH?=
 =?us-ascii?Q?qLdKjgKHvTvQTnH5UtSFy7CLXC4nVNtVyG+X7T/81Rva/ivgqdNV9q1uaxbp?=
 =?us-ascii?Q?yzzHRMToO2nJqes4B+d7wHReAXALrijPKyUFfKSm3hAZyUoAvazPln+dk+0t?=
 =?us-ascii?Q?DmNW/xzObfUk44ba8XyRaqfm2HLCpyPEzlw7cNQEFSXLQyuy06DavCAAFpro?=
 =?us-ascii?Q?0frzyxIYxRC3DoaHVHq8Mv7xZzFuS2I5jB+LA38eKaBKrzrtJaLryL42sxAW?=
 =?us-ascii?Q?4f9NWawsUOFk2dqUwfesN1pS4DojkLO4Ir0y9FAjSmE1xCLBimb5msMbBP4W?=
 =?us-ascii?Q?j3W5C/ecnlz0aQLTuhUMXJXf7gi68+K5zXvs7GImpoMchFUJjL1pC56a3KHy?=
 =?us-ascii?Q?7+FNIPodmtAbTxjRa0GvNMdQZwhLePFs9+wRRf6DcYZaKiiEhZWzzicEm4bY?=
 =?us-ascii?Q?oNVcET5YEk15FYGVUUiwPIkT1Oh8LxTRRj/TgCliRJ8QVdkuq+y4MKUkzLt1?=
 =?us-ascii?Q?LP8d3M7UlqDQtHAjj7g/VmqokXpxiSRD9Xh6Q3PHjZrYsIScflWY6acd9L5g?=
 =?us-ascii?Q?GP55ukembZ6d2U/ckYtZU37hqtcGs8SC/wX1op+Zof/v9IYHyblFuwnxy7Ko?=
 =?us-ascii?Q?u50XvaM0dn7FhZ7XTiJJhIfkFaD3rWUDM1w/RYGeaS6aH9Sfq+gKtsXFQYEc?=
 =?us-ascii?Q?T26nidyha9JjMKODgAQdx6Auw/TXPYdTfNw6M35PEpDpkp6e+FFr0zFhfAWE?=
 =?us-ascii?Q?1ayYqYfsac35iCzu0DahkRaIcxXFfjwVgEi2izKcmmGkXmRTjevNu7Z+GqyU?=
 =?us-ascii?Q?SjXqEaRo92UxRho15lqkXn0b0Gz1X8Px/YJ/yDcXkS/QhypKRuXQV0VotmtG?=
 =?us-ascii?Q?RjOsW4cNHdmvL2+6jRfF4MAc1NZhBuvWmD+4qeLYSZm+U3T7JrjOz+yYTZYP?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af2ad53a-f8d8-48b4-fb26-08daafb0fc42
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:50.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTb4p64rAT1lqLUjLN1/ecca9uPaGq+Eotfms9EYbsVor6gL1wl+Vf4ERs/b22O973e5gP4I6AY/Uccfwma2p9mWgSP9CB2KIrHUvqubw0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: LqYBA1OwfKMuT-Efb_XAyaNDfbHaXMgM
X-Proofpoint-GUID: LqYBA1OwfKMuT-Efb_XAyaNDfbHaXMgM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6995c8979230..36ae7cc5e7d9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -520,6 +520,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -535,14 +552,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.25.1

