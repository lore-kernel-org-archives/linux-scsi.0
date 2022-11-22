Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6E4C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiKVDk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiKVDkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:40:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA627DC1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:40:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM31emL008117;
        Tue, 22 Nov 2022 03:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=t8ZeonuP2WP+4WwG9P1lFqzYChkkjKPadiBDwJm/Vmw=;
 b=3CKLBtt1640XwUlxM2s8nkEha/GXZFBxvOhNrmhUvJxA/1d51Yt9kT+GqCFvtTaLjDPT
 WYq6h2el6+Actp2ZbRpsp6RfkUa2u2V2D+1XQ4DMZvH3Dtb1xKkhpwP2HiHAcRSISG59
 oQhR0W+SFGPyAy3wHkNGJgl/E9tD4x9J42uH/Euvof/rdriiXGARUDDrMpuVHBsth5Tm
 r7RR/4vVFs70lk3NWN6pDErWKkoY2/OiN2TemO/5mUZYV9CrxVF+KjjGx2Mp0aEp8fYX
 B27BZ+kt9Schpgn9wErKgjtyQKftq9tyUD7ZF5agOY84ghgEOKM5DNHH0rd3tkMXU0Hu nw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfaxt8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3J9Ln038796;
        Tue, 22 Nov 2022 03:40:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4q0hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVpNPOi8PTQrUbY5j3CeZhHs1QGMRoJpPwuSM1ccwgpSDy9wGlx9fkCZdyI9OoF6RsxS5Ug4GrdwGnqSxgW4wBs1NhTdoN9yQYu7A+qszfAL4T0H8WCBzuwqhLrk1mtM7HN5tTlUVuheeTbSc/caPzpnEiuz7ZUlhNjiNeTmWXWlzFGdfy0pjFrFDBeJXIhOMjeTLfNT4ylrb2A/B1tkm9BKJyOgDx9fv7UQ25gbpA1CuzURXmOu3P+5NvcVdqZZvEV8yymka6WhO5ufBldc+l3zFqpPDR3RCryFq7tJ8JDM1s13thID50J/e+ht0mfLLEYRTnaHR714QMaNjKMS/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8ZeonuP2WP+4WwG9P1lFqzYChkkjKPadiBDwJm/Vmw=;
 b=dsWHz+F4NMC5HVW3UPJJTpOIq1lbdi1CCik21yJuXi4KJAmKqekbu4UC7BRzn3/fmgQeZlMto/EddCkTmYlBTMN+iqrTDaq2mHClukAd/vaBRYp3auW818QqEbCoEBqCOHGRM9tp2sLMu/YxUhvMxaB2VmJfmc03r4yxLcRuJgE16UDfmvQH9EJXwypzXGUd3kGD7PkpCKSGMm+4Do6R28WD7GNmofQ5VxlzTzAaaySQ8h40k/diurOVQbNpKDd3IxN8MLqreq72iYA7fwFYMhgTHc7+GYzQuPQM6Mrdu6hrgJG2/rtQMtHWBgvWcg3dyoEtYgIl3KGkgBseVVh3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8ZeonuP2WP+4WwG9P1lFqzYChkkjKPadiBDwJm/Vmw=;
 b=KTZvuJZnni3Y6QraTh/zVL1/NCl8+1EQW2vcUOB6xrXUSWJ2QGIfuQ75UCymewTZewJh11YPjHhHNzNSHTKMwkDSX1QgtjsdMpHHH5uSwwcdBQx6BOl4D5F0JjInbPfjIQhjCmhEHEn6Vn9/Kni3LSHlWrvUn6OhPYtozxdvbaE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/15] scsi: sd: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:27 -0600
Message-Id: <20221122033934.33797-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0030.namprd14.prod.outlook.com
 (2603:10b6:610:60::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d9bf53c-29e2-4abb-211b-08dacc3b51ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bo1YFXiy7J51FAJg4G4WA0CKu9mKYJbIUW0YHZVuQmJ+d5zVKTa28aHPDZPse6uv0cJhl28hgtznUg9wmex9C1po126CBZjCdvQ9H4J66ius24RZgCdr7Swz0yqS0pp4e3pf8hr07tI+qXsnb0X+vI6UTnec4HkoVzIbpu3zSSFiG3tBIFUOJLPbZ3C8eaaDRqZtAoW9MQ8o7Rt8/OQS1sGUeedOe+yUh7ryRpqCW52z7/mZ49LAxxBZjax2yJYfbRL8ILl3URcqxNJVOgGBEJnayjY1Gimr6cx3Gtbxc5onEVnZPboBce6O0Vx2w7+txMsoJYclXIaA/0ziC1j4BmDiH5tsaz+kLNC85iG3RfTIBCTa4AGjfHxYWEurKdO2M54PEeucWZw/m/R02ZeraSakb6LIyybGKmHWRK040oqEbbiSOyzu5WCqvrf1ASnr3PmCY+Nfc6oRDRbebEawxjxjlFWm2rY4YBCpEQsCITR3dwySCGdEtTE9l9YDw3H/CXZox8/bTX8Ud2H3QYmMarBFDcCUw9nqHMfDR1SxzBh0EZpbYp1VWmkGSU8Yd607NN1uNa4xgAYAPSpcj9uI/0Y2RTODa7XSMPlLk3XW3j20+MSun4QDFowZF0EmqSKLQscXGE1biuqB2pJDynqMgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i51CTzAVpg4PoDzeahsszgPwAskDRazWoo0N1yfkJ/p4lC9rT+RgAjZis/jj?=
 =?us-ascii?Q?PAMf+rZ2Psyik4cao2uQN16o5fhmUqsTCNdSILlU5hIK3mL61iKWbvfJZY8C?=
 =?us-ascii?Q?QQ5Yz8Sky1i7cXTJl3v2O/hSAUNdN7rCE1gTet1HLK7Crc0ha0xrKtvkO5EU?=
 =?us-ascii?Q?UJNg6HcGnJ08TK23F3rjdB9RUTCdWAm+uhyLqY+K4Q5wZ48F3vqS4yyfTxxn?=
 =?us-ascii?Q?M9SSzMVE6g+bl5wm0EFp8sqJk7Xv3pvraN9+CQ7FxCwGvPI5/5w71N1PrW69?=
 =?us-ascii?Q?ZIZNPjvLi058JgGiGkPCi5Q2h+BXn8y6SE6vi9wHRnaebasrVVZ6CXRJFZvt?=
 =?us-ascii?Q?gGhOr7BLTTENULeP4vNxwNLhnBgKyrRAk7PxEfC5ZRWUSXHf+fi6cj0C0SoE?=
 =?us-ascii?Q?afmTUGAUijYG1JkfBAb4j/JRET844IAqGzJurMqEAdMge/2q44WH9Y54/SCU?=
 =?us-ascii?Q?N7HuYZWG1wWncNf0XGYvLqhfrUvnIxkORoqOkTQ4lnzN8pgc2eq2eddKiU0T?=
 =?us-ascii?Q?82Icx2/BBsmhc70YVAz92kH41YJnfHYtREJDnptaCsvMu0ajuW6utM55ZGi5?=
 =?us-ascii?Q?NFnTcuQWTTrPlN/4vuVTmz/LBcqCSR50Ml4fOHaI+7BpFZfhWhMCuh+kmNxx?=
 =?us-ascii?Q?lEaDIXgmNidhVIGRa7Z9jP/FghmEMqiptCAYJc8Wgyq5HDb4uLp/14zjhr1q?=
 =?us-ascii?Q?60SDMWvhrqbKHIhuq+aRUlFz701mtNu0nNcluvHkhwTZf+bwfSKHM2ipDGBD?=
 =?us-ascii?Q?q3ZQlKEWPAMopgG7QasfGcQmvmwOpbdHfeww2rSJIu0VmOQSeb0bf1dSVvl6?=
 =?us-ascii?Q?NqFb7kGWAA8Xa0KnEVnhJSGH2SX3vZkjrhypUU9d2x2ysWDRMyfpyE4KJwRp?=
 =?us-ascii?Q?XVnialWPNe9tsvPdA3ThFDSeL57VIwrcBkzPIWyhS8feKltv1ap+qfcFXmfs?=
 =?us-ascii?Q?pUeWPk0/gz4ThA7+rg6DNF7yMpt7CBmywnvdvQ3TJC3fKb4k2Lg4eAH0YVrS?=
 =?us-ascii?Q?oOcv331W2dk7vwF+PAErL+MydolmAUhObRXTOeg4YII/nOdgrEC7UUHf2iCM?=
 =?us-ascii?Q?+xvEeQP/9JOCILmcfi1jkUWYSK79PNaekMNDvy0tpqjswIReRSp3BDu52FTf?=
 =?us-ascii?Q?RgZk1VF2uMMiL1A1NSM8DAbKPXInSBqnN/uIag7u4+Fr9AWW9/JcGJhY3njC?=
 =?us-ascii?Q?rJySk6iWKI5XEUHdKAqycjmP5hQeXb6ALTLCBNcHo5vKpkerT0dV4Xud9iSc?=
 =?us-ascii?Q?DBYKIEC13CDwncV8Temptl5dEn8ZE6D6jbgUrXi+k+Tat58VRYClsPkZk80N?=
 =?us-ascii?Q?WvhKNza2zCj1xdc7t9J9F4xAGd6qUI8/AL/iTF13eDWfngY/Xj+uvY24/HhS?=
 =?us-ascii?Q?v7nyviPMV2/R39A84YC2yNe23nJCYRPJ2RUzlXtj5k2xvtZHOKryAY2/vJ3L?=
 =?us-ascii?Q?m4nd0tWD4uZYhHZxwBd7l0Yl/xAzMOESqbI1ETgCskgfpxj8ECn7sPgu4/bu?=
 =?us-ascii?Q?dyefYzKrvAdCf7xdvv0Onui+Pnr4fZv7EDbB20HPYgyA+TrZQAufrb0rYCZe?=
 =?us-ascii?Q?PQZyFmI9F20X1BQXFZeEpRlheO4VcvOr4ypjexLWpCoTFtuFqSGWKOTJWhAO?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RoD9nTOjOkeRdESuiCwYrs6WwRWMOIWF1xXumgeWCzC9sT0GKRLBzkDOK9YGiGL07d6T78tXa9WlHVBqT9nxVebth9x2Y+H+e1fRwQSOtUrTb2iipkec4n0mQSIegmbKyKKIQBnydnRoAb++xUIt40p57+jCGw73PP/gZFPBUOhWiTR8y6rT/4qjUae/7AFtsjQh/ZoyV4OlV4TeeCJsJE+gXMsLslU6gQy1VKmAr1xyOeSi8YfZerBNRRIh1E54ueauIOHVCw6OWTs7mZgBMipeMWRNdCPUOV6+YAMaEZjtnQKm6UvUs2CVs82VxoIiBpow/2R4d6uz+jL2yk99BkyplsrTYMEKUTu9dC4leLZ7kNt13lIrigvpPLFRYVXlG9xisIVIyifZ2u+a2N3EC+Enp90HX1I4yjuZ5vP3Fj38sHH3NH4+qKOMdbb5JIBVPZg+d9nRaV6YePQLDirbG6AfXsgZqlov/fSxbczO1OZTbgI4h+Evr7E8M4GL5l7o9HV+VEhAWpHeFgQ1QU9jK6h7XsG1AKUsBb4NPrJhkXe9NvbJ7d9QzuNUWu7OdPL8VbkvAAdA4002TLyL2xLVBx7ouqx+tepRJo8Bj3vElRI8ypo8ZTfNeOUBQh0EQ6d7ix7bd/yEYIMoBIuoFmvuRuSfj0gzqf0TKojJDWQ6K/CPX0tFzhDOiuAgX8lbJndIDt7tYqys1GPOy2/SLHn0ZFKen33NEJeBbJ2BTgPEFqkfs8ulYtgtpira0aRbrTvmKalDdwg4kT8AmhWr/u8UC4JivmI3L/VoCs3W8LwJlT6T8jXLJ5PzADNkFxcDG4N9g06F2wnq2JJKEST3MhreAdmLT/5Wvaig1RiKVHzlWDmRAz3MPTQyDdGbg4XClxOz
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9bf53c-29e2-4abb-211b-08dacc3b51ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:37.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNi3HF1u1zgsbE++KatTcf/v8oRfgpyxPJ1iUwPgu7AfN9ZEQAvueL8gvEMrgvbS9dP4TVeapBe6cOpv6nuhlzecFm5cZN6jNHrsfmAroUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-GUID: DKjM2OPfkZWlNHd8L4pkEK2oBofOovtX
X-Proofpoint-ORIG-GUID: DKjM2OPfkZWlNHd8L4pkEK2oBofOovtX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sd_mod to use
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 77 +++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bc60ec91dc8f..678f2f5e7813 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -671,9 +671,11 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			       buffer, len, SD_TIMEOUT, sdkp->max_retries,
+			       ((struct scsi_exec_args) {
+					.req_flags = BLK_MQ_REQ_PM
+			       }));
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1594,8 +1596,12 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				       timeout, sdkp->max_retries,
+				       ((struct scsi_exec_args) {
+						.sshdr = sshdr,
+						.req_flags = BLK_MQ_REQ_PM
+				       }));
 		if (res == 0)
 			break;
 	}
@@ -1750,8 +1756,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, &data,
+				  sizeof(data), SD_TIMEOUT, sdkp->max_retries,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2095,10 +2102,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_execute_cmd(sdkp->device, cmd,
+						      REQ_OP_DRV_IN, NULL, 0,
+						      SD_TIMEOUT,
+						      sdkp->max_retries,
+						      ((struct scsi_exec_args) {
+								.sshdr = &sshdr
+						      }));
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2155,10 +2165,12 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
+				scsi_execute_cmd(sdkp->device, cmd,
+						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+						 ((struct scsi_exec_args) {
+							.sshdr = &sshdr
+						 }));
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2305,9 +2317,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC16_LEN, SD_TIMEOUT,
+					      sdkp->max_retries,
+					      ((struct scsi_exec_args) {
+							.sshdr = &sshdr
+					      }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2390,9 +2405,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+					      8, SD_TIMEOUT, sdkp->max_retries,
+					      ((struct scsi_exec_args) {
+							.sshdr = &sshdr
+					      }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3641,8 +3658,12 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
+			       sdkp->max_retries,
+			       ((struct scsi_exec_args) {
+					.sshdr = &sshdr,
+					.req_flags = BLK_MQ_REQ_PM
+			       }));
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3782,10 +3803,14 @@ static int sd_resume_runtime(struct device *dev)
 	if (sdp->ignore_media_change) {
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
-
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		int result;
+
+		result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+					  sdp->request_queue->rq_timeout, 1,
+					  ((struct scsi_exec_args) {
+						.req_flags = BLK_MQ_REQ_PM
+					  }));
+		if (result)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

