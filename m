Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0672BEE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 08:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjHUI3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 04:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjHUI3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 04:29:24 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B1ABB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 01:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1692606562; x=1724142562;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g8gX223jGGv2SPhoRGg/hHr/PBTYnScQxtfXVTPtj9Q=;
  b=Eu1+IvoWHEX3JPZOr6aw9q2cjcvDqxX+0lbl5M8W+GlwP/DP/sLYfL7A
   EqXo4/DVjNiRln9Mp1MI9H0wMEwYApKFYm5QXpEJyaJHeBh3kJ22XDjjI
   vPyNd+eRiCISvebtRJCj5SrT+gOTam0LaMQyvKyQRf3bEnxe5B6SR5lbr
   WqHd5XrZNmIzLFMVy48eHy5C+P/GlAlDsvC2icihR59ZQyaoXZFF6E1UZ
   7/FE6uvAzpRfL7mz9hHWb91kWJUBEfxBYTfOyBeRii+3U5YyzAQYyhL8S
   DAQ0YtDSRL3wQK4IwJvk5Sf60BotZbfZcfLX/+61ANcSqnuldVd8bqflx
   g==;
X-IronPort-AV: E=Sophos;i="6.01,189,1684771200"; 
   d="scan'208";a="353653518"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2023 16:29:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUUycCD07RhhhOObXhYc2EmHbIFwc0ia7r0xlCY1r/wCpTLv9lPRV+q0Zx9oFMycjx0Jn+jFHhKxITdEf8iOmI2Id8oV3Aj4sDdUqJAXBiJGlREYUwmAZIH8LClI1jNK85Ue35dvNCplBiRRmwdUnkW3gLFX2eh3c2AsVgTLcrQd0h13PWq/8kympmdx3bwQKj5rDLb7ZgaJZNuoVcLjHm2Dqrt3clWzY3q/2r+sBcWDxlOlvBY4ypg+7DV44KfmZumhq4pU4hoMKe2yJrNInIxJcNuWj6xoWJdgOGQpjuFj5EMeFc7rn7kFzQUHX/cQWzSKfpTc9LKcO2CbZ5Z0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LocfVnpuN1UuoijGau9phYb9psH+ZBkWwUBbXz5uwHA=;
 b=nv7+peG63hIoR22SMMIEM/fadCSUtPwc9X5FwEjOREFbJ/IO5FkvJfYNoL+aLgJgtHoNzI2D8aT4Pw1S/L7bba+/F8/onSADXDEbnz17aNn7mY8CJrkAq4l9O4UnhZwzDE7gWDgarPjWFWICEHpFANcfHTN+zOjrOB5KOSc8PDvNy9e/KmRoxKe5dGew5dl/CheApy1GCczkk4EbwlAvQ5sxgnoAuKZ+8AxQb0cUpaQ7SembB4bvCaICXLGrZ2dUu/uzRuydsxW4QWottYMetoFp9W3s9pMG6Px4WdzV+o7eJj6laK+6qPpvn3fyhbTI1HrLQT1zjLVDKi4rVEx+Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LocfVnpuN1UuoijGau9phYb9psH+ZBkWwUBbXz5uwHA=;
 b=OZvYgfK7dx+YP4yDL7XxAW5GEfSkulc7DpfNidYHHPrg6Kvp/rQNX9naRReQnIJyl4tMNoDMbxYzUBtug0SSP+6Tej5L9znR4FUVtt1Z0pBlf59/ENa3OGI6/U5ZU0VQ4DUWbakg2beBD2cNKeyua5B5WgaNkVwnSrdIxy045eo=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB7710.namprd04.prod.outlook.com (2603:10b6:a03:31a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6723.14; Mon, 21 Aug
 2023 08:29:19 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6723.013; Mon, 21 Aug 2023
 08:29:19 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Igor Pylypiv <ipylypiv@google.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2 1/2] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Topic: [PATCH v2 1/2] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Index: AQHZ0uRxNEnknIpCRECDK7xzDd48Kq/0bV2A
Date:   Mon, 21 Aug 2023 08:29:18 +0000
Message-ID: <ZOMgXdqjvlz+Ruof@x1-carbon>
References: <20230819213040.1101044-1-ipylypiv@google.com>
 <20230819213040.1101044-2-ipylypiv@google.com>
In-Reply-To: <20230819213040.1101044-2-ipylypiv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB7710:EE_
x-ms-office365-filtering-correlation-id: 754e3506-cab6-48c8-b8e8-08dba220b693
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C+ive4wliqTykyeCvKaVC8tgtUbXnSIxitfqBdX3AIHfh2lpFSMMc46L7hlyzbO9kMwBPjrbJYHfEhwgSxBdPGvlFYPZJB0ov7l7TcFLgIMN7aQ9+kWKfbRK8qMhPPRrp8N/p/Wpt2bW88SENUHwE3WinbvIDxMZZG6i6OhSz+ORAj8nRUIbsnnAe8xs3qi0xwMpHTTMBOhDnjVzsBd6+Z285QrlIPORPxLteAkRvOV9K5OJ++jR1Ps9TpTMY7Wh8U4cG8KbhkGJOAFTXc94g8Up14UsFEeMzd1pt7d3qmq8kbIyi5Cb62Mjbu8TsC3b2cZf2wE6f/yj/DJfjxjl4COB+M1Cczgfc9rgi+OM8pK4/HGhYUzs8aW7Cn1ATqNf8jvMEWPKMuVBGsmFoxSe+EPOSsSfqkyrNRj0Kmhrt8rYliTld1SJFvwC696J1iX2lsvsr2zvUFcKd5ax07BrnW2pFcRUrCspPTOfvNESTB2Vce5bYkVHy7/y5XRJS9XA+rNElNTUPr4lCuJ0CIVoDtwNmMJGNYioF63qgMY+7HRVndunORMlDZOdZyD6Io0Ohw2+/PypoSbWcImvDtj5menxCvf6oujpCvoj95/7V8dls9CzYEtjZAVzmjv8w9mC/BAHj2UrSdQK+fcsQ811Rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199024)(186009)(1800799009)(2906002)(83380400001)(38100700002)(38070700005)(6506007)(6486002)(5660300002)(26005)(86362001)(8676002)(8936002)(4326008)(316002)(9686003)(66946007)(6512007)(64756008)(6916009)(54906003)(66446008)(66556008)(76116006)(66476007)(91956017)(82960400001)(478600001)(122000001)(71200400001)(41300700001)(33716001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aRmaie02Hg9aO1ScDvokzTApWXv0/yqJDwF3oQRFV1um/7TjLF4fY3iw1+Aw?=
 =?us-ascii?Q?xM0CEf1w8hxk15oTkJTqoBOxrb8QIN4ichVBS1/zWwU5V88H/0tWYgKjxgku?=
 =?us-ascii?Q?bHaZtfMr+CT+Rb30HBXLB7mHniCYwV1cVHnDfPs+azZOnOB+1lOFmfJpUXKm?=
 =?us-ascii?Q?Chg0YhKdpYb709/BwYiVHrAsgZZkfBnEhLyb7UbeRTJAaFIeiU9/enMkwOrW?=
 =?us-ascii?Q?NvKeUnhewhcAlL3C65biHxktMBWjjrKQ0mVOjdJe4voQKThI1M00dMgixBwV?=
 =?us-ascii?Q?sxagw8WnEQ/7SvhuM+0WvlJPE0tzyT8Pk86Jkm46qpeLUMcbCUoxQ7EVAJA0?=
 =?us-ascii?Q?xeRjY4qwDZORFSmzWHpXN9Jp8eRzDLp96U3tUeHU2TkHgW9VTnKmtcIheOlV?=
 =?us-ascii?Q?cH9Vgo5BJKUhaP/yQefpWDXor5LWFGf2XDQ6jkIMNJX4b6yLc9ZRLowbxtkz?=
 =?us-ascii?Q?bPvNrCY2HXPuxqtE1bMMcA3v3Hn9ug4zhojGbE6abH9IKxDfHWZ2zwqTDQzP?=
 =?us-ascii?Q?4LjWuvjwLPWiQkBnOeF61JJVKGADs81ERd0kzLm3o3YSqXRtZfK06LSHPkRy?=
 =?us-ascii?Q?PGqHCd3dxWMlH+i+5BpSHSYK27F4hSeUNlAoU2anb+He32C2oHdsmUVAoQ/I?=
 =?us-ascii?Q?OZ6qwWaG/2uAb4w2iKuwhN4kTesAqod/pGkP6ntF4d4yEZxCHqDYG06sZNrO?=
 =?us-ascii?Q?Ylw1BbrElDfOGCKgaYrbskG/k8t8oXZKPfttiAIrdAmlH6EQqTtW5gI3B9GI?=
 =?us-ascii?Q?QOD0kfcqn+ePK7YnVMLCW+Gb46gmQxQL7gCurxlxaU3fiq7/bvTt5EE+s9BL?=
 =?us-ascii?Q?UkwvsIVQl7ol2CDAcYfW8knBfdMn//XzJFsWl1UwHocJtll3exfhyR+KBGwS?=
 =?us-ascii?Q?DeJlyTD18CiOO3QfWQCjRfhNCZkm6xoxClkvt2AVT7ub3BOxYv8xBYeKaV3h?=
 =?us-ascii?Q?n9hTXBp0M911PyslYTyB/bPAhzr+V1cXuImxGYvoRpO9fly6kQaBg/sHffUY?=
 =?us-ascii?Q?2FrKY6//Ll0shRkSd3efJWtBv+N3yNqZ8bgd0NxXOU5XDAtJhEnQ3vDA9N5K?=
 =?us-ascii?Q?cP00WOG1oC9Gttx49GFAUe68+6iyuuRN34U7xuzo0YtAnCyMgDiC+XCh4dNS?=
 =?us-ascii?Q?Wg1QccDRS3PCH3llUj0r39wyN01F3mjj96ubGgq2fL6bwfIcmOm2geaBHnaH?=
 =?us-ascii?Q?cXhcwAWPY+mKC6wz9BmCNBNajNNWxvBu0ZyZHT4mL0fwNrINZ3e5kVWxJlEf?=
 =?us-ascii?Q?o6WDv6ZX4m3gn/5lSR+OB/JiUUr5rrKtLO8fv1DWSCFG5sKhxaWMC7o5g/eA?=
 =?us-ascii?Q?LeYJb1FCm/UARbKi62EMTbiIw8iE1qQg8uQn3pwAuhh7OM5jBsIr4S8yuDeW?=
 =?us-ascii?Q?6e3QBXpoA9SgGGGr3L5cp6MllR8J3OpA6a0FJR406pYrUgo8T8r3QKo5V0iZ?=
 =?us-ascii?Q?IFbX8ga/t5hPmyZ6nYI/6tZ3jji07RdNmkOHiZ0gxbY+Ct1GeAakCT4OJ2wP?=
 =?us-ascii?Q?fkghgCExEa8MMoWiYCiV4UzIw5qXYoCs2uByohL1S4z5NXfTxuua9eDAs/zF?=
 =?us-ascii?Q?hfjA1AMJonxJysO8p2/B3i1HEYEkbCxGzQFqNWUsoC864EM0Y91eG4Ply8sw?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D29C9AD2CBDCB4B9EDB7D51042104EA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gqpcfAxCgklIOmErHdoPE4BNo8SFdXh86fuRkKctrJVHKdJRb4Ymxc9ATtZd?=
 =?us-ascii?Q?URT549ecURhzPPjg0kqioq5fM0wvQeEa/fTCzySUmRjio4K8nviXm2xvZR9E?=
 =?us-ascii?Q?exM+7pslF9zcrwcvVzQXPDLI5duAzPj9xJ+1VTrLotv1z9RNvIvnsTJb7+U6?=
 =?us-ascii?Q?13Ym4seU6kPdrRY/wFjfZICOhu0LIFjj0umIZCrJTLe3tXRSwv5F/uBjXat5?=
 =?us-ascii?Q?7KV3w8w63w2qfwPoiUX6Gffktz2ObjQstwT7b3YPV1FWsbFQ6ZMFCSmgSnZ8?=
 =?us-ascii?Q?mI36x3QKiMYChspCZLNxCukqrXRPSGN4o73lrq8J19FfzgJxDI4IAF6v97Qd?=
 =?us-ascii?Q?415iCZ/DeiA1rB6Iee8nXhm8naLmrRVtF9w5l6qTyXnO4XIioubxqNNoV1MU?=
 =?us-ascii?Q?9wXZ2tDz9Zjl4oNX86kPLzZgQ4w0Oo5NHChG4YboCAVe6/cG2DwABwV/+v0v?=
 =?us-ascii?Q?nUDXfZxIC+x0GL6Lfmq2CPXDlUHJn3Gp+dUADdLPswY2jOk082MqK6HHgXzg?=
 =?us-ascii?Q?6Erp4yflX6tjPagOYkVSrHNX23WYx9d+la5ZDglRhbEhpeZRmI868kyePAfD?=
 =?us-ascii?Q?99j0/fPDaZ4m8axkNSM9Z5Ux2JdHgvmY0wFxXBwuZRgtGnGTUUtZEwdFS998?=
 =?us-ascii?Q?niTd37gFqBpfqTDBlihHBQEPh15/p+LvZ96b5d0E7xWZmwo2UzJudo7IV0Dl?=
 =?us-ascii?Q?EzUKDAcSwaptbzxI9wgcDIUEUZq+iz1n4hE8U16szmV5Ds8qM7uVJL/NsdYt?=
 =?us-ascii?Q?xgbj3vkI7CVdBMJIorLQ66VQBeoN2vEwHczU6N8NnOXgmK05RJGR1xP2g9cb?=
 =?us-ascii?Q?/BTnJ6w38P+u2yYhfWILT1Xr0H2VaG6XuxPtvFwvcgutvNHQNsPbX990wsAM?=
 =?us-ascii?Q?o0N80vCrF4nwmrwjkD1SGjm8lZeA5eZOQbmikPufn+nXrgN6X0y69L5Ntjn+?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754e3506-cab6-48c8-b8e8-08dba220b693
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2023 08:29:18.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p5atAqMJarmy0g8eELzPgZPDnQ3IruPIhCeKre2UVVPEoobJYuzYXR2gzet2boRvv4yPTk1yU33J2gO514R8sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7710
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 19, 2023 at 02:30:39PM -0700, Igor Pylypiv wrote:
> Set return_fis_on_success when libata requests result taskfile.
>=20
> For Command Duration Limits policy 0xD (command completes without
> an error) libata needs FIS in order to detect the ATA_SENSE bit and
> read the Sense Data for Successful NCQ Commands log (0Fh).
>=20
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>  drivers/scsi/libsas/sas_ata.c | 3 +++
>  include/scsi/libsas.h         | 1 +
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
> index 77714a495cbb..e74b60d9c4b3 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
d_cmd *qc)
>  	task->ata_task.use_ncq =3D ata_is_ncq(qc->tf.protocol);
>  	task->ata_task.dma_xfer =3D ata_is_dma(qc->tf.protocol);
> =20
> +	if (qc->flags & ATA_QCFLAG_RESULT_TF)
> +		task->ata_task.return_fis_on_success =3D 1;
> +
>  	if (qc->scsicmd)
>  		ASSIGN_SAS_TASK(qc->scsicmd, task);
> =20
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 159823e0afbf..9e2c69c13dd3 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -550,6 +550,7 @@ struct sas_ata_task {
>  	u8     use_ncq:1;
>  	u8     set_affil_pol:1;
>  	u8     stp_affil_pol:1;
> +	u8     return_fis_on_success:1;
> =20
>  	u8     device_control_reg_update:1;
> =20
> --=20
> 2.42.0.rc1.204.g551eb34607-goog
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
