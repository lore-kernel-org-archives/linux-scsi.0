Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3C4EE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 08:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjHUI3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 04:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbjHUI3o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 04:29:44 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9D7CD
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 01:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1692606577; x=1724142577;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eX+8hpp6DF40U8UfHf61PJfzFPPLoSqZC5RDd053fMs=;
  b=YEW/mn2SSuqSdFbX1TClnL30UBNs+9O6piKjS0XCIFYWogj13KZ1YgYR
   itXS+TY5gHlQZ8+ere1SOdb79RkHhqqtsYP8mwMWGHwKNf2lNVp0ubr2A
   d4S+ssmyc6pjPSP1GAWrRRUMnqYS3U9oz5O4FFuKm7NyVv25K95P4thez
   HFY76KLbNQIXUXPZiUkf/6vR5KoTsLjnKFRyq5UX1Lgn3qzZmZlnIcLg9
   zzMFCxWaoyivy1H1iL8eZZ6O7evs0IxV7oT7aB3ocBEA4e+GaBQqeQAhn
   zOGcket8dcFwVMifiyBKlTTUuRA51K7Ngmh6wD4Od2yq8w73b0KNRx7M0
   w==;
X-IronPort-AV: E=Sophos;i="6.01,189,1684771200"; 
   d="scan'208";a="246260847"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2023 16:29:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oit8t/p2FvcZckV+qrM8RvsbnhOcV6A79KzbYSiB5PV973SqSEXoGbYGYuvtcSOcvLA3v8K1ZFqaCA1cbPALxLQyr8hAlrhw63uIqau5kZeCS1oua9U1xZ6pdasRD3TN9fMaw+kWYIkr2gxPSiU+SW0s0m6b21jBdK+c3zlFJz9aPyTGWR+5OGV16I+j3lMjhTujqfQHVyrx7fowIgE+x5RBtVFf2G0EjIHcN6bNUvVhyZjJnNHkMHf2e1wobUtz+FBup8OZxbnKe49cj796ZS/BHgT6CpuHrzH0uKKGuEEwLJBfaEcxCmN4KLhyBlsZR6Ss4lIRNN3lJ8YxjNk+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4p8UqFdvu8dmpiaMdLB3ViSWUgGdCP29ZBgOR+9Aqc=;
 b=LicwBTJP/sqMdg6ld8KKODgEANPd4c7EXGXoK3ACBKGJbn0m41vweOlZJd25SiVeccNJXFXBqpUkGzJBJAOKoC5Y578RLo8obAl13y3TnZ4zWv6Oj3FueczviNOo9ZAMmK62zEbQD13Xb9T8seFLO/KhUUqTFN93HGEb0fYmmC1lCfVgVSoba+nKbEpmrCro+6socAYJvOTfa3F028pSiYj+jDBHwUjn/Nh5y8UL6z69Ab/G639fCr5uiy5+l8Tiq57lUT4Q+yvS7xV+OyVW+AcMv87Hn4ofPDQMR8uqtwPNbXc8TSjGvk23V1qbVG6ugYsCnH+RTzFCXu8XLL4Evg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4p8UqFdvu8dmpiaMdLB3ViSWUgGdCP29ZBgOR+9Aqc=;
 b=l8f045ooePnq3UyryC2xlb1kUDof+vtsP9rzXL2YL0Et5L4DBl83yIMFXa7O2zy4WrdN1HoZfrfQaK1uoZ5SwSVcqwFkQ1JGf/QAb0ZG1E9wdzI15Z7VV5SUtqq86w5ZwvrKdNlvqB8c9y7P9dehHp11wV+6Qe+s4bwAueGjYFk=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB7710.namprd04.prod.outlook.com (2603:10b6:a03:31a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6723.14; Mon, 21 Aug
 2023 08:29:34 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6723.013; Mon, 21 Aug 2023
 08:29:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Igor Pylypiv <ipylypiv@google.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2 2/2] scsi: pm80xx: Set RETFIS when requested by libsas
Thread-Topic: [PATCH v2 2/2] scsi: pm80xx: Set RETFIS when requested by libsas
Thread-Index: AQHZ0uRyWDxDdGWkGEySb8ZT8OChEq/0bXEA
Date:   Mon, 21 Aug 2023 08:29:34 +0000
Message-ID: <ZOMgbum9xkKD9m2D@x1-carbon>
References: <20230819213040.1101044-1-ipylypiv@google.com>
 <20230819213040.1101044-3-ipylypiv@google.com>
In-Reply-To: <20230819213040.1101044-3-ipylypiv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB7710:EE_
x-ms-office365-filtering-correlation-id: 0940fa51-b684-4317-d41f-08dba220bff6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MLzzipPzm2EXvP8trLt0afFdl7ypUJA/lcGQRB+g5gMuNZzUhmchP647lkM0JRdg4FAZ+2DZBNFdG6AMiGc1YX0Dn0lf/8iYHqzfwpiNQ2pt4wKTPbvYJezhw7UsgyklgJVFd5iaXBqxTCmvC0KkKbR23oOmAeBU79gHqMtAXoSqCFj0Bp7hTMkCrwjFsbV976FtwoUYXBt/Q5l2VlCKXp4VJCcXoeT8yNDal3bUv0pkfJz0WVsIhcfUZAEE4VXG2c3mwWtN31fdf9+9wKXxvwtj5jY7m0PsOBy8OSIM0ZT2cfg2My8ZXHWYtZAuoA+S3/yNjlv1qYp9F74g+hh+1R1k7WRzTgSeZjmfgVr6SH7PdofkqLMsOmUth2LRqWrBHayxdVIWht6VCK64SsgFy9m6Pv3tyEI7vfbMzDibIyP0EebXIn2MSKU8TqIbLixiSOjdXJTUTTVO8hcq5DR8JS6qBOu3mbPpO54e6t0axdGyW7yfIG/85chSWLF/x+KWjlJ6oPqGakaQTiCtsrCKTj+k4W4kzYZBZwBIvCLqupN0dTd1D0HYIbd28GFlY7GQuOhCN/QOaeRyUYN4NP2VrX4ujm3alm2D3VgQJxSBPt4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199024)(186009)(1800799009)(2906002)(83380400001)(38100700002)(38070700005)(6506007)(6486002)(5660300002)(26005)(86362001)(8676002)(8936002)(4326008)(316002)(9686003)(66946007)(6512007)(64756008)(6916009)(54906003)(66446008)(66556008)(76116006)(66476007)(91956017)(82960400001)(478600001)(122000001)(71200400001)(41300700001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MsVRkEvzWAR6YaZ8pjkeUPv4CIyhgjg9lhQNWwv8ZUxJBeDqc+MWtfUytOFX?=
 =?us-ascii?Q?1G/BGkEgXFQqgYePsAxIpsKa1niEsoOuPDggGszUIPytbnTdQNwT0zHvorel?=
 =?us-ascii?Q?q06Z6UM9cDumhZQ/FqRw32omdpvQa2uaNaSIllRioD2wwgl1vD5X2b1NFgNR?=
 =?us-ascii?Q?ngk2/zAS4sDgLjaX+WQoIyLMg+S4uXhfxJLzVolIWZM27knwYj2EtcCGYjky?=
 =?us-ascii?Q?0qbqhOCrnKrwMVloTepACzyELhHcBm/I4YPeiFYEo+zVwGdyJ6v2VUzGyAwv?=
 =?us-ascii?Q?/5L1+IZu+UNRGWs7NZk4dGKwEzUIwOEyRgGrdzGsQ3OILqJL258Wd1b++oGp?=
 =?us-ascii?Q?ax+KRaX0eJmoy4SIR5Z75fdd+Le6Fc8/82d4seiI0yPfLqmm0JOtzrtFNPdu?=
 =?us-ascii?Q?Md36cHdefQOn2J4jDHvnRzoD8BMC9VKq4x6PgNMXvfvp3rUISBZOzNZA2N/C?=
 =?us-ascii?Q?BUaInj8D+TYFhinSt2JBa/eJDeqz/U2+vsIb5IuwHazQpBdgUm4AIQMfiF8c?=
 =?us-ascii?Q?Y+U7cwSRYORLe7Cv6aagjtycdvpNtX4d+k0yp9F5oy6xSauhABmPoFHJ++QZ?=
 =?us-ascii?Q?P3VoQBNwT6H821r6e3q9CNft5dfzmGEtgHRc8vZx0YC3Ty5+ji0xJ51kZTjg?=
 =?us-ascii?Q?mW9KykrnQo19QcQllkqTzYBt7R6sGXdEpix2sRVyH4KSfONjR73tic2pRQ82?=
 =?us-ascii?Q?zCliiQtYX7LX/NqL7rlKd0arsoY7Z1nGHwQHpoLWdMvyjhjgii5uqvv/c/79?=
 =?us-ascii?Q?YioJ4t43caVhGdQVYuR/Dkh5hWTg882vxdk4/gO8n8Orz9rIGfVnF/808H8m?=
 =?us-ascii?Q?Cj2PK0zrIF5I/1uWe9bi0HBK1epORJsBwb0DaCKrPJTcClncEwaiYAUvWAMh?=
 =?us-ascii?Q?5iiuLCUG36+Owgsdbpvd3aRi1WEwpF3jfbgXO0tIJ6uEO7kyXJyxN8zeQdiM?=
 =?us-ascii?Q?M4dEzolbDWjUYo01NAx/W8SbseLgPBqN9yS69NTViBpD+BdXYJ2UP25DRFQh?=
 =?us-ascii?Q?JW3l+ZwfgMfMdzI8bof1FcNscDhaJZN/43OMu8ADDVkGCGyOAl0M2m4yvFKA?=
 =?us-ascii?Q?oJnUQDm81H2XD+FMerYs7nhGi4UcWrFQUUPROUMu6GNMtjUNnY3szYUO9mua?=
 =?us-ascii?Q?dIC/G1NBOoVft68SL4KAuFJkMsBdMLjDk95SxXM7IWslfsYCkpxNNlwmSZ73?=
 =?us-ascii?Q?sZLv5bQFoy8HUHY/TUVBImLaxA6Wg4IveL8VrHaheqDo62m3Ebx60mNUe9Vb?=
 =?us-ascii?Q?4R9SorU2mWPsWbPXcdRI9K+9MtKz/4vDgs00JYxGbEs/YvT8P7AINTdnL/pt?=
 =?us-ascii?Q?Ckra+tD7ocfu+3A1yWyI+hfMbOoASzJg1weyRw94ssIWsyf+izBoC9oES4zc?=
 =?us-ascii?Q?WNXXcJhmB0yy4COuXsZmRF73PG/DVnFF7V0Sa34M/3zzbXo912z8vTN7Ny5e?=
 =?us-ascii?Q?OHRIux6NM6mBwGIg5wUMHYgTJ+dIKtKdFADIK+DR1ho5Twj5jrRE4KqtTEjW?=
 =?us-ascii?Q?02ScKzqK5y07wV18PAtTfJsbu85oayY9z5bVG/YWf1YPEbQ3uJ619oqEpnBA?=
 =?us-ascii?Q?sUGKkfxTDzLFXFn0YFdJKC42W4alQuPdaGhJnb7DXwpw5Pw7fRgsBQrVmi6C?=
 =?us-ascii?Q?yA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1F44F2C0798B844A78D2145F66CFE4C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?4hmrJ9xVucX8bKF83VbZZ88KJPJNAWmge/Gb0SIH9LkrAJL4dbsv6BpFYCsG?=
 =?us-ascii?Q?iHM61ToA7o54ZfehfWhXeJ1/kPHhXIOjxo8p/X9NbZ4yAnMtFpRItGIYryf5?=
 =?us-ascii?Q?BS2bTyLDlz392QwXg429n+1v69Uo0JRBTZ1iviXE/jj9EuTGrL4zSafp3Cex?=
 =?us-ascii?Q?f7pgis8mKQVyxMon1HvT4ZGt94ZZ2gqMzvKgpLomax6Q2pgAZkpRCksOoteD?=
 =?us-ascii?Q?AUAfcJJZR4xqfQUHn0qFCvoNZzSkggTq7PeLEfL3G6PGMU3vr4ZuJndaK8Bb?=
 =?us-ascii?Q?xbrwtV1HZ6pr7DLVbBhBcVcrdZ+nbkR9o/fg9T36iLkeJFvViU44gAv08ILN?=
 =?us-ascii?Q?60T8EmhnmC/sAMeK6bsBpJBg//Uerm/V2oMF6klCOd1vkd5j+fK0zsksPoEY?=
 =?us-ascii?Q?4b/sGG9Mr6Fzwq/faowOSemTEblImQevHV6LKGxPCCm1D414nSCe92rCq6vb?=
 =?us-ascii?Q?PQ9+jHN5yMfj5aypr2mu9bFh3XgjJqJhsKALZxvBa1ARLlbp96OfbQxJvVgH?=
 =?us-ascii?Q?C53HLVgSwxjbqJO5ZM04MyzPX73dg+9rAAGsPqZN3scDPXwNK/oenX7Rz0Rb?=
 =?us-ascii?Q?vsH4JLusnZIs6YUb+O4FlqPTUcA2AgaR4LBSQEAp7wcCRKdnhjsqb8f2lqqz?=
 =?us-ascii?Q?2icgvoCImr2lUR6spqKTVXo6FuX4wQIZL9ZOiO8Ijf2RHqPaz9N5j9glT1b5?=
 =?us-ascii?Q?8L3dNZgyeTDAzXRXwdksO4CZCab37bd4IKmlZR6DEm08/lpetng3PjL+3VmL?=
 =?us-ascii?Q?3kecDNeKEUO3W53G549OB7nl8Tnl78R8ASvhK8WL1imhihXZ1phnQSZY7Rpa?=
 =?us-ascii?Q?iCa9mV6+V3QJnpuueeuPYZnX14fQTDNQiGotE1lS+62fh7+26gcrUrxCzOuu?=
 =?us-ascii?Q?4U9qMpRA/VAqDu6+NuMIaueRbzLEHg0xrQ73WPNrQBlRhgAaF4XSYf1P7V1H?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0940fa51-b684-4317-d41f-08dba220bff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2023 08:29:34.6312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+/gWG7vqX4B9wEr9RnuHlYrvlO/lbTH5OmV6J5g57Ly6OJwi5oIDi+Vx//aQUfnamcZN3zPq1NRaTsP1PpruA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7710
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 19, 2023 at 02:30:40PM -0700, Igor Pylypiv wrote:
> By default PM80xx HBAs return FIS only when a drive reports an error.
> The RETFIS bit forces the controller to populate FIS even when a drive
> reports no error.
>=20
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |  9 ++++++---
>  drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c | 24 +++++++++++-------------
>  drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
>  4 files changed, 19 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
> index 73cd25f30ca5..649724a1d134 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4095,7 +4095,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
>  	u32 hdr_tag, ncg_tag =3D 0;
>  	u64 phys_addr;
>  	u32 ATAP =3D 0x0;
> -	u32 dir;
> +	u32 dir, retfis =3D 0;
>  	u32  opc =3D OPC_INB_SATA_HOST_OPSTART;
> =20
>  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> @@ -4124,8 +4124,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba_=
info *pm8001_ha,
>  	sata_cmd.tag =3D cpu_to_le32(tag);
>  	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
>  	sata_cmd.data_len =3D cpu_to_le32(task->total_xfer_len);
> -	sata_cmd.ncqtag_atap_dir_m =3D
> -		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
> +	if (task->ata_task.return_fis_on_success)
> +		retfis =3D 1;
> +	sata_cmd.retfis_ncqtag_atap_dir_m =3D
> +		cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> +			    ((ATAP & 0x3f) << 10) | dir);
>  	sata_cmd.sata_fis =3D task->ata_task.fis;
>  	if (likely(!task->ata_task.device_control_reg_update))
>  		sata_cmd.sata_fis.flags |=3D 0x80;/* C=3D1: update ATA cmd reg */
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm800=
1_hwi.h
> index 961d0465b923..fc2127dcb58d 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -515,7 +515,7 @@ struct sata_start_req {
>  	__le32	tag;
>  	__le32	device_id;
>  	__le32	data_len;
> -	__le32	ncqtag_atap_dir_m;
> +	__le32	retfis_ncqtag_atap_dir_m;
>  	struct host_to_dev_fis	sata_fis;
>  	u32	reserved1;
>  	u32	reserved2;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 39a12ee94a72..a5021577a15f 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4457,7 +4457,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
>  	u64 phys_addr, end_addr;
>  	u32 end_addr_high, end_addr_low;
>  	u32 ATAP =3D 0x0;
> -	u32 dir;
> +	u32 dir, retfis =3D 0;
>  	u32 opc =3D OPC_INB_SATA_HOST_OPSTART;
>  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> =20
> @@ -4487,7 +4487,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
>  	sata_cmd.tag =3D cpu_to_le32(tag);
>  	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
>  	sata_cmd.data_len =3D cpu_to_le32(task->total_xfer_len);
> -
> +	if (task->ata_task.return_fis_on_success)
> +		retfis =3D 1;
>  	sata_cmd.sata_fis =3D task->ata_task.fis;
>  	if (likely(!task->ata_task.device_control_reg_update))
>  		sata_cmd.sata_fis.flags |=3D 0x80;/* C=3D1: update ATA cmd reg */
> @@ -4500,12 +4501,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
>  			   "Encryption enabled.Sending Encrypt SATA cmd 0x%x\n",
>  			   sata_cmd.sata_fis.command);
>  		opc =3D OPC_INB_SATA_DIF_ENC_IO;
> -
> -		/* set encryption bit */
> -		sata_cmd.ncqtag_atap_dir_m_dad =3D
> -			cpu_to_le32(((ncg_tag & 0xff)<<16)|
> -				((ATAP & 0x3f) << 10) | 0x20 | dir);
> -							/* dad (bit 0-1) is 0 */
> +		/* set encryption bit; dad (bits 0-1) is 0 */
> +		sata_cmd.retfis_ncqtag_atap_dir_m_dad =3D
> +			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> +				    ((ATAP & 0x3f) << 10) | 0x20 | dir);
>  		/* fill in PRD (scatter/gather) table, if any */
>  		if (task->num_scatter > 1) {
>  			pm8001_chip_make_sg(task->scatter,
> @@ -4568,11 +4567,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
>  		pm8001_dbg(pm8001_ha, IO,
>  			   "Sending Normal SATA command 0x%x inb %x\n",
>  			   sata_cmd.sata_fis.command, q_index);
> -		/* dad (bit 0-1) is 0 */
> -		sata_cmd.ncqtag_atap_dir_m_dad =3D
> -			cpu_to_le32(((ncg_tag & 0xff)<<16) |
> -					((ATAP & 0x3f) << 10) | dir);
> -
> +		/* dad (bits 0-1) is 0 */
> +		sata_cmd.retfis_ncqtag_atap_dir_m_dad =3D
> +			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> +				    ((ATAP & 0x3f) << 10) | dir);
>  		/* fill in PRD (scatter/gather) table, if any */
>  		if (task->num_scatter > 1) {
>  			pm8001_chip_make_sg(task->scatter,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80x=
x_hwi.h
> index acf6e3005b84..eb8fd37b2066 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -731,7 +731,7 @@ struct sata_start_req {
>  	__le32	tag;
>  	__le32	device_id;
>  	__le32	data_len;
> -	__le32	ncqtag_atap_dir_m_dad;
> +	__le32	retfis_ncqtag_atap_dir_m_dad;
>  	struct host_to_dev_fis	sata_fis;
>  	u32	reserved1;
>  	u32	reserved2;	/* dword 11. rsvd for normal I/O. */
> --=20
> 2.42.0.rc1.204.g551eb34607-goog
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
