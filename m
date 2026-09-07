Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D1B4E3ED4;
	Mon,  7 Sep 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794788; cv=fail; b=NPhX7DSfFtfLqvp5aAhHk0rTX1k7Bhll8O6tHBqSeXANxvuN8quLF8Qxlf7xElsjaXohGPsiDvYZaO6bRprkNuVu3fdgvhz1pCeAxtO/z+9TAYtmYnJ3WJp7Nb3gr6izSP3vRPl6hNWY23TdYfxTDKLSupqrTMSxlToTOa84hyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794788; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bdJlhGAmMMssyA8Amt0CIMrP+i3U/VuaRc3v4DqozldQDxhIAkeYVEDZfkQDfhMhroL/3dv7w0swIUTBVVoV4UcbA/tqDE6LGhzsxLY4gGIO5hUBzdrLYUE+Hb+jOPT2eTKulCmNGagD8nojgcpE47+Rfu5IbAAFJQ6YXxgGbng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZSaV3Rde; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kSmJFMGt; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZSaV3Rde";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kSmJFMGt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788794787; x=1820330787;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=ZSaV3RdeBla/AmqGVK9ogo6PGn+/UBIcMJNIgwxgHmNqoxSGO++kPo+I
   0TidpZpO3W5MB9Gx8c8EmYJ2uuG+heyMGOPUDP/IN9Ci40aNc13KACNho
   Q3o3mvJPpYvfSnco/IRhVScqn5GPdHOS4B6+WfvsY1hrgZt9bEEY7/eF/
   iA4xy2Mm8Ei5OcXrSEkD0fuY+vaAlU0AaJ9cCxO4PrNyUhZrTbQiMVdOq
   BVJtn+QjSNXp6Qs36BB9vynl4Ot9QKEVNJI4qrGFqQJe/tpxjZ6GRaHX3
   FgltO+3512EnkWeOaVlbgnLwxGXRvub3F1hGBn88JsiDLTzd273XHEXVS
   A==;
X-CSE-ConnectionGUID: WbOJo+zpTJqKPsw7ZJPbqA==
X-CSE-MsgGUID: GtobWPTnQ0KsNsJhcaU58A==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="156050676"
Received: from mail-westus3azon11010063.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:26:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRapliZjD0EDabfFUDorTwUUXbXvsg+SuiY2DC1oL3+l5DSEqLqpjX975ULg5cUkrdppjU9c7IK/euSvf0fNNdDkDOZpqymePW0OCbbmQYUV7+N6JYDQAKEaLzv98rkLDl3cAHoYCe8N60JIU1idmpaDKFSPtKI0xKDE34dLseFXyzj0jEJb0i0Maa9VPE7oBDSYS/oMAETgAVxJpQOamMoc7W8z0ZMM8d5Bi873jHZPx3VcCuSz8bh29GhK58jEWlnt1dnHTPUlZOJLv8hakgC/EBjkKPOzjPGIRNDXjI6XxzjsUKfZTx5U+Rwxk5u4WtgKSU7Pj4qhl/7kgRmbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=y7Haz8uN1TEuKITnoyptgV5hjg5FDDg+UjN6g8BThJjKxOF9uPMowv8y+V+W+YQodJ+7Wd+zBDH/+U3srvJBFxTRY8236CfQakvEx7edzoyD2PCdIjQVMDrnPa6GoRqXld8Qt6BiSsQQQdNL8YvMYLLc64+Q9zLE1zGGJOi1E7xv15xTJGYuVtplkRYjCo/qDQNeB/I5rVLkpCL/EbrurxHXF9xRmsChrrGFiTDtEpMhtFMFL2rjSpJpBM5Ac47V835nyh9kY7bMaHwyYpPLEsAIQvmU94x1Ia6eLpQMRBG7QsfGPFSClHykIvEzJG7EgNs9OS8uP71Wy9dDl9J2mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=kSmJFMGtiVk9e0VTFKPZmKvO6m6uDloNFqHfC+cDWmOgUNJTsbyKd+sb0Bw4fgXwQ/t0IYbp+wSS2fYSIMlnMxqofdo9HeerrotiaOax/oncp1k9pgZH7BC+l7xJmf8hIShS9vqlkuBj2HXbEpN6whL+bpJ0WtPp+JJ/uR+jfNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB8960.namprd04.prod.outlook.com (2603:10b6:408:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:26:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:26:24 +0000
Message-ID: <8b8085c4-a745-4472-9349-ad250cd75eba@wdc.com>
Date: Mon, 7 Sep 2026 17:26:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 26/40] scsi: lpfc: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-27-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0173.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::16) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3664b5-af01-4a35-e386-08df0cf46079
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|19092799006|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	t1jx3HHvYtlTBDr/qyE2N+M1QispW8FWyjzoM0ZIkivoRfu8btwyj1Q4M+PkTdwaXEkH5Lfp+D7HGrLdn7vzTzIWWs9ST/2aFEC5Rw21z3v+Wcbe6Eqhf2IX7qW3Fdp/OBsdWZQXPm9N0Y00kLQZl1hAkIzE49sji6blLIVByORN/DqfuBQklqHk98+jBlfrYxMJ8MgkEsojvNeS94G6C4KxWYeTdCctdEeUx/hXDFgITxbf1oIg+ecNI8cqzeAlsR0fMO5K7Qrf8eXQPZvU0L7UBesOQlQ4JBws8EaL2Q+sOsrow3lHbY3yUrtv2h9YQ9zz/OKsuWhm9ia6LjJHRil+XURFqskBMFyeDCxLOfJqGMYi2UhZLh1LF4xuwCC2gG9Fkpvv43pVAD8uWFKa9hyea5tRwL27ZJuLA0XQemMJ8igQFBnW/nZMk2zambw1Ep0O4j9j40m3hbNTyrqSqs3+xfpdrYLwagFnLKKP6AyKcNSWoIQIyRxPDhzDlFyiPVTbvEQN+BbwnS9eFDKEjxYU7eB0q2o7Bi2Rg97EeJz78vk0IJPrDCUdS99FikcoV2um8QJ9+aYyLJpU3x6I/RgjbyCl6uHLtCuU1fBvrSOPlj+VPrHc+e9DqzxexAIP3AC3v+cQPaU/wI3h6UjMzhdZRsT9XtHfBXsCONCf1O+RkMOUTGDPmJQneSjdKL54UH79idPKUWtsBffrkb19jw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(19092799006)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHpTT3JnSTgxbzFnMEJ4dm9hQ0ZLVFNBb01rbHBqSjZEa3NjS0lGclhReUp3?=
 =?utf-8?B?NHFyaGoxeXBkNXZYUGVFR2psdlNyN00ybEJ1d3l0MGIrTm1tc1JsMTlEOC84?=
 =?utf-8?B?d3dWRjNlOVNCUVgyRjhIbHdpTXk0UndZaGlKTlV1emJUcmdFNlh6VHhDdXFr?=
 =?utf-8?B?eXNENTA0WGw0MjlBWmFEeWRQTjRVeDZ0NjVpV09WSFVyUmNZVk82UjA1eTlv?=
 =?utf-8?B?dzdKZ3BIUjNmK0hZbUNSMitQM0dmNGh3UlBFM3hveWJTd3BCQU4wcDVzWXU4?=
 =?utf-8?B?YUd5YjNUdzZtYXFndnpIdlpoS3U4b3NpVDFFSTRmT0tldXdJK3ArMlRVakFH?=
 =?utf-8?B?RnM2MzhJVlVSaUNETXphM2F5V2ZuTmRNMzd1MWJXemZ3S1RlYjhhVENGNW9i?=
 =?utf-8?B?WnpCMzJBNXRTeElGT0daYWRIcWhzZlZsOUlIRWk5bXU1SFljN2M1WlNJNUVi?=
 =?utf-8?B?cDlGb0RrVWN5K2xDRG4xNCsvMExXaFdkTHk4TXp3VTYvVHVRMklFYWh2TTJk?=
 =?utf-8?B?Tlk3aDlUSzhtZXU0UlQrOUY2TGcwam80S2xnT2JaMVFBbjBobXNDUGY5SFBZ?=
 =?utf-8?B?OFJqZE05aW5YWnJGZDBMTTJiQWFVWkNlZW1kN2hJbzVnVjdkcGpyOWZTVnR3?=
 =?utf-8?B?ODdGWjNCcHdiRUZIVEFVTVcrcjFxV3FSVVVPSFA1NVBkVXpQczFQSTVUcngr?=
 =?utf-8?B?SHNpV1Exa3U5UVJOaVVJY0o2QjA2UFRSSDVmRGdpbXVSNlRudm82S1c1eGdw?=
 =?utf-8?B?OStpUktjSFFIZVhRWGZ0NGNwSWE1TmVUWVJmeTJqSlNFSzM5a21nRFE4bEp2?=
 =?utf-8?B?aVd6c2svVXBQM05HcmE5NXFYU3hoNmlpQ3pwVVBSUHpzeDZDc0R6elpxdHQ2?=
 =?utf-8?B?OW1zWGhnVzJLZjVTYzNlNitwTzJXWXA4bStUUmpOQXRNbzlYYS9QY1U1dXBt?=
 =?utf-8?B?N013SE92TTQ2TFJmYi9HaUo0V3FJdk9ZR1kyWDRhK1RIdFRWVVNUSG9YYnJr?=
 =?utf-8?B?dTcxdzltR0xMTkJvV0tLTzFlbEk4NUVPWEl4UkNnZjF1dmI1eWZJa2VpYkNn?=
 =?utf-8?B?d2kyQk9HV3QzNUZINnhuQVZVYVI3WjVOU0JJdjJqVXhEM0FHMlJxOUNtUE1Y?=
 =?utf-8?B?YmcwNGt1S1VTcjVvV2tSNExxMTh2cnJqb2cxTUYxeWNTZHh6QzBraVdVWWVJ?=
 =?utf-8?B?L3VvUmllRFZlM2diR1BrbEUrc0pMclVqRStYUGtURWhjQTFpSDYwdzN2dnpq?=
 =?utf-8?B?OVNnaHBJYUlDOFd0QzcyUHBsMnlQNktTRE4zL1RUNUpZY2JnZUVPTlZjVWZW?=
 =?utf-8?B?SE83Vmd3SmRDWDdzdGoyZzNtTkREQjZyMld0endWZm82ZVJhc0tTWmRRbUk4?=
 =?utf-8?B?WmhUWE1kOW9pVks3WUNUVks5eTBMbEJZTXZENEQrNU5wR2JRLzhKcVZQaUZ5?=
 =?utf-8?B?QmV2MjVicjNoWFY2cGtDVHNxNk1NbFI2dThyOURHK2hFUEpRYnZNbVZWbE9o?=
 =?utf-8?B?Yk15NVI4Rlg2OHZyWS9PQVNVNEFYdkRaZDhTakVpN0xBWndnTDFPRHU4ckk5?=
 =?utf-8?B?ai9za3V3TndXcmxWaUpEcEQ2ci93eWdxaHdZMHc5dU5hRktXVHp1OXZjZ2V6?=
 =?utf-8?B?ZHcybEt4YTlDdzJoZ3ZQUXh6ZTd5dXN2RTJYVVNVMlc1UTJMaFVMNWZielpM?=
 =?utf-8?B?N0pEYjFTbnhXOGxmZWpFNWUweDE0cjV3dzh0VGhWOWhSNmtOSlI3REVHK0V5?=
 =?utf-8?B?WDUxSzA4SG4rSXptTHZjOERlYWhRakovYzExYlZ3T2RTeC9Td3podHJnWUNX?=
 =?utf-8?B?MVJvT1plZ056TkZzaVNXNndUMzNMZFdvV0tFV1lZdzlBcmw0TlEzRUNydmRi?=
 =?utf-8?B?QTFSdGl3anoxZFF2QXZQRUh3NTVJQnA5SDhxRTVBYTZGeUh4MDd0bEhVYWZz?=
 =?utf-8?B?aGpJd25QUWxvRWtaMnZCQ01scHFNTEFrc2diTk9jVXRxaHQvdDI4N2g4WlRR?=
 =?utf-8?B?MFVINTd0MGpnQkdYbkx3YWRQU1h2M01GN2VMbUJhTUVqb3F0dHBLTVlXVnlo?=
 =?utf-8?B?VVl2SmViZStsN2dRYlBJbHpLZUFtK2lLRTNCUTExVlo2UVNPSU9kdnR3QTlF?=
 =?utf-8?B?NlFXYzB1Qy9hV25vUjlVKzZ3Vng4ZWZPZm15cjFqSWxwSkZ6MmdxanJSVG5G?=
 =?utf-8?B?Snl4SlY3enJDMzNXZ2tVem1ndU5sSkd3eXZyL0MxSDdZZWdUTlpzTUJIUEI2?=
 =?utf-8?B?YWkvb3BSK1BXOGVIVzlJVmFGbVgvK2hGMnVIZXBsWVFJUG1QL0ZvWGV0dVV5?=
 =?utf-8?B?RXNENWVkZ0ppY3loM3ZaUzFzSFFoa1E1ZEdIZnRPNVVkdGpwbGVvbTJSSDN2?=
 =?utf-8?Q?6Onh/3ouDOji1R6I=3D?=
X-Exchange-RoutingPolicyChecked:
	1plXQ13PrMZAzrI60puaAA2cZt+Xz/hIO9QZyMHtoZHY7HqJfnEhGL26FzCMaXvy00QWzwwpPJbaFwRLbrYWgrYUHCJVgGj3R+SFEVLLPOpUAjK3ghxPon5bzvZalhQO5ajdUy5wL0KJL4TFY6+dpg3UN6u7yzcQWn/lSppB6snXNBlVkuLuA/yfeYcgRoG6AbRg4/dkiUHXxgHnKh4gp+zvOSq+S4JrfmJsxGzRkdRUqLmf1eLqugk0ZnMSCfDt1nNpeMKUul3mmaz/oee1XEQoG6PSa2qgNF02sWc09O0Pir+SoAIIOSdIXmZ7rsJE3bTbVJVUV+zKl0MzcKa/zw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vJZV+3MwdYv2hU1SuchSkFl6bcpvSyeVU6mb1A0WBkAbHLIsGv+VoxwTPneDK+Nqtqpj0SABKuAkgZ7ixohv3OnFUraAdQAoD8Ajko4AH/XwUieMed71JqvnslBOLpkPYjU/bUpspaWkAbJHH0bjznDWOHiYR348X7JO+z6a5BRJXn0taMXMbmNFi8LVLXuEf0Aap+NK+W3eVxGRvn5vMunKzP/Bh51L3MrPgrc74r6eOtgaKr5t84ZFbyJ3FShMy0+5eWx+Ip+czxSUl+f6Cu9yME98J8A1unP3zi2x0oOQiiSJWHbgYxZc1MaclPH7AdwbHtd/57jsAHttK7YgDCtLN1dcE6odBAD/eyRHdsPW3Es1MU/MUq0rhmtwwonng/dKsGnRRbeHZBRXEwpVNeLUYbgE6/xVOntD9pjiD9aHgU2QhA3IPf9/5opyQ1lZWlW/VMYNi5O//E//LAnKj2XRtlbnhxtVMq1JcTRK4NoZS+ltwjtQIj24Jxi28Za89h1Ln7RAc9Ig9Ai1L626vZTk6cY+gqQE1aY0UsnDPVNzjOLYSPBdXqbr7P7nPJRpQnG6gs9885GV1i/FKLfFSn5SY848DcCnT31Y9n9UkRPGXsJe1kQV+qkaiz6V3JhW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3664b5-af01-4a35-e386-08df0cf46079
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:26:24.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vmpg0qLX9FJNR63XIEto8ZQaJfeGgl2NkRCau3k7AyVN/c22nZ50KN4VA6JtfvTcjnKdjzdLEaTqqvMR5mfrWuHXp3Yavbm5+J1h/+aZamA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8960

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


