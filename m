Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41D2C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKDXZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKDXYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CEC1E3EF
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhqUl032442;
        Fri, 4 Nov 2022 23:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Gf9et9b6cHY7wWR5tmwS3a7POkq1T9L/TDCC6kpGd90=;
 b=iQl+yF9xbDeaqK2VyiP2jYfdSXoMO29unBDZ63VmwgPJzbbxuay5AAmr2aPq8ygCqyc7
 FlxSsA03rGvVnS69GL5qieOgalaaZwetuC/mXUUFYdaigyYRtMvc4vzq//7b1+kxXIqo
 FlW5Ip1ahOy0AeRuAblpV4FdWnlXT2C6LgdTUB5kDYJ7z9Meftxcklqe7fVNe4RynGmb
 lWAkU8DNA87yFNtO1A5o09EjihYpJgyFFsEsmj/6ou/5gzqF8GhKrMHp19Qt4d2PvXHe
 K/XlHVOUSsOc+q5LkbxPP0ez1kOZCPq/vp8cwgy2ysuv+xjd9w/uTpjiQ5rhmwpg0jkk IA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty398bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Jhv0D023054;
        Fri, 4 Nov 2022 23:22:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwp0a0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IheXsAG8yA5tnPXq4Gyh2MyDr9zS1sjggtBmYz0ovSVDHksv2VTnkEn5xZmGqffxKisYOzwwTHHI0KNif5b6aVq49v5qspFm1S2WhttSAfU1pnHrj5Clu/4Bqv99DmUSIDunHspXpt/qpaajcDOFECXfKx8zBI21saKhbmnNbpG3kNKrpvqeuRvW37n4mwfm1zA2oB9+Be3eG7EmaL0V+EJIzirkwA3nTNH2JUJ1JYLSbAqiCqoRiy2ksprOlGCrYXSTrHNViEo96R5wID1M0Umi0YQQyMRYBes63Ir/evqP7erN8cpVb0nCSiltfxxHSwUF4cc3hcKxMVS9TfJ7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gf9et9b6cHY7wWR5tmwS3a7POkq1T9L/TDCC6kpGd90=;
 b=ktqL9mcM2VNmiOCixMaAKecerq8mCXQYzIRBMaeXbMIcpWTvMo4cQuAyQ0vyayfHWqy6cqafBWlnPWCWEbBM3uAzQGiHMcKfRA8ItU3Y/irwIXfCoaq7ySx6Mg0r4gK4sfw2x1WtaUfeCDX0TPUbqssZquDtQOUh1LSyMkmaKgGC6hBJbUTa9VUL1ZV4zRBjVneUlgpeDLSmlhESwaN60paIp1Rrhzq74wR6H93URUEcJ17nFF0yDsVomcUuOY7WTepbp3RkeEaDrpdrLQa2oZeCcENOl7e6PlDyi5B7D91pLC+RktDDn43W4jr5WOPqNJUzky56lhtZUI5dtue1BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gf9et9b6cHY7wWR5tmwS3a7POkq1T9L/TDCC6kpGd90=;
 b=V8AJX97fuj8F6lY/t06DKE51AX05QBuRLsIPeIJs4MpTi1x9qEx+vwe8yf2cs+gr95WDNMQP4+z4whATKYUGVXequlSciN8wrUcfFWVFaeAJPCKK73/PsfX9mWfTU3XFwpYRalWWrHzt3HMJUVukkweofYgcQeK4ppuJ9SzgM5Y=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 26/35] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Fri,  4 Nov 2022 18:19:18 -0500
Message-Id: <20221104231927.9613-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: faf3f506-9879-4eaa-d749-08dabebb6694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlg/Vq+pyBmR8J2VLduu2/kw4ZRusKxwFeUbq4jF+yAI8VJGwVrqU/SjZAtZwu33sOyr0l9yfIFU2oOhWlTxOMOtudR12AZaH9iV7ZC2Z7MsjgDtQ+QWyaskeFg4/gLOV2J2cf06k1oijvaaWqlRKBOCIxr5yyk0HPjfAZVICwQkHuaWRVAYZnBMM7xzENbtndFSsb6DbD4mBD1XgZZX5MJ0YBYj98SmcClbiloM1XUZcXLao9Xrua9yYOebimIO5I/YyvqD2elsj1MYdomkbw2U5VoX87qWxrSpSfE0hdLbDXnuke9qg+es7COpA1uX+4dBAeAnNiF0wti+zzDzvew+vO23v5tLw8T1QI5gqxcR2PIDV3Aedy68iY3laBZLgusMCextUYu6oeTDhtUR9Y9+QlPoKZ2tDlHGVXoqMf7/l1aHpmUviER3XJLUPi72kQWFVhaQwDHiNxxw8bFNTzHwL89uaonOjBnRBTD/1r3YPfsJbucvbAfttcfZpE7jSgIGfcbI6Pu5WDN+UdapbpTMBeI/M3dUuu/FczhmNeConJ24m4yL3/MikEvjiZ4lLvUqzrIyUEniqb/Xf2RodkH8d9zoIGvDUcbQ3SCeZ5ByMocC9DZMqaDiT3OMVYJPhNTjWPXqjj5A1wLzZALObjVdYG9bb9wgLnB6Z9UJ9TRXoz6lftEedzuTrG443FCy6aLwkYcF/6CjjUPbf0fL/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DQWTSfHeBoHXrb/Cu/LrLNbk7PiMsekm9ARt9Kin1Nja2G1EoLDO/ZMKKDjE?=
 =?us-ascii?Q?N6bqWBDhucj9hbXyhnarQkEMvmkC9AVS/KqrykHNhf+DME3gWUc7cCRra33W?=
 =?us-ascii?Q?Jbat89iLxtzNEczhELzlObz1cOCB5wByNthC3I87ci9U2nV0N1a8p9XAz8IB?=
 =?us-ascii?Q?sG7oSLy2VLM97pz4tAnUaZzEJ5aLMLg+f8BRGI6W4RgLgGPEbUaT2fnJ/nxv?=
 =?us-ascii?Q?9CKbJJ3TEgSFu7jX6ig01arpXerVU4ykgnDljIDLwESKDsTM0b0PzOyI4rQE?=
 =?us-ascii?Q?FGdIZrULbl/4mSdbfYFPtIg02OZ1EJkCEVPxL2yUTm+MGJB2DFAmoO54x2Sh?=
 =?us-ascii?Q?Kcos3tcoM8o92FgofX86QvP53y5BhK66FFP84PKekxpMk4l/gf0p50sEIOFD?=
 =?us-ascii?Q?IwlD7Sc//CUUfV4WgbNA2PDfrocaAR+D7245RzAxwtV8Pc8fPD+zla97DsTB?=
 =?us-ascii?Q?P2uNCB6zoecVkfPIzxVdmK+GwfjORX6W32q65W/Wnaxoq+BGteGNBNC69ufb?=
 =?us-ascii?Q?QAufkjw1llmaZY1C+P9/2rEWxKDEqn5rxOTCBagE3hdLtWXSoVq+P40+x3xQ?=
 =?us-ascii?Q?uI7ZtvnAh9oWOmZfO3bgZkw8SglQ7YKzjj6GcIpPB1PlRng4LiY/UFH2ZYJv?=
 =?us-ascii?Q?XptfcoXgXwnLfyTH/eJeVO7b7MdN/CYX5DO6aW4Zk8KwB0iwpIrluKkJX5O2?=
 =?us-ascii?Q?hZ8cSVQVT1uREHmgRLwvlZGlEeSuwr550Yz0f9hEWth2Ti+c1FO5QVg6B04j?=
 =?us-ascii?Q?UEa/U0WLVgPcQISq1TyBwdWGVMbqcXoY+Pmh2QOnE6YPe6Rh4bKKkT8sRUwf?=
 =?us-ascii?Q?X7cK6s8uJWQyxbNOpqtIE+35NSsdmwDzrO+d+6/8Cx9PAbAmBOIHFzFBxt7x?=
 =?us-ascii?Q?aJOf8dy2YReScL619T6+vlOfTJi1+X/45mnzA8u8uhmkjjAh+QWhQxRe1e25?=
 =?us-ascii?Q?PrryzJL9QUE+XaQs5Op1SwCKJURGsg2H1FNfzrBNMJdld8wdQ+6E2IZgmRYZ?=
 =?us-ascii?Q?Wglaw10NryRhI2Zc8CiLlb3WIH+MeJicgtG1aiXV5Cy/e9M9P9hXMhtUkrYk?=
 =?us-ascii?Q?CVbjSHsi/xbOxeRId77uTrBcxr6GWEBznTHgikRuPtm3Y82H/YdT7fty6U6d?=
 =?us-ascii?Q?OVwfSBQxLTxlQWeQDS4Kd6oJ2YhDFnY9liy/UcZayDjwG4OSPZb0uxGAjnYt?=
 =?us-ascii?Q?S0AQC6R3mozzzl32W5J5RmHDohkIXvSWxlLxOALtqM7FQSFqiScDwEs/oOsx?=
 =?us-ascii?Q?UOeMAi0swys5YHbUCj2/OBqPGcu0fGMBscKJUvgkaDc+7cvK/UVAKlDACQg4?=
 =?us-ascii?Q?4L5/hMUJZCcxM/ziSv1UjrKUAy+NpD21ZaqF/yRmSM3M596KzV6V+YN1rHSM?=
 =?us-ascii?Q?adCCS8TZ7ImHf28kis3Bmy+tlefKZJbwhXvCwErspGrQ3Ptzcc01jAqy2cSZ?=
 =?us-ascii?Q?BXk2MSv+BB8n0giKKh2Xx5CP06bjeELGJdWVS73U5PVCVy8uhQL6TzHTp034?=
 =?us-ascii?Q?LUDGTN+9SvZJT8a7s+GgPd+KvM1ZvyEzQpJb3yOSitSVXqlmMnZ1+xQDTePZ?=
 =?us-ascii?Q?pnTog/In+/mmRvssrMnnpLLlOvH6rUkRaxg5PggWvHkFOi3a5/cp6QGW6x2I?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf3f506-9879-4eaa-d749-08dabebb6694
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:11.6788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /klATP9/VjymsQVx2Mr5ssPZj90RL4/Kvq63bneGIgbP0/FzUOZFhpfgnUcjYeSZi8T8hARcPGF1ovjxfZwNJST7NR3I2o5z4cg+T+ChPJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: 51YStH_M5GNI6uN6DH6E--iMyP6mwWYF
X-Proofpoint-GUID: 51YStH_M5GNI6uN6DH6E--iMyP6mwWYF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 66f1bc03e219..a07f569b5812 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1580,11 +1580,19 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
-	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{},
+	};
+	static const u8 cmd[10] = { SYNCHRONIZE_CACHE };
+	int res;
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
@@ -1593,26 +1601,18 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (!sshdr)
 		sshdr = &my_sshdr;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdp,
-					.cmd = cmd,
-					.data_dir = DMA_NONE,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = sdkp->max_retries,
-					.req_flags = RQF_PM }));
-		if (res == 0)
-			break;
-	}
-
+	/*
+	 * Leave the rest of the command zero to indicate flush everything.
+	 */
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdp,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = sshdr,
+				.timeout = timeout,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM,
+				.failures = failures }));
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.25.1

