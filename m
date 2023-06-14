Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF14EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243316AbjFNHWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243322AbjFNHVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173082972
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:42 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kCOE026738;
        Wed, 14 Jun 2023 07:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=OGqtYj0pWb8SJuBXnMNMM+yuNru++g3o4t4beGdcyNQ=;
 b=XhYvannnxsUsUokgP+v1Yg75EsDIHE3+Hu8bWpX/7oQXmgByElqeD8MnJwjYT1yVvf6g
 bUrz9B0KGf0G6I0y5K7mWyrwSfIbukXxnqwCqAqiLSB56yYyKOt4Yg7OmE+ztZqovxWN
 qL9eQnWxPicIzFAISxbh0ROmRRK2yJ2DVpVbC0eyMD1b21mrRvAFa8iQiTQWtR/+iZyX
 MnqBlu1vF7H0lwTMtaQOln7NnJ2/MRez+uLcpH+7K5MvG2aAZw7cKDjA6CdoMe5baXou
 LXOgAmB4yRtYxF+3yXEnYrbGJdqoPFGgsG1fA/a8hDBZMtXIz8gc8F9hdi7Nh8gKV+RK jw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6rjNs014164;
        Wed, 14 Jun 2023 07:17:54 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4x1dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHJ42zqfgIHBIaBwUHuqAf0QhndJAzJSGOAijPpWpyEEc8lGB9yPElNy4sHx2XY00zILxbOlUs6OLZ0iDv1uGw15FxmmjI7nmsgkeTWk2GWnOZqWg/MykCRM696iuCnihXhdCTIqu0egVUlCCAA/bQnqHSZmqbtq5BOwzTjMW83tzZAHf+kagqijLmotVA6seQO6cqGVEMVAtHC6UH4cmgDivANXi+VAUpjhRLw25LMJWbDfudkFwempi/ThGcgwopLmPYYh6XIx75vP/1mjWBqHJx03iV6C/SUC7KbRxgflTKdyggZZL+RZInIXqpavcNaBgLKfy2SvUBH9VY5FcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGqtYj0pWb8SJuBXnMNMM+yuNru++g3o4t4beGdcyNQ=;
 b=ZWcPhFDG+2APV843v+VdwZRdUdBsgfzygVtN1OxErjYCaBNaSgGlYshxBCh5J0J+09q5y5tQ/fuLIXLE4LnwupppoYDSw/9i80a4xqGd4gRZNzoIh9xisTpmOs6/CJJPBMSbcRUz+DeFlOSYinCWr2XcS7z6dZ8of7JCCMvRdnf9b2Nn+yELfStbgGE04GrZScpVw2t/ve2tlg2q9SHmpmpC0kEf6KRVjvDWk4Ca+WCt3NlEVPcwkSZUD44JEBAtIJJfjpM3UAl+NxfZvMLT9dBgaVzAsTwyAMSgAabLJ4eSq/jnCJh8VSbWQ4D+9ZTptGKtcr4IT03EgCPyG9E+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGqtYj0pWb8SJuBXnMNMM+yuNru++g3o4t4beGdcyNQ=;
 b=PhJPlrKn9CdypMRs6bOcsAyPjitZS4j1zigI+PF3YuQxfv887H8sARFa2uhDHyR9dYaiuEU6v5lCnmNkv7SBz6M5aWzW/W270ZpvUy/8Cjq4LQqUooB99yYvOlXYIVLF5U9FNK0sL3d44yfMv9y7+Zb1ixXUK6fD9qvdJA2roMY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:51 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 17/33] scsi: sd: Fix sshdr use in sd_sync_cache
Date:   Wed, 14 Jun 2023 02:17:03 -0500
Message-Id: <20230614071719.6372-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::10)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: fd337c6f-a678-43c0-240f-08db6ca77717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwCdgAzA0AqDNhyTKQLCdqZcFO8FmmQTTztr0vQ2Gul5ztoRQadzVDjHdiIqO7VdgVcCl0AhkUaHp4cWrkB7QmkD28P5WyndFB0FlIgfAqn+5ve+nGEOniHnFxUuWpBewpG2jn4gj37VNHSRFbdjChh14qG0rezxUclz4TZIA6s1gVS6IMxUOBDU1MzwHMhjGtcYgnYX1YwhJuZyUVwcXZb9J1RQRChcbhZlL63lhsWtMXbxaVP8zYlLCFtJYvwpV+wArmGFccnUTy38hXyEWgDyTseR5ZXN+Plb+W7zq9VHuBpub0NYqOv7QDKd4D9uWuhX/nChyGPNGkGDKgNS0a4Qq0sRMgyrBsOoi76zB8DW1GCePBBWXIbx2LEu/6XzX7ZlN2IVns9TRu7GaCH66CN/WurMZwn2cDmW+EvHiBc3nFoJIx/LH+7/D/LfM2jXKbPjbA52sH/HLzaumn1B22xtpcV7r1d1BKD39Rqq2kEkW93sr3TELA1a+e1q6A6RogI6j+Lk2FE461LurG04VMZVJGxGxMZEMcUpL7atKn6L+e1IpANphzdAZ/Hnsz1D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FyRPhVHdK+0jE2wn7FAAckysglG83KAGlyykxJabJrADJdYfAVGgPLoQMUpr?=
 =?us-ascii?Q?dIcY2Qw4BXlcoNmophKAZENKILnyT8iClThbbKhjgkkTs8hWPPPdkqzxCGbd?=
 =?us-ascii?Q?ekihdGAwDa30RVplEeaapFeMZFs+q/WtQFnq4D/ON63MHxm0C5167w0VP+fB?=
 =?us-ascii?Q?40ItSsqDjtVNV98RPrvWpImnu25/Owc+le+SAI55LxYUoi2Ga/arP9cqTwTB?=
 =?us-ascii?Q?/wZSg3NCrdjMXhAJ1T2bi1RFt0mjFSvA50oErw6JYR3TrquRz5fCtZ8d9EVS?=
 =?us-ascii?Q?eV8832tM17GRkCAW/dQwPFIbMkW7Lm0CLEOwch+2gZptWQ0tdsTmMH4AArO3?=
 =?us-ascii?Q?g3t7d6XDjKQKCoidQ0eeLKMRijczamVKlr1VvuFCp+XuInvCG1UcrgkKgWdI?=
 =?us-ascii?Q?6uA3dqMqVZhF2WVicNgUUZQheSKiAnwCmhO2QIERX3fi9UBD+6m6pYMvhuxu?=
 =?us-ascii?Q?3H5oYTma1DhqjGI5R6IG1XLR9PxqsgQvkOXsof7x5znezgv6IWQwtnicAlwo?=
 =?us-ascii?Q?YyeUONqzmp5UDTuB7Hss8hmTMEKmOytq43W0utk2bq7Ge77Rku8JrV0aQouo?=
 =?us-ascii?Q?DZN7uZf4zzj0MuwZxuGLh5kTTuc78timyY3LWBaW8xMsf+5Nkmb0OG3we+vk?=
 =?us-ascii?Q?nT8MH4s5cwJwRdLvE+jpAvcu/znTmMXdDpe6yuFTVQVB4IaLjyRmiPG7ZyzF?=
 =?us-ascii?Q?2iOyW8aCVpE4VfUZk2Iv3CkvPj9gKo2Fi84DPidSR0i6nEFEMmByG8gYgnYO?=
 =?us-ascii?Q?L9nxGRJIXWnrfJ7u/uyjsgrynZ5Ho5/1QONzQlC82WtO7yzrJGKP4FXFB56E?=
 =?us-ascii?Q?TxHPGmsjpjU9xVKkKG0qhVrpNNP52w/VL4jek8knv7+6it7NOg/kN5FcK/qF?=
 =?us-ascii?Q?xeot9DhgI9vCblRAd6w55jS3coGe8skY5F/HvV/ZWeyEXmASgx769isd1K6b?=
 =?us-ascii?Q?FYegYOjbcSKHcz3YY0mV1IgTUAiFJIkjQGVmaYvnwLt+N2EMxuvMGsKq1w9L?=
 =?us-ascii?Q?H+FLaBEY5Gd61Z7x2tr2fvIZxJSYWt3EGs2GiaSgiPNrqO12TUE+SKBXhRBz?=
 =?us-ascii?Q?Z4QBjJ7bGJvcJsjpR2tdxMgaMRBI9DKa2POGNbORq1JXKq7f/pCMBNm79Ai3?=
 =?us-ascii?Q?DtG9/Q0oTWk5mz1xQ4zxyWxozf7olZYAIaC6bFhb+4TvMjx5XKcsnAzVNzx1?=
 =?us-ascii?Q?JQCNAaW9NGZIakIQes5QNERvrtDaCR3UNXiuEIEuJFm7eA2TNqqai9l7SLzQ?=
 =?us-ascii?Q?B9ZwF6Btyt2PQF2nE8d49DZJ7E5yV1IrzYed4Vt+FklKQutqQnjpSsQPYf6A?=
 =?us-ascii?Q?EYSXFx01CEPaZk7Xu1RvoFAdtGWuSZ4MFe/vPoRUF3kyIa2GUySBqdT8J9cu?=
 =?us-ascii?Q?EF2nPSaETi7qSz4Q+g8nWYvEDiM0bF5gkqC+biTikp25cMP5dOvTp3XSf5z1?=
 =?us-ascii?Q?KjOiCmtp3iU4tDGcQcNiEtoMM1qLOLCeSQFcpdLq08rqSOWWsgQ99bidfOTq?=
 =?us-ascii?Q?tu6cbWIRt9ZgBlO0cdwwdj2V7b8vk2HFpew9vdixJZdftR1Q/XJRtaT8XX2z?=
 =?us-ascii?Q?MFAMZrtbeWZnU6uwXioYXXMmxzIBpuYr96H/hqJ/ZAv2DSU3D7T81YozfCdY?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tIx8scc3iW+/TAc64TxEhHugtd4Bj1cTMtqUzT/IWB9nD2CTcjGiOTLX+eFemn9VgHnzVIuLl27SsX1zc/KQfKWhr2ODAQ8BBDRBH9LbyWwDh+TIrM6OwEaT85zgOwTvkcsx4S6s6/U6uiYz3M+rB4kcHTh+QSJtCBfgDHYGUgVnOvAFtwoiG/+9EgbYCEddYUadwWtA4ruT4Jrab934SFIQA1Vtchop95PFbzusNXB46p2C2EFdf74SSk33mgcEVGvNleHg4x4qzhEHU0WKUvKshXdhNgY07k2L5BJQyNhbi8DFciaoMxqteAEuKC8fPBpuuVATZeVDEhJn9No455I0z+zFy99B9aXq9W8+CvGeOOxzOqYNiq9HjbXTbNMuVKTihku5qWtbcVK5WGZAY5FCtBE2kZ8kgflg7gNk3IgZZa8Anu4bE1RyFDaUvXJ7oSA0vQ+donXlyxLmFfeEgtNJXzDbMllUcBe7MSbXcn+FMvmV0AbYefVgfHLNtqsJ6Kj67clcRXceP1tGYTlJFbbGQBmwlVmup83or+olcJkkhBAUZR4nyqFQU/R+SfYybtm49wDnP/PugFTCWn9w1N/0BN6amUV6F5A3E2WhqAyy5s/JhCA+u82kiseSKTYbN+2HfGPnUyJdM6djqR9soK02tQFAf/A7qf/bRMRRP+jPAd/dcEfcc8tMLGcWDJDOUcRBN45Mlsr8YO8Pz6Ss0tYDIDosliWK/+nccSmjL4fVp9hoGWIZO78+8lUp7NzSti3QHe1dMGmisnKz452kqTAm7czJXI7+W0emB60Hx/y3ELDRnLAM1ZIoloCoAT1X0yBv+Htp8cGBOLeScCWJkwWDTqqJg9L/WplKFXzbhQ59WVpncG2bIo1MeWfzdGM/
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd337c6f-a678-43c0-240f-08db6ca77717
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:51.7367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrOEet1ukyblExe3LZox53MIgGcSkPt9PKyWXD3YMM8SMcU6Y3cgCaQACkBAgun46J5gVjnY1tY8k1D0jXWbXHPlGpGTgwaEA69rvOsRrPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: vmt4zxBFWy7BfhZTq5u21crurZK5vGRI
X-Proofpoint-GUID: vmt4zxBFWy7BfhZTq5u21crurZK5vGRI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so
callers of sd_sync_cache passing in a sshdr cannot access it at that
time. The problem is sd_suspend_common doesn't know what
scsi_execute_cmd returned due to sd_sync_cache converting errors to
-EXYZ errors. The only error it cares about is ILLEGAL_REQUEST so this
has sd_sync_cache convert that to a -EOPNOTSUPP which it can then check
for.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e67a3d163b24..bb2e5885e41b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1604,24 +1604,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
+static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr my_sshdr;
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		/* caller might not be interested in sense, but we need it */
-		.sshdr = sshdr ? : &my_sshdr,
+		.sshdr = &sshdr,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sshdr = exec_args.sshdr;
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
 
@@ -1646,15 +1643,19 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			return res;
 
 		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
-			sd_print_sense_hdr(sdkp, sshdr);
+		    scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr->asc == 0x3a ||	/* medium not present */
-			    sshdr->asc == 0x20 ||	/* invalid command */
-			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
+			if (sshdr.asc == 0x3a ||	/* medium not present */
+			    sshdr.asc == 0x20 ||	/* invalid command */
+			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
+			/* This drive doesn't support sync. */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return -EOPNOTSUPP;
 		}
 
 		switch (host_byte(res)) {
@@ -3849,7 +3850,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3861,7 +3862,6 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3870,21 +3870,18 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
+		ret = sd_sync_cache(sdkp);
 
 		if (ret) {
 			/* ignore OFFLINE device */
 			if (ret == -ENODEV)
 				return 0;
 
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
+			if (ret != -EOPNOTSUPP)
 				return ret;
-
 			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
+			 * The drive doesn't support sync. There's not much to
+			 * do and suspend shouldn't fail.
 			 */
 			ret = 0;
 		}
-- 
2.25.1

