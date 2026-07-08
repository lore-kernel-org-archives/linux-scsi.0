Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D263831987D
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 06:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492357; cv=fail; b=LKzIkhFKU3HawPL1+3q7bQYQiI7WEVhgep5ZkEe07flsnSL8cJFYMZcIjhC5CxRwi1bXtC/rW/HMcUbPHqVzLJTIbf8iTuu0QyKJFKeIm2DiKnqPgR9VqqgoCH9Ecd5gv6nPxXBlR65OkJaSkK8w1hB0tvk3Gwh9VE2ioD6owQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492357; c=relaxed/simple;
	bh=BWGcOrMLZUs5PemulAZPkANFA6Jyn4jqk7FnDQP+EhQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ku0v7aIv/1wvIhpP9fshc91Zn2bj+6VBegsXrBl+r0oLxj9aelDsleUDi1Prte/ZspvR2kJOLD86i83h2WH0ny1HTqemBR1jOFQA0YibZ10aswQLlpYZpBjt9pEtCmpAK6o2uCgsMXyQ5zqNC7thr0aHvYG8SoDYP1Y7rNZ35qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HVXA60Ye; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iYz6SGNb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HVXA60Ye";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iYz6SGNb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667JCPD91347545;
	Wed, 8 Jul 2026 06:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HsRVNtj8LC4JAot5mpfbmrkqxZnIpXktJifWvy/r+Ec=; b=
	HVXA60YepOBWTUlB/NUcxXmL8jgRtqYsQZhp5FyKm9HAJj6DA2HqUXGE7zcdI8td
	izmjnNub+9jshLT6yTxqucHyiVQnhRhCkLQtANWKLC/BSSihDs4gdo8zXv2iy/Sr
	xp92ZH9SmXjRJ9bG17DyBz5f2m2RZyvTJWVVU1In9rbgSyKsNBQO7cMutT38Qph9
	rhCb8yDrM8q12h2fOyeJE8G2gb0fSWJcIagvPlo3NdvWkBlLQsq9yq2F22vuiRu2
	XsVaxckhCLJv00g8p4SdHtjBwVGmb4wx1aKn61ctkiQx373M2cMCYCMsUbLeL0Kn
	g78EKpSn4OrApsE4jLV79g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rkbf19d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 06:32:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6686S7Yh022524;
	Wed, 8 Jul 2026 06:32:24 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f8wuy5v6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 06:32:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlLORznvH8WXaOWQLLvkHSCumYyRG2NCFIHDWEJJffzl/wk+bLaMLVOyP4HiMdMC4MoEU7BfTSW5FkdmedSM6wcUnqNNqcy1YVmMjiueeJeCAFqgme3yBI6svIifGAW4q0/RBlx2nlVBdMJqReJDVQueP7S+tIPTmPrIlbyDOf04Ep+oc95MKtBGvePQex59Snfp4ukWb1syZRgYCEcI7RgfrqZ/eJYK5CDdd1aemcO3E+4YzlgKstQk/rA0xPqPkHgBqhqVkLHxD+TEUjNgdGPQjP2Y/GAOUc2SCvr1Myxf/uO7E7ytg9GtyoK/wfz/g7vVHT3f8L9LNom+lVbSYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsRVNtj8LC4JAot5mpfbmrkqxZnIpXktJifWvy/r+Ec=;
 b=LQiAiVQEpbO8yb7rABuHJTrnULH/f4ScxiwKVQxHO2BdZHElXSoVP59rcSOzC68JbBX/7f/fuY0caoK+kt2DC5nyZrz8YJBVPGnVFb4i5dK6taWLPohGGp11cG0/1N7E9T41yEnF2BzLI8koGzoUiT7HlcyDJKp/85KfEAFLt+wkshxJXJL+UoOXBD19WPzB4Cl4bvtWvx2R4xLl5GkoWTo71FldxUUkDQwtZQKx47E6MLta/SeCgCexSnv6vs/n/Tfc4fE+9tRe2zOYovIF25r92sHMnuJF+39sQmc0thfYyf/SZTTPWasXIUoWoXyJIj3qclRsRcSfSZaJ6479VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsRVNtj8LC4JAot5mpfbmrkqxZnIpXktJifWvy/r+Ec=;
 b=iYz6SGNbZ7/zVjIlT2Wlt4+sSHcVXfbBFV7ML3nQ1EYM2vBD3BNaBn9xtkeUUfAprJ7uyFAb5kuZeDubmtgqsl/+h8Kcs1dfU/ul49utSJh35yYnhFbdoQffKGRVclnWQASNjwfq2z78WuQsb5qQgWUBN0s6o+mg7XEYbeAPHmY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH3PPF1D715CB68.namprd10.prod.outlook.com (2603:10b6:518:1::78d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 06:32:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 06:32:18 +0000
Message-ID: <afe4913c-7565-43eb-b74c-ce05a0b3aa1a@oracle.com>
Date: Wed, 8 Jul 2026 07:32:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: sd: fix special_vec mempool leak when
 scsi_alloc_sgtables() fails
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
 <20260707030333.22245-3-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260707030333.22245-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0131.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH3PPF1D715CB68:EE_
X-MS-Office365-Filtering-Correlation-Id: bcde53f9-fc3a-48e5-2f7f-08dedcbaa889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info:
	ahjA3a/QyMdaRWFW/HSV6cGNDt5ue9Exf7wPYIOB6PAglmPu0N+fpSrDj+gQcBOOddZ1/Rkqy6BD/sD7gthacB3piXSwvTkcX9I8kw9NxYpWonkxtlSFQgo8t6EWr5imDffR/A3H+zBbFrLhrSw1g/oTW0bOZ3NN3SLYRzyxTq34TskBTQUAnbuDmH1jgAy/Ou8FdB3QPcN3tUYk2FOhd4F1pPYKv1R63IkNRId+biutQRxgzxM9ZYsdcD6eWloCojcfkSu0wL1K5hKIYnzr9Yi1XE4bCjYejt9wmO0c4D1ZUvlBHah279us9FP9a4axzWtPw7M8dOUm+ks+Nj566ERbTz7Z6o3by1ADbyniF+tBxRgOniMPm7bEKdR0X4lZizNSYJeiUXFCtf8/79FTE0MuLmqSOuHCu2NZxuGRskOFpI6MHCWiYr95tpdIJtaux6+kEMSsoNxHeE+wCgBSltxVgl3f3Am094RHiNujy5F8pemtfMcth9iNU6jT1xahMQpd/SSjdh//5aYIePbKaol36tskSMyucok4cmPr9KSPOeHkSXKCRfaMuvZp9kAvrodH2sU+SjKOYCmZuYmxqBdFOD1TG7IPIx0LoEci8UFoTXEfhqqXam2pDFaDb88gbIAj6j1yg3O3Ojnzlhztb6W2yOISYnfZjzkgglE8bi4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003)(3023799007)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1EwY2NDcUxsSVBGRHkzRDJWVTRLN2t0UDRyazZXK01IOXdJc3IxTnVscVp4?=
 =?utf-8?B?OHdVL3EzaERIOEMvNThscEZZVklGMldtbUxlejF1Q3pPSWR4UWNwNEtyc2dl?=
 =?utf-8?B?dzRKYjRHcytqMjZwTE9reHFFcVkvQy9FKzQ0OTdjVVRhUlJaUUg1dGxtWm9k?=
 =?utf-8?B?THcrN1JtRjBuNEpYZ1RHcUJDRUlaZUl6c3U5YklCVHZzQVU0M0J4UHB3L3Ew?=
 =?utf-8?B?Uk9wUnU1MWJzN21hWnU3dUp4NkF1T0ZxemZDV1oyMnpQK2tVckRKaWk3WTBi?=
 =?utf-8?B?YzVPaDNhbktZcmZ3djRwY2hJY3ZEM3o3alFyQVZaWkxFc1hFVnBkNGlLMEJ1?=
 =?utf-8?B?RXppNURtWGl0N1k0Z0lHRjRqRlptZ3dzK05sZW85bEpWWkRHQThjbm1ja1VW?=
 =?utf-8?B?dE11OTlCVWlSVm5CN1VEdW5JdnhEdGdTZm1rV3lkNWxUbzBzSHErM3ZVaWk1?=
 =?utf-8?B?Z25peXRjNkNlVEREclM0K0tYUDduUTdHZnFZTGZ4WmVJS2xZdjhtaXNRakdD?=
 =?utf-8?B?ZUI1UEhYSlQwTVRWZ3JmUFBpY0pPb1hKVVRxSGlWRUxYSTJPbmErbUwxdzVP?=
 =?utf-8?B?M2JoVU1UZVJKS1hVdmJWcldnQ0FNbmxIWlpkTDF5eHZlcjFFYkxrWFpyUk1J?=
 =?utf-8?B?Y3B6RURZNklZcmE2c2YzbDdOSVFpQ1plNTlWN0FtbUkvaXdmbU84M2h5S0lP?=
 =?utf-8?B?OWYxd1k3QWpDcHd4YStjRlBBNjBQTmRRZ21pMXI0M2NiUkJyYWVTRzNxeGE3?=
 =?utf-8?B?MXBOWDMzNkxkNFB6RWlkV3IvcHJnU3dHdWRzckhVUGVVYUZhNkwza0syczVM?=
 =?utf-8?B?clNXTjNFMTRYYnRnMnBoTDdBV2tnM3RxMmJYUm5nUFdYL043ZERXWDA2bTQv?=
 =?utf-8?B?MWhXQlMweGkzVWpLK0tDTDVvOFMrN0hMUmdRWFRRQTJibEJlTnR4bm1yck8v?=
 =?utf-8?B?Ym12ejR6V0U5WjJCalk5MzhhdDViUzd0RE1TaUNZNGZiQis0d2JoaDIwSzlV?=
 =?utf-8?B?QkxXVFBnSm1EeW1HYUlURnVXMXROaWJzZEJxN25oUTlKSjJGOExpVHE4ME9F?=
 =?utf-8?B?ZnZYSzg1RFFQZGtCeW5EdzZ6d2g2QjdMb1JZSnZKM3NpSmJVT0RsWW93UXMw?=
 =?utf-8?B?d0g4NXd3SzMxRGFmNnQraS9PM05SS1JzcnpSemx1eVFUenljTStVeDZnMk1T?=
 =?utf-8?B?bXJVWC94N2c5T1p3Mnp0S2tWRFRiMWtZcENBMkVNL2RjejlwRCtja3kzb2xm?=
 =?utf-8?B?VFRWc2ZYdVMveEd5dFFmOVJ5a3hZb1h0bDdhMEs2NUZkZThHd2VKN3RSVmxi?=
 =?utf-8?B?QUxwVVhWUkplM2hTZFc1TVNSYi9EYWl0L25ISVpQQm4rU1U0OXFPUVV0REhZ?=
 =?utf-8?B?UWFzWkZYMTRXOENzMGtrQmNtVkpEZ05BWHR0U0hDNUNhQmp5eVhkeFh1TDRJ?=
 =?utf-8?B?VW9VM2tVUkgrL2QzdDdKOG5JcXRvUG9yd1dMSGVEZDE1UWZoY2xyMHRaMUVX?=
 =?utf-8?B?bHQ4b21OOUxmNHpMU2hhdTRxTnA4Z3NpN2F2UFI4RmRUbkRENkVxM3NYWkZO?=
 =?utf-8?B?bi83VDZIaTd3YUVHUjY5YjhJek9NV3FvbnYxMWY3S0NJRnlYUE1JN3R2Qmd1?=
 =?utf-8?B?T3crT0lOVGN4bC9rUkVyR1RtSHdUV1U5czczS09pdWVzVlJ3M1V0WkNYdEtF?=
 =?utf-8?B?QjNxSkR1WlRIbkFHZ09nUURyM3ZkS2Q0NncrL3RuMUorZGpGZVN4dHcySzlV?=
 =?utf-8?B?WTRqd1VoL0tYUkVBK2loNHYzWndETkZGcWtUNS9jYjVUU3M4TVkxWk4zUjVl?=
 =?utf-8?B?ZmxOKy9XR3Z0YVRpTzh5ZDBab2k5cERsNlN5ZTZwQmp2T29CZWZrV05wV2w0?=
 =?utf-8?B?Vm1Cdi9wekZLbTlwMTl4ZUxBY2lUQ2FKTnNrbk5ZVG1kREIxeXBQMkR4UkVh?=
 =?utf-8?B?RVNZbXJCdnpKUTY4STRJR203YlRWOHB4NFBoWmFLYmpoV3owYjAzVTB2RnZ5?=
 =?utf-8?B?YnYwdk5iYzByaHU0Nkd6UThyMUhFdGloZkZZU0Y2Ylc3b0RFdEt6ZTI3L2Jz?=
 =?utf-8?B?Qm5jREh3REo0Rmx6THQ4b2V2OGtFNjZIakVJZ0RFcTVxUitLS3lZaExFYVpO?=
 =?utf-8?B?L1lnLzBNRS9QOG1YaXhOTXZVcUdHQ0NSeXk1bTNRbG44Y3pJWW90ME11OGZO?=
 =?utf-8?B?YnMzYlNNaGxqdFkxQ1dzVzNGMDAzbk9zbGpmUW1UVnJkRmlLQmpYTzVTK3Y1?=
 =?utf-8?B?Znl4Q1E3MHJXOU9RZTk0cEFJVHJveFBWdUdVRURwV01teWlSQnNweGxnODNR?=
 =?utf-8?B?Qm9PbFhtQmhVeWtGaTVTNWZGRk9sSFhmZmZNeWU1bHhOWmttNTk2QT09?=
X-Exchange-RoutingPolicyChecked:
	mbLSFL8DErxpQLiReiUI8+r2Pj7drGJcn/qWMtraB3fdtMBUgPiFf1pyFoKzL48oSYo+Y0CjgnEXNNjg+X0BpkUZBu9Nn6f1u0QEjcYz0V8oTxjEzscGB2s5Ps/c2aoycC8OAuJvxjIAGI8YDdmOufv+/b84TJpEx5GOI+G4m6+uawqePJS9n1iIH4Z82fGb1I/B/of2hITPEKLWKrmcBfDf+Gzr1aiHsIIOloPv9AkOs1JtD+WfxZyh8tGgEMuUmebO7svgbGmkRnDRJreKu47kLwmY0pn/p4ChD0CnTIvocuQIrVJm2t6bngXB2TULZbUp6LW8YIKO4WOOQ8OQoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uwNEjDbhRHCRqTNBlxBEoKamUpUx2iMqtTtefTFWj17+46d3ksD4G/NkHIrSC3GP5TnNeM6dyq5pZtKRKpMkhzLVOlnYoFks07bvAaBPNc3t06W6WvagWLTuZMIdZA2XwzzSZoxSCeeF58uro/qkiA9HP0ZVpyAjZMy9xpznVmHKJKQ+2pP9xSWA+ZDfP/pXfBUSvhpxuQ6y9up4gdnGMhdkEBZh1ZSKwkD8dQ1OoRKBsJWAl0xm7Y559R7vLOItZoI66pDAHobqBs8PfUqIps2ymZ+0VEDZ0bCY0JbfbwTWoCuK6sfz0ztfK786OzY1teaX5d8XDwo+QXx46N3+oK10zSulT2ymMUMAcPytJZSoZChplfWoM2GFriGZk/mFaGRXVMHPTKu+vLthNPgQrIiOlzpbFiK5wNrriLSKehoKsIKmpxFSqZbJgh8YmlMIowogyIAv4j+qDeMIs3ahfCKrdGRE4hcm2Kx2tXC19aXwl2jnygo8Ea9TV5UHWGGeYvuC4wc/ByqyXcEkdsyn+v9ywRxs0MpaAjpV7BOgGUyeZ3gBazyX5RgTvNwBfX5SAyXciLmCsy/QUi7e94TeeRCN9lIAj6ldDZ7qgn870Ko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcde53f9-fc3a-48e5-2f7f-08dedcbaa889
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 06:32:18.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZsNb1lsVfiYFCSJNujaUtRni4ck2QV1KoEgpjGyFBswHAjbcZA8uVt8fXib7qc+iCOEI+xnkgIykPscwpBPvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1D715CB68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607080060
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA2MCBTYWx0ZWRfXy7kWla/Nhv1D
 5l0A/fg2frNTQ+InPCJQ4gCiFHx2xZ9vwO2EL/Z0z+Qb57O5Zur5Pc1CeF9uqSDIxBxmbCzdhuW
 J2al/mzRjm1fOgRzcMhh6px3IWJOLpSM9i7MIGEOLghS7FbLGVy+
X-Authority-Analysis: v=2.4 cv=QP1YgALL c=1 sm=1 tr=0 ts=6a4deefa b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=if36w9Ke4HYZayhaxEIA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: TsX5RENNe1wWngntVY0cetDKHpiMTc8l
X-Proofpoint-ORIG-GUID: TsX5RENNe1wWngntVY0cetDKHpiMTc8l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA2MCBTYWx0ZWRfX6wkpIdt1XxJ6
 8KauF1ieuGU+t/fhPJJALFkox2qrqApUu7BAVIhBT7I/Wex3uhpDBQExrz6ELGoxgRgdrwbuzdB
 FiBSu3TrZnAemlqrtT/fY1s7HaEb+1INmhj3BAp0CyuBuh8K9dSTN3mg9XSzBT0CRVnE1TdHXJg
 1duIWXtLuGx6iABnCaVRraKnQb1h70jj1S49UPmKs1zvfYcus42HV/mvYDgKf8Crt2OMxy7rEdx
 BPguNAqIsIyVJxcxPM2u9CMRSbB1X1OGf5w7iAAC/szngiTnA1bYsdN7uNSBwd0YrxPQALzqUib
 r1a0AG7KNSWzbpoPNGreof8e265n4NOnQuj7tF9T7v9icma8QudZi4ad7pYXXVVOb9CiBEzeYgE
 Xy8QoEep1tvRpLiL1SwvZpUi97tk814Sp7KIT1rxJfB1kVOYONr2BQ27rGm97IlZshp7o7FGol/
 wA92FtgMbeUQs5YY5cw==

On 07/07/2026 04:03, Yang Xiuwei wrote:
> sd_set_special_bvec() allocates a special payload page for UNMAP and
> WRITE SAME commands. If scsi_alloc_sgtables() fails afterward in
> sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(), the SCSI
> midlayer does not call uninit_command() because RQF_DONTPREP is not
> set yet, leaking the page.
> 
> Call sd_uninit_command() on error, and clear RQF_SPECIAL_PAYLOAD after
> freeing the page.
> 
> Fixes: 81d926e8b552 ("sd: split sd_setup_discard_cmnd")
> Reviewed-by: Damien Le Moal<dlemoal@kernel.org>
> Signed-off-by: Yang Xiuwei<yangxiuwei@kylinos.cn>

Reviewed-by: John Garry <john.g.garry@oracle.com>

