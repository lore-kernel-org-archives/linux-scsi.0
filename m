Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD736AA0
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470081; cv=fail; b=I2hhbdsdEBUjuM2czy55XgPFj2yDesDL+gm0p85NmjBjm5Kes6tjO4AX5zodE+PvQsiFfTh/Sh8Ra8ZD0RiWBOxmjgZAw9oTgJnACABiVRQBjLZ7pgvor6H975Mu9och+SbgY3HNaYl6ckX1JVozwcopXKD8aYv/45ke2YA6jKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470081; c=relaxed/simple;
	bh=8v/i4fUMJQA3JpbcD64coj4l6ImwOPRXtpoAaqvC+fM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QfPPUgvFh+YHGKqVgroZJI9svQXhEQvbyPRv3ot6EzP3m2bNURscE6OBrUUAV7L6i0APB9qGVKdIABXDaRRNmxlq3+AB+J/SPEx86XZ48jvUfllxCPBfQ5GrxocXzd2QnZmxuEdVJYLP3Tpf3PitneS3zy1igHOVICSX2pXB2rE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BfHf169C; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EQAiMKm8; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BfHf169C";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EQAiMKm8"
X-UUID: 90cdec4ae27411ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8v/i4fUMJQA3JpbcD64coj4l6ImwOPRXtpoAaqvC+fM=;
	b=BfHf169CLFETc4sNmyaMrg6GKdXyuCULkaibpPzNy8vXf3bF9U/C3WL6y2c5b/zv7/xIVnmyBp0+IyM4oT/tEDExdeWtYm0BTP4Dp8cKDHY/NXzJwyR4+cEbFwmVNsB36A3DzjXj3NqKbHt7a7VhbFbwBpLLzm3dLUHXbTxVLR0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:6d29bdda-3d91-4c0d-9971-615e61e254f8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:a51f0685-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 90cdec4ae27411ee935d6952f98a51a9-20240315
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 165284301; Fri, 15 Mar 2024 10:34:36 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:34:35 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:34:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZrMnpHLSHhvVhT/QdqghS0pNSvHmFSApNRO7sGU/TJCxZQczRghH53XdJ6aZ+5Jk9YVGzGwyq8oc6foxneemUhcLtEvBHZ9zQCPti9jpBFoZI3wF+e76pnCxvoqaQXdC49EDe0qBbswcJaZnj+TpSXZwVolRLQkKluDHq/bPCLJdr03OQEBVg/cMndtfQ7SausK2LM9m3jab1la20HrKiCc6oLBr2ju73kaWQEIK38NjCot1YqltVZPefeceHvAzbiTDHBKm7lQqYWvtfTZdyZ+NP0vxLqYFhcAd549BEnDEtuO1If3nBe3uJIgSh5sZG7g1opvyBZWFByJ9fIuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8v/i4fUMJQA3JpbcD64coj4l6ImwOPRXtpoAaqvC+fM=;
 b=eGGT+G/2aG0IgohkQqYHK7fF7am6WGYHg5tOGN3KuHhM7GE35Oya7pTZv8XhqoaLGjEFYonTueNY16QPixD8kYtB/Na7tsLYQCHtDqXZjdhC/sxSYa769Vxq/4unuUGnIouue+UhzNlZoK8HB1OmA0NXXQWgzoyPhtluyNLqYXRSqeLKTbaM5HG4V2Gnz1h1+g7iun0jNeiW8Z1bAOQcUFvCsMHapkSAdfQoVa+1iHpIFLKEvfoUjGkPiAtlycntpzmoqZzHge5+wSfiAmrHCqFA3nlGVgyjGjm/FC4WoeR0knZUKsg0G/YsC63t2DUPjpMMOI/raUXA1AHijJWfZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8v/i4fUMJQA3JpbcD64coj4l6ImwOPRXtpoAaqvC+fM=;
 b=EQAiMKm8KZSp/mDTQxazp6heVMT7JPC6XAcnbeV6SGdwTZi/0FqmnyHh8NiqqasXr5KZS2y3yfScj4zOSupaE7tNsBT1DpVmRtpb+wt9YRvsj2jhbTxAaBW55Hm/dHVq8sk3lxlEe9GHVWMbze81tBHMlk2DnGzjpyHQs0czMNo=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by TYSPR03MB8849.apcprd03.prod.outlook.com (2603:1096:405:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 02:34:33 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:34:33 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?=
	<peter.wang@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 1/7] ufs: host: mediatek: fix vsx/vccqx control logic
Thread-Topic: [PATCH v1 1/7] ufs: host: mediatek: fix vsx/vccqx control logic
Thread-Index: AQHacSahrtcwQC13PUWHpJOSt2U39LE4IFIA
Date: Fri, 15 Mar 2024 02:34:33 +0000
Message-ID: <c5a6c3ceb410006a4a137ef01dc70f7dc8baf18b.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-2-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-2-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|TYSPR03MB8849:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kv6Oeqz1o4SeF54BhptQFX3rHNEF5W0EaiiC17JTi2IRsm1NqLrswr1hXffICmLyw2SSwkXsPUteIiBKopEjOdhixqgPSAhkzU8AbC3Pu5KDSrRh8bX7AiWXvLc9xkFSLKXH7TmQkDNKFBX131RfOYf/H8dE0aYP2XVOX+YvNb7CC71blM4GTZFcC8Q3LazHIm+sx5Lgp64Y/RGxE8nReFxKOqb5+T8nBNje4GTJbN3Pnghmbp922HO88168w8yQxe0dPyK7FrqoPgCBZlnGzGmiyYrdBfwYUBHyjuJ91GWRqHfdCMHIV/S4xLSKLcHQOZfBzqtXyX4WfCIB9IlNkjJgp/QSeauQ7ahdVnlwpbJU2sWUPLp7/Z1nGdln3CDlI8zblJg6hj9koB4BSZ1XIUxn3GTGmsAf21g0XxDfJxd3uadXGbbsFt6Z2e1zTqOMvAy+K38698wjGIBNzNMd3lXJTPVVGEpH9oY1MLrWJK2lfLXmvqcFdYSymtwlkU42mi/VJlvnTjrS36MLKwUV+WdAiwjBFxCWOxJBBjo5RMticzvkC7S+oCWt5VeHk+Knpbt1xaZ29fIPTxiGpE2Mx/MC0WlfgIWuAE6Nn1hGUr7tsLktlc9uavRIYaerhP9g8wNot1M7E+L4Cr4K1EwkPWwTGKWQ/2LEcxbXp1upPH0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2k4azdGRXAyYkcxN2xvS3JvV1BGT245Rm9KSDdSUkt0dzZydWdpaHYrMXV2?=
 =?utf-8?B?ZzhqMHFsdXJPQlAwaDYwYUFkRG8rV1cyYTRENTRydkJOWWdQeWFPbXE0NXhK?=
 =?utf-8?B?MXNPdXFkWXk0citodzRlNFpPUThjRitRTGZqaXRGTFkrV0hnbmovL2Rsejdo?=
 =?utf-8?B?N3NOOWcvRi9XSVZSNHJuYWlWSzJRZHFQLzhLSEN5OXp3eGE0Z09FSTZlSzE3?=
 =?utf-8?B?dTVsWHQzaGpFQkJpSXJOWFJ3RzFTblJKSXBJU2RxWE95cmttQlpFK2R1L1Jk?=
 =?utf-8?B?SUlWbzFVbThzWUtwdnFiS25lZjBZRkROUEVRN0kvdFIzSmVlRDdSVVBCMU43?=
 =?utf-8?B?Zm5ZNUVMWjhISTUvWGt4Q3RJNThRY1FjQk9Zc01SaHpNbGovQUhxcFNpYlk3?=
 =?utf-8?B?NFE4N092anpNczdRSmlOL3pITExTOXR1QUJTTkRDV1JtY1lkbWFjRWV0TzFQ?=
 =?utf-8?B?eVV6VWY4MGN2NkJueng5bEJTUTFjOGJmLzJ5aDFxLzMwZWF1UTNEZW1OK3dN?=
 =?utf-8?B?YmJFZUxpQzVBM252TzY0blMzUk9SblNENDh2TEdUaldEaENsQ2VZbUJjUy8x?=
 =?utf-8?B?YmVFMUxoNVFvaDlRbmh0VDdGK2tTZStPbG1TbWg5dE5zNGEydTliTmpub25L?=
 =?utf-8?B?V25aRzBmeUg5V2NWU0lyVEtSNDlJN20yRENjcFYycmlKTk9hT3FsRnNYTStx?=
 =?utf-8?B?NHgvQnRPV1NPTFpmbUdDRGJVdzRSODlUVk1QN2VJUnhEWWVOQnBURjZrZExz?=
 =?utf-8?B?VW5MMysydktTRjFsSjVHVG5pc2JMbmk4RnhCVXdkVVYzSWpYQXJseW5URGF5?=
 =?utf-8?B?Q2YwVU1waDFFeHBOaE1LYVNuSGlzQ2k5eUZkMlBXZTdoYXJoSWVtWTdOQ0ow?=
 =?utf-8?B?b2M5bE9vL09lb2pEM3NkTFc4NVJsTHJwSytuL1FOVjRkY0VOUjF2VjBCdE9R?=
 =?utf-8?B?b2h4bVZXRTRRLzJOdW1KZGtjN1h4c2ZmMzI0REtwc0NpUjdORFc4Skpscnpw?=
 =?utf-8?B?dXcydmRXLzhETjJtK1UycEU4RlRucUx1UFhqMHlKMUF4a093UDIwR2VRb1lm?=
 =?utf-8?B?MjRpV0IzTWdPVlcwVEJtN1h4aTN6c0NZNWlnUDlRZFhmSEw2TDNiUGZZU1ov?=
 =?utf-8?B?bzVXQ1l0OTIrUGxpUktqRTR5bnVGbmVaZGdnbnZNMnNqY2VWVjNubjNxQWsw?=
 =?utf-8?B?aDBmamcwQTc4Ujd5eUJoTngyTGhheVlIZjBKdGQwc1l3ZnFHRzB5QlpaSkVZ?=
 =?utf-8?B?c01UdmZ4VGNnRHExUzdDRzdPcncwTDZTWWhENHdNZFJmcURhODBCWm5CNE1P?=
 =?utf-8?B?TUVXdXlWWTdCYUVJR2VlelBURzdEQW9jeVllc29ucVE0NUY4K0ErVm9ORm4v?=
 =?utf-8?B?T0xCencwQmxDbTR5QjVCQ0J1cTdZVU9CK2hXd0RwcjR1N0VtRSt5a0VTN1No?=
 =?utf-8?B?dlhOMjZVcjJDOVdSbWtNTDhsNTE0Q3RuQ2F1VFppaUQwdFZjczNkdzMyYTJ2?=
 =?utf-8?B?ckFZb296Q0pqbFEzTXpPbE5ydlQ5dnJRZDFMWlhISlMrT0drMjU5SlNCWDFx?=
 =?utf-8?B?Q3lRVDg5NDdWdUdQcUpjKzd4Vk80WFJudzhDNFlSU2VOVVVCYzFrWk1qNXR5?=
 =?utf-8?B?MHJUdldkTXdxbWlDRWpQaG9YNG4vZWRmSHpRL1poOXdQcURnWStMaDA2cXBE?=
 =?utf-8?B?VU9ULzN6cksxaDNLZjgwcVE4d2kzV3pRa2FYWWZmM014UGFmcXFwbHJrRk9J?=
 =?utf-8?B?ajZkT3RjRXVWSGY2OUt0L3BQWDc4TEx1MXV2QVVQQmVQMVIrTElQMXdLMWZm?=
 =?utf-8?B?NEROcXltdVFva0YvTUs3djZGM3EyQU5XSWNqbUFFWFNKczVDb3JDakd6Tmo4?=
 =?utf-8?B?REVVQlNVekk0OHNJdCs2LzFHY3Jjcll1cG5LRm5NOCtVcC9JOXhVM3NIamNT?=
 =?utf-8?B?dmhVeWdWZzM3bUt0YllTMUhMVXRYNDdNSnp2TmMya1h4M21pMzdHZ2V2Z2Ur?=
 =?utf-8?B?SWY3SlVJOXNMMWJFQ0R0WG5MWGkxZmR5RGpsWndWMklhYXhRNWtrSHAxczVG?=
 =?utf-8?B?RXN1NUdXTGlYWlBORlFPWGZjeGNrbjRuVmNVSW9pbXdoenhDVVdpdmpCb0pj?=
 =?utf-8?B?S2RWNWhYTkRnWW1xNnVXMkZ3NHQrT2JCSDdVRkJqNFdkVWpFTVhVTDd2czFN?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7AD91119A790E4B88170E2BB4EF19B2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d616de-69ac-4b80-8e72-08dc4498730a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:34:33.5246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9FbqsuYWPBrtMi/tokhGHaw2ArSqwMqHRZi2bX4esPnrytszRJP7QgFNehY5cOeIo1Ja0a4y3kgG4EOde5oG7zznpRtmd0lC10A64oMa6aQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8849

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBWU1godGhlIHVwcGVyIGxheWVyIG9mIFZDQ1EvVkNDUTIpIHNob3VsZA0KPiAxLiBBbHdh
eXMgc2V0IHRvIGhwbSBtb2RlIGlmIHVmcyBkZXZpY2UgaXMgYWN0aXZlLg0KPiAyLiBFbnRlciBs
cG0gbW9kZSBvbmx5IGlmIHVmcyBkZXZpY2UgaXMgbm90IGFjdGl2ZS4NCj4gDQo+IFZDQ1FYIHNo
b3VsZA0KPiAxLiBLZWVwIGhwbSBtb2RlIGlmIHZjY3EgYW5kIHZjY3EyIG5vdCBzZXQgaW4gZHRz
Lg0KPiAyLiBLZWVwIGhwbSBtb2RlIGlmIHZjYyBub3Qgc2V0IGluIGR0cyBrZWVwIHZjYyBhbHdh
eXMgb24uDQo+IDMuIEtlZXAgaHBtIGlmIGJyb2tlbiB2Y2Mga2VlcCB2Y2MgYWx3YXlzIG9uIGFu
ZCBub3QgYWxsb3cgdmNjcSBscG0uDQo+IDQuIEV4Y2VwdCB1cHBlciBjYXNlLCBjYW4gZW50ZXIg
bHBtIG1vZGUgaWYgdWZzIGRldmljZSBpcyBub3QgYWN0aXZlLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgZHJpdmVy
cy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDQxICsrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tDQo+IC0tLS0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmggfCAgNSArKysr
DQo+ICAyIGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCA3NzZiY2E0ZjcwYzguLjZm
YzZmYTJlYTViZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
Yw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC0xMTksNiAr
MTE5LDEzIEBAIHN0YXRpYyBib29sIHVmc19tdGtfaXNfcG1jX3ZpYV9mYXN0YXV0byhzdHJ1Y3QN
Cj4gdWZzX2hiYSAqaGJhKQ0KPiAgCXJldHVybiAhIShob3N0LT5jYXBzICYgVUZTX01US19DQVBf
UE1DX1ZJQV9GQVNUQVVUTyk7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBib29sIHVmc19tdGtfaXNf
YWxsb3dfdmNjcXhfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICt7DQo+ICsJc3RydWN0IHVm
c19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiArDQo+ICsJcmV0
dXJuICEhKGhvc3QtPmNhcHMgJiBVRlNfTVRLX0NBUF9BTExPV19WQ0NRWF9MUE0pOw0KPiArfQ0K
PiArDQo+ICBzdGF0aWMgdm9pZCB1ZnNfbXRrX2NmZ191bmlwcm9fY2coc3RydWN0IHVmc19oYmEg
KmhiYSwgYm9vbCBlbmFibGUpDQo+ICB7DQo+ICAJdTMyIHRtcDsNCj4gQEAgLTEyNzEsMjcgKzEy
NzgsMzcgQEAgc3RhdGljIHZvaWQgdWZzX210a192c3hfc2V0X2xwbShzdHJ1Y3QNCj4gdWZzX2hi
YSAqaGJhLCBib29sIGxwbSkNCj4gIA0KPiAgc3RhdGljIHZvaWQgdWZzX210a19kZXZfdnJlZ19z
ZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgbHBtKQ0KPiAgew0KPiAtCWlmICghaGJh
LT52cmVnX2luZm8udmNjcSAmJiAhaGJhLT52cmVnX2luZm8udmNjcTIpDQo+IC0JCXJldHVybjsN
Cj4gKwlib29sIHNraXBfdmNjcXggPSBmYWxzZTsNCj4gIA0KPiAtCS8qIFNraXAgaWYgVkNDIGlz
IGFzc3VtZWQgYWx3YXlzLW9uICovDQo+IC0JaWYgKCFoYmEtPnZyZWdfaW5mby52Y2MpDQo+IC0J
CXJldHVybjsNCj4gLQ0KPiAtCS8qIEJ5cGFzcyBMUE0gd2hlbiBkZXZpY2UgaXMgc3RpbGwgYWN0
aXZlICovDQo+ICsJLyogUHJldmVudCBlbnRlcmluZyBMUE0gd2hlbiBkZXZpY2UgaXMgc3RpbGwg
YWN0aXZlICovDQo+ICAJaWYgKGxwbSAmJiB1ZnNoY2RfaXNfdWZzX2Rldl9hY3RpdmUoaGJhKSkN
Cj4gIAkJcmV0dXJuOw0KPiAgDQo+IC0JLyogQnlwYXNzIExQTSBpZiBWQ0MgaXMgZW5hYmxlZCAq
Lw0KPiAtCWlmIChscG0gJiYgaGJhLT52cmVnX2luZm8udmNjLT5lbmFibGVkKQ0KPiAtCQlyZXR1
cm47DQo+ICsJLyogU2tpcCB2Y2NxeCBscG0gY29udHJvbCBhbmQgY29udHJvbCB2c3ggb25seSAq
Lw0KPiArCWlmICghaGJhLT52cmVnX2luZm8udmNjcSAmJiAhaGJhLT52cmVnX2luZm8udmNjcTIp
DQo+ICsJCXNraXBfdmNjcXggPSB0cnVlOw0KPiArDQo+ICsJLyogVkNDIGlzIGFsd2F5cy1vbiwg
Y29udHJvbCB2c3ggb25seSAqLw0KPiArCWlmICghaGJhLT52cmVnX2luZm8udmNjKQ0KPiArCQlz
a2lwX3ZjY3F4ID0gdHJ1ZTsNCj4gKw0KPiArCS8qIEJyb2tlbiB2Y2Mga2VlcCB2Y2MgYWx3YXlz
IG9uLCBtb3N0IGNhc2UgY29udHJvbCB2c3ggb25seSAqLw0KPiArCWlmIChscG0gJiYgaGJhLT52
cmVnX2luZm8udmNjICYmIGhiYS0+dnJlZ19pbmZvLnZjYy0+ZW5hYmxlZCkgew0KPiArCQkvKiBT
b21lIGRldmljZSB2Y2NxeC92c3ggY2FuIGVudGVyIGxwbSAqLw0KPiArCQlpZiAodWZzX210a19p
c19hbGxvd192Y2NxeF9scG0oaGJhKSkNCj4gKwkJCXNraXBfdmNjcXggPSBmYWxzZTsNCj4gKwkJ
ZWxzZSAvKiBjb250cm9sIHZzeCBvbmx5ICovDQo+ICsJCQlza2lwX3ZjY3F4ID0gdHJ1ZTsNCj4g
Kwl9DQo+ICANCj4gIAlpZiAobHBtKSB7DQo+IC0JCXVmc19tdGtfdmNjcXhfc2V0X2xwbShoYmEs
IGxwbSk7DQo+ICsJCWlmICghc2tpcF92Y2NxeCkNCj4gKwkJCXVmc19tdGtfdmNjcXhfc2V0X2xw
bShoYmEsIGxwbSk7DQo+ICAJCXVmc19tdGtfdnN4X3NldF9scG0oaGJhLCBscG0pOw0KPiAgCX0g
ZWxzZSB7DQo+ICAJCXVmc19tdGtfdnN4X3NldF9scG0oaGJhLCBscG0pOw0KPiAtCQl1ZnNfbXRr
X3ZjY3F4X3NldF9scG0oaGJhLCBscG0pOw0KPiArCQlpZiAoIXNraXBfdmNjcXgpDQo+ICsJCQl1
ZnNfbXRrX3ZjY3F4X3NldF9scG0oaGJhLCBscG0pOw0KPiAgCX0NCj4gIH0NCj4gIA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvdWZzL2hv
c3QvdWZzLQ0KPiBtZWRpYXRlay5oDQo+IGluZGV4IGY3NmU4MGQ5MTcyOS4uMDcyMGRhMmYxNDAy
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oDQo+ICsrKyBi
L2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4gQEAgLTEzNiw2ICsxMzYsMTEgQEAg
ZW51bSB1ZnNfbXRrX2hvc3RfY2FwcyB7DQo+ICAJVUZTX01US19DQVBfVkEwOV9QV1JfQ1RSTCAg
ICAgICAgICAgICAgPSAxIDw8IDEsDQo+ICAJVUZTX01US19DQVBfRElTQUJMRV9BSDggICAgICAg
ICAgICAgICAgPSAxIDw8IDIsDQo+ICAJVUZTX01US19DQVBfQlJPS0VOX1ZDQyAgICAgICAgICAg
ICAgICAgPSAxIDw8IDMsDQo+ICsNCj4gKwkvKiBPdmVycmlkZSBVRlNfTVRLX0NBUF9CUk9LRU5f
VkNDJ3MgYmVoYXZpb3IgdG8NCj4gKwkgKiBhbGxvdyB2Y2NxeCB1cHN0cmVhbSB0byBlbnRlciBM
UE0NCj4gKwkgKi8NCj4gKwlVRlNfTVRLX0NBUF9BTExPV19WQ0NRWF9MUE0gICAgICAgICAgICA9
IDEgPDwgNSwNCj4gIAlVRlNfTVRLX0NBUF9QTUNfVklBX0ZBU1RBVVRPICAgICAgICAgICA9IDEg
PDwgNiwNCj4gIH07DQo+ICANCkFja2VkLWJ5OiBDaHVuLUh1bmcgV3UgPENodW4tSHVuZy5XdUBt
ZWRpYXRlay5jb20+DQo=
