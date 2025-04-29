Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5062A2FB2
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 01:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890780; cv=fail; b=YNPJYUILzffmJxqBZ/OkfoBtFL9pmq4F/YV7Vz5gI5h5+w+Q365/78fy7t0w4fZ9Fna0g5bsUbZl/YAJPwP3pao+b6ykbAYzHh7a63c1Vg+gGhnZ95WELhV1AldN8lt4Ni8v3JqF0oNecqocwgimuXGrqveKX9xRd9jbwevsg18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890780; c=relaxed/simple;
	bh=x+iQ1kHVGgMmrL0e55ZPQ1PKFk86XLA6/K3PCjP//ZI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NHszoHYiDe5AgvnQfxY7ZtIL67xClB0NXnInrWU30xd8fI3GQuy/ZJIZJMZKjJnhKKWnZnBBOPpd6vnkYyvvEZ09fi0TKK9Vm4bMvgFzNpNQ9AJ/SUocoWrhVwdSlDEDDZdPCIgv1w4I933UTmW/DsW42QBXywUnicGuo4bjkV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CPij2jSJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kaIwvVCN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CPij2jSJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kaIwvVCN"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1O9qO020971;
	Tue, 29 Apr 2025 01:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=V2Cdwr0lUprYgMETrp
	ZcdYdOqj0i5TNCA2mMKbS0R94=; b=CPij2jSJ7nMtvPPpNCPVgFBN7IsI8UjLzo
	tEyziQ1vX/PFwhYh01vmvtDqT+1W4B+R5/mcVEi5Hdb3/SsqQ6E1Q+kP+PZSHhzB
	pe5og/eA7hmsLxyyL/zVgeS304OSdgNV6XrCaLI3dmcMR9VQK6hTNz/xn17lVt7Y
	X86rEzbgovxh3KYb44CfrCODNcCPTCO11XchGW2BKE1A0YtWCTDAc9rBTNXbmtMB
	VoxsqXf5Q5XnUirXoJY5CQ5iYUAJ9doPaRQxvlFSRzstQ1nEAdwGJXeT0sDtJokU
	gcbJlUJC3fFS/xOQCT9p2bMHVAPJNVfAnIXvXiQKoCJ3KgZuAyFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46an2r80h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:39:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T00sIa023739;
	Tue, 29 Apr 2025 01:39:30 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011030.outbound.protection.outlook.com [40.93.13.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxfehda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:39:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=abqnH05d/sOiQr/Mt/F6Fa7dnGUrHW6RGvHRHIrtgy5mcuIf0YWyuWTVqRVP6v1vcTyqbbzZ2DKeP0cA3dCz8DMeLfUsA6A2sAPdVj/4IamBVUxvg6VJuPON7SND3hEDWVCH0asQO7qDt1Sy7hrpOvVO3MePtTyU/D0JnlgZpAMBuvAwPrrxn9cCsvv+D70iTvCJIghMKzqFUa/RIYpPxOzyI7frRR1ChWmXHRrZVmrzlOjTT1RKS4m8KYyokGqxrJiz0rXxJA8NhfPu/m9opUzA4lQ4f8C+sCBIsWCLcXCe3LUKVh/fuvpLEQRC2XTJA3ade3c15m54UqUVawdRMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2Cdwr0lUprYgMETrpZcdYdOqj0i5TNCA2mMKbS0R94=;
 b=JU2LFPX+vWd1uTzu3zI5wiDHDrgdbVAw2pH14SHigRciUt1sa6j9VDd+jHMDG7RMPfz5j9LkfBFXKNi/WvlfMpPsuyZF3gFkTY4eirONNT/DQggZVGboy/t7G21U6tXHxu0gGxPokSPHQAJe3pXtPzuvl2fO1VKnN9SNEO8qQQefGlmIqBYV8GUmURnKQuvSpmHdLViYaHtt/SUcBl3HuBilNOCofntD35squkp1DB//lyvyRIzizT9kajdPlBXWIZXn7oYvchMCX7LPranrD1yNCIIa8MRbi/iJaRxNc04yiBgogL13ZlfsKwVcIt2MH8yhKZ+8iokLhkkHowrJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2Cdwr0lUprYgMETrpZcdYdOqj0i5TNCA2mMKbS0R94=;
 b=kaIwvVCNyMK2IpUsq4bp5enyg6MIA3JOo3f3Lq2YV5z3VvR3u2Y2Lh7CJE090Up4N6MXlRxLr5WC16JVceCw59fT82OIbGiykrVs3bJCj1zSHp3z1MZ2IMFxhHgAXOOb5pKosbnJx73gG5O7mRzaEADNVPsM6hkjiS1XDUp0Spo=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 CH3PR10MB7957.namprd10.prod.outlook.com (2603:10b6:610:1bf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 01:39:27 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:39:26 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.9
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com> (Justin Tee's
	message of "Fri, 25 Apr 2025 12:47:58 -0700")
Organization: Oracle Corporation
Message-ID: <yq1bjsf3fw9.fsf@ca-mkp.ca.oracle.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Date: Mon, 28 Apr 2025 21:39:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::33) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|CH3PR10MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 07282bcd-b6b6-4ec6-e605-08dd86bead61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w/wGHq8EdKlJG7zNb9jnSo6XBS48voFzah02x4c08LyxlzlbKiWZDtIOFyrA?=
 =?us-ascii?Q?AEYHOrJK7VGePh0UH0AqciFyp/R7WS0lj0Zed/A6FAscXKCtdszmklNhzVmt?=
 =?us-ascii?Q?La8ctvWAegN2921G5B+xM51dtxkZeu32tfXX/CetDO/ODkHDTkOotg4bGk/b?=
 =?us-ascii?Q?OlcgtPtlJaN6e4XCqb9RikzzZAAM62hsvMhxejoZ0uHwHHDk/e4NDXMp6GSN?=
 =?us-ascii?Q?nZVrxAvy0BEtAzCrZIqBeLnRNiwB3NQaZqGB1gISY1/h0d6+cg5zzeFxRXPS?=
 =?us-ascii?Q?GibZuvVWr93hvSSI7JgLMnCRdoKFpMgmIbLQOWeOaEqdAQfkwc2EbRnKmaZs?=
 =?us-ascii?Q?8wJXwSIQSUAqK1XMD1oNvyY2OFOT610yeYJwunfkpdzjaUvreymKdsSvO704?=
 =?us-ascii?Q?/zDpuOoI1c3NOY3I+Cm5IRZ6FQ02o/uwUhjNb6QpVvDslAB4nkGZNY9rUv9c?=
 =?us-ascii?Q?mhRDUnussQt2o6fo4XQgTop6AU93mPEGUx4d0nFTZkZneJKFcSpSvXDurEV3?=
 =?us-ascii?Q?UTVaTVQnafvHwD+rV0aYUuY/fSZTgigUzInCMKG1gC6Cxpwk968JIOV8MBkZ?=
 =?us-ascii?Q?jFvjq6hHLAw2q/R61NAfp06qjiaw6c7FEjBwawjT8RLT+z+uQAFSphm7Nex1?=
 =?us-ascii?Q?hPBN2s4/Dni9RUCwElJXAL0MNhC53pOyc8wVf899l8G5jOKqhnrH+oy5RHsf?=
 =?us-ascii?Q?CSNC1JNo/yYbdqLtDYTxbs3+sNQyEyHsnUVFFu2HHyA0omq+ZC0TgKbwQlyd?=
 =?us-ascii?Q?pjFlhH8DFCq5hDXEvtTpsoO9rOE/H80S0jDpjjmJuNOaHTJ/027BYx9+nh18?=
 =?us-ascii?Q?02w8ttx7Z5fbgobObrkHzqE9clIiAP3WKfq4334LfohUOIX9+JhItZdUCSXl?=
 =?us-ascii?Q?frDH3GEQbUYcToy8OjFtnmMjSgT8cmpQZ/1Tfce2Ws4DA9+gNL9eW+KF+nhH?=
 =?us-ascii?Q?5q9o/WH5h38hp+6tksndihPqGeSCGQHzsRSl98xlCTLr/YeauTdCSdKb2rR5?=
 =?us-ascii?Q?xINYNQbzEKnQ78Q9PlCojdmV/IGFQTd1YXRuq69AGu9GDYoD1FKhMjzqiEuN?=
 =?us-ascii?Q?LP+lUKc4ohkpYgIJ6sqkzyUbFx6AQtoj4EFjbJndhu6iBCenh80XFa4hY0vW?=
 =?us-ascii?Q?00fsNrG39Q9A8yZlQnzEuHoCYkg0jSbKJCdf6JYEt8dVSMyxPNJfUFrOlP3K?=
 =?us-ascii?Q?ftpepAVvtDGeG5N3TJAJ7Z0umZUGwkqhVZsAn7qLSO+fEjNWILLIGOMX1jwg?=
 =?us-ascii?Q?G50KUiG3Ct4hYkBptVjxRb4tn7O2KyOT6N2RdjCGhmVsLBt/VsrpwkBuwGn8?=
 =?us-ascii?Q?5aoMfNdsj0xOu6Y88Ko+3H0DjJP1XMim08zyDtJhnP19YPJP0rD1C641V+G3?=
 =?us-ascii?Q?l3MoiqR5czVBDKFiaXMF0i9D1RC+Lw80dyilfxrbB6j8fYcz7Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kTzk9Y4FD2wx31wvebkNDpcxz3nve4HAZMgK1z6hFPnY7OEzvKMcjRwj3VIR?=
 =?us-ascii?Q?M66bUOTixlb7dTNT4DQAIBzUtRNT2GtOLLLiWdB5bAYgHd3so4MbcP7N8/XN?=
 =?us-ascii?Q?Czas5bcXjyGVCT2n8taOqBilbb5BAZeSq7eI1TTY+Dqd6lXg2QTfpLA5/ZvV?=
 =?us-ascii?Q?imuQQ5RgbwLAfV/Eq/beI77BVvKAAN7TdIRtlnc6Uq8VsyAKIt+Yw9ynaTxh?=
 =?us-ascii?Q?+dJIn1OO9V3MRXKrUv2ZgweeiSo2gTTNLgZvDYVn95krKvuziXWJs+A2C0C1?=
 =?us-ascii?Q?h2f8UQlP3IzMrkxD7KaizhKnDiwYkZttbK5TCZLHL+epZ7YR+uI2F8x/uKRP?=
 =?us-ascii?Q?P4SDrSKqZibnaO3G11dQT7F4e0lfrxjZ+4Ivn43BtaCQCLXSEz/RibdA6dDa?=
 =?us-ascii?Q?dam4uEOUXEkoJ3MEUwNmUEudd4h8nYcGO3NwZQU0zQcmzlIhzzRxG6LdmDyb?=
 =?us-ascii?Q?O6Y9e0xh4+5tEylhEJ9eaKJXnrlrbcvC7BcVEoV8cWcThvCmhG/SgUrNDoj3?=
 =?us-ascii?Q?XfdVXmdSXczS85AeLbzqK/SM8B2+UJqPkaaHjI79yals2Bf3272YuoM/qbGV?=
 =?us-ascii?Q?ZQFx4clECIu7hkJfgoPGYiPc1Erpz+JpeRymzbjZx6/G5RYYUIge8W6Ckkir?=
 =?us-ascii?Q?ugZSxwLK7sKsG7ss9EWUa+nd3WyZR0MKr0gxMnY77Tkc9uCWas9jRsfh9sBN?=
 =?us-ascii?Q?W2iwObfZRqKFYjOhuQdLForE4M/5YbK//4+HAnLGLXkv7BV4JWsJOUFqDjmr?=
 =?us-ascii?Q?D76ZA1e0aBI59d2QMfBEjhg+PRxm31D97QKg2hQm/UGes8f1VwtlEIjTjLfM?=
 =?us-ascii?Q?tGk/xx2ULydvnKL79tw9jQ2AO259QAIPVRhAf7LKrljyvUQ/CEhFEO0YaH28?=
 =?us-ascii?Q?GrW5Hc0NT+wNk8ynZ9Dt+wFhtOqGyZHv93Wu3mEDu185/0YtEwM2gth96Plw?=
 =?us-ascii?Q?hVc0HgocIvmJ+UG3ap9TofWkQKAfes0HyYNjFMMfC5dzgW/9jAdlYtC7qWl8?=
 =?us-ascii?Q?xEkAaBK99JLMsqfK48+9SIxlIPb4qzBAtTNL+bQqbqAFNARGvPldEevy5ggN?=
 =?us-ascii?Q?z23IUKLvTjafFE+n1aYHovptlKRkJ0kbAASJ0Y6ItpNfG95IaY+BcufSvfw2?=
 =?us-ascii?Q?wb8mWjEwpwb3KTtX0YG4YQ25NetSpd5SbiGYXOHHQrtRojAnLwssGrWrYDze?=
 =?us-ascii?Q?uISQ5/utdgtGWaenschi3klfQqxvSk8hE0cjfl2WCq4F0O4T6qMKcNSbPSHW?=
 =?us-ascii?Q?MDTkMrZs+WUsl+fFPxvc+gPV2cyA43RpPO9kEq8TSbdKl3woh4l7NGLF2ty7?=
 =?us-ascii?Q?U5Kh9XWx9jOask3Ew//RiIEdT0yjrwO5h1pknz+NybsjDP1TNsG+oZOpdG1L?=
 =?us-ascii?Q?bLqO9X/qFGCmwhCQ+xhdgq4kNC9BmhYbBRrGH4jRyOnGSZliualR4kkKFW2D?=
 =?us-ascii?Q?Jr/Bhxk5yW8iLPA8FKLMgSOk32QYNe5lkt3h0m0rqhCgu/wJEMFzpiIW0aWZ?=
 =?us-ascii?Q?YKb4RnsrUKMAebbzkpp15wyU8uEh1ncYy4swxhIhtVO36xZ2FJFmnJfGmDh4?=
 =?us-ascii?Q?jEH6eMpeF3KpN1ZWCWDcffoLqh1B55GTzl2Ch8QMkWBDbQWdmrxt6Hc/F62I?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/77HwzAit1iiL81FBMtznJvFDSBhxr/pASS5QBy6cidtK3sLtxYbE9DemOigJDJDbtQkGZVqug4DJQHdwYsFG5ts0840hMJ4W59jH6YjNmWuxCTj1BBkktGrm1SWlQ2iQAG/cPQ5qFgZdd04jNNqBMDvNic1XOrhD8QrHIRtvU1ujJiXf2LyZ/VbOtR776hljIkfxVjGqY47qczKkukTXeT2VD8mVQGk4eltx8FhZUuvTAzftms/Ss1VIVFuS0I92pbzsMi+CjjybAqUi0Kdud9Q+Dn0Eb5zUVS+TfGxETaLKTdpYgTz5DHe3MEDF66SfaebKsKu+hwUaPg92YXrTOAZ3epQSxJYwFdsgb8Rrji0Z7Z9DrsOvG6DUpPu2fisEbSGCwA/sVNuQs49MaF4TeIyz/1+mjGEJRH+E8m1IysOQu2hTUs3BiFVnJfvEpaLJwEkrd3bPRlHzFc2sibbo1VqorXsApGI+aAL1UEG0qfioc0S2pfqrkfdeA80burz2ZPCaFC2tPuk9rzbHx9j4ggJ+427ZPEdvWl8yZBpBe+681/tWsrwthV1CavK+IkhUJ/fN6spI/e7pCRVkbXJR9SXdl0WSOfDQdpiktRyjPs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07282bcd-b6b6-4ec6-e605-08dd86bead61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:39:26.8196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKj+X/28datudEV5W1OdsiDqZ+uxvUmnL/DYflXfG954Kv5PA0gafkjbRV2kobm7jE/gnuxD+aFVtixP7eo//dBW3C46mpj8KNjBarFU4D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7957
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=698 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290010
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxMCBTYWx0ZWRfX9ZbZuxV8q13K DNBaoIeNJ5ZCdNpw/Z6aK0MclhH9i245n9tSUm1DT+BO7PxbT8smmjjHHs9aYIg8dBZXWKgQ+iT s1aBAkJFwR+03zEREcPYhP/rhhhQ029f0dzwudQq6IL8+f+w7Vf3TaMeMbepWldCO8Z/MrA5FIf
 cw1Tdhurnig4RwWx2lm9CS+G/eMns6KSwerCv9JaaIPeLpGwnAmoa+j6s8wFVF8ud6se7qo9mcZ oGg3v/NFksUS7uc2RbdkbfvrvgevRvTDBi3Q45yQYDCV1/MEcVfHP/lFhOPR4ijJtCdjZCUFRIW 044NkqRlJLaSUICM8dkY5q22pZpz9X6TGwHfLg9Uf26QQ7Sa6aA/4keHGgcV4D/F9pV+FESBm9s IOcEZhf5
X-Authority-Analysis: v=2.4 cv=MvtS63ae c=1 sm=1 tr=0 ts=68102dd2 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=_RMQLfS3bXhigmnKircA:9 a=DVKqRkKJf1IA:10 a=4hKcRJezAkuvdJugowca:22 cc=ntf awl=host:13130
X-Proofpoint-GUID: DkDjywzHv_SKz7K69FhW1nwrBKLyAYCg
X-Proofpoint-ORIG-GUID: DkDjywzHv_SKz7K69FhW1nwrBKLyAYCg


Justin,

> Update lpfc to revision 14.4.0.9

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
