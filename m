Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFC3C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 12:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30B961A06
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 12:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhCXMp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 08:45:26 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:19381 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhCXMo6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 08:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616589922; x=1648125922;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ychxHSpozysBgigU4PEGOKRCU4d/etz6pmMiMTdfKWU=;
  b=nm7DCM44wzcKRbMr5C+h5aaKX03QPXf1Fs9p5PZd7bVBtcTtyTkneRA7
   Cjrf9qMwmX/AKNlK+Q5Ube1Nozb/5WiHK1+DWPjmDsB/AppvgqCpBmvGr
   ksdPZYJQHnBGs3xtehjcQhloSpCd8Ag/BuQn9t20TI0JTk+vaCsDDThhK
   6gcw0Nn9ZrNNNGIsaZG53uSmO1bkpyvHZtEIPF4Cu575Njo9Dae2wZQiZ
   DkzVu2suzTk1PA5X5EHCdZU/hXjHPIALF6c8g32WYypm5cmXDUwRrxtdH
   y+wQeauaxyAeQOukJoOMuEiMrkqcysDwOl8QMPNJKianOFRigZyvnX9jQ
   w==;
IronPort-SDR: Z676J+D6L2SAV2Vd3O4VETapYq2WbDP0JsjXBlFReSWfdTMaNpObVj6q4VAkhbjfIZjwqLufMq
 m0rjSP9v4nZo32WQz+I6RyNHOAXCe5YAan5cItVarMm8p5z3yvUgfK/IAXiYYbbv1Qk2mnsy0q
 22NN5TWk16maypjwjqmziAiyaVDO41maOaXjgbpncHXUiATAyb+pzJcfWU+OTMZnTVTm3ki5rJ
 WLyA6a29QFTLPcgwtkxczORDUHlVR4Fjch5DMVS0J1MBHV4u4a/T821T1n/b8C0g3b53RaENu4
 jII=
X-IronPort-AV: E=Sophos;i="5.81,274,1610380800"; 
   d="scan'208";a="267315256"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 24 Mar 2021 20:45:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaNqbsEgqNLN1btJIQz+8C6o6fI4RY9E6BqEmWkvjvJLfz0jD4pKQ+q5qym2aCv680TQmRzOjrqLgOYGDtBvoAVZzToX6gr7OVrnIrExlXf7LBvRMSC3EaNgIZ9bxOk8Q8psLAIPS0X0XH5QfVnw4cdlp0cBGzp96HHIAxTqAs0pPhVAaCkfgxcCDoIExd+fETE0bn6OhrEEVihV75hJ4VWfDdXUhrWKVJyrSnfh9heWuMsmwXR17y1mbSjYFIScKbOO6tZb9dgs8w+WLNxIJBgoUnCb/QhWATMkSvl3p1J//zL6mpyhAIfxQFFUZVPOyprZW03GM1nqrVq1Lh9guA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ehclw2l/Xq5SHlF0t9hl9mUNbartIXamGeBmO8Ikrok=;
 b=kJQxRbRMBRzk4889NUHI45gmcw+Yyri2R+MJCf5llGAKE2Ilum6oXnT9EIV6RuhKPav4DptVIvPMjdKOcoSbcryW75PgQg1IVEzACp+C7SaU3bQucKpWoSHep07nJJ6a6FcpqzFeAu/eO84Bs8uqK1M6LSNY3Gm9vENyyMjWTgoDreLgd95HeTMG1WXCiUPN1rE3hX5fKCY+ryWehNOSNB34o0UzfwB5yHksU/xDskfgUsVzjglqTII7uXt4Avv7b6A9FyvqtMnmGGYV1kiPRgyj0qvRrWbsuNtsuPsyn/UqGZpxNAIkizlW4JuXLe2a79+SgO5DUHPuF48zQViDiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ehclw2l/Xq5SHlF0t9hl9mUNbartIXamGeBmO8Ikrok=;
 b=Db/BfegLxzyfA9lsrUhsKgeKrA3WhyR2fGwmqSlfYcttLw0dI0spZpHwaVoaxaaSS9MsdSuC+3FPna2k024au7TtGQDG9LBRz401Pidp5fxhWWjnSdrUbf9lg3of2XyHeaEdCAv5BEju5jOp7B5hYcXDRIFUThecVjZ7bM1rsnE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1260.namprd04.prod.outlook.com (2603:10b6:4:40::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.24; Wed, 24 Mar 2021 12:44:49 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 12:44:49 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v6 02/10] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Topic: [PATCH v6 02/10] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Index: AQHXHvL4SUo2feYNMUG/LIqOH/XvgaqSflYAgAAH0oCAAJBfwA==
Date:   Wed, 24 Mar 2021 12:44:49 +0000
Message-ID: <DM6PR04MB657597BCF8C0E2093AA4656BFC639@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-3-avri.altman@wdc.com>
 <20210324033104.5kms7pez6arnkaoz@shaphisprc48410>
 <e3bfb8c4fcadc8e1b7f9fec0ee4d57f5@codeaurora.org>
In-Reply-To: <e3bfb8c4fcadc8e1b7f9fec0ee4d57f5@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [192.116.177.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e580120-7225-4dfd-d600-08d8eec29cdc
x-ms-traffictypediagnostic: DM5PR04MB1260:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB1260DA97DD47830BE113C096FC639@DM5PR04MB1260.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2YHFlFIydpoYFdsS5I61SSeRhrmfMAK5jEfjsn6WWJ1hswWBKgk55MtnnxkiB2NIIuiQTihn8aocXjL2Zc0AJatrqF8ekTrISXjARDfIIcUGdSRQfOq89mpFPU/Rb5zfnazCTFNsBMfPl3PmuVOijbYFY1lRWCq7GvigHverPgkaxfPrF45iRE2CzIokVyMWwE2JNIVfZkr7YsCeutcrRkBw/aCwopRUKfL1zsw7q28Icb/vIk16v/770Ko5y6p/jjmbIRxKZP2OuOlkccjlU8av4lW6q274VsCnytX+zpm1JTcCjnt02YHFo20P/IrY942BPgn3IrjS+fz0FhlA1PNdmWIEv7iJrYHbbly8Yp8TzC/KEinndHlirqcb9wmKQVTjYejKltj2IuwZ9f4N1WQ18dSvKTWI2u9zXFpmHpiVM+W+jRSf9xCgo76syKVlGusnllkKTnGIp3K5X/LPeTRr6uQFR0sftLo5rfLSefBEp2eqvmc+w/oTqmdUQmlNkl4FagFsC6fNtNK89eTOlUcUmJ1qO4EihoWnlCJq4SVjsY82Ve5MMNw65j1R7fLlwFTk6pUVp1G8mCBdYXAZU1QjzQoIZmfgTMXF+/zokx25CY8PvE/ex5BBUzo9T3VV5ERt05Kup30xWs8NYGc9n69rkcKi/ZRlPSdoAio7F90=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(7696005)(316002)(54906003)(66476007)(186003)(52536014)(2906002)(6506007)(66446008)(478600001)(4326008)(66556008)(64756008)(8936002)(66946007)(26005)(8676002)(83380400001)(76116006)(7416002)(110136005)(5660300002)(71200400001)(38100700001)(9686003)(86362001)(33656002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1PBNaoTLOrAFVbw6fq6WW9jfLVL2vIl6aBt96/+ATSXXUgof6DAL3FPGUpv4?=
 =?us-ascii?Q?Iku+NuYf/LImCNgVAu6y8x1SFMtBmcIYCbmfu3AWKx+rbfLrKE29ZyvLnWMr?=
 =?us-ascii?Q?nk4DJQI2tl1xRHQAXctjZdsSGPuHLeFt821mmKPtALmoWTOt67NT8UVi6afk?=
 =?us-ascii?Q?ZOw75QOjCGb4h7e19xjk+BkU7WJM39kZG7wH2io/YnZ+AYwBHOQyAuCC4s0N?=
 =?us-ascii?Q?wXo59G221VV40yfz08owd/Ri7Uf06+tnvJNyiC/wAiaou/21+SIB5h0uI/vh?=
 =?us-ascii?Q?134ypZJgYsH4fVSjaoeizKD6xPYA3OIajgGO17D2Wv/uvW0Mw2O3S1LF4UtC?=
 =?us-ascii?Q?xnT/d7rWm2UU/7lgSZA2ELpE1CvPdIscTJWzxUz9cIcNrLdR/BnDXqQ9NjFk?=
 =?us-ascii?Q?FOMBC4jd9SOxlwUqpXD8nHRNbfIl/Yxr69HrsqDS7HOZ9uL6oG1u1w6kiEu0?=
 =?us-ascii?Q?I6bpt60V9V72nrE5C99Ahe20RaKHYMigr9fzRtxJdGMAJo0g3FKO5qaWGnFw?=
 =?us-ascii?Q?k5PlTDZmj858+5LDheGvx8TLC1RfZDl3kDB2CSzVUdWHiQX2ZxRAeS3L9f3d?=
 =?us-ascii?Q?98Mwb/nsP/gSObBAcf1JRS2V1crO7dA6dLOM+vggeqfXiRor+c5r+Y4I+fkx?=
 =?us-ascii?Q?1O7vxvj4Ive+QzP1V/TgBJ2N8OO8AgDQJVAdZUAJIKGQq4M0JGmVBqbsomRc?=
 =?us-ascii?Q?5QMK3Jta7LzTI+mjoTICeYcCzqhvd8rMngGRU4oN+vXnJEGZNmYErvgbwLR4?=
 =?us-ascii?Q?t7BSDGH2ltg/znHJnoLuJ66SJxoPimeW0TKyQfLAVhrOfy/9ykANGqxW52EB?=
 =?us-ascii?Q?QkyIHQKrNYxbJKCoPvgY/aS88sf5rouiOgbIFSCttqpcH1Ayv8ztcFZM9ZTq?=
 =?us-ascii?Q?X9tLk+3WqDwcTWNtFp/HcNNm561cOvkst6/+LLlZnAprXOmy6MKy8uLsZ+9Y?=
 =?us-ascii?Q?QjXQA5TTLtZEm03bK++o4Vu2uGrWk3cfLQ2KE/DKwkdlcTg0H+oEs6pPnw/f?=
 =?us-ascii?Q?D3veOV4aYDAdFVNvBc4tQsS09exkVwwElN5WT3SWMOkctCCPZkp7J2muameT?=
 =?us-ascii?Q?bKUIOQ0pRrsoi7e0j//4xxV8FjL9ihLDhMQdTSFwRUthjwsdj632U2x0a9NO?=
 =?us-ascii?Q?2sq1hAOpnaIhXcY55gfZN1YXONRrhaJFn7I3emCidKLjXEGxblV2UObnPlb0?=
 =?us-ascii?Q?woPXaCTACVX7m3qQvZPlckkvUUdtKhPLvNW7vVtzW+IjDdxkPJRuXKKPfON1?=
 =?us-ascii?Q?9IAhB6U/czZTSM9Cd3FQFhoGIdbj2+DwCP2mCM6UTLWEbLWf8V5AIorrM8v3?=
 =?us-ascii?Q?O90R8sEDWKOWt7R7EQhEmJ6K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e580120-7225-4dfd-d600-08d8eec29cdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 12:44:49.4843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92Pd+fNKaK1EZjGRU4aAq//7F1zIHUQdz4dehIlcpX/PGa/NVjG8zTLSDEsx/Wv0veT+CdtQR3ZgZHU3QP5VtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1260
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> @@ -1245,6 +1257,18 @@ static void
> ufshpb_rsp_req_region_update(struct
> >> ufshpb_lu *hpb,
> >>              srgn_i =3D
> >>                      be16_to_cpu(rsp_field->hpb_active_field[i].active=
_srgn);
> >>
> >> +            rgn =3D hpb->rgn_tbl + rgn_i;
> >> +            if (hpb->is_hcm &&
> >> +                (rgn->rgn_state !=3D HPB_RGN_ACTIVE || is_rgn_dirty(r=
gn))) {
> >> +                    /*
> >> +                     * in host control mode, subregion activation
> >> +                     * recommendations are only allowed to active reg=
ions.
> >> +                     * Also, ignore recommendations for dirty regions=
 - the
> >> +                     * host will make decisions concerning those by h=
imself
> >> +                     */
> >> +                    continue;
> >> +            }
> >> +
> >
> > Hi Avri, host control mode also need the recommendations from device,
> > because the bkops would make the ppn invalid, is that right?
>=20
> Right, but ONLY recommandations to ACTIVE regions are of host's interest
> in host control mode. For those inactive regions, host makes its own
> decisions.
Correct.
Generally speaking, in host control mode, the host may ignore the device re=
commendation altogether.
In host mode the device is not allowed to send recommendation to Inactive r=
egions.
Furthermore, as the comment above indicates, we *chose* to ignore recommend=
ation for DIRTY regions.
We do so, because the host is aware of dirty regions and can make the decis=
ion per its own internal logic.
ONLY if the region is ACTIVE and CLEAN - the host is unaware that bkops too=
k place,
So we *chose* to act per the device recommendation. =20

Thanks,
Avri
>=20
> Can Guo.
>=20
> >
> >>              dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> >>                      "activate(%d) region %d - %d\n", i, rgn_i, srgn_i=
);
> >>
> >> @@ -1252,7 +1276,6 @@ static void ufshpb_rsp_req_region_update(struct
> >> ufshpb_lu *hpb,
> >>              ufshpb_update_active_info(hpb, rgn_i, srgn_i);
> >>              spin_unlock(&hpb->rsp_list_lock);
> >>
> >> -            rgn =3D hpb->rgn_tbl + rgn_i;
> >>              srgn =3D rgn->srgn_tbl + srgn_i;
> >>
> >>              /* blocking HPB_READ */
> >> @@ -1263,6 +1286,14 @@ static void
> ufshpb_rsp_req_region_update(struct
> >> ufshpb_lu *hpb,
> >>              hpb->stats.rb_active_cnt++;
> >>      }
> >>
> >> +    if (hpb->is_hcm) {
> >> +            /*
> >> +             * in host control mode the device is not allowed to inac=
tivate
> >> +             * regions
> >> +             */
> >> +            goto out;
> >> +    }
> >> +
> >>      for (i =3D 0; i < rsp_field->inactive_rgn_cnt; i++) {
> >>              rgn_i =3D be16_to_cpu(rsp_field->hpb_inactive_field[i]);
> >>              dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> >> @@ -1287,6 +1318,7 @@ static void ufshpb_rsp_req_region_update(struct
> >> ufshpb_lu *hpb,
> >>              hpb->stats.rb_inactive_cnt++;
> >>      }
> >>
> >> +out:
> >>      dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
> >>              rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
> >>
> >> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> >> index 7df30340386a..032672114881 100644
> >> --- a/drivers/scsi/ufs/ufshpb.h
> >> +++ b/drivers/scsi/ufs/ufshpb.h
> >> @@ -121,6 +121,8 @@ struct ufshpb_region {
> >>
> >>      /* below information is used by lru */
> >>      struct list_head list_lru_rgn;
> >> +    unsigned long rgn_flags;
> >> +#define RGN_FLAG_DIRTY 0
> >>  };
> >>
> >>  #define for_each_sub_region(rgn, i, srgn)                           \
> >> --
> >> 2.25.1
> >>
