Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17521C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 22:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BCC239EB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 22:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbhAHW5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 17:57:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25455 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAHW5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2021 17:57:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610146642; x=1641682642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6bEEFy37TFAobf+f4cAbUsGj4/WcH2MMUFJbvA/aTGk=;
  b=coAZ5EKUGeHrZRdK+RqkeHHid0MZNdmktm7yAE7aYHGAX4XbmigQSawN
   ZElGUhGstQ5c49fE3lwHFXYfckIxKbXMwJouC9Krsn5pkomAw2uwW1WPY
   Cmw0Y89WTxgfQ7/g1tYPa/cv2BMAMJvz3EjgGiimY2jPASHfMMMu/ybKo
   04s4vdlhoTg8l9P485ov62n7V4AvsCVCftSj5ztg5gV9anppHx/cGIBTa
   tV1uP0IJle7HaL6+rgWdOOQXpQgdPGy2WDMhFN4e30lchM/lwPOG81YGp
   gz/4DrzU/gTacYUpQOeG2rfkT64GUercWw3/taR/KBZf9o61t2vkTjwa0
   A==;
IronPort-SDR: 5oZx6nmjU38AByyTDxX7VyyU4lKXZpSnIKvA1/qhwTDAF2oWRLm1HBXW8IydJpjDMRv7SL596f
 9zMJ9aHwjacQo1vsX/gaSocaBj+Q/+ATHhSEuX1+HfVu78MTyyxk/vLfa7USJwO84LHopOoTig
 FyrtD4DreeVeaNYtFHtZ1OBLPQu00W37D/XWIS5UgaUJ9/aDg6Uwt/hNFDrY6pJQ1U+EfeRIq2
 n0YhoZXNr0g26zjtWxjexAtnsNEQitqK/ZB7OPk8feyN542juCOEdgMd5mqXSutwwtRp6wnm+A
 fT0=
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="105335117"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2021 15:56:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 15:56:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 8 Jan 2021 15:56:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PP2ZCNVn/Aa7ICVS6Nz9VAcmDbpAJ5ar0I9RM6b9wBrHktnu5FArARoxwqaNcyPzsT8e6L6hqVKh/zZlYZy4iQRBc8804QzKR/E9f6FKARYUo76qhdcvr7+vhG96qcvHdT+aKDgo2odw/5u/vkOno4ejb81JTPxwc6Wk94rC2Qr4WMTsgDEsMnGp1+S3yUJV61CDCq7qUN7CHuYbPL5qHimKSJIJlJUzQc3ii4kYamuerVTPtKEiwENqCj6tk/I3/CaeOrkAmqXndFjsqFgrDlkLbmrwNUssqCHuBHSDEVSO4R6qs9SEYFk8D7Ewj0hoAxuO+WDer+/POyCkpSOI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcFiEqemnrnH+TcHJZ1OjNb5MCVqbQZEn9H0N3TvUN8=;
 b=Yb/qpWOeG1HiXHstvK+5RBLgCr2pSezYLEQ1f8cbC1/AJzKqUpTXj3iZblRiJBLksG3SW4R7b9t22cz+1F7uRky8bhptQC9UdsmuRgSHO/MNFG5A6qpeWj+uM31Klb+OfHEMHFMY3Qj5Po0JqKILB6+0UFkWmUB/KPS/YSwuHKKMmUJVPTuPfzZl7mJLgl0sX1zkQpPbMj8kDb6PW/cA2dECR1WDHRMmvuTLPqTvQ0UWN6se9MFienbfco5ExW5jocfDp5M5xwzkz2VQ49117Cpvc+AvSMVF5bL28QUWvsAx1YUxCkGcE8xHxnwH9Wsv1F+saJRPdNnsYjcN4PlbhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcFiEqemnrnH+TcHJZ1OjNb5MCVqbQZEn9H0N3TvUN8=;
 b=g9ek7X6ckZP8rPdMHZVhE52n0ejJZy8zysY65xQQfOd7bg3zJrfr9LFTIKssn0Pk/Z2RLvzEFdogtC4aJ9KC3RIQwzhwEvUFFGBl0w//xHpv4S2Grwz0YGXTiLDCCZSnMlvB7e3MFMqPXRy08U/whl1P3qtEWmW/2hpMbUiMGKc=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2749.namprd11.prod.outlook.com (2603:10b6:805:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Fri, 8 Jan
 2021 22:56:03 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 22:56:03 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 04/25] smartpqi: add support for raid5 and raid6 writes
Thread-Topic: [PATCH V3 04/25] smartpqi: add support for raid5 and raid6
 writes
Thread-Index: AQHWzzRC2nl00jNCkUK8UypKQB1m2KocikgAgABWXjA=
Date:   Fri, 8 Jan 2021 22:56:03 +0000
Message-ID: <SN6PR11MB284831558FB35184B3FE14C5E1AE0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763248354.26927.303366932249508542.stgit@brunhilda>
 <15d80793c64ffd044da1e40334acfd8ad8988fb9.camel@suse.com>
In-Reply-To: <15d80793c64ffd044da1e40334acfd8ad8988fb9.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfd0ae0b-f4a5-411f-67c5-08d8b4289353
x-ms-traffictypediagnostic: SN6PR11MB2749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB27497F91E75D87D2C4B32652E1AE0@SN6PR11MB2749.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: drrSQWK1iggBi3zQ9bRBQbGX7FJ2JqEpeHfPyIS1Yx8FZhK7hESy5djvqpRS6lrigjm5k9TH17rKhDOcxHTFuOl9wAMG8FWx94l+sMg2x01ETt3Y75iV2ZfNiIoFK7ARCX7kcfm0U+aQg883MoE5M1uNn99Ks7+6PD0H103i9H/92F+/tRKUnes7U7K7SFH5di69R29+8n7Q7oAP8y7rwUCq8y9tvzUdPW6GaX9qJJHohcF5Jm9GH8ewTDIJrd1Gm9b4hQUnJETA+t/xJ+5LE+Cqn4P1gEAuBr77qghsItoIo/q2JkzAAS9buoexlW5fkw6WmUwrUpjgKM+93MQL6Q4uTn53S8xzG+1mMg03xUAvvHzUhh64z5u71QoCOdMrmuAI643Hft6MM/mB7AjsruL26/5ipkhNjwCg1bmzX1K4ZN0Vs6E0KeHOUG6mefX4NIceSKBeoAQ9l9+J071zeGbiBR6Nei3q8mRVsSVxEzcKfubyz97bilMzmEqjcAR8mk4lka46U8ycaxoE9czcyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(86362001)(921005)(6506007)(8676002)(83380400001)(2906002)(7696005)(316002)(186003)(66946007)(966005)(26005)(4326008)(33656002)(478600001)(5660300002)(71200400001)(64756008)(66556008)(66476007)(76116006)(8936002)(52536014)(9686003)(66446008)(110136005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bQbvx/OeWnKoGca90/HMQJ8K4RxXGCbWFTCqFuB/zGzxahrjeTtFaOMpx1Lg?=
 =?us-ascii?Q?PIayxQ9vK3nFTyR5y2ekeK8j4owTeOd6haAJIkV8W3Uk2oMe093BLT8bDMcQ?=
 =?us-ascii?Q?8ryUE3lVPPah9SzP8p97ljU+ciNBjazyS0KhrFhiE5jPtAs4z5RpUG4H5E+6?=
 =?us-ascii?Q?0KmUWnGYaeIMXZRGHayBMyNOqL350m6yh9Uf4FqoHOeO2nQkdI5QQjW1C0/u?=
 =?us-ascii?Q?9nejh6YodEfKr+DgM/SfCOTZxoQWXYLcYtNbbS5IiT5nY9wg7wdk3vYSF3Ho?=
 =?us-ascii?Q?1zU3LQTF7SO4HxgK+sQVtIm9bLjXbjq/Ejjp1VNYw0++VJqWXZzjGCnBYfy3?=
 =?us-ascii?Q?6m0lfByqaUfZQ68dC8BeoftWffrbeGKclHLo0Ztu1Aw0eT0nQlAdPkekvaZo?=
 =?us-ascii?Q?YwrHY+yxp/TJUv3wiCp1WvnKs7vl4GEie9e9CsJi/ohzZNCQKOR2ZqEqkj/U?=
 =?us-ascii?Q?uW7J7OsE/YLV+1E+AN5HQ+fDNO2OEUeJc74JqvVb37UMDJHn9gbwW/91sxtj?=
 =?us-ascii?Q?Th4stedQ7NXEQcUb1JI9VGwNOmZGqzbp9xsn563hupISTjeb6h5lU8/tizIu?=
 =?us-ascii?Q?C7aL8hG621IT4xgUtook7xdSwFdSp5CmUxrKwXBCCmSrkmwn42RE2EIN1NND?=
 =?us-ascii?Q?qbwrIHIyjv2JTjmrrEeSFvuF/cN6byUbHmtKYo6OlFb/ghEMFEtAx2UeUBwc?=
 =?us-ascii?Q?1136BWRdpECwWNHphBDp+JiCucI7OtVO82lFQztTdT0A6MI6qLL5N4yHA5id?=
 =?us-ascii?Q?BXED0IxeBLRCrBIWmgWVl/r5B4VwdKw2q/KX2PaAYAzX8pDnpsrUuwX55J76?=
 =?us-ascii?Q?Y4BdE6YDX4p5mW1F17LvWIdhCoXctOGDQQ/gCtgexZtX6HXs9fLTbDvAg35H?=
 =?us-ascii?Q?FgnEKv9fg/ss3v3CUgEUc74FRq594fP/+Fxc1raEzf8DJobJqA3SjRhGnXwI?=
 =?us-ascii?Q?n5XceYprEP+QYevTnugP06TbL4LIclvPxMcjORCd4yc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd0ae0b-f4a5-411f-67c5-08d8b4289353
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 22:56:03.4784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: loEPuthsX+rFK/BRyOE1rNqs90GfeQcpJFwk9tPUYlemG8qYOU1byMPf4y3v+WzvtLoMVw78HYSULuGcKewZjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2749
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subject: Re: [PATCH V3 04/25] smartpqi: add support for raid5 and raid6 wri=
tes

Stg s>
>  struct pqi_raid_path_request {
>         struct pqi_iu_header header;
> @@ -312,6 +313,39 @@ struct pqi_aio_path_request {
>                 sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
>  };
>
> +#define PQI_RAID56_XFER_LIMIT_4K       0x1000 /* 4Kib */
> +#define PQI_RAID56_XFER_LIMIT_8K       0x2000 /* 8Kib */

You don't seem to use these, and you'll remove them again in patch 06/25.

Don: Removed these definitions.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 6bcb037ae9d7..c813cec10003 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2245,13 +2250,14 @@ static bool
> pqi_aio_raid_level_supported(struct pqi_scsi_dev_raid_map_data *rmd)
>         case SA_RAID_0:
>                 break;
>         case SA_RAID_1:
> -               if (rmd->is_write)
> -                       is_supported =3D false;
> +               is_supported =3D false;

You disable RAID1 READs with this patch. I can see you fix it again in 05/2=
5, still it looks wrong.

Don: Corrected

>                 break;
>         case SA_RAID_5:
> -               fallthrough;
> +               if (rmd->is_write && !ctrl_info->enable_r5_writes)
> +                       is_supported =3D false;
> +               break;
>         case SA_RAID_6:
> -               if (rmd->is_write)
> +               if (rmd->is_write && !ctrl_info->enable_r6_writes)
>                         is_supported =3D false;
>                 break;
>         case SA_RAID_ADM:
> @@ -2526,6 +2532,26 @@ static int pqi_calc_aio_r5_or_r6(struct=20
> pqi_scsi_dev_raid_map_data *rmd,
>                 rmd->total_disks_per_row)) +
>                 (rmd->map_row * rmd->total_disks_per_row) + rmd-
> > first_column;
>
> +       if (rmd->is_write) {
> +               rmd->p_index =3D (rmd->map_row * rmd-
> > total_disks_per_row) + rmd->data_disks_per_row;
> +               rmd->p_parity_it_nexus =3D raid_map->disk_data[rmd-
> > p_index].aio_handle;

I suppose you have made sure rmd->p_index can't be larger than the size of =
raid_map->disk_data. A comment explaining that would be helpful for the rea=
der though.

Don: Added a comment for p_index.

> +               if (rmd->raid_level =3D=3D SA_RAID_6) {
> +                       rmd->q_index =3D (rmd->map_row * rmd-
> > total_disks_per_row) +
> +                               (rmd->data_disks_per_row + 1);
> +                       rmd->q_parity_it_nexus =3D raid_map-
> > disk_data[rmd->q_index].aio_handle;
> +                       rmd->xor_mult =3D raid_map->disk_data[rmd-
> > map_index].xor_mult[1];

See above.

Don: Comment updated to include q_index.

> +               }
> +               if (rmd->blocks_per_row =3D=3D 0)
> +                       return PQI_RAID_BYPASS_INELIGIBLE; #if=20
> +BITS_PER_LONG =3D=3D 32
> +               tmpdiv =3D rmd->first_block;
> +               do_div(tmpdiv, rmd->blocks_per_row);
> +               rmd->row =3D tmpdiv;
> +#else
> +               rmd->row =3D rmd->first_block / rmd->blocks_per_row;=20
> +#endif

Why not always use do_div()?

Don: I had removed the BITS_PER_LONG check, was an attempt to clean up the =
code, but forgot we still need to support 32bit and I just re-added BITS_PE=
R_LONG HUNKS. These HUNKS were there before I refactored the code so it pre=
dates me. Any chance I can leave this in? It's been through a lot of regres=
sion testing already...

> @@ -4844,6 +4889,12 @@ static void
> pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
>                 PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
>                 sizeof(struct pqi_sg_descriptor)) +
>                 PQI_MAX_EMBEDDED_SG_DESCRIPTORS;
> +
> +       ctrl_info->max_sg_per_r56_iu =3D
> +               ((ctrl_info->max_inbound_iu_length -
> +               PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
> +               sizeof(struct pqi_sg_descriptor)) +
> +               PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS;
>  }
>
>  static inline void pqi_set_sg_descriptor( @@ -4931,6 +4982,44 @@=20
> static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
>         return 0;
>  }
>
> +static int pqi_build_aio_r56_sg_list(struct pqi_ctrl_info
> *ctrl_info,
> +       struct pqi_aio_r56_path_request *request, struct scsi_cmnd
> *scmd,
> +       struct pqi_io_request *io_request) {
> +       u16 iu_length;
> +       int sg_count;
> +       bool chained;
> +       unsigned int num_sg_in_iu;
> +       struct scatterlist *sg;
> +       struct pqi_sg_descriptor *sg_descriptor;
> +
> +       sg_count =3D scsi_dma_map(scmd);
> +       if (sg_count < 0)
> +               return sg_count;
> +
> +       iu_length =3D offsetof(struct pqi_aio_r56_path_request,
> sg_descriptors) -
> +               PQI_REQUEST_HEADER_LENGTH;
> +       num_sg_in_iu =3D 0;
> +
> +       if (sg_count =3D=3D 0)
> +               goto out;

An if {} block would be better readable here.
Don> done.

>  }
>
> +static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info
> *ctrl_info,
> +       struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
> +       struct pqi_encryption_info *encryption_info, struct
> pqi_scsi_dev *device,
> +       struct pqi_scsi_dev_raid_map_data *rmd) {
> +
> +       switch (scmd->sc_data_direction) {
> +       case DMA_TO_DEVICE:
> +               r56_request->data_direction =3D SOP_READ_FLAG;
> +               break;

I wonder how it would be possible that sc_data_direction is anything else b=
ut DMA_TO_DEVICE here. AFAICS we will only reach this code for WRITE comman=
ds. Add a comment, please.

Don: Great observation, removed switch block and added a comment. Set direc=
tion to write.

> +static ssize_t pqi_host_enable_r5_writes_show(struct device *dev,
> +       struct device_attribute *attr, char *buffer) {
> +       struct Scsi_Host *shost =3D class_to_shost(dev);
> +       struct pqi_ctrl_info *ctrl_info =3D shost_to_hba(shost);
> +
> +       return scnprintf(buffer, 10, "%hhx\n", ctrl_info-
> > enable_r5_writes);

"%hhx" is deprecated, see
https://lore.kernel.org/lkml/20190914015858.7c76e036@lwn.net/T/

Don: done

> +static ssize_t pqi_host_enable_r6_writes_show(struct device *dev,
> +       struct device_attribute *attr, char *buffer) {
> +       struct Scsi_Host *shost =3D class_to_shost(dev);
> +       struct pqi_ctrl_info *ctrl_info =3D shost_to_hba(shost);
> +
> +       return scnprintf(buffer, 10, "%hhx\n", ctrl_info-
> > enable_r6_writes);

See above

Don: done

Don: Thanks for your all of your great effort on this patch. I'll upload a =
V4 with updates to this patch and the rest of your reviews soon.

Thanks,
Don Brace=20


