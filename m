Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CEA314A95
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779096410; cv=fail; b=cYbrrIj4ofq8hvhuU2km0N/rX8XVaIm4I2fR3HPwWiiTEQknxVnWtVEe823gm4b0tidjnCgGUuEk3o3c7w1cJoLZ+/R9s7Fp8sFYRi90+vym9lFkS0ioUe/H8Ah5/oC84t91RQ9wMeVNTeXnyk8Z+a4UQ1Sx5xCv9I4d8JzUtjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779096410; c=relaxed/simple;
	bh=cgOPQ/rAlW9MQBA2Cw2lu4wvGzUpZo7QpvUZ4qtJuQk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Supx9/HuOYKVkhtXKwX6O2OBIHu9B6kPb+mrbOr1bZNqsHjoTWkktp9NQzWcecSUZKdJBZ/KZHc0xZjnQrftKw7QeV+fXfWSAUr8YnhsqQPpqLXArdsOW4E45Plfax/Uy/pn8D72K+9fWP+tlM+TiP78do40k4yoIiGTFHMOCh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fabD1Ff6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=d7YC3c4q; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fabD1Ff6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="d7YC3c4q"
X-UUID: acdacc0c529b11f1a3561939bc42ff46-20260518
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=cgOPQ/rAlW9MQBA2Cw2lu4wvGzUpZo7QpvUZ4qtJuQk=;
	b=fabD1Ff6wFli+JrQibf+XTbJslHmBFjfweYq1UuMXb849EzmzD3dFcI5e7QsGUfongLa7rmgGWUt7BMTlZ7XbDfrJL6R1zx8bNZg5z8rJ973stXQSQ0SyKuSL5tyyBkQEiTrciEYjbbp4mV2zDjSIZqzgMDdEghjj1vHx4RjN5k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:1f686421-63b6-4104-bd5e-f3fc245d3edf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:9091e75,CLOUDID:27c1b6bb-0a7b-4b06-8a25-7f692da0e3b3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: acdacc0c529b11f1a3561939bc42ff46-20260518
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1385539331; Mon, 18 May 2026 17:26:39 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 18 May 2026 17:26:38 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 18 May 2026 17:26:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ap+Dz62nDSOl1wf9zGJcV5cuICD05uWIc338wNFOlG7A1ikTpIpEKAKgcqErYK2P2De3Esqe9wn6ERajVs/W2EW8cX6RBtAbvY+HzGza15+XOJNzsF1yZWkS9buJUmCMOLKEBHklVVPM8kKf1GOxgOa9lFTPmirGdglSKPHdcMPp6OQYt6rdJUVh5EQXTw3XONVkC8eiWeUdXDROUnG9UCtDKtAM4io8byqFVVKVU8NM571qlDIfzaHsHf55L+8Ytt6Cqu7+2aSdz4qTUbzHG2oIWF84HC2YvgjQeLAfibcn/cfYJwGfsro+3EyFg9/UM3qpqD17Ih6Ax0sKhPxb1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgOPQ/rAlW9MQBA2Cw2lu4wvGzUpZo7QpvUZ4qtJuQk=;
 b=jRawlpl8HiYELtzdP0lBcWF9eYHIKQsQ3u6JGXk+EAvn6x72Rp0a6vBtRhwhrTYBrq/SAoo8IzcLw/1x5zUmSDrYwx4X81awMPY2cVDtwnWW+SAdnRgAq2Nh7397XRs0st4kpXRHDvPCAnXydcl1N6eqezX//hTF0qG/xPhU6cBmRr7BBLhU86h4wt7fP0l8BqCJlSRzdNxfFPGXa6zsfIjWl8HjXVpouLremNXzE7/V8htXUbGFgwN3d5l1LyFwaJqlpWoqc0IN980d/dbiUJfVMpyDojiMCSklOFEi1wbNWaA5bkxpYz+YNr6Mz1NSq20qRmgR12UYf3x8DSHrJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgOPQ/rAlW9MQBA2Cw2lu4wvGzUpZo7QpvUZ4qtJuQk=;
 b=d7YC3c4q0GyGwaFBiSHsi65X7sorueovLwLLG+nlDMzx6m1nF275oJTyTDq/9v337vFpwZO5yUfPxpPc6FzYO37y2KoCvpOuA5sz9LXrhoE/eewn3DT4d3kQKHd0Pz0EYA2ufTYrAC32SoRTqYwi0JSXMWgQafbrlgMY5PyupVg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8673.apcprd03.prod.outlook.com (2603:1096:604:298::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.13; Mon, 18 May
 2026 09:26:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0048.010; Mon, 18 May 2026
 09:26:35 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Topic: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Index: AQHc44A/IHVJ0+M1ukqkaTZOlDMObrYNtNQAgAEJrYCAAI5zAIAA5WaAgAB/mQCAAtfiAA==
Date: Mon, 18 May 2026 09:26:35 +0000
Message-ID: <e02140af260edd8f0391889f7c925378dc79bf10.camel@mediatek.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
	 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
	 <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
	 <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
	 <bcbfd7a71f698f6a3dcf627d3ea76c79b9897ccf.camel@mediatek.com>
	 <064b4c51-c3e8-4380-b1a2-ce996078efe8@acm.org>
In-Reply-To: <064b4c51-c3e8-4380-b1a2-ce996078efe8@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8673:EE_
x-ms-office365-filtering-correlation-id: 15509167-7d06-42d4-634d-08deb4bf8e87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|38070700021|11063799003|4143699003;
x-microsoft-antispam-message-info: DM+na0ZthoGlF1qroCz/gOSFq3EQmd7HLO9j+Egk6K+ITIdNOMJ8K5Wecv9w1EYO6gHXLHSHOu29RstaJPSZhxOKbdVDZpMS+sHBPySKMdLGKeph8iQuigxqd32JB2Xpe/ansIPVArBXy5aHWInACgAVseIAzNI41PZAT+ojP9aKEC4P6ElY5LaXmZVw/SnM+JDECyLV6YfHayfxrmBRxCWr86oYosEP4QeiBvHOlDU/ePPptR9IdKQDVqgdsQ5i52Ak7EN9kUZbs7nia04VbSYywdG4wdViveJ8b5kA0STHOzi1+xgPvYLMhsLs8suE9pZ7r8Eu87uYlOohoRUUojetGzYGa8eezkieNWiltQ3iVukSyQBmT4w7Tm6SzZl7g+j5JKDZE/HafLkXVraQyy1e32q+r4KnvhgiGPDLO6UV7jcjCRUP6YHbotJoCGvbP6uELrQQzF2OLfvHVaGKVl1HYuIdDjLEvB7Foqm8QlnYpEwY6m3OeR7Qt9L488qKBJKRJkN9sdRipZDcAXZVyNHXV55SuwQDj0QwcJAbDtpTod3HDmLBy8IsbKUNA/mLTDO34dS1HSvvi9jcnPRZM8FdRvXms/G5WcFtf2dntP/5N6UtiRcImKS3AXjkp7ITacZnS6CfDJJlYXSCoeO6txnz5qJfiMA9YFXHCJ/5RZpZTamRBPw3h20wMcviEh76WxgXYFOZst2PVvEqhvV3nUmtISOV7dR3lybvR0rWiKNFeEbUXQyCosvLpAEjJaJL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(38070700021)(11063799003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU1sVTQybnJ0TFowTUpuUmpaWjdnait4NWR5NkdjYlJvNUpTM2wraG9WbU92?=
 =?utf-8?B?RklsQnVwTjEvQ2tCSHV5bEZOazc3aW9zS0l3dElMNGRLcitTTzNmaU5GQVA4?=
 =?utf-8?B?TVNoYnlEK1pCVXE3TEVhWllMbVU4RkFscjBCZnFMTis2TkduUWp6VzhOdTdX?=
 =?utf-8?B?S3h6QWxzNGNCZ0NVOWtCU20rcWVUSGU3V1JYMTFnYkJKNklxSG1jRWVFWVh5?=
 =?utf-8?B?S01YcDUybnE3N1RoRitINVE1aElQdVNCTmpjUlJBRW50VCtwRlorWTlOWHp1?=
 =?utf-8?B?eC9Mb0xlUXJRUGxncVRXSllHd1UwQzdVR0N4VUs4K0hTT21adXVhREJudklR?=
 =?utf-8?B?clRJY0QwKzdFRC96SHhUR0o5SEVXd2tCbTZsNzdQL01GVlRiU3FpeGR4WlRC?=
 =?utf-8?B?bWlvMHpmSXpKMmV2dm56eDcxTW9IWXF6NElFblBTT2ZadzIzTDU0RHBnbzU1?=
 =?utf-8?B?VkVBWWkvcEJzZXV0bHUraDVSdzRmd01UVC93OXh1UzR1WGRpakRocUplTHZu?=
 =?utf-8?B?bzJFZHYvTDdVMzh0ODYyUmVpLzhISDlTTGhnb0h5ZjhCZGlSSDRMM1NOb0U4?=
 =?utf-8?B?RC9zeG81OWNtakpqUWJWb0Q4cFdJd29KV2JxUDQ2aHJ2OTRFVmJwSmt1VVpj?=
 =?utf-8?B?bTJvV0pzVjlPbk15Y1ZwMURHQjhDaVlxSDFaK0hDR25aa1JIb1h0YnNKZWV6?=
 =?utf-8?B?dGtiZ01kclV2QmJ6TEFibEFPemRTZTJZZERFMmlZMGxzdUx4TC9FejNKbXZp?=
 =?utf-8?B?Q084RytpL3VtSU5DU2k5d0V1Y2pPY3N1WjFjSGJTT0YwRFk2dzVqc2dwckEr?=
 =?utf-8?B?bWNsR2dwRTJMaXhabGllTnBmMUFXYXJUaFRUcEEyL1hxZ0RTcWw0L3dDNjVD?=
 =?utf-8?B?YnhXcC90ajNYbEVPOEREYWhQbmhQblBLUmQ5YnYzR053T011cDZQbHpoUm8y?=
 =?utf-8?B?bCsrSFM3TU9DRk1FYVpmVkx5bko4di9USDJabmR5citLQ0tDVGJTQzE3WFJa?=
 =?utf-8?B?ejhnbFE4Tmdna2p5ejc1UDRLbjN3U1BZRW1vdHdNWTJtbjgzTFh5bzhGVEZT?=
 =?utf-8?B?UUVwbXB1VkFrZGxMcjRLVCtBU2U1VjB4bDhoeDJ1VnRTbWxLc0FWaldWR3BJ?=
 =?utf-8?B?ajdvY1lmdG9xT0srUWRLcTFESVJEd1NXbmtxOUNlMHRBR3hXK0pJcVRQSWlX?=
 =?utf-8?B?MVM5TS8zNUw2R2VsVFlvNXNKMVE1OVphQnptdUVORm14clh5VWV2Vld6Qlhu?=
 =?utf-8?B?WWxsWFMyV0FYNW03M3Fsa0ZPSnhjaCtlbTE1cmlGWFlHZE8xOFpTYmliQVJP?=
 =?utf-8?B?TzNDZEIxOFpEWTJ3RUJldCtuZGdYOUhlS2dMSVcwcDRqc0p1YnBGYU9CUEZ0?=
 =?utf-8?B?YXl1Ui9zLzRuc01OaS9mbHYvUTIwRzFMYVZVRm1hNk1NVmFkYTZUUGNvbElB?=
 =?utf-8?B?aXl4a0oxbTJ0QkdnaTZWdkpVVGZqSnZtMnBCeXN1NHk4YmRWWFlITk01TG5X?=
 =?utf-8?B?K0lTMWNUdFNYUWpRWFdtM1N1dkR4UFd1SEtpdzVvaTlpQllmQkFUK0luT2F2?=
 =?utf-8?B?U0VmdzdBMU1lUlFVS1NidFhqRnorRUJ0Z2dnRnozaS8rZVU5SGVyYzU4aDNh?=
 =?utf-8?B?T1J2R2NMcjFCcjY2MDIwZzBCR3Y4ZG5vbnFTWlFXYnpOd1BMcjdjNEdMd0VH?=
 =?utf-8?B?SEs5cG5ZVS9EbHo1QmY3bDUyaEs2RGxzWUlaelBTMFJLdTRRNEY5b0gzTHZl?=
 =?utf-8?B?RUpHMlZJMnpLa1h6Tk83SEFBbjFRTXBjZkw0MWg1QjBZSzN5S0EvYWNBeDFH?=
 =?utf-8?B?bll4NGJqaFA0cnUwck11aVpCMnFudy96UGt5MWZiUnFPd29SZmFaR2RKaTM3?=
 =?utf-8?B?aEM0YjhNOWdIVGxZUjdsRFRjMkdXQnRSekxYQlM4bWh0Nlo0K3VROWV4cCt2?=
 =?utf-8?B?TXM5eW40VnljMWNBS1RwZW9HdUwxNzRQVXZrblVsL20wZm0rSDYwY3dxSEpG?=
 =?utf-8?B?TGdKRWptQkhPM0hwQzRIUnR3M3Jxb0w4RVltdUIxT25EQmc0aFVZWW9LU3BK?=
 =?utf-8?B?N1Z5bjVVSHRYK28zTXVacnhNd1FSOXJnOWZBYlk5N2kyZXZPVGVJUGJ2YSt3?=
 =?utf-8?B?ejM2d1VGbmZGTTg4YktyM1RubDI5Ym1iM0hwZ2c4b2hQb2VOODZib2JEYmFV?=
 =?utf-8?B?MnNIUWhjbDdZaUdUVE5XMVBQdDZRRXBjK0NxeHg2cjM2Z1ByTTJGdm1GSThV?=
 =?utf-8?B?eUcrcXhoVFl0RlhFU1dGNGhrSS9SYzAvODBIdmNCT3V1bEJyaXl2QTBoaHRk?=
 =?utf-8?B?dGs0NzgvWldiTElKdkVLS0MwcE9mc2ZScmxjSlpzWlFtSDBqVXljU3VPSFo1?=
 =?utf-8?Q?wmhJJvzk8pwONiFg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <128302CFEC5DD54EA8549B5EF50F4E47@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: MD7QDqd7LjL0tlj+HQQ4F0tLwS5KwBngUKzZsoIYc91/ehDy6rEfGBc/GH77LragFBft3ZUrrrh6MwWZCrxxT98NrU/uYdf7w1PJGumXSi6HT8WjdMPEiPMgX+/xwsXIli0IuviA4HPX/ggvR8Yoiav/jciL3ukGUvw5dZMfr7TbAQ8aSnhYMoLcrzo0/5AfzqoK7aZfk5klTEYayvf0T4Sxw0a8dJFHwD6SskqZ7CgYguqxxiWlphNkMTLKOWwukVpoz7xktOd6TZyvx6iuGfdPhxe6cwSDH9oXh5VgxTmI4EXYkWlk3Oh7KwrZzHZ6prYyjO+T26+OYUmwXi/40Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15509167-7d06-42d4-634d-08deb4bf8e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2026 09:26:35.6111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JAxyXRSNF08GPZbmI3YAyklOFwyZx8EETPAz/Ppzq1qSLta2HCJFV+pBuT1B2fpYjNOPJt5sdRYlVqCfqWtdPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8673
X-MTK: N

T24gU2F0LCAyMDI2LTA1LTE2IGF0IDA3OjAxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBZZXMsIEkgc3dhcHBlZCBoZWFkIGFuZCB0YWlsIGJ1dCB0aGF0IGRvZXNuJ3QgYWx0
ZXIgdGhlIGNvbmNsdXNpb24NCj4gdGhhdA0KPiB5b3VyIHBhdGNoIGNhbiBjYXVzZSBkYXRhIGNv
cnJ1cHRpb24gYW5kIGtlcm5lbCBjcmFzaGVzLiBOb3Qgb25seSBmb3INCj4gVUZTIGJ1dCBhbHNv
IGZvciBvdGhlciBzdG9yYWdlIGNvbnRyb2xsZXJzIHRoYXQgdXNlIGNpcmN1bGFyIHF1ZXVlcw0K
PiBpdA0KPiBpcyBlc3NlbnRpYWwgdGhhdCBjb21wbGV0aW9ucyBhcmUgcHJvY2Vzc2VkIGluIHRo
ZSBvcmRlciB0aGF0IHRoZXNlDQo+IGhhdmUNCj4gYmVlbiBwdXNoZWQgb250byB0aGUgY29tcGxl
dGlvbiBxdWV1ZSBieSB0aGUgc3RvcmFnZSBjb250cm9sbGVyLg0KPiBPdGhlcndpc2UgY29tcGxl
dGlvbiBxdWV1ZSBlbnRyaWVzIGNhbiBnZXQgb3ZlcndyaXR0ZW4gYnkgdGhlIHN0b3JhZ2UNCj4g
Y29udHJvbGxlciBiZWZvcmUgdGhlc2UgaGF2ZSBiZWVuIHByb2Nlc3NlZC4NCg0KSGkgQmFydCwN
Cg0KVGhhbmsgeW91IGZvciB5b3VyIGRldGFpbGVkIGV4cGxhbmF0aW9uLiBTaW5jZSBNZWRpYVRl
ayBkb2VzDQpub3QgdXNlIHRoZSBwb2xsaW5nIHF1ZXVlLCBDUUVzIGFyZSBvbmx5IHByb2Nlc3Nl
ZCBpbiB0aGUgSVNSLg0KU28sIGlmIEkganVzdCBjaGVjayB0aGF0IGl04oCZcyBub3QgYSBwb2xs
aW5nIHF1ZXVlLCB1c2luZyBpdCANCnRoaXMgd2F5IHNob3VsZCBhdm9pZCB0aGUgb3ZlcndyaXRl
IGlzc3VlLCBjb3JyZWN0Pw0KDQo+IA0KPiBBZGRpdGlvbmFsbHksIHJlZHVjaW5nIGhvdyBsb25n
IGh3cS0+Y3FfbG9jayBpcyBoZWxkIGlzIG5vdA0KPiBzdWZmaWNpZW50Lg0KPiBUaGlzIHBhdGNo
IGRvZXMgbm90IGFsdGVyIGhvdyBtdWNoIHRpbWUgaXMgc3BlbnQgaW5zaWRlIHRoZSBVRlMNCj4g
Y29tcGxldGlvbiBxdWV1ZSBpbnRlcnJ1cHQuIEFjY29yZGluZyB0byBteSBtZWFzdXJlbWVudHMg
bW9yZSB0aGFuIDEwDQo+IG1zDQo+IGNhbiBiZSBzcGVudCBpbnNpZGUgdGhhdCBpbnRlcnJ1cHQu
IFRoYXQgaXMgd2F5IHRvbyBtdWNoIC0gdGhpcyBjYW4NCj4gY2F1c2Ugc2xvd25lc3Mgb2YgdGhl
IHVzZXIgaW50ZXJmYWNlIGFuZCBhdWRpbyBnbGl0Y2hlcy4NCj4gDQoNClllcywgSSBhbHNvIHBs
YW4gdG8gbW92ZSB0aGUgSVNSIHRvIGEgdGhyZWFkZWQgSVNSLg0KDQo+IFRoZSBwYXRjaCBiZWxv
dyByZWR1Y2VzIHRoZSB0aW1lIHNwZW50IGluIFVGUyBjb21wbGV0aW9uIGludGVycnVwdHMNCj4g
ZnJvbQ0KPiAxMCBtcyB0byAxMDAgbWljcm9zZWNvbmRzICgxMDB4KSBvbiBteSB0ZXN0IHNldHVw
LiBUaGlzIHBhdGNoIG5lZWRzDQo+IGZ1cnRoZXIgcmVmaW5lbWVudCBidXQgaXMgc3VmZmljaWVu
dCB0byBzaG93IHRoZSByb290IGNhdXNlIGFuZCBhDQo+IHBvdGVudGlhbCBzb2x1dGlvbi4NCj4g
DQoNCk1heSBJIGFzayBpZiB0aGVyZSBpcyBhIHBsYW5uZWQgc2NoZWR1bGUgZm9yIGFwcGx5aW5n
IHRoaXMgDQpwYXRjaCBhZnRlciBmdXJ0aGVyIGZpbmUtdHVuaW5nPw0KDQpUaGFua3MuDQpQZXRl
cg0KDQoNCg0K
