Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E30C376
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 00:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726186811; cv=fail; b=qLUxFGKBBdESTP4WQaI6jc2L7/wtVYWCzSxxqW6LfHN+b2dRWlazqPMzec1QRjg7OfOTbzLBZqzDTVk1YPjgFIu5+nMKailGIK+/MOXbs5MFxyfb7uNwnkiF9kXQlNpxBcI8ERR8tjBXaMvNWFqhVBt1YDyKUhU7Ifa8sWWisgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726186811; c=relaxed/simple;
	bh=5HAxI49u8hO1GLMs/FfuMHPTo03Yq7ZQC4cWYDYVbGI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pcTRhYolg1hZhTyVNocJdLpJs/MDYlv6m6QjRjU2SoKNitBMlcKYZxU/sRfIYCgnsp7HfAYxQfk0BiFW8hSojHlUtA6rlczany9r3QEHIze/5EmPg7Ir+Drk/UBKy1qge3HF3a3X73PSEtXLy/82fdK5pnljjTIJpgpSrpZp0t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OFungePI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PFzVDE/0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OFungePI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PFzVDE/0"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYQf021202;
	Fri, 13 Sep 2024 00:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=BfDVbfNFJQ2qXN
	MFxnrtIVjHIn3VzmFIJVIVK7Ch/D8=; b=OFungePIsF02+crSjDeimQz8GC7XEd
	XU6eWx9znDoU+R3euH16mvH0oS7zM4GRT4DP1F+wYYKBrcKCAjIBDJYq4kGeNXgE
	65OZY1aEOpsvZVJJsmLiU74uYrkA10IUrMkZbHPU3yHmHJ5cZAFx+HcTp3gbk8jc
	NPRJqeymuHIyMapy9b43G8HuOpxV4GAiCBrr0PHRaclfBg/CqVlN8gg9i1CgJie8
	ffmvjvXzrSmrc4ObsgcmsMBswGZhUQzYilgztZZSXjbmjyJvcgkQGW/ygsBU2YjT
	G9I5lBjeZgBo7FJHdIEF/q7fr6eAW0VI67PfFbM9GVFdR5b7beaNEkgw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctm7d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:19:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CLWG9d006393;
	Fri, 13 Sep 2024 00:19:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c16ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:19:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yv2FwEXcVNlwYoptthEeD7+do6jLFjRwWCLIZ9VpewsTGme3XJlgac4oT/CcKLyniAAp3nyiry+2kwACuFYNOPNYH1qyYGjPYGENql+vYzLlISQwQuMeNsxh3uMX1bNaQgKidK6l5eA3iEyNzs0EO0sw8YkIAJo9q0pBo3BickubEmP8aC/LhxOl2GC/IoGlaFYknmeJAS3LHeZ89O3yhXBrGwXUyET4fwF++yUymp5uNk689FCUOn7NkCr1h+tEBeb/bHyqLNwg969OKGBVVDkT+GZcizgZ8VEXM4B6ENxKnF6boMMLL12Ydss0IjphWbvF+JM8neIdiTGk7QhJ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfDVbfNFJQ2qXNMFxnrtIVjHIn3VzmFIJVIVK7Ch/D8=;
 b=UyGRMxt87JmCsS8i/IRAkiTMEdDh12zDcNebBLUTYC88ghvPxzBEpoA0mkzVID/MK6t3Gj4Gb3TJXPNeuBOezGxwnOm2JyRmqkmZGvapg9OlFf2WK4Jqj7FN6+uhRWFF3SaI286BR1m81JZ5FKiQXRBzCTobRipHMJemOZuUtCC1oMadOyJV8blE9TEdvVU3XPV8eNmbVfmurQ/Yt1tDCUscH4esTf30vwKhi3S92iLBsqNzr4dtpo0aqmq2awa6+tZWTZcKNfuRqtds5hLfzQzmerd4EW4GGveCx3J7bILFMxFDeBY3Nzr8ihWgh2rK8geP9Nt4ityIJV/IO3Q8DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfDVbfNFJQ2qXNMFxnrtIVjHIn3VzmFIJVIVK7Ch/D8=;
 b=PFzVDE/0OoRC4J4LSNF5TCZItgTl2mLCuNgHoBFOkqtRAC00i8x79OosZ8TC2bl8GNP0klEe5TXmJE/Mr+HAcv9xbjeL/sNXpzAH5CcnI9j905Nv4GrbP1Nxb/yaKGKkmIrQvWYGo5iZ6D+E0nyuMGHEZbeiofT19qa9R4eyf5s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:19:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:19:36 +0000
To: Brian King <brking@linux.ibm.com>
Cc: mwilck@suse.com, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, brking@pobox.com
Subject: Re: [PATCH v3] ibmvfc: Add max_sectors module parameter
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240903134708.139645-2-brking@linux.ibm.com> (Brian King's
	message of "Tue, 3 Sep 2024 08:47:09 -0500")
Organization: Oracle Corporation
Message-ID: <yq1v7z0z9pu.fsf@ca-mkp.ca.oracle.com>
References: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com>
	<20240903134708.139645-2-brking@linux.ibm.com>
Date: Thu, 12 Sep 2024 20:19:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0207.namprd04.prod.outlook.com
 (2603:10b6:408:e9::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5563:EE_
X-MS-Office365-Filtering-Correlation-Id: bfde9f13-f90d-428d-bd6a-08dcd389c022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TiIq922A5QQNx8hC8w3jaOKZ/LfmR6/73oVBf8l8890nXgZtm9NZHexfl70U?=
 =?us-ascii?Q?aSsLj/L+EgSLw1Rdp/YH8vgF3tMamBGl1lj1QSslqWHseofQIkHrp20mTC5G?=
 =?us-ascii?Q?LSe/uQca0kuhV1JKl+N6gJnS0hXN8uyV4KGtcZl26yfOAZxDLuohEF3av8EZ?=
 =?us-ascii?Q?InW2OCbDs8feHrjH2BbdP3FLBkayTjFHtpKZAyvLfBoPtua5M3SJqh5MeTPr?=
 =?us-ascii?Q?79DKPIa6/mkvs66d+EDEdmHmxjrLjWUQL3VfnSXcJf4jr3wlfG/id3w+RmKY?=
 =?us-ascii?Q?OanXkvAtFgq2PaxSEQwYApuM/rggxzG9spnBttbyUDPfda1p6k5JCliwuPvH?=
 =?us-ascii?Q?3lPFQUx996MotdXmqf/u9IMoHugZADc4Ll7zI++E2cekfVrE96R7j37t6COA?=
 =?us-ascii?Q?s99gMgZFqcpU27yWdJu9qnZjlY1+tXSRKdvl5TalpR3JpBHoAdFBJvk1sDO4?=
 =?us-ascii?Q?lnZ49YR8zRX3L+uZyeyy6gcN6VjCBdybcXJYKfoCBj0j6lBGNvPzC2Z00afd?=
 =?us-ascii?Q?82xMo2Nz8pVAm94Aqmtdep6f4SwrOHlF3A0QCL1PRseiGD9SPZV1onJ9IQ0g?=
 =?us-ascii?Q?olb8zSjsFQntejBDbBEx521KaFThtg1HlgRUrnzId/NqClYVXf+xgjWO6bsw?=
 =?us-ascii?Q?V7QYAQ6VGUntYctXMrUA0hPE+EULSdeHkT93P3OVwHJB/bihHN56UDa6Uf3O?=
 =?us-ascii?Q?RNYO0+C6TJNuDMXbOmNbVyRDXYabMOJ016uMguaYZwMNL2hpEcv3Yhyre9hu?=
 =?us-ascii?Q?Yjcw+7v954TRpNEcAL7JCEJd2cp75zKS/6OPvtTD5i8ETOD9B2Kh2VTZkAq0?=
 =?us-ascii?Q?X2mAQIn8HDbqkVX2cwKYDuzmTu1qyuekR02IhvENJCE17WL5DkzxV4ibt5WX?=
 =?us-ascii?Q?MLvGbjPZCiIcI4hV/UzqFq8bt5Bxf2vFUIpXHpv562iBUoxaT5Pev63W116L?=
 =?us-ascii?Q?utv6JAX1gWbZIml7zB4QGJqK0lhK9Z55tASkNYphuB3rQ1nGXqUgrfL5IkFp?=
 =?us-ascii?Q?sMKuqu0akekp1p4XCmcjhPsEzAbo05IgPb3HeePXKaRhIPxfXm3O8SizXpzJ?=
 =?us-ascii?Q?rQ89fCWMem02DMZDo3oMD3Q+URVD0/jzCwGLV+y/Wpfykpu/V1f0IiHd4r1L?=
 =?us-ascii?Q?p2TujVgf0W0zPcyw10g7IlmyPMO3n1tSShZiOcgcRhv2w8xJpEiH9p4hdojT?=
 =?us-ascii?Q?cxoe3pR8aNAQZQXy8WiN3MstbE3WmaCIkyOC4EduJ+P0UdwHNUIt/Gb6stFv?=
 =?us-ascii?Q?tFLQyk6QmdJhPkVXJRxSdv8cpY6FcGZVHi+f+jcwEenMreMOBC+jk1W2MkxJ?=
 =?us-ascii?Q?dFCcz8sTyBhs0NAZnSjBoOQt+v8nnThZ72EjRVkE7OxaKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mkoy+wSo4h0Xm0q5h5bbWXH8QcxIJVugmWhm2wIxqpny5BzoHwhu91Kujp7z?=
 =?us-ascii?Q?NzP50EXdqL+meeZtIStYGYbQym3xkGFCbZCIIXFyxGvcmK1y2bmYdYgiUE/C?=
 =?us-ascii?Q?Ug6B1SaS7g4dcU94BfgNFPHZXH0FMY0QsbuS70z4EXbhS1FVwxvgqeFM18YY?=
 =?us-ascii?Q?tuzMJxYFlMqhC/UNvZYRetyqHwZXW0FdiPC5RL1UhczMtKlp7A6vd3DvlqnF?=
 =?us-ascii?Q?SxJqtSN4VIUWu1mfT/BuZbvRY0enARBlZrFOIvjjsnS6l9UcmMlY2JdvXLNQ?=
 =?us-ascii?Q?SuCFWO1SoqWOUe8F/3BzENIh77P7L71QUy+pMaypvC/p694I5aBi61y0kTy4?=
 =?us-ascii?Q?oKiL3knGxEnfit9MFxHkEVJCDUy66PeGyboaTZ0w2Y0SO7cZLjNxhbXMJtQ8?=
 =?us-ascii?Q?dh5ItMOb8+Nw1rnZhT1AnYWVAjy8NGVsdy++MEYL75kPsntkL9doz1xjhmSx?=
 =?us-ascii?Q?4DIdXTmskgaaf88ngcRlTrJLeUclj4+undWd94l9qGCwBLg7owfB6BaDPg1e?=
 =?us-ascii?Q?UJGbQrfHMpPugOsfBrZjFUoCFf7RlacW7wJVVvGeO8D7QhaKMNW+ptR00oUJ?=
 =?us-ascii?Q?serGIHYF2Yc6zYucQDBlsWjiUsLwCEJVhwYt71xMdHAr7G1FfUccyYVHrHgm?=
 =?us-ascii?Q?IONuQJ6+H5zTWLBBuSzXjdEC9UDggbaDCQprNVQJYvH7CZVOakaoW1r29cF/?=
 =?us-ascii?Q?Q39MGWcOMh0qMjdgH75vd/E7hW021QUnVZR+YkclKhgTvTkuS8ABJJLhryK4?=
 =?us-ascii?Q?A7JHz/eUPlz28nipdYz94Go/1X8+iLYvXIKa1EXguZt+bA3+duGUFLVnnZkZ?=
 =?us-ascii?Q?Q1ehYLskYf/fUZeANu7V2jmchUO3/1LmEVIeHkMe4QpAi1m43XCLzWkh4Qew?=
 =?us-ascii?Q?A8PX6tmT/xXkUXMQncncwH8HH5IqtVDO5UIsBoFen+RN6Gm6yRc+lye5/jZj?=
 =?us-ascii?Q?B45727hWU6xEF9EABbWKo+SC1TKKnwNzVeMCPzVYsQ1tB/0c9W1KhBcKEoUb?=
 =?us-ascii?Q?dFG7tgRmFrBSpiwduivrpGWjQzN7MDEpUc5T3EcqtC8EbZznS2fb75MrvtW9?=
 =?us-ascii?Q?CYFbXo/Js0+4h33uUxfVxR3plc12ePog0aZwRp5XqGEPqGOzJxxLr2qkt1MS?=
 =?us-ascii?Q?ykI/CObhcdoaCPsEpCff5rNJEw/0mujUq/BFMPaFXrYsOaQ5zlR5UgcA45bB?=
 =?us-ascii?Q?/7cmrwYz9PeO9vYQ1thKmjBarZUxRGSc7T5Gw4M6oMI6bIzywG+B3ZOQsNQm?=
 =?us-ascii?Q?0F9QCEUw2o4su+TKRs9J97+Rk8DGi0eATb38OFt7tTg96bZ6fyUxDe9s3Mu2?=
 =?us-ascii?Q?u76yCPpI7grSLL9ZB4gV64UJm7K2RROPGH6Szb7kigtCbbb6Sqlvwo03NukX?=
 =?us-ascii?Q?gS2WoQSguCshhJuATHCxEcXq4E9elQ84QwTVGUOIeBbkgAr/8Bf0/5Vzo7Sn?=
 =?us-ascii?Q?FpzcmDvsHMhL7MM5Tw6oEHomi9tRZT5KykqiiTxD0QW/lpzhJw9dKMkf/2RI?=
 =?us-ascii?Q?OYV6ZJgfYM1D6LgFMFQaD3XA7F/QHcV0/8QyJuacfQOEgR6gxxRC8aEDNkXh?=
 =?us-ascii?Q?aInKzg87EIKUwwQhMHgaVvNkrRtUivkPuB+6FyX2YQP1nkhsE4JuTUMjDsTd?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pki0GOrSYi4JTL+BUwP+3T12Nip+vTkInutV0zLF5UJ4uHxsVm5IGIqr6muI96vFv0Yti+kPZKeH2kr4ACtpA6+OJN/kXXJxFPg+9ofxgOO6mDUbNQrc8cscSXxjWLZxE3CtDWT2BaNInR4Bvcennud2ik1u5FdkwSv4tQtPlpcRfntlrrdltkSLtKB7DfAXH7622xa4wm1Y2xZ8LSioWJ1T42qtBnacCcgTjT/B64BnOano2PmQLKPOYhrFleCfvFv9BVLOzwMWTuhwwdyF0KSzej+EruODa53Ph0oVpk4y8TOufojTVljfEGCRnQXSYKXLW7xCjuzVMU/1UUSo35ERnFdk95IRHSsQnz2rf/LirPP10h5GB8iJDSl2a4Glmq6ZQrnd7HNVgkMboLKqwXJxhjOmfEEpQwddW9GH3jouRtZGdzVb/yKAhVowjI1ncBD74TRQ46tNvY89L/c3ZPoYlh8JQTqMsbB7sUDWoEwDiW7NZXv9b9o6JLnqxkQ36C8ru+lydWS5RW+H0q4+JBP2sxhK85rqToJCX4+Bl3QZzhttvQtnaf5WnFpuMV9CI9tgppemBp4KoveDOgz+NU8J6rTZC7+zdZwFlIRDYUA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfde9f13-f90d-428d-bd6a-08dcd389c022
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:19:36.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRS9U63/84Ok5XiX/8fo5XfTW1qlTPRaaMKtN/A69nQFSLQ6rPcA3bnfm53tElTXo7OUcTM9q8VGx0dUA3u733Q3Ph8M3iswTeuCG6cjL5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=885 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130000
X-Proofpoint-GUID: y5q3l3w2l-I1NVr1V0afSymH6NPKe3RL
X-Proofpoint-ORIG-GUID: y5q3l3w2l-I1NVr1V0afSymH6NPKe3RL


Brian,

> There are some scenarios that can occur, such as performing an upgrade
> of the virtual I/O server, where the supported max transfer of the
> backing device for an ibmvfc HBA can change. If the max transfer of
> the backing device decreases, this can cause issues with previously
> discovered LUNs. This patch accomplishes two things. First, it changes
> the default ibmvfc max transfer value to 1MB. This is generally
> supported by all backing devices, which should mitigate this issue out
> of the box. Secondly, it adds a module parameter, enabling a user to
> increase the max transfer value to values that are larger than 1MB, as
> long as they have configured these larger values on the virtual I/O
> server as well.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
