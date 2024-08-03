Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95546111AA
	for <linux-scsi@vger.kernel.org>; Sat,  3 Aug 2024 20:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722717786; cv=fail; b=knLOUHWBcFfwvdnA2wZYDqIeEXFdYnZ8i8L/jaKgQo1BDdyaKiUmpP27/L6K45kZ3ZCp2aAHw2ISSUmfKZrojgEgL41MEENWdG8QVer3KpocLQRS/ITpfE2fr7dH1SF1lHZgDN9Fk6/fgwYfebA/cjJpNYM53Tb1b0ORuHt0Q40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722717786; c=relaxed/simple;
	bh=XB26pQxVkykpWQSL1tJrHgaYtcQHJ8oF9iBO72u7f7I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r022K33QuyTObvXoP9DR/nHb1w3WkRb3UhRfufoYvePeCUl/WKqqllkd64QTPRAiFM2KVVgUkv8vJU1hbrAH2BRlPZXFbJE5jfLGJvxJ6igzp+w/xcjw9sL7XhJXjNZ2CyOK8eJjZ3or6IPXe0/DxqktSb8cZSn+MFz+CnSuTuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dd0dkkjm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IcGVuib8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dd0dkkjm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IcGVuib8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 473FveDf013606;
	Sat, 3 Aug 2024 20:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=vZk85qOGr41ZozB5Ipk1/AJpm/v9huxk+B4KF3uTC/s=; b=
	dd0dkkjmbNknU7Pn9UrsCXWAE2+XuZ9ViWo/1vDe8KjqwjCwHdIEoF5GR2M4zRud
	ECHeZEarVJ9zzGGcHI68S41NoamwZK9dIgmUxuK3fp0UEjubVG0X0h10n3BsjsZ7
	rY1qXSF47CLXGmHHCM8/TMLRqqi+i9O7Up/69R8VI5HIS4Yyzh56gxHuv6OBG+qT
	xpitJ8yJOPdLS2u9tdRLFccKAkQFz7LxnkSL4vZbZLRDSXTzY55y6aEx8NxkoH0C
	KQqY34FeacLmBEXhyuenza5w0T6ZZxU5LBC5QD4GM5FcBHUHH+hgiRiRbul5e2Ld
	4J1vQng6q8zk7S0Tyx6kHA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbfagnw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 20:42:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 473GbeJu026287;
	Sat, 3 Aug 2024 20:42:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0c8dw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 20:42:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUgR5vfTAbIi39hqr+B+GoNuVgLuV2VvWOAFMaktjOjHuGcx6hdfhaNxvtoDKECyDGgLRID3oUdjLNXv5SG4tPflSeh4ZWxFN/Ia4AuLrA5LXv08sCiH+6MlDdF1Rz0pI17IRVTUpuHpbr8TihUl5EPSio7qM4Zd8GyKHGOG4yp+o4/mksbGOuFMdaT4SZHcecxKgWJNYwSNfz2N38/jGNrnM5MMXmD06ObNZVT+Sp6Cf+OeNkCuFGylPbvWAZ0OPytcCSaiMO5f8dmRFWMwg47mwA8lRs/NRU4XxgAovMBg8uCh5OaxuWH+nj8nmCzLflAFBqQ+N/FiIphAeUvHKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZk85qOGr41ZozB5Ipk1/AJpm/v9huxk+B4KF3uTC/s=;
 b=CC3JuLeWjW7gaEBL1XYtFT4Vy7qlCmrkqiKbEM3WbTYHdMvadjwfJwFGzAF47wXKDvgCgkMpEP3xa+oZjJlme0ccxHCvhjnQ87XioBP/m5+i836mjdhnANYQAQYxci7wXMQXdGaPzLR7qKrGBfwqH1jTbqXOA/MmubeyW/rW73WNoLVwBlRGDVlOpijbiwJs4gBceUNigCH6aqPKi59uC2p3w5haOQrDtV+jkFmuzF8BEIU/3eNOO2lpU2yBZz/cdJv/BLk/aIeWsBRmcvoYmsVhgg0+UnMkLtelRji2H51+dacS4upssbXvnHkeHaUjuQ5aJGJfUomIfe4Ek/F4gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZk85qOGr41ZozB5Ipk1/AJpm/v9huxk+B4KF3uTC/s=;
 b=IcGVuib8hEXSaYdcWEtkPrPL4jUUA7O2tFgBUVSVFRYvWTE39Z+3JjKKMC1JtFOw0m1GyZcjaY/c/vk+ydkI2gZ8YAeJl7od/fus3YC5Ob/tWj/rlbMUdrzSWR8KC0vNJiJY4d11HPP/9H9RfjL8zFkAZMaybZ3noM5Ttygjb7A=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Sat, 3 Aug
 2024 20:42:39 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%6]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 20:42:38 +0000
Message-ID: <2addecad-bad3-41e2-a8c7-ee68f3c471bf@oracle.com>
Date: Sat, 3 Aug 2024 15:42:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:610:cc::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA2PR10MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: c454ec45-c5e3-48a1-1ad8-08dcb3fcd02a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHBzcCt2a3hvK1pTTnUzNy8vaU1ZUzJQSTlvK0xUc1FYY0pxQ3c2eklqQmpu?=
 =?utf-8?B?RytBaTNMb3A0enJSdDFlbjRhTVlRMkx1RWtsbldLWGZNSzlzaWhFZ3NQMGtZ?=
 =?utf-8?B?NlB3NkhEWGRMM1BhYWdxemFQYkZ2c0lnU09xaHpubTBLYmh3OGRvV1FrZFU5?=
 =?utf-8?B?K3diY0oyMDNlQ3lodTJSaDZScFZ1cGM1UzUzZ1p3WEg3THdTd2l3WnZRSUNv?=
 =?utf-8?B?U1BObVdWK0xYTDNvSG1kU3NWbnRJN1ZNRVAyWE42LzFwS2ZRZHVhN2Z0OWdy?=
 =?utf-8?B?TUw1RC82bXErWkl2ZjRqQm5ZbXZGTS9VWElOWWlQU01pV2N6cUlsYmxKNEZG?=
 =?utf-8?B?MEt6YTdId0duVHl3bU14b2M1TCtJV2NuVDRCeFcyaUpFVzhBMlBsWjlURFVR?=
 =?utf-8?B?SXExVDBNdDJmWWpRNmZVT24yN3BZT1M5TUxJbHV2VXUxRjZPMTJhS3JLUnRh?=
 =?utf-8?B?ZUQvNzlXeml5c05MZE54bGJZemo3azVDZEtNQ3IvWnEwK280Y0JrNGJjMlo4?=
 =?utf-8?B?YTZDZ2YzZFZuamlCRnFyNXNwakpVZVZJZU5VMUxjejlVUkphTTcvUzFFR0w0?=
 =?utf-8?B?SURKUWo3aENNN0YzOG1LRi9JRGRQVVlrMDJLOEFpdmNvV0NxQ1d4OGlWMC94?=
 =?utf-8?B?dGJPWGNMT3lXVWtIVG80eDVVcjk1VGZFUlgyamUvQVJHZTlJaXhCUGdTdzN0?=
 =?utf-8?B?NTBWOVpyRWdCWlF5ekJZUnRkQ2F4WHVTTFY0T0hGSmJPeWhlUTIrOXh0eXdL?=
 =?utf-8?B?aUsweGZsREppSlBxQjlnWUpDclVNQUYyYWp6VVp2TERHMmprV2ZRemFYQ2Z6?=
 =?utf-8?B?QnpmTmZPTDZvMmE3V203NlV4dW1xelRLeVZhcC9FUXM3Z1RyeVhUazdqb1Za?=
 =?utf-8?B?U0NqVjAzdXBDLzNIVXpDUGkyeHhickZpUlRjQ29iR0xxVzNmS0F4NWlDS1By?=
 =?utf-8?B?cm1WZXNSZkZkRGlLR2dEQlo4bjRLbW5LK0VSYWJsM1FlSitZR2tyL3BXK0d3?=
 =?utf-8?B?Qmp4UzFIOUd3MllwSnQ3a3BPQWtaSkVicklEM0NLalRhbVl1bzgyM0ZjWjNr?=
 =?utf-8?B?K1pZN3VOZDhkM1FxMEIzcnYzTE1OWG1raGNKcFJFaEtlVEdCaER0UHFnRldQ?=
 =?utf-8?B?TTVVWXE4NGg2eXpkeVZTVUpWaEpiYlFCVU1abUUzUGF4Tkd6aDZLTE5RREdQ?=
 =?utf-8?B?WEFCd1BkckRGOW9VZld0VStIUkIwRmlEeXpaaDgxdDNkTEJVdGlDQlhNeXJF?=
 =?utf-8?B?L0UwZGRTRnZtRnk2OTJCMGh4ekN3ZTZzVnhab05PL3JLOXFBZ2NjNXBERGd4?=
 =?utf-8?B?ZE9tTStkb3I1L3NNSm9tQ0pVVnRYalNCZmNBTVl5MjVaOUc1ekdVei9JbFZT?=
 =?utf-8?B?ZmxqRkd6RERydGZEKzIzZ3hQNWhJQkE0M0IrVXRuVENNM3luUHlBalJRanJE?=
 =?utf-8?B?ZVEvdlhzRFBHRkRSVGg3aDVWckVEUmk5RFdqQWovZmx1KzE0K1c4NnhPdnZy?=
 =?utf-8?B?a0hKQW9zVWZxZ1R3Q3RIWE1RYTlCQ0g0ZkFZS0ZiWThIVCttVzVaNGZ3cTVY?=
 =?utf-8?B?NmVQQU5uSngrVTA3RGJyMHErc3MzNTNxWnZIeWdwS0lTbk0zOEpiOXJhYldQ?=
 =?utf-8?B?Y1pQOW5hTlR6L0R4YzBJTEtmYkpXbmI0dHAyMy8yN3JwSVZDTlpGUG5Gdnlw?=
 =?utf-8?B?SklxVXVjZ1V0OHhGMitaa1NpLzBURmVkY0RoRlRZaHd0Vk1Wb3Awd1QzaTJD?=
 =?utf-8?B?V09YZDl5Rk00UGRMS1lqbytEbnJHVzBWaFF2ODNtMGJXVWZOanA3WVV5ejgw?=
 =?utf-8?B?aExJNVRjUk9iOEZmK211Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0tHeUVJb2VGdnRsVDdabit2c1htSHdMbmFxYmJCYnJTZ1dMK1JNd0tYblc0?=
 =?utf-8?B?a3QybkZScmYxelZSV08xTmJBeStmdDE0LzF0SmdwMHVSVGs0eE9mYzRQUHYz?=
 =?utf-8?B?eVk5aFVTcXYybEdYbVcxNVU5OTJvUFdjRUNEVllGdFJqdU5vc2JkcjZBZld6?=
 =?utf-8?B?VnNpRGlUSlJqUnp4MFF4UldKT0Q5SVJXS2VPRmM2QXcvbkxkMjd2TW1iU0xk?=
 =?utf-8?B?NzZLT0xXdnZFZ2JKMUNzQjBkTWJvZmtLU3EvVnE2MVY3MkF3TXdYazBiTHJ1?=
 =?utf-8?B?Njc3aDFiLzdlY1RHckpiTzYwZlg3RTFNNjU3RVp4WWQ0SHJvV05XRjNxa3k3?=
 =?utf-8?B?bXQ3cXZqOGhxT0owM2dzN0tYTGxYTXA5eS9VaWxyRXlZSi84bVkxMnhnZERm?=
 =?utf-8?B?WG1MRGxJTG9ZdnYyc1d5Uk9DQlB0cHh5VS9SVGxVVXJxK3lRTXJldkc2T1ZX?=
 =?utf-8?B?SkowR1lheFVEL2tlZ29pY1dabHhYVzN2VkJIUmd3bFk0cTNWS3NHZkdvU0Z0?=
 =?utf-8?B?bFpEK0x1dWh1amxaampqWXkvNVhJRlZRTjYwU3hicEpDOGtCWTVqeWxBOW0v?=
 =?utf-8?B?UjhLMWNUNU1heFZWRnByVGhqWW0yZS8zZmtKdzNRTkpBaUJaT2dtSDFxNEUx?=
 =?utf-8?B?alpuNTRMVlBPUzJONmlOMHZVQXdMVDhHelN5dWZxM21XNG0zRXhKYzBxbHFE?=
 =?utf-8?B?RzYrRytNdGtDYWt6Q2EzTjZlU2lZV2FmazMxQW0xbURuNk5Zc1pTa3oyMW1H?=
 =?utf-8?B?SVJ6N01sbGtkWDdMMTcyb3RPbFU1WjZmTjdybFM5eVRNMnd5R3k5MWlSWThk?=
 =?utf-8?B?bWxUcjdBQXZxRmUzdFJrWXFPVDQ4Z0w1Y0N4QUZROUtwbHN3bGxKUTZPSGIw?=
 =?utf-8?B?a0tKeGR3NUY2WEpkbkZJN0dTSk9KdTFQeXRIVUoxZXArM3VrMjFDTUZUUU1p?=
 =?utf-8?B?aHk3NzZtcWhFQmhUVEJtbGJBekhZQkx2UHkxMFJTVXY0T0Vib3ZUTGJCOGo3?=
 =?utf-8?B?WGlpWVI5M2RZbXVieWYrOFBpcUVhcGpDb2pyQ1ZrdlZ0WlN5dXdyZFdNbjFo?=
 =?utf-8?B?b3ZuUmV0bExRZmxuVmhXQlpKUHVLOFdSbGg2cW0zN0FkV3h2ZDU3WGN5Qmln?=
 =?utf-8?B?QjRCSjR2VytJZEhXK3ZXWmpRc1J2S1ZsK0JSSHo0djF2Zkg0VkZxaWh0ZGlD?=
 =?utf-8?B?YUZIRlhHRlJqTWE4Uk5YaVg0TXJoMGR5dmd2dURyTHQ4c3Q5WmNQdS9ZR29T?=
 =?utf-8?B?b2k5ZVRiN1JUS2Y2VHpvUmU5em53OE8rSEJRWFd5QkJ1R0NsK3o2K1JEWUV1?=
 =?utf-8?B?YTVvbWpyQXo0ZVZpSWhCS2NxczZxRFhhTi8rL3FYUUZHby9tSE9QZkhsVEtT?=
 =?utf-8?B?VENFMHpYY09yakQxZzRJdnJVNVZMMXIvamRMUGVXNmxZM1Y1WTlLaXh4V0Z6?=
 =?utf-8?B?NzRFN09GaFRzdlNZaERTK1dVSHVUSEZMdTlsODZRb0twMlVXL2wvZ01wQndW?=
 =?utf-8?B?VVFXb1JOZEd2eHpzcGlHUUQ1Y1NVUFRVTXAxUVFxREt3R29lUFVZbDY1R0xj?=
 =?utf-8?B?d3pURzN0T3dHNWc1WnlqcSs5QW5LaWNUZUhYb2pGNnZ4QXF2d28zemtnNStm?=
 =?utf-8?B?L1B3UVM4cSt6WCtyaFI1VXdkV1RLcjErek5vV0xhRVBGd2s1Mkc0NnZEQmgx?=
 =?utf-8?B?QWpTUWMxQUV6OHZ6cVlqRjdpYlM1UFJpQks1S1czQk1WZmpnaHZrckdxYTlE?=
 =?utf-8?B?VXYzZW9RTFB2eUVmemRCc0ZhdHhOL0FZL1ZoWjJITm5nZDVOQWxTd3FGZmxJ?=
 =?utf-8?B?UHJMUGtRUG9pejVwNzgrN0ZMekZqUGNEK0FWUnpNd3FTbVR5V3V2eHJIeWNJ?=
 =?utf-8?B?STRaeUQ5cGQrNTV0SERId3E1QzlSV21IUXJ0QnhYdlNqWkF6N1Fualp4M1dI?=
 =?utf-8?B?RjBxVU1tcnhHaERuY2Yvb0ZzK0R6eStQSjI5VjdtQy8zNzVWRHNBMEpIRmFI?=
 =?utf-8?B?YVZPb0l1aFNWbzJlOURkNHg5cFMrWHlxRC9LMWh3Y3NVVmtPZ3JDN3Bmb1Nn?=
 =?utf-8?B?YXBlZlJFZ2QrVFI4U0lSd2NIeGVBSy9qWlZjMEVDellRQkNURWMyVXhwV0gx?=
 =?utf-8?B?ckp3aXdFbURlT3BmdnBvSFV2ck5uK0p0L1BWNkN0NzlSZEdmNEwrMDV0QXZp?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GQ6TWHgr+kynfAgfcYo5FTf4DqBpH4O4FVgHPtjyTgs3BTHhKcKpNpcUXMB9qnAOCgz9KSmOW7Msq64vMyVvEvm1AR24AxYLvqIY+6lBhDT5QUzBJiUvcqsQrgno1eAPnQl0fIUpRUBiww6quDjNglZeKG1S7f6T3XkgDqh1nL8dmKLpGOpJeGR4uhJPMVu4BQMuGmQThfhwaD4KuC1Oyugp7mUWVkVBaiJ0SCqgiLtiFhXmCJzfg0BhnlV2sQ/pLQua+PHLuBYf61M3M9T1Yss9WnuulNeR1EDwe3DJ8NZfTzAGrVOExk3Xn81X5XwhAzIpMNOyLcRkGueiQz15eAweY6tqD2nUPyLAqLUxLbXEVdMWY3S56OsPPPVqilHWWVak2awLLQuN59pHmWB9HRpFI8rpp7EhrX3YBsTEi34HIzRRLEgcOpcYaV/PVu9RuCgob697gj9W7pT82jcBg+qrvYiXeOhqSKRrOXWJtqrWGBnqTYUOuISLhJMqGG7/3g+W7hqBoKAl8DHP9Jqzexk8X/yPXy2dhKeQnrtVQWqB3io66g2WNagYSHdEg0nSOwiQTHQ7xYJfGMHjC829pQPBIoxep5JWfz6zATf9Afg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c454ec45-c5e3-48a1-1ad8-08dcb3fcd02a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 20:42:38.7452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsgClmzf4eB14RIejiDSFn6Sn+oFxXM8KaRg4ch8QeOUCIacS0nzrH3CsHVcTHrfntLze+73sUOx1ds2e45JGjLlSgKX1BsvZDuv9zkia7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-03_13,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030146
X-Proofpoint-GUID: ReyH7jBXbsbGcwKFJeeLshgBA91V81cA
X-Proofpoint-ORIG-GUID: ReyH7jBXbsbGcwKFJeeLshgBA91V81cA

On 7/31/24 3:22 PM, Bart Van Assche wrote:
> 
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index da7dac77f8cd..e21becc5bcf9 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1816,6 +1816,12 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>          * assume caller has checked sense and determined
>          * the check condition was retryable.
>          */
> -       if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
> -               return true;
> +       if (req->cmd_flags & REQ_FAILFAST_DEV)
> +               return true;
> +       if (/* submitted by the SCSI core */)
> +               return false;
> +       if (blk_rq_is_passthrough(req))
> +               return true;

Do you just want to retry UAs or all internal passthrough command
errors that go through here?

For just the specific UA or NOT_READY/0x04/0x01 case for an example.
Does every scsi core passthrough caller want that retried? If so, then
I can see where you are coming from where you feel it's a bug. I would
agree we would normally want to retry that in general. Maybe others know
about some specific old case though.

However, I'm not sure for MEDIUM_ERROR or ABORTED_COMMAND.
I think MEDIUM_ERROR probably would not come up for the cases we are
talking about though.

I don't think we want to always retry DID_TIME_OUT though. The funny
thing is that I think Martin just wanted to retry one specific case
for that error. We had to do the scsi_check_passthrough patches so
we could retry just for scsi_probe_lun.
