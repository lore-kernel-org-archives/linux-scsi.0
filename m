Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF650C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLNXuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLNXuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:50:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8255B43854
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:50:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwnkf026698;
        Wed, 14 Dec 2022 23:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=t1+yz0HnVE9Q8IIwHFqzvAu/rq3h/1oTObmdxTCS/FQ=;
 b=wKSKqNP53X+SqyB1bHvhade+eYWvaislgOvehIWxlRPidfEe5p09DhYbml/y42joyk1t
 MB81/EyxVTBGOKTYZ/+l42ycdN/1bYW5TBMquC5ZQCKzzfXmxtkA5mHfHJOCOhEfzbTo
 61ouX3OTOyZliCLhg6RX9xL6wM+N+16nTqv55Rjy0mrNaL07M5xO3xcnXEHxHtur9WZK
 f9svNEOBA2D0eRUoftoRX/anfX4czqWjurNnJIhidJFIF5hWhdPxeRgnJIf619+53Jth
 v6g8drv2FGTn+R6vi+3E4+e9v+++BQVCz62kWPdxH5Kp7PyBqpkftywkY08l/QSMbC8n PA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeruq5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BENF41H025499;
        Wed, 14 Dec 2022 23:50:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyen35j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Apncv6m3Zgw0dBxuks/pxjqKpXtoDgkAD2j1GmNRHItieHfKCunIkNpYzcNsPVifh0tWj+yCHTO/7k2RurcoA2L1ZW9BLsk0S0c8AEAZZ9m4dsGyKPMCxfD017VjrEI4nAUZc3CPQTthyy2fbV6CphiFEtc+rTJUzsTtDWYScwzbAaFwaRGxWMhknLf7fBoIE8UfVFSP3t1d/4aRyWkKLDFhs5hmH3a4yajk9wKK7gTkqoW6wfgC0n/Izs9baTcLGFFuYhds/UOrWNSf2v2VY5Xu84ZlMbjFIVQ1AzLc+LPsWTg/d4B1BpCajg3T36AusYjJ95XnMdcnQueGaMpvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1+yz0HnVE9Q8IIwHFqzvAu/rq3h/1oTObmdxTCS/FQ=;
 b=QRDOF8j6sbE/sYRcbWpOuIVaI1LPDyZxx8ENEsvlqyqkpt9GzO7L4X7mtQmJGz42z6tg8Hb7iHSLkTRXRw5htaCwZ7kfTCYx2VKooIFqNQBMDv/CTQfdNYkEqOeHtnZSHUntIqh9Dra8QlG3/iTHA2U/f6PMpXI/dnda9zEu8T0ZbBDTM7Ar2Oj5jvMXM87fX8mKw96MdEFFRHZn1zfo25DU9dldZH2OZB7/KdJaWp12gt1KofhxdhbwVP70kDPWZZVNsY5vnrm0LDkpfmHQuSVixYIMYaCpCKc4jICDbJ6cbYfb8tTIkhNlDVM/B4LXpA4GmMXPvQeeS+jGzfauCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1+yz0HnVE9Q8IIwHFqzvAu/rq3h/1oTObmdxTCS/FQ=;
 b=zQu3oMb+1Rl9H2dhso/erBV3a9g6hzxsqF0vMWNB7clr3L9zb1Xsy4nTIFPKer4epfE0gvnfdueokQ3jNOGnu9RhQBcANpMSktd7U1BUmp4cJe4zqP5Ot3eymkPYdDB0vgOF5AkUKEYMQBzJJtr6/gZdIY4P2DmTyVFTZH6CIkQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 03/15] hwmon: drivetemp: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:49 -0600
Message-Id: <20221214235001.57267-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:610:4d::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f8e713e-5629-4844-3e1b-08dade2deee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtjTNEHmZnp5RyvCliUnp3Q0ljUld00C/Z6Mjvm4ZAD7TY0DE88CHQBOcexvrEK1XgnUR81npXcHJ/HgeygVprUT/dCZtIm7Ww8EvmCf1C82G7F8A6h7UUzUEQA3bcxCi7TminMKtRwUEMZjMQQUopxXlkhWYlX6PUuQLkA17KohoJG8gXlPXf6aZO+lZhvdgetV5L9KizoaeQ/NjMKWkPC9WqUwUzAwC36r4HfXpjTIEPRuWibTTAGXGiJ8p/V+zGHDh3NR5+zXWq18QTcLN9AsQHHDrNWKg8ubiK3ctzmjUNn6LSgLQRVpL4MgMweA1pRYqLciUOLalLj0lDE1dVhLBnVyks68BVw6Cp1TqYLEhKKDBQGflmxaoQnwq5EkZnvlVideLk681I9YJOtg6PtpJejn/TCpjtvdHK71p7q3aF3EP7abIBBr5+vYLK1bYKhSm9Ps8gocX/gtYEmaxkg02AKfjKDhjED1Zsgt6HSndr3FG8HWtz/b7GNQFo8xVHYSWfr8byG4fhdizTXhrH3ClE3yqMdbtnLmkERwbS+6JioZ+pGdZiyK3PClWuIDTdCExLk/Wz4z8WaT9swPSO/482FiddxrIGWcE70uwdOBj6/m9CDFkq2MnYStSChRBIj9x0JrkZC7D/QUtQwi9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z8W2cEBn7XAprGLr4Tnd6PMfPZOTPXKIKkqCBbUGy1tcXBWmoaftJddyp1ip?=
 =?us-ascii?Q?KNjpMqRSoNZexUJVy3BoKUkX4yGu+q9k3I5ivfXAGdP7F2o2JeTJewHIig6I?=
 =?us-ascii?Q?H7V9cO6GBiPcrgCztDCIoaBJL1gdGhm1XtHs/I0qJ2Kgz3bbBVKhgt6vNNJ1?=
 =?us-ascii?Q?s7mGZXYo9U9QPjxgakDJIVOX2dMDuVR4XLJDSYd373n6jxI/dygj0UnkLjTJ?=
 =?us-ascii?Q?GiCpRmb7ZMAnKojpGELMZD2JnodzMfkExru2phc81awMOjfXW12iPLONaFu0?=
 =?us-ascii?Q?1MV6go7lGHGBD/2G4jjcsrjB4iNRLFtbC1TvGSJzlKffJCCVNOsIM0lLC/8W?=
 =?us-ascii?Q?pnvysO9zaZZMQikCXkYThJxXsO7VS0HDNEs8CTvFY8OiWkPR6sCYa/mWF4Z4?=
 =?us-ascii?Q?p3vfien8dfBlpmsONyHVWxBGi304U5S61d401Nk6BfhyZKe4KvD9YuXFt78w?=
 =?us-ascii?Q?3o/G9riGYEt9gQR1ryFiNxdykpSJ1CoKoF5x3i3Iv1DHGM+pMUte5EsZa2hG?=
 =?us-ascii?Q?TTx2SVSJyp4Ep+G3VE+N4BMm9/vCw75Vj5AJIwPck97Vnly3ED619TcHjdnP?=
 =?us-ascii?Q?tXJpQGIGF5FSzlBVxjIa7rlGqU+H9jHtILTUiNOz9One+sRTYTgLTdAOAp9l?=
 =?us-ascii?Q?yDYkqfwkxjV3BKEusHKfZJfuJbxPdnFDZQogzjhpiEyt3ag4CUFFDieTEjep?=
 =?us-ascii?Q?so2TC8tHXUG+vMgQJgbP9NCt3dNSRjB4GSvI/yw3YIIX47F8pSvHDI8fHOs8?=
 =?us-ascii?Q?c7i5ZRHOaBQ0gvIrFkJhX8sGqtEmgh09tAWCN+KhfKyER9pZivEV+H+YNBW+?=
 =?us-ascii?Q?JMmuPqQgi0hKgdobA08TAuD26m+rZ42+c5IaS0oIpSJtUm2ygeHdqEBdu50B?=
 =?us-ascii?Q?fzGoeI5XrCbHV2MTEyzBKJ16Acw5QaIURHjIlKGUPHd7HWhJMRULv2Up9we2?=
 =?us-ascii?Q?IounxrTtMLHln7REuoLAAB0sfY318Qi7vgTn/6jHXZGlCPPZknpDGf3hNUBU?=
 =?us-ascii?Q?zGWMRkscuMka8kx6B6vjslTZSSFHG5X9uRYURwHPHxODutkuTWzjqnET/qxt?=
 =?us-ascii?Q?btmdCbysCDEBxR7v/ugwHApNYByC4e1MSP8ti71wcTBsSwk2sLCKZ+HcpvtO?=
 =?us-ascii?Q?0YL7WXlufzwcDkG7ZBa/nTI2V4lnFUFzipyx62cfOgyw1Ji8wVY0fcMkMtMZ?=
 =?us-ascii?Q?TC10o5EYN3yaaGTwr9QtRpBdj2AbKDChbhk03vWVbYOoQ8CnGLvdjFYLP4aA?=
 =?us-ascii?Q?6+OiSUrX9o+cJx7ID9bQ8PuhLlPAEY9ZvS6Atvkiiufk5Ha3vLq9/wvVOIQy?=
 =?us-ascii?Q?0uPmvJ+cW/n6xIryV+SHZfyOA/qYtMvUNGCZePQpeTu5zEdquoAuIUL2t3P/?=
 =?us-ascii?Q?W4IZyXX9v10r9YrHJvybkDxAaCQ/1QqpQTSIQ1JWtvF8FgkWh4XRzJIw+bLi?=
 =?us-ascii?Q?3JQZ0J/kyGCo86ogRgeNYL8FVUstYCwc8U68sX8RRWrZUD3wgSnAbPuRcaeN?=
 =?us-ascii?Q?AjOXb+BEtgSwHbHJqB0JLkKzTWz1KvlIgbB2NKMd5S4sYAxuhQmwGvBTYZg9?=
 =?us-ascii?Q?bEV+b54LRp0AC+3B1mmVJFnkD4YUZCrh0GqJtl2SFj67Fd1/PZaRdVdUuW0f?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8e713e-5629-4844-3e1b-08dade2deee9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:09.0441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tu7xAwBFOQdQ3UjuvpD83PeeKnmww1OFrZTMSDYYGhQz37ZJa2xAMZ/v9eZJre+YxRZqjcZOuD7UMXwIXlok9iTVsI4L8cV2ZBbXDU42MI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: _pUuc1UnwXQIqAb3J7U7_MbFlu64N1mz
X-Proofpoint-GUID: _pUuc1UnwXQIqAb3J7U7_MbFlu64N1mz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert drivetemp to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/hwmon/drivetemp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..8e5759b42390 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -164,7 +164,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 				 u8 lba_low, u8 lba_mid, u8 lba_high)
 {
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	int data_dir;
+	enum req_op op;
 
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0] = ATA_16;
@@ -175,7 +175,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 		 * field.
 		 */
 		scsi_cmd[2] = 0x06;
-		data_dir = DMA_TO_DEVICE;
+		op = REQ_OP_DRV_OUT;
 	} else {
 		scsi_cmd[1] = (4 << 1);	/* PIO Data-in */
 		/*
@@ -183,7 +183,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 		 * field.
 		 */
 		scsi_cmd[2] = 0x0e;
-		data_dir = DMA_FROM_DEVICE;
+		op = REQ_OP_DRV_IN;
 	}
 	scsi_cmd[4] = feature;
 	scsi_cmd[6] = 1;	/* 1 sector */
@@ -192,9 +192,8 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
+				ATA_SECT_SIZE, HZ, 5, NULL);
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

