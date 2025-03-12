Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E81EFF93
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 07:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741764839; cv=fail; b=JMU9NpKPTdd59vJmebYyfE/BUrdERTExnoeqjaCEi/dNOwoIdJ0QKlf3kuzYLNDrdIr/9s8YqS6KDaPNzobkKeZsNDlLICdpM5X2z9RPgZMpQ7HEvGLWRZ7aRrJ2eKiKxivbDtB9FxlV538mWTgvso0Sj+4CigE/e7AjaemvWU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741764839; c=relaxed/simple;
	bh=CbXUidufA6HzcsK+3lYH/MlNrMFemQm0ktHA8bQmbpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IFMpK8cxnQTgKAqBISZtZroRwuEliv/IzU/+2BJURAX/FeHIMJKVtcI2EPJcmAQA/FgFZouHg+U8RBYDQ14zTZcCGwPfRHsU32TY4nBdm6ex+Wr7qOGOiZvQoAJc3zKVGGkFeoPxKNkJS/gRj1D7MrysGlkwt2YNgEeyBQgszDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=BCuAhYmK; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="BCuAhYmK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1741764836; x=1773300836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CbXUidufA6HzcsK+3lYH/MlNrMFemQm0ktHA8bQmbpE=;
  b=BCuAhYmKTm3pp2ELnWM+irTRD843uulptTk4vD6z+p/P9sDJY5C4Y+HM
   lMF27uwmkZnt4hji2fwanM2HheHpVjEOzD4+fmyfBFbDkSY2g1NcUPuOq
   7sp0ij7LS4QNUGr0sZMo6QTM8Ad5uBfZ/mYxVeInp4+Ycyau3clBJ4857
   5hFA+s25bgDheqBuyxLKd8wz7kqk3v0b9UTSr/WMtupef8dbszfT0/sxw
   DSOIy5Pq7SDLhpIdZ1nWU27cD51j25Zpvggl93jpkTviFfGiFrrilw9To
   h10Ys+9S7hC+IJe6/bOrbL4MBW7JadK06p6PpTxDNnZGqf/BHmeCU2KjB
   g==;
X-CSE-ConnectionGUID: UZXdce8ySHyS4MvQdXetRg==
X-CSE-MsgGUID: yVYaeVHzSrC4BFQpm0fjhA==
X-IronPort-AV: E=Sophos;i="6.14,241,1736784000"; 
   d="scan'208";a="47670213"
Received: from mail-dm3nam02lp2046.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.46])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2025 15:33:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzs0Vb+1nsTE+kn/AGw46RBoT4Frn1uVk9c50OSArsfz5TtFt0DnWB42g7Ew3DKJPdomy7cO7535GjFxeiLWad1CYfVVUwsh+1yHueKNXePJSCWiCsUqTPylJyPVON9jo1d+GrGyiKMUmH+PaLUb0/z1+vYycDCd+R9+cDJW9EPoaNljGmqf4kO6HPqUnDU23na5aOrG1GnZnElt5GAT892YHCR0GMXAuzUkKNhKcVfIZRuMfRpASIvp/n9LOCPZ/+YxV2IgMROMENSnKwjll0AopqdRuHNm8APU0jAFCY1wV6pAhNMLlATw2P7dn8TeDm1w8hvGj0h1VHKJZsgCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIQMHa7GKq45KJuZV4q6y7molJynK0q10Wx5w1Yfyos=;
 b=VkeeWWIVKQkQuIGmrPe32jRVk1TlwIdqRMfZ7lVYo9eaa3n1o36hoblB95uywsq9s1ktt5bMEX4zMp9J7I6Kyr3hITutAN24iFk2sy2MddwZtPSkIVDAi6IndJPY9rgi0+qZWHmXI/iUZwy4ZAfYeAJsMIWZIK1F+Orsu9S7FcsB3sEcw2pMeLgnzMPMdof56Qh/3iRJiENYGrWMd4aJ2CExZ4d7QJvY3Gg9wncSC4Rw22CezCFfuOygaEDI2FOFEArZg9H89jIZ9xmvYeE7Gy5k5p3ndHSY39D/WVAd4TNUVEkVV4PLZMUP75WcPZqRMqiPq6Erl/wgkjEl+OC3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by LV8PR16MB6007.namprd16.prod.outlook.com (2603:10b6:408:1e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 07:33:53 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 07:33:52 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Eric Biggers
	<ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>, Can Guo
	<quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>
Subject: RE: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Topic: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Index: AQHbkr9r/c8CletXvEaSWcdgfTeG7LNvGcgw
Date: Wed, 12 Mar 2025 07:33:52 +0000
Message-ID:
 <PH7PR16MB6196B6AD43F68C7BE8128332E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
In-Reply-To: <20250311195340.2358368-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|LV8PR16MB6007:EE_
x-ms-office365-filtering-correlation-id: a65527ad-7419-413f-4d0b-08dd61383d1a
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?uuZnC12z5PL/qvOQMNAtgqhNRvWB65YpdBgqDmHWd11NSdKEoHLaVbvChcbn?=
 =?us-ascii?Q?XChKN6BNmyWlmv++/nvDYyHJ2GTGdusz6NBBbZ4X09+yIqrghxiMHYxsB6TU?=
 =?us-ascii?Q?uzzzu/tvUwQ5LuCkYieR8Sln9KkvikYAAgGqr91FnVLlyk+TcDbUJxwS2pe6?=
 =?us-ascii?Q?Cj1kIHTEdzlgIyHPcwbIDzaHjJAAF4z4GyErOyeOdXap4d9xw7Gr9DERB+Ni?=
 =?us-ascii?Q?05GXnx19Om1AGole43xMveJOc/MGRfUiSkwy3EFOOAr3/6VE7JdM1A+/R2G0?=
 =?us-ascii?Q?iZKOqsS8rb30Hm/efLfLiWjIIWVgWice1fcFyUTG653mT5nkC98/Fjbx5CNy?=
 =?us-ascii?Q?hoqw0lHBocBkp8JIgj/PNn3wgyqq/D4qhC6r7zhhrCIg5n//oiBylXHfdiRC?=
 =?us-ascii?Q?ZkYC1s/qUzfeJuS04j0ZI7vncIN/v9I1mqmvZYP7MjrOSZSfBWv1uvMfJ8X8?=
 =?us-ascii?Q?0iIXpfVShVMGL8PFBURL6Os6mIr6YR6ApSKp0HVPXaE6MXRBEzLUrK9bPKRZ?=
 =?us-ascii?Q?sRikizf6nOSKrVJNqkthQtZr1sSEumKK+E9DPhg3jtTNfAlSTYH1hMN/Ssr5?=
 =?us-ascii?Q?6wj/4MQL67JLKVYQBqV7O4nXiD/xJaa4U/6115DefbjJX1csge28QyG4OMk6?=
 =?us-ascii?Q?+WwswAupJtXty73E02fyGjptbj64L2MQeY0eF0lXkNvpejXkP329YpTQ3haC?=
 =?us-ascii?Q?aiwfeTVPiVMVFoigy+HGZrP+ROb9jI2qxnP2tXCqJisq0oJzRtDUdTC6nYnZ?=
 =?us-ascii?Q?RaBaXmty0VSHAWwxokUS7Pxm67KWCJEceYFjRs5ATYKbUklLLK6LatCL1WP7?=
 =?us-ascii?Q?UZMBctl1SrYUOIaeJVF73QdoeMFCtFhHhbnfqLVCLWt9ONRcvabSxpvr9AGi?=
 =?us-ascii?Q?jWc0+AFif+8LYuyII4bT2TLpno3E4o6DFuuOrmquzsFvOhMmMwF0tZZ4V0fC?=
 =?us-ascii?Q?DTsWBoJnBl8/gJhKBBnl7m3mnEVC5zVQTUjZzGWh0AfbvMNTiimbK8CI1tXY?=
 =?us-ascii?Q?mSEDgMGjgHnKDJ3d6DLGKuQy+G7dowwm/q3X5Wf0X/k83C2tyFU8+XCqUgOO?=
 =?us-ascii?Q?jkbZg/rYejgxJq5t1STBgrB1X/smYwv2EtgU6HXgqR+h/5zoHOBqCFWSOiDY?=
 =?us-ascii?Q?VJNpUOE616JyVKF+EH86SBLw51fSKYg8jaXRAHXjJUPVUgcp3DDwOhqzetPa?=
 =?us-ascii?Q?4IiyCuGjyzm/YQ7MikUQhXx8tzJmVLNicIFMuuaLs2p45WuV4C4gQtpzXQPQ?=
 =?us-ascii?Q?gHQsZhPHqPsB0PF54X5/3Fye0NGPrpEuAkTLEq1N2g6sMeKA1nUXZlGE8BSL?=
 =?us-ascii?Q?Azt9J8XXFEAiZCOk03lUh0tdmIvgkeYsZpS2lzD8Az8uZq9xN9q4F4tzilhw?=
 =?us-ascii?Q?jFkVZiF6YVbr0QMmhgQDt7+/iqvBXVqMG6Y27g0m0EKcUSykiBSEpQdirsPb?=
 =?us-ascii?Q?fkQXXDeYcgnlg6UM79ttXsx0PGt8YQ2W?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?BSEm2RiwxcnYKCGjOyc+9MuqqszA9UKEDfvPkfXnJH2Pg7+1Ld+eRO+Iiugy?=
 =?us-ascii?Q?6WN+NbZ9VoiqJCSRYR1C/MFjlwM6v8Aul/tiyhZYC2WuoEO9pXLGEvd3dYdP?=
 =?us-ascii?Q?cVYw2LBligOF6DjB4AZCbaPfOigGtvmi50cjcM5ChVNXsJweG2sawlLVeApD?=
 =?us-ascii?Q?ikmaNBUeKIXxrIsMbHoFbhDYxXJoJKkSDTyIHsBHeaZV9Af84o1O4L2l9ZWp?=
 =?us-ascii?Q?bSw9BLZUKHzbBl21rMTamQ3v3sZ9ATl9XlM8sYJTPucg8OQdwu5vxJVdHsdC?=
 =?us-ascii?Q?nGb4Yz54MOCQ0gLPMwBPH80Jxwoe1TbJ5nS4gyPUuB7TnbCmRFhc/nzfv044?=
 =?us-ascii?Q?sjtuj82ZMDa36cJjVgSyaqBcjlhmN8w7sr4i6uUNL+f4gHrUCEnDJR+YpjpD?=
 =?us-ascii?Q?22PSvBdaeamrWmoPWf6m7qKylo/5P/zixZp1SCVq9NAfS8ny+WY+KvkNWQrU?=
 =?us-ascii?Q?X03nt+3+7pgT+bTbqPXzEMfoCQsKqYDLThvPfiWTYqLs/RNxnJS6Fu65l5Pp?=
 =?us-ascii?Q?tpZRp0ugSzLZbEq4drrl6xRNqmdUoStWTvqRUWnYZPfmR6D1qynPy+aXU4k+?=
 =?us-ascii?Q?4RWDg6tS1ULuz9U2ntR608YrG00FGwZA/UT8LOgOnwhn54h80MegaYLyWlLr?=
 =?us-ascii?Q?jHXuC1aX84tEYXTIhWyt4SAgVksDzl92ySoXja4GJvDxoxV1x3FkMxe53Fzw?=
 =?us-ascii?Q?j5DtOUpPllVl+nhTpm4NFng8QnSU5pVOVKzbrOQ4HFgcVRVB6VlXpm8IMRw6?=
 =?us-ascii?Q?ev00MxJtkUQ3o/Gp66QX6oMmBczAH+AXJ5gigURuaQ/Gq3w0E3o3vstU6kf2?=
 =?us-ascii?Q?pNnRqlwEZjLSX4g0sKf/zDg0ERtGy9Fr1o//HiPazCDQCf5u72lJ3hExZgfv?=
 =?us-ascii?Q?KJtHYm6l/Xzu9mTXCSpoFxVDxxBrrd7HLFngB8SEEWAbrLpRpRNSE/Uaxb/W?=
 =?us-ascii?Q?6jU7uW0ZVHPKEyV+i2oS4r1+u8OsLZG88qg7cbLHZfVOuDOi7xbgriE+28Ay?=
 =?us-ascii?Q?3Dsu6V3xHsBsDQgVSmpVyL62iGsh5Pc6yLEY7eQCcdVMSQGw+WMTsxDKJQ6r?=
 =?us-ascii?Q?BmUgIgcrqWqmjmwfPK2Qk23xUR7N/fNNWQ4XB6YQF9Ou+mqH/c4yZujdjWTQ?=
 =?us-ascii?Q?g1x7I5J+hFLxsUhL9acSP5DoRikRA03GirsZ1GKfn1YTohHuRSBN56jlsNCl?=
 =?us-ascii?Q?RFQWzaB4qQEICZWhzB65tw4roYn0oBA1N4zmq2kz028gmcBZ7CIhreUuC/fP?=
 =?us-ascii?Q?8SqFAOpmznOtBxH7cJu+pwkgZs4e8arjF6eFPHakuqrzB6wFdHCNvJk7GHsU?=
 =?us-ascii?Q?9idntyfEX70DyNkhYpMd+Q0IptPjOU4MxPzMaAFQMGP2uGPVBLyCVqYep6XV?=
 =?us-ascii?Q?f4MtqXm0zNOaWb4ON/xjbCPE+d/U8GwV3BJT+6OgsvK4z2D6P6ZWNkfLKC+a?=
 =?us-ascii?Q?6g4OLKvA7Xdu4T6CThwsOpdQ7C0NAF3Xa5l83S3cowDwHBPVK7Ng0Aj2Xt0x?=
 =?us-ascii?Q?Hf+ovqRyIvSw+v1BjIQBvZsELAtsMVUV6cSMqz0BtzY8H3xeeMbOJhjOm45z?=
 =?us-ascii?Q?2yi4GgfY156X5mM0U9ugAXqHfg0D3wD/9bM+xGtB?=
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
	MD1A0YEpvDXZP549NHxvCkmmtzQXOlzFVafGuTOJoNoR9RnGZlk3a1YduU6e4V32NcHC2TxXOxK1x5uPTTATe+suMJ3XfgWBmezmH5QCReKCpmR0UKsCJYrNq9k6kaI7f21b9ocA8APHSIL4g55tEksnMI95SFIYtlr5zWmCXq1Pc+xg2iLsqN28/D/nYJF4BScOMLJG/m1SuJBH5tQ1+eH9YXxTzLxT7eV3eF9oBp6aJ8AnESCjP9GcvWi4710q90v6lZ9xynRjUbkZ8kUqs2B/9uC6v3J7UpRBE9EqUoGDpQUkDldRiSKdbv0sadFZnjY+yX5Gng+H0YxzO1uL2ByKksV+J45EIqfgN1B6qoLAry4ua5Pne+8ARfBZ0512CK0PUmjXzZVAWaZtQXBQDYs4wAobEipRy2ayWalNxzdkgDBvlvIEwV3xHPO8tI0thmYwS7CdueQ+CagZuANuxoPxbNKX3Pr95KLISnRrK0OsSRrUROrYM5HOv9OpKWqw6310KpbO2c/7qx1cQKSV13h0rzeT8gU3cAzcsw5zf636l65s2KQ5j7WT0sfrP+npVXgnD17Hjl/raSKdJwZF4ghuqECsyEO1DxmwXT6ouuU4oHRC8KokDZq66E+zzdHxK9hOuDG2eVDsSJbQalaczg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a65527ad-7419-413f-4d0b-08dd61383d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 07:33:52.7060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5b+XOWIrNLksO4xAagbEEuBD6dPtu+Zu8hQKgNgmhCH2ArTBD6GzckBw85/0r7dtwjdFLHJX5i1JRGD7EEuozw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR16MB6007

Hi,
> There is a TOCTOU race in ufshcd_compl_one_cqe(): hba->dev_cmd.complete
> may be cleared from another thread after it has been checked and before i=
t is
> used. Fix this race by moving the device command completion from the stac=
k of
> the device command submitter into struct ufs_hba. This patch fixes the fo=
llowing
> kernel crash:
Can you elaborate how this is possible if there is a single tag for device =
management commands,
And it is obtained under lock?
And why making the completion structure persistent beyond the function's sc=
ope solves the problem?

Thanks,
Avri

>=20
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000008 Call trace:
>  _raw_spin_lock_irqsave+0x34/0x80
>  complete+0x24/0xb8
>  ufshcd_compl_one_cqe+0x13c/0x4f0
>  ufshcd_mcq_poll_cqe_lock+0xb4/0x108
>  ufshcd_intr+0x2f4/0x444
>  __handle_irq_event_percpu+0xbc/0x250
>  handle_irq_event+0x48/0xb0
>=20
> Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 24 +++++-------------------
>  include/ufs/ufshcd.h      |  2 +-
>  2 files changed, 6 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 4e1e214fc5a2..23ba3f540f27 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3176,16 +3176,10 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>  	int err;
>=20
>  retry:
> -	time_left =3D wait_for_completion_timeout(hba->dev_cmd.complete,
> +	time_left =3D wait_for_completion_timeout(&hba->dev_cmd.complete,
>  						time_left);
>=20
>  	if (likely(time_left)) {
> -		/*
> -		 * The completion handler called complete() and the caller of
> -		 * this function still owns the @lrbp tag so the code below does
> -		 * not trigger any race conditions.
> -		 */
> -		hba->dev_cmd.complete =3D NULL;
>  		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
>  		if (!err)
>  			err =3D ufshcd_dev_cmd_completion(hba, lrbp); @@ -
> 3199,7 +3193,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
>  			/* successfully cleared the command, retry if needed */
>  			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
>  				err =3D -EAGAIN;
> -			hba->dev_cmd.complete =3D NULL;
>  			return err;
>  		}
>=20
> @@ -3215,11 +3208,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>  			spin_lock_irqsave(&hba->outstanding_lock, flags);
>  			pending =3D test_bit(lrbp->task_tag,
>  					   &hba->outstanding_reqs);
> -			if (pending) {
> -				hba->dev_cmd.complete =3D NULL;
> +			if (pending)
>  				__clear_bit(lrbp->task_tag,
>  					    &hba->outstanding_reqs);
> -			}
>  			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>=20
>  			if (!pending) {
> @@ -3237,8 +3228,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>  			spin_lock_irqsave(&hba->outstanding_lock, flags);
>  			pending =3D test_bit(lrbp->task_tag,
>  					   &hba->outstanding_reqs);
> -			if (pending)
> -				hba->dev_cmd.complete =3D NULL;
>  			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>=20
>  			if (!pending) {
> @@ -3272,13 +3261,10 @@ static void ufshcd_dev_man_unlock(struct ufs_hba
> *hba)  static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd=
_lrb
> *lrbp,
>  			  const u32 tag, int timeout)
>  {
> -	DECLARE_COMPLETION_ONSTACK(wait);
>  	int err;
>=20
> -	hba->dev_cmd.complete =3D &wait;
> -
>  	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp-
> >ucd_req_ptr);
> -
> +	init_completion(&hba->dev_cmd.complete);
>  	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
>  	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>=20
> @@ -5585,12 +5571,12 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba,
> int task_tag,
>  		ufshcd_release_scsi_cmd(hba, lrbp);
>  		/* Do not touch lrbp after scsi done */
>  		scsi_done(cmd);
> -	} else if (hba->dev_cmd.complete) {
> +	} else {
>  		if (cqe) {
>  			ocs =3D le32_to_cpu(cqe->status) & MASK_OCS;
>  			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
>  		}
> -		complete(hba->dev_cmd.complete);
> +		complete(&hba->dev_cmd.complete);
>  	}
>  }
>=20
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> e3909cc691b2..f56050ce9445 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -246,7 +246,7 @@ struct ufs_query {
>  struct ufs_dev_cmd {
>  	enum dev_cmd_type type;
>  	struct mutex lock;
> -	struct completion *complete;
> +	struct completion complete;
>  	struct ufs_query query;
>  };
>=20
