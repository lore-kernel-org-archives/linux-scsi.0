Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4624129D06
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720640014; cv=fail; b=jjlzQetbN65S+mO+gKnznD9KWNxwpziyBlipq2SPyqW7Ur4EIPn5ll8tQjyFfBmjw4F17ZKbQu+SdYOsf1gVibRpIXSXWzkAZerj4hjo15wFY+kbDO9hgC+NufmiKUxuJKJbtKJIQAQ7KRX3Rfn/LRExuVvOhcuMLp4XTmKfync=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720640014; c=relaxed/simple;
	bh=Eb3IhIzqjSbSMs93QCs+4A6jIIPnRdh5s7FK+FImYb4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vmfr5fqLKHJhMoknBOj8ddjIpxL1yw5k4mvdioBG7Cn4AKWAAb3Q6HtohqZ2XnX6eOYB9/zBRiYs7IKJSD+Bo5spRdSuIdeBSlRd/iVKk5Bdrn8N2eV62d4hkiv6Aiim/hBp+95cY5WThCnyxYoOOjUuV419SgfgHHh9eCTb7pI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OJ3Unwc6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=go6afj8n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJ3Unwc6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="go6afj8n"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFebYp029620;
	Wed, 10 Jul 2024 19:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=mWrExDlS6JTeNgbWk3AR+/ZRf+75cHZWNn/B3FEPpPQ=; b=
	OJ3Unwc6SO2twPyU7ugRo6OK9cMiWu5Vp3BggOuoL4sB7Ve3QCMm5BhX6NiLoZhf
	+YUZoS1LjtbAWtfOmyyqIvKxieoIKdEHwwkpxC7bfhIr+tqMG6ef7qcGWRGMwFHn
	gAJDA8mbg2FChrr6HN6GKsCZ5xl0vKR8RPeld9rtJnsJbL4r7i4IfSBDuiSwMrU0
	+cTbbbeEvQZ6dt8A0N+ymTqaAeMkB1DIrpqyLBH+GZ5GAGgKED3arze6ZrDVuQya
	+O0iXhKdwv/qY1NoSwCXof6/1fqpMuOZkPU6v++HnC40OOTLH3dMCKpurLHchDS1
	iaLkV+0Qi2oXsvzXTE+ZYA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgq02yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:33:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AIeN9E029895;
	Wed, 10 Jul 2024 19:33:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vva9j5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oiy5FWTLw4XKKJvswbC8T9DilesMG/JExHTGN2zPjRlJlLm6uPH2PUjO4uRfaJJytT/i35kGTfbbrexE0mU2KdoZnjEpsdAutMaXaOry0NU9izfZY/0+DwA+CAkjqkOPwpG8B6hqL34TVE+a92rL8i2NrHf1qRavllcV2ncs6iqxvycRNWPk8OAWf6RPXEhTopFN2fUpVE9nlxy0nmaUH4A1FTTg8206/SmvuDKQG+VjyhVw4r1Okzsz/nRSIIm0IAeCTnxw9Gx7cl9UeDHZxuV3pUVQ8YKmslqcA+re0SipQgZIDG+DxkdW9WB6ikyGeSfjkFV2P1XkbYfosQg/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWrExDlS6JTeNgbWk3AR+/ZRf+75cHZWNn/B3FEPpPQ=;
 b=igQRLleOL/SXg4MlRDcmLTPRNQgqwfQQqe+RiDdCE8raGRjlcoiyq+ohA9f4vIqrfT39QgXnVZwJ8kBH9t2IE+6jZqbHrOeVBX7XnPCh74ry6SZwS7X+9s0N4r/68sw0QX/mLOwmRRAzPNIwUe85uMKSO9lB1Ta4mZYShuaKi9LryDojfWFkgFy94dmDcjM0ULON+Awh5PhrXowP4ewjI33DI3V5EB6cvO7m9lobfAcdXFsH4cdYsipu+ULV1yYDdNYyJB4V+RAbY3y6P0z3CRkQ6hZYQYIh9J2KXOCLJ8hV6kng8CWxxNDiIhdymT4mJFs7Acpy7Bkyoe/8AgNVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWrExDlS6JTeNgbWk3AR+/ZRf+75cHZWNn/B3FEPpPQ=;
 b=go6afj8nKxkELqj+mHzQ0K/g/zBfwjW75Ldilu3gjlfECo2OVbgjGJnuNGb/pMm36WOZZlkzGFVHF04pzaksH9SvCSerr4S6HrmcMHeo3L7y2mSomUBHQ+KWHEibqcLLmixhp56TcjlaUnX3hypFnIGzm3RanGQLh1tjGGRpTnQ=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by LV3PR10MB7937.namprd10.prod.outlook.com (2603:10b6:408:21c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.38; Wed, 10 Jul
 2024 19:33:25 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 19:33:25 +0000
Message-ID: <9a2ed27b-abe3-4d8b-bd7a-56b5acbc5e8f@oracle.com>
Date: Wed, 10 Jul 2024 12:33:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] qla2xxx: Fix for possible memory corruption
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-4-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-4-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:256::13) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|LV3PR10MB7937:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4b70ea-dde1-416c-1f2a-08dca1172aa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?NXRJNERRd1lZd1hadUVrNnM3NkxTbXIzQis0ams0NVFmUzZKckFSbCtsMllS?=
 =?utf-8?B?U3Z3R1VBL2ZJZktkZ0lHQTBhWS9iV3pTMmM5RExQRXg1ZGF5UzN4MnErZit5?=
 =?utf-8?B?aDdvNnBDRnNtYi9kVDNUTXZZRzl3SjFQQU55MFFYdmJDclZKWjQ4R3hlR1pO?=
 =?utf-8?B?VTkzQ2xzai84dVRkaXl4cmNHUnhRUndHSFJvb21lVlRJWHg1NTJuODBvaTQy?=
 =?utf-8?B?enVKVitDQm5DcGdpenZlNlh2MGp3TFNjeHBrUmFFenk1cVZwSjBucVM0cHhq?=
 =?utf-8?B?aUJPaSsxeW5jOUNyd3N0WVlyTitQa25icjVCeU93TlFIcGg4ZjBndnJ0am5P?=
 =?utf-8?B?REpsbFY3VG1CT2RKOUFENVEvME9CcUdhb2ZrQ2lSRUs0K0RGM2tRL0U0MTli?=
 =?utf-8?B?RzkwZWJyM01LdWVHSytTMGtScE5WM2xXM3d3c0NuaHZndHRWWE5WandwSWRj?=
 =?utf-8?B?ZWV2NkhULzZTalc2MUdoMnRFd2lhR3BZNXh2ZUN6NEJGUzkvU25USS9obmF6?=
 =?utf-8?B?M0wyOWtRWjlvV3MzaHFIeUZZTnBVb29Lb3FiaXVlSjlYdmgzcVBqWm82SlQy?=
 =?utf-8?B?TWdVL1JwN0pBd05md2R3OWl3UlM0VnVJNkFPQWFyZVRnYTR6ZzRkSG8zcG04?=
 =?utf-8?B?VG1oY1FGaTVueVFLeW1KWHZGOGtrRVRldENSZmpiMWNsVHlYWjNmdzQ4MGFh?=
 =?utf-8?B?RGtZTmNnYmtjc0dUS1hLUHliVjVRQVo3anQvRisvaXRMQkJNVlYwMVRnS21w?=
 =?utf-8?B?ekwvT3hmbkJBLzlnN1g4SHh3RzFWeFM4MUJCWlhyOTN0ejY3NlB5Mm5CMEsv?=
 =?utf-8?B?SzZJVWNvblNTeUtmTS8yWHlBZWJ2OURib1VJNjErNHB3bmw1NzdZYUJKeDFj?=
 =?utf-8?B?YXRaY1Y4WFBvRlE5R3k4NGJ3RmVTbElqTjNXM1VuLzZ2RzJTYWFRQXhhNHRL?=
 =?utf-8?B?bXZyWC9UcEZJOGp4M2VDNjlOR2w3V3FIRHp0T283eG53TjFNL1VTbDNtamlr?=
 =?utf-8?B?VkZscDR4M25BVVJYbGhDMmgvWWVsZUI0V0tuT2tnY211QnBhNkR0Y3J0T1dT?=
 =?utf-8?B?aS9RaE9LbnlYTTQwdkVQa205ZHB3eENUa053YU1RWG16dk9uWXhqMW5JRktE?=
 =?utf-8?B?bWljRVM4dXJwalhXODJoNjRlR2RQM0NORXRFV083NHhlVmJwemU3VjhPSGNS?=
 =?utf-8?B?emFmL1BFeGFjZ25yaTFuMUZUOXBKalUwMloxN3EzUEo3dHdlK3B0YTVQeGQ0?=
 =?utf-8?B?NjJoa2YvOWM1RVNXNmJQZ0tqekdaTFRCenpvQXlDSHpFbU9ZNjg5bVF6SHl3?=
 =?utf-8?B?WC9XYW5WMUJLd2tqbWN1cklFM3BzQVBtT3dWTTFnRE9lTWNNUTM4ZXRMVVNS?=
 =?utf-8?B?NTJiMUtnNHJIL3NlVzV6RVliOXlhUjZMM0k4SGdKTDRsak9qTzUzZzE0V0NC?=
 =?utf-8?B?VVhwRGh6a3RSVmo5U25Gd0NWeUlOYTc1RjIweWtibGpYbXNMVTJmcGk1T0R1?=
 =?utf-8?B?M0xCRkR1MStSRzExeGpQNWIxL2lqTGtES09zWnBzVzZTaUlQSjNFSisvNDBC?=
 =?utf-8?B?aXE4Ymo0OGR2K3JUY05XYWdVWE9qTTRpWmNUZnlyeXpLYnFRN00xeWNBMFow?=
 =?utf-8?B?d0pWbjBuc2xTWVREbjlsdUY4ei9rY25HbXF0YVRaTmNSc21wWDJSeUlPS01K?=
 =?utf-8?B?S2YrNU04NjdCbHFIeG5DTW5ONmEvWTR0Ylg0SllzOXJkbHF2UU8ydnlxNFNY?=
 =?utf-8?B?cVRZZXFNV211NE1renFsZkdaeStGY2NlTmNMTkFjWWtyY1VCM0VPalIxZy9H?=
 =?utf-8?B?aVgwbHdRUHY5T2FiN0dCZz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SkZNMUEwcXlwVlBwOVpoWUhXRitLTTlXbWdmQ1lsRjVXZVdsM1ZzQVF0WWZG?=
 =?utf-8?B?ZHdHYnU1UEoxREVMbmZBT00rVFdYREdpdFZ5MW1zbFVDN1hhS09leVg1S0Jl?=
 =?utf-8?B?R2NTeVhGTDVwSjZqVkFxbWdiTzFOaEtTUnh3VW12QnZncjl1OXMyU1NCVytC?=
 =?utf-8?B?aXE3OHpQUWl0WjdCaHRlRlRMMkFwVzNVUWtYNWZuWkxpVGQwMm9vMXlWUEpH?=
 =?utf-8?B?WXVtNlYxRThtWncrY2VhN2xubS8wMHdHQ3hLTzBLbVFNV3d0L3FCcDYzK1hB?=
 =?utf-8?B?T1dFb0lJS3hLckdaNVRYWWxHR2FzcTFpaGV5UjBPT3o1UWxHZ1lLOWRKTVFZ?=
 =?utf-8?B?cHlnbitZRjU5S2dNUEp6cDZVRndTMitGVkNQUkozN2h6dUlIZGVTem94dG9P?=
 =?utf-8?B?MmJVR1dpRGs2cUs2akpVTG9RNEQ0dE5IdkJjL2VsblJ4R2ZvS3J4R2pnTW1x?=
 =?utf-8?B?dDVPN2FIclNmN1A4ZFplbmNoaG96Y0s5T3JhdFZGSCtMYjlWbHdQajQzRnU0?=
 =?utf-8?B?RlpzMjdnTi82UGRKeE1RbCttb0xsTit2TDhrU0ppdVlzdEg2djVFcDBob1RN?=
 =?utf-8?B?ZmNkUzdGWHlXN2U2M2d1WFNsVGFnemVSN0VoN1BuVXdhZ1hXUXRXZUt5WTVK?=
 =?utf-8?B?eUJNRVAzMHNqa0F5K3pDZXEvc25SeGZQbndyay9KMXRJSWRqMFowaGN3SWNq?=
 =?utf-8?B?bXZCVlBVUXBPaVBqODlOVlNOZnBJR0pGSTYrelBqVHU3NjUwbnRMdWFZYmZk?=
 =?utf-8?B?T0tTK0hNS3JTRFNkVTdXYWx3Q0g4WFY0SG13bk80MVRZWTJJL1VtK05qSHVi?=
 =?utf-8?B?WE5NZWJ3NzlPU1NvbFJQUWFDU1p2ZnpZWFN6dytsQ2NNWjhEUVdDVVhpVE5D?=
 =?utf-8?B?Ti94T1J6QndRWUF0WjU2c1cxN1hIOTNxQkxNVkZDeGVUSzBrZWF3cGYzT1Qz?=
 =?utf-8?B?U0F3c043U0hmOWcwOUVXZE05UHdoRDVuTFMrU0JrRDg1ckF1WnlUN3FjdTY2?=
 =?utf-8?B?U29SeGVTYXY3RSt0dHoyK1NZRE1EMHVpcHVFYnB1V01lUEt0Nlc4c2l5TFhz?=
 =?utf-8?B?TXhvT1pBVU00Z0VZMlQ1S3dHSWZ0bHRLWWdEaDZvcS9nN08wMTFSb0FZN2tE?=
 =?utf-8?B?SHA1NHNUbGxzYzVZemdDcElvQmw1cktmck14cXp1OGdWZEFYdWUwdkJQK0Ja?=
 =?utf-8?B?VmtSUE42VWNoZlVkKzZDQUZYN0tNamhLTGdmUWtzamlqb2NIcnBMWU9oaFJu?=
 =?utf-8?B?QTRqQ3l0d0hyTmhpVmtPa29Vd0FBak94dUhobGd6U3lqWmVzSjFHMkpIMWJZ?=
 =?utf-8?B?SThxYTVYMkdtVHlOWk51MWh0MUFSTkdBWmk5YlR3b2VDVTk5dzZWS3dROTc5?=
 =?utf-8?B?WU1KeHB0VG1BMnJjU1BjSFlJTEluaFJGSHZtS2o0QjNaRUVvN3JmUmxRV0I0?=
 =?utf-8?B?VmJTWWcvSzBOcUJQZWZWc1VjSk9nemhrYWJTNTd6dXEzbGZ4WHM0MXFIUGRE?=
 =?utf-8?B?WG5NTmdCVnBkZHRGRWxlZUVCcm5CaHNLck5uWDY3YXY1RW00OFgxWXNTVlVU?=
 =?utf-8?B?RmVFcG9GaGMxU3c5akVpNnRPeWxmcm5DTGZSaHBncEp0eFRqNm84YVJsbU5p?=
 =?utf-8?B?MEF2YWdaamROcVhRZnhzMzR4RmYzVVFsbC90N0N5WWlERDl1czJnWC8yZFdm?=
 =?utf-8?B?TFJpSjhOeEFFTklleVFmMjZ3ak9YM2NSSVhBOWRaTVp4QkVITFNCU3Z3YnVq?=
 =?utf-8?B?d2Q2RTA3VkF4Zmhad1JKNWpWTVlaclc4aksyZHJ6MkZ6aTFJL2VxKzZadmxP?=
 =?utf-8?B?eXpYRTh0dExzdThvREdwY1htbVdnTkowQWMrUEdsNUZrV1RhWDlNUDVOR0g0?=
 =?utf-8?B?Qnc5UENLaWQxRHVQR21POUpKdGNMQ3JIdTJta0FTdVA2QnBqcE5OTllKYTlk?=
 =?utf-8?B?UjViMFFpOGljVmxTV2dBTmd1SExQZXJ6amI4OGlWNzNvZDE1MzJlMkt5cmo0?=
 =?utf-8?B?L3RwSUhCMHhjU3VUejc5Qi9XWnRvd29Remdod25DNDNQV1NlYWxpaml1enll?=
 =?utf-8?B?V3VyWWJ1dmxBdThCdi9iTUdlZ2xGcDl1KysyUllSY0NBOSsrQmxjT0xVNExy?=
 =?utf-8?B?SFZ1b3ViYnpxQVZlNVlxYmZHNnZrNUtScy8rd2hsc1RxTkJYQjNrbUdYakN4?=
 =?utf-8?Q?UvWtGUE/z1gwfWMHokJRJwM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	oIL6TorathrLKg+LScKKaMYKiX2mNSeMwfHsvPCl5KUGUl5J7KFfgYxdt9r/iIk5xG9GqSkmMf9YxmQyVyuaVjlYQUXEccJCU3JmBO6UalTZXR0aglT49q6AKAs4i4043JGCvJhRGG5m5oWpIyH7EFu9+5x172IN83qhr+pOnq+uGXdxG/4FG3vXcWTTkVB6JIRpx6ayFUZBb/ySQkMn9BUkxvnX96CwMNRSYc8gmhnpTvXkgqtFiX1oycy51H55l9Ltyu4QTSvCZH8nIjiL9ylOAUKx+ZgfdzZ/NBikO/Zuhf95ffwApxnPMPGm2oMtbb9BIQL/5WwWEUy0dNzM2WUeD5TBPS1g9lhlULAX/E19BgcFd/1kRaMhYISsIGUV3aRQZtNvC3Uawxix92ZH98fYQqNOuPG5BE/vkzIwTP8BgT0Foi/li2AR9Kg8gamBKbdpAJZksMZDqNeVWZkISLNBzbtlhpOvR3BUEs4EbhBszqiAtpAGidyv8tJTb3orHWId0m3QJW6n34l821m+r0USkwLvOsKagJuLB2eoTrm7luXZNTgo9ph6spMz4qTcmTwIar9VSSw121xoiQtKZ0sysDICJqHNxorQvPUR7b8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4b70ea-dde1-416c-1f2a-08dca1172aa3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 19:33:25.2700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFNozjT3SQAXp4cXrwFBQ7nT5fTXxGzYtCp+srvoeZN8Riphj21e1aBBk8Qr1u/gQnOCG/XDw20gwwvK2s865zKG5Zu5vPw0a19u4kguXao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_14,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100138
X-Proofpoint-ORIG-GUID: 0tlzy2ylnNg-mkPr60CvGgPiG_orjhb4
X-Proofpoint-GUID: 0tlzy2ylnNg-mkPr60CvGgPiG_orjhb4

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Shreyas Deodhar <sdeodhar@marvell.com>
> 
> Init Control Block is dereferenced incorrectly.
> Correctly dereference ICB
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index fcb06df2ce4e..70f43eab3f01 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4689,7 +4689,7 @@ static void
>   qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
>   {
>   	u32 temp;
> -	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
> +	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
>   	*ret_cnt = FW_DEF_EXCHANGES_CNT;
>   
>   	if (max_cnt > vha->hw->max_exchg)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

