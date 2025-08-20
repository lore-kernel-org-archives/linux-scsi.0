Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A6A2DFA3A;
	Wed, 20 Aug 2025 09:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681867; cv=fail; b=ZrdHwF1iC1vU8IX6Rb4YfG4ookJGztUpfeDZcRVPiNEnLhcJlQ0fmfC6fG2f6vIAqZikAhEBXkzlNemcIWsydcDd3HKL2kqnyHMFvj4BeYxj0vuVbJP/uNs+Vkbe8sYuZkxk23xddaoDYD0rd7TovSFwvSJAotfy8yifQDQ1meg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681867; c=relaxed/simple;
	bh=kt24uaUwET57nqthlUaxPCCfku8Piyy8h1QIfoejBA0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lbz39AwoZKailfQoUDDyeZpdYtdY/K6Z12q5wF/xTfU7dYcpTwWb3WVsi2zjERMsvyWKB8Q1jZ3h4urX2+64XWRBtRQeceplkbikaKu203QCSgdITjCg0EV0h79438RZFHw3DpC9WgCO3CLhEmV4yK5d80oCr17qo4AU0LhyQ5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dbZg03Pl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fNpmz2Rh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dbZg03Pl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fNpmz2Rh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57K93ZFT027354;
	Wed, 20 Aug 2025 09:24:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2bpDODteCp0bgDukGhFee5SJ9Gk1+gehAYGL5cbVTy4=; b=
	dbZg03Pl3sZqq/GtSY5AwT/KGOCS6Cp+VPM2VBkBkezQ+02LO1/EGbdx+bFDhPwV
	x/KPS5kXSiZ0I85rmlIr1AiV9Wq+AWOGlVOO1Upa4csoIQwYt5GO1BdPjv8Wj+J6
	jJWlFO7/AWw9ypte7P5GziZ55RntXrWlrxfqb/xj1rbgoBiDm3PWJs25QoNCbMox
	Ulc8dKJo6vZcYG+LRbD8P6F8/Dftpb+kPv2dfI8oOxoFmM1yT+eppk2pOKvuQCgC
	JqZ0p5V72fgFZ3sBI1irUf5YtdcXaY9BR3zArpefZLGC/KhncccGRJpr6FAeOIUT
	ZNEW8Zd7EOV+x8M3mHWRrw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tt0v68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 09:24:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K8hMV5030401;
	Wed, 20 Aug 2025 09:24:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3ts83y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 09:24:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KzHdsaG9tHfiO0v6X985qBkr4gtLSBDiFLoFJt5pFSV8WrEDAGkPzCd3FKBRHAzkd8gzEmo3vFNf8VMMo+CdKbU8IILrh+GNWHYQukL0e+GyqiK3j5qxWCI5MXqqm89of3Iyl3a4/uq/1/AWweSFQoANweTul0wrWhSe4nnNtrhW6PZhwRp+zqRGMkQrqC6NV7Z4ICNZCNtpg3Hb5Nn68m41DwRs/TbEo+erTC8Ry87lmvaSVXGehbtztjIb8hgMRdhPq1QBUqdEkZ/I+850h1qYa9YdU/mprBI9/251ODVqmU4kMNWMBnwSwpuy7o3QxW6U6fiwq6ZwBKfpQk1+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bpDODteCp0bgDukGhFee5SJ9Gk1+gehAYGL5cbVTy4=;
 b=CYT9vDm6L8iDzXZwLcfjC1SBrXhUdPPuhK3JGDJh2HyLfsijG+fA+BeNiZbAPe0Jy7acMaeWibKW7msw388iYaYfa2HWn5C9UC10VZdKTDe+ZvH+v29Ym/6iDY9o+L5rIAQNPaaAt2jOryTOqMjr5p4r37dcOXqgRAc+TXD5Ut5KCCLbCQe9wKqxJk0+9ttohqRBcmweHk44j5gQPnDbp87iAUfjTIrn/4yyy0UiAEfoXK58EEUKC0TdDecVm4cZ+hIWPYeDtgR21ArJTqQ93MbR+Ko4jKjatVTJfmn28lWfWUxIPlP0gI5t4hRd0oo1zCYL+m+u71oPvtsQqL6P4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bpDODteCp0bgDukGhFee5SJ9Gk1+gehAYGL5cbVTy4=;
 b=fNpmz2Rh5eKn3IppnrI84GeK1tMcT3Nj/DD8HdmOdmSpN4dqMZfrE5s6WcPhAmftA1vNaAxQeS74WCGhOTJpRifzzOjVIUegM/cRBxvRxH108cGXl8MEfJOeTEqnuXfDO+t5cf2WBzf0S4JxwgsN+GGhjSmlaadmVjxi4QEEKOw=
Received: from BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18)
 by PH0PR10MB5578.namprd10.prod.outlook.com (2603:10b6:510:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 09:24:14 +0000
Received: from BY5PR10MB4307.namprd10.prod.outlook.com
 ([fe80::a258:9629:a6b5:c80d]) by BY5PR10MB4307.namprd10.prod.outlook.com
 ([fe80::a258:9629:a6b5:c80d%7]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 09:24:14 +0000
Message-ID: <0a345fc9-e780-486c-8724-2c313343cc51@oracle.com>
Date: Wed, 20 Aug 2025 10:24:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aic94xx: remove self-assigned redundant code
To: "Martin K. Petersen" <martin.petersen@oracle.com>, liuqiangneo@163.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
References: <20250819023006.15216-1-liuqiangneo@163.com>
 <yq1h5y2vh09.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1h5y2vh09.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0048.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::36) To BY5PR10MB4307.namprd10.prod.outlook.com
 (2603:10b6:a03:212::18)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:EE_|PH0PR10MB5578:EE_
X-MS-Office365-Filtering-Correlation-Id: 74a004ac-452e-4c3f-76c8-08dddfcb53ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWZRL0ZBRmFnN0FjUGl6bW9XbHRhZ0hmbFVzZFphSUgyRXgxcU8rd0F3MURK?=
 =?utf-8?B?SEpBRjdLenhwRTgyeUFXSjd6NzBaSzFlMERXNlFJMEtXam5IWjd0OUhjZGVi?=
 =?utf-8?B?NU1RLzZLRkQxbUx0ZmVjUnZpUDJUajF1ZUVzRkREMDUrUUlMSXh5MWQ5SE5G?=
 =?utf-8?B?ZWZ5OVhBeFEvMFhBWEIvNHAxaU5MQmt4VnVEZDdZNzRsZHkvWlNlMjlRZ2lq?=
 =?utf-8?B?Z3F6TUVQcEx2TmwvNm94Uk5UV0FydGtyenZETUlBWjhvdzF5c0dqdTFORTRR?=
 =?utf-8?B?eUNrOXorREVWWHB3eGVSYkxEV3lxUEVYck5QNUNxSVk0VzlPRlhHV28wRlpE?=
 =?utf-8?B?WWRvMHhYNmcrZ1VrcUdjUjlBQ21XK1I2allEZHFra3R5MnZFb0RZa3dkV1JW?=
 =?utf-8?B?dFJMYTQ3U1ozMkkydkFJaW5MSmlkenRldnJTQS92d0ZBMUJibTJ5ZWRxRHJY?=
 =?utf-8?B?N2JwN1BiR2J6ejdHQUhKUUhZUEZERjkxTFdrdWJVNiswdngrSXRDd1NFRXIx?=
 =?utf-8?B?RnljSGYwRmkyZ0dhajVYeHdXL09CdGZQMkRJOEFxbk5SUmNuVmtVVUFKdXcv?=
 =?utf-8?B?RmtlWkphNmZjVjNZR2ZldldFdUcyUXlnVHdncFBoQ2JiZUlhaE5kUEl4VURw?=
 =?utf-8?B?SkRTRmZBRVlHMHliOFlkYys2WDl1TTU4RVJEeFJEOGY1M01VdldIWVRNSnBS?=
 =?utf-8?B?eGpKZGNYVlY4dkZ2SGtKSVB6KzlFa0xETHlEdVdVNllqUFBCaXpLRCszUUtP?=
 =?utf-8?B?UStiaTlvV01lamY0cTZBdzh2RlBGTE9jK2JBZjR0YnBBeHhBVFJzSnp0MVkv?=
 =?utf-8?B?eEg3c3cxLzBtaWxKK3ZGemppMmViaW54RGU0bGpEQjhJWGJsbzFEcTU0ZTlK?=
 =?utf-8?B?VzYzVndCSEZBaFNmbjU2ZStyZUhFVjF3NkYwY055b3REc0dsbWxXem1lY2xw?=
 =?utf-8?B?c2VLUmVPZmRhUDMxcVlpWnhOMU1wdnh4WWlpc1c4M3h0TGZKUEdtdGtnTzZs?=
 =?utf-8?B?UC9aVFp0ZWRHbUMxNGkzd1lBQ0lnS3BPdmRicm02SThXditNbklJc1Z1ejBa?=
 =?utf-8?B?bDQ0RU9PUGsrZWxoUWpBV0daT0VBclV3TGVVZTBxdjRoZlozN2hNNUhPSlBK?=
 =?utf-8?B?WGMrZmp5MFBIZXpqNEc2YzBiZ044elhWM2ZwczJ5WDNuUnV4N2x5RTlBcm42?=
 =?utf-8?B?ZnVnQmNPa2FUQlplUUF1Mk1KVXNhTk9BS0o3Ni9pRGx3cEVHVTAvUnpnRzNp?=
 =?utf-8?B?WUhjWW0vcktyN0hjNHdBei9LTzJ2QUVFN1htTXFOZHJISzJJRU8weG9ya2Ji?=
 =?utf-8?B?WEFkeWgyUTZHMC9xSCtrczJza0pIaFlNZEV4ZC8zbkdiUlo4RUJpWjNkWk15?=
 =?utf-8?B?cXRIblloMFBMWjIzZXdDYXl6ZFU0eVBBaTYxVmV6OGtQdkZWN3BmK2VPYkha?=
 =?utf-8?B?S3NzQXRWOCtja1RIaStEclE1Y3RmYUtmMTQ3WlBMMDZVR1VQS25vNk5wNGxr?=
 =?utf-8?B?MDl3TUNYN2pKOEhkbi81aHVYbnpweTI3ZzlFUVhjR3d0NVdHQ0ZNVlpyMXpK?=
 =?utf-8?B?a1k1Z1hUbkhiREZrbWs5ZHVoTk9DZ1FkNHBlR3JTYmJBYVVVU0toRTFsUzlT?=
 =?utf-8?B?VUpUWDFuZHhIZUZwSmpYS0o4WVZJaGlOQ084NVJOeVFtUGZ4VkM3SnZvRjky?=
 =?utf-8?B?bnBRMDBBV0dDZHJpRFVMS21xczlvZjFua2pIbGlwd2pFQ2FDc0NrVm84bmVW?=
 =?utf-8?B?cTJDa3dRa3IzWG8rTTV0eiswMDFRNmVlbVM3ZzBib1hBVmpiOURZMkluZVVn?=
 =?utf-8?B?TDNWMm0rWTM4UkRXTTk5NlIrb2phZnpZWUtLanZVQXR6bDF2bnI3NWJWeVZ3?=
 =?utf-8?B?cndxRU1acnNaVTNaVG1WMFZDemo5eVZ2Sm41aVJFVDJNWjU5Wm1mL1V1aGNo?=
 =?utf-8?Q?0CwOHHby+yo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4307.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWhRbnAvNVBsVDFxUG1RRENESWNmaUc1bUs3QlFDOFJtTUxpSlpIT0F3djND?=
 =?utf-8?B?d3Q3cDJKaUU4VlUrUWdmUUs0bjBsTlBibjhydGo1eW54STA1Z0xKcU5Xd21C?=
 =?utf-8?B?VGZQU2pGbzgyODBTR3d5UWxqL09oK2d3cDRKSVExSGdheks2d3g3RzA1dWZh?=
 =?utf-8?B?d3ZsNDFjS0x0QjNydWpVQU9nYTArTjVvSkxrN1JnUURoY3N2UU9EQTlQSzV5?=
 =?utf-8?B?d2pmQlNGTmxoVXVBRkkzSS9SOGVUOU9RbEQ4ZmUwbHArZldIRUhpbnpKOU1J?=
 =?utf-8?B?WXpoZElVUFVGR0g4NE9YU0pnYUVqblBGWXVxdlU3ZmxkNDBhUFphelR4R2Jx?=
 =?utf-8?B?RnJMemxVYnRxRGtLVE5vTGN1cmI0by9pcTh3bUVWOTg3eXJIRUMxTms4RDI5?=
 =?utf-8?B?cVppZ211ZjJlN09DK2Q4RzN0MnE2Y25DdzJkM3ZSSDE0SEVPRGFPWjFvL1BF?=
 =?utf-8?B?TEpQcFRhUFVoekFFelUxMVA1c05UV25oUVVIdFFOWVVxd0ZQaGdLaFBId25k?=
 =?utf-8?B?bTBBV3JFVEpubHl0ZGFHS3FlZlQzRjhwNGlnSE1wZFZoekZsVmpaem81Qjdp?=
 =?utf-8?B?ZlBlalpBYUxKcUdKWU8xV2t2SGVCdU9NT2hrMHA1cTNxOGNMVW9Wc0JCNGNo?=
 =?utf-8?B?MENPbS8yb0NsK05CMHZXbWVDNHV2YTd3Q2lyRnREMVFCZXFWT0d6dnR6M1FZ?=
 =?utf-8?B?VER5RnRLN1g2azJUQkhXQStCeE9ZZElrcjhvc3ROdnAvckptT0ZpN3NYSU5l?=
 =?utf-8?B?RWY3K1ZmTmluWmhaZUM3eE00N1V3RXNhVlVxeWpMY3g3Ym9EWUNjUkFYM1Fa?=
 =?utf-8?B?UjMvOEZ1d2xMMmU4T0tKbFVZVFZ3YjQvK0prM3FTdkt0OUFUN1VJMllDbWJD?=
 =?utf-8?B?TDgxTkdDejZjUGJQTXdhVHVmZ09KRU51cVBjdzJPMzlZa2FGNnZtWktMTnJQ?=
 =?utf-8?B?dktubW51U25YYmMvZUtsRzFUdHNMMHNkV3NQazFnTHNMSXZSMk43OHluQ0Fq?=
 =?utf-8?B?NjBudytnSmxlaXh4WjJkUHNSWnNpeCtFSXZ0bG5tWnZEODNSbWJmMFA0amFn?=
 =?utf-8?B?VVJlc2FvTXQ1MjE1TGhzUzZ0NXlyMGxUUmpWMHBHUmNleElKdzdPRlJWSjhl?=
 =?utf-8?B?bHlqTW1JaDZwT0M1QWNkMDVEYzRLVm1NaytwcUcwSkNYQzFIOTdraWRwQ2RU?=
 =?utf-8?B?dG93YUN2UDdlY1VzUkNTUDdxaCswYWVNRFVldkpUc1NKZUcwUlpWK09xbnpq?=
 =?utf-8?B?VnVibXlFV1RlMFMwU0IwbDdtbXYrK20rWlZIbm5PbUtLckhLNXFPNWFteDBW?=
 =?utf-8?B?RmtqdVBMM1N6N0FJNElkY1FYanVTZ0VTKzNaRGIrODhmOTl3VUhiNkJBR096?=
 =?utf-8?B?eVNnRXlsOHUxMHRubFFDL3NiWXltZ3hDck9EMzkvV25uWUtmakIyd0E1TTNm?=
 =?utf-8?B?YjUxLzBsQU5QaS8zZG14V292dVBETG9jQmVyZ3AxVkJHSitiTGc5K0ZndWFT?=
 =?utf-8?B?K3lWVmxheHlkUTVCNnZkR2xXWFd1VkFkUUV5T1g4MlAxaHA2c1pGSVVSU0pM?=
 =?utf-8?B?MG16dlhJcHM4T0ptUUhjOWI0YmZGdURKRWVoTHl4ZG1jR3NhWGlRWExMZlpr?=
 =?utf-8?B?L1pZdFJrMkR4eWNsSmRSQ1ZLVlA0b1loVkZwaTdKV3FKcGtnbmQ1YmdrNkhr?=
 =?utf-8?B?T2FEd3JCRnBNbzNnaWlSek02ZHJWZTZWcTI1MUVTcHRNS29HZ3puMVl2RHRG?=
 =?utf-8?B?RUNzSXhPSmJpOU5YaGhKUUxQVlROZlczbmJTWFJsR2poL29GUEp1Q0NoZG1k?=
 =?utf-8?B?U3RTNG1WTEhjNmNTc01zZTVSNlVhcmU1eVpTV3d5K1QwUWE2WnNEUVBDcElZ?=
 =?utf-8?B?dnFRWndkZi9uOFRVdWtDK3R4VEREUGRQUldJT094YXhRTVJXYzVBOU5KMlIz?=
 =?utf-8?B?TzR4Y2d1bmplK3FnK3dzRU1ONmIvVXhyeU5NVktYMHNyc1FZcndSSDQ1YjJ4?=
 =?utf-8?B?NUt2N3R1RXI2YkZXOVdPRGVBY3FKakVRM21xbVNFNEU4MUNNQkVrdGw0T1pG?=
 =?utf-8?B?Q1pRYmYyZnpRaTRERHBIZTBhNVg2OWRqSWc1L05YZmNmdmhTMGlvMXA1ZXh2?=
 =?utf-8?B?Z3NBdk9VQWN4azJsNHAxSllQYURBQjdSek0vOGpEYmRmeHZXV0Q0UjdrbUhK?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OBWcGe+B8EPG+CmYRJDh0qG0HT68yOFWo9FHpaA73iwtXsH5YBJy3HynDzP34vWtBrIPeqMGW6dwh4dtmrpUu32hGunXIM33NT4QKb7dh9bNF+z+5QvxLxA2Xm3/v8qx4ibCRinXT8R3R90Pe+BKA3adVcn1lWSF5OhT/UPXgOGo3wGBUjQB7mpk/tVggglkVuswYa6NZWC1Fr8CJQ2gNzm6PNhYkel6+PQuFHUm9+ZdPkmBQghelQGWQo2gei+Vw/90b4OjJXs3glTAlydPiCXzfCGtGSTIq7xtgP0sWbopvcDc48mZ+YG/yQPXEPAjzMboX2Ptepfpp6KjNKLZoWNXcymknPrk6gDVM7yNBuXNCj+hZHrvhXo5dayk4pqy4a8HcXRib0syAhSTCJMiq4idpcVJKoJ00wJOPe9krJ7w4mQ52k1s8dhZj3eDn1MrGeEnVuB1zhddFCY6yAMVFUDayl0xHcvwoP5925AE3j+TmWFm620IcVEGuhHyb2DMx8Ji6oeQhV70pqoOcw9yKMA8cXknG8KbGRa9DVlvxS2gDrTw8/5c60DtMAc+HiCb2Gf1ki3eJf+/XKCTWD8OhPTjTtue0E0+4/vBIXOgmxk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a004ac-452e-4c3f-76c8-08dddfcb53ef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4307.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:24:13.9404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51JWSehKi/iHU4IHJnRjbZX613h7YSq5gd9uIfRnxfpcsB6FcN9jsrrBEWB3ZcpmkLksvJo7tujPF6pI047OJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_03,2025-08-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200082
X-Authority-Analysis: v=2.4 cv=YvRWh4YX c=1 sm=1 tr=0 ts=68a59441 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=ZpjTnUga3EQCRRpZvxoA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: NtUfRooapx1T9lB0IsmQpQbS1R4iCwS0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NiBTYWx0ZWRfX8iU+p9AIEpHj
 E4MWg6J3oGjdUed8rbTDmqb5wDQeHdlv89KwnEdhPa6pe4mH0L2Vhin1dgWvqwdAL24XMpZ8X9O
 z4qKfNJSTnv1k/ph8Ga8h3fc8hbFsK4XyNpHzv80W6O3RVL9s44qk51xD+uwj6Dgi3kD7dxolZ0
 uTFZH+kO/YmfwK4mUtjfSbRH4lM2E7iqqDu5pH0SEkJoLskqY2NVzaULIvbnxtZU3vGvnTIDhL1
 xxjXe7qBB4jvM7oZ7kxDdbRs53t/yjxzbTcaP7PZmA1B4W395osgdKjV2dFUSkgCkZsfboL2cGK
 PIzJOpOQdqWtCs/VaC6O4dPJLOpgloIlxQu3e8V5cI8V7AOhKqCitsMzDazshGSdBvu4s2vYO9y
 bt3Wss384t8B6h4mzz87wN4s5eEl1kOs5O4im3IkI/SVbY87K+g=
X-Proofpoint-ORIG-GUID: NtUfRooapx1T9lB0IsmQpQbS1R4iCwS0

On 20/08/2025 04:08, Martin K. Petersen wrote:
> 
>> Assigning ssp_task.retry_count to itself has no effect
> 
>>   	scb->ssp_task.data_dir = data_dir_flags[task->data_dir];
>> -	scb->ssp_task.retry_count = scb->ssp_task.retry_count;
> 
> This begs the question of what the original author intended to write.
> 

If you check commit 86344494e364, I got rid off sas_task.retry_count as 
it was never used. This means that we explicitly set 
scb->ata_task.retry_count to zero now.

I guess that they wanted to something like that for scb->ssp_task, but 
there was no sas_task member to copy from.

The value in scb->ssp_task.retry_count would be zero from 
asd_ascb_alloc() -> asd_init_ascb(). So dropping this self-assigned code 
should be ok. However, it would be nice to have consistent code for all 
protocol frame types, so we could get rid of setting 
scb->ata_task.retry_count = 0 also.
