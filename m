Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8C8C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiKDXTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiKDXTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:19:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18485BCA3
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:19:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj6go013351;
        Fri, 4 Nov 2022 23:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=OSgc68cUk1Yw6y3QaNr1Rl4K6Bk8oXMWY1YLiBnR6w0=;
 b=3UotaKmgLP/9poKX71+MvasQVqY4SO8Z7EiYWvZ2nBMsTCrJvckhx4NgdmT7euqZiN9+
 GzchKnMzPzgqWEU45Ldd28/vejoA0BywViJM3GSZnc5LW00ac6NtNDIKIkEjLB/Mu/mI
 crBn5AY9SSaeSfJrVU7AZvlkoV8zdZKvS3m5MQv7yECswojDlHJsjSArtO68+WPU/Dp0
 1smiT3NJ+v4LumJsOD6hkb8psWOepDnqJvK9++N9PWKHoHaVP+8HyByF2arYH6+3IVjp
 66WBWDTvNiJphmbj/2endPiSKratXCcE2g4QdK4KJs2RkKmVSpMrmCjEwSM3FSrcBpiU Gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:19:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4LTAMk031986;
        Fri, 4 Nov 2022 23:19:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmqb6r8ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:19:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0/fENTs0VUyzXgkljH6Tzg5h5TJQnPhCzWWb37+5eyAfkATupdp/26ZgKTeXUxFFuCk9gHGafl+aXoqqU2YFNLaZhpYIO6jhtuERkRLyWj1LzI1IRZRW0wQhgcqNI98mpvJ0X1eQKnkpWlXCo0qSdmhxODv+Azrt6bXfMzW4K6KZK71n0BOU+tuzaMzj1jZIXy/uaD9vRjzHSPKbPjM8TGvEqp3MWHkimkpfo8V+K/XdUpE/oJsv5Fb3Rchl9w8L/yScQSSqBjV5lfRPrOCS6LDTGsXFu6PjIoFUL2j5jCABRwOiGBVScDc47QpWVb0OIgDSJxUdoKrdcm9lMoKeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSgc68cUk1Yw6y3QaNr1Rl4K6Bk8oXMWY1YLiBnR6w0=;
 b=QAdB/R3wIz3Mr3Po05I1IX4NR0Q1ptvXQnf3gfEZwiPPKffemcgd+IHsqwuNN66tlUM1qtM0aIctFeit2mRB2+jOmAJXhQvfcCRH/VK8wvoQ4pOgciQV3FQkOrvPJFX/pTAYNLbH8uC3rUQa+6c1CNX10VBRoVinnHCr9upp/SDzJdGl46IJDbETmDaLhkHQgYX05CAdS200fDxQQWiWI8X3wG1ZkmtQDJGeNs2c9w+ypTPn10dsItuSyMeEC8t9HxZ3OCETAoBmnAGB62HgED/N3pz1ebWHpmd8fxLRmg6qpSCcKaw/NdI8GK6v4TeIQ/DXsBw6cqPcpM4nIfPdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSgc68cUk1Yw6y3QaNr1Rl4K6Bk8oXMWY1YLiBnR6w0=;
 b=IARPwjSlV6P8hBpFNreVXH3UJ06S6zZWRSpl0sTuTDLd53ds7tiiYvy4bEUgGhyiMYtTBc8b42787BrAkUiNkxNQKdiySYvUAjfFaX+svisxgidFDAsz1VvsrFRZ7VzGGEN2W7C5ErDtRpSrMH58aBr4riWFGTE9Fnf8/zS/b9E=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4743.namprd10.prod.outlook.com (2603:10b6:510:3e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:19:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:19:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 01/35] scsi: Add helper to prep sense during error handling
Date:   Fri,  4 Nov 2022 18:18:53 -0500
Message-Id: <20221104231927.9613-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:610:e5::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4743:EE_
X-MS-Office365-Filtering-Correlation-Id: c2db89a0-e38d-4e2e-f7b3-08dabebb07af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xoy+dtVrp97FlaoXSjan6AEB1SmYN8BELvdYlLKL3+Euyu9thzoKxgQETsiOuAVqfwe27MBavAjnOavWmTE63q+Az99vNn/Idtqaqkk5R5rd7rxV6q7/74YJ+EqVcTkSu3A75a09QZtEVepPst00pZmkaXRen4k7AEEqfJshfq8c1g4efdbNKiGHbGeCtL7VvqEsSlz75FjwJtof8J+35knkYM/mU1CSjyCmj+OgSus2PPtFKgSpYFBpb/p/DwsY7Oq2Mgn81bg6DuZaBjb8kcOHwaHfAEDqbnLqQhdNc+WmqYywNJdoW6mwwbylHCcwK3t5U3gkV23nOGRNWsyqM5QwXusk6mjFm4ods1q7Ydcw6hATZ7Y6XhImkU7zsx1rrpwqGnr9zYSvKqZHG8EuITq6KN5tKM8qam0ifW6j7dEObH+8Y6H25GW+927v0vYfbZhgcEAz9w20zvqsUhdK/mIGLfSotO21tzFKR5bxVKYwyHA2rFnFsZp2l4zX0nBWJuZKSDTkF4ZfdcdUGe6ZIvP4+/8j77YGVwuETZbT8V512w1k9xw6kmoRCVMoLEAJwIBnS3aX3boJWRh/vH/8llLp6hT/Jgk9CRrpmLJDqZiNed8qFwqL0qonvWnlaOqF0Lt8ilk1GR2USVNSYl4xLE8Bx1Pwkb2vq8YzkKoAL6IXfgT/ZkF4uvqWs9TZUsd4MH8IFeQcCm2R1at0wt1gLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(186003)(5660300002)(2616005)(1076003)(478600001)(6486002)(86362001)(316002)(6666004)(107886003)(38100700002)(36756003)(66476007)(66556008)(26005)(66946007)(8676002)(6512007)(4326008)(8936002)(6506007)(2906002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?InE2U1SeYFYFx/axFtxQrX1aqS0yl2bOSlMFmOFDCU5ie1AQfxeL1leEbthV?=
 =?us-ascii?Q?EE+koGM9QlfsKqM6PP4rsMA16qeeE9j0rS3cmn+guThSvB6cxgQb/V9Gpa7+?=
 =?us-ascii?Q?gASjT3IJ4n1QDTQ8UCUlfeML0C3DQs8gzojxThtQgDSvQHo6kx+B8cs7yV2g?=
 =?us-ascii?Q?PTWbji6xvGZ5OxKqRMs0mfYXbQK11/mIuKjuP55D0eID/3MLEvabF/YMlaHg?=
 =?us-ascii?Q?feECtcU+w7zMZqL1jkPqGG/hWWVIMzRfshD2unrH1WRI6KerWTqsuwcWIDsb?=
 =?us-ascii?Q?6OVSWuA+vwLvF30evHj9aEHm+myeAvEhQLlZb7zrKWXJ8jXaBMr1+h1IqvAP?=
 =?us-ascii?Q?Z7uJVRScX1mUR9qWVuVGwcPxD0Bb7T38V2yGog8S5pDitBVF4wZ75GxA2dBB?=
 =?us-ascii?Q?ol/W8jKy7QOb9HwRiQcas/FYrMCH1wqCIDIOcJzpfLC03Vi3caZhQ8kU9C9q?=
 =?us-ascii?Q?6dSQAesw3gmFXSdpGz5uUo7pUeaVZ95GP1MgPF/0JTEpgiQYOkrX8Wl5kDkl?=
 =?us-ascii?Q?Chmz/N1vv3wy7V/JIzcR0bIYuCrb+dOZxoo7UFXbJznJ6N4RwjZiTE8Wz3cb?=
 =?us-ascii?Q?2t1nS0DKApVstfedmXuSO45Z7ana62/IWIhNFHIvoV809yuh4eKIFtm/8u1/?=
 =?us-ascii?Q?X02PaR9hnAIVKoaHvyyhnVKF1Dg4WSbbF6MZ/9NHqBzGzropyPwY/7RKQatR?=
 =?us-ascii?Q?Z1iGKnYC8wLKHxBlxsG0y1eLEr/uBe7Zlsogna59dCO+KqVdqiLOrR05PP8n?=
 =?us-ascii?Q?SG8fctxxoeuxHNltF9rnoQXv2JMm3terp2Up476vXw2CAr7W6GESYUEOoqhA?=
 =?us-ascii?Q?2dFJSBGD0w68VKFEqTbZAqkbnoeu+aGYxFp4xgj8b1QiNJFYp7XPcW3dVU3B?=
 =?us-ascii?Q?MWI5JUQBWD8pbGZWgP2Jnz9SScdFTVH5S7RAOz8qR1f3++1UL+Z8RuYgFmye?=
 =?us-ascii?Q?cWY/vmzZloy/WfQjxpVH+8WScxUrYEegT9Zn6ysFnC62m7W0ARGplxI1/QWF?=
 =?us-ascii?Q?I6ye46hh6ZqCP2Dui/xvFuQfTejk2FPimASjVrOW/j7gjuT1vFLYlLLTYWMh?=
 =?us-ascii?Q?cyRY2ZHpwQSIqKtOBuYy6rfxv/Z4Jtx3IrLBzpzRaxRCK0qqOutxf0BhQc7s?=
 =?us-ascii?Q?q+PXNJQ+I5Eblyt1TcCJZKp3U1prj/nAVsFtXpQSrKt7QjpnOe/eB2JVol+L?=
 =?us-ascii?Q?hgcYB7tFr3MKRDsBG4wLU/9xTUM3HtDuXkMm9v0yH+ucoklKPZ7iqIeU+TSZ?=
 =?us-ascii?Q?/AVqbe3fbIimR2dnw0il004przwu0ankM8mvS4y/3jZOMuVtNq+ITlQ0n/x1?=
 =?us-ascii?Q?2lJLJNFdbgGDQD6kJaCRQL0mU8cr2sv1KHjIdwhytNmnF74LkOQwQbp5c1Gs?=
 =?us-ascii?Q?9MVizwcyOlqUO0Bng0O5hShHZgbkEAzJ7fcID6bvdo0ecK+OCjd2BK5a4Hri?=
 =?us-ascii?Q?lb+Go79snVyr0ei/bR3Dad+yeIAs4pKk68puPoyz5X1CdAI39ia69WX/kzxt?=
 =?us-ascii?Q?UYzyBRFp7kwfnVxA+0ON8BFmAhNfqGkgVccV9B9QTq9eYTrZI5xxl5jfJPwf?=
 =?us-ascii?Q?FuwO7g8QehQf1icw+VF3zQ+imEgAdnIK5EosOck3BTq9LGT7Tsv8A2ss7pxV?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2db89a0-e38d-4e2e-f7b3-08dabebb07af
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:19:32.4730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFtqlxnLetZmf32CEyyC4t435AIvJILMmNseKXdO4yihnmvYIeRbNMq2Xvf5otyK7DGqPyFUnn13/+Pd5gSZY2z5ertn6zOewjp8mR1VjSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: uVF1of1mNaJKtEeY-pgRzcww4xhL6WjN
X-Proofpoint-GUID: uVF1of1mNaJKtEeY-pgRzcww4xhL6WjN
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
index be2a70c5ac6d..994b7472fc56 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -517,6 +517,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
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
@@ -532,14 +549,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
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

