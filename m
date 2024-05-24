Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B659F128820;
	Fri, 24 May 2024 08:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716540544; cv=fail; b=ZpjTM1EHGE9Mn4uHxAYBVCp2h16xBZ2BFmc1O9q6/m14o62yqvG9HaTHHxD8hvVGawBXFF5zgqCuFKEf/hM0/ytIKXEh7vEqtaYLNM5bAUPaHwvFdckm6dKNkF+hD/EQLivNmuBS5pzHDAXIegJ6BU+kM2QkVEhMHvy1eKQhLgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716540544; c=relaxed/simple;
	bh=uI1+juaLfmSGR1NqkDSkOBaDUccllqPtX+4F2x51Vc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bBpfvKnr+hZl/MiLTui2J/4koEvpSu1anEKuCczsXWS2eX+rHsrGBLHM7TvbqSJscpu9Q/lrozSIthz0tAUVUZljA1cWnAmpvwcYLvh7G9Em4LNDagifaTMdj5W3V7o1AZOpjfZeyVbAGT7hLJrJqrmodXZ3CZ0SwAaGhRDeCMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vl7Emhs4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kV+CBpYZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vl7Emhs4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kV+CBpYZ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O8iQhV006550;
	Fri, 24 May 2024 08:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=S5HzB5ltSO2ocoPGwwWQXXNN8OAjIzpeWkWGhAdT3gc=;
 b=Vl7Emhs4rMgH7bjmXMhyf3DaiEqXMYTZdhuyM2lT0bcENgqYZrJG+MLRgNbpnTguEBP5
 /CrSN6Ib5grM6XtLaiexzJyyuSk7Qp73Q+UfuyqheJCSpsVf9ayGTSLcNuLMyM6P7EBE
 HXG93MiibRj1EJ7kJzSvEmPIUoR56gKMmG3ZlpJfkVjU4ewsZEdDIDfHHro1bPYYGoM7
 /Wigaen+R4ZMJqFGlakEAZlozNpWF3ScnAEFGM3mUOLAH/9zkLMxPeihL97TIw4Y9P+H
 TCBQ76rmx5RInRmKJg4c90qPUM3vjByWO53BcyBWCrmfXfAXV4RISOtHba9Yz8br3hJt mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7bbku6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:48:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O7sfJi002666;
	Fri, 24 May 2024 08:48:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsbmruf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caBuN1Y8+qv/mkv3K6XdICy353Ug9C80W/m/JGjFZKO4gd514GmTgw9WLF8GMs2N3y24nG5VTR2GzGdnPtVxFQ/Oe8T1vSX5Ma+EMOYDPMqjJgEAvSR064zPp08e2/erUMnP0ntluGaB8eOqM6+nrsYfYfVbYWsR0p+f7WMQZkQ20wWKV3+fLwgtKkl4REVizhbvESfXunVy4/uMBsysfbpJQIrsMOwp846biq+xb4VBtzQiPVKIR3QqchfeS4wTJCdu+uj7jN5wwORbT+KtNfB1t6RE08YOIUAvkTp8Ejper7mAT1SXnVs4Go0KfnKeJ+6brdKtdGJ2C5DTaBEa4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5HzB5ltSO2ocoPGwwWQXXNN8OAjIzpeWkWGhAdT3gc=;
 b=XZl1r3rVr2NJLLhzdAzwhCwPQNyRr4MPKnW/pYRlpRetNzVJ5P52k/3139FZR+BIujNnASWjEHzp9KokB5X3DG3E4Mmgqdhf42XCyxvmbx1a4gEukinSncp/nQ89w8Jzw/WZyEejQaFPSdOh8R8ZTl/sfiXVNL8aTQ6EnRi3awZdIrjBUWRWk7PrncB0UPcinjlceZz2YMNtIzyutWUUNG41yZfRQtprFWprLOYpjpY6HBm8ULisWb/O2u+UGXj2scgonKfS+FAiuO2rF2r5HK6htvfhUr1o4k5eK9A+/pdWKff4wNCsyAB2iCsdH/8Piy4AxoTxkuoVbWoQx6jIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5HzB5ltSO2ocoPGwwWQXXNN8OAjIzpeWkWGhAdT3gc=;
 b=kV+CBpYZvYfMRPMBpKeRtuxxyfsw0HEOXen4NRJ0FHGPgZU+WLGwRk6S96fyg+NoxaE1/GNIfzQMlCX/k0irIswYBKe8aqyxukk9AJ/Y4p882MqWmsGYnA43WwAt1rtrBZxBLmqe+8MlmP3RI+w15lDBefLpgUjhtug3o09g7+Y=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4357.namprd10.prod.outlook.com (2603:10b6:610:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 08:48:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 08:48:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        himanshu.madhani@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] scsi: bsg: Pass dev to blk_mq_alloc_queue()
Date: Fri, 24 May 2024 08:48:29 +0000
Message-Id: <20240524084829.2132555-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240524084829.2132555-1-john.g.garry@oracle.com>
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc7d387-7b34-4fca-2056-08dc7bce57b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?coF+v2WUxesmQaV28Q9RawqClId060ov3hxhEw6Q99P8UpVXOXsxiZZoaTqC?=
 =?us-ascii?Q?03r/CIiH3WIC3B2e9TLmzVZF6qPSSHa3t9Nzr/TpsxSkGcH6ZU68tPRf/bgR?=
 =?us-ascii?Q?A+eNGn/26SrGvG+P9+qpF86EXjXSMW8zp6S7oArzRSoWAu+BKSXZ1NrjiBE5?=
 =?us-ascii?Q?8HLEyvcxHMVQXjSbZp/Rb+mts9ujUyyGvpgtoFAMndhSEGdyfsETMpWAUqKl?=
 =?us-ascii?Q?zCfQLfqccK9ZXIPMStg3UXI5n+54fK7POXRY0On4USi9CzmCrOBS+bsg29hm?=
 =?us-ascii?Q?ekBec0MVXWwKuRN6dcVnO2opEiqnSwLmjRKViaw83AWF6EOz1KMfneC/Gtjd?=
 =?us-ascii?Q?5ftdD3xXsILii7t01dpjWREZ+VWHi1oAdrUGvAZNt028IJ8O5+4D/zZMSwIF?=
 =?us-ascii?Q?2X0/YkLgd6YWOW9aTJ3GAb4btSAIyf2HnYqhcneI5kcPSAZJ1vWAuAwOcY0n?=
 =?us-ascii?Q?GuF/yAPMvD5NGJRKPfC+8kp4/z2uGI77kogcXqoroPx7ZmazfBCQ6fj/jiEN?=
 =?us-ascii?Q?emTntaPEVFjayT2WvSFO+u1e8CeHJPSObhxAHMXqoOqqiQsHt7loUBBRk4sX?=
 =?us-ascii?Q?eWgUB12ECqhXxTZMHirhzVuR300Ag3tNiY5FIGK7oWN8+Q1aeKqkGur0+JDH?=
 =?us-ascii?Q?bq5Et49FjWbIXA3mLijlvtV5tBcituGGpE+CPx7zNSBNebF9Q6vJAT2fewo6?=
 =?us-ascii?Q?ZT9Xvd7eA/g74PODS5Wuul6FQFnbbPUZmbMdv3nsQl+ZLaJ2R1IqJ2jDvOEI?=
 =?us-ascii?Q?/NtQEVgXJdBEFXTP1esw/7FtejShGJCLRjLACO8q+QRAC0PSvzbRMr8EKyTw?=
 =?us-ascii?Q?VrbSEk5+KZsEZgqAopAoN+9YknOZ9mTxR3iZ2eunNWq0+OziCd9D/ZPSTl9X?=
 =?us-ascii?Q?w/bXuRZIWmDYTPhWB3SnD05lYqPJVF052qQs47oxy+o+bA5KAL3tGKt2J4a+?=
 =?us-ascii?Q?lRrUmyZhQ3KQmZpdyUB3BYLFs8anB55UU5Bp0S46pcD2VOgYZM7E+u4wY8Uj?=
 =?us-ascii?Q?36LYpwQVEeabL6vZR739+4ZBH6A0Uq6LtFwzaC/US8dL1CG6fz6bApto37ps?=
 =?us-ascii?Q?fe5J+xKTaQlbG6c+p8XDFo/PLnyji1UqoZNSLJxQohJhzrAYikOn9EA7Qtba?=
 =?us-ascii?Q?Uvn+UWQf56bJE4lYLWm+Oda2MX7TYZK4Uwh1nGGD1R9gKj+WxNEnTQf8sHsP?=
 =?us-ascii?Q?xtigXBJTVVdyNqGFL4XSDlis2/6vlHKgWYp1vLImLfxkOloHM6mWMKYv+vyq?=
 =?us-ascii?Q?aZgaBWgZD0Qiem+NNSGI2/ih1NgMUrmUfNtJ6edJuw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ji8G1QtEpO9M8bCJ67FwQOD2MaVt19MSTcUjJjtEj4Ve/DfkBXEZ8MiTypYO?=
 =?us-ascii?Q?i2DHUCML+BSPP7229E1qPSZSZgLNP+ezLk6oteH5tCODFBN8mkDysGaIVKZc?=
 =?us-ascii?Q?l1LWFLo0WrQ/tUi/vqyW+MMNiKywwCN2AgYGEqngL+FZHk5qPbe4S4tMhjg2?=
 =?us-ascii?Q?ZuHxm14ZDYZppXwOw+/Ii8+c7HI2aBNzbknj1Zu9IBTFGbvR+xXeckFnt7lH?=
 =?us-ascii?Q?MlGT0CCCl9qbDhJEpLpFQiJ7yR5N9Kn5lWpkQYsklBwydwUdKy3k0JgjyOzL?=
 =?us-ascii?Q?91RZY8rFZlJ/XWf76gKOFdHdJsh0xAqU97GvjW45Vq3OrTeFlhBOjJs6hWdj?=
 =?us-ascii?Q?GQ3jKkJ1vM0UStoa/5soBrVYACdl7IkOHNsyKWcQalJtdIw0QQUmrFllNMBU?=
 =?us-ascii?Q?HP+QTYiMXkiqmVo0pIJgSEtd/WO1kuPRK2I0/vTxOp6B8J84MKNFKkE/l71B?=
 =?us-ascii?Q?iejUIshXGllfaqBJuZMkYagzb9a1O7OhJVYK2t9aEwn5NoQz92qjaT5nAtDF?=
 =?us-ascii?Q?eMfk1gaWa2wEh5gVYGZfeYsY56Q4We+thgZBNHPjyPAiuhysQe7U1X3+nlML?=
 =?us-ascii?Q?Q8wmcKrJbYywpyuqdGBL27Zod/5EoHCmqm9UQE5nhOHd6FJD0uTCPj4GrVB+?=
 =?us-ascii?Q?GMR//nOuYVhiZF7XckTdCetUhvmCdAYBeWB5SSG1LeMyoAdcburbEtR6fhUl?=
 =?us-ascii?Q?YyBPfqsDUG85nSMxQuQ1LgoXL6f2qsrkiy1L8STJpzjDq2sYE07BcPx9ntki?=
 =?us-ascii?Q?PTM9wQ5f7kU295U4wXpXiTrfAqq/vvUTiWx8DhuDSaeCVVqCa+BIZiTjzPGp?=
 =?us-ascii?Q?IcfomFzG47LGetouSUIHwCHAmJgDcVOkTrRJ3/VyKqS3XClyTsoljqQFgDZ+?=
 =?us-ascii?Q?jxh1HRicTFHDRQt5fx8Msk2/wr5Enuwsfx8Dp5ML8PQ8HfdWu2gv5WEX+rmv?=
 =?us-ascii?Q?F/WRXuX7OfT+iPgYMQD9yTGAJCpukmgrw7PyUQJAxabBtmVU1fR7c2MqXuPj?=
 =?us-ascii?Q?v7Pct0vraIcs7qm1C/ELbK4GUJjTQ8DnWlTpeBTPBoQNBBtecYg2SKBJZmvr?=
 =?us-ascii?Q?V2dlnGcLu05nfpwt4ts8601/M1hDPdzKY09mcWMxHO9y4hi4HJBkz6j183sq?=
 =?us-ascii?Q?ZNQPk3pgeur/RZm3x+z5EGmlujO08dwj4IHXCUXxtpHOZx7akYDl7iMNX6Y7?=
 =?us-ascii?Q?pyhFUEpFsPTW1t11aVN4pHQxp8/q+aJVZhTMKyk5aUz3UY4E5GHvz7vJk8v3?=
 =?us-ascii?Q?5BBkfDpoYdRDFogKMhI8b5stBUbE+MBWtdVxxl04PAHZrM7TnbcLSHtUg+mT?=
 =?us-ascii?Q?gYoqoRW2ksp1h6HOy8Mp9H3lwEoHaEowp0m7MxzEaHxHqwK/9yzhKMO3ahAs?=
 =?us-ascii?Q?n1JIzrJGvwhTSTcEOvcCAAPckgEy5NhdVEQKMcsXMO6DAjvevB65JK4htMHs?=
 =?us-ascii?Q?D+AEOY2m34O6WeHt79S2qUGlP8cLRiby29V8WKsnvK0WhyZaF2UJiMPAMyY3?=
 =?us-ascii?Q?XcDGqVWogVj/nAbh9eaG23j5cHoUsIuZ21GE6F46OjpkTnbEPv4+DLcQNReE?=
 =?us-ascii?Q?7y/C7klPFMdCXRzd4D+wBIVU8irydWyq5A1VPKocERT2YP2qlFdS9cZj9Cgo?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	A8zuWKQg8S/gfS1Xu6cNDxFVs54lXMhzfl4GlfltctKA3PWdjsyawFHqZUVu8xiYP279P15qvQYH++G1HkZ1FDAwN0NQBFAwcgLr7WFJOmJsUnzf3G4KQNivp90QBz/a4WQM4ph2SpNiRMWgESyqoM7aJSEkmrPRF1RCAcVg2KIQ4dcjgneqzG0WWUtj2r153aZwgSTPHBA7nV1JkKYXWNNrfRAijm2h3eFbumyOHol4yPDMePsjWrg5DXRbH+OdcmAXjL4QGt0CO/xQX1buBluPi7c32eQPyOuSzy7kRRSPFtHa9zum7VLL7gjg+u4ZPhV4GBOfnMKhYT7QKxh2Nx/cSXqwvrhyR0nPl4oEC3iiMFrmdW/4pXH+1t8oTHnkpEzpm/iC9tj5yQkvxTnK7IGN8CVaezkM1KgIXH6+NMKKTOt1is6n6EqwS2mhyA5rCSoYmZyhxshMw4qtVkEmbC9peoXHKg02XluaNsigbrp0jndJHXMCIsafmhJrbnYD6FwQh42YE6HaGRpqVIGTETWg6HnghrfoLaIIjm3A+rxweYlmEh7mFnJUY4LnPKutO1UFEruXaytUnsW2YYZUZT4KGPfJ55ANOXQiKhlOaIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc7d387-7b34-4fca-2056-08dc7bce57b9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 08:48:54.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fK5RdlqZaoc4klqV+c5Ljnb9u8gWiAjC7CI19y8UPLYTb+TrHhffsc2PB1Vl6o+Kvz5mxhpJJngve3yxZRaPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240060
X-Proofpoint-ORIG-GUID: T0hCwOOfID4S9CebKGaitMnRszBdDReh
X-Proofpoint-GUID: T0hCwOOfID4S9CebKGaitMnRszBdDReh

When calling bsg_setup_queue() -> blk_mq_alloc_queue(), we don't pass
the dev as the queuedata, but rather manually set it afterwards. Just
pass dev to blk_mq_alloc_queue() to have automatically set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bsg-lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index ee738d129a9f..32da4a4429ce 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -385,13 +385,12 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	if (blk_mq_alloc_tag_set(set))
 		goto out_tag_set;
 
-	q = blk_mq_alloc_queue(set, lim, NULL);
+	q = blk_mq_alloc_queue(set, lim, dev);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
 		goto out_queue;
 	}
 
-	q->queuedata = dev;
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
 	bset->bd = bsg_register_queue(q, dev, name, bsg_transport_sg_io_fn);
-- 
2.31.1

