Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D0317716
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755333483; cv=fail; b=qe1ImNwOmsYBNqoOg39BuIn+oG7mA3I8ydFwGcMjZW7Bu27F9WbNC60nrodL2jbja9qAydnjlywKxl8fjaBeUhay2SQnbbpofp2rn0wnezmJ8xpTXtXhtDYl3rkWvTgoQmTtXSxGlW957h4Rxi8OkwrEgytvnOF7yI4Fe1wU7DU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755333483; c=relaxed/simple;
	bh=A8xvhEPZB6eCvI2CvetU18zZzc0vJHQGTt2dfLNqVXU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=krw2IZ8uPCdSeHIMLrW0WSyiaVOlwRZunWSWWAP//cAPgu/hePTup5rVCnImMBDQ+qOhzA43sofzqmCu/G+/GRh6RjaN8rWmsZJ4QJpshjx7xnahs9rrh27wz1Y1Qgl8yZkYD1ZfupMvNK605XtOmfL8rDvr1DCe4WpagMc0as0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SHZhYh7U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oq9vOqMU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SHZhYh7U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oq9vOqMU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G3g4CH023773;
	Sat, 16 Aug 2025 08:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vw55uVc9/nnsmos05ujWqh2cDA3uzUO6izOS+Isa1q4=; b=
	SHZhYh7UDBXa9GjaumKwlk97Zqa06L3YCgtrbSinYnugnPEJ0P/9SFZhsHp1VQ79
	NAfsm2613S7smqGAW2dFKX5K3RyQm1rR9yiA4x60o5RPO/baxSZqbYDHok9wo65z
	rbvkkCunC0QomGXEooyGiTwb+KGZlCBgNGNYkayBhgZmwHJ1/Yzk5YSEPQmrVySb
	rUI0HHMe42rW11FaBoJuFAfuIjEjLf9kUq0nVu9EsQ76OVniE1/hnC4yNPoRuOR8
	3TCL4WmCUaRml6/lvV0mdAMV5waRlmQECP/8bsAWaCKMnC+e/y3zbuQVxeF6tZax
	wdenyks+qXy0BfVJYPvaxw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgdfg9bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 08:37:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57G5eETb036816;
	Sat, 16 Aug 2025 08:37:51 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge6r2gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 08:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ylsNAfo4bd/ON6H0OkuI/J0JPE1SkAeTb89t3kh9XJBTHzVmhmH2lgdPL1rad6lFCeTns51OAHKYRmwPPseMB5NqYWeKBW1/UANdmbWJSoGrrVj8twr6mrjQJhpxQmdGTy4lNbhLE5CnQAYIf/Xawp9yn43eOwDg3nexnRbDoMyvtnMT5sIeGr2lg2sTEc1sRr2v9SBUWRRhOHtG7Nfn/smL9l12WXPnA8slhxRm4wYHnf49NsLvrDQbdqy9nAvQJAn+NK8PJPbqajwbmmXiTbHOjDSKHF14xsN5IMoSc9rYd0hWJlt8hWyMoOxC9zgjKjtA0hakQH+dCY5otlcISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw55uVc9/nnsmos05ujWqh2cDA3uzUO6izOS+Isa1q4=;
 b=ldSt1TGlvHu4F5wtPyBvmml35PvYNZ31C0SzfOlcLqILbE3SKuxIcwKXJ6hx/3wq/5phOTopNtst4/77TMtD9jjRIsuOjsB85WvFlcokQ0M7rn1Zvb9dEdsVGmbHVwrbED5ZQMSth9ZAVOo4P2nj6n4CcVR03nxWnmPvLflZru370eufa4/Sz9Wm2uAvJjZlBivbJwivBDwjI4ANK4RaJ1XusmykWoZJ4IVbUSUBdr6OqDYGCN8giGeFqvWTc+WBSTfWGFOWqY598H/n4qn90EQr7baVtBqm6fZsgiQUc8GiPcux6ia/qtGQl+WiiFbjJ+Kjzc1tdtF+Nhy53NqA8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vw55uVc9/nnsmos05ujWqh2cDA3uzUO6izOS+Isa1q4=;
 b=oq9vOqMUUoVqSPtSBqjJ+an4xX8wHQN11A1ZOaLMd87oHpHMzLhcikVuCSWbt5fAhMZhx3PYLCwRlhMbC4UsulwAt7GsIQYQZ6bQuL5zpjVVcG92dXDtgqFAh7cARnm61Jcx72sbiT9rxffrU7nWWkQtv5Ql3IANyga6DeOpAGI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB5693.namprd10.prod.outlook.com (2603:10b6:a03:3ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Sat, 16 Aug
 2025 08:37:48 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.018; Sat, 16 Aug 2025
 08:37:47 +0000
Message-ID: <34d25450-ecbc-41c3-bfab-ba7598849886@oracle.com>
Date: Sat, 16 Aug 2025 09:37:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
 <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
 <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
 <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
 <5a5c975e-9514-4adf-9888-4149e6d201a0@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5a5c975e-9514-4adf-9888-4149e6d201a0@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB5693:EE_
X-MS-Office365-Filtering-Correlation-Id: 334e1ec6-cca9-43af-6b07-08dddca02da6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXhLak9SQzIwWVo5N3gyY2o3eStBYzBnR2FvWkswNEpDZDM1c3JYLy9XRTUw?=
 =?utf-8?B?Yzd2VmFRRjYxTHVkWFpwU2tKY2k0RVlaN0ErVmtLOGp4NmVLOTFmQUczRm1V?=
 =?utf-8?B?SEpTTDlQelNEZURiTVh4TlRnOTBIRXN1cXlYczFCSDZRYTZ3OXFGT1pjVVd3?=
 =?utf-8?B?aGlRV1ozZjJZamZ4L3BuRzR4aVYxS1c2MGtwS0NRV2hxNVduTjVaRXNzOHJ4?=
 =?utf-8?B?bEJNZXluVE5oTjdHM25lMFVtV0pEQ0l1eGNNRkxucCtaZ2FQTnBoWi80SndU?=
 =?utf-8?B?Q1paNzlCSmpLQUdLN2k5YUQrUlV4MnZ5RDBWNVN0T1hPbWNObnlpMmJzdS96?=
 =?utf-8?B?N0Y4WjRLOXRyM2JMNktOdG1VMWRlRllWZjVLbFZPSzArcDYyZS9mcGR2M01p?=
 =?utf-8?B?MjhLL0UzcDdvL2lqbS9nV1pQTGRDOGZnZllDcDNqUHJJbVlxSzRzUHEyRzR1?=
 =?utf-8?B?Vlh6UUNWTzl4RWxvRFE1N1BacGdOd1BCc0JEQXFEd1haYzFRQ25tcXBNTlRn?=
 =?utf-8?B?LzJUNkQzRVZYSWxodXl2bDVNV012bCtHT05zQlN5b05vdW1Ya0EwV3FmdkN3?=
 =?utf-8?B?RWZqUVpQWlNVdGp0MzNLZkFlWVFySTVPY1MwbkF1OWdIc0NqR3hJdUlRZVRj?=
 =?utf-8?B?T2ZCVmRvWThYaXpsNkZRaUJSWktCRGN3d3RVOGt0QWQvS1RmbVM1SDBpdzYy?=
 =?utf-8?B?Q2x0Q3lEZFN1aGJ6Sk9SRjJ6QjQrV2RzMUF3SHVJQjJHTEozZGR4TmRGRXdH?=
 =?utf-8?B?M2xUZzlZTTdCdkxOSldrcHhIbDNOemdXMTFQcjh3ZVJnRVd4dkg2cy9kV01k?=
 =?utf-8?B?b3BrUE91OGlhS1JPTDJtWURnUXFvVDlHUkhiRkI2Q29MM3N3b0tBQTYxSEp4?=
 =?utf-8?B?Mkl0Y1NyZVNqWm12cnlGMjR4Mk41dElpd2hnZFovaDVNZFBXSGIxWDcwc3Fx?=
 =?utf-8?B?dEZnNktTVEhKT09hSkFqTzRLSXdtUktCZ0VWdHhtOXJEL0ZXQzJXUWhNRmhR?=
 =?utf-8?B?QlF5cE1kbERDTmtoNEhIaFNTZGxHaThWZ1RxZExLS1NSREVJV3JmYUJONHYz?=
 =?utf-8?B?Z29SM0M1QlIvSGg4cG0wU3FiR0VTS0NrU2g2cW1RWUJYSGN2czdCdS8rdVVl?=
 =?utf-8?B?UUllTmMwMjdUcVpDU052dGl2QllUREJDZFB0QkRaQmJIM1EzWFNDM2pOOVJY?=
 =?utf-8?B?dnM1UkV5TFZUWHFEYzFDeFc1aTR0bCt0Uy9pbUZicXZma2tMMHdFQXZXQVJz?=
 =?utf-8?B?QnB2YUZ0OWpYUGNCeGlna3QvUzVFSWd2cUJ6ZTdORmxEeVZpZmt4RmhLVkwz?=
 =?utf-8?B?TlUwUHhiZG5yYXVBQjY0M0lEUGt2Y3l2czl1aGtWZHorTWVxS3VyZEdVN3hy?=
 =?utf-8?B?clRRUGxnaGhXdE5JMkRNOTdJSndMeGx0dzg0UGxnNUpKcWg3SXFoV2FzN25k?=
 =?utf-8?B?eUtVeFd3QVhIMDhibHRPbE42THdYUVQ4aWIva2N0Rjg2bklsNElYK3BUM1Bh?=
 =?utf-8?B?Z2trblpQTUlmZnI2UC9xTk90OFJhdDJDMTl6VWxGVGV0QVkwOGdmaUMrK2xp?=
 =?utf-8?B?R2hDWVB0S0I5d0RER3hwV0llVnhtUkZ5c1JUcXI5aFpEKzNDc1YzaEx6ZVh4?=
 =?utf-8?B?RDFBT1ltWit6RFNUN0NmNkh2WHNud3RuWkt1Q045cUhkbWs4Ky9HWEcvMjM2?=
 =?utf-8?B?SEtJaVRTdzZPTCtSdW1NOXUwQXd3dnMzMUFrOXhmMmE0Yko1clNEVFRjUTlM?=
 =?utf-8?B?T0o3VXdFdm11YzhnMWpvcEE4dStLeEJ6YjllVWo2L082aWQwR0JvcE4ycU1r?=
 =?utf-8?B?aE81Y2xpN2pIVlFCa0drSkdacTNUWCtZV2I5ODJJVDlTU1RaSjJsWVMxU1dU?=
 =?utf-8?B?aU1JQ3Z4ZzZvSTNCUFJXNkpXSUVZUFNDVUl5bGR5Q1ZQMUFKa041Wk01RHFp?=
 =?utf-8?Q?RxN2ZNPym4s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1UvTUk5R2ZkR05Ud2dOWnczOXhlRVlUMW9VK1NaWWdZMkdtSUpCODlpQThm?=
 =?utf-8?B?VEVLVHFGZi9VSVg5QXBhOGhGVTVLOElucWRSNndkVEMyRWNHbEphUDB0eGUx?=
 =?utf-8?B?MGtDQTRHcUQvMnVpWW1ZNHE1VHJIVDRaSWtDd3VxSkhQZW5wRUFqSU5VSTdi?=
 =?utf-8?B?eGxJMW5hWHFydnV3Mng5cWhLdnloZW1saEh4SlhhekVsQm00Qlc0TFRkcVNS?=
 =?utf-8?B?aUM5WmhFZ09mbXoyVG1FSmluUlBObUxObUJDc1RrVVdhcE1lVm5KUDhDOC9I?=
 =?utf-8?B?Y1h0dUtEbHVhZnJUcWVCZHpWcHhCWHdHUUQ5Tm1GTHpYV2lTRzhuZU5sYnhQ?=
 =?utf-8?B?MjltNnIyOFZEQWpmTGdPR3Q3UkFydFE4NDlQL2RBdmtmRTNTRmdJQ3VPSHpm?=
 =?utf-8?B?aWlBSXhXODZFN0JqamRINGNDMHFQQWh6MHVpQTVXY1lJek43S3l1VTdibHJF?=
 =?utf-8?B?bjhzUHVGU3diUE02TFRUMjNTVGtOL3dLWkk1ZkovUTZJS3oyVWtVZmt1TFJx?=
 =?utf-8?B?VmV3RjZMeWdoL2MzbmxqZjFjbHh3R3hENkx2OW5PTTlNUGFvRDlLQzV3ZVRL?=
 =?utf-8?B?bVIvQ1VpdEpYKytEeVRPTzNEYzJOdjNzbXYySys1SVJodkVHRzEzUkE0WUtl?=
 =?utf-8?B?QnNXVzFheWM1VG5XN0ViMi9VN3JySEFlcVVpeS9scGtjZDBscW94ei9GZ2xR?=
 =?utf-8?B?VG5jNXRXUUloSzhwWUN6cFhpRjZWdTIxM0hQWVdBRUJBOWVPOG1qalNMdmox?=
 =?utf-8?B?RXVDSm9TcE1oNGdEVndYM2tQeVlrMWtNVkJyaVJIYVMzSzVycVhOa0dUWkRP?=
 =?utf-8?B?T1k2Q2dMeVAyRmtla3B0UXNIc2hKcmF3MFMzeU9BWmpZTHhsOTFhekY3bUV5?=
 =?utf-8?B?bDlWamdVQ2Q2K08wOU9TR0E0dW9ucTExdUNHT2plYlpBd0E1SkFyRTM5RWx1?=
 =?utf-8?B?Uk9hdTAxQWlqUTBKYmlOQ3d0dm1KK2djdzhQTitkcktHUy9kUXovNEVQRXp3?=
 =?utf-8?B?WGkzUTNqeDRmZjloNVJYUmRVbWY1MHpQUWpwZzFKZ1ZCSmg0VUFvcktmUUtD?=
 =?utf-8?B?aEZlcytaQ1lZUkYyZjVKYzg2SWxKZ3ZUYS9uOFY4cHloKzdnZmhBaXRnV3Jm?=
 =?utf-8?B?OC8xTk1tRUdRN0EzV3NuSkxDelMzNm5LZDg3eXlaYUt6OGpBanFNRm9ZZHZX?=
 =?utf-8?B?RjFaUUpJc1RSdzRKUW54WmlOWDczNWRId014TmN2TE5TWUhkdmN6MjdJM3NI?=
 =?utf-8?B?V09wdGowTHMwWkJpak1YTFZTSXZXZjBtTVhJQ2FCMDZNQUpFTlFqRmcySHF3?=
 =?utf-8?B?NWNVcnM1d25VRnZiS2xzajg0d1pEbHJuSnpVSnhYZVBESzh2MWdnNkJ3R2Fi?=
 =?utf-8?B?R2NwME9PNE1sQmcwdUF0S2dERnFzWC95cUN6Z3ZONVF5dHdpTG9PWVFSZ3B5?=
 =?utf-8?B?R1BJNEhGMnRPSTA2dWhsTlZZZlo1N0NNVHYydDVER29FVmllQU92Y05nUkVi?=
 =?utf-8?B?T1piY0RPck5CbHI2cG00cVBkRzlxRnlwZTFzU3NGVFVZeU9TOVo0NHNDS2sv?=
 =?utf-8?B?eW8xUWZ5Slh6bzZ5TmhQK1gyZHBiRTFmbEtuaGJBODYzenpIUnl5Vjd2YXdH?=
 =?utf-8?B?aUtDdStYZzdhbk1HTHNDU3FqeGd5dERUYmEyQWRUUXEvL1hwL1czSStnUWFP?=
 =?utf-8?B?RDVCdTJUZ3BDa1liK1RHZDJnYXljb1d3SXVPU0F0RUZSeUgwNHdOcG50MXJ5?=
 =?utf-8?B?WHM5cTdmQVJ6c0d5eWdGTTNvczJxdmFTbjV2REdWeVlZUnliZk82Zkc1bFlR?=
 =?utf-8?B?MVUzRWUzM1Y2Y0Nxbys5TlRmSmMrY0FJTHFvVFlqZC8zSG9DODNwREduOURT?=
 =?utf-8?B?dllpa1c1VDY4VllnTFYzM0ZpVVdrczFvOGNnU0ZEdjgwQzBBSGRadDJvK3gx?=
 =?utf-8?B?ZFNWUjZIZmFUMjk0eFQ0TW13aTNoSUp2Z0dGVjJQdk93WVYyL3ZQMytocUhY?=
 =?utf-8?B?Tk1Edm4xektyclorZU10QllDU0pGL0pIOXpNZGVoOHBaMXp6T05ZTXdSb3Ev?=
 =?utf-8?B?anlURTJ0TTZJcmo1a2FQZlhsVDh5V2Q4ZW96NjBKOE9LZklvVnRrOHRWdFpn?=
 =?utf-8?B?QTZXcUxnakhQWE9jb3BBS3RzNkQ4SmloYURUMTg1dXhaRTJ4cnlvZ2V6TklT?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yjAnQdsx/66DsCRlzaHxRaverfYSP/ACfN3tx0F3wacySr9a2WZAGbjQd9SRH7du8EAOwuhDBon084VaZjnRXe1PucA6Ka9RDzmXi+sgTgs1aq6xSOKOsyCl2VdDyAmk+r9togp3CPYbWUgc4WmyoCo1Kl+tIXNllC42f2bhxN2dltl4SFKmG/3MoGJ5RQU3zH3QgOJeTKW+ICervtYTjukI+XQm7NRksMf4KLlq3iBSJlMzbI56uMZXjktJtMUIdpmxGoN+f6eS/9dbYQWOhRFqY0LxD/mhGDtbFnbj33xSarLUiU6Uye4jR9ziNHi0Cm447xWpSSPnmBqIfxbLGiKfPurRWCO2LHnC06f4PUTRK3gP4112l2kQNEiymI+dkdO8Pk9Wx6jwetl2KaV0oNq9RYKaHXHiKpb4ZKxbJc/LiXZ7Odp4+ntBj+JCy9aCzEDSZlFm1YdXazpB2/6mboZGwFRYGN7IRfykEUH7dt0/jpd7txtSpXMxZukwXI8V1m1+VlodPz/tbk41ncBKqeYPmEjUuhrqo8/+3GcD7aE6UmtbR48lcOJvdOlctxEDEVYuzMYUkmqV6YKSE2tuahViEYVYkydhGdR236UZ46g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 334e1ec6-cca9-43af-6b07-08dddca02da6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 08:37:47.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cVEymWa8gxfb89bg6vrbpqS23o1AaGWXbvpQxjBUO6tUh5fpiOaOlhFtkC9U0nDEvsdEaxQzpviA7npYGRMj0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5693
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508160086
X-Proofpoint-ORIG-GUID: f_OfupBKouUWzKJnoAOzkCtURggFWrQL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDA4NiBTYWx0ZWRfXxN/rLG+NTjjB
 PExFJczDapTTGS69fEL0k+TT5v5zZ9cUZs7vTNDLfZesN07XG8AK4M6nT8FTUN1x3ttzUNY7Yzu
 66uGxCGUgLHqrRkJnoynKxbGbq0g0b5OTZunWMw6p5yJ7ziU7oQuzdso079w4usio4yuuz77WRz
 ZxgOpsXDhnLCYORZkZjVJem9+EKflGK01+Cd2ym1froonx3T7cXU4uxkXOzJJjFm+rZLClOWn1x
 I1Qhxc2yzjAu/0brYPV45Bii/9hv4NrKE5jQtCxmEirAM0GRYNybYGkAIzRxdDbwNtceF2IjFQF
 yUTyCBCgapB+xiuOtbGwm8UCKYHJhFRyZ0hb+cyuOdPbB1UdVpvYux+nHV0JwgQ7n0cqmjCyPyx
 PkomhCBSjqKXR6l66wxQJJ/hcVUvjrVKyfWPjAN5N3FmEx65u2X+qnvGooxxYwZMvQX9cDlZ
X-Proofpoint-GUID: f_OfupBKouUWzKJnoAOzkCtURggFWrQL
X-Authority-Analysis: v=2.4 cv=OK4n3TaB c=1 sm=1 tr=0 ts=68a0435f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8
 a=ksjgfOTb0J5xIM_L-bMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069

On 15/08/2025 18:30, Bart Van Assche wrote:
> On 8/15/25 12:50 AM, John Garry wrote:
>> Maybe so. But it is still less than ideal how the TMF tags are managed 
>> in the UFS driver, specifically having a stub in ufshcd_tmf_ops. Have 
>> you considered modelling on how the NVMe driver manages the admin queue?
> 
> The PCIe NVMe driver has different tag sets for the admin queue and I/O
> queues. Additionally, it allocates separate request queues for admin
> commands and for I/O commands, just like the UFS driver. Can you be more
> specific about why you are referring to the NVMe driver?
> 
> Regarding the stub in ufshcd_tmf_ops: moving the code for queueing a TMF
> into ufshcd_queue_tmf() and switching to blk_execute_rq() for submitting
> TMFs shouldn't be that hard. However, I consider that change as
> out-of-scope for this patch series.

That is really the change which I am hinting at here.

> 
>>>> - I like that you are using blk_execute_rq(), but why do we need the
>>>> pseudo sdev (and not the ufs sdev)? The idea of the psuedo sdev was 
>>>> originally for sending reserved commands for the host.
>>>
>>> In the UFS driver several reserved commands are sent before
>>> ufshcd_scsi_add_wlus() and scsi_scan_host() are called. 
>>
>> If you must send "host" reserved commands (which are not for a 
>> specific SCSI target), then it would be ok.
>>
>> But do you need to send any "reserved" commands to a specific SCSI 
>> target (which are not TMFs)?
> 
> In this patch series, reserved commands are used for communicating with
> the UFS device. It doesn't matter which struct scsi_device instance is
> used for sending reserved commands since UFS host controllers only
> support a single UFS device.

For more general scsi reserved commands support, we have to consider 
possibility of more than one target sdev in future.

> 
>>>> - IIRC, I was advised to have a check in the scsi core dispatch 
>>>> command patch to check for a reserved command, and have a separate 
>>>> handler for that, i.e. don't use sht->queuecommand for reserved 
>>>> commands. I can try to find the exact discussion if you like.
>>>
>>> It would be appreciated if a link to that conversation could be shared.
>>
>> I looked, but I could not find it. It may have been a private 
>> conversation while at my old employer (so now lost).
>>
>> Anyway, here is a reference implementation:
>> https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email- 
>> john.garry@huawei.com/
> 
> The description of that patch says what the patch does but not why the
> .reserved_queuecommand() function pointer is introduced.

Motivation:

Any driver which supports reserved commands will need to have a check 
for reserved command in the .queuecommand callback (for special 
handling). In addition, some more general reserved command handling will 
prob need to be added to scsi_dispatch_cmd().

As such, having common handling for reserved commands in 
scsi_dispatch_cmd() makes sense (so that each LLD does not have to 
duplicate handling).

> Integrating
> that patch into this UFS kernel driver series wouldn't simplify any code
> but would lead to some code duplication. Hence, I will leave it to
> someone else to integrate that patch in the upstream kernel.
> 
Thanks,
John
