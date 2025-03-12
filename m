Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C835243951
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789530; cv=fail; b=Fzvxd34Yw0WmG9ZeNbbr8F9WWERnHFsgJtI6HJSiOpPNgCZ3pX22e6RNLhyLb1L22kjW56rLyHPwq7yYBT+EiHr3fi1kafl62bHF6KcKNegu1Md+g92To5y+ns24zCgb4QHkGQCqxyyoJpu5PSrvJEsdnB88pQXAW9z3GbBTYnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789530; c=relaxed/simple;
	bh=X7zGvPl4jwmnLLSmg5Xb7OkiaaL43ZUAQGURQWoRRoU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fj8EmSq0PsJ+/wRZrxioEkXu7bVhlu4UK9q6mdPdXotAb4b5wxZ9faINSh25xmfHIc4J1VwPV78JeU5fOcHhblLsEyxyPmkk/ymDtBzgXhetp3a3/fJnrc4eGeeGJEQ/B5synP2n9WGV/EuN4jr56DXElgiYfZuFmY+7sg+BnEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=PNFTYnit; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="PNFTYnit"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1741789529; x=1773325529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X7zGvPl4jwmnLLSmg5Xb7OkiaaL43ZUAQGURQWoRRoU=;
  b=PNFTYnitoGNKr0nSojvAm3TBopdvAKiEW9eye+ty0Pd11dB+Z+DW8bZX
   5TVANyhQySPOSOKdjO4Y4+xaJ+mjjyFPOPtUDKFiUB+8VgkI4X0usJEPD
   ekZA7Mc6OS13QBXsfHKhxbfgS95MAuWg+6u/WWlkbpgKSp1uc1agNgyVg
   b/lPIHqL9mIoxh538ALV9dVoW05MzoPqAatybkbp4KrCDI++Y8t3GA+BA
   jkgJCubQ9BCf3ohFiZfXTnJns+rddcei9jZJBdhC+ln9bPxeBRp39ofO5
   fa7CiAdFVh50wR2S8Goz3V6/MUm4mOTgFqTbybFq59m8GJ2hX8nzgOje3
   Q==;
X-CSE-ConnectionGUID: QKTFeeOTSxCZspbdTgDrOg==
X-CSE-MsgGUID: 6TlL36AJR3aDo4QieU6V7A==
X-IronPort-AV: E=Sophos;i="6.14,241,1736784000"; 
   d="scan'208";a="47147609"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2025 22:25:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sH1FqQXwiYlN6KC0b3HrEC2W9tSKA0zIO+ArFcHbFhjkgmuFo7Q8dBrme1m54KpRQ3hSZMUG0XqAgJGVf9NW449WUWJSRaZgSXQVUA3QUm6xZTenp5bgmC2/PvTBfTQZafznHiA9zHO4JxbuAKjPKirC/5mJVeT+XWrHNFpqgzIUwkTtVOD0twS9gJvhqf0/IgQHhRVC3SywAOT4fybLIrmNf/Twl/WEgRE93dmavZyY6fVl951EP1nhRcnAHA0TnJ4nEv6dIkTblyxNM4+B+ih0afS6pwsbB2MpFDmVL/Dl5Cjxlc9v9e7lSmFj6o6f9E5CxVacPgq00Xt3jlLFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7zGvPl4jwmnLLSmg5Xb7OkiaaL43ZUAQGURQWoRRoU=;
 b=yV49d/jtCNTX4poUGnVEwGVX8oQuAzEI8ZzL3DkQ8tYaufrUqCpPV10jhDHLJ09B3bCYZFy27mo24p+PJdTNkgMZZxPyf20upOngrZpf9+ycWPo8Ue/Pr1iyX9t8QEvjBdi9oPkDQ3gc7JLKKkrZBECY0NkWmowCzI8W/MKqMGu469UAwpP2/lMP0yzboKoLs3+paoJ+5NsphWgmYyLRVXW2ls+EtQvA/I1abOnxOSKSeLApeH+2bSxYUNYfkAS58jS046edDcQW39REu/XZRwquBhwDDmDchTl8bY57SglGYHC0K83aR3DOInyy0gazZsukun1Do+FZ1V/83xNu7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA0PR16MB3758.namprd16.prod.outlook.com (2603:10b6:806:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 14:25:25 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 14:25:24 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Eric Biggers
	<ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>, Can Guo
	<quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>
Subject: RE: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Topic: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Index: AQHbkr9r/c8CletXvEaSWcdgfTeG7LNvGcgwgAB0yACAAACXkA==
Date: Wed, 12 Mar 2025 14:25:24 +0000
Message-ID:
 <PH7PR16MB6196CC179C5F5E0F69F2FA77E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
 <PH7PR16MB6196B6AD43F68C7BE8128332E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
 <088fdfb9-00c7-43a9-acb9-e5300923d129@acm.org>
In-Reply-To: <088fdfb9-00c7-43a9-acb9-e5300923d129@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA0PR16MB3758:EE_
x-ms-office365-filtering-correlation-id: c6204a0b-d9a4-464d-410e-08dd6171babc
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TnAvQSsrT3oxaHMxOGo4eEhLUUo0cXlZSWhQd08ybHUrU3BIcXZjdGhJUjhz?=
 =?utf-8?B?dkRYSFBTU1ZJVjlpdThvaFk4dlZYSFhuZ1FMNExTNThXYVFZOS9reE1kbnUr?=
 =?utf-8?B?c2ZnWThXVy9GakRVeGJVNC9GYnJUc3RaQUMzUUVpQnB1TGpBQ0pxNEJhbllS?=
 =?utf-8?B?TjcvOGh5Y2VyOHFFTXk4TTV2NXU5UUY1T1VwVWY2YkRRUTNlQTR5Q2RVRERY?=
 =?utf-8?B?Sm5ab1A1Y3ZRang4SzRiYjNWVU9KZ1dRT0xYQ25zSGJxQXNTVE9xNGhUbGx6?=
 =?utf-8?B?WVRXY3g4MnNHZTNsc1NuMG1qMnZnV05NejE1QmhhVHdXUzIyUzI0R1YxWFZ2?=
 =?utf-8?B?d1RCMnlIa3JkaUtHMWtlVWRKbHVJaUhyY2ZyWU1oVnFSZEZoSE8zbDNkOXpv?=
 =?utf-8?B?LzZJYU5XU1J1TzA0YUhxYmdCUFpuNVlDQ09NckpwOG9wY0p0ZlRHckZzYm9r?=
 =?utf-8?B?NE5tam40ZUg0dnM0VkVhUTNqQytTbEpwUVpVajhENnl3anQ2NUwvOXRMWUly?=
 =?utf-8?B?N2hJRXpqN1FDU00yMUNGcnhUUE5KRHRFM0ZqY2lNZTZ1a0VaRDJvdmdwY2VW?=
 =?utf-8?B?U09pMitkQmxLR2pBTVVJNFFOVVVDdHFxaWtFeFhxOVdZcjU4ZTU3WDhFbXVM?=
 =?utf-8?B?QXd1dmhlK2trZnpPS2UrUjFxaCtGb3drOTV2Y2k4WDNlN2dHK0loK0lKRkdY?=
 =?utf-8?B?cnJINEJuNjF3QncreFJPenBxeVlZU0RxUThUQnJOZm9McmcweSs5cFJma2tR?=
 =?utf-8?B?SzBzZG5jbFh1U2FuQXR3dGNOR3pvZHhycEpVcURPTEcwUzlWdFJ1MHpMa3VB?=
 =?utf-8?B?dWtIc1k4YW9aUXVHZzlQeDVDRHdocCtPeUs5OVQ3Z2YxUkltNWtDZVR2VWhH?=
 =?utf-8?B?M0g4UUw5NUFJdVVlb1BKcnp1WDZVblIzUnhXWEhOTTUyek5hUkZNWE9FeHpD?=
 =?utf-8?B?TWQ2NjV1ODdoT3gvRFN4RFBhN1JzKzdHcVp5WnFoYlRYclorTCtjK1lodksw?=
 =?utf-8?B?K2paQ3RKclZ4emlwK0lzZCtBSkdlZ2lGcFRZYUlzOC9rdkFlTEk0dGFPYXR1?=
 =?utf-8?B?UXZoM3V5Q3J0MGRrRTh3TTlNVTB0bUZYN0VDWjZpcmE3dkJ5UWwxR2pSbWs0?=
 =?utf-8?B?OFN3RERCbUM5N2J5SUMvUUtGblhWTEgrK3VYM0VzVlZ6UzcwZlhzWElxK1du?=
 =?utf-8?B?TU51ZHNCcEhlajJIenNZSDNCNFo4Z1NyU2ZwMXBwamd4Ym1EWWhTUnJUdzg4?=
 =?utf-8?B?YlhPN1VjZ1I2ODdrcGN5M2dBQk16akhLUDRsUmdSS0tPZHFCSlBnYnVtUEdQ?=
 =?utf-8?B?Q0Q2ODBubkt2UWQwaTBkeWNMMElSWFh0MGNKTTczMjExMWpXRXZLSUlIWXNo?=
 =?utf-8?B?SEhtZjcva0pqWUVVRnZVcTNXYjcyS056YUtvTS80TFBlUEJUVHc1WStsb08v?=
 =?utf-8?B?SFJ2TCsvY3NOSUhTTldmZk05TzlvVTJZdi9vRVRpVjgrYTVmMXNOcDhoWlE3?=
 =?utf-8?B?QW5ubzFWOEF3UGl2cERVVGVjUnNob3V6QmxLd0FkN1d1Ni9lZm9VNWRiQkw5?=
 =?utf-8?B?Y0IzdFdTTGp0czdkUTJYaFN0SjJZNEpVek80Y3c1VVdoWGFjYXdGS3ArOVR2?=
 =?utf-8?B?WDRFRExFbFd4QlhpNDNOYitESkR1VkpLbUhFeGxKMFRoNWhtakFkcVVmck0r?=
 =?utf-8?B?VndoYUZVZ0owa0hIem1CaVpxTzl4TEtqSC9iWXJ0TER2eVRqUW1BU2hKeEFt?=
 =?utf-8?B?UHRpS0tySjB0VUpvd0IyWnExTCtibHk2QUE2dEJUZUxvaGl3VmJmVGdkc2FL?=
 =?utf-8?B?cThESGVkNllyOXlsOURkZ2pXdXJ6bkVuNWF4WEtqTGtHQVREZ0dWSnZpRTRH?=
 =?utf-8?B?Y0FrYXNNeVg5U3FQcEUrd1NIeUVDejMrNHdnMHBEL3lkQTM5WHF3S0ZOWlZU?=
 =?utf-8?Q?kHdMEr4f3jESMoFf7tK1kpJhCHA/1YkJ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Sy9JN3hBektsWGo3TGtQcVM2MkFUM0R4bFJqRFZJOGVja0d4RVdrWTNQcUFP?=
 =?utf-8?B?bXc0dDNzZFpJS2dBMGkwVitweGxYaGZOVFg4RVQ5a1NOZHYvT3VmTnpxdmw4?=
 =?utf-8?B?eHJ4aG1pUmhjaGR3Z051cUwzT2hXazl2TUM0eFNCQ1dYTEpDMC9JaWFrbnRZ?=
 =?utf-8?B?c3grdW04ei9mTU5FTHB0YzlidW1WM2dyQnZkSkVmNVl0cWxyNUlSSUtUNWxX?=
 =?utf-8?B?YUIyVC96d3NPcnlGcXRGNVlyVXI3UFVuanVHZ01NVzBJSDI1dkZXZVd5bWpU?=
 =?utf-8?B?NFErRkNoT29yL3liVnZ6QzlBTC9nMmZOMjh3b3FNenl4WVAyQVRjeEhCOUdZ?=
 =?utf-8?B?WEdpeG5VWEcxeThGUHFjVGs5UkluNTNmWlVOQTNRQ1AwOXMyZzJuUHN6ME1C?=
 =?utf-8?B?SFJ4ZXhOU0M5dDk4L2ZzZFV4VmJHMmNXOFdiRlFvN2pZZkRGMXhKZVVzTmkr?=
 =?utf-8?B?dk9iNVpHS1kraXd3TnBIS2V3b1l5SnE1WURWMWplMGZPckk3ZXFCWFByR1VI?=
 =?utf-8?B?Yi9mdVY1MjkxSDlyN1Y0ZytrUFNjQXpFM0Y1RGZlTmsrTUdFa2RjbyszczFt?=
 =?utf-8?B?T256MCtXQ2YxZFZiazVwTXJ4OFZaYy82UHhmcVROUTdvazErRGZxdVlqNzVP?=
 =?utf-8?B?SDBGc3U4OTNTWDhTajU0V2c3cFJjOWQ4bWlsbFVPcmx2aDV3WW5VNVRzVzBo?=
 =?utf-8?B?aEU4UTJiaDVQK2U2N1FhcXVyVTNPdjJhN0NMcHJRZTZQazNQSndvV3R6VWRp?=
 =?utf-8?B?QU45Uks1dEFja1JXdTFwTGI0dUlJS0k4Z2t6cmRjLzk1SGV0elFrSmYxR0hV?=
 =?utf-8?B?K1k1SjRxejJGSVVMMGt6UlFrRGtFK1NMRzlFYWdjME5ZdVJVYVRBSVQxRXZD?=
 =?utf-8?B?eGI4cnFrSTJvVVZnVkJleXVSUlZtaHlTbEQ3cEJLVkNWdE9DdXpBU0dHa2di?=
 =?utf-8?B?UHZqN3d6SkJCU0pNYWp1eGt2Q0JHTWYzdHRqZmIwL1pZaU0zeWlJRUxwNDR6?=
 =?utf-8?B?K3RuaVdGYzBsL20wQlJ6UENRR3ZDRWZCYkRxdEZiWkVpc0VUc1dxWFlIUDdH?=
 =?utf-8?B?aCtBNzZ3V1RueXNhQUFoV1BLSXhFMWVEcjl2dHhQbFBQTmt6UGFCWlc0aVVB?=
 =?utf-8?B?Zk9sSENKeU5hOGllYVFBMEJ3bE00YXY3dTJzaVllT2IwTXl6VmIrZUVWcUhS?=
 =?utf-8?B?b0hHQWNmajN0eVlHc3JHNEF4NW1kMkR5N29YZlNTQW1Ha0hGSmVINkJ6R3RS?=
 =?utf-8?B?akwxdnUyZnhLNEh6ZURaY3JpYURMVmFjOFZYbXdneENWQWdZeUxnbTJoVlBV?=
 =?utf-8?B?bnY3Z1FleHJ2aWJSQS82bktYZTdLelk2dXZlVFArczNxdXpKWkZtMEhlM3Va?=
 =?utf-8?B?UEhsUmE2aVZ1N2RjNzdBWlBlQjJuczhRcXlhekpyNkdYWGx2bm81N29lSU91?=
 =?utf-8?B?KzlScnVMRjhKUlQzY1Y0a3NFeGw3NDJ3S0pxZ1pWZFJqbFNyWlRzMkMwMS9o?=
 =?utf-8?B?aVEvS294YkVMd3MxR2REL0RSbk5mWjNDdXdWclhEZVJ0SGpqaS9VeWIraXdv?=
 =?utf-8?B?QnFzMzlMQUxjbjN1ODh1VEU0blRNd1ZVNlIybGh2cmthS04rdzg4Rm5UZ3k1?=
 =?utf-8?B?YnB2bit5cTU1bjVvQXljenNVbzBURDF3bHhFMHlJZlhYb0loV0xJMWNMdU12?=
 =?utf-8?B?Y0VuOUpJMGVZYmZuR0lUc3o4Z2FhalhnN3FwVlVQbW5YVUw0NitJRmZ3WXhp?=
 =?utf-8?B?bFJNNFdKUDUzNWVsOXQveTJocmpicHlhWXZFeE1lVytwdWhSdDdJejBFVWVW?=
 =?utf-8?B?YWZBK1gwSXk3ZXdnTUlybUF2V0E2YmNlRjdGUWJVZC9la1hsemV3SytncVM5?=
 =?utf-8?B?RldDdjdlT0Z4QzVmN1JTUEsyT2dxZ3FZTWR1Z1pucVpoS0NuanJ6MUg4UU9T?=
 =?utf-8?B?Mm1FVS82RngxL0FITWlKc0pmWnVYdUFpbnZoUUdsTVYwem0vT1dVREs2OHFS?=
 =?utf-8?B?RUsycUNOc0J5UzVxdjFIdVNaMkMyUHlMRWViRHI3eExLSVkwV1N1MFhzR0cy?=
 =?utf-8?B?NmZQa3kzVjRiL2UvZ3ZzU1A1SmtNVUhBRFIrRSt0YlZidkJpNGRwNTArNDRn?=
 =?utf-8?Q?AHWQlYVn3gN92clf2KcVyUHYV?=
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
	dNTx68GOnr76ax78V1nMrc0s3wGcwF3TNHlvX/K6/HFwmvVFhy4i6P7B5lJO0/nb3XW/cro9WnMbAiC1M5yhJF4ciWmsv/f8TUTy8akrnFPoLAzDJ7WB7BV3GW7xUU1KDrGzpeEyFvg9pRkIBz4cIj8vaNTHjV7SBsFvdDjhK7oZO5/fDaYtyxkfnBdZJ6/+XKvd7QX6BalWn8JCXbJ5VhVBwn66k3R8eboESwms2Lytbw1HCvvKL4i/gBRThAOSTQjpGyhkKw7TnkyTDjlmXBLjsgxYoxBtQZojsjJhKZr/8d2QFjrKkCN5hdGuNzWKw5Wp/2EoOauRPHx8HndEl5WCH3nk4NwIQgd9ztaGOYZBqAPHWYSlfSk4c8aKaMovNhb796GsEhYE3bTeTAzGZzOOcGuJS6NqcXLcKar4gwU0jv/zbrewIDJoRz+6pk3KCaS5tCcSBTRcrr6oxl49SIZvHa83JhY+cGR9kMDJfVQDajActkJh0zVIZORr75Wfc4jVLcjbtzUe94/PAeaJlGnJX1XM+hMx7Cj43Gtpsaytl3frF/A/3nO/S2SUc9FJQpzTXIaUkNr8xgj4CYlvlw/LznAOynq0yiaXM2DdUzj1wxd3LLYYxVCA0QDmN0tps+2RbcZ7sXjSNKD1KAyOLA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6204a0b-d9a4-464d-410e-08dd6171babc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 14:25:24.8353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6iClooXMhA/pG+1/Rqh+CabuDjIaRiVMaHoTcuQNky/vRkuUz8RIZBBHEFKBkM2b1A4FmbaE2VRsXHodY027PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR16MB3758

PiANCj4gT24gMy8xMi8yNSAxMjozMyBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gSGksDQo+
ID4+IFRoZXJlIGlzIGEgVE9DVE9VIHJhY2UgaW4gdWZzaGNkX2NvbXBsX29uZV9jcWUoKTogaGJh
LT5kZXZfY21kLmNvbXBsZXRlDQo+ID4+IG1heSBiZSBjbGVhcmVkIGZyb20gYW5vdGhlciB0aHJl
YWQgYWZ0ZXIgaXQgaGFzIGJlZW4gY2hlY2tlZCBhbmQgYmVmb3JlIGl0IGlzDQo+ID4+IHVzZWQu
IEZpeCB0aGlzIHJhY2UgYnkgbW92aW5nIHRoZSBkZXZpY2UgY29tbWFuZCBjb21wbGV0aW9uIGZy
b20gdGhlIHN0YWNrDQo+IG9mDQo+ID4+IHRoZSBkZXZpY2UgY29tbWFuZCBzdWJtaXR0ZXIgaW50
byBzdHJ1Y3QgdWZzX2hiYS4gVGhpcyBwYXRjaCBmaXhlcyB0aGUNCj4gZm9sbG93aW5nDQo+ID4+
IGtlcm5lbCBjcmFzaDoNCj4gID4NCj4gPiBDYW4geW91IGVsYWJvcmF0ZSBob3cgdGhpcyBpcyBw
b3NzaWJsZSBpZiB0aGVyZSBpcyBhIHNpbmdsZSB0YWcgZm9yIGRldmljZQ0KPiBtYW5hZ2VtZW50
IGNvbW1hbmRzLA0KPiA+IEFuZCBpdCBpcyBvYnRhaW5lZCB1bmRlciBsb2NrPw0KPiANCj4gV2hp
Y2ggbG9jaz8gVGhlIGNvZGUgdGhhdCBzdWJtaXRzIGRldmljZSBtYW5hZ2VtZW50IGNvbW1hbmRz
IGlzDQo+IHNlcmlhbGl6ZWQgYnkgdGhlIGhiYS0+ZGV2X2NtZC5sb2NrIG11dGV4IHdoaWxlIHVm
c2hjZF9jb21wbF9vbmVfY3FlKCkNCj4gY2FsbHMgYXJlIHNlcmlhbGl6ZWQgYnkgdGhlIGh3cS0+
Y3FfbG9jayBzcGlubG9jayBpbiBjYXNlIG9mIE1DUS4gSSdtDQo+IG5vdCBhd2FyZSBvZiBhbnkg
c2luZ2xlIHN5bmNocm9uaXphdGlvbiBvYmplY3QgdGhhdCBzZXJpYWxpemVzIGFsbA0KPiBoYmEt
PmRldl9jbWQuY29tcGxldGUgYWNjZXNzZXMuDQo+IA0KPiA+IEFuZCB3aHkgbWFraW5nIHRoZSBj
b21wbGV0aW9uIHN0cnVjdHVyZSBwZXJzaXN0ZW50IGJleW9uZCB0aGUgZnVuY3Rpb24ncw0KPiBz
Y29wZSBzb2x2ZXMgdGhlIHByb2JsZW0/DQo+IA0KPiBXaXRob3V0IG15IHBhdGNoLCBoYmEtPmRl
dl9jbWQuY29tcGxldGUgaXMgc29tZXRpbWVzIHNldCBhbmQgc29tZXRpbWVzDQo+IE5VTEwuIE15
IHBhdGNoIGVuc3VyZXMgdGhhdCB0aGUgcG9pbnRlciBwYXNzZWQgdG8gdGhlIGNvbXBsZXRlKCkg
Y2FsbA0KPiBpcyBuZXZlciBOVUxMLiBEb2VzIHRoaXMgYW5zd2VyIHlvdXIgcXVlc3Rpb24/DQpJ
IHdhcyBob3BpbmcgZm9yIGEgcm9vdC1jYXVzZSBhbmFseXNpcyBleHBsYWluaW5nIHdoeSBoYmEt
PmRldl9jbWQuY29tcGxldGUgaXMgc29tZXRpbWVzIHNldCBhbmQgc29tZXRpbWVzIE5VTEwuDQoN
ClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
