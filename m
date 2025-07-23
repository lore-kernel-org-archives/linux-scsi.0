Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9804F1E32B7
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753257843; cv=fail; b=okfMDGPvnptozgsfmtTKR5XrVv9kF4qMDpPI4XJGmH2OXvkG+TjaX/zJvlz4tZTmBH6+V80xuz1kwn6g7YWJM9lmj4/Qul+/qThQ7KAp96uZOaVL9FSeBKrIcYp+4S+LolqjvFg+DVA3K6kPmJ76A3mJyfVeB8CD+1R1azD/4v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753257843; c=relaxed/simple;
	bh=FgjN9nMqtqCRP99urCGYMYmEiPWxAHZvuZY4cLa9QvM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ydo0f59Ib759Fqip02OFk+wmjeKq05W7c9gD5+Td06MjsVKcfLTt8DVIxr8vtu72PdiObsWCbZy46mrACIuem2Gme6nYAfzaw9XKmhNSf8K7uiVrj9dsDolIjuy0zlkcoVANk4hqvBxvih6hxI/Jha9eI03AgXj6LEK9Ng1vBPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MrOeGGnr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E0Pmn80h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MrOeGGnr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E0Pmn80h"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMQjJQ032589;
	Wed, 23 Jul 2025 08:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ynW0KoubQDUEb1d7alFTsv48rHjIb+6+1Vvcr0Z8Z6I=; b=
	MrOeGGnrm/TNeUxmXHaXo+u1A9IXYsMfEfzdh4eatJnnsJ+kbUTZtFOI7Hv83smr
	xFiKBGsmikIoOeIfaSm6rvdAKvKENE9yJj+mRfqPyzDrBhG3FD2Ccvb5jcx+IR7A
	Sir2/IuZe34qv6KHqdaumf4TGP+w8AB/IIxLGUoyZcEPsU/QQ+fmc5Apd+Y9Df+W
	rmOGIL58x2pvMVy5ITcTY8klH47O5wpcHv/rFN8osPX1noC9RAwayiqRI5tqQtD0
	f+jTh3rx813dvgryLxrxWa9c9fG9+B5onKKvGMeZmBv8GH0UP+zlvyC9e0pdBJ7j
	oguKxqbXhkSHTpM/Yd/9Lw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805tx7255-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 08:03:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N63sh7031476;
	Wed, 23 Jul 2025 08:03:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tgkq7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 08:03:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S70MWQRaKEuVFsq8HRB7WceOK48yom3T1lGbQUtA0zboUZgy080zHbPTWXbw2K1o+2ggCoi4dwOo5Fvg16vWOe1n0wWBeEmuW2Q9OPHnpxzbIolI9XjQk12zPb0GwfjwhOpMkC9FjkLaO6c/pG/EKpNRMlxNbvkM242EL+SFO+/jsLvxLLcGgRGz0smYXZfl5hwu+UM0BRaBNS6z1U2ThMuNP7wrGSJTF4IUalC+m3wEF8U1uOTMNIQP130rAfThFOqg166UHU0NVqVtnxT48FSsUnjH3hgHW3P0/qFVAQcL1zZUv/fGAWiWPzQGxACqqCRciH+KaLYqX5Ttd0dghg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynW0KoubQDUEb1d7alFTsv48rHjIb+6+1Vvcr0Z8Z6I=;
 b=hN1g4U5yZ/K19jdLvsMu1lOQHFl+7Y3+A+NAtpq7Izg9C8kISMXzOzuWyp4s87avPAMdlQ/M5NHuF0x5r9A5/ZGefr1D4mh/fEUJqLSV+wFQw+tl4qzQP2xGG/UMT+FpTCXM0ilqHRGpCG6uuLTQXcQ/REckRjzdTbVpvcdSn5C789lI6kgyWQ/+J18rO9r05AgCv1xasuMNLE3BAbemcrs+dMXKy1/gugso0zQNSyAPbH+SzU9ECK9JKMptGI5gEjtvqnfJ+xtvklGs+7rBgnGKMvQLGejaLOKyRs7dCPUaeT+3uNSCbgZ4YbJqnUvQyB5787mjYZ5yFIClQWPJ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynW0KoubQDUEb1d7alFTsv48rHjIb+6+1Vvcr0Z8Z6I=;
 b=E0Pmn80h9a0nBUCgWMgImZDomI/ode3QQJPY0C7dkWQrRZLgcRgQnFR9iW6wQIKKrwZ0z7Nte0N5+Ep/q6Gz3mq1kCXw8cIQl5MnESnHKhrzuNMk7U+NoAnMvhEMc7l45Q54tMOUDjWxTVA7sKhO5yg9FsFZpKHT+a43OwAQmZo=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DS0PR10MB8055.namprd10.prod.outlook.com (2603:10b6:8:1fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 23 Jul
 2025 08:03:54 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 08:03:54 +0000
Message-ID: <a5d6a872-2763-4678-a22e-28052efcda85@oracle.com>
Date: Wed, 23 Jul 2025 09:03:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: libsas: Use a bool for sas_deform_port() second
 argument
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-5-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250723053903.49413-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0134.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::39) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|DS0PR10MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: 773f6458-e88a-41c4-8bd0-08ddc9bf77bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0orRWdlSGZ1TXZSVHNpQkNDZlFTNEtMV01mVlVnTDF5ZGhrZ21zaG5WQXhr?=
 =?utf-8?B?R1FwWXNIQ1lUL0ViTGFiS1l4emo1NzFCRE91ZWV0R1RCdG9HbEpoVG11TVJl?=
 =?utf-8?B?NUpscFNyMXB5RDJRcEpvNG1ZSUJMeEoyeVRwZmZaMGhaU1dQQnMvRFRmdW41?=
 =?utf-8?B?bVJqc0F5OGszN0hQU2E5QmVQWGVyREg5MHRnR3ZETzdnTGlpN3FUc0tIK0Zo?=
 =?utf-8?B?d1c1YjBWZXp5cC8rZ1o2ZGdEWE1YYjVzYTF6M0Zobm52WnF6TThZWUpoTmlE?=
 =?utf-8?B?N2phTXlLamxtY2E0bDdzNEZ0TWQyZHUvN25rRHJIVFVOL3VBczdZNWJDZjJ0?=
 =?utf-8?B?OVRqdlZpTzEzUXdiNmVSMnFWK1hNYXVoLzhSYXp6dDJidUFDbEFHcGNJTThH?=
 =?utf-8?B?cnJGM2FOWWNnS1U3dEtOdTJQcUhFNytsU1lqbnpldFU3ZW1KNDJtR2JDQkpE?=
 =?utf-8?B?UW1xTmtURmJLWUMrN1h2aENFYUJOSlcxWjU2RVd5SElvZTZTOFVFdlB5ckN2?=
 =?utf-8?B?b2lQNkJaOEFRcDJ4K0hWYWVzcGVkc1pObjNrOWRDS0ozb3FtQUNwMElaVHAr?=
 =?utf-8?B?THRUQXJTYlo2ZGg1MUgxMVppc2U0dW5lSUpLV29YN2VaYnJjOElDVnAyYjVS?=
 =?utf-8?B?RGZwQTJPeGtvYU45OHgzZEF4SmEzYmorSVdOMlV1K1N6RU1PdkViaDdpMmNC?=
 =?utf-8?B?c2k0Qi96YW1YWWRDVzg2MGdPcTRSTDI2SURCd3RScUVOTXVHT0l4Z2dtbFJX?=
 =?utf-8?B?RW1sYzlUNHd2eHVaYW1uelRsRlJ0V2pMSUR3Y0htVnE5OW1sMlM0NUM4RDBk?=
 =?utf-8?B?NEU3TVNmNDZwVHd1ZE14ajdpdEZTWGJkZUhYbE1XV0NXOXF5bmVpb1V5SDlK?=
 =?utf-8?B?dFVZWiszcndneEpQdWttQUZmMjMrNUhweXVQWmJIZ090V0pTR1h3QldDaXk5?=
 =?utf-8?B?TXZ5S1Y4cSt3MmxObklSOVU4R2NUQW53bjdUSUVYbGVCL3d2bVplUzU3TTFy?=
 =?utf-8?B?RHU2Y1MyQnVqZkIxTGpydkJOU3ZWSDVNWFR2eFp4YUdNcFdsTHp2QnlNSHdX?=
 =?utf-8?B?QjF6ZjBOWG1JWGI3UWxjc1pTWFNDRTh3cnFlRnZML08xYnhORVFYbW95cVNk?=
 =?utf-8?B?b21wNHJUd2JPMzhkSlNWVW5WcS9pcWdSMGxlNmxRNmhINkhkbDQ1OC9lalBy?=
 =?utf-8?B?UFc1WmxPNVFxWnZnbnQ2Zi9jYlAwQm1YNnBXejhHUSt4bnRXbU9ISTZZWEhR?=
 =?utf-8?B?OG1sZm5yZTREYVF0c3dMeURDZU0xMFhkSnVPaHg4WjRveTM0SHVjOFFhSG1R?=
 =?utf-8?B?ZmxDdkJTM1hnUzNaQW8xczN0eWFTemNwTENLOGkxZGI2N0dvaERrYXRJb0Qw?=
 =?utf-8?B?UGVUeWR6M0NTZDhqbTZoeEFTUE1lRC95OWpTL1J5VXlZQ0VUNE1DQnllMllZ?=
 =?utf-8?B?SFoxTDRpVmhUcWFqaGVYWE9MMmc4U2x5ZENZczlWVFNOd0NZUzlFb1dOd2pO?=
 =?utf-8?B?QkxKRnV2RFdXbzBLejVrODZsN2xYdmJtdVpXWGlZK0N1TmNXZHNaQXFVUzRT?=
 =?utf-8?B?L01kdDhHWFI1bXhqNHNhY0lwSlBrcitKZWI2SEw3QzBNVm9DRkx5U3doZmJJ?=
 =?utf-8?B?ZWtNM1ZZeXJBRThXQm5UK1dvTnNyRXhpR0JTQlpuVTh0M04yNnc1M1hla09J?=
 =?utf-8?B?c01WclhObE5PYmlqQnM2dHlvbVpjNDBTZGh0OHMxOVQ1WXhIZ2ljeFpWbVEr?=
 =?utf-8?B?Z3hYTUwrTVBOVG9OVUk4K0x2RzNwZmQ1MFVJbkNyQVh0OTU4ZGt2NklzVUNG?=
 =?utf-8?B?VEpBcStkQlB6RHFXZ3FQRnBqTldOcEF6amE4Y2huUURsT3QvMW1ZbkVtKzFu?=
 =?utf-8?B?QjkyOVBQS2UwYUhtQnRvQU9JdW5ielFwZlg3SU1HTURXVWllTmQ5Sk9iMDNj?=
 =?utf-8?Q?uQyvUexVY58=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akwvL1ZnUXlGSXFnVGtsRWxlelNQaUs5Ykg5SmFwMmFPZWdvSDFnbWdtSXBO?=
 =?utf-8?B?NmlwRGdDNW9XaXhWeXRMQnNRNDlnTHFWQ0JrTEgvV2lXQTI0ZER2UHhuSXMv?=
 =?utf-8?B?cXFNSkpJaGloVnNCeUJXUTFFVk5jekNPQ3dQQ2I1Z0R0cW16WStnQzRiZ2dL?=
 =?utf-8?B?S2dWNldYdWVyOGhHTnFUeks5TFBNMnJ6MlVSMEdFVk84ME9YRzB5dFkrVHZ0?=
 =?utf-8?B?Szc3b3h5SFlmTURzekg2bkhiQXg3bHlNVFU0aEZKWFFHRUM0Z1YyUG9mUURj?=
 =?utf-8?B?NFRtbmw4MFZpL0Nxd0I4Zi9JdTVyY2x6WVRPR0dUNzBUNWtpemhwV0xxcSsy?=
 =?utf-8?B?ZDZkd1pxV1RxVkNjZjhaNFp4Ym1EK2wxMGRqZVpxbVRmTllpZFQ1YzRPNjBM?=
 =?utf-8?B?WFE1MXpBZVhPYS90OURMb3hxK2xoVEovTVJZeVY4RnJZbkFSQXZGQUwyMTFk?=
 =?utf-8?B?Q2p6UVJCTEQxdXBlclNteXcyc3B2bDFZZVl3aFowcktTa1lMZmZ1bCtScmQw?=
 =?utf-8?B?cS91RWs4MWZBdk9pMDhmQm5FRUNYcEJUQndvWmVmalBWNHJNdzJjWUJXWHNr?=
 =?utf-8?B?bTVjRXFMa2IyamdJSWdaTUtNdCtocFJodU9nd0JZaXM4RUluNXpiU0Y4VjZz?=
 =?utf-8?B?Q0Q4L1YrZWkrN2U3U09pUHRjSXA0emY4Z2dMU0dxd0l1bndiOGlmeXpWY01w?=
 =?utf-8?B?dkN6Yy9zWHN6aXJNWmtqcmtMU1YvbFcycm4yVk5CUndkNE9nNWxEUDlkSmph?=
 =?utf-8?B?Ryt0dHNUNzFSRlBFbDZoTU1CbFd0UzVuK2owMTVHL2x5YUxSNysvVzhDNFF4?=
 =?utf-8?B?UjB3UGhnN3V6TURVVFFGdFVpUjBwbmtiLzViY2RYUmR0K3hrVmwraVp5ODJ5?=
 =?utf-8?B?L0x6UStYRkNJS3JEZ2dabEU1RkJsRDl4blRQT3dBL0VyWC9ibGIxamt1YlNo?=
 =?utf-8?B?UVlPMG11Sy9qUE42VlJsbGg2RzRaWFl6NDF2WFVDTnRqcGRmQTNMVWh6VWoy?=
 =?utf-8?B?Y09OSEtaWjc2eGxGNXd4Q21hTTd3NXJnRXRJc1hQd3BvamY4aDhhZVRpZW0w?=
 =?utf-8?B?K0ZwRHA3N0c0d0RKdnNGd2FybFpaMmc2Qm5kRGRZTHltRUQ4NzNNUmZ4N1F3?=
 =?utf-8?B?cTBaM0ZOYUt0QUVNNUNFNXB6aXN5aEdwN1JTN3F2Zzl3bGRZWVh1QjhjSGNm?=
 =?utf-8?B?MXhtMUw5R3F0ZFhEKzVVWEpJLzhoajg3N3VPazd1ZTVMVllvNHBOU1MvcmV1?=
 =?utf-8?B?aGZocnZqeUZQT1BsMGtnb2YydlZpaHhERnRPcytuM3phU2FNcXF6a0pWS2hi?=
 =?utf-8?B?bE9QVzlPZ1dJOGozaE1OdTVBZm9BbUFxVG4yNjFuMUt0VjUxM0hCeHhOSkVp?=
 =?utf-8?B?Kzlxb2NWc0o2S2pzd3JrZjNGdkRhVHIvUmxLVENZeVp2OUlwOGFEc1hyOGV1?=
 =?utf-8?B?TVdDaklwOEpGbXB3ak56dTZQWTZIUmtuZUhjYzdINHB5a2J4L1F6WXBBUGM0?=
 =?utf-8?B?cHVKeFl0TXB6NCtaK3lsMzN2VTdWSTllWm5ZSTV0VkNuK05jL0lNU0NjY0h1?=
 =?utf-8?B?WlJZVDY2N3ZHRUU0eG1aSHQrLzc1NC9TVElURGV2N3FNdlJPSGg2NjJaOE5a?=
 =?utf-8?B?anBXb0VldTltdm10N0kwRDRtVU9jTDJ3Zlc5Q01HcTFlbEFxZEs4V0pHWmZ5?=
 =?utf-8?B?ZEdRVTRMQUdVVHZmb2Q4a2plMHZCNDNXTmxsbFBPUGRyY1B4ZGIrenR1aGQ4?=
 =?utf-8?B?TCs3UWtRVmZQenpjVGNvUmdHa3pBckp0c21HTTFSM0ZxcWhRWDFQajJZVEFJ?=
 =?utf-8?B?WlRvT3E2UHoxTmJDMnBYMnJueHREQWZsSE9KT1psUEYzTmJhUTAwN01CMHZp?=
 =?utf-8?B?NGJVZ3RpUjAxZkNudjNVRFo3QWprU1dKK08yaEt4enpZOWRsZEVpbGtCelBH?=
 =?utf-8?B?R2orVG9jVldkQUpqOXh6dmhmQjhSb2h5MHpGYXoxV2RCUjd2WitLd285Q0x4?=
 =?utf-8?B?LzhLRFQ0Z3VFcWk2UEpFSVA2amN6bGVvcjhVN1hRc3lYS0ZDMGZmcHMxNGxS?=
 =?utf-8?B?TXcvd1VJNEhGRzlMa2JiOXhCSVZYTkYxMEdpRjVFU09wV21Bc254Q0xmMFdv?=
 =?utf-8?B?clVRcFFXOEJ5aUcvRVpmWFdKZkJlQ1h1R2dNLzU3cTg3UFlXSHVoVndDb3JS?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fgx3FuyuV3eUWUX2mTZGCLbpdntq/G8tvDotetd7dB+aB8AloiHUYkO9V+Rqr/Nh2flSvjhT4G9Nj5Cl843JmSqXos/jr43ZeqmlpsXkr5lq8nU3JLTzC74Bq/nbG2sBnEC2Upp88xrmi+oZ01WeyRK7m3XGF1YQgr551hVKYWxO2FeJxCbA5N2x1oGXNQLznzTLVGCRFSdFtho3Cyy8etL/2FDYVCl6/Cb7XrwT7/rExqENLdMOh6EGXdnNINJ7CNitgmkEXIv8iMLmbnSoLCp22d4N6WdlNsjA6PgVeJI6KAFTrgf/v4w9ZWgKasZlGImJsOQtYz78qN9YRHYQQ+DinL8fdEixkr7JhSq8kUKAcJsicQ7cGaIh4/33H7oFoENaau/bPZIW9BLqN4Z9aY1bVvodU0vDkjmHR+hhnGyWdbr+pNhGK80UJuMA6io4FKi2T0wOCwU1MOjZRvQwA4lgKySF7nJWv9NJ1dupA8O+Egwv17XuIfstIwWRSLEo8BYG9jJlR3YxPWdpIQlTSZTlsoizMGen7EOR+A9BLwSCkrv7gwF5oGULrbrqCvLTKrJTkLCTodITDsHu4O4Vk1YErsZwRQ2fW0mmKQGEvNA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773f6458-e88a-41c4-8bd0-08ddc9bf77bc
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 08:03:54.5720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fO+T3gAEb9U2h+p/SDszVxuZEhc/7dnaHTNz4U2OoQ6hGo2hRaTb7kVF87ZAwym6jiZdVIvECkLYvYWp96TTrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA2NyBTYWx0ZWRfXy/Yty6VEYpuw
 z7FPslq1r2d/G3a1BYWetWTDnb1e75qRhD7JgZqg0+Cp016a+7qPFOo/aiASnTyFvpEu3HTr/ut
 x3ORYlN5QsoEf88ciCnVAzYvSSM5kMwkSzsVRt7ensSCUFzEOgyBqdMqN7BJXd7/lD2DqaPljVV
 8dOOMVKlYS1WZdWs4YSKJCBNyiThUBHYrnNBS17Gl4yVw6u4vgBdmYN2yYaCPFmfypqlOQkQaRV
 8ZtKIpzuXCKPOvZVjnVQYHThWf+5Zu1NHqVFLFz0ps3PtbtzbVCTKOtp+FdL9GWe3Xhp2srRfwf
 JuX9/EAAaF6oxnoVz93jyjJ+PTasO5/ARvKiTx6riSEd1lHtPQxrbK2ggdEwinLAHc78gdP7uaV
 KoNF/oYIhoTM+hpkhe6vvzBR/7TieqfiTorLz7aKswLQ6s2ri0aZ0lqA9vjT/CFdlhRmp1kb
X-Proofpoint-GUID: RW99RvOuagC0CYBaUAiXlXdZ3k_rYrM3
X-Authority-Analysis: v=2.4 cv=IsYecK/g c=1 sm=1 tr=0 ts=6880976e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=XtjqvbRUeySsjQc_0PkA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: RW99RvOuagC0CYBaUAiXlXdZ3k_rYrM3

On 23/07/2025 06:39, Damien Le Moal wrote:
> Change the type of the "gone" argument of sas_deform_port() from int to
> bool. Simliarly, to be consistent, do the same change to the function
> sas_unregister_domain_devices().
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
