Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F61A191F7A
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 12:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971821; cv=fail; b=ASSDvgNC6NsfpqDZ2auR7MUWhuCvYL1UjduzbJGnuNANQjhKQdpmYfNBx2RxTZ5P5ssFMUx9FXqEASdj5ofuRwH1uTcjpUAsQwr5jdJ3MVeOSm4m5RzHW0U2/X2ufQjlzcsZa4BmI4VxBC8OLIqoQthtlBV9UfcesDuw9fztVKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971821; c=relaxed/simple;
	bh=8uHZqL2+Y5hPpJezu5vs/6NIUyCZEWLRXl90hKxisjY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e1I/looV/2jvnDRZuwk37MiZFrGFlwwmovj/bTp3EJgBw+/AiMCAH9TJqyLQdvgpoqwf46e5x8DKDej4c28gDuaWyZv0iwPKyQKz4mqfbBZEkmVZ7X+bSKk7BBMcH8ZwjYKcucIT4lzGXrEidN7XqIXajma2drCRT0m6gd2CqiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=umHUwuV/; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=d2uwWx2x; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="umHUwuV/";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="d2uwWx2x"
X-UUID: 5a89e4746f7111efb66947d174671e26-20240910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8uHZqL2+Y5hPpJezu5vs/6NIUyCZEWLRXl90hKxisjY=;
	b=umHUwuV/PmBN+gg5+eyvBYWp9njSog6xelI/hJu1ADHevA4ftI2c0p/EYubNWgxO4YfNDpQ8e3XBdB7M3M44POo3UYbLEM7XA4y8KeotBJ8gTXyh2PRalnUdc1uTLbsS1rLE1PR2klCWha0iSoMslgJiXnJFgzTct7hKZrTCbkg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:3968fd6b-6734-4b4d-8183-19d6c3fff0ab,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:75a37b05-42cd-428b-a1e3-ab5b763cfa17,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 5a89e4746f7111efb66947d174671e26-20240910
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1721415675; Tue, 10 Sep 2024 20:36:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 10 Sep 2024 20:36:50 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 10 Sep 2024 20:36:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kW6E7//eTBY9gqrIDAZyqcZ1bPQPCy2LRUOQWkN4GRQQpLQILDs/3noYlol1goq5czgXJaxXy5VMkBm/v8xQsef+tQYwhLE3myNdKAASeBcAOuQla8b1KUrgvbvQcBF90H2gLIjdFhnCW9V4GgejuoFQEfXzAZYe4T172PR/OUJcG/cItw33GvfAVMQkXIwIPehYxMqhOoDoHZixkRBMHYOShLGNEw37iCZjckuzq5LDOi4MOi4yBNBIewEz2vbk2IikhyyMYU/E+NJqfCjHi9kixUiti3noWwzqQzDvlLTKDC2Qx6iHOc8T3K4RE2jTRl9+KPNAV5fIB5fhmmsEAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uHZqL2+Y5hPpJezu5vs/6NIUyCZEWLRXl90hKxisjY=;
 b=D+tsDTlsFun4LvxrmwvLMW/FkRYjUuVjv79TQhiPG39q5za91xrrW9LxU6uYBvgktDd+NAAJOzUwdiAMQjp2xdY46Wt1FN7qP+WPUTwxs3bDjeaE8m6Y9fxDi4ncvKcNkLN/6SwQB8Xb7vMsQ8SkqRhExbF4iI5wzYrTxh8Isrbcsozqz+CTPmoC6o/nRE/U08gCpO+gT457hC7HmZ3DZyMoviQUQGVKFNz+3Trq7DGRfe0PBlGWszkXdNnv1MzMQ6xZilWOplH2AMsr0Lexl+A5Ojf/EJYSmezYlrksFf4VaO1pIUBkXtqlcdfAsJez+T9HqEVVcaeV1RFwt6jGow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uHZqL2+Y5hPpJezu5vs/6NIUyCZEWLRXl90hKxisjY=;
 b=d2uwWx2xvBQUeyRZTW0vhLZ3M4Ud7MPDruByPpT5gK43lKFlqF/7waVo6mbNyr99v3aYpvi7GD63oI3gIUGwCwWAnb3aZPDdffz/3M+dVyxmXTYJ3niwXfEaa1NVIN9Bx4pvb/VFe3+vNMVa+WUPOUPYceM3jkzOTLwNUi3BDK4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8225.apcprd03.prod.outlook.com (2603:1096:101:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Tue, 10 Sep
 2024 12:36:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 12:36:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v2 4/4] scsi: ufs: core: Change the approach for power
 change UIC commands
Thread-Topic: [PATCH v2 4/4] scsi: ufs: core: Change the approach for power
 change UIC commands
Thread-Index: AQHbAw3FnHpRZeeAqUS5Iq3D79elXbJQ9heA
Date: Tue, 10 Sep 2024 12:36:47 +0000
Message-ID: <bc2a536c97de9e536dd25a5ae11dea6127c7e82c.camel@mediatek.com>
References: <20240909231139.2367576-1-bvanassche@acm.org>
	 <20240909231139.2367576-5-bvanassche@acm.org>
In-Reply-To: <20240909231139.2367576-5-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8225:EE_
x-ms-office365-filtering-correlation-id: 747fb010-7afe-4aa6-632c-08dcd1953c9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L0FGdXRrNHdCeDNJWjJGQ0JrQkhtM1hoYmdQQkVRVzMzbDBuRDN5TVhsOXZ6?=
 =?utf-8?B?UWYvS0Z3akQ4UTJOVysra1U3ZkIxbEdvZEJpaFRBUFMyWTFrbGRPbVZBdlh1?=
 =?utf-8?B?TllIME52Vkt0SXJJQloweThJOWw2RlkyK0hCQllhOVR5eExGbkdKWWdWY2tS?=
 =?utf-8?B?SStQOUl6Wld3TEM2ZDNzRDhwVnVjNS9wVXJCdGpoVWV6czJCZUpkZ254MzY0?=
 =?utf-8?B?RkduZnlsUytSck1pUHhBdlhqWlJ5S0lzdUdNbS80Wm1KblJDV2JRZVdldWY1?=
 =?utf-8?B?Q3B1VmRkdHFWcS8vQzJyK21iMmgrWVlIeDNMa0xxK1RhaTJ1aDhWZDFvUE1U?=
 =?utf-8?B?aU9qUmFXZm13RzgvYWpQbnYraEZiRXRLaStzVXVTeVNaVGdpUHZmbFZHKy9W?=
 =?utf-8?B?bkVSOFR5dGhWem5pOFNOVFJxaE01OVV5WmYwL203UjBxWGQ5Rjd4Z0NWT0xP?=
 =?utf-8?B?RjNkbmFUWERnYys2ODIzOXZwa05uNGhuSTM0ZUdoc0VrNnhzOFk2MDVEMy8w?=
 =?utf-8?B?WmdPRVVkc29vUEx1T3dBZ2k1QVlnbDBaZ1BzeHdHNGYwR3orbi9ySFVsMlYv?=
 =?utf-8?B?Vkg0cEZ1dG1HRGJ4ck9TMmNnTXFFYUR2eTZtVms3OVZoS2hVS1dsbXJaRk1a?=
 =?utf-8?B?Wm80djkway82UDFXVWFHRCtVVEh1S2VXOWNBa0dzZzJuQ3RMK0taalp3aDVa?=
 =?utf-8?B?S1RxNmo1a0ptWXdxdko2SVhDd0hTQ25qbUtjVU1neXlJSE5VOWpSVm1tWWxs?=
 =?utf-8?B?Y3BNTXpmRE4vT0l0ajVVK0llRzZ2NkJiSXJ0cUhTaDZEWVNkeGFGbXBac3BN?=
 =?utf-8?B?OEhUR0tvQWdobDRxNGV4RnUyWmVMc29teGcxM0psdjV3VEVrQ290ZzgxUmJY?=
 =?utf-8?B?bm1qMGRoY0kydHIvVml5bllwNk9GQXRVQTZNKzJMUGk2bHZnS2ZOL3JxWUMx?=
 =?utf-8?B?bVdnMHhjZllqcTFXQWpmeHhsK1QvdVc0YVNhYkx0OGo0RTdqQUdqc1JNMUNt?=
 =?utf-8?B?SjI3cG9oOEZBYnByc01yZG1WcXBrU3JIekJZNnZzSG1vbzdXSFkwYXF5RGpR?=
 =?utf-8?B?T0laWjNPWmx2SXcxdGpLSE43WGszRmQ3SVo1TWFTT1hoVXJLVU5wajBwbEg5?=
 =?utf-8?B?QTZERGtodVV1ZzNHN2xuUEF6eUNwdzhPK0xmRFJsMkFGeDV1RHhoemlGNVds?=
 =?utf-8?B?ajFvODAyemU2ankzeUY2eXM5YjRvMHk0c2JLQkhRYVRodCtlN2x4Mkx1YlJZ?=
 =?utf-8?B?L3gzYVN6TmZINmw2NXpsVks3NlROVDZCSGtWcloyN1REMFV6aTUwYUdRSmdT?=
 =?utf-8?B?RlpKaEJrU29XSWZVUXFDU2Zhcm5GbHN3b0dPazExMzM2enZac3FNUkRKb1lm?=
 =?utf-8?B?Y09GdzF5K2FYM25QZ25QSXlXcXg5aDZyQ1lmQUtZM2VkbDhUdVpiU0p0NnFQ?=
 =?utf-8?B?eloxMVFPdERKcXNvbWZMMXordHM0anpaamVHU3YveDdhMGFTblN6a2c5OEpp?=
 =?utf-8?B?am5KWkNydWRERUdoWTVneUVVR0pGR2xNVHNuRFBMUnoycGZ4Wm9DMHhCT09H?=
 =?utf-8?B?bnM3ZGUwZDZyYVArNDJxRVRRT2EwYzZLNVpuVi9FM0pxZUc4c2JhVEN4K3BE?=
 =?utf-8?B?OUQrUTdsY2FZQkgvMWxYSlBhTFJJTnlYYWNwZnhEZWhBRDVPS2FYM1VacDFZ?=
 =?utf-8?B?RVJwYk5mM2ZvMFVYaVhhNmUxSHlpWmdpTWNlME1Ed1l2OS9NYnhCRGpPWmNa?=
 =?utf-8?B?VnZWR3p4eXZmUlhIUmk0c0VuMmNjQzJoMzZLUVI1R3ZOSWxVcXpHRVZ2cEpP?=
 =?utf-8?B?djlvaUhabngxVE9kU3pJeGFsaGluMlIxcys2LzJwVzFsWktNVjc3UFVpdVhI?=
 =?utf-8?B?V1hZQVVicDBjaTdTOE9VaTdsL3UvWk9QM25rRjNnRWRoZHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3VJOXRLYkhTQ3BIMjkzR2VtcGcvU1NoRFFFc3UzMHBvZnFjVkE0WE9DRklE?=
 =?utf-8?B?Zk5HdnJaYWtuRGo5SUh5N0hLSitibi9OYit6NVpkN1lBeFQwMmI5QkxHZUYz?=
 =?utf-8?B?aC82ZFNCUjNneGsrdGJMbWUwQlMrVDN2aTE1aW54QmhFOXMxRmlBUmJpRUlJ?=
 =?utf-8?B?S28xV3I5bExRbG5Rc3NwdUh0Nmd4WlBlTlpUa2hSbzlyVWhRNkQxVWgyOWFk?=
 =?utf-8?B?OVEzVmVhZW02enhES1VZek03dW5XYWE4SzZ2ZG51S3h5bTNCRkhIVEQzMFFl?=
 =?utf-8?B?ZEk0QnlXWW55bmFaY0QvRlJLTXFtRk0wd0FiMEZUVGhJcTFQTTMrYWVQMXVv?=
 =?utf-8?B?eWFUM3Q0QkI0a3lwWVVpSlhuWGVoL1ovdDRFdjlOc0xHNXFwMXZsYllxc0VR?=
 =?utf-8?B?UkxJaEROQ1BGK2Job1BqdHpyUGtaZy9kUUhaU3ZKVmhrb2k1M2ZwQVhKcnlI?=
 =?utf-8?B?VTFJT1BTWlBvL0hlcENoakF3dUNpL0crQ1haNUlzaGVHeWsreGFiSXhLNVUx?=
 =?utf-8?B?MGlZTzlWOXdqOHpnL09RQjZDM0Zzb0ZFaHgvSUtJT2tOUktmVUdkVWExdndl?=
 =?utf-8?B?aXpVN3lZWkxYNjk1eW9WRUlOMUcrOG1UVGFrSjAweDlmblJKWGtINTY0U2cz?=
 =?utf-8?B?MmdYWVp3dnlOejBpR2JsYSs4c1daaDcwR1ljS213dnlzNlpDUlpERFZQQzZU?=
 =?utf-8?B?RmNFcW1nMTNISjRubXljRzd3VDlTZmgxb1l2YWJSRWludDdtcHVUeUZtckY1?=
 =?utf-8?B?dmk2MjZJNTdxaER5dUxGQ2pWeU1tSkp3VkxabWsrZWlXRDFBeTNsNmFuWlBz?=
 =?utf-8?B?R2NKVEhUYTZpUTVUQ1dDTitxRCtQQ2JVYm1uU3UwZjk5Y2JBbUEreDZjdElL?=
 =?utf-8?B?N2dNaEpaekUwazljbGpWdWU5QURFOXBWZXRBRUdUT0ZmK3RTOGZMeGhoMit2?=
 =?utf-8?B?bTllQ3dUTmltKzQrazhzRlVWSkdtMmEyQ0dYbGFzSmNUL1RNc0M0ajZoaWpO?=
 =?utf-8?B?R1MyM1FVdDRjYngvd3p4Zmx0dVo2RU5FSFBhWnREUkExOWdSWWdCeXRBbkI0?=
 =?utf-8?B?VUxuNHBUcDJZUlVMSW9IcUN5ZW5pWXBEWnE1dWgya2xQSW5UVFY5UmhDbXNr?=
 =?utf-8?B?THNqaUJJU215Wmw5QlJ4blU1YmRvLzc2Sk85SXNHbVJXMnpoTUVIc0xnZzFV?=
 =?utf-8?B?RlRrRFdtUElRYk9ISU5xK2h2TWlteXBmbW5PTDBOQ0VpaFErc3MxU0JFN09D?=
 =?utf-8?B?Y0psc2dmN0hKeXhkRW5pejVOSWo4L2IrYm9LL3M3WEVnZEhpcFVUcGpBVmhs?=
 =?utf-8?B?ZmNnSHJUNmdHSWNrMmVGM2Y5WlM4bE9wcGpGQXg5L2tqV1owWm14M0RrekFp?=
 =?utf-8?B?UFY3OUlIUlJMMU5NWUJ3YXFFN1VuaVNsdmwxTHhORktObDZSSmYvTUpvU3hE?=
 =?utf-8?B?Z1VTQTdUeDBvR2NGMHhqYlkreWdkYWxUQmYrUEM4SW5yM1M0K2NRcUk3RlFH?=
 =?utf-8?B?RytLcWRsUFlRd2NaUk9sc3N0QUZ1MUtwOEpMUEdlVm5EdWF3V0tibFRNUGJs?=
 =?utf-8?B?UkpqRTdtR2UxNzF1NnlTVXA4NElHZFdsWk8zVTRneVliNUdCUUt2Vnc2Q3Rj?=
 =?utf-8?B?TW9nUEJVMmpQeUpBQ0xBQ2JoWEExMzVFN1c0dUhyMTh0b0o5QmRZU1E3WVVT?=
 =?utf-8?B?YnYrWUw2T1NBZFZ2bGpCOHdCVXpsaDdCaUplUm0ra3NTZkh3UHYwMnV5ZHVJ?=
 =?utf-8?B?bHhhcTZBT2wxUU0yekhDUHE1MjRpaXFqRFhZZ3MrZEVrLzFTOEkzd296bkQr?=
 =?utf-8?B?ZHNJN2YrYTJteE16dTQvYkpIRWsxUTBDdHc2aWVYS21LWFhqcWNvMU45bHhK?=
 =?utf-8?B?Mit2VjZXaXlCdnJPVTR3Z1E2dmpLWVl6ZnhFN0oxSnB5SXpRRGRPMlR1Z0dS?=
 =?utf-8?B?N1g4SElIV1BIK053UldOa0RleURQb205em9BMUFsWkoxUGlTTTBrTTk3VEs5?=
 =?utf-8?B?UzJJWGVVMCtWcXBjL2U0a01lalkxVzFKdllPOFRrc0txcm0vOWxLakt2b3E3?=
 =?utf-8?B?N0pFN2s1Nmd4VmRjMnRIalM1a3FXck82ZStBR1poS1pVL0Fucll5ZW5SeGpj?=
 =?utf-8?B?dE91U011UWVqV0JLckVRNVZ6RnZZUENmYUprQXE0MjEzWVl5MjhURTZINFBl?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE166957F81BE74EA57F2CC87C3C0502@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747fb010-7afe-4aa6-632c-08dcd1953c9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 12:36:47.6497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nNJfGDe16UJ56oIp4zZQLZLVpTq+KLam0ZG88/Xd2AxolqrA8av/o0Kpn10IhQdjIyqgohvAnU1g5Wo+VBEmpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8225
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--23.964000-8.000000
X-TMASE-MatchedRID: oMBNC5/fKrXUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CyZf5btvM85Ac7EPIkVcg+OwPP
	ELQWm4vk4/WmCp/wVV7+ZRx3n+HfgIhYmWbjpe3Duykw7cfAoICGi0ftsSkQybcPp/oilssgyr5
	6f45o26zyK8WRp1qJNzXtHz0SFr9VTCNHh4LHUIx+WEMjoO9WWQl/FdRYkUZLfUZT83lbkEEtHo
	jrK13E4LcdfV+CTUsq4SaxPJqBEYpE4FU2ZdQO4ksHaPaQQRsBCs7hdHoFFA/gnJH5vm2+gkK7L
	OuYc7ogV2K/uCxW9o4iuLU5n9mED4MG9jJywnBVVnniKh7YTC30tCKdnhB58pTwPRvSoXL2y5/t
	FZu9S3Ku6xVHLhqfxwrbXMGDYqV8CpgETeT0ynA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--23.964000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	28BD94EED4164FB52C44E4325FBE55ECFFD0D7E4F3ABC8240F8017681388BB372000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE2OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgRm9yIHNvbWUgaG9zdCBjb250cm9sbGVycyBpdCBpcyByZXF1aXJl
ZCB0aGF0IFVJQyBjb21wbGV0aW9uDQo+IGludGVycnVwdHMgYXJlDQo+IGRpc2FibGVkIHdoaWxl
IGEgcG93ZXIgY29udHJvbCBjb21tYW5kIGlzIHN1Ym1pdHRlZCB3aGlsZSBmb3Igb3RoZXINCj4g
aG9zdA0KPiBjb250cm9sbGVycyBpdCBpcyByZXF1aXJlZCB0aGF0IFVJQyBjb21wbGV0aW9uIGlu
dGVycnVwdHMgcmVtYWluDQo+IGVuYWJsZWQuDQo+IEhlbmNlIGludHJvZHVjZSBhIHF1aXJrIGZv
ciBwcmVzZXJ2aW5nIHRoZSBjdXJyZW50IGJlaGF2aW9yIGFuZCBsZWF2ZQ0KPiBVSUMNCj4gY29t
cGxldGlvbiBpbnRlcnJ1cHRzIGVuYWJsZWQgaWYgdGhhdCBxdWlyayBoYXMgbm90IGJlZW4gc2V0
Lg0KPiBBbHRob3VnaCBpdA0KPiBoYXMgbm90IHlldCBiZWVuIG9ic2VydmVkIHRoYXQgdGhlIFVJ
QyBjb21wbGV0aW9uIGludGVycnVwdCBpcw0KPiByZXBvcnRlZA0KPiBhZnRlciB0aGUgcG93ZXIg
bW9kZSBjaGFuZ2UgaW50ZXJydXB0LCBoYW5kbGUgdGhpcyBjYXNlIGJ5IGFkZGluZyBhDQo+IHdh
aXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgpIGNhbGwgb24gdWljX2NtZDo6ZG9uZS4NCj4gDQo+
IE5vdGU6IHRoZSBjb2RlIGZvciB0b2dnbGluZyB0aGUgVUlDIGNvbXBsZXRpb24gaW50ZXJydXB0
IHdhcw0KPiBpbnRyb2R1Y2VkDQo+IGJ5IGNvbW1pdCBkNzVmN2ZlNDk1Y2YgKCJzY3NpOiB1ZnM6
IHJlZHVjZSB0aGUgaW50ZXJydXB0cyBmb3IgcG93ZXINCj4gbW9kZQ0KPiBjaGFuZ2UgcmVxdWVz
dHMiKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBh
Y20ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgICAgICAgfCAxNSAr
KysrKysrKysrKysrKy0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCAgMSAr
DQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmMgICAgIHwgIDIgKysNCj4gIGluY2x1ZGUv
dWZzL3Vmc2hjZC5oICAgICAgICAgICAgfCAgNiArKysrKysNCj4gIDQgZmlsZXMgY2hhbmdlZCwg
MjMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4
IDA2M2ZiNjZjNjcxOS4uMjNjZDZmNGE2Y2EyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTQy
NTcsNyArNDI1Nyw4IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZz
X2hiYQ0KPiAqaGJhLCBzdHJ1Y3QgdWljX2NvbW1hbmQgKmNtZCkNCj4gIAkJZ290byBvdXRfdW5s
b2NrOw0KPiAgCX0NCj4gIAloYmEtPnVpY19hc3luY19kb25lID0gJnVpY19hc3luY19kb25lOw0K
PiAtCWlmICh1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfSU5URVJSVVBUX0VOQUJMRSkgJg0KPiBVSUNf
Q09NTUFORF9DT01QTCkgew0KPiArCWlmIChoYmEtPnF1aXJrcyAmIFVGU0hDRF9RVUlSS19ESVNB
QkxFX1VJQ19JTlRSX0ZPUl9QV1JfQ01EUyAmJg0KPiArCSAgICB1ZnNoY2RfcmVhZGwoaGJhLCBS
RUdfSU5URVJSVVBUX0VOQUJMRSkgJg0KPiBVSUNfQ09NTUFORF9DT01QTCkgew0KPiAgCQl1ZnNo
Y2RfZGlzYWJsZV9pbnRyKGhiYSwgVUlDX0NPTU1BTkRfQ09NUEwpOw0KPiAgCQkvKg0KPiAgCQkg
KiBNYWtlIHN1cmUgVUlDIGNvbW1hbmQgY29tcGxldGlvbiBpbnRlcnJ1cHQgaXMNCj4gZGlzYWJs
ZWQgYmVmb3JlDQo+IEBAIC00Mjc1LDYgKzQyNzYsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF91aWNf
cHdyX2N0cmwoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICpjbWQp
DQo+ICAJCWdvdG8gb3V0Ow0KPiAgCX0NCj4gIA0KPiArCS8qIFdhaXQgZm9yIHBvd2VyIG1vZGUg
Y2hhbmdlIGludGVycnVwdC4gKi8NCj4gIAlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91
dChoYmEtPnVpY19hc3luY19kb25lLA0KPiAgCQkJCQkgbXNlY3NfdG9famlmZmllcyh1aWNfY21k
X3RpbWVvDQo+IHV0KSkpIHsNCj4gIAkJZGV2X2VycihoYmEtPmRldiwNCj4gQEAgLTQyOTEsNiAr
NDI5MywxNyBAQCBzdGF0aWMgaW50IHVmc2hjZF91aWNfcHdyX2N0cmwoc3RydWN0IHVmc19oYmEN
Cj4gKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICpjbWQpDQo+ICAJCWdvdG8gb3V0Ow0KPiAgCX0N
Cj4gIA0KPiArCWlmICghcmVlbmFibGVfaW50cikgew0KPiArCQkvKiBXYWl0IGZvciBVSUMgY29t
cGxldGlvbiBpbnRlcnJ1cHQuICovDQo+ICsJCXJldCA9IHdhaXRfZm9yX2NvbXBsZXRpb25fdGlt
ZW91dCgmY21kLT5kb25lLA0KPiArCQkJCQkgIG1zZWNzX3RvX2ppZmZpZXModWljX2NtZF90aW1l
DQo+IG91dCkpOw0KPiArCQlXQVJOX09OX09OQ0UocmV0IDwgMCk7DQo+ICsJCWlmIChyZXQgPT0g
MCkNCj4gKwkJCWRldl9lcnIoaGJhLT5kZXYsICJVSUMgY29tbWFuZCAlI3ggdGltZWQNCj4gb3V0
XG4iLA0KPiArCQkJCWNtZC0+Y29tbWFuZCk7DQo+ICsJCXJldCA9IDA7DQo+ICsJfQ0KPiArDQo+
ICBjaGVja191cG1jcnM6DQo+ICAJc3RhdHVzID0gdWZzaGNkX2dldF91cG1jcnMoaGJhKTsNCj4g
IAlpZiAoc3RhdHVzICE9IFBXUl9MT0NBTCkgew0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMv
aG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5j
DQo+IGluZGV4IDAyYzkwNjQyODRlMS4uNGUxOGVjYzU0ZjlmIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZz
LW1lZGlhdGVrLmMNCj4gQEAgLTEwMjEsNiArMTAyMSw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19p
bml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICAJaGJhLT5xdWlya3MgfD0gVUZTSENJX1FVSVJL
X1NLSVBfTUFOVUFMX1dCX0ZMVVNIX0NUUkw7DQo+ICAJaGJhLT5xdWlya3MgfD0gVUZTSENEX1FV
SVJLX01DUV9CUk9LRU5fSU5UUjsNCj4gIAloYmEtPnF1aXJrcyB8PSBVRlNIQ0RfUVVJUktfTUNR
X0JST0tFTl9SVEM7DQo+ICsJaGJhLT5xdWlya3MgfD0gVUZTSENEX1FVSVJLX0RJU0FCTEVfVUlD
X0lOVFJfRk9SX1BXUl9DTURTOw0KPiANCj4gDQoNCkhpIEJhcnQsDQoNCkknbSBub3Qgc3VyZSB3
aGF0IG90aGVyIFNvQyBob3N0IHRoaW5rLCBidXQgdGhlIG1lYW5pbmcgb2YgYSAicXVpcmsiDQpz
aG91bGQgYmUgdG8gdXNlIGl0IGluIHNpdHVhdGlvbnMgdGhhdCBkbyBub3QgZm9sbG93IHRoZSBz
cGVjIGFuZCANCnJlcXVpcmUgc3BlY2lhbCBoYW5kbGluZy4gSG93ZXZlciwgTWVkaWFUZWsgZGVz
aWducyBhY2NvcmRpbmcgdG8gDQp0aGUgc3BlYywgc28gdXNpbmcgYSBxdWlyayBtYXkgZ2l2ZSB0
aGUgaW1wcmVzc2lvbiB0aGF0IE1lZGlhVGVrIA0KZG9lcyBub3QgZm9sbG93IHRoZSBzcGVjLg0K
DQpNb3Jlb3ZlciwgaXQgc2hvdWxkbid0IGJlIHRoZSBjYXNlIHRoYXQgb25seSBNZWRpYVRlayBh
bmQgUXVhbGNvbW0gDQpuZWVkIHRvIGFkZCB0aGlzIHF1aXJrLiINCg0KVGhhbmtzLg0KUGV0ZXIN
Cg0KDQogDQo+ICBlbnVtIHVmc2hjZF9jYXBzIHsNCg==
