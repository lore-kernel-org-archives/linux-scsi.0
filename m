Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6AC13C90B
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309867; cv=fail; b=lZXcPt9G2NyIWqYqbBn9GIlb/VYvinqhucDAkj/rF6a8dFOVJ1WlKLxW/u7Qpv7yMfDraabXgVBpHrAoR2lUF41M7vm3i6jlnJYV48KZIoy6C+LAt/sppSQPxtWLoGH3aQTnLpsyPSg9JDaH41C/A9j+tltOZlkBN9xFnyKcqPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309867; c=relaxed/simple;
	bh=PrgOgTF/2NCPcx5yZ0f79b6OR6q1018Ap0cK8WwHJBw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JGs7blZPaNtpfjcrARKH8o3dHpcoC9cmskMLLutkkhxgemWbAvReQfmysw5DQwx2ZKJ7HDp448pRA7vg2ume5b4kkeMchidSaZ/CRREmp+KTPVEaOv6KDDnSmxhKXTELwTrw5vCczhffXJFHo6s8vHR5UYBJYFUj3DIY3Fk5cgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dll6cnmB; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Ci4n3YKg; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dll6cnmB";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Ci4n3YKg"
X-UUID: 463923a032da11ef8da6557f11777fc4-20240625
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PrgOgTF/2NCPcx5yZ0f79b6OR6q1018Ap0cK8WwHJBw=;
	b=dll6cnmB0KNr41wHag6cWOR+YNq8I3/A0cRNUyOW6NedVUn/bmJiNT5JvYVjugFtiBfTDHhy+dT7+DbR3FFTtgRvg4W4DY6Sl/aoy+VVbfuOu1tRlYEhBHV+hLMjLUHwY2EskUv7iWbMtPRMmnqYPWDixTH5AAsg2vl24OE7Cj0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:491cc423-224d-454b-bb67-a7cbc9fe3bc6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:02d68285-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 463923a032da11ef8da6557f11777fc4-20240625
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 499768563; Tue, 25 Jun 2024 18:04:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 25 Jun 2024 18:04:12 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 25 Jun 2024 18:04:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9bsseBqeBoD9JzTO0Oxeja4hVRKL/vDOkz9PDq4xPIxzmWjfdQZzk69y6kEzLA/2kl3ge8aLSe5MUSbSSdZRgqvLruAai1JYwj8696wvMEp8NdZKGV2HlIuSV6Bi4BoKzy8/3e+oUJivLl3XSDJaZvSYcCg6+vxzzsKvJ5Py23gNNw1XOlmLOCTer8Uu100d37JDrVzRYiujws8sFBVjf9QNv2SMtU8ROyVXz1omUL24EKqsfl62Pbs/mt46G9WZkgfABki5rEtJO97n7T9yqik2SM7+7tV4gKzq/lTRuOcjOXrIfVPp917mKrZZVmTgs/y21gwISvWZPp//qMkqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrgOgTF/2NCPcx5yZ0f79b6OR6q1018Ap0cK8WwHJBw=;
 b=OHk3NZnNP3YNO4VoVfdXZivB4dPokwioTUXTvP91To4BS19dAsvqoO9qpxjo+ljhISI4QdpVM/fIGqU4+ySVbGiKoSN37TnOakiFI/vX068Q7i4fRxPhliONzePycedu6DHERkOx0VoHWxZ1EmH/nBxdMc8/yBeV7jTaFAEkhhqHCOKvqA1I35grnuYccVNcQ+9jcTwLybhLLoP9kqpJyLh3TBHNsSyOHfou2c3SvIOCgSZJ4aYLv4U2GMzlS2QTG9xJg5EzSUqCVfFcLQmWv7Y0GnzN92ksEpekDvPRVkYyCgoxdQoKXR3ILhCHzGdGUWz99uGk/5gFeTTndcEyyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrgOgTF/2NCPcx5yZ0f79b6OR6q1018Ap0cK8WwHJBw=;
 b=Ci4n3YKgUzAWHGQMsEH/1Ggwx/EV8BQd/UAmQyErG4KBYzefN0tr15IbhwBW3YO5RZyR7bn2xSvl7creq6ESZG5SDKO8RkTLrX9lwXfoxVayY72uOGuqdFnlFIxlu5TOQXoXIyYMVG71PLkKJSGOdfQcuvASS9VinDI/O7QV2sE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8659.apcprd03.prod.outlook.com (2603:1096:405:b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 25 Jun
 2024 10:04:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 10:04:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Topic: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Index: AQHawPrEvEtR2PxEBkyAfPJ3MA8LCbHRzdSAgACvsACABCixAIAAnAsAgAEJ1YA=
Date: Tue, 25 Jun 2024 10:04:10 +0000
Message-ID: <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-9-bvanassche@acm.org>
	 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
	 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
	 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
	 <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
In-Reply-To: <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8659:EE_
x-ms-office365-filtering-correlation-id: e129164a-c1b2-41f5-b14c-08dc94fe287f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?TjFhdXE4YmcvamNDNExOcS9rcHpIYjVaOTArSGx5SElBbDdMS3VJdTVhd0xx?=
 =?utf-8?B?Mm9vVXNlNE42UTRRLzFHTkJkZXIwazMrL25DZDZGOU51TE9GVDRscnhtQUFo?=
 =?utf-8?B?dmtJSGR5Y25UWDlEdjB6VHI2UytvQ3g4ZmdMeUR5aUh2amVtTDhkVFB5bkZh?=
 =?utf-8?B?OUtiRFFMVkNDamwrOER3b3JaTVVGL0NySmlqNlZRbGxKbkRwdy9UTzY4NVhy?=
 =?utf-8?B?Wk12ZGdpb3kwQ1FoOTAwR1ZCaFJERGZ4UWZLM202Um1DTE9XQUw0YTM2UTlh?=
 =?utf-8?B?WTM1NlpwUWVyM29hUDlocFkvRitubUpnZjJwNDdIL2hMSGUrTldwT1FEeXV6?=
 =?utf-8?B?WnFNSnl6cGE3TmRZTVBIQ3p5cU9uUmpTNnRna0xtWjN2b2R0dXZ3bk8vb3dH?=
 =?utf-8?B?Y3poejhuSWFXeG1EdUNMMWlEMllhbTgvZ3daODBQR1lzNTVIdDN4WlBWSHd3?=
 =?utf-8?B?MlBsc2tjRkRJamF5S3laUk9xQkdQNVdnNE5WN2sxb1o5cnJjYkZuSnNLbjc4?=
 =?utf-8?B?YThaNk5uWDdHL29XUkpPc2ZiaGdSNzN0WFEwZ1BaM2sxWWM3QmM2Z0w0R1Bt?=
 =?utf-8?B?SS9PdjNHNEtnZjhteTUycUpQRzM4c2RzZmJCOEd3VmwwVjd5S3FpK0JKejZI?=
 =?utf-8?B?SVd0eXZhMTlmcThZdUhRaFVEL1UxTlVDTVJBYXN6Nk9ldTRKYnFaMm1nSS9Q?=
 =?utf-8?B?c1E4R1dwUWNvVlF0a3N6QVhxTzJnNTRvWjdHVFBTRVBtenFGdVhiakd3NWJY?=
 =?utf-8?B?ZSs4SjB0d3NLemc3V2daekJ4VCt0aGJ5U2VjTUxmemdpcW15dWVpUHlWaVlJ?=
 =?utf-8?B?ckxvZUErMHNYVWtFZlMyNjVRU1VkcDlCN0NFSlZoeXhhajBrUDduZEw4NWY3?=
 =?utf-8?B?djRTNTliMFBmTjYxVk5wWGZ4b1NiZml1cmFjTHk1VWgrcWpWaUtwVC9WcGFC?=
 =?utf-8?B?ZTg2TS9xZXJHU2ZaSHpwUmR4ck9LVTJZaEpMOTBPT2JPVXBGRW1ZdkNEOEMy?=
 =?utf-8?B?UU9WRWh4cjBBOUFnMWxNazM0UU13ZGVSVXRmdUVlVmNObTZ1T0lMOVNwVGlU?=
 =?utf-8?B?YWowVXZKOUkyVHZhNlRMWnpjT2h6Z1NCcHc5MlNLMlFkdXNBLzdKb0lGb1Zk?=
 =?utf-8?B?VU5OQkV5MXlHTHVoTGtIL2xRVHczU2Z1TFFTY3I0dHBYSlhiWDA5N25SdmF4?=
 =?utf-8?B?MDg4Q0JPMVZaUTVwZVBRaVRKd2tsODVFT3JzTWg4SGJaejRuNlptYkdnNnVD?=
 =?utf-8?B?bVRRN05tQlovNVBLQXBSWjFNTnRPcS9XSHllanczbGhBazAzak1Ca2dROGJB?=
 =?utf-8?B?K204aEpPRWV4VTFBMHYwZFhtTEdzTVczb29YUDV6b1FtU2hQK3R4d1BxYVRo?=
 =?utf-8?B?Tk5LWWpHdk14emZUYnUzd3paMDhRY2c4U0RjaThpV0dDaGIwSDRXVlVDTjMv?=
 =?utf-8?B?WXJsMHFPOWFZM0dRbFJzZmVLbEpsMFJEOVNBS1FVdE5lek1uVmxPdnQveUZ5?=
 =?utf-8?B?a0VJdytzZ3JYUStXTXByZ2pBbFBubEUrREJhcDdWN292dnFNS2VERnk2YjZ3?=
 =?utf-8?B?RExFSmh0NHZtdGZ2OXJpOVZYSU1oRWM4Sk9tdnFJYTl6Ymw1YVF0ZithR2tB?=
 =?utf-8?B?dHVlYUVSTWtzMnJzeHpYcE9mOUNyVHdCUFVKQVdxbThjaHE0bVhKM2FSZ1h3?=
 =?utf-8?B?dU96TC9nRWlkcUQ3bXdJSVNlL0FOT2t4UUFvSmJ2aG1vWFpoNjBXZjFOcVpk?=
 =?utf-8?B?a1doZ2tWeVZPUEwvTCtMcm1UMXdzRndYb1crMVFIakdOY0pFL09lSWhZK3Rs?=
 =?utf-8?B?VFYyTlFTcnlENXNXSmhYTWVGRlFGMDZ4VTFMYU1ua0tYdFZBVGdVOThjMFAz?=
 =?utf-8?B?Y1V3YXJ4UEFNeGhYQVUzcUJLQTR1MlB1bGJRR1gyUkRQWmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHdHTUpLZFdvektFSG4yU1hUcnNFVy9NcUxDek9JaVNVN1JXWTNPalhNUEZV?=
 =?utf-8?B?NDdZOWp3WjRJRWh6cEUvWlBtenRrWE5BSkx2a2tJSkRYandkR3pDbzkwbkg0?=
 =?utf-8?B?Ri8yMmZvL1RuUHdITEp5SVVUaS9acmV2VEhnRmRqYmxwR2VPQzgrY3lCMmpI?=
 =?utf-8?B?azJaRmVBeFN4Rzl6c1VaNk9BR0NIczJXaHJEMEF3dkRKY29KeGwxOHFVWUFM?=
 =?utf-8?B?Sk1uVlUrQTY1MGhqM1V5NWxxakRjSEh1SWp0NUc1b0ZJYnpCZHE2cDFDMEFU?=
 =?utf-8?B?WUZxOUxZY1FUZ1JLc1dvZFFiNzZaZFM4ZFdqRUpVUnpJNkltM1BlNVhBaHZH?=
 =?utf-8?B?MjR2N285OVovQTI2NUUzTFNIdUtvRzFxZ2V6YUhtRU5JcTVsMkJwdkNCcENs?=
 =?utf-8?B?bTZGaEVQNlkvMlVaWUhWdFFYVTViVFJzUWJzb1hHaUxKYStFVU1ZZm8zVDZw?=
 =?utf-8?B?bndURnFjbDJVM2dSd3BHbHEyQlFoTjJMbFpoT05OTi9oL25DSEhwZStqUWdI?=
 =?utf-8?B?dWpBbjZEd1Q5OTcwbGdJbHpFZkI4bnZOdTJndkx3L3hWWjBwMmpVQ3grM3Ux?=
 =?utf-8?B?NDRwck9yVzladXFLS3dyOG1OT1IxWFhUOWhmSmtyNzd2YzE4U2VObmxsSWRR?=
 =?utf-8?B?M1lxbERiUDZXRjE0Q1NrV01tVVVVd0xxVWowNThGVG5kYlZQM2EwbEtLYVVP?=
 =?utf-8?B?aGZHbHlEbm43YU4zK2JtaVJld3RDUkJwUlAxTzB3Q3lZL0llNC9aWC9XcWh3?=
 =?utf-8?B?ZlYxY0ZNTFpNUnBuTGpJYWZHZExlS3U2S3k3QnM1eW50RUdKS3JNbGMyS1Bl?=
 =?utf-8?B?U1lDaEl4bHJkZXFqL2pRUmdqNUhuYkswcmVzVFZMeXM1Uy9tQndGV0NDR2d2?=
 =?utf-8?B?NXEySHNoYTVBL3h3MzRxdVMrUkppVUdtbGF6UFhqQWlsK3Q0anBZVTRRN29P?=
 =?utf-8?B?SnFMbXRueTd3cmFYRVBBN0h6Uk5oc0Z4UWl1cG41NUpVR3N6LzI1NVJ5eTJO?=
 =?utf-8?B?S2Ftb0NjWUIyQjlSSHpvV1JleWFtQnY5ZEFCSW1TZGpzOTcrajFGRTJIVisx?=
 =?utf-8?B?eC9ITTVvMnB1WjNPZEFkUlhxZ0toZ2EyOUYvcFhnb082Mk1zMXpwbVVzRzY4?=
 =?utf-8?B?d1VEUFhwQnJtbnZibmxEcHlJWTVVajFDMkp6RllBT3dBNUFqdDg0dHFlUlN3?=
 =?utf-8?B?K2Q3YjVNK0h4dWFXZWI2SVVnZzZwQzAvRG1NRFRPUXJBY0ZlQ1R2SjZPUmhE?=
 =?utf-8?B?dkNuNXExUkE5Y0Z2eVFjQ0gxcmpMMFduVzJiUUFjZkNXSGtKc2IxY01hZndl?=
 =?utf-8?B?eXRCYTZwR2crMkYwY3h0eDY1Mi9zSnhHOWRnWG5IQ3Mzb1hYd1VZQWE1VEh2?=
 =?utf-8?B?ekdwaENYYzYwTFJTKzJpNkZUZ3orblhFdmxUeUs5aFFrazBZQXdGZDJNYTVJ?=
 =?utf-8?B?OWZxWE45Q2V0cjMzNmtKUDJtdmRZdWowZ0tsTGxzK3pZbVdMcGNKSjdoSURF?=
 =?utf-8?B?UXczS1QrUW40aGhic0J4T05hcTRQc0pWWmNyc3BrcFI2UlluUzlPVU9BRGht?=
 =?utf-8?B?R0tpS1JNS2x1STdBTUgvYjB5NmVabTRTNnFFV0pVTE9sWHR0ZHdBUFZETXA4?=
 =?utf-8?B?UGlnSTFIR21PUmgxQ2xsQ2NMOW9ZSitnYXpwVHhpdHBGZUd6RTZvVzhSdVRp?=
 =?utf-8?B?M2lIMGkzeXNtNFpMYTcyMzh1dlpjbWJPcERPeTJzNlhVSWFrZ1RGek1jWUJl?=
 =?utf-8?B?NVNrMUxFWkhlS3ZCRE1IUnZYNVBPUEhCMVhWRm00UHFNL1N3WFNVUkRSODhU?=
 =?utf-8?B?YnNtdjlKN2V0THhpakwzRm15eFJlYnVNcVN4ajZSaWRZWmVwcEJaK2dvU1hC?=
 =?utf-8?B?QmtuWW5kTitqRXV0SFRLbFdKUFFQUVBuT3F3K1ZFbVUxVFdYTFZHODJxSmFl?=
 =?utf-8?B?U3RFUDBRdmluNnd4UmVsUXkwOHg5K2NNbHVqR1Y2SWNyTHB3NDRZc3pqN1Yr?=
 =?utf-8?B?R0FxQ2d2bm5PTVBNS2IyU3gyVm8vQXg4U2xoWGk5WGd3djRnc3VZakRCVXpW?=
 =?utf-8?B?UUFHQTQrOTBVMm9ncnR3WHl2WE1VZC9wd0FZNlYyYzBpMmUxa1FPdHl6YTBK?=
 =?utf-8?B?dWdmTDQ2K2ZNbFk4a2lmRzk3dnB5TUR5QzJONnV2d01NaEx5MmF1YXk1ek5F?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4F6DB78463B4240815239A39E69236C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e129164a-c1b2-41f5-b14c-08dc94fe287f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 10:04:10.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YIxyKkFjcAqLU3sjgEbNlNo/dRxM5z/aEI2xyZhw7Hjiwmpz6mMnSlkawu9To7Xbpw3DR+TNa5U2O4c6Wvm6KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8659
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--27.089200-8.000000
X-TMASE-MatchedRID: Q8pJWSpPf0PUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzOo//J/EA1QauZoybwHAwkKl/
	RUlmGXE+Q6fcASfcYduzHVbJ7/tTriCiZZOL7oZ3J5W6OZe5hhSGlZBSK0BYbhfrrhbqMw+ITXg
	8Fm61gaYvqKnFoQ8g1Kj/QtTfNo3M3H58FR5tDSEKcYi5Qw/RVUAjrAJWsTe+1FeFXyekgdN0Jh
	9Xja3fhsJpA2tOCzA8R4ezsIKMERxoeu+OCiwrSngIgpj8eDcDBa6VG2+9jFNQdB5NUNSsi1GcR
	AJRT6POOhzOa6g8KrZRMZUCEHkRt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--27.089200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	EDFB86767169272FF33D062230F062501A4DCADD1E8F928F624DE9C8544617082000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA2LTI0IGF0IDExOjEyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yNC8yNCAxOjU0IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IFlvdXIgYmFja3RyYWNlIGlzIFNpbmdsZSBkb29yYmVsbCBtb2RlLiBC
dXQgSSBhbSBjdXJpb3VzIHRoYXQNCj4gPiBob3cgY291bGQgaXQgaGFwcGVuIGlmIGNvbXBsZXRl
IGEgY21kIHR3aWNlIGFuZCBnZXQgbnVsbCBwb2ludGVyDQo+ID4gbmV4dCB0aW1lIHF1ZXVlY29t
bWFuZD8gY291bGQgeW91IGRlc2NyaWJlIHRoZSBleGFjdGx5IGZsb3c/DQo+IA0KPiBTQ1NJIGNv
bW1hbmRzIGFyZSBjb21wbGV0ZWQgb25seSBvbmNlLiBTZWUgYWxzbyB0aGUgY29kZSBpbiB0aGUg
U0NTSQ0KPiBjb3JlIHRoYXQgc2V0cyB0aGUgU0NNRF9TVEFURV9DT01QTEVURSBiaXQ6DQo+IA0K
PiAkIGdpdCBncmVwIC1uSCAndGVzdF9hbmRfc2V0X2JpdChTQ01EX1NUQVRFX0NPTVBMRVRFJw0K
PiBkcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jOjM2MjppZg0KPiAodGVzdF9hbmRfc2V0X2JpdChT
Q01EX1NUQVRFX0NPTVBMRVRFLCANCj4gJnNjbWQtPnN0YXRlKSkNCj4gZHJpdmVycy9zY3NpL3Nj
c2lfbGliLmM6MTcxNjppZiANCj4gKHVubGlrZWx5KHRlc3RfYW5kX3NldF9iaXQoU0NNRF9TVEFU
RV9DT01QTEVURSwgJmNtZC0+c3RhdGUpKSkNCj4gDQo+IEluIG90aGVyIHdvcmRzLCBlaXRoZXIg
dGhlIHJlZ3VsYXIgY29tcGxldGlvbiBjb2RlIGlzIGV4ZWN1dGVkIGJ5DQo+IHNjc2lfZG9uZV9p
bnRlcm5hbCgpIG9yIGVycm9yIGhhbmRsaW5nIGlzIGluaXRpYXRlZCBieQ0KPiBzY3NpX3RpbWVv
dXQoKS4NCj4gT25seSBvbmUgb2YgdGhlIHR3byBoYXBwZW5zLg0KPiANCj4gVGhlIG9ubHkgZXhj
ZXB0aW9uIGlzIHRoYXQgLmVoX3RpbWVkX291dCgpIG1heSBiZSBjYWxsZWQgY29uY3VycmVudGx5
DQo+IHdpdGggdGhlIHJlZ3VsYXIgY29tcGxldGlvbiBoYW5kbGVyLiBIZW5jZSB0aGlzIHBhdGNo
IGZvcg0KPiB1ZnNoY2RfZWhfdGltZWRfb3V0KCkuDQo+IA0KPiBCYXJ0Lg0KDQoNCkhpIEJhcnQs
DQoNCkkgc3RpbGwgY29uZnVzZWQuDQpXaGVuIGVoX3RpbWVkX291dCgpIGNhbGxlZCBjb25jdXJy
ZW50bHkgd2l0aCB0aGUgcmVndWxhciBjb21wbGV0aW9uDQpoYW5kbGVyLg0KQm90aCBwcm9jZXNz
IHVzZSB0ZXN0X2FuZF9zZXRfYml0KFNDTURfU1RBVEVfQ09NUExFVEUsICZjbWQtPnN0YXRlKSB0
bw0Kc2V0IFNDTURfU1RBVEVfQ09NUExFVEUgZmxhZy4NCnRlc3RfYW5kX3NldF9iaXQgc2hvdWxk
IGJlIGF0b21pY2Ugb3BlcmF0aW9uPyBhbmQgb25seSBvbmUgY2FuIHNldCB0aGlzDQpiaXQgdGhh
biBydW4gZm9yd2FyZD8NCg0KQlRXLCBJIHN0aWxsIGRvbid0IHVuZGVyc3RhbmQgaWYgYm90aCBl
aF90aW1lZF9vdXQgYW5kIHJlZ3VsYXINCmNvbXBsZXRpb24gaGFuZGxlciBzZXQgU0NNRF9TVEFU
RV9DT01QTEVURSwNCndoYXQgaXMgdGhlIHJlbGF0aW9uIGJldHdlZW4gU0NNRF9TVEFURV9DT01Q
TEVURSBhbmQNCnVmc2hjZF9xdWV1ZWNvbW1hbmQgbnVsbCBwb2ludGVyPw0KDQpUaGFua3MuDQpQ
ZXRlcg0KDQoNCg==
