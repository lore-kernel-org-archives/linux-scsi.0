Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96DF2E3EE
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 05:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724305011; cv=fail; b=dXISXOwrv4G9LpUM4614WLf5bKGdHDqa+7fBSw7Czk/Ad7o/v1724RDie8QM6eQjFgDkFg1Dc26V8iUA+sTaBC/4jwmZ5M/8gJzoIUuYATdgvQCAktAfKc3IlC1MBV535J/trLRa1r0SD6eQKqOLWG155vpTk+Z6jzf82oMQGYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724305011; c=relaxed/simple;
	bh=6OfOXCx1nC6aMsABeUuiFVmwr/gdZSNsbyTU4SMIqSA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cIgAeY2dF63vkUyx5qPlkuEgo7NM2GURXsa77QhFrOPSLX252U5imWwax+K3c672jpb8ptPGDdeQ2+WUT5ccoiQ4yJXcUMLMcDMj0pSv1EwS1X57IiWS3/eVD1O0CAEmNvKcfIbEWXRI5K67/NaEvRA7Cj8fB8rSO2SoebOcBxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dXEjm9Dq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=W369tln8; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dXEjm9Dq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="W369tln8"
X-UUID: 7ef316d8604811ef8b96093e013ec31c-20240822
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=6OfOXCx1nC6aMsABeUuiFVmwr/gdZSNsbyTU4SMIqSA=;
	b=dXEjm9DqibbnUTPxJ46c8mdqRmGQFFtS6j0H+qq5nSWLSVCFHyX3/xuyjoNG3Tm1uo3bte3IA/w+nuK9G4j83l5alrS5Zo4Lv20VPylqignalm2v9YHVn0taGxD4chRWwEPKth90+9e4cLOO3grFrkOgINlmsSQGrsyXGxGq938=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:4b0c8879-4460-4f73-af4c-d84359c51a25,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:d212fece-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 7ef316d8604811ef8b96093e013ec31c-20240822
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1946697067; Thu, 22 Aug 2024 13:36:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 22 Aug 2024 13:36:34 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 22 Aug 2024 13:36:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+Muw0FXLzCjaGJoA4vrv43baXhlHmkDnmi4nyGYZXx5O0kuL65JcM/86bfPy3bFWN6nC8q5UySOD0rEZCwAWjm/XGvLoEGfVMgxoo+tAXoOERkmP5KOv0xAFEi5YAwrOmpn44F68ClS6gwQRpyNuWvOVebpST3LUt3xYUs8duZqFKCOb/n8q+M+x/QnPfHoOJViXMQo6XhsVzcW0LkaQEQZXJbWkq5tqYOeV4ei0miak/Mgs67AtnZFG6GuyDFO3kbq6+YzAJFOvbbY86ev+KSlfaV9l+t8EuA1oqxlo/UIh856rMv5e1y5o0cals0QBaPaHgqMin3MpWnKmBXgNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6OfOXCx1nC6aMsABeUuiFVmwr/gdZSNsbyTU4SMIqSA=;
 b=uClntl0R8UlEyWelPzvUyKFMZK9m/T3rQUza3vJh8gASczsQzdo7YmzNJG5qPQzZQOA7uInqzqNNT5CQGY/hn0pmN+j0Ni1q5JQA0p9ntsl9zqWjXowroPCOfDnDePPD0MCeUockU4c64Wqaea2zomXzZCHZLwbmZFIbLwXZV5QLLeVGS4uKBswLZ5EZHMncPggYRzdE3COzJdLF8rQgFx/8Sbq5n47XktQEMPDelPcxfXtiTzd4v0NBzc4kA90/jyscmmLCfF4xkTmsM/6Hj7QdNjqwYzN9ZsirQyv1xYqUyYKuv+9Zv0GCa6F/R1IflFskmXTz7eahkBemsrK0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OfOXCx1nC6aMsABeUuiFVmwr/gdZSNsbyTU4SMIqSA=;
 b=W369tln8JLT+tljuXwiQAPJxKACEWODNPAz0UrkoToGUBdSTKatdcaaJFoqWVE3KJ5igHoKBbp6NXaHHrF6uYu6vs4hFY4Lql1+AxQc3ymuRj0612hyQ/qI/8gcbDvJKXHFQP56yZjfkzd6UXQPC7wKTUiXHasDngnOPkQqXt5Q=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SEZPR03MB7839.apcprd03.prod.outlook.com (2603:1096:101:186::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Thu, 22 Aug
 2024 05:36:32 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%7]) with mapi id 15.20.7875.019; Thu, 22 Aug 2024
 05:36:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Index: AQHa8/g1O9xCFCXi4kKybU2KvbfJOrIywowA
Date: Thu, 22 Aug 2024 05:36:32 +0000
Message-ID: <c8cbb579dbbbc9f9676e79d13339e8802e5d2212.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
In-Reply-To: <20240821182923.145631-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SEZPR03MB7839:EE_
x-ms-office365-filtering-correlation-id: 0b4a7a46-50bd-4897-dd28-08dcc26c6174
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V2UzczhUWVFxU28yUnlzdXRXajZnZ3BqeWFsaFRFUldQNGtabU5aZkJzZ3A4?=
 =?utf-8?B?VGRjaXN3dTUyL29peTRIM1VtbFAza0xOd2dUTlJ3cEZZcnBnbmtTTFp4RXht?=
 =?utf-8?B?d1NneUEyZ1dvanpqT3YrdktnTUdKK0J3dTlyUFAvb05GRWU3b21jaTlxeUlu?=
 =?utf-8?B?ak1hZkZvcEIzdUJCUmIxaERWVkNIUTVGUXorTSs2UzZWV3BxQ3gycHF3bXNt?=
 =?utf-8?B?a2N2ZWtBaC9pZVdlUk1ZbGVXbi9RWFBGOUhNQlh4S1ZZeEJ2eWFkY0lkVWMx?=
 =?utf-8?B?c3Z4cUpHQ1RmY1Y4QjVNeW41NWlVYWExMzF1QzRyOWtzZzN2K3FjUUJrMENE?=
 =?utf-8?B?YktPZU9CTWkwZGxuMzdpTVc1Zm1DRmxzWDgrQVBVMkJhUVE5MEZQdnNtUEps?=
 =?utf-8?B?a21vdW90Y2p4MHB2cFlLT1hMckxGME0xeGJ4ZDZZUjl4TWo3SjJpVDVFM2RJ?=
 =?utf-8?B?cmhHb2V1OERsTGwxeUswTHFMNDh0TTE4RkpuaERJUG1CZmZhQkZic3hvWlVs?=
 =?utf-8?B?UjY2ZzZ4UTkzRzQzOUFTWlEvNWNpREF0OXd5OWhGUWV0MXVMUEVId0ZkVEg1?=
 =?utf-8?B?UDkvL3dUd0xKVVFVSHJaTTFLVkIwd2kyR3lITTdYMmN6T0I1NENLZFRUOFBD?=
 =?utf-8?B?K0VYeFA0VUptR1RkR1EzWkY2N3pDL2d0UmtEaVYwdjBKeUlvdFVyNFFJNHFt?=
 =?utf-8?B?eUdUSGNlckVOcUFjTFQ5bXU0T2ZpMk1pMk5KVExqeGg3RmFEbG1ab2NESkN2?=
 =?utf-8?B?Q1VadlB6OHRyTVZQc3o0Nmk3UWxQN203MG1PQUtJaUlDRVExb3ZhODVFekhL?=
 =?utf-8?B?emRNaXZveUJLbmhrc2d6RGtHSnZjSmJLY1RvcndFZWNRRXg5UlRTMDZqWkN4?=
 =?utf-8?B?RzNXQUgyVmhJSmM1cmYzbEgxbXQwdHh6YzZaRlkwSG1qenFGQmlMZUpIQ2Jv?=
 =?utf-8?B?cHQ2MlZ3MGNxRWJRN0NQc1Zjc1FhcW5xSTdKQlZWSFVsRVhZNU1kVXlUc2xt?=
 =?utf-8?B?Ui9ZMC9BeGljRy83bFh4U3JyRDNQQ1RmV3hTT3RsUHdtTVhZbHpIOGZvSFlB?=
 =?utf-8?B?SVNzcEZka0ZZN21KKzBrdnlmZnR6TFZTV0tCRVM4d3MxclhlSGFVV1VYN283?=
 =?utf-8?B?RXhKWFJEMW1nNGwvclRmNGF6ZThzbGxUNW1GMmU4RCtSTjY5Vy96NHQvRjdV?=
 =?utf-8?B?anhxbjk3Y05Rd3dvMW1YQm8zaDR0SVl1bjhaRldubVJ6N3B1UytWZTI0Y3hx?=
 =?utf-8?B?QzhpNEF4M0FJMyttcE1ZWVlzVzVXaWNYeUMyWmtkOXF0RjhMdmlVNUk0NC84?=
 =?utf-8?B?NDVTS0hYMk96QWZZTENIQmN5bWxFMVJZYnpISC9HV2ZWaGFqWVc4RnVLRDlR?=
 =?utf-8?B?dUN1RnhaNm5PeUp3VWNLcE5zSlY2MUw3VUY3a2hUR25yWml0ZHBYTHF2Y3E1?=
 =?utf-8?B?T2x2aXVQQTMrWFhwSGxoY1c5R1VNMEhWcUlFK3M4VVp0c3VYeG1xMkd3Yk5V?=
 =?utf-8?B?Y1NNcUFHOHl5VXdTQmk2dzVvTjFUYlNPTHV0a2toUkRJQXdTelZRZ3orSmdN?=
 =?utf-8?B?TUxtdjJ5UFkxdUI4cG83SVdkT0JTVkx4YU5kQ1ZDUjdVWHF3djhOY3ZkUUZD?=
 =?utf-8?B?YTdrOFl4Q0hycWdkaXl0T0JUNklQSGJoczVwem8rdjZuSndpQnZMV0lsdlh5?=
 =?utf-8?B?dUg3TGRFOU5lSHppdVJSdjZtOXFGTytyYXU0QnQwV0g0am42ZFRaWVpuY3p2?=
 =?utf-8?B?NU5oa3B5YnVvbWM2RUdrMGtmcUJlWnM1TVZDd2N0MDcrYkF6dy9teVVZUnMr?=
 =?utf-8?B?aFJvcXN1cGEwWTNJRzh0L09WTDJ3SThMWTFraWcyS1c5RzVvc1VWQUJOU2kv?=
 =?utf-8?B?T3J2TWVSaEthZ2g3RHpKRzBpWGZRTE9uNkNmb3ZDT1VNMEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFZybzJmaTR2dnNyV24xTmVDeWVGb3NDSHFEUGtzTk10eEt2d2lUNHJCZGpr?=
 =?utf-8?B?SVJTU0sxYnB1bG4wclJzS3ZPdmhDNlBudW43bXR1VUJ6a3ZMdHRsSHVoRTZZ?=
 =?utf-8?B?UVJWNy9wTjFLaU1kRThSVHZtZzRXM093RHBxYURrOEhraEVsaER0cXNqUDcv?=
 =?utf-8?B?cGVXWTJvbmpoT3JPblZMQW5tRUlWNkRYSGVvK2tucnRlN2RCdTRselA2dXJH?=
 =?utf-8?B?YURIcWhJN3hZaE9rek9kUTBlNW0rMzhPa2tQaS9tQSt4bXhEZWJEQ1BiVTV2?=
 =?utf-8?B?eGlGcVBEVSs1ZUMrN2ZMM1Q3MFhQRitVOTFycVo3SWJaQW5zZFZmaTgvT1Z1?=
 =?utf-8?B?WEJSM3lYZEpiNnRhdWVrZTY2L1lIcjl1MU5DSzgvTUVQTU9ydFpoUGV2bkdv?=
 =?utf-8?B?cWdXTDBkN1J3aHpiTzVTOU56VUNqV28xblZTd1hBZW5qb0lOSUgzVjA1OEFx?=
 =?utf-8?B?ZWhETGcxVmVONms1NXB3ZS9uSE5xeWZJQTY5NzlZSnFzZXhDMGhSaHpmTFlZ?=
 =?utf-8?B?dFdPWEo4ejhyaGp1VENvdU1NMFN0R1BYU09vN0hhbm8zWXY2VDRxU3ZFR1Ux?=
 =?utf-8?B?K09xWjJ3czdlMkZ2R28vL3ZCSDRmYkpEYkJFTENOeWZ6bXRkR3lVeDk3dmU5?=
 =?utf-8?B?TERXWmdkTXU5dFRDNUYxODZWSkFZbTJGNEpjT2hqd21TYVBEcTczOER4cVZw?=
 =?utf-8?B?MkczMTUxSEIySkRNc2JFTEhNbW9CY2JPclM0OC9RZ1NCSlVkbFBTenBxVlJW?=
 =?utf-8?B?TGErcW44S3FDVzZEelpMTWh1cU1ETUIxSkFDTXI3Q21QeEJWSUVjRW5FRU05?=
 =?utf-8?B?UmdyVU9wKzA3MlhwWmEzRUNMWjBZaHVMZWtYU1JOcmVid2MvZkg0blFWcHBt?=
 =?utf-8?B?YkJhUXZMSjlPUDkrRUhsUWNyaDRZTU4xTGV5d0ZTUXJMeDRrcmRMWjFDdlFM?=
 =?utf-8?B?Q3VrN2U1VGJQTFhSNU1kUkdmczErRzJFNHBtclRnc21YNVhxTHhoUjFWWS91?=
 =?utf-8?B?YnhmcHI5UjZTYkRyd2FlRW9UR1dvK3RwZUYzTXlvV1ptNkp4RXlWQ2R5aFpB?=
 =?utf-8?B?ZjhNY1czV0RSeURGVDFPcmVGdk9CRmd1TjgvcVdNbnhzeU81emNnOFlWN1NU?=
 =?utf-8?B?WjQrK2RsaVdaeUFySEs5MXArN3B3cEVtY09rcWt2QXYrT2ZiL0hwcnZZaHRm?=
 =?utf-8?B?T0t4UWdRQzJkRXk2ckREZkR3YzNUd2hOekJIUUJtdzNqd2JUK2ZqNXNkYThm?=
 =?utf-8?B?VjdPYnYzdDZrR2xRUWk1bTFzVkIybUpyc09uY2xkcklyc3Z4Nm9KTXZlczFw?=
 =?utf-8?B?bE1PbGwwYVBFU0dDeFAwZktJL0FFRDhMVE40cGR1ZUdmSXhrbDdvUGk3Wlk0?=
 =?utf-8?B?S0pyeURoL1V4eWd5eUJyS0wrTmxBWVpzd0FlN0FrSUQ0MGQxSnE2eVQ0WVJa?=
 =?utf-8?B?dWt4dk5ZQ0RpdHV0SlZKUzg5RFBDV01SbTVZTWRUaUhxVTg0VStqNGc3aVVZ?=
 =?utf-8?B?ci9CM0EyUXJkYm5DL1BTY09VWkYzUC9kNHRmdEpRRkJaaE5SWXB3K3d4OFVP?=
 =?utf-8?B?ZGVsZXYyS1IxZDZocCszTGtYeUNTdjNVMkM2UzM3a3poakprYVB4bVRFQWFZ?=
 =?utf-8?B?QmlEUGg4MG5FeHlseTVLUjI0Vk0xbC9PTXVMN3dqTEo2SDBoZ3NwSEVvaHpK?=
 =?utf-8?B?emR0QmtsNXliMXIxcWdhbWVEZVdIUDFQZndwaUZYUzhFNDRLbUZleVNBYWo0?=
 =?utf-8?B?ejYzbHQ0RFhPTHRqdGx6dnJ6SkpmUW5sYUthWEhiQXIycTNteERqVWpUOG9h?=
 =?utf-8?B?MDZCMVkyRkwzbE5aM3dQQ1RLMGxrZFkzTU5FL0wyU3l3L3BPWVMwUkNFWmtk?=
 =?utf-8?B?a1RZLzJza3YzVXZqZFRQN1hCMFBHVjE3MnhuT2hKeDRFaGhMOStudzJxNTZk?=
 =?utf-8?B?cHcyVTJyTU83dElEMVZxekZGYitHT1kwUnpxMElOb2pZSW5TTDR3ZU1oTURI?=
 =?utf-8?B?eU9jem90LzZRWGNqeTdjOFcxTE5mdGZDMTlseG5MRHNrZlU3Rm0xRkc0Y0Yz?=
 =?utf-8?B?cXlZa0pzRTlCODNvbnZBVE5oQUxuZmFxWDZVOWZKTnJZcnN3S1BJTE5MYTVB?=
 =?utf-8?B?dlloN3orSDdLeU80TWNqcmoyUFBLalJJUndwQXJoTUZmZ0gyM1lIM3Z5Ymti?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B7B92BAC921B44982D6D3ED2FCBCC57@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4a7a46-50bd-4897-dd28-08dcc26c6174
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2024 05:36:32.7033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XuhrYbj7G34QS58ZHIfSklfF8TOottEDimaO97c1AFo3hKwPXJLWv//dTszeAvOUNLVHZ1uFw5RJuek5n2iVIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7839
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.642600-8.000000
X-TMASE-MatchedRID: ge9e+QLSeazUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2ydRP56yRRA9zd7C7BtJobk4K0IMk2m3GWTF
	H84r4cDSmiby4uSsodvPH7C/OYQhzzX6zRB1Ydird+fuf9kcaptIv4RV84lHTqPm/sjj9KBgDBV
	jATuEiHOLzNWBegCW2PZex/kxUIHWNo+PRbWqfRMprJP8FBOIagF5KX4et2eCAB0J1c0ruVdy6Q
	r4IZb3D98E0xJtrfHkDJxQLiCjYpA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.642600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	FCFF7C0F6DB6C3063F1CDC13E44E5C7A334C021AA1B94608FCD40D98D97B73022000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDExOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgQWNjZXNzaW5nIGEgaG9zdCBjb250cm9sbGVyIHJlZ2lzdGVyIGFm
dGVyIHRoZSBob3N0IGNvbnRyb2xsZXIgaGFzDQo+IGVudGVyZWQgdGhlIGhpYmVybmF0aW9uIHN0
YXRlIG1heSBjYXVzZSB0aGUgaG9zdCBjb250cm9sbGVyIHRvIGV4aXQNCj4gdGhlDQo+IGhpYmVy
bmF0aW9uIHN0YXRlLiBIZW5jZSByZXdvcmsgdGhlIGhpYmVybmF0aW9uIGVudHJ5IGNvZGUgc3Vj
aCB0aGF0DQo+IGl0DQo+IGRvZXMgbm90IG1vZGlmeSB0aGUgaW50ZXJydXB0IGVuYWJsZWQgc3Rh
dHVzLiBUaGlzIHBhdGNoIHJlbGllcyBvbg0KPiB0aGUNCj4gZm9sbG93aW5nOg0KPiAqIElmIGFu
IFVJQyBjb21tYW5kIGlzIHN1Ym1pdHRlZCB0aGF0IHNob3VsZCBiZSBjb21wbGV0ZWQgYnkgdGhl
IFVJQw0KPiAgIGNvbW1hbmQgY29tcGxldGlvbiBpbnRlcnJ1cHQsIGhiYS0+dWljX2FzeW5jX2Rv
bmUgPT0gTlVMTC4NCj4gKiBJZiBhbiBVSUMgY29tbWFuZCBpcyBzdWJtaXR0ZWQgdGhhdCBzaG91
bGQgYmUgY29tcGxldGVkIGJ5IHRoZQ0KPiBwb3dlcg0KPiAgIG1vZGUgY2hhbmdlIGludGVycnVw
dCBvciBieSBhIGhpYmVybmF0aW9uIHN0YXRlIGNoYW5nZSBpbnRlcnJ1cHQsDQo+ICAgaGJhLT51
aWNfYXN5bmNfZG9uZSAhPSBOVUxMLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNz
Y2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IA0KDQpIaSBCYXJ0LA0KDQpJZiBsaW5rIGVudGVy
IGhpYmVybmF0ZSwgY2hhbmdlIHBvd2VyIG1vZGUgc2hvdWxkIHdha2V1cCBsaW5rIA0KdG8gYWN0
aXZlIGJlZm9yZSBwb3dlciBtb2RlIGNoYW5nZS4NClNvLCBldmVuIG1hbnVhbCBoaWJlcm5hdGUg
ZXhpdCBieSBjbG9jayB1bmdhdGluZyBvciBhdXRvIA0KaGliZXJhbnRlIGV4aXQgYnkgaGFyZHdh
cmUsIHdyaXRlIGhjaSBpbnRlcnJ1cHQgcmVnaXN0ZXIgZXhpdCANCmhpYmVyYW50ZSBzaG91bGQg
bm90IGEgcHJvYmxlbT8NCg0KVGhhbmtzLg0KUGV0ZXINCg==
