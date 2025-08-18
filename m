Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4677082D
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755518149; cv=fail; b=t8rSy3WIROL+/RYEiapkGhOMF5uUyu77WDrxvZNj6JYUyLs8EZlPeQ920YpGJg5G2xs3yRWR3ewg+cO93v1gPD1jm1bjEqhrjmoOhspmyTsi0kFPHGks4/Bwqy0qLlzDJaxojKnovGcC305m/lr0MiN+QkhGfAGyHJvoutrbwTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755518149; c=relaxed/simple;
	bh=QGk6adU3t94qFZLGkyutI6P0ueM3QR3EeIgefZuLoVU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EkT6+V6I8Zzf2najXIjMxCzLKi6f6m3tRep9y8IC+QWcJ5xMNGMW2RIbdMae8uBFNBq7CXHeLnKCQ9tsRXvuOqlwOWk7m4/RX6taB4Z3a8smq3fbfeSU7F5Z2ckstLolRC2m6spBawU8HHZGDvR1q6m0Fd5BNAvwetmjqNfaYzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=G0kHVQyK; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=TtCSDJcA; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="G0kHVQyK";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="TtCSDJcA"
X-UUID: 436cac607c2a11f0b33aeb1e7f16c2b6-20250818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=QGk6adU3t94qFZLGkyutI6P0ueM3QR3EeIgefZuLoVU=;
	b=G0kHVQyK7gegHe2uvkyKnCAepARF5OjeQDImoWNlxoD1ss8eo788JYJacUxkwpXqeEnBqJajU1uv+pVdiLiH2d+cfW+ZM+HyMMU39FS9NdmLHem0BabfUDgnYHYpjrt+7w9XjLir/aeXyB0vLBTLZs7yiKo+2o32Vvm929Q/XV8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:1db73659-534b-4856-b312-c2fded1de5db,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:85bb0cf4-66cd-4ff9-9728-6a6f64661009,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 436cac607c2a11f0b33aeb1e7f16c2b6-20250818
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1762729299; Mon, 18 Aug 2025 19:55:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 18 Aug 2025 19:55:40 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 18 Aug 2025 19:55:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxD/rdmCWxpv8qBQXNMAouNcqPDTiyjMjYNXF3H14QsBZJx5K4eKXgEy57azqZLbYAuLgTzg7lzumDbLyhVZi7p+2zguhNZlDqj/VHDp5AGb+QMll3Cjhj4FFOfpmSF2mZvdV1ChFAX8Icgm8YuBsBc4CkCRdvEqQZp2KOxbXG5wPzf655Yiw0jwcKGlcW8vOtjqeILXBgfQMospw+KAwQkd9HvtQrZmdhwwLKPRx8BJMuC9m2L7ew0n4rkbAT31lyUq5Vzi5CQ7oHg+76ncH7qqimiGii5mnH/4RXeXad7Wl/VmjnMxCS/eXcsAMlwDH7Ofo/ULzjxoeAyY6BQmug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGk6adU3t94qFZLGkyutI6P0ueM3QR3EeIgefZuLoVU=;
 b=xXt/GFh7bTDH1s0WJ8bAgJNSfTEZ6go3KM3UYAMsE7r11M0CJUp3JfDDg3e1f631yHA7o/VxuQO6pho5Z/3QQcdaQNEQpZ47AT54q1/hBB9uhXYgEFbZ/oOGZxGuFpPXORKUNIRZqh9wY+jGSOeiLKnkJA/Rru2CjkFz/AEGTT50iz5vItQ/5Ony855xqiAAlqHtLuVDaBTN82yKgF+ChoQt2Q5Aa2VFOu2gdDbbsz8ch5GYyoN29eLfaRjbx1d/NpXUjfbQoq2ZgJTE7rWhXQAkeOlaGX5f+K17ypD8ocrxaXcYvR3M4hXflGOYeL5E8SMwxrdo1mFEXzpD4JKkWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGk6adU3t94qFZLGkyutI6P0ueM3QR3EeIgefZuLoVU=;
 b=TtCSDJcA1Ja9AyOCxUJW0fN/CdkZkiUePh69vKHEcXjsATEyS8z0yoNaMXCl3ZKqG9zGqMWjMWeOjF5acbWdKLmsDTOtLjVs0STdursf2D4FMY6ygizeCxpjKY8CaxsdE+eYnJ1ci3HTexfTUOQS1ZvWmiMrr5VztpcnGHETV/o=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8742.apcprd03.prod.outlook.com (2603:1096:101:204::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 11:55:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 11:55:36 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] ufs: core: Fix the return value documentation
Thread-Topic: [PATCH v3 3/4] ufs: core: Fix the return value documentation
Thread-Index: AQHcDf2tj0q+h8pAc0mvuzXZmHVBArRoUgeA
Date: Mon, 18 Aug 2025 11:55:35 +0000
Message-ID: <81443b2225f2a65d76c0d3e10d33a30aff1092df.camel@mediatek.com>
References: <20250815155842.472867-1-bvanassche@acm.org>
	 <20250815155842.472867-4-bvanassche@acm.org>
In-Reply-To: <20250815155842.472867-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8742:EE_
x-ms-office365-filtering-correlation-id: 9bb8d091-7664-45c6-1561-08ddde4e24a1
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VTRKcTh4UW5wUnJaZTVCVjNGUnNOZGNXdmk0MHBXbWN0SHVnQ0hpeGFBbjlq?=
 =?utf-8?B?MmtuR1l2a05ZR09VeVdiK1o4SmoraXpKY2VGRWpYK09TaE1kbERMcWwwakx5?=
 =?utf-8?B?dEVWMFZkWDRZUXdRVmhNTHZNVU0weXU5R3ZzMXc4eDBFVVM5WFpjbDBVck16?=
 =?utf-8?B?N0NJOW9UMzg5V1BVcWpZNXhzWmRlUnVLTjRqZDZNOUMrUzRPNlpyUk1QTEJ5?=
 =?utf-8?B?MjRoZUhMaWprYXFIRGpKYjAzR3dhZzlxeHR4eHZsTnYyd0wwTHJpQ1kyMzRh?=
 =?utf-8?B?QXJHdVNpWVJzampELzcvaXFTM1Y2anJRRGdjSHphRSt0aUU0aVkxeHh1NkJj?=
 =?utf-8?B?NW5aRmNJanNTcUgrdEk0UVA2b1Y3ZE1HUlJ6dWxVN3pNaDV5RnVITGZTWS9F?=
 =?utf-8?B?d0tGQ1FaN3VYaHRiblNsemRsL1RJd1BoZDBEZTVkek51MVY5VjZXc05HL0kv?=
 =?utf-8?B?S0dIZTFYQ2RnaVFXUHpoOHo0bnlXek8xcjY3dDZyWkJLM0I1eXpmNGkvSU1s?=
 =?utf-8?B?YnpwTFZOMmlHWTVwUlg1Yi8ySWNTb2dNTENYSEtHOHJjWU8wT2hlbHlMY3Ix?=
 =?utf-8?B?ZWl6a2IwV1h3aVZwaER2S0UrZmhWYUtyeEZPQkNwb202aXJoMEdWbVdJMkRv?=
 =?utf-8?B?WmgzcXlIbWwwSllkWERBMkxjbWNWbWZYNWo1dDY2SjRxZzNodkhGSm45akhv?=
 =?utf-8?B?UDlnL2FmSUZsQm12WGdXYUMvV0cxUytkRy9iV3I3dTRMTDJVUEZMd2dabUVp?=
 =?utf-8?B?Tm1ZN0pnZmZJUCt5ZUIzS2dlOVRhVkFVQUYydnZyN2RKaERFV3N1aVNJSU0z?=
 =?utf-8?B?UTdCaEY0MmpNUHVRVFRQT25zMkxrZVMyMG9pckxzRVVXTTUzbVQvc1BTVnRo?=
 =?utf-8?B?dnR1VklLTmhZcWhDT21BdkZjQndhY3hrQkM2NVQ1aXMwMEEwN0pZZjFoWUkw?=
 =?utf-8?B?OG5yQTVoYjh4N3lUb3E5YW8zRG1VaWxFQlFXcXVSNndWcFJsRDVkSThMUktP?=
 =?utf-8?B?ek5ia0E3V3Y3cVdNYWFsbjRNNHVSWnprSkNkclMrVzkydU0weEpLN3phWGwr?=
 =?utf-8?B?NEVaRlkxN2dSZXdwSlArbEx0ZGI5Qmttc3UxeWRMZnlSc3BrMGd6MUN2eUpZ?=
 =?utf-8?B?SDNPdFBUNkFrYWR6cXBra3c3TEFKU3Z0UDI3cXVwQTFrYzByZ2NUcmRwMllO?=
 =?utf-8?B?WFNBWkdSSGpQU0ZaRVNYQnNPYzBrL0pZcEQ3ajZ1eHVzT3VpbXZ5ZmhlWWFr?=
 =?utf-8?B?WEZBQXNOeDVUREhtYUl4d1RhOWcveUx6UzFwM0dwOVFCaUU5Q3A4UWdqSjZJ?=
 =?utf-8?B?OVZOcVNSQm9ad29pYjFKREJTVFlxanBCRHNGNWU1K1NTZERsNlRTTzBES3Nk?=
 =?utf-8?B?SlJQNFdJcC96ekJjdllWZTV3aU9RRDZDUmFZRWdSZENFWVFaZjV4bWZPNVlh?=
 =?utf-8?B?RGtvZDNhNU0vVUtzeEJqUGF1U1JNeHllb2Z5YzFRTXk3M0tTb2ZXcXYzc0hU?=
 =?utf-8?B?SGUxTDJDYjIxUUNRL2k4SXIrNzRlMDd2akJjV0I0TW1vNDIrV1hZVjF4azJ1?=
 =?utf-8?B?OFdLdEpqb3lJQjdQUnY0ZXNyTWFuWU04TmYyOXdEdDdkQ2IwdnBRMEZ4VUZt?=
 =?utf-8?B?RU5KVUhEMmcyTW5RblU4cVBOSlFPMDV3U0tDc2pya25SbTRmdFdTL0JDUzBm?=
 =?utf-8?B?S2xiRUMya0hYbkdUWDBUYlZhdW9TdkdvUytsNDlhVFU2WC9TdlBnSHZUOVVl?=
 =?utf-8?B?OWNiTGdOUDNGSkFwMkpOekg0bVAxQ0NDZ2NuUzBaTkczdGNPN2ZReU40MWto?=
 =?utf-8?B?MTIvanlWcGVqSWhyWjh6K0pGU3NmNGcxdFMxK0FNVlFNcjV5cTNFeDNOeEdD?=
 =?utf-8?B?eGdoanU5V3RoSlAyYmczTmxDeU1ybHZURG5GVUFNU3U1RjlBU1N6ZWlmWVRv?=
 =?utf-8?B?WEF4V2tYTCtQN0dIcUsxWXRJL2wrUVFQdFhCTU1MUGg1dlJneFZGWUVlUXNW?=
 =?utf-8?B?R0hmU0dvNXp3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHgrN0hYZVk2QUp1YWhIa3FLOVVPQU5PcUxyUXlwVVAxSUI2bUhYYUlMRkpZ?=
 =?utf-8?B?bE53TlJOWUxkenRrZkFtNEhMTTJ5bXczSVRYQitnc2hpTmhwV25vSUloZGxP?=
 =?utf-8?B?czRMSEtlNmJQb0pkeWNtTDQ0NEorbFhvRy9CUWJUeXd1bWxtVVZEUUN1WWhh?=
 =?utf-8?B?RUJIcEJIT3pFYzMwQUI1eEo2T0p1Q1dQdDhDZzhDTjBGWXc0MnBKL3BFS1BB?=
 =?utf-8?B?OVJJdXkxQ2RPTXZDMzVDMG84SmNNWDNYeFJLMVB1M2xXdVdXSUN5RlhsMGhj?=
 =?utf-8?B?aXhlNnMzQmFwUXdsWDNuSFdxMDlIT21uMkdLR3p3Nml1R2RiUmFKQ0VPMlVv?=
 =?utf-8?B?bGRuU2ROTTZlcDhYTEhvL05hcHFoQkxRdGVKNVJ4eEloZnZSc05WalJ2ZEZ2?=
 =?utf-8?B?dFVnV1JuT3VlZXFuZ1N3QWNmcFZPRlpPM2tYT0lWbEVSU2Q5d0prTkFqaE5I?=
 =?utf-8?B?NEJIMW9rVlByeVY0ZkJmWVduTlVONU9rcGNYTGlCOUhBaEQ5cENlVEpNa1ND?=
 =?utf-8?B?UDNxa3ErOEdXRlIwOW9kWjhPNGgzb2R5Y3VMbUhGa1FDNi9rdXNHNWNHZWRx?=
 =?utf-8?B?cll4cWZCNnNFZndTemozWTl0Yzd2YXRLMDdEZkoreDl3TDMxamtYclUrdW4r?=
 =?utf-8?B?UHVFMXRFeXlLYVVpNDZ0NnRaOGlYUjZRemFlUnk5TXZvMlVDem5sbUF5SCtH?=
 =?utf-8?B?eldzK04vRHlEYzdrVXl5TllYbWxJd3l0S0NVTEJzZFpVK0ZTTTFxV1JhSGdS?=
 =?utf-8?B?WGd4TTVjaVYxa25qQlluakxuVE43REg3ZFh5MlYvSHoyWUdjRHNPVTMzTWlj?=
 =?utf-8?B?L2NzbjFGNmFRL2dwVWdlZ0FNS0hDL25Qc1FvQzJwS255Zi83cWFUWnR3QU5T?=
 =?utf-8?B?RkgxeWRNMkdNUjhmSHNDb1RBSnc1ZEdqZVRHcTFpZXVMK292M1c4UXNKUUd2?=
 =?utf-8?B?dndPTVM1bCtSREpEQ2dlK1lIV3hFREJvNkp3a3NDcUwxdkZOOElMQ3dZbHdF?=
 =?utf-8?B?OUpOV2EwK2JwQjVXVHJtOXdEajQrM0kzY2xyYVNuY3VXaDBPSTZsNnVHSTJF?=
 =?utf-8?B?ektWWldMbGZqaGhibi9Pd1RLaDlVU1VnblVMbkdIRGMyZHpZWkFpY0xnRkJW?=
 =?utf-8?B?VVFJeWNRYnBhc2l4TnZKeEUyODZ0R1FqaTU3YkI5azVRaEgwTUtMZ2FyWm5q?=
 =?utf-8?B?WjdWaXA5Skh1RkJRVmNJYmNYSEIyWDJQN1IwV0ZxQkkxSENFVEd5MUIvdjd4?=
 =?utf-8?B?TXFPL3VmK3FXQzZhT28zaDVHZFppcnpVVE9wVEw0djc0Zm15S3FMZDVNWld0?=
 =?utf-8?B?MUVZSmNYc094QUdxamVUaHFFSzJlOEZUZUUrWjA3ZHNLYzdxb0Q2WWpWMVdx?=
 =?utf-8?B?MnpQbmJBZHlQWDdKTzRzNHhBRlozN1JxVW9vem5ZbXR5ZXAxUWg2ZU1mMzNH?=
 =?utf-8?B?YVdxWmRzNHUvaCtOdExLak8vQld1Ky84WStKK1BpWENEM1VTajVWZmlVbENo?=
 =?utf-8?B?UTlSSitOU004MUVYMDZWaERvVHJ2MHBUZi9wdUcvU0hqNktaNUFKM3lFZ2Y4?=
 =?utf-8?B?MTViNnlPaFZzVUpYK2ZGUlBGdjZxWlkxQ3JZNndHRGZOT0tqaHNBTUtZODFy?=
 =?utf-8?B?ODg4NUlSUnZFUWdFckVCQ2prdy8yMTdnTlVJbkcrdzNHU3FLSkRzLzZ5aEE2?=
 =?utf-8?B?dytJWXNSbXA5S1VMMEpHUWhtb1NtY2lHbXpsWmgvOURJNWxROXVSbTV0YVFT?=
 =?utf-8?B?NVpIbzh3cWhCR3JRNW1KWGpoR2lpVk9CS3M4c0xUTXRWTzhQcUd4QW0zdUFr?=
 =?utf-8?B?RGxaRzdOMHFFbHcvUzZJZWhnNnJQSmQrSWE5dHJhNGpXYmViaHcxUUc0Rk1n?=
 =?utf-8?B?Q0V2a0haMEgvN1dudm5MNVpQMWlWVDh4UW11WGxvTEw5T3NlVVVvUHNxNWh1?=
 =?utf-8?B?L0RuYzJkUzZLUGVwbUxVTEphZmNlaGQzdi9rb3E5YmdHZTBhL0hLMWVHZXNS?=
 =?utf-8?B?THRlTWRDcHZucFVCTWtxRWZYc2taaHMyWEZ1d0NGblEyTjBRazdvczNpeFhX?=
 =?utf-8?B?bjZoalh1Y3p2SzJzc1lEeHFmU1VnOUE1OWovQWRHaTNJRmF6akdWd3BOOTJn?=
 =?utf-8?B?Sm9ySDZ2TG5Bbm40YXk0bGdiWWhuMEVua1J6YndJTHBwQ1dpTERyeXA4Q1Bx?=
 =?utf-8?B?YkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C65A03CAB05B094E9465B9573701C239@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb8d091-7664-45c6-1561-08ddde4e24a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 11:55:35.9585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D2ntEaeeUhB6LNxRtDH5ngeaO5AauEJ39F+kJ6XH70NyJkR11B6DJWh4iSuzv7qEpdjKcRlV/yNHZuLWe0GAGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8742

T24gRnJpLCAyMDI1LTA4LTE1IGF0IDA4OjU4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IHVmc2hjZF93YWl0X2Zvcl9kZXZfY21kKCkgYW5kIGFsbCBp
dHMgY2FsbGVycyBjYW4gcmV0dXJuIGFuIE9DUw0KPiBlcnJvci4NCj4gT0NTIGVycm9ycyBhcmUg
cmVwcmVzZW50ZWQgYnkgcG9zaXRpdmUgaW50ZWdlcnMuIFJlbW92ZSB0aGUNCj4gV0FSTl9PTkNF
KCkNCj4gc3RhdGVtZW50cyB0aGF0IGNvbXBsYWluIGFib3V0IHBvc2l0aXZlIGVycm9yIGNvZGVz
IGFuZCB1cGRhdGUgdGhlDQo+IGRvY3VtZW50YXRpb24uDQo+IA0KPiBLZWVwIHRoZSBiZWhhdmlv
ciBvZiB1ZnNoY2Rfd2FpdF9mb3JfZGV2X2NtZCgpIGJlY2F1c2UgdGhpcyByZXR1cm4NCj4gdmFs
dWUNCj4gbWF5IGVuZCBiZSBwYXNzZWQgYXMgdGhlIHNlY29uZCBhcmd1bWVudCBvZiBic2dfam9i
X2RvbmUoKSBhbmQNCj4gYnNnX2pvYl9kb25lKCkgaGFuZGxlcyBwb3NpdGl2ZSBhbmQgbmVnYXRp
dmUgZXJyb3IgY29kZXMgZGlmZmVyZW50bHkuDQo+IA0KPiBDYzogUGV0ZXIgV2FuZyA8cGV0ZXIu
d2FuZ0BtZWRpYXRlay5jb20+DQo+IEZpeGVzOiBjYzU5ZjNiNjg1NDIgKCJzY3NpOiB1ZnM6IGNv
cmU6IEltcHJvdmUgcmV0dXJuIHZhbHVlDQo+IGRvY3VtZW50YXRpb24iKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQoNClJldmll
d2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
