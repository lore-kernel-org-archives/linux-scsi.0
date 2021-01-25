Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C785C43332
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 20:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E27D222B3B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 20:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbhAZF2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:28:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36439 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729953AbhAYRLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 12:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611594661; x=1643130661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RlkGnt7k+XvGYtnQoqZ/6jSGnB7+GMdScnclOKjPm7M=;
  b=zofMO7ypjWoem+c0WqUwfozsIBsNCaggdDQCMJl7r5isJQvL9GdN7KCP
   cXalBQn8iz0YE3yNlOBoZlcxv/2UgvTyOpITroAwyyZwg/zVYfVLbgG+T
   uZw+Py49ylkeNaR/kHG4wlRci0mvMoUx73vwyb9IYliISvfVJDsdvRDnB
   iYQw0xsmdJq+n2geeU7gb3PfxYnGbGCkhXP1EbUYs7ScNrGVZOpM2AWbz
   j6CaRkghCs0ZlrMcmtropqVaCDT0WGwloulWe6rg88OUUcUqktKfxrd2K
   dtwO49WMhNWAOjzymlfrWOmRt1CY5DLSjBwvhOPyePsK10P18xN+s46xY
   g==;
IronPort-SDR: 5CLEqlpQWXsHxh0aHsuSzWm2YS4Tp5Kkt/yTQyE1ut63mNaRWHVqG7EmIcI4xqiXBWy64B8GKO
 1jYJM/aS787UXQn/LoL89O50bbsjXFTQMiHtnOpleohGZtCWARATZ/tpIL5dRLP3Syd3rBQjWN
 fPJ5nzICj9Gwhld+DWHdhAIeIBGImMbyrOz6QbI+MHWbRsFhcVohr1kX/uShJgeQPsTmlED1F8
 jliXR04/otW9/qu8dOHtfrNp0wGYJquklLi2CyhQrgpEeltrS/4KQRqUqTHvRAFWQSFy7IoaC2
 tB4=
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="112387555"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2021 10:09:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 25 Jan 2021 10:09:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 25 Jan 2021 10:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPHV2l6nhgVXtSymN2vfKlvEl/0uVTrMnwfFXpk10aEPilJTUpwNMSm7pQiz/ypX3FioXaDh6ySJt8LX/JXKD6EFvPXFreOB68T5yrlN4JjTXekj145Wr+A0FGwhUBP9YDS1RaAlzTWJHhnOd+k2bxd5ZvMLJmki72F0Mt38zFPiHbzZ7MMyNCeOeeU6nHA8frlyzyNbeXMJ/ZwtRDEQFH2V/p1CAVbVzx37vCGZLGMZuhHkevGnFXO9Dm8UQMRj5aMuLHSbStxVSMV5WPYE1Clbgj5yrnj6e3yA6wxUZkluSrbj8gWZYhvGvGAOY1e9OWAe8kTct6ogc73l2ypHAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NEnZUZJE8POXqrlS6hM+TUSMUO0kF3OV0l/jqWFaU0=;
 b=WbJ4I1oMWNguJIiY8C3VfkQQMVvHOx2pl+H5jndowj6Y5xKN7rYR0zqs4lYxtCXuV975n3maFPYn4DPIJbHQnOtHlsWU4xVecCb+JIAiegMJCnZVdSFiUAvOVNSziGAqYxSThp7b26ujsHfp/jCeZMFXeau3FUtuXLZaKstrYA1PEWNeFCUT2D67VLUtaudkviVgZ6zAwX9eYorZXPU86Aq1bYM+1a9Exd2sdqusyH9EOmOP9fmzZm00gcL9mouJp9QnhgTx7pplpNk9NBYPi2hO0JC5pibBuRv9ic2FafkxV2V2HG82d49MKHidKkiMkuRm1xLZjI6WolTVFkv1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NEnZUZJE8POXqrlS6hM+TUSMUO0kF3OV0l/jqWFaU0=;
 b=CgXEOeRfA5TKeHp7GvOkfdG2HhfsE8JKcJr3//OVExJKkGP9CYnfTQ7/SGd4AOIBuMtZ/XoAUUYzctjtfDUegU6jsX+lFEzTNse34Yc92F09XzsFlnqdbdfH3gZQSVjigeoZf3QS/m5q3xSwwq0RrJ1ngaea71g+ncP33RdH2+4=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4892.namprd11.prod.outlook.com (2603:10b6:806:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 17:09:39 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 17:09:39 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 21/25] smartpqi: add additional logging for LUN resets
Thread-Topic: [PATCH V3 21/25] smartpqi: add additional logging for LUN resets
Thread-Index: AQHWzzRnQ7gZWgfv30y1/UJfpv40KKodC6iAgBD13gA=
Date:   Mon, 25 Jan 2021 17:09:39 +0000
Message-ID: <SN6PR11MB2848C7584DB2FB8EF36532A0E1BD9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763258244.26927.17723549050349595895.stgit@brunhilda>
 <2b62a04b71dfe762b7a04906b3962e690587ed78.camel@suse.com>
In-Reply-To: <2b62a04b71dfe762b7a04906b3962e690587ed78.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24195322-07ef-45a7-a73f-08d8c153ffed
x-ms-traffictypediagnostic: SA2PR11MB4892:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4892236D756529A9A5174FFDE1BD9@SA2PR11MB4892.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TB7YnX8dSPN1kMo05trjqx2br7TTm4Ibi2C6/yHiWdoDnvVmUTDOmCpdV0ZsDQ4Lso8ahlz/5LQeDcnMGyO/wq7GJF3t0Tt3aGSnnEz8x52LUYujZU6ycvZq7XcddVcsrRtMmzxMNezUOlfdFS7yUknaNXIOq9pY8Ws3o/gljGNs7iPrByVzWlSuuOxcaDfDAuh9pVp3SOCUQMA6fN+2roRgIJPUxoEYBm3qEnUYEgYqS41IGs6/KspLkukJwyzbTD/KJnEKFuDDB5RprrZVgguLfhPDfuJGt6k+kfa7wuQH+Ky+q1xNHzlGWychlFRaGFxx+VESthUoxKkHukY3GaaaBxBM8wYTQ7BPkTTO3xAKtQMOP/kvDz8kbHBqKK1BEYVpo8y3J3tBw6OCEyprTggwXcA3bfgRCpqWk88W/vHgXCaS0m1pyKJwXF+/24Te
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(396003)(136003)(366004)(66446008)(66556008)(66946007)(478600001)(83380400001)(2906002)(8676002)(76116006)(8936002)(186003)(33656002)(64756008)(66476007)(55016002)(52536014)(921005)(26005)(9686003)(4326008)(110136005)(86362001)(71200400001)(316002)(7696005)(6506007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?t9dzvJeHli7m1ZxECh2bhH3xNuProWjU+/QNr8wIwJarhnLoUqxTbh4q5I?=
 =?iso-8859-1?Q?EDGfqkgtzlslJGhVgjOTc5F+G0jUzm8CnB3Ml43eaBBywySXAzi8RISk6V?=
 =?iso-8859-1?Q?w1TqM/QsOHqbfoGW9+gsts+CIumqOrxMUzRSzpoVhAirYBn/55Uvdj6UYz?=
 =?iso-8859-1?Q?xPp7ihLepbu9I5CEoSaCXIoVK9qd+13S80n2CTfNHKZJzHPZoIopJQAuO4?=
 =?iso-8859-1?Q?elw3sTYqdASMxekOslKmjgsDpu7eh/utLLqlt8l2d/ZgimBJiPPmeFZnUX?=
 =?iso-8859-1?Q?uYdWCKdh0SYpsmGh1K9+xYapPAWDWtGX8ocQ/ZY9SrCSprezkBDmYokYjN?=
 =?iso-8859-1?Q?YqxRCZHGKEZFNn0f1tgPjFo9H1yGWM+Sgn7jgZeWzZFHeVpDpdoA1kKA1p?=
 =?iso-8859-1?Q?vfcftEQPQJytrMSI8VrCwLDkb68gWgsTOqEdWfLtO0t5Q/CXRfUhBiEPaJ?=
 =?iso-8859-1?Q?213tUjE56JTjccES7KBHiEXWInEzu050wR1UtH1SeJnxFPPsDaQe8SBoJV?=
 =?iso-8859-1?Q?yVT/Jywig/Z8+j1SIj2KXp5zoYnIbFMxfdR21+hNpzOB+APR/9F1JDwOzW?=
 =?iso-8859-1?Q?HdJ4oC/ORr0otcw9dtu2ATfCVK7yjcj/znjC91PYRSWznHPpJw2YnLHEBn?=
 =?iso-8859-1?Q?l8qGTkHktF9/hFDKyirqYLotazFIbImpC4hEYbO6k5iORBThqv/9R1JS/v?=
 =?iso-8859-1?Q?osC+ZFOoqq8JDSDW0TY38n6mQ47sKKVnHLA1+/RATiqW4f++w4zlNRJ96h?=
 =?iso-8859-1?Q?GP/Y+0/0sMU7XxDs0/Oaa8+6CAzKRZVx0Fk/iNuHy/nRo9D62YVeVVUQl6?=
 =?iso-8859-1?Q?5FOjYRbjCrqw/coyYYn9bU11KmDodrx9z5GlCPVuMxkJ+Feo4NP8GJTOcV?=
 =?iso-8859-1?Q?3HMMz5nTvXq0lIkF8EVaCYPJxyYGa5Cow6ZLsDo9VWCBs5V/9VogmfhBQM?=
 =?iso-8859-1?Q?ZozxLENMZj4qJhgnXvxieMKRhMWafp+0jinTXUBOalJu7xNaCzaPsU61B/?=
 =?iso-8859-1?Q?hgyN276mmGUpw5pdjRV36ehq44Rs4JVySMBirVz1iQBQ833WzuWQoxztJ+?=
 =?iso-8859-1?Q?3gDKCklhLmAZTLq42FOha+x1axElSUL96GQRXucrVjW+?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24195322-07ef-45a7-a73f-08d8c153ffed
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 17:09:39.1947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6L8noso5XTowAPnaVcomttt7bNtWpoKI6+vxqMmsCvk5UlOaZ/YrIG5tVi9NROcVmaKu4Bfxe5bpnpoI4AN9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4892
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 21/25] smartpqi: add additional logging for LUN rese=
ts


The patch description is not complete, as the patch also changes some timin=
gs. Two remarks below.

Cheers,
Martin

> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |=A0 125
> +++++++++++++++++++++++----------
>  1 file changed, 89 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 6b624413c8e6..1c51a59f1da6 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -84,7 +84,7 @@ static void pqi_ofa_setup_host_buffer(struct=20
> pqi_ctrl_info *ctrl_info);  static void=20
> pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info);  static int=20
> pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);  static=20
> int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
> -       struct pqi_scsi_dev *device, unsigned long timeout_secs);
> +       struct pqi_scsi_dev *device, unsigned long timeout_msecs);
>
>  /* for flags argument to pqi_submit_raid_request_synchronous() */
>  #define PQI_SYNC_FLAGS_INTERRUPTABLE   0x1
> @@ -335,11 +335,34 @@ static void pqi_wait_if_ctrl_blocked(struct
> pqi_ctrl_info *ctrl_info)
>         atomic_dec(&ctrl_info->num_blocked_threads);
>  }
>
> +#define PQI_QUIESE_WARNING_TIMEOUT_SECS                10

Did you mean QUIESCE ?

Don: Yes, corrected. Thank-you.

>
>         pqi_start_io(ctrl_info, &ctrl_info-
> >queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
>                 io_request);
> @@ -5958,29 +6007,33 @@ static int pqi_lun_reset(struct pqi_ctrl_info
> *ctrl_info,
>         return rc;
>  }
>
> -#define PQI_LUN_RESET_RETRIES                  3
> -#define PQI_LUN_RESET_RETRY_INTERVAL_MSECS     10000
> -#define PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS  120
> +#define PQI_LUN_RESET_RETRIES                          3
> +#define PQI_LUN_RESET_RETRY_INTERVAL_MSECS             (10 * 1000)
> +#define PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS         (10 * 60 *
> 1000)

10 minutes? Isn't that a bit much?

Don: 10 minutes seems to hold true for our worst-case-scenarios.

> +#define PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS  (2 * 60 *
> 1000)

Why wait less long after a failure?

Don: If the reset TMF fails, the driver is waiting two more minutes for I/O=
 to be flushed out. After this timeout return a failure if the I/O has not =
been flushed. In many tests, the I/O eventually returns.



