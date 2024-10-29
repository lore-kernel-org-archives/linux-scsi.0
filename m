Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2055.outbound.protection.outlook.com [40.107.255.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3C0149C4F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 03:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730171497; cv=fail; b=Jl4E6HdbxR0KV4hCMQInjPhKVgO+R99wA+MTnVaE17ecmWD5wDABualqdrW8Sg38Ti7lR3frLy9xKepRHMkmR8Tz+1iLoPDqMGzH3KaU+UFcficM95xdxjo2b93DPj4c887R/1bUxNlwNVtN0fV+EU8iqJBS9mQs0I58t9jE54Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730171497; c=relaxed/simple;
	bh=I+Z5mJ+h/clwi4CbeoCNguPCm191iLXpFAq/I48oePg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KKIxhS9qWDTVqSykNm4vHVkRlZp3rJxj34vOXj6ACrXAerra9KocaHQn86JRpE0rKBDOmbRwPZ2ygcywjoykfghrVCTEoindqP49TQKYkqbCMT3DbdFSPvsC3jLVIZUjfpfPXkLUVWTOOJp18q/H8EHlpLNssOXnT6JjgxJ9tl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=OnQZ8VDk; arc=fail smtp.client-ip=40.107.255.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="OnQZ8VDk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aANVMBcczzaCSR+407PW3c7sVupBiEeJGyys2w4i1xHsTWIBIwiDB6S7EsgRt1XW05Yd5tw8KVYA56PU8OtkX9gK2YGCbfSSZP9KXF4wcWDOimvKXQ4er5bQOwU+votX5k1OA4TMrlvDjaHkCfLbYwsOshieornTOqz5wq6PpVYQnRi6wqh6lJl11sEOLt/E3kHmxRKGsCs3c44uFwnPykiurJwbynz3mrpTzB0cfFjFYhjdMx4iuUfQVStVn7ofCOGv8Fa5564KYzV3uxtw+9+9dCaQ8j+bsnTCXQUTrBvMbk3qUmEgEIA5mQYjW9UP0kp3eLN91bZzVdT0E4WJWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+Z5mJ+h/clwi4CbeoCNguPCm191iLXpFAq/I48oePg=;
 b=c6CSnLrKLjyr81PLiHnOwW9kX+tqK7GflSpDlFT+/s4adSB8C0JJG0gNVbUIKAp6ZzzCZTXetKDFkPtDH9cZMmGApOChr2XRsjxeTWbRbzUdzFCnCWyOCpaU9JBBxTmgxZ03bzF6akikN6t1licMJltkFd7dmr1OQGIJxb2kU/pS3m8tBIWkWR25tDPCapIfdgZyYSR+HmEQABV/J/zcoshQDAvktcoTNJyCDaTcv/krYqhR6nk2qbsSg8kkqqbh0F7hCwyTHvRS9zBYY1zhrZih7ix3Ba1CGvVK4jMit1Ix8RUgfLAObl6sF7tJfbBcCZFPxPMgzxcD3nhCXw+rOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+Z5mJ+h/clwi4CbeoCNguPCm191iLXpFAq/I48oePg=;
 b=OnQZ8VDk2K1WXLFQxtcM3I/GIpPytM4k29+uon0yKY5T/T4xCB9ojZKH7DzPKAVEKzGbd5dO7IWgy4jqyZ04w6MT4/ajGE64Yta42MV9Q1iV/emLEcbgEkngb4v9Z+/L+BRaLpnLBhXLlsMvIGV2RZi7kREM7hDFsSA7RuOpbukMjWFEWx2zDELgL1YhTHpTvnKePWDVlyXoVSz9L1x+ICvu09aOOrxEelYag96ZB6FhCSZyu9yVCiI/VjIfrxLJdBBRAQFli+se7x11lvsNMCPQUmnvZeQlTIF3h/E8XCda7jx8NlzebwOiUzP86Foii3uQMSfN3emiTLiDss5KbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEYPR06MB5891.apcprd06.prod.outlook.com (2603:1096:101:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.12; Tue, 29 Oct
 2024 03:11:21 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8114.011; Tue, 29 Oct 2024
 03:11:21 +0000
From: Huan Tang <tanghuan@vivo.com>
To: beanhuo@micron.com,
	bvanassche@acm.org
Cc: cang@qti.qualcomm.com,
	huobean@gmail.com,
	linux-scsi@vger.kernel.org,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Date: Tue, 29 Oct 2024 11:11:14 +0800
Message-Id: <20241029031114.517-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <SA6PR08MB10163D9B8FE4BE9DF5A47D9E1DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
References: <SA6PR08MB10163D9B8FE4BE9DF5A47D9E1DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:196::15) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEYPR06MB5891:EE_
X-MS-Office365-Filtering-Correlation-Id: fc8c1010-3263-4711-0071-08dcf7c75d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t2oWwEM9Xj6/75T7pssKWhCFRvWHhsMVAZNPscPT0NWQAZpvLXxHx/u/tpG4?=
 =?us-ascii?Q?JAF9/g/a83xuJz3MgSqM2sbggplPPwBA7BeVXjPylxAVM4O051dnWXThfwdi?=
 =?us-ascii?Q?0/sDAs+ySJmQZp+WNm+apcOx1U5f2xR2a5U0lPdneQC1pqbuBXHiH+DPCu4H?=
 =?us-ascii?Q?KeItr/k12mqYMXwmQy+GlX2cfxyGEWIC5vfOuRJQ2uP6xs/Ss5oN2hF7Ac75?=
 =?us-ascii?Q?Z3tjUKu5BX7Xxd3PpR7OUjuB1SQJXjn3E93WNkdKYfh8zP4FiAfB42vS6alN?=
 =?us-ascii?Q?nDf6eLF8KDVMyOi3HqzNktmEsKPB273IljT50/Sgzwcal6rZ2kdpVlEiGRXi?=
 =?us-ascii?Q?yl2Tn/DcaSaQ+5c3fhfZi0W8d7m9KPKOdmS7VLpRecv7t+FSm4Kc0uyGADt2?=
 =?us-ascii?Q?LNOYdbvIgwGtEfUQUH3shre8lCJeFxK8y7hhHzbO07nc4+Qg4Lfc5VuJWhJr?=
 =?us-ascii?Q?pj5/y5e3fzV5lQvFgmgtt94so+FAe+LUmaUo7GvKH/M4huc4AUgO3YOjwpzt?=
 =?us-ascii?Q?DioLP3ZXol0xJ39HAtAokB33d61YObWyPBT+GRF3u8iCuJ6SIonky2QTe1I/?=
 =?us-ascii?Q?NyB3ID6bfun8/o38f5Y5U1Y0LTaC8vk0TKhQZ02z4BHvWpbLNhEeOY3ZuDGW?=
 =?us-ascii?Q?9F5Pj8VQ9jNHkN3BokkRqSxUEm9dZu3ITMsruehKs3EKeDXeoU1B4eOrOVXB?=
 =?us-ascii?Q?vGhJozTk6geT65dTG4le8SthtC+LPJXPl0F8f7zWbk+AZalB26sItn7tM3vr?=
 =?us-ascii?Q?0eiBFn+Cf36vVI3TEMb+JyFMm11OdKSDCaUB2NxByXnm5w31EsnJUS3d3lx5?=
 =?us-ascii?Q?39E8qaUUnwQvnfZswSQg022p2u2OjMt5/o8FYf+JZRZHmx60esPiwWBB4o09?=
 =?us-ascii?Q?pkAKJ0iuqUqU8DWfPp+SZY5IW8GzPNfTAuZ//22ZOHOaHXr9JDhVkyVdvFRm?=
 =?us-ascii?Q?+mIvm4zM2LRM4HD2lRpFVvT+RcKAlzGgsmNAjhGE/CNQK6ZdKD2tmjZqUyyR?=
 =?us-ascii?Q?kXEeF5QygI/XD7Up1OK/uAs86xQ5VKV7OHlQOobD3WISIGbEW0g3drhiW4VD?=
 =?us-ascii?Q?ggW9ZXrdMDlO9AIbnA6SAyQx/y4+KcVIpFKV26yVHmU9IAo37F1FX/NAUbzf?=
 =?us-ascii?Q?cghbIbQsG4PGVuOYEjqoFoSGtoo5ZVBQtc3I1OoTe37lgr1bn8KnFob277yi?=
 =?us-ascii?Q?UCsO1yGHS7Nz1cwUWaw5ukPZ6qZc6rGErF69ujQfW28SXRFRVbYBRT2rSErt?=
 =?us-ascii?Q?O7OQ4mmPOVQF3cD/aHi4gEYISDg4WkHsaasENsIa7hvN1Vowt0e3IvXyIofq?=
 =?us-ascii?Q?Tgtw0Dfi2/ULfuSdv3KAVO3iOT9UE8p3EjtmhLrnDDepad3CQPajZMOOV49t?=
 =?us-ascii?Q?xnxU34w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ecw9GkSABDNqMV+X63LXkNZVJiX33+zQ//cned4hWiLwAKOkYEBTtJxnWH+f?=
 =?us-ascii?Q?OXyeq2lo64kGxrR/gbus58PinL3GYbLT68cusP3UYi2r4uD+G+oit8nMcebx?=
 =?us-ascii?Q?0AG6pJ/CHyX23qZF6Odid3Zor/u89wyhkQjMxwlMkDcrz6vjwKZZo4VTp1Hj?=
 =?us-ascii?Q?zrgyVUz4ADQS2qtxErw3+wCYLR9F4e26aalwcPRte4osnTkBDQqalmf5UpnJ?=
 =?us-ascii?Q?/3pcsFTEL5LxGfprISqe0MlT1KXvWa9NmILiK3RyvArOAcbHKfuyh64BsMD2?=
 =?us-ascii?Q?V/gcEKukkJK9g2huVRNcTkD/ojrtrZJK+mI5MbCT/JVHcF7rVp19+lT44q7I?=
 =?us-ascii?Q?BNWCeYN6+7tZsgszBdm/Dr4bp9I8rukwwZRXVUO7CS6JpU6596Rsblm2mc6s?=
 =?us-ascii?Q?2nyn5gdtQ/GbyYc1CBQe1Arta+y1gOOPbF8Es9le9++Caj6Hwmcz8NNmDBAl?=
 =?us-ascii?Q?m43Te3gaaxIvFwT9dEooXTkJ7NDyym56/BOwo8jNSW4P/nTknCDuQQJV9u8S?=
 =?us-ascii?Q?CoqE9WPV8BzRtWEixIqAj+MH9n0e//pMSl4oZXz4men7ayU39jFGjBXevwje?=
 =?us-ascii?Q?igt3F4JeQeDnvTeIzQq15vOzgcLRwksA3/a8eifkqfb9u++tFDh9uB/z7b1z?=
 =?us-ascii?Q?jga2ejvFF4zazuZYRM387XhEoeHcznmiHPmvPt8FuEgxnb8XjCLEQamfg9tg?=
 =?us-ascii?Q?ak3lZQ7YRAMP/NBRGXlXp6lpniu//B8VsRJRnuE8FM4IpjxMR1kc795w61Mv?=
 =?us-ascii?Q?vu7By7N/kfVbWNvp7pvU5l46kcucRmwPKb5VZQzwIoyesFIAho9qvbVulUJj?=
 =?us-ascii?Q?YnhQKPuwwcF7ScBPNZFKmeo6KZEOxi11amwdEOx+kC5E4t6/e3/7dmPyNFsG?=
 =?us-ascii?Q?y1wVurj3p8d3iDer9HtMjYURXznegKCDVksZr3+Kf6q9KBW9e0WXnv+3IMUu?=
 =?us-ascii?Q?ZOzkEnEtxKYRCpbudYr4Mmt3mSKgRj8FCve0OeQk63Zy0Q8rJG8gWFPEq7/S?=
 =?us-ascii?Q?J/dk6S39cNPHPHtoQQa4MVQWywpbCRpjQsAZsNZXGBfxtyYuR0abHtLB3W8D?=
 =?us-ascii?Q?1/3pTKSW0z59e2B4IFMd3j9sNmJV97xR7f5kjyq4n63PDc+jeDbU9bHeL1vY?=
 =?us-ascii?Q?IZoeDlOd9eXxLPqP9OVD9ewty3zjEqInYgAeA5TTX5UVPk3Eei9/RZ6EvFIL?=
 =?us-ascii?Q?q6mIn8CY2ot44qMy6Zocav/jELCwiqCZ3gwtUhfc7SjwjzHN64dxMBwWRa2l?=
 =?us-ascii?Q?RLKQJIHGtQsHIIZk5qWL3waJkerGgLvOHezH645QPLn0ZcsO331kWYYmTC7D?=
 =?us-ascii?Q?UiPULLcRhUGm23r/hqbh17XWCEQjHGlM5hZQoxLJ5y5yDUE/AQsmaXKU9rLT?=
 =?us-ascii?Q?8AUs2pofeOP4tGrJ0622UYhh34U8BehI427z6zdzPmGcl9I9Snc98HnBLXCy?=
 =?us-ascii?Q?puNAuUIRRn8vWmNau645xOJQAjapHG2ulUrY/x9zLSKNotPPGeWLcd6CdsMC?=
 =?us-ascii?Q?vsj2iVLXmXak+i8mWSJFA5S/cCeaqcOGfaInpMW/nlC6+lSFpZmq13vHOGbG?=
 =?us-ascii?Q?i1RPgoplCqGH1+F4lsy+b9CY22EFAuvXCgdgSj9b?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8c1010-3263-4711-0071-08dcf7c75d1a
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 03:11:21.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxtZk25jlz7Qj8W6defeYZsfrV7qOy4DzJaoSDEc8MsseaqMk7wHiNJze6+2HloVuTiWarjfOQHx9h3DdIGNHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5891

> On 10/28/24 1:04 PM, Bean Huo wrote:=0D
> > Even though I don't think it's necessary to enable a Sysfs node entry=0D
> > for this configuration.=0D
> =0D
> Right, a motivation of why this functionality should be available in sysf=
s is=0D
> missing. An explanation should be added in the patch description.=0D
> =0D
> Thanks,=0D
> =0D
> Bart.=0D
=0D
Hi Bean & Bart,=0D
=0D
Motivation: Through the sysfs upper layer code, the WB resize function can =
be used in some scenarios, or related information can be obtained indirectl=
y to implement different strategies;=0D
What is your suggestion? sysfs? exception event? or?=0D
=0D
Thanks=0D
Huan=
