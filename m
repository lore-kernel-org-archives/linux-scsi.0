Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C3202F8D
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729272351; cv=fail; b=UNz+PZQJ5GCQsG2ulGOZscfQdGRaGLz37UCEU2Ne5+/7p0Q2fTHg5uopAoSp+o96uUJ92GtKSyDHAvl5oFNVww7E+P9U7wUTI5bUREABiW0ZNcKJjuarR/6JYlhiApMFAlvYiA5T2EhmAHe43rwhpOO2S3UIheVKzq2ZAGjVZck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729272351; c=relaxed/simple;
	bh=kO0mKCNhrMUs7WbdRxJ+Zbu2C1yGEUhkavE8Lwyqrqo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VpWrLPEjV8Gx78G/39To9yPlNDdUMtuHctWqq3037jVfT/HAPCPe8giLyaKjYiZv3FoDUQg6Lcj5xkGHnWQm+aJ3F8vmkiz1esvyS7bas/aC5IpGvpzrIVaS+PNJthSchR2Dp9rPc80KK+5stajgm18LMKe40qPRN+fYo5c04wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZGt0EWjF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xc1UnmYi; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZGt0EWjF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xc1UnmYi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729272349; x=1760808349;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kO0mKCNhrMUs7WbdRxJ+Zbu2C1yGEUhkavE8Lwyqrqo=;
  b=ZGt0EWjFuZvUPTGik8H9Z0NlNsYLXE7ZbdgNEMHOVmgpjiTt5Q4IWJ/g
   OVfM0HWE5F+vNyb7I/mDrkGgPNoYyY7IKarDbXoloX/IwQHzmohqjHF9P
   kgKI8kLrGcHI4nAsIuIggBy6cs7rbCOzoO5cR2aQVpc+bFqhtDQrvHek2
   wY7y7jAnHNhtRB00TJmqDJg+WfsqaHfJK+FGW9679OLp0wZOfat3q/E1a
   eiG05sj/wrF7VdWcyXHOxTSiurYrwTe4YovhSkAkDsAUNwG0ZELN3pnfm
   djgNgPhLuiq7HpTBIlGWiVCKt/p64XtLyZhy1c4NZbFsTBNDIG5ev9LZ8
   Q==;
X-CSE-ConnectionGUID: gQXKhY79TLqRpoVfn8DOUw==
X-CSE-MsgGUID: qWBBwDt9Ra6fNXazdTE55g==
X-IronPort-AV: E=Sophos;i="6.11,214,1725292800"; 
   d="scan'208";a="29759870"
Received: from mail-eastusazlp17010003.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.3])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2024 01:25:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZjAr/7Hlu2wdwUepJgzkcSLGnX93+J1troikaGAuCdn8XZtvABZTVkIh/3Gq99yyor05jYFHDzKfWki1r6xSG2kfnP1ZNHGiC6ivTLavEGVdVd1/i2a0E0pliO4zm3usDQW7nc3kruGM6yDJnSxcbwYQghvw+PO/N5kklvRWhnQFAeRUFTrRDSp4BDFxWrYgYmZ8EsCnPJ7DmScAYiXCnMQLrTJ+qBRUPYfYMiRrbeXeT9XC8lxEWBohIV778C1sSkUC+0PaBYbITMyx8CZ95DM86B2FXgDupe8O4f3CpoenXfYyZE+Z7MJQXaAScz9VS2qYTUu+Nx8IhZGJRgVYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO0mKCNhrMUs7WbdRxJ+Zbu2C1yGEUhkavE8Lwyqrqo=;
 b=NNDmEYc/IyOTUgTklwYXkY+MCx98BMa2rfYXm7/LvL4I65feEMuIXvWc2dmJyubFiJDA0YIbgVOam9TtBHaUMW73Z4du3qNQbThZ49TiQ7c7kXNxzW5Z/YbwUWOzp28qEelb3kOtMpVztoZnGR0nHEsYdReIHwrQU/M/zWbqWkFkyU+fc2i5sx0cvkaiQHLhpjHfwdX+xzy5e8DwFLT0WAh4cLBzNzmbPTADM0NbB9m86r+riTT7382DQBmueFdtjQYX7nU8Z8TRhvyK2dMac+V4RxWHuH2qy4W7Sn1AMrlFBDRrX7lzxQuHqjEWHdlm24Pn+BFF6iMqBD4KGK4k8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO0mKCNhrMUs7WbdRxJ+Zbu2C1yGEUhkavE8Lwyqrqo=;
 b=xc1UnmYilZA/Xi3ETnaqvJ3/5GqAlIN/M1xMY/TGVOHjt22OOl1zL5kwl0yB/Jtso5zYMpsMFTc3KSQdx/cqLBFj05pz8Mt3hAX44T10nC6axJQB7OEcVauEQz2xm8+xfceKId/pYpWV13U+YqEJrN81LBSxuqrRMpBZY0m54gY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7159.namprd04.prod.outlook.com (2603:10b6:510:15::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.26; Fri, 18 Oct 2024 17:25:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 17:25:43 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Maya Erez
	<quic_merez@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>, Can Guo
	<quic_cang@quicinc.com>
Subject: RE: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
Thread-Topic: [PATCH 4/7] scsi: ufs: core: Fix
 ufshcd_exception_event_handler()
Thread-Index: AQHbIBAk173eioiIKUyIP1nJDoSWfLKMAlIggAC8UACAAAYE4A==
Date: Fri, 18 Oct 2024 17:25:43 +0000
Message-ID:
 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
In-Reply-To: <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH0PR04MB7159:EE_
x-ms-office365-filtering-correlation-id: 8057b0b9-3708-4ebb-5970-08dcef99e4ff
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eFdJczByRW9nOUtHV2ZPWlQyZTZsTWI2WjZFWkwwYVBNdGh2TGc0VnYwaEll?=
 =?utf-8?B?ODFnL0dwZWo5ZkRnVTFqU3htZmNjdjAyMWtkOU1nRUpyNlRqdWxjaU55QUNJ?=
 =?utf-8?B?bEVrc1hoME8rVW51Q3k5eVNmSW11WmpqeVdFUUNPeGIvNVkwa1hpTTRvU0FX?=
 =?utf-8?B?MllSRHdZK0FtSCsxMnVoRXgvSWozVXVKT3hJZXhwNTQvRWxUOGZ6Lzh0bllC?=
 =?utf-8?B?WTJlSHY3U0hWbEx0MFdDMEIyTzJocDBOVGhhZnNOZFpObnl6cFUzVllwdElZ?=
 =?utf-8?B?alBuL0swRnZZTUlBbGpuemZHSlNxWDZEREI2eXVxR0NCdXlnTFJyczRkWTRD?=
 =?utf-8?B?d1poeFduNGdnR09YRlJZemlta3BibFN4c3BpTFlqRlVTMjlXUysreHpJbGtE?=
 =?utf-8?B?TDk2MUVMUVNBWkIxcVI5ZkVzUjNMRWJVRU5rS0FTUE8vUk5YYml4L0tuRmRu?=
 =?utf-8?B?aFNmS3VxMURNYzM0UlVQaFd5YmtmWThHQ2NlN2NrWUQxMGIvZi9xWTJ0Um1q?=
 =?utf-8?B?VjIyUHA4SUliaHV3V2tXaDJFalJXa0RMRmJlZi9EdFREcCtMUzdQdXlNRW84?=
 =?utf-8?B?UFB6MHpGT045UXZpNmpiWWk4M1pNcEhMVEpGcWlkVlVmNGFNM0hMdGpxVXJ2?=
 =?utf-8?B?QjZVbUxlS05wSlpkZEtYNGlIU1BkWlpxd1o0bmtLa3JVYklmZ1dIc0V6TWQx?=
 =?utf-8?B?ZzBqcXFaNXF5Z3dLbnloaTQveTdORTI2WEpmS2pEcENuckl2Z05VaU0wTzRI?=
 =?utf-8?B?a1granpaUERQUXhrUkFBTUFIVFRneTFnMHNPMzZqMVM3a0wzbVp3a0U1UWYw?=
 =?utf-8?B?NTVVV1pnUHF6R0pnRWVsL2tIYjhTK2xJMXl4aGhOZW1HZ0VRZHpPTzhXWllv?=
 =?utf-8?B?V3JPaEY3YzVLN2ZnTHdjTjdmWEdjWmJXS2xPbVY3eVNPQUZpMjhCZlpqekE2?=
 =?utf-8?B?bTZoNUZjQmVGVzArMGdSQlI0OUtHamMvMTBta2ZOcituNkZXeU9GRW5EekJo?=
 =?utf-8?B?Wno2TEhVWUw1ekt4MzhwMU5ibVN2L2ptTlVLRGtCdUR0RWlzUGlIbHJhNDla?=
 =?utf-8?B?b01ka2Qwcmh0ZzBtZXZYeWw2dU9nRFZCMEUvYTdlelc4bFBhZG5kUzdzRGdz?=
 =?utf-8?B?Q1JUQktzditjM21UemhVRVpYQytmYnd6QmxGWjN1WlNaR0piMnBxWC9LVHFv?=
 =?utf-8?B?QVZkNG5hTmtLUFZoUGVWZFk0V2x3Slo0emhFTGxWcnVUbkNiak5ZMFIyNTJq?=
 =?utf-8?B?aTJ1Vm82VXdxOTUzSW5ZTEtnWHdNZVR0WnpnbG9JK2JKRVpTSndSYVJmNXNM?=
 =?utf-8?B?Ymc4QVJCTGZ1alR0ZklHRHlHZkdjRzFWeXJaMk9QbkVWbjFlR0ZtV3pVTkl1?=
 =?utf-8?B?OWJhRVNOaEhKSERQZk5CMnNNUFpJUitUdTc3aFdkV0JhMnYvbXY0QVllRnhx?=
 =?utf-8?B?ME9FbG9Tc0VHTVBhZmg5dzZTOHhCWlJaMHlnay9JM3U0ZXl3NVg5NmM1MzBv?=
 =?utf-8?B?bk1RdGVpdzlmcSt6NGQ0aDJHUUtNcjBuaVVGYnJzL2VlNk5vajhuYkd3ZlBY?=
 =?utf-8?B?Y21CMUl0VVo3YVEwcjkrd0kvN2I4aDVFZEsyaDNvem5BNTlOSjZ4WjRoZzBk?=
 =?utf-8?B?am9hWnF5dm43Q0Z5NE5iWCtCM1NKMncrbDJRZGdBRllSTWVWMW9TU2tteDNQ?=
 =?utf-8?B?cTV2YTV2a2VkVVUrbk5jTE8xOE9iVW9veFhzazAxSzd3NFZLb25JVU9raVpB?=
 =?utf-8?B?dmNqUkx2dnVOaldVQ0JnQ0ZYSk1mZFZ6d3B0cVc4aDZyR2tWRS80bEdJQnBK?=
 =?utf-8?Q?1RFAupM+vzw4UJo4yufDMjXl8BHQ12EY39gmc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?KzNZZDQ5aS9udUNvbEd4MmhoRmxqVnJFVDBpdFhUbHpXSlBrYkE4QlQ2NmZZ?=
 =?utf-8?B?WmU4UnNiQnhvcDYxK21XSEw5VFJUeTlCbnRHL255Rmw1OVJVZzFrOFIveUFK?=
 =?utf-8?B?SGw1cFVIa3BOV2I4WmxKQW1xZUV1blplbDF1R2xqR0dGaXB4dk5ydHRua21w?=
 =?utf-8?B?T1Vtc09xejZCWEhucUtWRlZWY256cTZ5dXZaUSsvaHprb1kyVmNtYWhMQ2Y5?=
 =?utf-8?B?MWpoWDkxdFZhWG1VajJzaE9MdFZCb2xYNit2Qm1iVlByT3J3eUlSdVd5U0sv?=
 =?utf-8?B?M2NzZFQyY1ZJTERBTjgwNkh2cm9lWForQi9Pc1NMUWZIZHNrZm0wQmM2dmVJ?=
 =?utf-8?B?ZFJRZDRUUmN5eWxFYzdoTEEvcDBWMkZ1R3UvakIwc05haFpWQlJ0Wkl3OGI5?=
 =?utf-8?B?VU9WZDY0SkNmd1ZHKzlQUkFrcVNpV2R6VWtnMnhYWjltTW9QeEVtOE9hVXds?=
 =?utf-8?B?TmdWUXBiZHQ0dW5LZVZEdFF3YXJiNVphOXdBOUQ4NGtxU01lV2xBT0l3L0Fx?=
 =?utf-8?B?TDh0aXkzNTZBWStaUU14bE4wWnFKemVyK1R1blpwWlR3WkM5ai9PdVJ0KzBx?=
 =?utf-8?B?MUJDeVZKZU1kNmw1YWw0b3RXYTNUc091QzQvVmpJSlNualFaT20wYm1xaHJz?=
 =?utf-8?B?MlZtY2dwMUtDYUc4L0Z1MGVMOHhrOEQwVVVnRWtEWFlRMEYwTW9CT0pnOStu?=
 =?utf-8?B?SmhqaU5GTkdXdHZPVmorRVlPelF5VFhUK1VKZlVjMlZueHRKVGIyQllyZ3U0?=
 =?utf-8?B?TFRHVnM0Rkt3aThXek91RTNVcnczbEpkamczbklJdytvRXR2aHM3TFM4cE5r?=
 =?utf-8?B?V25kWHk4clVZSHQ5b051M2ozckpwNUExUzg3dGIxU1U5NGNGMmVNZG1lS0JX?=
 =?utf-8?B?VmRDbTh6emErWDVCVE85RGRHZEVDTnV3L3hyRnVVL2pQbXl3ejVNRFJNejJ5?=
 =?utf-8?B?eUpacDlCUWgzOUx5aTM5NE85OG90RkloZ1RPVjNyazFkUEYrUnV3RXYvSysz?=
 =?utf-8?B?eTNMbmdtaW9aSmtKOWNkNkNsNXUvOElESTcyWERUenZHTmdRNS9rZ0sweVFH?=
 =?utf-8?B?SWhlZloyRi9qWHJhdVk4ZHFGMGhpVisxTVIrRThGWkFsU0VkQ05NY1Btb3Zq?=
 =?utf-8?B?SGRRbEFXZkxCTi9BQnpLb3JOd1ZYQWYxRldGYXpTeFIwVEhLNzM3cXpOMmN4?=
 =?utf-8?B?SmZwQ1FBcnhhajJURkRCSFF5bXUwQlhuUmJSOHRnWUJ5Wi9KNVdKSU8yN1RF?=
 =?utf-8?B?YmVRTzA2enBMbGVReFhUV1lXeW1KUXdvMmp4dUkwdVpiZzRVZVZ4UnBpMGxq?=
 =?utf-8?B?NWM4MVF4UjZMWFBaWFg2MmZaV2paVzhucGd3akMxVTUyTlhkRTQvUExFcHVx?=
 =?utf-8?B?dnkrZ1B6MjVCSWxiZ0gzLzdvL3FTWkFwbUZuaUVFMjBkTzhGYi90cGxoc1ln?=
 =?utf-8?B?YTJ3ZUsyem9UelNSSDZiUXJQZ2xsZ1EzeW44M05NTlFrcmhOSGMvODhsV1lR?=
 =?utf-8?B?cExNbjBzczBLblp3UnVFYjF4N2xmQzMzQ043WEdqVmFZa3hnRXNCc2x6eXJT?=
 =?utf-8?B?VXFja0FUWlIrTGZtN0pxTGMyb28vbUI4ZnlTdWJleTNDeVNMNkw3SS9meFBD?=
 =?utf-8?B?MUZkWTRzTmtBMS9FM3h3SC8wT0VqaXhpckJtSlljWitqQVdPdmx5WWhTblZi?=
 =?utf-8?B?US9Fb014Y0Y2ejQ5MnJGUUhVNXlqOEhCbTd4TGRwY0lvSE90Q2VmeTkzK2VS?=
 =?utf-8?B?VXNpcDFZQkNGTDZWRlNlaitCQ095VTFHT2NBWmlzTlo3TUxoOUljaFlqY1VZ?=
 =?utf-8?B?bHVHeEJNNUdhTHQzRGc0eTBhSno2MnVJTUdmcEpla2VORjVRWGNtUDZPNDdS?=
 =?utf-8?B?OGJhdUp4M2R2MldVS2VCL2FrS25PdXliaVB0dmZGMnZZZTBDUTZZWUNDR0FM?=
 =?utf-8?B?WkRPRWFJT3BGNHNxdWRKVmZ4cEo2S0F2OGxsUjlvWHpzR0RqNGluUCtOckRm?=
 =?utf-8?B?VlEreW9PYXljTVlKMHFhVHFFWnYzUDEwQnRDS1hSR2FwR3dsV1BoN3JEQ0tR?=
 =?utf-8?B?QzAzM1BEOTFjWGVGdEJGcGIvU2QxL2IwVnUzZjBkTDNCa2U4M0NrMHViQ2Vl?=
 =?utf-8?B?V0UvZmdSYzF5VndEclBUOVRkNm5RemRkaktDTWc0NTFBbk9MWC95SDhOVUNt?=
 =?utf-8?Q?bD7iOlpJGOH1UM35mXUL8pjhoXqRRTG8X/7ILZE34jPg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FlgP8uzxvYeLj6u+NjQYEu32GEmeI4KqBW8NEUYvmOawFNzdONC+D//Dcm11Wb2ySEYjKD1BNdrxaNhU4OA8TMrGDrASODGVfTxqxFMroxRLFVCdBmx52Fy9IcejZ6FnCRXTMUFIiVwN6jaCKAid2lLfFFjbXcNHDBp47tuh4acghXZ7NYthGsCbylz26GafdMunlm3U1z0j+YO8j4jOEbHlPs41V/urh1OyqubWQCmDRqbNFcm7oPWD00y9XMmTZtGK0dnCJ/B9NmDvGgq1VvNaiwVwcf1fW/TXKy/3iX2N8dNE5g/3Zb245TALw+oV1i1CrBE8REz9Oh8rFY1G8iDnadUyNM2Y4CgZ7ceaBQ9l1B8HqtOUdwvTeKEVpfOLH5qTLV2KHO2hsQ4gmcrU9GA3nCGNdUc2acTsa/TsKAmCIz2FzdkwG7PUiMt+jnBzdXlcSXc0r8D8kVz/acArkqGWV+8P7wAbQmeYZgKNUw8zcIBA0Q8+6hgQJgbAbnsEp3IZIQNJCWQY9eLvn9gumgZJbVDnnfVvPAQCN7Os/pagZFftOBrv4b19RJTqzd5OXEbiy1mAztKsa/W6SWWGdRB4hX/Nj5H/penahdRWtVoecfDXUunmwrsZ9ub45rZk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8057b0b9-3708-4ebb-5970-08dcef99e4ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 17:25:43.0661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3N8h6SLRyKeZNp9Vg3nSLWwdBGGfZ9Xr/NcTWNFQrt+Y4/529likDaHKcu3W68Zo191/1D1vbZHayClxADdUmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7159

PiBPbiAxMC8xNy8yNCAxMDo1MCBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+IFVzZSBibGtf
bXFfcXVpZXNjZV90YWdzZXQoKSAvIGJsa19tcV91bnF1aWVzY2VfdGFnc2V0KCkgaW5zdGVhZCBv
Zg0KPiA+PiBzY3NpX2Jsb2NrX3JlcXVlc3RzKCkgLyBzY3NpX3VuYmxvY2tfcmVxdWVzdHMoKSBi
ZWNhdXNlIHRoZSBmb3JtZXINCj4gPj4gd2FpdCBmb3Igb25nb2luZyBTQ1NJIGNvbW1hbmQgZGlz
cGF0Y2hpbmcgdG8gZmluaXNoIHdoaWxlIHRoZSBsYXR0ZXIgZG8NCj4gbm90Lg0KPiA+Pg0KPiA+
PiBGaXhlczogMmUzNjExZTk1NDZjICgic2NzaTogdWZzOiBmaXggZXhjZXB0aW9uIGV2ZW50IGhh
bmRsaW5nIikNCj4gID4NCj4gPiBJIHRoaW5rIHRoYXQgd2hlbiBNYXlhIGludHJvZHVjZWQgdGhl
IHNjc2lfYmxvY2tfcmVxdWVzdHMgY2FsbHMNCj4gPiAoMjAxOCksIHRoZSBibG9jayB0YWdzZXQg
cXVpZXNjZSBhcGkgd2Fzbid0IGF2YWlsYWJsZSB5ZXQgKDIwMjIpLg0KPiANCj4gSGkgQXZyaSwN
Cj4gDQo+IERvIHlvdSBwZXJoYXBzIHdhbnQgbWUgdG8gaW50ZWdyYXRlIHRoYXQgaW5mb3JtYXRp
b24gaW4gdGhlIHBhdGNoDQo+IGRlc2NyaXB0aW9uPw0KTm8uIEJ1dCB0aGUgRml4ZXMgdGFnIHNl
ZW1zIHN0cmFuZ2UsIGlzbid0IGl0Pw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywN
Cj4gDQo+IEJhcnQuDQoNCg==
