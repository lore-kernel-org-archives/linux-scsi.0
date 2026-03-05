Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89174279346
	for <linux-scsi@vger.kernel.org>; Thu,  5 Mar 2026 03:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681254; cv=fail; b=Y38FQ8RsOAJgx7Dzs80U+q+iuq6aHn1xDZPpxZ6cFeGQ55bH2si+ODkEhxVPt9hUNcE2lXv+9ezdXsLveqtySYlv/loPgzRwWoUSQlR88nH3SCAsbzDtOP++l0DCy+mnWSkR9raKUoXR2699yCEfGCPaz9lnT1POWws7Hrh0d+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681254; c=relaxed/simple;
	bh=d+mOikhxarW9BDCEsWTsGo4qGDmG9LX3yD0SbF3K1q8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aGyslXQU7OckBo+DqGQ+OPQV9VkSlFywfqyWK65fFbcV9bRixDDKdpZRD0dF+kM5fJzoe8KNWATg7YNJgJtPe/cIr2c0BEmV2pxYyAxDCjHzx6StL+w8TgF2Gqkr7BZYPkIPv+GdQaZG/OLTTYK2IeVi7dfdguiM2sk6y/J6OHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IxfdmAu6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gSQC3pXt; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IxfdmAu6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gSQC3pXt"
X-UUID: 3b60c550184311f1b7fc4fdb8733b2bc-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=d+mOikhxarW9BDCEsWTsGo4qGDmG9LX3yD0SbF3K1q8=;
	b=IxfdmAu60yvdJaFfhMMin+9Ci1AvakiDSuEwkvSBqaVwz+l3qDy1bUAcGrfVyrwk67Cb/UB7FDoqSOMHrFCkv0ApeK5oXTggCZ8+EC1cMfiRBMoKKW/ud0ykiiHysgIwygcUMXsA9IdKJLFhHes7oB0Gudl50qEk/FIFwo5JKOQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:db19c5bc-a0f2-4d93-ab6b-c6ce60804218,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:edbde05b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3b60c550184311f1b7fc4fdb8733b2bc-20260305
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2063674304; Thu, 05 Mar 2026 11:27:26 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 11:27:25 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 11:27:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/IHH+MwkLeAHvTKOIeVMap98yRhaWZfIquf92tKDohzpt6qtx5ZLMDMS44XEvCmeK214MQ1uxbss62iw1AtrJjTGgc8S2blshrviQtRM3D6B+smjUSfhefrsmJGcNRE8jilXlbDHUPo6FHWVuamnzlzLF3ndOHerWvm31wiudep/Xq6PE65h93hSCVjAL4x/Md+cLoh8AIw9v6rEnvpqNx2vQWLPo3YHxImUIGQAh5giuP4Vsw/C9TGhAkUzTd9iEo57ffVbTr+GYgZ7ngZXcZqfobMFmeVGdR7GOR1YR9RW2ZdgF7PZanKJWan+QgS6p9/S7o//c29N5Bso60LfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+mOikhxarW9BDCEsWTsGo4qGDmG9LX3yD0SbF3K1q8=;
 b=Fhq0i0Gc7yT3F7yfQmDJQ2bRK8nd6GG0PVbeH3e5S8tADFtt4iKWCg8WrWQ/Po88MZrAGkG/u831qYFpV8FgpCCw0ss0TLCejC6nKJ+Myc72iE8D106TiunjwatFNM5tL3wi7tYvU4YxQEs+YXKVnJFfFAt/cC9fAsN7uKp/QUt0b1pXl7ghx647LGSmhzv8jR4IaUvnblNHzZVj/Ux5fu2hwbi+uFzWbdtE7+Svqt/c+Lhk+4BddnuV7TYhH9I6g9sCWgeGdaPl7x8V6VQAUhhvvI6S16gbXvk7HhwMEn9V8wZRCKXnKu/Gr1PcPvjAxeleP7nCzCu/fmplyt806A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+mOikhxarW9BDCEsWTsGo4qGDmG9LX3yD0SbF3K1q8=;
 b=gSQC3pXtIjvknSRc5MGhonfOnnLh3qYjNM0sec1FXHJpQYoAJt+wlS+t+YrQDpHNkYZUg1LYrDrhDDSshcp8MiLzq/Y7vYJnqxyxNZqyDOlU+J62rOHS89BJYxvVooIhTnAvlDSjCJNHwiqX1NPSe2Jyzbbj9wx9g1Pxkntk28Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6491.apcprd03.prod.outlook.com (2603:1096:101:44::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Thu, 5 Mar
 2026 03:27:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 03:27:21 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Topic: [PATCH v1] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Index: AQHcq6Z23AQptP1Dk0+Aud7gmBXImrWeczwAgADVaQA=
Date: Thu, 5 Mar 2026 03:27:20 +0000
Message-ID: <fa949b2c2f9d23fa112f8b37377ca2f23c5bb258.camel@mediatek.com>
References: <20260304071346.1391315-1-peter.wang@mediatek.com>
	 <ab2de228-47f0-40b0-b586-c970a9c0652a@acm.org>
In-Reply-To: <ab2de228-47f0-40b0-b586-c970a9c0652a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6491:EE_
x-ms-office365-filtering-correlation-id: d1922f5d-6490-4728-6b26-08de7a671c74
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: FkvgKUBQXZzUEvmfe2Geqg8jnSp9c9VBL8yarIV6kQDj3tW6Cf7OUWHS3pbdgW/937xAgrSaj1AFTLfw9iGrF6d6QcwXOwSiM8rpO1cabousZIcY/BhUsrjv4tFulHS9ZWSC6E+zGoLASq/WD03TcPrDUj2AjwvEy4uM35i0oVR5E65f99T90dOKW1VTXSyfv/L0zpFEairLaXnzhofKQrXBxJ7BOhLvgK2NrHDm6rsj9uRMYwZBPr4GK8AlVcUDHsdftc1aaAtqK//ncksVfDRnPOz8wNQ8Qmd/BSN93ZMT6BU01hlq0zTzCyR9lvYJhLSLxiDhPIBqxHCgObI6ea9f4DFjpQebRBuCmFRfBChlcu0zsXCIRr8l8FD8CUeo6S5Lkov9aRqpxHmWTG51260C4MXxwJ7TV36P6BpY1CYxJOunMvlbFIYkQxNuRznWsz4eDfxw3JZwUBsLK6qjNQx2U2C1PiYkmY3EJjiucH2XqQepWDH5UQHErGUUedPtawFarclPWMtWkTcGX3qfqHwdC0WjT2ZcHVQ62e2AtHXKLOgHehbCz6VJAels/DDGikO5qkGJlQqyM5nD6e+4D7IfNqRvBriabD/H4aEQCa+xhXos0Qn8M37bhNqBbUKC4MLq5Y1HvVkwClckpjmlog7HWjhaC92mGXUAgmIaV3kNV2v5gn0SFvlGgvzHIP9ZC+T/fCnaFwOv9Q1slxdm3EbZx8XXKbZS0zSIiZwhcbU/U90mFIhwZbmhzgEY/RBeeJFqXvXkq7qTTeb82YanaQAYkCCb9Z38VBYJCYMElTQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V281dnBob1l5ZmZ4cThJSFpUeWRCUWVtU3hLaWhOdjBRR0dKSWlxblVOOG5X?=
 =?utf-8?B?ci9PcUJxYjRrV1lEYlRDMVNYTlA5c1V4bmtuRm1TNnBqU200U05yd1IyQ3JD?=
 =?utf-8?B?eFZicGd6WjVYeklxbzJyRmVwKzJEeWRZYXhLd2dVZmJpOVlyTXlCK1hDNzkx?=
 =?utf-8?B?VmZWUE1sT2JSVjFmTEtMcEJqY0ZGU0kxTkRiazhIOVI4TC9tbW9oOWVBOFg2?=
 =?utf-8?B?L2F4OFBtVkVOQXh4Zm9IOXRTd3JjZVR0ZWxtVE41MEo4b05raUtqMStsQUh1?=
 =?utf-8?B?TEhrY1ZPR3BMbW0yNmtUcjZhblBTME5JdTU3dE9UUllwdEJzS1dnaE4wYktp?=
 =?utf-8?B?Y21jbGRTU2lGSTdrbDVXR3ZWV2hCeXBXbWM3enhBTFdHOVp1NExTNGFsWDY4?=
 =?utf-8?B?anNQZXkzYTltcDkrc2Y5VmVNa0tWWXRDUVVMaWUzRitXZnRCWlBRMElNc1k3?=
 =?utf-8?B?TmNNMTFYdkloUXNyZFdtb09RMWJDdkJaSWxqTUREc2JKbnpFYVdXUDYzVHg3?=
 =?utf-8?B?dFhzU3VlcXVFcEg1cWJVUmZ6ZjZBTnhqZ3Ztckl3c0k2ejkrbDhTNXc0b1FH?=
 =?utf-8?B?cENRbFZWYlc5S1pKdTllRTJzZmljbFg1M3FPOWhyK2JZYU93K2JSdnA1andj?=
 =?utf-8?B?emFRYzlKRUhBOTFEMElMV0I2cVhISFhzcXhENUtUY2pZRnZGVzZYeUZPYnc2?=
 =?utf-8?B?TGZaSFhJcFNjTDVtcDhGTGZ6UjNYeGh1QjBMY2o2a2llS21WYXJuNkNTRENJ?=
 =?utf-8?B?OEZieHdTcXgxdjh3WWpLbWNzT2FhaGNVSG5UU29IL2UrU1llNzNsTUt5eFVJ?=
 =?utf-8?B?cEwrTlM4SnJPNjRVWWoyUEt2WTVqbHBXaVBlcHRaSnZKdzV3U0hBcGUrRHpn?=
 =?utf-8?B?WU5ibmg4Q2FFaXZNMGVHYUlBditvQUlPT1prWmlBT2NMS1ByNGJpNktwaSsv?=
 =?utf-8?B?UEUzcmZRelk1QUl6di8zOXZDS2dyS2FyOStWbnV4bHJkOHhCbXk3bHVlSm9i?=
 =?utf-8?B?K0dNSXRJS1NJWERGNUFpdHkxM2tVNi9HazRnbVpqaDFkaTlKcGZwYmVya0Rt?=
 =?utf-8?B?YVNROE95bVd0OWxSUmlzU0pYQ281Qmp0c29VOHhkWko3RitNR3c2bnRidHFE?=
 =?utf-8?B?SCsvTUZCN0RpVG9RVWFGUCtobnBHWjZJTFN4WlBVamw4bDhOdEFwL1hOUDA5?=
 =?utf-8?B?TUVKVDZtNFFYbTFLdDA0TGtuYWpUOXVYQ3FlcjVLaUdiQnFOVEdoQWpYdm5v?=
 =?utf-8?B?VGVFeFNPNUp1RE95VWU4NzVKbHJlVGpWMTBMZVUvMG1RMDBmajY1MHZtT0RR?=
 =?utf-8?B?Ulg0UEVtUWdrQkd6V3hUaXJEak5nOXZBVE5vRXVScnRqaE1ScFlpMUdMNnRx?=
 =?utf-8?B?Q2krQTNUMU0xdHhFL1JocVRMYkRQTW52U014VitQSlNVS2QwdDlFRG1xQnJz?=
 =?utf-8?B?aVhFQk5oYndWQTBxZEtORGFETVYyR1ZQVFlUQkh0Y3o0dmFZajN6TDRtRWRa?=
 =?utf-8?B?N0JUcnYwOVlBc1A2alBVWFA1b1gzSmR1Z0Y5VEc3YXQ0cDRmekdMNTMyOStX?=
 =?utf-8?B?UTRCVFNoZjBSbXV3RDkwYTNIZUxnY2M1MkxBdUNobzY0QURkaVgzNmxzK051?=
 =?utf-8?B?Z3RNc2Qxc1Z3TGo0NDZYNFM4Zy85NTlKRWJ3MC9GanEvTnpUMitkMWtyVFBj?=
 =?utf-8?B?cXpCeW9UZzdUbkZzRUZaMUNEc0FzU3JqeE92blBuaGUrR0EwMTIva2RkbFN6?=
 =?utf-8?B?dE5ZK3pLVmNvQzMvV2d4V2FlQ09hTnZjblZSSGxoL3k5dXZoY0paK2dndzhn?=
 =?utf-8?B?NHZiRzgxRGZKbW0rZi8wZU9qZ1E3aEVTWUFCZ0R2OHVoeEJQWVgrYmVOZGRr?=
 =?utf-8?B?WnQ4TWNUVXBVSEhjT0FYWEQ1a1h4eGN6Q1RNcytvSlBUa21lbGlpMXlxZmNo?=
 =?utf-8?B?Z2huVFc3SXZOZWFvT2srMUU4aDlmOHMwR1gvNkduYUpqZGs4WGIySjNBZG1I?=
 =?utf-8?B?WHFidzllNkRvY3drdWM1aTQ5UTc2UlBUZnBUbmNoZWpSYmx5QU91YkxHYjly?=
 =?utf-8?B?THJPZlpLZ0lsL1VFZndDemZvMTEzTmx2TmNmSUdaZHBqVXhwV041VTZrTXBn?=
 =?utf-8?B?bENYVVJLSHFPd0FmQ3AyUHpMK3E2dlBnN1dlQnNtZDBoSWduWEtlUDBrWVN4?=
 =?utf-8?B?T2ErTnRZVTR1VHdSOHhvamhGTXNCYkw1N1VvR2Q0QVpxTVExYmJkS2U3ak5j?=
 =?utf-8?B?N0Y5SlppSEtEbU1vb2NrR1dJUVI5Z1M0ZU5uQ0ZCcnJWOTJTSjN1aDBpMUp2?=
 =?utf-8?B?cnJUc0dyZS9MeUdtWU83Sm9NcUdSTVBzZUhIaE50R3lRSEpjb2l0VVVsQlNw?=
 =?utf-8?Q?lfBJr6Bou8RMmIYA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14DE998A3D32DA41B63B2B05B9998901@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VPnx8cz5kMKhUA7pP3zT5NOVhbWHE+ldXFroH6tYHpCrKiegDaZsjH6YoxqTZQ83etr9TNuNXBH864dVta01tI6hCFcqMVdp4SQhMlqEReWkiy5FvO07fcB7eRHdlNC9MnrsGztiQekSdJbCGXTW9bbeMmlMAZyZUgJ6kCOHoljKhJrDDpsygXtBQFnpYTbzTXC/sxsMJWzNAw22UVZONGTC/YutiqWS9dnCV8NOOyBbSEHCdTTs6Y7RM9h628YPO5uc6NC1NH+akpRSqWuzAQ5pzmeP34Vq6IE9IKcsd3jN1geF4eAvHHm2RSUzlw5RzyNPtAZ7CXlfkHdMUue74g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1922f5d-6490-4728-6b26-08de7a671c74
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 03:27:21.0187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AorLSDDORBKV8rU4guvfjppWG+gbP7JLn9hCrsDFaprF26AiVIn9I+O533ZnELviD1ig+PY0HMDDuNzDL2BDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6491
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDA4OjQzIC0wNjAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEEgY29udGV4dCBzd2l0Y2ggdGFrZXMgc29tZXdoZXJlIGJldHdlZW4gMSBhbmQgMTAgbWlj
cm9zZWNvbmRzLg0KPiBUaGF0IGlzIHNldmVyYWwgb3JkZXJzIG9mIG1hZ25pdHVkZSBiZWxvdyB0
aGUgVUlDIGNvbW1hbmQgdGltZW91dC4NCj4gU29tZXRoaW5nIGVsc2UgbXVzdCBiZSBjYXVzaW5n
IHRoZSBvYnNlcnZlZCBVSUMgdGltZW91dHMuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
DQpIaSBCYXJ0LA0KDQpUaGUgbWFpbiByZWFzb24gaXMgbm90IGNvbnRleHQgc3dpdGNoIHRpbWUu
DQpUaGUgcHJvYmxlbSBpcyB0aGF0IGEgdGhyZWFkZWQgSVJRIGhhbmRsZXIgY2FuIGJlIHByZWVt
cHRlZA0KYnkgYSByZWd1bGFyIElSUS4NCldoZW4gdGhlIHN5c3RlbSBpcyBidXN5LCBmb3IgZXhh
bXBsZSBkdXJpbmcga2VybmVsIGJvb3QsDQp0aGVyZSBhcmUgbWFueSBvdGhlciBtb2R1bGUgSVJR
cyBwcmVzZW50IGluIHRoZSBzeXN0ZW0uDQoNClRoYW5rcw0KUGV0ZXINCg==
