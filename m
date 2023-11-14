Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F87AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjKNBiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjKNBiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750A1AA
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:05 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNscjh016932;
        Tue, 14 Nov 2023 01:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=FQa4V8Kesb8ZxQtrf1TJYlHituufnQJGEeg4rmR31Uo=;
 b=Yxrx+VKYV67v/2HUgMlKJThWNzmFo2F2GjMdCQpXG4WPz40K+k2qgfuKopDD7PXg5Mo3
 1vIhQcesEhdzgfIP1foemwgeB4EhncY6uQ3yqyvi4DUYpG6HqmW90Iqtl8xA6oFyQN7I
 1T0vJ6zg0LAF9uxPkWyNGfA7MudNcwmTZ7xE+Jp0SmwL43VloGQKcYPcObVMCsJjZt77
 npI6rmJ1P19V4SoM8n4LUvWgRRHsPvt8qOxKwKwK8tzghkH38oluxaAenpoicxPqHOXi
 wiifj1QSqdDhi/DFYtR6ZkYhJUKo7CjJoz4inVHnx+a5uArQA9pxl5dGGku9ioT21ck+ VQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2c4gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1ECRT029776;
        Tue, 14 Nov 2023 01:37:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxqqsc1q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LC1YlayBB3O/SFnsfZLeoKFhRsZ3WsF6hl2/FClTfdhkz+bQGZkxZ4WzLM22nURGwG6QrHSn+Opqpw1fhQ0dFqmjflSc+By802MYOlmw9KRmp3sdASV1+0/DeJ9AmZ0YQb2Mr0PZO5r8EUsp7PXPXwVsKYYK0nlTDokj68TScWfOw++hrM1F7gQ7OePzd07Vwa3NyEnOOF/X0GFqe6/Cltb45z8zS4OXnoh28M/qsDx9IPyBFaZzqeMlTD5HJLsx4WcI/aGkeXtdNiQa1wne9WYmxfuiRezg9uX2IIm6HwnXFbXl4GUHptPLJ2qujDJYIWgBIjTAtJrPkphb3sGVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQa4V8Kesb8ZxQtrf1TJYlHituufnQJGEeg4rmR31Uo=;
 b=W4CiOcQXhU7LIC2cbavAjbukWFEet9EMUVhj7HdELSebFTnz2TwZSQyuwJuAGTafd4rd62U6QTV0GQCBWlndP6d2SUadkx5O3QSyDm2c7bqncX2KyVHPaIh4NRcp9XEvF4kWIqXTkGEnE0HvE8v9xjXYMBma657gNI1Fqj3PtYjzP4Utu4A9BtO/BgWnSJ8HZa/z+ZbQUaHCIpgul9TWDYrlgTZw3K37Rtvu/tP+5+NGylCpJGlRW5U6J6X+3X8Q6tCAAS9P3ewA24rPvisjyLfHXGC+bnEYq2o8GDD/d5y8DgI5a+WlX3gFMqco5RozPQRHWdIljVrhEZTdGHVc6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQa4V8Kesb8ZxQtrf1TJYlHituufnQJGEeg4rmR31Uo=;
 b=t1HjqjhRJMx5FuUr4gxdzf9zl4jkb71/V7xs5mWuy9WlQGrEdo078Jo6lVfLl43WMDeoRrLoCtMa7nD21XRS2/NEUWmL9eRNRyt2rEEh2hk1pxVwZOl2xsnUpDGwmSP3gr33TFzFTfp7sMYIFtnBtO7G0hFZw9ywx79Xd8vmshM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6752.namprd10.prod.outlook.com (2603:10b6:8:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:37:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:37:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 01/20] scsi: Allow passthrough to request scsi-ml retries
Date:   Mon, 13 Nov 2023 19:37:31 -0600
Message-Id: <20231114013750.76609-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:8:191::14) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: f54ea60a-f7ba-440d-5ac4-08dbe4b25241
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nIs6suEMC7Bn09EK9Afnmx+/N3EWMnbm2zcIM17EbByUqzGYWOc1lwYDJi4DLlXMeeXSclbqQ5RK1nuYfrByHdqp7M0wtA9rVMs5m+8+v10AVjOO3T1Zo3RmEtHaLQMEyag1QwfePoR2O9WIAiF/qKYp0rSgyDmIPAQj2PV47q7F0Z/qXO+6y70o0fVjxWq62KDvHCVDX7rOZO7ucaMXeLIen1pyEMXMt3hTNluxtxzpcLZCrhQv8i49fG+udw4RILuQoAbJEdNBbPzseOz+L8S0gIY7emuDdxn1/unxHpHC6edHQJdk8Cw0GkK6sn2m4M1q7Lo1Kr2ADFiqxUZV19S6HVvs2wWF5UwrHKHMKdMD4zjV6xslViECk94fvHinBTcrLWbe2ZPYzpCg7uLqkVWkk7PGqf42KNWqOJLYS86TFPYFmZ1TicTSl/KHAiSd0Z0yZaR9Tu5Ho/Ep2WWSFKrEOPUApycDJ8Aj+1wlhhJd0NSIIuciFPf9uZhgvsQXeYuMJr5Ad7A52t7JLD3nj4mLczk2kFKFu2vDHTxXvkMVtvIeoY6QshAdJkk+Rck
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(1076003)(6666004)(6506007)(107886003)(2616005)(6512007)(83380400001)(4326008)(8936002)(5660300002)(26005)(8676002)(2906002)(6486002)(41300700001)(316002)(478600001)(66946007)(66556008)(66476007)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O4r2f9TpzeZUBbMVDWKnNY6+7EP4G8AOj4n8oWMl+AcRv7pgif5o2xapIIap?=
 =?us-ascii?Q?wQ/bjEvOQGDT8AhyADyPp1q5W1zZiahdvB9/SBe2teneW5ZTsnltaWF2omVQ?=
 =?us-ascii?Q?3oiP1X5J6hI9WPqIX2benh99TowMfNxn+BUXQ/NtVBX/1kpMkXCHBLmWPSeP?=
 =?us-ascii?Q?dSwYtUeJc4qq07Ccw0Uf3dREEBcvRm2T5hjA5TYYvXwH81vBuWX3cHXQV+o7?=
 =?us-ascii?Q?cGl5VuagYDS7jK1RfY1CZOQx7O5PLpF6/aQMy6ub/3T69RLBeBoCyhjULN5n?=
 =?us-ascii?Q?l3MjWFqObtd2JdnBil2zTXA8wYFjJY3AzSFWXabG+2Q4IxxALDVMKS1gXePk?=
 =?us-ascii?Q?XtZbBz0etzgDa66bTavE16lf5c64cpS0/O5DYqUTOTS1oWWtqv+pNF0AzVnh?=
 =?us-ascii?Q?aGkjjLQdde6WdR0WsD8TBdvtXGOKyDYx7TVtG32VFc7JXJJPkvyQbbjC0oCG?=
 =?us-ascii?Q?9rytjsyVx7RdPazVAyEvRU5Fn+aLcNZEgJKfWT8GfSEQAadHSv7TNgDBvGq3?=
 =?us-ascii?Q?6ajF31gS2ZFJMVA6PE10PATkaqliRTfFx9cdRiMAN8XhCqZxvA9lLwzBTmlv?=
 =?us-ascii?Q?9i79kqx29F9a2VoNm4onJ/9clt+/aRgIrrTrH0Agy+OsDpqbZ1Ctf8Mknhb/?=
 =?us-ascii?Q?eiJRR59d5xGLg12j9VfbPohCzuz/VNkIQGJTCFuPe9oqPcPzgINNy2kEVbKQ?=
 =?us-ascii?Q?J4XMLGEPPn7d2OX1J84OG1Ydg4iGLPWOQEaSRBngM6SdG4Q7NerzFr9bwm38?=
 =?us-ascii?Q?B0M2VkqpD15qpg/oMXcTZPaeEyvjQuR5/uf8N7xorK3etwmOJPSBL775ucb6?=
 =?us-ascii?Q?AAqnrl4Z6+pEFq2FfY3cBMpTG8iml5hAZ5j9oMM+MIccMEk4S8+AP66LAHd3?=
 =?us-ascii?Q?/Cj4nnpGEDxBgoW5AY3gN1uzj0TiOdqpbMaLX8EGWdhc42+K7m0/UGGOOaWy?=
 =?us-ascii?Q?A/wWHS5bSVd0z4w3Mdk6c95VUZwosD5bRy+22X4vF3H5TIun3q7ggI4QqpiL?=
 =?us-ascii?Q?ax3Wj1J8s/Xd4FQo1YMhyv7dCZiaPUScP6vvdtvHtfSQB6yjoDFLv6tMfcDv?=
 =?us-ascii?Q?foUT5GB62Byz6rAz7AdWRq/cXiNXeTcA5anzLHduW+vU0qVPGg/eQYeJAWIn?=
 =?us-ascii?Q?x/93180d962IwU98Cz67daVGQBRIskI1J3tvWY5bIyAV0KJoKCw9D/3lqk5F?=
 =?us-ascii?Q?B8H1AmjejMkYH2VVInBZTm8eHOC1HiX4may77APbvMz60p1TifHWtQjoejne?=
 =?us-ascii?Q?nm6vxXhz0Q6u4MqmCHosLdwLPLyUDZ54lsv5dC8ruC8+oHqEdOEGCFfRDj9w?=
 =?us-ascii?Q?dtZ6MWyKc4x/SwMabxD0DdvjUybmEIXQ70t9IZoQOJ9qUC0lI9IxE52yurB7?=
 =?us-ascii?Q?2Zx6Twa1pP5ybR1PRrDzcTEV1ZJGiiN+NWi9jIOHwyy6PCuHAgGqPFB0wGMq?=
 =?us-ascii?Q?JhkC1ftuLZplWK+7OcCyGRxO3lgmTm6Io9cVXEqXvldC3wkMABPgAmbb7Qji?=
 =?us-ascii?Q?BhejNMN9v1OE6mAc/9+v74nWeeK37m/lhmlWUtDLHYIDOs8KTsv2O9MQOVXM?=
 =?us-ascii?Q?8n5+XatjDgch5XGKLr+wn2ih7hbYHnFTIoVgHI4Ztbskd1Ya7aDeoj/Of9eZ?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hOjK1QrrdTkD2whmH01d+Mst3WwvXLkAg3Lf0n5LAKlBc/z/bJsMCjxokt7W1JsORXxKaZ4iSsz4omOU4p/aA8oEjqiXfQtlVbQ1ebgQDMHyZUfiA/H9QyVtQIGw504PTLyDhtw981V7CyncOX9mWilMm7uJUq6cQVh5SvjXsg1xRZtRjX4WgcDlec9rW2dFy1f2q6z0qJ2+kW0Yt5b0EkycK6fTWSVSqN5Yyz2dp2sUMRxy1M4uswxHfC4vT5CSstFrwKuHYO4BOdWt0as7NM56CcB8DWwUY8roeURxoRO9MjE0CthTN+ESrFwEfcoujnRD6rTtZ+6Mq1M3W3rCJr3ClgssMlW13HeKAgxJk3Xr1hzRUNUnBBv8qHTXJPwUqidTqOqtgRS6twwtL8Pip4ruco4vYeG+H+KDc3KPPESVOWsoWpn6BdjTjNNuL1B3rmjywuVvDOl/grZ2avnJW5kzesCKH1Z2q0L0zgJNIeySJ7CDyDf9dQ62xviKVauWcGbAz/FnF1+YZRaHaA2xPVskCfGCgOYmpoEuwqPd8OC7Ufmj3x832CVfydpVjDAt4kYZURBf6iu/8V8a2KmggkN54XBZTGia4RJPKvVLVBoN+S7Kl+ARTD4IjqI9/V5SpchAd0+lOJuYpxb4pyN/bIEIIz0f/Vgi9tS3sFnYt8Y/Lv9LBfZP2JWKYQehBUuMG04Bu9OGGmwgCG1S44x9bXovXD0rTmO3wAtZ0H8X3gvXmG48imEWFdUWJFV5DdRVfCDEK7nZfO1AoSWxAyhy/0KFqKTsZl/vTaRnhCqa25lzGQ54sIYIyKi4H4jB+/ZJochPj25RjFS2S5uPZWFqSXY/nr+HWvwH579Pq8HnTMNFKxx1YDS1WdRbnbROAMTH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f54ea60a-f7ba-440d-5ac4-08dbe4b25241
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:37:53.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v/kFHerRdwJ1JTC2BdiJHcSTqnXlNoKWORQoll2hzgIHEd+UzW3w8NInJVrhDbybltoUap/kPRmgBB/1AVlYSGwYbW0IRbPciumCAneJt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6752
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-GUID: kXCW3VRZFX0SbvN_5AJJozBuWE-mpyJH
X-Proofpoint-ORIG-GUID: kXCW3VRZFX0SbvN_5AJJozBuWE-mpyJH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For passthrough we don't retry any error we get a check condition for.
This results in a lot of callers driving their own retries for all UAs,
specific UAs, NOT_READY, specific sense values or any type of failure.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
a lot of their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 92 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h | 48 ++++++++++++++++++++
 2 files changed, 140 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..dee43c6f7ad0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,6 +184,92 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_reset_failures(struct scsi_failures *failures)
+{
+	struct scsi_failure *failure;
+
+	failures->total_retries = 0;
+
+	for (failure = failures->failure_definitions; failure->result;
+	     failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reset_failures);
+
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ * @failures: scsi_failures struct that lists failures to check for.
+ *
+ * Returns -EAGAIN if the caller should retry else 0.
+ */
+static int scsi_check_passthrough(struct scsi_cmnd *scmd,
+				  struct scsi_failures *failures)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum sam_status status;
+
+	if (!failures)
+		return 0;
+
+	for (failure = failures->failure_definitions; failure->result;
+	     failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		if (!scsi_command_normalize_sense(scmd, &sshdr))
+			return 0;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return 0;
+
+maybe_retry:
+	if (failure->allowed) {
+		if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+		    ++failure->retries <= failure->allowed)
+			return -EAGAIN;
+	} else {
+		if (failures->total_allowed == SCMD_FAILURE_NO_LIMIT ||
+		    ++failures->total_retries <= failures->total_allowed)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -214,6 +300,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
 		return -EINVAL;
 
+retry:
 	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -237,6 +324,11 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	 */
 	blk_execute_rq(req, true);
 
+	if (scsi_check_passthrough(scmd, args->failures) == -EAGAIN) {
+		blk_mq_free_request(req);
+		goto retry;
+	}
+
 	/*
 	 * Some devices (USB mass-storage in particular) may transfer
 	 * garbage data together with a residue indicating that the data
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 10480eb582b2..c92d6d9e644e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -483,6 +483,52 @@ extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 
+/*
+ * scsi_execute_cmd users can set scsi_failure.result to have
+ * scsi_check_passthrough fail/retry a command. scsi_failure.result can be a
+ * specific host byte or message code, or SCMD_FAILURE_RESULT_ANY can be used
+ * to match any host or message code.
+ */
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+/*
+ * Set scsi_failure.result to SCMD_FAILURE_STAT_ANY to fail/retry any failure
+ * scsi_status_is_good returns false for.
+ */
+#define SCMD_FAILURE_STAT_ANY	0xff
+/*
+ * The following can be set to the scsi_failure sense, asc and ascq fields to
+ * match on any sense, ASC, or ASCQ value.
+ */
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+/* Always retry a matching failure. */
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+
+	/*
+	 * Number of attempts allowed for this failure. It does not count
+	 * for the total_allowed.
+	 */
+	s8 allowed;
+	s8 retries;
+};
+
+struct scsi_failures {
+	/*
+	 * If the failure does not have a specific limit in the scsi_failure
+	 * then this limit is followed.
+	 */
+	int total_allowed;
+	int total_retries;
+	struct scsi_failure *failure_definitions;
+};
+
 /* Optional arguments to scsi_execute_cmd */
 struct scsi_exec_args {
 	unsigned char *sense;		/* sense buffer */
@@ -491,12 +537,14 @@ struct scsi_exec_args {
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
 	int scmd_flags;			/* SCMD flags */
 	int *resid;			/* residual length */
+	struct scsi_failures *failures;	/* failures to retry */
 };
 
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 		     blk_opf_t opf, void *buffer, unsigned int bufflen,
 		     int timeout, int retries,
 		     const struct scsi_exec_args *args);
+void scsi_reset_failures(struct scsi_failures *failures);
 
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.34.1

