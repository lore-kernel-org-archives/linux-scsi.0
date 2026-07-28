Received: from OS5P279CU001.outbound.protection.outlook.com (mail-norwayeastazon11022138.outbound.protection.outlook.com [40.107.158.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF01A442FAA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.158.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785246200; cv=fail; b=GXQv9/a84utyZCvavDG9kgbZcU6cp/jE8AxV7hLz8884YCX/S4bKwEVvVF98c4iGLVTRBOzWLMT+MTP9NWMwD1BxG2vt6u0aw76vAdjuAtqE6FPAuxi0J9PdlssyyhnVFLZdRArdJ4aTh2laIsqBzNCftnL4tTdRyw2n28owrjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785246200; c=relaxed/simple;
	bh=DEE0Njye+MpQC5mwIMvR0gcAdoNasbT380H4zlc1OaQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=afJt+B0skmNmyJnlC9a9lH/CNbGenqDoPUyRxtGnziu/b9+WqgVnjd7Lkcn+HiYw70aXqvkdIq7yvlUpqB72W49QA5SssYEsXQhfp4fX5D+2lLThhDRdMiDQpk2EzsaxYSRDqFpBBBOGNbJpb71lGkzf5Xx1/1sxvoZ4JDh6R78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=intility.no; spf=pass smtp.mailfrom=intility.no; dkim=pass (1024-bit key) header.d=intility.no header.i=@intility.no header.b=NsFSacPW; arc=fail smtp.client-ip=40.107.158.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=intility.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intility.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=intility.no header.i=@intility.no header.b="NsFSacPW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBaDWD7Lv+z0gLnh0JdLZsXj0WHqPEVcTzIWavFsbaT2NoLiC6YnlX+O8sX3PFjOa7gUgi7VtOTZ51XwRojd5BV9vW5SKZWh9/X6a0qzAlB7J3Qfmar3Rbuyu/PAC4TiP0zTq+YsOxXdGKymlBQbNxB4eBsicGzsgxsrjQKTGgBNcRM+2uUsWziF03Enw70Xn4GyPTded3Z9kxyL18eM44WJoHoWxii3I6DFik3NluU5VBGM7kShnZ+axwML8U2+e+FamQ7fDxSkgxqKDbBTGWA2FRTYaQh+csaGAgNiGkiqtSLZbJMzN0tVVnnAjGVKy6N6ODEWbpgL92HWQcCy8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TaMWIJFtMNHXBzHvkNgDZ0Q18rmmNnVpV9cN3OkWqgM=;
 b=rU2ILLp1zFtk+WQaWYU0Yu52ram/TRSTze23ehM/aoER7hMArVRGGkM3LJJFHbf8uVEjAQOy7YKrAP24qcQwepONixlX08A3qOyL0+PYkkDQgoL8xdhhciUlZIufiDIEcLFOyTcSxMQREJvPX3OWaHBWtkHBgpavsWD40FeWOtEi2qWKliI2qOtxfPHSct+4aPo1sawCg5aSJFheDuIOWVNv6fBisHSMAuRVchHJq9o0OoPdaPRFCxa99KT0C3+8bOudmzvJzwAJlo61y5dhPv3ZJDQbmuBIWMg/OpT+QPJVbSsIjx8BFa94hcd12TOAFxLzGk3l3Vc9WQndxWGKIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intility.no; dmarc=pass action=none header.from=intility.no;
 dkim=pass header.d=intility.no; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intility.no;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaMWIJFtMNHXBzHvkNgDZ0Q18rmmNnVpV9cN3OkWqgM=;
 b=NsFSacPWRLGnkl6I1JGkWHHPHKOCnalbr3aOJRXeiWWeVtxVDEZEJljkKp0cQtUWMGcOuRcF0/qgAM1QB+FWlngX5tdpCK07mb6jE9R0n4ywy+f+jB2tjffU527k+XeaTfIMK3gDkspuX1Z02e8UaX2/zZbY/VxqCd2N3zrp6kU=
Received: from SV0P279MB0105.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:b::10) by
 OL1P279MB0002.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:10::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Tue, 28 Jul 2026 13:43:10 +0000
Received: from SV0P279MB0105.NORP279.PROD.OUTLOOK.COM
 ([fe80::8a8b:563d:c6df:ba43]) by SV0P279MB0105.NORP279.PROD.OUTLOOK.COM
 ([fe80::8a8b:563d:c6df:ba43%5]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 13:43:09 +0000
From: Mats Topstad / Intility AS <Mats.topstad@intility.no>
To: Daniel Fernau <mail@danielfernau.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, Thorsten Leemhuis
	<regressions@leemhuis.info>, "me@magik.net" <me@magik.net>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
Thread-Topic: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
Thread-Index: AQHdCHr1a5nXUO6qz0KZI2aX9dis4LZqymolgAE78ACAFxaxgA==
Date: Tue, 28 Jul 2026 13:43:09 +0000
Message-ID: <9900ABF6-01C5-4B9B-BEF3-BAB5A18C3F54@intility.no>
References:
 <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
 <yq15x5lowt9.fsf@ca-mkp.ca.oracle.com>
 <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info>
 <yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com>
 <YKopBh5zwX7tXjDOqU7R0K9CQfVpd3r9_baFGNLwcZGgb4m0cddKjzuQwp0lWZJqixIfpiHm9YwjQfRvNJjBZwl1PaqtuuuCd7dJ4lmirSY=@danielfernau.com>
In-Reply-To:
 <YKopBh5zwX7tXjDOqU7R0K9CQfVpd3r9_baFGNLwcZGgb4m0cddKjzuQwp0lWZJqixIfpiHm9YwjQfRvNJjBZwl1PaqtuuuCd7dJ4lmirSY=@danielfernau.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intility.no;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SV0P279MB0105:EE_|OL1P279MB0002:EE_
x-ms-office365-filtering-correlation-id: dc6a5074-9c5f-45c2-4fcd-08deecae297d
x-intilityrouting: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|10070799003|11063799006|4143699003|10067099003|6133799003|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 nEDyPfpyBMFiZN04ZUeRqHQnzocv5LaMyChOrKLqjWgEyYX7hcGVMGMidAkXX0E0PVClkb4Ej/jgERBjeMsFAyJdiRDg7A1p5VvSBLNP+KaWgMXiifWc2O4CU2o/3ZCHnArNCNdcqKKREZiIeCo43/57IEwVIJArVKaxNUBvQnt+GIDVhwQ5ak8msXsnUqUb8gfCbRH+BTb/B7kpr7P9dy/h6+JGAgWvX6JSdPed39CMTSsEgf3rHqxlWBwqbi++Mcz73fdmYmTiY83vZqGFmGEtPPt7CDti7XGxE5o76mjkcwA3EUovlPVCOjdUDgGhOJTJn500onLiG1sD/DikD/+GVci5u6tL8XfEi88+6UIlFVW3gqVQVbljS1VNjzbEo2yXRxSKWGbHvcblApe9A8RHGpQvg99f3CivRoTB58PTf3j8Cj/qj1dvvIquJrJiHOc4g9EkGLZ4lRy3msDuZVGO/91STnb826o8qxdQSw9EdXKrfWKXBWAfXhQtR4S0+OipWPhsVkpdF/FM9WrEAkKb1Aij7nthjN9ksk9XSMKbNiXdKae8mQw2KQCXTvUUVsn2wct0Iyx6SaEhgMb1r1qHcZpsPORkjcsQoSwqq3U6Xaxmg8jrrYtRjE/7t341dHCIYNrFtUg6c95jIGkM0XNEKO7PNgu5u1JHUShCteT06u7GzaOM9LkwcjSxOUaA5CQqWOlyY6GJJYibj7LIEt7Ko5UltBHhZbmgl0pqfiw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SV0P279MB0105.NORP279.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(10070799003)(11063799006)(4143699003)(10067099003)(6133799003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1EBeGhd20iqvgDok2AeEuKLBDG0/2y2mrqphB2hvsN6uOof5MqiBnvdHQJ5L?=
 =?us-ascii?Q?uPmJUlYYAASpx6aWE6ZlsfJs/Hu583FAStX9evC3NId+LZk2xI1T3XS9lkMd?=
 =?us-ascii?Q?2KJuxD7yPgZONtOZLECTnfGe/fVTpsPRVg9vTNjPHa6P+fH4WaOIBCVRE9g4?=
 =?us-ascii?Q?5UsnT21E7dcYE/lmqtejNS4fS/ksaJ8TWgRNU3/t0xsWJ2ShBjP/wHXKbSgr?=
 =?us-ascii?Q?j5Ag+vlsDLhva1se6dpbFniTOInz0Ve742U8SZZ0Pwcipm6i55/bEZ7U6NhW?=
 =?us-ascii?Q?CrGCRdBxdy5qWjzIcQZreAAlpRk5tz7I3p/0r77KcleQnfZO1si50nimkC30?=
 =?us-ascii?Q?mSdfJ2CPNxMbBQU7UqLoaHRdKcURKS8oIbjeVvVqZv481yrArCMTgHVbQqdU?=
 =?us-ascii?Q?y7CQowF2AwEfMcMzrL0/IFojdpuxcM4KDz+ATlHA9HcOXEi1RVubo8tzX8W+?=
 =?us-ascii?Q?NE40puZ3WPJwwCLk+Gt99o5UPfb1+NpdCBi+szSl0wd2arDj4Khk3f5mz8dv?=
 =?us-ascii?Q?YGfbnttDwmZDwG2fzy0e0cbN7EhtfE5Ca6VBe+RWlWIF2dZCac+VzaJYkM3U?=
 =?us-ascii?Q?sDj2hBI7KH7p2JvtVlGBruqFvgYc0v0YFGMomtZoMtC3PMydot71RmSvXmqg?=
 =?us-ascii?Q?LRA/lcKxnBCzPfCFPqTAN0xeat8Oq0siKBYD4jUDdPmxCVFBM/KRB0qOjLvt?=
 =?us-ascii?Q?TTbjJG2FPgLnTJ78sJgpGcy7rjYFr8JJa+Cq2qMMMfoHkDfKSCj1mAjbXfx4?=
 =?us-ascii?Q?vNLl6/htGlAlVd/nXUnVslNyl8lVWeH3NSpfTLTWjeYahh0B8/9LbdDGr8mN?=
 =?us-ascii?Q?k8uRIdxonPCGOEbG/LmwDYcw71WJQdBpTY2c5xMh+wJw7jvts71HlUPoGPxP?=
 =?us-ascii?Q?S0JY3V7XGZYoEOgdqqs56J6nDIe2lMXt7PgwoqufFU+b+sl4RnYl0RHPFrAT?=
 =?us-ascii?Q?a5SfRIIGVoNiNCAfUE7Od1sUL8hjiRiQRKOdb3GWd6IKP/4B+MxtHwROn65e?=
 =?us-ascii?Q?ue+G6L1/FQXFsDblmQsriWUhx6Ggvg704I69cx56E1adCDGp8VA1s82YL15R?=
 =?us-ascii?Q?yg46yu3CZGZW16l8fAd4O/XoaH6vreEd1mJtfCmbWGoSW3iKTKaiWUeIqBbH?=
 =?us-ascii?Q?sze5khPXCdilGuZtuP2L8CyT3m83+EbCEPq2IC3aZsLbuWgeM2iZNOOzfhl0?=
 =?us-ascii?Q?tA/RWTDicqHkT0bocInQgPqv2bzNur+j4PnEjNPYjDAl06ZCbKeXZsqpzfoM?=
 =?us-ascii?Q?mItlM6guJjMMKBjr5SDGSJ7SwIhmjoD7mRokF3wbkwFdUI1R7Xsg7C5okQxp?=
 =?us-ascii?Q?S6FdEuEx/Lv1GWM/57+n8+wJlvtr38hHfb0IEFfQzdrVOR1tBtyCelIPLc7V?=
 =?us-ascii?Q?2TPozLQ857e+BBMCXLs9KrkL+gXEHN0Wv5/c0/AE3PDdZVrEbqkaFcdWvcai?=
 =?us-ascii?Q?52Wtcb6vL6YCWRsxTmlHwhGGO4LBIKyLtjWo/V4JD882l5EbZPk3DX7kYH6r?=
 =?us-ascii?Q?oPmmS+mkQFDO7pW6O3YIWemABQEmDu7hmOs3skjYjLhREOhd5H/MG3dceC/X?=
 =?us-ascii?Q?7ucudN+A1w9Li8tJDblHZMAS5hedv1/aD0I6KX24CoukuudLi4mGlHvvit2+?=
 =?us-ascii?Q?W0IpCxJe/qhDdSWSVY2yrOSQBY/Mbo04JvmXyjT4zLpbVQWp3NgMA1m3Awyy?=
 =?us-ascii?Q?SjKMUouQFdcREg3IzI890ZTKq03hBo+9PqfXGghl2dc6B74Herpxet3nIeKW?=
 =?us-ascii?Q?LGq3ptlE9/bX/gPPr+1ZGPQtC9ZQZymvN7hCwK8ZnnvDD4mM/ZtM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3521D287AE273A448A125353DD0C8C53@NORP279.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: intility.no
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SV0P279MB0105.NORP279.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6a5074-9c5f-45c2-4fcd-08deecae297d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2026 13:43:09.6936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9b5ff18e-53c0-45a2-8bc2-9c0c8f60b2c6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fQAyioH60/J18a7qV91fp7onurmcTFvw1WMJSbwRC6aoC8KsX1Y4WyHWhH12PlqBGqDc92iA1FK1RNNcGfh2QnbpIBXhKPFyI6MRWrWfs+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OL1P279MB0002

Hi all,

Adding a data point from an HPE ProLiant DL360 Gen11 with the MR408i-o Gen1=
1
controller (megaraid_sas), 960 GB SAS SSDs presented as sd*, running kernel
6.18.32 (Talos Linux v1.12.8). Without a cap the node panics within seconds=
 of
sustained block I/O to the controller, with the same megasas_make_prp_nvme
signature discussed in this thread.

Capping max_sectors_kb=3D1280 on the sd* devices resolves it on this contro=
ller
by itself. I pushed roughly 85 GB of dd bs=3D4M oflag=3Ddirect through it, =
so every
request is split at the 1280 KB boundary, with zero panics, where the uncap=
ped
case dies almost immediately. On the MR416i-o you found the cap necessary b=
ut
not sufficient because of a second problem in the SG advance path. I did no=
t
reach that second failure on the MR408i-o; the cap alone was enough here.

Both of our worker nodes have now run on kernel 6.18 throughout this testin=
g
with the cap applied by a udev rule at device add:

  ACTION=3D=3D"add|change", SUBSYSTEM=3D=3D"block", KERNEL=3D=3D"sd[a-z]", =
DRIVERS=3D=3D"megaraid_sas", ATTR{queue/max_sectors_kb}=3D"1280"

This lines up with Martin's suggestion to cap max_hw_sectors on the driver =
side
for NVMe behind MR. If a driver side patch would help, I am happy to build =
and
test it on this exact hardware and report back, and I can provide a full dm=
esg
or a serial panic capture from the uncapped case if that is useful.

Thanks,
Mats

> On 13 Jul 2026, at 23:07, Daniel Fernau <mail@danielfernau.com> wrote:
>=20
> Hi all,
>=20
> Sorry for the late reply. I was unable to follow up on this earlier becau=
se I had to prioritize other issues.
>=20
> In the meantime, we pinned our kernel to version 6.8.12-4-pve on Proxmox,=
 which has been stable for our use case and hardware. Given the recent 7.x =
release, I will take another look this week and report back.
>=20
> We are using KIOXIA NVMe SSDs, so we will see how it goes.
>=20
> Thanks,
> Daniel
>=20
>=20
>=20
>=20
> On Sunday, July 12th, 2026 at 8:16 PM, Martin K. Petersen <martin.peterse=
n@oracle.com> wrote:
>=20
>>=20
>> Thorsten,
>>=20
>>> Martin, do you know if someone there ever looked into this regression
>>> and the proposed fix? I'm wondering because Daniel and Mats reported
>>> problems under the same subject line (in new threads), but also didn't
>>> get a reply.
>>=20
>> I think this problem is just an unfortunate side effect of the kernel
>> being able to build bigger I/Os by default.
>>=20
>> Typically NVMe SSDs report fairly modest maximum I/O sizes compared to
>> SCSI devices. I suspect this is why we only see this issue with a few
>> select models. My hunch is that these drives advertise a fairly large
>> MDTS.
>>=20
>> Since there appears to be no traction wrt. fixing the MR PRP vs. SGL
>> chaining logic, I wonder if the patch below is sufficient?
>>=20
>> --
>> Martin K. Petersen
>>=20
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/me=
garaid/megaraid_sas_base.c
>> index ecd365d78ae3..b93a6d1180ff 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -1978,7 +1978,8 @@ megasas_set_nvme_device_properties(struct scsi_dev=
ice *sdev,
>> 	mr_nvme_pg_size =3D max_t(u32, instance->nvme_page_size,
>> 				MR_DEFAULT_NVME_PAGE_SIZE);
>>=20
>> -	lim->max_hw_sectors =3D max_io_size / 512;
>> +	lim->max_hw_sectors =3D
>> +		min(SZ_2M >> SECTOR_SHIFT, max_io_size >> SECTOR_SHIFT);
>> 	lim->virt_boundary_mask =3D mr_nvme_pg_size - 1;
>> }
>>=20
>>=20

