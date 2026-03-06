Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D451D7262A
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 03:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772769012; cv=fail; b=T2bIQwIi1kWRn+8fvLkkAkRzREqcSv5q4LWeVAHvbUy0rpDsrII+MQ5SX3Bq6FsLURl22gTLgwhyVzvE7OlSrPbDsd0EByEj2KNJDz9W1J2q7KagEWOu7e0YdByOxeJGhbPJc0V/n1S2BrIzqJqoPDTGtL8E1TuXvT0k0KYTf3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772769012; c=relaxed/simple;
	bh=nDqA+fKNOBTIR/XMLkQg7tbqrQ+q+6nuIS53V34miuM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jAB7i2MHSc8nfZhw7Pp+xlq9KWN7r6u7Gi4lkXYDKAMenoghCkF9rIAxLO5BBrFRPINMe4rwHo07TE4dUhkYc8ri7PRP7nVK/G5kP9uH3ZdofWopiTer39DTSZLLSlhx9rAKUWWIFC/N6so5J1uHqRcknCQqrHXkKD4y6pCBVU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CJkECy/k; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=V007UJc+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CJkECy/k";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="V007UJc+"
X-UUID: 8edc5bf0190f11f1a39cd589f645bc18-20260306
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=nDqA+fKNOBTIR/XMLkQg7tbqrQ+q+6nuIS53V34miuM=;
	b=CJkECy/kmPSbOhvVv3qAWL8tT7rSilx3pBu/YBdW4zVERHCAujWWUUZ6rAdrEO0R6U75HRMIIoaHtIbeh38MFkuwVi4DcsajIaR4EVPLZwy9TPysWttUNhzXXh7i7bNN//X3ObGGw7aX1cKRmRqVc94tuhBTgGljlqlu4PutO+A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:f2672383-c831-465b-b825-436412a1b51d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:a27c52f1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8edc5bf0190f11f1a39cd589f645bc18-20260306
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1937599371; Fri, 06 Mar 2026 11:50:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Mar 2026 11:50:02 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Mar 2026 11:50:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uiPJy9WXMQtXlX2zB93k9iHh6GTNoFjdKiP4gitUFKksJ4LDCkqY9Cb8Dsnl8kqtZy3iGPjwq/aEarCdPcGDH1hFUCO+qxhYrIt39VVXp5r+lJCN44HJgStMGoFT/pltGeMiRKuJjY56JnOVqilHE2YmVGMVooyGc4Noh63VCApHhhIHpZNpjTLkx/DS0mJu9XFo9me/LBRiurxkETMVIbu4gVJfUj3WW6p+Pgc38iKOhXOY9KaDG78NALJMxWEcEhPp78TWGLBBmL3z81J9/38P6fyiT/1UPI+UIm2movg40/ruRfQvQ4FNxLxdQ6DOHsMdii94odhw6NnGyOB8+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDqA+fKNOBTIR/XMLkQg7tbqrQ+q+6nuIS53V34miuM=;
 b=zEHNmJtnoJ77JBHLp7FVN6FvswtuWlIU6aCt39nsDEgHhCcDVD6zSNLE8IXF8ZNgaB3t7GLyi9JtkdlOIiIlN/+OzCbaV46z3RnEvpZzYE7/kdjM1CdDSPgVcm8JrdEgr4ec5fFgJATI7zDDf26qPoiPpmg4c5fjZIav3dTNKGSacZHCkGkSHhXHRhI+W2QcfW4mnqRS1/l866/DAA3zISEscuRBa/sg3fgibccr4aXfLFL4IqsdnkV6J91e3vWiiEA9ufLP8/K95T+w+nWmsjwdE7fet59TRQYoaWBcUlzKAPOlWgiqW/5YKjJhzoAEcEY9+yh/k9coYqlenAzQrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDqA+fKNOBTIR/XMLkQg7tbqrQ+q+6nuIS53V34miuM=;
 b=V007UJc+28YbLc23zu1ff3jmHptDhkHFB7anureP3hcaQp1HwJqST5oMlDTl8IeGRMOucgJzPWJ/bChWtSSLNNDo3emsPWVAHm2VnCzXVrZRIxTaKSVpLfu9+aKfBJnYiiC19c3rNoASpQRUriI2nfro9OGRTxERDIMCcwy2dNM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8797.apcprd03.prod.outlook.com (2603:1096:820:145::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 03:49:59 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 03:49:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Topic: [PATCH v1] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Index: AQHcq6Z23AQptP1Dk0+Aud7gmBXImrWeczwAgADVaQCAAJQoAIABBIAA
Date: Fri, 6 Mar 2026 03:49:59 +0000
Message-ID: <e08e2f535fa318d3784f5cf5539fdcb38e7ed884.camel@mediatek.com>
References: <20260304071346.1391315-1-peter.wang@mediatek.com>
	 <ab2de228-47f0-40b0-b586-c970a9c0652a@acm.org>
	 <fa949b2c2f9d23fa112f8b37377ca2f23c5bb258.camel@mediatek.com>
	 <16a44a0c-1fcf-4e3a-bf9e-d29ca5f62157@acm.org>
In-Reply-To: <16a44a0c-1fcf-4e3a-bf9e-d29ca5f62157@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8797:EE_
x-ms-office365-filtering-correlation-id: 59fcfbfb-0bbd-403b-f6ed-08de7b33707f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: DkVK73CzdD/mSsWT6ESDio43eQdEILtRXIidyc1Ghjkec9efPVznZF8Fv6QxUmej5Ro4NWoORbTTUqPhD+W9f1NVEDsG6+1yCPc49/OL6D3psJlE9bYe0HJYGC7ZEmkLh+ekjbsNlVJhu1jECGRExxP/cE1uKWlo9wRrRNXii38lLlNkUGmRnxFCn7QRnxVPWkMfRknrv/KJzSaxHqNX/D7wUSSUky1VSiiVFObwvfS0wDPp/ivJ8vwhB12ZKCsYWZ75ETRTzY2jmtUI6f4PxDKxZYlxnYDkkGJqGeGMvIIJSX7jZqiRtXdWl8ieX4y4CG90TXVSehA+fsjn0csVX4lw55WDp6P5T2YrQ+OsVQO5TrGziVu30YMfQmtsAbDs4bsb6Lh6lKjII5kF5wrzl+ErmVChcJsMsWMyeVNFq5sA/fC3sHoE9P+POKIU+7bwogDDv/g7+PIhBzk8xDv0+zOuXKIdj5Jct3Z+/xun2c2AqfeK5y/NpR5nMiZkBHmCjgl4hF5srEHJvDQ/W/r2FanL90imT6QU0DjipEwYYO/fftOrNGJVIHm11wssoExiv8cwI4xOFP2gD5SmrQjAOTHasX1d0F5leNR2fnCrcoX11RxkJn7gcA53YjEuLOMs5DBKzBk5iLFdIeVPm7nN8tq3ba1puFwzakoiR8LTnBI34sAnTf3rFQG8Mb7u0pxVO6/vIm9rWCU8AaeWH1nKRD8qeSv/urODu0NyR3TxFfKCDxlFAa8mtO1vmB1WaJeCIB3rXDXuRbHh1L9/wRec2e82AzONc9YEV+zug3JiweU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDdyNlZnODNQbko3cmxVYTBYaVF6azhQci91UU9FY01vaEgrYmMvTjhBOVpn?=
 =?utf-8?B?MG0vRnoyNmkrSElKV2RTVlJWWjU2S1JsL3lIYVFOTHNZNjlkWE1oQzRLL3pE?=
 =?utf-8?B?VHhoR0JoeVNic3p5RlU5cWdrQUpCbzZLZUJzMGM1L3ZlZnI4b29lSWJZMFNR?=
 =?utf-8?B?emU3a1pVcDJaWjZYYkdYUHlWNDRtUkZWbWFORHArU3QxMkJtL3BkTExpbGxq?=
 =?utf-8?B?b01DMG16R09IekF4MXhGZnVidTNKRU11NXRCa0ZpUG1GdWwxZWtMelh3ZzI3?=
 =?utf-8?B?SWlUa3hGQXp5RFdiYWJpRlFZUlE0ekFKNzFCZDU2ZTJmTy9ldHNiUUNJRDFw?=
 =?utf-8?B?Z3NDWWhTbFYxdGNLL2dRY1JZRDFZR0I0TjcwR2paK3VBWHdSZVlrZ0FuK3VK?=
 =?utf-8?B?YWxjQTdQMkVJVVpsclpYM2RXRGV5a0hDbFhLK084VDJNTTFCcGc3NC9QMlRE?=
 =?utf-8?B?Y2ErbUNUT2tTZ2J1Zmo2T3RGYVVLZ253Y1JlSXJxMElqWkc4OHhGMFYrWTZH?=
 =?utf-8?B?RDR3bzRWNW0xdER3NG1CS2hmbEVrbzdHVVV3T3lYMzViTFBMZkNBcHpMRDVy?=
 =?utf-8?B?QVg0eTdISzE5SEdLN2FNb0EvN3Ruek5pMXpiUjVPcjFkR24zZXNkUHBEWFNO?=
 =?utf-8?B?SWlPQ0c2MkhjazJFRWcvSFk2QlhCVmJMMmQ2U0phV3lFd20vQjRFbGhCZkFZ?=
 =?utf-8?B?ei9yOHhtUEtxcUxGbUsxcFZpdmYwVDNSa2c4c3lBR2hLdkdDTk9ESlQvcFV2?=
 =?utf-8?B?czZiQXVoTUlVZDZ0QWgwckFCQkJKajBjaGxCNnlBU0xUV2V5R0ZLdml2TCs0?=
 =?utf-8?B?MUJibGZyUVpJS2p4VmE0WjlFWkdLNGh6Q1ZNcHVjYU04N2d4RC8rRk15cmtr?=
 =?utf-8?B?ckgxVkV6aTUzbXJsY3ZUMmZHWjh0Rml6VU1CRXRUOHNBSzhMQ2tXaG9jREFK?=
 =?utf-8?B?TmZxcjRyRS9SR0xmeWpPc3pYYURJSk1nMkJZMy9Za0xqNUQ2cDJLLzdEZEpj?=
 =?utf-8?B?bTk2eHpDeHFJbEMvK2RFY3V1Ukl4dm1tRUhFaU9XVXhyMVlpN3Z2UXJSTncz?=
 =?utf-8?B?cGFDUzdpMnkrWjM4UGZEbjZ2bG9mTkIvOU9oUjNxT1pYSElqNkp2eGNadDEr?=
 =?utf-8?B?QWUzbGtjSkw0Wms3VlJaQ0tZVExRR0E2WmpUVDRUdHR4R05ndlpjQWxkUFZi?=
 =?utf-8?B?ZUZvTmFrU1U3V2VXaEJmV1ZIMy92dFppd3dmMGxodmYzYW5IdWE5TUhuOUxk?=
 =?utf-8?B?VlcrUjA1bG9uandFVVBmNGlWS2pPNWduMVNOL0dCb2tDTkpFWEhiVmRvY3Av?=
 =?utf-8?B?Vzg1U0QzR1lWd01jb2d0RVVEelM0LzhPRStIaUNDenliMCsxL0phT1B2U05O?=
 =?utf-8?B?ZmhaVXhCZFA4dWRHYzJqSzZFQ3RtVityK2RLUTBRTW9hYm9sSjEzSnhtTTNR?=
 =?utf-8?B?VTNtTjNMWVNUREphWUVlVE1OMFJ4STJwK1RIQ056ZTJEZGlPWURVaGFQZ2o0?=
 =?utf-8?B?ZFpLb3o5ZEJDbTByVUVaZXlqUFkyYlIraXlWaEtjcUNuYUNrNDlIRHVoZEY5?=
 =?utf-8?B?SXEraEpFMW5pSlY0NDVvNnNRUHFTV2ZyUENvZ2ZWWktkbU9qc0R0UnIrQ2FV?=
 =?utf-8?B?endYYTNWRWtRbVZHZ1AyN3lWYlRZRENwSmVPMndCdEYyTG50ZU9EbGpEVXVX?=
 =?utf-8?B?UHU1WGRrQTZQZU1wS0cybXZ2L3c1TmJvbXZLOWtLK2NVQ1Y5S05aa3BmVnd6?=
 =?utf-8?B?aThtUjhPNnd4dXB5ZzlKUnFPNGlWSVBTek9wbm1kMExVV1lxV3NLdVRrSEJD?=
 =?utf-8?B?RmhFUjVha1ZWMU1sblk2OXpvZnpKRTVvSUtYUlBINFdNU2V6NERTcTJYUkc0?=
 =?utf-8?B?TXJGRGdsSVAyMHVWaVQzVGdPcXVKZGZ4WG5HOExsT3VNNVdmQVBsZXVVWGQ3?=
 =?utf-8?B?RmdlZ2JUM3RqZ1kzeGsvTzIwVHMraWtVcHRmODhEZEpCenpoanVzbDBRUHY5?=
 =?utf-8?B?TUJwYXNuTnY3WXoxZFVZbW9HK0Z0dVFkNi8yMGhMdHB0bytlY3dLamQ3RGh3?=
 =?utf-8?B?ZnJ3Y1o4TjJYcnprN2hjbkRiZFpkZzZ3UHVuWE5RaGdNRGZ5MzhPTjBzTzF1?=
 =?utf-8?B?Ymh5RWVUdUxWVVVJWWJXckNhM2ozRHVHSFg5SEttWjhvNkI4Qk9TYUZrajFs?=
 =?utf-8?B?eGhwNldSQ0pJMVV2R2F4Tll4bk5LT0lici91TzBwSVlrVS9mbjFtSElYZjdL?=
 =?utf-8?B?Qk5uU0c2eDRjc3ZjbmFjZzh0UFNxaWpja01hdmU5encwWGhTcWg3SG1XYURB?=
 =?utf-8?B?TkJsWVNkaWp6VTFjUWhZakxPQ3k2VVQ3U3JBTnJiUGpoSkx2RjN6cmZYSkUr?=
 =?utf-8?Q?vebbTOLS2IpPqouw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40217262744D8F49A0457A607F5784AF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Hj8K5NhOtjafp6G8rIBDP0CMx0a7pS+PllzJbqoYCSjlSDNe7BQAUP8wk2vlbKKlEUhjyEJXuWQFcnpuXVlDPqv3w3+Cm81AdCSV3g7MQaQMWO9E4lfvPX23tPdR1AYGew8HfY5kACKsUYUt1oyK7Jnksqma8pZUFaOjeT+kG4pu/07O3yCl+Gq19feRzYEST9k6qj8ch2pPmem4RKDZfh6s4LKzH/q5MPfNWsTJfNk50q5sh7fDmnH7P1CnNl9lSLSopg7Mg/iRiNchboTIC14Zflu8maNx980QVLEc2wTAjVCEaWWNlp6xtseXAS4OBwbQq52KlBLsKPlaOf2ZRA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fcfbfb-0bbd-403b-f6ed-08de7b33707f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 03:49:59.4048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6pTJeQGerCgxkISbU0YGrdhOmMxc4zNpHb2hFk+O1oajDfDUob7Wx3m+4oo6BdTaECGi7Y0CYNY9vf7CYah3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8797
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTA1IGF0IDA2OjE3IC0wNjAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFNwZW5kaW5nIDUwMCBtcyBpbiBpbnRlcnJ1cHRzIHdpdGhvdXQgZ2l2aW5nIHRoZSBDUFUg
YSBjaGFuY2UgdG8gcnVuDQo+IGlzDQo+IGV4Y2Vzc2l2ZSwgaXNuJ3QgaXQ/IEFueXdheSwgaWYg
eW91IHJlYWxseSBuZWVkIHRoaXMgcGF0Y2gsIHBsZWFzZQ0KPiBtZW50aW9uIHRoZSBhYm92ZSBp
bmZvcm1hdGlvbiBpbiB0aGUgcGF0Y2ggZGVzY3JpcHRpb24gYW5kIGNvbWJpbmUNCj4gdGhlDQo+
IHR3byBpZi1zdGF0ZW1lbnRzIGludG8gYSBzaW5nbGUgaWYtc3RhdGVtZW50LCBlLmcuIGFzIGZv
bGxvd3M6DQo+IA0KPiBpZiAoKCFoYmEtPm1jcV9lbmFibGVkIHx8ICFoYmEtPm1jcV9lc2lfZW5h
YmxlZCkgJiYNCj4gwqDCoMKgwqAgIWhiYS0+YWN0aXZlX3VpY19jbWQpDQo+IMKgwqDCoMKgwqDC
oMKgIC4uLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNClllcywgSSB3aWxsIGFk
ZCBtb3JlIGRlc2NyaXB0aW9uIGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClRoYW5rcw0KUGV0ZXIN
Cg==
