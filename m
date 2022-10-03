Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E0CC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJCR4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJCRy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA16439BB2
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODGZ015434;
        Mon, 3 Oct 2022 17:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+erRwpOLMPQQv7YO8DMH1pPa3L7TonE7JxMmFSfj3eY=;
 b=kFQuLSDtJLQxBBd6BlHd4fqaQqojxuTcggYMl1W0reRmS1mF3C3Qler+ZKAWOsq9VxOa
 uloD36gh58lkHfWLnH+o0r2fLyZFDx0jGx6w+sSqyQ4rGmNDa01mnowZC72/428vDFSj
 md3jBDWF6ngg0ekIsdCIA5S/Evksv2iiJ10xhwK2hc/6IFUVwUJL7WrHBn1wy+zAsfCb
 FDUggN238GVt7tPa9KYenV8ArJeIyENutvYlLViVtLhCobOo2MUCjfh+htD2e65XnILk
 eby4y9l2EPxqIl0/zwQtGYCO8jbF887NSY22ZzoD73vxuxYaEwVeAY0jdbvsBukW4lyb 1A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FV7Yd008246;
        Mon, 3 Oct 2022 17:54:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03q64k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vc3iCvGAegfgG6mj3uZ3x4drkes2fby/iQRYKHjxTB9UHe08AqleBZRzES4FC86VDlJ9K7wOGh+JUnXMLpAYfxzxuNbhcvYCosku5IF54efFVkMPpcCmHVRN2cmo1oOK6AfZHQttBl4luTJL0uhfRtw/zk2IMBCOGvihhR5V92mLGM3lthg1suWvyrxOhNwiRtgAyzgJcoCz6hIN751PC3mC1if+XxhCIr4PLWPFBBoTpiVLdo9otTd3O/Jn3CeZtFjbIBZyywQ5o4ZeMoFavJkjSYg6IHzBcl+VTC7qwzUlEXeSHbh1wGWnNGrWsu8c81Xaf493SPPgrpE3LqNS9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+erRwpOLMPQQv7YO8DMH1pPa3L7TonE7JxMmFSfj3eY=;
 b=MgZhI0e8bw2n75AgWVRw4pGxRKaoEW2CaXPoEMg5BcY6DXPKM8hD+Y5e1hKYev3GW6XHbRgGZOkPZQU31+YwQKqDJN+kMcGrXia4qYGSrqZ9jgjshnn/7QYGWIhDYrTmFL8Z89HMF+wVr+V/LqT2OPxZQFgz6dkpSSs/zlTZ4yHvmtqBTewS57KrDPI6j++ZqKC+Do/kfRDS4ApYU/LPlBzflxydrKeB3qTzYuPgdzMwoBIyejMNelTkwoKERxU3QeDt0x5n973nIfVD0joGE4DtiNVfDocOjWw3DBYkKgNbMYeYW1TDa1/8SnxoSMmakuI/m5XeQsRQI8UYfJTkdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+erRwpOLMPQQv7YO8DMH1pPa3L7TonE7JxMmFSfj3eY=;
 b=NYST91/U3A/N0uen7VO36w8kkQZPREKAZ7EnYcGc3VWoULdKsZbbyi9wd1BzD7ZJdd9iM+Iq32uBbk/T2tmPMZi0qXHsRmDC2B9p+e5wq8HROLNV53XzHDnfqsiAqR9mlJ9tq87aNvgD2IuC645dQ/tNwn7wVKoO7yMMfy6cISA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 27/35] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Mon,  3 Oct 2022 12:53:13 -0500
Message-Id: <20221003175321.8040-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:610:59::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 616656fe-13e0-4ab6-fe62-08daa56842bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rrrx9frRW2qLmKzRexDE8ql7ZIuIUsh4S5sF47MPkAhkTBkcAa7YtiHLOCPIyGq4QPj9o4zExfPUly0wtnmFSTQzeTSRGHxr0VwIX8vE2hLTISChhPvhcTREDYotGdWVBxLMjAZwODKFM5/c6TtOY9dHRNlzVUrSaipgDqjwi+/jk8Hgw/gTz980Kxe/TzjQRgQUqYYNiFg6lK3TzvUsSjAj0ytbzXAf23Jo7P/aGrj3zi/aeRl8NC0pQpipoda4lNHCSJELI4MV66TfZ4QUWLcvq0/ilFYdX65g8v44zNA4Pzc+Ylt0xWiP+WJrt/o6u6gpBlPrZ24ODU345Bb7BKqHqYYkWzryKE/Ff+JO190U+ry5X/7UuWJ2jST3JhEvu7JyM3r/8J/wnuI2VG3kJ5Ft5EAKj62VM12uTa6dbHUY/1D8TP26I4Zk69ouNJKA0Rj8F25sCJhEg7/AXFf6oJbnnZIfETjWdW6WJTZ/dcgnYgMiIrnUfYci19wwAZMcO/18ZAqYZJoAseVNcdLLKZE5483gPEw0248nNeO6+rrM1evRvsQoSXLflGcyG6GAQrENVbcJGp9g4RMj5oMLiZW2pEuSAw9IiC9uKsPH9Z0qJVjHz/WCf4rdkMekHYZ3Md3UogYpgfoKoW4fGu9j8/A6NkTtd/Ao5pq+Zv+3JKnBZzAb4L+NXErDcrTQHFj3PSRkt8hnsHf4haG0McksA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A/ewWvTWPz70P+R4AH1QuDb4gUCkL+Sa/tw4QOniSO9jF+fDApGK7KN1h9sI?=
 =?us-ascii?Q?2/Cxf0ojo6uRfl4/zZns4QUjtNBprH+w8CEM0LrDK07uVMg6fSzHMMPFyMIn?=
 =?us-ascii?Q?ZHcaLaKaCSfbTKo2l3Lazp/xI4MUXAWuC8bO7ncPwAK6jIoA4q2xMrN8sw0s?=
 =?us-ascii?Q?TvLWa8v0B9AEmbsLpPJ8dYgJ0RXKwmVX6UkJMbFphk29xkckBtR2ZOoUBkGE?=
 =?us-ascii?Q?RZ5D3fpQ37iAHaLqr6FTnKfwulC9iB6zk11FxffvR6zMutEctk/ZoyOacgRr?=
 =?us-ascii?Q?KTFLs7F3CMqjSk4NZENwjjQ/qFzSC0Vok6kQlqx/KO64ArpIh1r4RG0Ufe92?=
 =?us-ascii?Q?7YuMIXqV1BBwdXVEPAn4gSSk71MgUUM35farTuNIlbOip0IvW7mm9ot60RTz?=
 =?us-ascii?Q?I9dsTenZclbDl9MCe+hhAmtS5BNlG7pEVmHMmSb8DC90hivVv2ICrHoOOwsF?=
 =?us-ascii?Q?A5G3Nr1lCZM8zsPbW8qDTqaFqenPShNNXL+E9Oepe1VhIM/mBGQ7cxi583zA?=
 =?us-ascii?Q?WnLwpB79zm2kvhMXWGy4zg7GxZFjExnbDubGC5C8mMK2syjvUD+V9GB3eD+J?=
 =?us-ascii?Q?LkTPuHltnRp65YmbIaxLnK94qai0WrWi9g350H60yopjinUrxDbuDthh5ev7?=
 =?us-ascii?Q?TgvidxMhOjlhbwzdnNiZcIHMOTOIseuoXUKR5+pXoR7TpwAfo2AG41E1pRv7?=
 =?us-ascii?Q?6PJHLTawBdIwItlkl1M1VitC7zuhK/AR0o5YQIYAb3zqzaN0/5bGNm2fYVXi?=
 =?us-ascii?Q?Wb6lLsSHxLiTZxXtbA2IJ7BaBPS7N2jqa5QmcKA3dpsMwR4BwjqYh9xhrJST?=
 =?us-ascii?Q?lVbmOg13o4JV+lgIUECrU4n36jBpyd8rLKiKceGM094ld5gNfW5U/Z2vMCwR?=
 =?us-ascii?Q?moFViBhSSmdS71FX0TZ5ls++v38uYFEBZ1qrIWdvjaZZVaoztQPoQvknR6bK?=
 =?us-ascii?Q?pwHvPs+g3onWISG/znHxK5qbHNWoBI5b/uBU7zfZuC75eP1/WFoqpTtgWQOa?=
 =?us-ascii?Q?2OpJ2H8BKZUt2UCypbUfvVmN27iq+VKaaAUwWM1sRr5xtHS63YCu3JZSv7fL?=
 =?us-ascii?Q?z2IWnljDrDA2dH36A4vJQHrGv4eTdSHfXbv+hMjwUmnUEFUgrGn2noO3Kc6d?=
 =?us-ascii?Q?NGy3FNGh+ERLFhU/21ANSpo4oTG24QZlVIPu6DYtlz3kqa88Z2T9IjHzY15e?=
 =?us-ascii?Q?VzKq9SOlEqK7IqQfI0kU3hOhL0Qs8RlBBtxa1nK31TzMEjC8kMuLKiEQ0/T8?=
 =?us-ascii?Q?XE7q9x24CldRr9dfPxJSIdhZO6d0dIlvuxbgxrfHRefi60381Ee0PnulE4MA?=
 =?us-ascii?Q?PMNf1CewBvWw8lfk94GCxwwqrSWDzP5XHXMknUbzNzRPvoYUu5VXB8ykNjO3?=
 =?us-ascii?Q?Xflq74oS3vNNKiR+MZfBv5+5vT1dVjK2n9P1u/ePbxHePmgqbjwlviiNdXkc?=
 =?us-ascii?Q?f/G+0uSUYoI1g6yd/QuJCbWrTnb/u9LtKgCQs7EljyHOiCLr4vXAJHJFtzeZ?=
 =?us-ascii?Q?3vMGxUaxtgWuvoGVVhpX/z+PjU1Bmq3VikdPwK//htb8pu45uwqQAEL2M//3?=
 =?us-ascii?Q?iXEhcpr6Yw7+xvGpEEzoYn42jxbtjUJehiwO5CUbaYLfjBX0ZwBC11u+LTw1?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616656fe-13e0-4ab6-fe62-08daa56842bf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:04.2188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EH7JVzAlihEgjZYL6CjqXsbQ/VN+71WlmY22viCye76iLp+HClaUyxpLSOtdHeIctlxOngPFPn38D4cODMhwsta72yIheBtAaJCfdHnwr7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: GMyvlEbee1aqece6Y4J7hm9Q-yYIqMz9
X-Proofpoint-ORIG-GUID: GMyvlEbee1aqece6Y4J7hm9Q-yYIqMz9
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
index 912cc2623d47..a6b6c769dee9 100644
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
+			.result = SCMD_FAILURE_ANY,
+		},
+		{},
+	};
+	unsigned char cmd[10] = { SYNCHRONIZE_CACHE };
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

