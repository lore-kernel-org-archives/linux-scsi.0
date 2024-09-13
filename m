Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F65DA59
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 00:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726186761; cv=fail; b=hzhOsiNSTXPWJYxo+hdJa2mOYgFYkc0lfMX1OTlT7wBMAFkEoW44rwm4gg23k7pvTvcJeNPIwwg7VwwI0yB7T11kgcCi8MtNlefCJywCdG+l0DtHx8QkRfK+KaNhxV9HBGD72UYLikVgj56YaPM5HRGdd7Jp2DCNAi9i9d54htU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726186761; c=relaxed/simple;
	bh=GBGf9Q7+ZDgbQkW1i8e3stSaLFzgiz3Aife1wD2n+iQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iaEvGE43TCFkdJraaRT/Mtv4f1+t7bMsGUWp6uqQpC2oqtYp4CJ48858FzphlICeYL/HGfbKjUE6FwiFFwAvzK82+/SmgAbZHE2VPCaYm6c8HkQcUB1Bu8PZut7x8++rOa3MLM0n9ja6UPqBHhYxZaC8ETFFWuDBMtFDW5404HE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PsXkNIZ8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ff0Qc4hC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PsXkNIZ8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ff0Qc4hC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBnve007456;
	Fri, 13 Sep 2024 00:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Rjc/hGYL86xicH
	TxkRfMbd+WzX1NB7aWH6TrlALx0y4=; b=PsXkNIZ8wF9RazHYSBgLWPk6vBxhmv
	8aHb3g5etYMR4BZx8ccNpxt/bhQlwabVtnMegD6F3HEMykRF5E1vu1vegI5z2x82
	YTVP+C4BXHL1l5cIicXOQtJ/HgRzdf/AzKAGYT+YVnWS/8w4dxNrX+ZQlz386Vde
	TSXmjYARulWpngbWq6/qhvxNHbtuuurqXzETBkV5gxvInq4Sx8YeIwV0fYTDPaq4
	fhasAFYVVB7R0h1JLaepDV7hX8hQwg9ZMdwW79qCwr3ClpvOV5d31Fh9MGkFx6a0
	Gj/maLAnIQoRKAXZ18ilVUROPVHk8bndNY6GjnzVUku7WiFI9hhze0BA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9v3ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:19:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CNXqCa034204;
	Fri, 13 Sep 2024 00:19:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9cf9m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:19:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o5psERDq5PDsoxXKqRBFS96Ybko0P+9erO4ahc4u8qQ4N/L5IXsTEvsDBvz29ZHJiXi3z3jwj2084Jm6J8xN2q8iKL4Y2qHCsWel2/IhNI3lKJYYQzn0QHJpyP4PKLpn4lZWs1k5/kJIq7dbK/mQpljytihkhbzhsoyvN5GZ4aK7JRaAn6U2pKkSQq/BgrlIsgLFCcRe3ozTPtxXBUc18Zo7oDVJmRxaF8LEPHR1WT+cnwWHwDeLBL+vASSJDnbCAcZvz29hw3gIizbefT14lHI1t9q4AGsJBksRCbQjwzQSYtwfYK9GsjBnBhMmsXVabAZ7I+UfUtb5wqQqQQpFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rjc/hGYL86xicHTxkRfMbd+WzX1NB7aWH6TrlALx0y4=;
 b=PMg7DB2lGELWS/xZOWelKiOs7je9M12Tc1c/7DkAmi8j2qAVK8gYfKoC5W7o6stUX1atWXzVeIhUJu6myPGHem+qXxEFE3lJvN1efWKbeXh8pmSjqbSTYbG5xPcptcXCLUdNGOtybBtxnQEbsC2j8H2E1uKIeaudvdmboL515kwXascdFYbNjyt9Y7+U8DJptP2BNn/2sG4tx1FusSdI5+G7qRrbZssryJHORs7DxkgmvCjtOrUsjcoKgSgwpD78SqaQ/bsjaWB0bE+Xo09hkEfRestf707HiXFNS+iFcbwGbWvct0APO/4XbadT7lW3bYeRNIYWjIQWKITtC2MXCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjc/hGYL86xicHTxkRfMbd+WzX1NB7aWH6TrlALx0y4=;
 b=Ff0Qc4hCXfvREHEf9oCDTDxXYbzH//MTBbjJqfIr7UzCADnXkB6unD9RvTtl/IjkdLdTGdYNEqh+0hHQRo5ZIluwVnkSKXM1GSuSUsoANPFFFQuWoPix0mxwz4EeBRtdVvReqYuxQy+1kuSts8yjU5yWLOchVSszjd2IPBCet/U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:19:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:19:11 +0000
To: Hongbo Li <lihongbo22@huawei.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: sd: Remove duplicate included header file
 linux/bio-integrity.h
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240830075858.3541907-1-lihongbo22@huawei.com> (Hongbo Li's
	message of "Fri, 30 Aug 2024 15:58:58 +0800")
Organization: Oracle Corporation
Message-ID: <yq11q1o1k3s.fsf@ca-mkp.ca.oracle.com>
References: <20240830075858.3541907-1-lihongbo22@huawei.com>
Date: Thu, 12 Sep 2024 20:19:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN7PR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:408:34::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5563:EE_
X-MS-Office365-Filtering-Correlation-Id: 912f3d5b-650b-4416-b18e-08dcd389b135
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PLrNWgUqvvYXCJYhw+owWE2yImgEilY2SeWw///3zB5NCvNvtvMzErVgBTMf?=
 =?us-ascii?Q?Jla5HmJ3BsHvVBJQL94kKV9SEz9RqFJ8kGUgAHUcIQeLJ3RZIE/wEXgaVikY?=
 =?us-ascii?Q?dUA/ix/A1ObTv1opY6dY5rtg2NNOC8G/LndygqAlNHuuKgItYIBhsSWUBbWg?=
 =?us-ascii?Q?CiTrw/+JC9nouYccObDk+L6MG+TlfftuLaDk0oDHk6FSqpuHZDQuar/72uy2?=
 =?us-ascii?Q?21/CVzYfMnByNs1lUGsiLXTTG2oy8odEchnj28ltRQB41ocBCyK3XroIHDh2?=
 =?us-ascii?Q?wy9SYt6geBHKZkNkdwEXAox1uDgsm2duXd5dmFb3WcbHMzTcu91w68ePB5XD?=
 =?us-ascii?Q?u4mpfePmEjMmMr1urZ10XdH6UXafQke29vCg75ScBznM0dAv5NUgZpSK4v5x?=
 =?us-ascii?Q?Jypvz4wcJNRkF0Whur1+/HU33fZYTkI0pcGNEo8vr7mZ0ULyfK7fDObnBpo3?=
 =?us-ascii?Q?UHiGAsR+4esYa9FOzWHFV2pZwcs2tVKaTqr/pQ5cpMs2Dwp8QybFPduAkSNo?=
 =?us-ascii?Q?bNE2xluPiGBAKhHS0ePTgYQOhIb4UzzKw3y/eCfxJorly/YTrPQg+CPy869U?=
 =?us-ascii?Q?MOOxMpqrmc7MG3IJnPCG1CkHo1A215Styv6OMSURCpaVCKdiduNZ/XH3q7if?=
 =?us-ascii?Q?TrsRSPCZvVDuAH75ttmQ7Z2XeJgKn0xERv0JvECPzPfrS5Usy2OECB85avr0?=
 =?us-ascii?Q?jeO0zDaVd3kAADLtJHbSVrErSk31UHVR4UlfeabTLrOX3c2kokmvx4p1jAUe?=
 =?us-ascii?Q?rCsDVQ59t25e5MjRo1CijEobnmJRaVBPN31aK7kNisFrGcAOgP0Gu8Jtuthu?=
 =?us-ascii?Q?Skze1p+frtsRA/0mcbAMaaQfkLo+I0ZocTl1YS0tWRaI69/G1nsc8jUNiIFQ?=
 =?us-ascii?Q?xsDGiLKzK+EOzYd4GmEWv0Bg8AUBcb0i++hOfMvlZoUCNC+7HVLAbtqlhQtV?=
 =?us-ascii?Q?VYdoqpSO7PUkz7RkB2gxeCWdDHjRlfFYQfubizKD/YxIOBzVqq6asvu70N1I?=
 =?us-ascii?Q?oeyM/Gv90RF14tTnT1axjQJ+V7W0i79SvTMwdPJWtahpmspuMRWyaWbZSGEq?=
 =?us-ascii?Q?+P/aQczAarPWb/0kebjiAjqujma677455uxFIEDQAer5eQ3/tQY+4jNDypLW?=
 =?us-ascii?Q?ofc6VYanjllTaXzPVdY3EvJeepW3qB2jPktCw+ChX12bRO7OV+5LEOOCKJKQ?=
 =?us-ascii?Q?GAB6/m3Y8G51KBVWgjv1Ahp6TQowMVtbrEASbJeUyIWEjd9RGl3nMPtOMC31?=
 =?us-ascii?Q?m2yjI+om5KMfNDkCF5dAmfWaa0Pp6RZxAqgzLiBINDfs1EiHyje+6v/Ic7y5?=
 =?us-ascii?Q?2sy27lQ8to1ACQOtu0kUWzRcORwXkcD7hujf2cz6V5VuIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6MQlz/F35ZnKeUyQ9zPfwFIBGrrhHA4B165WNWwzS2ByctUwI3OF8mKjbGkZ?=
 =?us-ascii?Q?9B7oHVLiXZ/lDYtccFCw16ozXlQuQ+G5oCuXUKWGZ/Aarcvj0BT4AHBNO9fq?=
 =?us-ascii?Q?tEojhLoaOkxeN1oSXpOZ8QVtCtN72snwEggs8xNYanQJYuzgY7rFnDrBTaCT?=
 =?us-ascii?Q?8gdFNRPZnQCT7R5QcOhjjN4ObMTHfQZDypwJf0ctRStezqx9OhVEgX6ZR2NU?=
 =?us-ascii?Q?xgoqu4DH4jUQr56nVb5DSiHbKaLqlNCWPGrm+dah08oBBP2bzLbI9hMSsTm0?=
 =?us-ascii?Q?wUG4FdNilLm+uyOd+xXqvPXFJJMvQFxrEH1QweG4vjtrtG3MKfRb/TA5CEQi?=
 =?us-ascii?Q?DcfFNDQZTfkjPXMxkF9rDPNCbkYPSqDzSFI+BvCgQiMlfyiRQROKUiRgEm6w?=
 =?us-ascii?Q?OZ76Upb72mpiC71pxcsONreMHZT5H4XanpexUE7bkS1JzFxbjQycgWPbWI1B?=
 =?us-ascii?Q?85hUfwFprfQY0yc2CgrKv6OG1zYGV7WIX8sVWFOgNwUoEPZ+LlPbVdufSZm+?=
 =?us-ascii?Q?1KVPGJ7tBWdQNEVNIUqKOZBebw0xljT/wAaoq3Ym0eAcfbg+kMtxpGUgDQ4c?=
 =?us-ascii?Q?beRtoOTqAN5EMDKZXqh7dEs1XLHreO77Er0TeHSn8acWYKTNV/imV4I/XqQB?=
 =?us-ascii?Q?BZ9e0IWE26Cfc4wQqtjw963WPb7hsQ9t8z6Zy3NSOAy348z5e2ZX6z4zrolP?=
 =?us-ascii?Q?e5aXWBdGumA+YYqWutDEoqNEE22jqKYSVtOM6n/P5f6/rzQIdFAjGZwwYJt4?=
 =?us-ascii?Q?mUhjlQVTfTFrdFtvY4Xyu0WoY9204AetFFsp0APk0SpPyY/rUx54KmewHqFS?=
 =?us-ascii?Q?XnD7fzvYkjeNhux5ojwoUBleaikU+nItSf2PgGYEdpKHtl7yOlM8ILgS7+X3?=
 =?us-ascii?Q?FAdyiE11acW5AFlVWb9FpS/P4WlkcfWcY70VASRTsXThceQrs1xnmKc3wJtY?=
 =?us-ascii?Q?vS4Ui7HAWLpeGyg3w6umD0c17SO4Afm7zWVtYIi05Fv7ECszkoywRFKAbDBg?=
 =?us-ascii?Q?+WU6jHH5oDV18faiMGV3o2GAi9864KLiQMpcH01DsrTHFoI9Eam+fJ3dMk+W?=
 =?us-ascii?Q?tWKOIYlHjir2LkCnuCPlj9EDeUIgYu1ScKgcVxosNSq01TVSOqvSfSjZFs+O?=
 =?us-ascii?Q?qqEOFPjZoyzWMYOYcczc88hSRsb1hk3gN51orhU7zzoBnOPt6GCES4pRb1wN?=
 =?us-ascii?Q?qQwz956KQREuXTfkCIitodkb7ErAOWqKBjJ1LanP+4AJM1OOWG0NiN2dRLvV?=
 =?us-ascii?Q?ShMOk8dIYRqQDpHxGNZ4M9fuPn6MRuFqCWMoLHEAXni5WjHrJB/ogcdcqzgY?=
 =?us-ascii?Q?Hxm4vkwOGqyt/hKsO68Wj4LFYz2aoxC+horRHmFwJqT5Ux15S74LYRMvN9EA?=
 =?us-ascii?Q?6PL1fy2GE7HIH2UDGfKm3SREjHuD5u4GxhcCkpN09oByZ+5v33oE1VJf1f7H?=
 =?us-ascii?Q?yHO5qrJXU022QwfSqApw1cmjhw3uw/5IdAkiAnMVyM6yzxyJKrsrNZUm2SjQ?=
 =?us-ascii?Q?JVlH7nRk/9EvZtbHu0fMA8ZbNoJCESmn7d6WqRzIYiFfk+In9p4ej7wRt/al?=
 =?us-ascii?Q?MtWz3rLz0b0MoNQTNo9/iuBVo/so75XHuN7E2ho4Fw1r1GGFHnXgDrE+Bn3c?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r6UigvD52K2mwQ5MLQcRk6tui05fxCP9lWrZqc4y07yVtKNSCPZBatXTZNtu0pJFJgtIWTM7z9Gd2rrJRVxzPfb+cANHibRjUn34lg25t76Q/vbx0Yi7gedv5ZmDGtqjdDONcABlYj9a5c7XU+mL/44eShXUdDZcYpfcB+8AgI1upVqsWoMwB2Y8cyoTc9Z6KpwZtrH+meMZPRv5HibADYh6FxywbetT35vBEIETKjcZD7wwdgoHsi4PQnn4Cqg/HjheDsbBkx/QSmXwW1ieQTdIE9uvSijJECNTycRWe7FqSLc0l0ORWThQI6JL5xLMYzLSdCqGO7cFMIMbogHFNn5BayHbg6Py6nmHRVH1wPVTpsWOzFEaofAPwXje11MYqMfXCHNBn3MXb9T6XcgY/ngk4rEcx+WmchHK1hWgVy5NzuWu6msnp0bNyy7CDF/ZgRsrkf3uHCRZzd0teScD1d9zSq405su8nWnGeAW9DyrKfWrZ3vbPz3I/XOX60uJH/AwA8f7o0iyM9KsBhjc4XYJNTK9mGtVI9NRO+Uuk8hm9liC8CB2NkWo5x8yYHSq5CaxWDHqHPvpH6X+sY+t2KO6CYFevRpvdaxh3XAlEonA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912f3d5b-650b-4416-b18e-08dcd389b135
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:19:11.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8PKqmlQVpctvcZhvRYGonqD6N3uKjmd4i22JMD5YxWsTHQUT0vadqjObRSCepbAAKsI5nonHrXnWFdpNRlFu9Yh9AoaCzEne8yTolDUNZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=888 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130000
X-Proofpoint-ORIG-GUID: 4bP6nNeLDJFux68P4xdhQVdedLsaVfm8
X-Proofpoint-GUID: 4bP6nNeLDJFux68P4xdhQVdedLsaVfm8


Hongbo,

> The header file linux/bio-integrity.h is included twice. Remove the
> last one. The compilation test has passed.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
