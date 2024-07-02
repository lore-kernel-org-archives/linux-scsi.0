Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775A960BBE
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901586; cv=fail; b=RSute/auvedBod8bfI669TFx9QdNE5cjpMjGCPEoChtDUb89+cPGOeb9+Kxp8jWS20WsefT6sdB8WV6DJhFTUdfNLKGrta+vnjvjF8KFgpqidPN+AxMNONqcRoCjhcMU1jJYeUBo5u3I+ImyLpOnuV4Er5OR/eod+4I5fOfuu8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901586; c=relaxed/simple;
	bh=ZYd00ceMuSrhUtK1P1k3Dshkf5Le9Wyp7maSABQ6cyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LfLb+mttODqUUi896UOw+QWG84uDXIxmtcWR6minE29tws0yFRC1/ItwG8W68Z3uil8V7ShZ444VauJSZAMxh+bsVykpBewJY73Dhmez1gLWgma1cpR9bb2Ia9xhg0rj/r08RbN2Yr+qYXXctiUSgRDajzi2Yl4O8GG235HfCL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MXxYF1O6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=DuLNZOhy; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MXxYF1O6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="DuLNZOhy"
X-UUID: fe47297c383b11ef99dc3f8fac2c3230-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZYd00ceMuSrhUtK1P1k3Dshkf5Le9Wyp7maSABQ6cyI=;
	b=MXxYF1O65uKMcbGpO0bs6QWeqmtHA0RLOaGgje56DqQ/is2Rhc5mavF+fWP76VvoNIFKogB0CYko7swLOX05cztz4qf0tfLdhL2GeiJkbEGKMM8Qut2+dMKGWdJDxFgyuxmt1GsZt58qaJ5KxrHAjFrqNwj1CUOJSP1ZZSCKaGQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:273ad609-1e65-4052-9465-783f64dd0caa,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:1844f60c-46b0-425a-97d3-4623fe284021,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: fe47297c383b11ef99dc3f8fac2c3230-20240702
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1964957329; Tue, 02 Jul 2024 14:26:19 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 1 Jul 2024 23:26:18 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:26:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ai9SzDTNJp02DnSiYndU41N0B1LUSkagvdBtxvYmi8rt+TjzvhSp9Rzm7EoW2ooGUO55FIWXIugTaxJ5nPnIPgbL3g5+jHk16j1GQNORSOgTH7e+RJxaa72KsSjq2ZKDEcc+510paY9R+0vMFIc3no338lo+U7luLApfe0o89LtkQHeolpPfah9g8K0rO93XvV7xT2Hb9ozhrNiGPMgJ/xtUk94BsMxnSFZ33A5BmOZzTEBtauOWmhH3i6mIylLIKpaMy5w6eQPo7QAAcOPfUfNNJxl9FLr7VAE2/lr7BzQX74Gu1K5AC3YAKx2vc9tJx8Bial3fPSOgxRpIpWNY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYd00ceMuSrhUtK1P1k3Dshkf5Le9Wyp7maSABQ6cyI=;
 b=L20o+VvdKVE/7DHNsciMFAT1TMKF8HlgtrepeOYc3dEb8xwMb6ksvXxEpGvJaG2K2Jr1030xu3oL1/XxvQ6EiYCATjeoqZrRhzXbsVR9kNJivk3L3+/aG0EIfEsw99+JZmDiB0TobUeMrVj+m44WP1SCF1d0zsCO5n5ON32KpRvj8rF9+9jCMf/2nxK8qNWdmEa0YaQiAaRQUZ48IynuMUKZMk4Z/+9HbiykwV2dULbQgRT/8UcW+W/kcyIZY0y9XKOjjGwOu6RJcAqIr9n1Q9ZFEpqEbAhxjll33cMJT+mB/pC9JfVhokIVj0uOlq0d9vENi7tF2/j4Fap3sgqpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYd00ceMuSrhUtK1P1k3Dshkf5Le9Wyp7maSABQ6cyI=;
 b=DuLNZOhySBJ2gm8aW+2wjODwpDBPUgAV8DEezw8g5w0NFNDgTQ2ps1y7I/a35rKMgBy2+r0Col9f4+rlPOsUkHtKnSIkPwX2yfKtOcd9NUVU5y5LhvA4kfSAiInnZngYtS/vo7ik5Sg3ixf7FvU5UqeHDsH+6K+0zqej/26JgmM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7708.apcprd03.prod.outlook.com (2603:1096:400:432::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Tue, 2 Jul
 2024 06:26:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:26:15 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH v3 6/7] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Thread-Topic: [PATCH v3 6/7] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Thread-Index: AQHay+FBIi/vzFpK7k2KalhUDiJUjrHi+bcA
Date: Tue, 2 Jul 2024 06:26:15 +0000
Message-ID: <d18d0232dfe9a9694f73e28eaa481bc50deb16b8.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-7-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-7-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7708:EE_
x-ms-office365-filtering-correlation-id: 2e7b3297-9824-45e5-5c25-08dc9a5fe053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0JkMDNUOTBycEZTamFjczlLVEpNYUNTUGZFWllaZkt5dGJ2aXg1a2dPMnMz?=
 =?utf-8?B?bEl1dnZhaGZaQWVUVmxkd1FYdGhqWjFWcHllSnRnNU9SeFp5UjBwSCthY0pu?=
 =?utf-8?B?cHdIazdVTjVudFdXNFYwSVNsMHVRVzdnUXFhVzJLcGZPM1hxVmRXQStkN2Fv?=
 =?utf-8?B?YWFRbEZ5ZHBGMFpoVVNDQUN3ZmlQUzFDakNwZTVIK3ZzOHV2eVUwVVg5MzRM?=
 =?utf-8?B?MDB6YlBwUUFWbCtiTXJBdW5EbUxBN1hnclBGMElJbnk2NDJFNFF3KzNFK1BW?=
 =?utf-8?B?WDgwRkNWcGV2KzhuRXpsNW5PajhmbWZYQkhrOEo0WlVEamZPRlVTMHRJZXdM?=
 =?utf-8?B?dzZvWUw4STRReUdOcWlRQVhCMFVwQko3TEdwY2pRLzlqZ0ptbk9MOEwxc1RO?=
 =?utf-8?B?a1FrZlQ4TmMvazVQVHZ5dDhLVytRc2JmK25zenRVNVkwalo5ZXpmcDNMV0hN?=
 =?utf-8?B?WGM5RmVyNWM4K28zSVdsQzdnMzJmVW13S251VHNJVUk0TTNmNUhRRVVSSXVs?=
 =?utf-8?B?NzNvOVlBSWNrUXhGSzlGUElRWkVNWDh0dUNEQ0NIbzlkY1dzVmgrWG1YbitK?=
 =?utf-8?B?bzZGRUZMcXVNZjA2Z3UwdmVBQ0Z6WW5nQ1NzOWNpNSt4VWI4YldnMm0zQ2tk?=
 =?utf-8?B?UkczUTIzT3BLQTNTS1VyWlNpRFZlNmZkRER6N1dweHYrZFovb3lrc3B3UWlR?=
 =?utf-8?B?c0ovdFdlMk5UMlhhM0c2ZGwzamZLV3RBZS9LbHlOY3JDeW9LNnMvcmtVdlAr?=
 =?utf-8?B?RHEvN2RxWURUWFc2RzdyL1ZIV3ZwRjNjV0hJWkFUeE1KQlFqSG5jKzhKRW8x?=
 =?utf-8?B?UjZlWm1IUitmaE90ZmZKSG9yTVMwU0R2Y0dGNTczSWlvUnJJaktNNGI3dlhV?=
 =?utf-8?B?djB0b0lEWFc1VGlkb3g2VXpJemhPbHVsTUxSK3A5MEUrMFBseXlNVm5SSmxR?=
 =?utf-8?B?Q3g0a2hOY1JWczJ5em81aGszL3NYYjRPV25UNGtJeU4rWnRLR2xFOXptNTlJ?=
 =?utf-8?B?RUMwcXd4SXdiY0pCNmY5UlIzaWp4ckZmQVlGRzhnRVdUd0xiaEZMTTE2VWta?=
 =?utf-8?B?NDUzNHUyUUNJVUJlT0JxTzRCa1g2NW9nS3ZvdlFBNmZaTC9wMCtLNVR6OGNz?=
 =?utf-8?B?emNyK3JWNmhjbzZHMktiZEVFLzdGWjRPQlF6dTFIOGFrRG4rMVY0Yy8remhv?=
 =?utf-8?B?YjBZd3loNFVvYnYwS3VQT1BmL1I5WWpueW4vRzBya3B5STNadS9oaE1xL0h3?=
 =?utf-8?B?eWlMRHBsL1R0UVdGV3Q2QTcvRlZnUVBPZ0tMTVVjVFFienF0TmFlcW1vOUNY?=
 =?utf-8?B?bmJ1V0lLcGxaTmt5TzFrRmdIRWY0TFYrdWJoNThHNjRua2ZpZHpKY1hRTE9G?=
 =?utf-8?B?eklZUmxGSzI2NmMzTEc0c3d1bUVIeGF3bHZxMGtndEtybjZsMDVSN2NFWURh?=
 =?utf-8?B?clc3ZFhxa1Voa2tkMUlvbmQ3MlhZOXkxdEhYL3RZU2NxN05wM1gxSWhvc29C?=
 =?utf-8?B?OWs5ZTNYb2J6dW12R1FNMUFLZVFzdmFtTk94Z2R3ckthdHRqc0NGZnFrc0FG?=
 =?utf-8?B?VW55UERCcmpsSHdtOFlhc3BiV3FhNWF0dUFmOFZzNzFxS2NCOXpsTEFLY3RT?=
 =?utf-8?B?QUhXWlZYbVExUCtSL241U09YeGRzKzNWazhLaU5OSFVwRzNXNXMxVjczYzk2?=
 =?utf-8?B?Nysyd3oxZkxzVHQyNDV0UVVBeDFNTjVsS0htRTBSeFlDSENzSHVzbnVFL090?=
 =?utf-8?B?cWdTcVBQVCtESklaUFBWSGVpS2pUSXVuZTR2bVZSakpiNklLdktQdktnR21F?=
 =?utf-8?B?WkFVZGpLek45QlVOYkhGbExGZFlONmxuWHZNdkUyOVhhWktEWGlxUjJzZGZ5?=
 =?utf-8?B?Z2ZBalRpWFhPOXdnVnNVMnVhaDZadXkxNGxSK2JLcWhWUUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE5RZXZwRUlpTE5tblA1L0RjTStVdUhuSjRiYWd2bSt1dnpoNnUwS3FQYkp5?=
 =?utf-8?B?aytJK1hlWU1GS3JBTFN0N0JBd2h0dzZUbkxmc05VK3lFczhaZHUrajIzMEp1?=
 =?utf-8?B?b2FtWGhmZWM4aVlGdTIxbTZnMytqV1ZlcVJ5SDFwQXNsZks1dUNWdUQvTWpy?=
 =?utf-8?B?cmljZjJQWUE4cUVRYzN4WmJiL2RiVlF4MFN4bmNjNW9iZ2I3NVRBdVI5SDV2?=
 =?utf-8?B?VjFQMlhCU2JldXBuNXdWVnlFYjQxVzY5Nzl5RFNFUkptVmRCNVU2ckVybERx?=
 =?utf-8?B?NVlaak5xTjZvR01nZEgrMDVvWS9oVmxkam94WDJWcFRmWGU1d3FETnR2YVBy?=
 =?utf-8?B?eWE4SU5Pd1ZQSEd3aGZRaUVqN05odmFvdzlvOHlHVVVVZkYybFZKZ3VIaWd3?=
 =?utf-8?B?RXRmVkhUc3pMQ00wK1FBT3pNS24rYXJQODh3aWxPNDF5Rm1UcXA2S2VMZEZ0?=
 =?utf-8?B?KzJQS2JVRTFLT2ZiOER6L21EYzdtUjluRmNDTWd5ZjVTb2RjVldwWGVsdGI1?=
 =?utf-8?B?NnRHTHBJaFNoSFovREFBditmb3ZUNkx0S3Y5SHVBQ2VFVmJhVWNpWDVTMCto?=
 =?utf-8?B?Y2xQQ3Z4Q2xLdzY3a1FDcFVrcW5yd2FaSk9sTGdNTUdjamZZUm9wWnFuYmp3?=
 =?utf-8?B?cG5zZnVaRTQ1ZE1adnM0TmlNZlFQZi81MjZVMi81alRFT2N5eUZ1bGxNRUQ0?=
 =?utf-8?B?YndSWmlGVFNJMmx6U1lJUDdObkt3L2hNTmx5bnFTNVBOS2t1bFd0cXZmb0cw?=
 =?utf-8?B?aUFsSWh0a2pYSFJ0M0JDNzdGcGdHb2dsbktKb3p2dk9lSHRXWXlGQURqSVB2?=
 =?utf-8?B?R3pFYzg4YWw4Q1YwUmxhZnI1Z3VPb3hPRTZYTlFyWjREVENGa1Zmd2RrbVVr?=
 =?utf-8?B?QURvUWJwdjltYmJmTkZPRUVyREtvdllJa2Nic2MyVll1NEJyWlJhN3FNbnlW?=
 =?utf-8?B?LytrNzY2Wi9ocTRmUjlVQStjNHBxa1FZM2E4bU85d1NkQ1VDYzh4ektqeGFH?=
 =?utf-8?B?c05oRmgwYnhJbnQrRFk0M09BOFpLQkxTL1Rvd0pHYzB0eXQzRy8xVXBmR3dX?=
 =?utf-8?B?WlY2d1pTWGNid3N2WjBUNEtqMGZRakM3dzI2dmFSQ1MzNHhDaVBvYkplV1g4?=
 =?utf-8?B?SXdCa0QyWHU4QnRhdE9UeXdvSnh4Ti9mWW1jek1Ic3dNLy9lZ2ttSkNIdm81?=
 =?utf-8?B?SHB6TUZMWHR6aWROaGtIcVpxT01rWWVPQ05aRW8vZEtZM2lQb0d4UUJ5K3B0?=
 =?utf-8?B?aHF6dVNuQmRtZ3BNR1pxQWhCdUdIeW5oRGdwcXdPcXIrQ1lCMjBUV3NqL3dC?=
 =?utf-8?B?VCtJRjRFNlFpQm03UVNQOGM3YjNSd1F2bGpCZWd2NDZtZjhoQ1NjdnNHOTVI?=
 =?utf-8?B?ZFNtYVhUZkJQeEVaWXFHWmZBcVU0LzdLMll2ZUEyUjU2clgzdjVFNWdNLyts?=
 =?utf-8?B?RzRKOXhDdFRyVERBWEdWRXdYdjhBdkJ4TmRZdmVYOFVkeTNVcXA4aVp0NWFR?=
 =?utf-8?B?OXJ1OEFDblBGZ2xLWmdJZXdIenhKSVhwcU9EZE5JTlNwNXVMZjVqMmR2OEJE?=
 =?utf-8?B?dnVVdkpublJtYXN1N3VMQ2tyOFQ4aUwzdWNoc1hOZHhtRk8zSlNpa0ZFSDgr?=
 =?utf-8?B?RnhnRFkzTHBWY1pPbys5eUJaT2xGNlRlN0J4Wks4K2lXLzFhckp6SUIyTVFu?=
 =?utf-8?B?V3BuaGEwU0V6VGZOZDBoRTN0bU5seEY0R0hkaCtGKzQvOTNPNithOWFTcXIz?=
 =?utf-8?B?ZzltVnpJQ1dJK1l4K25QYW1CNkwvS1NxTTRCTzBPcmI3TVlwbnF6bnZLK0Rw?=
 =?utf-8?B?QWZRbEI2QkVXUVp0RjRLUWtzbjhlWEszMGFLa04ybHFySXlXbmdnekEvV2Fk?=
 =?utf-8?B?OURHVVUxQ01NSzdkMy9QSVVpWTEzWTJsbGFSRWRuZjJqYkVRTm83MzJrTVEv?=
 =?utf-8?B?c0RRYS9EQjd1dVNROUltY2lvbnRnVUM4a1JvRWVuWHdkcUhNRHFhQjVqYk9s?=
 =?utf-8?B?NUVCMGx3QXIySHN3OTV2ZTNtZGZwVXhKaWMvdzYyWWx5dkFQUG9CUXZxOHBn?=
 =?utf-8?B?TFNTTTNzNWJpNWJaTWQ2WFhOQjVaSkNiWmVwYXlEemhyNWQrellvYTcySFFE?=
 =?utf-8?B?d2VVeVBIMTVwTlJML1VBUlJyWDR1TXJpeG5lZGc3U0MzOS9uUjFNNmZFazFp?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF157DFD469C944E8161FAAB6956F8D8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7b3297-9824-45e5-5c25-08dc9a5fe053
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:26:15.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+iK9K+fSo7MYc2jT/u8dSBR60O1PyAQQWSfInYbiQKgP526Rv/TOMhbc2CDiP92TJjEBa88NXG5tloihL5CJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7708
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTWFrZSB1ZnNoY2RfbWNxX2RlY2lkZV9xdWV1ZV9kZXB0aCgpIGVh
c2llciB0byByZWFkIGJ5IGlubGluaW5nDQo+IHVmc2hjZF9tY3Ffdm9wc19nZXRfaGJhX21hYygp
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5v
cmc+DQo+IC0tLQ0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KDQo=
