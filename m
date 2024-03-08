Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7F951C36
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709888417; cv=fail; b=proWUPiC4mO8SWxW57N1a9DkPn1wwZXD7fe1CB2JzM4kop9ugI+U+40BVMSdsSNPw2VExYI0q8NSypqec1CSD6z4nA4yNsUmX+16anhxujKnxEghvt2g6pibL4TufC8Mh2jj8KA5J1WtKd9VijfwPylZA4REq1csiu5ltOdy0KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709888417; c=relaxed/simple;
	bh=+nPN8dggmOPPIfHjp4WedW+hKyDdEz2GJpS6boOeJIU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=exBeEs7XUk2MHmYb4TDH71OzGBsdaQssLbxbhl3BAhfczkWLn6Ydxwp5C6/9OsQdlD6gD/JGSIagXgzxIAaX5u5gkT4pgNATTUY3t3X6yESRSAemcbD4ZN0Zau8ezvFxat0ag0TBDWGfQ92TYsLNiLgbjn2jK1ecAf38ymI8tTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PfVZQ8nb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IKJQwnTV; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PfVZQ8nb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IKJQwnTV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709888414; x=1741424414;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+nPN8dggmOPPIfHjp4WedW+hKyDdEz2GJpS6boOeJIU=;
  b=PfVZQ8nb0VmT2PRVy6nvetD6iIciBEc3Km6ogi5CebIEAufxDBBlLo+r
   /Qu8VcNYA+u4JejK4BroIKL9nHxFNjQohgDSp9te8pKDSNhZaImarA82P
   6V+UmD5HuxWIib38RVkR5c9d5sJZPMPnMsrX9ZxIuJv/7tgwlyWX2G4Q/
   hC2yf1QENucLXZ/j8zTDLFHpCkZD7tOW0ct8qpvZp3dN3yZh1xsFabL1t
   pL4Mpu4K6HJzLT4af59JFqhhOxvyamE5+It2VCSgMYXcBE7pyIAAtAJHf
   iZPTjJc1luUKfZdDtA22o/So/I32vfFTwlIPMUHJV9xn6cleXdFBmVIwT
   A==;
X-CSE-ConnectionGUID: 3PTKE6JES4W4RFhMQufYCA==
X-CSE-MsgGUID: gOLn1qGuQq2HoBFMK3vpmg==
X-IronPort-AV: E=Sophos;i="6.07,109,1708358400"; 
   d="scan'208";a="11114639"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2024 17:00:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oa66HpeI25Fiw/iaWkTrcTyMtvplkVeeEHeCVKs0oTfoaZeIKepw7B9ERg6aZ4LTkAV4MHkUJjr6dyWu23ItbzBOzbEY3aPYyO1uMJVUS6FN6d2DVhAb/cMvMxzP21vxZr0EKKoCjmRDYBLnkc8vU21jBERgs9RNy4itNpjvzHieKBEf0bWCuYRCF28yEujcj5ExU6M2oPZekgWAE7hhHKIuAfzu/F55K7kQjq5I5/eA+Nk/7GFnxtDe8KM5L2UKDyMfxN3vrkHk4iSpOglSB8H/sai88O+es3zw2JBc77DXrvI0QQfKdYUKBfLeco9Oat0QYCjYxLqD3rMFKQVWuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8hZa4ILtwvcADmziQBIlRY/Wh/bASqXeWfm9iuDEbI=;
 b=XnbSj/eFX59lm+wN3GgivfF9bwaGHoqhVrwinmuoUOHQa9DPFRNSldpd3cZKNtFDuVNfhWVL55GQZhnRbX75c8rdEbXpQyIC5IftyAF8qrGdA1jRz7XP1/lBn6O6oqM7Pj/hPb4MNtx0nqJtBLTb6dqqpH0BLmWHVW4ReBFY6Y/ooP8ctXlWYdzm3EXxcNIFwHHyR+VeXVNd9vXsdVIibfkq9t7pJjvpxtINHJ5GN75v1+IW4ryxSkTnBQvAzQYTBifgFNse3c/ggZmoAUERJAAQaTtfeA1b6bFKx9ItuSJhRNQZPjpzRNb3MyxKCOSIvfZGbyF6HW9OQAZXokHVsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8hZa4ILtwvcADmziQBIlRY/Wh/bASqXeWfm9iuDEbI=;
 b=IKJQwnTVx0ydR49JSKU2VvtZVn7G2bfxYVxzGhyy671tVKrohcE8Db360qTcsLpyehxeH/TCl/wUOpcaSJDwVvFBwDbFzDJTElcJcIWp4In0GP27YDDQ2hDxQ8mshFfy28YM7VS+E19t+o2/xmIeDe25Q5aPCDmYTY+Iy7z48fA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN7PR04MB8461.namprd04.prod.outlook.com (2603:10b6:806:323::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.29; Fri, 8 Mar
 2024 09:00:04 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 09:00:04 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>
CC: "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
	"alice.chao@mediatek.com" <alice.chao@mediatek.com>, "cc.chou@mediatek.com"
	<cc.chou@mediatek.com>, "chaotian.jing@mediatek.com"
	<chaotian.jing@mediatek.com>, "jiajie.hao@mediatek.com"
	<jiajie.hao@mediatek.com>, "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
	"qilin.tan@mediatek.com" <qilin.tan@mediatek.com>, "lin.gui@mediatek.com"
	<lin.gui@mediatek.com>, "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>,
	"eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
	"naomi.chu@mediatek.com" <naomi.chu@mediatek.com>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>
Subject: RE: [PATCH v1 5/7] ufs: host: mediatek: rename host power control API
Thread-Topic: [PATCH v1 5/7] ufs: host: mediatek: rename host power control
 API
Thread-Index: AQHacSapekKWwlO1/0+ycPW7AONoeLEti5TA
Date: Fri, 8 Mar 2024 09:00:04 +0000
Message-ID:
 <DM6PR04MB65759091E0E9CC69EDD79255FC272@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
 <20240308070241.9163-6-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-6-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SN7PR04MB8461:EE_
x-ms-office365-filtering-correlation-id: c0c2c979-298d-49c0-bbea-08dc3f4e2584
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 LJ1cKajIIUBk4jZQkky2jkdoI/TrMwD1G0Chp+wCFLwvNmeQcjAHgt44ybPrhFMN7H2eAB44FMz43hwkzu/7fhgggg+Tqmc6pDyZbsMW6Pg1CSoCgzni4Cng+LiIq5RDW+evOv8l4+v3fQP2KypnS/AaBjeg3mFEjMhpARDPAhwjiACp2y/EiKDjuQ3dJrQipCN131+qmpwENZPBx/wKTi3uaCs+LHIeWAZGZrykLy7jKhfNUeOKznvWcckztv+10FcL30gJgSmuXM9tcSKnFmpN1h7K97fk/iC6G57F2YvZ516iLS+SedmrKzUK7rJJp07euXUxRfUmrq/N80Xo3bbTEn7AuQu0nuE0NyqSDmAqpd/dyJZ3N+tqsebD8mhWxCO4S4I/rWLYGtXzYKqbfnXzVV9VRD5kORyPIVpxMRx3Kmod5flB8Lh1Nawt5mZu8HQ+oeYco9+gliMtiJbex4jl1y5BXP1mwXfu36F/cAd+jkUKr32dztlErIoJcIw9FRLC3LZAxlWGgBX8zWroROmyuey7rhaoJk3lIzFw7uDEBneJ3NyKZ6g7v4dp/GmPDFV8N0YhqeAjuRDnWKRZHMrvH4K2ZoMyp+aW8v7WPC5L1qnMU+gYMTFGo3IJfPkBzHo2fHOCNNpWctAtwWWA6Ws/3VwHf+X5zEduNCzp+KklwO/UXEEjRPjg366ctVbdbxXlzf+GnxZ6Fm3Fg3iqSw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?d1zWV4vT5985E+TBQPFj3yaNR8ITWCozFjF2HHn3BwUqWb+/Z0ue3BQ8jsJg?=
 =?us-ascii?Q?pDjRpT8iNrIHtaFaOD9g/czl0xUnjxZd3ZfQ/f1ulsLuFgPW6uGcN/FJ4Avr?=
 =?us-ascii?Q?PuxBBLesYvjwxfGFulTLeqxtZ8y/2zgQtcl7NME5y9UVTuMYsiuQhGHDCFNV?=
 =?us-ascii?Q?VZSJ4n/LG5El/Ze6B4groCw9QAwcqgalL2EewOaWHj/mZpOtkRuMmk/MDbJn?=
 =?us-ascii?Q?eX4OneFTePtce3UQZ5vEIPCUrOFkjeo9PK/P7fun4E6rNxJ9wSNblJW8RZYg?=
 =?us-ascii?Q?+zVkZNinfP2ri7oHPz1UWObmSmMELE7L2qVcRVBWuq0NFUIH6LCz58TVu/a4?=
 =?us-ascii?Q?PfLBYucJkorRbzul4KNQnGi4anM/PS5v/stM0BQ8IX8ZkJUl1k56+OcK0tCo?=
 =?us-ascii?Q?ZVRrOLTB2xmhZzT4af6XSXhCbG/L6h6PWiPruwq4fTlrZj01ByURpRZluto8?=
 =?us-ascii?Q?B3+xOfsGJ6Mqk28ktzflIo5JaB+sn3OSjF9D0LQ/QSyue+pVapEVhdifGRN0?=
 =?us-ascii?Q?p6+l0GNpzAd8/6qRR1bwDfI2SKSu/VagYYBssH7RYQRbYm2ByE29d7hsv9XU?=
 =?us-ascii?Q?Gz5TO37vznnIVQagY9Edo8pyIjUVTdvIyJVl2tcHv1bYzjSqkqAi3T0WnOL/?=
 =?us-ascii?Q?LsZTzozZ+j4sKT4oc5g1lwl+tgSU8r8HIL51xxpdXZJ+IvQRcQoPgLwfOGAv?=
 =?us-ascii?Q?OH6dNSWGrp+hnVuRbuxF6KiXAp210WnTa4waECT7gMeAPh0J8TQPNnqPNNib?=
 =?us-ascii?Q?SyOKjr7GIe3bGn1e+hjjQAcWMSvdwDZkG0GKUkqDd56SJ96uPikN9H0icU04?=
 =?us-ascii?Q?zfJlwK/jI7nIUnZQ8Vi40G34acLrDewdCk7r0rFG02TVAGpcll81WAFTdPgw?=
 =?us-ascii?Q?jtkxNyQr/yiYE94VwLS5r77XTNLLDggJRIRyeSm3UV0bTOX6reL73PEHseA3?=
 =?us-ascii?Q?H0XLK5Ip2vtKC5cCcoMhd3NK2//87UB3EB5/mKtQ4FSbANCEQ4+1BDy4Q4Oc?=
 =?us-ascii?Q?kam1gvgg7XJlM/d6OANQDQkqwuk1mk4RYoAWexx0nzLZTRT9l3TTapGD9Y62?=
 =?us-ascii?Q?qUNFbvAFZkmnYTVhlpTPeJe77g2HC90g2ohJPgnPDoV/MIKouzeY7mdUffRc?=
 =?us-ascii?Q?RDSUQL5oVmVmj+2/IJj0Xd9DueOd5Y44GNhL/kar8jpGrsd9h4pCDdV8HrmZ?=
 =?us-ascii?Q?R+rC9MG8pX8SD/p2HNY6/KEgIWt7QahcutERi7bmlFvp8w3JvLarRvvSC815?=
 =?us-ascii?Q?EK50Mx1kxmS6FZXk8LbqHC2CoPaC46jDIUQOYbKKSOyh9vdkaEg3cyVjqcSu?=
 =?us-ascii?Q?Qj501coDYGOLvqMg9QCDsK0qbpZzKGawhESfULfCYMcUDkQpaxn+8xKcgLTY?=
 =?us-ascii?Q?BS+S00o18C5O4jUJjON6PSoEh7CbzPAZHpgPP+Jux3yUbVZ15MInq65q0veL?=
 =?us-ascii?Q?AetyVYpcHx0KEzhji9yVcfwnZGykEzeXs0hA9B7rp0MHts3PRBKW7oZ63zrd?=
 =?us-ascii?Q?Bmzsd+D20zUXeH0gK6L+63x0BeeCViwb68TWveONyHsBU7DNbPDN0+hqRUjm?=
 =?us-ascii?Q?IVcR+nllSdNp84xfpWRP5UxBkjS0Wln9FTa3Dt2/?=
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
	xPQFbJcpd0fyDo4BwiHcT7QZpPSXV3Km4SUOW0gXnhoWVUPchuSKdLfbiFFyNm3JbZaYE6XHwT+rdms5lZV8JWu1//WVznY7q3SyQDjetWUQu2PLR72djetcPOpAmF354axCbk1lR4WDj8vQEqVf0lmZmLF8JoYC0NlpPViCDEIxe5iMN+erYhJvFi6E2YWp8uxEM9WQY+e/aH8QIF1Ga7Bp8+hsAhGVNxjwRiuvZvLNjS/VVsX4C3NfJ7gVuh1bqdLYACKdqLfklO0WXP6TrWZZQAgPL9lCueTPliVgJNYj6e1zJHBRZrevwU5vlYNRf/Z+6eK7vkqdLFQIzYm5AWMQpWaXejKYu4wYUQ/euXV3HryiN1RQeLzxD4f2f0vJ2jBaLttdPxI708i8oynw8yEBSHRZxfbTtZbBQLS2E2s3OgFGmLSdSnLEdQcvGBt46oX+ddj0ci9jaKZTLbyDpr/Y7DOT4gPlYtNoTl7nf2mM20z77eaxvK/3cjn7ZhtGldf+phsgpR6U+uRqKIhk4MUq46r3m1O4ln2ppt5Bh2WXrG6BFX2jevCWkqUOIi2Oq8PHg1ZvSBpy3hwwyYPI9KvQKtlVeEHzIxkFmYQsZvt23Cz8VJpbnaOt7qx6POP3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c2c979-298d-49c0-bbea-08dc3f4e2584
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 09:00:04.9183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7TjL4VpsFQ1hduUvcejZYYR6jcthLMt05tRdtumuns+a5b5Rb328Z+j27Slagg3PHLVJa8LXhnzJQTYgtmyb3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8461

> From: Peter Wang <peter.wang@mediatek.com>
>=20
> From: Po-Wen Kao <powen.kao@mediatek.com>
>=20
> Host power control is control crypto sram power.
> Rename it for easy maintain.
>=20
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/ufs/host/ufs-mediatek-sip.h | 13 +++----------
>  drivers/ufs/host/ufs-mediatek.c     |  4 ++--
>  2 files changed, 5 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-m=
ediatek-
> sip.h
> index 30146bb1ccbe..fd640846910a 100755
> --- a/drivers/ufs/host/ufs-mediatek-sip.h
> +++ b/drivers/ufs/host/ufs-mediatek-sip.h
> @@ -16,7 +16,7 @@
>  #define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
>  #define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
>  #define UFS_MTK_SIP_REF_CLK_NOTIFICATION  BIT(3)
> -#define UFS_MTK_SIP_HOST_PWR_CTRL         BIT(5)
> +#define UFS_MTK_SIP_SRAM_PWR_CTRL         BIT(5)
>  #define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)
>  #define UFS_MTK_SIP_DEVICE_PWR_CTRL       BIT(7)
>=20
> @@ -31,13 +31,6 @@ enum ufs_mtk_vcc_num {
>         UFS_VCC_MAX
>  };
>=20
> -/*
> - * Host Power Control options
> - */
> -enum {
> -       HOST_PWR_HCI =3D 0,
> -       HOST_PWR_MPHY
> -};
>=20
>  /*
>   * SMC call wrapper function
> @@ -78,8 +71,8 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg
> s)  #define ufs_mtk_device_reset_ctrl(high, res) \
>         ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, &(res), high)
>=20
> -#define ufs_mtk_host_pwr_ctrl(opt, on, res) \
> -       ufs_mtk_smc(UFS_MTK_SIP_HOST_PWR_CTRL, &(res), opt, on)
> +#define ufs_mtk_sram_pwr_ctrl(on, res) \
> +       ufs_mtk_smc(UFS_MTK_SIP_SRAM_PWR_CTRL, &(res), on)
>=20
>  #define ufs_mtk_get_vcc_num(res) \
>         ufs_mtk_smc(UFS_MTK_SIP_GET_VCC_NUM, &(res)) diff --git
> a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c index
> ae184e4f90e6..2caf0c1d4e17 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1376,7 +1376,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op,
>         if (ufshcd_is_link_off(hba))
>                 ufs_mtk_device_reset_ctrl(0, res);
>=20
> -       ufs_mtk_host_pwr_ctrl(HOST_PWR_HCI, false, res);
> +       ufs_mtk_sram_pwr_ctrl(false, res);
>=20
>         return 0;
>  fail:
> @@ -1397,7 +1397,7 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>         if (hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL)
>                 ufs_mtk_dev_vreg_set_lpm(hba, false);
>=20
> -       ufs_mtk_host_pwr_ctrl(HOST_PWR_HCI, true, res);
> +       ufs_mtk_sram_pwr_ctrl(true, res);
>=20
>         err =3D ufs_mtk_mphy_power_on(hba, true);
>         if (err)
> --
> 2.18.0

