Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7BB388E69
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 08:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776673731; cv=fail; b=ioYzGsh29saGyu44Bd7VpacfRWOpSJW8inRMuaUEsNJhzkE18LmM78UZPLxNyV+MovrpDabMw7D+B92BVprcIPcBbXxvqqV5aSbb05HLni7LqWxC+fC6CKvT3OHLAas03B6VUYGyHJsuzrbeqjeQUJF8JvJ8p9Mba7+41cTSpwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776673731; c=relaxed/simple;
	bh=RDZcPQ4bIgX3tvcaMsLbPI4TS6T11/g0QkU6T62Nexs=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kur8KGI4HLlCCRhFEOTHhkbAzu7Eg6gK5mDwxVZBnDMOdj6UzyytAbvXMuKHcLrQzgq8hjRl4u+CI8FHiV6kO6mdNJjVBqjsf98XnEB72HviGIYRGuIikvgHE85oe1n7LeNtf5LWu6vTsSzj/shsjhr61Gu8hsFKFKRBR0zA6cM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RUuj+iG9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pPBCMTdd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RUuj+iG9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pPBCMTdd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K8QPbk3237242;
	Mon, 20 Apr 2026 08:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oYInac4gJZJLMCNVwq/AvM88Ekv+gklVzVZ6HeNurQo=; b=
	RUuj+iG9UAAt4ZYEGN9KYa16FnSw7GjzDc77ZaNxXc694JEhyvuNVnBhEv0TxVdF
	d8r4iWvDSQ3R++SGLWdfHT9K2FBdJyRCiCddEhv3B8Rf9n0V1wOPoOecVfMU0lIT
	bPy8YYNHNWQxku42XEOdcSBx1oK46W+VnK5PSl6KjaAqQliU1icKJb+5kZD0c6bA
	2RQnJtdb6iMTBkNWzCsb2YerzAT3J7fcVphDm+fzitv3rZIh7M8sq+cVnbUFiXaN
	NmW/3qOl9o+bkKxJP4JjhyqEY2Anfl0w2mdntY994xIH8uU7SRVAK3NFg/NV9wF2
	vPGTuUawUClNBXAG600V4Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2cg2u7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 08:28:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63K8QDHi000732;
	Mon, 20 Apr 2026 08:28:42 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010037.outbound.protection.outlook.com [52.101.61.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn186v170-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 08:28:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GnfYpjpIp7oSLZFsLIqijXjcT7+CqkKOKWe9N7lWipSESBRYem6R3EqaQ808cnZCxV/R/aFVICJ6ETURrGu5/J76eHS0ytsUes6EnZYhlGMwhE9M2IVx6IrCINdJYPBo4LcYEXEjsS3Jl/eQHtPo48qQZIlfc6gWCIS+Fk+LnYFkzX8cKFx+E5mqKjzKW9cOF1Nva8lAUbAm3W8K6YSU8qXeAIsfy400SCz4y0sYTJ0fuhXx9rlxoEIQCwnemDoOWnUvMZHUkkf2p2BNrszNweQXo63YBXT6BW8Rn6083J0boVEySeP2dnRHaligTUldptzk/3w8xCXBphGkW8BnIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYInac4gJZJLMCNVwq/AvM88Ekv+gklVzVZ6HeNurQo=;
 b=sn7ScOCtV8OR/pCVtjdBwCF3ScJcGiQSdEtszMW6far6O6UPlUSQ7YHspjALOWHvWbqSFjT2aSopGc/wTxhReo+/dcTYhBCTLE8Py86ZgPAgh9fAVdrF6db3xJL/uDTp0FUiaY8CtRaisGooLQJOx7YfemZBntZvPstPVMfyMpacWwONOZ78pk0Onc3BaSYycn23JQJIrjqGO/dT7IT2/kyoESkQQWloRCWwe4u31X3qGRyf2CAHCS6MPyuptp0gJk2RGgMcRBrLrYJhbWfYUbies9qKh94r0lGNRpAf+BhZ4sj3LkQpPq1xXriY1/ujuXjOV8KeFa5ucGGhfwoUSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYInac4gJZJLMCNVwq/AvM88Ekv+gklVzVZ6HeNurQo=;
 b=pPBCMTddWnTNCAyrzPGZ8kTxl6n+HAoYlWhoJj7nktEnqBqDhzdRkO8gU9GTtGmAJWLlCKGIJuQDxgpfakCpl4DQ0xPzDwb0IIjkds0LyYg35nX7/OsYNGMSv2gkT+NnPsH9VLBCK36ncErDYSKANdHTW/J9ES7nrJN+RatkQhE=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA2PR10MB4410.namprd10.prod.outlook.com
 (2603:10b6:806:fb::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Mon, 20 Apr
 2026 08:28:39 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Mon, 20 Apr 2026
 08:28:39 +0000
Message-ID: <5c33e4af-0708-479b-92f3-e98c051f92e2@oracle.com>
Date: Mon, 20 Apr 2026 09:28:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Fix can_queue comments
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-2-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260417230751.117836-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA2PR10MB4410:EE_
X-MS-Office365-Filtering-Correlation-Id: bc4f3763-4dfc-4ba5-da4c-08de9eb6d2f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l+9JmIRvxQLQomOqayPqIs8/2tPEFZ+FJ/Eu1YFkE+7P3VIs1RaIacWEztkxpAT+HxQc0fVc2GpRCWjKN2G5pTLD+b6+5JRf6YTuNxxKjFmQehOY/4puUnqoq/akgZbQYF5cB8chOG0LpxYZoybwfO37z4Jj8znfXiYjYsEf1kTL3D+h4ryKEdV/Gg3rxzN8aiVpzeSBj/jCTlTeoM8ajtqEy6aHvEgGIp1Hts5JYRj1axRG1E9U9aQ+Mm02Xr7IfPtB/w84zttWCTaCjGptn3l1TkAwdDDZgAwUrxG8A2nNcqDhvo6M21oPD33D4WK0GzlAFsRydqQY+k0S6OWTpnjPz+dYFVd0cbGWgRz+phEj4DM/Y9qPlJzJoiPv6vrLmxBhodQ9bxW7xsP9Bf3bLn31GVHd/2yWNG9QZsj1zD1M/9cYPAGWDC3sI7isNJWClu4qll6FNRy7PtbzryhPLqT0HowqknofYwfeSqXrEWY50TlRGBHPQ07RiUmAN2bf8XYpVjXFoCHMtskUcAtxPKNTuh40gQNhLoYchnaf2CMZKOwZYKLNeC/iimhzARDED98TKIqvdeHD2tW71xyG44KlDUi8UeIDfaUSdlsuv/6giK9dvdE+gkLGZqrjIgpxK/oTjhZS6oB2PqQBY2FlgXZDsS1f9usUNzWApbIKZZVwBNSkRlII2kqH10bhwX8mj13Nu+o4TK6TUKWpeKYN2VPxfGQxxTulr/u/xTfYkoc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnVUdFYwMHBlek5QNzZHQWExaStEVGNkZXNuMHQ5Y2FIQzllZ0hJSXpjdmV4?=
 =?utf-8?B?VmE0LzBaNUFnRms3d0YzMFU2emFSZG9DNmZnemcyTitjdVNHZyswOU91ZzRI?=
 =?utf-8?B?L1p5dWV2WlE0d1hCbFZSMFhwbVM5dlVablBOUkIxcHQ2bW9RZ3dGNXh2dXZ0?=
 =?utf-8?B?K0xsYithaW9TaDIzWUorYWtzZVkvc3prWDQ5QnlKUkdyTjZaQ2NyN3QzaXcr?=
 =?utf-8?B?Z04rS1lxODF3a3JPWWM2L2piVnN1L3pmbmFCQS9CK0YzQzJ2U25QNFBoMXha?=
 =?utf-8?B?N1lzL3djbXUydXc3M0V5aEJwKzdTUUYxdkJZZ2NtWWxiMGtsSFhHQ1NrS0VT?=
 =?utf-8?B?c1loeFc0NGppQ3lOZUlYZ294TGlSNXBLWmIxbmQ5SmxwQ21FWENsMThEdWhm?=
 =?utf-8?B?MERhb3QxNHVleURuMVJRNjBxQ1JqTURJMzhLdzNyY3lrQysyTWxxZlRmSGha?=
 =?utf-8?B?WGFBQmVKUklyTExEYzNGa1p1ZEoxMTF2VnV3bE1qOVJ1UEVTVWl1RWxPSThh?=
 =?utf-8?B?SWJLUFppUnhaU1VTd0hyKytFNlFrbzI2UHQ3L3N0ZHV4VUxiaVB4UzEyQzNL?=
 =?utf-8?B?U0toS0Z6eXp4UEFJd01STGdxMnd4d1dYckFSbTU1VjM5ZEFMT2FJUm5XWUtD?=
 =?utf-8?B?eFYwQm0wY1g4UzBWMzlWVkVMdWVTR3pSdTI4NFhUbFUwaUFEQjQrYmJqdGh5?=
 =?utf-8?B?YkR1cm54TEZTbVBoZU5jbXRJYXBnc3ZiY3R5UVpsK2F5QlFSSU44MkpKVmxp?=
 =?utf-8?B?aE1aWEhzQW52SjdNMXdYNEFGdDF2aU02TlAzQ2ZrNzlIamFJVGQrd2dQYWNs?=
 =?utf-8?B?Nzd0THY1WStadXh5WDVEUmh4clE0ZUh6SG55bEdnaUJYaG5NekJmOW5PODBt?=
 =?utf-8?B?TXhJaHR3U2xkTVRlTEptSlJvRVhjY09nbW9XZ3NzR0lia2ZBb25TSTJRUElS?=
 =?utf-8?B?bXZaMmNBWm9hL1Fva1pmYzM1cEhiMW5LOXBjU0gzUURCQlljcHkzR3hzUXZp?=
 =?utf-8?B?bWxXS01BNVVOT2JOMGdvTnA0QlVaekt1OFFmWmNFMlZ2aWM5M09ZUlViN3da?=
 =?utf-8?B?RFdpbUhZQUJ3L25taG1EOG04bXNWOHNXUmR0VlFOREx4RVh3VDgxRzVFN296?=
 =?utf-8?B?RWZPMVB6ZHRmTGl2UFVoOUwxQURRR2JWK3dWNmxmOXpzSlhwQlBadkdtR2p0?=
 =?utf-8?B?WDA2b2l5b1VBR2dETnRPcTFvZUZoTTNQUFdUVS9UREJkTmM5UWxQWlh6d2k5?=
 =?utf-8?B?dnVXTi9McWJGR0hFRWc3Wk1jZ1hMZURjYnlsM3U4UExLQS9RUEwyc3BaOWpG?=
 =?utf-8?B?ZmozQlNReEV0Q25pZG9FcGNSVFI1NEs2V0g4NkZYYVlUMlVMR3hiL1FzeFlx?=
 =?utf-8?B?dGJVUUVFSTdyYzE0VzRMYk5mTDRVTHdkK2sxQjd5bGpkWGh2UStiRVlZVzll?=
 =?utf-8?B?SG5LKzJEU1RtRlRzZUQyRzlNeks4NkZZV1dWTmU1bktKNzl0dy9nWWpGd3hl?=
 =?utf-8?B?K1RsN0dncEpHSkRYQjViek11TnhsU1lQNktTOWkwTjYvNVhUSTBRRTlhUFpq?=
 =?utf-8?B?Uk5NOFlyN1ZjMWpuc1BGNWVPWU16ekNhdUxiRnJNY2xvWjA3cE5oc2Z2NXlu?=
 =?utf-8?B?YVJXdXI4TDRmTXNFbTZLY0hmSytwUlVmKy9JeGJ3VGFOUnRtaXU1S2RUL01J?=
 =?utf-8?B?NUxRMFQraVRTZXF3T3IvRW5FTzRGeTBieWV1WE9qUWtTMmRZVGpaV3Q0czFo?=
 =?utf-8?B?bnNWSG83dTNQZEdSa05GK24xT0xadW5GQXNYY2V0Nk1TUHlwRDg3dHBySmo3?=
 =?utf-8?B?bVdFYXl0NWlMM2w0dURqWkdDTHlsN1BuTGhSTnUxWXQxeGRLdXc5elZYY2tO?=
 =?utf-8?B?L2J5SkVZMHhFTE5oNGZ6Yi91MWRMU0g5cXNGVUx3dXVzSGUvdE1VNHI4WThv?=
 =?utf-8?B?UHNPWjdOUlYyUHNVanExUjAxM2srT1ZGaXdDMVBRcGp6MmdCY1BuT1Z2UmpT?=
 =?utf-8?B?WEJIR1MzaDNnNXV2U2xDcFpjenRmUndoL1dwK213dFhYdTQzdHFoamVTNTF0?=
 =?utf-8?B?eCtrSFk0SWNmeUJ6eFkzcWZodEpwdzl6blBhOTJZK0twQW1HTHU0aUJYMVNt?=
 =?utf-8?B?RmZra092QXpHTGF2OUVydVpydUIvRkJuOFJJdWxmbFVqdHBWUnhFZkpTa2xO?=
 =?utf-8?B?M0gvcWRyNVdEUVZoWkxONmJtVTZrWFpKajZ1bXdYUld4VUFTSmdEeFNQMmhC?=
 =?utf-8?B?ZDVCcUV1VEZDYlpFRGNNRlN3MHhxMitrbHRBa3ZVWStCZ0JZRitZbFlGYWs5?=
 =?utf-8?B?YTJGYXBBME5tNUUxNXEvQitrYkR3alFDY0VISGNLNUFrQzFFODVWZz09?=
X-Exchange-RoutingPolicyChecked:
	uHcTsfA73+oJW0+zbaPUzIrLZs8Elpz2wG6jyaVnkn9hcgmuIHgsxNgP6pDa1jOHul0OQ74S9nxUD1GX19WW0RzMMFFN8vsT7WqBfx+z1dVlESlIMud7bkSvcT0Gg11EAOBkzXIcUpaMXjkR8VSpepFl01fT8TYtxsR7FABBZ3DmeiQ38+i2NGFp6yRfHE4PRRHcHFmaqKJmP+XlV38d9o2GCowPs8c4csZN+JZqMddllaxP12YAb+m8Lv68xIiKksYerXinsSm8BDemxrySoNJFeYbeWjAoI7jhVRD93M0AaQw6l7PTLNbbHapCgaVbe0a7bh7oowAoPLakRrr50g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BjQ9bQPjnwAaf3m2wEeZ8ww3WVUMYZKaBJ3Ix13AkZU5pH39fegQ/E8RpQZVmhIT3T5WNNVSJ/dnzBc0fmDbnSDmZFjtJmI9r4TanHzr2mV+0GbQ2m45GHLBXU5ZN2gDw5k8TyxWRLe6T0F+Sm73brGK7cLKJKrAwqHMBNhIYNhwsoI+K5f+QzdvS3/SWxTQDHQ0kyEuqqJWzVm4c+CttcfFtW/eDZCN8WR0VlkBZMxwgTeQvJ4Lo9zTXx7e0XSK9qtLislnJPe+64cz9QxA3NJSBqKggcQi0I/YAZDDnMDgsWqR+boHpw1bOiXU5yZSXzdfj+HyALYW4SrDVNFGbRa2fSQI+zye1rIj0i9zBbvf/Sw+oYQIsDNST1cmYuW9+b1oisOdwInuSULf2hgN5BzB+3HHf3BP1ybBuSa/cLQUhqhiFstghWrRqntbPuR2tD7z71jEhI9QIgcgd0qLD68iArK8sgDpZm9FUxYksDnEn/ApXAf5Ep4BZZ8a9cGBgIoDcsZZiv/k81X6M93t1IqNzhyodun2hFUukv1Now6KwANAZWtWV8CxNQewWaliWUkNnUD6jMMhWdJZFef+LYne3+FgYkOLHVbHB470cSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4f3763-4dfc-4ba5-da4c-08de9eb6d2f7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 08:28:39.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hy1/ltXYPpJHrarn3jUBOOYyFKuyzbY3SsA8JJpjP9rRlLFGBFCoezfC+UMBA2PNA5ixRN5sOSmM2EYZNG+Thg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4410
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604200081
X-Authority-Analysis: v=2.4 cv=F9FnsKhN c=1 sm=1 tr=0 ts=69e5e3bb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=Iyo5V8FXkvmcexUB_qMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FiJr4VpSm81hV1CEg6h-4W9gJZNKZj3W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4MSBTYWx0ZWRfX+OqCSuHBzlS6
 isvPiTOeiFM2BBPkjSi9+vehqvnaDPzQRV5UfmylUbmP76oeZYXKe/h7UGxTnZ31adcyVsg9J01
 gUK19BQwGEqmLYOoBb5GA0oxl4+Vu5wH7Zmf0sepQfsJJInxPOsgrATqcGTslAaBv14bLjKAI2X
 pbj45HSiF2OJ8JRWjUrfjfbv42KQNqK4AZOFZ1wLmAlKbU4SR/XAlUL9+5mk94b0fa3gQyNSdXX
 t68hB2pJq9/IV1oDdxuwUVlDrRweUmdHLKyOz4qBVNcRfeVhFgP+l5NEKi6N03iecpzalCFe1yV
 ZdRbsMfS2Gw0xFuYl9A2Gt09OZErE7vMQTySOgGA2SPfnW+KJNQWPAiGzPTbMRVvzB2df+Vs3TL
 n4Dz1WQp7oN/weyI/TzUnbNAkKajqkD76ASg4LFI43K2G9oYnUj3ioEG5fH0wm21pPoKElHqHy0
 UW9ZpDXDjdAH7N24xSg==
X-Proofpoint-GUID: FiJr4VpSm81hV1CEg6h-4W9gJZNKZj3W

On 17/04/2026 23:57, Mike Christie wrote:
> The Scsi_Host can_queue comment assumes the old pre-mq can_queue use or
> it assumed host_tagset is set. This syncs the scsi_host_template and
> Scsi_Host comment so they are in sync.
> 
> It also redirects the nr_hw_queues comment to can_queue so we only
> have to describe how can_queue and nr_hw_queues are related in one
> place.
> 
> I also dropped the non-interrupt vs interrupt driven comment because it
> doesn't seem to apply anymore.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Regardless of some nitpicking:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   include/scsi/scsi_host.h | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index f6e12565a81d..7c747b566bc3 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -381,10 +381,13 @@ struct scsi_host_template {
>   	const char *proc_name;
>   
>   	/*
> -	 * This determines if we will use a non-interrupt driven
> -	 * or an interrupt driven scheme.  It is set to the maximum number
> -	 * of simultaneous commands a single hw queue in HBA will accept
> -	 * excluding internal commands.
> +	 * If host_tagset is set, this is the maximum number of simultaneous
> +	 * commands the host will accept excluding internal commands.

nit: I'd have "... simultaneous commands the host will accept excluding 
internal commands over all HW queues".

> +	 *
> +	 * If host_tagset is not set, this is the maximum number simultaneous
> +	 * commands a single hw queue in the host will accept excluding
> +	 * internal commands. In other words, the total queue depth per host
> +	 * is nr_hw_queues * can_queue.
>   	 */
>   	int can_queue;
>   
> @@ -631,10 +634,7 @@ struct Scsi_Host {
>   
>   	int this_id;
>   
> -	/*
> -	 * Number of commands this host can handle at the same time.
> -	 * This excludes reserved commands as specified by nr_reserved_cmds.
> -	 */
> +	/* See scsi_host_template's can_queue. */
>   	int can_queue;
>   	/*
>   	 * Number of reserved commands to allocate, if any.
> @@ -653,10 +653,7 @@ struct Scsi_Host {
>   	/*
>   	 * In scsi-mq mode, the number of hardware queues supported by the LLD.

I think that this scsi-mq comment can be removed or fixed, as we have 
not had a separate mq mode in some time. I can do that as a separate 
change if you like.

>   	 *
> -	 * Note: it is assumed that each hardware queue has a queue depth of
> -	 * can_queue. In other words, the total queue depth per host
> -	 * is nr_hw_queues * can_queue. However, for when host_tagset is set,
> -	 * the total queue depth is can_queue.
> +	 * See scsi_host_template's can_queue for queueing requirements.

nit: I am not sure if we even need to mention this. By default, people 
would or should reference scsi_host_template

>   	 */
>   	unsigned nr_hw_queues;
>   	unsigned nr_maps;

