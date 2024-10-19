Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112C91D47BC
	for <linux-scsi@vger.kernel.org>; Sat, 19 Oct 2024 06:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729319927; cv=fail; b=S6U3OaPYmSqYpiftfLITUO/KhQCeeHYJwUJHSPt7q44XZRBIAR9Dz+6eeCymrQtNEqOy1y3p+1a0N5ED2t0gYe16TwWUF1PW4/dO9CNH3LOHNutyGIH4fAW3oBkaPxKSIoJXC0dPA30ow+Cg+DXevxEJr3rAi5GUttScQb9HjuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729319927; c=relaxed/simple;
	bh=BnU4rQSDqFE5VxC3VQdcNUXTHn2vvHYoTicFhCgO6uo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SFJU3OWdMqLbZr/lgTXk7DES80HFIVnmuCHkUfHGHqDGqCulnbLMoI5plFUpaDCWk8B1/W7MhNSUVgA4Rp92d86gY0nWE9imRIAMRh/tVa5P9rh8wTlg3b2N7jV9vmni0QuoW2bxYG1CmgTRXjGqJYXnp4iv1VsNJlXtYiQwZnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eu9ttvxh; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fgTERm2y; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eu9ttvxh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fgTERm2y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729319926; x=1760855926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BnU4rQSDqFE5VxC3VQdcNUXTHn2vvHYoTicFhCgO6uo=;
  b=eu9ttvxhsuP3WPzLUu8PL9C3sAavoqnMmBrUu+w2NiCoITTQBGT8Suxy
   fwvt8kVCVlSgkQo13U+I7SduwrT31rvTC6CytSFF7WxzIgWEA5T05G8eJ
   jN+dGiv8JNWpoLOLcK/acghYJPsKRvk8fGGqzhRmqOo51HzH0l1ZaSYzE
   SLPWUVOe9DKHBCr0cml/8mxhnylqQn+5mTLzkLpE8UWbFAO840Jkyx6d5
   d4YS7+rVFKjA+S1s28lbnBevDqKZrmSX5R6yqFqep+YclOZLcdOdkpKcy
   dmyZY4KOYiKsKiZ8bTb0OnRbaNYi/v2d2sBLwoKS/C9kwVVFMBp82ZjV3
   g==;
X-CSE-ConnectionGUID: n7BD7qhyTXK5SeRxVR6y0A==
X-CSE-MsgGUID: b54Dn9PcTiCG2lUobGdRxQ==
X-IronPort-AV: E=Sophos;i="6.11,215,1725292800"; 
   d="scan'208";a="29451139"
Received: from mail-northcentralusazlp17012053.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.93.20.53])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2024 14:38:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTCG6sLtpnPxiy587Hc7hjOAZ7ZCO/1KYYtbMBn89QEfRRR76oMtTc1jJifIHll12gll2tGQGvGGLYCWB2V0gYB/FsQ7hZK1urrkrTJqgUrVY7JeW6kwk333YcClc8GSBz1RYDQDIBMRKplKPvZRgyacsybIHxaoDTyXG11Ld+UubDRPun2vJajNZW8GB+a6uIgCfjpAT64EGtFmCiksPf+ZwPEOu09DujwuhdtPjVWrduZeYGhf6m9/sDAjoXJDFHA0oG29K26YitMoXJiYwQGVMnqm6wohHluAFjvnf8FGAEdMefa0tFfeaiFhR9k+nHDASn5eN2zgZUus3QwDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnU4rQSDqFE5VxC3VQdcNUXTHn2vvHYoTicFhCgO6uo=;
 b=sgD1zJCiSSFtXQ0D/YX7EGAMFnfP/GqBD19V376nozr90rhsR/sYvM5uo5WZGeMdSaUvJDXKmKv34etc8pPKs4tujD8pr0+Bxs5hCvJFYJ2htsRR1mEYz7eS0XKUy9P38vno6t3UUUap79spa2w7GiDpe8PGNhGB2dpuA+Q83zJBFzf4TsJ2SlndRjhtIzeHlPpvlHE7aC/FcTrjxOcCqITPnfJdeZzIcV5Ef3BPoC1nyqIDR2Iy8/O00fBSJsJ3PiKNXLdhVwrphClW1mL2do2siLztlPAuPuGyv6tNR9CngL2K0Pdpib1Jukm3AHJ1e+Ltkm+dgSBeIOd5npm6lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnU4rQSDqFE5VxC3VQdcNUXTHn2vvHYoTicFhCgO6uo=;
 b=fgTERm2ytVvQj7mpAtsPrQOMvaLdelGXaqraTm6guwvGh6f2ZQqrmVrkfRO/SA67JpeW9uXDt/0P7Ect+10i6F07VgaVGTijgdiDI34l/cU8qPm4MrCEve3+XQP8fWAohbzdXVdphTZkPHm9dBrrKbTZRX1JX417njAscWvmeBQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB8161.namprd04.prod.outlook.com (2603:10b6:610:f5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.26; Sat, 19 Oct 2024 06:38:37 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Sat, 19 Oct 2024
 06:38:37 +0000
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
Thread-Index: AQHbIBAk173eioiIKUyIP1nJDoSWfLKMAlIggAC8UACAAAYE4IAAJRYAgAC4a0A=
Date: Sat, 19 Oct 2024 06:38:36 +0000
Message-ID:
 <DM6PR04MB6575C9A03D96A1D4DD75D8CBFC412@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
In-Reply-To: <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB8161:EE_
x-ms-office365-filtering-correlation-id: a598adf2-6841-4a3a-6708-08dcf008a949
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WXZiUFRiZzg4Y1NVSU8yZ3oxam85MTNYVy9pYTI5MXBqcWpPNDhMQXo4VjRM?=
 =?utf-8?B?MUlidnZWTnc4U2Q2OHRyUmY0dnBlWml2czhQVllrR1lQR0t4UUhaakNQeWJI?=
 =?utf-8?B?WXk0WTMzY3BPUnozUzQzYkQ2VlBrNmVvMUdsbHJWeENZVWpGWENITlRKeG83?=
 =?utf-8?B?UGxGWUE2ay83Zi9qeWdXR3dFbWQzSFV4bVRrU1lVRjMya0Y2Ni9zdkF6Y0Ro?=
 =?utf-8?B?eFRidE1OUXppaVB2OFFnSUZucDFPeUV2clNrdG5jMFZmNkliZVB4QmlTNHI3?=
 =?utf-8?B?RURtb0svZzZYNHRWTHlFOGlYNzhTTkJDRjRhNUUvVjcveXBtTzd3cEsvbGhI?=
 =?utf-8?B?MFVUeC84MElwa20xQ2NDajZiUEhveEpUbFpldUFITDV6d3RIMmxZMjRzRkUz?=
 =?utf-8?B?TVN1SmZSTWJLUHROeWtXMUl0MHM4RU1uc2Y4ejdNQXQ4WC9RNWsxSUYxV2JW?=
 =?utf-8?B?d1I2dStUb0cwV1JoOEpGS0NKRVBSRitXRjM5cE4vdlVVNnEzUnZNd05NLzZu?=
 =?utf-8?B?OHF6cDZmaVpMZkxPeGxEWmhkamgvbkZUd3k4c3AydVYrNmhHbk9jMXIrajNj?=
 =?utf-8?B?TzZVV1JBaFJDOHpDUHBjMEZTeU5MelJrQWgvMVZCOWFZUmdDaDArY09lVFFo?=
 =?utf-8?B?WFFkT01UQjBKNEx0MVpmQzFCd3QycTNoNkhyOEtnUDFwSFFjWmFPc01TaW5J?=
 =?utf-8?B?SEdWUldQNWlTVEpyLzh6MjQ2cTN1OHdWYU9ua2tXbkxva1JJWkhxeFIybDJO?=
 =?utf-8?B?UzhpUlByQ2dxMXhVa1doQWYwM0lTVnVRMExmbjROMzhOYmJ0WjRtWTVXalI0?=
 =?utf-8?B?Y0pjZ3htOFFBam03dUVNZVl4dUlQOUJ0WUh1TU9wZnFRMG51YWw4QkFlNEpE?=
 =?utf-8?B?U25venlCcWowZ1ZQdWlmTjJtUzhMUkR0dnBaVWNnWm1nWEg1ZTdUVTZrZ29T?=
 =?utf-8?B?OVdCZUo3cGQ4b0FTUk91Z3Q5TEtxZUJHbENOOER3VmxrSy9ETUN0OXZ1QlZp?=
 =?utf-8?B?VTBNRUtSWldFTUVXeDRZT0I1NGVUeHZRbWRoSnhZQ29YTTM3ajZNTWkwRTFG?=
 =?utf-8?B?Rk1PWWhjV1k1NGNXcEdNVWdCbWF3SEZ1aG15TVlZVEZpWk5uTEVsUU5KQkN2?=
 =?utf-8?B?a1RsZXprMUNyMDZVT0NXRkw0REdleWpnMFJvVjQ5SFgxSzJ6cHNpZ2Z5OHA4?=
 =?utf-8?B?ZDZqUnJRaXlCZFUvRnBxNitITTMvVVNOR3NVWkQ3SDBkWTFYN0VzUTNpN0l0?=
 =?utf-8?B?R2RnUzcyUFdZMlNkdnZVTFRrbU5CY2k0Sm42ZHo5T0M4ZnMzTlpYSVc5ZE9R?=
 =?utf-8?B?eVI1bzhmNWhzNVMycmUwL2E3TTdQdkNobWg1RGlOc2tJZ3FxTWU3MnRzYnJI?=
 =?utf-8?B?T2VsWCt4MW9vUlpwT05ZZU5FZ0NQMnlmanZPaitjTU5iNmFrZ29TMlA0bGth?=
 =?utf-8?B?bmpXUkhoZHFrMjBVcWxOMEtoS0pxamlJWXNrSTFnVE1MNnUxL3dEL1lhQXFH?=
 =?utf-8?B?RGFnMjkzb25rRThCVFAzTEpzRWtnQnk3RUpBZHNqWXk3T0xVdWRJQkVKSzAz?=
 =?utf-8?B?MDd4dFUwTm1ETU9TMFA1NEU5dUVlQ0RHaE5XWDM1MG9wVmNScFBmZllRWVA2?=
 =?utf-8?B?dUhlaTFRQlgxVDBCQi9DaDB0MFpyVGtYVjNwMzlZKytJa3lYcGNzYlltbHo1?=
 =?utf-8?B?czVRWUhhOHJDaHUxMEY0YlRjcHlVMGFPQlFpeXlhMFAyUHRLaG54K0VUc01m?=
 =?utf-8?B?STIxeTFCRHBYSEV4Q1hlT1ZXSGp1S1dLTnVIRlpwcXlNZUNZRVYwYnpuaWk0?=
 =?utf-8?Q?xTNwIGSKGAi1HcoO0u0Cg1r3l5lLkTKnqcBJY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWRHWjhENlk4QU5rZmphM2JBMnhibU0zOEpFUElGbWJwNUE2Y3FvR0FsQkdz?=
 =?utf-8?B?WW5XdEViN0V3MSsweThaNG5nUXJJTHUyUGJOU1hqU3o3U3hDZ2tnRDhaT29v?=
 =?utf-8?B?S2J2dzhGTnI3QXNEdy9IK1ZTcWFPZXNIZms0TlZTdlpJUG9BNGVWU3czTktK?=
 =?utf-8?B?MFFPY2pSQ0loMlZRQWNDSURDdjVkYmIrTUxSN2xjOXk1cGwrR3F3VS9idG9Z?=
 =?utf-8?B?NDNteURMNFlleTYyUVNLZFVWcFpjdjVXWHpQTmRjeUYyanlMcDBXS05xRlov?=
 =?utf-8?B?WnlVc2ZjYTJTcS9vN0FvblFjRUNnSm1Mdk9sR3RudFlCODluVUI5ZmJGR3k3?=
 =?utf-8?B?bEtaVkNTN3d4UDB3eE5Ya3lWOVpmb0NLa1RhMGNmdUd2eW45V0dGVkdSUVp3?=
 =?utf-8?B?dDVsUjN5Y2RqZ0NtRGk0ZFp0d0x0c2pqVVRkSytBR09saEI4d2VlUSs5R2py?=
 =?utf-8?B?alhGZHVWU1N0SkZMeU8yUkJpRzFheDB6bHZCNWYvSDRQTnpQY3YvRzFIc1dJ?=
 =?utf-8?B?YzNWZ3JENmtjT2hhUWpxSkRKMC9RVnVxb1pET0NrcVVMOWRZWDhUbm84WDRM?=
 =?utf-8?B?cyszZnlJUDdnT0tUMkVCdjVFajlRTW0zRlVTcC9OV2dzZERsNlNveERvRzdT?=
 =?utf-8?B?UHo2V1NXS1gwTjJDcFhidHA5S3luRGRXeWhtbHBCTlRvSEJPMHA3NEY5c2tl?=
 =?utf-8?B?UGJQQTZwcXA5RnlDbFgzRDh4TU4rWGVhcDlia2EyYUR1a3kyRS9XUnlveUdk?=
 =?utf-8?B?VWFQRzRNVDVlaFF1ZkI1cVQ3aGdQdjZWVStsbnM2VFgrLzJhSTRYeEpmRU0x?=
 =?utf-8?B?Q0pJQkRmMWY5dGFHNDU5Y0dzVEppV0NJSzVWbXFBTk15UHp6ZWtPUmJ5akQx?=
 =?utf-8?B?Q3p6ZjlMRzNjT3RMdGtZR1FRcFR1T3hBc1NocTJ5TGE4WW9QeXN6di9PdVVO?=
 =?utf-8?B?TEIvWDdPY3pOOFM2a2QxL1FOYytDY0FldVp6K1NxUzMyaVZsakIrRitZNjEw?=
 =?utf-8?B?bHVmbFZLWUlGOU9RN1FWUUJsM1RnTUVFRnlPOVlTakhmSmZTbTFld1IySEpV?=
 =?utf-8?B?cDlWUE9pc3dscXFTSG14UGNRTUlIeUh5Zk0rcFAzN2MyY00xbUphMlUzVzhH?=
 =?utf-8?B?RGErYVBPSFNzQjJNRDFCNExoVitxOEorWTl5MldYeE1zdlpublZEVUdjZFNE?=
 =?utf-8?B?Q29pY2N0MnVTeFhPbVZha1Job0p0YzJHb1Nvc1ZlaWQ4V3o3TStTclhBZ1NI?=
 =?utf-8?B?ekx5OEt0UHpRSTFWdXhsdWFha2laNkxSdWJrcW5MTG1vd3dSVWFWd3BXTFRX?=
 =?utf-8?B?UUpHOGVKcEFLU1dGV0ZjWE04a0lFMnI5anRRSGpMdWJHUXJoNUpEU1daQkFQ?=
 =?utf-8?B?VU1XRUI4S3ZCN1Fsa3BHYlEyRWt0THNrTW1vbnBieURlc0pYNjVXV1FiV05n?=
 =?utf-8?B?d0w3TDg1dk9ZbXZLYWRYRmlyb1VQVVVPZ0lNWjhIMU5GRElnSnc0YnN6Vlpu?=
 =?utf-8?B?ZnRLcXU1TU1ObnhZS3JPY1B5TkVVQXhsTEZpS3VCaUFKOHFReTJNZGdXT2dN?=
 =?utf-8?B?d0ZsYS9YT09reUJVVG1BcHlnc0M1TnRGSkYrRGxjZWdEaFUyVTVHSEFGU09L?=
 =?utf-8?B?T2RUL0lTQkplTW02amNLK2ZOZzFvTkJWR1ZCSTRCWWZ1SDJIeDR5d0pNU0sx?=
 =?utf-8?B?NmIxQitvR3k0eHQxQjl0ODBkMm1ldW5CT0cyUG1RZ2RDempJTXo2SzVEQzRV?=
 =?utf-8?B?ckJrUEpjYXczWmplUGlSRzFiRFBFZTJRVUlJbUV3L2FrV25Oay8yYitld3hF?=
 =?utf-8?B?QTFCbGkvRGFJWXM4c0ZUTGI0YmlMV3pROXFzakxvSFRFMXBGOGo3bUlsanht?=
 =?utf-8?B?dWhjczVHT2FISHRMTU9MN2pxdWtyUmhOQ1BHVGpiUXVqa3JuVHdkS09UajJE?=
 =?utf-8?B?KzVaMG04UVZnU2dicGMxdlZCN0dHWitzQmQrZkxSWG1JV3VZUmFacUcwMW03?=
 =?utf-8?B?VW0xdXNxaFZpejV1Y1NNWmlDQWgzNTF2Q1JlOTFOTEhtbDIxRWg0eFY0VWhB?=
 =?utf-8?B?TUlrRit5MHI1RDl5TDN4elBreVd0Z0JhK2VLT0FjTk9ZOU1CZENyMURuYUNr?=
 =?utf-8?B?MVpaUkU4SjBTZWhKUEpiZCtkNldsZGVVWmY5b1o3REhQcFRYRFQ3aVZEZERp?=
 =?utf-8?Q?7nTGLn47i8TnCCsTAKtnBlXE1GzUp0znxydV36Y8iacu?=
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
	aa4G1M5RE8XO3uDAE2JMbpXhJ23Nb293VTiJWFkFkhulopjbzfzFMPYYdiWQswQthd+UuzleniG6bvMih/hEJ3N5pS9zVWuWbMIoXVIIAlsWDpMB6pS3u4TIydVEK60mhGBjo5lxBI6gPQzOClx7VS+iV2WOeMy/ytXo+za01ZHCpGptxpdYtdG6KAnd56eNFWxhgpxCN9CGWuq/rkV2qXH+P24vb9ueof+vdagkahBJ4/sj6KnWfD4zTRvUIXrs+E/2iTTf22sY1AVtiDlxQjvVQ0DBtkCT8KdjLNJ+oROm7FU7rSiAEmtOOHCm0lT4LHj/K7M4txAZBGIiHyoQc6Z0MRaHZ1ZPZRg1Lu05dLTrgfwvDibtB7PbZFMlKj+QCdixdoGOJPilZrydZ4I6uxQ6LuzPO0N627q1NJCyyPVlW64icdeAxNWJOXQPbEqRxa4Rd0akls6jkmkmU5INqtx/t8GN9/2rlz7kWX/nNGsikMAeEIrF9yJTVQxyqY0oH0Apycj39rISq3+/Ha3R4HYzVgTeJwFYBXNeTkWfpToUQWipJvRlXjSgeoGQVOhaYr23V/wFiLFLBNNEm8uQsdEZ2/4zl0O6lEVobrKR3jUqtGcGa0rT/+yTddfp422s
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a598adf2-6841-4a3a-6708-08dcf008a949
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2024 06:38:37.0313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJDZOQCRmY2X30yg2eGKvbN7/89iUIKu8bC6xhDlMCoboIfInXzbbj24MMIwlMB3tzQKgS3j4vVtaHmQT22Q9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8161

PiANCj4gT24gMTAvMTgvMjQgMTA6MjUgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IE5vLiBC
dXQgdGhlIEZpeGVzIHRhZyBzZWVtcyBzdHJhbmdlLCBpc24ndCBpdD8NCj4gDQo+IEhvdyBhYm91
dCByZXBsYWNpbmcgdGhlIGVudGlyZSBwYXRjaCB3aXRoIHRoZSBwYXRjaCBiZWxvdz8NClJpZ2h0
Lg0KTG9va3MgbGlrZSBpdCB3YXMgaW50cm9kdWNlZCBpbiB0aGUgZmlyc3QgcGxhY2Ugd2hlbiB0
aGUgcXVlcnkgdGltZW91dCB3YXMgMTAwbXM6DQoNCiIuLldoZW4gdHJ5aW5nIHRvIGNoZWNrIHRo
ZSBleGNlcHRpb24gZXZlbnQgc3RhdHVzIChmb3INCiAgICBmaW5kaW5nIHRoZSBjYXVzZSBmb3Ig
dGhlIGV4Y2VwdGlvbiBldmVudCksIHRoZSBkZXZpY2UgbWF5IGJlIGJ1c3kgd2l0aA0KICAgIGFk
ZGl0aW9uYWwgU0NTSSBjb21tYW5kcyBoYW5kbGluZyBhbmQgbWF5IG5vdCByZXNwb25kIHdpdGhp
biB0aGUgMTAwbXMNCiAgICB0aW1lb3V0Li4uIg0KDQpMb29rcyBnb29kIHRvIG1lLiAgSSBjYW4g
YWxzbyB0ZXN0IGl0IG9uIFN1bmRheS4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gVGhhbmtzLA0K
PiANCj4gQmFydC4NCj4gDQo+IA0KPiBzY3NpOiB1ZnM6IGNvcmU6IFNpbXBsaWZ5IHVmc2hjZF9l
eGNlcHRpb25fZXZlbnRfaGFuZGxlcigpDQo+IA0KPiBUaGUgdWZzaGNkX3Njc2lfYmxvY2tfcmVx
dWVzdHMoKSBhbmQgdWZzaGNkX3Njc2lfdW5ibG9ja19yZXF1ZXN0cygpIGNhbGxzDQo+IHdlcmUg
aW50cm9kdWNlZCBpbiB1ZnNoY2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIoKSB0byBwcmV2ZW50
IHRoYXQNCj4gcXVlcnlpbmcgdGhlIGV4Y2VwdGlvbiBldmVudCBpbmZvcm1hdGlvbiB3b3VsZCB0
aW1lIG91dC4gQ29tbWl0DQo+IDEwZmU1ODg4YTQwZSAoInNjc2k6IHVmczogaW5jcmVhc2UgdGhl
IHNjc2kgcXVlcnkgcmVzcG9uc2UgdGltZW91dCIpDQo+IGluY3JlYXNlZCB0aGUgdGltZW91dCBm
b3IgcXVlcnlpbmcgZXhjZXB0aW9uIGluZm9ybWF0aW9uIGZyb20gMzAgbXMgdG8NCj4gMS41IHMg
YW5kIHRoZXJlYnkgZWxpbWluYXRlZCB0aGUgcmlzayB0aGF0IGEgdGltZW91dCB3b3VsZCBoYXBw
ZW4uDQo+IEhlbmNlLCB0aGUgY2FsbHMgdG8gYmxvY2sgYW5kIHVuYmxvY2sgU0NTSSByZXF1ZXN0
cyBhcmUgc3VwZXJmbHVvdXMuDQo+IFJlbW92ZSB0aGVzZSBjYWxscy4NCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
YyBpbmRleA0KPiA3Njg4NGRmNTgwYzMuLjJmZGUxYjBhNjA4NiAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
DQo+IEBAIC02MTk1LDEyICs2MTk1LDExIEBAIHN0YXRpYyB2b2lkDQo+IHVmc2hjZF9leGNlcHRp
b25fZXZlbnRfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ICAgICAgICAgdTMy
IHN0YXR1cyA9IDA7DQo+ICAgICAgICAgaGJhID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB1
ZnNfaGJhLCBlZWhfd29yayk7DQo+IA0KPiAtICAgICAgIHVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVl
c3RzKGhiYSk7DQo+ICAgICAgICAgZXJyID0gdWZzaGNkX2dldF9lZV9zdGF0dXMoaGJhLCAmc3Rh
dHVzKTsNCj4gICAgICAgICBpZiAoZXJyKSB7DQo+ICAgICAgICAgICAgICAgICBkZXZfZXJyKGhi
YS0+ZGV2LCAiJXM6IGZhaWxlZCB0byBnZXQgZXhjZXB0aW9uIHN0YXR1cyAlZFxuIiwNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNfXywgZXJyKTsNCj4gLSAgICAgICAg
ICAgICAgIGdvdG8gb3V0Ow0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiAgICAgICAgIH0N
Cj4gDQo+ICAgICAgICAgdHJhY2VfdWZzaGNkX2V4Y2VwdGlvbl9ldmVudChkZXZfbmFtZShoYmEt
PmRldiksIHN0YXR1cyk7IEBAIC0NCj4gNjIxMiw4ICs2MjExLDYgQEAgc3RhdGljIHZvaWQgdWZz
aGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKHN0cnVjdA0KPiB3b3JrX3N0cnVjdCAqd29yaykN
Cj4gICAgICAgICAgICAgICAgIHVmc2hjZF90ZW1wX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKGhi
YSwgc3RhdHVzKTsNCj4gDQo+ICAgICAgICAgdWZzX2RlYnVnZnNfZXhjZXB0aW9uX2V2ZW50KGhi
YSwgc3RhdHVzKTsNCj4gLW91dDoNCj4gLSAgICAgICB1ZnNoY2Rfc2NzaV91bmJsb2NrX3JlcXVl
c3RzKGhiYSk7DQo+ICAgfQ0KPiANCj4gICAvKiBDb21wbGV0ZSByZXF1ZXN0cyB0aGF0IGhhdmUg
ZG9vci1iZWxsIGNsZWFyZWQgKi8NCg0K
