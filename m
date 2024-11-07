Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A359A1DB349
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 08:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730969171; cv=fail; b=oFYC8xRvNomoOD5FJ1wxnIDcPo1EboEUQJb0e9incS3g+Uv/S565Fjm79RVFzoTcrXPDjzwpL3HcP5GuZQ327eEcfTNRRLXOBu2MFdfWQWFameVmOj8C+hEXmZ0eMUbb1BRSfSujI588rQEb1eq8CujRzB5qBKrkHuNasbw4noo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730969171; c=relaxed/simple;
	bh=t5oxmQQAqXtqT2Kwvzy4URA8LeHMNIB+0lJXsqh+f5s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=otV2UQSudxN1bI2VP0kL+l4y+V2XfkKjs3hP165O5KpcRdeow6ImqX8C9iQzf/xt3Pn1MJ8nz7ESrzWtnu2HshoxsJlhNSdKE7S+0kzO1GoA9Qcbt+p7jD9q+5HmZMwrtSNiE9iJ0IeMaSUknMkUGUGDbBUrMYxni7n1bMPiYtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=j+v7Sugv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jZqfZkhW; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j+v7Sugv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jZqfZkhW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730969169; x=1762505169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t5oxmQQAqXtqT2Kwvzy4URA8LeHMNIB+0lJXsqh+f5s=;
  b=j+v7SugvxGBUWVza3rYOPtIKTLMFZ3K/10rvZQ6du2M7q+nU2SWrG0B8
   XmwvacfbRkKQyFr+etvOzKtf2vc/hwQsr0ipyIJ7Rai18wm+W4VH96nZ2
   RUOjLJn+oVpRD5CjNScSjmOI+4CY2YuPpdDJ40NTi2JqkgDUCrLTMDu1N
   bK6tW/sBUf2LlFE5JdG7b+3BiV+nKmldWv3BWmTe4kVyrR2mRl5/v8OBu
   VSbeRDVKdPPViA1/YTceOvEGTNno0glQDA4RJ73cb2wO1pOU8OU9pUQYc
   RUDybU8sHaeX+eO6pnu79/SYsaZoS1vCOPQpUbaxvo2Dqz3Z79aMUGZOQ
   w==;
X-CSE-ConnectionGUID: +rtUKQyER5eXRfQSzlTSIw==
X-CSE-MsgGUID: 04ltkCI+TiqeiwJKqDM9xg==
X-IronPort-AV: E=Sophos;i="6.11,265,1725292800"; 
   d="scan'208";a="31392333"
Received: from mail-mw2nam10lp2049.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.49])
  by ob1.hgst.iphmx.com with ESMTP; 07 Nov 2024 16:46:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lsgmk75/pefH6dy48/9YABXa1xnwZPNBnYpGRW7uwXe01EYSe7dwacPAnAK1KpA8J4FHFcGgthyAu0zG3sUtv6OLBL+zNb0yy5FSN2v5XevZUj4Ez0dPKYlJgmGsPNk+TbJFi8atSaJ+bqi5wug8LGd+8Skt8IksrVZKQ2v8CWpQuCMH4Xy+MwJWi2LngkUCR+GSTZPq1vlYvIyi7suqIzw+y2B+7KaMdOj+mVMF0zZD2FHVPHCxwFgL7ggQRzmkCZ3m1fu/zNspQD26N0Qq2q50d/ynR/9Or6rv2L/W1aO7SjpGGNzgsDlcYZUpMVvhLCUA7Ck8kQ4AYE+5g3jmwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5oxmQQAqXtqT2Kwvzy4URA8LeHMNIB+0lJXsqh+f5s=;
 b=YNtnh9axNMuf/5DSRpKtbIhVdJEQyyM+OgNo4asAGxw+CgF/d1yzB+uf+e96q4dPk+r4H9peHRFWpICzhxBsS7WhZ0yjs2JnIO8O4xV+m04c8JB0LI+WTwvONH9PNBaE6DZDvXQ/0JnxGDWEku8LvfwKTLBWNd9/q+vuP31QXTWJ4ArtGtGjXY0HhGlA5dvneIETPpNSdNtZo6gmomGnwz7no425Gak1wQ9caDflJukBlGA8JwsSOs9DipteS5DWkU9JrM7j7zAUKbAZGNNqEVPtoxMmJg0qXDWbWuloxk2Rg95Uae2KSxOUPNeqFDuLiCkSpzhZOoTQAiIHl0MqhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5oxmQQAqXtqT2Kwvzy4URA8LeHMNIB+0lJXsqh+f5s=;
 b=jZqfZkhW9d43unzImBdoAPz4q8EOLGAge/fZuQUr5YMJ8HhJ9Fl5wBBrx1DqGCVuZfCasdhlLbaXEO5Ej8aqoS9gfnMo87ZmpormuyhEQrgZMjBXpmix9SGIFX5HjCDoZ1LluPP0IqymBsIjOayt+4ngyetzuJiMajFdb5oDSW8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB8230.namprd04.prod.outlook.com (2603:10b6:a03:3f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 08:46:00 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 08:46:00 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Johannes Thumshirn <jth@kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, WenRuo Qu <wqu@suse.com>, Naohiro Aota
	<Naohiro.Aota@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones
 buffer
Thread-Topic: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones
 buffer
Thread-Index: AQHbKrtVwp8kiWr8ykWHdn/Za9uyTbKrjXkA
Date: Thu, 7 Nov 2024 08:46:00 +0000
Message-ID: <cfea0fb9-b361-4732-849f-baae9edeb920@wdc.com>
References: <20241030110253.11718-1-jth@kernel.org>
In-Reply-To: <20241030110253.11718-1-jth@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB8230:EE_
x-ms-office365-filtering-correlation-id: 10118251-7618-40cf-b529-08dcff089b22
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?M1JzanczeldzWTQ1SHpmQW0yK0drZGZLWFR1Qlg2YzFkbGIwMzRJSmxkbXdv?=
 =?utf-8?B?MmloVHVPbFBsdHo4bFdlUVhmaFpDUFNiakp2YlAzRXRCSEZHYVZWQ1ppUUJ2?=
 =?utf-8?B?SWlaRm94MlpQaFhMT3BsVmdzNHQybUg3MkxJUDBNaFhMNVZkSWVTQWdYTkFI?=
 =?utf-8?B?MHNDdHBDaGo2MzNNNjVGbGxNWi9YTVVCQTFYemRoZ1g0VU9LVnY1QXRBQjdS?=
 =?utf-8?B?RWFwVlBKZytCZFJMS0hkTWVTeEdpZzhDUjJqSjFVNUZRYU0rWVJ6cktqVlFH?=
 =?utf-8?B?YWZwUEN3RjcvZnVjYXZrSnpFeHdVVXFjc2llOVBkV2ZBZDE5eTZKb2Z4b1pa?=
 =?utf-8?B?QVpRV0x0cWhvWUw1V201K2dHczVnZm9hQVlFakN0d1k4K2lhaVJXcjRNN2Fo?=
 =?utf-8?B?bFdqOW12SlQyblRObEU2OHZTdVlrTDdHRjVCWk4vNlo0SnFOZGE5QUFzVFZw?=
 =?utf-8?B?MlphK1pHa2lJSisvSmpUNmZCZ2FhSzVuRUs2WjhwWTJHNldrdTFpcXlEOURx?=
 =?utf-8?B?aVVTNXdnM0paQlJDMmppYk54OHY1cWllYmhFenBoeldBdEZyaUJaeVdGL0hX?=
 =?utf-8?B?R1BhdkJXSnVnN1lyb0pqTHhFb28rbElTTFZ5VEMzRzQ0cDJRaGt5MHBPUFlS?=
 =?utf-8?B?eU5CZnFXNlEzNklMT2l3Yzc3cnkzUDlVYmx5Q2lqeDVkN2NvUWZRVnd1K3Fx?=
 =?utf-8?B?bmQyZVNxY1hjbDI3U09NR1dQS3BjVkRpNlEyYk1PQ2JoVE1vTVA2Yi8vQW5L?=
 =?utf-8?B?SjhkVC9LYzhrUWs2dWtmYlB5Q3Z2aGE1N3pVZHUvZitFZzNjZ05RU1duMjk0?=
 =?utf-8?B?V09tV2xmUTgrbndWdGlSUnFQMHRZZGtpZnh1aElIU1o1bHlnL3AzanR3dDJt?=
 =?utf-8?B?ZHNrNG5VbStZMjgzeS9YMXR4ZjV1SUFKbm95em1MSldyRVJMVTVHL3hpOTBJ?=
 =?utf-8?B?R3ZlVmZRZEtWTUNaK1lLd3V2bnVSSFNDYW5KMUZCbVhqS1BIejZXcEU3QWRN?=
 =?utf-8?B?Y3Bia0FCb3NJMFlZd2xTK1VYS1RYMmwyMUIwYVF1a0Z2MGY0aXdkYS9lNVEx?=
 =?utf-8?B?VHVLTVMzemcyTndOS0c1TmtpMWcwdjY1Q1kyYUQzaXdaRktYUUdrREhqNkNa?=
 =?utf-8?B?NkhwenAxVzB6WXduaE9uMmZRUG80QmUwY1dXYmVUaXlhNmpFY1QvTFltR2NB?=
 =?utf-8?B?WHExWDZLMHRudnVBRnd4SWtoYk5BK2FwZmFtVG5NWlorVkFBOXhyL1NPcEs3?=
 =?utf-8?B?c0czUEJpODVmUWhNSm5DQm11WWJLMnE2WEpSN0xsQi9nS1NEZ0F4ZnQ5aXg1?=
 =?utf-8?B?TExSeFg5MlVIbEI2am15YlhYN09QQ1p3VHRQZHdaUjdiMlBIUjRFR0t4U3Jk?=
 =?utf-8?B?SUhjRjVDZlBxSVNHUEVtNUtyMDVjWlJtdUdCcXhBcjYxQzY3SVBrdnEwZXRV?=
 =?utf-8?B?b1l4WktiY2h3bVF6TjhSY0hvMGFYVkJaNGs3dlFaQ1NmdjI2QWRqVnUzWFNp?=
 =?utf-8?Q?KcGN6A=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1NyUUJmaTUrdHpnT21QV2tNejNGVm1SU2lIN3F5TGJtbzl0MVNSOFVyYUky?=
 =?utf-8?B?SFFwbU5jWDJlcTlPQmppdnZtRFNSLytlMnlvUldXZEZzanA3QU8zOXNsenFi?=
 =?utf-8?B?cjMvb2J4bzhKeGlPZnFuTjRacW1kSTBmdTNJekxhQlRWODZOWkFvK09XdFhm?=
 =?utf-8?B?V3YxUHF5ZUY1TkUyUmZEYitYbkoyZ0M0dUNuWU1DeWN3eThVWUEvM0hLZlc5?=
 =?utf-8?B?ZFVHTlZpMURyeEtEOUlTU09TYnVadkVVblVvUVR2N29va1JRYjNvbkRUQk93?=
 =?utf-8?B?N21lcU5SaVU3enQ1bmlVZ0hEVHN4K1h6T0YvZXdEeDZyN283VjlYak5zVVlW?=
 =?utf-8?B?N3E5dEtoaWFyZjlRenE2YVVrVWxwMXpoa2paTnIraTJpZWxRUVNQODAyRmV1?=
 =?utf-8?B?RTJkYmFZWTc2bU00bk02dlVabFphNTBZUjUxQzBGUmVoS1VsQXNCNHkyekVx?=
 =?utf-8?B?T2VQNzJLV0ZpRitlZ25oMzVuYlpSOTNKblM5OFd1WmVNYXZuZkZyejlWRHRS?=
 =?utf-8?B?Q0VmWDVvTjhaK1c0L3NCTHE5QVhrc294eUZJS0dWRlRhcVhNcmgrWGtxUEsr?=
 =?utf-8?B?WkxsalhpZlBucS9JZS9NTEVwcFh6dlNjVS9sdnpLemtqejhERENuUE02Rk9Y?=
 =?utf-8?B?ci91eVB4Ym1NemwxSGpOc2tDTGFqWVpZZXdqNHE4ZDlydFhzSWxDODFvamQr?=
 =?utf-8?B?bHArUjcrQlVjeE5GU2xyLzZaRXJrTGFhOW1tTmFQUjhPSG1VbXNyV0lLU3lH?=
 =?utf-8?B?VDRyU0grZFJza1NlT1J4Q0lSbWVwWExFazB0cWUrRlAvalVUQW5aOGdxQ3Bk?=
 =?utf-8?B?ZjlpYmhMRm8vNFo0c2ZMRWpLdVBRVEd6RXR4R2VKTEh0TDlHYzRicUgyeHEv?=
 =?utf-8?B?dEFqMFBrWTZXU1RGTitwaEpVVkMxNFdCcVhzTnAxSnNzbmNtZDZRcE5FT29F?=
 =?utf-8?B?OFlTSzlKVXRGVGJNVGNHYVAxOWdQQlFmT2hzMFRnY1B0cXB6WWE0Vmg1NXdl?=
 =?utf-8?B?WnR3aDVXTnhZQjlJdzNCbldaY0hQSVpkUDFqNVVsbHVXbkg2Nm4vVllScXh0?=
 =?utf-8?B?TFhxemRlYU5MY2lxV0pnKzMvR1hsZjVQOW5rdEJvWUtrQjJFUTBQZ1pHMktT?=
 =?utf-8?B?UFExWWtDRlVXbHlVQS9MMTU0VzVCRHFyWE1icFVFQXMvWWw1VkNVY3N5TTho?=
 =?utf-8?B?RmpNMDVLbnJTbWl0bUMxbmZuTnQvZ2hOTmVYblVmeDN6dW1BbjlZeEN2NnR4?=
 =?utf-8?B?eEJtamRZQVBZTHJYaGJVSVI4Kzkrc05xU252a0xTY0pLcHFiK0pNQ0lIU0Nw?=
 =?utf-8?B?dndMdjl0aG1mYjJuVTFqVlF2NVNaYmQ0TWRBTUtNOFBQZDNjMjBLNjZ6YzBn?=
 =?utf-8?B?SFFrWXEvZmxjdmt5WWpTOTlIM09KS2JUZ0tESzM1VE8yTjArUjFNZFNoSktB?=
 =?utf-8?B?bUZDM0xMNmJHV3hhbzhFcVVSVWdOaFM3S3NkajViWXdiNU0xeGZpdndwZ1px?=
 =?utf-8?B?SHAvTTJrdVdZdUhJaDBlbStMeDVyc1BRSFVaaWhOaTFXd1JvdUVjeGR5Tzk5?=
 =?utf-8?B?UlhiZURrQWxrdGlFa2phWWxnQnB4VXB5Vi9aWHh2citiWnZmbGV5R3BzWVZH?=
 =?utf-8?B?TEQ2UlRyNnVaZEU3Z0RKYlJjc0o4SjNGMzFIdVBIRkRadkhmWmQ2Qm5NWFpX?=
 =?utf-8?B?cERrOVhnNENFbElydjJvMFYraDZKYzNBd05wdWNRbmZRaW9IZ3FTdWV1N1A5?=
 =?utf-8?B?VTY1aEhqSzFzOEQrQjB0NWw0VWd0NnhsbVVsWSsvS3hHUHR3SzVzMnM0NTF0?=
 =?utf-8?B?ZU8zbUF6anEzZFFKTjNncEZWeVhNWnEvZDFkTzdpam5sMDg1MHBmeHdtbXQ4?=
 =?utf-8?B?ZGp0UjhDZm9Eb09LK0xwdlpsL251Umg3Q3h3ajd2UGZYa3hoaW1hdTVVN2N6?=
 =?utf-8?B?Nnl2b3NLVThMeUt3aDlHRS9CZndkR3VQR3owOExUOEdkdS9qSFN5Q0hUZ1BE?=
 =?utf-8?B?eno3b3F5bE0rQmxJcGlabXRlVGFWT25ZaDh5MWE5WjN1dU54QXZwZ3M0Y2pq?=
 =?utf-8?B?N0lwSEhxMFRQUmFqT1IwZjdTWjFoRkoyWnlYNHNOb0F2ZjIxTXZsS3ZOb3c5?=
 =?utf-8?B?eENSa0ZmVktlUE5Pa2pqenNkZUdSMVZ1c0dWb2hwQUdBb2VlWXlNK3V2YzJz?=
 =?utf-8?B?OXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4190FC827B6DAD42A4C06CE444DAFF5B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gJkB9mcXMpoXUtMx7qLydji1bkQmwM2xEBpdVxtmypSQmmOePYARqwiurTKv3rkmSQpXTK8zv9bCdbsyTAHfJoFiuP/fN4UNapHAJOr7DYVKolOzkQD6gUJhWXTAIqLviRcg6MODix2wy7RdpI8mRGKmtgZJrUn5q5PUbktrns5JJwM28CoK4+Wbm8tnAg+PYMxwD1ymCohJ78PRUJGOUk7zZQUpDAWlmrvAMPNjc2B9Y9zz/KKGH7UrupN8EpS4450QF89VkGDEd9a2+sF7IHWQkr7mTSjDpwXTVihO8hVb5LTJLt7mD9RHr+yaO8KhfgW1M/e9iXqa77/q2XGtTEWAZfNXtFSD9h/v+qOnPJcRCdLgl2Uu/FKuKC9JUmm9BehE70/8wDPJm/Pgttt1gakrTKCGnkeuYqyUQnrLYRYh6UrPccPteS60k2HftxdLGrTHw9t0RhD/mpTun1vxenH42DgzlHUGCU6It4JVdIp0gSdcpc456xaJLRaiKjxmaT6rE8AsBH4jD55BtEut+N+unrcr0LNQGhF1XUxkFV2FFu208oysBy1zZtEPS+3kZLU5472UbXAE4SJ6JBQKp7EKzSOaSGcVcuPqQMxSyYNnpRGCMIdMHvTUNr2WUN+L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10118251-7618-40cf-b529-08dcff089b22
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 08:46:00.7281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: muy66sAeC+SKHYTqev9Yt+eMclzn+EPViyS/A0Zr7fu8ZEJ9ElHh4iBsEuuM3loKZAEkyvPkbdME8q0SeUeo3ITudQgBSD6xgcrdzZtv6hI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8230

TWFydGluLA0KDQpwaW5nPw0K
