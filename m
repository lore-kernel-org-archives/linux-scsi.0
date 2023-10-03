Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ECBE8FDB7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjJCUvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbjJCUvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:51:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70099AD
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:51:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4n0q014375;
        Tue, 3 Oct 2023 20:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=KvmCSuVrrZzXdQLjEMW8wOf600yxbRLxRd0JCSbsAtY=;
 b=wEcu75Z5IDGxTAFx7xYGsb2xsJymBz954Sx3t5LNHvfCsCB/OoRHcW02adcY3ck+90d9
 OdHIiO9Dig0lwCD1jjk7TZaayt4FbJazJXL68WBE7CjL40UcP9hu1vjkzQQGl7AFCbc6
 /hfxLHXDz84A2Jyw0QQTcfn6/kEm8M8fNoXkOw3tqovAWiOv3c4uStKXWjRUrKWzEDx6
 /a0Y4PC+H+zLw4W97Y7bUdpdccXrDZbfD4BrzFt+Z8jP6UzmKu9BNIBHwRHjO9jQbRcf
 6t4Im5u0t6qUMZNUMhF0ELf8K0hYVW7s8QTrN1e6JQgEVylmPZMaEY4Tnon3Ffaro97D 2Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea925ryb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K1ipq003023;
        Tue, 3 Oct 2023 20:51:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46kv59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NO/3582Ljw9DWKS0XFjcYYiDq+9nnupL5YzRpo6pnzgj2dDhpSDYni/sunG95DoI5UP98Qt/0PikNRph7bp80oc6ApVkwMildNcBy1WL5queadtu9Q9p9UNoyJU0j2b00+aY6Wmw45zZPIuTMsnbmTOEy3y9z051U5iCmRB60Pvg5rfCxnmsKOOl2xYw/hyCiGsKlxHH1/IkWU+R1HPRCFcia3g347lniVDBoi3QNyrzNw0zP7SK/w5UeET2jylphAfsPFu4U/xCElzifkLif/Y1BPNVR7Qlbaj0ReEPwR4IfNYVzru6C3SWw6F5gPGfyvQSWV+DGyI89nxcJqd27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvmCSuVrrZzXdQLjEMW8wOf600yxbRLxRd0JCSbsAtY=;
 b=ZACAttlJuTDT6wCk2MM40e79ztxq3/cXZZ9RqIQ4wTf6w+AG3THYOLdHsDkzv+Q0N4/jSc5kE/tlPNDrppDuU38jISlQPjUIVgY9dT7dipJ+T7yJQTYYfPSUHyoCR0zR84kRFRHs/4h/T1dybiR2wPvRuVfKukxK+bXQHPhp1dqRQvfjWvG+MTqseGoRG3qaOz7F0cB7//U4Cmx+q51SCLePgr2ucNOrsN/SYK8ga6ShL1LHsD2uMSGhbx4tzvG7UJSqKrX+0YUAVj4qLCCCGXPk3ACiu8FfKNCIYtQdmdbFviwZnaMVyIwvupoiUZJmHgTjmwb7ZoxEBUOgGazoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvmCSuVrrZzXdQLjEMW8wOf600yxbRLxRd0JCSbsAtY=;
 b=zaPAZbqcnyeoccQbAGgLReYxMwAoaiMfd4COOkBZGusAPRfqo4ncLbML6adb/4iecLhmq4LLC9w/lUZ2I+A4N5y/JapyQBwBZSdMuqYCDiqxTp4+qKKQIB7Qrpkgnrh9RuM+ZYRNOzIjs7RgiphRzEMLilmlrIkIYdkZvWnkMlQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/12] scsi: sd: Fix sshdr use in sd_spinup_disk
Date:   Tue,  3 Oct 2023 15:50:44 -0500
Message-Id: <20231003205054.84507-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:5:3af::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: beffaac0-7b6d-46d7-3d07-08dbc4527393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKtz8Pho37P+Aab0TV/GU2k0AP2QgBH12G1PQr96lhNBFARZraVZ8flvINm5WH5umPQc2aHIVzmKpsWdSZOyby6lccDHAQhAG+g2kH4gIJA/cYnKMwg9KMmcfX7Lf8L0aBE3dGfdR0PHbkNObY4pFJyNMJAw3DABK2ZMkcIJHgCkP1Ut4aSkbSJlGZ+YO4AmheMk1M9/MDYDSX9LB+N1otTcT8PvHqZMBx5sjydv3VZQkTAYEEvwMjIXxXuqYOLtEDOdzgOkQZVSIC6PDzMHHuKmFLQ/augy/QUlMC+jNnLVcnv55jXm/vP7bAqtooQ1AjtOpn1ZmtbZIpxjMb7DaRrWtrWvqzKxFAP1vVy5R4h9WUp/Anvj3XyCQzhsUbKfOkqvm94O20okNnjszAQEEFoQpYq4EPy6RR4N/Svb0jES+SvCy++Wu6dRACLsw7lRTC7DwZXCLyoo4+5hwN7VnRIbAmI3QIfecNTFdk+p+BT9TY1SNNn+kgvBgH139KjSnID1BRLVdhnQ2C3tSKct2VvO9wUV1tRCgj1JDScUeLP/gf31c5lbhhpCEYJkcbYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gPSB52y4twZ7vryDWrLY962iNYuqa0hEkzZLt9pbqY866+I8APkAWiM9QSFD?=
 =?us-ascii?Q?LukkaP2w7mH7EF7Bvs4/V17QDaO+dugRRutjYpm0VW9GGFQHO25acC4bzuvu?=
 =?us-ascii?Q?hslCa8Jfaz7gVbYKorb5NwcRcCTu2/sDZ4zorQbljZEPa+qpzBccypxEzTSe?=
 =?us-ascii?Q?mI7CiOFkhCPtZ2ipDmwpREpZYOO4CO4muV2yEvg2GrJbLKQKVHcoOiJzjPVC?=
 =?us-ascii?Q?5hq4DTy72gSEXS+zRAzlR9mwios2YyOcsDl7/CuDHlzo8n0XaaE73YqYl1Qz?=
 =?us-ascii?Q?qqwmDNWwdMsOwZc1oDYpHcsoFUH20F22+FqQL4b7RHhCDml9Rdc/YTXSacAo?=
 =?us-ascii?Q?/MCsJevops31Vjqx2K8l3woDcLtEMz5SfCa+WpWV93fmkVhta3iuF+0rprPZ?=
 =?us-ascii?Q?QmdsC5eyPKagFqLOBSIzEG79oU9CwR5gCastpCn/7ovxfG9IS6ITyBPID3zy?=
 =?us-ascii?Q?v/FKBnh2Ttc0zYx3cGyprvEdTM+s+T/fQ6txDyufANQQfee5oDyCwEOYENan?=
 =?us-ascii?Q?JcUDqB35GDOg3OSsi4ZUgBnXufUR0bkbDid9YqMkPRRBqYD741DNkuxvMZAU?=
 =?us-ascii?Q?L+z8WBC82xxg6xp2U06F66VVqELBIEMJiWGcp0W5M6Z02Lye/5hDvHaTAkEY?=
 =?us-ascii?Q?2slKl/klfoJ3mwxrES/rD1FH6qWJLkmuXHG99oRFtmw5L6MP8CM95ZpMjYkU?=
 =?us-ascii?Q?Avw+h0Ukv475F2cwOQxB7MMTrPDhFwTnCJY1z6V8k3bqMqa88nItpZkQClr0?=
 =?us-ascii?Q?iL+oGqls8pLYtTz+AUpAEpklFtaak9JLUzobjlZrDgxst4s+jbCqld7e4D1d?=
 =?us-ascii?Q?Zd8S9zNaViNkBOvU9VZzsGjX4x3JT8RUszLRVAB6CF9ZB6DubIbClVFodIAL?=
 =?us-ascii?Q?XGHFTuToEdXbaTOxz6R3aSC08gKcVR1bdCMC8OXIyjyfaqKQCmItH1abTufr?=
 =?us-ascii?Q?R7/t3xT5yzuHueqaLwYyEXd4kBC43356bIZcIY4Qan0SiW/u8Yeol8zLNJGO?=
 =?us-ascii?Q?XS43JqEbnKzZHdl3AAs7xLY2dTRQWz5R6Nv0V07/XEPjhdntBAQDXDz+J5WC?=
 =?us-ascii?Q?7jqMnIxBJF3b0qV0YJNLimPzAs+ekWpxNLl+LV/PAoOPwc0Qg4P8Mt6LpRN1?=
 =?us-ascii?Q?ANRYxdUQMrDHF1MEhppo92fRBM6CgRtBPler4MnJ81KWfV1kPT69hMJmOom/?=
 =?us-ascii?Q?pq9DSCSLl/QK17BRcoi/PiEEBf1gVZuuApAdXirtTj6s/raOlGPFUH6J5huH?=
 =?us-ascii?Q?0U52NzyKh5+8WuiQyonCaWVvzTC0yzpQs6VsLq6gJlxW5xLD2GaXwumO1T4u?=
 =?us-ascii?Q?kHnyGIEaWQ8faOx1RP9pHakaY5KqkUQmdzLTWfffMZT+QZ9QmvPtRZJXn5UJ?=
 =?us-ascii?Q?C79LMEACX4XAMBNqJ7SLvrLVBytaAc1fdVpaLdUVK4csEPfnXDg1XTL5ZMpr?=
 =?us-ascii?Q?pPM3qhM0dd4948d+u50/9SOFxuFh6nrMv87gJoiX3YnQZimeJ+YUQxci8ptM?=
 =?us-ascii?Q?Wj/bNGX8+cvwONZnOEzEsAhCMGLOPUrVpAFGjS7xdQKQu8kZvOCqVAgdwUmX?=
 =?us-ascii?Q?tEjbLZaauM0ro16d90XRqdS0j7Xs9wQGEDSxokoPspH5YHTcCUR3YeXg46Fk?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BqIzaQn9KeHkLgMh9yfDuJyQo65xpIXdiF+PutnbF4KLDzRSpgjd2kblSQa5bxVeRcASWB+G4ITM5i95faGNVszwoGHZNYoa0/B0YJFSoiiCIu8HRruJQXHFT4fN62ThYEK+4KmYHs4PzTpen1R6ZYXzoQzJo05V4gih+WoKMVxAdI8kBSXaKxOSDIyoju/fIWT+B1TNgWrBZ2je+mk/Q2z1saW/WNikSIaltCDSj3vkqoVw5/B1YRMsaYshSu/g3xC0YAr0yMUoJiHFFR+CXIj3t03Fvu9SHlbcgr6EL/7+eBhZ1SQu/LT1GKxGdDYDlrZRZ1hOmb9bAcM9nUNFpXi6MESClB0zOOzuB+LTTr4HUmJQ31BMsCxFBsR+BCh8hYdw7AcW0ZgYGS+qkJ5apeEk1A6k0vMwVm7BmmiHi5QODCZjZaFdZInhBYad9xHaCBtL73KfzsR4eqBtIiPRbgQ5tLUxgSPlGqwdAQqZ4+FicIMIumOIOJr8RqWkbq+r2fYVa3xWnqVrEGWQ7kyJBD9tj1rS9EbrgLpH3WShRAjvLv0eUL3vLeqspBW7x73OJwmIabncTIOfPsKaXHJmVAhsrQdEyoLmZP/LC4yzLJm59YbESQLa4/ImQV9ZQLWehC3FTd0mW13QeIft7Go/hURYMObDrCrxnlCfJNopts38vpFx6EFLRdEBUSeMa7kfTR6pNPPVdT+JXOxUgjhpPr3aTxAg9P3WZQVXvyNiRHP8DE48aVYtrw5WSpavQEzjpUoThXCQeQ+/BJ0wUxsGUpwMkxNg0mkBQJlhlhkb4nh/X55oiFbW7LEzSu8K6GVV4x1DfcUu10ipXXeX76IcsDjgophfP0uyYTuDbH1jKKLSJN9MmDWymprQVU1xqQGB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beffaac0-7b6d-46d7-3d07-08dbc4527393
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:00.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwkKaOHCXbizAGgNnoKhsUbv+Y5WJo1+xU9RXEtfe4CmjSkSZLGfqF2zfDC2Agi5Xm1fS+z2LRlbSxu0/GIXF1XScnrzj2q5wooF2BDAYv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-GUID: sA4d0Nh2CaDYN_mnQbqQR8sH_lrBdmp4
X-Proofpoint-ORIG-GUID: sA4d0Nh2CaDYN_mnQbqQR8sH_lrBdmp4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cc78b5e49f32..dde9b6707980 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2180,19 +2180,21 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 						      sdkp->max_retries,
 						      &exec_args);
 
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
+			if (the_result > 0) {
+				/*
+				 * If the drive has indicated to us that it
+				 * doesn't have any media in it, don't bother
+				 * with any more polling.
+				 */
+				if (media_not_present(sdkp, &sshdr)) {
+					if (media_was_present)
+						sd_printk(KERN_NOTICE, sdkp,
+							  "Media removed, stopped polling\n");
+					return;
+				}
 
-			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
+			}
 			retries++;
 		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-- 
2.34.1

