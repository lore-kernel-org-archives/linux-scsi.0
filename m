Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FF3C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiKDXWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKDXWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:22:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2738517078
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:21:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhrPs027184;
        Fri, 4 Nov 2022 23:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=Oh1ghgwhXCjnFsiX1Ejo0r6t9jIUET4Ji2zFycoqMK068J1NrDhd7Lz8oUhH3BS4d9bv
 PZkwG4pMPWMZltZM2bH+NCgn5s6DnCoi82KZZZMg3MX4OXMSNQ8+UW+rW785eO0b2K9z
 YtKYbuXLIc94JH2ZO7Ns/cwfCKTBFr9SxzLwLBPFLWTcffgKkoFv5n+/TyRmW5JG8CNt
 acVZtEIA9Hp2F76uNnEHM5jBNYxu/IX2FUvVXHKRJp8cR9HAvIS2c0+Z0+FxcZeT5Q9O
 V1yYwuPMz9u2aLEqj27IwyIzlFqfJCmsYmU/E9FoneHk2DMSUWYSphzughIHOBUZXh4z 1Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgust16dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4NBob4011908;
        Fri, 4 Nov 2022 23:21:47 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8csw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxIyTXhE9iR8HxtmjXyuJB5aXkTlEo/8ZEaVCq/Z/FELAKr+AeBRuh9HvbBUaCd4E4OUtPmEO5Qw+ZTEoLRTAIt7YsnxLPbtZBg0hLSdNDoQJGUk9Qkg2O/ctL8G+q6N/weE8xQKGwLInp0E62xZYBLbGBMUOrs3f/rDOSG3aEokh6FKbz3D0PViRLYOEowRkRF8STJ0vUqnD0V5bpFQleAOqIHU2Vyty3K9HzScZX626ct8kUNN3P+HmJ1ufVOGST6N/uY64ggv1i1QwZdTTbLei4o6cxI0XGh8Q0shREBGcB3BM6FRhkHxeySf25oCZHxToSA9ltM8TdtEGbWUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=f5Lp/lzpUJd41zzTJypS8ipyXDrRFlEu7cCgxgP8eazvbsaw2WaJbwk050jxjglTCR5pR8Du782hG/J2Z1DDTr7gfGwl33T15GcBdONzWweqJQh/YHBbq9EeNRwkWLr92JzdBANa17FF04zcU+lpgPRFLX6lfapGGJEA60q/UVB3aPJX9QBZ+kDu/dc38yapK8yy7dV8K1/yYNqtJN3YK5UWkWDEBfmfRf4V6iCSAUrMi90tcxVGEzRw1Kv+b2xn8OSoEaCV/GT9vE9BweEFYkDmwoVF98Gc82tl+u+7CN5c1lHzNo07R+VlcWso1nSb/YqHcLQVj4cUCzF7Pzm81A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=bU8cdZutk8Onb1vyMYj2/XG/+3VvdqL+Et25tSPteG0vZ/R7HrGCk0GAxrTIgUNT237GzN0tFMVayJZ99oJvq2gQrZ2jaT+LMuFJl1RAqFm08V7gg8/clh35hdAcwk1LDNt3MrTd1MBqnLT0vtoQUqM6raaEDqDvdFwitS2suzs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 13/35] scsi: ses: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:05 -0500
Message-Id: <20221104231927.9613-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:610:74::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: b6aedcfb-bbce-4cd6-20cb-08dabebb55a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +3W8TeCr6VydkxQ1CyMUUD/007n2VJa/NbUD+1NXxup5nymiPok5Ix/cZa42ydCTlQXlmfxUc35i6W4IN8zfzjSPFAUDEqybJYDGoOBqf2xnQWlsiUGzNVwpmwaLucehWL2MEDM+0DzfF3UdUQH4qUfsfDoUOB9w0iKYxBSNauWXM5SjNLW9C2gSHj3vwi/+RBfVgMvdZzaqRthsFeme+6RMyA26diD6a1DFyRb45C6WVTP/nGqdMM6kARCZpUx2uiuHUdi4jBWQIOF4+aR/sY57ScFXjeMrxR7PhYUptbcK3bUTCVLrUpsaQwzf+bsT8owaNcYz6m4CQqL60VLwRvu/YYSf6OZSlxaQK5tHg4VhzsAzWwdcXrZueFv7ndjtzOCJxucOOmWJGsGSWDeJDkGAyywjSUAaPZzkRcsz6R/Fw0/yEW+24JLRI83fScP/im1+5aO4QmiE5WdLFDlxtfi8VFMfbqT8loUEIvnajs/Dov7LS7yrZBlWNya2oljJARifxSs11G+vYq/Be9cl5mvijT+srwZFR5t5hX/TQqn0/r2JT4L9qK6CHFk22bLtteCS6Nc98+cUlSK7TrBBZeBtBv+yBHy7Xkp+bVn7AEhiFkMxCf7izxPtzFee54G020Hphfv9ipWUaGJaK9tj1EVi+8c0ha9botSMv3ONFmog0Jvc5dJ7Xo9jWjIRjKwL54+XjOOo5I0zpDSQIb8KDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j7fWTz3VJXJ4/1hW+0kDRAN+Kw/cw/OgVPlKd97vCbreBHbTcddGiX/djoMJ?=
 =?us-ascii?Q?q7IecIVZBlEqkvmkPItrUcF3/CubS9oxb2x61R2/E6/Srs9xt4d6M50kPEho?=
 =?us-ascii?Q?mgfjyizCUPjkBeBdh08fAtqx9WftmCrmT/6Vbon4hQczs5HFMTQIm2T1pLb6?=
 =?us-ascii?Q?svQPEA/2MoZgpLD3JCc9gOV2/G7fp/hA64lkTX4xy8Wmdv70iGy5kFOXHvOo?=
 =?us-ascii?Q?totohfq9P6YHRl5pHihQO4Fwr+wx0guJGtVCqZYKN4zKFoCH0DqY2YadzsdY?=
 =?us-ascii?Q?Uptm3lHS/1jdLpAWXp4EJ8pNh0WBCy+ibS9CLtPxQ+K12H2bFN+VoAzkLIp4?=
 =?us-ascii?Q?DEw/9YckcQifVqRGTaGCjIDRbZp4IGb831MmUdXImrv3kLjS5eLz7XR9vo8X?=
 =?us-ascii?Q?Yi2mSUgNooxOEwWjvsAiyPUVEyYRPPUc+beFtQIE+PCIjoHst4zi00F94ojB?=
 =?us-ascii?Q?QSmrQLXuu5j0Fc6x/Qo/fk/6yBUe7pKqjf+7KrSTQPp9cl4WcGF9hzzuNY4s?=
 =?us-ascii?Q?CT/fGxIrJnpZxxAJLtgxbv+6qnjuazoO/XL1wdwYuPeb5MiOEG8rTatAd2tv?=
 =?us-ascii?Q?CvwrsQ/kAqc3XArbmGDC9nLeoymjYzHNSqF8QjNNOBJhCgFW3fZ98xScm+nt?=
 =?us-ascii?Q?koQeldpk30MwmKpJgaPkGC77PrcMYFyFBKJcRoPBNInCqSxFqxbvUfolfu3L?=
 =?us-ascii?Q?JTnCNjxDkRryXVhXEpdusbgHwocjkkC2fGNLMr4Mpk44555/TOhHsIu1zXMi?=
 =?us-ascii?Q?u3By+JN+XK4ttkt/T7qhr4++I9MORx6grpRvDIvDoRzVUKh/vWk9p5tYj9+p?=
 =?us-ascii?Q?iXn6iYbqz9u14Ls6iss4IO/zIqKmLUCZTFI+H0NJNA2FELefj3wZyxMSkuqT?=
 =?us-ascii?Q?M9dMOx/2xr+ENQ2bEfEPD1ZSNAK5B/QN+suvzNfGuVvmhRfICUPZNnK69/WL?=
 =?us-ascii?Q?W7RZJ3dRC+Pga/oKnDH01O6uqQ3Gv5Tt5cs2TF27HhDTVw9y8gHeIOqW9/Og?=
 =?us-ascii?Q?ASI1pxlhvuZqNpdeGmrDwB9f++xIypxz//7EWRF5jKJBBX4dB+4//jzpjyMh?=
 =?us-ascii?Q?+9zjHWxVCNyElS3v6sWywacVRTLNwj4UGJ0tjlN9DdBFCkpurjQ//YL7fjUX?=
 =?us-ascii?Q?nYG6o5ONWAuOiJP6nsvX8yhfxP5UlJ28h/oW9sJIbQ72ePbyKQmU9W4VOrsy?=
 =?us-ascii?Q?rPCkJI+17DDOj2AIh2YRJlCNCODeNe1dRkBwstkiu9pY4bFQk5yPNcbYtyWC?=
 =?us-ascii?Q?MCzTXWrp6HroohePW0ijcxklMxV3S8UcDMatJ0lNF04F6WRmmI19BeuVzcd4?=
 =?us-ascii?Q?7XGHu5mZVvHHD5je4EYY/kEHayXp59rGx37wE2Wfq8wh+PuK6AmxVhl05QuY?=
 =?us-ascii?Q?HB/jaJocc7hfrO/Q6jOPjtuf2sDz2dgDcrJyvwseHkgRukPPTcS8FxjT2n6/?=
 =?us-ascii?Q?bmyhC5kTmoJjTOCZIvRu0IxQIswcf5pp4MD7SdTC5h96RP2gL7X60H8g2cMr?=
 =?us-ascii?Q?4AaD5sHcFpkP7XZmjTJjkwrhkH7YTe4TDNl3iY1QxmFaOMz3T9hjGzxcvZ/A?=
 =?us-ascii?Q?DnI4w8IhAkRdsYQwubzxKAKTgULn9/HZ/OrMNZj1N2wvTNDsxIPwZ0AgcEIC?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6aedcfb-bbce-4cd6-20cb-08dabebb55a9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:43.2905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqgDa7WOZkSZoxVPI5ORWhHKvPqeWrNphCQQ4jypyLh0CEXoEIfHmzB12VxfpQyMu3Iksno+c8c6afGjbskZAzD6wsx1u+l3YG4qci/iRrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: yXuzGOWdxrO5Bf6gEBB8uB54ZRGNUF8X
X-Proofpoint-GUID: yXuzGOWdxrO5Bf6gEBB8uB54ZRGNUF8X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..c90722aa552c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -91,8 +91,15 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_sense_hdr sshdr;
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.sshdr = &sshdr,
+					.timeout = SES_TIMEOUT,
+					.retries = 1 }));
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -132,8 +139,15 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	unsigned int retries = SES_RETRIES;
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = buf,
+						.buf_len = bufflen,
+						.sshdr = &sshdr,
+						.timeout = SES_TIMEOUT,
+						.retries = 1 }));
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

