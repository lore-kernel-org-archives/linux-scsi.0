Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17D9C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiI2C4j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiI2C4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:56:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1A46339
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TN0f011051;
        Thu, 29 Sep 2022 02:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZA1DWgd0PzD3Epr978f06v/7fC8LzDKvh51xDRQpsnE=;
 b=iONOHmHx3vd6Awmesr3SPIm4vqBQhnwuQ72YHbCODK+5edljcUFeLOgI8vCMBrzX4ESL
 Hu/0C50plXZ4RgzFoP5WR1bHl3ybikiVIbN3A5ierh2mD6CI9SJGO5eezhwaoVs12DXk
 n5zCZl1mIF7WNe1W0nmQqqE9z/K1rjlH3G+TNeMz7D33BhxiCwQQHPG3Je6k/SGfgWJE
 6MWgCKEbONqnmF+TgwUTEIknX8nc8hZHMEceuC0Uga3+/ufzCn7XhTrGO6f04FnOOOh7
 lJ7+KlfJhfJKkcCI/H2JpMpy6HAXvrQzYDYxBYlMQtqN+txXDd0o+k5rRIwZjs33fuvA xA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0ku9m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1Ylew039394;
        Thu, 29 Sep 2022 02:54:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpq9jc24-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngdyN97nqtmQ+VvjRTEaIUWNZMGmvBBma3K4UsibNJ/vSoMUkir+1wc0R+qYkZox1fh/mmIAgvhIm4TVfxvAXUpj5YkdE2i4fBMF+CxK9bYONX2Ow7scgUiytNjYqOFNWBEm84VHG/d2D4b9uczPhmJshx7Lsy8VFwlkgXO/fIAdu789HJZESXm9LakmFaGz9jmOIC93nGa3ivwFWRxpw47faauKAL3cuH2mwV/UKUqloPFuyRMCZ+ZH4szNEFeK1ORBTWIe/y3vTsDHDMlHbSqyCyroCVZyBn34dzRfhwHS0XH9GU1c2QueRsryrrkUCxg1cOa/aHNgNqfKi1UYsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZA1DWgd0PzD3Epr978f06v/7fC8LzDKvh51xDRQpsnE=;
 b=KMNNfkcrCMRF3KOEwv8rm6n2hKb8RZ8IXAAxXClBPyIWYtN0F8cKg4JCCctAQmJ0crs9yG59F67/1xCqjXCajVSuv2GR2vb22XPoSoCT/F9FXKvIx06dDhiWT0sCy9R7rWmAEBIB66x3bO6loDQa1V+BFiLTl0CSzTrPq9WxeYpxKhgEixwWD8rLg8N1IyGDqnRCwquBHTey9DmXxQhXHuoFdlwIQX/wumKGj60LLWE+yjNniSrj6snRUrMx6t/J3OCQWzzo57N+lqQpq71wi7xevmj9Pnu7Q6SLXZkRZg8D7xUYNrIhOOzeyWAfsKhfETBb6QRdPvQnROAxJbUXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA1DWgd0PzD3Epr978f06v/7fC8LzDKvh51xDRQpsnE=;
 b=eF5eRK+klpFg1TKRjaBpFjf725VMrt0sSSa3sIVA9r/NL/tvx3/EN0m9u97jbaFaKynHpNEVe7zCovM44IHeCSplAla0nJ+uhloQ3JMpmbCVyNdTaiGQa2sfs08bDdxFBLsIEek4IyulTrKzxyIH8XdXJUx4tqAtJEG7LOTUtT8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/35] scsi: Add helper to prep sense during error handling
Date:   Wed, 28 Sep 2022 21:53:33 -0500
Message-Id: <20220929025407.119804-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0050.namprd07.prod.outlook.com
 (2603:10b6:610:5b::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: b43bbed7-fa4b-4672-0db4-08daa1c5e438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faaw3snCRdVmIa1bxgpAaODiC9YVxgbJpCUEVKYyUzkokxuzlT6x4JUZYWjEHlKVOEVBsKF5ccY8wKTTGut46g2JtFqbY6t3wxbh6J/j4Uf6n+EX0JiSRm/oAFQOMoqLIGYg6oz64dUABH1fAhF9dJRJOivMsXPP3MYEO0M1CWX+o0RxYGsL4rbp8KfpYO1MYD8bgtp3sty8x0Z22XExUXrHnf6QAqRfvN/nkxhH0LUOuA5XZRXMrs3AYWVN/T/Sq3tzO72Huqm0n3JJ70jagdk4B/4IBRNILuy2zbmSOX4EpU8ypw+f4dLocAgiHaSPOe6XbhM56SBaB7NK2mM5nqq+80QSdz7wMbuDRo0Wy89upa3/2YyX1/ByeeboqRUecFKqzYlB4ThkIQftU/Bty5/a9XLivdNw+BJJEddwMw9IB8ir/Wsem19XfwHl5RPd/ykdjIuMNpEXMLMQgZ4UUvc0tZBRqZnUUzINMors/smt7NZHbBGZfrq32+y2eACBgguua5LEoAr6gQQjCz9uQPVwVFT2UUVyZDAYPUo8BoRAG1bKLKnFliYPQ0klU+zqgg+cqdvfzEf8jo8qec/JUWs49bcbar6QXotibUrXtFutZa7ehSiudrf2pglUbasVDzOgvIHf6QnzTcpyO60iELJDKO9aow7NeN3L0lWMhX/qfzlDABYQSkFoTZoWvzuf5/NVF3VriObqg1x6WhBQsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DiXB0pbDmHUTjqWkimWsRksFHTBGsK1hg3Ae8y/Ef984NXnJ6SMMt6S9pJ3s?=
 =?us-ascii?Q?5PP9rqhq0A06qTIgsAFcTFNO2MNELB3+ZnFF1Xaa8knuK/l8oPXvI3T1Xvjp?=
 =?us-ascii?Q?kL68ODe/KT1zsapAb1Rq1j9kyxRFTbZb1jJ1FTTqOXzPwtZjKhz47+1J/ewX?=
 =?us-ascii?Q?j/c33zvFxz1McI3AcOIdPaiVDBV/skMCOPRqi5PAwsen5T9ZBNJyqVZTUM9Z?=
 =?us-ascii?Q?vxdYlPa/+qee/oVDeMvEvlE4Stalhyqa8aAtEtIR/J4WSWIcbI9Ii8SB0VBl?=
 =?us-ascii?Q?fRvrLy/Z2EFSfQfhK8/VY2W3/AqYLZgT0/Fmn+HuqguQGGOJkWXbHVmdHMBH?=
 =?us-ascii?Q?gKuqhjqi25HYVFca916bLGw4Pcqim9hcLC7cZnSWSmMrj+3InG+vVUrI4i0f?=
 =?us-ascii?Q?wF9KyJFAOm08zXTXqQceRzcNd5QbXCqBsRkKSQEoFVEnLaRW31w7s1xuOr/h?=
 =?us-ascii?Q?JEeuFEiKh6tUmfCkHN8L8o2IAukd1Bo1Rs/2gfRXF99QqKlMpIET1MT10/HW?=
 =?us-ascii?Q?XVZlq2ezNuadc+YgPPH6h9b2wWOhRtw3+9MQM4OrxFJG1Q59QiYgD50YVO4y?=
 =?us-ascii?Q?ko7wFPGyzDmYYxIGM7QH9aZzzLxfJBIhWKLzoRcal9cS5z0U+yLP/LT81pYu?=
 =?us-ascii?Q?k0KGFQRKIjqJ9jO2IudsyyEFhXTIMR8bMQM2xkBH2xka+CWHXPkQV8+LJpW0?=
 =?us-ascii?Q?Wdy3MBJV20xDtyzCUK53mszCZUGpm2mxg29o0gbvxBKx+7SgSMx3uE9l195S?=
 =?us-ascii?Q?8Tv47ErSEKw5xOhzKhl5lz9bCXB1YjchORP1B6/HsMnGnpTYWcdHmVsPvGBv?=
 =?us-ascii?Q?QZZM4ueF9HNV/I0+DVUqzkYtdJTfsqHL95d8w9o93R4feQ/uBwhUasq5wnpa?=
 =?us-ascii?Q?ZGfBeg/Pqy8n+8Q8BQzrCElqjZuQQ5VcVUVA9fx4nYmd8i/08/KRWckWDftw?=
 =?us-ascii?Q?YTNFDVKALoY3hfMBKtOJKlq2Sxtmc9A+ILVsPyNFqCxnWA0MU8e5I7FBCw+i?=
 =?us-ascii?Q?sv63khlq779SGhJp/gL1tZvg6Gpw9cwrP7qUXFu0ur6L2n3fH127erc56xdH?=
 =?us-ascii?Q?DzBl5xjqhduDmGVBlrIN4lYzfiAoOSTnp5Huv8INn/hUp0dTjCoydgxqqdMv?=
 =?us-ascii?Q?JONziDpQZuUQFZ5RYtMGcrn9ARCS6VRZJ7QyucKl11ZPcUeyYU3+ozsSpj0+?=
 =?us-ascii?Q?o25JpwulTVZLCedPoF2nHp+B5iNqSsOG7tqJh3VSV2KG0HYU8B+Yxa27GEo/?=
 =?us-ascii?Q?U9Uix0nOKBLwiHAYy1bAe1oxN6vbDZL2+X+e52+44UZ4EeaNpVOPZfo87wTk?=
 =?us-ascii?Q?zB7sVAZt3pUQxESryFtGRgrYijwmqWj24KdS59jjfdHOUefNp2RHu5u2sL+T?=
 =?us-ascii?Q?MKvuk2g2b1ePvAHNovdKkVjfAipn4vMsDF1mus76U4vC4Dqw9dybiGnxwL7O?=
 =?us-ascii?Q?IyhSlfW0wOSARaKVJUpf4n4AG/AOYXBpX0RXsmkF17mWqiZw2etZIpa+d8+Q?=
 =?us-ascii?Q?L27b7P4EccK7hY2oUTJvZDUdrr7g77L6TwuDRTJ+7l1jvyzJnhV5I2EWZJ44?=
 =?us-ascii?Q?nQrwy8EFvkGBBQzZNwfT7nA4kinbcUR/29hOWBPFled5V2S1lmCpnew0NEXo?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43bbed7-fa4b-4672-0db4-08daa1c5e438
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:13.7416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBDIwlYCBcGDTcTiD2PA18b1SebaGVHkJ/Rr4J1voPKKfpi1RPpFg514I+yCChuIxJizna3cdeOdyoCv/q90cVr7uCdtmq++LZ9Yizn9TEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: cDkabLgqKMYxzjWLkIlpBmI9uhB78H-q
X-Proofpoint-ORIG-GUID: cDkabLgqKMYxzjWLkIlpBmI9uhB78H-q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b5fa2aad05f9..3f630798d1eb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -519,6 +519,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -534,14 +551,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.25.1

