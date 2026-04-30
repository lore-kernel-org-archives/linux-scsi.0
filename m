Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116046AF08
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566217; cv=fail; b=V0OO1a8S/X1l+H5Ku7+32kE1CduvAbr9eR432vUXvPQhzEsBvN0n4dKwN76wcvFYGOBXFWdpY5kPHJ7REBJuW4q4f127xR863Kbh6yfXfvlV1EAK0mpsLSvxd3Np9bhipALoLkmA36//UZPfKb+n4jfEf4kal8ZpW6j4Sv9Vr5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566217; c=relaxed/simple;
	bh=Us9Ukl5EJx/I4LmCC93TJuurtSLRnDCFZUiDdJVMRy0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TlmSFY7uziqkTn6lGNjBPYiuI/OfFcQLNgYQ9JPEUhxFIZZYi39AzaIpylQz4lNRtncveH8OgXrLCdN03Bw9V3ON9sFE2lRVQ0jqgRdw1OpeYKIVWGTAML/POusxW4DIj7SMotJCaYOYdaC2CX+nVxF2f5GQGaQDIql7V8spYmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nYR/z9fK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QSumz0Zu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nYR/z9fK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QSumz0Zu"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCfP4f3325596;
	Thu, 30 Apr 2026 16:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+lJbuE9RcNE0qti1yF
	X9UrIlLg0NNAaREhQ6xMM9QMU=; b=nYR/z9fK2WZdI9F6eJ1ozdLfyV4hU4J5bp
	cMl7VFOhTUoiM8Vu4rqKTeOGzaN9KHafqgP/L0DAno7eQWsTKd63vIMdpmqn5n6i
	NZjoorsHjTRPBcSGxK3B5+6iNNc9qPugks5YjMuH3Sk0TWHQyzkV4bIq3gHkQ9ni
	jWkTu5AIGqN/Uy85TYiZW7qAujI10uy38RALAzDHP4VLMh39OYLzvV1u5cZyYqy/
	/4xBVq6ngMeKjsJfvfdc5IwXndyrYtwbOJwjrD22qaptMPYDuqBlbhVdsWq28Qt5
	UkrzTmqKuCDC7Qe3jDDI6kCmXeKspfAzSnmssEu+/FrLDmwDScDw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnenpuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:23:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UGGRFb015368;
	Thu, 30 Apr 2026 16:23:24 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2fqkqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:23:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5BXC2EMDRMnf1G0h69HEJ9aSWBSZReaGZtorWylNk/MwVB7y9GVDiOZZluPBHtNqYp2obGlC/xVWfJTw9TLi2TAyHIOwmAek2q1A2mGUnzIF2o3dKrJuSDKuGT83Ar80LEkc7reJj9tSNMVlPPauZpvUce09obgMzjpDcAOEYHAoOgvUVSaMM8095H3cp771OUTl42GxHyFkHg1I9y+ZCtkF7GuaFog5DgkRBnVbIIVotRybvc/RLn4hv06Ne2OjJ/E2IXLT1VJ0Q51H5E2tGEJxJGG5K2FlO4+AET+tcb0d1JQf1cq4MKac7Ne1exvXsg2pnHsL7P1DR1b5+sy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lJbuE9RcNE0qti1yFX9UrIlLg0NNAaREhQ6xMM9QMU=;
 b=P2Ym0NidvCz9arFsy8E3+jEpB0xYlcAPa4laUPEqqsxvuoCXq1lawKIO0mZaZV43uMbDalqnyaO9b/7RaFP2Z2Eqf5lMC3hLnL56ErHR5YZFPDJyW3YorAjecyPOSSn3LM4fUCr1pxUX7qO51Md3f2kWjHmTl99bQJZRXe88Ht+F925mFplXf2uakQ7vewGv/9AYWdeDWRSu4C/doLltJOswe0sgIuV+UMm37UA+tgHMhUp3RF8o5kL/j0m0RIq9L7fQOSjbX6cjrvZ89JChDrZGLBa8DhizTwf1M40+hJNQvlGl/sdl65FEjbdLrFC5j8g5BFjHNSKIAUYxPcWh/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lJbuE9RcNE0qti1yFX9UrIlLg0NNAaREhQ6xMM9QMU=;
 b=QSumz0ZuozwKe73g5nkKL0ryiejovzcNIEw9HZLme3jxBBMMQh2Zp896cjus1Rijq1KPrlsk3Usn7J3JCBnjGCcPlABistkiMhCl/vDZ5UwQIWKL5DCtLxT7dZLFCCUat8ZRw1UTAoX7CTrPIK3LapUhETrOg5hNvSf+6roUopw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH9PR10MB997858.namprd10.prod.outlook.com (2603:10b6:610:342::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 16:23:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 16:23:21 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 2/2] ufs: qcom: Reduce interrupt latency
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260402171404.3008494-3-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 2 Apr 2026 10:14:02 -0700")
Organization: Oracle Corporation
Message-ID: <yq1fr4ce7w5.fsf@ca-mkp.ca.oracle.com>
References: <20260402171404.3008494-1-bvanassche@acm.org>
	<20260402171404.3008494-3-bvanassche@acm.org>
Date: Thu, 30 Apr 2026 12:23:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0311.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH9PR10MB997858:EE_
X-MS-Office365-Filtering-Correlation-Id: e46ac4c9-1a4e-48b1-4c3e-08dea6d4cb98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	g7EuktLso/JrsTWrtFAiIA7KPscNZAmF2JF2wSccLmGfxaNz64vlXqs6dx8l3IbcVNx7dzxGGZ/vemaDyxTotLEnUYUDo6CGhCwd2pJLRsVTsk/nZ/awIeqMv8OZhCc6yRHnNSy1pm31nUxbt2BJNILEJqm1JZVj7DKTNIjv93mrmf+4Yb0qdeiZy75QRUEHAD9OhUY/4qVs59sI2BmoUnABqoUQ/jtiAdebPsAeDFQKsq4d3aB8gOq5cw2/mfZt+skWgMk6iQbylG8Z3kgyXCkOe1FH5MaQ5FsefGBwNN7cGB8ZToZyiS1daPyoPU289cTE5xczvU9QNXEhoH2lvgvtDVvI9qR+1qEPjBii2PwBGbWfs+pnVBxyOQezIlW76FNBV1LNe34mF4G5h8KTIOA3MC2yXk5kY/d7rN3GyruOcuhT0oLj+nHut7BSWumYV/eTUH9faA0AP03YEAgeJzHe7fAb+mB+OeBjnbvq3d0NcxWIYOiL0/NApkSaBCcZ2MOQyZbQh48IaP182X6O+HyVFoeMrDYP+oiM7Dkwcl0LzoNmRpSSQL1jWG3W//lYcjh3ojo+RUcKcdXnRh/5Oh+k9pWod+eeeWPMjPEYAbPv6X5j+VdxeaxkFgSGRYvYV3TlBkvRa7Pn7BjnQRmJqfY8cMZBOAG8rNIC6HR6oVv0FucGeKeF/rEeXjKkcAtZXV09fAxOhdocdl9P4Qr8KQ48BWB1FiSIRnBuArYxaVc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YZabzanW2Gynimhgg7k4vscCghevl9qqEPIXGJyizaMCJL2k7P/GH+1ykZD5?=
 =?us-ascii?Q?D7EZbs4IEtJ4NgS78q2vOAglFt4EgGg8IivT7Kshgzz5O4oSJnp39oPH3sGW?=
 =?us-ascii?Q?r7OZmea+sJ6CjaULA6UK+HF+k8UannPHOCWtQO6nDC7yNbYaWhXPQti0Pqrm?=
 =?us-ascii?Q?GqIjU9dU0XCJimnKGdWoMB/2J8lFB2P7afuREKLoixtJZf8QaqiHBu9a1w9b?=
 =?us-ascii?Q?LYogHlXH/UTE48kSSGMN5bkLISwDKWHUBXljCEmnusZ4gXhiG0zmZ72K2+H6?=
 =?us-ascii?Q?xvumik8CvT5vQi3TqxM1N9ZU88za3LfFSUnDb0wYIIEM3lTWF68wlfo+AieR?=
 =?us-ascii?Q?mGnbFKlOSUBAmoj26DajgyXdhU+cMjdaD5kiZRv5czrTg9oIyDEHeBelihsx?=
 =?us-ascii?Q?oGTtsrFE712giNX7M/DLWkcAfm3ehIpl99QJkneQJtSsmHAsOHecunGQCobS?=
 =?us-ascii?Q?HiqVPTZSd0e4+0kySHw72qiW6yM0/bI3k9Cg/UdXGiPSbm0c7K2ovjrIOrIL?=
 =?us-ascii?Q?OfDFCjhAT1QS7Qx4v7vtwnj+N1oYZR6sVPSzcOnhkClPAC3iU2dJU1crnNka?=
 =?us-ascii?Q?VCiBHGKoBo7uR3aKwiGL1XqVZdo0ppuucTvwKJ3GUwSEXe0tDOfmsZ7tlKhf?=
 =?us-ascii?Q?yNeiftS3Ya5je/eIiiQG8VQ2jfiz0KKEBanjLMQur3Q3BIUrReuIQkIRDH/j?=
 =?us-ascii?Q?cvC2jVL6WI9VqbfNiZROj8L/9UeqC4h9FiZEKZBPhqpioVXXkxlGBkhg/u+u?=
 =?us-ascii?Q?jGUsHcUZ544JSSA6ouzjOh4+bzdUcDKPwuD21Cp4qWUMAi4E+eRreyNdtV5H?=
 =?us-ascii?Q?ZFWfIxISJqdTJ4WTL7pvZVYp/v26RQ4DYLhnzmfGidkN72VDMQFsC3JtN43a?=
 =?us-ascii?Q?nSxrY18HlTrmUd0uMndwJB+887o5h4sxm9lZW77HEAA/0Qp8GQmnbtQCiknm?=
 =?us-ascii?Q?IwaL+EkXn0xYU0rJsFohYk36tWx5IG5Q40CGlbKYLBDPbrZ3eTtig/GAvUMj?=
 =?us-ascii?Q?Wykkn9TCP6yCjmpAmMktjbbcr0eWXW/AM97FzcYorf2w4BtzlGA3H5dk8C8s?=
 =?us-ascii?Q?GKIc/qjOAhYRXWHYuqfSzYSLbDdrDthmx3OZ/juYbPX9c2wu913DU+0f7W5Q?=
 =?us-ascii?Q?X3YCWH0lgZFNKmR/Sxu1NlnVpmZQoIzAN0CIfpZS91VWJ4/TDevSJngBHoGd?=
 =?us-ascii?Q?n5kcIMI5akF2kTv2H7LfBhUbWG2q1fu6syFjTxvWG1qyhHbC0UYr8+dgXSdg?=
 =?us-ascii?Q?lQkglkwYqFvjcBLxY3hLlSQqgObDEebMCObjy1sTvYJsjEc6/88nqtLNinL0?=
 =?us-ascii?Q?IHe/UZ4KETGADcFkcq8LKzdiphi08bqptCUSUPt/jSN1vwBc/mZKw4phiWpH?=
 =?us-ascii?Q?6worSp+mK7lY+BVSqqONumu6MpuaIAeJ69oC/NV6X2PetBMNZf6mlhJvd7XR?=
 =?us-ascii?Q?Ndbccpdl+NGHG8PXGkixBgcSWRad6BYsj+73sZ1PzKd8EQbCbNXeU8rm3lQK?=
 =?us-ascii?Q?Nn3OhTdTFPbm1clp9eS3xIJxtOLlP1i9g4i39mfG+Hkrd/zPGSXd4P9fZ75Y?=
 =?us-ascii?Q?Nmx5BeCv/FOu7Izu3tP0InE5++9GWO5ToVhE/rLwY+EaaxtiKpTiLX6AnJ0N?=
 =?us-ascii?Q?N1pRRJgkwy0Rl2gGU66c5Ryg3keX4SP0MOiqXNYaiRyXLH+/4ocBtgtmanLH?=
 =?us-ascii?Q?l/a1W0eUUU1m5aTIehBbPaHaFiqrLfHviPpjrxp8OYfCTAjuiCRWBDERvnnA?=
 =?us-ascii?Q?vAuCF54vGjqQR7QRw+o02UwNtKU6IMs=3D?=
X-Exchange-RoutingPolicyChecked:
	ox3RZu10kuFfSkkCmSBi81KKBhyeedheG5ztpc9Qs8EFFxsEf9wQliEblMo1T7aLHGUD+Illvr0byB5236QCM3N+5RVgQnQxWoCw56AcM9Rlezrylop6VS0ct7mUUE4d+rpmVow2ArzIWWSeBU++Q3e52f80uexXD4aR5iEjHUG+P2fHPBDxsqGVXgoYNDBuEXPW4Mb4Tho2BBEb/JUrQGJnI5L2gb7LAgsOF9caUoUz41vBapUw4lPCRRFEWP42oRyu0Hnmpc2WgN/eq+b8zS+u5WWxLxyYYPfLTn0xLYLa6/VRXIqyWNNLtiJ8Cx+U99kzMcfMdDPB39lpi+upaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t6fB2a65eAlubAHR4z8BrhnVPrGm3nXDwLh7cvLwbypqXMDwRpx7DzaVuIQknkl1pbfGk3LN5gB27p0tXdlKR+w6FmSEoHyqxKDag0sVlDxp9BIPtj6eLMn1ds81eWxdw6WcKQrLWnKqM971M3BK0NQVMG+ULeFBbzAiEXGroBa0YEmShsfTsHZ7Rega5uan4TkgPlHfzvMLj6zVAiyum72cQCd+s45xBY2q5vJ1zhodAvhXlKdBzP+ynlmmrirmC4E+5GaodliVqIm19laeAs9TpzFw62SgHWx1hGMCiPLuPBemQWTslgI4RkS0Vm41qTG7SCjPOZqRq6myvcMgjVP6fZTN1HteoIXufsUNBG73OnfUknWEexnWVZneoiNGmX/jjq0LSqNlxXPZhA5jyNbKxAIyl6afzKZPQGs8QgcSLOrNKyHORPNeF20wXn5mKnviwjjWB/f0N2HYOlpmIZARsFME8gG73Z05yKk3PPBSDPuSHsZP2HGvEfPNUMrV/j14cn+QT6dZSuh8V8Dv2RZ76uP2YxqCkrEj+8UhyKDSMidSDLoQpTJrzxWlMpiFsGrCHINMcd6l4NIjorNH5qIH5KMGFwXV3licLEWCGPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46ac4c9-1a4e-48b1-4c3e-08dea6d4cb98
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 16:23:21.3884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeFXJXJ9zNvHlmwild5Nimjr5J2+FkyiDL9mYD2cC+YSW6CZ3G9bbvlcGFw2dmLK7DmI108xdphp2U975le7CqmDxqtktCzJDXjJbO5am1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=630 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604300169
X-Proofpoint-GUID: 6y1AfYn71QPrJKKaILTjD3iQcz1Oq1iG
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f381fc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=NlBLb_YB5W_99LnLvWAA:9 cc=ntf awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE2OSBTYWx0ZWRfX1GfUUypLFNbE
 8IssNeV+6kyuElmDWhul4fBWIwiwrb9Kt62UQf4Ws92ZLVQJO8JuS1PjWAJvAlt7EUn1zWMEDzw
 uNs/mMMoQcCuLOyP/XU0c4TdkmFRAWZiSgz3LDrmBGN2vPFTXlAVeVtZiHv+4yiUDLTYwoNTFr9
 azeTWI8kNOIevSwu8A/pdKeNEpTmCE59hjATUuMyWWbjGx2odSRNiqQ4lWXIqv3hVJIALuPMGoS
 8JmqjXhYDTfduuViuZ3eIHV+Fypvmatidvw+o3mXqU9j+1weNZAzjFb8gx+wywvSpJRm9r2057B
 jTbqtjLCtd7Ruh7T5Pdc2jhC60GB8b7utwmp+4DrbQwXhFE3e8lMFxfkkwjv5+JVrfkxrovEB/C
 j6TInE2dl+igY/DT2LVbmbJBtWDp6hjYInJK6hACqKTdF1P6Dyb/W4hYdkzDFvsiPjTA98SYrjU
 1KHh8ZB7ZjpeWXUq2TF2Ep83D+vndeQp2WDArqrM=
X-Proofpoint-ORIG-GUID: 6y1AfYn71QPrJKKaILTjD3iQcz1Oq1iG


Hi Bart!

> +	if (ufshcd_mcq_poll_n_cqe_lock(hba, hwq, 4) < 4)
> +		return IRQ_HANDLED;

Magic numbers...

-- 
Martin K. Petersen
