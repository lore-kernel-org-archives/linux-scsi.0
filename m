Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE937262B
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956564; cv=fail; b=SwmRNs1RfvA3QYivLulWFnaXc4Pse/zbHtsMWor5c/beHVaXIHvjqquikYGJEm2+VXVeql2UMnN/ysOJJ4Hlou8Anv36Hdmz6lHsjdcCv8DO26og6aa3GTL33huoPcEOdwWjcu01QCARXqdBWi+rYJWPxLjxtPgGUwa9H/rW9lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956564; c=relaxed/simple;
	bh=YEiqzPuoUqGJhDK7pd4EsGfx8OisvpQvvbNGMyuS8kY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mqHaXCxPV3o8ylXn8T+exPEuoahTjKYXkIzYR09wP9ia9ZLAeI0gsgZPfE3e1s6PVsv3VzsFEDHJm5PcfNQE4FTwJHlzTXimOQNZlQDoXrZWtWxyOHicvRWClsf+1r8Dc/skkokl1yGy1ZLDep1VFWCFCo8Rbtzq5p9jPY9RcoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CMYIJD1+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EW0Rq1zd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CMYIJD1+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EW0Rq1zd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEOI9b3555083;
	Tue, 24 Feb 2026 18:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ph6gefxLvcYtVqKCSm
	7ay69Rd+bQkFM1AeeK92XK4rE=; b=CMYIJD1+OU+Edpy0Cm4erC/+h4KKAjhNAQ
	/+7S2pfCxpx2H51xsLtb78yxbWJsiZ6i7MO3CJ9j1o9CxDmr+/y2+nvhYvdQqaxd
	Q1jPP/6zk5gjw2MyzLDJ2cxAA+eXYyu8Z6nqCJMU0Z8g+x5roissy/OwpgBXT8k8
	x/Oxrfp/9IXFyGDbR/tY+nwC2X9Lg+0lBMxuUwCYNFFF9tlDJU7ZMFlAf0pVdck8
	e6AcgNiVVOwz/eCGAulVOKs5lwo9PVypx3hwpnkGtta04BX08Rcyj2RyxRXwPH7N
	A1VI00mkEdFwdglHpL28w8UpT92tHwGmu7/DdI7y/85tgeWXFaLg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a04tet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:09:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OHP0hN015595;
	Tue, 24 Feb 2026 18:09:19 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011030.outbound.protection.outlook.com [40.107.208.30])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a9nar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nIzYPr3AM6Y988GQacJwndRmSIQmuietCGX6DB1uPE3M0viorZkS77bLV/CuHnqISsPqHdGXERbWih0j/yNZm1RYXSBTvo+Iav+d6utS08lcktGXygviV+fWFBR5jqRdzmc8MaLRzfRp7YifUBOg7kC83ocRVkQKJGsUa7uMEPA+h3VddaaFrGk38pHoDgNvEt9wuL3PA5O5DhV5I0vaO8h8tzBLXNq73to3iqLposDBS437GXgMbb76G/zHEEzE8MAlPCylcAatCm4SATgsuso4L5ICNS0DAwtLN9gzdf5mAYvRLVaS7BHYcn0q9WJ2GjkfjDsW2fpnCQhpDkpd3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ph6gefxLvcYtVqKCSm7ay69Rd+bQkFM1AeeK92XK4rE=;
 b=e5X+KL7+cwvX8XDYYecfKzFysxQ2Hg5/kTDzNNIHcuWPVcZs73DpN7haSQpyMbESEBY6xiuLQqNVFwtUdiMSmpkQwphcmUQuXedKz+wqz9C6oxWvRaWpTxrExOw6jhb7i9tbCGhm8uSoenUBzreqVH3ZZWvBLD+PxqEwQfNbSdqieDefLbQ9qEwUMWjdONvTqU2Jh2bHmnS3rsCJhe8uHplB2Adl+K6rNsCAfh1VGfDmrwk4rKUiiOfhseAfKzoVeQ6jHcJa45xTlHl5ie6qUHKXui5eWsGFVa3Ji1SkPunHv4mSvMxfu2igSTAfaesJrEPO6HQcPKOERFNohlHV3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ph6gefxLvcYtVqKCSm7ay69Rd+bQkFM1AeeK92XK4rE=;
 b=EW0Rq1zdLpJ7me8CwMq/Xa/u3rw+kaoGUR+0PeD0KWS6GNvtL5LZSTcRccbXSzBpWs1pSvc/zlvU9ymkDP/fb3NmBbevbWx2zGOmJixroB9ta/ulPq1yaBssebLZLEqC+NKoEs+cLO1KeJkNaGlbeaisEeXdx8CTaoRSkVMve4M=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 18:09:17 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 18:09:17 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart833426@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/13] Update lpfc to revision 14.4.0.14
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 12 Feb 2026 13:29:55 -0800")
Organization: Oracle Corporation
Message-ID: <yq11pia9fpa.fsf@ca-mkp.ca.oracle.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Date: Tue, 24 Feb 2026 13:09:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::7) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MN2PR10MB4128:EE_
X-MS-Office365-Filtering-Correlation-Id: b0548b5a-35e0-45d1-be45-08de73cfd348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EdSQk8UQsGvioH7b4AIHFFx0n+DBrDavM1f1wIq+Y7UWOOx7tSjjmbzJyopk?=
 =?us-ascii?Q?4ey5KzpaEx7xOVBWg+GAj9dxYGG6KxfWDQIJYQdmIzf+52YsBlEnuZqMWTTv?=
 =?us-ascii?Q?VvGtfP6JGsvCj/34Hc0OjyroVx55BpeWCrLklBAS8ZY4pZSYwDi/XuOaMUjV?=
 =?us-ascii?Q?cLbe9mc7/d1gC6EA/liTJfEJqiWt6Vx9c7mXJMKfvl73h/fLx6fps4Pr7PnG?=
 =?us-ascii?Q?/Gd+QMI2bGUePslXkqWozpqAjSj2jJLxzR8cOg7cxvdPQdiBWRmxuVrUIvX6?=
 =?us-ascii?Q?w0omWZwJMRGaHCa2Ia5vq8ttU1dgdToDRPMNqe+1UrQ3zOrH/gb3BLgorO5H?=
 =?us-ascii?Q?36gt3opdLOrD0lEvnFJRusvy2QeFxO19aENA3mHQLODv0iziyBeHr4NKuALT?=
 =?us-ascii?Q?QaBbjQONadgWUuwtGackazyMv0lMPsWsZz4LFVn2R1/K3P8XIz57TlYPDGgO?=
 =?us-ascii?Q?MsO3hpSeKCCjSssxgGyUa/xxpnHuyIZg2OGItD1U17kFSsgj3HXOzWjbA/fd?=
 =?us-ascii?Q?LG5aTFSGzBvddqVa2wvKFsUiyeze0P6gBi8LdD/Nsm+WdnUDnHvq+XTofATf?=
 =?us-ascii?Q?dDBJWk3nSnBVBtLivVEO686rnQWfNk+X9YpVG5AF6jD7ewUOgeWYnAv4W/jL?=
 =?us-ascii?Q?AnGPAo09KEcbQXV86azaQCshXcV9qEr+dWTVKBu0hNqyRWwfd3Ug7DklSzor?=
 =?us-ascii?Q?NkWkjR/8ovv0KAFhw5K9hesjSYtqIwwZalf4b+hqhBXRP8gbR2iZKmQBww3Q?=
 =?us-ascii?Q?qZJrHyB5Hsgom9wCwd95UhHW8BNMuNOKeld7xshhRVdfx/15SWc2hEBddN3u?=
 =?us-ascii?Q?t1DgdfgViiBjiO0GgnWiyxJlx1xG5s5sd02LiL3gx7l5EPnchpVmY7TcVGB1?=
 =?us-ascii?Q?OTbc6lnqr7klutw/Oieow2kl5TAoPSKS1RapGUQqMZ6sQIzYee45R9d2wigb?=
 =?us-ascii?Q?1lYW+BCrirMyLV8WolzHPFATDSsLO50DEHJti5HHWgSgiZUKKTNCIEZ/znEK?=
 =?us-ascii?Q?t3RbqwcBfzodFY8jq3Di3magoUhTwPgT9cFmUiHfLVW0RZC+CjF0NvlAbdP3?=
 =?us-ascii?Q?bc/WcWOdvfBVUQXPI6F67e9ZbHQvWTTuHgcOAXww6LuroiLFrnEO2s9+r4PY?=
 =?us-ascii?Q?EkzFq4AjR0DYGCKqcKqzfXlHjTRqkz5//Ey3eP74qIeZZ9SL6NFc2HtiqxVz?=
 =?us-ascii?Q?RNJlAbpJoV/ftXA4TVLkRJJC0dD5brmYs6PnbbIKmzUIEAxCUyEmd2VbAFL5?=
 =?us-ascii?Q?GV69uFjSSXlpR0d/dkd/0X0tjqLXC4joiAz0qawnj1cg1WIKgyMc4wl6v8FG?=
 =?us-ascii?Q?/DR6eDHwaPBKMtTKPBB/xrk/6MdNRoi10m93cFJBohK7IsXu4jeazXrlPorV?=
 =?us-ascii?Q?s5VY1Z/Dl+XGh0UIUG+NxquKq6R2uj2au52ALXzH6tcYcEbMqPW2F+d0+VW/?=
 =?us-ascii?Q?CYFtllz8Yt88JmsusKkGQ5y8ZfsMzI/1fuSsyFqB72HfUiqMDYbLLi1IMEXu?=
 =?us-ascii?Q?BIt7O5W7BTL9zhDSjrnkYPe9CqwaU2ibMefp+k9hyGC8+um4gtY+iUH0+Iho?=
 =?us-ascii?Q?9vyHdNOmv9PKAzhiAqI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xV+BMeQZdDfIWEBKeI/7JRAs/kWEsgs3TjiVrj5b1UtnSXdStiJrq+iYJk6B?=
 =?us-ascii?Q?MZjb+OVKfw9cOZKPzcFIT4KfVc+0JZ7WS8D8wFWIotvh5x/RTmojYYaEflrV?=
 =?us-ascii?Q?1GCWaaIyyYKw96TtuVjXrCOITPHFdubtVCI1PgHIj6giw0JMLudqGz6WXfpr?=
 =?us-ascii?Q?6g1ADwTdpPqyrSauO9nA3bNUSlOjGoRF9vG/3pY/abL5/vN/CeKKMpfsoVx0?=
 =?us-ascii?Q?7B5GOhps9FZecPX5DogI0OypKb2088q09D0NpwZm3BtE7+0nX6+i1AsO2TLV?=
 =?us-ascii?Q?X7Hbgp6PsdOY/UDB9AnWDwKdm3O5xmpV4jbxbwCMroJRE7qMVub7W5+Xp8rq?=
 =?us-ascii?Q?23XMuzS0U2x60jmiBOx39fRrhKwWyseqny/eqbuyaPNEusIWevJRmst80Fph?=
 =?us-ascii?Q?/PMGMNKGH9HjDSR8EcChT5Wj/s3T46NnSB62vw48E/sP8U+oXwK6ttYABQ0F?=
 =?us-ascii?Q?o0QUoDPuwZJMbnjjaIgYDiFyFqDQkoHO0Zg6e3ra4qzKVjS7pFZYHI7jEGwt?=
 =?us-ascii?Q?VwWktddZpdNO8HTwTzvzLsxR/LCjULorycyxsNLv//oQ75IP1e/0X+U893K6?=
 =?us-ascii?Q?e1fWE5gpqJNnDQhTrV5tOF4tot99Dr+SLcXjPL75v8waqIg6ob88AE3i2hFk?=
 =?us-ascii?Q?lmlelv704SJKvUYBKJ7wc6YJFM2uMqAL5vsSAx9vD4NB24GAfQTZpztcSJ85?=
 =?us-ascii?Q?uuAT7Oj0OQyHJr+51FBRJkkIaUfAVIBa1b52oUlFcEnWO3ZPiXpB4g4hKY6O?=
 =?us-ascii?Q?G6n93t0R14zC9sh4yTctr4pJ9qHwRlJAjz658jI8W3VL+O+QLTFN3u76uO2n?=
 =?us-ascii?Q?3A964lwkT4ivNlhvT8TGVQLUK6dEb+Hr8VZ1yHyZSfZsUNqkmrtbe1pVMt9W?=
 =?us-ascii?Q?JWe3SpYTUMwHsA4o9tRRQNBs8M/NDCwdUM4kCYLarZ2RkDq/Urnto+IjO7hg?=
 =?us-ascii?Q?fshr6gaNKGIuSemeH82Y/C6Um3SMGWj+72CBkDVnNSl2FPXLY61Z/zMkWQNr?=
 =?us-ascii?Q?01iBi+HKXZsBeJmYiBKwJqTWA57KW31p11xRboq9oiUHfUuM2NDuI/jXFlkP?=
 =?us-ascii?Q?//2n3ekTWQ0XhckkkqW+235QOt3neBFtB5rLCOtWSaf65B8QeC8bPwdRBxou?=
 =?us-ascii?Q?+BRPGWGiqgmuhi/XNtDvcxX+GCIP36wsmbBvkWQjfWEfUXanh56+j2lrOvHL?=
 =?us-ascii?Q?oZWTIHU1/ajHaxQDZE0yjaUvWmHJc7mf9o082oBXt6oitc43m3ZjqPa3zZwx?=
 =?us-ascii?Q?Ktdg/aZQw6Duh0LU4b5lPH2L4pJ2x7ivx7J9sSnWWYy486hTKyzxSmUQiqfB?=
 =?us-ascii?Q?DVjYfoMHYH1nyaQUZkgCyhQ2JzptoyaIHfLomMrbp83Vr5Kd7DzMHEd08UnS?=
 =?us-ascii?Q?I/Vppp3nfJSvsHCckmyCTXidqic4WNa1n6wD3/4K5nBXJADCUj5xnXpS+Mt8?=
 =?us-ascii?Q?fDGpCRr9TAMVeO1RtYasbiFYak8US7zIYBrAAEEyOhCWNfS1Rgp6KE4c5VaT?=
 =?us-ascii?Q?ppoECPVvLnZquFDkAxD83fwaYGA1HLWbgAcU11tcKs5dBZwnO1q+bNTYgtfj?=
 =?us-ascii?Q?YIEh06oC13+qSlavCqT/WjoR2h2BkkMAUW4vTgw3NhFQDw0P0HLDpzRMXFE8?=
 =?us-ascii?Q?Ec2T3t2CLfuipKqgvObG5FensrDaHqeYo+k5cwvueV+1AOe/FRP47YXsmG29?=
 =?us-ascii?Q?tRxD1MzbjB+r3+zGtmQlYH5ApdF6c/TRpEwJsHWjfkoWpG+PFwIz944wt/ZG?=
 =?us-ascii?Q?hM+cypTZjJYj9UQ4tC8OqnDsF+6YV6I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	suoe5ySdxM0QbF6WxleMSmsHONkY28MCXOEDUub1Mbtn4OqoMU9coBi/Jio72Jv1radh+2AfI9RP7zvDSmt7qDtgTSk/sxcoL1wATkWqzydZZtCOn6hI2/epXdIhq00LMx7usq0E7UdaROl/1MX8qhFroSuosW+Q8PlNG02Iwcla4BbtzpQIjW2mVEf6Ux18X+Ci9xGy+HDjr7g4fp3Szal196RNu3rytgg+z3IhxNSv+rHHA9KVCloitTnQUjEV/tfvA5rbIEYxKXT1ULiIshLiZleYYXJHpIIdiWExKOROi9PK00Mn8MwF7oT2QUwNJ5N5BG+hbcuXsd7Tcxe/Foa0uYkBZ8wazFf7Kin5KaxqtlxaD/YNFenz64ocWUb7jdn95iPI5lHJ6xX+QSXmUAF3Q6v4AvqZ/dOnLUoBlkLJYqx9XrFzQNEcc0bQ1HymL8c5x+4QpyrC8vsXu5TY+iv14nwe3CsrkY/37gjmt8y/qCI7VLXUUfpD0IY1zvgC/RE+KhnXcKazPXk6wN7xwYhjVliyyswDDXfRNtC05xpFLwavTLlPMhxu7+as8zU2GM526EaxkWEnZLMrsSXbWWTPU0WjViWHzLEMCSEtht4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0548b5a-35e0-45d1-be45-08de73cfd348
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:09:17.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1dJdq48/c1z3VRoyJuw3mbBA0aaRha1JTKX+2KDmsSxOdeVlCv96Ew+IiuKEHFkd/X0UahCVOk8nIsUvNF/5WhJmC6U/cAUJ2z93jDJhHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=657 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240154
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699de950 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=AVCfDaj8Szg8PMWv7awA:9 a=DVKqRkKJf1IA:10
X-Proofpoint-ORIG-GUID: ioC7Ed5uLBO0UZ1GNAiNbqsJkyJPFg74
X-Proofpoint-GUID: ioC7Ed5uLBO0UZ1GNAiNbqsJkyJPFg74
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE1NCBTYWx0ZWRfXxEao/vHlxO0/
 yZIDA5ofQu+MdrXkbnN4lMryEvnlYr86ZRbNkpY07/GyxzTsIOgnUJ6Pae3pGXPaha7vcqlxOcI
 b3+wQHopyCQ9FxxNzuz7M6e389MwXW4IP8cqxnWgLxobTATcZOIYDImlrSKRDv1dp+oTTtP274Z
 uxhnlcaPzS6JeWKrvHJxlEkHRPLg9AmgAKE7bowxUGwHxipQ+O/jKshy6u4jyHvztP72jntn3EU
 C/ObKv14+y7/IBNR+1J9R5e14fBNlVU5+boKNSisODdwjKdRTO8o+dNzA68po4Vbq2bIRsepj+w
 +WoYwOZ5FYnkOdxsukKaFDa6Gvx/c7y0eO7ttUKKxwK9tAKoyRPqrnFItWWRJNA4dFbTQk171op
 OHpH36WvIBOgadeLkv/RSQygE4mvDB49MNbj1atcCDzqWESDbm/Q7+Q83JTOWKXgQRH1gIlNT6I
 GdOjXY1EHILhvfXcJag==


Justin,

> Update lpfc to revision 14.4.0.14

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
