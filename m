Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069723822A1
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651011; cv=fail; b=k45XSvlg2vQZGgboz00kmjpft5U6OMdurXlpKXZXy7uAwqWSLoPfYDgUqI5yM+NJ/ezmYDNzwSJkpDauuK2PMysg4Vgq1wa41v0d5b7FBaKegQV3b8UjzNVWxYsBrse8rUTsiB/i20RGm4W00JVTMdtNB/Q7VEZv3MS7TZtHZQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651011; c=relaxed/simple;
	bh=HSgf7x/QYzrLesJj+DOpvQEQ7LlbwgevDSk7sPHZhA0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HoSl/ms66Qnp9qNt6ATIvCmdLJFmUxH8DN7UqMmYLLHvoGYTunKw2HEOo+Jv0fppKCVRFkSD0SlUX0Q9Rpe0iEwWw6feYPf6M+QxhU1WmZPzR30/sZhgWGCWeVB8kzn4iBa5n5LA1RlmQ3kN7TOk/sy3G6aqDqc5+WuZIPvB4DU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kgy3G4xr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kfTyvTVu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kgy3G4xr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kfTyvTVu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624J28Z03358558;
	Wed, 4 Mar 2026 19:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4t8X/RkzmSqna2Ja9hmDeOmWxi2+cbxiCPvatk1TwBw=; b=
	kgy3G4xrkLHDJeFI4ePCu+yZO+6IcLKuwOiykJdEwCVDGgQJ8mqNcto1SaYH52cP
	vEs2b4lblRi2lUV6yNqz14VdqWvAdCVBxGd1/TnDZDzzIx8pjUBk7AMZK3f1ZYL5
	7Y1jCnNiMM6KSUndm1xxFHrfHOhnm+Na/gitz/4UCaTd/R4MGZ2t8AA61fEMX5lj
	QE/Lv+oGKClcPrg2nyEk8ljhHEzkj9a8dPHJLNRBEYWg8lm2HgMdoa4LLPiwc9hB
	xuLoZnYL/dSg6AuyRXmOxWmPPiUGb8csiNcB63LBbmVRtdKuMH3sDJrFxbmNwnwv
	90G3tU5qf3t2ZJDFAkfRfA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpthtg019-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 19:03:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624He7rM037136;
	Wed, 4 Mar 2026 19:03:23 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013009.outbound.protection.outlook.com [40.93.196.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbxe8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 19:03:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BWNZJ85Zjp2ZfPK/qChp3p/pSip+9dQlSJl0hiqARR6IDIlt/gGVX0Y/L6i2nAFKVJ4scGLh7DvJUmzQI4+JfdNwpGXARZ9aNHkqwwwRS3nH3WBrKsf+I7FwI/HpQ55sMFShbKl5enBLq4drgQBtq/IlbCDYEMx5f3PeFwyehw3k9jq4YHU6CKjKfqVP2VqW5+H6Ywi4wkvESH/OveODbEOQOXxUK+apIeoRvpmsURXTy8JkphIt7/WI0SkyjClf48bvBKqJLTIFjBKtK9ZLVvIdNAEaDYrYePyAprZUvW0upm4uXjGu1YG8d0nEINfFcVPg2WWZWcc5q5+zl9wfjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t8X/RkzmSqna2Ja9hmDeOmWxi2+cbxiCPvatk1TwBw=;
 b=wX9lm0b9GuFmh6E5r0+3h8MCtAhvDZ38wlu2jdSpebdlgyqU0oDGY0D2OBSCzwBBoli4d9N6QHUcg4uHzy3I2q0z9+6L2P3J6FYTa8cHIZyf0FadTEkK7jewWFJZnm6FZYB8mHgJ03h569raHiK3xwt+LTacT9uZ+AhwO7Qdnwe4sbWQCme4r2LgPaH6sUBxcsVQFWFrVW3CDKHB/tDFGGPG9bQtpFnPV51hH9x6C3ncwaZkVCJ4rmhZQdZwM6qJMqyWeRFXwSHfa85COvjXlzyW7wFCcfwWaMIFnTpbwicsycv24UTED92RZQUOiEL7aQnf3G6Vd3gl2cZ6VbCwrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t8X/RkzmSqna2Ja9hmDeOmWxi2+cbxiCPvatk1TwBw=;
 b=kfTyvTVuicIZdeu+GDWqUDUpKLFE9CsMf0tMq4TfeIpea4xGy8Wv3wskCPc7lQI81+yJIG9u7YGXetBvGi2ZeU28l3TazRxUMSJhO7D2WVtWnM+5ZsOwdW4dMPMazDBoEytCRyeZ/bfNLKXuWMMmQpxtbdyUWaGnq26R4AuAxG4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4952.namprd10.prod.outlook.com
 (2603:10b6:408:122::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 19:03:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 19:03:19 +0000
Message-ID: <19ac7c6d-a787-47ac-91ee-71402c89cbe5@oracle.com>
Date: Wed, 4 Mar 2026 19:03:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7.0/scsi-fixes] scsi: core: fix error handling for
 scsi_alloc_sdev()
To: Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        michael.christie@oracle.com, bvanassche@acm.org
References: <20260304164603.51528-1-junxiao.bi@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260304164603.51528-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0028.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:20::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4952:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a6b2c9-e44f-4498-1ce4-08de7a20b2a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	BRwzQgud3HFoenE9aKnqwRceaT6h7tmUDOH3Fj+1wZpJsrUDzdl9nxkhGEb/3MFvo0HcfUTFk9AbvJu+1PhBJ7J2Tw4x20mw6Dgto1AWKCt/Y+viYd47N7W/vrYagoQK2yt3/IZxEnbH+WTfo1dGqiVJYmVBPeB88IHJy9HEqL1NKAsOeAjNrD6mH9n5O5F3V25o0zMKfDe8Dwnd+kP1EDzoTlmZ9ucUZuOCN+0lAtK5XMaiOggIvJ9NPJDMByclCriHm0ki6EWRm9jp4KK8ZiWyVMPc942veytTdp3B6ip12O+DaEMR1nlZetthIcRg+FuQY7/q8BE34JhQuM3pbcyZxBCpjjeWWa4KIVmi17VG0CymCTWFOAkMvt84dqaIykSykDkQ79+g/9OHOM0g81fJLo4mE41aI7HntK4+rwWB8IzPyJIhs2lNWMF+gdG83fpnkjO4hli5ss/Qy2FzeN4VmXo31E2GKHtgz8lojSL8yypomxdDfyER8egRvtNAV8fH4Yln12sSTE4fFiRG6PMsAG3RW0llLjhCitPouLD5r1skt33qrV8qVbeuuWXM0RgkJNHfMHR8RrmG73CGA6QTirDL0Q7wDyO8fy1OFHuwUAS/WvbcdeC91Vq6VGsd/XWAbxh0fNB+8GVG9wIeP88Ky/+VRZJnixyjyA4KN4FdG4dgqnJ3Y64wD04JK3u+rs9Ga6RGKxb6YO5x0yOnd/uQjboh2KWG0RUAuy7QMqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDdVMGQ1dms2cU5Va3dHZWZIbVhFUDg5K1grRDR0dlZ2aEVOUkxXQlZDVVlZ?=
 =?utf-8?B?SE5UTVNySFh5MjBxYTY2c24rOE5GNSt4UURqNDAwM3F5R3c0bU0wUk9yRzZz?=
 =?utf-8?B?eGhCWlFoekV3b2c2M2UxK3pyblFaU1FFaEdtZkkrV0FjUGdoR1dNby9TUHUv?=
 =?utf-8?B?MjdHUU40TEJDczlFdlVWT1ovOXc5VDRyQ1EyZWsxaktDTC9CYzR5cVFKMmQ0?=
 =?utf-8?B?bllWY3VGdjQ3a09JeHpuejhhdjFhcTRpdjVNdVBLUUdsSThYZlk1cjFZcEZX?=
 =?utf-8?B?WEVtM2pZSWhyQ3AvTXVlN1lHKzk5ZktGS2RDUHQrQ2tiTjBwbWNJRHJLcTJJ?=
 =?utf-8?B?REk4Tzd6RTBUQTVJbG9JY0FnRFk3NUFkZjA0REk2dGFFZmk3SWtQQ1d4ck50?=
 =?utf-8?B?VjVGOUtyOGZKSGJWRWMwZ0RTdWZlblZ0MVVQSlRKWFVjUUNIelcvZ2lka2tY?=
 =?utf-8?B?SmtGaUg0STk3bU8wMno2K0NTY1doUitldk1SQVNicVdvWTk1WVpQbHEzTUxq?=
 =?utf-8?B?akp2eHBtZzhJQkFPVjhvb0o1T0I2YWpkdVpnTWkyS0ZKejVuY1VoSVdYcXdN?=
 =?utf-8?B?NmJjVGp2WmpOWFgxTnpBalVnLzlreDFlNjlHWVFFVGJHU0VHNWtzbkFoTm52?=
 =?utf-8?B?dmRZcVI2YjRNYi9aTnBRTytoelVoLzRKa2kyZzVWUjcrR3FBKzRpcVhHWmo4?=
 =?utf-8?B?OVppMENPK3JCRERJd3dHdDZmTGFDQU5QYmEvMkhvU3dMOU1TbFBlNEJTNGlM?=
 =?utf-8?B?dlJqVlpYTW1yUmRDZXhhYjVvM2hTbEVqdkNFaEFTZ0pvR1dWenU5MzFOcFhM?=
 =?utf-8?B?cXZYNVhLZHdYRlNnM09HUzU0UFFEZHF1K05lNFpBRzRibkdQb0Fpa0tjeDhI?=
 =?utf-8?B?SG1KdElXdXNGbThZbUtKc25lYXVUMXJjekZSNWFEMENNYTNrMTQ0ZlNTSWVn?=
 =?utf-8?B?dGpqR1RvcVJwMFE4UndMSHE0dkJwc1JDSmNxRjRCcXFGeHpuY0ZnempLaHhC?=
 =?utf-8?B?MWV2ME9FRlpHTk4zbURoZm1tZWNRNTJtRlQxYnkvY3NHUXlPKzJUZXJrUXVi?=
 =?utf-8?B?NmdjNFNYQlZzL1p2b3ZzQytNOFJMTlZUdDVRVEM3QmQ1QUJpQjFnSTV3anhX?=
 =?utf-8?B?OWVOR2oyQUVZS3k5NmwwOENkN0JXRThYQU1EQmtYVkRRNVJsN09LRlJDNzE2?=
 =?utf-8?B?MUZNT2FNckpPTkxOQmJWMHljeXJkZmpRbVhIODVOZEk1Y1NHUDRhVHdhcDdQ?=
 =?utf-8?B?d1ZSVXV6OVpZbVllQ1cwVGIwb3pxZlEvcGFpR2R2UGsxSDJWUTROWGIzTnVU?=
 =?utf-8?B?VUdQSlpHanlwbHpUVVNzRXpNSVRoN1ZDUmtOVkNveVluNVdOTnZKV3NoanV2?=
 =?utf-8?B?cWpKbFVhM1BjeE9IOVZXTFNsbXVFd0RRaVl1TEpwdkdUUmpDbTgzOWgwOTV5?=
 =?utf-8?B?VVRSa0R6ZHZ6bDdUTjMwVmRDMjFaaTRWdmVzTzlFTERxK2VKUzJQbS8vMU83?=
 =?utf-8?B?emFDemxFVlhTSTI2dy9paEM0a0NZb3hZTmhRYnBjRU91aGhIZFJKRFcxa0JL?=
 =?utf-8?B?VlFTYVduNVY2NWt3NDlVTHYvbW8vRExuT2ozeVFEMWlOTUNJclN6TXExYnJy?=
 =?utf-8?B?OTRmZzZ0c2JiM2ZoZDdTYWEyMVVhMzNEZ2dxeWdGVDBlMWd1NXp2dGkyRkZp?=
 =?utf-8?B?WlRuSzN6NDk5ODkycHF1R2pOYWRKT3F6dzAxeU9adUtGenFNeS9xbGlLSUQ1?=
 =?utf-8?B?clQ1SHlxcG9jZ0tZUmR3MUxmTWEzSEhZT1dlV01BWVZUMTRvRFhzblozRnRB?=
 =?utf-8?B?NnJXTmNWZnVvd215ZTM5aHpXRjM2Mmw1RkhGRDJ2R3lEeVcxN1dadWpsTlox?=
 =?utf-8?B?Nm5ZazNvL283aWl3cHpDeitWNGNVd3Mzb3VmTElkTU9hU1lEck4wZktFb3pR?=
 =?utf-8?B?clJvZWFQOExvQk9YbHkzZENGRnRJczdDZ0pNUHI0bVFzZVdjOVlvSndPemk2?=
 =?utf-8?B?RFp6S3BiUE5XNXJlenF2WFJHNEFFaVR1NWt6b2hITHlvay9JZ3Z0R01ENG5U?=
 =?utf-8?B?VTNaY0wveG1KZlNvcndQOVYzOFZDWndEb2JvbHBaSEVhVFdudStKV1dvTm85?=
 =?utf-8?B?Y1FSTmNRdDJkeitvdmtaMEhOWnNBcHc3ajh4RzZubEJlTVY0ekxIQmpqMDVi?=
 =?utf-8?B?MWg2a2Zha3Vhd2tlZ2RPT0lheEdPckM4bTdFQUJ6WnpjUGMxc0xHTjYrNFo0?=
 =?utf-8?B?UFF5UFRNS2dJc1ZnRWdzTDlZc3VCTTdVaGRJQjNVMnhZZVVDd0IvWXN3T0Rh?=
 =?utf-8?B?ekFxeVFWVFBrYU1MOGk2US9LTyt1a1NTajJnWkg5Wk1OUGlFUUQ3Zz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WzMteEoKoKee8xiAhJTnwaWTXCrWsmPUW8QhtZpY/oEu6FfNRBYZ1GXAZoSIwnd2JPZPMkErvt/K+uboyJU/rlYN54/w2w+uYCQd0B1NorMNzYQcpC7A/yOYZythpyBJsWKLBqQDXldi4n0FN5BuZK/gvBeOWwT53PryRcvJ5xh/AFOMF4sTEaLRBckUoWqlhP2jk0zsbQSBTw4dmBwWTj+1byHH8Qqs82Fedl8GIkhezPDhU2g9oWwuYi0DtW5h7u8JFoTFm0JdT7HI5z827Avw8plXf1sp46/ZT/95/Ebskw/G0x2BVvpWFaSeKhIwGaG+PQOvG4legL+Y/3WGipKC6Gw1f9Os5UWHErfH/JqSbcdmXMT0yXsTfeUvEiCZ+6/YIVmWuFjQBMg8MPMwQK6IlHwWhFzEHmCzWDepbVjkg/roKFsjcCcgs+HKL9cVqVoOeeUAjz8jgIIhZgAfmolN+l8dkB2Y0QcLh1jjfjFaNgUA+scGGs9pCeFiNVbMClTGBq2d+MOHb0PY9FiWB1c2XIMwQOdpmF+S4PEQLotAkJO1uYGmrNAIf/3qSY4h6NtaZ7hMPQYF5IhRRJP3fCxkthN0GoU3VxCq5LvWS0g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a6b2c9-e44f-4498-1ce4-08de7a20b2a6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 19:03:19.2518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tR4UJaCRe9ayYyYMDpErpS2nHh4Skhmrhs8QWjVT1UkbIGBf3yAT1Y7PpQS0ZWEoMbZ/4JcaH2WxVkOHEypgfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4952
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_07,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040155
X-Proofpoint-ORIG-GUID: cT8ea5IzXHRPBTa1Be1yWOSzrPEOO0qb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDE1NSBTYWx0ZWRfX5UNhE4AtjW79
 Isu0FE+lQEyUGbK9le1farxCvFbvGBs22gkx6g680RLBgaHReE1BxWdkJUeZ6X0fdD3kd8xWimS
 kAlVDz6tYhPRvDxzVxqRSGLfH3dmYlP+JQZPoH53bolZIYSKbUQNeLmyfeoE/Ad/VaSNhDS12Vx
 szSuBSg/R7/DY/oKODj/ZOf5GKsECbHOHdzo8sYXT+8SUnRy9BvlIi9OrTke2cVGDMSnbuM2QQy
 jRrWRAQzSTa6TbCsWaCp8B49dNq0wJUryyGiGBltpcarhndtZPipiL3tKDdVrxfFQ9Wqaztn3qk
 tjrRoN5YBjhXlVsmfe5dKXWQrxJwaO8k2VeOlNqep35d93fXfpSKktCeriXuXlGie/IF64i9FoD
 2zVwXHK78SFmMORELXw6MB9RSDucgnKMbCgf1h3T5wdYX2WPcKJ4Wm1EfAAbXsR7slfRyN+iqcf
 ufxkM6IbxiK1dJ4ddeg==
X-Authority-Analysis: v=2.4 cv=KK1XzVFo c=1 sm=1 tr=0 ts=69a881fc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QRczWG8Oqo7VRSghL14A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cT8ea5IzXHRPBTa1Be1yWOSzrPEOO0qb

On 04/03/2026 16:46, Junxiao Bi wrote:
> After scsi_sysfs_device_initialize() was called, error paths
> must call __scsi_remove_device().
> 
> Fixes: 1ac22c8eae81 ("scsi: core: Fix refcount leak for tagset_refcnt")
> Cc: stable@vger.kernel.org
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
