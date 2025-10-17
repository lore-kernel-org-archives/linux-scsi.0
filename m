Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3309D192D68
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 08:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689784; cv=fail; b=ozoL9O07c8QALHBKD9mUEXHtoxb0nZQmd+Ykd+6fp8cz3YXIRZfkXrFkemAfwPsixwA/pL4XPYZBio2ENtqlQICj1oLjRi2jPzj0Rj4bwb5vQ/F/UyKKIV/XPVtdgXuugBSsa2rOa4Bz+dCdOFe5K9GYYq/TiHo+RhCDs/WUf00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689784; c=relaxed/simple;
	bh=xnfp9lP/FQ1nkgYAEz0axV7Flkn4gYuoHuueotAiYRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A0fWLxAFckWwi/ybh0T85BEjYUjg5EupPPlY9w/jTqbs70YIgDa5Qgb1y80m553MKWDu0JMCmXPrVhg5vLIIBVp2yZWXFaWGVK5n3agXZvAfxDmdlxR0D2abgvkFNcYtFpsWdjz86V2fTtyp+fJP1wMvOGsdvF0E6GfjMVjtB4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GLnZg+uy; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Xj1w0bgs; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GLnZg+uy";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Xj1w0bgs"
X-UUID: 6ad54590ab3311f0b33aeb1e7f16c2b6-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xnfp9lP/FQ1nkgYAEz0axV7Flkn4gYuoHuueotAiYRA=;
	b=GLnZg+uybMp6g3vATu9jrCx2KJF1lYONGPGe0K7trQWwYc/JAfLSmFlBt/6810gwEbHdYB8EoLShnS/fmY0jNLNKiYVULDj8gc5FR4aexw7bW0mwcxURPg7/Rwmwc4BfDBV4nrwJZQPE7BEneIDooglzr9QeVbeuUZfh58HAANI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e2117c34-c6bf-4cbb-84e6-289124fe4c54,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:45622a51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6ad54590ab3311f0b33aeb1e7f16c2b6-20251017
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 45876939; Fri, 17 Oct 2025 16:29:37 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 16:29:34 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 16:29:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p+BDv0rV71rshBxWuB6g/MoqsbmoYnmJQGyLRbtshgQAopW7gzwgLgPpHTi95fow1F56won4NqDyxVFTGgPGgZF59d8QTZ1VTCxg3fuonsaBPj6jHLSdCVKsfIDyKH+TZLkeqXiahqtHuoA5L52P0ETfabgtGZ0EknjuT1IdqkCpyENGS9K8TT/tJpmNEyNc7rohYe3hpbLUF4bYkt3F6O/9EkXEW7Ud1R0Pe4qdUy3EcpFiTwjQf7Wv9IqzobstqV2we9Ka/R0x+gziHWlDQop26Bz8BDTC7XxUCsDh8Bh94829Iuozunvs9nBwBe7+SQh7RRQQmRgEX6+GuiExaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnfp9lP/FQ1nkgYAEz0axV7Flkn4gYuoHuueotAiYRA=;
 b=CcuaQzebtjLSSYVIqeUrSFH7+Nj9Qt3nb12M3vf8m52dadcqMRRbKCZgtd0Qf62ZL8OrJra5zeGD+/LFuG+t1gGl/vEn6hrFyYlhadNX5olZ4zPDupXvgFn0eMNyBZgWyB2cB1TG3RssDH3vXMqW4hFveSNBi6LXWmO8C229feGlIugMoWdbGIFnH18jdS21kGeRO7jwTOQJRopAf5V/HfBBbOq3U8m9q3MsEfUnj3LREb1Dj4mCUgJUhgoNfA3eQpBISH7O69HShPVixt5bbJji4xpZXJf100kdz1jQvU1faQdpRAmAb78pGAGSMLKI+n6QgUTk5YoBjmBQjAs8Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnfp9lP/FQ1nkgYAEz0axV7Flkn4gYuoHuueotAiYRA=;
 b=Xj1w0bgsPbCS5ikQOtdCk3LIx+TCaSamMlarPSkpMX+FrJ+oBud9vmZmlO4KqkSa4r/vzAIYQaA9mK4eGrfjCM+thpR7ZbaG5+JYiTQ0Mcndq8I/cmk/nqFAHmAWjPzDaDSAx5PkcpRUwLba96sXRJ6hw7NZOW2XbHxju0A/Tkw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6847.apcprd03.prod.outlook.com (2603:1096:400:25b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 08:29:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:29:34 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 7/8] ufs: core: Remove a goto label from
 ufshcd_uic_cmd_compl()
Thread-Topic: [PATCH 7/8] ufs: core: Remove a goto label from
 ufshcd_uic_cmd_compl()
Thread-Index: AQHcPUWk1zgvyDYi1kGWz1LaInOHibTGBciA
Date: Fri, 17 Oct 2025 08:29:34 +0000
Message-ID: <20c0c936f5a36586ab63f48c2bf582b951ea76a5.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-8-bvanassche@acm.org>
In-Reply-To: <20251014200118.3390839-8-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6847:EE_
x-ms-office365-filtering-correlation-id: f29f8824-6057-4db0-76e3-08de0d574d33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TzFtVFQvcHVESW1IcUtOcDh0am5KZiszc2E4RS9DSnZEZDhHcXRETzFDRXFm?=
 =?utf-8?B?aWZZZHpHTnZBNDBRdDNiV0FSa2Q0RVVmaTdFRjhKV1QzL2dVcUFuMGtMOFdl?=
 =?utf-8?B?cVgyWmdyYTJqeFBLM0NsKzNjVm5MR1p1OFN5ejRmWm5FMVpVNnFHQkY0QTFs?=
 =?utf-8?B?aUtOdFBJU2RVUzBFSjlMbExKYmViSVpPdDRQTzZTczAzZENRTE1peWllcnFw?=
 =?utf-8?B?azI3WEdDdXJqZm14bXcxRm54NWRZTHQ1bU1mSkdVK1BYb0pieHJITHJqajhz?=
 =?utf-8?B?REE4NUtOR0twaTRVbGJEUHhUc0N1YXRielUvblBwQkliN2paWXlYcnhqSFlk?=
 =?utf-8?B?MHBoSERpbytGZWFBZEFibHAwcEoydHVVbnI5TWE0aXhiMldLYlo2dHZ5MFNN?=
 =?utf-8?B?MGR0SHZqaDZKVVNRaGNhK1hiNmdtVlRMQjF0aHNSeFhqV25henU0V3VhMk5j?=
 =?utf-8?B?anRCZkpUU2tzQTZlQXVkQkxrSG0zbCtHNVRWaGgrZmFZVExrUGFXSmN1bitm?=
 =?utf-8?B?QkVqTHJQd0lsQ3BYRUx4MHZ6aXRSby9XNGdqSG1MbWE3aDJ2VHF6SmR4enRw?=
 =?utf-8?B?ZDdmd0FpVWQrWGlpSjR3enowNDZjd0hsQ2NBTmV2NkpLait3QytvRmVOKzAw?=
 =?utf-8?B?bHlNNi9qUnRqOUxQdGVqaEtrUEJLVEczb01ZcGI3MDlqbk41eUhLTGZwSzQy?=
 =?utf-8?B?bnRFcUFUQ2ZyVVQ4RGk2Qk92SHRBaFZneUd2NGRkaDAvWmkwNWZLS3hQY29k?=
 =?utf-8?B?K2g5QzdHeGFsck01RENuLzBseVUzZzVNT3kvcnpCWnBRRE03c010U1RiU1Fv?=
 =?utf-8?B?UHk3ZE9xbFJ0OEVkRlVqbXlTckw2YlhnbFBmbGg2UVVpL2FGcmlJSm5WejFE?=
 =?utf-8?B?ZXI4ditxTlEzMkVGZmNzV0JudzRlRWxoSy9nVzVJelA0U3puRFFrTWJFZXhK?=
 =?utf-8?B?Ym1sYzg4bnNVRnArL1RGRTNYWHZUS0J6Sm16OENTU0dRQTlZN3grRkVsU0V1?=
 =?utf-8?B?S2x6V1lJbEx4R2FrR3BtbGw5UTRvcVQxZXkreU1JY3c3UHFNNzN6aVlEdGVI?=
 =?utf-8?B?eGVvYXRwVWFhQ1Q0M21WbFYvcDIvaTZnc3UvSTBGWjBKeWFBS0R3R2V1RlZl?=
 =?utf-8?B?eXNFbjJvbEhJSllBelhuRHFsTytsbXBjdmFWTFRGVHFRMnlKbXRuVUF5NGJs?=
 =?utf-8?B?eW1CS1ZUampDZnR2ZDVrY0hvSHVST2dTZ1pqemFMTW04MFU5L0wyUDZicFRK?=
 =?utf-8?B?MGY4R3RTVmNJU2Z0dzFKZ01TSTdGL2g5RmczVFdZQVpEZUdobmNFQ01uaUFW?=
 =?utf-8?B?NmlUNlJLY2pvdVJqUi95b1RET3F2MC9wU3Zya0lQMXMxMTdnMDJOdXI2VXBx?=
 =?utf-8?B?a3pBcWRmZGx2OWJuNmFaVWkxRWlXTUFKaWtIb004WTFNUDF0NnpRTGdsKzBS?=
 =?utf-8?B?STN5T2s4M3Q4cGMzVFNBa054cGxMVmpRL3VqWG5jS20rUmxTOFpaK0tFTnJT?=
 =?utf-8?B?UkRmQ2JoYjMxanZWdVYzbkd2Y09NaVg1Z21tYXY4VFJMb2JTZmUvbVpBMFBv?=
 =?utf-8?B?Y0NzaWZpd29wVXJBTms1RGIvNEhEOUZpM3l2L3dKZUR1SzZDRUNsUGoxUzht?=
 =?utf-8?B?Y05rbHN3bkliRTEwWXBKYWFXaTdUM2dWYjlHVnJqUUhPWVFaNVdMaHJaNlMw?=
 =?utf-8?B?OGlpZmhmUzRDMkJxaFZvL2tkL1l1OXltTkNvVkFTaUhjTGpEa0JIWUJTdE5C?=
 =?utf-8?B?Tkk2S1RrVlZ3UUlGQUFWVHBxMjh1Ym5FS2VaaFA2Y2lBeHV5VDVnYS8va0tB?=
 =?utf-8?B?dk5qWFdUUjYwVXlBUkR2VFZseFNKc1dzR1RaaVkrY0VJUEZpWkEyYng5Z3Vx?=
 =?utf-8?B?bmk5aE05Q3lyVk9FWW1wbm56NmVMWjZ1UEROelBSMFU1SHdaSEhsUVV3aGdJ?=
 =?utf-8?B?eTkzWVhSSkZkbW9tMVJmK29TT1F5M25LVGN5WkdCeVB4T1JmN0JzMThKa2lN?=
 =?utf-8?Q?3GxyLuSRyjaI+uPK1+SBe0bP43cmAc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGNPMHJ5bHp4RGZZUlJNd09FTWlMdGZQeUhGMWFLL01uN21CRyt6MXpmRzZv?=
 =?utf-8?B?OE5xNHJSUXlNQ1J1dkJlWmZsT3NkUUQ2YlhwWFdQL2FCV0tJOUlkbllMaWpz?=
 =?utf-8?B?L0ozODJSNngrRTE4N1N2M0hOZHJWbkdybEhKQXdkcllnNnROT0pYSnVtd0JQ?=
 =?utf-8?B?MHR4YmkrcW1yQ1QrVlJieGdhT3RlOTJBK2xRc1YrQWI0Q0ROaEtCWmRocytP?=
 =?utf-8?B?WENReWlPU1MwY25oVUJPZmxSVHJUWmM0S3EwUElFMTNob3g2TlQwbEZZYTZh?=
 =?utf-8?B?RlVvNHRhTDVkWkR1YlhGZXJWNUZiOWlrdGVsdWZTaUtucmVFNXdmUWFmQXpE?=
 =?utf-8?B?K3FuZTB6c0F0YlVLSXRnSEpPdTJhTVRwelh0RWdLdTJjaHNkMC9QZWN3RDZI?=
 =?utf-8?B?UFZQWUpmT2pRT3dUaWhxWVc1dVV2MmxqUS9mNHMwdGw3MkhzbFBHNDJDUGww?=
 =?utf-8?B?MU1BMVNLeXQzbHhLdjUydm5GWGE3WlNCNEpxa1VrTGZzVHRBZzZENFlCQkVM?=
 =?utf-8?B?aWZ6M09TT2dVZUsvMHF5RnBIZlV3bE9NVFpycmVNTEcvaSt5RGN1bWNKQ2pz?=
 =?utf-8?B?bVdmazBXalZLWllzdmVheGVtYXY2RmZza1lhby9QVUlYd0hueExvQVc1ZXJk?=
 =?utf-8?B?aTVGMDBYSzBobG9RSkIzYmMvdWc1N0RHYWZhTzN1VE1UN2dmcHVaeVdSdVhu?=
 =?utf-8?B?UmcweFhTVVU2MWR4aXpqZ0poYVdwL3RRbkpFdjk3ZGlKV0dObE9UdjhYSUpO?=
 =?utf-8?B?OHB3RlNDTk44SXp2NkhwZmtQWFUwSnhPejZROXd1dEc2T3VIQzJqcDFNYmxS?=
 =?utf-8?B?ajRhT3o1bHVTd3pVRmpwV29MNHE4SmpjN00vMXVlZzFheGNGTitlektyMFMr?=
 =?utf-8?B?SjJ4cm4zVlZ6U0hBUXdJVFV0aGNqZ3QxOXdtVHFTYWVsdWY0eWJQVDVwdGhD?=
 =?utf-8?B?U05kanhaSUFyQVVMVCs1VjhndXEvTHF6ck5FbmpIQ3FETjA5TGxBOG0wWU1h?=
 =?utf-8?B?c1FFODMxOWU5ZFZ6YlhBZEJMcUU2QUlwRGRXemtmUnV3TE03dk9MRldBWllE?=
 =?utf-8?B?QnBSZXY2MjIwTVduaWNBemZXVkZ5ajZsYWYxdEIrSHRERnpYZHVxZDQ3a1c5?=
 =?utf-8?B?dWNZS1hEYVVyZUpabDFxajhNSW9Gb01wWDNpNVk2V2o5OEdKalBxN3pZMkY0?=
 =?utf-8?B?cU1adkRSc1NjK3BlV2F6RDhRdEIrWVB1U3pWVW5JcFBjdW1JNHFCZkJvKzd2?=
 =?utf-8?B?WTF0Z1VpS0tORno1dzA1ekZkT0syeTBtWG9GTEs3UFV4V0ttMjNZUE9NRm5P?=
 =?utf-8?B?T3N2VkhreFVHRG1zRzVxRHlzT0s4UEhyVGUybWdFQjBibXJHVWFLNFJtTnd6?=
 =?utf-8?B?L0RzU2Zib3BNZXdnZ3kzQTZEc3hnWHlJSk5Jc3MrZzVQZW1QWFNyWTFaMDNV?=
 =?utf-8?B?eG9rOXpIMlB2L08yaE8zQzBEbHhWN1FpOVdDYVNKRXJ0Q2NNdHNwUmZKSVlB?=
 =?utf-8?B?NFdrenVaV2prRnNSRnBEMnNvWWlDekNKTzRQMUpqa2RDU2FlU0tXZDZJYkxr?=
 =?utf-8?B?TkVDMGFyUDRvN2pZYW9pUmhCYTZEQkZaVkdmdEl2WXBYTWtRVXcvNTk2a1l2?=
 =?utf-8?B?YmViOG9oN2F1K0Nia2JtSFRpL0ppR2NYZ2gyUEpwSlh3QUdiU0pHakF5Y214?=
 =?utf-8?B?NHY2ZWREMlBRTTduNmhWVk1rZkQ1RGxnY0FkOUpBNHpJYXBYNFlNNXUvVEp6?=
 =?utf-8?B?cmE1ZHFqcmNSbkZtaklpTklNM0x6QnN1Vk0wdlFaNUNSUkhtRm9LWDZHVlJQ?=
 =?utf-8?B?K0J4cVkwTHgwc1JNcE41T09WR3Q5a1FMTEN1MHRsa1JVUjd5ZkE3QURUM05R?=
 =?utf-8?B?RDBPdWEyVS92aVpLbVFmc0hkZEtlWTBMUkIwL05kUTlaa3FXRUpDNnhJbk01?=
 =?utf-8?B?b1RCWTFsazc2YS9JUi9DYi83ekltdXBTQWg0dkI0b0VVT0pGQW9hcDAxeXVG?=
 =?utf-8?B?YldHeHlnT0crbFVKdFduUFgyRmt4dllPTGRxRVQ3MlFyektQZElXdlBKYlFz?=
 =?utf-8?B?ZDBJMUdQVld0V3kzV1htdWVBWVpLSUJpZUNhSEI1aTFWenJDNnBDaXJFUU1l?=
 =?utf-8?B?VWF3T21YUFdBTDlJa256S1ZJUEg5UVFoUzFwK1hKalA3V0RybmJRUWYwMzRJ?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F9281C5DCB7E24C91023B603345EB60@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29f8824-6057-4db0-76e3-08de0d574d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 08:29:34.1214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CkRhIjf0mLh5TZQpp11Y5wqvqfmgH4VmVpj/wIyXKt+N/UzOIePJ/ssEntBwkH6YsjfURlusBxzSHWCCUiOwYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6847

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEzOjAwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFJldHVybiBkaXJlY3RseSBpbnN0ZWFkIG9mIGp1bXBpbmcgdG8gYSByZXR1cm4gc3RhdGVt
ZW50LiBObw0KPiBmdW5jdGlvbmFsaXR5IGhhcyBiZWVuIGNoYW5nZWQuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCg0KUmV2aWV3ZWQt
Ynk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
