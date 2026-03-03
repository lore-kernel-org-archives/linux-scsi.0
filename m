Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD658175A72
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 11:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772535986; cv=fail; b=u+7gK5AKbHb8CLYYTCbNiH6GF+vzaYB1WabcqWfdxPyBXIMYyKwg02Wq/bnO3MSJX8T/bBYiqNcIz23O8EKVM42JGFSoaU/4QLQFY0BNokc0SkZogBJfXd0dSHHp8LGzGVB+o+oWrSo+57uIgEqgtCsrHJtRxlrp4GtCTx0pRdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772535986; c=relaxed/simple;
	bh=kEgKN6Nmj0dgV18a6CJuG/ddn4+R5oFEE1kMhgz2TTc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gNN41hONnUOjQCZa+dkhLhMtScH77aPgXyWwMI76os/1/rWtf+cNmtN2qUddeLA3jAuME0urgef1gNpAgyLlVPZJAhxtilzmy6N5Mz7+mZQ16a6cJAExh2yGU2XKDkLhj8THQYH9G85xvc2nYBhigv03ifkNDpJY6patdyZBJzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U/Ubeqxa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Yxma/gOR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U/Ubeqxa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Yxma/gOR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62392Q1l046487;
	Tue, 3 Mar 2026 11:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8B5Ezamso3Sg2wx97ISTNr1R4GsfDr8vYBilfk4dLuc=; b=
	U/UbeqxaeHjoI2amcHGfHx5uG2vxa5TW0nm/tc8ydZGGQQwINpNUWGMeL4LzHo0U
	37biOHzCsjs1zMEERHTcY4dJJpyNRgCZaaT/v9chtgRlfxdl/vOzzWa9ABFsOfNl
	WuEFs3VQbnc1fR1cHyLYG84DqfKLlpeq/+kV7KHcBR9ePQ2v4o7QBYrGamhqptb8
	u0tkICPH/eQMm+mKq2oqWSKGqAqpRJBWtOJsiHE8FmmzVlixe18L+/8sLz1l+0Iw
	pMq5TpDLhUFvGcomevaEwi98bFxuAKijoaieNUf89x1JRgEvX6qk4E+6/OWzZxtk
	UxsNrQLSHJk8lWeJCoHzQA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnvnn85sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 11:06:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6239JqBC036916;
	Tue, 3 Mar 2026 11:06:22 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt9wt0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 11:06:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TJNTRCyOuMu0ss8GQy/zlTzozgq3qRcTqTaKkQXdn3dmnbwrIdNwnJ8uAu0frKcV04Jtk4gp1nfxJOF26+BWHk+rmvBX4FyuhV6x4CVHVWX5rwq+hrSp8Wclpu5hWdkr0/CREtSAeyRLqqx573wMUNJhbjQ04ExUXbYLe13Z3ZMfsI3ATu1ZxfY2a2MlrbjVNZ6dT/9RKOBltoCtWH7ZrZnX4MRcZJ3EIbnvmkSytztA6jz7oc9JgeSp0G+6GB++byeXVUuplhrlUbdKm8r+jQAjPAPV1/F/nkv42esSPTxgsWt5HUc5B2b+dODDUMZMte2T64VDkump8lYgH0Ervw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8B5Ezamso3Sg2wx97ISTNr1R4GsfDr8vYBilfk4dLuc=;
 b=cgDHuaPjU7nI9YOwj1bScrcrwjer+oDF13CmRaKi9ZKmE9Gtr6Ql/WXBN4UMOQpWIUeVR/gRKItw7GM/gfqcvBPQUxooANgILSRrgd09Z5SfJvZecUwZIljfdl/8Fkj7ko37F/RznS/0mh/T27pRu3Mg0bVf88cMq9wEw+EeM+uv7Dt3u5hA+ZTSOftP/6M348itCfnwPOqicOc+h+W6w7I4/N+ShlMjSFqT9KTorfS1/vCXjCtR8a3beHijw4bEVbfdkLvpfAUXSCfyuE9eaMYAunYcrWrH0H7Z8brNIP/ueb8hQvAYC9N3QolDfv87AjfLdCreoVamCY3czecxtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8B5Ezamso3Sg2wx97ISTNr1R4GsfDr8vYBilfk4dLuc=;
 b=Yxma/gOR4lfc6g0F1KQpAWMvSQYbiw/T6cGY0BF59LD+b2z3O9f1x9BljkzcUbJeZQyi1VFD9AxQjbDnvMCyjZ2gT688kGvd/dtS55VVkJ9PisbHsHYzqDdxuzWPyNA6QAdjhH/raFiPInN/9QtaKJ+2f83nnuami1bmR6wCU4c=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF715E13019.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 11:06:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 11:06:19 +0000
Message-ID: <99a40eeb-497c-49a0-8f7a-8075800c1dce@oracle.com>
Date: Tue, 3 Mar 2026 11:06:16 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
To: junxiao.bi@oracle.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
 <7ed13647-8b26-4c88-b1fe-af6c3ac41751@oracle.com>
 <e2d21ea3-bcd1-4502-9936-e54ac9f5f96f@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e2d21ea3-bcd1-4502-9936-e54ac9f5f96f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DUZPR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF715E13019:EE_
X-MS-Office365-Filtering-Correlation-Id: c0932873-e7d6-4f3f-2dd2-08de7914e5a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	7GfHnREoi5RQRN0IQiiYW7JhUL+Fwm/mL/KzHHWNMtig/NpaUUmlo8VFFhbDsBLM7pa0DefL3M1TW0SWD85sfENAnQfsPBkwrRe3iiMnDLCXPCI5V4FrO9EQTQuo8khLk04YcswEzqVfYrOxlXO6K9ALfipIq9vrnQICAO09m1DoZgVVneiRHsU73wWdyQlpMy3W3zzkQ42Xjv8q78SdA2nrSnN7uAxFSf1DSpnR3a53Grk4Qz++2v6NevigPjwCuhBLpEMQZtH04GxwlGLkG51xZwfODm8+XFl2/ChguivsU3cqkVKrs5bDxVua1nTxBkB6NgFX8VzCBKSVhxhpmr30zvIlRJpfIrg1Yvdq95DfpTqAHf8ltzLeB5cYeJK/xLqQ2SpgGxq+VAru2Le9KO5viCyKNAAQLU5Qm7kSClHx/LqtXewHnZZ4SdKLq6ZbiiH+qslketOUuwXtR/Hct4nRE5NjWFYDbHgMkUSkW4XwN9xBnwPRo9yV+aIS7Btj9IbjndQdSBsK8E+CLgL12JmClRq+LYVvqg2GPi5/ZC/aTTOd+lH4sWqNKzs6MmUxlOO1S+sETfe8mRptxIgG2V/7snk8g82Qdda6vlQBI8h7KzJtbQBZ+g6neIlm+Lt+gsT/utWCD/WSBU4tLsLweFBVjDZg3UXBi2/gurUl7sysYkjx3AW6w9YyUYg0lGqr1vqTup9hGMM5t8+g31WQTojERtGifvuCI3MDZqn9F2o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2JKaEZxRVMzMHVRTjltL1VFZDNZQ3pUYnVwQlE5cnZnOXpCUHQ0U2hxRm4y?=
 =?utf-8?B?ZHA5eXR0TUJFSmtNdGZqczZaU2Q5djhZbGFUMEtKSGt1bkFTVkFoZ0ZzQzBo?=
 =?utf-8?B?RVlETkRLNlg5Ym40aDdEb0l2c3hOMUp5VGFUa0lod2xkYXhCSHhCZnkrYjh4?=
 =?utf-8?B?SEZzSzF4Yk1BOFkzTUdBZ0RMb3dEamJicGpZQW5ra1g3ek5IZ3F0SU1odkNZ?=
 =?utf-8?B?QlN3RWZaaGdBYzFVait4K2FvUGhXbGZTdE9zQWRBTUxYY3RTWW10NWFaL0Ju?=
 =?utf-8?B?MmxEcys4ZUVweUpneDZFekNXZVhvQ1dwVEIydkdub0FyQmsyaDV0NnREcXE0?=
 =?utf-8?B?NW9jQzk0TmUxNnNnZDFDWEVyYU5yRzBEOERYRXczVUwzbHQxeGJTZjEyTjI4?=
 =?utf-8?B?ZEFweGdjYTFDNDlMWTZUWUthTDFLOTBzYSszc3EzVFhOZEtQaGNKejd4ak1E?=
 =?utf-8?B?WURJR0o0WVRtTFFkbWNiZjlnaHB0cnVEaW1mUVkwOElTT3JNUW5rSWdVQkY0?=
 =?utf-8?B?S1FQUjRmMG54OGpyWjgxY1pXREdxZXdWOVZNSFY1azcrdkdBcTR5SWxBUU9Z?=
 =?utf-8?B?dm9ITXhwa0VWRExSZnFkVDBTT2UrL2JSMEIzWG4xNlRMWG9TQ1htUmlDNkJD?=
 =?utf-8?B?M0l6MURNckY0bTJwaU5BVk4xZGcwZDNlcHFkN1I2cnQwQ2o1Nk9UUHNCWkxJ?=
 =?utf-8?B?aGVaN3psc3BBQnpKM3ZUQkxJRWlNZ3prcE5wT3NnR2ZGY2wzb2tqYm4vb3RD?=
 =?utf-8?B?bElrdExyanJ4Umlad2tQT2JFTDdkT1R5TFNmYTFaKzBJaThPR2N4V3ZQcnZB?=
 =?utf-8?B?dk1DaG5BQXNESVlKVWpkTEpUNlY2aWhWaG9lYTczT2dhQ1huMHczQ2tDbXhB?=
 =?utf-8?B?Zmt0ekdKaFRmRlpaajFCdUZvMmhURXVNMkZORlVKdWxsUnNsREltOVpObWNX?=
 =?utf-8?B?T3NERCtiSUVTYmFKTnZreXFOL2tBN3VrRTIvNGtFMHZJMmlpTk1aZ29UcUZs?=
 =?utf-8?B?UXdOOUtqSWRybHFqbTRielllb0lVNG1tSzU3MHhGTTdlK21IUmtaVnhROW5i?=
 =?utf-8?B?bXhxVVp5ZmtSUWxKcUJ1ZzNXeEZ2TnJGVGplUm9UQ29RcXRyQ3R5blJtQklp?=
 =?utf-8?B?SXNlOFhzV2kyQ0hPVERFZ2Fla0VhR1o5RTNXRERKU0tpL3lUTEFGcGVCd3ZR?=
 =?utf-8?B?ODZKTkYxMm5sOXl6RVNzcVljd2x0bElKdWRuUW5kMHZpeE1vSm9CaThCMWlK?=
 =?utf-8?B?aElwQ2Rkc0JSSlc1a3lUc3J0WmU4SmVONit5Nk5FNkVOVUFEc2w2ZVFNc21W?=
 =?utf-8?B?a29PQUZrTDVFTFZHcDR1WVhKWktWdEFlaFhqSnFqRzFLY1dYSElua3JCV2Z1?=
 =?utf-8?B?b1N3aDZJMjhGNFNQYjhRVHFaRzR1VU94SDVHbVZqVlk2Ulh2UlAvYlpOMUda?=
 =?utf-8?B?T1Q0ZlQyRWF5dW9qNjNLaVhIcWEzSVlmTk5uRGlZb2E1TWRwYjVaMTJpbkR4?=
 =?utf-8?B?YkIyV1JyQ2p2V3pLTTRTc0YwZmhDSDVmTnVMNFA1UUhjQzJkaFBsQWx5QXFU?=
 =?utf-8?B?anVXZHNRazQ1Wm11clNXS2RmRkRCbW9sMkhsamJWbENRL0hEeWtLVDMxUDVG?=
 =?utf-8?B?SFZOMW8yMzBSQUt0Y0ovQldSdHUxcFhoY1A5Sm1Dc0Nmd1RzaWhsYXVvTk4z?=
 =?utf-8?B?TStXc1J1SkRVdUdPeUlvN0oyOWZtRDgzSUlJRFYzS0o2QXBTenFVSkZUenRS?=
 =?utf-8?B?anFTOGlFRTNIdFh0YTI4VkRCQmRIbDJUT0MxZE9MSkxGSThnZW1wQURWL3JS?=
 =?utf-8?B?MDVkNktRQXd6ck5SL3FKV012NmRyWUo1SHhIN1YwWVNVMnVFSWk2bU1rYXNG?=
 =?utf-8?B?aTRRVFd3ZDdYWTZ4MDRtVlYrNHk5dlYwblY4NHJ0eVVybFNwNHhDVkdNYjVy?=
 =?utf-8?B?RVVPbzhvWXRpMHRaY3hpamozU0luRE84c2doOWdwQUROaHFGVWMraDBmSXFt?=
 =?utf-8?B?NWc1MUh3VVBFQ081ZXMxaENmUVdNVWpKWGtDMHJBYW8wQnNkaEtyTzNmZ3hB?=
 =?utf-8?B?NFE5WUxNMWN5ZEdxQ0JrbldEbkFyUjQ3STVqMjUxbjlZeXFDcWlpckhDcUNL?=
 =?utf-8?B?Yk9BM0VTVkh0TnNCSmp3MXZBemNnd3k4VFNabFNlSUhlYTN3aHVIZ1p6eCti?=
 =?utf-8?B?U3dodmVMTmJ5dGFIZDJURUdLSjF5S0NoUE9ZdUFoanc2TkNWekpKdDF0ZEow?=
 =?utf-8?B?OUlJdlN0UzU3cFpLSFFzWXVMeTI0UzM1R2NlNDZ2RzFqQ2hQelBrSHNLYXcz?=
 =?utf-8?B?dy9xSm0rMzdLWi83eVArY0s0c2E2eXBuMFRPSk8vMkdDYmtoYmo5Z0tpK0hM?=
 =?utf-8?Q?JsIQUotXtLHgJ9/I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lJhQMTTPEhrZO6beJpizrbkGfzQJokJtnVUJIstqNWH8STGtDdwjiHZ8m2TufRNn/ynNAzfR1YyhEtVVfFCzQ4KNdLRDbuyWs5UAi/j/mhY2rC7wBPEJJt/Xtgq0k4HXOuH9dvokt4DjWA/Nxm3TrMZBlL+QtFXGYHHC6/42dz2Re2ADdTrDhSQ6kiqXuIfMw/eci4S19RtovhGBquqmgMzxzWTnBzg4+ZcMBgN/o0hAzllWh0zgszFeB/07BrpWL1hzDm0fyq5s8Ma4reBiI5SFzlJkIlRMlo1giM9yMr6f8O3+xwhl8gVVHaOmiut5AKJvflhnS3ImQiVWevArzbAxE/b8gMrL0CFT8UTxaeXeTiNu8joTKItEsJcWyI5/9rplSWWx4w5yVNmLKsRiNRU7mL/EHOVUf6+UcYfSBMMdJRZlDk4cPwyIV32vrGAtblSoYFjEHtX9EiwTALrRaDdnje2O9zbMz2UBowPoFGNKCAj+8sHTPJ+TtXmwXZoKnlEyzDrOoQCleBAUV4MGCo6nzrkZWicYYIK77avAOd6WuYf5Thht6loCi1CjGVUk1roHgdO7AyCiiTkAS4ZOjB5kshjWO17jcwKFScENPU0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0932873-e7d6-4f3f-2dd2-08de7914e5a6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 11:06:19.4863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MF5LMp0G98t7o/OjYIS17/EV6GTBkkNxtt0448tIr3vKFj9846i7lbVgX6cAGcIzlJBXXgto5vr28Nm6igfGeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF715E13019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4NSBTYWx0ZWRfX/4gpP0jewiM7
 aR/lX7nsiF6I3wPjXO5SqWKAymudy6u3y+76gsLqFgp8mh70+u+hXSwwixzrz0TBT40hr/Y53xZ
 mhLMaqVDSS4p9/ijv138TsWFuNmm3F5O3Zk+yXLIrt+xmP8uZCgK5a3JpzL8U02ewtxJTaCrWEb
 D5Sk0/1uyBKGF62OPgnbvoA4J8g6eT1nJcnf35uZ6Kexow5vi/eduCFQq8GmNtuke0DoL/VaLwp
 uF3bwERyBKXzctlPqP4dGEBtl5OyW9Lm6xE4c9CGuUCqjHa+A3EOBw7eLzrLFOIAoPiEIq/ZY2y
 j7iuZSDl6ylrH1kbtuecPGUolNsDp+oCQUybV+wmgZf9mf2tcvPHfEKvJgVs0VI/gg1YtMMP7R5
 cdO/uh4+jEiXVpuMwlXd3SodG08TUZZtn0DBgtcDANDfMvQOkjP11vkDxs7M9/H/zNwrKjNigV4
 nKpD8z1gdlkIwfCueMg==
X-Authority-Analysis: v=2.4 cv=P+k3RyAu c=1 sm=1 tr=0 ts=69a6c0af cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=6X9ZJWLSbQiMeKFMEZsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: dWIM7ioA5EMiLmrTBkzJWB8eEc0XKK-m
X-Proofpoint-ORIG-GUID: dWIM7ioA5EMiLmrTBkzJWB8eEc0XKK-m

On 02/03/2026 20:36, junxiao.bi@oracle.com wrote:
>> At this point scsi_sysfs_device_initialize() has been called. Then if 
>> you check the comment in __scsi_remove_device():
>>
>> Paired with kref_get() in scsi_sysfs_device_initialize()*
>>
>> So I wonder why we don't call __scsi_remove_device() instead, which 
>> calls scsi_target_reap().
>>
>> Indeed, the current error handling in scsi_alloc_sdev() is odd - we 
>> only call __scsi_remove_device() for ->sdev_init() failure, but 
>> nothing happens between calling  ->sdev_init() and after 
>> scsi_sysfs_device_initialize() which means that at this point we 
>> should only now call __scsi_remove_device().
>>
>> * I think that should be scsi_sysfs_initialize() and has always been 
>> incorrect
> 
> Good catch. Thanks John. I will send a v2 with this:
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 60c06fa4ec32..c2f70de5c093 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -361,9 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct 
> scsi_target *starget,
>           * since we use this queue depth most of times.
>           */
>          if (scsi_realloc_sdev_budget_map(sdev, depth)) {
> -               put_device(&starget->dev);
> -               kfree(sdev);
> -               goto out;
> +               goto out_device_destroy;
>          }
> 
>          scsi_change_queue_depth(sdev, depth);

NP and sorry the late review. I think that Martin has already queued 
your v1 in his fixes branch...
