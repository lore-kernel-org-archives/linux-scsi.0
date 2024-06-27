Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375BA13BC31
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 10:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719485788; cv=fail; b=Rcf46AS82apWjJ2eLzwjURMqoR7Q9c41uwXC+K3hmH8jTsbyrc1bZyvLju313kl1IS+cVJUbcvgpHQ87+H5ADeAy7s1qjLwnGRq7WldbfN+YCbWh80wAUXp2qk3dyhAHamzusX+FzN66PhEcrm8PpTOcbDMoXQzNTXO0aladyHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719485788; c=relaxed/simple;
	bh=sUsKx6j2WetdeIMvmD6wM0mn6/WATb2EAFFVw3582YA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F9sj8vVmLnXjtVjIRyP49FEcGKE9mGLJ4BAsiOiKHgZLjgTjtUvUS+C4RF7N1ow82F/xC8rSNJ1aVxGLn9tSpHlyGXF0rE6iK/abjiPpFS1cSrtnZIG6uQ2Q/SoV1vnIqaXZLMcNYHSGa9MrXGz7hO8fpWOlZ1Nh7aPXH+BdCZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fdiHuur0; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GfACJn9U; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fdiHuur0";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GfACJn9U"
X-UUID: de962d74347311ef8da6557f11777fc4-20240627
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=sUsKx6j2WetdeIMvmD6wM0mn6/WATb2EAFFVw3582YA=;
	b=fdiHuur0Abrly98755fB8cUBsWAQxVU8H4SocdHCXBwS4TkwzqgV17KZgjdJzYWyOyaLmhWWevWuAAhVfFg+yceS6S26uZ3rbdEd82Bmfh/GPU17fbVLgHvGlGaaDaqv55gRSSvO4PX8XfLZAKN3TGLWIhw3I/V5acpdFEfSngY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:be00e30d-6839-4424-b5c5-3fbb251a93f8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:ce32a144-a117-4f46-a956-71ffeac67bfa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: de962d74347311ef8da6557f11777fc4-20240627
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 941274730; Thu, 27 Jun 2024 18:56:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Jun 2024 18:56:10 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 27 Jun 2024 18:56:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KP6RRB78XruseN+V4Ng0WL2mbQjanG9ygjfa2ipP1Ns/ilnGC44K3iwJqG79zB04yeZCVgNQlmRTKvGU/7cWxDdh/vCF1RqJ+CRXsZM560D4sxCY7Q015ql41RHwB2dyi1sqxTcpOH9vCttYJqVpwTSmnHnyNzooxGnnjovSR7uX53RCG/pNf5JjOJAEMMqWtjhAr1SMUNKjkA5BqEKUTCqzfY0tRT47LjCpS10aoEjBn7TkALW2udSP9q3ZuMuOfHmPwNCEG1QSeNJROuqxBuYENolhf8Fa50YIpbbQ4C3CqFlp5PTxLh4QPJQmxFT9L370dAeO26mS+IlXJCtUUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUsKx6j2WetdeIMvmD6wM0mn6/WATb2EAFFVw3582YA=;
 b=hms6Gwx/gsVwINEBz7jXqNcGRK1YoBxTO8eK29RhtRa2WZKJpEJS2TZ2JB+3uCA27Z0+CG9aHv/34ibD47iqJUjUDLZ82lVf/iLcVA9ALn1Mz+ejvJk9m6G1BTifneRGQm7XRZLBzpcK0HIPpajlwXcuuFjOIg98GapgHixFFXoT0OTxkFmqG3Q8Eyvno4D98UWx3jM8LirCnsr7vfNAn5LDI819PvxJjQHbiWRSjnuEIRt7xA6l9qh6Xb9YioSqr8i28r7R2CavEkOowMlGcbKomJJRKnDsnon8l/gl1P27GxIfKF7zO2KIwLpUqT0UNNZzmTb/9oDVZ7dkBzJqAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUsKx6j2WetdeIMvmD6wM0mn6/WATb2EAFFVw3582YA=;
 b=GfACJn9U7GHAIhh9bY1gGbyyGP4UBzxctDEPzXBeUmbzzWgCE6EN+8JmuqlnAKzpZqCsQ7KWPZT2Tw0hMcl0JRL7++nXSWFhyU+Q/Suxwt/0AbR+k0j/NK/RqJq/o4Eev9mjXt4L+gvw28AVhrsY3X+xyQRrKTdraWHycGNRiQY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8634.apcprd03.prod.outlook.com (2603:1096:101:228::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 10:56:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 10:56:06 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Topic: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Index: AQHawPrEvEtR2PxEBkyAfPJ3MA8LCbHRzdSAgACvsACABCixAIAAnAsAgAEJ1YCAAGyzAIAAvkkAgAEt1QCAANpbgA==
Date: Thu, 27 Jun 2024 10:56:06 +0000
Message-ID: <c8d6926ce0db4889238b18c573fb967574956361.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-9-bvanassche@acm.org>
	 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
	 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
	 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
	 <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
	 <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
	 <b302c1ae-2cbb-4906-81f2-285c2b913109@acm.org>
	 <5bcf25bb6f0d3338febf350716df8590a41af852.camel@mediatek.com>
	 <edd84a4b-839f-44a6-b7fb-9e875a2598f9@acm.org>
In-Reply-To: <edd84a4b-839f-44a6-b7fb-9e875a2598f9@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8634:EE_
x-ms-office365-filtering-correlation-id: 10dd6af7-8068-4f34-7b82-08dc9697bea8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ckpWU1ZsQ1c3ZmRBdjA3SnduT3hyWDNqWktIYTVHbVFBNlJjaUZiTlpMVmRn?=
 =?utf-8?B?dmhEK0VmSE5sT0Y4Y25xZk1NQTFxYmVSMzJGVVZuTmVadG4vQVBMbVd0THM4?=
 =?utf-8?B?YWtzc1pwa1psbVZoZi8wcWNkeEFONjRLNEk5R1hwaXJKekhRa1FCcTFqVjJP?=
 =?utf-8?B?S3Qwcjh6NVJMUnZvODVJellqUHlCbjdtMGkxYU1WSVJsMS9xVlNhbE1XQmQ2?=
 =?utf-8?B?ODQxTEYxemNVZm1jUzBIUFNMcVhMSmVYbUlzdUVVSXFqdGdJa0p0MlRNTXo2?=
 =?utf-8?B?T094dTN0ZVUyYk9vRUdXZ3dLT3FMY2Z2UTlLM0oxaFp4VzkvbzRvUk5LMERw?=
 =?utf-8?B?bW1IM0c0YVhOMzVIS2k4clpLM1ZDT2pndENGWFIwamo1TXVMOVVMYlJZa2c3?=
 =?utf-8?B?ZVFLRjZkOFhlcm5OSlhhaXVNSFpsZkVEMzZDSzB4elh2dUhaNXhUODJoZnRu?=
 =?utf-8?B?L0JuOWVpZFZYclhMczEvWlQ0S21iSDlzdnViVDFiQXQ2bWlTUXdIMllPb0xJ?=
 =?utf-8?B?T3VFYUR0eUFHbG1JaWRKR2NqbloxNU9kZmNjSWN4T2dpbkhGZEs1ZXN0TjJv?=
 =?utf-8?B?TG8xUEc4L1I0Tk1tMHZ3MVJPbGxVZlI4dEV6RXFVbU1Eb3pWckVNQ0Nva3pi?=
 =?utf-8?B?cVA4Tk5oSWhFVEt1UXk4Nm8rTzhnNUlpMzVnSXN2QkRPeWRkemZERG44NE1y?=
 =?utf-8?B?cWViK0NId3pIMWY0SXVDamhwWTgwK1h5L3J2blJKdHM3N2FoOXV3blFRK0xF?=
 =?utf-8?B?M0czK3N2NmtEaHZ6dFJIRGZrRmo3TURQWDNqM2lTY3ZCYlpjNTlIZ0lyaWRT?=
 =?utf-8?B?OWRhaGNCdmZMR0JaRGIxbnBrTDRnRjkwYUFua1ZtY2d2SHpGaFEyUlRPc0NT?=
 =?utf-8?B?V0YzVWFCRXhGRnVaT3ZOTkpTMG80QWxha1FFLzBpeFd4MXVwUDJCSGZDRXZX?=
 =?utf-8?B?c2dnUGd1VXl2Z2Z3amlqUUdxSDRaMy95ZnhTZFBCWXVGNE5FSXBjcTlsenkr?=
 =?utf-8?B?MGNkSC9FdDE1RWZFcFQyQjU3Ti9QQ1lrS2pWcldjU3g1RVRvVDgrdVBEeE0z?=
 =?utf-8?B?cnMvbmNzclUvRkxKUTZmSDlZc0lYa0J2bzEvQU51U0FvS1lPdXZIY3hWUUpx?=
 =?utf-8?B?c01KQWxua0libGJGTHVoZGNtZEE3TERZZ09wV3M4TXJUeEdzUU1FM0lDQzBV?=
 =?utf-8?B?VzIxdVF5L2VpWUdhZHd0TjQ0MGduL1Y5eVNGOXN6RnZVbGZJZ2EvVXBCZWZt?=
 =?utf-8?B?TmUxK3JkYzcvaExCUXppdG1JNWpEclVIaDV5NmczUHo5RCtuRThlbzdsSHh3?=
 =?utf-8?B?aElibnpvQ0dKZ0tsRTEzTkNBbEhYbjVwVkRXa0t3eVpEM1QxdmtybkEzb05X?=
 =?utf-8?B?ZnNrQnVBdm1RNXl4ZDRlVlArV2l0MFFOY04xdU5hdmZiZDIrUkVOTGlzTTBK?=
 =?utf-8?B?dk9yTUp3RVpjVkhjNUtMdlpNWFpWcnExbUdGVVBqRCt2RE50K1gyNVpZaXhF?=
 =?utf-8?B?SGlJOWNSY25kd09tc0U1a08yWU80MVBtb1o1S3Fvd0d1dzRGbWZqc0JnaXNw?=
 =?utf-8?B?ek5EWUlET3BzQzVla3JLR1BDTy9aU2QreHNDYlhGL3RXNzFvMlkrd2RmNjA2?=
 =?utf-8?B?NUpkVkRYcEVyYSt0ckRHQktCOE1VWUF4Z3pPSElibkdpMkdxT0xmN2NoK2My?=
 =?utf-8?B?dnJ4UnB1QVFZR0lXWGNUWjFSR0VHS0lSTVl3YjRNNGJ2RmdzdDRlS1lZeFhR?=
 =?utf-8?B?Vk1BaU5XZmRvUWd5VlZyUkpib2JjTHRlaHBZVk1YZ2hrZUFNTXc1L0tvekJi?=
 =?utf-8?B?U0hqWG1ybk9SM2FXbWs3OEM4TnRCalBNQnJ5cFdKekdGdm9PbkIyaHM1RlNF?=
 =?utf-8?B?UnZqcHRZUDFaK0d0Y2dnUjNrUC9VY0ZEbE1mQnNsN1NBMkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eW5kTUUrMThxdFpPc2tCVFUwSGJKZDE0Nm9qRE1aUDhiWnVjaXF4NWFzQ1Zz?=
 =?utf-8?B?eTdxVjQ2WnExV1ZweVpWQWF0WkhhZGNSYStOOHJlT3RJUjZDbFBPZmhQYm9p?=
 =?utf-8?B?UDRLSXFhNTNjQzByMzQ4TmpQbld1TkVyZVI2dXlLNzZqTmRYR0pVcnUvTk5r?=
 =?utf-8?B?WHpacE1lVy9XWTBaTTJ0RG1PUS9VNCsxbzlkZi9UZWlzRG1PcDc4WnR5UVNV?=
 =?utf-8?B?ME9BZlpaZ3pvek9JUVc3dmlrNTFBYnhiYk5MUUxPQnJoWTJJR2RORkkwLzZ6?=
 =?utf-8?B?ZDRJaUthYlY4MFY5T3ZleUd2blZXVHYzRjNuc0Z3SFlyN0F4VWpGVGcyWkV6?=
 =?utf-8?B?KzB2Z0doUHFCY0lua3pyRStWbURWaWw1QmxzeVRGSSttL0pxbXJNR0w0OVBw?=
 =?utf-8?B?ckJHQVdhS3BTSGc3NFJmMDBvMnFJN0FLYUxBeFpPMDAxYlNwMlNNSlUzdk1p?=
 =?utf-8?B?VUV3amc4N1lFN05GMzVHajRpTFprU3hXM2VtZTl2SG5obm10Mm1WT1IxMTZ3?=
 =?utf-8?B?Uk9jMWpSTFA2REVWSW9qTlVmTmdQVlpJYkg2MmNEc2tIcyszMFFmME1UYmkw?=
 =?utf-8?B?b0dCb0hOUDlHczBWNnhFdnFJbDZTa1dhRDhQc2JVTlNUZGtvU1MvM2pGS051?=
 =?utf-8?B?MFhjRkk3ay9kZEpqS1VhUzEwK1lyV09Bayt3QUlUL1ZXRWcxSWYvVDQ0Z2lh?=
 =?utf-8?B?RVhKM0NOTm1HUHU0SjRQakU5b3BGMkRhZEVuSlliU25NbUhwamx6UUhLZUJO?=
 =?utf-8?B?OFJXeGswcTltK05IZWtJaHM5c0xKYityWE8zUUtsbk9LTDdSMWh4YktTcU9l?=
 =?utf-8?B?TitXdEdUczltVmNHdTJ4SFh2VDFKUXJzZngvQUs5cjFRM1kwRFU5amN3M0pL?=
 =?utf-8?B?S3hGb3NNQkdTNHdGelhQVytLTjMwM0p1dFhDMDdzSG5obXJtWVd2dVdNajAx?=
 =?utf-8?B?MmQwOXI5OXRUaGhpSXcvdlJxWkNTYXhERmZkbEg4RHFKNzJmalg3S1NTWURw?=
 =?utf-8?B?czluOVBhemRHeVNqNFJ3NUtubkw5T0ZmSjBURzhpVlFCaFlEeTZMeEd4bTNN?=
 =?utf-8?B?OVkybXB4WDREWDRQMEh2dzhUS2N4NnlDNUtLaGc1aWFZcE94UHZxMkZBZ2ZW?=
 =?utf-8?B?ODJFWHdrcmh0TWlLZm00Um1jNjdWZjVrSzlXemJGM3VQMDJmdTdiODFsSkE0?=
 =?utf-8?B?ckh4dXdzTXlDZ1FYeGJSNDNOTGF4YUNEZDNJakp3eDRwY0JrRkVTMCthNVR0?=
 =?utf-8?B?U25nRElwM3BjVTNyaXRqekhvVWxUanpnMlp0RmJ0VmZIN1FNSTFOYSs3Z3JU?=
 =?utf-8?B?dnRPUUlXK3hCVHpPRGlWMXY3U0tQdEZycTk1SUQzNkU3UFdwUzZSUjFnN1NG?=
 =?utf-8?B?MnlQelBqMnl4cFlwVDcwUGFZdmpEeENhcjBFQ0hRaHpYVisvTnhybTRHT2RL?=
 =?utf-8?B?WHNkd0NidUhQbTZQaUg0K1RkQ0VqclVoNVc5VUpsL0RVeDdxc29VSFlNYlZu?=
 =?utf-8?B?SFB4QVovaU54SWtWcHV2WUNxMUhSd3lMbHJ3VjZXWnFxem41RmsrWVBGK3I3?=
 =?utf-8?B?dk9PaERYUEREWVN0aTlxaEMwdTVKcVQxcWJqd0F4TG9jaGY4UUZ4LzFBR1A0?=
 =?utf-8?B?ZEV4WHhLZlR4MzBRREtXcGdFQ21GMmtUWExTcFFzZFppSGppem1kQWhOcDRy?=
 =?utf-8?B?TG5pSVZXZ1o2Z2hjNGNRQm1BSS90dDRnM0p1dHRlTUdRZFpDUGhtNTdEY3Nt?=
 =?utf-8?B?TFRqbVVHSXh5Y3hZTmphejVJbEdPMkFscS9Bakx5cExwTTZuU0RjV1lLK3hV?=
 =?utf-8?B?ci9tTU1sYU9DbUN3eDJ3dGRmQjRqOGZkd1FuMXFOS2p2b3VUUTZ2WVBFK3Iw?=
 =?utf-8?B?bXdzSWZnMVVHaEoxM0pXbzBhQzJHOUFkUFNLVUFGMTZqMHhCQ2lPQU5Bd3RT?=
 =?utf-8?B?L1p5aThsQnNkQmI4SzAzc1dhQlFlOUw3b09pYWxQQ0lSV0VYOGFsQnRWeXcy?=
 =?utf-8?B?WXZON0NHZVl6am9JMmdmUW55STU2cHYvR2ZRV0JaK1Z3NzdwMEVRZWRPTmw2?=
 =?utf-8?B?Y0tFSksyanZja2swNkIvOWU0b1dCWlROYWJQdFZZVmViNHYzMzJGN1JNblZV?=
 =?utf-8?B?cW1KdkZ4c0VtYzhZaWNPU3F2eUxPeE5hc3hBR25lMjhOeW5SS29OcEM5czZQ?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E8A9DFA6A0D6D4580715618D505039A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10dd6af7-8068-4f34-7b82-08dc9697bea8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2024 10:56:06.2405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gKuiR0mGLfVyPSVynMt30e4YXJVPMzg1U+Rnma6dGTRAH91e6rRbmPpNKp5MlqWepEoACFiVvCk3yBieKLTjnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8634
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--22.950100-8.000000
X-TMASE-MatchedRID: 0aps3uOmWi7UL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTfhQ
	4FB19kmoZFQZ0fEzy6fBUU9pHq9NZSqh89G26qAgQ9/tMNQ4aiiG4xLksx3hxuWYx8s2K6RqooS
	DAIqqmjkLx7nOQFaYCPK2mPajSWmzgwb2MnLCcFZ4CIKY/Hg3AwWulRtvvYxRlgn288nW9IN5/H
	gWYxplM5MIx11wv+COQZS2ujCtcuA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--22.950100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	7B4ECCE6A94B19A022D84879C7123C82E13254CFAC46E94F1331F21A56549CB32000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA2LTI2IGF0IDE0OjU0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yNS8yNCA4OjU0IFBNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IEFuZCB3aHkgdWZzaGNkX3F1ZXVlY29tbWFuZCBnb3QgbnVsbCBwb2lu
dGVyPyB3aGljaCBwb2ludGVyIGlzDQo+IG51bGw/DQo+IA0KPiBJJ20gbm90IHN1cmUuIGZhZGRy
MmxpbmUgcmVwb3J0cyB0aGF0IHRoZSBjcmFzaCBoYXBwZW5zIGluIHRoZSBzb3VyY2UNCj4gY29k
ZSBsaW5lIHdpdGggdGhlIGZvbGxvd2luZyBhc3NpZ25tZW50OiAic2dfZG1hX2xlbihzZykgPSBz
Zy0NCj4gPmxlbmd0aCIuDQo+IFRoYXQgc2VlbXMgd2VpcmQgdG8gbWUuIElmIHRoZSBzZyBwb2lu
dGVyIHdvdWxkIGJlIGludmFsaWQgdGhlbiBhbg0KPiBlYXJsaWVyIGRlcmVmZXJlbmNlIG9mIHRo
ZSAnc2cnIHBvaW50ZXIgc2hvdWxkIGFscmVhZHkgaGF2ZSB0cmlnZ2VyZWQNCj4gYQ0KPiANCg0K
DQoNCkhpIEJhcnQsDQoNClRoaXMgaXMgcmVhbGx5IHdlaXJkLg0KUGVycGhhcyBpdCBpcyBkcmFt
IGNvcnJ1cHQgaXNzdWU/DQpBbmQgaXMgdW5yZWxhdGVkIHRvIHRoZSB1ZnNoY2RfYWJvcnQgcmFj
aW5nIEkgdGhpbmsuDQoNCg0KVGhhbmtzLg0KUGV0ZXINCg0K
