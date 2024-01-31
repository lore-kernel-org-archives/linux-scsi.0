Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A963FBF5
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668882; cv=fail; b=RmRYuCqASTy1sJmlF0nb7vqpenfuWaKRkU1SkePCemjxld4kxPtxfp2h6+OvEAUqUuY5E/Ohf4Pr74ZIm5B32v28ujkmsHTYM6lHsxLQJWeyfIC1RVv8Ada+DnKww6IrYOlMh9I7YdSpygwT8O1feTdZGUQvnw3Eztx5cytaxts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668882; c=relaxed/simple;
	bh=wwrog8s6tqjfbgjMBhwsnHJ8S/pJfeShRsbyN5LlhuM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AUG1S1v1yWhzSY+Bb5XR29g678N0DTLtUTUqC4VG11b4FrApgqUMKepcf75HrviqHhAv47rA6k2il/wKQz19JjJz6/392q6vSSSsX9T7utTej902rS5oq4socClBzWkpGS0pVIJ4nDAPedCw0oT3u4vHFgf83xHD+m1U5lMp3Wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MOW5d4lx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R5FNpYJ9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MOW5d4lx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R5FNpYJ9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxtqv021933;
	Wed, 31 Jan 2024 02:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=X56BxSm+QdB+id/3BNSYV7R4NrWWW249QNFoPYDjyq4=;
 b=MOW5d4lxcrdqZ7aY3KW2F8nk6VJJcCBlApAeUALJaeWcCc6Xo07uDDIbtM1DzfEVl3Pk
 qnuPLFtUYSWch+I+J5fYnksWeU4hOz353DLdp4qSS118+g2vH0vacSSYBoHvRHHADiCb
 RGnZk6DsTPKDxvo04jFqyCEsU/5mq71aQEzZE/y2ayKTlDTBZSL9oYcsG4Aj1IQc6yVa
 rH6apQOnqClMuaoBHWuIGVDM2beF2139sw0X0BMjCGfiTC9zc1d2IHpdEuPBnl0RU9OB
 fIEgNg52zglPfvLsbu5mHRdQlib8ZmOEn3A9y0qTOybJn/iqm3QmA3rX0OstQGLJZupe WA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcv0nty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:41:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V2UV3n014626;
	Wed, 31 Jan 2024 02:41:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9edu6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:41:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6WMNsd8+cRJcwCIACSvXuHjkyhOgTM8i54OGG+2xFNKIrJYhmWDCS9wHVPe1cz40BJbSuDhE/yJr+pglwKFUutsDbN12Dab/Q8pSNqVWRhl7VOdJl5lRWGhmt/mwm4tC0zG4op1AEt5mrrXeEplDJLZLxgAU0D3vYG+q/rMTYheb7sNyuWn+59FtXSy0LZf45IyFudQZy+zBhep+oey2cdnBtvj4rQRYl8aMDJUEgeGh7gB1v8j8JY5+yj2OBqAvO5daxe6tu3Ev1+JtPnQ2GVzshVtJxRrTKYZWf+2M7iJ7MN7byTYd88M4fFKJVVtcgnFndY6PgcqxRuBMGaTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X56BxSm+QdB+id/3BNSYV7R4NrWWW249QNFoPYDjyq4=;
 b=LnMZLJXnC2I7DMCONFYHvt1B8+NooVKf5KFH8I/WNCrd/BnDZCI2FgiJ7MB42fRW2kTwPNPWGGb6CYsDeW/tQVHFsf77PtimgjlL1OtEbnMCyPUP9SNPY7fVMMhWM3rSOMzsknrN8smLWjNlgJxeC8AdXbD45RmHD1iRkN8omPjfHqhl56IvIHp3ZDHaJtDoP/4YEIfy8LxMbPhP7Vv/kWKkKfILCv3NzRH6yRv4FxitJvKGLXYMrQR6CvSpkLsA5YfCvf9taY/A71xIDzIFAoYs7nK7rx8l0N2/yCTcQFwJ0bCO4dWEs7V4eFUuFGysyNiuBYiEJ+SQLJBshS+6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X56BxSm+QdB+id/3BNSYV7R4NrWWW249QNFoPYDjyq4=;
 b=R5FNpYJ9Q4l23PEn0lB6rEhu2peoKkkUfxNSkrBTQtG3ERuXcAD4nPBmIfD9gOpmJ2jr6VnlRbsenPNges2PslphqVuT0sXfnzdmL9Zt9ZejjRFeY5jOVClGZUjLRkRZKxovmPaus6lHfPg282L+mIDw0ZvrJGNuk2zz13hLRH8=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:41:14 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:41:14 +0000
Message-ID: <fac523bf-e05e-4b40-b326-b6183b2323ab@oracle.com>
Date: Tue, 30 Jan 2024 18:41:13 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/17] lpfc: Remove shost_lock protection for fc_host_port
 shost APIs
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-12-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-12-justintee8345@gmail.com>
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
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 24cca15e-0a7e-4f33-b111-08dc220617a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Pz3BfTDB4hJRuYmXr7cAsQikY/yMvw/eHGoS2kgX2gKKb5pKYsMCG1wO5W+vUWGZQVuP4+Ft2DZHP854PDL37p9Jdx3sElXy1tByEWhTKUZo2qVmIAXoRux/6A1Sl8E/alhK4Vv6YjNIadJeswHJKbhNFGaurXn0YtTnoDArF4um8F2oAQ2gLChwXK62bCe1rlUqxVPl8fblhHCo0w8Gd5Q02iQho4PaBhvC8llnkij8rg9dW0egFBNWMj0tZws0yd+SBY3oPquWRYAlvuY2aN4Dku/X+aZM7Es+ZdAQ/SsX5R59UJ7+1t4bf9h5zCVTfWcNRp4pXrpt4qcJgvv58+D+Hw5Lf3/MAAfeYUKQwK2MoQk7knXwwYBblkjQ0F8+trPT/ZJKKCkgZrgLRhINdEmu1JdxccJJg9eiD1fMJPUXbZh/KFR2xviESd0l9i+MNBE6uY5cyzaIhtgK/7OnEZaWJA6FjDWWSAMjolY5gRdwmg9h3tWq5KxgGIP2jJ7J5GC4tidH9TyqSJRr5Gge6hk1WF+PKueNVGcwnjgXYVXqoELEhmVeRLJKYJGKmc/IWBPTbe9FG5AE/yQPQ98e9RAguO/dEbZbby8+xa1a+6lqVAcZ0dTXrh/Sk5i0P+0RLmAECJoWPbQcfSVu9/e5DA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(2906002)(5660300002)(36756003)(66556008)(86362001)(66476007)(66946007)(83380400001)(316002)(31696002)(36916002)(53546011)(6486002)(478600001)(6506007)(26005)(6512007)(2616005)(8936002)(44832011)(8676002)(4326008)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MDQyUk9VY2o4Q2dleXk4V3pkYTcwYU5FSUg5a3pER2NiVUJqZVRmTjNhUjA0?=
 =?utf-8?B?SUVUSWVLcXJUa2VTM0ZkNm84Qk5pWU5BQjdoaGpGaVNpTGM3djR1NlBwWEVZ?=
 =?utf-8?B?VjBFSVQ5MEJUQUJBbGpBbDY3TERQUUNXMCs2VVBLejdKRU9NQ29zQWcvK253?=
 =?utf-8?B?a0pQQzIxdGtoZE1iVXpETzVwTnVmaERxK290WWpqZ0I3K1RnVzZjdVdLSG5Q?=
 =?utf-8?B?NFYreS9XaHdSWElRK1JoZlpRTlREUUYwNlBZajhiRkZmR1JzWFhiVG5uUjgx?=
 =?utf-8?B?Y2R4V2o4K2NsOGNBZFBDTHVlblFZcGhwc1h3T0YwM3JISDBHWFJUVTV5bkNU?=
 =?utf-8?B?enZ4NU5Fd3c0SExZaG00T3VrSmh6c1gvYjBGSDgzVjYxdTNNY2hWMUU0eldC?=
 =?utf-8?B?VEplemdWQ0FRSnc0MGhrUDVqSGpNRzNkeTlrRTJMa3BoYk1sbllkMzUvY2pY?=
 =?utf-8?B?TlljMDB1UGJybUFKZ1ptRUh1eU0yTEtXMnpKSUJqb3BkNENBRnpGdFg2Tm5Q?=
 =?utf-8?B?dWdJeDMyOFBMZGZQWjBCMElzdlBKeTBabmxFaTJ2Um1CYTVnNE5kQ292ZFV2?=
 =?utf-8?B?R3NScHZSUEpDQTF1bnRRZ1FiQmNyaGZ0R1Mva01iK3hTajAxaTE3OXJoUXpt?=
 =?utf-8?B?QWR5bVRNakJycWFickFkY0ZKRURDVjhEOGRQODNtUVlIZ1hNVGVFbTlrajha?=
 =?utf-8?B?V2pEbnhCbElPTHZYRGlEN0dKdWIrRi9ZNVNhdEhDUVJpUWpYWXNxK2NBazlN?=
 =?utf-8?B?NkI4bDR0NCtHOTltK1RkdzdtS3hSSzl2S3NKNWQxK1FWd3hpT2FmeE9GcmpJ?=
 =?utf-8?B?N2E3aFNya0hyNGRYQzU2NW9MZVRVWUZPa3pvOFJRYS9pWlhRTFFiK0t4NGsy?=
 =?utf-8?B?bDFnYzNKU3VBbmZCK1RTMTJwa29ocXRJSldUc2RURDBjcDNaczBMKytMaHh4?=
 =?utf-8?B?UFNNbi9QRHl5d1pkWGJtb2VHUEJaV1U1YnJrU2NTNlEyQTNqT3FIQ1FIMmFz?=
 =?utf-8?B?eno3aWZOL1JaNUhkNXg0Rnc1YXNVb05YOUZsQ1pnMHhIbmYyOGxpZHg0VUJV?=
 =?utf-8?B?SWE1MUZxaDFhRU1oOVh6S1Z6T05WOGg2eXFUbFc3Z3VBaUFtSElFcXZoOTFo?=
 =?utf-8?B?anVON1NWaUthVW5uM3RLWkZ6TEtIcUxuTFgwNi8vZnNZVjYvN3BQdHFTdElU?=
 =?utf-8?B?ZWU3c2JZeGRYZFBMdWZPb0RxeE51aE9mbVY5NFc2UFIwcnoxWFFRQVhuT2dl?=
 =?utf-8?B?MEwrQno5OVdlODc0Zy9ZY2FRUVd2clRVT1pjb3FMN3hsVnp0aTk4Z3BSbk02?=
 =?utf-8?B?dTM3emFmU0JWNjhqVC83VmRTcmRzQzFHbk1rVi9jZFZ5UlBSSEgyZXZzUmhl?=
 =?utf-8?B?ZGswYWZVVFg5cGpxODJsU2tLdjdXWk9oTGZWUnBIT2hnRnVEVDVsMG9JUVd0?=
 =?utf-8?B?bG54WmZQcE1PcGpwSU5BaE0xNkdFQzVaQWQrZnlpdE9Ia2l2UTg0QlBXS0Fu?=
 =?utf-8?B?T1RPbmt3eUNXV0lVMG9FMzZTalBhVDZULzFJQ054Y1FQWWpLajZ2SXI5RWVm?=
 =?utf-8?B?bGdpT0k1NXM0bmRjYWVXWlJnYXAwU0pxWURTc3pTZTVVWGNqUENpU1dUckVT?=
 =?utf-8?B?U1VPZnQvR1FNeVFNb1E5eVBBVUlMUDN4WWRlanlVeTBUem11cjBicy9XelNK?=
 =?utf-8?B?N0tPWWtrRFhSWm1zMlFJR1JxcTFnaGFrTG40Q0ZVTUZnQzRrYTNGbG56eGpM?=
 =?utf-8?B?SEV1SC9raWVtVXpVeTlvWFdFTDNmQTNvaFJMQWRXL1Y1UHBTeVQrOEt0QkV6?=
 =?utf-8?B?djVMamI1ZXUyMGRRRFg1YmpaRXMvZWNOSndFTXZwWnlqMjNIRmRyUkpWbUQy?=
 =?utf-8?B?YUxWVnYzYzFLNUFEdkhTZzFrQlZlNjRXclhFSDdDVU1pVXpLc3JwSUtYU0Zi?=
 =?utf-8?B?TWpFZWt5Zk4wQk5HTm05OVkvSGFSZ3VuS3hucXlmTmVjaEdZbnFZellWNllU?=
 =?utf-8?B?N3FzQUxOU1JiUytIUXFKL3JrOGg0QTh2cVJaNVZWOGJQeUYrbFcxV1A0UmVP?=
 =?utf-8?B?WkkzcndTckx4eVRzelJ4Mjh5bUlXamZVNWJ3RlRGb0hwN2kwYmVQNXRRVmc1?=
 =?utf-8?B?OWlyNm9oMWo5MFNjZk9pRUE5U1E4NllFSno4WGRMeTBIMjB3QmpGV3Q0SVJ4?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Gp8bpTjxb+M7rb/1X6X3xWlDGdXAfBtQbngyHhip08VAAqRt9t4mWA2Th7oicEBmDR3kmdw5DjW2BgEmKWttihGP33KK6454R8bfi+6g55i8DGqjtTCa8o1LGT3Nm66RDAX+4kG/Ulx+xmtIsHShZOWo2+DCb12YKoYdSh3vhF52MtsHVx2XsI0LUfRnlLETGovRnkmhRqZMLhC6vu/uJWjIcPGz7DB8BOIenG5GA1vFdzhHtBk0tjeLttwY2lviFMOIequK5uS1sVJwJiLv4RhykuW4JMedg+R3UZH2GbLdVLhJbeaqVpEUb75YDDK19DOaT9l06kryitnYTmcOwud0yr6WmaQXyvtByXwHSaOfyyX/wrhsBcE94vvcezpKNmPwy0Y26hVP/xR87KewWqZx2nV34ShIlu4ayFk13OqPYaYZyLzLLCGTJPyQYhbSw60zGhtT+bqWYz2JWVqihcA/P5CEJwFaocBYdAUszhsIklxAQuXyYQrr9a16Fj8krCOvt7vzVwcVawm4wJ4MlwthignJwywzYyz2cClAnAZrVRG2bxWFuH5jlC59vf/tA1zORXwv2yP4tSw4bPUn9ZTBoMsGOhpcXOH+rmYweZc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cca15e-0a7e-4f33-b111-08dc220617a7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:41:14.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +E2VM8jJMEayFK8jz2eOHmoKnAR5GVbxRRS/9eSW88dErJkcIK7SUzkySACoRdZ+TiXW7MgQID2vytEBTkydI7butlY5rRtUIlGi7HlPIC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310021
X-Proofpoint-ORIG-GUID: ltHJnSJ8UZ20LQLawohPGDcxDeF3HVHX
X-Proofpoint-GUID: ltHJnSJ8UZ20LQLawohPGDcxDeF3HVHX



On 1/30/24 16:35, Justin Tee wrote:
> Desiring to reduce the amount of unnecessary shost_lock acquisitions in the
> lpfc driver, it has been determined that there is no need for shost_lock
> protection when retrieving fc_host port information because it is only for
> display to user via sysfs.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 16 ----------------
>   1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index d3a5d6ecdf7d..1f9a529e09ff 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -6429,8 +6429,6 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   	struct lpfc_hba   *phba = vport->phba;
>   
> -	spin_lock_irq(shost->host_lock);
> -
>   	if (vport->port_type == LPFC_NPIV_PORT) {
>   		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
>   	} else if (lpfc_is_link_up(phba)) {
> @@ -6447,8 +6445,6 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
>   		}
>   	} else
>   		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
> -
> -	spin_unlock_irq(shost->host_lock);
>   }
>   
>   /**
> @@ -6461,8 +6457,6 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   	struct lpfc_hba   *phba = vport->phba;
>   
> -	spin_lock_irq(shost->host_lock);
> -
>   	if (vport->fc_flag & FC_OFFLINE_MODE)
>   		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
>   	else {
> @@ -6490,8 +6484,6 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
>   			break;
>   		}
>   	}
> -
> -	spin_unlock_irq(shost->host_lock);
>   }
>   
>   /**
> @@ -6504,8 +6496,6 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   	struct lpfc_hba   *phba = vport->phba;
>   
> -	spin_lock_irq(shost->host_lock);
> -
>   	if ((lpfc_is_link_up(phba)) && (!(phba->hba_flag & HBA_FCOE_MODE))) {
>   		switch(phba->fc_linkspeed) {
>   		case LPFC_LINK_SPEED_1GHZ:
> @@ -6568,8 +6558,6 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
>   		}
>   	} else
>   		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
> -
> -	spin_unlock_irq(shost->host_lock);
>   }
>   
>   /**
> @@ -6583,8 +6571,6 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
>   	struct lpfc_hba   *phba = vport->phba;
>   	u64 node_name;
>   
> -	spin_lock_irq(shost->host_lock);
> -
>   	if ((vport->port_state > LPFC_FLOGI) &&
>   	    ((vport->fc_flag & FC_FABRIC) ||
>   	     ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
> @@ -6594,8 +6580,6 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
>   		/* fabric is local port if there is no F/FL_Port */
>   		node_name = 0;
>   
> -	spin_unlock_irq(shost->host_lock);
> -
>   	fc_host_fabric_name(shost) = node_name;
>   }
>   

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
