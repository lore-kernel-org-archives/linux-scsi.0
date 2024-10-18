Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A6A20E30D
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 05:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729228974; cv=fail; b=r+jDHC4xYbOtYUnfPit1dg8+eSt+0npSeDZXMiqMmpm8kkQagW+bDab6Jii9wlpJaGwibmyZClysGPjWhGuF1g70+WfEuyCmyhbg6DsT9arybaVpuguFY3mJS5Nz7ZA9wSZweKWJVGb4XuYEbSULg7zDJnJ/jMEwE5Qi2HyXYkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729228974; c=relaxed/simple;
	bh=sSydoS9YnmapNNl6HHVA5/c5tkWeRsG5xvp+sVfk9/I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HueeJ9yE4xB1ZvMTkf6kuQGocifsk6DxNLdMqjAMHiV9ZwRpW58DSPfYDhfHNRxA9aEIwHT+fdaXD1OMB1zh1cSa9XnW4simEK8wL9tTSaJVyRtLbaZsJsP6bLFPfrBcc7uXm9mJeqDGn8ly8I5ln4iK8nUJmJ7+63RMQxIN318=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jqg5bueU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Uiu7lv3D; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jqg5bueU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Uiu7lv3D"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729228972; x=1760764972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sSydoS9YnmapNNl6HHVA5/c5tkWeRsG5xvp+sVfk9/I=;
  b=jqg5bueUSeRT+f6izt9KOxrF0Uo67llLiZndLMsZV4ZQmNEmgLi0hNSw
   /kuAC4pCXZAsYYEJgmV1T2kNedfvHJN2l1j7KItZVJKMctOLRCOoMyABs
   HQ0DxIEAHldr0S4Xj387FglyE9aMwygl5jq5xVPUMTZgy3R2e/IW2tPuQ
   YYSXE9RRrqXA/VNh4vm1brE9Mk/VyJRTYAiu9PxjAHQ0zyQf9H7Zro4Og
   bIVbNoBTFh9wPPbRa0eotfDSv+8ndMjEUH035CiZiedvTzunhEqcf5EOX
   9Sa7rcLsch1glVMr0TsQg4R7k0pxuCt7WKrz7MZQ1acmEwWro1r3uq6Xp
   Q==;
X-CSE-ConnectionGUID: nWreR9A9RiibUHeEPjYBTg==
X-CSE-MsgGUID: UdwlIvOxRo6HwmsGLCcZKQ==
X-IronPort-AV: E=Sophos;i="6.11,212,1725292800"; 
   d="scan'208";a="29245252"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2024 13:22:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EM73qgfD0R+kg0dBQkart+faP7b5U8AYkAl0GATHbJ539IJeGFUUqiSvBACD2YqTL54neqyFkCU6CblPIM9OuzFdyb8yxuH4riApika5wj8+MbElxsYmpVu/gGyLYy6rXYmUEsA1S5q/ECIG6K0W1y83W7SlDeqsnIlubYlj0YQfPebb7CW4u4l6Pl25XbnTcrQ87L1LgxRcvZ/BpTHXDRbOTwAJb1kDXFeo+wBgIJFQhMPVtW9kXbEY5B7FXFJWhOblOTKfY/y4cF6D0tKooxloKk/Ba1XHpZUz9mZueqx6Ns2PjzNC/yQoL+V/IhQzuFFw2Owzmf/IiZu/F4L7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSydoS9YnmapNNl6HHVA5/c5tkWeRsG5xvp+sVfk9/I=;
 b=nEbmAVN8zPtE+ADHWfhq8DJZz1ttnKdT4UslASoeZOmd6GaWDYgalkiSr7nmSPCt9kHQbPOmQEFPSsqXpwgfey0751v8Ghbpuil3K4we/7MsI+E6qQj2VtSeGeijlUNtXo7UtTyfKjKflgmdogaLHhRqMyis7q3a3IoDGE+fBKLUFSwSJz0pfqDeQnJEYxm8c3+kCKT0OGQP5M/aB5mWAeeeCNR1Y0m7gDpIHDcp2nh+qaEG89lD2BTv39YciruM27KIzygEDLGWoApxPlvAFP/GQzA5tjchA+taViZLAcp6auZ7Sm6fbS4REjRfQIrF0uWIP3YYh913BkvpP11vAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSydoS9YnmapNNl6HHVA5/c5tkWeRsG5xvp+sVfk9/I=;
 b=Uiu7lv3DH4nhwweQ8goqXIyKaVetgOFBqM7TOwWezlPdF95FODTKRTxkFt8JKEPS3EZ8o3isEvSTnqkbh5zOf5C0W9GK41d+2rQhZSu9ValgxS1Y5eS4nEn9sbnZQocX5s0qow3WA4zcFHqT5FrPjaXCZYj+hpP5K7rlCR/vhy4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 IA0PR04MB8836.namprd04.prod.outlook.com (2603:10b6:208:486::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Fri, 18 Oct
 2024 05:22:49 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 05:22:48 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Chanwoo Lee
	<cw9316.lee@samsung.com>, Rohit Ner <rohitner@google.com>, Stanley Jhu
	<chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>
Subject: RE: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Thread-Topic: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Thread-Index: AQHbIBBBWZ/scSktVkqDqxLsXwv7OrKKgX/wgACy3wCAAAcykIAAO5cAgACD57A=
Date: Fri, 18 Oct 2024 05:22:48 +0000
Message-ID:
 <DM6PR04MB657598AA1F5522FBD7B529A1FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-7-bvanassche@acm.org>
 <DM6PR04MB65756D0B96314EF126162948FC472@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d97543f4-f394-423d-9ea0-819ddaeb7749@acm.org>
 <DM6PR04MB657523DB92B671DD8F06723EFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
 <879075a8-998c-4e17-b368-6023ec960d9b@acm.org>
In-Reply-To: <879075a8-998c-4e17-b368-6023ec960d9b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|IA0PR04MB8836:EE_
x-ms-office365-filtering-correlation-id: f186c547-31d7-40bc-6c0b-08dcef34e7fe
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eEwzZXdwc2xNdGNWSEVMRDl3Rkd1MlhyOS8yVTh1VVpiUEZwU2M0dDJZT2Zl?=
 =?utf-8?B?Rlh3OXVhU0VhYVBFMzk2MXdhZmlsY3pzamF3bDJYWnhLZittNUx5SEk2SlZ2?=
 =?utf-8?B?eVcrOS9RSXlMSG9wVXhqWFBXZU1HQkxjRkFRT0h2ZTVmNUhmbkgyVEhtNEZu?=
 =?utf-8?B?bW9RcVBsSWQvbVlDT2EvbTRTeFBFbHVJdE5KRW1pZzRQTUVGdmtJM3dBRHNy?=
 =?utf-8?B?MTAzVDZzczhBdi9aR04waS8rT2pBcXpGWGE5bTlBcHZqeExYMFJrZnJCRFpt?=
 =?utf-8?B?c1pvQStuY0xBcmlXRW5NblpKN2JicGpZbFRZS0VBYWthbHNtUjVQaDJPVXV1?=
 =?utf-8?B?bmFkM3lZV1ljWWRrTXNXcHV6V085Z04wcFJ4dTBtdUhGODZrQXBxam1GdjdM?=
 =?utf-8?B?VXdqOW5rMVhNKytRR0RTYzBMWnptamhIRzdBL25VYXdjUzEwQ0tGSkFjcjVo?=
 =?utf-8?B?M2dSbVJtQlhCajhTNWR1a0R6ekdFeUxGVjdPOUZvc0JhbmxvV3lMMzIyVzNX?=
 =?utf-8?B?RGl4cTVJT2JIczZDdjRveWlwZHgyQzJRY0QxWW01TnZOaDYvdlU0TmtHZGFu?=
 =?utf-8?B?MStxVjBjdkNwdG9VdzQ2VDFmZDI5ZkNPNTIxNkN2a3lTS0pDM3RuK1I4MnpM?=
 =?utf-8?B?MVlCREpxNEJ3STNyelMrTHhUajRCOEdJWkl4dmdmcy9ubkRSOEo2TVJFTnJY?=
 =?utf-8?B?S1I0MHpaTERkQ1BSRENldlROVEg4M0E3UU90clpPWEptUC9ITXFaQzdzMEFw?=
 =?utf-8?B?WC80RFpwRnByYzNmaDdLUVpHNkhXMEhkbVRyNlJXTmUzQVducUNOaWUyM3lw?=
 =?utf-8?B?R3hwVjdGUFlxOCs5RnBwcW8rN2R5VDZ0VWpjanVmbHZWTk1RVzBQWjA1aVhF?=
 =?utf-8?B?b2djRVMzR0ZCb2xjUkRDcXBtYXVzMjVuOUFLVFdHenY5NVpjMjRvaDRKclRz?=
 =?utf-8?B?Vk1BSUlXRDBkZmUvMDhuemQ5ZEhrZVYzTENIT3JqQ0M1Z3pzU01XM2RVS2dI?=
 =?utf-8?B?ZnlwZ3RMTjFIeVZYNloyWmoweVdCNTNrZVFsV3FDS292VERUWEZFYWVaYlBy?=
 =?utf-8?B?L3VxMzBqaEl1WW5DRldYQjgxbWI2RVBIMW1HV1pYT3lBazQvNGZsWitsK0pM?=
 =?utf-8?B?Vm16MDcxOW9XY0ZKU2dtUnBhMHkxa2x0UDFhYXBRNm8xZ0JOejdMMnk5Smxx?=
 =?utf-8?B?bEF2U0xjUitGQTFRU09BTmRNWEF3YVloeEpRZ1d2SEIyQkhSb3laNE9jejhO?=
 =?utf-8?B?REt1em1NbkxQaVhCZllubmFHbmE0UWU4bTU4anYycVFzQzluaTRncFl4ZllR?=
 =?utf-8?B?YXJOWTZBSjkreHVSUjc0L3NKdVRyLzlNWnFkT2sveFByNkhGOG1WSVhOdm9i?=
 =?utf-8?B?ZW5QMGpyWjFFRkZXakRhaFpxc1pCVzNQUmFSMys3N3RIVTg4OW5wOVBJMWV0?=
 =?utf-8?B?cHJMb21tTlkyWTd5Y3hTZDl3NzR1SDc2Y0RKQUY2N0orbFBQZWpVdHNzNzRn?=
 =?utf-8?B?MVZPYnlwT05uZm9aMmJGSG04cnJnanYvNVVIdjJHdWFXN3lIMExEeVZ1UFdl?=
 =?utf-8?B?MU0yajN0VnZUVFdYNTdBWVRGU2RsQjl0bGRKM0pzWi9RbDlHWWxRYm55SE5I?=
 =?utf-8?B?YnhWeHdMVENEVTg2Q3p5eXFlTHlEdlV6cUU5NW5rZHFVZDhEakxDSDlzZnJu?=
 =?utf-8?B?Qmk5ZU1DMHpYMXFiUnJSMysxTmRjRkduTlhvaXM2ditHeHM2ZiszdWc2R3VT?=
 =?utf-8?B?Q0U1S25odmRISmdFMWtTOUVEcjV0N1pmZUJ2SlhzRFBhczczZmw0ZEJzQUEv?=
 =?utf-8?Q?rQVTAhk/nXxyOZJUB87pyK6UDqI449+o34w8s=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUVDUkIxNUZPS0Evck00M3V1S2kvc1VreCtDTE1FMGdYakVEQzNjcHJBNGFL?=
 =?utf-8?B?T1V0Y2RoczNnbStUL2huY2NPOUtQaUVWTTJ2NHRPcUhrL3lWWTZvV2JiWkIr?=
 =?utf-8?B?bVNxOWh3Ykk5VFRUQmdIenJzM3ZFZDFVMG1Kang5ZHRDeGZwc29tUjN5S2V5?=
 =?utf-8?B?QWxmT3dzZEk4SFQxeFowQk1xS0l3UWQ5dG12djJraVZPYkpaSDk0a2FEM2R6?=
 =?utf-8?B?cFE4VmdGZU9FYVNkWnA3eFJ5WFFFWis1d0FxcVd3OFFxRUY3TUMxOTNlWnZU?=
 =?utf-8?B?a2NMNk00THgrQVVZbTFvbzAzejkyZHFzeWVhY3IycUlGVCtnZkdYeXpSS0NP?=
 =?utf-8?B?c1JtdEV0ZlFZc0R2ZUtEc3haYUNwaS95c28vbS9mZ1JqRWQ0VkRqTUtiUWJC?=
 =?utf-8?B?Ni9HRFI2bDRvSGthTVVWMlZkUGI2SjdJdkJmUVVPNG5FWjZCOUNJekh3elJr?=
 =?utf-8?B?NVloVzdhU0Y3OGQvQWFIMitrSkpEQnFvUGpMcTROakNFOUw5N2hHTERzWUds?=
 =?utf-8?B?c25YN0xTU2htV0NlbkE1WTNqd2FZM0xMUDEvQUJ4Q01KN2NQamQwOG1GUDRP?=
 =?utf-8?B?MzhBOGcrMkd2cmhWU3hKOW41S0d1TEFtN0dqNGRlcm80cmppUndrazVNSjZN?=
 =?utf-8?B?b1ZEcE5wWGp0RFRNZDhUMHZ3Z20xTWc0WnNlenlRcFdFd2Z4MFhGT0JEQzFt?=
 =?utf-8?B?NDEwak5YbENrVkVLKzllZFJCOTloNFJBYlZNUm43dFZWRE5RdEpkWWF3QVNm?=
 =?utf-8?B?Vk5UenhjZWVrUU5iZEZlZDBGTmtrc1hNSWR3czVPb3VvUy9NZlNZdnI4Q2lT?=
 =?utf-8?B?VWtKVnd3V1BsMDRXRXhKN2pKM2xXckpyY1lIdVpXR0g1d3AyUkNYVzdBbml6?=
 =?utf-8?B?UXFnNkFPcGYyVTVadjhkZm84VEQvT1RlWEhuUWNpUnpGUU1hcE1DdWtMUE4x?=
 =?utf-8?B?d0FpbTQrSFdIakY1RlBlYVovSzNjeElkRDl5dmgwYjFwblM0RUd4OGNhNENr?=
 =?utf-8?B?dWNTcTRaZXF6YTl3TTZpZ0FVcE9UL2Y5NzMxdUFtMWUvekZwb3U4amF4My93?=
 =?utf-8?B?VVd5S2V2QVVrcU5QWUtKdkdYd1lzUlJnaGJ1WXpkVzNMWjg1aXk3Mld1WW1z?=
 =?utf-8?B?Rjh6L3ZlcHVpWllkUGxEZmIzOEdmNDQrN0o5WWl0WjZYbGJWRUtMeStUeDZh?=
 =?utf-8?B?YVVuWUJPU0lvOXVwZ3FldGVLQWVIZDV5dkYrYUdDNWQ3c1ZFYVB2Z1FBdjRu?=
 =?utf-8?B?K2k4aUUzWXhrQ1hxMllIUUk5WmkvVUswV1JvU2JVeXJtcWFZanZock5OeC9x?=
 =?utf-8?B?Q3dZb1d1dWRvczF3L2xTc0VYd1lySms3T24wR0JTcE1WUVhtR2pRRVdaK1NC?=
 =?utf-8?B?UXlCdHFUN05uVkxOWUc1bEhUcFowd2VjZDNxSHIzeVErRjFQeGJXemtVUFRm?=
 =?utf-8?B?VTJ6MU5GRS9pR0lYS2tteFpBRDZkcm1xK3RFQUxGdDBwU3FlOVM2RC9EK096?=
 =?utf-8?B?L3l5R052MDM2NGQ2ajhpVmpuYkV0R1BzY1QrbGNoTWllNFNRM2ttc29wMDg0?=
 =?utf-8?B?MTF4SjR1WkpJS2FtSTJreUplb0dla0F5LzNzdktPcWxFR3NiYm9VUlhyLyto?=
 =?utf-8?B?MExuVDZLa0lSQmluYkVKNDhQaTJ1K1I3dVduMzJjM0lZUnZwVUtvL0RiaHoz?=
 =?utf-8?B?VXJaTW5ZV0JxSkNHbmpFKzhpOEVValdIOVl2SGxSYWZBL080Tm8rck90a2Rw?=
 =?utf-8?B?YnZld2lUanQwUm54SEMrNFFqWEJDN0pHUkcrcUNuT0V6cGZtWFZDWFY3MVBu?=
 =?utf-8?B?bWVxUTVSOEZRTzN2SzdlMjFKZEFIOC9OV1BSVWFDdE5Hb2VNNmhGdVhkdkph?=
 =?utf-8?B?Ym1QcEwzVUJTaWtPeDAzcnp0MzVpR0ZpV1NqYWRGaGVDM2VlOFk2MGJqamhC?=
 =?utf-8?B?SHJ4czZZaVIwRDZ5ZE1EbTR5MVFXK2lVSWs1bStKTVFBRk5wUHc0MkFoYkN1?=
 =?utf-8?B?eTQvYldsTkJxcnh4bS9jcmx6Y0ZlQUx1OFluSFJDRGpWMElIOVNWbER2ekxo?=
 =?utf-8?B?T0sxSEdnbmRwRVBNRHB4WnJLSEw0Y3VOWUNCbXpWYjlCTUhEWmgxb2RhTjVw?=
 =?utf-8?B?cjI0cXNHSTFZWkxuK2JnZitKWXUwL0Q4T01SSzVtQk40RGNuUlpxVFUzSHB1?=
 =?utf-8?Q?IPwlDuIDA7oyKRtteTwGq43rSMz7rO9A9JIr/zSYWIG5?=
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
	keHx5tQ0Eeln27FEIMh5J5Wmiv8EOWsFJpTZs5jxp+R1rsl+JJaih0XwwxsQfS0EN3HMN7I+h4kqkkMTitALwJW2Uvoa7xDqNwBJd6LujdVwfVWPshTASf+XZHGN06DQHoZ+lqRd4Hwaiu+1aZl902s+lD5U/oQGaSvQGEC/HuA2+7mMtqNSqLaCYIlwP0uxwQKs/V2hbqYLISbSpuXIba34ufXJmFwPKlWKPnPaBsuEj5Wn9BaBPT18gyp1CPiIrEiiwc1De40qdnjyBcDKLOyr0LkHKS3iy9O66R44rbuD4/orWwIVU7b9X9vIRx0IyIxLQmxDGWyPLmEbuNNEWcAqMIdRc89SjMhIWHNh+urJzj7hU+1qp3t39WHkZKKpQg0JA7YgGY3/pAQoG0EiWmYlV8qaIA8bnD/SwZty0f+v3KLuqNy770bbIWfjUfHF9g3I4hn3FlOEoAZNWybrbl8E8HZvqFENIsTl/eYnBJa5HSvEm/SR9dKemISy619jOnoX6BCT9/S3qWhfrAzVg9y7RNwnox3dhlaaUF0Ig8Qpo1/RqbPAaUAhKdMhdn7DsnIFmL3Esf4dQzTV+fOqdKioW1zw2VU84q2PqyiHJRzXY8sH7cX+DNGWUtU76zNk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f186c547-31d7-40bc-6c0b-08dcef34e7fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 05:22:48.8850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0YGJBbjWSGs3rASK3BL91HU5Rvtw6ja0Yo76jatPfl42GYwJ3YZSNLr7ix0cNqk0TY6vRf9/Gl4IjhCg33VsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR04MB8836

PiANCj4gT24gMTAvMTcvMjQgMTE6MDcgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IEkgd2Fz
IGp1c3QgcG9pbnRpbmcgb3V0IHRoYXQgYWZ0ZXIgeW91ciBjaGFuZ2UsIHRoZSBleHRyYSBpbmZv
IG9mIFJUQw0KPiA+IHdpbGwgbm8gbG9uZ2VyIGJlIGF2YWlsYWJsZSwgQW5kIHByb3Bvc2VkIGEg
d2F5IGluIHdoaWNoIHdlIGNhbiBzdGlsbCByZXRhaW4NCj4gaXQuDQo+IA0KPiBTb21ldGhpbmcg
bGlrZSB0aGlzIGNoYW5nZT8NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vm
cy1tY3EuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jIGluZGV4DQo+IDU3Y2VkMTcyOWI3
My4uOTg4NDAwNTAwNTYwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3Eu
Yw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYw0KPiBAQCAtNTcyLDE0ICs1NzIs
MTggQEAgaW50IHVmc2hjZF9tY3Ffc3FfY2xlYW51cChzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiBp
bnQNCj4gdGFza190YWcpDQo+ICAgICAgICAgLyogU1FSVEN5LklDVSA9IDEgKi8NCj4gICAgICAg
ICB3cml0ZWwoU1FfSUNVLCBvcHJfc3FkX2Jhc2UgKyBSRUdfU1FSVEMpOw0KPiANCj4gLSAgICAg
ICAvKiBQb2xsIFNRUlRTeS5DVVMgPSAxLiBSZXR1cm4gcmVzdWx0IGZyb20gU1FSVFN5LlJUQyAq
Lw0KPiArICAgICAgIC8qIFdhaXQgdW50aWwgU1FSVFN5LkNVUyA9IDEuIFJlcG9ydCBTUVJUU3ku
UlRDLiAqLw0KPiAgICAgICAgIHJlZyA9IG9wcl9zcWRfYmFzZSArIFJFR19TUVJUUzsNCj4gICAg
ICAgICBlcnIgPSByZWFkX3BvbGxfdGltZW91dChyZWFkbCwgdmFsLCB2YWwgJiBTUV9DVVMsIDIw
LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1DUV9QT0xMX1VTLCBmYWxzZSwg
cmVnKTsNCj4gICAgICAgICBpZiAoZXJyKQ0KPiAtICAgICAgICAgICAgICAgZGV2X2VycihoYmEt
PmRldiwgIiVzOiBmYWlsZWQuIGh3cT0lZCwgdGFnPSVkIGVycj0lbGRcbiIsDQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgIF9fZnVuY19fLCBpZCwgdGFza190YWcsDQo+IC0gICAgICAgICAgICAg
ICAgICAgICAgIEZJRUxEX0dFVChTUV9JQ1VfRVJSX0NPREVfTUFTSywgcmVhZGwocmVnKSkpOw0K
PiArICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgIiVzOiBmYWlsZWQuIGh3cT0lZCwg
dGFnPSVkIGVycj0lZFxuIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgX19mdW5jX18sIGlk
LCB0YXNrX3RhZywgZXJyKTsNCj4gKyAgICAgICBlbHNlDQo+ICsgICAgICAgICAgICAgICBkZXZf
aW5mbyhoYmEtPmRldiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICIlcywgaHdxICVkOiBj
bGVhbnVwIHJldHVybiBjb2RlIChSVEMpICVsZFxuIiwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgIF9fZnVuY19fLCBpZCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgIEZJRUxEX0dFVChT
UV9JQ1VfRVJSX0NPREVfTUFTSywgcmVhZGwocmVnKSkpOw0KWWVzLg0KDQpUaGFua3MsDQpBdnJp
DQoNCj4gDQo+ICAgICAgICAgaWYgKHVmc2hjZF9tY3Ffc3Ffc3RhcnQoaGJhLCBod3EpKQ0KPiAg
ICAgICAgICAgICAgICAgZXJyID0gLUVUSU1FRE9VVDsNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJh
cnQuDQo=
