Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4458C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiJCRy3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJCRyJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775EF3D5BC
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOIcu006279;
        Mon, 3 Oct 2022 17:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PUx6rqGj9Rtobn8tQlQI4sSQVmc5HfGpS9S8mQbe93o=;
 b=kps/wElJkOyf0sCU6GFVs5z5Wy56niaKAZUSNc8EO1YnHn0GdC7LeIwIedW88KaffWJQ
 824PjR0zl3qUwZY2/1NjSImVSFcjHDvl/zziSYT6NPpxs56zdFHUPOXRe9fkJicP/YZ2
 q8w17UhTDVVJri/RvfJm83Bo5K0sj+lfjjqX23My0b6JQN49gnEldh4iRaqvnSgVqFo/
 cUrYlyG8TtrGOPXa+APnMxdZCijohfSI0ZnNJdTSZLnzwHKJy81D+bi6T/WBIeZ8TxeV
 tu85Aq72cQlI4lg1xohVHR/QhimvYjjObNQi2LMQiwgwsx4COfhe3+Skyh0sfepD/oj3 3g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xl015519;
        Mon, 3 Oct 2022 17:53:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxY0i7gTTJNv+OIEvLqT4OJk7oYQijzMoIi7wsGi4UQPFYZ25PideLe9NLUDmIbhfqcHhUCxPY3y/V9nuBvCX4jaIQICmesvrbUaM96gd/uj7vA8qKknMVKLFwSKCptqcmadem9Wrv39OAvkJIlRKzRyPc/0SyDpAzAbkrpeEAPCm7+kCSViNdGp4BaS0zoq+/XWEfViG5z6neL/2XQ8cn7tfiRrr5ofgwGgKGHGxR03Wb+w3VL62mYduOBvXeLbI41qzbcZIZMZh4bpl3xGK/3YDzTKRazHPHYInw4O7D/tZPzAwsmzJXWeyPCFFqN4P+bfvIP8EggliScN1Z0l4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUx6rqGj9Rtobn8tQlQI4sSQVmc5HfGpS9S8mQbe93o=;
 b=nNyE7jcXF9PC3y+I2nCc/9p9w9Gl8hSvPsWUuaHMhJxnKCyTnmVBSmnRcO+UeF/doVSI1pLoBRxKZUovzgfFNNWkPuul/cKIKwRBrrdbu/+ciSGcUwUrBt45tn9YCZqw6VHjl2dh+Q40lCgrxyVxbdhZRBL1uhtVbvwpFA4e7NM4FBfZvFZsc6mtrMbwMyAV5PAXr3C3IsX4Adf62DBVGF1ztcAVHKPefGAcxmliKpZoN6aTM+KF/lARmaQxxNEr/3BhDV4AAkj9SzWxQvSt6uLazrsB+pUX9NJDANUhmSHFV2v5Dk5lD3x9Z/DLUSqb4RxVQbfFXJQMrh9ySW3IWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUx6rqGj9Rtobn8tQlQI4sSQVmc5HfGpS9S8mQbe93o=;
 b=WWM0k/Ox3dDq52u8kqt5UqyedY030Yp1dQqkdxRceln1w5tbfLQoGeYMv5zzxU85bxIu32Baoj2Zkb7SXa/Bxs5/U7yfXye3YkdtOjQq4d/9SNv3+YYpw1DJuo1ba0y0JVZdiAJF3sZ8PPAOzw0Fdl2kfVJTCcVC0gsxy7E469c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 09/35] scsi: core: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:55 -0500
Message-Id: <20221003175321.8040-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:610:59::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 09213e44-4779-4073-fdf6-08daa56832b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z69DugpGxTeplIznFUD5sHp/0Z1HR2Ru2P9tX0wanH87mCdXF2jdJngaTacmDInWv5V3UYuu2Sx/Pdw5hrUczBkDQiVsk2yjGcPRIYky8zqfk0HJB2TTFDjP+Fz9IgjhoXfBwFiOvd/G1aC25tRD659w2QokATjS36M5dOD53/VqE7HxqooDwhCei0CNPh9GN70fWbCIl4xJZF9ictO194udGy88rbo3Aau9Z+QoLePrfp1MN9Gw20QhgCr7ZM1md9ZXag/mCafI2Tg7Sd13TKJDrbLQYOzrkjKoMJt5luZd17rLzokhXi/YNWfFUxQq+eL8QXmFnGRgiy8VhxLdv29z8jiC2qT6L4vdiIrYYN9IGnsMxqWV1CHDEwMafb9y3xRc+SyVBtXvSHK2WG7gqg28OmCqio6C8So/th3aztdCZ6iNDRnrEX+sCvsRJGzfYQtvEWae6qi9mMlfheGvz78Li+DyApBx+OBemsCYt+yzxCBke7u6n8j98RrDMDFy6aOYK8S0rJTue0nmMnYfAPYT13FfG23xlK4iZnb+WgXN+g449fHirfhOQA++8qB5XquTviaBjmx64Xh1/HvrUkIzIrok29VmjpidiyBuBvfj/Ct2ehB9xbwYmh9P5hhwaVlHdFMaEL+q+OcaaVr6hSsH53CYvNhN/TEJ+j7uJlO6SO0xKXor05LyvjN8Z3A0AAQPyZAS+heXgtbPg9ykhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1owXNJqhIVbpSMtdwfj7o1wzpEoBRlRbwToWI+kbwWURzyYQYw79YPj95v4J?=
 =?us-ascii?Q?xQ3l5KcyzihIP/XVzalUtag8InSdfaaJ0Vd/IEtpYYAZh62ExpboQyuN3t1I?=
 =?us-ascii?Q?E3WFwavqFVuyQcIcNlIg2dzTmtqdKFOaiyDEfWC657ZUntP0xSX+ecRiFmqI?=
 =?us-ascii?Q?9CHyOTybq1mGAwypaNbwsHOCRfu6LlIHTQdxA9RZet8MqdvHqt9H64ssoQIc?=
 =?us-ascii?Q?Hj9pXrLzwHfBpI3m0YPaBYpNiSgU8vSgSeeNd02j+GNwMMmozGXscCikxNk+?=
 =?us-ascii?Q?WCLAEuHghcDKcx1QzFtmNXpo2mUmDje8o4Feypen41mV1fvCA5Q9ybs4HtYS?=
 =?us-ascii?Q?om7+c3uYYFlfC9nHB13wdDS4k7BYKVVW9WSeELC4NSQW5F87vUeWGC609hUZ?=
 =?us-ascii?Q?hukoNHbh6UIPOVIBp4omIMii+tCV59RF+lHOdswR4CRJGilU0gGYHI8ttdTs?=
 =?us-ascii?Q?Ln1BPkcWoua5Uf/0631N/6kGvPr9GK/9BIxIqQYry/kEBO2jbRDlbwmgmWEg?=
 =?us-ascii?Q?Bkm0t05mzvWeBf655nuZZJyqOSFoniM8RPNkNPOqwX3aJxoavW8p5J18ML9F?=
 =?us-ascii?Q?3Cziu2eETsXooKjGZTWvqAPPX7CkuCxPexGCIB6ONh2s3CPfOabrsEbrfuKj?=
 =?us-ascii?Q?A0jr2wijTbMXd3W/gKYuO41mKxd2R4G7lmWQgK3byLoPH4sY1UzN5miNZwdl?=
 =?us-ascii?Q?1n1Mv2sQMgZqegs7kZ+RY+grIdXqSi/OEZZ/OQ3YuiUCf23GU1Rq4FbXG5Ai?=
 =?us-ascii?Q?Lv5HfWMwarEjRW17a8GGTOBNXQh21GvK5Sl2JE5x1og2+NDOVKJU34p5Bs4D?=
 =?us-ascii?Q?RVt3LCArwXgUQJA+TbVM1fRbMO1m4Vc8uvnSQH+lIZKw0O+6bwMIB/5mDlNj?=
 =?us-ascii?Q?P9JownLjWBmZJUBBqMIG59k+V//q3jY4yFXm9TyFZjyL3NuI+bQ/fvHCYoZ9?=
 =?us-ascii?Q?mveKbh/9LazD5abRIr7o9IZHpW74md2vh1TxUFVxamqXIsrecCAjTxy1sgvn?=
 =?us-ascii?Q?GhUt7kqJKBnJu9VZvpc3qJbkEknOkvRpxWRdUaBa3Ou8ANAb8prWjfwEjnpq?=
 =?us-ascii?Q?gW6sm4P42aZ3U+Z2F48yJXLjhi9FPtkgC2S5rFA9oJtXTFi6FzJuCO870ujp?=
 =?us-ascii?Q?hUOFVpxclY7aEBC6I5QqI6m1fgxo0QUQxeF1sCPTcJssbchFzbZ9MhfkpDdV?=
 =?us-ascii?Q?4zla84dA8dqWabZw8+elQd+4sORzB7VH2eFFwzc45WHgWJ2NfNmQLeyKjmiR?=
 =?us-ascii?Q?KJ5dQMKJpdQIwEXoTAnnjGjPWgSRF0xGqE75HHye+RUntCZP5AQo3WR5TdbC?=
 =?us-ascii?Q?UCCmUS/lUwf4sGD07ZAGH9xtECicqjGVaxF4rGsQeeXEty17nAhGxHA/M8RJ?=
 =?us-ascii?Q?Z4o++S/O8UMtW/4AgvyowFhkOt3S6LWxZylS2N4bIy7Q6/ThgV65DvJ9AexE?=
 =?us-ascii?Q?roPKw2NUUf5who9uHcSw+thNoA1uNmf+80GBQwKFlrRvEhiACfzvRWvYHr3o?=
 =?us-ascii?Q?XFwwXokykxzMo5PEbzdfd2GVQFEA/V5kem1Z4SaX99msMfYW/P/Lz5UqAsG/?=
 =?us-ascii?Q?ov5zodyqQuyzk/GgeyvedCFv2pglPoVNb64NIh9JPxOOWGLjYidOkcZeAfnB?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09213e44-4779-4073-fdf6-08daa56832b1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:37.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FuOycf+7sBr/k9OyN7HQtwFtYx9CnBiBZkFwMXbz26qnZXmMyUGJV37pbOnOUh+3DUGRnvvbHagCAJIlJ99V/15a2WtNkv0jkHZJIiesjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: RGYUFNYkDG1BTc7BT9Q3ZU2hPnU6a_OP
X-Proofpoint-ORIG-GUID: RGYUFNYkDG1BTc7BT9Q3ZU2hPnU6a_OP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi.c       | 21 +++++++++++++++++----
 drivers/scsi/scsi_ioctl.c |  9 +++++++--
 drivers/scsi/scsi_lib.c   | 31 +++++++++++++++++++++++++------
 drivers/scsi/scsi_scan.c  | 37 ++++++++++++++++++++++++++++---------
 4 files changed, 77 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..8d8090c8fb05 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,14 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 	if (result)
 		return -EIO;
 
@@ -531,8 +537,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = request_len,
+					.sshdr = &sshdr,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 
 	if (result < 0)
 		return result;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 729e309e6034..5708af4485bb 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -73,8 +73,13 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 685f2245d222..2f36b65fe0f1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2123,8 +2123,15 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = real_buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	kfree(real_buffer);
 	return ret;
 }
@@ -2188,8 +2195,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	if (result < 0)
 		return result;
 
@@ -2273,8 +2287,13 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = sshdr,
+						.timeout = timeout,
+						.retries = 1 }));
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..58edd5d641f8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,8 +210,14 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+	scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = scsi_cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = result,
+				.buf_len = 0x2a,
+				.timeout = SCSI_TIMEOUT,
+				.retries = 3 }));
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -674,10 +680,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
-					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = try_inquiry_len,
+						.sshdr = &sshdr,
+						.timeout = HZ / 2 +
+							HZ * scsi_inq_timeout,
+						.retries = 3,
+						.resid = &resid }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1477,9 +1490,15 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = lun_data,
+						.buf_len = length,
+						.sshdr = &sshdr,
+						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+						.retries = 3 }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

