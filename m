Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9415F3C17
	for <linux-scsi@vger.kernel.org>; Sat, 13 Apr 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713034863; cv=fail; b=rldKchJQpkicXxwyjsKVYXc+akd8NVgRpRKIsxFFgtyQmePxCK5dgreYVMdDSIrpu/v5hgHxmnu+uj6ltnlviSd/X/djvSIl5EkgiRqLnH4iFi/wDRMcOybRlozLmKz5EKyneIHWsktYU0C2H9Wf5D+9jeAwRfoBRHlPQcxT/Uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713034863; c=relaxed/simple;
	bh=Zp0tQ8zIiJEnD/hosiRDBJKiesVwfNGnsC9bxaKsrgo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aPJ7vQ3NhoxETuupSevIkMEKWBoJYzlp81KjelfCvXfyCIarXLKYUglMwsP8Ge/vIHpmdyvl5fOs5B0p+ei8BA9uZOFbA6UPe9fmMJUbdi9Af7F/kvvA/BRy8kqUkxFfTI4dWB6sJZIaFWbyauozfuI5Jw6l3NSsVKVuh+dkGr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mYH3rMCf; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BySu+4Zn; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mYH3rMCf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BySu+4Zn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713034844; x=1744570844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zp0tQ8zIiJEnD/hosiRDBJKiesVwfNGnsC9bxaKsrgo=;
  b=mYH3rMCf7Xev75+FTOewVagBGKOcY3WrJP2YjZOO5zM6Icv6oggA/GdZ
   uQYNkEQqB9chewt395lklMGlZ2mkEY9hJYxQT6osi2Q+2zimHtpbtp7dF
   iRICUg9R8nr9dCs/L0tkicXt42z3cdu480Yl4fojc7oTek7WP2uIMhtUW
   nv5mlVz0fzeqPNfdYLVIawZK6chJ01W/h8Fhyk39QQzvsuzP6ro7NFioy
   xvhnuutOl1kUH66MjgZuJRB5IbBrvVEgSbNirFNC8I98j0aq1ta24TL/n
   W6I/er1m0Jxwib7LMWn5aktv8uexCEb0csxbM4j2kVmnekD7jJC3dHH3C
   w==;
X-CSE-ConnectionGUID: kPjDrwTQR324OvZoCyedsg==
X-CSE-MsgGUID: s5XsWglvRyWCbuDOnjpQkA==
X-IronPort-AV: E=Sophos;i="6.07,199,1708358400"; 
   d="scan'208";a="13375291"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2024 03:00:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyjAeJndAlgp3cK3laAEsW2E29spqNwDNzTObe8moOWVG9qNK/QZm/4EHyqiBh03TFvv5RmFSAo3fZ/LYeQZom8bmEC/bG2bk1tzZ2iZ37Z3A798RqS/7kGXAHU7cICIsFyj+ly2dCFLRdaeajm7y8rchUROoEyLbWwMGcw2tonwUwcwXY/ysJ/7yP/OLIZWwySQpG2VUSWml180av0FWL0Hdy3Jw/lRqBQuo5+O6ZIAie+zJDKrjdYopUZQPqH2CSLRSiH6w3Q2e97cMBO8GUmsID/JoDKaygMlzBrewzkS3+jPdzc9+rgLoMvaFeoWsG0Gq2V/nwf4pL/A2AOZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zp0tQ8zIiJEnD/hosiRDBJKiesVwfNGnsC9bxaKsrgo=;
 b=T19JwwCWBcEHtS6mUdGlNLrcWGpE2tu/tq5VdO8LEhbQm/9vAmJBrZBMtkqbhnh9zqDKeTYxVZtWE/r3R/+KhOhE5+60sneXdtfKgcco2m2xdBuIswHChw6NbVE5EAj6rNpoEK9t2sM+COTdYnqLv1mMNKpm+0yJ/b0OmsWzI3979GPw/VcwIx4yz4m+3K204aRHOK9r1OfQYdBu6pX17PicaT8f0aLGge7Z3QYDNNIJcSygyLV+hmTQZdD/cryfQNfYrO5B0NKWdOAfVkdUkzdglBp9gOzle006ofOOHzJgJrRgxrm/87+jPIx886Yl4iZN9UykJMyg1oVleOM32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zp0tQ8zIiJEnD/hosiRDBJKiesVwfNGnsC9bxaKsrgo=;
 b=BySu+4ZnA4kq7hALFDWRlm73BnKyrDszTL+Y8XBDc64ajxIG0dlwkUCNuKlirW/INi1PqsVPktzS7s7LU+eSV/A2RjCjnA+KrSDdwrvkDNNmMUICfUkVV3Ng0gSmw6J3ncDUn4pOD3vvIKWWzN47enZjG8wv9/PG9nRv6deiZmM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 IA0PR04MB8805.namprd04.prod.outlook.com (2603:10b6:208:484::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Sat, 13 Apr
 2024 19:00:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7409.053; Sat, 13 Apr 2024
 19:00:33 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, Peter Wang <peter.wang@mediatek.com>, Bjorn
 Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Stanley Jhu
	<chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Po-Wen Kao <powen.kao@mediatek.com>, ChanWoo Lee
	<cw9316.lee@samsung.com>, Yang Li <yang.lee@linux.alibaba.com>, Keoseong Park
	<keosung.park@samsung.com>, zhanghui <zhanghui31@xiaomi.com>, Bean Huo
	<beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>, Akinobu
 Mita <akinobu.mita@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Remove .get_hba_mac()
Thread-Topic: [PATCH] scsi: ufs: Remove .get_hba_mac()
Thread-Index: AQHajQDPRxAWKkGN4UqXCGFpQHxBSLFmFdawgAAqe4CAAEjFkA==
Date: Sat, 13 Apr 2024 19:00:33 +0000
Message-ID:
 <DM6PR04MB65756DF9F19CA664768333E9FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
 <DM6PR04MB657567B296717C428115D487FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <cc6ee1c4-8ce3-4016-a085-6bae84754690@acm.org>
In-Reply-To: <cc6ee1c4-8ce3-4016-a085-6bae84754690@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|IA0PR04MB8805:EE_
x-ms-office365-filtering-correlation-id: 04a1bd09-1c01-4407-0df5-08dc5bebff48
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +QNsxTG3h1wSzyd8kb1X6TS79mW68zCQUvjpPc9cLYl9nOkoqHJu7sabPJtzMdZYq+b+fRjjEsmI6mCQhoeVTttNuhoEZ38Yn2Ioe9VOaYMheLriBV3U0z1CuGzAVa1QoMd1IllhCgg/Se/cWXeZeEIAAZHQFZObiBGACd/RShFKuzHSQwanp1ZOSc4HR/UusRLIvq5CgjBW9gphTcNHpyc2ffQ1gOECyiX6opsx6Y38L4JoCIex7RnNOnMefcuv02RpzXER6TwuBdbxuTtyM+sbF4o+E1wwdnPIpqCwcZ4XpEtxJ/FcOaM3FEbb375dxD7F28EGohJEUVsVjxu1YSfGqlYpxMSOF8gb36M+ALTwMg3q8IvPBS+dIbrNkh+P2EGIBSi+/A4g47JJ5NWNRGLlIbU0dOJyB+JgLDo10tTo0lTZ4k+k9dCECuNYlBpQ2qeJp4aWH/UGfb/I7+MSRcSdZr1M0f6UWFde8Qxs7R1z14/l5IX1DXruv/UHBJ7IllpTIy95ih0/wYpbNJ+Kze7KiKp7/lQEbh5mBhYY5eFwcngK/AXQDV7lP9lkSoVF0Kh8k2q9MK7A531vuFOJoXZxcwUEHK8N9l9BTqOpwE5qSylPFEnredQck5+MMSed5rrl9svztMc89C00wH5MgrHZFbh3tlV8vGXOJOZkxGdA378bLvIfZ5w1n3romwCkqhYhoj/biii5IWQ0zOaBevYEK+0ac4oUsAdpWCoLOwE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WFM1YmEvREZDSGQ4Y00xeUdGWHFEWEpFL2xvbVlEQ3hwV0JjSHN5UkFGNHZT?=
 =?utf-8?B?aWZQTTVTaE9tYnZ4OUNMSWFJM2srVnZ6Yk5tSURnY3ZsYTIwVUU2eTZYNkor?=
 =?utf-8?B?UmsxQWV2dFdmdVIwZ284U2kvanhrZGcrd3JYVDlTdWVJUE1Ybk14bzVhQnJ0?=
 =?utf-8?B?YllYN0M2ZFdEdlJqeUJNR3ZDaXdidE9ITlhpanNVTjNXYW4xdjdJQmdCY2pR?=
 =?utf-8?B?d2hTUWJ2aGtwbG1GQWVoS0wzN0tTUXNSejBQenVkZ3B0MXV2NHVUQ0V5Z01C?=
 =?utf-8?B?UGZtaDMveTdmMFl4T1VLV09pdlBaaDExNTNTUDFheUhJaXBmUFFKb3JCYW5J?=
 =?utf-8?B?cWZiM1NDcjdpaWkwc3ByK2pLaWxTdktwcVdnZzdXSDRFUktZS1g2a2NzWW9a?=
 =?utf-8?B?SGEzVENLbytVbmNFM2x2OHJBMCtycUZnekZ3TkZUWnZWdEpGcDIrUnFuWGZN?=
 =?utf-8?B?Q1FRME4veC9uVlZHT1ducW5HWWswY2dHZUZzNmRRK0RMVVQ3QThSWUE1YjJw?=
 =?utf-8?B?VVlvYlFYYkYwRWNRVHdxVzZkQzJ4cFRDTFM0WTVSVHZtUXRFd3RqdjNxbTBX?=
 =?utf-8?B?aUxnMlZhc09FQTE0cTZHWXFiMVZBSjRwQ043cEIwNGZvNGFCM3JTUkhCL2du?=
 =?utf-8?B?MjVYNkR1elp6Ym9rTUJIWWdzSGtmVmlJd25rdXpiTU9laDkxSTlITVd3SVU5?=
 =?utf-8?B?Tld4aHBDME9wY0lrVnE4NXJGbzhkaXg5eXpWa3dRaFJicExNOE5HK0dpSEE2?=
 =?utf-8?B?dG5DWkNhUTBYcUU1ZFNGaVdSemtRSVpBVmh0TmpZOTlzbXpXV0gvalFqdVRD?=
 =?utf-8?B?UjJIU0l6cjZROE5tUUVjYXVoT3Q3Tk0zMHA2K0UyNkwxdGVLYis2aHZtai9h?=
 =?utf-8?B?WE0rV3FZR24yV29aN1NGWnk2VjZFbFhPeHNNbytlT2pXVUhLYjR3dUF0SmhG?=
 =?utf-8?B?UUNiNWV2dU0rT2FPZHlOMkZYMFJsSXE5cHhuMHRJRlhHenh4NDJNbUVISnRO?=
 =?utf-8?B?aCtET05qaUE0OGpmaGZQa3RlcThEL1FoYllHMjFZNGZwMTdNbkxTQWNZalJz?=
 =?utf-8?B?WHBMVlRPMnA1WVhzdkU2NVpma2RROGNESU9WckhZMUlGZFE0UndvcmoxOXp2?=
 =?utf-8?B?MjNTR3ZpU1RBVTA3NlpON2tKK3gwajVHYkIwSVRGZ29nOHFZOUllQ05nNHhj?=
 =?utf-8?B?Q0Z5U0xWaXM0UFo5RGFGODI5N082R2NyYmc5M09MYk5WL3BtUzFuS2ZQNzF1?=
 =?utf-8?B?WlQ4c0lQbmFhbU9NZlRSRVlSTU82NG9ITitnNGgwY3FuQThLeEtOOEZuYjNL?=
 =?utf-8?B?UTBJWGFNSS8vSGRJYjlJZWY5RnhTUzZJVitkcktOdXFYVS9vZzNWNG83S2dU?=
 =?utf-8?B?S280TThBMk1qWlR4WU1Xa1VFWEpyT1NtNFlUYWxGYldZbkxJakQvcVRkTUlD?=
 =?utf-8?B?Qi9Mb2MzcVJrYWgzaFFCZTlHOXNmLzU3aWZyQTdyWTZrNCt5dnBVZ1JXNW03?=
 =?utf-8?B?Ym9KUk5NZmlEOGZ3U1FITmtUM1UvZlg2dVJhTnVCalBYajZSM2hzY1lMdHJW?=
 =?utf-8?B?eWZmUEV2SWJ3MDZEM2JGK3d3eUFURDFva0c3eEhOdzVwTE9rWEpCVUdIazZ1?=
 =?utf-8?B?YXBCTGdraTFRbkgwWkNYUkkvejQ3cFZ2Nkk5QURHdzM2VU51QWk4dnhMSkpz?=
 =?utf-8?B?eWRaekU2UGFtQnlONHZhTGtDeHcxMU0yUzNONkpheXp4eVJWcjNvMHExb21M?=
 =?utf-8?B?VU5QUHlXTm8vN2FGVWk2Q0luTCtXZzhmMDdnZFNWbFB6NmcxZGxDTWZyaGFG?=
 =?utf-8?B?WFlhcTloTDJRME5SSWdlQjRJME1oeTZlcGxQVkphZ3ArUVlhSSsrd2FKL3hN?=
 =?utf-8?B?V21rckdxalJCMlducnZXMWQ1VCtmd3ZhbFRoVGNiczI0MVVJcXM2WE8wdFZm?=
 =?utf-8?B?NGxjVWR3ak4yNDhnMHJNNzc5TzJqK3B4Z0JkdW45QXQ3WkNraTBJajgxdkVs?=
 =?utf-8?B?YnFwa0V2YWpHSlNyRWhuZEQ3OE9XbmZnTXhFQnI2M1IwYUM1UGNDdk5Sb29i?=
 =?utf-8?B?bWFRekhZeHhYSEpmci92Yk5oVS83ZnpNb1ZmSktWUFY3WUx2c2dzOUgrMTlF?=
 =?utf-8?Q?yX91XycrcVz08+XoOuEIcLe6u?=
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
	f87MANnLqkdRSdNomzO+hK+WIQy1BndhdgSseZ3Pa8Qm0OeC3hMWL/5O2ya3jz6Qz1m/qzREkpL/VMD1wSTlkMA3IQcc3XyXwdwjuqjfXuSvtJsBmFlMI3rzSJIxrBYPsJBTFJydI4BK6MxfgV9FKPewKZj2DYsdmYJxUXSGMLSDCVTYYNlRB0+ryJ2jPAo3eBs198TGLZYIyIs/rzGtjda1G2bUX47yeL7Se7Qx49VTPPeVp7YE2U1Z91vsm5Lkx7egR45rmtW2+ckgGe/QS3SR74t788tfjnHr5UpvjrLoPYdtEFrSvQ2TVHji/SFW6/9p0Z7zonAUemnOQqfTEbJyVmObwTPvLxKjyct4itNmtfjQ65aK8n3upnThF742KEBVuefEFJbAp8T5MJc4At26lhpPN8L0/tGoqATh5EvkUEQj2Ug8Hl7TlweMFyW+JWIU+j5u2Ain+UV2e7QbXeRgVydl1aq2ShflhPcLpwH1+KpvtCs8HGhHPVWNhASeC/Td5gjUrJo07WuzXJk8Fwn32Vg41edubtfMUviWDEfVt1aEgRjDYYZoCFahaujN1DIKIeLmEqZExN0jq2loP/90y1r9NK0E9rAxtUd/+lydHXVe3gbZU0mY/XeiLVVz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a1bd09-1c01-4407-0df5-08dc5bebff48
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2024 19:00:33.7737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k2vPqeD5OsnArkWstyfR2IAsoW/ubWjMdOCNj9nJUdWyhzGHvuCPLFDuqHqlu3IDnT5OmdHU/JCGumsMBzYiMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR04MB8805

PiBPbiA0LzEzLzI0IDA0OjQ4LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gKyAgICAgICBudXRy
cyA9IChoYmEtPmNhcGFiaWxpdGllcyAmIE1BU0tfVFJBTlNGRVJfUkVRVUVTVFNfU0xPVFMpICsg
MTsNCj4gPiBJc24ndCB0aGlzIGFscmVhZHkgaGJhLT5udXRycz8NCj4gDQo+IEVuYWJsaW5nIE1D
USBjYXVzZXMgdGhlIHZhbHVlIG9mIE5VVFJTIHRvIGNoYW5nZS4NCkJ1dCBub3QgYnkgdGhlIHRp
bWUgdWZzaGNkX21jcV9kZWNpZGVfcXVldWVfZGVwdGggaXMgY2FsbGVkLg0KdWZzaGNkX21jcV9k
ZWNpZGVfcXVldWVfZGVwdGggaXMgd2hlcmUgaGJhLT5udXRycyBtYXkgY2hhbmdlLg0KDQo+IA0K
PiA+PiArICAgICAgIFdBUk5fT05DRShudXRycyA8IDMyLCAibnV0cnM6ICVkIDwgMzJcbiIsIG51
dHJzKTsNCj4gPiByZWR1bmRhbnQNCj4gDQo+IFdoeSBpcyB0aGlzIGNvbnNpZGVyZWQgcmVkdW5k
YW50Pw0KSSBzZWUgbm8gcG9pbnQgY2hlY2tpbmcgdGhlIGh3Lg0KQm90aCBJbiBsZWdhY3kgJiBN
Q1EgaXQgaXMgYWxsb3dlZCB0byBiZSA8IDMyIC0gd2h5IHRoZSBXQVJOPw0KDQpUaGFua3MsDQpB
dnJpDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQo=
