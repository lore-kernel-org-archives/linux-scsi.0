Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04F5C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJWDEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJWDEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:04:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA9B2669
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:04:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2ssKw014061;
        Sun, 23 Oct 2022 03:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YjrAn5VLPkT2+p7vbcDBYRL77YeE9wnvFdg3nj8EpRU=;
 b=yjXbSCDrN4VAMHI2tHZErLNMFfHFnUKFMHRROo6RftDdOfT9GLBAOG6TZBQm3yjO5AVL
 2aOrrZX3bb9j2pXhP5G0LAjS8ceXZISUqxCzZ5s5+nvGj+VLqKD/poYrx9KJB1KJz+cz
 v4+xIDyT/7YxjMyGS2fSU0bjmiSLKxvnuEOf9NI+ca6mwj/F4f88GQoiPQjtm/VDvNLJ
 TiPwFZTwF6hbsBhVj++w7/h0+BVliYP7Ir3jFZbPyzR2HVjuNGWshxa5IVvbwQipoaba
 mWaDTjMXKM+jKtM3T69tGOOIK8f5XBPVtEhff3/G4eYxYZ7OOs7wYAmU/1JSQCN3I4fo AA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJ548h030616;
        Sun, 23 Oct 2022 03:04:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2ryup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjascbDT/gHZdv2A8hBYfj1A5npwW7DL5aLlUyIjMhGjppkfAzcrnfgBWmHNqZpbiwpvBT7x7Em/ddGWcJ7IdnCN2fG3J3q1i7oeI2/5sT5JG+FYnrqpl9IqelUuTix3bQuEvQXOPngY6rWXpYY9Uv/DSly0Mbp/nEoOnb1cijuE//vqW8or3ajJp3/4bH2Jj30wlzaV1vNJKfdBCB1mmk9cBqLqevQRGpHfGqpP8BfjGryApViwsEWxBk0zOch3GP3hHDnUl8KpAG4EHQY5hWnQ9C8U0C43LXdH4eqQlrlwHX5khYI35ctgXUAZkHGaWGUvJSceKLmNxnXjhqiKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjrAn5VLPkT2+p7vbcDBYRL77YeE9wnvFdg3nj8EpRU=;
 b=BfaEnluER+Y+WjfVVWSsme16sOlStjKwqPZiTgUn4VdWy9eh+Zs33lBpS17eunsHJCetJfZX86h+hfpMDMQuCb97rXfFbjodplSGjHuXDPpEtGK/ThgaUMNJcoYndQ0mHBZ3bqXLVOmpF+ECoyY3gnyV66I4LMmx68xM2+2lTCoHP+xKtggldeCHTw3S9RP3LUD7ci+j77CdWAOaI+YiuREprR5QLUPHDv90Yi2WFZUe+V2ToKAcibOJa/JbL9dyNHwffEJcCusrspQv0b975wze303b8cZDT27L/EA/p9hlrj3/lviqfPELjwI05XtlrxnY3AigV9c4YJrFfccVyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjrAn5VLPkT2+p7vbcDBYRL77YeE9wnvFdg3nj8EpRU=;
 b=Gl5GgjUx4LMkjMiq8zXENwEeOrwiNlapPbT9Y96lqiRjG5wF1q+64I9LIc7lBrypNwHpOQFMBF1PT+mItfQ9lUONVEOZdmWaMvTNsGy/vAXVJnK8KKKL8RWZKyD9Btkb8IufeMa2zdqVty7yXSpJgUWekAyHsbUXuKAk6+zieMI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 01/35] scsi: Add helper to prep sense during error handling
Date:   Sat, 22 Oct 2022 22:03:29 -0500
Message-Id: <20221023030403.33845-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:610:cc::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 42d724b8-c5cb-4b98-a598-08dab4a340a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSkGRZHJxg13DVvGBtp0XTfFctqyS3Qnn2QXKebXmGP8cg4FgTIOjyPvXL1238xtUAaTBIdRERCJ113JoR2k9rXK47stU0LGVSg/wO2Gn4O2P6OSmDWKAP+Vd2a9Djvy81TzxatGfHwVifWjeJMWIngbnkSElVWYlAG/u8aJ9zz41sn4MZ+wbodY5NM4GuGI2HYA2dAHefiBHK1IIoG6gtvsyinxxbI1UfxGJ8kRrNLj0+pqxHbZFQfg0JkxxHtUkdOIhxwd8vr4LywsreYDjB6CO7IQOvubf9TKnu1kGkZPK3IHas3uFAv61zxUe2mMabuuINQjurqWAQzVI4PCkpHm/YriUMCDrDR6hh4CCub0d7LWfvnZJZ8g3EfLeJ23828qot8nKtelEF79ZWCfzs0/nwF+v435Ez/PKeOKDdMme4PIZ+vbJoTLzZHnCAFf3PPbHWGcIlPlUIByz1kRaY11j89YJCy6GI/MwH1eWCzwlB2cG8u7ClEIZNQUqhbAtGFWX25i0cHS8cArnQziAl4roanN7fjL/kbrrqfKrV7wOf0/HrLjaqONLnZHDxSXY8AIw6X/QdaYBFGTn7YpqSvD+22HJhEDrfhmt1orA7w1QRLnK4wEQkQirmT+lHjMoBZpw3CM3azXnQyNHx3hkuIyWzjxy0YcPg9QM3YRuJgD2LGal5KPuhwNd8M2Hycz8qo1iups69ZjOWfc9NDLjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KwAX4V87ALmjcoHK7a7RdnFgAEhA1MAV0XB/AJqLpd9DaTTfwCEOdxM7qN1X?=
 =?us-ascii?Q?mCXbAv3/aT30M7CcF2s6jX9C3JGKTUh4G0JxoC0YcPmvph/dkFsJxsZ82YMG?=
 =?us-ascii?Q?rqCH91td7i9dNajeShkBKFiJB8LvgYYjCXIGPoZE1NgMoQFX9jI6xH8poU7I?=
 =?us-ascii?Q?rDgedbDDB7ru8TbB+o61MJ0C+5q813/ThJLFB2mWjmiAIrIC4CWP/7cdzpnI?=
 =?us-ascii?Q?WkEFkLk91ZJEJTI0T012YVgI6JNhL80TN7pyhN6z38I++CRZ2bCHH3uE1IyQ?=
 =?us-ascii?Q?JaGM9AFZJD8x2XhveOVzw68vZTARVUoFtMWv36mTSTu5OdNLw6O6orENDr4W?=
 =?us-ascii?Q?msdbjaS3meqSuFxHIusWaHlSxlszNMbQOrXV6q37nV6wapKOfVoNAw0UxaWn?=
 =?us-ascii?Q?1QAAQ12B9t7ssUikAiH8Rs7/9/CxD9aYevI6KOfPfznEGNYihfWKAjGjUs1r?=
 =?us-ascii?Q?ceSI69KkyWvBFiIG8QRh/uZhQusTOAXJwlp80lJoAk4abXwtzkJw276Bre77?=
 =?us-ascii?Q?J4Rbief4szoQCxqsCh1THeZL5D5Kx+uIdTzzU2/ICAdE5zhB7pr8yW5prmw9?=
 =?us-ascii?Q?OomqQt34lCTB8VmstBVlXIMIpNorefks7ZUdOXV/OzHsVXdv5kCGQ8+8mMNv?=
 =?us-ascii?Q?tzdXCLhNkuDOjBp2VRaxhT/jhE2wL1Cdn5KtC0iigbDen7g0dugsdyr8cCsZ?=
 =?us-ascii?Q?MJQdft0ePznqTS4+dikvmUt39rfZAIYeLEzf75ucT5yDoEzTzhYGGFP+O7Fn?=
 =?us-ascii?Q?ksdGHLYMsARZxXGx0BGl4rE5GFw4FWoYklXv9EEGB9nkG3/e/k5Ei9OxryaA?=
 =?us-ascii?Q?G0Rj22xh18oPC1182V8h9Swp//ApckGynMRWyF7HEXM5B44P+2oa1e8zW0LY?=
 =?us-ascii?Q?w5NOk7EIIM+ae9qBKCF7iLOJ1vNXtkUU7Qt40I1zZVmUad4rd0Ce5rRP47Hq?=
 =?us-ascii?Q?mLQV+etT8qLKktTPzQtNfshuQnEx/j/4s5YHMatAs3zv537uZ49afnvvjX7h?=
 =?us-ascii?Q?4EIVAzzRJ2TcVnbSwkHxaS3l7C3H+5xXZFnhwoQaq48v3cNkMQ3IxLj0vsa6?=
 =?us-ascii?Q?pekaYa+DT656pYNOzPIq42d8oYHZ8RCkNMl2/15arieAQYEdmWCgthce0N9W?=
 =?us-ascii?Q?6kiwGcp9pIDCBXTavXPjSbBe2Is1PyNHk4pnCRYXZkCnTjixy1ADLQcFxN+N?=
 =?us-ascii?Q?nZd+Azhjvw83NsfCtgX2C3RKjOO6JhOPTdnvW/uQ/Is5N1KduXZXCGqRGmi0?=
 =?us-ascii?Q?HM3zRb+A8LVCOU8TQICOImy/3xKXk0lgqB3KWP9Rg1Z6zRXGFVSFAGnCmCm0?=
 =?us-ascii?Q?fFhYNAdvYcUvdSpD2DH/VcrcX3Gl68PhQhEcHkL2IBnMjozaoFJ9g95ZzN43?=
 =?us-ascii?Q?c77oAVbzFcvbTa1pXLkNvaYf9IPYlxP5yuc/z84CZg30h/XOOW1p2AXMHrxg?=
 =?us-ascii?Q?NtgQzcsEKRK98+QMZLXiqitQEcWZjFGe1T8e5ak+7FoHlG5JMExAdm6isq4g?=
 =?us-ascii?Q?GdD/FR9mVMm3vNq0nI/c6I3GRvUtX9s4OxVg3Fli3UFxgahFctJjfZZWSdsU?=
 =?us-ascii?Q?XatwtwcLFd5hrjcB50twwlek8k9Cpl1KXNNvIXcaewochKDa7ZqS/tbSOJYT?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d724b8-c5cb-4b98-a598-08dab4a340a0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:08.4379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04meUxyIIoHujBOAaa9B7bgy6frl9yvd8yN3dHgOy44BTBNfSNHVC8GqO5gIBIG95aWl6fr5w/DPSyk5PPU14RtJNrIdS1htVBEjG1PDV+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: gXFLFFlOcZzjxXu-oD4BCnHGwpcpcFzr
X-Proofpoint-ORIG-GUID: gXFLFFlOcZzjxXu-oD4BCnHGwpcpcFzr
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

