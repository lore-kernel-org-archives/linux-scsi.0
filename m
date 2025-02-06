Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A42248AA;
	Thu,  6 Feb 2025 06:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738821671; cv=fail; b=UK3+a8vfBgYyFLWq9GaDCSDYfG6snuUSCXjcofbwXqiFDJ673qgtw65xyffMhVk2JAbmuwl3ECz01XAiYJK6HXJea/yXe49i2bgViXxFc1ttn9QoIetRKshj1rwthGzcrnpzKYKzJE+kEGe4WTcozgfAQWmJO6PeuR+MRvBsrx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738821671; c=relaxed/simple;
	bh=tACAkOWebQoTz3FYB6wwQYiU8WQtgkKuBGC8mo4g3ps=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UKzmpeinkMa0CfHCa/Tt8zS3G3o3tC40OXCVdB9tJrHCo3BUMesgbRyRxlREtkjeuVNzaCbAs7CFgUQJ2/C9fQxvKj0fUbw8J0vPbk1Bh27dd56Jo0zruToHln/hvf+2G96kRH2iI2R+6BlOxQwITPJK14ERmGa/a4kfLFqMZfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bc8rveIo; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bc8rveIo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DFoaHg40w5kxNKOLEE0vaen9br3eXrGbx56mOYk6NRxrizewDlx+LjTVdFFyIjn/tE/LghI1kOhBgMS1BNoltvTf80Z6omSvB+1j43oB2ddobVUXNhXeyIlb2J+EUsgr10OoGiYNNnJnkHMpWEZ8jxQ2sacsxdRI5XcNZD01MT3DxA8NVCqoah1rgtDHCw1/8Y+r5IlHYsNwRS3xwXyZM5QAfbU6yGsD9czDc6r1mJZf/PG/IISPCq49yOJvDRUM+1t4LH/30LqurL2K8tIrKZgVjwXZ1Mr+PilZ9xnkj2Yg/jM+qqu3uLZo1JkLK9fPFtjtvu0rx5SKgyR5PmWXJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tACAkOWebQoTz3FYB6wwQYiU8WQtgkKuBGC8mo4g3ps=;
 b=j2DplKKHyJFlskEwNiMDq2ZPb06qeUTGPzJ6eqC91d2me2Dq5d4M3Vc9nFsQmV/3A1/vpxcA5Nt/foPRVLTClFwr+ZkSF6ItivMoGP6zw419D5gZN2RKWYlzl1kkNPrdnmbW5RYjgRcVZNcu7iVaVrfznYV4X5xh1DJZBauDxGrBn8dnyoOnF6diaanL/jaadJOfai0eRhyEGhkiTMSzu5jucIBvx8C2NAc8N13lU9vLUlHgZCdA56jsUbdIJzV1MEYaGuIKh2Lj0mGym9mdRbT4A3NVE1TxuU5VMdwwX+mVDIN4JGxC9elyOQ4cuLr1RtYz0jQAUnQY+VsAKlk/kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tACAkOWebQoTz3FYB6wwQYiU8WQtgkKuBGC8mo4g3ps=;
 b=Bc8rveIo6/lzcEUVSu8mQrLll1+HbWVdRzDUkL3v6nMkDyuKhNDEdrtGpL9x8kfyUuhGViEErrrjFnP0pB7AtfcDP1pX+jj/tVB1t95uy3WO4N7H9iS7/wTpBtRlCUJcd9pLmQbiAsZLGeCh6rBZOZyl14FSqGL+G/Lmno+ZCDiHqmJSFDpwh8STmLHwF6eV6LNibVA1wyPIxXIt2j8dIIeZIQvnbs6BzwQlkZStLcfcX2WVZFAAEfj12HuEsQ9W4kKziSy5k4zrx00oXs0pdSIHlJW9tQYx2SHh4RO9N1u0SRaLz5K35sDrxoPGPUPrhGeX0IfVZo+D508TNdrtxw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SA3PR12MB7805.namprd12.prod.outlook.com (2603:10b6:806:319::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 06:01:04 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8398.021; Thu, 6 Feb 2025
 06:01:04 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Alan Adamson <alan.adamson@oracle.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 blktests 2/2] nvme/059: add atomic write tests
Thread-Topic: [PATCH v3 blktests 2/2] nvme/059: add atomic write tests
Thread-Index: AQHbeCIVoaC7aZ5ggEWh2e99iD8tWLM5yL4A
Date: Thu, 6 Feb 2025 06:01:04 +0000
Message-ID: <996a7acd-4cd3-416f-a374-659e09b58cf5@nvidia.com>
References: <20250205231100.391005-1-alan.adamson@oracle.com>
 <20250205231100.391005-3-alan.adamson@oracle.com>
In-Reply-To: <20250205231100.391005-3-alan.adamson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SA3PR12MB7805:EE_
x-ms-office365-filtering-correlation-id: e72e8027-2f41-4f3b-8635-08dd4673a44e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d05rbG1id1BZbHhFNng3NkFZaE5lNlRpRTh2akQzV0xxVTFxUUc5R3NiMUli?=
 =?utf-8?B?cnAxbGIvVENtN2JwWHZmTy9MZGJyR2NQRUNLdGdjdmFhbGlmYTVXdEpZUWoy?=
 =?utf-8?B?aWMvK04rbXEyYmRSdVkvMVREWWs3NVBMbHljNVB6WmkvRHJYZTUyR043YmJ5?=
 =?utf-8?B?T09OQVBnQkhqSHkvbzlCVGovTkxmY24zYjl2WEY4MTMwT0tNUnVXRWY2NTdx?=
 =?utf-8?B?UTJtVThtc0FMdkRvTjRNc1EzRjVhdjhwSC9GQzhoVWxFV1kzVXVaN0s4djAx?=
 =?utf-8?B?YjZrMHY4WTNsck0vd1hFRDRDNUhORzQwYmxJaVR5aFZxUkZFMmRYMnRXU2NY?=
 =?utf-8?B?QVJGbEpoNFVZOEdsQi9heVg2aVpvS0ZsWmpUVUN2N050RUVwMFVXWHJvMTF6?=
 =?utf-8?B?VGxwMW43WUw2N2VkR3FuUXZRUjRaR3BwV2F2L1U0YjdKZlpESXZIVFE2UHVl?=
 =?utf-8?B?VFJiOU9WK0dnWVVzaW5tMkovSTd3cExlclBPTlIwNjBYWm55aWxUODNqVW9N?=
 =?utf-8?B?L21jVC9YTk5MWEVob0ZneUtjR1JqS1hiNlIraVVyUnc1NW9GQTNidWhrYnlm?=
 =?utf-8?B?MUJsS2xyekQ5a2dZTnpSV215MklySWdhZVN1ZVluaFgrOXFxZGpIUC9sd0F0?=
 =?utf-8?B?TFV3ODk5MHgzT0RoYmhmUjZ3SndQRnpBWktKK0J4WHpNQlMyVlV6R1VWSzhx?=
 =?utf-8?B?dUxkdGpmY0RiTldpZUgyZldMaDNZV1dhcHVxanQyb2E0N2QwaGIwSXFocWhO?=
 =?utf-8?B?ait5eUxHbnBwVzhvamw4RnIrdzhRdjRQZnJHMDNMNUViMk5xVktTREIxSkMw?=
 =?utf-8?B?bXNDNVZsUTVndEZDaXhQQ1N0MUVoTXI1YnRJb0xyZVBQN3B0SksrenhSSlJv?=
 =?utf-8?B?bTEzSUZEWUpQMG5lam9ybjM2RWZIc3dJWEJZODIvNGdwY3BxZlU0TW5OY2xw?=
 =?utf-8?B?K3BPcTZTQytrY3NxeE9ocVp1Y0htZ1RGNERXcy9ORUVJbVB5NlBsMGVtVEhz?=
 =?utf-8?B?c3JMVWdOajJnRUtlcUwrWkYvaUlQNlRMZldXK3ZpZ1U5YUVnR2ltdXdaNHpM?=
 =?utf-8?B?RVlIckZYWXpuMFc5YXNSdjdQWjdMeWl4dUIyOVJKTDVJKzhZUURXd0wrYmdD?=
 =?utf-8?B?K042T05ESWMrdHRkeE5oRUl0M1h2U3UxYWN0eDZsYXh1TXVhcnhwOEhLRlFL?=
 =?utf-8?B?L2d0c3pzaTdsd0NRREFiUzZib1MzUlN0ZS9BVEVyTnF3ck1kcGFQS2RCbFd0?=
 =?utf-8?B?NnQveFBuV2xlUjFJL1IxaWhROVRRSE5jcHZISWtyUnJaUEtEZHg0TXBES0lE?=
 =?utf-8?B?N1Z1TFlvaGNydmVuT2FvSEJLeUNITGlVaHBEU0JvYUkwOFNUOVl0bXJ5NmVB?=
 =?utf-8?B?aGQ3Y2wzdFVselNJN3ErTmQxYjR5ejY0L05DMGFxaENtdjhzV2xHdWNxL0pT?=
 =?utf-8?B?cUw1MWZGMm4wN1ZtbEtLTmY1VTVaTFhVcG1PRWNQZWFDQ0Nwa1NOMXFzK20x?=
 =?utf-8?B?L1JTYS9vdG5VY2duVzJrdEtNeGpKQ2ZOaDNJTVowVXFEVFdTZlRpcURJalln?=
 =?utf-8?B?djIyUmEzYWlYMzNOemx4YjMyWDZsd216ZmF0dmtxT3hBUHFaaXd2dTR3ZWhO?=
 =?utf-8?B?UTRFS1V5VnZIbzRyK1phWmJBVTBiMVZ4Yk5paXUyK1g0WTI2Y3J2VlhaOFNq?=
 =?utf-8?B?eDJMeUZOT2tTM1lXbCt0OHR1TytXcThBQ0xiSUtjVjA2Sm1abmFUb2svWEVY?=
 =?utf-8?B?QjVkQjVqRnY3K1NPMzlmSkd5dFFFa0xFWDhZTUE1bkNWTnhPaUI4YVlqcGs1?=
 =?utf-8?B?TVpXMDJvUjBuenFGOVlrRmpJUXVrbzVmczA3ei8wRGJLZWxRZjd0alhuVURU?=
 =?utf-8?B?UlZQNGMwSTd0M2s2bFFVRTIzQTRKcVBVWHhySzZRd3NjbHFOMGNiUktJRXdr?=
 =?utf-8?Q?ITQMYHwVJwQ0jw7TURFywmr98p0xrLGX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RXRJeWErRjdndTNoUE1lODR5RGpFREJLYXp2NmduZENpNHpVekI3SnNNTzBm?=
 =?utf-8?B?eHk5SVhEb1BKd2xHQkNrbFlQb3Q3VmdidzhrZ3ZkL3VxUXRWV0FHaTVROTFD?=
 =?utf-8?B?NGZXbGxIWUx3VGV2dFVDaTR0b2J1bzlPbUtjZHpNcHcvbmNlbEIyRit4MGNv?=
 =?utf-8?B?QU5SdE9Od3lneXJwcnp6U2w3MVhuWDJudC9KNVpUQ1IyaGpLNUhYdmdTd1My?=
 =?utf-8?B?SXV1OGxKR1dRQytFY3VnY2xmNnh4V1h2SW5XMURIZGorbnRqcVlIamZyZjI2?=
 =?utf-8?B?UnIvc3F2U3Nsazc2MlgwVjRJL1F3ekF5ZEtoUUxGTkJjZDJYazBnbFVMQjdZ?=
 =?utf-8?B?ZHlWTU4rOW5JbHBXak82aE1rclhqRjB0aDRaaEZlcG1yeWhuVXlRRnlNSjd0?=
 =?utf-8?B?SW5qYXJSbndXVEducVp3QWhXRi8rZ0xlTEU3cmlJKzJGcWJtdXkxMlZ5dC94?=
 =?utf-8?B?d090bCtSaXdYaFd2OHhDdE80UWZDZkFIWXlpM3czU3pDOVIvU0dBT3lRMHhI?=
 =?utf-8?B?YmN3SmtzQ3c0RldBT1h2V1RVME45TXNtWkRRSUtwSWhvd0FkMUcwdktGa2to?=
 =?utf-8?B?b0ZoeDA5Yk9hMWUzamVDaHROaFh6a3BESGNwRmNlT2JlUStETTc0akMyL1Nm?=
 =?utf-8?B?NTdCb1ZGT1JyeXd0WldsZ2RCQ3NRQWQ0NlVlTmZoL09wN0sxNTZKSjhDK3ls?=
 =?utf-8?B?Q2pJYlBwUHJaY2I3K0xPM1RySTlHcFQ0cUlnZ0FUbzA2ZlkxeEhuMlNwVTBq?=
 =?utf-8?B?TlRJNGY5citPZUdMcmlsdFBWRitTTnRtR3FJN1h0eTJYWkRwaWJCUEpMenZT?=
 =?utf-8?B?MlNIbG40M2cwdTBsS09TcU8yZXBKSlZVT3FtbDB4WGM4MUc1d3M0T0UreDhp?=
 =?utf-8?B?OFJ6UytjcmgvTUhHSFFvZHRINWNUQjcwOFhKYWVxZEt5QUJ2T3NvZFA4MWRH?=
 =?utf-8?B?V0ZHWmZJMjF3NWlBNnNhRi95SEFYNVpRRERLVlppUkFUcW4yZ2l3T2o4WWZJ?=
 =?utf-8?B?eGJhblJlaHJzeU9NTjEvKzgwaFVNWWlPdmNGMkV3WStYYVA0Tjc2S2JxYWx0?=
 =?utf-8?B?SFc2MTVlTkVaVGh1alZMOEFHazZiWmt0VExtb0Eyb0VvS2FKY0psMmJMMDc1?=
 =?utf-8?B?WTNOaU5LcDNWeTZJRHF6OXlVOXN0WFlYRmNNamo5MmtLQVRpTUxLTjN5UHcr?=
 =?utf-8?B?TGRVMm9zSzRqTWVYTmpwZXRBSmFuSWRrQktqK2tFV2pXOWsxd3RNWUtFVVNG?=
 =?utf-8?B?UU1UY2dBWmgvSDBDSGJBN3FyaXNqTXlCNjZUdWtnSTRwbE9KMlQwSEVZRmVS?=
 =?utf-8?B?WHpkQXkyVDlSUDY3MFBnUUc0SkpuWHQ1R1VYZ1RmZFFZMzBlZGFvYkMxWlNr?=
 =?utf-8?B?VElLRVpwVlN4VDVaeVZpZHAvMWNCdW1hSnBnRnZBaFA2SWxQR0lRSTQrRmdo?=
 =?utf-8?B?ZzRNVmdEelJIYy9lUGVHNld5MzNtWG9reC8xSFVKR2l4NnZwUk9SQXJiYVlY?=
 =?utf-8?B?cGZlY0VpRmlwUmdmQ3lIWnZFN2ppeVBURU5idjA2TTBIc2VGUlZFeFppRmRq?=
 =?utf-8?B?dXlWOFlJYXI4MEI2ei90UTBrbnR2ckh0T2laS3RZV2wzMnk0aEhRQWxXV0ZX?=
 =?utf-8?B?a1RKUlJxYXBNenJobERscXdScHNnOTh0c0hKVlZYNlVqbG1UQkJlbCswOW5k?=
 =?utf-8?B?RkZVamVHbFZ2c0F0ekZFdm95OHJFVGRZcVlhUC9yQ3RuTEgrZWR2MytZNUth?=
 =?utf-8?B?eGV1ekczdlR6cjhVcm56a2tQQjF6cDR3aU5nNVpVV3hnMnVma0t1MmJmUC9j?=
 =?utf-8?B?Z2ZhSHhadlVKRmxTd0lSbVFsYjkzclgxUXErRFVPcTRlNk1kU0hHTkowbWRB?=
 =?utf-8?B?SVNtaGl0OTF4amVkWUE4RElHTkNvSVdGakJoNGtwWG1uN0xTWHBuUkloUDRM?=
 =?utf-8?B?MzlIL2hkMHR1b0ttUk9QL1FOeGRzeGlPY1Fici83c01WUnBSS2htZnF0dmFj?=
 =?utf-8?B?YlgyV0NnWERFMWZKa3V6dFNKTm1BZG56S05oak90TU1MTkZ2Y2V6cTBxNUNU?=
 =?utf-8?B?bm51bUtnYVlQWGUzTExvdzJzT3BrdUNmRGMrdk5xSGQrTDlrVURYaTdBeGNM?=
 =?utf-8?B?S3NUV01obDBMTkNBSTRQQ1JWdVFxZ3IrS0NPNE1kOE9mcTdhbEY4RXBmUW5r?=
 =?utf-8?Q?8wPgU96JggXetrPB4ZoyDBGvpcImNFJEMv77HzbRvjSV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C16309359B32914F86A07FC5A770E4B0@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e72e8027-2f41-4f3b-8635-08dd4673a44e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2025 06:01:04.7957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J66cyb6p3+rxHZysP2RCI0a6TCHYY34Vm93pi7h/U0xv9DVyBAlj0iaANUTCkAISFyUjgsQFR9Kx84fZmeeamw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7805

T24gMi81LzI1IDE1OjExLCBBbGFuIEFkYW1zb24gd3JvdGU6DQo+IFRlc3RzIGJhc2ljIGF0b21p
YyB3cml0ZSBmdW5jdGlvbmFsaXR5IHVzaW5nIE5WTWUgZGV2aWNlcw0KPiB0aGF0IHN1cHBvcnQg
dGhlIEFXVU4gYW5kIEFXVVBGIENvbnRyb2xsZXIgQXRvbWljIFBhcmFtZXRlcnMNCj4gYW5kIE5B
V1VOIGFuZCBOQVdVUEYgTmFtZXNwYWNlIEF0b21pYyBQYXJhbWV0ZXJzLg0KPg0KPiBUZXN0aW5n
IGFyZWFzIGluY2x1ZGU6DQo+DQo+IC0gVmVyaWZ5IHN5c2ZzIGF0b21pYyB3cml0ZSBhdHRyaWJ1
dGVzIGFyZSBjb25zaXN0ZW50IHdpdGgNCj4gICAgYXRvbWljIHdyaXRlIGNhcGFibGl0aWVzIGFk
dmVydGlzZWQgYnkgdGhlIE5WTWUgSFcuDQo+DQo+IC0gVmVyaWZ5IHRoZSBhdG9taWMgd3JpdGUg
cGFyYW10ZXJzIG9mIHN0YXR4IGFyZSBjb3JyZWN0IHVzaW5nDQo+ICAgIHhmc19pby4NCj4NCj4g
LSBQZXJmb3JtIGEgcHdyaXRldjIoKSAod2l0aCBhbmQgd2l0aG91dCBSV0ZfQVRPTUlDIGZsYWcp
IHVzaW5nDQo+ICAgIHhmc19pbzoNCj4gICAgICAtIG1heGltdW0gYnl0ZSBzaXplIChhdG9taWNf
d3JpdGVfdW5pdF9tYXhfYnl0ZXMpDQo+ICAgICAgLSBhIHdyaXRlIGxhcmdlciB0aGFuIGF0b21p
Y193cml0ZV91bml0X21heF9ieXRlcw0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGFuIEFkYW1zb248
YWxhbi5hZGFtc29uQG9yYWNsZS5jb20+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBD
aGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
