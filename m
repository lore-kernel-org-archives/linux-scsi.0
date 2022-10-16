Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F8DC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJPUCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJPUB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC482C660
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:01:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrX015579;
        Sun, 16 Oct 2022 20:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jxLdzpYRskLFdX0/hNwKee6XSQV0rluU423kGQiLvB0=;
 b=cvsjd56xUkibPMd4km+Y1Wl+JJ1HbvCo8iDyN80IKYF7tRTKOlfIkR51q2InGMOHr+Lk
 2OyxZsa3gr5jEwG7qS8EH8kcodx0FWQPLETnnLAPT6rAnz3GZLE686TPe891DjEyuoJP
 1BB8JnR/VFJuEmNaa1cRgWn3emU2Jv0AsvOAr9LVcB+/qd/QSVJckbuagfhtY1747ld9
 MEb/wSnFDxPnu3X9sJPRvaibPj4uBJvht4tOsqwgdE05BWDR+5GIAxtU4mFUDm/f6cJs
 VUJ+01Rzf6IEcF2eXbgkDyuWfNXCLOGnvI+rX5r3AX6BImibtPQvTxuEM2wo0hQ/JHn1 7w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSk034322;
        Sun, 16 Oct 2022 20:01:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VClkHHDCkBpWNElWCbl5TuRXA2ntRHSqU4ROz/yRH81XOghGz28DgTHUCPgzKoqJWvDPUY/Qxb4vYDY+oi0asXtE0H+DvL2jJZy5DG3Z45wMKoIUN+BtwUQ+d0WjlL/+ZAP+fClwvI845WGQN8HdJFN+5aVFBU9fmr94ZR8RMFPwSMNrNWnOGapgIxhy+vfGGqM6vOe2MSAB5v7okD3Tw/mg12BLv9521cwT+UCwLa/vMbMpGa6e3CNCpOnV4m0geV7lqS78D0162DCxcuc5ZiU2xFkpr0FtMTeeSEjuOGtMz6ghueS+gz1hJDu8bAsUzqOrpauTKrU5xzZhGvZf+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxLdzpYRskLFdX0/hNwKee6XSQV0rluU423kGQiLvB0=;
 b=Dy9ab5wOxNbO9m/fvhWuysXQVI8Uk7lcNvNR0WTLWhRl3Rzc7NMtOenPoGIpSe0rzw/MmCb97DI9mGPtGmEw7wSM7j8qBeNN1HBql/jkJXDAw2D7VkxFZQqWLj2UCwFIBA4NPXqeW0Fsbf7yCXmDafafCKH/8Mz/08yLZ8pnQeTGD+pmGXLd9y7alfdErnPRYhvEgg6FwleAhXSoKhQMI1460w5ByK3aERSNfcGheHYGkDH74n6kBGGXoDGov3NsqzETGkHvhd0qyLMrO0jPRj7pw0LAx3Q9UnUw59JIz9Ld2SsxNhnQo4pXuAyV4lFOnd2OQdiakNFAhT9NyVcfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxLdzpYRskLFdX0/hNwKee6XSQV0rluU423kGQiLvB0=;
 b=CIYH/7Kvp3ZbLo2czkZ5HwK+3GHcxs3cyJ+JVZ2UfBgBT/P5CXO7z333tV9KflHgnZO87oRWcGnWmloB2u4rBSxLEStXSfo/iBuVtS0pb+oaRhlVKLzI2CNj7usYMjP75yUhYagR8Ul9L2R3Yz0NrucMF0+XQyTSEfPYUK2Sxfs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:01:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:01:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 32/36] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Sun, 16 Oct 2022 14:59:42 -0500
Message-Id: <20221016195946.7613-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:610:5a::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: afa79b2c-1ce6-44bf-8a4b-08daafb11e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TR9MCIXAsGqFEaeK7SwwJzfYbw7ZdTZI1jjQipFI0Pp9MMpC77Ut4hj/vUvANhSTQbOzIbNr1WekLy9dJ5ZmSKCimB84f1mkL4iNkii9IO1sYBUlDvCPImlw990GxJOERvF+HJOAo4S/ChIMtLI1DPebvxAdvJZIo9/7TZp28qLQx65gFRtb4K5SWOs4FLY4+BEb6s4b1j12a6mjqumJchsr9liswfRsPw5Zwu2d6En2pqTe3gRyYpCcehVOHNvbLy3sj6liL7nQtGdbdfMzTskVKt/fb7/kNPEGh2qDLHImpf4eNccVgydwT8XNA2++AMH5op1m9gQith6jAeQclzqWoy7WvMTee9zOiBVvZJBZTOyUYqO1FphLUsUzUIoWnS4zR0J6NR9G3+jIuwCKbwRG7Ab9urGMM+pwtZO3CU+DeYJ735Ey8skSAE8wUcvrXWT4U1gKrHohs/6y680O2s+2mQs6DK6l3PiLNonmdG+GQ4zj1RxEuVTI4FwtJGp/8ruz8pKtyLJt7z/Ge1Waqe/eHAw3Fgh24IaO/uJ2U2vrLgKqL/zsudXgRdl4gaWfsf5tIb8CbXqzSFnO4187D9+cH/SrldQrJZBUrgIkXUGQs/SP4b87ysx1wHWsksj2kU57bsT5TtR2/tQBMDjJuF3Arafa+b42uY3Dsv9u8H2FhB5B21daAJmo38C36lPGWYS34t2CiyM0s77nubELQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M1HAzKQinbPXsaOJSYVs9fNlMTX6qLctCVlADjcY+/FaPBOS9zd34iWg2Hwx?=
 =?us-ascii?Q?TO4+XXV/6M9OoWnaZciHLowhJc2CvmyI2KD6JtHEHP+hAF7SY5N7fEjevbst?=
 =?us-ascii?Q?wQTbQJRXQtZeYpu15FEJ3Gjvi0fwoz3s0FhSYnSFH/GqsywTR2IgRh0cHmfQ?=
 =?us-ascii?Q?xFJ9tfKrtxr9frEjOsEEFqTEevEt8YCJJSj8W4rgZRqhIzqoHoKSX9bJgJeq?=
 =?us-ascii?Q?tSD9ppzNTQo4U4NZamd8r+vCWEiJjesc9Btoo5H2sKtbVhtDUlyjOMqSPNw6?=
 =?us-ascii?Q?YUnjHfKJ9GldfYtE1Cv+hmfT/gJzd7SMqWnSbDN+G4IP0AmUftSQ5bh/Oztc?=
 =?us-ascii?Q?PstvuzsBAUdqlh/Ibe0aEg4HhXqyVbNcXu9WPtZTBg/8zo1PlF94ST8cKAEP?=
 =?us-ascii?Q?uQJhVl+KWIbGPTy1zAjBHCdxhlE5qdWp3iDzTGgg2uQiixMyHCeInGA2s4kF?=
 =?us-ascii?Q?iL+uFW5ymFobMxmXDQk5vzmcAU10A/s5rIN5y1fSZm2yLUO+KmB5b54Dhooh?=
 =?us-ascii?Q?QWIlycGYzeCqaV0Da9P6qGzciRpxG5/pYLmZucwrKEJFAlCtwfFn5+DBcVQ8?=
 =?us-ascii?Q?SyiD+IvPFWRo96s2CcVSPohMWNFuSj6lQgXIoGfaP54LikKFGn7i+m4+N6u2?=
 =?us-ascii?Q?qaJ56Yvavcs+oG5t9vmHnW4PCnrAoFRf7TLgJPQfra6+aULAzR9FXZ+pX9BT?=
 =?us-ascii?Q?hBsvUQkaYZSjnj+e0ng0eJch+yp4nC7bifXo+m6ZxFELtsiPUWr9oEz5u/zs?=
 =?us-ascii?Q?4lHeu3pcIYUD7O8kYEoIPs4GFYhySmwf5L1Y60bF5uMzcMt54gNKvcihdJJW?=
 =?us-ascii?Q?ZsVu2l9YC847+2zNne5ypcR5cbrOMgxLTM6U5b11tCJf2BYHp4fxEvWE9PAY?=
 =?us-ascii?Q?kY2yO3ElGuOdEaSqIbWnGzCdif6Md1pvTVfbEGnvdofMUaIn+J7XaFHzrj+k?=
 =?us-ascii?Q?HCxfHXLmBTCyWR8BptNxquU/QlfAdaOLpTN53pOr1hJJA1MlRXJssTDUS769?=
 =?us-ascii?Q?i6pjnzy1G8PCCT9bgkvNA+vndgWTanE6dPSGQSIG/6C5tJLzUEAaqXfDTWMY?=
 =?us-ascii?Q?Q6hTbYz7x54RhG0MUaIfEl/IBv23QgGIa+j9tmnaXV09d4vaC1tsXMK+4Rmb?=
 =?us-ascii?Q?Mz6k0I+xvErZcBWTt6Y8ZcfpFDoQtQQ15DCNI+yafr2wiOAsPgjUcm/dimc1?=
 =?us-ascii?Q?fE+IocWYg7JningfjqrgXvWfcA8KD5MvFEY6e87Pg8ZOVG9+/inyQnWLJKtH?=
 =?us-ascii?Q?zblzuOBrWwtxLQUJ3erb7QOAMFrvnn4EJWdewqg+w4DZy6rmXZ6wmqAcOS/z?=
 =?us-ascii?Q?E/qG/cMx+odddbgz13qxIfyW6ez6QlJRu7w7ZOHCOQPe2G/1zS759S6x2N4m?=
 =?us-ascii?Q?Pjhfv4BnuSLBUEpoHEliqUCY2KJfFmfoW65Zd2witkMPNYVAeKSCO0z2ADyC?=
 =?us-ascii?Q?0XwG/1rx2ZMT1ZwlVsgjatCQo3n7N559uqqq9SmMsAN8TsK1rzAV4Gg0lp1j?=
 =?us-ascii?Q?VU/tIGFjFW8A4LwEj7HTpdb16hgL7b0VXK+Pt3S3z7mIFyHturMOtAEbSXJ9?=
 =?us-ascii?Q?YF+w5APEb2hFpRrpioFDgRlg5zW/mj+vyhfCyF7hLdrvWjkv2i5XnLa9SED0?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa79b2c-1ce6-44bf-8a4b-08daafb11e40
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:47.8902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 522ShI/Vlh/rtcMdu+ebvcNQL1/sx2R1dvmR36TwHwFV6oW6mv0CGO6ay4xc3FP/TNysfcbZwijnHsS3cE+N/lXOe6mtYcmuAMWo+VV7TxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: fw4LLebh6j0r7MnX_APm02ovSXzbbx_d
X-Proofpoint-GUID: fw4LLebh6j0r7MnX_APm02ovSXzbbx_d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 60 +++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d19e2d20ad91..7d8e269f3954 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2391,45 +2391,43 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
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
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = 8,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	memset(buffer, 0, 8);
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = 8,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-	} while (the_result && retries);
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

