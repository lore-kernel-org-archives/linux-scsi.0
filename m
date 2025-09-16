Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AF018DF9D
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 09:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758015214; cv=fail; b=C3xOa4iAG7U1cV+at67OmVA/Tr+ZZ9XWrSeSeWbdMKQyG9fBoPySUvwgC1nXSxq6aW7rfB0zMX7ZP1ni8UDtdfAKrpoxVtwFJLuaBGWze/29gngxrskv0H/eJ0w22YLozYLFpKy3J6dpvE1WrvipBwSe116EdA0gSq8td5mYvVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758015214; c=relaxed/simple;
	bh=2xrcRtNHqEmz5TXto21YPMZo7UslOmhLMUouGZuln60=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cmb3XPr9QGwyu+/THIqjRlPmY6dhMH+Ck3SlVEj69YEqY75bkcXkSOsybhcHDVuYpMt3nYhhmpB4SjhdnZMh9MHu1LMJzOm3PPzAM8Uz7+Bh53YynKvOdUYm9/BivNyJZta7oru9dKh4uKOHihembHvxYrjl5JbYApbhrg1ZJ3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nVTg1Ga4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QomPyJ1w; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nVTg1Ga4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QomPyJ1w"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1g6Ds022239;
	Tue, 16 Sep 2025 09:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7AJW0ThJqnp5m69xpEUlRJcf+KLluMnvPWRoqIKqMOM=; b=
	nVTg1Ga42vIMxKAUsgiKGDsgjDsAPd8J2SbL9FQtZ03dQKUlrNS3M/q1a6AIcb37
	Tvt9rBuyic/3ll4OaM4AWH+PxAL8M/QKfDrgj+RTomqPycXk8jno/68mLKzyKsTL
	pmvxDW8QS9t3BLfxrkUJuZMwzKTNo65lBI3oSxI2lCBTUycWXHcn6ycQBXmrt9U4
	FP8GQseBhXksIK5Yzh05C4HxbAjvjlyIYqi4W4xgBNZ6R8cc3v4aMr14oc/jh3KO
	+3L13fhkYRx6nUZjbBipn+YV1Did53ntKdQkDYAM6haXajIGYRuE0OlmzvPia2X6
	IcGjuHGsxonk1i5tL/Djdw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yd8m9es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:33:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G7ArT0001717;
	Tue, 16 Sep 2025 09:33:20 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010065.outbound.protection.outlook.com [52.101.201.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ccuwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5BwapzfqHY9KqxFBzJVj6o5+bGEpOop/7jX+/lChmenLf6NAx0Ffch0iB2K0DsgMCearpZKxn7b8hjamqcij96v6OeG1QTAg+34CQgsFwMbqf/zBmwOAy6YQVtO0oLr1xMOUuVqmq3s9zjxuq98uUgAEBOIkOG63RYAqfpCQa66SwRi+OPCcCPRAc2meS1e3+84KiwjjQ8WgARhhuNsBUx+anhXzJ1aTWWmWGjWQpNtd6Wz12KJqCQcnayeQrJ9KzPU//COQDK72+C4DzcK90pQdDHbK+x5lyhcUVZR3uxoFiDQCmVUjw0vg5niVO0X8DKRO4ms+XFqjikoAI80Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AJW0ThJqnp5m69xpEUlRJcf+KLluMnvPWRoqIKqMOM=;
 b=dVot3vmE2doA8u4dCYSYh0oLcLT123UITnhXbijtYJwNxrJkdk5gCkAt7Y9nU1oE5w9Ay9G8R2k9KmpLhe+8AZjB7BZv5Zd0eWwVP67E1GzHOK2qdagCPx18hhvCQCzLzHmhtHj1coOMQ8ChpLD4TWP9G7ngVkb0rbiBKhlzchCcXH3ba0V5RDZEt5LfRum9TF5Mu/U6X4vc7mJo8vq9EHTjVR5ej3IwX061nZU98elStwZZfH09IzMgEJbNN7ZWvZzDKtqqHQ5brB40ngyEjNQeQpGOcRRSS3G4C2Y6hIIDTTi/olr+5vg0Co+tqRrLOGTtnGk8nNsr6nI78zvisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AJW0ThJqnp5m69xpEUlRJcf+KLluMnvPWRoqIKqMOM=;
 b=QomPyJ1w7LrjWCOBPRuQFu+IiqZjDLlHAHlXxr185IFpq/klPwVRippySx1tUoA9bW3fEgDPKYEVFrrbFdtgRdGZ5auH8bwK//eWGk90TzD4vJel7LozMdu64ag+UjcpkohzPrtdY5CS5GI5zNG6qFFdSW0dlGgunw4Fdo0Ijd0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB4448.namprd10.prod.outlook.com (2603:10b6:a03:2ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 09:33:17 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 09:33:17 +0000
Message-ID: <279e5b3d-bd2e-468d-80f8-99a63c2a8edb@oracle.com>
Date: Tue, 16 Sep 2025 10:33:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/29] scsi: core: Introduce .queue_reserved_command()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-6-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250912182340.3487688-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0229.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB4448:EE_
X-MS-Office365-Filtering-Correlation-Id: d9d010cb-6897-4b44-0fde-08ddf50410cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHRDaTR0K1VZWlM5SjBPQjBFLzE0UThGMzV0YlVsekloWGVKVDlpTmg4aTYx?=
 =?utf-8?B?aFZaODJjcW9mekZ4QmltU2RUZG5MOHVCeGZmYmJSTW5yN01HNXRzVDhUL1hP?=
 =?utf-8?B?OU1ZNDhnWHFrWTFHZWpSZzlpTnYxMDNkM0hLcHVKcTcwaVMwU2hsRXNWT1BR?=
 =?utf-8?B?c3ZTd1RIQnZjQ2JBY203eCtTWUlPVXFjK2dBSmxwL1NCeG1lRHVKVFdYUUxZ?=
 =?utf-8?B?UVRTaWhtMml1NWRnSFZwYXo4Y1MwYmRUaHZyWHlCUEZTU1Bpa3QwSXlDTDRX?=
 =?utf-8?B?MHlrekNRRkRzSDdaa1JoS1hwRnVhckQxVWx4eEpwVHdDM3FBMW9QOUpiL2tK?=
 =?utf-8?B?dkhjb3BHcmdXdkUrdXBkYW1WQ0RaR1hUNCtXa1h6UTQvVmZLZ2ZDMlZiMG9L?=
 =?utf-8?B?d0V0R1lSNFp6dVdqbEs2ekcvbkxYVFc5WXZBbVFORXhRQjRYOVVyUjhnbHBP?=
 =?utf-8?B?dE15UWJzVmxRTklIeGlzVWozUC9Na0NGNllpT1FtcjB2VFpTZUNxVXl2VHZH?=
 =?utf-8?B?VVIwMTNlZUJlM2RFYitnL21Gc2R0eG9SS3MwdHo5UGc1WUg5djVKaThOYkti?=
 =?utf-8?B?SkU5eUM1NEVBUmhpOGNsTGhLVXpHR3daeEdYZXFiYlFJc2g4Rmg4ZERwZER5?=
 =?utf-8?B?YVI4eFJNckphRkVqeGw2d01leUFLUUJ1a09KUnpIb3dreFV4SzVWalVqM0tI?=
 =?utf-8?B?Yk1KcWdWMVVVTXpSaWF5SEd4Q0ZzdjYrQkNXbERWSWdtLy9TWC9WSHdSVlZF?=
 =?utf-8?B?Qk1BNHBENkRQWGtaKzZCQkg0MWpzWUdTaEdZZEZzZWE2WnlxQmoyY2tOWmps?=
 =?utf-8?B?M0d1STJCUkJPOXZTbFNhTDJLZ2czR1lqd1Q2c2x4NkM0U2JRWWYzZG5HSGFN?=
 =?utf-8?B?Q1dKcXloR0FqdWlZaEttWFNVd0tJMUttQk5mNFhTNVI5WENtbFg3NDJEVlpj?=
 =?utf-8?B?TVJYVURXYURubmFPa0V2OHh1T1YwSFA1TEZhSnJVUDVsVUdGRjYwUE04UUxp?=
 =?utf-8?B?MlFLclROTFlZRmpaSHR3WUN3a2F0YmllZkVUNmVHMWJCc0NBNHp3Tkc0VnhP?=
 =?utf-8?B?RWRDWFpiUnFXeEZ1V08wUkVkVlVGKzVSSlJBNEJVL042a2lFNU5NNG5teWVi?=
 =?utf-8?B?anBWQVdQKzV1M3RoOVZZa1hFNDUzckhDL2NrclBEL0NLdGRtTE1GZW1lcnZq?=
 =?utf-8?B?U1U0S0VEdHB5cTdnaGg5ZHNYczB2TjQyQVZ0cG1UcU1ZZG81QVpwaUNpRmNz?=
 =?utf-8?B?bXM2UHB0TXBYSWtlRm50dEhZNVZRV04vbURiQ0FrVGpHdEdrUEl1Q1hDNE5q?=
 =?utf-8?B?dzUzUU5NL3dsek80M1JhQkgzOHIwdWd6Qm5Iem5ma2luY2xPZ3JISEJDaHJZ?=
 =?utf-8?B?ejlHMTd3WUE5ZVVHQ2hGVUpvV1czRVVFTmtpaHMzVFVvWUNBVDVuNXdiU1dL?=
 =?utf-8?B?TnRObDlKVnZwSk1PeTVGMlZiZkc1SVFFOStLUXBnbzlZTFo3SWJheG00YTNu?=
 =?utf-8?B?SlpyRkNrTDUxei9PYWJMQW00QUZOK3RIVit3SVIrSUdPVnNUQ0FWUUNaWnFQ?=
 =?utf-8?B?TmM0a01yb3p6WkRmTXo5MkswNWlveW9SVGlBOS9FcnlCU1NRUE1aSDJlSHB2?=
 =?utf-8?B?c2UxbXZNZkQ4TUdNQ3NLeHRheEFOallCaWFjbHdTOG9wV2pBZnVOenFXWnVt?=
 =?utf-8?B?cTlLUjAvNDZZNCsrTHhCdmtLREF6N09FaXM3VGRKVWhxYytqcDZUSUF0Z3FP?=
 =?utf-8?B?VUtCTXVYbjQyeGdkSStlK0Nqc21MczIraisrMkwyb2txWnEraGJtUUpBRExm?=
 =?utf-8?B?V1NiT1lJY2xTclVkSGxHellJYm5yb0FUaUVHRWN2eVhTVGswNzJEOHpGMUFH?=
 =?utf-8?B?VG9JeVdWbzZHMTM5ME0xVS8ySlg0VVo0MTROck5VU1dGQnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUxhT3A2RnZrVXNtUlc5QXo4UVNqZzA2SU5TSEIrYU1SNkhFUWRCTzk2WHFx?=
 =?utf-8?B?bVhvSi9zK1NJdEVnSXRSWjJqbnZwa0RwTCt5OHhoL0djQlVDd0xHNE5uS1Fk?=
 =?utf-8?B?ekpVVVRCV215MitqSlpRN25WajFPeGVNa0hhTVVYSmRBUXFnWFFXVTNPcGpW?=
 =?utf-8?B?S2ZQYkwvM25Mc0lxd0tjNVBTc2dTY1ppZ2VqVWxnQitJV0pxZjdyT05NaGIv?=
 =?utf-8?B?cVlUWlJQOEExL1NoSWRwWlRsV3g5NzVpMldMYmdCU3pjd1pZVDNLaDJtMXEv?=
 =?utf-8?B?R1dLZDZQRktOR2pUUzdvWCtLeWdieWprU045K3lubmtRVWZEc1RhRndVcmdY?=
 =?utf-8?B?bVdmVTU4T0NsUE14NnczSWszV3FOWXFTWUxsZG05MFJzMWVURzVnc2w5enAw?=
 =?utf-8?B?MDhtNWx2dzREcFNOaGZiclpkdjNkUFNQR3hVL3ArWlh1bFp1N0N5RThIU21F?=
 =?utf-8?B?cTgrV0grS3Q2b3FrWkkyRFhGUG94Y1VEbnJuK1JTSGNxNnlMcWVJQnVCZTJH?=
 =?utf-8?B?Wm94UTNlUDh5anJOVldwVXh5ZGFxZXhQaVBRK1pHM01mR2hkRG5uREgydjBN?=
 =?utf-8?B?ODhveVo2VWJKeW1yazUwS1BBRml6R2t2VDMvWXlvV0xBaDRTcXQ4L0FxcGY0?=
 =?utf-8?B?RTZhSS9Ta3NVZ09GdEpJQ1JqYTVuMkJjSjE0aWVBZHFsY3p0cUIyWmpoajRu?=
 =?utf-8?B?aVlUVFZaWG5wb2dxbThMaTFKai9GeWRDTjgvTkNIcis4aUdGaXNSeHJWNEpF?=
 =?utf-8?B?bGQ1WUpyeWs3dDFDQThhYUQ5Z3IzOUxqZzF6TmFMcXNaa0dvR2lNdklZYmps?=
 =?utf-8?B?bnh0SDQ5TU5jQnhONU5qcktSZlM0SmZEbTVraXlTcjF5bDkyT1p2ZXk2ZWNM?=
 =?utf-8?B?TWpXdWNVMFdoaDBkY0FGWktXTEVMeXlFQjFDaU5Oa083dEZiNExGUmRmWHgr?=
 =?utf-8?B?YWNGMDdnS2FpdDB0YVcxdDkvRU9FNHh6TlV6dStGUmM1NlpyWUFjWWN3aVZL?=
 =?utf-8?B?aGl6SjZpejlOWDZrZVhKdkFGcGd4Q0NlZ08rVS9VT0NuTWtHdFEyOCt6MjJm?=
 =?utf-8?B?WDVtbStGY0ZRekJrZDVMSVlCeTlRbUZPcDNzWVVhSlllQUhXUk9FNVY0UlVZ?=
 =?utf-8?B?L1pBMzdGelBkYVUyRmNBaEEzODA2amlZNmI3WityNTVERFZlWXN5NXlJclht?=
 =?utf-8?B?QjlMWG9VMDgyZEhuQ1M4OW1ySnpJYmxBTTNEOHlTWWN3akNod3YvcEsxOVFr?=
 =?utf-8?B?NUR4K0x4NmlsYzQ4YzBVYXE4Vk9YVzVLcWVMeTI0TG5vcWVIUTFYWWdQcytl?=
 =?utf-8?B?Q1pqOVJqYnZsOVFlTVVqeGxLWDNZalZaMTdhSFFDZmliTlE1aTRLVUhGcDd2?=
 =?utf-8?B?akRYaVhndDR0WUtPYURFaHdSQ2xUY0lMM0hCU08yQWZ4eTA2c0xqMDZqeEh4?=
 =?utf-8?B?clBKS0QrMVIyRzFubXhHbXpQWllrM3psbHcycHlnVk1iRzBFbGxseVlHYkZy?=
 =?utf-8?B?eStKdkRGWmFyQW5ORS8ycXpRSklobzRpREptVDE4R0ZVZ1Zuck5FS2NwTWd4?=
 =?utf-8?B?cGJRV2dEbmJaZVE1L0VXNzNzSVk5SmNUNWZtU2hMa1FHM2k1LzBDQkpnMXhx?=
 =?utf-8?B?cGlWbkRJcUJZbmZxbjBKcnZ1N1pxUktLSXlxZndmSkJxWTdBdDRVdXgvaWpr?=
 =?utf-8?B?dTF1V1IzZFFIendmVTMzUW1pK3lvV1JrMUFZVWl5K1d5ZjBxVzEvbExtajMx?=
 =?utf-8?B?aGdjK08yOU9JSWZLQy96ampibGVuaDY4VlArbjdRN1MzUVRhM1YyQ044OERK?=
 =?utf-8?B?ZXNDRUlLRlRucjRHZWdWbU1nNDErVmNndWpBcHVGQkxIZVU5a2thSDFVS0pL?=
 =?utf-8?B?eGZXbEVrZWhCakdCeFZoS0RseUYzZVNvb29VRldwcWwweUQ3d2RMVGVhTjJh?=
 =?utf-8?B?RG9vamRHRXVXYTA5ZlhvZy9GdXVEVHFUMjFCMDd2Vm5VUTJvQkxEYzd3ZTN4?=
 =?utf-8?B?R2c3MkFiYTlBY2grSVlDRDZqN3c5S0NCWlprU3B2V0hnVVVaYWVkNVVMRXZ3?=
 =?utf-8?B?MmFJbEx5eEtxbjdLbk84UUYzYUdpMXpHS283N0NFc1pKcC9PMll3QXJ2WTBN?=
 =?utf-8?B?eHlmRWdCSURxUlZFczR6ZlVLSzRiQUJYb1U5QlpMelRNOVNpSktnTlRzVmxH?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8JtfoWwodsRpn/FSHB89/Ji3mNGzmL/AvRyv8L+YMvsn0SdyTaB8lpnnjbS+lcoDKRn+q6rcnifNkV+XUzhUsz+xez9O5+Eg6U/kvKM5/MnR2L22tgfygEJKBfZHCxYeh9Y9GcTrqmUHyrPMKkND7JFfbDeEWzkzOr0+zwZ2dXu5qJct2INunCfzNIMdY7ueoqs9C0g60nHBK19TpfvCB+sz1ArKx7w5RrYhH5Rjl+A2XRT6a+wRLE533o2DROArKCeL1BpVVFNn1tgMHcNI/p5iEDYZ1ampzPwc6CpuVomcx1BK72FFrEHzh1804EDeHDgVUBbnsO4w1PSx4Zn7zu7lAU1jTzZQUMVmc/Nc8ZNhFJA8HnEx6EW/B7byGjtS18X+ctkBW2jPjBarwkZ+XT2QU8vz2QzSaVzzQL08eNYX/IRBN7XojQiTqf2MdIMBVTM2iOFcbuJuP6kfIEqPiauIVfguBkQEnwWVfcQPETjmTYXMddLTbTz9kgc0DyWOiaKdZs1old0Ebez15ynDaLsQ8RwHHmNd/mJJUip/apHWu2mgHJpn5bcxtNYeCt8Tenj6rOeyHjxXGBIn8uvZ9fsqplkzTAhrRhIpHnliLMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d010cb-6897-4b44-0fde-08ddf50410cf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:33:17.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdFaRG0NTGmTmIBpuTJ0DlXCab0UeINAP4QW4jWP2IgpT2yUd72hr662vwjZfoRUstLp0+qmHrwG0/j1gf7uFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4448
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509160092
X-Proofpoint-GUID: UISAxldkwhAA-bJElQwY5NAQxlplZo3I
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68c92ee1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=ZqSUkyyUUnwzs2uWvIYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: UISAxldkwhAA-bJElQwY5NAQxlplZo3I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxNiBTYWx0ZWRfX8KOh9shKnfoH
 YEeC8mGFUPjxJN/9cUfVUpJshP+DKOtju1Y0QjIRmJognKB+wfZIgBdkC88IllaIsL8upE43s+0
 LBOfnPOQq2z011SlmrPc4CHKtERDSGNlJcd0vo4OchjyCtzIBYmk/5ja5iyGKRgJq5ZjkeetZoo
 RbON9oR6bLaQfaF/8eKKWIw+DBGhy3pblZD8QPCQOa68bFSNDnKCmknzwaH7eRCl/pSbQZZ0c0+
 bhYRi+nl42L10Uv/xX7MK3Q3KyGS9xWOX42uekGi8USQGA66gHauZGR8fPgljl1CFQ2VWN9xYi/
 NacAxVye45EAOTV287XPvr0TRtW38fWMiWFFPqaSDwiE9dL1nQ09UMGoc4k4r17T4GA3YTmMw3B
 dhppVnkx

On 12/09/2025 19:21, Bart Van Assche wrote:
> From: John Garry <john.garry@huawei.com>
> 
> Reserved commands will be used by SCSI LLDs for submitting internal
> commands. Since the SCSI host, target and device limits do not apply to
> the reserved command use cases, bypass the SCSI host limit checks for
> reserved commands. Introduce the .queue_reserved_command() callback for
> reserved commands. Additionally, do not activate the SCSI error handler

This has changed appreciably since I originally authored, so:

Reviewed-by: John Garry <john.g.garry@oracle.com>
