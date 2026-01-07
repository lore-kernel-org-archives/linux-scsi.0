Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012051.outbound.protection.outlook.com [52.103.43.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B32D23717F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 21:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767822001; cv=fail; b=KcVDlc+AO8ORCbWBVUOcATesb58lFpURSLjeA/aMpluBZtO18OrjjiTyTAsQ0UYnZqUxaPrLbXWFvl/F4Y/739/VXo2qsTjBw0M3jkPZisXaE1U2BHO0J5yqKb05D+zvk3is/8f+5wjH9L7476IUTB5usRE85Mxgax3n0bKLjOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767822001; c=relaxed/simple;
	bh=Q9dGGVywPXqS4wQqZH+jdlNz/HJ99IEY79I7bXzelSE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=chmSGrTgO00Yvd0jj2R+E37foiWq1d1Mzg+njtalC66N0bFoCvwkQc4dxsZLiZloFyToY9bJOy/IQgzAF2wiiL+RLwYkWOCrHajf4K0mMPX4OszVwmp4FznhVpiiw6eVWgbihRMnwrik4hOlngeNJJh7IKAI13NrP8NQOr6Rzuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=lWWc4TZM; arc=fail smtp.client-ip=52.103.43.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="lWWc4TZM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sa+ORqopazM5xo293XIhSB2xXVKILfsxw+exORvU0Lyp3YJbt5+Je0CF+wpIu3ng+XRXCkGaQl/VBddMAWYgo8QnDSBW5gkn30LjDR8c2RJTZlYn90wJxJ07qEK3fm2u9jAzW3vyASHhWuysGKN9E5at/cotZlc4TPQ6inR8y+ciUGJeWvutqfeJAqefOAG9yaJQWJV5Ze/GCy3zJbAnFdijgaI9YKp3qQ8mGfUtRG4JCYu2lc7vR5S6cqPHJAms4XSi1XWax1wZRCdYaweJ6NEKujFNHzaixg0A8CKu8aYipDYjva2NPrLstsuEs+XfL+B4aoKC/NPOCbT1utoVaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9dGGVywPXqS4wQqZH+jdlNz/HJ99IEY79I7bXzelSE=;
 b=hov400SBUJO/8AAT7xvkNcs9mk/MxsrqNY7MwssezII+SEbW0dWuWr0KhqgsKioXUAqs94jr/TI16h39cC/p5F954zYd653mp/+5q1+09hJHqhf2tIiKKE3yN35Q0ZD3duAYmA3Z6BI223QVgGR1eyMIYaHjHqtp75UjnINVIotahgDwIFWW9C5kUdn9IcfmaGT1xbj4GSYLWgSDjMp8KAMTYLUid698c+eAGv/tWldNTx76P7vvyBC3FXeKfJv7bn53cOGBmCGsR9eMynNO8IDnh1YyO3/PvNWvGlte6E1tzcIu4MzF6SwtkWprj7BCFS8SP+jT+iPHgbv6isQO6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9dGGVywPXqS4wQqZH+jdlNz/HJ99IEY79I7bXzelSE=;
 b=lWWc4TZM6T1oU9RUomr0WlxCMzh6tg60iCG5P1C8jrBEAv2V4FxK/0zfVtDptaKdTY6m1wUeAMVciq+ZQ2GyqAJL43oj0SUUmdEw9UA/Anth4HPcFsvZF/HLZwUmGNGAZX11eFsbQG+k58KLMbh3JcuUqZffCW2uQ3iE1nrc/wvkfoXAI+lFT3VwXOLDVrNJAvTEAyEXGBoNjwbLUZYRO/bHl3E8orpxlOKJD4OO52TVCtcxJNVJsDe/s6Uux36BC5Ltvw/iy9tNUKGPtbpmGwgN4fy4urxDTTrEr+c05XaL4pDYDxeP27xGGcf6pIjxf0yGTaNSBxLpzsAXYhehgw==
Received: from TYSPR02MB6350.apcprd02.prod.outlook.com (2603:1096:400:417::7)
 by TYZPR02MB7544.apcprd02.prod.outlook.com (2603:1096:405:4b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 21:39:55 +0000
Received: from TYSPR02MB6350.apcprd02.prod.outlook.com
 ([fe80::6595:20b7:41dd:e4a2]) by TYSPR02MB6350.apcprd02.prod.outlook.com
 ([fe80::6595:20b7:41dd:e4a2%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 21:39:55 +0000
From: Emma Pearson <Emma.techuserdata@outlook.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Satellite Event 2026 Audience Insights
Thread-Topic: Satellite Event 2026 Audience Insights
Thread-Index: AdyAHilQ9AtH216KR+u8XfWoDcoCJg==
Date: Wed, 7 Jan 2026 21:39:55 +0000
Message-ID:
 <TYSPR02MB6350B9D1C59414F30C23DC14ED84A@TYSPR02MB6350.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR02MB6350:EE_|TYZPR02MB7544:EE_
x-ms-office365-filtering-correlation-id: c8884ada-4c8a-40ae-a090-08de4e354c8e
x-ms-exchange-slblob-mailprops:
 q5r2+9D+CgNiBSRhAlsVV/RiEsjSga1NNZIsSG28UmGkOaj/jf+EtNT9OkY2+50OQ7G14Fa7qqr2hydenF9jCzx7t8RrK31Svh0oj+/97V6xXtcmxkxad1ONs+RdGzPowal5oFOpr3XQe73jaIJyl221de3Jh2BH1RkaRFsAU688u/lqege9J1t+gUNwNAdbBxvOIENVDS4I8hB7RKRef0orPhvxoQsO1obHU3CsQXifZgcFyUw2KzVqIuKBssyRK/YYsJPxvvPdSgzXFWPBKxAreB4T6Ncu/TTsnDGXPX6jj31qJUx9CJJM4cw6LbjUuIojESEy2VXW8zLBU+4R1HmNQ6pOg16F9QRDrKjOoMp81uv3fjkoyvjwTkRZY0OpxFOjO4bKJOezhePFvU5L01l5Kn+cKfkppm5g25zhh538yKk0s4Y1iP58kPAWefXZzrLwzyuvkPX6Jbt87372KgIAFTSmOPkEpxMi5CrkXy5KFqe0M7kLLvIdGvBvznvKBVoBsHpmDOqOBs1C855MvCUYiBhsEdtyrlP2TuIlVuUUW6QdvLbzstsjPrSZXUXy7oPAIkfJu+i76c9MgIp8D/LuaQWJj1Z5
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|39105399006|13091999003|19110799012|8062599012|8060799015|20031999003|15080799012|31061999003|3412199025|40105399003|440099028|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lsSsFJD9fbSQEiXIQ5LuoZsyaBYncHIPdld/Q83cQxYYo/Xy7bTskOMHTcqL?=
 =?us-ascii?Q?kXI0gtT+OZe1mHmO6MM/KNIGg8fn5ntD3wejnMh+KU4+Q7nv3PCSy2t6Q161?=
 =?us-ascii?Q?luVUuOeJgPbUSYHNwyyvxawrSUWz0GH/Jkoa2wgdZ8bbRIqK17xNWy0kLAqJ?=
 =?us-ascii?Q?3i4noLZhwEzlClrcyG5wbUuhJGm7hArPoO0xyEMvsMlUBugaiEAvdKFL0QRc?=
 =?us-ascii?Q?hyaLaFJZrrQx/jqjoUGSOG4/hYrrzeN4/W6zYekg5ygjPgKOatdp/vyNoaIv?=
 =?us-ascii?Q?/Sg5++ljElFrhGQDXVEi9LmNyhfRvcpgqq9Z/I2jIc4u3S4TUvP/3NBcKi79?=
 =?us-ascii?Q?DtvulBs48gFZf+ISSnmMK/6fUuVqm7einpIAdN6cg6ghajjK+GbjVaFtRexu?=
 =?us-ascii?Q?TiG+q6hhrQkugsYGy62O/DK49MnlRk+5v6O7LsAkuwhNpSmoyX1t9b5ERTba?=
 =?us-ascii?Q?2BFH+VZayReVVGAN158Rbo4oS5q77s2X3ggEd2GYIpYRV+VshG4sqXl9/CUn?=
 =?us-ascii?Q?aX0yc834EePvVi0eFCLMSOTQ12eQMe8Kqt4nSTHp+dUMdLSRnyGZzeQOJfb2?=
 =?us-ascii?Q?YGvFXm0/2GA8+cGBrq9858nSkGEbGlAlGretZY9BIjrAk7WhoaSsms6nzrtm?=
 =?us-ascii?Q?IGOC0yk7hnnLqLXb/EFx2GtdqUPzoS68dOiQBAMk+yIs8D3u0TKzLv3TiEg9?=
 =?us-ascii?Q?e1v9Q06rMfS8uOCOP6BVZ1eS/q7+zsrB8MHXDZ8BKpWThuZJ9PoZe2wuo7yw?=
 =?us-ascii?Q?QZvwrrRuVDiAR/4RTWwjWtQ30lpq46sOjyDdK3ofwyc1RdTJEbTPyOoHy1sE?=
 =?us-ascii?Q?5yOMPwU3aLNwMXlFArHQi4X69GijR/4i3PuSilP/3MCagyRYzF8k0zuPW78t?=
 =?us-ascii?Q?8x+IL4TqyFNe5xdEEo16vv+XXOIvlcP53pZizq0xdQZzJf6W4xgZ+eZQYD3t?=
 =?us-ascii?Q?3up1hwsgU23iafPsrfvRWhauM4qQMtZMQftwl9P9hfexxtx5Edg8qMfrb/lz?=
 =?us-ascii?Q?nZWQhYg9tILRu+hhpwHDEcDgIiQ8zOFM4QMAlvFwPmWSfj0Vh3c+T8gLHP0G?=
 =?us-ascii?Q?RXm5PJ7Ed/3WPnllrANC8iL+YpGsZDzg/iVG8/4RqvjRCY9FNRH3llFje/kb?=
 =?us-ascii?Q?DYrSdvJNGH6wMgbK3e9vZYTb8hd2qUy0hw1k8bJLW4H3whrzWEIzTz6DTUbd?=
 =?us-ascii?Q?YaInfi+J2tGIH4WLBcXOPGgWtc1mHaF+4x2ddBhL3u9AjSAPHfLT2AZBJZOH?=
 =?us-ascii?Q?b86hjDTFABykO5VDzkWx?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?T5NRVXib9JyHZn6mSWoCFywyVwHSlcs6eIhHEJRUFebsaNO5UcE5HFS0jhu/?=
 =?us-ascii?Q?kLBFJSLiSjRUKX5h8bJdX71GdqstEmMsvJI+Q1N3DNMYmkp/M/SmsIMJjWhJ?=
 =?us-ascii?Q?bBHMwFeidKJgsLCfTMZXVdKezP3mRWmwQzLFVIuG2n7jtFKFNwQNxmmWqyzV?=
 =?us-ascii?Q?GUCZVE1aenck8NVgTG5qaBArT+tJE6Em89Unsk/4Ms1ReiNqvTWMnpso4gxO?=
 =?us-ascii?Q?oBIaOgUNsgkya5PjBVM1BjNeTPKXErul4pwvjysnvQSrD1SGk1v8eC7ol+gg?=
 =?us-ascii?Q?mav8OSZHN640mogqFh1dj85JswngSYRZWgDYWWZ1v0jWlkGTEmB7I2i32df2?=
 =?us-ascii?Q?fkEfLI0aMp7d5SidY8WPioN4WZSolKF52WqeDcxXkmPmUvfq51a68YiU/lGk?=
 =?us-ascii?Q?tA3AM2gU8MBCUQCURRClSIFo5Bvm9NMwK6QgCYgi04Lb+ERb5LHJCOmPla/d?=
 =?us-ascii?Q?bj4EvDjHC7MqX911FKjq9rQIvL3CqUswDynzuUvoxtce0l6KeyFXlEgw7hjO?=
 =?us-ascii?Q?K5r6+f6as5m18seCP48FqPOQ51TPD9XZlJbjnaqCmuTTvHv1KMYife8w8yKh?=
 =?us-ascii?Q?NeJIMEqafggjJebH1vViEkZ/QfuU5PhN/CPDVRpbUbdvD+lzzfYjgr5KguTI?=
 =?us-ascii?Q?91oW3Q40QKa76M4ukjhAqmTbINMyPvUlGyw0PiOCIEOXGxlpVfWfcHt3KauA?=
 =?us-ascii?Q?DPDmj2VGkPpcTsCIUotmxTgzyRSUDwJlTFmucFFp4HWfhMG5pRFSTckqH07M?=
 =?us-ascii?Q?i7VAk2/QTgH1w8g4EURld/pY1hYwORlaEsZSE8de7xink8UrFAMlIKMAY9RK?=
 =?us-ascii?Q?ty6RJJRz5GpPKojiLB2xF+8x3KviWgIJxvg5UR9ofubuBxHv+0AK/TMNuaxp?=
 =?us-ascii?Q?QKsOus6idfUqL5z4pPo/bf7FVTP8ofFaMjr5sT0UBHHVoYUJFeICs/u6uU0H?=
 =?us-ascii?Q?8j4+HwmsSojRDGVGPfkdosEw7UeVFXeprZvS26SvkAFTj7YVhOy707mOLkjP?=
 =?us-ascii?Q?+FityHAOpwrtukOI1XkEBlUm6/4D4xeXCKrh2IwS+1s6mNNX6RGsooSq+Qmx?=
 =?us-ascii?Q?N0JtAj/He+a+8o9M88rktWsUiAyT+xMGwoiWHtH448jC1RT2opTQ9Gsh9tMP?=
 =?us-ascii?Q?wrQU7EAr694FdLAtx5nLJH3uIwYrgkLrXfKynqE1PnDhDhkIVie7QUU4Jp0n?=
 =?us-ascii?Q?lnhgZk+/Qs60FO4wth2sgJXUhnrkqzkFNhEzwZTlXkTSzkkUeXvMZi8QQOEQ?=
 =?us-ascii?Q?Eccc/ThvKUOp1PPZgxh++TmBAdNfa+eSxPskgAD4XaXKWadgrVXuvIqkNGBZ?=
 =?us-ascii?Q?kCNUul9CR47D+ICEPopAGoWSQJxBiSmHfh31c0HfhIu0Ik4Tf9PwXbO5z/QJ?=
 =?us-ascii?Q?ELFYhnjiYpOI807EqOI+2O8Q3I6rrfb68TIXtZVzoHU76av02A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR02MB6350.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c8884ada-4c8a-40ae-a090-08de4e354c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 21:39:55.7477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7544

Hi there,

Would you like to grab the pre-registered email database of "Satellite Even=
t 2026" attendees?
=20
Attendees: Aerospace executives, Engineers, Government officials (defense, =
military, intelligence), R&D leaders, Telecom leaders, Launchers, Entrepren=
eurs, Investors, Developers, Technologists, Technology vendors, Directors, =
Manufacturers and more...
=20
Reply with:
1. Yes, send me count and pricing details.
2. No, remove me.
=20
Thanks & Regards,
Emma Pearson | Event Coordinator
