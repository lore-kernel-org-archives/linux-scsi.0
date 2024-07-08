Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C1A224F2
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 20:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720471567; cv=fail; b=i8G0rkc8O5uBcKzmOzxK/VHl+W3qyVhzgmBeXB9ayZIzQhsoOTH/EfLVWYsahjdbWwFscmVCvGI754rFWUB0C1Tn0iNeo6s4vyrE63juXq7//ZwQwK2IMWHcPely9EVi7RH8RdgTKDqhmhYYAJYJ+NyMVzncCunqVOh4eA8ZkLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720471567; c=relaxed/simple;
	bh=6kPFnKyqbj7u/hUbqlrDas6npNSvGk84osrTga8LPlc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iIO82zNpCILOTmUIAe9BiHIc5plUQAUwuHGTrryy1lNSVog7DAwi/h9WWMJO9VC8Kk5pRaU5odtH+AqRVsnvIPJME6WqUMIMiVmz2O+yeP3LDxZ5f4uu0Nl0S+zYe8IaQGCCIgPQsQhdLa8ItvWJpc3EB1xCGaPb5Qt47sxtShc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PpNaRQLp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oQmEHLPR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PpNaRQLp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oQmEHLPR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 468JfYmR015844;
	Mon, 8 Jul 2024 20:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=9eGrPWF1cDBZba6lj163F8lbmo5Cg88+vQETSsA23n0=; b=
	PpNaRQLpCM6Vv0ewNms03PtFrfPcf8P/ObD8OiNPS1i2ZJSwbeeoWOpcjxcrR5W4
	aS5YFdw5mTPeiFfbudswu2xQAXl4NI2XDsddsll0vzekoXfdVfN5CzTZVhTzPmQI
	h/7Gda3tlfCLOmOAMg8lSEHYzBlNc1jrJ9YvPNht8T2XyH9pjLiUM9LjhPjxbREq
	Ai3uut/FWN5DWYaiDJWMRYQ4GaOpGdWgdDu0aAm4Fm5Ds+r2b7q6UZ14uz1nHJwC
	evU/dZhA+0kVFUDCCr8OsYiet4gHBcFKaBmork+N9ekHhQ6f+inqtvc4e+93ELyL
	oi+ZFm+Qej+QRQ/zbhIxPg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky3mg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jul 2024 20:45:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 468KUtWM007583;
	Mon, 8 Jul 2024 20:45:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tu271s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jul 2024 20:45:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkB6HajDUGWM4FmzY8hMkNKFJgKJIJEP4WNy4x3OHTl5V6GJNwKNID+UkqS1IMoiWfcWf9+J0IY2jlX/oCfbTukXoeB2MLT6xnp5LefDOBy1MiFHCE80/rJNfjv929RoszRaQB4F3AtwC+koGxG/oXXq/JClWq3jGJVgaN3qvFMZmFUoY/dnvkkCMbgkSqN6IZfoQebKYldQ2bZqbHVMhMKq1B0dnFZAE+yhT6QdpOUQLDZetVsP0I0q0K41XVMq3PE5O3hacpnlC//J9Ri6e7tVFcVtKjPSF9IZA0qN+XY0PTHVakHusgrLu0jh5M+bAlmCJePDsoHv7fAMyXALxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eGrPWF1cDBZba6lj163F8lbmo5Cg88+vQETSsA23n0=;
 b=Uy/vcxpFLMlfuPkDDy4aOZYWXxfvObVIE5kTT4iuyR3Jvg4FceEOO7ioy/jCrATp8Cpir8FZEYwF5KqME1GIDEwbP8fGJo8JH0t2w5/l78fML4yThmDylVYlnaKNXDOdvwbm2mUz/Ehlg28VeH+vBZ4OH11oDUdJHfnRgQL/N7zJWBpQ/2RSV/hptasxwrf4YPtFlXV1u34Wxe1BfUB64geDCF39G/aF4TJ/5yEDb+n3M5n4QSz5Ef4iwQ5L6cg5YVl4d4kCfYkKbW1zSVYL47QxAdFTIe8TXNAykl7eDpHsVrLT4/vs7YLwOkNZT/gYyLJvLKfwsKmuNakgkFLqYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eGrPWF1cDBZba6lj163F8lbmo5Cg88+vQETSsA23n0=;
 b=oQmEHLPRZGJKUneqaXrW37OKjfunLPkeJAf3LN6+hWlHjB4CJJwOKMB+LjcsKpZB3qbhtq3C03IrH0LXm+DA2n8prGDwAMCML0oVN4fbh52TkJ6D42+Qlmn4HNO/VM5u4iV9YqRVysjOhOUHqfGUpEmghkyN4KfemIriaASUo1c=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CO1PR10MB4452.namprd10.prod.outlook.com (2603:10b6:303:6e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Mon, 8 Jul
 2024 20:45:55 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 20:45:54 +0000
Message-ID: <5db7efa7-6249-45cf-a833-40f536f06253@oracle.com>
Date: Mon, 8 Jul 2024 13:45:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] qla2xxx: fix misc smatch warns
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240705055437.42434-1-njavali@marvell.com>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240705055437.42434-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::19) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CO1PR10MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: e101ffd4-b13c-4429-564a-08dc9f8ef663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?L05UTUIrWjY2TFFKNFhlMm1nT0JBSWt4ZUZyNm8vM1dyc2JEdHBpdU1RQXpk?=
 =?utf-8?B?YXdVZWljMGVKMnZ0WjhQeFlRN3JxZkhvVm15RG1WYVBvY3BSdXNFVUVKNjQ5?=
 =?utf-8?B?enB1LzZ3dEtBcW1CY2ZqQ1Z5SnFPQjc5VU5Eb2dpOTZrSHU1TnlMTkpNT3Av?=
 =?utf-8?B?OWdWU1FFTTA5Y3Q0akZpc0xKdzBsOTZMUUNjZ3EwL2JjeFI5eTJTMGJrYm8z?=
 =?utf-8?B?VTRKdVMvdFVKZGJvbTJHWFpGNm5EeHNwQXZMcXFQWVFTQ0VrUVNVUDNZOGtN?=
 =?utf-8?B?UGNMUElJV2I5TkgxT1RKWWt6WUVTc25FWXNUZHluWmdTTy9mK3lMd3hTR3dj?=
 =?utf-8?B?V3pwK3V2dVRoRG9wNGJSbzRNQWxFbExZdldQck9lODJxLy9EdVJoNlFxMnhV?=
 =?utf-8?B?Y1M2aEViZUYzZlJBdmQ2QURONllBOE0zZ3dDbk1qcFgrRmZTZzB1QmVaUEM5?=
 =?utf-8?B?Tk44bVdrWnVYR0lsNGlmMm83NEw3UTlOTGhsRlFGcWlyOTFvaDBaSkZCczha?=
 =?utf-8?B?amk4U1h6Y1JMdUJvM3AyZlVJVmJCMXhhKzM2cFIwUXVEazJCUFphZ1NscHdo?=
 =?utf-8?B?czFxS1hQOExaeUtaQXg3dkJMZ2NXdUNWMlRIaVdpdmlaQlhERk8xRElKSWhm?=
 =?utf-8?B?NnJBNUdaSzFzdmUxZ0x3MDZNNXV3MU12OWZ0MUFreE9RVXRVa1RyaXpabjc2?=
 =?utf-8?B?UXZzWlpYQ0h3YlpVMkNFU2NwcGV1OVdWNm1PbnRFdHN5YkViSEFrY0sxdERy?=
 =?utf-8?B?R09wKzFpZ2ZuMTJreU5Fb1JGN0tDeU9PZEJKZkpHaTVPOUNhTnJ0ZXF4UWp2?=
 =?utf-8?B?RnRNelBSVHE4WWtycUVwclVUQ05ZbkdkMXVCR1ptUmorSzlaWFZjU1kzaXhC?=
 =?utf-8?B?aFF6T1lLTlRMTW5Ma09NWEhtZXVkdjF3UDFUL3RQUnFTOGdBbnMydzFTWk1V?=
 =?utf-8?B?MHdJNmFkK1lvK2RJU3luSTh1OHF6S1g3K2hRb2pjNTgyRjFhS0l5RngvUDdm?=
 =?utf-8?B?b1pTM3V6MlhyRERIQVNEUVZHVnR6REFtNlQ0N3pNU3lYMzRvVHloSzBvVVM4?=
 =?utf-8?B?U01NREljUEsyenNsV09jL0YxUXJDamtrRlZ5dkF3UEplV3I5ZktPaEM1TVFT?=
 =?utf-8?B?N2VtZXd1cTVEMWhtWkZXYlZ1aHE0eHBlK1RoSExTMmN1Q1FjOUoxZ2Z0enVW?=
 =?utf-8?B?NHlzZTBIb1VjYTRNaU9obENCZVpJR1QwMXY4VXBKS2tveWxtSlpZNVBKcGxE?=
 =?utf-8?B?cVN5a3kxdjEwSFJ1WEhtQ3JyRGJ6T0pVRTFkNkxZdmpxcE9mZjZMdk5xTyta?=
 =?utf-8?B?M1VZMHptNlF4UW5NYjZMWjdiOE52QlRjSXA2V2M5U3ozR0tqQkRJVXl3ZWxV?=
 =?utf-8?B?N01KZmM3REwrM2F2WGFZcGt1TzNMSW5WRUlBNGFFajhJdUh6UnFzaEFYUVNq?=
 =?utf-8?B?RlM4NGN1VHJETC9KQmlDWERpdTd0d2VBaDlSdjBJTStCNG5pWjREVUxhTkJs?=
 =?utf-8?B?UGFHQklPSU9rWXZHT0xleHIrWnBnWnNqeVJRTlp6Z3JBQjJpVllRNUZKTDNX?=
 =?utf-8?B?Q3VNdkZBUm9oMVNTbngwRnQrRk04aDV4cE94UGpXSEIwOGhVbVJvdHRMMnNn?=
 =?utf-8?B?VUFSV0ZkUCt2NS9NVEZ5NXp6bjNYN2diSDBkYlU0eERYMFh1Y0FOc3BOcFRm?=
 =?utf-8?B?dEJRdTdZaVdLVUNYRHRWeTlXY0R5aVZHbzRzVEIvQVdqWUd2ZWl6UzhVcjdm?=
 =?utf-8?Q?Krhl0o1ulY9d6uJOdsUquN9UiDRlR4lJiU8H1Nh?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K0lqeW55UHh1NWhxL0JUa1YzZ1I3Q0lEelFnNVhxdldRUVAxeFVISHJEWWli?=
 =?utf-8?B?YjAvOTBVc2lOWU41MkFqeFB2emVJaFd4NVFiSXo3OHNMT3JxdmRJTGtFU0xy?=
 =?utf-8?B?TjlUeEFLbTBZbUUrM05qM3hDRlJvVnlxYnd1VjRGQ0VaT3Z2U0pkbTZGTVZk?=
 =?utf-8?B?WERYMStLRDdnUUc2NkRqZExyNHVVSlBCbEgwYlk0TkUyOVN1VGJscUI5Rmwz?=
 =?utf-8?B?OExUMGdrTjNZd3Y0WlN0d0J5dnNBelJVWHNBODBkcTVYdk9uQ2pmNTh4cWhQ?=
 =?utf-8?B?TzJlOEF3U0VJZGtNcFg2dTlsRlRkbWFFK21FWHhHN0tkK3F2dEg1b1J2TUh3?=
 =?utf-8?B?T2xVV2g0dytCMjBPTEFOakVjbHlHQnA1L2JiaGpMeklXVEc1ekxFRmI4akY3?=
 =?utf-8?B?SDl5d3o1bnNvYzIwS3AvdnJ4RzFPUnN3ZjlNMUk0TVNwRUNQbGxsaDg5WWJy?=
 =?utf-8?B?MXVCTVhGZVhadlIyUGVCUXdnalNqV3VrZWsrU3dtTHg5SFdua2w0QmQ5MEto?=
 =?utf-8?B?WGIyc1lwSjhZUjMyRDNPeFdlb1lYTnhIRkVsYkJzNkVjUlVrcFUwR3BSTXlu?=
 =?utf-8?B?NWxDQ0NlMXBOdXpsdjZGOUMvM1JHL1h5WmZmWlhod25MdEdpMEllTmsxN0hE?=
 =?utf-8?B?NlpYdlJvdzFuNUdOS25JZTZIUGxVdEl6a3dmUXU5Ky8rb0I4cVdxVmZuUENv?=
 =?utf-8?B?Q3c1akU5MmNYYmxxT1NvRlhFd216czQ2WmVhVHF6V3RENFlPVXgxZGdPLzZJ?=
 =?utf-8?B?blpGSVEvWnRpaW01Rk1sdjBCVlFjcDZRdllQMS9TYnNodmlhK2tIZ1NNRjdQ?=
 =?utf-8?B?ZVhmTnpkSnJiMzlKRUNMVXJzKzF2RVpOQ25IL3NwTTVvS3Y0bWJGc2dmbjNO?=
 =?utf-8?B?UDNIZC94dk1XY091WThmVERDZG9TQTJEei8zNWxaYmlmOGFPbUNheiswWEht?=
 =?utf-8?B?YzJ4ZHJYSFhPQlZZYnVPbUVoS2VraVc0eTZlazNkOVZJNHN3YWV5Zytza1V5?=
 =?utf-8?B?SjFMaFRzSEVLbzZGRzcxM05mUmd3cjJWNThmVkc2bU16QjNYMUkwdW1LQkhs?=
 =?utf-8?B?MjVMQmVLR0tocSt4K3VuVmJjRHhWOFFXTkpOMW9FVXpySEk1TzRVMGdFaDE2?=
 =?utf-8?B?Uyt3d0h6WGUzeWxNOVNFVFZwcUVxVHVDS2VKMDkwODBtMG5hekdMZUM2Z01n?=
 =?utf-8?B?bkw2UlR0RWo1a1lxVlMyR2JUbXpFRUJVVU9BSklBRGxCaUJGK0o3Wmw4U3J3?=
 =?utf-8?B?M1F4V2VBb2ZLNnRLNHprajN6TkswdGJMVmNWakdReUp5dVk5b05XdS9rY096?=
 =?utf-8?B?R0FYc1VQblY4ekJaWllZV3p3QWxuUjBKUUtrcTUxZEhEdXRab0NZbzhPVFZk?=
 =?utf-8?B?aU0rU0dwSWRXVFByY1VuTjJVWkNFL1laTlh3Rk9LeDFoanZJV3ZVa1VjL3do?=
 =?utf-8?B?cE50U3dKQUh4NUZPcHdzUlZnY2dneXZxd3pKQ1BhYm5qRURLUXVGTUdkbWpS?=
 =?utf-8?B?V09YcW5sZXh4dERGRHVWM2tBSm8xN2ZtL1ZOYTRQcStCeFNNYkpoZ1FQaGt5?=
 =?utf-8?B?NDRza2dQc1JqWU5DZ29TRDhPUDlKNDVFdk9CNGpldU01Z2RSYlpGa1dTSTRy?=
 =?utf-8?B?QkN1M3V6OTV6d2xkT1RXbGlROGRUOTFITWxUeGFsQmRFS3pRQUMzaGkycmtP?=
 =?utf-8?B?cUdWSE5oR1NCWkFDcE5rbDdQVUg5a0wzSUM3WEw2bWZjRXN1S0Y2WEVOMURw?=
 =?utf-8?B?Mm1Fc0Z5QXVkdlNOU0ZwcTRWSDJTZTRSY3JVQzBIaFdKalgzaDVjNUtnQ1FF?=
 =?utf-8?B?ZWxXMzVzcm54cmxDYlgxeTZvdFh0aXdOS0hBdC9EOVNCOVpoWFgwSlZranpY?=
 =?utf-8?B?MVpYZlFpOGhNSTN4S0FqYUd2VHZ3VFFPTU5PNStoL1BvZUh5TnNXTTdYOE1N?=
 =?utf-8?B?Sm9adTRiTVU3RVl3ajhKK2d4ZzYyNy9oYXZjQTNEN01zQm9ZdU5nOUNDbXR4?=
 =?utf-8?B?SHBzNWJCczdGNnRNRmdwMXlNbjdoRnMvSVhkeXNJZUYxOFVDNlByWnNHd2JZ?=
 =?utf-8?B?RE03dHFDRk4zWDgxNlJYVXh3VzNWUkVFSHBSVG9SVjh3KzNIZnRORUJmMyto?=
 =?utf-8?B?bzkxZlFwSlgvSVVLSXRMaGVSQ2pxVHdRbUFFWlhlZmlWQk9lMnNvTzZHcllU?=
 =?utf-8?Q?KspfsIwLDA0eZrqjrk8OR+A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ra/BUtfrxzDHB0GWaSdF+YFym2Ssc6LIwgFfIr9fXDpuwEfRIjBX7QW/2DOr3Y/vnY6ym9m2e5SM+vgUsTbVX4RaF+v8mNST6KVP5Yraz7hzYEzsiocyeQ6acpqjsIfG40s2/a0SaCrxRf440nelpj08xIf0Hl2Ph7MuuMdMBjO/1Kta+Va3qA5dM9vPHnT7BSZYR7J26C4Veudj8oGIWqY7GDMJvuSVahpqBrVI2IOAgrL+LymXH+6NMAIZ6qvn+ACqh3BmgY8qR5NmuU0WpLlFacA0oNd/b7b2O/wstsUEfQzM/x/mRbbfje9m7AUlt+xAz5Ckg+arZOYaZRFhR0lR+zDej+SO65CApjhqLNJqcS40W2w1TEJn8gQ3x9wKiJDFYZn9gSadwrAFz6r0rRcAnRZYZxkl5zthFa+HP1wX6naTrRD5RXrgpqnD8/Ofd7mBZeWrq3bv991sr/nkjolpDoXglQIWrxXOl7bwIPfl/jOJTywp3gtLWoCcaQ6WG1r2dw8R1m+VYEyZ7c3frv6n9/zVLX1aqL57hMmcz+7qoPm/3qrxgGs7foiZWEIzBEGnjhj3aToziYmq6PN7D+rehUdC5EDfl2rpLGoiio0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e101ffd4-b13c-4429-564a-08dc9f8ef663
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2024 20:45:54.8902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WDNuT3+mtuQ4f914tpGAMawRaBeoaeFQq69AT8Vs42ZhNJcFo1JF5x2FQj3/24BGNAhKRy5YLlbuFccb/oGaL2dULRKanK7RzBVzu761xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_11,2024-07-05_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407080153
X-Proofpoint-ORIG-GUID: URTHhshtSzYURgjRSKTdx2w_LGz7NPwg
X-Proofpoint-GUID: URTHhshtSzYURgjRSKTdx2w_LGz7NPwg

On 7/4/24 10:54 PM, Nilesh Javali wrote:
> Fix always true condition warn reported by kernel test robot,
> 
> smatch warnings:
> drivers/scsi/qla2xxx/qla_inline.h:645 val_is_in_range() warn: always true condition '(val <= 4294967295) => (0-u32max <= u32max)'
> 
> Fix missing error code warn reported by kernel test robot and
> other misc warnings,
> 
> smatch warnings:
> drivers/scsi/qla2xxx/qla_sup.c:3581 qla24xx_get_flash_version() warn: missing error code? 'ret'
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/oe-kbuild-all/202406210538.w875N70K-lkp@intel.com/
> Closes: https://lore.kernel.org/all/202406210815.rPDRDMBi-lkp@intel.com/
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_inline.h | 12 +-----------
>   drivers/scsi/qla2xxx/qla_sup.c    | 16 ++++++++--------
>   2 files changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 30e332806f86..ef4b3cc1cd77 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -634,17 +634,7 @@ static inline int qla_mapq_alloc_qp_cpu_map(struct qla_hw_data *ha)
>   
>   static inline bool val_is_in_range(u32 val, u32 start, u32 end)
>   {
> -	if (start < end) {
> -		if (val >= start && val <= end)
> -			return true;
> -		else
> -			return false;
> -	}
> -
> -	/* @end has wrapped */
> -	if (val >= start  && val <= 0xffffffffu)
> -		return true;
> -	if (val <= end)
> +	if (val >= start && val <= end)
>   		return true;
>   	else
>   		return false;
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
> index f0a1c5381075..6d16546e1729 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -3433,7 +3433,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   	struct active_regions active_regions = { };
>   
>   	if (IS_P3P_TYPE(ha))
> -		return ret;
> +		return QLA_SUCCESS;
>   
>   	if (!mbuf)
>   		return QLA_FUNCTION_FAILED;
> @@ -3457,7 +3457,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   		if (ret) {
>   			ql_log(ql_log_info, vha, 0x017d,
>   			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
> -			break;
> +			return QLA_FUNCTION_FAILED;
>   		}
>   
>   		bcode = mbuf + (pcihdr % 4);
> @@ -3465,8 +3465,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   			/* No signature */
>   			ql_log(ql_log_fatal, vha, 0x0059,
>   			    "No matching ROM signature.\n");
> -			ret = QLA_FUNCTION_FAILED;
> -			break;
> +			return QLA_FUNCTION_FAILED;
>   		}
>   
>   		/* Locate PCI data structure. */
> @@ -3476,7 +3475,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   		if (ret) {
>   			ql_log(ql_log_info, vha, 0x018e,
>   			    "Unable to read PCI Data Structure (%x).\n", ret);
> -			break;
> +			return QLA_FUNCTION_FAILED;
>   		}
>   
>   		bcode = mbuf + (pcihdr % 4);
> @@ -3487,8 +3486,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   			ql_log(ql_log_fatal, vha, 0x005a,
>   			    "PCI data struct not found pcir_adr=%x.\n", pcids);
>   			ql_dump_buffer(ql_dbg_init, vha, 0x0059, dcode, 32);
> -			ret = QLA_FUNCTION_FAILED;
> -			break;
> +			return QLA_FUNCTION_FAILED;
>   		}
>   
>   		/* Read version */
> @@ -3544,6 +3542,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   	if (ret) {
>   		ql_log(ql_log_info, vha, 0x019e,
>   		    "Unable to read FW version (%x).\n", ret);
> +		return ret;
>   	} else {
>   		if (qla24xx_risc_firmware_invalid(dcode)) {
>   			ql_log(ql_log_warn, vha, 0x005f,
> @@ -3573,12 +3572,13 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>   	if (ret) {
>   		ql_log(ql_log_info, vha, 0x019f,
>   		    "Unable to read Gold FW version (%x).\n", ret);
> +		return ret;
>   	} else {
>   		if (qla24xx_risc_firmware_invalid(dcode)) {
>   			ql_log(ql_log_warn, vha, 0x0056,
>   			    "Unrecognized golden fw at %#x.\n", faddr);
>   			ql_dump_buffer(ql_dbg_init, vha, 0x0056, dcode, 32);
> -			return ret;
> +			return QLA_FUNCTION_FAILED;
>   		}
>   
>   		for (i = 0; i < 4; i++)

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

