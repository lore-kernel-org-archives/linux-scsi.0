Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A02773C9
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 07:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757490685; cv=fail; b=nRoAstnxTFPtN7/r71Avh5IzrPSQm9AhPprjbIcdmpf6XqktHtqoVOV3mp8ebv6g0LRFLtpUQtx/tyL5TWTVFDTNgOWKLwHuFNBuVlYvVKVy2c7U9qSnr12LufNvNbR3UN5ZzvRX5+Ip9Qo1qeAcnOpDtjMPQB8L1gd+4prgWkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757490685; c=relaxed/simple;
	bh=AKo1mkVXyD5vRXKyIHhM21RrvMeTVN2277iAaW5vmkQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zap0zuKCPRj2tE74KTj1G7S5MmbT68QkZ/t6xEjvGGC8yuwemdrZDi1qJOs40Mplvd/vkkjbiqpe2TuKA8lM+Jah/K0eY/x9KfVHOmleICXxiKMmDOGWBmcUjpUvsCGZHhDTIx9wdOoinbrDlIJ8n7MhZgW5c0sJS1WWPMLDDg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=cgQmgtgd; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="cgQmgtgd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1757490683; x=1789026683;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AKo1mkVXyD5vRXKyIHhM21RrvMeTVN2277iAaW5vmkQ=;
  b=cgQmgtgdDvJb5SQ7f8OSJAS6uxDCjp+fU/v/2LytAVbEmhknQHbwJBgc
   45sPHzDbYydl4sU2qhQDeLZELSXZAjrhCn5zO7co4ObwI8rt0MEX88J5t
   DHE40wFyS2usWUc6BTIcv+iKmPkM5aKSFmNo+cPcD3l221B2St3Ps+kVZ
   02+aPrSVAUikwwctxowJTqW2Ur2ModS2C8l6tL07n2EJtl9+rnMf/gZ3g
   tnAvWGju893ODy8nKBAwn0/lGLFcuxdfd1EJ9R3SclVbpg/Nyv4GVe8SI
   ra7M0h7Jv4+q0RSA3Q2PwXVMmFl2e7iEFlm37E/cAe4PI/D4MFzFHvmkN
   w==;
X-CSE-ConnectionGUID: 4zco2gBpS3KxfBPYgM6Adw==
X-CSE-MsgGUID: NoIgQ3a7TLOkZkmB0F8NEQ==
Received: from mail-co1nam11on2132.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([40.107.220.132])
  by ob1.hc6817-7.iphmx.com with ESMTP; 10 Sep 2025 00:51:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vvgQ7ufwg/rq1iOWkv/95NYchQZ32f3Em8oBiBFBufzNMXBgKkeq6rqNFaORJAMKE75aM4UXE0OGmOt3hllFytdB/gyZcDRMPbXL3cBxTEkbuIkd5xX9qfEWR+eqJdlR+mAmqOokQF++DJgE49emsM0J3O48Df7jeDJCw9GkUELFXXAuQbZlFxhaVvs7LOBHLveu4iNJM1/WLHVJakvK0fG5PJ4B8uu+ejMGgzOegu5Cmrf1AiABA8W6DEGrUJbA3NfEj4Rr20rBz4BS+jtURFCG0RMD+Nbsfa3h2JagoxR3wMog4Jem24nDPMAv5bFCZ2hsmM16P/fXsGLpc2eoUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKo1mkVXyD5vRXKyIHhM21RrvMeTVN2277iAaW5vmkQ=;
 b=UlUGVpaIKr51fDH0M28JPjennCJ5u5peR/4WPVZFUWnt9zIslTIennDf71BV3nSmMoedEhOw/BdYKmJyG0AdfFzdUpgivIdnfDFGqYWm7IBxHvTJ3RhgH2oflgzzr4Au4bT2yNS2xgP84KCGpXLKomHBV4Fv/YX8upoBnukVkrI+xR7aLI1PaAoC+ZFF6lvdxKSrrCpM0aNmaBTaWY0u54+jP12sQIKaJTQdzNUqH/09U0lfTv/Y56IhhgXvgpKOcvWmTh2K6iPj+OBHHDp5DXNyh9S9wutc2XVRGwbdaUme4onxtipmZNtKE6SQtv0RwkMIsOsP5fU10g2KdQw0Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by LV3PR16MB6691.namprd16.prod.outlook.com (2603:10b6:408:271::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 07:51:19 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::d65f:a123:e86a:1d57]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::d65f:a123:e86a:1d57%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 07:51:19 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Adrian Hunter <adrian.hunter@intel.com>, Manish
 Pandey <quic_mapa@quicinc.com>, Manivannan Sadhasivam <mani@kernel.org>
Subject: RE: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
Thread-Topic: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
Thread-Index: AQHcIbzevUE7Bj/OBkepooYxNLjGQ7SMC1aQ
Date: Wed, 10 Sep 2025 07:51:19 +0000
Message-ID:
 <PH7PR16MB619691B9CD2CF4E2027016DCE50EA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250909190614.3531435-1-bvanassche@acm.org>
In-Reply-To: <20250909190614.3531435-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|LV3PR16MB6691:EE_
x-ms-office365-filtering-correlation-id: 63417fda-b9e4-4070-97f4-08ddf03ed45e
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Sv0AiV0MxxKuya6sFon+4EpCEL63ILJGuAMt2H4Yf/frdcLZtnXAGStnwDDs?=
 =?us-ascii?Q?dEnB996z4jbU3Iwi/6DsGAzkdxG4oxIO87b3IqxlauyORfqF4ibwhtK0bfcT?=
 =?us-ascii?Q?kMylDuvCCk4OGvq9mf+AgXocoxf+RBU6IzwnM1X4+by19/rnhOhmSQucjMlz?=
 =?us-ascii?Q?mLseWPCSWMs20VDsjwz/CYRIKLkG/ofEo6eNUc4PsXM7Rp3nGMmna7AOSMEU?=
 =?us-ascii?Q?fIIlvihCxyacJ5S2MtXZ3PqsYTD1OyJIKy73GqPLlq6YNQ02OaIa8E5r3Y64?=
 =?us-ascii?Q?+hm/9HDdXGhmW0yKevjSjMWdHljlbTOG982D1ogdTr/r1EVuUgnsvYbkZI2F?=
 =?us-ascii?Q?vtJelh7UMJ2JiZH/yBLBMhkuM4sb7TqQ+eG93BPtoTwoSh5/WquoWyh2BbTW?=
 =?us-ascii?Q?EpRSK5Czg+jfxRh73bkDQSajLu6alxcDxr7D/dRWiH57/oXp5HCwCXdEea8x?=
 =?us-ascii?Q?hb8JdetKVmx74sWcy+REjisOhYyMD3qGWzFzJjnT4YEVriRLCga8tim4fHIX?=
 =?us-ascii?Q?rp083VBlVyp92S3WgXgI8Nu3R1c6XsTS6tWnJUKJiFrtzFI03NUV1deDCbD0?=
 =?us-ascii?Q?rg+uOgONe28G3UzJSuwKW9PJEhgI5cym6cVHJ41/MvblbtGIGJJYlyedGY40?=
 =?us-ascii?Q?0tYg7sOF2NuwlzPJG9toM6O0oiUUEAbvOjQ3E15EoJVQYkkDcK3l2QEPjzQK?=
 =?us-ascii?Q?/zKwnPdsHfE0kRYkZZOhpitodtF+9m7NMQ1LeYans0/dC4adNRF6rFO7IyRC?=
 =?us-ascii?Q?6+fzh9eTGVsGyue/eIWPXlkSl4P7qW03wE38cP2Il7V+fdGOtP4PCQYRSICk?=
 =?us-ascii?Q?tKKhK7JxdaX5stUr3bKwLXpG+UTY+rSK+Ys5Z0FlSMW/LKW3Sv5qKXFZPGT6?=
 =?us-ascii?Q?pmf1suadp0dmobeg7Q+O571osHAInqJTbGsVudsrfS0WJoASWCeCNeJIFOtc?=
 =?us-ascii?Q?ikEwr30YTHF3Trpaw9i0X9p2uuERd5BPiFL9+ZgBe6x+HfusRBlBxmNcp4aB?=
 =?us-ascii?Q?VQFWMUNEUcawiqwQ6ddhfghc+YPF7HyUwaE/RCNtk4pvpN/TPf0O+DpFJdl6?=
 =?us-ascii?Q?tkhzWJhyltlaIIgBpDvhO8l+/lpdGcLrnrZ2WxeOaL24ONm37gLptEK7zihA?=
 =?us-ascii?Q?KXFMxOcUr598vWMOdiTHA4XUGlnxYBPspt8xpnlfKD+fZGbDP9tbYqCnGTWU?=
 =?us-ascii?Q?o580t4z2ulw4M9+JdCaTzlyjySwRRXhnpC398DQiRyPEdF2V2jl5Xl4PVohc?=
 =?us-ascii?Q?zWnnSvnjRJShxOHtmCh78LTIKjPqQD6aFakZUADfFbNdl8mIxz4DG7FOCxpK?=
 =?us-ascii?Q?4RapaaWY5bVjkbiEHwGgT/k9LzJHVkFgmIozy290uRcYwZU3XuzqEK+y7ww+?=
 =?us-ascii?Q?+UloUhR/jQZh5nphGnp6gr166OCU+HtJL4WwmpogScCrNOrb/hzA/GwpkJ4X?=
 =?us-ascii?Q?wO34pDpX3U1dabMf+4HU2WkFD+3kSeELlTW8hBT12r6TNywx2Mgbz3oOw8FI?=
 =?us-ascii?Q?pHH9mHDeud9kdhQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?j4GmlNEZ+OwMkrPw7QU+Ct3pNK0PBaUXb2Jv+j8ArU3F/xFGnkmBT03udbcn?=
 =?us-ascii?Q?OpZQKJbLqRV2fXMdPdov0uWhG7MiF7frMXCRh6QqEL7DYlXBsJghyy8LYoV0?=
 =?us-ascii?Q?ro4AqR3wr0oPUeabsVa6Kq8vFpRVkJajvsZzyTDXIGmKfkFNy+E5H1dZkzZ5?=
 =?us-ascii?Q?OiWNsW99p1iYYTkN5rBmzFw7UyA2vUbYe5643Q10TQJpB+Mz6RqL87PUSErV?=
 =?us-ascii?Q?rLUltqZQ9K8Xa/oyUC6H/2qR90zUOp/DRjHygQjNYuXjKtaBSvqEKqQ9I7u1?=
 =?us-ascii?Q?J3ZEe00AROTYhttYRC2yCg41jjtujdwewCLgsmDaSQk7GpZ18D7Ez/dB2yvg?=
 =?us-ascii?Q?1A1mtzB3XD1p7xUY6q/6vQO5sYcAXcQJfwwoAsIOjtERAdBy6g7G+ynkafJb?=
 =?us-ascii?Q?TrG5rxsO+yvObNrViZnt1p0OVBoI41LtDs80LYHzg9lCGo3wJP8BT4NlQSgx?=
 =?us-ascii?Q?w8Zyx+I5vL5mA5kB48ar9T/IvyJuJJ+PnnuQJ8gsDHZBWFXvstLa7QnHjGlA?=
 =?us-ascii?Q?7iol/eo3ixSGITuPbFYVpyLeI9XuZAzGUA3GEaKv3CBdYUUhl5+sw0i1q+Fb?=
 =?us-ascii?Q?B9cUaW5TNr5Uzjux8m6/fUn/zlztlQn/VdxDNT5g4w9dYjiR3UCWOkeKDxFk?=
 =?us-ascii?Q?Vw8H/Y/rYLx6ADGtlA8eFi3+KfLAUkayVzUAoj6ALYkVYrJ6vbG4PegMkhch?=
 =?us-ascii?Q?mkquSh5BUhEpCxxmR11S9L2Mhwtyer8IO2fydiD3UsEa+5d2Nk0Cgw652k3H?=
 =?us-ascii?Q?8PAUqDKH6rgeyaIKN1mF3MbtMoww1k7vi4GGl1XCVuw5gor2zfbbdT/YXdYX?=
 =?us-ascii?Q?IlZ41eV+GkSBa0D6dIFrS9tllMwTzLAPHAGPb/kgHDQYCmfFMtTuZFdzCFrw?=
 =?us-ascii?Q?tyZD7/luqGNWoYYGENsHdg5S2+ft/sb7eJ4sEvTiKmC1emRtAj6xD6BT/T7O?=
 =?us-ascii?Q?kUlJprDGA40gUkFT0qW6zRgI4+HYdsdjH1gXnTcIk6QGa5SqvJQ/ZxNXKtCc?=
 =?us-ascii?Q?HLlKq8Ku3XdOlTaKtF2rwYWvxW2QvME6CkfrYgjK1sMrX5wp+uU15PedUs+6?=
 =?us-ascii?Q?KPUrsvloaqichfbDO4YqGrMUf/4UWxwnaGbaqkgbnmOun/HgxYnznm/akf7l?=
 =?us-ascii?Q?uMrN9WW7ugXjeyg2hb6mOYOYZvX1G+8qeZ7h0zyD3WZGZEWXBcA4YM6mDHd2?=
 =?us-ascii?Q?r0ckVBiC7AomEXGP5m/NeBTotWufo0G7VdiYrJxYoTc5iLk8+e2RHWNiS0Xs?=
 =?us-ascii?Q?80c3joS9sECExGv4oElqnu2i/dh7c5cU+F8e8YL948DCQkEL+eQGQhjXlSqw?=
 =?us-ascii?Q?JuOOqJRySpWNRpD1YeWjNLzycTYEaeQqMztAUL1iWRuIX6kjA2/qSlaDyxO+?=
 =?us-ascii?Q?YCpq/nzOaGqlrk55CH0LFXr9zONHNfzJaIqX1UQ77xL2cQUMPdU36GF9aO70?=
 =?us-ascii?Q?N/MmRgmqPOzaTUdyMpccUMLMzVCWB0MjfYYH/idMQ49LyPsBA7vXII7FeFmT?=
 =?us-ascii?Q?csehKDFS7iQt+VWe9XfXhq/FYMnl8YlRXwjGI8fVliB4k7THZnIye+7x1aVV?=
 =?us-ascii?Q?HvjV4N2BwM7EjJ26tzwUoQLTXIONlhqYkp2V/iNs?=
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
	tGl8HWYwZyTGNVMIQYWzenUhPpzuz9p8rLjAksudaOyQcbn9HrX6wzYRRBFnJECh3MdMt8Puva9ZmArILyZWX/7SldLT9+cquwPlOgGgHJ1MyScXdyORSk/4Kygp0igcLYfr/LiEbEgZn0cHW+qUUQiA+3FkUITMaN8DqAyljJgrH4V6alZrAMhUlZ6UkE17uVndCMq3hf3yMQ/9qS4uc+QcI9BzOCisGrUM4DfQsH7C7oqZAnjTz+qoaBRrfPFZcgqEjcQmhe8rCxKE+tJq3nvPlGJoIAexNd6enEXHxRYqarUZCU+FiWtfRGz6H5+DRjP5RcTFujuqd4bMG47CPDniY8/Bq8Mkl0GgzoCvPG8tVgwHkWUOrz1hGymJzFgXg2Wct88j7sjIK6jZy4NINEvqQtk5Gq2futw5Bz3ps9bykTBPmzPPXVBVqPP3TrAu9uJyFLXxts6QWPrH6ZA8nQxR8DjCnc6F3LDwMoYJrp2H02gn8A/bBIXf3lXDME+9v9m0GpQJiNI0DEL2RlApSscO68WI+kRS7Fq0q8yD5ADG74yHUHUzjIfuxA+Ws8swG3jyGZCNz13oRUgUb8oi7EH4HBKHKVdUfbVR7cdCxbJ27dvWihuetCK2ItLd8cSIe/FYJ6G1NDMe8c7t9F2fnQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63417fda-b9e4-4070-97f4-08ddf03ed45e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 07:51:19.7689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QRME8srWOT9G3VBHPpSjxizeoZQq8rA7h05yLj952XBvAtnZUgzJL0PvUUhpvCwCZ4Iz8bIuYq8xJajXuUgDLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR16MB6691

> Some Kioxia UFS 4 devices do not support the qTimestamp attribute.
> Set the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices
> such
> that no error messages appear in the kernel log about failures to set
> the qTimestamp attribute.
Meanwhile maybe you can use rtc instead.

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
