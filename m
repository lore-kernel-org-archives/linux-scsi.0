Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C09EC5
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 00:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723508613; cv=fail; b=C9yVvsbqqix6m+zyN4na3KvB/TQ/wyM2xZ/029I0o9nzDLrfeWFYrwNch3LpfYlN41+rENBkZilHfMPo1y09xvtKQ05nbWnh5qVyJRVTc7DO4lfeUue8ZmiKJnlUak+f7oNbZKlLtbqYvZfbzeM0CKpNjAa0kBTzWzSR7HlAvxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723508613; c=relaxed/simple;
	bh=kw5Ia8sOY1OUPRxGwYnjFAZsyQr8VAbWU/yN7LX5ZY4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=snoE+oDcG+jCwMHr7e6CxGwWlMissZBZUJh8PpTNmONt8jwwRHjPEpIs78Yg2n5NO+EgWzUqe3yYHG0OBhXuLZoJkgZNo/GT52AkokH/I7iFXUaTCZRw5ARDypqhOHqV9Rse47e/UvGoTmwg8itVk+WgaW5cfnydNunRzgehWBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=p8+1sE3j; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=o6aQwaAj; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p8+1sE3j";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="o6aQwaAj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723508611; x=1755044611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kw5Ia8sOY1OUPRxGwYnjFAZsyQr8VAbWU/yN7LX5ZY4=;
  b=p8+1sE3jtwB1E+3NDjW1Y3yt7khpYw2XWsDE3+S8QHXDx3JRpiiOCuge
   nX9H9wfrTS4kTO10QT2CNxoy9iTEb7IGBNfHjj3Gkz2o+pSpLfrXaaDUO
   zvHp9EVWfm9MZxG8YGaG+X847xYjBU9iuNEunZJF3JQEHFeNJTZgeNuZY
   5EOmcW/pF3mVq5ZmLfanKD9Sc6kBEzv5ai2JB1c/IN7Z3Ewcjx/EOMDLJ
   dSmEAlUHNuz+btBM4vMwTbNIXLkdmQ9Vakutb5sYVrbhcmtRLOhaVgzPt
   aJs4GbzmGfUNpBeoFIi9JL2nWzznFJvlfLYEmM8fyfs8lt5gdqdsG+m/e
   A==;
X-CSE-ConnectionGUID: KPjRjD4tRquX6T6nupyoYQ==
X-CSE-MsgGUID: RizMoQ5ATSuJ2okY0Bfbqw==
X-IronPort-AV: E=Sophos;i="6.09,284,1716220800"; 
   d="scan'208";a="24830532"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2024 08:23:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SneGyTaqWpvgJX2xyhSkf5nvj5wXRFExUXp6Jl2bPhZtEawgqCqkXTfiuvjNi8b8pQefCErBkMs+IAhrfvfroa/olA7x1T73T4jUPWRFcbHHab4fYCA1A+7Nd/SvmdSc0Z3B0ymkSQ45L9CXNIGPYdewGzQQEVVnuH/R2Fee0QUIApebOfyFlV8BjuAxVJOrrIr34aTBPiDmj0JmwdTpJXEtQQdkrl65wnf3cJH9ulFg7ongxmcbSyEWUBFoeRIKPbTyuRtCbKuCT9FYPJ+fu95etMj+1sGi1IWIHWqFKxP/Z9mPRopJgZl3NBFvKhWKHG8ODETzrn8D6hFzkHbESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eVCzAvl/mhJQYo2w5SpCzLuGuIfHrVE8j9rNl9JOl8=;
 b=lxjpeZVgvrh/b2FHypCuhbICdL3s0FVABI8Weu79zAJgrDpIJd0FReVdRZ1dEeNJ1qUB54rHi3GUpAGJFCe+iVzDPGraTU/XHF4Ug1ZLd24F2wA0LDW8GXRE5LJZd0IHl/Hh1RO43Bi05xfTVcUj8HnBIJTucuYAy6jVtgjmXDigSAWd8m3/bfkQc/d1ZLNG8vWiv/AQ9t0wLCcw2+GbrYbHc42McyP5DRwImspY/4+YUaxdojACvDtDRjLPsBDMdE4HobpS1yr3jesumiDZhChjWlBVgb6Np0t+u7cFAgBPN1m5k6/yO7FkCxOchPmM0QyPcotFIgZpr7TgXwhQSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eVCzAvl/mhJQYo2w5SpCzLuGuIfHrVE8j9rNl9JOl8=;
 b=o6aQwaAjcFB5ZNQIM3daYqJ/aMmAOAePp1wzZyRvrAyXbZSpXvg/A/C2oISJzDshDauW4JA9PwDcgyLn3hadt63tAgn52DJBpGI5wCjOlo/p4U9Mbcy4lDnVlN6vdU2Ea6dUdWbE++r4OsfRHxdzcj402IEm5K7ALf9vqs+90f8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8341.namprd04.prod.outlook.com (2603:10b6:a03:3d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 00:23:20 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7849.019; Tue, 13 Aug 2024
 00:23:20 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, Ranjan
 Kumar <ranjan.kumar@broadcom.com>
CC: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for buffer
 allocations
Thread-Topic: [PATCH 2/2] scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for
 buffer allocations
Thread-Index: AQHa6t2Ql2glX91gPE6Y2odQw5LQcbIkWEOA
Date: Tue, 13 Aug 2024 00:23:20 +0000
Message-ID: <uizpmw3e6qigb46xoel6a3xuelfzex3xt5rpk5fqgdzbsrrchl@wjdx6c7mlnj2>
References: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
 <20240810042701.661841-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240810042701.661841-3-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB8341:EE_
x-ms-office365-filtering-correlation-id: a32225b1-01df-4347-7d1a-08dcbb2e22a5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?6Yc5gZt98895xl4u7oeYQu6z1ja69fWA/Fm6/wvHL9qgn7UMYe5ce2UnIIvE?=
 =?us-ascii?Q?Z31k9bvP3ho1GG17CcI5SUA+b6u57wYOtCk3b50Q66YggD29tpQHdcwi16Ks?=
 =?us-ascii?Q?3dafPiMy/59H6U/TdQTIL31M93BXVAlOA2QIp6TNKQQxy2K9rhQrJ52E5CKQ?=
 =?us-ascii?Q?1BAC0OxbxydCmhLyoeCUQ/+rrJaLtIOJj5res3rPz1UJLAjCL4TiBaR9UXgQ?=
 =?us-ascii?Q?CTN3zFDGJHPyY8Y5OfpHdAdKDO2Q64KQhHLIRc4/BsXBzjJpXycNknNoi16l?=
 =?us-ascii?Q?FsKas+CcicpQukSL2KmX0dC9I1+XMfxvlhscvYtXh7+hhQe/xn1+aKXNZhvv?=
 =?us-ascii?Q?JzcLRjD0scOhcdjq6e+H5eXcvSjV9ftiQtG6ilqCncHLVO9KgYh0IfMgsR0+?=
 =?us-ascii?Q?mj/TyzKarT7KAbTEOjlfP74yM0VirEwxbyMxoV5DD4SROjCLzMiGCu1S6fE+?=
 =?us-ascii?Q?O60hAedAyyaZCR63vgvfIKnsOg6l6tRUBR+6aq/jOJxSJqQFYhGnzMRmO1Lg?=
 =?us-ascii?Q?/h4+oatFMq4EHEdqEhqEarmOSHla9TnQKv6UCW8343O6ESWwhkuGIBD1B8My?=
 =?us-ascii?Q?Dt+9+BrAOowVVmMmzFSQEUvTWwlsQ/q8CtRheW5RpUXy4e2fpzb6t1j7QY9M?=
 =?us-ascii?Q?FK4NE6j580VrLQAn3dbwavK0VXqxsIRwO/HhWIFqm+q4m67x4yyHBl4BSeMj?=
 =?us-ascii?Q?ZZRfvW8iwhNl/Ftfx6bjkapyY8wft70T4Y9KCUHdObGHiHbQ4DlfZqF4DrZq?=
 =?us-ascii?Q?VOJrwXTUiJOFGvg/UwZ3l/ebZ7AC0MdWvSGExa5vKgLPAVg++j/J5R2Zza57?=
 =?us-ascii?Q?nuGZbnfQ7n6RAeraeAQOodJNlURAqh7AO/AJhdIQ4/pqwcajpG5FErkkgiFx?=
 =?us-ascii?Q?pww++oL+CgQYmDNFoKeEjp8V62xje5kr+c6uyfpAeQkoW/wBNL1bQ17UthkZ?=
 =?us-ascii?Q?TkbUSbghxaCBIIi/JvbVkRxG3FN1TxhGyig2PzPQmoRvUJOHGYjOu2ogHSv3?=
 =?us-ascii?Q?46s35VxJ3dDRPfZUdNTC/mceuTDLXY1YqOZrQ9wiYlbzZBK09IJAZ2VABpMz?=
 =?us-ascii?Q?1KlU8tyYbz4CXwQftIkgsN5Hj8WGkxYmZ8eBbqdpDkHt9HAG3HsHaR35Ip9g?=
 =?us-ascii?Q?K+wiPHH77xPkDi64uhFx9kMeUFbjVVytnPRAXfZB55bOQbJ41S9nYOfUVeIb?=
 =?us-ascii?Q?hzCL8Pa05z1chKF86zqWsYtdBouTYvoptaavDAjxIU1sCrtQ+RQL2WSMygdu?=
 =?us-ascii?Q?ojCkSaqs1WRm3AVJ52xiKcn5stHaMqUkR/16LooR7I2V1hMjy2XkshCy4vXj?=
 =?us-ascii?Q?iwZoEleTgDR/vcCkU8CVD6IPYUOyxZpTOHrhZQg2IQ6fINvs8TTq9H3nBRuP?=
 =?us-ascii?Q?l49fp3xLGldZU+/23ofobIbig942jqpMrYrpzOYtMCyDlx/WQg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FJgEB8rgl+xlb0v5AXd0lNW1jVG7hr7E55twNAjDbuamL5Ej99RCuD9/6SQJ?=
 =?us-ascii?Q?nYH/bd41P9g+BIur3p30A7kw7at1kKkOyimcz9Zx6Ec4fxwGHzO3NJTi1MFo?=
 =?us-ascii?Q?zBQLu4es0tpZKoFxYmYopMn4tnSxNmDg1QHc6YYARQ5nQa3Vxv+swhZu1GEB?=
 =?us-ascii?Q?FkIcU4CE/l7fF1ylwXaABCi6Fh37oHGKJFHwHxwbk8hTRk1ziYo23vNWCxhs?=
 =?us-ascii?Q?Rho3GEsSXvEj9CMA7a9vcnvPZk+pad5XHy+98Qeznl5eLIlSswzFoADo/4ui?=
 =?us-ascii?Q?1/N3nH2OI+lq37oTKNR+xP9yTruNt0G4Zhzgu7ypLNrFwiwGe/NOTjuvFixj?=
 =?us-ascii?Q?rTC/HMODhF+srtuXeeyXlDOtD+GOHcG3d/rBYsJaAnOtgvtSiMk3xfjfFV5J?=
 =?us-ascii?Q?9B1nHRmnMa9g17tN60ymKFrTye3N3ftvQZrP4YJblHO4lqg1sWAtIOzOsNQQ?=
 =?us-ascii?Q?kA/PkWRAT06x73FHAWzke5YPTvyO58r+FqNP173/1hcC2knBIwRgelyaC3Fh?=
 =?us-ascii?Q?PabNAVDdUBYJkNkZO+mw5lrtd24OrdcAFsaZ9Xf8Ia3A3++tbohttGiaxoNM?=
 =?us-ascii?Q?5B4x7msu2xtILFlugp03maaNTUaAVYElXiRiS6cQqGVUdU+ak8roarn9p0W2?=
 =?us-ascii?Q?+kzXJKWRFfoVQbjasAxieuTNsJL8iz0z5Aqyo0f4nKwukFweuY4hEfKB79qj?=
 =?us-ascii?Q?VGeGU8SskEG0tcaMQ0VRNucLvQY/IqNlsxB93gT0iUwq0HMx2CPejYomNPfB?=
 =?us-ascii?Q?TDXYz8crG/zIvAsNNkhFoQXN/y4sjlXckuroA4qN7MJQiga2cYwmqgYa2iiH?=
 =?us-ascii?Q?zz2xMaMlVTxSpEsYxd+0Etkk+WLBU+IYQ8eQTrDNnhi56cFFvUioZoeGq4jm?=
 =?us-ascii?Q?+iZ5xePbd0jss8Z9avg03ThSczOeCXqJXrjiJH8byELcdZvEbjtPzMQWVFRi?=
 =?us-ascii?Q?dWC8Xr2w7aiz37gzIyeh/Gf8xsfvAJxeeVORvAKXRTEaNUvY72iBGCjXOVJU?=
 =?us-ascii?Q?pAEpLChD7I4T7TvZieMJtPaqq9T9yuUe/QycPUu86hz38xlZ09985v0w1v00?=
 =?us-ascii?Q?D6PiRsE0iv31fPrIP8bN+jvzGH4dmeJGMVJcTwlGKaTaTZCAy8qE3LvNUC/m?=
 =?us-ascii?Q?EzUevfdhTkVg23piYqJaetgI8+p7oVL1Ma3hfrfUodevNXcHU61prnksNEN7?=
 =?us-ascii?Q?dv4nmjPLftoc5v/x5Si3WNkSltwnPKMn1gu2WsYtkjTAr4+WqVvq82LmpX1W?=
 =?us-ascii?Q?rs58BHIIOhIy5qIWdNB6Qj9KAeu2QPmNOkHkaDx1NNVWLXiMACXoFhth7Q0u?=
 =?us-ascii?Q?AisnoerRxQv7V/QNxbHsqGRjEHJqupWszew80LjMYG9Ol0VDIWYmi4NlKR2I?=
 =?us-ascii?Q?kBfFKN4xawZrNd7UYkEZem6Z7/IhNoXMtdE20sc5zfisS2eW42zk57lXRQC2?=
 =?us-ascii?Q?3vdddJj7WixczJSmRktbifaYIKUfft7UaJzieh+9jvfVmcRpHbze2ZgbUW7Y?=
 =?us-ascii?Q?Lrv7nW1Yr+7NI3gWFKPaPEntIdC7TEjQox6mc5XZ8ZbZlKm1KuX6bPhOCZO5?=
 =?us-ascii?Q?N4vAIld8qBgo1d3YElmBRI3A6cWwCA6oNPdNWjc3VPriEeJrbxu4uIPr5XOg?=
 =?us-ascii?Q?JN5SO7OqsefOHVy3cRoDrKA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <096DBA29A5245F4E8DA8BF6A688CD566@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sJa22kQWWZt5I0hp5H2iWUsCAqZEDmDrXUotdOKAxREJ4RjDQIDVHyEfr/xoS/TIr6oM+ArZK/6zWenDrplbnzXIQ278YllRc4aK//nIYGSd9RNinaaQxQlZMOaXJ7T7TqMWGotQt+uSAUpmpP9wj117KHjHEGQXvzHzcGpVqbwZk5/4rjFPGu3UHwUfClO5oJ00Ajw6eFPYaFjp2Vk9ofD2GM2vMyd1vr1rJ/pJvTFw4qG3mPrwElWBN5UtItcxZ5T180dyfIXKoy2gqkIkrCNsZa0W1Oeap+Bb2oRAbr90rOOCGOHEOiLrAZTUuxKrxuNXZLkPuE/VRJkcg7vfcoTaGqdABH9cJFd7Vs+ICb5T4PgolqcV7i8bECFCpfQXWvT2IdotxuNAEgLNx1DQD9KXDRLMUJAfY65etsEygLyqv79L3jLdluSWPU47K9XIvuay+dbwbEtafchtzu3ewUkmonuQVjOQgfVw/GSm14ricr++zoX5wFXvZRkgviw/nBqfPAXZmHJ23+dJO1G8eROQbK2URJVpHPKGkNkU+NikYMawAWZw5bAYcVWz8jOTM5apN0bOvtXP6RoCFTrwukBykjpKpSHfxggOtZt6bAwHLfYCp8fw8FCxQyjvTBK7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32225b1-01df-4347-7d1a-08dcbb2e22a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 00:23:20.3893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TgheQKhZvh4V4giai9baXD4f11TVxORP32n1VRscb5CjeY04p43WgfGS2upLXvuNNwJ63dtUcaPNYeqf2ehpU5+YhJ4tAQty5Zn+1xUdDWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8341

I made a spell mistake in the commit title:

  s/MAX_PARE_ORDER/MAX_PAGE_ORDER/

Martin, if this patch gets applied as it is, could you fix the mistake?
If you want me to repost with the fix, please let me know.=
