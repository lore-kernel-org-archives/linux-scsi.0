Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74757216459;
	Tue, 12 Nov 2024 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435760; cv=fail; b=s36A+35XSMpHi9S4JM7Ld+GvhGzg2w7ZZAnOeP+LT02oa5JLrBKZTg4FFawC2oGHl3hypOoT8vWnmVCiwNViFODky7QwJXwAK/JaaiqiYnYjTYFqHnaVER0OMrV53E8XHyNDq/HhYxeyGiHVHLw+5PPpyKBcqBb3GFq6Pi32J2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435760; c=relaxed/simple;
	bh=w450g/R6k+hKEM6iSS29x3qEORQXzYxA+39DaCpCAdU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WXkiznDQQcGUElo7jHxWEt/vtkbu2G8CJg/jH2c5xUO7LyvPFy9qcgxmSd2fkFAjNS6naskgmgEA/isNf9p9bAjQnQZjLFuqQxGJ6R4XMPFa/bt3c9RSnrOtP3/7cNUD95GTG/P3TrmlQ7qZK8eODHRaQ2uWJYU9bMRBWb8dClY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SSV0OU3C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wr0M6Vsz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SSV0OU3C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wr0M6Vsz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHtdgA027082;
	Tue, 12 Nov 2024 18:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=CqpM+L5RVAQnqAZLaVH8UESYvWtQdgW+ri4ebzzIUvE=; b=
	SSV0OU3CYEdR9HfDGL+Y7ZmRFXBr1HWLcitOm7NckCm+JvJQ+DcLvHx+3OAch2mY
	azCKgPVwv0CuamVxNLClZ54lRG7e+wQcBet4WO+frMLJkd1RIJPIVCU7NNaJMghy
	ZZoSpWgEQecZXGpPEQaOQKKCGZ927SapITruVGqWBb8Mfy+PEL2PMafqJerzU2rj
	3t3tmCbeKpemp7Akvbc/jLvBUCribnqnaR2KArbI0JYZ37fxIwoDR1P5El02n8Dy
	Am9NlXjcGqs+6DDwhv0pKvOxw5FBNPjgVCHa0OmZ0dTsNQSjTRP07RcklgpUZN9B
	ivDK9EG0EbQ1VtqTcCpNBQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hnd4kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:22:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHJPSD007978;
	Tue, 12 Nov 2024 18:22:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68gu1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:22:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T35tda/D4lQqxyVAYqZKnk4fGI5w7kFLu5hapQrO1WJ92Y9e3PcYkch7KuHpaUNwTl0qANaBYnVPDZuEu42Y1mwYkT9c4UDYZc16+QzBDGjFjT07YH+RShWd8QIQTw4ndBXq2rfpJFoAlaqbWBe//1ZYsjdYmv6uKkSqVXEFAN7Y2GhN0FVp2sJ0M/XCedrmihemVNaEV6RdFmHUMgd/uQJY+83SwZVXPzwfDw84BxFWVZ4/bS71ADWRGhRnffhLvnlAdv+uddCZQxmW/jR7BeDpEvbKRnTYx9wih51MNmXAQzdxy9GNzqdwKQnm3b11sPUJ0gpr6U/q7HLE9a4i3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqpM+L5RVAQnqAZLaVH8UESYvWtQdgW+ri4ebzzIUvE=;
 b=MfUV0OHL4nP53aerSxF/ps42ifsczq2BR+4rPiHxuzEjRl+8hOzFn5z2HjicDTpU+tYXNilH2RfgD2x1QzVirp9JO7Vh41cC2FUBSxhWx1/Bc0CQnnRCNOgXWahhK5HXEaBuMQOhDWZIVS/p1ePe3XfZJJv16ctl6FKqPoZE/0Ljrdy9SRDHJmqIfyRK108m8wmfLJzjMFhKq34OzyEe4saA1OiTkp+OTCPleybC8nCyADTj35o52hGQHtvEM6WlP3zfA/2M5rgDy9dbfBNF8eKR5Aprv1WFxHkLaUf6SLVkumDbhIC7WqC01X13O/1mMbAK8NFkCD2vvFBimcAGFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqpM+L5RVAQnqAZLaVH8UESYvWtQdgW+ri4ebzzIUvE=;
 b=wr0M6VszdzBjX1SCqt7Vsb4P56K/deMAuU1hZuEv93+atANNQDgpOsGmpnMesXctYmGZ2ukiXWL5Wz4tmTHXAs5YKlhusXZZJ1P496VF3WTdHBfyxIrUxJcpSQRE5lRoyOlMNUB1BUlFb0EwSoSI8wnmn46LWasKzQfCFrm301E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6556.namprd10.prod.outlook.com (2603:10b6:510:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Tue, 12 Nov
 2024 18:22:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:22:27 +0000
Message-ID: <b7746182-f2d4-4cb0-8028-93e405b1c4ec@oracle.com>
Date: Tue, 12 Nov 2024 18:22:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20241112170050.1612998-1-hch@lst.de>
 <20241112170050.1612998-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241112170050.1612998-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0288.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6556:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bafe46b-3f71-4354-268e-08dd0346f62a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWtodnpQYk11Y1hPT0Jrd3ZZTWhTUDhnUmVxNUZ3ejEyR2ZtczFpRnRzNExz?=
 =?utf-8?B?Rk9MRWVSRzJnNGxpMW9IUTZua05LVGtlVEd5REdCWGZ1MnVtZjZCcnZPRys0?=
 =?utf-8?B?bk44T0JPQkQ1WHB1OEhOWVkvOW0xYzZiODBqSmZkT0o1UExYS1RTaE9VU3lJ?=
 =?utf-8?B?SnFuODhtVGdUdTBFV1VlcnZjcWxoR2doMHR5cDZhZWcrS053eXhLTjdmRyty?=
 =?utf-8?B?ZE5GNkkwSEZzdnp3R2UzeStNSk5KSm5XbjVlN084VGdZTElwZlk5S3JQeE1r?=
 =?utf-8?B?NmxhN2R6dEdhNitzT2o0OTlGcnNKdi9hRHpOSTVVVzh5Q2owVU9MMWxjQUVn?=
 =?utf-8?B?NzdXaE0zQ2hEMkozZDEvaEtwbzdnTGJlUzJZZjBFaE5oQ29wVWRiS1l2ZW5r?=
 =?utf-8?B?b1F0U3piY1IyM3Q1QVRlVWU3V2t4THROMDhlRTVLYVdNV2RCb0dlSExjVnBx?=
 =?utf-8?B?Y0pDQWNIUGJOajg2VkZLQkFObW9xM0ZybWdPTWs1TlpERjJmQXl2a0xNQ3BH?=
 =?utf-8?B?cEhVbHc3YUxMelladzhCbzBkWFMzNkRKNGFMWUY2UU1IRzJUZzRiaWRzWmQ4?=
 =?utf-8?B?Q2Y4OFJrUmVOeVNSTDVwdThoZUVTRnkzdUg4UEZoVURqRlZzUFZ4K1FrcUxY?=
 =?utf-8?B?OUtLMUZxckNRNUk4MEV3WjVmM2R3TlJ0ekoyRWpYMU1nakUvTUdBanhHUndT?=
 =?utf-8?B?Q1J6TmhTbnVoaDBPdkhZd3ZpY2U2WjN3SjU0RHdJblp5RXBEbzhneEVsTVRE?=
 =?utf-8?B?cGtlb3JsWTFWQU51cWdvM0F3TWR1QytidmY4RERaZjA4WElDdkhLanRjSUM0?=
 =?utf-8?B?V3hnQmszQmF1MnJwbjZhbktLOTdBYjJtdWlhVVdnNzRzUUlnd09Wbm1aM1Zk?=
 =?utf-8?B?clJvSWV1SHpxZE1kaG9vSXpJcEoxSmxNMTduVFBOL0orMm5WNkZadHJURVox?=
 =?utf-8?B?Vkwza0MrYXVMVTl2dU1NcFhaUFZYdm1nelRPSUQ1SUlGVnc4WnAwWGpQQ1ZC?=
 =?utf-8?B?UGdmZ01GZ1ZUSDdjdksxRjJPb2VmY2Y3UTRFemhyZ1d6M1pqWDJnOHJwWFJB?=
 =?utf-8?B?dmdyMnRqT0ZrWGpoajh3MGszU2taZW9lWXJnRnJtQVNhU2EyTFFNcDgxUzZ2?=
 =?utf-8?B?VDZxNnM4SGdTemo3SUlaM3RlV2pCRDE2NEMrd2lMNTJOYXpGMTRyelNPOEkz?=
 =?utf-8?B?TEdacWN1cjd6TkpMZHVLbEQ2ZVJoKytNTi9veVltazJQS1FXamRINk50QWpo?=
 =?utf-8?B?NU5yRHdlc1I2VG1ZU2dnTnU4QldkQytQbWRPejNWdlBiemo1d0h3L1ZNN2o2?=
 =?utf-8?B?cncwN2FVT1NNcWhHbldTVU5UbU51MmR4Q0dMdVVEaGtBOThEYWt5MHV3SHY4?=
 =?utf-8?B?UFE5SUJSS1RmbHZHR1B1dUtXV1Jzc1NjNHpZdGl0TzRrVGl6VnN1SjlnUmNp?=
 =?utf-8?B?aGNKbzh2YzNMTzNiTkNXWG9iY0MzaDVObVpaSWllTkpQd2ZRS0cyRFhkeGJV?=
 =?utf-8?B?cWVwUlhXcGdScXJ3UVI3ZDVsR09MeTZMclhSNGs0dDR4UEdZNTJsUDYzNnpx?=
 =?utf-8?B?MTRnUmdKK3lDRk8rc2tINnhHTlQyUkZZY3ptVDVDbE01Ky9wQ1Q0OFV4TlJl?=
 =?utf-8?B?K1YwYnNROEFreW9UZmw0U3dvTkJzb1FoTE5WaFFjVkZCcm54SmNVa0JIcHMy?=
 =?utf-8?B?K3FybjVKc3M4WW1zelFhUStCV3hmQVN0bTBGbTljbUtHQnNIdDcrbG1scHF5?=
 =?utf-8?Q?c4qWxq+6hC6/UfmXbw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnByV1ZWZFVFLzB2WFFWTTE0dTVsclF1WVd0cGVHRGM4UDZ3SUZ1MFNkd0RV?=
 =?utf-8?B?THVVeEhXUFREelhXNjk5dy9QYnhRWnN4VmhKZms2SXNWdStUS3dPVjU2dWtS?=
 =?utf-8?B?K3YySzdRY2dxKzVUZXlieXovTGF3ODdESmxnZ253a0RvZ2FRQnNTZzdjT1l6?=
 =?utf-8?B?UkxJQVJFa2paeVd2YndkemxFaTFkSUJzbnJvSURJSlBLaXovNi9jeVNsWnZJ?=
 =?utf-8?B?TGdiVDBJQVZ0ZW9aaHdXWU1SSEVVNDN4Uk1mYjZMcDQwZ0dPYzFkTFU3dTVs?=
 =?utf-8?B?Yk8vcStmR1dXRmtTR1pQenhEY05BTkpmK1l0RHZ5RmVkWStzQnM3TVZqaTZ6?=
 =?utf-8?B?ZnRGTnBqbEQzc0hhWEJtbzRVRm5MVVJsWURTUGZ2UmxzWFB0Y2t6T0Qxalpl?=
 =?utf-8?B?ZUtsVUpmMFJDZ2R6VHJhRll5S1FxNTB6di9KUTc3bEZtbHhTcldDMWltSVQ5?=
 =?utf-8?B?d1JxSWFBc3dsYTJMWnZ2TjFMUTVCUGdvWVc4ZG9Samd4VDExNFVvZ1R2d00r?=
 =?utf-8?B?MmhZc2xvZW9WM256WVlOQmh3ZWhlL29sUFM2TEp1VVJCNXAzczB0dytrV0hG?=
 =?utf-8?B?VURzZUVkejVLSHpIR3ZERkRtN2w3cStJaFhQZS9lZkFtSmhzeTQ1WTg1VVZE?=
 =?utf-8?B?NThpQlBWMG1YOGdadFd6dTlqQ3l0eFdjemFSaE9ZTTJyUzl2Q1lZeTJmSEtP?=
 =?utf-8?B?L0VCWVBqOWpyWjlOYWJnOEx4cGZBeDQ4djVwRmo4K3JrV05hR1NURkN4bU5T?=
 =?utf-8?B?bys3SFQyVjYxWTZXWmtmdjVYOThDMkI4b2wvNE5YdVBJV09heWR2TmM4czRj?=
 =?utf-8?B?Ui9raHQxM0trZHFEbUMwTy9nOVdrZzVNK1gzVUtIQVlEaHAyem5IbmpNR2pP?=
 =?utf-8?B?NHJoV2JDM0xFK3I0QzdsT3IyQjdSbm5sMmZJTTVaSGVXZXZQSG1EN1kwcy9R?=
 =?utf-8?B?Y2FOYlo5aFJsVmdTWDFYb0dhT0dCdzFpMHNLOVpJUVJLSTBnUVhFNGtSQTlJ?=
 =?utf-8?B?UnlrSXVZMmF4Tml4RXV0YzVIYXd1amlaK292Y1hSM0ZuSC9CbEJEYnFVVGRU?=
 =?utf-8?B?aTdpcE4xY3N4a3EyOXg5bnIwSUxzZkNFbklFRmpLK0w1NHBIR0htRGxoUWpr?=
 =?utf-8?B?QmYrUEw3UzEveGMzTEdoNlhwV2tuekhXdWhZVStzU3ZwUmRkZ2VhZDdUc2Z2?=
 =?utf-8?B?WlpRd0pmSXRSTGVwZ0JPZUphMEpNb1JZQlBsTENMakYraHJDdi9UOEZPYVgy?=
 =?utf-8?B?QmJ2dUhpaUlzQ2paVVUvWmppM21LaDVsd3g3T2xhbVpBcDN0SnQzeHppOGI5?=
 =?utf-8?B?RWZPSHR3cG5hUmRCVHpjaW01MlRTbytmbk9rZ1hJOUljNzFYWHRFRDNBaWYr?=
 =?utf-8?B?N0RhN2pBNVgyZWc1eUx5dVQvNFpjZTJaeVpKUCs5NVdWMjhNelQxd1dYSE01?=
 =?utf-8?B?bXhSRjYrM3ZCWjBLK293R3FibHdaaVdNZEhlWTF5WmsrWlR0WERaZWJaZWo4?=
 =?utf-8?B?KzlSb2ltVHpjN2Z2dS9PVUhvUnV1NFl3aHNOYTN2K3ZZWVBFd09maGRqQjVY?=
 =?utf-8?B?emlndE9YdnlOemdLMU5PZkJab2pXSEwrZkNlREl2MW9JT0F1azhYZWszWUp5?=
 =?utf-8?B?TEhHeStCMCt4bWh0K1pOYkNyTVd4T3k5MmVlY1R5US9xK0MwSFdkMDVwUS8v?=
 =?utf-8?B?Um1oVXhoZ2tpSDU4WjgrNkZxZEdtU3pITXpqbEdUczY0OTVXYm01aENsZmJR?=
 =?utf-8?B?SUVZclZkOEFyTlE0aEJGajJiaE5MZ1hza3ZwRDdRODl2WHRWV1NPQVlEYVl4?=
 =?utf-8?B?WUdKVW1udDR3NVo5ZUdpYkQzM3ptall0VEx2QTd4MUg4MERWM0dBOXNMekp5?=
 =?utf-8?B?SDUxQVRZajB6UGI2cU8vT25JN3hhY212S0NjN0VPMmR6Y2pud0R3VUI1WFJY?=
 =?utf-8?B?b211OGhqd1k4VVlGanpBK1h0cURWK28rTWpHaFpNcDNoSlp3dTZCRXJ3eGdz?=
 =?utf-8?B?dFRqNHBUQy9sZGtLSHlkRUFlc1pjUWVteUJoS0ZzWDIvL0NhKytzd3BrQjFs?=
 =?utf-8?B?NUNESlpKc2I2NzEyUW5zMDVTV3hacFZmYkdwV2lRSVp3dGdHbUJvSVpMb3NL?=
 =?utf-8?B?S05NODROUko3d0VoTVN4RUFHOHJEeGFLVmpKTHlBdmM4a3g2MVkyTWoydzZG?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bJKHbQOzKRPceWhWRC7K5Y8AjEOcf2yiOfbY9Ka2wY+UV0l8+F8txMxXRQCBdCjYGzN0sHr+WERNAaXMGZa6mxkjKaUylyLe0i1Uqd1DCdAFBSJKcwyF5Crx2R26QXfFDLy/udjvfbxBMsgqTD3kSKYKePUaU7jis8lxA73oPpyfDam1+iR88rJmnEuBLP7jZcVQA2ywcC0fqvykrvc84GkuXfIIOMsqiAZH6fSG1u+m50jsDeqYt1ToWhLyuomG2VADQURFrhnszurn4wefgkLEl5U0Q9YH2lrVyeqd/7BiRd88iUxZ4ukPkCuFSrrRmrfea39UgtOXtnzaI/NXWhqHy8WxEzVJ19WYy8RvBmuRScwNKhAlNsbjftyBoETlxYIbhCAz3w1pP0NMlavMZPknX6DashYmVg9SUWB1yGZT1LkIt2Mcj4fXsc/cmxr+CeW/kmsgv/x4h4Ex1ibSS7knDNdVBjezSaWNh9yf52feJs7n5IwQh2rlPNA8BXVMAwWMiL9lPk+EdHOpzpJ7v6ENgLY6A7sGOOMIK4UNNsKS+lfM1mc4nC24qvcRS4ZKKlcE8w0FEWRQxDAVxt2wMYD5PQ5tDhEN2VKZ7zxxUfk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bafe46b-3f71-4354-268e-08dd0346f62a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:22:27.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Loqm6kTsVBq8/NCG6MA0ObwIX0+DVy4neMNH+Hh2pjNLiBd0/sij32TdRJ/nx76BfqGLBAdUS4u8CEqGxnRCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6556
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_08,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=837 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120146
X-Proofpoint-GUID: oEmZ9WqcXKvODXlXjWYvY4gYRxkRn2de
X-Proofpoint-ORIG-GUID: oEmZ9WqcXKvODXlXjWYvY4gYRxkRn2de

On 12/11/2024 17:00, Christoph Hellwig wrote:
>   		if (rq->bio->bi_write_hint != bio->bi_write_hint)
>   			return false;
> +		if (rq->bio->bi_ioprio != bio->bi_ioprio)

At this point bio_prio() looks to only be used in md code. Is it worth 
deleting that wrapper? I doubt its value.

And at many points bio->bi_ioprio is written without using 
bio_set_prio(), so I doubt the use of that one as well..

I do realize that all this is outside the scope of this series.

> +			return false;
>   	}
>   
> -	if (rq->ioprio != bio_prio(bio))
> -		return false;
> -


