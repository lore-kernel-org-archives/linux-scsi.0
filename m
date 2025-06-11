Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0CE25F965
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 10:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749637396; cv=fail; b=jR/XCtj8CS6xyEjgkijdSa8d+Ifla3mFfP5YJS+n7Nstnr7IdCzFPWXrHzVQnMC7xPee2sSWjLeQPIfLzPu5KpVBN54SbiBzhMqSu+9vmU5QwflnWzJqA8LLHgR3kCcz5MctI9ilJdajcqsEnBcqeopyzjrWxaizYOkeV76oq0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749637396; c=relaxed/simple;
	bh=0cyW2cp7VUx7nkdzaGqWCImh3p/00TsJi34kGa15WaQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PE0TWZQ9d5o4P2FmegyE6aHIdY7BeXSIbY7J9iFPGJ/Tlomp1UtPGVQydExFLD8zdSp9HdcfH5nWvJsBUYVk7tUMB90yTfJEguvyWqz8dozovAiXRyILSNkBMBYz0Z/ZEEWhJS/NgF8rddpP5CXIK9kG0fbh17dS2Lj/K1Igj7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=V2vSb1Tf; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=q5pzVTuq; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V2vSb1Tf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="q5pzVTuq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749637395; x=1781173395;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=0cyW2cp7VUx7nkdzaGqWCImh3p/00TsJi34kGa15WaQ=;
  b=V2vSb1Tf6s0aVLaezH6MKzxzx5fsbeMf1fIY+wRgKmc+epZCtXscMzyf
   CVs6/3T65D820q6H1uRqmAhLYH7lUxxzl/0PZ/prkSPTDaj68KZvJ118J
   jt1Cit1eTyP9Ylz4i33rQbBHcJe6kqX50Kgk/bn99XaR6TkYMUq46AUZ2
   1rPgdDTlXpjaerDogMMqHLmZ15jY84tIvum6Ww0uFqvM05X+UzoDu+be4
   shmFVuIiwO9e9f4u36lYUKYVD8YGi5CWDC08xLbU80k19GW3h3rHT7LdW
   k8ghnnpnOeo7iYJbjb7KgJ5zbIDX3BxqObunonFV4m6klrHcPJW2MFP2v
   w==;
X-CSE-ConnectionGUID: qY1ZQTKXTD+2GgQE8NirFw==
X-CSE-MsgGUID: pQT+6h5YSEiIKwywtma46Q==
X-IronPort-AV: E=Sophos;i="6.16,227,1744041600"; 
   d="scan'208";a="86381348"
Received: from mail-westcentralusazon11012014.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.200.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jun 2025 18:23:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+19hxs50Vmm/y7y9DZuCEKPwFnlYUamU7xPwrxl6rvtixhXITEwOjL/tKfBrwevZ11/5m8657gOnXBKQiFzNladdCHXe1Gdexw4ubfg9b9zXezkLrMbylb8Hft/PmGksvV9E68FiiFJPjChKDZSx6nikqKMOabFEiddfcE7maynP43MJw9gdj94APFtJM7dxfgxfKkE+khu6kguLLvkD0jTm+0vCkBnnPfIbVg2Syq3+HiK0IhlK8HFAA5Pt4tr+2A5SNYq8Gcqf7FXqVgzHJGmXCFxwGtpGYLhEiLmuWQiIqJRtio/etD7HCviAyufo/BcITD2qFvc33LlURtZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cyW2cp7VUx7nkdzaGqWCImh3p/00TsJi34kGa15WaQ=;
 b=m9J/5UAi8oEB/cN1LvuzbsJ/LL3o8vTYFG6ydlh2VoWXVOIOCXn7JsF92Waxqfdzx8gwvoxxNZ9kO6Vv4U9QREdoGzUoah9wauK7EsjEQQ4k9fVToCWSnfMmpmBarZtMavvcbpg9kM2MOrk125rQGyRlsw48DC+XMAX5N1f69yGGnNaI6Ztq1zzBo3EpolthYvD+C0ZR9d2nMvQVRg1ehNgiKmvFyKiErkbnphGsfsz0gLg7bwyn1MGL8W0phb74OR8q1uNbSNpGL3lpfkFxVrRzTIt1SnYPBiTYkzEglwQtaROAuOEl9u0zDKxqfiv5Pz8Eyu+TKUrKhCNu/rzH7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cyW2cp7VUx7nkdzaGqWCImh3p/00TsJi34kGa15WaQ=;
 b=q5pzVTuqSxaEgZAtTt4YbTblDBXhNavJ72noQ+E8oguo+TVteuvcjPvv519IVH6rMcJneRI/+HmDV2ZRKcsohhWbjDSClPIuI39fxrxbthxp9d+on8H1gvsG/ulr4wiqXDc1FbH+baly1PNCapkcnLxdw1dpjXXZTQSGCwTzOcI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7792.namprd04.prod.outlook.com (2603:10b6:a03:3b8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 11 Jun
 2025 10:23:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%6]) with mapi id 15.20.8792.039; Wed, 11 Jun 2025
 10:23:10 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: Set a default optimal IO size if one is not
 defined
Thread-Topic: [PATCH] scsi: sd: Set a default optimal IO size if one is not
 defined
Thread-Index: AQHb2qSNZqJBK0h2J0ibkknGOu+sP7P9wF8A
Date: Wed, 11 Jun 2025 10:23:10 +0000
Message-ID: <cac8143b-f321-46e3-b164-7ee6f5b1c88b@wdc.com>
References: <20250611073905.2173785-1-dlemoal@kernel.org>
In-Reply-To: <20250611073905.2173785-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7792:EE_
x-ms-office365-filtering-correlation-id: df2e5c0e-6c76-41fe-ae91-08dda8d1f74d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YnlEMXpxc0xnVXpoblhHT0xkcE43UVpadEZhUS95ZC92eTZMaElOMTVyTURW?=
 =?utf-8?B?S3lSS2kyMmp1R0hsZlBXTzAxRUZudUxYcWk1RGpjT0oxUXp2VWdZVitGRFQv?=
 =?utf-8?B?MlNDdndOamk2OFhIMjdoUlV5S0tJUzhWL1NFZkdqSTNPVE56enZ4MDYvbjJv?=
 =?utf-8?B?M3l2VVpZYkFSRG11Yjkvbmlpd0dpUS9OMTNNQzhhWUVsTmR5MUNyR1puOHBH?=
 =?utf-8?B?WThRRHFJNXV4QTNCZnQ0Z1htQWNJMXpPbTRnWjFtOWYrZkp1K3dQdW1aamlz?=
 =?utf-8?B?cXBtRlkwZk5xNEhEQlE0K2RqRXZ6QUg0c2xudW50K0plYkdSeklCTTRyRStW?=
 =?utf-8?B?WkplK3B4THlEUEZNa25VbEt3d0krbkFoSnA5TSs4eDRNd1VYei9CR0xRS0dn?=
 =?utf-8?B?b3UrMWhhVHdqbElxNit5SXZIZ1BKN0FoMkFMbWVSbVkweEFNWnlOS1VDSC9r?=
 =?utf-8?B?SFJTUld4THQ4QjlpTXRWOU1xWnhDL0VCVjhhbExTcmk1S0N4aFpvSWN2c3o5?=
 =?utf-8?B?Y1NJUWh3bzZoSk1GMVhQQ0FIcGhrNExweEN1SDJEcTd2SnM4TGZkWDR4NHAw?=
 =?utf-8?B?WVRiUkNuUjBmWm1qUS9VaFBQZTgvWm16YmtBOFBtRG5QVVhXb1V6cGpUYTMv?=
 =?utf-8?B?aDFHcFlHc25GY2FVUCtEdjI4YzIwVnlQcVl6cnQ0bVQrT2g1NmlnYnpQUE9H?=
 =?utf-8?B?WEFaZGFWUkxyQWMyL0hDbmVtcDZMU2tZMEFqMEJOUnR0V2x1T204bFBRVHRz?=
 =?utf-8?B?VVB0QmtSdy9OWU05bS9ZRHMwUUZiNE9USDBQT2xGMVZiNmNiUDRTU3VjenQv?=
 =?utf-8?B?Q0hrOE5PbHU5eThuWFVRaEdGbndaWGJRNGVZdmNJNHZzTWtNWU1rQzN4MnVs?=
 =?utf-8?B?RmNTRFc1OVJRVGRlMVBPeTJYNEhFM1h0dFBqYzZSaHZMM0lZZHpaV2EzTlYz?=
 =?utf-8?B?bHJURHByMDVLcWxSSTltYTBxaWhSSEhocW1URDlNTm9uQTBEa3d3ZVYrdE5Z?=
 =?utf-8?B?VC9uaEg5ZHpyLy9CbjBTYlZpUkVjVWVjcStpSHQrSE5jV25abVVERlNSTk9H?=
 =?utf-8?B?VEdZaE05UjV6bmVTZk1haFlIczlQZlRGVC92Y0J5cmVzWm1wbm5CbVBqU3FG?=
 =?utf-8?B?WW52eTJueW9EcitpdFgrb3c4TE02Mm4raElUT293YmJDOGk5Qy84azNFbHB4?=
 =?utf-8?B?MWRLT0o3bnZTRkw5NHl0eEZDRVBENHMwRWIyRkhvaklLSlJNeWlrbW5sMzFw?=
 =?utf-8?B?YkgyM0V5ci9TNTh6QjBIcFR1eXB2QVp0U2ZyZ2NNQVl3aXVzaVR0NGFKeTJN?=
 =?utf-8?B?Y2c4ZUdqVmRycmhsTXZnR0JIUll3MTBhZnRFWUIyQ2p2UW9MTDB5NFN4dGly?=
 =?utf-8?B?S3dnN1JZZmx0ZnlzQnJVdmE4TzZXZnRqcnBWcjV3WXEwK1FyeXNmMzg3MmtY?=
 =?utf-8?B?Q1lveXByWW1PWkJ3NUZQYU8zT3Z3aGN6WHlFeTlsRm85SDZnc0ovcSs1a3Rs?=
 =?utf-8?B?SmZUKy9WOTZmKzJENUVXWkc2ajdHbGpQVkJwSDJBMDZORTNma21wYjkwcGFz?=
 =?utf-8?B?Y1pWV3FJQ2JIc2RMVmdCV3FDb05ES1g0YW1FUkdGT2tETVR1ZWZWaWV6UFpw?=
 =?utf-8?B?RGJ2Y1IwanlMN0pLYjhhQXUzMkZwWVd1eEZORHBUZTl6VVdLNDQyRjNXVjVx?=
 =?utf-8?B?QlRXa2dsQ1MrczNyK1UwYjlzSDIyZGx2UkttT1JNeldQYnc4czhmTWx6RmZx?=
 =?utf-8?B?UWwraVF3b1E1QS9TTHFFNDkrYWxkTnlpdmFMalRXcytoUzJING1EMzhQSm04?=
 =?utf-8?B?TzNiNWJHN21hVVVJb0JqZm1SRHhSSE4vb1FSdHN2akE5VzA5YjNWdC91ZVB0?=
 =?utf-8?B?bTQxcjVYWTVQUmpNWno4UDdidjhvdFpidlpORWZEZlRlWmM2NklOUmRjc2pN?=
 =?utf-8?B?WGlpTnJqeVYyU1M3N2hZNG1vaWVqa2crUUlxeHJ2K1ZKbzEwZVl3TmRCcDZy?=
 =?utf-8?Q?OrQHGnMLTyZ35HiCvGWWCgZG4Uh0zs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NWVwMTJQNXA2aHpFeHAvZVZWVEZFVlJlV2U3L3VpcGtucU5uQU5CZXB6Y1B4?=
 =?utf-8?B?RVE4dlI3U1B3QUlLY3REZkxFU2RCV0hzVmxHSUN4dStEbzlxdCtaUlZuaGFG?=
 =?utf-8?B?K25NS2tzUFllL3ZOc3NUQXI5L3AvYlBaUjdXc3VDNWZZbmh4ZmR0bkFMdER4?=
 =?utf-8?B?VExZN3h6TWZMWFhyVDZBNEZOb2tJZ21qYWZFbHRYZEMvV2Y4RytBVjZuZlFC?=
 =?utf-8?B?SFhXcVR5dnRHcDlwZkkwcTIrZ0VaeXR6czI2czFDS0tyeldPdXQzTkpac1N1?=
 =?utf-8?B?YmtpbENQOTg3MllUdGx6alhNWnIraFJuNjh6Nm1kbnArSzJNSUoxbmEyODZF?=
 =?utf-8?B?dys5NXQxMjRCbnFBNGxIZ3doNzFpd2ZVV3ZjT3JKOXBQejVjNDdEd1BJYW15?=
 =?utf-8?B?a0VnUjRzc2F2dWF4cGM0aGd3ZEY1SGVrdi9uZUptVmJQZm1wek9sc0VnRzBq?=
 =?utf-8?B?dmhmOWRLYkcxdWxob1Mwa3ZQZFpWZlNlKzlFQTRsVDhZWnVnS29pZ1c2K1hw?=
 =?utf-8?B?UVZvVVFuazRFZnk1Z1BnMm8vV3pRVUUrRzdUWVp6eXRnNDV3TVBLRnVxc2cv?=
 =?utf-8?B?R3hUcnBzS3Q3MU4ybkpEY1BERjRlOWtlV0tCOFhERHJ3R2lSazU2bGtWY1c2?=
 =?utf-8?B?K294RmJtd3pWdFF2ck43cllGTUZ4bW9RMmxDcjlmUTJoeWIxazloaGprU1lO?=
 =?utf-8?B?L1Q5TWxla2tObkZoNFFkRWQ4QjRXRFFRMmdPOHFqNGhETDRVei9EYnlEWGpL?=
 =?utf-8?B?RFc4WDE4bkNGUWkwd1h0eGRhTnRUa0Z4ZzUxRDB2bE44M2VXcWxTQWtzMlpy?=
 =?utf-8?B?cTFEb1hwc2lhNFFtZmJrZlVBdUlXRTYxeHdtaE4yekFOREd6akRWV3MyM0xh?=
 =?utf-8?B?VWJoR3ZWUkpVZXBFNnQ3bTR0OXRDQXg4NTB3Z05kcTA0Zk4zZnlvR3BWdmx4?=
 =?utf-8?B?SHJDaStQN1FSVElESVdnZktPcW5waDJwVUdUUzhyMVNYdmVrUUtCOHpBWWFp?=
 =?utf-8?B?amZydmVlSTZOT1V6emI0cmYvTnQ5NTBwVlpsTVh4dU9BT1kvVGUyeTZEa0t0?=
 =?utf-8?B?UFlRdGZkV0hNclNtUVFqSFgyV2Rya2VjemNGVnhwa0FXWTUzRERNeml1QzhP?=
 =?utf-8?B?VnFGUk9PZHdoc0hSdTdOZWVxSzlvVzJ1a3JLdWlpbEpyVG5NYzlkVUt6TWtP?=
 =?utf-8?B?QW5CZGs4RnZSd0tZSlFkOFhPTDJFOTZHVGFFcDVWSzJxSjdxeCt3cDA3eVox?=
 =?utf-8?B?a1RUbHlSTGlpU1dFWllxTUdYZlNmcXkvL1cvL1RJUHg0dEVhaDlGc3pTTldn?=
 =?utf-8?B?L3Z2azJrUCtGZlhObXRaNDFmS3g2SWF4TTdJZ1lZNzNtMVJQaFdOY0FsaFda?=
 =?utf-8?B?Y3RqcnpJRVhsT0FEWFl6L0RzVUhCUGM0WVJka1FGRU9HVWJtVVRqZFFmY0RJ?=
 =?utf-8?B?UkJuSVFXRmxqODZQTHdZaEdETFoxODBFRmJsN1NaVnZyWmViVU5FOCt4UnpE?=
 =?utf-8?B?d0ZWMFc5NHFXTlRVV2Mvc21vR1VRM2xRS2E5TmFnUkdVL2tTSkFIdzRqS0Zs?=
 =?utf-8?B?WlpZZjNRc1QzMGptOXNLRlhRODZEV1pReXZwbmdkSEI1anFoUkkxSG5mc29I?=
 =?utf-8?B?Ny9uM09WczJQNGd5ZGlrUXl5OTFHMGlkYVE5aEtabXl4WC9LajhmSkltUlBI?=
 =?utf-8?B?U2ZuM21tdzRrTlB3NzZnYmUyeXg3dHR4L0J5R1phU3J1SGs3Y2lZVk5hSk9w?=
 =?utf-8?B?QmtZTThYcGZNUmtLbVZSS3J6dTlNMDZNSXJEQ2gyakNhT1hxdTdiZTNoTUZy?=
 =?utf-8?B?YTZTUmUvN0dCQTYrVndIak16ZWd1WnZlb0ZWWlMvTFRzNmtmL1dQbGg3U3lM?=
 =?utf-8?B?dmg0UzhONUJyc0NRR1NENDdUNm9Bam1SNWJJL3BpTzZhZGdBUyt2WTZZbkpJ?=
 =?utf-8?B?WngrMjFPZDJjZ0hFdVgrR0NNeG1hejBrRFBxVGhHbXV0QnUzSGI0T0hmMGps?=
 =?utf-8?B?OWFwM0dxbkhyTWdOelFlanB4WTVPc2Z4QUorY0xjNGJlWmtGTzRXd0RhZnk3?=
 =?utf-8?B?UTlWQzgwVHpQUUVnLzhUNHlmNFRwTnZSY29tTkx3R2hjUGJWV1IyWWFEaHd5?=
 =?utf-8?B?a29UVU84T0ZiTFZ3YXRZb3JsTTQ2dS9TeWhoVVZtUTNRQTJFRkhsbTl2MEhG?=
 =?utf-8?B?L3djWkdvamF5eERiekpZZlBiM2h3ZEJVK3lIL1VxNmZwaWYxMDA2U0xSMGIx?=
 =?utf-8?B?VXFyMzFiRGNXZFducUhObXpCYUh3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8D52E5ECBA0C6428EF47363F7DD215B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	83ANmjdHN8pzIqGS5KidWUZ1NRmOEDvtcE0ZHCeWgW5NUtBViwKaEJc9JZv25oYYhbZJmE6knDWOtrx5avto0eWO3cKY0kxav1QoloRNNLc+2Mr6o0uoPXqKlXONwgUi67HIG+aMhnryRJjNTi9UICFZyc0Q3FXEvtqIlHQPfB73/8864PPby1CkLfCOeq/QBMlQhiU2xP64s47GNWnKvqZjLVKP8SCA50j5TBQivA+JYU6aY/j0WYfeaBXmFzrLPdZfjpx7OLy8Kq60tTFoyAkMpcJTgE+3/33R4AZCjvKd0RKPYzl5kY6C4ZeFh3+Vl+5Qfv0TFrSFSzNOzjq/b5E1+2d74p3lWR2OWchcQPLOxTbPBbLtNy17faFblMlotpx5JKw+UzsvjzziRKcetZQ1QDkpWfaiubxqfGy/N2Zt7O5qm/Jy+pgMrZsTqyOLjICCotRpEogc6Sk4WuT4QHGKqBv2Sep0/emXHNT+XXmAKJA/tyzp4o8A/a5H1k8DTNBbAM6Fxp+V7Jhl8LOOwCuDJDS3O+HsiHK9dY0ic/+9yhlOjbKLBN9XYgPfOYotFPNDrjwBBZ6aBDUZLnaUU32zYrYyxk1i/w51z96PRPsLn5ibryyJAqL1/4F56d6m
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2e5c0e-6c76-41fe-ae91-08dda8d1f74d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 10:23:10.7021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XnRYc4LVQsuaWTmBJex/m6NVlUi+cU1doEKA6vJWTyQWqAY8g6jRNHacXzVjCQ4fdcd35BIbenthHMQcXYEGBWgOvrC9ssZWX1W7zoGhEVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7792

T24gMTEuMDYuMjUgMDk6NDMsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiArCWlmICghbGltLT5p
b19vcHQpIHsNCj4gKwkJbGltLT5pb19vcHQgPSBBTElHTl9ET1dOKGxpbS0+bWF4X3NlY3RvcnMg
PDwgU0VDVE9SX1NISUZULA0KPiArCQkJCQkgc2RrcC0+cGh5c2ljYWxfYmxvY2tfc2l6ZSAtIDEp
Ow0KPiArCQlzZF9maXJzdF9wcmludGsoS0VSTl9XQVJOSU5HLCBzZGtwLA0KPiArCQkJIlVzaW5n
IGRlZmF1bHQgb3B0aW1hbCB0cmFuc2ZlciBzaXplIG9mICV1IGJ5dGVzXG4iLA0KPiArCQkJbGlt
LT5pb19vcHQpOw0KDQpJcyB3YXJuaW5nIHJlYWxseSBhIGdvb2QgbG9nZ2luZyBsZXZlbCBoZXJl
PyBUaGVyZSBub3cgd2lsbCBiZSBhIHdhcm5pbmcgDQpmb3IgZXZlcnkgQVRBIGRldmljZSBpbiB0
aGUgc3lzdGVtLg0KDQpJJ2QgbG93ZXIgaXQgdG8gaW5mby4NCg0KT3RoZXJ3aXNlLA0KUmV2aWV3
ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQo=
