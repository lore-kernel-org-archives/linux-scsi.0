Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB232D5C78
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jul 2025 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751630680; cv=fail; b=n21EQLXvqpdxpMzafAJSlujrL2m2t6Kd3i18jSO/9oADl5z3H/8uzwb3ICl4DfS4mPDshwGX7IasQNO3Cw5khK6CzxKQvqBfWOEBg3oT8tfVz4f0ORMf+JDFOwUfEL9oeQP716mTVHj/pbDxYESBwil/A8f/uKC2GfAV6cdtSZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751630680; c=relaxed/simple;
	bh=+3nqMZ60bD34f3TcDd7Tin4siOvgdouqiMtqMQBeGlM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E4bjOgAYReG5iUjXPORXYEY+LdGSCWdyXUHpTCtqYKZk8tSFCM012imoQnWW+5WjiIXx+Qn+G/JR6i6+mPj9vIO3ZwNLfPmS+VYmVHdszmPFLdNlMk0FwAEaSz0l1UdvLVW92qhn9Om6nXP3YVdVPOGd1xCspNG+DJlGDhF31Uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NJ79xT1g; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jegdHH20; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NJ79xT1g";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jegdHH20"
X-UUID: 0c972e0058cf11f0b1510d84776b8c0b-20250704
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+3nqMZ60bD34f3TcDd7Tin4siOvgdouqiMtqMQBeGlM=;
	b=NJ79xT1gXBJJqe+BApHEvf8Td0VaIlDqqnnLThLd9ZO3ifefLbopW7AE+dk/g1SPRFAODVfMeEzhpC3DTBuSaCzfFt++cDfmOLmWuEEFlcIx/Qb/Kom7nzadG38lIjxjBe8L+3tj+RPpT2LNbfCA4pDA97DM6RsZW1XoaLb8FAk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:6dd8768d-caf8-4272-b2a2-3c4615aeeccf,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:1af28482-cc21-4267-87cf-e75829fa6365,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0c972e0058cf11f0b1510d84776b8c0b-20250704
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1975589601; Fri, 04 Jul 2025 20:04:34 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 4 Jul 2025 20:04:23 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 4 Jul 2025 20:04:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCBoxwNpp8aTss29Tfz/kmy865OAEXQNtgQL9YuI8AF4Tcxotij7eo2EpEzFtPstdjIuWqb3NHs2DF36pPlq6PnPi5TvqQxYcBW8VSEK4J0yEimxoDw7IjTEn3SgyMCksp2QMAeKEdox/kmZ9xDaagl4OYRzL87QyW8J82rsyr6V7yN3n0xwRf7rHAT4iv+RA651kxIg6hxCkJNdntkwFqoG4Tl5UGxD1ulfVvV1ddCa26jRSXq4HKFcBj69G7zQ+bg3lWc/fSgQohMLppCIaxvWWjr+NS5sQf7Tv4dyuQ0yZ0hzztk+BL9sC6S8tx+3VuYL05NMt2Y48wlPMKj6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3nqMZ60bD34f3TcDd7Tin4siOvgdouqiMtqMQBeGlM=;
 b=o5yYeGHBs8NyaJCIOJMRJN1el/gEYqxxy+O23BpoR+p24PwuJY+SQ1MxryvFK1xsnSmv5ZRhtvgE+GpWnMhLMuyeAG4ajdRwn3XyGYqr+bW2nM5ojx9a4rPod2dQaIxvXoBVlaAKYvB9jcPqoUeMLGzGvElFZ/2mnqeLDQ3WPSGt9rL/2jmfxhRE2U0wkH/GjZrydsrKB/KURRjUyB2tbQ28CBHBdJBRn6XGjEHtB3zsrYcmUEvQTdwj68hUusH1IOlNenRj0FeQH7iwEm451CmmAs9H9Lx4h/V7Yqe0SWem5vDlAGmJt+OklvRl0Fa0dq/1mfyknVZalTWF4vqwcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3nqMZ60bD34f3TcDd7Tin4siOvgdouqiMtqMQBeGlM=;
 b=jegdHH20AtKZQGhEgoB0Ilfaj1/oYPr08O48KgDKJHhX3a+efdFxeCbpLhUMkfu7IF3VuhWc7Fgo/5u3EP2+/G4P88YUrnT0gSf/yTH4/1Yznc10GNFwedQaiIx4aJyIEMtaArxI88tUNE+lf3DKecEQzj6vwY+M0HnBAijiGkk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8167.apcprd03.prod.outlook.com (2603:1096:400:453::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Fri, 4 Jul
 2025 12:04:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8901.021; Fri, 4 Jul 2025
 12:04:30 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mani@kernel.org" <mani@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Make ufshcd_clock_scaling_prepare() compatible
 with MCQ
Thread-Topic: [PATCH] scsi: ufs: Make ufshcd_clock_scaling_prepare()
 compatible with MCQ
Thread-Index: AQHb5USCMiceN2atgU+6IQYwmZf2kLQh7Q2A
Date: Fri, 4 Jul 2025 12:04:30 +0000
Message-ID: <c5a7711bdb370413ca05b8a71743a6cf5ba4d7de.camel@mediatek.com>
References: <20250624201252.396941-1-bvanassche@acm.org>
In-Reply-To: <20250624201252.396941-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8167:EE_
x-ms-office365-filtering-correlation-id: fc168b38-50c0-4d74-f45d-08ddbaf2eeaf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZzVtREZHU3VuMFUrd3dHVlZJZkxFSnFFdXo3NGFzckxnWDg3clZmRFFRa1R0?=
 =?utf-8?B?azFlL1lJKzRIRSthNUVmaGU2bit5ZzJ2MC8rNnZ3anpLU05OS2ZkYytTNXJq?=
 =?utf-8?B?Y1BtVVpiVE9FT1BzS2t6dGhXRi94K1hyb3h6Z09Ca0pWSDUyWEo0ODU2dnZs?=
 =?utf-8?B?SXI2V2JxTUF2L2I0ZHhObmJMSGJyTVVMSFNJR3p6YnZZOEJ0N1BVaGZvRTRO?=
 =?utf-8?B?bzRIZGlJVFhvWDRvR3A4NEVqQm9HK0RKRytObys4WXhNOS9vakpOSHdmNi8y?=
 =?utf-8?B?Q2lxbURaaDFTSnJhV3g4OVE2VG1WNFVjMGdhNmJrRmVhZ0plR3k4MUhuSmhr?=
 =?utf-8?B?N3lwUXpqbHdZWWxSbEt5SFdWaVhsWjQ5T2xFU2YxSFFpcGl5RTdDRWhwK1c3?=
 =?utf-8?B?ZE1iaENpUUZvazFzbFRuMmFhdStReE15WlZlb1NaalJrV3Zjc2dvNGFpcHAw?=
 =?utf-8?B?S3Rjb2RzcE5YMmRaMFFrNzFGcGtrWkJSNHl0OFB1M1BLOFo0ZjBzRWlSQ1ho?=
 =?utf-8?B?WE0yN0lTQzR4eU5RRCtVSEtTSGpkbHNhZzNoVEgvNHBCU2NKZXRnN1JVRUlR?=
 =?utf-8?B?bXljbVNFeXZmUjY2U2g2MVArWURCLysxbjIzL0xGTW54YkRtOHBHZHFZbU9Z?=
 =?utf-8?B?dG9MRFNjQk9OWTlPcVZkVWg0cHpXV0JqZ2hKR3Nxd09rMHVRSmQzR0MxeTlH?=
 =?utf-8?B?bS9YbGZVYVBYaGRBTlpkeWg3YVE5NkF1NWtJaVJ6SmRrM3ZpOG9VTmJsUlVq?=
 =?utf-8?B?TUcrUkVQNzhVM1F6eDYzbHJNWGJKNVVMREdYMVdiYkRGU0cyTTA1Mit6cXJM?=
 =?utf-8?B?OE4yU0dlQTVvdGswMzFsZEkzTkJhSWNSZ24xZzcxRmIzRFR5YmVURE9VME1s?=
 =?utf-8?B?Q05PbW5lVHpraFh0SUVRQ0Z4dUdRTmxEUno3VStQMmRBa3hRaVBBbEVSQ3I2?=
 =?utf-8?B?Tnh4Qjgvd2Npa0hNT1N2WnpvY2EwMmZxU0I3bGhpelJPMjQvdmNoKzBwY2VJ?=
 =?utf-8?B?M3RqVTlLdVc4ZkFZV3hLNHNNdDVseVg0R2tJc3FGSlZiSkdHVWE5bmxMLzdl?=
 =?utf-8?B?cUp4RHlhOE9ISVlmQUQ5NUNhdEw1OWhNT1J3cVZsWm5hM3Bab3UyeGFzWTkw?=
 =?utf-8?B?d0M5NExNTEpuUU1XekJDT084UDdEaGErUGt0ZDhMOHMrNkVnYWlCUVlhZzcy?=
 =?utf-8?B?czRJKzZqTWxLbWlacGN5WVBGMnMrVnRnM2d4SlQ1eE5HTjc0OFdvVVIzZUJC?=
 =?utf-8?B?M2NPMlJveFd4OHNOZEJrS0cvQ2d4MjhYK3JCZlpqVm55TkJRQnJVVU1iQWZ0?=
 =?utf-8?B?WEY5Q2ZBRkJHb2ZoSnQyajRWZFZ5dVZTOXBHWWkrTFkrTnlpV1BuLzAxR0w2?=
 =?utf-8?B?QlZFcDJ3am9ZdHlwdVBDMjYwY0E2NUFHVWtFZmhpbW55TjIzT3E4SWJzc1Vu?=
 =?utf-8?B?aHozSkRqZktza0ZodllGc3RadC9oQVZMTDFGNGtTa0FwVUVRaXFlVExtSkdz?=
 =?utf-8?B?WWNtSWR3Z2FJOE9QbmJXaW5sUFlpaUJ6QzhGRStjaTlKZXFqWU5FY2JUVGhu?=
 =?utf-8?B?NktsTGk1RWpwbUtaSHBYODI2cjNHb3N3dHRzVkhFU2hjdUIvSDFjTXFSbG10?=
 =?utf-8?B?bHhmK3hPSVFkemw5RXNlejBReC9YK29HNkVhTG02VW9CSjVwK3JicmhqQjBi?=
 =?utf-8?B?NHpxdi9kZURycHJuTDhMMUYxYXdMME1Da0s2ZllxMXIwTG9WZmpxeGpKRWFJ?=
 =?utf-8?B?MjR3MVdpY3FiRUdiRFpVSE9XRFVhUk1SQktZUklpeEJaQXpuQitESjlhSWhH?=
 =?utf-8?B?ZW9QY1k0UGMwYjc4dVJNbDJhQkd0UEV4Rk4zSE9McCt2Z25YdjN2S1RQYURq?=
 =?utf-8?B?VHdhL1BPeGQ0U05aTDJZeHM0dlJDME5RZTF1RlRQWEVJcEtUNkZZcWZENVlC?=
 =?utf-8?B?NlNnajVCWFFibHFDdytiZFZDVjlrZW1KNTJyb3dYcFEyQlRML3hiWElTeWR2?=
 =?utf-8?B?T3I3bCtwQWF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjZRVnNLaGVzUU41bkJzV3BZZWJPSlFsbzZtN3FqYk5VZ3Rza1lhL3d3bjlS?=
 =?utf-8?B?OU11RzFwZzZTc1FGSnFiSTVReVo4UkV3UFZNY2NiWk0wb1VZZ3JqaUtzdU9B?=
 =?utf-8?B?RVU2d1QzbXFKWVQ4YmtodUh1TFhKZmk0OXVDR2EwcWdJaEdVYzZIMzEzSXJR?=
 =?utf-8?B?VmJTKzhsdGRrdjY3M1VlMENnVDZqSzFtRWoxWU5sb1kvallhQXlxR0dBeXUv?=
 =?utf-8?B?MVNOQ1VXM1ZEUzYwMXo2VEFubVZ2aHBIZkVzYmU1TFZjQVhxekNyY1owT2ps?=
 =?utf-8?B?NGxhVUJWeEVyTFJuNWtiL0JTNmhYdE9lMWJ6enZnN3prTVRsWTU0dmpVUDhk?=
 =?utf-8?B?QXE3bU1OdjErTGlyUEtER3ROcjR3Uk83N0t5NGkydDRLQWhFc1B2Vnp4c2FJ?=
 =?utf-8?B?U25pcjhUWEE0NEE1bk1GK1JQWmFreTF3Ti9qYjR4ZDVEdzB6My9BcWIxR0gy?=
 =?utf-8?B?cFhmZ3JBTGhXNnpLM1NMUjI2eXdFaDF0V20yK3dLR25TdGR1R1UrRlhrL2hS?=
 =?utf-8?B?amNzajB1b1B5bW5TOUZLcDFkeTEzSnNkemVySTNRSEVkMDFuZWI4c0xLRHZy?=
 =?utf-8?B?bUROcXpSNElyV0NlT0VlbWdleXZ3ZXp4VG1DVnEyZTFRdnlCSnlza2l1K0k1?=
 =?utf-8?B?R3ZaekJpWHpFczRFNHNjRXRLQnhDZmNLZzlsSEJYRm5BYnRFaGw0STBTb0t6?=
 =?utf-8?B?N3B6U05zWEtFd2pZQXNlM0x1am9sZTJVZnR2UFdmNHBRR0RqdGVCd2JjZVJS?=
 =?utf-8?B?N0tjZWhIbjJLWmtNRGdxNUEvWHdBbTJKZHFRUjd3M1dsbm5OaVg1TUlnYnIz?=
 =?utf-8?B?L3VDaVljSmdMZ0F3VVlMTFE5bnY1a2pYTzM1TytEVERpMm94cjVUcnA4SWVz?=
 =?utf-8?B?anpPTlRucUpjblNSS3dET2RVY0JHdElmQmNRTXlXbzZUb3hiMXBEZkhueWIv?=
 =?utf-8?B?aTExMmhNcHhDc1JOM3VPOE5vemE2dW1INmY2S29lZGNQb01tOWxRNUFMOTNR?=
 =?utf-8?B?bGpyUWF6akJIRjNXeWtRUUNIQUtlWkRCdjNPWmRjcGluVWpuWTU0Y2hxSDNY?=
 =?utf-8?B?ek04WXNJc0NDZ1VQQzVtN3pET0k4SW9FYi9zQ2llTmNZUGlhSEdFOTRUVmQ0?=
 =?utf-8?B?cDJNL2VTbWFCaDZPU3g3czl4L2hLSlpQNkwrZXVVdWg1TXYyYlVyNU5FZFdN?=
 =?utf-8?B?WmpzajFQNVlwUWgyb21rbXJnMVVNbDhzMGRXNUpxSXIxd0NRMjhvM2dtai9W?=
 =?utf-8?B?cnN3RjlFVWo2b2ZtTDk0eWY4UHU0MHJhc2Qvb09FRFFiTEYrTGdscFA2T2Za?=
 =?utf-8?B?VmdVcVQ3d0FpUS9XU2ZwMnZwTkhiMzhRbXZDU0ZSUXcwYkZ5RnB6Vmx5dVVl?=
 =?utf-8?B?VVVWNEd3VGRITy9EdGNQNTI0M3ppclFwcDMvWXA2RWVidTJSRTllbFJFS01K?=
 =?utf-8?B?c0UzODBSRFNpZ0pvWG5xSmJPM2hvaXl2L3pQQ0dxOUV3bnBnRktMRFltNWxL?=
 =?utf-8?B?enYzSEROQmpmZUtkVkxTOGo2bG1jUFQ0YUdzYmJXTTZFNjY5K1MvdXg3SEtl?=
 =?utf-8?B?azdBUi9lcnNwWjZ2UFNrWGdhSi9oSkNIa1Y5UE5jdlc0bTYxTnFUSEN5OXVX?=
 =?utf-8?B?V1htdEZSVFVxeTNRRU1IRDZUNmgzZ3dwak9lQ0NPZWw5WVA0WGtlUWNYZU1i?=
 =?utf-8?B?Umh2WjBKRWNVbUlyS3R4eHRJTDhpMFdUbVF1RnNwMUhla2JqaWxzWllXTm5I?=
 =?utf-8?B?dmlPdEJvRkIrRjExT1FIaHVOSUdzRWtjNG90bG5MVzNVZUlUdGZyZUNQVkg4?=
 =?utf-8?B?RFhDVlUyMldsbXNjUzhnWjkwS016bEdpc2t4c1JhVFB2WkcvdnZGODJqblFx?=
 =?utf-8?B?enB5VnVDUEdoUU1HL2FpQlhTL1BDcktjSU1QSVlxRzBrbjRwRndEVUwxMk10?=
 =?utf-8?B?Q3dlcjlLNk4ySjByRXphTDArZE1BckJ6WTl1RWUxak9YSzVsTlhPb3lvY2Ns?=
 =?utf-8?B?bUVUYXJwMHdiRlhpckdFeVE3TXYzUVFqbm02Vmtzci9QWEZEd2l2WFcyd3dP?=
 =?utf-8?B?azdVTkd6STdjbFhRcEFEZG93OUZybEpZUkJuSHVVYXVLa3NHWHJmM282b1B1?=
 =?utf-8?B?MGlSbm4rM3p6VEhMZEk1RXRjb1ozaTJlNldwNjd3V0R4ekp5QkNZVnBCV0Qx?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1C1EBEDD8F0FA40950E12435EAFD08D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc168b38-50c0-4d74-f45d-08ddbaf2eeaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2025 12:04:30.5346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8MjziZ0XpACp1DdZO4aNY8G5Y6Sgw40eF3UxQS7mxYYE1U3rAVqCUowVImzltv3F/lVFvk4gBSnLoPtAoOrqXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8167

T24gVHVlLCAyMDI1LTA2LTI0IGF0IDEzOjEyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IHVmc2hjZF9jbG9ja19zY2FsaW5nX3ByZXBhcmUoKSBvbmx5
IHN1cHBvcnRzIHRoZSBsZWNhZ3kgZG9vcmJlbGwgbW9kZQ0KPiBhbmQNCj4gbWF5IHdhaXQgdXAg
dG8gMjAgbXMgbG9uZ2VyIHRoYW4gbmVjZXNzYXJ5LiBIZW5jZSB0aGlzIHBhdGNoIHRoYXQNCj4g
cmV3b3Jrcw0KPiB1ZnNoY2RfY2xvY2tfc2NhbGluZ19wcmVwYXJlKCkuIENvbXBpbGUtdGVzdGVk
IG9ubHkuDQo+IA0KDQoNCkhpIEJhcnQsDQoNCg0KSW4gdGhlIHBhc3QgdHdvIHllYXJzLCBNZWRp
YXRlayBoYXMgYmVlbiB1c2luZyB0aGUgb3JpZ2luYWwgbWV0aG9kLCANCk1DUSBtb2RlICsgY2xv
Y2sgc2NhbGluZywgd2l0aG91dCBhbnkgaXNzdWVzLiBTbyBJJ20gYWxzbyB2ZXJ5IA0KY3VyaW91
cyB0b28sIHdoYXQgcHJvYmxlbXMgZGlkIHlvdSBlbmNvdW50ZXIgdW5kZXIgTUNRIG1vZGU/DQoN
ClRoYW5rcw0KUGV0ZXINCg0K
