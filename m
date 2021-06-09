Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63292C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BBAA611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhFIDld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbhFIDlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592h03n020883
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=+CpW+8c08hSAcaGetxa5uU7xX1IYUuITpf0aXaTzlwg=;
 b=JkfB4Baj3Dp5n2xb2HEg8npObkzJO5OiwiPuTSNoK0qfF+PNIfBK7P4z5mZTZ/P60Ops
 QaWYy+5y7LegMImSHUs84CFKxGS/18SXfQeTS/DFrY27pfY5FUQ8T5K6wu1U4BgO5AQS
 Yk/lwUKmLt2/DpHT30HfEVx28Dlt/3SRbc7nNZ7eUa3RGRY6e8tImRcSo9fn6niB2piV
 n2nxQKTVeq6cHT6WunRUb/lFKFGxAiwWorz/QBeJNIJOC6NfsyWRi987kCB/TJAIf6Qg
 sxzOw3r0JrEfZWzpyPgpeWyrD6ixVchqTuhXmjg40z878l0G8IWd6LNhe2i2jvc/4W2G oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qup8u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3h1082802
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 390k1rhr0h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKn5dlP5QzGYDgjeNPE9qzvdUgiVPoO0wQvHnXqJgE7vVOitFD4UFwOkwbfxNP10uRdihz1bALyl12JlCXJu/zko7R+rTHXNq8OJShQgrTYFK6nyWy8/cd85X7sf30StZTmG5aKJt4zx43ZByklPwe25cuHBuv/JO0ChmeYHcozmIUqKB3y9ALhIoJJb15y8q1cwaUaLF7qFeVt1/p2efOg3RTBJc4XGla3vZAfpruZxxR7vyux+K1B/e9bhogyEpKn6ze0Wc0CDb6dDKKTCVffAyNGn5s98XVjAelTH30D6aK2XBzNz5c/5PW6mt+yVCGwrGyqOCfm/yUEaXHb9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CpW+8c08hSAcaGetxa5uU7xX1IYUuITpf0aXaTzlwg=;
 b=kJ6tgeZ8DdaSeiqT+i4r99B5GOfVVj5VsPuMzGlBapflLFtr2ebmwIwjoufzIas+JYp3/uKbUgttxPhTEOo8mPtvwb7VDfPD4NUK+kYri01UuMGZQ+LyHWU9DzrF8Xjyb0x4jmqCSUxEL6wXmuMMaz7NIVwlT7D7l/YgOzMw+nxg2MtakGyCMbrmI3uoJfbcuudstB/CPVv1e/jsxLbXFOrdl7oXtHezmCmhqLjecz96MKmz7U8hEu1j4joH+pBShcB7OpJcldrfHJDw/xi31zu4+i0TBNCPQk4GeDWVhmSObVUjKvHPsG1k1iwUts+5Q/ehbVwRFsN0bjmBxRwi7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CpW+8c08hSAcaGetxa5uU7xX1IYUuITpf0aXaTzlwg=;
 b=D3PlsanaGhy162xsoDp69FhJrK9AGfaK7JN7fcdwrDtrWybX8LocTiEA4buZHAUNo5M5AXCHmi2gt4zdE+nCQjZeySpfDoOB9n40xvJNG9r/XkOF56wGJDbhxBaNy5Hmtf37YQPsXocxpy8SFdz5NFj7NVuyRHfqHk9VXoC90Ys=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/15] scsi: mpt3sas: Use the proper SCSI midlayer interfaces for PI
Date:   Tue,  8 Jun 2021 23:39:18 -0400
Message-Id: <20210609033929.3815-5-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eec7c490-39b9-447d-43a0-08d92af83343
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422B1AD5AE358F21244497D8E369@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yl2KW29rHU2sqcGMUxUBJCi/aX+QGGiofv9H4LQa2FS7qkFKAI0x0++6Dc6Gg+IoAUIdhmmgnDdjbXDsbNAI4OgM4xzi9qhWdlMOZ+YARnsQKyEWuTTU7tzsgkAw6zsYkkiY8hhHBVcAHZr9ntLGFQMF0BJsPQSXItId9aJTszp4WHSwX64mNUXQCZTCDWHc5KQG9vifQd2XK8rz1eh5hq4reoDDsk9dFD+V4Nvm33kLbvDnC2qQ19qbT2uix0ne9sMKOxJGpfk5WJ4778F5+vR3jELmd2QFeN/Z9WN5ALJm6iqbzpVQmGFTMJONJpgdq5trmfrLPduPOCEpN6jRFawycmoCgkO0eroRFRlXa5dO7qciLukZ2e4CfAn9d8cP0ci/xJO0cb8g/Apy/C1kfeG1A0ISXnurH8OynP+LhV214DoPIihQ6AdrYAGiW6FrbG3h0mzOGByPCP7zNA+m6cvjws/YsXO3g3qf/H2Rg1KAi0hEVbg2m+OAEus/PP2lXS40uqGCucsn/bImStybnwSmjX7L8OvexFyuhtHuTiTjSMcdf+hKi40MLltSWRgblPQAbci3xor9BKGI12Y0QWmkOERvnRkX+51K2RizN087wN2eNUWZVD5bpQkgD0xBHW4VJX5Px7McQwI4lcdm3BnhU/9UlGc6aNy/qaSXCtFAwxybLGbnn1HqtEkuL4r1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(1076003)(4326008)(6486002)(316002)(8676002)(8936002)(66476007)(186003)(16526019)(107886003)(66946007)(38100700002)(6916009)(26005)(5660300002)(52116002)(478600001)(956004)(2906002)(2616005)(7696005)(83380400001)(66556008)(6666004)(86362001)(38350700002)(36756003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1GuNv7o0VjUUm55Kd76/G1fZZtZ1J0+4kI9FK29FBi6uu8vCYd8vBmJBPS9?=
 =?us-ascii?Q?7GRubzWOErT+qWqw74uiPNPRnxrkO2T9HVC5VRB1RiKf1lC7biDHmx0CuSr2?=
 =?us-ascii?Q?DM1Z9SlQGlF0X9Ee5ywvSS41+02Bf3zCcgOqZ720RP7XfDC3flS5kXB6n5qV?=
 =?us-ascii?Q?hRYrzDGa9rbors1c5ctyycTdA1pITYcXsytW30caeI4CDrK30rknQLt1JMQf?=
 =?us-ascii?Q?NH70BS4847mmr8SFAwRLKFvXCq9xjni31/yCO/VjpBYUPfFokReUt7MiDSdl?=
 =?us-ascii?Q?jsfgGqpPCRdWMbqXl4sSvh35a3SA04CnTcM5fAo+2DipnIA+xwP1v4OSNIly?=
 =?us-ascii?Q?jP8b9RaY5j+vYHTOGU+UQ9VYBtk4emGNBUs2om/ILiJkbL31+72Ij8BGRsgD?=
 =?us-ascii?Q?fUSNR1gsTHuaEhnW3k41oD+40r+a5m5ch/d2eYmpSJc9neVPpS7N9N3zXK0j?=
 =?us-ascii?Q?XYj+8zMJLEqAf1ZKVzttxdUohKVz0TPFimI0KZHNn23APKmClijYR+5VSZ2y?=
 =?us-ascii?Q?qQXTjD7tRHythYLA1d3NlD6uqsHseOpuKQi0iR9RJCn1qdQj3ivxUP8eu8hq?=
 =?us-ascii?Q?FB9rfPeNVZVkp74qUiULgHOpvEDtHyrbQ212cThiNfd5BGV2syTdcgEa2hig?=
 =?us-ascii?Q?5tzLAekYHhjKMhghqOC+5LwDeh6zm8IqWsgJec+UvGGo6OwYakMCXnk0914n?=
 =?us-ascii?Q?vQlOjG6ErKJEInFSzbd71YyHWvZMntF8YECVmTIhlkrQeLeQobhcQiGejtHV?=
 =?us-ascii?Q?ySprdtTo1ERlUq0EtVfWcGS/abZkR+nDjTN9la454EahWoZhbgZWLnwzSdMH?=
 =?us-ascii?Q?XEEW+CdYd1TxcR4I3KJ+LLUqBJGs/RgA+RupCmnUEby21QcSlFYkr9tMPF1U?=
 =?us-ascii?Q?2QPlNSAJdc1zEBtYfkMgsuE5gKuy6sQ9WhpYduHAcrlUIkAuS3HZm67tTRNf?=
 =?us-ascii?Q?Kf9iUnq0NrA7/0d9gv6sRljGNIq6eD59RfyJogCtnh4FxS02oAayE7lrc64N?=
 =?us-ascii?Q?dTCe/KdvIVzSmQEQ/DcmWSPX6puNtko9dVIl3P9GC6Ti9WyhJndIHUQrRdBO?=
 =?us-ascii?Q?Cp6Ipjkxvd0/AXSKzTdM/0BBho7owE/Mvy6Wh+WKJQB5NbHVRtQX/qAT5LVt?=
 =?us-ascii?Q?0Nz7/q4dvgSxdjHDhQhQVZRtivZ+ozn0VGRFkLkQxqCjUbmj6jnz2wqKlDSY?=
 =?us-ascii?Q?4MhCgP6w3qLO8XY6kwijd3m45IrBzVtatNmRmXE8Ry5rt4Jq2G40dMQSKQI8?=
 =?us-ascii?Q?BICERHfeJ/PKRveCA2blZ7dx/t6Uzu+GoT/KadJfP+3bSX1Qr/sWiGk39pGC?=
 =?us-ascii?Q?HDVSZh2qhq7dKgufGfFfgqow?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec7c490-39b9-447d-43a0-08d92af83343
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:35.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMfmhZlrdVXYbiq9hKq3UENdA2hr41dUlFpyS/iRY6YQNGd/DZUWd8lFzoYjmNdPho/MmcAz2hv5eyi9Xirg8CaVdmjgJA5nWS/9OFWuYYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: 61qjjVi1GHZOPQuAqTKuLPlt7Jz_IthJ
X-Proofpoint-GUID: 61qjjVi1GHZOPQuAqTKuLPlt7Jz_IthJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval,
reference tag, and per-command DIX flags.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index dc2aaaf645d3..322450800056 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5062,33 +5062,17 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	else
 		return;
 
-	switch (prot_type) {
-	case SCSI_PROT_DIF_TYPE1:
-	case SCSI_PROT_DIF_TYPE2:
+	if (scmd->prot_op & SCSI_PROT_GUARD_CHECK)
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 
-		/*
-		* enable ref/guard checking
-		* auto increment ref tag
-		*/
+	if (scmd->prot_op & SCSI_PROT_REF_CHECK) {
 		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+			MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
-		break;
-
-	case SCSI_PROT_DIF_TYPE3:
-
-		/*
-		* enable guard checking
-		*/
-		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
-
-		break;
+			cpu_to_be32(scsi_prot_ref_tag(scmd));
 	}
 
-	mpi_request_3v->EEDPBlockSize =
-	    cpu_to_le16(scmd->device->sector_size);
+	mpi_request_3v->EEDPBlockSize = scsi_prot_interval(scmd);
 
 	if (ioc->is_gen35_ioc)
 		eedp_flags |= MPI25_SCSIIO_EEDPFLAGS_APPTAG_DISABLE_MODE;
-- 
2.31.1

