Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9078E215F7A
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2025 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739785507; cv=fail; b=Od6SmlpGpEGnP+kNf/cxrvhxV3oUP/K/OCvJPFAitJMBgJlN/ZNlkwU/dBteNlVstw/bZfqFbkU5gUQDVN6oroQeGpGvE0+SDLtVDXVuhyZP5Y/SpJ5Yxjc4a366f9l9dc+9MIUtYzgMFpBbbD+fFBPJ9I8kILyUvnJ4fauziVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739785507; c=relaxed/simple;
	bh=Lf/eflOW5Qds3qbFfAZbdPm7arsy5XIqW9ykbzH+VFQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Df0g1UgkGnEqLSUDxSeDnNe+1Z4pWwj164K1qvjEuor7aP/mYDVnSZVxpEJqO0x1N9kAdJMDTEf3EwHv4G+wKQVbI3BsrttnL3U7sczjQ/TLud3yuhVjLCXbehExD6yziEjaL5nrtRYZ9kD5kXEVoWutPerbXExeR42hp/gVFWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M3gSqgc3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UuLkGhcR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3gSqgc3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UuLkGhcR"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51H6tVHL025378;
	Mon, 17 Feb 2025 09:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=QG6+d9tlqvh9FJUW2FO1zI751edzF14UsCCUvCZysAg=; b=
	M3gSqgc3sKOxPX7bv0eFQZQfieV2DrnLJI7hStp+mtpgFGPhx7fX5FOc3QTsKjYj
	xVVmTK2A4o+9J4ueBOumMet0ETCzJHn1BPhfwqyldx3pgwehsxus+jMS978m3rtT
	f7jtfLLpi1bppgvRTgKY49taI3JPrg1ckpOnGzyHdxOHz5wsJgtBYCsBi1i+a715
	IxCy7B8+O/TneorYQHY7zEvr3DrTvlgp7IWs0HXo9SlkvHJgbB61z4bmNsG4cvWG
	03+dyPcuTDqHeSySgzkFc+LJoDK4+OFwPSVYe+/5//JUFqYMo50uCOaC2RQI0ipX
	vu0RBvniVDEyqo5TvhyK9Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thh03vm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 09:44:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51H9V4tE034462;
	Mon, 17 Feb 2025 09:44:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44thc7q0jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 09:44:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yb1URHzsvuNb7f3XWgoIh9/sBqOYdXsBJHMjLgHPBfj6WyPUbVaZnQzpqTCWYAJEGzB4x1POFI9ejtm/OPL/DOBwOKe5Yfx21N1H2MhYO2p59vOq5OoLn3Oe3U/KJcbjcLVnmUmJ6NVBeZft+Ypyy00yjULPOhUtHHVlLD+okulSH4IrV9/aDdDRHAA0P2D6qroRfRTBuiLXJhZjMcoErNn8pWxtX7GaD4nCIL8benrgpv5Gh7QGDAqLswLJfzPOsz/nFnGUZuVbV+nPjDDwzw5aZ+0GS7yGO72+M+UPqR9cc3L8db8e5a13sj9p7+/YkziXGOfCWQUO139hasSODw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QG6+d9tlqvh9FJUW2FO1zI751edzF14UsCCUvCZysAg=;
 b=EM5C3jRps2ZrMVSHqgPATMphacaWz2iJBlkBK94ZWL6adbIsn4Rr3c67TTBCSGKWT3EQqfDzGoJGuO+pbbtuju1gNth/DbkQxbNUuwSi2h6bTagfe/8KnijxWF2znejR+Jzo9/LU47ngd6Ad0ziqZlbUetl3KL7kJjbFLHc/9koDmkSWtsKcCNQjnjLzZvE98/WWmIJwtPR78IDJmKSf1lxSSpwpOflgJ6TWt1aHVslXUsALHgPSvFmGxH7kP77WRJV4S+hGLPzpUnfaWVkwOHuC0MhRvcMmvN2TClBEujGldQV9tpsgtXyaavZHWa6Jw4WOkcIB5KoOoXPFG1oFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QG6+d9tlqvh9FJUW2FO1zI751edzF14UsCCUvCZysAg=;
 b=UuLkGhcRUWPo60dOxqw4QOwyBixuhEoVLt629yX0STJlFRaNHIk1sgPKXDy1NUDYjUXo3Rdh63oSpccIffBjyzPWWiZakl4Cj/0QfFo2390Fv+30C0wc6ZBtzh+nUs3F9XaKHqcrBt1Tm78SYNh3aLIRXhKfQZ9I+UBvrA3VngA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Mon, 17 Feb
 2025 09:44:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8445.013; Mon, 17 Feb 2025
 09:44:46 +0000
Message-ID: <4fe6b94e-41ae-48b4-aa9d-a0712a4ef16e@oracle.com>
Date: Mon, 17 Feb 2025 09:44:42 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry
 request
To: Ye Bin <yebin@huaweicloud.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: zhangxiaoxu5@huawei.com
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250217021628.2929248-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0132.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d16a39f-f333-4537-df06-08dd4f37b678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkRaeDlQYjJ6bFZzaHo3b1ZMTitQRmhKaENPQjZ2NkQ2ZWU1NUt4M3hlWUlN?=
 =?utf-8?B?S21vZnIyMGFSK0dLVWZlZVU4QWMyc0dXcUtpWXZKaXRpYlUzWmlHRCsvKzlK?=
 =?utf-8?B?andBak9mblVKYVJaUXFsbk1LOWZnK3RPR2Y1OFJrR0Y0UFR0OVBpd1FlVE5V?=
 =?utf-8?B?U3Y1OTNab1oyM3B1THBKbE1zaSt6NHRHWnNIdnM5bHJDcVZyS3EzVUhPc1lZ?=
 =?utf-8?B?UTVjVkFubXBWSjdodndQOHd3d002VU5wYjJaSDBKTGZTK1VJTmZqNjM5bk4r?=
 =?utf-8?B?TEEyOGRYQmkzNFNSelNuR2F5N2NOdXRZTUozRW41NE1zTVRCYXdBT01PQUlO?=
 =?utf-8?B?QVY0Qi9RUlJkYlUxVXdBWk03YjRPcjhIc0s3MFlrelZwZlFpTkREeWNnLzIy?=
 =?utf-8?B?NE1tbUlveityaDI2VDZIVkowUTcyRGVmSmZhY2RpYjNoY1NoM0kwUGE3N2RF?=
 =?utf-8?B?ZzlwWmcxTUV5OFYyR0d5RUJBdTNZVm1ZVVArNFRXYTROOWcwK2NhTEkrL2JR?=
 =?utf-8?B?SGgveEF3WUI4YTRxcjFpZEVuY3FDZ3NxTXBCV1lXcVlBSUhXU0ZGQ0xxcG44?=
 =?utf-8?B?WWJkRGY0REE4dzVuNEc2VzY5NG9hSlp4SGdnUWNmVHBhRERVNUQwTGhYRXQ3?=
 =?utf-8?B?K2xBOVVGV0s3TGl1WVBhbFlnWitHaGduelgwaGt1bXY2RUNUSjd0eHVHa0Rj?=
 =?utf-8?B?OVBXV0RLNmRjL0Nud1hpT3pOcmtBYjZpL1lDb3M0RFlNYmhrWnNxaWxicUhS?=
 =?utf-8?B?SVBKeVJOUlVVMlZLczZhc1JLalJJRGhmakJ2NU9VeThETmtoUGhrc25ZY3ZH?=
 =?utf-8?B?TEVuek83Z1Q5ZmVqcDNGQXdOV1hILzlmSExrTzNVUk50TEtISFVtbURQRlBr?=
 =?utf-8?B?QWphdzBnSHQ5ekx0WjFZSFdQa0dVdzNCam54YVc3dEpZc2tQMVFFeEJEWXFw?=
 =?utf-8?B?TDhWeXlGbUZyTHFyT0NjODQxR3Z4WUZQQmZ2L2xydGJPc3JiVGRFd01pVG0x?=
 =?utf-8?B?VitpdmRiMUpHN3lnMkl5U3NiRnZtSjRIcGtZeEVOaFJiQUJVUnA1UllNRksv?=
 =?utf-8?B?WGFyVU1rZU1LOWpWRFV2RmRXZytiMTgyODdmeCtHc2NJRXJ1Wk43Y1hRTkJu?=
 =?utf-8?B?SUE1ZjZrYTd5TjJZemgwRzU2STFiZFN0MmVHR1Ewbk11eHA2anc2MXRjYVFz?=
 =?utf-8?B?YlFSeWw0RWorVmxMd3kwVmtYb0VxWDRIMDVvalI2RS96RU9oZzh2RkIrY0FT?=
 =?utf-8?B?RDBWOXgxNy9JanJLbTVtK1NuUHVraXhvcGVJd3RaUjFISDF4VmYyUXVGRGpv?=
 =?utf-8?B?ZVlFd0c1cHdXenUwdmkwYU1HS0JkRG4wYkdYeWNOTnhMWDFzMndLN2ZqMFE2?=
 =?utf-8?B?TmNycHlqRUNrK2FZc01EaldJK3JEYitMNXcwM2JrWHVPNzlWM0tic1gxSDRW?=
 =?utf-8?B?dWdvMEF6V3VKTmhNMFRSR1QvZTAxdzhxNXZ1RFpVc20vTjJDUHNvcUVFQVQw?=
 =?utf-8?B?bGlETy8yL0w1eUJaUmNENmNwWXdMbnFlZGw1L1JPdnYvWkxqOTRqcVNlakhQ?=
 =?utf-8?B?MzUrbDdteEVjTXJ3TTNPa2YrRUJBV0JxRlBGQ2RHV0swR3RBbjl0REdTUU5L?=
 =?utf-8?B?R3NWaTFZbHhWSkJWdTV6cnJEZDVRcWpsOHhmSG5vQW5Wc3puL0x1UVZXeTg1?=
 =?utf-8?B?MkVKTzdUWFBxalJ2Ui9GWE5XSkk1akxXWGZHYTlVdnZER2EyZ1RmbmRpb0Zz?=
 =?utf-8?B?V05McjZUTFFRcWM5cnFwQktzaDV2eHRINmFWRHlyU2U5VFRFakVtSG5VaHRk?=
 =?utf-8?B?WFNLYlFNUnhtU2pheVJiK0RYbW1nOVBXMi8xTFlIdnk4QVJSdjRBVU1LS2hv?=
 =?utf-8?Q?+9RHbjt7c2MR5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1hrRXdJeGhNTEErdjdyU0xPYnJrYXo2MUhLNXR2Rnd2bE1tRStIWkVlU3BK?=
 =?utf-8?B?VFlaSkRiSmdDN0tBRHY5ZDkrV3pYcFFKdzBnQStCWlVBb1BNZE45V1JSMFZn?=
 =?utf-8?B?bURKeDVjUElJcUo3L1RWR1NUZ24yRGdMYjVvTzNNaXlOTlAweU9rUWFjblNv?=
 =?utf-8?B?L3RKQzFzSCsvQlZKcnRsMWdvVlNkZzJYLy9sd1piQVlMdC90T3RTb05XUjdw?=
 =?utf-8?B?bVJsTGl1cTc1dEl3TmRjYjJUUnc1VVFBUnFrQ3ZXd2xMb2lwMUlBV2daSHYx?=
 =?utf-8?B?RklER1NEbjlCTUZ1TUJuS3V1cGY0SzBLYUJOaEJGYURxQ0tkNWh2OFhZdmFR?=
 =?utf-8?B?QUN5ajFOWkVqL2tjbVEybzg2ZFJaWUN1dHBNckw2MUg4WWF3QVNNQk9TT29X?=
 =?utf-8?B?M0R4ZG0yMVFNVmlaYWlJRFJZY2ZVazBwb21jTFpKcTZDLy9yZDFZUTJoT1lI?=
 =?utf-8?B?VVFaczR5VEk2WXlaOU96VHRscjRxcEpFemtkZU5ITHlHU0gzaElFY281aTVx?=
 =?utf-8?B?MVBCTmtIV2lVQk9Xa3gwYlo4bzNkTzErakh3VFlTVWVNK1ZLVWw2TmwwV1VH?=
 =?utf-8?B?TVJUdWpFY09seVJBcnV3L0VRWHQ0WERDdzNlakMyZ0FpalEzcm5CL3lVRDhH?=
 =?utf-8?B?MlF1emEzNkFDTUoyOEtCSTEydXpML2dCSXBLNW12OVg1QklMRmUwdGVRSXg5?=
 =?utf-8?B?NHNLUk5RUlNoQStVZTB6MHgwK09meXFHSHBkMXhDNkJ0ZHR0UHlVTG8zL3Ju?=
 =?utf-8?B?SUJoQVNFQWU1OEZ3OXdBOHozUSt3NW92Vm5hNXdhNXVPU1VXUXhyQllWL1h4?=
 =?utf-8?B?b0NTS1ZBdTVyVXpkMElSNXVjSytMcGpvcy93UkhTSHc4WFB6cjJmM1ZVVmJq?=
 =?utf-8?B?YTdlcko2WU5QR0xXUHVITXU2VllUSGxqTXd4ZTdpVktZRHNRZjRqdC94YTVu?=
 =?utf-8?B?WW1qY0cwR3NGUUFqbDVRQzNTUVRDbDNLejM2UC9ib1dhR1JCYm1ETWpaWXgv?=
 =?utf-8?B?NmNUSjVyaU5iRlBGVG5pWHlBcG5VZ1V4emJTMHlYeFhZT1MvS05QaFVpRURR?=
 =?utf-8?B?WFgxSjFjR0h1WDNYMUllVHYrUS90ZnFMOFYzV2pkQkkyVDU4bGg2ZkNHc0k1?=
 =?utf-8?B?NUVVT1YwbDhhYis3K0lmdkpRR0p6QmVxYkxvZU01Y1ducmEwMW1OWFY2T1FD?=
 =?utf-8?B?Qmd5TWZUMHdDVG1IR3R3RWc4OE5USjFGSndIV1JnUXRTK2NNWUptS3BsTTZV?=
 =?utf-8?B?b0tLVVkvck9XaHpZMjgwalcxeS8zTHg5eTNMUGlxRnpNcGhSb1pGeXlQN1VM?=
 =?utf-8?B?dzl6RTRaREhFSUN1djZwTEhSalZhL1h6ckxzRzdIaUsvTUFHVTlBck1HT3dw?=
 =?utf-8?B?THBnU250dHM1MHh2SFVxVGxLRlpmaHlQVUNSUmhFRkxqa2IxUm9kMkJkTDZG?=
 =?utf-8?B?cU5yMmdsQitxVjNPdUx6VGhSbnJWUTZzZWp5alZkMU5Ed085N1NXL0ZRK2tR?=
 =?utf-8?B?OVlxL1JreXd5RitiM0dRQUhCT2s2ZFFkU044L1NJNzVGM2Rzb2tjc25Rcmtk?=
 =?utf-8?B?WFNDWEhtWjc4elVhQ25MOTFZZnhvczRwems5T2VzT0RCMnhNZDZ1QkdMeTVN?=
 =?utf-8?B?TUNPSFRyREEwL2g1NHJRTGsyKzFMVS9ESkVsZGdRaTRZaDN2eVJ1d2E5anB4?=
 =?utf-8?B?ZTdRQzA2dDhtaU0zdklpbXVwVkppTEkzL0lOZjlwUkpMTzVkZmVSQU9OMEd0?=
 =?utf-8?B?aGFOQ0Fqd2VRWEpuUWVIakJXajJ1ZXk4cFZKeFdTQmdoSGkwVjR2MVNRcVpY?=
 =?utf-8?B?SjZEVjdQMTIyRnlhQUpkYTQrR3kyMjE1bmhodWsrY0FIWE9TZC80SWFOVGVy?=
 =?utf-8?B?VVlVTmhKRllobExaQ09xdW5uMDhYMWdaY3E5Q1dVdXdQMGxGWjFnWUNIMVVQ?=
 =?utf-8?B?RDFCazZOYzlmbHlnUEFMaS8xZzV1Rk5xVXVzRXdieHhhbmswYzRscU1pSlhI?=
 =?utf-8?B?ZGhMOHhGdHBRZlpIWncyV0hVS3VHbGtRc25UTmgyWUR2RjFSZWVKNUEwSll0?=
 =?utf-8?B?ZTJkRXN6QUloN0x5MTM3cWlUWEVpUEt1SUhnUmxINDRjQm5JV1VPeVhLNkNn?=
 =?utf-8?B?NE9RQ21reGR3OEF2RUE4VTBzNXdiVjdseUlmWFBYVk0zOXoyVUY0YlpISVQ3?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BqFb+JrxGr6mnCIe4hV8ik6O0bKMXd8ScdkdWqJ0cn2q4WUUPl5E1CWMjKmS2jCy8UMswMQZQXT+mEplU0iLCi1RG6huR38pPmv5HEFfiJq2GZiojaoDANwMee6WKk7CC1prYQRbZT3LrN7aMvd1WOQBzXLt3peLlbWND7WrgpSYONLRlpedA4NLctby11eGiUxwtUvHZLNnJNl7jTUDl48BV8uq5qt5bqAkpSakPjwItvcrt79yZZL0ZP6dzx/zkWeYAY+JqXv+HelpzXHSJgq2i7X3RPmFxQv094ewqKEyQxiI4EN3z5KCvf3daH6JHbQJqXcUOFlhjcS+gcxNKnLofJGbkXKMZwgohSeCD51OrSbffUwC6goIagivEmja+gwG9r9XF6Jm76E5cA114/y+eHZztRfJpBHkdnNgbpL+NbmB8Uro4ZqAZ+vwiiRpBWHAJl7CYONdxTgesPcLpoHpbVC0OCjbNBwN1KIVgKZEHISu1eNBYqlVMITI1EET4Cjc6qxIMgz3uVozHw+Z39FOlhQIKwNyTsJipQkeSG9l4wBejep1i7bLIqctTXbDrSMQK4q6thrJ5yDBQFTPeKX9j8MzHcHPVyswazpGBFA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d16a39f-f333-4537-df06-08dd4f37b678
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 09:44:46.1993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3zYSJK1URq/j0YHPaRq5SOVVV8X7BBcS4OCrtxyc/nIupUnv1TMvRlqgFzMmaItbU3m6gLIq8m8JUPC4Q4fiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-17_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502170085
X-Proofpoint-ORIG-GUID: E-guaPy2vkjCfzSSTWYDgVjd_5UG1i2M
X-Proofpoint-GUID: E-guaPy2vkjCfzSSTWYDgVjd_5UG1i2M

On 17/02/2025 02:16, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> After commit 1bad6c4a57ef
> ("scsi: zero per-cmd private driver data for each MQ I/O"),
> xen-scsifront/virtio_scsi/snic driver remove code that zeroes
> driver-private command data. If request do retry will lead to
> driver-private command data remains. Before commit 464a00c9e0ad
> ("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
> expansion, first request may return UA then request will do retry,
> as driver-private command data remains, request will return UA
> again.

So are there any drivers which expect this sort of behavior, i.e. keep 
private data between retries?

> As a result, the request keeps retrying, and the request
> times out and fails.
> So zeroes driver-private command data when request do retry.
> 
> Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes driver-private command data")
> Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes driver-private command data")
> Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes driver-private command data")
> Signed-off-by: Ye Bin <yebin10@huawei.com>

> ---

Ps: in future, please list the changes per version here

>   drivers/scsi/scsi_lib.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be0890e4e706..f1cfe0bb89b2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1669,13 +1669,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	if (in_flight)
>   		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   
> -	/*
> -	 * Only clear the driver-private command data if the LLD does not supply
> -	 * a function to initialize that data.
> -	 */
> -	if (!shost->hostt->init_cmd_priv)
> -		memset(cmd + 1, 0, shost->hostt->cmd_size);
> -
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>   	if (blk_rq_bytes(req))
>   		cmd->sc_data_direction = rq_dma_dir(req);
> @@ -1842,6 +1835,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>   		goto out_dec_target_busy;
>   
> +	/*
> +	 * Only clear the driver-private command data if the LLD does not supply
> +	 * a function to initialize that data.
> +	 */
> +	if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
> +		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +
>   	if (!(req->rq_flags & RQF_DONTPREP)) {
>   		ret = scsi_prepare_cmd(req);
>   		if (ret != BLK_STS_OK)

