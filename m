Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B715918E20
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 12:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744634868; cv=fail; b=CYOfm8BF8ZqCs4/fTFSFToxSj9ITxbGqE+AOzvpjJxv4npxgDlIMvvEZxRaV43fBlbaXTAz2E0deNoweNynLAHeXZMoZlGjZlehmU6GrlT4au5dzruv/6jc0euYlIMNLlmGDylwW0pjcC1Jxq4qUhcZH59eKKJ28vU6Aq74lU7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744634868; c=relaxed/simple;
	bh=NdGFdVoO1CBuIbEHe6HSBxXMYWoq5LvuBdTaNw6Uepo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Do0Dl9nH8VcvRwsUCTYZhtayzXA/H4BHqtFzr7NfTKBDp6qeDC23atPgxGPLinyJQrzW7xYnKWTFHFWMqfjXU6qwNhBD7RB9fHlxuWLVRVWjg73reEXzSFumfjpvnIR+LRpYY7qQ/Iu8/VMbLa8L2WViOykUrEuOSVrrIrUhzwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Ay6GwCu3; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XccBb0vG; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ay6GwCu3";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XccBb0vG"
X-UUID: a15366fc192e11f08eb9c36241bbb6fb-20250414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NdGFdVoO1CBuIbEHe6HSBxXMYWoq5LvuBdTaNw6Uepo=;
	b=Ay6GwCu3uuHbTCPeMLrqEaMCQXZKb0TjpTm1IAUDlxKIdEIhC/M22FiCtrVhHjcy1JKz6eDj8P1MiltUi8h4l4VOhpYlCfzXYKtz/mnklJ9AtnNQoM78z4nc1WAbfVzymFLWpcj+b2wARbCw9I9MyUSE11za57VnGjAzSN5vC7Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:6d79755e-8864-455e-a011-b7dd9b0da158,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:eb010fa6-c619-47e3-a41b-90eedbf5b947,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a15366fc192e11f08eb9c36241bbb6fb-20250414
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 148698391; Mon, 14 Apr 2025 20:47:31 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 14 Apr 2025 20:47:30 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 14 Apr 2025 20:47:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mV0DwUxnZlbSPC2cU5sYUxNGNXmtqtWlnSGPSGg/Ko1qMeSsI9Lm3/+Gk0q9s+qZ9ZzaTUg+3X3gaUF2O+oTLtwwb+LbSMcLhKnTepeMgt/eLHDsW1GShRQZqD6gE/WLDfWyJSqBF+u1oTU5ri5gf0QQDApBrL+ki/7EtZpKd8FzdqG2Oogw6wdYmQSuWOWsGjoil/jjkuJf6emC15o1GnOkKIX7uFUWLwnskD3X7cTroXx6dLKlPujolnSrZlDaIKQQkmnMllZLjEWGnrxFLMWLEoigBNnBSleBxUw1fWOGAGH28jrl3BTIspcB98zS+4ggOYrUEyR+BgP/LRTSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdGFdVoO1CBuIbEHe6HSBxXMYWoq5LvuBdTaNw6Uepo=;
 b=xusodIzW7IIp7f17YE+mR/vy41RfXNqZCuyEIMf3sg3qp7vd039a6AffXhXkIRZ8WNgIIQczOcVRMcJdG5esR1B2Ua+1iS4TlVGOJWob1I8nrzajKtFfDv5p+3QMancCIBLU1mLDzbYVd7pKYgJ4Gaf8s4WuOpfU157Jf4POmSV3YBLC+zhhiU4v/aQe1ehudW7uCke1POsdFKVgo1ppj3aPgV87DfFKB7Qsv1WA8A1oSFqzMIJJ+t2FrR1s7gOU7tos/V+Q88MSoqXZDUgLQzVBVQihTM/yC/1QMVgTleUFAMyOIYbJhpGTzX2XxuoeLyKmVaZM5ePtFOB+E1Zbqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdGFdVoO1CBuIbEHe6HSBxXMYWoq5LvuBdTaNw6Uepo=;
 b=XccBb0vGS0WmrViIl33bFMpU+Pa38XoiIbLb5ZssMVL+CnvZNzqfJCUUlxBF/c4fW3G8O8kK3RN9ezVu4OcwJFNUvvpLAZYGWazER3opzE6DBPDZACfuh12Jp1kSfId3pdkVB+ua/KsNg7hE9R9kLWjAteJxQWGeLFGBVrX0DNM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8000.apcprd03.prod.outlook.com (2603:1096:101:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Mon, 14 Apr
 2025 12:47:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 12:47:28 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 07/24] scsi: ufs: core: Only call
 ufshcd_add_command_trace() for SCSI commands
Thread-Topic: [PATCH 07/24] scsi: ufs: core: Only call
 ufshcd_add_command_trace() for SCSI commands
Thread-Index: AQHbpN51tKbsVWNxIES4INbUprThCLOjLQOA
Date: Mon, 14 Apr 2025 12:47:27 +0000
Message-ID: <dd3b9a1f934d97e33de707eb8ca306ff600c8a24.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-8-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-8-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8000:EE_
x-ms-office365-filtering-correlation-id: 49836b6b-12dc-4f7f-619b-08dd7b528384
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NmlDWG0xbnl5SVJhSVBIU0xLdmhBRVMrOVljV2pBdlZnWFFMSWw3cGpPQ3ll?=
 =?utf-8?B?dDBkVnRyU0F5Y0ZiK1NEMVRnOUhBek1sdDNsejRSdjVvNmtjMWl1ZHBBcmRT?=
 =?utf-8?B?NnowakNvTTJuS2VOTWNQZCswOHc2TWZIY1c2cmNQYUJJZFZIZ09Gd0VjeSsx?=
 =?utf-8?B?b3FFTzVJd2RNV24yeVJaNTM2dW1PSVBEUkRyQ0xLUm56TFdtVDArR05rM3lj?=
 =?utf-8?B?ZTdSeFNUWjhRaVlvbVo2OGJORVRvQVJNVHBVMXAwR1MwWTBtTXA0dE9XL1cz?=
 =?utf-8?B?RDlvLzBmV3pJU09NZmVJaGRBcjZ1TzJ2cU4zMlhYdWJzZ0kyNzljQUtaN3Np?=
 =?utf-8?B?YWlpRkFDRS94bU5RWGxMbWdCSm5PWVJtVmQ3N3gzemFQRnFPQWdqc2JFTkhF?=
 =?utf-8?B?eXJwMlVsYXNFVHZSK0FoZCt3dEppWHd1RExyM21rN0ZlNjFSaEk4eXU0djRh?=
 =?utf-8?B?aTdQRE1sdlVuQXBtQTJoVTFEWkdlZDVXSXBOSjNZNzQvb1NVakZjbjVWY0lk?=
 =?utf-8?B?NmFwMVdkaENja3I3WlRFWEJ5aDNIajVmV01iMXhNZGRPczZOKzhhYXJPT2NP?=
 =?utf-8?B?MjRHM1JZQWllVStlMUpYT1FEVUlETXMyU3pzYkRCc1BVaWtMaHVXV000OEpi?=
 =?utf-8?B?R3FtSk5YQmwvdFZqTTJuN0Z5TCtnZThCTnM1OUhZb2xHbSs1WlRHOEZsVFJx?=
 =?utf-8?B?QUhkckVmYjZDaHVUSlp1Snl4QjdHYUl4R1BsSnZuUEVxTDNYdnhEYzZFVkVn?=
 =?utf-8?B?NHpBc0V6OE5kTjNtbGRUVkFvSC8wRWFjSjJrM1VacCt5R0phSitFeFdxTGhV?=
 =?utf-8?B?RmYzRmQxdVQ4U3NCY3NCaU9aT1p0aWVOeDA4VkROYTVubGl6Q0xyckN1VHo3?=
 =?utf-8?B?dUo1aEE1TW5OUzBpMEE4bm8vQWtWM3o1SkVBZmtnSlZrczAxYytEdXZBNFhz?=
 =?utf-8?B?VWxTMnRMZFIwSjU2Ri92bm9jRXJZTi9DUDBERE94VVJuWlBUSXdzNG5ENkRZ?=
 =?utf-8?B?NjEyRS96NkFySjBaM0N4R2JiWXg1OVpabGt1UHdWblNBd202MjJxN3orajRa?=
 =?utf-8?B?UkcwS3ljakp0RGkzbm4rd2o4bHNtQUpGektYVkV4TWF2TXpMWVJkTS9YaFlV?=
 =?utf-8?B?NWNzVDQvdWdoOU1UNUtTREduMzl5T2RvbTFBRFlpcEZZVE43L28vMWkzRnd6?=
 =?utf-8?B?TnMyNjduc1lsWHZBRWtQRUR3bUxsUlJvQTV1a0VQYlYyTm5aWTU0M3o1UE1I?=
 =?utf-8?B?RkFXVjEyMjk3ZVpQWmlSRU14a3QzZlovWDl5dW5JcmZmZWdpelg5ZnIrcG9V?=
 =?utf-8?B?d2FGQXJnUTBYVmFiSDlFc0NSUmd1b3RjT291dERyQzJUemFJdFV5RzU2b09S?=
 =?utf-8?B?MnA5V2hBcmR1STFyaW10S2FuSG5uamY2TXUzSGxJaXdvblR6Ym1ITWtuQmdt?=
 =?utf-8?B?M2JMQmhoMm9GdUV4eGROZXRDTnpPbUlXK0JVMG1HKzVLNG8rY29JVTI2eUE5?=
 =?utf-8?B?MFJCUlcvNEx0Q3VGM0dQNUEwNUJTSGRBZ1lGOXdzcUlBbWlhUDhCVHJyY1l3?=
 =?utf-8?B?a2o1cVJ1MGhPMkg1VWZIeEkxYjVGbzVVVS9kYklzcGJOUW9Td29MR1lNM0Nn?=
 =?utf-8?B?TnlSamVTaTlRYkJNb0N5YW9CdXErbGJYV3M3TnFpR3UwcVpFeERua2Z6NVRK?=
 =?utf-8?B?OGNUY1BEMFp5a1U1alpjai9SQ2ZvbVRkVFh2UlI2dS9oQkhCRzlBejFhTEFM?=
 =?utf-8?B?dEFpVlh4KzJ4OFJYMDN6bWQyaWFGNUdoajVyc0t1QjFHZm5vbDZZQXNXVGVp?=
 =?utf-8?B?N0VJK01BWDR3NG83M3JrYWlUOGVQLzlqY3N1ekxDUEVaSStDQWdVaklWalMy?=
 =?utf-8?B?TVFUVm5YWUQrajJJdEI1N2RkM0creW9QTW93SDlqbFRqNERkZ0FocnVzSDhZ?=
 =?utf-8?B?SEVlclVyclpsT0x4L3FXV2RDYVNuS284STBpQld1cmJ4YVV0cXdQTmJrVmky?=
 =?utf-8?B?bWxyM2l4ZmpBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFA0RlF1VWNzUTM2YTV0OUd6T2ZHZHdOaDJwbjFTb3djWkVZSzgvTndlS1Fx?=
 =?utf-8?B?dWRKenFvOVZ2Qndxc2RpbHFhbjAyeTJPYStRMk94VG1iRUMrdXl6UDdQNnRm?=
 =?utf-8?B?SFY1Rmx4YWQ2bkdQTmZrTW5rQkt4N1JBdG1uaHNKWEt3eE1IZWVvL3E2UWNx?=
 =?utf-8?B?VENYV0xIT0RJNWUxMkg0WDFFMlB0cGZYY3VNMlorK0cwVmRteHg1d2hPNWh6?=
 =?utf-8?B?S3RTbTFCTHJaaGFFQW1yMXYyNE9HbG9sNFF5UUdJdGQ3NmJqRXFrR2FDYTlP?=
 =?utf-8?B?RHFzazV2czNqeGgvRHdtS3RIazZYNW96NXdGY052ejdrYmc5c3cyUytaOGxN?=
 =?utf-8?B?cnl4U0I3L052aXNsZVcyK21BWHZaYllTRmVPODZNYXRnT2p5RUU3dkpxUnM1?=
 =?utf-8?B?WmtJWUxvbjJXZWRFdUZEWW5kblZabWd4Qm9iTnFzSm1ySVFZUjVTZnRhb0tG?=
 =?utf-8?B?elladzlXeFY2N1IyS21WSzVyR014T0R2U0t4b3hMcHhMaVFlcG9CUk5UZmZt?=
 =?utf-8?B?TDdyWjQ5QW1maWFyMGRpUDlXdHBSVnhWR0pZeWs0Uk5FcmNqZytkQWkyZkZa?=
 =?utf-8?B?SHIvQk1vdDdCZGRHa01TaGVXdHp6ZkdzN3ZESVczOVN1cFk0QzlYdzcycnFa?=
 =?utf-8?B?bUdMRm9ONjFQTDI3MkpzK0dsd0ROWlBoNVhiUHpxY2pxdEd0MkQzU0Z6eDNN?=
 =?utf-8?B?MmJybmpTZFgxczB5QWI3dzhTcEcxaHRrMjRyYjZwdlh3QnczQVp0akI2UjU3?=
 =?utf-8?B?aVVxd0ZNUmo0RHdMcmRUelh3bUhNV2RXT1dnZUpaQ25TcXhEWTQ2SGYvazRt?=
 =?utf-8?B?R2EzZEpJRFNJeDNPMnpuUXVmd01lN3dLL0ZRNDFneVJqUmlBVTNyUDlCVGtK?=
 =?utf-8?B?TDNCVytacjBmMmRhK01SOFpnRmFSM1E1K1lzSHFmNjNkSEp1dFA5T3RxOHo3?=
 =?utf-8?B?YUl1SDM4Mm1MYnYwcVBtWWVBUTZScDZwYzRiYnhFeSs0dWxLZ1NBTzE5THFv?=
 =?utf-8?B?NXJOUnl6MGQraTJwd2pCbXF0MHhvZFhBaEdoMlJHUTBSbHlLTGUyU1JZSXFq?=
 =?utf-8?B?RHovai8xSlZGeUFpWUVQUktOejFzWktsdVpjcStRRmo3MXJ6MTJjWi8wZWpS?=
 =?utf-8?B?VTBUbENtSXlJYXRVYzRWQlRMREtYOThKZ0xick1nS0Q0eE1FckJHT3RZZHVQ?=
 =?utf-8?B?ZmQvaEZwOWdUQ3RMMEJKbHpFb1drWld2aHRDdTUvaWxicVBwQy9rekp3S0lw?=
 =?utf-8?B?d0tvV3lHWHlsUWZXUjg2TGNjUi83dnY4RlRRMUYyV0JTU0tQd0VMTHNFVWF6?=
 =?utf-8?B?MTFVZWt0VGRhc1dQd01iTjdSMHo2aWZZeTNWMTY5M1lkbGNKNmR3cnBsMS9t?=
 =?utf-8?B?ak5rMFVNMk9KaVhUQ3RObGxhRFBiUUg4bEN3MzIvVU9DMDhKd1FaeWlRQXcr?=
 =?utf-8?B?OHowR0FSTG16SDRGUEI1a2lhdUI0Tjl3RVlMRFZiZUdycC84emc2cFYrZDVJ?=
 =?utf-8?B?OGpFdGMvUFdNeWh5VlV0aVlaTzZhTnRyVWlYdStxT2RRTzhGNGlXYTZ5cUVH?=
 =?utf-8?B?RjBHeXpvTVJ3bkR2RkNnVnFMci9oaHJaRmpwaDRRWm9pcEVPQ0pvcHdPeWRz?=
 =?utf-8?B?bFNqYkNiK1hWamk1ZmpKcVVRSXJYLzllS2pSbTlIc2lyR0dSdFQrL2ZUM2g0?=
 =?utf-8?B?OEV4MWM0UHV6RmNnQlRQMk5SeGZGY3I4T2lsY2ZMNG1GY2l0aU9WajBRZVA5?=
 =?utf-8?B?Y1Yvck9vWmVBRDk1N0xZQy8zbnE0YytOM29mVGw0Zmp0YmIydUw0anNxMldl?=
 =?utf-8?B?cWppOEhBK2NPTkNnYlVGNTlSeUlaM1JCSi83TEpOVWN4MUNBZjIyVG4wZE1Y?=
 =?utf-8?B?QjduU3c0cHpYZkE1VGRlNUt2STF0S2NuTUt3aFJ5QkZRTkFtK2V2V2l5bmNK?=
 =?utf-8?B?dXVjLzVTREduTWJuVnpNVjBqTm4wOVJ3YXNVTC9sQlo0ZDV3QnA4K3hWMzMv?=
 =?utf-8?B?a1VsYVlQT1RxVGJmcS9EdVNIMGUxMnNvQTgxd2lMeUJXMmc4RUZGdDFMN1ht?=
 =?utf-8?B?NGE5ZEZiK2ROMk1SZmw5VkEydGtPNHc5dHBONjRpRjJMTEUrenNhN0h5UjFp?=
 =?utf-8?B?ZVNPanM3TW5tL2I4WHJvSTRtZ1kzWm94WmFVakorOHliTUo0MTlQcFJ1NVRN?=
 =?utf-8?B?c3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <312E0E211C9B554C984B36D5C9AB3E68@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49836b6b-12dc-4f7f-619b-08dd7b528384
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 12:47:27.9964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZCj9UvO2/mXd510A6YxhZoyH7viMn2TX+a9Wp5lTI8CpfvaXDwmlpVOJs9KmGs4o+kKx5484HwfWf5XBz2z4vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8000

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IEluc3RlYWQgb2YgY2hlY2tpbmcgaW5zaWRlIHVmc2hjZF9h
ZGRfY29tbWFuZF90cmFjZSgpIHdoZXRoZXIgJ2NtZCcNCj4gcG9pbnRzDQo+IGF0IGEgU0NTSSBj
b21tYW5kLCBsZXQgdGhlIGNhbGxlciBwZXJmb3JtIHRoYXQgY2hlY2suIFRoaXMgcGF0Y2gNCj4g
cHJlcGFyZXMNCj4gZm9yIHJlbW92aW5nIHRoZSBscmJwLT5jbWQgcG9pbnRlci4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KDQpSZXZp
ZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo=
