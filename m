Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA311C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 06:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbiDBHBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 03:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiDBHBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 03:01:21 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6952264BE1
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 23:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648882770; x=1680418770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W/v3wIIerYNfwO5uy0CoW7FVoJG4QknWhegwZHPNKAk=;
  b=oGB0g4bY2OUXsZ0eELCEND93HMHX7hHKDB813eVzxknP4AiT1stLLHII
   s7EAvD6A3+jck9JvRADHSO3sE8svzLoxRToWccZVQid5rZ3lrS+/g97wM
   NZafeFNKPowAJmkYzb/Dko3280/Cpwwe7poZPrtAIhTUCnZt8+o42dX7W
   Ehp3z1quXt71Mc0XeiNjkNkeHkaDKJacFIO5Zd980HiCq0Hs7flhkfZHn
   SyBcxwNE1YpDzv4jYg+BwCLjhhCCg23/Z4GMpChurUohAf9AAcCQKqCmq
   WNX8Fbjdi7jUjMN4T9A3WNAw50GH3hneWCN1211KnfyrO40gvj6+y+iug
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,229,1643644800"; 
   d="scan'208";a="301060012"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 14:59:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXjfxYPi5GJ9QOOEJgD86XA32WQwhQD61dqOu05rIjpW/wBk4Y/TfmPN/KFuLUFr4ETtXWUklYqV4tuv0bUYQ2RVkxxKwLhnbeqyKBdCfsO2G2W+NJnAo/+OzOl1kdMXMaiB47ClYX6iTf5xk+hU/8zu5Y7W3CEW7MwtCKRom1mMFdwOx3oQcnNucaenm3v8BweZZfidWJvj56ev6bvP9UscB5KnDZzObbnetGnqxHmFKCosMA+2MeZ56RFhRPy+UlfB4vzM41lX3Z+CxizKg2GPeQjbpD/0HxtEK3w9p5xKbdQBbrl6mnOVuuVFrOgLbNVqsmqfWNmmlNitK1ftww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzQoBDe7ITVh3NhtVMmVvfND/ZNq3HJyUsqXe0M0rpo=;
 b=mJEQYnhhwA4wLF/fkpWjQGUE1Xcty6eVYfr7O0MxDUNjMTDDTdbTcQrg2SD4lm4juhR5k2w3yBMPfrSB19869G6GmknuS9vxeYvDpgRW8QGn90xsL/Fu8nZUlnc5ZJJQbCHZuaf30njeQVEn/hI8vu+OnPUF+HfV9ftlBXrok136v4p7Af8bYGRKRJfCbj7MbOYP9WXL3FlY0eTowvnV1e119nK2eNgzOIg84u/PFHsXx1OsXhmAsN6X+X765d8lNKkc7WNnxQi5IFPEeejelzksHzsA7Z0tqoAOXw9dam3Jm2OSxlcp2F+DXnXFvmYzfHpNsXZRxTKts/+DZgOtSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzQoBDe7ITVh3NhtVMmVvfND/ZNq3HJyUsqXe0M0rpo=;
 b=D66Au8jPUErtkT0Es8AcQhrKM9E18QWAmGO7BwNtruEgiAQXy6Eg/wn1LkbIihG5XddZiu2pCsyfvl5MkWHDj9mnDldf5UuP+4nOlGDfQBzqpHnLjOa8UEsa87QhEftpHEori98/MCntHUNnyvBjsHUVhN4Cnhs4BpVHecoKCzE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7245.namprd04.prod.outlook.com (2603:10b6:a03:294::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 06:59:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Sat, 2 Apr 2022
 06:59:25 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH 11/29] scsi: ufs: Remove unused constants and code
Thread-Topic: [PATCH 11/29] scsi: ufs: Remove unused constants and code
Thread-Index: AQHYRU/S9rh8DmXsr0KXnFq5JED5x6zcMxZw
Date:   Sat, 2 Apr 2022 06:59:25 +0000
Message-ID: <DM6PR04MB6575F371F794F5AA28FCCB33FCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-12-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c92175a2-877c-4a89-e00b-08da147652ee
x-ms-traffictypediagnostic: SJ0PR04MB7245:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB72459ADCBDA757A3B4198064FCE39@SJ0PR04MB7245.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1FmIL2Ak3qSaECeF6BBHXJBa72m/amXTibmoeub980h/MWO6+qeyQrXW736CFt059TQeHMioMZEHEylYn3hQFhLMqecvbXRFv6UxPJB5n0pow1GVhSdcZshEioGQ4Vrc2SoEt6dHx+IsyfrK5D0GEKUQX+IB34N63ChIFEauqpFqrDEvJO1NCysW7Inaz5Y1DhSQEuxMkvPNsg8xV1lBxKYrg5rrG9kUZZHxy/n7rnshmqcMkPVg4b63f0w7GNMNE1+pHhaMylbU4COydL88M4bR56ZbNqgercjH35rIY89ePWiys/QYp1gCK8SYXyhOmu2/piJDtA3we1KOCmfbtgWyaPWc8S48jDqRb0XTLJziNpCT2NElHnsd2TmUKFgVxUg0z+yZlu5UOQL8/msiVDZnImT6hX+7T6BegiS+oXpoJ0mvMmG+s5KqOxAzNijeRlWIUpUu9UzASUWs6JKrrMAHXcWQBiNEv4a+lPSIQyx4a2aZTDjlzVd/WjN4IM4N0NqIKN6LZj/EYjFo1nV5neESeh26r/lEWzVw3sRggFfVrQpwVnVrZH82j/3aZANx2DwDGiZGlO9DpI1Lsg5+36ACx1V+FNSrJoc95sUqRLQ8KMH06d9jH6//tXJ28JrLHs1QT/l6Sw2p8OAnobXn8fuFW9tCHJULyS8KkP21krLdhPU/1u7Rkuha7CBFfq7vv/QaRlX7cxh4gOjMWJCehg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(64756008)(8676002)(66476007)(4326008)(66556008)(508600001)(7696005)(6506007)(86362001)(76116006)(71200400001)(33656002)(55016003)(83380400001)(66946007)(7416002)(316002)(82960400001)(8936002)(2906002)(5660300002)(26005)(38100700002)(52536014)(110136005)(54906003)(122000001)(186003)(38070700005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xb8avioy8oQpaU5QDrSToldYoBi2TRhley4KU9EI+Zf9lqYf9I0f3aP95ezO?=
 =?us-ascii?Q?N7W+4Bm1+WksBK4+Os/5IfnKQ/ROBs7loWSVHPPV300iA9Nb2ai7ef5x+keP?=
 =?us-ascii?Q?IE6t0XpPDXbQVblZsXC/rTGh52N+jGnhS2IRhKYFFSyp4jfz7kVsigCD1r1k?=
 =?us-ascii?Q?eE7SU54GIeIfb26WHstzjLQVR1H4kfqkgMDXVDs+e0WQkhf8X3XKOC/1UdJY?=
 =?us-ascii?Q?6QYiSYJzsLKi/8UETd55jf6gMmML2m+RvDaEATQv0g2JKJNu7ByoWkdvmz/k?=
 =?us-ascii?Q?7UUeoWsuzh+B09Lg3nt9FtGIzyjkOsajn/KkgQy0Jv0tccO/wZe1TJfPNzNT?=
 =?us-ascii?Q?AJwuxjOYQ5CN04egUIq+tVkmUl2G2WVmPgeKagZRmpnfVgCy0LGOKJgxq21e?=
 =?us-ascii?Q?mX8Ao+D5WrUZjbqTcxsIiqvm++hRgvCyr2D7QqlOHBbIjj/U6fIhDidt9Uez?=
 =?us-ascii?Q?DbGk/BhP+alhbkXvYRiVgTLyaV5ePMFxHsLISE9f9RDXR2ax9wzFBeO3sSrY?=
 =?us-ascii?Q?TjSthrm4SEz40cFiwLAhuKOKjGIYUARAQ9gxcW0RbdaXj80PPzY6L3TnU19Y?=
 =?us-ascii?Q?q8uXSu/dDn31s8DO0temeuxz82lqsjpR69l4DXgUUEQmEyDLt5yJD6sywOt4?=
 =?us-ascii?Q?Yl97yVNCIxDrhkJoo/NF8tPKqFAFbcp9j4DelD1HRrfOrKQd+O1+pF3rClFj?=
 =?us-ascii?Q?OiIIwe71TbomSBcccADYHZT82RBmImJSrCxVrAy9MacJi58SYR5K7/bIE/mf?=
 =?us-ascii?Q?9TmbRABh4Cj9AU1TCeIiIfFY7Xjk6QVDoriWESfGIIVmbjQaDdApW60o3xU1?=
 =?us-ascii?Q?04unArjSmNYb4tUmvF1ISCqwtX6UyYXMwoDhKQKkLegUjRegYhVQ7Nn5xrJl?=
 =?us-ascii?Q?XdVVnlWlDM19x5dv3KVacaKKeYFPPdp9Oz+vkUudNN2H0pEcJ+KwCZ6uik3w?=
 =?us-ascii?Q?SS/CDKMaX2T291CSpN90Ye3XcF1Mp8kliQ4igYTUHM3aQDohbw7SPpFvQABX?=
 =?us-ascii?Q?20LzhD14gbuM1JETHVVH9JM1u9TUVKKoxfKS18uN4j4/W2kJScwAV4zXtGLd?=
 =?us-ascii?Q?6DAxN+u5t7DEnXGnC6Dldc3VT4yS8ehIGgpzQ2cutCeSHkzONgvplw7Je2Nq?=
 =?us-ascii?Q?9PAb/2FxfJnS20BQkRV/TavzbDqbNy8jVeABR1UuxRGBQebXaFYqcwjUGfbU?=
 =?us-ascii?Q?oncqKtMOvDhqbnVKVHKSNjomUkhLmoPw1yscTYGdOQ/IecYBQO7XJQBAbEyq?=
 =?us-ascii?Q?VHV3IcHvA2awViDUQmdzwrWIAE1OwJLpcjGBpxh+7jsJ98psjdAJaS+nS2YC?=
 =?us-ascii?Q?CA7HR7r9dMPWgR2aVIcjEYDIqgT0motGVRT+PCxb064nZBi4Tslp9fHamm30?=
 =?us-ascii?Q?YMWFNxLaaRhq66uvAh2L5UNj5dk42mU4faQlpVbBxk80Or2uLqL+HBh6JRNI?=
 =?us-ascii?Q?u1A8oJ0zsP1cq997JPkXKWGO7+uxik2OxFdrP9mwC5a/K6fnHYWICZ1KsSMe?=
 =?us-ascii?Q?n6469Gh3d4h1Bk+jFAfBw6vv5OMpQXfDO9RMX9Wyun1U8m2SbbNOeRoE6riY?=
 =?us-ascii?Q?iabdsZ2765t9GBX17DxnfajHdU9lmLqmFGi0Y5WXAt1z/5JeBvb0RbuqcpUs?=
 =?us-ascii?Q?gqcJI2Jt68Hk58Wwo6EVo+tWZ+Dec+L07N9gVtklUS5gTQ/JFSUR9KXgs5kp?=
 =?us-ascii?Q?1KfndUwNgJa9pH14NJEbleCp5bXvqiupUpCR7HeaazOB62qwx4QfqA2DGDTo?=
 =?us-ascii?Q?YOe7NJYwRg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92175a2-877c-4a89-e00b-08da147652ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2022 06:59:25.4867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LN8dNNRO3Hhw1AboEdyiyf1KW5sNYveLuLspDL8ZeK1krK4GrUE97ufLHVuLiYL3U4EDV/42vJ+xki1IzDBjMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7245
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Commit 5b44a07b6bb2 ("scsi: ufs: Remove pre-defined initial voltage value=
s
> of device power") removed the code that uses the UFS_VREG_VCC* constants
> and also the code that sets the min_uV and max_uV member variables. Hence
> also remove these constants and that member variable.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Looks fine to me, but better get an ack from Stanley,
because he specifically wrote in his commit log:
"...
Note that we keep struct ufs_vreg unchanged. This allows vendors to
    configure proper min_uV and max_uV of any regulators to make
    regulator_set_voltage() works during regulator toggling flow in the
    future. Without specific vendor configurations, min_uV and max_uV will =
be
    NULL by default and UFS core driver will enable or disable the regulato=
r
    only without adjusting its voltage.
..."

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufs.h    | 11 -----------
>  drivers/scsi/ufs/ufshcd.c | 29 +++--------------------------
>  2 files changed, 3 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 4a00c24a3209..225b5b4a2a7e 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -562,15 +562,6 @@ struct ufs_query_res {
>         struct utp_upiu_query upiu_res;
>  };
>=20
> -#define UFS_VREG_VCC_MIN_UV       2700000 /* uV */
> -#define UFS_VREG_VCC_MAX_UV       3600000 /* uV */
> -#define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
> -#define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
> -#define UFS_VREG_VCCQ_MIN_UV      1140000 /* uV */
> -#define UFS_VREG_VCCQ_MAX_UV      1260000 /* uV */
> -#define UFS_VREG_VCCQ2_MIN_UV     1700000 /* uV */
> -#define UFS_VREG_VCCQ2_MAX_UV     1950000 /* uV */
> -
>  /*
>   * VCCQ & VCCQ2 current requirement when UFS device is in sleep state
>   * and link is in Hibern8 state.
> @@ -582,8 +573,6 @@ struct ufs_vreg {
>         const char *name;
>         bool always_on;
>         bool enabled;
> -       int min_uV;
> -       int max_uV;
>         int max_uA;
>  };
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1ed54f6aef82..a48362165672 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8309,33 +8309,10 @@ static inline int ufshcd_config_vreg_hpm(struct
> ufs_hba *hba,
>  static int ufshcd_config_vreg(struct device *dev,
>                 struct ufs_vreg *vreg, bool on)
>  {
> -       int ret =3D 0;
> -       struct regulator *reg;
> -       const char *name;
> -       int min_uV, uA_load;
> -
> -       BUG_ON(!vreg);
> -
> -       reg =3D vreg->reg;
> -       name =3D vreg->name;
> -
> -       if (regulator_count_voltages(reg) > 0) {
> -               uA_load =3D on ? vreg->max_uA : 0;
> -               ret =3D ufshcd_config_vreg_load(dev, vreg, uA_load);
> -               if (ret)
> -                       goto out;
> +       if (regulator_count_voltages(vreg->reg) <=3D 0)
> +               return 0;
>=20
> -               if (vreg->min_uV && vreg->max_uV) {
> -                       min_uV =3D on ? vreg->min_uV : 0;
> -                       ret =3D regulator_set_voltage(reg, min_uV, vreg->=
max_uV);
> -                       if (ret)
> -                               dev_err(dev,
> -                                       "%s: %s set voltage failed, err=
=3D%d\n",
> -                                       __func__, name, ret);
> -               }
> -       }
> -out:
> -       return ret;
> +       return ufshcd_config_vreg_load(dev, vreg, on ? vreg->max_uA : 0);
>  }
>=20
>  static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
