Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C109C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJPUCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiJPUBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111EB2BB20
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:01:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GK1Ifx015345;
        Sun, 16 Oct 2022 20:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=v9Vt/+4lByIQ55PCkLsLJOhzpSiQJJplu+tsS3gcByM=;
 b=QDqQU184T5Xy6eRxRX9z4WaHc5h3DlXzE4ZuGUngQemgh6Q2WyLfU8AXDFJ3I/ToMWy6
 0Am4g4b0bXDi4t44z5C6Yso6b2K53mycwIllVosfHPoNTXA98WolybD9ON1HuRKOeIg9
 U+Mi0jMSjuFejgsGKc66lmvBgy0PM3zWRBrZxVyypJ6Lk4j3AYvoGEcW6iqAB8iUvFT6
 h77a51TzsWH+SXJ2wUseWOzVqa8QQnwA9sE3NLt2mtxb8bIa/4+I5fBAO+WQfROfkc6H
 NBEcgwuDT15m7VAmGMvll6VKGgTcevwNPt1R9+w8fVFOST+PHR1KF/Q3O+K5zJqU/f1A 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mtyt2cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSh034322;
        Sun, 16 Oct 2022 20:01:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFVQukB/A0ntYVy3mZowkSvKoJe9Tsy4NKuIpSTAa2ZQw/Ut6uywNNXF4k3dE5D2JpOyA3ipzP+FqEvk0pO+BR+D8G8Hv673a2gBwBUjIOrXqLTJ+kWpqOEs9il31yhbXrhoRojuXgREA1CVEnK0Nlyyd2QTh52qx3TLn2rBoRweHqH/NC43SB5pkehXiQCHLAjevExptovEa+WlbXoYwdlAcVOZdunQkkG1vBWf1BEhgbzMZ7fmZJItaGl9T9ad3dR11F8iT8h5WSm9REln6CWWTzUZYz9nR7rUV7vMwANG2mDISVXdqs6XckAC0D2f+kZH4itJpruDLoSTgMOWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9Vt/+4lByIQ55PCkLsLJOhzpSiQJJplu+tsS3gcByM=;
 b=DCwSx2yWvxqBURCZMIdSWtXhJwjq8TGOdsdBZF2bNaXj3cm1JBlb7sFc5sYkmf8EEvrZ7Z+hivOloRr9QuNQwM9fsgYNBaFH75aLuYDU3BWjYK+AaO071pOkIFJo/kh3sBq0PUnuzNVXe+a7W1FhEjVJuGFgYVYxRon/WMtPTrfYIxwavsFK3qzGvKZd624dWj56/+UT2od67E6flxK1IMKvQcvlhYtuYXZxzhV7Fo0VBPfObRHMlDwkEFwUr4dGOSTHu+YPwAQBJdGnWxO9ngVgx6Yl+fLrIxZe6oy/HJY/z44Yq6i0Eg4uZhztiASK02P4w1pr7nBWHRB3r4r+HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9Vt/+4lByIQ55PCkLsLJOhzpSiQJJplu+tsS3gcByM=;
 b=Cz34PgbnhQVsKuJwzQThdnXRo17NwSfwjzfRU2pX6kQn70u/TUFfLx1XGaQiCOx9JgOwm9ESBoA8vNAw29Qx9UGr3ivuzJey+3xSxi7MrQsph7QgQbd+hOum0/1m3cqyzTCCwHiqAqn32yyzpAUQm+Vef2MubhtO47HdS9cOwQU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:01:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:01:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 30/36] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Sun, 16 Oct 2022 14:59:40 -0500
Message-Id: <20221016195946.7613-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:610:38::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: 828042a3-0e95-46af-6e24-08daafb11c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDiKuHQP1U1hc0ibzX0r14NDZoYVfJJUX1yQo+m3MX6PklvpB6UBqxMmkbQLRL4DoMeBorXaafNrvOpU7pme/n4G1QV302NC5K8K+I8E9SarNMvZLQB2XFhP4NqnGg9KSUhSXAMyyeLjvJGdOYmO5sR92PsMhzksYOpmoYKT4Ilm1XmYMznQ9WjYe8ARB+4rkdbv9u1uY8qE1Xotfxo4f44S+kfbPSeruwwB69fjdyo0lVaR3K0c78ZTe1iA5LYVsfMJKq/9z2LKxrEUwY4aeyROBqCE8HZvArnva4Q/+vNrxZWQWRGBIqA134IwrkdMvrqZMDAV5OudwO6osZLjx+1SHgNQcvLxfA/Ng/z0XdVKZlaWWiYBSKZdve5u4ZBqVhMU1HFOOLCQOtQopxhYCyO3b3Jnz/7KRCpHohPLnbnhK5qf0co8XZ7AL2Q9wrIjyjJunxX6jtVvgVHCZiwGUjam/rq6aiTrzJ6cnQgcG5dJ/GhTaoTFEV2pWNlVjmuWnKr1zZu9SQkDSTm8IGH15ut7YaHI+B+w+u7Dia744npiQfKa+X3OcnTuXF3YcWdBLOoBjcE5bvOrMT8cB9r19TKbFbAMS1Ba4eMMlATukmzbt+3INja4FAbYwm/z8PRXx6BpOjhRvWnNvcG1qTE03I8N+z57NMJwaVG//Ms/2r+a+XlLgWoEqNve0NzrjAf7IsZCyWJ2u0xTMjUcPSdxrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b4cHdgrj+n4aXJ63AJu0M5KcqbPWy3yVJ0FzmwmrPW4sIf8aDyzW1iE/q2/7?=
 =?us-ascii?Q?3tTSIO5gDlS5760kbhvOtATOkyreWMuuRzg3pgqajstnGNCxpoz++udCXNeX?=
 =?us-ascii?Q?+Je6t0ueUWEf9+IxGCEAbknOQrtSvhMT9thea+g1D3lrfy3rTth2i1I3JNCC?=
 =?us-ascii?Q?qD5UN9Vn4ITkDKLcNu+ezAMZCohm3DQUaKSUC1//DT53ZDKGEDaaXYoZHWFC?=
 =?us-ascii?Q?431uQiZ4jKkSF6i6iwujp/zb6CoJIGeCdOURmL+L7g6D6xBtvbbrrbegd0Pk?=
 =?us-ascii?Q?1tqft+F7NAp8lrYH8JZl8mT0Klim7fqxgZA82YO8zDmL+hVGwAGr/7Fkgkar?=
 =?us-ascii?Q?3Mp8Cv9QlkmOTtxA47WBhOJJ0M7uJbIZ0he6SQmAvLSp1o2Xp66qeMcabs+6?=
 =?us-ascii?Q?BrWXnIUU8iezrmCBvS5R91hf2jWbQJ39bYHmqE7oMGDUeuPHN8JLBxfVkRoq?=
 =?us-ascii?Q?TB8JRIrANVbtTG1nmlg9bcLpnf4OAbdBPXtHeNG1D1tqFqA9WnHe9Asm3Zxy?=
 =?us-ascii?Q?rE6SDXhDn90C4LwVSCewLAjPEjRdvepUaGoJ9rsWEDuFv9xpop0vREACpwDb?=
 =?us-ascii?Q?J8cfGkDqn4QdDR0UnyYjdsSZtg1qMp2vRIl/YsZsdVry7HEBPrzxo3gPwtgM?=
 =?us-ascii?Q?RWdEE0zNeHhA4LnxZp+fKcsKJQWQJjYxNi5PaVi8iEYVvu7frA2erF/rUQFL?=
 =?us-ascii?Q?fx+Efgpfw2BMtk9q5MH6cjW+25OErl59gVMJAmUxsfLppCYSqOIrZ9bj7Bk5?=
 =?us-ascii?Q?86rakVg1hFMXmJpILo3D++4J8y9LvV0tWf/BmAUzO8+6TqGq2VwSACJGKDYS?=
 =?us-ascii?Q?yg0YB3q2q4ZaGYR7PoCdeIO+5vej75/8xx4DhfZRzpEkSar5ygm8pJi66VNW?=
 =?us-ascii?Q?nzAPXLuyjVfOfPipz6z9DFqoEB5xkrsSqdrG7zU4UZibHfvjZ0LaM/k/LWlW?=
 =?us-ascii?Q?EG312qDVgGjFRKAJ3c2reIYLm7WwThzl92o3PXpo9yGncH1M9pL08sA0fQ9a?=
 =?us-ascii?Q?nsU50GbOEgG+6/7tLr0fCDwLVt0GlfTjLLJpkHSTTE0YDJHsI54TVBKfj9pX?=
 =?us-ascii?Q?PJj1Uly340hoFOTaJmdUCNkrGJLQFxe7RQXEHXi8/1/Fl0FuknHX0ou4vV7Y?=
 =?us-ascii?Q?emQdMIJ7jVi1BmpLsqJYG44e6aGG4e0cRhu2MSGefpUzIeRab7N7Ldm9anL5?=
 =?us-ascii?Q?/o+M8m9sgmX69ESE9P4eod6gj0Bu8d3bWUpJCHhkUkGL40xZV6154oi/Tl1w?=
 =?us-ascii?Q?j6Y6kPCmqx8ZTqQ4ezCSu6//S4yDt2+CTomjvmd1AxQvQkA6kTqTSxa8kpOe?=
 =?us-ascii?Q?OppjCeK/DYSTsluEb4tohRhhcX8Or++EKbDLz4Ou1M8zYOGqqOi0q+XPppLz?=
 =?us-ascii?Q?bc9RoI3wijrFOLV84iLtT2fr2CJIH30jIUIFsGvlUkLDPiCXP4VMZOrHn8KI?=
 =?us-ascii?Q?9FFSFu6MoIhzbonuWWFima1EhQKuSnvooj+GQUWSS+/INh3WnqVgI1pqBlOf?=
 =?us-ascii?Q?KnPYHZknpXpV4aoJkWBqFgzKXLnVzO6K3rUZvLu5nG7ZafNghx2XesjwGlOL?=
 =?us-ascii?Q?mldG0zGIh4GtfhGt3Qt4a//RdK/th/ZV1PmAUelAHckuFPXZp1zwmQSdOUP4?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828042a3-0e95-46af-6e24-08daafb11c74
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:44.8904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhkd6gn9G/Lswfdt8dbnhZkqkM4Vtyu0dC9xIxi2cb758PHxnDDODYZpRLwl0ikxBu+OQ7yO6r2M1unr5I40hYacw7Bjt3nHhpvAXk+1YEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: _laxGahyO1eC_YVjWxfZ-9LHVhwmeHoU
X-Proofpoint-GUID: _laxGahyO1eC_YVjWxfZ-9LHVhwmeHoU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c | 57 ++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 28d53efc192b..564ab7507f2e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1425,13 +1425,21 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	int ret = 0;
+	int ret = 0, i;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1500,34 +1508,25 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
+	for (i = 0; i < ARRAY_SIZE(failures); i++)
+		failures[i].retries = 0;
 
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = scsi_cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = lun_data,
-						.buf_len = length,
-						.sshdr = &sshdr,
-						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
-						.retries = 3 }));
-
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = lun_data,
+					.buf_len = length,
+					.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+					.retries = 3,
+					.failures = failures }));
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.25.1

