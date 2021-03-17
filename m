Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8067AC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4F764F99
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCQIAP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:00:15 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34245 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhCQH7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 03:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615967987; x=1647503987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=itOXfFDPw5vwH5Qxy5JgbGEzjyNWyk3PKp/EvH+ntLM=;
  b=J0QhRAv0Gn3Ny9Tjy8GmjfctjNVUZPEFXAIWODjax5GKvxwp1Cv8fWlx
   xHFFsSwPddDHb7itHw0/oOcdxlbVzvkpc1luA5LOZ/CfSJWJgT99BM1X4
   bEjL6zuit2D3rg/NloYK2JK4qzCfKixpn1nEGNmR7zTniDMA095CTxs9G
   +WOUhOYmf1VumaVp2LeVlvO6FjcnKKNkEuMK2/D/tTLHEP43NPULKJfr0
   yMmQDh03Wlicvz9ATxOoOwpn+8MkxnHibwXhVD4u7tKHgvFHK/4RrjSmf
   EX/2zQ4IEBjCHTLNZkSAAjnpzOLnsINSPbgg5ulfWcidtzFN2rGi2QpBl
   w==;
IronPort-SDR: JeQCeziPCeCQKUqsBH00QwkH1e+1y4D5wM0SKKpgFLhMSCpGnHdBmuQc+Su7/z0cxpByPXiUUx
 fbW2GwpoUuA1772U8VVw3h5tBy3ZnbaIYanKTmORavkQ3F1xS5uJjYpSgesm9G/wJ9bFPfE8wi
 LV8TteshkZvFkpJvsxBO91aE6aBI89UjOPhZFTqcJ0gg0TeD2dOlemKaSNjCrMKaBakpgiRuaM
 Fsjz4+k+IhqS6G+AFSQTYMgLgQ/bWBPwVuyW96fj0qxtuNxL127BQ3h847ppc0E+nsgSvTaMPQ
 XKg=
X-IronPort-AV: E=Sophos;i="5.81,255,1610380800"; 
   d="scan'208";a="163486874"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 15:59:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luousQdCZ7Q+FdwrpN/Gc+unoyJt6eQcqpijPIIxLTR2FElBYmU/RpGzn5VtsBbTFhSfDeuXongsxKX0ThDjXPRBzDYgDyzcNnDTOz5hhrTANFrnK5asixwTdmPcdGpNaOm+v+deNCcI+TN6D0mBDq972qvnri14pWpP1ggRSBWD55cVOm4CuXXAokKBg8TGoeNhDMV5Kc20DQK90v6aIqgvhm899WMyD8r156qoZLNyzXfVmzr+enqzFAie71Sj2JniVqfMPFmADVsDyQAogL8v0JAx+YctAClV0MYS3vCwzvaLZBMRyR7KnH3xYsGwPqlm1ku/J7YTooT6d7HLRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moOoNSwJdipe27ff9ihSGSNv9LZ9VbGiSOuCCze7/Y0=;
 b=UPQE8+u8k/JIAnEZQLgzKWAC65EcBe0J0g3DjZl5DKd+pEyjwzySLu7ZWaVsgo2Gg0IaMr1WHjJA6DbmuK+24eaMCodb+zVmU/ZLkchDbIijq/S0LIhgtVkaRd1Kj4FTawi2nrCaqjZ8labv0rc9eMV0OaexZI9dPVXlUPDwdO6fdKQD4AY0rBbCZ3HIwL121crvRE41YsNRyaWrjwcOSbkaTP4mi+jmwPhgiYUPZOcTsnH8bbduOS1eDbHPyoTO25h2LoRv+AOAvrTRNqHXQ7TnZahZLZ6n2mJDnChyP0GwJ+hJC9tnAUyZZBYZxOmJvhEMHpM0xqEKV4FL0nm6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moOoNSwJdipe27ff9ihSGSNv9LZ9VbGiSOuCCze7/Y0=;
 b=V25qLJFi1g+Kcl4S6n5TLi4FDazBT2L2d4AkHNsieSaMi/04MXx/laZLBh2bOjiS9Jntb3K8h1Idhf51im14E6n/G8kEhUdjI8p7rKw6ramCfZes16MYRMfatIng4MCP/4nPt/YuCUxrn6gKNxVL7Hoo8JiNoKslNRG54L6KHdQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5082.namprd04.prod.outlook.com (2603:10b6:5:1a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 07:59:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 07:59:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Thread-Topic: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Thread-Index: AQHXGufzsAcNB2kctkO70hG9mtiIo6qH0HMg
Date:   Wed, 17 Mar 2021 07:59:42 +0000
Message-ID: <DM6PR04MB65754B711A4123A8025BB0A9FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <DM6PR04MB65751EE32D25C7E57A6BABE8FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-6-avri.altman@wdc.com>
 <25da7378d5bf4c52443ae9b47f3fd778@codeaurora.org>
 <57afb2b5d7edda61a40493d8545785b1@codeaurora.org>
 <CGME20210316083014epcas2p32d6b84e689cdbe06ee065c870b236d65@epcms2p3>
 <2038148563.21615949282962.JavaMail.epsvc@epcpadp4>
 <064483451ff0d9ef8703871332ea5c3b@codeaurora.org>
In-Reply-To: <064483451ff0d9ef8703871332ea5c3b@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0d4ae43-3c73-4797-7b26-08d8e91a9f53
x-ms-traffictypediagnostic: DM6PR04MB5082:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5082E137CEC2941179B29E7CFC6A9@DM6PR04MB5082.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lij0E8cu0fbfPAlBAkmhyAbYUpE3eFhNDpFWzCIWHaS6qrPehBCpA8TGXNkK00T2QDp26NbMDmkgMp6m2R4xsIIdFscZmatgrXk6BfPLFZCnrgqmDGjqu4HNdBEjpRYcr2gOYEhK2kl7ZApVQCNoMFEIOOTGDLgyH6Tql68Pf9xR+dr6UOnxsxtX0LJujpyV/TD1gKC3m1grgqTOKJYso/sERjLD2QsZ3//kkt420D7771/AjYRQKSIPUbW3y4vuDmkdgPgdqZCd1Fp3iyMmBVWGBKQKwLIbrfjKQNZJHdH8JBMHLZNQPxkUGAia+f3yk6NC29kdaGrwq/Vjgwi28UpkgJQyDM6y2DPpaUpQZNwCmSTIBWXhdGzAibSbH6BX+O/RSpNFaRjrkXf0HF855d6b/kpLv/uJVbPSBq3HjZPYZYoc7gBWPZPgTL5D7miJPdv1UgODpeAQJWw+cXNNr9mH2rAaJ4NNbjPzdHG9Xq/2Fv/Kt7xxmhY4DIxJKql3ORW5Buq3zdRMKTsFSodvvxbCa4JzS6lOyFTbstpOwFX09Ppbexce+IysBZ7C76to
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(52536014)(83380400001)(8936002)(9686003)(186003)(76116006)(54906003)(55016002)(71200400001)(7416002)(8676002)(66946007)(6506007)(86362001)(110136005)(66446008)(66476007)(316002)(2906002)(64756008)(66556008)(5660300002)(33656002)(4326008)(478600001)(26005)(7696005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?t9ky6/s1FknnYmyS5lIznbrEw8AOlIVm/Pm+qZpOHRGGGkl8J0qp6DZ9u4wg?=
 =?us-ascii?Q?PKhKUVxvZb4NsjMXj3Njon7mVn9GjKMC909Cf2xnhR4jaMX6xHoTpggf+lZP?=
 =?us-ascii?Q?WQ3EmfB5Uobf+NL5Jpkqy/ufp6ajeWl/8uBKMhVDKWvhvUuQ9Vf37sqaEZ0J?=
 =?us-ascii?Q?ogn52Wl+Ob5q/nAb7GZ2+vqyQDQnV6W+EPH/AlzhoUrKRLWAgSLSlmEUqBqX?=
 =?us-ascii?Q?axPvfXmU5vB/1OEvSz9nhN0RI6vMMn0NHEBNDy9Qg97U2cOp5D7gcbaEO957?=
 =?us-ascii?Q?rD6t9LWeYn8/ZOZL3gKt+0FyFANUaEmANw43H+jUbH/0qeaeUeLBYUaKpe8L?=
 =?us-ascii?Q?ZSHL7Du8y/Ir7NXI5/tANYIi71MVZlM+dR6ynsA3gul5lyX9HQCp/4okrSfM?=
 =?us-ascii?Q?X5nzneatBAmApgYERRQVLEemipqU8CKopGYWLzZWn2U8qD9vfyxMlllxtL6h?=
 =?us-ascii?Q?NDk1n3ZBJvhNeyr0ulaat4Fog4XqxJKAiQkijtS9rapyCMuPEIdLBvElXTUK?=
 =?us-ascii?Q?uQkNEx99UM1XDIeaEx1i2RFiu/pMHsXK7020342XK6cbxisj3pM4KwTW5pKF?=
 =?us-ascii?Q?paedAtXXs3B2dBKW35VHYYu9wIH/6kkQ+mtTTqXHuWdlvhZKt1QUSWQNN6MM?=
 =?us-ascii?Q?tHWRQa1pOcdaD71FsWGnCisKY/tc5KJ/ORzICg4xIGdvbWVwxIg4v/LwIhev?=
 =?us-ascii?Q?5CO/xg0HAU0dQDCUSMhftecuaB8vQqZfeLHxzPv/BT3YqkEhU30mizsPRHf0?=
 =?us-ascii?Q?NupWowbNdJzIQqaX7rZDzBD7yFGlJD7A1nBgMU051PJcGsjKQb26ChTct4/9?=
 =?us-ascii?Q?1TLozi90XEdQbzkZ4MbazGhm+Ql0JuukCakHKOyQaRR/qdTt8a3bd9PWpp8+?=
 =?us-ascii?Q?WCSV/aZEV4aWbikHrtiXNdm8Dj6Foj5i0ur9X/Uy7JfmDBcYTnFJHfkSlMUU?=
 =?us-ascii?Q?JP4ODzxaE635ZPGi1zlyNB3tBzbwIrVXf9w4+D7kObR3pVX9l9ofajKhTySW?=
 =?us-ascii?Q?883RO81cymMS8n4qrkNT8HtAh922Plny8hzBjMxHAm8xb6qwlxzfnfqdVNus?=
 =?us-ascii?Q?RBibRTQfT9vE55RvoQsHI9VFtDdGsw5GOGgt95lMspnsPekh91Sz3+3Cv6kI?=
 =?us-ascii?Q?Qt7MbfOMrh/QGO//W0/SdJMfFxpAsFf5Y3PGpgpIMnEakuY3ZxRRi0sppNpM?=
 =?us-ascii?Q?bcABB6LDVzkmo5OlHA2XjrdFaVYTvMDlCmnExo4muit0KfbsIoiSWuLNvbzB?=
 =?us-ascii?Q?T+hPMEaASZZC2QsHI+wFnCd29L8ZjXTvCX8Rq57YmhQkvA6+Pr7EumwR0HfQ?=
 =?us-ascii?Q?W0Usrl1wScbz05TIuNuaQoJU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d4ae43-3c73-4797-7b26-08d8e91a9f53
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 07:59:42.2881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iV4FXPxbGbn9e2mbIqLnnCOSnTeZvtM0vBLTPr2t1JgdqVYsl5BysRMO94/0mwwjFVFpJUUqjbV7bpnHhKOplg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5082
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021-03-17 10:28, Daejun Park wrote:
> >>> >> ---
> >>> >>  drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
> >>> >>  drivers/scsi/ufs/ufshpb.h |  1 +
> >>> >>  2 files changed, 15 insertions(+)
> >>> >>
> >>> >> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> >>> >> index 6f4fd22eaf2f..0744feb4d484 100644
> >>> >> --- a/drivers/scsi/ufs/ufshpb.c
> >>> >> +++ b/drivers/scsi/ufs/ufshpb.c
> >>> >> @@ -907,6 +907,7 @@ static int ufshpb_execute_umap_req(struct
> >>> >> ufshpb_lu *hpb,
> >>> >>
> >>> >>      blk_execute_rq_nowait(q, NULL, req, 1,
> ufshpb_umap_req_compl_fn);
> >>> >>
> >>> >> +    hpb->stats.umap_req_cnt++;
> >>> >>      return 0;
> >>> >>  }
> >>> >>
> >>> >> @@ -1103,6 +1104,12 @@ static int ufshpb_issue_umap_req(struct
> >>> >> ufshpb_lu *hpb,
> >>> >>      return -EAGAIN;
> >>> >>  }
> >>> >>
> >>> >> +static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
> >>> >> +                                    struct ufshpb_region *rgn)
> >>> >> +{
> >>> >> +    return ufshpb_issue_umap_req(hpb, rgn);
> >>> >> +}
> >>> >> +
> >>> >>  static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
> >>> >>  {
> >>> >>      return ufshpb_issue_umap_req(hpb, NULL);
> >>> >> @@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct
> >>> >> ufshpb_lu *hpb,
> >>> >>      struct ufshpb_subregion *srgn;
> >>> >>      int srgn_idx;
> >>> >>
> >>> >> +
> >>> >> +    if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
> >>> >
> >>> > __ufshpb_evict_region() is called with rgn_state_lock held and IRQ
> >>> > disabled,
> >>> > when ufshpb_issue_umap_single_req() invokes
> blk_execute_rq_nowait(),
> >>> > below
> >>> > warning shall pop up every time, fix it?
> >>> >
> >>> > void blk_execute_rq_nowait(struct request_queue *q, struct gendisk
> >>> > *bd_disk,
> >>> >                  struct request *rq, int at_head,
> >>> >                          rq_end_io_fn *done)
> >>> > {
> >>> >       WARN_ON(irqs_disabled());
> >>> > ...
> >>> >
> >>>
> >>> Moreover, since we are here with rgn_state_lock held and IRQ
> >>> disabled,
> >>> in ufshpb_get_req(), rq =3D kmem_cache_alloc(hpb->map_req_cache,
> >>> GFP_KERNEL)
> >>> has the GFP_KERNEL flag, scheduling while atomic???
> >> I think your comment applies to  ufshpb_issue_umap_all_req as well,
> >> Which is called from slave_configure/scsi_add_lun.
> >>
> >> Since the host-mode series is utilizing the framework laid by the
> >> device-mode,
> >> Maybe you can add this comment to  Daejun's last version?
> >
> > Hi Avri, Can Guo
> >
> > I think ufshpb_issue_umap_single_req() can be moved to end of
> > ufshpb_evict_region().
> > Then we can avoid rgn_state_lock when it sends unmap command.
>=20
> I am not the expert here, please you two fix it. I am just reporting
> what can be wrong. Anyways, ufshpb_issue_umap_single_req() should not
> be called with rgn_state_lock held - think about below (another deadly)
> scenario.
>=20
> lock(rgn_state_lock)
>    ufshpb_issue_umap_single_req()
>      ufshpb_prep()
>         lock(rgn_state_lock)   <---------- recursive spin_lock
Will fix.   Will wait for Daejun's v30 to see if anything applies to unmap_=
single.

Thanks,
Avri=20

>=20
> BTW, @Daejun shouldn't we stop passthrough cmds from stepping
> into ufshpb_prep()? In current code, you are trying to use below
> check to block cmds other than write/discard/read, but a passthrough
> cmd can not be blocked by the check.
>=20
>           if (!ufshpb_is_write_or_discard_cmd(cmd) &&
>               !ufshpb_is_read_cmd(cmd))
>                   return 0;
>=20
> Thanks,
> Can Guo.
>=20
> >
> > Thanks,
> > Daejun
> >
> >
> >> Thanks,
> >> Avri
> >>
> >>>
> >>> Can Guo.
> >>>
> >>> > Thanks.
> >>> > Can Guo.
> >>> >
> >>> >> +            return;
> >>> >> +
> >>> >>      lru_info =3D &hpb->lru_info;
> >>> >>
> >>> >>      dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
> >>> >> rgn->rgn_idx);
> >>> >> @@ -1855,6 +1866,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
> >>> >>  ufshpb_sysfs_attr_show_func(rb_active_cnt);
> >>> >>  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
> >>> >>  ufshpb_sysfs_attr_show_func(map_req_cnt);
> >>> >> +ufshpb_sysfs_attr_show_func(umap_req_cnt);
> >>> >>
> >>> >>  static struct attribute *hpb_dev_stat_attrs[] =3D {
> >>> >>      &dev_attr_hit_cnt.attr,
> >>> >> @@ -1863,6 +1875,7 @@ static struct attribute *hpb_dev_stat_attrs[=
]
> =3D
> >>> >> {
> >>> >>      &dev_attr_rb_active_cnt.attr,
> >>> >>      &dev_attr_rb_inactive_cnt.attr,
> >>> >>      &dev_attr_map_req_cnt.attr,
> >>> >> +    &dev_attr_umap_req_cnt.attr,
> >>> >>      NULL,
> >>> >>  };
> >>> >>
> >>> >> @@ -1978,6 +1991,7 @@ static void ufshpb_stat_init(struct ufshpb_l=
u
> >>> >> *hpb)
> >>> >>      hpb->stats.rb_active_cnt =3D 0;
> >>> >>      hpb->stats.rb_inactive_cnt =3D 0;
> >>> >>      hpb->stats.map_req_cnt =3D 0;
> >>> >> +    hpb->stats.umap_req_cnt =3D 0;
> >>> >>  }
> >>> >>
> >>> >>  static void ufshpb_param_init(struct ufshpb_lu *hpb)
> >>> >> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> >>> >> index bd4308010466..84598a317897 100644
> >>> >> --- a/drivers/scsi/ufs/ufshpb.h
> >>> >> +++ b/drivers/scsi/ufs/ufshpb.h
> >>> >> @@ -186,6 +186,7 @@ struct ufshpb_stats {
> >>> >>      u64 rb_inactive_cnt;
> >>> >>      u64 map_req_cnt;
> >>> >>      u64 pre_req_cnt;
> >>> >> +    u64 umap_req_cnt;
> >>> >>  };
> >>> >>
> >>> >>  struct ufshpb_lu {
> >>
> >>
> >>
