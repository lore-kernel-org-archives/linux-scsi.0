Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36423C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbjAWWMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbjAWWLt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CB738EB6
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:28 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhs40012711;
        Mon, 23 Jan 2023 22:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=sj3MjvcwUHnmrtqNOZobw46UHGxkrTAf4fx8nrxE2zU=;
 b=uBDuXI72nD7fBKZApCGGrIsmY5d2RXsKw6x2NSl9RUIp86jywgESZR9X86MpiEQgfF0p
 gzpZxC+5qSRigGFR9fQsyPTv31cNbXCYLzFh2HXNGBNKWjd1VzNjzTbhUoMprPMytFVH
 m0VQdKNb8kEIrcYlZuJ4oVBb39U+q5dGEd07NU1l8lEzTdqodQoiVx/qK3uIGR3r13L7
 2ubE5CmJVx/UcBNvT7FFY4QBMKIJlvv1uWvoTeOy1+wCyqhb83Q3NFtbzNCqfYa9jGlz
 y3sc/fJ+wmEML9JA9BpMYXFWg1HKdsUcQXlkgZdEQA4OMTGtM/XfaIwvTEUU9toeLZwJ YQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt41c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLN9bm040098;
        Mon, 23 Jan 2023 22:11:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g450xp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbvHnn+HIOJdvaVLSIghQcj8/QOiV9Ro1O/VEk88IwtsCeS84fSKTfW90HTrSuIq43jb05wwSRpp0AIHp2rCLGw2jU3C6T1Md/ejpeYf5CoUu5jTeQ1vG0geJ2BKix/ANpXKcphJZY4Amhr0d6ikq3jX9zm3oDj+Ao/5smwcP0Cp5uopHUDPKNPfxlvLtrMOrMeQvaGmWdXhUw/gGCuamMGvbjwbXTJm1FyvoIqlrZw4OgCwgxeKUc/UCFArYNcN2mptDS6503v2KLqRN61x3wOV3h92Hs5CAiopv2jLrDuPiEw3RdtucMI9Rtq0xiGQPrpgRbU6xyNnrDo4m85ujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj3MjvcwUHnmrtqNOZobw46UHGxkrTAf4fx8nrxE2zU=;
 b=PuhSQV5/l1NtHgLcM5OG4xCfPLTgoT39zYkWcFTjfA/F+P3cYVAJKxnjwmMHgYev5wlIMAT1bQOwzSbZjdOO+xUlj2t9V2lPOBdJfeyldbJClLjcv8C6xXeGVmB1e/3esRd8DNPMl/t7bh4X9I5WMVgDVZpKJXOqeEVwEv2oqQVGeVeyH3OJBSGpGTEgDjeYRDi6Ro+fmARFm4h/YiPObTY9E11ikJkergp+nfmu/pJFVxIG0/7vvDyyVAUi6yZle9jkYOgd5VzKdx+irsGE2+/jTEEfo2XdbATihHPK0xfkp0B5vVpYGBnuW5wqEzSLZMnlmBYUql7TgxyYUft/Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj3MjvcwUHnmrtqNOZobw46UHGxkrTAf4fx8nrxE2zU=;
 b=j9XAPKH/EOB2E1dCRMFfkO279tLeFern+y+qW8ElyTOgbwQd8PPm79qhkctHxKM3T1O9aI8IOxEbmTYQcuvqYrO2YsVKx20lskU+z1O+iyD6sGDfTQLlDo5aMApm7gBnnVwWF7/ZE+9ux66yNY0xEtG9pziVwl+O01NCOadaggk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:11:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 07/22] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date:   Mon, 23 Jan 2023 16:10:31 -0600
Message-Id: <20230123221046.125483-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:8:54::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d695c7-36e6-4175-d1cf-08dafd8eb60b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqKXwUYJlB/J92T1k1gwd8y8IsoQ2lIrQ8RENQKt3eIxBYr/bTT+kKxeObF4aQlWGnxQR9zKBZTuEMUMsr8oA43SpJ7AqQhFEF9qavwXmBF+5kPtO3Gwo34ebyTwYSTYjy5cbSEkFL1RUt4BT29JjmPby6g6zPeCoV3B8VIlZQa8lqZrmOa57OjSGR1Z8CWvCdZF+f4sjyIrfRTnFwACcReGe39kY2ftW9FBLAGZpsrzvcuhVBNxhR5P8WI2vLwcqFyZTabAuHbDscG4RzNCFDDn09rjNzqVHNYHMcn3kehjJV+RpBaCH2y6KfZIH5KDrvDzSEzLBgF0B35mMpQ5y/wboGa2SQ+tkfuHsODVSykxWxuV1UzVDQb+U7pDBHdiNnaT6Fg6DaT8TRo+023cLsLxMC5TbkSEq2riLwJjsXsWnng6kZQpT6jCULqdDmKfHZwki/+gF8tlghAmFJnDoa+v9KY4IOQJLewEv1B2MQ1/2f1swLqwRnvItBsbRZaZJan8a1/BU8pXXz4nZr94XrWZ+WmOCRXmxGRcbPmRl/8sp0jn3RU5uGj4o6SiQS1LP/AXYOD+Oszr1UDS3wwnovG7XpF3lHNrb2mNGymSSW+TT6dTo1UiZCMVmA6i5J+gftAoSC5aUEzIaKymJKWWEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFHriUCZkmKWYeBeiV4HWG8a33Tk3f3brbnwG+HHnQ/QVaBRfXmedh2fgwOk?=
 =?us-ascii?Q?L8dNwvqpdVDtdxg2AyZxqSOETiDe4pKxza8ooDcQG3HkGKwlwqRaNHxg1URT?=
 =?us-ascii?Q?0KnvMcWWPOW2vAcN7pP3i8nBRTsGNHTm82f8/M8ZsgnyicmEbmaNraAIPpxW?=
 =?us-ascii?Q?iU4hjcUiLeb1COjFfPhiRbNxKHgJI16wCJPbVBuaf4pAOXGBxbd3vnuKVtVe?=
 =?us-ascii?Q?SKO5udd7A8vzzaXCWivlLQBFWOqhd+p95Of6EKrs7rIhlsXEAimOXGAgQcMj?=
 =?us-ascii?Q?eEI3Y0LqDzbQRI08hPlgUcGrawVUgu4uM3etat4ql3C08p6qsLNTmWlHzebf?=
 =?us-ascii?Q?Bgv1Jqi0uWa3NUvikWHCTaQPbBA5ZiOM/xHY0S+gQetuTH6dkCMvy6J5R+pp?=
 =?us-ascii?Q?lodGdIsrwubu7vzI35vHsdR4CGri3Vi69gqj/IxViiC02DIdmlTxa0c6H4Z6?=
 =?us-ascii?Q?nKk//it1uGUSWAmV5Qmesq1ZTmpwD2cFFoY2q7ULzDbL9tGR5xB+9xT64/VK?=
 =?us-ascii?Q?lgT+Ind3VcjdN+YCZoYv6WfsgWlluxqGaK3YnID2ansAWr8DPzxBovNP5lv0?=
 =?us-ascii?Q?B+GIN5xO1wNWs9usfmlZNqhZqpE1kArwWW2edrOetudG20jCa3/eXQJB32MU?=
 =?us-ascii?Q?GbdppVM2qlZYCk3NeUqBcBMBZPNWyPtqlKpF12uNTRrewFC43B0ZqT5cOcAT?=
 =?us-ascii?Q?sLd4qj7H6CpzbamTIxbGu/CrBemq9e05yc7MflurZFqUp0oOEC4SuK3hyzr3?=
 =?us-ascii?Q?y/FNrAT/m9okHn6/FvIkeCgOd6KZrcKv7/CHZR6NCtBh/sm5GfNkQZVhIEzO?=
 =?us-ascii?Q?WoWL3HxXEMGEyDfdVw75qOmM9J5+r8OT0BDYqJsgLRpPElItaFuJJEXzPJEH?=
 =?us-ascii?Q?h+XLnpyYdLx/EMuN1gexqZrVhal3ubAsnRW1wslF5IWcL2cXo7582lNLPCXH?=
 =?us-ascii?Q?reU6BOmRdRgvqRWK5oAjVlUKYJNpICmF4LVKBgS+h8r6H9BcLYCv+qeU6KWB?=
 =?us-ascii?Q?EBpuuW2O7G1EMy7iB97iVJF+mrRfruk6ndDU5745up7P/Di6UnsCOkV0rHbN?=
 =?us-ascii?Q?PqDbeoseXalshG/ZXD1OpLhQhCxZUVU0t0hMSVihMwiqZCCRILYniOmkEVmN?=
 =?us-ascii?Q?qXSPVLunbvmmcTw91qdcqNucuhO9Mue3tKx9MnD8AuiXeiXPRwklVrQ8g7rc?=
 =?us-ascii?Q?EbfSlpCWbUPvh7P87ryC2lAx5GNf+wTrA9BeI9DTmWddrH2O8AUIKUvLSkSn?=
 =?us-ascii?Q?2gZPqteDM4kfT8DiMxRaWA8Yb+DVhWC/9kTQbGQAinW62oqVKttNXPYc1JP7?=
 =?us-ascii?Q?xm2NR1uLL6VjRt+zGoY7CZSpVkeVjdzxpzI9Ul7a1pYqdIXeH7CJ6/Rx8lgs?=
 =?us-ascii?Q?jU7J+McofluuXmi5dpW+QbTcybB5faYuGCpnHnaAu2zByKUbvEN0sOWJoRM5?=
 =?us-ascii?Q?uj7AnKB+krPC8hAAPlMiCATLIAsL4Wmpsv6U1VOnobsl2u/kHFk5hqLJeH1a?=
 =?us-ascii?Q?2XZoMAR/wZejkmPauFX6TCySGhXyDvmW7BgOtrp/T/oKD6aprkd7fkq8yDeE?=
 =?us-ascii?Q?D8w+HwPepW1ykszKffCJ8y52zDibZByiG77cnIHK2kfbKS+WV8f8OYZJ2MsZ?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ioRDzjiQuzUqQsynlPNoWe+N/VneZJfwjqGUgB8wtMAPcLu4xTq9SnXXr85cLQBmO0D4focpV8cHtugcrtl0M5/7lRRAJBdKupJ/NNBNbi6gb6mlgzCt0GnuNyDsojcUtVRs/1YyCsbnTyjOVz3rZkqiJivYowUxkdqeU8Aes1rJwWYpV0k0sswnIYPatpCzzelNto4Y8vHXUqFzS+6XkSttY4N50SwF3ZJ29q4aVTj3QhyXLz18CO/XoFWjcl+thSy/i67c/mlFYHvz3ve7AbIjxCIq8TcwmqUNajYGjOAGNORQxW5FuonvJ7VmJtmBFLXrjXA3h/2QGe5GHpv9SNxyFy1ac1ZEq1QakgYKRA9NGFo+V7XtvmfrfMcb2nkvj7N+yJHQm3Eewv2Fcpvzx1yboD96H7aaiJWp5ShYFSg3gt8x3P1lm493pYNNyEdPvZ1s/noHUcCn8wmm6RUMmxS9TAbTDIurniFEf4lQ7knrYF2lK4YglAliugJvo71wOVTDpjtQVW2YOsRrSHi+XiHizOWzOjLClb06l7dx0B/4orECKb0x13qKTiTSo1hYsa+WsuwbEcGWmlQla3QqZBk+K7OxzrfhrSSYpWgtOCh8Rgwt6UKwwNLmbq4uxJXLY9PNPau9mgbF4XHIJobLkTnQOT8QMSySijhrvS2PYea/nMeY+gVKU7x3+WwX9jD+3/MmYciZuP5ash8MTQz2KqC9LIQr/Gg3AzmcrP7fCJCmFrg3MlHf7N1IN5kp6MCH5OzdAu+ndkheiZ6e88S0ojhvhhi6+Z7eGj1S3VkU4gVA74pNdZiIU4H2TvD6NgC9VCbYaff9MYZy3ruWBSu31dwLvf2DnP9oyOLe6sRIMlJ8UqLQPn0TlanY+S3fP+CT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d695c7-36e6-4175-d1cf-08dafd8eb60b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:00.9163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ltjztj9ntFVNBY1evwtSfhCG1rzMOyFMpkb9mpTRbcciXa+EdOI8QnQ64tpSE7qCXR0BAtYY8CIOd3ZD1fPgrDOTwb4nH3DSqX8qkCcNO1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: 0iFMRmfUYlMPNEoV6wOgx5uMgVf05gT-
X-Proofpoint-GUID: 0iFMRmfUYlMPNEoV6wOgx5uMgVf05gT-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently re-use the cmd buffer for the TUR and START_STOP commands
which requires us to reset the buffer when retrying. This has us use
separate buffers for the 2 commands so we can make them const and I think
it makes it easier to handle for retries but does not add too much extra
to the stack use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 99fb4d72e0f7..ec7045a828dd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2170,14 +2170,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_cmd(sdkp->device, cmd,
+				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 &exec_args);
-- 
2.25.1

