Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EEBEAD7
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668773; cv=fail; b=dWWXaR3FAkJ89eGSumJJW1tNXHBo666kKpUoFaryIBsTs1dYjCu6fyEde7DwTDTSGVOuq1lJho4mHJdTOb/o70oqBNIc/BeF4c70Y7xdeW/HfCqICkLxe7JFuc8jMKvpp8gps3YRmv29BxrFBRk/7uXmwkyI9b8cZDKvXZTRj+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668773; c=relaxed/simple;
	bh=7jYvKRcqORCS/jlX2jw993sNSAH8QK1qWE4G9z7byjY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u8u8m+GDP9m6gn1fi42wG/PMEKS06+fJ8eM0+xS39Vf2BW1ImG+h4dB/Ac2DgX+w6sbbHcyhRK3CYBVhqJdaSuF/WZxWsnQlpGeBBwPAB7hdepxQphSpfL5B+WIBGTsLBrs0Fjidx8Ii6MolzlSOaf0v9uBg+K9BnHt/OXZk714=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NEWOKd7r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iW1XA4uT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NEWOKd7r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iW1XA4uT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx5uC016946;
	Wed, 31 Jan 2024 02:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=uWDWSI+pcPgInyE8Mu/PGu2WQV1pNgLNJw09ZykSzOA=;
 b=NEWOKd7rQ+oPeR2v9UPJG0iDXdke6dzpZ5212bHYrLMAoEjWPGNGsGDF4MmaKGS2UYWT
 vuBGS1O0UnS2iUqrxLBeE6htqa8I8IEq3ypZ8lFw51QrLTYAfspOe3CBGsXy8AWRDH7E
 +TSeGm6ivUoW4hCcUOgGn9RbVtOn6Ds+pxVcFx3ul+lG9pr6ILNJhffdIwWi0SGHBxUL
 zmaC83G4yEdv3MbMERs00IpcDJADW9EkNUcJKxWrp+4O4rJ6qdguLe3YneeYShK87Sqa
 8usLZA8ZLjeWGexJZAKkNLP3b9oZrBom+64rjdt+qsLdXjbdljypIQdp22aVorsJZVET hw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvseugkna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:39:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V2FiUl007779;
	Wed, 31 Jan 2024 02:39:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9ene2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:39:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwVsOrVf8JtD6UZn+5rpcDcLKSmhtgBINrEnSvM4vDsz9gh+PudOo76/ro2zMh6XacmLBCvdWPmIe2aaNYgqmywAbKGQt6enHBgod+Vg5RD3aZom7PzwHZJ6o01/lisEkfHAel53nzls2krGBlAxmyBkKvsey6XvpTE43KTRSMrOWiTbXKkxf9/Mu8lBASFSYWPdLr1fWl2qb/Ez0PtHgGGKRnbIO2/flgW3m2stJFS/QPUDLRwe2X12V2UIwekX9M9Qqa33eJYdi0DPnEADUpHkBAv6FX4BPKSMwP8AzDtcP/TJqa35waPEA70DmHiHn3PuJQaG8irezqcq/WrNsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWDWSI+pcPgInyE8Mu/PGu2WQV1pNgLNJw09ZykSzOA=;
 b=jtbVLDIGIOsuP9BhbcSlvwe8SvX/rfC1GmVzGOuNZ76aWmzlI61v9iWsUQrlYJLTXVWnmF6S3660Pp0x3Bt+oo8LA1sB+TTDYwyz5q2/ujBp+ZsnSin+eN5BSUv7rGB0Z/2A+NbKcGLxov/R5MX5MVnBt9bK/cc3sf3ziLrY7rMOYyyuy0m9dkul6qTs6XzOjIbBaNWpsEkb65fQmLJc00/0YYB4ihB/SrZjtMxzsjfQYwa4jChqfnwyASVTMFwolHwuq9yCfM84obrxrhD7OA+v6k7ZGlrB9+UrCzdfazZb0qY70WimRAWccZdnLKOCVZad7tOBO2tnuP5iYJ1diw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWDWSI+pcPgInyE8Mu/PGu2WQV1pNgLNJw09ZykSzOA=;
 b=iW1XA4uTfNQR2yZ/Kj0taBRSHR5sC5FrrjL7xliikBkEqzL5ksSHiJ6Jpg2pzmkEBRvWpkxyGi/ONeWoGuxtqkDq5mrUw5RYZIU5eONzK1OFFNpGl6lHlhyowQDE9EzTLAkW2OpqNbQjGHkSmYmByQwDpngn/XZAGqFG8Pz3264=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:39:27 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:39:27 +0000
Message-ID: <8cebb749-5d07-4460-b18e-ce7005d704e0@oracle.com>
Date: Tue, 30 Jan 2024 18:39:26 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/17] lpfc: Save FPIN frequency statistics upon receipt
 of peer cgn notifications
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-10-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-10-justintee8345@gmail.com>
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
X-MS-Office365-Filtering-Correlation-Id: a7575f36-fa23-4377-1f21-08dc2205d7a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EZw8nNmwKqf4C+ExpjtTv79siJx3tVU6tHNmw1c065E7DPSmVCchLU7+SR8z5HnN/qsnCdYq+N6k3TIXuFOIj9j1CmrWuPmDN1fhkHYJsiJ+/khmPhAq7FpvLXD0QzcR9HJ/okFEipQ+dP5Oi8IfHZtf20iq+T1KNM9FK9e228h67yRTzSqtbsDCtPMIFgWLklwbf3NetTQn9YADpFuj9ntLUfg+XJb6d6tTzoMqer7rC8AO9CHgclktaM0qL3Ckj8jRU3+Ffd2AsEhi75xjObMUATFPaqPTFH87frqafaqR2ZJIkmbC25sm9ogdq/YLrGbUI0raUSanLiuSOELB8mST40gerUnKBejCSYtov9nEc47XwfaEPuesCvzPtaRd2ZkVUbG16Pq6zmASvyK4cUBtVrdtfVWFLIeswUh2aQwCeida7ZIfkmZwkEis+QgsC/HwqRrBhlhdc4OnJ2x5CrXCCbrq+F5hMXxYpLWvul85lu2zOBOV8FRjN1kVPrO3df8p4ZZdvqg7qBLoeQPjU92QhZ3yrykZgt7Op+DRSPPEpofDEX2Yk8lMz967UVEa1RUKksgXRJk7D1tMRUxrxoyETkpbBiaDE9YgnBBkckjOLJbTYbqY+Mf9pePI6Vgq3EP/N1x2QAx4CMdDTfP4caorV/vaQMtINkpEZnXvbnDqaWcjds6XWrXt+1CJlH2K
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(15650500001)(2906002)(5660300002)(36756003)(3613699003)(66556008)(86362001)(66476007)(66946007)(83380400001)(316002)(31696002)(36916002)(53546011)(6486002)(478600001)(6506007)(26005)(6512007)(2616005)(8936002)(44832011)(8676002)(4326008)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YWVMcTUzaGVyTE85dFZBUDBFNGZKUUdBaFRUa1FMQkx2MmQ4VG9JZk9uV3NK?=
 =?utf-8?B?OUxjVVZoZjVEM1dYRmNlUk1YRTYycDdveUt0UE9qN3FsQ3FWRUxSRjg4Y3Nn?=
 =?utf-8?B?TWptU21IdFVoRW1HWlBNazNqaHpZN2pLNzNWaDczQVFTLzUrc0NUUXlvamRN?=
 =?utf-8?B?QmppV1o0UTdybXVwNldvT1lTanlBb3ZGU1FOTGJ2ZEpLVU1zK3ZneGNEaXVY?=
 =?utf-8?B?U1VicU9wRGpmWjI3ZGM5RWNYQ2daL2NOMDMzMjh6M2dZczJoU2YwaEVva3VX?=
 =?utf-8?B?dllPVjJDZWZIWVRjNUhqQzRUaGkzYzhtY2N2SVRBMGhwNElBOU5XZGg5YS94?=
 =?utf-8?B?YWFsbllKa1B2VUhpZnZZRHF1cWs4U1RiYXBnYVBKbm03ZThSbUNOT1k2SHk2?=
 =?utf-8?B?cGU1d1FFdGlzQ00xejFQOFhWNlVrMlcxSTgzNDFwamZ0Q1hBVko1NVhGbmE2?=
 =?utf-8?B?WVpuMlA1UXN1MHl0T0w1YkZUSG5yNmNONXp4NDAyRFJwSSsyQzZGY2NhVm5n?=
 =?utf-8?B?aXVlS1psUG5UMnhoOVdQVnRzbWhSTXpaYkM1UGg5cnRpUWRCaEdGU2MzNmVX?=
 =?utf-8?B?ZCtwbXJVdTdaZ3hpa3kvOWNML0xpaUIrMW1MMjFLdEljejYraUhrN01SY2xt?=
 =?utf-8?B?QXExRXlwSHVWRHdmL3dXZkdBMWJFaTJoQjdBK1N6b1J6alVEUzhSL0QxQ3ht?=
 =?utf-8?B?TmJ5dEJrNUd0K3ZTVC96Vk1DanBwQ2NQMnFmVGg1NnltcmRRbEdBTHZ3OVJU?=
 =?utf-8?B?UXgxN2FEU1ZGYWNBU3BXenM0dFA0OGtodXpkN1dIVG5BdTJCKzY4b25ySWFN?=
 =?utf-8?B?WGZWRDZnUDdTeU9HWjBjQ1BxaEFqcVdqL1Y0cVZ0ODNSOE1Fay9VTm1XcW0x?=
 =?utf-8?B?SVhKN2srNU1sNTE2K3NHOWVBMnpSdXFpMmlEOGlkUWxYaDk0QnpWVEpPdER2?=
 =?utf-8?B?Rzh4NWNPN29WTWh2TDlGSjloYlhSNGE5Q1hqVjMvMStZUWlQZnlRU1JORE5S?=
 =?utf-8?B?Y2VlMHE3S2hZYm9JSUgybTVtSXEwNWszMHg0MG5lbkE5Vit6dEEyT05Bc3l2?=
 =?utf-8?B?Sis0bmx3T1FkR2dsVDM4WHAvYTcxVkRQL01sMnpqdElXUmNSdDZEa3UyQjNP?=
 =?utf-8?B?ZXJwdWtBekR4N3RONS9MV1ArRXpUSXR3NjVtMTBRaEtWcmpQLzUxZ29tVGlq?=
 =?utf-8?B?cUNJQzBSSWEvdit6TXllb1pWNWFRMmcvckFEODVweC9tTTRIRElTRjZ5anQ2?=
 =?utf-8?B?UW1tS1YxeFlwSmRHcDUyWVJYM1hKYmZMTG9WbWxiSjJIYndjQVJ6N0hnWHVB?=
 =?utf-8?B?amdWTFhYMmFUenJSZ3F0MVduU3pWbS9XUnpaaUhPZzA2aHRwM0xIeDRqY0V5?=
 =?utf-8?B?V3VkbUh3Q3hpU3lDM0xZMGtQQTFkcDVlS0VzZE9QQThKMm5QSlhabWhsZG14?=
 =?utf-8?B?a2tNSE5TSXFGWmVNSUE5aEoxY0NVcUpjZW4xYjlPbTNuZjc2NDJtbWdkbDIz?=
 =?utf-8?B?VWhTV3JOMW5mbnVzQnE5UGJKMjdWaGh1YzdQM3lkUFNmbHQrY3h2SDRNRi8w?=
 =?utf-8?B?M05UVUV1aE1yUFZGZnhCcHdtdXQxMWhSZnpMVmdQdlg1dUVkMjgyOXdEU0k5?=
 =?utf-8?B?TEI5eFFRR1BLVVc0ZTRrb0kzb2VtSWM1MHM5NUY4Ry8vZE5xYm5RNDJkVmJK?=
 =?utf-8?B?aGdMQlJ2a3VrT3k0U2xGM1pKbGdIT3E5K0VVSmtYTlM1bjVoQWZVV3I5NHd4?=
 =?utf-8?B?RS9lZWQ5RVdnYkxuS0ZqSDdmVkcxK1l6UGF4OHBVMzU1TjZYNGFreUtXTTBB?=
 =?utf-8?B?dzYzaWJEd3V6azJ3NjdYSnd5WTFVMFZYcVpNOE5yL0IvMWl4TTVxM3VaWCt3?=
 =?utf-8?B?TGg4NElSRkxvSWo3NmFGQStxeWkyQS9hZlpWc25OOHp5Q0VIL3UxRG9rcmVM?=
 =?utf-8?B?M2RxM2tOZloxVGxwYlFLc050UGdIZGp1cm40QUx1eHRSTHJ2UWZXQ21iYndE?=
 =?utf-8?B?Qlo4VlYveFM4SW9GeXY2eXFwSnZnNWkvOXlXc2dBQUJMdWg0aDA3ZnRnRXZu?=
 =?utf-8?B?UCsyelJlVlpTYktxOURZemtsWUxtRS9vdS9GMDUraFJMc3NUdjc1OUhyZmZW?=
 =?utf-8?B?YmZrYnU2MlFFY0FuTmZqQTdLbkFGb0hSVzlMVjRJblFPOEhxajlVcHg3aWNq?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	gRsXb28M2wX2iJ8Octp0hDaDs1JpmAON3kLbbSaRuOh3gMYTwYVHflfF1scbZWPxHDIHDX2a7H5WvUAUwhx8+xKd+vG7vFl9y7o0YNf6sWQnwN0e6TPw2kGJh3sO+Bu5JotQEXMYNSWss6qNjxuCStxNBTZTUFsptHVsTSF9nsn+yZ+u42R3y6Zeha3qAOVn8dIUYkegV4dLuGxRhhdixH65iI9iJ7yaZ24JZ538KeKsdHAgEOIfGW0Ex6inaoabLJjfrltCMokAd7M/5Yi33F8DFXaQTWrtpfpzqld6h6+3p5y+76v7g7ErFSOmwaQ6pdfTKXxUoRzQenqgpBG182tsspT8Bu/kBgTwcZarGRZbdz61hdqq7sYYiKA0aEiGg1D04wkiOQvFAStQBO/0Rmfhx+Sl1dfy77Rrx7XHlB7KBi6CWamtsi2KxQjlfIEixL/FsuShoX12qFkolYwJIqPP94f5OwQhAAtzMo2VR0PDlmDJ/bqjoKGnwm53OIP1NKmmHYTBle2aTc4/hbomry2uNN5gUtKPcy/rwIEucnp6pcg+OgupqUVZyOTf44d0wxA+6XuUmDtR2KzNY1MhGKuXDtVk3yyoN3TP3VaqQMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7575f36-fa23-4377-1f21-08dc2205d7a9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:39:26.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jty2s7te2uJylOrUNMThEq/VzedHjf6QG5fSdL175kxZenMUSQqd2hwXavJE/9qDRfwslgxM8AipzhNkHbtfD4sh/b15srhhSqXEieq4P9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310021
X-Proofpoint-ORIG-GUID: -bCJyqbQK5jD4jAyNfpEp2GRVpJ8Sc6E
X-Proofpoint-GUID: -bCJyqbQK5jD4jAyNfpEp2GRVpJ8Sc6E



On 1/30/24 16:35, Justin Tee wrote:
> FPIN frequency is provided by the fabric in peer congestion notifications.
> 
> Currently, the frequency is only logged in a message, but it should also be
> saved into the phba's cgn_fpin statistics member for proper application
> functionality.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index a17c66e31637..1ada8ba6cc2a 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -10131,6 +10131,9 @@ lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
>   	pc_evt_str = lpfc_get_fpin_congn_event_nm(pc_evt);
>   	cnt = be32_to_cpu(pc->pname_count);
>   
> +	/* Capture FPIN frequency */
> +	phba->cgn_fpin_frequency = be32_to_cpu(pc->event_period);
> +
>   	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT | LOG_ELS,
>   			"4684 FPIN Peer Congestion %s (x%x) "
>   			"Duration %d mSecs "

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
