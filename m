Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D46BC43217
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKDXYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKDXX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B155719C34
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7eP012102;
        Fri, 4 Nov 2022 23:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=SSEtfUFc7rVbxpJTSb63QP4Z2B5+mprzop8q6nPPYeyl4sAqb7yRi++nKQd+LTenbFSf
 54AdqxOZk9HKDL5dWHHpkn8d3cgLbw9ivmwHU9X+Hs0EipR80xcuMAgjpfAMu93gYQnj
 GsiYzlJTwXgbroTZcuE9gt+FedRbtGWTxf5ONb97KCx6JbIMBjugmny+/svDnMW9JbBu
 jfa4gHtzjJAbynwyhnfTHM/2SlT+nHlHS2Lc7UE6xyqmS/xYI0W6Iue7lzDnmaeAd+3f
 7egFU1o0qalc4x7DCqxWuYUiML2rRxsMLQ8mwzHSHSwmnTyrkSwS6eX0r0xa1ZV3aqiq 0A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N8CA4014069;
        Fri, 4 Nov 2022 23:21:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4t9rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XASajHAAdyfllzBzgPunnMb575YPL7KAr1rMY9cplzqvBvfDw+bNT2ZaUTSxKZrkYRdQbS0Z71h1ZQyrVotleyMXgsDIKHCGi3M7nhMCYnp6teZBFHw6ZGZLI1JIjD8vu7tsfN2/BdvVnG6Mp0JoVFwPvV7KaqORinMH52Z5g4DkmC5IxHT/4B65As2tuU9NR6zBS5bKMqwJAxnAwYdtnDrU2mAGFhmylDtJIYV7sY4/HUQdTMC7uNT5qBzNocjdV/8TmkFyr7OTuBwwzeyIlIWNC6y8dE424adfg/WE1S3KWMKZo4l+zkOgc/Ih7+s0ygV6um+SP8gbL3ttE5gnpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=CcBAtgcOiNG1mF+p+T9cijxO7lRBd4suNK7Re3cyGvIUGoH7s1Bc1O7xmbOzp3/sD414zW8WXTfRuLI9hH1NG+fng04+0XyJW8EtPRcH/Z+tGEoWufkPKuoEmcAcrAj6pRFmMXWeNN5bRK+syXvl5M1zY3mn+B7p6yTmbzYg2eQUGoEmHD7KNPjBfi+V8ShklOx6gTXDMCriMpq2RncbwOEjUA7cMcUMaPPEMbagjrq6CH0LX4nhIWOe+W0DzZfdOK3zn3ud+SxS6y4oyGlgG4J+CPUXotr/j/nnD90i/LLdM1s15XacjVEQ4hHUnHYXO5aGyU0usREp/d/9SJQgQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njWcjRm7rRVDU92EVjdVekYdbKtw8s0S20ejH0HXvtA=;
 b=rf0kJhjmcLb/+likVMgr5HxCVZKn1FzMMYvB1CpJE4qKd+icjHLKto8w73BTQY4Tm9Mhb1iEx2ORHId22R6CKVCzatR5mSCxUUHIlUyLQQWMEv+SOkNe7YxMtTW3Vk+CV97XK9cUH7T6lN5HvEch5Iv+wIwJ5so6youmzwCAekI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 08/35] scsi: scsi_dh: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:00 -0500
Message-Id: <20221104231927.9613-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:610:cc::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: c40b9f73-d368-418b-50c9-08dabebb51b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oS9Nugrns0Y8nelveNRDazvzWiOUDhHZS6i7cJWH94asxGgQn0C2Zwk5BaPAGZvS8t+pdY497WtDoI3nAryA1C0MRwX14yz/yWl4ShpfuyJA2iQWJvsqqhTA2xtl9bkNU1X3hFMr6Pj3p4l2I5Ok05V1IdDHcfHUKHF7oVyKR8YuGcLCzOj/Z07jqwup8OmcoW53gXf5+3cMHviUnixenjlgqRfxbQlKKCuM0b/v3I3QF/dacESRCPgkuYk0oc4y6Vz9tUdBHPjp+Fz2PyilJwoRW+zqLyltDqqGyOebbs18g5VHLQgIgkNzSuIcpnPVhYP3cu6raWubdy7BDZAtrXODq19gzjpuKQt3NbNn/npJcl601HHivx4eg5a99NDIDEd1zXTingOO7I/pdvjLFMe2mFfn7EKy0os8DnhnF1kGccmnmYqR9uFGl6S1zmy/qHxdcqY0bYKmEEcPpPFet2k2/yUVqrYMJ0St5NzyReLVH7gmCsaU2xLWozi2gs5P2dze2Zh9wT3Nzn6e8mPlOBeVHKLsxSVPhdVpU3PfNnFu5o5DyQXeCQnwERr7gdBsMKQSd7NvjzOxywcLp9ghW4VTBMey7TJnSzn/8GBLHwDju2DwIf3Pr1Y+uvX5W6BCBByBNpGRkFg2b1mHINiQ8KrvRo3Ynib49NxjzdnZkr2QgEj6tZZoZz6HY1bM7Xx9z6KStnXC7kB0Hnclz2MD7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I40eF6Xs5MHD1SFJ1kjQ5/z09dYYvhGkjk7dmW0RvLBpAZO25/epM2auG4B4?=
 =?us-ascii?Q?3c1TuNMuAEY71F7qm+DFvRmasZoPvIHgf4I1RxNnwxLfgsxfsmIhB1y/pAsV?=
 =?us-ascii?Q?tbPZYXJx3dnQf7Guum5ltYyjNjr/KjGe3H0Lr6z3wMAoFH0/UU4FZ6F8g4+F?=
 =?us-ascii?Q?kz93lfd7jstUq0CczQyegDjUR9AFySfn/W2eR4slH5lEXAJWBWJmLU7aOGmk?=
 =?us-ascii?Q?07uCLxlZ9bMwzKipHrKyLpsXr5iA8tVarF+EjnSckVi146yHGNqzzgJvxvzI?=
 =?us-ascii?Q?J6WMDUtCUQVsgyVJs70WvAzoX4EWF7eL7mx3QPwfDAtM2dwXKgaotVIMBQEt?=
 =?us-ascii?Q?GZl9d4y2mmcjM6wVfOylI3POSTW/Qd5Ce66HOw47PhlCA7XTd8cDs2Hv1wTu?=
 =?us-ascii?Q?deKHveOw5ZF2FoWD9/j9SpKozeMsTLUM1V8B6Drea9ycpb3dUKGRYin5wFnl?=
 =?us-ascii?Q?cHoCKB3uHJZHQSVRaMewF3pSadiK5Hhcq/k/JLt0KDaTkxXxfIbX396gbBBr?=
 =?us-ascii?Q?8Fmzjm+g0lU8lu8Kp2maYZoERm8/ElHVm1mVjAUQi+qNeKimOE9BFai9ZwlF?=
 =?us-ascii?Q?AZ44J4X30K8xcG0DRChjGk/m07OkpLFutsDxxWPIN8lq1LAO8UvNKWgnhfR4?=
 =?us-ascii?Q?5NW4D5b7b00lcXDLYuZhQohct8O6pxiVti9C1Hwq+oO4gOt3ihKGqkaJViTJ?=
 =?us-ascii?Q?mIHB24kfeNqVYl/xf6rFvwxSgb2rKNR0iXbuvybDw1dOLemNQltuGOgUJjIp?=
 =?us-ascii?Q?x57kIec6LZ6xXrbS3G7gjtp+TW/DfrTaSnJO52ayQByrajqTUzS9PJHwSPv9?=
 =?us-ascii?Q?7U33LiY3kGIxPtbPfegS+7Vrj+Q3lX8SalVTC+51DvT63HXDdpAhqZMt3VX6?=
 =?us-ascii?Q?/OtU3GO3rNK9/cSbSTQOJGejBpT7cZGFatxHFWceZbnCTZMZShrqBtmGWTBs?=
 =?us-ascii?Q?fzZJLwBDCzC7HAMK3psVPWMNdR4z7cPpg9uy3dYcnNwyxOPgH12FBURomJx7?=
 =?us-ascii?Q?dYCsrovejIB7SCrAMmDWXI60e8PoD50Ks5z2ITpja0hB+qvrAaxwNnJ1HSNs?=
 =?us-ascii?Q?62E/yHLCVMxS50dGPICTd/SMbogmIYw/gdthIcS52hFF7nWcs/gwDIRTkoZ3?=
 =?us-ascii?Q?FU6ck+VnoWYVF0xRn9Nba/bM0efiaAELZmG+hNNIwsJN1VTlQ2sXG9EKyYnr?=
 =?us-ascii?Q?gpk/ZN+F24s3vtXAGdDQ+MYf40RNovJxC6aIdD8Ff0SELfev9UjUyz5fy0wr?=
 =?us-ascii?Q?RZWY5/uQQGBlD68D90LcQnJiVS7q6LQvf3Ec81ehcOOlQLaPkSqfE7HnI4uH?=
 =?us-ascii?Q?UfruvBCILXP1GFntqjP65ZKVwJkz3X9oEcH68bkulroQOyyiWPmLNTw+2OAZ?=
 =?us-ascii?Q?OPN6tMooF6sE2OR/PTUHPUHsMu89Zk8YQYkMXQZfqco/yQ+azTUHPYzcNiJk?=
 =?us-ascii?Q?175esbsmk+trdpXfTocFXIpx+w4Ht44lsqirOaC4PoWqOgVqnsri7ss49Wa6?=
 =?us-ascii?Q?cHdwQu39j8+iBi8f3mPMOYA3U1I7icYKQqHI1T1ALUYMzk+ozvv+u/W3Koqo?=
 =?us-ascii?Q?CX0MF7k6F65Yb7N9tvCZ9BawKYWDhOIjGHJwNP6G1odTEDx6FJaZNQKl2t7I?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40b9f73-d368-418b-50c9-08dabebb51b6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:36.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+sxGeZqJVsOj99JA7OPIDIvLR+rIsdo7AR3b1aO9HRQfVh4OsdnuE12cmqSEUgjGGfsaY1yspeRRu3TLAHKt6xcGWUFdJvyeTwzIyl7ZwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-GUID: 0Gp9eajvJxJkQDMFXd73AbDpi9IxOEXp
X-Proofpoint-ORIG-GUID: 0Gp9eajvJxJkQDMFXd73AbDpi9IxOEXp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 26 ++++++++++++++++-----
 drivers/scsi/device_handler/scsi_dh_emc.c   | 13 ++++++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 20 ++++++++++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 15 +++++++++---
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..e4825da21d05 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -139,9 +139,16 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buff,
+				.buf_len = bufflen,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 /*
@@ -171,9 +178,16 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = stpg_data,
+				.buf_len = stpg_len,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..0ad6163dc426 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -263,9 +263,16 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
-			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+	err = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = csdev->buffer,
+				.buf_len = len,
+				.sshdr = &sshdr,
+				.timeout = CLARIION_TIMEOUT * HZ,
+				.retries = CLARIION_RETRIES,
+				.op_flags = req_flags }));
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..adcbe3b883b7 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -87,8 +87,14 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -125,8 +131,14 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..c4d1830512ca 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -538,6 +538,7 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	int result;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -555,9 +556,17 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cdb,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &h->ctlr->mode_select,
+					.buf_len = data_size,
+					.sshdr = &sshdr,
+					.timeout = RDAC_TIMEOUT * HZ,
+					.retries = RDAC_RETRIES,
+					.op_flags = req_flags }));
+	if (result) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

