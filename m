Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE437CD49
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 09:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776330746; cv=fail; b=Jr02fVqubcK4Lv9Rhp2nSwmylQUTsbaG81JbbLcNOi8jAZFcs4pRihb7k49hTTwi5XE2CQjzyG0YxWGrPe6DriSVkv2jqtcSjqADJR+0LGeYYRYVMyJSmnF0Gjn+z8LOZTiHqgRs3X2N7jggBGlff8vruH7aXtOufIWjr5tPOEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776330746; c=relaxed/simple;
	bh=hB8DeK+x6fMFXAPWmnkyajn5YSXScu6sGWZqS47koGg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ebkIuboOvOrcfFSqzPrlIrWrpPPriVhjktsw92c0hOMgx05QX0XKvd/P/qax1z3GmpfsiLe7tXGwji58ZK/vkG8F8foKrR/Tsx5hSRtBTydNRVZzczMValc5nzbsPLmAx0Xou53pqxyRe5rasEWTekQTePZWTGfpEWM8kXjiJ4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J4Vzbwje; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rNQ3APst; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4Vzbwje";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rNQ3APst"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G5asMn1346498;
	Thu, 16 Apr 2026 09:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EASlZ3zAh5sf6t9GV/8qmkJjtQGAuNMtAiyEQ4TM7kM=; b=
	J4VzbwjeERxkT8YH12Jh7dZFDxAmHcRpyv9jyoEN2EUKOQnv4uBelqMwbzAVR5mR
	DAgRqv59eumsQbnqD9MhVLysTuEpii19WpZ6WOBZM2ctcAR4Y9x1QAxbLf8fqzYt
	nA13CrGEW/w0GVOYDtfQcib6AeI4lcHeDcnMOc0OwIllVuHPJjPrMnzuttG6MVWA
	bmt4gN6otqq/5Bx+vcQLzOCcy/naeT//d4d52oVIpWneWkfFY30aE0AsT1IgAqdN
	ahSAEr+5j4TLULsjiyyoPRd47gslYzN6zMyIVcyyALjQtVYyPINEGxnQQ+crTcQg
	m2oKG2D+L9te/llPrpaIyA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h71yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 09:12:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63G99XmJ037160;
	Thu, 16 Apr 2026 09:12:08 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7np8dy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 09:12:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJckA3oPo5+v1nupAAeLdYFnkRXd2povgrebdnit2eg/cpnf+DRCSEE9lmw1yxupklJ0CrAB6oEkXCOghLFg12ZMAxuWpLlciC6Tn0DjnoYnhXtYxTo8B6UGiLFhAV/XSotucMIFmoUMrcTu9Xfsu8MN0yzKgPIkvbvPV+a2TkUpZUP3RU5TsB4hJ1byIEoRpsfJHBq3X36LCAm6mMV/kv8xd5QFQPB3q2H8qhXurY4k/4/CM4Aakwu3CDC31qXIU6viQ05GlfPnYOFPJoIfFejU5LwJx+x0TlxZHwErT5gzgHubJ/kGaiAfawcIuiL0voZnnW/c4+Qzv+l9Tdwq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EASlZ3zAh5sf6t9GV/8qmkJjtQGAuNMtAiyEQ4TM7kM=;
 b=DSid3mhJtRO0dpUJw3oyGTlb7PwZlce8/gDvoeGsZRplrX0nfP1Wf+S+Ar/r/+TLMqlzISsvQTsfWif63OcWQORDAKU3MUavvnbVS99nOm3Scxw+RR/uD3A0355qx7Hdy7ANDHlLxHQjdJGhvJIsBqaoRNLEZTlPaGRwGE/qEn9nrVXUdOiYyfTkHbuwZxMZagFYZAAgKtN4u6slQsl3USnOo+av0t4cSfyz0ldwNZ8J72DQ2DrRwG94YN2yiJ2dw7lpu+1ScGLz3nrMss2bbOaniKJTp9I+MNh8kWiXj5IPrbdVGm7lN4cMY/cC25ISG+6ijfZ94oIsN8rBgOEuNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EASlZ3zAh5sf6t9GV/8qmkJjtQGAuNMtAiyEQ4TM7kM=;
 b=rNQ3APst6aq3npCAhdfLZ/5ljEUYT/KXP8TiNuHVgYcrf6fGdfUjTd9p2mI9z91QFz4kDOgkCPcUpSMpQGAxpZ4ig8F3vdSFXRsjslCsXCD7JRu+38BlKKBePHtKGjcNuXKhcEbd4vw0na3MS24kj6Y8Rg8BDtLug1cmLmflkpc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF194C7D93E.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d0e) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Thu, 16 Apr
 2026 09:12:05 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 09:12:05 +0000
Message-ID: <d0e8b978-d515-4b12-92df-35fe451a5c65@oracle.com>
Date: Thu, 16 Apr 2026 10:12:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
To: JiangJianJun <jiangjianjun3@huawei.com>
Cc: bvanassche@acm.org, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <53fcb929-2f19-4702-80f1-1aa059b308fb@oracle.com>
 <20260416023056.3366514-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260416023056.3366514-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0255.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF194C7D93E:EE_
X-MS-Office365-Filtering-Correlation-Id: 6deade20-8fca-4998-dcae-08de9b983a55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mHvyqLL9Hcp+doGpS0W/c6E/OLuiztS5Xy7QT9cPAu9d4QR0ymM2BEYTNmcPNGn8NkwGkn230Or+pkMCvMeAHZs5JauGusWtQyeRzb2UFwW5O/U5f5rCQa5gKWnX9GFNpIG5CLf8EjtIEOqa9QYY3A/Po47wvl8Vh5Qf5KpBMlOWUUwwLWLqK3b3vtDUKP4ClZMKngGHPRCcj+s9WKW6Dyc8VZUOe0CcssesICWJBelAghyi5K2WXjUXyVkIxCebSkIJGSBR3KjXcY2zUHYodqjZdEXE8TxOZ6DV4b5RrlxcqN2JEW9orJ9pXmvnWnxf5g8hn1I2r2Bcw8ZomwhefYGsds/UQSebdfY8bKeqymfai6wedovdHO5IDHJ9U87dCPnVji3nsLWUvtpV7cB4Ggj6lHNrPHSOecJ54+ncahitGd2SK05R7yOp6FDTMZKH5OtI2od3S8QthRowL7E6W2U9NQYhPZTOUrdqdMTUq4PfYNGfdSpKHrmt30/SX1lFsWP8hPrkGz5FWrF1x0D/KADlXF0AGzlphzIo8puVa2WawvUn9u44n/jv6ZX9tr9Z2TGw6xGudiZuxovBuWkKs3v0QRS2fgAvVVqHwz/P5ghYYS5ljGKx0wbv+jE39Gcuv6PK0hBCJsUy3SOlK3v15ytr6n6sScL0uGnMLQHdyBq53VcIpmGCr5hb8CTv/cIZfzSBzsyAx1RJjndpt10B3yvTMNL+TlEau8Yi+4ZuSSU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V281QzRYejJEbGd4UThLOG5zMjM3eVp1OUZhbUdZR2tlaER5M09sMEdQbjRm?=
 =?utf-8?B?cVFObEZ5QVJtNkpuTzBNL3B0WDlaMTEzSysvZnZGT1Bsck5RbUJyOHB1OWFW?=
 =?utf-8?B?ZDFhUUFXM2pQRmlvdVA0R2NCK0hFZ1RrbGJWdEpObkprOUthRDlYVnBGcldN?=
 =?utf-8?B?bVNHdDUwT3lWYzl1eFQ4d1BMODRpd0k1RDRUaGNwQm82N0FnOUh5cDlVSlF5?=
 =?utf-8?B?Wi9obU0vUmVCTkN3bGNWNGtWMmpJYWFmajZiOU91UkV3V3cyOTdtREhuRUVh?=
 =?utf-8?B?bE1MQzc0N0FSU0xwME5DZXBpbTdwYXI0ejYzMG5zQXBqMVBHZVdNc2I5a1ln?=
 =?utf-8?B?N1UyY2dWTVpncFhGd28wNWZDNDJ6Sk9rWGZsb0kzdUlxeHRlZHUrRUthV1ZJ?=
 =?utf-8?B?R0R3NXFHT0FYTHMvU0JHdHZBQ0k3YnhjSm16dVQ0Rk1IL0tHS2tuV3dxMlRM?=
 =?utf-8?B?cU1PUzFkUVVGdEFUMDBTUHliMlFaUVVsOGYzVHpyd0pnbkJzSnBSOGNxSm5r?=
 =?utf-8?B?UU50VzU1dHBuMFlpUHdtdHVwWThUMXpla3dvUGdtZlJ6TndXVkRCZVI5S0N4?=
 =?utf-8?B?dVRKdDVGbVpkYlJ0L2wvNVJyL3NQUmsrODMxN1ltdnltcHlWK0Q1OGZmQmhu?=
 =?utf-8?B?WlN4SXpDd2lKazkyT1FuV1pmTTlDQWZQdGg4TUFLVzZjemFrOWZWMUl0KytH?=
 =?utf-8?B?aHgvRW1ocHQxdzJVUk56cldKSFcvUHJBMGFJWEVHOG03Q1VicWkvTHNtQVNq?=
 =?utf-8?B?L3U2b0ZXK1NnY2R6TSttTThZVlQ3U1dteE1PdFpjaERKWUlsaUtoaUltS1o4?=
 =?utf-8?B?dW5EQm9FaGtlai9WdTBoZjhVNnF4NEZ3YTcyOUo0Ty9FN0NqSzhHSm9BL1RD?=
 =?utf-8?B?c3JielZGNEk1ck5CTHo1Mk1QcFdBemcxRyswN3BVUjlHSnVGaGQ4RFdpRW5E?=
 =?utf-8?B?RTlhL0NsYS9KOUVlMFptd1BsL1ZuYitzOEZLMHEyc0xlRkZVTkZCanlvbU41?=
 =?utf-8?B?aWxSR2NkT29UVU1NTndvVldxSGU2a2ZDeW1qMytFY1U0RHRDMVNPS0FwKzg0?=
 =?utf-8?B?NEJzTk0rVnlDb2JnZmNtRHhYWXlpOWR1cmhpUWFkV1hjOUQySFVFaW0xT2tL?=
 =?utf-8?B?czNaRTFwWVJpYUFDRkxIYzBBUzNZZ2tyZUxsRHJYT1BCaWFSVDM5ZDMvRFVv?=
 =?utf-8?B?K0FUK1pPMThzRjdXQXdvbTNaZ3lLaUFtNHoxRXF3Sy9zTzd0OHdSWk0rNnR2?=
 =?utf-8?B?NTNab3EyN2JHdE5TU0l3ZEJJdHcvTXpYSkpjQ2c4OWtHU3hkQnVtTEV0SUdH?=
 =?utf-8?B?MFF1T3FDUXZZaGxRS28zSUxYOW1pUU0yc1ZXTFB0dUVIM3RReXhWZmkva0M3?=
 =?utf-8?B?N0tDbVVjKzR1eExyWFJyMGREWVJJdXdFazhQVldoa0JIbGdTY3JXdmdBbnhr?=
 =?utf-8?B?SVhZeTBKV1pVZ0R6VzFBMlpqUUFSU3IvNEt0UzcyR0tuQlJXQS8wR1FQdExi?=
 =?utf-8?B?RnNCeGZrWlFxdkkySFgyZlV4SDIxTjJzdUZIS3czbVlWcmw2a3ZIZ2g2dW1B?=
 =?utf-8?B?bkdpRWUvRjh3ZU9xeDkyMEJCYk5qbWJ0dXBzZ0M4TzVzTmNRaDFyYVZLRFU5?=
 =?utf-8?B?amE4WnB6eUZWWU1RVHJrb2x0bkgzQmx1K2ZXbW5xS0VoekFhdU95UkpTWkxQ?=
 =?utf-8?B?ZHBWZ3BGejFKdnpkSURVTkQ5RG5xOU1XVmY4NHcrVi9UalNKMGh1MGFEaEhy?=
 =?utf-8?B?WitjbVkxTEVnYmQzVTZrV3ZXQmlnYW5JcXYzVjh2ZnNjRktuTWZLamtJTk5O?=
 =?utf-8?B?bG1zc0M4bTUzQjlPbXBuajdpcWlVcnF0VVFtdXN1MUNjcUU3VDJ1MGFoY1dD?=
 =?utf-8?B?TDFPdVYvaFArWDlrOVFFcTl1QXI2VjlNR2s5Q3VMRmNkRHdlREp1VkwyU3BH?=
 =?utf-8?B?NExPd2R2bTZ4WTZncDdnZEZjbzNrL3I3SGVsdXFLQ0lFMGVMM25wekY1anRi?=
 =?utf-8?B?WDFVWHpUSnI0T3NvT3NYVlZFNjV1TkkwRTBWOUwwck42UTFMbFdicEFvekZx?=
 =?utf-8?B?enUwY1d0MjNiOWhwZ2QxOFp2c2l5ei9PQXBjVzZLQUJrR3AxZHB0U2JFYTZ1?=
 =?utf-8?B?TXZwSkVIbWYvWFc0VkcvaGFvc2d5RHNvcDdDRlpsamc3NXVjVWF6ampjUjA2?=
 =?utf-8?B?aDVvR09BTFVnaU9JLzhROHE1WndpY2VCWW01SHN3cWdXRHFkZkY4RHVxcUtj?=
 =?utf-8?B?c3VaZ3VGOWl3NGpVN0ZQd2dGVDI3dFBkUDdsdzZYVlJtaFFGdGlxazI2Vko0?=
 =?utf-8?B?ZG9sUTRya1hVQWpDZmh5OUtBZFNxbFNiS2tFVEpKNnUyTnMxRkpHUT09?=
X-Exchange-RoutingPolicyChecked:
	t2OgOr9HeM99DFk9CR54tlaDH+s28YBhZpF3PJdgbBqy1gZGbsAK6AYWB0x2G3QkUi/lYJDPD9d7fob9uIRomy7UfF7Q2OQOasngtjHY5QddMVSPxyD0L6eyM4Ml7Cvx5yhrdM9M0o7FQufX9Gkvcm5xTk3jHHjZETaVnbymk8Pm0i+0Q4NPP+fKU8i9E7xQOHuvs3kEIWqFTbXTEx/BYb+/icc/VmDez0hNPqaMLl5aSCTjhkWC8SmPlVUd5Uqm8zCUasOi8fdoaEcijVIsYWIvT0EHIYy8/nxhXb1824v+VNbaasNB5owbbnClGXhdKzNnVlvBviSg5eWNpmjTOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vRs/DhkGKsNcTLdmINSwDB+Mi8voY6oG70mxDqgJ2oarQkd0RdYzscX/MebW6N780LL6cVzEoMPQf+mQq5ltr03WBBq7GIbAahl45gt9YRPBryEl5HF/4/n+ZTWE6hd3ROIk+7Nixihy5Rb83fz/kVhlh00v75XejvPDHBaTsGGuMr+BttbqVwEhp1PVrhyH0GvqzxfyAgU6YDGN8u67flwqWFfLMTX/uAg8JR/Uec8QsDW1FFQGphS1luK5/1S03c1Kj1IfGgzk1Ik6fzS0EYfLzf7Sy0gn66V4066Jz3G+mSOTU/dBQb5UNut/hhvxIZr2idRbq3AObwKp4H1YL8hMIkrTOcDGU0xSPCb7eTq6S+H5T9oK+gs2D42MqKzExcOVqmtVBx5K4HMC5ee3Hm0icwbhjHXvHNDQvJFAKBzHwcqND29rNdP33rnRsEvGXzQBFEi1QMDfcUhXxdF/JCh1P527QFX/vcStVJagtudqaeYHPIeiz1JLlzorxBAaL0MzdnIttWSL9T7lFsRYCs8F9/uW4ZucJQOyWve7BYOVb6CTdcJJSayQHUSgarJIHUOMcep5TCZnWArrOteclk/M4gTRmlvN0XP4N12N7g8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6deade20-8fca-4998-dcae-08de9b983a55
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 09:12:05.1552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nhG6sJ6RNe9BwT8TUQ0c2FCFA7Sc1aJiO23/btGm44xI9B+3xsSI8F7uL2qrHUg2aIx6N6ocfOYych2QMQNqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF194C7D93E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=985 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604160086
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69e0a7e9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=4Y8m8IjLhCCnmwZcSYMA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12292
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA4NiBTYWx0ZWRfX/m04YdV1pFqI
 XyN6HnGHSAfld1WK9ugvPIsykmoAKOQlpMag1kapgtJY8+drOdv/YpXCO8xjecGOgEeSwWJTNq+
 //5IjhFf/3MBtWga6Ow0uSDKhFZqGQdBUpAO9ftbG4g+PXlnQqlTEtUOSzkFWz6/v2Z3sLv+KNh
 dfvPHRRxKNccWB/S0Imzx7PXoaaxMHPasRuuTUAuow22NrEFNVqQfbcxBFUArZeINkPc66L6VXB
 WugvUKzmSx/uYqIFkfSefhMkYNxnuUJWh1/2z6dSanS60MlHXe0gULXYiztsDewSZrXipFg95+4
 SrQ+bAn/NN4PpopPX1hozFSCrucTrhdvh9Yllt2I1QnRFh3RKbPt5HE9F93u8ij2l1WfHz91g/8
 8soglt2pjsFaKTzlkPj52PFofRQLcS8Otqg+KWZRihsUUESSKmIob+1JHsJzcYssgNOVjYI8Eu9
 3L+c/IdGceCL/PswEvkscKxgIzQPS3q9fMc1pHO8=
X-Proofpoint-ORIG-GUID: Ot43BooJKEvH3d3dJXwPAZwcK7OHQwCZ
X-Proofpoint-GUID: Ot43BooJKEvH3d3dJXwPAZwcK7OHQwCZ

On 16/04/2026 03:30, JiangJianJun wrote:
>>>
>>> John,
>>>
>>>> Can you please consider picking up the first 3 patches in this series?
>>>
>>> Patches 1-3 applied to 6.20/scsi-staging, thanks!
>>>
>>
>> Thanks
>>
>> @JiangJianJun, can you please check the other patches?
> 
> Sorry for sending this email late.
> That's great! I have checked the func, thanks!
> 
> 

You seen to respond quicker than 5 months.

Martin has merged 1-3/6 in this series, as above. If you want the rest - 
which are the ones which matter to you - then you can repost them.

John
