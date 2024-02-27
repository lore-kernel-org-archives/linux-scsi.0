Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CFF4DA0D
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 04:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709007043; cv=fail; b=CF/+lQZhYYOcpsqpeswn0eZoV/zWV48RVTcZnaXgHGss4c61yycTWCu4bXLJxDsR7IWL3zQsBJbj0vU9LqJ+Ko1xJIqBeS3IPhtpJxjnHXi56Xpzeiw2AoV85sVrSqVk2E6//PKhsRPo/mCvsL0lcutKMMT6cPZl/AIW3565gJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709007043; c=relaxed/simple;
	bh=5iiPrAKPBrHF9cUaTvJXwH5DqJj4Dbiap2vYQbW6n7A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HAIYDcALO+/OWUGIHLw7ns7XwFaP9BiYMpVwDD4xrfOjZrhQqp18bJY01QTJ7B1wow3oLl1UZ9puqhosxmISOTblSm8KHGJm1Ox17M9n59F40rS5067nVOv7X3RHEotWKvuxow4phf4NItgi0ehJ9Uy6mpiwvctItYs2ziSAt9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VWXS1DOj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ny/aqPIb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VWXS1DOj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ny/aqPIb"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41R1DwFF023344;
	Tue, 27 Feb 2024 04:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=mCvg8pH2eSxJvb+kb/jEt6UXHWgMwn73mNrmjmr9mtw=;
 b=VWXS1DOjw2P33lx0KaAcNRT2aKcD215jGygp9jLvau1zJCI31JM+9Mf6vcbFwTruGCkw
 RaomKp/DTAxEln4pXpOHQFzRaQFACYpVFgzNw/JMjjeWqoHgCUBAUH985wpO+zhvucVS
 Ajt4vcfGFoRinFpYSfxLUwPlj3Si1G36ZWE7NNHqp4UhnARlS8md84fhByNsCEGE6+/H
 RZhlLdEzskNqqbBp2aVM2t0/25pkUtE8Z1AxF7vKSgdRtuA0JY+xFRaFKvQ93RD+ZF8x
 VTDXl1xWfL9ZXlaE000JkndEgQ8yzGZvN2dPPoEomGYCgjd5L7JVl833yymmQCiI4SYA dA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf784e926-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 04:10:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41R2IeLS022880;
	Tue, 27 Feb 2024 04:10:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w6r2c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 04:10:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5ELp7n4pPzx4TUY3EVS/CJDWlJtljaWc7juzCytQq0m1wQz+CFmUQDSvZiAw1mACjlRkor6mWj4P5O14cQGVtdz0dH9FUsaVRuOH8EmeAodBGKX71M/R1CL3XeZYf39901Qtn40zzVlcQ3E24mhprRwSFnaBBjT+1lTJwmWuYFarOteTu9abAxmrxfqW/ZZuMtPzwLUvAs/w7eFD3mnR487mfh/rmxuFtc8TT8Rpxi9mtRbYv8/lXSTtk004ktLH9OltPldLfKF/1o4cogsnXhPTmzZBkCh0A60imQPw2Mxx14hAOva8K1MriFb0AfFsubcW9LrOU6hdiaSQID2rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCvg8pH2eSxJvb+kb/jEt6UXHWgMwn73mNrmjmr9mtw=;
 b=cK3BHTaWl4jiDa2ZJ14Jx6JuaPOMBYThWRttSKlczXSGD+6YHRMOusnaxYAUXTDDS8emYOj3040AX6B2Mk+AqIyPbIy3/9XucV/mjcSX3B/GW/uRzYcBF7wyU/finMngnZU4DLqA+0XbahXQOFmsYVM07upEyUr4ZPVuN4APtBPm7oJhfPPOtFW4oBUms8jGL5Z3e1RRFfX7Qc2ITpwM5Gq8SQOTIeB5oMTck2JljBSA5YrzBMluwbHSKMbNWC1MLohsSt8n4TeG9nhzdOe0zPXSjNKFvrGZrtApOor1DvhKVRnt/kv+wGlZUF1h0K9FItsjzs1dHLXPv+xuqnKKbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCvg8pH2eSxJvb+kb/jEt6UXHWgMwn73mNrmjmr9mtw=;
 b=Ny/aqPIbqhqOq5mMRB9qwVhRnm5Mbey//DN6nHTORCa76ZCGzX5EDwDcpTa01cOzd/B9axcoKK5WRTMbJdgEuIVIrfgMqsCEiIqxqqZ1tRjSPMkO8bn6ujjDpE9k5DucTsqOGmtbcKNdeIA23JvAieByD7Z+2+j/Q2VZVa6p9sc=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by BN0PR10MB4886.namprd10.prod.outlook.com (2603:10b6:408:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Tue, 27 Feb
 2024 04:10:33 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 04:10:33 +0000
Message-ID: <ab54f48a-2dc5-4270-9f83-5eb23bfe7c42@oracle.com>
Date: Mon, 26 Feb 2024 20:10:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] qla2xxx misc. bug fixes
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240223074514.8472-1-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::6) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|BN0PR10MB4886:EE_
X-MS-Office365-Filtering-Correlation-Id: 0747c5f1-1555-44f0-0073-08dc374a0b0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IA+khqi3IdSCIBzEa5cRHe6/3d+kh+D3JxbkwQkq7wc/9oGg/2OY3LP2f1qYICO3VRPPs2L6NHpdMHhit/JG5akrhM+HGY4IyTULgMKsNs9r9Jt7knpy8F9rm8uTPn8BHar/y0K0Fcc0iS9j/csWS/OTIGJ/WOrFsndtzmIzyNqf8kQUCeHvmzK/OFN9YvNyzLpdI9IQZpmx4N5CONyv4r7ru/DwSPHVd23QoRFJ+X70fjihrNtizX9dYHrEjFsaMNFxND445svs4tQQmBReBx8n633vfSPZsOd5mkX+z79+WTN8VRjmsI3F4h+Hm5VR4+rM49lPIH59ngB94r1blht9dyQxAgtmM2BJLno4Xd4oYGyyVQBbf5geOnmV788/3RDP3sGHhrOFmY4Cfd7vUFsiXZVFkjs3XkLMb/DczuB6SY16b+3Geun4DIB3DwYfb2MgQVDEkOvxwUYy6HcPZpf8ITpuG9x7x1phnBC6JoApkMfI3rOfg7roOjOpXIK2jDAsjmSHPCRykqxcEA65U1LmAvnyvv5H6Rdal62TUnpgEvfVP/T1nyBRyvCvl2/jW3rdGcwhjvt8O1fI6ZFwRsK+CPrhH6V1JEjCmrXTY0Mv8Lh0oV6y/WQgrVMahpaLDKHJVcVp6VxhR6yzPyMup1lPbQ8BLm+a3sfRvOQ6yAU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MFJlQXQxdWlQVXJteFlqazZhRFFnM3YxQ0VXOHFmT1ptME50QlBjTVlvS1Zn?=
 =?utf-8?B?ZWZNVVVjWnVFVEVOSmgwT2RwODhteGo5emNVMFVveXBOUXBaV3RVbWJhcXFW?=
 =?utf-8?B?Q0hZRTV3QzJ4dlJweFprWWFoVWFON0pQNXFUWWdDUHVCaGVNa1hTbXBRMnRx?=
 =?utf-8?B?d0ViMTVoRDdxWWcxeVBaeXNwQjBza0RIcEY1STBWdEMrNldMWVpzRDFIUWZS?=
 =?utf-8?B?VWM4M0FQYm1VRGt2ZTR1LzlObHlnaXpqK3ZBd3NkbUdTa09naUxXRzJBb3FK?=
 =?utf-8?B?d1dSYSt5NVNjR2ZrdTRvNisxWWZTNEYwdHRocENsRldlWWwrK0xZdXJtQlln?=
 =?utf-8?B?TkNXN1NjUnJOSG9GK0tiTzhqNm5FNmhaeXlheTE3d3VuaUJGaEc5OEEyYmxL?=
 =?utf-8?B?aDNLVElvVE5pbzZnRmdjSnZ2KzY4Qm1HQjJSRDZ0MmRNdDVaWFRtb3h2amww?=
 =?utf-8?B?T2lqMW55c1RzczUwcS9Rc3had0pTbU5LYU4yS1Rhc1ppeGs4eWMvZ1YwVTkw?=
 =?utf-8?B?YXYxODAzVkxxYkJZaXhTNTRBUUdwZGRocVdlV2hhRVJCVmdIdjN0UEhOMEV6?=
 =?utf-8?B?RUtOYUtORjRhelJHbnBUdzg1dG95U010OGN1TlR0ZSs0TERFOUNpTldoajFZ?=
 =?utf-8?B?b3lyR1I3cG9iMkM5V2R3OGUrWkFHRlRISHU1VGJoc283REllSnRuWlBaMzNE?=
 =?utf-8?B?VENLbWptaGZuTW5JcHBDN3crVHVTVnZZRjBFc2hJeVErNkxvbUo5OHZsWFgw?=
 =?utf-8?B?SHNFVW1hZFhNeVNla29lV29rZk0xRHN2Nzh6Slp1TlZWazBUNXBVdGFwTlM4?=
 =?utf-8?B?VCttSVlQemNmNTFCZnM4RXVNV1VFQ0x3Ym84S0ZLM1VkL2tPVzg2K2V2S294?=
 =?utf-8?B?aXgrYWVWZmQ2aDA4N0hzT0MvNDBCYmVrSGU2OFkvN1VPYXQxTnZnc1U2WEtm?=
 =?utf-8?B?NlRiSWM4TEJYYitCVEs4ZWdLS1E1aVk0bUp2S2JEOVdaMDJGYkdiTTdjSzFq?=
 =?utf-8?B?b21ucm84d2VFYzlWWENYRCtDYWxuU3BmZzhBU08zTVNiNzZmNXBTOE1uRyt2?=
 =?utf-8?B?ZVRvclFQZHBGTXZ3VENoMjM2WmZPTGxMcG9jeFBobWMrVVpXZjFQdlRZclFq?=
 =?utf-8?B?SUJVTHRiRnF1VU12OFpLMGVUMVdDRURnUkhOTzR5KzBpK1Z0RmJkc2JsVFB5?=
 =?utf-8?B?M2h1b1JLYVpKWjBSRXNGME1taTJzbE9NVlVDbXdxT2NESjNmNDJpb3RzbkVj?=
 =?utf-8?B?T3hoYTAyQytQL1EvUmExaWdRdWJrVmdZemwvZTcxYjVuQkpVSGZLU3AvMzRk?=
 =?utf-8?B?K3R5ZGNnTk1NZmJWYzhxWFZCb2FPdndSYmVnQ1JBVjhHRHgyNVQyNktCVDZv?=
 =?utf-8?B?cUoydzJNSzFBcTlUN0VIRVA1MlpKU1k0cXUvVnhoaXNKeHZEaUNhTjNidThs?=
 =?utf-8?B?UkFzVjU3Y2tNdUV1WVN3d004dFQxZ3o3VHB3Wkd6UlQ4OFNuVDVRRnI5cnIv?=
 =?utf-8?B?bHoxeVFXYmp3bWhyYVdaOWdYcnp3S3lSdGxjQ05WWERQcms1aHNPY0QzV0JB?=
 =?utf-8?B?UUJmSzZRNFVXSG13aXgvZnpQTlFJb1daQkJDdFJ3NDE1YmVuVVZmcUN3cTlr?=
 =?utf-8?B?T2JxNGF3S1NVTERPcU04Z3VQbm96VFlpREJMZGxGRmVOMVVmS1VicjkzWk5t?=
 =?utf-8?B?UGNXRnAyN3RpVmVEcjVoczhsVGQrR29zaVJvK3F3YW5EQk1rV3BVSjBteHFF?=
 =?utf-8?B?SUtUcVpabGlOZDBoejZOcDFFQ01wTGxXdm8wK3hlWEFCZEhtbkVaWEhVb20y?=
 =?utf-8?B?Ykc3TlIzaHFEdmdxRmlZQnZQUkJ1NXpFN3NsRXVwdHRnL05ENXZ1V2l4S1du?=
 =?utf-8?B?KzhYS3JSdE00Z3Z6YW5Nb2xNdm1DbHhzaVJQbUFKNnlzR0I2YVhOZDNDODhr?=
 =?utf-8?B?QzRYL0hpV2lPdlVERjY0NTVveFZ1YXZuN3RxN3EycFM4T0dOMU9jYkF5dW9P?=
 =?utf-8?B?WEtHbjdJNHVCdlNuWWlSRWxjaEFmZFIySzFTZnlHZTdXQUsweHpEN2d3dS9V?=
 =?utf-8?B?U2pkcWUxOUpYUktkVXBQNnJtZ0RQa1VPckF2M2Rhc0xVYWpUc1l5RTc0eUZm?=
 =?utf-8?B?K0hoNUpBVE4zRGdhK0FaQktBYkFzR2EwT3pMZ2lrVHJsM1RreEJJL2Y5Rkpv?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BIF1wNdG/vbfHOT+qP8X7+9b87jRdbeDkpA9IefMANxq1kkoqd4lWuT6IjpFPzwN5nQd1zdbXfmzE5h78wXqUuUg3mcNYgPn2qJOtWH4RjFfwmc/JuWGjs9Rk2qfMzrG26WL0hT4Lx/X9vJAQ6v8qIYhxNzB0lapQsLSMu3Y4a0mYDEP2lJcv/HfQuhQVOlAObRjtG96cohb/DFJ5nIDzjDLCpHWfN63xd+zPSkNwd5hEtwKCKBDTlC8g2+VsTszkfyoysKYUCkKILmxaks+hQmyShc/AZpuh0t/rZHxEq8Yxo/KPha4c6kr5fWIaBdx2VFYbId0Iwzfk1EtodV7+4IQkcfvu0ykrEk+qUBI2w/JSnwdPWdnd2fFtgV4DrC7E83X/wDD18kNx8QPZqEdp19Iy4FKL2RTSLZwZdOGgGryUExcD+OrtJxOOtifII9u27eD7EqUdl50IPi2WZpHDH58qwq/Jctx3FITc77xiZJ4Apq6cLZXFSz2Z41zjB7bFNs3ygIROcdTw5Jk54SyMuaeHdl9ccV2eLWbFcFMlk/2EjHYupUVToZUIB0g1azk/6K39Dvgs98dHyhU6SWVtyDUN+GphKbPAfRV1mw6gdk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0747c5f1-1555-44f0-0073-08dc374a0b0e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 04:10:33.3818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCWm4WLaVXfJ5TigRM6F3zVJWlPJJJd9QPivqd9fIFae+XGibKu2g5fLd33BBSPsK9HgSR1D3PSDtnNRGlNSFun9w3/0ukCJQU6xPfVeQS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4886
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402270031
X-Proofpoint-GUID: 5cyapo33qh2IcgmPhkUtML5KC648qeHb
X-Proofpoint-ORIG-GUID: 5cyapo33qh2IcgmPhkUtML5KC648qeHb



On 2/22/24 23:45, Nilesh Javali wrote:
> Martin,
> 
> Please apply the qla2xxx driver miscellaneous bug fixes
> to the scsi tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> Bikash Hazarika (1):
>    qla2xxx: Update manufacturer detail
> 
> Nilesh Javali (1):
>    qla2xxx: Update version to 10.02.09.200-k
> 
> Quinn Tran (6):
>    qla2xxx: Prevent command send on chip reset
>    qla2xxx: Fix N2N stuck connection
>    qla2xxx: Split FCE|EFT trace control
>    qla2xxx: NVME|FCP prefer flag not being honored
>    qla2xxx: Fix command flush on cable pull
>    qla2xxx: Delay IO Abort on PCI error
> 
> Saurav Kashyap (3):
>    qla2xxx: Fix double free of the ha->vp_map pointer.
>    qla2xxx: Fix double free of fcport
>    qla2xxx: change debug message during driver unload
> 
>   drivers/scsi/qla2xxx/qla_attr.c    |  14 +++-
>   drivers/scsi/qla2xxx/qla_def.h     |   2 +-
>   drivers/scsi/qla2xxx/qla_gbl.h     |   2 +-
>   drivers/scsi/qla2xxx/qla_init.c    | 126 +++++++++++++++--------------
>   drivers/scsi/qla2xxx/qla_iocb.c    |  68 ++++++++++------
>   drivers/scsi/qla2xxx/qla_mbx.c     |   2 +-
>   drivers/scsi/qla2xxx/qla_os.c      |   3 +-
>   drivers/scsi/qla2xxx/qla_target.c  |  10 +++
>   drivers/scsi/qla2xxx/qla_version.h |   4 +-
>   9 files changed, 138 insertions(+), 93 deletions(-)
> 
> 
> base-commit: f4469f3858352ad1197434557150b1f7086762a0

After you fix the warning reported in patch #3 of this series… you can add

For the Series,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
