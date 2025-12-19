Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B883323535E
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 07:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766129593; cv=fail; b=jWnAKEdZaCi23kVDj2+wTOK0a3H8JExTAB+k9wRi+Ko+VQvgXqnPYFelhrnbhbw4D3xXysBSc+Pu/Vaor3HKZMzn2LbP59CbId4sYx/ktBsUS/u6YeyTPXWeXT04OEr0JsKDIASMtkpXziVXf0jdaD5ighWLFKAlBsSyAeykC14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766129593; c=relaxed/simple;
	bh=NanfpsUFkbMJP6pQwiRjokWSdjXn1ufb2t0rsD000rY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BEAOwEzYfkBQJxcsPXdesGVKvv9sk1O3kuMuv441qxx6cpxEmtRI+p9UsvEblRx757uUefntbf5tzYDGDWAVAvch5C30RGSvfI0RUpToxYPU98xAgoMPv9baih6+267Myx7QzNpigKIZ1whOPSGW0XI3NbN4KN5hmg9YV7fZMnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gBSKUcx/; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Cq6q0Uxs; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gBSKUcx/";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Cq6q0Uxs"
X-UUID: efc7136edcac11f0b33aeb1e7f16c2b6-20251219
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NanfpsUFkbMJP6pQwiRjokWSdjXn1ufb2t0rsD000rY=;
	b=gBSKUcx/S3PhsSNcQjh70MHlxBlc0PJyfbvN0kfkrI7yiYGo9tva0HN7h7L3+PxorE3CoHizjerY1hEPPel9ybhW3DYG/hkA2QpCbxkiyxW8CCiErLbRXUw3PWEFKr9WtJknTaa4ut14DVmywHZ4vxlDGHQCizPmT4zhTmWipjE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:0c1b3f9b-ab7c-4965-990f-f8f7aabca887,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:cd00f302-1fa9-44eb-b231-4afc61466396,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: efc7136edcac11f0b33aeb1e7f16c2b6-20251219
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 112479836; Fri, 19 Dec 2025 15:32:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 15:32:55 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 15:32:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=quIkBbIKAxQyZQV4ffPqb4PO6cWNwPz4H8LPwpTW0sW+R2BpXJHc6iZ0xMLVcmxNQFqcXkT+IXnG+bimglbz2I+KskP5aYuhKrPNwWCE2V6Hk8cLfkbU5uf4xo7wvzjFbdidRYhkhExWlh/zYmtQ74/N41Oiz3k4VTtp2JnWksGhvp2xfX9FRw3Ir5Lf3mKFfOMDvkwE8JAUI6g+UPjovZ45y+8J42cHoGcKE8nysuF2L8SFPKiBtZhQVqMyuCza1pivHYUOsuplBHhUhh4kE7O1nSgj4M19yjhQ0yju8hjLih5IDmWrPHV4mKYxnCaO+sU1ZwGnlyD/ST2hb4iMSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NanfpsUFkbMJP6pQwiRjokWSdjXn1ufb2t0rsD000rY=;
 b=pN3R/c0XzhTDoc8gpX3wm5Fnjr0hBMEX03PvBndASie1WFDubvA7e7FMyRN7TVAQu6vdsCtmtbCgnWx+oSSm7JSjKLeHwhVD8maBjpoqgzmXaJp0Va9cdoyCqAzAGHQo8NyTbHwIw3z7wJN9VDunrjBz9QdnH1or4bj8UQ6tJ0ExmTNXRll4zZ2pbk8vmIHO+jWpdWuVQsb8/m/owNTnkEwZCnrgPkFcy7wDg4nWfnF/Pf//QC7tbFkc1bCgnYqALGc6jgPn+1bAhYHUbaYyZDrearxLddct5EExRA/4JS6dNPU+rP9y/ju+sAQBKrvZKUCcJhBTYsQawuWHQpSFYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NanfpsUFkbMJP6pQwiRjokWSdjXn1ufb2t0rsD000rY=;
 b=Cq6q0Uxs7fWr4KkUK6tLOZty+vPu6574L91PQuRfbUtEiwmifOVeWEvxGbtrN3XZ0Jts/7AlC1vSyCi8+MLK1BcdOOuBAhfjzDmUzcJXZuonrkmqmhq5ykum6QHUZ00qN1xVr0Zk/jCVj8kFhJeeaNBJCrtEd//ndoG/d6Niv3k=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6813.apcprd03.prod.outlook.com (2603:1096:101:68::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Fri, 19 Dec
 2025 07:32:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 07:32:52 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "nitin.rawat@oss.qualcomm.com"
	<nitin.rawat@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH for rc] ufs: core: Configure MCQ after link startup
Thread-Topic: [PATCH for rc] ufs: core: Configure MCQ after link startup
Thread-Index: AQHccHM2kXmeV1GmHkyH4oME7gZbu7UoknaA
Date: Fri, 19 Dec 2025 07:32:52 +0000
Message-ID: <877f7704215c36bfb15808e3a168767845ce09c4.camel@mediatek.com>
References: <20251218230741.2661049-1-bvanassche@acm.org>
In-Reply-To: <20251218230741.2661049-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6813:EE_
x-ms-office365-filtering-correlation-id: ecad634f-94a8-49f5-5514-08de3ed0d19f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WEpQM0ZoQ2ZnSjBDeFlaQ01wb08yVkQ4aDVvV1NwRDdRWENpdDQxT29ORlha?=
 =?utf-8?B?NjQ5MkMwbWlFQVh5bFZ2WWNsMGhTQUR5ME9GYWJMVmtWblVNczduTjZDTUZx?=
 =?utf-8?B?SE1oaU1tUGE1VG84bjhKYnJoYzVNeEgvMEJ0Ty9PQWoyNklSMlpkSW51RXd5?=
 =?utf-8?B?bjc4bVdMZHRQb0puVHBJK1Ftbk1BeWRKM2tYZkVlNVhDdHJtd0h0NExVZjZT?=
 =?utf-8?B?UEpPWTJXSVlBays4TCtyWWdaOGV2VnNHVEI0WEIrVG0zcWVsZmlMaktWTjNk?=
 =?utf-8?B?VHduSkNWOURWWnBTRDFhK1d1dzJLOEFqY3F1U3pEQ3BqWXRxb3lkWmw5VXI5?=
 =?utf-8?B?YTYwOWdDRXhveUpSYlVlUjg0R3FwWjNHS0pYNzU2WU5yaDMwWEVpL3RoNjdW?=
 =?utf-8?B?c0pVZTRZL2ZXaFVxbjJmYkVpMHFMVVNZM2VEMVlCWFl2TjA2dkJNRDdxRVFB?=
 =?utf-8?B?NEwyWE50ZWc4OEpjQ0JrR2MwV2ZRNWFyc3VTdzZqWUllcllNSHJnZUdsc3VV?=
 =?utf-8?B?ZWNNbU42c1d6TTl0ZnFYYmVlRWsyeWdOUWEycmw2RjVUS0hNYUVTY2hQQVk4?=
 =?utf-8?B?S1B2Q0FnV1dFaTlYSjl4L0pBeitpNmYrVUZqOTZwQ21HSnUxRyszUnlMUldX?=
 =?utf-8?B?VXZKam9uRHFPOHdScnB6NEJtaERMc1JrVDNxUWkxQVV0dmowaG93ODFpYlB3?=
 =?utf-8?B?UXRpSk9XUm50QlBRalBCeGxkUHk1UTBUOWIySjArY2NTaTdZQ0I0aHJ2dHUr?=
 =?utf-8?B?aXg2RVFvUVl5eHZpTGVFVVQ2ZE1pSFpUdmtuN21aZngxbTNNVS8rSHdjZjQw?=
 =?utf-8?B?cnh1QTZiSkxTTTBNTVd4VlZuOEVISWJ3cjkxV3c4aUJhVS8vT201MkZvMUVX?=
 =?utf-8?B?M0VZUndpSnpEemFNTHlXYTAzN21BWnNsWktqUU1TNDdyVzYvTkZpRzRuRWp4?=
 =?utf-8?B?bGxKL3Vhd3JEUU9PNVArV1FSNHY1dWxpRWQ4a1l1ZzZWaFNEMnNBSC9oalBj?=
 =?utf-8?B?eC81UHRmbnFpNDQrU3FWZGtsVlhmaXRISlU3VWhSL2loZUZFWU1KOExaWjNx?=
 =?utf-8?B?WmJSWmE0bmRqUkRmVVRpV2I3SGNtNmo1MHZYK1RKcVZldVhsdGZVcFU3UkNn?=
 =?utf-8?B?NFM0bm50MitvRm4xcGlXWVY4MzFVVTd2cDN1MUJnVXVSN093aGxFVmlKRy9M?=
 =?utf-8?B?TWJkeFZrVHlNTDlYWWRmRHJhMUZhRk1YaWFITDZwOHI0U0IzUVpQd1A2Z1RO?=
 =?utf-8?B?b0ZlS3Nsdy9ra0VsYXQ0d1RpYUgxUCs1Q1UrelF1R2htM1VoNmFVb2I5NnhH?=
 =?utf-8?B?UnBNSmkycmU5NkRIQzBnMzZuL0Yvd1VyaEZPSklFMU4vd1BLUFBld0lybE1k?=
 =?utf-8?B?Q1JST0hYSjEvUDhPN1hpMUFscFVRRXNYaFFVT3d0cXI3VXBrVVFCSlBnZzFG?=
 =?utf-8?B?bUk5bDdEL3lXZ0xXU0g3Qk5ybUFNMWIzREdQRkZzRysvZVNkYTdQb0RrY0dB?=
 =?utf-8?B?b1UyaHRVdnlDNHV2dFJwdk1UT1JBUU1yWnZCaUFuQ2FDWDZVV2IvZ0Z6ZEZX?=
 =?utf-8?B?VU9pOThVODN3L0Vtdm1oUE9mZTJWVGZFZ3EzbitJZ0c3WUZGSnVmUUZWcVlQ?=
 =?utf-8?B?UHpXV01RaXNzZzlmT1owOHozVXhZR3M5M2lxdVA0bjVGUlQwUHZObngxekVM?=
 =?utf-8?B?WnorMGZJYlRIWklibGxwL2RjUHMyQXZZa21pd3YwOFpXcEE1K2pJMVlVK3pQ?=
 =?utf-8?B?RzJPNkQzbTMvcHR5cHV4ZHFjbjdaOWRCT2hIS1pWS3pFS2grL0EwTnNSMHl6?=
 =?utf-8?B?UktPUEwwRjJJTkdjWFh3N0tQL0dnL2NpMk4yNXVNU2RwdFF0eG5zNEhGbjky?=
 =?utf-8?B?b255bkJBbm5zZUowdTVxc1NkQm9waXMvSGRBOWtTZFFraHZic3ZpZk1mSjFB?=
 =?utf-8?B?Wm5rZkJ6SGFneHRwcy8xVVovMG5aTStMV2o0MUZORkRqMFN0UGNGTWVLUHR3?=
 =?utf-8?B?TVhhc2ZUN3JOYUh1QzlTQ3I1b3EyQ2dRT3lwc0VGNVprdkFuSHk4cUtJZ3l0?=
 =?utf-8?Q?NwBsy0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjJzSzM3Z0R3SytsbGdTM0s4Y29tMkkxcHF1ZDh5RG90SU9DT3YxODc5bjIy?=
 =?utf-8?B?alI3VlB0c0pXMEtJOFMyV1NNemEwdTlnQ2pOaUUzaFVJb1E3MzhRWUpmT2s2?=
 =?utf-8?B?S0FnMWpEZWxWcWhkNlEzL3hoL2IzRDN1YysyTWRZa1VFSVFydFFpWi80RjVt?=
 =?utf-8?B?WFpKNzhkaFo5QVkrUTBaRkdHc1JlaVRVL09SUStFYmFMVE9RdW9zSDdZOENj?=
 =?utf-8?B?ZEkxbUdFQllVN3dQdU1meFBsNUI2OVlOMHRuT3o4UW9QZzNHeHFJVTl5dDVB?=
 =?utf-8?B?cEpPcFhLL2p6SVRhMlowcVdjSUEyeVFJVS9nYVVIcExKekRDQWloVU5xTWxW?=
 =?utf-8?B?YkJqcWFZVkdwMnF2bFlyZnc1d3lyK1hpTHZPMFEvdDBWdVl4c2NITXdZZE45?=
 =?utf-8?B?bXJ4cGpLczRIRTYxc3ZtK2c1UDlPbXZ1azRoRlc3ZXpiaTVTaElZTktHUWYx?=
 =?utf-8?B?QkxjZDZzalJoRlpqdXM3ZXVBeWptcDJTa3NHRXN0cVNQUUF0MFBsVzZUaHlO?=
 =?utf-8?B?cXBYSmx0ZjZOUFBPdk5BODZ6SkVETUpBTURMVlhlVGozelhmTHBwb1JKZFV0?=
 =?utf-8?B?dldKQmpyR3lDaU1qSVJRTXB5STlrMVY0ZDU4Wks2SUVDZ3E1dUV3bUdoSjRL?=
 =?utf-8?B?MWJpd25JOHp3dmxJU0R2d2lpVFBGQjlXWHFrRUgxNmsycWpqVTRlMXFZQ1BM?=
 =?utf-8?B?S2s2bGYzZW9HNEVBRVh4UjFscVZuN0NCYzREOTNKTVpLZVViTUl1dW5rR0xK?=
 =?utf-8?B?VVJSQnBPajB5M2pzR0k2aWtDNzIrMXlPamkzTHJGQ24wdERkUklQUkJFY0xr?=
 =?utf-8?B?UjdzTHJ3L0VwbjBWcTIvN0xSaTBDQ0R0TTVnUitmM1RpSzl1bHpncEx5U0Mz?=
 =?utf-8?B?WVF4TVc3Unl1eFZQUjArRWtXOGMwenhlbG1xUjk0bG5wYkp2dEQ1ZndXV0da?=
 =?utf-8?B?elZkbXBXRlhleXRMWWR1NFBrWlRoT0Q4aytWYms5UXAwWnVFK1M4a2FsUkRh?=
 =?utf-8?B?ZUF1ei9QNElBVkZ4aFRPS2lhYytmR1pjK0VJNldBcklERHJSb1RNVVlOdldS?=
 =?utf-8?B?TWVqa2k1VUhRNzM2djRiZEYxejF5azZxc3Y4MU5HbmliQ25hMURiSFFSWUFa?=
 =?utf-8?B?N1hKNTQvQWlmZnNiSFdNUGYzOEhkLzZjWXV5SVMrYVZ4aGpJT0taZHpaK2h6?=
 =?utf-8?B?WXBOdDNRQ3NQZHlEM2IwM25WMExsTEY2ajNRaDVFbyszSC9qUHMvUkhyWlhL?=
 =?utf-8?B?a29RdmNEaFJHeW54TUdoQ1hIT0pOUXA4KzhyK1hZdGJqa3lmaTZxSE9sRzRn?=
 =?utf-8?B?VVVqM3g2S3Q1TFlEUkQ1SGV1ZUt3bnVPeElyblJxdk02Ump5VGYydDkvSWpz?=
 =?utf-8?B?QWQreFA5aEpPeFM5d2lSNnU4aFdPelJuaHFKWHo1bUtUWXIvTFZVaFU0OFA2?=
 =?utf-8?B?UFRGWVlCVGllcEczalI5SVJWdW41Z1RXekw4VVFGSngwc1RZdFc1VkRiUkE3?=
 =?utf-8?B?dnYrYnRSWGZLLzFKcWkxVjdYRGNjY3RaV2IzejZ6Wlg2cXUzNFBObHpORHBr?=
 =?utf-8?B?djN5WWszNStIL0xsY24waE92TElwUWx1bTcvUWE0NTRDbll5cS94MExCaEYv?=
 =?utf-8?B?d1dxZHVFOGRuS3p6dFpPMTZNT2V3RWZJSitYL3U2WERYZS9VK0RRV2dnMHdL?=
 =?utf-8?B?Uk1BV1YvWTRIWXhkWTczdHJaSHNJRDdZeVFUa2VQZUd1WVRoQjd1LzdYU2Vm?=
 =?utf-8?B?Y010SFR2S01NZzBiQ0ZoY1BSUDdTMG5McjdxS3RQdXZKaUZHd3FqNFd6RVNI?=
 =?utf-8?B?bDhtNk5SRzB4WXZDVEhvZ0ZXeVVhNW9PMk9wSjVzYkNtcTFJQTFrdkRpeGlM?=
 =?utf-8?B?b3RQckRhSEJWLzNXcW1FYUlPLzVncEcwM1dZQWoyMUkxdlVtR01WVXZheWph?=
 =?utf-8?B?UGp3MEwrcmlEZUlpbXA4K0xUY2NVanpJanBqazdaaVc4RkJNZlZ0Tk9YTWk1?=
 =?utf-8?B?aC9IWmM2OTZvUGhnS0VXdGxwOWx6K2tIMUZpdFZ2c0x6UjMzRTV3YmMzNXFH?=
 =?utf-8?B?dU54b1lKMTcyeXBJeHZEU1pxRVRnWkxWNUZ6OXlpRXB0UkgxWlA4VnhlYXNp?=
 =?utf-8?B?TDAzWnZ3VUljUElZT1JKeGpRbjhBWkxjbUI3Zm5Uc2lpekxXMUJpZEI4dmxJ?=
 =?utf-8?B?TzdSSFN0dHFGNTVvd3Avdm82OHpIVko1NGFTdmFIZGZlSWJoU2VnQmRrVWc4?=
 =?utf-8?B?T01KZVh1NzlzSEZCUHZuRi84d2RyK0Ewdzg2TFVDT1p3Z1NaRVV1b2pRY2x1?=
 =?utf-8?B?RWQyV2NPSXlYUzRucVJHMlV3SHhSYmVPVG94K0dKOERMUHZNeGowaXpSV3Rq?=
 =?utf-8?Q?ZlT9iD2PFfPSCWFw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <670C62A6EC392948A2C9357396E504A4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecad634f-94a8-49f5-5514-08de3ed0d19f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 07:32:52.3822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OQxsHPLiSkhhv2cNtyXibwCGBEBa/Fd/uKQmErPVx9/KrENxpNv1vRm7TuoYDL0r4qK+mvBcJTH9E5ZP4S6Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6813

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDE1OjA3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IENvbW1pdCBmNDZiOWE1OTVmYTkgKCJzY3NpOiB1ZnM6IGNvcmU6IEFsbG9jYXRlIHRoZSBT
Q1NJIGhvc3QNCj4gZWFybGllciIpDQo+IGRpZCBub3Qgb25seSBjYXVzZSBzY3NpX2FkZF9ob3N0
KCkgdG8gYmUgY2FsbGVkIGVhcmxpZXIuIEl0IGFsc28NCj4gc3dhcHBlZA0KPiB0aGUgb3JkZXIg
b2YgbGluayBzdGFydHVwIGFuZCBlbmFibGluZyBhbmQgY29uZmlndXJpbmcgTUNRIG1vZGUuDQo+
IEJlZm9yZQ0KPiB0aGF0IGNvbW1pdCwgdGhlIGNhbGwgY2hhaW5zIGZvciBsaW5rIHN0YXJ0dXAg
YW5kIGVuYWJsaW5nIE1DUSB3ZXJlDQo+IGFzDQo+IGZvbGxvd3M6DQo+IA0KPiB1ZnNoY2RfaW5p
dCgpDQo+IMKgIHVmc2hjZF9saW5rX3N0YXJ0dXAoKQ0KPiDCoCB1ZnNoY2RfYWRkX3Njc2lfaG9z
dCgpDQo+IMKgwqDCoCB1ZnNoY2RfbWNxX2VuYWJsZSgpDQo+IA0KPiBBcHBhcmVudGx5IHRoaXMg
Y2hhbmdlIGNhdXNlcyBsaW5rIHN0YXJ0dXAgdG8gZmFpbC4gRml4IHRoaXMgYnkNCj4gY29uZmln
dXJpbmcNCj4gTUNRIGFmdGVyIGxpbmsgc3RhcnR1cCBoYXMgY29tcGxldGVkLg0KPiANCj4gUmVw
b3J0ZWQtYnk6IE5pdGluIFJhd2F0IDxuaXRpbi5yYXdhdEBvc3MucXVhbGNvbW0uY29tPg0KPiBG
aXhlczogZjQ2YjlhNTk1ZmE5ICgic2NzaTogdWZzOiBjb3JlOiBBbGxvY2F0ZSB0aGUgU0NTSSBo
b3N0DQo+IGVhcmxpZXIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4NCg0KSGkgQmFydCwNCg0KSXQgc2VlbXMgc3RyYW5nZSB0byBtZSB0aGF0
IHVmc2hjZF9tY3FfZW5hYmxlIGlzIGNhbGxlZCBiZWZvcmUNCnVmc2hjZF9saW5rX3N0YXJ0dXAu
DQoNCkluIGRyaXZlciBkZXZlbG9wbWVudCwgY29uZmlndXJhdGlvbiAoY29uZmlnKSBzaG91bGQg
Z2VuZXJhbGx5DQpiZSBkb25lIGJlZm9yZSBlbmFibGluZyAoZW5hYmxlKSB0aGUgaGFyZHdhcmUu
DQpSZWFzb246DQpDb25maWd1cmluZyBmaXJzdCBlbnN1cmVzIHRoZSBoYXJkd2FyZSBvcGVyYXRl
cyBjb3JyZWN0bHkgYW5kDQphdm9pZHMgdW5leHBlY3RlZCBiZWhhdmlvciBvciBzYWZldHkgaXNz
dWVzLg0KDQpUeXBpY2FsIHN0ZXBzOg0KMS4gU2V0IHJlZ2lzdGVycy9wYXJhbWV0ZXJzDQoyLiBJ
bml0aWFsaXplIHJlc291cmNlcw0KMy4gQ29uZmlndXJlIGludGVycnVwdHMvRE1BDQo0LiBFbmFi
bGUgdGhlIGhhcmR3YXJlDQoNClNvLCBkbyB5b3UgYWxzbyBjb25zaWRlciBtb3ZpbmcgdWZzaGNk
X21jcV9lbmFibGUgYWZ0ZXIgDQp1ZnNoY2RfY29uZmlnX21jcT8NCg0KVGhhbmtzLg0KUGV0ZXIN
Cg==
