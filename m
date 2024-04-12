Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F07286AC
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712913264; cv=fail; b=L+5QAJpERMSRNzhtN0A9VT4XiSI0Z+M9DJzT4y0jAESdO5WGFqQM+kKfhlu9jlfo01JzlgS4ldEBrhhFvkr0V7mqQ40TA+aYFJQ3oDgWfV7BMfu01wNp+RSmq6D1VzKEckNdrZ8Dg5MatBo8WzTqkQ+4tq9zPn3Lpfs1slrdBP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712913264; c=relaxed/simple;
	bh=SFmdW/DEmJhjlFdCjwjBd7NCn1VD0tuN+dIpznyoPaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CTgf/IO9JQF1VdQcF4KvJz7k0wkvgAvdBIBcU0EifNndEeuciUlMKfowXg1HVR1jjaV6fRrSWkA/kXb2aMmivE4aCXz3iK1UdEhGFILd9aVbzuVUOqy0l/9JIwIzCZQXbiK1bfPX1QlmguY7I6FnvmA4H2FjM22tvSr15hJ4O9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QJL0xF88; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rw/Pknfy; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QJL0xF88";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rw/Pknfy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712913262; x=1744449262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SFmdW/DEmJhjlFdCjwjBd7NCn1VD0tuN+dIpznyoPaE=;
  b=QJL0xF88+8jTP3g+vcHk+dSHlawckDe1uGYXKjxB204jO5RS/UzbZmsD
   FuehX6YJgZ1fgtNrNY20le1CL1s1L+6uyNNaudvXVjwra6OOp1XbYH1w+
   xU1F5nOp65RqgVOJos6LSgw4TzHeyh6su/C2LvdEeIBXpyF1P2GzhFjJP
   G6ayU88eoMepJLwFhDNjME1iLWKv/RHrY2EnaG1R8ST2Qcvy3Ky4SLj2z
   dgJuYnKk9Lh/TyiKGCNXAM2X0rGdF8hmY0xdXuDzDW/7T2b9LH+S5NCXC
   EXd3PRqBpo1Nrn5VaPUkOqkTU8gSYHDN1Km+bFiCv/U+oUVnc9aPa+mGo
   w==;
X-CSE-ConnectionGUID: g12L7x4mTIeURSgeeJ26BQ==
X-CSE-MsgGUID: 6QoV28U7QmC4bacV6EZAug==
X-IronPort-AV: E=Sophos;i="6.07,195,1708358400"; 
   d="scan'208";a="13844044"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2024 17:14:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+4hnZb7pzN3HWiInQA4eAb1pgHleDl2iQ8HK/8en/wqO4xln+bgcY/kuPFzOWsR255P0Yt9hMHlILmaFc4O3kyxxVXvqAyUrZpc63Yx49oZ2nrLQz4uxaj6m5n99mH3BOZCUjylZKbdQcPZfkG3grDPDubrb73FUZUAqef+mtiG9ixzBmGDM/n6s1BN19neRjE/VoCNu1VJNGK+VRSyFF2CJPikZ0Q89eWmkihZPza7nywGZ6x/J7MxnRfHG8G458rGhXZj+XDhbXk5XZeZvZPb/3cv2+vKL5O6lI60tNTQ9FMHCuf4xKPxAVYzmPeW+LMuNOvh369iBhHlmXROMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8i5tb7NRJOUjWBgAZLIJlzmtN656fSQG0dVC7M9M+Yk=;
 b=YOVJ3HkKLja88QEc3idPHE0qYz/AGWJZPUcwfuaNTGZfNOfDXpsIm+JSrhzL348Ffy0nHEmlLiE5GbZ8PSFofscz6yxumLfSEMXZ5wp4QuPb2HjLiPYrzqdFwJIg2UX2+pVP5lgJA8ACU01cTtkLnHloFr2hmb2RMfhyCnn9G/Hwz1Xt+LCSTf/sVHuVpyrwOgMP4gYvJXBL1ks0C43cpdpcSJEDFFLNcFRCRfSOWL9bkv1aZick6Zi9YyXks3T45UNB6fVPu4Q0lGh0TKiDXnPfirKGuUipCNIBff8hRa4SfX7a2VYoJ3Zumu8mYqrTunbHyXVmedXsVWgPpMJO/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i5tb7NRJOUjWBgAZLIJlzmtN656fSQG0dVC7M9M+Yk=;
 b=rw/PknfyitkcsTODuxKq10q7qmGdketncnFWRbnD33Lq5SswURmXczHAZ184PUpyNNJaIo0RDLRiV0f7ZNLDcNiLpBmMOTX9tpsehm4ssu6dXMRRoTvrnwNY4qe3QX2UVTgGQ1JqKzvtP+anWmFJSxVgbzyFkHKDAErg9i1Bi/M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6313.namprd04.prod.outlook.com (2603:10b6:5:1e5::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Fri, 12 Apr 2024 09:14:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7409.053; Fri, 12 Apr 2024
 09:14:18 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>, Stanley Jhu
	<chu.stanley@gmail.com>, Po-Wen Kao <powen.kao@mediatek.com>, Can Guo
	<quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, ChanWoo
 Lee <cw9316.lee@samsung.com>, Yang Li <yang.lee@linux.alibaba.com>, zhanghui
	<zhanghui31@xiaomi.com>, Keoseong Park <keosung.park@samsung.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>, Maramaina Naresh
	<quic_mnaresh@quicinc.com>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: RE: [PATCH 3/4] scsi: ufs: Make the polling code report which command
 has been completed
Thread-Topic: [PATCH 3/4] scsi: ufs: Make the polling code report which
 command has been completed
Thread-Index: AQHajGzmBkHd1l3FvEahZp3YizHLU7FkWhjg
Date: Fri, 12 Apr 2024 09:14:18 +0000
Message-ID:
 <DM6PR04MB6575F0D8B742E1328E73CB97FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
 <20240412000246.1167600-4-bvanassche@acm.org>
In-Reply-To: <20240412000246.1167600-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6313:EE_
x-ms-office365-filtering-correlation-id: bf005329-bd4b-41f3-7a8f-08dc5ad0ee82
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 VtlRc0d5BlkXNrvEiUIgImJISe9rL0ZXv5WfGnl1Iuw3LD1SnfrNlG+nd+ayOha3rI7fGkeKe7oFij1kXnM4tBd0MwlqVy2Ufxan6Hp0qKkC/KMLfC+pqQ9ai9OqYSBxNio6UlGJNd54FHQ+RqDfodGwD1D1UT4GeO0u9ecdsMIeiE/5n24P7sZFIgWWbeJjqYfdsHyEH5cnjyOgWhf0jli1brtTWB6ef5V3sUNu+0Bz/KTSdWsAd68ybOwMCnE9nvrndHXz39zYEx8/IG3aZ/riL9Tk0Fwsg8N9tZ7ncFFcvq/uzgP5zbQKepuQfBmT6nf0xX7YEezOre4dPhqajCi9q6076MYLl+HGPMKZdI1ql5l2kD26Y1pZ1RCN0DJJyZShZzKbxe8Gh+xl4Qd4iU+459mrPm/sD1lyMSMCWpCsJ1mBqWJOSB+lRGh+mVfW80p6n+b1ispaV1iBSTsY/UqpkOzrJ1SM5qVnBpzMYm1K0cr+eVntVpC2ZN5E8y6ymbZAJN/tqHror9HO29VYIRCaKxGUyc31XIuOy9DJfFTPgjyQ8GYQjj9wb/hXcWY6V5AwUFBrvVKNAtgjaldbccuDSfVAfkEyp7U9oSwhkXwb5StQ1E0zFZdp2DeamBZsvYc7dXbzRnUdLL9YLOg/xTbohjnyszTxiWmHMa434PX1ThzDKBebYVNPb2BFqLDNJfTYX2IrSMujEunyz8JaEdxi5qqs/AgwZwGHwNzgG/8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xB2f8iz+y1+3Cv2RPoe8DFCvlExvRcHfoivOArSIrd7tkydDZ7f269YBesgz?=
 =?us-ascii?Q?Y//e4Sh1OTNQQN+07/DwPecRJpG0hihlxqU89CLpgjNC7KuBabcQsOPma4b1?=
 =?us-ascii?Q?5Y6hVb2mBV8qZssCaPgfr/w98z/veMSD0nQx17yp7T75DxjW06LgHGtnTYYf?=
 =?us-ascii?Q?J0MuPM7ZRM8m+6l3hV1pG/MlNLzGT1pGiSJQbpzbOYtb3JuZerKAL3mMwjsZ?=
 =?us-ascii?Q?Z4moc/j/AAab7mpEBsx77OB3fu56PLEzx/lZKjJz1IjP3KwnimflFtiVcEyD?=
 =?us-ascii?Q?KtuCF/zVhcNX7wa08CwTwDTyEk2YTGiWgqv+YkYB6ZVuTalgpqpw4QNQyLEs?=
 =?us-ascii?Q?Zn3FiNmBhq7DvwaQLpAWCU6x0cnLZcgRCFLtD6D9Q0jUnOKzqap0mmzzrwLV?=
 =?us-ascii?Q?Cj/b29efg2bTCCMjYnOj8gSoyN9nZeFZswFZajdh9261TaKy8hEeZB735NNs?=
 =?us-ascii?Q?QdQTOVT3Nm2M9v6jYY8d91lszeejT22Kc4m5pLcMbVovoBle+v3Ed/k5O457?=
 =?us-ascii?Q?G/I3DfjcExmW9pwSG+U0673uq5TsFXOraGm/ipP31yHQKlOsR0ONqbdDIeR8?=
 =?us-ascii?Q?MHTHm9HRLHd4kYRU5oExeFWoI2112I8RZtTsYKz8R67mK08eL/UhCAG4UmpR?=
 =?us-ascii?Q?onU7xpxcnD17ZE86AsLBRtr8fBzO00jfArNNNsUTnv2aJKDOJaLZaoKkbl8B?=
 =?us-ascii?Q?fZrnURNbDHlEJKg3cyc7PZxU+tZILkF5DPie9a5uUaz8kY8Y8gaE6pdgbuQ6?=
 =?us-ascii?Q?Dq3B6INjR9Ea+jv68wKndiQ2oNrc6cmrODc9cvj8gbGuOLmoImv4Dcciuw8m?=
 =?us-ascii?Q?JYuX7A+9FLkKR/8+ZG1S8/OSP2yImPCJibfi5aLNO0ieCTCJWpFgFQ6TQIoc?=
 =?us-ascii?Q?JXSAcyBjFQUd4FMLtMZfkSmx+XyCSTAa3Ftlc44/F6eEQmCidb1Qt6DAnBcm?=
 =?us-ascii?Q?dAcx3RVIEqphMpMmawiamadCeUZcsHCYAo87DCDhzuWkB6Y2nmY6CuUy41Wa?=
 =?us-ascii?Q?LyKVqqzqZBBLtDbwyPgfAHvMkmBh1yLdhYTLqi/y9vQEe5ZGGw1nu/lfFE4V?=
 =?us-ascii?Q?3th6EMIMhNA+PINz4N+98akpy/OxD/nA4XqIVaprzHaq5MlOBFkMPFagJ+eX?=
 =?us-ascii?Q?AsALPOD18kU1QymQ4YiiiN+iPiMRJFMlyqhbNiO8JPnnYCgoaO6ZllN3ubLh?=
 =?us-ascii?Q?HWpMOOdydbyD71Ys/lI7nWNw2i777zoVfWba90rB3bAdr38awGqm0f/0KcAH?=
 =?us-ascii?Q?xIlnWBjY1AH1J0qRzivYgEH8ZyisPSUFvOoJh184pmw++O4fFI75wRiDhpqa?=
 =?us-ascii?Q?IXBW11nshFbu2rql4xdR0ngoZ05G5RU78qP6nvVUwZeLk8C46R4EA0vd0nVI?=
 =?us-ascii?Q?6+Ff9B68cWVjmDLNosRV0l50BtfX3PWOlQzEm33UyIDoTu+K84blOAadDBqV?=
 =?us-ascii?Q?KbcJzZ177AMJG18Sbwre6Phr34gxnjM82o0Y7+Te1FZU/UXmPIxM3IepS6Bh?=
 =?us-ascii?Q?4evT7zlwqQudUkJEHoFGK/s4XDBmUQMofLW9gyvqYQEzW3RyR/Zzob4A7GTQ?=
 =?us-ascii?Q?8+vzR4gl4qrz575210HZxZNaK/632Frq5BTzcoM/?=
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
	BENBOlDhV8BUxuNS0XTse1OCkpZIun15isd+7QRob0mXKYeyBacE/YmsPzqLKnFk3jLFNX7tM2S52MReH0VKk5NPD0Ag5sLYOLZAN6ZU0YgGKqmIZlOAewoFr3wyaO6IYYPNr+2eos9M7vOgDQ6k/3PApLMri/mfS9zYth5jNVrv9GHGFEAsRHVR5IGHap/jGmxjJ4j4f0W8YQHn0sV9Cn5a2WWXSJE54eeTkiy0w2Ne3LVFVnJzDZhvK/2RPgPXGOnceu9gBBma0UGXEcVvLzeG28nPyuI+A6AtpTENCP84lsNLUiEoCr88M8bD8ODEc/xr/PYOo7RRYC2NHOpCpB9LCENRBt/CTCElb1spBNrIrljpxarDPUxxnJa7GEPzFfpTKqIDyAH68n2qr1mBGoe9f/RGuLMg2y0k6rsan5VwEPIajkuDij57blupAiqIfYHYkUpSyTG8/cl4XEfpdNo58VytxSdliwKK0aW8s3as7ZOZx+1LfJ3IciQSLi1WqLg7+IWOn/d5P4xVBQObSyLlzvBvim5+b2Izga9wwA6TpfrNLpl12flRYV28e24DccxGYy/XluMaJzDcjkcuK+piT/ik85e4Znfac5wkh+foDMvSZd2yDZzZ3Fwiot9c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf005329-bd4b-41f3-7a8f-08dc5ad0ee82
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:14:18.0783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uG1g1MP97kqxU+MUiavLRDexaUxkQeTh4TO1+ktrgMKsI+76Wr/P2ZnQTmyWnujIPRP6wdxIS+redyM2TxPKew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6313

> Prepare for introducing a new __ufshcd_poll() caller that will need to
> know whether or not a specific command has been completed.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufs-mcq.c     | 23 +++++++++++++-------
>  drivers/ufs/core/ufshcd-priv.h |  4 ++--
>  drivers/ufs/core/ufshcd.c      | 39 +++++++++++++++++++++++-----------
>  drivers/ufs/host/ufs-qcom.c    |  2 +-
>  include/ufs/ufshcd.h           |  3 ++-
>  5 files changed, 47 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 228975caf68e..5a02e1b3b3a5 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -268,17 +268,20 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba,
> struct cq_entry *cqe)
>         return div_u64(addr, ufshcd_get_ucd_size(hba));
>  }
>=20
> -static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
> -                                  struct ufs_hw_queue *hwq)
> +/* Returns true if and only if @compl_cmd has been completed. */
> +static bool ufshcd_mcq_process_cqe(struct ufs_hba *hba,
> +                                  struct ufs_hw_queue *hwq,
> +                                  struct scsi_cmnd *compl_cmd)
>  {
>         struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
> -       int tag =3D ufshcd_mcq_get_tag(hba, cqe);
>=20
>         if (cqe->command_desc_base_addr) {
> -               ufshcd_compl_one_cqe(hba, tag, cqe);
> -               /* After processed the cqe, mark it empty (invalid) entry=
 */
> +               const int tag =3D ufshcd_mcq_get_tag(hba, cqe);
> +               /* Mark the CQE as invalid. */
>                 cqe->command_desc_base_addr =3D 0;
> +               return ufshcd_compl_one_cqe(hba, tag, cqe, compl_cmd);
>         }
> +       return false;
>  }
Maybe elaborate on explaining why the tag isn't enough to designate the com=
pleting command?

Thanks,
Avri



>=20
>  void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
> @@ -289,7 +292,7 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba
> *hba,
>=20
>         spin_lock_irqsave(&hwq->cq_lock, flags);
>         while (entries > 0) {
> -               ufshcd_mcq_process_cqe(hba, hwq);
> +               ufshcd_mcq_process_cqe(hba, hwq, NULL);
>                 ufshcd_mcq_inc_cq_head_slot(hwq);
>                 entries--;
>         }
> @@ -299,8 +302,10 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba
> *hba,
>         spin_unlock_irqrestore(&hwq->cq_lock, flags);
>  }
>=20
> +/* Clears *@compl_cmd if and only if *@compl_cmd has been completed. */
>  unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> -                                      struct ufs_hw_queue *hwq)
> +                                      struct ufs_hw_queue *hwq,
> +                                      struct scsi_cmnd **compl_cmd)
>  {
>         unsigned long completed_reqs =3D 0;
>         unsigned long flags;
> @@ -308,7 +313,9 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct
> ufs_hba *hba,
>         spin_lock_irqsave(&hwq->cq_lock, flags);
>         ufshcd_mcq_update_cq_tail_slot(hwq);
>         while (!ufshcd_mcq_is_cq_empty(hwq)) {
> -               ufshcd_mcq_process_cqe(hba, hwq);
> +               if (ufshcd_mcq_process_cqe(hba, hwq,
> +                                          compl_cmd ? *compl_cmd : NULL)=
)
> +                       *compl_cmd =3D NULL;
>                 ufshcd_mcq_inc_cq_head_slot(hwq);
>                 completed_reqs++;
>         }
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index fb4457a84d11..42802fd689fb 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -61,8 +61,8 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum
> query_opcode opcode,
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
>         enum flag_idn idn, u8 index, bool *flag_res);
>  void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
> -void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
> -                         struct cq_entry *cqe);
> +bool ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
> +                         struct cq_entry *cqe, struct scsi_cmnd *compl_c=
md);
>  int ufshcd_mcq_init(struct ufs_hba *hba);
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
>  int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 66198eee51b0..08abdd763c51 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5540,9 +5540,12 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>   * @hba: per adapter instance
>   * @task_tag: the task tag of the request to be completed
>   * @cqe: pointer to the completion queue entry
> + * @compl_cmd: if not NULL, check whether this command has been
> completed
> + *
> + * Returns: true if and only if @compl_cmd has been completed.
>   */
> -void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
> -                         struct cq_entry *cqe)
> +bool ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
> +                         struct cq_entry *cqe, struct scsi_cmnd *compl_c=
md)
>  {
>         struct ufshcd_lrb *lrbp;
>         struct scsi_cmnd *cmd;
> @@ -5559,6 +5562,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int
> task_tag,
>                 ufshcd_release_scsi_cmd(hba, lrbp);
>                 /* Do not touch lrbp after scsi done */
>                 scsi_done(cmd);
> +               return cmd =3D=3D compl_cmd;
>         } else if (lrbp->command_type =3D=3D UTP_CMD_TYPE_DEV_MANAGE ||
>                    lrbp->command_type =3D=3D UTP_CMD_TYPE_UFS_STORAGE) {
>                 if (hba->dev_cmd.complete) {
> @@ -5569,6 +5573,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int
> task_tag,
>                         complete(hba->dev_cmd.complete);
>                 }
>         }
> +       return false;
>  }
>=20
>  /**
> @@ -5577,12 +5582,15 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba,
> int task_tag,
>   * @completed_reqs: bitmask that indicates which requests to complete
>   */
>  static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
> -                                       unsigned long completed_reqs)
> +                                       unsigned long completed_reqs,
> +                                       struct scsi_cmnd **compl_cmd)
>  {
>         int tag;
>=20
>         for_each_set_bit(tag, &completed_reqs, hba->nutrs)
> -               ufshcd_compl_one_cqe(hba, tag, NULL);
> +               if (ufshcd_compl_one_cqe(hba, tag, NULL,
> +                                        compl_cmd ? *compl_cmd : NULL))
> +                       *compl_cmd =3D NULL;
>  }
>=20
>  /* Any value that is not an existing queue number is fine for this const=
ant. */
> @@ -5609,7 +5617,8 @@ static void ufshcd_clear_polled(struct ufs_hba *hba=
,
>   * Return: > 0 if one or more commands have been completed or 0 if no
>   * requests have been completed.
>   */
> -static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
> +static int __ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num=
,
> +                        struct scsi_cmnd **compl_cmd)
>  {
>         struct ufs_hba *hba =3D shost_priv(shost);
>         unsigned long completed_reqs, flags;
> @@ -5620,7 +5629,7 @@ static int ufshcd_poll(struct Scsi_Host *shost,
> unsigned int queue_num)
>                 WARN_ON_ONCE(queue_num =3D=3D
> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
>                 hwq =3D &hba->uhq[queue_num];
>=20
> -               return ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +               return ufshcd_mcq_poll_cqe_lock(hba, hwq, compl_cmd);
>         }
>=20
>         spin_lock_irqsave(&hba->outstanding_lock, flags);
> @@ -5637,11 +5646,16 @@ static int ufshcd_poll(struct Scsi_Host *shost,
> unsigned int queue_num)
>         spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>=20
>         if (completed_reqs)
> -               __ufshcd_transfer_req_compl(hba, completed_reqs);
> +               __ufshcd_transfer_req_compl(hba, completed_reqs, compl_cm=
d);
>=20
>         return completed_reqs !=3D 0;
>  }
>=20
> +static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
> +{
> +       return __ufshcd_poll(shost, queue_num, NULL);
> +}
> +
>  /**
>   * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
>   * invoked from the error handler context or ufshcd_host_reset_and_resto=
re()
> @@ -5685,7 +5699,7 @@ static void
> ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
>                         }
>                         spin_unlock_irqrestore(&hwq->cq_lock, flags);
>                 } else {
> -                       ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +                       ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
>                 }
>         }
>  }
> @@ -6960,7 +6974,7 @@ static irqreturn_t
> ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
>                         ufshcd_mcq_write_cqis(hba, events, i);
>=20
>                 if (events & UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS)
> -                       ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +                       ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
>         }
>=20
>         return IRQ_HANDLED;
> @@ -7453,7 +7467,7 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)
>                             lrbp->lun =3D=3D lun) {
>                                 ufshcd_clear_cmd(hba, pos);
>                                 hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_c=
md_to_rq(lrbp-
> >cmd));
> -                               ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +                               ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
>                         }
>                 }
>                 err =3D 0;
> @@ -7481,7 +7495,8 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)
>                                 __func__, pos);
>                 }
>         }
> -       __ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask=
);
> +       __ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask=
,
> +                                   NULL);
>=20
>  out:
>         hba->req_abort_count =3D 0;
> @@ -7658,7 +7673,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                 dev_err(hba->dev,
>                 "%s: cmd was completed, but without a notifying intr, tag=
 =3D %d",
>                 __func__, tag);
> -               __ufshcd_transfer_req_compl(hba, 1UL << tag);
> +               __ufshcd_transfer_req_compl(hba, 1UL << tag, NULL);
>                 goto release;
>         }
>=20
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index b3ca9b3bf94b..0598cd8f53dd 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1704,7 +1704,7 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq=
,
> void *data)
>         struct ufs_hw_queue *hwq =3D &hba->uhq[id];
>=20
>         ufshcd_mcq_write_cqis(hba, 0x1, id);
> -       ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +       ufshcd_mcq_poll_cqe_lock(hba, hwq, NULL);
>=20
>         return IRQ_HANDLED;
>  }
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 4ba826fe7b62..8fac282e0476 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1263,7 +1263,8 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba,
> u32 max_active_cmds);
>  u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
>  void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
>  unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> -                                        struct ufs_hw_queue *hwq);
> +                                      struct ufs_hw_queue *hwq,
> +                                      struct scsi_cmnd **compl_cmd);
>  void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
>  void ufshcd_mcq_enable_esi(struct ufs_hba *hba);
>  void ufshcd_mcq_enable(struct ufs_hba *hba);
