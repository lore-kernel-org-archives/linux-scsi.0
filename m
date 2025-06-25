Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F991367
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 04:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826004; cv=fail; b=ASow+Ag/aD29JXMsKqRDC4dqOrIEDIWDjdAg2RH9vaULuGf7rpUACYxi6oRwsL3d6Yw6zcxEEFsBzwipOVNy8JaLjd9L6K26pObi3XH2JX2aMIP85cnLn/odIL8r9ag+dlB68c5Lv4KC62Al6IeuWWAOSIm0O59mYehBOhwR/hA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826004; c=relaxed/simple;
	bh=9yaHo/iUYe1f5M10w7nok1RQeeuYCdrrOt4kOekwBG8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XTdpdDyhdQIwGgW+LTFczCRnvRVDHGBlDQYG38q5GMFKgzERV+FvaM0bXV7TS1o1ng/EQnxnuMm3RjIgMnNwmJJLzOCiuwzVg65wnCWNJ3CiTPAXy0l73ggWywoN4lAHZkhdmE+3h2GVniZNbVVODXUqwC4sYNnF7K5SyPz33dE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TgIP2nbP; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TgIP2nbP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbPjW+pIbBqXU38dkAXUA2m9CvV5GzWyylwcXfrM0TJGXokmn1Y8IZni7pJ6AzBsTO8PavMRQW6A+Or9Z2YS0lxLkYfIz5cEVKiX8vZy5x5WvH/dGfbjxnrYX/bdfW/zIquOaD6FKNwzgm+GbW1z+4J3kbUt7YMcP4Qz+mGHHKdLH5edQWKMcveCd7fsvwGdLSh1/t5WuRh9TmbaODMano5ckaU/umeNs5DhWYPQIMcsgYAjJ86dsqmRUcuXQQsoCMnTlZJG8jf02EAWarvaoPomDTTG/uQQVc8ugp7v9im1cG//8AdCwKMM7e3272ewR/emkkHNmq651eABjZ6qJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yaHo/iUYe1f5M10w7nok1RQeeuYCdrrOt4kOekwBG8=;
 b=SipYzSHTsVQSdUl2bl77Qjw0cjyI2pUAhZPyJJZ/shgdfWRuEMeLNa0K3KFstZBcXBOS2xLsZbOLcnDQn2sv+6eZ0ggr6jKkphadj/eP8mUFNGK/HoDqnthLQ2RK3TQt4ze5BmQrZEM/I0IGXLv/CNILNAnyRNklC5HCHEmiR6hICLXXbuD7BuDC8LPMl/pOzD/HrqjD+DdCZa+rR+8+SNguOp1zxi1wn1yOVEIVDDiaHrYOk9dCMhtcc8QZ852ynPQUGe8d3ARG13p9zeX/mxHiGtEzSUaVrf631z7iwmOF4EWVdMVXcjipAvXlr4Hhkml8oyIp80jzFqw7ryBrug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yaHo/iUYe1f5M10w7nok1RQeeuYCdrrOt4kOekwBG8=;
 b=TgIP2nbPKLT31u1naGcIAOkgDJ5cfzHF61s5eGtuhwDVR2mPKnQCM+vfb7wPaTp2exo4O+pJoDZNsgUwsjeUkm6UgNjdMDnvzmcxboNL7XS6nLggwYjfNak89k7ftXUVY00L1FBNUs4Dpd04GKmTyFGBdLbbQNoBxFgm3zWzKMnbqB0y3gOTKNPGFJ9Ea2cKkxoFgJpUPGh5A7BIh5rccLDuzOEFTRbomlr1C8r897Uf/Piaex/JEfE6K2n0eFfL0ZM9iJ2KLpC6xr34LqYsLqYYhbAjQkOIfnyxHGxMxEnq3yu1i8q7/gYbhtYe9avmt8z10PPyh2EHe/YSSMUemg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 04:33:19 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 04:33:19 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Bryan Gurney <bgurney@redhat.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
	"hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"axboe@kernel.dk" <axboe@kernel.dk>
CC: "james.smart@broadcom.com" <james.smart@broadcom.com>,
	"dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>,
	"njavali@marvell.com" <njavali@marvell.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>,
	"jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v6 6/6] nvme: sysfs: emit the marginal path state in
 show_state()
Thread-Topic: [PATCH v6 6/6] nvme: sysfs: emit the marginal path state in
 show_state()
Thread-Index: AQHb4gz93VqFWvKgqU+pbrqCSK5mUbQTUHOA
Date: Wed, 25 Jun 2025 04:33:19 +0000
Message-ID: <41780682-5853-40d4-9e6c-814475ef2a22@nvidia.com>
References: <20250620175820.34795-1-bgurney@redhat.com>
In-Reply-To: <20250620175820.34795-1-bgurney@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB7743:EE_
x-ms-office365-filtering-correlation-id: 7b67ee98-d6db-4a71-03fb-08ddb3a16973
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d0FuZEdkaVBDY1d5NFJFdGFNNFYrNkFwaWlkM1ZTcnFXV2RXNlBqeWJjRUV4?=
 =?utf-8?B?d2U4QnRHaHdlUTQxNnJnOXpwWHlwb09WTW9SMGw1RHM2bkFwK3JyNmZQTjR0?=
 =?utf-8?B?TFZLQlZEcW1lNEgwS0RXb2FTRlZCdC8zVGM3ejBRR21uUlB1VjB6OXg5aUxQ?=
 =?utf-8?B?VWJnSHFEbERDSjFSSzV0TDVPbW1NRzdUTlVna0RPVWtNQWMrVTgyMitaL3Vq?=
 =?utf-8?B?c3NpWnFiN2N4bkNyU3RGTXVHVjE2QmY3WVQyTnA3MnNkRldUMkRBbnhmci9r?=
 =?utf-8?B?UWZmMDdCc2Ywdm0xSkN2dHJTSEprbjBRYmlua0ovNlllaUNpVlRpb1VKZmZL?=
 =?utf-8?B?N1ZTSE5TY2VaNnlZU0hMNVdHWVd1WVE5VWlUN0t3M2dKLzZwUkdxeXN0V0tm?=
 =?utf-8?B?d3VKbkFnMmVOLzM1THBTVUR6L3ZtNVhPcEhJajRNRVhxdHBrcVZwMW5nZko4?=
 =?utf-8?B?a2pVZmlTTnNscWgxcTlwVWFxVGVPRXVCZFo1N1JhdE9LUERkWEJRaGdwaWI2?=
 =?utf-8?B?R01YdHZ1RjM2SFlTUmF2b0NLVE0yTDdEMGc2WmtLS0pwbjlGT2tUbWZnMXIy?=
 =?utf-8?B?MlRkZ2pzRStSUlVxWEFUOTRWK3dvMGo0TWVjbm5TMTU1YTZKQStZeEw4VmNl?=
 =?utf-8?B?cVRzT2ZWUFhMejNlSVhvZDZ2czR5a0RRRkFvT1htL1ltakFsNVloWVc2NGtz?=
 =?utf-8?B?cjBSUUVYZlE0MjJtdnpPMnVKaW1yMFhFNnRncFdkbTJ4dDBsYWEydlU3ZHV5?=
 =?utf-8?B?dk1haDZYVHhYN0N2UFVJaWdUYUdFOVFPUkI5TktrNzN3bTRHMExjZjMvbm9S?=
 =?utf-8?B?d1JHa2lLUEg5UVVjOTlrdUxqN1EvazdBNWd2U3pic3Y1VmJjTExRZktoOVk1?=
 =?utf-8?B?d0p6Z1J3NStVODhJTTJaQXlidERLZjhHcStLTmNpYXJSV2pXU1R0QWQ1MUVR?=
 =?utf-8?B?YXVONXRKa2tYajU4RTg0QWJHa1pzeElvYzVLMjZZM3VrSHJIbUMwSURONjUz?=
 =?utf-8?B?SkNueWdRVDI4d3JPSVg5ZnBMY1J2SmJGd0lFSDRMWm8vNjQ0K25RZUxXRHRS?=
 =?utf-8?B?eFlTK3FYMVdyTmRvM2EvYTdwbXorTTZTK3pWeDd3UXljOGE4cFhDVThvbHRN?=
 =?utf-8?B?WElIVmhHWk9ndTFsZ3l3cVdSVk02aFhNeHlQeWc2SjhheCtYRmhOTUZ6RXlQ?=
 =?utf-8?B?dThha2ZkWktwbzFFaFJubnhFK0pBSmthRS91VXhtZU5DeFdsdFVEVHgreGRL?=
 =?utf-8?B?aW9YTEJ4cTZhaGhNZ2grVEp1b0FsTVNqVmdCR28vOTQ5MlBOdXpPRmVNOEo3?=
 =?utf-8?B?TXlpZ3B2TVdsU2twSDV5RVZValJPNFhUaXZOWUNxVGppU1ljTkxmR0VTY0lP?=
 =?utf-8?B?MUoraEQxRmZJVjFqNEkzVXN6ejIwanJtZWhYUEhwT2w2aFFuMXdtbmp1eXk2?=
 =?utf-8?B?TGNOMldVWkVZeXJuTWFvaExjekNzVG5PT2xhVUFlZ3lLKzdGTDFzZkczcXhH?=
 =?utf-8?B?ZHhrc1kxZVhuV0pNelNmM0RpbGJWQ1QxeDJXd2JPaitNN1c4Ynd3QjRpWS94?=
 =?utf-8?B?ZXVzYnY1MjdJTUxBRWZVN0FMbUhHYmNpanlnU2JlYW9tT3pYRXYxanNvMk9w?=
 =?utf-8?B?OFdPQkxVeHY0SjlQenhaS3dBMllKS0xCYnl5ZXZTdGtBMmpteEVId1YrRklQ?=
 =?utf-8?B?dXNaOVN1ZFZxYzNhVnJpUUdyaE1pRzMzbGFwZGZiWHF4akRDOHI0czFqZUY2?=
 =?utf-8?B?WWRLQ2NWSVoydWdRd0plNUt1Y0o5MmJ1dURYSVYwc3YyZk9CY0xCWGVYTXNo?=
 =?utf-8?B?eEhRazdZSzlvcFRsNWJONks1MnFuTmV6N2o0Zy9OdEtJSGhXZEN5SDJZbk5z?=
 =?utf-8?B?UE90RUZkTHpicDJ6YjZTa0Q5Y2VORDJKUlpBaFJ3ZVpmZndFQXFhRTBRSGVQ?=
 =?utf-8?B?ZVhyL2xJZE9JZE5VcDliUlBraFF2VWwrOXdPMS9CZXNUdElRZHM0UU5lbWoy?=
 =?utf-8?B?SmFRVjZ5dmdnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R3VFRjhBa3NaUGM3enRJQk1KL1kwV0htWTFnSWVsQ2ZOK0ZCSG1EYnZCaFdy?=
 =?utf-8?B?anVzM2VHTGZZMGgzeWxDaW9Hbkh6NFdKNkVzYWt4cVJNQy9DdjY3NWNMS0pP?=
 =?utf-8?B?b1g1dkRIcThGM042dndBenVmMHNEaHFUUlo0TzMvLzg1LytKd2xBSlpwSlJ5?=
 =?utf-8?B?RlczWWFVNlYwUXhHT09UZmpuSHNFWDN5YzBPRVdaT0NhbCtHUXUzTmVTVk9s?=
 =?utf-8?B?M3k3K3pSTnBuSUlyRURRUm85TC94SFpRNmJhU0NRdmZtaVB4YUVFM0V4VkNG?=
 =?utf-8?B?U044TlErMnZDMXluY3Q5WFlDbEZUemFQVWVoT28zNUVoOEZXcmNSM2IwOWRv?=
 =?utf-8?B?YkJJZldDcmI4cWZsNjdwc1pZZkRqZ09mTnVISVdyUFpqUWQvQjZFbldYaHNs?=
 =?utf-8?B?anZHMmZMOWo2TG54Y0hzTDErMUNIWEZ6TVlMZUV1LzZTK3Z2c3Q5UGZhRjJO?=
 =?utf-8?B?U1pTSmRROVdJUG45MnVPSjJOcCs3MlVXNEFQdmxmRG11YSt6VXlkR0hMTi8x?=
 =?utf-8?B?RmFteFVGUGY3bXZFUTR1ak9pMk9rR1R3YTVrQmdLTTZ2TDF1Q2RGV05uOUdq?=
 =?utf-8?B?WWl4ZnNvMEoyN0lvS2o0RWtURWZWRGNuL1AvbVFzdEw3SHY1T0t3cktIQURF?=
 =?utf-8?B?SVFNdFc0NVY4eGxOMWFTblBkeXR4NDZRaTI5NWhRRDJLeGFndG52QlBGSU01?=
 =?utf-8?B?V2prcTVZckJmakJLZHc1RmJ1NHp3MDM3UDBxYnNhQllOQS9UaFJrdUFCL2dl?=
 =?utf-8?B?bnR3RGllcmVnZVJBZHRiQmxiVXVuaUZLaXIzNTJWYk9ZRjh1WGtwQzVrNTJP?=
 =?utf-8?B?ekRwb2VFSmVwSmpiL1ozNTNwbWE0OURXb1hKUnJpcGtEaXlTKzlaaWJ3aXU2?=
 =?utf-8?B?UGRQMHRaWHIwdGcvV204eklnRHBzbmYvQlQyMEU1OXpWZkRhd0JFbXJFQzAz?=
 =?utf-8?B?bUVGOUcreTBQNGpGZllrNHd6MEw1VzN4anRHMXZveVV6MStoMmFEQzFtMWkz?=
 =?utf-8?B?Umw2MmtpY2tvVW9nanlPWjNXaHYzUk9wVmM5REh0WlBqdWdaS2ptd01sOUZn?=
 =?utf-8?B?Y2kyRTkzNnUzMUxJUy9wK3l2NmdORVlFWkNRTDRXaWpJcWRPMU0yb1UyWGI4?=
 =?utf-8?B?dnZqQzYvZ0RqMTJtUzdSc0tCZFZPM1JNVGRtY0R0eERHYVVYZUZJSEpESHND?=
 =?utf-8?B?aHdZUEpzRjlzVldVUHByNW4yRzRkanl3SERWSXRnZUZCWU5sYUNML2lUNnkr?=
 =?utf-8?B?VWtCN3JTTGxlYjhPWGs3NzM3N05FdEJRc1Y5bW5sa05yWVMyVnBYZFg0RzVH?=
 =?utf-8?B?M0tZWTVxZkE4cE5IMmNES2M1VFdsZWlibWZkZUQ1RCtwNWZhRDB2R3dFUUti?=
 =?utf-8?B?TWQ3VzBETGlrMTFHWTI0Q2xCd0NDZnh4UEZoRGJTbjlCMVVRdmYrSUFkVkhB?=
 =?utf-8?B?YWFYaE1tRUlWNkhldFBTTSt3WXpvTzAyM0FCTVdCanhCaFVCRFZUaWt4Z25S?=
 =?utf-8?B?b0tPMGxLdFJLSmp5RUpXUEtSZm9NTjR3Zy9YS0hmWFZUS1VudXVqd2h0REVB?=
 =?utf-8?B?SVA4aXdXbXVWSkVKbEFxcFpGc2VzYm9VYzYwK1dFVzBVOE5QNk43cHpsNDBv?=
 =?utf-8?B?UFdhQUFmOTdab0wxa3k0S0pyTmxLTnNzSCtmRHVMajVnUHAvZzhORS9FOCts?=
 =?utf-8?B?TVFFOXRNRDE1OU0xWFdwNmE2Y0gzMlB6bk8xMjhuT0k2NTBYWHhBWitGMStR?=
 =?utf-8?B?UklsWVM1bjFpZWJXRjBFdlpocmwxaklSTFpXUW9YSHg5K1FhbXRBbFFhKzBN?=
 =?utf-8?B?Vi9HNXBCdXdpcCtiUzRGeTZBZXZXeEo5ZGx1Sld4RE5HNkZ4RHR5NWpiMVJP?=
 =?utf-8?B?QjFlclYvRVJTL0tQTitOOWc2MHJIYXlqa0ZaYnNEUk1MK3Z2Z2ZUSFFlTFl2?=
 =?utf-8?B?cHJ0OVpDc0FMWTVRRVFOdHBxQlpwUHdVTzgwV296TCthSjUzbU5QSmtvZmd2?=
 =?utf-8?B?RDNWOWRlZUhIUXlGRC9MZUxrQlNIMVNWYWd4WG5GUCtGKzlPaTkvdlM0LzBT?=
 =?utf-8?B?OWpia01ad1pTdUFQNnMwM0RXNTE1RXByVzdIMmFhTUdkVFpCclM2SGMydWhK?=
 =?utf-8?B?QkdqNHlNc1FmQm1EckhJWmYzQjNqOUpKbnY2QXU3T3IrdWQvUCtDR0ViaGJB?=
 =?utf-8?Q?zbLBj9enGRjnpLbe+0jSWJ3dFHjr3Zzdxq6KmKs8mSuA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49B90CEFC4CAC54B863E95B7EF60136F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b67ee98-d6db-4a71-03fb-08ddb3a16973
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 04:33:19.6099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vo5k5yLMKkmBtSXsulNxHMmfU0wLz4oIPpf2NBNYD83ik2bDIjxSdE7WYSkCeRrvBEytyGZjAwg+ZEitu/6USg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

T24gNi8yMC8yNSAxMDo1OCwgQnJ5YW4gR3VybmV5IHdyb3RlOg0KPiBJZiBhIGNvbnRyb2xsZXIg
aGFzIHJlY2VpdmVkIGEgbGluayBpbnRlZ3JpdHkgb3IgY29uZ2VzdGlvbiBldmVudCwgYW5kDQo+
IGhhcyB0aGUgTlZNRV9DVFJMX01BUkdJTkFMIGZsYWcgc2V0LCBlbWl0ICJtYXJnaW5hbCIgaW4g
dGhlIHN0YXRlDQo+IGluc3RlYWQgb2YgImxpdmUiLCB0byBpZGVudGlmeSB0aGUgbWFyZ2luYWwg
cGF0aHMuDQo+DQo+IENvLWRldmVsb3BlZC1ieTogSm9obiBNZW5lZ2hpbmk8am1lbmVnaGlAcmVk
aGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSm9obiBNZW5lZ2hpbmk8am1lbmVnaGlAcmVkaGF0
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQnJ5YW4gR3VybmV5PGJndXJuZXlAcmVkaGF0LmNvbT4N
Cg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52
aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
