Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B42625332E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 05:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776144979; cv=fail; b=UbznnEEN3ekWCFa4GngXKwwAnnVmPDgSeguLU/KKSxIDvqqtPYMkExLCwVpYuJM5tw8W142pmgmNiK2z121Rnm1EsjeT9T8Yfd7EbrG98j2ZZ4GUD9QZHtzuRO47rV+tW6xFUL2FlEOZfcJPUGmhltPd689yn9MTyrSzeMGEBbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776144979; c=relaxed/simple;
	bh=CsCq9hYXNjyqReVT0pZYpihSSSO0AnDVXN4tECwGOvk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h4hyMl/8aAw8SSeqN8QB1HjFA+unYCOtiUZ9306smWVvSUKTrhdeFCftrZdnYygufdSOX7QMcLCA+eIu3Bfy8YLIQs1Bl+yN4XFrd2/ou/ctgHUNUJQnDy9pcqtAiPLDNCvF8hUe3ZyTxsZ9Un9kj4bOqpUwdgRViDrrFDqmUko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kpSxEYrw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tuxJUhk3; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kpSxEYrw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tuxJUhk3"
X-UUID: d7b3afc237c311f1ae70033691e9ac7d-20260414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=CsCq9hYXNjyqReVT0pZYpihSSSO0AnDVXN4tECwGOvk=;
	b=kpSxEYrwXNBIjJoAdDTAhsL3GemcKB3ymrv3QhIrSVTuchhIuJqIaVs9fxA1phjBVHLd6C9oG6NpEZrzw7qYWVpUQ/5wPwY3gBvC7W/H+SNbZI2tEKRa8JstZYyFn4Mb/RFFfj49ORHvfTIUuqDLBYOWalnajvmz9VidK9AQDzU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5075a332-72fd-492b-af47-1ebf1fb4fd1d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:ababe894-f8ef-4ca8-bea0-143568f9ca1d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d7b3afc237c311f1ae70033691e9ac7d-20260414
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 65172993; Tue, 14 Apr 2026 13:36:10 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 14 Apr 2026 13:36:09 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 14 Apr 2026 13:36:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubqMD6L4MTzv6ED2a4Aq7kB+ytjjTS2Gy3o/SJH0mK07/tZzp8DKUA8GNWBL3fqbROthLDekWt7pnn84/ykfW9IK6XddJkbBoyJ1gKEJSUD/s+R9Q3fTz+hRIly5BGlpuc7XRMN6zENpbj34bRLA0hofqV2lNjgjs+f5rsALZKvoiSklFdr6OQZf0IeNg7WeOL1hmdJvM/QxEZhil7lkd6pWsCSjh/mHPBMDFXv6HEnvOG15r5OR5wpgXBqGg20tjI5HGXDPoT+jXyjDIS9mhhViRpqvwUFEd1Q4+M1py9a58JIFbZ5xmx/tj/B6eLtvIiPmqxSSPZM3kDyokIDekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsCq9hYXNjyqReVT0pZYpihSSSO0AnDVXN4tECwGOvk=;
 b=vnj0+ZCPXuW9mgRzIFnGLgRRMh+FnXr3uXIC2QArKjLWfvBk2Y7ouNUXze3QglP/zQ68bqLzeA5Wu42Pi1g2UpJ0TdKCzSGNg6n6kPfzJaekWTYpnlw+Koc6Xe8U2VNOT93HFhDDnO9tylRqk7PhPlxST/8DSoloB7xpgT+Q7YkvugK5Gq/kTiTmSGhHtAoWaOznfzm9jC8aXytcAaqLWzRFdnogwdCgfy9mUS2AftZty7lUUdLiQSBpfNU/aVUE43Y/oXMiJ4G6LxT6/7LXscOvJQvecGmvveN1uEvgMSYhPOot5wjpoNKmffSfDILsELjvV1deaB2TGLNAfRpcwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsCq9hYXNjyqReVT0pZYpihSSSO0AnDVXN4tECwGOvk=;
 b=tuxJUhk3NS8r8Al/ctdnncsAK8cbelx4/UVvSQIGAL+GCIVkaCZLDT2OG2spCw8A9yL5+evEe3Ty4+25rnx5goD+LatxW2Te1e/QR8Y7L0v/zFzUSJ/rW0XepxJCgZzoh3Mr7DY6qXAwgk/WT6ixb9xsJ/uuzTJjV2e8Xla+JTo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8806.apcprd03.prod.outlook.com (2603:1096:405:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 05:36:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 05:36:06 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "wangshuaiwei1@xiaomi.com" <wangshuaiwei1@xiaomi.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"wanghui33@xiaomi.com" <wanghui33@xiaomi.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
Thread-Topic: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
Thread-Index: AQHcy7VOZiE/9Rd8/UmyMJP6gMkUMrXeCcKA
Date: Tue, 14 Apr 2026 05:36:06 +0000
Message-ID: <ed8f32842f42dab0a3ef4774272b41cefbfe8fae.camel@mediatek.com>
References: <1776133204140474.3.seg@mailgw01.mediatek.com>
In-Reply-To: <1776133204140474.3.seg@mailgw01.mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8806:EE_
x-ms-office365-filtering-correlation-id: 78d5c199-cab5-44e9-bf3c-08de99e7b9b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|38070700021|56012099003;
x-microsoft-antispam-message-info: zhFdUHmEiQ9Zi088xR6WXoSuD+no00DfAUXg5o3GYO7B6ryBjXj3J6EbJutQUT+3OCKqN5y12qnryFjRPD9ZnD8aa8VELzSVpnDxa7TiSDab2C3hk6iENH/gF6Cbm320G17NlUnXKWmTzADL3wK4SkL2ia59sYvkr+jaXBB88YcxhH34hsJfCNfiz9VtYRHdVW5rm9M7wO4djvLPYk578kssrc+4g8ntIpgZMIXDZXv1Zx1OHxhxp2slxey9cY2ulkDcTUNbn7DCAXyKctC3/3QPF+4RWf2J3I8BBzE20Q8a6Dpsc32mOM18Is441q7UiMzxSKlDpDtNqXv1orL0U65Feg4l9Q3txGwbof0g6LRev+hLDDVKrGjD37g9kB9nV9nwZH6GuflbM+qzJSOFtqBXPwvVxQguXuQqEsreBe/3l/Zley3AfcDKhD99kMWVc0FfWuIKRzv6YhV7eM2O0YrLTiouEcsXAnVc+DFL+hw4DMSwtxb0krfeTFqEexq4QCDPE4K3sPAjId3IOMVH7zTcAP/f/+9vpe8bmMK8CKXjGZX99n1UrItKi2lL9hVtVR/Uf16b5kepFYfXcs+XZ6j+nb3BC4d33fIsYShpZvy6nHABotEuEGlobxG3N3FkEv6nfL6jR1J2+5ueeU9ULeV48KlkeMhQixvhRaADVu/k9Ysv8xInoPJE3ZOm5QSPCeMFe4E/tqSuAHIB/Tlligd1MZdbTMEbG38E5b1fQjFcR26ZVh6Lc2ZuAbKTlWdsA0FRUAgghGhzKxvNdRLYG1/bPxOFf4caxMgYyhTAry0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(38070700021)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3lsZjV5TzJiQkoxSmtTVFRsdWJxakdoTkZiMzBWR3pLb0syVlYzYnRNZk9m?=
 =?utf-8?B?cWpBRDRBYVJwM0w3ZkIzVlAzOTYwY29Rb2hOMDJ5alFST2NBaUNwVE9FeWM0?=
 =?utf-8?B?dmhVY2VzK21hQStqbjZ2SFp4Y1Nmc1dqVS9FRlovbGx4c2V3U0xJNjR2TzJ3?=
 =?utf-8?B?a3o1aXJueGRtVVJtcUpaSzlRanN0dE02Mi8rMnRJNS9nVUJ3UWw3VlRlK3ox?=
 =?utf-8?B?YjNEbkdodFlick5mNS9iY2wvK2ppVHMrOFZCaEFVV0N3Y0l5RHkwVnBOVVc1?=
 =?utf-8?B?Rnc4WEdzMzZIcUVtOGx6UjF6UEREelZLWE1EVjdTeVpKMFRPYVY1RFlZcHU0?=
 =?utf-8?B?YTh4c3NZTWtoT0xTTEc4Zyt1VkhIeHZib3RXYkRvdWRpT2FMeU1wRzAwbEww?=
 =?utf-8?B?YXQ1WmpBOHVUMDdFMzRWUDlRTVY0ZmdzVFdXbUJ4TzBEWUhyT2VWTUZ4SzRU?=
 =?utf-8?B?OERwMWdrRzY0a1VWNVJ3dHZyL1pwcXhXOG9nZ255a3VZdW1pWlhXdUEvQVBM?=
 =?utf-8?B?RC9oMGR6cG9sbk9CRXlhcURpSEd2Z2lna3RqdXVGUXI4ZUx0eE95L2pXNFZk?=
 =?utf-8?B?aUJDVWswZU9LL042NFJnSzJHVllXamE5WjZhMWxlZkk1czUwUXd2L0NnUUQy?=
 =?utf-8?B?bmtMQXBRdlRqbXJGRUIyZUVPalBxY3gvaVRJMklORnBoTyt6L2RVUklRNUdP?=
 =?utf-8?B?Yzl1dCtZdUJPMzIxcE1TMVkrMkRxOWFuNHh3MGs3bngxb0tXck95eHZML2VI?=
 =?utf-8?B?RjdDeVZSb1RvYzZqazlXZlFSZFhna2lvSUFmTkxvNGg4eVNPSUUwZ3VHSkJF?=
 =?utf-8?B?eE1mZnVMWHQrZ1U2eUdhdzBMaG85Rm9nRklZMzZmeU4vU0dpRmhDeUVYNmR2?=
 =?utf-8?B?UEJuZGRqck84V01MdnRRRnh6OWRNQXVlODZjbjAyMUVkTytQV1dDL1VVQXZW?=
 =?utf-8?B?VDJ4ZHl5SXdjM1F4aHpCUDlhenpWM0pNMDNsaitqTGE5NmxJU1hxWDhTNG5a?=
 =?utf-8?B?bTBvejF6QmlIZFZLZ1A4Vml0T3EyL01oSGdkZlBJd2hwT2lPY3lob0dYdG1h?=
 =?utf-8?B?VEd2ZmtyNmNXYzVaekQrS2lFZ1d6OVVud1lRTXJXSkhOT1VzKytSMWlvL1Zu?=
 =?utf-8?B?SXRSakJCRDhBWHo5YTBMSlRHUmlvbTE3UnRSalhnQlRXZlpyaUFWNHEwbG9F?=
 =?utf-8?B?aFdnUmpIVGZBQm5KbFpTV0NnYUFkZTgxOEZ2aFJXVXNORFBseWdseE5xMk5h?=
 =?utf-8?B?YzRORlhjdFc2enJLNENubGJrWGJuaTB5MmM1cnlrT1JnKzMyTjNIcHk5VlYz?=
 =?utf-8?B?V0FtUVRualpGakNFSUFIZXQzSnNuT2RndFU1NExCeGxHZHF6L2RWK05PUlE1?=
 =?utf-8?B?MjF5MHd4bTJ6Ty9ub1NCNE53TTRicmR3YksxMDZES2JUM2h0V0l5WEJ5U0E3?=
 =?utf-8?B?MC9uRm9Jc01XdEw5dDRRc0pYUS9GSEVEOGZERDVaeUtYcDAvckhVa01ZTlZj?=
 =?utf-8?B?MzdTMWRibHR1VC9mZ09vazYxM0dmeHZESTB2bDBYbWo2enQrY0h3bW84MnBa?=
 =?utf-8?B?NVNrNERiRHV5dWc1bkdBQkhSQ2tYRkdDZjJJV0NzSFhHZG5NWW9USHpYc0hD?=
 =?utf-8?B?RWN6blYvNjZYb0h0WEVyT3JIYWFQZnRFS1JUeEhvRkdrSEJ3ZFBoSHF0Um16?=
 =?utf-8?B?WjJPRTd6MG9kTHNPNlhVVlY2UzJNakRjNlNtT3NXZGx5TXp2dC9qcitkcXRp?=
 =?utf-8?B?aUp4RzlTbVBHMnJJb081cXJuUEhnRmhyYlZ2NzlYeFBqVndkMmlUQ0ZVMTJC?=
 =?utf-8?B?UERlZWtNbVdUZStGN1ZWUlhPY0R6T2FLNkF4TUUwN3A4bEpSNVZFSzl6Vm9X?=
 =?utf-8?B?aXMyUVNPVzgzcCtZa0FLeG9XTVRUYmxpS1F6VzRsa0VYSCszcXZ6ZFEyZC81?=
 =?utf-8?B?V0p0L3dFK1UzRGpCTG5Vd2hjZnJUbGc0NXJ0d1gwUXo4dzZPOUFJbUZ6TGZ0?=
 =?utf-8?B?WEUwSnRqaU9FSVQ1SFpsSG1UYkN6cjZsdFBhU0NnSG0yZnhZRTM3UTE1aWRa?=
 =?utf-8?B?UTJKaGZNOHB2WmM3TWNvOXhtbytFQklha2psYmlHNGFqek5uOGhENWF3cy9r?=
 =?utf-8?B?dHNKWE1OVjlCcHNnbnJiQlFpcFUxdnNuWWxLWGdTQ1VSLzhQSUIxem8yUjNt?=
 =?utf-8?B?OC9lL0FiN2JNdzdqN0E4NHp5RXR0YTdTV0dBSFZPa1JvUmJncnpjeWtEWXFy?=
 =?utf-8?B?RXYxVHRjV3V2c1cwa3dDbWtpYzVKakp4YlBlakF6OWs4aXkzSUxYd1NnR2xB?=
 =?utf-8?B?TjFBeHFYaHJzdFQ0Slc1WHQ5VGc4U0kyRE8zTzFkTG93NWV3WU00N2VEd2VI?=
 =?utf-8?Q?zgVQbGVLB2t+SS8g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E310B9F19823324DADD515CFE5FD01C1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: IkFRqstVBMzhOM31sAP14rvGF0KechawuyQ1tyb5WvqdTmJtPieWmGki2CsUN9+dS4uR16dDp6KYqyhEh5qyU8E440f2exceqR1ESI0xsv2XFyGvsSLJxEX7jkX2Jln0cPy2zmkOtoqxR72Zl50uroNq4f11qTofNa2/I/ZmZfvt1/G2BdtS6amBOlKPG9kfdQdoEOX8ua61X1YhQOHSN0esEh7aNs2g5PpLzrWLqAbUQz5rqCEWTnZ6PX9LbpWkPZYJ3q1BtLNSKmH3m9+0I14/a/7nVD5VAZGxO6ftZc2C4CJwObqgIFHiR7LnbxSmYX1RZLZ3693u3bTYnIqbMA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d5c199-cab5-44e9-bf3c-08de99e7b9b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2026 05:36:06.5104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T91Bj8EEm8edt5hm8czKuyt9Vs8k6beGVQZGEPgpvJaQ1QJJZ8SN9Uy/g+JWN4zEDwiKRbpPlg5oeS3P2lPxdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8806
X-MTK: N

T24gTW9uLCAyMDI2LTA0LTEzIGF0IDE3OjExICswODAwLCBXYW5nIFNodWFpd2VpIHdyb3RlOg0K
PiBBY2NvcmRpbmcgdG8gdGhlIFVGUyBzcGVjLCB0aGUgYlJlZkNsa0ZyZXEgYXR0cmlidXRlIGNh
biBvbmx5IGJlDQo+IHdyaXR0ZW4NCj4gd2hlbiBib3RoIHN1Yi1saW5rcyBhcmUgaW4gTFMtTU9E
RS4gSG93ZXZlciwgaW4gSFMgTFNTIG1vZGUgd2l0aA0KPiByZXNldG1vZGUgPSBIU19NT0RFLCBp
ZiB0aGUgVUZTIGRldmljZSdzIGRlZmF1bHQgYlJlZkNsa0ZyZXEgdmFsdWUNCj4gZGlmZmVycyBm
cm9tIHRoZSBob3N0IGNvbnRyb2xsZXIncyBkZXZfcmVmX2Nsa19mcmVxIHNldHRpbmcsIHRoZQ0K
PiB3cml0ZSBvcGVyYXRpb24gd2lsbCBmYWlsLg0KPiANCj4gVG8gZml4IHRoaXMgaXNzdWUsIGlu
dHJvZHVjZSB1ZnNoY2RfZ2V0X29wX21vZGUoKSBmdW5jdGlvbiB0byBkZXRlY3QNCj4gdGhlIGN1
cnJlbnQgbGluayBvcGVyYXRpb25hbCBtb2RlLiBDYWxsIHVmc2hjZF9zZXRfZGV2X3JlZl9jbGso
KSBvbmx5DQo+IHdoZW4gYm90aCBzdWItbGlua3MgYXJlIGluIExTLU1PREUgdG8gZW5zdXJlIHRo
ZSBhdHRyaWJ1dGUgY2FuIGJlDQo+IHdyaXR0ZW4gc3VjY2Vzc2Z1bGx5Lg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogV2FuZyBTaHVhaXdlaSA8d2FuZ3NodWFpd2VpMUB4aWFvbWkuY29tPg0KDQpIaSBT
aHVhaXdlaSwNCg0KSSdtIGEgYml0IGNvbmZ1c2VkIGFib3V0IGhvdyB0aGlzIHNpdHVhdGlvbiBj
b3VsZCBoYXBwZW4uDQpPbmNlIGl0IGlzIHNldCB0byBIUy1MU1MsIHRoZSByZWYtY2xrIHNob3Vs
ZCBhbHJlYWR5IGJlIGNvcnJlY3QuDQpXaHkgd291bGQgd2Ugc3RpbGwgbmVlZCB0byBzZXQgYlJl
ZkNsa0ZyZXEgc2VwYXJhdGVseT8NCkluIGZhY3QsIGlmIGJSZWZDbGtGcmVxIGlzIG5vdCBzZXQg
Y29ycmVjdGx5LCB0aGUgVUZTIGhvc3QgDQp3b3VsZG4ndCBiZSBhYmxlIHRvIGNvbW11bmljYXRl
IHdpdGggdGhlIGRldmljZSBhdCBhbGwsDQptdWNoIGxlc3Mgc2V0IHRoZSBiUmVmQ2xrRnJlcS4N
Cg0KVGhhbmtzLg0KUGV0ZXINCg0KDQoNCg==
