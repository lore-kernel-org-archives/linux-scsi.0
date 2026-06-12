Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90723371D0A
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260725; cv=fail; b=PIhawp1HSzTdm3+Qm5ACo92Pdubk+VqFiTGGU5ef7FfyS/uD9MHBtwIjltHeFT1wBY/mt0KFKp9lKOZ5fR1DyBhKtUImAKvC13zv8KHMwfuMucwq8EOP+8c0xvv5tGOuRIVgHIk4XyWU8yHKo/TilQtgHCtyRffX9S6eI9VfJDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260725; c=relaxed/simple;
	bh=15bzSWot1o17CfZubHbQFg+lrbjkQYkOfVVNn445qsE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kEDSbtjkXl18M92xm934o/EJnNMZVtB8GFkeEI4MEIT5KZPc6GSziX6xNr45sxPmxgJDoeRXMY8ttaDdx25MeD/Na939lePg54opGnxLYFsl22zaZzwehA+Ndr6HmtlC2U8Y+OVUwawhZxFtXoki83rlFtbDH8gnhOcYs7v3D9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TD6DGb99; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i6qkx+0P; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TD6DGb99";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i6qkx+0P"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C7NWgo1634356;
	Fri, 12 Jun 2026 10:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=XtDZnNkOPU4gZv4R
	yiQqPVH0O9lRgACIrM3p52Vkkm4=; b=TD6DGb99cRg2nX8DBOZGtcA64k51cB9L
	2kAQJ0HKchvJnQYzTe1SI8DQ9hm2UYWMfoGQ+//MP6ghcGEz0NC8PRrwcDUWea2Z
	n6NC7EttMaiUtBOxTBWcH9ciQdH2gTJArhwB8RD39wlEuuKUbOJfi/rpphcRrJ27
	8y4IkkBiCizeyhpMc7RJR2lcLJDy0Y9vjFYTN3cEdGdfboyY0FhsMRGOCpEziOWH
	5WGqcOzJV2UpZstyA1iYVvcFZbBI+Y6/rs2S5qjWchtSlmk90flpdcjV8hBVMp+L
	0cd1gdrVp9fVxyF5rsBEgfEUxxaAsps2qFlCNg+si1NAz29Z7UsWsw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eqe6vardk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jun 2026 10:38:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65CAX7QE019874;
	Fri, 12 Jun 2026 10:38:36 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013034.outbound.protection.outlook.com [40.107.201.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4erefwvf6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jun 2026 10:38:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5Ge6fxzveGKutpspfLpu24uif8Eqlx/FfYKCXBWWFkG8Gpu3/+u9b4gxrvQG6i7+mecpvniLtvy4iwSzGBqxYGrnMQ+j+csAXJ8pE/eN9woK/FNQXQ8TBHWO3LO9ikeCldIsBzUFHrw28SrczyutfU1R/D6HfTBdvzyn3vkLjQr/7+0edSZWDhN6bBqB32ctL6Ba/ZfDTNZckZDU6Wf7ngjVzCLSs5dW09kZclBTl6Ry1JAsLWKv/gPhUFZxaElQRSx54Ud6k+2wgUCYjW8mqrx7RoU4+yKf9qTyxQ38MC4yj6HzKlnyNRZpHZq73X2SlKVO5qAcR6IKH0bmPvRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtDZnNkOPU4gZv4RyiQqPVH0O9lRgACIrM3p52Vkkm4=;
 b=R/Wl3ALTCYylyP5FGZ3SR9wZzw5tkirdFRrqoESHfJGUsGUJgcnS85gp70/QsEcEXR6U5H6qgITUt/tas+tH/+hWoM6/bKG6bCGjWPEQcKoQWpimJv8p3SV13cayGYwPhpx/7eoJeV2iDuN89FUttBEi1DZ6cAe410te3LRxDVSlBZkthZYtWAUHOixkJFchR7r1HJGqnboH1kNEYc6T+PfPYeEsVhpjnTkiUn95FDDqZ0SkkhO1SiIWn+cXhgoG6B6IlmALoLE/lwkf7Cp8JQSlAgw5DgyWbyB64jyO1ON6sWK8gkKM4CEduGIEXBeq3cc0BF80cGKPoFrvz2CtfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtDZnNkOPU4gZv4RyiQqPVH0O9lRgACIrM3p52Vkkm4=;
 b=i6qkx+0P2UumKKQDZWEqb7ZE8LI79jMRZSMuBZMbx26ICoC3HtuwmLDPuUvK+2Ra/L2i23iRqIjvJ+F53MPHzoOCClszdwFF57B0tjGPOkLVxoUb6FR4mTurQ7PcIp31B6ZE6GRYwJ77jwjJPV45Hh1Kn/hwIYDe5Gf+TcIAJE4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB4890.namprd10.prod.outlook.com
 (2603:10b6:610:c9::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Fri, 12 Jun
 2026 10:38:30 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 10:38:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: john.g.garry@oracle.com, hch@lst.de, linux-scsi@vger.kernel.org
Cc: iommu@lists.linux.dev
Subject: [PATCH RFC] scsi: core: Drop dev->dma_mask check in evaluating max_sectors
Date: Fri, 12 Jun 2026 10:38:19 +0000
Message-ID: <20260612103819.568200-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:8:44b::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB4890:EE_
X-MS-Office365-Filtering-Correlation-Id: 587c3763-4333-4af7-5b18-08dec86ebe65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6cC2EWmPdlwkP0jc+Uz1wGS/hCQNWsGotmbtwcmCQzPWCqbCman/clQ9NMx/k8ML5ouwInCIpkdQrXSD4T/mj7l27WUIwxM+f7+hXSEAq4gZlFeL/JnK46SrBN39Fi7bV+Nrm+xi2X9bNBDnXEGKCNMxeypv8MBeelucuhC7t8uI5y1qu4/aQJtcXFUTvlm/pjgzwJmqSS70vTaSqHvTJlEvNTkYqbrVjAyFS9rNJ6ZaJ4PSY6XgJLfOUkzdFcvcAG88OX9JOYglT6HC5v9/QdOOprCqZzNAWjbrP4FTvBNPYbZGkQa7GFOgOyYJI5noYYqGOxpWWyn06RcFmu//2+3haAhwL3V2gBZs0GGwZXtMk83RXz6RltiGrcSWKKrnI0nPGXWtevcUzR9t+C4BXH2tA1nxXmQLSJmZJeLpjiXR8EsKPgA8hSQSVSzF3tA1c6hyNjE1OC1XtQ5lWB6dqU97+0kxdowS8xI9ADApuC+6n74RIbTkiNtX0wesUPX8tI/puI8LM8Q/HdZaKqafjyeiiQKeO6FBoC9pEr/Xi2r11zm5qkUaV7cG45CcDlguYS1y4F3zu+2AKmKGn0iwYqW4gFxoXmePpTFXeevVizL4Y1+7TdZoj0HEjcaV58HELEnypjBRPX5w+uPDxCNHp3D3MA5CJY9fLvrH4JUPnKplFU6beRZsUPXYU2GRRZAK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zCMZuBBpSVljQASfBbFAgo6qlefOw9sLSj7c29KWwZdiP9NJeJJxP0v9eome?=
 =?us-ascii?Q?xIdjTkY7paNqhXTJAj2DdYwhqc6hqquTTbjlTjDJkCIvM5lj+RZRaDw57J4T?=
 =?us-ascii?Q?Drrur/DPrkUcdP8eoIRMFE4ACUunE/jj95ub7jjZ6cAH5/FehCtQ876LDw2x?=
 =?us-ascii?Q?vSHfoU1pzcNZ78mUI1d+5m9+5Ks1hEmkOKac7I0DfVf5RIlmo42i3lGZtUBD?=
 =?us-ascii?Q?giaFGHcVoiP3G/mjws+JvEI0ZRLuuIpVNxrClZ0mWY/PwEEkVkd/zghc/v0b?=
 =?us-ascii?Q?P5vrezbKpQgY3IQs9izTwyAGZWWbtdsHCVY0ITyoYdaXiVXuSBKxJqMG6CPL?=
 =?us-ascii?Q?jJAjaH6G1o0QzkcbVK3ptrUkRRMVjBngVnIFmMX3t16sbgs3PR17AguVd119?=
 =?us-ascii?Q?+96ZMqspDm7YXBpO8SkJ3Oib0tD6vJA5djeP/1cgDV9aVv042oOLRktP/5LX?=
 =?us-ascii?Q?ZMNPTE/HbzBYtr+muzSf7kS4iinwI4vjhfrCWUL1NaajND3luseyf+uQR+4i?=
 =?us-ascii?Q?FLk+1+vznxKWsKFXvlL9UTCxJWv8wqwJ/py/dt3KiLcBdqFZxvv9IOGhjFgA?=
 =?us-ascii?Q?IaSFsFSlN1Org9Kuf27jXDN/LVLF9VzWuUV3lV52zy0kZ/bics/g5jkqVO7H?=
 =?us-ascii?Q?eIsi6wbGl2ApqLCFAA7BwRWS6lTdPQT5Zf6kwyNp07Im/atR4udVsxnZ6Fjt?=
 =?us-ascii?Q?IeV5gIOpWAHCJ+c21FvjEbYNjbNAen6oKBl6xuYdcfPOzEh1y2NUWHZ+Hn1j?=
 =?us-ascii?Q?z/ftapmFlbNdP+1r+TVS9diAn7+vJC9aL3SwRU4areppEJI7Kb6Qa4O+qvtS?=
 =?us-ascii?Q?BxJVy/alXd+jYcuoAFCe1HoPZMeskMpHLAQPMJ5Wm82+yZOREeQxvNDpWGRK?=
 =?us-ascii?Q?GspaNkLJ/Qr5zOSlRnML2ZIiaRfnV70IOLlaMtpDxzEaLLLOtbeeDn6WmSLE?=
 =?us-ascii?Q?szto1gvTbtD49fWBl35Of4EEvbBFt9FuqBHr/rRPNBiTo+ngNbN+qn2EMQ0n?=
 =?us-ascii?Q?nYXDvug4AjuuzwX4/ooso84hAENzXqYGuZFpc8k+djKQu3jSe/kHaioEWzll?=
 =?us-ascii?Q?FfqsYa+5IQQk+W3NKFFboKyMEKjsc2kmffCWXMRvlbNdrD/1h3cD8Gr1qMbV?=
 =?us-ascii?Q?xfPsFvDJOwQO9KLpfBeIPTs+1AmFO2ej45m74QEThWYVV4qjk5wNO4wQiY2O?=
 =?us-ascii?Q?I0k9dokFtMvJdoMgi5wnSAzmqX+eXzK3eVZDfF3yddzphXuCMQlz+8COz8jP?=
 =?us-ascii?Q?AWjQcGWM118Ny+EzuKMs2qFYmPphsofYLP0g64x511tiVadEfqh1axpfnUPq?=
 =?us-ascii?Q?csE9kpOLL0D7uGH8ROTtV2QZTqwYTyF5lG9rQsWRjxhRMPcPU4V1vnNYdk8l?=
 =?us-ascii?Q?lbJfC9Il11Ea7fSdfSd4rFXfQrC2oIXx8Vzh7b8uMxFajoplaDu7jBc1p/EL?=
 =?us-ascii?Q?9/ifa5meIRHOBsXZyemKzjZi7DgC/sux1+ec3MhBHn+jrqvm2XEuxtNjHP1B?=
 =?us-ascii?Q?PSOSRkLQHHmHf6+b2u12oPUQ4SfGoNw80HG8jn3WQzY6jeV16138jd/1wbbo?=
 =?us-ascii?Q?uMW3ueKH0+n9RxzJ27Mm96a4ht5T+QW7aXe6RmIBws395nNRXuFYjVFTxAWV?=
 =?us-ascii?Q?iqksaSVhj3uVJDjdJ8ouL7R0CvXJ1ycLf38EcBOKgQKxQqumT2wvJsVBxg8+?=
 =?us-ascii?Q?CHh+yt/J75aVMKq0KcoW5RMWHXAjtKTL/DvDwWxIFQsd/zGHpbgs9ajM098+?=
 =?us-ascii?Q?Nx7doIH1JA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	OikcowmiRkEZYLESN/BwTErJMxmG8XsPr255pccV4bOqPg1AIPTGf1ERk2HxjF1pDpSb0lDIYJvDo3DCkT6re58A558Wo6si0cG8Ymt7oojsMvuxW6CCx4d2hRemnqS62683Ho63VHX8m5QH0KS3lS/N1ebV2dPDPzso5dMtXwsW7hv5rr2E3nR9eaXIBEq8RO+LCVewztrnXcOd8J2etvVxHFIHKUpUEpMTcInWesKsu9/vA30ciwmL1Dv8/24KE458gfr0ZYxyEiV/toFHC8B+VGU3bnXoChDe4ewx7PyV3RJO59UngSXmN5JQzY3kjOkb48mGv9Wv3sV8/sXdkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8in59TAq5dSKV9t0QwtARwXXkeJW+wNoBUg7lN3W4P0KuLylJWCGDJPN1hWgwYA7Op5M9QYJ6rkmdFfvPrCH7hicGFHgTuQPIDG021QxI4+FYwKHcsuNvARor+AFQU/PhxfvWOFQDaEitkrbkioRuzVJ8BoaqFmOxfbSiJcW2MSuqB/XjAootcsfN79O1TFPuz4/Vc6LwVvJG3pHzaUhzmv72ngwQocaPnUaBovBK4gbFj1VU7S5CNFDiAD1MJE5s8dZgctdj7sbV3qH/0vF0qagzfke5IbNzRXrR+cQJD9EiWMNEjBcHWqaE7iJhCfgcac/+clnaTpLQQIIAnFUyyx1ae/NwS16hMM16CcNtdSQ+vjaphcK8uuN1tDrwYlt7IJUxrwyaPFoMuaTNrgfxoMMhBxDZLL5AW/Z/zW36DcodpyrZk431hzXWDVdaT6ti3WvlGXYi3utXlfZAjSYGIQRHysc3QIkKKBApJMz/Ak60EWbcvElNJTJJ9BA/Mlwp//WQWTn+CrQ/ENKL5hPpPaArP+8gmO9A+L0pOlSRJumntXbLbanfyebld91Rb6YN8iaKDUBW/NxCE+w33n/ApH/Szk16pC7zqnHrpJsksQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587c3763-4333-4af7-5b18-08dec86ebe65
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 10:38:30.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKp0tNMbDNq5nU/V/+5EuC6zO4gIsyafjpDqDC1xOnVfHY4sZ9zpra8F+JlnUZzAlzE/7WRfjB+se3Em6ZQuRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4890
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606120096
X-Proofpoint-GUID: mFoAwaVdQZx2wZ8Nsbm4WZ4yin74uJ8S
X-Authority-Analysis: v=2.4 cv=F49nsKhN c=1 sm=1 tr=0 ts=6a2be1ad cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=VNw1f7lbhciUEahsZjoA:9
X-Proofpoint-ORIG-GUID: mFoAwaVdQZx2wZ8Nsbm4WZ4yin74uJ8S
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5NyBTYWx0ZWRfX9CcDHIpt6lPq
 vqHN/gukH/7TCpKZvn2S+vfV+Wg1dWdmoHYBuHSzfWtA2EaRFrvFrr19k6ehGtXl0/RNmlxqeng
 f0dqSAiPWhNrDun4DFi5Yh8AsvCow+y/usBi7uWZVQc93Sq8t4rM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5NyBTYWx0ZWRfX8TAMpBVT5pfY
 71xmC5w1RtT4Vi87wZ51H0swPdq/KeJqLmBzWRFaEdzfjF+o6YyXdxKUV1jUg55M43lqDbcEOxp
 k6feFGysyG9OFFSzagCM2942kdooC5XcwDXedha4bgft7VrzZN1Jmji+am3aXUdkxLtR/8y3cvV
 beJV5xd1NQTwr4Ym5cnPN1Vr8QfPBVOAe4HbbF/xCW7vkWCPcCHx21R40nr28HVSMkbxd/3ax/U
 Jo5x/fafbtIExUravVKHMjJ7ex/XOd5R3hz0q7+ECFZiPBwqFgYBA3Dx6uP7VcpqTmfkgsuOW6I
 r4WX/UHz/yqMuBmmVV41DzxbY8II27xTbG83D2PtSOwlIomak6m8XqOIvr/3RZmzXZ5O9wMfktM
 FO7tJ6rsy1DNzrSTtiX5zU+wf3RdT0ZYG2LPK37gn38BH34I0L8lQQYKl3LxGhkzC6wi2wINDRr
 urFVQZtNbzqVEWxV6cA==

When evaluating shost->max_sectors, we currently check dma_dev->dma_mask
is non-NULL, as dma_max_mapping_size(dma_dev) could previously not handle
dma_dev->dma_mask - this is no longer the case.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
I set this as RFC as I think that this change is broken, but it would be
still nice to get rid of such checks.

I don't think that dma_max_mapping_size() can always safely handle
dev->dma_mask == NULL.

For callchain dma_max_mapping_size() -> dma_map_direct() ->
dma_go_direct(, *dev->dma_mask, ), we would expect a NULL ptr deref when
evaluated *dev->dma_mask.

static bool dma_go_direct(struct device *dev, dma_addr_t mask,
		const struct dma_map_ops *ops)
{
	if (use_dma_iommu(dev))
		return false;

	if (likely(!ops))
		return true;

#ifdef CONFIG_DMA_OPS_BYPASS
	if (dev->dma_ops_bypass)
		return min_not_zero(mask, dev->bus_dma_limit) >=
			    dma_direct_get_required_mask(dev);
#endif

And I did see a crash for scsi_debug (which has dev->dma_mask == NULL) on
ppc64. This is because ppc64 selects CONFIG_DMA_OPS_BYPASS and in this
case *dev->dma_mask is evaluated.

Suggestions welcome on a proper change.

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf8..d22526d8a77e0 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -252,10 +252,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	shost->dma_dev = dma_dev;
 
-	if (dma_dev->dma_mask) {
-		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	shost->max_sectors = min_t(unsigned int, shost->max_sectors,
+			dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
 
 	error = scsi_mq_setup_tags(shost);
 	if (error)
-- 
2.43.7

