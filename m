Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99431F2C46
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734435236; cv=fail; b=pIk2avsRoduULbGx8MRDibQdX8pCDoVFgRbkzWIj2tsJ355SZ1HweF3H+jzZ2ypOzpzR4gGxQuq7Qo1SHYRUqscw+NFavATrZesIBFDEZNtzwiLV+VKBejSfQI6RmEKvfGw4kv2N1v0r5vzEg/eoyKKd1dqvRpbgETYYzdDUj4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734435236; c=relaxed/simple;
	bh=HLn7CCGzUsDAziuqDzgg7P55+4O1aEDdquIrt54XIdM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y1AJ/LuakJADpvNsFi+xGpoIndQszBUKdqMjelPfpqLuFyuhdZxDcEzMR00MCXmCW6PhOWpX1/7KZY6Q+xoHpjEceZqNAG/Bi2V1kKjD3IIOI2h8RjsIF775IPhFJ9xZuhzMlDHUaLLbJkcKv5cZ3qs3hCfXTHEajW+9x3lAxcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c6e67WwX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=v6YNoPek; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c6e67WwX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="v6YNoPek"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1734435232; x=1765971232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HLn7CCGzUsDAziuqDzgg7P55+4O1aEDdquIrt54XIdM=;
  b=c6e67WwXaoN6aZfvCc7CE8agXTIY7+O00H3wt2RUVZM82qoLuRvrHZPN
   ExsMv/mMiPDyfxuGvet0uDoMCJL8Ij1yvM5C3PgESAFE2CHzM6iBY3bvE
   6wUivaLlg7FPZAk0VTSGGoJOF81tOZvaoyDoqhWm5hTGCIFYSXr1vw5Eg
   lrksMGmqa2KQlcC5DEyKuxy5y8dROODvtDt4t9wu+gFrbZloQLtvCEhre
   HLZti1p1pZ8yIjwTezRLJYlgcVm19eeS1L3Is5ceIqeVbNauOfIKTl+K6
   8R8tVMI5YY8Cn0xFeOhyTGg8pCPUyJs+1D2dPBJU+UEdw+FBHSG2U+TEg
   A==;
X-CSE-ConnectionGUID: 73mEWK3cSJaxCRBoLexBVw==
X-CSE-MsgGUID: bSVH+7DMSqiF15jetn5EBw==
X-IronPort-AV: E=Sophos;i="6.12,241,1728921600"; 
   d="scan'208";a="33875053"
Received: from mail-eastus2azlp17011028.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([40.93.12.28])
  by ob1.hgst.iphmx.com with ESMTP; 17 Dec 2024 19:33:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BHkvk5xMjWJryzgMUai7Yd2DLJ7Ype9YRMafqJZOUpsLi6cMtQWC5hLztfKvRbY8VtgwQQ8v2f9Bxg0UNPtjwSHRBmGpy96qkYUCRM1zD8QGVpzs64Kaol+xt9REf6xNKOMgQgiH3dOCjV+2uS+91u8xtFcisIFDpZECZRlTCP5e0ZINTsIoxnGYb2c/h+qAJKm7VcTnh0bFPvvg0gDDXjvSt/y4sa/JV/xHGcrkgF4HnL9xpuxR4xXY0WjPvGgn31fYKAZzzGaA9kE064EkGvXe3ggpEMvgvjS4RnKKkbxwvWptm6F+U+AbUxMPvisuK/7CVT/2fYOyghwLN9iDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2qEvZ80SgvILD0RCvpUCQHDcbHLRWyW11cg4gB92IY=;
 b=ASOB6y58SvTwKslYQlrn0ac8Aa9VhgNEvuO0R2UyNYtuMRwUKojKwYfdRJNOfQroYW26Drvj5yZOFLbKmTrYdLviDGONepDWVVcmEqcLtUxOdD1O8Bq+Y4X5DkPHAqL57eDtG5jM/ROwxi9JIk6u/E4FeaMcxLD9KyBRXuANgPajsAssA7BnmVWe7VvCXKHpvQta6Skch+cuZLc+g0iIIjLlDiJf2iDK4MFbpjqb7DWXAbYEMKeY9kXTQxoUNnlpVL5dGIjJQRcqEsioVwfHn2hbbH49LCt1w3XHFOFwELQzF3x13jJVdiYFs0f9o5b0GNEBk+GuXqiyHWvyqyd6EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2qEvZ80SgvILD0RCvpUCQHDcbHLRWyW11cg4gB92IY=;
 b=v6YNoPekzYxXbl6xbz8fbbjZr0Sd1i/nvwB2rhUVHzj66U/f3cm7/FVhq81EBlMxT1HNa+oFXLKWkBHmFhI2faJdtb6C/n7GO285lCdhq0E7PX+T7vp0r1MKKo+rPxR1OsP3GOZPhoOvr46weKc/OrHuEMeQrF9c94NGLBtnp/M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DS0PR04MB9416.namprd04.prod.outlook.com (2603:10b6:8:202::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.21; Tue, 17 Dec 2024 11:33:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 11:33:42 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Guixin Liu <kanie@linux.alibaba.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: ufs: delete bsg_dev when setup bsg fail
Thread-Topic: [PATCH 1/2] scsi: ufs: delete bsg_dev when setup bsg fail
Thread-Index: AQHbUHKsm1ZUkJNIDk+aZKk5U4x4obLqTcQQ
Date: Tue, 17 Dec 2024 11:33:42 +0000
Message-ID:
 <DM6PR04MB6575D789D153E7B8B18F76D5FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241217105840.120081-1-kanie@linux.alibaba.com>
 <20241217105840.120081-2-kanie@linux.alibaba.com>
In-Reply-To: <20241217105840.120081-2-kanie@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DS0PR04MB9416:EE_
x-ms-office365-filtering-correlation-id: aaf7100a-1ab7-4918-d57e-08dd1e8ea8cf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?iIym9Eb56TVM4/i5jd3xh2low52u2Ebj9TRra1s0J2JZjU2wpg3m3Np6eGAL?=
 =?us-ascii?Q?g4kp4f9iaR+yIAZ48es8L28q3PQoOD+MTFemwdfJl3JQSnfkrOjT4PXVu7N1?=
 =?us-ascii?Q?zz1Iz42Innc/Y/HwZ/24WcwMvL+2/iPYlHa4mIKWA4ycAQhzcrc/05n4IQl5?=
 =?us-ascii?Q?G8T2O5Jzec400SowcYsaZffkShrO5k4S0UjZtRUT8HjSOf3toIuDMWr1+WKD?=
 =?us-ascii?Q?Rxx/TSLc9xUXB9kg4ww0BE34lAEMxSO8NRh4m6rtTwt0MhneqLB/owR8xexx?=
 =?us-ascii?Q?MnNVXp1FVY6udKslBsboeBT2OYY9wivp/Yepgj1Sd9inoIbcSGdZXxawTXUy?=
 =?us-ascii?Q?hXUrcMTjBesCVM0ZhEW+vEJFw6CiVxPYny37jSBpRP/zi/tqxKZLGNWFdxo9?=
 =?us-ascii?Q?ihHBFr7FBpUXJ5fal7mviZsYhnmKdnoY20BXBKLXhV2qT/sWOr4yMQSUXiVa?=
 =?us-ascii?Q?i4ustcNam7ZjUbHM+9vQEzr9bXwX6T4Hslj0/sYHDEvnq4abx6d44F8SmcDN?=
 =?us-ascii?Q?hwPt88VtvkBgIUFrVTT48fAaBKyDhfK+o9CQpRQis4qr0dKAfIsDCOuHdQC6?=
 =?us-ascii?Q?+ZN+pO7a8KgdNTNx4nLanKyD5wKyGZhN2b1i05c+nw6986mon40p2K8k1F8/?=
 =?us-ascii?Q?gQFDVAgW+ML3uqM1GmhKyZqoco2EKqwVIsqgDA0z1tC8kF6noiK1y+WK9QME?=
 =?us-ascii?Q?FbiHvaqc7HVcwrzwE5gfpwcH6Zgw5pdZHMofUA3djeFUr5scC43FctW+dm6w?=
 =?us-ascii?Q?uqt6s7RWOcG9jnW5IOI5YuragrlLf6LC8ksV5lSzsKBXbHJ0gDsC95s4lcBm?=
 =?us-ascii?Q?7gTe2TTM4rZzOsqkuX3rG+Ih22kv+EF9xnxNVgcR/HrHr2LM7OHgc/81m892?=
 =?us-ascii?Q?jiyCdgOhhgj8sbL6pT6pkBFYTiV0MYSaDEoHcrq+lOfNBpGoey3MQkuO8FYy?=
 =?us-ascii?Q?LhyOcF8rThUL/aFx10HWJZ1BK4Qb3R87LREputk0PAdATqFTJcX00/63TLB2?=
 =?us-ascii?Q?Q7bgePouMlGPUN1nFyczmPw1mCI7VKsUgqzQn/zsfIR3srABUbY106EnFBLJ?=
 =?us-ascii?Q?Vy8S5SdGYc/cWW2J54yoGz3s9rZiskp0aJ1EunhPH7nKXxo1S2qUgYO8wnfY?=
 =?us-ascii?Q?y+sCjn11MOSisH3KkomAtuyMfIV3CWRN5t/rRaf9eptT6hl62RrLQu67DZUt?=
 =?us-ascii?Q?lkGEcRmapm232iZ0x9Rbj6p+FIU9YOPGoUrau+9DFSVWKdD5TosekmELpAYl?=
 =?us-ascii?Q?918Uu2yMEkA61E/QAMGyyFhFVL1rWijjT3jFX2YLe3M1y1QdtJTRWiUx0Pl1?=
 =?us-ascii?Q?UiY2yyb60Vi5uZ3mZGH+P9Su6eGQrZXCbu7eYJnQlRacZApxOs+eq3zVAjQy?=
 =?us-ascii?Q?xqJnc3muR/sRpqt9gU0R+aVc1sOZ/uB8bKG90DGcWLsuTd3HIJJGmBfdz3mJ?=
 =?us-ascii?Q?okRVeMl93C3mXqZLCqYwmiQ0DgjVJcvv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?NBxTnfHwX2zySyZthCqXr/gsb4ZGh+Gz0NhuLpdRtFuMe/zjzLGrNBuo8Lpu?=
 =?us-ascii?Q?VYaqTg5HjxyzR+a/12ijdbJdo9zCQPKHswEZov+nT1I4OYqLLHpA+BxsSu6U?=
 =?us-ascii?Q?3A4rOyErLdNWZL0uLRHGLmi73XHQH2LqOetDnNLDKa1CYsj3IYXjbHQoT/xx?=
 =?us-ascii?Q?9gBq55l92ko8+JDUP3EW9Z9no4XleyKQNaZu8sByBurRH1zAWG2F0y/LWRFI?=
 =?us-ascii?Q?1UcEPN1E3lAJg5fkikwIAN3ZlUGn2OWWecSpyVIpgghgXbD3p9ihWen31/Di?=
 =?us-ascii?Q?0J7TF74uyUzT4waiFzLeXjFMjaXWrh7eYDPNAJGyot/T7FFKKQgtBzhkY0bh?=
 =?us-ascii?Q?SLvmT2To3/8RmfVC9hnv3e9Hq4+iIOHdmmY3urECOev9Fn045tA/tOo/H9mM?=
 =?us-ascii?Q?15aikLllLZkxqyeaaup9D3MmZavJrkFjU4M8xj5FkhoFLDHYRIxYYlydH2v9?=
 =?us-ascii?Q?rVaJYMuLPbV3Xljjyv686k2fR0JmP3iO71erC6g5FNTRzE3/2j2XDAuBU38Z?=
 =?us-ascii?Q?zSEUJO4HxQC/58Uee2WNjoftmBbnHPZe6iFbGty0wEg0n3Pa5o0o4LWL2kUt?=
 =?us-ascii?Q?3rWHryVnHWq3MWWKai7jyW/qoa5rI6jKdq0li9qDsMXl3UpzolXWLksyediw?=
 =?us-ascii?Q?N1gSQ7iiVtjFV3OK4b2YAq5U1l6szUZvsyBvs/Y6OsfWpX7jmIoD913WmE01?=
 =?us-ascii?Q?DM8pi5NoAGCzH5b/bui9sqcRgTSsMyv/qDaR86mJxr9JKCuu7+G+hz0JMpLa?=
 =?us-ascii?Q?CozHvcxuTWFWpYZxileMomJJOPl8GFMvIUyaNN43aoW/C5hxisbM0JbH40zO?=
 =?us-ascii?Q?Y6P3Op6h/TezeyFr28jJ1xUOsk9tvIYmR8hcSdqm4u5Ph7H/uTDo/rEkLQnW?=
 =?us-ascii?Q?XjO2mVRD9ck85M+UX6k7tvDYXYu9IOTf199isSQS5CRaM4A5Psh6ERoqILsY?=
 =?us-ascii?Q?kIEhQsHp8SNXwsOLCCtMyONEOcuH7a1Oyxa2G0Bp+/S8lmRpWOsvXpF2lvRp?=
 =?us-ascii?Q?KFXEDi4VFNFcjFAmc4VP44Yl/tIEnRmwQzLePHipinSITmtW0vdILwscah5R?=
 =?us-ascii?Q?eS3lGuzkFhMLLGCcaXmWs0McxbBl26+hSK7Wm/0BVYB08jYvhdjWQGfraJrK?=
 =?us-ascii?Q?qhKDYGNNnad8BtMdO3nPdypEOHqTJF5OCLYuqn6L4StKH1i6W0EXwU09pTIr?=
 =?us-ascii?Q?QHIJD+az2zaZuJP6FGzMKWKNeNeAsChj1cbWqTUDs9SukEjCYGmHnlsP2kkW?=
 =?us-ascii?Q?aReQy8IR7mXB1rI3gKVeimq7hJL47261FBu1OW+jKW3X67iM720dq9KGsPg+?=
 =?us-ascii?Q?J1V0t5bW/7WCSdYh5AJPMoC/G69YqJvU69S3j3xtg92Hw5wXLIjuUDpIQYRP?=
 =?us-ascii?Q?x8VARPlMC1uo0r3EXGn1axjyVOzbchqRDgeNfs1dOKqqxQrqrBtgrTUdivpG?=
 =?us-ascii?Q?ezCeCS/vVynbg1Vs0ViPocuXnhyp+dr8NLYD1UQN0Vq9TRMG950uPxSp8rg2?=
 =?us-ascii?Q?EB8HO4wOCk6ryI/NLZL5XJjc8Ld4CtqW3yRaCAk4+CTR8DT30a2DHdc4DBlj?=
 =?us-ascii?Q?a/+0BZbYkoGMjrvFkFmPuQ6UowMDVSogQxW2rCjS?=
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
	w0nUdI4PhzSL9Ik3117TEXX3T+lxIAOD7dkZXSvHSwcbX1/Bw0RTkqpmFg5/tjWWbGDmhNQLOuRPJXPoUCqfLCkU0CPYF8owDCjQGIejF8QYhNF7wHTiNxG7IvO5aVFWyrAaK9z0gfPGGFCYitP/kllx83HVDziGPWcxtFSP5DUHw3237+GZyd7hoGseqBbM8mOMln5ErrJHC00EqL+FIN/3bLQeHWcALPEO9xXLqtNzesHdGrNmvMvC2iYU/UM8dy/57t45sFdq3ZAHrX7Aj87rEb6tc6lG6LXyP6Zp1rVwPl6EH9CzOTrpZAqN7hlF78irec7AA51/hkZHQw8fTr9RjiAD8vIFK6xnhFuyoFBh+JN0jGv7cMZ4hsx7nmEAZyAkTJuoH8Ii+jKg30ZEKJyXqHeayUOSkhiFhnM5aHOOm2iTHODQUufEw0a+VP0rFOJJegyk8wxgfAqA1tbnWtkJIoKuaUDFgc4zgjeWAPr3xXMWMc9i0m/r+z6CcpakLoi9Ek9Iof1NI3SWUooGJyD7PZkcJXnlSjqL8SL0tOarAdIN6RRK29UqL5/hWk49I1TXMw9KuvKFQFSaIVM+4s7Ee0FZqeFkGZxp//R6Ohoup2EdlYRSdjyjfinwso95
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf7100a-1ab7-4918-d57e-08dd1e8ea8cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2024 11:33:42.2387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M1FIyMrHyvGzsMtF9TqbDXVP0YmIIvp7S9XXpkukLGoJwg3Wgu+KMqEGZ5JNb/CNkOFJ53JMx1Fa2P5yFP3Sow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9416

> We should remove the bsg device when bsg_setup_queue() return fail to
> release the resources.
>=20


Fixes:=20
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Once added, please add my Reviewed-by.

Thanks,
Avri

> ---
>  drivers/ufs/core/ufs_bsg.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c inde=
x
> 6c09d97ae006..58023f735c19 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -257,6 +257,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
>                         NULL, 0);
>         if (IS_ERR(q)) {
>                 ret =3D PTR_ERR(q);
> +               device_del(bsg_dev);
>                 goto out;
>         }
>=20
> --
> 2.43.0

