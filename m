Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F243C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA8460F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhHQCvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 22:51:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2748 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhHQCvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 22:51:02 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H2frP2007587;
        Tue, 17 Aug 2021 02:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=0sTnY7EI/Eh0+ENgCuy4KbJYGBG8ujVGYfvAdpxakM8=;
 b=Fztmqat2+YRHNBF/u5I1NWq1OyhNEGcE5a8Y80QMWvtzEq8K1r0zx82M78yo/VwMSiLD
 o8bL9M4E8iMAp/4n2+Tn4o8jp8tysYr6ypRTlT8r/4JfjhGi7IwaFLRTwK7T8rfOy2MH
 /Utm/cfCui3ybJqd5kVaOShCGaq3zYb1iKhkhTFxAa7s4YPSFwPu7O+kV3gE1gjaXKay
 5PmpIzzAoILjeUCGAqf46imkgPqykp35MDsNGCgT5DlJ3Zi3B2IH1HMhSsxYA5VY0EZB
 yQdwVQmHPlrfOEjK9pxRZUjeWMbXReXaaGlDVh/qfVNhE66gdkIgBh0icGIzdyJ2Utg7 Xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=0sTnY7EI/Eh0+ENgCuy4KbJYGBG8ujVGYfvAdpxakM8=;
 b=BJ0ruqN6h9tyCByJkVKur4vEV2mbYag0Ggwus7OEwRjC6rbncm3H+emijNrrP5gQaIB3
 am6sPlOKlg6KuLoh+ePAfzXoujUpNl2DbfU1zVkMQTfArOuJrrEJirRvTP7rBUHDmhYp
 jrqGoa7DQzTZgbwEsJnT/2zDVo33xjQjzx0uPUTsrdYO7aCyb+30z6wHnHaeyLgNvHpI
 flQI4wT3KB0hSLymCK0N0xiW34qE1KmOnXIsATaih9QqZ2RRY+KNgXa7wT5Z86HNxw/K
 1XLUx6DSf78DQn2fwJ4Bj5GgajV7Nh47uW2bO4APgj/NDFhL04sLGs/CEYal6v+XtRBm UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpgjm2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 02:50:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H2ijYr132105;
        Tue, 17 Aug 2021 02:50:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3ae5n6qpax-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 02:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VA3lv/IF2etpJYbZk3va0pu9g/nUcNKSOTTTvWkRA72cV96B3wAmTz4jLXB9SR4mS/PYgjW65e2NIe4mXiAQSUtuRxFfMXRpUtKFCAw/+5mCP1CLG+bxlagSxmAbDsz4lQJH+QSr1xVm6mS6Gt7MuvJ1g+stIrTD7NJRBqCm5gU5xF7b/CthcRF98bDNv7Y6F4RWU5P2wJwD8iqFO4j5KKTSjQy73YTydyxc9lqbgH7yLBElQ3yjbbPeydhPr1GO+rCIke4y/pAcmvQa73xKU9+VsyGum/RTThieKHSF1ahwQA4K67xSy+zYqWg/RI6ZxZv9KE7E98kLaRGcvrkWNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sTnY7EI/Eh0+ENgCuy4KbJYGBG8ujVGYfvAdpxakM8=;
 b=aclAniyaZRwqf2otZAKAp7ORfHWNP+pZgo0KQ54zTX/DslC3TDvk+Bs7EIIyZ6CL+eEp2bDn3uIcHM4HmBAR3uo+jQ3a6y97bDLhqoYGEIaaOBcXejHetEwK8dQhGfqW5IeVed2M3AV9dBK4gTjDeBVqPmP0RBn1ooQmVNQ5EfpgBVC67Mym/FuRVrXQqUK2RaUgeuP5T714pw1rrOzAb6Mc6A1k6dC3pzI3DL8wjxdTj/bkSnTtezzcgCeeve99VkTng5MiwgZgydBb85P8KJSR4b7DVMW/jlJy5L0XzWEiLHcDLgOvEOshSNOW9wnELFuORZrxHsIQ0uFM+K7tdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sTnY7EI/Eh0+ENgCuy4KbJYGBG8ujVGYfvAdpxakM8=;
 b=HfK5iKr+MLslkWK5v9zPsRSxz6WCAnSls0XqFgGT643We6kq1el6LC2kb1huv4z266w64md7cTCrqkWhagM9Gg1jkVZmjHRRCGbBQzbXxp0T4cNeR7kGxxvRMkM68gQ4ILe64207M7DJUb5x10SDRxg1UuXQR3Il9SM/H9sQRXE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 02:50:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 02:50:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v3 2/2] scsi: lpfc: Use the proper SCSI midlayer interfaces for PI
Date:   Mon, 16 Aug 2021 22:50:14 -0400
Message-Id: <20210817025014.12085-3-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817025014.12085-1-martin.petersen@oracle.com>
References: <20210817025014.12085-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0175.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0175.namprd11.prod.outlook.com (2603:10b6:806:1bb::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 17 Aug 2021 02:50:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c381e9b4-17ce-4c98-67b9-08d96129c48c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5466ED73C1C105969E6BAAD38EFE9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:339;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlA4aQA1h4OF0oKCq4EfmmuVQ2L8CHZFKCm1XZ3WLlYV9Z0UunZPtpdwplRUKqigzDCT16e+VsathRPqrIk5hfXo4y8Bj7/v6NG1pbMjz2jHJRcpvUnJ9iGNxCvKqPkvBNbxUnzqRAqMKzpLvyMaUcoXuyGolJhbWS9OgRm1ASrZs9LLEz9xai+g2x7hACr2sAOL0EOXY6pMTS1Tgn1E2ACpmsYIYEnyzOPWoKtX8sWEAm/XAj2dnCw/aDRRHApXQTMS/mD8X0BsgkFU3Yeq9XuQ6z7rD8MbUgYsXw8neJlajAI9MqEmTHcoH5wJwYIpLe/s8EN1OuEa3jiEFkHJ2xcizfl4d/8FaVgfew6z5cyIXxxWzzuvAenU1CgnajLv94EL/P3A5bLXrvAQlpI5PWN/rFDcQhnrSVfDxWEIcPbVEVM7dOxySaHzJWr6TuC6NX77G90W3PlmEWL/qMkqoR+S4CeXaqcdcAZ+k5CFknhp1wOwZo8Tkxwv2aIytdAR2dMO8/gwPulCr9RwXpqf+laTPUsjX02PU9NMZsKOqn85oJr8B3oBOEejzUqGPF9hBXgVHlA3W7+oLDJSHdxBItSpRfWxww3T3uhU1eVF8vc2VnJDzD4TpthJHoxxIJT5hSNrAFUUB+bfz70Aldxh4NGOLlEjGG7tcASXdOvt88/4a03XfhwHIj1iOLsNlTe0Z4V5zvG97SEsU5WvJpg/cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(396003)(346002)(366004)(6916009)(316002)(956004)(2616005)(54906003)(186003)(26005)(83380400001)(6666004)(6486002)(52116002)(7696005)(86362001)(4326008)(5660300002)(8676002)(30864003)(36756003)(38100700002)(2906002)(38350700002)(66476007)(66946007)(8936002)(66556008)(478600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gwSLi1RHD/6h1MEGtrV0w6uoryt8h+ws69oTsOFdP3kseM94eiC57F9ZXLUb?=
 =?us-ascii?Q?8JlDIOVEG9hf+otpopMp7rlL+pRvqHaMWNo6si2S9kXoZE5/ToNxqufVWJQf?=
 =?us-ascii?Q?RGfvkXekXjjszL2dt3X1+Adgmyt8svJJCL248iOeeQ64+VCxs77MFN7OHdwc?=
 =?us-ascii?Q?kGeQbMjvB50R7mRuQ7qlghfftqY+9neCdWa6tmjLPmFNFy8P61TmRdr8qKYk?=
 =?us-ascii?Q?Np2AqvQ9E0O4M61/4Y/DNrn3kSJKPFaVV127IFcGZyFRLlfUGQxvKG9pPtz6?=
 =?us-ascii?Q?viaZF0ugtWUHTspfbEyf+GHmsTYv/B5AC9KcGljZpZjCTXGicNPAV/Sslokm?=
 =?us-ascii?Q?xaI9jnndWBnDJ1mD+rrHllijoKBFnYw4ePqCobIzHpMO7bIau8gcfKLmnL07?=
 =?us-ascii?Q?4LclTgjWPRcO4+gzPoGxmq4cn7xWtYuwXE6oKUBIbk09ZbdT+dZN29dnooNu?=
 =?us-ascii?Q?BdKXQx/LKYZ7ekOz6qPwU9ip17J/AH5kIKGTpNedQi1R3QtlYikaZ8QT1ywH?=
 =?us-ascii?Q?sriUDuVwSOxa9VMfbiUcYS10/+B2nXE/mtasfZtCehCeiJgK8h3IiXYILgnI?=
 =?us-ascii?Q?XLkvK0OfXW9uqLPXy/+e+UGd7CvgZsMFYAIew6xxzv7N5uZCnoaMMxz4iZO6?=
 =?us-ascii?Q?IfQ6u/5gH4G2RFF7f2ymkH/2quMy8rjZevuHKDJAaJkW4FDC7OKO6SmU0bpz?=
 =?us-ascii?Q?jh9aq0jS+zrg+O0Ql5paonyGFwxE8n+Gzlwi6uF8RL4DTZOVO80skPYTUVj6?=
 =?us-ascii?Q?/WeOir5Rb3HtUWM4cPBKHXy6vXm3T85IcalLn526DSsQ/0kiGCgL1nKggGJX?=
 =?us-ascii?Q?/U+ijxWKFt90qahWGCnrCndXbi4RNtu18vncMICUHUi8bUpPqNEzK8o4K6Cz?=
 =?us-ascii?Q?3fi3dKLTXHkfiuF5mUdyzx1JhHRTa5KANBPV460wFuGW24tnwjZNC/8bNHai?=
 =?us-ascii?Q?49NoAv8KciZkrY9wDfrmsvA9gp53gaAqIpVRLBkxtje6fUAk5R+iOqG62jnR?=
 =?us-ascii?Q?ZDcgDrk/6w8MfoOMteG+iCDwq3ceEa3YB6DuPctfGoVTFKa9caMTvsD2SXW9?=
 =?us-ascii?Q?OGztMZYGqx2END7kjRV84H8CZ4sG7klUVQSJabLvIuKOfPSqZjJMmpmTSi86?=
 =?us-ascii?Q?UimM1vvq4WUehtaUNCO3mtPUCfX3jxGZeLeLSQxIpBP4NhHYxOZW3HTMSz2y?=
 =?us-ascii?Q?bbOjvFkhwGgnhTXUi7STkfnckHhhvljKcBE9MpZEeiehQoVnwO+8WZPrVtF6?=
 =?us-ascii?Q?WzGzLFG4rOwkpUKKShLwLlYnmpkoThurnmzY24KznQmz9GtGp6wss5DK/qyd?=
 =?us-ascii?Q?co8QfwFIEtUR6htSMdLyPlmd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c381e9b4-17ce-4c98-67b9-08d96129c48c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 02:50:27.1264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/FwlPreGU8qYmPHAnMrcEIlOLGP2ti0m3f/ez5NV6MNxnq5yKZ+cdFWCQpN6+EKABLZpx7QhsJkk4/LlsnTXCAElNS6V2dx0uJae6g9u+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170015
X-Proofpoint-GUID: _DXgzRZxRa8csvjsMCSfvOtRx0GPU7SX
X-Proofpoint-ORIG-GUID: _DXgzRZxRa8csvjsMCSfvOtRx0GPU7SX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval, reference
tag, per-command DIX flags, and logical block count.

CC: James Smart <james.smart@broadcom.com>
CC: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 120 ++++++++++++++--------------------
 1 file changed, 48 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f905a53d050f..d60e31343a07 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -96,30 +96,6 @@ static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
 static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
 				    struct lpfc_vmid *vmid);
 
-static inline unsigned
-lpfc_cmd_blksize(struct scsi_cmnd *sc)
-{
-	return sc->device->sector_size;
-}
-
-#define LPFC_CHECK_PROTECT_GUARD	1
-#define LPFC_CHECK_PROTECT_REF		2
-static inline unsigned
-lpfc_cmd_protect(struct scsi_cmnd *sc, int flag)
-{
-	return 1;
-}
-
-static inline unsigned
-lpfc_cmd_guard_csum(struct scsi_cmnd *sc)
-{
-	if (lpfc_prot_group_type(NULL, sc) == LPFC_PG_TYPE_NO_DIF)
-		return 0;
-	if (scsi_host_get_guard(sc->device->host) == SHOST_DIX_GUARD_IP)
-		return 1;
-	return 0;
-}
-
 /**
  * lpfc_sli4_set_rsp_sgl_last - Set the last bit in the response sge.
  * @phba: Pointer to HBA object.
@@ -1046,13 +1022,13 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
+	lba = scsi_prot_ref_tag(sc);
 	if (lba == LPFC_INVALID_REFTAG)
 		return 0;
 
 	/* First check if we need to match the LBA */
 	if (phba->lpfc_injerr_lba != LPFC_INJERR_LBA_OFF) {
-		blksize = lpfc_cmd_blksize(sc);
+		blksize = scsi_prot_interval(sc);
 		numblks = (scsi_bufflen(sc) + blksize - 1) / blksize;
 
 		/* Make sure we have the right LBA if one is specified */
@@ -1441,7 +1417,7 @@ lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 {
 	uint8_t ret = 0;
 
-	if (lpfc_cmd_guard_csum(sc)) {
+	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
@@ -1521,7 +1497,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 {
 	uint8_t ret = 0;
 
-	if (lpfc_cmd_guard_csum(sc)) {
+	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
@@ -1629,7 +1605,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1668,12 +1644,12 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	 * protection data is automatically generated, not checked.
 	 */
 	if (datadir == DMA_FROM_DEVICE) {
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD))
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
 			bf_set(pde6_ce, pde6, checking);
 		else
 			bf_set(pde6_ce, pde6, 0);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(pde6_re, pde6, checking);
 		else
 			bf_set(pde6_re, pde6, 0);
@@ -1791,8 +1767,8 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command */
-	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
+	blksize = scsi_prot_interval(sc);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1832,12 +1808,12 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		bf_set(pde6_optx, pde6, txop);
 		bf_set(pde6_oprx, pde6, rxop);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD))
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
 			bf_set(pde6_ce, pde6, checking);
 		else
 			bf_set(pde6_ce, pde6, 0);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(pde6_re, pde6, checking);
 		else
 			bf_set(pde6_re, pde6, 0);
@@ -2023,7 +1999,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2051,12 +2027,12 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	 * protection data is automatically generated, not checked.
 	 */
 	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD))
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
@@ -2223,8 +2199,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command */
-	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
+	blksize = scsi_prot_interval(sc);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2281,9 +2257,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		diseed->ref_tag = cpu_to_le32(reftag);
 		diseed->ref_tag_tran = diseed->ref_tag;
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD)) {
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK) {
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
-
 		} else {
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
 			/*
@@ -2300,7 +2275,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		}
 
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
@@ -2557,7 +2532,7 @@ lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
 	 * DIF (trailer) attached to it. Must ajust FCP data length
 	 * to account for the protection data.
 	 */
-	fcpdl += (fcpdl / lpfc_cmd_blksize(sc)) * 8;
+	fcpdl += (fcpdl / scsi_prot_interval(sc)) * 8;
 
 	return fcpdl;
 }
@@ -2811,14 +2786,14 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		 * data length is a multiple of the blksize.
 		 */
 		sgde = scsi_sglist(cmd);
-		blksize = lpfc_cmd_blksize(cmd);
+		blksize = scsi_prot_interval(cmd);
 		data_src = (uint8_t *)sg_virt(sgde);
 		data_len = sgde->length;
 		if ((data_len & (blksize - 1)) == 0)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = t10_pi_ref_tag(scsi_cmd_to_rq(cmd));
+		start_ref_tag = scsi_prot_ref_tag(cmd);
 		if (start_ref_tag == LPFC_INVALID_REFTAG)
 			goto out;
 		start_app_tag = src->app_tag;
@@ -2839,7 +2814,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				/* First Guard Tag checking */
 				if (chk_guard) {
 					guard_tag = src->guard_tag;
-					if (lpfc_cmd_guard_csum(cmd))
+					if (cmd->prot_flags
+					    & SCSI_PROT_IP_CHECKSUM)
 						sum = lpfc_bg_csum(data_src,
 								   blksize);
 					else
@@ -2910,7 +2886,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				scsi_prot_ref_tag(cmd),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2920,7 +2896,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				scsi_prot_ref_tag(cmd),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2930,7 +2906,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				scsi_prot_ref_tag(cmd),
 				app_tag, start_app_tag);
 	}
 }
@@ -2992,7 +2968,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3007,7 +2983,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3022,7 +2998,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3066,9 +3042,9 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 
-		/* Calcuate what type of error it was */
+		/* Calculate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
 	}
 	return ret;
@@ -3103,8 +3079,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9072 BLKGRD: Invalid BG Profile in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3115,8 +3091,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3131,8 +3107,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3146,8 +3122,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3161,8 +3137,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3205,10 +3181,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
-				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 
-		/* Calcuate what type of error it was */
+		/* Calculate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
 	}
 out:
@@ -5549,8 +5525,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(scsi_cmd_to_rq(cmnd)),
-					 blk_rq_sectors(scsi_cmd_to_rq(cmnd)),
+					 scsi_prot_ref_tag(cmnd),
+					 scsi_logical_block_count(cmnd),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5561,8 +5537,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
 					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(scsi_cmd_to_rq(cmnd)),
-					 blk_rq_sectors(scsi_cmd_to_rq(cmnd)),
+					 scsi_prot_ref_tag(cmnd),
+					 scsi_logical_block_count(cmnd),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
-- 
2.32.0

