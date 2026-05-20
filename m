Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EBE23392A
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779253318; cv=fail; b=msTIStNR9PZx9PHSMZJ4tVYYHKxKWiWk1G2x+W4rhTg4R1QXmuTP30F6gmzLfHz9LQA3byHxfl58j4t4SDtQxjcrbv5f5Yf093iFO6LP9WfUFor60S7lNJ/u2WncohQHzSl2TaSLxBg5VQ9DUYY1EE2QQHcASeuY26UEKm8GmYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779253318; c=relaxed/simple;
	bh=jswcu7HhZVkSNstnlN51czUPSDElkuWStbRD9fUuB4E=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bJFk8B8F0DSkx47S1KWxoio3ZMxt9rzIa/WAwEsu4BnEdtImAK3iNASoHjhX5OY1eFHCeDAbgBysynvBSPCDhmMlAOkI4vr7dSrLqCGIx5/A1WsI2U7d1isqPYWtIlwU4EuqSCMLgDUm/p4QdYyxBuSa883zXWDG7y34j/2oCm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tar+/SX3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U3rq+Tq2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tar+/SX3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U3rq+Tq2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K3KLAl3257439;
	Wed, 20 May 2026 05:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=r67mmZPyl97il33iHFM7f+34TCeVcooNwVveRGq5buw=; b=
	Tar+/SX3tEP55CBUG5l3SxgnYpI1SLFjkXYZg2zt+i+dwADe1jfYw76b+r2oDu+D
	ypuUZOE4d14dYtSuHyi1ysJeoDZmvzQ2oeOZlyg4inVdTSPWmxHxQLEt4BpkNd8Y
	RPd01ARP3eG2uOtQDOqgqtbYu3a3JzlIfhGJV8nlqJUQb6H8Pu5Ef6RJWVvNtvGK
	+Qey3co8laG3CsvrHBzIS2TUkzJS0smA6fVv7ShmvI0xliCkl2nvNKu93Lvga8m1
	WCtda99sYNODTq0sLuvywjAzd7iDU32PTRLKINYDeH5eXiKo/uBieQIeyeEmGRVl
	8eBFEJ7dw8GzkTyCd+AcnA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6gyx6arr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 05:01:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64K4slxI025135;
	Wed, 20 May 2026 05:01:53 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e84ed5xst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 05:01:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIS+7Ne5cvK2vO+7fnp7Orj+x2TOnl3MHO0/qGm0fkwoDPKp9eODhyrGEiI7k0oOIJUizRdvXmDQaSJ8ifIGOJxTFO3uaU0e8VPMf1H0s29sr7dwf2fz3y1+m8trdrfZNt9Itsxm/VG/tUSDOvXmQe8lWro0GTqpC1L8WtNqpbBRG/jbHl6it9uNPqpddGPLbTM+L7woZ3gUD6WMfl0E1iQ87vdYpGe//qRpfwEzR3j/FiUb9JhNK7Odddy+XmpJzECfJFpaxuFRHeTuge5ijYc22wQyCdJ+NUBcugxZ387XRC4I0OaZE/jcx+XL9h8E0qMXWCFFsysQ3Lx7i2Ocjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r67mmZPyl97il33iHFM7f+34TCeVcooNwVveRGq5buw=;
 b=UIGl6ODOcLiizYBrFCyHFleCh5Yrbaf/ZP8VbZ+5kcxqU2mzbQJEjIQGYCAtSYTi2v3oNJjROQVtgm/Qs36R2DgYKuhu292cMPsKuy5JtVyC2LncU3fyszBlUvnQprAhPP4UFKGVMk5pJX8Z3RIduaelGT3EyuYwZ00FKiO/XzTjSuaMVBy2gaRWUzK8HyaGaUzDFpAgj0lq9/LFhfHz0AmTy18voc2Twn52CG0xDa4bcYxboaeKy99zAiV2Ve95zUBFREVfaPfyPGzCniK7RvrbTCHU4ZeLHRxBaJgqIH101BDBfuD+97UdVsQ3YBxMm7FTzwh/zzUtO3X+sjhmlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r67mmZPyl97il33iHFM7f+34TCeVcooNwVveRGq5buw=;
 b=U3rq+Tq2yTZ8xC2G1coataAhf+brNxTQxFd0zDmnyrgCv4bBNs1lfkMJtlW8WWO18n66DFCeag+SjtBDg0YVUZyG3yLKkJ801gcHF5bLeYY1TDju06kGs5TvobAZOmI39PjNmNk6LETB0OBiIxlEdhMXsTsmac6H80KPxsQyvSw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB8053.namprd10.prod.outlook.com
 (2603:10b6:8:1f3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 05:01:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Wed, 20 May 2026
 05:01:50 +0000
Message-ID: <65c55bec-dbdb-4ded-a976-8cbcae6630b8@oracle.com>
Date: Wed, 20 May 2026 06:01:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Missing "\n" in sdev_printk() in
 scsi_debug_device_reset()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20260519205356.1040855-1-emilne@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260519205356.1040855-1-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ca15cc-12ed-4417-ac9c-08deb62ce735
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fok51QeeSmCbxum1CwYj9lOwqh0vSIAPRAmocTCy1HGP6ps9L1PCwaxIWCA4T2pHzU5YYVjE9i6AErcSGPOmLsF41Ngz5eIA3RkK63foysa4orKMp23/jry0Gk3y2cXEYrHV6N5iPNQq8rKDspgW9TIqFpsD645fN4vtUUbAxLSnpJA1zo+1P6aGvxd6GLELf9nrpL65P5hPgC+3H9GIb/W5C82s/xTDdRg+FGNIqRXDhF8E+82kJiQKvs5uL875KduYbrXk1a7q4RuaTJNoDvHgP04OX04ZGEDH2/fXL7MVUdVM5TJac+7B2hljAAuP1H7+vhay37VxXcCuOG4wu0EeNRdk+o3nAg57kxVB0mac9GVgzdEwifeI7z48q33xgLirUv1gUf+U34p7MH+b/bflD9HJ8jr8TRTNGLVMiGDyfkL7Uw5jVRWBoRu+CeI2ZPkuceECvrAv0Mpqto/ch85e9r3j2W0bDs1yoTUPywSbNVxHzae6Kbj+ckTPpvLkcT5WKQUrjO8l7mOV0GHY2cAtrEZRQztiU2jEQmD14OAtSZYO5cpcF1pALMC6i8JNALyWB6umx367Wn8Tj8xNea593TYRAGDSyyZ32w+/ZpN04cx0YRBMl8itFODZk+IZuXgdwstNEg9wZafrdjnJEKNvrIHxziDDwcsdUYBElgCDvolJsm/8dOUQgumX0RD8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVRYNmZNT0ZxengzV0N1OTVsb1RoNmJzczQvNThjVUhRUTltaWhrVmRUNUo0?=
 =?utf-8?B?b1p1S3RNbElCeGVOanFBWTJlTlpBaVllcU9SSGJtMWFmNzNZUXhLSWVvZC9R?=
 =?utf-8?B?YTUvSnV1UlNGTGNuZTFkNHF2eUZCSlN5R0FnTVFHaWhBY2RuTzR2ZDR5ZkVv?=
 =?utf-8?B?UUpzQzhXRG5WYkpld0dRdU1odm5XZDVlL0dFL2lwYmNFKys3UURLY0xZZnNI?=
 =?utf-8?B?c1hnbG54SnErbnlzNG5Bd2ZYMnFUcnlaZE9ZYnhudVduTnc3OGw1aHVtVi9W?=
 =?utf-8?B?Y3FlbFR5WE5JZ1h5U1RhM1lWT2c4OURJZWd2NXFRWVRMMmtQZDBnaTZ0Y0ln?=
 =?utf-8?B?RkhlYU9kQ21nck5lL1V6MVBxS3MrUlFURlh5bmxXdmU1VlJmcUJWVVFPMTlW?=
 =?utf-8?B?cHZGWEdNbW9HbDc2NjNhL1lhZ2RnRGhBb2cwOGNIeE1iSjMzckpxUTVVRHQ2?=
 =?utf-8?B?bWtzL3ppcVZQaDNxeFRnZ2kvTXdsUGQ4a0pGT0FMN3JNY3g4MFJDV2RMQzNa?=
 =?utf-8?B?SlErVU5yK00zMmpxMVlyazZUZVg4TTZ3dkZvVEZHeHM3R2s2WDFrWFFjT09K?=
 =?utf-8?B?SVZDZEF1T3Y1amM0WjZiTk1qSy8xeDdDd3BZWUZFMVp0MUt2Rjl4WUFGTVBa?=
 =?utf-8?B?bUt4ZnQxeGZ2WlpJTVM4TWNqQVNVd0syZnVLclYwRGFUVVYyb3E1RUNXTkY2?=
 =?utf-8?B?Y2VJeGZ6MVJEeUhkcE5aZ0Z3YktGVE1xS0ozSWhOV0NXNjRLaVorenp0bHJm?=
 =?utf-8?B?UHFhZ3NLcVlVazlWbDBrUWQwUlkvSmtmaGNiejBRYnd0K3VHYlNRcGpDa2xV?=
 =?utf-8?B?SkIxZVNlM25rQlZRaDhBV2QyanQ2cWVPdVYwdXZ4YUhYRzJlbVlqM0NNek43?=
 =?utf-8?B?b2dSd1hwK0ZOOW56RVlPOVI3cFpRaVJVR09WRnF1QmwwNStDekFvVENOMGZF?=
 =?utf-8?B?eGl2S1FlUkFvMXdwanVyaU1KaklsMUNiRGlKRnlLbjdMU0x3clJTbUlRMUVa?=
 =?utf-8?B?RisrTHpHaFhQaGwrQWdrRFZjME12RXh0YlVLZEpiNEVGNUZIT0U4Qng5K2h5?=
 =?utf-8?B?U3hKV0hoRDRWbm5OVUFrNjZwVHIyVW5OM0tkNTM5YUtDS0V0ZzM3S1JQaVlt?=
 =?utf-8?B?SEd0R1drekdiUXlJYms1ZmpENklQcVF0cisvcTUyZnFzYVdKaERyU280dXBX?=
 =?utf-8?B?S2VnUkVQd2RmNVZramhLL2t6Wkc3bjZMemRDdWtPUzhUdVB3NkZRd1M4Zkxy?=
 =?utf-8?B?K0c3YSs3UVk1SnRRRXhoMWxWQXp0Z3VhY3ltTUFoKzdqVUhobHFMQVpRZkha?=
 =?utf-8?B?WHpxMTBzRS90ODRXNWlMZ0ovRjRuTG11RSs5YTNHT3ZNcEZGNzVwK2tNZnZ3?=
 =?utf-8?B?Q0x3RmNHSklhUHVmSk5BQzA0TWVPQisxeW91eStJRkNxSlo2M01TeVI5b216?=
 =?utf-8?B?T1U2TUwydkhDMU91V3RPTXI2Z2dpRG1Ib3V4QUNMTkluOE9FTmVxWURmTG1u?=
 =?utf-8?B?L051eEVXeWpnNFZZL0ZyaVQ1SWd1Tm1TYkxxaVMwaWM4NHpud21xTTVCUC9M?=
 =?utf-8?B?R2NkT20wdktrRlpVQ3doMWFURHdXNG16ampEd3h4NVpKNnplMy9rejhMVm5p?=
 =?utf-8?B?R29yUlRJb2ljRGdtSzRGcGlzVXJKbTFCUlNqbjVIWjRPeEZDYTJneXc5d1h1?=
 =?utf-8?B?dk1BZ2dlaDUzK0V5L1ZNUnUydFlPYkFzNFZEYTloOVQ3WW5ydjNyWHRTZllH?=
 =?utf-8?B?MCsxckdPRzUyZXFkOXgxb0tXVjNsQUVuTnlUOUlBYTNRcEU5Ris5TmY2V1FV?=
 =?utf-8?B?d3YrU00vemp6eHFicWNZM3dycnNiNlNaYjMwbVlXdS96dEdndTArSk5ITmVm?=
 =?utf-8?B?bWNEcmxKSEREQ2plZ3lrQmdkbTV2UnZLTW1ibjlaRVp0MmsySXZEQkVIcWVi?=
 =?utf-8?B?NWowcklnSTdPREhPcUJDQ2RsNjZQTXpWU2F1bUUwRkt5dEVXWHdHeUdXaGll?=
 =?utf-8?B?aWtCTWNhM3BwTlpsUzNqM1p0dDF1emliTWJsU1dLOVlFQlhCOFcwMzFFSHRk?=
 =?utf-8?B?YjVFa1NhamlEMmt3VGRIQldMYUt6T1ZLRHp0Zi9zSnk1cjFyRkxaaXZrQVd6?=
 =?utf-8?B?dWpmUllWaHE4R00rUGJLQW5tY0lkdFk5NVBIVC82M2RYZTFnU3BNL2JSMDRP?=
 =?utf-8?B?N2pBNStGNk5CVzNxWVltSGNMZnQ3ZW56VU96cVFUb0lJVVBnV0NOTjlNNHRH?=
 =?utf-8?B?TW5WMVEvN3FsZ1Qyd3RDOG9EQjJaTFhISGRENFVsOERuampVT2ViSUlUek82?=
 =?utf-8?B?dmJHdkdIYVNjREdkRG0vRURYd25Qb3J4dGlYSWNoeHRxQ01ac2NWUT09?=
X-Exchange-RoutingPolicyChecked:
	aBleNc8ghDIoDmPhhN58dyiyNVu/5PkDWDcEIJgHnTPSuWTURnNRbAggRVMh00IZ/Ly35uThsGzv0Dt6IiZXYe7Ybvuoub43bhqTtnjCT2CAst7RZxuyP0m+FovvrUngXiPAKNSVPZI7fvKvEi5Mtw16tBIa47uyNlCWijNQXQGhPp5gE02YjsMyDNclIwSDsI8LtV+2Z67znBonT5yhsukNmmz9tSHrbDrhzGBgcqRPJmK4VWeM/rDzARNjnsIU6St6IMjahujR8nopEPlTtujiKGvehrouWtWDV8zeRuxjmU454/eQ7fl3FKJkJHKdkOooo6BXVfB3clIdZkzP5w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l/Ds1bPkc8JKjG8C32fxcXqf6PeNSMIN2MVTXp88oxdm2Rm1aCOIOIzyKGB7NJtO0pgI7jdF5Z8iE4fug1lxv2ORn04nTrAtmzz4CD3QUYTrMpcntjSmzzBP3Gu/Itrtu5+eKwTYHEBWooYvaFnMBEruqAJdX7/06XIcK5XjS/zPPlyIzoAaLdV46uK1i+wnDmidnABYd2JYsecJISfEctHmJpqlx+m6JljRncffaXl5nN7sDClM+wrYT6ess0Ex5M9YSRSdxK2pabnomkKSeqdterdyu3RwI/zyIUuPeO+V30hwmnDl9f7YzwWuDdnU1B+PEITRJCu5R7b2QM9R51KvdzClYGtW8VXfeIxzVMA5w/6mRwbFkjbciEbhemYjBJpj9AkOz53zpDWVbmNVCIDlR5JXo4mYFWSlEn6Y2g9UUnP3qAh28rmInIxUEeZbszEGikfooNdVTRWJOo+pUq8wPgB7YAB+11TwYX4uoIeSzd5XNH7QK/6RAAk9TrZrjig5gb8Y1wmOUGRmbPUc97evyNG6Fo3BIEFJ4vWUeMc7xuKQT5WmMRpHO/Hqgbo9nLOw1ZVmwjQh965Xgi6cXveBNJv+/dWREMBy/qTuSho=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ca15cc-12ed-4417-ac9c-08deb62ce735
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 05:01:50.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCDcznopucF8rRcXwdz+HZvyFGArK/KOAwtfogWWTEKyZBFVC3lPl4xiDZhiXPq3fbKN8kcF7rgfwbUrSUQN4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8053
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605200045
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDA0NSBTYWx0ZWRfX+XYPRfZs9/ug
 9PWRrvoPVBx6cYQshTmQpXgkTFf2vB252bnEdRlFK50Pf6jSCivSYRNi6dHBKGFLIy9/nTmDem4
 TyAO3jxt0Uip0UWXCx3XN/t/RNLI7js7EacwXGMgNClEmFHhKFdzzZgLaaIK/MbYS0WH7X+mV94
 hDfcGRGNmDNLEFRZRSpNq/oXLnHA4t1TNozZpXlCQ/DjGR+lImbOtWoqGtYBzRSSCrV0lRkcA/p
 zd9mlYIlz+Um42utoPuqBdxBy3lyBIfLK9HIYFjrHs4nCE1igFQZm1JLQb1r/6HQtHrnQeBsZqt
 95kBfkqYPyePWbKybOUP6OkNaLgcuFTVv1+aSiP+uN5Pso8ASs7I/bzxAEiCoLFHG2HzT1qVjX/
 5g3q+LHGA6svkYcSYDbYxQXkHYn18OJ08hdeqxq9bnnPh+D/Nxf0I3zpmXVqXDdl1hz2HBByqmX
 nw0zIMkJzWSUNPZCunAFuNyfH+3xpfiniII3M29g=
X-Authority-Analysis: v=2.4 cv=Ls2iDHdc c=1 sm=1 tr=0 ts=6a0d4042 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=B3Qe-ihn8xG2DBF2MJ0A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13839
X-Proofpoint-ORIG-GUID: dlYjUFUNV8tEARGQOACvXiaWOG1F9F6S
X-Proofpoint-GUID: dlYjUFUNV8tEARGQOACvXiaWOG1F9F6S

On 19/05/2026 21:53, Ewan D. Milne wrote:
> A "\n" at the end of the sdev_printk() string appears to have been
> inadvertently removed.  Add it back for correct log message formatting.
> 
> Fixes: a743b120227a ("scsi: scsi_debug: Stop printing extra function name in debug logs")
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Ewan D. Milne<emilne@redhat.com>


Reviewed-by: John Garry <john.g.garry@oracle.com>
