Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989DB1C84A1
	for <linux-scsi@vger.kernel.org>; Sat, 27 Sep 2025 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758964295; cv=fail; b=LOqE06BEmbR206/mxrIzhcHisNLqNKxb7rjrEwaxQKSAJ+sSghMtUIgKAk6ZGI3jgcPtPfW+y106U1+UI37lK4x4tiXJvPMgsnqn3JRgfEWSfXmFbrbjFa79O4XN2kr6Xcq67JLC+EmgE22OWZ70dSOr3rzhTaOtOyjEQwJcwIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758964295; c=relaxed/simple;
	bh=fZribNsuDuLnwxlyF0wUZSfUXZnJlZOOOx2TbWFr51c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f/0RtdNuK4pekgEvHkYGaMbNLh3mwTWDOQPw5yhRZKVAEkRgexeQxLQ/nKnP3MSiLy9ytg8CtshJLJNX2xEJehWiY8nzsxlDkM+X0Ni3GTM/u3pvlGJuRgv2TF8Y2d5qhWCwoxuRBRwNLCKBpEpTuMRqY8M67mE0xzcupRe5lkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=onvbBHDO; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="onvbBHDO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758964293; x=1790500293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fZribNsuDuLnwxlyF0wUZSfUXZnJlZOOOx2TbWFr51c=;
  b=onvbBHDOVL87+bdBOdJlQ4LqHU2Y7ERuRNpc2sjEbnCWJNMzDlqxHKKJ
   Ga5h8VmivLvbaZVYugUl76achvJZhbx7HZgiX33IDqSfzGNpdBS8NK2XG
   HKgEStFPeG3cPugAMAg/QdOVSOMbPTTlak8A7u1VRWpxwAukWEibWAZ7d
   JCi8zvJXIjXTJKxcOChJjDY54T/FkWxgRAuAvQIzEmYJrEDuVkTR/S+/p
   OWM/ZpzPM9pt6e+NwIcNcuYJCu16Lu4EonZn5Oqbs6hioQFQjATurEywU
   isgSy5kzRFyRoR0aW2scE1Izzm1aun1fnJU01qPeo0E4VsaC6YyYzAQtG
   g==;
X-CSE-ConnectionGUID: zFWvNGwpTASvd+Get3D0KA==
X-CSE-MsgGUID: M6bJjk8hQXmkDhrUKrgFRA==
Received: from mail-southcentralusazon11021116.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.116])
  by ob1.hc6817-7.iphmx.com with ESMTP; 27 Sep 2025 02:11:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRY7MeW8gcVlUGBVes2IvvXgkKY1ywRYcDPcUp6qtaKr7QOieNOr5LRPwfrRrJz1DeyyooSG25eFhINd9wfpoZ5mLgqfI5W+HcrGaFRmxyCci8aUNUmwqWyYJUe/YC7MLgmZUSeuGHT4t1o4ckml13RdRJh7q+goQEVfij21F5VeoU9TP2vmy3ffpNo5IrWtFjKsqUJVFOqrhKJbkVBWxX6/L32I6hW05KtTNYA15NSu+HrcFDZxARDlOPY0eukAvQlTrfnEu0tyvZydO4oHlgr8ua6SwGYsmoTIFjoo0VtABgmJWFuud+quP+vAQbdvlyxsWqFDMyuvwCqj+oYptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGLabo78VeIlnteTPxlTu3PqxDo6DVlt9/YpEe+erGs=;
 b=FeQt8wNazbZ30OQEIRllES4MAuA9oYIF2X1bVLjS6BchWvGrJLNAMs5anP8eQSH+kb9Hy7jyjK/GkUrrFvlkzKDUkJ56hq+etU2ZpdpnTE9DBL+NaJ3vzIYQToj3oDbnXFRHEUOYd8R9P17xAFtE0BWE+ulDk5efrOPhutQ8Fe7YLB4D/IiC0PDPhzUrQfXH8aSsci6CMTpRKZqjI9dKPmISojCKGkt407DyKQusLcdSaSqrFdZsCMdF9+/036x17Jq1+6TKaZ1dtxgaZj9/OuuOqiOPCN4k3lybrCghwAxqE8p3G5wrHyWNR+fl3Ua9Ndak71ywUFuBlR9au5WL0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BLAPR16MB3668.namprd16.prod.outlook.com (2603:10b6:208:27a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Sat, 27 Sep
 2025 09:11:20 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.013; Sat, 27 Sep 2025
 09:11:13 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v5 27/28] ufs: core: Move code out of
 ufshcd_wait_for_dev_cmd()
Thread-Topic: [PATCH v5 27/28] ufs: core: Move code out of
 ufshcd_wait_for_dev_cmd()
Thread-Index: AQHcLZLEK5SVn9ZSXkeQWwUUlzff/LSmwguQ
Date: Sat, 27 Sep 2025 09:11:13 +0000
Message-ID:
 <PH7PR16MB619676A87B2AC5C5F91BC75BE519A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-28-bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-28-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BLAPR16MB3668:EE_
x-ms-office365-filtering-correlation-id: 3ac670c7-965f-4052-79ca-08ddfda5cec3
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Dt2mhRbFZZk2vWm62/wK+mXLBrNPdZ+q7oEyBZhSga6em0IGejt17p42stT+?=
 =?us-ascii?Q?BeRqNvOzZeFAgOMQHgn052fB4xsMhq6/Qqrqt8rl/Nsm5uqlREquaieR1BN7?=
 =?us-ascii?Q?MpBRMXPiocOvNhEUsfNB2mDydQ9d6K2QDinKKQiXO0/N1ytjSNZXnkMIJ1TW?=
 =?us-ascii?Q?98JsPB7kKbs12IjtfrsF9BSnkEhvub/OxKJD1i+LHIIsfUTVNJWcJX740qsS?=
 =?us-ascii?Q?dCjhFAvNYi7cXpCa5QpepjREgJUsegVHDDlzshmzfRVcgmnUwvpXppJfe2LA?=
 =?us-ascii?Q?EpFP+2QV30YtGM8+Y2v2LxxyBlTLZwh1AcZLMZ/ul7CohwNyRYK+Y8iCR/qo?=
 =?us-ascii?Q?Uu6Vt+uXAns3dB0dgQ/wrf1VTIxN+HYrKxJoJlDiu9g8iNa7oGADMOhevqU1?=
 =?us-ascii?Q?XqOtqYKX3OcKS93011MM8Yk2LS0BbkPFYXESH1TtzUcug5RV8r3AZu3g6TX0?=
 =?us-ascii?Q?aenm1PaEPGRqEDKWc9FLdP9QnVEKKLZow4v+AcqCjzNQ0gXihuY1fiZdAnpt?=
 =?us-ascii?Q?5GvptPxWz/xxj5079oYRoVILeUcuf30fHaX+tBVY9aaG/LKYO6lAVPUxEhPW?=
 =?us-ascii?Q?lQhADb/3kBdW52eiQKqCKh8RjGSTMLSAY5pVCXyKN+UTHzY/uRSmBaL7H1qq?=
 =?us-ascii?Q?Lo4S5+BsfqYLlRSte3GJGaKnAesQHv5BRsoljMdvHzEptDmN+nfRkaVd8m+C?=
 =?us-ascii?Q?nUjUQ4Ow33+CtiUePy6wYDsaQYAZ/3PdvLJVQtK4+wGgU1DKtYeCrUNz2PAe?=
 =?us-ascii?Q?w7cgxFxUJEkjayRQQI9ye18u66ufMPGasGZxeTmsrbH6g3Rd/2su4lrEeTM+?=
 =?us-ascii?Q?+KWrHTa2fipkd9pIl4rUe7nYEmUmM8F070M/nG//5ux7qp7VPJrXo1jkEhaz?=
 =?us-ascii?Q?lije3kkytsb5MnG95mP3F0LJnA/d4+T5wGCwaaS0a/rxqJpuEt/zjgiz6LXq?=
 =?us-ascii?Q?fC6vKMvuEEk/Lgr8mA9vloU9O12lpO3Ar4/6XXmBEGE/CvsXhU5nWDltjBeC?=
 =?us-ascii?Q?OHIVrcedQeezXdmOIrxGrInbj+Y39tfYwP1i03IlNCAZEwG1EaCnkfGXBwea?=
 =?us-ascii?Q?vsohCEyNeyZCaztKjjEb1fWs/cSA+s/2dzfu/jRCjlRLCH0gYsP3JjBXBb7+?=
 =?us-ascii?Q?UxQoOKikpafRKQQh38OH3+o1ZxzgHCzfxbPqhge4l6zWKYrjTE3M+wKxOQLw?=
 =?us-ascii?Q?qdvLBlZ9P8a0+mlOkCuPi1sD5hrHC7WletZ/8p1lu7tndb152D6+ub4/UZfs?=
 =?us-ascii?Q?iBqiFj3yBykaPRn/X8Uu0tNCryJley5Hla8oODlKq27F6dsaDZD1QGO15/eA?=
 =?us-ascii?Q?N6HcyT9PftjXxmCzam8m16emrtoQZjH8j7JKqSiYUyYa1edxYlBRLcdIzCt3?=
 =?us-ascii?Q?4OG657QVbAM8eiJFk+1Ebzy6TerBjnIcV1OCbZlNe1VAk7yOvipwibUHCwpZ?=
 =?us-ascii?Q?4x2Z7tr2X6m0LgbTkB2A3POH+EgA2cTvBaFquBBkkwEog5Vkxdlu4lDrs6Ue?=
 =?us-ascii?Q?49VtxyJTE5ZKsh7GQil+jnjN9V+zY/ysFhKq?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zFJC/NVXr9laJfn86x1m4eUrx5pc5mJDQ7rBN0q4BjH9z1/kCaIEPUQbDpfE?=
 =?us-ascii?Q?3iguzyqgbwOxah98YgwT9Or+A5SqVR+rJh+ZQEyr2cfsL0LbPsuU+2gwd0bw?=
 =?us-ascii?Q?3VjgECEStmin1RgG0F3VifQDl0DT5FPwH27SxYAeAk6938gh0pOuXbEkWFyQ?=
 =?us-ascii?Q?/dN/vzrGFF+Ad8u7aIGEjhxtKLRCvZQpECETkBK85tVZjOXmLDD9C96hzcqI?=
 =?us-ascii?Q?36Mfx+i98ciRUDPXXZ3UR4ePMU9xywEqNdLmnCE4CFFk+XWHUgHxmJKQ5tNb?=
 =?us-ascii?Q?NYzDGZ1CZl+WjyfBzYHhEnEd95DHmixVEPu2CuQlNTNBf+G+rrvF9OYY6F7w?=
 =?us-ascii?Q?qJwemXjd6Gu/S1r9b1aLdq2PeeSXR/Rd5PEfpGqFOFTucUSyhLSDjLBwW3TW?=
 =?us-ascii?Q?h1TzFeUkemUlRioc/cZInWfGht2Bs+n8KFlEsu2llJf6Asc/oYgeeCCmHTA7?=
 =?us-ascii?Q?6b9pSh4+Xmh/oM5UUhLAqLYNlcG411/qCfnbxIm5LegJMX23hjuDmexNSBBb?=
 =?us-ascii?Q?5ihtVGqO99T/g68vgooeQt3M5o82VWXjbsKwiyITMquABcix3ZTJHUTOvbkR?=
 =?us-ascii?Q?KxFpzCEe9AQOOOLl0WcPwqhaD3L5FpIjfFTJL/fWJL108irQs8aqN/dtqvW6?=
 =?us-ascii?Q?A+YPjCTn1E4MZiS8oX9r0zjIyZikT2ikUR4cPLBy3NwXvVm4sThhU9VGcrD/?=
 =?us-ascii?Q?2K4gwbMakfm4elMROvcEvfGGhefTL/+pRBkOHuyXEEtt4DrPa+1Y81p3XerJ?=
 =?us-ascii?Q?Vb7wOGXpy//83Fq+FvtJOQM+rH4TnQo5UPrMsAfnXiMEudcHeWCqht/Kjwv/?=
 =?us-ascii?Q?x1jHN8JXri6R2iD7x4yiJvbEk0fOsR7QFjnwMquJzqiAkDWMohoA/7S94CEY?=
 =?us-ascii?Q?nSpoGGr61G6NYenhpRp+OAVVv/Pr0QgdAxoXSjGp40Tg7NFV1hFqzOHXtNM1?=
 =?us-ascii?Q?t5HCwRSUhBE75HlKqCs3vKkMls58pb2xxuwxKFP7IjhCrGKGpyo1l19z97MA?=
 =?us-ascii?Q?zS1PTlBl7k8LNiNDxzyQMu2gtcb4YKHIdO+XHArSF00aoeMKYCHPslat78JD?=
 =?us-ascii?Q?ca5ilpfu3s3ZkF1VhrMuv4YbysvRwU48/FhPf0LX09aBFdSwN0UBwOt+TiLM?=
 =?us-ascii?Q?7l80QZpJhZ7M67k7KGtgPageiIF4y/fcgE4eFPXrzKLTfgq9Qg/2LOTZHHIl?=
 =?us-ascii?Q?mRQ0cTuuKLz9gK+na6U1YeOhy9VQBXliLFHMvrYPsry0a7X1apRwzgZWSaUr?=
 =?us-ascii?Q?IZI0uggLi5AdwjnG0Wx/xBHDmhrFz4txi2NOEZZqEIqwoJUTmBrOzkkJw4FQ?=
 =?us-ascii?Q?C3kwVgdxSHIqy2mTmn2dVhvMHnjxO4IJU/1dXhjlcMuoz92gQvFodsY9M9Jc?=
 =?us-ascii?Q?NCymjjdUqorQcAVGQ0NEDWC7sGSVkrabsJoCZ9noz1XHm4EQhXyoK6OjFjWo?=
 =?us-ascii?Q?h1TUgsvb2YwE50MRkWMo0+lXxEvx0rFNW4yRqkFo2y2QjmNlCSHoLNjsOgWO?=
 =?us-ascii?Q?5Rs2DjrGJKBNf5l0gHoIUVQcv4Xi4qp5FOOnOWXkVfsoMWXWGK9ShluFv0/i?=
 =?us-ascii?Q?Tk6z6HylyEsWGgm73fkT8huHpPl0BhkOKlEp1cKR?=
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
	QqLq9r7uKXPBKwPG+fW/DcHU4l/BQp6nvPwxL98B8oP8Nj9vKRXMjfSt5goVDTgqJhFJuqY+ki47ONn6+P89Cq+JZR5NWRMRDdbD2lTf/V7LuUUVoHJOA3CMvR4T2RzDx8LMLkL/XVZfuUW6cy8hCUGWD+CDKo+mBl4njZ6rU7DtQ1AXqarGP2DHof7RVQJp09uCOhwPVHmrx1r9lDHDtp+hMEZipssE4gKtOOi72AKPosqeVCKCL6R4KGi2e6PGYTpNnPBtWcgIY+xLtqu9wk3Oq5qHHgh6uK3b/VsFEFX7WxsMjlTKqyg94elAjogh/9ypsUhP1mV5Oidbz0sAVPLmxa6mM8HS5CtSZmkiXePLn0+H81nmA/vye3rYHyRgxKDHtY0Dt9AofB5XviSZEJG9iiVFocLX4z1ZRyRygG3hZbGStd52NFN9DSjxbYhWdzB4YHXQzAljL5QC83iMQQsRGCXhKxjn8L6Md6h18EpQ2r6G8xZN5LWFq69ujbreumlgsbxMZVEPphipOhKwjl7PiEE+C4qFdb4UASQh7hnjHlWdlk135wgv8eVc5RtaZQtNaCTv2LqKj/q3wiP52kjraUrL6bEgSZWMJ1frg7+l2LoB1mbzV6NbKHniJSZdqSX0ZE7WbQSUrreHZM/P3A==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac670c7-965f-4052-79ca-08ddfda5cec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2025 09:11:13.6812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: THVU7OxEjziswWuFVn63zTdSmc7Y79Bmmsvh8b3G07iMTU7oKIMta6sFTvezYjrGpr/mQvL+ZYvOnJztVliPfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR16MB3668

> The ufshcd_dev_cmd_completion() call is useful for some but not for all
> ufshcd_wait_for_dev_cmd() callers. Hence, remove the
> ufshcd_dev_cmd_completion() call from ufshcd_wait_for_dev_cmd() and
> move it past the ufshcd_issue_dev_cmd() calls where appropriate. This mak=
es
> it easier to detect timeout errors for UPIU frames submitted through the =
BSG
> interface.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> a3c4f8cb2f37..b6ee8bfbb718 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3262,8 +3262,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>=20
>         if (likely(time_left)) {
>                 err =3D ufshcd_get_tr_ocs(lrbp, NULL);
> -               if (!err)
> -                       err =3D ufshcd_dev_cmd_completion(hba, lrbp);
>         } else {
>                 err =3D -ETIMEDOUT;
>                 dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n=
", @@ -
> 3372,6 +3370,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,  {
>         const u32 tag =3D hba->reserved_slot;
>         struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
> +       struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
>         int err;
>=20
>         /* Protects use of hba->reserved_slot. */ @@ -3381,7 +3380,11 @@ =
static
> int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>         if (unlikely(err))
>                 return err;
>=20
> -       return ufshcd_issue_dev_cmd(hba, cmd, tag, timeout);
> +       err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, timeout);
> +       if (err)
> +               return err;
> +
> +       return ufshcd_dev_cmd_completion(hba, lrbp);
>  }
>=20
>  /**
> @@ -7384,12 +7387,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>=20
>         memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
>=20
> -       /*
> -        * ignore the returning value here - ufshcd_check_query_response =
is
> -        * bound to fail since dev_cmd.query and dev_cmd.type were left e=
mpty.
> -        * read the response directly ignoring all errors.
> -        */
> -       ufshcd_issue_dev_cmd(hba, cmd, tag, dev_cmd_timeout);
> +       err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, dev_cmd_timeout);
> +       if (err)
> +               return err;
>=20
>         /* just copy the upiu response as it is */
>         memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu)); @@ -7534,=
7
> +7534,10 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba,
> struct utp_upiu_req *r
>         memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
>=20
>         err =3D ufshcd_issue_dev_cmd(hba, cmd, tag,
> ADVANCED_RPMB_REQ_TIMEOUT);
> +       if (err)
> +               return err;
>=20
> +       err =3D ufshcd_dev_cmd_completion(hba, lrbp);
>         if (!err) {
>                 /* Just copy the upiu response as it is */
>                 memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
