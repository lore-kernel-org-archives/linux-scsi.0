Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AE17BA3
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710490787; cv=fail; b=NhKBmyIZSEyxEJf6mT4TBerqreB/MMuv8GMR49xZ6J45pp3dZusrU9b+OU2n29MDZftZldv/Yi+GvEX4F4whsA1oBnz5YXsIoOK6TaZlX97bevZJ2eSqEffZS52zNjERHBfU9jYNKHkGn20rn7U+/DIzcTXQw8UvQglAtjY5jEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710490787; c=relaxed/simple;
	bh=GGF/Wr5kXtg5NG5lBxga6ErJQGvdD0PWNYXzM3+ercM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ENLHhCc1jFFg4/xCkLXuWIz9PpuoHBpVnan4IL4cHc1PYrAoE8YQWM71v3IbHT/1OBY8SHs8jPNWAS0f2kJ0RB7pZicePpH4BMGVN8L32tzXo6QkKkaoWQsQ9y5Nt0OkQUtJloJ+19xSWw/GsrFdPh/dt6P4gqtBPHHwZIDl8Xk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QYs5OKFq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=K/mAEkCM; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QYs5OKFq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="K/mAEkCM"
X-UUID: c3e5a2dce2a411ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=GGF/Wr5kXtg5NG5lBxga6ErJQGvdD0PWNYXzM3+ercM=;
	b=QYs5OKFqhxNVw2lXEQ0N/1co7U+vcew7LpaVW8eBYT7nAalFFoOAzsOxe6R8ew9yl2ZTGQMqDn4q5o8oJrKSiTMCOQgGK79tG2JYkT4pRHX7xQ47wnaUAqpHX7qiP8n7athDH3WwmWi8qXnE5oFS2BBwFb4DX++UdJG+H0WJkJA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:300efb29-6c82-4ca1-9a8c-74eb83bd744a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:80110a85-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: c3e5a2dce2a411ee935d6952f98a51a9-20240315
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 120280292; Fri, 15 Mar 2024 16:19:38 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 16:19:37 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 16:19:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bkneg3+9IO7GX0PLXA/NxipZqL/gQNlKmV544VsYlWWZkeRsXSpqJCu9h2BKR1eXuJYfiwYGYmrQ2gxP9/UZe1mlsVxrk28UIAusOTOyMBleCQgdFXNAhJlxPd/eLEMn3Cc0bFSULgMYugWfKxhsaOjlzI/9s2uhh3EPbsDGN27xMzorcmMSP4StYTOtcmPfQilzboqJFI6hdXetfBeFq4QwjkjwxUilSvQMhZNPaflcfId5m1LhwdX7W/HaKJrPvs7eBGd/LKwp0Q2dJT6jkKVSq6H/oxGwMfcCPVbIHwb3IZijWxSsyjoxCB+xPzm9kpdoF/w20cgy3Ukbpewh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGF/Wr5kXtg5NG5lBxga6ErJQGvdD0PWNYXzM3+ercM=;
 b=gFUibAWsyIkBykBww/BwQIuMhnwniNJ0Ny810bMbmP3CZJ0pi2UnLvAutQj58/DzwGJxbDisVMMjrQCHcpVB+5FMYl5M+7WxhtY2huNSqAExCWdNFGNA9zQ8mZC3miLQH5fzfel+/xqOrjAt4yc1x40SG0aYWo1lNPQzWYC4luTcj87DypAQzQN/UQVlb3S+bW3uG4+4GY/C774osag+3KzUMm+Vriojkq4lu9rzitGLZ+41FwJULtCLww847/ZajgZMw4nKoz+nisQqBsYMV9LTgym8XS95Ay7OJiBd/mNCdCvoZ2KyditGflLPVcrDoHrpa/f9Of/KMLCYGe/lJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGF/Wr5kXtg5NG5lBxga6ErJQGvdD0PWNYXzM3+ercM=;
 b=K/mAEkCML1Xz1YtqkARAUwcEhX558Z6FhvyRfYcjgnA489fC6EFmGbtKXSHThKy/rBSvVpwvoJy3F2ZD0jintI6uuh8pEo5XUmUH8I0lrM+qF3rXuXmCTh14Xhbdd8qSuiHGWBy+O8lI/CIO76BSXFqdezjcws4LB6r5k8gef+E=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8675.apcprd03.prod.outlook.com (2603:1096:604:295::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 08:19:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 08:19:34 +0000
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
Subject: Re: [PATCH v1 4/7] ufs: host: mediatek: ufs mtk sip command
 reconstruct
Thread-Topic: [PATCH v1 4/7] ufs: host: mediatek: ufs mtk sip command
 reconstruct
Thread-Index: AQHacSa7EBUyNxLDPUauRKOXjQ6vArE4IOwAgABfzAA=
Date: Fri, 15 Mar 2024 08:19:34 +0000
Message-ID: <f2a7a9f3725583231e3a6b05c185711a0a75059c.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-5-peter.wang@mediatek.com>
	 <67a4a108-2fec-4e65-b6a5-024f3175b1ca@acm.org>
In-Reply-To: <67a4a108-2fec-4e65-b6a5-024f3175b1ca@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8675:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UHo3ug1T6sKmEaliUbHFvoBw3DrBO+23IlEK/2t7Vc5/TcaiCPbNVLD5i/0jR9TtyL6e0yYzhPWHKvyyg7YXhe+dqCXJzXw7wNljEnImBLWo8HeO8RFDqCKU1fH2cnLaMOryoAol5Ic8V8yJFQYv4KIy6ih0gditFXwK/s5zPjnNS+aENusjahASxYEnp7jOw2+1s0wvLlu4dIFwNyX9n3ericxzf23nfspOZigUIaNA4APRR5lzFmqkPA95ft+USAtSP9h1VACbWKuEqiVp+B1uiAJOg48chyoD880OsXIDiHaCIwjQcssTM5LeJkFcxa+1d8CQcQHABMpF9VzWrxv3HRTIJtw7GpDmV6wCMIjNSG3pe2SZnLqd/m9P0HL39JvduWJtFIQCx5U3Spd7/3fz0DiXjupsNJfKZIbaC1gj6sNEiUZ2BaHU0zdEyFIGNgLJc6eqy5JZsb/tQP7fj6uT+0ooR5sttDuPqvSqnZoqQ/o0JvKbCwL1LjswLcLZ6vxmMqadaYc/yUSH4JuveI3/sPKhLgG6E+rdbS4C1gE7mj7HDo7wrgU/IWlP5n/TzvTa7/M0Er5Y1P4Hy+NDbil1jah6UkrzHpBbIWd7j1EpcKFGpkYoAB34IcvQ8yILgzUMObvQZyyTlXjG7lkILLbgYQbw0MaPKeYXo5H4GwA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFBySWRSaDVjczBkRVFTR1dVZ2Y4bGRidzFOUUxCNCtDeStoWlUrZVREakxv?=
 =?utf-8?B?SmFKd2wyVnVsN3l2aFVXZnhJZU9mL1FHQkVxSjBnTlNKd2hLMmFpcVVvQlNh?=
 =?utf-8?B?Y3cwY1F1S053V1pIV056QjZvMll3S1Y3eHpGR2x2V3g3c2VjeGhGSGw2QTVV?=
 =?utf-8?B?Y3hEcC9mYWpMNFp4MzZ6eTRoNDRvSytYZGpqNFp2MWp1eTY0SXRsSm1tN0Rk?=
 =?utf-8?B?L1pJWERBSVdiVHNDZXRGZUc1c0JZY0s4VHBNbXhjSG9mRXNRa2dTUlhTQkxW?=
 =?utf-8?B?WFMzb0xRU1RUWkgrdzVnQTlSTk1haGQ0RUdscTBoM2lGdTN3T2d0bXRKb1A0?=
 =?utf-8?B?LzRtV1dYVUxLSUJoTGtxNURKWGV5bG5Za2JpbVNqNTNWa29tVXMyNmJQdlRU?=
 =?utf-8?B?V1dGL2xqeW0zclFTYmM3RzhLVnV6VUlLUG9CUGxJazhCeHgwS1kvYi9PRmI0?=
 =?utf-8?B?ZC9qSWU0V004Z3NhcXNBc0U3UytUMzVRQTJ6WXNWd2NBd3JaakVHbmJkUlBL?=
 =?utf-8?B?ZTQvTEI5dE8wMnBtYWtOOU8xVnlHYmdsb3ZFVnFYckJ4Mzk1VWo0bUo5TlZZ?=
 =?utf-8?B?Z2hIdTFHUVVLVkxLcGlhTDV4aTd6ekNWVmN2Q3RKWk5RMHZwTGtLRk1meEF1?=
 =?utf-8?B?NCtocFltNkJzRnVTOGJadXU0QXozN0hEK1BBaUZPRWVVbHZURERXaTlxRnho?=
 =?utf-8?B?MzQzMzZreVBlTDJuTlZETW9RQkVYUnhJQVV4WVFNYWQ0b1hqZ0VESU91NEpq?=
 =?utf-8?B?a01vamwrVmM1QkZERzJOMm5wOFhiMlNwUk53RzVoYkUraytsM05ybzc1aEtL?=
 =?utf-8?B?QURWTXA0QWhKVCtHQS9XTTR1R1hxdUVXdVM2a09BSnBScXg4UEZBWUxJSnB4?=
 =?utf-8?B?RUFrSzlzWWRsODFvWFN0NitITHJNZ3FtdzdqYTFCT0trVUVGU3dSM2tFOXIw?=
 =?utf-8?B?andlT25TVjVqVFNickNCMjlTQThkcGFVL3k2Q0d6Wm41bFJuV0pleTBTRTBv?=
 =?utf-8?B?bm1KZlhwbEZtMFVLUHh5V1JxOU5jekFsYThmTTBvK05iQ1lVdlR4UHdFWUpM?=
 =?utf-8?B?K0RkbWR5MkZkcmFxL1BZZUJ6SVR1Wmg0ZVdwUWFJd0RhWXkvdUtZZXJtMjh1?=
 =?utf-8?B?VStEQy9VVFJ2d2JMOWx3K0dLcXgxVVh6QVNSWmw0bzNMVkZ0QUk2ZkhCaGQ3?=
 =?utf-8?B?MEY1bDBSdGFGY1J3ZFpSbUJ2azRhZUNlc1Z2dHFRZ0JrSHY0NjRubXBYWGUw?=
 =?utf-8?B?WlQ1M2FDYkZJRVlGUG0rMGU3M1M3NVBXUktFakFENVIwTnJpUFRZWHFqYkdp?=
 =?utf-8?B?QkczSjRFajVxdGk1MWpqMUd6SGtQN3VwVDZLRmxTUWlLNmtGbUowWC9rN2hY?=
 =?utf-8?B?Zk1maHhONE5FaVJIcDN0eHZBQWFqNWFld3NzZHlDUjUwRmlVb3MwaXRkazd2?=
 =?utf-8?B?RHlJbFAzZVo4VDNVZ29ZdWh0Rnd0aWxmdElrWXNCLzFnRzVTdmg3cU5GZDQ5?=
 =?utf-8?B?NUxlSER1TG5ZTGxRVzYwOGYrSkY1bVd2TlEyRUxxRXE4anJrOElvYnpvTTl3?=
 =?utf-8?B?VTNBRlZNb2NYMEUwMlM5TVAyK0Zacng3Mi9GUmhBZkp0dm0rVmp6eEUxS2V2?=
 =?utf-8?B?ZG9RdVZnUXExemJiSG1GWlRwQ2tRZ1RSSzhzZjI5anAzTGwxdnF4MFdVcUph?=
 =?utf-8?B?bWpEZ0NSRnN1anFETkNMQms5amc3bHVvL2FvR244c3NFMDdpL0ZsUzI5WkNv?=
 =?utf-8?B?Ni9UT2FWRmVTc0FMVHpaMngwaXB0MUVpTElibUZpRkdGbEQwYmlMMWdKVUFJ?=
 =?utf-8?B?aVhQU2tWQXBnMXhHM0paSXp6RHhZRnZ5RnZyVHFpbDRBSVNRNzVhd1FINmc2?=
 =?utf-8?B?MlBGMC9WT2lqTHBFTEhtdVYwUUFwSElMa3p2cmxyQndYUDRoV0lsSkdEdVZY?=
 =?utf-8?B?SjJjcm1uM3VSWFVxQ2VHZlJNQllmMDVOejVuZFltNHNNelkwSUdSMkJwVnRO?=
 =?utf-8?B?ZkZJaGE0VFB6ZTZRT3lJWGRHRlIxK0dSWkRMdC8xYy82eWFCc1RrQzdsWm1Q?=
 =?utf-8?B?WS9NZXFEOFp4U1ZES3U4YWQySllaNzVnMGdTSXQ2Tllocis5VWRVdVU3MnFM?=
 =?utf-8?B?QlNDUFBOWWtPTzdsVWwrbmVnVWdiWHRTaEFWZU1OQ0l4cnM2allhVDg3anhy?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FD2C4BC91C1C2459E4FA8C18BFEA6F0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7befb854-5593-40bb-e06b-08dc44c8a5e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 08:19:34.7104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TXuuryWsFWh27ApuWRy6KnqNFgQ0oQAugkr6qrJrwR6FiYM+Af429hZbuULHnveUwm7ZhHr7w3oLgeTK5GaX/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8675
X-MTK: N

T24gVGh1LCAyMDI0LTAzLTE0IGF0IDE5OjM2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMy83LzI0IDIzOjAyLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gPiArLyoNCj4gPiArICogU2lQIGNvbW1hbmRzDQo+ID4gKyAqLw0KPiANCj4g
QW4gYWRkaXRpb25hbCBjb21tZW50IHRoYXQgZXhwbGFpbnMgd2hhdCAiU2lQIiBtZWFucyB3b3Vs
ZCBiZQ0KPiB3ZWxjb21lLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCkhpIEJh
cnQsDQoNCkl0IG1lYW5zIFNpbGNvbiBQYXJ0bmVyLg0KV2lsbCBhZGQgY29tbWVudCBuZXh0IHZl
cnNpb24uDQoNClRoYW5rcy4NClBldGVyDQo=
