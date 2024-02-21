Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7172F36
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2024 02:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708483510; cv=fail; b=VGn3MjfVWpX2RhnYenD5UDG49hYC5TC3Ge7wUcQdtKSwCEEGoa3VD36pwDSyPTEqphIgJWO/tu6YKsk6aULn9HVt4S1IDcnOGuRt5bKzcdylxAX1C+uvOXY0DejKD3iX4I+e4Ya+qi3FfS3FickI9HGDLCCRJTstP7A/zFg9W2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708483510; c=relaxed/simple;
	bh=ZrQCZU8Y2M3P0UCYOLxDk8NqeYPFLn8O5Ibcx853OGQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XkZAmC2XXc/cq7pgkSMqne7O5Ct8DJjYVib2Szficisq00h105uxtiLx54XNRltLx56w0IIfGgeUBk2DrZtsbSo8e01zmhOQz9GfU6ZWmLc4YQmm4kjqaDCNgibhN9HiuSKpGOgCx9F2UfGTq0rlBtjXyEHVat//nhSsUU4JBKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pi88fkqv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qJSqMyoX; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pi88fkqv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qJSqMyoX"
X-UUID: 3591dc60d06311ee9e680517dc993faa-20240221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZrQCZU8Y2M3P0UCYOLxDk8NqeYPFLn8O5Ibcx853OGQ=;
	b=pi88fkqvC3+USFOvr2YATem/aigQ0leQdY57TC10Jx/prh6LothRUqqUR9lc6XPYkFkXhabc4fm4yfeFlhDzocU9tlQMogfxD+UT8hwuXnK+3qySLqGxNylPBGNZteOBeYAzMResF5I4RkOgJwx8gUXmo+xahJL47am3vli3t8g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:2c30b009-4ac8-4502-8683-3b71a622768c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:8d1c878f-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 3591dc60d06311ee9e680517dc993faa-20240221
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 899942005; Wed, 21 Feb 2024 10:45:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 21 Feb 2024 10:44:59 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 21 Feb 2024 10:44:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQGZPQGWguqhfhK2u4aN/HwE8ITKVD2hvoInSPBJiFFNFoUmsknN+x+iwBbLLFllRQMBc4Vusuw7Vwf9q1cgpEh3woCeC2c1itNV+ycn7uDlVHnsgEcMiHi3dv6/F+VIyg18/PpyEYas6Cbho3ICd//juiAPT5RBTEyqm7Iq7e03iPAqVq1Ic67opY3MK5UC4X+MKDtkn/VryhgTt5X9GDKWJB8LjN3a2rd2tEwOENWBZdamhaxWPth00sk0lz5sWiKX+etZwR1MydzvZq/gPWg4H9kXOsDDlxy2nDt9hoK6A9XURqSbvdmjg8YQMKhn4tFeJdV3SQUGtAT0zZSO+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrQCZU8Y2M3P0UCYOLxDk8NqeYPFLn8O5Ibcx853OGQ=;
 b=buWV8I/wouBgJHSKWIrByPTMLv8SwBB/kX4gIrDv3kaoXqJXhBA4gJ90DEHP/XnU9CfGsDZ3BTExM4AbZrUi8Zs1SCWC0VhrE+rEApfhRJzgdeTu1+tfN7tpfGLcmazMfeowwxPW1D6FIPPbfI1ALiZuU5iLzJcjjEwI1y/mOvtb0Rxvtb4U6Pu4WiT+sjMiXNxCK6GZYKiARdpuHJ5pzDJ0e43MUHwRiLnDNEg0yHu810EnPTyNHiKR+vdRU/SNK5+VA4fg961TtN+4+8pf+bPb4Rg/Kh2IcCoSAlnSg/aI2d0sRI6Wy/sQ0wlhQiX2D/5FJ9c4guK02YD2OLqnJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrQCZU8Y2M3P0UCYOLxDk8NqeYPFLn8O5Ibcx853OGQ=;
 b=qJSqMyoXMSVrrQPNzsV22CvBE28PzZ3Y81gay/yZCgrWZs3yyx+0BkvVFwjtdd6/w6QYgF1eSzdJxWZ2K2PkT1WMcmZriHYPVsl4bZnakwr2ysBaq4yz23hgVgBoHFdDJnnXXtT9NLttxjGyNVxO20tF76wNPV3meND2X3J6oW4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7512.apcprd03.prod.outlook.com (2603:1096:990:d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.37; Wed, 21 Feb
 2024 02:44:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::b3e8:3d9c:baa1:fe29]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::b3e8:3d9c:baa1:fe29%5]) with mapi id 15.20.7316.018; Wed, 21 Feb 2024
 02:44:56 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Thread-Topic: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Thread-Index: AQHaY+EWoz2iUYqqe0mCoxGYvuPbLLETeb6AgACeZoA=
Date: Wed, 21 Feb 2024 02:44:56 +0000
Message-ID: <0874377d564ceb63efd62df3757c6e5f3a0dd03c.camel@mediatek.com>
References: <20240220094211.20678-1-peter.wang@mediatek.com>
	 <46d0c5b7-7158-405d-ba38-cece4030e2bd@acm.org>
In-Reply-To: <46d0c5b7-7158-405d-ba38-cece4030e2bd@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7512:EE_
x-ms-office365-filtering-correlation-id: f9c367bd-848c-483d-3425-08dc328716eb
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qY2n/x0nQwf/QzUmum6mjtVfdmsbe4EV6XPm85X0FODdzKbWtyuA5qTA8C+gQoUbxanvcXnZTbdIq4UkAmhgUslUpGddR5QxVrydem9KhcGEMwzBx7Y4oUhgavtFKKRxc923dg81AtL2GK7SlGwAzC1qFbyusylp398U9dhbxMMxLwfqntUz/QXXWqZRcW0HtS+h37I9E6ir6Ja54wbJzC30KrZOXw8EK2qg1ITGAgMYJAJ8UWrJEn1RiZszvj5I2kcW43Z9lla9PFPY06vhWDW35weMgaLbOIvSZV9u5SfW1ZtUxsmIdRrfc/BUtiFkVY48zT3VhVqVs69/LsJkIuuTHLJykazXpJCPXWFFhjcWCTfXej3mm1ZVedjg62zRLnAjh3UUTaEATrSozRmPIwaIaYg6IOdq+WkIe388t+nW2zQTLlji8TbOwo12YgoNRxc0ZkGon92XvOBgisEikBwi1enN1l71GR/cLg/RYxtjADAbto89HevbYpnC2lQe0EV/KDIjHp0PtlZh9DyfTOKTq3kv9ZcRf/BPy8eyameDqtJwa3SGiJo7bovVw6zywAtf7pDsr8o3rxOqe5awLhdoB01RHcrMX9Mimmo61tGQXQZYUnN+aO5GrbMaBCT9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGV4K3ZTUDhzZkI4ZHlJV0dKVFF6aGpJazFHMDNodGlsS1dIMjlHNjFRcVdu?=
 =?utf-8?B?UGxiQzRuWjRkRk1ZaW1wYXV2UmhEM1lMYnpraUhiRVNzS3dadHFaV3dpb1dQ?=
 =?utf-8?B?ejA4bFpqQll5YVJTdG90T3hSQUx1bW9GekRQQ1IxZFpHSzlWMFlqMDZqVDlZ?=
 =?utf-8?B?U1JQMVRkM0xSV3B3TzlqUy9JUkNLTkJCcUxWWlQwV21FMWNra3prZ29ib01o?=
 =?utf-8?B?Y1Z2MUtVY1RPYk5oSGhTSmF1YlBwM3JPRmgzWWN5a2piZEhGYU9aNU8xL0tw?=
 =?utf-8?B?bGE5RDRPbVJoOFB1MnJVTFJvdSs3UHhOL0hEV1ZVd2ZkcVIyYjdncGZXb1VE?=
 =?utf-8?B?cHpXY0VmejNmY1VOMjgrNmZ6R2hueGZpSENsQ3A4eDVaYVJiRTZQampPeXdl?=
 =?utf-8?B?OXBRTjVGNzhVWTBXSEgyVFZzWUhXV0YwdFgyL1V4cGxLbUVROXVMcTNOSUNX?=
 =?utf-8?B?ekdHQWpRVEVmNmd3bnBKZFRHM25LZjRsdmNUZmZvN0loM2RlTjdGV3QyWUJQ?=
 =?utf-8?B?UE05Ym5ZSjRaZzUvLzF4NUdQOWkvVWpxeDRxcTIvM1hRVTVnblExUXNDbk5Z?=
 =?utf-8?B?QnUrWVFOamoyMldPeHVXU0F3alVTQUJDbERIeXE1Z3B2SU9yU3VvVGNUM2RO?=
 =?utf-8?B?YUxZVUoyWVhQU1JNdVJTc0V5VGx6YjJqaVUzd1ZnWGh0bVhZdGZtSHY3ZEVk?=
 =?utf-8?B?clUyRjFjS3BESko5ZHJJT3RBVGwveEI2NExKbmFhV3d3b0t5S204aFVWZHZ1?=
 =?utf-8?B?NW1aeHJmcjQvbmRuTXRneXJ4NTZ5VUsreHBrSC9MV3kwSldBZVpCOGJrYldl?=
 =?utf-8?B?bjdzd0hHTGdJbmUxeGV5cVg2dmRkWkgzV3ZiSkVrRFh6MEF0aDhDaDZYRzU3?=
 =?utf-8?B?bkdrTVJYd1A2VmswNTNxeFB4N0ZFeXB3dmJlVHM4MTFpUkVDeXllUjNCeDdG?=
 =?utf-8?B?cVhWL1BIaGphWEdqTHI3Y1ZUcVY5MEwyaDdXYU12MDMwOGdjdTFmNkc5eVp2?=
 =?utf-8?B?dGxoYjFQMXVITFZhbVV2UnRwVmRBR01OeHFIc2lra1pwQjhZTWd1Qk9nZ2Z1?=
 =?utf-8?B?MG5mK0RFSnBzOFRnQjdHbExOaU1ubWwwcU4wTW4raXQrU2svM1lIUmFiT2NM?=
 =?utf-8?B?T01SNVM4b29uWVZlTWY2Wkl0WS9ka3h1YkxhUFF6cUFwMGgxMXUxLytwQ0dI?=
 =?utf-8?B?MzVmc0FHTGwxVVp3WU9IMXV0T2pSZnl5V3lqWkg2Qko1dUsreThqUFB1eHd1?=
 =?utf-8?B?aDZ4TkhOR2xBRkJwcWJ6cWhUcFRFYjV0eTlKdVEwL2VCVHZtNHc1QkxEYWRz?=
 =?utf-8?B?TjlIRUFXWjVyOWpYVm9YRXRiYnVQWE5FMWQycVM4bjVtektoNEVIUmFYZ0Zp?=
 =?utf-8?B?KzhVL3ZFaXlCWW5SajNqK2hONEJ3b2pOby9oMFZuVFF1T2NwV3NaY1AzZkdI?=
 =?utf-8?B?TWJsZ3h2NGhPM1hSbDJjNDNVK05hdVFsdElJUDlaYjl5TjBSRG5sMjZVbCtz?=
 =?utf-8?B?RUVzcTduelFGWDlONWhQc2FVRDJFazJnS2MyWm91aW41NUFuK1VtWG1yRkZK?=
 =?utf-8?B?ckVBL3VHMDhBOE9CR0d5OXpIaUtDUTByU3EyS0Z1YXBmb3Zqc21zRmYxRnN4?=
 =?utf-8?B?dEVTUitwNlNHY0QyRTdwYVN3aGhhNEVGMTlobDY4NmNRMzdkdmZLdHhtRTNU?=
 =?utf-8?B?RSt4OXRqMDFuUmdhdExUVlZySmRuOTRVZERSbzM0T1lnR3dxZFZCVnR5VURT?=
 =?utf-8?B?S2NiS3FjMW9Pci96QXQrZUFmMm9lZElES2tkckI0aThVV2M0MnZaWnczaUxq?=
 =?utf-8?B?dmlGemo4ZUxYbk5nenNPUklnZzdYc2xCaTU4N2p0RGhvV2xuR1ZWQnJGY0ZT?=
 =?utf-8?B?eXFwZzZmNEJYcHQ0eGc1SUJQMmdNNHdJOEUyMFduSk52a3ZjM0VDWmVZeHpW?=
 =?utf-8?B?WTJGN1hKVWxYa2VwYndrQTNqRjc2elZ2Z0c2N1l4VzlRRWEzMTVSeGVtYUlM?=
 =?utf-8?B?MkZVclNPOUFvdGZrQzlKclB3aDhmMFh1QXR6c0V2WEZYWmxkRE9zT0xxNUYy?=
 =?utf-8?B?T01EWjFNVFVCUENzb0MySWloWTN1cDl6ajhaT25ZUVdkakltWDJ2RFAvMUZq?=
 =?utf-8?B?ODJYVHdlL1Q2ejEwRE1ISHlnb1Vja2F5Mk8vYnRNNFBsK0k3d3lMcTVkL0hS?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D39EF7CCE93A64089AFC15207E4EF13@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c367bd-848c-483d-3425-08dc328716eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2024 02:44:56.6204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrzSuYmn4q81D8u87yPbjSQgqdw/yRHWuHicEKd5HISlRsae47YXkwaPpgjWvefWNlQBOijxjR6BN7BNaajBTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7512
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--18.912700-8.000000
X-TMASE-MatchedRID: u8usGLXufdjUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTYJU
	cS4KTn2A6sepWczL2Txcd8kFo8hGAmPnR7BD/zBVVTfJWlqPdDM6XjCcGFXeryWCL+8tLbvaoBf
	Cx2HzmBsZgEtVcwH0qsnP8zthnWDyzOchXTgjX0Z4CIKY/Hg3AwWulRtvvYxTWRN8STJpl3PoLR
	4+zsDTtAqYBE3k9Mpw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--18.912700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	8EE6F73A0FA832B52E8DF769DE2C52F9FB2EA4B55518A633F87BE6B75CF189B12000:8
X-MTK: N

T24gVHVlLCAyMDI0LTAyLTIwIGF0IDA5OjE3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMi8yMC8yNCAwMTo0MiwgcGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20gd3JvdGU6DQo+ID4gQWRqdXN0IHRoZSB1c2FnZSBvZiBjb25maWdfc2Npc19kZXYgdG8gbWFj
aCB0aGUgZXhpc3RpbmcgdXNhZ2Ugb2YNCj4gPiBvdGhlciB2b3BzIGluIHVmcyBkcml2ZXIuDQo+
IA0KPiBJJ20gbm90IHN1cmUgdGhlIGFib3ZlIGlzIHN1ZmZpY2llbnQgYXMgbW90aXZhdGlvbiB0
byBtYWtlIHRoaXMNCj4gY2hhbmdlLg0KPiBXaHkgdG8gaW50cm9kdWNlIHRoZSBoZWxwZXIgZnVu
Y3Rpb24gdWZzaGNkX3ZvcHNfY29uZmlnX3Njc2lfZGV2KCkNCj4gc2luY2UgaXQNCj4gb25seSBo
YXMgb25lIGNhbGxlcj8gSXMgdGhpcyBwYXRjaCByZWFsbHkgYW4gaW1wcm92ZW1lbnQgb2YgdGhl
IFVGUw0KPiBkcml2ZXINCj4gY29kZSBiYXNlPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4N
Cg0KSGkgQmFydCwNCg0KVGhpcyBoZWxwIGZ1bmN0aW9uIGlzIGRlc2lnbmVkIHRvIGFzc2lzdCB1
c2VycyBlbGltaW5hdGluZyB0aGUgY2hlY2suDQpGb3JtYWxpemUgdGhlIHVzYWdlIGNhbiBtYWtl
IHRoZSBjb2RlIG1vcmUgY29uY2lzZSBhbmQgZWFzaWVyIHRvIHJlYWQuDQpTdWNoIGFzIHVmc2hj
ZF92b3BzX2luaXQvdWZzaGNkX3ZvcHNfZXhpdCBpcyBhbHNvIG9ubHkgb25lIGNhbGxlci4NCkJl
c2lkZXMsIGl0IGFsc28gbmVlZCBhIGNvbW1lbnQgb2YgY29uZmlnX3Njc2lfZGV2IGluIHVmc2hj
ZC5oDQoNClRoaXMgcGF0Y2ggZG9zZSBub3QgYWx0ZXIgdGhlIGxvZ2ljLCBpdCBzaW1wbHkgbWFr
ZXMgdGhlIGNvZGUgZWFzaWVyIHRvDQp1c2UgYW5kIHJlYWQuIFBrZWFzZSBjb25zaWRlciBtZXJn
aW5nIGl0LiANCg0KVGhhbmtzLg0KUGV0ZXIgDQoNCg0K
