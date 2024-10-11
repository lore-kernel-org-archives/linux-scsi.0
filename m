Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E81F4FDC
	for <linux-scsi@vger.kernel.org>; Fri, 11 Oct 2024 05:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728625481; cv=fail; b=WiMpEuyY0DVA+aNDux5oVv3bKxvDHeu9U4CgQZCncksIHgg2Xj2NnORrbzABwwe8nFZprYXA9dOsTDQXfFnOyyKkRpDYP0pko/AfUJWgESKHTq6Gs45zvqr+GXh+DsLUn+n2YrAUv3c2LZ5/n2w5UlgpsHbUivu5/LIOppJb6s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728625481; c=relaxed/simple;
	bh=8HCORqk1fvb3O+ROgFOoMqzJQD97mnhoQ57fSWD4FfY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ahGpl1jCUNW7in5VhosVZKR9VJScngL70OJTSgxkEPssMMAHFYJLFIXlXzNyE12+3Z8471QGkQSI6Nih6l+90s5bfLBjNmOsnIY+bY98PGt7j5nwHaS7frhO+4xtwxBI//vB9ZpYnG6uLrnmQM7vHsdmrydiju6/ZBeDN0T+JjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cFYl4Z5k; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=srzpdR/O; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cFYl4Z5k";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="srzpdR/O"
X-UUID: d84d5816879311ef88ecadb115cee93b-20241011
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8HCORqk1fvb3O+ROgFOoMqzJQD97mnhoQ57fSWD4FfY=;
	b=cFYl4Z5kywYDNIIS3+2Uhjl60o/3vOk2dJMJKpttBfVPjA9PkKhfdpQCZcZzjz6ZbxxhwTjQzbBsbquOmNtye7Ob2n08se7soJuA+uKHgv48bZSFlUUX7sBVMEJ7toMSvWGJLR/JN9/PjPGDijgPOjkIUnFZaJPgY0I6dzI3Huw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:b494ea37-9592-459b-b92a-d6d7af20803a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:a5341641-8751-41b2-98dd-475503d45150,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: d84d5816879311ef88ecadb115cee93b-20241011
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1097978622; Fri, 11 Oct 2024 13:44:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 11 Oct 2024 13:44:11 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 11 Oct 2024 13:44:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pcYIpZbX1lSUcKd8zMlg5t+oz9cVDONYocZe3fceuLAgw5P+nzbKBD9AOyoYU2kcH/zTuFz8pJT3jknRkExnuva25p4y33DuT8LakOTjTXOZf4KRpyY4klRTlAylOHh3MfkZ+kL/3C6r11YF9yYgeYG5TS1gWOTg5VZIfln0m0JifWTd1FgAKI6q2AdZzosKbPFj5xqcUQjKUzxMydhXb0x0t2gZcZBR8kjP+y/jBLyYoZbSrjmjQTlXate++d9dsfDeANVvmwEI+LD5u1qT95njTe/sHuNJEYWyGDeV1LA2bn6j0tfvloBl3dhVVVpZl0Nn1hv//zuhisnxCKXaFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HCORqk1fvb3O+ROgFOoMqzJQD97mnhoQ57fSWD4FfY=;
 b=wggdlFkIe79VR0WknE20aaFjT0+/0n98VP9uP2lhZ487duTBBkNroslCJRCB0Ifg97Z4ddh7XsIrR4/b8kHU3KfDEAYxCMzYX/m3/Bx98RYVGFJQgWhjBve3vUgP9wwyZMQ1kCbOG2ngc0iyW+Po0D5iBoKd/NmIvbgVTtcByUdNW4iv4trUtAglwJH8Z4UTp0NVcqy0volt2eEDpXlb7apd/psBJzdcBFpUL+4jjkH0RqSu4U/C0FQL834fenhCugEBBuCnY5BKqY4MFWs0qHdEw8Rw35mYNCkBplkdEEqSjm4Jr5dGwDaztZ0U+2mQyeJYEXUqtoXG1dK5vcXapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HCORqk1fvb3O+ROgFOoMqzJQD97mnhoQ57fSWD4FfY=;
 b=srzpdR/OQwOz68trWLHymFFpciQQNNEudfO6eapWE0Vw65vg97/nOWRZZH0JrKuxK0l8ZvNjhUc2wsbiPeMPYJgjGlifBirxeB959PNeZBSf2uaBhGwbVy3aYBrLFBmJaNIzpGgdfyd7qqyrlwVoYtIBn/7ThiKAWqc/Xxhn4Mc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8835.apcprd03.prod.outlook.com (2603:1096:405:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Fri, 11 Oct
 2024 05:44:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 05:44:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: wsd_upstream <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbE+Mn3m6Kz/z9nkigLrxdmIZYWrJyIqsAgAFGjwCAAg1bgIAFdH8AgAJNQICAAIKNAIABCVUAgAJVMQA=
Date: Fri, 11 Oct 2024 05:44:08 +0000
Message-ID: <25eca93981791a25a76d9275c6035e3f46ea6f07.camel@mediatek.com>
References: <20241001091917.6917-1-peter.wang@mediatek.com>
	 <20241001091917.6917-3-peter.wang@mediatek.com>
	 <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
	 <69a77b95da27fa53104ee74ecae4e7da2d1547cf.camel@mediatek.com>
	 <e6e93ff1-cba1-45a9-b4b6-7dcbd7fca862@acm.org>
	 <8c463196860b71f26bddad0e7e8be6aacd470109.camel@mediatek.com>
	 <a02c83eb-d057-48cc-9735-770928a2a0a1@acm.org>
	 <bb9280de1a6dde857f0f3fe8c784bd71653a5ec4.camel@mediatek.com>
	 <11c15e60-4d4c-46c3-b3e0-e1c4497378a2@acm.org>
In-Reply-To: <11c15e60-4d4c-46c3-b3e0-e1c4497378a2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8835:EE_
x-ms-office365-filtering-correlation-id: 73200da4-72b9-4e8c-eb53-08dce9b7ba19
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T0tORm5xdkwrcUJsNU1iZHhsdnByZ0RoNm1Ia2RZcXRjMmtpZGY5Rk5Yd2dw?=
 =?utf-8?B?NzY4MUNqUjNpSWllSjdqcHZxRk9oK3lyV3V5OHoxYnZQRHR5VlFiM3hybkhX?=
 =?utf-8?B?WlEybTBhT1d0blVJb2Z2R21wNng4dkJNOGxEVlNiN1ZNUE9NSHNLbkUxc2Zz?=
 =?utf-8?B?YmE5ZDRoTHhEMVRxcWFHYmRobG1ZZTBQK1hRTHhSL0NvOCsrd0NqNnpJK3BC?=
 =?utf-8?B?RnR6T3hDT0E4c3ZBZTJEaXd5RUhCUXFXZUxya1NKSXVxN3ZtSCtSaU1pSGNx?=
 =?utf-8?B?dEdXVi9ZNFFJb1FBZC9zN2Z1SUF2VjlySDlwVGd3d0FlRklwd2lnM0lqcGdQ?=
 =?utf-8?B?WnZUTitzRW53Q3ByK291bXZvU2tFb2NQaEFDN2Yrb3lJVi95V2xTTUFXd1VF?=
 =?utf-8?B?OUpVandzeUxqSkhqcGx4UTJCb3BsQXBXTmpTRllMK2gxZE9VTHd6dlVCVjJS?=
 =?utf-8?B?N3JSQXZHdmZON1VJb1lZbGhSRVgxWVB6R1ByaXFjeHp6d1FWSFFFaHIydEVo?=
 =?utf-8?B?UEh1MUJnbmw4dE1ESEdYamZ5djRITGZIeDdRMHB4NFhSa1gxMTRtVUxySTRy?=
 =?utf-8?B?Q1dwSnh2NWY1aVA3WE53VGNpUENEYVZtUTdwSE03N1NEQndLaW00SjljSXNn?=
 =?utf-8?B?cW9KZ08rV0NKNWFuRCtmQzQzbU1DRFRQS2VWcW85ZjdBRnlQMld5RThCUkR3?=
 =?utf-8?B?a3lJYnpSRHpPanA0M0ZwZTdjYmgrem55OVBnR1FraWc3NzNKYWJ5bkllak5B?=
 =?utf-8?B?Rk1LZWNDMzFISm5qYjFTN3UzK092a1FMWTkrNzlRbWZrOVVMdXg4ejJqa3J0?=
 =?utf-8?B?cGZReENpWUZUVXZMQzBWczRNRk9NY0l3eUs3TmtYZm5VL1lpRnMwTENVUlll?=
 =?utf-8?B?dkFsZS9LanFZQVRST2syd0IyekdxeWxZdmYrKyt3aVUvUE9NQ2pEeG5BRkQ2?=
 =?utf-8?B?TFl3UDFyS2RKUzI5THFpTUJaSTJKd2ZzYnRSZE42RVdsdU9wb2hkOHJrNUtX?=
 =?utf-8?B?Y3V4cWkybVhjSXJDbjV2M2ZHRWJYM3c5NnA3UUlRWjhIaExoTEd1M050RGR3?=
 =?utf-8?B?dEtvWFF4TFJvRko3amJmTzEwQ1FBNW41YmdnRjdkNTBoNTRHbTM1UCt0NXB1?=
 =?utf-8?B?bno5cGRJNFE2bjdKc2E5UzJYS1JQRi9Welk2NjR5K1VnaGdPYWRBaHpXeThP?=
 =?utf-8?B?SVAwSWoxNndFQldsaE1DblJZL0hIYkhwQTlEZGFzVzhMZUFGdGNIa0phZ0dW?=
 =?utf-8?B?Yk5VUy8yanhHYjJiSVRNSytmTFdKaXgwQno1OWJwNTlRWlpQWHpwM2JZcU05?=
 =?utf-8?B?VTd1VGJlRVQ3UUx0cDY1dEM4T0p4L3FTaHRnYzBQd3BZaHlKeUI3VWw2TG5y?=
 =?utf-8?B?QnNEa1BaWTRKWTdtL3BIQVViL3BNQnFjKzV1VkxQZkdwZEUwU3hZeUxtem03?=
 =?utf-8?B?SmNZdlNtaFFQLzIrcWpHRW85M0l4N3p6MjhHdU9FUndnblh1UGxCaEN3aXBR?=
 =?utf-8?B?dzRrM0NpSXFPTVVpU1kybFlNVzJjd2xGSktMd3QvM1hxZmxUUzU1UmROVzlH?=
 =?utf-8?B?TzFTcG8wK05FOHVyM05RdVU0dFdadUMvS2p4WkVwZ1pDOGhoQ2R1LzNUQzNU?=
 =?utf-8?B?ZVlCdEhFd1pNRXpzb3N1QkJWWjlxZVg2N1EzdzFBdTRoRmd3cjMzN0F0T0ky?=
 =?utf-8?B?dWJRaVl2cXoxcFM3THhzZnhxZnNiQWtoczZ6NnEvR3ZDenZWR21idS82MFJ4?=
 =?utf-8?B?TUtKSjFuMkFIcTlDWE9lMGVWWGpleGZTL0d3K1FZNkJteG5PK1dCUldJWjA4?=
 =?utf-8?B?d3Z2QVNGUTBkb3dNRXRiZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFBlc29QU3ZoZ3BZczVTdFB4WEx5WVNQN1M4bUVRVjU2UXpHbTV3ei9vYkcw?=
 =?utf-8?B?Zm5PSkU0QkJkaEdSV2xGcS9zSmNsOWpKSDBiYUNmejhKbEp6REozeUU1bGNJ?=
 =?utf-8?B?bk91enBZc0Jib0c0eFpyNzBuRFJxMk9NdkNEanBOWU9yaDh0OU04aDFPakdr?=
 =?utf-8?B?bUlXdG5rS09waVlvZy9wcGg3ZzFQcTEza09COHFFVnNzQy9xaHIzM0pWMTNE?=
 =?utf-8?B?M1M5RjN6RU1pVk03ejhMaHhVOWt5TmhxRmE5My9XMUllV0tzUmFEcllyUE9M?=
 =?utf-8?B?UWpGRC95VW9SMHNrUkVrREM5dXRmT252TzhwV25SUnlreFhNZ05FM2VRRnY1?=
 =?utf-8?B?KysyNEhDQjFUdWYzZU5vaGFlMWtvenVyQjRLSGZEVXhvQnU5cmZISW0xYmM3?=
 =?utf-8?B?U3pQamEwMHRmWjJ6cGZjUG1TekxBR25uR09RTmduN1dSVkY2YnoxRFhWUEF5?=
 =?utf-8?B?OVBWbXVUWWY4dkY0bG1BRTZLR05EbFNVelNkQmFhT2JOUDFrZDBLSFlRZHQ1?=
 =?utf-8?B?dXlEeXJVSmh0bFZuL0xISjcyb293cml6c1lwYklXbUpiYTNVcTB1U200UGpp?=
 =?utf-8?B?TUdpb3lXUWpRbnZYWUxBMUphTEU3VEZiMTZ3TlJ3Y0tsd2FvbFlTUXNNOUJZ?=
 =?utf-8?B?bVVCaENKRmFGMlJWcUc1T1V0UjJ6NXoveVdXL0JsT3RtTXBpMHZvc0hkZGQx?=
 =?utf-8?B?bmFReTVwYmduQXhYQXpqdk5UUUpaVTE2cmowbUlyaXhDRnVtZmZhbHVlVEFn?=
 =?utf-8?B?NGVJekY0VW9yWS8vWFRPZjdnN0lTK2tpRUhaUGpWRHVieFFoL29QaUJ5WGF4?=
 =?utf-8?B?aWJ1T01CMUtqdEh5ZVVyMjl1NDVtOWgxRHcybURyMVNGN0ZKSUs5UzA0WnFo?=
 =?utf-8?B?ZnF2MGVwUExMODVSWnJpV0dZM0NneXB1MFJvalRMYjM1K2FjckU4OHVrTHo4?=
 =?utf-8?B?T0l2N2NVTWlsVm8wK2QzZ0xxZmhLdHAxV0J6eGFocjJ3Qms1Mm93cGlNMnl0?=
 =?utf-8?B?NEhSaEViWXZ6R0UxSE9aS2g1QU5HazFTUCtQWU0ybjA5YitCZVdOb0JYWmI4?=
 =?utf-8?B?ZGZqSHd6Tzlnc0dLRzZkeXdSVExTd2ZQUDhaVjJUcEV5R2lLenkzSDA0bXlW?=
 =?utf-8?B?WlhXcy9ndisvUXRxbHdDcVJnMThIQm9WbnJLV3UycXh4MnlsMUxKT1A4V2hY?=
 =?utf-8?B?Vi9wT2lNa2xRQUFFTUxmTzdyc1Q4RzZVK3UvNWhRK3FuanBaQ3hscWIyTTFL?=
 =?utf-8?B?alV2bS9PbnJzTjRPU1IwQ0hEZnc2aUxZeHhhZTV5MStDWVQzWXNWTkU4R09s?=
 =?utf-8?B?WjhaM2svSERrdEJ5UHhzM3YwMUcwV1FGQUFJS1BWRWRzYkRIdldLZ09GSHNx?=
 =?utf-8?B?M3c0UjJMMlkvQm54VlBVRHJ3RXVUUnVpOHhIeE1iUlZteUw0bWlFZDFBbUxY?=
 =?utf-8?B?RitFVDNZYTJ6ZEJLV2RqN0FtT3JEbjRwZ0pibmc4dktZZUxLeDVvcmNNZnZZ?=
 =?utf-8?B?VksyS0tHZndOSkFsT0RaVnVPUWNkVGRDaWFSN3UweGlZaVN1bXVVTHUwZjlI?=
 =?utf-8?B?YnJUVXNLMHR6U3gxY05FR1BITXlCNHNCckZvT1ZhVEdlcnVNMktkU2d3YWts?=
 =?utf-8?B?NjhNRUFsZkNmRkJ1d0tRRFptYlIxbWpDanpmVzhsM2VGb0FhdzNJVk1jYmpi?=
 =?utf-8?B?S0pjSlY0L3BCVFB4eXA3VklKdWpUdXlxY2VRQ29odWFORWduSVVFcVNpbTlD?=
 =?utf-8?B?Z1V1TkQ1aVl3akNuM1RNd3U5bG9EbWxSV1lxOGhkMnFXWlJwQTRKeFJMU0hR?=
 =?utf-8?B?WEE3c3pMOFB3M2Z0MFlFSEZpZzdGZUZNODYwUzhvVTlmY3JRYjczbytrKzB3?=
 =?utf-8?B?Z0tVM0ZhcnRkRFFlRXRqRzJHNXVDaWlESDNRZHNBVkVwZGFTbkJuU3d1U3p0?=
 =?utf-8?B?NERZRjFtOEhZMi9EVlMwcVN3bTBzbFpySnpPSzVnbmppR3lIOXhIQm9ZVjZQ?=
 =?utf-8?B?NFFUVXM4VkxCMFpOZzB6Q05uazgvdUZGMndQWitpT2JDWGt0Yzhzdk51S3FT?=
 =?utf-8?B?NW9YY2g5QUNwYitIOEo2Nk5yaGF4MjVIN3pQbllnYjRyTFJWUUZGc3NXT3Bh?=
 =?utf-8?B?SDU5YmR0RWVWeU54Znd3d05RSzAyR20wMWExdm4vWm50cHUzODNjbnFzSVo3?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D69C9F6CCE19B04F8B450F2D866B75A1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73200da4-72b9-4e8c-eb53-08dce9b7ba19
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2024 05:44:08.9869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BKWtyf3bZ1PybSx3DkKrauO1DMW8orCICSDzACuoQVKVLgzSIvtEh54okhuq7wqdy926zozxR8MLXAKfIgDP+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8835
X-MTK: N

T24gV2VkLCAyMDI0LTEwLTA5IGF0IDExOjA2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgDQo+IE9uIDEwLzgvMjQgNzoxNyBQTSwgUGV0ZXIgV2FuZyAo546L
5L+h5Y+LKSB3cm90ZToNCj4gPiBZZXMsIHRoaXMgcGF0Y2ggaXMgb25seSBmb3IgTUNRIG1vZGUs
IGJlY2F1c2Ugb25seSBNQ1EgbW9kZQ0KPiA+IHJlY2VpdmVzIE9DUzogQUJPUlRFRCwgcmlnaHQ/
IFRoaXMgcGF0Y2ggZG9lc24ndCBtb2RpZnkNCj4gPiBhbnkgb2YgdGhlIExlZ2FjeSBtb2RlIGZs
b3dzLCBkb2VzIGl0Pw0KPiANCj4gQWdyZWVkLiBXaGF0IEkgbWVudGlvbmVkIGluIG15IGVtYWls
IGlzIGFuIGV4aXN0aW5nIGJ1ZyBpbiB0aGUgbGVnYWN5DQo+IGZsb3cgZm9yIHVmc2hjZF9hYm9y
dF9hbGwoKS4NCj4gDQo+ID4gRnVydGhlcm1vcmUsIGV2ZW4gaWYgdGhlcmUgaXMgYW4gaXNzdWUg
d2l0aCBMZWdhY3kgbW9kZSwgaXQNCj4gPiBzaG91bGQgYmUgYWRkcmVzc2VkIGJ5IGEgc2VwYXJh
dGUgcGF0Y2gsIG5vdCBieSB0aGlzIG9uZSwgd2hpY2ggaXMNCj4gPiBpbnRlbmRlZCB0byByZXNv
bHZlIHRoZSBNQ1EgbW9kZSBpc3N1ZS4gV2Ugc2hvdWxkbid0IG1peCB0d28NCj4gPiBkaWZmZXJl
bnQgaXNzdWVzIHRvZ2V0aGVyLCBkb24ndCB5b3UgYWdyZWU/DQo+IA0KPiBMZXQncyBwcm9jZWVk
IHdpdGggdGhpcyBwYXRjaCBzZXJpZXMgYW5kIGxldCdzIGFkZHJlc3Mgd2hhdCBJIGJyb3VnaHQN
Cj4gdXAgaW4gbXkgZW1haWwgc2VwYXJhdGVseS4NCj4gDQo+IFdpdGggdGhlIGN1cnJlbnQgYXBw
cm9hY2ggZm9yIGVycm9yIGhhbmRsaW5nIGluIHRoZSBVRlMgZHJpdmVyLA0KPiBhbnlvbmUNCj4g
d2hvIHdhbnRzIHRvIHZlcmlmeSBvciBtb2RpZnkgdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKCkg
aGFzIHRvDQo+IGNvbnNpZGVyDQo+IGFsbCBwb3NzaWJsZSBpbnRlcmxlYXZpbmdzIG9mIHVmc2hj
ZF90cnlfdG9fYWJvcnRfdGFzaygpIGFuZCB0aGUNCj4gY29tcGxldGlvbiBwYXRoICh1ZnNoY2Rf
Y29tcGxfb25lX2NxZSgpKS4gVGhhdCdzIGFuIHVubmVjZXNzYXJ5DQo+IGJ1cmRlbg0KPiBvbiBV
RlMgZHJpdmVyIGNvbnRyaWJ1dG9ycy4gQWRkaXRpb25hbGx5LCB0aGlzIGlzIGVycm9yLXByb25l
LiBUaGlzDQo+IGFwcGxpZXMgdG8gYm90aCBtb2RlcyAobGVnYWN5IGFuZCBNQ1EpLiBJIGtub3cg
b2YgcmVwb3J0cyBvZiBzcG9yYWRpYw0KPiBjcmFzaGVzIGluIGxlZ2FjeSBtb2RlIHJlbGF0ZWQg
dG8gVUZTIGVycm9yIGhhbmRsaW5nLiBJJ20gd29uZGVyaW5nDQo+IHdoZXRoZXIgdGhlc2UgYXJl
IHBlcmhhcHMgdGhlIHJlc3VsdCBvZiB0aGUgaXNzdWUgSSBtZW50aW9uZWQgaW4gYQ0KPiBwcmV2
aW91cyBlbWFpbC4gQW55d2F5LCBJIHdpbGwgbG9vayBmdXJ0aGVyIGludG8gdGhpcyBteXNlbGYg
YXMgc29vbg0KPiBhcw0KPiBJIGhhdmUgdGhlIHRpbWUuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBC
YXJ0Lg0KDQpIaSBCYXJ0LA0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3Lg0KIA0KSSBjdXJy
ZW50bHkgY2Fubm90IHNlZSB0aGUgaXNzdWUgb2YgZHVwbGljYXRlIHJlbGVhc2VzIGluIA0KbGVn
YWN5IFNEQiBtb2RlLiB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSB3aWxsIGRpcmVjdGx5IA0K
cmVzZXQgaWYgaXQgZmFpbHMuIEl0IGlzIG9ubHkgaW4gdGhlIGNhc2Ugb2Ygc3VjY2VzcyB0aGF0
IA0Kd2UgbmVlZCB0byBjb25zaWRlciB0aGUgcG9zc2liaWxpdHkgb2YgdWZzaGNkX2NvbXBsX29u
ZV9jcWUuIA0KSSBiZWxpZXZlIHRoZSBvcmlnaW5hbCBkZXNpZ24gZmxvdyBoYXMgYWxyZWFkeSB0
YWtlbiB0aGlzIA0KaW50byBhY2NvdW50LCB3aGljaCBpcyB3aHkgdGhlcmUgaXMgcHJvdGVjdGlv
biB3aXRoIA0Kb3V0c3RhbmRpbmdfbG9jay9jcV9sb2NrLiBQZXJoYXBzIHdlIGNhbiB3YWl0IGZv
ciBhbiBhY3R1YWwgDQpleGFtcGxlIHRvIG9jY3VyIGJlZm9yZSBtYWtpbmcgY29ycmVjdGlvbnMu
IEV2ZW4gaWYgdGhlcmUgDQppcyBhbiBpc3N1ZSwgSSB0aGluayB0aGUgcHJvYmFiaWxpdHkgc2hv
dWxkIGJlIHZlcnkgbG93LCANCmJlY2F1c2UgdGhlIGZsb3cgZm9yIGxlZ2FjeSBTREIgbW9kZSBo
YXMgYmVlbiBpbiB1c2UgDQpmb3Igc2V2ZXJhbCB5ZWFycy4NCg0KVGhhbmsgeW91IGFnYWluIGZv
ciB5b3VyIHJldmlldy4NCg0KVGhhbmtzDQpQZXRlcg0KDQoNCg0KDQo=
