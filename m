Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1ACC04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiJWDHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJWDGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E021642D2
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2ssKx014061;
        Sun, 23 Oct 2022 03:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CXUz2yZLTeZd2IGr7kDd+IYyEIT9Z5E7aRKgFVaRZhk=;
 b=gyF7M+AKh8aPXM77Hf5nZe3OdjSnbOZPmsDRiFVlAH1C7LAbDl95GINmpXuZHclVr0Hd
 JSZtGyCFc+vdui5p9zeyE5/4HaMeH1IAupKr0VbM5FMniGL83U06j0bjSx7Wy66k9syN
 AkGtzEvlibUaIovGgb8Ympou/9GudgETL6Upm7sXVjJG1NYSaVy3agaNIB//1ycUs6af
 xBOBmw0AC6IdnVg1oPHWEwJCQHTBYGFQ+5+S/TMuZr+A5SdVH6IfPveR/uBbFy4IhhyH
 03/gossuaJQpiZJ4eyoCUjXWxydoDhB6nTNz5+gK3zw9RcbNJFHiq4zzmgFVeQhxT0z4 OA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJq0gd030706;
        Sun, 23 Oct 2022 03:04:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2ryxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHtr8eTqTKiipJ/0Z3brTZPQhcPzO9O02dy5t5+PglH4Y1eJn1x0vlBwOrus+Sg35ZA0NS/bC/IlSLhl7XXq1IZZJJKk5pPA9OYcdfWiGkOIr0i/rVoNs2Jw0sXwWv68zoeVeTHaQ0sVVkx1CoZYjSa0FTezuFnicPE3iHeGDYk3SfiyYLFkRbPVRuUwjq2+jGD4uYQYApGAbpeEAHu+sCr95F5x23Y1rlD0YttYA01NtmK+o6/KnkWxa4icbkU3TvafB3fY8P5DZ9gOBfE/Y3dgPjhFC27rK1d8vPTsXsHtV+z/OmJkEQdmBZb2mvgKMD/b25yCrz1TXKCiUHZnHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXUz2yZLTeZd2IGr7kDd+IYyEIT9Z5E7aRKgFVaRZhk=;
 b=Y/xIl9Y/781taNHrJ1/tN7Y53uBdTmGPgz0MlJ5op8l9Q0g01qGIGHnzGBsRNpnFHWscQSP6lbfZGUWqJcOtbvA9AxgOEGy//drsMvkYbyO/dxBiy6mF+Duc3Qyo8W+d0vz8XEvseE5I5ATQXKpeyd4cJqZ2y7jlmbwq85SqYugFzPwOnRmLFyMTV9cIZBamoM1FZOr81FWMEKSsHCfqiI+NztlBMCLIYnipDvJ9riS7VcWWDZJhNpVia2WV+6qcXoIAqqfWWNSPs6xYUSG+pN+i1PsIpoagZ1Qxx9/EiYu9Um4xjZXXUFuVMqXQbf7At6ZFDin8csbTHRSlPoWGcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXUz2yZLTeZd2IGr7kDd+IYyEIT9Z5E7aRKgFVaRZhk=;
 b=BZXv3EHWdz9TD1Zq1aJ5T5VzoqKlHfjcu3ZpPp2tTxHS8ZNySY0RvnWMX4OtNHcGNZvVpErdQyhDA34Iv3slgBZEuLHsC4SzuA1UAPuQ1SUOvdQvslAE9pjasn2xwMNMmcsM6JiY/NXllqkn7drz6Wr03VUvPGQy39m+8efrc08=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 09/35] scsi: core: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:37 -0500
Message-Id: <20221023030403.33845-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:610:51::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f01e87-de51-45ef-3d7f-08dab4a347d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHUDO5GIH7wW5c89jZDDChpa6Cb5s9LRpsRzHzYOk1u3MdBj8k8yOwk8RDg/uZZpq5NW5mxZjph4ji+7m46k5BEqCBsL76jE7bZZ8FdeKn8qQdOfVyokH9cGnr7FTq6D0gR45cO/KhbV/3QF8a3n5tMVq79+HrmGcyrZ8lZbq5lvkid2xZCLX2j9308/5vgNbtPCI5wZfj5frwG7ggCU9/B2fAnht13ZWc6AaXyLDAl3T74+5uKmFGj4ouMdPgZ6ZqwfE/cAVW2kIWZL3+rQmSjvXC4/jS0A8OZ8/45AkTFkLsqatZVZ6Uj1wr4X9RICKiUZmuStadJs3dndMK2nwOsCxIqtUCtm92SpiUEtvtU/uMizUXTe0pPysouh8fVHwKVSFWKcALGdyTZs8949Lhv7zpCd/fakqI4ngO5uPXSzYgiHchpqzKDuHYgbLn2RJur0O0LhrAeyvCRidolnfmiyufz46FdfyU31eHFdHqcq69ZrM4BWWNl/sWk9hrPwqiap9/na2AlvFprul8t2D27fIfoK9y0Nb/a6bvgci69+NeSEtJCo3R4AbXrwBz4Wpm6fohdEjvF1knccjs+fTNhOvwbfgbMRo331qYnOcxifFd4yT4GqHtY7HoZ4ESvFBH3/MRe3qj8DOtuCyV8Cgna9n029eObE9ZD7CFXzFAPB9k1Zcus4Ww5jjTHEznSWxyy/Q3jGqBfPzkrqbz+roA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ggJbsfTwGBIiHBwV0ZRJTCj/NO7rbRX8zG9AuAbNwfCWshXag+LAhwiS3Iiq?=
 =?us-ascii?Q?WyLYsXUyt5J8hoMQTi745Xlm/HanIvk1c31lx73ee7j6x50VM3yAPmcmKxeT?=
 =?us-ascii?Q?xLR37TMfPOJ5Ymh7gpLDdddxAYpgxDDt324tqpuAU1o8zirghJqSwNgSFEvi?=
 =?us-ascii?Q?4jGJArzTSkmjoJZdxlym0KAiRMJsTxWmPvmBVvfMa7KoaY2CF69mKexdndtS?=
 =?us-ascii?Q?dtpolW5ZXcF+BDI4K3uqdY24Tav3L5ySG0DIqqEt8gnotyUadW0cK1yohK7s?=
 =?us-ascii?Q?JuT4OtNszGbMHM2iqwcqKQELLcAv+zaxXrtvjvwfJWsnMUzCtM74dQsnEfv5?=
 =?us-ascii?Q?aZLdnNv7UfRVUBNajcXD+fhwI4gINSn8vo7zH8BfpW2P8P+1UV95OmsdHl/2?=
 =?us-ascii?Q?MJ/GQuJvJIdmN1/2q5G219SnwrL9GkxzWwFQUtheQ2W4mD1hNQ20h001Ku67?=
 =?us-ascii?Q?jikG5MZiTe2gm0JpQKLMWn3b3+RVLCtLQM6TWrJspdBphsSOCUWoPAeYwLI7?=
 =?us-ascii?Q?hGY5EG3+3mos/heg45UK0YYBHGCeJqDCOR2YxlVIOj2d+KALplxAtj+n2E1b?=
 =?us-ascii?Q?mR5JP7ILmbiggm7NHZeAlS5rCINPF8PKmx0NLYj+oCbOEOVdcACJEjbDpKS5?=
 =?us-ascii?Q?GQemLLAOTDwfA7KktOQD8xDWq2sXOdDF0Rg16uGQB0SGABqqhL16+bDJqC/Q?=
 =?us-ascii?Q?V3SskMp4OjNgi73SrdjDlF9msTEIM/x83ERQkxEyAgUDNo5CF//pd0CwQXb4?=
 =?us-ascii?Q?slyEmxNbd+mxGI9FO+oUvJklXBetoKq0zId93vZ11sZDiqG2vK7MLGtZP0mz?=
 =?us-ascii?Q?51JZZuv5Fwn4Yv/gnGR6G+0Em/y8oP17UtuHhsvasMvTopQrCjHNlmmGLe76?=
 =?us-ascii?Q?jxJWH071ypOvh4N+uWO2kbWY8WA95yzgUB/aFl9R0+dsHEYdieTQ7sIGiMgv?=
 =?us-ascii?Q?HpL6YFyR5UzSbl8yFOsW2AINe1Go/YFl3co9nEGV7UqMSdzfs2BVcnBo7xZ1?=
 =?us-ascii?Q?MB4HfLMNjUj/G0s54GVxZfu+tyTM7HRxJdxdmopOEQdllomNj8mvmHcungjN?=
 =?us-ascii?Q?epmF4E5JQRrhS6WUC1Czt3vOq0+h0cdyEA6iTNYHmOUNFlg4WsBGM8fRGQlL?=
 =?us-ascii?Q?qOOuB9AS3F419kFi+0pCSy2QJHgrY8Ph2bRZrnis87kgrq2qrdIgRW7p/TXY?=
 =?us-ascii?Q?RllxQCH0rWYB1N2u+MRvte1busvoP+yDe6ke7y48RNIfVRTktxsZuFg+DK6j?=
 =?us-ascii?Q?26Jiht8e0+80h2f5/FD+o8hoT25uChNdFkHT2eHCxy6UaFtVSBnk4lNOScYp?=
 =?us-ascii?Q?wfMp2eaBOqz8mx5ihj1IpXf6Zaea8WYig/sD8G7tFw9xB1wfLaidC+yyQDSa?=
 =?us-ascii?Q?nMwcSjE+0GtKL9hUH/dSH3sW1ayEj3zlLIT4myS4eAnWfoozCr55E/HfMmV8?=
 =?us-ascii?Q?smmYxeuEzjFeWxUfqL2tNiM4iVC4FYw3sBLUdy99YrqAhq4WaphUKNw/DkgQ?=
 =?us-ascii?Q?bEI8MI7s8CaBv9I3xdcYB49Fev58yFB2yiIFisQNHoOqP+UI7X2tI8blf4Dl?=
 =?us-ascii?Q?wEpd9ozDwvSrnl6SGyQX5/I1u5z31dEwZ/WRcV7oYBA2/DgJYZt2OJQL1j+V?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f01e87-de51-45ef-3d7f-08dab4a347d8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:20.6712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrSa6azX4Tw3yGif95cchn/t0+YylP3qkzxQuCk59F4Q5Yzojv/TD7uH/qjS9310pCU1lyWf43FW9Jr+orTrBWp/6dT3+hb6bWoE27ZQeKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: sVp2JmLHTnrxII9BsuGYEGMXVokbOTec
X-Proofpoint-ORIG-GUID: sVp2JmLHTnrxII9BsuGYEGMXVokbOTec
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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
index 2d20da55fb64..67f291cb0042 100644
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
index 0ad0e476f2cf..e9b19fa939eb 100644
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

