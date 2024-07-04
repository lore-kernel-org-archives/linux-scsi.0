Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B69D17993;
	Thu,  4 Jul 2024 03:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062342; cv=fail; b=ClFOCnlGcPz2ZtglH6mEwV9isZxJt8n8w5PWcMfP/l6J/zfVjRTQXEJ+6ln9h5CtFreNODwx3RQARECTCILZ11myFyxdemJmFTA6wL8Uui7VISKZglR/U2m6ZAR/0kLbyDc64wWzGNpLcP6JkRW/6v1ajqOvGhY34czg9/w7O5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062342; c=relaxed/simple;
	bh=bN5kGDA3Sg02cLAD2ektIV3kg9Gf/gcRnGkTxmrPRNg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Nw9WaCniUQTvykSoFkW71ryGzeJ/bgR0uEFiM+RHXF4xP+tR70Nd2zAcs3NXgB4Xt2otNMCAlGFZUTS5rWYI8V6QfDCuYKUSbZe5q6IU8mXtS38nW7U6h7La9oUQZmRZKHsScD2EvPXrHCezATsoKhgeDpVHz9d5iJHpOQP90EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W0ILzcYV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KEmsb1Ec; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W0ILzcYV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KEmsb1Ec"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4642MSNb012559;
	Thu, 4 Jul 2024 03:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=KrGuaa1rwBqumz
	XEAbP87sm9ileuS7fmZph3xXbPySI=; b=W0ILzcYVztpog1fDcf5z94/cq4Ivpf
	PHYqR09vYYQyuRtBlxIhNNlKzuE9IEjCKc6wYcIS+EiN9cyDihuvcJC9jedWZ7eg
	my2khfk3j8rSvMs2N620rdb7rK233CifDgHu9lhGuOXhx0J16WAn4v4BMPbL5PMS
	rGEdTlICGjFEQQsJDSjxGR8Jn+zzFJ97LvJKh3UveS+EAvLR0n9cIuGqyG+v60WI
	crDCxrKGfm6MOuIUwtwA9/l9TdC2Ktag9+Eb0UYRkiT92bFGEQKCHcv2Ttbfjb3r
	yNjUI1lF479wd3Vg7IHrMcln2FxzOrWK774KbG925br01mF6ahp3/u/w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4029231cqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jul 2024 03:05:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4640hPqp021519;
	Thu, 4 Jul 2024 03:05:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qg097x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jul 2024 03:05:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqAQYyvM7kfjTcw4i6K9agfcBu+XPvkGXbkZmfAiryi5xypLgoEmm9nO37GG/JrNWNjpFMj2yIYMAWmX+EKIvNkEB+MGkZ3Kpq9Skk/U8bnqCyOEGP2kIfEcBzNYmIjNiqUZawP9dqN683bjnvJ4bnNfS1a6zj7SDHqWranBmLZeSF8upTOJHiRhOOW75FJnbAKT/pqkMDZSWtZb+6XWNPQSzZ8LEpydtjvOSaUmyRF42uaPCZdviZtLXoLeJlzH1Tj+T1TzYAgaSDK8EZvFu5Klzktp46zm/XKGt6YcKwBIypnWy2DON9rGGsyFHeBOo29cvovQjeXXCX9fb3YNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrGuaa1rwBqumzXEAbP87sm9ileuS7fmZph3xXbPySI=;
 b=UAvUkYcWhDQ2bKJnLGdFrgEFAJ06DNk3FEKaIxexJRLWt5+VbcKeynmzu2T5SZg5guNfb86v6ev8C/VwXDo/rLmQLOXKN3x1B1W3jTK5aeSHvJte2uli4NAe86b9wLbBm/AeKVz0iv8A/HsuiChVCn9eBjBEVzgMzYeOyyKDf/C20c5wEGKc5lP1e9+/EobsILUWpVrdGD4ouIhSRWnrlF0+z9lxMBOjZSz4uShOgh3DwbCos3XmG7V+YviiZxNtHX7ydIFdiAbY+N8Mzj0pthX3oKOnddCAF4j3uZv0EXpLCsVgGYGh5y8XDXLdK1pVbOmy5IvrBNLf1QlXWOeeZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrGuaa1rwBqumzXEAbP87sm9ileuS7fmZph3xXbPySI=;
 b=KEmsb1EczdBGtRs9bc+foNvIFw/1/fC8Xma9tozMfNtA6vr5uQ1QenHPwXXCJ0Rmi3YwbYTlHQFEkO/P27L9rA87fX6xKbuFEAFrSyupnsF2l0Nr8aUfD/eWhx42EO5V7Bp3fMi8aHMxjbk/SIYOWY4ZLxC3ISn+mUXeky/llkc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA6PR10MB8183.namprd10.prod.outlook.com (2603:10b6:806:444::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Thu, 4 Jul
 2024 03:05:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Thu, 4 Jul 2024
 03:05:20 +0000
To: Niklas Cassel <cassel@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, John Garry
 <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 0/9] ata,libsas: Assign the unique id used for
 printing earlier
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org> (Niklas Cassel's
	message of "Wed, 3 Jul 2024 20:44:17 +0200")
Organization: Oracle Corporation
Message-ID: <yq1sewpc0x3.fsf@ca-mkp.ca.oracle.com>
References: <20240703184418.723066-11-cassel@kernel.org>
Date: Wed, 03 Jul 2024 23:05:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0062.namprd03.prod.outlook.com
 (2603:10b6:208:329::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA6PR10MB8183:EE_
X-MS-Office365-Filtering-Correlation-Id: b5dbf7c4-7aee-4ce1-67b9-08dc9bd62380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?egu/IoTMqBvF0FW2Du7DnkoG6n/Rlj828NLJB2sTuChM/VFn2mSjlMVWk8Rs?=
 =?us-ascii?Q?Rzc8n4SsMdedRiZqF9/5yqxDKZ38A4TQg1n30j2u0Qcx3uIKIJROrG6pBv66?=
 =?us-ascii?Q?/mBFcu1ox8rRlJmIcSH6xkx2qRPCiMNIGx3i9GvWOksNYMnpjspI+kNyvuEy?=
 =?us-ascii?Q?aBI/bJC4jetWMN1/j9Pul/pEUgokbQi5+L8HeRi9sexVb8kqaAyXVzYNCM97?=
 =?us-ascii?Q?b3Ux7bT3IDgsYaS/0PDrcktAh4kaMyPp6HEtocQbq78KfmS5huSU43u0JnXt?=
 =?us-ascii?Q?Oernam33TfFl+IXbJTcUOc2kbZBEGLD5D19mGQFA0Qux/aEPvIuMhuF/u3P9?=
 =?us-ascii?Q?Mo492RyVfCF83EUHtRiYQI6EeCxtYKYUR149G4YxN3kCmh3T0dKXhWf5HT7V?=
 =?us-ascii?Q?XNTfLorOo3N8rSuplD1FsrMekbvEHpFOlz8DDxlwfqz5Wpjg41SnI00fboRe?=
 =?us-ascii?Q?Ua+ZQBiwUYm2GyWh/W3UH87tJz0Bw+w9eNr8dglCxdLmLyEnwkA2CcsRf2yH?=
 =?us-ascii?Q?BVCZxXTvVbR0bcCdDzad0UVZpuQeE6XJcgS+ilys2Mg17z2ObtX8dx4CiJyw?=
 =?us-ascii?Q?3FF4Y+Tjipe8CmAZBxEO1Rbf1RNx4bngumUKZag35J4NQiwv05UXlSELeYZ0?=
 =?us-ascii?Q?c3Ag6VkiHWieWwVsogf/hubx+vcQSxLkh+Da0rQuDW+h0o97kKbvcKXbUpXK?=
 =?us-ascii?Q?nJBfzsIdyMk0ABXenfA85Y5TGBSWBQ1bsGVz2MvwphqUgNIMmKc8FMGvqzZl?=
 =?us-ascii?Q?G3H1sGQGkIv6PsEZ5v8V1L9xzPswlihsqouFeIGTvrzeXg3WshJdNTyI0kP7?=
 =?us-ascii?Q?XrfsjmQnO5beUIDHhKT4Pw4A7Jk9WSGyfis4QKYr9PGDMBpjKzRrRpUoflZ/?=
 =?us-ascii?Q?Wg6RKCLH/s9xwBSuLnvfXJf2HT4eLXoHRG76t/3pZTgDjMXlpuDeGwVD+/M9?=
 =?us-ascii?Q?AiT7VLIQm3PhvtuYRelIfUjJYPiUW//q7uzIAy1zBEAVxY62UupNRp5Kd+6g?=
 =?us-ascii?Q?rsDe6pjrplElK1jK8NiVt1ACYc8rBh9m81VEMGk57/q6ck2/ckjjzmVvPM9w?=
 =?us-ascii?Q?jNi9b68x37YytUcEXkcZwMVHxgJ2z+GY1b6NjG40U3XBRoysxH+o23XYu5tj?=
 =?us-ascii?Q?/mRLQ+H0SoPu60go+x2R0UlkL/KtsMgsWw7NADCM8UIqeDqOSNbJ7h1+/Kui?=
 =?us-ascii?Q?IHICa8mv5gGywgoxafa83Gif/Q5lXH574i9rJcDEu+bRFpsBHDGYt2I+eBa8?=
 =?us-ascii?Q?8pc6pjmEJbT6AENM+RkUbJN78z+soXlEUhXs9tdMNSHuF9CLxSiZ/DeOexI8?=
 =?us-ascii?Q?8l6GBu7F3IdbNdpU5pZjDySXqnjbcQKbuHPs+haVeOQhHg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?F9sLIaJORUCNLD8WhfGX+2l/qLmbeQCEBE+SRS0EXStNU3S9HqnHfQ/ivZpx?=
 =?us-ascii?Q?DsQQbwMs/S+weZEBaKkdodfu8qwRxyLbwXLIJGXldtsE7cAAhrPrqFuDB8yr?=
 =?us-ascii?Q?O/4Vf/pZtHl0Zi7Z3J6nYx3v/970b5h73WrdR2XJ9TrPeVzB8zlsApdMfzAO?=
 =?us-ascii?Q?xEL20eHRmK02DUo9HCnlv7b1ea2DWDXQFJLTyOwXAFDkCif+9V6ysCjtK8f9?=
 =?us-ascii?Q?pc0Z0hS+FW3szla6YHFXV/kcnz+oxw3K7RpMH2ac7WFwfU+nbjTNiIySqicB?=
 =?us-ascii?Q?cNhOMSox7A6addk9kb5lqQZZTcPkFnfZ2LjSm1e1fGIqNiFbuDlTVP9wLOxs?=
 =?us-ascii?Q?LQWcWuVi6K3ifBnPT/VhdLXkSDWyG+RUEz9YdhPqivyHMAmO3qEzZ5j/nQI/?=
 =?us-ascii?Q?i4Ir4b03iaBS4qGV2ng421F6nCKvXVEdxeucJnzQnxMrE2HHHCgM/FgUh8HS?=
 =?us-ascii?Q?ZJsxC4/ltzTDB6vmCKeEO4AR4zlA/GlLCDkDRyW1O7/845xkdQo9iZOWnySE?=
 =?us-ascii?Q?e43++F7VLPAVlsLGPFC2UEyMOV1koYGjm2ViRIXsEh/c5N6MrsFO1DRq0CcC?=
 =?us-ascii?Q?uzqW5ZCRiyswwXZBjG31RTWRxBrsmQY4ReAxyxuIBvju6cZKVkCwrUjlLFEk?=
 =?us-ascii?Q?HIq1rV/sbART7qZvveO2IbSNLSsr3lyCaIZmI7PiNeftjjlu9Gsei69yOB7v?=
 =?us-ascii?Q?3QN7Vo3Z+1QJNkNny65q5YP0gyhzC7HmFF094OfIXnbBrBGcZtPILTCqwbq3?=
 =?us-ascii?Q?HxCDQ6QoTVmR0/ePlY35XCIc5SZbmb2e3VD3cbzzY0IbaVJltJ/If9tdlIsc?=
 =?us-ascii?Q?Ip7HOtAK/an5qWQYfOdzOODDvaYV8yPjJgEiee8gi4zWVKtSN562guZVqVaS?=
 =?us-ascii?Q?o5pqZWXnvadXIxrjpO6UK1mse3HdcwE3HJNFL+EcmL67CbTrCTABlo6G8VDP?=
 =?us-ascii?Q?KAM9DiHcZ2f+b7rluwk2nSHjqEa0olQEdFj5FIGMUmsUXKqDCqbE9ORhT7l2?=
 =?us-ascii?Q?gVLPZ4mKMxJSzCQl3r3QwfwMe0+IiNFT2dMrpudmqtfZfXd0WMylqQfShXiE?=
 =?us-ascii?Q?blxmxw7CWNVyCojcsvV9fYH76FXehXPJLEKH2fQgnaLHNWZ4m82y1jyl4TCZ?=
 =?us-ascii?Q?D8yqqPzj2aEOqj1yOIqeqNlwV7BDYqmDqFAOlNM8UrjMPdufpkak4kjScCOD?=
 =?us-ascii?Q?0kWEyDsDbZevAMmOABhtx8fFMr1+JUke6aCvtIHzUqTBW+cZeWr3NqjJv/On?=
 =?us-ascii?Q?okIm56WMF1ijM1XCarVJMRJOXwiENkeankf8Dtgy1qTs+1EnzDnyyfqPKguB?=
 =?us-ascii?Q?239BVEnswdQIGin1a+WU+Ieuz5My9IzDknVn0LmMhmQopRQdmM+XdjsNjX1K?=
 =?us-ascii?Q?zANMhGC6ZnkmpSSorkko7nGfeSwZ3Dl7by3weO+hlbt2AX4oIE2O3l/yUOy6?=
 =?us-ascii?Q?7V85GDbY/aoJ4vf7W0blXp8k3DJg0OmwR0ivnfqV4y7oI+OTc8rd1UwC9+WS?=
 =?us-ascii?Q?e7bup8touDL2VE1J3ak9u59WlbOUkIbybpXH/jgfu8WzbZei4kJuQrXkG8mc?=
 =?us-ascii?Q?Ug2jMurXQuPgEXizJ71lrx+9Zn33QWiAEjJstAOmFrjEHemoIgg2T6ytVvnr?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0pEel+1reA2j/osnW1lJ5JtwmsvcuPmxnSLtEKCbRpVZ+9S31kLxC5evYNk9jyw8azAzTpRtRGnVmxxsbvn5EqRG+dmydwphxBxTg9l4yp/xVOK6Jsi7vNiulTjbh1sA1CAZOHG5ypxywXN/ySFeBhZOTzOdDhfmrxLWnU6fyXRziXSCW8yeM5Ff+HvDqYOnwghx/PzwpvDFDOb141BcR6WhFHAI00xw78wnG+8hKy55o61tOUudM6Sa4yyBQictRoLdP/1s8hV3MgKksL69kpOgfPCH1nwQ/wwdxzET+llR5+y1BMd8ToHoJxiruF4jhz2CAUHSAqO7GPkvoRozmFSignwfRx5KqtG57POr3omttQghSjbYciJr4x8UODobNLchfAGNTOrM9hAVGIxf7KvYsDS75Jk65IskI4NsbzRYlLYY+GiCd6nz72ZjcacQh/Tw32JA5BiT1E94KpskEo4B0YAB37/PbqLYdlAaHAH1OL3pF8kzYiC1o4UFL8YUBt+KvjlEfCiAw2LEBLFZGySKbROk8A9Byy8qlJFYSgJSQGlTgwthaJUMSZOjztcC0vWmXl0qRwU7DdEmYgYNq7zk+Dil2Ba/PaWxK4RjBWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5dbf7c4-7aee-4ce1-67b9-08dc9bd62380
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 03:05:20.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngwSzRiT+W6fCdbvs/drajSdzhHdSVSYUcuq8nhw3YkoDElZxrFllC/JsLx+cRAeWPmdh4tbvkA1S2uW1DjFxcvggpreQf1RFNNhLvmb5iM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_18,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407040023
X-Proofpoint-GUID: iT6oscVEz-teCbZWtBz8ATTd1oeHYA24
X-Proofpoint-ORIG-GUID: iT6oscVEz-teCbZWtBz8ATTd1oeHYA24


Niklas,

> This series moves the assignment of ap->print_id, which is used as a
> unique id for each port, earlier, such that we can use the ata_port_*
> print functions even before the ata_host has been registered.
>
> While the patch series was orginally meant to simply assign a unique
> id used for printing earlier (ap->print_id), it has since grown to
> also include cleanups related to ata_port_alloc() (since ap->print_id
> is now assigned in ata_port_alloc()).

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
