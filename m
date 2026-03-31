Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3278D1EEA54
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 09:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950126; cv=fail; b=X2HP57YuHJ6VsX6wCVGJZpZSugBtn2gq+qJg6TJpbVNS6DSRMXGTx6EECvgmF01m4TOfi1DC9Ptv33uD2ctTprjmLDd5Xm+D+i0BUXy/0v+ZoFEiupumzc1iSJxEUmQAOwyPkKZjAWEq8utPm1hLnDEjXjNyY/cdcSdRsf3DgeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950126; c=relaxed/simple;
	bh=DPpka059Hur7US08i9s+yfZK7k2UVnIOL+P1TA8ThOA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tuDc6lk/0X+j0uVsRHM+mhmEQfF2z7XJRdgUpemVOpl91sOoOSfVZT0fw8c95ypyU7IsnU3CVOseSMSoXBzIXSlSDAKZTYObqm5PMosjN0VuQR930ct9ko6Su/7jF5eB37QjqvDzAizAo9bVJ2dMP+DfHwK3d2WwwhjuGGRscac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qA4xtjgX; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Zf/b2D9r; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qA4xtjgX";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Zf/b2D9r"
X-UUID: dc2bf2962ce511f1ae70033691e9ac7d-20260331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=DPpka059Hur7US08i9s+yfZK7k2UVnIOL+P1TA8ThOA=;
	b=qA4xtjgXK4t8cRoI/CBkvlW0rpaKyE22RienAGzpdRUxp8OajZUkap0m9WxYPswWtJWxSVzwo4LCyTqQT8WHv3smp1JB9axFEyrgTFy1kiV+6Q/ggBpthmZKOyPf5XrsmtHu6n8BntfqsuTYG+XvcrAoWHxxB7i8ykf4uuHe9Qw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4e378305-b7d4-4039-a220-0a9c391821d7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:718ee68e-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dc2bf2962ce511f1ae70033691e9ac7d-20260331
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1068405378; Tue, 31 Mar 2026 17:41:57 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 31 Mar 2026 17:41:56 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 31 Mar 2026 17:41:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dua1iYghz1X8VMlzvOezTXS02bNZQJ82hLKxbg1FryMT0Fx4Zb5y+T2qqJbtaTfVv8HhFKOunHbYYVi7JiASR10Lq3H+RVKKnbxlUObRnw9P+xl4Bp74xcHd6un5RTT4nfSIGCnkokwWFlOGg4atEOPxnmmdHXi4ji3FbCrBE/kuIurEZlOlV7F7MCWTMyEqMH3hc4PXo9Ky8Z2nxrb+fJ3HMVGGaPHRPlTuPnc1FxT1/GdZYg+CmLIMqvh3S2Msdc5AgpOSEpK6MwDRB14M1mzwPNTyOIfFsU2D392HGiU65e2421d9znihJ1l3iE/JkHICmqGgY/WB55SJa2Xopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPpka059Hur7US08i9s+yfZK7k2UVnIOL+P1TA8ThOA=;
 b=eWnDX2jMd9bkVSmFsWCa9IovkSf00sCqCuGwg4GmKqA1hCWXPrbK6DTfvtBMIlWw2nH9p8LnI54wXaFXYTvJ8fdyR3jJdOAyqwlyLPQEHbASkacg09A0GzFnUg41F4/v/grWjlrkkXxR9JIBAe9Y58JzMc9uQE8miJiqpQpH9Og+VOAyFYKiqmXUWitebQkov9aoc+cEeee4n64uVt40mZEZaoIDv/NtFv7m7vuTy1hBZBgTGA+ZETl4tKGP+VZj2rhx2w9UHtV/9NConQFc43MQLQ9Z352oTZ28cFXFISzJEnzCTovCVUAG+cmX3bxtXt9RtN6coo/jOBnZcFIGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPpka059Hur7US08i9s+yfZK7k2UVnIOL+P1TA8ThOA=;
 b=Zf/b2D9rx+nFOEG4GAe0Wx4X0MtBBFSdTF27tILdyWNi8C/hd/vlTMEq3sgL9/H4Bl6m37snIuYaPpj3oWU6nw/TC9CWbw4/DD3bAoxHTTpwEXRsWoRu1XqGuXp3Ttu1BUdtrTKPxo1XQ6yA3VUvDgTIMeIRazU5/Kqz5Q4fopM=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by KL1PR03MB8516.apcprd03.prod.outlook.com (2603:1096:820:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 09:41:53 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 09:41:53 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chenyuan0y@gmail.com" <chenyuan0y@gmail.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Thread-Topic: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Thread-Index: AQHcwHPS0LRtMwK95kC+/vV31GyfvrXIZE6A
Date: Tue, 31 Mar 2026 09:41:53 +0000
Message-ID: <4685d17dbf09397aef70c2e2b84ee13f1c48d4cd.camel@mediatek.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
	 <20260330183311.1941942-2-bvanassche@acm.org>
In-Reply-To: <20260330183311.1941942-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|KL1PR03MB8516:EE_
x-ms-office365-filtering-correlation-id: 9afe65b3-5125-4873-eb63-08de8f09bdf6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: uVkHOlJGeVQxK1C07/xIl61xuWUPecPGTZhieuER89HNtXn6hVNSh+VkUJzq24dmaSGzk/qM+nGPDQ2itQSvOeCqyzHfUtpJ1ts7r8JvLAonU5aEcIo3myz8j9gs04jcfxL51y+SWXY/AzgcKq/1NUpS4OIYqe93wJACEV+YL9gxTRM5zO8yEFFz3GBlh5RGbfvTKixqUidS89NXoVWV3cg2ewdH7PtuvMli1OzQzwC4hIVjDhDvm+TOA++i9htI2l9mzVSMbY9lTzOhnRwP3YIqckZf3lOF/3snQZYygROz1ATqADI9v60XpAW56YRjiQEtEU3qqhSZXD+JJ28lRyr7o6AN6R/Dw191B/5XOzZfz2FSXagC+9hlmdl6l3+4tZ3UlM69A4GqXhzDteWj1UkMi5M28dZsKMBOTKhggBuT/QyJen1BovNyHrqIVYiqhAX6DyG0cQVG7xZSzDq7fqrY0bJB59fXaP0atX5ndBP/FktLh+r1dEGVC/Ji8qyUNFwB7kJLAonOWdGl5E+ozRpH8wCfM73b2bh2KC9wbMbLH/o0jueDPXxnqu6wLi2ud6oBs67WFd2WWXlMTgMaCKmNlcqc8PBk27QFA4iduO1GXVOO/y5nHXxBviA67Umzm/mv4dI6xJU9PelxMCapHqR1AUOva/9SKiSnOx13zRmQdAaf37EHqngCfn3H4MG5YVCrQcXjdq3R/9TVwMZPDDeXUulkS+wszPYnImm7gExOE20afxVOp0aLeBb9KTquA44xdX+IVF013Im3MHc0A7MU7F9+yQTn52ZHPxhFDAg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnFhTXJkRUU0SmJ1aXhyQnZETWQrV1lUTWdqb0Q3K3BuY2YzVUpSK2J4ZnNW?=
 =?utf-8?B?eURVS3F5TDBoZEM5YTVOOURjZVd3NHJPc3VOUk9vdnNRdWRZMzVsYVpIZXFl?=
 =?utf-8?B?QksvcnZNbkNZMUxqbWtCQy9zbktzZityREpmVnBFL2RlSCt3MlBpeUhSYnhH?=
 =?utf-8?B?andlZUFvMTdGRTR1WjVsdFpxdDNPS293c0IyUW55TTA1RUpZZWk4UnpzOU5S?=
 =?utf-8?B?NSt5OWoxQWl6UmsyTEhyVFhjaWVGdjhiT09ZUVFqaVlzR0FBL0YrZnRaclk2?=
 =?utf-8?B?c3ZjWkQ4NDY1ak1VNEZrV2pzZG96bEJKdnF5MDNEQ1c4OVFkQ0dWbCtQcisx?=
 =?utf-8?B?OXFPT09NTVNsbUdxY2lZNWtyS2d4SE5uY281R0tLZTgzT01OOThsTjRUSExm?=
 =?utf-8?B?aUM4TDJocXNTK0VSenQ1dDNjT0g4NXJEWkdmQWhrTW5yaS9ETDJnNldIOVRW?=
 =?utf-8?B?TDFPZVhpS1JXSkZ4M2xaNXRaOFZBbE5RRlk3YU01SmdpcUVWSnRodEJzekZN?=
 =?utf-8?B?Y0MzUU1rUjhWRGRqdUVhWk5qRzRXZzJlK2hnWWFNOWxvbmdlSHc4amdTOGlK?=
 =?utf-8?B?SzZHd0x3cWRnWngwNmVVWVRxRVZEZTBEUVpJVmZFVWl6ZEM4V05RQWswQkYx?=
 =?utf-8?B?SnBqRUkwVGRYZkJ5VWkrQzcvc0k0RzNvVGw2b2N3TDBJbHkyRXRBODBIaklY?=
 =?utf-8?B?YkxKcUowblB4aTd4THppZEY4ZmlaOW53QjNUbTZzc1NUVk9sbmg1cGwzVHJV?=
 =?utf-8?B?R21aUHQ0bzQzcW9tTFZRUGl6U1M2aFJWK1NlYmZHUm5UQTVvL3hmMnY5aTVB?=
 =?utf-8?B?WDVwaEhMRWxiQlhhZ3NqakRIMjdFZ05ncEkyWHJSTkZpQzIyU0c2UE9xaDZM?=
 =?utf-8?B?WGlkOStoK3dTdW1ZSWc2TXp2a1FvUzA4ZjAxcFYxMDR2ZWYwOHM0VnIzSlBM?=
 =?utf-8?B?UFEreDVjZUo2V21mQ3h1RXlFd2RMVE1xbHV2aWx6MWtaUFRXZldhbHArZ1dH?=
 =?utf-8?B?VzMvOEgyUUhDSTFvL0NGbFpKOURXMEc1NGJMRnVnUXFyM3lBakpoS0cvcFFh?=
 =?utf-8?B?MzJmVUpEaGpjRVNwR2dRM3ByMFNGc01MS3pCU3F0T3c0OFF3eGpGU3htR2Zq?=
 =?utf-8?B?emtQcURuNUh0VzFBMEkvby9zWjNnb2VIcXVDckJhZGlMOE53RzkyRExFSzRT?=
 =?utf-8?B?Ykp2bVZlYmRFbWNXemlyVE0xNHRIQmQxR1FxdURIa2YzQlk0R1FXaWJpQVB4?=
 =?utf-8?B?b3VkNUlSaGpzanJhdnRsckdUVWs5U1V6a3lEdU56Z2pLeDdEVk1FMU00cUFM?=
 =?utf-8?B?ekxMVzlZb014QVdLT1dHVTFhTWtPKzUvK1lUdWJxd2UxZktQWDROWDNiNTJ6?=
 =?utf-8?B?RlM2ZmozR2R0UTc5SUxFdFU2SGpFMFhMeTVXL3VGTVVRekhmNDNjYVRjM2Jv?=
 =?utf-8?B?ZWEzYU02MHFYY0UxRWRHSUJQMEdIMDF6ODVhN2hRVDFpNjM3OHlTRWlEUHR6?=
 =?utf-8?B?L3dQdHg3aUhvNnRkNmxJeDZHdkZ5ZGFzeEZJZWxlTUYrZ0J2YTFaKzd5bWN5?=
 =?utf-8?B?VGRDQ1JyS2gySGpJWjRJODlsUXZlVkxlbGdKMS9GWFFpT0xlSy9yRGY3L2pZ?=
 =?utf-8?B?WnJzeWhvWDRzNEUremhLUXdjd0F5bThtdkErS0lyU2FTRnU2RHZ0WXIzaXBZ?=
 =?utf-8?B?blVsa0dhQ1kyMndTRFRyYzhkV2FrMDN3RVV3UUpoRUJEQVJvVjhESTNnUkJV?=
 =?utf-8?B?NzVEd3BwWDBvTVhXVjdxN2tZS1FYS1RqYmxORWYwR3Rsb01VY3dWTW5ETlFY?=
 =?utf-8?B?YXE5bTB6WmRpZnlrcFRPR3NNTEZNL05ianFQaGhMRDRGYVhYanhpeTJaUHNp?=
 =?utf-8?B?VWY0Y0tKbE1kbFEvWWpndFpMZ2tPWUNJbzdDU3oxMXVIYngrN2tSeTl6RVFZ?=
 =?utf-8?B?cVRuZnpxYU9NODA2M29hcmdsd0MvcWpWNU9zamdJNUdyR0hRallQNmxoZkcz?=
 =?utf-8?B?TWYwSHg3bU4yYk1vR3MxbHVFaXRtdGc2d0RSK3BTYVVsbGRFQUJMWHQxQjhv?=
 =?utf-8?B?T3FhSTd1TjZONGF3V3NwK3d5T01HSDRKWUkvT3ltVEZyUDVkQVpKVURoY1RK?=
 =?utf-8?B?RE4ya2lpSGpzWkhJckpMNWxsazJWQ2ZoSDdvWE9hVWJrOGc1UVVTbktFRHNm?=
 =?utf-8?B?MlZnd1RTdmx3aDVZNFhjc2ZHcXM1QmVWbHo4cmpldDdiZkNJWEtFM0Q2Qm1o?=
 =?utf-8?B?eUdpOEFXdEVIdkg0dFBHZWdKTXF0MStxOVptT0hHcG8rdFpzOENUaS9QZkQv?=
 =?utf-8?B?d3NTNWNTZUkzdnZPVXJqMGVLbmFaVTg5SFpaMk1NYk5wOEZnOVE0SCszcmhN?=
 =?utf-8?Q?DSCr1gsxE9y+yxp0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A46B3ACB0152D942A332F58A5E89FE44@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GRwv71QAuNoyvPMdQ2TAYD0d3wsuzqS5b0P3SDcl9EtVV6TM4kk9j9sWQuKI0Kwkvpl/9aP7JvfFtG8xaJqHb7wFA+sV/k0x1sDn7Aciqo6vYGNnPpFsLfszdgg56mmRLaF+Z54k4HGb4LyhXW74ySSFwUI8Z//B1h+EzoMJwm67I96eP0NM5vYdGLakzp+MJdOy78UY+Aq7YlYxzKODKkrAjIvtHvGvVCUNyow1Zih+d1dj2jwn3KNGGuna27KzrGrLiaAhfh0meCdHMCLoIi9SQ3QCAldRgl+YK8Rc6cAfrFIfNKYgz1U8ISw/IO7JNdeSuEAlnsHyvXk3+vWDZA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afe65b3-5125-4873-eb63-08de8f09bdf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 09:41:53.7119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FSFj+PLxVjPAuTMntLxWClqTU9VRGAlXeAZ9WkbDLHTYz8RjrqBEwcq5N+WtW7fKLHDEW3n2izvFiwELFJ5nIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8516
X-MTK: N

T24gTW9uLCAyMDI2LTAzLTMwIGF0IDExOjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZXJlIGFyZSB0d28gaXNzdWVzIHdpdGggdGhlIGNvZGUgaW4NCj4gdWZzaGNkX21jcV9j
b21wbF9hbGxfY3Flc19sb2NrKCk6DQo+IC0gVGhlIGNvbXBsZXRpb24gcXVldWUgaXMgcHJvY2Vz
c2VkIHdpdGhvdXQgY2hlY2tpbmcgZmlyc3Qgd2hldGhlciBpdA0KPiBpcw0KPiDCoCBlbXB0eS4N
Cj4gDQoNCkhpIEJhcnQsDQoNCkRvZXMgdWZzaGNkX21jcV9jb21wbF9hbGxfY3Flc19sb2NrIG5v
dCBjaGVjayB3aGV0aGVyIHRoZSBDUQ0KaXMgZW1wdHkgYmVjYXVzZSB0aGVyZSBjb3VsZCBiZSBj
YXNlcyB3aGVyZSB0aGUgQ1EgaXMgZW1wdHkNCmJ1dCB0aGVyZSBhcmUgc3RpbGwgb25nb2luZyBy
ZXF1ZXN0cz8NCg0KDQo+IA0KPiBAQCAtNTg1NSw3ICs1ODU1LDcgQEAgc3RhdGljIGJvb2wgdWZz
aGNkX21jcV9mb3JjZV9jb21wbF9vbmUoc3RydWN0DQo+IHJlcXVlc3QgKnJxLCB2b2lkICpwcml2
KQ0KPiDCoMKgwqDCoMKgwqDCoCBpZiAoYmxrX21xX2lzX3Jlc2VydmVkX3JxKHJxKSB8fCAhaHdx
KQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHRydWU7DQo+IA0KPiAt
wqDCoMKgwqDCoMKgIHVmc2hjZF9tY3FfY29tcGxfYWxsX2NxZXNfbG9jayhoYmEsIGh3cSk7DQo+
ICvCoMKgwqDCoMKgwqAgdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKGhiYSwgaHdxKTsNCj4gDQo+
IA0KDQpTaW5jZSB1ZnNoY2RfbWNxX2ZvcmNlX2NvbXBsX29uZSBhbmQgdWZzaGNkX21jcV9jb21w
bF9vbmUNCmFyZSB2ZXJ5IHNpbWlsYXIsIHdvdWxkIGl0IGJlIHBvc3NpYmxlIHRvIG1lcmdlIHRo
ZW0gaW50byANCm9uZSBmdW5jdGlvbiwgd2l0aCBhIHBhcmFtZXRlciB0byBoYW5kbGUgdGhlIGZv
cmNlIGNvbXBsZXRpb24NCmNhc2U/DQoNClRoYW5rcy4NClBldGVyDQoNCg==
