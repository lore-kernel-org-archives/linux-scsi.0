Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3B1C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJCR5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJCR5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8543FA18
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOYgO015780;
        Mon, 3 Oct 2022 17:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PNqtyKEDi1RzIVkc0eoTbA2MzGlq4+5eFFcHvyYJ+EI=;
 b=JA6TDnfELSw9T0VfaMxVKfOexyMq89rrNRC8k/kR9il6Hu5YfYV0Z97CUMLCPc+sOZjI
 wjKbGVdi7OLiRgCZMS/vAbgT6MUCwF384IXtOrjKf82Ev/gvwXft+JzL3CvriG4s1v/t
 x87XQsGnLTtE9OiTaYyWACiXBBy4AgV54Aneq/JSccCE0KEtEahMGlZVzPbqqpDsXUzp
 RXdkx6zlX7T48bzFHJ2nTV5qGpbKNN0G9KSdsArid85gg79RwAQBcNxFQ4IvYRcS6mGH
 J1xI2Y08Ut2ZBiXs7GVtlDrr9KoC2B0fUT8XY6QbyFbRS7FdiwQW2TX8p0ZSv8RV6OdH dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea4cwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FFNfY028067;
        Mon, 3 Oct 2022 17:54:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQGcKRXG94yJRNSMlL8dejECmRgbMmunNs2OnD2BILIkFvsYpA0LhLa4t/7KLaiSRlPYR85/z+bpa5xFLh/Bc13dH9J7Y/svCmMnRZtwY+sk/Fo/srexWgv5R5d43DNr80wVuETjsxmuhwIA2hUIBDAjz9zxSYFQ7BsKm2nD7/I/cVpmXLNQEMi4t216esLhDAD1nBxTSR1MtICK5Uz1dQF/9MHg5Qt9pPM6QhlKaoL3ZO0e44JRZhp/HxDuP7bdyllMuDeqq0owjn3z3bXO0OdgB/XF+5ty1qK4sNQCbTSKba+s6vOUM5q9e/6d1jVlDSekcFF2m6ymncirzEh+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNqtyKEDi1RzIVkc0eoTbA2MzGlq4+5eFFcHvyYJ+EI=;
 b=O5ojM0X9drLNxqzmzJQWi+zsYJcJh0T+LEZ5PolFZqKnbvYYGwZqy4TWb1bs5OspyoouzQ3Vc3vaxby0euq64ZottfcWq0XywBjr4w5uhegC6tw2iUoplz08zI98NYoFgQ/d7NlIx6aroiLh9QOXkX1WB19BjHT16hBsvbNuT9sxqrwP3EvTXtj/09Q/od+GCLPJBcbcbJmnvwvfZHKRO2DUZfwNAcO04dpQhg7slCAHKIUQrDa8CO/mPELfJQ9oF7JlHey1MbH056rfHHmH5veynKq8cFjw7Ya3o/ZX3pApjPsDQpRbULW3xXcLlFtlYkPf3BzPlLngHgpblI0J7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNqtyKEDi1RzIVkc0eoTbA2MzGlq4+5eFFcHvyYJ+EI=;
 b=tzYda7Qs6b9KbkL8uT4uwSG7O6xBk3G99Olq5u9EWvRfc84MANvNc6OaSiGFeYSBY8d+Gb6pnE7crlsbSCdR47Y/OacviBCKO0tpxY5zWGbTdSbQ31Y+VGQbX2O3jwxLepHACCBXc8p8IM4R5SukJFpH6BN+QBHohwHYZBuU3eo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 22/35] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Mon,  3 Oct 2022 12:53:08 -0500
Message-Id: <20221003175321.8040-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:610:38::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 78b04414-acff-4128-3285-08daa5683e8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIyimRNxrYFIPghgNp1xGkoYtcZqcSVAu4h1JP2HGL9nwvlc9mcuH3T8zC7N/ed8OnlUNXYAdiQbJTXeTW2plwOFKyakxqdpLw4S7GExyWVSHFWOZwlCEniB/R71IXJxt6oj0jpkN1G1dNaP8sgH6PQG3imwYk8MBkpVfr7Me+puoc9CqJM6yeM/jOm/LOGM02lMTgbiwiDTNByjG/kTJ7D6a7dn9wfXj0zrYNgrXDB+u/ZSkIdHAZz9Rvdwzw9S6p6pDFcJLQKoqA7gwBw3Q1F9D7wnEu0rCfEkH6cSgBd3ntVkE08kZr4sgvmpNmUFka0MtXqEWdoM5fvfZyG9Fwr1isXbai8UBefDvdxWG9Hx2cSLq1xv/qe89R6k85grn8xeiGmNor3lDsfbKovjtmEsaz7rIbUzArMbY8illfT/sFnIAYEn4VPExyjnxkbpi07VPDP9a1FXZAw8QoA8kRMIPE68YFYdXbMM7jQFi8lc9UQJzEjrcWlL5S0In0FiJsJl+zYXtARyiy2HHcZCouzBBwVU7gnEz//PSyfeW2N2FPEuR4VSp8J8f7K3TA6S/poPeZueHu9LhfM4WAROozo4oxXaLtDuMSfolO4r0s1Zol9T6EM4I/v0UjcIHbDYS/lG7BCZnA76QOLO5c0Sv1utXPwgmlRKKTQXHzGN+uWu6jhXw1+HA7F8IGKQsolmy+p17Uu5CJaincohM4xnsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cv5wrfhw59vwsndMfhRwxhzpEOxqvB/LJo7J+wcV0B5vydA+40oEB7ymiPTB?=
 =?us-ascii?Q?rqjmxMrS1MaBEeAAYryI7/mdgxp4m5O7LTcSMFYvVTmnnGL+fVZJE9iW2F8/?=
 =?us-ascii?Q?ypg6NpV7Uyv9VK8g3MCSCUejeybeyBGLDjfrDWoEFLXLytF4uPH641D37HGO?=
 =?us-ascii?Q?HLWEFm2Ma9UAH4lVkCSdDBRzsCykWV0si/9Aef0cRC4Tl1przyoPLI44I1Q3?=
 =?us-ascii?Q?/PIMaNyjbqDViAWq39vd2U5/pkj9fcD6Zgum0/zZDEChYsqvKubXckrTyZsd?=
 =?us-ascii?Q?7KZ5MujfkEFV8MptJiqkroEdRycC1G2lFxfLvCNp+BqPqDZ65AqaEiZSqIKu?=
 =?us-ascii?Q?AtxAzI1J3mc3b5mLoJCSeE8ifKMRfk1jLLPpx+dTKRLg04+4jxol15ZYpLjr?=
 =?us-ascii?Q?KLCLByi9iIKP2759TkHvYaU9iVRsUX8Lwgu0aNc3ghwG/vFn/IJXlK6Xl89C?=
 =?us-ascii?Q?AupvGjJA8ARhbp00oMrn1LztJkOY4oTwiRO1lzozz6Phe0yrgFjJSuJSJVf8?=
 =?us-ascii?Q?S/bVEFniLjXUUdb9X5PnRHwQw8+dSB2w2W6zXBGKTVsTFmrSxuCAr9r6b3oJ?=
 =?us-ascii?Q?oSC+TzSgpHBJov6elM+7YweGQfLbtQL7CY358rpoxyyL3C4UsYsbJMtNYFTi?=
 =?us-ascii?Q?NXA7AywaQ8iqOyX0mk8oYEnlpDdbJHUF+g7c9aPTXmjppvHhPI69WjgwZyWQ?=
 =?us-ascii?Q?8yPOQ5QvwVf15cnh4x5Tb9JiZOGEyrhzqaBXfpPNkR6Wsp3N+14p82qUEMaf?=
 =?us-ascii?Q?xtO1mObyXR3S/0XLklD2CxQcPYgQchSzPTux/h3EH/cNAgqjWfum+ncHcPbU?=
 =?us-ascii?Q?/4rFnXyRmpjHhJX47snxN6qoQ1MOL9yUmEraUhDIsIG5N/QuZSsnauo0td+V?=
 =?us-ascii?Q?B+fYjtF1lr615V4BRjIUEVHHaj/Ct2lWe6uEc629utVt3msLY0nfjEIkkNGO?=
 =?us-ascii?Q?1/+nexBNMq45JtTPIJofCuewWvvKDnDTfC2EvsYbe8Jf89ArUJpa7sXAMcAr?=
 =?us-ascii?Q?2yjvaeifRCR/+bGQ9yblxh1DIyNeso0/3Znmg7rtB8IuF4PP9LCBmum2Ivwo?=
 =?us-ascii?Q?dZFBFTRQ0P+hiX2JtOXb24hT80rzcMuyZyZjd3O185VHK0Et/27hLcKiOQ7U?=
 =?us-ascii?Q?t4ovvUx5/YobC5MRgYFdJeFeWNa/9a/3EX5keCxgfVIta2h+HozaPcoequPp?=
 =?us-ascii?Q?uXXe2zlmOBIo4NoPgJAV/gihVq4wqYX+TzvspLdGCt5SC6ObKeNg71tW4a01?=
 =?us-ascii?Q?WuCMZiBVd1B2ix1XQasxQ/zwCnHf6YBtxPHpRlpJ9DDMkACS7ntPwDNnNFwr?=
 =?us-ascii?Q?k2XPEk4dezInBB3gEuK8agP0yiMrsu0UCOgrEpYeUhJU/nHsJ/u5rRGBmCM+?=
 =?us-ascii?Q?I3sEXpiVwIbwBWdMHAmcxwMd7DegVlZTn6IaZBFa4Bu+Q/XQ+WpbTzslEzvD?=
 =?us-ascii?Q?22BWDt/CQHKXFQhcS0ZXCg0jl0ZjoIX4UrFlMgsIll77NHQr3x8SSSG6lcZQ?=
 =?us-ascii?Q?ES1u5uLxyD/7Hv/Mdat5qYy2NXXUkWdBWR+QkNV5s3LSYzNnowdudJQhFa2v?=
 =?us-ascii?Q?EEzfN7TSXPmqQqIl0pdnWh+ruBsS9bZoeLnC7gzF3M7f1OwTMnRJOBNWD/HH?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b04414-acff-4128-3285-08daa5683e8f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:57.2506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NE1KmiYxaN+ekInqB8MEnoOEkM9WOiUVvTUh5+VQ2ZhPFzvqBqCFm5J9j2m2ewpLLOadXSI1tV5cKRS1cQNVWOb2XYOROQqVxJz8CJoY3RA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: gJuteAfLH6zyaMNm9CqJqg3UiR5xDHoG
X-Proofpoint-ORIG-GUID: gJuteAfLH6zyaMNm9CqJqg3UiR5xDHoG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 82 +++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37eafa968116..a35c089c3097 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2283,55 +2283,59 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_READ_CAPACITY_16;
+	cmd[13] = RC16_LEN;
+	memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = RC16_LEN,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = RC16_LEN,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
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
+		     sshdr.ascq == 0x00)
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

