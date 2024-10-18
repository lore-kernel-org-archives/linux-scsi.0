Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E3217332B
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 05:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230665; cv=fail; b=QPcXqv/7MG9bjQc8ZsF3J2ZAF+x5ylHxQHUFZGyrNTz2bxJ6njTHHx3jsVGEE1zSzodiBE1Z5DqqdPIaAL1Z5V0UNs3tfDguJst5gtV7t+m6MgTN4g6YwKZyp6A03HfoX4b6rnYWu/6bmKiUoybwWtKAQaaRS6hFVijGuZ2FBNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230665; c=relaxed/simple;
	bh=2On5WZFqQwUROJAkT2az9GAkZTBBhFRoQ+r05d3vEV0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TtM/xMpCBmvO2Nnt+HRCbgmd0fIXik/G6dW1ieiLuCieeiSKzHS50Dq1o3WF9PfW2CN2BuMxxx2xU0VdJegnr41VE8gIcWD/9wkPb22MlT4JLELlopNJA5qLQu29zznKJ+Jxj0tHrH7eDbtwutoSHsgZB1LgToesWTpMpbgPSEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LZsBYYzm; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qoe4EFD+; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LZsBYYzm";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qoe4EFD+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729230661; x=1760766661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2On5WZFqQwUROJAkT2az9GAkZTBBhFRoQ+r05d3vEV0=;
  b=LZsBYYzm839KMqaGk8g1y1qxKIXR9q7EZJseoLet/RS4g4TghbC/4MM+
   LDmiSBu1rE1fr4T7bw9YCvtNHYQhqDndfBNCUP/c7lu7HPTdPboEzjcu4
   UyE39MHKq+UsTrNi9+SRR93vgB7X94wmIkS2Gyrjm9qTb5Pf8ZOdX64Or
   KezjZ80pWpRxbAAaAeUrTgP0YErLTGKOq4DwA/79dycAUU3qedsmlfBIL
   OQ8diBtO/R2NivOqubYwAcXWrbCCiK5HFB1+ctwKgRlHFAqErRUlrmBqf
   OqWRnjX2Gkt6qItNIqmN2HyWv66Od/umihaWMbC4k28jApF3ZpsP9I2RR
   A==;
X-CSE-ConnectionGUID: EC3HmFoPRmWachcsejq3JA==
X-CSE-MsgGUID: e7uLwNpiTKKlkDQwk73nfw==
X-IronPort-AV: E=Sophos;i="6.11,212,1725292800"; 
   d="scan'208";a="30203273"
Received: from mail-westusazlp17012033.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.33])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2024 13:50:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inmFtXuMHxuz/xjHXddfDS8yYp9R/drXHoOILqXB/ZYOdLpLtirqogSQEULVT+TXWuPtCq0+k02LJw3IsUtypU1TiJKzA9k5+Y2BG7+x1VG4EGV8/i6zuzn3gNcKOC1feIh33r6oBDKOd3p6CWoeA8xd68z9x+dSGIrHHJ90wmKL/l75Q/hPsiumsQ4iz56TEz2uuxie8BMNHRVQTtZsZ3h5Q0M8pmMX+zmxh5EcdmSiCVHNXpfjNUrKzfM0cuUU6wuWaiV4vwbDf24ybyFGOzvppJDWNKRM9Ug9njjRCWjYwWHPQAc5qnr6KFZ3MRGR1553SD7jkm3XueJyGYsqUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPWJTjtw2BXDaZi1ZQeS70FqskcBgGHodRFRYxNtJkk=;
 b=xkI9AtYU1uB+dpcy3RLBOzhcJ5RQ5vhCImZdnwTtF3yMrZCwv+SZ3dvEbFPe1oI5WpIGPOGo+3PWC/NUQRxOsEGXASY0/jirnd+R8nAM8frAhaSz3MSjuTMJDtlBk2fCg/U4daYX1E1BZTMGiCfgb0koNCh3U5TEB2pQOL6LvPuly9U6qt8qEsS94tAYy2mgw4ehQV785aavNR3yBkpqbd3tCBGJVwhIsiniOwTpaT9D4GQcLEmfXVPsLodWcVPf6a3iDTEp5l/qZETlaNyMwLiAUN40w1wbAFiXVpNHakpNlY7ELA+dO/8k31oY/Hfn69wmZL1hgtk6NWoNPAL2uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPWJTjtw2BXDaZi1ZQeS70FqskcBgGHodRFRYxNtJkk=;
 b=qoe4EFD+t2sfUxeypiIa5TfAQpuU09hLCvQFHdfLc7KfZg3EO4PlM85HYtCb3oxizj+yC/7Z2X4nu35VvZjetzOI4EIMICfwuZiL2gzMaqghD+eOxkujBP7ckpp1y+WQ3J98oXr7OYiMICkFsjI24QjQe3HFfWje5DqzVlWeZcE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6333.namprd04.prod.outlook.com (2603:10b6:208:1a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.19; Fri, 18 Oct
 2024 05:50:55 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 05:50:54 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Maya Erez
	<quic_merez@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>, Can Guo
	<quic_cang@quicinc.com>
Subject: RE: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
Thread-Topic: [PATCH 4/7] scsi: ufs: core: Fix
 ufshcd_exception_event_handler()
Thread-Index: AQHbIBAk173eioiIKUyIP1nJDoSWfLKMAlIg
Date: Fri, 18 Oct 2024 05:50:54 +0000
Message-ID:
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB6333:EE_
x-ms-office365-filtering-correlation-id: acd11a04-aa38-4ea3-9b13-08dcef38d4e5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?5DW+ok0KbOMRX+zv3myIJjoLjWFguMNpAPeJkTIGQzr+MURliB7xXRSgmmzx?=
 =?us-ascii?Q?2uOkqVZ4D+BhYMLmhDbdf3++zAFaOCnZD8k7qLe16mGDYjlCSQv7zS9NGLWy?=
 =?us-ascii?Q?q5M/jOe8Ns0URsUsUvdF2aEtHgGqcdyz8B5Jibo+FMaYRJONjIIEZpqIQc0m?=
 =?us-ascii?Q?XAFBGueDJpzpz8IYH+Hjj8Rid80psGAJPtfY0xrr0MIsA9BBQvRlINnaKfWK?=
 =?us-ascii?Q?1wN5xRg+lnIBFBBfHMHsXM9cVo94HXpLmywl7BlBQP3sI/gRFb1dtUYJ5pB0?=
 =?us-ascii?Q?Nowx2Vns04ezNQWPhkY32xcV54ED1zkCV0ipXwYCRXBnreqO29Jn2l6He9Pi?=
 =?us-ascii?Q?ZSwOD+j+DdR+VOQLv5QKBgUVLyR1YlEll10ljNjayo04ZzCgk9GQ5kx3QS0M?=
 =?us-ascii?Q?yyE+uoGVTSCMFXGTf01X60NwfAXI/VXEVNbFb5Lp5hTk+6vQDUFp3fMG5ORa?=
 =?us-ascii?Q?qm+sKVnf1nWg9WiC+ooEWLuUIOSwm5NiSpDlWYXWfDhd9nGGTHJrZDZ2ZmAc?=
 =?us-ascii?Q?yXzl+OuVpKVvuZLXDlJNnf6wG0yLAfvG1C3oKTybkGAZXivEpynv9xtpYWYL?=
 =?us-ascii?Q?Yxcu6pzgCOmaq5FEMYFV/YkT+upGnmXIHBf5tUDZZoqsPkuN9c6zXdhIoWwZ?=
 =?us-ascii?Q?7/lYwoKxnjHaSTVEPIeNGpvXLE03l/MXBmcFxGeYbegVFXNV+nvoA/bPrGv3?=
 =?us-ascii?Q?Ub+NIVkkrLjeUyGQU8AM0Ql6fom/kyfWvqAleHWuXvHC/TPz1gOAFgntl+HN?=
 =?us-ascii?Q?xj3jJ2zuxeYQ6ZFu9XpKihYqI88/Zk2y+l3IKKbo5zlbQUjvUqb3BvBpr9cR?=
 =?us-ascii?Q?Bwl8963MC6V7U4Mzj2DrYwayVY9BqJRpHPrkw74SX6cwfYnFaENuDQcoUUjp?=
 =?us-ascii?Q?oIIT8y1g3euF5PzsGwinLasX52QW/CzgsLVFqhmFRj/6srcSF/psFDyi6RpX?=
 =?us-ascii?Q?3pCKY/3wgAyjQIxiwNlo+QwnAUXf2ChKnYc9DouSm1+GVI8HzdRKOCZWkNyY?=
 =?us-ascii?Q?6hmCvY8OlD++dWduP+FWkTzNHcLUATnzpeZiFuuw47H4m+Ao7NncbtSMeB9l?=
 =?us-ascii?Q?6fYql9t7LDuKdvPCJuLbeo2YMgmpGrG/m9xz2IbSQoe3npguXoPgwAKUn44n?=
 =?us-ascii?Q?Dnm6SXGgTclxMtyySv/7rVsZXfYkdTD+Xi0MYqd0xjjkMeNMeyR2iyWWCb5u?=
 =?us-ascii?Q?OHwJPGNT6npb7KZnEWed0ocnLo/lmI7J7gdP0+lWEakX+y7vZdPPwHWdKELN?=
 =?us-ascii?Q?mxJCYndhun9gIN8kFZqxBEZaYcnfNH6wuu+bRqy6pa45r0ZF6tSd5hdj1DWW?=
 =?us-ascii?Q?t2ZgkBTNo4QlMqQDzFnSfLCUOyLTiMjZ/rBd1zq6aRXyD3C1KKmWmyO97Bae?=
 =?us-ascii?Q?oEpe3rc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?aG134wwlzpJlOOP9SPoZc5cQYYbU43TwYtx3o378eE/ao1BgMZ/sR6UCSjSZ?=
 =?us-ascii?Q?FQdu0Zq0rt0ujdUgqXUExWYnOnzUCHjXQxwprumC3LfM5S2pOKMKBIq/vFs1?=
 =?us-ascii?Q?hid7lrCCLllXrYB0gU2h6qPuVLS9tSo7m2Ozu4G1XqDvl0ioWeAWuG6UKZaA?=
 =?us-ascii?Q?Vbu06s1ou3KbAn9AgTrQe2hn60o9godvllLUwAueaQLmghvjl9AumrAr2tJU?=
 =?us-ascii?Q?hm2hv9sQt+6bPkfviCs/vhkL0YyLjOoUS+X3FcwyMaEdK6GwTftlzkNbxzNR?=
 =?us-ascii?Q?pNOYzQBcxaSPjRMoN6g1eA9VUL35B7mCmmP/+vTFMD0UdJDaDj2MJ1l11Z29?=
 =?us-ascii?Q?51Jspf51IsH1N8aXo4gUM1OxNiCgCEsIcMlrbPrs0JPSQYMj55eOl39dVRbo?=
 =?us-ascii?Q?jey5jDbqa3r8RO5Or8LPEVs2GGRZKwVgZC2RBGlkn355x/y6ys5zWQwQxj9d?=
 =?us-ascii?Q?/d4+f+h83VEzK5sP8FZOtHjioSvDXrjXdccB660LvQKf9oGrnBzQgyp5hIJi?=
 =?us-ascii?Q?cLo+FnQwGx9lD8DGbCAU3pKEQ+zRFW/D2O6VrgCdApAE0apCnyKWw9695M4i?=
 =?us-ascii?Q?bIQVjI+qboQ9rfqlGnsKetqZYSaP4nRcDqpeNJEsos3LMV2rNNqSmPiJBAH7?=
 =?us-ascii?Q?ZmupV99LmJxe6s2xvyaeJJbix3C5gDyxIrY0JCMUDSHyLgeC6/IZRxWgv2IK?=
 =?us-ascii?Q?FqBYP1me0c+3cFAptFAeCKFHX5t4KoPYH5DsNKdM0wSKkKQ0ISv9pZIJNnIh?=
 =?us-ascii?Q?ngKsWJG+vNiOWGbJqwm59/p6TZay6Ck6g0orPBuByNV8xEUisdi64ykiWC1x?=
 =?us-ascii?Q?t1iOw3GMNamNdum9ibB5tBwviKDNBIoaSe4sFpzxFGqphjc4JxCFLYN9B/Eq?=
 =?us-ascii?Q?Ulo7vrZHRyHtFU8qkM7/sTFXkG+H3WOCd0Jm1HUUzJYNWvy7acB/xj0lNkuF?=
 =?us-ascii?Q?AUPeCGKZvGjqqO0Af5lwF46ZIlizaW+W5UNvL0uR/vgewOKv/Jf2jFLU3xO8?=
 =?us-ascii?Q?vVWTHb5LUZrzBtYeG6FM88PLZzBghFmG90A+8INN9cQLMug8ZqXoZPMZfYDy?=
 =?us-ascii?Q?9/prq1zK8x4OYnUqcYUrDBNSSvvto80sRxxHQK2TfqEgGPy8F/ZGgfcvVz5g?=
 =?us-ascii?Q?A9SQjQuzewx3PFPTkDa3c3jJ0qqeAVzuA+32BB94MJHtc70T0p83ZXse9MEw?=
 =?us-ascii?Q?czFAqaWImO5XKqPQoxTcD6HIlwuXH14F7QnJc6LXSgvLJ/i6X/oiib5tQNVP?=
 =?us-ascii?Q?rnpADZ2WbxvK05MRXlvCEcrN8TNWsblP/dODKaqChFEnePjl25Xjud++oQsh?=
 =?us-ascii?Q?lyqRxz6v5Q898PXFUokp5mwHstdpOajEzpAm/a3yJy9DPh4Y0Cd/srKq5sh8?=
 =?us-ascii?Q?9tX6A7pIfTYw/JlSvsKDJ9sxDmhYu2cjPTJpTZS7nvjZTliLt9998T2W0+dP?=
 =?us-ascii?Q?p/GzhLy00evN0ktPx0zTzjvoPTm9x4wsmyc+T4cFQpk5G5x/WfJEjpUD4zdh?=
 =?us-ascii?Q?EYp8tintd5iKlUCebaIN/DXA2qIKywdE5EHx7qqkuXUC8v6D99lvKCXWmNi6?=
 =?us-ascii?Q?Xw7QUQBG0/DCGouxv/pLp1E/W1WexVef2020Y+b9?=
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
	o0y3m7MBJdrkzzm+9kbs7MnehwCMayCt19SzHVxEsUTc0a/OAxtfYw0rvY3ttQ/QTboVjD42HOAu8fvCIbQvK2/SyZfBHuX28YTrYdcvOzSIBVK2t0xbYKoBD0VHdu5OY1loo5Lx8L+aFx5P+o8l1Wp/MsxouXHyoMdvGXcq+1sp+qDS4KbAYnVImKKbF3fzuVkL85Oq4VAtCJYz1kC6kqM1UN7vZ51tEffQnhxSpNKc7o10/yOsWUxiDGQQxn8V+aqqrLGhtDRrKHMKCsP1pBpe+gYuakplrF1qvMs40t2pLagAZ9z416mViWQs8Uramt87xFafNC1kB30koiMZ12/ZOJ7HJ5tC2I//nBXcT5sASAhz5WapXAPkDQUtQjEl4Xerxd4w1AJP7v5SpQtZrV6fWKD6lqssZamyearMQ094IGtY8InGapSSkzblE3HtstqUIBtneLA9WBrtDyCXKxvQhO8eSUhhGhNdtEwCvpDmwhT1rzaei1+pNjMlL/VnPtdJVdd1DOCtqL3EqnQ47x3zXVVgmqmJrpPrjF9u36g3fSfV5kS1GBhZO4oIGXu7t19Pvl2MdRErzjJmI80PW+7YERSWYYAMCk5WWJAzI4hCQBxl5k33eBCsh1PsCDlv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd11a04-aa38-4ea3-9b13-08dcef38d4e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 05:50:54.8295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iEpS7JBUekzLL/NyqnQOxRvAV35dWzjRjjADJ42G8rXchkyMPQHzg3PgFE4tfwg0vTbO8l1uaeTLG0fKaowDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6333

> Use blk_mq_quiesce_tagset() / blk_mq_unquiesce_tagset() instead of
> scsi_block_requests() / scsi_unblock_requests() because the former wait f=
or
> ongoing SCSI command dispatching to finish while the latter do not.
>=20
> Fixes: 2e3611e9546c ("scsi: ufs: fix exception event handling")
I think that when Maya introduced the scsi_block_requests calls (2018),
the block tagset quiesce api wasn't available yet (2022).

Thanks,
Avri

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 76884df580c3..ff1b0af74041 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6195,7 +6195,7 @@ static void ufshcd_exception_event_handler(struct
> work_struct *work)
>         u32 status =3D 0;
>         hba =3D container_of(work, struct ufs_hba, eeh_work);
>=20
> -       ufshcd_scsi_block_requests(hba);
> +       blk_mq_quiesce_tagset(&hba->host->tag_set);
>         err =3D ufshcd_get_ee_status(hba, &status);
>         if (err) {
>                 dev_err(hba->dev, "%s: failed to get exception status %d\=
n", @@ -
> 6213,7 +6213,7 @@ static void ufshcd_exception_event_handler(struct
> work_struct *work)
>=20
>         ufs_debugfs_exception_event(hba, status);
>  out:
> -       ufshcd_scsi_unblock_requests(hba);
> +       blk_mq_unquiesce_tagset(&hba->host->tag_set);
>  }
>=20
>  /* Complete requests that have door-bell cleared */
