Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EF413D539
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 03:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739416069; cv=fail; b=PuJFmaeAp+VYGPPRH7qFkzGI2H+f940pI6eKEnHucLkGUMWLgXR4djW28Kc6ynDWRt6cKEMM3wSmn9QGBZarqpz8mx8uAKqxYI3FHjSPu7nKnvPESPQxW70ss5GN3yuch8p/QvfFYwizbvXjk9TG8Tch869EMhk8mJoQfNTOXbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739416069; c=relaxed/simple;
	bh=SCarSqAoiZ4O02fb5PZJLWRdSv1S7xb4irRbGkQ2emE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NNNdmkzbXJ7uKMQx/LroqhXKVvce1q4LxL8/MsJWieOMYcY9aPcvmC3uYmqTdkiWXricdH97O8EseqjY41iDttpBiN6+2D2/Sx6hxNjUWJkb5vlmDM+4Mqh7JV3ZqTeuu4RQAaoEvYdFbCojitom1o7xgMe89wTlz/wfRjQgvnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jUkFz8Iy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tBWAAWsI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jUkFz8Iy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tBWAAWsI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1qBlS013411;
	Thu, 13 Feb 2025 03:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=gliwN3wcqNAjGAGLcF
	9skkxF0ZlDk80PD82esdNVM5U=; b=jUkFz8IyjtGhpRaQR7GTwt7Ajr7u6chBlN
	xC6RtcWCI2snPQVWoq2/bpVpdhWVB5Mk1joC+DwQUEGKFFTmWODxQZxzTAKFZyUz
	f9QL+b4RJ7x3w4V5UCUThqn4yTqLXsADOg5NSBNd19XUyzwb1gGU8M7v4DW0u8VU
	4QYdTZUGQC0fOaQWVVi6ceVHBjC+KDzaBf7DK/y2i2PxgKiCXh3eSlt47jwcQq6+
	6mvPanQ2lU3OkP+Us0jxYszoB4oAQ+4KBo+LPPV+CMnItoyAHf7lA99bFJXMPsAc
	lZTZ04SOyntWjn5T6DeHyusBBzdJIqbenZQfp8oW8K0zA2VqEirQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0s40rkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:07:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1i1fT030523;
	Thu, 13 Feb 2025 03:07:36 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44p631jm8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:07:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVekPcCXgMb4qkuoJc1ZyVdWZ3YlNhQ62hfT4Jqs/ZW/IXpBx1e/56kyChHF3797xiSYVgVy3xRHh4UkQXAAFl1JPuWGz67fA8xQIt9vOy/uf5mB45bhf6K1fL/mNqS9Rq0R8GQTJePvmMe7Mtt8ldp5lCo/d6QX14X0HOet7hU49ry5yWVcDC4jALTgp3XlhZR0oPw9s5WMGPDNXkVxVk8LQWbUyrDItb75xHVffe7jjMIA7/Igqzcs8+dj8NPDPIS/g3GHcb4UONI79UayhCPDluhioqyUfR0dDyOWzHDdL08XxMt8gvbyc0uBRTLDO5q7kgpztVNZABcofyQLIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gliwN3wcqNAjGAGLcF9skkxF0ZlDk80PD82esdNVM5U=;
 b=UqB28u3Xcd5ar+2qWyk1mcIT/kEIdciPRNlqiAzdRtD+wcjXsS21BdUxgZsvQLJmrDCeGLejQZ3YUJKn5s7y4vpo43mZ26yNJwa45pOpsc1MRAQalYjyMl74EZy37kc0vArmyZ7xSZnWlfHQo35h5hQWoKQwwKjvGcxiNEdkSpNnyc9I5axSK7lW0PklAeWRgqu03+uJnfXH6I1FIQO4mra8leqhiH1kMHWorDScOypAvP4gWb8mHjivuBWAOqmrPwscyVLUK+PfFIOlitkvwHx+KSu6usRjSHSoqCgXLSf6EVY/XuR9mc1TTVXpjkIlw3wzFFKNHLT1WYlt43tmlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gliwN3wcqNAjGAGLcF9skkxF0ZlDk80PD82esdNVM5U=;
 b=tBWAAWsI9k8TSHAmWnKs9VqGBe7WyM0lCIXfz0cCPwyWEEk7UHJcUEuQfOh9k44Utp2YESmMlD7Kl1OqZN8To3eODG829wwA2J3mBPZa3TrGS76aAYqgsWmfMR26qPl0aPiuwuP/j/HxGEyfN0S2Jzfs9C4EVQ+US3ScPQJ5xWQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4940.namprd10.prod.outlook.com (2603:10b6:610:c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 03:07:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:07:34 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Duncan
 <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Subject: Re: [PATCH] scsi: iscsi_tcp: switch to using the crc32c library
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250207041724.70733-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Thu, 6 Feb 2025 20:17:24 -0800")
Organization: Oracle Corporation
Message-ID: <yq1pljmv8yg.fsf@ca-mkp.ca.oracle.com>
References: <20250207041724.70733-1-ebiggers@kernel.org>
Date: Wed, 12 Feb 2025 22:07:30 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0287.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4940:EE_
X-MS-Office365-Filtering-Correlation-Id: ca2e23f5-167a-411e-871b-08dd4bdb8fde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/8o6bCIn+eFo0sQXndAGdFYey8jkIsIyqtvVZM+7GR5S7cCKogWgSqjY+rfU?=
 =?us-ascii?Q?qd2PF+EVsCUZZbRw2QSV2gaCHTC4Nk0i/0sC+Mnip4Wx9BpO/KY1TfhlPaEV?=
 =?us-ascii?Q?6CwmdapVmrT445acthvLW9NcV1jCkNB75Z6D8/OGA7Agq9RRug4DLsT0urFo?=
 =?us-ascii?Q?hwDsdtQRPn6N/W0NvaucROAScpGpX15ywSO47+WNvcyBYlreFox9asb/RreV?=
 =?us-ascii?Q?O9HXWR88fudcmbxzi8kpjYjwejPsBoBYuJFsvrxRliap573VmFMPOdtQKkPK?=
 =?us-ascii?Q?XtJcmLDhCDJRuuFjT/d9/eVtTBF+f+abMTVOcULLlOzO3kKhLDdAfxshiS4/?=
 =?us-ascii?Q?9fgMaux7g4kx1shQ6BFrmFGWlcFMrVIxWPB79mareDvcLLnKwunTjGC/HqWQ?=
 =?us-ascii?Q?QGk28UcD/5sVqts2sCa59G5LkcfDTK1P9bDyHezY1enEwKE8h+euCPb8NbBp?=
 =?us-ascii?Q?gb1607WNd1E8tG/c1BbQ+SBr42TshkDXts+x3U1ApZ+Y62M6X4uqoQZ3pPvx?=
 =?us-ascii?Q?y+rFWakvB6Vekp9YQXGJCx2LuPqoWWAXN9qonDru2j10cx1kVyHY1iuXwhZI?=
 =?us-ascii?Q?2BT79s1IuYru5BnCKm5UzFCiPyT/ZPGaST/djkJbhTMH2jiMIGUvHdG0Nh1n?=
 =?us-ascii?Q?bQhX3pCX4JzEyoRh/sU+PmnhJIYhzoiDYvLoSQNz7fxITUpqUYzs+/i3vgFZ?=
 =?us-ascii?Q?xL3A28sSbGjNCu15MgCHCMaE37vDLNuJ7dMTfTG+6A4yjU7rFB35SfDXXaPL?=
 =?us-ascii?Q?bzOdz1tJnC6BlWaKzZ8y4F/kgHIqpk8FjHuMWTkCDShjHtSIYgXIfMXVeQZk?=
 =?us-ascii?Q?8kHgbc1ViARvP5CoGrpBe0qUtb4PNToOu+GNlgmrtVU1/43vf3BwA5UZhtA5?=
 =?us-ascii?Q?65b0KwfBFpA3XgAoPRoVPU7U7rl7kwsJ6xhdnj+ObKsetVm40kUXip825jsu?=
 =?us-ascii?Q?1aw9iMm/Wmpbgsyu+Q15/Qbc6/uAAqkfR+Wfl4S031bhGcc5obHzTuMMr0cX?=
 =?us-ascii?Q?QO0fPQzbMjlnc6vV9arA23KHwkYg/0cP5CmQZLq4XKVIy4oo0q0pgq60Rp37?=
 =?us-ascii?Q?4u1a3YJ/CD1RYY0SSIZJlm+7CrhJo69sMnEPeVNYaGxXXpUpSFko3exninql?=
 =?us-ascii?Q?uDCH0HxcXh0SLqH11Mmp+3vbmbRwG999TTBo/2B3nesOZ1+tOgD135cZPFmL?=
 =?us-ascii?Q?qUIDe4Asvg/FLZ1TsYjs4QispuZ6ArJed0VVwba8DAl2ihYQkctbW+bfkhYw?=
 =?us-ascii?Q?asNloJ2/o9A7xGT5kW/vpt2mKvtgj0GWBY+yxZJ5+iKg3M1xL7u3P5v/7mXJ?=
 =?us-ascii?Q?t9vbRjDcaWIx2PjjXk6ScYJU3jH1aXmlib+XT5xXJjDm3O6BJddoQtksgqu1?=
 =?us-ascii?Q?FYHQWwL6wIyF2hhKa9rr73+hdirn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qsFBRW98Y/34kV4S5g//HdJPWjGTer/Gx9Xu/MiJUKwRk9dV+ho5XM13nz2m?=
 =?us-ascii?Q?v3+t0m7/nlzoWhAzDklFOBoruL4atGRcedhZCgU8RzUgZDlBUlXjINte5f7N?=
 =?us-ascii?Q?JXQ8EOOAENT+SE3FYIfq+cI00mwxyO2wlOAAXUd5Ae7Amnsz623HhksyC3LA?=
 =?us-ascii?Q?Q15ycU1n+qlwSd8ISTD6UCr4hw8B1Qn1J+BzRMQbhKX7FEZAl5EuMtQ9pt5N?=
 =?us-ascii?Q?7OyeNkt3YLHjFs0xxeQcr79PdcBLobfrsFnwqA7kiM0bJTVGqgVa1ca9wnMz?=
 =?us-ascii?Q?zhc+f6UYFwdL089DJP79GnUUyd/dlZWq6XByyKsHQPvu/eVTfAIh4CdoYjWJ?=
 =?us-ascii?Q?KqNKN2N0sTr0Ut8mJvo1kWJ/YSCBrdNWKw3LR3BioK6dzvCJlR/v58tCvu9+?=
 =?us-ascii?Q?BV6XQKi4QTiDgPPU8GTIKW5USKg6pwy9XbJEA/23s3gIPOhd7rr2f+KoBOae?=
 =?us-ascii?Q?T7oZMuEVQYiwDd0b36bEUCNENc34W/EyVO+sOzQT7m7BtuolBaIRZWU2Z4cR?=
 =?us-ascii?Q?e5ecFDspHtliFthh6A5qsiuB/qOztEIju0IvWILOn4RDoqiEHqSgtAU/FDk6?=
 =?us-ascii?Q?RVoU5Snu2OZb4hnd8dR/YWwSQOF1b8TRpPJWsQGVoMB05gFkxw4NpL6TG/Av?=
 =?us-ascii?Q?0FV2WVpJn7/bt2LeBdXQAXDkyhlCXi23BaYXY6FMwPKL/Ug5stdGcPW8yErb?=
 =?us-ascii?Q?/DB2LBYvtewa2ssqJMvyIHl04/VCdSHDpdX9ICa1PDp17W//iT/ySJfY4uEM?=
 =?us-ascii?Q?DWDvoLjXxtoTwARD21hjP3Cj5qRBqFUYYPvXeih8BjXgOsQvnx/BVo9YIvQY?=
 =?us-ascii?Q?LGR9ULawco/XGyKjIaftH3RJznpKbCQp0Xxf0eqAzu++L5/PMNcy56N/KSIE?=
 =?us-ascii?Q?nugL7vg8kSF5fD1PMfdlfb/oycu3SrZuC02hrdezHRiJPvfeGO9IVoKDWLPc?=
 =?us-ascii?Q?HZhJ4h6O6SUMw3UZmRAb06SJZ4MoyW3uRc61wdKqBUHzzNkaB+tmFgPAlc2P?=
 =?us-ascii?Q?Ct4zN5WN4jzWw7aBGenJ2700QcZmduiNCK6hZPWvhI8w9EJoJ7XrTZCKZGnV?=
 =?us-ascii?Q?WMym1mT8WqEhX3zc/5jRDhShRfZ6Ne2kgi+zS8skCjWMiCtPZkgk3hAVLdD6?=
 =?us-ascii?Q?Rve6qsb7Upe8KVTCTAyQuqEXqu1n4WeXRH7wauSdxVsAJRt4dUEkwP3jOjdX?=
 =?us-ascii?Q?eP1KLXuBHS8K7GvHM3g7zz8fyMX6uKZlB66W41gqKFbfXLUnslcdlgVredx3?=
 =?us-ascii?Q?Ob4mxXl9EPHeeZ4miu+tdBjIMhhbTH/rbW8jJrFBMgs8zF0e+S9Jb+kk8J0K?=
 =?us-ascii?Q?/5LbaCvVuoVT2u2avbdYP2s+Es3WH4c6yAro4c6Vric5Nbw71/rfduKftdmq?=
 =?us-ascii?Q?tUzGKUcGGdhMzxHgWLXDIgCMpeH5bEaguY35LRrsmGAbswNGuoEBWRE28R4z?=
 =?us-ascii?Q?phv6GMh7MgBvWShjcqAlWgVSor+fKB4A5x9pi8FEVpuDYqK+YDSp8dI4LIbb?=
 =?us-ascii?Q?uZutbvyzL7FLjqUicD1y0pQCZ/RasLPviizTsB+YsiCG2GFkz4iI+gyWb0FC?=
 =?us-ascii?Q?FLlULRdNRDL6xdajoEaMAuoGm2E+E31Dckw7SSrnUdPcFqw764cXFu81SoPu?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MOpE8Z/KXDeww9+dGjWPlTRpwXc3EHJ8x/yeCIvRBtleZ8dZzpB38JJ+0TsLEL+EllxTazb8ilYloXbWJGg/KG6A9ArB6yODap+eIxbd5Xqg9Z89yUhZBXtHXAk9dPKBQneZf8C6luTLzYsrisercjJ8yhC+5bJAEESRz5maWCWLUEZGd6lPHvrvNnxlsYim27MVZp2egFCkl7QeTUz5SZ83+eBAXG9U7JAsO2k9qBEEHMp5wnrPfzavXwhX/q7/ztogEcKVOjHqHuj+kLyPgAM4cMLj8mxmaUbTrpUdUd3Tc/KNe1AM3kBeAIVkGU2JrOvlOqdHNx3jMJrHtFi6okke5VU5G+HD5A6UiXBJXPcbouI7LkjELFurBLHVbuCV5jvXLzFoPmg4yISlRJc59d0tyZslXQBgQT63SOxbnvWKLRIuCH0wR1aJgrJmedp9sTGQl+/0Mcu6E+kxcUxIaf6r97Zt1cgiANkCozR18AliOL5L/XfkJEapnn/Xj130IovTuZWnoT7HDYll4MVbRG9dpDTF/uNRurAiLO3UtvT5nlsPeB+fldPgv6A7+YMOPCifUYn4IWEsP7jEhuh89Fyjq8KiyEFkjr5q4x3fs7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2e23f5-167a-411e-871b-08dd4bdb8fde
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:07:34.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqM4X78dFeX39kA6RVCDLVZ9lGYxR6B7o6vGQdXJwbmmKyFdKFyDbHhbW++dphVn3IJiLHbaRhno0Y7TWIrU0U1/e/lOlRC3QimVI8b9jPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=757 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130022
X-Proofpoint-GUID: gnqvdKN6-hQH6LZ9GuqcPv1PAYkTavoB
X-Proofpoint-ORIG-GUID: gnqvdKN6-hQH6LZ9GuqcPv1PAYkTavoB


Eric,

> Now that the crc32c() library function directly takes advantage of
> architecture-specific optimizations, it is unnecessary to go through
> the crypto API. Just use crc32c(). This is much simpler, and it
> improves performance due to eliminating the crypto API overhead.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
