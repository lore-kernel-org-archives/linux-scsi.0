Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6288C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 14:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95C3164F21
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 14:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCQOWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 10:22:51 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34546 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhCQOWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 10:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615990968; x=1647526968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aERoXEb0J10683SV6t7cHw/ssRa9wLW52tmUY65KSNo=;
  b=fiAzo61cj55DHrRsE4czUENLG6n/rTQBotQN4yM14z2MlqVAv0hIcXmO
   f7dTCC0H5YeknB/ct6zW19nL6xFFesmmvKlzQOpvR5swDqjMMMSYgWaZH
   sAj6phgRsSZWOJu735p/qKML3G4aoNRlfJczACLZm1p2n29swsw5Ap47A
   AMZdifR581GujEZycjj9VtctcUhGSL+L/1zQF7eWNsL05qm+tVzlJktI8
   WkslG2g1k70aQwHDlkwukczOCHQhnSIxHe42va4iHpLL3yyHpvvpvYlgx
   sQkbwUuP7S89sa1iaD5+iPV/oi1MVySz5m8CDK8MEBhuc61Yogb9xyBfv
   A==;
IronPort-SDR: NBRXwod9b6tYeeklOdMw3bFfGrWrJwkIirR3L8ByY1uTKnQhlEEcUZMRQGRLv5pp6CyjR2vFN/
 xPfxzLcJOx2x96li3IjJQDTOb3E6hkew5dKKNpxdwf6z9tta6EkQzU1Pk8I8QarRzcoptVe7Dl
 LsC6DtsaSEmN807Wa85awte4Qhsuu+MsiEOBQCwCMiF0MkmF7HU6dwFaOV21Qtw32khhvThyjx
 e9UngPpUzgyRiTiQECGAtLV9LAsB/1ofbx7AaLK16TmXME5Ovv+KxZuULJbNBUQBzAePvtmCOV
 zsw=
X-IronPort-AV: E=Sophos;i="5.81,256,1610380800"; 
   d="scan'208";a="163511067"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 22:22:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZBxGaG7jRijqWnHCCGdBsx1xUD+dHQNHU2fdsZXkeRIJPPmWQIe3xSnAoDXF0bB3m5e/FvU7zweSt/vxvNJKrMhAyrcNn1eQ3dbQU49oW8R1ozkfYNiFrXatDGX1fHc8pUOHXzFMDBhCIPI6C0fEzyxrVZZeUohVm69b6sCpqAT5I2N7bwOscKbyNbwyz0CJG8WnQDLNAYmsX+rkUKPvIdn2ZbX+WddwreN7e0I1KC2GbI8c1dJdYyJiqwatvI89K2IPsRxvrpUAHtwk/IoqnHZzgbBMxwsPudtAknTdepvK3Y8v7DFdVf4DwMKbzVfCnHhsRSQwSP13KQE3fwA4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqrCw9hCCvJln4RB6K3dK4ncMBg0sy0NrZ44xPBdbc0=;
 b=XIuqSRIiQq9XlP+hP0S9kyGMk1q6tD+ej41CHBsNHtjhcrXnQ2OHUHBbwV3To5o97uHMRQ1RfBPD4PY073ddThJzVjsOOeovKRlbpJXPmxJzOnocNpp8tHZNr6OKmmx4T/sNp1/ZNHxvANPC80Iq9GTpgZO4etUNvNoNl1q596/wp4oH/aHSeAVR1UJIIts9IjaMmdNeZ1HDShkWV2MkSa0bLWqGbc7nsXQ1UlsNJRjf9QIqJEavIUqRixWYWfoBMazI2SXGOVN8Y4BRL8dHtbAlRIP7CuAiStkzprd7KcunbHgZdIZazglJjXNh7InRkzUtbdVxZmmYdeuCsRnPAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqrCw9hCCvJln4RB6K3dK4ncMBg0sy0NrZ44xPBdbc0=;
 b=nn6XHFXYzjcNywhP/yLjDDBB0S90cDhriRljVIV8TefHqhLay1DTLZcqA5GjG9KYIhCCSQwYxjN+LfDPl7DlTBSiCGqFd+DsQiXvSmbKL7QUd0HiLOQKkABHQJt44Yt3cHAZAE7ZtRbPTushyhJKbJ1Q/28s2tGoR8euu7ZJDc8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0973.namprd04.prod.outlook.com (2603:10b6:4:41::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 14:22:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 14:22:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
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
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHXD2ex1y1f5g2rP02e5lIjKmzR26qIGY0AgAAGPJCAAA7hAIAAAEIAgAAbY4CAAAQzAA==
Date:   Wed, 17 Mar 2021 14:22:42 +0000
Message-ID: <DM6PR04MB65755C69AD3D64BC5B1E93D8FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
 <DM6PR04MB6575006E0682C3D11F54965DFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1d0e3c5441ecf14b6614ec0af0d30af6@codeaurora.org>
 <DM6PR04MB65750C0AE1F1EDB41EDEE491FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <37d0a4f115ad5d08ab12a76e6cbe17a5@codeaurora.org>
In-Reply-To: <37d0a4f115ad5d08ab12a76e6cbe17a5@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a47269b3-5b60-4bb0-598d-08d8e95020c7
x-ms-traffictypediagnostic: DM5PR04MB0973:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB0973809DC8A8982B71762072FC6A9@DM5PR04MB0973.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TR8AxtEqEH/Z10RmqLlMIf2TK+li6ACP5kN0ZCmpLbBzwLHs8ZH8zOIFTtkhR7YWQwAELJK8936P8QpP7W9se9hHib7vdXzaB0tMmJpSie1AAXP20pTNkbMa6OOaAzAg6m7Lc07ha1c2I1eAoHXN//ooOyTEDCLCYDjIMgqPBZCiotfDqXrcCy35V68EXZU3WT8iPH7WOA1Mp+IgnWsJetRwMVWWw+fUgO1l1ibcWAG+SVDLDolzTIljNj59GeXjC9eKRCp0PPfT/rBOLvJxx/pP0F4I5bhV+yM4AIh9esPkd1shyegLIWc1Q93TWdReBOLqZ+D7pPomM7+SteqfIts40407b6csksfv1tO66AoDET0pkz6j8CIgaFADNzW339qlqdP2VVOC5KQpZtAv7Kxw08BRttbNw+qeJhm7kWxk5dZW4WI9hB10xI+OxfHFdQGk+39oFzkIqAgH55XgSa/LreJRs/ah8z6Rhr1acRFErfpEpz/be1f9xQ0aJEFVEgh8hdSAO+kRZn4hEiubxVctGqX+ospi+K1EPiKzImZFTRdHifEZuzC5NAgSllLl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(64756008)(66556008)(66476007)(66946007)(7696005)(5660300002)(66446008)(71200400001)(54906003)(76116006)(86362001)(8676002)(33656002)(478600001)(4326008)(6506007)(2906002)(316002)(53546011)(26005)(55016002)(83380400001)(186003)(7416002)(6916009)(8936002)(9686003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8pVxAEyvdjtDrMpCjKpJWMXu/psc+lbnFY7ihTaRVaH1MEKJn8KVdJC2G/50?=
 =?us-ascii?Q?hlZ/O32ixv6HuAf8E5pKL/gjpoDovhjmwpbfTQC5SzPtfCu7AT7jGX0gSmAO?=
 =?us-ascii?Q?Uw6t1UvgtxL3FStwHpmzQjhTXbvz1BrulBs1kbe2a549Sy/xKBeRYLDZSvia?=
 =?us-ascii?Q?4PkYQ29XnYiD0agWMekcPfqKtJyOekil2gse9yc9LnheXFwW0AQFTHF93xP/?=
 =?us-ascii?Q?+fsTVJmU6TLZY7BW/3/ZLlNS2CyMXD4Lhc4slf7K02Q1YOEuZ/qTLnM7QYk3?=
 =?us-ascii?Q?lEvqgA4h8RRYovAjijsXXKDkt7WhvBoN/iQ15aTJICvEdihtL/326iydsvhb?=
 =?us-ascii?Q?fXbE4lf7KN3MNP2sqlKOvQVuSyZ9e6tuQSUYrbUjSlgm6W7SwFRwTVqxhyfT?=
 =?us-ascii?Q?/fO88ylEcUdfVAhe9n+I+AOlRA4M8AdsgSF66Blme7TnALC9PHu63ZQvnH6q?=
 =?us-ascii?Q?Kt7aPt5nxu8KfoBvkWXe8sE4t1HXRoqvNCwugNW9Ncjb3DFEZa8EmQoQjAO5?=
 =?us-ascii?Q?72haRjXIvuUmmnbgbN9GTJE9ijnxMPod3tKqfOWw3+YMm4j9o2Kqu6Wc7Zeo?=
 =?us-ascii?Q?2UR70tUpQQE2iSTxPt9GI0AqeawwHJV/D545w3dJf996bhmr8smVzPhdeo6g?=
 =?us-ascii?Q?FMwG3iQmigLhvatwYRWza7hUsC8LLg4krKsMzRLSzB5dBEVC76VtjV1UZZCL?=
 =?us-ascii?Q?bVxwI6fqNseVHolX2PA0XuikaZ9BKDtmTtsJIpnz4cTZ4o/uotWDsIPFFfn6?=
 =?us-ascii?Q?XbSxmbIrLD1yZECPfYLjVQUdw5m+R6oZMozRY9vv+c3L8LCqU3boTfjpaOkn?=
 =?us-ascii?Q?+YUYknjDCq0dgHlvdBs6f2KrECJChoFDGhunoHafxofHSMnob8cNCMSH5naL?=
 =?us-ascii?Q?t/TevUmmQ46yBgKLWJtKrDxpQ5RAmmwjRTfjSfTogq9CENq2+g4RPqyUubtD?=
 =?us-ascii?Q?cODO55dSCnw7UMhex2XFcP9U4HgGwthq8bLel7lkerWj3uOqWGF50/S5NvwJ?=
 =?us-ascii?Q?Cn4e41AnHS3xlkaNRu4n9MwvPllek78sk5vaOOfnTB5fthUhtzxNBBR9zTxE?=
 =?us-ascii?Q?VF+R2LOqJDkU/nQqkPNmYdSx1qf8PI2LPm/v9DR8jRWTZv17vkMfT90keoG+?=
 =?us-ascii?Q?AgH5lCz5d5ZDpYURBw76uh5J3ZhZAH7pQycPQHTmomr5aw1eRkO6WVzQpVmC?=
 =?us-ascii?Q?GjxA9/l2WoDd/7xYzwawsDw/jm8BnN+r4cPCd5+VHAIZgYAxTmRdKO8ca8b3?=
 =?us-ascii?Q?kxbRCZ442n4nTFrWogPW3lESA2/37IABl5ZjwOcdlQKuzxVeIic20XwMe2Zx?=
 =?us-ascii?Q?jUJmSm04ZRXed4pHC1i1Kunc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47269b3-5b60-4bb0-598d-08d8e95020c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 14:22:42.7734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9L237KpKE0qVXBsv2T1QG1Xtgif5uwaJo858pZ40z9L7c1MdjR60d5qCSdaxgC9TLeniD4BH6uR0Kh8/zV6yZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0973
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> On 2021-03-17 20:22, Avri Altman wrote:
> >>
> >> On 2021-03-17 19:23, Avri Altman wrote:
> >> >>
> >> >> On 2021-03-02 21:24, Avri Altman wrote:
> >> >> > The spec does not define what is the host's recommended response
> when
> >> >> > the device send hpb dev reset response (oper 0x2).
> >> >> >
> >> >> > We will update all active hpb regions: mark them and do that on t=
he
> >> >> > next
> >> >> > read.
> >> >> >
> >> >> > Signed-off-by: Avri Altman <avri.altman@wdc.com>
> >> >> > ---
> >> >> >  drivers/scsi/ufs/ufshpb.c | 47
> >> >> ++++++++++++++++++++++++++++++++++++---
> >> >> >  drivers/scsi/ufs/ufshpb.h |  2 ++
> >> >> >  2 files changed, 46 insertions(+), 3 deletions(-)
> >> >> >
> >> >> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.=
c
> >> >> > index 0744feb4d484..0034fa03fdc6 100644
> >> >> > --- a/drivers/scsi/ufs/ufshpb.c
> >> >> > +++ b/drivers/scsi/ufs/ufshpb.c
> >> >> > @@ -642,7 +642,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct
> >> >> > ufshcd_lrb *lrbp)
> >> >> >               if (rgn->reads =3D=3D ACTIVATION_THRESHOLD)
> >> >> >                       activate =3D true;
> >> >> >               spin_unlock_irqrestore(&rgn->rgn_lock, flags);
> >> >> > -             if (activate) {
> >> >> > +             if (activate ||
> >> >> > +                 test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_f=
lags)) {
>=20
> Other than this place, do we also need to clear this bit in places like
> ufshpb_map_req_compl_fn() and/or ufshpb_cleanup_lru_info()? Otherwise,
> this flag may be left there even after the rgn is inactivated.
I don't think so - may cause a race if device reset arrives when map reques=
t just finished.
Better to be in one place.

>=20
> >> >> >                       spin_lock_irqsave(&hpb->rsp_list_lock, flag=
s);
> >> >> >                       ufshpb_update_active_info(hpb, rgn_idx, srg=
n_idx);
> >> >> >                       hpb->stats.rb_active_cnt++;
> >> >> > @@ -1480,6 +1481,20 @@ void ufshpb_rsp_upiu(struct ufs_hba
> *hba,
> >> >> > struct ufshcd_lrb *lrbp)
> >> >> >       case HPB_RSP_DEV_RESET:
> >> >> >               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
> >> >> >                        "UFS device lost HPB information during PM=
.\n");
> >> >> > +
> >> >> > +             if (hpb->is_hcm) {
> >> >> > +                     struct scsi_device *sdev;
> >> >> > +
> >> >> > +                     __shost_for_each_device(sdev, hba->host) {
> >> >> > +                             struct ufshpb_lu *h =3D sdev->hostd=
ata;
> >> >> > +
> >> >> > +                             if (!h)
> >> >> > +                                     continue;
> >> >> > +
> >> >> > +                             schedule_work(&hpb->ufshpb_lun_rese=
t_work);
> >> >> > +                     }
> >> >> > +             }
> >> >> > +
> >> >> >               break;
> >> >> >       default:
> >> >> >               dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> >> >> > @@ -1594,6 +1609,25 @@ static void
> >> >> > ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
> >> >> >       spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> >> >> >  }
> >> >> >
> >> >> > +static void ufshpb_reset_work_handler(struct work_struct *work)
> >> >>
> >> >> Just curious, directly doing below things inside ufshpb_rsp_upiu()
> >> >> does
> >> >> not
> >> >> seem a problem to me, does this really deserve a separate work?
> >> > I don't know, I never even consider of doing this.
> >> > The active region list may contain up to few thousands of regions -
> >> > It is not rare to see configurations that covers the entire device.
> >> >
> >>
> >> Yes, true, it can be a huge list. But what does the ops
> >> "HPB_RSP_DEV_RESET"
> >> really mean? The specs says "Device reset HPB Regions information",
> >> but
> >> I
> >> don't know what is really happening. Could you please elaborate?
> > It means that the device informs the host that the L2P cache is no
> > longer valid.
> > The spec doesn't say what to do in that case.
>=20
> Then it means that all the clean (without DIRTY flag set) HPB entries
> (ppns)
> in active rgns in host memory side may not be valid to the device
> anymore.
> Please correct me if I am wrong.
>=20
> > We thought that in host mode, it make sense to update all the active
> > regions.
>=20
> But current logic does not set the state of the sub-regions (in active
> regions) to
> INVALID, it only marks all active regions as UPDATE.
>=20
> Although one of subsequent read cmds shall put the sub-region back to
> activate_list,
> ufshpb_test_ppn_dirty() can still return false, thus these read cmds
> still think the
> ppns are valid and they shall move forward to send HPB Write Buffer
> (buffer id =3D 0x2,
> in case of HPB2.0) and HPB Read cmds.
>=20
> HPB Read cmds with invalid ppns will be treated as normal Read cmds by
> device as the
> specs says, but what would happen to HPB Write Buffer cmds (buffer id =3D
> 0x2, in case
> of HPB2.0) with invalid ppns? Can this be a real problem?
No need to control the ppn dirty / invalid state for this case.
The device send device reset so it is aware that all the L2P cache is inval=
id.
Any HPB_READ is treated like normal READ10.

Only once HPB-READ-BUFFER is completed,
the device will relate back to the physical address.

>=20
> >
> > I think I will go with your suggestion.
> > Effectively, in host mode, since it is deactivating "cold" regions,
> > the lru list is kept relatively small, and contains only "hot" regions.
>=20
> hmm... I don't really have a idea on this, please go with whatever you
> and Daejun think is fine here.
I will take your advice and remove the worker.


Thanks,
Avri

>=20
> Thanks,
> Can Guo.
>=20
> >
> > Thanks,
> > Avri
> >
> >>
> >> Thanks,
> >> Can Guo.
> >>
> >> > But yes, I can do that.
> >> > Better to get ack from Daejun first.
> >> >
> >> > Thanks,
> >> > Avri
> >> >
> >> >>
> >> >> Thanks,
> >> >> Can Guo.
> >> >>
> >> >> > +{
> >> >> > +     struct ufshpb_lu *hpb;
> >> >> > +     struct victim_select_info *lru_info;
> >> >> > +     struct ufshpb_region *rgn;
> >> >> > +     unsigned long flags;
> >> >> > +
> >> >> > +     hpb =3D container_of(work, struct ufshpb_lu,
> ufshpb_lun_reset_work);
> >> >> > +
> >> >> > +     lru_info =3D &hpb->lru_info;
> >> >> > +
> >> >> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >> >> > +
> >> >> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rg=
n)
> >> >> > +             set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
> >> >> > +
> >> >> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >> >> > +}
> >> >> > +
> >> >> >  static void ufshpb_normalization_work_handler(struct work_struct
> >> >> > *work)
> >> >> >  {
> >> >> >       struct ufshpb_lu *hpb;
> >> >> > @@ -1798,6 +1832,8 @@ static int ufshpb_alloc_region_tbl(struct
> >> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >> >> >               } else {
> >> >> >                       rgn->rgn_state =3D HPB_RGN_INACTIVE;
> >> >> >               }
> >> >> > +
> >> >> > +             rgn->rgn_flags =3D 0;
> >> >> >       }
> >> >> >
> >> >> >       return 0;
> >> >> > @@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct
> ufs_hba
> >> >> > *hba, struct ufshpb_lu *hpb)
> >> >> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
> >> >> >
> >> >> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> >> >> > -     if (hpb->is_hcm)
> >> >> > +     if (hpb->is_hcm) {
> >> >> >               INIT_WORK(&hpb->ufshpb_normalization_work,
> >> >> >                         ufshpb_normalization_work_handler);
> >> >> > +             INIT_WORK(&hpb->ufshpb_lun_reset_work,
> >> >> > +                       ufshpb_reset_work_handler);
> >> >> > +     }
> >> >> >
> >> >> >       hpb->map_req_cache =3D kmem_cache_create("ufshpb_req_cache"=
,
> >> >> >                         sizeof(struct ufshpb_req), 0, 0, NULL);
> >> >> > @@ -2114,8 +2153,10 @@ static void ufshpb_discard_rsp_lists(struc=
t
> >> >> > ufshpb_lu *hpb)
> >> >> >
> >> >> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
> >> >> >  {
> >> >> > -     if (hpb->is_hcm)
> >> >> > +     if (hpb->is_hcm) {
> >> >> > +             cancel_work_sync(&hpb->ufshpb_lun_reset_work);
> >> >> >               cancel_work_sync(&hpb->ufshpb_normalization_work);
> >> >> > +     }
> >> >> >       cancel_work_sync(&hpb->map_work);
> >> >> >  }
> >> >> >
> >> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.=
h
> >> >> > index 84598a317897..37c1b0ea0c0a 100644
> >> >> > --- a/drivers/scsi/ufs/ufshpb.h
> >> >> > +++ b/drivers/scsi/ufs/ufshpb.h
> >> >> > @@ -121,6 +121,7 @@ struct ufshpb_region {
> >> >> >       struct list_head list_lru_rgn;
> >> >> >       unsigned long rgn_flags;
> >> >> >  #define RGN_FLAG_DIRTY 0
> >> >> > +#define RGN_FLAG_UPDATE 1
> >> >> >
> >> >> >       /* region reads - for host mode */
> >> >> >       spinlock_t rgn_lock;
> >> >> > @@ -217,6 +218,7 @@ struct ufshpb_lu {
> >> >> >       /* for selecting victim */
> >> >> >       struct victim_select_info lru_info;
> >> >> >       struct work_struct ufshpb_normalization_work;
> >> >> > +     struct work_struct ufshpb_lun_reset_work;
> >> >> >
> >> >> >       /* pinned region information */
> >> >> >       u32 lu_pinned_start;
