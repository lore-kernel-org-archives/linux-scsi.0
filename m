Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BFD14D459
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969363; cv=fail; b=mqVaGAHvDbZw4XVhDs5rQvCw5gJ4JcYuJGhk3unnHt2W+skZwRF3A5uobsuZ4GQKUfHcppW2EmRqnYQF8YYJ6DicsiWcTW52+llMD2IrVGjB+IJcEwbbo8r09+5jeLT3wWA+lZsCoJnyU3ycy4228q2odQTGzRH0qzmJSjWQZt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969363; c=relaxed/simple;
	bh=b3SBQxcfcW+6zj8Dtw14aSJT+WkeJE0WWyGLJu4Qe0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZT2hQThmXSn74qM2509G8em1MDWYire3HtYaf2qyXJR6NR9jY0f76lvk+tAz0lQRp1E+A8jGAZI3mClcwI+jAnENv9oEcniysGIO6U06vQU4HGWHro57kwbFY/bnKntG0E5g6NFqtuq8XI/yC0pp1GDv4+PN0ydMthhZfHwMsnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hk7qsr5A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EgZ0WGCA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hk7qsr5A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EgZ0WGCA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMovBo008245;
	Tue, 23 Jan 2024 00:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=zAYjDajbSvI79mZBM3zspHWDMEx6LdW+K2xyzvxT728=;
 b=hk7qsr5AMld0ZE/Xtw3pvHtLKa6k6EV5HoL83Nbm59KvfhtnGu5zHHarF/x20rX3o5zp
 IIfCPjKov3YRvCwFfnqxhD/3FcN/1f9Kqk5bglzT5sfQZhWY4OW138RMqZT1h6O6h9Fv
 ivYWjDODrs87Ti98S4brqr4Fh7v9+7xj1p2Du21L0c/Hlz6BKesp3yXodUfjRgdCfy9R
 D72K6m9UFU6NPFsMJi1J00dUC0yHB8uxazdz3O6KGHrjLTL7+UVwHhOxubD23pyHudZH
 BKcdWwM39BODEUvtseFG7NkN/FsoeZYPZOrqsGBDR74Qn7G2hkff+942BGJpAkMVmwY9 Tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr79nd2dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMluSv025289;
	Tue, 23 Jan 2024 00:22:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34k6-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMWuEG7f2ISTI1ubxCTqWhGhkE361W+Lc0ciy937Y3mynXR4fVLSma2qvveCZo7Ny+8J7tKdfRdGJCVjyyI2r5aqsMeJtcX5iOi5UBf8nUAxWh2wflQmM/7GzjDeTC6FxQEOdfMiEvNXrC34CoCw9AcTVdK6xtC1DCLPTdTNGBNOaoMLDIIjjKRrE+yKNj3++4ORJXep0qnDIwVO0z2LNOxVlSiM8WEgu0EUOU1tojv7pIMY3jOWqKq2Wta8ZmudxVeap2IHhrek2DN5xU9JKJDgvZxUzuwZWTkbKm4vUEFwS8tIBjmXlBIGcF/dH5LSlMAPhW7Ew6lPuNqziwg9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAYjDajbSvI79mZBM3zspHWDMEx6LdW+K2xyzvxT728=;
 b=DQcrR5Lo/hJQwMsKBxBi65UPiWhlC5zXupNN2RvMZPdbzlCY/iSmWyrX+2CoTgkfLLfrB84OuJgDhuK4SjJDUe1gH8o3ryuJWRD9nUTanW2eoLfkgwJsAKlL8VjuU1ZeqZ65SyUBEA/OAfE/7+HVVuVTSVz8DmsYs6397BQG8+2j/oOJSaBPe/rjH6vpeZhlykV+zc8/+ghpyHhJY+uElLqWym0ITyl6AT6VcIt+Dg6Kau1sCF91k0hmRioDXNL3AwHDH/osXVhLh/Os36eTlTBErmBjS2tM297CAhEU3DGpjzCORbMPAS4lOuG9k3/muPYCv/gk4vjcf9yXfbvq7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAYjDajbSvI79mZBM3zspHWDMEx6LdW+K2xyzvxT728=;
 b=EgZ0WGCAtCqZyyuCGXhVMtjKFO0g7mOFuPuhlwIRE6jrO4fComgWf/OE2+ly/FU6L1sc7Ubkx3lhkHl7OQTVe1u8je0qR9+/FV5ylKIf4yVdl35G3qh6DlOPiMH3W08wi/9Ty3Pqjc4ulnaY9KnO6FEVYiFjzuSojhN2xDWwZXY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32; Tue, 23 Jan
 2024 00:22:29 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:29 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 04/19] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date: Mon, 22 Jan 2024 18:22:05 -0600
Message-Id: <20240123002220.129141-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:4:ad::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: e83aa56e-8c5b-4e33-8b96-08dc1ba9625a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	v5DpjPt854LvpWgOKxsaruoAwyHxecE/r2hqqREr435niYzTzsYfb1mPUT87DxLQToe8J5qF7eK83lFjWYUzgdMlAdexq5YMB2gVFbqc7CcpDx5JG1RM0hat2P9bII6362gtWo58E+9okyCEVPMtY8U+YLuiVrTvJ2V3p7JYWffLk+l8LlqR314C1HS6ywXKaYE/1vtmcc6HwU64ZUCbDrfYPWtO/iUIBaED3caPENwUn6BNlCOP+hkRAy4+piXZli8+nfM2i0tFPs/eUv3HvGQ21CJtL+3pQnYk5QYQt6mR0neTfQOGd3bJKHlNbfrQKi6JGC0G03kqJpY9aRwBekeJVEet76hhUPmLhQ48Nl36W20ngsaFPKUJhhZSlxbIIOPkbkpLloJvrK8bPrLGR1ft/wuPgnvofq4r05k3lC7/xfwFz+YxtJk+UrnrIC6Shj0cRTBI8nkIy19IZbmysIzrFlfPXYyHLVoZUS4os/MG0Ru+DncBDzf60vkVGUgBceWhQXGalTnfb22Nz7aqCaCBI7dBljQnYi9tQRZ7gOhaFvjoeJJnZKwKKWxq2mqa
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(36756003)(86362001)(83380400001)(1076003)(26005)(107886003)(2616005)(316002)(8676002)(66946007)(66556008)(6666004)(8936002)(66476007)(6486002)(6512007)(6506007)(478600001)(5660300002)(2906002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?sZ7V4hZy6bWfruhKyuNlD9AUXhAaddDVQ3QQMskbD5psYRsm/+qWlIInXhnI?=
 =?us-ascii?Q?LDpU5SPdX/9z2pWDm/pNMoCCm86i3K8hkzS9WIQ6fZ3WL/JAxSKFiAgaCq/b?=
 =?us-ascii?Q?SOsG86VmL6FEtAICSRkl2cMFd5LGw5LPwK6ZTliN3w17EdeA7IziDyDnRF95?=
 =?us-ascii?Q?IvkcRj2Mhsyxf+wDbSaThcVkTM77xgHgKledqBkKdc+kuDLdawj+J4hD9wRu?=
 =?us-ascii?Q?DXY2BqpwlP5EcLcPm4zTOevXLnvZFDEmkMyc5F2Ozu0veYzENvp+G96WfCuo?=
 =?us-ascii?Q?A199/08Kcs9EE+pZI9Yvg2hkvPe4fV10xC1efi+wguSPiCrshm3Ck1PXuOcJ?=
 =?us-ascii?Q?RIU/w1Y2/pT0L/1uHw0HHRGlHF+bLFokJtAjlPxQOCeM5x8ZsCLyTLhdwoQ5?=
 =?us-ascii?Q?zvfwF2GhIQpqcNyv9HUJAZjFLrjW9/hDs2ypdiMiaYaoLBKG5/hDJ9+aEtkH?=
 =?us-ascii?Q?FvSEiErYWcP4ONmJvBqwbLQldKpTU9ayTN5smBj434c0vm0NN6SICsYQTjuU?=
 =?us-ascii?Q?JiUsmgTC/KotWSBcva+BBwFOqB8vrGbJsq+ykw8a8Ot8yIlmvx0OSKC+pi7+?=
 =?us-ascii?Q?bZ07qQQcDPs+iNoCyaAUcL2/rNSdIAhJSDOtZcO+7/hC9BmLmY6mReRfM8wX?=
 =?us-ascii?Q?4IbA6ryFB0POqQ8746oFWJXc4JSjw8LChAUNqbegzwQDO3C/Ka5Kl3mMsjTm?=
 =?us-ascii?Q?FZhmumYKLVQyarooHq9YQPxpJRVNLSaNaxesDDXdMS4xS0jH3ZRYSeMB36eE?=
 =?us-ascii?Q?8E4s0du0Gi/R5YwVKKgwQ6TfONDZ3/6St0C/K3e9T6Iperaz9sAnFZpjwC9q?=
 =?us-ascii?Q?AMx3uemdlVhORCdawuj5gUKVBSd2VWDdujA1XPfkC+tdYjwAahQZi2avWZuM?=
 =?us-ascii?Q?EhhjC8+mySSVVtGGroP620qShCIHlRG/DY5beC35wm1XEg6kx1bY7Zg0X2tD?=
 =?us-ascii?Q?y+U/RugEM5LM9lDvEJQGzB50760Suj4Psg/IGHP1tfcgDy7uckl3/FHHJsHS?=
 =?us-ascii?Q?BQOGRby4r95ooeFBj8MBttRZAGWrn7CFFOKZX3c09FHB79DhwKWOmP8EpGzs?=
 =?us-ascii?Q?FWBgP55jwvyXYF56iJgAFK6pSRs8ueUUhUviriCmAUgOQA+nL1tGkk7O3/af?=
 =?us-ascii?Q?w0ukWlDR7KsRJrSc1TmnHzeYnpUr1mDqqotuOD1Awvn9gk1SfMeEX1Z6cQRh?=
 =?us-ascii?Q?a7OZ+14q1S7nMSZsg2tHqWhmDbSpyr2h0VMYGFVjVzVjNwnc95BlxeFUpzXy?=
 =?us-ascii?Q?+nGwfwz0779s0LlAyp8YdN5eFmA+r4zZlBmfVy7nuov0kLAs+01ZsfMn01Pp?=
 =?us-ascii?Q?cDorIEMVmL9ekesHVjPrJ23R9coOxSn5lL7Bal52yz0ZtS5hsh8b9zTOn9IB?=
 =?us-ascii?Q?K1H5UdsqHiNHKujTAsmHubTgAmOFm/gxbmgkDHAsswq6qEE4I0TeehYRA+0v?=
 =?us-ascii?Q?svgFSlB4VWZAhaTU3THe4EG3EuJEyZd1GLO2l2C1XZXSPgs10dNGRM/Fo5rd?=
 =?us-ascii?Q?Lzvgf0vm8mWU3OovNkZISHl15z0lSv3KCSV4K1LdbnyyqTxDQ/jj8NkBiyaU?=
 =?us-ascii?Q?GlEl5Iy78NMbXtM/bXjzx0MSSawRnHsKFdApHmWLQSxrWGxJ3TlF7qDZTOSc?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HQAG9ztCU7qO2kjF3EsXk5P9VokIF4gkNkbtdSYKwC9E8GqqTKH3WTnX8UG2BmflUXywxfWdDGjQsAxOKESfHoy3Tl86rDaJcdKGlL66Dyin4AhDlq3q82oy9UtMqHnygIZ2eOcsz/3BFgQ66be3xv2G1lOMP5wxWyEWrd5yY2zZBORgzIcRmZMOSMbtdw3dq05gW6LSvtXEZT+FzNQnuh+tPuaHjw6QuvSBxF32sDciS0hl8AWq7DfeaseA6j+K0u5ZrUtziAfsIC16hZxie4c4Q3Ow7CzU3xl9I68nxZwx+f6i3S1xDsoAqKVTk2oHE/7aS8UaYxnXla0vteAODveWy4Hw4utjDGOW3AjoGZe8xdeNQAc0Z4hXSun1IK1F5wEIe8gd+4qNIM9zMF4B60XueHWWLDzCC+UhHMTAUNEaYU9UYRCdGv3Q8e9xZ8fgGI+iSYbZQInDSvU2KBnqlqcsJsu+L/WzNVQuWlWSN6FIY1L3ZaO0oNS2YJNxBL3/VdxBB7BM12WSqJnhpjNqOkqObH5ILnlESSFBaqQGt4IB5qTwJw0i/6wpTKKP3OnvrCrKN3epnAdNEF4bXrTjGiiiIjig3yWHDWkvnA2x6bI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83aa56e-8c5b-4e33-8b96-08dc1ba9625a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:29.4334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqFwa053/nFACNKK54HRm4ze60l/MyUY9+BJUKdDIkrZxHPLB8rlHsL39ILUeaH36hiPQFCFVyujB1Ew0KH5W1Kn9JFqxqgJUWdX8NOVJuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230001
X-Proofpoint-GUID: 2ssjpge4WfegKD7ljfcdAMQTmiqS6Fa9
X-Proofpoint-ORIG-GUID: 2ssjpge4WfegKD7ljfcdAMQTmiqS6Fa9

We currently re-use the cmd buffer for the TUR and START_STOP commands
which requires us to reset the buffer when retrying. This has us use
separate buffers for the 2 commands so we can make them const and I think
it makes it easier to handle for retries but does not add too much extra
to the stack use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0833b3e6aa6e..3d85913d373c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2318,14 +2318,16 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = {
+					[0] = START_STOP,
+					[1] = 1,
+					[4] = sdkp->device->start_stop_pwr_cond ?
+						0x11 : 1,
+				};
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_cmd(sdkp->device, cmd,
+				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 &exec_args);
-- 
2.34.1

