Received: from aer-iport-5.cisco.com (aer-iport-5.cisco.com [173.38.203.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B333F0AA6
	for <linux-scsi@vger.kernel.org>; Fri,  1 May 2026 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.38.203.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777662582; cv=fail; b=J2iNt52pN2s5VxdSqvX1htAKpCeBAnbylo2BCHvW4La5oX8JVMRtc1BH1+ApfFgrfNDYMc/Y1Gl1oWvD23Iv4vwbEAKVXMGLgTl8DICpcm86a5C/g/JDIqq7Q3hKZz8YFYFPOxr6SGYkmn+BPMxq0bnTSdgbQ8jNUuPtJJr8rtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777662582; c=relaxed/simple;
	bh=3NxPK8o7blyM4WQumdUzpPBJ3eRp/Uinm7dh4LKuBgA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MhGKBNEJ++IFE94Egc/upS995GiIXcnWhr4+eBmsr5++bRJgV5BivdKM5zcEGpB6TFiRwZxSe//HDxGVhZvN6+L14M3NUKpY5gGjqhGeL/5lq8CNBigafkE85L75LrQTX0GaAAo0wv8VYH/Il51zlfX/JX1A5GstCaDYdYQAnnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=KKISwOBz; arc=fail smtp.client-ip=173.38.203.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="KKISwOBz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1231; q=dns/txt;
  s=iport01; t=1777662579; x=1778872179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3NxPK8o7blyM4WQumdUzpPBJ3eRp/Uinm7dh4LKuBgA=;
  b=KKISwOBz/dApd3KvNvmHeH3peUFCSjOhrcPdMbE+RHoJTfMJayel+yYy
   keREhdun9ZOjWV2croQ9IEBHh0ADdFYiow93EWvBONxwar3sMskHm02EJ
   scS/FVgOYFhkcSOYxdeyq+1BpF242sS9u+EFEF8YgTqGc5dZuBRjSux4t
   n+nkNyjpcxb1TGRLX6XD2NGjTt+CBAjdu46/p6uP1Ho6ueTtKLq8sS0VI
   WRPOm6MC1h2u0ExYu+WuJTBbrvcx/OjO67Vrd0EUVSUMpe55+MoCRGmmg
   +kcq6+ylY53i3tbP0mT19DwRt0cGAxHvjz2FRDg0+Ffb2sF37C1gxHp2D
   A==;
X-CSE-ConnectionGUID: YixDLomqTc209c0TMFPLsQ==
X-CSE-MsgGUID: cP//oRYvTbqpe8q14frvzQ==
X-IPAS-Result: =?us-ascii?q?A0AsAAAI+fRp/9NK/pBaHQEBAQEJARIBBQUBZYEXCAELA?=
 =?us-ascii?q?YFtUxZvgRESSYgjA4RNX4h8nhqBJQNXDwEBAQ0CUQQBAYUGAo0xAiY0CQ4BA?=
 =?us-ascii?q?gQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4ZchloBAQEBAxJnE?=
 =?us-ascii?q?AIBCBEEAQEvMR0IAgQBDQUIGoVUAwECqA4BgT0Ciip4gTSBAeAkAQsUAYE4A?=
 =?us-ascii?q?YU+gxgBAYQ8gSEZhHonG4FJRIEVQoJoPoRDAoQTgi8EgzCBfo0aUngcA1ksA?=
 =?us-ascii?q?VUTFwsHBYEjQwMqLy0jSwUtHYEjIR0XFR9YGwcFEiEqboEEdCxcGg4hJBFZQ?=
 =?us-ascii?q?jgLSQWBcgKCHhlfIywDTm4DC209NxQbAwSBNQWKWh0Pgi+BDoEAmDuOJaF6C?=
 =?us-ascii?q?oQcog4XqmuZBiKodAIEAgQFAhABAQaBaDw5gSBwFYMiUxkP1nF4PQEBBwIHD?=
 =?us-ascii?q?QMLgWiRfQEB?=
IronPort-PHdr: A9a23:LfnNiBT71gI0B9g9eEAGlOucJtpso47LVj580XJvo6hFfqLm+IztI
 wmGo/5sl1TOG47c7qEMh+nXtvX4UHcbqdaasX8EeYBRTRJNl8gMngIhDcLEQU32JfLndWo7S
 exJVURu+DewNk09JQ==
IronPort-Data: A9a23:uiSc3aLfJuwhHhDIFE+RmJQlxSXFcZb7ZxGr2PjKsXjdYENS0zVVm
 2obUD2HP/jbMTT1edxyaNi18RlT68KBx9FhQVYd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnW0
 T/Oi5eHYgH9hmYtajl8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1fDVEaGYod49p8Wzkf/
 qQkDR41Sgu60rfeLLKTEoGAh+wqIdOuOMYUvWttiGiBS/0nWpvEBa7N4Le03h9p2pwIR6uCI
 ZVFL2A2NXwsYDUXUrsTIJQ7gfypgHjXeDxDo1XTrq0yi4TW5FEtiOW8aIGOEjCMbc5t2QGfn
 FPYw27gGhxKLYXDxyCb4Ev504cjmgu+Aur+DoaQ8v9snU3W3WcICTUIWlah5/q0kEizX5RYM
 UN8x8Y1haE/7gmvC9L6RRD9+SbCtR8HUN0WGOo/gO2Q9pfpD8+iLjFsZhZKaccts4k9QjlC6
 7NDt4qB6eBH2FFNdU+gyw==
IronPort-HdrOrdr: A9a23:AIdwequVSMQNxWv/WSyoeRrY7skCcIAji2hC6mlwRA09TyXGrb
 HMoB1L73/JYWgqOU3IwerwRpVoIUmxyXZ0ibNhW4tKLzOWyVdAS7sSo7cKogeQVBEWmdQtr5
 uIH5IObOEYSGIK8voSgzPIUurIouP3jZxA7N22pxwCPGMaDp2IrT0JdjpzeXcGPTWucKBJb6
 Z0kfA33wZIF05nCfiTNz0uZcSGjdvNk57tfB4BADAayCTmt1mVwY+/OSK1mjMFXR1y4ZpKyw
 X4uj28yrSosvm9xBOZ7GnO8pRQluLmz9tIFOaMhsIWJjiEsHfpWG1mYdK/lQFwhNvqxEchkd
 HKrRtlFd908Wntcma8pgao8xX80R41gkWSi2OwsD/Gm4jUVTg6A81OicZyaR3C8Xctu9l6ze
 Ziw3+ZjZxKFhnN9R6NouQgFisa0nZck0BS19L7vEYvCLf2r4Uh9bD3yXklV6vo2hiKs7zPXt
 MeVv00r8wmAW9yJ0qpzVWHhubcHUgbL1OhXlUIvNCT3nx9mXB0yFZd+ekk901wqa7Uj/J/lr
 v52mMCrsATcicbAJgNdtspUI+5DHfATgnLN3/XKVP7FLsfM3aIsJLv5q4pjdvaMqDg4aFC0K
 gpamko/lIaagbrE4mDzZdL+hfCTCG0Wins0NhX49x8tqfnTLTmPCWfQBR2+vHQ78k3E4neQb
 K+KZhWC/jsIS/nHptIxRT3X91XJWMFWMMYt94nUxaFo97NKIftquvHGcyjaYbFAHIhQCfyE3
 EDVD/8KIFJ6V2qQGbxhFzLV3bkaiXEjNtN+Wjhjp4uIaQ2R/pxW1Iu+CGED+mwWEl/jpA=
X-Talos-CUID: =?us-ascii?q?9a23=3AU58uymmaFRpwTcC/9TbW93odTXXXOUzc3Fv0JEq?=
 =?us-ascii?q?hNW0zEOyeEWO11ptAiPM7zg=3D=3D?=
X-Talos-MUID: 9a23:nsKiQgWiIRwc9pbq/DTUw3ZlDvZ23663EE1diMxatdOaJxUlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from aer-l-core-10.cisco.com ([144.254.74.211])
  by aer-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 01 May 2026 19:08:28 +0000
Received: from rcdn-opgw-1.cisco.com (rcdn-opgw-1.cisco.com [72.163.7.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-10.cisco.com (Postfix) with ESMTPS id E8EC81800033D
	for <linux-scsi@vger.kernel.org>; Fri,  1 May 2026 19:08:27 +0000 (GMT)
X-CSE-ConnectionGUID: OXnQzVGcQROZAkf7akA3PA==
X-CSE-MsgGUID: 2pBCO0ooSQSoboSxtXdaHg==
Authentication-Results: rcdn-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.23,210,1770595200"; 
   d="scan'208";a="56429032"
Received: from mail-ph0pr07cu00602.outbound.protection.outlook.com (HELO PH0PR07CU006.outbound.protection.outlook.com) ([40.93.23.90])
  by rcdn-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 01 May 2026 19:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m867E3J20IMpoopLuDFfA3o0zjPlxn0Hcds+RhfimLtJObmbtnPLTpZ75S9cEXGpuvPhZ3aShNItVHpWBq8CVhAwmEVxWAVobkWcar2ulpHz3yM6/1JqyzSiqljQkmdbSgV7ns5B/nOAtCXkmY5qfLvkp51TtjIvKSVHYH1LJCpj2yy3WYvp8e3SFI20SZYyYIIJM6dxvYKbh7riaFMOaMp90sDLzT9bUX2IR/i3Npk+G0nnMZyoZaE70NJYHQDUc6HGMtDjKYQHGfTM2Fj0qQx8AYFzyhERQBGQNV2G+LSlY5q2gzp7U9/xNUFew/9mLh2iI0y81yCnoKn1DeWjLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NxPK8o7blyM4WQumdUzpPBJ3eRp/Uinm7dh4LKuBgA=;
 b=kWvu2rJyBUNol8VH41mmssiW1AqK39l987AuFlxyevutsm5tGZloh3OgMq/fFDVIJfP8cVqUrU36dYszQpbYeGI8pi+nChC8CaMRsqs/9ljlotH8V1Axv4jH8VJQkbAFPFVJHrvtwXfJRWpxrVh+XZqWkSlySE9XVey+Lv+d4i1l/3zb88jlPJzsOCfGeGUlBrHI6FD6BaoV999Y1xACqyP0UGBz2/f5+diWoMjRL/LHkfpm/YwBfNzWrlUFRXRfE5FSiVVYQbQfmwQvqxd6ieLCo9gQfymgskjNmgD7FedalEoTAKnhhjWcgLG8SiKODTtMu9QwmUjwcKG9FV/0LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from DM4PR11MB7277.namprd11.prod.outlook.com (2603:10b6:8:10b::18)
 by IA0PR11MB8303.namprd11.prod.outlook.com (2603:10b6:208:487::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 19:08:24 +0000
Received: from DM4PR11MB7277.namprd11.prod.outlook.com
 ([fe80::5d85:31c6:8031:8603]) by DM4PR11MB7277.namprd11.prod.outlook.com
 ([fe80::5d85:31c6:8031:8603%3]) with mapi id 15.20.9870.020; Fri, 1 May 2026
 19:08:23 +0000
From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Marco Elver
	<elver@google.com>, "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
	"Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 53/56] scsi: snic: Enable lock context analysis
Thread-Topic: [PATCH v2 53/56] scsi: snic: Enable lock context analysis
Thread-Index: AQHc2M7BsihIztXxuUCQyIsKZtkpGbX5ifvr
Date: Fri, 1 May 2026 19:08:23 +0000
Message-ID:
 <DM4PR11MB727798421B172D7CFAA425D4AB322@DM4PR11MB7277.namprd11.prod.outlook.com>
References: <20260430182130.1978347-1-bvanassche@acm.org>
 <20260430182130.1978347-54-bvanassche@acm.org>
In-Reply-To: <20260430182130.1978347-54-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB7277:EE_|IA0PR11MB8303:EE_
x-ms-office365-filtering-correlation-id: f7c05fad-dbd4-4615-4b4d-08dea7b5045f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 5SLBNYjc78hIpigLFEWY/LQelKEmXsn5CkiZJrie+kRCEvL60+yn9NbSXAO77UfgRmZIktmlVRTynHi8kWhq1Zw3s2/4XmUQZs8t6+HNX6N+Nc6S6pXeKBezYpJnOzrUd+wsJGNy8kXFN5rdDnjqVt3elrFUO/385I4yfbXx2v6I8+JVh2UmAycWan9EFNjm+xmXf8ZjrcnrzJzZwV+IIl1rKBD7t5PCpc2gklk0NQ4wwMS/klyT94nbk/Oz8JW0jGcVC1K+yrzV1gOqnr3uN4Q/rzRc0SrdP3RYHUNmrT5JcDJDWj9PpmdhjqHcLN6c01ekDzlb/5Zl1aUkYkzbG2oLphUp18VfTNhp4vlMEBXAopkiOp5uYsqvh+YgVhMCrIMWoJRKNXCUkdmPyySeytF5tIF8mLumpswssG7EvzMPJQRQYzfWtY5vbw7Yd4H9lBcoT82gAFiWHmBe2+dFLMZhCJShh+XzSNsh1glMcD7cHJIzo3QFdAKrqchKgG3MC7AIohPdOGsnL/Gg6yxcjBcjEaRb7gJAwFGPYOLMTqG7kHc0uyz9dolvCmageo+bZiTjcv2aiZdmvMkxuEWrfF6bexVa11n+H5L1K+MHLvqPg8WdV5S0idh1xFRqUcqVFWLeJ70HAB16tJtKQ5J1XA4pCFsnXo4Dk/kTHOiS+D2/lKr7j5hHJ01yU7u+XL1MjmF2CO6FqVLSO/H4WvVbamCTfw2bqMY3b2wKfsQ9V+kaFpKMHRJUJYDxiVWdPXye
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB7277.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ylcuj0pYEd97QCpUf+ZXRyt/9NfU7rHuWVev1U8XYlw6vp6aZZGtsWu3vC?=
 =?iso-8859-1?Q?UOYG/xomSINuIESEfrFY+6Y5hmShr8inmd9K/TlEXfZW1PqKLJgt6/Ezuq?=
 =?iso-8859-1?Q?4t6orf6toMuVNpuka4FPnf1R9J8QVNYGwe/a0Esn1Ttg24vtV4JrO3yxbG?=
 =?iso-8859-1?Q?s7TyI8QQeUclRat8GGJoj98dqa3+5pGRIYGrZipdcjSKFM612EyR5jfHo0?=
 =?iso-8859-1?Q?uX9YJrG9MIjxTRcE3V3Ib9zRF6HkpeAVltXn1QpIKHZr0LuoWKO++FA1Se?=
 =?iso-8859-1?Q?a2skYzA7lWfmh6gZ0mBspo6ohi6Pithxo5sQh52cjdnih214PKmT0Epf4W?=
 =?iso-8859-1?Q?mFTO7WBF7q6uWX5aMZU41yp3DKtkGS77tQxA/I15/fyQl348zE6rLd18Mh?=
 =?iso-8859-1?Q?LVPhdt6GJEEw0kk2sx6KtlQ0rzROTWGxDQMn4VLF0LhdauYuJFIPNnNFqW?=
 =?iso-8859-1?Q?4gRid5r74QivGXVLySpRIaJTVizWjvCkXvEE7MIbtJHuXYOAizraWkYTRN?=
 =?iso-8859-1?Q?krfZ8t6Iz6CuKfbrcuf4K5D9dnTH45QiSRDNMBPhP9NmHCOcMrz7I2nAGg?=
 =?iso-8859-1?Q?SwV7h+Oohb+tFqO7N9B0Hii7ce7NZiKYePtAQ+67UcZEn7U8BL1uyupa6b?=
 =?iso-8859-1?Q?ImuwJbPkp78e2wfUS9Wat1UkHr54txvzpuoms92ap8fyDQKI2YOl2LLSdi?=
 =?iso-8859-1?Q?wi/Q0B2c29jJtUUHz2GcWEZqFP3cFJumkl+WbwPdaOLXf6i4QiKJ6Xa89c?=
 =?iso-8859-1?Q?myWRfKiWCWIyByGFcty+COQlqOveTQgDg1Sj57vf309Z1+nH8iKr+3LH6i?=
 =?iso-8859-1?Q?3zUMQhvc+328vYmJlaPtFs2ruMBQqA67nxPNRO6uChGFBXOf0rELFi5mUw?=
 =?iso-8859-1?Q?2xEN4IbeSvj4FWsCqZLIbzPpmYXHtp0VxITtdN0zoVIK3dxtSFMPGTsMu0?=
 =?iso-8859-1?Q?cssQ15ubQOF52VM/3RXGL3EgR8/iRvGk9UcWck1Zo+ekOtgJDMniRUq6Wv?=
 =?iso-8859-1?Q?5xLXnnbG2SwHy4j2jpqtbypJ26Q6Q5dO+4JQgd+JgVWQ9dfcVEkj6D2y0h?=
 =?iso-8859-1?Q?Tnvb9YsRIQTju7EVHAIpvJlOIlLCL04ezjMbzvhQponOOvT2GH19Rvl3sq?=
 =?iso-8859-1?Q?JH+UpeuA++E0lPB+93taTkrvC8TXU0uvcj5UcWq6xwpmnEF5PbbidR2FFB?=
 =?iso-8859-1?Q?8dJhYK9eHSKU3OPRP2pgUZ0oho+e9ex4JjEgkwNc3+2yZWCymQr2UvAZ+0?=
 =?iso-8859-1?Q?GeaailUqXmTmQ7acV4LYKDB8qAee7hRE9J0z92gHZ/tJKmQ3N7JuAc06uj?=
 =?iso-8859-1?Q?O0E1TzexWgBJIKVQWQeosSL/AuGeAu2tcHy43d2CEUdU+awMl5eUjX8YAb?=
 =?iso-8859-1?Q?yras8m14TXrvCVxEjnGH3+lS0oUiaObodRmTDby1FrQC1yAeJzC3lt2ZAF?=
 =?iso-8859-1?Q?1d/0pcldRHEJTxKJRmHIqY35mZNztL43vQYJO0jJU3j3aQfOOhE+zG8CAl?=
 =?iso-8859-1?Q?TboI1nMGaChCIDg/y+d+PcacRRpjholw8SdpsYM5ve7sZvkolu0cxwphzb?=
 =?iso-8859-1?Q?YEloOgFqiM3QSsz1DnM+qg8NGfTxl2FvDEKTBhHgD62JkBpVbQ0vXQDfbr?=
 =?iso-8859-1?Q?CzjRto624AYtVyDnYlyIINXPxnfElEU73J/Fu+ae5BooNiUhPV8G3DhLwA?=
 =?iso-8859-1?Q?MSYWB5ZJB4Voxs1ihAsevjH434wy4XANassjGHS5x4hBnTuHeCSRgT1hmn?=
 =?iso-8859-1?Q?AunnTsbWSbAkbeJ8iZQ1Zv8SUQL/fLEW07PyPbmlNzr0Rq?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	inFzAQ0jwTatt9VFWOkhyx4XwV7rZMIO7+TBnQKUHWfyO1dHksDd3REqNRjRS/pzKZMKtS6kH6ILJrCfZ+7LQ1AQmmA69YFKrptVLDzNoBKqdajZV35EbODkIxhCFJ44RGjHvNkSl0QgbM1EvwJdYadarv4RLh6QoFBCwOOwiu/pJTJF2o3407QDgA8eaQ6DbQ9InX4VIlEQg8SDLiNxvHuTsJkwLTczpuAMm2SXQC8ng2MCTc7+lkZRBsQUCy9rBFLwy3sy+0QJlQK5vA1LjHZA0Qi3kMpdwlI6NPZZhIGOl9O3VScYMU/kR47EajFCK2L/kvw3tJG8t5DcSfFNNg==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB7277.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c05fad-dbd4-4615-4b4d-08dea7b5045f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2026 19:08:23.7211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O15W2BoF5BeGhKo0hiPJGjAAm3X/QrhVhfWnMzh50md16RKcilCyN/CXekYgd2A74MqjffO4ffCey8zu14XJEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8303
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-1.cisco.com [72.163.7.162];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.162, rcdn-opgw-1.cisco.com
X-Outbound-Node: aer-l-core-10.cisco.com

=0A=
=0A=
________________________________________=0A=
From:=A0Bart Van Assche <bvanassche@acm.org>=0A=
Sent:=A030 April 2026 11:20 AM=0A=
To:=A0Martin K . Petersen <martin.petersen@oracle.com>=0A=
Cc:=A0linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; Marco Elver =
<elver@google.com>; Bart Van Assche <bvanassche@acm.org>; Karan Tilak Kumar=
 (kartilak) <kartilak@cisco.com>; Narsimhulu Musini (nmusini) <nmusini@cisc=
o.com>; Sesidhar Baddela (sebaddel) <sebaddel@cisco.com>; James E.J. Bottom=
ley <James.Bottomley@HansenPartnership.com>=0A=
Subject:=A0[PATCH v2 53/56] scsi: snic: Enable lock context analysis=0A=
=A0=0A=
Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
Acked-by: Narsimhulu Musini <nmusini@cisco.com>=0A=
---=0A=
=A0drivers/scsi/snic/Makefile | 3 +++=0A=
=A01 file changed, 3 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile=0A=
index 41546e3cb701..b12563cb174d 100644=0A=
--- a/drivers/scsi/snic/Makefile=0A=
+++ b/drivers/scsi/snic/Makefile=0A=
@@ -1,4 +1,7 @@=0A=
=A0# SPDX-License-Identifier: GPL-2.0=0A=
+=0A=
+CONTEXT_ANALYSIS :=3D y=0A=
+=0A=
=A0obj-$(CONFIG_SCSI_SNIC) +=3D snic.o=0A=
=A0=0A=
=A0snic-y :=3D \=
