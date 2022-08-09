Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDB5C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbiHIAGL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244575AbiHIAGD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:06:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ED31A05B;
        Mon,  8 Aug 2022 17:06:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwJlJ007174;
        Tue, 9 Aug 2022 00:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=b0nc16e1sa85xR1eTlQa5v4D/NEXN5N6ZhG5J41ftII=;
 b=kNQToLS1rAbAKj5vudKvqloF6sqEVTAdSfwIDvSRVcUj+5fjzZpCqwAhrzNkTqzBsetv
 hNREl0yeRyTW5BOaquOrTabcyqztwJ7CGYLC/bLQ4p8Zp1UZDllvREOxp5CjPAAd7lFx
 4nd9/01W1Y0dDxBX0i3ay5VaPN8bgQvDoTLcFyMNcWUEQJ9TOIXvD1qDQZxhRB7yUGoN
 JIQ4J/JUyq4ZMNRPPB4BOT0QXZDahPRGjCDOkjRbHJ8UK4WwyHS0oYfZCOMc/xUL+3i9
 07YwFOxcUig0QWQbf5BlTf0mg7CPEqkx1LXBHJgS60sK3mnngsn+JJv4gydONlArDao2 fA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0wKw034430;
        Tue, 9 Aug 2022 00:04:49 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2da1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIeg20jNNOwAsENWSbcaEkzmI3n37V3R2U3jELwnm9nkt3wG+hNrhD2suXfHnPunRntLA2EV8c3877g6oSfIGDYjBC6RKKOvDT5AUh+jdyanDcxnLjPytVNxuyHWTLMGi3Ri/vfCAO+8VVpLF+xADenE6Y1Wx5aS9Ck3uedTCWvJ+O82Gj+owjO8VgZy/Fe4QOgANFvE7oZ2h6EcGF+t+i+sAoxrVTjCjXTFtTPpbU97qcpAilFNbZE+ZGovVi8hctHcD2rKZttqX1fT2QZMewTp9GpI+ufKuHHnqLtsO9PG+e40gNd+127pHD1oVePX/PXNTX1Up/sUv4Ath9QwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0nc16e1sa85xR1eTlQa5v4D/NEXN5N6ZhG5J41ftII=;
 b=SiTDWRlHNicwcxZFrnchbc3oFIh3OYdzy1DWUrvXqWHslE8S9NDsIslB9WtL7MR62c8ckmR98Si9tZSyXilJhEXXGjzK0wCIyQMC9PWdQnPnI4pq1Ht6TgZkUJUZu/oL2X+0bL5NITIVvoN1goiVgczX8wockEWEAffnfWYlFCgjtXuBFXaiRZV3GJzjElyzlulanIXyE8c/ngd9JdoCYvYZSzNfXHw3vykAEUQ17orWjx6rtOR1L07D+WLLNUVYIQqyq5syhbQg5BZ6hGchZWZ9nPX4fiS0th5mqq3COA7sA8FOxV5ulOOZQvVj4lObfuqfd5wkaDYsW7BX7kIbvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0nc16e1sa85xR1eTlQa5v4D/NEXN5N6ZhG5J41ftII=;
 b=TWeswIx8/UFveHmdaSRGp9ZM+qQbDHUxTQBcDVK8ZHyMw8rjruGmQxn/+DeQTWBq2KiDJygKulXWqccmZ0u7CUPv79gM6YoI2yL1YM/sckUUO5jKV716wycqqZkAbPELMaxJoixfrEJw3AxLHyYXszG4iEWlXclelo5eWdJpp1o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 17/20] scsi: target: Rename sbc_ops to exec_cmd_ops
Date:   Mon,  8 Aug 2022 19:04:16 -0500
Message-Id: <20220809000419.10674-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:610:59::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 969d6b0e-ac62-403a-b5c2-08da799ac5b3
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KumX07/vQr5FOAxiH1/nW0jPngObRpQgXtDp4zFP9rSNvzkHzHnTHZGFO53LkQh+s2mQnS0VqoYVz1u/mIwzy4TeA/8jwR5sIY1ZGrB/7hSF1bR2u0IpxcSMtErk4P2aQvSpIB5X5FQdDCAB/cM5sAx5L/n9jrdYmUSWCjsoDckjLStDJEMo4K/MF6P1uJs2gKzYVQqixZQcb1aLZGJ1HZUYmC/SQ+b+jS4s1BC5G0+resmPeUylXe/mYIOwpmKuJQROxWgW1hqTYqZWTvUwFTDRJfq99xqGL+I+4LaRwA0Rp6/j+RnUd8SOTN04rl3UAyOjAzg/Mn8L36ZmSfJntg7UvnSetZWUshwSx4i9xXfQsU30m1UQH7l8X/iYshOL6VNLK18VvHTLa+nFgZZ0xj1pM+OIcTD5OzevZT84Fmo7WLFyBr5LoAe1WpBz+ymWGrZRwgijK0lNQUgHVMlsRvS1je6ACiY0qfGQ1lvwDSlD8TvILnT+GI7TtyVOVjRwJvXmVHDpxDwJah/0tlnnmsalZyXCMO7UGPB4g77a82ZkLctCFvIknjhtFJZGecZUqdhJ3gCuIEjERD46l3ybx5y4ZPUAEvvZdlgflut8LLF7mQ8sjUEsp9vDeYGsQxL+RGfe1rTD8nUqP/crMbzyyRatGO5CnJOoiDT7ySnWVJFcNOeMKbtodhWZEfzehMjtZX0coyye/HeXJQBY8dgJGQteNXBvxRnZwCMVYawvMLM6xbvu4rDZUQiGacdg84LFtF7DowpZWRnUvckB7ikrpBaUc4dKxICge+HlZHXP/0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5ufcYqIpEbWVO4/sB+X9bFnDfXtMqZcd0/0s7IFVwYe6hhbTXCPTCjBOICH?=
 =?us-ascii?Q?pLcRLp+z59xCHKIyjeCfwOkh3ODAJ13q1Zh6BiLRH+XVTWiaoQMYC1Eex5u7?=
 =?us-ascii?Q?H04mySEYed7ndZpEOKVOxGtL0SsJZDsmAGsV1pdncoADv20K6CwxsUcQV5FI?=
 =?us-ascii?Q?kGhoobFNgYGU12M1yVuz8CMeXpdJ5FDL/DXrIOTZ/oZ61zUs5cKMrTBOl08K?=
 =?us-ascii?Q?zPnff8f7Zh9qwOmB4CZ2A7eRR7ZS/lIKkWLk4wfbAVzYuCPD18C7lPPQYT4i?=
 =?us-ascii?Q?E+fARyjr0phbrMLgG1AcPfI2zwfUcewuFOIbo/iHGj8fA+ge//sOLdILaOgS?=
 =?us-ascii?Q?qbxde5sYJcJK4uFGgRvPonlI+A/Mkft43KcgZBpM7C5I6EZuF8OMNvsWhQwH?=
 =?us-ascii?Q?9tiIWw+Qi9VSf6zgWp+Q3xwiyp4DkHCiITHAYcuSM6+lwlflHNrf5vvXB7OW?=
 =?us-ascii?Q?ZEJcmaU+HdHMaUbaMhjzSRN4AOePKl3K6go2Zta5Reo9rxALIkCJWE1c7NvV?=
 =?us-ascii?Q?KrkQtQM73X3xzNa8n/LyLJqQ3gikRG59QJLgST8QtS4RrkJAUbopBVWGUAK8?=
 =?us-ascii?Q?VOvZNcTasQNKDMxn35njQ0XZs2VxjFRCGQdX8ZVLhOD2jDrN+W1JpAne5Wpn?=
 =?us-ascii?Q?1HykqGuHxho9MGJw7bk1XcalIokcteOpFgaY4KUdCNBpicDoOkg5IX8VWiZA?=
 =?us-ascii?Q?lPU+PHCfO3fyOmugH7URklxdHWNAFLiEVQdMl0Fek7Q5mou1FLuHgfi0b4p0?=
 =?us-ascii?Q?LTSbqTi2YVO1lonOiDB2cSUrgpxkd3EM1PsSqH2tVKUSQzyxr9H1sVWB/Dzs?=
 =?us-ascii?Q?EVdADUgkHeFAJHSwx2PVeiAlWf2PK/6i7mRn9vYyiCDdlDBWCdVkq9Pp2Udf?=
 =?us-ascii?Q?Y1W87QSyWbV+hi0f3eDBk4pdAR/bKRtUmiST8VlCQXIGTPr87HpzV+CsUcV3?=
 =?us-ascii?Q?FRV8IMgD04FA7bP7eQzK1VAYNklvq0hqt3pAjAEuD4LB2Zp+QJyZbVpMZ4Eb?=
 =?us-ascii?Q?Nl8qVOwTFuHDKC3LC7L82giReJ8GJMYC2QfsNmhhQTKkrmabapw2GbDzKN3e?=
 =?us-ascii?Q?5yjmC4ZtUPZhU1GHOzgBCDvq4Z3UWQnOOvBzJFEf6ht4+ywb/GmxtErlP1+m?=
 =?us-ascii?Q?E5+yY9xc7lqjQdtKbF6YJ+nyQg15bCGeJUFrMfshECIOtcj2uJ/dajLxpwj8?=
 =?us-ascii?Q?FnXcCcAGsN+5p9RPqiKAVyy6xZSCPHrHF+HToaoQIaA9BYzgYRuSa6+TG+DY?=
 =?us-ascii?Q?KB2ZV918nbE4zNcrb2lnoKvjCIpK2tVSENLPzmJH1rPPZk/F/HMhPsIR6t07?=
 =?us-ascii?Q?kEM8saqBMPpt60j/Ab0bb2wtBfMPNiKzxNzvn01tGR86oc9alxPuL9SVNwQ1?=
 =?us-ascii?Q?tDj9Nz5oOClJrCMIttwI4DpfaNx//Y0WpSnhn1UkPQsQs1+TXB+G4OwRXKck?=
 =?us-ascii?Q?igS+nOdfZpKq93MCYw2b5Ry5keKbIlPabxepsmXk+7hiPoboVwvdlQeZMc7H?=
 =?us-ascii?Q?cB/liiQ55FaKaKyzfWB4X+Xh0MWytIIL8BjofucT9LZW/xB6brAMgelwOvSf?=
 =?us-ascii?Q?sgLumq2pSctLy4dYwMshBjVrCgVWRyOznzd/oadi9lM4FKLjXkoOfCo8h9Ah?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 969d6b0e-ac62-403a-b5c2-08da799ac5b3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:47.6566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiYdbz9gDXBg6M8LoaPz2BpXCiLbDNFbX8nVv3JZGb1v0mU56L1eLXhCSMqvq1+evFhQrid7xqc141j6mP9NV4e549sY0LyOAPERpY5/qlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: gxgiBdDmaUvgmjeqe_JLM9OkmoMbwc7F
X-Proofpoint-GUID: gxgiBdDmaUvgmjeqe_JLM9OkmoMbwc7F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow us to call the block layer's pr_ops from the
backends. This will require allowing the backends to hook into the cmd
processing for SPC commands, so this renames sbc_ops to a more generic
exec_cmd_ops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c    |  4 ++--
 drivers/target/target_core_iblock.c  |  4 ++--
 drivers/target/target_core_rd.c      |  4 ++--
 drivers/target/target_core_sbc.c     | 13 +++++++------
 include/target/target_core_backend.h |  4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 28aa643be5d5..8336c0e0b1db 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -903,7 +903,7 @@ static void fd_free_prot(struct se_device *dev)
 	fd_dev->fd_prot_file = NULL;
 }
 
-static struct sbc_ops fd_sbc_ops = {
+static struct exec_cmd_ops fd_exec_cmd_ops = {
 	.execute_rw		= fd_execute_rw,
 	.execute_sync_cache	= fd_execute_sync_cache,
 	.execute_write_same	= fd_execute_write_same,
@@ -913,7 +913,7 @@ static struct sbc_ops fd_sbc_ops = {
 static sense_reason_t
 fd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &fd_sbc_ops);
+	return sbc_parse_cdb(cmd, &fd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops fileio_ops = {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8351c974cee3..5db7318b4822 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -878,7 +878,7 @@ static unsigned int iblock_get_io_opt(struct se_device *dev)
 	return bdev_io_opt(bd);
 }
 
-static struct sbc_ops iblock_sbc_ops = {
+static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_rw		= iblock_execute_rw,
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
@@ -888,7 +888,7 @@ static struct sbc_ops iblock_sbc_ops = {
 static sense_reason_t
 iblock_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
+	return sbc_parse_cdb(cmd, &iblock_exec_cmd_ops);
 }
 
 static bool iblock_get_write_cache(struct se_device *dev)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6648c1c90e19..6f67cc09c2b5 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -643,14 +643,14 @@ static void rd_free_prot(struct se_device *dev)
 	rd_release_prot_space(rd_dev);
 }
 
-static struct sbc_ops rd_sbc_ops = {
+static struct exec_cmd_ops rd_exec_cmd_ops = {
 	.execute_rw		= rd_execute_rw,
 };
 
 static sense_reason_t
 rd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &rd_sbc_ops);
+	return sbc_parse_cdb(cmd, &rd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops rd_mcp_ops = {
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 1e3216de1e04..74133efda529 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -192,7 +192,7 @@ EXPORT_SYMBOL(sbc_get_write_same_sectors);
 static sense_reason_t
 sbc_execute_write_same_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
@@ -279,7 +279,8 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
+		     struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
@@ -348,7 +349,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
 static sense_reason_t
 sbc_execute_rw(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 
 	return ops->execute_rw(cmd, cmd->t_data_sg, cmd->t_data_nents,
 			       cmd->data_direction);
@@ -564,7 +565,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 static sense_reason_t
 sbc_compare_and_write(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 	int rc;
@@ -762,7 +763,7 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 }
 
 sense_reason_t
-sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
+sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
@@ -1074,7 +1075,7 @@ EXPORT_SYMBOL(sbc_get_device_type);
 static sense_reason_t
 sbc_execute_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index a3c193df25b3..c5df78959532 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -62,7 +62,7 @@ struct target_backend_ops {
 	struct configfs_attribute **tb_dev_action_attrs;
 };
 
-struct sbc_ops {
+struct exec_cmd_ops {
 	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
 				     u32, enum dma_data_direction);
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
@@ -86,7 +86,7 @@ sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
 sense_reason_t	spc_emulate_inquiry_std(struct se_cmd *, unsigned char *);
 sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
 
-sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
+sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
 u32	sbc_get_device_type(struct se_device *dev);
 sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
-- 
2.18.2

