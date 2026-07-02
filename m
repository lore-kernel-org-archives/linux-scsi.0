Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C975355F36
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002840; cv=fail; b=CsOmG+g+bLOHnR71Pos8sFW+Ja2BIL8YWTnI0PtkSIr4qXGzRF91HFCyjBxzAkiB4aCRLX76qAB0/46jrO8BFlHRKZJ3XGC25rkXpPNPkc2lCJWhAy4OVtX0LjBsEqp57IpnkyaZun2s07DYpHBGEs4fC/QS2T1aP4TFZ31mao0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002840; c=relaxed/simple;
	bh=8/H/CvxujUeZiEGbOoRZIi0Ba1qlxpeMbzldhTUkGFs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qkRKYSMRIZZC4cACFGtrMx9LC5xzu8pFOenv4u/sf9405+poxm2Xd0BTV3eJPgK+wS+6w51kqAvVP9+Bn1sIwEkyOKwSqlKwjE5mJc96DqLHxTd3qe22tQHhok+blf0q8yz7SaLfobUAvNiGOSraoTvvZzgGHUD8FwNxNFAj6aY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WIcHqJX3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YvM7yFUv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WIcHqJX3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YvM7yFUv"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662CiucY909413;
	Thu, 2 Jul 2026 14:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PNveLe3wULxhO/QmbcC+VCmTZ6XE6oI9vogLHOicboE=; b=
	WIcHqJX3hdbc4AZW9gke10bnUv4Z4Ze/rDcbd8ks8T4gxNuRNc2lIZ0NH0rT6afT
	dt1yQlo8zFxP2zZx54Ljs6s5S7TOrGN/+SysXJq+v4Q7HvGlNWVoJ2vhTsGHb03q
	u+IiIWSnN7nH8Y3KMFOwGS1XT7g1OdccRH3Uy/UesexJFmye6LEhtF3HQjdaLjTx
	9DfE/WStQg/9030re+szLwwYtaFff5BMSC04WM6jQZKyfKe/g2fd+Yg4SzlbGkAE
	dLOEUVzaD3q6nMUECAtre2LgJPhjYxkTi//NExgPae76Qj5hQ3nfdcX8ETYn2fcF
	5WnMKTKRNIxFl9dsaM9EJQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qrf64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jul 2026 14:33:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 662EXdcx030180;
	Thu, 2 Jul 2026 14:33:40 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24ytehv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jul 2026 14:33:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UZqZfT1XUdkiQ+q3Op2Aleqpg18AUnifktF4hcvkRdy6G4nshYpVeUuEy9qN1zID1Ws2U9OnNe2B8utNnUCvYNo2l6SKSKAUveuNqnMu9gmlIzeL0EPLeHdr/SD3CZlj1zajl2usOfujT0m+ig2eXX5QjK1EGfZgkZkKUkFWVRl4xAeuo1seiEEbmxbYnZ5IuTXwGtYkjO1bv4sMD1zaa44h7Us9CELqDcFn9pW9ru/PzIGHBHDGhU1bAW/XgE0XpdHu4BZe943WvX2r/5zN9NifA8xRuSTArwxfxFs3c10e2f3QcnJ+dMZxMYzWqJMMhdO5vxn+FVpVvYxJy/vAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNveLe3wULxhO/QmbcC+VCmTZ6XE6oI9vogLHOicboE=;
 b=IQ+u5OdhqnlARCdpYbqZ6HrBIlbVRkC73pvrZL1eJEn74HFbPbb0z2YbVjbfh+4zIkQh2OMXtzap5kCFDQVHMzYIHQQ1jcSpaVKIMIPvZs5fJ6hGyNhafHAwsevsYxLtCKEP8wiTpbBBELcveHDG4VWwO/h3xfv1h62OTn8f3QRgIdY0/1RO/PkT2Gv5LCFSDuCfy5fdtvByXuF+mT0a5IIVFf+6SGjoEQjs10nTjcknoVxa/1NrFljRnNItBy465ZqyeWHeF2bH2lra5OrvrGi2MGJphvdjSynoES1vbCTnaTXtcbJ1v/Bwqu7N9jF027gaa+NoYh0woPFHuj5oaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNveLe3wULxhO/QmbcC+VCmTZ6XE6oI9vogLHOicboE=;
 b=YvM7yFUveGRkXISainzY93V2OB6urwU9PwcCKWJnAdDeThYW2dzCLIJ0KyVDG97hbF44Xp7thCvaaPGEUnShDX+dPjjZRqITBg7pMeQVetsK2plr9k4P1O8P4RXyGKolPzPugYrbskQ1W3O71FZwcrLMqmyFfxiD/HWUIzgJ7kI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SN4PR10MB998047.namprd10.prod.outlook.com (2603:10b6:806:211::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 14:32:37 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 14:32:36 +0000
Message-ID: <99269908-bc00-48ef-ad55-80a1605d7e5f@oracle.com>
Date: Thu, 2 Jul 2026 15:32:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0 for
 no DMA capability
To: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        m.szyprowski@samsung.com, linux-scsi@vger.kernel.org,
        iommu@lists.linux.dev, ionut.nechita@windriver.com
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
 <20260629085310.2298552-2-john.g.garry@oracle.com>
 <53d07679-b1bb-469c-acc2-981e75c071c9@arm.com>
 <d82926fe-4557-401d-ae58-4302fef5657c@oracle.com>
 <7c9720fd-c615-481c-ba4d-f5e0efbdd7f0@arm.com>
 <20260702141116.GA22720@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260702141116.GA22720@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SN4PR10MB998047:EE_
X-MS-Office365-Filtering-Correlation-Id: b31fb4fe-1ecf-4cdd-8fb4-08ded846c1ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	InDKa/NyY7ZWcQvISvXwizaIcUO4cTQ+WXkZ6hQUh1vQdmFQdKICq0BQDAZMow/abfTQ/RVRQgu0KBEh83JH7NXTDx90T6Bh0zXYdvH0e0Z5qLc5+bDaw91oiwTtx37dCI59u/iz7B5bWSZHKhhPnxFUaD4Kir3KvBpPuQ7HBKfZjZryWAaI307HpIbpgYbv/l+X5ee5oS4Qg/ehZSuAcd8Qn3PuaSvh/h6La9bGw/mBQvHBa2WElhRb9hmVFVgIqqAQJu0hVJMmI5C1+Uc+sc9q6Ji91kjRXarchvMJYCjOzzp31/HjDcaXwOqKtD3UWysE62WkgxO0arK1osnRDfjydAmEPgWouv0JQ/+4wL04iRdmp5R6jKYO4VK6h+Y0jl0q8RC+lR+fpDjpvF7KsEtttQ+lqNhbZTHNmMq0gFAq4nb7Cu23T1/clDJOdusxjneBmnEMKL4hZocpV89AX3P95JEDqCEWAcoCOUqbWzqn+UqUCjKySqc7AtW5NfYMP1174fVEwjsVJi4znp3Lo3aOmfCB2j6AOuikDB8Cm+KzjQkitTaeAVD9AsLsSvAYbQQaM8DCtfwg2bVuEQ9XlO/oN/U1JoiCZXlT78cHuH0z7Jo7j57Qde4lGDyyGYFI+nH8f5AA0JWCOWe1x38wU6Po2pOOgGOTmdbAH5Q//zU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnI3RFlibGxiMGdSVGVaVU4zZXdycHR4cm8wWjEwTGpNNE5WNG9yK05VVUhu?=
 =?utf-8?B?akdKKzFLSmV5YzlIdW9mNVpvSVNpYlZvenhQdnJTV3ZXeGFKcVRObjlOS01p?=
 =?utf-8?B?cVEvT3drMVZWTGZ1amlUWVJYNzJOZWI2bnE2bnZlVG1OWGxZNnk5d1RDZWR6?=
 =?utf-8?B?VmVxcDhxVTRvMHRGVm8zQnV5NmV3ZXlMek9FSmVrUkFETXpreG1NVUJxZlpQ?=
 =?utf-8?B?ODBhQ1RibWZyM3hiVndkMkpoQUZkNmI3UXY0SWpSVUhPUnBSMHhSWnFkdDVk?=
 =?utf-8?B?VjVMWVhFbGhMcytaQ3hHZFIrTWwvQXkzVlROVm83N1Nlb3VsZGgzQVVmVkY5?=
 =?utf-8?B?MTdjNE9mOGJwOFNxUEV5UGU4ZU5kdFBwR0piU01FR04xV1VGU1ljZGxnczMx?=
 =?utf-8?B?M1J1ak9VbVlLSWYwendvRjJySExud1VCOXluZmo3eFR1Q003MTUxSTFjL3k2?=
 =?utf-8?B?MFdSQ3BydDlMSVJBWlliV0dKZnhoc0x1SW1nL21jQ3RkejBGZkJrR1NpTHZZ?=
 =?utf-8?B?WnZ5ZElGeVQyS0VFWENrT2xaTUdlY1U1cjRNZSsvMVcycUd3c0pYVXkzdmt1?=
 =?utf-8?B?T0JYRFUyaDFLVUoxT3JzaUNVTEs3MW10cnRYKzlPaTVNTFU5bGNVUVdFWUlS?=
 =?utf-8?B?MVVaZE9Ody9WcWNqZ21CeDBHbUphVndJUVR3NUptbXVPVm52Snc5eUFMWnZC?=
 =?utf-8?B?MWk1cVdsUXhoN2hOcmdSMkhYWmowaFJpclBSK0xWbjYvL25jYVY0ZjI5N1hp?=
 =?utf-8?B?U1JPd2VCYU0yVCs1OTFIVG4vNGpTc1d0ZkFFZzRWWDY2dlBzNitSWTNPci9J?=
 =?utf-8?B?czhMU05CRW01SGRoMm4xRk10QUtqUFNFeUZWOFdaeHcxWHZicVdVdUxYalR4?=
 =?utf-8?B?bmtqeHJPb29yZk1jOGM3ZUw5YVN5cExwNHAxZ0JxZEsxdEFWTk5OMDRrNjVK?=
 =?utf-8?B?YlovR2NzWmpOYzJpSWQyWGl1R213UVdNWlNKRk5nSS85Y2xsTG5qVElRZ1R3?=
 =?utf-8?B?VlUrdGdrZ29XNlBXUWVHZHpDZTB0SjJXbkdFYTZDRkJOeElKOWVlbHROZ2pY?=
 =?utf-8?B?VXZIYXJUS2ZXZHBJdFJCWHpqTXM3ZnRmaXZudGFtb0FzNXljeW1zbEh1eSs2?=
 =?utf-8?B?MndjRE1CQmgxMmNRV0dER1hWVFV0SEJYaGpCMzJIZHRYcWRldGIyamQ1RmU4?=
 =?utf-8?B?MFdaeXI5Tk9nZHVpS2xsdWlvdTg4a3U0VFlpWjlwYk51TXVrRU9STDlpS3Uz?=
 =?utf-8?B?akFJVFI4ZWtpbzZ3ajRNc1Z5UlRaeWtIZ3pJbitBRjF2YVRhOTV4T1EwbnhE?=
 =?utf-8?B?OVVGUGJyZVJUMFhWVVlxenhCaThMK21rYjFVMWs0VnBCTVdpSzRWeVBGaVk4?=
 =?utf-8?B?Q1llNUk4NmtOVGNGL1JhWW12eHVTSHozVmtDQTZ1d2x1Z2xZUkZzYlQ3NGJa?=
 =?utf-8?B?YitrUDd4MGxNYklwSVpUNFdva3ZUd0N4ZDVqemV3V1NvUXNucHdSdVdXMXBm?=
 =?utf-8?B?MFN3bEIxdWNPQ3Z6WElQREN2Z2tYYUs0eWdLWUZvUDdaeE9rdnpzZXVxcHJ6?=
 =?utf-8?B?T2tTSDFXS1RyalVxOGcxRStoNExxcExGckc1aDdYajdyejREZnp5bUtNZ3dj?=
 =?utf-8?B?RXJNdzIza0ZmVlZSWkZFdUxaUXZRN2EyTkFIc2xudHVESEhCeTF0Ykp6RHpD?=
 =?utf-8?B?Y1ptTFNNWExiOHpucFIraUVDQkJhcGtlb1hweXM1cThRRTlxTmhQb29hV2lV?=
 =?utf-8?B?aEI0UE1Zd3BvRi93T3p3U0ZxdHJqMzlyRy9WWkREUTc3U3I0UkZ6QWRGMzRB?=
 =?utf-8?B?SHJsbExOWjlCRjhKMXJoOUhBdmtxb0pibTRWNk9ycDEydzZ5bndETXZLbXdU?=
 =?utf-8?B?dDBOOGs4TUJQbnFFQStjaUVjN0FuSFJZcFBZRllLT05McUpaMjlQandRRUJT?=
 =?utf-8?B?R3VCNCtLd29RMWtUcEVEZlR6Nnk3OG5TSENFNkVpbG1CTGlPWGVyRWhQaEtn?=
 =?utf-8?B?cDI4WlNvRlI2clpkMzd0K2dwMnpHOC9RemR1OWFFUlRmbnFzNEJlRE1abEF5?=
 =?utf-8?B?V2ZKVjJJNHdPbGhUY3phZmNqdERSQVh2WXpXZWxhK2hBQ1l6L2Z2ZmNSTWkv?=
 =?utf-8?B?bFdYNm12aUZDWm1pR1lOaGlIVkdpcHZzUk82Z0xxZUtJc213c1lDMFdCaEtL?=
 =?utf-8?B?QUxPc1ZLc2hiQXlHQlVvNzlWall2TEpMQjd5cVZEajRRZ2hUS1hWdytYNVhS?=
 =?utf-8?B?TDBYakJqV1FBSFVOZmQ5eEJPVDIrZHZRakpaRDdRNVlibUZsdVFOKy9vS3py?=
 =?utf-8?B?UU5BR3Nwbk9rZko5cm43NExqb1Rod25QYTkxcHBWbEh2VHVaRUxLQT09?=
X-Exchange-RoutingPolicyChecked:
	bUaoIdQNEQgdfoP1KL8XepM62H+vRCa+To7F/LCbuQfAFj8mAocwgbi0aVpGIstSfVjisA/VATbdn8Jb1YCArhMumQpl7oBqoxxLPYW9GODNeRZ+AdODzgDi4ATy8B1/RpI+RATaEVcF0j8M/nEtnuS7qWeI56Sm5V49hzh7HfW8dLQLxiykhOhlMD6px9kraQBR0M6khBaoUTUVsaqWPjnxIE51LOANtD2bHRhQtoPVGgsIAHksr/g7n2AUlqska4yGGIh078DbaY6ErcUnAMsUjZrVPzlp6PkTMQavLMskSusuPEl+aq4T+7Q0hq9NzFQW8AVRUR+E41Y1Zg31pg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HVTVywBR43H+4JVTpf3vXAzLZXuzFHKhL+aoZZ+JI///XSYoRUPp212cS8EZc3axTgpgFpSH9m9kMCc4aeIRHUWNI7z42FWqMfH0Ezl/FJvlkx3/xqMkuQNIOyobWGKP+6oQ2Qd+M5J8a/CL9mZyUef1gIg5P3+tG6sBusMw8c4rSyb/LVik/SLOOylds8f3Y+KzanYpACqBzrRFquWOt2QxjLwJnEjbPHqx4qtDHpk2hDU/7IGhGsyqB8aroINQMB2hVb0G49h6RKNPa92lzrIkn7UVirIgjlXGkiCRHbB38EPO1COTyrBq1Byq+syH8XjQNUu66kjO4kBq6N+0ThBQ6zbxpQUrEBz3ntsllcloqJEV3bJgJ1cXB45Ev8oje79ccy3KqaboCuN48xHmBpTrgWZJE4EUSkAeHLvV+PuCPsyn5vlUO/TNh6CZIWNOVH6g/INtjNMsUT0Ba5lGVuSASVkec+i68JUHUmKoL+MvE2nNoMWSPqn7HdBmSKv4nS8cWj6FqZox4VtJt+SEop6LhuPECH69SrsSiitOoSdOAXy1Ge9nHzJkpwk8fJeJH9/kUaY768eDqojaRA7VfUMu4jdVt7sM439kawTvbAo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b31fb4fe-1ecf-4cdd-8fb4-08ded846c1ad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 14:32:35.2372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WUopbxBuxp84AceWzhErwqxBtvMtnVir8iW+DdHm/+WtQt37IPrqdM8fZWy729+e2ZbVxIo+Ptfr5jNWpxdVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB998047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607020152
X-Proofpoint-ORIG-GUID: RUnjYsNDDwvScYMLk8e7HeM4gKWeoZNr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDE1MiBTYWx0ZWRfX/dX4qoO2jM5g
 rJDGIGkG7sI1F+/qibgjOxg5gevUwuX6JNLH4bLEc92AlsYAMss1BL7w4H4iswbpotayNlyex5E
 Lri7LeDQyhWK2CucH5TzobJmXSyZk8uWi4mIwanYPx5ZTqqQqtjsyKbRo8jtOQWJ1sQXg5kEVjA
 1y5HZEEw7rQj2DcVTw4lMJJa1oEHbTsKHR29BpBJ9mcA0RZwJLJMpdRnSd3BxsZfrACtYvN2LsT
 ckkenLoQCSHmxSLZ92/ugsRdKBq7yanm7JaN+QpGMhQ72J+oJHTBJjG2NMfRK68exw/osKsED4D
 9P1lLwygQXevmKqp5Xr3iNsxsTK8sdWc7hp0xKqkrrnSqznkmSbgqkY98jfmHzWeOgirfaPTz3R
 Q+prmnrn9Qcsx/8CrP9pUwUmtVndv70+5HCdagSdstGTwOGb4JLhT7+30to/xggIhxz+KYbZUwD
 ugdwWbiozvav2rbe8qjb//kn8Vod6AP7liQ6nJZM=
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a4676c5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=3m88cGiBo6dpB3kdh6kA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: RUnjYsNDDwvScYMLk8e7HeM4gKWeoZNr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDE1MiBTYWx0ZWRfX7a0aKgk+by18
 Jm4RoxzBjFEWrecegBfF5p8VYH7tl2yRqGOhufMLbCyean3GKL+DmRPojBRBUxAUkt6RlP/fP4M
 xFZj80ILM9HC/X4sfQRQvXDnXG2M/VaFZkQBhrDQ1eDAT86ONbfw

On 02/07/2026 15:11, Christoph Hellwig wrote:
> On Mon, Jun 29, 2026 at 12:09:42PM +0100, Robin Murphy wrote:
>>>   > Additionally, could this cause invalid zero-sized block layer queue
>>> limits
>>>   > in MMC drivers? In drivers/mmc/host/bcm2835.c:bcm2835_add_host(), the
>>>   > return value clamps max_req_size:
>>>   >
>>>   >          mmc->max_req_size = min_t(size_t, 524288,
>>> dma_max_mapping_size(dev));
>>>
>>> bcm2835.c is a platform device driver, and platform devices have their
>>> dev->dma_mask set in setup_pdev_dma_masks()
>>>
>>> Indeed, that driver does have a non-DMA mode of operation, but that looks
>>> to be selected independent of whether dev->dma_mask is set.
>>
>> That one seems pretty bogus already, given that DMA mode is apparently
>> dependent on an external DMA channel, so "dev" is the wrong device to check
>> (should be dmaengine_get_dma_device()), while conversely
>> dma_max_mapping_size(anything) is a questionably meaningless number for PIO
>> mode... :/
> 
> Yeah.  It would be good to get this fixed before this change hits mainline,
> though.
> 

ok, so then I'm thinking of something like the following:

@@ -1305,7 +1305,13 @@ static int bcm2835_add_host(struct bcm2835_host 
*host)
         }

         mmc->max_segs = 128;
-       mmc->max_req_size = min_t(size_t, 524288, 
dma_max_mapping_size(dev));
+       mmc->max_req_size = 524288;
+       if (host->use_dma) {
+               struct device *dma_dev =
dmaengine_get_dma_device(host->dma_chan_rxtx);
+
+               mmc->max_req_size = min_t(size_t, mmc->max_req_size,
+                                       dma_max_mapping_size(dma_dev));
+       }

