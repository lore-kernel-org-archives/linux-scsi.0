Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F421E3772
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503798; cv=fail; b=SGXRmrv7gA5HUgM33wSKsZrzJ6O2eJLbOK3ldYVS7jeMPuWStgo14HfaKW+JWlwwE14dVF8GM4jCBtP61o7/purelzyaN1vSOmKBJnKLsCUOcEe5popoSzZsAkqomSlvT6zU1f/vrmNsutDi6tl6tJmZ4hWd6n8C0T8ydz1ktCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503798; c=relaxed/simple;
	bh=48Q+pTQMRbpO4CMK/zPtfKIdMqhyk9FilBGS9ROBhcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hagmo2R9vMToK+epegv7cV9ex2wb4fRi8LBPu7P24S7P5FocjwMpgQ4r2m0MMYgsquYA3Y7dQNh3zWfMpPvoH1bSwY7ZVW6cl+eqj2o3ShbRctU8wTPW5MNmqGpcn9CWsVb+uSlGM2XL9w7F6I10D69mI7z2c/dy8H/8QmWrSt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=H+VYu2iD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bwxevpgS; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="H+VYu2iD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bwxevpgS"
X-UUID: dfde1a668f9011efb88477ffae1fc7a5-20241021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=48Q+pTQMRbpO4CMK/zPtfKIdMqhyk9FilBGS9ROBhcM=;
	b=H+VYu2iDI/hAXWvDpZhPRZnqcKcxJsNa/05+6qcRGq2t50u8wedOI9X7Ws56dJATAdnJPO6G6ns8u5Pk8EHt/jyx4mHiIpwBkuawLmxZclMAKGj15SL8zf/xGMQup2d6Z2rNatHJERzG6O1eDczf14XFPGVL8yrRaYNoH4jitaM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:df39dd31-6454-4138-bbed-edcc4e0205ac,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0fcdc3,CLOUDID:97dc6525-9cd9-4037-af6e-f4241b90f84d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: dfde1a668f9011efb88477ffae1fc7a5-20241021
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 923516792; Mon, 21 Oct 2024 17:43:06 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 21 Oct 2024 17:43:06 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 21 Oct 2024 17:43:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+HZLHivFSJdYtTliREkmr4WjMkADvBfPTAZTqZjohJGAzDbJzX7uVgn3IGbtPPGb8yefkjOPSOPmY22fZ6qcMSJr8cD+WmInTu8rc9WyHx/7AvKh4ARlVfWeJDlLgYWMEt0EuFYaZpATXNiL2IjW+1A1XhMlBlpFkCWkaepQh9q81OXJsYlriKJ7BKSDzfXCCZujfFIsfgQnqmKEbP8UrpZwMedWL0kqrl1wS95qxUNdpg/QUUBZBVb/dZXdnSlDu3iDCIjMGqxf1SmbZ2rJRvgLsI9lgcbc9wh1YY0QP5cCbeNsboDSl7DuYWVp4lvcLJJfLkNFp3UKcCpH9OB7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48Q+pTQMRbpO4CMK/zPtfKIdMqhyk9FilBGS9ROBhcM=;
 b=blGHGIcYJOcw2IYJf+ggebd/bFnka2DVIXieffmE/21Nn8BTWzRp/r48Y/WnLa17emPaE89fwZLqOJiC3/bZWYAcrwi7hrjy29/052tcWUk2t4NpOg+mOrdxObYy3usosLXKtKHEoObgAaYScirsNWJVb9rt1imfAs5qbwG38KAWjg8mNXj0Cw2faeGVewTm8q9Fs2drP8nsm50yWyznlgB7SZy5r1bnDI96wC3l2NcaMQ0HqCe/jepzE3/CWdYXfJ7g4cTQN43ZE9aegzNOveubvnsltPj68fA8CxBKLMFE5+/u2H/ZuI6F7j+hCYkvNIo/88O7nAh/A/JqpxGNTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48Q+pTQMRbpO4CMK/zPtfKIdMqhyk9FilBGS9ROBhcM=;
 b=bwxevpgSjMDywfFE/sgj/cgwJJKmai6EbEWl8qXzszrrK/a84SInNKC5PSlvUmJ+GX+mFBOiIAeqv6U1kR/RG0ZR+utBlh4MRA4PlsI/bnUH5PmsIvObNg5WoPw317M9hJ34oc2mkeRp/s2koPuy4BNfVWZeXp6HMqs6jxxsKfQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8550.apcprd03.prod.outlook.com (2603:1096:101:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 09:43:04 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 09:43:04 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>
Subject: Re: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
Thread-Topic: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
Thread-Index: AQHbIBA1pPTrBqoK4E+TyRNuUcqSCbKQ+x6A
Date: Mon, 21 Oct 2024 09:43:04 +0000
Message-ID: <37f935a047e05f001e1fa38f58d98abac4543ab0.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-6-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-6-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8550:EE_
x-ms-office365-filtering-correlation-id: 5b103688-0905-4f8d-ecd6-08dcf1b4c2b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZktsMEtGd2tjSTlvOWVWcTVxYmZURWxheVE5V0l2YW1hbXU5MUN4YlpGaTN4?=
 =?utf-8?B?a1k4VTE2aWxDbUFOY2xNaStqNEZvMGVQZStCVDhhM2lNMFdTQTdpNHFIUlpt?=
 =?utf-8?B?UDRmSTBqOWt6S2JPK3Q3NFJWZmFTOXI3SHBNR1dJZVIzOHRpb3hGQUdRQmhZ?=
 =?utf-8?B?cGJmU3ZCVjM3dGtLeXdQZkdwc1hOOVZyNStkQ01NcW9QMEI0NVFGMS9EdTdh?=
 =?utf-8?B?WU9JWFllSDBSSDRsa0ljeklUdWRaWFlEclRFNi9OTDh4Tjg4dDdYRkNvZ0Vi?=
 =?utf-8?B?TERGSzNhV05rUzJxNnU2N3BJc256d1B2K2o3dzd2bW01Vk41TE83MjUxZDdZ?=
 =?utf-8?B?c0Zoc1Fjdi9uQ0VURXNoaGxRUG1mYUJwM1U1WlJWbzlyM2I2UStmUE5JRjZH?=
 =?utf-8?B?ZUU1anNKblBndDAyWkNMNUNOZ0ZRb1QzTWxhUGF0d0c4TmRocno4WTVqdzYv?=
 =?utf-8?B?czlhaDBjdXdOb2ZLMVJKUDN4ZzB3NVEwZm03M3F1MXRuamdORGVaV1Jtd2tl?=
 =?utf-8?B?enZBSERTeVNmMHJRSlprSUhjWGoxU3lzU1BWWUtQbkV1SjFvUzlCUmdDV2Nz?=
 =?utf-8?B?QkJUT2t3aXliRmVlNWM3WWNSS1NlQmwrRitvaG9tTE1VbENiSW56ZjJYZWdx?=
 =?utf-8?B?WkptMkVRTlBVMU0yWVQyUWVLelhxZkdsV3E4Q2xYcmRZQ1cyOGM4cVU3RWQ1?=
 =?utf-8?B?eStlaHBWZDJ4My9JUlN4Sy9wbDh4NmtoWjZvTmdHMzV2QWprSWpGUEF0dldQ?=
 =?utf-8?B?OHY4OXFCUHNSd2FDQnU1dVo0M0IrZkNaQnh2ODdvYXdMNlFoc3BhWkdGazVI?=
 =?utf-8?B?eEk0T09RRFBPVnArS3NqOTBXOVpIZEY2Y1hpNjloM0ZzeUV4L29xOWVkR09r?=
 =?utf-8?B?NCtQNDRHdzFpYjU0RmwwNHo3a0RJZzRTZ0VXQ1E2TVpUQ0RTc1IvK0Z2bmpH?=
 =?utf-8?B?NGNPOHlsZUJ1WlFGQW9KL2pZS0d6aEF3QnBXbm1yWDNPd0xxbkRsNVdQQUN5?=
 =?utf-8?B?WnhtMnM1MTBLMjUzQnlJZllmalBOUmJzSXpKVDNmUExDTEdmYjlHcWFYd2VF?=
 =?utf-8?B?NzJCR2xOblFGVTNScXdYOWErRzZNMEIyV3JMRGFJa3BPMGJ3eVo5TEw4aE13?=
 =?utf-8?B?YUFwamxac3ZkSXloRlRKK2N1dWFKVFBXbDltUXZ0R3FjYm5UWVJoem1ROTly?=
 =?utf-8?B?dVZDUUZWZzNyVFdQSnVrckQzTzNhbW0wK042WXVCbkdMUzNZaDBDNzRScGg4?=
 =?utf-8?B?ZGlHSUIySWkrcTRCWEJhM2dBcHhIQUZBeGV6V2txZVdFZzlnUVl3ekVqMzFo?=
 =?utf-8?B?cHJYenNKa2FpTnloWmFrelNXZ3RXQUFxVnQ5SDltQWhhVndSNi9YcTZCYlA1?=
 =?utf-8?B?bFZDeDdjUm1wcmJyeHl6dldWZHBmM3dwY0hqNW1UaWZ0NjMxOUwwbEJMd21y?=
 =?utf-8?B?YWorVHhVdEI1bUVKcUxzaGU3czU4TUxCclFrVEkyT3Z3Mlp5SFhoWmtxWjdn?=
 =?utf-8?B?cHZ3aTIrNEp5RFpHbWdFK3VZWVBwMmVmMkhHeWV0SDNUYk9CWmFML21OOWxG?=
 =?utf-8?B?RHUvNzhHbWU4SVp0NnFSUmlwNWFzQStqT1FjMzJOZWFKZmttb3FWL0UxYVdL?=
 =?utf-8?B?bTdVOG5VUDM4QVlWZFlKbmFDNCtsYldKRmoyQVZnUnhLYUxZeDVTRTFpampN?=
 =?utf-8?B?OGJEcGNJc3JzNjZqaFpYRnBQaW43aUQ3ZllXcFZBUjZzVFdGVnhFTzBCdnQy?=
 =?utf-8?B?T0Y3YjgvS0ZVbXZoRDVqY3NEZUd6cGhOc3BxWjRhQlFyUFpEaG1lcTFwZUhS?=
 =?utf-8?Q?izi4SlEqpTZ2g2y6sqBEZTK0Jeq/UsJDK1jkA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlJSMFhhcXRFbm1lWUtBVG9uMzlXRklpMGZEN2NtT2kxd0RjQk9UdHp3d0I4?=
 =?utf-8?B?L2NXWExOTzFYS3J2QkFFTzRRVzl3MjNmdTZxK2E3b1lzMTVOdTJGT1hrUmh4?=
 =?utf-8?B?Y2Y1bzJCNUR3VXM1MDdCa2NwOENVeFN1c2QwcGxRZ2Y1RzloZjBqRXlXZXEv?=
 =?utf-8?B?S01pMkdKZ1d5T3d1aGdJUGNkN01IVGwyUURXZjY4OHRPMFVsby8wS09LTllL?=
 =?utf-8?B?VFFFdUc4d3Uva3N5MmZOSG8zb1dpaEJOU0tHN3lDMnVSL3QrU3BUSWU0VUxq?=
 =?utf-8?B?YkMwQklMVkpFVC9UNllTeWlTQnhRU1BQckkvR1p5MFBCU3FLZVUrOTdjYjlE?=
 =?utf-8?B?UTIzMTVtdDVLYnFuKzRhSFlZUTZvMnFrZjkwaW95OFFuZTdRc29td0Y4K0Zu?=
 =?utf-8?B?REZOWm1Zcjd4dkNYTDlpWmZVNytydGNKbFFhY1NqV3NnSWl5V0RiVG9IRlcz?=
 =?utf-8?B?cUc2SUM5WFF2ZXFHbWhwMlJjS3orU3JmSjAzWGlTNnVESnFnU2xZNjRPQ0Y3?=
 =?utf-8?B?UDdkTGFpOHBqUmN5dGJITUhlRytGWU5jaXJ5S3EwSjdvRkxuRXdhRXdQSGNV?=
 =?utf-8?B?T2M0d2RGMW9pc3puZTlUTTZFUnh3OXdDcWtQaVRkeW8wNS9od0ovY21zbVR5?=
 =?utf-8?B?cktvSmpnOXBUaTFRa2dIU3ZBS3ZoYThmNnk0ODh1TGZLazU5VzhlZzZudlFp?=
 =?utf-8?B?RDdzcGkvaGdlWHVBR2Irb0VQOS83SkJkOGJMdGJOT3hYUFJKUGc2VVVlWjhn?=
 =?utf-8?B?V0xPRERWVVVITDF4SVgwT3hmRmh0RndJWC81Sk80VlFQU2lWeDdrdWRLZm5r?=
 =?utf-8?B?d1Q0a0lMWnFTVXBJcW02alQ4VXBlcFRTY0IrTmc1d0cyZ3NVZUx3RUZEZjVN?=
 =?utf-8?B?NWhwWHkyczNCaUtLTnZ4YXlrRUVkTDFWVmpUTU9HV0RYRW42Mi9kSXo2WlNt?=
 =?utf-8?B?d3pydkt2a293ZVhKclBnbmhSeTQ4dkR0U0VoRENQVFNFOWYxVHJSYWJwcFBs?=
 =?utf-8?B?SjBya0VEU0hDZ1hGU01zci9seUFBdExsdWZQRXRyMC8xNkFsWmxvai8xVkVF?=
 =?utf-8?B?eUhSNW9GTW9OemZyOTladWNoVGZlaThDL0lOUmtTYlVJdE5seER6aVl0WENZ?=
 =?utf-8?B?TGp3R2IzS3Npc1BnM0VtYTVqMENvNHE1aEJDcGhhR1ZpSzFDOFZ4ZTFUTDNT?=
 =?utf-8?B?cWd5QlFDMGVxaCtoa0xlNFRmTTNQOUFSSU1icFZnMmdFcWlOZ1ZqS3ExYlJB?=
 =?utf-8?B?UU0zMUp6ZHFRTGw1ZytRSmk4N1gxcncwU0VEWFVIb1V4RUtUNmw3cDJpaTVT?=
 =?utf-8?B?SjNNd3NpMGQyVDdER2ZYZGdJMnZweTcrdUV1OWIzLzdsSnQ5QWtuNEd5bGFa?=
 =?utf-8?B?SkZoUGozaEU0L0FaeWdOR01LTW5ha1FxS0o1bWJyQks0ZStHK2l6MHlyUnJq?=
 =?utf-8?B?RHp3UHIrZ0FyQWhEZmZSUXpRazVIVkZYTWhtWnplNjl3ZUpQVkZobmhURm9y?=
 =?utf-8?B?VGZ1dHZJZk50NjRZMllERndhdW5WMHlOZ0NsaG1nekR1TU1nUXNjQVFkTndD?=
 =?utf-8?B?WFpuVVJBSHl3cnd4aEZ0eFFIODhVcExNazZ2aDB0alRqV1IxR0ZqUGFVR1p4?=
 =?utf-8?B?VVRWYVBaOGdiRWJBZVN3aGgySG16SldOV1c4ZGRvcjJUQitENmtSd0xMRTNM?=
 =?utf-8?B?RlR1akhGa0RKbjE5WWUweFY5azNQL01nTEg1a2JqWnRCNmU1cjlVU3hwK3Zt?=
 =?utf-8?B?VDFLOHJwYXNNQ3A2ZzBybVFrdjJvTlZ5VkhOOGk4ZE1HRjNHOG95Tk12OGVh?=
 =?utf-8?B?U0oyUy9rOUlGTTF6UU1kUDJxRDZXTklPd0FIOUIrM3dXYWJYczVWdk95dHdz?=
 =?utf-8?B?UG1iWitLd2JOSGt5U1dJV2JWWHQ4elJ6ZWlOelU3TVhTTUhZUU95eVJQR2RH?=
 =?utf-8?B?YUcrelRkQytmbHFid3J6REFFWThUQXFwNVRSK1d4WFZJQS8vTFZZOXJxSmNi?=
 =?utf-8?B?R2ZtQkNVRWFhc09WbVNxM1hMczNaTDJVTjJUa2IrcjBtRENGVGNKS3VYd0h2?=
 =?utf-8?B?WW94MjB2YzdBMTZ2RzBaRWRLaEpMcmNleTFwRERNSSt0NExRUUdTNHViT3JV?=
 =?utf-8?B?YWtaWTA4TzV3UGZhdDZJSXB3bHdkTU9nT0lJSEdORFdYTEhmU2lZWlVNMHgr?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9A1557032DCB341AD91B173F2C94188@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b103688-0905-4f8d-ecd6-08dcf1b4c2b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 09:43:04.2392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjH4orOTAy9ML8x3weX42s+cbrrvtKDJBDUWa3zCK28RmBksnp1n934fQ84saQF+psSyZTgTG8bvK53aRBe0zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8550
X-MTK: N

T24gV2VkLCAyMDI0LTEwLTE2IGF0IDE0OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVXNlIGJsa19tcV9xdWllc2NlX3RhZ3NldCgpIGluc3RlYWQgb2Yg
dWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoKQ0KPiBhbmQgYmxrX21xX3dhaXRfcXVpZXNjZV9k
b25lKCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVA
YWNtLm9yZz4NCj4gDQoNCkhpIEJhcnQsDQoNClVzaW5nIGJsa19tcV9xdWllc2NlX3RhZ3NldCBp
bnN0ZWFkIG9mIHVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3RzIA0KY291bGQgY2F1c2UgaXNzdWVz
LiBBZnRlciB0aGUgcGF0Y2ggYmVsb3cgd2FzIG1lcmdlZCwgTWVkaWF0ZWsgDQpyZWNlaXZlZCB0
aHJlZSBjYXNlcyBvZiBJTyBoYW5nLg0KNzc2OTFhZjQ4NGUyICgic2NzaTogdWZzOiBjb3JlOiBR
dWllc2NlIHJlcXVlc3QgcXVldWVzIGJlZm9yZSBjaGVja2luZw0KcGVuZGluZyBjbWRzIikNCkkg
dGhpbmsgdGhpcyBwYXRjaCBtaWdodCBuZWVkIHRvIGJlIHJldmVydGVkIGZpcnN0Lg0KDQpIZXJl
IGlzIGJhY2t0cmFjZSBvZiBJTyBoYW5nLg0KcHBpZD0zOTUyIHBpZD0zOTUyIEQgY3B1PTYgcHJp
bz0xMjAgd2FpdD0xODhzIGt3b3JrZXIvdTE2OjANCgl2bWxpbnV4IF9fc3luY2hyb25pemVfc3Jj
dSgpICsgMjE2DQo8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2tlcm5lbC9yY3Uvc3JjdXRyZWUuYzox
Mzg2Pg0KCXZtbGludXggc3luY2hyb25pemVfc3JjdSgpICsgMjc2DQo8L3Byb2Mvc2VsZi9jd2Qv
Y29tbW9uL2tlcm5lbC9yY3Uvc3JjdXRyZWUuYzowPg0KCXZtbGludXggYmxrX21xX3dhaXRfcXVp
ZXNjZV9kb25lKCkgKyAyMA0KPC9wcm9jL3NlbGYvY3dkL2NvbW1vbi9ibG9jay9ibGstbXEuYzoy
MjY+DQoJdm1saW51eCBibGtfbXFfcXVpZXNjZV90YWdzZXQoKSArIDE1Ng0KPC9wcm9jL3NlbGYv
Y3dkL2NvbW1vbi9ibG9jay9ibGstbXEuYzoyODY+DQoJdm1saW51eCB1ZnNoY2RfY2xvY2tfc2Nh
bGluZ19wcmVwYXJlKHRpbWVvdXRfdXM9MTAwMDAwMCkgKyAxNg0KPC9wcm9jL3NlbGYvY3dkL2Nv
bW1vbi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jOjEyNzY+DQoJdm1saW51eCB1ZnNoY2RfZGV2
ZnJlcV9zY2FsZSgpICsgNTINCjwvcHJvYy9zZWxmL2N3ZC9jb21tb24vZHJpdmVycy91ZnMvY29y
ZS91ZnNoY2QuYzoxMzIyPg0KCXZtbGludXggdWZzaGNkX2RldmZyZXFfdGFyZ2V0KCkgKyAzODQN
CjwvcHJvYy9zZWxmL2N3ZC9jb21tb24vZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYzoxNDQwPg0K
CXZtbGludXggZGV2ZnJlcV9zZXRfdGFyZ2V0KGZsYWdzPTApICsgMTg0DQo8L3Byb2Mvc2VsZi9j
d2QvY29tbW9uL2RyaXZlcnMvZGV2ZnJlcS9kZXZmcmVxLmM6MzYzPg0KCXZtbGludXggZGV2ZnJl
cV91cGRhdGVfdGFyZ2V0KGZyZXE9MCkgKyAyOTYNCjwvcHJvYy9zZWxmL2N3ZC9jb21tb24vZHJp
dmVycy9kZXZmcmVxL2RldmZyZXEuYzo0Mjk+DQoJdm1saW51eCB1cGRhdGVfZGV2ZnJlcSgpICsg
OA0KPC9wcm9jL3NlbGYvY3dkL2NvbW1vbi9kcml2ZXJzL2RldmZyZXEvZGV2ZnJlcS5jOjQ0ND4N
Cgl2bWxpbnV4IGRldmZyZXFfbW9uaXRvcigpICsgNDgNCjwvcHJvYy9zZWxmL2N3ZC9jb21tb24v
ZHJpdmVycy9kZXZmcmVxL2RldmZyZXEuYzo0NjA+DQoJdm1saW51eCBwcm9jZXNzX29uZV93b3Jr
KCkgKyA0NzYNCjwvcHJvYy9zZWxmL2N3ZC9jb21tb24va2VybmVsL3dvcmtxdWV1ZS5jOjI2NDM+
DQoJdm1saW51eCBwcm9jZXNzX3NjaGVkdWxlZF93b3JrcygpICsgNTgwDQo8L3Byb2Mvc2VsZi9j
d2QvY29tbW9uL2tlcm5lbC93b3JrcXVldWUuYzoyNzE3Pg0KCXZtbGludXggd29ya2VyX3RocmVh
ZCgpICsgNTc2DQo8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2tlcm5lbC93b3JrcXVldWUuYzoyNzk4
Pg0KCXZtbGludXgga3RocmVhZCgpICsgMjcyDQo8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2tlcm5l
bC9rdGhyZWFkLmM6Mzg4Pg0KCXZtbGludXggMHhGRkZGRkZFMjM5QTE2NEVDKCkNCjwvcHJvYy9z
ZWxmL2N3ZC9jb21tb24vYXJjaC9hcm02NC9rZXJuZWwvZW50cnkuUzo4NDY+DQoNClRoYW5rcw0K
UGV0ZXINCg==
