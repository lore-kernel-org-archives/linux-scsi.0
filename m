Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55109340406
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 12:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389761; cv=fail; b=DAqgi090BRz5porWnF2hrKw4b2kYzdvbjqP/VtFoELyV/2GC4ySk36OCdnG0AVG7uw4pKvpoOeQOk940rc7NHoZjv9yGR09kFgRnlncj0PpnYNAK+rhkaIiQIQzGkziOGyNW4Urj6MFnsDCRKuh3PUBqUO5oq7uraUUSRv8bY9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389761; c=relaxed/simple;
	bh=K/hdtfkFxjZ8ZfDkvxZADEsXCWngHqJUgBP0L+xaJM4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KePiRVMleNWTJGn+qHtfM800qATp0GDdQAMEeUrEttgH7SYT/4Ra/w8Yd8bLkmnvhEh/B5LBNHPKrMIb+V2wH3/gregdwr67ExYozlC12lqjwhtUOsvtOlsb55Fz+/nqNqfG69HlfrAL99R9Nzv5o0yOBwTIbG0hAsRqMj+A8XI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=tzm+KMQT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=D7HqR32c; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tzm+KMQT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="D7HqR32c"
X-UUID: c0fde006b03911f1b1788b6acf885367-20260914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=K/hdtfkFxjZ8ZfDkvxZADEsXCWngHqJUgBP0L+xaJM4=;
	b=tzm+KMQTVzhw2b0otH7KmBpVuvAQH07Ju9rb3+92mem4BxUx24ZJTiCYpzJKFTPRZ3hYpx0J0hR0aU7EgjzIyDjnGy40BHVwsQgXwtpBagZmOrJaFH2EyUSa1KhA+m2nWo0kRyEd7K1noDeDgCxtTyxzVbxg5F3xEW7V/9s0v2g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c84c593c-8d24-41bb-80f2-63364c8cb564,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:6285c5dc-e2a3-4c41-83fa-4adacd638ae3,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:
	nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c0fde006b03911f1b1788b6acf885367-20260914
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1915646487; Mon, 14 Sep 2026 20:42:32 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 14 Sep 2026 20:42:31 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 14 Sep 2026 20:42:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MO0+jKaziFeE0tNGkntyWLVCuUbx8FJknfI92FiTuvENH7kOlZ+6irKwXoT+YOuuMYlDpVI4PboHf+AfkGd7cf8q1sNT3UYCZeqnxLyoUi2Pn9lycEMt5eDnhnYXbA+Zvc48A3Dtp89JdlnmSpirVRgPOeLEtWtCrTjn/MpUy4+7zO48ODxZjCgk9Fos7IibCzeOHx6xW6RGcHLhklHcKkuI62bVL5cgWB9XGGG0GQYzZCzj4H+9O9YBEH0csc0xfATpxUTPTsYMkDzrcZaDsAQVrJTLcb/o/UoDdo1eP+js5/MxZwi1I0yWHekGmmuh3QGJfYf3A9Bi8a2cTCqX8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/hdtfkFxjZ8ZfDkvxZADEsXCWngHqJUgBP0L+xaJM4=;
 b=ZQx0+Ku4t/xOMjJDqn/6MXFIWGTI4uzw2J5DOc7ENZTOWrJDoVmAiHP6KXFl4jYH9UE2N6LgzserhA3orGIm92n0FvIBKbnjLpK0d0km7xR6QcISQpVcG36lb0shrzsT8N4juSfvqill2OjlBcvQT+x2IdBu2qTPT8T3C01Y41fXjwoOFNtOsZ77yqg2SNeVACndAvs3kLaiWvCwTPEH8D6YjixMXjVQhipHoAB3AOuq/tzCq03HfdyPwpXZKWB2kwCuF8CHCvbezjVkjcHl3WqZycxAeNF79lg0gVtG7VPIFGO2CRYYnbeCKGxJyOb0yFl7Z4+0wzSMxt/jl8nfGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/hdtfkFxjZ8ZfDkvxZADEsXCWngHqJUgBP0L+xaJM4=;
 b=D7HqR32cXgetYG0ozjYZMAJ5jNK5d8g3LHh8WkWRPjbgMLMS3vOikcmbxitKvbZRMOl4IjG27LOyiWsbtogwjg9IPtq7my6sp3e1ntpShM+zaswiKZmrcgw/Lk5tM4dIOldGtgy/NrIBf7dg3mkbB8OourxEAYWZji4nSxaat6U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSNPR03MB10496.apcprd03.prod.outlook.com (2603:1096:604:47f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:42:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:42:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ufs: always notify POST_CHANGE even on gear switch
 failure
Thread-Topic: [PATCH v2 1/2] ufs: always notify POST_CHANGE even on gear
 switch failure
Thread-Index: AQHdRCZcFCpkB4H2BkW8KC+xGb7Go7bNxyeAgAA9igA=
Date: Mon, 14 Sep 2026 12:42:27 +0000
Message-ID: <124bc8d4adeb8da9ff611c8c745c8ca9794ea066.camel@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
	 <20260914085148.136429-2-peter.wang@mediatek.com>
	 <20260914090211.A873A1F000FF@smtp.kernel.org>
In-Reply-To: <20260914090211.A873A1F000FF@smtp.kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSNPR03MB10496:EE_
x-ms-office365-filtering-correlation-id: d5a94131-836e-4d51-0e8e-08df125da22d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|22082099003|18002099003|38070700021|4143699003|10067099003|56012099006|11063799006;
x-microsoft-antispam-message-info: HrV+QmlTrTKOQit/pHGNhib2bkknZsQYRS5t4SuSmPnld/q91nvr56v63hJje8A5/KmDrT0b7UV0TMedSP7MOO093YG/XtO3OzyZQUL2WSFn6n+StxjvTimq4rM5NWuoHCeV0jG6KkZ4Dz65r6NbyrT8I7npusAlDIxkfWnCjc3EJCzdGvAS9FHF3On4aU9K9KjpT2bvRYX8OnUOww5imEGoLvL9QL4tztJ6aYxONhIsGnjQaQBk5agjX5MXSgOmU2SwFML0izZVSF1K3XJUcWKKCEEJrso2k95BR0Khi46LX5LvNyZ2CD3uYBnnIS/7Mn+RjbTFWIZ1BlYFyKCGnjQXdojy/nAkmfZD95m61ZWNuDS4O8iXFNjI6ozGm0TODd7K/05Gj5lzMourqQxRnFOMlgRQRfrX95HddSVUVjLSFpzy5Hll/huv+xUN+695+E1mWBqEalSwYJuNAPllhiGJC+ILCi6qpOKK5ytaTV39LjfaOMyDs/E0gpvxlNvKjmUh4ELCGalIwJi40yi2FpXZxw5zpZBgJhEg3jiU3anEtFIvdboKt/ndbvTdiaNXoJ2PVi6ZOEdD7f/47bluRoWUOdvkDgmo0m8HTdL1VjTqaf36aB4zL/iC9cPZFT6nhB+xDMaJYhPxc84EoBmzNrq7R4KGy/2PtC8Yve1lgAaFQXtKQ26lJYm5BOlWwvqErt9nIHZaM0oLw202wXsdNbVwsypVR1b/hU3xJ0cWCpU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(38070700021)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0JubjIrMVhod21VblFQamlsQWhuY2NkT1JXdWQ5TGdkYll1YTVubzROTjhQ?=
 =?utf-8?B?WS9mcFFKeGovQ0Z1NW5ZbHVnNk5WNnpzUVlRcTNZTlYrbk1wNFNYSk5WVlN2?=
 =?utf-8?B?ZVo3Ukp5TkowQmNsOFV6RkJkZkF0VkpJWmt2OHVyWjNsS0lpbXBvV0NxV3h4?=
 =?utf-8?B?Z3R3b2VNdTBWYmQvL0N6a3hsbTd5R0hIOGxCUGNVb3ozSHZqaDVTZ0loblVL?=
 =?utf-8?B?RlI5Z2tyQUNCQXVMazEzcW0vai9hZ3Arbk1FOThqSkk4MDNTbk5zZWl3cWo2?=
 =?utf-8?B?U1RxZlZEU25CZ3VtN3VVYzl2SGN4TVd0Y3JmeDg4REVxSVE1VEt4RzlQTUVx?=
 =?utf-8?B?SFd4eEdEU0k5Ymh1b1F6dnZwc3dpNStWWWViNzI1UXJGb1JPNVppclgzZ2FV?=
 =?utf-8?B?Z29GS0E1T3YzcHhNeFNQOEZ3UUpqb2Q1YzJZUWRGWU0zdzhuaHFWbkhsMUx2?=
 =?utf-8?B?aGdWOGNCcklOc21TcU5jU1Y4aFozd041QWx4V2tLTVNvd0ZHQWF2aE1TU0lQ?=
 =?utf-8?B?NGZKbUZDdkErT3NtaDVNMFlHaCtUYzAwelpGdStJQVQxTHVnOURPcDZ4b2ti?=
 =?utf-8?B?TlhhWjZCVFdHUWRMS3h1ZHh0OVMzWWV6dm5CNXZjVkNzeDgyLzBpeU1GMjZJ?=
 =?utf-8?B?YjA3RUhkSFBLMUtjaXI2L2xYaFh3V2plQnAzdGtMUFJJUXJ2MTNEREVwUWpQ?=
 =?utf-8?B?UzFOOTlFd3c3N3R3ck8vOXZpdWF2OFFTdURoZjlmVGlXQ3dQY2k2bXBvbFNN?=
 =?utf-8?B?VitlV2w2SzY3QjhOM2RYdmdvYnpXdFF3Umw1QTJXSFJ3cHJwQXoxbFdXbjhh?=
 =?utf-8?B?eDBoMjJrVU4wUW94RFdHd0xoU1VNV2NlWU44VE9yTTBQUVh1cmNQbDdDOUJR?=
 =?utf-8?B?U0VQcHFFemJ5TVo3U0lhY1B2azdZUHltRFhXd0ZJRGVoeFh3RC9jMWtrK0dT?=
 =?utf-8?B?YzNZMkJpQ1hCbUV2Wm9UdUl1RzBNeXV4M2U5QmhKNzMybWVBbnlxcUFwZUo2?=
 =?utf-8?B?VDRaeUEyK3Fva2lncW0xUTdTTHZwSlQ5QWZ0S2Z2VVhmUm1aTVo0ZjlLc2k4?=
 =?utf-8?B?cTJqZGFORTZUQ1hKM1lHbTV4T1ZhbzY2ZWlwNlZhWXdBZVp6bG9RSDhwRGZW?=
 =?utf-8?B?RGttU245UGRKeEJ2NTF5V1ExWlBiQ1FkVEdaSW04bHhpQVdGcnN4RGd5TWZX?=
 =?utf-8?B?bGlsd1dLTEVoWFlyQ0hBdmE5WGxUc0R2RFhaMjhQc3RQNWJheEpBZEdZRTN6?=
 =?utf-8?B?SWdEWUpsKzM3UDNFYm5qeVI1eit1dFVYUUFBc1V0dHo2L3ludEo1VHJNbDJq?=
 =?utf-8?B?ZWNYeTEyc0xhU0JpbzVqYWFmKzZmL29EelNxRyt6NzRqV0wxZk4yYzJ2NFdS?=
 =?utf-8?B?SGtISjhaZnUyVVFmKytoZ3NaYmQ2S2tiMjRyVU80MWFUVjlzQWVZZ3VqZWhr?=
 =?utf-8?B?VDhjUWlQRGlsUDM1VllDZW1QM0c3TE0reVZaSWVKb3NWV3ZyN1ZqVU9WcEZL?=
 =?utf-8?B?SlcyQjBOZVRpY243bHNNdXBjaFVMMktwNUpWWlI4WTZtRFdicGJDejJVdnlI?=
 =?utf-8?B?ZEM3dGpVYVRuZEtFR3JpNTNVZHZGQVh4UGtYemR6ZHNpVlZ2NkNSN3c1MWNR?=
 =?utf-8?B?UE1kVG5YQ3BlMXF2Z2RWejJCYktzSG41R2NxRUhMcmpiWmlzdEhnOGl6a2FS?=
 =?utf-8?B?RDNKa3NiQ09JYXVDVEZ4VkM0dzhWa0NSdFdZV0x3SDNhbDY2UTQyNVpSR29Y?=
 =?utf-8?B?SG9yVDNnM2RMWjNndS9SM3UzTi91ems4dVR2TzhLWS8xNGV6MGJnamhDdjZF?=
 =?utf-8?B?UmsweHRobzRIRmttVnQ4emxhUTJ6T1ZjVnZwVUcrY0dIUENtL3FJU3VUak92?=
 =?utf-8?B?VFZIWHR2VWZWaFBKNWg4bDN1bHA2UlpKSkpqQmR4Qkh0LzF2ejByR3RXRC85?=
 =?utf-8?B?WlQ2ZTc2YXRjVWUwNkxBSWdZWkh3cWRhUndQWElBYmpYVWRpTWRJUnRvblNp?=
 =?utf-8?B?S1JHMS9JK1F6SXJNODczTjBSbzRGNzRvM2k2MlY0VTVLYTh3NnkraktVZHZy?=
 =?utf-8?B?Vm84cDJlNklIMnhRdGpxODYrTStQOXk4YlB5aFhVdTNMcC96T1lWRDdXaDZa?=
 =?utf-8?B?dHVFRkl2M3QxZXVBY0gxa1VOUHYyNnpEdEJnaHI5aW5YWFZDajNYMHBHN1Bh?=
 =?utf-8?B?VXJ6YVdVbkNkbDcxaFpCMHEyMUwyWlZwK0JvNG9nc2tEdmFWdGRtMlQzc0pC?=
 =?utf-8?B?elUwTmhEY0dDQTlJRENpcS9sWGp5QThycFlZdTNwYXFoR2NyeXg5b0FmZUlI?=
 =?utf-8?B?MnJWLy9zVTBVVWQ0TDhRNlhmc21KeHU2TnZRakFYMzZEVlZUTFZMcHo5VHhV?=
 =?utf-8?Q?aD/mIi80zGx33mDI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D05BB299B76BE4ABE139F3EE23D5E78@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: l3ZkpmgRkRzLv11Uvo3eCFiM522rnnoIuO7ZUoooae4obftGUc8//BZUvZS2avg5H8OtdQV4gIv4jw6JBb7hfutuws4E5pj99g1S/DDBe0w0I5ZqfoWKYSsbtsnwFcXRMiE+6j4uMJ4Hs7dJitECo4neweJh8dMnE1HCWPjf51DkUo11R0FWu+LibeXKLCCBcgsjMbw5rfklsCER4B8xNUHPBFtJyWSB23Yi9ueGNJQv6fhqx/1nSBkuZZYnbxmV+hv/bfVCvfSvlU0QyLrmozqTfwuxw/nLY+EEhbp4+hO1PYksb9bfc93eZi+eUdAqzH29Tqpgly12l92qiwdxFw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a94131-836e-4d51-0e8e-08df125da22d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2026 12:42:27.1999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtoHh3+vOmUyvlrz+89FEw0JPj807fbeqGome17g2v8cjc4sC5+xmGtfumyqbNtAav7hDxSvZE86TY/wLTMMWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR03MB10496
X-MTK: N

T24gTW9uLCAyMDI2LTA5LTE0IGF0IDA5OjAyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlDQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gV2lsbCBwYXNzaW5nIE5VTEwgZm9y
IGRldl9yZXFfcGFyYW1zIG9uIGZhaWx1cmUgY2F1c2UgaXNzdWVzIGZvcg0KPiB1bm1vZGlmaWVk
DQo+IHZlbmRvciBkcml2ZXJzPw0KPiANCj4gTG9va2luZyBhdCB1ZnNfcWNvbV9wd3JfY2hhbmdl
X25vdGlmeSgpIGluIGRyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBxY29tLmMsIGl0DQo+IGhhcyBh
biBlYXJseSBjaGVjayB0aGF0IHdpbGwgdHJhcCB0aGlzIE5VTEwgYXJndW1lbnQgYW5kIGxvZyBh
DQo+IHNwdXJpb3VzIGVycm9yDQo+IGJlZm9yZSBhbnkgUE9TVF9DSEFOR0UgY2xlYW51cCBjYW4g
ZXhlY3V0ZToNCj4gDQo+IGRyaXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uYzp1ZnNfcWNvbV9wd3Jf
Y2hhbmdlX25vdGlmeSgpIHsNCj4gCWlmICghZGV2X3JlcV9wYXJhbXMpIHsNCj4gCQlwcl9lcnIo
IiVzOiBpbmNvbWluZyBkZXZfcmVxX3BhcmFtcyBpcyBOVUxMXG4iLA0KPiBfX2Z1bmNfXyk7DQo+
IAkJcmV0dXJuIC1FSU5WQUw7DQo+IAl9DQo+IAkuLi4NCj4gfQ0KPiANCj4gU2ltaWxhcmx5LCB1
ZnNfaGlzaV9wd3JfY2hhbmdlX25vdGlmeSgpIGluIGRyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBo
aXNpLmMgd2lsbA0KPiBhbHNvIGxvZyBhIHNwdXJpb3VzIGVycm9yIG9uIGV2ZXJ5IHBvd2VyIG1v
ZGUgY2hhbmdlIGZhaWx1cmU6DQo+IA0KPiBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1oaXNpLmM6dWZz
X2hpc2lfcHdyX2NoYW5nZV9ub3RpZnkoKSB7DQo+IAlpZiAoIWRldl9yZXFfcGFyYW1zKSB7DQo+
IAkJZGV2X2VycihoYmEtPmRldiwNCj4gCQkJwqDCoMKgICIlczogaW5jb21pbmcgZGV2X3JlcV9w
YXJhbXMgaXMgTlVMTFxuIiwNCj4gX19mdW5jX18pOw0KPiAJCXJldCA9IC1FSU5WQUw7DQo+IAkJ
Z290byBvdXQ7DQo+IAl9DQo+IAkuLi4NCj4gfQ0KPiANCg0KWWVzLCBib3RoIHRoZSBxY29tIGFu
ZCBoaXNpIGhvc3QgZHJpdmVycyBpZ25vcmUgTlVMTCBhbmQgb25seSBwcmludCBhbg0KZXJyb3Ig
bG9nIHRoYXQgaW5kaWNhdGVzIGEgcG93ZXLigJFtb2Rl4oCRY2hhbmdlIGZhaWx1cmUuDQoNCg0K
PiBBZGRpdGlvbmFsbHksIGRvZXMgcGFzc2luZyBOVUxMIGhlcmUgZGVzdHJveSB0aGUgY29udGV4
dCBuZWVkZWQgZm9yDQo+IHByb3Blcg0KPiByZXNvdXJjZSByb2xsYmFjaz8NCj4gDQo+IEZvciBp
bnN0YW5jZSwgaW4gdWZzX3Fjb21fcHdyX2NoYW5nZV9ub3RpZnkoKSwgcmVzb3VyY2VzIGFyZSBh
Y3F1aXJlZA0KPiBpbg0KPiBQUkVfQ0hBTkdFIGJhc2VkIG9uIHRoZSBkZXZfcmVxX3BhcmFtczoN
Cj4gDQoNClRoaXMgcGF0Y2ggZG9lc24ndCBjaGFuZ2UgdGhlIGJlaGF2aW9yIG9mIHRoZSBxY29t
IGRyaXZlci4NCg0KVGhhbmtzDQpQZXRlcg0K
