Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F3171A1
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 06:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744180520; cv=fail; b=pypzdB0DOLa83g3jrH3ujpj83hFnZp8z76DrvnZTmBuncEXAMDu7EUOA0tVnYH9DoCZD9yyvvCwvCh8OG9ojr9OyKMQh85F/zQL7o4WIRlsDLzOMqVansfbeoiEkiWZl3drG7MgYS/8dyQUimBap39CfKtqEw19CpZNv/ZTJFns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744180520; c=relaxed/simple;
	bh=W4vKBeJBqXc1HyzVsgcVWLS8MjkjmdIoGsvtDvjlamQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j2palTRAnSWgt+KwSo9bZeQXG5kKHuZYkgjH9ZuhK/SNSOARTDXE8eAy0S+0XVWZ9gEt5Ire/bftSMyYosjFO7tQFDun89hiT/3sDg9Ohwz/ilI79Ai1PSTq7lHO6zNmzUCLRkTMcYnvAuTMmk7wZtlWhx6EZtzODnlyGGZotd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=zT8v6VXb; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="zT8v6VXb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744180517; x=1775716517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W4vKBeJBqXc1HyzVsgcVWLS8MjkjmdIoGsvtDvjlamQ=;
  b=zT8v6VXb9d1ozt5JCgsLvYJpAvT9XybG8locn6In9JaofRtDqPTCYy6R
   AG1wJwxjLs970Wcn7d4M55KUTHy64lxONwBNehIHgV3oDFtzDgsoWkYJf
   aNGTBXWatn7kBMWkIUaegZznBXthqWWUBkut2/kze1AKZVQir9aBHJTEg
   z6jbLLb+sMNDt7q363qWyC0pd/ysySJXuKjX5vU5+SZaFQZdVNsac6tA6
   VzbebG/88JZDJ0iIwS6wYz3L5wx5zIbhbnaqSkte8VcKYV1ywRld1fm7m
   BCXuV3FpOBjANLDh4Cd2A/OToD50GoKN53Xt3SbhUZUYnsT2SNNWyn3YE
   g==;
X-CSE-ConnectionGUID: +2oyNPAiRGGDFckRwHUTPg==
X-CSE-MsgGUID: CUOkLwmjS/SbmrceYx5fHw==
X-IronPort-AV: E=Sophos;i="6.15,199,1739808000"; 
   d="scan'208";a="79493530"
Received: from mail-dm6nam10lp2040.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.40])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 14:34:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRGxbuqKoVPNPe/azQKywq4JILxK1MX9oOSmo3LJFPqGM10TxQuF4juccmBI09gaLhZk07T40x6PCxq4Evt7/+rJSBo8vXh8ePzBlwwCr1kduMQk9R6u0I/XO1nRwmgVgjhqnbncbg/AwJlvSz0GVpkHcj7wqsdCuHIemUb0pG0WE3YKW9hhXr1lWz25ad1oDDeLIt31TcMw85PambrYr48+e8xT0CZF8S+Ls9ovzroOgO5DTm7PDJSkv6W3oE14fNM0wrwXVqJK9Vl8eo/Oj0OVcgmE7rU+p422hiTGu3QqHXr10sK2PUYYIEs5iUvvc9B7Z/VbKu6lHp+w9wv0HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCl0drRFn6k42+MLRs25BNtvh/jbLZ8yqWR8KHZQz1k=;
 b=NaDs1EivaCfhjzaig7K6X5B/5lOQyoEk+3uBikmr3W42cAvW/mIlz6RQUx57SpG6+p81UOtNRI2RYzrUpT6T9nitDljECIXZhiKruVZtNir2Ntuf9KFEEzY/0CbMxJvulv8y14vVRIgFG2C6jT4cvGpbjeONeqvo8xLvJ6OtJzXydEi86218TVIjZ0CRnUIMjJ8uJ8oNtm7mKwF2RbR0PPM0prbPj17Ewpkt+cTR5frraDNPpnQtVjYKiukEx9zsX3N4ejQq1fL+uA4kDnIFU+kFRq0cWqOTLHI6S4E7TfTP0eN+hnUmNC0/EPWCE0h2FrQ+mX3jyhiAonSX5f5SkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA1PR16MB5152.namprd16.prod.outlook.com (2603:10b6:806:330::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 06:34:05 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 06:34:05 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH 09/24] scsi: ufs: core: Change the type of one
 ufshcd_send_command() argument
Thread-Topic: [PATCH 09/24] scsi: ufs: core: Change the type of one
 ufshcd_send_command() argument
Thread-Index: AQHbpN5lA3CUqqH5dkKn3ABKJfekM7Oa6OSw
Date: Wed, 9 Apr 2025 06:34:05 +0000
Message-ID:
 <PH7PR16MB61966967C1E97677F1A21407E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-10-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA1PR16MB5152:EE_
x-ms-office365-filtering-correlation-id: b52e2967-6a22-4143-0337-08dd7730869a
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1g+f400wScbAM7VUphFi+ABicw2d5+Q0V6o85vdb1npd3PNLM8ZyNydWEVMA?=
 =?us-ascii?Q?t+RA5bpd51P/qME1N5KJjc4sLHqTwpmGj1C1tJ/vT19yRIfPKOi2wYu0RWMp?=
 =?us-ascii?Q?pa8VIwa9M+CIuFOJjq2ce6NvpLYZk3iI+qg+QCGQ1oGG6jULcqZl276PMoQB?=
 =?us-ascii?Q?g5U6ooLhiIHdvqGAWzzSqT6ySF3X5feg7LCc5h4D36G+jx9Whq3lPYoORiOf?=
 =?us-ascii?Q?jQGz5yduOoLeoqYTGnwiwX7qF+rdSJ0l+8itntcqW9ObGFTMrwvQzBGBImNp?=
 =?us-ascii?Q?VHmgdi507rl0AqLDaFNwnPzKcvEPq/pXP53hNKeTHl7PLYP0w1n9IUM3TQbx?=
 =?us-ascii?Q?qgpedEhkiWSWEslqN6zlTTcQ0DpnIyQNK7Amp3IlMYycPnZkYFDM5df+aRFn?=
 =?us-ascii?Q?brnyPKScB7o9VN/Qu/PcxgqR1p558p6HwgluE6GkHOG6vhGn4tLu/+uAGBb/?=
 =?us-ascii?Q?zjGZdxXWYowZjfWy8lITb8IfsQqHVKEgnO/+ohY5aNjn3A9jTvHo8Niq3BFR?=
 =?us-ascii?Q?pW2EP8LW2Yl8aOPjrx6CsMWRQR4frMvS0g9RZsfJJ7TfEGumOQqPcXmdESEh?=
 =?us-ascii?Q?HbypbXXzFo8UWYDeMWBCM3qixKZpjSAOeEd5Hsr373x6TKfVTWnuLhtpC+cD?=
 =?us-ascii?Q?MPowJJjR3/F5VlKfoXIU32xFt+1Y2XXiqrAMZ0esaFqNlbhBqgf/ekoP4ruv?=
 =?us-ascii?Q?B98msn1GL88E7a9IHMP0CeduISxBmps3AxFN+9buebZSylzMpkvIHmyterhy?=
 =?us-ascii?Q?spK78+TqjlIrEUJl4uSh634A7VkFAn9f34IVtOqexXg3dOM1SdP1lpp2i6v3?=
 =?us-ascii?Q?6gLbnbn6nRoUAE7cRg04MwgjIEXED5kCMPNUMDNWy99eKP0AT0fbSwgEJdcr?=
 =?us-ascii?Q?cBp+yLjlxL7CxtjjcTWEpdqn6mdddehv3gQOrvFJ35YAVyAZhUkU/Qq/Egwg?=
 =?us-ascii?Q?FKwqWfMV8JfZt65jK0kyHEUoXIwOThmKD/qqtIFow9G1cHB67BksdYEE86k6?=
 =?us-ascii?Q?fTaY7k6ZkEuDQx6M/93+HlFw6egDvE46xUwI7F4VWRO3hyjw/Z6BKl+uZazl?=
 =?us-ascii?Q?ENcPHjUpHn2F5Mktafq6PdMilIhJVY8VWwofkmoftcV5ey/Vgz4gR09zOoq2?=
 =?us-ascii?Q?AZqlV0uATCqpqFZju3IV5NqePlQ0WWfvI/OTWYy0mcAbLMeVW/1ONwHMX8C1?=
 =?us-ascii?Q?J0D/yGlt64c6Vp60jtDOV1e8zRmz9UBKLVP5MY/ySPHAy0qp94uXYsxzpDUR?=
 =?us-ascii?Q?1rZTvSNzl7OMpTeXhXsgnr+FSNvRWez2g+Y5XWXwMG2Mmz3EeE4PieXDuGyj?=
 =?us-ascii?Q?NKOV+hsPwCWnE5WC7DTPSUbk4caK4X4jse+5/Fz4oYogvM6ZgvgLsUJiDVsm?=
 =?us-ascii?Q?d+knw/vagmni4Un5RGdSPkT1ZtRk3lO1tQP7cfmWd1tUkj0baz4qBdteHmck?=
 =?us-ascii?Q?x0VKiHOV08fjnmbtPvQ9VUKk9z3uj8Fg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?H8wmT2GO5w5BDBtuTg//dPDq5YJ+JV7j9cQau0PyX3f/zKFhn60XvsmqJvmq?=
 =?us-ascii?Q?88T8P9VenPHW/A8R+AvBl1PARpGIilDHLUrR/8iIWfbWvWNzdlk7P2JAzxR+?=
 =?us-ascii?Q?Z8EsKnzhRnZxVJqz/OP/AoEUlafMdrsmUdGXcdD3Rcyp7IPoHsLadN2+ZdGp?=
 =?us-ascii?Q?BeVX8xzqOp7cMLBJkaxCMMF2r9i3nvtR9xgWJX1jeGBQFUctlxhnChix8BcT?=
 =?us-ascii?Q?dWaH2h1g2sSrucXwGbXrNN76H0IbN+O9dplUPL7Tiu8qINdzBTm6zfP5LM4K?=
 =?us-ascii?Q?ZC8vQPGlVhxPo8zSlH7Qv8mudHOsJmD/xLQ+Yq1IduMwjODmM6uH4HJ6ioKS?=
 =?us-ascii?Q?BQWXLwslJiENvgz6/R4q+LwcBZAB68wXun2HrfVcGc+KZcK4S2jV9WuMGp9f?=
 =?us-ascii?Q?vv/DDYWeCr75q0N+lCQPeqLTbFEI9LqTNPQOLUsPd4jcc+BRshxx57yet+1V?=
 =?us-ascii?Q?TYAL0UNPAl8WgdHiu0gOgYtg5htqR6FCn6LEzacKm/b9PgTR3LPRP4K4m6vZ?=
 =?us-ascii?Q?irkuak/PvJb9qvfQaITo2tAOQrkdoaPYHvDaUFD63+Cv7FrluF6qUCFGrjY6?=
 =?us-ascii?Q?HzTnelajOQJs/roXwSyHbkpdcSynt80iwScbXQbJuXTSockDqGHbkUenWnbT?=
 =?us-ascii?Q?DsjsQ5XWYM1tvmPguTxv8dRPnqIHZknivRlAMkEF1rl1BeaGhIOJHzN8FPDM?=
 =?us-ascii?Q?VtXVs6+Q0/tXn1W1SpsyTjP1h6OgPxR858RzMla8LSCdhj49Wh/5A5dHT/LQ?=
 =?us-ascii?Q?7mrSQC93IdvU/+2jnzbguk8pLXWi+N3803fvDxelC+iCE2Ti17knQVDx30CM?=
 =?us-ascii?Q?zgNnvg8t5jApZbe8QUTiN2bI7bRYdb4VTTVdyeVDhqcQi71jeXuKjZeU6uhc?=
 =?us-ascii?Q?AmYHGvVs/WV5fShQMKJ2rqgUNPrM3jFhN7/vgvNaRay9HSdPV3rocOgAjrZt?=
 =?us-ascii?Q?mZeYKAspf8ZHVYSUs8cLtcIx1JoBHktG/xeMgNss1CafFBsOK8TUwJLa+NZ1?=
 =?us-ascii?Q?8PGybwpWexjRuayAJvFvX2RAvg1QTH0o65WRygMBJcLHnwRXjluCKflx5Emq?=
 =?us-ascii?Q?avVBcl/Ytu+nLf8RNiGEcs0HIEvJsS9kvmeSEh3IjLNL8nv+4R1v0ZtrqYWt?=
 =?us-ascii?Q?KxY+9sFEE2knGkxSx90qXync2v961yh7yFRd3kTBMryYIq6DC4tOWE8W70bo?=
 =?us-ascii?Q?RY+OVnJ27pe3whEgiMfd5rzWKQAIZbSInRURc+RE/ZmFdFQpkbvAOWjZpMwz?=
 =?us-ascii?Q?QvLJEIFqAj+7ME/WwkOwI0klw++tvrfG3m+C/5BX+tuNMGZWvVEh8BZjgswE?=
 =?us-ascii?Q?6bIrORA4ajnIbYjTDWP4i7zxKwEmDATwMABa3xL63M9EWilnZhUnBWjj44cF?=
 =?us-ascii?Q?/os6BXIjdOrfWH0luH6QjkI3zYch9n4wDKPGgUANZtzgCwrWq0mT4SMwUH3N?=
 =?us-ascii?Q?fUBszF6qsEf1f/J52IGNB7Gb2Y6M+q0s4cXL66YP/mgi+QmxWhOttCMK9Zli?=
 =?us-ascii?Q?tHGEwKMGr821oxx2cufdf2ecCaWJMd2HmVSqj9qwkawcIX4fppuq1xPcmOak?=
 =?us-ascii?Q?akFP8vv1X/gzgkEK38kkh3yJGseiSA0w5Zs6qKUd?=
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
	2N5r2jtOPXyilGHHkGoexmrbuTKmT3ONzVQHxaNalw7OnRX8Fc1eohtcZXqZS8ygd8TXGwGu/n07nsWBnnScpZUtplhuPjqPnp/SdpiOpeORJh7se9/4L4dEnNWTzezIt5EWmTuBAQdpznS3wMK5/b0NWDmqyDjoSYWuDS1vJhqW76h1ss1WzPuOQzkMZWdfw2sI0UVyLG8cTQ7s/Iz6QfMmFHjluvvBSL7uAVp7PdwQQxRU9jGgnRjiilF99Kxdhz9aYckSYF1p4gUWKski6Ollp0vE6TZoevNf5QMmSBzd3BbZqZJPdamEe9kugBA31EXK+QGMpvBdGT8jHXAfvbD7ChRKmlhaJ77hyPTiKwzca6rnFYeBEYGce68njKNfQE6rfy4e0qMp4UU5uw24anDESG5BfTocvoVzxgzAOd+glgE1/Uly1tif0+EirOcZ41aIhYRl2uUvJcaGtC+A1c1JcHimUJgfJ10FOctC5P8/ipeSBnUfdYEWPk4EZOaRGe7kh5zvu1LXbFxMGFL5vY1ajYZ2r9a7Q6FNPm74xw3cyEEu905VMiNFfC4pVPKNZefP3uL7l6PWvWsFSoWh+GrXvHbEKiI1J1CjO8DAc920CN1wtBlDfSgLnRfNV6RT
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52e2967-6a22-4143-0337-08dd7730869a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 06:34:05.6495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pY5AQ/mwm0cRhPuy7Xwcg1AZgObFqXzkDpXv84iS7H21SO7ec3Itn6NwWK376WVni/2IYduJ8z5qLrPN6jmI0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR16MB5152

> Change the 'task_tag' argument into an LRB pointer. This patch prepares f=
or the
> removal of the hba->lrb[] array.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> f87526443d8d..883551274330 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2292,14 +2292,13 @@ static void ufshcd_update_monitor(struct ufs_hba
> *hba, const struct ufshcd_lrb *
>  /**
>   * ufshcd_send_command - Send SCSI or device management commands
>   * @hba: per adapter instance
> - * @task_tag: Task tag of the command
> + * @lrbp: Local reference block of SCSI command
>   * @hwq: pointer to hardware queue instance
>   */
> -static inline
> -void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
> -			 struct ufs_hw_queue *hwq)
> +static inline void ufshcd_send_command(struct ufs_hba *hba,
> +				       struct ufshcd_lrb *lrbp,
> +				       struct ufs_hw_queue *hwq)
>  {
> -	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
>  	unsigned long flags;
>=20
>  	lrbp->issue_time_stamp =3D ktime_get();
> @@ -3029,7 +3028,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  	if (hba->mcq_enabled)
>  		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
>=20
> -	ufshcd_send_command(hba, tag, hwq);
> +	ufshcd_send_command(hba, lrbp, hwq);
>=20
>  out:
>  	if (ufs_trigger_eh(hba)) {
> @@ -3263,7 +3262,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
,
> struct ufshcd_lrb *lrbp,
>  	int err;
>=20
>  	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp-
> >ucd_req_ptr);
> -	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
> +	ufshcd_send_command(hba, lrbp, hba->dev_cmd_queue);
>  	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>=20
>  	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
> UFS_QUERY_COMP,
