Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8237D2153CE
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 06:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755238899; cv=fail; b=sn+aNyL2dZxjs0Cde3igsAKS0CJD1d4Xoi2Qz6HtqeZxtcdGILTvKN/k/EbP8IHiucMvqcPN2fLlDDMgM4opHL0O6uht291R30cp8g66JPYS3LV9eRTE1+FwjgV8srzAEhEl5I/wdmIV/LI0m/cWRL+f9rShulyC3qrvJxuZ8YQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755238899; c=relaxed/simple;
	bh=wD9SHqeLGd5WCPWpIU41B2lzQH5JrJy/vo0DvO8BBaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gueDhYtNjsc9DoHS/t3WqNhOWNgmZjkNg+8cBzB0d2Q9CM78wywjudAWt1baMRiQWWprJZSAeiBgGD/xOYin01XM193BlvOq6TFD+aWPqbQd+62JLclknqxdICYn1oXWwOP91H8v1Rqo1gG17dNfvxztsIAyg1jqM0p5iFkTJCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BVmfZm+e; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fuCledUL; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BVmfZm+e";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fuCledUL"
X-UUID: 16c5a82479a011f0b33aeb1e7f16c2b6-20250815
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wD9SHqeLGd5WCPWpIU41B2lzQH5JrJy/vo0DvO8BBaw=;
	b=BVmfZm+eNwfldiAe5wJlckZ1mkI/Wh65a3NPcCFGwwKYW4Nxg4WAnHrqJVVSSUZnBpdhlAAfUnAINLMbaxZpK+Lr7e7UJ4LwZ45q+n5RJzY5QJDK5HzUOhK2lrJi9rjDniGn+tw+TXWdDZuTxBpi7K9SI3jcE5C3hxGoUo5scFQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:909444df-2053-4100-a115-1a3234f9d659,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:28fe3f6d-c2f4-47a6-876f-59a53e9ecc6e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 16c5a82479a011f0b33aeb1e7f16c2b6-20250815
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 969326398; Fri, 15 Aug 2025 14:21:33 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 15 Aug 2025 14:21:31 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 15 Aug 2025 14:21:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zAhfHQaQaPKUadL7sN9GBUH52KMX4A4JCTu87knaIZgprt+jO6JVChMsbvhYpFHPLE0Q+yzgOE+thvNOa1USnYTQRdpQby4khIuVjYa91JIkef3m1PCxWSUdeVRqZYRztqyaoUGmbVeJfSyOvTIiKFqIkpYdMNB0Xly3H5/pYiKdkHBBWLkACY/ayDvTNWYEm5NaLC+zqiIn2XGDye64fUBTxIdc4NFbrMbprjbyhBcCi/uCQJsHZxInan/nAGrOK5l928tW2vuRVts7pv5Jq0pTkJehjs2DnZC9pzXN83TMj1yi5dLHE0DlzkjUFRO5uYq96UGuy1uiJTAwlCx+MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wD9SHqeLGd5WCPWpIU41B2lzQH5JrJy/vo0DvO8BBaw=;
 b=UW10OMN6IQ4DOZDjmCjku/GlFTFZrBRPv1XkSn7KKnie/voX7UyGrWa9l5g9N/VPI1Q3fn3InCVdkNxP4c9qXxWF2gU4+geul4MyUIdBi71hquRlFYLLNNzYo8j/DmPJ7DNlJAVRMAm/jlSpEwlsr8VH0yO74h5g4rha5wkUuZufkhsQ8tsGdO/MxOfup9UJYnbK/CMdgiHGMr/Qw/Fr85FXZ1xIgbuB0k8jcQLzSneA4jWNx/BI5Az+hfymZjSkiLRy7FNVAXNJ7o6wRYhiE3CiJNra/uV97MTJozC8SH7G49kZKQ8YXdPl5FKVaKV0UoBDQFbLecQIl2Edzpn5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wD9SHqeLGd5WCPWpIU41B2lzQH5JrJy/vo0DvO8BBaw=;
 b=fuCledULB0TawMDx4lPB0w+57CNJZv2A2bkm2UkBcbVC67cvjlci8TQjE1x2ejn9Pbl5SINlWawJFvkR/WMwHtyTYKV957FzP8Wdt0ZZm5luNAPEMP0y4ggNozl9PRo/ZjCwkZTahIH58QGP3NRthvAoJS59yvggxa0/lPuvmXo=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by JH0PR03MB7510.apcprd03.prod.outlook.com (2603:1096:990:b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 06:21:29 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 06:21:29 +0000
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
Subject: Re: [PATCH] ufs: core: Improve IOPS
Thread-Topic: [PATCH] ufs: core: Improve IOPS
Thread-Index: AQHcDHVWtz3rU9kVDEiO9hO+dWi6vbRh0fGAgAB7B4CAAPPJgA==
Date: Fri, 15 Aug 2025 06:21:29 +0000
Message-ID: <1f67bcc9c93101260223dcc6e7844f07d463e4a8.camel@mediatek.com>
References: <20250813171049.3399387-1-bvanassche@acm.org>
	 <6413b3a930b073440793f2dd1578dd2ec8bd7b18.camel@mediatek.com>
	 <bf5ee29b-bd7c-4fd6-a558-eba0b9c09fa4@acm.org>
In-Reply-To: <bf5ee29b-bd7c-4fd6-a558-eba0b9c09fa4@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|JH0PR03MB7510:EE_
x-ms-office365-filtering-correlation-id: 8cde130d-a7ab-43b2-e0bf-08dddbc3f8f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cElkUnNMWkRhMkVwQ0ZiV05TSW1weENpMmZIT3YxQnc2WWFtVU8xOHEySERv?=
 =?utf-8?B?R1BaRmdCd1UrNzdLb0F3WU45bmdqUjJ0MDluenJZUUxZTGRydjJaRGxuSTQz?=
 =?utf-8?B?RnpqSTFBTENRYVNvUHNVWUhCc3dtc0R1YTBQd0FjL1RDQUZFazRpbHd5d0d2?=
 =?utf-8?B?WU40WGFiRERzRGZQZFVPbENEem52bmVuZVZqVkV6bGpubmFoaTM2TENEYWFs?=
 =?utf-8?B?aUxaOWJXNXBmMllnZloveE5EN0tqbUxYU1ZOdlhkWWYvZUx2U2tydDRqbFJl?=
 =?utf-8?B?ajZrWGZySEw5S282by84QjRXZkVtTHBWZlBKQXIzR25NWk9DZThTN3hWdEI5?=
 =?utf-8?B?eUVjUnpxNHBaMkNCR0RHK1kyM3hBdVJwM3l0U3hVdTNCYmZjdUV3UnFtQnBO?=
 =?utf-8?B?UU5qVmRMZlpjTTZEOVJmeTUxenJucElpNmJqZWFqQVNRalJlMm5BQ2FHVm10?=
 =?utf-8?B?eWdNM3JWclpFczE2NmhxUzhHT1JReW9hd0czT0RaSTdzR01DQ3VZdnJDZEt2?=
 =?utf-8?B?VVJ1TjJiMUpFMkRCaXJNZjNsUkFEWFF3VDdBU0RVQXB6YU92YmJaZTlSSEtH?=
 =?utf-8?B?R1pZWk5mYXlsS1NVR2F4dzE5VkY4azcyU2Vjd0IwZUpQUGkwSkp2bnRBZjRo?=
 =?utf-8?B?MFp1R1BRaTNLTWxvR1pXUzBIb3dLM255WTEzYm1VUmdTMjhsalRKZ3NNRVh1?=
 =?utf-8?B?bERUdmlFU3ZraDJ4dkErTVdXOHFmSGVxUmVTKzRqNkVyTGdQZXoxN3NtcUVG?=
 =?utf-8?B?Rm81b1RVK0pYdFZZVWJhcStPVXFDQlovTm5GZWNnNS9YQWgxS3oxQllWYU5z?=
 =?utf-8?B?MlZRM3U1VTZvSGJuUWZwWDVQV2IwWTJ1RnNiT0FFb3VLZTFockp6WGM1NEZl?=
 =?utf-8?B?REJnM0VmWVJBV28rYUxPVDdvNDllSllBUWVkUis2ZTJ4VEJKcys1THZxNno5?=
 =?utf-8?B?dFdQb1Y5MkNOOXZRRkRMZWZBNmxBKzUzUEpzQU8wTXRHbmQrTUhWUlFpOS9n?=
 =?utf-8?B?TFdPekFsckpvdndURndUS3haRHQ2QlE1bjdvaEk5emhUcHNEdFlXMTZIMmtH?=
 =?utf-8?B?dnVJamlyUVhaMm9jRGg4Unp3emtlYmRudnZlRUxxTktPOURWR3UwWmU1eFJO?=
 =?utf-8?B?bGF4dUJxcUNqZEh5UCtHQ2pZeTlkOHpQTDA4OGEvZ0lMcHFyejZLMjYreFhJ?=
 =?utf-8?B?MXkwLzZMcEJsa0d4bllFY2cvSXJEekowQytCNmtTc2E4ay9oNHdxWGJrZHkx?=
 =?utf-8?B?WUd4dWVuc2J1aWs4Y3JwdHR1ckJ0a1FkZDJKRHhkeFlvM1VzdGorMERvNHVW?=
 =?utf-8?B?Uyt3TXV6Y1ROM0dtRjZuV2dPSExFRUtpMm9jcWdzM2k5MDNka1M4cERyc2Zo?=
 =?utf-8?B?bzU1b3l1TU91WmhIVUJkMVFjUEErSTAzN0xTTmUycHpNcmpFTFlGUmlzOThR?=
 =?utf-8?B?UWNacTJuR0JxbDgxa3ZUaWd3MTBSQUdvYXFCN2NZRjdlTHF6RUgwckxDOTdz?=
 =?utf-8?B?dkhzR044SzEyMThtM0VVUHJ0ZDRPam9ad1EwWWkwYXplMjBPRlNCWWpUblI4?=
 =?utf-8?B?QkQ2eVE0Mjk0KzBacFBNRW9kS3ZvaUtUZEZIQis5S1BVNDJKWXAzcmVrd3hC?=
 =?utf-8?B?OWMvb1o1NWpWWitUeGJCSnF2RDFFUEk0NkFpSFZ3dHJ5MWw3U296MTA4YWlG?=
 =?utf-8?B?cWJ1U1NTc05JbTQzQlNYVUNtWWcya093VHRiVnkrUTFaOWxyR1gxdEpUU1lk?=
 =?utf-8?B?YUFWVXRobFNmb08xQlpjR3RoYW5DNzhidE00L09DYVdZYTByMm4rb2dPdXh2?=
 =?utf-8?B?QkVndjdBeXU1OFZXT1dSalNFdnh2b1FOLzUvTXZLKzRnVkhEVHpvcUxBaVpH?=
 =?utf-8?B?MDNhNmNoeEhyWmZPeXdZZVNWeksyRUJ6bkp3OEtkVWwzUGNZbXRNNFRqK3Fl?=
 =?utf-8?B?bVB5WXd4WkEvVzV6T1VUcHJhbG4wbEg3NXlWa2wzZmYwcWRJMm1XcDBBMVhQ?=
 =?utf-8?B?aENTOFo5eHF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXROZFNuMW4yVnJRTzBBY2NFaXhrMDhDQTZTQVdjZUEvbW1jbTlYcHRtRkts?=
 =?utf-8?B?T2JVMkNDblRKZkRqQ1BFVVhYUHhWejFwdXVta1FwMktYZlJUbEdHbzdyS3pV?=
 =?utf-8?B?aTlhY2xDcG5ZMWp5Yi9JQmQyUVdZU0pKMnEwVjdHekl1NlZVb1FXdmZRbWRa?=
 =?utf-8?B?N0Vwak80WFlmd2JLcEpVVi91cFR5NE04bDg1Z0V4WHNUWkRWU2ZyejkwazJn?=
 =?utf-8?B?Z1hiRTg2d1R2eUNpTmYyeG5sYno1bGR1RTJuMWNBbjF2cVcwMDIraFFlSTdW?=
 =?utf-8?B?aWNTcFFya2NJOFhVaTBFQnBIbGxSWTBEUDVKcFFGdWtrWDAyTER4MVM4Y0pP?=
 =?utf-8?B?WlZaajNUQjFxVmxqV2FMR3lKV1RNTEhJVTZZSlQ3Y2p5L3QxNTgxalBYVWxH?=
 =?utf-8?B?NEY0cEtDVlRCWEdVaTlvUGI4VUpYWTJsbXlCaEtYS043ZHlqbUtLaXhkdW9h?=
 =?utf-8?B?NndpR0lqSlY2ME9LNnZTQUJFaWRhVWpOaEhDbWREK2RXeU03YTdlY29wSEJz?=
 =?utf-8?B?VFJoMjlQWnNmYlFqOG05TzVxRlpmbkdRRVJNcUdDb3duN2FZT0J0TUx3MCto?=
 =?utf-8?B?RmdjN1EyUFhCUksyMFVrSXJJWkM4eDVhdEtIemR4aFNyUTBkSnRCaDJad2Z3?=
 =?utf-8?B?c0p6ZHdNVi9ISWM4WHNpbk0yVE9mN1N1RUJTdVpUSWdVc09lRWU0VDFtbncy?=
 =?utf-8?B?MTdMUE1IeFJqRm13Z2pmdWx4N01vbDUzclFMaGk0amc1Y1lGNlNydjI0ZFZY?=
 =?utf-8?B?OE5CWTllVHp6VlFTM1VrTitSWWFuVm0wT2VuczlOa0pheXBuNitEaUxpWFpK?=
 =?utf-8?B?ekFUTEJOWmd2Z0E3cHBBWFEyODgxWm9WclRuSUFiU1lRMVlsWi9sT1RPQ1FI?=
 =?utf-8?B?eGtPVjVYaklkcHh0NHB0b1c5VXBwVjJlQzhTSjVFVFplbmx0d21xcjZvT01z?=
 =?utf-8?B?cmJxMEppNXdEWjV0WmVyby83clFaUzMxV3UvR0VSa0FGSENQWmdyc093MW1C?=
 =?utf-8?B?OGZjMzg3NFJKT1FicEhPMVZHTlFGSVBERGdjSUdiMU15dE1yOEJMU2lyVEFi?=
 =?utf-8?B?RjdDc1luV2FzKy9jMXVERnVVa2lvQUl3VDk0YUR2ZGtlczhuOHBCTnI3aG8v?=
 =?utf-8?B?ejh3WW5Jdm9jaGlkeCsyZ3lNc0M2Z0gxOFBJbGhrZDlwNWpRREd2cDBwMjRi?=
 =?utf-8?B?RlJadG5BcUtEQU5pUzZPTzB0U0JRSDNveG1kbUd3ODE3VHZieG92UGErRml4?=
 =?utf-8?B?dGx1QnB4cDZaczhDTFc4bHFyalVSR1B1Qk1Uc2FPa1ByUGRsS0d0MUpvdkQ5?=
 =?utf-8?B?SVhSa0FpZm1qVXpWOE15QVUvb21jQWxSK1N1cVdmY0J0RFFzbElLb3lTbGF3?=
 =?utf-8?B?TUsxdDlIM2pteG8zMWR6b1ovUWEzbTA2dTBwdldLMmU1ZTFSUzMwS1RtUGIr?=
 =?utf-8?B?TitOVVpoV1Q3azM3cGc0SFI3T2l6M2Nmd0pFQ3B2SjU5SGJNYi90bGhLYWJH?=
 =?utf-8?B?bHFrbnZKNUFET09DZlJuK3JWNGxaT3RZWG10VEF6VldQa0w2K0dLc0d6WHcx?=
 =?utf-8?B?endWTDlSUHNIdW5Cd2kwbVJTUU1qMDFERThuVS9TZlFSSG5ob0dzeTBQYkpI?=
 =?utf-8?B?U00xZUFVRklEekFibzg0RVJVV1dvMEwrMWJqVmNqUWNvMVJnbTNNS21YbHB4?=
 =?utf-8?B?bmE0cXNGM3ZoS3dnOUpSMUJWa3VzSS9BOUtmOEVsdDhsSnA2bXRRS1VjTHhB?=
 =?utf-8?B?dEFEWHJvR2J6QTZCSEgwQmRlRWlMS2U1a1Mybi9LcDlpTkdOSnEwdW8zSGJu?=
 =?utf-8?B?ampGdlRtZnNKTWNTZG1OTTYvdjRSTWE0QnVmSUNUUnVYUkNzTkx5ZXNvNkxv?=
 =?utf-8?B?Q3U1akJ1ME1ha2NnSUtEemlud0hzcmUvT3RudzRDSmdaRW4zenpRbzNPaDRo?=
 =?utf-8?B?aVl6SVNScVhMWUplcTRXZHM2bkFsZU5tMVYzZWkrWWF3dHFoSUN1U2pXbFM3?=
 =?utf-8?B?eFB4SVBEQlI3Z0kvdEhydHdxc1ozRXJPb2lYOFIyd0h5QUxUTGl1V3R5SUxE?=
 =?utf-8?B?WmRQNHVyT1h2eG0xaWpCK25XQ0hJdFVvbmN5ZEVhZnhoRlpEUUtDdmhkR2Jk?=
 =?utf-8?B?WVJCbElITTZEa2VhTzhadEdkUTNWKytadm85OTVnUTlNdUtqSEdTKzdmMEkx?=
 =?utf-8?B?Ync9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F581039EB8FFB143B7C6C4CE5F1A2349@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cde130d-a7ab-43b2-e0bf-08dddbc3f8f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 06:21:29.8143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07TnuyCr4zuGxv8g+kUEYZqvF+H9ccWcNMxZidIM99Y28V8PMTqDtpbR/C4TNZH35SAzxUzmi5zUD4qrKdJKEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7510

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDA4OjQ4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDgvMTQvMjUgMToyOCBBTSwgUGV0ZXIgV2FuZyAo546L5L+h5Y+LKSB3cm90ZToNCj4g
PiBBbHRob3VnaCB0aGlzIG1heSBub3QgY2F1c2UgYW55IGVycm9ycywgaXQgaXMgY2xlYXJseSBh
DQo+ID4gY29kaW5nIGRlZmVjdCB0aGF0IGltcGFjdHMgcGVyZm9ybWFuY2UuDQo+ID4gSGF2ZSB5
b3UgY29uc2lkZXJlZCBhZGRpbmcgYSAiRml4ZXMiIGFuZCAiQ2MiIHRhZyB0bw0KPiA+IGFkZHJl
c3MgdGhpcyBpc3N1ZT8NCj4gDQo+IEhpIFBldGVyLA0KPiANCj4gTXkgdW5kZXJzdGFuZGluZyBp
cyB0aGF0IHRoZSAiRml4ZXMiIHRhZyBpcyByZXNlcnZlZCBmb3IgYnVnIGZpeGVzDQo+IGFuZA0K
PiBhbHNvIHRoYXQgaXQgc2hvdWxkIG5vdCBiZSB1c2VkIGZvciBwZXJmb3JtYW5jZSBpbXByb3Zl
bWVudHMgdW5sZXNzDQo+IGlmDQo+IHRoZSBwYXRjaCBmaXhlcyBhIHBlcmZvcm1hbmNlIHJlZ3Jl
c3Npb24uIEkgdGhpbmsgdGhpcyBwYXRjaCBpcyBhDQo+IHBlcmZvcm1hbmNlIGltcHJvdmVtZW50
IGFuZCBub3QgYSBwZXJmb3JtYW5jZSByZWdyZXNzaW9uIGZpeC4gSGVuY2UsDQo+IHRoZQ0KPiAi
Rml4ZXMiIHRhZyBzaG91bGQgbm90IGJlIHVzZWQuIEhvd2V2ZXIsIGlmIHNvbWVvbmUgd2FudHMg
dG8gc3VibWl0DQo+IHRoaXMNCj4gcGF0Y2ggZm9yIGluY2x1c2lvbiBpbiBhbiBBbmRyb2lkIGtl
cm5lbCwgSSB3aWxsIGJlIGhhcHB5IHRvIHN1cHBvcnQNCj4gdGhhdCBlZmZvcnQuDQo+IA0KPiBC
YXJ0Lg0KDQpHb3QgaXQsIHRoYW5rcy4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVy
LndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
