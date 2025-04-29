Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882E2193077
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 01:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890094; cv=fail; b=LKoxFKUwt/4l6mLpYPYBmnZ8KmOKYGaieFNLaSDaCcwfn7ICoeySmihxQcbNBn1qKalK2kQ5DnRBIKX/jxJPItGKggPdTUr7H2bKXKHJVa3p32rbILqwmCoyKg6aYMrtjCNWfWVDrAUn3f4J4OL1Bx7kqfmgdGs9+okB7Qt+EU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890094; c=relaxed/simple;
	bh=gNgVJjwse1z2Fu8OtuC91369iIiaPG1OC9EE34cwSv0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BTtnxNgtNunr7sg0B7HUgMQB5D/xhgqvtzQYZykYHD2V60AyvkEVbGO2bYejsG2JwKPEx98BC38J2JKKlJ6C+r378UeqP1AyudOr/yOu/NQkslcm7r79zumUtR5XKbejQgUgxpsDvjhChl0/yvQg0FCMy5Jv7neicZv2L554QFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eQ7sPpjD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CTk+BmgP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQ7sPpjD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CTk+BmgP"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T136ta027339;
	Tue, 29 Apr 2025 01:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=dfsZ/M7F3T0EI6VZ1g
	TLHM3i6IQ1TG4C/Y86rn7Vxsc=; b=eQ7sPpjD47nrCPHvJjq1Uztq8mtz+/CX6/
	HayUCON862je8SBSNi/+WoNj7a7NBwCESclQ81xwz+oZM3/zQAn3VPUluGkigQx2
	TqovjPfAgXac+6bUS2PLtzSetHmcUeubCh1PfUIlHTxdB3SoNgAp3XDmWmoN6veG
	wv54EZo3uE1KTFqLYudl4AB+8GujwWtRg8ApuvRrRdW4lIPT1oEpqoFrQjLbbjiS
	cVID9DjfARy6orocHZnlJpYKLFj61MvDu8Aox8H4E+UVqgLi3SOmGslfMBWauw27
	E+FFZbOpIso0Q7u13cACBp83YwsVBu+dkJsbrCwY1+CU9b7I+WGQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amrvr0k6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:28:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53SNo5UF023774;
	Tue, 29 Apr 2025 01:28:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxfeavx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IE7P8CiwBInMX6uYAfem/gkz/CoaS09u88Ie3d2ZqB/dR8u+aDahn1tNXu9XJwBp6IOR88gMdN9IHYmi6H1Ti629JKVj2uD4Besb2plciIl/Z0PW+iSEqWjDqa32UUAykI93Oq35b7eTvTSbdEuOUbDBqDzf7BdlaFHK4N5tuLVGqG8oJCiNF5AGXfmGRcNbqUgRMKlLh8OcBOH6UDW+/NkvVGmNO6ru2mW21w+EKweH4ErW458Ehhd4q7GFfT2lvWa5XNmQbsbJxUGFrD6wapDRHZJWxx7WHHmrVfkWtzUJUAxH/DeIG+aPueR8u/m5DkiFSAv5obUXL/Y7MGDgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfsZ/M7F3T0EI6VZ1gTLHM3i6IQ1TG4C/Y86rn7Vxsc=;
 b=rYw3sUYM6bS4mQPrzw9Gsdf9CFSMAqOsUvHMR2NjiOnKd9s9H4dWL/O9PcNnjQE+Vgmm3WWmyJ4NBVnRSODIv7DRRaVsBo0CdsQk5Sehmt3bdvPr+bxpg7fWJAoo0DOZ4CYAUguWqe4rg2P0UvNYAIQkJTylhY8xWg5RGbv/jGu/FAAGh+M4GxOqnjjMReP/H6Ock2cI7y0WLauyJQo8s+U0tJFTHCvNldhcz2Kw8d903hMnbQjHn7gzTtKE1PTOht4XrMLm/RXPfuNWSTDQ2tGSE2WHtZfcVlQY7NORNqMuwSdsEcPmTiuwFPSKUsStc54VUTPwnzci59GNloEprw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfsZ/M7F3T0EI6VZ1gTLHM3i6IQ1TG4C/Y86rn7Vxsc=;
 b=CTk+BmgPmJPw3dL6L2vopMTzqtvResh7jtof5BjasdCh8Bx38iAwZ6NV+nv1V6IbXgXMFcteAQyc/haANFi3JuiWS85CNcItYaudBk2jmR2OzLkcCf73hEkQ8ojjI0HuQlMyDgWht/ksBIammWFRFpQZ1nFf0PZSteCt+bnx9MA=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MN0PR10MB5910.namprd10.prod.outlook.com (2603:10b6:208:3d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 01:28:00 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:28:00 +0000
To: Oliver Neukum <oneukum@suse.com>
Cc: aliakc@web.de, lenehan@twibble.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        colin.i.king@gmail.com
Subject: Re: [PATCH] scsi: dc395x: remove DEBUG conditional compilation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250428124345.520137-1-oneukum@suse.com> (Oliver Neukum's
	message of "Mon, 28 Apr 2025 14:43:45 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y0vj3gfn.fsf@ca-mkp.ca.oracle.com>
References: <20250428124345.520137-1-oneukum@suse.com>
Date: Mon, 28 Apr 2025 21:27:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:180::20) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MN0PR10MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: 545e37e5-9ad8-49ed-acc0-08dd86bd145e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M6Kg338DAb6iMMjwYo+FrGWicsUoXIWEAxmUq7WRy8SQnJemEv3GZMPODPxd?=
 =?us-ascii?Q?zK+n+/Wldp9SapoOgZJBXD2wNfHVejtUmC1QOkSOVAtLY8/+3xofSZ4OR8XI?=
 =?us-ascii?Q?wJugI12k4+1Q+hPfqEnT876Wa2Jcq6yqmo9wBTTo0AA2A1nv+S8kVxB8g2k0?=
 =?us-ascii?Q?kpOJvmhfSghEZc3RKEJtVqeTMG2KydsfepiTUEUauYr2PvkInPBbc35aEORI?=
 =?us-ascii?Q?O5bhiNc7Y/OIe87ZjvJgMr+v0Tztd6BIpmvjqnl5YJkK3NdZLd/Z7ma4zpY6?=
 =?us-ascii?Q?tO6NcqFqH2QKpeqbD88+3GhiDUux/Hzb3f2tZi4pjbose9iYP8JPRPjYE/OB?=
 =?us-ascii?Q?CnR6D1Q0RjF9eO8sKwMyj2fvaetx3Hxqa3eKdWygVyRtscs4amSZ+8mLrrZ5?=
 =?us-ascii?Q?BujkkmSOJPCX5z7fDdJeWlK/TZLAhFjNpAABlzp9ks5oJbIWy2ATbrUGNtIN?=
 =?us-ascii?Q?yxg+ZQyaU9hpWZc5+d1FvMTjPeAlTsHJGbZbadKjyUAszHnIWb/2YvcTxad6?=
 =?us-ascii?Q?qL42/s4NdsIqMJeDb6H80yzwnjEFciWvYuGxYDtTBRH1BzKjphcXOGI/UIV5?=
 =?us-ascii?Q?k5iaONmidKJFSDhkBE30NAzFj5UwRr9g6CGaEaYkL9eR/59IROgpiUnjeyNh?=
 =?us-ascii?Q?o4ulVmQn+YY0TFF3JillXUTBZxDQXVovU7VUWRQy6JSytl36MY1ag3gQtptG?=
 =?us-ascii?Q?MrF2jyloXZrO3B2S6k2Lsik1PhSOyFc13mWtnfWAmPEvD0x8Lzml+YyLTxwK?=
 =?us-ascii?Q?24rqACGOukdz7I+DD39pvxVwucbrD0m1/EpXgQ/pKVKuzXBS1/QA878zMd1F?=
 =?us-ascii?Q?DrYSZoql85co8GQoTOh486qSABgHSAanJ+NKJcdLyLJh1RtBrZHJ1AGx2cLy?=
 =?us-ascii?Q?L3mNyvW3EtJhOFtHywetll36XIaIJq/xYCzwgKEXGmPCyLizoV3Wp//K5caO?=
 =?us-ascii?Q?znRD29GMQBWWavlANpwS61ozrjktrNatBzRf0Ygwe3N6qG4CzmWLHtW3di7S?=
 =?us-ascii?Q?+lmvvSWgCJYETytJnNdpngwx6BumP8bAIa1Qz533E7VFgXe92iimfGzI2Y9s?=
 =?us-ascii?Q?OSmctVMtl5pcNzZ0hYw5maRT8GcN2LvYlv2mGMh1BS6K1PTiiY9xCh/xg6aZ?=
 =?us-ascii?Q?PIbIal2kxiCWoYqwpCozEix8L+wj1GKKKn6TAYlTcmh9Gs8Su7vqmiKpd+Y8?=
 =?us-ascii?Q?761Zs3SMYYEg2xSsk7elt3CxfgdiDGMhfPPfAl3UDKcZnXctSn4z7YD+v/v6?=
 =?us-ascii?Q?QtfBULhJSR7KAafw+8ennWRcCF+tIxi3N6vaIu2JNuNuViPKpNMAj8SolA+K?=
 =?us-ascii?Q?GNV7yPVd0kMgvNFcKq2otMpY7BxRF7QIdX/rxX+FhWZ7ePwHWEQWFdU2Hf+S?=
 =?us-ascii?Q?TwzXSxo4Ptj3mSy1Mno7FUFatv5xqYXG64B+2TLmca16nJv9GDgKuBfZqPiH?=
 =?us-ascii?Q?kdVNOPOrAm4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bC4B81BRFeyaVk4CrLbgMkJh82d1XNksdL3gkVAGy+89xNfUuxJBc9JV+SM4?=
 =?us-ascii?Q?wPwOvqXhM2Yv7QiMqzX1QbBK7nH4MFkjPdfdd+2vOidWTf2jtTB8qPIXtm03?=
 =?us-ascii?Q?KWV8nzDPrVkgJIJL6I+U0QTUZLNqooaqCc9rMe5UTNjE1K4YWrYSsVdzo6yl?=
 =?us-ascii?Q?mQmnkywwXg9NTPFATygG5TBAXINrtcrLa2D+5CGLYMRvQDyKdHlDX2jUb9zj?=
 =?us-ascii?Q?iyBRAjdA2l7k1B1YWn0yaCRNLqQPOdzFvhirlDQvakuSaBWVU1jtCljw+gIw?=
 =?us-ascii?Q?eC7lHye+8DzZyVkEepPJONgrT6s6pw3Oe9xaaC9/Q5u3W7epDshowk5r/bdy?=
 =?us-ascii?Q?DRB4yd95ZlgOLNZmmXl3j20NEuF5feqKjcMccqf6AqK5lyoy+5faPeQbMJPF?=
 =?us-ascii?Q?4d9WXn32zlxajx1ran6+cNOhOJpDOra371r6GwASoz51vYyhzZDHUDthQ6o5?=
 =?us-ascii?Q?SA2lZ8yddLfi7tnqPPBdocKRBnJgpKWT9J8oTTQEkD2/Ab/N2HnsYo+rwQwh?=
 =?us-ascii?Q?1/X8vNKOnx2oxiBmN5iGwV+kxOlrh3CYLzFfb79WG/oCa9ZWJ0NdSirh3/hb?=
 =?us-ascii?Q?ctm0Kd+QnGNqVvuwhrFPfeUnz0edK8aXuHTcillX4NVVaKLt8jnN0n3MosBB?=
 =?us-ascii?Q?kW+a/Sl2hHvwkYmBKaXkHlks+I6aRXLtiOzVY6KEJiCmjl0t8eKOlewE2DYo?=
 =?us-ascii?Q?/yOHXLdldZgY4rOOfaFVqPPK6DOH9tBoXOu/N7K6zAYUZ9Dyqum/JQl22v6/?=
 =?us-ascii?Q?9CJDUf7z6d1QrKRwmE7ZlxZWqOGoDI013xSalTQ14ODhaEg3vLlH3co5srgp?=
 =?us-ascii?Q?YKGOtkBko3/GPb7bHcdN+PriBawTbDk/HoHs/ctCr2vTHDs5EmwWWboeVqRL?=
 =?us-ascii?Q?8SnwyVwqroTMADsrSvBp7JcGlU6ovCG2Ad3rle15+F5HAi0Rd49+IYUbhZxl?=
 =?us-ascii?Q?4hqoEO50BIdCsTLogc05qRVP043JjfqiL9cGRDfdBqN3K2pLrpZSWNQEkzei?=
 =?us-ascii?Q?kKCXmcanaDCUaaLyL9JYhTNNrwwmG+QDPaki3BtU6lNRFQ+Y1IQmNq6eXNt/?=
 =?us-ascii?Q?jbzIrNxHVtRm1dLm8un33QH6C5MaOwwTDdkKTvRLrDOdPbcf2Q+RMWFwFouY?=
 =?us-ascii?Q?yt+NGpxXMrgC3STGVxmzOBjZCO/Ub4bapDEeB7ITefCZr3RfmsZ+tAvpm+Nh?=
 =?us-ascii?Q?br7VdhAsC9EqypUgta4r9DkfKidp6H4CLQV0uoIaYJ4USD5jnapQSjnYlaMR?=
 =?us-ascii?Q?xk2vjsdGaHikk2nFJEtJ/4tDHmCpN6nHJ9lx6LQ6mUGKdE0nN4grcdj5msgj?=
 =?us-ascii?Q?bT1eJyw3UriGR/aJVhHYoHUbhFfm6Dyqc4y+Lt/w9/3tsrYP0enTNUGjqzDR?=
 =?us-ascii?Q?iK/fLAO4Rfnx88Yq+jWqWjREtkxOE9bc+VX22K/Eo62YrEH+S9hAoj/qe1CN?=
 =?us-ascii?Q?PvCp9JsH2JCpE0MOG0hAhhjzrQ1v9HpKQpAjDWATf3Mc13m2v6D3oIXn7TR+?=
 =?us-ascii?Q?oGtBlRuAk77955g9juEAz2mp/Gtp+nbJoUvnWnUkkl5x/v6Fy6F/HnQovoGd?=
 =?us-ascii?Q?4bbNsKPbSBjRy45+EoI1ALpqLQbshy9QKq5RNqq8khssmchkarZUJj5I7cHP?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nNSuqH6jBqmX36r05a5uQ7OCuVQ89MX5pa/XGSK5hM5jB0CrXyXtOQYYtzjE3NaNL9FB1aCyO5oKPChQV/BWqxD8Sm9RGajx7o4bVY9mbIyLU0IWdHqF+H305T3YUZZ72x8YRwIHIB+sZLkcMe0tRd3uyv6++RAEOQZ0YmGyU2/hgUAujnTMqDaSQHB3R6JzDQPgyMFaDelub2JmEgfHkflp5VgXHLYpZgk5R3EUxo1KsReGa2BZcKLXCuDIrDPqHpls7nKaxGw4awEqrSuBfaFbVq1/krihMM3xDD2EhLuhl/Q4wI+N0Altb6oVqmGY0Qvx6oS9V/ycIHqzovk4EQo1mRHWK31uLurkUxpN0rvOdvmue3GXWvkDeFDfVm/QkvqHrDE9ELK1rTQrSGMcR0Rvzw2ZEvtcxEUZbQOccK2xyi7aEzNT1WgbqfG1UK9XQW0TwqK0zpfzPqKOQaC6gk0omf4P+gIcVU29uEOzqlHLsHhI/zZc5PUzrOTnA3trRlu03Kz654XjH7moxDwpn35ZIbIT5REIiwIfUhE6iu4rcYHHgeHdL1nUc0q8edWO17vvviAfgiHCGmJ5+xVa+mknBf1ID0hxDzdUQnSmcDc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545e37e5-9ad8-49ed-acc0-08dd86bd145e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:28:00.6382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZELap/9pgXfCS0AD6XWV5GXXayFuVgEpGDblnCG3evkxtJGzytKGNcqSU5C/LmDhAuZhSSsYhrBOXG8K4tU5gtIz5PMuEM3bzbspIZ4rTD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=707 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290009
X-Proofpoint-GUID: 48v5xNiJzarGpty8opQxHXfWWS2NrH4Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAwOSBTYWx0ZWRfX12qLBndtd33K 4C+eFcsvDF67owQhfgekRwR7R1LJjTmjSr0WXhEnpkp4HK2KoEfeMZAif5m1gmzJWjJ0Xz3tepr jOribguq9DNoOJweBhh2bPuh9Zmq2UlXHhTRPRgbw0kByeIqTiSzkn4a//2Ru1EMVv5IZLOJEXe
 i4vhaala/IHqkSgjB7YTm5iYYTWv6ci88SBGkrNcD6bwI9ADaGTUqhc4abdM3TOeV4Yui965nuv /QsOO40SJ28LT8jbzStq8mCxsAIsjXD6lA0QSq3/6SlMxLyqwtzTIaCepUVUg7dqXCtYwNKylLx IPv1b4e5SfNeKKcAmdi4jyrqrvdOtDm3FBSOdkTpzzxQI8vVt5ukIWhqTcxAtKfDtxyshW9U4yP KdKt8RfT
X-Proofpoint-ORIG-GUID: 48v5xNiJzarGpty8opQxHXfWWS2NrH4Z
X-Authority-Analysis: v=2.4 cv=NPfV+16g c=1 sm=1 tr=0 ts=68102b24 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 cc=ntf awl=host:13130


Oliver,

> It has been broken for ages. This driver needs to be converted to
> dynamic debugging. Remove the crud.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
