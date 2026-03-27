Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938725A2DD
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 21:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645903; cv=fail; b=mkwbSO5+wTRnlLYCzD+yJhpAYkUXMDvHkwgI8JFZJ4CLvuOItUsW5AImpG5fGCLp8mfd9orIeEY368yMTtxq6Wy57Usf+MYurzzr+/K0vzYGxJTRC2jh96dSFJzYteUMvpCWl03CSR4wEUYZxZii1V2I5MA0EjcY1Ng/weMzgPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645903; c=relaxed/simple;
	bh=ep4kZ25D6geXmvMW8/luARd8DGM/0NFfuBRbPWxMOUE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ef7Cub2CaNftlLwImpBP8WDBOQK84/EhUzjr5R1fEwYcAx97sXjVC4h30vfPVVX+syhpY+E4o6kDONzcyB1zpWHjABLSPM7yXtycoURner4tquiotZts9Z25eNZ7CCDEZReQ1AJ5EcPkgdYO1UjPc9J4QBMh9hhwJ9hcrKs/hHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dK/cuGmH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZK5I9dFd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dK/cuGmH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZK5I9dFd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGu1ND3771475;
	Fri, 27 Mar 2026 21:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8nT35l+iMDNGScATTm
	pL3b7el/WMVoI8+GFQ1POpzvc=; b=dK/cuGmHSBCBM89P6Knzaz670pyxGMguVR
	3olBJkswwsh4KNFcpT/7uHk/I+o17ffIqkbjiMQe73ZbRqDr9yRfRW4EfchcKxTC
	NoFPUrRTnlEczWnb6wQa2DxzQ83gxM/V7/9f82AMjwx+k/U2+NP3Uh297jGIre1E
	yhcRW5d098Mbi7CllaOpVZAqSCrErPgxMsQpEJalU/4plBuP4AuK8Cii7YllGWAn
	uqKExM9euzw9vGqw8ho8IssJKxS0HAeHB8XZ7zvdDlGYxYKWG/pUPEag8BbjVQOj
	t0dl8ZcCFLAwDmM/dD/hF9cDjtNPKFyCC72YHqxg0TFSiLWWMksg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kj2jw77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 21:11:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RKMFsB028882;
	Fri, 27 Mar 2026 21:11:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011045.outbound.protection.outlook.com [52.101.52.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsewvvw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 21:11:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0ll3Iy9+DW8shGq0/xHlHsNLLupPVtQJ6YZ5+PXr/XYrOzmlgTgi5dI6ZM6Ye7mmg4e1ACsrc9+pA6SDHqVPmy1Zmk9Jk46BytGfQ2ibGb2/C78O7xrORRRF7PLnmOWAea2bncE6RYT89eYLxmiN1CUEw49zLsbKNL/eikZ5Tp9ubkGhSUDaQAOcnNhcov/LgqY5MeJDIYE5EXqxSjt/LAVgfSP3Izy0VDeQmh83mw0+jqNOfgya5haVuJ3NReTMOZda0bT0Rx03pI+e4EJ+7ZXfkiXdyhakPVaypiyMku/UdP65qN8zC9NnHT5ObpyA8GvroutRng+gcFuBQ5meA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nT35l+iMDNGScATTmpL3b7el/WMVoI8+GFQ1POpzvc=;
 b=pnbW1s70ORP+FyVoKYe6rzHh7AMm1TLAaYW//Cf4qm2eTOPUtmpg0yR0gItXqG8CiacLNcmQYg5EiMRnEjUP9Wt5dBBjqjnrx2WIkdZD6vIYLgve+QK/JhbTmbpvIjg/wUZKGKDW6nfASDEnj/401Qj25g1JmSBjv+GHDJGUTIauVg7KsSMBQ475JrSbRbe69zUFjKxQs8APcCoqgnjdlHBR08+gJp3KGAPv+CcwZh+/pSVdsg+u/zoAnl8LttAAm9Xi04nSFgCHhr0WZkSeGf485lnLuyoHvlm+jDe4gydKrzIQbbYZcFK0ULBWiYOXSrkJ3yZ8vGdsVX1oZp5FIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nT35l+iMDNGScATTmpL3b7el/WMVoI8+GFQ1POpzvc=;
 b=ZK5I9dFdaj47wIXVJY0eBSOYjaGRcnLBRDgORpgCV03GOWz8CEdoGUiXiqgbS4V37Kwr5z+k+hzSdn913FoH1pf9QFlH9uhn5rzWlcfPCjIgbRIRO180y14c7secO5jbyPe1fA9y90qGb5eIbjCMZtlOLtRlDciHRBesWFTrZlM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB6722.namprd10.prod.outlook.com (2603:10b6:208:440::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Fri, 27 Mar
 2026 21:11:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 21:11:34 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v1 0/3] mpi3mr: Enhancements for mpi3mr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260320090326.47544-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Fri, 20 Mar 2026 14:33:23 +0530")
Organization: Oracle Corporation
Message-ID: <yq1pl4p7zb6.fsf@ca-mkp.ca.oracle.com>
References: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
Date: Fri, 27 Mar 2026 17:11:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0030.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b2ed514-2ce5-4db1-c3f7-08de8c456d07
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 oauPO2xKc6MbiLLxbf5lAtDh5J/BT+MQfO3ICIslxhQH1X7VQVE3H24y5Ll5NZWNpV6gR+x/QhIQvfrHNqEQMDchkE15xR7CCHuFFz5dQoFMBViS5dSXG1Hvlj5+xjq+jGahOEKPRc+dxbORX0WnzsrKB8iXatN3DbdQ64BF1wQY4ZfU5UbruxnDfOFFeha4WMajmeKsxu3Mmz28JVHvOIgH2yWgFdSlIidag2K2z/qXBSQrcz6kGI8KtCy7ZqzAi/VqWIF5J8B5IqyQdw+CMmIVw7JR7If1d7YDjpcO+N4iMtICu+s31vyELdyLlsh75gUDjBWdcNTjmIgfMm9kfm2m2F5wbI2xK2ZJoidmxxeeEResTBO+BV4cacN4q6W7IMy17tQsfyfw82DRJ39snW6S3U+T4kapZLHKRqeSH+cLoKjopYDkWwsDxl6JSURN42e8yd1y1XGh9ruMQPURxAzt6w6BWG7t4ZgbaqvSwpTcv5NJGnLH8HnvGF0Rf+/PBb3KrrF7sdIgiMqArLaYNH1bMxCyiOc2pcRu2pML0qciMDFD9cX6iWag9rhaOmvyzMDu7zL/zSFfKZeQg650kpqrXDxPdzGZRb2LTFvcr1DlhWoM1MuFFi7VpfgkSEfwp9ks/ZogPYroWCOKD8tRTe7PzLtr8XWTw2YpkxECUsDDEJ6O8CYowj4L3x+7db6dFEfHmG6crVWa9IWOnPA3FhJcZ+J+tmo6Zg1HkineHQQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?zNgGyJzthZfpQSn5xVI1sV/ecli/tB5hloTatpLiO5aGXcGh8AHldzyLnw6z?=
 =?us-ascii?Q?icJjBinfbeQIPlImv+c7dcOjbQXkLuITu6dJ0Oo2DD7yHXhc/UffYRci95tD?=
 =?us-ascii?Q?gulTVAheRU0pFVuKtaHzdaIY+Tt1/Hvau6unJ6IBOJk6pHyxTCowwRepA/Aa?=
 =?us-ascii?Q?Oe6eiDS7e3snd1tlpqjvCUFBGcytT+HGLzz3PPk+rGHO5PF6znDXPLA4JnsP?=
 =?us-ascii?Q?atWq5lh2nBAGqeMF4a7KAl7NnwqHEHR2rHfDH6ie1ZgC6HqmYbYtQoHnZAam?=
 =?us-ascii?Q?/NnikseSCwCrAr3blGmI7dDYrGaDLLMwXKgQvTzswMX9rEEcCsWWuvs/NWZi?=
 =?us-ascii?Q?kczdcfhqtCgHj513a+KEbxY2cDqGyllflwQpIBUgpOSPCcGXYZK+uMALmM5j?=
 =?us-ascii?Q?T0hOBA2V6qklKAv5UQpa9jg5PhQ2tF7V3qCJwPIRbMf+7HPiMG6ufSIcr2W1?=
 =?us-ascii?Q?UoaQrfXxyBsE+zc0RiMeaUK5twYNELYdfO3rTlj4NVh48ewAmaO1jxO5GzUz?=
 =?us-ascii?Q?evYqr+gDdiort8U4zM7i7iUIZ3R0GJuepktd3alj83jDKfFNFEbUWlvupTsp?=
 =?us-ascii?Q?oxvDhXRX8CV3wh7CK8i+zz733DxN2GosN43BQo04qivVcmjhZ4r/6r0kdFA7?=
 =?us-ascii?Q?DNXaIP35EcMmTJfUATmlVIXTLxaD7iW4Ntc+CuMXm8tWGv+gUyS2ZC/oqRFK?=
 =?us-ascii?Q?QdOLqKYmQRyEwY63GJPJha0xKZRX1Wbr/rGdjhLR+H533cWN9V/0uKaD31BM?=
 =?us-ascii?Q?BMALwt4y7e3pX9o2BI8CqXQTMM3s+PVXkBUUfwIdJ0FczQv69pZfV3VFSzsJ?=
 =?us-ascii?Q?t2zYHchyiw+GdqzUyZXYsghgTjg4OX5Lx8MvjNXzWuaFw1sPgx+ZumJ+mKs7?=
 =?us-ascii?Q?sWQeCHmKPi93NBpVXEt1Wabuxf0v+Z4vY0II5CEE3Xd+Jw+smAMs/n9tGdAT?=
 =?us-ascii?Q?NGt0W9zOgp1oKzlxZTqUse0C7gCu2GImO1klB/YYq95ev0EgAhFXiwn+J90S?=
 =?us-ascii?Q?Fw88vIdCrfCKAmyih5W3/nVzw1wnTfvgcfIjTbU7AUr4xu3IEEXFE/rzk4Qj?=
 =?us-ascii?Q?OrMWMU5EnrGgGB9vg/jspe+l3MxsPXEp5wz8G50YvcXBOntSl00xv3VxWwS0?=
 =?us-ascii?Q?9PSJpICGYm36Qv7Xwd8KcnFdyffAKi1QX81PKDzg9Ls82SVZCB57bAHdZ1/x?=
 =?us-ascii?Q?IFOCDptWEi/MfMTy5Z2kK5xXTkQSgWvZTBu+cuvn2u+VEBlLIFoLmVAC/uDZ?=
 =?us-ascii?Q?bMt2PNN0iL4FBttDfGzpSA1wE/0s/Qgbo/8ww6F5f9h648ZaNiCmLTIHDzio?=
 =?us-ascii?Q?jqnvJW/J6EoqpS8gQFJ2Io5Oxn6lguk8Ft++s7rpj82XFvAXJ7M95dCKkKOb?=
 =?us-ascii?Q?Eo/+3306tFo2Uy0UGmjaOENZd0doT6jIxGPmBipjSgO13/nSfp3zZXxHr83Z?=
 =?us-ascii?Q?C/tqevFt1WWvklUGTudCdekivbtm1HvIhvEDp+y2wZKjepiyGk/Y3Qo4wAGt?=
 =?us-ascii?Q?KWpW1ByqaJB7AeogBnadqsCJR2ozjvtXnm58saQCvVKr41urZoDtQo+LU1f1?=
 =?us-ascii?Q?x5jL1h9L7fuTRJ87YwhsL+Ewdh8ec2zulZd1XuR5J7c+vmQmRmdfJRW0zwFu?=
 =?us-ascii?Q?AgYQmA6ci5Ehuvhzt124JkxBRSrWROBvQkEk98C40UiQwmvtg/GodmrwlROF?=
 =?us-ascii?Q?4AQRIEcKb3m84RK6YOnVmjBCRLPmg9aDE5FkMIYdQtZXNF3otE2fiBX/QhVs?=
 =?us-ascii?Q?SWNFbXMxIcAs6UuSwciFEcTmyghmJiw=3D?=
X-Exchange-RoutingPolicyChecked:
	EIlLyGDOvofPRpICsGG2iO+PaEe2HO+KYKMrYN6p5IVIePeHvfVGKDPz+YjNhKOaomr1qY4lSHoIGaFqxaZs4EElm4b3ZkfDL+ad3e7PjMFY1ZOgpI1gH145QghNEE4DITjx8gFL1FUAA45WBHPfQUCnNxNMpT6o/nSt24gU/HVujxWXUdbJvnh0z3KYmhLEsZ7cq0ngdn6lwx0sFfiO+ect5cmJku+oYkqB512UouyltsAG4jY15qgKTSKkPXYfD1nnNuCFzl4kJvGq9KWaSqzqNvTnHiG8H78+JWiFjsJtC1aMzZl03AJ1oCP209CloBsE2/F27Ry5IQFOjTCdMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LPd4FmT23b5YfUTCnawOLS3jaLBiSXHTQHiCzxZAiv3VrrsloC93ncgsP1DK2RgJRRzdiGtQIKVv843vi4N6ko41qGxKBYvSwd2yOb+jDIA1CzVRFaLN+TvOz9UQwD37D+cNfMPvI+lE3S0KqSO8tJM2yoVpTqVTjza8gKPn8nMZGfobxKAhEnE9wE/uzJ5NEqS5GzmKYEqyiDzpdlQlREgS81DIwCQkW22bYToi1o84Z5A63vqR9adJL7eKCsnOURyY1qqodFMRUUMAiPKMvaykjLQFO0FCYffAXqkj9d/uFJ2zzJcGey86PRTZKY/U8gDHoTZc7IhiF+wPvTdfFKdC4XxDJo9IiT+5d4tayppZnIrymh5RzTqEKAZg0whXp8nzyZaA+r/IhIWjGPOlQVCd9QJqyld/a2N5SZIW+OYOdkT2IrxLskeDvLHxMDP4P+4W8fCacJWsqn1zzkeEhb8QF/z58ubyeSbMk9BVNNKwWiK0T0F1rvn6x8/IxmK5ujEKzVG8Mweusgw0vNlo0OLEvZZqMqOC8J+e1BD9DP7hDSdm6EJWMSz1NVwhtOxpnv60my2BAQ9Q0o6QXLRjYtcjRVtQXL+5kXz7V42zP3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2ed514-2ce5-4db1-c3f7-08de8c456d07
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 21:11:34.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YGu3TSOUZrMxz3p+/+jVf0UYAsxmRW6K2XF/0Cj/OS8Pby/bEwOrnZHlv1+Qb7Wf8Sl2MXfh8EqYUdSm9heqZ2FjhYETD6OQM3TNUBMCj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=818
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270148
X-Proofpoint-ORIG-GUID: ZS8_0mErgsygP8oludHH-Tu2zBEkEqIi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE0OCBTYWx0ZWRfXy7QUKHbhcpvR
 9iHCVkD5zgtopnMl7F1NJWYajJLiRAfwXYmzN0MCvUHloELimLZZLnMA7vvZVR5prQrU/Nok0XG
 9pxB3OktEMDtyBqkTF11RfOPGR5Ztg5NcVwE9v2fPRlXppz7srVD6YUGDYj8OAHEbranbx79Sg3
 aoM+8CHNnZlCCroMm/vbhrsC8vKoKpFmuBy1ndQph6qCkivTmOAsP0bWtJ8CfQ+DkHnEWJZhiq/
 KdX4bSxEW2/R4kvRx2sJiuyoQbO5S7XtJPSJ3jVHp2BV+ez6Qf6+tu/Op+Kp+wYhjf4QXFCn6vm
 5RdK9jE1sZmSgeq/YRFbaQwxiP9ck9dF+g8IKZH2nT1clcFgODVLU6xAOgMaP9DzGX34GpUkn7X
 G82veT0wR9iMBCqrdZQXil8YL6c74WUd6cPECndvDj2Pu2GwT0Bg1nf6SjCj/px1YKmATHdq+QI
 OmEy/drtEr3pU4AwSuA==
X-Proofpoint-GUID: ZS8_0mErgsygP8oludHH-Tu2zBEkEqIi
X-Authority-Analysis: v=2.4 cv=KtJAGGWN c=1 sm=1 tr=0 ts=69c6f28b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=ZqN9JrTWbv8YwB4YWy8A:9


Ranjan,

> Enhancements for mpi3mr driver

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
