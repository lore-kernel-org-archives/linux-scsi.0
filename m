Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83814B941
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231400; cv=fail; b=O3CG8PDNsRmUwDJfmVffz9XP1FiEBgXK+bHtXgqIdVYaRh2mWZdezTMxbMBUCRXx92F3agGCwrtOUHGUo7WQG+6jkP9iBStrarrKuobMJSQ8wHeVzgP+7WIlSQTYyvjUCkxW7cgkMIjYK2c6Y93bZh8b3wdh/aN80/J3weVpyro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231400; c=relaxed/simple;
	bh=Fn6RbwKsYAKhyOLyqZdM2frmrwVSdaN/ag9whARBa/w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ticou8PWidJW3v7yd1i94UnhR1CrrqgFAFNpHmjJhpqrtG2e25yo0tpOfTHM4Nc+9XJ8lWw6nD3Wh6zdgoGvsjsPtVL22d+luO1QLGopTzZR8akxu0Mw2hZDQluvjlWMmr8MmZ7PxNeXBo+ZvJ0eQO7a1VLLBnsmIQpS1t5U0Hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PC6SZ/zn; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IG4Y2VbR; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PC6SZ/zn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IG4Y2VbR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729231398; x=1760767398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fn6RbwKsYAKhyOLyqZdM2frmrwVSdaN/ag9whARBa/w=;
  b=PC6SZ/zn/+FrzLETSNGpRfOSh6mypLZ0JXT/cZmap9lPlMb55GKNTnFs
   VuZa7dNoSWX0VxnhggFJM0Pbl11IOh+KQhIyYvdJSURlXV1Ivpprg0R31
   2+Cio18XkAMM2F56jyhIyr2PQfQlJPJPIMs+UDAPUP4+thEXxKWvD8jJ6
   K7tzPQmLo0QEk4Ny3apUMR2Pv2TEete0YGcfEL4gy2N5kB9zT4rxLI//u
   eek/GTRz+nJs0C7IVqKTCKD36QptTvNRxFiX4M4uN+JDgdY3BPogb0ft4
   WsaP4AdfgO+7Nv6BfjY9RcDtKTWUSJ69j90yK6OJqHdfDhI1QOR4qQNcC
   A==;
X-CSE-ConnectionGUID: MogDSZ1+QDCiUe5X1g8LTQ==
X-CSE-MsgGUID: 3XaIVwG4QUi9+8BkIOwC+g==
X-IronPort-AV: E=Sophos;i="6.11,212,1725292800"; 
   d="scan'208";a="29710223"
Received: from mail-centralusazlp17011027.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([40.93.13.27])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2024 14:03:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sv94s/zYLbYmevdORUY81p3xJ8Jffcdri1eo1fBbnmqstnVMsvu0MQA8nbR8FROMTa7g51bwokKgWqjlmJsdAtB0M5/Qn7Kt5xq5CKdlEPsYtt9GY/YSzRHRETzyDPzVrPvXCCtlW3JUE5q+v0lCIdRRrDh6JKWfHSO+7oviFSwk6kpvuQJCUDN2AhdsK8n/BauIguB1h33iT4vE22kBMzqryr39ODIoKKuxCuXWzYT0ZDliKJcl2Ytk/nkHXFBWltAigZkJoIbkW2455Z5cdtKKPQrFY9EP4GBJHkVrfuXpX709ES4urTApmNTuXNxYI14yUmjosDgtDDe1DOODrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0kBtb/XpjM9Wjeqt/YN57wG0aLoRlZWeOdKgf5O3Gg=;
 b=iVJVQCTPRMMqvc4Xy2/X2qZQ4DgqgIkSPs1iv9lkq/vFS/QHWW169Y07yDr7L7VoDc/rjapHXi58K5ofjDp8EHOi85mEe3U3C/sRAn1bTRVxHhNs8hdqfy5F61MwSE7BORy6ALWzWlifQPLqck6s7XBwV/2uDZkxkJff6kX2NmptbuqNdBJxL4zdRoZC6uOhJvPcVCwwIEUdfvGz5bnzsHK9jUVqHjdhU8TLGwAwmgbkGGF9p/fq63Pe5nsl3es8c7Eu3PQ6AVrQ08OkNxNeyC9FaYDT/FGOK1/Wqqw9Gmb/C7uBlPnme7a7oMps7mz9KzEzbHhMbHqFnjqo4KaqNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0kBtb/XpjM9Wjeqt/YN57wG0aLoRlZWeOdKgf5O3Gg=;
 b=IG4Y2VbR4/HI/YzGvXiZJWEKVRx++f1srqLK4kJ+0IPuPenVBMk4Fo0tPtlNfIaG07jpKgho5YGhLR4vecplQUpTlWfDoqIdQY8BNOigivD5cKDE6NXFfyK4vp30T4ERp/JMlXQ6XuJATlYnJo++GjYWwmI2BqFRzawB9iA7UtE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA6PR04MB9470.namprd04.prod.outlook.com (2603:10b6:806:434::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.19; Fri, 18 Oct
 2024 06:03:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 06:03:04 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Yoshihiro Shimoda
	<yoshihiro.shimoda.uh@renesas.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Eric Biggers
	<ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>
Subject: RE: [PATCH 7/7] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Topic: [PATCH 7/7] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Index: AQHbIBA3TD8dUwK++kGA2NJIlDhIo7KMBeUQ
Date: Fri, 18 Oct 2024 06:03:03 +0000
Message-ID:
 <DM6PR04MB6575D9849E5A1BA869ACE445FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-8-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA6PR04MB9470:EE_
x-ms-office365-filtering-correlation-id: 9b9b16e4-0bf9-41d7-017d-08dcef3a877f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EQfDXE2x5raect0W7YZfcBzP0pLYxdpXk3hpt7UjK3pWjj589xOxfSGPSHCb?=
 =?us-ascii?Q?1ziMjWemK5DI5V3DWobqlhjUJfmQusAUAIQxaoUqAovLV0A6xKcpmUTZyh5Q?=
 =?us-ascii?Q?4fiukI50IfsFiXq9o5B3oKoDZvKiSnieh7d1HNXNPwPSQ/E+TolEbGZrKS0x?=
 =?us-ascii?Q?aVp1FywblvmtfKaFZj0idvfZSt9/zzuK23oDxWwD8lycQpq3JIxjWLSostn7?=
 =?us-ascii?Q?3V3c77VBeNAObwJgoSHW0liO82W0Hnb3JOE8SdplUIKDstL3xiLj2Nepaj8C?=
 =?us-ascii?Q?NxGYCGPwzJ6Lielkpv/4joGZu1lbOaTDXe24k/Tk8xQFAsE0AQMLNQg6AY2B?=
 =?us-ascii?Q?e0pwPHzCQVGsWrDP+/G91fTOjS+PeOVdfFbwdTHJUccliLDutvYxFAv0i8om?=
 =?us-ascii?Q?hs+vG3LghRqMJJI2D5O2ob9N7PHqol8V6DS6AiWxTGwpxeA1aiU+QswIEwue?=
 =?us-ascii?Q?al7qq+ZapOTykjNggOQyfMHQfKGotZgz2sAEHum9aapAQ3zM0EcACWN36mTt?=
 =?us-ascii?Q?My8o1/6CJO/Xph4zcWMXZwIyNePPCVoy8xoSkQ9MOZ7NxA930e74PEM2x8R0?=
 =?us-ascii?Q?YZ2ieBBT6+gWVrVRY02q+gkhQmUXA3f++iFgxUU0V0VLivB6jq3Zl7CvTm7h?=
 =?us-ascii?Q?afcUMwGEmNPyveD+zQSzWNJz9k+BwKkFUUMfo5ypNT6pIZw2A+4gjB26IllX?=
 =?us-ascii?Q?g6oOJWkCDnhblVb0iEItI+dxACSQSSd39GipbtqKBAnnDFx0TZ55XT3RNFa2?=
 =?us-ascii?Q?td4Dirxvwf+2fgWvxD2FdHbiklfawyLJpd+ofyALVcHkJsdatlOkAoc1cz1J?=
 =?us-ascii?Q?rvvsZqDGtAZXyBMnPZZKyO4ZuAuWrrxbxaEYJvNWG7+C8KIAlb9LAiV3SGDn?=
 =?us-ascii?Q?0F7JAgZRaW53XibXA85Yb6HfC3y0//5t6skFiQbXVKTHjrhQoaO+FG5HG7cM?=
 =?us-ascii?Q?1JyZloWnhs0/jXCyRKGxp+g7js+yXqStSNbuiYeWcU8rr7KSnrKFPWyFB4Pn?=
 =?us-ascii?Q?2Xf2Ew7YqO9xZ9i0JLE5BYDEYnLd91m4a0slePhq5xzGSOqTOTD31/4lcMHa?=
 =?us-ascii?Q?R+UDs2cmWxj6sd9Ts4sRIFETpRKw9hCVqTvUu0WNMgN5Z8WjfyQNfEeNOnCT?=
 =?us-ascii?Q?nwoUsH9skzKOmyuRWWNAxdAgsd671r9btKXbBYauqUP6fL3itMGbWvCh6jfA?=
 =?us-ascii?Q?sbDLpNvMYiadf/jd2FUpknEHWO+IwkE0QAhPeEUO4ebKSUWD2XGsi2rOaaKC?=
 =?us-ascii?Q?nDOgmq3widsELOICfyktZAB1IF32gjVLn8EHS+ngMhFmWR5ab3Ic7ocQtqn2?=
 =?us-ascii?Q?vL4C0XD20x51EgIiEa1AtQs6KM8gdiC7JQwDhlosutFrdnZvKaLLhnd8Tnsy?=
 =?us-ascii?Q?9sZrjEk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YCcF+o9dgUp9UsN4aSO3fYiihigTq6M1hcVO9JrCe1URUBhRdJf8bgOLOGRQ?=
 =?us-ascii?Q?AatR/81MuUkDTwz48hRIXUJB66VIWxdBcA4HJOexNx/ljhGHJclQ68s/k1Zz?=
 =?us-ascii?Q?wdAm4FJCYzZrkDrK1zc9/u63GsvfvsWpi4nnLe9nP3PWme6cy/RBnV+FdTxL?=
 =?us-ascii?Q?2njdWuoDIXPHJexU83pB/DOL0B1+mslGN7/STZ2lhJ/HXRMXuwaRFFt8uWhM?=
 =?us-ascii?Q?Sfzifq7DlmKl1Kwgz10KWxVO2lvDQVXLDk7OEoyIwIfdKOzXviLuXJhlmwAv?=
 =?us-ascii?Q?PIVzT2p2206SA1h8GokWCwI3NBviGCEsMBFu04VQuaGpfNqsijysb8rxfATN?=
 =?us-ascii?Q?VvGfQUesEtMGdfLo4Q0ctjnYv1T0H9LcBj3NfbulS9f3blaM7McF5B3k0LzC?=
 =?us-ascii?Q?qeLnGWT1vOyJxnOI5PPrwlr1BMetf9+PmAkc0d6G6zPgKNcGrpGYHjlZWHaa?=
 =?us-ascii?Q?78pS/b7kEL5lVuCa03KN5nWw5A3kjzOPxHg0oQWUZX5pbSo4fhX8rsPIxmkZ?=
 =?us-ascii?Q?llh83MaTd8fwc65fKeCmCuVCqFW5Ega9wRoy/HVrbbMUOglC/PiqKGJ4lnwj?=
 =?us-ascii?Q?Vs/xrY3YvIlMe+D6hLqoc/CqKD2zcLoxA16DYWIykU/M7rJtA1ovJT+7lAVi?=
 =?us-ascii?Q?N5mkDIEx02/iPe+ex6RtKoEbKnvVsrbnLHBFY5Ish4xdSs7Mhm+DALYcaNJg?=
 =?us-ascii?Q?tGAJsuNiS/jNzkjbZmY7s7jBez9J+k3zXKGlQwA/EAgIy8D+U4D6kIK59qRd?=
 =?us-ascii?Q?5VQhodky4ZADTUUpYitd1Ep5FNPbHv3k31JgUxpJUqkcXbUwIyr4TcsgovR3?=
 =?us-ascii?Q?d1Jo1qR0Tx7+LRCnpkAg7M9qrRK5vgV6vq90Bg3QTeRLWs6I4VnQt3yMgOHA?=
 =?us-ascii?Q?7oGj0paal5HqRAHitFCO3AFQ0Ls2N3Pck6FrhqMYDNrn4Ga/1xjNo5GQ3u97?=
 =?us-ascii?Q?rUebgSSF00OuUDtqqT7FJXZXro8/FppSdljFWSJM7tf41DRVbb7BtIPtxP3O?=
 =?us-ascii?Q?efNGP9rjnyLOc8aOlNhMKt9poiiHY+R+qk01CjX/A2sWz1P9xLcyTKta/jYY?=
 =?us-ascii?Q?ltNpjXvtoWYNKnubFf580iDNNWeMSiFkaggo9e8e1tjX6ztKlYFYHHKACahf?=
 =?us-ascii?Q?rC9UOooZdIgUJ29mNLOzNPE5/5d/rBytVg9yYrRRCT2QVAtlzccboJWdncPw?=
 =?us-ascii?Q?8RJKruDOXWGk1lEhdRdsUXfPiQGpRafZOfvyepH/UFtAnGvN2iG/kjExsMaH?=
 =?us-ascii?Q?pJFvbJzSMBbk6q16QEHUrPo4i/Zv7JuYSBViPLubsMdIcHWCAkUr//8MSeo/?=
 =?us-ascii?Q?mQVFeZXuLTJtqKXdp2AyPRjn7JmGqPMpQ8lolqRf3riveI7lT9Tz5TCkuOd4?=
 =?us-ascii?Q?bKDDKkXM7uxNaLdH4ZELrv0sp8sdPsd1WPIJWpR5sq25cjtQul7bTg96bPLl?=
 =?us-ascii?Q?RR3MyNJ4EbABPAglIcSF6sEeGlbDHd+cqQDPdrwWPagKT/xctC9VsU9Cwzy1?=
 =?us-ascii?Q?TWIU+6j7i9U7G6F0QEVISWVdZsdVsQcnLdkPz/bViHsvSBSYuk2M0HTFl8eh?=
 =?us-ascii?Q?bxKncPj7w0bUBwqH7O7M1Ms2SWnxG/4fRpB8TBeR?=
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
	/YTqtba7pxapm3vxxTx880c/Jn7JfzJwtOQXteEtrZTjQdVa5iFoTItrf7ZIQhTa7TYExDlxQwA6dxnQey92jxpDhvSMIkvkJ4wzIsyQ/goADGwdtyOIWtsSVg5rqCFFi5QyFGsqFAKMvY8+Bwjm2Set8/ltwxKPvmzVTTYVUlbZhhxo3cWXo31ybSFSBsb+hXCQZDe3KWh9efpkbyGUutZ5wS0ZA+lLZ/dx5ELbhp3LXACvWVJj7wj4KOO0wpDcs5BTI2NDElINjW1n50yk6bVi5jmGRhjAIN5fXvqvkr3NAPc4/NI/FEmaVsv7il7AZwZpsurkqNwdy/dEwfxqw9NSjzlCmMT93FoYB3nv2us9TLFGDFcKRG4IsOeyXyP05R0pdSEPSggUFJGDRn17K63lisfuYuDbgSVlMx/4k3VTGE9PVDQkQr68IeuGhlJdeyUOxERiJxMldQZymve5ARnBs8ODHF8Wme+VpH8BkFVwabtPw8qSvoIaU5xnH3YeEjdEMGn2Fu8TJvpzBYlrKAUICvXN17A4H26QSJAHG++t/nQVvr5LAnzsb2yvz1rjMSShvFmTm4eTLiZabuHRm66dcoz/rwfxq/efVizBtOQESe78bAlbTP2Dkpe/RxWz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9b16e4-0bf9-41d7-017d-08dcef3a877f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 06:03:03.9764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2cXot2NB/vxZPqI/MQj2pdKL1WWVLe58F86HLRigxeKDzXUymV6corprfSuPEQIgbSi+TcfwQgZQB99N4x+FUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9470

> Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
> ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
> This patch prepares for adding 36-bit DMA support. No functionality has
> been changed.
It looks like this patch belongs to a different series,
e.g. the one that adds the 36-bit DMA support.

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c      | 4 ++--
>  drivers/ufs/host/ufs-renesas.c | 9 +++++++--
>  include/ufs/ufshcd.h           | 9 +++------
>  3 files changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 75e00e5b3f79..c1d4a9c8480f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2389,8 +2389,6 @@ static inline int ufshcd_hba_capabilities(struct
> ufs_hba *hba)
>         int err;
>=20
>         hba->capabilities =3D ufshcd_readl(hba, REG_CONTROLLER_CAPABILITI=
ES);
> -       if (hba->quirks & UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS)
> -               hba->capabilities &=3D ~MASK_64_ADDRESSING_SUPPORT;
>=20
>         /* nutrs and nutmrs are 0 based values */
>         hba->nutrs =3D (hba->capabilities &
> MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1; @@ -10280,6 +10278,8 @@
> EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
>   */
>  static int ufshcd_set_dma_mask(struct ufs_hba *hba)  {
> +       if (hba->vops && hba->vops->set_dma_mask)
> +               return hba->vops->set_dma_mask(hba);
>         if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>                 if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)=
))
>                         return 0;
> diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesa=
s.c
> index 8711e5cbc968..8b0aebf127b6 100644
> --- a/drivers/ufs/host/ufs-renesas.c
> +++ b/drivers/ufs/host/ufs-renesas.c
> @@ -7,6 +7,7 @@
>=20
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/err.h>
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
> @@ -364,14 +365,18 @@ static int ufs_renesas_init(struct ufs_hba *hba)
>                 return -ENOMEM;
>         ufshcd_set_variant(hba, priv);
>=20
> -       hba->quirks |=3D UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS |
> UFSHCD_QUIRK_HIBERN_FASTAUTO;
> -
Was it intentional to remove the UFSHCD_QUIRK_HIBERN_FASTAUTO as well?

Thanks,
Avri

>         return 0;
>  }
>=20
> +static int ufs_renesas_set_dma_mask(struct ufs_hba *hba) {
> +       return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32)); }
> +
>  static const struct ufs_hba_variant_ops ufs_renesas_vops =3D {
>         .name           =3D "renesas",
>         .init           =3D ufs_renesas_init,
> +       .set_dma_mask   =3D ufs_renesas_set_dma_mask,
>         .setup_clocks   =3D ufs_renesas_setup_clocks,
>         .hce_enable_notify =3D ufs_renesas_hce_enable_notify,
>         .dbg_register_dump =3D ufs_renesas_dbg_register_dump, diff --git
> a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> 36bd91ff3593..9ea2a7411bb5 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -299,6 +299,8 @@ struct ufs_pwr_mode_info {
>   * @max_num_rtt: maximum RTT supported by the host
>   * @init: called when the driver is initialized
>   * @exit: called to cleanup everything done in init
> + * @set_dma_mask: For setting another DMA mask than indicated by the
> 64AS
> + *     capability bit.
>   * @get_ufs_hci_version: called to get UFS HCI version
>   * @clk_scale_notify: notifies that clks are scaled up/down
>   * @setup_clocks: called before touching any of the controller registers=
 @@
> -341,6 +343,7 @@ struct ufs_hba_variant_ops {
>         int     (*init)(struct ufs_hba *);
>         void    (*exit)(struct ufs_hba *);
>         u32     (*get_ufs_hci_version)(struct ufs_hba *);
> +       int     (*set_dma_mask)(struct ufs_hba *);
>         int     (*clk_scale_notify)(struct ufs_hba *, bool,
>                                     enum ufs_notify_change_status);
>         int     (*setup_clocks)(struct ufs_hba *, bool,
> @@ -623,12 +626,6 @@ enum ufshcd_quirks {
>          */
>         UFSHCD_QUIRK_SKIP_PH_CONFIGURATION              =3D 1 << 16,
>=20
> -       /*
> -        * This quirk needs to be enabled if the host controller has
> -        * 64-bit addressing supported capability but it doesn't work.
> -        */
> -       UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS               =3D 1 << 17,
> -
>         /*
>          * This quirk needs to be enabled if the host controller has
>          * auto-hibernate capability but it's FASTAUTO only.
