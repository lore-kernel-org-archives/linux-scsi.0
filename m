Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266F5C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJWDI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJWDHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D8472B7A
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKulHI017954;
        Sun, 23 Oct 2022 03:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=gsHI2OvS+F6AClpSK/mN8ujawQzWrPrn0fklaZaW+/2NCtssJvEmIgsMETk/65zY3J1w
 oil555UQ8ols1Hosfw3/XEVvJGsAXzTIV0R6mrJWP1UoQ1IVUoYo5pCnKFJCH/98uk+K
 LDiPPjwVLf85h94i6lSs+Izlu6T/Di5lv2jqXsZ2v2VFORYM09eo2rFftBSSHKUcYpTj
 JDl2nSiQW834lZZtLhDE1weqQ+ZzEYVsWmBjgZS8+owkQIrgYzauo7JxO+4xtZLhSxEf
 1T4YmOgLQe4A+3KwGUQDzN4vysiDEbPxw3FhPl0S0wIj58UTNu4CeXdDlL1Uuo8G6v1x Jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJXlt1015307;
        Sun, 23 Oct 2022 03:04:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2g7sg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLeVfb7JDJj9R8XdlwNe0QQDUbcpCsLZqZP8O3T5i6fVDSyjKyWkG7W597O+Lw5leoefw8df5J2jIb/alsDFSsaIle66wgqmiHXGhsmWaCN2RyHRJOwVi0pFHt/s3EkFW+S+dYrr4nzD5nwpX2beq0w/BFfLVtbwSTKwiGoMa/70eWTF5jS3U1ebTiGiWVzq4jWvuUCiZ/7rclVb+bLVPqcPxaLpDj0jj1JVqzFEEH5lua1KPWiAb5X/qD+q1lYzDUeiGKg9WDjWepj6k2//IXj6ndSYUk8I0sHXUEVvI5GM8MYOQ0EXyBDPBWrYCZsqgE5AI1OpmSqrtrXu/ye0Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=bGgdb/0aFMD90kI4KmwiMaNN1x1MkuL+6M1ZYTRkOdnRguPtO8NfeFFhou7bcFKdIQZOrGWnwsAj5Osr5hFYpklLQvbbzIY+hqgvA3NEiaEQVXrma19nhLqwdlZ9CieWH3uXXuJKK+HNxDa6y8EzLs0RJFO3u44ioFWDWT9Ynl2y5iozu9vrfA2GJ8fAFDKx5d7QCYtfqBs5yXySRHP2fIJN48BB4fHNP3cAtV4iB+QTPyWItMmHPuH7k/+1gBEiNOVtX+dm39qzxc6Hf3LJocaZCzR1aWGI+t/DYMocorhVw8UxmvzdTnVDAJIlP2E9X6sZI0lCMxmlZFUTS1Pv0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=FXoujMNKVb3qiAFXsRxj6be7y+iPuV9fo14DJq+pLU8lt+LORmO6ZhU17yRkozp02fvQexHstB6SbObCDc38M+ysxOzum0Oonac11Nd3DRTYHPDXOA2xLqsAewzajLvVa4luCzFDoZS8dtNLDKiwac2W0uR0AsAqc+21hLW6Vog=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 24/35] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Sat, 22 Oct 2022 22:03:52 -0500
Message-Id: <20221023030403.33845-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0358.namprd03.prod.outlook.com
 (2603:10b6:610:11a::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 01f3740e-e42c-4898-6326-08dab4a355b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/47sCuQpHWmdtDhP2caedm+scL51LkL0y6jAzAGD0f/1AxtK1fuTWkqkasMeJEGnAp8+mAqXTUGsvRURubZb6Nt/YJLXevOU4E6Ps9a1N6eUhX+ZnODDFgxqLeZC4p014X4+m0kGSlZ5lPFse6WEkChCfKXNXELiGJqNP6zbq94EXTKYUDVIun6co19b+PL8QB87cfd7S47/qtRwulz5sMR7sk4lSKJl+3P0od5/zrBhY1EA7E6zSLfc+lJyD3akR5M/XdSlmYUiHndAQnEMq30zKURPFdYUZvUbbo9OpgzdZhvUywEn0Y04nd3cOnajxxFCFKaHg1KQULLDF4eD24tmM1n5Fic/wingIsuomhutQ0WrOhj4nakXcsfNgtxqeqCzmdRoMplQVGJ6rYjH+gWQBzNhc+3SkwQ8Yub8429Qk8PsF7tJgnqSBu4tk4CAAXDpBp9o3gz5keTslWAbtFNjNxGoDSyAosSeSXpwVx9luZvxxjiY/sAMTEpAANG3RryAY027b8Tg8D0tGO+9GamNrVpl+iyNUkSWiHf6/WVB6nWadEpjnuG/b3y4E85NIg3wlRGZ6UaOZ6ymiu4+AXVNvetObkdkfZykTMCPGIZzhmzD1nAiC8vLyHawh5Ij9z+eRnUaY3eEQAapQKQsWbSpNEHhSSgHXrjCurp5aXBZN8kVgXL0TFHa9Sx/J6pfKMcti0ZCqCJrOa0IdGKKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qRQFObZ5Zm9xzo7cvtpeniCCxns6brsODSSaCRK70OyjWpsSPYpTTEeNN4nr?=
 =?us-ascii?Q?YFCDpHt8c+8XSBWmRhQFO+QaJxgYGY0M22qMO0SvsqWJbjYA2HIGZyfhAR5o?=
 =?us-ascii?Q?zcTPkNE8x72TYHC4FlEaHJeKmBE4pXMJyUwQonLyIrRmJKhnG9btdChwv10X?=
 =?us-ascii?Q?BEI1i9WN0Wi+RRDxUWkiJBV8CbC2b8iO1R+cWl6D7J9P9iD//LxFV/Fjr9TK?=
 =?us-ascii?Q?R9MQToyCKm7Y3RVbk8JtlXzPlFuTpBRydDtVUY+CXYr4pm4SakjbTis85m3s?=
 =?us-ascii?Q?qMtfTo2KzioIYXR4jHEjjB+q+2jlTWfYdn3W297aRQfvM65jgJ/ZRi+cfXKU?=
 =?us-ascii?Q?luGEPt6kbf3ALRsPgoRGpeaV7TXidH2XuPspn4AByjugni5X+2orhurgfH4N?=
 =?us-ascii?Q?vI2xGX1qfArGXXBI/LL5eZcwD9+TLFxK0NAd9AXDZowS9q97obopJN+Kct7X?=
 =?us-ascii?Q?1+MrZ8AoyGjfnFWoUAAkFV68n5bQUON9zXPj2Xmt+bOmYJ1UD9aOZKmt/Jht?=
 =?us-ascii?Q?UFjoqAdhauBUwIpQsfNVv5kVuVWvVP0sC24eaP6WgI+92rSfS+5Ag8brHVdt?=
 =?us-ascii?Q?fjl37yBkrGJBKlKG0hRZz1ihFEyjq0uqukfw+lLcXFuJ0UkCS37SkxPZVqzp?=
 =?us-ascii?Q?3RmStx4LowfQBJkLIP1BX2tiDM5BdgqRc19p2RCquvtWXt9J8MtLrD2K70W4?=
 =?us-ascii?Q?Ea42e5jDQ2MNCRCdyHqTOhydtsYQWd3CTNBJNgafTdXVjagN8SZiRBKfrBhM?=
 =?us-ascii?Q?8/ZBEOgXjehurh0PlMQIxaEkAXcuOuI0abSKxw3lbe/LFg2gMvW7dFsRHToo?=
 =?us-ascii?Q?fUFR/v2k7sSMwuAR5MfsQ+N638Bgew+HFoPkSHPn3VwJmA623N3a6oGWOKWo?=
 =?us-ascii?Q?jH1PpeY316wLrNh91+G4nVcUt437HAXrFJVetkvKIBVfWXnVKNxQ+PIs4TPw?=
 =?us-ascii?Q?VIkNbW2BvNZyjg5kIe8ZsU+Vu+VGMqUXdsyjnwNNTad/5iflKB/Q3twp2I63?=
 =?us-ascii?Q?A9UzgwFChgMh871o1NNT49E1ln/kPgEmGIry1kIEIgFENxnnYsnftpI17YiS?=
 =?us-ascii?Q?RM/6QB22W3aOLKdh8jeZH8M9eReDuY1SdyScOVBIdf7cVcMXzqgLma6QdYkp?=
 =?us-ascii?Q?pkeBVoA2RBeEnXtwOUzTXcMDiK2TipTcfbcV0MYs9LpIwprg99+vl6yfD2m+?=
 =?us-ascii?Q?BuapyPlxUIr+lKX+nWIk8c8dYvP7lpHeasM/nL1hslEwMnvyHQbiNYbkYzcK?=
 =?us-ascii?Q?jFSNTMl/cDfgcjQCS1zlMWUGE+XgGWNjPbjlqRXHt+SNrW1a921msSBgurKs?=
 =?us-ascii?Q?XFDTpmqaF/Yl/qF6sNi4Bg8VkePh5/izGnGc1oIyE258TF049PiEqR3tGJ9Y?=
 =?us-ascii?Q?2jXhUQCDrL/Oek0bZPNDdlmFl01ef7jHJgKRFN4WOXL/0Nw8b8mUEmVuLK0T?=
 =?us-ascii?Q?lbwhsoRrSd0n9tSoNw/EHfYu1brSPILcDDxQRbAhKfgLnjre1G1ubbw/ph7Q?=
 =?us-ascii?Q?cEfx6WftoHEGemv0QmhEz1mH227EgMhxpsPYjBUJvNk9bJysgSUb1uRWF9yi?=
 =?us-ascii?Q?lhbl8esmJocUCU5L9yk07fyaDSEBHf7jONAdyUFVRTMGWgMbT5m45NI2PHAY?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f3740e-e42c-4898-6326-08dab4a355b8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:43.8100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVwtrDP2Bzt+tAfA4CENRF8PSwUEmnSgyne4IX5YIiaHToQFnNsZaTvquJ4fhTSCrXu5Gndsl5fwKeGgpXte1CPgOCmLCWc25ydVEfA11ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: zuXQBv6u80upqfk107Ir5y8AIoWubTyV
X-Proofpoint-ORIG-GUID: zuXQBv6u80upqfk107Ir5y8AIoWubTyV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 46 +++++++++++++--------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index adcbe3b883b7..8c09d512a415 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,8 +82,17 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -94,7 +100,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -108,8 +115,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -126,11 +131,24 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -138,7 +156,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -149,13 +168,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.25.1

