Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7936F22FDE8
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 06:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746773716; cv=fail; b=UWkPRlff4OxTfXZi1gHRr8XvKT+pZQ9BPQdej/aNgB6A6HqvTtAkfEh7NtbMMqXS36j5rV2yRhOmSvpENHDtDqt869o5uLO5gC31a0wWNvJzTg+4hiFAclA/oVTys5tjCKasP47kkkzwOeq95TIsUYYXAxGQWjfZqhdqysAPeN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746773716; c=relaxed/simple;
	bh=Xo0A6w+KWBdZBG25XRwM0uF2GY/vknSNQ/iBny8IgzU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oB9MSfZGvxTXfVJ1KZqeJnSo48KTlLoHtMPaj8EZ5tDnieloCcu4wzGLR95h0jUA/vXnBPTTLzhcsp1vb2VwV8AfxdvFKFr2U3HIeZyRjKWjPOiuQ/l6+QAimOMjwiNaFpfiLUVSXkDXi8S2NVoI/PQcsOoiuayPFxE2yw/6UOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uwIuBdHx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tb0z5Zva; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uwIuBdHx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tb0z5Zva"
X-UUID: 87f80c942ca211f082f7f7ac98dee637-20250509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Xo0A6w+KWBdZBG25XRwM0uF2GY/vknSNQ/iBny8IgzU=;
	b=uwIuBdHxSI1mwWnjgLw/BlCyi2RoRMiaJTyTmX8cQTmkIin5w/yp8LIZ27WPzFAQilcL5E46IOOsSeVlZA+Lsv4fgOAeWsZeWtKcaqSRGBycCkJfRd2Xm/PhSkYJyCWGFcJxIgwyhmJgmjV1TppSnQMy1n8i2LZePxyiu0Y/5CY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:54f45565-8d22-41be-a70b-15b27a378d7f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:0bd1c5e0-512b-41ef-ab70-9303a9a81417,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 87f80c942ca211f082f7f7ac98dee637-20250509
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1538374226; Fri, 09 May 2025 14:55:02 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 9 May 2025 14:55:01 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 9 May 2025 14:55:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AABzRYsTZfHZBA4iX9V2vafPCuYa15yd/ZAc9Tpib0QjZ10hwLkF8vFv/dvFSZLGbtuxR0LtA20J3gb+79fHL07Xu9rGPnPEK6e9ED23Ci3SdEzaUB/LqV0XkFYYEkhgsN91FguVHufsQegtw2TUXC0qwpJVnRY2iqugfZVJdTY1RO4Nlu3aLhfvipMo0eNHkF1aU37A5tVbhdNnG9p20UwXQkkYW6IFHEZdaVS/TXfJMYH4TDf7j9NoFJUrBjvV56RXZFnPOmBdLhRtFIkraXF5j2V8Bl4pBssvSO2cELQAzc/TVIcB3v8YJzGSEkO4meKCGZQ2JG6w3wBoD5T8Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xo0A6w+KWBdZBG25XRwM0uF2GY/vknSNQ/iBny8IgzU=;
 b=Pn0tvv7Fsgc5gCY8MluTsKC3bZLYvsscqMZgKdUtEdwTiuxGMRKSTYshni62t4fesl/CH2s1EY1bVc+qHy9c7E9LXlToAobGopvAoMLXx2KVOhYMDATeNX1cwyruNQqbdElH95sEkFolRkerR9MW7Bz2wV7aRhMH5K9vu6SiLKLUwjfs2flrndl3OgLUCMTBLmOfvJ7qz0Nuj100HcSCU3FaN8uzUbFUC4/7cKhOb3lu52r6G5D7GxT44Kdjw0exFhNDI6/0s5NwSQEc5W0LE7cldDku/ixibDmX1uH8uXQl1lbkeVrT/tkh3gUM2t4ErF5OmfsPz6Qilfts6qyRIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xo0A6w+KWBdZBG25XRwM0uF2GY/vknSNQ/iBny8IgzU=;
 b=tb0z5ZvaiOf6GTdh2JD6rTEA1paCnnZeQXAgYYGXRIeV8j44c/SWEnS0HmlmziHs9QMyWUygYQUJvZ13aIl1NR0/ecStjgaj0eYI9LobZaoSTeGOlQlEqQuJVSYfF97sRYEo4f8vJPWiH9tX8slpybz2seWuxWinZxIRQChaNu8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6661.apcprd03.prod.outlook.com (2603:1096:4:1e8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Fri, 9 May
 2025 06:55:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8722.021; Fri, 9 May 2025
 06:54:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Increase the UIC command timeout further
Thread-Topic: [PATCH] scsi: ufs: core: Increase the UIC command timeout
 further
Thread-Index: AQHbwDn+6OR1YQwQFEKb9SCSSgqoYrPJ3huA
Date: Fri, 9 May 2025 06:54:59 +0000
Message-ID: <d894ea0226f80f483b0db3ad7948f9048416ed6c.camel@mediatek.com>
References: <20250508165411.3755300-1-bvanassche@acm.org>
In-Reply-To: <20250508165411.3755300-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6661:EE_
x-ms-office365-filtering-correlation-id: 5e0044d2-d96f-46e7-e8b3-08dd8ec66a87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MFllaG9adHVqTUhCRzlVT3U4UUdXWFlQYzUyRTF4azRDemg2YXNsY0QzUDYx?=
 =?utf-8?B?ZkNMeGYvUGZ4ZkRuY20yL1ZraTJ4YnBhR3VrVkhxV3FCZFJscFl6K1N1NWpu?=
 =?utf-8?B?TG50eGtaV3BXcHNtdEt5LzVsWkVUTlJiZ1pUaTFOUWsxL2ZNNEJueFZzNnps?=
 =?utf-8?B?UUNnQnJSendJcGV1ZjlyL1Nkb0owTXlacTJDOEFuT2hqeXlFamY0NS9tMWtS?=
 =?utf-8?B?Q0RjN2FnOGNjSjZVVE9sRzc3KzNOUjFJUzlsakpEeWd5eUVXajRSS2pHR2s4?=
 =?utf-8?B?YkVKOXRhT0pPQWFDR2ZLamNZZHZCRk5vTmhBZzJJa0hONzIxQkdmQ1oyNzVo?=
 =?utf-8?B?OFNyL25yWVdnYk1held1RFVBUTEyMElHWUNwd0ZIaHljTDRmcFZXM0JQRFF0?=
 =?utf-8?B?eDV2ZHVnaStpS0RNOTBod1doZ3dGZVhXcFhyaytRTnR0ZnkralVvVmlKdk45?=
 =?utf-8?B?blhrYjhkTEZPbDZOWEF0MzVlYWV4M3JmNG5WSjB2TlQwVldWcVNRdW51bzFq?=
 =?utf-8?B?VjIycm4xREY4RktnMTZEMDZqYUFxVS80dkJsTkFveEVqK2hxOGxPenAwSW9Z?=
 =?utf-8?B?bmt1a2FncmJ1QTI1MjVSaWVVa05kRjNpNEUyWnJ2dHptdFZvRjE0Y2JxeGow?=
 =?utf-8?B?UnVVaW1uTXI1cG9jb2JtUmhMTmc0Sy8yNERIOVl3M1JadkxkVHd0VkpBVVkv?=
 =?utf-8?B?ZTd4OURHOWVpdTRUUVRxbVFUemM2QWtER21jM2ViQ3BTVFgzVU5ic1FTRk5a?=
 =?utf-8?B?MElRcjVGUWNGQnVNWWtCWDY1anZKNGZYYWVWRTBteFhUcUl4TmVmdTlsYmJr?=
 =?utf-8?B?NGZRNTE4ZTEzams3N0VLYmJIK0krQSs1bFBPMzc3WTRMNFpRUEpuTHdRekV3?=
 =?utf-8?B?d3FYSTRGNCtzSUI0YllNQm5oMXRsMlFQQURHaGN3clZYUC9oZ1FUS3JOZkZj?=
 =?utf-8?B?Y0pUbzdaUUNvcldKdHZMZkFJc2JScm1Qek84R2Q0M0xaY0pOa25zSUxjZ2dy?=
 =?utf-8?B?WllYZ1VxUVBzV0J1WmNZaWtvVVU0OTVXN1pTOFlUcHpBYlRsVUVOVGY5dHpy?=
 =?utf-8?B?ZDJMVEFLWEtCSTBiK1B5YUNsSmtMTVZLRWlyd2ZPc2lwaVJSQlF0Tk5EdTBF?=
 =?utf-8?B?cGhNcjRhakdMSVFhTi9mZllCSTVLZW42djVJREtWUnRmc3REc1JRbU0yNlc0?=
 =?utf-8?B?d2lBZzJFNHFmSmhWSEJkWDJnQWhIdExtK3R4VmlvUDcwUWFsSEFMOGFWdDBN?=
 =?utf-8?B?ejJTaE5TUHVsMUdoZU81MFZQMWU3eXZoY29vbVd1QW5pWUpRdnJ5MGdMdFF4?=
 =?utf-8?B?RVM1NTdKR2tFVlZXd2JhZU9JcHlDcmpyQ2QxQVBwcElkcjVqL2ZibUZsazlJ?=
 =?utf-8?B?eUh6SCtUcXZEeS95cndMUTJmNGppaEtEKzJsV2xaMHVJc2QrcHo3aDgza0di?=
 =?utf-8?B?ak1wSkxjeERwclpjVXI5WjVEZC90UHlEMENKSDFOSXpmR3p5Q0ppUENnMWt6?=
 =?utf-8?B?Zzg4VHZiS1JTakhJMDN5R1N4VGV4aWovR0ZwOUs1SE42bm9yVUZXaVM2VmtU?=
 =?utf-8?B?eThzUngvSnJadVA4MXB0U0s3VGRsMmpKbkVvbDVyZ0w3VjcrQVFIQzRiMlVs?=
 =?utf-8?B?dWZvVndiK0JsNlloY2V1NW1NVS9NVnlod0E1QmlhaVVWYXBWMnNCaEE0K2ZU?=
 =?utf-8?B?OHB3S1BFSkF6eitZOFNKQ1FGTXNUMXdkRFZvb0JGOC9GSUY3WUFkc1Uxd2JJ?=
 =?utf-8?B?UkpVR1hqMm9oOStnQXJRN09qdFFhUnQ5VDVVdjVHZi9NWXlvMXdZa090UFdI?=
 =?utf-8?B?M1piV3NXYVY2YjlFZnlSQllUc25NS3pTNE5HYWIwUXBXNCtzQlFhSXpDUkRM?=
 =?utf-8?B?Ull3Y0R1WFZYRWVobmVBN1V3M294U1FwSzh2U3o5bHMwR2kzT29iMzI1eGQy?=
 =?utf-8?B?MTE2TlJnc3JIUXZWNmlNOVBhZHNSWWJ3cWZCdElRdjUxWCsvdGQxZWVwWGRE?=
 =?utf-8?Q?gGO7HWLnWmvWE7hdOGdC7ENQU7eqWE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHQxbkJsZWZySlZscmhIaGR5dy93QmJVa3hNQkxmVU45Mi8xYlBMUTIwMlJv?=
 =?utf-8?B?T2FtOHYzS3VzTGdqR1loTUtTMnlVOG55bTZnbE1Zd3ZNVUtSRUNBU2ZWQW1M?=
 =?utf-8?B?N05TSk5oUGR3QWtwSFgvdG90UHZmazREV0pQbWlwdmpIb2VjY25zWGFpYmlT?=
 =?utf-8?B?SXY2R1lNeUFOeTFRd3NvTGpsYi9LSi9NU1orN3BqQlRnNjl6cWFMbWlCTFor?=
 =?utf-8?B?eG1tOTdLdUVGSk9sYjB0TlJNVHk3VEZGVmlIZWpxb1pOamg5N01SMG5UZEhO?=
 =?utf-8?B?TW5NYm9Ma1pDdS8zWE1LZkN1Q0F0dDMzSU5KbkdZZ0FaUUZOaXhHOHNEeUJa?=
 =?utf-8?B?VCtHZzQxOG5pa0UyOEx0OFplK25hRXlTWDhQc3FJWkR2a2NxUGdFR0dCdytP?=
 =?utf-8?B?aHErK3RpVU1Kb0Z5OFd5TGRtUDFhajlUazVjdWxrT3FZZjJHaEUzcUlPRWNa?=
 =?utf-8?B?SllsT1VMcjRpcVFpMDd1U2FKY0gxRS9Xb3IwbnhtT1d1eFZZZEp1TUMzVFNs?=
 =?utf-8?B?R3N1bWJQTnErZG9jLzlyQUREaTViZWV4MXZsNjFwZG1Mcm5wV2c5aFErNmVB?=
 =?utf-8?B?Mjdhc1hxakVtQkdHdjlNeWdpV2l5VkRPRW1SbVpmNFJMaWdvTkhKQUpnc1c3?=
 =?utf-8?B?QzY0ZTduYmhuVTNDdUtkUlNsL2h1cHFydnd0MDlJU1JhUm1qT1Q2S3hLU3hY?=
 =?utf-8?B?RmlSYlZKTldzT2FXNnBGYzVLaTlsTFN4dDE4TFByM01qK2UzUy9SalROa2ZY?=
 =?utf-8?B?dlRoYTZJaGtRZ3hCZE9jUXRuRkZNWWh3SjlpbUZkNlNkejNPWnZUbDZ1UGFx?=
 =?utf-8?B?bGx5OEZ1dWlKRUFZZkxrZDFHM2QydzJoczNlOFUyK2xTSDZzUXk0dGZIRTFu?=
 =?utf-8?B?RnBrNWIxcXVHQ1JCTGN0UDdrSzB6b0tQL3h4Wk1hNmRnMjZ3eFRxYm5uS2Va?=
 =?utf-8?B?MEZJa3dKNllHYVdrM3VndWk4emh6SmFXU0U0cjQybE1SaGcrR01XU1pURmJm?=
 =?utf-8?B?a2oxZXozSnZFMExLZXJNMVBNZVRLS25DOVZmSFh3U2w1b3QvY0ZTcDgxWjY4?=
 =?utf-8?B?d0liaGFxblByMEN6b3pPWEdnUW5IbjkvbkhBZGF0Z0VIVW9xQWxBKzlFd3R6?=
 =?utf-8?B?YmIwU2Vwam5rWElZbzIyWFJpTVRuMzQ1RmpiVlNxUUYwb2lBR2tQOVFkdXhV?=
 =?utf-8?B?S2pWenlYSlN5QW1WelBkRklLZk40NXQ3MThDSDliS2cvbjZCbjJUVTN5a1J4?=
 =?utf-8?B?b0l6eG50TFhvMkpoQ3QzUTBDMnQrYVhQZVhOSWk3M3Rtd0NZdEt1YlA0NnVa?=
 =?utf-8?B?aCtLSkxvUHdsWVNESGsvWmlBVkM0RStwRjBoT2d3QVZmMENBajN3ZGxPcjhG?=
 =?utf-8?B?eHBMVjE5c0ZhbFQrTU96RE83blFGME9HVWpHMW5KRkhtVnlZenpwamJGRUZa?=
 =?utf-8?B?SXpYYzZqWENMYkdQWm9yMzhhWVA3MW5pVUEzcHM1aG4xMUE4c240MzkvOFZO?=
 =?utf-8?B?NDBLdGE1RG4rMVhBeGtrV0c2T1dsZGZSb3NHNzZFTUQwZ0t6bExkZ2M2Mnkz?=
 =?utf-8?B?TlVlcGFiMEpqODJ3bmVIcCtQSFk5dkk1eUhGVC8vdjVvNTBRbFNWNVdhVVdF?=
 =?utf-8?B?UmltMk1yZmtYT3Vsb0tRWFA5aGdhczB5ZHgzT2I4K0IwUmdYSDlZSXpGYjcz?=
 =?utf-8?B?RHZnMFhPbXh2Z1RKWnYvV21UQW80eU9iT3JtbGxTcjFqZWhaNFhTVzkyRnN4?=
 =?utf-8?B?bFBaQ25Udk1RcklzR3NMYWtzcGtRc3l4QnZveTQ3K1ZSRms2ZHVQMktMMm13?=
 =?utf-8?B?bG1RWU5Ed0ZGeEtCOWRnempybUdQTzNUeXNJUGpFSGFMb3hzM0pRWTBmRmpy?=
 =?utf-8?B?b2M1RWNXSWdZUUJSaGMyQUhLMm9ReTcrbElMSHBEaWtsVmI1TEU3VVBtOGpl?=
 =?utf-8?B?MmhYMFVJcldjOThyUXJzZkRydlptMUVPend4c3hLUGhxNUMwK0REMlVFRDZB?=
 =?utf-8?B?VzFxWjc2TVRBMHJTbU85NHhQVzNTZGtoelZmMDFLeENvSk43MHNLa050Si9V?=
 =?utf-8?B?OUFESWFrNjlyRmVwVWdzU1pOK3RuVC8yR01YeHVQa3k2emRldTJvcVVxUjlT?=
 =?utf-8?B?UWU3SlV2cXFEeDZ1R2w0MUl4SlFoRmZoaklGUDh1ZXpXMnVId3lmUVh1aHJJ?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D391853EBEF2A40B6FB03350D9997BE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0044d2-d96f-46e7-e8b3-08dd8ec66a87
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 06:54:59.8309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WLZ2vylxp0kQ4r/frGBgvIrfxQf18npGmZxyCa4/ZaQn0PZ7jegsLSmtHSonk46pNDfitxWulKlzcXShvUEgSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6661

T24gVGh1LCAyMDI1LTA1LTA4IGF0IDA5OjU0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwKPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBj
b250ZW50Lgo+IAo+IAo+IE9uIG15IGRldmVsb3BtZW50IGJvYXJkIEkgb2JzZXJ2ZWQgdGhhdCBp
dCBjYW4gdGFrZSBhIGxpdHRsZSBsb25nZXIKPiB0aGFuCj4gdHdvIHNlY29uZHMgYmVmb3JlIFVJ
QyBjb21wbGV0aW9ucyBhcmUgcHJvY2Vzc2VkIGlmIHRoZSBVQVJUIGlzCj4gZW5hYmxlZC4KPiBI
ZW5jZSB0aGlzIHBhdGNoIHRoYXQgaW5jcmVhc2VzIHRoZSBVSUMgY29tbWFuZCB0aW1lb3V0IHVw
cGVyIGxpbWl0Cj4gZnVydGhlci4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUg
PGJ2YW5hc3NjaGVAYWNtLm9yZz4KPiAtLS0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMg
fCA0ICsrLS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jCj4gaW5kZXggMmQzOTkyNGEzMmIwLi5iMThiYTE3YzIyZmYgMTAw
NjQ0Cj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+ICsrKyBiL2RyaXZlcnMvdWZz
L2NvcmUvdWZzaGNkLmMKPiBAQCAtNTQsNyArNTQsNyBAQAo+IMKgLyogVUlDIGNvbW1hbmQgdGlt
ZW91dCwgdW5pdDogbXMgKi8KPiDCoGVudW0gewo+IMKgwqDCoMKgwqDCoMKgIFVJQ19DTURfVElN
RU9VVF9ERUZBVUxUID0gNTAwLAo+IC3CoMKgwqDCoMKgwqAgVUlDX0NNRF9USU1FT1VUX01BWMKg
wqDCoMKgID0gMjAwMCwKPiArwqDCoMKgwqDCoMKgIFVJQ19DTURfVElNRU9VVF9NQVjCoMKgwqDC
oCA9IDUwMDAsCj4gwqB9Owo+IMKgLyogTk9QIE9VVCByZXRyaWVzIHdhaXRpbmcgZm9yIE5PUCBJ
TiByZXNwb25zZSAqLwo+IMKgI2RlZmluZSBOT1BfT1VUX1JFVFJJRVPCoMKgwqAgMTAKPiBAQCAt
MTM0LDcgKzEzNCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qga2VybmVsX3BhcmFtX29wcwo+IHVp
Y19jbWRfdGltZW91dF9vcHMgPSB7Cj4gCj4gwqBtb2R1bGVfcGFyYW1fY2IodWljX2NtZF90aW1l
b3V0LCAmdWljX2NtZF90aW1lb3V0X29wcywKPiAmdWljX2NtZF90aW1lb3V0LCAwNjQ0KTsKPiDC
oE1PRFVMRV9QQVJNX0RFU0ModWljX2NtZF90aW1lb3V0LAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgIlVGUyBVSUMgY29tbWFuZCB0aW1lb3V0IGluIG1pbGxpc2Vjb25kcy4gRGVm
YXVsdHMKPiB0byA1MDBtcy4gU3VwcG9ydGVkIHZhbHVlcyByYW5nZSBmcm9tIDUwMG1zIHRvIDIg
c2Vjb25kcwo+IGluY2x1c2l2ZWx5Iik7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAiVUZTIFVJQyBjb21tYW5kIHRpbWVvdXQgaW4gbWlsbGlzZWNvbmRzLiBEZWZhdWx0cwo+IHRv
IDUwMG1zLiBTdXBwb3J0ZWQgdmFsdWVzIHJhbmdlIGZyb20gNTAwbXMgdG8gNSBzZWNvbmRzCj4g
aW5jbHVzaXZlbHkiKTsKPiAKPiDCoCNkZWZpbmUgdWZzaGNkX3RvZ2dsZV92cmVnKF9kZXYsIF92
cmVnLAo+IF9vbinCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIFwKPiDCoMKgwqDCoMKgwqDCoAo+ICh7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAoKClJldmlld2VkLWJ5OiBQ
ZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4KCg==
