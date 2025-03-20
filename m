Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0AD801;
	Thu, 20 Mar 2025 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742484686; cv=fail; b=iOgB7cqd4xpeI9n5f/LrE9eOoRIX4WQxiWeQMrWV6iO0ZDN735XAFYTVNRgS8pz6qwUiZsjJhFGuYojOteR9VumKQso9DTY37hmLKQ9X56WT1FRvhuHcvA+nk7LX1jbMRuRsf9n7BSIaGT90ZQBOGXN+c4wJUfcvcMARwhlY89A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742484686; c=relaxed/simple;
	bh=pvJdcSzXsCm6tH9Fkd+R9ImzdRaQ0ac/veIy/MPwXNg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hiCbsHPCawCAWVNIS6YTx+cneVW9PiuqZcZd3qZT17p49VEvY6mTioTCiSQn2waaw+Lcv+OXJAELpSZAHYCm3SwmoFh9LVvqFATMz+F7ArmTvK5b37VuKyf5yNpcGtynJNKW0J8RrziNi8z8PPHlIcBFdm0plHXuUU7RDz15JEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EU5ojWxL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nf+Dsyig; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EU5ojWxL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nf+Dsyig"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KDMkta016009;
	Thu, 20 Mar 2025 15:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RHscasbXYUaKDXsbtUkqrfCwdZ2W6Ej3kPDoQX+Zq7s=; b=
	EU5ojWxLLo0+7mBMDoNNl+HwYAiHMBQV3j+ivgq/wqP/IQlCUJqFx0AF/gclV7+U
	uU9c7489EmFJwB2kWKNxMvRJX4klw5zFUcIeKjJvw4cIMKKfLpquvjvhXgsFiJjO
	o5pwv4NyQd/H5p+BWYhRVLqnL4JL+rH2Pp+hoy0HKlU3Nl2wK45IHZk093hM9jNy
	0NSvUL9+ODHWy2tBQ13jsDUf+egQhKu46lHi/cxtVSp2aFD/VWwXonlVvAVzf9fp
	iD3nXuo0e2ET9iPHA4uQ3ESvFTvrygJdPvKDhbnHmR7EZa+BXnh3BORjPqyKPDkB
	cXKOAyedY6W7dygFebNejA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1m3x90w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 15:31:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KFL0J3018556;
	Thu, 20 Mar 2025 15:31:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxdp87j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 15:31:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uiLPkY8eUMy99DapQvRp7xLmxz1yZBpz2zgpFf1r9crAQrKC1/4M7Mt7Hvjh+hXNx06LFatG71dUzJvnhTL2pWMXtFkJOpr9LZIHb7QGgu1LRnzI24u8v0j770E0QHu0FyMMCZST6kkW6st2h5oofPazJQbNXKbm8jGnHLIArHo9ljvpbYms3Is51ehKY8BIsdzUR2mccxINWVxRBPvGE8L6P4RXbC9om89nDXT6S/xcChseWLGod0sMT/N3KAqOFxLZjIPRZsCDqsSzvXmiD09SXK77fyr59FBDb/rF5U+grnWP7/ACHriCv1pj4uFPvUe7nMyxGTKskX+ZvoVL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHscasbXYUaKDXsbtUkqrfCwdZ2W6Ej3kPDoQX+Zq7s=;
 b=WXRnuw2vgWHt91Xp/WQiC+eHxiwyi4PywWFCNwNw+0NB/IQ4bLR+gI2RW5bAYxvUbtVXycQCQzh7QYlhD79Qj2HzOwPvzoD4zMDw6vi4d9aug/EqcOcwik8ygeo31baTtaiTwbFyjPdjxA54iXNL70LykyvnqQsp/MUxBQ834+wCx3AlgQpktMUolQ/WG2vHShEkWEgqoA4B98oHlUGTRgQlK0IlKjCluJ2Q0Z0bO/pfyblWtu++Q9mtFHe90aO2o+NoG0euK9ZrTLO4wQIXCGQ6ETsqqORZKVBJIgunRk7PmYcc1AJbuIoTc98/vSica3yXzMOgXFwUqQswTiy04w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHscasbXYUaKDXsbtUkqrfCwdZ2W6Ej3kPDoQX+Zq7s=;
 b=nf+Dsyigeb+MZM938ZYwIfN6NO7XX+hMli8LjbEuXF72b+YtKZ1AjF1hNKIS7emcwoK9TKSQeTjLO657nb8pNJtqLWj8ChedGMtnjhBwY8b+EoZLds+8Jdd9vAOA5zIVOsa1hUmW/VbPZiIAia8IrUXJv6QMQy4sNVdI9FMj9oA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5114.namprd10.prod.outlook.com (2603:10b6:610:dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Thu, 20 Mar
 2025 15:30:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8534.031; Thu, 20 Mar 2025
 15:30:55 +0000
Message-ID: <6d97bc46-5394-4f5a-b1eb-1731ecc4ed93@oracle.com>
Date: Thu, 20 Mar 2025 15:30:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: pm80xx driver crashes in a daisy-chained multipath JBOD
 configuration
To: Jarl Gullberg <jarl.gullberg@algiz.nu>, stable@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
References: <b35d17b7-2583-479a-b7c7-6bfc9604bc5c@algiz.nu>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b35d17b7-2583-479a-b7c7-6bfc9604bc5c@algiz.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CWLP265CA0267.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:401:5c::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5114:EE_
X-MS-Office365-Filtering-Correlation-Id: 0357f6ba-3595-44e9-404c-08dd67c434af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXVLVlhPS1dOQk1zTmFNRHlEZHhjbldoZzBXdWpQTDFVVzd6QUVIUzJoMzZw?=
 =?utf-8?B?TWRpUGFiTWRQYUV2RVJNZDJLTFN2YTU1SFRXYmROWmdSbzBqVi9PNEcvMW1N?=
 =?utf-8?B?WGNhV2g2T2RYQWM5ZVhkQ0ZoSERSMy9Na21lcUVLdHVJNThHblJ4ZDhqTVpm?=
 =?utf-8?B?MjdLWFNjU0U2cU42N3N2REhNVkZkVURpME5PL0pMMDd1Z25GWWpBRmNzbmxL?=
 =?utf-8?B?TFFxYlVjeUtySlNVekhrOGVmR0ZTbHBkZkg1bXg2SDBGTGhZc3ZTYXJxYno5?=
 =?utf-8?B?N0FKeUFtT1BkcHh3d3pKTVRxQmhER3ZaL1FTU09nQStPVkZCd2ZxN3lzWm1o?=
 =?utf-8?B?WURvN3FDbjZKc0NqVVM0NnNxbzdSd3grdXVZa0lUTU5yN2d1Q2ZKcm96NkR1?=
 =?utf-8?B?cFZxTmtxeHgyZWlxSzk2YlZkY2ZLNXVNYWdKaTVUWDJOV3o2OVU2NmttZGEr?=
 =?utf-8?B?S2hNZW1MVVRHc0QwRFJVNFJRcVNHUFJoeXljUnB1UXJXRkU5VlAxUldzZVdR?=
 =?utf-8?B?Vmg4OVhJa01yQnFCaXZiRjMvNmIzVG0xbENyR1UrSzMrZFNsY3VMMVBoSW1W?=
 =?utf-8?B?KzB0MUhUWG5xUk9EOUM5WGsrSXF3L295SEpOcFc3Y0lEWmpKNW1VWlMxeG5n?=
 =?utf-8?B?aGNqNTlsZUNlK3JuNTQwajV1cXZlZTdaM3prbFN3eTF6d2VXVnU4L0VEVDRB?=
 =?utf-8?B?QXQvMCtkeGFNcENJTTNZUlBNbGp0MXJuaG5uU01GbzNZcFB5Q2JDQUlJTTZT?=
 =?utf-8?B?bnBRMm1uaStoQlVyUEdwQTVEUTFoY3B1dG9yemtvNVhhYVZkbUhiSCtoS1JG?=
 =?utf-8?B?OTJVbXBsUmIrVXNtNU9OOTB6Q1Bjalh4ZDlzc1ptZTF5NS94bi9CZWJiZ3JK?=
 =?utf-8?B?OGp1Y0tsL2kzem9sbVg2VXZMV1Nna2JzVDZ3YVJBbjJZNTFkb1BtSmdSUTls?=
 =?utf-8?B?V1RrVjljdlV1eEFYTFBiQTZlNkRObndTT1JKa2F1cnQ3Um94eGVFVWdHTXor?=
 =?utf-8?B?OFZtN3R2VnFvVXI3eUZvRnJwVW5iclBkaEo4dTUrM0FVTE9zUVhrK1JVSFZI?=
 =?utf-8?B?Qm9Xb081QUVtUFNzSVlsM3VYNldsemYxeC9ZT2dsZ2JkeHEzcU9kV1lCUFRl?=
 =?utf-8?B?eXlNaEV4K2VFRDdHeUlkbERLc09PMFJwdVBEY3pWOGpHK1VzSU4yVEx3YWRP?=
 =?utf-8?B?TGVibUdwaEV5Vm9wNGJlMndraTJabVUvUnloNGx0cEpHY09KZkFWd1dPWGVU?=
 =?utf-8?B?M3JpYmhrV3FaQTJVeDZaU2J2eVlqRGZUSW5FRm83Njkwa1dkckRMc3lzc0t0?=
 =?utf-8?B?SzdPM0dJNW1wMXNaRFBMMDRJSkFsYml6WERqYkVnL2NBSGpKZGxQMFRuS0ln?=
 =?utf-8?B?S2EwdzJBQlNUejhOcHFPZnArU3kvU2RHNFRFYU9Ccko2L08wcGNjeXYvY1hP?=
 =?utf-8?B?YXg3RnVabWJSamlCeEtOR1RYNm5Kd1lDSFluWVJQQmRRdVNsUm53ekc5Y0dX?=
 =?utf-8?B?WGZIRWFBdzVPT2VwL0xKUVZ0cXlNZ1kwM3I4QWNDM2JnZjNOVFc2TnBMVy9w?=
 =?utf-8?B?OEMrcjV4VEcvTmxrdnNpUDdPRTBkM1hvbjdjYUY1cVlObVJYcU54L3lEaTdI?=
 =?utf-8?B?cmZNS0kzL04wY3VYSnBkQmdBV2RWUFQzWWk0Umc4d0puZ2w2R2lhaFhpUDBN?=
 =?utf-8?B?Mm5TL0ViU2JuMjUzYTRLWk1rUHZzMmJDb3lVb1pjeWV3QzVEUVk0UVE4T0o2?=
 =?utf-8?B?Vjd1cGZ0MzBGQm5mNGdVTVVtODIwaGc4VzFxN015R0pSNll4bVdPcGY0ZWdL?=
 =?utf-8?B?bUkzSitTREtXYm13Z0FNZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVEyTU1tRm1wR1hHc1ZkYTl4dUNXVjZNakZBWnJDNm0xcWYreUkvU21kM2JI?=
 =?utf-8?B?U0d2b1ZOK2JJNCtwdnd2NmtXSGNteC9GNFBaN1duSXVBK2taZEdHeXJKMDdI?=
 =?utf-8?B?d2d4V2FyTDNENU9oR1puaWVHNTdJQTBZMUIrZFo1Z1J3ZW5HNTZ6UVFSUlpw?=
 =?utf-8?B?WXp0S1RjVVBYclVGUCtyeU0vYlR1blA2OStRYkFmME1NSy9iUHhUNnJKS3Mv?=
 =?utf-8?B?WEN1MXh5ZDcyVnNMT2ltRXkvNFhaYlJrWm9QZWN1cHBQSWJVUlRlck1UaHd3?=
 =?utf-8?B?V2gzY2JRcExUZVc5NEE4dWUxYVdCakFsSXVmdWtpdTMraUxvT29VNDZmNXRn?=
 =?utf-8?B?OXdBQzVWMDJhcDdNMTdMdFpwNTBmM3M4SEJveEk3VmhCOHhqSVJTWnFrTUFj?=
 =?utf-8?B?THROVTNVRmZ1enJxeHRiQW5wdFJEZ1ZxWW15cWxhVFU4U2trSFRVbGVUSzFV?=
 =?utf-8?B?eFlGRFBjTEZ3QXdNZ0tDd1V1aUNqQlRVanJRR2d6amFOZVVXbzJCSWFOeGZZ?=
 =?utf-8?B?YWdTL3Y0UUo0MFc4S1BUNHd3eVNzRU4xZTJvY3pFTHBaT1RPbis3NWxISTNC?=
 =?utf-8?B?SFRWZ0dlMjBHdU44M0xwcGovNytGVXBxZFZVbmVvdFFHTm9Ucjh4ejBVeXdo?=
 =?utf-8?B?d0ZYQW8wVGlUZk5XVDhXVjVJN0xDd2xpOUEyVHJ0dVJnL0ZqOXdHWWpjRERJ?=
 =?utf-8?B?Z1NtUHVYSW1kSk1vYlJNUGZMS0RsdXJjZDhRT2tWMlQrNHlqUEhTU3NLaTdL?=
 =?utf-8?B?WjlGWG0zUUJxSllNWUlXdWV2QWNBVXZ1b3JiZ3VRQmZwYVl5MThueU04R2Zr?=
 =?utf-8?B?K1lDNFRaN2NCQ3FyRHUzd21oM05WUmlCOWxiSk9oRXpFQmV6K1orRlJpWU16?=
 =?utf-8?B?b1lBL2ZRcW5hRHkrTEdFM0I5OFZKajZwUmdaVHhzZVluaitRSGJqSWZDSi80?=
 =?utf-8?B?YVAyZXBrdVFUaDVBcFRyamdLZU5GVCtRN3ZnVGRSSSt1UGhpQ0QzbVVqVEUx?=
 =?utf-8?B?MmdqdU0zaHVRUVc1ZjFqWlRFOTNNT0RiQnBSU2ljOEp3WmFDNDQ3SjF2ZkFQ?=
 =?utf-8?B?MmxDL0dweDBFd1NPOHl6VCsxTUVtMWpENi85SjJsdEtoNFFRbEppQnMvOE9O?=
 =?utf-8?B?Q3dCVllmTXJSckE1cmVzdWxIYmhQME45cDl6QjFTT1hHcTl0ZjdVY3hmMTNq?=
 =?utf-8?B?bGJ2eVArSUczU01wK3h2OVdiVDlTWjd5d0hXRDFmQm8rUGVxanpsUVVQRTgv?=
 =?utf-8?B?WnVCVm1VZGxWZjlkaE1CNWFGQXdHWXUveVRlazdlWFFYY2wvM0dUSFhuOTVs?=
 =?utf-8?B?cHJPMS9IUFNYcld2TFVGaXI5eU5sdUJSOHFoSlpFeXEzYngrbjNVenhHaWJU?=
 =?utf-8?B?OW1LQWlVakc5WDFEVjNXeS9aZEo0TXk5ODRBSG15emVuRzl1a0tlNkJMQlNi?=
 =?utf-8?B?WnNoaWVvRHJmVTN3M1NVMFNLczRVR1lQYVNWM2tya3hibFplODJ5QmJwN1Zm?=
 =?utf-8?B?Rm1wRDdRNy9PN2pNOERqT2JwSEgrK2lHdVo2eDRONWRFbkVyMENSK0ZkZ0ZQ?=
 =?utf-8?B?VXArOE1SRW9RVm5YaVJnRXlLZTliMEZHei9RR29BRkNraHozZ1duV1dQTGZ2?=
 =?utf-8?B?WmRIc2RXK0g3dmgvaGh1OFpWZkU4VWlsVTRJbWVhckRxSDEvVnp2Z29pd2dy?=
 =?utf-8?B?UlNJYjU2UHlhcE5Db0RWSyt4V0F6WXNjOHhBeUFHZGluR1VNKzVPT0Jhc1Ro?=
 =?utf-8?B?cWZVVm8reGlOM2JEazhqRXNIR2hxWVhyWlhqZmRYUytUbkk3bTgvS2dGNHRu?=
 =?utf-8?B?MDRVVFR1Qkk0S0IzaDVUV2plcGJ6enppd3FOYlpHL1NIT3N6Qk9YNkpTdWtK?=
 =?utf-8?B?a2V5bUZQUVRxRU5uUDUwYmNadkpiTE0xMHBrdk5MVDRSWFFSR3dURFpNQ08z?=
 =?utf-8?B?cHdBSW5hU3ZYWDJUZENiL1NRcnZMR0Z5eU5ubDl5MGpNV0d1RGo3akJzUUl3?=
 =?utf-8?B?c3FtbG4rcHJXSlpqdWhLektodXc5c3hOR1kwUGQ4eVp5LzdGKzFOYWNUUzZj?=
 =?utf-8?B?OGZSZC9aZVZzd241Nm9SaVAxbzh3TWVvQjhaM1grV240bzcvakNxQ3lCU1Ja?=
 =?utf-8?B?Um1rcFNKam1nQ2cwaHVzQU5qTEFRVUxEazNJNFo2WWJyQ2hSK2lZZVVWYTVq?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MWsELaNJYDIpss5T/q6kJmTUo/K44ip/x68qBmPF5sHA+uCmAjW12gaPN3Y1YBqHkKiedlXFjeggvMNFbPx8O4aBZPGUD+nJI4gNaHeG06zddXAvr6sYIpNN+8V9pctek/1vvXFrEpSxDwTb/8U9CZmhr5f6K0iZmEyvoEqhIqrtvwJlNq6/a4Y2z+6CJfYTF7InvyKp/JNTih1fOJ7rTL9NnxCsMkjhB0YsCtW4c5PcllLtN0qa6gwJOpk8JJScNn2lTI9Z3py4umDaq+fDHNShnpLryOXD4HPn5G0uQ8M3nOiRMG4PZm2z64lG4MSNfHOpIbSuLtYx7nB4Cfi6kzI+N/LrNQenb9mRA3nZl4mrtbFu65WccEsDabeiCSd/i2WvDWrR1AYfjeuSCgHJtmPGy5nG0Nm82qZ6YtrIz4dsUtzvQRqXsxNtLFGhwF18XUU5M13SaknZ6QhAKX8KHs8074Pl1LldFHGhBMOSD/MqctsH0wzJ0hY2gsJJR/gI77V5nhyhv9Je3n9AS6N0M9biv7RE9Fqw7kwDLa3phGwcwsBHavzbajgoOX7sqrUbI6UZvC/iLAe1ADth6MkJItLfgk0ddfPXcKzKNELP/ZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0357f6ba-3595-44e9-404c-08dd67c434af
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 15:30:55.3978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UvF49aHY5Ux2+sY2AyEVX9znR1A10FnvoWnI2uWBT9mNSEEhJ25WAgK2Me95wnMZDNZuMEL6424rDFVoB/MVGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_04,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503200097
X-Proofpoint-ORIG-GUID: 43-oGRwwhQN8ONys7aaQvN34T_R2de_Q
X-Proofpoint-GUID: 43-oGRwwhQN8ONys7aaQvN34T_R2de_Q

On 20/03/2025 13:55, Jarl Gullberg wrote:

We did have a similar report some time ago:
https://lore.kernel.org/linux-scsi/SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com/

But nothing came of a fix for that unfortunately.

By chance do you know if any earlier kernel version worked ok for you?

> I'm having issues on kernel 6.12.12 and 6.13.7 with the pm80xx0 driver 
> using a PMC/Sierra 8001 card pulled from a SUN/Oracle ZFS Storage 
> Appliance. Specifically, the card does not appear to handle daisy- 
> chained multipath configurations correctly, and either locks up at boot, 
> crashes during runtime, or doesn't enumerate the disks in the JBODs 
> correctly. My topology looks like the following:
> 
> ┌─────────────┐
> │    PM8001   │
> │ ▒A        ▒ │B
> └─║─────────║─┘
>    ║         ╚═════╗
> ┌─║───────────┐   ║
> │ ║  JBOD 1   │   ║
> │ ║           │   ║
> │ ▒ A       ▒ │B  ║
> └─║─────────║─┘   ║
> ┌─║─────────║─┐   ║
> │ ║  JBOD 2 ║ │   ║
> │ ║         ║ │   ║
> │ ▒ A       ▒ │B  ║
> └─║─────────║─┘   ║
> ┌─║─────────║─┐   ║
> │ ║  JBOD 3 ║ │   ║
> │ ║         ║ │   ║
> │ ▒ A       ▒ │B  ║
> └───────────║─┘   ║
>              ║     ║
>              ╚═════╝
> 
> Each JBOD has two dual-ported controllers on it, allowing for multiple 
> shelves to be chained together and the controlling server to be attached 
> at each end. The same topology works with an LSI/Broadcom card.
> 
> The problem can be divided into three separate instances:
> 1 - failure to boot
> The driver crashes outright on boot when enumerating disks. Kernel logs 
> from 6.13.7: https://urldefense.com/v3/__https://gist.github.com/ 
> Nihlus/8b390a56ce743a85ff7aaf7b38cb501a__;!!ACWV5N9M2RV99hQ! 
> LI7Pw_xqRwStNn5N13RzQjbL0DOUoI_wA4ekgiNME2kPB9HP8XxGqfNziRzUQVihbHjVCXBjPqYCZQbWshP2GgUqPGle$
> [   15.261604] kernel BUG at drivers/scsi/libsas/sas_scsi_host.c:378!
> [   15.335390] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [   15.402050] CPU: 0 UID: 0 PID: 374 Comm: kworker/0:2 Tainted: 
> G        W          6.13-amd64 #1  Debian 6.13.7-1~exp1
> [   15.528840] Tainted: [W]=WARN
> [   15.564215] Hardware name: SUN MICROSYSTEMS SUN FIRE X4170 M2 
> SERVER       /ASSY,MOTHERBOARD,X4170, BIOS 08060108 12/27/2010
> [   15.698278] Workqueue: pm80xx pm8001_work_fn [pm80xx]
> [   15.758607] RIP: 0010:sas_get_local_phy+0x57/0x60 [libsas]
> [   15.824126] Code: 9f 2f 86 e0 48 8b 5b 38 49 89 c4 48 89 df e8 e0 29 
> 4c e0 4c 89 e6 48 89 ef e8 45 30 86 e0 48 89 d8 5b 5d 41 5c c3 cc cc cc 
> cc <0f> 0b 90 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90
> [   16.048618] RSP: 0018:ffffaa888e017db0 EFLAGS: 00010246
> [   16.111024] RAX: ffff8fe450766408 RBX: ffff8fe4515e3c00 RCX: 
> 0000000000000002
> [   16.196288] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 
> ffff8fe4515e3c00
> [   16.281552] RBP: ffff8ff5ca075c00 R08: ffff8ff5ca0758c0 R09: 
> 0000000000000014
> [   16.366815] R10: 0000000000000004 R11: 0000000000000000 R12: 
> ffff8ff577835200
> [   16.452077] R13: ffff8fe450760000 R14: ffff8fe450780e40 R15: 
> 0000000000000000
> [   16.537342] FS:  0000000000000000(0000) GS:ffff8ff577800000(0000) 
> knlGS:0000000000000000
> [   16.634063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.702706] CR2: 00007fa7f2f58273 CR3: 000000035c022003 CR4: 
> 00000000000206f0
> [   16.787969] Call Trace:
> [   16.817136]  <TASK>
> [   16.842151]  ? __die_body.cold+0x19/0x27
> [   16.888981]  ? die+0x2e/0x50
> [   16.923345]  ? do_trap+0xca/0x110
> [   16.962909]  ? do_error_trap+0x6a/0x90
> [   17.007658]  ? sas_get_local_phy+0x57/0x60 [libsas]
> [   17.065922]  ? exc_invalid_op+0x50/0x70
> [   17.111710]  ? sas_get_local_phy+0x57/0x60 [libsas]
> [   17.169970]  ? asm_exc_invalid_op+0x1a/0x20
> [   17.219921]  ? sas_get_local_phy+0x57/0x60 [libsas]
> [   17.278184]  pm8001_I_T_nexus_event_handler+0x69/0x1a0 [pm80xx]
> [   17.348911]  ? psi_task_switch+0xb7/0x200
> [   17.396779]  ? finish_task_switch.isra.0+0x97/0x2c0
> [   17.455033]  pm8001_work_fn+0x6b/0x4e0 [pm80xx]
> [   17.509144]  ? __schedule+0x50d/0xbf0
> [   17.552856]  process_one_work+0x177/0x330
> [   17.600721]  worker_thread+0x251/0x390
> [   17.645468]  ? __pfx_worker_thread+0x10/0x10
> [   17.696455]  kthread+0xd2/0x100
> [   17.733933]  ? __pfx_kthread+0x10/0x10
> [   17.778683]  ret_from_fork+0x34/0x50
> [   17.821360]  ? __pfx_kthread+0x10/0x10
> [   17.866107]  ret_from_fork_asm+0x1a/0x30
> [   17.912942]  </TASK>
> [   17.938987] Modules linked in: usbhid mii hid usb_storage pm80xx ahci 
> libsas libahci scsi_transport_sas ixgbe uhci_hcd ehci_pci libata 
> ehci_hcd xfrm_algo igb mdio_devres usbcore scsi_mod crc32_pclmul libphy 
> e1000e crc32c_intel i2c_i801 i2c_algo_bit i2c_smbus usb_common lpc_ich 
> dca scsi_common mdio
> [   18.253949] clocksource: Long readout interval, skipping watchdog 
> check: cs_nsec: 1981286504 wd_nsec: 1981285958
> [   18.375615] ---[ end trace 0000000000000000 ]---
> 
> 2 - runtime crash
> This happens if the cables are reseated or the JBODs restarted after the 
> device has successfully booted, usually by leaving the cables unplugged. 
> The disk enumeration fails to complete, leading to a call trace in the 
> kernel logs and typically causes the JBOD controllers to get stuck in an 
> unhealthy state (see case 3). Full kernel logs for 6.12.12 are available 
> at https://urldefense.com/v3/__https://gist.github.com/Nihlus/ 
> cbbabe685de551afa2cc8cdfbc6be6b2__;!!ACWV5N9M2RV99hQ! 
> LI7Pw_xqRwStNn5N13RzQjbL0DOUoI_wA4ekgiNME2kPB9HP8XxGqfNziRzUQVihbHjVCXBjPqYCZQbWshP2Glf0272-$  with the relevant part being
> 
> [  415.245390]  port-0:2:32: trying to add phy phy-0:2:32 fails: it's 
> already part of another port
> [  415.245473] ------------[ cut here ]------------
> [  415.245475] kernel BUG at drivers/scsi/scsi_transport_sas.c:1111!
> [  415.245483] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [  415.245487] CPU: 0 UID: 0 PID: 11 Comm: kworker/u96:0 Tainted: 
> G        W          6.12.12+bpo-amd64 #1  Debian 6.12.12-1~bpo12+1
> [  415.245492] Tainted: [W]=WARN
> [  415.245493] Hardware name: SUN MICROSYSTEMS SUN FIRE X4170 M2 
> SERVER       /ASSY,MOTHERBOARD,X4170, BIOS 08060108 12/27/2010
> [  415.245495] Workqueue: 0000:19:00.0_disco_q sas_revalidate_domain 
> [libsas]
> [  415.245522] RIP: 0010:sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
> [  415.245539] Code: d5 75 e8 48 39 c3 74 8e 48 8b 4b 50 48 85 c9 75 03 
> 48 8b 0b 48 c7 c2 80 c5 46 c0 48 89 ee 48 c7 c7 ae c6 46 c0 e8 5d 32 ce 
> c9 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> [  415.245542] RSP: 0018:ffffb595400d3c80 EFLAGS: 00010246
> [  415.245544] RAX: 0000000000000000 RBX: ffff905c9651d800 RCX: 
> 0000000000000027
> [  415.245546] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
> ffff906db7821780
> [  415.245547] RBP: ffff905c96eb4400 R08: 0000000000000000 R09: 
> 0000000000000003
> [  415.245549] R10: ffffb595400d3978 R11: ffff907ffff7ab28 R12: 
> ffff905c9651db38
> [  415.245550] R13: ffff905c96eb4720 R14: ffff905c96eb4700 R15: 
> ffff905c8809a800
> [  415.245552] FS:  0000000000000000(0000) GS:ffff906db7800000(0000) 
> knlGS:0000000000000000
> [  415.245554] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  415.245556] CR2: 0000557484600000 CR3: 00000002f2622002 CR4: 
> 00000000000226f0
> [  415.245558] Call Trace:
> [  415.245562]  <TASK>
> [  415.245565]  ? die+0x36/0x90
> [  415.245572]  ? do_trap+0xdd/0x100
> [  415.245576]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
> [  415.245583]  ? do_error_trap+0x6a/0x90
> [  415.245585]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
> [  415.245592]  ? exc_invalid_op+0x50/0x70
> [  415.245597]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
> [  415.245603]  ? asm_exc_invalid_op+0x1a/0x20
> [  415.245613]  ? sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
> [  415.245620]  sas_ex_get_linkrate+0x9b/0xd0 [libsas]
> [  415.245631]  sas_ex_discover_devices+0x38f/0xc20 [libsas]
> [  415.245644]  sas_discover_new+0x71/0x110 [libsas]
> [  415.245655]  sas_ex_revalidate_domain+0x337/0x430 [libsas]
> [  415.245667]  sas_revalidate_domain+0x189/0x1a0 [libsas]
> [  415.245678]  process_one_work+0x17c/0x390
> [  415.245685]  worker_thread+0x251/0x360
> [  415.245689]  ? __pfx_worker_thread+0x10/0x10
> [  415.245692]  kthread+0xd2/0x100
> [  415.245695]  ? __pfx_kthread+0x10/0x10
> [  415.245698]  ret_from_fork+0x34/0x50
> [  415.245702]  ? __pfx_kthread+0x10/0x10
> [  415.245704]  ret_from_fork_asm+0x1a/0x30
> [  415.245711]  </TASK>
> [  415.245712] Modules linked in: binfmt_misc intel_powerclamp coretemp 
> kvm_intel kvm joydev evdev crct10dif_pclmul ghash_clmulni_intel 
> sha512_ssse3 sha256_ssse3 sha1_ssse3 aesni_intel gf128mul crypto_simd 
> cryptd intel_cstate ipmi_ssif ast drm_shmem_helper drm_kms_helper 
> iTCO_wdt intel_pmc_bxt intel_uncore iTCO_vendor_support acpi_ipmi 
> watchdog pcspkr sg i5500_temp ioatdma acpi_cpufreq i7core_edac ipmi_si 
> ipmi_devintf ipmi_msghandler button dm_multipath drm loop efi_pstore 
> configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 efivarfs 
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
> async_tx xor raid6_pq libcrc32c crc32c_generic raid0 dm_mod raid1 md_mod 
> ses enclosure sd_mod hid_generic cdc_ether usbnet uas usbhid mii hid 
> usb_storage pm80xx libsas ahci libahci scsi_transport_sas ixgbe libata 
> uhci_hcd ehci_pci ehci_hcd xfrm_algo usbcore mdio_devres igb scsi_mod 
> e1000e libphy crc32_pclmul crc32c_intel i2c_i801 lpc_ich i2c_smbus 
> i2c_algo_bit usb_common scsi_common mdio dca
> [  415.245777] ---[ end trace 0000000000000000 ]---
> [  415.245778] RIP: 0010:sas_port_add_phy+0x143/0x150 [scsi_transport_sas]
> [  415.245785] Code: d5 75 e8 48 39 c3 74 8e 48 8b 4b 50 48 85 c9 75 03 
> 48 8b 0b 48 c7 c2 80 c5 46 c0 48 89 ee 48 c7 c7 ae c6 46 c0 e8 5d 32 ce 
> c9 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> [  415.245788] RSP: 0018:ffffb595400d3c80 EFLAGS: 00010246
> [  415.245790] RAX: 0000000000000000 RBX: ffff905c9651d800 RCX: 
> 0000000000000027
> [  415.245791] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
> ffff906db7821780
> [  415.245793] RBP: ffff905c96eb4400 R08: 0000000000000000 R09: 
> 0000000000000003
> [  415.245794] R10: ffffb595400d3978 R11: ffff907ffff7ab28 R12: 
> ffff905c9651db38
> [  415.245796] R13: ffff905c96eb4720 R14: ffff905c96eb4700 R15: 
> ffff905c8809a800
> [  415.245797] FS:  0000000000000000(0000) GS:ffff906db7800000(0000) 
> knlGS:0000000000000000
> [  415.245800] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  415.245801] CR2: 0000557484600000 CR3: 00000002f2622002 CR4: 
> 00000000000226f0
> [  415.388491] pm80xx0:: mpi_ssp_completion 1752: status:0x3, tag:0x29b, 
> task:0x00000000bc0fdffa
> 
> 3 - incorrect enumeration
> In this case, only disks from JBOD 1 and 2 are enumerated. The device 
> boots correctly, but the controllers on the JBODs are in an unhealty 
> state and are not forwarding traffic as expected (link LED on A1 to A2 
> is dark, link LED on B2 to B3 is dark).
> 
> System information:
> Linux san1 6.12.12+bpo-amd64 #1 SMP PREEMPT_DYNAMIC Debian 
> 6.12.12-1~bpo12+1 (2025-02-23) x86_64 GNU/Linux
> Kernel config for 6.12.12: https://urldefense.com/v3/__https:// 
> gist.github.com/Nihlus/33ab520b37270ab2d92d2ec26ddfa730__;!! 
> ACWV5N9M2RV99hQ! 
> LI7Pw_xqRwStNn5N13RzQjbL0DOUoI_wA4ekgiNME2kPB9HP8XxGqfNziRzUQVihbHjVCXBjPqYCZQbWshP2GtHZI4Xp$ Kernel config for 6.13.7: https://urldefense.com/v3/__https://gist.github.com/Nihlus/8d1af8204b0e4c456aeb30d079659712__;!!ACWV5N9M2RV99hQ!LI7Pw_xqRwStNn5N13RzQjbL0DOUoI_wA4ekgiNME2kPB9HP8XxGqfNziRzUQVihbHjVCXBjPqYCZQbWshP2GmrYt1VX$
> 

