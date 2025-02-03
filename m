Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B873211292
	for <linux-scsi@vger.kernel.org>; Mon,  3 Feb 2025 22:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738623275; cv=fail; b=DhSgafin8qoOtqqrB0MNppLvSlbmT+L6Jli5iJuGyzpbeswIorOJg+71jdcLyjwLRLSmHCECEitPHDlFRU8/Jtp+ifEDLMBVotcaEHIzmk0nT2P1M3LU9/YXc/wb4XIvNWJqAKLRn8HVv8ZLTbJF8eAgDaV/N2OY2IL03TTh358=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738623275; c=relaxed/simple;
	bh=CqB9QJcS4GHQ/19tm1facmgEwch4cwolW3Fq8c1WM8o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sFbKoouy2RoRzJ/Oieqzv3Q7BvTz9KFO29AhDInEsUKENSxnKUWm6u/Up1z0qRMR2hxw5DDJxNXqfT+hH9Dcppt907cEF33bXxsEev/QxjI4kwnXBBh1qW9O3kx874qfTNryE+2CzQ2vlrwPmVSOyiDVqQlEYx+LcagtmmujkBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SpSSSC6G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n2jTgoie; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SpSSSC6G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n2jTgoie"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMrpc024957;
	Mon, 3 Feb 2025 22:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=QL7dEYkFsiUKZXa1Pr
	ox+iFkiPNQcBKMUcp8Ls1HZxw=; b=SpSSSC6GgTm4HhO9RytB1blnwlnKzTKEKk
	uOgXmme+jcD4ZxJQ13J/m+ytp5uj75Rsj6as1Y7j+VjwFagaUQ47h0NpdeOs6L78
	98DkoI9OretY3hssct8T5cL6SLwYP5qFOn8H5uJXaWP2l1Zw8ktq/BE4qk8CtiT0
	sgZr0G5cjQ4F7xMXJqK8z6c3CNor6qozXEZ6eHe1N3SKY4u1NjtBfUI/bS9EeE+T
	tO1+cNDRFY/VimGiF8tQnXTJxv/YbOVzHXyMVUFFTebkjAftb/qQRFDXZGg56klN
	vZhpW707hog++G/k+eMW82Sly9eg7pf58lpYwNIn5+lUSf3oTkzw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy83qnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:53:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513Lkx2F029864;
	Mon, 3 Feb 2025 22:53:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p28xp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:53:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mr4q7bNRw0EvzK0N5g8oknFX3K4uAu2neGc/LnIrsneh8qnzcHUyGIcwGRgZmSfM/e54ChURNM+L5CUBz3m7rhXu/1RWOp5vhdsUUUUu3aZt8iSipkT5FmCxuOhib6mP3vFKtgXcqNVLaqZxMkcLX1VUtcxUmlMezoy8ooRlgUVUf4gAgVnddFKfD2hB6B0ppV1RDqHP6Sd6mF76zmYTUilHDHo95JB8lp54CFl85kovP9VElZWVDrHpgYG9YVgB+glpQW+rQEh78bxwR+eLtpvBgMTTZf5QnNi4U6I5zRVKsjkIlOISnEBmelOE9HYRSjAM0smDs/U0qxndpRXx4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QL7dEYkFsiUKZXa1Prox+iFkiPNQcBKMUcp8Ls1HZxw=;
 b=GIuLWVL+IHNcof0TY10eI+TuNSi0n0xpT9CkIk+IDOnDULcmf7Xpnc3pNDvtA4kmwrO9RgBQRGxLNmIs1Q7XGj95fQ+qzH/U8udze4Dn5ZIxRv1lrHknKf8jP7f5Vq83uTQPsdUEDq2AFyDUuCueOt9gauMT0hHo1cVJkMAvM21xdnermlJBROB+NU79lNpqwYm9Lis2QnVEAAHM877CKhHUJt3ZTQy2TsQ/+WUQcId9x9al5fB3vDtNeUz0+v6oolIZMt3xk2YSe4h8/S5YJgS8LDtfL3JT3i6sx/J4TzQ9onQ5+BYHu/AVjTdgXto/F3kpMR2PCcc/WGppWYfINQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL7dEYkFsiUKZXa1Prox+iFkiPNQcBKMUcp8Ls1HZxw=;
 b=n2jTgoie2WrOpF1B0/Bd8U79UEP7IJDaakA6N3YK9obrQXqC2HIiQVtU4UTlx0OhtPomWR72YvDATdZmLm1e9tuIRDn9NL277OL2DJNX3/BQ94Sfd0sHW0DZdmQg9TnL1+KSBew0NpXswmb+3yV2ggEwpDNYMBeT+tQRe9FvtR4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6613.namprd10.prod.outlook.com (2603:10b6:806:2be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 22:53:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 22:53:03 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, jmeneghi@redhat.com,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        loberman@redhat.com
Subject: Re: [PATCH v3 0/4] scsi: st: scsi_error: More reset patches
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Mon, 20 Jan 2025 21:49:21
 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ldumhc8q.fsf@ca-mkp.ca.oracle.com>
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
Date: Mon, 03 Feb 2025 17:53:01 -0500
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:36e::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 25be2696-9fe3-49c9-7004-08dd44a583f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?saxYzFgFP2um9pyUQVuSJzXRS409/znhGe1DBWxGiG9B4WoTdjlRZTyUOPl/?=
 =?us-ascii?Q?T9GXxAq/37ZnbQC9GUlBXLHP967YgfItr5WOXr+z6khcY2LXr8K5zKIdqMXl?=
 =?us-ascii?Q?RQ4yKKJGrP6pGJMfXrF57kpWZxNTVAYnEHFdCCD/sBgaijhJ6DYK7X0bvNsp?=
 =?us-ascii?Q?zQPvWfE5hVh4mi6S72Lw26V9YoDGB6AJUdzRSpToWU8HInL7dK1OP1Z0qmj6?=
 =?us-ascii?Q?Vc3md9UekqSguuvQ4OHBiBV80wb4flRuDeE0vi0R/YrLTW9oEE6aLGap58zh?=
 =?us-ascii?Q?b4GKSLZDncvjmH19Oe71UfqTxY4jDd/uEDv6U5mRdCAQ9XjTy6kj/23bheWW?=
 =?us-ascii?Q?1nC8Zh5yyhQYR0KkfcNp2OpesZial8lB7FRpYBtTNSWMlX0DHEDdU6UpTKYV?=
 =?us-ascii?Q?vQBNTOt/WAoOZGM/1amvAzOF/HVV3XbibeUmMTJTurceKumDMuGLUwS16G7x?=
 =?us-ascii?Q?B/NxvpupIVxYlundcswHQz1HaGT/Q47SDBRAr3OdnfLh85Zfch2N22YOyy2g?=
 =?us-ascii?Q?e8xehimrC+N0AvzigNkeXxoxoHbEBkHS93eVEt5ovzjUwHDmuC+Tckja/7Du?=
 =?us-ascii?Q?4geqQKVqYKp72B8Ki+o8POkYG3LCfcn4tk56eaq6xskYewNAjyUnQVcA3p/l?=
 =?us-ascii?Q?3UojLHoU1dFuD2a7LlzFE9bAUGVPI9gh0VcPBq7S4opn6NMwMjgwhew686xK?=
 =?us-ascii?Q?tHUx56Uq/+FSyBnG6jF/XGkTiRlczfpA+5eODxQuRVI1kZlPss3zNam6PZv9?=
 =?us-ascii?Q?fqS6IgvGWZ26+8y8Hl4hSAe7NNtnxxgZSInqe0R6jdTOJPIzgg7cO4vsQsfQ?=
 =?us-ascii?Q?QYcN1DLBBJovgIKiHS1luyc/AXai0dKRKUYUnAe6/iv0O12/wadpNJy8Lzq/?=
 =?us-ascii?Q?wkPRaHcJNbEWurjlpSEi0Z1w7TjRH6so6ubIXtyYKH+K1ixVNWrPUjLuPlZe?=
 =?us-ascii?Q?YrVtk7SWbNJF4vKcpLBb7AoFYdY/hYPfNShuWNOyHIjittUGx4CboLMDpD2E?=
 =?us-ascii?Q?9pV6tZKXOWYOFID6NMtyQYymZVKUaeDTTpJrpW7EEvf2ngWnbawzec9ffR6p?=
 =?us-ascii?Q?3R0Jmzu5smY3hos9ojDrT2iMK2ViCJ7SbbmEkJtPDFHy/IU2JFVgfJY3VZ7F?=
 =?us-ascii?Q?U/utftZ0DdvGg74M1ylKUwu5AWnrrZRjiAgBdFCZqhwsfZeHWg3WVYMp35yJ?=
 =?us-ascii?Q?8QkBSn5LCpLQiildof7NKbu9Ft+M87e4s1TP07rPo8xI8iyLivQca2M4Cgh3?=
 =?us-ascii?Q?cNbIMDF95NVqfZT4kK9KbmzXEydbGXC5goiXtTDBsqvyGqN1pcjORnpsfWPz?=
 =?us-ascii?Q?6HoYExVAI1PsoAqzMrUXxZ6lkysNuCggvqdoOeOV3ymB9qjXuMb86m9RPWTd?=
 =?us-ascii?Q?ARDeLbQ5tBFVVVDt5VxUQTaNGHMD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UiFCIx99ud4eJysvVEinmUwQnCLoAqgKIgnYb1eRmVNLcs1QALnmu5DaYI0i?=
 =?us-ascii?Q?xKOLxcfr/itW2NL1QEVYxQM0JSaObtkPq3CPD1Q2MflQ4uLbTMLl9fH51VYw?=
 =?us-ascii?Q?WNPgvryn7M4bIqPEFR1AMKYaYnNSwaO25wBV4A3ipVbI45uEHAtvI0o5GStf?=
 =?us-ascii?Q?yXsBdXI1ohsGOtL2aNYvNflSOK5l+VfIJd2V6mPxMe3hp3bI9AILo/sS+vVP?=
 =?us-ascii?Q?uCUAlLp/eAu9bdvhoqiBMTxzP7+UPKo2MxpX6sIQDdVU/N5r9wYyQip3cZQ+?=
 =?us-ascii?Q?R82RYEp4oGU3YnvBtLLLXIYu80Zkos2nxMCzGgkm4LuXu4CUa7QbR3cpXDeO?=
 =?us-ascii?Q?NLo1KOewRj/PIlTjFO90u4AP+x3RvdFVVOJjsn3j+NGPOo0ydxOwbtaMODfb?=
 =?us-ascii?Q?WIWgNNC51AlTpboT9xroiIS1S3aMuhVyD7r0HPlLemtLDfk6tacAtsqdd1Pb?=
 =?us-ascii?Q?8okm/r4UzwtIQ8zr4WwhGR8IAGva1pIBjM+5LPxmThAGFnbanq7NuyU2IbWl?=
 =?us-ascii?Q?UFIogtiyP5biMj85HeI7mkXHltbUPoTo4g+BMlBKikQz3ATFs7HCUSjHLlgm?=
 =?us-ascii?Q?d3f7JVpdcLOs5eSQwiXz8ivYNtuPWHsyILoE/8kVgEVy0lw+EtnT0KRuJxE2?=
 =?us-ascii?Q?QmMQ2MAzEjCbrZNan3Nowvc7VXXmRYnPDZPpaJFaDPn7zOH7vseiQ8gzINPT?=
 =?us-ascii?Q?jeuJW7tfcQDFFFaQCakD+XuIxpnSZEYFxgHPPFolOM9pqgYLWc23rPuutoDS?=
 =?us-ascii?Q?MFK1R2oEXwhrRzkMLHDpeE8P7EXyqMccvJL/8LpJIxcXatu3UiZikFuKjU0+?=
 =?us-ascii?Q?6uBX4RmBmL0ibXxbGkPLfWnOW8SfwysJHOGKNScLz0ctBg8JDrnVMDd5o6Gt?=
 =?us-ascii?Q?6wQvahmCXnzhb4bFc1exSu0EYlu61rXOGFIHBYloDK6SJndA/TgD9obpooRV?=
 =?us-ascii?Q?Tl9lcnafImkBPbkISkEgW8YpfI3v1EuncL//tAU0DllmeMDpPWYxgtvSIHLO?=
 =?us-ascii?Q?algmBOhXNAxD2/jWCTB43brX/gFv+XyMdtfvRgVI/hVV5+eOjI3bYOvbGZQq?=
 =?us-ascii?Q?f2PuXhEl/lPa4eHSkXUbJW9Uot6R3qyANj+8bj6nZpXcyqkNM4gkRUIm2pa3?=
 =?us-ascii?Q?necQU+AVu0c4IreFGRujFk+gYLxRZ7bJUaiCTApb3T3UOQyV1wU74Nb/Mjp0?=
 =?us-ascii?Q?t7WtiwdX0Ko5F2QHSnn0maMrWsq9r6s8ssM8EtmsgClcpYgGetAiEgKdag0g?=
 =?us-ascii?Q?oeGLkF2idUNXumnFqNj1+BIM6SIAdyhudWZkI8n2sNR1hyjHtNR5Wmw6HoPv?=
 =?us-ascii?Q?5HAbw7gzUvOo4PPmovxUMJU/HFzvvcN/hi+llonEFSkoI5gGvxFKimnCfwEI?=
 =?us-ascii?Q?50EuhV6a5V2z4ZYnMB5YiEiruoXqfkGdfiyF9aCOKCr6ZgAdur3wxDI/EKUd?=
 =?us-ascii?Q?YQWphinmjdUX1336SToGThoJCtlAzl4gSyLSDsN+NCRYgh28TlTtklcFbO45?=
 =?us-ascii?Q?W7k63w8K7q2QH0yPUHD2gZhGQMP0uCLa9V3Kdw27qS9sEw6UgZAFIwsoZPpo?=
 =?us-ascii?Q?D7xLOXpjV/K+J7VGJkBZ/UX7H4VZ6OKRd4LsiuxPHrmAoXArSpI5Np/s0R4v?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zgp8qt8ATl114m3M2Ff0KqvjgevbvyK2hGMJRKLOcLRvE2oKygdeTzo5wrM537STX01Ljp8jfoQwRaXN0b9g3AmduRRnwQ5FQmEdhjUyF1E6aj3HvSkKFxWy2gyPKrbIL+QP7xreFMh3k7LTyQvuiU1ENjIN6Wq/bbx+OANKUxifsWUl8MVA2aVZJot+na/iebtA7+xYb+Wg/v6dVBZuIHWLvGlO4hAu833ar8DftrrgVi/bcFGj0m1tyWyTn/8ONYtTpvxMbSWVUK271P9K9MUUVtg1iG82OXQAyyqVLRng5ExdE6tAWJkDIFw/8wfWq5lJzzvryXJuKEMKOKhhBA4fYIrZOhpt+Yau1QGaU0JtK60LOPT0sZYDIlM44EFhEkHknAdLojLYWPezFe8461f2ylbJpGgXIrplqhWzwkAUbxBGYpCkOzWh+nnwiSmlRUrD+7gjrdxk7v+3oXzr/ePNzrqd0A5i+CnuSQ1fH2xnKAxgBurGGpPQ6zVJjOrvXCUyYXbWzxfhTnnXjsEhVEQff31cf+ICUPMEmiCKPKWCMsN5lAQWiJbm61dhZpPC/AwBq/DJellNbbEf7ri4IqS0UHG7+LezXwDPn0P41Tc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25be2696-9fe3-49c9-7004-08dd44a583f0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 22:53:03.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cp7w637xjjr/aXqzFTAxZpIb+yqMD3bRIWMmLxpWVxDa152t/n79KfdNM4CtFOj2AuY6j357Yn79ArHnVZcDwV727NBQsLGEVXpe6Bw0r0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_09,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=920
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030167
X-Proofpoint-GUID: I_GkD9HLI35i6IO0UOdpvTSKSZ_hMe6q
X-Proofpoint-ORIG-GUID: I_GkD9HLI35i6IO0UOdpvTSKSZ_hMe6q


Kai,

> The first patch re-applies after device reset some settings changed
> by the user (partition, density, block size).

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
