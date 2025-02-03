Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B201FFC55;
	Mon,  3 Feb 2025 16:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738601404; cv=fail; b=Fvn2lGu4aTPQyGDKHlIU8ifqvQ1wqqtHTvn2iXp0uOsrNSr2pHojm8cBffWi9/paOHeDfghUhsnpuaguD954+a4OgkJYQBqjF26vRlKXQYIkHRc+zoMmJdUP86Olpu1vietDWDDR3FJ7Rn8bnDDy5n/SgN7qCvgLXtfnSGUbEe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738601404; c=relaxed/simple;
	bh=4MzgSZHcpTjV9WknwRRDeB38nabktTwbQ0uJ8yROspM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iWlPTf+0WZyYC9II+zi4bstp8Burgg9dbACyfe09LZ976KvLV/0u4qnhdUCjDapeB6YnjCVoaYfej8WfrNbkEjRqATu4n6QNSkrrYVg2ds4ZbHE77/j6i2iyWYssEYi9+8I0zH+AOGEJPpyrEg1DEZN/1XNnGNueYLh0AD6ii44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OPlZp8BL; arc=fail smtp.client-ip=40.107.243.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OPlZp8BL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKjpsHvUItOv3CfcsVfJE2WZaal+8FKOcOM92OmdkgvuzpEw5l7JKr3AmY/X3quT+C8hxcG3jYyr+TAgbzvX9EbjruKkPPzFtU4/NgUZw08d57AqMaMkDr+x7KgUvrKPV5z7hkev+O14McG75Unysrz1K0Epd6PTnWjOVCzjGNltCzTKLN1qKo101p2d1b5HvOPIP+nIDRQ96o0y6RohuHphzt+w4I9+Hu+SUe5DAQ+zpUC7Nys4DTL8WIeFlQZ7j6N5pBDY8Q0EbvHJQKBvTu3lqDkx6UkZuiUBPKFhBRWeSvBZFBr8TmtE+v7HhBbFlCQYk/dwCO9En3TFJI5wjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MzgSZHcpTjV9WknwRRDeB38nabktTwbQ0uJ8yROspM=;
 b=ogHL0IUtZMTD3MgLJnLeREnON8vasCF+3NsqPK42jGiHdkWPWRUa9esHKN+qzCJni3LBGqPvVK1VfKSDOR+RZ/lilZEQD5bv+maMmq0uNXo2GP35ySpW7x6GY2P9pbrrRxWCJlrsF+LWZQ/to3RatOgA62k/uHQI9QlOBaxxZpLtucUoyGAceKFvHdJGYfwafZguKuUe/S6n3eup4fbftJZi/nOPm9YQh1zRFw4Qgo9xkeEHxP+SkCxWqKVEFkkMCoBQzD0lfKvjr+gibSF/aNT+JBIpzZ4rZcVhXO0wN0JvaLpNQTQu2idULc2lCdDGs0VzRzZw+bNFCY8nuVechw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MzgSZHcpTjV9WknwRRDeB38nabktTwbQ0uJ8yROspM=;
 b=OPlZp8BLBiTXF0CLHftArpgui6qgAI151FHadgAr0Qep4R/GjClc+U9GdlbSo/r/GZl7rmw9YN6ss9gqnyk7FYoeirK+GusXZBhwSsNmuUc4FCp5p91xwEAEaYcF3AoUIoYeDMGbhZnHB5WtlFoqeFDDBUyzK9lcxPCNmRgdo6BPQ6rZ3aB4IlivwfnzVYSRHb6a2WPrshXBT8M3Fwl4w7RMI5EC9D7iRRxmp3BkIRqQp2VBYVLj3zw4pqI0fiH8LDgyVMK3LL1TyUJLREKXpHC7S5gP4sfRSXZ/t+au+nXIjjsiI5h3WkHz9BUlU4c4Ol3D3ms9fDHiyKiiNzo3CQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MN0PR12MB5738.namprd12.prod.outlook.com (2603:10b6:208:371::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Mon, 3 Feb
 2025 16:50:00 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8398.021; Mon, 3 Feb 2025
 16:49:59 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: remove bio_add_pc_page
Thread-Topic: [PATCH 1/2] block: remove bio_add_pc_page
Thread-Index: AQHbXbHxgYHHDxrTcUumzD0wKp5y3rM1++6A
Date: Mon, 3 Feb 2025 16:49:59 +0000
Message-ID: <f7bf999c-b3a5-47e3-ba77-483039656302@nvidia.com>
References: <20250103073417.459715-1-hch@lst.de>
 <20250103073417.459715-2-hch@lst.de>
In-Reply-To: <20250103073417.459715-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MN0PR12MB5738:EE_
x-ms-office365-filtering-correlation-id: 9fab7710-de0a-4b79-50c0-08dd4472cc29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?a3FyeW91MzgvY3BDcTdoeXZFZEtycG83MHBMSE00S3I1S1d0eEdGT05yZmlJ?=
 =?utf-8?B?TmpSTkE5MVBxNFRkTmF5Mjk1a2tjU0Rqd2NFeU1XYVdjcUJ3Qi9aQ1dYMll3?=
 =?utf-8?B?VU50RTdDTmhweW52cnBlWEQ2QytzV3NJaG9UZGM3bk5ueVRMaVNuU1h6a1dr?=
 =?utf-8?B?d1kwNGN2Qk5oTGdlL0RVcERyUFRDSmR2cnErbk1vTFFrQ0o3Znk3S2lBRm9x?=
 =?utf-8?B?MFlDNDc1V2lYRFVFTTdHNGhETHVPbWJTdWphUVVYQVp1Z1lwcXgzbUtrclhp?=
 =?utf-8?B?WVdMSWh1WHNFemV4NnZ0NlAwanNMWEJ2ZVB3a3ViejY2MDVDSGFQbGd2bHVP?=
 =?utf-8?B?RnNDczdtSU01cDZMQnIvMjNCMW8vdlZ2MVFTaVM0cnh6NjRrUTVXb2Y1UURl?=
 =?utf-8?B?VFptSStrOHFhQ0tDV3E2TGdHZC9WVzd1Q0JCUmppWmZCY3RuNWorVERlblBa?=
 =?utf-8?B?dHp3UlhnbFhEcjlQQjExckt1MjZTSXJoMW5mTVZjSjJTTUZkNEYrUm9Vdzdq?=
 =?utf-8?B?K0lhOVhYQllSYUlEK3ZnQU1YbkJnV0d2SllCOHdpTitXeDFqY2JiTE9SL1dm?=
 =?utf-8?B?ZUFubitJM1h3V0M5TVhRMlVocFhqaHBBVGZZYU1kRjJ3RlRLVHJrUGo0eXJZ?=
 =?utf-8?B?THF5ektlakZGaENXeUxoNHllT3FCN2xLT25RZWJFVzRQOFloUjJuY0dET3Ra?=
 =?utf-8?B?cTVsYXkrR0FNY3ZtSkZRSnczZnZBcTNXVmdKS3E5ZU9kaUk5L056ejFJNkQw?=
 =?utf-8?B?VU1yUzlqYXcvcDVMd01HYnN3SldCK0l3dk9QbmFVL056bTdBMTZvb2lyYU80?=
 =?utf-8?B?ZlM2dS8wV0RsTytoS0pkK0JJQjFyVHpaUTM5MEE2UnJ2U0UwUEx1UFNYZGc0?=
 =?utf-8?B?RnRzUlY3MGkyeURiVkV4N3hKMXhZTWJNUkpRc2xuYjlsOWJDdVl1dTRwU2tV?=
 =?utf-8?B?RnZ5R0x6SlB2MUkwNVBRUmtBbGV6QW9qcDFXYk15RmZsMTVuWjVVRjBpemNv?=
 =?utf-8?B?alc4a3liSndnQnZLR1NyWGF6MTdGcy9IVVBqK2FvazY5dktIaGtPeXNhcGFn?=
 =?utf-8?B?SzF1Y0xWaTNhU3h3ZDMxNmVLdVhhamFzU0EyTjJwT1UxMkVDVG9iTzBEUllp?=
 =?utf-8?B?ZlpXV3RnT3BQeUljMzBHVWtjSTMydzFpQ3VOaXg4VFR2VUZXQkRWVnBRWFpH?=
 =?utf-8?B?c0c5bERGM1pYQXc5blJDMFh4VG00a2JYcW0wNUxXb2Rza3ZJZHNSMnVLblFy?=
 =?utf-8?B?UnEzeFArSmVCZU1SNUlWNWFmS3JTeVJNYlZ1WVdZbEgrbEN1MnlDM2llcTRF?=
 =?utf-8?B?UVhnb0dHWHp3bnoxcG94VTJLQmdmdjZxajQyRUNOZnhHS1hWQ0N4QWg3WHpU?=
 =?utf-8?B?d2ZUZ1dGQ2llSDhmYjFxYk9KZytPVGdkSG1acU5hKzZsVlRyL3diaU9VdDVj?=
 =?utf-8?B?RGh0Ky9MM3RvNEJpL1p1MGZCNzM4MDFXY0pYVFBkMGxqTHpGNkRYZnlyaGVp?=
 =?utf-8?B?SUsxVE5McmlQVVBXREl3ZktpZCtqamhvVGEvZlMrQ0YzaGRMWjlSdHVTYUpp?=
 =?utf-8?B?bHUxU0l4WEwzd1J2V0htT1pJNDJjUFhVSGhhODd6MG1EL0tKa0E1TmhmU203?=
 =?utf-8?B?UXJmc0hqcHJDN3JZT2RkaWZlb1pVamRaWWJ2NnZkdTM3alFqbDdRWHFMZjJT?=
 =?utf-8?B?T3JZeklxM3Nad3dzdFJaMWRMMEpCVmNRcSsvRHJZR2FmR2l2S1NoN3llS29U?=
 =?utf-8?B?K2Mrd2x2eU1lUGxZQWpLZU1veks3MEtBdjdEM2gvRmVmQmlVTVJVQjZ1Vlpx?=
 =?utf-8?B?eHhpYzlLRkJxU28vUXQxYVdUTFgrNkdpNGNIWUk1WHpXQzUrOVJpd0Z6aERp?=
 =?utf-8?B?ZjJjc2ZKVGZ1OFVFMTJiNDBzekprTURhbmJkNmprOGFMelJ0ZHFBcmtLbHAx?=
 =?utf-8?Q?cbv29bAf4XCSuXF+NeviqKKifd6vhOVd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ckdOSjBpTXJ0KytleXVhOXpiS0hGRkRBeGI2VDA2eldKeUsrdFlWZzhicFd4?=
 =?utf-8?B?bFFqT2t2QXpObmpraVJGTkNIUVlPd1NEa2tOQUNzalh6UXVwYmFhY0pXTFVx?=
 =?utf-8?B?NE1VRFk2T1hOb0FZcERpeVUvNk5nd0xHQ0s3T0NWZ1BERy9Sa3kraTE5TkFu?=
 =?utf-8?B?WVJoQjZneWh6cGR4aTAzaHdGdFA0d0VMaVJoOHBBUlpZOVZnajhvek5aa2V4?=
 =?utf-8?B?MEZuV3oydTJDMmZYS2hlOWh3WDVRcUpSK2FjcFlpVXVHTzc3SUlFbTBkZGs0?=
 =?utf-8?B?Q09jV2U4dmhpMWo1VGZYeHhJZ09Xa0RyREVSN29Db3VFM08zbkxNTUM3YWxZ?=
 =?utf-8?B?NEw4Z1J0RmlRZk9tdmNDczZWaHhyK1RLeS8rd3gveXBiQzlHZHVKaGdubE5s?=
 =?utf-8?B?RU1JRE9vd0pXOUQyc291cFRsUEJwQW9SRW5USklZOHJSZ2hxenM4VkN1cm8y?=
 =?utf-8?B?Tm41N2xnUjlYUnhnQjFjanJlUzUrSjZRaHQzdVlQZ1hwalJ5WnJONlNVaEFZ?=
 =?utf-8?B?Wml6TU5QemtjSFJFYjBYUXc2TGNrSHBEWUp3alR0VTlxakpLaC9hck5OQ3dh?=
 =?utf-8?B?enRZMS9ETTNqVENrRU8zWHpMem1LcUNTd1M4MWxFQUo0S2Y1NUxMbmZwVi9o?=
 =?utf-8?B?QVRZQTF5Y0hzMkVQWG9ZMTNtYjdhMXV5enBZRE1YZHVHQ3BQUmI0Si9JcE5m?=
 =?utf-8?B?L084MTlpRVJ6eXkvQmh6N1h1VkdNeFB2WWJnOWFNRXR3ZTBpV1NIWXJuM3gz?=
 =?utf-8?B?Q1JYZFVReHhFQ1dUOGxndUpyQmJyS1U0cGlRRHMzNVdNVnJGRmlNaWl2dVVQ?=
 =?utf-8?B?R01GNUlPdU1KWXMwZ3FaKzJtdytINlhmQVd5YkFlS0xvdm8xQm5XQXlDeHFw?=
 =?utf-8?B?V0xmR0k4NzA3OGc0TFpJSGZ5RXZnSjhyL05TcURvNTFJWDdCN1lVUFZmTCto?=
 =?utf-8?B?eFNyeS9OOVVwbUM3dHpmeDBLczh5VytBbWVPYk9LR3ZpOWlZVTZCcVNKdVp6?=
 =?utf-8?B?SVNUdjh3dkh4YkU3M3JNS1FNQ3BLMXEvbUtHckdUOEduSlFaaDhsbStEcXU4?=
 =?utf-8?B?N2JZWWZHR1BMZlAvUEpRVnh0V1Jaemw2dTBTbnNvaGllUjdxNzVQK3daUEZI?=
 =?utf-8?B?dkxlUEhFbGc2cWRTYXFtbmpUNGE4TjBTRDBPbzJ0Z0pkM05YSDN6U2lORzY1?=
 =?utf-8?B?RUhDSm1SeEYzdWF2MVptYXpzYTl6dnNWWnh0WG52UnU2am95QWMwbG51NWQ3?=
 =?utf-8?B?NURFNVVOQ3pYSmtKUk1sSGpUUUdRTjdTTFltdmZ6NjlXVVNjOXpNRUlwVWZH?=
 =?utf-8?B?U2lSNU44VWVsUGtrRmFUYk5PRVIwckVvdCszeTNnMzF6cVNpVGRRUHcwYVZx?=
 =?utf-8?B?UHRudjZLa0JPTURoZ1RVR2htVlFUVWpjODV2cVZ5Ni9rbU9RUnU2THpTeHYz?=
 =?utf-8?B?T1Z3a0lObmNVWXFBWGx1VU5ITFFYd3RYdlRBb1FmV2hjZCsvVnJDNGJsUjJ4?=
 =?utf-8?B?QjZOMkMrOGNQMG52U0h1dWlBSVd5RkUwdkZTQ29ZRDV6SFZHODliM1BoSnYr?=
 =?utf-8?B?eklvcmhkRm8weHZqMEhzQmI1ZTJxaGtiUmFPOG5XTGpFSWJ3Y2tSZHBCekRK?=
 =?utf-8?B?dFp1MzhqR3RobFBVbHI3NkNvdVU5ME0wdXBJRHcycjVkRy82M2dreWlrSTdY?=
 =?utf-8?B?VnozOUM2cFdDQmNXVWZlSlRhMDhYSWRtYlEzdkVLaThhWERRbVFXT3NYL0Nm?=
 =?utf-8?B?ZWRqRndqTHZVOXFJZzgwaVpIY1B2MERuSHNMeml6eG40OHBXamp5NHptSTdl?=
 =?utf-8?B?UU9Td2pEa213VEJaR0tXOUpyeDlXME1zY1I0bkxTdG5lL2E3WDFuc1lZZHZS?=
 =?utf-8?B?RmlPdEMwV24rVDBGQm0wMFBpTVIwVnI1VGNnamsra3ZwcGpBV0Y1MjJiQVhw?=
 =?utf-8?B?TlB6M1pvOTc0VVBuc2FDTzZCaHphQUJ4MkpMUHZkMWNla1lnK0R4TjBEVUhU?=
 =?utf-8?B?Wm0yeFMyTTlrd24ra2oyRHg5U2l4dS85cnNaeW5XZXJzV1ZpenhNZFoyalph?=
 =?utf-8?B?TytPaUtDdjhzczg1M2o4WG4zS1FMVW1YeTVLWkxRcnJhWFRYbm5RK3FjdnRr?=
 =?utf-8?B?UjlHYnhveDR3SnEvN3BUS0lvMmo3TThVNFlOZG9wcWp5RXl0ekVjVmhIVHRO?=
 =?utf-8?Q?Ole/S/AOJJBwTmuopuHUDcDfRIAOj+SyDKbY8ukf0D7C?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1B5C148E56C214F93828182D05781E1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fab7710-de0a-4b79-50c0-08dd4472cc29
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2025 16:49:59.8191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kClpQ2BjSx8kA6ypclz5E+CRhFBzeTB8YZudIIH0jPWDeSDGTek5Y+fjnXEaKk+ZLJ27RXq4K8FKHjy6yQndEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5738

T24gMS8yLzI1IDIzOjMzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gTGlmdCBiaW9fc3Bs
aXRfcndfYXQgaW50byBibGtfcnFfYXBwZW5kX2JpbyBzbyB0aGF0IGl0IHZhbGlkYXRlcyB0aGUN
Cj4gaGFyZHdhcmUgbGltaXRzLiAgV2l0aCB0aGlzIGFsbCBwYXNzdGhyb3VnaCBjYWxsZXJzIGNh
biBzaW1wbHkgYWRkDQo+IGJpb19hZGRfcGFnZSB0byBidWlsZCB0aGUgYmlvIGFuZCBkZWxheSBj
aGVja2luZyBmb3IgZXhjZWVkaW5nIG9mIGxpbWl0cw0KPiB0byB0aGlzIHBvaW50IGluc3RlYWQg
b2YgZG9pbmcgaXQgZm9yIGVhY2ggcGFnZS4NCj4NCj4gV2hpbGUgdGhpcyBsb29rcyBsaWtlIGFk
ZGluZyBhIG5ldyBleHBlbnNpdmUgbG9vcCBvdmVyIGFsbCBiaW9fdmVjcywNCj4gYmxrX3JxX2Fw
cGVuZF9iaW8gaXMgYWxyZWFkeSBkb2luZyB0aGF0IGp1c3QgdG8gY291bnRlciB0aGUgbnVtYmVy
IG9mDQo+IHNlZ21lbnRzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxo
Y2hAbHN0LmRlPg0KDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vs
a2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
