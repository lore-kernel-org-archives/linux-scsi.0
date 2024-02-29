Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A8C482C3
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 07:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709193182; cv=fail; b=HDWhssIdEEON1PouYNiW5WQFfVZFORVKGq0qW8jVJPaZ/ljVJ12QD3zMkxbpR7jgwpMy4XhWmiXsGQfR2U/easYJ3LY7Df02yMtxHNFSYFPnw8SjkoSTS8sCssuFf6ph6nCZJrDkOPj3oVVbGpwcuLvdt2O0Ny7Z2kUo36oQF7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709193182; c=relaxed/simple;
	bh=XhaOv1dxcVkpXI9SK4HJcTyXumTn6OEjKEZ7HsO+4ls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FlFD4oBOymHSJPpExtgFInDy5XNbp2RNjt/jIujVOl51TZ+se1C3bByxlQZKtc7TO4YUUTJLWYKx42tpXO7uMuawES4mgyCIJAJHV++DEIogO1x/SQ0Nw5pXdWPJls/ssJIyg92BrYeoHuQdKr+ppXs3CgEJ1CIMJGAauno/f8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oRXZ8eGq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Z2PLdBk4; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oRXZ8eGq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Z2PLdBk4"
X-UUID: 8b72084cd6d711eeb8927bc1f75efef4-20240229
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XhaOv1dxcVkpXI9SK4HJcTyXumTn6OEjKEZ7HsO+4ls=;
	b=oRXZ8eGq27XaFM/dkQb/vA+7vzYT2ki+EwGzTFK6uJTXlSDzIKfeorivBpj+RSDCBeNurXkuOzfl2PoZo44qMf6PH5kY7VDP9FCfbuH9r4Omdh+YDuFMb09Fw03zg5rfuMHcrxh6yyRMJSCXKk3r5rJuXPf7N66P4do5lVZmGjk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:d144cf8c-eee8-4e75-94ff-3191f23a66bf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:427756ff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 8b72084cd6d711eeb8927bc1f75efef4-20240229
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 556938974; Thu, 29 Feb 2024 15:52:54 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 29 Feb 2024 15:52:52 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 29 Feb 2024 15:52:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvdAIB3sExz51j3LzE763AdjiFYB7sseHLaD+nx9eyhKV3Z8XA3MAqIe+zPaJNLRC70rXSRULAj4GNg7aw81y1qfguiQwc9WJCHBJQmDxhr2WRIOMVE5zhngFqyizm9WAXLAxIKNhU5OFxF0SKpzWkjYpSQZQee1Q0c1Jh0Zg4jbLfwliWlM7pAVyon9TLMeNBsTwNx2BhYzpp1h2Oj6VF1n+5vBHWkPjG220rywIvjPNicx6mepdORNWIlwKAI5C51jqOupqoRd7oX7glF5y2WX/GsWvipAM72P4kBXH5Ro3G08I/pDpezq23jucbhjyFauIg+Xiy0R/U9FlwuHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhaOv1dxcVkpXI9SK4HJcTyXumTn6OEjKEZ7HsO+4ls=;
 b=Jf8PUbMZgcuc5iS9OIGTul9BudkuNXi4NBS2YKHsVbiRU7hqkEHbrC8Tar+lOki0BULdWaRMAFKOpGBRyNoH+7X0wyLDa6/Hrt9fpgKAi8oCG5QmMQSpJ8alEZGbCXqnTqkXCKLAzPokpD8f1Johs//sWjH1EoCn8h1oCUUxahZ3e8gKP8x5LAjmniWsSu5/huYuK5EDz5K+goBjMkUWzgn8s5Pmrwg4IUt5+VqZszHD325apIWD+09CeMSCfQEareN7EGGf24uwr24V0Nl2YlCQ+KVd8cCoZx572A5B2fxo5XzMHyDclETb10etNc9XY9KNjFcHZtCFQekzsCZ4PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhaOv1dxcVkpXI9SK4HJcTyXumTn6OEjKEZ7HsO+4ls=;
 b=Z2PLdBk4Y7z2ewQe6pwzdQwAhTgWxT76exaVRAQKfATq3TMS9FFhAcg+2uW7dRH93foWdU1idZ1u+atRXs+KoZoRL6GyPWD6UmI/CIbFbGTb+Sti9NLAUDUkrPvur2kEmwfyO5V5oKZD2PhqgVD20cqLtGWD7w90PZMFMUdqugQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7413.apcprd03.prod.outlook.com (2603:1096:101:140::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 07:52:50 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7416:94cd:75d9:12bb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7416:94cd:75d9:12bb%3]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 07:52:50 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Thread-Topic: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Thread-Index: AQHaY+EWoz2iUYqqe0mCoxGYvuPbLLETeb6AgACeZoCAAQADgIAL6KuA
Date: Thu, 29 Feb 2024 07:52:50 +0000
Message-ID: <c410a78da06327f88b7690dd315678e70224373c.camel@mediatek.com>
References: <20240220094211.20678-1-peter.wang@mediatek.com>
	 <46d0c5b7-7158-405d-ba38-cece4030e2bd@acm.org>
	 <0874377d564ceb63efd62df3757c6e5f3a0dd03c.camel@mediatek.com>
	 <923e2241-ab08-4cf6-a614-91da4b3575b8@acm.org>
In-Reply-To: <923e2241-ab08-4cf6-a614-91da4b3575b8@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7413:EE_
x-ms-office365-filtering-correlation-id: 95db35df-64da-4be1-434b-08dc38fb6d6f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bIcnzPTjpMtfr+GUZz0lj/Nx9twQCoz+5DpsKIhP064AZAhxmlLrkm9yBRq31TZVewwBFWkZ5d4DDp8r1gcNz0Tk4xO2ryNHU1ApUXtwVQOtf/l4/soLMgiJCeaYjqzyA9rrRBH6QnBxS2dVU079w71jyJum1ZI5c2jXHTmdOfeMAaEajcnI+dS2wgVErbOPNW9S0TsXBoU8spl89vvo32b418xYlg9YHZesKxgzRe7nij4faCYJ79zvCJfWOL0V9glqfF9SOCvaMlBGSFlEodsE+c//0npfsb2OjFj05pkkAPydr0wgynnsJrfzDZwitoziUcKBEwk2bdxqQ2BdqKsQsah4ZucK93csbM0uMPHRsJa1Uq0jilXOfuYdAxUPJ3y/SzUqHb6gI/8T9A9oJUFcr6w413DcExeT2UfgbS4NV8HY2Jn9BIkRKaexDDljnltKeyPEE5aELlHc9JuuHA9obcbWkCUsaRO4N2Lkzl3f2M+EZs7cVkfRCU7uvB9K1JH/0kWs4lj03ZeTm8+9jSIaOtmh6nO1IxBSRkLaK4bUajFJ+cWooK+XbuECKckUja49SgazfSAl+oAyAJyrILxIBgp/dbRpbj+J4SpuRvqiYg0wwjii2xhjdOil+U/4rKEm/r5NHNAMeHJmxWJpmCM+UM5FIxQwuE3BDoEVQCncLq62iwDjxosKxFYIKDpc5+2Sp8CEDm/rsPhqYv5yVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUl1RFkzeFhOM1M2Unh0U0xWd0RmRDM5NmxvYkw0Z2c0L0Y1RVR6QzR3V1ZI?=
 =?utf-8?B?dk4yMFd4TjFKRjhYOWJtS3NKdGhvNUtxVnc0emM1RTFNMGpqNXZGOXd5N3ZR?=
 =?utf-8?B?bGJVaGdFNmczWURLbDJaS0pKcWljeDVxalRIL3E4Vml1bFg2dGRtK2Y0UStE?=
 =?utf-8?B?VHFkQ2hJOVN2T3l4MEtieG9xejVXelFXUTdhUkRNZjdwcDFZQ05CTWluZUZB?=
 =?utf-8?B?S1pnVUVBV1F5QjMvbmNwWnVsK09MdGxpQ1JpUHRuaXRwMm96b0VTODN6UDJY?=
 =?utf-8?B?YVJKQWowckxXSkNLTDIxTDFRcFgzS3JseDlla3FYN29FU0xtWDN4UlNSNzBy?=
 =?utf-8?B?YjhkRHVqdXpjZm4zNnc3Y3plMlVGMEpYTCttQ3VKWDdIQkhNVytMVUlFc3Bn?=
 =?utf-8?B?ckVGY21pL1lMVTc1TWN3blJIWWRRWlozcmlndmFEeG9LSGJUalJyR2JNclUv?=
 =?utf-8?B?NmNPRzJuZFhlMW9YSDZYWjZYVkxNbHc0MHVNTDJuOTRJOGNrdHlwVkQ2ZjM4?=
 =?utf-8?B?dXo3cFNFMWhScXR1QjFPZUNYdVRLZWpnZ2RDMGFxaHVLM3hDeWxrR3lPMUJX?=
 =?utf-8?B?VTgzWVRSckRaMUtQNndjSDhHZzBsVjZEeEV3anNXKytTaFMrZmFPZEEyZ0ww?=
 =?utf-8?B?RnRyU0o5WC85TGVOOWc0R3pCTHBZNkxKRVJFSVN6RzRZK1YybDZidEVuVjdQ?=
 =?utf-8?B?S1l1SXZFYjQwVjNzZ05LSkg4SEhlcjhhRG9YUzVRQ2lFZm9CWkxjTiswZHZq?=
 =?utf-8?B?Zk5aWTA3NFNQUDU5eTg2aldMRHBoNlovcFk3V0NERFJNNUNHbGV0LzgrYXJJ?=
 =?utf-8?B?SDFvaGtQYU1yQ3A2dmc4OElubjdJdm8xNklBYVJYL3c4cU40Ymp0c1duRmhx?=
 =?utf-8?B?RUI0T3JWcXhyS1AzMVJhdXJnNEo5UWw3QnhqOGUxWGcxV3BXTXorRndRY0xZ?=
 =?utf-8?B?NlRYeGQ2UEVkQmVNN2NoekpSUEVjSDVBc1ZHMzNKcmE3WE5vQktVeEVTSHdK?=
 =?utf-8?B?TjNzeStQWnNQaDMxNTFRTHhvcU52L3laczV4a1FSemFmTUpiSHk2Vm94bWVK?=
 =?utf-8?B?dTcxUkVxdTF2ZHZYMDdxSGhBSFd1UXZ4ejZpYXpITTJYMTBwTXlMS0ZmK1h6?=
 =?utf-8?B?WnEzR05XYWsyaWtKM2d3OThjVFhmV1I1OVpTazFMUGUrYVZkNmVsVWovTDE0?=
 =?utf-8?B?OWhmUHVHK0lTNVBtd2tjR0pkUWdGdzhoMDRSYkZuWDl1cy9DWXJkMDNIMmhs?=
 =?utf-8?B?dXdTaUZIRU9UVWJ0c0MvdWZ2bmM1TytqUFNnVloySmNDSFF6K3dXK0xmQ2t0?=
 =?utf-8?B?eWFNWFRtRVFQSWZhbVhZcEkyRStnMEN4aG84dGlkaWRtamtOcWxMZFlFUjFI?=
 =?utf-8?B?WHR1bm1mKzdETVJ5OElYSUtZSUp3SXZweU9IazRrd2F2V3ExRmNBOWsyQVMw?=
 =?utf-8?B?a1FiMi9EbkhHZmRwVWU2WVBYVnVETHpMNTBQVGQ3UGRMTG9JSGpsNEE1ekVY?=
 =?utf-8?B?bndDbFkvWWVBbGo0Y1R4R2xlWEZyaGZEa3gyUWJocVhuQXdzZWh3WE5TYlVD?=
 =?utf-8?B?cXlOWkNWcHBGOE5TUU42cysrZUhNZk1HMEFWczh5cVJWYjB6ZTJJSFh1cXNt?=
 =?utf-8?B?Tm54d1lTVlVZblNqVTJJak5qQVQrRXloaXNDNG1YTE1aSVMyNFZRa3UwYnZ3?=
 =?utf-8?B?UkRObGhjRTRrQ1k3RXdjbjNHNHlaR2FsOFRxRlpXR2RseDJQeERVZmNVZExt?=
 =?utf-8?B?bWdxeUswR1duSVVSbXA2RHdRNzFTSXRIaUlObHhybkdsTmlYenNZN1R4ZUJ3?=
 =?utf-8?B?M0ZiU3dlM3BTTlpHUzdHdkFjWTM4N1ZtemYwd0hGK1QyMkdZNUdLTVU5UXVH?=
 =?utf-8?B?Y3dSeGNnK2NaKzdHYmlDS3dWL1FWYmc0eHF1UjlTaFlGMnNlL3hVQ0REM3N4?=
 =?utf-8?B?QjRFVHNBZnlNbEJmMFJ1VnRkbFlIcWFWOVFqR1VkWFJhSG9PTFkwZXluUEJa?=
 =?utf-8?B?OGtJTVZ4bSsrTXJwMTNRWk9UbFErUHVrMTl3TUpJWmpHVG1mVTlSbU5mMW1i?=
 =?utf-8?B?WnJ4bUQydG9ld0JoOW5DcWhBRTBaTklLcHBWWVZCQi9WVVRHUDZlTDBqQzND?=
 =?utf-8?B?Qi9takpFTGFpYWd6ZnpuQkhtRUkyQy82T0VWMUp2Y1drV3BWT2RWQm1RMFYv?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3485C36899749A4DA6787A978E988D75@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95db35df-64da-4be1-434b-08dc38fb6d6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2024 07:52:50.3691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cnt7Uzz7VibIpIL/RfhyxL9ZD5NLyASUh4fY1/MtqR3H0owIY8BF+u87a24fH8Eqool0GmFfpISIpRVh19BJ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7413
X-MTK: N

T24gV2VkLCAyMDI0LTAyLTIxIGF0IDEwOjAxIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMi8yMC8yNCAxODo0NCwgUGV0ZXIgV2FuZyAo546L5L+h5Y+L
KSB3cm90ZToNCj4gPiBUaGlzIGhlbHAgZnVuY3Rpb24gaXMgZGVzaWduZWQgdG8gYXNzaXN0IHVz
ZXJzIGVsaW1pbmF0aW5nIHRoZQ0KPiBjaGVjay4NCj4gPiBGb3JtYWxpemUgdGhlIHVzYWdlIGNh
biBtYWtlIHRoZSBjb2RlIG1vcmUgY29uY2lzZSBhbmQgZWFzaWVyIHRvDQo+IHJlYWQuDQo+ID4g
U3VjaCBhcyB1ZnNoY2Rfdm9wc19pbml0L3Vmc2hjZF92b3BzX2V4aXQgaXMgYWxzbyBvbmx5IG9u
ZSBjYWxsZXIuDQo+ID4gQmVzaWRlcywgaXQgYWxzbyBuZWVkIGEgY29tbWVudCBvZiBjb25maWdf
c2NzaV9kZXYgaW4gdWZzaGNkLmgNCj4gDQo+IE15IHBlcnNvbmFsIG9waW5pb24gaXMgdGhhdCB0
aGUgaGVscGVyIGZ1bmN0aW9uIG1ha2VzIGNvZGUgaGFyZGVyIHRvDQo+IHJlYWQgYmVjYXVzZSB0
aGUgZGVmaW5pdGlvbiBvZiBhIGhlbHBlciBmdW5jdGlvbiBuZWVkcyB0byBiZSBsb29rZWQNCj4g
dXANCj4gdG8gdW5kZXJzdGFuZCB0aGUgY29kZS4gVGhlcmUgYXJlIG1hbnkgZXhhbXBsZXMgaW4g
dGhlIGNoYW5nZWxvZyBvZg0KPiB0aGUNCj4ga2VybmVsIHRyZWUgdGhhdCBzaG93IHRoYXQgdGhl
cmUgaXMgYSBwcmVmZXJlbmNlIGluIHRoZSBMaW51eCBrZXJuZWwNCj4gY29kZSBiYXNlIHRvIGlu
bGluZSBzaG9ydCBmdW5jdGlvbnMgcmF0aGVyIHRoYW4ga2VlcGluZyBvcg0KPiBpbnRyb2R1Y2lu
Zw0KPiBzaG9ydCBoZWxwZXIgZnVuY3Rpb25zLg0KPiANCj4gUmVnYXJkaW5nIHRoZSBjb25maWdf
c2NzaV9kZXYgY29tbWVudCwgc2hvdWxkbid0IHRoYXQgYmUgYSBzZXBhcmF0ZQ0KPiBwYXRjaCBz
aW5jZSB0aGF0IGNoYW5nZSBpcyB1bnJlbGF0ZWQgdG8gdGhlIGludHJvZHVjdGlvbiBvZiBhIGhl
bHBlcg0KPiBmdW5jdGlvbj8NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQs
DQoNCkdvdCBpdCwgSSB3aWxsIHVwZGF0ZSBwYXRjaCBhbmQgYWRkIGNvbmZpZ19zY3NpX2RldiBj
b21tZW50IG9ubHkuDQoNClRoYW5rcy4NClBldGVyDQoNCg==
