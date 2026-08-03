Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2F636B91E
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760757; cv=fail; b=WY1NQVp/GGT6R/RAfESmYHMdhHfVknSlEZCvnNkkryKnIKPkM1D43YTpdBnaIURGe9JGCf+epzE3qDu33FIsA6sEmjulkDSM45ihO1VYJ4aJ6SY/JZIVi/LJjqbru9Msw5iR+sqE8kvKMB77CUlkttcTZr39OdFc6tdst9uSWCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760757; c=relaxed/simple;
	bh=XJfYSxtwggVhJE6PwMYZRLxA0cIeu56uV6okZ0gxEVo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dHh/8D5c5TC8EvgN3UDuZVMdG2WZ7jch6sG23MqVMU/AA7O1xdTedzur38rNJXr80EiOPIAzA0atiXyG5fbIZkj1xoU9uup0rWHR1mHWBR/cp8lxnZy/6dGWKcYIsVvT4xHs+KrdZ2QH7gIdLs7upLKJjzUOWrx5ziP5bysSN7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=N/ynvG9o; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=D9g8R0Ws; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N/ynvG9o";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="D9g8R0Ws"
X-UUID: 4f55d0848f3811f1b1788b6acf885367-20260803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XJfYSxtwggVhJE6PwMYZRLxA0cIeu56uV6okZ0gxEVo=;
	b=N/ynvG9odwkmM5yxDjQTj0/MexLBBU+TyRSmnS/NeaHOSADArK+BlTJwv1GJgd04f0LE1U4k4a9IwVYPHSDbQD17EaAAYf25f0DJ8ddudHyu1DqeyHdWd5CvEDZledHKs10whsvySSiV5Cdc3Tq9kEb8xzqaXRLAsDrz5ElE0L0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6ae46216-101c-4bb8-adf4-c5cd22e0530b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:60279ca7-8a7b-4c49-a0c0-42d13e7adac0,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4f55d0848f3811f1b1788b6acf885367-20260803
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 168564259; Mon, 03 Aug 2026 20:39:03 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 3 Aug 2026 20:39:02 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 3 Aug 2026 20:39:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/yfzgcXhESGnuvjuKgaYQOIRKsBDGWullmZYNE6qkuEA3uu+ZVE+tP2NR8C3hGSAkWPf95aYj+g1Vtj4xtGbSJVXOxGHCSY/dxcEPsGarV+hgXdPldRBM+c3cf85bktb2kRZnIMZ5GAzbADtmxK4o99DPBpqdZY85du5EwDiWjo82ad7ZONiFe1pf3jqr0OeklmIBh838+d7xWZTJO7+bfQwIrPf+Luh2PMpyWg9by/XyiWEh9vyd8GzhsYQiYyzGJZ7EbJ3KAMGEcMdHKX7AQk0FwdpR9TZlCzzELhiPhncWJgtVvP5fNA6mh6HfHJBbKRi82pSAmQ8oPVujdVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJfYSxtwggVhJE6PwMYZRLxA0cIeu56uV6okZ0gxEVo=;
 b=PHBWmTpFD+q5rsdQmwNv402eIhW6AthosVg+8eoZywjNq5cObaLvQT7iM7S0nCgm0OP/RyeO/hRbSTgo8s93gw3QOurS0nT5uyT5c66aPpBiq7e1IInlRYTssN6D9BctBaHk+OUmvDhE+cBfNvsiGvZc2ZBI0uAwxdAX1yUOhnLudwTPoxa52hVJznO8mAgMtcXGYDhPDey+2Na+NA9NX66B2NmAvegwTvcx/B8NrUWcIyRgpizwvynns/EqZkJnhnN6ZlP5VrQ85bIiRrehNa3sSBcNw/LCYAzy3nrVc0Cd3U+mc1NGyyiyCYUZSzmZRQnh9ecyIoz9+ghs/qhXbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJfYSxtwggVhJE6PwMYZRLxA0cIeu56uV6okZ0gxEVo=;
 b=D9g8R0WsNXDU5sc4SVbCCxz9Xbrz+cudpWZIoug4c1koACEiG2oy2RSoGB29Cmc7Gm5QYvs6KlTYm+P9A1ENxNCPhAQ+V+VOHt6uyLvnWzcWODxJN225ccAb5aKdLMkXLwycCLZQ6XFIFDYw8Y3WEYfn+wmC9616XaOKgsRbETk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7131.apcprd03.prod.outlook.com (2603:1096:400:33a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 12:39:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 12:38:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "elver@google.com"
	<elver@google.com>, "ajay.neeli@amd.com" <ajay.neeli@amd.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"sai.krishna.potthuri@amd.com" <sai.krishna.potthuri@amd.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/6] ufs: core: Enable lock context analysis
Thread-Topic: [PATCH v4 2/6] ufs: core: Enable lock context analysis
Thread-Index: AQHdITcLKO5aSEMDN0+V7pWLxNfNI7aMR60A
Date: Mon, 3 Aug 2026 12:38:59 +0000
Message-ID: <751314dba76f1341c8f53e74c5712be917a912ae.camel@mediatek.com>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
	 <3892ebc054bed0608a3b4951e160b18ced9c5ee8.1785534721.git.bvanassche@acm.org>
In-Reply-To: <3892ebc054bed0608a3b4951e160b18ced9c5ee8.1785534721.git.bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7131:EE_
x-ms-office365-filtering-correlation-id: 878ac2cd-2c76-44cb-cd63-08def15c3125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info: h1cFxrOtvZ4+qVcnb6VKwGlHE9HTx4/l/BmaiZYfBAfB7QWEOSwQsQ7259u944ohuRMApKWkH91ECdvodf+2gjUQV5m5WcJCSu80O0tDmMSHBLXaLsOPRztBR1ANIUTlnHuHwVyWG2F3ikd31/IiPuw4zg4tnwcUGpKkx4mn37K9WcJwg59r2UpCLtCOKS+7mtIkmU+9vLQNL3Q/r6soWucHdrNBmLGb5sVpEOGW0ezs64mQmMrg3deXG6g7Y3bb6SWQ6Itqpz1Odjo47QI43YmqhquAB4qz2xR/xyj3QMWD6qP63oGJUnyxdgedSPdWs4FROgTHEMtfnz0rbL2ZsCrUtEQ69i9z/JhOd/2TAX7orxzOHMYP1t+RVjwTV+S5cQdxaPqXyuLpE3ZRTOsM1EvQoTW6cpt1lRLijxZkz6jHfPCa4q7s5rhJeSe9GXdBlxPbdJ/i/2lcSHbO41oh4sojV+w1DrIp38rlve4LHqJG9G6UwDLIHyFRjjc41Y1Swrn1uKWzKcDxiV8SKsycUsJVCBs/i+Afys0Arqvc3JoBPthO+9JsIJhZGoI96F5KBwZK48nu8G03JeqAeKve2/zWAfFb0UUl9q7fTDAXMsXF3gmKMgfDriTcJMdK809umgREA+wOrZl8sngx1VHWY24vIZr7u18DwNi5N9oFWMPVUlbOAvuwMY6XS1uZdeGLCEAJTYIULcIRNDs4Pe9yRlsC6pQuSAP/DjHAKrCAvps=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjFVTXNCQ1VJMVQwUVRrWkZ6bWxOZ09ZSVk4N3FUUXB2WVIxWXU0NHdaMm1S?=
 =?utf-8?B?RnpidjB5bm1Fb0JnSCtjdm1Ic01rVngxN3FBR2ZvdU1idG1meExMZ2FlZkwx?=
 =?utf-8?B?bGlYT1FKNmhlSkd3b0JEOTdWUmt1V1Zic0ovNHY1Tk9tU0krK25Id2lVMGYw?=
 =?utf-8?B?d3pXM0lLZCtYNmh3WlJEUGFocXh0SnU2RzNQc0QwalkrOGk0VWZ1K0duT3Nk?=
 =?utf-8?B?UW9FcG44QmZBNENJclA2dFJuRE5menVtQ1NMYUJKZHkzYmtNem1DVS9RRlhS?=
 =?utf-8?B?N2xMeXFtYU5kdGxKeGgxV0Exb1NxWEZxdkp0Q3lwQ2lpODI4Yk9TZ2FnQjFZ?=
 =?utf-8?B?SzQwdmxQa2lJRlBiTzRieDZZMm9UQmtKaEpGOFlPbVhiWWdhYjlvcEJUQ0tH?=
 =?utf-8?B?MlRuWjJyOVoydXNvSXd3dGdLb2t5bG45MHpkaVBVMi9LcnoxL2Nzb3NNNzNw?=
 =?utf-8?B?UnR1L0JFVUxOZXBxRUZrYUNIaVVxN2NtUHd4eW9EMEo5bVN5bVJPM2FuakRZ?=
 =?utf-8?B?TnFvKzNFc0t3bWFJSlRxNUNISHlBYWVEd0xrS1VrSk1OOFpOU1F0bU1MZGFF?=
 =?utf-8?B?UkNRd1dtV0ZSMGdsNnMvbVB0M3AzTVA5K0RJdDczZmhHSDdWRnZQdVFZRXhO?=
 =?utf-8?B?NndMVkdkdEZBOXJuazZ4NFRxTHE1NjNDVDhDeHNVTFZPWlhGME0rc1ViUjM2?=
 =?utf-8?B?eCtxTVdiMjJjQ21MV1FlMnVoRUwyNFYrUU1ONzFiYUtUQmVwbnh6aEJrVGdU?=
 =?utf-8?B?L3FjN2FYdlEzU3RTeWN3M01rYUtMbFduZFlSMlZNaGVsU1dtbTRpSXhpcUVo?=
 =?utf-8?B?L1oyWkY4bVM5dittTGpNVGJSWEthditmS01qbzRpNmNOcGRaVldQbDNxZVZG?=
 =?utf-8?B?UTQxdGZkVnBJZ2xTaUN2Z1B5ald0TGJSR3l6ZjFWUVI3YzVuSThaNndoekxG?=
 =?utf-8?B?UjZlVjhLMEk1RzhDeEp3cmlFSkNwQk1uVGxMN1ovVnN0NS81eVRQY28xdVlC?=
 =?utf-8?B?czNKVG9uaTZaam4rSnl6R0tia3dyTDJPM2ZmM01yR0Q3RFhDMm9tWnRJQmdZ?=
 =?utf-8?B?bk9YVTBCSkVQVURIU3d4bDJXS01JeXlFcUdYeDk2cjlpUXlLaG5TblBjYUp2?=
 =?utf-8?B?cFZHbGFwWlVudng5OVk5OFRPTEgxQ24vWUFrUGZCV1ovaTN3TEVabkNBOGpi?=
 =?utf-8?B?eFpGdGovNkhBbzRjTlFkNm9XRDhIaGExRktHNnBYNDhuVGt4MldOUlRPSDRr?=
 =?utf-8?B?QWZ3MG9Cc1Ywbisya2ZsNjRIb0RjUUg5NS9waVlJTUpzNitFMUxpV0ttUDhN?=
 =?utf-8?B?MzlIcHlCbldsQ3B0dnloOW92R0NwRnlCM1A2akJwL0pkMmVzMjJucE5FMHJu?=
 =?utf-8?B?cGdTRmlQSXNZQ0dpbVE3MCt0NnR6NGRhU2N2OEJYd2lrRDhxdElwR0k1YTRy?=
 =?utf-8?B?SUI5bUNNY3pEV0VvMWlhZkJUdmlTQTBzOTJpbEZ1aVhsWjZsUzNZcVRJZTJE?=
 =?utf-8?B?ajhxRGlsNlloODlSK041ZTMrSjIrd1kzUE9wSVlYaEpRbUh1N1hWTnh3N0dt?=
 =?utf-8?B?dm1BbzRXRTFaNWlmUkc5eDBudEdHWkxOekYwRVFqNy8vMGFTeEcyYytVaTJl?=
 =?utf-8?B?enJkSTkrY3U4c0tWd2hzYzlsT2o4Wm8vVzVCc0tTS3Z6WGNVT1k5UE9MZ05z?=
 =?utf-8?B?L2ZQa3pmL0NoRE9RK2VIMVVUaWVJNndwUlVUeCtEaEh5Q3VDV0l6YmdHM3JS?=
 =?utf-8?B?eklMaWEzVnpidkkycnFDODJKd25qZERrK21Ea2xEaU9JcGRnblB5ckdiVDlL?=
 =?utf-8?B?NkpqODVvY2ttQ052a09qY29wQ3NmNzRhTk9ublNxMys3NnRpMHp3NXlFT1Vw?=
 =?utf-8?B?eXdFWGVuR3JFSXR3Y2JtcmFEckM2U2VtU2ZSQVFDaTM5eFUzOWFMbXRjbW5m?=
 =?utf-8?B?RWgzdFFkYkRaYmh4dHlTNnZGN0p1ckFYekVMWlJ6VVYwUlMvQk1zSWM5RFBm?=
 =?utf-8?B?WHVIWXIzSzlqZHczM1lUU2tDQWYxRWlSY3dwc0RWTlAwc0pTT2MzKy9sZFEv?=
 =?utf-8?B?R0xUaVpJZnBCVWM4Sm5VRDdUdlJSektPKzVwYnlsVkVuSXZLU21UTnlEelht?=
 =?utf-8?B?YXFQTGZ0Z3BPc01oaUl0WlkzRzA2a0xTbXNjNTk3ZkRrVnN0dldaU1oycnR3?=
 =?utf-8?B?TFUwV2tZT1dvb3hmbGJwZlZZQ3Q0TXJrUFVrOHZhVFo3UDExYXVFTUtSMi9Z?=
 =?utf-8?B?Q0xjdkFPNjNmWTcvZlJYeFFKWGJDaXU5MzRRYUJZeUdHc2phM3pxU2pwbnlD?=
 =?utf-8?B?UWZ0T0tSdTdSMEh6RklXZDRQTGFmM1VsNkFTQU9taDhvR1MrQWhxeUtQaENP?=
 =?utf-8?Q?feeV6PMEf9Y+vgrI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <964C15BFEC3AE1438ECA25254AE52D69@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: HR7GTbGk5jJL91KAw7y9fPOJRvX9DH9GsWWM3MByowcTXH7qcUWG1qtG0UU3IW1rM/9kcUHLHn0SHWfctm8vx03qIGqcicvBPEbLxhHvCqQEHumg2NB6Q3eprSN9A/dvhavY978cdXhXr0qIckRSWf3Yk9v3oc2qlTAG4mFYxOIaUOZCoO6JIDWIOIdhEqi3I1nTxBtL4OQRKPNqYnhv5hm81ht2ETK0tFtJFJ54tBYSpswGw9kcv88uXslQ/ci0TIQmb+/BJqu6ViywHvGySRkAHaJsU5h2WepcN2ukFx9t0DjOwfT9GqnBklfMxly6aj7shxSWX/g8S/QbY4TY9Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878ac2cd-2c76-44cb-cd63-08def15c3125
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 12:38:59.6594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r9Czy3sAQoI50e+76APHZ2FyHeWJzFiAOduP1xJLXXwP8wwlZyLS6Z5IljA2GnglZ5MmbCEBY/vcAtouDATXBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7131
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTMxIGF0IDE0OjUyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEFubm90YXRlIGZ1bmN0aW9ucyB0aGF0IG1vZGlmeSB0aGUgc3RhdGUgb2YgYSBzeW5jaHJv
bml6YXRpb24gb2JqZWN0Lg0KPiBSZW1vdmUgdGhlIHN0cnVjdCBzZW1hcGhvcmUgYW5ub3RhdGlv
bnMgYmVjYXVzZSBsb2NrIGNvbnRleHQNCj4gYW5ub3RhdGlvbnMNCj4gYXJlIG5vdCBzdXBwb3J0
ZWQgZm9yIHNlbWFwaG9yZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUg
PGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxw
ZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
