Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CD317B506
	for <linux-scsi@vger.kernel.org>; Sat, 16 May 2026 06:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778912704; cv=fail; b=DMxnTV9PDhPBoJL3HDzkABkG8rOuUJM6dRf8SC8Q+vjRuPsmAgVjUDFLxKXhoeaLSnW1v+qMSBHdMYajXoBXuvUvoN1Xg3OZVMeK0QGPLt6xKLsUBWgsqCdNbp7pBUeHBrDC55JqNP+E59pFexDMDHImeoNSg1VbWGkHCiIbkkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778912704; c=relaxed/simple;
	bh=PmBONn8Bl680vqplyomVP9WwNHRpOCrBa6akfMJ+BOE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IeWTkRC5KmWpd220c9b5dXeprZurmlC31LXjrQu4KpT7Fu2cFyoBEEqMmU4sAhFWfj90uLZxiGxHdZa0+tZkempi1GggYC9aEBKKQpL8nMO3Xkrus+xP5hDn6/QtwPci9lqtcZXVH0BrfiND7pIyIEBJl2LsApF7dgoZsW0/1Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nEbvDPdh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XfZ5xr7v; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nEbvDPdh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XfZ5xr7v"
X-UUID: f111dd9650ef11f1b5a00d44d12bea5a-20260516
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PmBONn8Bl680vqplyomVP9WwNHRpOCrBa6akfMJ+BOE=;
	b=nEbvDPdhj8gY9J804JnvAH9Z9G2xMJfTUqg0Fnqp0FdN3Mwx0xXkKI3uiX4esfLW2Zqx9muX7/mdcFI6ygLrI5/P8VkgjGRxMky2oYuc733o+6aNcZQ41MJBT8Q3oRfY7ED3rxn868BcP0Lz1GDi7Q5c7GOzox9omW+FXdURyqY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:9a88c447-662b-4da6-a8ad-adc600dcefd3,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:9091e75,CLOUDID:64666da4-a669-48ac-a1cb-3b38a93be682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f111dd9650ef11f1b5a00d44d12bea5a-20260516
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1206662097; Sat, 16 May 2026 14:24:49 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 16 May 2026 14:24:48 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Sat, 16 May 2026 14:24:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hge0kLcEuUYwPk4v1BlqUXkME8hzf+deAfzVAzhXDlfDlHeZN054hJ/DmUTuSD6vlro8jh0w+XinE2x5GyPYrhXAjyiCxAgSC0oN7/D5eshuTetmrT6V5dsD4mZp9sZvSAYBSsZ/zCxzEKnx/TbuwYNhl0OSH+JdPUNfdaBII1MQ4QBUxduj28SRaV6iKAx4dPY+MvMXOxdoYd6FkczbOm2kkbej62x1VVTFhvtpkr7xaHfpX+fw9um6vWd7DvHmtqdCzyDtnCjNI/zyZseZy49WzkT4/ND8mwd6Qaj2hNJkHg10927sNzQyLr9tZYGNcj+lKsUcyPoLEvllT3Qkrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmBONn8Bl680vqplyomVP9WwNHRpOCrBa6akfMJ+BOE=;
 b=Bjb2iuRG8BwiMY/oe/ZQp1bMECTfFmYN6KgUecPoi8TyhuGcatdvAc8NnwNBXntP+CcdPhPd30/P8tSkpw19u75mFNw3ddmA8xMZRzjxeQcD5ncovcaWZ9esfFm20BFOcANPjKWct08soFfKuMNhcsPsH/Njc/SjQnXmt5NhlNXD44eP0V3p/SVaPrw6b5lvS1jWeuNSkCSV+EGLar62xr3ZFwhQjOR6vDb2rk+czV7XtxI+IMTmrYBsob6IWoFnZdYK0H28XN/GiFTx97eEjU0P3ar1oHC5rkwFt1uk7MjeAt9XNyoYjkDPB37LqbNlPP5l9FxJ/+SlXJquGEDc9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmBONn8Bl680vqplyomVP9WwNHRpOCrBa6akfMJ+BOE=;
 b=XfZ5xr7vaJEzG+cc69zY8zAc44vK5WtN4PLOA1oZSQG1poZqr4wcnfqeNJHq6Fvpjgqe/rSyvQVEiUqm+hVw1VpxprFw4lYm+HpIxQG7xEbsDHCxBirddSbB0K0eo3guHvK7i/SzCZyBvQTgXEd7vvHbEQ9YkuWZEqc8HIzLkXg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7071.apcprd03.prod.outlook.com (2603:1096:101:d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.9; Sat, 16 May 2026
 06:24:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0025.012; Sat, 16 May 2026
 06:24:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Topic: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Index: AQHc44A/IHVJ0+M1ukqkaTZOlDMObrYNtNQAgAEJrYCAAI5zAIAA5WaA
Date: Sat, 16 May 2026 06:24:42 +0000
Message-ID: <bcbfd7a71f698f6a3dcf627d3ea76c79b9897ccf.camel@mediatek.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
	 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
	 <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
	 <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
In-Reply-To: <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7071:EE_
x-ms-office365-filtering-correlation-id: a7251330-f7b4-40a8-3d1d-08deb313d114
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003|3023799003|38070700021|11063799003|4143699003;
x-microsoft-antispam-message-info: TlNLrINZDVBHdKkv0f92etQA1hYHEr95jo9fgWAweMk8TCYtC1W9S71aGNTnDgZIEqHBJWnGt9hl50wx6u/kLpxlaOWTLowoJ0OETbHOw4SHYgOAd7pO9xNKy+2ZnRqfMwJEv6NNQW6VD0CA7Wj6ICdDdzr87IvSeGP6MmrgXQljxSxTXXhbq1DC61MsuRc/l7ECfwPPPCwuUvzPLet/+WxhTULXiNjrBvAZjU0Nw7Ai59m0yJ3zcWIBjClzRzzabo3sNK03s8opbpANfK2Pq3v9xoFwn/0I+gLeQl7QwxpRkgFwUlBhD6fNR0SH8RpxwFyyokwOlrhpjVv7WEkoIi8IXyGU6xNBcVJcwO50CD+gK16NU/KwZ1DNC97QO21GqkN0y7csVIIZqwfsxbmiYM7VXBF3yf/tMW2wzKmlwiyL7SQN4X1gqBwO6tu2Wm67hmwTlcU1oAedekIP7pr7TnPpKgFlAVoX80LCHX3KnLB0Zccjgx4uFpvnPY3LaomSkPVCMK4SsRlp72AuVXNrWbnVfZpOJyNIn2DwY09miD8NAdT3rK6Y/VKjVEpNDstoWtU13YO8epg5NiU5OGSa5LirQZiVBU4nn02sdONzySa3GmZGbIub3RKADB8thAvEUYrNjZnltVlUoHC+g7PfuHTjFFq5WU/5ffKpVKFq/LdADwOFWiMYe0YzP8Jfa+RGNaqJyStkPO92ocHH/TKX0K1XcK46eVhKsPecjVVJrc5zZkhgB1ZpOiqfkTEF7Jtb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003)(3023799003)(38070700021)(11063799003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXFHSmVYOWJpOXhmWFh1aUw1NmREaVpHcURFUElUREtUbFdWcVNuMWJleHd1?=
 =?utf-8?B?WlFSakZjdkZ6ZXRZWFZSb0JuK2J3dTFqSkRXK05ISDFjV20wUkVQK1ZySHU5?=
 =?utf-8?B?K0hMSkJtbm1DMExhaW5BNE9va1pHZldFcHJ4SUtlTjNiK0VmMFkvR1RFVEZ0?=
 =?utf-8?B?TlpxNW9yMTBweS9sRmIrUCtyMHBqSXg1cUQwYWJZZmhCcENiajJPb1IybUFR?=
 =?utf-8?B?aWJ1Yit6eGlvK0Q3My9pc2szRWdZSk93WWhJaVZqVjlxSTE3TzJya0hPaWdF?=
 =?utf-8?B?MERhREVBYlRTd25HREpuTERIWmlVZmlQNUFOSG8wS2NiVUtWOHh3Nlcyb2kx?=
 =?utf-8?B?REVrZzNTZ0krQUFzYkxSK2VmSnNnRWo3MUNYeEdNQ05DUkxRd0JyWVpqRjhF?=
 =?utf-8?B?YUxFa2gzbkhSYVpqWmtwblBwQUFuTEZSNGo5STc1cW4wV0YyVSsyOEZaZDR4?=
 =?utf-8?B?MmNSRERsUlRvMGw2djNBNmxqZW1qR08ydjB1NDl1cGtHeHdaWDF4eUhuYVlv?=
 =?utf-8?B?bmk3Y1hFQUxBOXpUdUNtWGJtbUhVazUyK3liT0RHN0ZMR2NuODhobEpuL0g2?=
 =?utf-8?B?aXltZmZVOXRieU8wcVVZRlRmQjh3WGZmUi9CTmdqYWVzL3FJTHNHdGxQVlVQ?=
 =?utf-8?B?UXdiZzR4eFFwakVGbm4xZlRhTnArU01lQUNraEc2NDBDV0E1REVlTExtSjVI?=
 =?utf-8?B?MWJCekRqTFFvb1NIR1h4Q294d0N5UEtHaGxocjliY0FSY1k4RGt4djZycGpx?=
 =?utf-8?B?cUhNNE9ucGtxK3hRV3hUMkhqTXRXc05UYnF2S1d2eXBjVkYxSXRNdGFlYmRQ?=
 =?utf-8?B?ZHZ1L3crMk5MaGRFZklMaFh2WkFYM242QzN5ZjBxK2FVN1N1emtMaytQM2dm?=
 =?utf-8?B?bS96MmhxR2lLcGZlV2ZkSzZMb1NPVTV2bnNLM1hPejg1TFlQMWxaZVZlK2Jk?=
 =?utf-8?B?ZWxBTE1NNkNBUUwwbUZUNWxoc2Z3ZkJlOEpuK2o0K2F6ZGozcUtscm43M21F?=
 =?utf-8?B?S1dnMFd2RmxXdnVOVThlNGRMeGFMd050N013SUhDT1NnQUppcDJlZ0J3R3VP?=
 =?utf-8?B?M2pMSWgyeGFqdDE5OFFEdVNCOFNlVWhNa05SM0JoS3ZJZ1FHZStMQjhyenNB?=
 =?utf-8?B?S1E3UldTeFVGaUZKTlNQVnJ1THlZZms1L05Qa0JVcUNIaEdkMnFZcHZFUGhS?=
 =?utf-8?B?aEFqKy9uSE91a2xwa0cwcXk2dHp5QStEU09kbWR2c3pTRnRWekpXRjJ3eGll?=
 =?utf-8?B?OUR5YWtMYmdiZENGeFFyMTlSMWVBOXBBeVdjOTRheE1zdGxDNUdxZ1lvcDJi?=
 =?utf-8?B?Y1R3NEdLbkdoVzBjM3BmNGErZVF4cGtHMk9BM2krZjlBZkxkT21icXlneFVU?=
 =?utf-8?B?bjkxVjZ4SE5zM2VDTnk0L2JvKzE4ZHFPendqRFZkUk1QUkFFUzZSME9zMTJP?=
 =?utf-8?B?OGt5ZlRDa3UrUWhaSjJXWEVuRVNmdXFKUFVQMlJNQkNNSlh5aWxoWWtiS2cw?=
 =?utf-8?B?dXF3a044YTR0cU5ZWVRPZGZjU0ZCQnZzdGZLWGRkL2h1UDJsUjdnZnN1OUJt?=
 =?utf-8?B?c0NaSUhIMzhhNlg1N3k0dHk5Mzl0d2JsOUdHM1g0NzcyTkluWWZtL0xvTG5y?=
 =?utf-8?B?ZjNNWThrd2gvK29aY0lLckxYVTFZNUFEY3dBNFFDeGxaRHBKdVh2c0ZmMmpL?=
 =?utf-8?B?K28wek9DaHgwT1VpRzRTY0IrR0IrQmx5d3EzU0dFUS9NTjZndUpOYXpkVFgr?=
 =?utf-8?B?MHdHenN5U0lqL0twc1JrWElTVjkyQWlpL1pJN3B4cllmT21FSlo5TzdkVUxj?=
 =?utf-8?B?MUJMaVJJSlduZ1BYbXFKNWlqTHpOYy9Idk12ZkNoZmxwSnZUcTQ5QUcrZExB?=
 =?utf-8?B?YTd2Q0VTa2tsN2czWWxxai9lb3I3WWFSMjlGNmZRbXJOVVNSejJ1djYzK1RX?=
 =?utf-8?B?Z1g3WFRnanUzRnJOZHJKVmkyYnZBUjFPOWZ1N2VGZnJZNWs3MFRURnQ1a1ZB?=
 =?utf-8?B?SG1oVENxMzRnOWtlcHE1MTN0K1VtRWpSSml1K1Evb3p6WXo0bFpHWmgzaGZi?=
 =?utf-8?B?dXVlUnhhUVEwQUFSUndMc2RsRlJWYXljZ055YmxMQWwwcXpDZUNCby9yWmNr?=
 =?utf-8?B?azJjMlUrdDhOUHkrOVhFbzF1WDdaTFpiTzMwTHFFdHJ6QUFlS1A4OFE5Tjc1?=
 =?utf-8?B?bUEySXU0R21iMmduYWpXWjdBc1FMRHJCSm85c2dCaU1BbU4ySllEOWwrVnpN?=
 =?utf-8?B?SFBZOGRleGp1MHlaM3h0WXFpK2p4OE9WZ1BWcDMySXB3YW9JeE4wczgxYVRL?=
 =?utf-8?B?UVZ3cVZKWmtoMk5MUTkwWmhxU0l2eWFpZ0RCS0QzLzZzSTBrSzZHNlNsaHhY?=
 =?utf-8?Q?YSRth6kCPBCB46dE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C30F1C2F9DC6141B18891CFC3212C81@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qV+N2rtVsY3YMdjQQ+QxLTeNwa4cYR7/seyln1tHSnJQl6ZGBeU55JrIrqizEvgCldvn+Ep4PU9n/we2YSkiJUfDnjUqKF6mL5ufUwHV2lVSoNtMFltzQbhHpgMHx/50YkxzA5mokLvDiMTMNOLKUNlW9ygDlAhhnjq7DH37H2YRNBba0npo8mYm5EUxOTPshHxkEYoh+nF4I9fqKYhH9PNvG1qQxq8MOC0PSa75AQLMY8oGXiiTFNjQMPer9EPoj6BS29H2SQpjdmwfWVyEuNkPUgcV0rGcJIusZM442PLcCaaM/er/4nij86DbDDPxhzgLs3+Eo52rx4CL7znrQg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7251330-f7b4-40a8-3d1d-08deb313d114
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2026 06:24:42.6325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FeQvU8duy6uRf0juAk7kZ/oCXWSAaAAV9Pow93BX9NjhDV4qpS9sAmnsCKy+2PsS7zv9JT/8oEicQbqjh1rJzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7071
X-MTK: N

DQpIaSBCYXJ0LA0KDQpUaGlzIGNhbm5vdCBoYXBwZW4uIEkgdGhpbmsgeW91J3ZlIG1pc3NlZCBt
eSBwb2ludCBhbmQgDQphcmUgY29uZnVzaW5nIGhlYWQgd2l0aCB0YWlsLCBhbmQgdGFnIHdpdGgg
c2xvdC4NCg0KDQpPbiBGcmksIDIwMjYtMDUtMTUgYXQgMDk6NDMgLTA3MDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZQ0KPiBIaSBQZXRlciwNCj4gDQo+IERvIHlvdSBhZ3JlZSB0aGF0IHRoZSBmb2xs
b3dpbmcgY2FuIGhhcHBlbiB3aXRoIHRoaXMgcGF0Y2ggYXBwbGllZA0KPiAoYXNzdW1pbmcgdGhl
cmUgaXMgc3BhY2UgZm9yIDkgQ1FFcyBvbiBjb21wbGV0aW9uIHF1ZXVlcyk/DQo+IA0KPiAoMSkg
SG9zdCBhbGxvY2F0ZXMgdGFncyAwLCAxLCAyIGFuZCAzIGFuZCBhZGRzIHRoZSBjb3JyZXNwb25k
aW5nIFNRRXMNCj4gdG8NCj4gwqDCoMKgwqAgYSBzdWJtaXNzaW9uIHF1ZXVlLg0KPiANCg0KVGFn
cyAwLCAxLCAyIGFuZCAzIGluIFNRIHNsb3QgMCwgMSwgMiBhbmQgMw0KDQo+ICgyKSB1ZnNoY2Rf
bWNxX3BvbGxfY3FlX2xvY2soKSBpcyBjYWxsZWQgZnJvbSB0aHJlYWQgY29udGV4dCBiZWNhdXNl
DQo+IHRoZQ0KPiDCoMKgwqDCoCBob3N0IGlzIHBvbGxpbmcgZm9yIGNvbXBsZXRpb25zLiBUaGUg
Q1EgdGFpbCBpcyB1cGRhdGVkIGJ1dCBDUUUNCj4gwqDCoMKgwqAgcHJvY2Vzc2luZyBpcyBkZWxh
eWVkLCBlLmcuIGJlY2F1c2UgdGhlIHByb2Nlc3Mgc2NoZWR1bGVyDQo+IHRyaWdnZXJlZA0KPiDC
oMKgwqDCoCBhIGNvbnRleHQgc3dpdGNoIHRvIGFub3RoZXIgdGhyZWFkLg0KPiANCg0KU1cgY2Fu
IG9ubHkgdXBkYXRlIENRIGhlYWQsIGhlbmNlIHRoaXMgc2hvdWxkIGJlDQpUaGUgQ1EgaGVhZCBp
cyB1cGRhdGVkLCBidXQgQ1Egc2xvdCAwLCAxLCAyIGFuZCAzIHByb2Nlc3NpbmcgaXMgZGVsYXll
ZA0KQ1Egc2xvdCAwLCAxLCAyLCAzIGlzIHRhZyAwLCAxLCAyLCAzLCBDUSBoZWFkID0gdGFpbCA9
IDQNCg0KDQo+ICgzKSBUaGUgaG9zdCBhbGxvY2F0ZXMgdGFncyA0LCA1LCA2IGFuZCA3IGFuZCBz
ZW5kcyB0aGUgY29ycmVzcG9uZGluZw0KPiDCoMKgwqDCoCBjb21tYW5kcyB0byB0aGUgc2FtZSBz
dWJtaXNzaW9uIHF1ZXVlLg0KPiANCg0KVGFncyA0LCA1LCA2IGFuZCA3IGlzIGluIFNRIHNsb3Qg
NCwgNSwgNiBhbmQgNw0KDQo+ICg0KSB1ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2soKSBpcyBjYWxs
ZWQgYmVjYXVzZSBhIGNvbXBsZXRpb24NCj4gaW50ZXJydXB0DQo+IMKgwqDCoMKgIGhhcyBiZWVu
IGdlbmVyYXRlZCBhbmQgcHJvY2Vzc2VzIGNvbXBsZXRpb25zIGZvciB0YWdzIDQsIDUsIDYNCj4g
YW5kIDcuDQo+IMKgwqDCoMKgIFRoZSBDUSB0YWlsIGlzIHVwZGF0ZWQgYW5kIHRoZSBDUUVzIGFy
ZSBwcm9jZXNzZWQuDQoNCkFnYWluLCBTVyBjYW4gb25seSB1cGRhdGUgQ1EgaGVhZCwgaGVuY2Ug
dGhpcyBzaG91bGQgYmUNClRoZSBDUSBoZWFkIGlzIHVwZGF0ZWQgYW5kIHRoZSBDUSBzbG90IDQs
IDUsIDYsIDcgYXJlIHByb2Nlc3NlZC4NCkNRIHNsb3QgNCwgNSwgNiwgNyBpcyB0YWcgNCwgNSwg
NiwgNywgQ1EgaGVhZCA9IHRhaWwgPSA4DQoNCj4gKDUpIFRoZSBob3N0IHJlYWxsb2NhdGVzIHRh
Z3MgNCwgNSwgNiBhbmQgNyBhbmQgd3JpdGVzIHRoZQ0KPiBjb3JyZXNwb25kaW5nDQo+IMKgwqDC
oMKgIFNRRXMgdG8gdGhlIHRhaWwgb2YgdGhlIHN1Ym1pc3Npb24gcXVldWUuDQo+IA0KDQpIZXJl
IFNRIHNsb3QgOCwgOSwgMTAsIDExIGlzIHRhZyA0LCA1LCA2LCA3LCBTYW1lIGFzIENRIGlmIGh3
IGZpbmlzaA0KaXQuDQoNCj4gKDYpIFRoZSBob3N0IGNvbnRyb2xsZXIgY29tcGxldGVzIHRoZSBj
b3JyZXNwb25kaW5nIGNvbW1hbmRzIGFuZA0KPiBzdG9yZXMNCj4gwqDCoMKgwqAgdGhlIENRRXMg
aW4gQ1Egc2xvdHMgOCwgMCwgMSBhbmQgMi4gSGVuY2UsIHNsb3RzIDAsIDEgYW5kIDIgYXJlDQo+
IMKgwqDCoMKgIG92ZXJ3cml0dGVuIGFsdGhvdWdoIHRoZSBvdmVyd3JpdHRlbiBDUUVzIGhhdmUg
bm90IHlldCBiZWVuDQo+IMKgwqDCoMKgIHByb2Nlc3NlZC4NCj4gDQoNCkNRIHRhaWwgaXMgMTIg
aWYgSFcgZmluaXNoLCBDUSBoZWFkIGlzIDggYWZ0ZXIgc3RlcCA0Lg0KT25seSBjb21wbGV0ZSBD
USBzbG90IDggLCA5LCAxMCwgMTEsIHdoaWNoIGlzIHRhZyA0LCA1LCA2LCA3DQoNCj4gKDcpIFRo
ZSBwb2xsaW5nIGNvZGUgZnJvbSAoMikgY29udGludWVzIGFuZCBjb21wbGV0ZXMgdGhlIENRRXMg
aW4NCj4gc2xvdHMNCj4gwqDCoMKgwqAgMCwgMSwgMiBhbmQgMy4gVGhpcyBjYXVzZXMgdGhyZWUg
b2YgdGhlIGZvdXIgb2YgdGhlIGNvbW1hbmRzDQo+IGZyb20NCj4gwqDCoMKgwqAgKDYpIHRvIGJl
IHJlcG9ydGVkIGFzIGNvbXBsZXRlZCB0byB0aGUgYmxvY2sgbGF5ZXIgYWx0aG91Z2gNCj4gdGhl
c2UNCj4gwqDCoMKgwqAgaGF2ZSBub3QgeWV0IGJlZW4gY29tcGxldGVkLiBUaGlzIHdpbGwgbGlr
ZWx5IHRyaWdnZXIgZGF0YQ0KPiDCoMKgwqDCoCBjb3JydXB0aW9uLg0KDQpUaGUgcG9sbGluZyBv
ZiB0YWcgMCAxIDIgMyBpbiBDUSBzbG90IDAgMSAyIDMgY29tcGxldGUgd2l0aG91dCBlcnJvci4N
CmFuZCBTUSB0YWlsID0gU1EgaGVhZCA9IENRIHRhaWwgPSBDUSBoZWFkID0gMTINCg0KDQpUaGFu
a3MuDQpQZXRlcg0KDQo=
