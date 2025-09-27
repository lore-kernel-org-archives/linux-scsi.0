Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0AC2D6E54
	for <linux-scsi@vger.kernel.org>; Sat, 27 Sep 2025 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758965995; cv=fail; b=I4rhIcG1DjcHabRpQ4cfOs4R7Q3eeeVHM8FH5Yb9JBn1q0sy1x7wkXOxd5uC85gWbABw6BTebOnTLHWwR6FXUw/8mALUU+EhSMIll5S7+xXcoerNOaOlWUDOyGIj0lWfa/iH1Fbyjoe9LI1pBTpCufntD+WD0MS8Q/j3q+EWLwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758965995; c=relaxed/simple;
	bh=eGGxouIj0NCqkJSxLKK9+UP3qwVEj/klCN3DTrn8yqo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rFXuTyvTT72SFIfh/s7bwmC9BLb5g+u2ym42BKvlqhc5CoJjjnITYc+AakE2uWMDMIXmKOxlxR4YRuv32yp+t1bVkMrtoBNLEJ4548eXBSACTvkJZxSgBKIOMVqgMJjPyOch9Ae/iPrE/papBAWiDlpghINlNwAhUAZ/gICusxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=rcbIrB9J; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="rcbIrB9J"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758965994; x=1790501994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eGGxouIj0NCqkJSxLKK9+UP3qwVEj/klCN3DTrn8yqo=;
  b=rcbIrB9JbqoqEhZjfjB7+7uZy2hVjzTHnpuXg5Oh9AuO4J19DS+J29cl
   L1dHcuVhc4BTvq+//bnD+Mdo42YBgDXYpZkTdqOuIOBoZIXIUu5Rcfyha
   6K8ZYjUXX7JhiuW/3JNNEzK0PQHJeCrAW6hMtZiMDpOR9iTjNinaBuGeM
   cEx63+SUGbQD3bkofPgjw8P7KSSe1bskcjfd1n12BU9bMq040Q0pGXQMJ
   33t1BpBQ0hve5ykKbARrQc87y82t8ER2n3UF/vUrbTr+PgMhiVlHNIVT+
   0bT3Z3m9bUirGMIsxD6MIPipa4d6de1qrDtsCeDASYZuEb07MAYhoq4sB
   Q==;
X-CSE-ConnectionGUID: kGFUu0vKQN6bjKrFhJPEjg==
X-CSE-MsgGUID: UIJ9dE1TQv2z1ToIFJvUfQ==
Received: from mail-southcentralusazon11021083.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.83])
  by ob1.hc6817-7.iphmx.com with ESMTP; 27 Sep 2025 02:39:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6snuUro6kv6hvYuDJnyQLgQbMv7THFprRbNoZQ8MMvPcGeutEU8ggX675dd/wbd+FqVokYd+2iBBO96xAG9436dtqyHEDTjxJkQFpNT7A9rPEQVlcl4aSlCNjluKodsxnDllZVePHA6Ve7Nsoajeo/Up3Zv7XWWvt+Tnc0T22o3mvPQ2K8Qev92CLOEMILNk7PA6F1JVhU76tTmEpTpVrpzgnh9lFFCqw31toILu1McdnPmVMJ1Tq/al/ROdNAXgyCvCgzvfeeyCIcpevQAnBdT4NbjvpNRxjvVNHIGRvdJDjKMGAgx4Ew8r/cT8+OJDtkn1E9+FcGx/C7mWZ+yqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKnp3FWLvmkropk7dPwBDEZNf5Zub5+JwaDCPGxmouQ=;
 b=p0I4pQQAEcV1xKqfKYTpG6D0NLd040dYXrd4RcSMvQByZ4stcdViUr4/sAVYjAMTutbSpsA/ojUosElyCUnZZQZzjDdMWZi3wf+nK1T+1Y7zUX6BA11HX2YHELrIBV5wTLn4+B9KRp6I2A0ehZ1VYu13sQDF4d/v0l/lcxRsAHOCD2JBAbOmCTG5OG93kG1HmMp6Ujm/342o7famKFqRXBRpxFqa4Hb4aj6MQa9u9DNJIJ5g5c3dC/naLrh16Muos7of5CiLTiSo52g855eGY6gVDc0lB4LQAKOz6EETE4YO5He5kxz/GLbcV2MgQKgKy7SqJyUAnrRcv5guMR/KXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ2PR16MB5141.namprd16.prod.outlook.com (2603:10b6:a03:4fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Sat, 27 Sep
 2025 09:39:50 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.013; Sat, 27 Sep 2025
 09:39:50 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v5 19/28] ufs: core: Call ufshcd_init_lrb() later
Thread-Topic: [PATCH v5 19/28] ufs: core: Call ufshcd_init_lrb() later
Thread-Index: AQHcLZKZypGpSizcjkSY8Bf+iOwjL7SmygXw
Date: Sat, 27 Sep 2025 09:39:50 +0000
Message-ID:
 <PH7PR16MB6196E79491406B1E7BB2C2BAE519A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-20-bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-20-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ2PR16MB5141:EE_
x-ms-office365-filtering-correlation-id: a4c0a2e4-fe50-4588-14a4-08ddfda9cdfc
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?zYOcLZGtb64/NPz2QKpnOmQMDLkZGQjXTyIDolngQvJvsbDPXrqW1mc3+D0u?=
 =?us-ascii?Q?8kH7hmWZuroIj9AsLE6bSDJzbiKo8BZsk7z+2Ggaadqoou87OMs5EYVi0rgw?=
 =?us-ascii?Q?rRxGkqz5TmQ6ZbzHoc43uk0cLlsN/QYngkeVcb0lH1r0VKRPDmpSNKG5nB4x?=
 =?us-ascii?Q?oU002Cjiy7xrbcBXejSxIcOuk4AZzQdUTLmioZ9N5PEkWWzTOeQYRgnWaIPf?=
 =?us-ascii?Q?ItENykCf2Hc/HCvEIerUGoJqp75+BJhzadWVdPg4mwl9op5F8IPZXSKyu9oR?=
 =?us-ascii?Q?Zgg1oYGfMfvjcu9r3MAAOLl0l6nk9NhQKzPblTXSguhxBano15YjOerT8Gn7?=
 =?us-ascii?Q?9v08o8jqGXtoTgOORn0DHR92/PgxzF2694w3BY+aK0DAvsU1AaaOIgz5qp7o?=
 =?us-ascii?Q?giHFRVc2zdjQmInfEOrAjk4jG/hVxWJTlbKthlUU1I8LmpmJCFDyqhSuUlG9?=
 =?us-ascii?Q?K22pTRi2VQfkQd/q4yL/HFjX27K6gH0iuoAb7tcq57zSXlgn6/d3hfTHCwpt?=
 =?us-ascii?Q?1Qy6Vu9qkyqARQOrg/d5B+eieGbDvoIbjkahrhp1I8cQxZIbdDdyaEyc3QBs?=
 =?us-ascii?Q?cNrwcqilb3kBDWaNTY1l4xePBM3TvKgNbuzQ+4Q7RDMk+1DrbhjAHbvcHaz0?=
 =?us-ascii?Q?4yEDttyKBRWhMrK7L3x++E2Miep9O63l1YR6y4YF6z3BT3Y3Yczqwyc2CxmR?=
 =?us-ascii?Q?+Tlu/ixZdVdPHXJ6uqO1QcsD3c/OR53SsJalT8405BDYdBOO92QHe0nRGSix?=
 =?us-ascii?Q?mZTe8dgIQzoFWqcy+XypVyT3/KBqDJJctfOteUsQdX4f/F7jY0PjTy7xzIdy?=
 =?us-ascii?Q?YmJxfHJMEXdxZYZQxKkU+Kd5H9dwL//mvjlaxAD95blEtwmGcH1ffEP000Aj?=
 =?us-ascii?Q?dB2EzWjlCEm9sP8J15utwAXOiAZYIpIIKRULU8WIvbmQ2N8AlhATx/pz/4Q0?=
 =?us-ascii?Q?3X2W2SgEreYDvX5PtZyWd//MOaDS/e8b1I2G1fO0M6uYdpfPvCHiVi0bY9oL?=
 =?us-ascii?Q?6088JwKYj0HOEfGD1jFae8U10cD2hyt4oEsM2W8fQmf+/uUerU2DV14ncImB?=
 =?us-ascii?Q?OHb1FyPKpc4GhjDiDixgvek6NMP+8tZV7gyQiXC7yekLMBOVch8GoNoZmg/k?=
 =?us-ascii?Q?LugEKCsfJYJKazbJzvGHvdF07p3qGCfb7lC/IdG8fC/XP1l5SxVXGyzlGqfb?=
 =?us-ascii?Q?bZRogxKWZvcgUXrJF3old05obuTei/FBobfS5/w050WCnP+LxCPTuMivjGm5?=
 =?us-ascii?Q?HWDM+Gbe7/Owda+ByjcDt3Iomneawe/Y/XgCSfd4WTeNa3/BRiAQRuNviRl5?=
 =?us-ascii?Q?Q7vN91S3bfWskx4YGRSsHmauuzibQdRCy629LcASyTnxF4KEFDw+79/1pgz1?=
 =?us-ascii?Q?nwLHBEbPbMVMK+X3KyJ4IyNnhUiyubARs8Kw1gyJjo+9zmEvV7yEOu4M9GBu?=
 =?us-ascii?Q?Ue++U2NggdZ2PieVtYyM6jH93p9HVkY0SEbjQhCgCabRjNVmCOtOLiZDOCRD?=
 =?us-ascii?Q?z1aUOn1daSqvEJtxefkX03aKtjsMbPY/ae8K?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oTHK9hNhQT4giCg0Sm4C5xH1tNP1PYkRlKz0wabrp5jdq10y7blCo2zilPjz?=
 =?us-ascii?Q?uqrQxeotbNRoCr5z0JuVIXHg31d2SFyNQmQsPu6GwCQrj2nw7S0WE9tFxKht?=
 =?us-ascii?Q?6qlESzXZBBp2MNhAxKn0yRmlItfcB9JfAtbihDgGjDl2+TAfC9w8ET5eQKGG?=
 =?us-ascii?Q?5fXCyTAWjqn4t4JVowZz/sD7L8CWbM2+w98nSNali04TTLgBD/ucZUzBnmKs?=
 =?us-ascii?Q?mYPlB0Y+nzzW/qGSAYdsJR9P+ecUVTJxbqNHftcWi/Kbb0cJm1Rupd32tIix?=
 =?us-ascii?Q?eC0w0tUYeiwyhQaLQRVv1j4aYsuB27LhR1cgLa7y+IFhXw8+qqcOfRNPY2X3?=
 =?us-ascii?Q?7QHhDqDqrMfMTt1izYddpAQCg0N6HsAMOJhL/U23sJJpbo1GiPesEM/irweG?=
 =?us-ascii?Q?86dxQdNjQ4uin8oLc5Lx5LOiZduBng8b2BrrNr35FMCG0TqZGxDmH01n6Sw5?=
 =?us-ascii?Q?9YBPneb4AExzMfprZbdV31skigVOgLygyQ7hI0GcvreHIrsefXR6vltGhYzG?=
 =?us-ascii?Q?WXnDEb9kZ3WQkTYFAe/J4B6RmvWJ66tXqCRfJNkl/1HFtnKtQsYaszwZp/tt?=
 =?us-ascii?Q?nGXRsxytT2r9jiYVAPYUJ4NKjp+TFq12eiclPqxNhLCQz/7Kvuo6ssHol8nP?=
 =?us-ascii?Q?KjF3X3Xp/Nv9hp9TZKWvLSmZNf6I29YvKyjbBfHg8rtfSaXvqnpwtnQ8Z55/?=
 =?us-ascii?Q?6HVgtvd5YNjY2NqHPgHn4j7rppvPqT4kbfzUgIQnFDF63t6KJCHsY8EEISC6?=
 =?us-ascii?Q?m5m8bSWdwMwMrUUF/XhZVKPLa4w4SAy1HhszvkXtQgl2fLTl/8HIIdsLBrj/?=
 =?us-ascii?Q?4ZdU1vH8v6GL3U8Bgr8iAWByZaIN5ls2MGeZIjHEpcEcRRpQj2LLaTsAPuzx?=
 =?us-ascii?Q?STc1Wiyt+62zmaIQxsyQ957UZqlqaHc4B6gFBJFgsOGNiT1SjlgB5I1qFtZK?=
 =?us-ascii?Q?9CVaIKvHI3mN0qEPotGAXK91v2sJCg4ISFIp8V65nB6xLujtSnkRXRUh/i6H?=
 =?us-ascii?Q?c+u4fCjNugwAmBGMsqWCroJ9SS7Ni/koikJxwQ8DcX3Lrp+OHE3guJEIerbC?=
 =?us-ascii?Q?mq2NBJUX2RWu8chl/6QWm8Njtzu64ID1kle+TNlxdUQcWGgrr4r9wUEaySkF?=
 =?us-ascii?Q?iYs3gWVym2Fwz5Xr+8IPphHYPB40cB91SOetJdbI45uQueC0erZG7YdCilCz?=
 =?us-ascii?Q?xcqrptZfihNyrGPN3eH97Uy6QheeWXsOXZyKeAP8QiEcoMac7oPGieZakNf0?=
 =?us-ascii?Q?hDEXUuWPqGFmFGtQk60xWc2dcprncn/MmEk+YDYlC5gGqIOZIJ5+nO9wzRT0?=
 =?us-ascii?Q?LMSEnQUF+W5VjLgp3X2TBPueJpRC8LzoS0o5IYA71vh2evVfVzDtXFUOf7u6?=
 =?us-ascii?Q?twBHLNpIO4f3hnZH6RQAkOW0eZVH6w95W4pcxYplW/z93aMxIM/a/UN/Tlv1?=
 =?us-ascii?Q?8hyuiLHz3WdXF4YAXWqQ2z9h+RdS6AlXWrcYLMLAvsYVaGrsKYABd4AZt1wi?=
 =?us-ascii?Q?+TgDFQbJmiq4caY72rxPxvNtSAPeGVJDzVNtibKyhG+tgtvXd8ksFWXHZZvI?=
 =?us-ascii?Q?gNgIpi2NrRPBjmM/ReuihInMhGVzgYgOevZWDsnB?=
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
	zQuQIZBZTujibTG85K1/2weKNQQRo6MqsPWoY4pp8fEFNvrrCwuu6CG/p/LNZfv9YcIgOCLeUt7szk8LvNkR0mNRtrMdx8P9TYtTzh9ZmGma5jK5a1V1qO3oUBrxi81mQoXA20uVcC/G9g2jvVxGMpuvDJMlQYkgUqfcjJTnDOxxTVEI46HnIvQNUjcOt7XZ6B5CYlcSNwfnmnre+saMQEM1Q1Phfkk7WgN4qtJyPlxhfasZqPI29Haer/jjrHIsgNhHkJ4+i0MsgSuATeHRmj8xP0Y3kQ4WdU2sMmwUe1+s085EveSh4HEUaWdK2WO3bI3xUKyjqRz9DLo7unxRjBGFDNzR6kGe7J5FUvWopgRRF21sGuBVzbR1dIAOAYc/BIeI368IuMUNxpTjSy+4gDvKpj2dEFOnluyaGXqPB1ND99K8KU0TNPES/IXYS09RIt8E8jxJJZZn+4Liq/UMD8mRxmKTD9ayDMeTaEZ5eRPW/lbVGuCFQ9HuSbbAozkJjaWw/yLhtIBAgoOos2OiEhLasFVDY/r6dVuJwe8qLOXrcAhpXSQu9ceM8m1Z8M72tLkWM9hj0G2ZJepptFLlOFWV6YZlwbqhOMU6XJCNEta3ph0CzB0Wi84/Ihw8niAFlQSCxijI6uvU0x8zm7bzoA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c0a2e4-fe50-4588-14a4-08ddfda9cdfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2025 09:39:50.3049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: prHm/EtIOeiz9EK2rPNZ5j2s3xmv9tLVFM01PVMTX0vOAKw/jKLP/LC7lwo1iccMxdlwmiAhJOgRivHBZfbg8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR16MB5141

>=20
> Call ufshcd_init_lrb() from inside ufshcd_setup_dev_cmd() instead of
> ufshcd_host_memory_configure(). This patch prepares for calling
> ufshcd_host_memory_configure() before the information is available that i=
s
> required to call ufshcd_setup_dev_cmd().
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 53 ++++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 7ea18204b5fb..bb14af688e98 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2903,8 +2903,32 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba
> *hba, struct ufshcd_lrb *lrbp)
>         ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);  }
>=20
> -static void __ufshcd_setup_cmd(struct ufshcd_lrb *lrbp, struct scsi_cmnd
> *cmd, u8 lun, int tag)
> +static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb
> +*lrb, int i) {
> +       struct utp_transfer_cmd_desc *cmd_descp =3D
> +               (void *)hba->ucdl_base_addr + i * ufshcd_get_ucd_size(hba=
);
> +       struct utp_transfer_req_desc *utrdlp =3D hba->utrdl_base_addr;
> +       dma_addr_t cmd_desc_element_addr =3D
> +               hba->ucdl_dma_addr + i * ufshcd_get_ucd_size(hba);
> +       u16 response_offset =3D le16_to_cpu(utrdlp[i].response_upiu_offse=
t);
> +       u16 prdt_offset =3D le16_to_cpu(utrdlp[i].prd_table_offset);
> +
> +       lrb->utr_descriptor_ptr =3D utrdlp + i;
> +       lrb->utrd_dma_addr =3D
> +               hba->utrdl_dma_addr + i * sizeof(struct utp_transfer_req_=
desc);
> +       lrb->ucd_req_ptr =3D (struct utp_upiu_req *)cmd_descp->command_up=
iu;
> +       lrb->ucd_req_dma_addr =3D cmd_desc_element_addr;
> +       lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)cmd_descp->response_u=
piu;
> +       lrb->ucd_rsp_dma_addr =3D cmd_desc_element_addr + response_offset=
;
> +       lrb->ucd_prdt_ptr =3D (struct ufshcd_sg_entry *)cmd_descp->prd_ta=
ble;
> +       lrb->ucd_prdt_dma_addr =3D cmd_desc_element_addr + prdt_offset; }
> +
> +static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp,
> +                              struct scsi_cmnd *cmd, u8 lun, int tag)
>  {
> +       ufshcd_init_lrb(hba, lrbp, tag);
> +
>         memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
>=20
>         lrbp->cmd =3D cmd;
> @@ -2916,7 +2940,7 @@ static void __ufshcd_setup_cmd(struct ufshcd_lrb
> *lrbp, struct scsi_cmnd *cmd, u  static void ufshcd_setup_scsi_cmd(struct
> ufs_hba *hba, struct ufshcd_lrb *lrbp,
>                                   struct scsi_cmnd *cmd, u8 lun, int tag)=
  {
> -       __ufshcd_setup_cmd(lrbp, cmd, lun, tag);
> +       __ufshcd_setup_cmd(hba, lrbp, cmd, lun, tag);
>         lrbp->intr_cmd =3D !ufshcd_is_intr_aggr_allowed(hba);
>         lrbp->req_abort_skip =3D false;
>=20
> @@ -2971,27 +2995,6 @@ static void ufshcd_map_queues(struct Scsi_Host
> *shost)
>         }
>  }
>=20
> -static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb,=
 int i) -{
> -       struct utp_transfer_cmd_desc *cmd_descp =3D (void *)hba-
> >ucdl_base_addr +
> -               i * ufshcd_get_ucd_size(hba);
> -       struct utp_transfer_req_desc *utrdlp =3D hba->utrdl_base_addr;
> -       dma_addr_t cmd_desc_element_addr =3D hba->ucdl_dma_addr +
> -               i * ufshcd_get_ucd_size(hba);
> -       u16 response_offset =3D le16_to_cpu(utrdlp[i].response_upiu_offse=
t);
> -       u16 prdt_offset =3D le16_to_cpu(utrdlp[i].prd_table_offset);
> -
> -       lrb->utr_descriptor_ptr =3D utrdlp + i;
> -       lrb->utrd_dma_addr =3D hba->utrdl_dma_addr +
> -               i * sizeof(struct utp_transfer_req_desc);
> -       lrb->ucd_req_ptr =3D (struct utp_upiu_req *)cmd_descp->command_up=
iu;
> -       lrb->ucd_req_dma_addr =3D cmd_desc_element_addr;
> -       lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)cmd_descp->response_u=
piu;
> -       lrb->ucd_rsp_dma_addr =3D cmd_desc_element_addr + response_offset=
;
> -       lrb->ucd_prdt_ptr =3D (struct ufshcd_sg_entry *)cmd_descp->prd_ta=
ble;
> -       lrb->ucd_prdt_dma_addr =3D cmd_desc_element_addr + prdt_offset;
> -}
> -
>  /**
>   * ufshcd_queuecommand - main entry point for SCSI requests
>   * @host: SCSI host pointer
> @@ -3084,7 +3087,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)  static void ufshcd_setup_dev_cmd(struct
> ufs_hba *hba, struct ufshcd_lrb *lrbp,
>                              enum dev_cmd_type cmd_type, u8 lun, int tag)=
  {
> -       __ufshcd_setup_cmd(lrbp, NULL, lun, tag);
> +       __ufshcd_setup_cmd(hba, lrbp, NULL, lun, tag);
>         lrbp->intr_cmd =3D true; /* No interrupt aggregation */
>         hba->dev_cmd.type =3D cmd_type;
>  }
> @@ -4042,8 +4045,6 @@ static void ufshcd_host_memory_configure(struct
> ufs_hba *hba)
>                         utrdlp[i].response_upiu_length =3D
>                                 cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
>                 }
> -
> -               ufshcd_init_lrb(hba, &hba->lrb[i], i);
>         }
>  }

