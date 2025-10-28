Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719B1EE033
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 12:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761655692; cv=fail; b=KxoGnxXQmAnu8/bcJePcWIqgjIKiFoZQzvFqGyAekTr2eTEKd8nkcTd5sSXgk+TWPCCZgyLBYc+zM0R+FfvQ+SIcYJ+HavQzN70me0ZV3iX67MV+g6NRY6n4ShQ3pRBD4QIEAeGfYTfZJXNlXj2VdcfROhADVUqXP6opc1X+dE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761655692; c=relaxed/simple;
	bh=EpjOW7861sNhSmcoPXfUv+eLUHxFha96viBBciDoTBA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UGPg8YrnST8/YqysyeIwUzNawWpPDClLeS/YtGJQ0WHGO4+4iey+Bv/ibHPuwgsnFRDwR/6j7vbPSVAZ9nNJwNFgIXVg7YGN69ZKygqbNYDAvbAakRA9fOYUU6uVSeYrP8jc5okgvTaYIo61oJ79THnBZmFAeNw17HAKNN/Rqcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Qv0qiw9m; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=C2YmAZ0d; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Qv0qiw9m";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="C2YmAZ0d"
X-UUID: 58eb5a82b3fc11f0b33aeb1e7f16c2b6-20251028
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=EpjOW7861sNhSmcoPXfUv+eLUHxFha96viBBciDoTBA=;
	b=Qv0qiw9m9pzrriP/p4PhWHWZm0g03L0VCDTQfejg2GGJtVV+TQgGHbrEp63HBlIgVKXSshGEKK87WjU1xkYsEt8kr/iz9Qjxi8bf64/AlmxUX74D/oNLRctXNL+xLaFSuBo0R4ks6sG9E+FAkCypH/mbZ7zwgKa0fc8iWq0dCME=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:50c2f014-8167-44fa-8e4c-8c1e82039daa,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:32301ff1-31a8-43f5-8f31-9f9994fcc06e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 58eb5a82b3fc11f0b33aeb1e7f16c2b6-20251028
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1775792731; Tue, 28 Oct 2025 20:48:05 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 28 Oct 2025 20:48:03 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 28 Oct 2025 20:48:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rw+MI0cQAVYvSWIbrNUu9Lr1BnPuEtS5fpEYMc5weH8S+hZn9eOCMcN6LmJ6hmce5hRVpR8R9gXluKJrfySFV8wmCmQjBsXPAUZhJpGmn19C/+juwi+1yO3AXk/eF1N3p2+ONcCcvmEIavtaolMOF1mLtjehRRu7dFNLX/QKAxCdeKFyY9ZVQKu2dpTXu2HdsIwXpwieGGNFdcOq3Okfew6T6qKIBhbHvXliK9hYi346zqD7a1F/3g9n9PckxS1e6vokmhssXhPKGbNSyV8zUl9Tc5yW4iN8zNjIc+G3nqN+DC9z9Cfm1sn6pMmkdsD4hTeTh/4Oj2V6voTD6oLddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpjOW7861sNhSmcoPXfUv+eLUHxFha96viBBciDoTBA=;
 b=QZXD39atPKhefj0p8dlON8V7orA4AaGUmmZBvpSv5zEJeLxE5ftk4VamAsfjpDTreX0xOlWn9nOZkgELctlPdiZWBOgV1mUgXKWmqD6bI1o3HQq5pzMsIqoD6k4t4YHTRUKpAYP7OEZUf+NWOwB29UBIBMthsvUaMqqks4KEFFeaCXjMhznwu4RTl/Fmlb5K7rlWvYMXxjWOh/rBylfzNjDv/Nixc/ThprN+cKhVEgMGopWNhEnu9RUkFhS4F4rK5HYIK8JI2TK0tH35YeQzBd73+JtQpCa/yqICgW8Y+Zm6yDp0lIIRBM+ncoWTWCT6NBLINDAukpxR3f8JX60CyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpjOW7861sNhSmcoPXfUv+eLUHxFha96viBBciDoTBA=;
 b=C2YmAZ0djR7/bL7m5qPU7EWBH57aMxKXjduMZGoh1LW7nCUBDhqXgdk13wN0GP8TOtlTgVN1APck/K8wlsrIsVklZrqX6/FM21/lio8ZMshHDh6915e2MnixU/nWl5B8+v+WsPdh2HgzKkeiQOxYt7WerRYdf9VtcTcHZsOteUI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI6PR03MB8706.apcprd03.prod.outlook.com (2603:1096:4:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 12:47:59 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 12:47:58 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "andersson@kernel.org" <andersson@kernel.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>
CC: "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "chullee@google.com"
	<chullee@google.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "ebiggers@kernel.org"
	<ebiggers@kernel.org>, "gwendal@chromium.org" <gwendal@chromium.org>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "huobean@gmail.com"
	<huobean@gmail.com>, "mani@kernel.org" <mani@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] ufs: core: Really fix the code for updating the "hid"
 attribute group
Thread-Topic: [PATCH 2/2] ufs: core: Really fix the code for updating the
 "hid" attribute group
Thread-Index: AQHcR2S4UVT2hLZVAEeJobWGLwI2U7TW4DgAgACjKYA=
Date: Tue, 28 Oct 2025 12:47:58 +0000
Message-ID: <98c45a4b9a409d0fb187bc5228076d088650555c.camel@mediatek.com>
References: <20251027170950.2919594-1-bvanassche@acm.org>
	 <20251027170950.2919594-3-bvanassche@acm.org>
	 <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
In-Reply-To: <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI6PR03MB8706:EE_
x-ms-office365-filtering-correlation-id: 058396ed-d603-457c-5c2a-08de16203920
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?L0t1cUJ5RDNxYWEwQTRnOWVHSFdzajFQUjJ3UVN2bE1HWFpmRmVBcUpaSlpI?=
 =?utf-8?B?QmxpVXY2bEhQRFR1UjJQaU9NNGlKY3NTdFFTM1JlZFNIRFVpZ2lGaVRsNDJj?=
 =?utf-8?B?T3Q3dENaQ2JYdTE0eWNxQWlJNzAzMDlvVXRvVE40QTAwUzgzNGtGbWp1NTha?=
 =?utf-8?B?YnhES1lZVVFVNmZESDhuenBYanN5d1UyNFhFR1FXa0ppSmJCUzFCTjQreG5N?=
 =?utf-8?B?TXo4eUVXNXZXbFE5UzVkU1owUWEvaDIvTXk5T01qUGFGZ3IyTVNYemxVVGNX?=
 =?utf-8?B?OHI5M01PWDZDS2ROZUJwZGZDaGZaN21XRTJTS215VXpoTDdONmFNbGc4Vjdt?=
 =?utf-8?B?T3V6TStMV0xkcklNRG55ZjZLaDA1SzdlRnBhYUUzVkdUUW1zRWxHMmR2QU1O?=
 =?utf-8?B?dzV6R3o2SVJrbCtLUTZGejUvd1lxaEIvYlZvU0I0cS9hTlg4TW1MUXZ2NG9S?=
 =?utf-8?B?S1VTa1lhQWRrRFRGNXZPcEFlZkdRZGI4d1BSRDdueU5YUVIrc29XdVI0Y3hX?=
 =?utf-8?B?RUllQjJYdzdZeVc0V1RtZEdtYVNHODlja1gzRmV2UjRCK2xGMXAwVVAzWHA2?=
 =?utf-8?B?TysyZEN1d3JlL2hyZzQwZGd4OHpKUEs2WFdENTJRLzB1NUpPcWRrek5jY1hR?=
 =?utf-8?B?RjU3ZEpET0FIeTQ1OFEwdW92SUZNc01icWdVUGNNdEhTMFNNeUxpMFAzRVd0?=
 =?utf-8?B?ZkFIajFyTXM0NzhFK2xlaEt0TUNzUVFjdDVRYVJhdExqZVUyTG5BS3dMbWtH?=
 =?utf-8?B?U3VvandMa0ZnTVh3TDBKWEN3OUxqYmlmdTJUMVZBZGFEbmwzWXdSeWdMMExH?=
 =?utf-8?B?SWhEcjh1RjJGcDhxdVdDaktRd2U5Q0RjMUZ4ZmdKMjNIdXdyTjZOanVCT0ha?=
 =?utf-8?B?RUxoOWVPUXdIVWRUTy9Db1BNaEMzM0RXYU1PT1FlNjJSalhpZ2NZOWtmTlBQ?=
 =?utf-8?B?cjhXcFJEMzR3a0k5MGZDRy8vTHM4VFJmcnVFNmZ1K1J1Z1MrdmVIbWhNRU5F?=
 =?utf-8?B?T3puT0ROT2NyR3dybWN4UWVaUFQxb2R2L2Z3T1JqTnl2NVRMSDEwQUVuY3FH?=
 =?utf-8?B?ZFhycGN6SURTcEpJaVZNRGtUQlRzVGRhVFFab2lUMG1Ycy9UOEcvSHNCNUJt?=
 =?utf-8?B?cVUvbWdzZWtjOW91MVIvWHZnMUtSa2gwbkMyc3pNZUxZYk52VVBMUVVBckdS?=
 =?utf-8?B?NFFCSFl0K3F0aEJVYWRpRU15N04yU0xQdU1VKzNybDVzQm9neDZnamo3NUhy?=
 =?utf-8?B?RGJCbW9GZkV5WTRjbldVcEZvTUFrVUxOWFFaTUQyTEpiTGQzUElxOEFKdG5x?=
 =?utf-8?B?RUFDcDYyYzBxcFlZd1YweTkvY3lpRXFzQWZRRnZyQ2NLdGh2RXpOVEZ0NkhD?=
 =?utf-8?B?Y3krd1EveUthUEhjVFNNWUI5MXYxRkwyS1JHWGkxUk9MWXFWVDN2V3FXWmYy?=
 =?utf-8?B?Q3BUMUxnVU8ycGpDLzBRbjkvVXM1ekh2QXllbXVpWmt2TE1kUmNSL3FQUFBB?=
 =?utf-8?B?bTR4ZG4wTnlSRTZCaXJ0MllxTHd2ZEwxeVpMUGlmMW1wWHVCWXl2YU5lYkJC?=
 =?utf-8?B?cE9rKzdRN3l4b1hQU0dQQkZNbkZ0d2kxV1FMNDdmNSszTEtYb1diZzFPdVVO?=
 =?utf-8?B?T0FPMFFpeXVlcUdqVmkvMXlUQTdjcGVxMko1QWpaN255UWFTQ1RkNnhiS0la?=
 =?utf-8?B?NGp4bmJHQjZDd3FjQjZzd0pFS3RBdXp4OVp1TUZFcHJ5LytnZkgxK0xzdVBZ?=
 =?utf-8?B?cDY2ZGhoaVkrdlNJNk8xcGxPd216a291cDFoYUE3MHNZeE1BZUF4UFcwcktQ?=
 =?utf-8?B?TERxVlVtc0lFbFhYQlJ1T1lkaDBSUVVhc0tKL05QN1dZaHljeDJacTZ6ZVhV?=
 =?utf-8?B?dUVpOUZrVkRFWCsrdzdFYmRpVG8xVXFIcXczZWNIaVE0VXc0UEdsbmIrdWUv?=
 =?utf-8?B?R3Bod2ZJdEFHeG04bERkVDh4a3VVTGxvb0VOWTd3YnFlSTZ1SGkwQmg1bkE5?=
 =?utf-8?B?eGxoZWhjRUpFVHZZRSt4MTJhYjBaNmg4c2dTcGtmTFk0QU1ndm1HUWVPOHU1?=
 =?utf-8?Q?Memuij?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE1HZWdjSTBqdHArWlhYekdDMWkxQk81aUJlY0RaNjRyY1hFK0dCdElOb3BQ?=
 =?utf-8?B?dld6YnFyVDZjbG1tS2RlN2FaOTR2czYzb2N2TTBVUWc0WlZiclRwOGs4SlNY?=
 =?utf-8?B?eGdsMHVlTDIyWlZJbGhna0V5UzNQcDYyaGMxRExSMEFLbkpwVjdtdWgySHlq?=
 =?utf-8?B?a1RkN0JZU1VOZmpjYmgzU1ZqdWczWTN0Qlg2ckNvODllVHNsNVkyaEcwWmhQ?=
 =?utf-8?B?K0N5dkFtUHZ5d01mMjd3L2NoK05rc3NhNEVpZjlyNUloc0twOWVQTExaUDFh?=
 =?utf-8?B?M2ZVdm4rUDlKR0kzY0VsaG90YVB4eFVkMHdhU2ppZy9YbEVSRm1aRFltTGZt?=
 =?utf-8?B?TUUwQzdHQllaYXdWand4T1RVVGZueG1BT3JwdmVqVVh2MW96YXVCdWFlcSto?=
 =?utf-8?B?cUFpbzdIRlFjVXZNdGFHUGVHMjRtWjhNcGRKc2FJcnNmT2pMTlRyL1p4WmFP?=
 =?utf-8?B?K0FnUHJOVUFJZ3MxR3FNZXJOYWhITVFaWmdmM1ZyT0w5dzZ4K2ZVYXdFdlpR?=
 =?utf-8?B?alBXQ2kva2JCZmplbE1PSlV1MUlqSWl2cTB2Y0tuNnA2QjJ0OHJUTFZFcWp0?=
 =?utf-8?B?Z1NhYS94ODhYZmhjT2tpRzRsd3ErQUJCRFVLSkIveUpVZzRRc2M1a05ZbFg3?=
 =?utf-8?B?OW4wN2ltcGlrazFaV05YL1YwaVk5bVEwRGJUUUI5cEF5cWVQVWI4cDAwK2Ez?=
 =?utf-8?B?UFZLOHFSc0NiMy9KejY3VGNsTDFFc2JpMXFLL3lrc0NCcnZDOFdUaWM5TVRa?=
 =?utf-8?B?Unhra0djc09rWVdmY0tIWHI5UDVjWDg2Nk9KVXZlQjc0WXRuSXlmS25FSnE3?=
 =?utf-8?B?SUlrZG92NGJwVHJIWEM5QzNJUERPRzUyV0ZiZ0dOTXRYem1icUdzcXNOYzhy?=
 =?utf-8?B?a2pOVG4vOWhOZVNpU2UraG5PSUptWWhJSDduUWY5aUZJZTBTd2VXZ0d5QXdn?=
 =?utf-8?B?ZmZuSG45Zmk5UUlGVjNlSVpWQTlFZTUySm45UHE4UjdtVUhJK053WlVhTWxj?=
 =?utf-8?B?dzNseWRybWg3Mnd1OVFuLzhGNUU5K3NlRWdhc1FQYkpjWFk3WlQrcVBzYTE0?=
 =?utf-8?B?RTYrYi9OVzIwYWtFeGtPcjRQQWkxeWNYcng4M05TWUxmRW9td2VYUnlwbDVM?=
 =?utf-8?B?WFR5cmRIYXppL2Z5WFVmZHFOSHp5V2ttUlltOTlNY0VlRVNseVgweGo5R1VU?=
 =?utf-8?B?bkVNS0FQMGRtbVBRQnJ5UzhHTDYwTHVLa0FpQ3FQZnorYzFzTTk2Y3N2enpK?=
 =?utf-8?B?NEpxVnhvNzNjcUphMStIbGMrOTRDQjRxZzVRMTRXRHFzSDZNSmY0clcrK3RJ?=
 =?utf-8?B?dnRxeFBwcVpOb2RhL0o5c3JxdGYzM0FxZEZjaHR3Y2FIR2Z1dmIxK0lYZFJI?=
 =?utf-8?B?NkVycHFGRG1nejUvWG1ZV3BxOUZhVGVyL0dhcXliM05mU3ZVMmV5cWpORXdT?=
 =?utf-8?B?azVMRmdJWjBVcE0xd2E3TlpTaHE2N1c0Y3ZXMWxPMldDRWg5Y3U5bHpDck9k?=
 =?utf-8?B?R3dxTUNWS1hOYml4V3NEaStvNHJtSzQ0OTdkTzlBRldFY2hjNlFuS1cvQ2lZ?=
 =?utf-8?B?aHNTQkpXMlVFeUZBb3owcGs4S3ppZTduYnhWMUgzT0NZWXVVaFlUb3EwS1lG?=
 =?utf-8?B?dWdtRVhvcmtLSDdRTzlNeG9nS1BiRVpMRTFCOXk2SGtWMGlDZVJqVnJBNHls?=
 =?utf-8?B?VXVNcEdIMWhMN2QyTFRkbGgzVkpsb09MRWlzWHNNbGhhak1IdlNtZHIzcS9M?=
 =?utf-8?B?UkFiV3Q1czl0T1lFYU5YZE85bU1YOW5XVEF0aFRlZTUvTVEzMVk3V2g1bGwr?=
 =?utf-8?B?azBQZEEyUlcwM2JOVXhZMktuWFg2L1pOZ1hSU1BiSCt5S25GRTdKdE41WWs5?=
 =?utf-8?B?djFaMkdTeEpVdXBDT0UzaUxaVEZWRklLN0ozV3BDa00zcUZqQWk0ajlZc1JQ?=
 =?utf-8?B?UEpzMko3amNYODJpZlNxQXVlTGE2WVVhUkxBNmlBN2FSaDU3aGpnRzR1N1A0?=
 =?utf-8?B?NEJqejI2YUV6cVZnOTNObkozTG1zSnZlcGZ3bzZnRnJzTkdkOFhjL3lMMndS?=
 =?utf-8?B?ZVJhY05GZnM5T2cwUVYrNHhHRHJ5VU5LdzJ2S2Z5ellpcWFCMEpCVWtlY1B1?=
 =?utf-8?B?ZTZ3NjE2N1ZCMkZPSlRQeHdIdEdHc2hNSUtDajY0OUcxWm1kSW1nME1acDMw?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3502B93E9F0D6F46B6994802C54B3068@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058396ed-d603-457c-5c2a-08de16203920
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 12:47:58.6282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mz+MA+3Jjb6Y2mtqwjvoVTyr/4ZEk9j20SHJbU/yTQypSQDXyh04GbyBrDorokHe8i0jcPVGlKxDYI2p62z94w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR03MB8706

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDIyOjAzIC0wNTAwLCBCam9ybiBBbmRlcnNzb24gd3JvdGU6
DQo+IA0KPiANCj4gSSBkb24ndCBmYW5jeSB0aGUgc3Bpcml0IG9mIHRoaXMgZml4LiBUaGUgZGV2
aWNlIGRyaXZlciBzaG91bGQgYmUNCj4gZGVzaWduZWQgc3VjaCB0aGF0IGluaXRpYWxpemF0aW9u
IGhhcHBlbnMgaW4gYSBjb250cm9sbGVkIG1hbm5lciwgYW5kDQo+IHdlDQo+IHNob3VsZCBub3Qg
aGF2ZSB0byByZWx5IG9uIGNvbmRpdGlvbmFscyBzcHJpbmtsZWQgYWNyb3NzIHRoZSBkcml2ZXIN
Cj4gdG8NCj4gc2VlbWluZ2x5IGdldCB0aGUgcmVzdWx0IHdlIGV4cGVjdCAoYW5kIGFzIHRoaXMg
aXNuJ3QgdGhlIGZpcnN0DQo+IGF0dGVtcHQsDQo+IGFyZSB3ZSBzdXJlIHlvdSBnb3Qgd2hhY2tl
ZCBhbGwgdGhlIG1vbGVzIG5vdz8pLg0KPiANCg0KQWdyZWVkLCBlbnN1cmluZyB0aGUgY29ycmVj
dCBmbG93IGlzIGJldHRlciB0aGFuIHVzaW5nIHNvbWUNCnRyaWNreSBwcm90ZWN0aW9uIHRvIHNv
bHZlIHJhY2luZyBpc3N1ZXMuDQpQcmV2aW91c2x5LCBJIGFza2VkIGFib3V0IGZpeGluZyB0aGUg
ZmxvdzoNCiJXb3VsZCBpdCBiZSBiZXR0ZXIgdG8gZW5zdXJlIHRoYXQgdWZzaGNkX2FzeW5jX3Nj
YW4gY29tcGxldGVzIGJlZm9yZQ0KaW52b2tpbmcgdWZzX3N5c2ZzX2FkZF9ub2Rlcz8iDQpUaGUg
YW5zd2VyIEkgZ290IHdhczoNCiJUaGF0IHdvdWxkIG1ha2UgdGhlIHN5c2ZzIGF0dHJpYnV0ZXMg
dW5hdmFpbGFibGUgaWYgdGhlIExVTiBzY2FuDQpoYW5ncy4iDQpCdXQgaWYgdGhlIExVTiBzY2Fu
IGhhbmdzLCBzaG91bGRu4oCZdCB3ZSBqdXN0IGFkZHJlc3MgdGhlIExVTiBzY2FuIGhhbmcNCmlz
c3VlIGRpcmVjdGx5Pw0KT3RoZXJ3aXNlLCB0aGUgc3lzdGVtIHdvdWxkbuKAmXQgYmUgYWJsZSB0
byBib290IGFueXdheS4NCg0KQW55d2F5LCB0aGlzIHBhdGNoIHNob3VsZCBiZSBhYmxlIHRvIGZp
eCB0aGUgd2FybmluZywgYWx0aG91Z2ggaXQgaXMgYQ0KYml0IHRyaWNreS4NCg0K
