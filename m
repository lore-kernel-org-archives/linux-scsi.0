Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27091134A0
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2024 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706262386; cv=fail; b=ATKdQkY2hagfHT230c1GyKqnGYFycZH+kE4bBDAMCps0ABgPtZJu0TQk3I/wpsuze+RzP5+KAFbDxV+0M6LFMvS1Ngy0B8f1g2vcUIwDCiNfXrsBW8NP4TG4oNEz+UQ92SpVkGahW/5DLA0IRSVRSfWGol9SZ+iBOnymv4da7vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706262386; c=relaxed/simple;
	bh=bMzr01iTNFG6hcoHASnwfodRn3XuvDbOu8PxSguJTTo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M8HGe0sOH5od3ibsuifFekO/co2NYb2bOBJqMp7gnc7iuIF5lAvHImoTsu0LkpILPBtdd9V8n8P8a+Ubo0gBVZwQhxF4RyqabPN9VprJmQu7g5YSW199XtHQxpRhqYuuSojUhcK0/LCpZkQ8FNNmR7+7Kl8MB56/Fry0L+qAzPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=BXvf89VG; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="BXvf89VG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mx4SmergjC35/LL3BUglaPUkF3TzDrKJLqgTjub8wW3XSWe5+qFnA6mcCvinNEcItU4f9VgLhf6HAcY8qd/2a+i+vEVPSIzGWa/V5757oE8glPFJpgmaUYUCKD74ln6dEKSjckNuQBLBtBbWuXeEH2RBSpApYF+FRz/POCrMat/GtsbMkvLHU9JyreqycHNtPMvWJseimozWp4MvK/R+YoRVlHMuMgSafZC0DnEHRDX8GLsh4O8jps1hO8iBk0FBOqkNoeV31uuajEb8l8W06PWkuLWkfLawcRtA8AHSAMA7lftxrpLyUJDYPIvt9WxNnp8M9x24A2DGLx/sxZRqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMzr01iTNFG6hcoHASnwfodRn3XuvDbOu8PxSguJTTo=;
 b=UJbH/pR3SmdjFf94jdG3+PSWlYuN/QdXdbn+osphSysJHegO2ZKLNxfqzmLl9HvID4i6n5HP9J9GjQCIQx5ceSrpiHV5krtEZXivQMCZ4BGdLgnEuqnLvF88Ss/Rsiot0bVJi0UMMQEZvyGS74uvlMhUtp922By+nA/aTVtzB6rxPZpl/LXkA5W2Xlk1xdnpMv9SnRuVoqSxSsDWcIstHxa+rbnmOw2lsrqWxQQSUicr1C78GQVfZgXAilrj+sbDMsKx/1351FMm7+Ta6xXcoAx8/1Ht61qF1T39b9YCusG/koxZdj8JenX0/8WqHR832RzUw5aFTupHA4T1yi5EDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMzr01iTNFG6hcoHASnwfodRn3XuvDbOu8PxSguJTTo=;
 b=BXvf89VGHluBp6VRwAKnYP7MHm5JAYPG/xh+enBFlQfW4P+bVktvr1bScoI+tZs0EHg2a0Jf46eFIbwaG294eEHY/vpQhduvZFN8lUAZ18SU8zR2BjyGryVwSceLEjKckM8Qml5OdikykFwNFstcpF/XC+wDY+HWFKTIPc+MTLc7SDo/Nvx9+d38dxae3zF6EHOoSpw5uMgJCeV5NWJt5jl8i8t5zDGj0spKNfAo/8iyRshhy5PU/sLaG1BZV/KoiLbRMW9bFZFESTRAKz6NG5YLc36nFjmkUsz9lTbrnR0f/qZEq5GltKWWGI0YH020cwEE+0Kez5OfmcfoDuWb9g==
Received: from PH0PR08MB7889.namprd08.prod.outlook.com (2603:10b6:510:114::11)
 by DM3PR08MB9192.namprd08.prod.outlook.com (2603:10b6:0:41::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.15; Fri, 26 Jan 2024 09:46:19 +0000
Received: from PH0PR08MB7889.namprd08.prod.outlook.com
 ([fe80::8169:ef49:5bf6:fd80]) by PH0PR08MB7889.namprd08.prod.outlook.com
 ([fe80::8169:ef49:5bf6:fd80%6]) with mapi id 15.20.7228.011; Fri, 26 Jan 2024
 09:46:19 +0000
From: Bean Huo <beanhuo@micron.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "h10.kim@samsung.com" <h10.kim@samsung.com>,
	"hy50.seo@samsung.com" <hy50.seo@samsung.com>, "sh425.lee@samsung.com"
	<sh425.lee@samsung.com>, "kwangwon.min@samsung.com"
	<kwangwon.min@samsung.com>
Subject: RE: [EXT] Query about UCD allocation
Thread-Topic: [EXT] Query about UCD allocation
Thread-Index: AdpQF4Sme7+LXoijRMWzH5BRC/bwfQAIlBWw
Date: Fri, 26 Jan 2024 09:46:19 +0000
Message-ID:
 <PH0PR08MB7889A8C7D16F911E4F4A8FCFDB792@PH0PR08MB7889.namprd08.prod.outlook.com>
References:
 <CGME20240126053128epcas2p41cf6ee4ff361ff89f7f1dd2f190aba6e@epcas2p4.samsung.com>
 <000001da5018$e9506c10$bbf14430$@samsung.com>
In-Reply-To: <000001da5018$e9506c10$bbf14430$@samsung.com>
Accept-Language: en-US, en-150
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=9e281c33-55a4-404a-927b-94acc310b908;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2024-01-26T09:27:50Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR08MB7889:EE_|DM3PR08MB9192:EE_
x-ms-office365-filtering-correlation-id: 005529dc-a4c8-46cc-1876-08dc1e53a619
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 wM2BkQlQXPYT6jnbdx7+cTg48OINZKbJ6vK9A7i8ZJRzMBcPfA/FiAvCsq6UghIVA4ta4zXorRRfJQoW0fQBAIJJrNgMFBAAlSDpBNJqAG8BP9ViLEj3qkkXRaArFPLaL0vQhipP4azDar6H5p4AqxHwlV+N5aXFdpg4s5LpDwzResGP798bCoVS0Rsa9NDspvb2SPNDfYOZtfv8tapFx6CeQjU2MYr1y+REMoa5tvvuD5G+0eiU4CSWwgl5MgXDiez8Dbq+ogVQ6alXNfKtD/GhZWU1IzKHrEgTxCpGTi4M8Ouq4n95iXCN2tD7ZrTTbmM8faHSO1Vs0x5ZIHkuDnxSP+FzJH9oVjIoosQEohwsrPpSwGBDMyNlGrumgSfjoIxbg5YuwvvuA/mndE9aLsoJD7gve5Ac+6cilc9iZFQXcoChmoIxSJKRJFhOUE+tI4isMJr36kuQqDQxLxnq9AHHGHUzYdqXZQ/qN3olh0dOE4g/c30DTekAq9iXVxR0nTpJJxqs5Zwht/JDEuQZSJCk5Wfem50VnYGQJCG7PQH/Nv5wkQ63LQXly1XDJWARfChYgAi9f4FyKk+z1kZ8N97a+lB/e0hwv3cYHfpBKuZ6jTPaKw8mjlC2NcBQzIXljCKmr1dRj0sdbBAz9KSIgA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR08MB7889.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(71200400001)(7696005)(6506007)(76116006)(110136005)(64756008)(66476007)(316002)(66446008)(66946007)(66556008)(83380400001)(5660300002)(8936002)(8676002)(7416002)(38100700002)(26005)(122000001)(9686003)(478600001)(55016003)(52536014)(2906002)(86362001)(33656002)(921011)(41300700001)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QW5TNmxRU0xNSnF5eitzcDRmeFBrWjFxUWtleVJWK3lWZVVuVUJWRVNiK2Vx?=
 =?utf-8?B?aDdQTGNQVGxOZ09qZGNzcnoycUg0ZHlrUFM5bTVlQitmMFJTUTRWR3hKT05a?=
 =?utf-8?B?UFZSOWRaalh6Q3VpTEpnMjl5cjh3V0lTOWVvQnlHcU9xN2NCSmk0aXRQUDY1?=
 =?utf-8?B?ZFJHREQvNFp4SzVpUGU1V2RkSWFjUXJnd0xmcjRMMGpYNE5acDdzMlN4eWQ3?=
 =?utf-8?B?MDJxd1dHT2tjajhDREhiYWcraDNjYVZKNkltVy9PNG5UUVY5d2lGeXRncU9X?=
 =?utf-8?B?UllDaXJYS1NrMFRHMUVMNVMwV0M3SmxmNUZmcXhJMUplTDhiVXQ2MjltVkFC?=
 =?utf-8?B?aGtnVmFmZVB5QnhPRGQwaU04ak9YNVhHRkVabk5Ga3I3UVZaWHQzdjlpR0Yw?=
 =?utf-8?B?dVRDQWNyL2JtUTVBYUxCb1g4aXJ3NTNJNHpkMktJZVhmR1RsblI3Nkp3aXRB?=
 =?utf-8?B?N203bHBmZzZnRDRPWUNaUFY5bGJFc2orVENZY0R2RjlpcEZOdDYyeDJqSjBW?=
 =?utf-8?B?Q0JDalJiZ3p3bGxEKzEzeHZUeWpQUG5STVJJV3BETGd1TlJxN2xRbUswOUt2?=
 =?utf-8?B?a0dpdlc4dVJLOXBGazhSKzJBeFdiMkRxb092MXR1QllwL0ZjTWQ1cW12SHAw?=
 =?utf-8?B?RWJvOVhNSm1XTVRuSTF5cmFDcFNndTFwK1l5eDRjRDZ6eUtROXN4SWlFSGRi?=
 =?utf-8?B?MzVHSEk4djlqUnVPakNyMXZVTW1hQ05yNU9wbHJ3THYxcGZkcDJoWGVHMkxO?=
 =?utf-8?B?dTNEc1dNQnFPMkhKSlNRUC83NlRiK1huZGhTbXNGcmZnRTgyeGZ6bDZDLzdK?=
 =?utf-8?B?b3FzWUd6dE1mY2hhUktZUGFwZnlUTkJKdDIwWlJlbjBZZDJwcytxY3NTeW1G?=
 =?utf-8?B?L0pMUWVFVElJL2RpdFZJWEhOVUJKc1N6R1U3TnBkL0E5YlVxcnlnaktxdHpQ?=
 =?utf-8?B?QVNNMzRyVTJmZ3VIZXdMY2JVQVBFN3Rza09vQXllSGxRRi8rM29xWHZ5Yzll?=
 =?utf-8?B?ZDQ0Q29JTE9WOXA4VGZzUnJHaXdQbGpNV0ZlR0FicU1JSlo3Z0x6eHZYaGlN?=
 =?utf-8?B?Wjd3OWU4TnNvbUIrWU1vMTNxUU1nM29NdmZlYnhBK29TK3pRbTJVK2Y5KzQy?=
 =?utf-8?B?VHh5YUFNeWpielVDbU4vL3RmL0ZQb1cyYVRLVUpjcDc4eEpvMXMxeGZ6SnE2?=
 =?utf-8?B?R2lOQmFXUGZZbzNCUHJhMU1nd2J4YzJtbzRBTDFvRys2b2NaNWRJR2ZVTk1z?=
 =?utf-8?B?cUVlbmhPNkJvL3I0MVRpM1BJNGhrQ09IcjRxdVVBYlkyS3pXNnpYOGV1b0dL?=
 =?utf-8?B?a05CcWE2My9UNytUaG1tYmRBaG1OR0pVUm1ncWFxQkFRWEgyY25ydDZzblNO?=
 =?utf-8?B?b2txendOdGZZNVZKMGlBT1FRM0M5anJzaWpRTUNmblFBeml4a0lsd3FYSXN6?=
 =?utf-8?B?TDcvaWhCdjZBZTNOVy9SbWFVQ0lOSFRpQzFIYnptYzJOcG9mM0RUaGwrSW1J?=
 =?utf-8?B?amdXTDZ5MG95c2ZyVHk1WGZHSzRRbUN3UE5HU0YwU05jbkk1ejlJWm55OFJ6?=
 =?utf-8?B?enUvandYSGlXV0d2M3R5M1JBUUdjWVpFejZZWkw5aGc3T1FkV004WnhtV1Zo?=
 =?utf-8?B?SS90MHVGWXlzZlRxM0pqTStobjlvVnB2TVRLcEJkR05RNEYyYThVdTBaTnhv?=
 =?utf-8?B?S3lBTVRwWDJZYW1PcXQyYS83dWpvdjhDV0ZrNHFOVVVPaHVTcnd3T08yUW15?=
 =?utf-8?B?YWhmcldIcG01WUpqSkZiNytLQVE5ZWhteDVESGc5dWtKQVh0MDFuS2FDeFVz?=
 =?utf-8?B?SzFiQjVqRXZtbGdnVEtOQlQ1K3NGUWU3bXBLdmV6S3ZNQmpvWmh2bnZua05P?=
 =?utf-8?B?NWZxWXRMdm14d05IYWNkT052SGhDQ2FQekk0MEhXeUhraHg4aFh1UDhjSTBP?=
 =?utf-8?B?Qkp2Snk5b3RxMUFnckhvUjVaMXlZTmQ2UWxjazJCb3NDTTVTTUdiZjQvMXZy?=
 =?utf-8?B?WSsvek9rQTJwWHlQTGRhMzE1Qk1XNElnMVVYNjhJYUlXSjFycWFTOVNsdmVK?=
 =?utf-8?B?WThzVFByaXorUGNwUXg3UkwyYTdONndrZDRsSytJeG9KcjhpVDQ5dGk5TkVZ?=
 =?utf-8?Q?7fQ9uCTMSkVa/pfHgKf+1znSd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR08MB7889.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005529dc-a4c8-46cc-1876-08dc1e53a619
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2024 09:46:19.7053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kFiqkna5BGe3C3ABN+g3BpcGNI9w+/WfKofZWbQd946xbZ7oxJ5vJfuDSkG7XP0cJMeso7c9KLLusLs+Em4v7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR08MB9192

PiANCj4gRm9ybSBhIGNlcnRhaW4gdGltZSwgVUZTIGRyaXZlcnMgc2V0IHRoZSB2YWx1ZSBvZiAn
bWF4X3NlY3RvcnMnIGxpa2UgYmVsb3csDQo+IG1lYW5pbmcgMU1CLg0KPiBBbmQgdGhlIHNpemUg
b2YgUFJEVCBwYXJ0IG9mIFVDRCBwZXIgb25lIHNsb3QgaXMgZGVjaWRlZCB3aXRoIFNHX0FMTCgx
MjgpDQo+IG11bHRpcGxpZWQgYnkgUFJEVCBlbnRyeSBzaXplLCAxNiBieXRlcyBpZiA0RFcgb2Yg
UFJEVCBpcyB1c2VkLg0KPiANCj4gSWYgdGhlcmUgaXMgYW5vdGhlciBrbm9iIHRvIG1ha2UgaXQg
c21hbGxlciB0byBzcGxpdCBhIHJlcXVlc3QsIGl0IHNlZW1zIFVGUw0KPiBkcml2ZXIgY2FuIHJl
Y2VpdmUgMU1CIG9mIGNodW5rLg0KPiBBbmQgd2hlbiA0S0IgcGFnZSBpcyB1c2VkLCAyNTYgUFJE
VCBlbnRyaWVzIGFyZSBuZWNlc3NhcnkgdG8gZGVzY3JpYmUgZGF0YQ0KPiBhcmVhLg0KPiBUaHVz
LCBpdCBzZWVtcyB0aGF0IHRoZSBkcml2ZXIgaGFzIGJlZW4gYWxsb2NhdGluZyBsZXNzIHRoYW4g
aXQgbmVlZHMuDQo+IA0KPiBJZiBteSB1bmRlcnN0YW5kaW5nIGlzIHdyb25nLCBwbGVhc2UgY29y
cmVjdCBtZS4NCj4gDQo+IC0tDQo+IHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBs
YXRlIHVmc2hjZF9kcml2ZXJfdGVtcGxhdGUgPSB7IC4uDQo+IC5tYXhfc2VjdG9ycyAgICAgICAg
ICAgID0gU1pfMU0gLyBTRUNUT1JfU0laRSwNCj4gDQo+IHN0YXRpYyBpbnQgdWZzaGNkX21lbW9y
eV9hbGxvYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKSAuLg0KPiAgICAgICAgIHVjZGxfc2l6ZSA9IHVm
c2hjZF9nZXRfdWNkX3NpemUoaGJhKSAqIGhiYS0+bnV0cnM7DQo+IA0KPiBzdGF0aWMgaW5saW5l
IHNpemVfdCB1ZnNoY2RfZ2V0X3VjZF9zaXplKGNvbnN0IHN0cnVjdCB1ZnNfaGJhICpoYmEpIHsN
Cj4gICAgICAgICByZXR1cm4gc2l6ZW9mKHN0cnVjdCB1dHBfdHJhbnNmZXJfY21kX2Rlc2MpICsg
U0dfQUxMICoNCj4gdWZzaGNkX3NnX2VudHJ5X3NpemUoaGJhKTsNCj4gDQo+IFRoYW5rcy4NCj4g
S2l3b29uZyBLaW0NCj4gDQoNClRoZSBjdXJyZW50IFVGUyBTcGVjIGVhY2ggUFJEUiBlbnRyeSBj
YW4gc3VwcG9ydCB0aGUgbWF4aW11bSBkYXRhIHNpemUgMjU2S0IsIGJ1dCBpZiB0aGUgaG9zdCBz
aWRlIHN5c3RlbSBzb21laG93IGNhbm5vbiBtYWtlDQoyNTZLQiBwZXIgUFJEUiBlbnRyeSwgYW5k
IHNwbGl0IDRLQiBwZXIgc2NhdHRlciBnYXRoZXIgbGlzdCwgMTI4IGlzIG5vdCBlbm91Z2guIFRo
aXMgaXMgbXkgdW5kZXJzdGFuZGluZy4NCg0K
