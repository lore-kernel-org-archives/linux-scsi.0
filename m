Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBFE1B7FD
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jul 2024 02:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721098460; cv=fail; b=qS9wBeOXBM4/93MR3R7eeovF3cFVADeo6baUgMkZRTwam6OMFuhPciYl7DbdmbCMKiE8tIWeXimcau+HOXCrQY5XfoN5xQlfMmGB6cGa5/Zi63lmgpdigBvZvofnoNssq+R4O2mK9t+T+ZuQ6nMXzZalX1jLi9+JtKcWIjZ/omc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721098460; c=relaxed/simple;
	bh=qiSQRn7NLhul8mjW9p3O7GiKzRnnv1c0sXBhUBdNSGc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Mp2OMex0TkZiXAl3OkxfzWFDWaaK+Uwfa7++d+QCmMpnazOMDjNb7mnHAMlGYthXjc4blegK/gNvkyAFR7jf2txLirJDxPjxuUU4Yp4mHqVUH6TXvMBAucTdJxzFN+qmnvE4Gjsc12y23e78qkDErBVSiS2vz2YcXMroKwI/1gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XT1TNsSv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CMZhwu78; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XT1TNsSv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CMZhwu78"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FLHcdJ020580;
	Tue, 16 Jul 2024 02:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=KK3MEuiD/pdShu
	jfVrP7fEpMvn1iRq0BFVaMESF8khQ=; b=XT1TNsSv+2mCv6JJg7nQnZh/kW1B6P
	bPe6DVvuGA1APiA5TcOwidEuxKfeoAe4Cany/IT7esGzRcm6VKBniT2++383oVuu
	H091nDQ5+D2tM/fhE8ZMDK3mhpfsx6CSvucNdbqC2PkGkBu0Q6S4/s4/QR3ZB5id
	c5ke5arIQn4yTbrHCEnpqGg2OoYPdkjaOUH61KAVQ7VMFocD/hzBKP4HagbFG2tc
	NjzQgk/ILH6BLCMdzqEFKr+hn2cWmrNjCT4AJvRxPVocm9xHeHjTQUyoBw0rDQp+
	0RWWlZePTxI2u9XDhHAXbBz9r7VIWSCKEiNLQ7ENtvOgUyAWVOMrMTaA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bhf9cbsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:53:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G21ieL005854;
	Tue, 16 Jul 2024 02:53:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40bg18p9p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:53:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtCl1WycBCDqXUwgUXuZh35D18YJX3B6+6zxznc2nyy/Jr6NQ67q5rHeQpw9zf/YTQSCjBA9pkpiSr7GnICviXcpP0VkT1y6Jbbh0t4ejuJRGIshn7x//jNvTkWIwAf0hMQ5wYN0ef2StpR6fXKTZfPbeLigeog3Nk9mHoSlE3tSz3PyPehUEyzpqAm56YnCnW4wumi2KxY920DImJ7MXU5eD9+o+un624XHlABfbNE639Mtnv9GRPQiNxqyZcHhSmmIhotInKc2iXs4RaB4co6XlMREYsmOXP8gvLhSCpMBzk5FeixSc2/6Xt/780N5b96Pwe3oUOmioM3VmV/xZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KK3MEuiD/pdShujfVrP7fEpMvn1iRq0BFVaMESF8khQ=;
 b=qUMsFoVbRxoFFcDY4qLpOR2//ZsPW0nO1kfDhrrcXzxQnVPfhvyi3ude9+p4NdmqNxc/GH0+f7OEbxDB186ZHRo9sT+pSERqeKwgKAGqpz7PhKc3xuAFkGCLgYME0h5R9vQxL8I9rHxtX+t+FQliGBrggb2ClRHEdP3paIs3eFhhi7tpuRG4V7aDMewa/dhf9FfeF38aT16cn7eEOxqzMo1rjjNtBtgUBLjK/LkVeZkFSfg2vpfUFiFRVyG32bvNv635sSpiPFnOJa1WsGOvdhNvFeY/QlPRt2DmkOo+iZl91qImsiwmfPWgw5f0hpSJUlD7T+Zu1iV9YeNYd7/Ytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KK3MEuiD/pdShujfVrP7fEpMvn1iRq0BFVaMESF8khQ=;
 b=CMZhwu78pPu/uyDnPh89NfF634jvWL4PzRMdiLs4rlBwVzqmm6IdM1ZdS8IKUOeXDbGONV2VztPkTr0GarjVg2mJsk59tccrm8/WYTICF5uXjlOiHZpOM9JPD6PgtKXR0YYAj5Ht6sAPYU4ILU+GVRbXjmQgrtXIEDVk3Gyuw6I=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB7866.namprd10.prod.outlook.com (2603:10b6:408:1bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 02:53:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:53:43 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: Re: [PATCH v1] ufs: core: bypass quick recovery if need force reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240712094506.11284-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 12 Jul 2024 17:45:06 +0800")
Organization: Oracle Corporation
Message-ID: <yq1v816jbdf.fsf@ca-mkp.ca.oracle.com>
References: <20240712094506.11284-1-peter.wang@mediatek.com>
Date: Mon, 15 Jul 2024 22:53:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: b87619e1-6046-419d-27be-08dca54280e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?ysxiDSYjCZ9GZOtgVTKS1Fofgr8atlGbfaIhT2BaMt5ta8LRg4HEq/z+wHn3?=
 =?us-ascii?Q?IMDIY35bg/FBWCDAeljX2A69/q5GI6O1n20e4yxj/en0jz2ggdo30wCyUSeB?=
 =?us-ascii?Q?eiv7fN03PQER66iFFxaNzSOUxI6fDwbqwbUNqLj9+2QeR5wmpZ6jvrR1IfGl?=
 =?us-ascii?Q?mEf0MKehrdaINegS9GaHEHQ33cG3ZUEZz2U4rufigwoxWN/qNM9xhyXlUibL?=
 =?us-ascii?Q?CYiZQfng5CWr/LHzK/UgCG4fFq8ftzoxGD6hvSVCx1HGwco8uELCLG+QDm55?=
 =?us-ascii?Q?LAN21UmdxmE35mRaSDlaZz2utKy0Z4cczbdI9JME9iFRVbNfv5b9g3AjUM36?=
 =?us-ascii?Q?EUymMEKFja2qzGoaFuF9pMuwBPjV+WgXgm3451nJ/3KvIytuVOHWkKzFwcOK?=
 =?us-ascii?Q?2qTKaIBjv7tWMX0sltoadefTd46iLFoFT0Zuo3QlOumlTSgdjIVYFDtBaLIJ?=
 =?us-ascii?Q?j7DkPv7boxD6PNM1bbTS5/GCVt4Ta9vmm+9SbE79WxpIHbSAnyqCGcjL3trG?=
 =?us-ascii?Q?rNy7PhYiKg4rEzXI6Iot1Yj5D/wAgXAz/4L/MhL3b0EJ3K5pgUfd/s/FoXhq?=
 =?us-ascii?Q?0x5i2IMm00NzSWBmd4cUcKFUDuFhl9+guM6K+Az4Rq4d34ebRKc2WphjDoWM?=
 =?us-ascii?Q?f3wJPZ/I5vWdIatJWLzkwMAtfJJYYGg3urTA9HH2zJRfbj8XXNNEtY8gmVtl?=
 =?us-ascii?Q?GTV00nc46bZch63xOT5cqyVyUG+9tn+BZRKUVgNw6vFMQy5YP2flRY4DSfLz?=
 =?us-ascii?Q?2tJEVjYxbVIH9H5mJMbji0XRPsJn6pMAq87hGgRqL43ONBrKatDuCskr5pcj?=
 =?us-ascii?Q?S26NQrUpKYoAXklBOQ9y6JXE/YCbaHwhPkLeZMQjIsC0yTB1bTy04yJ56tyY?=
 =?us-ascii?Q?sNktVnqgrvjq/bGmDSQoTrcB3dRTXVTc4IFAgvQovu45kotaNYkYxzg7+1TA?=
 =?us-ascii?Q?xJBHxVeA1hB6iw/fo/YC6sEBqOvP6gDrYcach9dFduede4m70zRYQ3o5YesH?=
 =?us-ascii?Q?GxFhbU/+ZtRHa5Vy2fqtqx2xOTi7Fsk01z85YqS5sNJJkQ8ZibY5pmy8+wPb?=
 =?us-ascii?Q?eP0olnOysLe2s5nLectq9PQWy4ooN2JYfN0kxeoSEkSl64SCWSeYtmQzmKi/?=
 =?us-ascii?Q?LOWQqQN/sWjqSJx7qVnfcLObRxSJh9E8KzTSR+Q9PIQzj+r6F84ygXvQXtwC?=
 =?us-ascii?Q?a19X0qn5PWmxFJXH3SeDtYheXVH7FyEFuZ02YsYxmc14mlW7bvXYdxOfCCiP?=
 =?us-ascii?Q?vbGQtyPf93o/9TSlysPdXCmLMsZ+7LlU4AzKEXSycZlNVhmI5mkVQs69X80b?=
 =?us-ascii?Q?kZGNB0GBlfoGNYdsgZsd1T2ufjkxA94TArU7DWxs0oU/BQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?OBos5kX5L8smIUQkLCDDcyzhWHGlBkl6d1CT7NmSFbc852Is4s7BgQhU94Gq?=
 =?us-ascii?Q?vlO2XRe46CD+b8gpZyZYKWMSZfuwcShuI0LjYYXEf4ozyhyYEn7cqF2goqKD?=
 =?us-ascii?Q?wpyW0onrBTO7zTP2Q3H0BLEbkflOFhcbifSIYuXNj4xhvvqE1bfwuhSsl0RJ?=
 =?us-ascii?Q?obpBOO/jdYzE5tuayrsoGhWiBwlL2DncyiE9xVKiX0WGeTMt3Vt7wVhtAl/I?=
 =?us-ascii?Q?oZqX3h3fIIRAvpaQnWOJ8jrt6eHAnBUCITKuDs5e04KhbWUpJ+Sbrl29OLJg?=
 =?us-ascii?Q?e63ixxmEddRiJBhAC3rBc3PxbnVGYeH174t2FR8PWKaOwoCTccT/bEFcrtbZ?=
 =?us-ascii?Q?ynYemos60TFfINIPtk5sQQphbrSblK47/mcB+K/c9XEoVO7ivm0vSvR9nx1Q?=
 =?us-ascii?Q?MUnIOKDpzmEwz3zqm1LM5+oTWuMJ4xG/G8ht//Bn/LRh5XEiMtXYapagkCaf?=
 =?us-ascii?Q?M3rDsAjkn+Cz58thI4ICUjiYOaa2K9rNrZfe6VlNTB7zOQ0m6kAtuMTzxHhz?=
 =?us-ascii?Q?LNMlsfqU7cBvZzYimZzex4LCA1K/7TqInGGwyGmzhwgfaV8/NFt0q9hacgyO?=
 =?us-ascii?Q?ZhM06GfvxKsdVd8n7vd21b79k1EZB92e0d2ICAzmD/YeYQ9vBL3rJMNfv5XA?=
 =?us-ascii?Q?vA+rxVuXZ7Q9vh2SV3mkYtC0WYLqAlkIEGupgS8g+sUyCYegajrYD6NnGM3S?=
 =?us-ascii?Q?IGAoBQrXJg0QfLhvL0zgy9BkRv8cr6C4VTaSMURjg964A5WQ/Jp4s4q8hllN?=
 =?us-ascii?Q?fdZGU6NF2DOtFr/4KOAyGL/ho1JLlOHd4QYDPLGRU/aLAExzUP80BHGfNCV3?=
 =?us-ascii?Q?8uZgWXoj8+c1H7M3dnaQVbQ0gp1/ZLylpHqcHktdINnU4GHrVwl0iM192E3w?=
 =?us-ascii?Q?d7H4GGlbP18vtSkMKITtcqRKJcKZy0Jlnc1F5CWD9fAeFyCeeVmQJxf9Gc67?=
 =?us-ascii?Q?c9txHIbUkCHdTrXGNsITK2wUWoSnPoDQgn64O5Ho4ySGWoctFCtM4q+w8vSI?=
 =?us-ascii?Q?ofaekgZIcdOnhYjZgS46DEXUftQXbYySemzKE7TQSFPkImO5wuvE6tOiP0mR?=
 =?us-ascii?Q?X+6NOCBmBiaN9ZIkFQbIhT7cU6l1hqvj+896zz5X9JRdMGT3UaR/MovWzNBF?=
 =?us-ascii?Q?meA7XYmUMm+tZTHhfK5atnKrrbx7yyJUS0AXYXGMGnq6Vs+mZjLodgDeP5vF?=
 =?us-ascii?Q?uvCD7DriabhqDdNKzmpVq/87JIcZy3BZDfYwLtUCwaJFjAkvtMY+1j9Zxx2k?=
 =?us-ascii?Q?0c0IkvWKvEsQCO5M2MhKVrf1Okru1jCQAcfi5uotRoFyI9rj1rgtoC1AaY5f?=
 =?us-ascii?Q?N6CsqrpkAoWCVN8LD5sTtdBULk47YQSYcTMmmc8ki29+FcrDWJAx4Kn2GCPd?=
 =?us-ascii?Q?G+Zd+6ZaNe7YvGxQFY2QFQcExI04l5svY4evouUoVtD4IY0d/PN+gjOlF7ZV?=
 =?us-ascii?Q?8u9jh9LQ1qP0BDTX7oC5ssZmZ30TMg6M0WkHwBVB4oyxD4tJPC5IW4aZHx2S?=
 =?us-ascii?Q?SzGBimO8Mhfo5YYzJw5zOraE95If4krNKtdMlIlvufanV7Y3MRleLr0kO/XS?=
 =?us-ascii?Q?zLmRy/hp+wyECdqeWKRpfwK21X/xsQ0lrzpUXsD8l5u3J6qHat+mC785bj6n?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	P+I5bKviN9WcNho/QsWktw2jEbxteMXsV3xigl7JgEpBzj45gchRlIkcgAxOXzZCF/+pmEqduUlgsSqmemBwBhs+fzuuF9tIgbDe2unmsbePHK1cZ+tiqbuAKac3ZUq6QNrPFk/ejuhPk06BelN85biCjgr6ZP/PpMKtLf3v6Ky+PsSDntLpedFm7E3M4zPf59uNzqEpHtYZBIo6gm66z/bvgxofvdee69D91Qk9BBmEGsb/YdQyy+YoZzg2KZUumirL0UoxblCuTiJlrjKJ8JnhYIUTmsi/s5umXNGO/PVLeAFMDKf/iq2Ot7YdkzlBCCs3KIOx9Uo+GhYGoA6vFEqTSt1w2aPWnbGyRSjDBnwQkCsIJGVB3e8ZrZgopqrAJH1KiAQ+B6j6LG64A0qkK+CnNKF8bPMvmX7WOcSw13/PG+mzYp6J6mSwrhByM8UM7riqZnAtnkqmH6tLFLIoxmzm1L1K1UUaUc8XKAMYPpxFh62qJsUzRe5Wj4TOUR8IOnFBwG+id7P2z5aSgtBmYeMH4uhW6Tu7Ve5VMR+N7l9YQQ5R9P1i8sCeSal+opls4dEgsOE6mg6t5OKJFkpLUk0DWxUsuFTa+LS7wCtsTsM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87619e1-6046-419d-27be-08dca54280e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 02:53:42.9721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5fXS5Sg0h3QQrz0VFme2d0ibi1XlKKZJwWhbqGoWTaMxUggcA+y+BgQz+cj0rKBInbrdIvtBeX3pbht4F/fQ1uVfH/ykT9FF7Xe/MHjt+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7866
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=902 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160022
X-Proofpoint-ORIG-GUID: y1ht8w7xCylXxo9LWAGyHBfhPbw7sMyK
X-Proofpoint-GUID: y1ht8w7xCylXxo9LWAGyHBfhPbw7sMyK


> If force_reset is true, bypass quick recovery. This will shorten error
> recovery time.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
