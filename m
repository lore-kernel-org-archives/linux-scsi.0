Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A6518E20
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 12:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744634842; cv=fail; b=MmH0vg7elmKHDiioA36vIlU7GzlwwEatkuKrKCTJVWU3O7hcjzhB2Wen2vastI1ahBLSCn4iLnVbRDvQpLNJfAMd53y2L0WWGUCv/rDNbt6oq8zVEn4VmsSoQOJAod8cvsjsiU3SbCdnZ4Yj4NEfLz9huXvnBMeappZtHrpAA00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744634842; c=relaxed/simple;
	bh=Xn86Cd3dualwEx4T4xzq/9R13suexbYeigROd+Xvrn4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j4rNkQK4GwwonF+mNbwgMN7fz8EUcAl1FR21x6CdQku9aEAmfkUvbvdRacyCL5a/xJgaFzGVDFZBEalRlOkyerfpSdO63lQHC8UnOZGfwpUGgxlGJiIGUjWFjQAyCJ4Cp4sBXoRrva37g3TjzWVn2ry75wv15tm6YxEoo4QCBvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FPS/HBk+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EiYMn+Sq; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FPS/HBk+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EiYMn+Sq"
X-UUID: 9392c4c2192e11f0aae1fd9735fae912-20250414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Xn86Cd3dualwEx4T4xzq/9R13suexbYeigROd+Xvrn4=;
	b=FPS/HBk+fjlxd20egGwcVV+tLyx+U0rcWHI5GSuTU2F1krhfK9hIE5BbpIA2/nh4CG0pvxVzp3UpCXgagcAtd90R8KOIU2NTaBy1QpKgTNd9dd7hx+vgT2RHLuofdefan3lF78yvAPlGotlg1r/DbW36EiL9uGUSiGhVLWNtn4Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:58fd7ce5-378b-42f5-b133-7f134e1c0630,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:26d1968d-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 9392c4c2192e11f0aae1fd9735fae912-20250414
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1172168930; Mon, 14 Apr 2025 20:47:08 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 14 Apr 2025 20:47:07 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 14 Apr 2025 20:47:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lxprku0FbDi4/DgXdGqRBC9dtr2GQfQDoO+MkrWqWFLWNohazfDtCiqD2g6MReTqfmKp9Tlw09+T6n0cxWsio3iPEyeeq1oYLzJIohISBd4+qgC+z9n4CMKTbgcbc72MXxYEHsFgRMxGbgypft6jvIZBH1BfHudXoRUF1JTg+Ltr35FQMr1pKqE07ycCtliZgd6co2AnR33r2Zv+c+xJHl/lgkG+Ex0FQc4KUtOKePcDya798L8JuxQIuVyvo4VjDB6//rx0SF8Pg5ubBhkyOXrWLV6H25rDMvPbkj6XAdZzcDqdOEixZ/nWlj4MlAeFuwBmSfSAln+axB88H5DPEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xn86Cd3dualwEx4T4xzq/9R13suexbYeigROd+Xvrn4=;
 b=B6bbHAklK8pCscNaZZAqmiQ9KpwP6O2OMHhxLEzr+M0Qrec+SDm+QuYeFhgBTpBVnvOegXVqZcpGQ8TzVqQXHFI/Bd4PNA6gfhkU021g0102Bgft1n0e56ejGxqUKdf0IXiwqBCozQlfB+kMxYyofPAalgT0oZgtYYw+s8FAMUyYXp7d9hXfXmdSsOrrQ67PukqUVQfH20/+PGjotkwm7XTgPT0FL/uUizsoNWvlvN6THn2X0rQqXSwkYEHCw/iYZ5DVIRXMbqSKbUbcJYToumRzeZfGbzyA3yiCmx4XQkpm4kG1HIpCbC9cGQ/2tKTVfVaKFCYImep4JzjDiIgvUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xn86Cd3dualwEx4T4xzq/9R13suexbYeigROd+Xvrn4=;
 b=EiYMn+Sq3IzTZKA/gn+nEpbwCj2ZknL8A+VVy008EmFFiCNxRsa0KM4T1cOi1eLJTw4PJjOtt3hgYafl1aKbLTdIbqw7jG33aCqC6hNyamLL5Re4wUJVootwemcW8Xj8q5AVx18xSc9kuell60xBN/BqYlxZWzdajxCc92aJI3I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8000.apcprd03.prod.outlook.com (2603:1096:101:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Mon, 14 Apr
 2025 12:47:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 12:47:04 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 06/24] scsi: ufs: core: Change the type of one
 ufshcd_add_cmd_upiu_trace() argument
Thread-Topic: [PATCH 06/24] scsi: ufs: core: Change the type of one
 ufshcd_add_cmd_upiu_trace() argument
Thread-Index: AQHbpN5nbrYUrucqH0igLhwZE49t9rOjLOeA
Date: Mon, 14 Apr 2025 12:47:04 +0000
Message-ID: <d430a8308b5183f443f631e0552c5ba1eb33bb3d.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-7-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-7-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8000:EE_
x-ms-office365-filtering-correlation-id: ae24b184-e8fc-4100-076d-08dd7b527587
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U3ZOTWxJSTlTTHdFYnBwTWNGSStPeDR6SmtJeTJPbXN1bzFYSExLQmtLRThW?=
 =?utf-8?B?MFVVUUwwWnNHd2twVGl5SUpFV2lkZ0phYkdyQmZZMTlXNTZrKy93OGhqZkpq?=
 =?utf-8?B?MUdpQWVmVkFkMWdpTXMyWHBqVXdCa3VBWGRHWDV1eHJhcTBhVGhDSDhncVN5?=
 =?utf-8?B?aFZxeDdtZW5nWWZTMDdaeTFrVnVLY096RUZqNVpjOThQR0hmeXJZZVVpVGls?=
 =?utf-8?B?WnJBMFZ0QkdVVWpOdVZFTzdqdXpDc0dUNE5USU5SbFR1TDV0NTlpdWIrTFUw?=
 =?utf-8?B?Vm1NUWhjUThES0VPKzVhVkxpdU9oTUZ4UjU1d0RuVmJBTVA5SzRValpzdThS?=
 =?utf-8?B?dTJwSmtQQ1JBWm1hYWFUUFFoNHdZUGhWRzA1cDhGR2Eva1lNMDhNbXlSVWww?=
 =?utf-8?B?emxiU01ndTkzRkR1dXNIOEZOcmgweEpYNkttejEvOGxrb3hJWDZCUjlyNjBQ?=
 =?utf-8?B?aThCUDdvb1lPeldCaUNGUUJoSy92djRQdmQ4NkoyUzhUeVhSc21zZ3pkYmlX?=
 =?utf-8?B?OXArMTFlZUp2d1E2TDArY0N4RUx3S0J3Lyt4Z3RSbjNyVDVNNGJtTTJSWTJV?=
 =?utf-8?B?QmJsbjA0djFzdGxXVWlPamdVbm1LNlBKRE1Ud0UzMzd6NlhyRUV2L3BjYzg4?=
 =?utf-8?B?MzBQWmNQUjFqMlZzeFIrbjlXZTF0OHNSYjBWTnhMamhjSVBZTHg0N2p3ZVZy?=
 =?utf-8?B?RitvS2F4a2dyMmRSTzZQQXpRd2N6M2hVNm9aNWtjMjIraldqZzVldHZTSlJk?=
 =?utf-8?B?Ty9oU0xhYW82QU1wQTJTNm0ybytDTm1DOHpNQTFlZ2x0VzQveUVZbTNid0Fr?=
 =?utf-8?B?SnE3Yk9TU3FDM0FWTDc0RTh6ZTNNeDJhbDZKSGVobkJLWUJSUmxHcHhWMk5v?=
 =?utf-8?B?V0gxaTZKeVRZMVVvZG42UmhIeTAwSEFJVWFGOXFuWGtnckpVN2tsVUVjcS92?=
 =?utf-8?B?UGJxaXNUZ2xObmlEZW5NZ3I3RmNjZkIxQzFzT3NKTzIvNWVma0FiZWNSTWVh?=
 =?utf-8?B?VkoyTGU4V3FraHNxK1U0N1hCdFZwekRYWUlFNUJYNWVKMS9TY2pzdW5kQzJz?=
 =?utf-8?B?SWg1bGVybHVZVUVSbnFMWkxIQUJKRS9aTU9sOXkxV3V2WHRJSXBFUG9TNExT?=
 =?utf-8?B?d3c3a2ovMjFiRXBxcm5hSWtWaDd3OXNVYmRmcVUrQTMwK2R4Z0ZHMTFOc1o1?=
 =?utf-8?B?L21YSFR0SEZ2aVM1THdGcjdMaHZHeXB0K2h6bWxDNjNsRzVwOEFTRzNPTEpU?=
 =?utf-8?B?bmx0SmkyM0FlVWU5QlViNWRady81SmZ6di8xZFowQktPQ2d0U1Y0OWRpeXpE?=
 =?utf-8?B?NU1TN3hteHBjVHVZVFVQdXZoMTdDVUIvRmdTZnJYSHVaMEcxcUtRZ2I1TlJu?=
 =?utf-8?B?Y3RFTjd5TzFGcGhyQ0t1V2NaN05UWGVlN2U5Wkx3czd5REFmY3g2VGRvYm85?=
 =?utf-8?B?b0dTTlN3cldhNHNkanZ5OTUwRDhnYlY2blhaNko3aGVWaGo4Nml1WTZ6Vm1U?=
 =?utf-8?B?cmlxVTZGSlA2SzhTSjdsQ1l0UHFzUTlOUktsMEIzZm5vM0FRRGlVK3M1bGo4?=
 =?utf-8?B?SE9JS0RxdGUwcXQ3NmtRK3FTUGlyUk83bVpNVFRUcVJoWjBhd0U2R1RMUjJI?=
 =?utf-8?B?cDRubVIwS29YdmFMdTBSMEVIelo3d3VDOXpiSFFORnh2elV6cE5waGhPMmxL?=
 =?utf-8?B?R3FIM0hpSEM2RVZNdEJpNm5QaGVxS25JZi9ZdXlTOHVxM3p1OVY1YmZXeUcz?=
 =?utf-8?B?Wm5aaUp5SFlNM281MUc4QkE2TFpXczlhdWM2SzBhQnZuTkZXcWczYlJteUtq?=
 =?utf-8?B?a0lyczJmVkc5L1FzaXVMRDk4enFqa0FmV0hLakUvTVgzZ2pDUWlGRzNIem1Q?=
 =?utf-8?B?czg1aXZIZ3daSHB5bGc5cFBobU5QZTVzdjVKa3dvZmZLUEduQ2l5WHpnN1F2?=
 =?utf-8?B?TXFjeFlQT29KYW52bDNndVllQ2dTWTJxWWtOb0VNcDdUY3dkQ09VdmtTSEwv?=
 =?utf-8?B?M2U5RUNlM2hnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzNyYkxiR0JvSkFYdi9jRVhpSGtsaW1CV3M0TlJPRFExWU5PRjA5K3JkMElS?=
 =?utf-8?B?OEpKbGxqdlRoNDZldm1lNEJRYks4bnQxb0xROEgrbFpUNHpBcHJXQVFzUmhV?=
 =?utf-8?B?K3hMMGFYcW5mM3lFRFc0UXQ4NlFQTkdmZXdRWG5yUyt2Q1pYdm8rdmY1L0ls?=
 =?utf-8?B?YlArN3ZQT29jWE0xM09nRzdQVW8vZEJ2QXpvV2JNbVRNZHVGSmd5amtRWTQw?=
 =?utf-8?B?U1hNVmZTNnZSR25na3ZTam1MTmVCZjRjby9aSGFDK3QvbGpyTlBwRFZKWTNE?=
 =?utf-8?B?Q1F1TCtWMHZSVG03VHJQckJCU2hIcnloOC9PbW1iS0ZuVWUzWjJiZkpadk9Q?=
 =?utf-8?B?UXBrc2NBSUd4WElyOFlKUWk4czF6T2hZclVRYXkzMEMyQ1ZiYmpmQ25tZEh0?=
 =?utf-8?B?SEZrNUpJdnBjWDh5VFdYTkRzN1VIeHVMcEEzclJHQUgyVlVBWld1RXZKQnpJ?=
 =?utf-8?B?L1hVc0E5RU0rSXQzVGlJdklWYTBJUGFSSTJCQVpOSmo4Sit4ZC80ZHo3Uk16?=
 =?utf-8?B?Z3l1L2pvbWtJcmJHSlVYUEEyOXRBb3RIcjhaRVd0K1JiY3JvemNsaXdkK3Jy?=
 =?utf-8?B?RTA0SHFTUW5lb1lCUmFkMVVVVlMvZlR5WDFrZ1kwdGlqdzdyaUFORGdJc3N6?=
 =?utf-8?B?U2syTkhDWVNWdGNDcndzRVdlc2FuRHVqZTYvbStvdHl5YmdhU0RyN3IxY0ov?=
 =?utf-8?B?ZTVHS0taMURUZ3Y3bXBUQUtDVWVlL1k3bUlTMi9hZm9CQjRtYXZpcXQxd1lX?=
 =?utf-8?B?SnNyY1AybTdkMDczeG8wZmhGTm01TWwrQ3JxVGorb1puYXAyT1ZmVWdaSU9x?=
 =?utf-8?B?Wkc5b1Q3UTJoMEpadGxncU02RXFPOVdadkp2R2owdkoxNVA2YnVxNkVKdnIw?=
 =?utf-8?B?VzRWSkxoRVFEb21KU25td1loV2U3cjE2WENiczZTWkxBUVR1SjQvWXUvSmFG?=
 =?utf-8?B?RVdtbWlQLys1Zzg3TVBTb3BFOWpCcE9mbXBYLzRFUllYUVRvQ3dlSktYeCs5?=
 =?utf-8?B?VUthdXRWYnAxTXNJVThNb2toRTR0OG43RVB5R3l0ejdJem1PWkZwT2RWY2s0?=
 =?utf-8?B?QWRHaE5iZ2tjN3YwNjl0OVdrWFNwT0dWOWhhd25mcFNUSW0xM1NJVlBnQTdt?=
 =?utf-8?B?Nm9XRHM2L3QwdEZwSnBhRkpZUlkrSkNoNEVOekFEek1BVk5odU93OG1OemNh?=
 =?utf-8?B?MTc2QXBIY3kvU3o2MTBwanh5NVA5aXV4SXlNaGFIZnhIWXBjcE8yeHhkUmhR?=
 =?utf-8?B?SFU2TTNxTzlHTDJtWGMyVjhHN1Y0aXZJdFRDbUhMcVpoZ0F6ODlSVDA2N1Q1?=
 =?utf-8?B?elA4bVhzT2xPQzFFWUYvTndTVWxCUWhha0hQUjJOZG1hWVo4eHI0Sm1TY282?=
 =?utf-8?B?Qjg4VGVPYXJrWVN1bnk5ZVp2eDk2aGlEUWU1MkRBemUvbnpEZFp2TWU4dnhn?=
 =?utf-8?B?Skdwd2doeTV5UjVSTnVwek9uWkh3Z3BpNE5lak5NOUxQbW80Ri9panpES01h?=
 =?utf-8?B?UEhiMHN2NGEzRStrSit6ZVlKRUtuMXNWM1BWT3JialpjWU5HaUU4Vm9oQ0hO?=
 =?utf-8?B?bEQ2V1ZyQWFnS1RJUDFlcHJHeHpCeUJuM1RJNUhadTZ5K0NNajBkZ0FhMWlu?=
 =?utf-8?B?b0FBazRCSVFXN1dOUjl4Wlk4TmlnbjZ3SGxuWU9FQ0kyeW1HK2UwYThveEE4?=
 =?utf-8?B?U0l6S25RelZ1YjZnWVdCTHY0dm1PVFp0NDJYWTVWMEt5RHZYNndqcWJPbUow?=
 =?utf-8?B?cW9QaStxWHlpZ1VrcTZqT0pSRGJWNFN0ZW93NkgrRlNVd0J6K3VwUit6VDR3?=
 =?utf-8?B?UkJKTEhSeDJzbFhjWkV1UW5ZbDNTMVpMMFdaK2FrdGVaU0VTK0V5VXpqVThU?=
 =?utf-8?B?TCsydm5LMlZXUHZBdVZaVDBmZGR6ejNSNG43ejk3eTZVQWU2L04wS0Z1SlBU?=
 =?utf-8?B?R29ZNERQYXorY1piMkdaSXpJR1RLTDFnbkpuVEN4cmdyb1locGhNR3RKaWkv?=
 =?utf-8?B?L1BqWFphbzlYMGFXNUgwSWNhQTI0WmZ6MTAwOUJhRVBiVjdZRk83cGIvb0sw?=
 =?utf-8?B?eVZzRGpMUFEyS3NrTllCZmNWQkNJU0orOHVZR0NucFZqZTRDVlF4Sm1zeE5s?=
 =?utf-8?B?S05hcHRoZkhoWk03TVFJRUxOai85aGgra1BuWmMxTitqaXkvUndzZDluTVBi?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BF1E5A85D0E764F931A4405DFCAEABD@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae24b184-e8fc-4100-076d-08dd7b527587
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 12:47:04.5534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34TA0uEl1HRJbGzT8aUkuSwgeHHl5hREs+CUYYMOBoUIax9tyB2pcG3kYx1HFvSIItiP8lvVWu5972UunDQ/wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8000

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IENoYW5nZSB0aGUgJ3RhZycgYXJndW1lbnQgaW50byBhbiBM
UkIgcG9pbnRlci4gVGhpcyBwYXRjaCBwcmVwYXJlcw0KPiBmb3IgdGhlDQo+IHJlbW92YWwgb2Yg
dGhlIGhiYS0+bHJiW10gYXJyYXkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3Nj
aGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVy
LndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
