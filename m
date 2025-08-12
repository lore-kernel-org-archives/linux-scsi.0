Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3092E7173
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989445; cv=fail; b=RpCkNyn8tliBnFpTOUyjm+E1IvECkiPurvkBd/6GBtmi7bQjuDBGp0L6lPEl+V3x70m78yAEArLkFnjakUOWdPqkvcj9e9+p3rPD1G0im6mKnguzsIY1LOw/EOzdT2n/FnWi1FeTToIWLm7slYsmeIFH9TfuP7zaOn5edte8BpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989445; c=relaxed/simple;
	bh=PkbBVu81fMsNQZl34lUNji3MgqO7xNYnOjZANQBJsjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J+jp9/vfVfHQyMwQxfaKEeo0Zi2Q7o48LugcxcpiXqTkCjjo08S0cWxWWknJqE4ZEa4Ggq78ODwodP8xaTBOSZktYM0pSbYukWXG7hSvT4aYphrArj7fA3r8dNjhVmTIoCXc7/tJf61or0xor1a6glE+M4Q3SshKx2QiZiR3btc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nz4leTeS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=q6kz/b5f; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nz4leTeS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="q6kz/b5f"
X-UUID: 477f351c775b11f0b33aeb1e7f16c2b6-20250812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PkbBVu81fMsNQZl34lUNji3MgqO7xNYnOjZANQBJsjQ=;
	b=nz4leTeSJiSxSOaeSKhE2AirlXtwBkjz4F4+kfMnM95S7vzBfUs5+2yGVdf6j7LMwrCQzYDW5bkm4j88V6Sb+r5m4pCW8RUrN3/ylTtBZSmFbKX1ecZEPC4XgUreb9ThjZeP+HSDpsdK42S2+jOoF8tctaJO/dAi6QuO3MqzH7g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:8dab89ba-d751-4865-b6ba-8d6a4ba19d12,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:adafda9d-7ad4-4169-ab95-78e9164f00fe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 477f351c775b11f0b33aeb1e7f16c2b6-20250812
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1931368186; Tue, 12 Aug 2025 17:03:57 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 12 Aug 2025 17:03:55 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 12 Aug 2025 17:03:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V/ePcVxJP9J0p1E76xzDXi6NccnDHqtiNY6wahF+tnwatODR0cwvPFp2ZPNUwF+R6tCZL1GP/O85Ejt22M0XDV+fGEEzX2e1Qjw4+4beLrS1pnyNPC0MZStvOdW2D32a1i24sx98EOVftixRdfDAi2DOZGGwxKFm6b2/okzTMNpvor6/KokEhAYcS4JBoz7l3gsXXX4KJOAjzO4fuuqHqEbH9ESqDsKaC8i4RRN5GLf2WCB8c+ZRRELnQkJ5BgG4eaSOgRE7aDE8i5J/KPAGy6NNFnQdVBhug3hASIJvCNsdBUDV+gx2F2VmSh4QTXYhj3HaBEBptfER8WypYtn+lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkbBVu81fMsNQZl34lUNji3MgqO7xNYnOjZANQBJsjQ=;
 b=uYSQ5bKaNz/PfGsC6MFFp3JzvyT1UNu3xwfK7GxPKS0P21XnXvHmwIQLdFyyWI2MQ7dm+BA9IUycY0lPfc3HOX6nMqTDDoCkdFZP+iP1tdirO+Nw6uDKz/6QS35pZ1chKHv2kRn1uT22T6xGPSRS+2AjKtO6Zc0gFQypHMguog2hZjidT/WSOJ2Eg6tXa/YgYalkjw56VC4mG5/NKti/6KVw5d6ZNiP3uu+qH+TUnVFjN3WPQjjXU44Y9+CjhaRrKGN6fu6K5VEjQ9iXNfTIaZ7pbiMlpe/Iyjhz0fJ2x4yakBeIT80GXZolhrQSiZKnZMrNh+165+25hL7EUCKpAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkbBVu81fMsNQZl34lUNji3MgqO7xNYnOjZANQBJsjQ=;
 b=q6kz/b5ffee7lEsAWz+quo957sN8vu9mDr+rfkjKx0va3ih19eHXR0IJRCraQ+3q/gNzWkp1Pu2hipPDM1DRgX7SkozuscyasmN/evnhH8+IRLovhfUyaH9z+DvujyEddJEu16taeaecj0P5s/sk1ZRGdisv/1c9Vo23GaQhmRU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE1PPF1EE48B57A.apcprd03.prod.outlook.com (2603:1096:108:1::849) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Tue, 12 Aug
 2025 09:03:53 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 09:03:53 +0000
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
Thread-Index: AQHcCtdo7AdJE9MAlEyqkHCv+jyHgbReul0A
Date: Tue, 12 Aug 2025 09:03:53 +0000
Message-ID: <f11710482738e2550ede731eb8699a2c9967fe8a.camel@mediatek.com>
References: <20250811154711.394297-1-bvanassche@acm.org>
	 <20250811154711.394297-5-bvanassche@acm.org>
In-Reply-To: <20250811154711.394297-5-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE1PPF1EE48B57A:EE_
x-ms-office365-filtering-correlation-id: ce56a9e4-301d-4760-9286-08ddd97f2960
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dm5ZS1I0QXU3cU5abnRtNjUrOS92bm91aGdZd3ZvaFJVTGJudzU2cUJVcjVF?=
 =?utf-8?B?ekVCb3BRbjVOcEFlemh2K3k5Uzk4ckdpWnNBeExqQkNicGVOQ3JwRGZoNHZB?=
 =?utf-8?B?YnNTS3I1WVRRRGRoa2dsOE1KdndUNHU2TEFwWTNBaG11QjlwZlpOL09KT2ZB?=
 =?utf-8?B?K1JVMGNwMG5mSTM4TG9icEVBaUd1bERybGV3UlhkUHFEWmo1dlVaZlVYb0k3?=
 =?utf-8?B?NmZVcUxRTWxJUldyQThhTzNyZXM4d1JlSEorSGNqZnlRbzBHeC8zQVdiM1B0?=
 =?utf-8?B?ZUdSYzVuOVRicDYyb0s3cSttOWZERE1CRzk1VmtuRExLdDZZaDZZUmVQNVJX?=
 =?utf-8?B?OVZmb3UxM2RrOGtuazgySHFBK3k0YnRIazBhZ1BOb1dOd2luK0VnNFhtcEwy?=
 =?utf-8?B?MHJ0YlVoRitKRi9Ueld1dW9uQlRETTk3aVR0MEJ0dEc5SEVtRTVzdmx4eWQ3?=
 =?utf-8?B?WE11STFsbVhoaFQxSkY5Wkd0WmRQR0ZockpuRXFOcEpVb3dTSEY5bGJuTXZF?=
 =?utf-8?B?SWhCVFk4RWNWK1RMaDZCVURuOWRsaTNTaTBuTm1RNUxqbUpaZFdjbVJENDVz?=
 =?utf-8?B?QmJ3UW1WTW9ZMGNrSlgxRllxbDFYdmpPOU5XSHM0bmZDdldFTlZyeUtYQTJQ?=
 =?utf-8?B?Mmc0c2kxcmdhcnhLMGFoVlIzQlhTUy84V0xTNTlJcmNWTitMbWYzeWtGV0xJ?=
 =?utf-8?B?MmJrU1BOdCtxbDBqbk9MTkVydklqNzRqdlhMUk5rWHVmOUkyZWRUVFJ6cUhm?=
 =?utf-8?B?L2JCWnFnTTliTWQ1ZnRBaUhnNldYY1hnSnp1NFhGRXNHcS9YUFVGMUF1SlBV?=
 =?utf-8?B?djUvTjg3aFNvYWsrWlMvMDd2cVVldUpsNFVJMno5WmgvZDRSaTUxbEduSU9E?=
 =?utf-8?B?dXhjcDBEdFlBcTZ3VFRDbnBmdGVha1hXZzBqbVJWaGpnZlVoMFVseGpPeXA4?=
 =?utf-8?B?QnNZa21CblloTlh2Mldoa3MvTmlPMkVpbmNHVnZWWUMxMUZ0bjlOOXpXTmo5?=
 =?utf-8?B?S1NpOFNsajkwVzJGZUM2U285b0x4bkVQUmtVMFBwVHhnK2ZKdm9RWXh2aTlF?=
 =?utf-8?B?K0dZS3ZhZUJiRnlva05nTy9lUlRmemZMWENXanpBOUdDSWhEc3pXQ1JVQWM0?=
 =?utf-8?B?aHFhNzVhSzlQMFdIS3dLNGMvY2FELzFZYlRsQUhNdlV4a1p0UGMwNUZ1RmEr?=
 =?utf-8?B?b1VVTDBIRVpmK2dTVWZVbTlDVkxBQ3dVbVZFUnl2R0czRFVUdVphSC95ZTBz?=
 =?utf-8?B?aFRNMUhNTUpDYWgrd3FZN21zQlhIcE5jeDdFMmNLZjZoTmxQcVBZSXhNQStU?=
 =?utf-8?B?dmdTaWJDU1VMdm42VGdBVnhEcXIzNGtUaThvUW16RGlrTW0xQjA2TDNkQnhZ?=
 =?utf-8?B?UHA0Q0UrcFBSQ2E3QzlrcWVFeFpxK1lXMFg1NmhKMDYxMHhmT2NVU2lvRmFQ?=
 =?utf-8?B?OHhxRkdNY2pjUlRwbTNUcVdrRTFtSTY0MlVMRmx6aFMxdHJrV2lTaloxVjBE?=
 =?utf-8?B?d2xoLzkySXNXRmNyOUJqWUZVWFdJMUFkUWxzaURKZmdIN2NUMmdLWDUrMnU1?=
 =?utf-8?B?UVBDemFpV0l6UHRxRDNNbnpRdzFpTHVNZjlKNmk1Qjk0UnhRL1ArTCtITzVn?=
 =?utf-8?B?WlY0RVMwMzBVTGFDbHhmWlpuWmFlaGVnZGVMd1RCR0U2b0hOL21FNjJ0cEZk?=
 =?utf-8?B?YXJFeEp0Y3VNc0pic1MyM1JLcDFUN1Nza2NHMC92WXpxclpRazFVakxEVGph?=
 =?utf-8?B?L0hvTldOdEN5cDBCTVBueGZyNkx3dnR5WFNKOTA4U1RxZmlZZlkxNmRhYk5P?=
 =?utf-8?B?VWhwODVTcHRud0UzTUlpM2l6dXFHVTIxODQ3cENIa0lHcEx2QVVGYmRmell0?=
 =?utf-8?B?MHRSbEpseGZNVGtGSWZXclRoSm5ncWJWckpHbjhZa0dDMzdMK1hyalJPaVJR?=
 =?utf-8?B?c1FQREZDcTY3MmY4YStJTTdZR2pBYzExeWNJNkwxb3pweUZYd29wcnY5YTJk?=
 =?utf-8?Q?zdjK0wczG2VTEItYJ7tynx99VD/+Nc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3FwakRmYWIzWEx3YnVEZ1g0YnE4VW9uZTdxMnlyVHE5SHo0SUFnV0lRS29U?=
 =?utf-8?B?S0ZKZlFTUW1SY1kvUDh0VFlMY0xPdVhVeWRZc3hER2c5MTg5S3RUM3ZDMjcy?=
 =?utf-8?B?WUhnVWRRSWllQ0kxckJuV2t0RENPV1BwaWVGSGRta3MxekJWTTVBcDZmc2g0?=
 =?utf-8?B?SHh2MzQ4OFVzckc5dHQ5VFpzaWtRekhGZ3hXaTArd2N0ZUhjUGJxSTBjb3FE?=
 =?utf-8?B?TWJVcTYrUWFpbWRPa0lKM29USVE2Mjl4Sit6QnNqWkpnZkNmd2I0bzJtZVBx?=
 =?utf-8?B?YUZ1RTU1b09kakdESWRjM1gwL2VhRUF4OVRUc1F3QnNEQWp4N25uY2VSOWpn?=
 =?utf-8?B?VkVxbzg4OTA5UXdUTXlnNVlhMzFaMnkzK0ZoM2IxOXM5bWZhZks3YUozNktr?=
 =?utf-8?B?Tml2dUMzVFp6QWNzaUhJT0Y3N3MrQ3ZxZ2Z6YTVLRWJRUEdYaVY5TlZzZEx1?=
 =?utf-8?B?QWNMbnd1Vk13UlE1T2lPQlF3S0lVK2pyOUxPQ0kvRitRbTRlTW9wSXN2bkli?=
 =?utf-8?B?d0pMZTVjdnk2UngyclJJS3U2a0cwdnN2cXNUQ0NuOVN2d2l3elBqaXBlcjB2?=
 =?utf-8?B?eVQwSnVvVktjM2Zxb0xnRnBxc0JWajEyK1MxSFhDcFFBYWNjWE50VVhkQnJs?=
 =?utf-8?B?d0RwcTN2UTY4Ti9oMmlqaitNN2k5VjhIR3FQZDZSL0M1QWlPV2Fjb1FTRWFL?=
 =?utf-8?B?elp3Ni9kYkk5OUR3QU9iME9UUWVQS09Hc1B0cDB4V3c2TUVSZm9rL1ZDL24w?=
 =?utf-8?B?Q0NWTVRITjByU0dsUDdITDlINzg2WXR4R2taOHNqUVYrNlo1VzkwcWlwMzRV?=
 =?utf-8?B?M2FxU2lGOXY4ZGExMzJSUEZHaFcySGhzWWw2SDNBQndFdEc0NnhmOFlPSDRO?=
 =?utf-8?B?UVo0SzRHaEVhblRXQUNwQUVyN3NORGFyd09NdVJZaUhoUzdrR2tvYU9iN3JL?=
 =?utf-8?B?T0pDL0w3VU5tM2hUR2Jmd1dFb2d0NUJqRm5hcmZHVHVBVUhXU3RzVUFac1lQ?=
 =?utf-8?B?YkxsNGNPU0M3a1BxWVBqM0hvTlV3UU9WVmk5c2lmTm0rcm9mekNpZU1lVjBL?=
 =?utf-8?B?Zm5iOUhaTmIvTFhwMGs0ZVdGSFJvSm9MVWd6Y1B6a0lwNE1mSWNJcnVVTmJC?=
 =?utf-8?B?ZHQxTDRBN2IxMGFQY0YzTjdHeW80ME12ZnhaNWJWUExIVE45WVJxMklqWEZ2?=
 =?utf-8?B?a1l5d09zT0FraFc4dTF6QTdocnpXdHVvcUxTdjJUZlA2SGplQ1V3QU5zWk5m?=
 =?utf-8?B?Y3JqaVJWNjZucDFaQjljZTZqSmIwVXRaVEJkVTNsQy82L09qbDFlWlErV3Ra?=
 =?utf-8?B?MGEzYlE4M055WjdhU1hOVFFiMGJBUERpUWk3dVJJdGZGZTJ4QkZPQVBUS2lh?=
 =?utf-8?B?Si9zK0U2NzIrSmtwM3dod3hrREwvbWhSYzBwVmpHOE5oZEU2TjQ1MHNtb1Ir?=
 =?utf-8?B?YWN4Qm1Ca3Y1VU4wdGVLVlRPWHRtQjV0ODZaRTdIWTF5RlEzcGljWWZrTVVJ?=
 =?utf-8?B?YnNrN0kxdXd5bWh2OThVTG83STNjelBZZURYcjdzU0l3UEhPMFBYUnpicHBn?=
 =?utf-8?B?NEJ1ZEorN1J4RTAwUExIZlZDZUlDbkFkZDhabFZvUDB3SEE1dkNxUDVFSDhi?=
 =?utf-8?B?QmpQV095b3g0MTZZWGpmOEdCQk14OThsYUhheDMxZGpRdDhFcWJIQUZSMW1O?=
 =?utf-8?B?N0lwdVpMT1ZrNmdJRTEzMS9oRjJSb3B2NUl4L1JsSjlIaEdKVXI4ZDRVa0E4?=
 =?utf-8?B?bGpyVEd3aXY1alZlanNBSksrMXRLdGxiWStzdDd4dk5VR04ycXFhMnl4eFVF?=
 =?utf-8?B?ZkpmYXI3dVhzbmFTQWIyZVV1M1hrUXpUbmJ3NDl5aHdkUlplcE9Wc2NwcTEr?=
 =?utf-8?B?MFJuanNoMWd2WTlYbTVhTjhab3JkR0VRU0FGWGttNnlWclU3L0VHN0tNTzFT?=
 =?utf-8?B?SWdQN2cxRUtITjJ4YVB0bW9NQ1pnN25kSmRPc0QvRXIxYmxoZUZwYlo2eFVW?=
 =?utf-8?B?WFcwbDlKY2dOeStMTkRXMDdtNXdndjViWE16VHVsOU5FeEptQzBDOUQzTWhE?=
 =?utf-8?B?bzUwQkVjUEs5MTd1Z2tVbXFnWE1GWjZ5OTNIN1dWd3gxR3M2ZVFvbTZoZmJQ?=
 =?utf-8?B?TklhWkJZcmsrbDFLWTJxYi8wMlo0dVBqMGpYZHNiWGxrUVVPdkx6cUhoYjM2?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D908FFE353BDB469ACEDAA8FF04094A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce56a9e4-301d-4760-9286-08ddd97f2960
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 09:03:53.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EOOWdPB9Bzmm7lVyHkr6JakwWIhtfQ+xSJNfO1RWWkUeBIEcrB5aKStbdnBuv3KFsFoxrZDiHLRWcGvpqXP71Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF1EE48B57A

T24gTW9uLCAyMDI1LTA4LTExIGF0IDA4OjQ2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZSBuYW1lIHVmc2hjZF93YWl0X2Zvcl9kb29yYmVsbF9jbHIoKSByZWZlcnMgdG8gbGVn
YWN5IG1vZGUuIENvbW1pdA0KPiA4ZDA3N2VkZTQ4YzEgKCJzY3NpOiB1ZnM6IE9wdGltaXplIHRo
ZSBjb21tYW5kIHF1ZXVlaW5nIGNvZGUiKSBhZGRlZA0KPiBzdXBwb3J0IGZvciBNQ1EgbW9kZSBp
biB0aGlzIGZ1bmN0aW9uLiBTaW5jZSB0aGVuIHRoZSBuYW1lIG9mIHRoaXMNCj4gZnVuY3Rpb24g
aXMgbWlzbGVhZGluZy4gSGVuY2UgY2hhbmdlIHRoZSBuYW1lIG9mIHRoaXMgZnVuY3Rpb24gaW50
bw0KPiBzb21ldGhpbmcgdGhhdCBpcyBhcHByb3ByaWF0ZSBmb3IgYm90aCBsZWdhY3kgYW5kIE1D
USBtb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hl
QGFjbS5vcmc+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCA0ICsrLS0N
Cj4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jDQo+IGluZGV4IGI1MDU3Y2UyN2FhOS4uMWI4ZTJlNjhjNjAwIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMNCj4gQEAgLTEzMDMsNyArMTMwMyw3IEBAIHN0YXRpYyB1MzIgdWZzaGNkX3Bl
bmRpbmdfY21kcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiDCoCAqDQo+IMKgICogUmV0dXJu
OiAwIHVwb24gc3VjY2VzczsgLUVCVVNZIHVwb24gdGltZW91dC4NCj4gwqAgKi8NCj4gLXN0YXRp
YyBpbnQgdWZzaGNkX3dhaXRfZm9yX2Rvb3JiZWxsX2NscihzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0K
PiArc3RhdGljIGludCB1ZnNoY2Rfd2FpdF9mb3JfcGVuZGluZ19jbWRzKHN0cnVjdCB1ZnNfaGJh
ICpoYmEsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1NjQgd2FpdF90aW1lb3V0X3VzKQ0KPiDC
oHsNCj4gwqDCoMKgwqDCoMKgwqAgaW50IHJldCA9IDA7DQo+IEBAIC0xNDMxLDcgKzE0MzEsNyBA
QCBzdGF0aWMgaW50IHVmc2hjZF9jbG9ja19zY2FsaW5nX3ByZXBhcmUoc3RydWN0DQo+IHVmc19o
YmEgKmhiYSwgdTY0IHRpbWVvdXRfdXMpDQo+IMKgwqDCoMKgwqDCoMKgIGRvd25fd3JpdGUoJmhi
YS0+Y2xrX3NjYWxpbmdfbG9jayk7DQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAoIWhiYS0+Y2xr
X3NjYWxpbmcuaXNfYWxsb3dlZCB8fA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX3dh
aXRfZm9yX2Rvb3JiZWxsX2NscihoYmEsIHRpbWVvdXRfdXMpKSB7DQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoCB1ZnNoY2Rfd2FpdF9mb3JfcGVuZGluZ19jbWRzKGhiYSwgdGltZW91dF91cykpIHsN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FQlVTWTsNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVwX3dyaXRlKCZoYmEtPmNsa19zY2FsaW5nX2xvY2sp
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXV0ZXhfdW5sb2NrKCZoYmEtPndi
X211dGV4KTsNCg0KSGkgQmFydCwNCg0KSSB0aGluayB0aGlzIHBhdGNoIGlzIGZpbmUsIGJ1dCB0
aGVyZSBpcyBhbm90aGVyIHJlbGF0ZWQgcXVlc3Rpb24uDQpBY2NvcmRpbmcgdG8gdGhlIFVGUyBz
cGVjaWZpY2F0aW9uLCBzd2l0Y2hpbmcgZ2VhcnMgZG9lcyBub3QgDQpyZXF1aXJlIHdhaXRpbmcg
Zm9yIElPIHRvIGNvbXBsZXRlLiBUaGVyZWZvcmUsIHNob3VsZCB3ZSBjb25zaWRlcg0KcmVtb3Zp
bmcgdGhpcyBmdW5jdGlvbiBlbnRpcmVseT8NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
