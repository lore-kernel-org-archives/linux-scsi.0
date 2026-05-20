Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5194837D12C
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 08:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779264771; cv=fail; b=TvYVkt8EL3ekR3eWRUFdPHQd5dmujx+DaCdoJt9/ofHMFkNJF7+GS+lj1p7aSXmFrnKi5OQOH/EV0mmFmxzqV9cy613pTB+dW5gkNDJ4lMjnP5MvHE5rNw3ikpwC0o4b7LgsSqRr3hSJaDuiOZbBz3ZAA/Aw1x1Uddh/hvfJbQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779264771; c=relaxed/simple;
	bh=Iw4KCxBDMP0DqUDy4JA+dn8YiLBL/U7FBNkEDmHJvX8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M+BV6GuJ9VUABgFjbhbWz29/n207isrPQw3Y77A1KbxLsD5hKdBpYj9Mvqx+8VQrKuxJX/RfnYeV8aHNz4lPjF1c3e9V8Ox2qHOktUJPgMS1psyEyIhll0uRXWchXB1h12m7G9Tb57pEG3IScJ/RVbIhxs0wykKeZCgBPwYD1Ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sVqJGb+P; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=HqQ0MjT6; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sVqJGb+P";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="HqQ0MjT6"
X-UUID: ad5d215a542311f1a3561939bc42ff46-20260520
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Iw4KCxBDMP0DqUDy4JA+dn8YiLBL/U7FBNkEDmHJvX8=;
	b=sVqJGb+PtrIYRTUS7tdqUduSXIL79zQhhkrBscjjd+pUzCwCqsrf8dFmtK9yrhaBPcpqUOMG5pxZEOVQJgGSc9H0zooyCwbd+8xtDv2EACenkb9PrJWFW2p0b3GNBq827aBcLqbOpSq/LQ+aQZCKCTQD54T3DZY7GFOE5BaYerk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:7bb05867-b024-4111-a7e3-992913ecea43,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:9091e75,CLOUDID:32382122-bef7-463f-902c-5f40f7404c33,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ad5d215a542311f1a3561939bc42ff46-20260520
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1096221053; Wed, 20 May 2026 16:12:43 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 20 May 2026 16:12:42 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 20 May 2026 16:12:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G1M+bK2CBaYl0EFONpdzMy11x4XqO6ZXiBh8D8tQwlTzNsnSLFUToRXlw8M4nIN5fbEd2MfDKNTyXuJHKZmuamjkpbDgZEG05XKbaFULhrsqSdMmdd48yMdhgnVAOb4apllrg/vk9mr+Ug7hDX16aDmYfspWxG16QmkLmstNQvN+XNSI6C+ac8Vorle8+rXpt24TSZrrHLmEDoKj7ZTMyD12A8eeQp0YUG5wzIFqjzpOSgsXJxXiQltSrGmRgCtKdezMREuMo6/ZRaknKhiDk7pl5joDAzOigk+08XA7xsbxoLMeHxub/gEdf3YqzwTb0k2kbB/rPfuKbVtyZhoINQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw4KCxBDMP0DqUDy4JA+dn8YiLBL/U7FBNkEDmHJvX8=;
 b=FQqRBvXm/XACLg7yMl5JnTnWMdTdVYsNs8TVLz3RfxqttZ9izEO5laj3gpmusZoHQZNXbAZ4AbtZoHj18mppxJ2muLnY+knmfOUIw2CERhmuKPjbPvM2ujeHHJWmyZaH+u8RCtqGAyk055NHVUhy8VqmjTHNgKBeIhxTp+hEkLmFNoKMooxPsOQ1Hxhe4OQfcsXAr4DtXDXFyWw+IIn81OK2i495nKNLZ1aOOBLaoaRNbcAgRC72bNB5pQAcSLT6WsrXHEcSSvNL2er6wYD2zw3HF7uRXPx6sgc/Agjglg7b63oV1tEYLwy+hvF9SPQfVh7lTZy6a3+AP0i5uNoxUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw4KCxBDMP0DqUDy4JA+dn8YiLBL/U7FBNkEDmHJvX8=;
 b=HqQ0MjT6uJJ4IkjTslyC9EBMzet+YJKkZk7pWrJA/MfRjdJLxDTGxTPICCqchBtvg2hb2wxlVgFuEBCs8SPA1UOG/jTl17jCIwjZushZw3vKeSccvJPJW6wEl2CeR6jx0pNO64A2ELm566yUfWkqC0nQY1/hiL4Lk0KUigtm1fo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7406.apcprd03.prod.outlook.com (2603:1096:820:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 08:12:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 08:12:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH v2 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Topic: [PATCH v2 3/3] ufs: core: Optimize
 ufshcd_add_uic_command_trace()
Thread-Index: AQHc59WiU6WS/8hISUK2sLPewPspaLYWkSoA
Date: Wed, 20 May 2026 08:12:37 +0000
Message-ID: <54514aadc2b220e9c5630d65c59f79ae16073db0.camel@mediatek.com>
References: <20260519212135.3130556-1-bvanassche@acm.org>
	 <20260519212135.3130556-4-bvanassche@acm.org>
In-Reply-To: <20260519212135.3130556-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7406:EE_
x-ms-office365-filtering-correlation-id: 0f10f351-5d9b-4019-e7bd-08deb6478e12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|4143699003|56012099003|18002099003|22082099003|11063799006;
x-microsoft-antispam-message-info: 2bJ1PeOB0RDTTK8i1XPQCXPRYsIlzOir43jBTqZwP1C6LM63RcFC5nnuuUlV9JJKIr8OCxx7PH+nSgujVtkZ0lj75/A3Dv+U2Rtng6QKr+EJsnhITZCT224lx47Z/+XX/z/Xpb2nyEw8ta7PjBNAgeo1tMeDCqbOCJhadziFcWWEMcv5iTfQ54QtndwbCcJICPDQO5nTIrzTMVMP02CUt8QwfhQ9x6nlCaPkmGCzYbik2x+gS8y2u4ZwXLWrVaWi3FLu46tOeyVsB0xHuW5LCaaioDoB4w004PwbkdqI+aOLi0J68PH/+7oRO57vzu/tGXHumbJ5HResxOIlhvdeePYqwc0xr+xwljbYZ93LkW25t8BUuZ0kmYwT5vlMUddJplwYMSaT/yLTyUwTRyhtScXtRjF/Xq4pvwB6V9gZ32CfJxE30Xm1WU2C2ZeWlkjY3x6iQJGLlnE7UmYOL6vimkPEM+1o+nK4SS0GApJ1dkwLkq1H4o1x7UGaA+UNLglzRtbt+7BipNT4y7UScernCar7lhYk8i6qW5ANsz1cD4AK9cRuwbr2MBKKHuqdY14YEGr3BA5UkzQ1f92OitwUm07p0TfybUChYzQwnvvbofPGCaVmfMQ2Y5sznRLqNq6s2lQHYMhLsSNPHC80OuZKMz7R2ZOYpCUGPIJa23AK4vfxZ/q7gPztzzJtsDKAD449cFnSl9/PYNq6aZLH5bKZUhmZMgEFosbmy3E1vut4fHP8jYookBGdXdsB6Y4uiHIA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(4143699003)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkVjUlhpd0hBN004bUlxMFZsZEtnMTRpdDF2bFBYMHNCRTNsSmJHVmhHOW4z?=
 =?utf-8?B?ZWFjSVNwdzBjdE5LZGh3aGdTU1FweThYaFZoaHBSUmtLMEEwUXlJQ0c0MDhl?=
 =?utf-8?B?Mkx6RGxVaHVpMCtFZUdjYXlzcUxrTnlFbkZ4VU11ZkFuNUh3WUZSbm5YQk5L?=
 =?utf-8?B?cHNBK3RISnp5dDFzaTJrSkhKSHAxZndqV2pmdjc0RjBBWFFKeTlEL1M2WDlK?=
 =?utf-8?B?d1VNdFFRMnBCQlFYeXoxU0hENXFZUGR2REZhQVYzUWhHM3RWNGJtOWJsVnFX?=
 =?utf-8?B?T0Q0WDI0NVRkOUhSYVFjSnA5VXdOLzFGd3JpNXBuS0o3bTlJMHhFNVN6NSt4?=
 =?utf-8?B?WTFza3BMRWorSHE5bmV0UHB4Z3pjUENEMlBlY1JYQ2ZldGwyRmVoYytqTG5O?=
 =?utf-8?B?ODVxcTlQR3JoM0tvM202YThaUVdLcGFKdDYwVk93dlJQb0g4SHRoSFZMck96?=
 =?utf-8?B?OURlNWVmL0ZNYVBkcU5WdWJqREJZTVA1VE04QVJuMi96Vi9NUTUrVXl3eS9C?=
 =?utf-8?B?MFAwUWd6dEtrclBOZHJUeEtkZ3hBZ3JqQXFWc251QnZXdUZmYk9qaStIbVdU?=
 =?utf-8?B?TzNFUTdCRWY2N2dYb2g1TFNYNkhEOFFDWjUyemlvaFlVcXpiUXkrd1FEN0Mv?=
 =?utf-8?B?RVd2VmdYaXNZVmdlV0Ywc3dpbDJUUUk1aUhoMTFCeUJOazFlM3c3dE0zaSsx?=
 =?utf-8?B?b0N4QU1sWHRndkduMG14dkg3a3lKWDJJN0UyOUZBK2txU0YyYkp0YjhsdjRO?=
 =?utf-8?B?eUVIWm9ZQlNOQjl1QlVXbXBvaXQzcWhzNU9hYUxBaXN6L0VBMkhFUldyRU9X?=
 =?utf-8?B?bUlYMEhMWGgraUpoRnFPUWE5UTZEWG9oT1VNaDQ2SkpBU3pwY2lGZlUvb0hN?=
 =?utf-8?B?dDhMNUUxV1JBWXZOc1dWV2xEbnVlM3VOVXdRLzkzTEMrblJRemJJYVpkdmFY?=
 =?utf-8?B?Yy94RlJnTTFrMjBQSEwrY3RSZ096anp4OGlveGorbDhiZkpneUE2NlY2ekZ6?=
 =?utf-8?B?UWFPaCtlVkpjWFZmN3hMdnpqRE9qVEsxdzQra2VnRklTT0VnOUpBdEtsMFRD?=
 =?utf-8?B?SkZNM280aVlYWFlGUFd1TVc0SGpyODVvalc3eXdkNFpKbWdEbmJnZ0JTaVpC?=
 =?utf-8?B?WktHdGJtUUNPa2puK2dNdU5qZ1JtWHdqd09Gc3dvaTkxVVhxcW94b0k2aHNY?=
 =?utf-8?B?UGNFR2U4aDNVU1lwRlZTQm9VTmczeFhXdFdEZlNLdHhHOHd5VVg3b0dWZ09t?=
 =?utf-8?B?bXQvWU45dnpXbGMvb0VFSXBsK2ZCeWNyU2NlNno0Z3NWR2NvV25xbm9hNUJa?=
 =?utf-8?B?V3ptMVRmMHRnbmNoSkdwdGVmSXMzL3lCdjg1MTVkMll0K1ZleXdjR0pLZ0dl?=
 =?utf-8?B?SFRvWUh5RWpyUEdpbFg1K1Q1UXFOeG9tUURYYVIydG9sTVE2VEdmN3RGZjVE?=
 =?utf-8?B?a0xhV2RnN0pnVklXM3JnajhpL2VaYkJKV2MwUDYyNlNJTE5sUE9VRmt0Q0g4?=
 =?utf-8?B?NmpTVnZ3QWZvUWxSdkFHeHFyRU9FSkI0M0NtelJTbUxRN3p3M2czek90N2ZH?=
 =?utf-8?B?a3R0eEZmNXgzTnpDMHRESUdFS3Q0eFYwaG1MSTQ0bUZxSFRsdmRjbUQ4Nytu?=
 =?utf-8?B?aDVDVzlXaldGK1hHclduVUc0WU9LRHVjYzl4SmNmTTdBM2dkelZodWhLa09C?=
 =?utf-8?B?T251bTJ6clZVb3FIU1VaTFAzTlE0ZlNlTnFPWFVHWkc0Wk0wSkxVNHNSTG8v?=
 =?utf-8?B?cjRnQW9KVVlVSnZWNFZvNjNUN292Vi9XOFh5Y09DQ1lnYnRjdjZCbDJRUUNj?=
 =?utf-8?B?Q0xQc1o0ekVWTTB4bENpK21ybmhjbndzajFkakpvQXVzQ0VTS01VWTVzTVh0?=
 =?utf-8?B?TDl1WVIrK0N2R293N2JzY0tFWWlPc01LWC9kT0J1UGZNckMvcGtjTU9KVTFk?=
 =?utf-8?B?czZocXRmTnVKMHpwSElJM1BhNmhLVUlpU0ZnQzVjWDRCZFlMZU12RXBFZEhB?=
 =?utf-8?B?ZGFMR05naHFpWjlvWnl2ek9rRFJxNHNMek8rOWt0cGN6OVRBNmdSbTVFNndm?=
 =?utf-8?B?WHc1OGRyUG1wenlJaVc4N251UTRnamRhVkRuQ25GbEVZbXdFRTQrRFVzY1pm?=
 =?utf-8?B?K3VOM2hwckk0R2tHcDNTQncvaXlIdCtpWmlleXdHT0Y4dDgzMXcyQk9RR1FJ?=
 =?utf-8?B?aFEzaVBzNWtJWWw1QzlyUHU2OGtlYk1GSUlnQ21vUnJUd1FQaVhjbmVOcDJU?=
 =?utf-8?B?dHVxSVZ2ZnYyeFZNa2dBZjhZckJLbkxKYlpRWW01ZXozU01zVTdVRGVWRDM0?=
 =?utf-8?B?MXBLNG05N3BpOEtzZG04U09scTU5RWNLMGVYZDN5Qk1LSmVBM0h3TlgrTS9J?=
 =?utf-8?Q?0fSsK5zml+XcXTJA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F3B084473C0384F91F2851881FD7615@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PPBS/hG8uO8NI8/SyXPs5PbxR/KJMggXUPzRDN1eIMENU2Hr5o/4o1Os3CUvrDngoNM7pTSCuVRcwFnpBMZVOax+IK2JRW5RQdvPMjkZlaiWecYlAuUM2GivtuWD+YQBA80QSnaDmP0+sjdfux59ZJlMoUTeG6gTa3blEPogBG56Tw245aBIV7IaqFgxUWUHtAvcsddg+4/Xx2koFgTF8RT40aULMUGc4wK+DTDcf9Z6yHv/CUucFjv6fpN5pR9q/uTn3wVUWohf5UVHIhMpPdeu6PqMdp5EFfV6+8XaUv7NrZGVK/6Pv6ns+06T05Lss31uPGslJ123CEDFr9mjew==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f10f351-5d9b-4019-e7bd-08deb6478e12
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2026 08:12:37.5163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G8EefcT9Lx6ZZ9hCVFQJ49bmtTjv0euxfn1fRRHX6QO9/RaBQ9xWo8pk7Ylh5RqgApGZ8hBCkyzPtqpRA0VUlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7406
X-MTK: N

T24gVHVlLCAyMDI2LTA1LTE5IGF0IDE0OjIxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFVzZSBjYWNoZWQgdmFsdWVzIGluIHVmc2hjZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoKSBp
bnN0ZWFkIG9mDQo+IGNhbGxpbmcNCj4gcmVhZGwoKSB3aGVuIHRyYWNpbmcgY29tbWFuZCBzdWJt
aXNzaW9uIChVRlNfQ01EX1NFTkQpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNz
Y2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRl
ci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
