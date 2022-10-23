Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25613C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJWDIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJWDHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E62691B6
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:01 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKvuVx019443;
        Sun, 23 Oct 2022 03:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZX0kC19HqVBQAkII4+hiPB/HcbHfedkV6Cr4nvIuXVU=;
 b=Y3YaGBwuqUVKrFu2oSrBvmiIBuHJHxxIrkvyce03I34Xg0pLOKmr3/otdl5EA0rCMUZI
 63wJBY9T3i8XGfC1fgPNdPytgp6mHHzLwDcLp1qz0bez6Gni6BHvcQ15GAsT2HrmW7lX
 2qHPeB87bImNtKkj8gsa6xVlrZvgQxJYjgS+Fdz+XeaIqtqpQKm8g8ZbI0PmL+1o6NYy
 2hLchAzn5h/cshT9hnnW2loMwhSEvSQfF+pba0uIJGaQwhVDWH7Lb/ExNPBcmYihQHRx
 OzVoWdTCiDOYX7oQ2g75mMcHiYDTXlZqK1LcnpMtPfoO5D3/DGpWwZGBXrXGCm8iNTBA +w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJXlt0015307;
        Sun, 23 Oct 2022 03:04:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2g7sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vz/RxSuvHwm/hHlrVQTR4+AcHMR2d/l+aU+r/IreX5akY/LYFdUnw9pg9Xq/pTBN3IJx/ZaNXumIOTzxfCYHFydcqoTiHKWYEyKaE7hvuMbfcY/UhWwpgsqLuvAwHZfFPq7sp2YgPIqjLHAUuyaMH1hSEIIgmiuPVq8rQC4A+RML4a9NKtIWeWOBIwMflZu/Lptp81ZDTeJxLdC1Qdc9WTsrxV+Iox5QU2AQu7T0jBNsp7uetAc5zeey/h4sEgvLh7h+fFTEdiDz0ud3rx60Y5Ecr8cbz6D+1A9Eq2L74Nr1atqlBp8Mn1/Fq8pn93zTIsOM7yHVIKW4hVg4sZczkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZX0kC19HqVBQAkII4+hiPB/HcbHfedkV6Cr4nvIuXVU=;
 b=LgrSZ3uyd8NpJfM2ucEPs+ph1lTPfoyvPLfFAP71gAUGAskHRKEpJSdkviZJO+VBHwt+48T6mwirir29vwV/nLjFpduJyAOuxLKKQ3p9+GQh8bVltETFO+QCIwOuM9m7fGnThHJyj9A35DWBAG67IxkdbEY1bbn/nGgBfZ/gr99nbvUt804mdQlkw94KcPqgrHxNuM3lDZGhFhnbc8hpIj+31vHm9Q5nlC7h7VkwtMwtsO9zN8EW7+1k1QgZVxx0oyRoU4JZUFUF5w2jSiBkMLLUxrd3g1Pdz9eCJx5OjqMpMALUTfIa25csRZtfdMscLe/CBVAcG9Tqv/KFeAaobA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZX0kC19HqVBQAkII4+hiPB/HcbHfedkV6Cr4nvIuXVU=;
 b=jdkRcBL/s+OfWsei7fo2LZ+j7KbK3L7CBIRrTYkChcxr4optfCFiNcG3/4e7wHAQ4qP3F6sQWJmeqZC/M45SPkWmivgS68fDPaqiTssEBGdBWMBQF4q8GlaRzkURUg64gXUWAjM2dzNmFplW5OI3ukPEA5yQClILlSCHTEBSjig=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 23/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Sat, 22 Oct 2022 22:03:51 -0500
Message-Id: <20221023030403.33845-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:610:11a::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ffd05e7-7bf9-420c-c199-08dab4a354ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZwQ61Qll3np1fqvGKuz/1xGBScBkj18EC6b+d3f5HOy48LFeLnmTKHuS6arHL2u28dGE8A2TTIH74IGnry9Uz7YaEf5dYQLO0IW+vbYUti2uACx4h2K0YIfwXdxA32N7iFz91EBQWNSikZ5dKpIuCWfOSsmGjdw/Ymq58kc38Eo7hFWr+1WvSnHtsBCK6AncB+TdUmb5sHpcuHICMlGDS2Yf2hveKQVNwpSrTmjI64553o7Tycbcm1zavg4r0GnQLwkRj+sBx7pwSCMJgTKzLMZrNmBKNFrmlbMmMYy3ioixn8jpCECU/Mpjctr0kS/2wcBZOeQhqKvRkipg0k3/QPXDszD5FSHb9eGfInklfLipvX781wuTOnqtXImDCHJs+HsP8LWZh25pF84SAtVoEv2XTNYTpnGkEf9Is+qirBUJFvGRbuuSYKH5Nvb78Y0OrPBIxAlOUk76bXB6eJGUpRkPtD7SA1bdHpjxr/eBN30F86bhSMq9npsAJEwjrr67mWXRqWdaIqqIudQ/PiH/8hOIWbZt23JBmiXTMSA0Fr+TMSHnC8a3PEyxJkpc3HUMHXGgGud7qKSvH7aDAvzvR2dUK8dBJF5aW0WTPxo6uJLED+fPh2QBvDP8C63jqQYhFRvbKkB9d4C1jC6Mqj5ZFMvKgLabu59iHIvzK7xlnUY9f9E5RoGMX4R4l3gtS4MIC/rIDXvxQi+JzQRlVewnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+GtCcP46yKSP98SH2UqGLEiIY29PStDQw4qDf5tVEocm7Ds176xYwvqXvmYC?=
 =?us-ascii?Q?tiWSZ4++vMmhbjTyMOitDnlwVd3EeC7qLjBH5GnVdsUvOrJyuG5ckhgrgpNI?=
 =?us-ascii?Q?2LpR9c+E78JaMg//gdy35Z137lzeSd19ilJGDITENqYCtwhd/SG2AtjS928T?=
 =?us-ascii?Q?Z+wK88W0bAqsgdNt4m1uVpT8xViqEwvZ+HmPIRLvm2h1RM2z1vHDYYJloUZ4?=
 =?us-ascii?Q?fd7tSVcETG7bzv3fNIBrAEcxN91xYFiq4cW37ac8f+LOfENgMpXLvoNixk+1?=
 =?us-ascii?Q?EIbibjIuFLs461w6SbI0rUwS5MiLBxtWbx2qdfA4EcTPbm/5FYOpuVdgR4FF?=
 =?us-ascii?Q?Y5tZfTiQeoXEpBbLMd0QB6cPwwXdGoLQb4Vf4aeXYYNzTw+393gVtxJQNq7h?=
 =?us-ascii?Q?aBC3bAaYSW6vQgSQGs7x/y+XN62Uo4voFb+9BRTqwteR5862bFpnY5GAKEi1?=
 =?us-ascii?Q?vz+TddY1y+rtN1xjYWdWAmH+JSd5bxZyHLcT20l089B5HpXMqiNFsIIFapkt?=
 =?us-ascii?Q?/K1Co/g4P6sXtBougTVofg4X+Jed1ooOgJJMUSxo1ywaIhbK6h3aYI9T72bx?=
 =?us-ascii?Q?aPDuW/rGq4KjgPnRqz6s4qE43amwedDdnrwERNFgQNZesqrRMtNfZdeW/2Zk?=
 =?us-ascii?Q?bG40DZ4APs3m6xjgjls9pMygMq+uvEZlnWprp6yhe/Wzy0EUiASt/kf/kdCs?=
 =?us-ascii?Q?tmspLndjc60td897KzWsPiYAbzg14lLJwYz1jZ53Jtni0Pi8lnf0I3UMY7MQ?=
 =?us-ascii?Q?na0vG1vBrgMaaSA0xVukQYqmrWmvzdeDhp+oqLiLfsoAwf/aKuYgeHSs5T0A?=
 =?us-ascii?Q?CK0O3QVJBPW0ny5HTdhbnd+onv6ge7deFPWcE/E6rZWeFWkGnZiJtcuWksC8?=
 =?us-ascii?Q?+fpO34Pkdzy4lR73D1EZpSV8c+jTF8Jgu319vkqUiVi+TRn+oibYW4edjNhS?=
 =?us-ascii?Q?WlYlKYHEPFGi3gTkeutRY1jJ82gc3frX6TdIr6r+6y/UQw/fOjxXOEQPfoti?=
 =?us-ascii?Q?TiaTOVIYqmVLboK583t0Y0vRvFCCckHwX3qnEWL2lnN9B1jQ+TouTJrCwy8o?=
 =?us-ascii?Q?R3M7W02qjNRyjPpBvnk+ZSSufYp4cJVGJ4bQ889lFBPyhNiYvAPJBxi4Nu/X?=
 =?us-ascii?Q?MPA6ExZ4Iw777g12W8hFxLEZC//c2IMpKnM7NJSPoNwMBbbtyHN0gLxb0gRU?=
 =?us-ascii?Q?PibUQt+oFoZ093tE0gCTd9I7DjdX3L6zw7VuZCV05G5UrfTSbU+504hGhQYq?=
 =?us-ascii?Q?LS2rPgUCEPVE1ebHJGpriLechY6c9EuXnkUY6WZO23MxW9aVjl7QcF/eEO+p?=
 =?us-ascii?Q?vvyhvYYHpkfPl0gJ4V6f4XY6dH4DypgtjHtIuZbhpzRhvfTxBV7W6zBdSZLq?=
 =?us-ascii?Q?hia3xH+cQxL+zXHhSVYAMeHcJzIK/SFinWA+MuQfjkQB3ODxe+yliepxduFm?=
 =?us-ascii?Q?TQ3SXGiXOWw9ZpT1iBGoikRJ+loxmM6qGengISbomhFzYMDqRLn+MRu4I5P5?=
 =?us-ascii?Q?+10GQFMwpXm4MrqZuzALcfsbdg9LYZpE48Bi8bG5xdTbkZtuQhhltZVbqFSt?=
 =?us-ascii?Q?LUvkKgvu5CQDwTBQy1r0GgD6S8o++N/Zrdf0hM4usNRfvtGhb76c/pDXGe1R?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffd05e7-7bf9-420c-c199-08dab4a354ce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:42.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJjckgVcQLnYfeyzAt5PmiSMEj3mLB05XIw+jX9DTYa3lrHiuJA4pbEitHd8TYuzm08xebNn5KiRQ7WzjQT0OKB6w7pGbuqLci+Tv6TKlR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: X9DzYa4fxG-8gyXIZgy7mef2wZDdbghq
X-Proofpoint-ORIG-GUID: X9DzYa4fxG-8gyXIZgy7mef2wZDdbghq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tried and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org> 
---
 drivers/scsi/sd.c | 93 +++++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c94c3cdffa90..700b41c856c9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2062,52 +2062,66 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
-	int sense_valid = 0;
+	int sense_valid = 0, i;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
-
-		do {
-			bool media_was_present = sdkp->media_present;
+		bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		for (i = 0; i < ARRAY_SIZE(failures); i++)
+			failures[i].retries = 0;
 
-			the_result = scsi_exec_req(((struct scsi_exec_args) {
-							.sdev = sdkp->device,
-							.cmd = cmd,
-							.data_dir = DMA_NONE,
-							.sshdr = &sshdr,
-							.timeout = SD_TIMEOUT,
-							.retries = sdkp->max_retries }));
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdkp->device,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries,
+						.failures = failures }));
 
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+		/*
+		 * If the drive has indicated to us that it doesn't have any
+		 * media in it, don't bother  with any more polling.
+		 */
+		if (media_not_present(sdkp, &sshdr)) {
+			if (media_was_present)
+				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+			return;
+		}
 
-			if (the_result)
-				sense_valid = scsi_sense_valid(&sshdr);
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+		if (the_result)
+			sense_valid = scsi_sense_valid(&sshdr);
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
@@ -2138,16 +2152,15 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
 				scsi_exec_req(((struct scsi_exec_args) {
 						.sdev = sdkp->device,
-						.cmd = cmd,
+						.cmd = start_cmd,
 						.data_dir = DMA_NONE,
 						.sshdr = &sshdr,
 						.timeout = SD_TIMEOUT,
-- 
2.25.1

