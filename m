Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A340BC6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiIVKHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiIVKHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9892DB6565
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA53jD023889;
        Thu, 22 Sep 2022 10:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mr+A+RrREF8LJAJhSHufqfWGdHn1kz76hIun2vI8R8s=;
 b=GSVHIHse3re1Tvn1GPPW5Ewfo6yoUOkSnLmUNbFSwDfpSFl3c2xc6xJCwB7xQZc4x/gW
 O3pqRiqOz6G8nGk85ajIfEBPwVVtRsrdPq9q4HMM7qwrsj7+6F7aA+iH1lechfr88IZU
 kfnusHgAa01VpqyJPbFb0HwnjNBmltbXLSw08Y0MwxpvA1zC40QrA/2vSje+UVZKPcTz
 84lksZE6/tUVTqnyLX0RaV4+MO2gC+nXsCw47Lw/lMy1f1JLgtiO9QynU68v2RILKpJd
 xCtDl2Y/X2JRbavxdPskOzcFYgiV+bzZFteVjRimtiwsJW21/OCv3doUiKtWzFIY6q3Y Ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0mn7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lWe4033863;
        Thu, 22 Sep 2022 10:07:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nedps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkoGQV6uzS9mK906ydTcN33c/i8EPRFxyLdWYgVqZr1T4vwjEcv0EDMKlSiIx8Gbikt1YVVn3r/bLNtJBCUG4IFEj8Z4Ak0/Zjb5FQzJ1X3c/HaJqPE85ZHyWmt3M/UQtm/oQQHsoEexwLsl8E48M9miXkNHdRyinS0NpnbPCCbtXAPcffESukdkf8QmFbOs6+YYMfEl8nP3RbC8bSSATZFGLC60hyKjWn5SAyR9udKhTEDPvwA10wwCkqd8SCg0KHGUF61J1gosMdV1y088txHn6tuTjmobEj0tq+/Si/TFbAzVm8mfHPgT+eRsGE1KOTobYGBcn2Gf0qBHmGv10Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mr+A+RrREF8LJAJhSHufqfWGdHn1kz76hIun2vI8R8s=;
 b=XGzjjQCMuLEg4yWjVv2TW+xThJ0HL7HszozLt8qtcdaVg/WqMK/ZjqD9CMa16AfXMk/EoTGM+ydCjeZ04vrTjfsKfWcZVAL7RYAD0jJzoZmqtrnZM9pahQfqP+zt4CV5HmxyNG2yaP1rOMq3d2AU/uw9o5HFtWDQ9WINwcZwaJ09mFMdEnEiIFVk22VefKl3Wx08rRLtANFQc6ikVDxyfsvD5dztoRXOnDx8nMCDAIeSbfzw/vXXNX6KValJUGZCfVYHeyZ7nblc3+F34eW4kQ+UidvnNDEWhJ8YXIHYWBtxOJPKt2WNqMWkc/pCXicLrejFNatSqodf0MkQJ5TrVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mr+A+RrREF8LJAJhSHufqfWGdHn1kz76hIun2vI8R8s=;
 b=Kg7JsIZxcus5J86aNBmVfA3Ee8OXO1if+mlGH/Dv0qLdVqU+8/LtYhRTZ5+gNAiRC/DQtmv9glYNoa2HMXZIsuZKcGVTBmiyEkesg8PJN6rwZdXRDcH+waXQKyOtcXlu5NKaZ3evhioqyLGgUaTINA+Fte3OI4K7QXIDDROCByw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 01/22] scsi: Add helper to prep sense during error handling
Date:   Thu, 22 Sep 2022 05:06:43 -0500
Message-Id: <20220922100704.753666-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:610:57::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b42ee44-3172-4879-41ee-08da9c8235c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hIJTufhg27M5HzrpWu8PBPeSQJKKJVhdC3x3SuVqHr68zjVtcqmZSb+vLD0HNm5dzizzP/FHKQCCAvxHweG/SFOnzZErqqwx+m+uve+gDcdyPlHRHv/r9XVxYuLKLVtRArEqXyAnzq9pDF/gK0K3/e6AlxAMZCn9KFLjFyPxwOwDaD6jdCO7svB+ppE3+51Nxq6HfhugK+v8OCz9NcjS0IOPelHjTAgRKDscNax+y+y71sy+OGpybDmDGxMzO81hKy9cM/+7Nhijq8v/Ar/ZbARNIrB/HtvkjgHQvMNawm7FDFgSWoHvTuRNpIFageir3M14XhSuDdGmtdcd3GQm9PnEcFMFXndPTbHu4NG2nX+xDTciglk60GcasZOKgR9MmGxBQU8E2mWK1ogG6E5YfjpXCT3NYuEGnGFl507RGekZpis7wO7J/86/tdROWBR4hciD5Y5aEAn7YJ2Pzwmuia0i/tpGsdcwMgXHM+4YyzcWUjt9PqBRTF1Hq32dgWrPczQlybfpahl3QaoQWSblsqx+rlO3fuDUGNO4n/YFtcnUBny2qrZg5WTPgc10FXrSUvqXA3lXmTRB3PXXkK+sDdA9Q72XRFtrv3Q7KqHqrrP6xdTJGhbLyPRrBIXmlaw04/Ga+0TKyBI40pdOPFv3cYkcbppPiPBeqkxs9oOhr5eSKJovsQlRgoHMp6/m8fcZrPsEFIGOKgH/dJNfPRuT/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dNYEnYr3Wl4Lh3jn7DbzFaCfnvfcI1/t+ZvipAlMAXKt16xuKqB2ltMaKITH?=
 =?us-ascii?Q?Qdsz1bTEfnuCFrN5Ie1JjVN1aiiX2JmiJ5EqbNpt2cRB+wDjqfkqLpnHldEi?=
 =?us-ascii?Q?AKAcXHqk/PdPQCRfYooSXosuqQavJqGoSUJEE61N91oUjNdegxemtmeeED3S?=
 =?us-ascii?Q?gctqrYFMfDX2hIqWAIkBuGxG6ksMnWn4Y2IKYBN1L8l42LHN5IyyuUaoi/6L?=
 =?us-ascii?Q?j1CQQTA6dkVTZL19jB8aPlCw+UX2vYlpTMcSlFPo4FTx30z5Ywm26lsAvCOF?=
 =?us-ascii?Q?UX42i2qcFwqy9bi+5+VfesP9g5R9bgQ2DVqLflWwONcx6/h4ovE6xkXzMlhw?=
 =?us-ascii?Q?BHf5Y1gIxxGblFKakd8fNTVUycm4guz+kSxra1Bd6uGN64rukFI55e4waBdl?=
 =?us-ascii?Q?EpLfnh2GXNoww/pLu7ojTfQWHQtCEJFXQrExRr2GKxtKITMaqq69PYv5ClR6?=
 =?us-ascii?Q?7lYU8/DUiVeEl15P9ILJsyZds++wldTQ1xqx8KbauCqozCGpg432+OznnChc?=
 =?us-ascii?Q?kLJbmhmwjvRXc8R7Rg8j79k2rRYBXlPNt5OMrep4Vz0z92tCxCR94xwgeWU6?=
 =?us-ascii?Q?BPm4OJIGVdGfLqRDllc7+7V0LuG0zXMk0j/Q6hAxBGK3P5ysmmfi/HMwZzlO?=
 =?us-ascii?Q?4uej66hogdobY/duGluH/PGvCO5PsL1JoZs8EtYirwafnFG6PcnoVAVE8TUv?=
 =?us-ascii?Q?xotykT4YeOZRb9Z9012J64G6VKSjzOVjJIx3wTcP2PN7T5VLpstpJY26ILgE?=
 =?us-ascii?Q?KPuXxiwK/fHWCaejkFycSB8tdajL2p23F/82oB3YabCAtJOhMPhyemZYMmNo?=
 =?us-ascii?Q?rphPyqsNlaQTjDkYTQ/sZiz62hq4z7v9qQETsQeCZa897Qbrb+5gavtNgJjU?=
 =?us-ascii?Q?KjJd++ie/av+qDZKsAtxJ23E6GXJVptKDCOC6cCNsd+8Js+H9xaenwdwsmox?=
 =?us-ascii?Q?A1XO5YitUidjT4x8/4tPtAUiQ5FY8LQ3bs0Va0V4XY4p0UlwAxWVR8X4zJR4?=
 =?us-ascii?Q?tt6lHzv/pp5Kiac78VzijBUul9DGzs4HOxojXjEkbGxa5lN74WMg81pThTPn?=
 =?us-ascii?Q?akVHbjUbdW8lkPxXE5lluu6IW5mp90HZjR5dBxQU4GPhJtS6DwZK3lUVVUeK?=
 =?us-ascii?Q?He86+Wm7mRH8RKhyQ+jSHCwbb5SsixAGaX6bL29ifi8Rt4o8SWkNXnHfCeTJ?=
 =?us-ascii?Q?mC0CAamjfj5MRtLykb98Ad55XzwfM65sbU2TQyIuezuKBXLSqhxEdieXyjRs?=
 =?us-ascii?Q?CQnFZd/5EAyMKdwalVO7HdTbiHuhIczN+1TazxItbbuJcW7lHygXHzBcOSSx?=
 =?us-ascii?Q?1VjsRjwpMItQOAwkt0Uar8FbKXVhpppP/PfoPtvbBOkPBk5IJfVhLbyJz5dg?=
 =?us-ascii?Q?Up16NgSvuKrdLxOZz9ClDInkfz2IB06z+Jb6uKuBXwJ7EPYUdupypxek64QT?=
 =?us-ascii?Q?PmH84B4yFI8akTMdo8hQUltYMoe4BFUdPoAu3Kj79TWf5+SWDKTOD5jsiupF?=
 =?us-ascii?Q?hN0CBqlnA6c0Bg9c7eHofDVdu054vjs/pL6d9idrMuiItgvHnObrvel/U3c1?=
 =?us-ascii?Q?tmj1JBMZGavU6UsHEB2Il/uRbv7fG22JFK9HGR/XEyMiY2NdgJhKF2ABMTFt?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b42ee44-3172-4879-41ee-08da9c8235c1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:08.9604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqvIjSEh+DS1QlRCceGUn5ZvwFKE/DC4/vboCPx7n8hQ/UQkbv0ryOI8A0moQpApO3md+61gJCrGI8AgdvUgRE/TdkeGlyoQivtqjSadA4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: AXyPNbr7vj6Ckspmlm0lEZifOvsVcgzD
X-Proofpoint-ORIG-GUID: AXyPNbr7vj6Ckspmlm0lEZifOvsVcgzD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b5fa2aad05f9..5fed56b6b7c5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -519,6 +519,22 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition scsi_prep_sense(struct scsi_cmnd *scmd,
+					     struct scsi_sense_hdr *sshdr)
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
@@ -534,14 +550,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
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
+	ret = scsi_prep_sense(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.25.1

