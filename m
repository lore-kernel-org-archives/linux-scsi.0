Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17191FFC55;
	Mon,  3 Feb 2025 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738601419; cv=fail; b=kWhaWSkWONbCRWt6sVOIpsPlJwcIt13hGNp9IJgqI4/BA3D8hwiyjoNMK2SzTjj/rtMpYoSay5g4tbw4lADbcw4V0fYrgleirNccI1ICqn3N8SEGGp3DgaaTHtLYY9ZUxYTnsShpXkoP5Cc96+YUUG1XmXc8bncpbgPdzSlXrJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738601419; c=relaxed/simple;
	bh=v1HIKnyAkCC/BUowI6at7p4LV4Ti5FD0wUU3JFMuua4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GjpZ0XcBYvUN4K06ke1w27Z+8eMgnaTQw1O4UyL0WZTWM5mwXxUarT2UG3G9IJDTS+wEM+ILVfArrO+Hk9LbPcPzeorBBU3KChT3IQ4EdGZ/jc7H+XrdeSUts87D1XxP6sFpGMcE13pGe+X/twfqW/AISjZRQ1jqP73Df178nbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QVSgTKPS; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QVSgTKPS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k79QEiaZrfgavEU+DucuasqmwA6tHx+/W5WfivZXIZxb/rJpiO9DIKEy5BBxgxtL+5h3rv0yaPiKKkppozTYBaTkD5stoVYcw0v1/i+qxSsSac5fTYum7PqQOms8n335nIfB2JIfCx0fgEqUYe1drnUBXMr8AK6UPPkRynUPaVzWPmWc7lxtFDbFwGpNF4AWYWhhay62L9EpacdTc2riPsWRhvBUqPToMdgOk9POoe+/9OYtSXj1aB/gE8eq3cOJ4Nc8zpOZrk+1MQvV08KsMfh3b/jopf5mNjiOUiY7eGllqdxMvJvS6kB2EMuqTql3DpdATRINRdYpTM/Ry/3YJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1HIKnyAkCC/BUowI6at7p4LV4Ti5FD0wUU3JFMuua4=;
 b=ZPlvUwvmehsPS/yxjqg7To3B7co0VKnVBdpc/5xV6xs5DAny4Qr5BFzSEztMpq82wIVIzHuO8sYsk7M/iDTkuBGgG5h3sg34pwjyOE1J8fpN/BaUrUwT8I2/afZYEiYtYDeSCmQPtvA48anbNemzrx45xZbTL9JuJ2Y3jWSkS0ZqzZvJK3CZ4NR3SYbh9xhAtno5NGQ7WtvdLGybDEUBxUCSCX60lxmVfOv3Qf8S5i+7e6swksUGuJXNWhFtLkjqMdrqNRg9nJFzADR6S3Xd0BVQZEvu3pkxeilP6TroDnamfk8j0fQ21+H5J4P9OAza5ra3TEODg9Vf/sPirv5EQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1HIKnyAkCC/BUowI6at7p4LV4Ti5FD0wUU3JFMuua4=;
 b=QVSgTKPSE2Cc0RIuMyAHxC7uYt9OJwnCxEfj6L8zgIzWBEZ95UohlRcXlvYC5X9YU2FRKYec4TG/1GxnKc2FcTAS2/hK3DOODnjtIIFuTmw0LyhoJQEGs+dqWFzTkK7CrBp2xDrOVdNQ4vlOOorev6l5W2YFpJNVTNotcrRXkFmVJ9MgAJSTPpkqHn9qp2E4ykDwqNFR8GbltZYhmCW6tzZWG1N+LqUGyz6OsyFAufcn4hft9LKse7aOJm9u/yLVP/fQoYlZ3EmAGzFHFA3z6iJo+C/PcpSNmYabiRBdSe14L0h99Ofde+b8ZPaB33Y5Wr1y6I3WmZUpbTiSclsUCw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MN0PR12MB5738.namprd12.prod.outlook.com (2603:10b6:208:371::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Mon, 3 Feb
 2025 16:50:14 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8398.021; Mon, 3 Feb 2025
 16:50:14 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: remove blk_rq_bio_prep
Thread-Topic: [PATCH 2/2] block: remove blk_rq_bio_prep
Thread-Index: AQHbXbH0yd7lRdyrgE6IHKuUS7H32LM1/AAA
Date: Mon, 3 Feb 2025 16:50:14 +0000
Message-ID: <bd17602e-cb39-461c-8e89-6637c54c3a38@nvidia.com>
References: <20250103073417.459715-1-hch@lst.de>
 <20250103073417.459715-3-hch@lst.de>
In-Reply-To: <20250103073417.459715-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MN0PR12MB5738:EE_
x-ms-office365-filtering-correlation-id: 1b6b7af7-aa8c-40d8-0d19-08dd4472d4e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d1prZEpXSUlxYnhhU1NDVUZXSTMwYW5YenI0eWFING0wbU5aSUFFZktTSkNW?=
 =?utf-8?B?eG9zbkl4aFpDWmhUTUhtRjJvL1ZXNGFEQWtjWUduYWdQYkZ6dmhFdUNVaWRj?=
 =?utf-8?B?RVBNcVFCUVg3cFNjeTVJZ1l6c1FML1YwVkt3dVd0cDdOV0ovOEd6V05RN0sr?=
 =?utf-8?B?bXZ2VlNrc3ZJRDU5ZHRnZzJNU3l2eVNSRGJlRVhYaDlkcndTQjNGc2RKZWhP?=
 =?utf-8?B?UW41TlRRVkh5bEZ3RkRUT2pSNmtwWHpPb0RZUGVsbVJudlpUNzRBZTVmbXZk?=
 =?utf-8?B?VTZsaHVUUmdqQ1ZudEhRdThsZnJja25YbFlLdEFsMUwyZWlROTNpVEF6NlJL?=
 =?utf-8?B?VEd4dnhRRUJ5aTY4ZCtlVlYvK0QxekdxN3FhVWRFOGNxaEZzZlhFVHByZlho?=
 =?utf-8?B?MlZZQUM5MHhkTUVFb3R6LzY1ejhkMkNDazdvTWNOSGpNb0Uray9sYklMcWxZ?=
 =?utf-8?B?aUhMVHBrNG43VjJHYWlWalBQUUdmVm5kcmZMSVIvTmFQNmxXUWFYalVsRWM5?=
 =?utf-8?B?NkxIaXdIVjIvRFJLZVhOVC9xQTR6bGpkOU5WK3FuZmVSZkd3TmZKM1U4dDNl?=
 =?utf-8?B?MWVCZmcxaEZzRHcwQW1ReE9PSnQwbEVRNGFzc3dyUzluTFpQRnRSOW1vRzFY?=
 =?utf-8?B?RVVRaTRXWG9rckJJa0d2TFpaSjB6Zk9CUStWeXFHeEdQS3Mzcll3dy9vK0RG?=
 =?utf-8?B?bGZNY3NIcmVkeFQ4UUEyUm1nbUZvRGp6aDdKK0x3eGdhUkdqaS9odU9XZEx6?=
 =?utf-8?B?UjFadU16cjBTQTNNTllxMng4VytzbmxOby9EYUZNMG95dWR0TC9NY0Qwb1Jp?=
 =?utf-8?B?a3hMSWNwWDJ0R0Vhd00wMmJ4SzZqTGtEaGxhbUI2dm56b0VNMmV6MzhvczQ1?=
 =?utf-8?B?dmc2SDJuV0x3L1loOVBtVDZtN2s5T05ueTZOd0QwN1RSOTZCbWk5Ukd5SVl4?=
 =?utf-8?B?ci9EdWQ3TUpaelBIcTl4RUpuMHRRbi9CR3p4cFVGN3Q0UFRyWlcwSUNuNVlG?=
 =?utf-8?B?MSsrc2M1aHpqM1QvWkR0alVKbmdDNVJua09hOTFIZHpXVjNLVUFlZXlDUHgz?=
 =?utf-8?B?YVNhSHU0K3lUSG52cGNvNFExZ0sxNmNOeTg4amZELzdKWFhyVWQ3RHFReWRx?=
 =?utf-8?B?WW9XY0ExK2JPMVJFcDJVVzZtZnBmN3VodmZ0REhCUmJSeW52eEtwVHJyRXpJ?=
 =?utf-8?B?OE8yKzAvTHBuR1cwaW9DWGhlTkJNb2xhVEZFQ3RvSHJ0eUk2L2tNUFhkdVIr?=
 =?utf-8?B?QmMwSGJIZ1h0ampzYzFJV3l5YXJ5Ym1iMmgya3E0YVpnQnRhVkZvVmVpVmtk?=
 =?utf-8?B?ZHRMUmNkbFVkdE9oTkFxS1o1Z0N1NTkrRWMzTTIvRXhsUkVXdmRJK3BMekFj?=
 =?utf-8?B?dk1DMUM0NGwxMGduNlA4UjFnUTNPcFVYaU82WDBlYnBFZVBSUjZuZ1EwZ0ZR?=
 =?utf-8?B?TnFDNTlWbjAvT2RnVTFFQUdOWkVtQU9MeWxCOUhISi9vblNsWUFjWFRNbSt0?=
 =?utf-8?B?WmxaaHJVdG5zWXBNaFN6ejFnSHdRRU5hdXJTRy80aGpHUWl2YWpYbTg2c01D?=
 =?utf-8?B?dklLWnkwNEl2c1FUUDFQZTkrQkd6djFZRUYyam1vNlZadWZaWS9UaVhqaGVz?=
 =?utf-8?B?SXdHcTF2WEtCZWJMSmJkOUpxN05pOXJuU01BOWEzN25CcXQ1ejZXRzU2NklB?=
 =?utf-8?B?NUdMTXM1Ym1TQUFwTHhKQXp2UlpmUzJVbUdDRFhkRTZVN1F6UVg5bnVJSXN2?=
 =?utf-8?B?clhMa2d2MllEaFcwVlplbUhmWVl3ZkVXR09hWFdYZlBJOVEwdEs5TkRwKzQ0?=
 =?utf-8?B?Q0Z1TWhEUXQvci9SWlF4ajNlN3NJdFl0dHkxamY4Q2FXRzdZWjF5NjY4dThQ?=
 =?utf-8?B?MFc0UjlxVVVXS2VYR09Ya1cxZHBzZGlJc0oramZ1a2tqc2xqc0RQa1poZHJZ?=
 =?utf-8?Q?M8GqKWyvCW9zUxq8eGietpKTKPbFFvJ6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N2EzbndaZDB1VlFpY2lBYlBmdUdCUm15Uk9JOVM4Vzl6S2xlakp4b2JiL0NC?=
 =?utf-8?B?UktqUzFxWEVPTWFOaWZaRVpSUEg3dElZYS85VmdyR3NxMFh3TEVFMVdIanZh?=
 =?utf-8?B?SnZtYTJQRkhrcERrRHlkUThrbmdLL3V3K0h1WVkrTVpERkhacTlELzhYODdR?=
 =?utf-8?B?M0xTUjVWbVdEU0pvSXArM0t0czl1TVZaOXlYYTNKa0F6bGJETGFpWVZ5ZnhN?=
 =?utf-8?B?ZE1VVzJsaTVhbXBldnhyUnNKajBFT3F2SHlxdS9NNjhuK0hJb3pzVmFTOFlF?=
 =?utf-8?B?YVFSVGtiRzNySkkyTGZXYzE2cWh4WjJ1dVJpeDV2azhsMXhsSmlCa0I4WHBQ?=
 =?utf-8?B?Y3JYWEd2YmxnK1pMcXdoQ3h6MzNtLzdqSVhnVmVLbGFEeWV2cGczM2NBamQ5?=
 =?utf-8?B?VHYxV0U5ZFZqdGE4ZXEya01Qd0c0b3UySmFLSWtnR0hlWHlkeGNnKy9CSWgx?=
 =?utf-8?B?M2U3bmg0L1o0Ui9ML2V4bkxQeUdUTlk1aFVVbGlISUU5cnc3dlVIV2s4dUI4?=
 =?utf-8?B?VVU3MGNzYnRJTmVmUDhzNGZkOFBnYjhnZjM4bnVocWlOb2tvc1FLTHA1b21L?=
 =?utf-8?B?WTB4NEpoQ2ZnVWw1V1FRVktMSFVvd0dwL0JBWE4xS1hoM2t2dnZjU25LY0lG?=
 =?utf-8?B?RzJ6OHo0M0pBR3dyQmNqbGVsYldPL05TVDYzS0hiaDZ5THBlelBnU1hZb0xB?=
 =?utf-8?B?WnhYNzFGRXp1ODJsUFNCLzBLK01SYWxicjFFWDg3T2dqZWdlWmx3RnJwc0Iw?=
 =?utf-8?B?OHJmTzVrdFdIZjlZZFhEcWFJeXZONUd6aVdUZ1NEaldSTzAzQ1dVQjlrK3Ra?=
 =?utf-8?B?bHM0L0lhalRRTHFIRDFXU0NLSkRLa05LaDFwZEd1OXV0Z2d2VGJQaTJ6TXZO?=
 =?utf-8?B?aDlNZUNMc2FteHZ2OTZyNDFYdlBzRjExanA4SGg3c3VnZHpxQS9PQXF1M3Ro?=
 =?utf-8?B?ekVPdExoRE9yZVhSRjh5YmRObzBuTFVPaW1sN3gxMXlsV2E1ZUUvZW5Hc3Jm?=
 =?utf-8?B?S3VOdm5mU0FKRUYrZXgwMTU2S1l1WGN3MjBzWVc5b2F1UmZmU0JpTVRlV0Ey?=
 =?utf-8?B?UFNhTmRkaVZBTU9KN3Z3SHc2YWFmVzY2TE5Zc1d6RXpsWThFYUZ4TTIvZFdw?=
 =?utf-8?B?eU9PMXZkZnk3aFRaNEpIalIvZzhKcUhqOFI2Q3dHK1lVcFFQM01hbWpxWkdC?=
 =?utf-8?B?QWZjaUJkOFlub2t4MjRuSmFQUDFMc3JxcWFpV3YxVndxSVRaOU1BKzMzeHlY?=
 =?utf-8?B?YkwxcHYrN0xuRFVFdjZBTmRYVGErNmphWkI3eGJDWHlEdFIvNGdrRTFQNWFq?=
 =?utf-8?B?N3BlUDBTT3ZSNkFHalc1WmFZdTRVR3ZKOTU4YXpkOHowbnJObndSN3pSMHoz?=
 =?utf-8?B?UkJRcWZvV2o0T3lrMXFwMGpqWDJSZWI4aXg0ZjZyN0ZCTVdIenBFak9FUVZ4?=
 =?utf-8?B?bFdidGtWZmQvbDRtb0krR3prZ1k3UzNuY3hPU0l5SnNqZ1ppTmFXMXFoVjVi?=
 =?utf-8?B?Y0xFM0pQWGs5RU1RU2JCUDJVbWlyc0xwQ09nRndMSGx5Y3BGZjVVOUF1V2VD?=
 =?utf-8?B?T1NGSGU5dks0ZjVMQUV4UzIvZ0JZeFRFcXBmcHNyWnVPc2NGRER0QzRHekFK?=
 =?utf-8?B?YkRadkFZbklFMjh6QVlOQzQ0a3I5c05mYUVRRnV5ZVBheFRBN3h1OFBta1VZ?=
 =?utf-8?B?cGt3bE5jdGZqR2d2OFB2SHlKOHBJNlVjbjI1VEoxZ3hkUklPM2pMbk1FRmlu?=
 =?utf-8?B?em02WVZKVGVmaVRPWUprV3B0M1EwT3FRYXhGenk1K3RQWEM3VzVteHdrTmor?=
 =?utf-8?B?ZHR2UzhKNFFBWWozK0tZdWpoUXNhNW1BRW5QUHI3TDZKYk5NSjlLM3pYSXM0?=
 =?utf-8?B?eW81WkxnN3RDSkdKWk5XVnp3bWZ2TitYcXVJQjVvU1Q0UkhnZHAvNmlDRkg0?=
 =?utf-8?B?RU5HcHFkWUJ3SC9qa0RBMHdPdGNzRWQzZktENlVYMk9FRGFpTUd1TEt5d1Mv?=
 =?utf-8?B?Szg3dFlRSkpFN3ZjYS9zaEtqM2NpQjcyeFpKbXBSekp4L3dMaGN0YWlTd2dh?=
 =?utf-8?B?cmwvYTRUTmJ4WXBOUWF6ZFc1MFNVZmlsMWdBdVJmbzZpV1hVSTR6QWhqNmxk?=
 =?utf-8?B?aEROd1VPdjRvYjBNQks5QTRBRWgvcUxndTRUMU5ENDVoNGJOQVgzRFpBamJK?=
 =?utf-8?Q?ZCOvpnvNGy4G1iBxBfQryZtJKop9fsCMOxtG8rEd3uEb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D64DEFCF6D45C842BA5E9003488E4FB9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6b7af7-aa8c-40d8-0d19-08dd4472d4e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2025 16:50:14.4244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruSNktZ6RMdMXfjSTfXCBDXlvL81ye0P0xUUdlrk6ZzL/SeA3XajqbF8uz5dya2SV37mm83lYgYLR0oO0YXqxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5738

T24gMS8yLzI1IDIzOjMzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gVGhlcmUgaXMgbm90
IHJlYWwgcG9pbnQgaW4gYSBoZWxwZXIganVzdCB0byBhc3NpZ24gdGhyZWUgdmFsdWVzIHRvIGZv
dXINCj4gZmllbGRzLCBlc3BlY2lhbGx5IHdoZW4gdGhlIHN1cnJvdW5kaW5nIGNvZGUgaXMgd29y
a2luZyBvbiB0aGUNCj4gbmVpZ2hib3IgZmllbGRzIGRpcmVjdGx5Lg0KPg0KPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hAbHN0LmRlPg0KDQoNCkxvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
