Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47CFC6FA91
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiIVKIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiIVKHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F1D5889
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3s3D006442;
        Thu, 22 Sep 2022 10:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ck2sjqzT6mwA9jXc1gC/l1TR5DXcfU6LS+YL1zMo+9Q=;
 b=G7wDne38psK4IFy6hpzuNEqdowXMg67Wk7JQEwp20Bd3uYcopgKNc8Zn1+RV7HJypjKW
 +d03yUYUJw3USY2K9H9j7Nx1cVyh1TaWDjKTVypbgBEslnUsXVPKznTM1N0vCBHHHrDT
 s8KUD3Jncl6uGOlSu8mZ7Z0GljoXbwpVMiC8CHu8ncUlV5l2XC/fUI8l4+bD/vSDzKwM
 4x9XoEPeaJMMNCP7EF36zqiR8oSG+kLj48pIdEefPe65ramNOPqvCY5bc/MwESgx/09h
 5DtXBlgxJy2Gk5u1GMWCq5biniCUOdCjqwdHLCkiWH1gYer6S7wo9P/iS1mE65qqK8EC MQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md285-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lW5O033884;
        Thu, 22 Sep 2022 10:07:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nedxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9S40hiwKrHwCMaUa1WCTRdXc+VvQi2hnREcsORkLCTOj+Yh9wGaYHBsCNjoPDwM92Up+vYry8kiiGkMmFvdvn20WpNyrMXGDgIVi6mtFC/CAwISSnkVEfd35ceJ54qPT1mszjMJztlr5f74SivucZ7DaF4bxY3JXMf3nn10WiJEA/3jL4bzSnG76Fj8kex6fycbp3CpsED4MVSW9WWxgHdLWvV5xp7kEz/xGD0Qb0DIHUcvvjF8VzDvjvOjCiDbNxWOpJEsfYrRbCRc9evMQNuBeDdgVqhLHKQmB1dkODT5gld7M4XudBnupGWw1dZD9X/7IFpAsGoYtyI/GkWu9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ck2sjqzT6mwA9jXc1gC/l1TR5DXcfU6LS+YL1zMo+9Q=;
 b=Tc8n7g8IKCbr1rYy3QaiqrtRf5tClQzLFBDsk8FwzVniPCMXwclwjGyv5B66a11envnwNMBUOjQFQwaFeL/jTAv2l2ONb8MqXCOa1OOSF0mSAkrfcKiPbEJETS4wpsBKzY1BkvS7cVWGJhKfDL7lHLXp7HudOKXZJgr198u+Ne+RsvsfyiJfzyJyPlrwCMNz5SkcuU3LgBCyunsnz1Be0tiMJnZ9fUSJLb8/zNda+ubLW+bHZ0HjuulyY6ie45GxcL741P9RdZIZoJTi5HXccyo2yVS0Kc/MSFfURJI89DH930iJCIJ33nHN4Uxm9yq+DvNKff3c403Jqs3TdLv9rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ck2sjqzT6mwA9jXc1gC/l1TR5DXcfU6LS+YL1zMo+9Q=;
 b=D0SKFkZH2wwY6ytRF8YK0PtE3U2zK2y+bJEkrTt+apN32rGJFR9UcMFRHu5A3NdQaejQzDG7qeih1uk8VsGTH1USRiXK6/NGBwCfQUA2Ni90mzdki4MXiKH1QFYWt8liEJYIJe0HTxRk9KnK+4dkSFNn3hUxScqPXA6pKf4aHEo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 14/22] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Thu, 22 Sep 2022 05:06:56 -0500
Message-Id: <20220922100704.753666-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0010.namprd05.prod.outlook.com (2603:10b6:610::23)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: e528c7d9-f32e-4822-5af1-08da9c824207
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3HDGLw2b5WXpoXNEVMMGAq4K8vf1dQnrosjTplMHUfxOZOXJ+mJ5S5H3oKV+rPaUVIjMlrl8NQrqWudHfSoPCaliGnLvVwwsbVwnY6zHxGSPCjqm8IIdfxKHD8CPa7wYbCGoBFm31+mDDUNBWneqc9Y27iHgd9eZHtbZEx3QnTshpOWkXZXH0702K6QRtWrdZet3996T1p80kdMlUytM1vXiL8OuC25KsPK2n/QIL9kap4zSNekMe0xi6ySmawOUSTl2aUPgMB2GryYitvjC/IEFYM6TVrW5wVIavtp7JesoIu2dnBk/TYrDpU4YOZmoypOINAoehYD6WFKFHwyKO0RFzhBFkxVYqENtg7tcIIfYhO98LNpvyGf4UUdRzY0gio0eXoSLWALFIQzoNb9vigAVJZoCarQRTSy7mw5I9Z1EPB2oY+3nQcdX0S4zzZketqn97Na4ZdNTeEjfeRpcDXfmabuPsexJ/rpm07KOWD/QxLX5WOeFQFVJD5jNaPsHziOuGwVsiS9RmcThxXoI+YvSTc72svS+c6V4T1Mu+tSYoVwmDzq6vQ0f4midr2+oEqOuARDmZjYTPHJDFKb7oSUcD+I3lto7P3/OGp60gFdBtr9MpGNFdWx4dw7bVmeNUlQkVDHDlazfwPZgeavvdzAembcju0g7LKlbtudK87cHndu8CsSbvYdND08hxQl/Qb2ECydZrVfLbTIEesqXCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gEHc132+KRSI/uz0eH2OlzzgNx9Z2Nh7spomVemirsU4pypPo9SqYGky6JLR?=
 =?us-ascii?Q?I0iSyIZIOQ8BAJ7Kcd1a1+N0mG1OfwPxYbvwV6/yiwDDctRYJAd++7GRgJqW?=
 =?us-ascii?Q?i04HpJ5vk8HKDV3bgfNyolQSxcLivYpuFEf/jN9v22UMWl4+N9cnIBZdVG7v?=
 =?us-ascii?Q?MrtwmfMXkNvQE7yYH0L7vFm7QrNWrHSpy0ZlNrTKxrEqqH74jm6XbMxdZZFB?=
 =?us-ascii?Q?DBqSb3LFszJ4+iu3nctg2DZybXYa2L6pETOgh5djt0jWNiGcmYd8p7vnsvRl?=
 =?us-ascii?Q?wI8PfCVsvSs6nGDe1CkfQtzVGP0SNKpiBMKufDz2Ap9cb5ex/fjTglFwmuRm?=
 =?us-ascii?Q?dJggehHb4GNu6GoAhhQJuiYiFJObTpytsHQ7hQNQPWZiDmxE8QJDsQpiCIR6?=
 =?us-ascii?Q?vLKtwTCyyz4FnCdHzJOA1QOIcE6SqSB+HwpDd24MkJDPF2U0mdrXl+mfL8NC?=
 =?us-ascii?Q?2Y5txbYT2E/yFpJzKJnyizb9yeEZzYSQwt85iZsrHnGAPWCNuu9O0FeTWrt+?=
 =?us-ascii?Q?cSOt9J3DkysbteReO8w0SNPhge2NCY4Eu9mfQ+TRo4CI3UMAIAot7Z7RpyqK?=
 =?us-ascii?Q?I8pJOAowrbsYLLKPWPL19VsYRmRoVcZmljpR8vBSCMiYTKrMFnYoc2NPl+yR?=
 =?us-ascii?Q?BVqdXnb8CZr+Mz/isGVmJILpPdSec6t3MKUyfXr6BsdtFq+d875xkqtfm2Wh?=
 =?us-ascii?Q?6dQe1vRkdfp9qZ8k04xNjl1ZfHxmjRTem6PNvFLsUi39Nhmm6ogZN7aSM50F?=
 =?us-ascii?Q?ZQ7xc8DYtpn5RYWFQXTOs36XjUO0vRuD9WhgLYK66/G3T5HtRQ5njxdTwt/B?=
 =?us-ascii?Q?FGdx/J5+Ah9SxE2x2mOPa3B2mLtlO6hCQn/2qeYN6njHqb8MQV/r2+xyFbLs?=
 =?us-ascii?Q?x1JVqNtB4FMpC+XSdZVBWR3IZOXOOBOwjIXIjb4oaXiAGZq4GB96XNiz2TEx?=
 =?us-ascii?Q?bGS+gQ0zhpGANMH5uzq4By10WSVTCC/HT2wm7+VBMbQF36yiR3XqNN3uKMOA?=
 =?us-ascii?Q?8XUNetULqOWWlbIqUhJyZm4CF/mDZs1W53l7bkSjHmXb/fIjYgwA9hmXMHiO?=
 =?us-ascii?Q?EA775tysjq8lAx2mxqDpV/CeyvcZGiTBob8LH2JnZRGyzQ+8YQtp1Y0DRdiw?=
 =?us-ascii?Q?RpH0nEBNgG0HdT9+/JtNfvNoh/QNRS/BNxNVZ9a0IEA5aDCW8EOwRuiJ0CXv?=
 =?us-ascii?Q?LC9oxpLVNcMcGktoeMFRVmZrFCuDghrV8yVMXWdP9OdU23lx1juqmqrYKsY8?=
 =?us-ascii?Q?Q163QZ9paYa6E7JS89EtMh5aZOe6YhkP+0Bwpcrhy9uhDHQ/YfCK2i+0ZOBz?=
 =?us-ascii?Q?ytHGA295dMiM79BiOSCoh678UjCmjI0uC66vHgGhHOnvmnKuf9GD/AUdRQN9?=
 =?us-ascii?Q?pSewm6PNlrSmcWgXL5bMGd5jehTOQM8zhIddZVREQHTByOrCLJz/pQn3ValH?=
 =?us-ascii?Q?ToMW2eOOI7EnMzCgiblfAbf4OI5MOAoDt+YMtAfo1fP6eLmsI3XHktVDl2IH?=
 =?us-ascii?Q?ybCXv0WtGkKLXvo0QlD2PWv72977C26Rn7GgpXPrL5XL1jlGWd61CR8ukqRY?=
 =?us-ascii?Q?x4oFLKP2RwyGe0zTWWJZtrjSZaNtkaCj9nQbw9n/DmxeGEfBw311AMQ1KSZ1?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e528c7d9-f32e-4822-5af1-08da9c824207
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:29.5056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrsNdm1zVcZPMz1Tychh/MQo9qk5mKcFiyC5GgL0/1CpENYBbMpBsuUa0h1/7M1Yel/ZZWDfOtb1N56cLJiihhtDgflUaR99eVUDx+sztRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: jhXalMGiPzWQ9uLAhrESyYCX81WowiJ5
X-Proofpoint-GUID: jhXalMGiPzWQ9uLAhrESyYCX81WowiJ5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b76e0b1900a0..264c63b10e06 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1573,11 +1573,19 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
-	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_ANY,
+		},
+		{},
+	};
+	unsigned char cmd[10] = { SYNCHRONIZE_CACHE };
+	int res;
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
@@ -1586,21 +1594,12 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (!sshdr)
 		sshdr = &my_sshdr;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				   timeout, sdkp->max_retries, 0, RQF_PM, NULL,
-				   NULL);
-		if (res == 0)
-			break;
-	}
-
+	/*
+	 * Leave the rest of the command zero to indicate flush everything.
+	 */
+	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
+			   timeout, sdkp->max_retries, 0, RQF_PM, NULL,
+			   failures);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.25.1

