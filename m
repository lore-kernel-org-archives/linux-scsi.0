Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F229AD2C;
	Sun,  3 Nov 2024 00:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730593657; cv=fail; b=SWKPLGdE+quOTSurHbLC1tFgvd2F45c/CAPlvcucxdbS28RMTx90JUWgc0nZz8GVKHKRHbaWiXw9NEY8UjOHhKHeZfvLwta+Ys5MdwYKpDN/Bm/FMvWZyJVkALYezYkJ+ds1I7CI6ByqV8FGEP7E+Es5Ef59jJEfmcs8HWLk7zM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730593657; c=relaxed/simple;
	bh=WPjIALUvG/zh6kokQ/HNaoklJw6TXl9BlhzrFcEkA8A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UWH3YChwCSznKSfJ0W3zUwO31lnv33BrW1ECpNSUNG2qUysJoC3MOQof53YDYnO4BOwYq/oZIbnruRmXseb4zJWVQaPTTWT6Yu5XtwEiK9lJNzu7PrmmrjJXETUwWGGPgGViR2HVuB1m6pYGpmotllvYftTRYc0fe9WWCwrFiyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cQBWi94A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I+oYYnda; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cQBWi94A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I+oYYnda"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A30AGdF020591;
	Sun, 3 Nov 2024 00:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=584hsPkFw0BnRdFLU6
	zrRGU3hu6yQZUr4uMAGXYZWOQ=; b=cQBWi94A3IYJzZE/9TUia5AuNn9oc09KQ2
	nsHFP1rLk96YTlmNKN4bIToXQWWvQN95cTCHSq4buIPNd4M4c/8IwhVpAkrI4Zqg
	3cmM+eiAMV0q2VGpoclrk8/o2mEcuRZDJ7j9knipMr3kwdvaHrrAKTPLldbN87/Q
	m+23RW4uzwuGleyLsykTChMsqJ9gTC2mXz7Q82fBs4GfpAH86PBryWhLR+vjZo4k
	axXoPpRLjJnWXrbiHC3ebWGJegDKenmCxDCUTEEuR2mwif9s43eZVVr9HIZ+6mnC
	xdm+rDQ3aaUNpCsmx0zvg5Ds+d3Mm2Q6AuTCR6KbYdPG/ZzZgp1A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nanyrqb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:27:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2IMMK2031455;
	Sun, 3 Nov 2024 00:27:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah49gas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:27:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nla20+n+syvlHdpfLqhPYCIbNcHtbi7lc/j0BtW2FH6gB/O3V5ezrSOTHwJ8tyhrxg69h9tFMN9m6hxv/hn6pKc3dYPe6/cV7qAUgZQpCmHkDeNhbPNMAqYmNoAMOSlxtonG3f3Iek/Dyb0yvFnFaRBw6nDCi1OEX1KBhHehvAdVmNJ1hiAnab7noHYzosw+iU8nZ79IMTt3DpiTVxq6/6cW3G0a8Vb1lrDsLeVsDJMa6FWiJQ/zf2i1n5Mj6fDpmrDNRgLx4xkPJ6AfddCAfjVZ2aAGp/AvMVnnY37KlWY0mFM5CQsrRvT70wfpKurz402qIi6V0iEY8JsGU1zx3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=584hsPkFw0BnRdFLU6zrRGU3hu6yQZUr4uMAGXYZWOQ=;
 b=OLgtFGSHURZG192JV4WQ2tctcZse4NtzmyK+MZKLEvV9zY0sqBIPCcguYkaV8nIum4O2QLeP8MUACw6Gc10dgLCG6QZxsG8X2SeuSNM5fwEZb9u2CkgqEXzavclx9XW5dTgiMJYjs5QEl7stXOgGS9mFWsUgnounh6k1P58dOSacX7xq49sxTh+MB0KceMRRcOPzHrzBpJZLNjj2SroRCaTlX5wcscuNwpY5YLXttoirulu6L2Owd4qn44170sBkV0S3QQmz+CQLhIfwy0LA3fqh0uXpJhEzpl19FTDA7n4XOtaOXH9MXbpiqZgORSWuPAnk+80fBkRkgONWfVYkTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=584hsPkFw0BnRdFLU6zrRGU3hu6yQZUr4uMAGXYZWOQ=;
 b=I+oYYndamXsgw5nDVlrp0N3uWHffSeAp7uDdla2BFeSQqq3B+YMLOmU2F8EPvW7QrFRrcMN7e2cAwF7f63Rb41tOEW+XEnwijrxXl/5hsFoZbTjYJa/xH77IjkN2x2Ck0iHtND4eV2T5BlJ34BguQMP1gqHBQSuOF8eIglsbVbI=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 00:27:10 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:27:10 +0000
To: Philipp Stanner <pstanner@redhat.com>
Cc: Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Minwoo Im <minwoo.im@samsung.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Replace deprecated PCI functions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241028102428.23118-2-pstanner@redhat.com> (Philipp Stanner's
	message of "Mon, 28 Oct 2024 11:24:29 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ed3t88mr.fsf@ca-mkp.ca.oracle.com>
References: <20241028102428.23118-2-pstanner@redhat.com>
Date: Sat, 02 Nov 2024 20:27:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:335::18) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ0PR10MB4797:EE_
X-MS-Office365-Filtering-Correlation-Id: 718e0495-9671-48ed-578d-08dcfb9e41d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nn7g9rejzkTBHn/EbyWvszssGCkvqOD37k0I5jLY2Nu41aIon3719ZnyTv43?=
 =?us-ascii?Q?U2KH2iyB+LveHVcc3+DuUXwKms1BkH0J4pj+Id1VsnHu/20k147VGY9TAFv/?=
 =?us-ascii?Q?87t2TZq+C9au3Mi+MWjKq5m08qNplU1aCSQwmZ/f7h/JpZ/PtRsTTJ8rryBy?=
 =?us-ascii?Q?MLX/ncFPhV7Lrw4qmm2urEasmueMmUX/BhLkjWSpGy+wd+jE0yBVT03UTx3H?=
 =?us-ascii?Q?ZDR/7O+jZGaXRDWQVQaAY18S6jfqAqi1anvRwsPEUu/w6iwzdEanuGpfR8lP?=
 =?us-ascii?Q?LEkcV/k1FggypJYjv5+bo/XwVIxWlLqrUfTPBtzOGCupNS8aM4ExGZ/uSsZk?=
 =?us-ascii?Q?TzG2uNiTxt28XbhEHqyjPie+FDKHeIswppA5EmdY2lK1GuVrpAfluGAGbHIa?=
 =?us-ascii?Q?BPGkQFbjJ5CK3HgSSNzolPf+++G9w/x7gqUbfylblP1X9MjApvtD30h5QjY+?=
 =?us-ascii?Q?aQXoNWA/oZqmTb2XLC+qcb1IM9RJCTqNxKClbJoUr5UmJ47QX/pgWnUrnR7e?=
 =?us-ascii?Q?UwcoTgWBQd/voPpHFIQLvT7qaVtiCdFT2nC/F8B/iux+JCKxBcvXxLJRWBHw?=
 =?us-ascii?Q?WxoVAjBhIUtMomfj81W5lA0Yuziqp3IQW6anBGB95GZ4/JG2815fp281x6+F?=
 =?us-ascii?Q?1Hvu/vXzDn9cqf3OaGJvVVHwZvwFtNkSLehS363Sns5nSGnRXNXBvny8rnHJ?=
 =?us-ascii?Q?gSlv6ntCx8gPUOf/emjXzuMPd2IZFKSouozAfqlj4PDAnycMnfKA2nqGU+tq?=
 =?us-ascii?Q?zVKNOwPV0WR5CAAuF9W8KbWRZuMykghOgQmHd37T+fbFD7OKhqtTH4tpR9vo?=
 =?us-ascii?Q?aKvhtDgJzFzLqwTNqRpgOEeU4Qq50Ts8D5/rb6URWeODlERg3Xd7LZK8Ykwf?=
 =?us-ascii?Q?EEpO91jEyGcE06+gphJoSOkDT9f5eWFxISS33n/W7Cpx3RHUIiMBHsdOEXXC?=
 =?us-ascii?Q?c1Ai8OaLZ2kjXcN7ELvuTh+KxOqUEeaJUcCkyMHP7SNtc7b9K5AoNYkOCyi3?=
 =?us-ascii?Q?eMA5tYb1SdNSrR85NpQTOujTaSHYLDtLDiPV/XQyKmvytGfrGRMlNZdnYDOQ?=
 =?us-ascii?Q?7lvBVP3gezvPt+zbCQiiBBTXQX8Biw+IK9KG1mKHGM9/Kw0V+XgkUvaDbIlC?=
 =?us-ascii?Q?bojaB+r3tQ7Y4PQLNScxov4Bb2f2SX07pH/di7X5p/Gb27xUNhJSPfc9ak9E?=
 =?us-ascii?Q?ey2Cqwb/60Eg5p5RAvp8pT0OgHNvFIInbaQWNqOrT+Exo+hrqFn6ijeRxH6l?=
 =?us-ascii?Q?01uZgHtaJapqpgYU/XHxx4IG+EnzqQp/IVZwliRZTJLo/n9JXzgc6EnfKVUm?=
 =?us-ascii?Q?6/G8mRBAY+jXsbqhKV3BTpbf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Remjh1qR9qPGRFmcie+SiQCtV/DYDn3Y/8g/CAX+bFnRUfXHSp4ba9eXeCRv?=
 =?us-ascii?Q?fExFCv10xS8ttPFTxwgmBTIqvbnSe2VxlRfz0d/akUIF/jGgyeFLjbNGKnhL?=
 =?us-ascii?Q?tZlUtT4jh8wfX1cnr4vD4Tyb4ei6/lyx6W0lWxNubQNbzTrXttr3ovqhTIzS?=
 =?us-ascii?Q?mGQpsTa9xoQ5F+t7fdm17/37seZJgDfWg4M/U91QbJ6bsxICv+vNMuws0E2s?=
 =?us-ascii?Q?5x9Bd6qZKtCS8XOyjwesGCUaSX6Cn8wYnxo8DAa0HHJTPUHyef6DVoEu4/n1?=
 =?us-ascii?Q?u+HJXaFxC4Rd4l2EPIYgfU7wkS/Spj6lK5FvhzRcqZxDW5BRFx01wsXYPwa9?=
 =?us-ascii?Q?mMp5gwAGspTiObOW5Zj2WMwQoS8L4ZkTyv6iRPFCuAZJXOl+xN3RcPVhVxNI?=
 =?us-ascii?Q?0qsif22T/02pe9Zs0yZ3yG/ZDxhOmQI9BmIu44k2S4An0atY2adI5+kRRreA?=
 =?us-ascii?Q?PQYT9xeHoLl8ck5h4wLujrVfSeRzkxf82xCsvAGF+qFlgbgGtDNUEkZlKs43?=
 =?us-ascii?Q?EijbLSbjrNm2/x0yTAlkMrC/01ckw/Is31jThq/Fjy+FvbJK7UH/utopwQPy?=
 =?us-ascii?Q?YiRRfv/zWCCmN8dOQHr7PQfWh8qtyAXV8f0fwU9MY7RCA04bl9+EZIH1J4UK?=
 =?us-ascii?Q?wdWVaxkxBfeXSYCy4Qi209Gwsd8W9YACAGOptjEtWReBk0WPP8vN4iymTfjv?=
 =?us-ascii?Q?AdVbrOhLofJlor/yFXAJRI8YQRlBW5znTo/k7XIF2Za9FO1h4sb6Llzm11P9?=
 =?us-ascii?Q?61Q7Yxknhl9JRnfE4LDxbU/sAWUW/D//TlighMeaBha9IqVSzM3bSxoPMMj4?=
 =?us-ascii?Q?uvGQ3Worw9J2xIU0VykE08RwRkxfLxzqZ5pL5VXRvVrgS5iQgsNTsnJgbUC9?=
 =?us-ascii?Q?5GXBcE/vA1o76PMmzCcgYw/xzMFn3w1mAMZxouxzhHZ7qFCSVn92UjcQe2GW?=
 =?us-ascii?Q?U4afV8zgLdPOkG51KtrUQDmgiNx9HSTKzHI46rxh5c24yZrLGpIGBXIJ4Hfx?=
 =?us-ascii?Q?GEmmxV0RyH+18wUVGFfciE4MS7Wom9pQ0nzsZXZVtwRuPD7SvDbHI9UvkaVy?=
 =?us-ascii?Q?PXogpn0qzlIErYwfwnEAqO2nsNv7to2y9/fZUzpXRZ2R3NvcAnNNKkdUnlbF?=
 =?us-ascii?Q?Dh7CMpJ2XJBlnv2INJNhFwtQp2nWbntezpPg2AuoZks4u/DKPp4VW3KUgP/G?=
 =?us-ascii?Q?bjQTK5b7jHEJDYIrYjrRNhjgxM+ALu8v1eZYMK5aynyVBk37dJbjbPWHyevM?=
 =?us-ascii?Q?NqzPxmYmpiA/o00EWU58Y4JDFHpWr9c2A//0L8VupyVFbOgB455uVU9zxyEG?=
 =?us-ascii?Q?TpIJ2bAWmKpAmcx4EuSAHrvhGW1ftG8S+Sm79hyNWvIW0r63grWsM6L8/3Fp?=
 =?us-ascii?Q?rBHldWfvm+d4GCg0WJn97SZMH1fTf9JzYZm9pDpiJgg1tx2srkL0KAxjcqUC?=
 =?us-ascii?Q?KKGZmw59IAymETNv+ie3CWO7KIgvjn0irEl7lWsyyGSZm8Z+I7mPiPWDeJay?=
 =?us-ascii?Q?g4lXn4HSpo7GkbWjUy0EuPlV17PmntiTLH9mfWPkDOz2880IvLtN+5eW4UvH?=
 =?us-ascii?Q?/4DnZJf7yDcbBTqwuuhFt8QSKfI+DKBS22562ZanUjHs/j6lJ4XsNR33USsB?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6YOdjHgxZP1bAb8s3RmmKyaKkFvcI9orRFl+fBOllE/Q54R0E1KiNIXx5AlQ0/mKQH6HEVBw3hzETKFj5FHKAuc4w1JwKR84E7VXoh0CjOcrqLcfktFah/C5ORDyWtGlKZtH1LkQWu0hjaTfZkVbX25+BkIu6Nh602xBKa2qz/ehLLNLbpvFCOSz+uSPKH/NxGDBK0USmKhPicAUlyDNqa6l/G3Ac9Oe/pdL8p+57vkIcQOUM4kohQyarRicYViCfGu0ZPXwzt1qs3VaB4Ngw5E3XN9me/h+We4JcZXZIDNpS85nCFPLkBfbPyaMIGJXDkWisPurj1FYk15mBGflZ/3D893uCU98RhBrWdKZhDlg8/FOPoZxmK1ss/u4py4rlZ1tDSteKO+nb445SB3fWL4Zuwl+SiXlFJespKG5u2ydKU9blJNPbWaMPOcCvdFG4FFyqLP8Wk4QlNvIIa5p1TXLab+iq7vxVw4djUkEWmjwN3Drzf/ijKtTa23N2Y/fSTJ/8hZda5Ta2VMx67xmcMHiYlZb5wj46ZBq3COOMKOP5AtnUbJaoY1V2cEnkcCFTphMp1HXr9MOdMshL4rDaA13Vm83bgPAgPsUr2yCAr4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718e0495-9671-48ed-578d-08dcfb9e41d0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:27:10.8098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fj3FgoyJHtOrJWad9U91SZs83MeEgM0WIjueaPazLsXqhKmMMo9mCGY1GGH1FYmiWWLcX3Li6F8jR/il5Prd7lOA7FqjXC+zGiYyVxZvV84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_23,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=753 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411030001
X-Proofpoint-ORIG-GUID: _qXadW2OPQ5qWWFr53USceXIimTChNjx
X-Proofpoint-GUID: _qXadW2OPQ5qWWFr53USceXIimTChNjx


Philipp,

> pcim_iomap_regions() and pcim_iomap_table() have been deprecated in
> commit e354bb84a4c1 ("PCI: Deprecate pcim_iomap_table(),
> pcim_iomap_regions_request_all()").
>
> Replace these functions with pcim_iomap_region().

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
