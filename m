Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9F153836;
	Tue, 29 Apr 2025 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745889627; cv=fail; b=HHtM0nWhOJbHQOdmYuKq2CRLQs5EJ80Sub3BryMAgpxnlouKM09pmJD85yDmG1SsiHq+OXhi4nYd+jJMq2GN4UuxCDGRHbsZmAOkwiObvxvgXP7O2F/kduMxihF4R9hxRc3CZ57t4iA3BLQ+jqG+neoRcRrGCFNS2uIAdBSIwOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745889627; c=relaxed/simple;
	bh=71gszcK9yhYg6elgsmltwCJartCijbpBq6l6T2vyX5c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eGKC6IvMiPjQQCyydgY7vLwp7N/bAkjnL42zoDjMcu5IcgagH2trQ6/9R3FqjWEltGot8m+NqAIYDUxha3ScBgbweB7ASK3EQ+K0LhuDiK1yTX6qBbQh1KSQ0nnMtuvkMG2mP4BF+fiJpIndA529IPi4cgeBers/Yfue21haxgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C/lXMstJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wILVmufU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C/lXMstJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wILVmufU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T17JaI015479;
	Tue, 29 Apr 2025 01:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=cAsXdxPLMmJ0aGMAuh
	T/v/ahVv9wYavSTwDSr1tvyQ8=; b=C/lXMstJ3DR5Qqgnk5PYiIOXZgWyTvSVvH
	P7Qzswn8V3jeIOaRTSuD9M8ZOTnlpkJvuvlvR5OfJKqRuA3gWXNICfsEf6QfPrd3
	QNvO9cQn4fcw7YQauA+d5H9EO2Xr7h0W+RAWLj78O3trOIsoaw+JP8xrM4S+OA5c
	X0VNjZWfhyHNw1s94t4oHvWXPuP74SG2Lyihttn66FOYoFyycO/v2aXAiBGNitih
	2l1ex+o0qFxsvQL4ZaF/rXJcl+N39XisHomtk5v7+9WH27ISd01A2yqeEIzJjz9n
	M7H+/44xENU6Zx32+t3X046+OPGCNIBWMPkJEcoWGQQ9UccqfmKg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amtpg0g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:19:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T09NAx011323;
	Tue, 29 Apr 2025 01:19:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2047.outbound.protection.outlook.com [104.47.70.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx9ppjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OmX7/+bXQ2m1avh3y6Ng6KtJLQV7FesVQrvv0s39HhafIRGj1mOozUxrj7jmthpI32MwgQrZzfzeYS6KY7MpfRw2q8z2YYTpIToIjR69uJ0BNvTzYmRMpO0K+d1zxrbgtEtvxXd0v+pxIy6/Mj3QR7NzZ/EJ4SZ5k9j6HmW+YCVFGaJWvkhp3zJduTR6PLzdBhEpY6lDsvL1IWvJr5+cgVwMTP3rU0VktWvoWhW+illSasHo9Sw0kSHDnpNfXjIuNh3eA0mTBJIQzT6INQaaK3VAVmRaSljKw3GigO/UhKLKUsfhEJ/AKTfSm51F5lFyGNnbnrd0dVEtGtzyOJrGvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAsXdxPLMmJ0aGMAuhT/v/ahVv9wYavSTwDSr1tvyQ8=;
 b=ZYgPxq5P3eKosZjGNH8zuUpHC5Vee2TCM8pg10qNE586JfpEG3M+OSU5YLR+fa4w4qsogrkdj0dFesJD0pV07vR+Za32YZkKP2JWaGe4CNtMr447FFcxKgfKiNAu0MDz2NAQrMbMBG7oQ+uMLECh1sCh5glByJ71QfOGB9GUmmHgit3qEWtpd7bya/ZAuabxJUTu5nmaFLhePwApshDP3EBjn+Ce1mlM71rLrLm9Y0dJLtajAEHMjk1ZAGXDbAeRB/HcXYt8ptw55lALd+n4ZMuft2DbzLD1KfRFLLvM1N8JfaE+bqRGDvsO83LJmmbQOwKQNDzar3LCAFbwhkc73w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAsXdxPLMmJ0aGMAuhT/v/ahVv9wYavSTwDSr1tvyQ8=;
 b=wILVmufUhgZ9pfYl9kRmMc4Pm+0DjAX90sazHFNfEgqGy7IyY9r2Z/wAbmEiI+PuiYFPLglhi4PkkN7yPA2vH9PgmNoBrqcmJ/dKU/873ZwjNWpOqr2+N97LkuSeF5pXN0CSVhu1mHbDvTw6rT+gU77YEG1KKKE4tm4/jagmldg=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 BN0PR10MB4997.namprd10.prod.outlook.com (2603:10b6:408:12b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Tue, 29 Apr
 2025 01:19:39 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:19:39 +0000
To: Huan Tang <tanghuan@vivo.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
        quic_nguyenb@quicinc.com, luhongfei@vivo.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, opensource.kernel@vivo.com
Subject: Re: [PATCH] ufs: core: fix WB resize use wrong offset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250423092917.1031-1-tanghuan@vivo.com> (Huan Tang's message of
	"Wed, 23 Apr 2025 17:29:17 +0800")
Organization: Oracle Corporation
Message-ID: <yq14iy74vdq.fsf@ca-mkp.ca.oracle.com>
References: <20250423092917.1031-1-tanghuan@vivo.com>
Date: Mon, 28 Apr 2025 21:19:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0017.prod.exchangelabs.com
 (2603:10b6:207:18::30) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|BN0PR10MB4997:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b18d94e-f1b5-46a4-d77e-08dd86bbe9a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?47dKrR1JshJpR1iFZsSjd1nk3xTXDxKcxChKT1NUHyDnrUPCvZ185jfdXLHn?=
 =?us-ascii?Q?8mhBG6qHN6wxIRjngJ9tFLGN7b569/fl4CWWvUrgIfmHwYTOsd1knj1qBlCH?=
 =?us-ascii?Q?MbHxHgzZCtTn56KOG3lgxo1LE1pcM+sX70PKTYTg+Iq7qXOiAmgDDt/pPiuC?=
 =?us-ascii?Q?aA9Y0GovCULaaOwYvb79+PTvChHGvIRrwSb9d8SR0KgDIqbTp8w3YOd4pb6v?=
 =?us-ascii?Q?A1CKDqQIQ3EfpV9MewEFG+AOes+WI96Wa0WrOcu/KSsPM2xWOqfU72cJ4JW9?=
 =?us-ascii?Q?j0fy3b7KglzECL31Fss2L5M2Bid+ysSVr89YyR7HAVEiWbwOT4uiYcb3+H9Y?=
 =?us-ascii?Q?5h1d/8ECgyZQYjsKgUqVAVvSoZgEgr0azmqRSbNpYKE72fG5nMHxc9m69wHW?=
 =?us-ascii?Q?WOMzeNiL6s3TzVznL+YMmdrvMHtdQRwx0DvHFaaLeTBWZyXfDiHc8qE7BRue?=
 =?us-ascii?Q?JIrTfUzpFMa9OZAXjPZFY65RVE67ZcHINGkL1lsP/ESyUrkoCBzoaqFtCqdl?=
 =?us-ascii?Q?tucQYiq8TFcOvEvnUnyIbXjWQCNXfayshgA539gDF6TpF2zlRnn0UtJwoJRP?=
 =?us-ascii?Q?ZQyQzQyeIkI52Lzcid3J6cJqAso++Q5UjJlED3FEPUfaXivkZfnfkG2gTYcc?=
 =?us-ascii?Q?tccitvp6obifpwffGHLkgZdb1FAthl3k1s1eSWwvk8Lm+yMrPKsn8weaz2R+?=
 =?us-ascii?Q?NWmE5dq5vcnw6vUxUtmIryHAiD2V7mpMpihn4XyleG/OIPTIZq0Km1roqGaa?=
 =?us-ascii?Q?zJ0o3PHNmIcuQLXX0jQBSqQ8zNEingJ+8zwQNL0AB17VKN6BpfWwrl0K1XiU?=
 =?us-ascii?Q?/24BBcbEFMPG9y+cpj/guBNvA59B0u5JUizyU8ka201LTx1em3/1Mcrn41oE?=
 =?us-ascii?Q?RVrFw82AYDcdzwya3KBuKfgiCRwXDmEKar4MdHF+RnfKS5GOpO2aSJ4izw00?=
 =?us-ascii?Q?5zy7S5dhkQ8QdzuD7BDGkqD1gP704DJyi61BsH+oRUqHuiMhhNlmcac53OhF?=
 =?us-ascii?Q?0+4eC0i/5FiYvXf6tno/MWXaf8Bc0JZxppNj/wk2xNah7ZfIMMkqCcd0Oooz?=
 =?us-ascii?Q?GDUA2h8Afne3vE1iYG/4MPpkHsV7K1xxrw0/cO8Tt3N8ZGwcEYIuq9kQsv57?=
 =?us-ascii?Q?msNn2qK3ohrgfmPi6p6Zl0ftnSshydtIKHg1L13woavCgSaySRO7XMv89kkI?=
 =?us-ascii?Q?blW9GMdnbDTovKiMZOUPucpId4kO6AsDE2uj3p6TJbXG0WfHPC/hlvd3ssSW?=
 =?us-ascii?Q?8hTjmBxzMo+zQcgYJ/E1fO/yuXPXOl05qVF1JfNw93pLm8KqFPetOUSLxmVY?=
 =?us-ascii?Q?RigtMzVAka3V3Ht/c8Lu4u+U5sCJ4BPGFgG2+N/7kjY0QuiBFrXBBOjuTlM7?=
 =?us-ascii?Q?uEmBSBjulaUXdamXVenq4jKjGet5HDena+GFVyEbn6UWXLQTtw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v5OKvQzpS9MjmTrYjOR/QbSnO2lT+fXLJ6gxxbWDm3BaBUmCFNuFCfBWTo8P?=
 =?us-ascii?Q?lfdhOvTRs8M1hmleh2vJgZ/RIQxAEHKQP/UVxCuK8y1nIEI6y+4H9xTLCdyn?=
 =?us-ascii?Q?ARS2o7k0LR7J+RlgN3R1/VUuIWf64jTPQ3OV9JD8PXZozWLtsFhH2D8394A9?=
 =?us-ascii?Q?ErE9k0SqNlhjoNCcGwgKSi2VDp9gXjqXl6xF/uMknaAcooWvtIUwrU/Qgpmo?=
 =?us-ascii?Q?AXlZbyf1KKcKa8FMtO515vLeWksX646Tqf3d6t+vthNDONZYEfmKtOyRJZvj?=
 =?us-ascii?Q?N9ewACrDKwWifFFVVVpEX1lX3CPeLzghXO5QlQiVgphxsI0MXv8ThsL2hsdn?=
 =?us-ascii?Q?sAw/Hf19F37bBBRRBHKEkGZscn5H4ZpriBWgv1hghXnHHRis+A/D4jMHRrsA?=
 =?us-ascii?Q?ptBHwvEIa3PQFUfI9FXC09OoY3EQBeopL5/lZVlAHmCIhhlh4smGndMukNLY?=
 =?us-ascii?Q?5eYyvHeZAa6AdiH3Z5KKApExpq01Yz9H19LHW6Hr2tRhdGAEtNof5Klul45g?=
 =?us-ascii?Q?3eqdnwRE3tVd5UlB9dIVcAPnmrCiYyX0tBBQGdvogtG9qzbDgxfzLERbffU7?=
 =?us-ascii?Q?42XL2htSk22FIFsR6ig+zwspFlOnegNSn0GOGiW1NL2kTh/pQW6CKubifqH3?=
 =?us-ascii?Q?NHox6fLaiKjKOgTxeYm94TKIUEZpBns4riSCYbcNX1AFq3xPmaTo0mbwGQwz?=
 =?us-ascii?Q?qoFfIOMi05+HxrwEbH9VV49FTmFMCbZJI1yM1x2FXS0Tr9l499mTWWyLubVM?=
 =?us-ascii?Q?Z1tkVtg9ZzU2tMRDtd0z4Tmq1Jx2lhIOYbWnaw0ZRhc+JIzi/0+Fel8UzfdK?=
 =?us-ascii?Q?0Ha5BAO4PssQ9oFmfJ1IScevcwzKGkaFyXxAv4SG4xCbmRcQhh5d/qp7tXum?=
 =?us-ascii?Q?/6xn4i7nH3AGQ6xJGQiagan3Z4sN92Lfc947gKmJls6moRYbahTdv/CF6wNI?=
 =?us-ascii?Q?xzco9neBd0ZD5pOk053K27Zr5v6xUN7Jb0/1ZrPb3PXXU93AewlilPgWmeEm?=
 =?us-ascii?Q?7SzvZt4K2VfthGuTaJr4q1oEQI0+kS7AIhmwb9GxCCMMkMdBvbixuKtB72rb?=
 =?us-ascii?Q?pGlCfCs+dQhjcoC7T+DJrNDJ2ax/vtVr9GABqLF3pRybtQEzNdRI2wp6MTry?=
 =?us-ascii?Q?Bbpynp7A05dHLYGbNJnk0nE0KXTSnZzKWD3mD33GMSyAWjczqQhaqEKDvblT?=
 =?us-ascii?Q?u2S2tF4CRQd2OwByPTE7F/oMX1GO4PtIaKAYdENQwVSJynbG2h8eZWD8ACrf?=
 =?us-ascii?Q?LdhUadR9jji27kb9QnfXpcUh/WQK+jNzibB6V9490wi77E891ZdsbEAos1DO?=
 =?us-ascii?Q?FglibqfV7uHResBXGeXFUZ3RG2sODQyDxRrcwDxAyUnQ3KENbdQ+KeLpXAXw?=
 =?us-ascii?Q?w5E5J8lesLl1mG6ifQMQaUKyOa8M5EoAsgMVqwHSl/o3UaUrTJX7Sxqdy4cd?=
 =?us-ascii?Q?m12M3cE4bXIiO6iV2lGVpmh535oVfp9sGI7aDo2FJN/KppBzjqS5uJa9tmeh?=
 =?us-ascii?Q?Ysiu9YU8JBjpImFU2zqmiQ/hL2LyN5ONXNv0+fD7cAQ4E6woEeV6JlGeRVMZ?=
 =?us-ascii?Q?nJRxe38kuBZD/kOuL7jsIA68wwLThsXhUEnWUWK8RQmBJJsvDSQlbAjzX0uZ?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	huD3xeFjmRaolJtsHbPCdazX0sWRPcVJ+wWNELFxXUiCy/Rx3A+Jpazakfy9+t2bKNTpt2ZmZoaBTwfhwkTQ4aEM1zj+ap4cbsFSmkWeYcUp4GrGixchfzqlXcR2QKD0QvHy8UTxVYnyn/+Bxl+xTcT1Pz1I2R1iyErG53RS5o3QoXS8WD95UhNx4DgnYCoMpZlUFXzu1MUuKG/yQzEIFXp9YTAm+MxxTljRv5hPCfuIn+XkJejrSg5B4zWkhQLNsBrn5PUrpP+oIYdA/jLYXEXVoT5kM1nl4HfbVAg36hhkhBHN+k2VHIhqg1X9NfFGLvuLJu2alMry9CFCMT7gFOoeBW2u9kW1V5JQVLksV2gwa5CHr9FCYoe4/oBgHyKNbJy1zpaLM+b4YRDFArGjqGUdZG90QNn6+kc1/92755Y54wlbBjp82f2vQTbf0KPjxm0gLOt/ZJ9Y510AJ9wELsoetaBD2Thm1tnvEvOIJ2Iree+YWFXpFkRQbF/BrTuvySFpHkLt5c65bcJ56V8kZo4bW5KrKbXxQYMzI5IZ1s3UIjay0JB+mUHK+v2I8OuB2L6a1kxqDzyv1HhAo1Dek0eyn3NX+DxpqKd90EtPmfY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b18d94e-f1b5-46a4-d77e-08dd86bbe9a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:19:39.4388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pD3Z2euLvvSlbY5QlWxyAn43elxcKFTVGNZmYQ/f94yumiGvlFsNIzqAwLRWMJWp0APrhQ4GmPMOedxeOXbT+SlHLcO1wjNh0YSH3uYriCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4997
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290008
X-Proofpoint-GUID: JEsOm2CwCFtVxkh_p46nfn7lB4xk9EO2
X-Proofpoint-ORIG-GUID: JEsOm2CwCFtVxkh_p46nfn7lB4xk9EO2
X-Authority-Analysis: v=2.4 cv=cK7gskeN c=1 sm=1 tr=0 ts=6810293c cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAwOCBTYWx0ZWRfX47rPKKySEOV4 Ia45pjqeLZ14q3lb2WTikhpgXqb3pota5hkm8sxdPUcbAUNjLU754Ndyr9BmS0hFHYw95TtBrzK bL5uFdOcaGNmtgYJ/cnLIpFLcBQDit/xmtfg2QT4FAxDP0+f72dbltu76Jy6s+Pfb7jXqSkPfDf
 VnfSwlDtxH0dYoLbhbUA9XLKx70AaS5sNTXj+EMyARmNxNvDPM5PIXkQcWl7JUcMNUlztKDBHE0 PYmKu+TOZA3hyT1499iMoNCYO7/b6OLW4UKjwTOHYTEcpJ+JjzpH8n9wW2cKntlTlq1af1VpsT8 1Vs+KfIitE8BMxqJoxnqFXXeynX+hHdWOfzxIjhSmuMFHXpiDMppkixqVY75H2aCIw2hNdKmbOH kLHzpN1K


Huan,

> 'Commit 500d4b742e0c ("scsi: ufs: core: Add WB buffer resize
> support")' incorrectly reads the value of offset
> "DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP" to determine whether WB resize
> is supported.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
