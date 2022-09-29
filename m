Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD95FC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiI2C5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiI2C5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41436123DB8
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:57:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TQTu011065;
        Thu, 29 Sep 2022 02:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=oY80lP+f+rOpJKW7MrFJVux+5vWAlNasEHgSPvA0EaQ=;
 b=tk/bzibDGDYyjflcOvQ+qUo1u07jo6Xp5rD1z7cGj0100Q1WDt9aTIJLVo+qU+jnPTFp
 av7WigmcEW0UNoZGzM0ePJd9ng6EPn5tZrCfsR+M6rWgYYWcXfQKdpdIY4xSDk7z4eNc
 xwd2E1xTLDJXIdbtwkFUYlNreQp94/G/QMs1A7Ry6ATKn5uUN1yM7bvA3pN/sSLmzBrX
 nuyoI7ODVcSJSw2CdSORNrjssA+Cbrs0moO0NP0GgcNxe/mQEm2LdKh1huEXeuN/mR/O
 vCahMUw0ymYYFAxuNJqGExIDK/gBRHsLbkx39jYrWeUU2/5nJ5Bxqy9mdy1NLp8H1S8i jQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0ku9mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T0kSR8002257;
        Thu, 29 Sep 2022 02:54:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6v7m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAm/WE1hMToLncucNSE4L709mYC8bjuXYTPnZwprXYUHrmX+iyWdX/scP3/RcgHjeh7S6OGz4bBnNy7IggFGSBNUkCroB6eZnV+ARDBf7MZKP1FNa79VFSUfoGULlME3gKcsAu9c9NOC442Mg1IIuUDYmEAbc8rUIJnqskucihjm+SmKC9tZ1WMuuBaBQ+RDTNHMSChqr63HFJgvQXscJFglRqVrrWrp4pko5licUu+FDbnUUOOfMyB9io9LHnh0nEta8ZMoQHiSpLdfZVBIbOGpHaIT/nMKNlNf/UA+ZSS6TpCM9kjeXF5oeAiaTRvXwEe6ns0/B0TJzqiMWuZ70g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oY80lP+f+rOpJKW7MrFJVux+5vWAlNasEHgSPvA0EaQ=;
 b=k7wAZ4eYQf4byLY/fGWcyRnC9LhP7kFnMi+SmrBzrrTx1a9hUPRgh9hAQtKYOr0bwIdibyN927+02x5sK6SCjufwRqFcfH4XgNuz5AZixDpjomDUC9VmOiimZBhhED0g/fGOQ+R2UDq59Y0LWpa/1xtlDTE8thlIZDX6RDV3R+T1DGoBk/fSx+dwskASn271EiUI8LkcdvWQwYNuIcvT+d8dHp8JioKwOnCYjYuHWON382SZBZXlswY6Q/s8pYHfk30XcxSbqgqkyeCCpNdGEGP2yn2PbFwLF6lw/rU5qTQzf4kKJ2chnHdTd1Ygrwj0nBr+lR4U9VT3draQSQgpFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oY80lP+f+rOpJKW7MrFJVux+5vWAlNasEHgSPvA0EaQ=;
 b=RFGym/v+ar7CD7S/bpZk8MUrJe1zgXGjXsXlv4tlOAUI5Cn/alXVffX9GRk44Sn5Y9p1TY19OrKgxjUCqHHGrX3tFzaxPMYerFoLNYOJyKFuB7wxMGpxnJbCn/2MMHifmZBIx47T81Fc+dz9vtEBSgXqNhSgaTeri7zsQnIRMJ0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 29/35] scsi: Have scsi-ml retry scsi_mode_sense errors
Date:   Wed, 28 Sep 2022 21:54:01 -0500
Message-Id: <20220929025407.119804-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:610:4d::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 043689cf-7423-41e6-86b9-08daa1c5fd80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnsknwN8R1TohEUZT6ibHlD9CP98/UhpX7OMRjKzVn1/+lFVPDDS/ziR8hfZl2ZXBIA9lDIig6l97idV2Weq4am8kVYyIo8go8zbcSwXwSqBslpU7D++a89/XpDGK+tcMYldkHEhYI2nCLB3u8Ky4JS9YSRsfCQCBMjYwz0Sd9KfYwf5PQpA+kJfl8V0QgY8ZGtDzo0bqgsGSOlO42b1sY1qvzbrMc0oW/4OZFz0VHQo2LbZojh3QEIWlweFi2+G1hiynv0wr1GinZBL7RQe63HAT+Wloo8eoqYSBkEyoTcxPAhZSWnSDRGDO3EvP43WR5o5sw5FVBErn85pltTnsge6hsxJRUo8TFhFWr+fXjm3E2mMvbJK8SPLVR9R9N8K44hRQE6i4htMHDnslGdZPGzRKiemEnwf8MF3ORjXIGsqxSXY/fkYYHFion3QAXlN08Ce3tYxuurVBhbE8nr/+2qlQBRZYU1sk1Db1vBVwyeKXzaqV6WKQRkgmJK3Wq1C/lL/cmH23pp7Q4Kba5+Nwl4TmerTYrIAIhjEBLWSD1VJI+wQvmGhFA1vM4P0l9TeLWvePprYTIXNdtcdm5zhYIpInku5AFjzoUgPDwufK+ogsWnjDOqc613DD43O0MdZVR2ZwyHqx2GqpuMd/pKfnPS4ederV+C+UvcBmYJ1UeEfy5B4aHI+M6rWE0YYUB/NtKoIRdyD3kOx/uiSPKFa5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I7x/H8MBhYXsM2nAZJ4uHBYaHTdQwxfAMdfPeo8SZFCHbTFbkhnU9oVfBjWM?=
 =?us-ascii?Q?osAbqjPI8G2TkXPdhUYEXTthhCyRlM3xO64AnW2CG+h7rDtQdBmFoShPFTS6?=
 =?us-ascii?Q?7InQFTPPjnNC2fWJbSNCleUrUMXqFrCDhCp/4dN62GMjHOvumAu5KSQw1bkn?=
 =?us-ascii?Q?03AbwR5ivvGqoFx6dMzpOUFoWVsjb5aooGfV55z0o/O0jBiyQR+WCnmOk42F?=
 =?us-ascii?Q?Kr+PgZg0w1v0u1lJaBjOQzeVTYQeAavG9kRtAHrOZs5u74tGmOvE6kcH9j7r?=
 =?us-ascii?Q?d7P6HLDdSvQkxnKiiYWRgWzdVtngk83DCJ67R7dIfc/MBe6OjEim9WKOZXRE?=
 =?us-ascii?Q?ARi7bfq+KIlftbCFXP+iconW3aF3ek9x8t0Nu6DhphTebGP21f6UymSZ6sVf?=
 =?us-ascii?Q?N72UHhcxDWIgYImtzBcnASVJzaASikLTnfwLX8JI1qesRWm6+qSOLVcoTrSF?=
 =?us-ascii?Q?xjRnwMCIaxnXeB9xnZV9yWCwhEz849mv3dv3U+4onda7ap0a0md+NK14Ko6b?=
 =?us-ascii?Q?LcheNkhXSOTomhPBV3AqLTgIvBVNAxgDwi7m5Xug9ueIqqYZH0SyG1AypA67?=
 =?us-ascii?Q?DzJtHVdaHzL9V2FHGFd1cx4bdzRHG03L/rZu8ry2U5joOZKTbuMnP0KWNDiT?=
 =?us-ascii?Q?Kh/0nkd0ZtNhBRhBQf8ACebhvId6gYFqsvtyDnKv4hj/+nRWg6/3a7jF5iKR?=
 =?us-ascii?Q?14VU0C3nNYnidbtgZcxWBR2MAn14XzPZblVoSqBMt8wuthc7zD/E/S6e9gKK?=
 =?us-ascii?Q?M/GPn23c3xi41xn7e6VlnxIXipGrBF9qkP9xWBWE4z9s0usEPnvGwCsuPBjT?=
 =?us-ascii?Q?n+Uy2cKP/unSx/buOhXYHx6T3epJtWkEM+aS41/tTNr43c8xF6vf+kY2sNct?=
 =?us-ascii?Q?YTPSxQD+TEInOXEqV1f+/EXKqD48q11QtgsSTFTflIPCgkoLiy5TNdFNBRNW?=
 =?us-ascii?Q?uZLY24HVL2WPTDY94WWPYRQX4NyelCTLzBunnH01uOibbc0/spvhnDnOxt9g?=
 =?us-ascii?Q?FFYrRrv+9YtAjqycwC7OvORUZPTxCnFYlK1GlD6RcXbqkcQsAV3n91wX0bNa?=
 =?us-ascii?Q?UAOOIAs1V+uWM2Y5vvfhWFi5aztGip8iJVfIjqTOYLX8z8l4dALJnLrBJKTl?=
 =?us-ascii?Q?O4SP9LTSANmimWU6Z8h5PU9zPk15XjrBruN5v2JPSwnswq3+dzSKAV9XDQJP?=
 =?us-ascii?Q?jsW+iL2EWsi6KNaDCcIQ6PZ70PVdavoUUWlP84CFHs42G6V16f2srXUOHLis?=
 =?us-ascii?Q?KVzbsi/ssPkvOwyulr5J+p5o/3fSwqdjKYwoQmbdJHQGNti1sWB/uenKRJ5t?=
 =?us-ascii?Q?25/oGJuvmBovxF9VWD7/9h12eRJrotdTEOgS+MEAEF0vp3NhU/+esGjt4cAq?=
 =?us-ascii?Q?GONVdo+ZqelQvxQOiIXQ0Vmuk05/f1345lubRVvYm0PDa8jtl5apWIn6hjhX?=
 =?us-ascii?Q?tiRZcCP3FBKgqkx7Dvo9SYm9Rgxun0mfL0mCEcytnvm15ZTMNGqis7qFj0PH?=
 =?us-ascii?Q?xymzqiuCwUtAu2NP6BLyzRYMn8BrdxAE0k/xfzP8Zq3hXk8fnKkUYpwF+5Sk?=
 =?us-ascii?Q?cE/a4LD1ZKibP0Lo66Mk3yp8EYxowpoCNDrAtzBWar+ZeZzRXCAqv4BJts8V?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 043689cf-7423-41e6-86b9-08daa1c5fd80
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:56.0971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IihaR08LmH8m6bS92X9NMiCQTm9PpPKaR7QIJPIUkzLCLzAOV8QmHTuKo83L9Z4B2rJpQ+xD/zudMMyZS31WzBNgtco22sf++iZsXRLvCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: 6iHk8Q2PVm404PBAg0aiCsgw2IXesyeC
X-Proofpoint-ORIG-GUID: 6iHk8Q2PVm404PBAg0aiCsgw2IXesyeC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9136a3dfcd67..c7efdb00baa4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2160,8 +2160,18 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2203,7 +2213,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					.buf_len = len,
 					.sshdr = sshdr,
 					.timeout = timeout,
-					.retries = retries }));
+					.retries = retries,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 
@@ -2230,12 +2241,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.25.1

