Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EEE27B354
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 06:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869092; cv=fail; b=r5dhw1pB2zKHlg3lFQwRwdzKg22rHKWRABq0kNBkHiYpXo+4dT93iNw8oolq8Ob/eO2OdBOLIP3cuNZ/lF90ScOFsHGgxb2xcKavwaQ1RP3f3o8y+J1g8CGaH3R9BtljmbiPxVfh68ZZrp7nvFSf83oBPNHoysgobdV8SH/jzMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869092; c=relaxed/simple;
	bh=O9VtMq/vegiVpYsLc3eVOkZ5rkzHjbWobrZMJSQQo3Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z9Km8lb8mIzX0zaF4VxLW7chhJZWOv4TrIgQmAGuPk9qo8lT9hlHYme3NYKEe11k3H4bke5YJroXevWXDdQiFbtCh3F0okf6pz1EiOZPK4aqJVPDzrBhYxFOsowF69QK7MxNEsoAhT9SCmfDG8ByfyGO2uIPei2NnTDv3NIrRas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=ZCJLuzl0; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="ZCJLuzl0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758869090; x=1790405090;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O9VtMq/vegiVpYsLc3eVOkZ5rkzHjbWobrZMJSQQo3Y=;
  b=ZCJLuzl0zk0lezhcMToalFdlZNt4PLa6BwxQ+AK3yDAd4EnK+urtGlHY
   TbjqeNP4JxITd6UeS0mS8k27OXDOtCAZ8ZGDO+gZoGWTn+Bgo1OvYsvXK
   db8JfKq//lr6rdMzgk2XK0FyELRQHWcGL11sUb7aSzwaZOdK4tqiTOYbm
   tNpUOAItXHdtgURXLx9VJL7iNEF9DW2UtwBuOGNM2eBkemYkMJRwhQ6M8
   xB85Vnt4U9MIaWvwHjLXNgC6R7794v8hlDQRs5G6SQ+0JSxo0NleisTbj
   Sei4nit1y8huq7btq2WevEjXJAMo5IQ8vNGpc6D9jpH4hqErN6k35fv8I
   g==;
X-CSE-ConnectionGUID: cL8CjYcIRp2Lizq+Q7eNhg==
X-CSE-MsgGUID: +jmMa4GmShqPgwBHkH1BIw==
Received: from mail-eastus2azon11020082.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.82])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Sep 2025 23:44:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TWn/Znh72Q/HdEdJ3roAkoNejriw64lQ654KNSQGPMPzxGuSjgMi6jhp/StQCn0/pIE0h6fn6owQqlhDbVtUStAskqmz2eZWdFYT3PUUcmkNm3iD4gDow8+p+vn4HnBpbJL7zGdPE+pQLd9kp8yI5nS3IZ7QPatGS1v+8jQoxigQZ4bt7zfJG7CET5i5xxw8Xx4P34MOmthk+arGTCwOVUs4sXOcnu+lrtDiJMJa9jRIhMa6dZTu5X/d4Assa3ybCCGs1MLbtdXCUOl84nzzIuKnaAn5klG9ZhIcnzAtucnpQ2zknEsCKaO80YxwCGMTZ0sVOzGGxBwD6cq66CU6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WzG0wCsoQtMjn7cSC93hR5nDeU7Z5g3jX/w0xo9t2LM=;
 b=Qrr0wGoWktin4NOK/EujcAsj2enfeeuVZ5hUAaEChWSZjuq68K/6WgMWBRIlj8bMNgf8D0cQhZJ/M6rb2DsWhA7PRpevGdcW4M/MHaXgld7KrjSlUQLXjy32z6nJuL1bwzU51n3b76m0QWS7vrOM7/6pBXda+7pvuFXcB3lfafX9758pLmJXg/Pt3N80tjcvxgQGot5/8lLgV5rG6N/KLiP/PfkxDjXt9sSgz79ivU8ucxNiOcm6U8k9ybqVHSg6EI9+QRSVgINlbtF0dAtuSJaPTbZbmhW+gpf4QXLCHDXHgWpXTrClp47O2YV21go7UmKZzCwnU6bmdfCnJPGclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ0PR16MB4029.namprd16.prod.outlook.com (2603:10b6:a03:31b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.13; Fri, 26 Sep
 2025 06:44:46 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 06:44:46 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v5 15/28] ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Topic: [PATCH v5 15/28] ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Index: AQHcLZKCSfAewPJN+0qYd9fpw0hB8bSlBs5g
Date: Fri, 26 Sep 2025 06:44:46 +0000
Message-ID:
 <PH7PR16MB61969B046CFC0E3D32CFEDAEE51EA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-16-bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-16-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ0PR16MB4029:EE_
x-ms-office365-filtering-correlation-id: f5df26e8-cbd4-4da4-eb5a-08ddfcc82ee8
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ZyvN2RIdO436ZBzcOpZvXCfwKfV+5WcPtKAJseceO+ZVEejOvZjHtCNzXCsY?=
 =?us-ascii?Q?NZqg4/4LNzKzem4uL6S5A1g6UCM/0i2tRLw+Hx9acTZDa3nWU4nmmoKzlXm9?=
 =?us-ascii?Q?c+shmoIDWEPe/XFHhgMGBMI08lATsXmJPxjna7USHHtRmdF3Kaxu2u9ui8Uk?=
 =?us-ascii?Q?zgoepwO/BETBNHZiSPvAkp53qNT2q38406+g1ePkkmBrVxgAsmF4eUfxfrcx?=
 =?us-ascii?Q?cUrF0KzECjzuyxLp5338cTqzXWQ4GeUYayOzpuWqjGDeqOwDZWipMNT8TqbF?=
 =?us-ascii?Q?hPwYoU1LNsg6UhuE/2OAUqhOdsyNhXostHXHvNSpBulpz3INM5hzzD4Hd2uR?=
 =?us-ascii?Q?t8mUVR+hDFQ4/LL4CA6NfYHkwrEVE8fFPfK/y7Yi4YXK0x3MXjopdMqiu4kB?=
 =?us-ascii?Q?CnqCcmByt2BzuFwTn7gl94xb6O2NWaQnZtpt4g4DQTUYgQGRPGfV1yJtaYsI?=
 =?us-ascii?Q?AJME0ooxMLkvQlM+B1Mc5MSy4SO1jsYmoPPkLpXroVBvqr+xbBE1C+9ZQb5E?=
 =?us-ascii?Q?EniJ2vUlEy+AVM8uQhtqpTNk0IWTivDztT4TjTf3nGfEYZUvK2iS/W3sW/YU?=
 =?us-ascii?Q?5tk9RnHMzetwUpfRiayanuSjBqnh9u2Q+M2V7aCOB73CfS6rnezvBWtEoQz1?=
 =?us-ascii?Q?FLGKGnnEWU+u3SPaW+81xnp/LQ3vSLUybzLCaNT66Xs5ssJCZBSTft2mZiDE?=
 =?us-ascii?Q?Qwotk8Wdz13iUcfEKwmr1Ew7WTshWF+SZ3GH9/uDIFptPmyxW2iyD5j38Usj?=
 =?us-ascii?Q?C+8+hLJgSf3+4+ZcyJ/hwc7hNDprJ/I+YKDplqsLwEYVqCAyv63DeLImupFL?=
 =?us-ascii?Q?sygIi6c82sdN0JqyINK2tXNvWD892hEJf2yMzWCqR8qDrGWu+whjYGNQHNUp?=
 =?us-ascii?Q?6e6dKq8D8mSgo5H9yZPYdd52NKjjJnWzqDpXCrEX0qKD2XdvMUFvxaVr/1Ja?=
 =?us-ascii?Q?8ESxxmH3rC7F4U3WrMioSxM0sSA9ieFgte4fpXpNT0XuKeLz4NYqleO8Qv8g?=
 =?us-ascii?Q?Cxo8M6esnJgtqKA2GjU8xnala2uKNFuRZdf+xitjFycyI118izLT73bGRzHV?=
 =?us-ascii?Q?M6ygzwhGT6FYmvUkLm8/D/tJtgsFBPN10ltY7Vfv0Tl3J7wL0Ijvw99ZclU0?=
 =?us-ascii?Q?Bi9RKpp7n32QKHbhIDkfG6BCrVqT2fE2uhUDxGY53Roulyd8/x7N8jzWDf/k?=
 =?us-ascii?Q?62AF2R3jTIvRNfagpHsgDCeHGL863JlWaVcy6GFrh0/xva6uG7/03TKdlbL3?=
 =?us-ascii?Q?lVw2loKA9kj4O7bdJvbOBX9V0SHe5f0JtIMPsLWmIXtlkoV9a25N4n3Rl/1M?=
 =?us-ascii?Q?CyJDvVTrSq3+ga/s+nfWD2NRjREsGNzOttGMSKGTviaRJJSx2VrqA7PLL67S?=
 =?us-ascii?Q?b8QvvMLVrHSR86TG99cBZ6jgrOOXEawpxE+xfmv4S/32ehhAtllsbVV4Luix?=
 =?us-ascii?Q?xF5++5nfmlyL5UTIIop4RqZmUjKAryi2j5Pq9WF61M6doIKmvjAk+XCC3oXU?=
 =?us-ascii?Q?XVq5GCOP6IIxtUFKixMiV49XhfRFwmwoieZT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4qAiX3w55Ps3W+vuV+QSyTBnhvnJZH4xvVpO6NL3j3r0WuhEvrHw2xS9oK3V?=
 =?us-ascii?Q?OUbeoRC9EynA/40Umcoj96jRB+rLxrFAgR2rtnv9rvw7B+DexYP7BiRS/Q4P?=
 =?us-ascii?Q?Xjbvs4+RynCP+uDac+JC5gnLb3/S1EuQUi6JAvwlrYDXbFiyt+YLybuPghM+?=
 =?us-ascii?Q?3yC3ySd+KaGVjejFs5YzhvpuhuPFB1r+7/imuhQzvRwXG9ReUbkTW/OwEA93?=
 =?us-ascii?Q?8ifLAuuDMGzAvvN4YB0M0pOAXsJSBiX9beHj6qYwD7J2X/OWejQjb9/Qm/9M?=
 =?us-ascii?Q?Uq/jgrNtubHWmoXfwf+Kc4M7U+nWeDJuBXxmGasesnTRc/XemiiOESmoxU68?=
 =?us-ascii?Q?VFfQaYrggPxCnX25GTo87+WwPKhjaJIyUPYkEjW3Kggj5qgamyRE3vakc7LQ?=
 =?us-ascii?Q?LVWA0cuJGMKCINaMzjBV4bncxJp5O7oLCuW92rQQStURJpIbNlkwp75+bsAA?=
 =?us-ascii?Q?6zViYx6hvXcZG1PjpBZCxrlWdT9RKUeFZL8liQdEHhlxvYeTNXVu2ilVXxJa?=
 =?us-ascii?Q?LpxtT7YhOxROuenGfRzREoirtxzEUFcDDONGtlX5mxFMpZzKh0PIkhDCk1gA?=
 =?us-ascii?Q?2vaLFYlDDm9vIA0dfxinBOwT/zZDEb4TnWCFGgdDkbR4bxs/HzGu5XQI3d5B?=
 =?us-ascii?Q?7ZVkpZi7tFXtpg1lmUcREnxyynrWUutqcrg0CuyvaF+62Gf67z7u3T5MARYE?=
 =?us-ascii?Q?d3FWHBMXES39sWrKzTbrKFktbq+cjZegsQo/jKLv63RG7tK65CP2FnPHugdQ?=
 =?us-ascii?Q?HfxlQSVC0JZg/VaKtipNgWidhwcvkehmPr+j9W0+N52hjohd94bYbDK352JH?=
 =?us-ascii?Q?NnH4gEI48mO7qGXO4Q0jKoHZvx/yOPONpmEMMwRm0cA4qmGaI/y7d3V01m44?=
 =?us-ascii?Q?AYq0B//r7ov25slTYtVgmmVBeDHrYizRs8SVeP5nrUpRmHULyMXt8ym5nsFn?=
 =?us-ascii?Q?pzAu31C0ev3DXQQ4EDuRVbIcsU53p2xSarWLcpMBrQ8HmJTC5+TEaSRUU9NZ?=
 =?us-ascii?Q?NZ1eiDfmh+f859rgrxxrDDviZvr+kcXeQxMJO+k4YJ0w8PZwqlrp2gChXvbS?=
 =?us-ascii?Q?vG63kjW9C95O8v7Jpco/uloxKb2GH5oPW62OBAt8IWIPJzBFw/sMmuANjeDU?=
 =?us-ascii?Q?ZmjenPKT/c3RC+IuMimrk9cJsEjZjHh/Hq/oyd97r+qxxzB8ZfPZkcfSsKH2?=
 =?us-ascii?Q?+zqPkvk8sRE4cp2jg2MTZTMmOK1JWKvng2vKbNNf7Q9odr+bEU7d1fnLrJR0?=
 =?us-ascii?Q?0hsrjX5N2IpRMn57oLIiXsYd893JocGtq8kuXz4HIJ2q2grXbE6STgsGPQEg?=
 =?us-ascii?Q?9A0MUEYnpP53MrdLPm7UXuvqwLsJaD6KvJ211u6B2VNzQill4JxdPjxtBdgt?=
 =?us-ascii?Q?kQCj1LRcZyovj9e31d9Va9k53M6GXabDsydkvRflCFzFsqALuHxqB2r0KMSU?=
 =?us-ascii?Q?0OP1c3chl2TS9zvTrP1tahTYKQ5VNxpHR5BKxDSIiBmvucAz5H6QAWpI2Lme?=
 =?us-ascii?Q?g/HSXkFvXP2uhgIPd3wGSKdF6BxNXkmf733ykMX1cGb7W+A6XXdmIJ0Vmsr3?=
 =?us-ascii?Q?1PoBbVjpp0WOWSVItdAI+/qAjPpVTD/VgeZNSQ8R?=
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
	MmzwkHEW+CAETbdk6YzOQBlkpgXTFLnq1uQIzMMjal76ducVZgC93np6vPRjLZGOfY+r/6i7P7vzcgemX8KZO9SOt3i3kVLvmoiQZ+gslD/nUnslLgUmmOBMgLo20HMWkk/MYD7+huSUXnv/oSFW+r+BSENN9PpsxdIQ2cozJ9TxgrOwDQ/4c2UPMH0gQ0U46IcP8JS2DhLU60uUr1Q7hRUH1A1eieCI4+mZD175SyQFNAy/DXgdWqdQ6G/OkljXivUGizfwEYAUJSoGzx5rS+dzC082W6NKlDnMowMgZtYOonUZivLCGa2e33oEtdMIOjvqgYY8kysU0THvYRsDefqoYEVWhf0yk0rhg0e8u0SXqjeGD+Rbl4/HIRpK2KJawsWhHjHv39QbgpWNRetSsvOKcApg2tG27eKhYLVLHLDJ/bOb2zfcH4UcwnpEL8mq0G/1sk6VGgBC4cMHsuljEYnSaY1XY/enfAG48dBjic/PvWhkkAUch+DRNDE9EXNOvbXTJe881Fed4dHfraOt6WZQbmL6s/DK/Chg8qy32kAI8FHTeZFkOC4EZUTgVnpcbxC99O5ThY7XHmjvi8YU9J2A/AV3Xe/ZPltxaR4hy0y0GR/NEEKBaLnGuocZx7jGMrnTVTpuCmr/AR7piipGyg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5df26e8-cbd4-4da4-eb5a-08ddfcc82ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 06:44:46.6622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pzn4gsEOTb+hQ6uq6OjCz8v3QvlXzc83o1Z3l4LP9nSMPJ+rXWlLEXYDjEM5LwdhSCumOlAoIt+SjTbVGpUnHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR16MB4029

>=20
> Replace a tag loop with blk_mq_tagset_busy_iter(). This patch prepares fo=
r
> removing the hba->lrb[] array.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 80 ++++++++++++++++++++++-----------------
>  1 file changed, 46 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> ec1c8bdf07e6..eea9e707ab4b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5717,6 +5717,48 @@ static int ufshcd_poll(struct Scsi_Host *shost,
> unsigned int queue_num)
>         return completed_reqs !=3D 0;
>  }
>=20
> +static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
> +{
> +       struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
> +       struct scsi_device *sdev =3D rq->q->queuedata;
> +       struct Scsi_Host *shost =3D sdev->host;
> +       struct ufs_hba *hba =3D shost_priv(shost);
> +       struct ufshcd_lrb *lrbp =3D &hba->lrb[rq->tag];
> +       struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
> +
> +       if (!hwq)
> +               return true;
> +
> +       ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
> +
> +       /*
> +        * For those cmds of which the cqes are not present in the cq, co=
mplete
> +        * them explicitly.
> +        */
> +       scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
> +               if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
> +                       set_host_byte(cmd, DID_REQUEUE);
> +                       ufshcd_release_scsi_cmd(hba, lrbp);
> +                       scsi_done(cmd);
> +               }
> +       }
> +
> +       return true;
> +}
> +
> +static bool ufshcd_mcq_compl_one(struct request *rq, void *priv) {
> +       struct scsi_device *sdev =3D rq->q->queuedata;
> +       struct Scsi_Host *shost =3D sdev->host;
> +       struct ufs_hba *hba =3D shost_priv(shost);
> +       struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
> +
> +       if (hwq)
> +               ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +
> +       return true;
> +}
> +
>  /**
>   * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
>   * invoked from the error handler context or ufshcd_host_reset_and_resto=
re()
> @@ -5731,40 +5773,10 @@ static int ufshcd_poll(struct Scsi_Host *shost,
> unsigned int queue_num)  static void
> ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
>                                               bool force_compl)  {
> -       struct ufs_hw_queue *hwq;
> -       struct ufshcd_lrb *lrbp;
> -       struct scsi_cmnd *cmd;
> -       unsigned long flags;
> -       int tag;
> -
> -       for (tag =3D 0; tag < hba->nutrs; tag++) {
> -               lrbp =3D &hba->lrb[tag];
> -               cmd =3D lrbp->cmd;
> -               if (!ufshcd_cmd_inflight(cmd) ||
> -                   test_bit(SCMD_STATE_COMPLETE, &cmd->state))
> -                       continue;
> -
> -               hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
> -               if (!hwq)
> -                       continue;
> -
> -               if (force_compl) {
> -                       ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
> -                       /*
> -                        * For those cmds of which the cqes are not prese=
nt
> -                        * in the cq, complete them explicitly.
> -                        */
> -                       spin_lock_irqsave(&hwq->cq_lock, flags);
> -                       if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->s=
tate)) {
> -                               set_host_byte(cmd, DID_REQUEUE);
> -                               ufshcd_release_scsi_cmd(hba, lrbp);
> -                               scsi_done(cmd);
> -                       }
> -                       spin_unlock_irqrestore(&hwq->cq_lock, flags);
> -               } else {
> -                       ufshcd_mcq_poll_cqe_lock(hba, hwq);
> -               }
> -       }
> +       blk_mq_tagset_busy_iter(&hba->host->tag_set,
> +                               force_compl ? ufshcd_mcq_force_compl_one =
:
> +                                             ufshcd_mcq_compl_one,
> +                               NULL);
>  }
>=20
>  /**
