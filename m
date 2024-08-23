Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFA91CD00
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 01:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724375563; cv=fail; b=ewq/9evlpMLZh//tdlgavvFbDifGp1BU7zT3pJ+fgmhQqMlbd67WYw9jH/yymrWfQRGr/KnJPU/Yp4fENuIG604k+skBboEDO+EIugEZbjUoR7w+vFPweRfazZzB0NB6btgEQEzCfNke2GawyxuQg6E6vd7vancOYx/oMfUPxxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724375563; c=relaxed/simple;
	bh=E7u4UF7G78xXQml2wjyPz6ftaGiL7pEiMYYmRJkGDMo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W4Wck5DWj2jLhkU5JC2DhoRMHSUPg4KUdsV8da+XkC0bHns69Fk3hfLhZggUkwesASMZBeLpJhCaY4Gtp+hmPToAz/YKndw7ZgyCK7fO+Tdd+/uJQk3uhY6eYj5R9EupK50AXVQiPR+YKvibUyp47EmubXqLuK0UiPsWQ9AoW08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ow67zCgM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jlGSsNd1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ow67zCgM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jlGSsNd1"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0Bk1o003193;
	Fri, 23 Aug 2024 01:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=YkzxYVAOPySmEO
	y0jNvkthT0CIQ1ogDHSHllp+d9vPs=; b=ow67zCgMuZ+DbJtCIkixfxoUnJW3ci
	zFU/Nco1Ad+ZRhO/mEMhFOQWbFALiklG84dpNGMLreZZ3uuIBmGvh9vmQ7Sii23Q
	TmTBOOfO890UYDwAC/MC5H6R5Aac81PqtKUBrgFFjU8efhh8TE6T+A09QaYqtXKR
	Z5uAqrIZF/qLMpB8YceDuYKKSUkm+s9M3ucoJNqdx9rqC/snEwk4gAelgtaOmY66
	p8MniQ2vKp72PqyaQ7mpzDS9GSUqrkOeKAqtVEY7iFKGzS548V0Sprn8eBt7ZUDS
	JBXGiQffUX47tlGIOXh/2U+hiLl35MJGdGesVPowwO9X0P+c/sr3xINg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m4v3b1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:12:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0YCKH012154;
	Fri, 23 Aug 2024 01:12:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 416g0e8uk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AaTDnG8idFY4wUx787U4sXHf8hmcuVd3JfuLmRGbZWh+EIx3B7E/5Quar1pZIQr59cK0NIvHC9v9H6lQhbEtHUu3SCl8gtA3Gn8K+O1viW/capbBil1nvBUazG4LtbOIpQmk86VYzMXcqe+u1yXVbMr6CJkehwDIDHKZ1y+ZCD6+k/s34l/enDq/UhDhuY3BVviiFHkV51vUDAixvuCXgiq5z+wsLXJabfxyLkMOaoK1I4/N7Uq9FPQKnvB/+WmFKTCyYngfHc+f9w6JtEqZQ3ifwgCT2TMRR2AaR84t21YBK9yZQLgTf2pdJ1hMCZGMjwKqUgcIj+v9mhFN9aTVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkzxYVAOPySmEOy0jNvkthT0CIQ1ogDHSHllp+d9vPs=;
 b=VVTm+xB2eYdobhOhOSDS2iTxuOt8dkH6OattlZt5S0SwOuCTTzklNvZPuTeOambPn4cwVhGnA/kAPUlkfqIzrIbawl+4psGSTrbUjILxTkcg+vWHyYCUEad36oiUN1hxzkaCeBjA5cevtkjWDZ2vpMjWu347wNlp3XGin3LuEd7GFpW9YrFdJjWwhXRuo8EnBvqUfAL0jiYbZqdAAX0xejfCAZM3Z+9rpGUelEQi7V5+tStC5kClnbTkfhGVlZsSa3Qj3Oy1vzW9Lx/fETIajF6gvibZdYLZ1D2hf5DsHR3kgUW+CTIutCrAWvEMCQn6sBL5QjtAxr02PlMue0ev5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkzxYVAOPySmEOy0jNvkthT0CIQ1ogDHSHllp+d9vPs=;
 b=jlGSsNd1fySMMbm4PIrehzpPI7anwZjeZ8nXH+D/hdwObVBfLUzMDGo5KNHXrftaG89+KUt41Ejzvb3GqPMq/cO5inQzrqVMfglVejrONtRAkC9s1/qHZnyOhKxEqgO+6IEMBsN0E9QKonew3X/QA8RUkA3X8B/pcpijlOPipjY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7353.namprd10.prod.outlook.com (2603:10b6:610:12c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Fri, 23 Aug
 2024 01:12:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 01:12:31 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, chandrakanth.patil@broadcom.com,
        sathya.prakash@broadcom.com, jjurca@redhat.com,
        sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com
Subject: Re: [PATCH] mpi3mr: a perfomance fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240803150433.17733-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Sat, 3 Aug 2024 17:04:33 +0200")
Organization: Oracle Corporation
Message-ID: <yq1o75kkpp9.fsf@ca-mkp.ca.oracle.com>
References: <20240803150433.17733-1-thenzl@redhat.com>
Date: Thu, 22 Aug 2024 21:12:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0058.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7353:EE_
X-MS-Office365-Filtering-Correlation-Id: e11de51b-143b-4573-015c-08dcc310a9ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8btPqi4WAlIgrGgxS4pZz9/STVq/tlGYcofYrO7E7Gfv6kL4teCKgjf7eBkW?=
 =?us-ascii?Q?G7lqaVjhqr6RUpJuUfcvxIbwafj1fxTlMdPYScVYHNXH86rcH37wBMbdSi4/?=
 =?us-ascii?Q?tdDk7wS5DcrR+mhoJueh8nHqRsGuoKT4kDDpUYZyuMv+KjEchyqwHP3ZwIG1?=
 =?us-ascii?Q?Kw0+3jBN8LSWEX+tSj5Um+TYrianTySmxwyD4cB7osCBr47QMnJx9KeXleBp?=
 =?us-ascii?Q?r9ua8uTv4o5jfi36qHFcBtcg7b5DDppnYnAhGFDHoZRTcwNsWrNAR4/yvY1M?=
 =?us-ascii?Q?Aj4yqMtuwtvxAtgQPwiPGoYk+tKupH6uSMrdiXnExh8zBimVngKEhkMrTlth?=
 =?us-ascii?Q?6cL3+2bEYHKbIPUcIBCCeTFkI/V4V2oec7NAHhpicyHIu0chUmiJy2IuAmzX?=
 =?us-ascii?Q?3bljY1OgebzRFJ5pkT4U8pkJUERWf8Agvkwoag/RfLaD+dOzE8WibEa6yyoh?=
 =?us-ascii?Q?ueWRZZ6LKMDrpT9tiOQ93T19zNdQUqemu/CxYmMNC0FFfvxdicnljx/v0s4/?=
 =?us-ascii?Q?zrqV35aA5ceezPZHYvs84olIWiBpUqBHrYHEEyzi1DnVWzTsfcfBgtGYZ4AH?=
 =?us-ascii?Q?uOJxQp9iiL1C+2qTlPq4Juk8h2T5gdSBvpQC+YFZxOtZKsypkkFxXAvyX28C?=
 =?us-ascii?Q?TpvbAwUIPAwetVkZ4SRrfcWHbZqqYxbharsNLSPtBCe9Z2cFT7CRKEkmxgUo?=
 =?us-ascii?Q?m0Vqz+5Lwyo4vpyBuj+plLp8L5BsJ9nb121Knv4zsEbLR21ZFKJm7jlBKuMJ?=
 =?us-ascii?Q?wOdQThQShOLWpnjE6427auLZyiTd7dRClqLc0L64jKBLswNqs+YvnCozB5mK?=
 =?us-ascii?Q?BT0GNJs2hZ6N2/nurU38OdB1EyOTAov+/eCVsBdCJHt+PRLywxfjtyQBYKkk?=
 =?us-ascii?Q?6kI6WeJEyPW34Z1c8UBEUImo2tphiJ6fvbmjlYxn1fonYwxhJFEWqTsWthmP?=
 =?us-ascii?Q?pZDYd93RRWpAwV6/Y6vmbgAsS+48D4bI271/txKF7ojRWtO9LTPQwmtnetzY?=
 =?us-ascii?Q?+MPPtiOZYvEb3dZXgGIrolMZ9qUDhyAagwPKQetPn4T/aJIFYgGrJV/aYHkf?=
 =?us-ascii?Q?i1z7M14/Qj3bzzgktkrHuv7U9+OXYJmormSV3fUla25rGkmd+P4l+nNQZAVO?=
 =?us-ascii?Q?4hY6sLpkFz1YAQ127y1e8P0ehLd/gS4luO73f3R0zfzA3/F7RBk4DcrkFuXN?=
 =?us-ascii?Q?SJWW4t4dmtqVMgTDp95jyl4XsfBg7ur2sdOtNINH0WbokYV+9sT2Qgma3Sce?=
 =?us-ascii?Q?Fxdp8wskBjdOT0dvVwQ748wZyd8QM2S7kFX7rjOmkT0PkFPvI287JwJJ17hg?=
 =?us-ascii?Q?ct12/ziqhrG2gK/XoFPL1R+sfUNsVd6GxOTcRNQTm7iEWA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a3Nv7lG0+/rkYwe0r8MaA0XxOG6BnKIPMFJ7mBTQ6ivNePA4IwOuIW40T9up?=
 =?us-ascii?Q?OzCpdbmaQlF8AzcO4iP02gTWF4XGB68+IsaGxA6kEnZvDEgq/4MI/qOzMcit?=
 =?us-ascii?Q?DlmF0wNp4G95SUsAFq3lKmp7L10yl+zBvO0/7dyC2ZiYqiOKSs9S/ZfjVj73?=
 =?us-ascii?Q?Mx+O8hVc8SRfeoYSIgp3YE6BOMeHCHzJeQRw9mTpyCLHxbHKwUJCl/IGn2Ul?=
 =?us-ascii?Q?F1YKX7uXV4/HDCmVPbJvw5Tm5K042VZc/obQ3ZBL5L/W+ninQleTRRyYESzu?=
 =?us-ascii?Q?cKLo1bdRyCLA0ehHkTMdPl1yLGvAXK6wI3cSV6iJZn+K7DhCI/PWfBCqgV/O?=
 =?us-ascii?Q?10EGYx3td5sRkYnziBN1R/Oa+GP8YyZcr6lC3N7qI/EXBc7T978ZI00ftGXJ?=
 =?us-ascii?Q?ftlfdrB31TaAAuFY744igWHHnbjFTdbiQO+JzIAvh40QszIjJlEWpnuAs9HS?=
 =?us-ascii?Q?5Ceb5m5/GYJ/sJkC1odF25NjbHFAaiDsAfqMsIwq1SvV9XOoCil6k1PHP9yy?=
 =?us-ascii?Q?0UPZvPS7evE6l8KnQZYiNfC72qAPAFYhKXWr8XelYekVV4rjqsAlnoxQ7fqv?=
 =?us-ascii?Q?qOkSVrHw5SvgDQlaJw/lJgJ5zu6o2zuiQnJSsfKEFEzC5RxQ5whJsjlSEVtf?=
 =?us-ascii?Q?u564uNxvGDLoFTLVFD/69jO4VuMPPd259yH3I0NaprryWYVpdRBNaoSf0A7p?=
 =?us-ascii?Q?/e5iScfyAp4JQbseZWEoMr3JvmGG7UhWbuO+I3+zsc4l69XIY5RujCj4+4vr?=
 =?us-ascii?Q?W0g3idgMBnvCuGQpc2eedwgJ69glN3oZF5Id/voX1QZhbJFoQ0L41n/25vFk?=
 =?us-ascii?Q?sDEuT+IiMBSLxHN4ksGxoH460m60SQhYJVlD5Ujz8bZO09nHL+yilWAhkO9s?=
 =?us-ascii?Q?aiYky/ouS09ew+Sb1GWGVVi0iXAs9d3vxIDePd+Tqw/XF+3e1uw5MPpSiLbD?=
 =?us-ascii?Q?RKwHq73h7SS/aKgrKcHwiQk0CD1LXZ8JTT741sd/va2dWuipbbvJa6aun7j5?=
 =?us-ascii?Q?Wdz95kG3jnK1t+GMlmTh2s0jy/r4j/+gQqfXhE6XeQ0LME99n4wApPFN3c5O?=
 =?us-ascii?Q?a2P2ra9bYSVrcetS3azo+65ojansnfKiCLyFxSOZmIcKqj/Lx7MsyWiu6NVV?=
 =?us-ascii?Q?D2j5tHLD5hSYtIJSx2gzNo2JFRtDxvinSLS5vrw3eh5dcR9sE1ch40ybxYJI?=
 =?us-ascii?Q?CaOHIKB5LFIBkHHMUgDsZdQq0atBPDNAGL85b40PldVfkV2RzutBK32T59kD?=
 =?us-ascii?Q?bMlpbQBW0X5Ypld5dUGzGtgRFQkbX1f6xOzFhEzRrNYVBwUywRTnT/hIWNw+?=
 =?us-ascii?Q?6+2PzB/NU2mgysBvJZOQTXMlkhSWOJUoAxijKyZqFuE23C3goHgAQ2UG+FDj?=
 =?us-ascii?Q?Y2FIJRDtubTFOq5lvnR/qb/jCZATMlsi6683KT5cgJrU673FjKKxfCGapTed?=
 =?us-ascii?Q?Ico6zp0tO7ApRd4GMoJEUW8qpRLsxYlJ3j1xeyxvrDc/eaumnrfmsR/wHdhg?=
 =?us-ascii?Q?yLt6zkYbvwkDWsUFpGEEfbyfqKmXJwByRgu1L9B2yPSPMA6jpmov5P8QEVWT?=
 =?us-ascii?Q?stsBNb6wtLIEBiPXc/3sUOGMd3GLKgxQ4q79o/Wu2meUbG9mxvZFwXoofLu6?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bfcggiGKDCU9BrFhw8SJwNjjGy0NHC3vsV/32p23FMSXd/1VN9HlQ/BAAahcK+BEhHEA9QVVw78ocHx7ThBToS39NKSEWSzCqPXuqBojzxhz/L0rN0XtFvJz4SrH8tcp4jKgk4HZ45y7+57ec0MuLuQNXQMIOwKM2l/KzZxe8MWh00YD73cVg3n1m2liG0kxpTOYG5qc2VAf1dd68HRM9jJ4IzPOWy4hk92EyZJVS36ZeNInd1TDkbKh6cmEA35WbXPyrZsfBSneqc3bgdd/gzPctemI3RwuFjl7s3/qRqkDwy/ioDkA7/1hZnxiXP8IIx8oCWDADrlNh8Pq0MVX0NKX4OmeddR3qtF4xvum5ihYEeMygg+fBT/hDvzPf/El6uO0BHAG/WdiM2wK73FpVFxSPo7xSuaLcXRDlomYJtEBApmZVASSMPoSimsTB89c2/Iu8zLTf/KB+DylB7aPg3i/JFhY0J9u5gIBvGtiHVSlepls35FhcSDv8oocfaNKZs4lje5gSZCMzsOsmu6FbGBKbcy+vrIJ23PYZ9WBWRvfKkUEJ895pl6vHpMfsRvjDow1qNQYPavqGp+i3MBz963YwlNtB+57zLVZiOc3WZ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11de51b-143b-4573-015c-08dcc310a9ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 01:12:31.8847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBHHCbC992VA4I0jNLHkuH6X+aX+qsS7SuF1Of18iF8WCKraBPhfd8L4eFOFK01Utq2npEaACUxJSUo8n9NSW6WIFsnY0f0KOpUSihacTNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7353
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_17,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=958 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230006
X-Proofpoint-ORIG-GUID: r6qwJeLjLvl_dhX_JoGIoiULMazBuj1m
X-Proofpoint-GUID: r6qwJeLjLvl_dhX_JoGIoiULMazBuj1m


> Patch 0c52310f2600 ("hrtimer: Ignore slack time for RT tasks in
> schedule_hrtimeout_range()") effectivelly shortens a sleep in a
> polling function in the driver. That is causing a perfomance
> regression as the new value of just 2us is too low. In certain test
> the perf drop is ~30%. Fix this by adjusting the sleep to 20us (close
> to the previous value).

Broadcom: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
