Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68853433A4
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744893554; cv=fail; b=gEQN8S/bc3ELlfUGeBWasvtjAtwqhPf+mT4odk83apiT1A/HlGBV7h11UbRLlrEeX9syd/ZniEAJuC9dVFAS6JyvNxH3+45LiNKfm6ofLYao/QrmUoc+Qyo79YuuuTxl3FMEKoTzSZfr9gOY0wA4aM4wn8Gl2E11WseSmXJssdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744893554; c=relaxed/simple;
	bh=c9qf/btSqjik1xe6DRrk2qLsrL+wnGRpZwsOuWj0B8I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NDqpfGzx9fl7S4k69dUm38/zLCuKKLLcSC2tM8GquZoN4UyKzjnsFNme6dmZCE30hOEvhw2H3V0y3CaIObrMPD99WPr4kyLgNV9bBZy6RoGqgY9qPqM0A3rbIH63c9Nti4cKHCl2iRFDih3njf6GuZYdLgZ8JBPIGb5bjHpSesg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dKxcZxgL; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qpEfyxP7; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dKxcZxgL";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qpEfyxP7"
X-UUID: f42049a21b8811f0aae1fd9735fae912-20250417
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=c9qf/btSqjik1xe6DRrk2qLsrL+wnGRpZwsOuWj0B8I=;
	b=dKxcZxgLXMg9NeXU51uQC9zirrYTgmqPUIPyJ4qUmDNeGi7YhP/2siHGMrxGfHfMM6hKDoB+tZJ1dJhzlHezatxM5EDQ8Te6yWNTulDz+rxP/mJpJsla3V4jvbf54jN7cFGf0dztXl6X0toVxPi6OlgSdxss/7QB5dTb0qRWDR8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:72e2947a-a4a6-48ce-929c-98104da1e47c,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:0697ba8d-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: f42049a21b8811f0aae1fd9735fae912-20250417
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1375747398; Thu, 17 Apr 2025 20:39:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 17 Apr 2025 20:39:06 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 17 Apr 2025 20:39:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOHeLgGU0rDpt5K4PAHBzjgzQHSVCgLN75EjwlVAXSiw/jYy6ypLk/XMErlL9cIO8AmvM//eFkiZft9QL+LNxgwtCozk4Ipm2G7kvG6TRRbigZBwqcrHv0o2lm3AKIEam5gAqMUE6Xf45IVO4CgdspEmRc8BRetUUYw2mdQXUWuTio4ObGuxFDhmplmygj0SAibHjPwMAYQ7cg7b+7QL2ODWIE1N9UQ5nhdeDh8o9m4vnZDe+MYhJU9d//hhj+ZVvCL8MS/vVLmcViKP424GRxPP1a+R+WDjKngAoqu7WpT2lLcXlgKYTe9yZU6nfNDV96ovkvJGU8m/khK2a53PUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9qf/btSqjik1xe6DRrk2qLsrL+wnGRpZwsOuWj0B8I=;
 b=fr8f63KpLCPzNUIVuSykg7arhkhJcTet9nbumGzC5SVTZIah8QavDo5g6LG1oB8cWfXW0xZg8dkFkNV6xO84RsNEmZj6ito0/aztXWtHR7z3bZOAKzCZKodDSZpP0P8W2DnLoWajFb4KzrQq6WkSNLceED3yX7HL2PWxOzonkQVMeQscQ94eN6sIU3sr2xiB0GPiaheGEKDwKrwQfmxpQS5AI90MiBPDdBAkvQXsCT8bIZNA/rU+qiQtO1LbV5DF7LKiNcmseSZVqKCj6o6ScXDK8FOJG/wzU4kIitmXAI8r+NxIPrzPE+1X+go6Hji+Wag2CDxvi52iWIs4BD949A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9qf/btSqjik1xe6DRrk2qLsrL+wnGRpZwsOuWj0B8I=;
 b=qpEfyxP7SzCr+Nf7rlc5SRi3er9ojcbavMy8DjYtU1Tz3uvBlDvBNPoxUFtxnmd/a2huOsuJ4+jt49yxosfL/9nBMnGOO+XmU2fUXAFi7L9JikWICM3OIukmIC+pJ8FRnHbz4SZmc1g0SD8w6yOebzHCUQN9eHfRgjof5lQK6cg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KU2PPFDD2810A4B.apcprd03.prod.outlook.com (2603:1096:d18::42b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Thu, 17 Apr
 2025 12:39:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.036; Thu, 17 Apr 2025
 12:39:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Topic: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Index: AQHbpN56xYfiOTSZp0K/37ODiF6R37Okb0yAgADPF4CAAqNCAA==
Date: Thu, 17 Apr 2025 12:39:01 +0000
Message-ID: <41c2d72bb792a9fab243e2586696db91205c63bb.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-13-bvanassche@acm.org>
	 <0390adb9d0ebed4ba4b386453d20175b1f3a0709.camel@mediatek.com>
	 <84d20bdc-fcd9-42e4-939f-a3ec0422e646@acm.org>
In-Reply-To: <84d20bdc-fcd9-42e4-939f-a3ec0422e646@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KU2PPFDD2810A4B:EE_
x-ms-office365-filtering-correlation-id: d626c858-d590-4138-b065-08dd7dacd4c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S2pzSDl2VkV6N2g3ZURKUXhiMml6TGFJRUtHdFF3NXc0anp3ZFNEVHQ1MUN5?=
 =?utf-8?B?NlNPc0MzVHNDMDBNL1o4dVU5NVhnak5WSFVDdEVXOWs0aHljZzBUZDZDQWd4?=
 =?utf-8?B?bE0zdHRWY1k3a3B3cGJadElHWXUrZDNEQmxmeGF3QUJZOCtrS3R0TS9CSk1n?=
 =?utf-8?B?OXVjMFR6RGl2L3R2WEVScUxBeHduWGE5dzA2MjhnY1lQTVhBQldSYWJ5dzlT?=
 =?utf-8?B?UFMrZ1hnNmtJY0txT3hRT1N3VW5ka1NnOGt2MXFjQ3l1T0I0UDJvMjRoelJ0?=
 =?utf-8?B?U0V6RS9rK0NjaFVUMU5MRUEyMHpEa0lwd3U3Z1hzcFpxd1lCb0VqVlI3L3Vm?=
 =?utf-8?B?VUx5MmFRRjhISVg1S1UyNDQ4Ry9RbjcvSGN2SmtldnVEY2IxaVZiZ3RLRWtm?=
 =?utf-8?B?MUhtS0ZVVVVrditUWk9FZWlIMUl5YjR6MzJyR28zclJzSHdsWXNMMDQwdHN6?=
 =?utf-8?B?VlI1ZEk0QnR6UzFoSnppYndKNEZrVUp5U0xqakd0Q1U1Vnp3SW9JR2RBdHQ5?=
 =?utf-8?B?N2pnbUVnRVlRdFJJTDBob0VnRW5hc2hMSWplemNZLytObllKVWlDTFBmVWx2?=
 =?utf-8?B?UXhZQlRzMWVGVXBHSy9YU1c0ZVV1anZMVGhGZ00wQ2N2anpJRlJvcjNDaWVt?=
 =?utf-8?B?OU5Cc3p2alJjYXY5M0U4Mml6WUhtOTN4WC9PRU4vTGNBQ0srbjRUOTNXS005?=
 =?utf-8?B?cGtJckJVSXlUYm0weHYyUmxRMFZyY2M2MGQ5aGVTOGFneVhMbHl5L01zZkNY?=
 =?utf-8?B?U1ZyclJucFFaeFp5OEJOY3lFUFd1S2J5M1ZvUG41eTVxNVRnamFDbzFod20z?=
 =?utf-8?B?S29VTHVyd0dqRVMxNU12QzFUZ3BxQjdYL1JGZTlzTm1uQlN4aDNPV1VpUlVi?=
 =?utf-8?B?WndxRS9jVG9ZY2NGRE02Umc5aytkME0zMVE4WnBSWWVKNlV5TTNDajFjV3Rs?=
 =?utf-8?B?QlFjNFFOeDVhV1ptaE9pQU1IcmMzZ3VTV0thdDBubkxXbTV6M2crL1JlRERw?=
 =?utf-8?B?TDRmMEVyRG1JVVU1blF5Uk1QNVhiSVgybVJTVTBNK1FyMnQ3YWlkTERaaDdt?=
 =?utf-8?B?Ni9Pcyt4a2RFZmFHZnphZUZlU3pKc3doOGxpNmRWUG16aXNmcVRvUlFJZUtK?=
 =?utf-8?B?eU9BYVZmbzZkUVZiL0FHRkxkYU5CVitzWWxyeHRkc1ZkdkRadUEzL29PNkNt?=
 =?utf-8?B?c2Q0ZkJ6ekRsNWZmY1orRW52V0VUUjM5T1pHbzkvK3A2bjJEY1YwalZ0aTJ6?=
 =?utf-8?B?NmNkVUg1ZUxkcGw3RVNuUCswZDhtckpGV21aQXNnT2FSaFZ4REwyaHF2VmV3?=
 =?utf-8?B?S1BqVWxKNElncWg2bzVvOUE2RmtQOEVXMlBPV3FEUUJ5QlFDeDVmcUxscm40?=
 =?utf-8?B?VHlCeW1XaW9ObWtCYy81cEh0VVFNQzNjbENzTnlIQWJvS1lIQ1ZFNUhaS04r?=
 =?utf-8?B?MlpPbTJNRXQ0WTY5dEpKV2FoK2c1dS9lQkRqT3dLNVMxOGJBeVpjaUhpVTBW?=
 =?utf-8?B?NkkzYkRvM1owaTNVSUMvUlIxUkozeldDSHhvOFdsRlBTdUhOOWgxb051bGQ1?=
 =?utf-8?B?b0ZOQmczSnVmNitJeCtBOS83bURqWC9WNjFiNS84azlxVSthNmxCMm1kZ3ZU?=
 =?utf-8?B?c2V6anh2NWt5QWtGZmUvZFgrWmFiZmE3d2I2bFNpc05WMjFWei9maTQ2d1dV?=
 =?utf-8?B?NnkzaWNSVDlSczdYSTNyWFM5RGVUKytTM3U4cERjNVFCMXNwc3pyNmpZV3B4?=
 =?utf-8?B?bHpMYzQ2WUYxcWJETXVEUkdpZnMrc05iaTFHNE5FL1lUWXF2c01kR0RxU0NT?=
 =?utf-8?B?RytuREZjVHU5cTM5OHhVSFBLampXaFVYOGkyWE5sYk1oZFh5R3ZCbk9GM0Fu?=
 =?utf-8?B?SEg1RDBvVzRIbUJYcFoxK1lVaDhleVNkVTdCQ0hSNUdzNVhIL1FSelNqbm5t?=
 =?utf-8?B?MC9vVURHdkMrTGVJZTlxNjJGS0dKR3B4bmdCTnJrQmdCdWNrQjVpdEtlZGxW?=
 =?utf-8?B?UjBTOXU4UVh3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWZzbXBrVHZLV2hRdVBQZ1BFNm96Q0ZqNGJ1T3U4REhaVXVPU0FPOHdMdHdD?=
 =?utf-8?B?NkNYMkJWYTJJOVZzclF6QjlEL2xQOW45YWgvRGYrSE5hWGZBTk1EV2RlYzE1?=
 =?utf-8?B?clZvUjZhV0ZxWjcyR2hhUDBiZEc1ekU0VVRxckhVbjcxV3lLellFNEljNmZP?=
 =?utf-8?B?UWpUYmtYRFpTaE9MdUVVRkZsRVZtd014Ty84VzN2RjUxZjE5MGhOOWc0SHVM?=
 =?utf-8?B?d1E0ZGdlUXduUUtVNElJcHZZNE1BZ05waXNmbkJOQnp2V2dSS1BhMmQ2bjcx?=
 =?utf-8?B?Y04xTnhhc2d5REYxTFhqWTUvUU9najFVem5nNDA3b0txejlkYWtNQytzakdE?=
 =?utf-8?B?b0szQkRVOVE5c0JSeUFjZy8ycThMOXQydU9aWlgrMDZPYlMwRFdxdFNlZWVW?=
 =?utf-8?B?b3RlTFU0REZsSmxnOU4vYWE0UXhWSUZEUEpEcy9aMVZ6ZVpWYXFFbTA0TW1O?=
 =?utf-8?B?UHcyN0I2dGxxZ0NhazNkaU9FRSs2dGt5NzV0bXVrSjZ6TE9CMG1mNFgxRXg3?=
 =?utf-8?B?M1Q4cVl2VXUrWmtBLzN2WVBpM05hVCtWVlUrWSttTm4ySkFNbXJYWDNBVEp2?=
 =?utf-8?B?L05NWnFQOENsNFBJejlhN2xWcWhkTlB6OW9adm96cnhjcEQ1YlkyZ1k1VHVS?=
 =?utf-8?B?RThYNTFpOTNzcXQzOUZXVzdvWjFvUDdEbDNIb0xxOFVMZmlOVGpJTEUvdjN5?=
 =?utf-8?B?SFRLQ3hKUW5WVHVaNFE0WVU3K1YxeFE1anNFRWV2YllVelE0QVhKcXN0bXdl?=
 =?utf-8?B?eU9TVldDUnBpcVdLalBLK0MwR3ZwSGxkMHZQMThLNnZCdjhzVXNjOGpKVjU4?=
 =?utf-8?B?ZlRQN2NWQURadlpCUWRkZ1Fkbno3UlYxRzRmZkxxcDZMUDFXQ3VISFF0Y05K?=
 =?utf-8?B?MFhxVjJPUDNCNmMrOUhHYmdPNUFhaEtlUmdmVER1Z1htR211SFZKd1hwTWFk?=
 =?utf-8?B?Yzh4N3YyV3ZMSUlwVzVVaWk3eUVqS05yQ21mUGtYNXBrNCtCditRb2E2QUR6?=
 =?utf-8?B?bFFMUnpjeG1PS0Z0d1F1dEhnNVpNN29iY3Nld1kxd1VGbXN5aUYyd3QyMzBv?=
 =?utf-8?B?NTR0T29XcEwvenNLNklzbEl0bmJGSDR4anZMMlhLdlFNWGo2eDY4OWtYNkpm?=
 =?utf-8?B?Q0VwUE9UNDlTR21ZM3pNVWpzaVdvZUNiODU0cmZpVnVBbXZrR3BRZ2RMb0Y3?=
 =?utf-8?B?bEVOZUxWSmd6YWYvaDk5T0JZdTRjZDlSbVBIcmdPRXRBaVY3empWQVJkd3Jr?=
 =?utf-8?B?cmRGbFhSS1JBQjRCcmtJcExVVmtVYnY4NkhWTGFLbzJITlh0RUFDK2s5aGQ5?=
 =?utf-8?B?TEVQS2U0YmpaNC9vM1VYUnZoWFVpYWZ5V25PcWJkSy9HV3BDLzVFTnFLeU13?=
 =?utf-8?B?bTA0MFE2VjQzQVR3MGRFbzREU1crOEJ4ZHVTVklWaDJ4U0g3WnZoTk4rSlht?=
 =?utf-8?B?c2hYc1NJV2FXSFlKWHpHdm1ZSHZubmdtUDVIeTEzOVJ0Z1hvTVRXSHo0WFpr?=
 =?utf-8?B?c3FtaWh1ZDBNR2RZcCtIRkh5Z3h2c2dQaTY0UnlWUUxrVUtuT0h3NnlIWkFx?=
 =?utf-8?B?aHZlVUFLUk42a0MydU95c1ZlYWxmdW5iSi9JYjdOL004U25HeENVM0dWOFZ4?=
 =?utf-8?B?dGRBOHByWTlRaWQyZmJKdkVwZkJiUDlNUDFZNC9RaW5NUXJkWm1PMURIU2p6?=
 =?utf-8?B?Z0FLZ2Z6U2xpdVJRMXE3RHQ2SXVYNjJrd1NhNitCaTNKS0puSXlncmVZSEI4?=
 =?utf-8?B?VXZCL0RRd3UyU2RaNDhXUGNPSFM0alJnS29Fc1FuUmMyQnRpZ3FDWHdtbnRy?=
 =?utf-8?B?TWZsN2tnU1gxTHN1c1dWMFc0R20vb2YrYk9xUCtsVzJoMUlaSXg5NkNXK1VF?=
 =?utf-8?B?amNOR2s4bVlRcFA5czRmY2xPaXFpRzk5T041WnNxOTVUUjdPelRvWDBjVzBE?=
 =?utf-8?B?YmJwdUxxSGVUYlZ5WU9yeEJkdktOZ2tKVFdmL2VVQjd4bGczRFF1VGc4M2M4?=
 =?utf-8?B?VjVuSG9JeDYwQmFFYVREeTdoYkNETFBkbTNhNUYzUHZ2M3JwWjhMb0doRHU5?=
 =?utf-8?B?TWxNa3lqNThZTElmcGhhRk9WRkFIdWhOMVFMSEJmb3RkNG9pdldkandINWFp?=
 =?utf-8?B?RXR2SFhEVGNyTU5MejdGNVV6SDNRaVdRaTNDdkVJQWV4b1pmcHdhUFNFY2hO?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C46EB2406DB9DF4A8A703DAAA5EDF9CF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d626c858-d590-4138-b065-08dd7dacd4c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2025 12:39:01.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ilgoMnBZyqriIiuZRZrvCdWENE5X9H/ixrgBN//KYdwEQjsVdvLlvL0sHCboaBb8iokg7DLm3Qx6S3WwyT+hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPFDD2810A4B

T24gVHVlLCAyMDI1LTA0LTE1IGF0IDEzOjIyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gVGhlIHVmc2hjZF9jbWRfaW5mbGlnaHQoKSBjaGVjayBoYXMg
bm90IGJlZW4gcmVtb3ZlZC4NCj4gYmxrX21xX3RhZ3NldF9idXN5X2l0ZXIoKSBvbmx5IGNhbGxz
IHRoZSBjYWxsYmFjayBmdW5jdGlvbiB0aGF0IGlzDQo+IHBhc3NlZCBhcyBzZWNvbmQgYXJndW1l
bnQgZm9yIHJlcXVlc3RzIHRoYXQgaGF2ZSBiZWVuIHN0YXJ0ZWQuIFRoZQ0KPiBkZWZpbml0aW9u
IG9mIHVmc2hjZF9jbWRfaW5mbGlnaHQoKSBpcyBhcyBmb2xsb3dzOg0KPiANCj4gYm9vbCB1ZnNo
Y2RfY21kX2luZmxpZ2h0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gew0KPiDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gY21kICYmDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxrX21x
X3JxX3N0YXRlKHNjc2lfY21kX3RvX3JxKGNtZCkpID09DQo+IE1RX1JRX0lOX0ZMSUdIVDsNCj4g
fQ0KPiANCj4gwqBGcm9tIHRoZSBibGtfbXFfdGFnc2V0X2J1c3lfaXRlcigpIGltcGxlbWVudGF0
aW9uOg0KPiANCj4gwqDCoMKgwqDCoMKgwqAgaWYgKCEoaXRlcl9kYXRhLT5mbGFncyAmIEJUX1RB
R19JVEVSX1NUQVJURUQpIHx8DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxrX21xX3JlcXVl
c3Rfc3RhcnRlZChycSkpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBp
dGVyX2RhdGEtPmZuKHJxLCBpdGVyX2RhdGEtPmRhdGEpOw0KPiANCj4gwqBGcm9tIGJsay1tcS5o
Og0KPiANCj4gc3RhdGljIGlubGluZSBpbnQgYmxrX21xX3JlcXVlc3Rfc3RhcnRlZChzdHJ1Y3Qg
cmVxdWVzdCAqcnEpDQo+IHsNCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGJsa19tcV9ycV9zdGF0
ZShycSkgIT0gTVFfUlFfSURMRTsNCj4gfQ0KPiANCj4gSW4gb3RoZXIgd29yZHMsIGlmIGZsYWcg
QlRfVEFHX0lURVJfU1RBUlRFRCBoYXMgbm90IGJlZW4gc2V0LA0KPiBibGtfbXFfdGFnc2V0X2J1
c3lfaXRlcigpIG9ubHkgY2FsbHMgaXRzIGNhbGxiYWNrIGZ1bmN0aW9uIGZvcg0KPiByZXF1ZXN0
cw0KPiBmb3Igd2hpY2ggYmxrX21xX3N0YXJ0X3JlcXVlc3QoKSBoYXMgYmVlbiBjYWxsZWQgYW5k
IHRoYXQgaGF2ZSBub3QNCj4geWV0DQo+IGJlZW4gZnJlZWQuDQo+IA0KPiBCYXJ0Lg0KDQpIaSBC
YXJ0LA0KDQpJZiBibGtfbXFfcnFfc3RhdGUocnEpIHN0YXRlIGlzIE1RX1JRX0NPTVBMRVRFLCB0
aGUgY29kZSANCmJlZm9yZSBtb2RpZmljYXRpb24gd291bGQgc2tpcCB0aGlzIHRhZy4NCkJ1dCB0
aGUgY29kZSBhZnRlciBtb2RpZmljYXRpb24gd2lsbCBleGVjdXRlIHRoZSBmdW5jdGlvbihmbiku
IA0KVGhpcyBzaG91bGQgY2F1c2UgaXNzdWVzLCByaWdodD8NCg0KVGhhbmtzLg0KUGV0ZXINCg0K
DQo=
