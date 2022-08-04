Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53839C19F2D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiHDDmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbiHDDlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB0A5E33A
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741iELP016168;
        Thu, 4 Aug 2022 03:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=RTmmg52yunYnZHHvRKyJCmSkaEhemyWsf4GOOhkXrbE=;
 b=ToIEmwXht4TZ9GD9IkUJ8SH4kHvTh0NJ+9E0AMDsOx51pCDU/aYzo5NxohloOTIbx5BE
 CpJ0NuIaTZWXzqi0MNcGRkZWxecHE0+YY+oNL+rnDUOfVMzy5OEzBSTsIElqSwhbOCNt
 dZuRP9el7d/pBauFqZfaN5wREPpGbIbFpVV28zHL8RRlpazSi4hWA7mnHp59ssQwA895
 +aOn6JTLA5cpqN5PvOMAyotQbo8vF0ADeaTGih6E/GpJ0h1Uy4j9XeOeLvSf7arwtJce
 qCnqjHJrWUDFReD5CyDQfQJfY18dBEtRyyZIVtbliu5CXer0UovAcEglDgu1lAWI2jtU PQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu813nkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273NCUeA003017;
        Thu, 4 Aug 2022 03:41:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33w4yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQ3cd1alsfTZ0mbl6H36qqZk6kA0PEKv5HS/zr0uAaG6UuC5NfvF4lFCus4KyoOjYHYPMWSOZUogViOaBCbO5N3u5APrLWIRLM20waqNHvtOrAjMBooUVFc8jvi5FMO+FQy61yKiY75NNoSEolPBLtmxKjZOmYYC/Sp572nkGoc0j+EjDYaE2tv3KuiK/9iRzg+hegXPjNeoujK0FBzIgU4cTrgNQPa0qMsOZxCzntMiQRpX1mCpfte8aQhSJzWeP81vseIYbTnvOnUcjZ5uuVZ1n6ad279Ykn0z739rtXcHkxm3wBiDO+KNVPk1hGWi4BlrPNbetJ7u3nrR2HdkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTmmg52yunYnZHHvRKyJCmSkaEhemyWsf4GOOhkXrbE=;
 b=QQLaw3HrTRlaOT0YzdxVZRI6YkVurKrNcmJJduAhhRXsoQXekfp9rDU10EOvQJlsQHubx1TFkiKs6YwvBYrgAaTTY6Gbrss6IoNaf9lPLxN+yttRmr8naPog4gTQxLpx4KIROyTR6M58RjbifHqBvUiM6Tuy/j6MLpsQcAjHh2U4D2N3oO0toaIZfJuU5I3/Gm4oJM04tE/G7owgojfgU5zoZyRgU2Y+fv8ccgXRfx767wtnHN/m/wo+Pyk31ywfLjZUe4RR7Wk3hIzBrVk95MqKjXi5ZMmJ/IgI0QF2lJBwGmoxL4bhSBfxD4gs5BGwoIcktw2xKB2VWYclOZN5YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTmmg52yunYnZHHvRKyJCmSkaEhemyWsf4GOOhkXrbE=;
 b=ACKYtLxuGuoTYrzQbz8zEzUH814W9fNdpjVf+fCMorvAH2azfO4WT+zxkIPvy053DkA8o7C1lCI+oHGpd7uXgAuxY9k2GzGFZlEVezay+84fNz7aVOKLEwydOWsiGpxJAvMKdtacllWTxkDmwpEJrbaKLc3gYGNqfwr7kqIlkhE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/10] scsi: Convert scsi_decide_disposition to use SCSIML_STAT
Date:   Wed,  3 Aug 2022 22:40:59 -0500
Message-Id: <20220804034100.121125-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:610:cd::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12737047-2af2-4f62-c118-08da75cb2f53
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VSJG0X0CCHtEaRdZHzny+Whr+qDTEC9lVTzP3NWoa4RgbDp2AOTT7ifM5KEcuy8SwV+4SA/5Mg8yXjcmsHyxt/LnlwyunwZWAyrdiRf6K3U2d7zaH6MT28Qf+C7QcBAkDrJPMHemMmPnzXiBNCiHmINKyYKYLCPEC3vCU1jNU/+pOp/oIw2n5E3yZpMU7iZMV8RBcATl0XqI6RPZfJQaPzfrz7H8VXFNXelfzF3MhGhbCk6d6U4G2OvCerYsz/SR5JxQX1BymAGgHuM8wFAh0+hThnKTPS0Q/619a2iS1II1bEmp9crTlp9dvDHorajpr3H7NEsq0h+p2rjH2xuGoIiwjnTWxcUFazyhaWsKkvjqlz9YYJKLhw0Hs4OK16m5JysroWVWj8zgMxXwsfVIUMkgJTY8hltJR+phG/5GmgA7+3/BN142bDZHbPgYqw+bs8j7jBdxkaZAZWape8p2l8rMlojNcs+bd3ByxkwOOQsivZGE/4kcWmBRWCLKjKf8jMSwaROGR+VYtFUj4YvRXW21Fuk+OwBr+F6DBSu/POdsCFweLFv3U6Tcl8ZQYyyqOQSHRJQRBwRhE0fd/qRbQ+8IsmBDO31GFYvF/9Yf1lw5SWtPwy8sxwUuIe7nKFx10G2hYEPfGLPhs7q/P655avpSnbc2SaOBl82dPGgqxcFf/hQrQuUqBEtPVdACmDVfN/EHB4pKnov2to9Vuk0lviZRsmUfcOzWKGMC8fCHl32Bm1LrILzjqx1X7RALXCudjoXKoijFymMq4rtth8GIBZVRmtS58bZ7zKuXlSCNIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zf4AsTb/ZWR501+jejNrJZuJ8IlhFdRVjWIwDlCFcAiMjRptVjr+fdBZyoG1?=
 =?us-ascii?Q?MVoDTexma3RHMLG4e+ICyxdPSD8xmPocu887G/s0fTzzGwK2GZSW88cgk/5I?=
 =?us-ascii?Q?qPV8yvDK07jMIJR9J3xEcirHbgwH7Y2zkRVVLu4whJDqyi2jRnlMtoy07MVr?=
 =?us-ascii?Q?GUXIaRdRnk06fu7vlqWkl60g22lTjM4fqULqgep0rKYwyrMjGV0rSFsHAKgk?=
 =?us-ascii?Q?aC1Y2M3wMPszihTczWYBFK6tjjjJnybd1GAPwn4O2lsX/fEiOE9xG5ndoObj?=
 =?us-ascii?Q?C2fUt3/D3UAVC2UdWixQWyIHYZuWT2TjOvtHUZA2utFgbVyoFLPsgCEnJMRx?=
 =?us-ascii?Q?n9x1Q1ovEcXTaQKJ3yfmCQHQgNmEOGjsbNFOTPmQisnN/UTZt9aQV8QAf0jj?=
 =?us-ascii?Q?GYmiqEMb8T1Ik9W3HpEidPp86LSErNA+lCr4n8uMgOOgln6Tm3oTzBk10cUV?=
 =?us-ascii?Q?Xrg3c1317LSK8b0/lwyguMYt2LJmkpaSMdyX6ZPiyEMILYB5b0em4sFUHqhi?=
 =?us-ascii?Q?C38erjT7M/tqVwgbC5GMCTXgFVn82TIcFj4uZbHhyKMpBKcLUN9QfKt5oltq?=
 =?us-ascii?Q?ICxG1EyCZ1ilPggkinLWH/rDq2FJ5aXGURksI1XhRCn9bplcPJXAJ/ZQ1esU?=
 =?us-ascii?Q?VppG+STCPRCKPBV5eq7KdKuJRICH2lqFM3icfJR95yhsEwlyTa4br3z2w58U?=
 =?us-ascii?Q?PRuis8ej9QcvjDZDSepzbhHv0rcWHnNZASQIUssAo1ZTyWfi8mAcDxjvjAoo?=
 =?us-ascii?Q?tSd/kgTkdCq1l6qdpM7iJ9P7eBbBHoY0/yBH1Ypso/vjCGOrJBj9BEBHPX+c?=
 =?us-ascii?Q?yy+phA8yLlgJnyvpc7QwpFwRF4d4Dkhe4wFNPM5AEqaNf+HLF/Bi/ucZSIZK?=
 =?us-ascii?Q?v38AtNdrlj74Kta9mIZEBr4+BSdoHjcMp6fVOgsLfkxtS8h+dXRBnGpggROg?=
 =?us-ascii?Q?iFMFhoWFrSwJu8bS/pwzJIsBh80bUG83O/PnOnhw/dvO4VYLa9MbmQQPmsuq?=
 =?us-ascii?Q?mAAwhZ7jQYp0tAHT+RHJhK1fUJrhYT8qWl0OtEZcftf2wN2GBp/IletoltL2?=
 =?us-ascii?Q?H1BGblE4WzS4Fj9WXA5Lls7FeJmEDO4OU6ilervkTtzrLH5oj0R8lrzfXOLN?=
 =?us-ascii?Q?xqbFY3pTjXV+EQW6dFaQhPavJR9SCg2lrz1oNkMV5cROWiIV3+dNLl2B5buj?=
 =?us-ascii?Q?WSqjoj8WG95pVSD8pGdfJM2tTLzTnzTnGLB3lCYp6doiV2JBELUVna0I0Nec?=
 =?us-ascii?Q?qkSzLpbHqF0pGnVC97G2d2yP7b006JtM+TvTnnPoGxom/HSxBfm8M6mcCMD0?=
 =?us-ascii?Q?QhdSq04fW9VMufCcdeJi+ysHBoV4R+b7Qc2eb8/Vg5JfBpxrKSUOYTjzBO1e?=
 =?us-ascii?Q?nuQK/UaeWui3UQKuD8oMjaaEG0A83j4dmIstmiV2/sDA7qywq+Ml2uVyMPZD?=
 =?us-ascii?Q?ARlzn9flEQus+L4R6XNLfv6qn1VH9QEDg3YIILeZd4UFawYXPdFeN29T1dPB?=
 =?us-ascii?Q?P65cVtkxotOfWIO4J/UYStk9VcXZiRMx4Gr+bC+2oYDZXgnRmSGBCglWJ/o5?=
 =?us-ascii?Q?ExOd3xtaMc+nU1Ni6JBrPa2I755G35kAsPQj5bdEotJzXdVk23bPU+GHLCxh?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12737047-2af2-4f62-c118-08da75cb2f53
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:16.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t19WMC8geldU2+QLcpavgmaoJs1rjjbq1is9JPJJ67rj+OMWHdeo7xs1UGv3ROmlLmHYiVjOpgOsKN7uTDIBIKnKyt2F26wXixj4oYI6z50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-ORIG-GUID: 85lg0uSOZW0nvnTW4dzvXn-qMG7phaDp
X-Proofpoint-GUID: 85lg0uSOZW0nvnTW4dzvXn-qMG7phaDp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Don't use:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

Instead use the scsi-ml internal values.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 12 ++++++------
 drivers/scsi/scsi_lib.c   | 24 +++++-------------------
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4adadd3fb410..dd6a31dce3eb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -649,7 +649,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	case DATA_PROTECT:
 		if (sshdr.asc == 0x27 && sshdr.ascq == 0x07) {
 			/* Thin provisioning hard threshold reached */
-			set_host_byte(scmd, DID_ALLOC_FAILURE);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_SPACE_ALLOC);
 			return SUCCESS;
 		}
 		fallthrough;
@@ -657,14 +657,14 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
 	case BLANK_CHECK:
-		set_host_byte(scmd, DID_TARGET_FAILURE);
+		set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
 		return SUCCESS;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			set_host_byte(scmd, DID_MEDIUM_ERROR);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_MED_ERROR);
 			return SUCCESS;
 		}
 		return NEEDS_RETRY;
@@ -673,7 +673,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
 		else
-			set_host_byte(scmd, DID_TARGET_FAILURE);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
 		fallthrough;
 
 	case ILLEGAL_REQUEST:
@@ -683,7 +683,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		    sshdr.asc == 0x24 || /* Invalid field in cdb */
 		    sshdr.asc == 0x26 || /* Parameter value invalid */
 		    sshdr.asc == 0x27) { /* Write protected */
-			set_host_byte(scmd, DID_TARGET_FAILURE);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
 		}
 		return SUCCESS;
 
@@ -1988,7 +1988,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case SAM_STAT_RESERVATION_CONFLICT:
 		sdev_printk(KERN_INFO, scmd->device,
 			    "reservation conflict\n");
-		set_host_byte(scmd, DID_NEXUS_FAILURE);
+		set_scsi_ml_byte(scmd, SCSIML_STAT_RESV_CONFLICT);
 		return SUCCESS; /* causes immediate i/o error */
 	}
 	return FAILED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eaf4865a2cb6..92a643ff64e4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,13 +583,11 @@ static inline u8 get_scsi_ml_byte(int result)
 
 /**
  * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
- * @cmd:	SCSI command
  * @result:	scsi error code
  *
- * Translate a SCSI result code into a blk_status_t value. May reset the host
- * byte of @cmd->result.
+ * Translate a SCSI result code into a blk_status_t value.
  */
-static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
+static blk_status_t scsi_result_to_blk_status(int result)
 {
 	/*
 	 * Check the scsi-ml byte first in case we converted a host or status
@@ -616,18 +614,6 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 	case DID_TRANSPORT_FAILFAST:
 	case DID_TRANSPORT_MARGINAL:
 		return BLK_STS_TRANSPORT;
-	case DID_TARGET_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_TARGET;
-	case DID_NEXUS_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NEXUS;
-	case DID_ALLOC_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NOSPC;
-	case DID_MEDIUM_ERROR:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_MEDIUM;
 	default:
 		return BLK_STS_IOERR;
 	}
@@ -715,7 +701,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	if (sense_valid)
 		sense_current = !scsi_sense_is_deferred(&sshdr);
 
-	blk_stat = scsi_result_to_blk_status(cmd, result);
+	blk_stat = scsi_result_to_blk_status(result);
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
@@ -893,14 +879,14 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 					     SCSI_SENSE_BUFFERSIZE);
 		}
 		if (sense_current)
-			*blk_statp = scsi_result_to_blk_status(cmd, result);
+			*blk_statp = scsi_result_to_blk_status(result);
 	} else if (blk_rq_bytes(req) == 0 && sense_current) {
 		/*
 		 * Flush commands do not transfers any data, and thus cannot use
 		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
 		 * This sets *blk_statp explicitly for the problem case.
 		 */
-		*blk_statp = scsi_result_to_blk_status(cmd, result);
+		*blk_statp = scsi_result_to_blk_status(result);
 	}
 	/*
 	 * Recovered errors need reporting, but they're always treated as
-- 
2.25.1

