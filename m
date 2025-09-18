Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6729CB4D
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 08:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758182497; cv=fail; b=YRuWm68gY2gkYqJ7+uVYxxEW5gXGiBqtU6D9IXDoCHT44Bh4++nfQZrRi7+sa5zMHzK3jYEB0nL1OvgAQMuaeCiyOt0Fy2SWcEpBEtMV2xqnW5h+oW8Z8r1yCNi5rMsDxWl3Bkpi3oZIv1W4WpFLRcSATS3+7cTaYja8ZdJeoXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758182497; c=relaxed/simple;
	bh=4D6daH4Rvt6oIaNM+CwNs2mNn9UhgKj+aefkFtI086c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E4tZcr5P5PSwlUwDv9yNoD9EopcJNZt6YRabRGDkt/7gEIdao2DvB7aj5wMdBUbvcjBtd6/qtlziQS1OoCc8UPfwCqbp7TMNp40ZpsGszV6bT0Dh/3FnLfWiIn3g9NDqEvFFdPucPiw6jJQbnStadSWxWerAuPXt8XPEK3NXxUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jGuVIoOK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A/Xq+nnE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jGuVIoOK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A/Xq+nnE"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7ft0g008946;
	Thu, 18 Sep 2025 08:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6N4eN9R5tFJ5aud4TddnDrc8LaJLXFHtkHylwUpWHA8=; b=
	jGuVIoOKVX7+BXPhFz1lQ96xhG8c3CNfpg9nmU4Osv50szxKIc84MyJBukpL5qMw
	zcll0liZG0fORxee2wnAK9enyHbC3pm+JdJ7g0Bx+rmXyNMt8lKQqhHEocbzL3XQ
	V+ad2V/E8EOeIKvlF/TnSP/n+DgYs9aJqqAZMKJJ9T1GmKL6Aeal3olO5rFxvG+E
	aegEEJ+zqKC/4QzD2o3jdo9nbira9KkXsqbj38ExY/ExgDwCsRqPCETImRX984Zj
	7D8UhUnhsa89eVO9d/M0Z3pFAeGyglGWCc2YOq6aoOK7iaDb7OTK9ribm6aFTBe6
	HRQv+U55yTe4jH0bhMw2/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbtx8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 08:01:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7bR4Z036849;
	Thu, 18 Sep 2025 08:01:18 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2etpda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 08:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R75xLYf3UCFehvdFDbGuIsHWJmY5r3zmg3Jv4h8Jk9UjFyPp/XmsH6ECaTMZ25itty2MrHW/QagRu/+Sm8mkrY0EU4UCHZarX58+8hLcN6VJQD7p+DDhvW46Fh++cJd6q/uEjkbQd+XE1dgDUhoW3NUYQWiOA4UwAVCq0RE87PY61nxrcHdfZ+RqswATCHOOBbqRyhhUF9NWd+2qo9+H875NgG6/gNHEeVj1cSL+w6hZS8xh/A4awZZ2wIgp9u0Ao1Ygtqo9v958gYXx1ndtC6uZgiAMt+mcB2oiX2Ma8mrcylhJU1BW8tQC3pAaZGkNSvtQYP5BXvqGn2aSgfuU9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6N4eN9R5tFJ5aud4TddnDrc8LaJLXFHtkHylwUpWHA8=;
 b=U+dkwIm1oNVYSsiHO6QLOWTw7xpSxY84yJ2+mNPv551aCPWSFz8JE1iaB+Sb+LBcUQCNelyPXNzK52kiI57uK1gol8scYh8xvs6KFzok7Z368qNSlaYdFEecH0thByY+78ElbpoDZO/28+n9KwzX2Z2ueR+2ANoANfM4TUDLrmlScPM0Z90SXUSF/QI0B/wPx8/rYhYYq6avSmqYfwjJJGTs1FmhslKkvrqz55mXIPV1m+WHb46siFYQl+tLO1xZIYQ+Cup5yT3nDMtAqfZhBV+8zKHbWYrB5trGjaPbR+CrFRtD9c3thJS7gZm7HQlq3QZJhWAf2tZlCb8fxVjoeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6N4eN9R5tFJ5aud4TddnDrc8LaJLXFHtkHylwUpWHA8=;
 b=A/Xq+nnECjStIsDOzL6tZeIysEQNs7xd276Cp+2aYy27LcbakefG+iWBB1tRQnqqimeWtKGlXSQ5Aq+SP8ReJe5CWh1vQowdKUHcl8D9fvht0SLftRxZBcTDWVxGDZnfv8i7BOJIdqfNty1MzXvfVlYaHTQjRuP2pTvX2pqoYEU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA2PR10MB4460.namprd10.prod.outlook.com (2603:10b6:806:118::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Thu, 18 Sep
 2025 08:01:15 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 08:01:15 +0000
Message-ID: <331639f8-e162-47fd-aa7c-070bf36d1dc0@oracle.com>
Date: Thu, 18 Sep 2025 09:01:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
 <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
 <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
 <d175ed35-874f-40f7-bd34-15dc13d58b5b@acm.org>
 <e7ebba4d-d09b-4823-8830-6aeb6286bcb5@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e7ebba4d-d09b-4823-8830-6aeb6286bcb5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0274.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA2PR10MB4460:EE_
X-MS-Office365-Filtering-Correlation-Id: d5bb463c-365b-4f60-073b-08ddf6898a57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXVxemtzZ29jNHV2UE03WFBabm1FRVh6NCt4SFIrRjJSRjNGME16Mi9VWmRN?=
 =?utf-8?B?R2RsTCtHUDVNZC9qSlh4T1RXc2VLMi84eU5RUVFhQjg5RU51ZjBkVmE0dXBl?=
 =?utf-8?B?UmRXN0NyYW5XWFJ0eGJQa2puYmYrZy9JU0hNYld6T0s4QkI2WlVBN3Nvek8r?=
 =?utf-8?B?MGhTRHp6a0l0dGpCcjFSZXVPa2VVamFDV05RRm81NFZnUmlJWU9PMlpBQU0z?=
 =?utf-8?B?Z1NaUUxmbTQrTHVMK2J4WmEvc1Z2T1pPZHQxK05NeGczb1dRYmhMdUhLNkhH?=
 =?utf-8?B?MFdCYnFnYWlGWWhwdXVnLzJMczVTN3FSVnJIOWxKYkN4VkVIeEpVT1hEZ3A5?=
 =?utf-8?B?M3Y0Zk5wT3lxdit2NGt0TDZrbHI3VHV4ZndnYWFNK0E2dzJjbnpsV2Y4bUQx?=
 =?utf-8?B?dTRHdlgvT1RzelRDaWpqNC9pWmtDbHRDMDBvNzJHTVdjMWJJcWttL2QyZ1N4?=
 =?utf-8?B?QUFWTVNDb3FWM2VCZ0JaOGg3WE1KRmdlVmpGQ1pXMnYwamk4bXVkcFRLT0JG?=
 =?utf-8?B?aUlIMExiYmVORWlmRTQrTzhhci8rYytwWi9uZEttOFpaS2pxMXdobVlIbUNB?=
 =?utf-8?B?d2E3S3EzckpPd3kzTEJubFo0SUtOVnV4TlUzOFRsbXh3UzhlWmdxRDVOeEIy?=
 =?utf-8?B?TEVma1hQRnptMWM0ZDg3eUExeTlpeFBldENYZDZ5ZFR4eWNvQWpUZHVFNEkx?=
 =?utf-8?B?Q0FZRDgyVWovZXlnYlNSMHNwMVIwNW9MNXVuUjkzdVprdEY5M0V0YW1IUWNG?=
 =?utf-8?B?dXlPQ3pmUlU5OHF6QzA5Rk1pZDRkUW1wSy9UbXdnOC82YTRpWk1CTk1ER0I1?=
 =?utf-8?B?VnI1d3dDSUZYUEx2S21QWUJTekJLdzZYOXZGNWp6N0Z4TmU0b1hib01zM0wr?=
 =?utf-8?B?cHNsTXA4bEE1aGtXM2NnTHRmQU4rZVJIbmJ0UXlmT1dtNW1JMXluK1dVOEdI?=
 =?utf-8?B?VXlSL1BnL2VpbzM5RUsvelFYdVBEczRXZjhEVFdMNEhuM3RtWkRtZk9nWVV5?=
 =?utf-8?B?ODgxSElLZE02VXRtTUV0NEFsWXhLV2tFbzN2dU9lT2wwSGlWUVlXZUxjUTg3?=
 =?utf-8?B?eThEdzcyRTF2Vnkva0hjNmRsQzJOSksvNXBqUjlMejI3Q05CMmhVcjNlN1lK?=
 =?utf-8?B?QnhRRU9QZ08xdmdzT1R6SGFoVzMwTG5TV3doZWZyNGJtMS9vblY1WGplTU9B?=
 =?utf-8?B?YkFoanhCckQ5ZlVDV0dodjZ5WVJkVmdjMHk1UnlvNlJzZDFFY2ZMVkR2V1k5?=
 =?utf-8?B?R05IN3UzTXIxVXAyWElKbm0vbGNmc2V5Rkk2cWtmSWpTR0t6TDdkQWF4L0lQ?=
 =?utf-8?B?TXdXaldSNVhuVlI5aDgxamhBVUpFTEs4SzdpZ1ZHN3F3djE4bHJhZE1lbU1s?=
 =?utf-8?B?ZFUzM2VWUUQ1eFhsSkdUZmtMVktqVk1BcG8yaG84RktkSzgrUkxybjgvdy9C?=
 =?utf-8?B?OFU5M2QxYlRCVlJvaHVVMC96UHRRUDlaM3hrbGlCUjAyQlRjMWxNWWxOak1U?=
 =?utf-8?B?dnc2VmVIN2dxNXVQY2pyU2g0NXM0Yk44WG03UVl0NVFCSEcxeVFDaEU2RWNq?=
 =?utf-8?B?emk1S2JzVlQxMzA0enZsSCtTcGNNNGhtQ28rRmlVYU05YWpaaHUwaU8vaEoz?=
 =?utf-8?B?d0l6MG5sSkJ5NjJTbm9LOWFPc2xlR0FtUFZnSURmNkpRR2RiYzBvVFFMWlJ6?=
 =?utf-8?B?SW9GT0hoMmVucnNoMmtGZjhBTHhTTTNVSUhjSVh2bDNIdTF2QmtBaU0vUnFS?=
 =?utf-8?B?NzdsQzNzZlo4SnlsbFhsbE96aEgwbUZvaEZ2eS9kU0ZKbXVvK2tkTWZyMmR1?=
 =?utf-8?B?b3FNVE1rQUN0UWJxNHQ0bTRFbnpWalVKUmF1ZlNmNk9IelhqcmtpLzdlUFRq?=
 =?utf-8?B?cHZzK3A5S1dQdUVkK2pBcnhNYi9aY2kyRW15cU4xNTV3am5DaFFTSDVhMWh3?=
 =?utf-8?Q?srZfDDds/mk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anZqWVY2MEt5T05pRnVPQVMySng1QUovZEFjYmNhMFliY1E5V2ZoN1FhYkJW?=
 =?utf-8?B?RHV4VjI4QnhRQ052c0VrSjhuWVVvQVYzcTMzcWlKbmpiVGlpS2wvNWgyMVZx?=
 =?utf-8?B?OG01dnBUOERsSy9lVXhvZXUzS1lLMU1Gd3JjellhZDZ1T1ZLVmdaUDV5aFhE?=
 =?utf-8?B?SUg3L0ViYzM0NFhSdmVRM3dFMG4ra1NPQVlzNkFZVzlCME1iMWcyN01vS1Rv?=
 =?utf-8?B?OUFhTmpvUmwyNk1xMFAzR28wOGtjNDZnM0dXV0cyYkY0b3lMQ29pQmltdzZR?=
 =?utf-8?B?RUtIeHN4KzNVeENmSG9KejN4bHl2c3hvNmlWNWQ4enFlTHZadDBEWWxpN28w?=
 =?utf-8?B?V1k0Sk13MWFoTjRzc0JTYTFORnp0SlYvRHN4cTNndWhkaXlDYldrUGtEeHAx?=
 =?utf-8?B?VzRkN0psSjVqdkxTWnJ2QXZRUmVFZVJERnJWMnZBczNCWjRXUmFuNlJuNnNN?=
 =?utf-8?B?OXcwc1UySHRaTkkvUUlJL1BaK3lWM3YzOC9IQ3NRS2d5dTdUSDk0VllzbmRW?=
 =?utf-8?B?Z25pSVRDbjE4TW5xTHhjK0t1RVhFSEd1T3liRmJrQ0dWbGtvTC9Tb1FONkJG?=
 =?utf-8?B?OW43U3hxdU9Oa3dQTk1NZkZKSm03bnlGUVVpVTNNdzFocnpXRmw1VUtZMWxB?=
 =?utf-8?B?Y3MxSzJNQnBmQnphb1V5b1NGY3YvZ3ZKZFNaTkdNNUhxNmF1Zy9iQmVCcnJ2?=
 =?utf-8?B?WDRFb0tmZ0dmaGt5Ujk2T2w3dTdxak1IdzFZbEFwdE1IWTRsZkJuWnlWc3BG?=
 =?utf-8?B?eDh6Yjc4WGQwT0NhZTNCaE4xeXVSWWtVSzlhZXpxSlJTZ2Zta0V0R0hSQ0pn?=
 =?utf-8?B?YjJ1b2NRZC9rRk8vSHlKMSszbms2OW5tbDVwcnRkNVRZVFVUZGN6Z052WklN?=
 =?utf-8?B?VTFNcG8yWUxmR3FxdjgxYnJIZ1FKRHhQNlE2bDVBUzZ5NnFsd2dlSFgxNGtU?=
 =?utf-8?B?Sk9HOWNsQ3NEeEh5NkxIUjdlWWVrcVdDWEVtTU5Ua29UejlpRUZTbk44SmZa?=
 =?utf-8?B?V09vemxVdG4wRjlWcGRCTmlPclNBMXk3UWNHQVdBdmEvVUpqRlIwR004SXVG?=
 =?utf-8?B?Zi9QMU9yTGNWTUMwRlp6NGNPK3RHVVdmWGJCRFBwekR6N0xmeE9UN0oxSXRQ?=
 =?utf-8?B?NTJCNTVFR0FWb1lReXhoSE5PUG04Nk9kanF4QWVudWlRRjNCVUtUeS9iWUZh?=
 =?utf-8?B?WVl1MTEyUTBBRGxaREpwbDJOdHJFS2RQZkRMU2NFYS9xSFZSVWtZZnI0bytS?=
 =?utf-8?B?SGpNZUJkVUVSdldIbVBCaFV0cGlsNGZqVVhYR1RSQmVaL1NHdGVqZ3M2UHFu?=
 =?utf-8?B?NEZkSkVybHZ5Y1N0OGE1aHpaaXkwUHgvM01pcXdpMjhsNDRUYlhWM3AwZWIv?=
 =?utf-8?B?eFhZU2drbGQrb3VJalZpZlNsQWFROWpEd1JuQTJweWgwcXdYTGU5eUlhQXIx?=
 =?utf-8?B?dXMrOUpSVEZBOUJhOEdZZnNpMmpSb0JVQVdzKzdSbVlRbzdIdEswUldPblJG?=
 =?utf-8?B?ZTErbVFtcGp3Wk1kM0xkUndEZGlwUHR4NGh3ZlJDM3RsbXFSbFVMTjgyeDlO?=
 =?utf-8?B?d0pyaHAvankwdm5tOFQ4dmFJdUYwT21tODNFUlBVUFpqeGw4M0xubnN2Q0FS?=
 =?utf-8?B?VWp2azY1dTNEV2tYM2VUK3A3VkVkQ3FPYlQ2MzJYdGVDeWM2YmFUMGVyS1ZP?=
 =?utf-8?B?c1pzYWtPdjFwN3lTb2l0MnZFY09xWGhSSHV5bkVDTmtaQk4xbmlNcktheGoy?=
 =?utf-8?B?Mzd0RWV4VEtTZXNJUnF2WS9raGtTWEYvS216WnB4UysvRGM4akx4MnVna1JN?=
 =?utf-8?B?RXNVTUJYSnJsNm5RQmtxMnBVR3d6cXBMd1NRY0JuT0ZIenVRcW13NmdqVGtk?=
 =?utf-8?B?SDBBVmIxR3RtdktSMEl3Ry9TZlNzQjMxWDU4RHBxZTJZMTFlZ0JvZzFYeUl1?=
 =?utf-8?B?TjlMNzBRMnNuTjhIVG0vU1owSEs1ZEoxRzdCdlg3ZFIrNmdiZXBPTkRxMFVw?=
 =?utf-8?B?SnZMQ3dOTlQ0REJQUFFWS0RlWXQ4L3p5aUJKajZFUno4S2JSNDFUVVhPQkw3?=
 =?utf-8?B?YVVKT0FvN085QXp6VUJudTBhektMNlZJSW1PQ1JSbHhQTlhGQW1wc3AvWWpK?=
 =?utf-8?B?QmVEeGwrdXU1bUxWNlEybW1kWGo4NStSMWJoZTkvVHo4M1pDbWYwR1FPL0Qr?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sgzX951o4ZRs5oK3/TD/h0z5sme1pBBbBoJ3pDmUoRwajVcyYqx7lp1UaSdS5Ad1xocon2jC56T8FIGdxmLqdWTY4HNezQzsc9ychQIzzxv2NI5GWY91g6HKWvvVzZsBcdkC2GvpvE1hUC4momUzBwjbHk2A2c3CmmO/hoXRBc+ffJvWntRfL39KxjFffF5EfMU47rEHOjiuHAZc61CCA/PEDkqBrgIkNxhG3m9DVsJdTLG//+xg6mHpVtdP/O8XBC8cYGu9vKJkXb9jOUx5Ktl5VilFA2emSRr3y13grfxRASzTGnG9AsYVt4OwWIZdqKyiyfoTsAPXY3cBXQhk0+p2PosrRK+zautgHr4rvwjM2O++nA74y1HgEQQ43/ZprnGpTevQlKiC/gOLKCcUXJjx8Vv+i8hR5PqJrPnaAm5nSnA+UCgX8UpWunZzDZiHk8lP4xBkdUNQz3UqcDxjT3hHdUanHmDqzvO1/pFmvNXn/1cSQ8Ts3foXO6TI+Y5hG65+Tfh+cE046FkZnhkx+r8xjHTrzRamg73zCshfAYagPpGThvF5s7qcsu379K4KChSAUj4b8lsgc4aBOHd8TWFwtGOTHWkQQQh3l5aW/ZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bb463c-365b-4f60-073b-08ddf6898a57
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 08:01:15.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O219uBM64tHmuoXmq6tD4PD607vX2z11ODuJDnqnMJDr4F+L2pQKVarKQsQ3OlzauG+RBguK95n0UtTDLcManA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4460
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=951 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX20SObee6eK8u
 9NIPudv6mqSF0st1C90T3UK81tEb9FcGuNS1w5FkH4XNfPXC9mi9TwFRNfUIwnc0nQBQALSCrxh
 nK5htle1amRVvCwwXXjMpAZ7lPww9vR2F8wpIIWTl/mzrs3Dj6d163kuU6E+iYA8vfV1+n5fHOq
 hVFE8ynH/vK315AEWphbJvHzVFKdsIskqW3wKHl1Ml/xVFYz7I/Fx0fiWAfXb+LSuiYMw4Pqr95
 /z5Zb4TOKJ9T3UhcsjIdd5ZWymkckPYYGvN+W0xAkHyF5sMIfkLCprqHxPVFNFwXgOFMribPHEv
 hzDKBUm7KBKSXuWFQJMrgY0DvJgR4N27p/AjyNzsUv7Dmd085N+waXoiOVURn5p0BzUB8A1NLaH
 VUB1TuWMhX6OKlXU2BSA5w86qPP8pQ==
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68cbbc4f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VTQpv1lu-j0gs7UiVgQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: en-Xtywozb3Khc0aBcomU5MGZ7_PCJnO
X-Proofpoint-ORIG-GUID: en-Xtywozb3Khc0aBcomU5MGZ7_PCJnO

On 18/09/2025 00:42, Bart Van Assche wrote:
> On 9/17/25 11:21 AM, Bart Van Assche wrote:
>> On 9/17/25 6:08 AM, John Garry wrote:
>>> I know that it is not ideal, but could we use scsi_execute_cmd() 
>>> @buffer arg for both in and out data?
>>
>> The scsi_execute_cmd() buffer and bufflen arguments are passed to
>> blk_rq_map_kern(). blk_rq_map_kern() shouldn't be called in this case
>> because:
>> - Calling blk_rq_map_kern() is only necessary for data that will be
>>    transferred with DMA. The 'args' data won't be transferred by DMA.

I am just trying to reuse what we already have without extending 
scsi_execute_cmd() further

>> - The 'args' data structure is typically allocated on the stack.
>>    blk_rq_map_kern() copies data that has been allocated on the stack.
> 

what's the problem with that? It's not like we care about performance in 
this case.

> There is another concern: passing the scsi_exec_args pointer via the
> scsi_execute_cmd() @buffer argument makes it impossible to pass both a
> scsi_exec_args pointer and a data buffer to scsi_execute_cmd().

I would not suggest to put any pointers in the data buffer - just copy 
in or out the data which you require, like the example which I had for 
scsi_debug.

> This
> functionality is not required by this patch series but may be required
> by other drivers than the UFS driver.

Thanks,
John

