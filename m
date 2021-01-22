Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E38C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 20:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CE723B00
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 20:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbhAVUDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 15:03:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21177 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbhAVUCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 15:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611345757; x=1642881757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2jlJwKbQJweO5Sf5ybQ5JYKNVOXZz/gpIrOqWi6tR0k=;
  b=ZK03fMi78bKrX0haoJbZ7K4CPVvvlsoMYgNZaGR70kqD5ukkddZ09frn
   DvRfhlAyWMCJ3FMzzb1V1+waoxdkhGdXPKFS71NqTBuseMSZnt8lU+kAQ
   0Tcsz8/t4O0SIMaGEMXFt7WAh+kUCs+qdijY9iAoG41CeOWnv77lZTByD
   QVYAqsDV1VKjKcYv9vAUplZu63FnAA4/U8PbsVrGA5hTTvTTRk+Y9ddQo
   DPrYDTY1fiVRzFjsdtiBQIcGQKIJGv+r6iRfPwznDiCXjZ4gElDbYYu2n
   +FqqRVZ+RyQSTJ+S8r0p90PWbYgFH843CtFIbFhdJv8EdNESWpTmJJpEv
   Q==;
IronPort-SDR: GazgxAvBsoxe5c4tnGgwpxR0t+lUDgfYANhpgZXGWoC+KE1BCfDxprpu6FDj9RYwH6y6fsm0fQ
 2D5wnaHePkmrLapAdjr2uzb1aHgIzKby9g9JSAli1VtV3KZV0QtLVHzhDIPVppOdud0T6fWQmA
 YdPw6FZsZN/Hw3mpZBUY+xoYcCI7TIlzQrBNPR/p7MnTsQ/BDwJDmnLos5F0ZUgk3Rnfm1U2eS
 UxfUIgMjt5WclzbcXcF7szE9GmkfmbHalj4XH9D30OcyUmvRyFcRz2klgmuTRH29LmK3mA1c6x
 Qdo=
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="106964145"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jan 2021 13:01:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 13:01:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 22 Jan 2021 13:01:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRjWwArYXdPfO7C/YRvOiuCeQgVZ4YggkqGFWs0iUHJh//nH5icgvkKnL6y6B/jII7W39km07sPlCZ/6g56f/+ID+xPshLL3ZhUPL6MwTjCKKZ2VrkZ76dHCIiXsWMnlGenw7RpqEz2Ox1FNenWZEavmuHHbmQt6QBljOAKnarGfu7K1r149Qi4SzxumysDoro1B9KQLn2+WtwXWL92a0oG3Cz/vEGavZvQLiXCtJrYI3+TyZHLj5J4QIIktBFIc9m3zqM6UpcTYFI2TGXrPMulxtqoG6VOjvVZsfQy1fFqvab4pCP/wXsnuPuNnFC3lKDmIPWYNOd4DrMtEboQYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyAD2bc1+wpC7KLGQtbZDVT/5aR1y38sEUaV4L6BaMM=;
 b=IxBfgfd8yOBdLhQe5eL6mdzjXLIucYqKsqlGF8Isf5QE9y2eCXzhy1qZJvIdkGcLaq6WRtAtoh2rSnUkT2H8xjpSRAr89ouTYDwoPIIr4vD/pBfOrifEVyYsRyrTxtQj4lydStRLfelBuZTjhf6tY4reyVebf2CJ+ZfePdC2TVRwsB7WSdPeu2QrnJC2wz+1w92ePMvWbqL2K1vmu/xX0krpl5XV89fC84NCIKVoc5JvruaM7H1jkAvANFJA+Y5x8tj17r/q6znyIcHNd+KIduELK/oRDZwzzAS0MUOPZsb2lP58HsC3bQfT1GuIbfnQiY6UWTjfe1MmlOHOcPkUQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyAD2bc1+wpC7KLGQtbZDVT/5aR1y38sEUaV4L6BaMM=;
 b=CwvZnwhPbodZYhKBCe8InghWhI64mtPehjj0RfMYSbNN/HZF9PAkyBgYDtRGZl4Jj16TPLcYOsD6aAHuPsdnJ4ciFlaL0keJFmtxUttHBcSBfvwCQGPOOf7F4iiuA977begJDzWbgeNbVEE07YT7Fpa451oeV58T/pXgmLb53NQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3280.namprd11.prod.outlook.com (2603:10b6:805:bb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Fri, 22 Jan
 2021 20:01:12 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3784.011; Fri, 22 Jan 2021
 20:01:12 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 08/25] smartpqi: add support for long firmware version
Thread-Topic: [PATCH V3 08/25] smartpqi: add support for long firmware version
Thread-Index: AQHWzzROMiB7trWULEObxemZcnHa6KocioWAgBfJTLA=
Date:   Fri, 22 Jan 2021 20:01:11 +0000
Message-ID: <SN6PR11MB2848AE6E94C45DC1EC29D57CE1A09@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763250690.26927.15055129460333690813.stgit@brunhilda>
 <e83150ef31a885a3374e287a2a7fc31967c757bc.camel@suse.com>
In-Reply-To: <e83150ef31a885a3374e287a2a7fc31967c757bc.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 526260c8-b0de-4379-f71f-08d8bf1077d9
x-ms-traffictypediagnostic: SN6PR11MB3280:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3280307333FDB6AEE8DC840FE1A00@SN6PR11MB3280.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZcPpq9ORM7JGg9vtl3RABy7MIK/w3WfJgOdFK0pKeGDGBSs7KGy/z+4/PkXtrsxIAZmvQiEkSwbGnITFgZTOi/hREZ6G92LhC/iWr1jUqTayjvafQ69didnvsqyYQ6KvmkIF6vPSsDnWuuDt7baTtoianpVkkFX3xYMxtAHcI5O+qLup9tvgeQ3U3wuyyqSAzPfmvHe+OvDahUz8g9udceg+0F/4Dj3taIZ9nRmvPXfEri7K/0XwQQ3OQ1PzOKBksVhekFyj5k0JMT6MuZkMAdmLPw9Te7u1J5x1Y+RlGtktp2inAnUPb9C1a6JMeQJYCtf2RstGLjS65D3U7VCf/ETDKsAu03LkD5UjB1uFzk9mYlXA0a2TvRwu/AYK7kRcTl6JrNkFo0gWvlRucSYgZSSHvguiE81kGPFkRKKeR6iYLwR4SnAN8HeBlcql3fWJD+GABFLUSWToM9iVMyzMqHaMK/tcOnB5kGsWyN9F7c8aO4fmcGcQesei2+Hrjxgpnv+U2g5s9dO0TjOziA+ZNf0HgkjT31D32lR1Ua8DYsAHIBgvmnNmSiUpi7OFw+BX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39860400002)(366004)(346002)(5660300002)(26005)(66476007)(66446008)(66556008)(8676002)(76116006)(55016002)(921005)(8936002)(71200400001)(9686003)(52536014)(33656002)(64756008)(66946007)(478600001)(186003)(4326008)(110136005)(2906002)(86362001)(316002)(6506007)(83380400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iWhujIivXAHxXXzD/3ZEDyulgdLEdHISbUGrjfMuSBjxQj7kMO8Wi8uZxk7f?=
 =?us-ascii?Q?g3eTSNRJT1hS4/lbxlocoz6MzyVYUE6+0/vS4zidnCNZr34yJkfECuMr8vFO?=
 =?us-ascii?Q?b696/sxbxucxvD20cja/BVrLHPLMdpctOp5aQVmVwGM2F1bCVNctPU63Jgho?=
 =?us-ascii?Q?cpLB6x9KXi40UUMMSgDfr4XKlrMB6DIyQDlsTxkDpmgE/NdaBLlDoSbtSIwR?=
 =?us-ascii?Q?y9L6Ss1WsoVp+8dLy85O9AT84KG6hm/bplXuA1PVlzTSHT4KXdqnJ1n81QTy?=
 =?us-ascii?Q?2HUD7oPGXIDIsNOhfagQ83wya2WDxdwC8MNZVW5K1pJbrIRFfq33dMIwSdmc?=
 =?us-ascii?Q?4owURbbNR5PficlrIXU+L0QXn3tGsVBywKG6tKIq07dH7lMAb3N4k+iHrsqf?=
 =?us-ascii?Q?ByiSAVlXKCarHpghkO5IfRsaUlUM9gi08s5YsLfqf1lTdG/REK5VMOJpBBb8?=
 =?us-ascii?Q?32TtYpthb9jvWpLTZxOB/7oYCOsHl0eyB457bUVErRdCar/tDCNsCP7WLMVz?=
 =?us-ascii?Q?8FdUMkSgt1noC6DVg0g8hj/PXFH6mr6W0LuU36zllre3u2VD6xhytOKzfbMe?=
 =?us-ascii?Q?A/XAq+1/9JVDu6iTzLvTcf5wr+FEZJtM44IIJ4JLFLNDwb3PKq5h3UB7dD5k?=
 =?us-ascii?Q?nE8r2M6gSsVkLfz/eRvmSUW5abzgMy1uRcdSUo226LkKXWYPm3Lcq7a8fO9v?=
 =?us-ascii?Q?WrkeugbfdVCLwbWnj4wWxI1z1OldMQ27w0bo2EUw9wv8Br2R+77ym5Sa4nk5?=
 =?us-ascii?Q?fsI/fifWsiZlHGHFozzXFj1LcBPxWqu2jhQj0xMoUunaZ3ohAX5ak9kKHjMk?=
 =?us-ascii?Q?k7B2WYX9GW33WIMRC26saTkXpcM5DV3k/z13mlf7pb4SbrN+gYcBPVrxUCCX?=
 =?us-ascii?Q?IJ6kQnptKqgHkjcaH+/nWZiPgTvq4ofwWqxFm5a3HMY7QzDJB9Q1enpXKxlo?=
 =?us-ascii?Q?zj+v3kUWoBndc+vXx0PHMVv/xwVVvzdQXlTFpOmNha/3S2JymZca33VCbggx?=
 =?us-ascii?Q?jtQgjPEnZXfDuTp45aTDsQOo+ETGoxsU5YVYj0/Q1Gq4RcSEia/8s3ngNa2D?=
 =?us-ascii?Q?eKTIjpWF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526260c8-b0de-4379-f71f-08d8bf1077d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 20:01:12.3130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gZyCshnvm4mgQfkwdVApKYiXORWn7R1p+qoWKJ0fTbzKM3BKg5fPmZeFthie9w9qmTo/HSz9irtTnejd1dPWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3280
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 08/25] smartpqi: add support for long firmware versi=
on

> +               snprintf(ctrl_info->firmware_version +
> +                       strlen(ctrl_info->firmware_version),
> +                       sizeof(ctrl_info->firmware_version),

This looks wrong. I suppose a real overflow can't happen, but shouldn't it =
rather be written like this?

snprintf(ctrl_info->firmware_version +
 sizeof(identify->firmware_version_short),
 sizeof(ctrl_info->firmware_version)
 - sizeof(identify->firmware_version_short),
 "-u", ...)

Don: I updated the code to match your suggeston.
Thank-you for your review,
Don

> +                       "-%u",
> +                       get_unaligned_le16(&identify-
> > firmware_build_number));
> +       }
>
>         memcpy(ctrl_info->model, identify->product_id,
>                 sizeof(identify->product_id)); @@ -9607,13 +9615,23 @@=20
> static void __attribute__((unused))
> verify_structures(void)
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 configuration_signature) !=3D 1);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> -               firmware_version) !=3D 5);
> +               firmware_version_short) !=3D 5);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 extended_logical_unit_count) !=3D 154);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 firmware_build_number) !=3D 190);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               vendor_id) !=3D 200);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               product_id) !=3D 208);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               extra_controller_flags) !=3D 286);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 controller_mode) !=3D 292);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               spare_part_number) !=3D 293);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               firmware_version_long) !=3D 325);
>
>         BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
>                 phys_bay_in_box) !=3D 115);
>



