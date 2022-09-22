Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87DDC6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiIVKH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiIVKHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4182D5759
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA40fc009734;
        Thu, 22 Sep 2022 10:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=xP7YpwjuYKhp48rG4vVdS1mG9aFQPipMGXTLYzeIBrg=;
 b=F1xhuhgkjpP6lihW6LBg2LDz3uypD7HlLC+HjxIOQN9wVxulp0I/kMU3wJW7vKhyQgRB
 07BSBrwwmo+fhvjdExfxazB0JkczfjwM5SUxReJNA68lC/T3EFmIKkLG1ntwj6ZIUq0+
 hIkJbSCz20EInxhEhvWUFDY+5DssiTWR3s65u5lOeg+cTe9qfNOd9iP06Dg8x9zt/5Sm
 M3WFodYd7RFVpCsDsckkYoZqWL8X9i7Ck/J+orITX9yE0rLc0ra41RBvmr6HZjkUZHzk
 9zqa9PdgVXk/UvaaHI2MfellYBadldpfhcE5bplUHRJDqqEXFZ/e4DsAn2ZcoHxF8Bdg BQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688mgp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l36W001239;
        Thu, 22 Sep 2022 10:07:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cb3frc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ctm6lEhTQWSo6JkaFGhVbOH3txrNeWfapcPt2oVtbjVx0lkUYVGi5WwJ6NisyRp41bhE5u3Uq/dJ22HuHDm62etn4ekQM68QxJ+fvjFZDZleqH4AMAqTkERpU0Kl9nYCkcjPRN3Y4qpxEdm1e0ANJ5zXW4rZCJF8EyLqgpM0i6Tea1zi6s/s7QSw8RcXKxb6OQjF5j51nYqQlviGiAxComRHrX9IT7F69h6vCSW+BTVD32geeQsHYEdIlzrl2VtZKfYmRfQAlV0VyewVopO2T/t3sFW+hbLEDs3L4bQ4oyl5E3ghyFY1fP+VH1+ul2LUUjITR4vR43Nio+fxH7U0wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xP7YpwjuYKhp48rG4vVdS1mG9aFQPipMGXTLYzeIBrg=;
 b=hPW+ySYHcFQA4P3wgfy3QMJV/axN5YlCC78SWFChKwDcmPKKZGOz2SIu0gTJA6IN6GWg72eUv1/VG8W/AGSAxgU1uFgtdVEyxhFP+46bTz2zwPep+46QpjZJOV8xn83nSXukDOsWBJbqbldT1l0OIwtVrhy2tm+i6vqYqGUjXLE13TekKfs2xDpp0FpfmMzkJWTY4P5jeoZ/iiR4Wg4Vn4gsjg1LvkDysT9oz1PYpqwYk+/pHL25GguiicN+acB2y+iwhCNBqk7iVGM5EBr73SOowH2urVCPxhJ43yMlemlyQgmaDbQrKk8wCjuxPNBVpPdpnb+ewtOArlv4HFgEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xP7YpwjuYKhp48rG4vVdS1mG9aFQPipMGXTLYzeIBrg=;
 b=F78rGpyJO+KD6Ht/R4rY0039NFh0nkNKsWdGYxkEfe31CiU/X7FVAz3dQCqsa1ojB7TbZpFGbJHyizqteghPni5UsFUl0Rm2kH9crHo+mEdnpsJ4ApJFyC+Pn4fwfuHmw2qIQY3eeBO/lWeGQJwHiJ7Ugd+Q+4CYNKQkx/upniw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 08/22] scsi: cxlflash: Have scsi-ml retry read_cap16 errors
Date:   Thu, 22 Sep 2022 05:06:50 -0500
Message-Id: <20220922100704.753666-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dfdcd0a-3efa-4a28-f634-08da9c823c70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0iSL9Qq0AwDd+GldEevdkOGs1/mh8RzzR3bs9rHEgYH0RafvOPi/p0HNm8XqbvtnzI5JMui9iUh9C9DfI4LH6VHo4Ykqg0mi5mEWFMvvLUWD1UuvDXPbLSSI+b+TKJR74IP6qiPIDZjB4usxI5IsrfjD2Xr21rdp/yn3qdza7LMmxB3LiU+t4pN/3fcrA0Mu2VSvOV+J8Yy0Y6NTXag7BJnyYoMQZ94ITtAs5LcMqRxPH9/FEM7SV5toTlkvFbP4VqT6s2ROcJMjGiC5iXi1zQSAKyTHcdIXWV/WHalAzKK4U6pDVDUfQCd+FEOHxH0kCep9KH8C642Up8gSrNIiD4FfWwttnUGv1aoJRA0f4Y8Uw4klT5w3iXj3jCcpGYqbuaFyboU6QuA6v0E0XURpv89+63/xn5q8RnKqLBLJkC/6ysEmZULYeAgBOK2G5b3JchH4m5xDHra9pAxFnhVjXdlHS0KSgQTizhCE/cKGG/mMhvs9GmluSk1rD/S07w5Uetifybk8329i4F7hW49VPr8Zh4101PG/a6ST98qnQRTRFrHMKX9Un7zkzd8i9jNTX3+yh/baMkGnKgC8RKhVcmX/o9NRBh/kqtvS6om60TwHiJ7BFIHS6Z6Dzy/v2wCjBPhuB8uGIJQgYLUk4wCzoAzGcLhtzaG2TpSJknwXO/Fs1QWNmVVe+Y41K9WlGLHiLt2nzMn/FIfDXWmZ/b+F8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BRSPpA24aBg6Z/LXXO2z35A2wFk6PxZpPma2TyPfNJY8Yfh2VTRGy70SovIQ?=
 =?us-ascii?Q?3qpxvFDwqbhXfQS282Lv/xSrIRiOdJG1R8HFZmQBoPzjvWh8+Y1SSdasdk9C?=
 =?us-ascii?Q?O7g+gbUHbGG0E8MRgCS3te5Afq2/5910pNWCR0PCa4L0EuSDWsyafhX9M28f?=
 =?us-ascii?Q?gwPidt5oevGQsEYwj+fgeb9SgZgKAb8zqLBxP9pPDJ6r6IHeASLTYOdlr72t?=
 =?us-ascii?Q?bYHcrPAYxJ3XvCL5g2kbQqp9uBanxbOVZdBzVNjwNGFrQHMFegP2bo+eoZbG?=
 =?us-ascii?Q?RH2vbYxPQGHR+Aiq7pKopXmI0J1bwQn4aOA4TvfL2uk3HEgf34Y5u/gIBFhR?=
 =?us-ascii?Q?bFq3CMGT97acDBndfmDULeg6ISA6k17xSvx0XVRUan9MIDf5zIP3QSXd5JwX?=
 =?us-ascii?Q?9PWKnNWZGb/AgBfkBqVI3/XGiU2krozXJ0dDxCxcDH6p5QpnGgtHPdUepXfj?=
 =?us-ascii?Q?zvDc0VxyUK/iO34DJVzjTpQhSTLIuEf6hA6DkXOPY8RyO5aLmPWs8subsBzL?=
 =?us-ascii?Q?tKZA1s0SL8Kn3+twkCVpiWbncLB2bVXU6UWdQfArrsfD5wCj3Fmswf7O7Iba?=
 =?us-ascii?Q?Cw/BHcvYqs/oYR7DS+RbQtwvtzE8vhCygkbymhC3WO/qOqZjkDQBQ8V0JUF4?=
 =?us-ascii?Q?VwNWBDYF4pcTupgVqsynlJ9R9mFKlY3+V+BjzhzZDlZwXWv3CZUVXxj3d9ea?=
 =?us-ascii?Q?dP+qCpYE80KyAmFEbmp4+ZfdXJ/eAckjgX7gfPa7Q/qQBLvVRrPuZ4C/1HmK?=
 =?us-ascii?Q?r4AZ/XGYDDLRZO0ABZjSb71RJM5B57kGhLGaWmmw5HIIQZo6sQOK36Q28a9D?=
 =?us-ascii?Q?Pj3Aq0iFpP7XEDG2hugquYoJCXkh4x7HySUTpIk7eKjCIgWRTYs7O+aPMRhT?=
 =?us-ascii?Q?TC5lEh3kF88eqRxbzm9nQHa5wvPZmPPzMsnP3lKrL+yEMX0JRKMwMe50XseQ?=
 =?us-ascii?Q?0xDYoMRoQBrCobwHkKvSkv4kFnPuanJBHHhdyt7zFM4tdFS6UOplZbUcl8hv?=
 =?us-ascii?Q?wrfoJxhbSDXsa2/HoJ7EYYU3ME+iXrC0R00q3KVqXLdD2qubOVieqcg/sEdM?=
 =?us-ascii?Q?9Rxn8Am4tbc09pglLMjeDO6kUcx5eN8rNm2jd7rJRrLBtf6og2/JPK4QysUK?=
 =?us-ascii?Q?VZi/xFdRzXfXzEfyUtfqNiWxx5Jw1DDUTNSDLdPJYhgeXyBeHX8LAnpL4yxN?=
 =?us-ascii?Q?ExIM4tUjBduj4iTHXCrknqfMXAwWO6XYgMCCgtXEUNhJ17V3rEW5F6lvpgZr?=
 =?us-ascii?Q?mKPLgO8T10wA//HGT8lVDD0oAKvFPXkzF8CwNePTeVffMc3sHLK/M+niI8GS?=
 =?us-ascii?Q?4gObU9Ms4kFVN87KqysTwk1/cN0R7QBYAFcRi9TTKY+sjO30vu1qDk03cLuN?=
 =?us-ascii?Q?4DPiamPG3D/keyCYZ5sCkMPVb8vKJ5gnPcBaiakVSK8u8H/u+sy30Yfsovco?=
 =?us-ascii?Q?Cl8aeIBFj+QKlwLxnJTI4VjQBZLhfY9v7fm6tuQ48pb5NEAvrE15IRzfTvzG?=
 =?us-ascii?Q?2RceJFSnVliquN89U7yFgPpwLrqJCYnhXM1nK6LWd9v4yp9N/RyG8QNM92jw?=
 =?us-ascii?Q?iqLKcOXSuFEvT+XzTjYD8/dzwgz2zdJOCcX25dlxjBW+qacmRhcM3Wb+065u?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfdcd0a-3efa-4a28-f634-08da9c823c70
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:20.1157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LcphL7VY60g4TKMncmbD9nCYiRwC/iL/n0RNU2oEt+ZE1p5HYz7SLAKZ+BvTBTxHGKPQRch7X7eniDnav6XVRm3ISVHLbUSrgzsmpOi/Mjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: POEc-tk92GLrKFy7_wCu0kbrO3_vSyLu
X-Proofpoint-ORIG-GUID: POEc-tk92GLrKFy7_wCu0kbrO3_vSyLu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_cap16 have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/superpipe.c | 45 ++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index cc1a63986bff..ddb9a8f29141 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -337,10 +337,32 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
 	int result = 0;
-	int retry_cnt = 0;
 	u32 to = CMD_TIMEOUT * HZ;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x2A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3F,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
 	if (unlikely(!cmd_buf || !scsi_cmd)) {
@@ -352,14 +374,13 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
 	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
 
-	dev_dbg(dev, "%s: %ssending cmd(%02x)\n", __func__,
-		retry_cnt ? "re" : "", scsi_cmd[0]);
+	dev_dbg(dev, "%s: sending cmd(%02x)\n", __func__, scsi_cmd[0]);
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
 			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL, NULL);
+			      0, 0, NULL, failures);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
@@ -377,20 +398,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 			case NOT_READY:
 				result &= ~SAM_STAT_CHECK_CONDITION;
 				break;
-			case UNIT_ATTENTION:
-				switch (sshdr.asc) {
-				case 0x29: /* Power on Reset or Device Reset */
-					fallthrough;
-				case 0x2A: /* Device capacity changed */
-				case 0x3F: /* Report LUNs changed */
-					/* Retry the command once more */
-					if (retry_cnt++ < 1) {
-						kfree(cmd_buf);
-						kfree(scsi_cmd);
-						goto retry;
-					}
-				}
-				break;
 			default:
 				break;
 			}
-- 
2.25.1

