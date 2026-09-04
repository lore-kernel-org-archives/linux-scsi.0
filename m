Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D6C2C11E7;
	Fri,  4 Sep 2026 03:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788491979; cv=fail; b=Fb2g7ZZCn4MVNKkiOuM1LWHMdJoxj1lnf/XmXamBNOnbRijoxvY8K+pFi6uyUN+XgblN8KYaAY4sh0q/PTEhLvgJOTMwQxRxOksXBlXKhIMbI126z0o1bxDA0TLWdcvFf2X2bAkt/jgUYohwW2+pwuB6OJhmpfqA/rvr/AEPCzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788491979; c=relaxed/simple;
	bh=4JEJijZd4h+siGLC1zKlH22RZXdX7cDZfB/lWEosIJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QXt1OKGA9S0wwH/xpkROUrTY43ygx8EeBomAeCeBMns03C18ugOjly+DCtbvFn1WSCP1PbkDQFsbOJFwoPMNVXnABwi/ajbSIGSDSbZD07tqHoakXYD/A4ljvpNQvk1sw70tsTBNuffbkFV+ok3ltwCNb9/gjif3ShiVXcFX/KE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cTZZd/a6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=WBXqOqUQ; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cTZZd/a6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WBXqOqUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788491977; x=1820027977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4JEJijZd4h+siGLC1zKlH22RZXdX7cDZfB/lWEosIJA=;
  b=cTZZd/a6kUqEnEhGm4GvEFImB1O4KomJYKDMK2yevk/gk6PgUg9ZFL5K
   LE8O9Ap0PbZeecNRvPy8y8inJbwiMviljR1MA5fpfvIfEy6Dk0B0/pteH
   02T1o5E3S1HIYUfK3N6WPW8/5sj+OAcaQTnIQHlF9QAWvzKzegWYcC5q1
   ODgKc1KTmCvu7Y+swGmiB6KJnZohFmL7nZEmXIK2ib4SACnEDaWWZJLJH
   fb+lHWEAkbxOKhdJkO2woH8/Q0519O5Qp+neu7sesOpfmRYLun9DnAZdJ
   mFD4r/yLZzultfSBJSTWC8Sudsun8H9neaL7DjaHrUmaAyulS6ggRs1Uo
   g==;
X-CSE-ConnectionGUID: P/m0qSp4SxaoMzeYD7WA3g==
X-CSE-MsgGUID: ohCgFVKNQQGaWOazCJQbJQ==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="153348389"
Received: from mail-eastusazon11011061.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 11:19:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5ZO6nCQhw9jykHJbd7lFVZd4ZXVMnSzP2iYw9/DMB7oKNUFM/Gd4FFwoVxTx2e8PJN6BQpc5WzREuYF8SGZqCgo0wLZqoCCKkNkTcBFHsJTPkX16ZWq+xTqBsWnaXf9/AZBx5bomN+FQVdqPBJmw7mytFtXAPyh1YvDdfafhIlTWHKhDWfA/6OwHzttEB6hoER22Nlnf5Mql0Yj2OvcQpVrJbPBaj6WNm4edLvbQN78s7tekICmAeK4RW6xSWUqd3l9KGRTdU9eYY63bSY0lI0Vd4vhf6/rTE1GZ5I5wOiJ61fLTNRUPY46X+5RmpE0QMYg6qhgDjwHUWq7/Uj89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JEJijZd4h+siGLC1zKlH22RZXdX7cDZfB/lWEosIJA=;
 b=EGWO/KJV0jmeZwtaqkS6SC5ldtkqaku1fjcHfuGxk9ECjQKaS5m8o3iA8VNWJArDUMqKShIvNtL1SNrOmhcV5vkUzO7fk2Y3Ryy64rmpqLiU2nMsDvh4PkeWuOIAytiFmcZ67dYcFSkAx46LIzdrTuqO2L2qNRf/lhj8vhTLsVb6c623Cx0nl5U7b2I49gaTxvv+mwsTQo7J6CSWdRQTR8Ibk+4yzEFrNmupGwmPOtSj8/AO/3FqzTBrzPJWauS8qTQjcQNa0OLRQ1S4+0M8YFqE2z5Uo7jM+NpYye3pREhBHA0wqH6IDwtCi27KKIN4abKi0hkenKMXS7kOkkxXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JEJijZd4h+siGLC1zKlH22RZXdX7cDZfB/lWEosIJA=;
 b=WBXqOqUQwq6EPKjBPMUxNoYrrWhuHzeNfushXfwxe1shl0JnLr785t7SgEywws2bfi5uwFwlXU7CGqYA2Co0xsvJgkujNIU3JSaL7eXOxftUa0adVxkgIOTEW980SSM9H3XvFLzpMdpXoeQQeeDqJEiyYpC99Ea4W9BnbGrdARs=
Received: from BY1PR04MB9561.namprd04.prod.outlook.com (2603:10b6:a03:5b6::11)
 by LV0PR04MB10135.namprd04.prod.outlook.com (2603:10b6:408:391::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 03:19:28 +0000
Received: from BY1PR04MB9561.namprd04.prod.outlook.com
 ([fe80::3869:e494:2fa8:9888]) by BY1PR04MB9561.namprd04.prod.outlook.com
 ([fe80::3869:e494:2fa8:9888%5]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 03:19:28 +0000
From: Alistair Francis <Alistair.Francis@wdc.com>
To: "mani@kernel.org" <mani@kernel.org>, "cassel@kernel.org"
	<cassel@kernel.org>, "dlemoal@kernel.org" <dlemoal@kernel.org>
CC: "alistair23@gmail.com" <alistair23@gmail.com>, "jasowangio@gmail.com"
	<jasowangio@gmail.com>, "xuanzhuo@linux.alibaba.com"
	<xuanzhuo@linux.alibaba.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "den@valinux.co.jp" <den@valinux.co.jp>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Frank.Li@kernel.org" <Frank.Li@kernel.org>,
	"mie@igel.co.jp" <mie@igel.co.jp>, "mkp@kernel.org" <mkp@kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, "James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kishon@kernel.org" <kishon@kernel.org>
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Thread-Topic: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Thread-Index: AQHdObPJz5OVFDRvSEWKpAWXM9IaQ7a5ZmCAgANbVYCAAM7zgIAANFKA
Date: Fri, 4 Sep 2026 03:19:27 +0000
Message-ID: <2daeb43d582f0d960370fcd415c3b5bd3d94c67c.camel@wdc.com>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
	 <apaOZeeDBIRlpB7b@ryzen>
	 <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
	 <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>
In-Reply-To: <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB9561:EE_|LV0PR04MB10135:EE_
x-ms-office365-filtering-correlation-id: bc606157-b645-4e48-c1c1-08df0a335423
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|19092799006|23010399003|366016|22082099003|56012099006|10067099003|11063799006|5023799004|4143699003|3023799007|18002099003|6133799003|38070700021;
x-microsoft-antispam-message-info:
 +0T8wXebaArfvrSR2UBLgKr/98dCClbq4yOfY8Bq/W80Nt8bVfnA8usDPaC2XWD1xjXOdYBQOm/1c5K90C9yfBU7yRvT+BT0/K60eA6/gTrnKqb4AJe79t7Yxys/mr3xuCEwBlYjxCT7s///5m2atExfiAnDD8Wb4d9KIM3IoDq4Di2kGuAwBev1PpVtci4PUPdN/gArnH8LTSSeSqmyEgHmRgzzBeNUgx5eATu44mXKiQ4gviG9+1acscKkBDYfnDgUWEFrctvbJXNz3o9athcpkxSxK2YHXQMiAXgkgfmEuMqwOmbfcMTRVyG6Ayy5/DXhlHfg9RUQe/pdVVRRd/noKc3LWtDtiMw4zbku1P5i2/Ga1/lP47tGZesiOLwcTwSyXpvHXemSuPi/rpxbrZKpj5u/avtBLWDKRLP26DZ9plBkWykaqxrCsgcFFpiRSkdBosULRGpxEeX7b77pXXsaKjgtMplQw9fL4Ax3ZAuZNRaJzOgqDLQBID9/c288I+Q7pXNP7uSWrTpVhHPkU/6ferCqqudWI214gGmoZ2r3mj8uUrTvmEI7dNyG9fNM16fOIf1D6fM9+udgDf+n/YpBZRRMM63ZIBevviIoiBJ/G7m7QwpfSMLzpwFMyLWW0E/0JvohWmS6mg/iVcYqeKZIP6EWE6gwR+vV+i0Wdl5ZwDKaDOW0UZRwBeC/VvgTpXYX42KsISHtwrMw4ZsWhynqG5QJt8x5Vf7ucxPKgI4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB9561.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(19092799006)(23010399003)(366016)(22082099003)(56012099006)(10067099003)(11063799006)(5023799004)(4143699003)(3023799007)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L1QzYlFvend0TnpOaTZZYjd1V0pudkgybm1zNmxjampZQ0NwQWFRZDF3L1lr?=
 =?utf-8?B?OVJ0WTRMNkNHREdUeVFPOG5wa3ljUmtURzNzK3p5aStLd0dkWEhNdnRFKzFH?=
 =?utf-8?B?TE1VUzlpWE04dFprekNGK1BqRXN0OUdWUDVZWFVwdWdPa2k0ME96YzVVbk0z?=
 =?utf-8?B?RldJZDUrZ21nWWh0bnUyMHNnMFhjcjVhN3YvZnNROGNTVCtmelg3TmpPZEZw?=
 =?utf-8?B?SW5XQ3VhUzA1ZTdUYkk5MGRZTm9FSU1nMEN4VmlPUmpMTG9MT1JlOTh2SWpI?=
 =?utf-8?B?RE9BaVkwYjJ2WEthNVpXM2xKNWJGS2dZUXhuSnZVZkRmcUdISzZqVnRGZldp?=
 =?utf-8?B?aWpmRzhRY2NJTHJjajQ3aEdMLzRwK0xJcldYNDB3cXI0L1QyRU9PYnlTbGZE?=
 =?utf-8?B?T3gxQ0dZVFJoYXMxNDIvb0VlamRxbExOODNVQ3lwZnV5cVY1ZU41OEtMTmJG?=
 =?utf-8?B?Zm9oUlZjTXBuOVNGVUUyd0xBeHNKNmE0ZWJibUJraWpJR09rYmtGOVh6aFRG?=
 =?utf-8?B?K1A3OWNER1FkcDE3MTJxTzc0K3R6bW5pV1duVEVNczZoR2N1UzlBcnNQZVRz?=
 =?utf-8?B?MHV4WUtFd0RwVFRacGk2bWNUblJIRUhxUlVpdUlPQW9Jb2dGQzdNR2VZcjg2?=
 =?utf-8?B?M1c5dFdXcmNBbHNWMFpPUW43c0FJVWdOWjl5clgrTlRxQWlpK01ZdFJoTmY0?=
 =?utf-8?B?MWc5bFh1VWhkaCsxdm1IMjFjVmYvdE5WVi9kN2VXR0plbFBrTlRvYkJaOEhX?=
 =?utf-8?B?ZUZMUFlEb2lMZTUzZFRQcG5XTFlNOFNYQmdQT2IrWXduVGowUVpsemZwa21s?=
 =?utf-8?B?clcxamUwT1IwaFNmc0NNcnJwOVBEYVdDdmxVaUZhTW14Nlp2VytUaHNYRkIr?=
 =?utf-8?B?a3BmYlRDcEJsR2I5U2gxcEhKaGsvQVc0Yncwb0M5cisvcnRyOFpFemNvc0hm?=
 =?utf-8?B?ZzRPbDlRUDE2NzVZS1UzZHFkdlFzVkw0NE5qR096dnhNdi9SOWxXTmxUSU9Z?=
 =?utf-8?B?cTIrL3hrZVRBaW5BanA5NThJVWNSazN6ZFB1czF6cHVseExtUGljeXl1Zmxs?=
 =?utf-8?B?OGJnazVCLysxdTlqbGpZM2NVUVFtNjJncmlacFNHK0hwTzNYcUt4SVNqa2cw?=
 =?utf-8?B?aUd5UjVZMXExNGsxSUdDVklCOC9jaU5UcXo5b3NlSEhJaWt0TXhuTXQ1dGh2?=
 =?utf-8?B?M0FHbm1SWkN3VHRwZXRtaVp1cmZodlZ5NDRXa3F5cWhTZVdEMHptN1Q5Wmdm?=
 =?utf-8?B?WWttSUp6NzNYYy9qdk9kWHI3S3IrYUpuS3J0TTNLc296WGYyRkZHZnpUamgv?=
 =?utf-8?B?elBrcVFzSnd4TkJrSzhVL1BMbFd2ZThNUCs5d1o1SUpZWlVqQU9lclpjV2xO?=
 =?utf-8?B?RTcvMnk0aXVnaWdzenc5eXBmeTAyMG10Y3UyUWZCWnNUcUJVdmVrWldONGFL?=
 =?utf-8?B?TlduNTFZQXJhVFNCVCtUQTh4ZFFBVDNnalRpSmdEaVdyTjQ3elo3OXVrT1Nq?=
 =?utf-8?B?K0JiUk5maUY3UFdoUlVyWnhFckdKVUloL21UUVE2OTR4S25xOEdFWkUxM20v?=
 =?utf-8?B?WHZEYTVxMlh3aXppOS9lYzloUUsrUzFjcGxNYjAzdm1uVW43MzhpcGs2UDZG?=
 =?utf-8?B?enczQ291Q0dKK0kzZ3ZCUE9vbTkxTzBDU2VtdmZFZkNMQTFpZzdRZFExZC8z?=
 =?utf-8?B?K0lWZG8wMlVLblFWaisyekZaTCttVGlKMC9iNzFZRzlxOFp4WFo1MU1rQkNV?=
 =?utf-8?B?MnI3SmgzSXFtUXhEVk43dUlUVVl4c1JwWmxHV284M01DNWhONm9yWEFBZGw5?=
 =?utf-8?B?LytQcDBLdWsyYzdhd3JHRGVqcmVGcjhJbklaK1ZuTEJTaHpMVHYvL1gwTkNV?=
 =?utf-8?B?Z3MvL2lEeWNteEFZREQvRk5TZjQxTW5idCt0NzZhVXp6R05MVHVVZXlCSEkr?=
 =?utf-8?B?VjFQWW5CTTJyYThxblhqbi9CT1Rnd0U3cFVOVm5Db1hjMUN0bWlWV1JCcnJP?=
 =?utf-8?B?WkFrbDE4aktQVy9aam8vSGhrWi8wOS9SQUNUQVNWaEVsN3hHSnZXK3dvN3ZM?=
 =?utf-8?B?OGNaeUNjQTBnaSs4SnBhNTMyTnlLUFU4dVI1WUNkVkhuUGt1djBMQTR3TEhq?=
 =?utf-8?B?WHQvWk00WjBUK3lwUmM1Rm5UNkFCT3Fjb2lSYkJwdWhIRDBaaTVHMXB2NTR4?=
 =?utf-8?B?KzllUHZKSlZMdE5PTTNDQkdCYWp4UmVYSmRNczhKeG5wSktpcjhFVyt4M01V?=
 =?utf-8?B?NkpjK0MwQVM2TDBYVWVML2phZHVhVTI4RGtxUDM0b0RzaWY4dTBIVVBtT2RB?=
 =?utf-8?B?Y3FER05IYVJyL3Rwb3dUYjlzcW5vYTVQcjQ2SWlEY1oxTDdNZnJPVVFtWTBi?=
 =?utf-8?Q?dxP+MuHdnsWjgdvkJ+/V1YFJPclvxuL+VdiYqrNKQArUR?=
x-ms-exchange-antispam-messagedata-1: hgUBsxvhdX3H8byhUmM5KQQNDjVEYj/f0I0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C26D5D94ACB52E46B0DF08101E44DB32@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	guvITdh02A6ascbNCKz3ozXpFaupe6EUQNU/7rdCdvcaZfFPkEd5e7NlqRa4lpUNDgE8eKZi7sTLUY1zicwr9x57kVSgdQbRqE3LvV7GWsyUMN5C2ZXcvIXAxYB0L704oVhrKlhcVsLMh7/xxyGggK+Bk+8C75x7W1l9c5b1KjGjDqYt6dcj6mkBR8Pd6odJhBl9T5gHBhiSThpQOi9YkU2JpXjjXqIYxqLe1QfMG7EHQ6PoRdEbqgYCLXtXEwu7qugQda3TuAOJeuFwc4OwM9WSVvO/WaHW5O11q4VXQDqdxC7iXxuoa26mOb1ubZO0kdm+FcepEu0ZVjEh9WCIaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V4ugdE98loBVPW7mIkpCgcCzYfQjpFnxyZg2Tjf6/qbQIBM3BKjHwxHI1cWj6kmma/fTin1ODy1WNxmL00FNS85FIbFGQ9WVp3HadKCoXknaUZUYLGr5UlI0rjKYg6gdlAKBaedScBhGBSBQx63MEnK8cLHTr5Zd0HsgxqRLepliubyR5Ww9dmYl/qjVEtuKSzCc3MTtNipicCt0A8o5s9sxhgTmGnMbhGHt5FuC+y43r+vrHLm7iX6UuJ/CuJOPKN22sdgSBrwG98Td50wCH5uMKLa9zqHsfMXZtPPut1tro4piS63LPBhN+IUwd+gPhpyRJE9PkRsOQVfKBTZC7DHXm2x0MsA+9kBSRk4NyPBx8xT8jUUmWNJMNQnF6J0ozoB0fmhyrj4/27H4UQry4w5ztqt6On/NnjYhGZ8qIkT8jniJ5xbj1VibI4S/JERa4716Ctqu/31vnAEQe6GWDfL8EGp4LIokpzcAbdqeZpp+k2DElyMtwrVq5JLS+Mzsfk1AZK8sLGYnbffvm1ajUodo/7jme4V7mkFuNxkruTNtl1Jav4/jNU7cKEiekWBcUzJMgA5Lbfwd8h0mCrWxlo223wBjUo47E/w6lDEz5wcINUAZMyZvLA+NSrxYOL+8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB9561.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc606157-b645-4e48-c1c1-08df0a335423
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 03:19:28.0785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KwNDIwIwzKO9zkhzw67vnX5JrairEEx7M/A+U/rLTBIdm12aLy4IeUMJ7/1QfhkPURyhfjMX5OzEffynzSQ2sXKtoevQ7jICjH2bM2aKROY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR04MB10135

T24gRnJpLCAyMDI2LTA5LTA0IGF0IDA5OjEyICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gOS8zLzI2IDIwOjUxLCBNYW5pdmFubmFuIFNhZGhhc2l2YW0gd3JvdGU6DQo+ID4gT24g
VHVlLCBTZXAgMDEsIDIwMjYgYXQgMTA6MzU6NDlBTSArMDIwMCwgTmlrbGFzIENhc3NlbCB3cm90
ZToNCj4gPiA+IE9uIFR1ZSwgU2VwIDAxLCAyMDI2IGF0IDExOjQ2OjQ4QU0gKzEwMDAsDQo+ID4g
PiBhbGlzdGFpcjIzQGdtYWlsLmNvbcKgd3JvdGU6DQo+ID4gPiA+IEZyb206IEFsaXN0YWlyIEZy
YW5jaXMgPGFsaXN0YWlyLmZyYW5jaXNAd2RjLmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoaXMg
c2VyaWVzIGFkZHMgYSBWaXJ0SU8gU0NTSSBlbmRwb2ludCBidWlsdCBvbiB0b3Agb2YgdGhlDQo+
ID4gPiA+IFZpcnRJTyBQQ0llDQo+ID4gPiA+IGVuZHBvaW50LiBUaGlzIGlzIGEgc2ltaWxhciBh
cHByb2FjaCB0byB0aGUgTlZNZSBQQ0llIEVuZHBvaW50DQo+ID4gPiA+IChkcml2ZXJzL252bWUv
dGFyZ2V0L3BjaS1lcGYuYykgYnV0IGZvciBTQ1NJLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBk
b2VzIGVuZCB1cCBiZWluZyBzb21ld2hhdCBzaW1pbGFyIHRvIHRoZSBwY2ktZXBmLmMgY29kZSwN
Cj4gPiA+ID4gYnV0DQo+ID4gPiA+IHJlLXdyaXR0ZW4gZm9yIFNDU0kuDQo+ID4gPiA+IA0KPiA+
ID4gPiBUaGlzIGFwcHJvYWNoIGFsbG93cyBhIFBDSWUgRW5kcG9pbnQgZGV2aWNlICh0ZXN0ZWQg
b24gYQ0KPiA+ID4gPiByYWR4YS1yb2NrNWIpIHRvIHNldHVwIHdoYXQgYXBwZWFycyB0byBiZSBh
IFNDU0kgZGV2aWNlLCB1c2luZw0KPiA+ID4gPiBhbg0KPiA+ID4gPiBleGlzdGluZyBTQ1NJIGJh
Y2tlbmQgKHRlc3RlZCB1c2luZyBzY3NpX2RlYnVnKS4NCj4gPiA+ID4gDQo+ID4gPiA+IEF0IHRo
aXMgcG9pbnQgYSBob3N0IGNhbiBjb25uZWN0IG92ZXIgUENJZSwgZW5zdXJlIHZpcnRpb19wY2kN
Cj4gPiA+ID4gYW5kDQo+ID4gPiA+IHZpcnRpb19zY3NpIGlzIGxvYWRlZCBhbmQgb24gUENJZSBy
ZXNjYW4gd2lsbCBzZWUgYSBzY3NpDQo+ID4gPiA+IGRldmljZS4NCj4gPiA+ID4gDQo+ID4gPiA+
IFRoZXJlIGFyZSBhIGZldyBwYWluIHBvaW50cyB3aXRoIHRoaXMgYXBwcm9hY2ggdGhvdWdoOg0K
PiA+ID4gPiDCoDEuIFdlIGhhdmUgdG8gdXNlIHRoZSBMZWdhY3kgU0NTSSBWaXJ0SU8gZHJpdmVy
LiBUaGlzIGlzDQo+ID4gPiA+IGJlY2F1c2UgdGhlDQo+ID4gPiA+IMKgwqDCoCBSYXhkYSBSb2Nr
NWIgKGFuZCBBRkFJSyBhbGwgUENJZSBFbmRwb2ludCBoYXJkd2FyZSkgY2FuJ3QNCj4gPiA+ID4g
YWRkDQo+ID4gPiA+IMKgwqDCoCBjYXBhYmlsaXRpZXMuIFNvIHdlIGNhbid0IGFkdmVydGlzZSB0
aGUgVmlydElPIENvbW1vbg0KPiA+ID4gPiBjb25maWd1cmF0aW9uDQo+ID4gPiA+IMKgwqDCoCBj
YXBhYmlsaXR5LCB3aGljaCBtZWFucyB3ZSBjYW4ndCBiZSBhIG1vZGVybiBWaXJ0SU8gU0NTSQ0K
PiA+ID4gPiBkZXZpY2UuDQo+ID4gPiA+IA0KPiA+ID4gPiDCoMKgwqAgVGhpcyBpcyB1bmZvcnR1
bmF0ZSwgYnV0IHRoZXJlIGRvZXNuJ3Qgc2VlbSB0byBiZSBhbnkgd2F5DQo+ID4gPiA+IGFyb3Vu
ZA0KPiA+ID4gPiDCoMKgwqAgdGhpcywgYXQgbGVhc3Qgd2l0aCB0aGUgY3VycmVudCBoYXJkd2Fy
ZS4NCj4gPiA+ID4gDQo+ID4gPiA+IMKgMS4yLiBMZWdhY3kgdmlydGlvIGRldmljZXMgb25seSBo
YXZlIDMyIGZlYXR1cmUgYml0cyBhbmQNCj4gPiA+ID4gdGhlcmVmb3JlIGNhbid0DQo+ID4gPiA+
IMKgwqDCoCBzZXQgdGhlIFZJUlRJT19GX0FDQ0VTU19QTEFURk9STSAoYml0IDMzKSBmZWF0dXJl
LiBUaGlzDQo+ID4gPiA+IG1lYW5zIHRoZQ0KPiA+ID4gPiDCoMKgwqAgdnJpbmdfdXNlX21hcF9h
cGkoKSBmdW5jdGlvbiB3aWxsIHJldHVybiBmYWxzZS4NCj4gPiA+ID4gDQo+ID4gPiA+IMKgwqDC
oCBDdXJyZW50bHkgTGludXggZW5kcG9pbnQgZGV2aWNlcyB1c2UgdGhlIGxlZ2FjeSB2aXJ0aW8N
Cj4gPiA+ID4gaW50ZXJmYWNlIGFzDQo+ID4gPiA+IMKgwqDCoCB0aGV5IGFyZW4ndCBhYmxlIHRv
IGFkdmVydGlzZSB0aGUgQ29tbW9uIGNvbmZpZ3VyYXRpb24NCj4gPiA+ID4gY2FwYWJpbGl0eS4N
Cj4gPiA+ID4gwqDCoMKgIEFzIG1vc3QgUENJIGVuZHBvaW50IGNhcGFibGUgUENJZSBjb250cm9s
bGVycyBkbyBub3QgYWxsb3cNCj4gPiA+ID4gbW9kaWZ5aW5nIHRoZQ0KPiA+ID4gPiDCoMKgwqAg
Y2FwYWJpbGl0eSBsaXN0LCBhbmQgdGh1cyBhcmUgdW5hYmxlIHRvIGFkdmVydGlzZSB0aGUNCj4g
PiA+ID4gQ29tbW9uIGNvbmZpZ3VyYXRpb24NCj4gPiA+ID4gwqDCoMKgIGNhcGFiaWxpdHkuIFRo
aXMgbWVhbnMgdGhlIGRldmljZSdzIGluYm91bmQgVExQcyBmYXVsdCBvbg0KPiA+ID4gPiB0aGUg
aG9zdA0KPiA+ID4gPiDCoMKgwqAgU01NVSBiZWNhdXNlIHRoZSB2cmluZyBkZXNjcmlwdG9ycyBj
YXJyeSByYXcgcGh5c2ljYWwNCj4gPiA+ID4gYWRkcmVzc2VzLg0KPiA+ID4gPiANCj4gPiA+ID4g
wqDCoMKgIFRoaXMgc2VyaWVzIGFkZHMgYSBxdWlyayB0aGF0IGZvcmNlcyBhIHN1YnNldCBvZiBs
ZWdhY3kNCj4gPiA+ID4gdmlydGlvIGRldmljZXMNCj4gPiA+ID4gwqDCoMKgIHRvIHVzZSB0aGUg
RE1BIE1hcCBBUEkgKHZyaW5nX3VzZV9tYXBfYXBpKCkgd2lsbCByZXR1cm4NCj4gPiA+ID4gdHJ1
ZSksDQo+ID4gPiA+IMKgwqDCoCB3aGljaCBmaXhlcyB0aGlzIGlzc3VlLg0KPiA+ID4gPiANCj4g
PiA+ID4gwqDCoMKgIEl0J3MgdW5pZGVhbCB0aGF0IHdlIGhhdmUgdG8gaGFyZCBjb2RlIGEgcXVp
cmsgdG8gYmFzaWNhbGx5DQo+ID4gPiA+IGp1c3QNCj4gPiA+ID4gwqDCoMKgIGFkdmVydGlzZSB0
aGUgVklSVElPX0ZfQUNDRVNTX1BMQVRGT1JNIGZlYXR1cmUsIGJ1dCAoc2VlIDEpDQo+ID4gPiA+
IGFzIHdlDQo+ID4gPiA+IMKgwqDCoCBhcmUgc3R1Y2sgd2l0aCBsZWdhY3kgdmlydGlvIGRldmlj
ZXMgdGhlcmUgaXNuJ3QgbXVjaCBlbHNlDQo+ID4gPiA+IHdlIGNhbiBkby4NCj4gPiA+ID4gDQo+
ID4gPiA+IMKgMi4gV2UgaGF2ZSB0byBwaW4gc2NzaXRfcGNpX2VwZl9wb2xsX2NmZ190aHJlYWQo
KSBvbiBhIENQVSBpbg0KPiA+ID4gPiBvcmRlciB0bw0KPiA+ID4gPiDCoMKgwqAgcmVzcG9uZCBm
YXN0IGVub3VnaCB0byB0aGUgaG9zdC4gVGhpcyBtZWFucyB3ZSBlZmZlY3Rpdmx5DQo+ID4gPiA+
IGJ1cm4gYSBDUFUNCj4gPiA+ID4gwqDCoMKgIHRvIHJlYWQgYW5kIHdyaXRlIHNvbWUgdmFsdWVz
LiBCdXQgYXMgdGhlcmUgYXJlIG5vDQo+ID4gPiA+IGludHRlcnVwdHMNCj4gPiA+ID4gwqDCoMKg
IGdlbmVyYXRlZCBvbiB0aGVzZSBldmVudHMgYW5kIHdlIG5lZWQgdG8gYmUgdmVyeSBxdWljaw0K
PiA+ID4gPiB0aGVyZSBpc24ndA0KPiA+ID4gPiDCoMKgwqAgYW5vdGhlciBvcHRpb24uDQo+ID4g
PiA+IA0KPiA+IA0KPiA+IE1vc3Qgb2YgdGhlc2UgcGFpbiBwb2ludHMgd2lsbCBnbyBhd2F5IGlm
IHlvdSB1c2UgdmlydGlvLW1zZyBbMV0NCj4gPiB0cmFuc3BvcnQNCj4gPiBpbnN0ZWFkIG9mIHRo
ZSB2aXJ0aW8tcGNpIHRyYW5zcG9ydC4gVXNpbmcgdGhlIHZpcnRpby1wY2kgdHJhbnNwb3J0DQo+
ID4gb24gYSByZWFsDQo+ID4gUENJZSBkZXZpY2Ugd2l0aG91dCBhIHdheSB0byB0cmFwIGFuZCBl
bXVsYXRlIHRoZSBjb25maWcgc3BhY2UNCj4gPiByZXF1ZXN0cyB3aWxsDQo+ID4gYWx3YXlzIGJl
IHJhY3kuDQo+IA0KPiBUaGVyZSBpcyBub3RoaW5nIGluaGVyZW50bHkgcmFjeSBhYm91dCB0aGUg
Y29uZmlnIHNwYWNlLiBJdCBpcyBhYm91dA0KPiB0aGUgZmFjdA0KPiB0aGF0IG1vc3QgUENJIGVu
ZHBvaW50IGNvbnRyb2xsZXJzOg0KPiAxKSBEbyBub3QgcmFpc2UgYW4gaW50ZXJydXB0IHdoZW4g
UENJIEJBUnMgb3IgY29uZmlnIHNwYWNlIGlzIHdyaXR0ZW4NCj4gYnkgdGhlDQo+IGhvc3QgUkMs
IGFuZA0KPiAyKSBBbGwgUENJIGVuZHBvaW50IGNvbnRyb2xsZXJzIHRoYXQgTGludXggc3VwcG9y
dHMgZG8gbm90IGFsbG93DQo+IGRyaXZlcnMgdG8NCj4gY3JlYXRlIGV4dGVuZGVkIGNhcGFiaWxp
dGllcyBpbiB0aGUgY29uZmlnIHNwYWNlIHRoYXQgY2FuIHRoZW4gYmUNCj4gZW11bGF0ZWQgaW4N
Cj4gdGhlIGVuZHBvaW50IGRyaXZlciAoZW5hYmxpbmcgdGhhdCB3b3VsZCByZXF1aXJlIDEgdG8g
YmUgc3VwcG9ydGVkLA0KPiBvYnZpb3VzbHkpLg0KPiANCj4gKDIpIGNhbiBiZSBkZWx0IHdpdGgg
cXVpcmtzLiBOb3QgZ3JlYXQsIGJ1dCBzaW1wbGUgZW5vdWdoLiBBbmQgaW4NCj4gdGhpcyBjYXNl
LCB3ZQ0KPiBuZWVkIGl0IG1vcmUgYmVjYXVzZSBvZiB0aGUgdmlydGlvLXBjaSBzcGVjcywgd2hp
Y2ggYXJlIG5vdCBncmVhdCB0bw0KPiBzdGFydCB3aXRoLg0KPiANCj4gQW5kIGZvciAoMSksIHRo
ZSBvbmx5IHJlYWwgcHJvYmxlbSB0aGF0IGNhdXNlcyBpcyB0aGF0IGFuIGVuZHBvaW50DQo+IGRy
aXZlciBuZWVkcw0KPiB0byBwb2xsIFBDSSBCQVJzL3N1Ym1pc3Npb24gcXVldWVzIHRvIHNlZSBp
ZiB0aGUgaG9zdCBpc3N1ZWQNCj4gY29tbWFuZHMuIEFnYWluIG5vdA0KPiBncmVhdCwgYnV0IHRo
YXQgd29ya3MganVzdCBmaW5lLiBBbGlzdGFpcidzIHBvaW50IGFib3V0IGJ1cm5pbmcgYSBDUFUN
Cj4gZG9pbmcgdGhhdA0KPiBpcyBzaW1wbHkgc28gdGhhdCB3ZSBjYW4gcmVkdWNlIGNvbW1hbmQg
bGF0ZW5jeSBhbmQgZ2V0IGdvb2QgZW5vdWdoDQo+IHBlcmZvcm1hbmNlLg0KDQpJdCBpcyBhY3R1
YWxseSByYWN5LiBJZiB3ZSBkb24ndCBidXJuIGEgQ1BVIHRvIGNoZWNrIHdlIGVuZCB1cCByYWNp
bmcsDQp3aXRoIHRoZSBob3N0IGFzIHdlIGFyZSB0b28gc2xvdyB0byB1cGRhdGUgdGhlIGNvbmZp
ZyBzcGFjZS4NCg0KPiANCj4gV2Ugd2VudCB0aHJvdWdoIGFsbCBvZiB0aGF0IGFscmVhZHkgd2l0
aCB0aGUgTlZNZSBQQ0kgZW5kcG9pbnQuIFdvcmtzDQo+IHdlbGwNCj4gZW5vdWdoIGFuZCBkb2Vz
IHdoYXQgaXMgaW50ZW5kZWQsIHdoaWNoIGlzIHRoZSBzYW1lIGhlcmUgZm9yIHRoZQ0KPiB2aXJ0
aW8tc2NzaQ0KPiBlbmRwb2ludCBkcml2ZXI6IGNyZWF0ZSBhIHBsYXRmb3JtIHdoZXJlIG9uZSBj
YW4gZW11bGF0ZSBhIFNDU0kNCj4gZGV2aWNlIHRvDQo+IGV4cGVyaW1lbnQgd2l0aCBuZXcgZmVh
dHVyZXMgZXRjLiBUaGlzIGlzIGFsbCBpbnRlbmRlZCBhcyBhDQo+IGRldmVsb3BtZW50L3Rlc3QN
Cj4gdG9vbCwgbm90IGZvciBwcm9kdWN0aW9uIHVzZS4NCj4gDQo+IEkgZG8gbm90IGtub3cgdmly
dGlvLW1zZy4gRmlyc3QgdGltZSBJIGhlYXIgYWJvdXQgaXQuIEFuZCBJIGFtIG5vdA0KPiBzdXJl
IGlmIHRoZXJlDQo+IGlzIGEgc3RhbmRhcmQgd2F5IG9mIGV4cG9zaW5nIGEgU0NTSSBob3N0IHRo
cm91Z2ggdGhhdC4NCg0KdmlydGlvLW1zZy1hbXAgZG9lcyBzZWVtIHByb21pc2luZy4gSSdsbCBk
aWcgaW50byBpdCBhIGJpdCBtb3JlIGFuZA0Ka2VlcCBhbiBleWUgb24gaXQuDQoNCkFzIHZpcnRp
by1tc2ctYW1wIGlzIHZlcnkgbmV3IHRob3VnaCwgSSdtIG5vdCBzdXJlIGl0IHNvbHZlcyB0aGUN
CnByb2JsZW0gcmlnaHQgbm93Lg0KDQpBbGlzdGFpcg0K
