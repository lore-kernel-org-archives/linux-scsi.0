Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2541153800;
	Thu,  9 Jan 2025 14:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434756; cv=fail; b=GqX6Bw2u4o9g2Hg62PtzNw7/Ihy+F8VcIC5XiyoDu9dNoETPYuzh6ZHEGxU0bbluhbQ5qfBiTgQIDLIrKsh4mNKUFgQOxmaF9Q1xjpH5uF+XlsKKeZdyZrA60MgZswS+ZqdgUTNQQC7lm0LEe7m+VTl470l7QUherCC5tEFEvUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434756; c=relaxed/simple;
	bh=RwGyue9ZOafI7qSddUbfL7ohLUDvH+WbO0/evPLUoyM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=blr7/ZokmDJkgyPPwOqiufaUAhek95TFZkK7dVOyNYROXluNjTdBfysxe4ejmbWX/5DTQiCOQrb9Zejz7lI4s5FkA3dgAjREgDv08wjTEN2OfQmrX+1dOxXP0LHrqVnYVCSVqvdv3axAwC1a235EyYOt2wsMU1YRsCvqmO2KoIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B0UtA59/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TUEn7OhQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B0UtA59/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TUEn7OhQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509CfnRD010560;
	Thu, 9 Jan 2025 14:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=221B0atVRovyEQXjI5
	pui6cjMEK45vgcMTSfwAXm9mA=; b=B0UtA59/V6rcrSViqxvn3LS01L7m++SN0l
	I0u6P94Iz0M2SWtJPop2q/aZgDYlGseuqIQiM6aOKPYrtTv5qnhnqy7GjEphaMW+
	wKKdnnl86OXi9/ErPOpe4IWkm04DbP5SEzLRCvOiZn8c3G5t6ELjbvCW1vyNh2Oa
	GrdV/5drSK3rI3VVR1YQ6l/ztbj7qvxg7WI0YBdXPQzm0TDtNnPisF12OodH49Y8
	S0axbtmNVgTP4aTzDv3P0gjRv7oq64ZtfHQC0+vYqqJWgP1yMU055kUan+6uAVz6
	1mvEcqBVvvlmGx69RD+WRSylIPFHLI2pihlosXqpI5WoatZRta7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xwhsrwv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 14:58:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509DZuM9027599;
	Thu, 9 Jan 2025 14:58:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuebe7wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 14:58:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMkCn39Cp1PnGuRI3XrUsGWc9zpV9pJNWP9xf+TvlKLgOUFLGhnyXYMUXOXlbcKbyKMs1rVnQl65b6nnwkkhFaKgF7JmxAu/0X04De1hn1HovRgHH2YNnYcxIAQ20KAww79XgqYxW279tWlYx2DVB3xm2e/63F2CramDZOf0MX6Cp1oyy5xBSlXEWDa7Eu4n2TPtwHVpBl9uLbEQny08xcacIC2g8Ppu6okE96bYtRrwiPDHEIcIwEblp4OpdMM9+3PiMtQwKC9wmPMkKE6zEtw81JouJNCGKh6S5zb4AV7YjAqxpaV2qmG1Ttf1zCLaxM4yQAnHsjKvvpvPipsUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=221B0atVRovyEQXjI5pui6cjMEK45vgcMTSfwAXm9mA=;
 b=ytRAH77eq6Bk2Bj56QONMbGOmEpKFrerV1MKNAmkyynViRW2GBeMr74AjvV4pyuIcOIHyFK3L7pEnFgeV/okRIXe+3TqFFTV78sexAP/zWQ1hDEWb2W5Q1b8HMmitNx7noXb671x/Emdu3bdjrxSRc0/Lde5Bnhg1ScoYuD4n/kQ/JXeTbas2DwaXLQ8nTo5vYcynnAhmdSy0ZehLs7RkntF1AVYiZoGn1/wV9BCCETT7+izqxdqF41LikJ6gT8Tl/q1Lfj+n2EBqPEKQUoQ/7P804W89VqhkImpX2bCVA+VKxgRhP4puT3e8KjG+ZzUI/85xrSsfRTfDn2SdA1vZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=221B0atVRovyEQXjI5pui6cjMEK45vgcMTSfwAXm9mA=;
 b=TUEn7OhQZTbFLKCypstFM42Q7vY5OEz+59v8ku1XaGGWd2U84oq2uMTV4udfm2X6v1oqKvqDrtDosZUPArH/gYsqBEVRNO6V6rrnWrfQOhfFxhUwkNHWj10YF/+Q1TY6usqGgYiywv7bS1qWRQbUzhLsDzfq0jj1EXHAZjKNo/g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4400.namprd10.prod.outlook.com (2603:10b6:208:198::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 14:57:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Thu, 9 Jan 2025
 14:57:58 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: fix queue freeze and limit locking order v3
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250109055810.1402918-1-hch@lst.de> (Christoph Hellwig's
	message of "Thu, 9 Jan 2025 06:57:21 +0100")
Organization: Oracle Corporation
Message-ID: <yq1jzb4828h.fsf@ca-mkp.ca.oracle.com>
References: <20250109055810.1402918-1-hch@lst.de>
Date: Thu, 09 Jan 2025 09:57:56 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:40::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4400:EE_
X-MS-Office365-Filtering-Correlation-Id: 16533aa1-8f94-441b-1f80-08dd30be0196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+t0HhdP26yu7njxl3TIWWVvGngpvill36RsYJyLdzmLW6Xy1nWAACFQ4FtHt?=
 =?us-ascii?Q?RJbGrhFQAV04qHvffgSP8dTcguHB9Uw29JW5shmK0lCkJ9TcjEONhoYfokl9?=
 =?us-ascii?Q?5UsS4JuyJRKoVQX4RMAJzmUevaQh34Y0T4bfR5D4sufxGpqtjfVB1MhGk5zx?=
 =?us-ascii?Q?w+AadObG8qNymMcMCEVoZa2tBcvHLrLDPdh4KPUOG19kpxzoi2ejK/MRI88L?=
 =?us-ascii?Q?FreeqtLzUwuRVm4Z+IM15I7mU+VaujhAh6Snxvs0/zZ+QeMt5siuxH0rG7O9?=
 =?us-ascii?Q?OHoFJayXKL3J27upooQhHgmB5Ol8MEbSUlVLGEme7fRkD8TaxPTxmWxlEYt+?=
 =?us-ascii?Q?wEmTvpzNlFhI33uZKyWoDjjs5fyUGpRAiWeCnMu2oJBaq3QSiq1QFALVfaeq?=
 =?us-ascii?Q?byYbtYmGxiPx0bbb83Vumh6bOtpqqDM4fGseekQUtA2snV4F09xR+pLEfq3R?=
 =?us-ascii?Q?rw4Gx1EvkSGAsc3/ekjsH36Be1UzLZWVYkijUEOWvMsjtY1z6ExvqvD4Cuzi?=
 =?us-ascii?Q?MwBqVgXaIdJmsFEtLQp5TEH/GMx59MzXgKT0aC+/qi3fPY1q0RDMvNnnud2y?=
 =?us-ascii?Q?s9UnWc0+XZS/zdzDVCtHOE2ZE7Kp7e0lS1uEoMp8ii0pUOntTEsZ4z6vZqZD?=
 =?us-ascii?Q?maTWRCS5V4VBjWekfBT8GfTmV2IvVaZR89G0piOFzoN6DjmXko4dKn8iX/3c?=
 =?us-ascii?Q?v3v/aQ8A9ak6ieGNPV6Uz/T49ZKYAStX2lJnp3tMLe738LqHhK24lhtpDUwZ?=
 =?us-ascii?Q?8GunmlEdtSkQ6L/ebjpd82oi46vuPFfqF9KVwWd8Oy/EQH6T8D/6f5QYFMkv?=
 =?us-ascii?Q?7Vi+RoqvadFw7Ilu3PLKycTMuWGUA5mevk/K1k/ASOB0iHghgRap8X5paw7j?=
 =?us-ascii?Q?lIAY6vg07YZ4dPkDDecV+w2ewOpukbZ+j8x7vkZ7M+dU+EFmPAcPVXxCMSiN?=
 =?us-ascii?Q?N9wvpk6ZfUh6zQRAn37gKEjpXr2Gpg/0WhUtL/W3GVF7pKw/xfCzRvRoD700?=
 =?us-ascii?Q?DfTfI72SOascMRW2JstWjFVOdmbc3RK94M3hfexwMYw3xpOJjuwVkiFty7Jr?=
 =?us-ascii?Q?OYc3OG6ptsJ2RFol1A6fNo/KwVBzm4uRhcs+UR3W3gt8zodV61zCAjJ1YUIj?=
 =?us-ascii?Q?LBMDYdAZsoTo8BO1lvIqRVtRtXN40TfCSCtPxlroYtrQloEIQ/QSZ9aq+srb?=
 =?us-ascii?Q?hXRu0hAvgvjD8/41QRdQViEPHn5KrJUy9E95FFatMIG2eJMamRG+ezHLAvnI?=
 =?us-ascii?Q?CkdgFVO5EvzBE35G8mb1lhNcEI9PQwPEwlgL5MPYKxPBARcpZIRWc6iwHqND?=
 =?us-ascii?Q?m7ozaFEvPLn0SDWYTnMr0SkMf7zH3y4gU4/KSWjqkpZUhDGqeaLRGxwrizGO?=
 =?us-ascii?Q?L/HnKX2cEbb52W4fOYA+vQy/vOia?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?odCK+8lOme5XRXxHNAxK5+RhlWRknd1nraM/XhQaWjAXer46XK1Gdb9K0epv?=
 =?us-ascii?Q?+Oz1Tgb9ROxAt2vBAwP9i5DPXLBspEU0iUlW+YmTvmkkOCcA9cvkGlayuRzQ?=
 =?us-ascii?Q?/Xasaojxe4ANicfPwYgy3uf4uihj2g27O4PhhAyH4pfH5dO2ImBWEmb/3XDM?=
 =?us-ascii?Q?B10Nsf9gU6jh4p5mAQRDbtzkGKKY5qwnNok7KIiIZSuzqDcU6JkCZYFkAAYS?=
 =?us-ascii?Q?mbc3aoCBht1P5UOqq0gB+/trUQM439c6MI0BT06FpI44+jUFrM3uoJFzMgPo?=
 =?us-ascii?Q?a5+9ZQ6k5bI4iUxvLRsKuB+NGDXWxOJZbC6Bxi1IZRadxz+IjiYsQ0Mevskt?=
 =?us-ascii?Q?03GRRYTqHyakWVni6SmoUAROtlsrOMrskhSOJWAfP7c0098rWTOY5L26nug6?=
 =?us-ascii?Q?MNuuCEIrM1GbAk1XOItAUXjiVba8h73lwr58Pc8mURQG+U9TInYUbVFlvEIS?=
 =?us-ascii?Q?oFE4qusi6DVmUiI9vFkzuYyMvIKNu8ugauA/fMF7DIfGFcWeZLPPnsZincpn?=
 =?us-ascii?Q?8tFZymIuFcq1GzcymtEKQRHXl4VKX4DFaAZOko+EvRisPoO1fa/BkV/MjSOS?=
 =?us-ascii?Q?1/yERIWI3wSGNb/a55rQhFoFqyprmfzesCkvSRTE98zHmWFlteefqKOpkaVF?=
 =?us-ascii?Q?3oiNqr7c6Cuj/eMKiynaZqPgIInLbDOgwDzW6PlOhr9C7iFGUpxKUJX6ET83?=
 =?us-ascii?Q?LOtbI4LVsP4wGFHc0SsBKfrm//p6OVtJSGDGZ6DCioY3qWVDY2WI0XVS+289?=
 =?us-ascii?Q?MYnZLQMtsgj7xoPc19D25uxc8E4HN/6l37lRnSDWEmmPJ1v9yCWEKfXJdTCd?=
 =?us-ascii?Q?tsI5KRfdZYQM6Z30VRY3Kz1WPJ6+POUOqPB65vTpWYd6kSGc8LpmCR1RaOTO?=
 =?us-ascii?Q?h5EvL7vipztapFZtxiuNYHIxu3A27FSwqnd48kFLoyH+OG7fyYZr8u4FlMiy?=
 =?us-ascii?Q?vivAndYDVQJzScpydTL6+v4k1L0DW0rrZv8YAI0QdkQMaWdyxj0HsZFQfHsg?=
 =?us-ascii?Q?3Q1T0ceXdFULMNiPt09xJGIcWgSJweYDzxt7pIH1/tp6gubsn8ZptzQ1s2oi?=
 =?us-ascii?Q?NLPjEYnlfDM4NtgQmFVV9FA/nup5xaeCevqRVfhXo9j80/9BIFSiqPy2tr7H?=
 =?us-ascii?Q?IvjB50l1VZE1KOViwasKfLIa/W23KZKVQTPfkgBTJUAdCrrxy1113mAFGg31?=
 =?us-ascii?Q?BHn7MrN++hhPjpb0MbdB+nBnCiFJilRgsG4N0ZpYYhqq0oRhiE+pQyRQdx5/?=
 =?us-ascii?Q?jz4dTRU56BKr9uoxBnXE5so+cNwMKrJs2dOhcflA7nQ3Tlbft0B1vbw7TosW?=
 =?us-ascii?Q?w66j7/M4sNETJvbpWEJ5R5mYlRsOcVha0Oz3BzT+fhKOzilkzPWX0XoGOcXm?=
 =?us-ascii?Q?/OJ/9ZplEkeS6J8CinI8fVkRd3bRWRczUX8Sw0eUPsXCSdAllkZetq5wtmPV?=
 =?us-ascii?Q?tngEPmtCU4K1/FriMBonAq4QtpZ4KxRm6fgR7uLfZLfWSmXpyyIe4Xs2GLBX?=
 =?us-ascii?Q?HikPyJu/Asw2Qzk+LRzCETRG+C1HtuhUHsUMRx0UNYFbnS2TAJvjt0dC6PEN?=
 =?us-ascii?Q?C0HZwY18B9Fsm5D8TnXlV9xqHqYMC91U5G0Km0ZJqd8/BeRRECTH2GEvf0tz?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YbWhbLFEJ05ayVsfAXYHtB9num30mkG9d59lrwTdoisiYkqvLgDFjU9NxSiuHdLNJdMRuJGC0B0imF66XHwQQz69lww+cSMzEBKbkPwdjsB2+oAs5dSPaSDAH0QUk2UyOLqhIZglDmPpdgcag9JN9MOnLXloM7qHRSEEZvZMSlR08o6q5RpoejnzwnMzZypU4OwlQMFKBbav073Lq/Hga8ixuFTYRo+/rA9XmwZjjGmISRCs9kd5cBa1ceo4jx41X46CvDMyLtXoWVlfUoPWpTdQFZG9JGteKqENc/8A2HVEOQ/J1x6kjhDka7hW5tI/SVrYQHZ8OumnKkPajvpsTNu2b6u3Hq3RoRyW+sVT/Zk05LA/8Y8lfPi0qa/h3vXqj/wYHZOCk6Rq9OUW5e9CToHW9jqo+rrcCACBWV7qlvQqwbA3PQfxDZyx6/S3fSYcV6ROED66QeLEQa3WV6LkDYZM91Ao5XoOF0WjnJAQ3uX351lak7R82pGQF31vCyaxx/kTBYdl2qvfEJTaYTDgUNqWtOzoxk30LtOKu9z4TSUD5wKUONV/qs38q8sYFwycOPCC3Kx77UKRfdzQ0JyuxKmEThQigPl/UH9EJ5Jcf4o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16533aa1-8f94-441b-1f80-08dd30be0196
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 14:57:58.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6WAy+wISVa2icbz92j3tlWgTZN+xj3SQT3gp0+tKACnLLCbV+nytGnLRELqyhivt2kripxSK82O2pvOek+f8qbA6ur+enowcAskk75mV28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4400
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_06,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501090119
X-Proofpoint-GUID: KVSplP-lFQ5N70p9NGbHf5qJ1ZVZ7IWw
X-Proofpoint-ORIG-GUID: KVSplP-lFQ5N70p9NGbHf5qJ1ZVZ7IWw


Christoph,

> this is my version of Damien's "Fix queue freeze and limit locking
> order". A lot looks very similar, but it was done independently based
> on the previous discussion.

With the minor editorial changes addressed:

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
