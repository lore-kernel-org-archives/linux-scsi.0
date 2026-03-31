Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874F20B810
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 09:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950222; cv=fail; b=Slr6Nw9+GRQF9vIeKm8galO4q5RFRCRVy2pSB+uZKVcfle55Ah0LrvamSNkhD85RSnFYAQMS8OFQuNsGWhFf3MXAgEaBUwFFFp6IY7R1q6qw43Llw5hF0EiEayeQ5KI72Mbswrf/kSmbBQrIyFf5DNWbPf6rdiyd6fMkCu4eZAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950222; c=relaxed/simple;
	bh=TBJ8LnEOq3J1AHDb2fQzpyGedMfTNBu6MsDpJ7GkNn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DEz11XCN4r8JCU9WaBSsUCqzEM7TWW40mjsczUcPEg78X9Ie8mDh5vlKC0RYqiSo8AopgD20XyH8fVWDjVu/NAuJJFYjm5tQzyVNT3r522YVkmPnwvToErvYD4c+Pq2B3iW7NA5N/Upvm8cXKjwPn2CGwp5oWf9+Tp8DdAnI2jM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dwMGLHYb; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=DQ3TN9bB; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dwMGLHYb";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="DQ3TN9bB"
X-UUID: 155a51ac2ce611f1ae70033691e9ac7d-20260331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TBJ8LnEOq3J1AHDb2fQzpyGedMfTNBu6MsDpJ7GkNn0=;
	b=dwMGLHYbltwWhPk3Cfvvw0ynRNhHLgtRX0r9sknt02SuqrF4YgBtnZ5Q+qNB0w87LKaIDgvn0TEOExohUYYZDwLcW2EtDVyYznKXWvO6wqEIpCYwBq9aeNxcasQSOc/9q8C0xevkkGe+8t/GyPh1JFuoxQuf+bjwgmgfNdhWmvk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:be2a70d2-66e6-4b3a-9af1-b3c029f87792,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:678f56d5-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 155a51ac2ce611f1ae70033691e9ac7d-20260331
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1462361555; Tue, 31 Mar 2026 17:43:33 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 31 Mar 2026 17:43:32 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 31 Mar 2026 17:43:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lc+GOgLUzSZLwlaD1Cwy6n5smJsuk62zkB6rZjhzHI+NKc1+No8+nimoEf1TNI8HXA41HY9vhhiu7Q+5zIKKCCDByBbaHwa94XpHexJiXh/eZLRqvGuw+2v7YknpAp50YTSZeJbLs49LAhQ51LO+22indfLk2QPcEE9/ut/hGAiI8v0WyfehUgPscL84ykDuMaXLGLlhEXH6sWvqtnH0g7PUiRJaFrSL+GkqsxpI7SQ456SDd0vKLor7jJ+5DrmlmgsZqdlvWq7bc9hiAU0Z3ZmJ2wRdr5QTjdyDkCfU74EAyeLetyWHYjHYa29PgNA7L6ry+BjGh5jUMWCSot0BEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBJ8LnEOq3J1AHDb2fQzpyGedMfTNBu6MsDpJ7GkNn0=;
 b=RyabVZzU53bWsh8NiCUyTO3+lTJVfVRak8og11ZbyBV31p7sYiySJJR8CMZwJCrVg72CP76gBdfnz2CoTft9SLJZUTM40sGO8d+ujzPd6ixliKa5COk4zTUhNBLfXQMVp7tJFguF8IuFnryz4PP9Mkw6N4pgyr0xCzpdGIhojutx8rH5S42Dk8kGsWzgMVQiHZikY3SJezVhl+BPEIQNugIfWgMymP6/FjcFlQ8/Pb1tn/0DRxHJkhKN9lyp1lbyC6Ol8jwqe2fvAUMnOkLqGnj+n3vreAbSXH9eohg46VmKgVXlWWv2Kfgf2vQ8jsmwLhTJ23gvnBXthSRHXTN3dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBJ8LnEOq3J1AHDb2fQzpyGedMfTNBu6MsDpJ7GkNn0=;
 b=DQ3TN9bBEAJxfZndGBUaiXif8FtNs+CmJF30pWKA0LDzd6tnHYj7Lt4sN6FH7w89UzRxqaOJ5gI9WAkj9MWcg3P5q8i75V6T7+a0pIWfuBPWoGVUnaPcVJvwyA5Nx7et9+EsJMrSVn8NOql/vIO5OiI3GCnZXKseA1wjtL/o6iw=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by KL1PR03MB8516.apcprd03.prod.outlook.com (2603:1096:820:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 09:43:30 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 09:43:30 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>
Subject: Re: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
Thread-Topic: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
Thread-Index: AQHcwHPTaq/YlHAI7USfheU+xp3IirXIZMCA
Date: Tue, 31 Mar 2026 09:43:30 +0000
Message-ID: <b76180520d10f2811c072f0944a0864e779e3868.camel@mediatek.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
	 <20260330183311.1941942-3-bvanassche@acm.org>
In-Reply-To: <20260330183311.1941942-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|KL1PR03MB8516:EE_
x-ms-office365-filtering-correlation-id: 6fcb6ea3-ecc6-4ad3-b7eb-08de8f09f776
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: nfq2bJbKicdNby+H1G2Duy7pWHWD0brA5cnNTu3EGlN5nqD9s2FeKRYSb7RjyndRfDLpmlRbRKrd5QPzly2oopVbEUb9OdaTqpl/Cyyk4JjMG6Yqp8GpGQt5uV2gLbVY9kUo+ZfOogsQTwYT+pw1NPJ+KMaZ/YKlMdvlkrejHguAWZ7h5Z5qwMrg7yF5F5aH55D9fdnRi7iIFsWmjGWI2Nuh4p2ZqmZMXYJ7IoP7oH45OOQsM6ULcSaaivLWRFLuHRA/ruMfcRdfUjIHpDJxJ6vBv5ya9+NWbgzOxcLL/Cb/xT8g9uH/vdMNdF8VzAdwBxwZpIVQ+SKGAd7V6zdDuZcRDFYTNenc3+EblbU0xQq597Lk3VwOplAZr+99gyW30WJKOADYxBl2rUu+lN5jpFNPxqOU1IJz8jpX/9llR/VrOyNoPGT767rhTBnH9RzZszp4cyZs3Z+zvZNJmGG5TLm0ZCvQ2/U/p+IP6Ws0iQz+w0RUKzatW2OP5LwgnfniR3MYd4ooYrQAPVFaAdYjsnaAYcPFRDlFS1W8/9+L/XOhbD3qYY5aq87Dg5T38zoImPdjFm/XbJOmz3BcrIkF/XchoBRmLj+Rce61Yv2gcsR+9MhcxUJc1V6uQ3wkkmc63ObqACGwKilYkPOJlG41XnpyMZSxqHtMoKbGAldPKtWdm9szQBXgPjD6MQL8nFgBXE8T15EPHW7PwIvo1NJFZMtpdCS5xKt7VjXcdY+Lt//ntsFoasTWojDu3fMQMP+zMA9mhhJBN/0f5oFe0rcneN1qpXgIX8BKDRyiqAZBXrY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWRqUDNxVUYvWVlPTlAvcmpWcWd5M3dTSWVPRjN3UitSdDVOWnZtcExPR28w?=
 =?utf-8?B?bHJXckF4Tm5mRURIM3ZsTy9OZFRRY1dSNnUvR3RiTktkb3FKN3JNRXd2QTJz?=
 =?utf-8?B?R2RrMU0xNitOZnhlamNvcFVka3hsT2lJckdaWXJRN2VPYktXRTVrR013MlAw?=
 =?utf-8?B?NEI1ZWJzdFJzcThGQU15eXh1VjYzTUV0VkE1cHU2MzJid2JZZ1J5NzF6VjFU?=
 =?utf-8?B?eGtqbStTWmdHcXVZMXVHT2cxakhXREtoS2hBUWRDeFhQOEpYVTVBeGpxVWxK?=
 =?utf-8?B?NUxxNlMxc3JSdDJpbTNoUVZxYkxXMHV5UmlsdU9weGJxcGh3aHUxUVE5ZVdq?=
 =?utf-8?B?VE9TZzJuZ3FlUlVxUmwzS3YxUjNiQTBWN1RBUHYwVHlCVDJEdnBoQkhoeUl3?=
 =?utf-8?B?cmFXdHhBdVpTdmphQUt0eCt0eXBxQmNia21GdDEwNjF0aU1OeHgzV2NCYXVy?=
 =?utf-8?B?RitScXpRVTJlU3JhTHRPcFNCN2k2WjJXUDg2OEZRZUI0M09TcHJIQys3aGwv?=
 =?utf-8?B?ZUZQMWhTRFAyeDd4akpZSHFvdnlGTWRvek1WVTBxc3k1emJMbFdCZ1R1cC9G?=
 =?utf-8?B?ME5ZYnNkNjhrRHhsM2l4VjlUdkFaU0VaTHBSOHljTXNTRkJDWXRtdHZDT1Jw?=
 =?utf-8?B?SitUQllLZ2tMRW42QUgyV2hLL1E5Z1BOL1ZnWTByMSt0VHIzV1ZPcUJYL0dE?=
 =?utf-8?B?ODhpUGFUVjRtUllzcGJUcVI5dmZuNUNLdTB0VmtYZUdBS0ZXK3lMSHptQnhv?=
 =?utf-8?B?cU1LRE5NRHFiRXFhNkRRb1M0azVleTlvU3RDV21ycWZJbGpRWDk2blN2QXk5?=
 =?utf-8?B?VHZnNWtoWXhDdHd5akRmZldjekRTMXMyN0d0QlRNQ1djSVJXMW5CS0ZqWnlF?=
 =?utf-8?B?eGlDelFkMmtpZVU2ZzA0VEprZDUwUkZMV2l6cndRS25DS3k3VGNNWUJkQzhP?=
 =?utf-8?B?NUwwOEVFRmFCUGF3SUJYTkYxYkNKb1JOK1dDS3RDZitLZlBVaTd2RkMrMVJD?=
 =?utf-8?B?d2E1YS92alhiU2QwYi9ZM2htTGRtczNGSDNVaFlQWUhOM1lENC9mMHdnckI2?=
 =?utf-8?B?cnJWZ08vK1VJRGUrbE9jSGpIVTJPclRmTzVEdUVUVXIyM1BnR0ZhV2U0R1RH?=
 =?utf-8?B?R0k1RXJtYVQ2YWhHd2JiRTY0RDg4ZjIvaHJ3NDJRTmVISDd3b25JMVI5U1Ax?=
 =?utf-8?B?T2o2eFRFdFNEQkV3dFVYTlZ4VXBJa1JxeG5mZWNoTGdpK2V1b0hlSlpyUlIy?=
 =?utf-8?B?L0txdU85alpxc0pJYTNIcHJLRUhCL3ovcVBHTkJ0UjJvRWt6UXc0dnA1RFFF?=
 =?utf-8?B?a1IwTTFHMHlLcC9pdDVPTDZIM1d6WVVzcXJ6K0tPK2FSeC9xK1dTNHJZM05E?=
 =?utf-8?B?dzZYN0UrMnhFSWgyNVorTmZqZ2FhWFRSODlHOVNRMFQ3d0VtQ2xIY3NZQndL?=
 =?utf-8?B?Vm1YOHFGMUhmU2xHd3NlaXhkVFFVaStxMGpuTWpWWHZ6dCtxS2dRYklwN2dr?=
 =?utf-8?B?eXdGa2tyNHBVMmQ5b2Q4ck94QTk3V3RiT0RXQlQwcWpmbS82R0Y2ZWdVL1V4?=
 =?utf-8?B?TUNMVC9UTnU0aVF1UlQ2UFdRNEJvYytXUU4rTy9lamwzY1Y5NnE3cSt6Tnhx?=
 =?utf-8?B?aGVFTEsvOTJpK3RuS3J6NUk1WDdSWFUzQzdyN2lkV0g3d1Q1b1VmUzF2YkxH?=
 =?utf-8?B?Y2h6dFBNK0xYWTdCcHVPK2RFYTZLdWRTMHJYZEIzTW9NR3JhVkxMaTZ3UUh2?=
 =?utf-8?B?NmM0NDJUZ1RRaDdPa1hFYWhETXFxalVGV2t1MCtnZ2h0bFZPa0JwOGF5cks0?=
 =?utf-8?B?RHNLTnJ3Y2xOaUU1aWpnR1ZVa1BTVFpTajZlcTdNTnFkWmtMYVNYdHNFeEo4?=
 =?utf-8?B?NSsxK2cway8xcWMydnR5WVRSZktodnI5TmpUM2k1Wld6TkowaVJORVRRclhn?=
 =?utf-8?B?aithVWxCUlA3YXhsZ2lYRWlpcVNUVEN5OURzdjRsbGs0VEVyZ0o5R1BRWCs4?=
 =?utf-8?B?VDVVMFZrM25KcEY5NEo5R0hPYk1CQXhaL2xMa1lRRUl4WlBTWjB3c3cyMGpw?=
 =?utf-8?B?bkI5bEdhOUtVUEtBY0UxbXoyNGtZdXZaOEF1Rklxem9PODV6aXFzK3p6Ritx?=
 =?utf-8?B?SU1yUUwxS3VkOExPUTFiR2tNVlhFTzQzTHd4WFVNZS9NYmFteHlMU01CUGQr?=
 =?utf-8?B?bjNlL3hVblJ5OHlBRDdxVlRTOEhubGJwZjZGQjZhRXJxVVFmY3JUYTNEY0dD?=
 =?utf-8?B?cEtLaGhHUVlBdXcrWm5Yb0twRnk3R2h3V3ZMbGNpNkE5Tm81b09SRGpRZ2li?=
 =?utf-8?B?SUNiWngzOUNLT1ltZWI5ZDE1c0ZIckcvK2l6VDd4WDh6R3MwdGNjSnpPTHd2?=
 =?utf-8?Q?Z9JqnGuvG6c9rsxI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4FBBC5647A76E43B20F766377206B3D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GXVoZPc6RzqWxMwtCwvKY+HjYhCV3lCd4tpwmF8ELE4kWgY3s0/oQO5tdGF2Twi7FrRKoHxDfd0+Y0OcNfEejdmTtgaaFGass/9rJBHLC8tOyLfj108fZkfQ3JIZGEgT4rwBysVnPM7/JPg9UDMq2BGtosAsvrY2JuhdWER9nRmuqh54GNP9zZZT5MyX2ibaw3aVf6HSYdvkQuVPkLVflKU29k7PlT/kyVPxrim1rrbySh8P3iu0NnUpk/XPNbgC/voq9FAe2iVKOboNzC0brAK40INklJrJowCD5+3YWEWRyujmDGCVVIOK+94iobphckMUbYFaZl1Z1yclqo8dKg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcb6ea3-ecc6-4ad3-b7eb-08de8f09f776
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 09:43:30.2159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTMPUubhxxfaAKxU+N5o1vksGDapjqziXue6PtLV4PHbRT22ZqX9EpWgP0mfmQNAKNvSMy4zynQsEQ5UU2yg9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8516
X-MTK: N

T24gTW9uLCAyMDI2LTAzLTMwIGF0IDExOjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEludHJvZHVjZSBhIG5ldyBmdW5jdGlvbiBmb3IgcHJvY2Vzc2luZyBjb21wbGV0aW9ucyBh
bmQgdGhhdCBhY2NlcHRzDQo+IGFuDQo+IHVwcGVyIGxpbWl0IGZvciB0aGUgbnVtYmVyIG9mIGNv
bXBsZXRpb25zIHRvIHBvbGwuIFRlbGwNCj4gdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKCkgdG8g
cG9sbCBhdCBtb3N0IGh3cS0+bWF4X2VudHJpZXMuIFRoaXMgaXMNCj4gc3VmZmljaWVudCB0byBw
b2xsIGFsbCBwZW5kaW5nIGNvbXBsZXRpb25zIHNpbmNlIHRoZXJlIGFyZSBuZXZlciBtb3JlDQo+
IHRoYW4gaHdxLT5tYXhfZW50cmllcyAtIDEgY29tcGxldGlvbnMgb24gYSBjb21wbGV0aW9uIHF1
ZXVlLiBUaGlzDQo+IHBhdGNoDQo+IHByZXBhcmVzIGZvciByZWR1Y2luZyB0aGUgaW50ZXJydXB0
IGxhdGVuY3kuDQoNCkhpIEJhcnQsDQoNCkNvdWxkIGl0IGJlIG1vcmUgdGhhbiAoaHdxLT5tYXhf
ZW50cmllcyAtIDEpIGlmIHRoZSBob3N0IGtlZXBzDQpzZW5kaW5nIHJlcXVlc3RzIHRvIHRoZSBz
YW1lIGhhcmR3YXJlIHF1ZXVlIGZyb20gZGlmZmVyZW50IENQVSBjb3Jlcz8NCg0KVGhhbmtzLg0K
UGV0ZXINCg0KDQoNCg==
