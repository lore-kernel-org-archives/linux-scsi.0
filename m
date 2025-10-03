Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FFC205E25
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759500738; cv=fail; b=PiGjByQyfeKr0qcC/X+FpsDjy5IBIH7TzqOwCi4cZtUxinESUi/LCPRqH9A7k63vmhZZhmhUY3aOM6OUYkLprqo5ihPkKAF8UMw/QkJYJm1TaF2E6U2N7i5DhtkmuZb3qZCXZ5jYZ58nJRUnLkUKvnumdbLmlvfKESll27Wly94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759500738; c=relaxed/simple;
	bh=PrbJX/xGOXsojrI84sExxlu4WveT1sWHz+A1MfUtM9A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NJbh9oGBK7W/LPyipIFXWDRz2bLLYgZJPh+GlAnkixjTGYCike45j8x2VMboW7dVckWwEU7eaTaXK1AerMTZ8JdLNKHbAhHmfekK8jPPrZ2dTsQfQ/zD/DkxpKA/VvyC+REuq/vcpx8TWcUoOg6laWcYBeTQfN8BFZYWsNbkmik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=4nmJj+pS; arc=fail smtp.client-ip=52.101.56.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="4nmJj+pS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jY12sP5c5carzo80wLXxyICuH2TYIx6Enn1u1Q2bF5ggGGhksHWezU5abxrzxbZ7/yA8SZABDK5bHaAdXHFIfiDjWX4V+rmTnueXdeJF9ME1bEiP96zlx9zRJ5MskyQ4NK9eenUvS8I3l6rq44N5FkBjIgaHi2p6fTt5Rs7zvR0rQi/cwupKILUoAPB/dX7KH7EVoYk2AMksIs8jEqzMRDPTQh0WKFd1F5I5QOV9vPqYTBeM1zdJjXenmbd/y2RJbIpNNfaxZjVqlr+W5IdKEyt8i+v22e6tUrWF117lMdUvIRNOWD2Om/zDQQmao+0agiYeWszLEGsGui8wbZUg1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrbJX/xGOXsojrI84sExxlu4WveT1sWHz+A1MfUtM9A=;
 b=HRaZ86IFjzdw/ZFb+vRFs9LsDNQeD0milZx6Ut516e1w6NEOpFf4TyEnhf52O+OlhAVN/ObbV6D0Y7RBeieJtBDrSbSiBURnlMeUyEz9uUjIyxBD3Ohzdh6bNQXATkgYbgNhrlxgDEm3aO3HOz40/5Wsb9rjz/mnMDwu3UEZR7G7PBMsHCGJ4rG/uJdG2WW0Q5uzOE6rBJQ9jICf62WPOc/B2sc9d5Yfb2y50oFhDv6pKIq/wYssKaYdED2olEsg/Fg6RrNJV683++5nRRx0eX6oKw9ABbCiKKM25eLwZa27veIiPEg6aADjkg2+ruErLhjZXz550S9wEVbzwcQtFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrbJX/xGOXsojrI84sExxlu4WveT1sWHz+A1MfUtM9A=;
 b=4nmJj+pSuH/ovD7mYPNO1rd2BPK6ANihHull5qFm2/LnkYb78Uv/yaUgEA+0KwB5pw9VTdIW7k7aeQfJbKBDxr0f/XbQuSGR0CYX4IQl/8ofJaJ5gfNcIAVnL0d20KZ3cfXvwUaBxaDbzWOvA28NHeC0yT5OL+QTwjYI9W1zKZenPaU0boECb8ir2wCcPtsiJPrqDcBNms+s96SyZj1op6TtFBryukfjmq0tyEmNMy+t4ccSbSs1AkOE3TocMMwtPYzDuO5s6fZ3RHPZe5DRD+160ZckJji+0eYReDwbil9MTPEiuMk6S/f9s4fhuAceudOMfBOYmiDR0R7Lu0Y9tA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DS0PR11MB8688.namprd11.prod.outlook.com (2603:10b6:8:1a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 14:12:07 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 14:12:07 +0000
From: <Don.Brace@microchip.com>
To: <bhanuseshukumar@gmail.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <storagedev@microchip.com>
CC: <linux-scsi@vger.kernel.org>,
	<linux-kernel-mentees@lists.linuxfoundation.org>,
	<skhan@linuxfoundation.org>, <david.hunter.linux@gmail.com>
Subject: Re: [PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic
 size calculation
Thread-Topic: [PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic
 size calculation
Thread-Index: AQHcMsgXq+8jxOyjmUeDNENoPkNqZbSweUjO
Date: Fri, 3 Oct 2025 14:12:06 +0000
Message-ID:
 <SJ2PR11MB8369D7E14C4886340917342FE1E4A@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20251001113935.52596-1-bhanuseshukumar@gmail.com>
In-Reply-To: <20251001113935.52596-1-bhanuseshukumar@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DS0PR11MB8688:EE_
x-ms-office365-filtering-correlation-id: f8e5b937-c930-42c4-c6b8-08de0286d5d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?6KtOTKz+Boi4BGLB0B1SOLTe+8hbjbUZyDrClB5jt6595Wr38FIt9pbQfD?=
 =?iso-8859-1?Q?Vqp+qPVHx8PPOW2aJLNfRBdw7hcHbZ+jTFTKI2xgKGNfAYM7qxt7V+SkV+?=
 =?iso-8859-1?Q?suDTmx2ZaG3Nt2VrZKfSmX3PhWp/sgdcIcR61LFHKAgTgYDP9fNUQ3OODN?=
 =?iso-8859-1?Q?9NvOe6IqxXyS0kSSkJevAAHSv/ZPf2sRWcLc/a66G5j4I/GINODIMX0X2g?=
 =?iso-8859-1?Q?UWgsnPTuZr5Tj6aQdX/Z7hgI/x9fx9wZo+oOk71lLk3MbnfS8/S2I6qm4K?=
 =?iso-8859-1?Q?9/sTZG6VP7p6PnL6DDahfaFjR9dauaz2OK65orq8UfYbc8FQT64t0VhwoE?=
 =?iso-8859-1?Q?Jo6jIqsXqHujccfh8nVy99sPVtJtIB7VW53R78/BqtrUU6PKPlzTaGki7m?=
 =?iso-8859-1?Q?N4JTbC5yiaAAPoP2ivLI02aGqTqxoMOE44/d/kigaCDT/7m6QuYrMBh2zR?=
 =?iso-8859-1?Q?ZSnlIL7A3CL4IJluSTIJ2KzvTciZGHp9+PKhudOYPXhTLZQcWrBYGNU5cV?=
 =?iso-8859-1?Q?k2LjGNJpTs4XiRWvPqDu0wd2dPfoZ8I31XBM+n/Er3fkZ5khd6esIUkW56?=
 =?iso-8859-1?Q?JOzN/2To3+Jclrsu3pdwqp8xK+4Ozd5aY12TibKmsZC3ElomDCuryy9gDY?=
 =?iso-8859-1?Q?aI7zguQGvWHCIkYk5M311hMgonUvFw4GMgOvRAu6UIvm4mlf2Pf6RXsbo+?=
 =?iso-8859-1?Q?b05O+rWtl88X/JY80UewAX/ziYKfrBWb84cOyox9U3b4dYxpwiADhVPJwr?=
 =?iso-8859-1?Q?hfvXa7g2DTMty0Xq1l/wRZIEXQrAeJJ59d2yxBAbmYxFAoKEEk3PCPskhq?=
 =?iso-8859-1?Q?y3rjW+vSzUuWyGZJDchGtjRMS8lw/XA2cHEbGsO/uPjKx4D7QFgd99733v?=
 =?iso-8859-1?Q?mmKop/5s6S9FEvJDd/9MtpeVCiBUfI5JA6EZ9MFh24kFS5GvLGFOho05Ar?=
 =?iso-8859-1?Q?O/C4nm1VPl5OjU44pcJ96PLHsOR/rvOwbujZlKP5i6wD3MGrqrU/MPcznn?=
 =?iso-8859-1?Q?zApgkesZdGWbODMEYOMQOSYCjtr2EIriYpY9fuULHIFByVdz7BNn59G+P0?=
 =?iso-8859-1?Q?yZ+0uQ3RkZCE4Vjt79kokVH09o+EUXNP7LiWIyC/wC+YHeoAis2Dk+cztS?=
 =?iso-8859-1?Q?R413sd6Bs9Tb7+YNjKQPrWjf3ml+9LEX2wdM70IHNgiHI8wjnD4f56LGZw?=
 =?iso-8859-1?Q?Irt8AoAvfOetDpGGFJqhOfIhvYVHoc3VV+RVJM5M2c2Rq640iqu4qTfz6M?=
 =?iso-8859-1?Q?5zMsKZVGidbr7L/Atid/JUn/W5GMGVKgU6RPAfx8LtDG19y1IVUtX4BMfx?=
 =?iso-8859-1?Q?L95nL69X8dboOJf72op9I3C/AeLcMDtv5UY8jOvXnqp4Z/NDE9jN8bnRsP?=
 =?iso-8859-1?Q?Kf0Zj7uM6tlWbxcmVCmHckKwwe9zFWpEb8iButtm+dZM0wpOTTgHVxYjHn?=
 =?iso-8859-1?Q?gJw9HSZLA0eT4UkNir8QQxqpijqoU7ZKNFn/EmMPg9PIGklJ6oVbrv1kUC?=
 =?iso-8859-1?Q?SG5sllAjH9z+FjO+QLXI12QAvgtfMYQhLoaHRQ9y46rh4JFyaOs8oPxkI6?=
 =?iso-8859-1?Q?7XhKApkTE4z3BBPY1k59uxPxMCkg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ECbijROMvQkqIlyzxwMb+FFe034hL+6QeRIqU5gKgH1mTnvlIrgJhcuLDz?=
 =?iso-8859-1?Q?ako2+n8v/3HVE7/NQBKI5e0j5tg9IwrU3OR2RzHKpbIRxP+uw5bU+6Ob7c?=
 =?iso-8859-1?Q?uZW6uj2hDBMTxJZeF2Ko/dOo85vkTEOcBsBV74KGBK4wEc9E59BfxsMixc?=
 =?iso-8859-1?Q?uO1epDNL4wh1urJsdIBhSh0Go5BZw7lC2Yey5CScj6OaFiN7EnH7Ldx02j?=
 =?iso-8859-1?Q?1XCo7gugA+9Z0DN0e+oto/ilLlgyz4+w+NhCLTk3KuQ//SbH8S7qkaFad6?=
 =?iso-8859-1?Q?c0LpZsxJMCks4KDErr8tlU+dd0QrjWMbyBIYH21Fjb2Ea/OAuplyNQyRYP?=
 =?iso-8859-1?Q?2m1OpFi57H70umPJNx64WalSi5/M4n7kyMwIXCj99gLs9WVkt/J0GCRu6A?=
 =?iso-8859-1?Q?jUELXeQ40aKkgnUIl9jIg7b5V+PwBew72mI4Nh4mFwS59su9a8N+rFDk2F?=
 =?iso-8859-1?Q?QUzwzwAjkhYpXqJucA28DEj8cOB5peBf7UAZx+sg5DiUY+J5z5a99nHCQy?=
 =?iso-8859-1?Q?oO+0pe3+dv9YdWt+bfG85iythzmZ1TSXaQKyqTOxLBNYbM2EEpyajIPA+/?=
 =?iso-8859-1?Q?kxECWBxSOZvdo/oHTcG0b6vXl1ey2CB6ZfQ/BN4yGkGO2sUm07k7dIml96?=
 =?iso-8859-1?Q?tlrM6DsYyLyhWnDm4FyWrsLfkQnNEwxMl1v3HsYYoQ0lreTR/ymoGzE2dI?=
 =?iso-8859-1?Q?s/vA/kA7SQsUWMsBdngqI3iDfPiq+bKhLj4kv05EYBKW9GK0YaYNxqxf84?=
 =?iso-8859-1?Q?A5Y3qvxzZcThuGBuxf4eivvInowrKWZHkKYU0Y9NEhOgntM7SBX5+5gfAA?=
 =?iso-8859-1?Q?ARrR+QNmpDCoodWuWlsjSjiA2+BtF36FFE/867NDz4n65pZT0kjSjvOfxo?=
 =?iso-8859-1?Q?Xihii13H/kSD3FlA9x/p3IcrzZ74ayl96+4IsMR8CgGli5OdI/KkfUmI5j?=
 =?iso-8859-1?Q?iSz3xxyTssQLmJJGB/ekeZb6gKOWxSdLWXr54SfPeIH6omhhciDVpsB/AC?=
 =?iso-8859-1?Q?j5a7ptTOsUAjZb9C34sn1/a4LnQOzMWdLwX9MZPbUI1NmSvhBZS1D4sGUS?=
 =?iso-8859-1?Q?ymn5wDToHmkoL/FwfHrqvEadkv+WnBgq0bMtDBGu4EaYZpMiFYwBkslf4J?=
 =?iso-8859-1?Q?O+nux89/AqfCy/jpZMCbZieXSdn8arV3HOVoms8MMDAkiAGthue/fCZbfA?=
 =?iso-8859-1?Q?xIAUr1jgqBWVkw3yWFfyf62qtuLaPIOZhitOOoTAaGbKIj+mgixdVbK5t1?=
 =?iso-8859-1?Q?19mqLf4nr+/ded1zoIkaaSQAxob8aNMtXO04UB+Xcjqj+bN+R2b1P3g+3d?=
 =?iso-8859-1?Q?LqM027iK6K43l04jO8eBz2E+Rz/Qjg6KggBXjMMyez1gc+OFfsdwgOlY9V?=
 =?iso-8859-1?Q?hvSLJPs1OZ0BFT3vX9/IG7DE61d0t4LjFneX/NBW+JRgWk0XZIGCQCQHGS?=
 =?iso-8859-1?Q?/AJ9W4hv98yEglCXkNMHb50F9BteGkALXkmBcdO5VUAjQ+m2vSW7lnwMqM?=
 =?iso-8859-1?Q?md5KebCj6laitW574fIMkqsE33ipRzZYttqe3ayRsYeByC1LBT2IOxR+fj?=
 =?iso-8859-1?Q?GbMjo+Kuwae8/Yha/H7D+Iv68vAhHcrZZ5np6Qg5atHzS75m01b7kJe3ra?=
 =?iso-8859-1?Q?jJIWDa4jnejKrHRMqM5jVIwgScAJoA04c1?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e5b937-c930-42c4-c6b8-08de0286d5d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2025 14:12:06.9804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jajiwmpP4j6VxL4gAqyF6FFfVqc9bU/Vd0DQGvuKgcmCT4dNY9Kuf6xk3SZFs+OHhHXDf3X3ffYMBwo5ejNnig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8688

From:=A0Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>=0A=
Sent:=A0Wednesday, October 1, 2025 6:39 AM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James E . J . Bottomley=
 <James.Bottomley@HansenPartnership.com>; Martin K . Petersen <martin.peter=
sen@oracle.com>; storagedev <storagedev@microchip.com>=0A=
Cc:=A0linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; linux-kernel=
-mentees@lists.linuxfoundation.org <linux-kernel-mentees@lists.linuxfoundat=
ion.org>; skhan@linuxfoundation.org <skhan@linuxfoundation.org>; david.hunt=
er.linux@gmail.com <david.hunter.linux@gmail.com>; bhanuseshukumar@gmail.co=
m <bhanuseshukumar@gmail.com>=0A=
Subject:=A0[PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic s=
ize calculation=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
Use kmalloc_array to avoid potential overflow during dynamic size calculati=
on=0A=
inside kmalloc.=0A=
=0A=
Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
Thanks for your patch,=0A=
Don=0A=
=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 2 +-=0A=
=A01 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index 125944941601..7ff39f1faf38 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -8937,7 +8937,7 @@ static int pqi_host_alloc_mem(struct pqi_ctrl_info *c=
trl_info,=0A=
=A0=A0=A0=A0=A0=A0=A0 if (sg_count =3D=3D 0 || sg_count > PQI_HOST_MAX_SG_D=
ESCRIPTORS)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 host_memory_descriptor->host_chunk_virt_address =3D kma=
lloc(sg_count * sizeof(void *), GFP_KERNEL);=0A=
+=A0=A0=A0=A0=A0=A0 host_memory_descriptor->host_chunk_virt_address =3D kma=
lloc_array(sg_count, sizeof(void *), GFP_KERNEL);=0A=
=A0=A0=A0=A0=A0=A0=A0 if (!host_memory_descriptor->host_chunk_virt_address)=
=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;=0A=
=0A=
--=0A=
2.34.1=0A=
