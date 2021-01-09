Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE819C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 16:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D1623372
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 16:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbhAIQ5i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 11:57:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32313 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbhAIQ5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 11:57:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610211457; x=1641747457;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iXkTJGHNRBKEZ0gwfze1rJBmPZDe4w/veUQPw3NNiv8=;
  b=tvYtoxjyy3z6Lv91Fw97H+v/nO0ktvZJiiIc2ZYguzIoI2WdXjM+0OP/
   yedjUu2aY3jMB6nOV1sU6CLmmyT+5FPFaOCUElV474nJL0ZDrTH8jiFa1
   LzE3IJNGqrWdi1B//+Rc8NbycbXvftapdywTwKodbVH+ZJOA9wxXpMy+5
   MWLDeHehU7dn/b4IIEws3bJngYmfRR/14ApDyIqekgNAZqJDE3+Ot7KT/
   RMKN7dySPBozjqn4Y5c17e/NxdTxR8xC9w4mMgXSWF3ctg6Um5K45veo3
   ulIO4UKpyfwtYk0GJ795alfqTssEIWOy20SZxPUwr647+UARMG1QYI1nt
   A==;
IronPort-SDR: tsehvpkyx/JJ+/XzH8qR8E0q5w9ZA5aFv/uZllUtfT+Aq6+cTHBU7+vbCczRWF8Am9eBI7fug+
 L4fZfpedk7206DesvymxyHdqUSMj10kLsUcu3WZGGqY5w8EAGqTf7vG7L+uW1IgKGec4bIbPKn
 3vBlBV5PxfhjHEZOCFAfotdnPV0a9xpxNQfUdCLgNFo6hoVux2p1DZFOrBYUFo2OxPme5gD1Jx
 QWRnRVvzBb8n8jL6+irvip71ogcDsJssA2NiR0iBro//fttU+CPM7s7TSdzg3EcEAD7NbdSjQc
 IWE=
X-IronPort-AV: E=Sophos;i="5.79,334,1602572400"; 
   d="scan'208";a="110414076"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 09:56:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 09:56:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Sat, 9 Jan 2021 09:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBJYbARUxp6DbKJJ5K2lpPwHoDSGmqHNMxBR4lxjpTq50h847Eq+U/PTw78i0j9tAk+ICzD6goq9+dVjLrKLB+M+bzgGo2csvzIPs/ph2OLr1gLmvVQ48FDqx63JSeqdoGlACPzJJv5XE1ahlxZLxFKHuiDpjiR0/5fEhBFeK8cNkLpD1YIXXmHoTKb9UW+FuVYiABvl74/17SXvyHKJHggI/RHSDWvnq7OAnF/Uf9DEZLoxCRyL3jyECrT7tqfBQxMJh9FlRxKtocQL2NHEWSBCibU7YTP2YOwGBt6AYb1N4RGzhKiR6vsrhbRgLvnCDsPRYhD+cjyGvLPdZsicOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwu3UzM8L5JiCM65kLW+geDriaiLMvSJXnShbaBfRR8=;
 b=hpfOeIEPoWRBgcNveEN7YBaox4GO4qRkN9nVy3qNmCAeZsnslZCcFlkLLkTM8uDt18a0cn9WrFVnyjK6j9logTxb7lMVtxG0PbzusmkKwduxd+KhKsrjck5LQ3mW7CR5SEM3O0f0iACPCj6vy06fh3+DxfZ3E/ERKx2IkaxNEaJL1molbXhiXgZJQVN770ofcjuS58bPLZnpWxBSRvUDCYdzjjLjahPpYH/ojLaxveUw6FJfiYhxUdrYiL0sYP+S4cI8f5aYOh2e7MiXpcFNVTvf3KxRI0gThQ/5mGybisYTdZo0GMxGcPSfJ7N7QucTiKWRdEfmlKE1DqEjmrjteQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwu3UzM8L5JiCM65kLW+geDriaiLMvSJXnShbaBfRR8=;
 b=vDkdzkM8IbGCat2XQ101yO2RWRcIwwpHyBy1hXj3UXKEdpjHpWNeidPFPTOjEMHTXbDCcPew086i6EQ0GpmNWsrDqW1uMz6auoEQMEt09vWuQ3l7Oo5KZaHfQaC5ub1rmTlCb3Sw6RjwvYJ+FnAKDHLPuzjUdky1hgzGXwbCsKM=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2704.namprd11.prod.outlook.com (2603:10b6:805:53::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Sat, 9 Jan
 2021 16:56:18 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3742.012; Sat, 9 Jan 2021
 16:56:17 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 05/25] smartpqi: add support for raid1 writes
Thread-Topic: [PATCH V3 05/25] smartpqi: add support for raid1 writes
Thread-Index: AQHWzzRAezDPbLuTAkiD0a+jKDhMCqocileAgAMib5A=
Date:   Sat, 9 Jan 2021 16:56:17 +0000
Message-ID: <SN6PR11MB2848E203C0D59A847605349FE1AD0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763248937.26927.6012524710393214473.stgit@brunhilda>
 <8db21f825551d9eefc9f8fd15bc9d0b877b9594c.camel@suse.com>
In-Reply-To: <8db21f825551d9eefc9f8fd15bc9d0b877b9594c.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 008fa452-247c-4e6a-7634-08d8b4bf7b91
x-ms-traffictypediagnostic: SN6PR11MB2704:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2704C3B305085C99193B2240E1AD0@SN6PR11MB2704.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: del0K96PL0QHE9e6B/uezc9dbncwoWHJjfyzLd0FOnqbIoWU5+DsMZEnVXEinhkeiGAf4m1rx6rDfmuVQ1sZjKNaWN8ccQmumJphXGZ61Rz8AzPOMvTUGJDDElUB612mONUYPOYIF37T+hlNEuZ+0aeLiZwdZQSzsoW+6Fuc4h8xs43dtqEuSEoel+VOiWtBQvau6M4UbUjf5Rp4MmfiJYHDKQK2l1nsBhZ6b2L3gKg+zeE3c1SqvV+VmZeCueuj4XyU8BWoTOekmjrbJMw6te6s7okD5c7euCe42bp/u3nWrwnoKWgHbBlQzINAYfh3VutQ0KuTu6mrfEbRHd/czPOFL+/9Q2uLY2A7VDghaROWvO0dPYv19wZpO+jTvbaMDtrI0XuxavExgidJwXu4uj1Apx195O+0ymdl/g1lwz+UcXJX54DwHn7QjL0M6NU1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39850400004)(5660300002)(186003)(4744005)(9686003)(55016002)(86362001)(4326008)(8676002)(66946007)(2906002)(26005)(64756008)(52536014)(33656002)(76116006)(71200400001)(8936002)(6506007)(66446008)(66556008)(66476007)(7696005)(316002)(921005)(110136005)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FRfEy8rVYLEtnZr/h0yRUaGzHqcaMXOQqnGSAfXwiJEBTXJQGhUe60SSKlKQ?=
 =?us-ascii?Q?hpO1LO8vTbXr6JT42Noro7ltQ9MTrvjpiaMaM0OUAMOWjqwsPd/8O5yhAr8/?=
 =?us-ascii?Q?k+qwXJmiCTWs3cFyq6x1euYSf6WFEoY81otqztjT2xXxxhhIhlK4aJjjdGII?=
 =?us-ascii?Q?lYuTr0c43ZgsQNlqE4Qpznjw3Xrg9GKdt0L7Kfh7X76Rr74j+OUHQoe3iGpH?=
 =?us-ascii?Q?vLY285REZGTWGm7RxZtoRDH37jgJ0amCcNbWtoSmFftwV/IeOA7LCyRiJezc?=
 =?us-ascii?Q?GkuK93xAg8ej46JIQz62px8x54deFST6WQ1r0T47k7D9tixBwmERd89d091v?=
 =?us-ascii?Q?00OHK6ltoa3NXlfwp8PeSvVhIFgJH1PfX22FW5ecYcCM3cpHUtlGZOsTTuFU?=
 =?us-ascii?Q?4f/ORk5XyBCyI9bavC/57BXmNL54xPJofpX0ACyNjOUTu0R6PiUUWY0Y3EhA?=
 =?us-ascii?Q?Fo5Z2KmkPIB3QngrQfzZO7womFfCG+tSdDLvn/ue15ARYrwbnyraNYHm1c8o?=
 =?us-ascii?Q?+VQL+MLHov3KD4ZNnCKM7MnFaHGn7aNOF20vR+7lQLZSrEKp64pbP9OJrlo6?=
 =?us-ascii?Q?kq13nVbWQWNa6qZnwEZgyoS7APgawAYqXMWnF/8pgLzrO1Z6OugoKtkhZIjQ?=
 =?us-ascii?Q?TtIJAKZXZJ0wAL4ecGUsrF3BT8CmZZBPUu5lh3ztmAZS2e0MRt0H/dEoUdps?=
 =?us-ascii?Q?Up8jWjGTNMH4pPk4+ADaEPXQLfQ07D2vjuCt1C9f3viYtM2Tiqm1Gopow26G?=
 =?us-ascii?Q?/8UreS8ZJBMSM4D6jNwfxbGeu/0Sw3pQwMxwPB+bsw3xXjgW7INcKvh/zTy9?=
 =?us-ascii?Q?Ep5JHTLtSlwwhCMqhFh1VuDC+uL0zqB2BgJ10F1IbJaaU89pQbtEpWTwHRjF?=
 =?us-ascii?Q?pCeuvr9px/yqG7WZWYYwvPd0QOfTh8rEmiJuFl2ox10Jj2Ha/g8Y0M7NiGtc?=
 =?us-ascii?Q?v1lTqkno2lft/6PkqTDsLLDYWUqLG/Lx5pavK2+nQ3M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008fa452-247c-4e6a-7634-08d8b4bf7b91
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 16:56:17.4320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eR1o9Ug7DRvT5H2ld9VH1m1a+KweK5Zn8PWhahgfTpPKgMIkgYp3lZXxSfMGp7GMgaaJ6QTixPAWbTSbsP6t/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2704
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subject: Re: [PATCH V3 05/25] smartpqi: add support for raid1 writes
> @@ static bool pqi_aio_raid_level_supported(struct pqi_ctrl_info=20
> *ctrl_info,
>         case SA_RAID_0:
>                 break;
>         case SA_RAID_1:
> -               is_supported =3D false;
> +               fallthrough;

Nit: fallthrough isn't necessary here.
Don: removed fallthrough
>
> +static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info
> *ctrl_info,
> +       struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
> +       struct pqi_encryption_info *encryption_info, struct
> pqi_scsi_dev *device,
> +       struct pqi_scsi_dev_raid_map_data *rmd)
> +
> +       switch (scmd->sc_data_direction) {
> +       case DMA_TO_DEVICE:
> +               r1_request->data_direction =3D SOP_READ_FLAG;
> +               break;

Same question as for previous patch, how would anything else than DMA_TO_DE=
VICE be possible here?

Don: changed direction to write, added comment.

Thank-you Martin for your review. I'll upload a V4 after I complete the oth=
er reviews.

Don Brace=20


