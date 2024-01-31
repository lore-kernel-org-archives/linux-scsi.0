Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDC0DDD3
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706669069; cv=fail; b=thNfdeYBSML0nGvUjMGVp0ykvKd0+x7hEl8vfbQx7x4YL+siLEgEXf2KVQN2ZwltXGE0em0D8Hld2/kchv5TsdBH7JZ/f+kbK5cOlt2zmm2d7lADRlXuOSxTeXOON3D/z3M/9HoFvgWJ0CjdSSwR4r0v1m8hYTdtT5xsCv02h5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706669069; c=relaxed/simple;
	bh=srKnv86UEAN8LZVxjguDKUd9lphG7g5tCXfLew4X9XU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LizqDkoqvQReEjjGVGxi4LN6wSHEIiyBHIWhrWmWWestwPetVvYdQeEhPFc3raHSdjU8en0qS8qo5S4X5V7XPI3hHTXZ+4VHJG8rNe/yce5k00Tgsgld9fgS8noj5zqbm1T+i+XU/R4ZTDcqyOAIQbEjbhchMjvz2pIjYSwl+1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jTWCDF6N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hyRsZEMM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jTWCDF6N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hyRsZEMM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxjPn030549;
	Wed, 31 Jan 2024 02:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=TbyTUKuY0C8/CaQJm6ka4eLUACMDBbwz9F4lIycYotA=;
 b=jTWCDF6NEQzUWdLOB+ek7Ln3mn65rCG0PL+bKUfULTpT8wEuLG6Ag2y5zsvkyPB7oePK
 ZKYR+tjm3BYxP94N8OAnrrPu52d0ZSMiGC6OmPN/pOP9/CaCrjLgfEDWmq9hMeEm4Q8a
 K70wTmso7+9DXHFNWbYGCGDz7NX91BNydsbIUbReZVkM3je3fHxHsKCUQruu7J5A5Mct
 C8EvTbWmbs/QAUB3jzOZ2re2CkP88D/NA80nVMMOfyDVmOKtsU56g0OlHrLflrHjbCTj
 Slg02cGPxVM2CsCQOE3HE4Tnj1eiVzdAUV3W9Qdfg2jpJg7cTts8ZT87hIrkVeprjaFf Qw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0kwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:44:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V2PHNf040253;
	Wed, 31 Jan 2024 02:44:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98cpmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:44:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+8KTUVSfgvw+I4vCW5VTesPoY7Cw+la+dF85OBdQWsmni+s+rG2yJKUv3QXBvKhCZDtydHzLSXyIp2GVo/tlT+EKgVtyuCZbSUu2Bm4ZDO3dxy9REPiQXOVBIy1F6ELeAyN16zOaY+fn2TRdpmbDNdv+4mlqfE03lmvBxBOAyB30bvK/WS1/wZaT4Jv85Qp4ek0P95Fk4kZPvi7uj7ESWGsvuGvr3us9py1cDYK25MtAM3f2FwEPFUq8klIB1e54VgyTYyzEyTVn7w3shWfWRDq2IVPoofPtSY+KADlJKWKxNcEqLdsD48xxWp4TsRiqtuxD8gwowBsf7NCBD9hLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbyTUKuY0C8/CaQJm6ka4eLUACMDBbwz9F4lIycYotA=;
 b=TbO2uqpqrPk4lGC2QwkcvL16qyzYYFn6atMz/UWaRXpGbYkw+0vaVvnHIfsnRzI2Pk5xWwLZQW8viDrEuBqqUk+fiSG4ecOwpbyO5dwfS2A3jCdj0/MbZY6h0qxoh6xh2WZL4C4GILI/reSYE/ni1KA6O3Z7pLlltfl+CMxHF/yJC68RzoBYJ9jb4DuftvWWm4W93FpHZ4kegsSxk2LAzyVn9EEz+LmUn+vjbEz8nIMn7QgxiZ0AA6IUWXxeK5BPGkWkiqlaXweipDBXuzDw44DTP+l/3QaBw12wR/abijhdcTBojhp8rBz7PiMPjZ7lkUQuufPXziE98h/voC3NNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbyTUKuY0C8/CaQJm6ka4eLUACMDBbwz9F4lIycYotA=;
 b=hyRsZEMMyGLl7DaoOGezRxcZEZ94ghV0Zk14a+nCfOjDVc17sTY9CrO92wlDmHF4RPsNJ5qSMvwhcE10lkG6b/12K9JaJvPLXi3NT9WaD6+lMHLx54hqMTkHNlbpWiXhzPAlncr9hKlKX6k331qxm1JBteqjAXNi6PnyCXge7f8=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:44:14 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:44:14 +0000
Message-ID: <ea847847-c3b6-42b7-9403-3a9db5017e6c@oracle.com>
Date: Tue, 30 Jan 2024 18:44:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/17] lpfc: Change nlp state statistic counters into
 atomic_t
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-13-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-13-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:a03:338::25) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 93626553-6282-4c3b-df86-08dc220682f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CBZwSGa68afxpG1e59KHvUPhyF4pt17qhQbB5jwqlYEhk/4iFPoKBXcr8CyEPIQZOKsO+e0M3MhADHX0YIAS563HgHPaFfmOo2ci8UCnB8CsXgS0Av2F868GZ48ESrL6EIK99jLJLgiXNJmNy9TPiFSaxZcrKoAVMPpiIp9Reah4v2DEMYm6Dd3pbzKl/gloio7Go0pd6/rhT0Z/fi8LlT5zJjr0U3cEsuGeuaceFQ8kfEMYfGA+KhRQ/wCMKP9aORAcVo3/qWaRJQda+nkeHLHX7OceHRnZNwHV2lbNQIE9BJeiQvKSwjXUWh8tojtnqrBdNKtSI0qo+v/TclW1G7lPg97keygF62AHtCwDpoPjSIXaxk2+iQNTcu6f1P2WQnlT8yiLozUVoBbUDOz7QfFwnGdU4K9A670LC0CAP5W3E8Eb6CKsTB1aD8PR6jNv7Rar6PQoQQQaqDpRR0ZSRqfXwjgpX+TnB75uusj2MRkvgYP2ZhjDiz3QVk3RMByar91Be984dGnEi1PO5p6NAAyaeSBG5hNKj1jRp1KxrzO3vyDjvz4G3GBhwZYUP4u3Xd6DG9C4+UDuvnBoPa7lpov1PIgJmFMgYFMedd78z5vWMrWBM8Q/3kViihEHgFyio+jLe6HrzCS+NZjj+2Unrg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(2906002)(5660300002)(36756003)(66556008)(86362001)(66476007)(66946007)(83380400001)(316002)(31696002)(36916002)(53546011)(6486002)(478600001)(6506007)(26005)(6512007)(2616005)(8936002)(44832011)(8676002)(4326008)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cHdBQnBET1JUcWNWWDV2NDQ4MzlLdlpmTnhFSndUNit3WDVMMllKdkJCL1BD?=
 =?utf-8?B?RnhoOStMVlpmNXNkMXBaODNrSVBLN1Z0MTdYbXBrVzcrMmQzUmI5NmMyaVIv?=
 =?utf-8?B?cG50Z2NNQ2RRUnV3eWFoREFWU2NKVXp0bFlPUXV1L0JXMVMzcEJ4MVpUWVpN?=
 =?utf-8?B?d0F3NCtTbTNBWlArL09LWTArRnBtamRCeU1LeEh3azAwaVhWZmZWbFRJdDZ0?=
 =?utf-8?B?S21LUDFidlhVQjAxZWs1R0J0UWlpZGJHc3lHT3VIaE5FRTMrWjZSTXlFNWxG?=
 =?utf-8?B?VHdWNmloN1VGakkzejZBdlA2T1VwRWYyR2YyWmlmM0I1RUR2TW9aNzk5MGtG?=
 =?utf-8?B?cVBsZWxZUjVFUlllRFFZRWZHaXYyWjNJbktKNnFPSDRTdGl5b3UveWNpV0F1?=
 =?utf-8?B?cGhpYnBsYVE4aHNBalR6dHVlNHorMVlCU3NZdmU0WkhqYk1MVVd3ZEF5Vm9u?=
 =?utf-8?B?WE5hZkZBSUR5WUZrNGVsM3ROZ0krNzhLOHc5SlB3bW1TTy9rRThnYnZxQ1dl?=
 =?utf-8?B?VnZPWlB1eDVhS0pxOE1ESHdLQWZ2SjRaVk9YNUcrM3poMjRRclErYzY3OFhV?=
 =?utf-8?B?bVBDYlRmQ3NPcWMwaFYzY2QvTE9WbDN2TS9uRytVUUVXYXE1cDdzQUZuRkRV?=
 =?utf-8?B?RTIzMUg0TGt3TTF5SmxLS3pueGMycmRwWTlLUjZJbFFwa284T0hCRHhnd1Fk?=
 =?utf-8?B?Q2U3bTN1WnBlOTRNdjBlaTA0eGt4VTcySmpTQkFSbTZ5Tk9NNkdNL0M3T3hi?=
 =?utf-8?B?UVNtTXE0MHZlWXFzQnhMMW9Nd2dxbFAraERveVE2aTRhZ252bVp2NFl4ZFpq?=
 =?utf-8?B?WmZ6U3F5Zlp4Q2xzMFZhSXNxSDZ2L2o5dDh6ZEIrSmVwZjV0MUxBQTZpRFFI?=
 =?utf-8?B?ZEs5dExWSVpjSUNKekN3dDZYcjNSYjRFMDhiSC8rdTgxeFNGMGc0NERKblFB?=
 =?utf-8?B?SWUxZlB4SDB0d1EzamR6amU0YVFYSFpoVXd0ZDNXbExoSDZmQXlGMi9vZzFW?=
 =?utf-8?B?aGtRam1QZnF3SnlSYjd6eFRvRUJ5cFhrZThVY1JTdEJzQjhYcFVOZ1BEcHdD?=
 =?utf-8?B?MER1R2RUelRwNi94dmlpYktOak55ZHZoell6NXlrdGNDL1RqNFl5cG96dDVC?=
 =?utf-8?B?ajlwckd2NXBxZVdzeGtlN1Y4T1JYWk1HWUE2ZlVQbW5JZmkzNDZ6VE1QQm5W?=
 =?utf-8?B?cnZYQWtCMHFNdFV6TkdoSmJwemE5b3ZHZEJaVkNEeVBYZTlKZ2theHFXMEJ5?=
 =?utf-8?B?bTZQUENIMUQ5Uk9MRnYvMVFwRXBId0tEaDNiRmU4WTBDUzMwU3YzOThjK2to?=
 =?utf-8?B?cG8yaElvVjRPUFo5dDkrSjRmN0FOMUVTRFYvVVdwckY1WFV1MkRaUkE0WTNs?=
 =?utf-8?B?TnMzWnRxMUFvaHVIS2R5U3MrZGE3eEUzRVBNWnd6MHhsV0hRRm9GNkxCbnJm?=
 =?utf-8?B?eG1UQllwUGNWUVlyaWFiNm5KNkdGNC9hY081VmI5YXVOK2E0cEhHZkx5ZU5o?=
 =?utf-8?B?TFpTVzhrQ1ZqYWdSTGRDZENWaXppK0I4SklReEFYUFVNQ1hzMXdvQ20vcnBm?=
 =?utf-8?B?U1ZzZ3JVYjgrY29tWmNTOVQ3R2tXZWpMSU0wSHNjdlI0OGVUOURFTjJUaGxO?=
 =?utf-8?B?My9nbEp2Q0ZpQnduUVg2Z2dBZndoV0RqVzlDY01jM0RyalpqMWNJVi9YY0VW?=
 =?utf-8?B?THA3bHNjMm1ZSXJPcXppWGpSQkFZbkp6cERDZHd6cWFUU3Q3YmNvRk44UTU3?=
 =?utf-8?B?NjhpNHhSQkJ4QzVscHh4eUsrOUoyNlA2Q3EweGxuOTVMTmNZUk04WFBjMXZ3?=
 =?utf-8?B?UGp2UEtlYmd6Y2wyM3o5SDdHQW1tOWhQK3lCUllSVTNFTjk1bi9rbWVJL0dU?=
 =?utf-8?B?Zk5Bby9HeW52NlRDU0hNQ0Vnd1AzMDhBR2dYUUVRVms0NEN0UEVxcDdJWS9V?=
 =?utf-8?B?eXRtYmJpOWR1NTFVaHhwaytsVFZSTVpoWUY4RkloZ0l1UUtWYTZZUE9JZDV5?=
 =?utf-8?B?Z1VuZlpLbnozSVd0VE9aQ3NYQVdJL204aGtOY1F5V3hPbVJlQ05KSENBKzBi?=
 =?utf-8?B?bG51YjZYNGlReGs1OVRDb0Z5OS92NjJUdEVEaEQ2ZlZiT3o0amd3SWVJa210?=
 =?utf-8?B?RTdhMy9zb1c0QWJkUDV5YkpNejVHQWFmbVRVbzY2UzN3Y0J0Q0VSbFpSVVdY?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	X8CCYe2S7zAdmTlqgDCrQoUqcBR4bVLGMVIpA4fHOmSlSYA/+xRITrJMSnjHkIVIqXyh194R2y98sTw8TpawqlOyU0zRkMw/3n7QYKDFpjYEVBe3cP49gq+qlqf8mDCv0PN110J+FbqQzy6AySHcR7Z58b9bTMoacVvhCmhFVAiDwYWQEewwtMCtnKY34bADi1yFVG9jiXPYVPhRSIrkg8e4+7Tv9Wq18bnzIGaO4U4cgI8Rdt1XDfnSK719QFQ5NPHeZPuQkFntJ/w7e80UYW5JPLViUif3Or9/8BWQHv5qAI9Y38of9pWc3zRTSgU11G+BeB8hxCIdnc6xjDOV2oTLRTdAbiHElm94e+Yosh6MA+7Zcs+VGI13bUz/HbnwSqIQwBKQ4SOBuWW8qA6osW9wbqcIhqrOOjhwbm53YY7Xe9rAkIA2UI7XnkxHcyY6/LmFUdEpKsWTghxNtlajLmpCQpL989DRMf+hFPva8Qyr5XXYAIuUKBqoI0Ggt4fCXPMKtI6aiQL/lxifCbkW4gxiNgzgq3UldnMizfe7KqB5qxn1JVFbM1MFIbwGGycIGZeQjfXoRn2b04fFeTGA+OCFgUPc1tmAE8wnFVJ6f4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93626553-6282-4c3b-df86-08dc220682f6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:44:14.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wo+v93X99Ma4VkWPzrEq/bwUaGFz0pgXnW8FJBhrouh/kfwTUIW3rRb5Sm7wNShh5/JbCiO+wolGqvpMhDNGEmEeVOyNFNLRStMTD5fgbUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310021
X-Proofpoint-GUID: CtV8FLnxTf9BDCOTg6KC1sAV-LQFAOWq
X-Proofpoint-ORIG-GUID: CtV8FLnxTf9BDCOTg6KC1sAV-LQFAOWq



On 1/30/24 16:35, Justin Tee wrote:
> There is no reason to use the shost_lock to synchronize an LLDD statistics
> counter.  Convert all the nlp state statistic counters into atomic_t.
> Corresponding zeroing, increments, and reads are converted to atomic
> versions.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc.h         | 17 ++++++------
>   drivers/scsi/lpfc/lpfc_attr.c    |  3 ++-
>   drivers/scsi/lpfc/lpfc_els.c     | 10 ++++---
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 46 ++++++++++++++++----------------
>   drivers/scsi/lpfc/lpfc_init.c    | 11 +++++++-
>   5 files changed, 50 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 04d608ea9106..8f3cac09a381 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -589,14 +589,15 @@ struct lpfc_vport {
>   	struct list_head fc_nodes;
>   
>   	/* Keep counters for the number of entries in each list. */
> -	uint16_t fc_plogi_cnt;
> -	uint16_t fc_adisc_cnt;
> -	uint16_t fc_reglogin_cnt;
> -	uint16_t fc_prli_cnt;
> -	uint16_t fc_unmap_cnt;
> -	uint16_t fc_map_cnt;
> -	uint16_t fc_npr_cnt;
> -	uint16_t fc_unused_cnt;
> +	atomic_t fc_plogi_cnt;
> +	atomic_t fc_adisc_cnt;
> +	atomic_t fc_reglogin_cnt;
> +	atomic_t fc_prli_cnt;
> +	atomic_t fc_unmap_cnt;
> +	atomic_t fc_map_cnt;
> +	atomic_t fc_npr_cnt;
> +	atomic_t fc_unused_cnt;
> +
>   	struct serv_parm fc_sparam;	/* buffer for our service parameters */
>   
>   	uint32_t fc_myDID;	/* fibre channel S_ID */
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 1f9a529e09ff..142c90eb210f 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -1260,7 +1260,8 @@ lpfc_num_discovered_ports_show(struct device *dev,
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   
>   	return scnprintf(buf, PAGE_SIZE, "%d\n",
> -			vport->fc_map_cnt + vport->fc_unmap_cnt);
> +			 atomic_read(&vport->fc_map_cnt) +
> +			 atomic_read(&vport->fc_unmap_cnt));
>   }
>   
>   /**
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 1ada8ba6cc2a..e01583e2690b 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1646,7 +1646,8 @@ lpfc_more_plogi(struct lpfc_vport *vport)
>   	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
>   			 "0232 Continue discovery with %d PLOGIs to go "
>   			 "Data: x%x x%x x%x\n",
> -			 vport->num_disc_nodes, vport->fc_plogi_cnt,
> +			 vport->num_disc_nodes,
> +			 atomic_read(&vport->fc_plogi_cnt),
>   			 vport->fc_flag, vport->port_state);
>   	/* Check to see if there are more PLOGIs to be sent */
>   	if (vport->fc_flag & FC_NLP_MORE)
> @@ -2692,7 +2693,7 @@ lpfc_rscn_disc(struct lpfc_vport *vport)
>   
>   	/* RSCN discovery */
>   	/* go thru NPR nodes and issue ELS PLOGIs */
> -	if (vport->fc_npr_cnt)
> +	if (atomic_read(&vport->fc_npr_cnt))
>   		if (lpfc_els_disc_plogi(vport))
>   			return;
>   
> @@ -2752,7 +2753,7 @@ lpfc_adisc_done(struct lpfc_vport *vport)
>   		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
>   			vport->num_disc_nodes = 0;
>   			/* go thru NPR list, issue ELS PLOGIs */
> -			if (vport->fc_npr_cnt)
> +			if (atomic_read(&vport->fc_npr_cnt))
>   				lpfc_els_disc_plogi(vport);
>   			if (!vport->num_disc_nodes) {
>   				spin_lock_irq(shost->host_lock);
> @@ -2785,7 +2786,8 @@ lpfc_more_adisc(struct lpfc_vport *vport)
>   	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
>   			 "0210 Continue discovery with %d ADISCs to go "
>   			 "Data: x%x x%x x%x\n",
> -			 vport->num_disc_nodes, vport->fc_adisc_cnt,
> +			 vport->num_disc_nodes,
> +			 atomic_read(&vport->fc_adisc_cnt),
>   			 vport->fc_flag, vport->port_state);
>   	/* Check to see if there are more ADISCs to be sent */
>   	if (vport->fc_flag & FC_NLP_MORE) {
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 35ea67431239..7c4356d87730 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4023,7 +4023,7 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
>   	spin_unlock_irq(shost->host_lock);
>   	vport->num_disc_nodes = 0;
>   	/* go thru NPR list and issue ELS PLOGIs */
> -	if (vport->fc_npr_cnt)
> +	if (atomic_read(&vport->fc_npr_cnt))
>   		lpfc_els_disc_plogi(vport);
>   
>   	if (!vport->num_disc_nodes) {
> @@ -4600,40 +4600,35 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
>   static void
>   lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
> -	unsigned long iflags;
> -
> -	spin_lock_irqsave(shost->host_lock, iflags);
>   	switch (state) {
>   	case NLP_STE_UNUSED_NODE:
> -		vport->fc_unused_cnt += count;
> +		atomic_add(count, &vport->fc_unused_cnt);
>   		break;
>   	case NLP_STE_PLOGI_ISSUE:
> -		vport->fc_plogi_cnt += count;
> +		atomic_add(count, &vport->fc_plogi_cnt);
>   		break;
>   	case NLP_STE_ADISC_ISSUE:
> -		vport->fc_adisc_cnt += count;
> +		atomic_add(count, &vport->fc_adisc_cnt);
>   		break;
>   	case NLP_STE_REG_LOGIN_ISSUE:
> -		vport->fc_reglogin_cnt += count;
> +		atomic_add(count, &vport->fc_reglogin_cnt);
>   		break;
>   	case NLP_STE_PRLI_ISSUE:
> -		vport->fc_prli_cnt += count;
> +		atomic_add(count, &vport->fc_prli_cnt);
>   		break;
>   	case NLP_STE_UNMAPPED_NODE:
> -		vport->fc_unmap_cnt += count;
> +		atomic_add(count, &vport->fc_unmap_cnt);
>   		break;
>   	case NLP_STE_MAPPED_NODE:
> -		vport->fc_map_cnt += count;
> +		atomic_add(count, &vport->fc_map_cnt);
>   		break;
>   	case NLP_STE_NPR_NODE:
> -		if (vport->fc_npr_cnt == 0 && count == -1)
> -			vport->fc_npr_cnt = 0;
> +		if (!atomic_read(&vport->fc_npr_cnt) && count == -1)
> +			atomic_set(&vport->fc_npr_cnt, 0);
>   		else
> -			vport->fc_npr_cnt += count;
> +			atomic_add(count, &vport->fc_npr_cnt);
>   		break;
>   	}
> -	spin_unlock_irqrestore(shost->host_lock, iflags);
>   }
>   
>   /* Register a node with backend if not already done */
> @@ -5034,8 +5029,9 @@ lpfc_set_disctmo(struct lpfc_vport *vport)
>   			 "0247 Start Discovery Timer state x%x "
>   			 "Data: x%x x%lx x%x x%x\n",
>   			 vport->port_state, tmo,
> -			 (unsigned long)&vport->fc_disctmo, vport->fc_plogi_cnt,
> -			 vport->fc_adisc_cnt);
> +			 (unsigned long)&vport->fc_disctmo,
> +			 atomic_read(&vport->fc_plogi_cnt),
> +			 atomic_read(&vport->fc_adisc_cnt));
>   
>   	return;
>   }
> @@ -5070,7 +5066,8 @@ lpfc_can_disctmo(struct lpfc_vport *vport)
>   			 "0248 Cancel Discovery Timer state x%x "
>   			 "Data: x%x x%x x%x\n",
>   			 vport->port_state, vport->fc_flag,
> -			 vport->fc_plogi_cnt, vport->fc_adisc_cnt);
> +			 atomic_read(&vport->fc_plogi_cnt),
> +			 atomic_read(&vport->fc_adisc_cnt));
>   	return 0;
>   }
>   
> @@ -5951,8 +5948,10 @@ lpfc_disc_start(struct lpfc_vport *vport)
>   	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
>   			 "0202 Start Discovery port state x%x "
>   			 "flg x%x Data: x%x x%x x%x\n",
> -			 vport->port_state, vport->fc_flag, vport->fc_plogi_cnt,
> -			 vport->fc_adisc_cnt, vport->fc_npr_cnt);
> +			 vport->port_state, vport->fc_flag,
> +			 atomic_read(&vport->fc_plogi_cnt),
> +			 atomic_read(&vport->fc_adisc_cnt),
> +			 atomic_read(&vport->fc_npr_cnt));
>   
>   	/* First do ADISCs - if any */
>   	num_sent = lpfc_els_disc_adisc(vport);
> @@ -5981,7 +5980,7 @@ lpfc_disc_start(struct lpfc_vport *vport)
>   		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
>   			vport->num_disc_nodes = 0;
>   			/* go thru NPR nodes and issue ELS PLOGIs */
> -			if (vport->fc_npr_cnt)
> +			if (atomic_read(&vport->fc_npr_cnt))
>   				lpfc_els_disc_plogi(vport);
>   
>   			if (!vport->num_disc_nodes) {
> @@ -6077,7 +6076,8 @@ lpfc_disc_flush_list(struct lpfc_vport *vport)
>   	struct lpfc_nodelist *ndlp, *next_ndlp;
>   	struct lpfc_hba *phba = vport->phba;
>   
> -	if (vport->fc_plogi_cnt || vport->fc_adisc_cnt) {
> +	if (atomic_read(&vport->fc_plogi_cnt) ||
> +	    atomic_read(&vport->fc_adisc_cnt)) {
>   		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
>   					 nlp_listp) {
>   			if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 8e84ba0f7721..1285a7bbdced 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4770,6 +4770,14 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   	vport->load_flag |= FC_LOADING;
>   	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
>   	vport->fc_rscn_flush = 0;
> +	atomic_set(&vport->fc_plogi_cnt, 0);
> +	atomic_set(&vport->fc_adisc_cnt, 0);
> +	atomic_set(&vport->fc_reglogin_cnt, 0);
> +	atomic_set(&vport->fc_prli_cnt, 0);
> +	atomic_set(&vport->fc_unmap_cnt, 0);
> +	atomic_set(&vport->fc_map_cnt, 0);
> +	atomic_set(&vport->fc_npr_cnt, 0);
> +	atomic_set(&vport->fc_unused_cnt, 0);
>   	lpfc_get_vport_cfgparam(vport);
>   
>   	/* Adjust value in vport */
> @@ -4946,7 +4954,8 @@ int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
>   		goto finished;
>   	if (vport->num_disc_nodes || vport->fc_prli_sent)
>   		goto finished;
> -	if (vport->fc_map_cnt == 0 && time < msecs_to_jiffies(2 * 1000))
> +	if (!atomic_read(&vport->fc_map_cnt) &&
> +	    time < msecs_to_jiffies(2 * 1000))
>   		goto finished;
>   	if ((phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) != 0)
>   		goto finished;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
