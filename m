Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2339D6D3
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483792; cv=fail; b=bzT7iOELOs/H8iUyBILJPjshdC2MjCO4HtZsFttXOHebuhjLEj6LVWJcTdoO1cX5eKDHZ/WKqvE48XfKakWrtYIMtXkeK+hevs5+aXQVWem60+a6uITQMPSQjve19P6VPMXn3NYNNpsDTnqWoX/5rw2wsVxtlUTca2okmhIaBsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483792; c=relaxed/simple;
	bh=SyFp0OVgZmRPx/VvmaYRyuT9Oei8lFHg9+cLswPQBxk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gTC7rZ9ZEayCASv+eFu2zAAngxXSYSsSwhHFtv+mQGpj6h8n68UQn7kUl7J1MkaHs1tbuGl+SHsRInC6gGXGMFv9amOviZQ+FoWzN+c0Lu1LdgsNWF+JmDOMX3KpCkyR4yYubYEPH7t4xOm5aXTe/J63WOeNzkilVKuiqF/oyPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=laWVw4gl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iBKfhOTK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="laWVw4gl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iBKfhOTK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622KT01L1944491;
	Mon, 2 Mar 2026 20:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mpB9DDFvH3Mt3wVZEDHvhw6u7WRbxFchB0FPZWhL6Ls=; b=
	laWVw4glXFqMeFx+fxU1H+ghzRzGAsn/RGNfby8VEFKJ3+PQKEq36qAdgTJHO5ry
	FFaETzk81PZ6Ax7tHPh22J9/uUMTpXD9COM8ZCYlxG+4i01TpmWUb9kXjb0FEuZW
	4/i03DExbSag7J3JNXTFeX4SD71vIetdOSQK0QgFkr6WRn88WqYtlcVgXUOeWBxG
	R/5/aZDoWqejhYom211s4HgAIEGC87J253jnCv38Xxw8BJv/ldY6HAh8Atm1fGz/
	IafE5r9n/Voaayhd/1tZj9UwWb+lnoT95S2EIKwCR6s5GBw4F+bB7MWzFhNYIZ7z
	/lYq6JYfFIB9FgK1t2QHHQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnhm9r0h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 20:36:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622JbhOt023220;
	Mon, 2 Mar 2026 20:36:27 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011040.outbound.protection.outlook.com [40.107.208.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdqtr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 20:36:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=so1lLiIfuPlaZlpPp4Y9RrO+WDY0wt+OATSkOue1YRqCUEi4lcEWpPJdgkQUPIMen8hQ2mwXcc35CmeMP+00UjgC4J8SHuO28Bh7Q4cwNM6S3ApmPKdNhNS8IV1QjoEiynHxDHiyQh69qt9V0i0sZEXCr7heckER+hWJwwm/fx8YSIKLboXyYhWIxRztseeUmCnRwr6jeCdAzLvSSGEo1TuZJf3Z6TY9DoUjzG0DfMZ62J7+AZnPgaTqJLV3Z595JG139L0JbWadPT2ZWssxRIdquKHUAdMrmQ+ZhYM6B0c4r9yEJPjRxEKN7hJV974yWuqNCgSRu8FV7uxwMoaFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpB9DDFvH3Mt3wVZEDHvhw6u7WRbxFchB0FPZWhL6Ls=;
 b=GamnESAGJIH6NUQUXVQ6DS7jzsFBhcHlf1J6HCoLvcm2qBgZZkOlwZZWV3+Gof7Ty04d+edcyCIZnMwdXd3CcrzY67czToA+SZvZT5j/J7OEGVE+0GzER3Gv/e18xEtAhNKxctZnpB8f0v2MCk40x3qLfFDN0C+lKDU6K0EGuZNsmHWiiet15Jm+dFEG5jJupiVUdyBpq3/HMKz14gdUNm6DMP5Aj2uU54Lla/YBMQ+X0FVi00Rzh5HH74kiFISF83oOpvUn+HV1Q139ur8WFRRHJDKGzWjk37GAr8wfzE4Op1fcWWSaCG6U6mm4A/o8zzNYxoRpjekG+ddS/4GtXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpB9DDFvH3Mt3wVZEDHvhw6u7WRbxFchB0FPZWhL6Ls=;
 b=iBKfhOTK9h9qtahyHrW8ONABozlJS/QU8nZiZFit9LDu0y4dgVprGaGvfXcMVrIjkhy72Jd7S8z40obiEINIQ/efNfffES07KXq7JFjIBuCJFsSVQV9uL+dcNwco+e2yOkAAQtirutgz7y+8/ctYGqCK9GZhjbnVMU+ynWCifKY=
Received: from DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19)
 by IA3PR10MB8396.namprd10.prod.outlook.com (2603:10b6:208:583::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 20:36:23 +0000
Received: from DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba]) by DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba%5]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:36:23 +0000
Message-ID: <e2d21ea3-bcd1-4502-9936-e54ac9f5f96f@oracle.com>
Date: Mon, 2 Mar 2026 12:36:21 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
To: John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
 <7ed13647-8b26-4c88-b1fe-af6c3ac41751@oracle.com>
Content-Language: en-US
From: junxiao.bi@oracle.com
In-Reply-To: <7ed13647-8b26-4c88-b1fe-af6c3ac41751@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY8P220CA0047.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:47::6) To DM4PR10MB6885.namprd10.prod.outlook.com
 (2603:10b6:8:103::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6885:EE_|IA3PR10MB8396:EE_
X-MS-Office365-Filtering-Correlation-Id: d522a4ce-646a-4f9b-1546-08de789b5e7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	RRdkNw3OfBYuYVY9dU6afvg4kEilYOckp3MJl6l+JxpxJXJrkocNFAwAbNoU40nqo58R5eg/G2o4NYnSSdqzb64A5YhZ7ZKfEjEURN7MAhN+HUGH+8xPCYCQj/NdNMSXtzfMsutbumJmhpv5UlCjYKviO3TzxMkxVnw+QUzyJfVWDf2GFqNPrDviJ/ZpogYju51YyAL/ZDmGQY4tWEK0mzcKkak/PBI3hLVNOgM1kS5vikFTR4OpoUO9l0XLTNS0nG5Oe0NSCxVYIJHY2zcZebKnF1DvdSqZQgrtFLOJEfLnZsCggXvccPidJJJFo0TRh8sgp/gZxwrFlqfz8gB8GJ5JLiQhRpNibC/37wE1K9hbojgAAOnAqoxqUQmFpyt9zKi4jB5AlCo3rYrOIu+baikgQ25sKxuLXRpulKIT4yKmhBo+4g23P3dBiJdWkHtnexaMYdzARhGNn5xFc45CbWzrJW0WWB6i3GsEVTMsCfnGXKH2ftQBANeEa18RRRK3Vbxx9TFo5aCZgDbeSONrwtwl2qjqct+igYRDYEOcIkr1anQ9gu+UnBa8zoyq0RPlHtvV5GjL4sebbLfEiO1TA1YUdRCX4avgIK5XGTObnSrm4k9OjSDS9VaDhYgblOtQ5bSWsxhjpmOTy5gJtFDphwAYUhfp7OHEjBwxP1vXau++WuUw19WckQF0YQT+qZiPPf8m4m/+MPrll+e48iJQPVVPhW6vpute3WQKBWjcogo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6885.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEVmeSt5Z1VDL21sbk9CVUVJNFJWWmtWcnlWc25ob3JzbnUxRU9iVEVVTnND?=
 =?utf-8?B?MFNQc0Z5di9RNXBMSWhPdXRQZzRKWVVaSlRUTFg5VkJrelVSNWhFQTRRakxo?=
 =?utf-8?B?Z2RYbHpxKzZSSGJ0TGtBcEVmVU1nYzRBR0VEVW03anhLb1NwdktXaDJDZUJu?=
 =?utf-8?B?MEhhU3Y4dkUzc1J0ZFUzc1VwenU1R1pjNjdMS09IWU1oTmp0TjIvYWpCdVV3?=
 =?utf-8?B?Ulg4ODhwaUc4NTVpRjB2amI0R05KdWFPdXNrczY1RUpYbzlrVWxpVzB5ZVFa?=
 =?utf-8?B?SUZmbTg3Tm5wM00wT3RKaHZSdUMyaG9CdGczQjZQRmdrQlJEbzZvbjZUaklC?=
 =?utf-8?B?VHZwS1dINU1hODVJK2lkT2cvZjVlLytPcURHVGo1Y2tqVDRqME1tL0hxb084?=
 =?utf-8?B?L2J4Skx6cDNNOFd2S1BZK2VCelF6VVlXZzkxbDRzYzQxeGRKMnhmK0c2dzJ0?=
 =?utf-8?B?OXR6aU1ma2lWRVFyRUxtVTRDYnNaWEhoSzJ3QklsdndZcjN4d0ZZQjdWZmFN?=
 =?utf-8?B?bndXdmgvdTJRTnlyWmhKRW1BZ2VYV0l2Y0UzMDRkbTJHbkhKRjNRZjcwOEdh?=
 =?utf-8?B?d0ZNdnBHSWN1SXRGSml0R25sVnppRzlxd2ttTzRrZWJ0M3J5aUhHeGQ1cnN0?=
 =?utf-8?B?UDZRZGswV2p3U0xwb2UrYTBtS1RiTHBoRm9xUVVYSUg3bUdYRnRrTWRYcGJ5?=
 =?utf-8?B?NFRnV0NlRTZkWHU2QWtRWXIwbzFDY2hWTUpnWkljcndTMkhUbEVHR2Z5eDRG?=
 =?utf-8?B?bWZSNm5DUDdWaDBvL25kcmhPb2RWUlc4ZENNeU9ncHFrWkp6c01ITnhJU3dE?=
 =?utf-8?B?aktIdi9HcmZ2WW4waTVZT3cxeldHWXF1NTh6TzdQR2hOOS9rcXVFUmRGUlBI?=
 =?utf-8?B?Z29EUDBzcVVHLy9xOWw2aWJ3UEsrd0ZrczB5c1FDK1hudUxXWEtzNUU1eWZR?=
 =?utf-8?B?UTAxYVI0RjV3ak1jZzVRdnVZUHhRa2Z5N0xPdW1xWmFrVVlZR3FyejNHeWpl?=
 =?utf-8?B?SkRLUUc2UVo2dEVtQWVpSnVnQWtQYVJtVEU5THlwNkFJYmY0eUorNmJhS2Vt?=
 =?utf-8?B?OW54K2ZkZ0w2NG43UmdLTzQvejV4V1psdy8zR1RESDc3UWh4bVZieTZYV2Zq?=
 =?utf-8?B?ZjlPeVRTdUdTSlAyeXNKZWZzSmxFZ1AzbUk3bGRGNWFqYUwrelJ2Z3pvaUhN?=
 =?utf-8?B?dVRrVWV3aWhMeENxUFdzVnh6RmpoSCtROGFKYjYyNEtWSERNVVExSXptaHo4?=
 =?utf-8?B?OThJdStXcjcvaXZ6MXFlb1VOYmo2QjJiSWxpKzZlbTFJWEtFUDAxS3dyV2dM?=
 =?utf-8?B?V0hjWDJ4ZFZuWGFtbXNvZTg1ckRqaXh5MmdpZUZyWmF4MFZja0cxa2d6L2h4?=
 =?utf-8?B?UW8xQUNIZ2kyR3F6TW9ZVjdRZmthdGdBRm5NZmpYVTZJcjVQcVo5eGpnTlU2?=
 =?utf-8?B?TXd1R2JUakZwblgzVDFWRkh4YTBNckJDV3cwMUZFM3JEb1NYREZTU3BMZTFy?=
 =?utf-8?B?MjRVaCtqd1RlSnpLbHVIZERGU2d0Vk54cnJubHk1ejdSRytkVS9XVkZwWi93?=
 =?utf-8?B?R1BPZWp0VUZab1pveGZIVmFkeVE3T2tRcFVBQVNwLzN4MVFLNzJFSHNIKysw?=
 =?utf-8?B?UDNPbXE1SlR6M2Y3UGJneURWUkVQV3dmNkpUMHovZHQzNjZ1djNocmx1MU9Z?=
 =?utf-8?B?aUJQYVdiNW1YcFhKYkc4K1NXRHNXYldEZ0JaWUo0a0RmYXFyWEhEYVdqSU5N?=
 =?utf-8?B?b2RrM0FJREhXMTRFNGRLOXdxTGx0czZjZTRpOVQ5MDdVakZTOTlJbGJwZ244?=
 =?utf-8?B?T2J4c1E1TXNpY3lMSUY0d3Y0MmNINmM0MTFGeUl5Z2tQWkk3ci8yN0YwT0VY?=
 =?utf-8?B?M1V2R1dwZjZVRnNLTzFtV2pyM2pYZFE5Q1VVdjJYTmRaVmZIUjNkZjFQM29o?=
 =?utf-8?B?TzdzRkszcG1za0M1WEJrQWIxUEY0d054VUNtYXJaTHFacGlXL1BnWHpMYis3?=
 =?utf-8?B?KzRSR050SFh6Z3BFNFFxcUlYalIya0hTRmlpUENrNkMzRUx4eC91M3B5R0Er?=
 =?utf-8?B?UGdOZnovdDUwb0JBdHUydW1LNy9pUDVtb3Z2Z0lGYnR4elIxS1FjRTVZZnp2?=
 =?utf-8?B?ODFUQlRSVldBUXA0aWN6a1RiWmdMeFRvd3p4M0NuZGQ4U3puV2lqMVJseHQw?=
 =?utf-8?B?akU4dUtHTm4zdXFSWlRlQkVlVGorREk1b24vaVRVYXE3Vm1KdDVCSllZM1d0?=
 =?utf-8?B?dS9uTC95TnlBTlA5cjhCc2x1cEFISnJSVUpmUU1aVlBTUU9zQTh4OGN0OE11?=
 =?utf-8?B?WFZIRitJaWFlUG0vWEh1RFdPb1o1K0dCdDQrQVk1cnB3L3Yxd1l0dz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R6NwehKZHILyndT12OUGjqrWzOwLt/E0xiCAoBFgqMH5fk+03oM22RZBTvlY2/BYRVhPkOfeP2yZVc/OE5VfxyMpeSHMfEqrDqU2vEE2AAiVZx0ea+cLmFL9jZ2zErSVENbBFlMWhqA9MkDzeST6u+kivCkQVpteRqxkVYexEh7cGdginGEQeIXYdWvu6RTB42+L4VJK95p329+nuYHCqlNyrsaVUx+llU2Jpu/qbUWn2+envvoArKjhqsu8kN1rIcEM2g8s/9aYG7MGc4ihCCbfyZ3XcQgV5OlM4xtgjtjxQ5Fch7Ocrkgn9y7mRFsMEEE76yTqK2P87Ad9nKnBOG6Csp1Bk99Br+N7BiX9xWL73OPcEoZxSyn15fJR2KPYL7h0zw+YialOITyHe7iFtyxV2m3wXwX9+zrmJj78vv89rgcfzTT6F7aJAGzvxHqPHPrz8P/n9AAmuXe2r20Tg56XFqVo2lC7GrvYPOKMTD+Eyqd4b/KKHaARc+vva5Rci+pv1v3k0XD1+9n2MKglbF04qJp1qOrBvWC4qRBZ1kP8Ax8yN487uBof/peyi4nUcQqdAtHgJpvYa9nh55RfTxoZpFqNg7uZGhRY+OFvZ5Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d522a4ce-646a-4f9b-1546-08de789b5e7d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6885.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:36:23.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOeu74hokrVLrbCNRaZvejefQYkakofisPo0BeEg8SWBlwA9r11+2KDjplh3DTLjrGK7wam4FeAOUUdE816Seg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020157
X-Proofpoint-GUID: icW5BFrdEU_V5PX5oKixtHe5NOh7rQXp
X-Proofpoint-ORIG-GUID: icW5BFrdEU_V5PX5oKixtHe5NOh7rQXp
X-Authority-Analysis: v=2.4 cv=cZffb3DM c=1 sm=1 tr=0 ts=69a5f4cc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=TEqD-70CHJVzpt5ZZeMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12262
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE1OCBTYWx0ZWRfX4i7y7hALCjRi
 FpXA0os7ghL1DAlggV9rmhv4oIt8wlQwhzcv3qppdJ7ptYM1yS2xmLBb9BZvRFD3/x+o2CEk/hs
 crG971+o1Ym85S7HZrO9dnDZWlGEQfcjRNeeTfvysIEviUdmhJLy+QfF4Shut/SmCG6GnknS3HG
 jTl0t1zd2NLK1tA3FoWiQ/3Aqbz1JhqckUJtu6n3bTRVz8eD2aEMvBuZmEyu23oYcHxe2YFFOBV
 0HbLBJPbHFT364Bh0bY8/l3Tkm0RUQZFuOO6QuVcCdeLgMNmiwc0kZ1+ZLRhHaxqoCl3E0H6AvT
 Z4jqPpJl3ut3v4fZZNhidSsrECZlnwnXtSSsGMxeQa0NsRxw5PclIao1XFYOwrOjW7oBl4fchbq
 Je84ljrncJBEXnPZ8kFifcKjJyxifSWQOidAeK43yuZ0ruI3ANUuvOTSSPUU3XJH7m08t5vFUj6
 YCN7oNJPFGmJIY9T23DF3H1Mn/vCE4KA1LygvCXs=


On 3/2/26 2:30 AM, John Garry wrote:
> On 23/02/2026 23:27, Junxiao Bi wrote:
>> This leaking will cause hung when tearing down the scsi host.
>> This is an example with iscsi, iscsid hung with the following
>> call trace after this kernel log.
>>
>> [130120.652718] scsi_alloc_sdev: Allocation failure during SCSI 
>> scanning, some SCSI devices might not be configured
>>
>> PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
>>   #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
>>   #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
>>   #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
>>   #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
>>   #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
>>   #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at 
>> ffffffffc03031c4 [iscsi_tcp]
>>   #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 
>> [scsi_transport_iscsi]
>>   #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 
>> [scsi_transport_iscsi]
>>   #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
>>   #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef
>>
>> Fixes: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>   drivers/scsi/scsi_scan.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 7acbfcfc2172..c64ef71633d8 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -361,6 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct 
>> scsi_target *starget,
>>        * since we use this queue depth most of times.
>>        */
>>       if (scsi_realloc_sdev_budget_map(sdev, depth)) {
>
> At this point scsi_sysfs_device_initialize() has been called. Then if 
> you check the comment in __scsi_remove_device():
>
> Paired with kref_get() in scsi_sysfs_device_initialize()*
>
> So I wonder why we don't call __scsi_remove_device() instead, which 
> calls scsi_target_reap().
>
> Indeed, the current error handling in scsi_alloc_sdev() is odd - we 
> only call __scsi_remove_device() for ->sdev_init() failure, but 
> nothing happens between calling  ->sdev_init() and after 
> scsi_sysfs_device_initialize() which means that at this point we 
> should only now call __scsi_remove_device().
>
> * I think that should be scsi_sysfs_initialize() and has always been 
> incorrect

Good catch. Thanks John. I will send a v2 with this:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..c2f70de5c093 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -361,9 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct 
scsi_target *starget,
          * since we use this queue depth most of times.
          */
         if (scsi_realloc_sdev_budget_map(sdev, depth)) {
-               put_device(&starget->dev);
-               kfree(sdev);
-               goto out;
+               goto out_device_destroy;
         }

         scsi_change_queue_depth(sdev, depth);

Thanks,

Junxiao.

>
>
>> + kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>>           put_device(&starget->dev);
>>           kfree(sdev);
>>           goto out;
>
