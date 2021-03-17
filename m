Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC74C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 12:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FA064F6A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 12:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhCQMWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:22:48 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:38358 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhCQMWS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 08:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615983738; x=1647519738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tOwvDnPWAB7bmIdzwUV+ROqXPLiK3V1sUJMVjHB0L9Y=;
  b=nZhlZO+tREA+ZS4hw/cF5SEJzulGRvLc5P3t7M8v4KYvxYr5DYe27JXB
   V5VDJdWsz6NzogMnoYS/JoRY6BTrtUEZfZ0xFjOixHI89adP2zpCrhV2R
   vHE2+XUdc0g2KrNy7RUejCFC4nv8vmaoIqTwjGsKSM4UHN5FLTwUaLcoi
   XU3ZmLl566VJVF1AoMDP/5uJ/0v7Xhk253ehHHnkld213QX3lEQDgqFIp
   XxAYKZAybUsFjPfjahNrrjj65e0GkLUklmn8JsnoX9+l36c+gZWRWmTbG
   w7Qbji5qhGRXhGeuOalHWeH9KNc0dVBF29dbWQ4ZkZlPawTw9hYAHM1LJ
   w==;
IronPort-SDR: Bd2cs3iH3BbU1lOj12Z44P/aSL5v5Qw1vGmeSj3Fiq/7mPAeDHB7oHiye6Cf6dCPgUfSNzKlfS
 A/u34JW6jaPrA3cj8x8dcETUpLsfrEEgH7TWgDX+c4ppO2j8ErRN7kTbaXEVHVEPLXY6z4UEcW
 gxbl3oTb/+soKgko/cvM27zIaKqTRekesoWu8o/PXus5Ipg9CYmnChHdgov+WWlVqGfUyZR/7O
 DPpZZda0tQWRA2luUYMOOKHhxmnk/COz5huPEkhZuxM7LN+roiZXIa3I4tEYzVTz9q1HiFmqUi
 o6g=
X-IronPort-AV: E=Sophos;i="5.81,256,1610380800"; 
   d="scan'208";a="162366889"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 20:22:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bw1u4czZYkHfH78RQC1xejUTzvt8jgGw/Dk8S6K3BQ/MrmL3L4Il/SPOLxr2M/60eBlV5ohtyy1UEpd9B7fcCLwDjg0oSyq9P5avOCB1JYcyezGaN0ruwggd820bBtlAYz/CABULZXsK+tz4nUWy1BEJRnaxHmlC2WX6niQjICMR6y4BiGBV+BiU6dYOL8aR//bnk6ddlSbY6+rywJJTIAYHKJE/z11we95T6YJTjIgjeclA2SXvvsXBeAKr+0Xm6NZTQYJ4AUdCkdUI5hn8dfYwId0ScF/sCNH/T/iIERmipeXcxmJr30oDmVhEvdu1OyKkQsHjfB7R+1kllpdubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MAXjPwmyFMgLF1K0TW9dicLAgC4n8cF3hEey8uh0vY=;
 b=VvneHo8sP3iZOhJfHb45EY0k0EDUf57+AQCBO4YwBA9FIWnMN96Qut8PUbZVW3iNNiuhww+4LSThXE3wnrqJyB3WygeWP7w8qtvqYNypvAEXtEoADQH7GzVshcsnxUEsh8p1ndiqQuIp8vkm3iTREDWvmmWyeY3Qmbcz6zOHgJs8BPWaFnBkIe9/sayjamwW3d4D6KM1v/jKnQUcflrHYLjRyIqyJ8RpjwNDmfRqy48KL6N0nPD0YbC4nJJzASkVR0UyKqnpbmjwdNerscFX9he6JfqlaBGNxNySbZCrZ7kROirLcubqP/imU51pIhj+daQFABFacUFM2orxEcpBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MAXjPwmyFMgLF1K0TW9dicLAgC4n8cF3hEey8uh0vY=;
 b=JDWERhEElBeHL/eHsgzPnKjJoxFqeuQteFLJI/WKt0kz4YXbfvu7QOuk+bYzLTkIb/NM9tTlZwxsrGAvjtYwYJddigxA4REsyAPcU6TY5WxgDir0zduIhJfla5HCeCSvc3Bmqt/+U17h/t5lvnUxJ9El2z2juldEM0w0plx0ctc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6576.namprd04.prod.outlook.com (2603:10b6:5:20d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 12:22:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 12:22:16 +0000
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
Thread-Index: AQHXD2ex1y1f5g2rP02e5lIjKmzR26qIGY0AgAAGPJCAAA7hAIAAAEIA
Date:   Wed, 17 Mar 2021 12:22:15 +0000
Message-ID: <DM6PR04MB65750C0AE1F1EDB41EDEE491FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
 <DM6PR04MB6575006E0682C3D11F54965DFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1d0e3c5441ecf14b6614ec0af0d30af6@codeaurora.org>
In-Reply-To: <1d0e3c5441ecf14b6614ec0af0d30af6@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ce1fa820-e647-41c2-e4c1-08d8e93f4d46
x-ms-traffictypediagnostic: DM6PR04MB6576:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6576B3BF5468A9EF909300C7FC6A9@DM6PR04MB6576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3YTe2s159V6kmfGdGghGi3IXUkzjvT/TmRzcxD9HwXC+tR+GRH7SiXnryRALQy6t3pwFu+2om1fTa1p+EHXGs6yY7I84Q9nU0kOKIRQaADnc1XlfyT9mPi4NU7m7e6VVe922URTIT/2dM5WYSEjP6WCAAUTpmKhaxADYysjsfqqzVfVEU2pwrNjnY5trYtKGnPQL7iRXs+wl81hIs/G9i0dXG0j3JWN+C6eYc2jHMHPvMfydB2j2U1wnrVYzWaIWdZU+EdNxoX89wq+FmoOfxV/ZZ5h6BqH13QvvRg8YWW4fKO3au6RtU3hsK/pQ4bQOJcrrbOmsgLUU1cZo2krhG7WCs7W2KGjO/nmGgFm0CFdN/VtGRF94yH8DSmnea2g1lvEx/6vAd+MW/H81qqvpXhSJNxaG+O9oe/Fw9BylptJZQOKRSuNjlfZOOadzDQtKKC/+SCX30dF1cDrErmIvf8cgWOlmODogfajHWAR03RZMIV/LM3Dggq2dm9gBvrjnjKsEJENuSHxcowcealJ+Ea449spo8VpzSPHtIeJY/+azzPHbC6VMsZMVcy+HDq9W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(7416002)(186003)(54906003)(33656002)(8676002)(53546011)(6916009)(86362001)(55016002)(66446008)(478600001)(66946007)(26005)(76116006)(66556008)(66476007)(8936002)(71200400001)(64756008)(83380400001)(6506007)(2906002)(7696005)(316002)(52536014)(5660300002)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bve3Mwn6oHGZVyRwqXLCYMROI6lgvTwJnhtYlxq1+3Yfh1TZuT+Q/2vOrXWX?=
 =?us-ascii?Q?ZqaFL6zNMt0htqq5wuaLpQ3f3DzGRDzwQUPaSDfn2rxOo07Dl7fAPiMQi9Q0?=
 =?us-ascii?Q?799VdgQAixgxmPoZjVMdtoLbHrvczRSkh9gd+joeyXm1u5Pgai87JLZfCMPW?=
 =?us-ascii?Q?T1LiCwU8hxZ7+/pplDq9TCfujzKlv6iRvAY67b8tUnmlHxFEVtWFCKiMpOjj?=
 =?us-ascii?Q?4iLLh+QgqljNz60zgJCZUuOK1RG0d08qiIOkuXafQF0ohW+Q0GJ6Ol1H453x?=
 =?us-ascii?Q?YBI7dWgtkVULdh8ekgvgU4ne+U5kt1+woZUP96aaBzhNeH4lbSi3ZBHJHCyN?=
 =?us-ascii?Q?7QDdiwlArH1gR66eQTR9o0oTV8EaCVjHEWSA4bXfkhfF95Qtd1OOugASLrxe?=
 =?us-ascii?Q?4caMDS9PepTguuxOocR2/psjKFibZhjCkIideQ3ckDHPmIaHj8NEVH0YRWdm?=
 =?us-ascii?Q?B5MCl96/AL3aMNarrInR7ANDbxYGM62+35uL8jwQ1UfKvmBf66MfOMvn6GFD?=
 =?us-ascii?Q?3AioD8XRFKJUPkB+u02E3JaAkbi9ea+KyoVdwJ9PRuZNuEaCdyRKM7qs6ZRi?=
 =?us-ascii?Q?v6UKWurZICPW0imoR8DKABQjMLykCXHgDVa+kx8F/t/lWv+Lfe/et9mN0aIo?=
 =?us-ascii?Q?xjb0A4XCCjqoZ0BML0hwGRtHGiKGKt0QK3jDQe1YqG3fSnqCM3i/zKelQktr?=
 =?us-ascii?Q?7Vo6O9Igp8zcfRdLU7gJojXvNqlCz34SRuEt59wSmxKRnkE3pTS+tCXXm4mD?=
 =?us-ascii?Q?rdkXrBfuGA4LgeewJz+q5GY8XIkUS8AO8o7pg2cWsm3DfJDbD+d4hfjWY80v?=
 =?us-ascii?Q?I26F+PX1GX9u/O9k/QdCmRLIRachTuAw9mAOZfRSrUZ2ZuXUTcPCz/B+rZxd?=
 =?us-ascii?Q?TtkQBdD6FrMD2Bar6nonp919JXFwZ9SRe+ONNfpQlm8XG8Svvlf69LgKIsHA?=
 =?us-ascii?Q?iMbRydjM2F1JZRk1u3s0v34TPUqX681H+CcphZs5P1icJib9Xd41msU0U1nr?=
 =?us-ascii?Q?SMtlc0hChy/tCVpbs3Pmc+ay8xUHnWVPGuS1KQtqOnDCJ5Nl7INiPum+8EcU?=
 =?us-ascii?Q?6YSA9lMkFfCZ4ibWq1rLQrdMGxQtV2PB0o1NCdu3cUEn/1QLVEHaCFDLiW5K?=
 =?us-ascii?Q?4GZzuDrBEUCNjo/8wA+FASXH7LFXPf4UPJYsBqiSJrzF2IS8KpGRnwiUtz6a?=
 =?us-ascii?Q?CyM4ysO55+3GU8e5S9AJpgaot9fgW8sd5aAXIExdUy+0Dzr/aLTqlcY+yXnZ?=
 =?us-ascii?Q?WsBiCSf7+UFzPcQv6l3sUHp7EVcqLB4yHaRVp8WF7xIR7J9MIZ9+tc7EzE54?=
 =?us-ascii?Q?0ABuqsc0o3me7lmQPH2AgBo+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1fa820-e647-41c2-e4c1-08d8e93f4d46
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 12:22:15.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RNQkbAJ6BbkGEYY1godAvcSVsE/IRKc/+PVi1exV0vIy2c+DaY+fZ0pHO3CaNINCeq1RfN/aNLkhdg1NJ7dlsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6576
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2021-03-17 19:23, Avri Altman wrote:
> >>
> >> On 2021-03-02 21:24, Avri Altman wrote:
> >> > The spec does not define what is the host's recommended response whe=
n
> >> > the device send hpb dev reset response (oper 0x2).
> >> >
> >> > We will update all active hpb regions: mark them and do that on the
> >> > next
> >> > read.
> >> >
> >> > Signed-off-by: Avri Altman <avri.altman@wdc.com>
> >> > ---
> >> >  drivers/scsi/ufs/ufshpb.c | 47
> >> ++++++++++++++++++++++++++++++++++++---
> >> >  drivers/scsi/ufs/ufshpb.h |  2 ++
> >> >  2 files changed, 46 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> >> > index 0744feb4d484..0034fa03fdc6 100644
> >> > --- a/drivers/scsi/ufs/ufshpb.c
> >> > +++ b/drivers/scsi/ufs/ufshpb.c
> >> > @@ -642,7 +642,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct
> >> > ufshcd_lrb *lrbp)
> >> >               if (rgn->reads =3D=3D ACTIVATION_THRESHOLD)
> >> >                       activate =3D true;
> >> >               spin_unlock_irqrestore(&rgn->rgn_lock, flags);
> >> > -             if (activate) {
> >> > +             if (activate ||
> >> > +                 test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flag=
s)) {
> >> >                       spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> >> >                       ufshpb_update_active_info(hpb, rgn_idx, srgn_i=
dx);
> >> >                       hpb->stats.rb_active_cnt++;
> >> > @@ -1480,6 +1481,20 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba,
> >> > struct ufshcd_lrb *lrbp)
> >> >       case HPB_RSP_DEV_RESET:
> >> >               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
> >> >                        "UFS device lost HPB information during PM.\n=
");
> >> > +
> >> > +             if (hpb->is_hcm) {
> >> > +                     struct scsi_device *sdev;
> >> > +
> >> > +                     __shost_for_each_device(sdev, hba->host) {
> >> > +                             struct ufshpb_lu *h =3D sdev->hostdata=
;
> >> > +
> >> > +                             if (!h)
> >> > +                                     continue;
> >> > +
> >> > +                             schedule_work(&hpb->ufshpb_lun_reset_w=
ork);
> >> > +                     }
> >> > +             }
> >> > +
> >> >               break;
> >> >       default:
> >> >               dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> >> > @@ -1594,6 +1609,25 @@ static void
> >> > ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
> >> >       spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> >> >  }
> >> >
> >> > +static void ufshpb_reset_work_handler(struct work_struct *work)
> >>
> >> Just curious, directly doing below things inside ufshpb_rsp_upiu()
> >> does
> >> not
> >> seem a problem to me, does this really deserve a separate work?
> > I don't know, I never even consider of doing this.
> > The active region list may contain up to few thousands of regions -
> > It is not rare to see configurations that covers the entire device.
> >
>=20
> Yes, true, it can be a huge list. But what does the ops
> "HPB_RSP_DEV_RESET"
> really mean? The specs says "Device reset HPB Regions information", but
> I
> don't know what is really happening. Could you please elaborate?
It means that the device informs the host that the L2P cache is no longer v=
alid.
The spec doesn't say what to do in that case.
We thought that in host mode, it make sense to update all the active region=
s.

I think I will go with your suggestion.
Effectively, in host mode, since it is deactivating "cold" regions,
the lru list is kept relatively small, and contains only "hot" regions.

Thanks,
Avri

>=20
> Thanks,
> Can Guo.
>=20
> > But yes, I can do that.
> > Better to get ack from Daejun first.
> >
> > Thanks,
> > Avri
> >
> >>
> >> Thanks,
> >> Can Guo.
> >>
> >> > +{
> >> > +     struct ufshpb_lu *hpb;
> >> > +     struct victim_select_info *lru_info;
> >> > +     struct ufshpb_region *rgn;
> >> > +     unsigned long flags;
> >> > +
> >> > +     hpb =3D container_of(work, struct ufshpb_lu, ufshpb_lun_reset_=
work);
> >> > +
> >> > +     lru_info =3D &hpb->lru_info;
> >> > +
> >> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >> > +
> >> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
> >> > +             set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
> >> > +
> >> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >> > +}
> >> > +
> >> >  static void ufshpb_normalization_work_handler(struct work_struct
> >> > *work)
> >> >  {
> >> >       struct ufshpb_lu *hpb;
> >> > @@ -1798,6 +1832,8 @@ static int ufshpb_alloc_region_tbl(struct
> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >> >               } else {
> >> >                       rgn->rgn_state =3D HPB_RGN_INACTIVE;
> >> >               }
> >> > +
> >> > +             rgn->rgn_flags =3D 0;
> >> >       }
> >> >
> >> >       return 0;
> >> > @@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> >> > *hba, struct ufshpb_lu *hpb)
> >> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
> >> >
> >> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> >> > -     if (hpb->is_hcm)
> >> > +     if (hpb->is_hcm) {
> >> >               INIT_WORK(&hpb->ufshpb_normalization_work,
> >> >                         ufshpb_normalization_work_handler);
> >> > +             INIT_WORK(&hpb->ufshpb_lun_reset_work,
> >> > +                       ufshpb_reset_work_handler);
> >> > +     }
> >> >
> >> >       hpb->map_req_cache =3D kmem_cache_create("ufshpb_req_cache",
> >> >                         sizeof(struct ufshpb_req), 0, 0, NULL);
> >> > @@ -2114,8 +2153,10 @@ static void ufshpb_discard_rsp_lists(struct
> >> > ufshpb_lu *hpb)
> >> >
> >> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
> >> >  {
> >> > -     if (hpb->is_hcm)
> >> > +     if (hpb->is_hcm) {
> >> > +             cancel_work_sync(&hpb->ufshpb_lun_reset_work);
> >> >               cancel_work_sync(&hpb->ufshpb_normalization_work);
> >> > +     }
> >> >       cancel_work_sync(&hpb->map_work);
> >> >  }
> >> >
> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> >> > index 84598a317897..37c1b0ea0c0a 100644
> >> > --- a/drivers/scsi/ufs/ufshpb.h
> >> > +++ b/drivers/scsi/ufs/ufshpb.h
> >> > @@ -121,6 +121,7 @@ struct ufshpb_region {
> >> >       struct list_head list_lru_rgn;
> >> >       unsigned long rgn_flags;
> >> >  #define RGN_FLAG_DIRTY 0
> >> > +#define RGN_FLAG_UPDATE 1
> >> >
> >> >       /* region reads - for host mode */
> >> >       spinlock_t rgn_lock;
> >> > @@ -217,6 +218,7 @@ struct ufshpb_lu {
> >> >       /* for selecting victim */
> >> >       struct victim_select_info lru_info;
> >> >       struct work_struct ufshpb_normalization_work;
> >> > +     struct work_struct ufshpb_lun_reset_work;
> >> >
> >> >       /* pinned region information */
> >> >       u32 lu_pinned_start;
