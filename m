Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F4F342CBA
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 07:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779350102; cv=fail; b=FI1H7hXHPhv+YrzIMX1hP2fikUEgVBjtCPCwIb3mROP5jrIqIxt7zY3Ifylnm3YO2hqUqvzbsPt+FJfsjZ0wkoDf2mwdBiFpfkAzZ3lUwTKWaIVdJyBTK+ZE8Nx6Jx+IK4nu3zssOoNbc9k8yW+z0bBnoUGe/qu4UTpFdjccT0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779350102; c=relaxed/simple;
	bh=3gOWCKqDeioKA9yIc8Jg8ZChgWGP8ST36itNWCOu2zU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FyeKHUYn5rYOY+I7EhKBs8fe4zRRIv2KXS7p1Wvhl1SNxlM47/qKnRPny9aDJIV9tRYEbFiy1yabT3mypeHYeljmNloyFYtIr3fwapNSw3BWKaP584djTTJgRV5mDXHp4n2phIGZsdLIF2murKqWHcgY6tyfXmNbLX+cVjwWgxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q0Ir64AA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z7Vunlnl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q0Ir64AA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z7Vunlnl"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L2Uq7J012454;
	Thu, 21 May 2026 07:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GSOcBcUm5M8uk8pekdfvAUiYx/mmT9Lk9eAcYjQVim8=; b=
	q0Ir64AAG4tOJ4lp8zx2m7SB3STFi3VD3BoUFStK6ndabSZbt+SLGUT+NK3RdjEg
	QLLyOqc+PuIap9ut5WEKSNefgl6rW0er1CW+yGysxAxSNrXut2xvxqTPFpjUFMc0
	5gxIVShlpw7Q1YcRofo/IL7IwzFcUPVNDYcWcpRsr1FltfxanhC30vRZZMEgBVte
	GmlB9FNfusTmshZhdevG85XBLqUPwMeXRhtRz8bzxdeCaQkUg0wqx0M5V2CJhtV2
	zyukETUzn/Yf/B4i9GzGPlOJeLgonVONurrWRKi8HFQ/KyG7Qi4zphSOJlD5h/6v
	3To3M80bE+Y9WS9RGJx1RQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t0ven-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 07:54:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64L7skoe021687;
	Thu, 21 May 2026 07:54:52 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011012.outbound.protection.outlook.com [52.101.57.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e84eet4eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 07:54:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdLqe3T/PXbv7NYHTB7ek3ybP1ilQbJqSlzqE92r92k6fZE+TPp6e1aFVxPIV+aoqiSxvUKzwDODM6vb7x6fq8vsf+akwLh3rZXlRER8/yRWCdZU4F0KbSwiYwFs+PKdjZ6QjMbM740ujiI7ZoWhOtBLU1jUgw+5y7YxCdr033w9WCnjPbKrM614t1YK+a5pgr6UfmZvKkLG9gXR65O7Bd03Af1JY3h3zD8hmiHffnw1kXb5BcqpsyLNqqi267HW6U/yN1D5egjqMUOafQvJzPO8MGfC69yjEtmJPHXUiBBpd2fNZ1VeewfqH1R/FGox6CrVih5Da+V4xxZ5G8Rwiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GSOcBcUm5M8uk8pekdfvAUiYx/mmT9Lk9eAcYjQVim8=;
 b=ef354EFX2OaTM/j+Vu+RB0QeNla0Vnnix9ucHoY0CkjKV6/OO8NJBmtW9/3uPXWlyFGbS86FV0/pBt8aOlsDa3QuKVn/bZaNCHQkEOkaARQLLIxH2W4f86mY+iPp2RVrbaQ6/468ytTTi8FgMYZvu4D3HbhO9u+DZX9SgGjRZM6BTqDyepGPzX4N5Xh5fQqr6zvhHjjEVo8j8zpmUVFCwNf78qwlI26+vFgT9ExrhoxHdxItB1urLijUsBpAIh6mduU+bryGYMxhZYE7fqrLe2LyOHrjLDZTi6coFfqvkl8XZ1cJezso9LVkMOOrQtoy6H4EOvyAmsdaBXATyYHJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSOcBcUm5M8uk8pekdfvAUiYx/mmT9Lk9eAcYjQVim8=;
 b=z7Vunlnlpu0GfciWx8SERSLgRFTRpJz3UDCA8Xk2ozyWdS5eeNcCGeBx/xASTteUPrczfcm4+jFHZv2Jg4T3wSzI8vvkkt8YWW6F8DCDAELzwV0E8DEILJqxOkOHT9VK/xpDfIcex/6WqJGQqAa7L3DXMuNQu9pFm6GiD1w1SHA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4223.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Thu, 21 May
 2026 07:54:50 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Thu, 21 May 2026
 07:54:50 +0000
Message-ID: <730a24fe-4007-4dde-adb4-af640973d9b2@oracle.com>
Date: Thu, 21 May 2026 08:54:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Remove the set-but-not-used variable
 "sdebug_any_injecting_opt"
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nathan Chancellor <nathan@kernel.org>
References: <20260520171454.4035623-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260520171454.4035623-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::27) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a30af2-779d-4bf8-23f3-08deb70e3c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	2V/vulDRSAeq2+mx0/ZGvKp5v1BPY5KntyXeuGdQyO7kCpgLSzIXsUmMEYlggUAcaPJkoHFqfQ0IaDO9HZ1AycK2Of5jSRroXlMsJCsPy7MIsA5s9usz6fpCm1dKkh+mb+ZM89mhhjBICZc5C0it5MI3uMYb80fBCnliWAiDk/KT9BONw4Fh71tl0JYs9flNnwgWX7tvJn1nKVpYFwJV86P+jsHsneQWMF7ljj+ZmCNsw6TEqhEBs5ZsF1U1BhJafTW1VpvaBIo+1/n51UT7FOEbrTp+BVz+/ZYrwgteEssiHtg9FwRvisJFPhQjBlTeQiM/PUzQZikQ7sr8u8XgUfgGKvs4FKqTE5t/TrRUqh2K9iITF0O4FUhyfqtey7plVP9R68SuQyIJCoYWj1OkC8vrSrQmn3189h70gpEp5O60mOiaawVpgtb2Bx70JgmDr/qHXEfPOXNQQA8gB6dOyXd9s01X59UpvU4yfD9EI4mFUejC2gLUmE1lQDXytZCvRxIME5YVBH/6FOoBQ7wyinEp0nyUyh2Ajd6CZnAUwlSwcncPEIon4QUhtmtGs0Em4P98lFuuoFS0Ai6q2MKFbU4IEPDDegnqXP8L4/QQr3PWFSA7Kgtcv6brrS8NSc0TXGJs3+++Uce1VdRcBu7pRcMH5D0ksEdo26q6PvUA5swF/77l8qVIDcGhYmlmgsV7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnYvZVRTeERqc0M4Ry8wRHdySDFMTjVSQjduN1Y2RFNBYXN4VVM1blAwZkpD?=
 =?utf-8?B?Y0gxOGZITzh4Z3hxalBVTXRVeVZ2ZjMrWitQNFc4UFVRVWtBNFhoaDl5dHNu?=
 =?utf-8?B?ejh4eGtvbCt1TldKWkM0NnRDOVRHNlhRRHBDZGZHUjhnMUI2L1gzY2J5RzFy?=
 =?utf-8?B?NkRycElydjZ3aDUzU1NYbkZLQXFXL2RBUUc0aGN1RzlnclBUZWZMUVlWZ3Iz?=
 =?utf-8?B?ZXNVcy8reVhQUytTdW4vbkhQeWtTMnliVzdwc3ZkWHRNdWsxL3JWVEJGVEIx?=
 =?utf-8?B?QXBNRkNWT0Q4YVJwR280NnpSbVJjQzcyMFRBa29qYi9STHNGNEhqWDR6V2R2?=
 =?utf-8?B?b09XNjZSUTV2cUk1ZmFYWUxtRkU2V0lvSTBhL3M0NElLeVdQUFFXRkRVenBj?=
 =?utf-8?B?dGFBbzd4aW1zK0dLeEQ3R2s1WXhrQ0ZyTmN3SjA2SlFaOGRTRko5UmkvVHFM?=
 =?utf-8?B?aHZPWER4V1pUMS82OXBZTytSSGt0cGVWVWxCSGJYM1JBdTVTVU1KSDZJRnlj?=
 =?utf-8?B?dkJYblNUcFJ0Y0FYYkFwSkFmNm04NjFUU3U4bkt2eW4yckExK3pVSzRCZldW?=
 =?utf-8?B?UGFKQ1hEWG9uQXh1eUttdU1uUytQMzdvQTEzS29rQURhdGdNUGdaQVVrZjBO?=
 =?utf-8?B?OGt4eFVpVVFZZVdYVGtBRHJqM1R4cXR0eG52SDJyQSs2TW94Y1JDVnFFQ0h5?=
 =?utf-8?B?UTcyRTVjTVQxQTkxakd2RFFleDBWeDBva0Y5S0doODJ3RjBJR29FbnhiRitx?=
 =?utf-8?B?alhiNVM2L3dtT0xOdHlIVDJwMStEdVVzLzAxeDY4ZXpUQWhiRm5UanpCcGJB?=
 =?utf-8?B?Z2JvckVReXpUMkNLdmJ3ZS9uSVVoeFVleUZDY3A2c0RVU2xTelM5WXM5Rnc0?=
 =?utf-8?B?SjBJVjFVNXBNT3Y5c1M2KzZEczBSV21ObUZuK0xoOCswUXFoUWRIWnVmd0g2?=
 =?utf-8?B?VjF6UWViT09EV1N5MEova1NIL2x1TFVrRmJhcDJjdDhCMTUzVmRUSm0vdlFT?=
 =?utf-8?B?ZDJ5V3htbFNNVHJISlZsMTVpK2MyL0psS0c2MUl2cDVxbExzTHdVOWRkZG4r?=
 =?utf-8?B?a2R4ZHYzVUFQOWRyRGVvandQQ0NEN3M2enltdVNVcEpoMHQya0JwdzNlWXNY?=
 =?utf-8?B?b0JVTGYvdlJZMWlRc1ovNnl5cnpVb3Fkemt6RlkySTRxam1iYVQram0vOU02?=
 =?utf-8?B?Ukl2aThPSjZOeGwxR2VJaW4xM3VGMldPYXRRU1pEL0tRVmdDd1ppYVNmUDBn?=
 =?utf-8?B?ODlJd1ptOVRyTE5TN2k0elo2RlRNUXl2Tm1kTmtvQ2R5d2hiUWk0RVFNSTcw?=
 =?utf-8?B?OVV5MVlIU1hVUFBpcisvOGlySGtZWkZaN3NLay9PNzNCNm4wcmg2KzdSMjlU?=
 =?utf-8?B?ZG81bGF4WW0zNExYV0J4bE1wMVE3ZU9xd3B3ai9mNFpRbnpOc0duc0JwTFJK?=
 =?utf-8?B?S0l3YWlCOVdUM0MvRmtjRVRwNldpOENVdXdiTllMZFZWU0R2K2wxWlZLUkdP?=
 =?utf-8?B?UWh2dFZ1N2dZMFJ6WE9WYnBwaG4vQytrbWlScGlWVEEzcjYvQTRocmhwT0dT?=
 =?utf-8?B?alRiSlRuN1kxSlYxMUpxb2F0RmVXbE1QVzJ5Sm5tand2NWxKbEMxSHdPNTh6?=
 =?utf-8?B?aXRqT2dyUHpIVW1XNTF6TVVaNFA3N0l6Yi9HWFVGbXk1cXl6SWl0M2NRVUsv?=
 =?utf-8?B?ZDQxZ20xaHU1aDRBNSt6TnFmRUJWNDZQa3dPVnN6NVdWckpYNG5yRFR1SU9r?=
 =?utf-8?B?RE94U1UzUW5BUWtVM3RHWjNVSVZ5RkwxL1pHRUZ1YWlPaGMrZk9MSGNZODRB?=
 =?utf-8?B?T0R0Rmxqa00wK0szWWZLWlFXVnQyWlJ3eWp2SWx0TXhIb1YwTXpDc3Vlejk0?=
 =?utf-8?B?dGtxVkN6bTFFT2Z0VjR2dXpBUFFybUNMOW1GS1ZPcWl0M1lKTkdySE13UGJG?=
 =?utf-8?B?a3J5NjBxRHk2OXlVbTNXVnM4YTAzREhmNzRKVzVySThSUEU2TUFWZGlKeUpI?=
 =?utf-8?B?ZDloa2tvVVNVaHpmaVJYbUJVRUJBMVVhNlJHZnBrM1I4QmY1M1M0cDJFMjF6?=
 =?utf-8?B?Q1Q3YmdoRlFpaU40Q2pFWE1qVGs1R0o5dWs3UkE4VkxqZXYyRUkvUHo1ZXg2?=
 =?utf-8?B?MS9PZ1YvcjJSTG9nS05iNDdtNnljaWh1Zkt3RHE3czVOMmNnT0JJdkdvN3dl?=
 =?utf-8?B?U09wK2p3T0VNV2hFRlRWNmo5MGg5T0JTNCt6QWtmUzIrQ2RXQVRoWElLeEp0?=
 =?utf-8?B?UHl0MkpQbjZoMnlJcFErZlFzT0NYdStaZTVHRGdnc0VEa2xPRyt2QVI3Wk0z?=
 =?utf-8?B?K1JqdXd5UzBaajNJb1c4emh5ZVBPbVFpOXhHNEM2M3A2WWN2OENCUT09?=
X-Exchange-RoutingPolicyChecked:
	Dv75ZCU7kssuV8PyK+EhhFBpwP/ORUKBxqt68hwPVHsCzHsqxtjWPgYsmxVdHqfmNCy1mu8FDZwLeRLaC4mzZ9AnAB59i0DKDWdsYcy7OzZjFSrHKuo0WsSVUvgs0lOnXIAUJDIBtOK8LuCDrtJwnnDi1ZKxjlN85bpgoT3xXqVFEf0jEtbPibiXSF17EFiaMhK3WMh8SSAujuwIcobDrytmVbN/tDompIwPzXREUPylUt7sVooM7lNkndn5fsr8z7SdatAryrXyGHJ2vY/peY+Wj3bEkcGUIx+WmiJw2Er+qBVrGrxAJxQLMn6HkCaCGliWnPTVJSzHRgiBGC4lTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+xksnnYwa6t9++tMO+ESgDZ4ZYU1b8O2+dAgqZolQLZlRvnvi0+UpJ+h5f5LUTN5bXh0CiloQXleGk27zlgLQ9xphHSjeVPwsdrNQYkMXZYHjoTZoWzUjB9dxuSiY/76E3ISGd7kJCeJq3CqoGnwsBEpxlcpKoQ2r6eAetWjx1rxzMH3mbtVDVM/dPsnnjGf4RsA5v41qyjEHpvZWplY4xeCWZBwFn6sw5NBh4FxiSZpEYjrkVqNmzCrnajNPl8WNuAgNYisiPOMkSZVX5kdVlpl1UmT6xZ/dWo9GjjM3mJo+eUpkThYp6PG0HPWPsTueZy2X0RvRrXxl9SuR3B9d22dOJE19p1JynC6Zq6NGqoIjjAxTdusZr2QXe+KbottKQabAXQvdJyk6yCwL4xXcjH+nYm3XDEsNgiBCtPb8V2sR6guRvNZEprKR+gkWUn2axAIdnbrV1Jxewl0GmRDA5rUGsITw/HXe8S1JmBdh0ZGFb5poguaWT5Nt+A09XFBkQGdSzYeABCsvsIsH4nVVuo4QA4vonpUPC6dJyKloMjEHg5AkriwS6cSWF6zOl1HFu+0dLxYC88EA74wPFOlxnfaBbXl7Q5EnWvGcimCYr0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a30af2-779d-4bf8-23f3-08deb70e3c4c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 07:54:50.4105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8eU8JmwtRsnOcnJ2kjbDaj8vaHlv/L31FIpfKfWyo1W+E7krd88+pHf7mCC3SC0tL06pFpdzx+4ydyRQyU6Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605210076
X-Proofpoint-GUID: MJ9BrMhPDprDtuVq1R7GLp-Hx2jphMwY
X-Authority-Analysis: v=2.4 cv=d9jFDxjE c=1 sm=1 tr=0 ts=6a0eba4d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=0mlL1PYO3GfcHMNWUR0A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13839
X-Proofpoint-ORIG-GUID: MJ9BrMhPDprDtuVq1R7GLp-Hx2jphMwY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA3NiBTYWx0ZWRfX6GErY8uRrgtu
 gWayAu6RYhMywAg+8tOJdIVT3EZtaiMh3UjJmr285JxVwarwJPsq/siRoGUZ/PrdGj5x8R2kGKb
 lRWhB2+vHuzMhtDf3wwvHRPRc/BvVFe8+rjBW2RoNiW2bOZRlkFOq3YOQKdkVVfyEkVUEWsiv/A
 abALp1eSLvaJX+LQPDt07+6x8iJYzviDb3hp9h5gG3ILKuvQDb7F/xr9ScrwXOx54AbYWhmhvOn
 dpao2PJxVeOr9d9gWLx+R4vEafECTXnyj+uGEu67JQfSGXIUUedkBExjNXQI1j1Y9AOUPFFfQDE
 N85n2m9/ZfJOLwz4mGA6UdhsuSuTBjd95gLwCPGEKLslCWoSVoPZa27qHD9Tf/YMhwbCIJkDudI
 YHwzi1W/LVz7rl7xHkVa9CW8Tz8T3+LE9jc3GBxI6eA6CPhw2B8Rn9A5PetSa94KH6T02u64RcJ
 CYMyvwMHJnbt0HvbOXza3xxc6rldD1tu81w2rNoY=

On 20/05/2026 18:14, Bart Van Assche wrote:
> The static variable sdebug_any_injecting_opt is no longer read. Commit
> 3a90a63d02b8 ("scsi: scsi_debug: every_nth triggered error injection")
> removed all code that reads this variable. Hence, also remove this
> variable itself. Remove SDEBUG_OPT_ALL_INJECTING because there is no
> code left that uses this constant if sdebug_any_injecting_opt is
> removed. This has been detected by building the scsi_debug driver with
> the git HEAD version of Clang and with W=1.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>


Reviewed-by: John Garry <john.g.garry@oracle.com>
