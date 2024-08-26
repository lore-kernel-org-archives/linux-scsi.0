Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567CFE56C
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 06:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724653005; cv=fail; b=hzDLuDO8uKWE0rot9c/ZGUsnpKNx9OM0ssWxxt4XtU0mJct8+kn9szGI5dNtTDuLu92/1u8g0AGBJiG3UsvLe2qE6BYzHlu54XkPvWBZbzS9NgldhKxhijKjtFEhqBXc0Bcxzff1m+aDhsW+AlhCsaH88FjO1rd8F1EyKyyVcOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724653005; c=relaxed/simple;
	bh=nEv6tKjliSeL3sQ88lTzF0jw5RrU/d5YW6jLXlsAmKY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mw9ZDSXNp6jaTzA7uUej6KuqbQWLWAuBlwmhtOl0pwi1IcbQA4YWUFfJWpmi3qi7uQ5fjuTxx4LZa5M0oESM1+OET++Ce1/NANqZad2KqpQbq8Tq0r6NxGxiQRYtYHL6QJTL9KH+XRp/Qc4nRSPQ8R9E0MwTsW+nCtuRinN+m4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cWTQcW46; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=j8/9PVa7; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cWTQcW46";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="j8/9PVa7"
X-UUID: bf38758a637211ef8b96093e013ec31c-20240826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=nEv6tKjliSeL3sQ88lTzF0jw5RrU/d5YW6jLXlsAmKY=;
	b=cWTQcW46tWDZNmANS5ToYmpsdM2hebT0rMdoB6+fu8n+hu1etk+eVUnJrCviE/8Vz1vQYI4I0hKDRSLmg9GfjO9BoaxsrSHSwAHAkRAwTSJazV2AQ6wgtF4hqyfcRE+hbpN83iFlpPskxRKE7OLuqJN4uVMmopfciciuFd5bEso=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:f8b4fecd-b0e0-4f2c-a1ed-2fadd23b3922,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:67d5edbe-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: bf38758a637211ef8b96093e013ec31c-20240826
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 576908349; Mon, 26 Aug 2024 14:16:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 26 Aug 2024 14:16:34 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 26 Aug 2024 14:16:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gy/s3/qnOG4lcaQsFMYCWsNFFf2+jPSUUUXDYoRwgDCNjF28v9+3UNCBShWjFJ6Ist5ZQirdRQw3ZTiPBw3SIGuJK7oUkgie4tTZYc/SFrgw+C37r9PvbVccAsPjjL7IqE6gFkimHExeZ3/2wF18Ug93RuXtUHu3qZ3fkZN743dnJ2kI7BpJOXnhXaIQmWLAMDdwXebtg3TLFV+kDJ/3Su2vcamNOm+e+Rwga7xO5N5/qKm1+bfKhMBXiVGnCpFthEIt9mB5csv24RTKik9gmF9XXEYVA28A3zCjtXJxtuctO+7VMotK39u89Gd+EXyBt9vSeXavlMgUjibpqjXW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEv6tKjliSeL3sQ88lTzF0jw5RrU/d5YW6jLXlsAmKY=;
 b=sjcrFquV0hh+TtdYQ9JowpB4pPhsYvLRc8TzQCWIlfgUH9Q9gkQo3tMGKCkOl1QnSK5+8o7Oho7+kSgMIWMsfRLbVumq5GiMDf/TtnXK96zKRWLyprPAsnNX+dPiAXAwI/BBLuHnZJza9jnlkVNTN6UWnOIS7hVmL2IiN4J7VLXhR9g52QRkdjKkJW2lpAw9FdEdKnzqDYLVNN6xWFBRnQb/MxE+uq/h+5SB24fcIBkP+0YDb+85H4G+LO5iKack/yqRtjAm//irXUgZURXAR5kRUYxSV4/IXaYlTkBf03Vi+UXl1zJrGpbdo408+5sYFo774SOe1B71hsuvEC/sVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEv6tKjliSeL3sQ88lTzF0jw5RrU/d5YW6jLXlsAmKY=;
 b=j8/9PVa7asf7io6FK8rEHcXWDfdukFvmsloGNLL4UpVPIETpkLqxRgsCSKczkb6dKlhJKogt0vtLQ2iYf9tZNxKqJeSJuZvxnVKKzNG7TZySLOdArTMI/A+v1mhrbf1qAYww3dRd1WnarXkqOYoGOd8txCkrAEHIcbxbt3tj/FE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6728.apcprd03.prod.outlook.com (2603:1096:400:216::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Mon, 26 Aug
 2024 06:16:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 06:16:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "martin.petersen@oracle.com"
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
Thread-Index: AQHa8/g1O9xCFCXi4kKybU2KvbfJOrIz76mAgAAqm4CAAA4hgIABJXwAgAPJKoA=
Date: Mon, 26 Aug 2024 06:16:32 +0000
Message-ID: <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
	 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
	 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
	 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
In-Reply-To: <63b82e64-e968-4704-85b8-fad919994432@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6728:EE_
x-ms-office365-filtering-correlation-id: 9f4911ee-2db6-4129-2c07-08dcc596a162
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YXhGdFpmSzM3bkNUdEVDd0haaXI5ZHYyQUxBMTdMeDFhcWRiYlBRQWRLbExZ?=
 =?utf-8?B?cWdFbEdXOXl1TUcveFRrTGdrT2lscnBMMGpLWHpGZUNnZGhNQllteVdwRnhF?=
 =?utf-8?B?a29RZHNvMjJjeTVOKzVqazhYY2pxYXd3eDZOYml3elk2Y0luTGgvVk9XdHly?=
 =?utf-8?B?aDVOem1rTVp6NC9nYUZMWklmbnQ3TUxzZzVMMU1jYUd4czIrZVBuMnpZZytL?=
 =?utf-8?B?alg0cG9xdWV0UWlMc0ZoKzVGbzdDU2FiNzlzTWM4UThKeHV2TjBMVEN3MW45?=
 =?utf-8?B?Vzc4eTJVaUZjVEkyd1MxYUlRQmdNcTJJTU1OWmY4LzJHcWxpSkRzMGFtZlc0?=
 =?utf-8?B?ZFNFYjJnNkJSWEFnNVNEOVl1eVMyejU4cEUraTYyZXVmMW50OExucFZNWUJE?=
 =?utf-8?B?NjR5YXpLaHp3Q1RXTHNRdUtGeXNqNzE3MEYyVHA1aFo3S01BU0ptdnFKeHpu?=
 =?utf-8?B?UDd0KytLQ1RDNE9PdkNQMFhXNFV4YWk3bGNtOC90YWZ5eTRPOE5YNUk3YlFk?=
 =?utf-8?B?dkZ1Q0ppTGw1UlZaZ2FLVUQwb2xiWG1hamNlbzhIdnFUVmRHOFJEa2xiKzBu?=
 =?utf-8?B?WEFjVmVpSzdqdmFwbjB6LzJPYzJvaDhkNFNnb1U2STlkejZZVElQZmlkQ3J2?=
 =?utf-8?B?NGkzTnhMalROQXA4TXV5eGQwZWpiNnhPMVZkNHhROUhIS05WMmU2ckg4TVNt?=
 =?utf-8?B?bnRFM3R3NUNENGJSMWdGQXRGQ1ZVWXdWbGZIWUtBRTBJSzBmWml4d29lZnpz?=
 =?utf-8?B?UVBVYis2bkw2NVNKZ3Bkdzh5UmpBVFQ4bXBkakt0Uy9hQzlQUnRRMVp1SzU5?=
 =?utf-8?B?N25BREs3N1M2TGpCYWNENllBeko5M1UrY0xWdGVIbWNGTWxtUXlOWGE3b2FY?=
 =?utf-8?B?bTU4eSs2OXgveTVwRWNCUWI3UkE5NlYxZXBONGRQbXZyeTFmWkhNeXZUY3VC?=
 =?utf-8?B?NzdoQXVIUG9mWVh2NmlpTEF5WU93RDhLS2piOGM2YllucGlwUkFqOFUzZHZp?=
 =?utf-8?B?dG1nVmdtd2pheTV4QnVjVzQ4SWJEeUU5OWFweHlKbWxrMG9tbEhQd2krK3RH?=
 =?utf-8?B?Uk5ZR1d5ZEJKOFJ1K3BIUlVpQURKNkJ5a1lTQlJRRDFOUytsRGw4TXlucElj?=
 =?utf-8?B?dEc4dHZJUHNRN3VHZjNRNDJsOEZtQ0tLNG0vUURUY0dvLzJDbW04SkJTSUJk?=
 =?utf-8?B?TDl5VmlBTWlFSk5qS0dyNkd6cC9NRWwxUU9TMzl0YUpIK3hueVpUbHliVWln?=
 =?utf-8?B?WjJQY2NNQjlnOEV4T3k5QmREVE9DVTdOWWlVVi80UFNzVUNDQUZieGprZS9a?=
 =?utf-8?B?R3BQVzlMMGJBZXJlQkVWSnlyRm41ekxJZi9SczVMOXNsOFJRZ09jVE9FeDd0?=
 =?utf-8?B?b3lUYWpONzd1SnFZeFNwRTlXVDZETlRRcldZeUZncENGUTFOOHRvK0hJQ054?=
 =?utf-8?B?dEx2eDVEWDhjYWZ5Ty9jNlEwZHNGK2RLYVpaZCtaczV2bFcwbmJndVZYakp6?=
 =?utf-8?B?eVE4ZFNNM0xJRkNvMVRISXRRWklCVnlXMjdjOCtPc0RpdVBldVBLRjlHK3pH?=
 =?utf-8?B?NmN0TTFqQ2w5VVAvYzA5MVVVOEt0Y2NBRlhZMitPR01MQVdlY2gwTlNBaWVK?=
 =?utf-8?B?bWdSbkZCTE1waVl6MEZuWnJ0SGlBYi84MkUvN1QzeDdqV2xUR1JBVllJZDg1?=
 =?utf-8?B?ZjNpN3VyeExNZExmdHc5VWFmalM5YzFNcG5OcHo3VmxDK3dXMEp4czdHL1ow?=
 =?utf-8?B?TGNOcDgzWWl4Y0ZYUGRQdXdwNHdTaTA5V2lPZDFQUmJSQ2hTNm5sdEVlMlFC?=
 =?utf-8?B?SktIMXRSMkU1WFloL2NWOE9KZTVGZ2xjem9qREJzZk1WQVdkQXZFTWxZSmhs?=
 =?utf-8?B?K2dyRXYvMjZqMVBObk02Z2JrdFU4d1NQVXpVbGNyOUFuNVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGRmenNLem5mT1hrY1V5SG1TUG5hZTljWXBCNWZlaXpjaEFlTlk3bGJlK0cx?=
 =?utf-8?B?OHBGaGNTVnZrL2FpZEtsUE5KOHlYQUc3S2xpU0syME0yU1hPa3RyVWxYWnk5?=
 =?utf-8?B?MExSK3Nud1JzU1VPMlN5eUhOaFBLRnhsNmhtRXZGT3k1aGNZeG1HRkluUld4?=
 =?utf-8?B?cVQ5cnhrYWN0Q0RFQmdQcDdNZ0xuZkcyUWlBdFlrcTB5Z01vT1gwS3ppU3Qw?=
 =?utf-8?B?YmIvODRpUGpESm8zZGxHa0hLZDJPcE1YQkdvWFZQUW9qa29RQS9iUHVXek9Q?=
 =?utf-8?B?c1RlRDN6aXpxMVRuV0w4dEZtdjh0ZUxOV3phcGdZc0Y0R21UamVYWTVoeC9t?=
 =?utf-8?B?UkF2VzVUbDl5cUxTYXRyclN0ZTRDWEp3WDR2dndaWFVKU1JaYzhrWnBRSFhB?=
 =?utf-8?B?dHFrcUNQaHN4ZzBZV0JUbXhBbWJ0QXdNOGVvNGxWOHkvTnFaOW12eDdCTi9X?=
 =?utf-8?B?ZTBUcTBycjRhQ0t3Q2JpR1h4UURVOURLKzZqZHVGNnlUOFM0bXVwVkREU3NS?=
 =?utf-8?B?eTZmL2lKM1hIZXErTFFvV1BaMVMrU2tZeGczL1htNmlEYkdVTjlLUkxzaVNP?=
 =?utf-8?B?eHB6SHV0eUp6eXh6UGVqUkRFd3VxcWlSNmJ3MkxrYndCYVJRaGRuQUxFYVBR?=
 =?utf-8?B?Qk5GRVc4eGhiYjJFZXhYQUZ6R08zcE4vRlB0WndtOXQ5d0cyR0JMQ3dpd0hI?=
 =?utf-8?B?ZXhaQUtqK0dTZTVUcEJ1a3ZBTFJBd1lPdkNteG9EK0hSYzBra05KSWtCL08y?=
 =?utf-8?B?ekNvRnJWZjR1ZnU2VVJqRDl6YUdtNUM2MWN4Q2V5bEl2Qm9abTBOSVlkVmkr?=
 =?utf-8?B?b2ZJRmFxbS9xb3V1YzFOa1pMMmUwVUloSjk3MjNRSkNqUFlOejZMNE4wQzJy?=
 =?utf-8?B?OUYvbW00dmx2RWoxZDJhL2o2WFB3bzN1bWt2YndtSENJMGxnMW1jZy91YUJJ?=
 =?utf-8?B?YVhGdTM5WmRXQWFPbGFSWXF1bEMzRDIyQzZ3c3NkajhxTXdlbGd0VERPTnY1?=
 =?utf-8?B?N25SQnVlWkdqemtGVjNHblZtcFZ6UURyZ3k0T1J6V2MxNW9RS0R0SEhmSXVj?=
 =?utf-8?B?NEZVUjhkSEJJc0lyT3hISWFYOXNEbFVrczhWQzYreWhwdGU4d0toSDJoMEMz?=
 =?utf-8?B?ZmI1eXdjeXlQRExXRjhTODRweFlVQnlYaHh5aXhiWGpIcU5CSjdnUWswN2Jw?=
 =?utf-8?B?ajRWVzkxZUxnVlJrSnYxYnEyZTd4amNsMlZVcEZpTUt6aE1vVUJpV1hJM0Nr?=
 =?utf-8?B?cmtNZ3RuajRtdnFzaiszVnY2SjVIdlB2MWU1Y21XN2dscllvWVY2SGJMS2dz?=
 =?utf-8?B?cWozTmNVVFF5MzVJWGJtQ0MxTUlaS3lLVDQrSDBETDg3MUowZ1RtTGRkTHN6?=
 =?utf-8?B?N3ZhdmtUdElFdEdqa005QXBwTk1BZkFiVTBweUtuQ0pucTlTSGlrMDMybjdz?=
 =?utf-8?B?dmZkT1poRFBpNnk3dHhIQW1JTmljNW5CenJYQkNMVWhEWG5HTFhqZC8xRGJW?=
 =?utf-8?B?WVNJRjB2eWtLc1ByWkVnR3FWVVdKOG1ZSlVqQU9YbWs3eFNRWTh6d0lvZFZM?=
 =?utf-8?B?QW80QmQvdUpmRDNEVGQzY290Nlg2bWNRc0VWZGo1aHVLNk1vT0J1T1R4c0Rq?=
 =?utf-8?B?bDdsWW5NNEFDQThvQWhsMDd1WU5YSnd0dXVjc0NOdjVaeXJwTjcySUtEMitj?=
 =?utf-8?B?NlJZQ1ZjMHdkOGNQV1E4SkQzTWpEa3FMZC9TbGcwbnVxUDRmVUhwSEIvYzRV?=
 =?utf-8?B?TEwzNzVIaEo2cjlnb3Z6OUJKeVdlblNyRDd4V2U0ZzdPbW5QdWV1VmtYTUww?=
 =?utf-8?B?c0JhRUxraE5tOVo3SzdaZEtVUlIzTmVhOGpwRjRqai9OMjN5alRhS3JJVGha?=
 =?utf-8?B?a1BDSStCWkhsdE5mb0RrK0RSWW91OENPTkgxZDYvYkxRUDhPMXJIbGpkTjNE?=
 =?utf-8?B?QTVrWEJ3eUF2MW1MZEcrUUQzVFdsZXJQbVZ0Q0thTXhXamRGUFpTcUZxVzN1?=
 =?utf-8?B?L1RQNE9scWhqaVFyVUhiUzFXVVZFSm5mWFc1bjgvOUN4MURySE9DOVBrUkx3?=
 =?utf-8?B?a3V0TFI2cnFadWRTTEhoRSt5eFhZT1NZTlhGaTlrTXE5NExoZXNRS3BxQjZu?=
 =?utf-8?B?ZW11UzUxVjF6R3VXV0FObWlGekh0TG5mU1Z4b2IxaStrVUJ4SWlZR3RDeEFR?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4803AEABFB240F48953B62BE0628B4A6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4911ee-2db6-4129-2c07-08dcc596a162
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 06:16:32.2720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VAr5E0vnWCbmvoCmS9d5NJlUFF5pa3gwQcGYr7/DLjCOkT+dl4fTgMmeKdD27g556HzIqMm6c/1keH5ClzjupQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6728
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--21.345000-8.000000
X-TMASE-MatchedRID: 3FtKTYP2XG7UL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTXJS
	YlpHrkP0EeJteF7n1P2/vVdPVXCD663DIQZqenqbDr0AjBcmfRp7wR6/2hZzOuCF0N8/HZ2oNir
	voD95MYuiHrJq2GAwgApngpJ8wKuPcx97ZZVZcMrbQFsbjObJeKx5ICGp/WtEpWd1BiMZbbTP7O
	SqW2R7sZzoS/HbvlJ3JaPip7F3g4wEzlKcqjzGcdXz3l78F3YmX0RsAdZZVkpsoi2XrUn/J+ZL5
	o+vRV7xJeFvFlVDkf/cUt5lc1lLgZON9R+uSfQA=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--21.345000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	E139DE42D41C5CD8FE86B98982F484B614169CDC4711DF76E7B57CAF5410BF1F2000:8
X-MTK: N

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDEzOjI3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yMi8yNCA3OjU3IFBNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IFlvdSBhc3N1bWUgdGhhdCB0aGUgZm9sbG93aW5nIHN0ZXBzIGFyZSBl
eGVjdXRlZCBpbiBzZXF1ZW5jZS4NCj4gPiAoVGhlcmVhZCBBKSBzZW5kIHVmc2hjZF91aWNfcHdy
X2N0cmwNCj4gPiAoSVNSKSBVSUNfUE9XRVJfTU9ERSBBDQo+ID4gY2xlYXIgaGFiLT5hY3RpdmVf
dWljX2NtZA0KPiA+IChJU1IpIFVJQ19DT01NQU5EX0NPTVBMIEEgKHN0ZXAgQSkNCj4gPiBkbyBu
b3RoaW5nDQo+ID4gKFRocmVhZCBCKSB1ZnNoY2Rfc2VuZF91aWNfY21kIHNldCBoYWItPmFjdGl2
ZV91aWNfY21kIChzdGVwIEIpDQo+ID4gKElTUikgVUlDX0NPTU1BTkRfQ09NUEwgQg0KPiA+IGNv
bXBsdGUgdGhyZWFkIEIncyBjbWQNCj4gPiANCj4gPiBCdXQgYWN0dWFsbHkgc3RlcCBBIElTUiBt
YXkgY29tZSBhZnRlciBzdGVwIEIgYW5kIGNhdXNlIGVycm9yLg0KPiA+IA0KPiA+IChUaGVyZWFk
IEEpIHNlbmQgdWZzaGNkX3VpY19wd3JfY3RybA0KPiA+IChJU1IpIFVJQ19QT1dFUl9NT0RFIEEN
Cj4gPiBjbGVhciBoYWItPmFjdGl2ZV91aWNfY21kDQo+ID4gKFRocmVhZCBCKSB1ZnNoY2Rfc2Vu
ZF91aWNfY21kIHNldCBoYWItPmFjdGl2ZV91aWNfY21kIChzdGVwIEIpDQo+ID4gKElTUikgVUlD
X0NPTU1BTkRfQ09NUEwgQSAoc3RlcCBBKQ0KPiA+IGNvbXBsZXRlIFRocmVhZCBBIGNtZA0KPiAN
Cj4gSGkgUGV0ZXIsDQo+IA0KPiBDYW4geW91IHBsZWFzZSB0YWtlIGEgbG9vayBhdCB0aGUgZml4
IEkgcHJvcG9zZWQgaW4gbXkgcmVwbHkgdG8gQmFvPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFy
dC4NCj4gDQoNCkhpIEJhcnQsDQoNCkluIHRoaXMgY2FzZSwgSSBzdWdnZXN0IHVzZSBhIHZlbmRv
ciBob29rcyB1ZnNoY2Rfdm9wc19oaWJlcm44X25vdGlmeS4NCldoZW4gaGliZXJuYXRlIGVudGVy
IHByZS1jaGFuZ2UsIGRpc2FibGUgVUlDX0NPTU1BTkRfQ09NUEwgaW50ZXJydXB0DQp0byBwcmV2
ZW50IGVuYWJsZSBVSUNfQ09NTUFORF9DT01QTCBhZnRlciBoaWJlcm5hdGUgZW50ZXIuDQpXaGVu
IGhpYmVybmF0ZSBleGl0IHBvc3QtY2hhbmdlLCBlbmFibGUgVUlDX0NPTU1BTkRfQ09NUEwgaW50
ZXJydXB0Lg0KDQpJZiBpdCB3b3JrcywgaXQgd29uJ3QgbW9kaWZ5IHRoZSBuYXRpdmUga2VybmVs
IGNvZGUsIG5vciB3aWxsIGl0DQpyZXF1aXJlIGFkZGluZyBhIHF1aXJrLiBJdCB3b3VsZCBzaW1w
bHkgdXNlIGEgdmVuZG9yIGhvb2sgYXMgYSANCndvcmthcm91bmQsIHdpdGhvdXQgdmlvbGF0aW5n
IEdLSSwgcmlnaHQ/DQoNClRoYW5rcw0KUGV0ZXINCg0K
