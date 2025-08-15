Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D023928E7
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 08:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755247371; cv=fail; b=SZnAlbo560asxfbCD7aBm1aWI11l2wyNuHM2jiWvyP33LTRF7ZuKXENTj9olXao56fDPP2N/2fuwHueiU2rc8AGBusBJpo/w6Igcj3Yj+dgLLhgAlNC6eWGURgGCah/XWnUvvxTta9NHePBu6hJFIaDDfMpbjx4A55hmdcSd5Cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755247371; c=relaxed/simple;
	bh=aCY1XQv6ej+OA+u/nM+Tdu8/rlmLJYUone3rkCe8n2I=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eG0CdVCSvLEGYKMGIsG34w76u9Fx9wBQmZAhlC9PGSoSMH/0jyZ/3c1VqFeakZUlDwBsgHXtJSo/AqFduP95ndRYQw3Ht982G7xK/I9t4LcuLatD0QTRvvnrO1YFxA0ETZW2VNkdGwjEpUhzTEW0Kn7YikLMI+A+mJGInP5r0Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d9337pmG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A9vaTPnr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d9337pmG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A9vaTPnr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F8g6SR028549;
	Fri, 15 Aug 2025 08:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U264dMIh0RagJehsixIRnoN1c1ZVJsZWAw4jRQOnFqI=; b=
	d9337pmG0Lpcwx6/0NGEOLCqVApKgelqPsMyE+4h7kHhUoc0MOh51YbBtHvDspwX
	QHcInAIEqmQ98otaU4g6RYgAiA3ScLqg1FGB4M+q6qN7SYorq9NrVNZ+UqBapk7i
	kcd0Lv/QMvIlkDwTMch1ZSgKyntvzSB6DJT7L2JATtPqsO3cFxUai3yq3soyyi44
	vkSq49ZueotBRoreMYFOfSH1l/bYb0z5yagCBBSRxOgDi2GrxwFfoxl11BMgm+s6
	nmWxJ7SqRfUMQUuokDEVLEYTXOkYoQ2YQqdW1/E42F9rjW0sSjKhsFDENT7KbVYt
	g4as5Onz4CQpJRsO1j7Vlw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4kn5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:42:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7RoVZ038531;
	Fri, 15 Aug 2025 08:42:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsmb5fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:42:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkDy6BVFa/GJLlvBo9lqL6gH0r6yPSHmjmTMnr2QB52gjjvGNyr0CwwNzQRHjAlr5wVsauPj028+Nj/HZ8311azeNPYutRwPVmXqjS0a4GlKnI/nmvBbVi2aPHWZNQNtZJCtdu+bs22ZLn2xAAuZtXxH2k9mmiCN4fhdQ5aH4CMtwhLI5oNjnM923JO3Y1bPToTHLWemi6VPzSe2DV4/3WjlsW+dANfSKtUoczNB2LIWJFJlMmiigjNvo0GUoISg1maQN0lA+5iE6uFZ0VpbvEEyTf5VqKg0l4MZALTCCNWjuuTv7lg6dLeEouIyE62DfHuaoa80/2lB8DH4Q/uTlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U264dMIh0RagJehsixIRnoN1c1ZVJsZWAw4jRQOnFqI=;
 b=uh3xDfQVc+kAvVBSiq7XCv8PW89EOR0eDwagCeuyvvBRXGTa9mi4+ctBJvlYwm1fCQ5CK+uoJmWMTfCI6Qj+JcW3t5i5k6Syjl+0q5FjSeAnAKpylhB6J39XoOt0XNniTxDzixm6bv2m5ktmQCokKtTU7DbCIODT+KwprM9yoxpuirU/RDIb6z2Hs5Tu0Bkgo86HaLesCITpJvrnCCCgI7hkCX7EKZ7opG003bSNer9QgAArpWuNZIPr7EYYvp5jyoTjoURaRz5JJTaAwickU3HhosydpNlHvNexnntqKh+4eetrc6PK0Z4FhZ52Lj9ynldc0JHelJhJBGR4zmFImA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U264dMIh0RagJehsixIRnoN1c1ZVJsZWAw4jRQOnFqI=;
 b=A9vaTPnrT0jj1n3RVKza8PUZXvRp376tNOTLxiwxYO2BOu1DkqZB6qj1mhtB06HxMQcWWDRejWayCvrOcBht7nQWw2AoCxHHFSYCtDGNDTwMQi95//HQK5aFRnKsGR6EQhaGnKdeFExJD2CCU8Hh01c5xDRDuLJqdaEFhGUwjPk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4364.namprd10.prod.outlook.com (2603:10b6:5:223::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Fri, 15 Aug
 2025 08:42:36 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 08:42:36 +0000
Message-ID: <ebaa25b9-9abc-4ab3-bba7-7a375334d4be@oracle.com>
Date: Fri, 15 Aug 2025 09:42:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] scsi: libsas: Add dev_parent_is_expander()
 helper
From: John Garry <john.g.garry@oracle.com>
To: Niklas Cassel <cassel@kernel.org>, Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-15-cassel@kernel.org>
 <0823c04c-4d52-4814-88e6-a594c19a6259@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <0823c04c-4d52-4814-88e6-a594c19a6259@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0405.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4364:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b491bb-b4bd-4dfd-c551-08dddbd7aefc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUU4ckFoaURwRXErVkJvbHplbmdtZHdsWCtwOHZSTmRuMXlJaWdWQW9qdmc0?=
 =?utf-8?B?cTFPM2JndDIrUHRtOGhzbElNd1pPZExTM292VkFvYzZIVjMzV2pmMzNCUFpX?=
 =?utf-8?B?NjVjL1RXTDVkejR4bEI4YkswdDZ5c29yTXZFbjl2YWpuUE55dUU5N1dCT0VT?=
 =?utf-8?B?ek8vcS96SldES09JSnZyMjQ1WDk3Y1BMeEt0bFVKRitodkgrUUJYMW9OQU45?=
 =?utf-8?B?UWEwdzBGVXFmdXZmMzF2T1RwVERrKzdQUXBpekVleGRtOXhjYXd5R1Q4c0Nl?=
 =?utf-8?B?NHRlUWRzaWZGYVB1RHZVK293SUwxVGNSRDBHREk2MWF4YWlpUUxwTnMzaHZT?=
 =?utf-8?B?eTh2dEphUklZNXNSakFEeDNMNDRsa2RLUURKU3VVMmlrTG5ZTHNNRDdHaEpR?=
 =?utf-8?B?TWUyc0pHYUdWRk81em5JN2VjNS9jRmdxb1JTaUtsSEdESGNIbFkwL3R6LzhC?=
 =?utf-8?B?a3psUXFjUVN4bGZWbmE5SE5LeCtvVExEVWdra0lIalNJYzJ6Sk1la2VKYVZX?=
 =?utf-8?B?ZHp0QmIzM0pGd2R1bUdHMnFGMUV2bzJ0NXZwVDI2SmwrWG9Eall6K01KRXl0?=
 =?utf-8?B?ZEhsUjhaQ1lRTkQrQWVsMFhGdTlEYWNmMG9UQlFJSk5RZ21ZbUc3Yy9TQ24x?=
 =?utf-8?B?WFNqWEhNQ2tDeWR4TVJZQjNnb3h2SzMxd1hsTGZqS2dUeFR1a0VqWXo4dlZD?=
 =?utf-8?B?OGMxRmtSVTVRNUw4VlhhK2Rmczh5VFd5Rko4UUFRZ3QvZjdDWG45QUFvamo4?=
 =?utf-8?B?c2ZnOExsa1hRSXE1MjFaKzZ1YUU1TXFqbHpmVkpGd1I0bngyYWkyVC9qM016?=
 =?utf-8?B?UEZWeE1DSDVmNW5oMXJwZ1NXQ2xwTmJwY1VpSDZBQVgyeDNiSGFTMDN1UWxQ?=
 =?utf-8?B?NFFPWEVNaGhTUUhYb3pyTmsvWWFVVXBPQmZONWFEK1REcThTWnVkbVV3T2ZP?=
 =?utf-8?B?b2tmUkNaV2lyRWh3VC90VnNnYy9CZmozcUladEtScWs3MjR2UHVmSXdkTThO?=
 =?utf-8?B?N1ZsM3hkeElwZWIrQjN5TzRlMTZMUlNHYVhyeDdLKzVWSkxHckwxVkRlVUV6?=
 =?utf-8?B?STVCaWZEVmZOejJGT1FreHh1Z08zSGZYR25qTGVubmwrTktkYWhMTC9CbU1I?=
 =?utf-8?B?UG8xQVFzYkFXV2ZDMVhOVTNWSFNNNlZiTGplTy9PbHlTL2V3TUJVREVzcUtp?=
 =?utf-8?B?TkZibnpTN0gyV2VGQTJGSW5tUTd1eTR6ZVJXdmVJbFVBeWdxQiswL05jWVdy?=
 =?utf-8?B?UUJteTBDS1l0VVhDaHpsV3I3TWkzQ1RsNy81cVRoQ0ViRnd3MEpOS1NsUDc2?=
 =?utf-8?B?dXFjVmsxbWgvcUV1bko5NFRRaHpDVUJNY1IvQ1dSWExoSHZLWEVjZjhNNHVl?=
 =?utf-8?B?WTNDcHNOSjZHaGJYY2ZrRmxQUXoxTFpmVElXUTIvbDR2Sk1Ib3dlVFBycVRR?=
 =?utf-8?B?bGtUTjB0RjVGU1FUSnJlM21Sck93S2R4WTJoQXJZUkExYzdvSDNCSk1CSGVZ?=
 =?utf-8?B?azBsQk9POHdXeldaTVloTkR6MHBMaEljSG5zOFlCUDVGUU4zYzNQanBCUXF4?=
 =?utf-8?B?ek5TQU1hNmVIZEVjV0g3dTFWdnhrSjBWL294STJIbHJFeXJVMnlEZGtNblJu?=
 =?utf-8?B?MDV4TEoyOXhabi9YMDllTnZ0cFRtRkp2Rkc0bUVZUjBaM0V6cWZML003MkJL?=
 =?utf-8?B?aTJkclYydHVnK3FCdWozYXc1MGJPNFJiQUNzVlUrT2NSdDUxMS9WOC9ULzEx?=
 =?utf-8?B?QmkxWCt6MWg2VTJIVkxMQWs4cCs4ek9nRFVmcExVd2VZZE0zWk1mbmtLYTFZ?=
 =?utf-8?B?ei9XQ0duWDEvS2ZZMUdwZ2dkTVVRQnRMRmtQRyt1b3ZIZHpzbGRsQXVzN1Zz?=
 =?utf-8?B?eERhKy9hb0owdzZGSWVCeE5XRjJMa2FuM05Bdm1RY3NpVmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUI5cXVLSFMyUkpSYWNlSzIzcCtOYkNiYzVRNG5XYXFLbnI3REZVemZvZVp1?=
 =?utf-8?B?YW43QTcyYkptZEUyVTZ4dzVYUHFHR1M1d2c0cEZNUkdTQ1NCVHVlUjdwOFBq?=
 =?utf-8?B?VUlTb2NyNEtmK2loSksxNGc2WndUTGZJeGZSL1hqYm00MUU3U0pLOUlGQkVX?=
 =?utf-8?B?Ny9zTk5GQVZOVUdPZlNRT3p1eHV3aXh3ZDB3SC9KNG1WcVhWRGYrTVpvYjNO?=
 =?utf-8?B?WEFlOHE5dlhiM0x1VGRpQ25sRTlLUmxBMW56bjVSTjhEeXZoRFFtSFprUWNn?=
 =?utf-8?B?U0h4bk1oaXlGWUZmYW03c29yREZjcGc3OHR0UTZKd3U4am9wOENndnc5OCtx?=
 =?utf-8?B?dEQzUTI3cHdqR2xjc3UvalJ5dWFQNTBkYXozWjVGYnVxb2VHUE1oTVZ6ZytR?=
 =?utf-8?B?L2IvS3VxMktXT3JDczNuMW01RDNJT3JSTm1DaU9OWGFsM1BUR0hla3Z5V0JJ?=
 =?utf-8?B?NjRPMy9hRWJEeVFoWExiQlJteVpPRWZkck5GR1dvVU1qZmlGZzdUMk5nSzBC?=
 =?utf-8?B?Uk9XTVJQWWExWVZHNThjZzZFV3NQZGwyTXBkWXBZTjBpMFhPb2FyOEQvUFNU?=
 =?utf-8?B?ZlFOY2tTV1NwbXRwMlV2WEhBTGEyaEJMNS9FOHQ1bDVib3hmZml3TnlvYjc2?=
 =?utf-8?B?dGc3WmxDVDVDRUV4M1lYRHh3OFpMMnNYM2NqZlVsQzY0Vk82NVlYL1FjYkJx?=
 =?utf-8?B?SjJ5UUNUMHJNVnBIeEJodFNiaC9tRHByVzdDdU9zRnQ2azhCaUNRZVQwamZk?=
 =?utf-8?B?UUJFT0thSThoR3ZnVGl1SElGcTU5L3YxY3lNUUhybnRpbnZ1QzdlQVZDaWNC?=
 =?utf-8?B?dzR1WnhxQnZBU1RnUTZqUFdlY0duUWVPRCtDU1lkd2U1YWtZTjlyY2FOUHlx?=
 =?utf-8?B?VmF6N2I4RHJwOXBsMERWWSszMXZyU0h4NWpMZXhDeFo3NVdrcWJsbjJjdHBk?=
 =?utf-8?B?emNDNnZSdGhTUGR2UlM5YnFuL3MrL1lscW9TbDhzMG9LWDk2UVdtRHRvbGVz?=
 =?utf-8?B?WjU2UVgzRWJXdUFJZW5iTEdOU1lZdFJpMHpoL3FaZHY3MFhNOFZMbFVDdVFl?=
 =?utf-8?B?ZXd1OTROaEtRUVphdEt2VHhQZk9ZN3l0N1NSd2t2L3FzK3kvd3kwMUcxemRu?=
 =?utf-8?B?REUzSnFKemM0enRsNGdyT2JoWXZmdms2ckZYKytoNkp6NVRrMnM5NUpoa2JG?=
 =?utf-8?B?cUI5b2VvK1NhY2xvVzRwUEJadC9hdVQ2cnRnMUZ5UGI2NW1HMVo5U3c4ZmhV?=
 =?utf-8?B?T0FEbW5jWmpxV1NzZDZ0TThvVkIySytPcHRWb2E4QzB6THcxWWo3WnRlUDVE?=
 =?utf-8?B?NFQ2SWYyRXNsNytCVjUrZk90bGt1aU84V3BwOThTL2xTRGJydEtSZkxQQ0pN?=
 =?utf-8?B?L1lFczhkc2tvTlBmYU1MT09LVUtoZytYL1BoUUY1QVUwRGNLU1lVam1tTG5Y?=
 =?utf-8?B?L0RmTFR3TWZWN0ZoSzU4a0VsS3hNZUVCVE1ZbnR3eTNmZzFrQ1F4aWJMQkZC?=
 =?utf-8?B?ZGx1Y1Iwd21GSXg3c1dsc1FkZFk2bkNkeVRXOHowRG9aMDNrQzMycTlMTkdt?=
 =?utf-8?B?WWdwb3YzR1EvbmpuN0xJSEhKWWQwcEQyTUhpcVR6ekJXemFkSVk1b1AzeWFw?=
 =?utf-8?B?NmxtWlNCMktMUHVyQXRkRVZjdVErZkZXMWJaYkgvYjJHMlhXaHpaM1BWcUdP?=
 =?utf-8?B?OWg2SjlpaGg5RlN5c2ErdWM3Tkc1UkxxLzArK3o1UzF5UWY2c0pxbE1Ld2xa?=
 =?utf-8?B?RjNXd3BVNFd3TGhuRCswdnJRbXB1SVFpN0lOMHMwUi9CNXNmSDNoN0p0NzJu?=
 =?utf-8?B?NTNtY2FQd0dNN2xPbDNkZmw5bVFMMnp4KzloZkt1WkRrcXpyWHduZUgxSjFj?=
 =?utf-8?B?cnpNME1tN2RSaXhHSXNCZUdrNWcvU0k5UWZXU1VFYnlpQUY4cEY0Z2diT3cx?=
 =?utf-8?B?OXhOOXBydFBPZmVWZFlCZitTd1dRNjNQd3lwTUx0VzF0cXRFUHZyM2RrcGd3?=
 =?utf-8?B?NGc4TktxaE5OSy9YcUwxS1gySHVlbS9Vc1d1TmIvb0tyNmhpakRLMlc4UkZB?=
 =?utf-8?B?VXZCenI2ajhkcDVzdG9QaVFHbGdad1UwcDZkMkVvOXN6NnJMTElUKzBvb3lu?=
 =?utf-8?Q?mveqOYKWrk+Aymsnqm6KXiIDY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DZmcXIq/u+1vAOcNZgoDf6GNblTgnO4ixDhvs3+eLR/mY4Inpj0/rVKJgAkOUlZpOaJlcBxjWKTn27+S/W7FOAt6jEEw4+zrXmWEeuoZIUAL6kYa/arcQnub1qhV+a/es/533lHo1xsKdQpLiAImJMWsAf6ahIrgoKPYb4YR+M/cPsjFX+5vbR1CJMcq6YmNg5Rk7+rojcPk95cXISRJHqMYMeXCtJcQNkFBAZgbygK42CYecQwf4VhIDcmgsPXJzFdnPe03A7SzrSj/Xg4XLdzLqzk/H/I/g+22I/qvSJv+fnjQmoUDSPx+ajcCyOemauhYGvcGCU2Dxn56BSJA12I4rHifp2TeOsLLOh8gLDscdK/9DDKLx6Dd+STq7GCHIIDBcAUZtnUwzJcsvxl9L2E4jyU/peOizHa+5arfomcsVM479NmFBOn9TR3tuHPtUWoldyM3pTbPn3sN8zgNuDjWGEmOwU929atMqR3Lp6TeDT/XQtDVXZuVlElib5T8ALJIF8E187jObh3qBJ3QUsmFLqQOF70wilGcEQWVKvEdcW2ejf3T36Ih8514vva7HtS4aXoVd8+l9lJZ0hHhU+Bmijio1jYB3BzZR5SZPqY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b491bb-b4bd-4dfd-c551-08dddbd7aefc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 08:42:35.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hRLcIh3Fg7jPFBkZtyVwPq11r/JP6wOBsxs3skjeS1wmmaqOI+O3gBrkU71IBg9cMQ3CPnr7vL0HVKj3iB1bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4364
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA2OSBTYWx0ZWRfX50YUFqlp0ob8
 dyLKK7FuLmk8e8Kb+65oBZ6ZbkPuasQO5hBHySf441jn21aO7KOr8nPtEfR37jmYvhmpcDLhNkM
 TQGgZoXWoyR/q0ulsOlkHfvkkP7LbClGzSvAdFxUtOOnOBb2ag0Wuj7wzz35oa26zHi391S/uPQ
 jpZq9ok3YK73UEwcMKrQwtWv5or+E218XH7j1i8UJuKsfM4Ih7lE0C1bUJewVBAzsSEul8SbwB1
 DDwS/v8KGE9k4mtR0kkHEch7+nDC/AySntUAfmvTbUFKB1HfK4aQxiBC0b4HKw9gM2NcVOJqD+z
 8WV8a/mfS2CRQ1s4rI3CeVF81g8eXQra8las+CewbCCYLT1OSUq5psTC2YKY4x1sm3KWfhsLe3f
 odBjeQRSdzQA+r5bYkQQmOTb2FarCH6x3uK0iACmb9vtmGO6GioM5PkOglXayNLA19g6v4LL
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689ef300 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=sjWgeNWvyq41yob2dBUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: UMS94nJI1dbdC9uXXTjHutTjWLAiDr3L
X-Proofpoint-ORIG-GUID: UMS94nJI1dbdC9uXXTjHutTjWLAiDr3L

On 15/08/2025 08:07, John Garry wrote:
> On 14/08/2025 18:32, Niklas Cassel wrote:
>> Many libsas drivers check if the parent of the device is an expander.
>> Create a helper that the libsas drivers will use in follow up commits.
>>
>> Suggested-by: Damien Le Moal<dlemoal@kernel.org>
>> Signed-off-by: Niklas Cassel<cassel@kernel.org>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 

BTW, I was going to suggest to make dev_is_expander() to accept a 
domain_device * (like dev_parent_is_expander()). That would make the 
code more concise. However there are a couple of callsites which pass 
phy->attached_dev_type, and not dev->dev_type.
