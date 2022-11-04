Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0963EC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKDXYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiKDXX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAE56367
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KjFO4012176;
        Fri, 4 Nov 2022 23:21:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=kt5wA/4xxZoZP/V7MapBCzqtN9KBNkYaZlXCBfE5DkmZtR2jqOTuH4ded4fU5bLQPOXa
 yQrr1aZNqL7KJlOT+1t0wyfSs7c0h5gMSO3ZzBLibzAzxMdn+YwjSFsMkI7/MHQB0qZn
 rDBagnMv7YtGtQdvHp6hdR6OO72+s26DVPc62ho0WFYqyYGXsjFfCIfk7McvxaP9xDV2
 Dh6l/cDNzf8g11fWtIPwMuSNRFB5A+lGyMsF2Y+iEVqVq17g6GhD/z1bYmTP9yyMc3yF
 bNadJ84FfKpqNPkdiH7RzNTCJyCPZLUxKa3IQ5hNk6anuIo+MvkKWt/bYCm6dM7/EW95 MA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N8CA7014069;
        Fri, 4 Nov 2022 23:21:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4t9rr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSVCo/WOZB7S3v/jtx7RElJsh9hG64Havue20kV0aUwjEgNWIrhbtZjsg2ZaugT6E/PotAUsjTuEFTJcPQYxCvj6zn0CZ/DeZCzlJ7F5/X8WqxWERLdeghoJLCV1xQnSMhCjFlHbWBaxlaUgK4L20rYazD5jIv9H1NlWMGzC0n3P9qExgWDRz5GlLZcLaGAmwWT2g+7Chefs9iY7pbEVi1kSf6luv3lHFxXfNfNrsKtM9XnNIC2BqkXqFZVr2U92+RvlPa/9qxOumPphW8gZa91E4Mj0v1z9O/gCEl4l/duSxERlGr3Yn8DE4drr0/fPCFM9K2aDXkjS3inqt96HAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=BM2fQWgo7iy8nt/dCpoGrFjgjVIdpuGANNIsZ5etUNb7ALG45LoxFSte3EiqNcRUVSBK4QgluQ9YlX93+aI87ROecYva+Th2asu/yRgxIjqWch1uiVAqs/UShfkex2xDNfz0SB4fY7QZHPBoElCVZyJK1NAsqSQsPalMxLy0v9Veeg+JIhYXlsaEzkSspz13DJnKY71vE142SO/8ThereI46rvNt5iL7JTeehHIz6TIZV3NLoKcWkEUth8neQOyXLESb24kNqCiMPdDfVO2eZUC25fSqW3MZ7c4Wb8B42lK3qkeKBDHQuAmAo/mmdOCqYaJpFjvXB6XRpXrismlkKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=ibFGs6lD7HBHD0n8mwfP2EtyeWRD/T2Hkl8Gl2lqPIg9pVNisTK8yp4gHjB/t1aJ1pT76ckdaTItRB2HNWzqj7/leqHYPEv9vFBnTnkwXUP6zeGbZhw8aGP0+LDNsr4DlXC8shkIXIyrzUhK+V/he2RLbNxqrP/MnRWoEkDp/YI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 11/35] scsi: sd: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:03 -0500
Message-Id: <20221104231927.9613-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:610:b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c2e99ab-ee6c-4ecd-d971-08dabebb5413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3a3EmlhS5tEDWvdZGVBQ3sQs7e03LHWo8nhCF7kjAetjcdmBSo1zG7Hy+1RjAa6jqrDGSA+0Xcy0L531hnU4RJ824/jb2CAqjFw7FB1g4GNhmmDQqOAX/qhSUN7KxxC+ya4WHMtB4XYS0I/jJKbyridLEHsR3fSXPdvH2YQ8tQD6FmLpUVt7t0L59JRV5q8/e5hIpQwrX7QVttzQb+NZcpluLResP5kxdUDLJeVU3sESgf6jghwbL+JMoAO+ifINTAWxG5Stt80XKq8GUzJlGQ7lrEYFmUw6CTjtomy6ss0/8CPJCE64RCVRspLrV6N+mk0bxhMPW79WNafYkSoI78+gx1E6RyJgQACpWgsvWpq/1kDCg66YZx6UiYfeuugYWd+0Qp/wtZQ2x6WKE0wWZbva5aJTz59n9lM9iKL1ylLwFLThTyvIiEt5mAxOHceCqzq90vH/BfSIpWyLwB7MJ+7kRJlGH5hoMCEjXcJc7/eNzxuhv+rI9gPxKFifqaWN2rufneHY50JckZBWTkhoUyomyUvuDLwC/8+y08/NNoaYdDw+9t8QymF2c0XRHmKWoKPh1A7zrEobbWkjzX6sq1Jv5OgrBW3p3cbUrZhDcbEncvTTG6wK55eA7QbCRyYIrDXcvuLHMRPr7vULzBChOTHkk0SZ5W82ux61lIbm2/GpMo9MrSUX/EVz6b9CdLmGmzNO3AlaxkT4zA3Gqi2Emg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fu9TyjsUfe77K6+LgTFazKnBrw0msZ/KuPXWEBV0cxZtvw/IlizQ4jvWgkt+?=
 =?us-ascii?Q?LJsk4d7PT3p/v7A/kx5OjYPfupdUFNBgJ6g8rdsLbCIRo0m2mQUyGt27uZ2r?=
 =?us-ascii?Q?MIspho0S1686xPUx/hFaLvYtE97rYfg0tzf/XsecQVF82SiTsku6aAJZz/2m?=
 =?us-ascii?Q?GmzMftzH9n22aieayN0ztkeEkoVCUc/b84Z1gWu5lr4XpgIIM/MSB76MXaBW?=
 =?us-ascii?Q?mnHjM67Ktko3F+ilSD6hmyuIV5mTFqPCkn4LMjk06HR+UYjpnor8bChLOC7I?=
 =?us-ascii?Q?1hvfipzlO66PNg9PuVrw4UVO2wBoNw0HwqgD20uZhVbWygXJrw3tBQfS7F6N?=
 =?us-ascii?Q?BG5NRw9n0L55wHSymg0n1zjdyA2PD5HskIfrc4+OStvLpLThoi+2w9GpYfsD?=
 =?us-ascii?Q?qFkffxubS/fSeWex+PlNNndweD+RBb4avcYLCnwPjOFYkH8QvOZ8tBLqcx8W?=
 =?us-ascii?Q?o3IdRu2PHzHpuhqgxJZ/EtC2GRpFh0Waz370mXcahGQ5nHzuZ1+k5NgF6dSI?=
 =?us-ascii?Q?4ARH9LFJ+yh/ngWRTJ8gLRe9sg6gsv7czySn0umCkKwIgZnZvi6ct0GzZpAi?=
 =?us-ascii?Q?wPfzgatnrXXhQwrKyGDpSvBrGNpnLp8kdTDobB5dw0I5dscL/66GXRYpM+cJ?=
 =?us-ascii?Q?ylrMkMtZvcHQvOvFQzMiUvljsKuQn+0kwoh10CZuGliDWMCAd9OqSLyJLBp2?=
 =?us-ascii?Q?08dyiBQqvv6sCwuS6J4E9DlkMm8VWOv+WjMKDxLy0BaC8Sc+4PHNO4QnrfA+?=
 =?us-ascii?Q?Co/mo7tg0fpuWPEy017bgRQ5LXcY5/2EdOxWsckOUIhGSvwkeg506VVCYA/Q?=
 =?us-ascii?Q?1S5SrKPKWnzhJBzb7ohwzCsMr+Fz5VrQa7haPhftPe0rUPCo0Xf6hp/SL1c4?=
 =?us-ascii?Q?ZLEVXRkPT/aBbQrOn2d5lX5er8fXvMYe8H+8lCjPPaG2QHweJDpxvNQ6yVXn?=
 =?us-ascii?Q?mChXSP5UcuaeISe59zrIDKtdSs0SL4DV3yUSz5TOGYSfy4pkdqkV3GEWv9DC?=
 =?us-ascii?Q?nJGpKo175P4YIa/NofsaE+InfoUInc3e0RH8ilt34TUfx6X8npIv2EXt1YJo?=
 =?us-ascii?Q?UlQ4Qsrk84aRptV6p/Fi5q2zs1b5VxL1Z4tLCHkwRmZRNGR/2CNtXTV8IsLo?=
 =?us-ascii?Q?AO0joYBQ68R+UpgkH6JtMpiZtboDm5LrroDBBRoX++yD9JQEbGWg1/rWA59Z?=
 =?us-ascii?Q?iDJdgMuDejaHCpKQR1sQXeMFtp6NRWwIdMp+xCMoi/Bqe9XeK8mzROdrkz/S?=
 =?us-ascii?Q?YgPFqdU5P4dtD6fg3rKkgWndlyEsb1sk2MOqnheHRCU/+jC8waZ2lfZHO/QW?=
 =?us-ascii?Q?+iLkFQquasNWrYXmTJd36kYwNTFuNB0nioxPbzgSwBJ4fZZwo9eIAieBwbpC?=
 =?us-ascii?Q?dNCcicLXuM40y9Mz8/pgkvjI2wcOjsiyCYRc4/hLmQoOY36LYiUpS4Tqo8KG?=
 =?us-ascii?Q?zFyCn6fOEZBGRkK1aWAXoqSEf7vaE3pmrIqFiCQoT4pe6NRgdPM9BnfXqz4T?=
 =?us-ascii?Q?ArO8SzpoGZuhIWoQXd8pqYsynVzbJg5QMDzhQaSOJGXwjXxY5R61qwFBIQwn?=
 =?us-ascii?Q?KEEhjKKhf30bOdM0n06MdP7jOs12t0vAvB7t0B/EejOkYPCwebjASLZxYaVZ?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c2e99ab-ee6c-4ecd-d971-08dabebb5413
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:40.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8/erjvImHtv2ghTFedP+2zI2YyUxt2HZusnaRPdisfYG40hQwIX19vx1SWMZvsfvNMl5EMmUnQvwM68AHhm7x33izeHyDZe2ktFegAj7m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-GUID: Z99OPA9KKGziObbeJYaxN1F4y2Q19aoC
X-Proofpoint-ORIG-GUID: Z99OPA9KKGziObbeJYaxN1F4y2Q19aoC
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

