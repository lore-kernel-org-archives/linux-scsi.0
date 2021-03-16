Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADFAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6498F64FF9
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhCPIaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:30:39 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:64430 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhCPIaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 04:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615883409; x=1647419409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qkW88P68q2jGnI99ZDOU5kFoqcEglUhH9RukgB9Hyu8=;
  b=F3NjJ2A8ILZo9Wc8eoxDRKLwtMPhKyPN3W14F1PXNryMlamjGZOe69pC
   bFWn1l/vpq+6asUSCJMvzlqdxU/9n++z8Sy4uya8va5lvb+PUha1Pf5QU
   2IDavxSBJsDHhHOx2yaahdYhkWSIz6wWALr3rkK0kd1vLIAAqVLCBKaZ2
   Qj9udRn6OwqGlXV8BTLVpDDQBa4lLAum1fVugs/QWuuUaEHpf8vsSZ9q1
   BTs+4cUQJ1sJ+L/jYk8izDhvJ4gzmXxSdO5StKllfrCzyfk9hY4b/4TdS
   I+KQ6fssDltCsdUhfFEEOMoK3bjY7l7nv2eQZoyUVpqS2BEi3S6TopUie
   g==;
IronPort-SDR: UtHwOUsXTLCXXlDM80oxgmYqGYFLrlNbZCMIv3kOqNKcTySv6aicBiI0zNZ3lgf3zZ2GSYTjyB
 vrHOwzfKQx5XujyxgqtHyG4+1MsxMbZxpn9VBP9FE39fJI93eIdMRnNR4SBA3WPctX9y2ixQMQ
 GlGPu5/oz6cAB3aHZYu9l3qN2o0iwm5g8HkY5GGSLReyMT93IDYmsf0zpb4lo5kuwTnLYurlVC
 +QqvTzPPEiagwKT4KLkqGnz2XLCYqO1BS/C2UiQAKOhnq9yba6s7afn/BExFUxLyvsS/ZSj/q+
 7NM=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="162254322"
Received: from mail-sn1nam04lp2058.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.58])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 16:30:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlCYEycs1kHbTj6DveGWrMAgBGk1ZR95TV3gzU/xIbK1408NsDge/0htgYkBPMQI6uasZAqYtp1zygVnwic1mPWzX4K8WnC/IfvorGOYbGIwFjuGO4+Qt7mDaM1BUc280oXV4a36vmRio0S8m1yrrf20+SRS/RUU3THLBOK7gKT7H0yOSOZCha7F2VDS97O4QLHvP52QfuyigIdOi4kZoLxsM+TsrPKPARu7JnXxgNzlj6Nqyp3Gz1mQN6FejYzUGqql7InpnxCpX/HeWIvPzd1qumMf9/WLgmYlnGiqFObJnDit7O3rJVfXAbJSZEHQWgng+Q9cq6Sz6ZhDKIlG4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OpOdMg5rb6LlLSCrX4WKssD68vWcdcyl7xKVOevMBE=;
 b=Tx+JUNFhhFainG8sfEyntyD5F3ghQXWeqCCJAUIzJWY4fDRbj/Xfb999AtYn1l7E0898QYayFxNVi/X1sfSQOUpclN+A5kmkX2AietAvNlG0KfmMf52I50jlfZ4wFuyFUaSfBwdB2N0k+itnJs+y1vMJqwjPpcHRrH1HBnLl2zV/jcMoO5RLzDNbvsxEDY2Kyn8L/qr/D7tmmehTVbfGlpkz5yLguF1+d2YyK4D/kv1mVV70CyM5QET3l09CZP3nat+2Ehm/regfaVJOglETwnHerRazRpqiwBvefht+V8x8Rlmd37lzJVsYUYkIs7442HV3bxap99ZxRjezJE46sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OpOdMg5rb6LlLSCrX4WKssD68vWcdcyl7xKVOevMBE=;
 b=sFfq4s48JF/FlmeYVPkd32JWJl4Q97pVIRKNyuAnTG6745TLdmdjm9O2BXYNMMKFxRtE1kchcZaADRG/ZurlXoVJo06W0w/tKdh1wWbgn/gnVKYrrwuhAC8vgYYBw5+caPKrtbHV0cMvxPUR9jkLLqzvnlaBCurOQZulO3LKW2s=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5019.namprd04.prod.outlook.com (2603:10b6:5:11::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 08:30:06 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:30:06 +0000
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
Subject: RE: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Thread-Topic: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Thread-Index: AQHXD2erjujwThfcjE6SijSHmiAch6qEgT8AgAA66gCAAaEBwA==
Date:   Tue, 16 Mar 2021 08:30:06 +0000
Message-ID: <DM6PR04MB65751EE32D25C7E57A6BABE8FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-6-avri.altman@wdc.com>
 <25da7378d5bf4c52443ae9b47f3fd778@codeaurora.org>
 <57afb2b5d7edda61a40493d8545785b1@codeaurora.org>
In-Reply-To: <57afb2b5d7edda61a40493d8545785b1@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2fafa841-f2ce-482d-5e20-08d8e855b422
x-ms-traffictypediagnostic: DM6PR04MB5019:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB50196DCF895D2E730412D416FC6B9@DM6PR04MB5019.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ClFbzoxgSXX5eOwdV1I0nWIoXSwDEcOrGBuBQKZV8Hvc3kymFO7ISUN5X9FeYNfy1x6kwVHRhFgFD1pFnaUcYIPTroLQtZ/XqDkJqsWh6LY8QmC/z68XywssRgFuzOXSd8RqH9moStNnD+IhyQhCJW98pEdN5BFbmbTpfZ+q3oenFK8D5iXurbYneFxfqSZF2ZaXOlmoOKCigFZmJpRtGFsMuaEaYSUZduPcyuv3nknKl+e/AQR+gUP000PQdZFinEx3M1OfEfpC+vfBblwEHy9EAyNtDIzOODIb7TTycR1Rr5mUVm8jlE41oZyuK/CNwZ2JcEfQ7HgbM408VAwIuMQl12Q4P+JJQE5pYpFDV2Bk5cqreX4WTX+IVoaYkvppbwFF5EQWW8njD7qznPA81TNZQbM8CsMyk7ioyBoqA2l6k8V9nweR3vGlUIrNQW5mdhC0figa3/iwVGUiasi2pNgIv4IKMbkMd1OkPXQWLqBR5aofUkVSk3cQOfMinO6tKNrCMJ1yMG0BB7tElsfn3lClCKUKlNyNaSnRSANhxe/GKbc6XIzQdUta7MrPOpaU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(5660300002)(9686003)(66946007)(8936002)(6506007)(55016002)(7696005)(64756008)(8676002)(33656002)(66476007)(66446008)(52536014)(6916009)(4326008)(7416002)(76116006)(86362001)(71200400001)(2906002)(26005)(66556008)(54906003)(83380400001)(186003)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9nP9SgpQF7vusz+UXeD25Irj9r3pUY+7dezSWrOv4eNwMjEMWzXWr1ExfrzF?=
 =?us-ascii?Q?+kwq/n8qfqEm0AwqPZFKohzYvmYHAIbsnM16oFGBbUiJZaGciphgUxYYXR5o?=
 =?us-ascii?Q?JddpX7pOYQdYmV15kmud2JVIEhcswB1LuAHGi8RqVOd3J2hNWixKM4p7lIyM?=
 =?us-ascii?Q?C93hbhKdGhn2MEu473zvOlEw1R5YJb/SnnMQMVtgS0926FlnT+Um6O5NAUW8?=
 =?us-ascii?Q?HxKSRpe4JERE45R6sdjbjeWu804gf279T/HUlQVU4v36zlTtiYZa6dQz980t?=
 =?us-ascii?Q?9MCAEMRfJAZDH3gFSCV5BEBUgTgH8YNVOAUX4N4WnrMHiGhPyQJeTMIibflQ?=
 =?us-ascii?Q?UDxryDb+8RWKfK3zir6zT3uycXgWJ3qFfEQ4KRQd1BBShvotd7iMTmpu4znY?=
 =?us-ascii?Q?4Uc86pTxShiJGDMf5ijdn/6CNoATUIpKzDk4oGVPzKBbntoVjEHamEfgMWrE?=
 =?us-ascii?Q?tNERZT2OerwDAfv+IqZrEgHYpKl08Fs8QxSmtEn/+UGJe3w+Z7Rjvz9kc+RQ?=
 =?us-ascii?Q?pNGtynQZPzBmIg5VHWVoCv2PBmsZ7Nb/UxJSEyyhAEzkTBRMfMAdgeMElSah?=
 =?us-ascii?Q?hN5FFYlBYrwvFnG29iLYX0M+p8rMOM3+1/rPEQXTnvy3s+W29y5k9LKWmLsO?=
 =?us-ascii?Q?fNSGVKmRHt+6p7/ktm+sHYa6FZAU5vctIBL17N2BCj6iEudVmip/zg2xU0u6?=
 =?us-ascii?Q?t6NG/z6dqYva68E7aFLvZYpUhNemzHhe6oQ4eh252r6ruU371YegLbg7kIRn?=
 =?us-ascii?Q?02UJVknbyo8c57itHApAzY41E8/4CHFJecO5dmUBbCsDZhHLYtYxrG9F09LZ?=
 =?us-ascii?Q?7PL7FAQLyS5z/uHu+P/XkTO12Vq/6TIRaXjCuQvDJMrTaYdsgxeaoE3y/pAU?=
 =?us-ascii?Q?atxETf7nFH2ENpADRnGFHIIyhtiIuiCQS061dWW/qfdNHtHI4S74pUGdPeg0?=
 =?us-ascii?Q?vGfbk8qIDGYxLzAz/WegBVnmDHRr6D0HMnaieccT3jYCDfQm+uNViyqKzl2d?=
 =?us-ascii?Q?baIOq19sqXyO7zPix4Yd88EDcBbF6xX0lYWDu3bsvqtrHlTW3G3uAjmQt0vu?=
 =?us-ascii?Q?YJq4jkGc23+RUw821E1DR/WNDxMP5ezNIZ4gAOyeHR+rZe7XilN+Sha4nyym?=
 =?us-ascii?Q?5KwvJK+9PFU1hXYIgdliA/pcPggeGdICFahP1vvOpRWqwN12U2u2zHfJI6gn?=
 =?us-ascii?Q?dog8es9GQFTF3iUF4kSkTpyIQGjNel4HkWDJcmYjjZDg+09tniqcQ69ewXuQ?=
 =?us-ascii?Q?IaWM75ZFqwyqPR/raPyIsxpqs4qgEukiDy9+HcfqPoTHFCncmnyEtwhePUDc?=
 =?us-ascii?Q?qyWkq/7IrIE/sV2VSmeVjh/W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fafa841-f2ce-482d-5e20-08d8e855b422
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:30:06.3546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IGRmNvfeAmUKdE8qkt8sozqzZIiNGHNZTyt94dCWqSGVQ6b+8bKNV3aAVlb+z08nsm8dfYz8Q6iWnkNSSdTf1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> ---
> >>  drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
> >>  drivers/scsi/ufs/ufshpb.h |  1 +
> >>  2 files changed, 15 insertions(+)
> >>
> >> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> >> index 6f4fd22eaf2f..0744feb4d484 100644
> >> --- a/drivers/scsi/ufs/ufshpb.c
> >> +++ b/drivers/scsi/ufs/ufshpb.c
> >> @@ -907,6 +907,7 @@ static int ufshpb_execute_umap_req(struct
> >> ufshpb_lu *hpb,
> >>
> >>      blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
> >>
> >> +    hpb->stats.umap_req_cnt++;
> >>      return 0;
> >>  }
> >>
> >> @@ -1103,6 +1104,12 @@ static int ufshpb_issue_umap_req(struct
> >> ufshpb_lu *hpb,
> >>      return -EAGAIN;
> >>  }
> >>
> >> +static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
> >> +                                    struct ufshpb_region *rgn)
> >> +{
> >> +    return ufshpb_issue_umap_req(hpb, rgn);
> >> +}
> >> +
> >>  static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
> >>  {
> >>      return ufshpb_issue_umap_req(hpb, NULL);
> >> @@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct
> >> ufshpb_lu *hpb,
> >>      struct ufshpb_subregion *srgn;
> >>      int srgn_idx;
> >>
> >> +
> >> +    if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
> >
> > __ufshpb_evict_region() is called with rgn_state_lock held and IRQ
> > disabled,
> > when ufshpb_issue_umap_single_req() invokes blk_execute_rq_nowait(),
> > below
> > warning shall pop up every time, fix it?
> >
> > void blk_execute_rq_nowait(struct request_queue *q, struct gendisk
> > *bd_disk,
> >                  struct request *rq, int at_head,
> >                          rq_end_io_fn *done)
> > {
> >       WARN_ON(irqs_disabled());
> > ...
> >
>=20
> Moreover, since we are here with rgn_state_lock held and IRQ disabled,
> in ufshpb_get_req(), rq =3D kmem_cache_alloc(hpb->map_req_cache,
> GFP_KERNEL)
> has the GFP_KERNEL flag, scheduling while atomic???
I think your comment applies to  ufshpb_issue_umap_all_req as well,
Which is called from slave_configure/scsi_add_lun.

Since the host-mode series is utilizing the framework laid by the device-mo=
de,
Maybe you can add this comment to  Daejun's last version?

Thanks,
Avri

>=20
> Can Guo.
>=20
> > Thanks.
> > Can Guo.
> >
> >> +            return;
> >> +
> >>      lru_info =3D &hpb->lru_info;
> >>
> >>      dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
> >> rgn->rgn_idx);
> >> @@ -1855,6 +1866,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
> >>  ufshpb_sysfs_attr_show_func(rb_active_cnt);
> >>  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
> >>  ufshpb_sysfs_attr_show_func(map_req_cnt);
> >> +ufshpb_sysfs_attr_show_func(umap_req_cnt);
> >>
> >>  static struct attribute *hpb_dev_stat_attrs[] =3D {
> >>      &dev_attr_hit_cnt.attr,
> >> @@ -1863,6 +1875,7 @@ static struct attribute *hpb_dev_stat_attrs[] =
=3D
> >> {
> >>      &dev_attr_rb_active_cnt.attr,
> >>      &dev_attr_rb_inactive_cnt.attr,
> >>      &dev_attr_map_req_cnt.attr,
> >> +    &dev_attr_umap_req_cnt.attr,
> >>      NULL,
> >>  };
> >>
> >> @@ -1978,6 +1991,7 @@ static void ufshpb_stat_init(struct ufshpb_lu
> >> *hpb)
> >>      hpb->stats.rb_active_cnt =3D 0;
> >>      hpb->stats.rb_inactive_cnt =3D 0;
> >>      hpb->stats.map_req_cnt =3D 0;
> >> +    hpb->stats.umap_req_cnt =3D 0;
> >>  }
> >>
> >>  static void ufshpb_param_init(struct ufshpb_lu *hpb)
> >> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> >> index bd4308010466..84598a317897 100644
> >> --- a/drivers/scsi/ufs/ufshpb.h
> >> +++ b/drivers/scsi/ufs/ufshpb.h
> >> @@ -186,6 +186,7 @@ struct ufshpb_stats {
> >>      u64 rb_inactive_cnt;
> >>      u64 map_req_cnt;
> >>      u64 pre_req_cnt;
> >> +    u64 umap_req_cnt;
> >>  };
> >>
> >>  struct ufshpb_lu {
