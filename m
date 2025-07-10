Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3621828B7FC;
	Thu, 10 Jul 2025 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752135180; cv=fail; b=f99pyeyw0JJjIpWyvkWm3DAH88TvRwAm4mkNX2itrdB69ggb2C8R8UXKOO24pD0oDqXY1Jz6tv0EbYwsYYXAdC6X3CxeRkgvynHM+shAwmrQRbS3sTXUBEfNYmPOBf6dNgzMhriurZMmnoT0by63eiJi57g5wgSHMaYt8kEAGLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752135180; c=relaxed/simple;
	bh=v0VW76c8flci3jRQo+MHf3DOUdBlwVs4+jax7XsV8Ds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A9D+lxIxXAFzVVJv70stHZUZ8f8xg771x6DlXQ9GKs0uZ8rKtTRQGA0UJQrg0Fdm2+VT6FeF5wQ4V+rXZG2ry7toioH+NUPvsG4fxd1ih6hShv31BSqmLsbaWJK6/yRDAHZkOZ/ae7gd8WHwCvL8umyc8tVn1CUclo+6Aj8VfyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HKZTr2f4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FCDXbiqF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HKZTr2f4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FCDXbiqF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56A7qGZJ001287;
	Thu, 10 Jul 2025 08:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bo7vRhSClAqGqswFvj/xzs6355jewVAMH2hsK8WUV/A=; b=
	HKZTr2f4dKU3LeQNmdSALIw/VHYXCLB9qmPX74lsIOJus2vEVpzsPUyKgoUTD2t4
	W/VsbFtspLdTOGB2drXFNjvhIrF0N7h0vB0dWuerIGoi+fx/VBbvDtYZGcla0e2G
	E6mWmV3G8cK6j9X6DVjX8zrPIlXiLzqm+e+2MBKH2MR7EC+Fa3YxWlSHrQwkzsXI
	RHXzGZYsPT86ssu9ezqqZJos5rnWm9HUaXTzSCNevb7W/7JoD0dm8Qjp6859Ah3u
	XCMULlmxFVplIJ4e2mQw+DczqkO+KNwIJmMhtmrCQyUSpbimXo9i0G4Y7mVUlXmo
	MRkILGs9xncyX1FJ/fU2lw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47t9gkg1cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 08:12:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56A6qC3N014040;
	Thu, 10 Jul 2025 08:12:44 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgbyw07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 08:12:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2zcjd9dAH0tIKc5xaDnuJCydFz7lIecHuwofh8NajG09EJa+IJtx0RF1MfpMbCT85GLk7OBTGZ/tU/hC2pEbPcgzZLHkhhP7toNfTqxV50ubyItqTdQts0EZKqCSTt0ikK1ktLTgxo3Em045vBtxCv2nYuOV39eLJNiLYYbxAR6ZFHzWp8kb1CuCcPZ4TovIighBvjpYCjTkQRnKCZq8GKwDBXOUKYDjNPHf1RaUM0MAsuvl+UmZ9adsQuatxq0oO0n/o+T6CdgjmKVkv06AgjASo7dxDGkpoYsVD70nZqHjkIziKL+t+cdRdFnkYhGiLh+HG2y0ZgAEQGsLZti4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bo7vRhSClAqGqswFvj/xzs6355jewVAMH2hsK8WUV/A=;
 b=hX+lz4oxKm1qa7PXgQ7mKeJFtproBYz4XEFIifUAN8sDvvPuYIx6xkZaO15TxzuXVvz/uXAo6niWDQzkA5jd9SEeJZex96PtI2gIsOimobjgkJlFgUu+OJqMSvbUI7RZAEiVapHyb9qVkeiYd1DDdGfdp0WOxbWYGy1M9EYlZZ1b0m3N3FeDg86PPkVVU8Guo8HKAPwe8HQgsjrLHvC7K/icPZ3kvPjWbA9YqKO9b6InO0OCqxq8YWbvB9zJKIvpzYeSV/v0PI6fKm9oeuiMrTdOq/vf4WPHiWubiS5eskM30bWMPo5zBdO9qNn9ARzm/HSzXfZ1wXeKpSAl373Geg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bo7vRhSClAqGqswFvj/xzs6355jewVAMH2hsK8WUV/A=;
 b=FCDXbiqFY6MkXpd1qMqCbLNU+2Jg4uVJi2H/ZhyQN17TdE6cw/J7jT+Y3bk9eaekhFoarxhU9MANtcopHJa935QzqNoG18A5TLsftj6/JJtqG4iUJHIqcgAQMdpPwj7mAQ6iDKEsJbHcDCaZt7kNYW+rsxQ1Y5mhqvByZAOABeA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CY5PR10MB5940.namprd10.prod.outlook.com (2603:10b6:930:2b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Thu, 10 Jul
 2025 08:12:41 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 08:12:41 +0000
Message-ID: <ce2ccc7d-143b-4c9f-99c6-05d68166e9b4@oracle.com>
Date: Thu, 10 Jul 2025 09:12:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: aacraid: Fix reply queue mapping to CPUs based
 on IRQ affinity
To: Sagar.Biradar@microchip.com, jmeneghi@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, aacraid@microsemi.com, corbet@lwn.net,
        hch@lst.de, dwagner@suse.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, thenzl@redhat.com,
        Scott.Benesh@microchip.com, Don.Brace@microchip.com,
        Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com,
        mpatalan@redhat.com, Raja.VS@microchip.com
References: <20250618192427.3845724-1-jmeneghi@redhat.com>
 <682ff953-9130-4920-a9f2-88dfd6718be1@oracle.com>
 <PH7PR11MB75708E49B0C0714421E2812FFA48A@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH7PR11MB75708E49B0C0714421E2812FFA48A@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR10CA0021.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CY5PR10MB5940:EE_
X-MS-Office365-Filtering-Correlation-Id: 4deac18d-21c2-4fb8-6c39-08ddbf898a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEwrQjdSVnVIRFhEUFhJcnNRU1pXSm9xeldyNjFiaSt6MzZPMTgwL2JkY01J?=
 =?utf-8?B?dzVXNmxIS0xRaDdFV0lUVmdRQTNxWVRTeGJWemo0WUdTUTZJcW9YKzZvZnZI?=
 =?utf-8?B?dmpsRFQ0U05CQnU1anUyUGRJaFRicTJPb3Ztemxpbm5Fd212TXFiRk5Mbm8w?=
 =?utf-8?B?Um5PQWYrRHRqQzk0WlpHZGJWR3dsZytkRzZpMzNtTzBDUFhKOS95RVlCWnlH?=
 =?utf-8?B?UndkRVlpZG5OMDRINGVBeEJVdXJIS2w1T1V5QjJWL2pGWkRleU1LdnZlWVFa?=
 =?utf-8?B?ZldUZHR3SXUrREVNMG9MSHFuRGtpWXNyakNrVnM0NmIzQlA3UGZKTkVEZVls?=
 =?utf-8?B?TmxuUFJmYVNWMkJBbDV6OTN5Q3hvdm9JUXhyZG5yOVYwZTJOTStqemY4aTM0?=
 =?utf-8?B?TjQvMWt4c3pUT1BxVkpNOFNYbWx3aGZDVU9icDZTOWh4K29KUmRva25yUTNw?=
 =?utf-8?B?bHd3bjkyOG5kbERSOUp6VGVXTWJucTV1TithSlNibllNTnVpNUJaemVjZUNj?=
 =?utf-8?B?V3hIWUVyc1ZrWFZRSWFZdGRCWkpCb0F1cjd0cUJvOVltRlMybFVCTlpjcGtt?=
 =?utf-8?B?eFVqZTE0a1ZaRnk4Tlc0WUdUd3N2NzE0UE5iNU1EOVFhL2Vkd3ZLTjV5SWl5?=
 =?utf-8?B?WVRHSUxWVnkxTEx6clFYbnZkOG4xOVlicjhmaFdlL3REUnRwVmkxdW5TRGVi?=
 =?utf-8?B?eks2NDh3M1p1ZDZ3dk5TTncwSkZtNGJBN1RMU3JkQWlxaWswVGdWNVc1Wkt5?=
 =?utf-8?B?ZTdNUFQwZWpZOER2YkRiK2NpcSsvVzNYTXVJcEY3S2VoZG9UcnV5YW53UnZD?=
 =?utf-8?B?a0thQXJaVnE0S2NhK0F5WmlwMFl6dUdoN2Q1ZjBXbVU1OUx0d2VrbWdnUTQ1?=
 =?utf-8?B?Y2RsRVNTWEtzSDBPMTZnWFJCdlVmazR4aVpyaUxKdTJTU1JPYjdTaTZoNlJC?=
 =?utf-8?B?YzB1VkFibjNjVEl5S1Z3REFsWGhsdjlvQkx1cVNJTEMvN1RSM2xrNnFPMHdN?=
 =?utf-8?B?MzYzVnRCWUgvaHdzNmJnbTBHZ0FSNzFTemVYS2hVdndCMlMrTDJnLzY2Wkdj?=
 =?utf-8?B?Z20yQjdFSnNQRmZwdWZQMndSQXJ2VHBRL3EzZDkxNzVRZHk3QUU4RHFPTXdW?=
 =?utf-8?B?UVlGRmZiTXd4N1pZUU9sVW9jVG54ZXZKZ0tzdUE1aHpDSjNlTTR6dUgzOU1D?=
 =?utf-8?B?L2ppcFZzMHVXWnpnSFE3QVlld2tzR21Fbld5czR4azczbURvU3FWOVc3d1pB?=
 =?utf-8?B?eGlqZHMvc0xCejhNWTVhWUxmcksvYmoyUGdHbFdMcHBNZnpjZFlrUlZUSWpo?=
 =?utf-8?B?QndmUnp5c21LV2UzZDdSc09FSGFtNDhvaWNoZUVRZ1J3ZUdtclBSNGwzMEsw?=
 =?utf-8?B?OVd1SER0a3oyWlF5dm5kSi91bDlqdmJNZXl0VDV0ZlRDNVVSakRhaWp6NGZJ?=
 =?utf-8?B?QjZRaWgzZG55ZGxpYXVwb1FOdlAvTit2UEpJcyt4RjgvL1lNOUdnWDMwZXdK?=
 =?utf-8?B?Z3lFU2M5K0JQNE02RjBLV2Q5aDZJdnExVEsvRmZkRk9qaG9yemZScy9kR0Fu?=
 =?utf-8?B?SVROTkY5aUJpMGRCc2pSb0pYTFJ0UXFFcGJ0MFNsWWU5QmEyVWxUS3huUk43?=
 =?utf-8?B?K1pqK0o5ZDhhbTNENWpWSWt6UHFFUnc0WXAweTJBMFY1dHpSaTFuZ2hrQjdW?=
 =?utf-8?B?cjZKVEtXbDVSVXBWN2xsMlpBQy9LRmNocERLV2wzY2RFMUFXMmlhZEtEOVBn?=
 =?utf-8?B?OWJqcDBsZU0vcHhldytIektCaG03dW9JRUlXb2hhSy96S3VyOHdqRlBLV1or?=
 =?utf-8?B?bW1QSUtsK2phM09qUFJiK2VqaC9MNHEvUllTUWs0NmR4aHJRdG9LbHN2b1lY?=
 =?utf-8?B?MGpmRndDaUpqQ0Jraml5STF6OEZXcisxdExyRlZIRTVFcnlmMUpHbHk1VStj?=
 =?utf-8?Q?EIs19b/kkWA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1hLc2FpZWIvTlc2VUcvZWFtUi9haFUzNDRJbnJvV1JSTk1uNlFrZmRKeFJE?=
 =?utf-8?B?c3J6OVJqbGNhaG4xYnhkeWdEUXNXRFlTS08rd1YvUC8rT2wvOEFJUlJnRFVv?=
 =?utf-8?B?bWMvTXFwcjl3eDk0aXA3aDdRMjhvUkl2bUQ0R1dlRzFoNnhteFhBdWVMYytq?=
 =?utf-8?B?NEdhWnFUZ2dlU3VkeGRVeHErTFMrd21ybU55RERPeXZGWitiM3oza0hoblJ3?=
 =?utf-8?B?c1NPYkVQR1NFYXFGUklMWWNoSmJ2RXVqaEs0eFJ6SXZMMmQyOUJybyt0WlND?=
 =?utf-8?B?aG80eG56QzVJMDRzVEwwUUpvR01zRjVaYjRHZXlEMFFpVWFENTVZZUMyOU5I?=
 =?utf-8?B?SlRUSDBZQ0ViUkVFQ0RXVmg1M2FpSDBSZVpYOTRnbzJCYXhXdnFaMU9jemZv?=
 =?utf-8?B?K3F2NnBzdFpjMTlXUVc4ek5odnptQm5lblpRN24ycjlhSGlhQTQ3UGRnWmdT?=
 =?utf-8?B?b1ZOVkduTnB4TXNKMlErODVVWFdWSS9pWmdFMUpjVEhaOExJaG9tcVF0ZUpL?=
 =?utf-8?B?SDA0elMxN0NZNFNyemZhYmFxWmtkYldVYXE1S0hXeXFOMElKbldFT0hHWG1C?=
 =?utf-8?B?YnROcEVieTV1K2tQRzE0dC90Ukw2MEMyRkFzWnp2WVF4RVdIQUpnNFZ6VWhP?=
 =?utf-8?B?dzROc1A2OXJhZ3NqVFlaOG1nc3NSc1BLOXd5dHA5R0RrbmNwdzZRRTQvbzhK?=
 =?utf-8?B?MWR1bVdzQzd6TDI3OXhsRG9rUGc5UDlWd29IeDBpaUZSWHZFQ2JZVFZxZU4v?=
 =?utf-8?B?NG42dXZQOEtsdjJsWmMyaVREYlBoUzJhYzBzU20yaFNicVAvV3R4NUNmZjZo?=
 =?utf-8?B?aHRYUTFyR1dkYmN0U244WXJNVVF6MjBzZnAxaGI0UnR5OHArc0JlYldIYzRU?=
 =?utf-8?B?RjAvNnZrc2JlY0czQkJDcG5XTkxtV0prcE9PakhUUTdOalBUQTQxb2NGUllF?=
 =?utf-8?B?MXZ3Z05FTTdUUGpoYXNibjJER2NiRTV1dHVqWFdsZW9JNUIrTUtPQldzVUUv?=
 =?utf-8?B?bXQ4Y2ZEdXJzeEg5SHhwTTZPL2Q0WGFaT2dRck1vcjR4RnlVbWdFRUlndmU0?=
 =?utf-8?B?TGhla3I3SkxTWjRyTGxuVlRteVhqekJxNzZKZFg0OVZZOGY5VWJhQkowR05n?=
 =?utf-8?B?MklveG9JcTRyYk4rUVFuZHNEWWE4WTJSV0tRdHdOdzc4TDErWnYwdnd6bDVu?=
 =?utf-8?B?YkkzblFSRVQ3UlBhYW9NbDRmREMxQnNFcHBVbitOandERkpTcVpGNzZzOGJa?=
 =?utf-8?B?VUszbkRTQ3lkTzd3eFJXelRmMTdEWUh0RnB0RnhwTkNsampCb1R2RFM5Qnkw?=
 =?utf-8?B?WmNQZW9oRVBPVjl1M3FEU0xrQ3dtMU1qNUZHeHQ5UHd1WURWTGNoYjZaYmpa?=
 =?utf-8?B?UUd4Q2RUZDg3R25xbmFad2w0NzFMa2MxTDh2VGd5VHBnUUZWajNRa1M4SVZs?=
 =?utf-8?B?b0lsZDh6UENTSXZVb21MZ0dadXhqWVpyVUlLOG82TitoUis4MG1WUkJSaGhP?=
 =?utf-8?B?Q0JaWUJPNUxranhwUGVMRXM1Z2FQN0xUU2N0MmFRaWNGNWtRMVR1RU05MEc2?=
 =?utf-8?B?U21LZmEwWk9lL2tVaGkvRitFVU1TNkNTOWk0MVNlR2RVOHdZSDJSNXhBUEdE?=
 =?utf-8?B?SENDQS8zVmc2VkN6emxqalNJaGVWZFhFdU5ycERXb0pmRnVXK1NDdGxYUEd2?=
 =?utf-8?B?NEdtTDlpUFB6SCtxNG1waExzTjRDOThaWW9NVjFva2RKWEZVMXFnY2d0OUtY?=
 =?utf-8?B?STJoQlRNRmxDUklxS0NyakpEZjgxQmNDQ3BCZENIZzR1eHluQ0VHNkFUdWs3?=
 =?utf-8?B?cnE1eUQrVHhnOEFOZkhhZ1hGTFp6dG8xWmtMK1p0L2V6YnoyNXp5bTlYdDdF?=
 =?utf-8?B?VlJzaHZyVHlXbm9UL1liMHZlRmFMWnp3LzBnMnlHcG43WkZCZUpSdFVzc1Rn?=
 =?utf-8?B?NUJSaXN1ODVIYnh1S2hhRkdqTUZvUFRVUHVXTzJLdjRlQjBNS2pscXh5Tmk3?=
 =?utf-8?B?QnJIWXdTSGJINlZ6MmZBTW9SblpBK2w4Yk1oSmNNZEpLOEVFdEJVUmhGRU1U?=
 =?utf-8?B?WEc3dVY3a0VzcjlZUU10OGEwdXd2R2dmZmlJZ2tuOFBPdVYyQXYrZ1B2Wm9w?=
 =?utf-8?B?aDBPS0NhRFd0R2NqOFp4dlFabE82eSswR0N0ejI2NW1mdkxCV3ZrNFliaGNv?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c46e91Jp3UsMQtEjDycZwfJziTIe/xnQO9pYCSz90uteIFxj55ZdFUw7f+5bvTtIb5m/5UKmk56JXuK2TynCGvykxMZHqO4ktLOkCfHHpdhxkuhQCqFG8pzrpVp/I2ChxSXlXKltbxJwMS94wB7uT3Q8oaXItY7xbo9g6xM4PJVEXxeBFFSmb8bHybS+icKlk2bisen9PHOrvbzD6rbNZzBse4EOie5CVfslpqEPeWFGnMg+6ZBIl62u+vjxyv/Eey4sv3cJxvbmXUUQau7zKaQzP4DuqsnkDz6EG3mFdgllyK4PpnqvgwlUVyi1RGrDACGmF/C5/KGJkDkRByew69b8dCIoXzbQPQe699sbJuJ2rTxdMCf2REv+gf3vewisKfaXPjjDqSs8g8GtNzHPYWjgdAsLDpW8i/7U7b3757YEfIhXvU9USQppTkYYbHYkuI+rS2vnJiT6xM99t3Olk8ZTEUD5wmnHiEr4BWbDv6VoAZpL3OAamvdQFikBAhubf2RS7uhk5nWNo5bU9JhZy1yzpM0HqZNQr6srOZRou6vyCLidSHqHqLJOZM6o6ycH63Z0OJigLK1OHcgorYEUD5hcJwIbhvUFvLCMsajP8r4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4deac18d-21c2-4fb8-6c39-08ddbf898a72
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 08:12:41.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEQYvx9nIkRphrFAreUdOYYoRoKZid/F2LBKWxpPxKUwhd9dEZDCRr6lFEd3SRGKwVhaPuiMx8RZtarW6aOQVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_01,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507100069
X-Proofpoint-ORIG-GUID: xFCRhuftuCPhxWtwks9JZghE0EXmvqIq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDA3MCBTYWx0ZWRfX2GtudKzrUF2l PpCqWim4vK9pxlHcJNGS270IZNUKBmnR1tBXx9i+M0exp8FP4VnvRf7yUfoWIHhlilb6otiiaBa UJUjtoxN8iLnK7mPcY1J9OkP9AH/WXSTJIFu0yU65kDXnZZo+RaECLCmXzSENbnukzIb8o7RE81
 O6/bSdyCe6Q1CxnKqZet6bPjMNsPYE+ssqH1QXrjB+1SoxkEOa2PjcQwXhGXhQXV0SLtYbJiNKq 8m+faXiwZ7HFFQxIbsuEI2nyZHGadttZr0TCCt2VniIr+tXiGJnR4zLw73odql1k8/32W5q6+28 F/4thPfmqXnVsZBQCIOG95ZKmevqCJPDG1LecbJN2uTjMzPYHElMbHpr8+YXqJEaD3C32InfmtO
 kB2xvrChkil0zUDGlnM+dvfxeHT4iA6wBtDkS/ERKYs009ZxSHXSt8eirhafCudlBR4zW88z
X-Authority-Analysis: v=2.4 cv=AYixH2XG c=1 sm=1 tr=0 ts=686f75fd b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=XYAwZIGsAAAA:8 a=l4q3bOOOhi2BQ4WH2nIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=E8ToXWR_bxluHZ7gmE-Z:22 cc=ntf awl=host:12058
X-Proofpoint-GUID: xFCRhuftuCPhxWtwks9JZghE0EXmvqIq

On 10/07/2025 07:49, Sagar.Biradar@microchip.com wrote:

+ Daniel, hch

>>> This patch fixes a bug in the original path that caused I/O hangs. The
>>> I/O hangs were because of an MSIx vector not having a mapped online CPU
>>> upon receiving completion.
>>>
>>> This patch enables Multi-Q support in the aacriad driver. Multi-Q support
>>> in the driver is needed to support CPU offlining.
>> I assume that you mean "safe" CPU offlining.
>>
>> It seems to me that in all cases we use queue interrupt affinity
>> spreading and managed interrupts for MSIX, right?
>>
>> See aac_define_int_mode() -> pci_alloc_irq_vectors(..., PCI_IRQ_MSIX |
>> PCI_IRQ_AFFINITY);
>>
>> But then for this non- Multi-Q support, the queue seems to be chosen
>> based on a round-robin approach in the driver. That round-robin comes
>> from how fib.vector_no is assigned in aac_fib_vector_assign(). If this
>> is the case, then why are managed interrupts being used for this non-
>> Multi-Q support at all?
>>
>> I may be wrong about this. That driver is hard to understand with so
>> many knobs.
>>
> 
> Thank you very much for raising this — you're right that using PCI_IRQ_AFFINITY in non-MultiQ mode doesn’t offer real value,
 > since the driver doesn’t utilize the affinity mapping.> That said, 
the current implementation is functionally correct and consistent with 
the driver’s historical behavior.

For some time now this driver has been having issues in this area, so it 
is strange to say that behavior is correct.

Indeed, this patch is trying to fix the broken behaviour Re. CPU 
hotplug, right?

> To keep the patch focused and avoid scope creep, I’d prefer to leave the affinity flag logic as is for now.

To me, first it would be good to stop using PCI_IRQ_AFFINITY - that 
should fix any broken behaviour regarding CPU hotplug.

Then, if you still want to use PCI_IRQ_AFFINITY, then do it like it is 
done in this patch.

> 
> I’d be happy to follow up with a small cleanup patch, sometime in future, to improve this if you think it would help.

Daniel (cc'ed) is working on a method to isolate CPUs so that CPUs using 
for queue mapping can be configured for tuning performance, so that you 
don't need Kconfig options like in this patch.
