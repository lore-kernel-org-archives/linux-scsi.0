Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8951DC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiI2C5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiI2C5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06C811DFEC
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:57:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TN0l011051;
        Thu, 29 Sep 2022 02:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7e+b7zRKR+31Pn0JUOo2sNJrVnTRN1/KpqjskzN3Dm4=;
 b=Pm2FATiphvr9oqro968SSclBQpXGeSzC8qcO8+Vp823e+wryn9vu/0O/nowUoFdzi/FS
 Dx4UC7G1u2sbjpe+WcC9ngCyORjo0MsUJr2xo5C0KN5HXmJygBFXRsCP0yPJ/jC1J+FN
 M/S9FaqNXTqacpyIvWW0b5kmPz4tJzdAv/ofqNgAoS/l3OcUr11K+DT6gD/iVgWeDjaD
 UaICCXZgE9PFgcMw5JTMnidaYFpqwh38rvhWsmvmHCtG99PABER8o/vsvDmJ3cvz1W9V
 gVo7Ejb+I14u6ZFnOgnIbzikyaMnJfNtcvwtNRh+x2/18q4J+lrHRglfmfykhQL+LDTz Cg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0ku9mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T215Oi002239;
        Thu, 29 Sep 2022 02:54:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6v7jh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfUoyPw856dkz3fdlehQmNqS6jZXsOotStRJ4euBG+D3xhb744bYGdVOosM5qh1ceCmplQfjoP0Ph1LBXxkSudAbFrmoUwoZambaCbvLfFLESX1axl9J/jMuP/DywnzrZA0/w8Bno7V50KC81gDacMMdmcsjs2+VXznGMyrK9sdeNwisyhNad5IsGmhk9KUw18DNoGOmqrSTsGPH+scimq9h1eFQy6fLA8qwBrlajLjEmPeHGb5G7XLKWyVoP+LZ7nlW9+xa2gEYgPjd1+Wt8hFHEgMvZ2n1Ed+cVC6L2P4ntK2KOBvjxt13SLudmuILeB31AHao5XMRfr5WV2T+yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7e+b7zRKR+31Pn0JUOo2sNJrVnTRN1/KpqjskzN3Dm4=;
 b=eL1Zc3Zgnx6l/8y66d2yFUn3GFN4JdKgMSeW9xfNmpxlb0rmwVpBjnZpWJ9Dpwoh4eXF5yUBIKaWPX94aXeE8l+MHRcv5v8baU5X87GDOTzQtBi0ceLbgl9N6ml/ZYQBWNO3suLTB4gPzpjFVqFX8psf4G0KZdVFpZE+rf5uwkTFiyUO0oIKzmleOsSGW+faLzOcgv722SmPbKXk8hSs3KfPJdY5sUCRZ4qA4TZD9qlqS3seKYGSGhr9gV8vSioQ8V9fvQCwYnOmngY+ICVQrmSYNFDCAwjS7WybL+A9pJ2pFPFNKCjW69erE0bxU1XS0Dhuvu5AGP4/WeAxB4cziQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7e+b7zRKR+31Pn0JUOo2sNJrVnTRN1/KpqjskzN3Dm4=;
 b=GJOXtc+y4gAbEktb6IWd6Qe3EV6y2sBHlVXFtPi+6Mm+wHj244NWk9AgB6wDyvzTiY0lMXkuuL4JN3aNxZQx1VyCAwBCBRJiG+MvIE3EESwEuRYSf3OUplBaEEg8Oij5afPuwDa5ddzQfPLkj51zxYCLWG3ecR5E8BDwR+8ZCNQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 24/35] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Wed, 28 Sep 2022 21:53:56 -0500
Message-Id: <20220929025407.119804-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:610:4d::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 67807988-b1dd-4037-9ad8-08daa1c5f90a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dB2iaEhPrEaNj88rZfwAVPcXQY2JTRdPa05J4o/IvPqnAzJhLdNJegmKh41xnDDwQfNse5+lCLHksicc2zH2nk1IHbhDmbClNESEgkw71TfcvzSBXqXYF/4DSi1y6cGcYTHLafZwn2kUn7LPiB6TyGhQkOtKJaakLzhbvZWhHn1nbRHA5Xeag+p4EA9Q0cLGkTN9T0SJB3RlMuHFAmrtx8cfuTSxNJFWmgls3ogjwWQCAYC73THRmpuyAtRzyUh2veYp1Civ/l9emgR4J/kLrSxEwQL/lAMzl6Zt+yBpZCD+h30somqgVmiWWDrUe1Gd9WNXfDsRMEmJtad1JMgodLjwRCWV8ByxFUdabTvm/JY02z429BYYre1SlYVOIJ7XuddHqx5O6a4NymtBioKr33hKZRJ4N3mGaxY74wWj3x06S3lVCilUrZPiv9ZNSOUh+MTwCN2QnhV+z8hIahS5G+jUDdiR+Zs13EUUoYXgjlwwk4eMvBYw++2nycvMwUvAEglgyROGYeggc0On22FL31uMjXQwMk4KPxkW7r8amS13vjFGy1b4h6IDBYM33keUCI3J7Fif84M291xMQHprS6Ii4Oj2IWvY5q9CqvkQrDM+aPZibSz+KJlB6iGdgZgq/bNkyA7fXjhSOlaFgHOKdSrecRT1yeb9toIb2FfY9UV+9aV8sJq3uKdV8lC2jEOtuct4R9Zpcg/zkXNzEHFpHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8MkEnHKuJ4nR2GAwJq8oYNX43G1kF/2Kj3Vzjg96zC4FMymyVixq5USbbPOx?=
 =?us-ascii?Q?4c6saucStVoBsdfjnfvg/cPYKVamezdLlee68G4VNtY4Qy+YYpyAtjK8bu5D?=
 =?us-ascii?Q?PoGLMaQ0rfq4CHxN+UjDIckeTi3jJ16PEc4afdxf71W9aM5UEJVTH2nxzVXY?=
 =?us-ascii?Q?ZDQF2YluFhlq3lkvKleGG9jM0OCT/ykEZuEyU5VpK7wPc9eQYsuhSl7ZzyAz?=
 =?us-ascii?Q?MZLboS4S+Z3Dg2/un2Mc0Mx94WnZXhppemMKVrf53aexSnQDzGyETtsmt0S1?=
 =?us-ascii?Q?cbnUSnI3KzuAip3xeLUNPwkAzHdppo4MhK0chpu/f80zEifrBhRppDN3BsC7?=
 =?us-ascii?Q?KjrNZK1EU8Zgjep1IwlrpRrKAMfGzGeVn2T446ok3nNgHJjDvWeLDOXPAymp?=
 =?us-ascii?Q?NEs4UlJTH3I42SOMmfAcPTIP6XFKsJC+DxioCBrmspN0EltHoc5X3SBJIv3q?=
 =?us-ascii?Q?FoH9DSL4BtKV/qrWTCszaVxCEFIMbKKZCay70RL2k/dtPLPncuOgu9Q1Y4yw?=
 =?us-ascii?Q?3UKTb6VzX0kfbN0g8pMDzzU9zWj5rDMwZSxXdFJ/Foipusrzz2WNP2uazXUA?=
 =?us-ascii?Q?uyj0qjt6tqsmTj++IGMGOKxlQNxnh3QI6W3W8SDRHzczcFuHcdW6jTbTfI1w?=
 =?us-ascii?Q?IVMBSeQISUzOaa7eVhXRZxKi1u+awEmcRvgt44WfFxM3ftVKfbprn37VVdXF?=
 =?us-ascii?Q?P+KZ3c23r8+yPc7SM11oU+7BSKXxUfdfeRKMqToy6QDeB0QiBDpL3J1Ml316?=
 =?us-ascii?Q?qsXNpV7QoKXkWCDNUqt0ECVH2N90ZKwWLBZvS02S0zNSLP/MSy6Zcqb8JAZm?=
 =?us-ascii?Q?7QfEPV6Yy28YzCqPxhCE+yOIy8hvV4+UzBBi3bKimoykBOTOgSUZNq1iz+vn?=
 =?us-ascii?Q?8M6nGNZJ5u62nuOYvj3R/SJ1fK/iD+GDOMIlg0RDpYqZ790y0pQvgV/I/W+P?=
 =?us-ascii?Q?8h3k7G8s7bbamj41zodltKNLiPDxyxx3zezdJPNN4G4XtTqQkGCcLabK6sDG?=
 =?us-ascii?Q?m8TUQ/NAHdtqcWhMdi7RAdAFc0QC4lku8XflT/1USNiwcPBJkLj5A/+Zzz7H?=
 =?us-ascii?Q?PkI7HcnDLi4u8T2kVAIfW0o23hyKnA+Cm6+xqcLoxDUquQZLMUcJne8wAFJJ?=
 =?us-ascii?Q?esAsIoA0D1k+inQE1apSKNukDDpMDbgJfoGo4KUIodoTKlYjskuN/R52K1qK?=
 =?us-ascii?Q?genl+hIq4pyuFma3ojYl3dLPW/+KE3DP9vdKysP0W5fuS4m9eU8LY1NSg4zF?=
 =?us-ascii?Q?clKBV7uVbL9VDoAaa04x/ynMXNWeLGbE6cj15/PQzfiqwhTOk+zbxSS0SR1X?=
 =?us-ascii?Q?5d3Abb2dmcXTg+6LUot5ldD+gndFZGS/5Cffwp1fg4lqcjMzyOmJwildDXIB?=
 =?us-ascii?Q?gvh2WYcbfgNzMcdC1gwByTTvz6dt5ywXhu/g4YHgpwi1yOX8VOq92fup3bvx?=
 =?us-ascii?Q?bzcS4TSliHYsxkWxSLwZAsnvpBJOINjOOTGSZuvW3re3kP6hNKK6syrIH1bY?=
 =?us-ascii?Q?bmS/pQvLLh7kzu8cyJGcFLbEJ8w5NsLKWNnS8YFcND1qed7XHAMD1KbzbBd6?=
 =?us-ascii?Q?LYH1+Z5wUgH3okKSxMTNRUq4bo/v7nrdVVVG/5l02ccal9ql3pEH9lWXD1tt?=
 =?us-ascii?Q?rA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67807988-b1dd-4037-9ad8-08daa1c5f90a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:48.6603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18S4ESuYQoJpvOaNmd0KL9M8YPLVVPM7DYN9oKo08ukVmEpV3DecUhG16t4mCN4qYhSbM9XmN5jfTLd9Ore2HafAf7Lb5OEkNQtd9mJT9u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: V27FFHwsVc1YZpwPc8kDNDAb7t9OPQrc
X-Proofpoint-ORIG-GUID: V27FFHwsVc1YZpwPc8kDNDAb7t9OPQrc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 58 +++++++++++++--------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index adcbe3b883b7..c186809f2e17 100644
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
@@ -126,19 +131,33 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
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
-				.sdev = sdev,
-				.cmd = cmd,
-				.data_dir = DMA_NONE,
-				.sshdr = &sshdr,
-				.timeout = HP_SW_TIMEOUT,
-				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = HP_SW_TIMEOUT,
+					.retries = HP_SW_RETRIES,
+					.op_flags = req_flags,
+					.failures = failures }));
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

