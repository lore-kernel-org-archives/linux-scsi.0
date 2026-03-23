Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05D73B8933
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278923; cv=fail; b=pIAgrv9NYUIcEgaNUArQAEdlN+EkoYLXq9gVkT8FlOkNxSzLIx1Tq07y//B+eg3VNNauUs/V0veQFBqn49H+ku5uelSAq8YZ2UwfRqgfPWL+bB3sILjLjYWOZZi0FfjMtEL/bwQvE7yeQjFOWhMjqK/GDoTfomECihv1w9j/7WQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278923; c=relaxed/simple;
	bh=WJMlzLt95YpFPosGbi72bcNqR1JKXbwaItVW495g1ec=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o+5oLxc+nFvT3hVY1zjhiZ0J0U1hbZQ9EhOtnoL0qawIRMBVeqwhFMIXP/v8WJecEXSZba568PDejFbULWyFfA3umsfervwJ9xg+ikneGRIbNsTE8ohFTl7fhZ9whzb+3csPtd+ujARCXVQ7/Jjg+CjHrusJ9r03Lf61KGDxfpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R84sAMAO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G/9yOA8u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R84sAMAO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G/9yOA8u"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NDt79T3488277;
	Mon, 23 Mar 2026 15:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IIayTG0O2RTlWWmcHlBkt+2mcvry72xQkCBLePlXBDw=; b=
	R84sAMAOeh/sWmnp81AMg2DXCSbXDvDEjJhQTlIX4o+blQnaKN49J2NIRelSrpLH
	h9LDnM3pDpJdmOlICRQaKmQb/BD9kSG6R2YShIXzIpbUFUSC7FUFzusBJqly3vHP
	mfOFPi0zUZ2tl+lM77SGZ/fIKfyZrt/xi5KwlQI/8IiQG+3HPg1nnYn2/3YNz746
	RZeHre+/FZkSDSlNUzTT19ZNHe97DPTLbrP991ovk/nO3XcxYoHVX2R3kbMn7PCj
	c0nbOa+R5gI+9xcTdIJdenYBTLBYRAP/5v5hf+O/BMfakiXCULHXMZ9TEfnmzdkr
	lwN2owjXMpXpJrPF5MYIpA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kja2gmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 15:15:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NE0CCK039933;
	Mon, 23 Mar 2026 15:15:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8argj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 15:15:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3O1Bw+HfYLl5kab7+1C6g5wWJjEstRVOseywCHa5hkvovc5i6eKhbtPbOUN016X/s2t23Q9ewzk5z3HBtGw5gVVeVjXu+/uR7JXpi/CyTwcUNGL8NIIXL+1J/2p3KOabwG7i6Yq4RqbsSLgkrmY27Q90/No9BFJ3g/faZ2EIwozfDsdHokuMY1GKT/C8s6qb39FvLOe5D3gIqxw25R/OEgpQILGDrKFkvU0ak/UiDzcOfw28IF1en7NmKexPrI3pnpMrO25g0FAaqaeiMomIEVB6819JuOVZv+Hw5aFru7QL/Em3If2ln/te+SLX++byZQvbT1F4fKsaOO5HfKahw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIayTG0O2RTlWWmcHlBkt+2mcvry72xQkCBLePlXBDw=;
 b=RKjOpb73eKCnGKeeCAbbFuzVo7h0gxplmrPVIX6sGdsmRzCA3xZqE4trtcvNBW/wnV+dCndxX/7k30G0bQrSpoT30RQxGsbxgw533eZ7m0xZQdDvI6BQAnUWEi4sZJ1Z90Rexfyp65alXHslCEklKmdsrpz2Xkbfnj8y0yCONvNNzZhCtAHRsX+ql2Rs/GPE3u5+6vaDgLQk9dKAaPqTdwDamQiEbhHTkqVIr1jlJ4La/lij3D23bBRHsApvE81sFl2OO+OSUSy3hQcvjUpbnExv+jCrfG1o79V+F23zI+JZrV3CP1D7kgbXxWLpaMlog+KwHmiFe2ZK5ORyg4myaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIayTG0O2RTlWWmcHlBkt+2mcvry72xQkCBLePlXBDw=;
 b=G/9yOA8uSAzGpDcorL3ColrolpEqZR0KObQkx9QDJN1GlXfrR8iLYFP7Dy8yUa/6wwN/qTj4/lkP0I8i/tAs8QCTAGH7Zf9NZCD5MuwN6BA2VlXLFDpjdjp20jKDV2DWDdCy1S8hLQKmDvj7oNUsCvhIdTQagafraHcWYPuD4JM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DM4PR10MB6280.namprd10.prod.outlook.com
 (2603:10b6:8:bb::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 15:15:14 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 15:15:14 +0000
Message-ID: <a3553b50-625b-4fb3-9a1b-7c8c604a3828@oracle.com>
Date: Mon, 23 Mar 2026 15:15:07 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsh_dh_alua use the device timeout rather than a
 constant
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: hare@suse.de, Krishna Kant <krishna.kant@purestorage.com>
References: <20260224010754.37001-1-brian@purestorage.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260224010754.37001-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0055.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DM4PR10MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: a8025f95-c19e-408f-bfc9-08de88eefbf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	Rkj8JtXUTEmUQ85zx0B5wX0egBTwvR5a9sEgvwotpOZ9ZpRVeL7/Kbm4F5QQKki8Bbigyz1HPx10FlZXlekMfbDUTRe0KDk73jkQ79v4yYE39Y4Hi1h9ly1Vrv8FKwMKOqgYp8gaqOWhojI355SjrLMKRVmhy9/q0ICg0VRimg/5JlyaPfFm6w2ZMOp5FzhC5gNMdTYdU0s2vZMfVTz0l3OK+jSD1uT9tNEmKsgcAWPNntLjLtwpKlk8yL3nyVGr7cjwKF94YMK23F6qftux4QrJ7r9mKt4KmrVZPtK6xpRpnUpjbDbfBc6LIQk2d3s6+kcJE7azEunq2BBJk48TCdTsEWMFuLDzrBGh+yjt0fDOxJdOC6HGUyfgsSjH+P8JrjpUuK7BorNk/jL5DwvnVM4CW4yskpJ62ZEn4A2Zz07N7QveNzwnlMw8SEfcwOhkzBXC50KDL5T4Am8XkAZ0SwBCaMPqoWbhmvEm2QAy9sIQzZ2Y+vFpIwnnAclQFLUrHhSPQK0r8Gm3k9adGfd5+GZ9nNBe7h1GKp5GBn5wavfkU/I8NNvwVBRsu1JtdHXRusJBIEgfeiXa8w5HPLxTg2IU6JWg+N4BvKD+gxvLXUXGPcJLTyWqwXmXZLRiY8ckT7Fua9vD2W/oUHkoBQZbM7nPBflOq7HlJgf1hP1eq3WiHKpcn3CjWGBEFKlDtsvxrvB9bSGfRBjMqNB3RO/iKIVOmTDWMPmqmsiJSeMoC60=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkJjWG13dWt3MFFYSEVCUDVCWkJhdjlYcjdjb3oxcU9WeUExS2lYZjRkL3l1?=
 =?utf-8?B?QTRQYjBFZ2lNV3BrYm9aZHdueCs0bGtjMmpvbng2bUJBbGtidlpWK2FYNmk3?=
 =?utf-8?B?dDJwN2FvLytCMFN1aW50R0xrOXFudHd2SUZjS25IdngzaEVQeHJJSFVqblV6?=
 =?utf-8?B?OFRVMEJ6dHdnamRlQTlPTWRDR0Y0MTE2TTMreXlReFJjTFE2Q25ZcDZPSTdJ?=
 =?utf-8?B?Z2Y2ODRWNStKNHB5Tk5zQWNxa3I2VldBTlVKb2ZSQWVOS0xUeTRTWEFKYlM3?=
 =?utf-8?B?N0F1VnpkaktBeWc1RlVISHJSbGY0NzFmd0JnMHRLazFML3VsZTJKb0xhb0Yw?=
 =?utf-8?B?eWxVQWJNY0Q5NTlYOGNueUI4Y0ZhWjhaY1ZDWW1rWGJtNmxSVUdET0FMczdx?=
 =?utf-8?B?NW1ldEVsdHNDZGRpZ3pvb3paWGNiTzdYdUVrZWk5WU1ZaDdrWmN1bUVkSWZx?=
 =?utf-8?B?U0dPeDFkY0oycHdDUXBWSmljRnpibWdndkovR253Y0hORkg2Y2UzV0xxUlBZ?=
 =?utf-8?B?RE56clJTbSsxTVJubVZKNlFwekZJaFdrMnloRmRYbWx2QUJkNUxUbzlxYVh1?=
 =?utf-8?B?YTBiOXJJc21KUnFWOEpkcnlnVnNXbVNwVkFKVCtLVWQxR2JYd3hBeDQ5ODdT?=
 =?utf-8?B?SUlCWU0xbHJQVE40UkdRdkhPb1F0b1ZRSnpLYnBvWncxSzE3RFRwcFN1Y2pN?=
 =?utf-8?B?UitPRm9Na1pGOWdUOFltK3FUWWwrOHZxczRHZXc2a3pwMUF2Ymx2b0IvVVNw?=
 =?utf-8?B?WGJDSFl3cFBnZlQrRTdRMFJIZ0M0SnhQcERhL1VTZkFRMG01U0ROdDNjOWVR?=
 =?utf-8?B?UFpqaUQzSSsvVlJBdjBmanovTTVmNmkwa2N4ektkRDlmcTZtSWVUeS9pYnc4?=
 =?utf-8?B?N2xyemhCclR4dVg0SHZOc0xZR2d5cG5zTFBQY3Q1Qjloa2laNXlZMVZNeG9Q?=
 =?utf-8?B?Z0VpMjVRSmlQOTlWTGxWcXBPeGw2aC80YStvQTNXeUNrczBnVXRoWW5QdkJX?=
 =?utf-8?B?bjM1dVgrQzRsc1JCSElCTnhxR2FhL21vZXp3SFJOcDVjUjEycGxIdkRpUVV2?=
 =?utf-8?B?ejhqSUVXOHFJV0FtZlQydDVYcExkcHhtMWJVVEhJZHdZYVZiQ1IybjUxc2ph?=
 =?utf-8?B?NEJVL2FmMEYrZjcvZXdJQm83bWwzaDZPWDQ2blZrYjVLNmxLYTRiZ1N1OU5P?=
 =?utf-8?B?THFYQVFJR3E1NnBiUzVQUmFNYWNERjJsRlR0a0gxOWYvbzJtOHRLZ2hSdjhH?=
 =?utf-8?B?RmFwN1ZBS04rVnJIV0JEdm42bXlSbzltbzJTc1lHZDJFV1ptdDg2UlFUbDIv?=
 =?utf-8?B?Y2cxZE14aUpJbGxZbGFCNDNodjJMZG43dENnNm13ckZMV3I3cWYyNjk1TEVa?=
 =?utf-8?B?L3NkQmNPbjE3dWtyMzlTdGNqd0lURVptNGUycWtEemF1bkwvTUg4MjNQOWVF?=
 =?utf-8?B?c201ZzNlejdUVVIrT1ZUb3pLUGNieGNFRzRzSnFMTURodnRLYXNHUUFOb3hp?=
 =?utf-8?B?S2k4UE8zRy9tNEU1L2VWenVqZnM1b1I4L1BsQ3FDM25oWnFMT1FwMmw3ZEZG?=
 =?utf-8?B?QThvZFZ0R3o1TzN3RFdrSDNERnNQVm84elc2Y01EZk1INERGaTZ3cW4zcitW?=
 =?utf-8?B?d2NmQ0l4VmpZT1ViTW1JaHVlNEw3cjdPSGh5UzVJMWFjSFpDOUh1a0NXTVMr?=
 =?utf-8?B?UUw0ZU5HcmMwdlFxOGJXN1FUN0g4dlc0M05aRlhCZmh4WlhFbytHYTFvYVRW?=
 =?utf-8?B?dDIzbWVvSWlLVnpYRnZZNGhGaG51alJzc0xSY1dXZ2JONDczd25ZenNoVll6?=
 =?utf-8?B?Y1Y0Y3VteFhjREtPSktIMTNtZkxLQlpPMnpFRGpxNVR3Ny9wNWd2SkZUT2tV?=
 =?utf-8?B?dS9HTVR1eHJZcVkwdG5EVDlkM08wek0zOGtER0ZMVXFVejJJQlh6WG0vM3FS?=
 =?utf-8?B?Z3Q1UU51R0lvTktrVjRVTHN4VHFWVHBidEczNmNWRjhFdmVSelA0N3pNc1RG?=
 =?utf-8?B?aVhDOHpkbXQ5VmtDK1JiaGVEdEpOaFh2cDV1WFRKbmhkeEQybXI3Ky83ZjUz?=
 =?utf-8?B?N1E4MmNheG1vVXZFVHp6TmFpb0xwUWJTTmYzQktUNWRpVGE3TjA4cWhtdHNL?=
 =?utf-8?B?ano4Und5eXZjYTI3RndUOUVvQlFBSklaVmQ0c2ttVzFBMVNCeUlxOWJLUW5W?=
 =?utf-8?B?Wll6RUh1THR5SHFkdTUveUFiOC9aTjR3Q3VJRndsN2JKcjFkd0FlUGxMTnBp?=
 =?utf-8?B?ZGlYVytBNWtZV1pDSGNKNmVPa3pra2RFYWVjMzZJTUdsazhlSlRReXhuODIz?=
 =?utf-8?B?VEc2MUN1YUo3WkxmOWVZQ1NvdlRsUklqTm4vcUI1SGpGY3d2V1RQeFNTK1Zu?=
 =?utf-8?Q?s6c9sbf7nIZakw64=3D?=
X-Exchange-RoutingPolicyChecked:
	LZgIijGd4iYKwbVD5Q+b+RLuDJFx9gTqoHMm9kTrztRM8wiWX7xux90A2Jd6Nh6utz3Oks2RUPElXQbgJgLumFsX/2iRFynQ+p1pai3iDZvAKt1vtvhaiQa8FXDiQqSSZdQLKR6JOIY8ox/Zn4v1B2X38aWK1fU3BLSrD1/80G9f5YvhXO3aeRFktm2ENycijTvOT+qOyX5m2pU1qG3KH4buy1iT6SPlifA+8d92oaKFv1NkR3sNivM9Yc082Rrpl+Q2vd3NCqpBJ5u7u1YDhzWxrpM6xVuEukxzOv2F32mx/tqGxm5wv12M1YEcMSGH5j5YNNq0/Ghtm4HcDFtHAA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UPks9yX0CpJvzLfOOqWWXQSHKlmqLAsTycONuiXahOOfwU2unxlSP5DrHx/Wtbah6UQhh0j8fIG7QZLqZ50ebI+s/FHFOZ7tO24r0rLJ9snw1PVyxUN3Hi50IkWAzwimgqr2RoR+NQZpZgbUiHVe8NTZWHBOfbWv0HmsGnWQXxQVA6wzleVvt7HubPLl6CW7C89wxs+pRhLpClM9P/xesbcu6zAFOtloK+5T77CMXHGHbbjtEEo5laQMhfHBMHEaOVEtjU3KhIsJCDQ1qfEuFE0Nhhni9F80hU0WwZ/U+ttLyajr6YST003uAkEH9O1AOaS8wATNPM0g9DruOECarWTxRzle55FBbWCDbfUw1O/bS/SKbtwPHO3Wf8dSgCka5Jko1ViGmxnDbn6BDDJiQ2gR4Qsopf3565fFG8XmB/YbuExskDKCoCfaFrJibEHl46iYeBk6ylEPcpTdc7wi66CdsX31pET6eX8Z+VUTifjoGTuddkMO5yLSIF0YqO4z+bTxFlwPtii5cS6BFcmW0iEN5vY9gxGVp4nCniq3I6MCMtJKX61OIgRbyZOtbnpe5HSbLuVwCY2fjBsav8LlOlqoZiObvVBbj+Q1ZaujQxo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8025f95-c19e-408f-bfc9-08de88eefbf4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 15:15:14.5153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLvI36uWu20Ixzz25jiyyL0EUq/haa2WRiUHK2SNTrQcn0ryaNjGEkBq/2MJDeqx1vEi1oRkiaBwNW86vE5zQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6280
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230117
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDExNyBTYWx0ZWRfX4N01SnBl2gk2
 txw1vn79HwXw5TNm5i62//KkYOLM8dgbvijD/INOdqKqSMyxaZ1PNtnGkT3yf5Aqg2RFfyxPy/Z
 13m2RCfqMU0EmGk1VORBQGdEoGmNClrUg51r0qlaesrfmKY9ma4N5IdSU3OCzbNrhfqPHLr09Tw
 WvaPuKWStUAmhoU1T0pv0tr0Jaftb0BBpGZx2jabp3Y66AUtECWh3Z1ioQ5BlKnjpS+R6FXJWFE
 bT/nP6j2ZJlbqCXvXiGk8VXHzju/oloDfD1pUAONU3vuoT8erykx+N4Nsjh37EwZbSUDeVvtoHh
 LZmX+MimWHcLZnzxi0rTItE6CHNglbepQ0HRyoyiFAGVrZmn+QyE7GLONhwYMCPKoiNrFyrLLFI
 a9Tal2Nk+bByQPNSU50e926Mn5aaZsY7io3WAs0cnd7i2T7nh3QUKsvROL3eoxi9QT11sy2/d6l
 rOE6Fia/RX2c7heGlxw==
X-Proofpoint-GUID: ltnIuC_cOHBemf6ADyFjlGgmhBVrwyZq
X-Authority-Analysis: v=2.4 cv=TPdIilla c=1 sm=1 tr=0 ts=69c15906 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=WTJdmG3rAAAA:8
 a=DcIJYyK2zSXZwZg6fasA:9 a=QEXdDO2ut3YA:10 a=q3NGepEMMmKWaCv8Sx90:22
X-Proofpoint-ORIG-GUID: ltnIuC_cOHBemf6ADyFjlGgmhBVrwyZq

On 24/02/2026 01:07, Brian Bunker wrote:
> Instead of using a constant for timeouts, use the timeout of the SCSI
> device itself. There are reaasons why someone might want to extend

reasons

> the SCSI timeout and having the constant out of sync can lead to
> early timeouts.
> 
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index efb08b9b145a..7f11acf714ad 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -143,7 +143,7 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
>   	put_unaligned_be32(bufflen, &cdb[6]);
>   
>   	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
> -				ALUA_FAILOVER_TIMEOUT * HZ,
> +				sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,

is sdev->request_queue->rq_timeout == 0 even ever valid? In 
queue_io_timeout_store() and sdev_store_timeout(), a timeout of 0 is 
rejected.

Also, sdev->request_queue->rq_timeout can change dynamically by 
userspace control - is that ok for these changes?

And, finally, READ_ONCE should be use for accessing 
sdev->request_queue->rq_timeout

>   				ALUA_FAILOVER_RETRIES, &exec_args);
>   }
>   
> @@ -178,7 +178,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
>   	put_unaligned_be32(stpg_len, &cdb[6]);
>   
>   	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
> -				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
> +				stpg_len, sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
>   				ALUA_FAILOVER_RETRIES, &exec_args);
>   }
>   
> @@ -512,7 +512,7 @@ static int alua_tur(struct scsi_device *sdev)
>   	struct scsi_sense_hdr sense_hdr;
>   	int retval;
>   
> -	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
> +	retval = scsi_test_unit_ready(sdev, sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
>   				      ALUA_FAILOVER_RETRIES, &sense_hdr);
>   	if ((sense_hdr.sense_key == NOT_READY ||
>   	     sense_hdr.sense_key == UNIT_ATTENTION) &&
> @@ -552,7 +552,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   	valid_states_old = pg->valid_states;
>   
>   	if (!pg->expiry) {
> -		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
> +		unsigned long transition_tmo = min(sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
> +						   (unsigned long)U8_MAX * HZ);
>   
>   		if (pg->transition_tmo)
>   			transition_tmo = pg->transition_tmo * HZ;
> @@ -664,7 +665,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
>   		pg->transition_tmo = buff[5];
>   	else
> -		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> +		pg->transition_tmo = min((sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ) / HZ,
> +					 (unsigned long)U8_MAX);
>   
>   	if (orig_transition_tmo != pg->transition_tmo) {
>   		sdev_printk(KERN_INFO, sdev,

