Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C33C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0065A6128B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbhDFGTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:19:31 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34389 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbhDFGTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 02:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617689963; x=1649225963;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YKo36mz0WOO559CkHJ079xEk2c4tAii2GEBFEjN2p44=;
  b=BPtTzMt72BxWB/EDgpirGLVhNVN9lD/i4zyDhLH5Ij5LPj1eH97v4T3P
   gc0VbGAuKc1QuM4N+5XJCHBtmsBUrkE7b9SMc8JF+mAq0/vTDLkCnuaFv
   kxARD9U7Q/cyM2yvF2bpwdQ4N93mr1fnZqM7kutpqBZGZbuOW6WH2eslh
   UJsoCoTb03OGOvRA3ltn61UOEE9Cl7DXhf43TNg+2ltLrEYJp/YtY2rCK
   g0S0g3jRiGFB/niba9bQZ2DeVkkIAF6beFdiZX2o8ch5JKbSFCZ/mprEl
   F5yqMcUHjzD6aO98ZcIN3tAKtXknM1Bw2KZRAWF7O+suJO+UogMcgazUa
   w==;
IronPort-SDR: TLVMcpTR0tPUg/Yda7+mviRhYmvlNyxHf6T8+fXRIezxQjUFjT+UQdkodidpdxCtt/i8XL144p
 Rn7PBdBr66Zn5TV1xk2J301cmtEPb/Fwr3DmCtYUgIHhf929kWLLU4h4JFUb/ylXUw/rByzsPj
 Mir286bCoSxPUdto5ky19b++CVv+CxeM3NQzJM8W5SiPjUuCM/6YNQLcek8SuohgCnBLr4lgKB
 H+pZ8DnhSRlUawbdB5UNMtqGHfRfoWjwhdrQov+IcevvLNk4ys/SIOSHt+v1E7LMvGO9HVeeJG
 ceA=
X-IronPort-AV: E=Sophos;i="5.81,308,1610380800"; 
   d="scan'208";a="268282832"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2021 14:16:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEDqdplhPtT0eDlxndcwBFGARKnyNJRIIjEAYDKp8ez3gJWs2LRUavQxazMDIVcCXeZda1wfy8nrdKucFG5OTbCNp018RcuVqUCgg0J0iSKpWjOe2H0fvL1hZ1ZWBQ21MM183SKOnjPy3UcbOU5UpLT0ZiYVRHoLLwWJb+lXQrmWf1JsJ6amwzXpOdNCC37pUvc08yi9GDUq6cBv1LfLCTcDtE3I8rTQbhM3GP0T6nBv7VBhjuqENQAjp1ryKpnYbAQfv2AfRV3HkfV3rxeDAEiM+1TBmQF7SJfumc4wGTla0+IypMZx12OkLPuhKpCYXxw3OLISpbN3Yhdh9DOqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJqzW0HPhwj95fvSvZCVVIOq7jJ7qeXqH8QDmwC/dQ4=;
 b=coqEZAZXFLc7f/lkvqgLmvPIVRm4vfU30dscNgQQpKj1cjfPENmLcz3chag5IQCSnsPUFbjL+6d67NokcLx+ac2qWdeI+WXKmt6SJKc/i0h5Xqlm3ug5dSL+pKk6j4qIWgptYD4zS+FxjwNPxXURUoTLCAa7GzK5RJP5jmSbIlInOVPHY4XtAerFhSgz0zbJBgKG55vkFPbw8ZqjYvb44PTEvfzv0cFEPLObs33kln5p1IUK1X4lRbbSWOx3vbm/YRSt9fXRtK+X3hFY3EyRye6inlejY66ZMb9GKegiINliCQIIn0GxbWHSYgw9lDLarGI8TeOxEvBuFgqaqhZcjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJqzW0HPhwj95fvSvZCVVIOq7jJ7qeXqH8QDmwC/dQ4=;
 b=wF51FZBoWg3fDCCg/DIuDHUPOY6XTflGd9ZpcnqPQaUKmObonqKOtTeEIqp4uzlEqlKMgQZsd+mmKaaT2AYl256g6DBadf34jq7jpUPUdF9b4xr4Ikz5HB5+Gb0ucITvrxHq1kKdR0YYWiOMUN+8Iz10UXWC7nD/o21PULe0iyU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6667.namprd04.prod.outlook.com (2603:10b6:5:247::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Tue, 6 Apr 2021 06:16:59 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 06:16:59 +0000
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
Thread-Index: AQHXJgEueLuV4ularE+yUH8qPo3IjKqm9ZCAgAAHZsCAAAthAIAABAWQ
Date:   Tue, 6 Apr 2021 06:16:59 +0000
Message-ID: <DM6PR04MB65752BA21FA1857D6EA10B62FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
 <20210331073952.102162-7-avri.altman@wdc.com>
 <e29e33769f23036f936a6b60c7430387@codeaurora.org>
 <DM6PR04MB6575719C78D67B7FA1557C21FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
 <6bb2fd28feb0cd6372a32673d6cfa164@codeaurora.org>
In-Reply-To: <6bb2fd28feb0cd6372a32673d6cfa164@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05451cc8-e47b-4a2e-f4b6-08d8f8c39648
x-ms-traffictypediagnostic: DM6PR04MB6667:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6667015A2004722468FB7BF2FC769@DM6PR04MB6667.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CrjoAS0x9dQMTApYmcZl51Lozlmr8MQM6uPHCRVzFKv8JLC8lZ1j4LbHHoh7IVlkDDD/sRoR/F+QhIqB41jeuvLYSKyRjUe0fA3xHCP6SqI8EY+LUZ1yb9d9+uSGtQFLPUjKqN5akLM7ZHyWOnd87qKjlGmcRvO686hsAAE8ym/fLRu6LU/LIjdnF5foaUR6tNEDG61ai+sJwfvja7FbovSjCegQtUEUW/JWr3nTwsYuFd3z/OGO+0sJv2mvi0y+aMADXqq/+xUFYUYmoS3dKaaHrwZ3sEynRZgEYL8ycXpP73Lujq6OKgY0fmcjQXcLVEaySzQM2jds9KCAMAlU6J+hoQuVzrqVy7OyPPVAkXhkLkp2i/ExWzfa9fJzpqg23NoibNF99LVg7b1yd1bc4LQxQ+c1nzU6ek2J3fhfSvjWqOFs1lruFmuL/WD6Vn6zEmsEANockr4vNVTk+dQZgEJOM8SdETQLpIU4tS1ovpN6nsoGmeSJv/YaM8stk96CZtLtMuDaqwWauBSjIsW4Rq1xq5UJI3k52RuxF4NwJ2OtMsXGZ0RYhOntnXfBnYoGeKA/VCttxoyv1LmxW7fEaiOn0vuE8+IC2McxcpMrqkJJ7XGyHNXgPYQSgICeVd7gxfqLBVR1he+m/UuEZF9BiG/9B+kSzdP1uIlYoTUiYfM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(7416002)(2906002)(38100700001)(186003)(6916009)(8936002)(86362001)(66556008)(71200400001)(478600001)(66476007)(316002)(54906003)(7696005)(53546011)(6506007)(26005)(9686003)(76116006)(33656002)(5660300002)(52536014)(64756008)(55016002)(66946007)(66446008)(4326008)(8676002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?29xgQWMHzlW65TqRPgESE/VqpmLG41laVZ4mItBGoZRrLyvHkZJNF5EnOXsp?=
 =?us-ascii?Q?scwAcsX3tYhfEo3Z/rvDtGe6J6iGM2FnIwtghInhOrKwvUZ5K3AkxSriZLeX?=
 =?us-ascii?Q?09XelxsnUIi0t6wKKhx6tR36fCC4Li886zlaya3oadiGlKd54W13DEGNAB10?=
 =?us-ascii?Q?45qfM+KIUa3h0wbQk1vBOXPAzl+AejUnp8Dn7evPAmZcp/hbSfDnz9f/IxsO?=
 =?us-ascii?Q?o6mDrm8utSt3tBrMEWN3/80eVjg/XU6SootCdzaOwpYTyRwod7uDQRSrLoKu?=
 =?us-ascii?Q?Et4TDI9UAkrtIWCTuYqfF2yKjHXy+WgwWLFi5iCdTjD2sjpQaSXdAO1EMlO9?=
 =?us-ascii?Q?1ZEhYNqXiEV1La4jVbGTvABkKybpdwyvgySqb6ZrPk7u1/ELGTRk5D+EwQet?=
 =?us-ascii?Q?jl1+s+71BF0iW8Xt8di03sPeCSLezNUEKFcWndHusEPG+l169+QeVGZPoSSy?=
 =?us-ascii?Q?X0MYggKtT1r7EikCu4FCD5ohhr4LrmLJ7CM/2egFFgrJFksq2yE3Jemvoj//?=
 =?us-ascii?Q?xf3MSyt1eTiw+oJNeaZ8MdJMn2Uv+SfwAIfwgOn2iiGgrjeAPxhfxlrgsBOe?=
 =?us-ascii?Q?4LWpSSDSzrhnfLWe8gMe2m82Er0M5ZTU2n9IudHADhXJsf5miDApOnxKoL7C?=
 =?us-ascii?Q?+YAW5Ni5oKW5AZ6bWCVf5gWxty7kv34fjlk/9X8f61urqR26eBdOhBcjuokx?=
 =?us-ascii?Q?aK1SyHk79FPP+TRd9I7CrBFH0bVgJcRfrBa9ZXGYxVGIJ2PUAaqHRGwu/X7W?=
 =?us-ascii?Q?F/D/PloSKmmLHcGYwPqei10Iyw+wXGCnS0jhn45VAwy+PBFvdIsq0/YAMmNw?=
 =?us-ascii?Q?SzDm6/9OHU48tF+p27Sn3U6OQhZBSyHz7r0vCQwl/lh2DmHsFKfNwPqW/2lk?=
 =?us-ascii?Q?Bnh+Bt14s3l8sZF+Rgv/AizoCEMuET1bGDvTuQO76vsYsOhV8j63+eExm+PQ?=
 =?us-ascii?Q?qdwRpJT17hWKV+e5f2W0y7wWS7C5vpbbr/cFfatSBf65ZZ0+1rdn3rtU8CHR?=
 =?us-ascii?Q?uHSDjRzNvsH8AtZwtugw+1IGIv1XjNmcxt904QQ2H9oX14Gaa5yOLU49pCzK?=
 =?us-ascii?Q?P/LkfJOt3arK38tj97h0334HHZqccWiVPBb6K8zRSaAnA4QO8/oYCwWlLQeN?=
 =?us-ascii?Q?caY6TS1YYfD08Nd4qEoZV43/TB+UA/dc9x0zAfQfMmy6dNj/5Pxnmq9aCJqi?=
 =?us-ascii?Q?3MSO5iFHjrJTrK1pRZnz3UiwMxSvXz3IF5whlt5TonjHgdLPxCeI19kzVoU3?=
 =?us-ascii?Q?GxErPdnS4AJav2j05yHseP4VZSgiQtN6JCfqeFvUMLtNLY0ycCwsMT8ouMVq?=
 =?us-ascii?Q?m8MkE6X7CuHFWMJDEwFeOXMh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05451cc8-e47b-4a2e-f4b6-08d8f8c39648
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 06:16:59.5484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /dt/PyclDA8J2UeJxVWwOJIsDnbFE+2i+LJDY5JlCGmoLyyBGXtUC+0Xab5LV1RzRgltKJjeDtnsXPyzBaqxTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6667
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> On 2021-04-06 13:20, Avri Altman wrote:
> >> > -static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
> >> > -                               struct ufshpb_region *rgn)
> >> > +static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
> >> > +                              struct ufshpb_region *rgn)
> >> >  {
> >> >       struct victim_select_info *lru_info;
> >> >       struct ufshpb_subregion *srgn;
> >> >       int srgn_idx;
> >> >
> >> > +     lockdep_assert_held(&hpb->rgn_state_lock);
> >> > +
> >> > +     if (hpb->is_hcm) {
> >> > +             unsigned long flags;
> >> > +             int ret;
> >> > +
> >> > +             spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >>
> >> Never seen a usage like this... Here flags is used without being
> >> intialized.
> >> The flag is needed when spin_unlock_irqrestore ->
> >> local_irq_restore(flags) to
> >> restore the DAIF register (in terms of ARM).
> > OK.
>=20
> Hi Avri,
>=20
> Checked on my setup, this lead to compilation error. Will you fix it in
> next version?
>=20
> warning: variable 'flags' is uninitialized when used here
> [-Wuninitialized]
Yeah - I will pass it to __ufshpb_evict_region and drop the lockdep_assert =
call.

I don't want to block your testing - are there any other things you want me=
 to change?

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
> >>
> >> Can Guo.
> >>
> >> > +             ret =3D ufshpb_issue_umap_single_req(hpb, rgn);
> >> > +             spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >> > +             if (ret)
> >> > +                     return ret;
> >> > +     }
> >> > +
> >> >       lru_info =3D &hpb->lru_info;
> >> >
> >> >       dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
> >> > rgn->rgn_idx);
> >> > @@ -1130,6 +1150,8 @@ static void __ufshpb_evict_region(struct
> >> > ufshpb_lu *hpb,
> >> >
> >> >       for_each_sub_region(rgn, srgn_idx, srgn)
> >> >               ufshpb_purge_active_subregion(hpb, srgn);
> >> > +
> >> > +     return 0;
> >> >  }
> >> >
> >> >  static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct
> >> > ufshpb_region *rgn)
> >> > @@ -1151,7 +1173,7 @@ static int ufshpb_evict_region(struct ufshpb_l=
u
> >> > *hpb, struct ufshpb_region *rgn)
> >> >                       goto out;
> >> >               }
> >> >
> >> > -             __ufshpb_evict_region(hpb, rgn);
> >> > +             ret =3D __ufshpb_evict_region(hpb, rgn);
> >> >       }
> >> >  out:
> >> >       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >> > @@ -1285,7 +1307,9 @@ static int ufshpb_add_region(struct ufshpb_lu
> >> > *hpb, struct ufshpb_region *rgn)
> >> >                               "LRU full (%d), choose victim %d\n",
> >> >                               atomic_read(&lru_info->active_cnt),
> >> >                               victim_rgn->rgn_idx);
> >> > -                     __ufshpb_evict_region(hpb, victim_rgn);
> >> > +                     ret =3D __ufshpb_evict_region(hpb, victim_rgn)=
;
> >> > +                     if (ret)
> >> > +                             goto out;
> >> >               }
> >> >
> >> >               /*
> >> > @@ -1856,6 +1880,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
> >> >  ufshpb_sysfs_attr_show_func(rb_active_cnt);
> >> >  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
> >> >  ufshpb_sysfs_attr_show_func(map_req_cnt);
> >> > +ufshpb_sysfs_attr_show_func(umap_req_cnt);
> >> >
> >> >  static struct attribute *hpb_dev_stat_attrs[] =3D {
> >> >       &dev_attr_hit_cnt.attr,
> >> > @@ -1864,6 +1889,7 @@ static struct attribute *hpb_dev_stat_attrs[] =
=3D {
> >> >       &dev_attr_rb_active_cnt.attr,
> >> >       &dev_attr_rb_inactive_cnt.attr,
> >> >       &dev_attr_map_req_cnt.attr,
> >> > +     &dev_attr_umap_req_cnt.attr,
> >> >       NULL,
> >> >  };
> >> >
> >> > @@ -1988,6 +2014,7 @@ static void ufshpb_stat_init(struct ufshpb_lu
> >> > *hpb)
> >> >       hpb->stats.rb_active_cnt =3D 0;
> >> >       hpb->stats.rb_inactive_cnt =3D 0;
> >> >       hpb->stats.map_req_cnt =3D 0;
> >> > +     hpb->stats.umap_req_cnt =3D 0;
> >> >  }
> >> >
> >> >  static void ufshpb_param_init(struct ufshpb_lu *hpb)
> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> >> > index 87495e59fcf1..1ea58c17a4de 100644
> >> > --- a/drivers/scsi/ufs/ufshpb.h
> >> > +++ b/drivers/scsi/ufs/ufshpb.h
> >> > @@ -191,6 +191,7 @@ struct ufshpb_stats {
> >> >       u64 rb_inactive_cnt;
> >> >       u64 map_req_cnt;
> >> >       u64 pre_req_cnt;
> >> > +     u64 umap_req_cnt;
> >> >  };
> >> >
> >> >  struct ufshpb_lu {
