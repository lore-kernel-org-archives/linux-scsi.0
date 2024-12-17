Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9A1F03C7
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734435138; cv=fail; b=WZH9K3+8cAC747NCpNTwZOPRbzFAtMWVkrpFc0rnaicRla8S4DybdmsW+tC3aPYG/0L50t2omAlwxIG7MOal+LzvJE3KI/gT5iZ8Y1iJHOdqqKfrgmfkqcj1LPwii8zaNmwOHObKFj5UA7x84EZreWY0i0IX+zoJY4O8MxzvXbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734435138; c=relaxed/simple;
	bh=UVvA1chH9g0alC65VPdZPe3LO4o+LHBA+r8OCMeaFR8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=du99HEmJKVFBKlQK4Nme2MgR4vZcPy8R9a4nl15+KZAgSb8eRZdsT7p6uYKTnoT9vkYYI44EwrSwLu4a2GeK9zmFCJekH13arOi8EpNokolbecN0RR+Ao/FY0A/iWv8DfKX+YFwuZ+FpEjLPecdDhwW8zChO+iDTd+bMBH2M2nA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NrDK//dC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lH4d1Soa; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NrDK//dC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lH4d1Soa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1734435137; x=1765971137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVvA1chH9g0alC65VPdZPe3LO4o+LHBA+r8OCMeaFR8=;
  b=NrDK//dCz+rZhNPwYLBwfIugXr7qSXG/jQAGnvDUHtRhuIWlpkw0s/Ba
   qF79yWF0S8g+oivcX8HCsIcRmB2h+UZsLveIIV5UFmlH+pzWLuS3amSlS
   bqMvGuLwzncptSr61ut0Ns5fqnHL3vvJwF/a1R07yfw+DzUZb6VQcCfKn
   69K2G2dHuMlA1aOQsXS8zZxImFNgbt6jgfUCHZ1gCmpVEQN5LSgYQgnFZ
   mXORQfHTUdmp0yRS2oTdBET3AB7a47+HrUQu68Hbmm7yviGejfnLN3rFH
   JBJHq4IUrEAfghzd5zgGS7xSbrDT7ur08Dj8XHoVGVnQ5ZNSS8CNDX5pV
   Q==;
X-CSE-ConnectionGUID: n/lSWY1aQKK+tYLF3oF9DQ==
X-CSE-MsgGUID: CjHvxCUnTN2xXvY7rSlKqQ==
X-IronPort-AV: E=Sophos;i="6.12,241,1728921600"; 
   d="scan'208";a="35083044"
Received: from mail-westcentralusazlp17011027.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.27])
  by ob1.hgst.iphmx.com with ESMTP; 17 Dec 2024 19:32:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NujpvkEDCGGzVzZTvPT/jOjFtUPmcKxbtSsok04NUfYfMvdS60AwdbWbb8p8tcI3oKAo71hNgCZJYBSDNh2/mLY8kFKK5Uatfx4Z1WaQjcoDMk5r2LrJcFJT1pmwWAnIGjF5vYQOn9yBD90UySKgddvDevZBkrK6L2pa4U+va7QpNmb1vSvvt5LcBN1LGCm9pw7jhHKbs6OsTg53QxtyoFAuT9EB5r6H66oxs0JQQr4lgS6XVeoreahfCtP7VF71X9qWSyjI+43yzL3vsiJoXSCiwrffdUsj8GkV3T18CA06wkvChdOPrBaF64HHgGp1018/7Tk1qXLVqj4J/Cex6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvheJAGbkPHe9mkBhVBxkGWfAIgvMeyshPkoEh8QfqU=;
 b=ps4EcPHXaaXOz1FhzukBVy+n+D+mKd6G+cTpphAuOpfDcox7afgXJaPDD7REXtigC/nH78L+FxzKVR29BVbsyZJChjJjvjo4+HgPY6RBOETFF5Mb/dV8+nzsiRuDoLu4RUo86b3L0UDJUJnytOZEMIvfeT8lxbD0BqEikChb4/IXQwU5Dr9QK92A3tQxLGOXSBz8knWvWBgdm1WM+3PwvO5uSzYL7b9UEAHCZPYBA2/5T4Z7ITiLIEam+LAEsNpdChAKMMgblsdoSAGhrc5+4z+ky472wEGWmYYGBRHL6fKU87tyGVXu+iqGfyiJOsUoY5uT/o9niLFkXR0e7t3+dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvheJAGbkPHe9mkBhVBxkGWfAIgvMeyshPkoEh8QfqU=;
 b=lH4d1SoaQYdTazSon52TAORoPodMfyQWlGCnjaBKV+gUQ0OxxZH9alQAntQzYUyP15e7Le6/SNyNvvEjF6qIQonKdRFXOkVgllpyoTRFvJ/5YNJ5H49hAGUHbYu2NHE2d5bPQ70c46w/beuQ8id3I3sEoiR6ZP/RI9gGgmxDN18=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DS0PR04MB9416.namprd04.prod.outlook.com (2603:10b6:8:202::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.21; Tue, 17 Dec 2024 11:32:08 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 11:32:07 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Guixin Liu <kanie@linux.alibaba.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: set bsg_queue to NULL after remove
Thread-Topic: [PATCH 2/2] scsi: ufs: set bsg_queue to NULL after remove
Thread-Index: AQHbUHKyroxk6MYHu0yfFKUxOZ827LLqTYnw
Date: Tue, 17 Dec 2024 11:32:07 +0000
Message-ID:
 <DM6PR04MB657595212DF490331677F506FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241217105840.120081-1-kanie@linux.alibaba.com>
 <20241217105840.120081-3-kanie@linux.alibaba.com>
In-Reply-To: <20241217105840.120081-3-kanie@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DS0PR04MB9416:EE_
x-ms-office365-filtering-correlation-id: 50e1da06-c11f-4e6f-f578-08dd1e8e7087
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?xa8ie0psFsze/YAlUC45+V/2oR0HVWHRMdupBVs36+tFH2kxzm3H5Je2Vcuk?=
 =?us-ascii?Q?cT9LL/GCtBE6R7TcsebTW9Pt0fu2Qk8j1sJtmgFaLEJNJ9QfmHxuJwBc0VRA?=
 =?us-ascii?Q?Bi4/UZBxq+J4PU37nWEy3hxwOfVG0XPAZ3a432AnZtUn/Kk4wDavMLyH2Q8l?=
 =?us-ascii?Q?xsW1MEXRkPveoZODuNl5esMw6eTCcUhFdlWej+FHkGujcgdgYBstSbohva3p?=
 =?us-ascii?Q?7IHB6ARvD4n53IvMnGZ1OZZSH6mqR20HNXMI8T2ciCR1vyfUvKIUPIt7Ckep?=
 =?us-ascii?Q?uxevzwajJVvVkr+iTpND0k1nXyeuRVzXfIGOGFY8LdSOrzOpSK12NCp8FkkV?=
 =?us-ascii?Q?/2dFPFiIw0yj7Zo1+Q+i0oBbNuVAFfUPedX8lW09l9VNUPnyszqkZarpFMve?=
 =?us-ascii?Q?Qy7ldqgfD+C8Edbh4O0TDlBEBPwV8/Dp9KCkCGwdLEq/r6wBjiOtb/J6sYpM?=
 =?us-ascii?Q?s7tPLL/Ge/mdQDnjDfZrFnbuTrpuXL/XZPP7VgJPmMJ2EZcOgQeOk6dDG44w?=
 =?us-ascii?Q?N+i+kZipkoU/fC3zMsAnMXpqUTLEcvZE7X5DMHBQ34mH9Yx5DUDnUZI6XZn3?=
 =?us-ascii?Q?AVJEnoq2dlny0IWTlnBU0OMH+XR9ndNtRjng5IUj6+D+QYRtuqxrcE+vZi0j?=
 =?us-ascii?Q?2o9fCxYUovaoWgYdX9LSN0Pn2TEXuuRXzLxMjjOQ/ZKXRr33t7iXGj0lV6MV?=
 =?us-ascii?Q?Ag8s172sETTjetg6dY9QFyO/TtWJpHx0pzmgvM3Wj2jjHoSv6PpW/BgWTqNW?=
 =?us-ascii?Q?5zBU0dc3L3H5UUglhw4SSx4AbsGXNjM9z4m1X1q11GhctrSOl+2slLDaXHoz?=
 =?us-ascii?Q?jkeYQpeIdNLd8B3SIiLl2Kt4CBEzEvvl9feWKLpRmy3NEnk59L6yt9n1nQ3E?=
 =?us-ascii?Q?csRO/rCn5qw2fWgxR+Cicg+hhargi62odoluymbDC8ZTwhxWo9hkL/1kq1RW?=
 =?us-ascii?Q?GQ2g6KXIVQjNUXBQ2xpm9fWHnYPPACRfPlzeOA63D8gQmefG4Grlp5GcvPjS?=
 =?us-ascii?Q?Cwwp1aPmNSFg3dNZ+4qOfgYcRogALHHcAHuQ82VKLhHKNrFPbLq16te+CKDM?=
 =?us-ascii?Q?ru+TP5luzdn82j2RK8J97beQQYyGLZzqE7L7yeKs5f7XLDJH/tmxt/5v2sLL?=
 =?us-ascii?Q?Qv+SMWg5vO/UW74w2a4Mt5N3xFmgCYW6v6IchiYxcnfe44D27nKXPVDThjZv?=
 =?us-ascii?Q?X34goqKCCLeb1jagrBQtr3Ccq58hlb1X1Xc9wrBatQBU0BQVKqQ0kfVERNiy?=
 =?us-ascii?Q?0woDu6F3ihqpZiI3O/VF3SoAgBqJLYWfFrQv3nNbGdYnDy233Q5i2r7IHo4b?=
 =?us-ascii?Q?i/e7dSBtnjzgeHFprm1b2iF+QJSIoUfaBO6Rw0NmS6WFpzF33d3gdqWOCuhy?=
 =?us-ascii?Q?Xd5GVSkFbw1cwX9qCIMBKLtmGs56Bge67p+JBlzpJSqwxp6xNIyP8PuAJ0AF?=
 =?us-ascii?Q?qeMtJZERu+b2vojqZzl6+ha3svRYbtFr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FtSMELEYss20EpxKHgO9NcGQ0BlQvejSHIpH1LIVs54j0FRpYBCnJu2s5M1I?=
 =?us-ascii?Q?MJHZ+tkAHi1NiJ2uxYFxxuMtQmQyWKkd5X7sEpzesP8ekLDUROUBPSnlRPXj?=
 =?us-ascii?Q?VS1fwgAMW4qLsfwQ1wbgZRCFheL/qEIzuU6urWrBFhuzsiJYwPmWiLvXN8LH?=
 =?us-ascii?Q?QN4QinmSUP1InSlo5D4ai0uCS1VrRb1ZacJIKBjO6sRMDDKUXqEoUQ5F6pZH?=
 =?us-ascii?Q?wcYHepbrZNGE6G0S+ELDK0JtaG0gA4giw67csI4F1Gro4IEjhUh5rZut+8O4?=
 =?us-ascii?Q?4F9QGcXZR51z1QMnTu/9h7tlPJi0OOR+IYkh2JtXw6N2+USn1vkisiLuzPYb?=
 =?us-ascii?Q?voHzTuOThax0zlFLV5DQAzCmeC+MWwLDdwQi39iGnEPcz8YhS7XnW9Nf8iMc?=
 =?us-ascii?Q?KXIeFeJ3M+m5BN7QIw++ABxWpZ1OkflU4v9m6aaU6ztQmEFSzUqL03Si+ory?=
 =?us-ascii?Q?hym5e6bDM1ACbaI8dZgv7nxOJRHaCdMi/ZeiPxWbOUEJUn5YMS97geKEAR1w?=
 =?us-ascii?Q?kCYVfFP3HtYBtkz1bYTwfjUFt2BL5XipsUzWSqX9TIrlxlQSH6WUl6HxhM32?=
 =?us-ascii?Q?pGBrdcXAxhxDuTpkiC0ycE6KMLITB9bAwnI1AaLdY6TmFhfBRDpQQskkADIi?=
 =?us-ascii?Q?Sr4WutyfBgWP5kdVBTkePcScehG4cIgsRQiVOHRgLjz+uFvKDV1cmUWdtXP1?=
 =?us-ascii?Q?jyXRJL+/WScOVEJ1YheFYjEBB/891x6n2eRN4t5HHVwiX3BKRoBzlWCC9jFG?=
 =?us-ascii?Q?wKImq2TJNnq3v6H848PZqQW3Fnpwzc2hff/HrLsjlOEF3MKB6bUnhlmbVoPp?=
 =?us-ascii?Q?h2jb6cL3OWi1K8bd0rj1Ql1uCt0/0Kgr3ciyeKMvLfLzAwCvngWM2huKrmBy?=
 =?us-ascii?Q?5G+7zNP9HtGvEc3DVSyFnDBBYXNGP7nE0pGYMPHTxrQ/9MufEB6r+z9h1qYA?=
 =?us-ascii?Q?CTzS9k83J2vhjhHNkKnSF4OLNcieCUJstRGgge2rAwze5s6rv2vn5Fw3jC19?=
 =?us-ascii?Q?K5mAy5U4/syQ/eOUm3r+2YGjdB0J+d3oGpRHenNRlR7cQklQpZ4pkZwlMgTy?=
 =?us-ascii?Q?GWq6lsUOUUrGf4SRWtYIgejmTVREoXMCDwK+K1Q1MM2Op7yxqIM4+9b4wNWb?=
 =?us-ascii?Q?je47j89bxyuSGrl4mk0t59JRIAD6QXnKObviE+bzahb1Y7RORKMJegyaNvjm?=
 =?us-ascii?Q?m2AT/BdeYJBXOncqIiRCrGOMisX5LWVWHmE+04WvCxtJvHcg/myHz0SnmAEb?=
 =?us-ascii?Q?0WYzIn5ILjgI4Y7vdLgGzwCovJzIz1Sdo7JQvQasNSM1YTQWL0tlZY+lEHr1?=
 =?us-ascii?Q?+iTKdZZ8XanIcemPyr7G6gjAYuZcwYxQEPOS4euum5o2qBxZTk6zIzRjiSvb?=
 =?us-ascii?Q?CI7c3fNp+tPKWBwDOvD2dycYfZUmGZDbgTRYQoJL590fM18HZS9z2+CPTloE?=
 =?us-ascii?Q?EOji3wl+8GldIie5OHNkUrkFr+9K8qJGCbO6a4WcuD+rmBynSPxO2DL+fZ0i?=
 =?us-ascii?Q?UXxqf1aPPs/TFitYiZipYNd36mu6jbvteDzHI04xGsXiKAQibKbV4A3hOwsY?=
 =?us-ascii?Q?ZSqLhA9GlhuDbPcsIbQaKs6+khdznhM5FUFiQfQe?=
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
	KGH7WO+waMfrBOPMLKjUDmVqIp1Gc6+xCtHYr+oQb4jmb0gnb8zTHqDjFI+5DM+w4JsRXAwiRROCzHcjp7LmrxbIFE9UMvQ/3Wxg9UvX+9o3FS17zzz9V3a8CTDedNINrkEN0xZNNHU5wu9pE/4yriMKB+KKY60N+Yfu4zWj2JQTOR4nnflMPAmvZiakXejjyX7yT/KzH89BSB4LhKDe4ftiw7hd42PfxCER/fq3hyu0FOPqRPe0vi1cbeMvVLVKDrLeCtDm+MrkiZw7o6J9ueYGNjuu90CUk9RyrFGBGqpJghan8+OQQ4N9Az82qkT0JiRxyD8QYkxrK77/JCxyPIqBUD/491kw+psj6uBX+4P2PsNM/OM/hxVFet+jpBYW/TpOhMxQLgINzyupWsJrqi1xAr7TBVdNwEujINkoT9DVNUI8VdPVUTBg3Q3n7431Oqpz3cXpnFeEig3HAzAkArRzODBY83TMtXFQ+HHjg5gnXq6itQrVVbo5eSMQCuNkHk4547GWBfml/x/bbb+yBUjw5OgEUZwBPMPCLQoDIuX51Ad+N038m6VRUa1RRxLDzS6hcu20NfO1GugWzpfaoz4RQ1/vfxjFWDvAwpybuNwAMVNEp9Kq4MeDK2NFJeiU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e1da06-c11f-4e6f-f578-08dd1e8e7087
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2024 11:32:07.8094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ewOMYvW5OMtdtKuCUg/7WSPa4F39Ir8Ks9K0cMguqGf1rs2PsLkmDB4WsccrjLFPFa78a3cwM/EQzMXPeVU7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9416

>=20
> Currently, this does not cause any issues, but I believe it is necessary =
to set
> bsg_queue to NULL after removing it to prevent potential use-after-free (=
UAF)
> access.
OK.

>=20
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufs_bsg.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c inde=
x
> 58023f735c19..8d4ad0a3f2cf 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -216,6 +216,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
>                 return;
>=20
>         bsg_remove_queue(hba->bsg_queue);
> +       hba->bsg_queue =3D NULL;
>=20
>         device_del(bsg_dev);
>         put_device(bsg_dev);
> --
> 2.43.0

