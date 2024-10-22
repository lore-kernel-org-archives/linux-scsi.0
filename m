Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212C912BF25
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 05:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729575430; cv=fail; b=TXgPV/QpqUJ2qK4prmplvtDLb5OzROcDVNStG8wQrpespNKhZwQeRRThh6LRvn5YY6b1VNbC2SFdp21wZBepz8jHd9JVfEuI3Veqgs06b8/GObG0JIXsDALuAbWCnkZShdl+ZORzjf6Rn8oIpQ5QVL4ZO/6JhdCfVx1SkRL4jGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729575430; c=relaxed/simple;
	bh=Cnn1JAoJxe+kfVJ6h4keK7dbdpTosEfTtTfwpuRQQac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dvz5gchgVC5W1iHswBiJq75U+GeNfv+krafWVeG+JHDvgXf/d/4td2ixeQt2XlzO1Pu4ttLLNF5PCZDFSUvUz4WwT7nZw927fvOW40ls1Yrh8cUnCnWCWrxRrxTJCkaKUhwvHp3HBUdCvpaa4Fhp/QB3wHzjNBYsdwqd+37ZDWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SW5SyP/F; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rUVR+fca; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SW5SyP/F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rUVR+fca"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729575428; x=1761111428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cnn1JAoJxe+kfVJ6h4keK7dbdpTosEfTtTfwpuRQQac=;
  b=SW5SyP/FIVMxRz8tByAelzzA5hO112XLESF/Rc6Com1KJDxwMA031Ffk
   yFCVuW+ED1NI5i2RqmliDPCZ9mSx1teL7od++SEdIXREcbV4spT3W1OUv
   0UdphL1xs4+z5T1YzEO0FNQ3g+b7MIIHptFFIr8BfrLOo2be97d7ioqWd
   ZV+1XqD25hnH929pNpOOUaYDkA5igBQAKZMR+Q5m3V5DS/AWftXIvlSfg
   Zr4hjYSt64HPd8FnY5UK6vcPOhY/IuiCbBbi9p6k8MdoFuC817jaVm4Rs
   pa+SJ/IHvYm7h5qs/LvCt1xkaF0/o97I2KdKv2+MBSRLih9E27HA0QEsC
   g==;
X-CSE-ConnectionGUID: G6nai88MTB+zQerZjZ1WYw==
X-CSE-MsgGUID: 2FLiFgLoRAy6KEicLH9uZw==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="30659347"
Received: from mail-mw2nam10lp2043.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.43])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 13:37:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zc2f08s9H1ah6D3plb15R15yYDpW6b6tkSc9XF6S6uGvvUws5yWMMSGpZ2xVbYSmXPFqKn9+QTH1cK2zsxol3lnOhUHQhJphwYEWX4Ay/QZCNSJT+n8HlMg7xmo244PasNlzxYEVZt02aQ5yVncgRqwlKZAdC5o8MlgIzS1Ps7+wqgszeXQN57CIGNrjDg9Y/Twl0ZWdVZE5gFuyDf2qAY44MjrfAfX2OoWNz6f9rXx9ChJik0yV/5Gjmj096efrh2ipHIQVMpyKI7hVQy9x1ApwsAyNW2ewSW0ifWBfvW39wFItJed7rnk3yvelym9V9muQFR9vHkzBD5VSJVt8yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cnn1JAoJxe+kfVJ6h4keK7dbdpTosEfTtTfwpuRQQac=;
 b=rtwuk1JRB5b1meVDpC0ToQMfQJhnY2awPROpTqh7ZmQ1jBjXs68+E/Unq2L3/7cSH9RieSuXChPgf2ZoY5fMyMWvnbxDjM85gGokXOzOAlM78OG5yAVA0T57tyu25Yjax0FGqQKz4P/pexwPgZToyerRIfyyMH06xzfQbnWSs9jooRIqLW/T+JBNrHzzrCWrZTN85GoEURxncHhVJJbjIWGIA21GMbMAsXdckLjFBeGNJjS4iDTMlNEuVXA4oBxBWrVl43dFBYKDGOq1ozqKRpTU+gnORTPqhI/HaHN/mTCFaRMnOnXsClXPDDN5QX/10gEp9e/d+dRcEY1E96tx8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cnn1JAoJxe+kfVJ6h4keK7dbdpTosEfTtTfwpuRQQac=;
 b=rUVR+fcaJBWk8N1l/dQBaJFtfx7kjEmzOeBaA1DUrnEpYeP0g1vgFrhhmC+XHzVQvsX/68bTNqXV/p9jLITI966zPjWUq6Up/yntUvRk3glLVnUgKDpYu/0jHbpUPneOb87XnB39am8Q2tJqyqeE+8NJmUqX7E46KXfrstoA/2E=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by MN2PR04MB6288.namprd04.prod.outlook.com (2603:10b6:208:1a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 05:37:06 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 05:37:05 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Topic: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Index: AQHbIZato9yZE/MjkUeGYMJmS6EW7bKNlnnQgARHJoCAAGf0kA==
Date: Tue, 22 Oct 2024 05:37:05 +0000
Message-ID:
 <BL0PR04MB656440BAEF93DDE50A0E2F01FC4C2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241018194753.775074-1-bvanassche@acm.org>
 <DM6PR04MB657551A72CB90ADDEFC49F48FC412@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b385c84b-1755-49d7-9125-20e3b482e6d2@acm.org>
In-Reply-To: <b385c84b-1755-49d7-9125-20e3b482e6d2@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|MN2PR04MB6288:EE_
x-ms-office365-filtering-correlation-id: e4122831-1e18-4efc-551f-08dcf25b903d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmdncVU4RWUyOSt2U3BIOGxyMVR4d05rN09OeTlXNit4Y2dtMTc5QjhMK1hw?=
 =?utf-8?B?a1hZTTdoUjN4U01MNnQ4R3VxZ01hVllmMjI3RU1PYVdFY1ZGbnNYd0dUMWhY?=
 =?utf-8?B?RVhkeDFhenZTMm1jK1FxekhMNmJlREYyL1c0VkJpR1JoK1hRQ2FFZHkrd2Y3?=
 =?utf-8?B?SmVhaTVpdm5tY2hHMEV3b2dLMmFLQTRVS3ArY01TWk9XeGI3U2lTc1cwNkU3?=
 =?utf-8?B?OWFZSWQwZFF5US94SWppcTRwSitWcDY2alo1VVRoWUpYcmxEb2JXbHY0RER6?=
 =?utf-8?B?Sm5sMEhxbmJRYUtXVUpCRDFVMjJjTER2SFpwczFvaEpwUUJjY2VrNSt2S0x0?=
 =?utf-8?B?OERXRkRyRzZHSU0yakNYQ1JQZFdqMkpneTRRTlBaR001NVpIZVpPQnZUUVVO?=
 =?utf-8?B?VGw3N3pRWjNoUTNkdG1BVDNkQ2hSaWVTOUpSTHpJZmZHb0kzVks4eDYzKzlH?=
 =?utf-8?B?V01xdW5sWjJNYXVwNVpNQ0FjUUFnMFNjQ25kMDM4Q1NON1JBY2liQ0xnOVVh?=
 =?utf-8?B?b21nWWlqV1h2b0oyRTh1TlVIZThMR1ZSMEc2cnBGNVByblVjYU1zZm5YZ0ZI?=
 =?utf-8?B?MnNwMkRwS3kzL3pVYmJWZzJNK0o1NTlaYjNGMDRZajJnTXdtUnNrbnlDMjFE?=
 =?utf-8?B?dDdjdzU4YTZIS0dGbHJWSjV5UmRyeHhyMSszR0I4cnM0N3FmNUc4emsvN2E3?=
 =?utf-8?B?S09uWUlTV3dYRGNoMG5Nb1UzUjYvZnUrVE5lOGNZNHVIM0s2RUx2ZjEvQVdx?=
 =?utf-8?B?NGFCODVWQ3pzc1BObHRqYW9EUW82TGVOSS9mQ0Jtbm01K2U3THM2U051VnpQ?=
 =?utf-8?B?SU83ZlBNUzM2WjB2REZXdzQ0NmNIOGNIYXAzT0Z2MDhLKzZtYWl5aFNsWTVJ?=
 =?utf-8?B?eUhvbzBvcW9sNHdqUGtQZXJmdGg1bm4zci9VWGtXUDM2QytEYWcrWlNYTnNH?=
 =?utf-8?B?N1ovNDlkTWsyMzdnVDBtYUxhaG54WTVjYUNDZm5kNi9LMDE3eEpjby9GdHIx?=
 =?utf-8?B?YU5pQUZ2a1ovb1liVDZTdFVvSDFKOGhjbDJlL1l1Q1UvRDgxaW94MHRleENH?=
 =?utf-8?B?REhUTkJXU2l3UmdVdUMyci9wTXZUekFMVGZFcy94OFIxelZtUTBmSHlWb0o2?=
 =?utf-8?B?ZzRNYk5wVWlheEtKUnJCOU9NSW4rRDNUVXBnU1pmUzI2OUpsekVKc0ovSUpZ?=
 =?utf-8?B?ZkYra2o4SjNVa0Jqazc3VElBQ05HQURudG5xK0lpNGJiR0lHb0JSMmpzZzd3?=
 =?utf-8?B?cE5lNldkNlU2NVkvVTErWDRkSHk4SUFaTUtLYnJEUG03cmRJaXh0K2NDSDZI?=
 =?utf-8?B?WUd4UndmZWd6UHNKRUE2R2M0YmNHMkVnSmxhSTRtL2ZPZ1JXQWI2THBEZWxp?=
 =?utf-8?B?Z3hRK3l6WWdnRmhUQ2szWk15bXZWdFVRT1Y2WTUvY0dXUk51aFlaY2ZiOStM?=
 =?utf-8?B?eWQ0NkFyZC9OZEJseS9ZNktld0VhMDJsaGRFMllONDFGTDFmWFNrQ1hOUXhM?=
 =?utf-8?B?c0hlQk16UnFsTUFwQjJOZEJxWnZjb1ZSR3VKZzJNejNGUkNsK3B0Mlp5UGJ6?=
 =?utf-8?B?V1ZrZVdOaThhZmgwT1BKcTh1WTE2US96R1JnRWlSNEMrcldHa250d2RjdEt3?=
 =?utf-8?B?NXl4ODJrTkZ3WVNuVkFLTGQrWFUyRWUxQU9vOG1FblM2bUVwemU1UjB2ck1M?=
 =?utf-8?B?Mk1rd1I0dXh6OGpzYmF6enh5NDNDcWE0SXIvNi9reEtUdnFBTTJVTWZNV3Z1?=
 =?utf-8?B?VVA3R0IzVHNLRmxzZG5tV3MzSStsa3ZPVk4yNUMwTFg1aDJtbjFrbnRwY0x2?=
 =?utf-8?Q?vJ+dyfoSReul8y09oONtQqmScSgeDSeGONZk8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1Q1SGJkQ2U1c1dlZ0twWlQ2eG1FUEFNYkx1d2FqQkoxYnFkV0gvRlJiLzhG?=
 =?utf-8?B?QTFKcGM1eTNjam12L2J2N1VaeDY3MDhsbU9VZTVMZ3lVeVhkVHhVWjB1Y2g2?=
 =?utf-8?B?Y0lUZ05zMFcwb1pHbEZxazBTTkZHaUlQR0dMdnBMTFl2MGFrS3pxZWRYZEtS?=
 =?utf-8?B?ODR0T0U5aDVselB0S0ZYOW1aMDcxVXprYk0xbjEvUXo0dHVhVEwwTWVQWTBs?=
 =?utf-8?B?SzFmUWhpbG9xYVRyY0NOZSt3Y25CZ2o4M1IxWnVPc09ZR2hZQ1E4ckZqbHBI?=
 =?utf-8?B?MVBxbTR4ZElyYlFXQmNzZmU4Mmc2VGtZQWFEZFllYWhwTWFSZW00MGtJRnlW?=
 =?utf-8?B?Wm9USnhGY2c3djNxRE9IeTF2NXY1VkRTL25obUxBMlJHM2JielZCZmZ1anJV?=
 =?utf-8?B?dW8ybUc1V3RVenY0VThHbUx2cllvMmtFTEN3dlNPTjJwRDIwNFYzanBYSDNr?=
 =?utf-8?B?N1dPRzhOUGdMdndPaUwyM21talZKTnMwYXpXYUFibGNwUlNmTjhoVmZ3TCt3?=
 =?utf-8?B?VU5rOUNka0dPKzZjbEFSNXl0TUh2NHdkR0dVQmNQSXVGcm5xN2dpcDdRWnJI?=
 =?utf-8?B?YlBMK25FVVBNdzZpRkFONU5EeDNvL3dvV3NnWm4rN0s4My9kMzI1MWRGaTlD?=
 =?utf-8?B?QkhmeE1UTnFGb2VQQmUwekxhM3pVallOS1hvV1ROZHlIeW5OUjMremhLOW5m?=
 =?utf-8?B?UDdCWGJ4UmVOZW5nL0kwRjFLRGR3ZmtYcjgrSzdSMTQ4dEgwU1RTSCt0RlF1?=
 =?utf-8?B?MDh6dXQ1MmZUbEU0L2pMNi9vbzJwLytiQitvM1Yrc3lIRXgxMDVBK21VRnh5?=
 =?utf-8?B?cElOWFhuQmJwWE40YUNabHBWV1llaVJhL0lScHdmMVFMcnBvdFNiTWRzbU0y?=
 =?utf-8?B?UnhsOUFYYVVBb2d6TERSdnJwVzc0UG9BTXVKL3N5ZzNNZUhzL2tqZlBUd3hX?=
 =?utf-8?B?Q3JPQWx0OUVyalJ6akk0dk1IOU1PWVlueWwxOE51dld2aEdraVdnOUdDQVd1?=
 =?utf-8?B?WXhia1I3MTVFTXlsZ29vOVdNWHZySjU4WkQ2NU0ySG8zU05QcmtiWHBNb2xx?=
 =?utf-8?B?MCtmeXY1YXFWVWJCdmlmVnNkRlI5MGlrUjYvWDRKODBDUmJlM0xSUkxMNExw?=
 =?utf-8?B?MFZQMWZ5V3NNeXN4VWJCb0ViZkREc1FmYktSY2VJWFJWeVRKUTkreXFjWDNY?=
 =?utf-8?B?d1NVb3BXcDJBc2srVkVQenRmVTZGcmxXc2lLR3h4dE1Zdk13UjlmZlJyN2NX?=
 =?utf-8?B?K0J2MTlzcjhjNXZaRGpUSVk1TldqMk40TDljSllEODFoOE00bVFDNTNzYXBP?=
 =?utf-8?B?NSttb0I0a0ZyUE9DdC9NN3hFWVFlaDRKeWxJdFJoVkl2Q04zUXpmbHlnV0NJ?=
 =?utf-8?B?Z0Z2U1B2MG1tQ01VMCs5K1VaZkRsUFd1a29RbHdNNDl4Q0FZR1Y4QzdIUE5U?=
 =?utf-8?B?UmZ1N1FWZ0JKREo0dFhjKzUzVGZKcEY2c042WmRub3dmOFZLM01VY0NOWDlH?=
 =?utf-8?B?MlZwUGsrTG5xY0o2MUpITEJiRDBhVGdJcmQwSFRvMnVrRTJ6Z2hMOU54YStK?=
 =?utf-8?B?WnpMaThNUVdXemNyQVRzUCt4aGM3NGNhSEorZ1orZG93dnVSYTg3Z285b2Q3?=
 =?utf-8?B?c2xRZUYwVEQ2dGx4dFd0UDByMjVRMGdLandDOVliM1lyK0pCMVBxWjFhNnNS?=
 =?utf-8?B?aDZ0VENSUHJTTVFDSDVSRzdQalV1eThxSFowWWc1eDVhNmNuRzUwTmdhRlRs?=
 =?utf-8?B?SCtFSUl6djJjRGNYWmlKYVlxTlQ3UDk3d3JINVBsMW14SDFadkxLRFBGeHRW?=
 =?utf-8?B?YktVNzE3TXdlUzlIVDYyQ1czZjFxWXp1R2ZlWVRpdjJGU0lkK20vakQvMmpE?=
 =?utf-8?B?RmtocWtYNmtacjl5L081cS9GaXU0RCtZdmpJQlo3cWVLS1pnSkpJbjZxdVlJ?=
 =?utf-8?B?cFBRRlJ4VDFFdnp3RGhxZWJySGV5NTBXOEd2bDRPMlFHOWx0Rm9rMGoyMGhi?=
 =?utf-8?B?NDRZbjNzc3VWalphZGZQVXpNZVpkS3IxbGY0eDVKNnl1dXlhWFArY1QrTS9E?=
 =?utf-8?B?NkVLZkZoRTB6QzFuOFNXM3VYWTlJVEFrV3pxTHdOTENaY1FnVWNZSTArQVhO?=
 =?utf-8?Q?Nf/XAFih4AlRyYnZjhOvMm5SR?=
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
	kYZRWsEgvvfjwMs7vs7wfKxatfoUk6ZfWVwW2vx3tb8PbLN9gqiWy1LLedb4KN7xun9ASO4SdmaN9nhHy68GsB2ZoL9sjImS758zSexwJr1giZYknz8I2PzSEgnyMhT27OVUvgEssFk96iF4bK4ifT0Zm0YxaEnOLjqi+9dUHHw2WCBeqOKcWpDAmTZ9pCMXzKxFrbqjjcYwvBmSasBmXQ6DUNWIDtVQuPcc4pC4cuf17VhQaMBTmcT9d3mcVReszlv/bWdSYYLLqVhlo3k3UaCcutCNgGIzt/HC7YXGn+RKnAkRKNo5soB8uXY27HvwS6/q5CVG4UTqcWtigY/PJYddO9+/ILN1yEfdwjE5RVi2q1dsAex+Qr82D5aVgZMICtwwLFcgnddub8SN4xSPfZbki6zs7dhgcd+gNxcuZKCx7NqZxkF9r6dyAi2mYMxjhTZRDXfbDnXnaiMsY63rTRuWC8Elxwi9JtyqRb3CjWk+UiByfWI0p8OMnwy+RJEMltUoJEeBRG/1bhsjMCvLTALsMN5CgDmddDqbeCg8SSxNZYSlrtbAkLQAc6Yh+I3M2R4KdMjFdZo2T4krFL4DNvY2byIidnBP7taWLJ9YUS4jyzw/lx3BinOn2EikVBdL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4122831-1e18-4efc-551f-08dcf25b903d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 05:37:05.5191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ryzi4jQaB8RemOV+sgIQJ5+a8OfI67kfTkuITBzYFhJ9fN7exuqXq6Gt8IE1SYW0UBkt+4TCLK22Tgxa4G5fdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6288

PiBPbiAxMC8xOC8yNCAxMToyNCBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gVGhpcyBwYXRj
aCBhbGxvd3MgdG8gaWdub3JlIGJpdCAyNCAoNjRBUykgaW4gdGhlIGhvc3QgY29udHJvbGxlciBj
YXBhYmlsaXRpZXMNCj4gcmVnaXN0ZXIuDQo+IA0KPiBUaGF0J3MgY29ycmVjdC4gSXQgaXMgdW5m
b3J0dW5hdGUgdGhhdCB0aGUgRE1BIGluZm9ybWF0aW9uIHJlcG9ydGVkIGJ5IHRoZQ0KPiBjb250
cm9sbGVyIGlzIG5vdCBtb3JlIGRldGFpbGVkLg0KPiANCj4gPiBQZXJzb25hbGx5LCBJIGFtIG5v
dCByZWxpZ2lvdXMgYWJvdXQgcXVpcmtzLCBub3Qgc3VyZSBob3dldmVyIHRoYXQgdGhpcyBpcw0K
PiB3aGF0IHZvcCBpcyBtYWRlIGZvci4NCj4gPiBBbHNvLCB0aGVyZSBpcyBhbm90aGVyIGhvc3Qt
c3BlY2lmaWMgb3B0aW9uLCBlLmcuIHRoZSBvcHRzIG1lbWJlciBvZiBzdHJ1Y3QNCj4gZXh5bm9z
X3Vmcy4NCj4gDQo+IEkgbmVlZCB0aGlzIHBhdGNoIGZvciBhbm90aGVyIGNvbnRyb2xsZXIgdGhh
biBhbiBFeHlub3MgaG9zdCBjb250cm9sbGVyLg0KPiANCj4gPiBMb29rcyBnb29kIHRvIG1lLg0K
PiANCj4gRG9lcyB0aGlzIGNvdW50IGFzIGEgUmV2aWV3ZWQtYnkgPw0KWWVzLg0KDQpUaGFua3Ms
DQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
