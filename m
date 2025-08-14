Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5401FF1C7
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 08:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755158450; cv=fail; b=impaIT8ft8lxQbxemHp2SRTuREynUZK2QwhkQpjBG/Dbs3nZfKDVh0EUMgxWfdPDQ7lM+IshsgI0hWWG5aQK7nPmgRiYmAi5agvMFvZv5teGJBJn/pNb68SO8dNckdMwsKeufNqdxbp+HfNVXMOgu0E988BgttO33MeXLpf5pb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755158450; c=relaxed/simple;
	bh=QEYZH+XDGLiXz7vCCvbOUBgten43JrKRgJZC1+JB5/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jDYEwSdSOF0ExU3syBETg3aHXbvqnFj9PCd45zoTbN3MGIne1Z8nCOwQ+4C5j7uz6GIXOFNGofRlvQVv5PPmdAX6pbhrS4YCoAtLIwOS/poTrJVVux+c4K23jkZpFVLSuyjuznZEbMQkcmB2EUmZUX/0Gak5bmgDvPmUrKw6ovA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OvZuToPt; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Qsirq2CK; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OvZuToPt";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Qsirq2CK"
X-UUID: c6c02eaa78e411f0b33aeb1e7f16c2b6-20250814
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=QEYZH+XDGLiXz7vCCvbOUBgten43JrKRgJZC1+JB5/Y=;
	b=OvZuToPtBg7aFloV9U0T6Nrb6xXOGe9B+n6+lHXrQtBW/OyWIPGT+jz/TFWdZSfr30KlEUahAcapgbrhvB+REoye1fKKhuXR+eH6KXgCm/rru+c0Gv69Tu34xY521+c9Ssnb0SXzDedyHdUnem4YXWPt27P/HfrCljgn7XGTUbU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:c311e756-3648-4538-a49b-f56ff0ba744f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:630cedf3-66cd-4ff9-9728-6a6f64661009,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c6c02eaa78e411f0b33aeb1e7f16c2b6-20250814
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 986707549; Thu, 14 Aug 2025 16:00:43 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 14 Aug 2025 16:00:41 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 14 Aug 2025 16:00:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBl+QAvYeRxUfmPUFGfa6Bi/Equ9rSt+XPn3M1EnrzR0+9+C12i1VlSpsDP/TrRoQHDXQHSMHYuOVLEr575Jmu9AsiStM8/9GCO8l4O4ta98lr0lUQfx27o3R2ftVJAB/1Tjcl/HpFqVYams10spbFRR0PKTFYAHKdo3GuKHsEX77owZHMabvSeaQVdiO8jwCkFYt+lJSjk9Fc6Es/dh8k/S/fADUsHU+qu4gTubznbsgtT22lKiap4jrNqCfYo+Zkgfm0zn5myELV+NmhDcdPx0j774wmP0QE+jQqGaDDyhSzhDs/0hwXmRQqmSQYyzmyQRoQbMjbqYRIuUU4AttA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEYZH+XDGLiXz7vCCvbOUBgten43JrKRgJZC1+JB5/Y=;
 b=WlwkZM3yWQxnAWy6t5lKVU/bP5iUChLaSut6oSBJdwhATGiL/GHpUv3MBMoWdYJfkciJm/rf2VUmgRaAFSkCXffnewvrxPidZVGgeBvMfL5mdLW+1zsOI34NG6MrTavMIS1b7NWCplH+XsjHHSB8F3xKHEep/aH0D+eezozvzJgjiQ190l2dtLRdmCbsGJAeS9YVP+blshb3fZjE/JRGVo/qBv1pk1mrAm/Kt/cm6IN9qR5HaL97MqXumJLQLprHHj0xseLN0Ra/bsYt/4tfNTnQ+XM1o+NjRGUY1pig4TzX0vCKDI6dy38hH5todt6+ezRGXm1bh+W7+w96vskRxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEYZH+XDGLiXz7vCCvbOUBgten43JrKRgJZC1+JB5/Y=;
 b=Qsirq2CKIN/ZFFHvRGcNgiwCAeo0nUVVf0JPmFxzn24IIIsiWyki0LUv7Ra8XExeALfIkyhllvoPSAGzCAzxQv2zkRqEpJ/wDzrUWulOx9dPHgrYf/43+tlTXLYnFKLrkGlfg4jKcVZXHC1VIqlA7NpW3jfR0bFzw1vp1mqON0M=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7337.apcprd03.prod.outlook.com (2603:1096:101:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 08:00:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 08:00:36 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 4/4] ufs: core: Rename ufshcd_wait_for_doorbell_clr()
Thread-Topic: [PATCH 4/4] ufs: core: Rename ufshcd_wait_for_doorbell_clr()
Thread-Index: AQHcCtdo7AdJE9MAlEyqkHCv+jyHgbReul0AgAIHuICAAQtDgA==
Date: Thu, 14 Aug 2025 08:00:36 +0000
Message-ID: <c0e7d95206e44cad332b65cc722700c327585eb0.camel@mediatek.com>
References: <20250811154711.394297-1-bvanassche@acm.org>
	 <20250811154711.394297-5-bvanassche@acm.org>
	 <f11710482738e2550ede731eb8699a2c9967fe8a.camel@mediatek.com>
	 <b707f40c-707f-4ef4-af9d-915dd8d5ea52@acm.org>
In-Reply-To: <b707f40c-707f-4ef4-af9d-915dd8d5ea52@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7337:EE_
x-ms-office365-filtering-correlation-id: 4821a4e7-e27a-405c-16d8-08dddb08a72a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?THFyOVlrNzBMTWFFbWM4ZWNDUnU0SXJLSzlDNTdyMTI5MUZObS9jL1RMdVBD?=
 =?utf-8?B?TmxRTDVYeUJvSUNETFZ5ZWVTZ3dmQWFwQmtJK3M3b2JRMFVJaGVoYkxLdmNk?=
 =?utf-8?B?ZkQxc0piMkc5VmU1Unl5cG5UNGpDUmlnUm9qRjBMUmh2SngxcnliMnBUTTVu?=
 =?utf-8?B?V2FZaitPdmVvbUZGMmd6OHV3Ri90VHFycUJxZ1pISGRxVXlscFQ0bGRWOTFG?=
 =?utf-8?B?amN6QjRyTy82RlpnZDQ1UTNoaDNvaFBOcHRLREh3SXRBQUxzd0t3SFhYcWcx?=
 =?utf-8?B?ZnY5M3dXME5lWDVkSUdSNlNjRzhQMTZOQmpLRURsY2YzZzY1b1Z1bGtlUFBr?=
 =?utf-8?B?a01SM0RTZlI2RmZ6OGhqSWt3dE1FVzl5bTk1VC9SZGIyN2hNN2JjeWttRXhI?=
 =?utf-8?B?SzVsNFZoVnphVktybE95ODlSSmVBdUZEUXppZVdrNWhYL3k0d1VyMytrREJR?=
 =?utf-8?B?cmRQVWUxTmF5Zjl1Y1V4cDhHWTVpa0J4aXNTM0VkRjRYTHNrQ3UwbmdnL09Q?=
 =?utf-8?B?aWVzZnhycVgwTUs2c0tJKzhNdVRXUWRtbFVNNGlEWjlvbnVmL0RXdGpieExv?=
 =?utf-8?B?Nk42bWRxa3NuOW5vY21scjF3MW96b3dzYXlnUzlOVHdDdmt2NktNempwQjFt?=
 =?utf-8?B?MG9teElQWElHbVp6T052WWJmNmVQSUtwdmRWMFNXMHlJZXNPcEpnMy82L1do?=
 =?utf-8?B?MWlTSlBINXZuTTUrTUNBdmlOR1pudVZBaWRWak9CZmdKL1BHOUk5ZzRvcEJO?=
 =?utf-8?B?ZEk0WUZGSVMwSlVRTXQ3NlFpWWtMMkhoK0Rjb3lOeDJyT1dnb2tOSExLME1E?=
 =?utf-8?B?NFpMT1ArSHphbkUvcENYUUMzSDJJcU56aHRKdnBpTzRJaGxkRGZWR3BEYm8z?=
 =?utf-8?B?a2kzM0t3dU5aYzNnbDI3WDczcFY2bUYvRGY2RnNBQU1SamszMFF3L0g3aU5Q?=
 =?utf-8?B?K1NuNkJ6aFQ0cGhXRG02elFqTmdIa0hjaHBtYW1vL2RkTEMrOVJ0dTBPTlF5?=
 =?utf-8?B?QkJ0dVpwaTRuQ3MzcFNBUzUrbHRGczhsdzdnMW56SlVGVkxBY1VjSThjYnFi?=
 =?utf-8?B?M3dRMzJtUGZWbU5vQkw0cGY1c1FaeTV5VmVBdXRwTVJNTWRLU0tSL3c1c1Bm?=
 =?utf-8?B?VVE4YnBKdUthb1ZQSUFnaDAvbHNvL0JsdXArNy9uTjB5YWtjRi8wWWpoTHR2?=
 =?utf-8?B?OTVVc0hSckQydmd2ano2QWJ4Vm5ycDN5YUU3VXh1NUJia2FwYncvTkQ5NUNN?=
 =?utf-8?B?VjNpbzBxTUNzQldwYWhSZCt2MjRodEVDbEJ0TmpvWmFtTFZNRW5NbHRJck9a?=
 =?utf-8?B?QzlDRUh6TXM2ME1Xa01iUVZwRmRCZUc2VEhkM24wbC91MWo4anZqSVhRZkJV?=
 =?utf-8?B?S0JjK2lJa3N1bVpFQWNBSnVXVEVpMFNWV3pkdVB5aXBoejVmcE92TnFoWWNS?=
 =?utf-8?B?R05GejIxRlFCSjZyck44OGV4ZG5JdHR1eEV5N1JFNS8vcmV6UmNSdlRwampn?=
 =?utf-8?B?cTRQbjNOazVZZlBoZXg1ZkVoa2lhdUJRemg5Vk5mK1N3OUNPdU93ekw3Mnl0?=
 =?utf-8?B?ZWRvWVFpa2FFL1lVZk9Dd051c2FkcFdGeHFqanpSeGxCK2FobnJXb3Vyc3k5?=
 =?utf-8?B?dVg4RHkxclBhM2NMSnkvYUpLOG93Qllmd1lXNkFuOHpWOGdwb2xPZHBZUDRh?=
 =?utf-8?B?L2VYV0owUU5hRDF5SDdSQUZpcTlkTDNNbDZFalIyUWtibkhGYWJnRldUYmxh?=
 =?utf-8?B?UzRuNjNqZGI4RnozUUVHYzdHa2RwWXkrbjdQVE9tVDJlN0VQbVc2bFE4bW1w?=
 =?utf-8?B?OVM4bXFHdGVsdFZwQTNTVDY5bC80UkRwV3dHaGg5N0NIWFJxb3kyLzdDRGtm?=
 =?utf-8?B?VXFPbnpyb1l0U2Y5Q1pJTjFudHdlRGZ2eVd1V2U5eVhiWE5RUXJ4dGtXTjhp?=
 =?utf-8?B?ajl2U3NQWXVKNDA1ZlpoTmN3MUZjU21XL0t5RWpGMEJObFA0VjFNRFg0azc2?=
 =?utf-8?Q?86T4kWiw77g+d6A21Dwkr1izI5olgI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDFQSWtTUklhYm8rVEpCZFpNSURYMXNETk9hb0hxWmR6T2VyWUxtclFtMURa?=
 =?utf-8?B?YmhpNGlCQWdzc2NTcGptaHZWVGQrdUU3cVYydStDZkFHZDVkT2VqaEpOSXht?=
 =?utf-8?B?SHluckwzL0tyTWNzV29pY0pvcnBoenpBamNTK016dThiUjBLNytIRUxvZlcy?=
 =?utf-8?B?YkZNNTkxVVlCWVpRZmxMNDhWYmJHaCszWGlkUWZDanl2SEpxOVZWNC9RR3lX?=
 =?utf-8?B?VkQ1WWJoZk91Tm5vTVJQLzhjUU5adWp6MitTZVAvaTZ1bzBuc28vRm1wUzBr?=
 =?utf-8?B?OVRGa0lzRFR0cmNXWSttSGdCUldVRU5HRGJDUFNCMVdBM2lZVThheTZJWElk?=
 =?utf-8?B?RTkrRDJBaTZPRUVyUno2UlQwNFZEaVhNWFdnbzlydlBJUWhtZzNGcVhTc3N0?=
 =?utf-8?B?eUozSFdwcHVsZGJpSVMyM3lBUnRCL3JqUzRsOEs1YUJTWWZUbGxnZExabTRv?=
 =?utf-8?B?M1NBSnRXdnlKamE3R2xaWlA1UnFxVDkwYjNYQzdzSDhJYzB0UkpUb29LYUwy?=
 =?utf-8?B?Qkg2TnBFZGpycGgwZVFRM1FyZm45OHl3ZXhCeENJSTQ3OUdJNDhzUDR6bGk2?=
 =?utf-8?B?bUI3ZnI4TVI2SDVuV0pxa2lrTlB1WTUyWmh2cVVWZG1WZFFERG5RRDd3eTBV?=
 =?utf-8?B?OUo4U25tamdqWVUxOXYxbEZGYkZZRHRrZUhYZnNFS21yUHBkWlJSZDhyeHpl?=
 =?utf-8?B?QlZjRy9ySmg1Mld0bFcwWG5ISHNBZzRsNEhIamt5Zmd4SW5ha0dLYWRWK3JK?=
 =?utf-8?B?WEswYnVzMExiRzFkYUE3SVQ4czZNTUhPN0pBYnBqU3g0ZUs0N2lJRFFJaXpO?=
 =?utf-8?B?ZTZabVlHd0g1SjdmajhUM1RDY2pIRmhlSjJQMk5hQm1STkF1QngvS0ZBbERC?=
 =?utf-8?B?ZFlZWVVYUitJUTgzSUJza3JwcGZlanRYaWN4UEdzMk5Pd0ZVQWQydWhOSmla?=
 =?utf-8?B?WkllblZndE9KNnhqQm42ajJPNkJqY3h3QUU1UXlDTGcyUEZYbXUxQUxpcWlt?=
 =?utf-8?B?RWFDOU1qc3lpdzRqVUg1M0Z0dWZHaHJDTGpGMXB2QmVQVytURHpPTzN3cEdQ?=
 =?utf-8?B?TC80UXFHL1VPaUxlbkRjUUIzOUJXUWtwbWg0Q0ZRYXI5aWV2WURpeGlwNWtL?=
 =?utf-8?B?QnJSVlJmZlBhZTlwNnBDU0JyYUoydHdOaks2cGFLSEdFUDN6SXhtUE1jd2lK?=
 =?utf-8?B?c3FiWTIyaXA2d2NVNFhmdFlVQi9GdzVGWFBGQjZ2QjA0R2hlR1h4eWFoSStI?=
 =?utf-8?B?ekNwVHpXZ21LdjBNUjZET1hFMzB5T0NmY3I5WTFQMWV3YTJGRjNiY1pLTzRM?=
 =?utf-8?B?a05YcmlhcWRKZTRKN1JreThXNjhMTHJ1dUJFVXdJWXJ3dHo4dzRXTWhtQlgr?=
 =?utf-8?B?dnJaNGdUTWtZT0Jram8rdnBjVkcyK2FSOXZtNmw5b3oxUTNINlNoNXphcjZz?=
 =?utf-8?B?NUpqOFI1QjVuc0NwL3c2S2FyRGpvbmlBa3VhMVh2YU9JbTZFdW42dm9lbmJs?=
 =?utf-8?B?YWN1NHFDM21jQlZHbnNSdmZucmNoMnNMVzFZblZBN1pVUWN2MW0yT0xBbEhO?=
 =?utf-8?B?UlY4NFhNZUNEWG4wYTlRMjNzR2FmVkx3Z1Bvak9Fd2wyY2dvMGRvOFZJV2ZM?=
 =?utf-8?B?TXpiTjJsU3hweVlhVHJUckhzT1YyUkQ3VFJ5VjYvZnorS2hkVWo0ZHBZSW1D?=
 =?utf-8?B?eXFYZktFOVBMRThveDB4a1VncGNTWnhKRGtmL0xnYnpKVDJGTHl0S1hLNEhr?=
 =?utf-8?B?MERGak4xTWxEKzMybXRHNFp3L1JPeWRUZyt4ZVhlUnoyWnp1anJWdGVIeXFh?=
 =?utf-8?B?bEpzTkFsSkx1MzV4RlkxK3J5eUpyVUxuYUNPZENNTE9wUGNqZEpodk5FTjJM?=
 =?utf-8?B?dW1Xa3owZzZiSk9neXN0bDNNSng3RzZHOWxCTnFDQjVNWkg4RzY3dDdxUXU3?=
 =?utf-8?B?UjVLeEdlVzM4VzE4M3dFL0lmVUxWNFZ4eHFHSUxLUUpZc0R2dmdYYnZmckcv?=
 =?utf-8?B?Und6UWc1ZGxsdHhoaVNDaCt4SWhhNWEzaTF2VDNqWXJyeWh0cksrUzEzcWV6?=
 =?utf-8?B?anVqWjBETS8xb0QrdEl2VzdXNCt1RmZwdFFkRlMzcExSbGNmWEZ2THpxVnZR?=
 =?utf-8?B?MUNpR2l0VWJEZVlheDg1S1Jqakc0YVRIWndGNGlubjNhd0RKckdjVFNxamtL?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <818443C95106A440959EF2E0FDD11511@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4821a4e7-e27a-405c-16d8-08dddb08a72a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 08:00:36.7229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9B/5P8dhSNfTsfC2o/scFOM95kcxkC+r8qWgkCTK6igRXcoTyqTlt0KEIvhLQHqh72A+J2+nKamPvkU/qnAyoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7337

T24gV2VkLCAyMDI1LTA4LTEzIGF0IDA5OjA0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDgvMTIvMjUgMjowMyBBTSwgUGV0ZXIgV2FuZyAo546L
5L+h5Y+LKSB3cm90ZToNCj4gPiBBY2NvcmRpbmcgdG8gdGhlIFVGUyBzcGVjaWZpY2F0aW9uLCBz
d2l0Y2hpbmcgZ2VhcnMgZG9lcyBub3QNCj4gPiByZXF1aXJlIHdhaXRpbmcgZm9yIElPIHRvIGNv
bXBsZXRlLiBUaGVyZWZvcmUsIHNob3VsZCB3ZSBjb25zaWRlcg0KPiA+IHJlbW92aW5nIHRoaXMg
ZnVuY3Rpb24gZW50aXJlbHk/DQo+IA0KPiBJIGRvbid0IHRoaW5rIHNvLiBTd2l0Y2hpbmcgZ2Vh
cnMgaW52b2x2ZXMgc3VibWl0dGluZyBhbiBVSUMgcG93ZXINCj4gbW9kZQ0KPiBjaGFuZ2UuIEZy
b20gdGhlIFVGU0hDSSA0LjEgc3RhbmRhcmQ6ICJUaGUgQWRhcHQgaXMgYWx3YXlzIHBlcmZvcm1l
ZA0KPiBpbg0KPiBjb25qdW5jdGlvbiB3aXRoIFBvd2VyIE1vZGUgQ2hhbmdlLiBEdXJpbmcgdGhl
IFBvd2VyIE1vZGUgQ2hhbmdlDQo+IChhbmQgaGVuY2UgZm9yIHRoZSB3aG9sZSBkdXJhdGlvbiBv
ZiB0aGUgQWRhcHQgc2VxdWVuY2UpIHRoZXJlIHdpbGwNCj4gYmUNCj4gbm8gZGF0YSB0cmFmZmlj
IG9uIHRoZSBsaW5rLiINCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNCkFjY29yZGluZyB0byB0
aGUgTUlQSSBVbmlQcm8gU3BlY2lmaWNhdGlvbiB2Mi4wOg0KDQo1LjMuMi4zIFBBX0RMX1BBVVNF
LmluZA0KVGhpcyBwcmltaXRpdmUgaW5mb3JtcyB0aGUgUEEgU2VydmljZSBVc2VyLCB0aGUgREwg
TGF5ZXIgaW4gdGhpcyBjYXNlLA0KdGhhdCB0aGUgUEEgTGF5ZXIgd2FzIHJlcXVlc3RlZCB0bw0K
ZXhlY3V0ZSBhIG9wZXJhdGlvbiB0aGF0IHJlcXVpcmVzIHRoZSB1c2FnZSBvZiB0aGUgTGluaywg
ZS5nLiBQb3dlcg0KTW9kZSBjaGFuZ2Ugb3IgUEFDUCBmcmFtZSB0cmFuc21pc3Npb24uDQpUaGlz
IHByaW1pdGl2ZSBpcyBvbmUgaW4gdGhlIGdyb3VwIG9mIHByaW1pdGl2ZXMgZGVmaW5pbmcgdGhl
IGhhbmRzaGFrZQ0KcHJvY2VkdXJlIHVzZWQgYmV0d2VlbiBQQSBMYXllcg0KYW5kIERMIExheWVy
IHRvIGNvb3JkaW5hdGUgdGhlIExpbmsgdXNhZ2UuIEFmdGVyIGdlbmVyYXRpbmcgdGhpcw0KcHJp
bWl0aXZlLCB0aGUgUEEgTGF5ZXIgc2hhbGwgd2FpdCBmb3IgdGhlDQpyZWNlcHRpb24gb2YgdGhl
IFBBX0RMX1BBVVNFLnJzcF9MIGJlZm9yZSB0YWtpbmcgYW55IGZ1cnRoZXIgYWN0aW9uLg0KDQo1
LjMuMi41IFBBX0RMX1JFU1VNRS5pbmQNClRoaXMgcHJpbWl0aXZlIGluZm9ybXMgdGhlIFBBIFNl
cnZpY2UgVXNlciwgdGhlIERMIExheWVyIGluIHRoaXMgY2FzZSwNCnRoYXQgMTEyNSB0aGUgUEEg
TGF5ZXIgaGFzIGNvbXBsZXRlZCBpdHMNCm9wZXJhdGlvbiBhbmQgdGhlIERMIExheWVyIG1heSBj
b250aW51ZSB0byB1c2UgdGhlIExpbmsuDQpUaGUgc2VtYW50aWNzIG9mIHRoaXMgcHJpbWl0aXZl
IGFyZToNClBBX0RMX1JFU1VNRS5pbmQoIFBBUmVzdWx0ICkNCldoZW4gR2VuZXJhdGVkDQpUaGlz
IHByaW1pdGl2ZSBzaGFsbCBiZSBnZW5lcmF0ZWQgYnkgdGhlIFBBIExheWVyIHdoZW4gaXQgaGFz
IGNvbXBsZXRlZA0KaXRzIG9wZXJhdGlvbi4gVGhlIHBhcmFtZXRlciBpcyBzZXQNCnRvIFRSVUUg
aWYgdGhlIG9wZXJhdGlvbiBjb21wbGV0ZWQgc3VjY2Vzc2Z1bGx5LCBvdGhlcndpc2UgdGhlDQpw
YXJhbWV0ZXIgaXMgc2V0IHRvIEZBTFNFLg0KDQpGb3IgdGhlIGRldGFpbGVkIGZsb3csIHBsZWFz
ZSByZWZlciB0byBGaWd1cmUgNTI6IFBvd2VyIE1vZGUgQ2hhbmdlDQpVc2luZyBQQUNQX1BXUl9y
ZXEgYW5kIFBBQ1BfUFdSX2NuZi4NCkluIHNob3J0LA0KVGhlIFBBIGhhcyBJTyBkYXRhIHRyYWZm
aWMgKHBvd2VyIG1vZGUgY2hhbmdlKSANCi0+IFRoZSBETCBsYXllciByZWNlaXZlcyBQQV9ETF9Q
QVVTRS5pbmQgDQotPiBUaGUgREwgbGF5ZXIgcGF1c2VzIGFuZCByZXNwb25kcyBUaGUgUEEgbGF5
ZXIgc2VuZHMNClBBX0RMX1BBVVNFLnJzcF9MIA0KLT4gd2FpdHMgdW50aWwgdGhlIFBB4oCZcyB3
b3JrIGlzIGNvbXBsZXRlZCANCi0+IFRoZSBQQSB0aGVuIG5vdGlmaWVzIHRoZSBETCBsYXllciB3
aXRoIFBBX0RMX1Jlc3VtZS5pbmQNCg0KVGhhdCBpcywgaWYgYSBwb3dlciBtb2RlIGNoYW5nZSBo
YXBwZW5zIGR1cmluZyBvbmdvaW5nIElPIGRhdGEgdHJhZmZpYywNCnRoZSBQQSBhbmQgREwgbGF5
ZXJzIHdpbGwgZXhlY3V0ZSBwYXVzZSBhbmQgcmVzdW1lIG9wZXJhdGlvbnMgdG8gZW5zdXJlDQp0
aGF0IHRoZSBvbmdvaW5nIElPIGlzIHByb3Blcmx5IGhhbHRlZCBhbmQgdGhlbiBjb250aW51ZWQu
DQoNCkhvd2V2ZXIsIEkgYmVsaWV2ZSB0aGlzIGlzIGEgc2VwYXJhdGUgdG9waWMsIGFuZCBJIGFs
c28gZG91YnQgdGhhdA0KZXZlcnkgVUZTSENJDQpob3N0IG9yIGRldmljZSBjYW4gcGVyZmVjdGx5
IGltcGxlbWVudCB0aGUgZmxvdyBhcyBkZXNjcmliZWQgaW4gdGhlDQpzcGVjaWZpY2F0aW9uLg0K
VGhlcmVmb3JlLCBpdOKAmXMgYmV0dGVyIHRvIGtlZXAgdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRp
b24gZm9yIG5vdy4NCk1lZGlhdGVrIHdpbGwgc3VibWl0IGEgcGF0Y2ggdG8gb3B0aW1pemUgdGhp
cyBmbG93IGluIHRoZSBmdXR1cmUsIGFuZA0KbWF5IHVzZSBhDQpxdWlyayB0byByZXRhaW4gdGhl
IG9yaWdpbmFsIGJlaGF2aW9yLg0KDQpIZW5jZSwNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxw
ZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
