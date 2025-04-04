Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA81101EE
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 10:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743763225; cv=fail; b=L/tQqlOahidDvSieJ7D1x1Jf89LzXu/cYKo7/rOGN0Hu/OkH4QFjOjH3gNZQ7tDIpr6tRGiAaE50fDtfbcsUjHiHhSlw77mp24i+Whe8uzukyeXClI+DXn3txtnXK+Jk0I0E4ljTvFb8uOpxAOsqVHXhgj1HsyiBaMxIKsAK+24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743763225; c=relaxed/simple;
	bh=bpMZHWk/wHopAwPZK76XuYMv8OsCUuTtD/2irfXmJ5I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nizAB7sAQY2ISO/o+K8cQW1P352vsFokqe6BIAkADVNgi02FWD4RMdmJqb4eaqryOVV61/6D5btx6ARkJ5i1HTF0u4GIF15meuAyuXftsxoAqZ1c00P6MVIQ4giZcPE/SMlbVZ5ril8ui+EoVb/1Lg5PiXc5NwXvoQDH1TFWQJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KwIjA8Fs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kUCU8P6w; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KwIjA8Fs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kUCU8P6w"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5348N6G7014751;
	Fri, 4 Apr 2025 10:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RhmdbPxBM6LtSi8Nl1nG54lkmpYnBa71131RADFbwco=; b=
	KwIjA8FsnnJjRBRNsXczjiaNMIsn9pcuPxdk3li4EMMtwz9sSDZ+vb2DUMY9m51l
	oCPcm5xaGcc6tZP8bR0M/sHmsxUWYDbK8pg/jFnEtZlfl7XUTXZH/JPU/pRNV4/a
	TTz0hV7Lvc5kRN9xtffYwrtno70zXpPjuXM69h2x7+gLrqh+3BaLvvcg4NmIoHPt
	qiiDGTuEYDu6UwiyJqcH1jwOmAYgixiPqvjEmwqsi0/5Q78Ijkkouef2bpRaOC1n
	MKexC7XdnMPtThCkkYKn/m8ia2fOh2KTpPSPJKRoml6cZ5WKrY9U9CD+HdBV5ntN
	S81zw/BMfxbRFe0tPaNPcg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79cex7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 10:40:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53489rpQ036468;
	Fri, 4 Apr 2025 10:40:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45t2ntvr3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 10:40:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDZDxSzhNJKCrFsIfA+njpdbIm4aUPYvrWzlG+07/DB3paXLXSMncCqmuPb9rv3TfYFCmYdOh4apCoIEWPpLogv0M6r6/dMxrWt5WrnBeOKA3fL2MFm6IECy7MH8Eeh+bJhRouxqat7Bsb8FgoNYkCHZCcvzvnKhiT6/Ad60i2wDxPtdb87kEhQJScVEIf5T7z2R2xjzjIrVOH3tENfr0/jW2BO+T8I/SlABq3V6kfMCQh2TBQu7AtCbax+S8Y46cVvDzXbUYzQNghbEEiPkA1BuSVhPdM14ixABSGalXFZudhvKl/eakG1nLTQB7vaYHNZZ1sxMPcr1BsOyCLZKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhmdbPxBM6LtSi8Nl1nG54lkmpYnBa71131RADFbwco=;
 b=tjueXcJBqiaKLB+hT6/PlPZENMClcpRVDBGsLzq96/lWQeDS+zbkq5w+GRjF8rQQsEQ54kBybVbBhi1lGnIfXJhjruAz5IpbXMGRfs9ngbReShvmDmxP+glqNl5nhBS/j7q/ybN+mwibwnrlVWr7UJpY9+BGdk0HGGqxErSPwFABDY/CmFBbbfORoqevoAcY9N8HDd7oGsKVtvIUW7rQ4+Z2nM94eB+RJrEa/5ZLDt0KBt4QgplfGRuLmFFOQHFxO4xPeSVYcBHRAKqQNe1m+ky0GlEnpHageUIotl6W5jmECWXE30lsXwH8oAQ0bEb4/6mqsJNWE25qtitb7Z8NnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhmdbPxBM6LtSi8Nl1nG54lkmpYnBa71131RADFbwco=;
 b=kUCU8P6wWr2Bup3bpwKAFabZexnhmlo0GFobzkh7dHtTdtl1QZB/Q0g5raD/yl8P6oKuIJjiQNvYpUsVgwQJ7zw7EQc7VlOztBzJc5n0NPHEHAEO28nXy+QHM4DfnVAyd7VzpHU6DcwkRzPtBmcYb1VBts0PCHDGIiTNIbbU1aU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4847.namprd10.prod.outlook.com (2603:10b6:5:3aa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.42; Fri, 4 Apr
 2025 10:40:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8583.038; Fri, 4 Apr 2025
 10:40:00 +0000
Message-ID: <bc9d94bf-a1e4-42f2-94f8-1e3ab93d7e05@oracle.com>
Date: Fri, 4 Apr 2025 11:39:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-2-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250403211937.2225615-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0277.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4847:EE_
X-MS-Office365-Filtering-Correlation-Id: c1feb7e6-0fe1-4a93-33f7-08dd73650d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjZzVWorZWQvdkwyKzlsZGE1Tzl2NmRDMngyS1R2cU4vQWNqVXMveTFDa24x?=
 =?utf-8?B?VnplNXc2cGdmbWxjd1ZyK3RLVllIV3NMdTBVdXJPWGgySXhGOU8rVjhZanIy?=
 =?utf-8?B?UytTeXZCOWJVeGZLNlBWamF2SVo0QXlLdlAwUDlWbStsb2pLaWhjVzcrWEZZ?=
 =?utf-8?B?WkJ0WnF6eGtnNEN0d3QvNzBBNU83S1RGQ0J2bTdGTWo5UUZ3ZHZwTEZuY1ZT?=
 =?utf-8?B?R3ZCSjMxa1MwV0VoM1JGMkxyTkNWZVgyZkV2ZW1UUVRIc2hKMnpNdEJOc3Bw?=
 =?utf-8?B?bVZTc1pnV2hDQXpVamNNNU84cUpTQVJrZFVCUVRqTkt2dGY5dkp5WkFVcjlS?=
 =?utf-8?B?K1ZWeHg5VVR4V05lc05wcGNaMks5cTJOcmtoYWdzKzFOQVJjK2hUcjdOWlBF?=
 =?utf-8?B?Z2dzMUx3NGRieTdsc0VBcU9sZSszU0tON1ZPVmhtSjd4QzlHb25Mc3dHenJD?=
 =?utf-8?B?Q2QwaVBXaTZhaXdKVjJNREpBWG5EV0E3bGxMN3RHSGVidDVaRWtyV3B1eHZ1?=
 =?utf-8?B?SE5hR1ppM0lSOWZ6K05INzlIWTc0VHZheFhYN0tTMC85SVBKSm5XMGw3K2JV?=
 =?utf-8?B?SjdZczBGMFc5N2I0Q1BTRFM2bVRLdVR3YlJkRWR4K2s2ZzcrdU9lRkhsRXRn?=
 =?utf-8?B?N0l2WlRvdlFEUEVBQUxMWlFWWURXd0JxT29Qdmc2UVFXNjZ2N2JUaFBBaUUy?=
 =?utf-8?B?U3FuYWdoSk9iL21ycEM3Q0U3ajBacjdWb0E1dS9hTXhOYnBqb25xdW45Q1R6?=
 =?utf-8?B?bWVsZnloelhKc24rRjk0RSs1eERJK3N5UXVJcHErTXNLSFd0M09GRlYrWVF6?=
 =?utf-8?B?WmZaejg0S2s1V0JIUGExQzhNaC9XUmdMSjJvUm9OejAwYnFJRXYzUWNSZC9a?=
 =?utf-8?B?QnVrUWJ3SFlVQ3RaQWhBOUlTeDR0bEdqZjZUdkErL29vTFFyaXlHaklrbkJW?=
 =?utf-8?B?NkxubnNnbW42Q2ZJOStMT0FtaHNMNVBHWjJNSWRaN2RNcTlwQ2gwaEdZTnY1?=
 =?utf-8?B?YjZQdnNDMVp3c0c5ZEdOUlhNbFlUbGtVeG1GRG1kaG9WN3pXNEdWTVczSWtH?=
 =?utf-8?B?KzJSUDFoVkVkVUpiMnliQ25LT0xjMnhMNnhBWnhIZzlxa2pQTUNXWmlSaTgx?=
 =?utf-8?B?M1VoWnRJY3BkTmhIWUFUNXVoaCtGQkxLUUNkRWlEaTV0QVd1QlgvL2tkU2Ro?=
 =?utf-8?B?T05Ldm4rZmdONzF2cTVxWkZzZk5PMUJJSE1GREEvK0RKaGVoNGhwM0FJQ00r?=
 =?utf-8?B?RWpUY0xzWk0zNW16eEt4RmRLc3lpZXUyaEZGa21adlBzY0ZOOVpiOW40WkZh?=
 =?utf-8?B?a1ZmTjNhcEFQdk56d0M0bDdOVHNaaHdGb3p4YlF1ejN1SnZ0VkN5VlJiNmla?=
 =?utf-8?B?cE9xcTdkbkg1elFWZ3hGV0lyMC85VjNVd2wzWncxWWhoSmRVZlBnWVdPeVRW?=
 =?utf-8?B?d3M3Vm1XVk9mU1hmQ0wyVUV1M0dLRXZ1eVNMRy95SDJDbUJBVHhWZDB6ZURs?=
 =?utf-8?B?Rkw2V2ZIaHNQWXFSNnBHSGFiUnc1VTI3eXBYbGJOMUkzaER5aGY1ZmxXNkVX?=
 =?utf-8?B?c0FIYzkrNjNsV3QzajFjTmlXcVdacnF3ak5kTXhGOUY4N3U0WU4wMDduWXU4?=
 =?utf-8?B?TmZPNlhDdUFZenJ3dnIzOVE5MU44Q29GbWsweVNXdlBrNVpjSXMrbjdKMENy?=
 =?utf-8?B?V3NrS1dtN0diODJNUzVvK1ZncUZIM3QrS1dKeVo2UWc0eUpkT0ZaaWJoUGNr?=
 =?utf-8?B?Q01EczFZWjg4SW5SUG9QOCtoblAwNjZSYk43YnUxZWNaZDRsMWY2bmpKWk9t?=
 =?utf-8?B?ZVdxQ2V0bkk4cU1sU2RaWVczb0EvZmJJaENDb21ObGJoOXZtSUhpbTljV1hl?=
 =?utf-8?Q?jJjgVc9WLtYOQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWc1WGR3Ynh2WHRFMlRnV3UyVCtrSjYrS1RCcVZVSjlQOEFtbllDS2kzZzk2?=
 =?utf-8?B?RVFNM3hYVmJRQVg2N2JBaTF6RWxNa0ZodlhlM3pnSURPNWFwWmpacUZ2R1BU?=
 =?utf-8?B?RVBPZHlsUjdGY0VyY2o1TVVYQzFIZDdHZVRxeEE2RGxwamY1cHg1Zm1RMi9I?=
 =?utf-8?B?SlFqTFBOTG05ekgxa3ZXSEVHbThWOHIyTUVVYS9DQnBCT29YZStjSDkzM3pl?=
 =?utf-8?B?SmtoVFYyaE93NlA1eTB5TlBVZGZEK0ZDL0x4OXRQR1hHMkFBZUVITS8xNkFM?=
 =?utf-8?B?VWNGYzI3M3hJTDFUNmIwcER0VXZpNS9WZy96V0l4YlRvZE1PVm9jNDZxeHB3?=
 =?utf-8?B?UVZMLzdCTGhya1J4SEd4UDRGMVo2QnJqcGNTa3dDaXhFTXd4Z0JpbzVVbGJy?=
 =?utf-8?B?ZWR0dEs4RldLeGlleVNSNUtwL0twV1A2YUE5THc1ZXpMTjFaeFBjYzlOV1Fy?=
 =?utf-8?B?M3V3TW1RQVRPblNJVkJyREpNWWZtM2lSK1ArSk1tWHQrUFo4LzZzWkwzbEpV?=
 =?utf-8?B?THZQbFZxNC9IWWtRcUJBOEl5Yko2T010VXhISjRUZmtkL0NFcnFZZEtYVitN?=
 =?utf-8?B?Wjlzd0kzNlBQMjRjMTFXTTVLVFd2VHozUUVoZG9xaE5zTXltU3BRenJ6cjhi?=
 =?utf-8?B?QnVkV3Ivb3RnNWlVc3hiNVJORWs2UzNPNlNpUTNwOFc3d1l5TXRYSjhiZHNu?=
 =?utf-8?B?ZjhHcDMxTVNNVURtZkhBNkVoMmJaL3F1Yi85RkYwVDQ5OUlwWnBuQmRUWlNZ?=
 =?utf-8?B?dnpHSGxwZWVFYWFBLzFYYVVEK1duUHNHV2xuN3FOM1NydDg4WG5nVjk5U2lJ?=
 =?utf-8?B?d0VKTDlLSGhGRzgwR2NMaFl1TmN2MEJMM0hFODFSUWRCT3BLNHRlSG9mZVJK?=
 =?utf-8?B?MFhKV3h6b2kwK0w1Si9PMzNrNlZ4WXRCWUJzRUp5YVNUZkkwM1hweEpHaE9V?=
 =?utf-8?B?MXJna2xkWlp5d3NmWlU3WU5RcCs0b3lLN0ErZ0JGSzFobG1WYitDWWMvM2Jj?=
 =?utf-8?B?NGZvb3JRMWdRdjVwa1FKRERlM2g4cVVnRmZxazlvSXJQSW0vb0pZRzczRzho?=
 =?utf-8?B?cVNvaUVlU1laVUt1UkdYT0xpVVlKL2Q2WVpDb0tYT3lldXp0M0g3ZGsrclVJ?=
 =?utf-8?B?eHErMXRwdEhjNEpjM2loRzRXbUdtSUFhQStsVWhXeFBYQTNhMVNhaEZMNFRz?=
 =?utf-8?B?TzBXbm4xUm5HbnVRMGM2N3UyYzlBYkhNZ1NpWXVuWWV6UFJmTWFQUnJVQVI2?=
 =?utf-8?B?WEcyeVJIVkN6WGZOcGtCUkwzTksvZ1c4MjE4aDlPUUFpMU9qbk40OFZndFVo?=
 =?utf-8?B?NEdMZzZzTlUvQVd1VTZBenQ2NS9LTjBiY0F4aEF0WTJERlJDOEVTLytuTnpz?=
 =?utf-8?B?TzZFMXpzQ1J0S1gxY1V1RnBLMFR4MXNrRW53S1BoUFYyZDdjVDVTYnJ6aW1w?=
 =?utf-8?B?NHFMcnp0RlBxZEMrRmRoZldoQ3JTbCszM2JZMmZ5UUpJTEV6VVRaam1Tb1Ba?=
 =?utf-8?B?SThhZ3FrODFsaDJtd1VzVmE4TmRKWjc5ZW1YRHZBRjNYdmY3bVFMMER3eEhH?=
 =?utf-8?B?OWptZ3BtNE1qTWFwaDgxY2NSYnlieUpQSVNEQW56bGZXWU9XTmE1dkMyYlA1?=
 =?utf-8?B?cll0eUsvalhxZVdEVFVvMkNibUxsYytUeWMzdUhIaDhIbHdoSlhJZzhQS2x6?=
 =?utf-8?B?U21tN1JjU2Vzc2FYQjVWb2ZjU0k4MklzbHpYKzJQczVsYTQxSDllV3JPeDV1?=
 =?utf-8?B?TE5LSWxDOFp0eWNlVFJyQ0NZT0h4ZlpVRFFLQzhxcUhjajZUSlZyUmNGWHRy?=
 =?utf-8?B?S1RWdC9EbTZ5Vnk5N2FjY3JnNktiK2ZKdVNWSzg0WjBGcWJjVWZlbFoxSmpv?=
 =?utf-8?B?S092RnhNcXhLbmlSalh4dzJNRlhHalRXUVhzQll5cFRmMXlLUStkeFl6Undx?=
 =?utf-8?B?L3VYenBVOU1rcUZYb1YzRkt4VWluS1prQ25UbTBub3JkWFFMNkxUVzdFL0Ex?=
 =?utf-8?B?aHgvcHd1Q1ptVkNDNUx3cUtsazcrZjRaZHlxcnduSEFZVlBZczVNWHM2UE9L?=
 =?utf-8?B?TStaK1ptRkE1TllMaysxbThxQUxGWDc4NTVMLzlLQ3RZRXV4elZaR3dZL3BN?=
 =?utf-8?B?THBpU3R2b3A0ZTJ5NnFyVEE5OFFDZG5PZkVUdWtaOG5US2JqTXBIU2FlS2VY?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OM1OkVPD3ROgkrTV5Ef6/SJEXIw6RDJUiHgHo4VSvGrGhiR43HDEqMiQxlL7StrWoUz/Budh4CvYnDMEijqJ7sajbTDgiD5W0gviUalJxpa0arhZwS5lYtRh/ern4Jur8RX991PtQ9Cxr+1aZBR0nm1Fwtds2okftuAoyanBHJo2dny4pRSXeUo0c6ZqtD9na0OKdW4Ys/No7RxQ+HqreEbiISNpLQWDSu1suFfD+TEhRarPr7uJ0IBc+z/Zx2fMA0pcNLf+6zSx/CRGkU4GyrhW32SeCLgzKxgbiUrhZp3vubvz8ezkPvKAy1Gp2wz5bsqNSeJbOzCEcl2/mCkMEX7mX9JVr7353T5xYfoj31b9VZ1m9F8wQzDzsfReznEIqJsAGnx2Vim/vpzmz/VZKoBlp8l26oS0FiMFd3ByKy8/Zzb0CNJ3yzwAz7DYtd2UhqKhQw6GCoKAFOcGqBRit2k/4iD4wmcIXeP2Ju2JkqwCnz+oh7Psp+FR9paKogHwuTidxZ+j1txnJzqhqzxIj2vPOAXMSi5+LPew6LeMQGHNn2t0ren0lRQZ4cHURSH8KhJ0TIFDDBPqUM2jsMLLDuZ6hNrfKnNnFT/SvFteYxg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1feb7e6-0fe1-4a93-33f7-08dd73650d26
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 10:40:00.8865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXX8BKxNTikQEahh5PacPyRYp/GSNDli/YpXSL1l8xH+hPS1zxYeaNk9ScUUJatXU+6XmKQ6Ddl7MFpEnaXTkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4847
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_04,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040072
X-Proofpoint-GUID: jacVU2pfzelcitfJU5HV_EstWbsG5Cxu
X-Proofpoint-ORIG-GUID: jacVU2pfzelcitfJU5HV_EstWbsG5Cxu

On 03/04/2025 22:17, Bart Van Assche wrote:
>   /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
> -static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
> -{
> -	return blk_mq_rq_from_pdu(scmd);
> -}
> +#define scsi_cmd_to_rq(scmd)                                       \
> +	_Generic(scmd,                                             \
> +		const struct scsi_cmnd *: (const struct request *) \
> +			blk_mq_rq_from_pdu((void *)scmd),          \
> +		struct scsi_cmnd *: blk_mq_rq_from_pdu((void *)scmd))
>   
>   /*

Out of curiosity, how this that better than this:

static inline struct request *scsi_cmd_to_rq(const struct scsi_cmnd *scmd)
{
	return blk_mq_rq_from_pdu((void *)scmd);
}

