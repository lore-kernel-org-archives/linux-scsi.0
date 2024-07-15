Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078AF18C32C
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2024 12:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721046753; cv=fail; b=VzPnqbgZGnfaC+c5+aOihCOFmhr6XmVvJA1MMDWVtiX9f0vfLqoWUxcI9JJzxfHb0Vti85314WPBN4eJtnzySQ5EEnSuW4TgL2Y+OZfz1x51chbXrlTGbrD8x4Nf6WDGOY8RojkLwBbXfwPGOlXOUeVdmraHJc/uDRGJLG20hOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721046753; c=relaxed/simple;
	bh=8YaPJ3cuAhwWGz1KJIWJfdEf8NVfMlxS0WxDydbwkZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m7ufIDStmaNmMXQJKqXAJ/XajC8sQ2hyHwITMhqi+B5F1axXKIWgLecqQ4s4U854eRfnSNA6Gbh4mQ1DwROKwnjj+XenThffET0vyHav+CatchWGfOxIwMMe5/LYH26gGUMSVBJ61TSsFFFCzPEErbNdTbRI4ojSQe/Fbe9EOWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SrYR7sDl; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BYTbwstR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SrYR7sDl";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BYTbwstR"
X-UUID: 4924527042a611ef87684b57767b52b1-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8YaPJ3cuAhwWGz1KJIWJfdEf8NVfMlxS0WxDydbwkZI=;
	b=SrYR7sDl2H7mpoEF1R35cKfk5qB4bXSlik0PmuwD9y8LhIpKC+Fb9VC0Z//hrytqYF/fbwaYcJ1ze4y310owEvRRuGrb0YPH4ZSxihDK5ejK11tEpIg9z6M+ouB7wobnjfMXJeaFPX+ID/TQAchVNtgbovlQ208RRvYOczOUMh0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:7c741772-d6e4-4c91-a5e1-f0ff4f46455a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:796d80d1-436f-4604-ad9d-558fa44a3bbe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 4924527042a611ef87684b57767b52b1-20240715
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1822915360; Mon, 15 Jul 2024 20:32:23 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 20:32:25 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 20:32:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvcnNWgKClfOVbpP2mVliCsCbJKp0bZFP0rH7j3CStuEN9q+vcNDzf0zUcBAmCruqrOA5y+++n/RzR6OVV0l8jaYHTmSWUfblcPQDKxtz6r/xtGHvGow1UwsAczEQOShrMA/bXVuuq0rpdt288V+1pqCTw7pT8GbsDAksc99F2XaHo/Bzfdzfsk2zwgitUGLjXlnNnwRwnjr9Vhm8PiaV7R/aTj1ewbt1tiahFu5j+2HWvcGvKZWxQmT6ixRxO5gW0QZPsH/Glt5eXVr6QXebHW4QqKMQXYvIBgEOlIamPNRrtTaGLyfrewqdm61n7s3RgGQZL1gjIIuuJjWaeXNfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YaPJ3cuAhwWGz1KJIWJfdEf8NVfMlxS0WxDydbwkZI=;
 b=szzboBuOWUt0Rw5eYGK+8oQMT0R1YfWspow9IaTtEI5F84F0WzU/far6Zf8Lg/SLHtg9j4muJynxoPGeSxGfrteCqfeXWRsFh9JJWrwwAdd1r58rlfCRYAJQjbhfvjB5NMFa1821Je7yUfPOZ97FwmeAnytK5JYAbXXRDRQnJBBpcH+ZLpr6Ba6blhJo1pRArYjsf6sMMCLMDRl/dDx9H5Vdu6666aRrsIxHBW2u2dXp+0N1ewODFT4cPD4DwxUw1yyQUK8606vGMCGt53MswSDQWnKe7yZK2znu/flk//WOgCPmJx7V3b5FgGd+vkJG1+mYE+FxlFbAUgNhcqTBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YaPJ3cuAhwWGz1KJIWJfdEf8NVfMlxS0WxDydbwkZI=;
 b=BYTbwstRp2UT1SZ6OgGqVRgUolJuOtvksrCSoUvPBUJZSfvpSgbTFY7cqAL1XVaxLLwZNLwRx1nw8TR2//Ecy2FVPHdT76+oe2KElS1WPuimcLe0IVdJ0OrzR580vJbVBznl2cl3nzv4c/rReB31vE0xtSMEfrrVNYvy09qlPwQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7931.apcprd03.prod.outlook.com (2603:1096:400:462::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:32:23 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:32:23 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "rohitner@google.com"
	<rohitner@google.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH v5 07/10] scsi: ufs: Move the "hba->mcq_enabled = true"
 assignment
Thread-Topic: [PATCH v5 07/10] scsi: ufs: Move the "hba->mcq_enabled = true"
 assignment
Thread-Index: AQHa0Xx0IQkmP9XQj0SjoSZHM0Y2MLH3wxsA
Date: Mon, 15 Jul 2024 12:32:23 +0000
Message-ID: <bc4358793238e95cf338d4bc9208dd4777207be0.camel@mediatek.com>
References: <20240708211716.2827751-1-bvanassche@acm.org>
	 <20240708211716.2827751-8-bvanassche@acm.org>
In-Reply-To: <20240708211716.2827751-8-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7931:EE_
x-ms-office365-filtering-correlation-id: 6380ad5b-882e-4c59-45fd-08dca4ca2d84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OTFGN0hieHVvbHA0eHd3NDhuOWpaaDVRQkw4WXZ6ek9JTVpPQUVSNzhFbGtX?=
 =?utf-8?B?Lzk1cmtMOEJWWDFHNjFpWGkwcmo4aDRMa2lGcXp0UGVsS0M4TG5XTkZGdEdu?=
 =?utf-8?B?SnlTMkpkd1M2Y3lzNkFqeE9uSS81Ym0xWkVZRjl2RG9FOW8yWFgxUDVmaTE1?=
 =?utf-8?B?ZXl5V0t0N0FTS2ZxQllsb1UyRGowUlg2TzA2eHVkUTRnNFhEUlJKa2RSbWcx?=
 =?utf-8?B?NWlMd0trM3dxNGV1VjdyOER3YUVzbjN2RUdiZSsweUpiRVdXSGhtVk5KaW5M?=
 =?utf-8?B?eXUzOW0xcUVBT1YvQnRXcE5nSHFBbUdjK3VVN0QzYjg3SnZEMG51am56Rkhh?=
 =?utf-8?B?bXBxaTZKWC9XVVk1T2VOMFJkWUcrWElxbzRtQ3ozaHhWMEFObVA0SmliNmt5?=
 =?utf-8?B?Z0sxRHJPTjFDMlRHeUgxWjBhMEU3b040RHBGNjlWeTB1aVhuQ1hiK0d5Z0li?=
 =?utf-8?B?dHZLQUpFQlhpY3d4S0F2OUJTbVZ1N3VFUmhWdS83NkFOSUtWOXY5ZzFxL0hn?=
 =?utf-8?B?WWFGdWgrMmliR2YyeG9GemJqRUUvT0VndlhLcFdEaTRzak5TcVlwR3pvUnlo?=
 =?utf-8?B?cmJmOWNUL1AzUDZXZmNwcTg2L2Z6eml3UGU2dnl1RHBLU0FkY0pLeFgrYVZP?=
 =?utf-8?B?RzhvTkFvcEpPVWZVMzgrSWwxNjZDcExwWUFqQVd4UEVacVBBcWRPRXpyRE5F?=
 =?utf-8?B?aWhPeVFtai9EbjNhUjZxNkVtMkxCdzRrS1FtUWpIOTZjRjlCM24zMm9OYWx1?=
 =?utf-8?B?aWFxVy9hVkN3SDNINGJnS216K1NZT2hJaXExOFF6Y1lvWmtIcGFqaHNEOW1v?=
 =?utf-8?B?aTBiWUhBNjRGYWNSbEs5L3JsM2hqY21GNW1OcXZiNE9nUThVQU5VbzUwZ3FI?=
 =?utf-8?B?cStiQ3R6UmNlaDk0dE9tNjNCQlQxMVh0WnFjNE5DczlEWml6c0Z1d25VdThO?=
 =?utf-8?B?SytuL1pRcUU5ZnNnMXZmUVRlQlJrSHF4RmxVckRuZWx0S01DeVBZZlZtbHps?=
 =?utf-8?B?OUNPSGc0WWNkVEk0UFg3Z241d0FmaGp6c0xnVlZqWDRTM2ZyZWtyMlFWbUNO?=
 =?utf-8?B?ZEdodkxmdGNER2Q0N1kyTUNZazE3VmZlNENBNkNGNFhnbVc2Y3QzRmhQcS91?=
 =?utf-8?B?RWw5U3hxeUcyM1AyQmJLbXRwUGEzcm4rcDRkSHJDSU5va29kVTRtRk9MVEtZ?=
 =?utf-8?B?SXVKOG9yZmUrUWhibnJrdmZJaVNUbWxES0tZM3A3eE8rNjNUVGY0TURsYnNF?=
 =?utf-8?B?QmN5bHg5aC9oS2U5OXFjSjVuNjFRUHMwOU0vV3Y0REcwY2p6TnhsY0ZmNzU0?=
 =?utf-8?B?TVk4OTZZUXprUUt2WDJmRHFCWkt5VG5xREozY0NNNytMY2tGVWFSWEt4SURX?=
 =?utf-8?B?WVlqcDdHQ0JqV05YaVg3Z09VOEo2U2JJS0RrcTBtRTc2K0ZTYUVOWVByMHR1?=
 =?utf-8?B?VUczRkgxQnZTQ1N4Q2J4Z0p6b2wrNUZyT2JHY3Q0OXdkN2F2YmxuUURmdVYv?=
 =?utf-8?B?R3puU1FRQVpFRzlsUHBwZVdJbVQ5NGM3anc5WVhLNFFDclliWVdwN2ZSbytM?=
 =?utf-8?B?bEFhZWp4YVRpWVB0SEphaFgvK0hHUllseUNWdzNMTWpkTTBWSjNyWFg0SkRH?=
 =?utf-8?B?bkNGY0RCcnpSV0JBQWdQVUNNWThGeURYcURWWWdQY2pyMHFOQzUvNml4WW84?=
 =?utf-8?B?Y3hoUHJNb01NUGQyTEc3NTZTOGxQRG5ZZUtLeW1rNSs0Ukk3Vm4rR1l3ZWR5?=
 =?utf-8?B?bnh2U3E4dThCUHdVRG0vZFp4SUZsbnd2azRscHQwUitxd3hST2VrYzhZYUE3?=
 =?utf-8?B?czlSWjNSN2IzbkhPVTZIakRTTUtvSU9DdHEzcm8rbmRzSnJxVU1lUjdTb3pB?=
 =?utf-8?B?OGlmWmovc0Y5ajNKL0FuczFCK2pNdHFIWVdjVlJhVC9uNUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXJBYkZLc0FFZFJLanZjdnJac2JKTm05S3pBTGlSV1FMNlduc1hWdTUrSmNq?=
 =?utf-8?B?YzR6TWk2OU9UYmhaYU0rOHViY0FHalJuRVRwZm92Vmtrb2JUeTZGYUI2dkRm?=
 =?utf-8?B?M3NzWXBIcU1GcjY3amxIY3oyOFIxTmRMaWFOMTNTdFkvVTlhSDI0NkdQeVE5?=
 =?utf-8?B?MnBYUW9wYndydkdNTWVaU1JwbDFvbjFTaUFtcERKbjBSOUR0L2VEU2swbXpS?=
 =?utf-8?B?b09NbkxmUjUxMWJ5S0xtMlVIWEE1NkZWTG4rWkNpU0NhZ3RpQzJyUjJ5R09h?=
 =?utf-8?B?VFhaS0g0SWZISEY1MGxJTVlMYWlLYzlhSHg4bVVZME1XMTg5VXlYZXFXakVP?=
 =?utf-8?B?SnA0aHNIL0FZdWRaa01XRUlUUi8yRmpwWlYzbHJ2WnZXcVVyTVBiaExaQ0hC?=
 =?utf-8?B?VDFJK3B0RmZyYVZvZDIzR2NTLzBUOSsxam9MUzJhVEhwR1hhUEEyWDZFL3pv?=
 =?utf-8?B?dXRmeE5FMWFwbHFwNFRIdStYMFJnUkx2ZzFHbnNKL3lDd3hMd0lOQW1YZ2Zk?=
 =?utf-8?B?UHhiVVA0ekt4RGdZWmlrZWdBZStqTUhVN1dHcUtMVnJkUTRlVk5UR3d5Unha?=
 =?utf-8?B?UWFRVDdqMTF2S2F5MXMvZ0YwSnl3SGFBQUliWVV3QmVhYkxHQzZUSXhPUzAz?=
 =?utf-8?B?U0tiaXE3M1hMQi9Jclp4Y041UnpEemdwRW5kVkRaODQzQlpMTHVBVGNia2tH?=
 =?utf-8?B?S0QzRUZOZW81ZWhZVm9mTHhzZ0l2L2lRUHExWi9iWHlvNzVVcXU1cVBHcTJk?=
 =?utf-8?B?U1BCMUt2OEQ5cXZPbDV3SkhDbUt6ZkRSQ0hSVFVmODJDSXVrTGx4ZE5hTXhC?=
 =?utf-8?B?Z0d0ZjlxL2pZNnZFcTVGQnkzUHFrWlFoSUl2a2FGMmRzTlZIdXBSVmw0RDM2?=
 =?utf-8?B?OXVrQXl1WTd0ZEsvQVcrWjVDUmlXN1F6RHAwMzdVSGdMUzROcGVUUHRzQjBw?=
 =?utf-8?B?K0xGRFBZcHhKRlNMS0xuZDRHcE1YRlp5QTlDZVNhdWtGajRvSi9YV1BEL3Bh?=
 =?utf-8?B?WTBaakFoS0xGbjNwNjVQZTJWdUg3QW9ZWUczUi9ackNXclR6T0V1eVhhZGU5?=
 =?utf-8?B?K1hJbUxpUjEycnorYjEzL3FodEhFQUZkZmovd3F1NGtTMlZ4WWZrdkxoWTB0?=
 =?utf-8?B?ZkVSOXorVFhvYTRXQXhQS0ZVdVUyNXBHZHo2K2pscDhDOWpJTmxaL0ZZbjlV?=
 =?utf-8?B?dmNPNXZBWkh5bGliQTdUOTlqWllOZld6akdnMzRrWkVISWI2UitxMjNlc05Q?=
 =?utf-8?B?aDB6dmc1c1lSZXd4cTlvcStINVJDdFUvZ0MrOVJwZGVuaUN5eVFLdk53c08x?=
 =?utf-8?B?MUJURmVNaWd3WExJdmlhYUxOTTdoTS9VeUNRK0tUN3BhMGxBZ2xuWkhCdWZy?=
 =?utf-8?B?SEZtUm5icmptQ3NNNW9PV0EwNTFZOWIxL0VyY00vbVBMa2FBRkpmcjRtNCsw?=
 =?utf-8?B?V1NiUVBoeWxMWjJycDFKV3dPQzhzaVNzeWdlU3NPcGZhWXpubW90ZWwxTS8y?=
 =?utf-8?B?OXlZeFo4N2RYYmdzd0JLeER4WlBaZ3FqSjl0c2RsZmc5S2NtRXcyUEVmUUFq?=
 =?utf-8?B?Z1hQTU5rUi9SQklLclBWblY1UzMrdm5XMjZFb2RjNXduVEk2SzR0Q2I1ZU9W?=
 =?utf-8?B?N1c1MVNCbVBKVEZvV0lReGFLM1o1S3BFNW03V3FUL0NNcUtrcHZHK0Uwa21Y?=
 =?utf-8?B?MFZnOWsreTQraVh0TnNkTi9GVXZWTTE0dUdQNFVxNlB2NkpBdjkvaXYwNlZZ?=
 =?utf-8?B?ZXVmNzRWMDJXQkw3TGZCV0pJT3c2NlEwRUl1emwyMkp2Y2V4UEFZdFNuTjJ3?=
 =?utf-8?B?eG0wNVo1d2l4NHp4NHdZTjl5TTlUS0szZHFkN1hFVzVuMzBiWmkwV3JBM2Zk?=
 =?utf-8?B?YWVraUluV0RLY0YzZ01ROS9MeFZIRm83YnJxQndBL3R6VTZKRE1hUVFBNFdX?=
 =?utf-8?B?dHFlYmVneXdmRmlGa29CbGlnRENLZFI4SHk0OFFsamlMb3orVGtkMXJFc1I1?=
 =?utf-8?B?QnlIVUhXL1AzdWxpa3FZV0F1NDdSdE9ybGxHU29hanBnblMwejcxYXlYa2V6?=
 =?utf-8?B?ZzhDTjNuNzMybFd1enVqQ3BXQXJ1VG4wKytQbHp2dkRxSHNUa202S3NNc3Ra?=
 =?utf-8?B?R2JxNndEUXkrM0lCZTlqTjg1dnlYM28rK1h1Tnc4OThUVDl3bHdwNXREanNH?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE2A85A332B544418B661195A7F94318@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6380ad5b-882e-4c59-45fd-08dca4ca2d84
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 12:32:23.3544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tyc9gGs8yZMgHeaYPDFkgfZanF1OFwXWX3wA8PWGlZ9LWlJv9Rv7V7xXEmb2QoyOqx3r3WzQAtuEDSx236KSWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7931
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTA4IGF0IDE0OjE2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTW92ZSB0aGUgImhiYS0+bWNxX2VuYWJsZWQgPSB0cnVlIiBhc3Np
Z25tZW50IHRvIHByZXZlbnQgdGhhdCBpdA0KPiBnZXRzDQo+IGR1cGxpY2F0ZWQgYnkgYSBsYXRl
ciBwYXRjaCB0aGF0IHdpbGwgaW50cm9kdWNlIG1vcmUNCj4gdWZzaGNkX21jcV9lbmFibGUoKSBj
YWxscy4NCj4gTm8gZnVuY3Rpb25hbGl0eSBpcyBjaGFuZ2VkIGJ5IHRoaXMgcGF0Y2guDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4g
LS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyB8IDEgKw0KPiAgZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QuYyAgfCAxIC0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCj4gDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NCg0KDQo=
