Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013061.outbound.protection.outlook.com [52.101.72.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8673F2135D0
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743077134; cv=fail; b=rigl96obYXkH/vUVFiRZUWAEfinekPPKt8lUxGTVJqcck7WERcb+ruj8Wx3Ido/WSFMB000nRDNBo0+GJT+tKAlKAi+bIvG8O4nCeokks1r+tNA8nNwDVNfkH4o3bYnsLzxuyP9gzb0SA0Y7VFoY2FJO2otyWvUVINLovMQqDAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743077134; c=relaxed/simple;
	bh=bxBZXeqJmAFTkpsRq2HmovfAHCP+FbLKMu0W3fDB8lw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BBvQWryys1b1cM/qp0NvidQWxJ5wMKAAufnkrPhkWsRQvPEWKipcUJy4SHHmi4FqGnmiLoho8vE7oKdEmJxzar+dRF10mNHrKqXT2HMgx6Kt4/t1rC7IpCrW15TEuCXRtuOE70o0IbwRRjNsYtA5JrOvI9NyADhOUlkw0uJSjwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com; spf=pass smtp.mailfrom=in.bosch.com; dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b=fBwk1iDY; arc=fail smtp.client-ip=52.101.72.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b="fBwk1iDY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxFxwug14rtOPgK1HvwOdODUKg3ChLBW6iYUqDwH2lCG00lO9IyuOpt+L8br42trZpuD9TqElOZu0gi8RZeX3u9yURuqMX0kbdJ2r2R21WAF0CDDd75zcZBxNrIa6yfvUlQJOX4cvJGCrT2HPYD0nwKd2anA703r458a5+MgOY/wyofFqQIDubL4Gdf1gFvmxoSEZ2MMeyilUj9Pa3OFQmz3Cv+X8EFrVN+l7iwR+G5V8bmY90xh6MRIs0PEL7E+2amGqB81h2MYJ3HegZk6KGeivRK68RblYZABJ5WRp0C4If8drcPQwpzYUKkRWLebtyFgpnVgUhox5tVaCusyvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxBZXeqJmAFTkpsRq2HmovfAHCP+FbLKMu0W3fDB8lw=;
 b=DWol0Nee1dOWxu3X6j9mJpEAcOiFnhzkCoLqXSi00+3/LWYd2wQDVc+2FmD6qzW6I1LRoRsfPuy0+tecqLkoBMkouuTkEagIDh1NhOOGnmQMH8BX3WQG0ye8h/nhIhlP7PtqOhJrgw94MpoAADtGBD/k2Aes8Hm0hm1JVKo1b9ymcKZWCGUfLNTEWjoXSq/XJe5yHuKbVSYoIrdbM1pfoYDZT+MIxPl0nviUJcCo9SOd+oESQPTdbmyiQqrr05klbiUSnY9ZYZALAAj9TlZE2XT3tk2pwexL/TEoExnwCkbwGm4VwLxzw3BMi10O8eC5pdYhCnLnSSEp8EPGLZeC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in.bosch.com; dmarc=pass action=none header.from=in.bosch.com;
 dkim=pass header.d=in.bosch.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=in.bosch.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxBZXeqJmAFTkpsRq2HmovfAHCP+FbLKMu0W3fDB8lw=;
 b=fBwk1iDYIKT/gKpVdhznHqzmcmVT6q8DqDQs0rHHCufhP4tUGhkNLZE3LJVdRj9aGvP9ocG896QKu9JGlBcVeZt3YMtXjg69C615NgyjuwouzOxHLFVbekHpae8vfXAejui8ccXOFnAHAVWYZ2xC1rZV/4MuZz/n/433PznVrpz5A7bJ3pfLN3MMCN+c+4CVlhvW7cjCmLqcACilX2PQUi/UeqogEFtKY/dQpJ9PwIkulVMJPCDBuWB17GGBdqOEZAiQHxUz1igqqhZnoggSCEQ/chkWpY+yqTRIgIkR0qK2vD/Wj3WKGHbpbM9pWchaZf184zEO7d9RL9xDTD8Zsw==
Received: from VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:16a::10)
 by GVXPR10MB6323.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:16::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Thu, 27 Mar
 2025 12:05:27 +0000
Received: from VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::67b6:6edb:8a95:c33b]) by VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::67b6:6edb:8a95:c33b%7]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 12:05:27 +0000
From: "Selvakumar Kalimuthu (MS/ECC-CF3-XC)"
	<selvakumar.kalimuthu@in.bosch.com>
To: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>,
	Manjunatha Madana <quic_c_mamanj@quicinc.com>
CC: "Antony A (MS/ECC-CF-EP2-XC)" <Antony.Ambrose@in.bosch.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Topic: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Index: AQHbnw3tp8bUIs282ke9V8AWlRtforOG4MIAgAAAnQA=
Date: Thu, 27 Mar 2025 12:05:26 +0000
Message-ID:
 <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
 <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
 <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
In-Reply-To: <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in.bosch.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR10MB3936:EE_|GVXPR10MB6323:EE_
x-ms-office365-filtering-correlation-id: 79b789c1-c7fe-4fe8-491d-08dd6d27a965
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MFYramFlZ0dXNUhWQXBMNS9xc1V1VzFFNjlHaFhLV2JpOEFUR001QVdjb092?=
 =?utf-8?B?SXhubnFsTm1VMHdBZHU3VURBRnA1aFQzcDAralVXYzBwbTVhWDUwTXNKNFFZ?=
 =?utf-8?B?dG1WMzQ3ZlNJYlJIZUVmSDZJYjRLcFhpUWNpWGtGVE5oL1pyQjZaTDNyZ255?=
 =?utf-8?B?c3dGaXBLVnBIaUJ6Z1VIa1BlWHdubHBCNk94VE5QVkFhd1pkUFJmaGFwaHl2?=
 =?utf-8?B?NWNUbUFYQkNKd3pVaEJCWU1DWEtCSXlPbzJRa08rbXhDWEYzTkw1KzB5V2tw?=
 =?utf-8?B?T3B0U09SK1ZtdmExTUNzb3hsSmZwdVZhNldOV2p3dzdlRWpBNTUxSWV5Zk9O?=
 =?utf-8?B?VFRoV3lpa090dGxCWW9mRVBZWnNnNzRSK0x4d3JScVAzRkc4eEFQbXhBQzZN?=
 =?utf-8?B?WEZvM0lnMFNVNDZPbE1MSnQzK3g1aVIzbTkydW5NMzF5VzVzbjNQM0Y3YUNN?=
 =?utf-8?B?Vi9Ib0hqYUVQMlhBNHBjOXBlODNES1ZEaHdEV0o1VDA3OHF1K3B0dndZemtH?=
 =?utf-8?B?aS92QmlPZDRIdndJbUVrNGJwMk5KM3BzdHBLaVpxbytHb1lwSkZvSG5XdjVz?=
 =?utf-8?B?U3BEeEpkRzBja09OQjh3MVNTR2xObzZtZDRaV051T1J6aHdCTWovS1NVdDVr?=
 =?utf-8?B?NjhYUnZhWEVxUVlYakNDYWxSVExuSzA0ZndXTFdIT0dmdzBNT2tDVC9Jdklu?=
 =?utf-8?B?NFMrR0xsYU1sNkZtT1ptV0NmblI3SXNFbjF5MzNIV3M4TStxdDBKbjRmQkFh?=
 =?utf-8?B?c0gyWkszOHZMdmVZenZaL2tBRG5wbytVTmgveEpGaWpPaklyT1FBamlRaWF0?=
 =?utf-8?B?bmVMeFJUWEZhaDZobFdyK2xxc0lCWHh3Z1NSOGM0RUplU0lCNXhsUS93dmF3?=
 =?utf-8?B?RUF4a3BuUFN1eDV0VkxVQjdxUE91VzlXTkorZUVRLy9xNTNkV3Z5SHUySXN1?=
 =?utf-8?B?UVFxdUR1S2o3d2syOUphS3BqcElKTGFjTUlGNHJZZENJOXZKbWxsNmlXT3Vm?=
 =?utf-8?B?cmFTV21Fc3BZTEJDbEtZU0FSc2k2RXFET1g1a2hSaS9CVld3dkFmK1E1dlZV?=
 =?utf-8?B?N1dvb1NOZXNxNzN5MkVKVmk5TFpBclkrc3N6Z3RUTEwrazl5R2FzK2w4anp4?=
 =?utf-8?B?L3pUcWhZWFpqMEVKMnB1V1pKOGJlQVo0T2FGdUQ1SUN0RHV6dmV6MktaRnow?=
 =?utf-8?B?dndHTEErNGhqbUpKZHRha05qK2FOUGNxUHNIK3p0Zk1NVXd1Vk1GMzRvU1Zy?=
 =?utf-8?B?eFJhazhPNnhTU0xZRGpJRWRaQlVUYXU3eEtCeWFsN0MzWVJPdnlTeWl1WmJu?=
 =?utf-8?B?NmNIT09mMWJsV2s4dXB1akVqVWwvSzc2WEhncEdqNjBGWFZGbllPbHk4Slkx?=
 =?utf-8?B?cXJIaUppekRucGZWdGc0U2srK2VBSU96NExicVdGcXdrTGZXV2xlRGlOZVFO?=
 =?utf-8?B?bk81WFFrYk9ieEhIZVdiazBwQ1NTam02UjdHMnlZMkJUZ3VsM3V0SnFsYXBz?=
 =?utf-8?B?L0NlbHRzSHA1cTZDd1EzMEUxT0lTLys3RU8vS1F1Uk56Q1FDMmh3blVGTmZ4?=
 =?utf-8?B?cnRzekZScXhWSTZYdktLdU9HNGd2dXBQT2ZoY3lMSkx0Nm5aZEU5Qmh0Smln?=
 =?utf-8?B?MHhsSUF6dnhhcU1iK0VVMnBGbUdLQlZTOWlDamdobEhKd1orbEc5MThNK1Vl?=
 =?utf-8?B?Nmc2TXp3b0Ivd1NZTmNUcy96ODhIRnNPR2R1KzF1aHRDNWgxWE5HODNrR0hx?=
 =?utf-8?B?MlRZamV0bVpqS3FmTC90L1lESVYwbVdTcFNJK3VMUWtvbis3YXN2RHJpUmtw?=
 =?utf-8?B?TWFSVkNLL0Q0WDVvOTJ1Z25LZmVBZXRWODdEL2VMdVh0ekt2eHl4ZnhIVVRj?=
 =?utf-8?B?Y0NISy9lZmhFcDFZMUZvd3NIWS81WGc1aEt0QWR2TjZNTXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M3FBL3pKamNyNWxDZmJvOFMveDRjYzI4MXZGMnNXeDEwQVpva2pIcmIvRGo0?=
 =?utf-8?B?MEk5M0VjamQ2T3JneDViL3RBWkpKeXI3M0xqcS9sRWN6NTU0VWRHcWZvQnh2?=
 =?utf-8?B?bERzREJLQXM3TTVyNVM1NTRla1R2TG15cnhoeTY5Tllld3I3T0tReW1DR3Rj?=
 =?utf-8?B?VjMxNFpSMllkWEYyVXk4czlKR3RidE9CUG1SU3E1TFVlTG1qRFhsLzBrRHk4?=
 =?utf-8?B?eG1YVGZjNmhuanNjcnRUaFZRcnFDbUtlZlQ2cEFDQWtFTzNRRWxleGM3eHow?=
 =?utf-8?B?eHN4blRtUFlPMFVmUGh5ejN2MEtFU3dYc0hhTDhJaDZGcEVSN09WQVZjZEhw?=
 =?utf-8?B?b1VVaThGZlVWVmhhcVZtWjllWFQ3akxFZDVFR3RZQlpGdEQrOFQwSkwwTTlt?=
 =?utf-8?B?SzhJUzM0TVZRSHdMVXhFY3RQcU92bVFkbnNFTzduQnJRaFh1QWxQOUtjdkpw?=
 =?utf-8?B?MlJoalY3VlR5bGJBYnRyRzl4dk1nb0lIOTNPNEdCaEN1bHVaM0F1bG0yVytt?=
 =?utf-8?B?Nkk1bUtUNFJoekhyQjRrb2NvUTJubktJNXYwTCszd0lKdXF4MEkzUE1ZSGF1?=
 =?utf-8?B?TjYrZ2lnTEJxOTR2SmFKVUlWZzZXaVpjRGRNWkkrMDBpNlJHVFVoNldtSW11?=
 =?utf-8?B?ZzJVbE1tazRia2VoNThVeldVaE83TE5EeDkydUNiNGM0WGI5REVPc29yUHFZ?=
 =?utf-8?B?SlRwS1F4OThtVjdYVmZzYXZPTnBsYnhSMmpJL0M0SG5mNUkvV2V3ejJKellj?=
 =?utf-8?B?UXBWdVZUNlY4Vmh2cmFwTjZkME03bnNPWDdqU2czVm81czV4aHMrRk9xQXVm?=
 =?utf-8?B?SmRuMkR1Mnkxd0ZTZjhZeGE3YkQyOEVhZGM4bmpTSUZBM2ZnY25xZGQ3ejFi?=
 =?utf-8?B?NEZMd0ZMR2J0Mmtya3ZHdlQ0eGNTbEgyLzQyOHVJUkxyZzE0M0NBSGgvK3dG?=
 =?utf-8?B?ejVrbit1TXN5eTZsMmwyeDhhcHNqdVhINzg4QzZUeFlyUitDRWFGSEw1RTRG?=
 =?utf-8?B?Q0M1SkorYU9sUUtsRFZxSFlmcjhndlhLejV2Mm0xQUZpV1RqdGRDM1VKTU9v?=
 =?utf-8?B?VVhOVThneWxWUkQ3TDhQNUJqUFlHdWtUdXhMYWpGb2d1WlNDMFRzZ3pmWDhU?=
 =?utf-8?B?N1BMOW1hLzY0ODJNY2tZdElCRWZ3SkkyWS9LdDZlV3lWSnFVY3BscnlXNEtG?=
 =?utf-8?B?VFQybEVxRXNoNm11U3dHZDhSMVEycXlzMVA3UFFoMVl3K2Vmb21TU3VaOS9E?=
 =?utf-8?B?TTdvZHdhRWFNcUFlaTBUcW0vZkpod2VLdjI0OUFqKzhTb2xkd2x3MGRaU2sr?=
 =?utf-8?B?bXpjWFpIRzJVRzRMV0pYc2dyUml6ZGFWSHlTZndtWVltNTV5RXpuL1ZCcDFj?=
 =?utf-8?B?cUlxUEtneU4wY1VRKzhGOHZpOFZqWGxBRmVYU2hxTzZ3SGNRSnE0OFdzSzIv?=
 =?utf-8?B?aXUvOFZtUk9uQTd4UUZJVThkQ1doVlBrSVZ0WkpSSldLTllqS1o3bUlSaHlR?=
 =?utf-8?B?VlBzUUhzY2tWSC9NT1RsMHMyQ0NxNXJ0cjl5dWlqQkZKeFl6WDlVdlhRZGNw?=
 =?utf-8?B?cUg5UWY0RWVZS1I2bUVTbXcxK3U0a1NsekhvK3hSUndHR1hHVURKVnY0SnBL?=
 =?utf-8?B?UWF0UG9CREIrb2JuTDd1VDBEcmtmUGZTZkFDSjBVdTl2dHlXV2xRajJEaW5k?=
 =?utf-8?B?SXV0YWE2bk1IZ0xHTURQLzA3K2JTTXI3eU96aC9aeWszZjY1MVZRZVZzSm1H?=
 =?utf-8?B?aXZKNVFyc3FZLzIrL29MOG9rcStPRjNIRGJWRTRzM2d3TWF4YStNMEdIb2h5?=
 =?utf-8?B?dVhISmU3UTZyUFJlRDU4cEhDZmlKOEZoMWJkeEZoYzMwQWlMSnNWMFZvUUJB?=
 =?utf-8?B?dy9ab2tsaXpIMjNUSndZSE8wWnlWcFBaano3Q015bkttVklob2dlRFdicU9J?=
 =?utf-8?B?VUxyUXQ1UUxUQUlpbDBuYVhPRS9DM05jRjlUM2xmZlp3ZVJTSEh4Sll5UU1V?=
 =?utf-8?B?aU8xRWtMdEE3dXJldHUwRW5qVFdzSzY2Q0RHM2xPMitjY0s4YXVza3N5eldq?=
 =?utf-8?B?TDFkMkhHVHQvZFo1c0lFMzdPRkU4ZHNKM2lQd2lhNVNtM2tZVFBJSHFWaDdh?=
 =?utf-8?Q?o3R0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: in.bosch.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b789c1-c7fe-4fe8-491d-08dd6d27a965
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2025 12:05:26.9332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0ae51e19-07c8-4e4b-bb6d-648ee58410f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8FBq1gr3YaHHMbzaDY1oCdJgpxUX505oSZI7Q70xNhrA26/yPVSOrU/AvoWFu6/oZTLr9lnUCNrxYKB/GaE8yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR10MB6323

SGkgQmFydCwNCg0KVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLiANCg0KVGhlIGNhbGxlciBmb3Ig
dGhpcyBleHBvcnRlZCBmdW5jdGlvbiByZXNpZGVzIGluIGFuIE9FTS92ZW5kb3Itc3BlY2lmaWMg
bW9kdWxlLCB3aGljaCBpcyBub3QgcGFydCBvZiB0aGUgc3RhbmRhcmQgTGludXgga2VybmVsLiBU
aGUgaW50ZW50IG9mIHRoaXMgcGF0Y2ggaXMgdG8gcHJvdmlkZSBhbiBpbnRlcmZhY2UgdGhhdCBh
bGxvd3MgdmVuZG9ycyB0byBzZW5kIHJhdyBVUElVIGNvbW1hbmRzIGZyb20gdGhlaXIgZXh0ZXJu
YWwgbW9kdWxlcyB0byByZXRyaWV2ZSBkZXZpY2Utc3BlY2lmaWMgaW5mb3JtYXRpb24gb3IgZXhl
Y3V0ZSBwcm9wcmlldGFyeSBjb21tYW5kcy4gU2luY2UgdmVuZG9yIG1vZHVsZXMgY2Fubm90IG1v
ZGlmeSB0aGUgVUZTIGNvcmUgZHJpdmVyIGRpcmVjdGx5LCBleHBvcnRpbmcgdWZzaGNkX2V4ZWNf
cmF3X3VwaXVfY21kIGlzIG5lY2Vzc2FyeSB0byBlbmFibGUgY29udHJvbGxlZCBhY2Nlc3Mgd2l0
aG91dCBtb2RpZnlpbmcgdGhlIG1haW5saW5lIGtlcm5lbCBmdXJ0aGVyLg0KDQpXb3VsZCB5b3Ug
cHJlZmVyIHRoYXQgd2UgYWxzbyBwcm92aWRlIGFuIGV4YW1wbGUgb2YgYSB2ZW5kb3IgbW9kdWxl
IHVzaW5nIHRoaXMgZXhwb3J0LCBldmVuIHRob3VnaCBpdCB3b27igJl0IGJlIHBhcnQgb2YgdGhl
IHVwc3RyZWFtIGtlcm5lbD8gT3IgaXMgdGhlcmUgYSBwcmVmZXJyZWQgYXBwcm9hY2ggdG8gZW5h
YmxlIHZlbmRvci1zcGVjaWZpYyBleHRlbnNpb25zIHdpdGhvdXQgbW9kaWZ5aW5nIHRoZSBzdGFu
ZGFyZCBrZXJuZWwgVUZTIGRyaXZlcj8NCg0KTG9va2luZyBmb3J3YXJkIHRvIHlvdXIgZ3VpZGFu
Y2UuDQoNCk1pdCBmcmV1bmRsaWNoZW4gR3LDvMOfZW4gLyBCZXN0IHJlZ2FyZHMNCg0KU2VsdmFr
dW1hciAgS2FsaW11dGh1IA0KDQpyZXNwb25zaWJsZSBmb3IgUGxhdGZvcm0gMSBwcm9qZWN0cyAo
TVMvRUNGMS1YQykNClJvYmVydCBCb3NjaCBHbWJIIHwgUG9zdGZhY2ggMTAgNjAgNTAgfCA3MDA0
OSBTdHV0dGdhcnQgfCBHRVJNQU5ZIHwgd3d3LmJvc2NoLmNvbQ0KRmF4ICs5MSA0MjIgNjY3LTEy
MDggfCBTZWx2YWt1bWFyLkthbGltdXRodUBpbi5ib3NjaC5jb20NCg0KUmVnaXN0ZXJlZCBPZmZp
Y2U6IFN0dXR0Z2FydCwgUmVnaXN0cmF0aW9uIENvdXJ0OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQs
IEhSQiAxNDAwMDsNCkNoYWlybWFuIG9mIHRoZSBTdXBlcnZpc29yeSBCb2FyZDogUHJvZi4gRHIu
IFN0ZWZhbiBBc2Vua2Vyc2NoYmF1bWVyOyANCk1hbmFnaW5nIERpcmVjdG9yczogRHIuIFN0ZWZh
biBIYXJ0dW5nLCBEci4gQ2hyaXN0aWFuIEZpc2NoZXIsIERyLiBNYXJrdXMgRm9yc2NobmVyLCAN
ClN0ZWZhbiBHcm9zY2gsIERyLiBNYXJrdXMgSGV5biwgRHIuIEZyYW5rIE1leWVyLCBLYXRqYSB2
b24gUmF2ZW4sIERyLiBUYW5qYSBSw7xja2VydA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KRnJvbTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+IA0KU2VudDogVGh1
cnNkYXksIE1hcmNoIDI3LCAyMDI1IDU6MjggUE0NClRvOiBTZWx2YWt1bWFyIEthbGltdXRodSAo
TVMvRUNDLUNGMy1YQykgPHNlbHZha3VtYXIua2FsaW11dGh1QGluLmJvc2NoLmNvbT47IEFsaW0g
QWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT47IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1h
bkB3ZGMuY29tPjsgSmFtZXMgRS5KLiBCb3R0b21sZXkgPGplamJAbGludXguaWJtLmNvbT47IE1h
cnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBQZXRlciBXYW5n
IDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT47IE1hbmp1bmF0aGEgTWFkYW5hIDxxdWljX2NfbWFt
YW5qQHF1aWNpbmMuY29tPg0KQ2M6IEFudG9ueSBBIChNUy9FQ0MtQ0YtRVAyLVhDKSA8QW50b255
LkFtYnJvc2VAaW4uYm9zY2guY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNClN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjEgMS8xXSB1ZnM6IGNvcmU6IEV4cG9ydCBpbnRlcmZhY2UgZm9yIHNl
bmRpbmcgcmF3IFVQSVUgY29tbWFuZHMNCg0KT24gMy8yNy8yNSA3OjQ2IEFNLCBTZWx2YWt1bWFy
IEthbGltdXRodSB3cm90ZToNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIA0KPiBpbmRleCA3OGI1N2U5NDZjZGYuLjIy
NmNjOTBjNzRiMCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiAr
KysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC03MzYwLDYgKzczNjAsNyBAQCBp
bnQgdWZzaGNkX2V4ZWNfcmF3X3VwaXVfY21kKHN0cnVjdCB1ZnNfaGJhIA0KPiAqaGJhLA0KPiAg
IA0KPiAgIAlyZXR1cm4gZXJyOw0KPiAgIH0NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9l
eGVjX3Jhd191cGl1X2NtZCk7DQoNCkFzIEkgYWxyZWFkeSBtZW50aW9uZWQgb2ZmLWxpc3QsIHBs
ZWFzZSBkbyBub3QgZXhwb3J0IGZ1bmN0aW9ucyB3aXRob3V0IGFkZGluZyBhIGNhbGxlciB0aGF0
IG5lZWRzIHRoZSBleHBvcnQuDQoNClRoYW5rcywNCg0KQmFydC4NCg==
