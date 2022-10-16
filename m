Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EDEC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJPUCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiJPUB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB4D2C645
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:01:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJluMv004999;
        Sun, 16 Oct 2022 20:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=i9vh5+iS7Gzn5UmBIU2hW+DPpl6St3cZ0h+c/7sJvC9mNJ8pUA+TBkNVo9m6iWttvLOT
 g19btewST+X/aQLOY0ntxMry3OryRCnHyCD2YtxT8gu0PsyAbOyd6M2O5ple7TSq3b0Q
 CMDWQfKJZul/hZYryDwk2CDr7aq1DUYYelvEdDjKmqcvbhDIrvzOmzTYFti1Ac+Ps2ts
 sLMNaO11o+WRwEQgHXvd4WLCZTjt/8L7+6Rb0wpKBd8UjtDSCngU3/YQMwS3Bho4MXVM
 CppSt/tjH8BqTYKM3t7w7srQO5X0lXm30JQtc5SW1x4ZNIC74E6Zc0mAo0m0nbjQo1pL 2g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAneK001181;
        Sun, 16 Oct 2022 20:00:08 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgmf-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrTZNh5sda4W/H43foZmCgU/zayiLHgeeCIx3rHi9D0Ui4s8E7Rzav2RXZ4Y3kMTCoPELZqiZ331gv1vDc4FYEoWKFbzqIB2mQllSCd6jyxbogBLhJiMh/mW2OLI8PIuHrJsk48oreTW3Lmyto8l571s/+vyDdnH2cZLIE67qzhsQUhP8c+NQs5x7fgyp4pCqVEFNoh21fwpi29mi0Xheb5Ut2uwXjZfx+J/mpIlYXo5QoliN7ZwFycTRYBVEHG9dj4RBlT6dvTYyto7qlzn7nSttNT0NM092dEnd7i69tTHmIXThZ4/7ADtG1tAs4cSPoKuNZ1ZttN+fbPnb5TDSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=WvHYM4Pe++CRjWmg8ZIF6QgOoOzD0UkJo+kYbnvvY7sk/CIYnu+TxcFVe4FiJA1uHtQe0UmMlYnSlbMRWrW4hAxcDptfKVawJZcABY9cncP3Ah/nOhKbxmfgtiw/IUbZhAN831aD31RpUCMU1+Q9teT8/4/DGqenISNdVdfjiDlATFmxE8MzSBfPmKCPl6lCunmNwMSfut67WNjJSfbnPJF1iX23Gz+vVW1/flP4JqKxSXoEY4F28rFHv/NbDUUWdj7zynHDqoPcO7hkD8L9mjwfdZ1oFY0wwqox/10F5LhFTIrtmU7LgpezpPBEZGxgSaBgZpumYMnzNI5ZqzZAxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=DzFgA3Imu5mT5kLIQeu7zNdZLQF/VRxOd93LkrClyPF6B4qNhehJ6sNOGLU7K5dFi4LzG43RBQbF7ulvVwaoG7sKkF/T49SqxYjSf2Bm9TrR9owPzPQNK08hKRWH65QTZnkGXJbybi+FM6zt9wBH89vPvkxkMfxq2DDnZ0d0oz4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 11/36] scsi: sd: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:21 -0500
Message-Id: <20221016195946.7613-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:610:e4::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: e701bbcc-8acf-45a0-e1b9-08daafb105bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHcDt1oQiXbnviw23dilbRZedTMwVDnE5NMd3P2fKT3m6clPBm+IzZ5XpvF+/Y4I7wiFP/9vraw2gjcf93wqn9+U4n83EOD095U+CXxRQhPfykNE16PTsosTcpoOVGYa7nUTV+6i6ZEJllt0ZMpEi10XexUu/eBztP9Ene70JxEAZ5ZLL9fXt+o3LYImHadWn6WBIcKAQv5PyAuJUAxjPeixTIx2Wb6goN4vo2HL3eNfs4aBzS9jFqKUditt7xdCyvN8Vdak3HK5y+NwgWzA3F5RIIEZvtFjo3RJJW/myEffq69kBFChbwnWgb9nzmesF+wJKhkGPk15RnJgz43dWb3GjQyJER6pvFFjGIzJkE7MA0EsXwBRxO3Idg0zR4oRjJ3Go4ne4yv+HeWlnyJ3LP42+cPKjbwu4V5wGzd4rLa09QP96/3A6ES+k2WHGkEkOmvBzeOHipGe/0WGRJEHFxwHg92/McdLA9YDPLTEMlSaOao4PYN3JOeNoVR9LnovMqg8rcQxeAUe0LSFKXSjxUx5xOU3TeQP9vBhYFZdyFBZH7nt3VhjpV9DS4irXx2bbpxL8ymr3RDzbCPbBZMEUvSaXemIueEFk4NCG1VezxtXnLal2pCBtyzJrGc48KjfmyPk7rEM4li2WXMUEeOyB5hjfx+vj+YCQcqsrYSdIS75fPHEyS2uv2CAqo7wZoz7XvbS1hVO8q/gxlBQuxpIqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PQrti6wLNTy2Ne8JYYOifTZZ85yUqqMooKiYZK2IUp7evRTUUJY/9qXDGRwA?=
 =?us-ascii?Q?Nsx7UyJcmsu9T7A9XYjxQYcoKNqJHY1pDlFB5rQIOdPTs4Oskx3JJG5No2SN?=
 =?us-ascii?Q?9cT42eciwik7cvgsBo+SL8tBN5euoR5KlrdbmjcOAurVKeN8/RO6lRHF/BMY?=
 =?us-ascii?Q?n4lF0/OQRLq4aJ028NvcBO2lOVtW1/OebQY8OEOhjEgdLw5Pw98SzRfyQw1H?=
 =?us-ascii?Q?aWFEgXmv+bwhLUai9+tC2vMbCvt3JZ+bUdzQ1YEA99YSz0FPHyafTTMKYYsa?=
 =?us-ascii?Q?wKhrS9l1QCC1aWs2ilgVMilDSFJCeNzuig1/clYaECdQ9HdgbXn4L7PIoEgD?=
 =?us-ascii?Q?Dk75IY4T5h2QDtTkCetkBcfJTbizbLH4toyERHoRxkl+DrRVGnvgJ/a5newI?=
 =?us-ascii?Q?cLxRTjjj4csCEYYGsLCwHaBpVdKCxRmj+72wOWj4Zzp9uA6L59Db2Wlk320q?=
 =?us-ascii?Q?OMgNq1qaGuLDraHu+fLpDyPY+LZ9fXqP3xGmylLm4i/mD+/FSh8rvwW8abEb?=
 =?us-ascii?Q?mD2bFkkSOJKTalPD1nRbvIiivW+j7jIJVquvvuebp6oNDEbmZ6JEQfgpLb2t?=
 =?us-ascii?Q?Oh+Cma5/mx1yoQ24ZF034/Z8vDXUhQIt+zl02D8ePmQ/SEBgQ8IJRd6ovJth?=
 =?us-ascii?Q?i2ZK62BQ0x1APk1ZTjtOkQSYG0Pu/A64OrnypH+aLl/+7wQJn/VAOkgP/rGl?=
 =?us-ascii?Q?giNh6X1mBJGYMWTHrP2qSeDt1gH7V1L3QYGychIP3q+glCjDKumJvWVKYsBU?=
 =?us-ascii?Q?4WRb9ePdfNmu/P3z1/CzdHAXzLRgXXAHVLDGnUK/m6H8gRH8e4N27EMq3+av?=
 =?us-ascii?Q?vmckTLDHHCiBTfAMySORM+4ZiSgPi1d9ubpp/hjSv6d3Q2+sjMOQqjoTk0gP?=
 =?us-ascii?Q?MTuraU+bxIavvDwPagNf7kzeOKtBVf6l1LzFT3uryhlh4oFu6Z0UgYb7s4hp?=
 =?us-ascii?Q?p89YkHzNHfAp1hTTIBn+NGfIEiOXaznkRhJK5TdMV/N66pHPy+xX9xSZM2em?=
 =?us-ascii?Q?EMp1qAem1fFwLdup/3E5jRSN0x+fwZeHuF39tes9//iW+ZU492McSaTPvHoE?=
 =?us-ascii?Q?lQg87fXgHBmfODbjtadfg65YUa/6g3yt+XK44M3OQe4/pTTvVq+Mm50h7Ubx?=
 =?us-ascii?Q?FzR252fq0jAFzcXiAWbZqjx0Dp6ucJzZ7SAUYUQQMRW5ImuMORQh6OxEvNNX?=
 =?us-ascii?Q?pJSVtQNuC3cTwTd0M5rvMOxRWAbTYi8FUanneIb5Og37EbJXuHNyxGF0evpW?=
 =?us-ascii?Q?h1XQpfqrEaVIP7j8Y25g5C87VE00ITGRHuc+QFspNWnQgjcRQlT3TnY6jtHT?=
 =?us-ascii?Q?Sfp9ks9OXTv/U8WH+ap+eM8rUDRfH9BwuVBzNwTUKAPauw2AJYA5xOHoWEqe?=
 =?us-ascii?Q?g5g7O2a9fFZt9E2L6hCzRgOHCEtviNfZcUeattJLcsRELmg9a3h0QeGpo8+3?=
 =?us-ascii?Q?rnTeS2KWdzGX/XLlhpCp+gmsC5sfjkM4VNkG/3ayUqDjCnXeKzY7qNwtWtrx?=
 =?us-ascii?Q?RhBAi4qgu7gAYZs6poAekib15ORkFQiFfMaNa2HGncZOYq9WxWDv2kNMrc8L?=
 =?us-ascii?Q?bIxvEtM/54x9dtZuLeYp8vMQuspQxpJrA+qJqgU0a1Fibfdb3eqmY5K1dqAJ?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e701bbcc-8acf-45a0-e1b9-08daafb105bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:06.7998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIRt7HSOVmxrLxYNCk+lJaVnJP1OYCOeF+9+TzN84ffIhkvq66RpbecAxKSQGuhuoUNanTgLsa76XwJo0yqP18GiZzSIYG1YECmQE/RLvGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: hlPkaFvd7X1l8cWi0pDlTMYuaM878Zxq
X-Proofpoint-GUID: hlPkaFvd7X1l8cWi0pDlTMYuaM878Zxq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 102 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..37eafa968116 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -671,9 +671,16 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = send ?
+					DMA_TO_DEVICE : DMA_FROM_DEVICE,
+				.buf = buffer,
+				.buf_len = len,
+				.timeout = SD_TIMEOUT,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM }));
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1594,8 +1601,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = sdkp->max_retries,
+					.req_flags = RQF_PM }));
 		if (res == 0)
 			break;
 	}
@@ -1720,8 +1733,15 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &data,
+					.buf_len = sizeof(data),
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2062,10 +2082,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_exec_req(((struct scsi_exec_args) {
+							.sdev = sdkp->device,
+							.cmd = cmd,
+							.data_dir = DMA_NONE,
+							.sshdr = &sshdr,
+							.timeout = SD_TIMEOUT,
+							.retries = sdkp->max_retries }));
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2122,10 +2145,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+				scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdkp->device,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2272,9 +2298,15 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdp,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = RC16_LEN,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2357,9 +2389,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdp,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = 8,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3608,8 +3646,14 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdp,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = SD_TIMEOUT,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM }));
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3740,6 +3784,7 @@ static int sd_resume_runtime(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	struct scsi_device *sdp;
+	int result;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
@@ -3750,9 +3795,14 @@ static int sd_resume_runtime(struct device *dev)
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.timeout = sdp->request_queue->rq_timeout,
+					.retries = 1,
+					.req_flags = RQF_PM }));
+		if (result)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

