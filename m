Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C08C6BFC0
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 06:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718691533; cv=fail; b=fQsVtLn99VDYCvuPMSRp0AKiWfcDH5ikgvndZSVaIXYpcsJqORGa4HpAHdVwtDuKFAMwSvC8wTCqczMkcIkCHHfS2MMemVpq0wix31fomYNK93ukZaKZIgA5w71FUNC9JDqInbO7VSt0zqV0Eh+CZIAP55PiSAh/hXEkgyTe+MU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718691533; c=relaxed/simple;
	bh=6lE048ZVjIIjhV+CdH1HO2QBmgWcd0hNCNFuFwNvvP4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bojr9WbrIPEPmbrbGHKQ1UmQ/DlUtge9LPsn/gH3SAkT2PPNaYbr2t2Mj6j/Bw5NdQcb0nYv/KJ8QuDehjYBQa85iavyz9ev1f8GTjmWBvt2cIe4d5VeUYcJ/v96FXYP9oAiF9cAx8Le49DqkCu/x2+wo3WNNuGUWJbv3n9bS8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fSCrswt0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jAR6EULm; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fSCrswt0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jAR6EULm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1718691531; x=1750227531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6lE048ZVjIIjhV+CdH1HO2QBmgWcd0hNCNFuFwNvvP4=;
  b=fSCrswt07RHtchXYiFl1Kw4UXIQF3jN61gLb1TYYJlh7RnCZiEMj6XOV
   BabyJMxG13Oty4biSVbVnP9XmGwU40T3eTi+iINLvf2J4n2ZFsHrwqrXq
   z5+FSDeI9lYNJ3/E+JRoYUsu0XVLRwOBCXaIlTutNBDGBhywTbADNvW4i
   YqnjvkwOnGs7ryX7Atl2XmVxXPOTIZamGarQfxpQ5MOJvs2HFmHHvRbKt
   DedVgKE6NbJ4QJZSBz2Ghw7036Oc1iR4z/oqF7UG51er13+t4kXELKLK8
   g4RSBDppRyLEHVVCti1c5Q6XBrH0n2QHhR/hqyv4tfPR+EUQCMMRsjpUp
   A==;
X-CSE-ConnectionGUID: qhN0oXKVQI661UwZSPWxQA==
X-CSE-MsgGUID: Fmsm+cfMRG2SH+kQU5lXQw==
X-IronPort-AV: E=Sophos;i="6.08,246,1712592000"; 
   d="scan'208";a="18618972"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2024 14:18:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOV90IWgSso6EdXnOz6+zpDg8DAyCBZcty1+KXskUUk6osaBceMfkR0PPc6Mm7tG3/e6mZWfmnGL7fuXYHJ9Iq1QSIR4deB67E+9asIzpZ3yyevx0GR8WPh4dFu1cguXaYdzmyTOropYRnOc+IJx5XyyBXZBHI/8MDjqCRHhFTSi10Q+DutPNS/D5sR8PQ7hhefJHoLiQ4XUWcTMFIB1f6FzpAsx4maJKyBw5wy/jeN8c5fjOxAmTkigN4e2ACvHAQP9MuKTdcD7eQfjsr0B7BfRcapk3x7szS2/O9MKbbEgy+ixjHQKOdmEJPemOxuZQVgaFzt6FwlO7A8dShmdYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lE048ZVjIIjhV+CdH1HO2QBmgWcd0hNCNFuFwNvvP4=;
 b=YjYRwsT3quybV/rwV51DzZoKhSGxz6Wx6uaY8apUO4M20nZt0ju3Qmyk5wPgPKE35xdYlJ5bV5euY0yPCXI0s/WydUOuPBzQZ36oCvdlCx1JSmbyFUxYrJe/fheTn/OsiC9i5JjWxVjyrCJylqWKiJaLnOBjNoqzrfZ3bYKRbc6FwuWTAR+EmCrFTinKgU+zwdrLG+telx1ne0eBDqcgDAZ6Ijg5CocZyfBuKwsNVz0DeLLfRwRwfvujH6BDgP33BwgV8wgnqW/H8ldie9J7JK6+t22h4vqujJNqUn1M5TfqYHNK/benybpWqXzna0tezGElSlftnRJHoQAosi/G2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lE048ZVjIIjhV+CdH1HO2QBmgWcd0hNCNFuFwNvvP4=;
 b=jAR6EULmwaA3uqj9G04yzlRZsYduzRhbFpsSJ4tb6UHFGM4BV5GjELGdpUxAU4v1wPprKqymSms0Vf5lLGReK+eSD/y2WxNT6u1qJUSj7btcECblnNjxH+WeYoLchC+qyZPqWViX3whwMVZ3rMMAFRLGnaC/EcvFrBQPkR/6uV4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6745.namprd04.prod.outlook.com (2603:10b6:5:22a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.31; Tue, 18 Jun 2024 06:18:48 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 06:18:48 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Bean Huo <beanhuo@micron.com>, Minwoo Im
	<minwoo.im@samsung.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>, Akinobu
 Mita <akinobu.mita@gmail.com>
Subject: RE: [PATCH 1/8] scsi: ufs: Initialize struct uic_command once
Thread-Topic: [PATCH 1/8] scsi: ufs: Initialize struct uic_command once
Thread-Index: AQHawPqfQCGy8C1o5UeV1hTDGuAi1LHNDJwg
Date: Tue, 18 Jun 2024 06:18:48 +0000
Message-ID:
 <DM6PR04MB65751A43021B3B75C503C056FCCE2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-2-bvanassche@acm.org>
In-Reply-To: <20240617210844.337476-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6745:EE_
x-ms-office365-filtering-correlation-id: 767c46a3-3ae9-4ac0-d175-08dc8f5e83cc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230037|376011|7416011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Kpo706moPrYbm9dyRZfCndtXqcEkHG8z9SiQRf+Zy3isKRye63DDZ0+GWS5r?=
 =?us-ascii?Q?wvMfeikALzLGcE5iD34xR2KKTCNjMFrHcPOTQaLtJm9mwhpUgxybrgVgygkR?=
 =?us-ascii?Q?OqMid0eI8labMdhS8d/LASVJtlw89MX3m2h5Vy+QI+HtfsQg365ZeEGirIoC?=
 =?us-ascii?Q?i55ANnO6irp21xUXtlL3G/vJ2NbfAVA0Cuta87vhTnr7WipYTuji/wz8jIEB?=
 =?us-ascii?Q?lwi6cEi64JkvSVH0ZUwI4PSq6jixwV4Rxp4Jijnv7RjmQC8jXtprGSL5FdT8?=
 =?us-ascii?Q?bhLnVy+tcCRi5OHuJLUsnHFwfedbp+pM7VOmv36/1fUt3pHpIHm3+omKkTMQ?=
 =?us-ascii?Q?K0Mu1daJ/cCimjwhOTmoQtRrLVqKpyfchkq7H0UGCIFYCmuc7JPD7NDtFkuB?=
 =?us-ascii?Q?e02CY2Dk7riCIYjhj5FdbzfLdMwkFXr96jWGDkVWi/HkoOLUZoj5Wpxb1Re+?=
 =?us-ascii?Q?qmA0ZRvlSfXbAxZDOradQNwpp/oE/5VHwJzsqwkgaJBNd87TAQa9pfC/hMZa?=
 =?us-ascii?Q?FHInMrqVa58DM4CgEFmsD4TR9xjBHB8IEYzj5m8cHhpu6ydg9pNLbHlYx7z/?=
 =?us-ascii?Q?9NouIyHrJnv4MNnfA3B5HoOHuL4sr9EmSYMapsXwiI1sKlzjlISpK38cL/FH?=
 =?us-ascii?Q?k4SrSKDaWG9Wj36iHqu/da8mNW5RnVvv5K1wCHOCfWpeIegvLZ5a4MlcNJxc?=
 =?us-ascii?Q?6QV51rBcmRWY3OpOVU3RKGzGJp71fYdrD0meYvQO5+3Fwqyq51yrCyPNvvsy?=
 =?us-ascii?Q?ivG7D9FpmNzCfRnQ+K0GOyuXybG2NQVbKPxytUy/flpAsPEb8Wfz5uZjST/J?=
 =?us-ascii?Q?o967w/Bl5DpNEWy9hmBSxMgTO/twxUyvNh1rUeBfKE4zn98Oe/xef7d63tVF?=
 =?us-ascii?Q?XlcNNgEO42FTaHzrMzBIzSDHFddaC94FvF7/v7mKfFiSjMYXTLsCwvHStAbW?=
 =?us-ascii?Q?yeT1RHuGU7KnmTwmuRC0jMwuQCKcm4N6GnK6mBXAodN8nPbRcWtzNwaQ6rRi?=
 =?us-ascii?Q?JxhC6ci8nvOZLy6aG0+h2ob+szW8O79eUjePvlst7rjAIXQEUoDPCSpeTGBX?=
 =?us-ascii?Q?fsQrIvFvS+NfnqX9/aByZRO3PGg8Q7xyBZQ5B6lo1xiI35nt4Jkb197a/6VG?=
 =?us-ascii?Q?/hbtx5V3LHzGeX0NejWXtbabyhI3sZlmmAlPay8O8jglw7ICFYDbe/wtnkXT?=
 =?us-ascii?Q?4UwAp8mx2t9EakXcBwJsuGU/SiDDE5DvA88udv7D2Hqqh4w3cqXr6rF2xiMi?=
 =?us-ascii?Q?wvmTiB1+QlH8jFtmmOC5Ul4+zBbTmMF1GtdZKuBzv74CAxZA0kFz29yJ2I14?=
 =?us-ascii?Q?1/A39iK+m2N/dC72uAX4l0YeMxJK+VHB25QgD2I2tjjQaB5wjv/LaHPEFrbT?=
 =?us-ascii?Q?OfNBseI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rnzquNdvGN5gVyK3ng6HSiZQps1iTu6FfUO32OwC7kt37JjCU0HY2YrP3Tku?=
 =?us-ascii?Q?4QnUPilbZb+La9D9MaE8M9BemmlMOUeCLlEbQJegYiN6h8z0VxxdC3KsCGPK?=
 =?us-ascii?Q?oW9JOr5M6vjXfIVil7o0iQhc7oNushhuisKm+U+zUeHUqXhZxsBCwCgQCuWO?=
 =?us-ascii?Q?WC0df7rTEvfKOnxyWeEyY00yO6njHuu9rNuA1tTvEch7/w3PbAWpFdEWwoUk?=
 =?us-ascii?Q?2PKffiXm3O0LK0xt6/JxBthC7WcleapS90oLv1oEYNDnngoj7w+B7bmiNGYz?=
 =?us-ascii?Q?6eGPNZbmypc77VCnJ5wcs0JghTQ1UepG7u8Eymkd6602vzuPcvjzzMrJuxpz?=
 =?us-ascii?Q?87+Q/8TmGRkRBchTKmet/seusnSqohp1I/XH7o5XN8Ggvwa77eHwbphQ87zu?=
 =?us-ascii?Q?3/1e8vkwbGde+yIPNL+Xx2bcwiKKP7GRwymkmmYohRvlCANrHqzma4uf9rV8?=
 =?us-ascii?Q?grQTD1QB8i9NaiMfd6zIW0GyZP6mX45dlQXHS/j6ZFZOGu+p2CKHvy74wDit?=
 =?us-ascii?Q?UhpBYNELXmwv3Xx0DpxWgho4ye9l5AQDytoMXttLj+5yh3YcgNS73fxNQ8KW?=
 =?us-ascii?Q?cYIcw4Gce5ejs3SMWrWoGExLD81AC4MsJgecJluXzzYd3ls6loJXXrlPstNS?=
 =?us-ascii?Q?jVTLVpMCQLdxCRsZXdKZ0KtNPbRyRubTvofM85wjB4DXhteH6oRLBzsEcCLM?=
 =?us-ascii?Q?cPnLRi2tpD/Ieey3Y/S0u/HaRVbu5k0FYm8q/GuSwY6B/x/D3slonZHKPKXQ?=
 =?us-ascii?Q?dSGhCrm+ulWr3jlrlsGxHQtsyGKh5jd/yQjlCkU1G6OYuvyJGHxCmeV5yLcc?=
 =?us-ascii?Q?bCeIXEArEB/5C+YuZAtBsIfG94C9pScoSy6hJmW4nDPnyBg0EF5PRO7K9zG4?=
 =?us-ascii?Q?mrO4QHpsnmJdGR1Ep9EbBexPpzj/jFRnqhBhvg7mU57iPXZJwnRDGMMfNQ0m?=
 =?us-ascii?Q?rzu+H/GzzvHvNGbYUY+9zHSAtBISMWLE1lX20Ew7EHAl5TF4pWs+Vo7iWvaX?=
 =?us-ascii?Q?bOEhxKetdl/FyYs7w4HjCPdUu9du32JKEUUE0iIhMf204IqDENwkS0+UtCYG?=
 =?us-ascii?Q?XEwd/fgtHMqgz/mn1iy1J6/i/RHMie2b4Ao+Wsx7oqgg1GjKYA18ryjxed7V?=
 =?us-ascii?Q?QAz/gr8rP5luV7M47mUtyQZaMo/UK+vAclZ2F8LX0Fo1gJ/WVqJ/VM3LBaXz?=
 =?us-ascii?Q?ZRvARXorUxOOWeThN+CJPOKB8oGDPsgervS4H6/iePrOWMBPe5wY1PPemt1m?=
 =?us-ascii?Q?wMcpH899pSyDpEVSJSgEdmDgBOwUbRAyrJNqGQhg6M4skZ+QCK+7wmo1WEq6?=
 =?us-ascii?Q?P7adDKHt3BbFI4pwWMh85q12/nuwPYGN0mmMiYm3Fin3SqGuHQ2SXROmzGus?=
 =?us-ascii?Q?FT6l4KEX5wT/EeF30ZRBbetqoHKq1cu8gDZHCVzIManbG/RuIG5msScgb3YI?=
 =?us-ascii?Q?m5AgKF4wJhTOxWjqCs2DoRuhYlfxNuFkMW2ZBPznJ9bHdN3ymlvjg66nIDrj?=
 =?us-ascii?Q?WsWZVT57kq4HJXJQ9WH+AGSlALZQt0u4/58yBrJHWZEZTdB9P9xJTe2mbYCi?=
 =?us-ascii?Q?P6oMS5qlX6MJdMOhLbUzteXdFIN9kACq3/NWTTOl?=
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
	lDVYt8fixZuAC5KVqf7CSs8tLMmafmU1MV24wx0N2nTCknSh8NBevwg97cCsNLWqPNGwRSy+crAHJB42OXlU0w3Yt+A+Ry+ZKGJqAB+vbUpE79xlHa4Bzoi/39GE7h3wUUwIjlMXjNiv74zXQFUoxMx4+Df3+WNEQSVj//Dg5OI0zf336ke3c/mxEKINS13tj7xLy2Y32FFj+fo5JloG/51Mek/bpQhXEkrg0uXQsuxe5PQBaT+/pDxWb2856C9BYt78Vu/IAFvN3m+DEJWf/B6HrQ/O0iqUaRvTx3M038H7e9EyVN2/0EavPzGr329+lP0rhbtR3elWZ93B/CtPzP6re4OLQs194KXhrDhjvxI1bD3NvaYYZr5xptBhwDA18uFL6IXc0RGj44mo+u2SiP9RXq7KhpCh8v7un0jajZwVQDgpw0kVNIC7Sm/NBMvj9nCgOahokVPiWDEDT3OcYUEIsS4s1lbSm79w1NvywzHpdH1W2GcFSNzY8B+MXlxESzuEEQRzO4Buluv7g76rrcrEuMunq2wdIbXNp3Y0qvYlnS7HH8oeKUNeTZV001Tq2XOdS+iibNXx9A8+y7zoXByNyTZI/Qpdkcnapu6vkU6DZYRdez8gjBYCqlgLueGC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 767c46a3-3ae9-4ac0-d175-08dc8f5e83cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 06:18:48.0164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OrxN5vLr39pZAby2OgHpf7MN+XZW9zRHRwZ7hYS65cwxDk5uCgAFaTgvG1nSQ+I6tsu1JQAzeDi4i0Ljf6XLBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6745

> Instead of first zero-initializing struct uic_command and next initializi=
ng
> it memberwise, initialize all members at once.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
