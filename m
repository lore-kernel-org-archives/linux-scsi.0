Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31714328624
	for <linux-scsi@vger.kernel.org>; Fri,  5 Dec 2025 08:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764923493; cv=fail; b=alUJD/W1IDN/tSzIihqVzlQIERPS5tifl0lgReCdxNSR2psWRA3rkB2RF0uoVQTy04EZZD9WaNH/nHtiQBMXcnyqf3NfftRe1I+TK2xiHA8K46c6oWs8DYIjQL5PkWtwOziuI/ERXjmE/mb7h/iouj2pPGepI6qGccDaul6sxKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764923493; c=relaxed/simple;
	bh=PNj8DYmgDqFKTXPkixTNojoEr9sPkMWJNVuFT0tJIlA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lfpE5FCDxF825bDzBAdXnJf3GXKpmCJdnqOUuZHms5fsebQ0r8pRhKF2Imj0Kq0/CBzkXD8Zfo/sfcXp9AN2GGo1H6/7SleUWibUKsBMkvNYwohMGIktYHe8G8Cl3N1egJrpfels9+3tjYtC+KPS4P4mF/6nFJDhmmGt2J0gcnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rNrpPWiA; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jQJZ3cR/; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rNrpPWiA";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jQJZ3cR/"
X-UUID: c6929606d1b411f0b2bf0b349165d6e0-20251205
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PNj8DYmgDqFKTXPkixTNojoEr9sPkMWJNVuFT0tJIlA=;
	b=rNrpPWiAwZjU1CfHr9axi2P+xLDWbEnJDL2gZ/hP9JhxvvBx5abEmLs0gCiwEEvEsYOPmSLfBTmfBx7oooz8DxGoOCQOnqCxKE7geCU8kQqjfIksyAy00AfnF2ouBAJ4bmA5vLk5VqJFTvdGpfrJTylto8yL1QM+iocIwgiqvSc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:37fcd016-2850-4558-867d-f0a10be1210c,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:83397002-1fa9-44eb-b231-4afc61466396,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c6929606d1b411f0b2bf0b349165d6e0-20251205
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 263577056; Fri, 05 Dec 2025 16:31:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 5 Dec 2025 16:31:19 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Fri, 5 Dec 2025 16:31:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tK6/ZiHYwpJo4Os6OyvzyeJkj2JyIPkb3HRDoIBhXjJu9lMQaa35OJ5Sld0FJEzTUBYJpm+FhZ8x8p+eXG8t6y1VMJq6vH3nuoP5QU33doL6TGQloqh31R5LRSBSeuVhRl6OzOdXDgdNHfEpgWYWfo95A2M/Weqz57h47FvSXlEAcaKgsOjYgFwKTS8IHOQyaW+OzH6YMiRAJOzVL29xFCEsPJwqPKZm5UJqt1DcNL+GLdgx6yE+GfYvU8Np6WQV7OI35Y/yUdsSoJ7t2OhATgkRA73bFqF7t3dL/zuZTIM+JaGbDyCDR8upbSlTy5IHr5ExErYkpzN/Tm+uZYCstg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNj8DYmgDqFKTXPkixTNojoEr9sPkMWJNVuFT0tJIlA=;
 b=lZo7AJXFiHfddpPlvOJJ3HyOAd94Yo6gsfO6ZHY6DkFOgLGE93Fx5C0Z9G4rO8GLYVZw2umCKbMuEUUbkCXq/v/ZRjFZg7D4m2/MMmGYH0zGEsjwuJHYisvJiXZ/RWlumercqDWLZgUj4imYsVVu6mSk9VPwW04Y3NYD7FE1c72PAe2+v2GEX/B1BQW5Z/R2LNmqdDBTK3KTmFcHLBtrDd7+ewvv57E2sA/4sYDrjoXhLIl4xqtxZLezj01Qa3PPs3wFvMrpvkSyoap4x26r+w/dKZjHPGrgXRROcvYl9v2bJqxKGLXAHC54D7IdOfxYasSr7VErEs7BTZ1nmORHHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNj8DYmgDqFKTXPkixTNojoEr9sPkMWJNVuFT0tJIlA=;
 b=jQJZ3cR/jfrxmziJnG0x684JJBsFzOPIIgARCtZw1qxYYrsVLqTdCTqAwVsrSzVVVJPB+ZoreJcp/3aJDlo2HELaGQV1YDkolVKHwJQ3HAXqJCYn2UbkTO4hDHj4/2S2N9cdu6/UpWarUecOlyOoVEt6jsmro8NPKY119QeMMyE=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by TY2PPF94EB25A41.apcprd03.prod.outlook.com (2603:1096:408::9dc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 5 Dec
 2025 08:31:14 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%2]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 08:31:14 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Fix an error handler crash
Thread-Topic: [PATCH] ufs: core: Fix an error handler crash
Thread-Index: AQHcZUA574/lGF7xqk6bZGDhfLzhNLUSuIeA
Date: Fri, 5 Dec 2025 08:31:14 +0000
Message-ID: <14cf8cdad876f68d59cf487ae16ce561458c403e.camel@mediatek.com>
References: <20251204170457.994851-1-bvanassche@acm.org>
In-Reply-To: <20251204170457.994851-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|TY2PPF94EB25A41:EE_
x-ms-office365-filtering-correlation-id: d2c2d380-71ab-4400-a4a9-08de33d8a702
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M2pUMVpRUy9LTFIzZDU3WXB6N3p6ZUpicnhBckZjZ3pORXBmSXNvSnRmWFZl?=
 =?utf-8?B?bXVHUkpud24zcjFSS0w0di9ESVZPVDVOUi9vQzl2cngzSGRqR0NweHpJVWl1?=
 =?utf-8?B?Vko5OVNjRHlsckR0dTQ3eUxwU0FpOTJCb2JWVGk5aGZUWlJldkZPMWY4V0Fs?=
 =?utf-8?B?SWRKbExyRUdRKzcvQXVEakIvbi9QRm1tRGdkdWdrbEdIM1I0bGF6L0Y5cCsv?=
 =?utf-8?B?NklveDYwK2VwaXR1UXBtdDJGL3JSRExsQURLbmxBN092QkkxNDZmT0FidVlj?=
 =?utf-8?B?Y0JzV1g4UG9tRmJaV3JBQkY0M2s3RkFJc2FrSjQvaktSbEZDTWx2MGN0elpv?=
 =?utf-8?B?cjhaZGhhWHBSaHBDMlVWeUFWZkx3VllpcTBsd2RMWnNlT1B5K0lvNisvb1BP?=
 =?utf-8?B?encwanFhUDN6K3lYNWhlMXBnUjE2enl3VjYzODRUQTBSeWhKVTljaTRVV3Rw?=
 =?utf-8?B?V20vRnlNeVpLeW85WmkrRi9VbGR0U3pRZnlHeXVDK2pGS01QVHczR3lsN1JN?=
 =?utf-8?B?VVFKdHJuYzZQNW1UOHYrbFBYUmNoQXlVLzhUSXdZeStvOHRQNEQrelVFL09G?=
 =?utf-8?B?aVZSL1Uxb1pRYk9FemZhSGVNWWRJdUowVkVrenFjaHB1QzVQWklCZHpCRytx?=
 =?utf-8?B?b2pnSElLeVNNQyt0bXVvNFlkN1NEUGl0MURGbXhhVVVGZzkwYlIxdjZOTmpr?=
 =?utf-8?B?UmtySXNzMmdlcmZhUm5NRXk1VGR4b1dzTm5SaVZ4TGlGWXIyVUZtanNBOFl5?=
 =?utf-8?B?aWU4TERFQXFVS05CUnhkTWtwMUhiVHdsYXJzN09zallMa29xUEZqZDBtSmJP?=
 =?utf-8?B?YXliK0x3bFZUYVFqOCtDUElDY05uTGVqaVVrQko0TUNaSXFWRlJyRTJBc2th?=
 =?utf-8?B?dWtyWmlDSXdJV3ZtU1dsbG9Qa1Q4bG5OZEZaTHRYYU4zVXNFVHZRK2tMZjJp?=
 =?utf-8?B?MWRIV1l1R1hCZ0Voc3FiUkZTbExWalJLb3pubUF3K0ZGelY4NzFaV0FYcHl3?=
 =?utf-8?B?NC9Yek5GZU4wcmlFV24zS1hBVGdVOWxjRUg2RWtQN2ZiWlYwOXBRQjdneVdQ?=
 =?utf-8?B?Y1p0cEF3SzQ4OUJ5bHRsY3VpSXBnUXdKRmJRZWlmQTc3T2x2R0tQd3pkc1p3?=
 =?utf-8?B?NG5HbGpoOUF3SHVXd3FkaTFrSUVhZUlnK1A0R3RLcndmVzNjUWRCWUVCVzA5?=
 =?utf-8?B?N3ZyRmJ2dkhCSDR6OWQ4S3RzVzZmNGxoZGJvOUszRm9ibW1nZUdpZHB2ek9k?=
 =?utf-8?B?RTdydnZHMHlRUXJVQ3ZlYUZxOEJ5bUJlU3JVakRnZ0l0MWRWME4vd0NXY0M4?=
 =?utf-8?B?Nko5cmZHTEVCclhYNXI5SC9DVXBqWW5JaTlCZ3VmUFVsK3o5bG1abDJpbEZl?=
 =?utf-8?B?dlRjczFKUmplMG43TWRqMDZiMXJ3eDUraTR1bmlFWUdyaWQzN3lPNkFCMm1U?=
 =?utf-8?B?N3F4SmM0clBsalY3T3BJbVZCa1MyYjdSUVhqTXhlU282QURsRVF0RlFvQkNY?=
 =?utf-8?B?dTBkckF0SXJvNmx0UmFXMXFOTngyTW5idmtKUnB0SEE2SDNNeGJVVUFWbngw?=
 =?utf-8?B?bHpRNnlqWldoVENwR3dUMHB2NEs2eDB6WFkrV2s4Y2RlT1k0YS9NcXVKZjg2?=
 =?utf-8?B?dmpEVm5RTHlsS3VocG1Zd3lqYlNpcitmNmMwNUpibExTVi9OTmY0SEcyLzla?=
 =?utf-8?B?Q2dNajFGaENIMlk0ZzVmVG1DN21vQjZsOGg3TjIyaGpHUnB5VFVMODg5M1Yw?=
 =?utf-8?B?SkhocVVxMVZsWmRYTTA2NVM0c3dhTW5CM0pvK0VHUUhOUkRlbGtCZ25WRDFN?=
 =?utf-8?B?dnMvcWF2STY5WjF3VW5xc3ROemcxOWRQVFpDRVBsRFRVV1MraUU3bXBLdWVr?=
 =?utf-8?B?R05xNFBTMWdvNEdTa1ROUzdxUXRjRDB5b3I0eVMwTldFY2FZMkNmYktPQzBW?=
 =?utf-8?B?WnVQUWRvRFQwY1ZINlhxYUxacWRrbzlVQU5HT3JNcHA3VUJJM0JiVUloYlpq?=
 =?utf-8?B?ZnRFUU1ldlBUSWxuaHFMeWl4eDllUkMzUk92elA0dENleWwxWGF5VVNEK0hW?=
 =?utf-8?Q?pkePeg?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHpWQkNIMWVlN1pJS09xd0VrQm9MREtLNzdCNjhpRXlpRi94MWRTamM3cW1R?=
 =?utf-8?B?ZXcrS0NQY0tQMGhjZldUVStDeU85NHpXVlV0b1lhYTRGUGt5Zkc4SVpvQlNL?=
 =?utf-8?B?Zy9ic3lnTE43Z0FCR3hlMUZ5Y2xOeXhocHZBa0JJUUJZeTVrcEFmQ1piYmRr?=
 =?utf-8?B?eUVZZmZOazFVd2l4UElDeEUxcHB4Y2VKMHdpTldSYnl3dEZ3UjRkNTFEdGdU?=
 =?utf-8?B?eUxiUkR1b1VWSkhWQS9obU5udWUyUWpYNUltdWlDZXd2SkJOL2VWRXRVOFBN?=
 =?utf-8?B?cm83UStmQ0Q2Q2dwUjE4cWJaOG5qMzZzcVNQVFhQZ3dxTzY1WENROU9kU2Vp?=
 =?utf-8?B?Tm9LL256UHNjMVZFbkVQK3JEdytxMVF0Slk5TEtaZlNPeUZ4VGVyUWVxeGU1?=
 =?utf-8?B?VEZQUVdZREVlR2c0NnpEWTVONm9CWHZoUlBlYnY4eWhnRjFHVTN3cnppTENN?=
 =?utf-8?B?WWNjbUdJWXhPTzFJNFV3aUVvR2hnL3E1TEQ2ejE5VHZ6cysydUN2NFl1MVpP?=
 =?utf-8?B?ZVNseEptdXBSQmdpRWx5WHUzcVBidlNxVXVEZ3pCUitRNlR3NjRVNGNIK0RH?=
 =?utf-8?B?V1piNDVIUEZYazkxUUFZNEJzTWVIUXZ4UTJoVFFOYnMwRHkxYS84a0loUTF5?=
 =?utf-8?B?Yi9nNVlUWlVidS9RdzNSNlRNL3YzYmFpVDVQU2dWZXVZTWRNQ1d2ZDF6YlU0?=
 =?utf-8?B?RXZWVkNRcmNIQ0VTUWM4eFp4R2F6Z1pScG04bDBSd0FPVUhpcjhZNzNpdTll?=
 =?utf-8?B?MG1pQVhXT0srcllmNStseWVHYXoyM1NWd0llNmd6d2pKd0Q4N0ZVWWx1aFRD?=
 =?utf-8?B?NVZmdC9DdjVtTnAyV2paZXdseklsK1R4ZFBhTlVzc2ZQaVVTQUlCQjl0S2JD?=
 =?utf-8?B?OVh0dEhyZDd0VElDS1JJUGx4d1gyeXRydGFTTTZJZWZlTEVrcklDUVBDSmRa?=
 =?utf-8?B?Z25EYkplS3hZaFBOdktJWVdVMzRlakN5TWJnMGN1YVlpZjZPVlM4UnJKYUda?=
 =?utf-8?B?Vi9QQnB6cmx4eld5cU9QcDI0ZHpwSTU0RnNBRWErZm1wWlZzdC9majk1cTBr?=
 =?utf-8?B?dWJXWHd0UjVPZkhuNnlyKy9zTUlTTW5ZdlZibTJyYkVzTFZ3SGs1VHJ4TUoy?=
 =?utf-8?B?bjl0c2NQTnNNTnJsNFpWZGdFdGN2MmFIZHpJMGI1TVd0cWxQVmc5ZW1uUkdD?=
 =?utf-8?B?TVM5YVZJSlpEVGNiQ1ZMcklJTFo2NU9Ha3ZQd0N5dW1XbllSWU01eW5hS1pk?=
 =?utf-8?B?NVMxOExSUHZSMUFKSWVWanhyUTk3TGN0VWxEdFk4R2pDVVJwMWFReC9jdm9J?=
 =?utf-8?B?RENpcjRpYndKWUdJUCtKQUc3WjNCTVc0Rk8yOTRnV3R1K2NyZUhhMmhST3VT?=
 =?utf-8?B?QmFqVXRjTFhleXA1OUhJV0oxY3h2Rnd0aTZ3YlhNWFdKKzdBWmtMeFFlMFNO?=
 =?utf-8?B?d3NqMDRWWGVaK3BVOFQ4NDVZb1BvdlpzY3hjbUNkNzlqSFhyUWQ3YmxCaWxD?=
 =?utf-8?B?MFVMenZmVk1RTENHWXNldldRQktYUFFEditQc0hxeUhZVGxLNUptT0JscTV0?=
 =?utf-8?B?emp2Q0hESC9Ha3lYd3BTWHZyYk5YMlVNdmVXa2dmOVo3UStqd29Ua1FmL3Rx?=
 =?utf-8?B?eTkrcE9mMTV0OVRwK0dDU0UrT0krY0xhbzU3TTdxdXZmR1ZHaWVodWZnK2pa?=
 =?utf-8?B?YVkzd0dkSXJ4b0gxY0xTT3NMY1U1bWZkN2psaTlqWXNyYVNCOU9nY0ltNXFj?=
 =?utf-8?B?VGI2YkphZXk5YjhJUGRULzRKN2JIeXdzTE5BOEYzL2FxLzhzK3VLaGVXdEVl?=
 =?utf-8?B?dzZSclV0SnNIY1ZUZmZFVFpscHk5ZU92SWViUkkwTCtEa1FvK1BZdTFaN0dT?=
 =?utf-8?B?bm9WS2srNmZMK29pZVFQNzduZDlyUTdXKy91S2k2UlNNcmMrdjJJNUlJdzh0?=
 =?utf-8?B?KzlXQXplTExZemJLWHVNOEI2WjgvTHl0OFBUNWtsTkJjZGlHcEV1NFlzajRx?=
 =?utf-8?B?aytiSkFMZG9wQmNCMldJMjcxRTF2dmgxdlNySFhGbHEwNktJS3lUc0xtdUFn?=
 =?utf-8?B?ZzJNcUNUUE4zNUx5QzdwemtpYjVvR21zazR2aElhTTAzbmlibkJNQ0x4YmNE?=
 =?utf-8?B?eGtKTDVqMzhrcVFEV2VtN1ZzNzNGS3hjVE9hdTJVS1g5Q2NLNzA4a0h4SWYw?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71367819FD4210418CD870DE520004B0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c2d380-71ab-4400-a4a9-08de33d8a702
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2025 08:31:14.0778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /sIIIIA7S6VYF3DND005lRpnxMIQsj3yKhr1urNbP7S4c+Li2uv/nLN+7tZATtuPMAzFpxD8PkwF1M4nGO+Tig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPF94EB25A41

T24gVGh1LCAyMDI1LTEyLTA0IGF0IDA3OjA0IC0xMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZSBVRlMgZXJyb3IgaGFuZGxlciBtYXkgYmUgYWN0aXZhdGVkIGJlZm9yZSBTQ1NJIHNj
YW5uaW5nIGhhcw0KPiBzdGFydGVkIGFuZA0KPiBoZW5jZSBiZWZvcmUgaGJhLT51ZnNfZGV2aWNl
X3dsdW4gaGFzIGJlZW4gc2V0LiBDaGVjayB0aGUNCj4gaGJhLT51ZnNfZGV2aWNlX3dsdW4gcG9p
bnRlciBiZWZvcmUgdXNpbmcgaXQuDQo+IA0KPiBDYzogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0Bt
ZWRpYXRlay5jb20+DQo+IENjOiBOaXRpbiBSYXdhdCA8bml0aW4ucmF3YXRAb3NzLnF1YWxjb21t
LmNvbT4NCj4gRml4ZXM6IGUyM2VmNGYyMmRiMyAoInNjc2k6IHVmczogY29yZTogRml4IGVycm9y
IGhhbmRsZXIgaG9zdF9zZW0NCj4gaXNzdWUiKQ0KPiBGaXhlczogZjk2NmUwMmFlNTIxICgic2Nz
aTogdWZzOiBjb3JlOiBGaXggcnVudGltZSBzdXNwZW5kIGVycm9yDQo+IGRlYWRsb2NrIikNCj4g
U2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQoNClRo
YW5rcyBmb3IgZml4IHRoaXMgYnVnLg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndh
bmdAbWVkaWF0ZWsuY29tPg0KDQo=
