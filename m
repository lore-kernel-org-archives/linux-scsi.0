Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEC24A1C
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 02:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742265590; cv=fail; b=H2Mxw2Phx8Eqe2mj7zodO5FmJmQh5qMXpbXk6XuJKBqTcV16VErbYX/wCdxZjwVSaUUbBn+BUUx7DywB67iOvxcF1eu7yaAwl5TP4J5eE+KV7+RSmy3czqqfwbgAv/OWfQkA9UJDbookPqw0v6F608rjuFjFIQOSNwM3HvCXhDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742265590; c=relaxed/simple;
	bh=AOv1qj432fhRVcEjX2h87L1QMZoh1RQgF3KLIC7uZDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o1MbgN/EGz2jgWTv/HH6foQayFVi2Dnv+aXgt6xE6TDw4p1Nn/i32TvxmmPuAb+RNn6w7SJGIXpnL83/vLVCf+NF+3gF1lqfE10aU6uz+9ttQGsHK+wVHDBsfczhUw9n4ZbV78ujrwMxRTbLKPx0TRrCbgYUYPyK+Ipcw6WZV4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pKCh+lDy; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Zx8YuYLn; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pKCh+lDy";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Zx8YuYLn"
X-UUID: 386f7e0603a211f0aae1fd9735fae912-20250318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=AOv1qj432fhRVcEjX2h87L1QMZoh1RQgF3KLIC7uZDU=;
	b=pKCh+lDyw0ihUE45ACsf+FG9IIuToIuve2y/YHPgxakDGJPyJ32kRC/waYqFkR8BazdIGotY/tMPTsO8Yi8coOLGfoH3U6EabgW4alZ1CcRdcRX1SkoneHmh7a9/uml/ToZRBT1IQ9cMJuIaKY3oZ7+xw5t8eovl4YgcCTxjIU0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:53370ac4-24a3-414e-8dc3-feb5e4b335c2,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:e7bd3b4a-a527-43d8-8af6-bc8b32d9f5e9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 386f7e0603a211f0aae1fd9735fae912-20250318
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1916316918; Tue, 18 Mar 2025 10:39:31 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 18 Mar 2025 10:39:30 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 18 Mar 2025 10:39:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+vciPCU8fqFgIObETdndxr9qVZwaDbD2uMaQWvZgnFNF9bHY6vpuLAkyQBif6fiOwAqN0RHQROVeBcugO6VeXi2oQMfIxD/jh4u1sH2gZwM/JQMAiwH1Sy94qjOGPhfF4R4GdQZQ1j+ERaS9gFgV+DCuguGc3g5BwsyCwijsXGw5ftRgtdIDUUbvGyOzcG4tUqNczbM59XtmrtGyZELYfaNxtT8M4O1hE+mZv9Er8j0uU3BZ9tkW1gbsfrNSoW+LkGfwoqlWI/NVJnRROIOQJk7ftL2tHzrH906u3v9L+H0sJtHgANdyFHwuON7XQu4Nw2vo7epjFRKtTeYwnXZ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOv1qj432fhRVcEjX2h87L1QMZoh1RQgF3KLIC7uZDU=;
 b=uwV3JulbXOtzXx0/a+Aerfm1I1xf7lYXmAQKyQfznCCF0IiGojHvE+/uyDg1XQW0LGW8boEHnPE0I3nKjW6rrwOMRp3Qr9gyjvB/EJ8rw8HLmciPl+IbgQ+Y+57+3VoqRd76fbtCkMP+/Gq1yF/WcttcegS0bb0C3gIiYY9JWZ35TrzyBbTwqROcvMt+lMHVLr4Om3oGHXmDQjnTmPojqu1jBE7wrMrc+cQ6d3M17QxWu6e6dZshDiSWrZDSvDp4khVp4a8hEq+nQWPNwulfQndqM/2TbpgIqXIU89zuZYqcPLQ8MivwpDr4wPMWxihM17CHXupDbRIvZPQnjnas0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOv1qj432fhRVcEjX2h87L1QMZoh1RQgF3KLIC7uZDU=;
 b=Zx8YuYLnTYDeoP6enYpiyEJiyKDJbXnPBcv6LkePwZBExoS8LZ6kYnAzRPXkF9Rt5P/tNEZsI1cJ5Z9OS4HyHv6eis+cBbJ31Oz0w+pghNcsNJmkjJAzhg6mbW3sV4xDwGjTXGUQskr5IUuBFTFCEw4TOtBOapD9rnw+GnxtNTg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8532.apcprd03.prod.outlook.com (2603:1096:101:1fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 02:39:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 02:39:28 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "santoshsy@gmail.com" <santoshsy@gmail.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
Thread-Topic: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
Thread-Index: AQHblTPkf/KToTGGq0SQWRiDbCLDa7N4M4eA
Date: Tue, 18 Mar 2025 02:39:28 +0000
Message-ID: <2a8360280297b17814f4ff5952c5597f3eea184e.camel@mediatek.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
In-Reply-To: <20250314225206.1487838-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8532:EE_
x-ms-office365-filtering-correlation-id: 7ea5d6c2-526b-4d3a-2816-08dd65c61ab0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cFI1dzdVS1htQVJBbTJ5VWY1RWUwTGEzQ2VGRmJvbks0Sy9zT3lFM1RpdndO?=
 =?utf-8?B?STlqdTEyd3BKNE1WSUhmeEp4NjVlbTJJY0I2MGpiV0w5eWZQTzY3a0gvZ3pF?=
 =?utf-8?B?L0g5RHhPY0FucVNJQi9UNXIwZXJaeXJMNTJPT2QvNlJGLzc4QXBGdjUrUTgz?=
 =?utf-8?B?U1k3S2NzZW9EY2FMMTJxTzJ5d012Z2M4bnZ4dVoyY3pYT2hZZ0luQ01VRU4w?=
 =?utf-8?B?WFBjQmpEQ2VTb2ZkVTIzWk55cnZRTit4Q25VNmwxdTd2UVZpbGtXcHl1bGRN?=
 =?utf-8?B?c1RtWUJydHVSdnY0VGFuZktxK2ZCTGM2aEFlVnBLbUZBUVZ3NFR0eUYyQW1X?=
 =?utf-8?B?ZHhqVjNHYzEraUpUMFhaaW12clhVNVd1UU5tWXRLSGFtN1FCSmZvNW1YcFBw?=
 =?utf-8?B?dVFMb21wUlEvWEQySnBwVmc3TVd4ZEFVV2xsVVJwSVcxd2Uwbmgrd1JQZmRQ?=
 =?utf-8?B?NHZlc0NOdmlsYXZQOFNudUY0MTU3TWwxaDJjQlJnNTVwY2NZUkRFRXNJcUxz?=
 =?utf-8?B?SENYaUs1cUZPTElLS09xdURYTlJwbkZ3UHZrWEtJZW1mNjVwVzg3MndLOWdp?=
 =?utf-8?B?cmdyZXQ5ejlESkt2WjEyM09SSnVoWm9YM2Y1WVorY1NhNllkdnI0Q3RieHVS?=
 =?utf-8?B?ei9Hek5WNEJZcGZwb05rUFZXK0Ixb0p6cmlmQUxWdVRyY2NSKzFHbmR4dDJ2?=
 =?utf-8?B?ZUlqNWRvUnZZNVMrUnU2UFpnRUIzM2xMSHRJNUszSHBvTXdjNzRMR2V3QU9n?=
 =?utf-8?B?d2VzL2ZhZWFNNERwY2ZDc3pIY3ZrUDNCMUJVOHpEaStIU1VrRUN2RlpJU1Y1?=
 =?utf-8?B?d2JsQUk5Mnl5Z0JWc2g2cUFDbzY0OFZWZnZkMVowaWhpSmkxRkIzYUhQM3Rl?=
 =?utf-8?B?V1YxS1F6ZmRla3kzOXpHT0VXUy8zSHVYNUtESmNtcnpvQXFpOHJTVDlpR2lU?=
 =?utf-8?B?bXk3ekFwT05raS9HZnhSSW56VW9qWDh4S2Z3TVJuZnRqL0NqNi9YZmU0a20z?=
 =?utf-8?B?SDVvSkhobHdJTk5kSEdVL2p6aGVZVDVoNE9QbndDL2hLN3B1VjRaUEFjRlBP?=
 =?utf-8?B?emVmNERLV3pDVkJZbitmNnJwOVVwK1cvK3ZlMTJUVTFwamI4c09JUkRFUXQr?=
 =?utf-8?B?YWdhK0ZxOFE4U3V0QzFhY29lRHZYUG9BRk1xa2NyOXVJMjJwa2F1VWhtMEZC?=
 =?utf-8?B?bDhETkxnRjdKcFoxNW8xbG00UHFxbFd0WVZUZlZQNGxydGFESGFMZGY5a3R5?=
 =?utf-8?B?SkFFTGQvTzVyUUpOVHZsZmFMeFh0cGF5bGlVenU4OE0yS1h5THJtODdPM1FC?=
 =?utf-8?B?Qkpzam9FWUxzZ3JQZWlHWHVadm05TzZZbm8xZlFnMFBkb2ZzYzFzMFRPbXQz?=
 =?utf-8?B?SlN5N3llUHJaS0N4SXhwaWpOajF5K2VML2NGa00wNlFBNmc2OE1MWEFjQVRN?=
 =?utf-8?B?Rk5JbDlPMFR0RXoweG9RWmJpWVFwUGo3RDFrcmlHak9QV2lJQzFRbXJ0YkNM?=
 =?utf-8?B?RTc3ZHRiTWZFSXE2OTBSaW1mYXl0KzludTROdDNxTlN5NlJmaHB3Uk9jQ0lz?=
 =?utf-8?B?VDlCV0tnK2pnQU1LeWtJMWpXQnJnNEhwQUwvK2lkUDVFOWtZdGQ2QnVtc1pz?=
 =?utf-8?B?aThrY1ZyL2t2bWtJWXdyeE1HUS9hYkpBTnByaW9lZFpqRVQxcWRFQUMxOVNJ?=
 =?utf-8?B?NGo4UkVuME10RTdmMVFSR29kQXQ4Q3YzM0h1MWdkblJxam5SM0s1dlNrWWYz?=
 =?utf-8?B?QnRUSW9nbDlNR2hhQ2d6MnYxc3NOZVlBM2hiLzJ0MWlBSVdiNHI3T1laalMy?=
 =?utf-8?B?MXNaNnExTGg5aHZ3Y3BmTjNPcmtockdLWVloMU9ROW9OOFZKWGlTREE0MWc0?=
 =?utf-8?B?bFMrdEtHVHhDVjlRNTlXTTM0M2ZYWm9zOUIzc3kwNWoyU3kyVEtDeks3bm9Q?=
 =?utf-8?Q?v0zyK53kQihHMGQlOE1obmb6dFQYkzRV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vzk2OFpML2ZzeFBTRVk4QlNVZFpNRWk2UTdpeis4dDdXRklFUjV0SlJwVkVS?=
 =?utf-8?B?WUtCTHJTRmg5Q21UanhJY2UwR0w4Qkw5aHBrY28xZkI0bVcxOHI4cXdGMU92?=
 =?utf-8?B?TG9ySkdEUlI1citEN2I2SFB6dGh5L1hBR1VHSnFMSkVlRmJJM3hMYXd4MWE4?=
 =?utf-8?B?QVBqR2JHcUN1RXVnWk1vNlhjQ1A3NnRUdXh5SUk5N0kyamlEaUIxTnBxeFow?=
 =?utf-8?B?bXBNWDJ5UnFKcjhEamNEK0pKYVl4Zyt5ZzJ5cHJwM0JDdCtuMmRFcHluSkl5?=
 =?utf-8?B?VUR2U29OVk1BN3NYdDFNc2FtUjE4cWpEVWQ3dExrUGtRdTE2MTZSKzdIbzZV?=
 =?utf-8?B?TVY0aHFpYUVaVElZOS9GVXU5ZFpkZlh5MGRDYVliVkxiRU1nS0huN3Q3REtx?=
 =?utf-8?B?Z2JCbGc5NjV5VjEzUWE3dWxyUUxQRGgxa2Rkdzc1TE5QNytXSWVkL1RpdkZX?=
 =?utf-8?B?L2xkaGk0VXZVazU4dVlsU1h5ZWtLVVFwSHk4TVMrVnJId284Zkw1V2JNNWNt?=
 =?utf-8?B?SCtWdXUyVExIcHpqaGRXVlQ2dEgyZlAyZC9USU5oVkNxRXF1bVh5T3NQOTUy?=
 =?utf-8?B?NXZTWkp2SExmRzMrQTU2VGZkaXJjb0xWTy8yRXcxVzJNVytOSnJaMGN6VFNs?=
 =?utf-8?B?ZWZjRmh2dlRpdkJ5cmtac2J1RGN4d1JTWk1xbzR2cDFwU1FwUXJjVU95dzFY?=
 =?utf-8?B?U3FlM0NqWnc5WUpvcHc5cHQ0MkVTWDNjY2Y1SXQ5YkJ4bTkzMk1LSi81THV4?=
 =?utf-8?B?WDBDd1ovb3Y5K3k4ajNCZWl3K0pUTG1RR3FEdStaamNLSlpHUUhFdEdWWi9P?=
 =?utf-8?B?ZkVDc1dma2VBbnV3a2J2c21uV0dwVUZWUE5SSjNlakpLazhKVkhldFVzbkRH?=
 =?utf-8?B?OWVtbzdNTXBmQXNHTXQya3ZHdk50dUp6ZmpTeUVnVTN5TTBHM0hvb2dQRnpy?=
 =?utf-8?B?MnhZVHllZDlRMFlqOEt1ekluVVBNRHVRQlFsODVWTnJrREFPL1hJQnJkZUd0?=
 =?utf-8?B?NjlWd2R5Sy95VWhST1ZBV0dOZWc5eVpRRVZrUzYzVWEwN01XT0pxUHkrU21i?=
 =?utf-8?B?R3Zwd3JXTEw2SW1LcUNFbGY1VEY1UE10UXF6WU9QRUtkUVhjKzU2QUV5SWNE?=
 =?utf-8?B?QlhmU1RCeE1KZDZtN1BPd2lMRy9vMHdxOEtwL3Y1a0dmdEgzM3hseG5RTEIv?=
 =?utf-8?B?bFNKRVgyc2FITHJmUUhHcjg1VHF0YnY2azhscUJ4b3JvWk5RL3FXbW1DZkNM?=
 =?utf-8?B?M1dvdXdiWk9aRVVudHA5ZG8wMU1pZy9zUklzZXFVVnZJQ0VoWTZtczkvTzdB?=
 =?utf-8?B?Q2FwNTdqanArWFBvMUV5THNzVFBmanBDLzZSOUkvN09MK3lucGdaVHJWcWE4?=
 =?utf-8?B?OHFQdHJlOHY0bXl3MGd5UGZOMjdmOVRLQTFUa2Jza0R4UmsrbVNwbHdlWnV6?=
 =?utf-8?B?RlFYWVlWMjNTSGNzU1lySlNxb1lTNDRsUlROOXRmNjBNQTU1Ri83NTZSNFVj?=
 =?utf-8?B?c2xqbHNQb0VwZzVJKzNoZlIrcTlTM0xsMjZDRms4QXpEa09PUGQwS3AyT0dk?=
 =?utf-8?B?T3NzYlo5WVh1d2pXaXF5TENBTjl3L25KSkw1NzVRbFVhMUgwb29IRlk1elVL?=
 =?utf-8?B?R2orVkpHM1hYOSt4TjJ2Y2FwNUZ2VGFBUEIxb0xZSW1QWlNidGVKR1p6ODE0?=
 =?utf-8?B?Q1hDK2QzbGlKcFFKT2EySzRrM3MycXpKaEIzR3ZDZUk4R1FURjJuMDh4aUpY?=
 =?utf-8?B?eVJrRUNPa3ZmQVI1ZHZjTVVYWkwzY090QThneTJhSjBOeHcwZ1IzNHJROWZO?=
 =?utf-8?B?Z0Y0VitsM0ZMYkQ2OGNndVgrbzcyNWk4TVdna3J6c2VIeHA4UGRhN2xObm0x?=
 =?utf-8?B?SGphWW50VVhBOXFwK3BmdndFQ0M5c1E2dmF1U2ZlUWpzMHBhYng5WWlMQmw2?=
 =?utf-8?B?Y1gzMlZwWmcxemVKS3htNDcvWHVlVzh2Z0R4S0QxM1NMZ2lLWkVBa21lbk1w?=
 =?utf-8?B?MW1uZXZNcU9GVk83Vk1JU054V2RHYW5PZTZvRGpMZjZVemJzSjhxSGk3R2VS?=
 =?utf-8?B?M05DR0E3R1B1djNiK1gxODhaTzN5RWhYRTcrS3ZNMXo1OS9Xekx5SEdveThB?=
 =?utf-8?B?NXV3QWwvOXZONUlocHZKZmtzS0Z6WTdWd2pXM1RrSUx3Q2pMUG1XVVFkQ2hQ?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF5700693DB40D4191F00625FB837642@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea5d6c2-526b-4d3a-2816-08dd65c61ab0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 02:39:28.1859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+JOhbWgBfTWaSI3qPKcWKfUlsMXl8dXEagzEnNYo69NI5Dc/nztjARFv3zvZnwT/fhqY9vdVD9dgAMnTWp+Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8532

T24gRnJpLCAyMDI1LTAzLTE0IGF0IDE1OjUxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IFRoZXJlIGlzIGEgVE9DVE9VIHJhY2UgaW4gdWZzaGNkX2Nv
bXBsX29uZV9jcWUoKTogaGJhLQ0KPiA+ZGV2X2NtZC5jb21wbGV0ZQ0KPiBtYXkgYmUgY2xlYXJl
ZCBmcm9tIGFub3RoZXIgdGhyZWFkIGFmdGVyIGl0IGhhcyBiZWVuIGNoZWNrZWQgYW5kDQo+IGJl
Zm9yZQ0KPiBpdCBpcyB1c2VkLiBGaXggdGhpcyByYWNlIGJ5IG1vdmluZyB0aGUgZGV2aWNlIGNv
bW1hbmQgY29tcGxldGlvbg0KPiBmcm9tDQo+IHRoZSBzdGFjayBvZiB0aGUgZGV2aWNlIGNvbW1h
bmQgc3VibWl0dGVyIGludG8gc3RydWN0IHVmc19oYmEuIFRoaXMNCj4gcGF0Y2ggZml4ZXMgdGhl
IGZvbGxvd2luZyBrZXJuZWwgY3Jhc2g6DQo+IA0KPiBVbmFibGUgdG8gaGFuZGxlIGtlcm5lbCBO
VUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgdmlydHVhbCBhZGRyZXNzDQo+IDAwMDAwMDAwMDAw
MDAwMDgNCj4gQ2FsbCB0cmFjZToNCj4gwqBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MzQvMHg4
MA0KPiDCoGNvbXBsZXRlKzB4MjQvMHhiOA0KPiDCoHVmc2hjZF9jb21wbF9vbmVfY3FlKzB4MTNj
LzB4NGYwDQo+IMKgdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKzB4YjQvMHgxMDgNCj4gwqB1ZnNo
Y2RfaW50cisweDJmNC8weDQ0NA0KPiDCoF9faGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHhiYy8w
eDI1MA0KPiDCoGhhbmRsZV9pcnFfZXZlbnQrMHg0OC8weGIwDQo+IA0KPiBGaXhlczogNWEwYjBj
YjliZWU3ICgiW1NDU0ldIHVmczogQWRkIHN1cHBvcnQgZm9yIHNlbmRpbmcgTk9QIE9VVA0KPiBV
UElVIikNCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5v
cmc+DQo+IC0tLQ0KPiANCj4gQ2hhbmdlcyBjb21wYXJlZCB0byB2MToNCj4gwqAtIENhbGwgaW5p
dF9jb21wbGV0aW9uKCkgb25jZSBpbnN0ZWFkIG9mIGV2ZXJ5IHRpbWUgYSBkZXZpY2UNCj4gbWFu
YWdlbWVudA0KPiDCoMKgIGNvbW1hbmQgaXMgc3VibWl0dGVkLg0KPiANCg0KUmV2aWV3ZWQtYnk6
IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
