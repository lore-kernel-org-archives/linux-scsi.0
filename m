Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2293C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLNXwp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLNXwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ACB167F3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:36 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMxC96008159;
        Wed, 14 Dec 2022 23:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=REIguuBRZqH0yEqM5RkwJAsUBscBGAoRYxxKBR1+QEw=;
 b=R8CxZo5OMl0eALW/QEOlwXrJhXPZYWXi0UlLpPqP4p1t+EFZ0CDubhNK4J0AvEnbc2T0
 n00JjTV+xPtBA6UvG8rJG8VleovuN8rsQBR882nyzjjfWvTFXnKypydB7hfmykX4HkCY
 cASg9SWh8Hv08TvRjSn2DLHYSC/Ch6FttQ+uzubVI1Zsc2u8oldh9eQhpfIvxqO15NAH
 kpdqKiqq2BZKkhCkLziaR+FjnflHRQEchmbrdd1kOxGwCCdVUlIoxQ6NNaMTbDQK5/S9
 VweCy9K1NMWis+LDCHuuXSqAw8k8XM7yOE3XQeUwFKO03i40Vcokp0U7fLI+YH8jif9S 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex3qtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BENOWuu007273;
        Wed, 14 Dec 2022 23:50:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqkkv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLgW3osab35f6f+4Acr1TqA3Ql5lAFSmM+K6YOBhpfF5I1DX3fshOCbDEgcdUTixOPgJ/CytiJ2Z9P0C7vpnKajsMKOypfJ2n6RmlvzvBfzMneN4zsgSzvGwRuTqcY6I3guUgM0QhwvULendeK9QMWPxdyMnegwHZ/sp2pxgJA2JXCTzZK1vujMPk+EpDLdmsYzImLHTBA9EMvDs7fRuWUgFyebI5VAApZwJ88OJhg9RT8n8J5BRWh7W35YUNzctNVihfwPdi6FFfS3lUZaMf4Tn087PwTKXjU1HOqRb+XmNEjTbwqKCoTWCI5s9RQzLnwDKpST/1nkzEj1ACJHUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REIguuBRZqH0yEqM5RkwJAsUBscBGAoRYxxKBR1+QEw=;
 b=X2cUNOarz2iizC3NFgVP3f8H3eGhMHaTOmhLKAlKjEQyqEVewHYSmWmFTumLPM/9L0r9vk3XwhqfLTDmRFOmY5xQnGyepX8ncjEcViOWFYY+LwvzAu01u/J8cKBjhbg66qWPssEe8OIU0PVgHiLanMPU351XqEyUtBPDyJMO8U+DFgH7apJ1GppFj+f2nIiCyAc1jvdxPM/LdbfTeaYfCYxRPxOyfXF6VEZn/w09i0qHpj42DSQzCEyY8htEP+GbKnouvmsb4aqc0oF2mK7gR4HscZVC5A1zrKjOc4EAXnzMnpUl3BInVrhg2x2anATPaFKD4PSXs7q4jaFI1Wyy7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REIguuBRZqH0yEqM5RkwJAsUBscBGAoRYxxKBR1+QEw=;
 b=Wp5/MTeQo0uYZWI1YvGtd8zrYzU35Whw43P/fcjWJbZU9MiAXYL5MtykdAGviudOA9iJY25cDJ6tk8NwpkQwf97Y8RpBphmkUdG/NG5c5C+rUz6hgBit+Gobqy+AiCRo4hioWyC7x4c/YVbnkPZPuoGeTLwJHu3fgFFSNgB+H7Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:58 -0600
Message-Id: <20221214235001.57267-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:610:5a::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 36e18053-6582-43d9-8a98-08dade2df71d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZ/ZnCZtnrm5wMX6O7OzBextSYUqNRJ3DmOXNEIK7hzLeqPmdNHha6DDpmYayLFUcJ3US4LpXQ0Bv3izNbsyrtAdu9kZRR+ttz3sSgGNFtxNXzcNQC/ESw+w3dNjEDs3TQV7lWN4nLbBRwBp5usBs6rsHgTES5VP69uSu9MR8V75TD5ceBVLGmCshkxyncMxFy0sGh0xFcWOJkVE2hj2asYu9Xc1NImwzX4GdmYKhT+UZn3H9ueZuAoa1wIWNh/xcPk2Q9UlEIHMsODOgHq5G2qpK3UCsJU2V9ghbtVyzsXyR7t4DHXctSb+s1c+zIMsj81+7ImulF8/J4LvgMJ7pihTxdNg4l0Uc4m4duNOGxnS858o7m0EKDnqSyjdmSOzm/VpDwAKP64OK62NECP7iFh3z/ZQloXvWxNv7A1h9jx1pYTSOTDUU6x5iBcDDIJZ0+StDeXdK27C13tv8W1XiA48Ke3JYj+cgDRo1XnjvBJRsRoWWYmQUb1aOCQZtNc7UDhqD0okp2UFiN7PVdJZZFp5OULebTqnHTXHZ731gdsvwQXAls7FJmi10jm3gKQlsHE8u0qzYJI1q2DuCOde+AALdwRbAm48R8S0UgQb80HOx1G2KfBVUTcXE2tvmdVP1tCyDHY5fkzc7WEqLYodvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(4744005)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dFTqxvK1ux9LYrbD3CbXbkNhnKYThn8NqZKxparpxpfAwtiRjCLz0DOzej2n?=
 =?us-ascii?Q?7/bJZoyS7G0th2Nd8XE7TPClN1tNFllT4ym0vq82X3yzw46kyKszUa2i8OGz?=
 =?us-ascii?Q?ln5IUAwm519+cTYWeRc03N3CqBkwJgbwULDqc6ykhttCN+SRfO2GdCiYcGua?=
 =?us-ascii?Q?FdoB3KeyJ8WjHCTTrGnYzRz4IOXCfmOILeyaHawESCkFdZvi9nPTrPEG3WhC?=
 =?us-ascii?Q?pfnyyyOJfDSWFNgfdRCxppzG2kofsBDY6w/WnXBLUrMaHAbFj9Cc0z1s6bQA?=
 =?us-ascii?Q?B9r7a6p7Vq7aHN/GFycFsrlhDI2rT8hk8vS0Gem1Y704jSEPQVW542yoB0WZ?=
 =?us-ascii?Q?bbe+r3T7Knuc93ibqi8LlG1WyRvS4NEGQVPkwR8a2msQdVUxluPdpwxw8YnR?=
 =?us-ascii?Q?KSWUnkI7p2onQghq1u1QsMb23nT1JJYQU4jmh42xsmfNujY7aLnv945YWM2Z?=
 =?us-ascii?Q?rNNzlLTmdRwWosmdLFKfl3CHJuOUnF/gy0kYEXXpBCUKIU/RuLrwpugsVc55?=
 =?us-ascii?Q?02GcGfNAHnjbeauTaOGczurgE5JFqiWnCAYFO5FpIsm5PsKW1JNCgy53phBb?=
 =?us-ascii?Q?a0JYDj6/bO5YcTtAaFfoPYGAYMNTBdFjhbfSptKnH6/R9ZtOTnhpnkontDLJ?=
 =?us-ascii?Q?hnkOOgjbF5jOfJT/h+eP4Aa5y7Rp6N0p2EJD3KdW+aH4TgPI7LzUabNR6kkG?=
 =?us-ascii?Q?LNNMaSEkNMChhYhg5bS1zjftaLgLMnXeUsvdmUQ6cwJ15kLez9pxMB64wDOT?=
 =?us-ascii?Q?sepJ4e7z/p/pCFsb/zVjZWVm/TqYeXiZ0OGvEBHTuAm/QLwJ4/NPzO0ns84T?=
 =?us-ascii?Q?3ttM1G2wO856yL6OFgDLbDcpB4XYrkNhn6I4vgDWS2Qz5too3yhxHio0sMIo?=
 =?us-ascii?Q?/DWAByF+xGtTZuCWtiDB4LRNHus6DewLZwblA7VWhYo9DEWAX+UxYx+7Ru48?=
 =?us-ascii?Q?nIRM+LyNHyn73sYvE9aoWm9PuMXzojZ+YfBfSQF1RWlEYRXbL4luEbWwrLhe?=
 =?us-ascii?Q?zMUAMQL8w6jIYwFmZ6kQZzZ1qukCU27G8cj8QaoANjaUNBC5rHvPXzBgu6ff?=
 =?us-ascii?Q?M+nDoxmE4fv+6eQtPXS6Tl7JtqfVVWi82knwK/xPDB3GzVVDpVshmd/LxotB?=
 =?us-ascii?Q?sHi3n3MmPjxyzJ5R6+6fS/D9E5kURosQs5RL+002vnDaqZXMAF6163LAHAYq?=
 =?us-ascii?Q?0VrovGjplqxC6Y4KpoEk/C4+35OGleRVkMISYl8mfGRRJy3dm6+CS8rErln1?=
 =?us-ascii?Q?CbvbK4lqITiGcSjNz4jkABQhXOVjs5CN96rSBfdskUK09aK8coj7WId+zFZS?=
 =?us-ascii?Q?7ZKnXpQMhFXPWMmjoD7rPClYCdvnU9Gxih3qr7rGw3lm3BPN7NN529ETu21l?=
 =?us-ascii?Q?rLa/yBkTXQj7t7vYig33ChyYRIPSiSUBQlMQXduB0XIbvAtrOuM7q5ikSNFh?=
 =?us-ascii?Q?VXBaLMrvR6K5LRc8PDPHVYTdMwyNUP02fobo5dZHv9Z9IOIQ6IH9PQZWKOJI?=
 =?us-ascii?Q?VO+kfr61tmng7YN5aJ8+ZLD6W9aQOazRp2X32kpkoTHHYoZ/tgOBWm28bf9O?=
 =?us-ascii?Q?fQQ0xhZVUGIT/1dfhNwplnfvIz7UyqQ9Dlt2DgGkqb5fVj5Nmt1n+ZHqBpie?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e18053-6582-43d9-8a98-08dade2df71d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:22.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+/QSBn/dxkRj8CYEjV7DNM4ZUPTMImyDTzab3g3IEsLYRU5JKYwy6IgXdNMtwvPIPPda5LQAogW4lCgEGE0dp8jBtl33tMf1UdOaXqErzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-GUID: Cb2Une2_JoPkEu2kmD_cm0slLszgtplz
X-Proofpoint-ORIG-GUID: Cb2Une2_JoPkEu2kmD_cm0slLszgtplz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert virtio_scsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d07d24c06b54..b221c3c99320 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,8 +347,8 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					  inq_result, inquiry_len,
 					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
 		if (result == 0 && inq_result[0] >> 5) {
-- 
2.25.1

