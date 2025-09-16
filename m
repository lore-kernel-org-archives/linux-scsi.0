Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850311E47B3
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 09:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013770; cv=fail; b=tug/wXV4ehaYbYHG2+fKrbZ6p62AokZeHmAsYsHVOX4Agm4Vv4k2eNZPJo8+ZZn1cGsLiYQL4qtHUspDYsYTs9geWbFptd6bMAVtwlzEzdrjLFBHe37/nf/Va5CFjQTCj1WKYskIj2x9bkiM40fno9FTU6ZRa86j/6RovgDXTOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013770; c=relaxed/simple;
	bh=SO7qYemFedijG5IADGvZ7hhtP/vJ6V1ZpbUpciHqUd4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GqceYebx3knkKpniXdEiIBM5afjV4Umt2TMk3OGFZOSyu76gtf6lq5DlVUw75no+ouXoFBr8KUmuowWzSG3rhbRl3JxXqLvE6lp/Vl2ttVEiASEJXECJc8a5unrdRFcz3CiQK2cQEJSeDIxnObynP9x02nt/tS4BNhWRhfAE9Pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rGd7JH1c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zNWmnE1g; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rGd7JH1c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zNWmnE1g"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1frRZ001926;
	Tue, 16 Sep 2025 09:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CUtd4CVRgJseRziElDYqlwIycr8gUjAVV/Qe/eiyaGk=; b=
	rGd7JH1c8rxLlqnGvItGcCTEjCz5BSFiWDeWTNMfD163vgoAjIi5jwkLBZlvqQq+
	xEFwDAP8mOhkkFDx+FW00L9abAVYm2d/JqgKpx3zbFmQggLypzKkdDiY0+jJuNp/
	bZxX+wU+4xtlg5D44pJTGaHbaDFR+Ty7nsEiW5GqvcXJYDtYfGQd7ri1AyBpi9zA
	nPa0hFlUiCJaFuHlug/vm3tyn587JXeIepOEP68wTvnMuubwJ7IKu/anjj5e9xAA
	cXaHdOKbSiRDYcVZWNfFINTVRtJ21URL6/2BRGZ/lqie3PWCiWC7lMtcZ9eK/iCr
	RxTTGqh2Dx7htYuLXjCOPQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v44ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:09:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G71Wra028769;
	Tue, 16 Sep 2025 09:09:16 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2c3u7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uw9hdpf4CNQrSF7/cgNt8YLy6UVO6gRGH/K+q581GmdjbhdpeC+q4IAcKPDEpW4V2SJYtAXMWAhOnGuPkkGEV6Mtp3vw03wrnJI35E6z4dMUa1RRDYiAZm0MrbwAVCpMbYKBAhH+7KsPHnzhPmaBQjwgPQa5a0ez6PQY1YMqmWeTcgxYUvFstLWIuDmSwPi8Fgb74mixl6o0rt/u2UwqUqhv3spuwrnF8s3ACpx+D0826P7MeTfbuC+3JvnU2gcq6etoq6vkK9PB/+ELr5IDguaqLTWCuQ9vKbEq18vmHd7FfezqLsKc+dM7pJ2o0kCAFGX0qJdjPLlZr2f2Z5FHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUtd4CVRgJseRziElDYqlwIycr8gUjAVV/Qe/eiyaGk=;
 b=F0ovUfEaof7aWroD25utJ/355jsAgnKRbqoi+QXLsWB9WG5hnn6VUF8iw2SmmwfI41K5qjj30+NtWkIIwVwNMiv098zDJfNrPeCcoXztZd2WKi28IHkmTWLj3HZmrUYcmtde5l5XA8kjig0UdboeD6TczLA0QUmjbChi/X89CTYZ0HsB0/HhtzICpQQuKTbUX/vDH9lVEy3ipH8E8NR/KHnXTPBsvENvNcnHAlmKH7dUO7Vat5G6CHTrFZsiUbdDiIB45FuJeTj1DrlgAfCg8h0aTSKRG84GriTXHPF+PtKCDTLCtnVs8FenVydUZitQiS9VDXSSAcd3TUL6wCTnaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUtd4CVRgJseRziElDYqlwIycr8gUjAVV/Qe/eiyaGk=;
 b=zNWmnE1gaCzkw09/dHibbbFhKDxrbLraJOeSmAsf16bR9QQuMiTH6x4R9Rnnr+wA7HpPAffkY+Y/VpzsONwTpz5+hbt+oSqUADGth8gbB/l6DhfzKGTLxrXh3DNAWvSCFcdeByMth3kPRCnl9LuLWS6jH9Usl/wQeizrNChlhhE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM4PR10MB5992.namprd10.prod.outlook.com (2603:10b6:8:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 09:09:13 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 09:09:13 +0000
Message-ID: <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
Date: Tue, 16 Sep 2025 10:09:09 +0100
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250912182340.3487688-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0662.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM4PR10MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: ac2d831f-7657-441b-4a68-08ddf500b433
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1RlU3o5bHFicjVzVjFUWnhqWVg2ak1kdDhMRVZ6Y256RzNndCtDaWhNdGxI?=
 =?utf-8?B?SXpMaDV0S1VkZHVrUS8rSkF4T2M4UEhrQlgzQW4xelQ1QjFZL1c4ZUVIYU8r?=
 =?utf-8?B?cDFXMHpBWkREeEsvUTk4WEo1YXMraTVQQ0xVL29PU2oxaHgrQ0JmVkc2cklE?=
 =?utf-8?B?M1ZYM0FLZ0h6aGtHenVMNm5OZUdDbjN2UWpkblFpUW5ReTB2ZDlzUTVwNjRk?=
 =?utf-8?B?KzBTbWRqRzI1aHVXYUhnL2p0TFJlVjg1V0phQ3RJNGhUMUlMK04rT3lKWjBV?=
 =?utf-8?B?YUM5NTRROHdBaHBKQXlzdHloQ25ncy95QTl1QzVBelRpTWNXYjZBditJTGJP?=
 =?utf-8?B?Ym5OemZBWWVXVkd6TGJ4dXdvZUhWWTQyQUU5YnZvMm93WEJjTnl4d2NYcHo0?=
 =?utf-8?B?U2orcnY0UERCN09LMnN1OHlUeTFDeWppN3hQUVVkbFYvVldwS3EvL2ZkNzVV?=
 =?utf-8?B?dW1jamFGMVZlTnpWWHpsbGNldzhKNlBycWlLN1p2andPV002UzZ6aTdzdnM0?=
 =?utf-8?B?emxVTVdTcXNhTW03SGhvYnRoYmZ3KzIwSitIaTJxQXlLSC9WdDd6YVJ2aVNa?=
 =?utf-8?B?bnhBWjBxOTlXK2d2WU5OWkprd2RCd0NFNzRLbTdqZllaTXFUVENSNDNZMWxl?=
 =?utf-8?B?bmVreld3b1NTMlZkUkcxcC8rRkZaQS9QSDF3U0o3OWtlYjhJZCtsSmExMTRL?=
 =?utf-8?B?NFJnT1dEZnVOdWo5Z2JoNjdlWktrZkdOeGxKRzlVbVMxczZldkZmbThheDYy?=
 =?utf-8?B?OURBQVl2VThyc09rb0xQWFpXaDJGWXhJbUJjRTc1VVQ4ZlNqUVduZ2VFQ2lT?=
 =?utf-8?B?MVRPTkRBZDVRSTM0dFV5RFFXNUhMUVNHaG9iZXh1ZHdWckhISHFzakhzNURm?=
 =?utf-8?B?eUlWejNxdTl6dW9vbWo1dnJUdFhQTEc3UVRNV3phNjZmeCtYWHVYQnY2U0ox?=
 =?utf-8?B?MVpsR0liYzQ1ZkgvKzd2Rlc5bW9HTGFBdWZrdW9JVWtTTjVOR1ByRnA4aHdm?=
 =?utf-8?B?d2t4S25DV3lkMmJyUGlTVkx3SFUwcng2Zms0R0lFb3A1Z0JRS1ZHMzhmRytK?=
 =?utf-8?B?bTMvZktYNXhqMHZONW9RTHpwdUpUMTJ3aWptSHBmTERwZ0d0UUFZM3pvVVBq?=
 =?utf-8?B?WklMa2NNdlBGdWp1TGw2S2tldnptdXVVUUQ0NjNWV1ZKRHcwWm1yZ3pRYlZw?=
 =?utf-8?B?c3RqOU0wZ21IamU1Rzd6eDdxbVpjayt1ZnRvbHFSYTdtekIxa0pyRktpb3FM?=
 =?utf-8?B?bSs3dSt4VjY1VmhLSVRiMHNBY0VqaU5FYk8wMlVTOUQyS3RKd2JVZkhzL05Q?=
 =?utf-8?B?cHppYmpBQjRBa1p5UU9FNDBiTkZUOGtBa21QQ01xUVRpbzRBeFlSY3FtYjBV?=
 =?utf-8?B?eGltR29lSjdGWEhab29WakNrRXBXWHpTcUNXK1FhazVXVUc0MGFmcXlNdVM0?=
 =?utf-8?B?YlZkVDM0bmV5UDFZLzBnUUJhOUFpclFhaFRNaytUbG1KU3MrcXdSV2ZQbm84?=
 =?utf-8?B?ZFpML0MwUkw5UnVjaWRtcXdFN21wNi9ucDhqS0FqR0E5NlRBcVd5UUtwRU82?=
 =?utf-8?B?Q3ZERFRDdGNraGdaOUgzSHEzaGVyak9QQy9qTXR4VFFHT3RGWDI1YVA0L2hI?=
 =?utf-8?B?TXo3ellqZHJJb1JpVCtwbkpLRUtOa3IvLzJSd0szVStwc3RkcTN1eUduVUEw?=
 =?utf-8?B?aVhZSmEwbVpWS0wzM1p0VFBYRkgveXhhRUp1eVZuS2F0MWp4S04xN0EvNnpE?=
 =?utf-8?B?ZHp2QkxMaldaSi9DVWJLZkd1Nkl4Z1lhVFc4anN1SCsyUWpiVS9hRjcrSGJV?=
 =?utf-8?B?VmRvQk5NbytkeEtndHZmMjNYTURqNjR6N2twQmozQmdiV3llWllDQmFYRUlm?=
 =?utf-8?B?Q0ZMeDJZM1BVSXdOOGNOTzAvWGVCbnhlNkRTcG5MVFNrVUxEMDI0dFBvQ3lR?=
 =?utf-8?Q?mpY5MriYGAo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2FOKytMY1NmRDJXYzZvK1VLMm1UWlMxWW53OE1QZVg0cWJNKzk3SlNmM3lQ?=
 =?utf-8?B?RTgyUkZRdTNjWFNYRWJOWjQzblRQeVdpaElLamlnVGh0NU9ZQ0xHbDBpK2I3?=
 =?utf-8?B?VHUxcUk4MUtFQjhnLzlYditiTU9manVQOVhqakl4S25UYVNQanlxRG9wRmdx?=
 =?utf-8?B?RU1MeGpWaUJMc0NZVnVPYldzbVNSbEFlYkZQTU1OaS9VZEIvWXlVQXdhazVY?=
 =?utf-8?B?ZGZOeGUyZUZudkNtL1lEWG1kUmdRRkJyTmc1TSt6MWFRaGV0VjlnZTJNS1JZ?=
 =?utf-8?B?SEhTNU5udGF4dFJtdDY0QkpYcmVBVzA4K3NXTUFRRDF4azZ0dHJGNmltNG92?=
 =?utf-8?B?Y0tjam5iYjRFajBxTWpWZVFLcUtOMHZsRHlBUlB4WThVOUdwMC9pYlduRUtZ?=
 =?utf-8?B?ZEtJWVFZb3FhZnhOOUhxRncxd1B5dWIxekJUS2ZBVm5tTzMrQUVYeVpIWnRw?=
 =?utf-8?B?alV2RzVtVFJ3NUQzc09XbklqdnVIOWsxSXdacnhoWUlvaERWdEsxMDB3TFBn?=
 =?utf-8?B?WmlZSVhVKzRvNFJtSU9XWDJXUk1HM3pkMDJlS0hkRjhlWnhWaitkNll5SU04?=
 =?utf-8?B?MUEvekhKYjBOM2xPMFZqTmxrMlJpRFQwMTdtWCtPaGtpQjREa1psa25SVzZ1?=
 =?utf-8?B?SzZQZzAxbUpLeklJVUp4c3puVnVpWHRKMTcyYTNFN0NHNGg2UEl0SSt1ajBW?=
 =?utf-8?B?TS9FTVE5dFJodDZGZmhvM0FWNnFPeEhDbHRtVEh3T2ZybVRmcG43aEgvaE5r?=
 =?utf-8?B?S0o3K0MycExiNTZKNUNrSDI2aWhEaCswN29EV3RkRVRPU2dpVlZoMitMeTVa?=
 =?utf-8?B?NHlnL0RtQVBJd21RdXhFUzE0bTFqbEVnZXBaa0FBRElEN21ZdFVlYWtnaDll?=
 =?utf-8?B?dSsrQ1VlVXUwTXlzekRhTnFkMVhpb3A4Ni9oL0d3TWYzRFo1SHkrejJHQzVU?=
 =?utf-8?B?MXllMkkzd2czVDlWYnNWa3poM1VweGpXM21IM0dlQkFwWXljT0lQMHZNMGNo?=
 =?utf-8?B?bzA5b0QvdTZCZ3ArMkxBN0o0NE9ZNFZsM05KLzk4NlIzczNLaVQxWGc5U09D?=
 =?utf-8?B?dXJRODRmbjAwZ0dScy9PNzE5cnBVK3hkTHJCaUtPQllHcDlXdDNuRmRScTZL?=
 =?utf-8?B?M1pjSjhhR3RiUExnSzZTZDZHSUsxczNrbm8vSHVxNmpKQjgxWXJ0dCtNRnhy?=
 =?utf-8?B?VEttdEVKNjVRMTU3ZlV4M205VkF4LzJrb1E0T3dSOUtScjk5QVVCdURjNVc3?=
 =?utf-8?B?bXh5Y3NvbEhma3Q5ZElaaEQwcHhhN1VkZ2hXZkZmZkpiSmlQZDA2a1l4Q0Zu?=
 =?utf-8?B?aHQ0R2ptd08yc2l4OHBOeU4wdFRZRGZPdlR3SEh1ZW1RMnlIOUZUMU1wT1h3?=
 =?utf-8?B?bnh5VWlaelN4OGlnNVlqblJHNHg2Ny9NM3liNFpoaGNrbmtuOGxaVllsZSta?=
 =?utf-8?B?TS9sd2J0aDg2TFR5K2hyOGdEMy9IT0NldFF1Mno2U1E3cVUwcFgzTU1zZk9L?=
 =?utf-8?B?YVJZR3A2aSs1Tk5aL21FdWlEK2NaYUtuWE9BcGU0eE12SGZHbzNaSkd1RFF3?=
 =?utf-8?B?U0hCcWlScnlpTFVQcU16M3JKNzNCMmYyNEFPTEJ3RnpiZ3lxQWhpWStOeEsx?=
 =?utf-8?B?SHY3UnpQekc4NC9KNnJaeEY5SUNrZFlJL3lXWnR5MnR1Wk9EMjB2dzB3ZWRv?=
 =?utf-8?B?UmxCVW80eUVLbEZ1aTRMUHpkVkxuNVZCbUFxaDREUU55M3lqYTFYZWdvbEV0?=
 =?utf-8?B?WEJYWDNBaS9lMm5oU3REWlp6NU4rRTdZS0FocUZGdFlva2pFT0ZWV2s5OVJ4?=
 =?utf-8?B?elVheUpiRnJ5elh6a2tJbU1mTFkzdm9PRzFmT3l5eFFGT01CZEdhdkpsS0JD?=
 =?utf-8?B?aW1lWnhMR0YzMlI2QXJveEFsZDZab01GMkFxaVQvOU5ZY0l5bTYxc2phQmNz?=
 =?utf-8?B?N1IxRkJzQmdPRkZ4VFFEMWFzbGQ4OElieHJ5U2U4NFQ4Z1NTcC9RUldrdlpo?=
 =?utf-8?B?WEtyQ1ZXTkRMdmJoNWhSekJpckZyNXo4bmlUZnFsQlM2KzU0cFJBNU44b1BP?=
 =?utf-8?B?czQrT0JKd1JORzBaZFRXbm9hZkxPMVQ0M29TSVNJWjEyNlNMWWliN3oyMHBM?=
 =?utf-8?B?Mkd1Q0lZWUMxYVR4UXNFbVNHVXBlZFhXSzZRZDExTkJiMkNXZCt3YW44QUdi?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7KB8fEUui3Y9/mjgVgV3O7w/iv9JiSbSKJEgqc0yxa2M2DK5pgHG7nmTRadiQsulTstChM4ypbkIB9beqI9cbBAbUnGmHTOz1zoFuNU52fYLoHZac5x840u3P3S+8LkBVMZrF234adgiAite44rZb+opcD5j59i9wYM3+AIY0oQZUhcKiaWS+yTD60hw6s+4OkVa6l7pF/9e7+lwvgc06OCO+NiC3g51aheMWEU0F8yIXicVmkpDcH7Y+U1BI5RazfMqx2OtBxVT5Kfu46gnHCRPj39riMsYMuc+Rc9EYGVsqO/b8auRgAiEyqiAIv9p4g9Ri6NU1mj1cKIvzBtE+y6YZ2B/6idancc/3jGveF1TRfUIKq2hchTQlP+wvJEzdX7/2xdttFvRT0+5NTaOYj68ClKpnXo2jhwF6oAHDoUEGqKMC/avO1gOJBTVceIJmZRI7X1yh+lflG6rygy1fP1p1u7BXx0xrT06NU8qP497zAdd5o9zNYwAcavgCuzaMHnaSLjKH5RacRoKRSBm8Tk9MXL0PiRZMcXHR0a7lVOMZudLqkhbhgLukwFuJv62ny8KXParCJ4ipw2mDXqUHnx1TDGMOhRTFV9IQtEf+Pw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2d831f-7657-441b-4a68-08ddf500b433
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:09:13.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3qynWZlDZEU9qyJf/l/pMI9dRem67TPACaJBlcoqq3zUiLFbbjrIamtdVASIO2CwwuMJ4l/KG31Gmy0ygJ6fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160088
X-Proofpoint-GUID: OT18MgvKxzeFcqDfFRPFviGcj-jdrOa2
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c9293d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8
 a=wrpb17Trpfd0HqQpxGoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX3IC78TKuGFJf
 dqRBiVXFri+3HkM1ZiGqscMFU0P6ZLwbrKkFc9zkPT/RE5V2d+ZfpVfIvz8woQ7QG0h5c2IhBEZ
 guq2BzqEopSW9qDM381XGf2yUudtG8o593NxlyVkms2NNIgJ8x92DiLHP0TSM6SX6puMBLPFIz1
 FbKDRN/Cla3NAecMzb/651M+3B20LvEr/QzgBQ5nmGR9cKU4K1rWPkjPmEyMZEbpmYcCqd2OXGi
 VSuX7yEzt7JGdr30q8KcwjD3DyUu3w8UEDOD7NsGgMjS0Ffz3SsWw/x4bBbUZCyyoNNLkRiSQvR
 V9phCCCBSv/IDvs75mtblxgsCbna0Xtc25V4ZFxRfEMxX4S40/z5vJlz6O4eXtTEdx+7WXT5Drq
 wVCjoJX4
X-Proofpoint-ORIG-GUID: OT18MgvKxzeFcqDfFRPFviGcj-jdrOa2

On 12/09/2025 19:21, Bart Van Assche wrote:
> Make the @cmd argument optional. Add .init_cmd() and .copy_result()
> callbacks in struct scsi_exec_args. Support allocating from a specific
> hardware queue. This patch prepares for submitting reserved commands
> with scsi_execute_cmd().
> 

A comment: I did suggest trying to reuse scsi_execute_cmd() for this. 
However considering the code changes and the comments, below. Maybe it 
is not the best thing. Let's further investigate...

> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c    | 28 +++++++++++++++++++++++++---
>   include/scsi/scsi_cmnd.h   |  2 ++
>   include/scsi/scsi_device.h | 37 +++++++++++++++++++++++++++++--------
>   3 files changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5e636e015352..022cd454d658 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -308,7 +308,10 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   		return -EINVAL;
>   
>   retry:
> -	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
> +	req = args->specify_hctx ?

Can you check args->hctx_idx is a specific queue or something like 
NVME_QID_ANY?

> +		scsi_alloc_request_hctx(sdev->request_queue, opf,
> +					args->req_flags, args->hctx_idx) :

did you consider passing this hctx info to scsi_alloc_request() and 
allow scsi_alloc_request() contain the logic as to call 
blk_mq_alloc_request_hctx() or blk_mq_alloc_request()?

> +		scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
>   	if (IS_ERR(req))
>   		return PTR_ERR(req);
>   
> @@ -318,8 +321,12 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   			goto out;
>   	}
>   	scmd = blk_mq_rq_to_pdu(req);
> -	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
> -	memcpy(scmd->cmnd, cmd, scmd->cmd_len);


> +	if (cmd) {
> +		scmd->cmd_len = COMMAND_SIZE(cmd[0]);
> +		memcpy(scmd->cmnd, cmd, scmd->cmd_len);
> +	}

you could just pass a dummy cmd instead of doing this

> +	if (args->init_cmd)
> +		args->init_cmd(scmd, args);

is it possible to do this in ufshcd_init_cmd_priv? Or too late?

We could have a "is reserved command" check there (in 
ufshcd_init_cmd_priv), and do whatever processing is needed which is 
done in ufshcd_init_dev_cmd

>   	scmd->allowed = ml_retries;
>   	scmd->flags |= args->scmd_flags;
>   	req->timeout = timeout;
> @@ -353,6 +360,9 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   				     args->sshdr);
>   
>   	ret = scmd->result;
> +	if (ret == 0 && args->copy_result)
> +		args->copy_result(scmd, args);

can this sort of thing be done in the LLD completion handler?

> +
>    out:
>   	blk_mq_free_request(req);
>   
> @@ -1247,6 +1257,18 @@ struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
>   }
>   EXPORT_SYMBOL_GPL(scsi_alloc_request);
>   
> +struct request *scsi_alloc_request_hctx(struct request_queue *q, blk_opf_t opf,
> +			blk_mq_req_flags_t flags, unsigned int hctx_idx)
> +{
> +	struct request *rq;
> +
> +	rq = blk_mq_alloc_request_hctx(q, opf, flags, hctx_idx);
> +	if (!IS_ERR(rq))
> +		scsi_initialize_rq(rq);
> +	return rq;
> +}
> +EXPORT_SYMBOL_GPL(scsi_alloc_request_hctx);
> +
