Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB9FC6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiIVKJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiIVKJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:09:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8BD5765
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:09:26 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA4uj5018946;
        Thu, 22 Sep 2022 10:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vff8kZJ3mfbyoUL5w5hdhU0XGj9rfn/7U2SDHyD2g0Q=;
 b=L4lFt0r0mgTXSLLyz2Js3CaH/gJSKBMfQSr4dBdrpkLCUVX5y+V547vF5qxlutjHpe1E
 1NoasvnPnHkTv5d6xFBfxN5wbVOvOo2BupLOoKnW1NHa0axQgREZOJUUSWkNl5MTdiUJ
 hFvDOh88vTiUoC3N8gRgBwrl+AYM4DtK7VYE1/nwkBUycCg1IeX50ArWumm4oiRi7dUu
 2R0GkpeYIrJgHB9aXF1kXphjn7omfi10TVTgF3caX8dMmUF490KcZrz4PAS0P02i6PHR
 UzTvc5FLFfdOMSQ3IKA5WRpWMHcCL3F0QjfsDnZ/vXQEj/C1iSAu/ta92np0lZKmJL+A +Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stnaj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3kV001244;
        Thu, 22 Sep 2022 10:07:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cb3fpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KevBMq6sgkJIRZF7V3yoB+rIdt0i2tFr/7VlBc9rKRvQ/CvCbgKRNcXWkWsJokOY9qy3AK6S04IupLyQE8dnnRfAd7l2sd8RdS+RKiZrg+vqh4h4ylP6sKuC0GCTaV/A6eNwwwqm6B7HJKuOlorJIhKGnWaPZ+MLlTYccpOmzTSqGAZ05Pn7FR4/7TJ5hsAKto/9fpZQ8a6J8YrMe+TYDItPKW6FW4KcGRm624hb9u0FYxgh1oIz2jfOZcxFc0yVA/oy7wBbmmJLoxb7wabQm4hdtgSGipqUXUnE6tkt0jV22XLcKiaK8SsHEyjmQ9ad0H8FGxqY13G/S0CclcaPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vff8kZJ3mfbyoUL5w5hdhU0XGj9rfn/7U2SDHyD2g0Q=;
 b=gT2LqGvuK/Y0nKmLC/Z5NqzJdmPMWPSnc603BYEJy8Lq6lHvcM3JYyXvE6llLedWqbk/oE1uCYgF7L5a0AetEgxsUhSvyyPJ49LfwPulWzRqCM/W1Uye4Ss+3oZC0ahpqJHFSZaBHnEOxJJwdN4kPny42jpTCklmEHGwwrlL+RRYdNTJ0eQOw7dOMeje9IcUNigfuIHwC30dOz+TKVFlgII19BKOxuVqeomLOMfMGKdVZXw4ZlQlAPnc9jWsM/XB3tO69ktRnV5PyQh6uu5MgQQLt08srlkpUgXVl1Lg07IjvmCi6sWvGeXAW56IWkwoCgsj2heVFqjOHPz+xzOnvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vff8kZJ3mfbyoUL5w5hdhU0XGj9rfn/7U2SDHyD2g0Q=;
 b=bLcKm81+cTt9Rg9uXBz6Ik6aqKNJmeMSG4tuv4J7QWBV5dtxhEMkz8LE/xXrIviaYxRLEjIERp+/+Hyc11ELircSgC+O+i4vNLxFAVmCkAikY4XOf0z+s0ZNIDmPEfH0Brz1y6xGefb1AmaAwTtkVEM6DzpNbyujDgvsrb+Iqvs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 06/22] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Thu, 22 Sep 2022 05:06:48 -0500
Message-Id: <20220922100704.753666-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0028.namprd05.prod.outlook.com (2603:10b6:610::41)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a952f88-dc24-4b5a-b758-08da9c823a5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tV2xw3T5MAdjkkMt7ehD6XFVKGPOIGEtnE6nYKJ+NP2Lnio6D0VdL9BqUctqjKGLXQZ88qI/T5duNJldnNfls0/zEml8PnVs1absYPU/GyyLAytpzkCAzBq20daIMhS31wzokXaBK4TG+c68w/e7QlZHIAuRWFGZJxxHlG4jI0j28/LCu8ZyKTSR3lCiXRH0Gii7t9KtB88U1QYeW0SFz9VwL3BFOY+aTD4r6c43yTXIferc+1JXkYkEZ97xhv8gEVAr0z+uLFbtvo6qtCEUPUJgjNTuVCjsqqEKkiT1b10d/nVnHL9iOrC1pCfaOn2EPhuv2F5EGScaTt0NAVo41LbJY+z5xhsOpqXTo+emEQ2oP6w1pwqZcGDVoiF8jMub/dZCLlwaeqkCfjQfjeBj745sY4ALHA/d8EHPsD5RP7d28sqrsHC1P7XdxYmjgQM8VOOdYxyPBW8Vu91tr3UooW/LPRR5YBHxSMbjal7sCrqgDKqUrkJsylAoybKOChE2P7/MJ1BDJTgsn7vJ2OC7GAoXzs/AoJKwFKV7WXC2eLxNHotBha3VSmYjNknfyNj4Oji8ZNPowZFeMa/DE7cfz7tcTk0dQMMZuM8Jaff5ptEQPZIvEpaiUlDHhA7vp5/7CNsAnJzgPmuAkL3vOFvoDli4UQMFbNpd3xvJAtsQpiqlayPUHpZayyKgK142ObNU50MIrXrG7p+iFLIMxG6k3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RQVcmNUrd8K3joVEh01QRucTdlXWAjGz3StP+Lzbvh863onqEF6PosaNB980?=
 =?us-ascii?Q?9dz55Ry0pYVZ8AZcTQO0vKjD9ReIUkVRkPsPGNYaaQNwCRIijUHR+ezqgF9u?=
 =?us-ascii?Q?qGslGYXBs7EVo0nRUqOVNUmJKj+p3mDK8PvTsD39DlFYrp5w7zpBeG6sAHjo?=
 =?us-ascii?Q?xV5jx0jqehYl1kkf1+/ETt9jRqlv5GCjQ58Fa4K1AuYCsqrWSmhT6hWA+nJI?=
 =?us-ascii?Q?FPFwsjzgOFPtbmtAqpLbCLCwh6sriAtLkmqzW31/qYOnwgiKOvatEP3nAjvL?=
 =?us-ascii?Q?AxHDcimg6+2PVskT01hSYQb47NOIHEDLyUnmVWdW7nwb9nZqIVxD0CVwzucp?=
 =?us-ascii?Q?KszRV+5TK82CGeHmR5KJu71PLpfCPg7HpxivXpufCTJeXFE+QsIMzsJrPU7H?=
 =?us-ascii?Q?TA+P1Lx9JcQqHEzLE33T/dcdukEGADZUtnaUn62DtA2E/GNnIO+Y4Zfv6uMp?=
 =?us-ascii?Q?uskaOkuQPSlZBrEZ15k6nQ0gnCyHWYel54Wg6j7o356DVLN1SiFd0jyEciLK?=
 =?us-ascii?Q?C+eJZAxgLN8AvKqHIgb8ldDpueEMtKad+YnVIw7uu65UcmJA4QJF4jxlR9Wc?=
 =?us-ascii?Q?WqFC3UbiqmIobb065pwn/LwFmhks849gEboX0jYHlM9grh8BnWX0q0GvN+B9?=
 =?us-ascii?Q?7++tkGCNrwcRFi+cfB7SLjLsnTUFvAqimiVi7wYiuT/pmEBoZ3nnL7h8SRrB?=
 =?us-ascii?Q?suy1LeySTunZAksxXY9wInB+KllsowHgpceetsyUeY61dH/PWkDtUPcCGPPi?=
 =?us-ascii?Q?SgCNcoFjog5tc+TxS6oRNue6hucLv57LCffRm7orcShtOoWCRDgJBIPHPlFc?=
 =?us-ascii?Q?5NUlUaqerA3aWNZ4skfYbMnhKQJ9TwvNE2Gu0iA9thfMRtM3CtOJg4E9I8B7?=
 =?us-ascii?Q?e9aOmBpn6iZT3dzMqCg+mc2kWFdwgs/4dfB+G/HgCzTJ7WBkxIuBVJ+9cDjx?=
 =?us-ascii?Q?dBEPkPN4nWwCfsQA7PdOT9TAXW/LZdGvoWRpJ9Hvi/jn6Lk26GervnxOtwmK?=
 =?us-ascii?Q?QVi2bZN34lSiP4y+7ENwA2IHWHSwMcVRsbs4Y2ybdaQIIP4ZdNPvOAbbexV+?=
 =?us-ascii?Q?qJPzYgU6V4Yk6LHZDSi2M/3wvYQkuIyiYa/V9N5XFMUYS+DsoxhGjVWGquCo?=
 =?us-ascii?Q?Y5rXqifhkDQl+gjxXNXq/nwl8PveRFCCrBdhCgRdimSpUqinfAotWjWAuKRO?=
 =?us-ascii?Q?KC+lTi/ivIfWB2rAlZLXAO+OCKHcTb5jUrMLKwLi7pWMFVMSfZCg4H+ZE5kS?=
 =?us-ascii?Q?DcC0hbr7rwCJmlnBmwdHXlWE7dZo9910Yz95tEDPH1142FFkDa5iIl6UBkPQ?=
 =?us-ascii?Q?sHTuln1Ko7m1RzfZhGzpL2x3afHoBwWO0xZ0Y29Ls+73uuXoICjPH2lu2HGq?=
 =?us-ascii?Q?jvijA6/we5vzLD1xjJwlufcrvUO4MNYkaQukQVdb4FjlEeZNRw/DMH6+gAps?=
 =?us-ascii?Q?E8s+bXLN+s73PgTKwykhGc6hjMDagsZmxJxRnzpLdtU64F44N7kIOnhAbrhk?=
 =?us-ascii?Q?38NVKlhnzNOgYqw+BuY+lPVughSoeiOURV9dPmBSBa0Yg5FPJDmMSz3UuMV1?=
 =?us-ascii?Q?1LtW515i6PpkqaQgVK+4/CIu7TYvVIkm07SRf9I/upo3rlTBA70pKFXUkg2x?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a952f88-dc24-4b5a-b758-08da9c823a5f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:16.6629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9V+UADoFr394MtiFXZFX1xhkUhJIII8v+55kJZJpCVkdMwBv08ewcAUp4smHEe6IXbbF+CEstTlWsSqhxEr86xaL3zB9HTQXkc0qRIiGey4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: YXi2FQRcAwwigFww_BX1biTpvnTZftx4
X-Proofpoint-ORIG-GUID: YXi2FQRcAwwigFww_BX1biTpvnTZftx4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 70 ++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c215da95fb8f..46383b680893 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2259,50 +2259,52 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL,
-					NULL);
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_READ_CAPACITY_16;
+	cmd[13] = RC16_LEN;
+	memset(buffer, 0, RC16_LEN);
 
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE, buffer,
+				      RC16_LEN, &sshdr, SD_TIMEOUT,
+				      sdkp->max_retries, NULL, failures);
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		    sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

