Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617023D525B
	for <linux-scsi@vger.kernel.org>; Sat, 16 May 2026 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932395; cv=fail; b=kVsv84AHOUGgcACboH68dTaT1D5EE0ggIj+u01Q+SgEaCzaou665/QShSE1zkeQFxFUnt1qcBOby73DubMOQPigqB9dio08g9rvJiV7HIzSmZWm1Va+aIdz10RDU9d85hDFVVzbwKYU3jL1t9LzFWe0TzbLtWRu/1UTCC+SAIJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932395; c=relaxed/simple;
	bh=e14JSslCQa0lwrhLOXOicRMS/fGXzLMKmL03OKAlVAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FafOfJkHVIqlBP2NOCMWbp0oGA1NZDlI+WGxDDM1H3PN6lPRxHd1YIuazf9bKyj0mPdYA0TXpAKuzJ1ktGijMYZWPkY0J828meNsDIq7Zsr4D/zfWiX5zubDg0H2DbdNx3sxjk//ujKt2IxQl3BJTkn9GL5XI86tbRe5Mbv9l3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FwH2h8Ua; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qAJ0ur4S; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FwH2h8Ua";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qAJ0ur4S"
X-UUID: cae0ec7e511d11f1a3561939bc42ff46-20260516
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=e14JSslCQa0lwrhLOXOicRMS/fGXzLMKmL03OKAlVAo=;
	b=FwH2h8UamYyAZBnYFStiUeIFXg7S1DEKpcfOzGkvFfHf+NKUmN+MAUDXEnCXsdemwZ6gvMiajGabUyViUydpKzuq6xm+FKi4ZZAFdfS35SuDsrB6e2lQEQGt/jDOPAw/Yojcwhk3rGtayZNDlN59slPgVqlBI/FBcIDxhdnUx5E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:d5d2f8c9-f3cd-42c1-b680-c659de51380a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:9091e75,CLOUDID:da506fa4-a669-48ac-a1cb-3b38a93be682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cae0ec7e511d11f1a3561939bc42ff46-20260516
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 522675057; Sat, 16 May 2026 19:53:02 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 16 May 2026 19:53:01 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Sat, 16 May 2026 19:53:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QdSiKP4ynaLZIC4PvfwgL3jFeVOmal38a7JCQhjD5FBuwGVDV70gtAePOIvkpnw01nGVtuzxdhstQSxTyqG5TnriwTaCK9ao1jiI+kAkYBSu2UG29ZE09LZeEvPgmTAh3SRZrIDAz6UZLe2sF6l49+5drajjbnItPlQ5vArqOZwbaPIHirsY/L/BTtD2czzZvlHoHRwKwlm1PFX27VXuA6HWwcGZpoZuRJkYgELPI9ZiL4QjA7wa7ZChhMDRyJOor/BtYAiDjAE5vR6cTnuqUW4C9fIOag/Zm6WdS7k342jAS4HPcCD348S/ssCo7G0xF3vm7hHjIP3PuyNl2oYeSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e14JSslCQa0lwrhLOXOicRMS/fGXzLMKmL03OKAlVAo=;
 b=KxnMEHMVwvtuS5wK/7uxqrQ+IF5W1QuxIxEoW1X2XzAknoUH+rb6iqxbl/kadvYNALLB9+1HWMoFRCQ6hi/RqT6wpUt/wG3zXMAWgv1/SPZBZ5j6PHunzTIzyl9/BmG2JtOlv3ELwERm41NBsXlpnA9AyQcVk8hcofD5A+Yr3NNBU03a9r71eTVoP6lRPGLbxKnT6eTqCagqvzvls6OT6W4LSFs4VNEDXNV9D7lByXB7j+eeFFe070klZuUOKQqcTH2HOP4TSxEI1sbSwsh8OI1W3P+CvIR7u6uE9SKFWtLnqp2g0ON0QzfYcTjixx/7sls2UNpEwPv/c9ssKu9wZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e14JSslCQa0lwrhLOXOicRMS/fGXzLMKmL03OKAlVAo=;
 b=qAJ0ur4Sx8tHKSuxnoKsXuLXAzDWsj6nnfdicNfjO9iinEM57vUUl32P3mAxKUi29S9DLAF9c55IIBTc3yKmYTjYA0G+/VzWhTcT/g5JHovV40lKPaBJW92PWzl+4ix2ZsghsntmGPD0InCnCkS9YgT9Hfjo8lzNCHUdqcaQLf0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8082.apcprd03.prod.outlook.com (2603:1096:400:479::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.11; Sat, 16 May
 2026 11:52:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0025.012; Sat, 16 May 2026
 11:52:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Topic: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Index: AQHc44A/IHVJ0+M1ukqkaTZOlDMObrYNtNQAgAEJrYCAAI5zAIABQRuA
Date: Sat, 16 May 2026 11:52:56 +0000
Message-ID: <599a2ea183cce202170ff3c06d71f42d32a01198.camel@mediatek.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
	 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
	 <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
	 <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
In-Reply-To: <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8082:EE_
x-ms-office365-filtering-correlation-id: 07173c8a-11e4-49c8-47e9-08deb341abda
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|3023799003|56012099003|22082099003|18002099003|38070700021|11063799003|4143699003;
x-microsoft-antispam-message-info: YrQFXMJjXli7yD4Zw3FiFgmzUk526NPFn782fC2ofvTeFS2wD9J8ekCi0qDgOraHhJTxR3Dc3fNhf+lpfOmDc50UGSWjrXt6ghWEVBYmjZwhoJe4g2dSYGXDw95mUZ5gOcBHoiR3zG4a9deH+BrG9xLXopJl0T9fnhxZ4+BiY+LfuWW3XkcaUO5xVSgUUo8RXiryDEZIQIepqKO5MrPPVqevTj/n9YpMIzzymLsrKPy2fHHE49ZsksK2595Nn0GAu6FbKCG8kxqVLD8egVrmOqCZukVlvMZZrsLs4W5XELc9zSJ2cQrkH5hvUStSOH1WXStmNsR+fI84XgZitjOWYJNcn5IrrxkvsZ890YULqEfkGPLig474go98ySb0Sv46optAnseKKFNmyfSrRaCg2dkrWYDKs5YY6Gx5ncKVB0yMoYmQY63oQs4mC9LJmrZxSWrKwVUKR0cx4nLUKML4P6uDFTbykrczoji70vCrb2E4L7prLH4hTNEV1OOQrXIzWO5SwFkDEzVjg+lV4lSTltQxDhcwRlLAOjxdT9cUCFD0/5qkN0jFPe+UNtABmDavuMRimrbNNSo31cTteMTFM7r8wOEUG6DDZtEfz3XVEx3v4pu6YV/37gIH4Fnws5tEIbA3u7A40s3fJJAVufqVe9tHO+GXOMijNnJpvOdbMhSV3Ygp9K3k1wc9gvDPbOoaq9i9p5fee75GDGZvw3wMPNoxlSkzTPc4H0t1Xr5YaHre3Hi19G+8u3IidWRcX2zO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(3023799003)(56012099003)(22082099003)(18002099003)(38070700021)(11063799003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDc0ekhaTXJ5ajJEdXdWeHpWRDRsbGRCMERYZ2ZLUzVzVTcwVmlYM2haTHdM?=
 =?utf-8?B?Q3Z3VmtXaTFwNmpLMmxRVEJjYmJDQWpNV1JFWW1HYXJjVGowYUliZ3dTcGxh?=
 =?utf-8?B?T3RqRk9KbHQ1OTNPcmJhRWhaTjQ3MnhrNmlDVjhNdlczYm1VQTdUVDg0Y2JG?=
 =?utf-8?B?UjYxaWVTb2ZNaE15ZXdjd2xBeFRuMDZqdWFtNW5wZEdaamZod3pnSU5FRDhl?=
 =?utf-8?B?T0JaWUpVa2JBREN4N2oyS2hhWUNHdHJkWFdPbTNuTlNBTkJqbENXYTV1Ynh1?=
 =?utf-8?B?MmJuM3oxcHU0RXFUUWZneDBOU0dUMGUvbEFIelZua1R4c0h6MXArU044QWl0?=
 =?utf-8?B?eTNRMElwcTl1akpiRU9FdjdNOG40VDVCN2xKRzcwdCtDZTlnN2RxYTVPejhG?=
 =?utf-8?B?b3gzakUwT0M1TERTb1Nmci9ySUZJV2FBWU9MSGY0Q3M2OWVITEdrOTJqdXFZ?=
 =?utf-8?B?OGVwQkVzbDlibXhzYWpGK050bjE4NG82NDBUVno1QWl4bHRTZVdOSVpJTzk1?=
 =?utf-8?B?TGpDWTduM2tWMWVUMUlWbGFqb25lVlpLT1FnN1BBTzNKTlBwMHBVWityTzNt?=
 =?utf-8?B?Q1B2Mk5KZWhHQ0p0c1lGOFhnL0M5RkcxeDhwdzE0SVVhL1lGK3VMWEZsMTZy?=
 =?utf-8?B?akNpSE52NkNVTmpBRkM4UVpLdXUyZEFSanV4SndvZVhQYk9kTkNWQ3k1RXBa?=
 =?utf-8?B?Mk9JMmQxUUlCMUtoaFRENytacm1hTzJveGFIY0Y1cVhWaVUrUlAxRkREU0E0?=
 =?utf-8?B?OFMzcVRVMFdmOGdnS1p5T1JTSWU5eGhVbFhyd2gxcVlyM1RPekhweklVeE5P?=
 =?utf-8?B?eWZ0VHpKODBCSlNoOTR3ZXpNclZzNkJGYmw2U1NaRGtsdDd2cnIzQmxURzBD?=
 =?utf-8?B?ZytiT2w5OUYydnZPc3BPZVZNWXN3U0xyNmlaUlVNUzRpSnFsL0NQT2UrNHFz?=
 =?utf-8?B?NzdQTlQza3ZmS1UwMUt2UjlMMXgzRklnZDAvQ0h5VzJtejVWSGRrOWhldGVx?=
 =?utf-8?B?bjNSbFQraTNmZXVBZStaREZyRkhBNDlMaXc3Z0FJdEVQVFhKMGtJVTNSTEFp?=
 =?utf-8?B?a0pXaUNqbTFYY1pJVll1RzZ5SWdqYUhUUUdSUlVUNnd3SWVKSlptYlU3U0Ro?=
 =?utf-8?B?ZTU4NlpQZ2xPb3M1dkJlN0tiWjloa2cybGptVlN6SGVucTVCL2lGQ2tNYzJL?=
 =?utf-8?B?aTVZZENIdm94MkFNN3A2MnEvVURVUHoyQnlWVExpMkNDc0xRL2JQZUJ2NVZG?=
 =?utf-8?B?dnZiL3dlb2xZUm1wQ013bHd3dHlsckdnL2JiT2dtTDdlb0ZsWkxlcDhvWlZI?=
 =?utf-8?B?Y1J1Q0pObDhnb3lpRUFzVTJqYW92UEl3YlhTZmlsSmtnTE5jVmxLSExEclo4?=
 =?utf-8?B?T2tMWnJwcVg4TEprdG44WnphQ2c2NElwdld2QUZOM2pSQmdHSDVxQ2lQTkp5?=
 =?utf-8?B?b0hvVm1yWE03Z0x4SkNiTVZIWlMxdCt0cldjNzZMQXc3R0xKYkFrNjN0Ry9H?=
 =?utf-8?B?Szl5Y3U0d2wydVBERmlIZy8xWDVFbm5kdS84WE55d3YxeHRmMHNKd1AvRzVG?=
 =?utf-8?B?YXluczBENlMwekxDMEVVMFBGT1dqY2w1cGJPRHNwV3RCUmR6R3lnamp5RlFN?=
 =?utf-8?B?WmR2OUtRR0VHNEVxRDZVaDNPRC9uN2VxL0d4eUdLVllKQjcrYWpUdllkVzZm?=
 =?utf-8?B?N3ZWTlpVaHkxUUtCY1ozK0VFRnBqUEZHQmt3ejY3NVROaVM0TGw3OTR6L2h1?=
 =?utf-8?B?VUw2cm1memRjNTg2alFNUjBxUWhKTVJEYUpkSHVJMDg5aFVwM1dheVhhMjRQ?=
 =?utf-8?B?c3pseUVxTVM2YnAzbUFOVW4vb0ZsbWdDbHFEM0lmbmsrQS9nZXJRZnQrZTdX?=
 =?utf-8?B?TlZsUVNVNExhekRWTldHdEtYaDNiNHF0NUYvWVA0cm9qMVQwVmIrdVNvUnF1?=
 =?utf-8?B?VEptWVJRdDA2enRZMFRYcWREa1JxWW02aFVhYkFiUklISko4WU1RdFB5UnNK?=
 =?utf-8?B?ejZnb0dwSUl3UTNKa3RXTDBRSnkrR1RVRjlsL09pLzFab0RNNWZ5U3NyL1NL?=
 =?utf-8?B?MmZtUmllZENRWStRUlV3ODFkMHBaa1ZzZ05lQ2oxRnVPQ1NTRTBPZ3pWMlBk?=
 =?utf-8?B?TnhUTU9VQ3Z5MFljZloraFcwSUcrcTEwMHRJNkNSckt3UlhtQUJvb2Z3Z3Zs?=
 =?utf-8?B?VVIrL0lZaVMyL2tZb09KWTJLdnJWMXNXdGMwbXQxTFBGVGQySzdHaDBJRkhj?=
 =?utf-8?B?V1YzNWtMN2FCcXBKYXZ3SCtDc0NpbVpaM3BLaEx5ZWFYKzFDdlZ5b2dwMEFD?=
 =?utf-8?B?UHFCWWpVakZSVkFrczI5ckFEWHYzMDBEYmx0QWM0NGdMVWk2SVpZVUpQdkFz?=
 =?utf-8?Q?/KoVnwhZTzeWpQe0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E19EAD733A3F24680157C5C2B434EF7@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ab5X2Y5KUrgZ+y/4HqbtAJm2q7EF8Srgm9ePMwkQjXdjBCv5sZCyJ9wjQLyypNNp5S0iTbrWR8HKLGGoFuHBrFkC5J71sBYSBhml/WrSb7DKpEJVdZh4X7/uTc5LgcBVarBbNzQx+7yEjTGCRLUTZLXz5v/OIOn/Pxfa7D4oNtAjzmh9jd9rM/2nsL1J1RnovkVIrOgQwOt/RLKapP0FfpbPIfWbR5CJERS6ttRLHXyi7B2wrV7/e8UP8sC3QJoraRt244a9KIWf1HZa8q2Xx6AHIuioT1b5JX4sVNznsadSoMcC/hb283OwhqgNsl6mA3qgrT8lxKv137daBGUc2g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07173c8a-11e4-49c8-47e9-08deb341abda
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2026 11:52:57.0038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wS2JfvCLl6Epk9uMmZwUCu/TJAu9PH//a276adKN6lEqSKrzMhBOHwTUC8a4qNdkawbV06hdVQHVg9b5tRQiPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8082
X-MTK: N

T24gRnJpLCAyMDI2LTA1LTE1IGF0IDA5OjQzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICg2KSBUaGUgaG9zdCBjb250cm9sbGVyIGNvbXBsZXRlcyB0aGUgY29ycmVzcG9uZGluZyBj
b21tYW5kcyBhbmQNCj4gc3RvcmVzDQo+IMKgwqDCoMKgIHRoZSBDUUVzIGluIENRIHNsb3RzIDgs
IDAsIDEgYW5kIDIuIEhlbmNlLCBzbG90cyAwLCAxIGFuZCAyIGFyZQ0KPiDCoMKgwqDCoCBvdmVy
d3JpdHRlbiBhbHRob3VnaCB0aGUgb3ZlcndyaXR0ZW4gQ1FFcyBoYXZlIG5vdCB5ZXQgYmVlbg0K
PiDCoMKgwqDCoCBwcm9jZXNzZWQuDQoNClNvcnJ5LCBJIG1pZ2h0IGhhdmUgbWlzdW5kZXJzdG9v
ZCB5b3VyIHBvaW50LiANCkFyZSB5b3Ugc2F5aW5nIHRoYXQgdGhlIEhXUSBkZXB0aCBpcyBvbmx5
IDk/DQoNClRoYW5rcw0KUGV0ZXINCg==
