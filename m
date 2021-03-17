Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867F3C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 11:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BCAC64E12
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 11:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhCQLYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:24:07 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:15674 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhCQLXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 07:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615980229; x=1647516229;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bva1pwvv8uAZi9uv8RUoKtLooIEHg4ZTk3whUrb6id4=;
  b=chZLNq87Uwm/MZoigiki0UMkc1zE6Il8M/w0YadDRVQA1oiJ8gvVpnxG
   grS994ZNB2QEt44gUEJjmVw7I4P5aY/CDNBR9BovKUXKdP5sH8cZUp9zP
   W7wHkma/gBJfldlIC0zFdSyUX2N0kbN9I7xO7Ux2JmRPZ387/4c3wNt97
   R1riRRoHXWeDNgwi+oWi04AFA7YfTeyraXqbF9d+6EuixYOmOiyN6cSc3
   ghn1L4W5fdb1RdheS2qfTq482xCaoYdedJAyhaXG96kgxlGX9CYBf2KZ8
   opEXnAT3dhVyGolluJ2YrhM5C4gk3bzQ10liZw86ESRkVTNISr3wuBQY3
   A==;
IronPort-SDR: BwmScEfUeODQVDw9SypV87+mBILhpZ4yfpPVxwey+suKidWwOcu9wTOSn3Ji06EmwTvjulNj51
 nCu3xGqw9yzAPjQsx6W1c/LCkPCngaF5CRYx2z/1je2F2ys/IrvBXsw1QIRLB13Eu1ObM7GGyw
 Uj++QMCmcrSs5LLC653t1efQPKizEtvQ8IPgom7f2l2GRJBpzgYh5QZqcCnA7KptSt12bIDMn6
 U91Bcn//AwWwtLiyMeHIUXYcrcVEamUcL78g7PgXAkBrj27LSEOwPXVBfx21E+oAnrSGzmBxMs
 XpY=
X-IronPort-AV: E=Sophos;i="5.81,256,1610380800"; 
   d="scan'208";a="163499055"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 19:23:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIcCBId+ywkE4lrUDlI/RL//bmz/4zLrDUNA7xh1xZRwzpmck89ktaHYtnxQfKEgumNUYBCSB4IsV5mVinetUUEWZbqsBLjYmfeJJJaE6X94AN/lURhw0YS2OARSHSJvEpxIOkkPCQNkLFV4wAXxNUqjJ08sQu02k6VI+2dYfG1E+7sTC3vvbULfz/gTn2WdJrUCfjTDaUR76Kt6i4D69QSxoNaf2MHfBd/AeH4yqZ1/RNjZvdD1ISxLaZCecZ/NbRmlk9PTZ+8nx4yE4tvcpww4hYiKKs4co6Wl1W1Ur/t2KAXxyVeZvUAVgJ1LLtZ4sbzWSHv6b03zUXR40vkJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnikXbHxoS7K1RYqDyQ88el4h/JO9X9ew3+bPATTBIU=;
 b=oaIZwSRoPLSnV8hxB+7+QVC3MzVBCq5aW6u3xNVlXRSk2Jt3jD+j2K4uMhLdVx5/vv3sGBKHybzRAUVt/uPx+VdZFel01ObKOUDoL/EINDW3oEkkqRsfCkrXTASo1SxMoYdrv5R9gkKAqBqBbw4qP77rG6qvWwO49iG4FxmVKi7VoOYwQraELZagrKmF1nYFNpl1qu1unlIGc6jOh+MkMEPuW/fzAmeaxqdWHfqNp2fIc0AH9v9RqJ2BmKCmdpOH2e0wlG5KrNIgf+YCUQcmnVPkidQv7Ie2j8mGmY5DxDoXWLhFCzLJqRYshRIVO4hGYiZ2+3ckW0diXiNxH+qnoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnikXbHxoS7K1RYqDyQ88el4h/JO9X9ew3+bPATTBIU=;
 b=ldGjq0/Wi3PFG3+TkpqsslREXH47Z+BnexRrj6zrSplrO7yrdAg5W8IpTtGEG+6JxjaAcjajqgjXB3dmi87/SnOwdTwcnDh7nkejQqJzuu640C/HYPEFsXAzL7D8DpXyp4J/+FeEbk+cS/xO/B2/k124YIUyfxSRPQpW+tGJ0ZA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0267.namprd04.prod.outlook.com (2603:10b6:3:6f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Wed, 17 Mar 2021 11:23:45 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 11:23:45 +0000
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
Thread-Index: AQHXD2ex1y1f5g2rP02e5lIjKmzR26qIGY0AgAAGPJA=
Date:   Wed, 17 Mar 2021 11:23:45 +0000
Message-ID: <DM6PR04MB6575006E0682C3D11F54965DFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
In-Reply-To: <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82c1f526-f7d7-4719-4e23-08d8e937209b
x-ms-traffictypediagnostic: DM5PR04MB0267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB02670C45E0C6A42DDD16F2F7FC6A9@DM5PR04MB0267.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iZKEgJEa/c87M4+3tnZAcpAKYwEJbpgEzc8wZigUqWYC7AT/Cj/MB5EcHUnmE6jB6UhBYvyr357pCPM4aAlsemVB6eYE2kTESRPLcUMmW/q5qfOQMlflB4BSPCZLfxbVFeKoXHPmai2tkWeoKq6Pap/dghBfK6osLyuDXR+iXxYseibUtQVr16J1Fo+rSU0sUJqTLnpNqCgan2QopsLlXSSGlWO8zJEps7QkEEisTr1788pSvr7Q2SxC+lUNyCzoIUTQdhvGIIut9nEZtjJZ2TBT+yDQpsJgXWeNwLE8Ns3Mj2aKZxY1lGSUML/JHllIT68vPz2DHBVfMppVy1EdMH4y5Z3xSxZmAOZfupVmZ1EOo3mqOWLnJoEUQNKLvN/wCvYNouFGSskUjH54CvLFKm35hwQpuI0+hcuFPz+7Y7nCSZgzlskYSNzWoiYwEJkMllV3fFSP/d30c6CRicpxXAZEvJ6HP3zd1ALBoHhXnNKLwC95CfB3BFpnlE6DKwb1Wc3H3FgzN/5NazYfxBGYKYJr768mgmMymVxi4Wp2Ij/wI4RqoWE9/Pha+IFGOu2l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(53546011)(76116006)(66446008)(54906003)(5660300002)(6506007)(64756008)(66556008)(66946007)(66476007)(316002)(52536014)(55016002)(9686003)(33656002)(83380400001)(2906002)(7696005)(8936002)(8676002)(26005)(6916009)(186003)(7416002)(86362001)(4326008)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?o7BsH2NkbahM/E/q/7faks6TV4h2Ob5u0W5kLmKKBlk1c636tP0vNpSypLYO?=
 =?us-ascii?Q?Jmr5fx/Qi/rOOhTkZCpGGks0p31LFJEuJ/4MftjD4vJh0pFug8o9vbu0Rkw1?=
 =?us-ascii?Q?Brg1jlzKodhMTc//VP2jUEvj3/c6gfeq6J2TcDQe0Q1XWSo+s9GJRoSywwjM?=
 =?us-ascii?Q?mybpvPvmAV7XtgjjvcvzT/qgTYJp7yKkgu/GDori7KB0A2wPV7zFRvx1NC+F?=
 =?us-ascii?Q?qZ681vYZeb76oXoezf54Jq8N5N0FkEbRf8dFHaGK2EKdUxXpWUn38mCQ1k4k?=
 =?us-ascii?Q?Mi6S00r/xlfdUIRQCTW+GID/UHv7AOajr7F25vUhfEgYn2Bp0g2Ye78nyfEb?=
 =?us-ascii?Q?4Bx5ANNlOTV4HgtnOEDYIlaTIi7hhSqor2tgHJYO2MQeCy/7eEAGM7KhhN+v?=
 =?us-ascii?Q?VeHwrmQ1ijEM4vaxsYDFr/lBgC5VuKzpi9Nf+AUQqxhbZXEZ9gmhLbD+VEiR?=
 =?us-ascii?Q?ULyGlcLJZbQh+1R+md4nY54NR5CI8AiXEvz+8ref/8ShBHSxwDAXHvzQFY9/?=
 =?us-ascii?Q?Nwr1DlwElpDdik1SyeLaj1csYKF5kxOZLutyZhmYQu5j9UmjEXCt1Gkfx/6k?=
 =?us-ascii?Q?6zPoc+6SrfQMixTbU42p6Cej2N52uX0LrdIv5mVNc4DxQZgM+wTpRaMEW5xk?=
 =?us-ascii?Q?lPnkiUeM3jSuT0ql0IpwdGWDyWXgQD91oZ2aP0MRIhkDywh3djaYG8LyxJFu?=
 =?us-ascii?Q?s0FQZ5ql5wLdpFI2fn+IYMox9DtjTlATCYFJcTS02lFNqG4ygvbMNgcmNLGV?=
 =?us-ascii?Q?gqZbM3AKe2ncD0XKcN6ekIEglBEWpu0XoeqpBaTssm7tWe00rC2k2lwDyqPH?=
 =?us-ascii?Q?4pjtKPNDe5HVLBdoXLW69OG7wSElZXUwTU2umeRFFGJmAAstOZEbsxQHG5T/?=
 =?us-ascii?Q?GxjD8WH4DGdJDKL79VHQlznQrJKBZKJg8dxfPIdZ7/a/j1i7ipkbiaGUrQ0V?=
 =?us-ascii?Q?LbO4mrk28dpLBKRfzjkQ0dJcXBOxbGK7OYapt6kK2zcXcjZNE0L2iH/OD9Az?=
 =?us-ascii?Q?3cpNFAoH9pQ/bf8VKk2dIOR/Wa4IwXq4/fyUiUz2IomeKEkTBDXPqpIdwSEI?=
 =?us-ascii?Q?HKzcdW4bau2QOuAbnwmLzU6iQNJI7P0nTYTChJzPpOOc/F1PYAmlEwRkrCkS?=
 =?us-ascii?Q?/7rt/XYTrnytn7nh2y9kFm/DMy7Q38WOcBCq7JRC3flS/PMQmNXvy4HxL2k7?=
 =?us-ascii?Q?DowMzdIihP+FgFP/P5hfDmBehbFBwywte9upQwI1hHV0K9hK+W7td2KW1PaJ?=
 =?us-ascii?Q?wUvq1AXLPLtTKqbQC2MSCFQYbpLqe7IwNxe5jrFSWyLAD1qdEuqT3CLTOizX?=
 =?us-ascii?Q?FFDzf/MbT9VGiTMiWS7J7v5j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c1f526-f7d7-4719-4e23-08d8e937209b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 11:23:45.1113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5b7ihoEqvUegMaGVFkhvsVcc7KGV2Tkg7eodCfhPNdFWTAXdJnrBva9GAOvIxPgpXuStb6Zf1PwdhPY5sO+DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2021-03-02 21:24, Avri Altman wrote:
> > The spec does not define what is the host's recommended response when
> > the device send hpb dev reset response (oper 0x2).
> >
> > We will update all active hpb regions: mark them and do that on the
> > next
> > read.
> >
> > Signed-off-by: Avri Altman <avri.altman@wdc.com>
> > ---
> >  drivers/scsi/ufs/ufshpb.c | 47
> ++++++++++++++++++++++++++++++++++++---
> >  drivers/scsi/ufs/ufshpb.h |  2 ++
> >  2 files changed, 46 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > index 0744feb4d484..0034fa03fdc6 100644
> > --- a/drivers/scsi/ufs/ufshpb.c
> > +++ b/drivers/scsi/ufs/ufshpb.c
> > @@ -642,7 +642,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct
> > ufshcd_lrb *lrbp)
> >               if (rgn->reads =3D=3D ACTIVATION_THRESHOLD)
> >                       activate =3D true;
> >               spin_unlock_irqrestore(&rgn->rgn_lock, flags);
> > -             if (activate) {
> > +             if (activate ||
> > +                 test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags))=
 {
> >                       spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> >                       ufshpb_update_active_info(hpb, rgn_idx, srgn_idx)=
;
> >                       hpb->stats.rb_active_cnt++;
> > @@ -1480,6 +1481,20 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba,
> > struct ufshcd_lrb *lrbp)
> >       case HPB_RSP_DEV_RESET:
> >               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
> >                        "UFS device lost HPB information during PM.\n");
> > +
> > +             if (hpb->is_hcm) {
> > +                     struct scsi_device *sdev;
> > +
> > +                     __shost_for_each_device(sdev, hba->host) {
> > +                             struct ufshpb_lu *h =3D sdev->hostdata;
> > +
> > +                             if (!h)
> > +                                     continue;
> > +
> > +                             schedule_work(&hpb->ufshpb_lun_reset_work=
);
> > +                     }
> > +             }
> > +
> >               break;
> >       default:
> >               dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> > @@ -1594,6 +1609,25 @@ static void
> > ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
> >       spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> >  }
> >
> > +static void ufshpb_reset_work_handler(struct work_struct *work)
>=20
> Just curious, directly doing below things inside ufshpb_rsp_upiu() does
> not
> seem a problem to me, does this really deserve a separate work?
I don't know, I never even consider of doing this.
The active region list may contain up to few thousands of regions -=20
It is not rare to see configurations that covers the entire device.

But yes, I can do that.
Better to get ack from Daejun first.

Thanks,
Avri

>=20
> Thanks,
> Can Guo.
>=20
> > +{
> > +     struct ufshpb_lu *hpb;
> > +     struct victim_select_info *lru_info;
> > +     struct ufshpb_region *rgn;
> > +     unsigned long flags;
> > +
> > +     hpb =3D container_of(work, struct ufshpb_lu, ufshpb_lun_reset_wor=
k);
> > +
> > +     lru_info =3D &hpb->lru_info;
> > +
> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> > +
> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
> > +             set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
> > +
> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > +}
> > +
> >  static void ufshpb_normalization_work_handler(struct work_struct
> > *work)
> >  {
> >       struct ufshpb_lu *hpb;
> > @@ -1798,6 +1832,8 @@ static int ufshpb_alloc_region_tbl(struct
> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >               } else {
> >                       rgn->rgn_state =3D HPB_RGN_INACTIVE;
> >               }
> > +
> > +             rgn->rgn_flags =3D 0;
> >       }
> >
> >       return 0;
> > @@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> > *hba, struct ufshpb_lu *hpb)
> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
> >
> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> > -     if (hpb->is_hcm)
> > +     if (hpb->is_hcm) {
> >               INIT_WORK(&hpb->ufshpb_normalization_work,
> >                         ufshpb_normalization_work_handler);
> > +             INIT_WORK(&hpb->ufshpb_lun_reset_work,
> > +                       ufshpb_reset_work_handler);
> > +     }
> >
> >       hpb->map_req_cache =3D kmem_cache_create("ufshpb_req_cache",
> >                         sizeof(struct ufshpb_req), 0, 0, NULL);
> > @@ -2114,8 +2153,10 @@ static void ufshpb_discard_rsp_lists(struct
> > ufshpb_lu *hpb)
> >
> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
> >  {
> > -     if (hpb->is_hcm)
> > +     if (hpb->is_hcm) {
> > +             cancel_work_sync(&hpb->ufshpb_lun_reset_work);
> >               cancel_work_sync(&hpb->ufshpb_normalization_work);
> > +     }
> >       cancel_work_sync(&hpb->map_work);
> >  }
> >
> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > index 84598a317897..37c1b0ea0c0a 100644
> > --- a/drivers/scsi/ufs/ufshpb.h
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -121,6 +121,7 @@ struct ufshpb_region {
> >       struct list_head list_lru_rgn;
> >       unsigned long rgn_flags;
> >  #define RGN_FLAG_DIRTY 0
> > +#define RGN_FLAG_UPDATE 1
> >
> >       /* region reads - for host mode */
> >       spinlock_t rgn_lock;
> > @@ -217,6 +218,7 @@ struct ufshpb_lu {
> >       /* for selecting victim */
> >       struct victim_select_info lru_info;
> >       struct work_struct ufshpb_normalization_work;
> > +     struct work_struct ufshpb_lun_reset_work;
> >
> >       /* pinned region information */
> >       u32 lu_pinned_start;
