Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BC4C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 05:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA2D613B7
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 05:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243786AbhDFFXE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 01:23:04 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23591 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242463AbhDFFXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 01:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617686592; x=1649222592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ooK5Xa6VOgyqbGl5rPEgL4CdzL7pCEVB++uW4GfI4sQ=;
  b=BybNynSpZzpXIT883MjdVwG3FRXKJHShKRNjeCCAMFp49BfVTIcfffhq
   drTkXfM9i3we54X8OXK2ZRhG6vJpRJ+9bPC8r70lz8jMvwCcrA8Sah3sa
   KmQ0tzjedyNGRtoCmBm/HHyh99NDCwDHMY191mf3pLdR+mfRXPebWjdq/
   FPwybaRJVk76qMd5SryIO2/jhOrozrfWsPUR6QN0iNGbpsO8QmEc1/sOY
   C/7PXVfkhvNYKmhgwVC6391pi57BjrRIAd7ermCz5C1Np2zZu+gdLK826
   BcIHWcHEpHSzpDEAatGYhe8PjUYTUW6pJk1tfkjuYEld2pOkDMtbstoF4
   w==;
IronPort-SDR: 8bUzBjJUDpRCE90lafC+DVWBzVjnysEIUD4/XepAQMbhuAoUvQyeKFpJ127Qc0NJQMejLMseui
 ttQjPtdwtFd6NmJnTU8hN/i5JZYVDoxO044VdWKl1L9ssAjjyDiLkZEdMka3ZFUsSoM40LN1UD
 AWNxs7B1llT8kYu92WA/MAYKt50286DEC95bvuOXlPo3Euz9G2+AdI95KNNcBtaJub/sooMPHr
 J7ZYyrSz8Htyc9+SGqGcznz/0Hdx0Xw+Z5zVzpwArKOLcFVOQrQKrZxtTsao6N4PAAMBxuqwO6
 DWA=
X-IronPort-AV: E=Sophos;i="5.81,308,1610380800"; 
   d="scan'208";a="268279221"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2021 13:19:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qp6k8b8Ens1u7kyxOpKNVc0XqkAARxUf22p7FzJPNG80wOSGdWCLPoVPbEj1numceVT/jJLY446tCooDqJ4COivs/BPuhBaV+pAxWiP43b30odyZeSnQitBhl2ewAgJDsCrc+QbftguAg2hOhvJpaLtdXbEgL6PUp8LuQMOz+IhmMePOMKtpOy/r+6Lg88+TiacZjwlCOb3nQftMdy4DkxVPXoy2HncvW4FeUzWf5JaoQzAeXg2KwQf/I+WR+1Spbo8oXEA7/gBVUEnmUJFOAu5KAG97APZu0czhkNMNjZNXiMkV2QurBLdWaIN+AqjLTSWp2fU9ZOxpNL8j3idOpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY7xfivgayayFE4sknTEKNlLMVqkgfizMAUVwakemrQ=;
 b=knYFVadCiAvCTXIAPFur8OrXhUqE6H/CPFpW/eAVTso1bGJnaxLm3v+NTo8vdYChQrQdjP8dlRKi3AeYm5FXnKipGs/R9neZrl4Fmsx+0WY+NO6R6c6G6ZKUyW28NNav1Nvm8saEjUofn33ycTif31gG4Wo66OKtmP/+7mnISZ2sB7/lRrf89YrgypgcYAnByFnhqkhIOGG66wLGeA2rcCNbzoPH/2b0GRofQZZNeNtlTZ2xoMu3IYBvkmE+9j6PPOK8+tDEPR82o7OT/xmcRG66Zult5zxjvNJqIoY+OMScHzIC44b855V8PZ+8AM5USG+CUOWtCELVS/ZD5lRIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY7xfivgayayFE4sknTEKNlLMVqkgfizMAUVwakemrQ=;
 b=z46eW22V0JYdcTXB9U7ut2+QaErspmYprc6MgGD/S/pnQoUzmBoi5GcxddUbO/r/zKgrPXK5mhfIFRKzO5UGIGP1LjIdyuGAPFpODwWPt4FChgmfI7YSwN1tQOCWByWOD0s06XtzB77Tx4nhouklVKhmPPZvXNmpZf2vb8g+Wqs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5356.namprd04.prod.outlook.com (2603:10b6:5:104::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Tue, 6 Apr 2021 05:20:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 05:20:32 +0000
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
Subject: RE: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Thread-Topic: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Thread-Index: AQHXJgEueLuV4ularE+yUH8qPo3IjKqm9ZCAgAAHZsA=
Date:   Tue, 6 Apr 2021 05:20:32 +0000
Message-ID: <DM6PR04MB6575719C78D67B7FA1557C21FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
 <20210331073952.102162-7-avri.altman@wdc.com>
 <e29e33769f23036f936a6b60c7430387@codeaurora.org>
In-Reply-To: <e29e33769f23036f936a6b60c7430387@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5d06247-428c-4bab-b13c-08d8f8bbb340
x-ms-traffictypediagnostic: DM6PR04MB5356:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB535674F567167A8D3693DE84FC769@DM6PR04MB5356.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mi898RwiinwKParyYFCAyy2DQbDPINaZbryJDMQEUcE0xAW+QYJyHgljU4nIMQ6A++bEyQDkUbVemRqrSxEeNkD8n9c+2ydyI+/oCyh/s7cQF3IqfH/XI+IH3jKS0UpoA4TRLrmvHWYWS5Ma4Bgvl6OIpsQ2SSM7SjCBmSV+RirXTQz2S4wFRGKZySXl7i4sjPPAp+PWX4BHgMayRqIAy2Aar5fQ/FDQcGssN8jXeSpXE2hVBq6L9HMk+H+VjuZAloMgWScU1rwANTJe+GEQFEZlkSSBVKMMxeixrcITL46H8rPRojj92JrEbHrLiAlefKBoh4tUriYB7XnkxroLBKmUNWi8DgvwowpQhUMkT/RzFgFDWKaOfXgRpPm16kyydbGSmOZbHo9dCfX7e5eHiRJ0I0gz4b5FhI9vEseWw5NfawntFIDWEBcf1SjDzhQRDzm4o9gaYPR5O5AaNkD1YpbQGADRiTulPAEWNOx33ub1wEmMvmi/kKxMMufL+yncUIz+B9UoInli7KERsa20+HN56HBGtPdajuZPc6IacDIwW6Do1m7RmJ+b5eq/e4yTKnMk+hsDmlTv1kDR3+dznOO6yBvm4qYZYoSWxCTgSQIzQtZDflwrE3x4kiV5xXyo6rcAhYvBEyr8QgtaYZT0nWDtTLgwCPVWiNYgX36y8gM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(6506007)(54906003)(71200400001)(5660300002)(33656002)(7416002)(86362001)(316002)(55016002)(6916009)(186003)(83380400001)(7696005)(66476007)(38100700001)(8676002)(64756008)(2906002)(66556008)(66446008)(52536014)(9686003)(478600001)(66946007)(76116006)(26005)(8936002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uoFBk6/B9EnNS2Wqf/DV6DqHaXsT901oxszrSFXQO3jvFAuYxEUhtiSZpV9/?=
 =?us-ascii?Q?5hQwRqzfVdG1ZdC+PXWlhI3lXPYEIcE6oDx3yxLwebjQv9zDOC8R5/WJfpH1?=
 =?us-ascii?Q?CzxRh+Wgj2qOne+5SbEhnSt9Te7wa3EQ3WhfvQFDYPGagmhklzI1fJL3otCJ?=
 =?us-ascii?Q?MoZA9GUyS9McvBEbmo2AZgdrsf/wkRLjouqPwXHMQ0V7t6rBQqTwOSNsKw1g?=
 =?us-ascii?Q?7Bs+d9C9H8A+FP9pUrU0Ir68eVGpWMJLKwjwgT02stiCBy7WpVVpIbAKM6lt?=
 =?us-ascii?Q?fc6tEL5Osd65ZP43mAr5exAm/43JN4eZQhCNNkx9iBwuW7IdQBfaOHtBsJsx?=
 =?us-ascii?Q?IomkG4ryPh7fZbF8Ry2TSUHWeQtkWzuTAA9TvWgdFGFYVwnJlXJ3jlqiztut?=
 =?us-ascii?Q?Bh5w737NjRXZHz7OhxA1uDBUpv/y1WScu7KLYH49KnSyEwrxQ7b5PBzeOO/g?=
 =?us-ascii?Q?YkYWYFKURGhSKkkPdxTrcWuZt0fBPovSrzcGgB7AMbTxLUwjuaKQrP4hVkeR?=
 =?us-ascii?Q?l48f6NX99twoGghvX6fVdhyR3R+fUL4HhawvitiPCzHn+ahXJ1bLNw+GCqKm?=
 =?us-ascii?Q?h4FnPqbSY8kFrif0vfPkz/B4JCMoqks0YWfUdRWTJ1vgMEEIYONJpDJLdHPT?=
 =?us-ascii?Q?5hzJT+k2nWvi7dke4qYaB7QVLJTuVvVaVbEt4qsjhhwRUFCB6olx5Jvwm7Vl?=
 =?us-ascii?Q?eRC+tl9iG4MoISBgmVwXOTKF1lNitUlQ2js8QkFZ+GEz6uIpWwcaAA7Fmpq6?=
 =?us-ascii?Q?FQdjbotuBpVH4IfiKUBFXJ3OFSWQLyL1vVxp+iK9YRtaPwI1czLHoNTtYuHn?=
 =?us-ascii?Q?hq34Pq62PE8NuKAy+UDqDddYJRwolQr2eGaKeSEHS77f8wE0BXOmQEAu2K54?=
 =?us-ascii?Q?7Qp6AY8v8Dj5xZJ7V+CHMdczDM/QHKX2VL9rh1AobUZIFeJipi/WnNWzWAdD?=
 =?us-ascii?Q?pDDsmDkHZMW5WTqYYhhPLbK0wAaXXQXRCEMIGUvr/nD7n7L5HV3Avwr5BKGg?=
 =?us-ascii?Q?VIfQ6SQhPfj1c27DdbIGdsyTbQKgQGOFkqF54uqag9CDmmSRaJfleOXO+0J4?=
 =?us-ascii?Q?+VBJs5ytUkah6PW2JJhdUbxZSve+YMTMvOhm0jCtfAjQq3wf6oUJ651NRZ2G?=
 =?us-ascii?Q?rqwuOPc9EgVrKS86MKtssrYEBMaZDcvXzxvVxWk2jd87mZs02zigHFOA3p9Q?=
 =?us-ascii?Q?dUg+Fbx+aKo6y+t6H4+RpMpL3i9HemqORD/jMS+1FHCz3uDVJaUDVGPFsU5b?=
 =?us-ascii?Q?VLr3bKXhgZhIve9zDK0u3slI3SHrsqAIo+/CspFMaiieyZkxs1GmKXGhdb+8?=
 =?us-ascii?Q?kAfwWF0DOcsr6CVmGZmJzUjg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d06247-428c-4bab-b13c-08d8f8bbb340
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 05:20:32.0987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RoUrMdvSiWALcsHl+RKyl1E00Qhl64eQ1svw9WHPoci/0Id+7rhU6OgU7Zw1s7S6ZLeZs4mXDdimyfGb2fkO7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5356
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > -static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
> > -                               struct ufshpb_region *rgn)
> > +static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
> > +                              struct ufshpb_region *rgn)
> >  {
> >       struct victim_select_info *lru_info;
> >       struct ufshpb_subregion *srgn;
> >       int srgn_idx;
> >
> > +     lockdep_assert_held(&hpb->rgn_state_lock);
> > +
> > +     if (hpb->is_hcm) {
> > +             unsigned long flags;
> > +             int ret;
> > +
> > +             spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
>=20
> Never seen a usage like this... Here flags is used without being
> intialized.
> The flag is needed when spin_unlock_irqrestore ->
> local_irq_restore(flags) to
> restore the DAIF register (in terms of ARM).
OK.

Thanks,
Avri

>=20
> Thanks,
>=20
> Can Guo.
>=20
> > +             ret =3D ufshpb_issue_umap_single_req(hpb, rgn);
> > +             spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> >       lru_info =3D &hpb->lru_info;
> >
> >       dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
> > rgn->rgn_idx);
> > @@ -1130,6 +1150,8 @@ static void __ufshpb_evict_region(struct
> > ufshpb_lu *hpb,
> >
> >       for_each_sub_region(rgn, srgn_idx, srgn)
> >               ufshpb_purge_active_subregion(hpb, srgn);
> > +
> > +     return 0;
> >  }
> >
> >  static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct
> > ufshpb_region *rgn)
> > @@ -1151,7 +1173,7 @@ static int ufshpb_evict_region(struct ufshpb_lu
> > *hpb, struct ufshpb_region *rgn)
> >                       goto out;
> >               }
> >
> > -             __ufshpb_evict_region(hpb, rgn);
> > +             ret =3D __ufshpb_evict_region(hpb, rgn);
> >       }
> >  out:
> >       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > @@ -1285,7 +1307,9 @@ static int ufshpb_add_region(struct ufshpb_lu
> > *hpb, struct ufshpb_region *rgn)
> >                               "LRU full (%d), choose victim %d\n",
> >                               atomic_read(&lru_info->active_cnt),
> >                               victim_rgn->rgn_idx);
> > -                     __ufshpb_evict_region(hpb, victim_rgn);
> > +                     ret =3D __ufshpb_evict_region(hpb, victim_rgn);
> > +                     if (ret)
> > +                             goto out;
> >               }
> >
> >               /*
> > @@ -1856,6 +1880,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
> >  ufshpb_sysfs_attr_show_func(rb_active_cnt);
> >  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
> >  ufshpb_sysfs_attr_show_func(map_req_cnt);
> > +ufshpb_sysfs_attr_show_func(umap_req_cnt);
> >
> >  static struct attribute *hpb_dev_stat_attrs[] =3D {
> >       &dev_attr_hit_cnt.attr,
> > @@ -1864,6 +1889,7 @@ static struct attribute *hpb_dev_stat_attrs[] =3D=
 {
> >       &dev_attr_rb_active_cnt.attr,
> >       &dev_attr_rb_inactive_cnt.attr,
> >       &dev_attr_map_req_cnt.attr,
> > +     &dev_attr_umap_req_cnt.attr,
> >       NULL,
> >  };
> >
> > @@ -1988,6 +2014,7 @@ static void ufshpb_stat_init(struct ufshpb_lu
> > *hpb)
> >       hpb->stats.rb_active_cnt =3D 0;
> >       hpb->stats.rb_inactive_cnt =3D 0;
> >       hpb->stats.map_req_cnt =3D 0;
> > +     hpb->stats.umap_req_cnt =3D 0;
> >  }
> >
> >  static void ufshpb_param_init(struct ufshpb_lu *hpb)
> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > index 87495e59fcf1..1ea58c17a4de 100644
> > --- a/drivers/scsi/ufs/ufshpb.h
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -191,6 +191,7 @@ struct ufshpb_stats {
> >       u64 rb_inactive_cnt;
> >       u64 map_req_cnt;
> >       u64 pre_req_cnt;
> > +     u64 umap_req_cnt;
> >  };
> >
> >  struct ufshpb_lu {
