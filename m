Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9098A165F17
	for <linux-scsi@vger.kernel.org>; Mon,  7 Oct 2024 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728285662; cv=fail; b=uTN0xn6bC6W4Y9WCFvOwRiJO+5+fLq1RQGpRHcdP3q7KPFPyE3e6wBKXuPBwzP+njv/Dhm+CRwUpJnVuddTkxbIufsnUoU8mk1K70REv3MWkZZdxqHIF6ldmd0bIXMx2rU7sWJivXil/Bsq79zXHNcKfpkfJZTZSCk1Ho5+a3yA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728285662; c=relaxed/simple;
	bh=MiIOvpI5qfz3ug9zi8PnlMENUhQwSHij940u78RpqXw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=om0UEgwQB9h59a8QXErIq395+DzLyglf5QOQTgcsIgDsjQC+LTz4yWSaENYOUIceTuG3NlZN5mbNjwFFGShF+zUav/Z9pjIMR/NUfWPAQPaDjE7YVConP4HZIqyLw1rh+/KPu39xdHzLZiy+tZHhF5dVh97qxb/sCw9nk6TDCew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nvEmmQEM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=S7ODBKD/; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nvEmmQEM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="S7ODBKD/"
X-UUID: afdea1ce847c11efb66947d174671e26-20241007
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MiIOvpI5qfz3ug9zi8PnlMENUhQwSHij940u78RpqXw=;
	b=nvEmmQEMwnKmfa396/sb/hOvlLK4pQupqL51Ban8y5QjvzrjTwrQOj4AKSXUStESwPYBjx/fARdonBNDO2+PBtFNr3/6fCwDWHK2L0lyEkEPKvLfre8Rm55XtIoOmtt8hleZqsAPWumMh/7XKuSwwr8dokW4s67ObT1nHy870nc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:1e5f80dc-e8f8-474c-9a42-e4a4f7d4df72,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:5e79da64-444a-4b47-a99a-591ade3b04b2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: afdea1ce847c11efb66947d174671e26-20241007
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1639366313; Mon, 07 Oct 2024 15:20:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 7 Oct 2024 15:20:51 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 7 Oct 2024 15:20:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tv+breZ9Bx2+j2B3A+vYz+9Ce0G0tUFblRltIGUi5Hrxmr3kL09bFTH8d5zTijB5qAMVHAI8CnA31VtNJnkRdZckS6OXH8E0XMlME3Hn2eB1U4NVilvwXD52whdyliOMKJQZ/+Ghs5J+tqvuIz2cyGen/mYn19+lWLPk+cap1isEW8x7TU/TubD4xrAGI7G5ZBCxadZbI04ic2PgmL77TuEOKwVItq6hPW1cKndPQVbc4P2MD2kqzLSuH31fYG5d0zV7Kg6IzRpl+pKZpwRlq9KnatE0aUV7OVxhA34zsPhjtNvd1SvSmVSSbqygqmZA4DcQfaATUrlcJ29fJX4Gmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiIOvpI5qfz3ug9zi8PnlMENUhQwSHij940u78RpqXw=;
 b=SxlIHD4pReznAufLhzoJQ4v+exCFr2GO8T+DKkTgUDzIcQyN/Iu61olr6QoNyW8urR+ZSnWZOmG+NDqCWH9dHiEJCei1cqHzWDc7GB1/U7X5vOdtmx+K1E4nGSKAvStJT4cvvFdXGwst803nrfdqU99bhfw9hLa/mszbHBDsjtmv1/sx/LqCmGxQDixwydWXgilljHgP5SqLefa+i99W+Hw8014GXWDkZehK9TE4GETXTzFLDNb4NXbTzdB+CFTfaLUALHc58/WEhsWb2jXtNrxOQImNTHOTngu+4/2NMMneE1h9d0tCzwLY/A2wqGo062HcffEIQoyrVgV9xXn0tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiIOvpI5qfz3ug9zi8PnlMENUhQwSHij940u78RpqXw=;
 b=S7ODBKD/ojAIoFDZshWFeJGJt7tRq5RL8ZA8TrX3tTaHyZVb2xDt20lcVRnbRN3sjVlv886AW04vg6q0BfRsMGW/6wGzxBiQh2dkZMYkOtz+gcJjm6iQii+xT8ugtXnvz39kl0cY3z2K43rGtpSDbWfXvhfoWo2sOaRqpd1lIm8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8180.apcprd03.prod.outlook.com (2603:1096:101:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Mon, 7 Oct
 2024 07:20:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8026.020; Mon, 7 Oct 2024
 07:20:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: wsd_upstream <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbE+Mn3m6Kz/z9nkigLrxdmIZYWrJyIqsAgAFGjwCAAg1bgIAFdH8A
Date: Mon, 7 Oct 2024 07:20:47 +0000
Message-ID: <8c463196860b71f26bddad0e7e8be6aacd470109.camel@mediatek.com>
References: <20241001091917.6917-1-peter.wang@mediatek.com>
	 <20241001091917.6917-3-peter.wang@mediatek.com>
	 <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
	 <69a77b95da27fa53104ee74ecae4e7da2d1547cf.camel@mediatek.com>
	 <e6e93ff1-cba1-45a9-b4b6-7dcbd7fca862@acm.org>
In-Reply-To: <e6e93ff1-cba1-45a9-b4b6-7dcbd7fca862@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8180:EE_
x-ms-office365-filtering-correlation-id: caf97162-feb7-4beb-d520-08dce6a090f0
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b2c1VWZlZ2Q4aWFkdmVpOE5FazJuUWlTU3h4TTcxNXdzWCtNd0ZLU1ladk1i?=
 =?utf-8?B?YkV3WThvSUZvenlZYW1HdGd5bUYxU0lXQjh2YmNMU2FGUTM4bGdUQzl0Z3RV?=
 =?utf-8?B?aVV5OHB2aU5mbXFtR3F1QzBPM0hOS0NsK3lUenB4ZElINUE5c2YzR1JaVVJl?=
 =?utf-8?B?Zm9QYVd1ZnlXMDJTeVNOZGNYOUZEMkNRZmVOaTdSYXhCUFBzTkFhaWlLNVlx?=
 =?utf-8?B?ZzE4d2o2RUJTbEU5emhFSDJIVGVnOExqRzlkTkdhYUhSMlJvcGVDTXpTNUdu?=
 =?utf-8?B?N3ZnU1hENjFBUno2MWxTS041WkF0VTIwSzNaUmZDYVU1ZXdCWFJWOEh6MU9L?=
 =?utf-8?B?bmxyWVdINkdYWlk3OHIzdmY3dEwreS9GUzdYWE01UkppTE52NkdMSGlxUmlx?=
 =?utf-8?B?RjdCVmJCYW9MbnFJTzVNek1RMzFWVnNJS1ZCNFBjalUrdWN2UEczNm5MNzVP?=
 =?utf-8?B?SUpJTkRpbkdEYzlBOC9xUzZUeWI3bmMwendHbVJsMjlNK3B3SURpbllpNUN2?=
 =?utf-8?B?MkhWSXdsQ1NQRUZMUE1ydW9YMWs4cnRTb0FlQVphRDFrdzQvdmRCaW0ydDFh?=
 =?utf-8?B?OVowSVpGdVFwTmxmdDV0TEorRUkyd1FHenJ1WkNIOExYNnlwWjNyVTF1NTcv?=
 =?utf-8?B?UURGY0pXbUlmcTA1dXA5SnlWZGhkYmZHMHRIRVlkR2hYWG50eGhYWVZRMFdv?=
 =?utf-8?B?RUc5a0lUanBGczJVL25EU0M3V2t3VDdXT2hiL3NLRytqTE5JMlJHK1crUnZ4?=
 =?utf-8?B?RlZBaE8yRnlYd2F4NUdCNStQamREcFplWlgyVnhuR0p0UmRyRTVCL05HbGlp?=
 =?utf-8?B?VS90MGg4b3dpNE16bFVZUDRpQmsvOXN2d1k2RmNtQ3hWYitKWWtDS1h5UExk?=
 =?utf-8?B?U0NFcHIrUkxlNmNqQ1o0S2dkZXkyYW5BUWR0bkJxbkR3NTZlRitVNk9PSVha?=
 =?utf-8?B?U3dBNmJJbVAydDJFU1VHMXVUTTJaMzNtWlI5d1FocUVPcjJsRnZoUjIzcXJ5?=
 =?utf-8?B?SFRwcXlrRkpnMmJKOHR0WXd1cHM4YzE1L1JEdFBPRmdyOFM1Y0NCWmU0V29R?=
 =?utf-8?B?WmNWNjRTOGEwa09aSlB2Skkwd0FHUkVNaHRvU29Jc0dYK2Y5dTcxV1QxcFZp?=
 =?utf-8?B?WnZpOE8wYXVkdDJmdkdJTFM3TXVudTd1WitjS21JTWxNeWdZQkpRbmhIM0tD?=
 =?utf-8?B?ajNRQmlPVXdYL294dFVCeWtodW5KT1BnOWVOQnhCNlYrRWZ3U3RHdVN4eTF5?=
 =?utf-8?B?RWZhRmJtSzB4Sk82cXNWejhOeERKUFY3M1BwLy9oVmZiT0VYTnhKRm12eHds?=
 =?utf-8?B?K1lEK3VkeUlyWERmcGFlN0VDZ0hzQWlEL1pISHN6aWRISHhTbjFoUGNtT2VZ?=
 =?utf-8?B?b0djVUxabkxBTVAyVEorMGNBdDdrTlZGYldCRUpxS081OHJCcjd1WSszMDhI?=
 =?utf-8?B?RFF5cjlRSGMwUFY4dWZKNEpRWFJCUXg5MjlkMTZqa2cyUFhqQ014ZHgzZFZx?=
 =?utf-8?B?dlY5T1ZkclRIWEpBKzVsdTVDaVJVRkJTOHVxRGVWOG9oSkh5VExPV3JnT1NF?=
 =?utf-8?B?YWtKMG9HRGNhMldXNTJQTnI3dG45akJIVTdORHFkZ04wQ3EwTUd5ajcyb3RX?=
 =?utf-8?B?cytMbFg2cmNzM2hOR1Z1ZVpBZmQrcUdZMVVLNWlIZWJzYUMyMDUwL1p2SDFm?=
 =?utf-8?B?akIwS0NJY3FPdzZHb3NYWWoyWkZIUnF4SHp4TTFTNTdIcDZaSzhMb1ljV2R1?=
 =?utf-8?B?bDZWSm8xMjhRQjl6dWFxQjBlLzhrdlh4bDdxRU1rdEVJdmhuSm9JM0RyUzhS?=
 =?utf-8?B?c2xValk3V01RKzR1SnVzUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkEramFnMC8ySmxEajEzQ2dTQ2xPbEpTUGhrM3UvVHJRaEtldThwWTB5dFRU?=
 =?utf-8?B?KzBUYVpLcFBKZ3dwRm1VRlNpZ1RoODRMT0tWbHhBTFo2cnVQS3BCV2RHaER5?=
 =?utf-8?B?R0ppaUl6Sk9QVUthZTBpQmhjdXlzR2txSVFGZk1TbFkxMmVMcUlXR2xSWXRQ?=
 =?utf-8?B?S1RvRGJtOUpzL2llZUVMQXRPL2xkbWl6bGVwd2QxZExvZFdNTUduZWQ3Z2t1?=
 =?utf-8?B?T1ZSYkdIaVVTTHpLZjBvOFFnb29DTi9UazEwMXRYTEFHMkNhYVgzelo2WEcx?=
 =?utf-8?B?bmlQM0RiWlhnSGpXNWs1eW9rNW12VjJXQytncmp5Y3RONGY3aFNWZWVvNWxS?=
 =?utf-8?B?Z0lFOTl2UDBRa1QxWWpWVDJKbmY0aG80YUVFeVlPdE92dkR2eExSeFhmN3V5?=
 =?utf-8?B?bEJOWENVcEU1T0IwR2VmZDNzTDJXQk5PRG1lYlFYUHBaajBpY01Pc0tJNkU2?=
 =?utf-8?B?M0hPdzFjc1lHMlp3NzVIS1lUUCsvcHdoL0F5QnM0TFoxT2VDQmFINTFlbFo0?=
 =?utf-8?B?WkRZRG5PeElpQ0lGaW4vUnR6czcrQy9aa3J4ZW85VVlweFZFUGtFUEIzVzBj?=
 =?utf-8?B?WVRGTTVXNU14RjVsNG1odDdENitHOWtHSkVmMWFkTzNIdXlYR0ROaG9UaTI5?=
 =?utf-8?B?eGZvbXpWaUNyS3JzN2ZCell1czlmTnRaajZ4Zjg1S3lNcUw2TUNVNFQxNUVC?=
 =?utf-8?B?c0llaWRGYXViUGlsZmZvZ2cwa2twZTE4UTJLNnpMSzNFMWZLNjd5OHlNK3Rp?=
 =?utf-8?B?bnoyaGVPQU9qS2FzTnpmMlRXL1FhQk0wMFYvTlgreHVWNUh5R3hiZ2dxN2tH?=
 =?utf-8?B?R21ta1RIZjI4R0hQbmlaNWQwMS9aVUpyVzU2dFBjZHFacmpxTWJ6d3F0MXRK?=
 =?utf-8?B?R1FoWE56TEFJTmJxTElWK2s0WGRlS2VYQVdsdEErczlETDJKNU9mRjNSNFBi?=
 =?utf-8?B?elhtdndQU1QzMTVReExGbmcvOXkxYjd2RjVheEhYU0dpaDBBbW5DNEFiVGRk?=
 =?utf-8?B?M216alZJR3NnZFptajB4REEzcC9pZW8vUHdLY1JwdytES0QwMFpsSVppRlkv?=
 =?utf-8?B?aGR5OC9sbk1lOXRiSm9vUWZ3RnRIbDZvZXNMcVdHcjZJYTdsQkFjLzhrMDRY?=
 =?utf-8?B?WGVYVUpDaktIQWxDaWNFWTVYNUpieHpHa1RFd0hqbS92NVEvYldjOW0wZndI?=
 =?utf-8?B?MlRFNzQ1OXZsMDhLM0xtUFk3NlZCT1JoaUVMbUhIeS95UFMzdzVkdWlscmds?=
 =?utf-8?B?ZzBkTitKT0NLZmt2RzdsQyt0bGNYT3UvV3NRakl0UG5pejhJc2tvMTQ4dW5O?=
 =?utf-8?B?T1JOV0JnRzVoV0oxTlVlampFQ1VpREhvQ2x0VE5LT1BrOVlZa3ZGSHpBSEF5?=
 =?utf-8?B?dE9DaVEvd1gwU0l6T0U3NGludWoveHBrK3Q3OHFXMXVIT01GOEp4N2dlaS9s?=
 =?utf-8?B?UC9SREoxVTR2alY3eHJnb0ZhUm9yOUx2ZlcySzZWSm9UcHc5aDFsRXoyR3Y3?=
 =?utf-8?B?WkpaUWJHbEhROVExRUNNeXk3VUJScXVyN2hZUUFCOU1uZllYeU9UaERubTFR?=
 =?utf-8?B?Rktza1AxV2wvVThtUG00ejA1eHdRL0p2R3JnOHBQanM2RWQ0S01nRXRFVnBE?=
 =?utf-8?B?SW5uek9EYVVRYXBYRDEzTnpRZ0RLcC9XNW9kYWVWZHVLS0JzMFZlU1pLdUwy?=
 =?utf-8?B?MWF4SDdVcDV5ZVdNU1FNK2E5WDM2QWZBaXhoeVBXZkJmQkFtcUZwRnpIK2tv?=
 =?utf-8?B?MzhpSXFQR01uWWgva1NDSlJlM2pjbjhqWGtxZ1RGS2IrMW8zMmNYTU5UZUtT?=
 =?utf-8?B?cVkyTzdtM3hRTlNEWm41OVVRSVBXMmZ1K3Jia1J2N2hJSnhaS3pJeHczVStj?=
 =?utf-8?B?L2xjWk1VbXZ2STE4a21FeWd3Q3d1ZTZXY1VmOE9sK21iS2JTQzRrdkdzNEZL?=
 =?utf-8?B?anRBMTZKbTdYcURjcG1OK2pNUHo1MTgvTk82UXQ1ZEZ1UkpDdkNNSk8zWTFL?=
 =?utf-8?B?YlZmbGdtSFZQT1lYNVFZYnY0RnhRcUJXdzkxbHVwQmwrK1ZzN0hTSXl5dzJP?=
 =?utf-8?B?UFdmN3ZMZUNIWm95L1BNY3Y0QkEwT2RXQnFEUjVkRFpobXZsT3h0M01rbTJW?=
 =?utf-8?B?SHFRMjMxZE1pM0lpbmhoUGlVT3ZLRTZ3bDJIWHhZbjhXeDYydXFuUmN3c3hF?=
 =?utf-8?B?Nmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19F823D7BA9DCE43B576B46CB02D1400@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf97162-feb7-4beb-d520-08dce6a090f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2024 07:20:48.0106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YEwf6orkt9c70oZUpEAgf8ET/KVNkX8pHhhXy+ynox94qkBJBXLoNHKpfTmsMeoki4lmNwey4sWeEUxkjsjuDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8180
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--23.885600-8.000000
X-TMASE-MatchedRID: Nail4dlEBNHUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTApX
	78mdqZJjw69keE2ImrCY5e3oo7MBTdkWp8vGVp97cWo5Vvs8MQtIv4RV84lHTWltirZ/iPP5WLp
	hJP1LZR/yADIkhx/IMB9efM/CDO/8fqPFbZMN65BuZoNKc6pl+NJiOXUqKHDnFJnEpmt9OE/5D2
	fKjr61wOAoSkLj1dCKVEfDZRdL9NxxgewaS64+l5gCHftmwEMLZph2fCfuodwHKa9BbJu1VObTp
	JWONTOHi8zVgXoAltj2Xsf5MVCB1t7DW3B48kkHdB/CxWTRRu4BQLWahPl6cftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--23.885600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	4AE776BF2B5AED2786509E5587C407242C20332AE74C52862825FADE3995B2F52000:8
X-MTK: N

T24gVGh1LCAyMDI0LTEwLTAzIGF0IDEzOjAyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMTAvMi8yNCA1OjQyIEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggbWVyZWx5IGFsaWducyB3aXRoIHRoZSBhcHByb2Fj
aCBvZiBTREIgbW9kZQ0KPiA+IGFuZCBkb2VzIG5vdCBpbnZvbHZlIHRoZSBmbG93IG9mIHNjc2lf
ZG9uZS4gQmVzaWRlcywNCj4gPiBJIGRvbid0IHNlZSBhbnkgaXNzdWUgd2l0aCBjb25jdXJyZW5j
eSBiZXR3ZWVuDQo+ID4gdWZzaGNkX2Fib3J0X29uZSgpIGNhbGxpbmcgdWZzaGNkX3RyeV90b19h
Ym9ydF90YXNrKCkNCj4gPiBhbmQgc2NzaV9kb25lKCkuIENhbiB5b3UgcG9pbnQgb3V0IHRoZSBz
cGVjaWZpYyBmbG93IHdoZXJlDQo+ID4gdGhlIHByb2JsZW0gb2NjdXJzPyBJZiB0aGVyZSBpcyBv
bmUsIHNob3VsZG4ndCBTREIgbW9kZQ0KPiA+IGhhdmUgdGhlIHNhbWUgaXNzdWU/DQo+IA0KPiBI
aSBQZXRlciwNCj4gDQo+IENvcnJlY3QsIG15IGNvbW1lbnQgYXBwbGllcyB0byBib3RoIGxlZ2Fj
eSBtb2RlIGFuZCBNQ1EgbW9kZS4gRnJvbQ0KPiB0aGUgDQo+IHNlY3Rpb24gaW4gdGhlIFVGUyBz
dGFuZGFyZCBhYm91dCBBQk9SVCBUQVNLOiAiQSByZXNwb25zZSBvZiBGVU5DVElPTg0KPiBDT01Q
TEVURSBzaGFsbCBpbmRpY2F0ZSB0aGF0IHRoZSBjb21tYW5kIHdhcyBhYm9ydGVkIG9yIHdhcyBu
b3QgaW4NCj4gdGhlIA0KPiB0YXNrIHNldC4iIEluIG90aGVyIHdvcmRzLCBpZiBhIGNvbW1hbmQg
Y29tcGxldGVzIGp1c3QgYmVmb3JlIA0KPiB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSBjYWxs
cyB1ZnNoY2RfaXNzdWVfdG1fY21kKCksIHRoZW4NCj4gdWZzaGNkX3RyeV90b19hYm9ydF90YXNr
KCkgd2lsbCBjYWxsIHVmc2hjZF9jbGVhcl9jbWQoKSBmb3IgYSBjb21tYW5kDQo+IHRoYXQgaGFz
IGFscmVhZHkgY29tcGxldGVkLiBJbiBsZWdhY3kgbW9kZSwgdGhpcyBjYWxsIHdpbGwgc3VjY2Vl
ZC4NCj4gDQoNCkhpIEJhcnQsDQoNClllcywgdGhlIGxlZ2FjeSBTREIgbW9kZSBpcyBwcm90ZWN0
ZWQgYnkgdGhlIG91dHN0YW5kaW5nX2xvY2suDQoNCg0KPiBIZW5jZSwgYm90aCB1ZnNoY2RfY29t
cGxfb25lX2NxZSgpIGFuZCB1ZnNoY2RfYWJvcnRfYWxsKCkgd2lsbCBjYWxsDQo+IHVmc2hjZF9y
ZWxlYXNlKGhiYSkuIFRoaXMgd2lsbCBjYXVzZSBoYmEtPmNsa19nYXRpbmcuYWN0aXZlX3JlcXMg
dG8NCj4gYmUNCj4gZGVjcmVtZW50ZWQgdHdpY2UgaW5zdGVhZCBvZiBvbmx5IG9uY2UuIERvIHlv
dSBhZ3JlZSB0aGF0IHRoaXMgY2FuDQo+IGhhcHBlbiBhbmQgYWxzbyB0aGF0IGl0IHNob3VsZCBi
ZSBwcmV2ZW50ZWQgdGhhdCB0aGlzIGhhcHBlbnM/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0
Lg0KDQpTb3JyeSwgSSBzdGlsbCBkb24ndCB1bmRlcnN0YW5kIHdoeSBib3RoIHVmc2hjZF9jb21w
bF9vbmVfY3FlKCkgDQphbmQgdWZzaGNkX2Fib3J0X2FsbCgpIHdpbGwgY2FsbCB1ZnNoY2RfcmVs
ZWFzZShoYmEpPyANCkJlY2F1c2UgSSBoYXZlIGFscmVhZHkgcmVtb3ZlZCB0aGUgdWZzaGNkX3Jl
bGVhc2Vfc2NzaV9jbWQgZnJvbSANCnVmc2hjZF9hYm9ydF9vbmUsIHNvIHRoZSBjb21tYW5kIHdv
bid0IGJlIHJlbGVhc2VkIGltbWVkaWF0ZWx5IA0KYWZ0ZXIgdWZzaGNkX3RyeV90b19hYm9ydF90
YXNrIHN1Y2NlZWRzLiBJbnN0ZWFkLCBpdCB3aWxsIHdhaXQgDQp1bnRpbCB0aGUgQ1EgRW50cnkg
Y29tZXMgaW4gYmVmb3JlIHJlbGVhc2luZy4gQW5kIHNpbmNlIGl0IGlzIA0KcHJvdGVjdGVkIGJ5
IHRoZSBjcV9sb2NrLCBpdCBzaG91bGQgb25seSByZWxlYXNlIG9uY2UsIHJpZ2h0Pw0KDQpUaGFu
a3MuDQpQZXRlcg0KDQo=
