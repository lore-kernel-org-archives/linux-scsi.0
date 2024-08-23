Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04891AACC
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724381697; cv=fail; b=GeqeaV8bcaq7L8HZXlAu53ol7WZgYBFqcMLq8ITWewKND4khPdBwIvI0/sZh82YcCr3ENUnd80WtkidUPBxvOESZ4i2fGe63oztIRun/awlI5qCfIgwiGrTPqur5f8kZJsLW1DDtBGYp6NKmibsIDdJZu8s1ltTRsg46FBS0zc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724381697; c=relaxed/simple;
	bh=TgMi/H6aHK1sqo5cGeF0z8BJzlibvb4UgyoU51JyqR0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k71Jr5aNgTGv6rTcbC0ed0+2j0HqgHpiE7VEHw72DmXGzzftgWeKmpH8nThAqnCWWEDzaP/B4fmdurSYKqcGWDzNAMpScAjhxOYw92qb9dqoen9v/FcuYo+zietdq22Rli03xvY0ZK4eh115hGdTcusaDN4nCK/t42boVW+IKOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=tAUMwyku; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Usf87Noq; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tAUMwyku";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Usf87Noq"
X-UUID: 0ea944c060fb11ef8b96093e013ec31c-20240823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TgMi/H6aHK1sqo5cGeF0z8BJzlibvb4UgyoU51JyqR0=;
	b=tAUMwykufkn9fhDHcoqTF448mvZ0KZy8UxwnRYBAVJVkYaS3JgilrLr0k4U97Cs5TrN1j0RDLsP2IiSbACZqy1QZEhuPfNUvB417T6BDex4vG8djBgH8oxwcHE5BO/pSAEVnzqpLKmhJ1UOnTDCFSryDZnE20T9qY0IpASYSflQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:f12319c7-b36b-4553-ba5e-908f1b038c2c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:877da914-737d-40b3-9394-11d4ad6e91a1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 0ea944c060fb11ef8b96093e013ec31c-20240823
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1255032970; Fri, 23 Aug 2024 10:54:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 23 Aug 2024 10:54:47 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 23 Aug 2024 10:54:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8Ek1wHT+D6HaUAIy3Qierc91lX6n9FJra4q+IrWm1oV6ebrJ3zRu8Um/xYUlfAlD4mI08pehmZKrwHeIIksIl0ZciuAnz6eckJTerqehp/fHZrCbaS4UCRCZdvYC125ekhFE+SH9WdHF6aDKMMbWNm1uv92vE/3/HAJk93NgIkeKXIp4E8x4ARGs5oaL/cg3G497AKGrRznoBZNz4wYqj/wTNoUvO4Q8vUot1Q62cO6ph6xMr+QO1c8Asxa3/bTrbRnzRAo/4h5r9gfwjYVjSWf4HNl8tqeWTF6HCjnwjNVciu3G4bJQ5VlTAxZh7IoUBBDywk9XGjZV/CAN3wazA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgMi/H6aHK1sqo5cGeF0z8BJzlibvb4UgyoU51JyqR0=;
 b=ZcitiMU27dzJJC1wu7yRUptsVbnrE6vtEhvVDCu77req07KB6n7SalcpR2SCzCMdrWJi/puothl6eCYymN3rkAIW6KBlkiaIeq7cXXEndi4Ohd2C9iQ6hksjxZM5EsRKtSoo2DDWczDjRz9xpEhYDOupzv2uqZ2uvOhGahGTTJ/2Inw6ojsAF583MS7b+IPnd+l7vrrDOR05NC2JWho00W4jW3hrnvKXF27B+pu/VFARiZGsK+hg+n5RK7PmcHvp4b2NlrDOAGKhUiaLItWgn7XJrHawsSMglRgGTKTd8wqEynVpLqOBxQqFlW9wNwnhrPtKc5fgi3TWN+J5iq40RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgMi/H6aHK1sqo5cGeF0z8BJzlibvb4UgyoU51JyqR0=;
 b=Usf87NoqPoEcleKgaN8Z06rxlaHcGlVVbP8ACQP791xTBZhIvanw11B7NK6DLkNFfDlButLz6msNStY+g1E96bGjYmnamIBpNc3pzlmRImkOUaw7Et3Z2T1XTa2nf0VqDRNRKmpnJ6SOIut19r1Mrx9DvMKjh1VWM7AFyg2pLbE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8081.apcprd03.prod.outlook.com (2603:1096:400:470::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 02:54:45 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 02:54:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
Thread-Index: AQHa8/ghGzQNc4Nbn0yIAFU0+PnDB7IywgwAgADARoCAAKVaAA==
Date: Fri, 23 Aug 2024 02:54:45 +0000
Message-ID: <7f2e5babd9807a056ef5967296b19263fd10677d.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-2-bvanassche@acm.org>
	 <50e21f3e873c19da78b108b0352a8aa6cf95907e.camel@mediatek.com>
	 <3dd5c574-97ce-46cb-a925-9074973e8afb@acm.org>
In-Reply-To: <3dd5c574-97ce-46cb-a925-9074973e8afb@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8081:EE_
x-ms-office365-filtering-correlation-id: 8097fb92-ee83-4940-8285-08dcc31ef1b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q0YrZm0xNTI1TGVlZ2dCd0ltdkp1WFZTOVZrMVpaV2xSMENCUDZZUmNwbzhS?=
 =?utf-8?B?M2ZlamhCdHZzZGpmMkFTTmNFT2lzUXoycGJqbDdZSXRYRXNqY041Mi9PZ1lE?=
 =?utf-8?B?cE1RcnU4OTA3cy9wTkpBSndIaXg5SUF2OEFCNlFaYy9OZDkyU2d6SHlCOXBR?=
 =?utf-8?B?SWdPM3FtTjk2Tk5lZjVNNnJOTTV3bFhLUXhhZkFSeS9hMzV4MWRPRzJKSkJX?=
 =?utf-8?B?dWJXOXFsN0Y0dEZLRStoTjVwMTYyM3poTGE2dWV0eTBuVHNMQjIwdTlUQVVK?=
 =?utf-8?B?OU1LSlNZSURpZ1NSWGNFZ1hvYXU4RmpiSFRqRFFETnFhZGFhUUVpSzFVTW13?=
 =?utf-8?B?RCt6NTQxQmtlS2x3YklncFY1NDdYOHlOeExVOVVTam5KMTMwcTI1WlE0SmJJ?=
 =?utf-8?B?Z04rQXh2cXFaWWdTQVRnQ2JrN1BDajRrMHVmTWNwLzc3REJHdnNZenh4bFBN?=
 =?utf-8?B?QU0vLzU4ZjA1ekQrYk9HOHo5T3ZsTHJOMHhHajBpQ2I5Z3NuSGk2Y2NNbUlQ?=
 =?utf-8?B?aHRXODBlTDNPeWtZellBQ3RpcUtJcmY0THpZUzN1ZnVFZjlnNmZIN1BEbDlI?=
 =?utf-8?B?c0NFUWE3UjUrUTdWVE5Ld2kvZVFnVTZqRzAxVUtaRXFWU1FUZjFjdlA2alVk?=
 =?utf-8?B?MUhPWGN6bXQyMTcyVWw1c0ppbDVxenVsR1IveG5kdWJTSDFPQUM5V1lJT1dD?=
 =?utf-8?B?OWFrOHRBSFArT1FJSzFkbjVUZ3ZyWUhubXFleHArQmhMaU5FTDU2QnV6dGdJ?=
 =?utf-8?B?VmRFVVRyRitSQm1Na2hMSmE0NnhET291OE5Ub2lhaU83UDVHUldhdHhGL0pT?=
 =?utf-8?B?c1Y3Umt3TVo3US9hblVzVWFKQ2p1OW45aDE2ZllpZk9CMkVRTkllTHRMb01Q?=
 =?utf-8?B?U1BFWUJuVUljOFNNbFpUYy9nRDA5Rk1FdmZ6bm5kTHBxRjlycUdKaW1Kb0Ry?=
 =?utf-8?B?MjdRT2V5eko4OHFEMUNqMVFTYmNVZExsODgraFJCTUtvTk5OSU9nNGxNeVBx?=
 =?utf-8?B?alB0WlhtY0FRbTdYTjkrL1VTczNFN1ByUFRJSnpKYVpCZTlQZ29VVENMcGJU?=
 =?utf-8?B?YjF3M1ByT2NQbUhCR0ZVU0VsdXN6bjkyRU5LSHNLMG11VHFLWW16dGExbm93?=
 =?utf-8?B?UU5HL3hlZ2RyVFVneDlXMk83YVJrcnN1UzRVUi9taEs1aDhVaHFFYytSUDB4?=
 =?utf-8?B?WVZTMDBFWXM1S25ucHkzU3F3SDJDZDNncTJHdTRvcWNFU2h4MXVWMlRlWHNm?=
 =?utf-8?B?dXVsNFIycFNQenpYV09MU0R0UVJ5N3kxdGZaQzd0RXZqOVg4SDVPNjFDYkNR?=
 =?utf-8?B?ajFCU2pmcGlLZXljaFZVUWhSTkZrYTA2NVROcy9uU1R6T0EvWGZ3b2NKdkNC?=
 =?utf-8?B?UGZPWmtzZStQdlJZQkk0VWRtUW9XdGwrRXpqVGhRQjFycnFMZE9FTUZRU0Nr?=
 =?utf-8?B?bXQ4QU1BY0xQd3pCbEFTWE42T25lUUM5cXlva3U3dVZhSlp0aXkyM1pRQmUw?=
 =?utf-8?B?dys1MjkzV1crNDFnbkhlSDJqRUNsbmtYZCtRYUg3cm1QZ29nN2dBUit4SmM5?=
 =?utf-8?B?OG82WU5DY0k3UkpuZ3phcHRXekZsUjgwV0x5NXNKeTFIUUMxZm8xb2dRTlVq?=
 =?utf-8?B?NWNibE5ENmVyRFlGU0ZTcE4xN0hmNG5OdWVyUXExTFA5ZURFVnpJTzVmOU5Q?=
 =?utf-8?B?eGNrVG5vTTZjNTNsa3ZXTUFON0RkMnUvdERtMGFsZVlXR0JrdVI1RFcyZ0Zv?=
 =?utf-8?B?T1p3WEYyeUFKYXZrOG1kSzVncUYzY3EyUDZNTnFSYnkyZG5yNURPNStLRE1i?=
 =?utf-8?B?NG14N01hdFJhaFhmTVZlMlBxVk5LM0FZbXJWTU5haXAxYlQ2UkphcW8vaWdj?=
 =?utf-8?B?VVdIRHBQdWNFN0RTQjdzMjlRV24rUlQzU2tNZWptWSs3TVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEJhM290V3RFR0JYZy9yN1NiRXVZQnprWXJUOWppdHZTUkg0RkFybENYblBu?=
 =?utf-8?B?WHo1dGVIQTRPUmoyVDRYV3V2b0syNVZMQXJtS2Q4VU02ekxFYWJRSU9acjR0?=
 =?utf-8?B?N24vVmJPdCtYSUtGa1U0TVZsR1ZEM0VTSHlpVlc1aXNNem9ic3BGd1cxMjhq?=
 =?utf-8?B?VlhjeUtWOWRWMUUxNWZKWGJCS1lJL05sR0NpWXZOb0tEL3piYm9WSXZnMnVq?=
 =?utf-8?B?bFhzeGZhL0QzL0UwZGs0b3pzRmZhQlhEMnVDMlQrYkVRR2RJTHN3Rlh6UTVX?=
 =?utf-8?B?bE9vR3NycU1RR3dBeXZ3OXlmZWNOZTNPM21OWk5Oa3dFcHY0NzM2U0FXUUMx?=
 =?utf-8?B?ZzF6Z3Y5TXphdVliL05GUGtJMEFublFhYW1janBsRnAyWmNWa1QzOUVjWS9i?=
 =?utf-8?B?bVVhRHQzWEp6T0hXWEN3Y3p4RWxGaElCeVY5djl3RnNZcjk0eFVWaDQ4cUtn?=
 =?utf-8?B?UkxzSHhzc1hTUkZ0ZkV0VGFXdVZZVDU5UGF3S1JUODQ4OXFxbU96Sm5vQS9q?=
 =?utf-8?B?UDhrandoK2xQTm1UNUVYUXZ4TUljZnhESXFIUzA5NytLeTNDSEpBYkg1cXVa?=
 =?utf-8?B?OWJJelZwckozcFBHU3dqbFRHellXM2hMczIrMm9MN1hhVVVWY1E1Z1ZxNG84?=
 =?utf-8?B?TGlFV21Fdm50MGhDbk4yY1E2d0xHam0zU2djMUFObUhXVUpDcUpHZkNaWGxO?=
 =?utf-8?B?d0JoR0I3QTVKSlh4SUJXWlVFRFFuRis4WENDalYreCtzRzA3UURBLzFIdnIz?=
 =?utf-8?B?L1E5ZXFWSTQ4alRlYTdieWVLakRPZDVLK0VaaTUvRDhSazdMVEhvZFpuSWdq?=
 =?utf-8?B?enZ6Zk1tVk55d3UwQXlLcnI1aGhQRG5lWHRkZSt3SFc3SzhzVnpLQS9QKzBY?=
 =?utf-8?B?bnJEVkltZk9HMmhzVDJOakM3L1ViY3llM3BRWGk3UnU1dWlWTTQySzBnZWIz?=
 =?utf-8?B?U21hRlVxdzVVNmQ1amk3NFZkUzZydnJ2YmNtZS9xMzJyUHBrT211ZENKQVhK?=
 =?utf-8?B?ZVo3NG9uaVhHbDc5eFJDWnl2ZHM0VWp0Mk5TWnFJejdrbzlTbFg2WEJ3SE9Q?=
 =?utf-8?B?ay9Ybkl4bHowL3JobVpVOG0zRVFrSXJyWC9FMHdVSk1hMGZPeFJ5ZUxNT2Fy?=
 =?utf-8?B?NXhyV0N3SHdOcFVsQzdWajVTZjM4YXNaUk8vNk5oZzNPVmg3b2o0YnJhN1I3?=
 =?utf-8?B?Si8xV3ZQMXAzb1ZVWksxZzRmZEloYWRzby8rYUxPKzVWTno5ZW1kcHYweW5i?=
 =?utf-8?B?TnYxcEJyd2UzWHRvYkVPMUxnNkdvWWhXa3VFaGlIYWl4KytBRVVpZk1DY3lr?=
 =?utf-8?B?dG8rdFhrdFpWZk1kS3pIOUVkc1hvSlljQm1vbGJTNVBYNmVlV2syUm5JU0pj?=
 =?utf-8?B?akVJa29qNjFHellIUzhIZ3dpd2YyTHljSStYbFBVY0lhZVNja0xNSlp5RWVs?=
 =?utf-8?B?TkFZWGVqMjY3YUdpZHNZTDN6NC9vUEl0YlJUVWtTa255alNQY0FpTnVQL3Ni?=
 =?utf-8?B?U1h6N0t5YTVPUkJXMVJwNjc0UHYrSDJkbU9udkVQV0ZZTFEzeFVjS2NBUUs0?=
 =?utf-8?B?R1hicFh3N2tNelM4ZDcycm1PVlJmeTV5dWU3T3ZxSk12elBJayswcjZKREoz?=
 =?utf-8?B?OGppMzdWRDFWeXBRUmMrMmNhVWYySm4zN01BMFpvTW1LcEphTWZxME5kalJG?=
 =?utf-8?B?eXNoM1JLakJzeitpejUzanpFYUxucU5XYkRTZEduWVNIVTJLWkVRZXNxUUxy?=
 =?utf-8?B?OUJoRWVnd1ZwSVU3MFY5OEgyRStkWXJaejZFYTdqQWlLbUZ6dVdlMzE2QUJh?=
 =?utf-8?B?alZENEk1MmdWb0tTY1c1cUF2UlNpVzgvdTBPNzIxK3dZejMzOVBuejFNSnVt?=
 =?utf-8?B?eGpZNUR5K1VQZm1rM2FVZDN6NFRqb1hzS2Z2K3RDdnBsd3BveS8zWTJkOVlC?=
 =?utf-8?B?UUpvV3crQlVCWlhSNUVFTVZDU3JxYUthMmV0RkNjREN5cnJ6Nkd6WHA3cDJO?=
 =?utf-8?B?ZVdBekpKd0MyM3k4RmpxYXczZ2ROT2NRVHowQ2dERVg1Z0NHamNrbXEvb3hz?=
 =?utf-8?B?U1I4ekFUTGFrUW13NGE4b0w3eENuclNIMnVNY0IyUFhYaGdocFAwNzE5ei9I?=
 =?utf-8?B?d3lqYnFKTlFValRCTFFxd1ZTUlRCYkFLNDRkQ0s0ek1nL0laaFlJb1R6TEFR?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14885D54797FCF4293D423F0BFC29427@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8097fb92-ee83-4940-8285-08dcc31ef1b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2024 02:54:45.1074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiWdhDwKyNdjQC2aJjp8Gb1UHpe83Zyx8GBggEgzy29SPfjoG7LUq7JQe3byBicvs85LBWEPFbcSirPY69Ci6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8081
X-MTK: N

T24gVGh1LCAyMDI0LTA4LTIyIGF0IDEwOjAyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yMS8yNCAxMDozNCBQTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiBGb3IgZXhhbXBsZSwgY29uc2lkZXIgdGhlIGZvbGxvd2luZyBjb21w
bGV4IGNvbmRpdGlvbmFsIGV4cHJlc3Npb246DQo+ID4gDQo+ID4gaWYgKGEgPT0gYiAmJiBjID4g
ZCB8fCBlIDwgZiAmJiBnICE9IGgpDQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IEFzIHlvdSBtYXkg
a25vdywgdGhlIGFib3ZlIGlzIG5vdCBhbGxvd2VkIGluIExpbnV4IGtlcm5lbCBjb2RlLiBJJ20N
Cj4gbm90IHN1cmUgdGhpcyBoYXMgYmVlbiB3cml0dGVuIGRvd24gYW55d2hlcmUgZm9ybWFsbHku
IFRoZSBDDQo+IGNvbXBpbGVycw0KPiBzdXBwb3J0ZWQgYnkgdGhlIExpbnV4IGtlcm5lbCBlbWl0
IGEgd2FybmluZyBhYm91dCBleHByZXNzaW9ucyBsaWtlDQo+IHRoZQ0KPiBhYm92ZSBhbmQgTGlu
dXgga2VybmVsIGNvZGUgc2hvdWxkIGJlIHdhcm5pbmctZnJlZS4NCj4gDQo+IEkgYWdyZWUgd2l0
aCB5b3UgdGhhdCBjb2RlIHJlYWRhYmlsaXR5IGlzIGltcG9ydGFudC4gSG93ZXZlciwgSSB0aGlu
aw0KPiB0aGF0IGl0J3MgaW1wb3J0YW50IGZvciBMaW51eCBrZXJuZWwgZGV2ZWxvcGVycyB0byBt
YWtlIHRoZW1zZWx2ZXMNCj4gZmFtaWxpYXIgd2l0aCBleHByZXNzaW9ucyBsaWtlIChhICYgYiAm
JiAuLi4pIHNpbmNlIHRoaXMgc3R5bGUgaXMNCj4gY29tbW9uDQo+IGluIHRoZSBMaW51eCBrZXJu
ZWwuIERvIHlvdSBhZ3JlZSB0aGF0IHRoZSBkYXRhIGJlbG93IHNob3dzIHRoYXQgbm90DQo+IHN1
cnJvdW5kaW5nIGJpbmFyeSBhbmQgZXhwcmVzc2lvbnMgd2l0aCBwYXJlbnRoZXNlcyBpcyBjb21t
b24gaW4NCj4gTGludXgNCj4ga2VybmVsIGNvZGU/DQo+IA0KPiAkIGdpdCBncmVwIC1uSEUgJ2lm
LiomJlteKCkmXSomW14mXXxpZi4qW14mXSZbXiYoKV0qJiYnIHwgd2MgLWwNCj4gICAgIDI1NDgN
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg0KSGkgQmFydCwNCg0KSSBhZ3JlZSB0aGF0
IGl0J3MgaW1wb3J0YW50IGZvciBMaW51eCBrZXJuZWwgZGV2ZWxvcGVycyB0byBtYWtlDQp0aGVt
c2VsdmVzIGZhbWlsaWFyIHdpdGggZXhwcmVzc2lvbnMgbGlrZSAoYSAmIGIgJiYgLi4uKQ0KSSBo
YXZlIG5vIGZ1cnRoZXIgY29tbWVudHMuDQoNClRoYW5rcw0KUGV0ZXINCg0KUmV2aWV3ZWQtYnk6
IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg0KDQo=
