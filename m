Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179F2EEBB
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969511; cv=fail; b=ANRLt7n7KAKutTOP3CW9bdhAB4KDV8o5eRTToSLNio+6jIlo6w2WsEVIXYqs74LCjOn7rjIiYmMjXp0bxbUGJBW9qv569BYUY9n3oIt6V0aHsDiLwbSSdAB47JCM/ksxoSCZ5MpQjzap3VKBiToZhxwZqaAYHpSHbEREmWAfM48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969511; c=relaxed/simple;
	bh=K5n9Li1sPsQiUGc4l3BpvDYcgdgYMj9pT7qkN0YyH+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bOQd4JJmvKxLkSrd1d6UKCKbNgXkWjoNu14l4THpmVUVHFVeE+qhydmnYYlshmxm+bGAO3fPJ6/QH8vaiY+GByn90Bf3oI0UP8fv8IZEU/KtMjOIqmGtbgtmtqQ54+xwmQXKQhOMw0plh1rJQfCU1S3as6whbLO63/4jPrQuDe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qwlhtj6j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wt/Orxmd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qwlhtj6j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wt/Orxmd"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMogLt022182;
	Tue, 23 Jan 2024 00:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=t0Kjk8zsR0i7Qe8RdIzL303MaDCOodtCk3SOKoVkj3s=;
 b=Qwlhtj6jkCQHSMUjdufkBODuyVzOQtSBL+kNYBmT35JJvNNJdXbqIUuumwN2vW2QLJhK
 uRDsErYDQRp7dxJpOFwyRIbMyvuF8loDYge1KwstgyDVAcxVYaKNHiy5F/NBueQk7Knr
 Ifa0g9RZwwC3pXx2LXO0eLxCboYtSVcmsKw/r/u/4Qader+Ta08f4KNKntRHweQxlcSu
 uARgOoleXsE7aaLE9RjH2AxuFTTjQ8NFqDVEsRIPLJdLh+oO9XAVIBE5ThzF6lcAPUm8
 Nip0oCsTYxTHfEmV7drArSggCstJsEw3v1PA6AJGM59WcVw8cgXe/i3C3y6JJEb3bUlt zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7n7vysv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMlq83016242;
	Tue, 23 Jan 2024 00:22:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32q0r12-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUTjIfnIruELQgKfsBaNg3iNIumlqzWDklQ1jegZF3vLFx+BUwptXLomPmubD+i5o59z4N/5E06gI8uo0EDSWIvfWDj/HJ6HPQTKkWY4vZx/OFsfUeifdasHO7BDpPKnp4pCr6S4JkcUMhM63Tubt1O2DrshTuya9wUvxlK+llUOw8OGHIreE0uvoedaiQ4BDiNs6Iyq37iqXy50iss/8dAgmTfgaxWv672LGG209jjJ6skiSLmcjqvYB0H5h3kidBexTkefl97S0YVu4ErGkNVHvxQW+9XF7jTpfNEHsHTr8xGJ0+zS2K7wFX5UTja2qlQPuzDoMjBoFWe5wGiS7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0Kjk8zsR0i7Qe8RdIzL303MaDCOodtCk3SOKoVkj3s=;
 b=XthtzvuEEd1COb5NhRNdH4deoERtp9c8UziQfW8yu6ijRUSA15WBr0DZptOu2pc9/xds+ky17P88nAPwnmGn4z51OPfscCbZcb5rEXdjFFDNdivyjLoAhqnR5w8lB44kcWOImnVlgPiOdsGk13SOuW9A8Dp+hfDydd81wg25GZNURed61+3aKkiiPmlzLO4v9Fidk+iSlQxmRewkLyMNY0WECL/OLz36EhF6+qOxrJRupF8wc8UiXFYf7MXmkO6JlWvicz196Zu51eWvDSkEk+0Znx0WXlFsMmLPJ6NzSxpItp4TfWo6SsnjnqVIn4X7CXRDfzoPlbwSeQLQr6U0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0Kjk8zsR0i7Qe8RdIzL303MaDCOodtCk3SOKoVkj3s=;
 b=wt/OrxmdS3XK1731F8bvwb6czQEF8+0ud4DGK00GF9zI7nUBXvZD2U0mhtb9YlxHTvFkYkhz2HBDAWOUTBeBuRI/6QUuReAxXf/+kTNDuzIH5kjdtkdibFJOj6g1yroBlquGGk5sHwRUvZth3EidpMMrQ7TWu1LeMEbkqOi39Vs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:40 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 12/19] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date: Mon, 22 Jan 2024 18:22:13 -0600
Message-Id: <20240123002220.129141-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d5a62d-8ef4-40ef-a8e5-08dc1ba968e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+MKHkXIdCOFjmYBY9fRPd1WVqWhstfhi8hG8l6MMi5I4TvJQir6QbdNWNY87d8Vh3Taj6WFMD6WNisQk+dOijGOiDjeP49VXwLd0KTy280GqpfHQ06fFJGrHDkGa+G9aam++uDUWvFPKSaesRiRbySablZXOQamPGP9iq9GFW/JiWZcbVttGPMwGQIe0QAaBG1ysf3oBfrjfD0pmTY0SJnjA2vZDUYFlTn6HEXb+vjDV4Ts0iuEsxUWLrXy463Uu90Xd+fvnnc/VGDcEgV1yUB47f0kkrJm0zFBLtYyC8cIscSO0YzKsSB13BtPril8TS2g4ffuoaqtSZay1dn8LSW1a54jn6tLfoafn0itjpudi0+bc2AweUOmNYP4sl4VIQDWNPLBl8Z2pEW8QI2qIP2nbLz6ljzMYJTx9i8VLdOsASgx/AsS47YFaCGHRx0mNdPHsGBNyuhZ7DpToleXiuCX/HDEuKzqvGtGADsel2X7BzNxlsr3CdL8i7k/v+x1+IKB/Fobo+nxSQhhexH/KLrpPsHrRa6mx5cHFHm6fGS2NsSf8BzffjbBya20RhK7N
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?kmTF9EYZfbcaKLZBhic47zAnL76AOsJ2CHfxe7TknhnmLpXkxkX5ODuhX3sZ?=
 =?us-ascii?Q?HsTBJQhOlEiJoZ7tvnBz5LPpgD1KmoTrP9YCPJWf04EI8r9nxJueRw9iH+t5?=
 =?us-ascii?Q?phPd1JkHG7ENpjIT1CIxYCnxoPY+mCkPQHAfpKJpFhnvH5V0KlPtoAU0E01k?=
 =?us-ascii?Q?+bM6doQCTWGF+XeHJkA2SeXJrrU1AhcvEKx9oOlN3Hb1NfxWKxwlWpollQHM?=
 =?us-ascii?Q?iKsT8cskJOzr1pg+2irof372tkFbE4RjRSmxxgdZEoFmbJAk7v6rqdh6Slhe?=
 =?us-ascii?Q?zC5CHc7s+Sjv3HtzdstojVnTUxrfxEph9zzGGyOKrDJSIWPT04KzO8gaF1KX?=
 =?us-ascii?Q?ef4dyiII0BtMWINPwz0c4j/+viX417abYTPDN0dlMvBn0L13txW15hDww4HU?=
 =?us-ascii?Q?aVtR9QzUGCrOZjtYaJs2MSe6zxi1oxNF31lY/dfwMiwqgjG1O44n4yqox27+?=
 =?us-ascii?Q?/nl+BUteTuXisvxyC6qFKEPz1RGqCdWXNjoIqSiIrv6u5qwzvaLQWzqhLpMR?=
 =?us-ascii?Q?0dkGrLC8OcQxO69exiga/VUeBhd9X1M4aDScNOml5KTGYvsjtwuyti7HzxrB?=
 =?us-ascii?Q?tRxcvCZBg/9AXYLm52yXBU+SzpxdG4pqK0h6E7326ezBt1f6jMWX2lD2V+1A?=
 =?us-ascii?Q?0Udyxi+QEjLs6gVwEfg/SHjZvIgemrH8Pdb1JvmuWy6z1Vk/v9QMYICkRFAm?=
 =?us-ascii?Q?NeJsF7J625xv3VQjJM43ihzoT2hu0rpxdMc7o74LYTPMWLVkHtMTIsNrX5H7?=
 =?us-ascii?Q?pMPMVbuJ/FN9h0CTfnpKDkv5zrjN0trP0RTxTkKqDWqZNDjafl/Ji39iXtC6?=
 =?us-ascii?Q?p37MlFt698TCZw38BXh7bcOg69hVbKRiS6sRuG7Cw01lO3Tr0hdZ4DzPFUqs?=
 =?us-ascii?Q?+gPUdo7NbW7pH7o0RJATbD8IrizZDGQtKDbEYOgkQj3Iof5yDj8MklDI2gR3?=
 =?us-ascii?Q?owh1G9S5w7nYXKR17f9yBGtRcXqw//KvmnpOpfGvt/PIquGDXJeZw802irNE?=
 =?us-ascii?Q?Eh10CCZpZAZulZdOEpZJZigImohPoBbVEmjOatbetRhNpyPfRV4YlURe4rgZ?=
 =?us-ascii?Q?Uhg2W7tSiKHj/u2btxZ76sX9PC8XhfcLTnMxm/Of6etknHPkt/mnCVNndvj1?=
 =?us-ascii?Q?rLyw+DM8Klx7uWqj+ZfSuR4SaIfT3W9E+dv3P4vRePzi/nYg9qxvzTCzF88X?=
 =?us-ascii?Q?ZDQVvEcqZIvv9XfQ3VLJ6XThD9EaBYSyEViwN1BuW7tyAourGXWXN7eYYMbr?=
 =?us-ascii?Q?0NOiNtfRRHhIKVM56Sn334nnf11QzhSy1Q/jvhjK1UT1WeGQTpyhbQvIM5Z6?=
 =?us-ascii?Q?VqrTC9uvNVuE1FkYd/Q7ngSQDyzioETCRfKSKT0IjD50YQDhzeJrju6kzOY1?=
 =?us-ascii?Q?JFDWHx+VB3bDA4E+JThJquaB+JDtaF8dbuE9RjNrlBHlFscu0sadBUY7m3x5?=
 =?us-ascii?Q?OUI2KClQ+hz2yk6+G6auIn+yoTWOTvwORrQ80gJixWvGGUxe019x8pbZ5+4n?=
 =?us-ascii?Q?VgQQ4Ax1jGlEBeBa6so+7cGL5mj9BvMhS8H/cDik4ojlI6MtvMj7GZMNTQ+O?=
 =?us-ascii?Q?uI1Eu72hLeJx1WHL+7RdYOUw2cFcfbGiZGO3MCbg6nImMp03PSX+u3SWul2U?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KEtZE5nqS6U/GEFaBLbSftTN6MfyXQqhxEGp1i1jKSotm2qUQACJ2rzisCPMB/yFP/+O6yolAL0bB5fLQqlRQ8WCZxR7iWVFMJ/zs9nVOEWxDrVsBKvgo5b+J7M/CipQdlUAdrXe+hsiG7ZW1MHjhIy4CNhIm2yaNmo+AHuebqy3uL/ZKhYWqcbGrzxOu8CoOulDlLE/fwFesvT3JT84EEfCzipyEcEWUa+gB10oxYO06cB+Zp7JuD0LARs3AIDQSHzKKTiHkj5Rex0oPDmjkc54i/ch8LTgwN5YgKajjBZbOhvQdoNQWUMmOnhgUQSwFIKx+sCcDz6BZCA/2scW9nwcqscqPmH2hmK7O5ZfAhyryiHpBgX+rDnBD0Wr6fJ+rkHiQZnbaLlIMZbNlJ4CLg6yXOYB8PuwnnJqsrkjam/mWP+SRp7VhiBFoLTuxrnIGLA89Doyw5PMm6tDmzzO/vf9YESGOTovuJJSnJv8u5YhJMfIuZqXxaGRkaBfg9EBrAX/eHqko0qZJ+6241H48hCCRhelyg3syaGRkNfz1ZKjsTg5Rh5czDzJ5I3T5YjLh88tSrxiiIxcbsbQEBcxQzq8kljc9i1swkpWtwdtgpA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d5a62d-8ef4-40ef-a8e5-08dc1ba968e3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:40.4216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8jpNKojXuylpqiuiuxUkU9qAB6/sZD9JSOpMlz5V35XP/mShKvTFk5b7CkPoytx2vMWRlUEZdLx7WVscZsAiyECFs61YGbe17yPfnR7+C8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: 0ukE1ZGKEHbmK-NVHU4uxPvnOxfzCiPJ
X-Proofpoint-ORIG-GUID: 0ukE1ZGKEHbmK-NVHU4uxPvnOxfzCiPJ

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 868f23517d33..9b109192c51e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2262,11 +2262,25 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = &failures,
 	};
 
 	memset(data, 0, sizeof(*data));
@@ -2328,12 +2342,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
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
2.34.1

