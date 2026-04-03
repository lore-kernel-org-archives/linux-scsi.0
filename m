Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481083C2D
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775179119; cv=fail; b=PktwYGFF4CEpYoRROZTXoHVsB72AsxL6c4SWHDgu6Q6yuRymb9ePELX6jK671lwJBXe4IiwKMN+KBQuGXXyKjlcKA2G7CCf5rpGK6WrZN6NErYaYFaWMFTu7X/S2b70FsSVoODJ4QFwxvfGOEvrEpKQIsRsppHg0t/JixQLoW3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775179119; c=relaxed/simple;
	bh=woLEKrpNhoLu1wLOPw5Vpge3LtFnQHZMbjySfXtJ2HQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RrnHrd4rJNpgycj6UYuwvvuvcZ02XAGpub35p/LU3/750nE1oYp2/qNUFZGYqNlDQqLLLvHdoKi8UsanUZAX3QQgDTMnITntx1wwmldZB+iKgMfziaCDoPxHyZdkY/TTvJzObRBjDshz7yTov5AkAW0qfRcME7tMo2S0p2IqyCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XXDO2Zll; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZwbXcx6x; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XXDO2Zll";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZwbXcx6x"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632LLgQD2266026;
	Fri, 3 Apr 2026 01:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=APBQln5xfXFaDL6f0H
	NU2yOPAQ+7xN9UW6nKwrniG2E=; b=XXDO2Zllby83AGxRSKwd2CCEPYAUQ25qT4
	2R/iKVraNVf9f4C6j2uLsQ9lyq/bUr1CPM+uAcjxT6DU3zIj3t4ClDHb0P9ro0JM
	HVqYFBVuEG6bSvM3lUCLnTBMavSMyvS2W2Ou6945URnCfuz0FJePAY/AZYsDEwAc
	H+IHgpaC5LDnyUAj3zaYTLIbA7q3KvOvsnsGoEUJN+idotTWDT/VYR22zElSLeYD
	N29tKq+IXgfN7hQjkXbrCqJuvd+/xH/Clf90pueTg5NxfwBpi/suLfOOg0xiJmzL
	EjIl8UBvOhicRJfFXNgbAes6ZUXc5r3HlR6X+y7+QsvmnKqolZmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65w7hft7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:18:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 633143Yl024610;
	Fri, 3 Apr 2026 01:18:31 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddukm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:18:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyA/1NdYSWSALs7vlrLhwcY/Hwh4NTIOWn4uAzfCh0gS5rKJAv2nOZksbOquyg/UIV/YXrL5ltj6PZvvniDpHszJDTVqTwh64dhL3kz5OpIq7H1NFPdttKtP2BF9Jrqxv+gQ7czGOhRhV3LCaGE22JhGuIvCYPZgwb6pNoEIIaYac6uiPgq+xx6dmcs/gt5lC7wZfmne3mkg/VezpMqFDzvIJgSaXOL4mTME5SCDFAdgF6YTsxeS1sdXyezMZj4tFBPhIu0GtQOCvhVtb2cKmy1xlxyBtxw2Uy9vPFzov7vVCJVda3F1gqixMOmCD8aCipE1/L1BcX49c9+zSGwhOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APBQln5xfXFaDL6f0HNU2yOPAQ+7xN9UW6nKwrniG2E=;
 b=Pv/z9CsvM7Kd8fT8Ui6BnjHYSnc/TH/0xEJdxFKex5NiURQpMAT+/y+i0ccyledM40gGOESwBd/LKuCnwYhOxn9LbwuFSf4l5WsVvvWMISjfOcYvJ/77pa2g1MYfVMxBPZ2xFOx7sjbrCVuZy1usrlCIw/0UsK84K4SZQ2TYcSxIoLoaFYPZbmShY8X5/3coFLml/s1dKHAm7SIa+5EyUehAqVatfIJ9IiTKy96R5f8e1J5ZJqNmkpJDA/Wcq8uh7LmLxI7TT++5m3pnLsNGXNh1c1A4K4PrxOp68UrpxB9o+9a14zTNeewkdejjf0qT/BdxBWIBIM5VknHYbk4YEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APBQln5xfXFaDL6f0HNU2yOPAQ+7xN9UW6nKwrniG2E=;
 b=ZwbXcx6xJUjYz7z3A6ECW3IEkExe6k2yOsgqduZVfQD2XaRaw3gK4Mt4NZPxmqbVVUGyAV8Taxg/4zPaB8tQp/WhpOrWFIMaDLqnj0qRTZXRIxjeYZhfvSxiddMi9CRPiOMVMRut2BB68R3IdintZ/sF+jBuL6/XTLJhH7GkZZM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPFA632C0238.namprd10.prod.outlook.com (2603:10b6:f:fc00::c3e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 3 Apr
 2026 01:18:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:18:28 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: aic7xxx: Fix compiler warnings triggered by user
 space code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260402153341.2909184-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 2 Apr 2026 08:33:33 -0700")
Organization: Oracle Corporation
Message-ID: <yq1341c4zae.fsf@ca-mkp.ca.oracle.com>
References: <20260402153341.2909184-1-bvanassche@acm.org>
Date: Thu, 02 Apr 2026 21:18:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:610:b1::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPFA632C0238:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e410b5-4265-43e2-aa85-08de911ee94f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x96CSLOOG9BGmnKqE345LgMrlpJyu0hMt3DN5XMekR8MmV6a3GU6kuukdxkBeKRGoUXgnUXRdUKdObp3ohng8CfMZEew2ZxvhsQ0JQtS1Fkj/ibR9tEiUXu5klRJWgYCHRGzs2ff0+WKQswL2kuvrO8LYuhVt4MdQkPvPmnc0OJlwoevA+7pj3WiV4CoYwT9tt3vRIcfZqzssqPFpmcvLnCRSMX9AyLYr+/mdUwBwHUspYlmM922JnMAwLNWcGxUJOkSSU8BNHrm/YiYuKMkXKyv+KT0XkGSSfaqIIPVNk2wzmcLbo8PE7YKuXrejP5EvSN9ytn+uHHu0EAQaI4WCBYwNU3H9bQvZvTxa+pF/H8/OFaVwWhlCfwehKRnp1P9ijIFOpgUyoUGvRawsIwer2B13kPtCRd3lgAuRdFdKNzd0v6y4Rk/99UgzHRa6niqn7yOLubSIrkyykKGV/OD+XoKQbB0y0fTyRa7wzsDjdmRJMopD+6SzVMuL3J2XDfugzs51eQKTSy/RLZ2UfXxVC2vjgakmnYYn95xE5GhxphAq0o0Qn6dDAbKBTk7jKRNAqtXSXcrO37wPkTJcYFdbcZvrFMZ4Hj1FLauCOGLZuOXsDTgwEG8xWBbxQTKEf7xF8SJYD2q7cSFK5ZQ9NbbGH8vk/3UjQRjyiS0qjjDzCTjCxaRuDtd+8tyYcqylHqBBmQCTzjn732OerAUEawZGRHkicnWV4B7dD7YKmmG0yU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?txLCOOKoaPwqsMQA5it1YvoEA6v7AIMpkOMsvlEGVxi52wo+p9gUJsZvj/YJ?=
 =?us-ascii?Q?B7AvrpbVaru/FUwqVggxi3sClZ2baeQYeaA7+dw41LwB5FXQ4gV7PaDW1eh8?=
 =?us-ascii?Q?lAvkgKe6NMlpk/B7zrG3dw97wHZbsAnhMrRCR2UguSHfBo+vdvtNx0r2Fe87?=
 =?us-ascii?Q?1tPkPTm44oThcnUVoJqv7IhbNsetkv676MPKJzIpDUq1hOdm5u2ZFxk2IPW4?=
 =?us-ascii?Q?54avCbQtlrr19M9vIjYoMFxcH7DGvawpsSvoUgTwrfhuyGzRhk+qrJf+KLhW?=
 =?us-ascii?Q?LLf4MJnghi2EU4OFDggMpLioRqKrbQ+OsVg8nog+fwaFPLAGfti4AWVABdpW?=
 =?us-ascii?Q?4nBYUQNL/js3iugI8MiXCiYF/PSO+NeeBnA4y8sPMK4K+mG6LsTF+pycpdRZ?=
 =?us-ascii?Q?3Or1Z6iLlzmeJ3A1i3C2qYUN0x7GMIjY1W5aue/vaPDyMt+JbKbPwrkcf6t/?=
 =?us-ascii?Q?Rh7JRks/bXgHlG+qL6hvIybyWg/ZII5GRZhmuPLEAzC79sMn66yaceNrJnFe?=
 =?us-ascii?Q?M4JLVtcX7w8w5BdCCwJblMu2hUML2eqzeWTyC69B+XTQQgU+AILyHA+4qbdU?=
 =?us-ascii?Q?WHE0UthdQegVWf6hIVxuFXUjiVo+sRrwO5QRgI5I+XwxPgidgUoKdDQpHlUD?=
 =?us-ascii?Q?hy61kszb8SUxYIwRkyXv9errlonhu2bUnu5sxJbf2jpsdGAiqKU/bOGBLRnm?=
 =?us-ascii?Q?vho9P0jFFkeGDWaoETc1CZ+0irEvNHQ4prLH1w1YjTSEO7ELp9l2FGmt6Ip4?=
 =?us-ascii?Q?QR3ZmCmCyDVw3z8nSsXorm5EpD60NiOouOLwT41K7KrNEQze48lefLUEpzFI?=
 =?us-ascii?Q?27U60F4EvEA4XE15BXhk166xLMdiUzCgBlo3EdmgoQpY8kxJas4sbfam5ViR?=
 =?us-ascii?Q?G5opBtdQA6CF1ymNC+IPVAQ0HKxLMe25Atb5209SE1SAJ9IdIzLYh8maoKUP?=
 =?us-ascii?Q?c4Cr8b2wvePDXHjbGonGQlPw6unohb3Lv+mZPdBZ5EQfXq1Dw9J1+to3bXvu?=
 =?us-ascii?Q?gbX478xS1k3TGgdfM2vEfh+CwYYcE++/uufnzmjHYui+CA3WgSowdwfgMiNZ?=
 =?us-ascii?Q?c2uQ12l6FSYpJhHg3qyXcAp5BZcYQslNcdFJjm5ceSPUTPeFVxBI+i49eLfb?=
 =?us-ascii?Q?Mh795p1JI+fZY6B4k0x1jbDR2lQxJjsTCmBJl4rLriYevvdoAOiLMohqaQEi?=
 =?us-ascii?Q?qslW/1PdzXgJWaVAZwDypHBjX04hUsyixkbrWlE956IpmCEdgSxlFDYlOGpI?=
 =?us-ascii?Q?+CE0S7imiH7Y0YhQRq83Nl/4y1Nh8qUkN15MnlpabJ++qlfVdEDUgBfVqEek?=
 =?us-ascii?Q?9bx+o4XlfOSMD7YEDnNa88SixLmZmrdw5tE25snF/BIqC2MtzWLStc0VsmpR?=
 =?us-ascii?Q?FzNkIamz2gd6EnO/c+qDA8XlIqBrayDF1W94Q5ap6jn/z2bnvUiaGAC+us/o?=
 =?us-ascii?Q?/G5bOfm9ChtEEUqks/FgLCXTL1mNQUKSCY9NitWC9Y0kTIJWuUmXsaMJYAUP?=
 =?us-ascii?Q?aDJtlmSTMd+GijpKv8dak7AMS/Kh9gsmnyTNNYLrrEaPfYuS87SOI6lNij/f?=
 =?us-ascii?Q?bDL/kFqpOL8OyssL/73o2dKtkxa3vCD+S23YhfuSmhklM5+k05rdCQ4PKbiF?=
 =?us-ascii?Q?iBlNyUejrpNG5t5j5LFB2ykDKx05z8TbF++KS6O0ZeO7cghtCG9/dqkvBk6W?=
 =?us-ascii?Q?sjf8nl3LxX85/XXYRghwqkoz10uq5APgTJLN94+66Nka0ddN2Le+SKB2MnCG?=
 =?us-ascii?Q?xXG3hd7teFKX4etBUnjkco4kq4jz6ZU=3D?=
X-Exchange-RoutingPolicyChecked:
	UnSGRIV8F8WvozDUa6pPFo7EiFxWKnUT8SGNFc0fyVm0rcOr+MykcfqY+mxxwnwNKC5OL+5bcjllHDtiFhzR90thbXsdGq4Mr4Z1h1MuSptq8HS8KiuAXpLEd3itMJEoBZSzzranJvj6uLr+zbFjqvgIz4Xt/kCYe4ogWoL2REatx3BiKHy2PVbzNnAftf+iwwXK4R8R3r6IzMmiY6JHd3WgQ09Jq7TJxR5AfkyLKcfjoNaWXRmb5jDJ3paN59TuEqtUJ7emabnd876zV/dBQEds9AJPG+xYkEY+PXUNVv3Wv3AUqk3jDJ/34QR7j5uOls53+xw6WyKoHouUoJ2Y7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JZCYui73mpDGX1uhNLKukru1BDvg64qbbpnDBZtHCh3WxF8Or3iZOUH3WgHv4nvil4zmlxPeNoySeekUbVsDk6F8uRB/YMx/ve9U14dKiuGVdNLs1VvhqRnkNGrSuYz7kRjquYN1Lef7CjCk6c43OGtQTX4PWHKQh4AELuR2aknrLZTV6yjxBogM8VzZREDkWyXNcpazvz2W8wlRa7dS9FLUTJuBAD80V15wjo92ZgQ4n/EVZfwHj/rO12ff3g4/E8XuT30dl+5ZMmA2rq+efdWX0YpSXn85VKG/08r4Z/CQRZUiuJi0gtQZTqrlw0PzyKQh/IsufiNI3kBAtiENauO6m6Y/shLJxi6u1RnsdvtkbNPtBcPvUqV8IGX+CATkM/ZR0PiOKGy8MOMiTXz0byDpKigfIdPqeJ+VNmWAHLBSwk7cHNWr9cb9AUqycmbJ8B064NwsvVwZ+FHqQJsObo0ACBftdQCfjwl/n+wAyypHWqBpMkPQ/PiRDiYzZDghfBvtW5zzg7P1dWiJ3Vmv02CzpcYTD77JdAfwh1qqi10VR9ZFxHmRJqZq1VJv+TfbjdlLZVOcPrbu3B8qzh/ml+Lpb3VLjPg9aAkjn3BAmLU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e410b5-4265-43e2-aa85-08de911ee94f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:18:28.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCT4lVJTU2PLCP5n7LjZ1znZvw7+39YtKKNRdYHLWQLDCOOYC1aPuWWSaUUPyqSXhigXLi7h5n3S/Wdwd2nkZA53+eATq3jQYt+Y1qNQOVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA632C0238
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=919 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604030010
X-Proofpoint-GUID: bUc0XcPJ8Rgv6BNrwNUXZmbVLxmOKcr2
X-Proofpoint-ORIG-GUID: bUc0XcPJ8Rgv6BNrwNUXZmbVLxmOKcr2
X-Authority-Analysis: v=2.4 cv=DKSCIiNb c=1 sm=1 tr=0 ts=69cf1568 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=6gItoEMkhOOZMK_oc2wA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAwOCBTYWx0ZWRfX/dAk3UrGdaBp
 UtLG+UJjtWFXuDe+93YpspRDZmktZgoHU+XGH1B7lK8Gq7P3DwTqLw2sbx9XrPJXHZZ1XsygIH8
 RPxdK7wgr0VZ7MBtzdsYVV5DzcdpzvJd4AaR4OGvEGdmGVt58oxDYuolbpMPCPwBPsS5T1G7V0W
 ju5+fq+92K5rCT/HDq3F1UqZ34YruBkFGm7PGknGU4ZTMedHO+TDxBI/uafytx3H+o9odkYI9Fu
 NyNA7om5RmB1k8FLB9zNCnlmLsjlxrfPiUA/if/Rg8JAVPDW6VWi1XGC5s32kyp2h4xju6VDvMa
 dhu6TLgR+KLLEQooTwfHddXSCch0Hz86n7DXG89zhR/XoqaVSX/3GPULKsRNlz9S8mSksdpaRe/
 WJW7ApSyBB/KUfSbF97giN0Izj3/wGkJPUi0GVGFCj0BuKZ4ul4CxHgV/u9I7NxFLjbqQzTeBjM
 FwLR1L0U0E0cbT9Ia2g==


Bart,

> Fix the following compiler warnings:

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
