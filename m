Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF843FD1A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022068; cv=fail; b=nYHretQqj/OKKEqTrHopscl6X1RztAFE7Ak9Ni2QUZIbiIcJqokWZLZkGC1lhmC5aTuzuSWFG87lug5/rCOwbRVLlPIEKvQPzzjfY+Fbr8Jiq09A863KSPp87cPIvzJu3TdHlP+ZSPuS8Ddebtl83aDS62ksigBm9fQvAsuq1eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022068; c=relaxed/simple;
	bh=4m9MdZ6rbYvK9o2EVGj738qo+liVjbaA0F9rfFstvPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eGfM9kNhkN5vwkFbGVVL+AffWkGsHqx4swrAgR8+ifu5re/EftQBaYJN2NDnbM7OUNJJzgY1vbXoMNJsKe50m0K6RlnA5U9k5dlPdutil0tHMXwze6bnSV6cB+SlH1gWGjPjw+T1J9J1pKjwC0lpVvZIk2Nn6UvCm2VYeCvP5HE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=U134J0/W; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="U134J0/W"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UQru2353891;
	Tue, 14 Jul 2026 02:40:56 -0700
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021110.outbound.protection.outlook.com [52.101.57.110])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fca36ng7b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:40:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQn0cr6G9si3scQJXdXCgR+AyhTwFZHx4DJnR10zcMtfbNSUv9fiYZ9WohgtxWEEgw+ZGvVnYhVlDVJf+G8bUi+CDtzVPh1CBhds8wmgUalBgn1vDQC4BGtgksW4f7NO27YIcuWTXL7bQURV/x95RQIyBXX4T3fjodaw0yJSaY6YWltDkCQkZb3jMHYPpcdY5zx4GKACXUs0XaOgbFxqHDNx7uPghjjd986MTungGHRusON4BSD9/V3FCG0ZcRqV7HBDC4RyyTgr5huAdFZUamyFLySUE95wB5t073pvpFAWCmKuz1WEEpArjdsScvk6RGkuFMHmrjMr/AqtVOC+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEHLs4xKPHFTzHwWpM/HKjiIHXZpsOhl/Ky3NAPG6p4=;
 b=R0V4do4/5nlOuporFrEgSi/k9fIBtlpKUodzoMt/lQTV22DTi6CDL0ZLG1KRsFH1cGEfxLxrNLv3lDMSLFJl0p1qHRmKL+po/nCHR9ZEWQK5DyT+vgw82mDnfHiwY8MpnbZ3wCDqXqsz5FB6jQRh6WYjThxn4jY3XNWU05++S+Zu8eMsbMLeYEKLzGw8VWnp0m8BuPLcBoV3VyYrC7AU2rThj9saoj+AoYghd84F2lxgM47an4WEHVKGiPPqhzS8whRa6CbcaCodf+mlw9qSbYc0ocJuWi9LwpnKQdbBR8m1ujF01JLptH/REn+hLy/pb0x5K9wc/9Nrb+2/LyZFRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEHLs4xKPHFTzHwWpM/HKjiIHXZpsOhl/Ky3NAPG6p4=;
 b=U134J0/WvrmLGtcG5CcJ8T0iUk//zwxTPTziu0XLk4j2rIeow51KVY0nAWrIw8hqD07VGhqzY2VOQ0tMW4v3EHL7iHqnJvBJc91xj2tEZ22db8/QD0L9IPhXF9HO7pcZZCDsnjXKrVfespOpgPRhvk8guSis+pwXyH6mqwdD1Yk=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DS0PR18MB5285.namprd18.prod.outlook.com (2603:10b6:8:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 09:38:38 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%2]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 09:38:38 +0000
From: Nilesh Javali <njavali@marvell.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-FC-Storage-Upstream <GR-FC-Storage-Upstream@marvell.com>,
        Anil Gurumurthy
	<agurumurthy@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        "hare@suse.com" <hare@suse.com>, Nilesh Javali <njavali@marvell.com>
Subject: RE: [EXTERNAL] [PATCH v3 00/88] scsi: qla2xxx: Add QLA29xx series
 adapter support
Thread-Topic: [EXTERNAL] [PATCH v3 00/88] scsi: qla2xxx: Add QLA29xx series
 adapter support
Thread-Index: AQHdDdVCksQo/zDTeUKSzDCoYFtXHrZszHWA
Date: Tue, 14 Jul 2026 09:38:38 +0000
Message-ID:
 <CO6PR18MB4500B32E7A08D2B4957A0F2AAFF92@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|DS0PR18MB5285:EE_
x-ms-office365-filtering-correlation-id: 7895d40e-f9e2-420a-8307-08dee18baec6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|38070700021|11063799006|56012099006|6133799003|3023799007|22082099003|18002099003;
x-microsoft-antispam-message-info:
 1kbzQgc4PRNiF2JJqe5bTs/nV9qFFAZ6ktgOitaNUl4CQbw4UAyby2EKbRM9Xre4zxFA+204xDLjl3+cSWullzB78CVQUVBzY0OYQabXTOax7V+gf7aG+KoDLTER7ndOBS591tXVAEjS8N1YoqZyPS+pqf4AM92w0v36iPVQMnedaFVRIplAi8ynfUOiL/9bqkx3vLU4U2xfvL/KUnDnDxMPi8CtcChVKD/JC8Bnss4aNe2IesI2Wp3ozxfPHbg9IOLN4U3+ZhQYbgszBBm2pno2c0o26JKTCCLs69CQh92ZAPXkqgSV9ffZzWZtm7bGi1JK6XjJIQ/zWfTBkSpWsCMSWFJJwdR4QNVva6n8zSeYFBYPHMLxUqX3Bfr1wrPMTsMhAaDb1JSQEWj5+4gX2UBnOxngFqWv50SA/CP5ZKVB0e7VtAS49BTJV9wBnhA48I4Q/r+FnMgQVCDJQeXu5YiBwSq+5X6sR6EzV0JQnBq7nrCwwvpGE1wuRKzJ1twnpwEJcG90SivBkn1x62Omcv6QqH3Cc4TFbIzjwYbHdFd4IQpcjJxy6zxEvqwDH/iA+oKcYn189xLFLpSzCcmNNbKyZ/tB9ENKIfFzlAuIyNWnQ7Wy+5c2F0JydDlak3GsrXxdh7cwm6JfOBaLto8lzLQ+83HwwKLFnKaC08ctoPnvKma8EHdGf8Vst6cR8mYICAsn22L6g2AAct/hgy1kSGWMQdmEFL+Af83QOtKSlFs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(38070700021)(11063799006)(56012099006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?windows-1256?Q?OnBPMjCW/1SgF4jPK86O/J2bmK1+4sZtXuJP9nzM8H8hH0jg+Vv37O7W?=
 =?windows-1256?Q?yU+5BEYqaArRu3hIYXNw5xiNG46yrA9wZAAibtcP3bUUlnocrDkdLnAf?=
 =?windows-1256?Q?9ofOlNGDcbAH1cvGEjh2US0raIBRqwHmE8Xu8xeYP9ihcPP+i/eiNgMu?=
 =?windows-1256?Q?FuOQAaG8KfIRfnCpDZ4sx0O51I8lPFJd7+VLc3GRoUrn2exxZIqkZeKP?=
 =?windows-1256?Q?DKwAlqkXd6M3niDSfJTIWw8dAeGZOx5ytovKlr0ET24FgRCywNJIOdOf?=
 =?windows-1256?Q?nqJyGVdMTVz80Ki1BJA0Uj9i2uOfCZzp4ArTWNKNyNdQyAfPNasz1vfS?=
 =?windows-1256?Q?fX6mq81qZYc/ehGeZh3vI7xWkKbMfyDVB9K+Ma1GZwOtKqije91K00ho?=
 =?windows-1256?Q?gPO8NBQZ8kshKePFe0KxzIoF793LFSH38eh830Ih3XHcn1g5Tm1rJs6P?=
 =?windows-1256?Q?FKhBEFds59GtDIyZBYgupXBomZV0BJZuIyEREgCtrBhGJtqbIAqtEI8B?=
 =?windows-1256?Q?I+SJ6Xr5N4EtLEupzsY+x4HiBXe6tmpjZLkMdruy9dDibFGFiPqcfMCA?=
 =?windows-1256?Q?Hqor8f75G1R2oeGwPJgpXvdKG5arSjmuAagAXBFL4Q6HOIIVbh8vY3Dm?=
 =?windows-1256?Q?pGg/7uAFtme4SAP6EIALX6VDyq50We7UCymbNM+JrAY0TTwSVTg1y4Lc?=
 =?windows-1256?Q?ra0oi6SWkgAJ8m6lSKIhL2O3OY1ZeYkyM3WoVD0GzsMMiMFfx3PkCRzj?=
 =?windows-1256?Q?qLcVNnTCXGTk6ctKtOT42QJhyBVNF3Q+6qbTAoUnOemopYlOuywjBYST?=
 =?windows-1256?Q?5icbnF108uo9Wd2/FtQsIEahxNpoNdc/BZbVP1ShchtQAV16GzHDJZOt?=
 =?windows-1256?Q?ZKz08Hv8MGhCcd1fjn+cvMloJTyIqoJUuVVmGSnrdMKebuzzdVlwgEcJ?=
 =?windows-1256?Q?u0P3ic4PQ+DSG7llkmNEs3rt3ezjeaC0BdRYUHoaV8VxRAKeWQqQy8xt?=
 =?windows-1256?Q?0reEGBEYTdt8kjawhixeCaCijOeoIF9aYnEE62QveY9/0ro1MR54Ihch?=
 =?windows-1256?Q?U9NpH3hxkbTCGcoSTFyN2Opkf2O0XQkv0FdS+7anGrgY2G9X8uzI1Zol?=
 =?windows-1256?Q?EtkA+VCmmHqhRnH6kUMbG68O4GsnrVBqex8l/RdY+OVAS3TUV0wvR3TG?=
 =?windows-1256?Q?UFERyTGlANr5okDOmwfQtSs0OPCv9xVGnudxT0Ycl2RgbSSkG+2QSGSf?=
 =?windows-1256?Q?avMGUZ8ntOJyqrEZr8Q5Vlej2LTsmDA5PyXcJTQv/C6f6XeiaLSoS5xz?=
 =?windows-1256?Q?PGEpimGA3DfKpFURiLee42sma5CrnKfcOJtw/2kW36LeIkoRF9/uSfhQ?=
 =?windows-1256?Q?upq9NVWygIjKWW/uWnyd8eGoEdXy6+TRq/5OmHAw6Lun/3InExjQbmjI?=
 =?windows-1256?Q?wyiODO0ig0ZX0TInsJpkI+LB3YmVCYzcYhMaBodKKe1rt84m0x1WC5Ny?=
 =?windows-1256?Q?amst8z26PD0ipauCdir0HjHuxLXdn8TPijy6BmshOJ6hwrHxfiGyvuMs?=
 =?windows-1256?Q?dzMcFsvPWHhYJ4EuXGRtlofYfCy3t08OiGnrR8bKgpvz0P17Emx3OQyE?=
 =?windows-1256?Q?dWqiNb02CcExxhYHJ/K9j3383j77qJ4EqdyefuIBRb/eKPP4EsLOAC3T?=
 =?windows-1256?Q?1bih5MTQMBTiLl68ZtrK1LBLiJceHfaSyvrevC4IWzrLWXY7uIxUjEgv?=
 =?windows-1256?Q?bHWL52UbZ/srk00M4pkBXTyv/hz9DHaubgmZP2rHN2csJ3dPEdjHNAhU?=
 =?windows-1256?Q?5TsvQVXC3x+RA8vySZ+KgsJNBsbe5vBeSXjo3uRx/zXCBiaZ?=
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	RPYlCR4tJ4FOoYIleQOrObIWQIkIiIVCwE1Cyx7OI2HNvg3KFqNqGJaGay+d8d97O+mSRUzSYtoGC6cO3F9t6nxD8CBhu103mK98hwa9BqNN/C/9gU5IQeRVtLqgbrOWfJUr3R/q1zNOkgzD1DMtkWh8v91G/KQw85J/CHQ72jPUPueDukR2KI6FNaRRSpPQksAEJZ7FfjI8PoVkr2sxGv+shyQTqXKFbgWw2t3LISQxzqawMgzib8U27MKkVaIdl0JzbmML7b8//mtIzX5dkh5Sfu/dHI9p/6xtrZrwiGqiCD1JRWIoEbG7u3zog82SxYMWmXI5gK7eoXAC9Dhn+Q==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7895d40e-f9e2-420a-8307-08dee18baec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 09:38:38.1833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M+unylfWTrqqdvSy2hP7bDiNaReuiAE0QRT34D4ZquW1FQNXJt5i9sW7Ww9MhUkQcg6PaGrBvnJeU+vJ1YLkSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5285
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMCBTYWx0ZWRfXzVrjcfhIBAxm
 dOI8W7BoFq/EaEQSTwQYw9N0nsCepVtiZQVACrcNBMmK/0+IFSk3wXGfr6V46Qr5Eo8eXc9KphE
 6PVPN/WtzqUsfw6V2KSwTx1JSeygUNucqjryq/V9YnePoOoAqXsaMksXJ/lrwkDqeyKBg6xKPYP
 q7OxUFcGoMCynUmeu9GBq6U75mZq/5hVMj3YVnwefgokwcjhvJfnFSxJ/M+RzHoMd7+OfuzFJLN
 CK4r9DmyMGTVwuYDBKJF1ylFmx6GbvyhvpUomVnKxQaOQkJaeOEamJEprjBujxCbfArflLmMWz+
 981yvuRXehsoI7k7GxXIpL6fLC6UVfMR5JS84N9QkUCQkQTXlQqpx0mPSFZ70A6RlOejYCoGGIl
 I55t5WvytjZ90neLllPNF4D4owgblTVlKGsUqz3psK5KZewzgthXWEMGWGLFIDBhD2UdcXRn2i7
 vR+voPuP2fF5P5yKkrA==
X-Authority-Analysis: v=2.4 cv=EeT4hvmC c=1 sm=1 tr=0 ts=6a560428 cx=c_pps
 a=Lukco47usUvZlN+GeMSXkA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=eoNxP8pz9j0A:10
 a=RAioF0-LDSMA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=RpNjiQI2AAAA:8
 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=iox4zFpeAAAA:8 a=47vXwzMeKN9WKHGH0-UA:9 a=lqcHg5cX4UMA:10 a=PRpDppDLrCsA:10
 a=RFXaeJp-pwgA:10 a=OBjm3rFKGHvpk9ecZwUJ:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMCBTYWx0ZWRfX8mWAw6Le1XAq
 HOvNBAjvE8albd3AUKBNNX9XadPMLxwZCZsXjzDJ7ilJAD5mSgMukiXFiOozxc8TeRyEcpjhlXn
 vd5h40XgtpvQCNGWRcSPYn9g5uPs0XY=
X-Proofpoint-ORIG-GUID: jl7sL_66QedCVJbLTPeo6Gpdaw-o3QsD
X-Proofpoint-GUID: 9-DvxYOsooRIhXVAzTmrh_E2RCD1c8si
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Hi Martin,

I have incorporated a few additional review comments suggested by
Sashiko into the v3 patchset, and these changes will be included in
the upcoming v4 patchset.

As part of the v4 submission, I also plan to split the current set of 88
patches into multiple patch series to make the review process more
manageable. The first series will contain 56 patches focused on QLA29xx
support. These patches have already been reviewed and carry the
appropriate Reviewed-by tags, so they should be straightforward to
merge into the SCSI tree. This will be followed by smaller patch series
that address pre-existing issues in the qla2xxx driver.
I hope this approach works for you.

Thanks,
Nilesh

From: Nilesh Javali <njavali@marvell.com>=20
Sent: Tuesday, July 7, 2026 11:23 AM
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org; GR-FC-Storage-Upstream <GR-FC-Storage-Upstr=
eam@marvell.com>; Anil Gurumurthy <agurumurthy@marvell.com>; emilne@redhat.=
com; jmeneghi@redhat.com; hare@suse.com
Subject: [EXTERNAL] [PATCH v3 00/88] scsi: qla2xxx: Add QLA29xx series adap=
ter support

Add support for the QLA29xx generation of Marvell QLogic Fibre Channel HBAs=
 (ISP2091/ISP2291/ISP2099/ISP2299). The 29xx family shares much of its arch=
itecture with the existing 27xx/28xx adapters but introduces 128-byte reque=
st and response
ZjQcmQRYFpfptBannerStart
Prioritize security for external emails:=20
Confirm sender and content safety before clicking links or opening attachme=
nts=20
=A0=A0https://us-phishalarm-ewt.proofpoint.com/EWT/v1/CRVmXkqW!te3Z1f8UYnU6=
9O-8GX3aDvYr696GUuq6tjvQPe5gG3BNv-ylN5iMkituQ_5Q1NEn7f43GZ-gHHeyslujdR_1Gpu=
17DqDCwUPHZ0$=A0=A0=9D=20


ZjQcmQRYFpfptBannerEnd
Add support for the QLA29xx generation of Marvell QLogic
Fibre Channel HBAs (ISP2091/ISP2291/ISP2099/ISP2299).
The 29xx family shares much of its architecture with the
existing 27xx/28xx adapters but introduces 128-byte request
and response ring entries (up from 64 bytes), requiring
extended IOCB definitions and updated ring management
throughout the driver.

The key hardware change is the wider IOCB format: every
request and response queue entry is now 128 bytes.
This propagates into every code path that builds, submits,
or processes IOCBs -- command submission, status completion,
marker, CT pass-through, ELS, logio, task management,
abort, ABTS, VP control, and NVMe.

The series is organised as follows:

Patches 01-08: Foundation and flash/firmware infrastructure
  PCI device ID registration, ISP-flags wiring, flash read/write
  interface, NVRAM configuration, queue initialisation, FC operational
  firmware load, removal of a redundant VPD flash read in the sysfs
  read path, and BSG passthrough (flash block I/O, MPI firmware
  load/dump).

Patches 09-11: 128-byte IOCB infrastructure
  New qla_fw29.h header with extended structure definitions, status
  continuation and marker IOCBs, and IO-path updates that select the
  correct IOCB size via the entry-size helpers.

Patches 12-24: Sysfs, mailbox commands, and core enablement
  Sysfs attribute gating for unsupported 29xx features, mailbox command
  enablement (get_fw_version, execute_fw, get_adapter_id,
  init_firmware, get_firmware_state, serdes, ELS, echo_test,
  data rate), shutdown path, ring-slot helpers, and memory allocation
  updates.

Patches 25-39: Response-path IOCB handling and final wiring
  Status continuation, status entry, CT pass-through, PUREX, ELS,
  logio, task management, abort, ABTS, VP control/config/report-ID,
  LS4 pass-through, and BSG feature gating adjustments.

Patches 40-55: bug fixes uncovered during review of the earlier
  postings -- queue teardown NULL dma_free and bitmap locking,
  endianness/bitfield cleanups, 64-bit FPM word counters, 64G/128G
  port speed setting and reporting, an edif NULL deref, Name Server
  logout detection on FWI2 adapters, VP index bounds, NVMe abort and
  LS-reject locking, a dport diagnostics info leak, a BSG job leak,
  and an unbounded FRU image count.

Patches 56-87: additional robustness and bug fixes found during
  continued review -- MSI-X derived queue-count clamping, firmware
  dump data-capture improvement, flash-version read serialisation,
  use-after-free fixes (qpair work on teardown, cs84xx on host
  teardown, FCE trace during firmware dump), firmware-state and
  mailbox hygiene, FCE trace enable parsing, QLAFX00 ring-slot init,
  error-path pointer clearing, response-queue over-consumption,
  soft-lockup polling and OOB sense-data guards, response-IRQ
  quiescing and completion-path SRB validation, NPIV vport count
  clamping and report-ID-acquisition locking/refcount fixes, NVMe
  abort/LS-reject/unsolicited-context correctness and locking, a
  coherent DMA buffer for D_Port diagnostics, and BSG passthrough
  hardening (zero-initialised stack buffers, request_len validation,
  SFP DMA zeroing, and I2C length bounds).

Patch 88: bump the driver version to 12.00.00.2607b1.

The series applies on top of the scsi tree's 7.1/scsi-queue branch.

Changes in v3:
  - Folded several standalone helper and refactor commits into the
    feature commits they support, so every 29xx enablement commit is
    self-contained and bisectable: the entry-size helper conversion,
    the marker IOCB refactor, the NVMe IOCB build-path unification,
    the NVMe ring-advance conversion, and the duplicate flash-memo
    block removal are no longer separate patches.
  - Reworked flash-version handling: dropped the standalone
    get_flash_version patch in favour of removing the redundant VPD
    flash read in the sysfs read path.
  - Added a large batch of additional robustness and bug fixes
    uncovered during continued review (patches 56-87), covering the
    completion/response path, NPIV and report-ID acquisition, NVMe
    unsolicited-context handling, and BSG passthrough hardening.
  - Bumped the driver version to 12.00.00.2607b1.
  - Added Reviewed-by: Hannes Reinecke <mailto:hare@kernel.org> to the
    reviewed 29xx enablement patches (patches 01-55).

Changes in v2:
  - Folded the standalone fix-ups posted in v1 into the feature commits
    they corrected, so the 29xx enablement commits are now individually
    correct and bisectable (no "fix the previous patch" commits in the
    middle of the series).
  - Corrected several Fixes: tags to reference the actual introducing
    commits after the above reorganisation.
  - Widened the ELS vp_index path to 16 bits to match the 29xx 9-bit
    hardware field, folded into the ELS enablement commit.

Thanks,
Nilesh

Anil Gurumurthy (3):
  scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx
  scsi: qla2xxx: Add extended status continuation and marker IOCBs
  scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

Manish Rangankar (10):
  scsi: qla2xxx: Add 29xx series PCI device ID support
  scsi: qla2xxx: Add flash read/write interface for 29xx
  scsi: qla2xxx: Add NVRAM config support for 29xx adapters
  scsi: qla2xxx: Add 29xx support in queue initialisation path
  scsi: qla2xxx: Add FC operational firmware load for 29xx
  scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
  scsi: qla2xxx: Add flash block read/write BSG support for 29xx
  scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx
  scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
  scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Nilesh Javali (74):
  scsi: qla2xxx: Skip image-set-valid attribute for 29xx
  scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
  scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
  scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
  scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
  scsi: qla2xxx: Enable init_firmware mailbox for 29xx
  scsi: qla2xxx: Enable get_firmware_state for 29xx
  scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
  scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
  scsi: qla2xxx: Add support for QLA29XX in data rate functions
  scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
  scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
  scsi: qla2xxx: Add support for QLA29XX in memory allocation
  scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters
  scsi: qla2xxx: Update handling of status entries for 29xx series
  scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx series
  scsi: qla2xxx: Enhance purex_entry handling for 29xx series
  scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series
  scsi: qla2xxx: Add size check for ELS status entry layout on 29xx
  scsi: qla2xxx: Add 29xx extended logio IOCB support
  scsi: qla2xxx: Enhance task management IOCB handling for 29xx series
  scsi: qla2xxx: Add abort command handling for 29xx series
  scsi: qla2xxx: Enhance ABTS processing for 29xx series
  scsi: qla2xxx: Update VP control IOCB handling for 29xx series
  scsi: qla2xxx: Add build-time size check for VP config IOCB layout
  scsi: qla2xxx: Add size check for extended VP report ID entry
  scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
  scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors
  scsi: qla2xxx: Fix endianness annotations in vp_rpt_id_entry
    structures
  scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
  scsi: qla2xxx: Add 64G/128G port speed setting support
  scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
  scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
  scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
  scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
  scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
  scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
  scsi: qla2xxx: Initialize NVMe abort_work once at submission
  scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject
  scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
  scsi: qla2xxx: Fix BSG job leak on validate flash image error path
  scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
  scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation
  scsi: qla2xxx: Serialize flash version read in reset handler
  scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
  scsi: qla2xxx: Clarify MPI optrom address/length units
  scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
  scsi: qla2xxx: Don't query firmware state while chip is down
  scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
  scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
  scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump
  scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot
  scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error
    path
  scsi: qla2xxx: Fix response queue over-consumption in
    __qla_consume_iocb()
  scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature
  scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
  scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
  scsi: qla2xxx: Quiesce response IRQ before freeing request queue
  scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
  scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
  scsi: qla2xxx: Avoid double completion in async IOCB timeout
  scsi: qla2xxx: Skip vport under deletion in report ID acquisition
  scsi: qla2xxx: Drop vport reference under lock in report ID
    acquisition
  scsi: qla2xxx: Hold vport_slock for host map update in report ID
    acquisition
  scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
  scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started
  scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error
  scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock
  scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
  scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
  scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
  scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
  scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
  scsi: qla2xxx: Update version to 12.00.00.2607b1

Quinn Tran (1):
  scsi: qla2xxx: Improve firmware dump data capture

 drivers/scsi/qla2xxx/qla_attr.c    |   63 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  608 +++++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h     |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   37 +-
 drivers/scsi/qla2xxx/qla_def.h     |  145 +++-
 drivers/scsi/qla2xxx/qla_dfs.c     |    8 +-
 drivers/scsi/qla2xxx/qla_edif.c    |  101 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |  144 ++-
 drivers/scsi/qla2xxx/qla_fw29.h    |  830 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h     |   40 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  176 +++-
 drivers/scsi/qla2xxx/qla_init.c    |  919 +++++++++++++++++---
 drivers/scsi/qla2xxx/qla_inline.h  |  295 ++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 1303 ++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  755 ++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c     |  499 ++++++++---
 drivers/scsi/qla2xxx/qla_mid.c     |   78 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  315 +++++--
 drivers/scsi/qla2xxx/qla_nvme.h    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |  310 +++++--
 drivers/scsi/qla2xxx/qla_sup.c     |  784 ++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c  |   34 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |   48 +-
 drivers/scsi/qla2xxx/qla_version.h |   10 +-
 25 files changed, 6388 insertions(+), 1154 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h


base-commit: 1801c8284d34d7927f1a158226e427c195936746
prerequisite-patch-id: 9cdf671a5c422facf4cee5626701f9135d076122
prerequisite-patch-id: 807b23211a696e9f032ae85b037aafeb08501768
prerequisite-patch-id: 1145e5762d000b371299b981054a7baabbbede6e
prerequisite-patch-id: ad6f2e8fdf93cc1341470516aee8ccdee0d99cfb
prerequisite-patch-id: 6df17c866b242df13f50eba6cd81f26d4dc0656c
prerequisite-patch-id: 05d09642756af9c90cd8568d63496c676ace66f0
prerequisite-patch-id: 85252984f56a31690f027b735594caf003738e27
prerequisite-patch-id: 86b571d585d2dd9f783220df2bb1baeab0c7dc2b
prerequisite-patch-id: 44f65619d39d4e5f1dd56a898ee6156238a6b3b7
prerequisite-patch-id: 412cfca3d3695325b90a70a56f998e26d34cf5bd
prerequisite-patch-id: 368f0039bdb590ec70f83327ed6c82028342367f
prerequisite-patch-id: 0af9e8e1b40955fb0f513f973db167ff469dd45f
--=20
2.47.3


