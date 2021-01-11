Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50CCC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C13222D03
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389933AbhAKW0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:26:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54049 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389909AbhAKW0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 17:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610403989; x=1641939989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fRG/8QM84q6YH2JGZzskht1OCkRI7f/Yfyotk7Fh6Ow=;
  b=Sk1sFujaPLJ9t9NYshxuiroi4mNUyzg/EFWGmCfwNgb83VDzeT7gDSnG
   y6z1prayAAT8TR+YDqDlH4sEQPP2xzjXi9Y5H8pFxvoCm+Eq5wAhyFoGF
   DG3baUiRndXGEeR38YNSR1gIzt+VuFRVXY4b6nU6peaBwlo9ViPmcVZQ4
   qP27ttcsWhuiy2JwuNAUiqnPiVLKDw/ZHGRjP73tbg6w7UuYtVv5xzSXr
   1JDInp9lI1NnXAhtTG2qRiPUVxU9DuZ4euPSM7lK002s2sjj8a4BwemQ7
   dI2Pa/C4b02kgwwag0/n6R59u8JZtbs/tJO7SykWiC4AtoL7KNM3DYpPS
   Q==;
IronPort-SDR: vHslbUYLXwC8/Hk/UtgtnkYwP9mLREODYKFGoweYyZL9BwwEd4YLI0ODHqa3bjL/VrUNEb5Cuo
 v/4dvkZWRJ/MHSJjCnTBhHf5atKVSS1oALJtYWjMMM6XFwEWVddnnKrqeQD2ZTbVQi32KBA5bo
 Cs7nGZ5fa3emtpORsOamGYhL9M+JcWi9ugofLOhIoN/uENtgq1k2ZPwxvxE4eIgM9Tb51XBhqa
 0C/5HZ/7PAVaSYbLn5XJatYdZ80RwDneVNK5bZ9TeK47IsQDzHj0YUQJWg2cUZ91DFeJgkNZV6
 HDs=
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="110624129"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2021 15:25:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 15:25:13 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 11 Jan 2021 15:25:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5WlKa0ZdQw7tUij9AsPFPHjVPyguvcnZEg8+M8yg9ST1qa/L0gDJC0eAWgQy5I/TWM+WtGHccTrmirGOURmji0DEyY1nwxdf+GpGA5qU31/0rPpnZGqzcz4hx2rBPkFdpqoHA9WztLtR/naGany4x6nndUei3KUZweLyKUXHbuoRU0Gpzv2X/iifbO0cyjlHBU0M7RsJ/AUhYQeP0wAajcsXNGjShNuyQy0dQHWbutzPizi9YvTI70c2QbdYHhtmrkS1m5zykrHlDmOnth5FzMhKlF4m7Oe9eVa84iPwf7o2DHdQKG0CyL4VpjOgMSPmKj50Zd9a4iH3SwwQpX9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRQWDZQSjMXY0syj7Cx8PkUNp+tNk8Im1vFBsjUPx94=;
 b=PMdGjUOZHTCGRTRPs5QQrxRjFLP5yHZi/C5gWj4EztjoPpRXujH7TwZmVc1wQOZPGYznsYeha30XpfgqlyfQ3MJJJYf7wxzMs9IvlZhY7jFln8CQ9BPdQRAifwxDnQS/BEQvzxd67KdbdarYPAij01+1rRGYEj/hHGiGGYX6siv9jQopxotWGIBlG5ReOzZkLnMzb270r9vEt54gA1gpcxDThVNSa4JCsfz8ZhGIAMTbsflOpRrZ4MhJMc9cOF5XV8bS+5EnAu9nTJpB6yBHHrYEULD0TF9XtQjFHieRpAja0b8UayA/OpkPOCalKhdK2GccablORMBCPQGGCe69Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRQWDZQSjMXY0syj7Cx8PkUNp+tNk8Im1vFBsjUPx94=;
 b=sWUsGe25p6Kbv3E29K4Cgc+chZ3i5qZXQF0ovaGHjYqYufupWWU+CaeZPNqgEyT7hRtNfUMFYbj+C7MuoVePgyh0ie5aucO5s8dDarTRTP7Ym3SBxePE/DXidQEoApY5F42dowlKXcpDb5GLu9BJAOdDwohQ29c2ANtZjY+NdWs=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB5018.namprd11.prod.outlook.com (2603:10b6:806:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 22:25:12 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 22:25:12 +0000
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
Thread-Index: AQHWzzROMiB7trWULEObxemZcnHa6KocioWAgAamspA=
Date:   Mon, 11 Jan 2021 22:25:12 +0000
Message-ID: <SN6PR11MB2848D427E533983DB241AB41E1AB0@SN6PR11MB2848.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: a0cd43b8-5b7d-49a2-f3df-08d8b67fc32d
x-ms-traffictypediagnostic: SA2PR11MB5018:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB50182A37234E7DDF09DCF9AEE1AB0@SA2PR11MB5018.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bnmAG7/bIKDMKYDpkILaxF3audClDYPkajZFZk/sFHrj16drBoiBFoAUOYzv2WfU3O9pGKTfrvZzK2FEtbQbzJcFaMOneZDE43F1DPlZ+9mhYlWHwtb8ZpjhE5W/Ob6bshXWBdzMD0rifOHQJxNU5fcD8h69v1iBgTDNLk+4KaAS8nVJukFKR1vUOTxXWoUHcNAtd4gNi3MYsAL1KRbOLxmpzZ11QQth18ZW6u8AyYXv8x/Fl4mYPuU8kggrdrj6xyppsP7fu6NITre41kr+Hp207L8ct88FeyLckmqyaumJGR7rUYeoKYtttp5NlKwyZ0TqHZ5FPsw//5Pd+pUER2SpjOZZI8YDlnmPEZi36IHTUKd/IQK4vbcsfLFnneCMQ6SEd1Car0ob32el0VdJDQ27vMMU4wBTwdpFMrkrhQvNo8yzeFLJUa39gv0bEm0O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(9686003)(5660300002)(55016002)(186003)(2906002)(8676002)(33656002)(76116006)(110136005)(26005)(7696005)(478600001)(52536014)(66946007)(66446008)(6506007)(64756008)(4326008)(316002)(66476007)(71200400001)(8936002)(86362001)(921005)(83380400001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aJaPPCr2X6ZzSBQsFaRZVz/eW7NBv2ArMMH+loly1oJlTNiDvv61FfeHfPFK?=
 =?us-ascii?Q?mSxwBnbCusahfDhqb0+03Pb3IXDqTTAA+onCjg3P8KErYxvZxC8m1ezoaUS1?=
 =?us-ascii?Q?jdNgcroTGl/o/Yu+ki0WsPt8ONnY1p5U/MSEzYNYqw3HY1uKp/feIOqNQT2h?=
 =?us-ascii?Q?zQuCT7/imU/F4QcJ6q8mgU1Dy4M3eC6wzqop52SGfZdQwe50xFru2ByTwGmD?=
 =?us-ascii?Q?kYXl6HDLKRNhlreh2EO011s800hf+fQ9wmIB974vAN9m2w0bxWZx9IzhkdZ0?=
 =?us-ascii?Q?uUHVek6J2c7+yvFbUqFr4BH2nomEAr2cmPn9Zm71jPhXVvYdWwjpSwOsPR5R?=
 =?us-ascii?Q?hii2FIViKBUDxmwSKHA6/tb2mRjApSVr++++8O0xhFqpX4XUUYQNm80YDe2h?=
 =?us-ascii?Q?le+4ZPdPzofYvi4klvzGSpHnW9XwSNgN6I21+mH5MAELbvb5rKfXGenMHSar?=
 =?us-ascii?Q?juAOcL/QopBQwbb7f1KrWcqkCS1Gnw3BA8J0d2/matt3/9dXxOfC20Fkmu18?=
 =?us-ascii?Q?D7lUuKinXCQz60bPdmvguPaRZ/3hHHSYKQ1MJT73qo9VG2JRl/A62wkaCeyq?=
 =?us-ascii?Q?nXfTdrxx0k7+S1lU+agR2F0NsxpUrKrQki3hBS1RDV2jk3e8FPYAlVIUGUc0?=
 =?us-ascii?Q?cVV66GPOHr+gW+3qDVy0UtAY3O87qhyQYlRfli/brsTtpCoF5d4czGsEXVeY?=
 =?us-ascii?Q?we9ZrtOD6irydWtj1EfJZUrKgv/x+IECFT5MLo2NKef2J7SvorONSLef2Rz5?=
 =?us-ascii?Q?23E1Sm6wGGtdXFGQMGVF57iy4NmDiqDaAinJNyfg7ANVVutMfkpg/gA0AGOZ?=
 =?us-ascii?Q?zb1d+iKBtBMPThv49V805g9VRjiG8v2uw1bFAcfTagOJvtHetG9GvUuGEmvJ?=
 =?us-ascii?Q?1wKkk/ZGi4G+1IXnOwG2/Srj5CObM+K+K3MAI0GJdjLECodsNe853Ssl0Hhg?=
 =?us-ascii?Q?pXWQ6lrtDC4ovwkXtdsUJMpLjF8ylmdu8IBlHljsBmg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cd43b8-5b7d-49a2-f3df-08d8b67fc32d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 22:25:12.2796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTurNXQghwqa0MHC4tYmwwDK9fxpDQtCfguBhob1sHacnVV+630N8Xej2nPer3iqzwFctzsDGos1VGEsfnSnww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 08/25] smartpqi: add support for long firmware versi=
on

> @@ -1405,7 +1405,7 @@ enum pqi_ctrl_mode {  struct=20
> bmic_identify_controller {
>         u8      configured_logical_drive_count;
>         __le32  configuration_signature;
> -       u8      firmware_version[4];
> +       u8      firmware_version_short[4];
>         u8      reserved[145];
>         __le16  extended_logical_unit_count;
>         u8      reserved1[34];
> @@ -1413,11 +1413,17 @@ struct bmic_identify_controller {
>         u8      reserved2[8];
>         u8      vendor_id[8];
>         u8      product_id[16];
> -       u8      reserved3[68];
> +       u8      reserved3[62];
> +       __le32  extra_controller_flags;
> +       u8      reserved4[2];
>         u8      controller_mode;
> -       u8      reserved4[32];
> +       u8      spare_part_number[32];
> +       u8      firmware_version_long[32];
>  };
>
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
>         if (rc)
>                 goto out;
>
> +       if (get_unaligned_le32(&identify->extra_controller_flags) &
> +               BMIC_IDENTIFY_EXTRA_FLAGS_LONG_FW_VERSION_SUPPORTED)
> {
> +               memcpy(ctrl_info->firmware_version,
> +                       identify->firmware_version_long,
> +                       sizeof(identify->firmware_version_long));
> +       } else {
> +               memcpy(ctrl_info->firmware_version,
> +                       identify->firmware_version_short,
> +                       sizeof(identify->firmware_version_short));
> +               ctrl_info->firmware_version
> +                       [sizeof(identify->firmware_version_short)] =3D
> '\0';
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

> +                       "-%u",
> +                       get_unaligned_le16(&identify-
> > firmware_build_number));


Don: Agreed. Updated.=20
Thanks for your revew.
