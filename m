Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3C73019C4
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 10:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761213791; cv=fail; b=VaeXoqmSiLD/jgrrtSRR0Yul6EC1FuCefdRvHu0rhjG0C3EBf/uPDPos1OwytRSOVQVe5Nt2nKhOoosogWgjEBhALO/hdKi3qhrU67D0mBg78Ie9AKzzy6MvPmW/3gge7seu4Nn1wGN+v3mJwEb+Gs3BK60+mprhcMUvY9yT1/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761213791; c=relaxed/simple;
	bh=9ZBzP2UkiDfmqEUqzVbE1MTcNG3kj/jaT7ignNu5IUM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uib8HZe7218TRDRVma4m8jgbpJWG71/WnZP5swAM6U7OgawMElsGoxJ6gGN3MqqyUjh6hh1kk0viBGuxzmEFz446zX9QfIDFg7gyCP9lm0VEiiLPh6rV9WaQT0gDysOEDq2OjyL/Mh5364IyZ1oPIvf6C6FOPyZCoiv9XFvZ2no=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TGRsQPu/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EN2kxYe1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TGRsQPu/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EN2kxYe1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N9kjjA011712;
	Thu, 23 Oct 2025 10:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kgtg7QxcCUCejaA1glTWsYRLRgUlBSl+Kh+UFD1/3vU=; b=
	TGRsQPu/Twsw+QWOmhmzpTmqtFQr5HL0kO9O2up5gHnubC5n5cWB694D3tYPxJ7o
	BuZZdLnguBBfc/jpJOlHDmp0bJxhaJyQaDspGUFZPoHERnbhUQBgyEALP9yEdt+k
	B+EC/lge+dx8FrxsgZhM7OL/EAN2XM8jKbTBeueWfhVtk7wL7WREe6qwVhrD9Eqb
	NdM60AVIAzjX9T96K8xhqlJ8wzD9m2NI4D3UINt7sTyL1SvNCT6OmS1sO0vxU4i4
	pgNFmd+f/9U1rdGCtRwFu6S3C859xKfNnQtM/YyTqgMhMaUBsQFLF6PMvw5r6KdN
	h3qbCcaPGZYMi7IzT5ScWA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcya69f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 10:02:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59N9Gnju025256;
	Thu, 23 Oct 2025 10:02:49 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011059.outbound.protection.outlook.com [40.93.194.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49xwk8v5bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 10:02:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDCc0i9RYNBlxE0IFX+Od4ZX6qRGR3IHG+7BL9IPhnFxOFTZXedFVX301NW4xnLCiDnNsWJUZv7v88zJ+vWWTBcFuzuqMlh3gFYxOewhSJqmpOi1/UnrmRA7gK7TL9jmcKixn2JKucL6R6ks7YbKyZw6zFoTOa6U+T6zzs2+ro1IZ35FSZ5SYXaCAxxZEYp+BUG5JMeawYVHgi/CoCpHws/RspnFTay4ZKYkTQ8W9jAtv0o3A5YvF4srHTjYdf9zKBEUdLYDv4M+kYa49xZ601pl6sBrOE50teImxtouZVDc4l4BMeJoosZ+d9aWHlqz/mnnYPUHnqkNKCSIO5dXdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kgtg7QxcCUCejaA1glTWsYRLRgUlBSl+Kh+UFD1/3vU=;
 b=WkC9G3dkTpFhetwjSiqBXPow5XgecBBkNH+VkOq8WfIVF59MX5PswWX6Zmpr/r7rMXt42vCAUFyOSHwaCJe1FoCvEUVm32pAw4/WwmEHWujdNysJra0WT3fch0RMWiloEsuN7atQIlVZR4xZmqjXWmgsaNLXZYglCH2p03RmytzqVQ+oRaoy87XNumOIw2MDEcpksuo72ZS0qxX15ALgWXl7WHYWYAA2r7mMmcgcSCxwEg4c+4KAWjG1smQJj0Ec596ZeH78y271yo1ml0m0uYZeZ1S791KpvyqjXp+r07sNvzIl0C2Dxq6HDTZMLo4lZ1wtZdpqzI+Lw7uxBKhb5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kgtg7QxcCUCejaA1glTWsYRLRgUlBSl+Kh+UFD1/3vU=;
 b=EN2kxYe1a/KTuj5T/7hE3a3TfdoP3aqrmBLATcmT09SFPgrLixsKU1MD+Mb3Wh8hhjRymFyDmvgXyCrJW1nz4sN+9urKamYjzQmMS+iet8WHmEpS4uDm42grGvE0iNCNJV6fN781cZvvvaLslIGex2xqW68QgmqULBr1Kdq16Lg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH0PR10MB7440.namprd10.prod.outlook.com (2603:10b6:610:18c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 10:02:45 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 10:02:44 +0000
Message-ID: <c98aa96a-5c71-4de2-b9c6-61f545841fec@oracle.com>
Date: Thu, 23 Oct 2025 11:02:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/28] scsi: core: Make the budget map optional
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-4-bvanassche@acm.org>
 <60f9a312-455a-4714-81fc-abbcf86715f5@oracle.com>
 <e241e5c1-a908-4d2f-8f66-82ac3fec937e@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e241e5c1-a908-4d2f-8f66-82ac3fec937e@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P265CA0032.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH0PR10MB7440:EE_
X-MS-Office365-Filtering-Correlation-Id: d4939581-e026-4630-9911-08de121b4fe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFB3QVdRbE42YTRDOEhCeDNFZGxQOHRTa0xOTDExU0Z2M1lsSENoTzQ3dERz?=
 =?utf-8?B?Qk1RMWJEQmdXL0tlRXlrT0NLajlXTzdqYjB2MGdFN1QxS1hRN3c4Rm5wYU1w?=
 =?utf-8?B?cU5VNnpRUjROdnJDUDdhOHZnR2VnSncySlgxbjJmM1NBWWNVQmVmRmNOQ1NZ?=
 =?utf-8?B?TjVwam5Wa2xGc3UzTmVDQWphOGhWWFlhdnhjQVdEM3BZUnJKQUpGeG51bk5k?=
 =?utf-8?B?Y0dYbU5ONGlicnBkNFFuNXhwaWtkL2xCSWV2QWRJSE9wUHhxbnk0ZmZZR3ZB?=
 =?utf-8?B?djZLUysyQ0thb0V6K0dLUk9zcjVsdXN2UkVUN2xZZWlDYXpqQlNXcGxDV2lS?=
 =?utf-8?B?ZE9RdlRtSHFnd2ovR0czL24wTHBuUGlEbU9tYVo1MHNRMmJMN3BFMEx1Z0VW?=
 =?utf-8?B?dVlzWUFmZzduMzUybzV3RmRXTE1TQlNKOXZBVVZNa0FrL2RuT0RldFFOWW4x?=
 =?utf-8?B?ZFNvbkI0SzJBUWkzNWJZYUMzcExjNWlOZ3VaYzBCb1Y4dFd1bWRic1pJRk90?=
 =?utf-8?B?a1dZdjBVSGFRcTVjT3FiWEQvN212ZTE3bU5jM2M4UlpUaUhNN2ROd1BTeXFK?=
 =?utf-8?B?SGFObWdpOVc1TVh1Y3h1Tzgwd3RCcEg2anU4eHd2WXAyRGJkL0ZmNUhyYTd3?=
 =?utf-8?B?dW1zbURtSWwzbElUd2c0SDA4VXErcWNITHQ3OXhJWVd3bE9udFRHOFJmdmNG?=
 =?utf-8?B?clgzL29vd0tIL2Y4NjZOdWpra2N1QTlpZGdUcVd6SGtBdnVFTzlvT0JzWjFv?=
 =?utf-8?B?c243aEJSazlZWlF1WHZ1OWZidldpb0FGRnJ6cXVMK0hNaFZNOVNTOFlTSkNT?=
 =?utf-8?B?a0lNSnJGaWhEOS93akQrc1VOdWdHQlZMd3M4UTVDU0VDKzhGTzhoRWorSDZr?=
 =?utf-8?B?ZWU3a09NdTQwKzROMDJOSE9iVGo0MkdhQjBFaEpGSnZ2WFlGc251MG0xSktI?=
 =?utf-8?B?M1dSblVJaUE2RWk4K3Zid1V3dnNFaklPemNKUEJzTUx4Qm9MczF5QWl1RGVr?=
 =?utf-8?B?YVRiTG9LREU3aVdwbzFPTy9VbXpFRkNZOU5ZbXZiTmE4YS9tbElja0x4cGJG?=
 =?utf-8?B?WWdGckJKd3B1N09HZnRUaEs3S2U3eWw1RFI1QUx6WXVsUlIwdVFuaGxMUURn?=
 =?utf-8?B?ZlIvSEh6dTlPUGxJTTNHVFkyRWdrbGZEeVpackxqVkNoZG9YZ3BPWFRmTGF5?=
 =?utf-8?B?VjJYNFhraVhDWFZQdnIrdm1vSzRNZVRrME9IcjZCM0VoVjR0Z3BWbkF1NkM0?=
 =?utf-8?B?RU5RblZLSTFQVTQwUTRaZTY3TnIxNWEwa0pzem1jUmJPR3VKSnNOdmJpK3ZV?=
 =?utf-8?B?M0xDMFJaQVFHT1NrdzVlT0pPTEdKMjlLQUZ6MTJmWkI1YXlTa0gwdDNZNDJ6?=
 =?utf-8?B?blhkUklYTkpMRWRZeDd2TjlQQVZucXgxTEZsTmJWUmM3Um5zRCtHeHVPcllD?=
 =?utf-8?B?OThGVEZMZC9rNnJodXBRandWL0J2N0tkajBMOURuaW9Kc25SRDVOU0tNd0U1?=
 =?utf-8?B?YkFtNnFLaGdocHpSSUMvMnk5b1lHTEhGc0lrcWRPcWduZXBuWjAyNWQ0OHVP?=
 =?utf-8?B?c2xCcmNDQmxOOEhxR3dqTnVPUjhqNmJNVDJ0QWg2OHFoWEpiNk1uaHZlMklL?=
 =?utf-8?B?WnFnaGVreG9kMzZKc09qN0twZkRsUWhHcTkvVDlaZy9weG1ib0Y2MXE4VHZa?=
 =?utf-8?B?bXJBU2I5MGZXczdqMkFwS1FmRkpXNHRteTRtb0JLQXVCaElrWGJuQlhnWGQ3?=
 =?utf-8?B?UnJVMDArK0ZkUysrMXlTTVFDZkU0ZlEzNXJDR1E0bTgyT1l6NWJXUVFUUHNi?=
 =?utf-8?B?Zmxnd2c0U3JUOEx2cFg3R0hLdTZjYWxsUmUzM0RjSG9Fb3lRL2hSUERZQmZz?=
 =?utf-8?B?dGNHOUtkNVdsYWRFVVJBSXM3VWs1Nlh6UHE3QUlMazVmNU9LeTVsa0dibEtL?=
 =?utf-8?B?WkxqVjlla3IwbTYvQ3RqTWkxUCtLUzRTZi9jVE5iV3htaCt2QmhhY0ZNQmRK?=
 =?utf-8?B?ekZFQThUT0pnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHRCZVhHUytoUkx4Ly9JVjhQRGZ0VTM0NmZaUG4rNVVZOEFVRndRWEd5Zy9a?=
 =?utf-8?B?M0pVN0FZcHlnT0EvWGxiOGFWQmwzVXE4cytxKzhEcUhrOE9ZL3ZQdENSeFdP?=
 =?utf-8?B?eml2cjM2Y3ZpR2Fac2YxLy94NElpMUVQYm1PYjRsYjFXdGtNdnN4NkFCS0tk?=
 =?utf-8?B?T09penMwV05OYSt6N3NvcytXVHlrSjhRa3pvR2lHOVFQc3NxeUgxTkNGcy9r?=
 =?utf-8?B?Zk8wdVlUakZhM0x4NDVTRW9Wc2VqWTFPOVE4aUZIazZDV2JMOG5lN1JTTC8x?=
 =?utf-8?B?N3FmWVJUWkdZMTVmSUlrMzkwNm4rWFV0Znc4NExrRmlNUmU1RkZNQ0xjUXZD?=
 =?utf-8?B?UTB6dG9teFVSZk1iVk9MMU1xNTd1S3V5WWwrTDJRbUc0d2VJKzh3djJEVW9C?=
 =?utf-8?B?K2lnUC8wRnY0c3puYnRmRjJFRzEwdGFFTmRMTmh5ZmhGR05NazBhQ2FQa3g0?=
 =?utf-8?B?MlUzakpNMTFvdzFWc3dlQkRzSnozeEh4RjRkOGwweU1hSVI1Z3FXWTk0Q0Fp?=
 =?utf-8?B?U3hqbzdQMmNvdHNMOEU2RHdEL2tOdVhNZ1ozR2ZrOTAyWDRucTRiNzF0ZitH?=
 =?utf-8?B?b2g2Z29UOHI3UysyV0J1MWwydUEwZ2xZTEVTblpnY0VFa0dLZTkyT0tRS3Fm?=
 =?utf-8?B?OWh1eGEwUzAwY2YyNEI3cFlkNktJTExFcCtReWhMVG1lN2FKdXpXbk5qRnRH?=
 =?utf-8?B?dnhONk0xMG10RlNxcmIwRUFrckFQb0ozNW93citVYTJqZ1J2aXBxSGNqb0JR?=
 =?utf-8?B?cTM5Z0VObDU4aWM2UEJVRHB2aG5RMWNVVHU5WVkzUGg1UjRPT3dwRXdqZTlN?=
 =?utf-8?B?alRQYzBwZC9XOEZxbjFKcG5iMmJPTkUzNkxDTC9BcWsyZ1dZRVUyRVRzaFl1?=
 =?utf-8?B?b1hZNXVxRVBiQTBSVWxUVXVKdHI5Tzlxc3NoZzlWNnNnTkdXMm5kZEo2UkVF?=
 =?utf-8?B?M0NmSW1jU3RHM2NEaTBKa0ZHcFNWZjVOQTNscnNNbjZFa2hHTFVvWk41ZTIv?=
 =?utf-8?B?dzFCUG1ldXJrTmREWjFEZDRjUW5LVzloeVlUT0NrOS9TTFpzaUE2SDJoNGRv?=
 =?utf-8?B?clhqUnpLYktyNkRrM2tzY05BRkdEbGliZVB3VGhnNS9WMklUaUx3Ynplc2xR?=
 =?utf-8?B?dTF3N1lmWVJpMVllSy9PSUt6TnNTcDN2cmkvVDYzOTVTMldhMUNYSGZ3eHBO?=
 =?utf-8?B?S2VYdW5NTzA1R2luRjZvWHEzTDR0YXZKNFo2eVMycmZ4MER2TG9nVTE1Sy8y?=
 =?utf-8?B?Uzhvdkhkak1hU3BtMm1NN3V2dzI4N3ZyR01ob01LQXBUaFBhYTdRWWt0ZWt4?=
 =?utf-8?B?TUxzVVdEaWc4UmtNaFpkNldROW9oUC9HcG5kU3BLdVBYT2xsUk1IbXQwL0NC?=
 =?utf-8?B?bGpEbDRJdXdjRGxmVXFkTXA3OGNKS0pkSWxkZ09FWmRxcDlZazBKcDVJbW45?=
 =?utf-8?B?NmY5T0pxblRpVHltbFFhZlhXNVJzVEtkRnBDdWJlWldhbHN2aWdWWThkZURI?=
 =?utf-8?B?N0Q5K3pkY05ZSlZOMnN1KzBNbmp5Yk90ZzIrRE9kRGlPV1UvdFZjNitpaHZB?=
 =?utf-8?B?SlJUZHR4NlhhUzN4dlVMYWloQWxJcVI0N0U3dU9YbzdPSXZ3RjZXSGxQeWNR?=
 =?utf-8?B?dHR3MDRrdWVJWm01eWI3Nlg5ckZudjNiMGJvbXdZSWpwS3hUUlFRckNWQktr?=
 =?utf-8?B?OWJ0NXhqMkV1dEpVZ0F5VkNRVG5kT0JxdjBmQXRCeVdTRWI1dDRWQ3QxeUZ0?=
 =?utf-8?B?VTAyVmxsSkpvRy82OWhOTFNLa2pYRE9FMUdjMFFHMUhRSFVHWWFaemNpaE9W?=
 =?utf-8?B?Q2RUOWEvQVFMdVdyNUVybi9RdE5zWHlyZVlVQVZpRjRXalNuRWJBZExDRnpS?=
 =?utf-8?B?SmZzd05OdjhXOXBBUnQycE5LTzJWc1dMYUpNQ0dIOHNUL0ZFeVNGczltbDJO?=
 =?utf-8?B?aTh4TFZSSnUyYld4TWZjS3l6VFJ3ZUFCYVRFWHlWNGJ1SEUxOHNyc1E4RXEr?=
 =?utf-8?B?TElFbW5ycmFaTHZNREsrUmFicjJrTWp6ZEx3YkFkdExTR2haSUd2SjNjUmV3?=
 =?utf-8?B?WTdwZllkTjNzeWRPYVZnUkRyVDFOQzZkWWYvN3FjOGVLZzc1Mkl6aUo4RWdN?=
 =?utf-8?B?ZEwrcC9jSFpqVzFVNEIyQzdoV2dPTkdBK3cranp4RVJrRXVMNUZpaGRQLzZa?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J3Ry0Fnkiw6yVYuE7iUYaUCBlKfrsFmzEnU/v3Ilu/I3xAMmgg3RtYbope7L2pEs1Ih20j69RLcqQ6MrSTiGImx4D0mtLpnTsIXGZxCWkBuxfV/iAraoEam3z3LgMAJ/3CPZfZXoXHeOMIn8oz38TyCeebunSa5LzDAOe+XYgAJzYHLlrmTISgpQ9SvAwSG0mSDnn4sEqYkvWXURfKG8o8Gmo8zdKFuXScqsYudvREdJkmMZTIWdoLIJVpjWLtHiQpKy7NJ8KHabiByxc3xgCJzUngT0Vp8AkN2Eg5V8T5tJNXI7BlVAr4VVlRw691VNOe25Dz1YOQlb2vm5xs/bBM8IxiaHAgWV111Blbso4bzIsRmFdW1HIvoxLZlKX9OHP8ZQ8+y3zAf5Hpw2w3EzLpSa7gkxYpMd5Hku/Wdm7sq+KhOwCTVL7UDqdzrv9Xhoe3nAzN8YbEz19HQQ8JxEPVbWhOD8uL5vOT3nA5QJNQkmxoX0nEH+ilxsxkwQsYLtcgAwDYZk4qozMs7w8DPm1byso9aaZtAE1jZRUP7zsqLmd9Km0+/FXpYTgSDLN5W5Xrh0Ms5Xda1Lwvo5Qt7jyFVvm+eWRUMhmMoQDedRSQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4939581-e026-4630-9911-08de121b4fe8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 10:02:44.9485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: va18GR6y6fSaa3eHk5AW+uPAMxHayJritMCX6O6wnGCQ64XKacQhrD6AdKJmsfbugbXWNMk4kMaQZZTcYIWEdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7440
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510230089
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68f9fd4a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8 a=UJ-qMIyPQSVGaOoyYhIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX0AiouULOKCgG
 rsiXwj9Uu5zFsZmqJXwh1S7SBWonrs0QNlKrVMbESiLLOZT5DPtmSkGoXMgNceuwP55baaqbdPp
 MAQQE+m8vRQCsc7geWcCKOSkNJ86p3uU0pCZXFN8d7ZU4ZO3ke2N1UECEOjT6K4x/Bra1bXo0PE
 kVKb1RF8fA5sPSqjPgOmqBcKhIlY2bLB9dCy7Cs+uyI3j4XFOzzoPaPBFEap3TrQyYD0VPHQeYK
 zuE8SKEPuIOrMLoc3slemfVbmfRZSVNFE82XgtLAdzolfYBn6GftwJy82cV++dqvaM9QLSu/imG
 Ev9AFsxsL6/X06ArwJ098WXlulzB198rH8/1c4hkcq4iffuGECImtBPCmdCVTg/IWpKO6Ai126V
 /FB6JkqXdkCHdEs+VwYgB+2JjdLI5G90MuwGVouR2SiIVo8xHnk=
X-Proofpoint-GUID: Ce1BGrMwWSibTp_R2k-aOTnQodfmIIUa
X-Proofpoint-ORIG-GUID: Ce1BGrMwWSibTp_R2k-aOTnQodfmIIUa

On 22/10/2025 18:23, Bart Van Assche wrote:
> On 10/22/25 1:29 AM, John Garry wrote:
>> On 14/10/2025 21:15, Bart Van Assche wrote:
>>> @@ -1360,6 +1361,9 @@ static inline int scsi_dev_queue_ready(struct 
>>> request_queue *q,
>>>   {
>>>       int token;
>>> +    if (!sdev->budget_map.map)
>>> +        return INT_MAX;
>>
>> For the record, I would not do things in this way.
>>
>> The shost psuedo sdev does not need a budget, as mentioned.
>>
>> However we complicate the code and add extra checks in the fastpath 
>> (like in this function) by treating this sdev as special and not 
>> having a budget.
> 
> Hi John,
> 
> The following patch series will be reposted after this patch series has
> been merged: "[PATCH 0/3] Improve host-wide tag IOPS"
> (https://lore.kernel.org/linux-scsi/20250910213254.1215318-1- 
> bvanassche@acm.org/). Patch 3/3 from that series skips budget map
> allocation if it is safe to do so. I don't think that it is possible to
> skip budget map allocation in some cases without introducing an if-test.
> In other words, the if-tests introduced by this patch will get more
> users and will enable an important optimization for the fast path.

I just wish that a neater way of doing this all could be found, rather 
than not allocating a budget map and checking whether it exists in the 
get/push budget CBs.

BTW, about Patch 3/3 from that series, do we really often see sdev queue 
depth >= shost queue depth? It seems an unusual setup to me.

Thanks,
John
