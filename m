Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0682035837E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776760956; cv=fail; b=CrM6fdwGBg8gH0mNgcqcGA/DKFjDA+yUauNA+PzQZISBr0G22+0ueV6JWrNvTQAtI6AviTG6lsnLCGBjl45cb0QafGuFcyWbZ5fq2DXkuu9U4xFyEcXEPtrBDs1OVvuHmo6FcxDo5YxCM13cEjnifPC1WDhGR3/8p4lwPxFYeb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776760956; c=relaxed/simple;
	bh=ibXZEjelEPAtJY4Gx9ea68UsrOa6roL2su4qB86f1a4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MO6sshkBvZVeOEXQGv1mKlQs04lF27pN/ARsUsuTUtOhZK/Jmdqt8qI3QWvKpXCXeF6DTUyIfOlSNLWbSuANZVgi1jMsew5eUWjqyTGyEGZiGm/U1nbB62PjbonlVb0AaA9HXujGzVvxlBKsL909oFa35gFAfH6VOkT6M9qJhxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=b5YP65yD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OUN2VITD; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="b5YP65yD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OUN2VITD"
X-UUID: 06b91e163d5e11f19a16598d5ca7f8ec-20260421
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ibXZEjelEPAtJY4Gx9ea68UsrOa6roL2su4qB86f1a4=;
	b=b5YP65yD6Ye4ivK2K3UzSwWbGiI3FMF6RvGoWKrXRZuoBwFJssZFG9um+K5Xq0bN4QL+xtFivWkdguJ+tqO8gemjgr0GRtInVRzi2tW/CD5OsYcc/cy9cUHGxHNC5lmyXpQE+HdkC2/PjvEvIeVKN6aWL3eyXlDb/trDnlsIlOA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9eabc3d7-c9d7-44f3-8b1c-7a27cf5a1fa3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:d7cfac8f-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 06b91e163d5e11f19a16598d5ca7f8ec-20260421
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2091571266; Tue, 21 Apr 2026 16:42:27 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 21 Apr 2026 16:42:26 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 21 Apr 2026 16:42:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xvaJvyu0RH5C2eZ4XHJqTIDpINIFYJ3mMEUbL/zzeUprmnNmJm+/2Ehyj+Luw83Mxgkh02DaWpCBz/wbG39KBrr9IY5j2OYtWccY0wjSlgbm3dBHbbS41e6rTWlBglrgmhjGYy5Tn9v5ZycNLRiYd7dDw7jL64x/8cywcgMCCjLsA9s3qYpXSgBj3HN8kRLvH/R7NYpF8p5/EB2FebhAvzngZz7hAjyo+pluO8Dgik5MhBpkPHjjd5GhFWrVznp8SImOD3Z75E/J7qtJt5BzyT/eG1fJFTWQ2QuZfpQnD1iE6OH70m83r6zSeJyrujRy9objTD/mFIYKvIVR/4QWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibXZEjelEPAtJY4Gx9ea68UsrOa6roL2su4qB86f1a4=;
 b=jc/dOtRpHmEs6FARKFjFJ2QuSAFRpGNbW9pemF4oFcQGW08qCQaS2+IjLyW1cjHYv/HQPWG4AdT+ujXyCkNB0kjZDGuHlQRVPa4/0mG2Je1xFP9uIiibz54LHM4/UbFjuuaQBsnFv84DPeOWkd9DaxfWFF1oGoYKc49q2OT80gO3IgCBNQ0hqjx2DMLm3+flhTHf37ttNv07z6H//chCip49Ah+9IhCcbMnSEiANcIi7LTATlVtH0gXFQUEtcZdBpWHtaRqvVA8Dob1z8pBkQgcTZPVIj9ZC5Ia1sDIgIbLuzxpOHO1+8yHYWg2HeNDktq80eXA66BZKw0B3D7b18g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibXZEjelEPAtJY4Gx9ea68UsrOa6roL2su4qB86f1a4=;
 b=OUN2VITDDPg9rgDJqkq+yr7+/KmapzuFXodVytzDykH17gS39B3q2/+HfaJrRQeQtKVU3lQAn9N2PWmkXQg93FPuRKvwLYJGqfLi1l4gIg+BDreUEH+T1AaU7eXfFgVp80M5FFQHZ7YnGbSrfc6BvVSIA3wm3aJYAQuHZAosa3U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8210.apcprd03.prod.outlook.com (2603:1096:990:48::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Tue, 21 Apr
 2026 08:42:23 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9818.032; Tue, 21 Apr 2026
 08:42:23 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 2/3] ufs: core: Complain if UIC argument 2 is invalid
Thread-Topic: [PATCH 2/3] ufs: core: Complain if UIC argument 2 is invalid
Thread-Index: AQHczrGKGeZrUpdcUEuoKN2Zd8FZ0LXpOCiA
Date: Tue, 21 Apr 2026 08:42:23 +0000
Message-ID: <2191762e786406159dc89d32b932d8f18dcc33b7.camel@mediatek.com>
References: <20260417213027.3506742-1-bvanassche@acm.org>
	 <20260417213027.3506742-3-bvanassche@acm.org>
In-Reply-To: <20260417213027.3506742-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8210:EE_
x-ms-office365-filtering-correlation-id: 2f8a2eb8-aee6-423f-558b-08de9f81e8bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: QITYzOTcRF9Ylm2jdkfmqOTQwgXaXjOBge7sNIUMYJ8bC7x6ZNUr5NMdre/xPxzGkSxTuXfF1Q2WrY7QBJ4ygpd431noTkLS8uELt4BQLizHxzRB4BukwM9zk/AFz6IPNovF9KULiIe3G6LdKblJhJHF5c17vmP6W9i645x8W+j/nCadXsoKLZTTEuu0A6bBGPrzLY4PEi+P+cUA5wyL/70qsOpv/+S57ZtEAdVR54mTRx4cQtCtxUSEqJbI5Mo2JSLyl6PphV3u0EXUZ/SIezdGh3iqx3K5ixuwjhqnYWTU3K2Mk92giAXTjt0QV+hISThWCpb9twasyHBB+QX/Xz3Au4SmS3Jl89CK7QKK43jVziA1BEh65Lm9EwRw/1jKvjxa3ePYAE6F0G6ukurjckjsqZeLSbIS5LFXNvJJrXOYUhZPAdo8WoZ6Rzc0vJiPWDEyY7IyoXbazr+pNc/lskC0RT+UNFNp030pRmHD47l11AYmD3M74eK4vTh1sE/IA3GvtiuiM7OCOJJwUzKK1zpUGIWAvKbgbbKsgGsScUu5I6u8Ei/UmKpXZrZo32iskip7gVLaIK7NM2cXwUXUA+NOmqPaOj54JXUiON629sDdDmpGrQtOpWp5DG3qBPXjYH/yr94g1yhYLlDYQ2dwjzf5AEO+CJW8Ch+m7fp05d5D0RujJwSQUCETH6LgLevEOjRIVEBF11ucx6Km8mk6dsABUZ/w+vmgcpI2/Y2CQhYh4+eRFKW9wzquC2InzW01xVrf+Us+1rXRec+eHU6++IeLZiBIIDDmyIChQC4ZBQk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azdTbHNjTzZCU0RuZyttRWd4VURXMm1PY0QrWDc4eE5ONUUrazRUTGhQdC9X?=
 =?utf-8?B?TE9IRURKYVM3SWlvUEk5SkQ3dFR2amIrK1dKeGF5QWJEL3k1eWlydjNCZWxw?=
 =?utf-8?B?K28zcFliMDR4cmd1UXZjSitjaTZvQXpSVUVOSTdqK3lURVNPVFBFM1JjTUdu?=
 =?utf-8?B?UzhKQ3RIaTNUcU1xOHVhckFBYW5MNlV6WXV3dzNXVTA5YjZianhGVklhcVlC?=
 =?utf-8?B?TGRxYW1XaU1LQUJnNWZycStMa1pBc0NtSW1SYzlyaHV3VklHdDljYXFCWVZT?=
 =?utf-8?B?NjVPVGVQOUlNVHVSdk03U0VQeDVrbEg2Rk55Y25lZkJ6VEJJanpVUGh0NER2?=
 =?utf-8?B?SU02ZU9IQ1pLaE9MaW1ieFZsRlA1QzNTcUkrbFlxbTVPLytZT0JsNFRUSDNl?=
 =?utf-8?B?eW1UNkg4SGpOMkU5cU1rVllFZHM0dGRkRXQ5TWtoVXhGS1QybkVHV0JqTWRJ?=
 =?utf-8?B?aGc1eWIrZ0VJY3JmN2V2M3QyWlV3TllxdVNwR09NWWpvOXdWQzBUVS9DYWhK?=
 =?utf-8?B?Mk5GRzVoTGdLK0k3L2U0S3lUOWNNQno5Um9QL202ZEV1MVhjck4xZ3FrVGpo?=
 =?utf-8?B?OTJodnhieUxkeG1aaGlBNlVDaW8xcHdyMDh2NHpFaTdQYzhQMSt1L0hSUC85?=
 =?utf-8?B?Rm5BRHU2bmRpak8yMTRyb3VBLy9UeHVyWEFHVjFlZkk0Rmk2d29JajZLRkE3?=
 =?utf-8?B?SWJ2UnJIZ1IwU210eDdZUFZ4WVAvNlFXV1FDZFJyUDNQWnluWU9mWjVJeU91?=
 =?utf-8?B?anhYWXB0MFI0bHA0YmlTeENSL0hlSDNzUGdJTFZNNnRReFBGWjFmY1VXanpz?=
 =?utf-8?B?WjBYdFN2MzdQN01rTi9VUDNaMC9oQmg2VGNXbkRHZ0RXMkp2U0NzQUN3NFha?=
 =?utf-8?B?dnBuQW8rc01GUi9nYkI0blBRYWZSeDI2ZktKRFVzUTU0UVFMZktYZ25EUGd5?=
 =?utf-8?B?bGNhNTU5bk5MSDFia0t1bEJFcVhPejlyaVFQQUs3Y3p2ek11QXFhRFc2M1I0?=
 =?utf-8?B?ZEVLNnFuYkdHOHljMW00ZS9pMGswY3dVRGpmUkdDQkdvdVFVUWlpdUk2WTVH?=
 =?utf-8?B?cmFFek00WVBFTWZOSGhhNVF2bFl1VDk4TE9yZ2kvNndjKy91NVl1dDdDTXps?=
 =?utf-8?B?UE5UbC8weGNPcGcvcjlDOHlIdWl2T00vWUxhY2Q0dUZGaU5KRVlzdHpGWnMv?=
 =?utf-8?B?am5YT2ZIU3p4RjFweXpKS0xIS2VlcXh3eVprcjUrMnB5OXdXSFByMmdPRWdz?=
 =?utf-8?B?TDh0WmwzMTlEVklCcnJxTjBTVXJnblQ0V2crenp6RzhldE5NVGxqYlpvcUFz?=
 =?utf-8?B?N0ZLamNmVkFBa3hIVGUvQnY1VHhrZUk5Nk42akdNSkJKS0FoNjlzWUtIeDZ1?=
 =?utf-8?B?Z3lpdmo3REd3Z0cvSDcxSk5qcWI4a2MxT2owYjg1Y3VCQnZMekVWdThQa294?=
 =?utf-8?B?VHg4TENZVUxqcGVzcStsR3hlckc5UHUybWgyWHdORFRBSSttZTk5NzBsZWdB?=
 =?utf-8?B?Z1lkTldNZFdvUGoxRThMb2lFL0hJMnBqUkhHYUpRdlhTUEZKUGFnM0RPd3lj?=
 =?utf-8?B?U0tnMlpFNmJEZGtDTHo5VzJVTGFEWHc5Z20xLzdwcWRQYlU5YlpuL1p3c21v?=
 =?utf-8?B?OE9WbnFLS3JGaU1UVVc3ZDhOSmRIbG84R0s3dmRrRDk1NzB0cnI5M0RWU1VE?=
 =?utf-8?B?N1BCQ3RKdXUvU1ZNUzJaRkdpZERON01jb2pFazhVbEkzKzlGcXVFdTFwL2ZK?=
 =?utf-8?B?amloelF5c20rT3h2ajdYT2laVlMrWmpyVE50WEhuQXZ2d0pQWEtZRHFkaXlP?=
 =?utf-8?B?dThwZWYvakJmM0NyVC82YjNUT1g1ZStGQ0U5WFlFVEw4QXRBaWtlTnBFU0Zp?=
 =?utf-8?B?dTJOdFNDWHI2eEhvVUdLd24wU24vVWxlZTJaSlVUb1dUREZqWDdyRldZeXEv?=
 =?utf-8?B?K1dXL0VaZjhMNUk3Tm9OakhSazNWa1ovcGI0MFM0Tng3OWxweTZMUkMwSVMv?=
 =?utf-8?B?QUpudEFHT3Y5SjMyU0xneFloenZFdGE2SFhobkZ2czByRE9EWktWaVhCdk4w?=
 =?utf-8?B?TVRwdGhnajVjelp5V2hpWENCMFlNbCtDYzZrdy9ESkJ2TzZibWU4THM4NEZl?=
 =?utf-8?B?QXMzeXVnbEcwendXek5jT2M2Y2w4ZFJPbzhXUUoxdFljTVZocXZrcVRNelNn?=
 =?utf-8?B?NW5HV1hrbVpZKzhCTVdzYStTV1RxdFM2K3QvblBSZFRWSjBBWjRrU1VFU053?=
 =?utf-8?B?Q2lmb2NtOFNDdE0yVnpoV00zMUlFazg4amliVENSL3gzZ01tRmhiSmh2cXJm?=
 =?utf-8?B?T2MyK0gwQ3lXeFVrTDBaTlpIdHo1VHhHUjQ4MDdSMDJFSDRiZTI2alNvaHJa?=
 =?utf-8?Q?Jb0hmJI2zJla15xE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42398769B20EC843A6B7B352C0509F5E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Q82ibc2WsWeQec5Hq/Y8VHq1EwETysA6cqHrHGi4qzg5i3JDVH7YKtw/tHAqA3Q2FdUgfqH+OhAXi0h/cKprZXtTuHbooeyEFuNKj/Lbceg7HM4D8NiLoOvRUHS1GHtuh5pc3ui0YCQzCVx03TI+A7rodaHdSSs9nswlDik7TUjib3epotemhYlGQg7vySusaKINF/RKdOGn88+vYT5LyPx4wZlDUMlXqE2xV7AxR7n3lr2kuj2+JOb+nUy7UOznK+zKU3BVdZ9wRgpihhN4Fsuq1KgDhBBimwaAMfSFt7+LLrXv6boQ59fBjADnOSUq+V+shkjmMM2Vk3tLGt3xmA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8a2eb8-aee6-423f-558b-08de9f81e8bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2026 08:42:23.7093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TR25Rz53wiMcT4Wr/CnDkFLkROQckZXoSO1DBZeAZokpxW6pZJTHdW+WL0lDpbjQS8pFaIJ4RZXnlcr72F36vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8210
X-MTK: N

T24gRnJpLCAyMDI2LTA0LTE3IGF0IDE0OjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEFjY29yZGluZyB0byB0aGUgVUZTSENJIHN0YW5kYXJkLCB0aGUgbG93ZXN0IGJ5dGUgb2Yg
VUlDIGFyZ3VtZW50IDINCj4gaXMNCj4gYW4gb3V0cHV0IHZhbHVlLiBBZGRpdGlvbmFsbHksIHVm
c2hjZF91aWNfY21kX2NvbXBsKCkgaXMgYmFzZWQgb24gdGhlDQo+IGFzc3VtcHRpb24gdGhhdCB0
aGUgbG93ZXN0IGJ5dGUgb2YgVUlDIGFyZ3VtZW50IDIgaXMgemVyby4gSGVuY2UsDQo+IGNvbXBs
YWluDQo+IGlmIHRoZSByZXN1bHQgYnl0ZSBpcyBzZXQgd2hlbiBhIFVJQyBjb21tYW5kIGlzIHN1
Ym1pdHRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2No
ZUBhY20ub3JnPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdA
bWVkaWF0ZWsuY29tPg0KDQo=
