Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B11539FF3
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jul 2024 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721393394; cv=fail; b=Qa51BLGamdEhIGuswzl29/Jscbrb+/lBi/akwfCjernXc5j5DPcx6YhwTY8cxufGKVLZbwXLVy7niV5r/6RLCKStyZKWQzop5C/Tlj+mdZ+ZsKT9a93nfN2h0h2rM83BNZckVYjcpGLL1auuU6gRpdzZdN8ZuPcLcAHGIW6917c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721393394; c=relaxed/simple;
	bh=4rFXcfZUeuMOpU+Qp6W9LIE7PYmijdBX0fzQrTmJQSI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KTLLFo7I2JmhtnlLnJNJ1QG3ChR6fkNJtVML9GTUqyh5Evg0B3ODB7/oNwHpdfJo1G/TJbLM7Rw/3oJfdyNvrKmf3a1MTYDNi3iBimtZ3okM1wH7Y9hrKjYXyfX9T2WNY+tiW3ar2ytun+KcGfGHqBqVMrkOaM112LYThPND4rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WyuSp95W; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rCQhjbZk; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WyuSp95W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rCQhjbZk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1721393392; x=1752929392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4rFXcfZUeuMOpU+Qp6W9LIE7PYmijdBX0fzQrTmJQSI=;
  b=WyuSp95WLVG+gMHiimG4hIqEgej38blaGf/KkFYrH8JFS70VbaCzyXXo
   cgtzGBh6bO6lIbKSKxTyhQ+Rz0rGbaMj6V117pUTITEowrF9Z4bw5sk50
   UZvkAlm8SUmKzKM3UKAtt1hWtoHUYdJROHv65Prv+8L9CCP/A+0ArXCjh
   9Kg/ZyGeACfam9UCYIq4MQXg9IIkPNn4Q/618KuIc9kdq4ewjdf+sTQ7a
   aMBmJycAdv3gu7NdMt9UI8ahoTOtmjQ/ayTHOCADUTl65omXiOskCVdzD
   TrsMAU4Y/ToqNhrwOXKCO1APspS/f6gdmPlRXsW1sp+Ou2H9Rx8wkXD0F
   Q==;
X-CSE-ConnectionGUID: 6tCYl81eRPG/aMkvwhFgew==
X-CSE-MsgGUID: lUaR7rEiSmuiLB7M+Q7A1g==
X-IronPort-AV: E=Sophos;i="6.09,220,1716220800"; 
   d="scan'208";a="22871758"
Received: from mail-westusazlp17010002.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([40.93.1.2])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2024 20:49:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9u3eQ69w3QabZPlLTrSKmez5aZSdVCyDBdJxVcX1mjH36Coopz23c2WGi9xPB1/MoLyT2icAdN2WibDUqxM0TqxJDB+ZK8NqU3OuWeYIMbqAQjLEzi8ixykgWw6CzWaR9oW3hqSenCDCHA3LDUGhW8Kw0heKgFFc+Tu1yiMYQkm4uhko1w11oTCBaJb8KnJvGXH/GeU9WjB0hHFZDR7vDTXo8zJKGWR1VX5/TM14zA9kZFAznl1Lc0LM5uRony21C2hNdkGSswnINjMNhtLOKaVYmppYBEg+18FHgE+45LcaqlRP77EykXWpPYH+XhPOpuqCs+5ASnKMT/fbDpy0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rFXcfZUeuMOpU+Qp6W9LIE7PYmijdBX0fzQrTmJQSI=;
 b=i1/ez1j3Xyj++89+hc2wesu16sW7jEvLnPMNmK58bgF2pfcI/xV5HmQQ4YituFaAZMU+7ezu77pEXMAWNdXI30c7H6jfofCi9w0im57ugpDkgWamlRMFo3LlPSQ540dDbKgMntDQzIpCSO/IGoY32D3F/3YpPVV12uTdapD0x0Qe1OqisyrfYroEOS2PTpLqgZ3o2MgTvwvcY9mx40kF08GuKIG1DHGFF6FfxoPgw3gNqzh3TIrlNO0HyuPZfES22jTr3xxiw99vGpHFLr1vEZz7wX38DvCdCaSKFbvXY9kUljdHnz5bezGZLjciMiFwRfxDSElD5J/fCvGbIzW/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rFXcfZUeuMOpU+Qp6W9LIE7PYmijdBX0fzQrTmJQSI=;
 b=rCQhjbZkC4LuHyBrErZ/NPtB4PmACYFG4MIK6wHl9YUdEXm9ZdTtvvHfyLFKlOfvRR+oq0/lvfSL0hZ7byRyozr9I4qdPKCzR+WP4uU/0MlJ0i4zFGiCWEykGSemLIfn/rdSVazZrzO+f1H5GiXWnsWT4EKacivE4cXaPu2YRK8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by LV3PR04MB9186.namprd04.prod.outlook.com (2603:10b6:408:277::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Fri, 19 Jul
 2024 12:49:42 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.7784.015; Fri, 19 Jul 2024
 12:49:42 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: hch <hch@lst.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth
 Reddy <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/2] Fix IOMMU page fault on report zones
Thread-Topic: [PATCH 0/2] Fix IOMMU page fault on report zones
Thread-Index: AQHa2a7Hfvke/D3fFUe7DEZi2ILBurH+AOEA
Date: Fri, 19 Jul 2024 12:49:42 +0000
Message-ID: <002847dc-1d92-445b-9ffc-6909e890d072@wdc.com>
References: <20240719073913.179559-1-dlemoal@kernel.org>
In-Reply-To: <20240719073913.179559-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|LV3PR04MB9186:EE_
x-ms-office365-filtering-correlation-id: 665b89a2-b242-41f3-9310-08dca7f142b0
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmFGQlp2UHQwR29laFl4c29LSGhySHRLK2RHV3ZhVUJ1NTVtY0JSVEFjMnFP?=
 =?utf-8?B?SXZBUjd1S01CQmNmYXZhRU9ZdXhRNHdadDQ2VHN3NmN2YnovSlQxdmtRN0Nk?=
 =?utf-8?B?RjZHT1JwZG1WWFQxVGVWQXhuNWx1eDhvZHpHM3FVNWpwWnU0ZXJhTUx0cVhl?=
 =?utf-8?B?SFVXZTgwcDBySzJrRVJBaFB0elk5UlMvTjd3WEtLOHhHNnJwblNVOWJubDBV?=
 =?utf-8?B?b0tlTXFNWThQMmNxZWV4VFQ3TktpdmpiU3VVV2RWQnV2d3NEaS8yMmFsWk5D?=
 =?utf-8?B?azgxRklDN1NmNU5sRVY4RUVUZCtOa2NhNnlTaGlpbURBNU45RlRJWUhZMjBD?=
 =?utf-8?B?RVJMODFuL1NEbTJsUk9aWkRVcXFLUXBJQStCRjV6ZnlXWUJCT1l6SkhMbnJ6?=
 =?utf-8?B?ZHAzUEppN0t5dTVBYmRZQWJYdEo1aHJlK3Q0Rkppa2VlbURUcDJHUFBVMnQ0?=
 =?utf-8?B?YnE2dHhVODhqbWZLQ0hnSmJOaEF3SDVTRUZpT3AvZ3Fwb1lTMU5NbnBFQTk3?=
 =?utf-8?B?ZktvT2VmOUZKdGN0cEZ4bUR4RlJlckxVV3ZKQ3NGN2czZmx2YkVKY3EvWE9B?=
 =?utf-8?B?SlY3eGpGa1BncEFkdTBWTGp0VnBjTXNwQ1UzZXcycmVVc3M0VUZzN0JRMURr?=
 =?utf-8?B?WEp2Q1lEQkRnbm5hUjl0dW8zWUZ1TStSeCt4V05iTTN2YzZOUjIvMmE4c2Zm?=
 =?utf-8?B?Z0xySEpEbmdyb3BmNFVDbm80bGg3dlllQWNtTDYwcDlCUTd4SEgrR2IvTTZw?=
 =?utf-8?B?Tnk2T3hZL0x3VUZlSWk0aEtyV0V5Y3RzMzIvSE9mSkg0dWpjTzZMdmNoRXZY?=
 =?utf-8?B?TnNQS1NTMnZkbkZKOHBNVTNNY052VkJHSUZ1TXVyWEtvSzdDcHU3TlhpUnU1?=
 =?utf-8?B?bktUNGdoeEpweTRIV0ZyMVBMWE5tN2dGRExHZGNwQ0hNUy9SaVZ6NllsdkVK?=
 =?utf-8?B?NzhqRXMxcktmNXpvRndXcHZyZ1pPek44eVA0QUoxUW8zOWVtTTlPRDJkWVFz?=
 =?utf-8?B?VEV2bi9yUmlsenJtQnZWMWxxenEvb2N5NU5UdUw4NSt0L0RJWGo3M3U0S25p?=
 =?utf-8?B?L2xIc3dURnY4WjN0Z1NVWVA1SUVtYVJoajc1TUpEK3NWQ3g5N0QzRm1lWWt2?=
 =?utf-8?B?Nnhxam5XakdXMU5YMDQxbmpNc0UrQytwMzN2VnhwL2xmN3N6aTZWdmF5Y2Fz?=
 =?utf-8?B?YlhNMnZtTEFlWTlYdDliZGJ0QkM4b1A4dXhHZy9QMHBWbTdHYlRaMXJzY0ZE?=
 =?utf-8?B?aEZ6SmhDYnJmd0RzZ0tudC9MQ1cwcjg3RC9OamhrNEVUNGdQZG9mTFZ5elV1?=
 =?utf-8?B?QTFaZm10SmV1RmFDWk1ISnV2RGhQbkdMN2MrWkVFbnIxUFlGYi9EWjlpOUwy?=
 =?utf-8?B?bWVIeFRuMEdxVlgrY2NUbkNNTXdRMm1Jc0hVUHFIcVk2S05YU2lub3JqMENo?=
 =?utf-8?B?bENmTGtqQnB6aG9PbU9wUzVnb05aRTFrY29TU3MrZ3JqU1d0bUVpK3hqdkxZ?=
 =?utf-8?B?cnU5Znk0VUtNNjlya3MrckxCODNRK0xobWlQUlU4NEhhaXFzKy8yMmtEQmJW?=
 =?utf-8?B?RE9xeDJtMzNmZlgrVW83WDR3TVBxMkdneStlUWJyb3U4QngzT3owMlFMNVlN?=
 =?utf-8?B?T1puT0FwdTlFYXBXbGEwQWdBd0RNNlFNWHljQ2NGaHpJMkdHVERadEFlcWlo?=
 =?utf-8?B?bGdSNGZGUkZhbk9BRE5FazJGVFU0MGF5MTczTXpkUWF6VEg3MHZING1LS0hs?=
 =?utf-8?B?Nk9xeVFFVjFZc2liUGc1UU53VDcyMC94NzBWTHJWeTJwbnZoanBOcE5qdFlu?=
 =?utf-8?B?bVZPSzhnUVlMNkVsMmtuOUgyLzRqODl0cHIvdVorWjY4NXVRV1dUTEVoWGh0?=
 =?utf-8?B?Q3BhaS9XekQwSFMreDIrcGJjY0xrQ1hYT1o1NHdVdXpvc2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dWdqOUNCTUdKMDUrb2Vwc2VsM1p3Zjdod0RoYXlGVGx1TGovWDJwLzJoc2V6?=
 =?utf-8?B?dVlLTWh3WXRiYUxTRWJ4WW9XVDltVnpRcW82bWhqeTMrcDFzVlhXSldidWVy?=
 =?utf-8?B?YmpEYlprcGNMN3ZIVE9HUmg3OHErN3pXMEdZeE8xOWkwM3c3MHZvTEZBMWxp?=
 =?utf-8?B?MkZkK05MUTQ3RUhTZEVSWVRnNGlYVUNXVGdLa2krbjJadVBBWGs5MW9iUTZE?=
 =?utf-8?B?b29Db29hbEttNi8zTmxtOHlDQ0xidW44TVNFYjhKYU92MUIvWFNicmlUUW9Y?=
 =?utf-8?B?YVhHRzQ0MW84Q1hobUVRUGQxRXB6cVNxTXRsekNoWG5nNmlZM3hCSUw4dm1o?=
 =?utf-8?B?Mm5lS2RSSGhQTFo0U0FsZUVLWkt3YVRmZVZDam01V1IxTU5LL2hRWjFCYmNG?=
 =?utf-8?B?c0Z3MTF5QzV5RFZiOGNGVUhIOGRaNG82TEVUZGQwNG1mM0tPaUw5cWtXNjJG?=
 =?utf-8?B?U2RjWjhaTkY4cTNGQ0kvOVYvL2xkb0JMdGZwbUNrKzcxOEJPTDhId2JpTGpQ?=
 =?utf-8?B?dEVDeU5KcjJuMTZVdDlnK3luVklKUElHa3lQVFN1MUhEMk9ySVF0M2RIcXEv?=
 =?utf-8?B?U0NkNCtTbEQrdVB6a0NTRTgvMEx0eUl1TDFZSUh5NWdObmdNYXozVGVBbzEv?=
 =?utf-8?B?SnVVSnNSckV6ZDRjM1R3N3hXa3JsQjE1dFJJeHVwcmQ5R3M2MzNKZUVLRnZn?=
 =?utf-8?B?ZTcxeno2NG14Mmh2RDJ2Z0FqL3NjV25vMC9pWmFhUE1GVDlWcERqT3IzOWlR?=
 =?utf-8?B?eWFtK1VocEMxT3VPS2VCa0lNNGJ5aExWamVwTkRKN25TOVA3dEZMRnNnR2Vq?=
 =?utf-8?B?bEJPYTVNRVhWSXNSTDRvZmRpc2JvcENNUUlFVGRIcFE2K1hWTkNZcnBJUTVE?=
 =?utf-8?B?MHI3c2lDNnVWbzJ5anV6eFdEcHM1SHBzUHNTUzNXeEo5ZzA2ME15eGJhWDlR?=
 =?utf-8?B?RmdpeDY4U0FRQWxZM09TZUorRHpRNXExVURNdDJ4R2ZNYXpEc3Zab0FXSXNx?=
 =?utf-8?B?RzBoZDhIU0gyQzcvcGZ0YXJnREpnZXl1TXRCVi9IT1FmVTNhejlHbXkrZlYv?=
 =?utf-8?B?WkNVREU3WGpkV3o4akhXR1pwdVk4anlWWnc0ZHBTaDI0cEFRZGN2MERqcVJY?=
 =?utf-8?B?TEtBajF6V0FHYUh0Yk5XTW04dk1BSGxvUE94RUhXQ2tMTGRtNHYzM3UrNzk1?=
 =?utf-8?B?dFJucys5K3lpSC83Ykp4dzU2bnR6bUpHZmJxcE4yNWtYRWNZNlNGeEtOdjZ5?=
 =?utf-8?B?aDYrMHhxZUt3Q0Y0cHJCemoydXduSU04UXdJTjhZT3JZMkMrVnphd2ZSSjVO?=
 =?utf-8?B?WUhZVHdFakYrdjRORUdBNGVJWlpYazNBWHpQYURaWEFDRFFra2VEWlFGbUVr?=
 =?utf-8?B?N083ZktMa2I2eWNHSjVOQzZ6NVl4b1lrT0RWNmVWU2hpRkZqUldZUll6S3Jm?=
 =?utf-8?B?RnJrbUNTVkZHQWtMVkdWYmFiQUp0WHBtaVZHYThuMXNRVjBwenQ3UjdNdVR3?=
 =?utf-8?B?Q3hRMkRCSjAwQUFraktCQzd1UjkxaXMyaW9BZ0JJWDdieEk3REtxTXEvWEJ3?=
 =?utf-8?B?Uy9tcERhdTZod2pRckRiYTBwemFTNzZkSUhYQXE5Sk5sRXhZRitsVitUckxC?=
 =?utf-8?B?YlEvaEJZcmMxazRXQmlodzFLN3FjL3NSTEVkYTBCdnhZT1l2dVo4NGVlb3Bp?=
 =?utf-8?B?VjZtVng4Wmp2dFpwbXFicVpPdFp3Ym4vbDlrdVZMOW1ucHFGRXYvaSt3bXJ1?=
 =?utf-8?B?MGdTM29Xenh6ZnhWTTBHOFVKVk9temdkUERkMitsSFhqZVNEYjYycjR6U1NR?=
 =?utf-8?B?bjdETWhMWFNVZ0dYT1RRNlE0QVA4TXd0Skx2bzlOTVV0d3ZpczN6YUVFMzVO?=
 =?utf-8?B?SytYZWpITDV3UEhKSk5hVVJBQnBUajF2cUV2K1AxM2dYNUJBVzdTdlRGK1Bo?=
 =?utf-8?B?UnUzRDBSTml4YUpIQ3I2MnQzdUhUQXlkdWtnVjdoUEVrczhtMHFKU1piSGha?=
 =?utf-8?B?KzVJdEpUUjlzTENiNEdVdUVjK3dvS3l0czZXV3FnamdSR29hWVlHNy9mRWcr?=
 =?utf-8?B?dFovUXU2bnh3WHFuUVVEdkpack4xRzlVZTlaZjB6d1FBcldCeXBGbExVMEVV?=
 =?utf-8?B?K1FaL0RSN1dKOGxIUTFGbUFOcWdvYjF2anRtdjNlZ1hYOFJrWEpPMjRCR2xz?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41074D78C116544A8B3D3970CCDB0102@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jpAid7oYx5FOf97QAX8mPr1ans/A3+iIoDpqnUTmdxwTwV0TZb1E4C+CuR8BgT928htG3LuqQqGbH3VY+C2H1k5V5O7qNVCqjMJiaWCxm7kEo55ozWYLVf7ZP9TQTbxtBTATA8YRAfsDfsTWvJiQl1iAH4COqeRveajbsuYmPGevxZhcMPWE9SkdfJEZWjuJFg9Z/fsdRbOFvFpqSHfjK7DVSlQmeXuYYRU2tL1qa6cFnqHuA7jWWpP1M/GQkPAvKVpMxYKWJtg9uXXiz+4B9T2UrknRrSQ0RJHOamz1EW0JR/rwXSJVImYcEf8b1we/IvSBNil2YddUtPx2O+p7woio9T6MbQxrydAghTN35VSS3S7EYMm9ixaRR0KU65nelnTnI21UwUKn6zjYGMZkCPe1LdnsaOVQEVcBgx7ZottMVkq3frWO38oFAnpB2cNvm/ad09o+rtjkG+1irIW09iRulOWibWuwmlZggyWaGEoZ4L/M46Vi5JA3LefJ0/nVpZCodWWR3/0i+dN5vI9fhmJXfSzjHxZBZfRuz9Uyu4a9tati3N/2Qw1NSNtkOK6Kvt6X48MhiI/1+ui1z1beJAtthL4oCvJVksd/J70SCRZ4S2C+g/xMuehCySNMytjf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665b89a2-b242-41f3-9310-08dca7f142b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2024 12:49:42.7529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Tc6E/vZBP7UQXwHyO8o6ANqG7pQFaTFN9DEhXHkV05FmYr8AVUG39mkIKP4U0iTPB2su2NvP3mlU9sjuUhmIvhn+inHPumVrYajSB/0row=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9186

T24gMTkuMDcuMjQgMDk6MzksIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBBIGNvdXBsZSBvZiBw
YXRjaGVzIHRvIGF2b2lkIElPTU1VIHBhZ2UgZmF1bHRzIGVycm9yIHdoZW4gZXhlY3V0aW5nIGEN
Cj4gcmVwb3J0IHpvbmVzIGNvbW1hbmQgb24gQVRBIFNNUiBkcml2ZXMgY29ubmVjdGVkIHRvIG1w
dDNzYXMgb3IgbXBpM21yDQo+IFNBUyBIQkFzLiBUaGVzZSBwYWdlIGZhdWx0cyBoYXBwZW4gb25s
eSB3aXRoIEFNRCBob3N0cyBhbmQgYXJlIG5vdA0KPiB0cmlnZ2VyZWQgd2l0aCBJbnRlbCBtYWNo
aW5lcy4NCj4gDQo+IERhbWllbiBMZSBNb2FsICgyKToNCj4gICAgc2NzaTogbXBpM21yOiBBdm9p
ZCBJT01NVSBwYWdlIGZhdWx0cyBvbiByZXBvcnQgem9uZXMNCj4gICAgc2NzaTogbXB0M3Nhczog
QXZvaWQgSU9NTVUgcGFnZSBmYXVsdHMgb24gcmVwb3J0IHpvbmVzDQo+IA0KPiAgIGRyaXZlcnMv
c2NzaS9tcGkzbXIvbXBpM21yX29zLmMgICAgIHwgMTEgKysrKysrKysrKysNCj4gICBkcml2ZXJz
L3Njc2kvbXB0M3Nhcy9tcHQzc2FzX2Jhc2UuYyB8IDIwICsrKysrKysrKysrKysrKysrKy0tDQo+
ICAgMiBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiAN
Cg0KTG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVz
LnRodW1zaGlybkB3ZGMuY29tPg0K
