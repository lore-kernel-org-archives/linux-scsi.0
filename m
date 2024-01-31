Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2A0D294
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668534; cv=fail; b=mjxxEBxGd8jRKLZ/stJpkdyPkkSyUX7KM1IuYBosZXKKUb1OSNjAa2ef1PSAZLPNlxSxcJL3/Jfs6e3aNIPwECFkYKmKaFERyGqtPKbLL8RG/s8Yku50gnEzhDdKoSbM+jf/2SNJvSkDatGRrMbfFp3Bn94vXh40mfUymr26CCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668534; c=relaxed/simple;
	bh=GV5VstiKoLCBvPqpjmdHp9c4OQvCUktpE1JaI3hIkQA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GJqkJCmXpwPDYYiCC6Ysf+Zm+a6Mbim0QHzaIDy0Isbv+aKgOZZNYIX9LwwqOC/574q9Do6A3dtXVbhzzbFmK9j4zc1wWjp8YmgoxZVFrJGl6OASXUTa0bOxNd1Q+XqZtV/wjK9MED0g4klHwb3Q1GadvKxWHpVgf5e9nY+XNms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KHwuxP46; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bw5dFHN6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KHwuxP46";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bw5dFHN6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxunl030724;
	Wed, 31 Jan 2024 02:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=cy9Zy+Ak1P3WASBWkCa6keckyySgo/TijnfHoTowxRo=;
 b=KHwuxP46fwJPrA63bjpTxZHRUJzsj8B3v7uPSTwEDhqw3TpKmcxeOzaG/drpFar5sK5W
 hi7QZ+A+QC2Glv9EUq4Q2p+rpeWMT4aNgn6gA/C9pbEYCqbPdzodjhZUaPDYnBkhvEw4
 tFF/NQqp+nwJxvKZP8IEljWHPt1+PQak4fcqN3WJTBjPJumZNqmLKKdDcvE/UBHhBIKY
 YjthNvEGGj8WSfj2AoqQQ0w18A9iqIXCwgRf0M+yKpUa1TFa6SjPY6tarxlr76iuSoBA
 NsT7+UfSo81/24U97xhsNH45v37R4DPJz707lm6fmmD9UJ+jef8+O23I5dNzZj6M9Wk7 2Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0kjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:35:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V212Rq036092;
	Wed, 31 Jan 2024 02:35:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e5s03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:35:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TplrJDbp1fVcHqYS0rg2uYgLvgyXdsoOMqzOPIjqpH0kdz1nNBetB51vpd4Q4CPjORgJ711de8Z8SQgeL3sbYJ+oI8juitByTNRQ3+Zndver9eUWOS0BaquKFOJYzwwi83FhgQUTSqC7H23fCNPqOIM4lCNCsF8mrzX6C+84s39N6UpnU/eOlvPJCKCY8kZgjhqUhGRxEtMTkWrSNYlYqEtAGBU5FPfQ0ureY1nMpI9n1S+LvE2tdi3FLX8/VxmiYAJ1Wv6JBaP/oJi1xl/SQdgF4Wee/s0ovkIGYBdJyMT28NGYYajq5gx3ympGPyM/UdAQLtYgO+ABmXKcabNN0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cy9Zy+Ak1P3WASBWkCa6keckyySgo/TijnfHoTowxRo=;
 b=oarJ5QBpEDJbmrTREMPVCDH+JyhCTVY7OVO7Dt8SlozphyGtIZ0jOGsrHrCKZ85XEDx1LVHjb5NBGcJFdgor8jyfkOBRhnAqfXEwQRqHj8I4SpZs4NNMrHEkn2fU3cxWA4EswWk6tBOQUDT2q26e4TtISSrm+jRHNnCi+IQIjsu14z47q+B94NYcmss4a0zU8dXjpgksKv1tXLItJrvBEGOOJbFn9oY5IxP46XZZKbhnYfyQhocZcK/cfWyyjjjZCEcqWcS0WrUT16JhEc41tmrEOKlQqIApEV0+Ph1xNLAzOUXxX3KGoVh77djsVW0Hy9pS2mJ8YMfMxWuLEkNb6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cy9Zy+Ak1P3WASBWkCa6keckyySgo/TijnfHoTowxRo=;
 b=bw5dFHN6FJABGfHR+4m/2iJkNr48P28H7rZS8LUlrmuKHBK+6aLfNwWl3AshcP08gMSXHmh3AWFdGVTdg58oxDgq3hinooy5krETHXhxdqNFijlpJnIIxlO01yW1P9AUaKKIJUd+7dDfOy3cvFZBjaFN9oCjjiySDGG1xSy3ezI=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:35:26 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:35:26 +0000
Message-ID: <99bc83fe-6f9c-4614-8a85-7d18509c4459@oracle.com>
Date: Tue, 30 Jan 2024 18:35:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/17] lpfc: Initialize status local variable in
 lpfc_sli4_repost_sgl_list
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-2-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-2-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 37856055-db4b-497d-8dae-08dc2205480c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	aN/p3NOXXZv+U0kYLDYhsJdHSZLdUCkeBnBcsNBEtdjjP06FNAPPga9bn864291T3It6A+dnVSa2Qmffiu3WILgXmeGJ5MIRY62uSO8a3FtINcJz7yJ8wBCu2KlL5t+p7IQKW2bImVb4cJCfBR7DQm6AB8/k4UznanrEHxPz5kIhVOIy0dbgsjvQ1tIXhVBiBIdhqULMcHwEhb7X5PciTMjVdHJjL3zWdMPtcpPq8xKEAHp/htMskLKUZzPMRFpheX+1AN6csSptGCVTTcWGRak8dMVQKF+5LDygoWF7/wfBEE97XQW6GIikcD82UQBzZtIAfLzJ1SlikWpz5/F8WgIkh/nBxGfkajQv7YoP7n+Cl3TGNi17VPUFqYeAtgPufOHnOA6cGcVP6vg+KpyywIB5pujwhF3fbrcXOuMoo4yrrDIQMjXnV2ZDNE8WxB2MSGOyXnxq9fESdbzrbRzgHAvGDSbFSGnstYJmKfjxO0pDO5z+inKwnv8Vp5is1UKrfbzG/b1ptsfFq+piNFXgPzhuocmJRfGuyfObjvhD/sSdgKTEGEOOlPOkC6+pAMO9vlsIgugrde+6m1qUIT2pBn2X9LwCpt5IMqPRYd60yKQULSR1fY5ZfhXNLJDCGRJRPRR8NJjZkfMO1HCuTY/iKQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UU9uUW8vYW1xTmdGM0xhQ0RtZEp1Ump3eUdrNTY2Qy9XUUl0em1wY0F1cy9Y?=
 =?utf-8?B?VVJtZE0vSmM3Y0NpQmFjZ1Y2V1BIbnlLMjdPSW84TG9qRzlJOCs2MTdRMWlI?=
 =?utf-8?B?M3U1K1M2SmViTVA0TG5wMzhHMEIzb3ZNSjM0YXJEMlRCNC9JbGUwc1czaGNk?=
 =?utf-8?B?eW1PSDNadTF4Q3VaSDVoZUJybHRVVmZpNlRmWkd4dDV4TUx3K3VHUGl2Q1oy?=
 =?utf-8?B?ZUxmYnpyZldtSERPblZmblhva0VOZ3hRYWNYTGduUDBoWERNbVBvdS90eng5?=
 =?utf-8?B?ZjQxbjdWSVpSMHQzMVNnS0VBaHZLc1ozVVgrU1hDR1lCYU5pekpOR3hoS2Uy?=
 =?utf-8?B?cWZ2U1p2VG9xUVMxNmJhbVJ2eGhVV2VDNHEvbUN0VWxPdlJ4amJ2TWUyL1lE?=
 =?utf-8?B?b3Y1c1Z1NlZHQW1uWi8rYm1BK3l4K3crVmx5VEFQSlRzdThVK0FhMDJVMGc1?=
 =?utf-8?B?QkV6dm9jKzB0SWx0Uk9tbTVkYzU3b05VUzlzYU05TW04eVpMV3dEOFcxd1Qx?=
 =?utf-8?B?b016V1V1Vk1meXJtZUR3WkdMNzFxbTkrYTZzd2dLYWk3U0lrOVgvNnNIc1Jr?=
 =?utf-8?B?SkR6WnQ1ZGJtNHNXTnVjZ2JScUVYY3Z5eHJHRGhINFJ6TEFsTW1KMGlVWjE2?=
 =?utf-8?B?Q2dUVlM2dGZ1bWN6R1hLbnU5NnozMWtJQlRhTjlQWnZTeHFMWGo2VGt4M29m?=
 =?utf-8?B?V2JVRHFZNXYvMzQ3ZnJWRmpGNng2TElJRkhnWjNxejNzd05JanRWMVEzdCtY?=
 =?utf-8?B?SjhIM3FLaWtoZ0g2RDNna3htYTMwM3ZUTFRMWUUySUcvWkVrWXJVSm0xQ2xs?=
 =?utf-8?B?ZFdBRW5LZ3VsT2ZNVmZtSTdXUjd0N1RvbXQ1VnpqNVA0enIyQXZzdFR0Q1M1?=
 =?utf-8?B?N01COXZnQXk1UEpxa0hmZTF5SmVEMUhFbEY3ais1THZTU1VvMTBRYmJ5dTdM?=
 =?utf-8?B?aDJFMHlsSjFvajU1Vm4rSTBGbE5ydTU1QnQ5OHRaVkovTG0rRTFLcEJXMlRj?=
 =?utf-8?B?czV3KytvWnZhWDByOFl1anlSY3FsTm03dmdMcExSQzlleUJxRDV0aEoxeGxv?=
 =?utf-8?B?Ry8yazlFRllPMmlVK2VtbUNhY2wvWGU4N3J3TVdmMGhRNU1rQlBGMTlnTXMz?=
 =?utf-8?B?VmRZOGdDbUh5MDNrdHM2QWtqRmF3eEEwNEx1aTdCbzM3NGNEcGloQ0IrWndC?=
 =?utf-8?B?VGJpcHBzdmtlTSsvRkdZdTV4d2tSY3VVcHlUOVdzMWp4RzRDWXJlUkpQemJM?=
 =?utf-8?B?VSsyOGFveStjdmVYaWxxVnREdHA4MFN6WThDMVVkd0NyMHRjdXpUK2lKanFu?=
 =?utf-8?B?b3ZtSzloOTRkRnN2SkMxRG5DajBoTkVLbS9BSnh2VGw0N1IrT2lxZUYyU2Zz?=
 =?utf-8?B?dzZBY3l1dXVadTYwRTloTExiWmRkMThLVXZHalFyRVQ3bVhvMVBwWXcyZ2Zl?=
 =?utf-8?B?c1MzaXNmT1FtNGpQQ3FWL2lDNStTRWtKTUR1ZGM0K293MEVCUkRDYlh2MVpk?=
 =?utf-8?B?YTMza3o1c2NJODE0U0pGUjFscjBxaVZmdzE4bllWcGY5MGVQVGtxU0JOeUVF?=
 =?utf-8?B?UTlyUmNVQW5CeHRpV2s1Tnl0cW1UK2ZNMkJYTFlTQnYvMHducE1ZYVgzbEZ1?=
 =?utf-8?B?ZWY2WHV0a1I4aUlqN084VHhweXN1TE43SWxFOUZuWk1QTE1aUlJBWG9lVUsz?=
 =?utf-8?B?elM5MitRQW93V2wxeFUvdlNmRzJ3NnJRdEpSbFFxZEtVZCtUM2hNQTlrWWtR?=
 =?utf-8?B?NlU2Z0V0RU56d0I0Tzc3d3phSnhPdjlPZ3RnZXdwNWlyd0t2bHhSQnkxb2JG?=
 =?utf-8?B?dDhIVnJSYXFSaEtaVy9pRXFrTGtsdmxldFBYOWhQMitMOVZTSHFzb0tRRjlh?=
 =?utf-8?B?REd4RitJRzBTdEFMbW8vS0Z6L0N6Um85RllPUG85by9GR1hOaE1oblB3bjRN?=
 =?utf-8?B?L3VGSTdCelJnV2UrS1MyR3AxRjExcjdPNFF6NGVuSEQ0VWx0ZGZ1d0lhampC?=
 =?utf-8?B?UDJXNFJndWQ5aVNQWWdkUTdaNHdZTHhOMlNaZnM0WlRUUVFOMUF0ZnBVdWZK?=
 =?utf-8?B?RjVJUUtrSmtPZG9PUUw0OVJacm9hbmRQaUtJUXgrRnFTVFB3d0N0MTlPaDhn?=
 =?utf-8?B?UXBzYUdMZ3ZJSEkrZEp2SEVsSkpDaFZhSXRNOCtKNTR1cG5pMXhzRm5xUjhq?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	xY1HWIcr7WALDkM/ylLVoG86ZLmuzbgAqguGXNmG+gZDLWm/uzurhjLXUyzukX13Jw6dJOmQj8Un2D5gx8C5HX5dWYi5ShuVhykGRDxQ9KA1VfQWMaEEMuTn7Mkn4LTzGvHwICY6a/j991B1ni2JrJv8+ke0DrK3BAzESngJjl1cBWIy2nwWEVg24cA84rUz4MFqs2CaFB+z8aTyuvjTyqV9AVmNlcWE0oaiyxJW1EIBrgKARs3ikz60ekKEDafX7jwElOWKkZXm0Em+7yoqO0s/rDp3M+hrqU3+kvSOS9J22SEC1q2/XSNHVXoVuXzBjfRUlYHU9k/CCMG7G7EkHcyqHuK2nIgueOGVW8M+c5s30aHdMDiVTgCfRSzO93W0n/tVxWiKebSV2HTjGo/DSi+iJ7kYUD5aUti8aXOQ0cIxfKNgwfoAx0X7nsVyvWUJUcl5X2Tb0mZp2hUebDLJ4XyQhiXuz6T80dcnHHsHtFIF/VuWas3MpqlceMw2UOBRcJD+p083eJpS6P5cafnkZgJY+5wneWA/OqafcjpQtBdQIfxVe3Y2x4dxp8XQxXQJrORKisLjTAHytF8JsEg/Pn+Brvsda3sUCHGqtA7RPvc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37856055-db4b-497d-8dae-08dc2205480c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:35:26.0200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yuvH2BhYH5RycZx2poo/WeAasa6LoOfwQmybPd+lWullJXdcX+xbw3fFw7QxmsKc6Zww0ah95vvMDss9voLOZrAvkk7Hb29bUzvLcHW1ii0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-GUID: ipSYjmaGa-Pw1Y5h0h7-0WckvdG-Fvqr
X-Proofpoint-ORIG-GUID: ipSYjmaGa-Pw1Y5h0h7-0WckvdG-Fvqr



On 1/30/24 16:35, Justin Tee wrote:
> A static code analyzer tool indicates that the local variable called status
> in the lpfc_sli4_repost_sgl_list routine could be used to print garbage
> uninitialized values in the routine's log message.
> 
> Fix by initializing to zero.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 706985358c6a..c7a2f565e2c2 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -7582,7 +7582,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
>   	struct lpfc_sglq *sglq_entry = NULL;
>   	struct lpfc_sglq *sglq_entry_next = NULL;
>   	struct lpfc_sglq *sglq_entry_first = NULL;
> -	int status, total_cnt;
> +	int status = 0, total_cnt;
>   	int post_cnt = 0, num_posted = 0, block_cnt = 0;
>   	int last_xritag = NO_XRI;
>   	LIST_HEAD(prep_sgl_list);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
