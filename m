Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE21D8488
	for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724494007; cv=fail; b=f5Zk7sABzSkMiga08TrwHGMcwUAI5EpoEnCPu4QSEOBNNzVtrbRMBHfartso4Vl5/ftHOOm+7ceq8uA7W1IL2u5o9efm/X5EGVXoWE21AcQQnSaMY6R62ZqxsUCHwc3CHMK6z9VkE0d/1As/jYufe1pcVOZVpHSogOXdgkLPB/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724494007; c=relaxed/simple;
	bh=smugs2ryA6f8le8aBhu3QIpiG8MNczEJkWdDhxCFYB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lNH34GKJbEWk2WlcRkNF18AaLKWUG+434plpAxfIUjtt92NPvGTvLXkRfztytLMx0QEL8Slok9qW68UuUIW7VPk/lL1x40FOhf7Ex97EDbOvXsmnMmuhw8IVE5EqPv1s67H2jZqvS+scQz+z4Z2yaqO31dWN2SmGpi2aVh5BKbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rusfxno+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=S847XMps; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rusfxno+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="S847XMps"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724494005; x=1756030005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=smugs2ryA6f8le8aBhu3QIpiG8MNczEJkWdDhxCFYB8=;
  b=rusfxno+yCSrhljtnG3jC3z8R+fBrONZJNPmmPnzlrKzneUTt/Q6x2HN
   +x6H73q3JVSpCPjPBJ5Hl5gifCZytB3ClaDksAlhorfxEhutTNAkvTqXy
   fHe68zN4g/wXuQZWAPq/Rl2uVihK/ZE1V4jMA+B88hgMUPe44XJiN1a0J
   NEtz2KjfkSPVDlDfRQzjYrMJiKAL+MtArrZkrZFUdmpUYRHFFbuKU5SHG
   /aWhXzJ5Ex4S6BXdZ74cBRd0W4wXBNHxZDM/dBOTLhCDBsBRNy+Vg3SWn
   dNL3vv7oZFFWbxJ4rB/To12oTm6K7iszbx+Yf6I+ooyMxQqfDIPPXfbDU
   g==;
X-CSE-ConnectionGUID: TgtiEpEIQgqe4s5hbL1Ebw==
X-CSE-MsgGUID: KbUu6AJ7STWi3MIeTuEKGQ==
X-IronPort-AV: E=Sophos;i="6.10,173,1719849600"; 
   d="scan'208";a="25115998"
Received: from mail-eastus2azlp17010007.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.7])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2024 18:06:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i0ufVwUvpq4WoCKYJvzTF4TmRWbsUhx5wr9k0NlysdLMs/djiVGTKhinz3PDzu4o8JdBBuVyB5a+mFa7BWMvi6G7P1Kh0q1ZfWp185VnELCLlPL/DANqB53v5e2c947q/xsOjzIuMDuRyiwsQtc24Dbf7wT1Ab9pfjot2ghVWJzeWtfSoPFiwKNE7G8HRd8IxS8dy7DDrQoCPud16kN9j7uEuWBoCiZ5xWwe1tcLhSucugcN1/Zn083tEYgi8TKSmnC+Q+bM3ZL6aQIF2jE1PgwHm9bKI+5ZMwt2NtZB/EiM+4GWAajszjZ2SWZLvZP454MJzEd0Marsbuy06ac9vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smugs2ryA6f8le8aBhu3QIpiG8MNczEJkWdDhxCFYB8=;
 b=wEIP7aVexNrY70JiSAxnvLTGu+PYxIWiz4qlWq9zYmDEJ4gllKBKB1fwkJlv69Wy5tGfRkKbVx41Uxs1uYUvBq9s2InGY/ikSnhARxvBKe8kiz8GPi9u4MFoWZVmuNXtikdU5L0NNNunemILxBm70LTz79dweJVnlOJLQs1ERtRAwcSoXcDe2kWdFJuZQHCrkbMMeXtd7o/7aumJNdrnHVE2p0U8HPVBb8eqZyZQDrPk15j/wJjPFSsJG09lxzGjj+bKXN4cuXWs/JE+8Up4iny7En+Kr3Dui4bdZ+9C9Rj64eEIf2es340O8fDGg58qJRzWihrKu2zL/W5zL3fteg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smugs2ryA6f8le8aBhu3QIpiG8MNczEJkWdDhxCFYB8=;
 b=S847XMps2jv5PxYMLwOc1gJqJaE15h+n0u1FVJnhg4jb8Pph0FLnUgQca/mMk0WLPYh68hHkBCOAVTnps5QUbgGzgCiqmnPwqvGQa+BvDJoftGZNJJjjfFAm47LVUwvBQDQKrudUPPoMZQKdbnP36ZJUvnz0FwTJuA7w0gKYAhQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN6PR04MB9504.namprd04.prod.outlook.com (2603:10b6:208:500::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Sat, 24 Aug
 2024 10:06:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7897.014; Sat, 24 Aug 2024
 10:06:42 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Bean Huo <beanhuo@micron.com>, Andrew
 Halaney <ahalaney@redhat.com>
Subject: RE: [PATCH v2 2/9] ufs: core: Introduce ufshcd_activate_link()
Thread-Topic: [PATCH v2 2/9] ufs: core: Introduce ufshcd_activate_link()
Thread-Index: AQHa9Ntw6fkcRs/zYEGTheEgdjy1ArI2MLXg
Date: Sat, 24 Aug 2024 10:06:42 +0000
Message-ID:
 <DM6PR04MB6575659636D994B34F806780FC892@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-3-bvanassche@acm.org>
In-Reply-To: <20240822213645.1125016-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN6PR04MB9504:EE_
x-ms-office365-filtering-correlation-id: 04e3443e-6661-475e-b16c-08dcc42473e3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?AmV+sSp6BT+EH1+s259ZwIWoplvON6JbWlJmXsvpQlMOyJudubIWyRobkSEg?=
 =?us-ascii?Q?K74EGBr1aZtgyvBWagpR2uDagzH1vSnUKJxaxjXUuJDx5qmTFAsvqRfmXRDd?=
 =?us-ascii?Q?Rqd5VMWUVutL6WpSCvD7aZAey6VW8ql/cgQZDUEJ7kjSNn9WGLHibZo89Iu5?=
 =?us-ascii?Q?fW4/UtTI4vtip9zmYU6xjICUHlfkyUX5OtlIwTyLRDpvl/+FwfxuXzoX0jyL?=
 =?us-ascii?Q?xMFYvHSq3ZNUFQXepD45+uCkM7FKUzjNUcwckT45mF7GFHr4+270H+HuWLRl?=
 =?us-ascii?Q?zrcRPfSNSh91OPUA3/cLM8qnYUaOzF5ZLmsGCKdKhyu+gwwD9MjgRQPPDLY3?=
 =?us-ascii?Q?vP8wGHcIgJbsz00fh0crk8osLAHoYo14VO485t4XgVsEl4owrMbjsZGbSUDv?=
 =?us-ascii?Q?j21VOthxMuVCB+ECNL8n4MIAf1XPVZ2fy9/bZyl77IpDgsbIDFJmDFkco6Al?=
 =?us-ascii?Q?Cgu30chzM0I2qEqCWucoljuva9mYe317UZfvCugotNuQzwIJfUJAS6dIjn+6?=
 =?us-ascii?Q?m0Esc2zHz39JqVdmQ9u6RxWplhVHrW5uyO2frIudCl/EZ/0DckQFslRXIpXx?=
 =?us-ascii?Q?cACOp35OctmLE1PEEnHtJdFwW5f9wH949xjyGOLmGepgkpHm46u/+5u43rNf?=
 =?us-ascii?Q?gMbkhlwA4frINZrgSuAeR5SdSfu36MzCOnWSBaxtdW8sGGORDXp+lNEljalM?=
 =?us-ascii?Q?qUUVWlCbGvY0XuXHRxgnj0uvTXgSNj8YX8x503D2+UO8DncaIJYukn2Mhj5g?=
 =?us-ascii?Q?GU8QpNP9zHAU+W9eA4ErCRTMPUJikUUCk8PROwSL2qCcvRFkUQjLLHkIDVrL?=
 =?us-ascii?Q?ASp7BcZWQPR+0Ifkbl+oMgcSpH5BjlsT0zIdGZ5fg6KQoVw4M4r32X+/Ku27?=
 =?us-ascii?Q?EkXzChrBdSn0+vWcNhScjRtwI1pX+2+rP7epO36DHai86iGjH9RYOKNLZCoU?=
 =?us-ascii?Q?Vcd0LHLZflCdMkN4Z/KdZlW+oKQSXL9FjvdY7FoeAGIAAEbD7SpMH8MUEq8V?=
 =?us-ascii?Q?qpnIPlswY2D9oFH6evexc2OmQK+iDu5z826jSzvlnO5QSX3q+GyMR3As6kKc?=
 =?us-ascii?Q?OLwP/D3VQaVIBbeou4gSvLR0yJ4cbrquXT8TDC1TTMwerdrkyTFhQZwVLOX4?=
 =?us-ascii?Q?ckdShati1Ku0eXKXWOiWBl/1ntSgLdGsVqZyXE/JuNANMzUQtbUM1xZ0B7Ha?=
 =?us-ascii?Q?Me/hvL8v2M1ziM8h4DNt1SmhSI7BCcelvI8KaeFboDsmQw1AYFozB2mEKyXz?=
 =?us-ascii?Q?u1GlhYEpaT9mbtV1miLo1LjeNGsKtwKd6K4SAD1gR67Z87w07uHFakysW47x?=
 =?us-ascii?Q?0ATjIfZzQfQyU3YfbsSlmRCd0feFk6yIMKMNeswjMs25re67UXo+GOp+SBrW?=
 =?us-ascii?Q?uk8VPM2CILnTGL80/MoIkQ2tdLmLFTQxS1QRo4xoORKYuLZxIg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?aRJC7n19JgDxUHQeLhwGsxH7ip2vYjZOSMdIKhL4K8hWjAKXBPvXe6DR6TR4?=
 =?us-ascii?Q?LzeP6z+yHKuNsWq1vpRzNvpMbVd+aSy23PUbaejzsubwM1nTriWDqwt7Hy30?=
 =?us-ascii?Q?ZxwQOBqN5oyAdS+T+8091Fr77SinUYFcJw9IK7d5gOdWbgRJ8R2TTZ6htpdA?=
 =?us-ascii?Q?7DmSkR0Qnco1Q98q35ADcp6njp6d4ByJSvRECzgsWTawGMcTzbAQ+yyexmY2?=
 =?us-ascii?Q?/0h8WaJTcMah/03aLHNwdIdD6T9ySgYE4PIl71FkwOr/xkkRhbCNON3YmJwG?=
 =?us-ascii?Q?+K7HZ+nVwulr7LvU8I523vPfFEmIEa8NLxqt/0KrNKJ5sjuLbtcl0+1TqtpM?=
 =?us-ascii?Q?tdA9RIVqY6266WVMgeDIKYwbXkxnKu9Mx4uiZg/1zkVDrUjO0E5blMiTeO2K?=
 =?us-ascii?Q?KR98VNyu6ES9eJqkDY3IIWxNk11fw7t+3Dhxz9qNUISKoVsMWIROkRjIcRTJ?=
 =?us-ascii?Q?sLK/HsVrgBwJKXM0P8Qo+GbzG8jnzw41nxSkJDvm4ASr+iuimjCBtGiU8BLR?=
 =?us-ascii?Q?J0ybaQMmnRl+WIPas4kCMmta7msQ6Ihe+mBLQn0Q2YcTfK2RQSYSepoISQNF?=
 =?us-ascii?Q?++YkN5dmYR6CjAIWMS4hWWSmg/38z3+EsZpFownVOye8N4coK6vnkRlykAET?=
 =?us-ascii?Q?AIq2RqWnbFhDSNISf6Q504D6cBSvVKBlkvS/VRO47BXAJ1DprkDnwjl9DX93?=
 =?us-ascii?Q?KOxldLVPY5c/gzvuXxHhZUWfLEyzVdbuIL8/dtV1mQuqX8i+L7KsSU8xHl61?=
 =?us-ascii?Q?0n2p6VavsKgY2enrG7Jv5wM3B2TVQEm5g49+nXTKELDM5ZNH769MIDyoCwGh?=
 =?us-ascii?Q?XdA7UBMeLOrYBZWoeZ0fKPtd6d6zVaGaSEE836wGI5BY7AgMOGZ+qo+38Qwo?=
 =?us-ascii?Q?YPNCvvDD0LvFNlnAwn/rssue3LMnlXwHc6UO7cnXLaXCjE06/1xeebuqYPjO?=
 =?us-ascii?Q?4xJyrn/SQEzFdl4WEpXR/drNHVz9rOk46GV634Cm12Zr/LYHPvX7bTo+r4Yn?=
 =?us-ascii?Q?haZGEqBz/6WljlhhzzJCnUPGf3KpcTyhrxLIYvZ9QXeelm6q7h6u+g/caa2s?=
 =?us-ascii?Q?IjXEZHPu1+yD0vjiohWz4hsxE62V0zWCvvQ896WYCYDDmchFPEqQQaqSY112?=
 =?us-ascii?Q?JICb4SJ+XC+HdCwle6pehroqJepqAakZa9UO8LSynkOUn5LBsznIIFb6/Dg4?=
 =?us-ascii?Q?p8RCs6UfLFF7SC2Q8Iu9uX2+8PlBtKcEfn3b8DBfq+4y4QkySXB1fLYQeohk?=
 =?us-ascii?Q?2FkxMrj3CwB2z5zC8F2MXgWXtfdAQJttPgh9PVYkxkN84u7Nq9AHtpw22ojg?=
 =?us-ascii?Q?MrREwfPsu2S2wIwwysdMCj2nXpZNp8bduKQd/VKqmLkTeYCSpqxV4VlXWYLN?=
 =?us-ascii?Q?0NBdupQ5yN07MgbzMPPC5YCa68/V6hZBWYXNNRakMA3tULgCiYG1zTDYRegH?=
 =?us-ascii?Q?2nXeT85ozOspzbSK1p0g+DDMJDJxmxL7y6aEpN0XNT+i1z6m+O0f6P+5qAY9?=
 =?us-ascii?Q?/ptxFioaaL++LkW1yGyL6H4j8y7J/D3yhPBXjalD2Z1BZPstcrbaE9Dchryq?=
 =?us-ascii?Q?+uIp9yGnCu3fJgbXPfZpqvMKbHT6Js0+rx71sIms?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WZMiSEObzgv5BfBDjLF8lq/7T83hiGrbSc0S19JYXhEwtQbiP7/Y9yvDAA9QOQf+TdotrebP9DN20OUi6PJmIzNwQwRPKTalCujuKC+iXx6KIxljdWxp5XDpjQsy9conq1wg555V+JmMfmeMyiZcfPqrhj9N4GZnfZvzRE2b28ddoptecXn3DnfckLgnEqfY8WYgMGw5ortfdJ8MZte2tEFIqmN5tvrsRk+2b6bUzhH19n+PALM5EB+clYS0X2y8G/pmzxFikLQxgDfkATPicZbyogOygWC2Q3Gzvd+RzJXv2YtrJWrLz2yK89YPRNlg/BcwsHnEfCp+BiIrYZNvq9jk1A2kQLy74CaitTq1/Z4iti7w8Ry7WGoVPiscsjE304sd6JAbgT7yysUACfbf8uKQI2lrCcyCRw2aOLu8BK7rTRfnmJPHjdC+gas+Cpc1Ykssbr69E7MvWSgCwFhRiZW/8uICoUpWRlMVv7584M0EomMTFJI2tHX3XIUA27BqXtEQeq6Mo7+lyOxLlsZIHkxz87YH7oSJPt70070mw5t8B+6SGpRJjsJWFAw084NjijAi4Yh1Ewc4bZSnxL6AayUpZlAX4eglUTWt3elcFUUC/flGRm8HcaqHIo9wxSeq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e3443e-6661-475e-b16c-08dcc42473e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2024 10:06:42.1501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f/+oxzamW9AzFZRPDZ3qwezmyMUAvP6wWdNfi7+PKSSOQa1OwIXbDvh1xbsgX7h0soyCjUwYb231hE/gCpo2oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9504

> Prepare for introducing a second caller by moving the code for activating=
 the link
> between UFS controller and device into a new function. No functionality h=
as been
> changed.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
