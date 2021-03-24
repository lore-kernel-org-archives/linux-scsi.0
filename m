Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79226C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 11:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4663C619F3
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 11:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhCXL3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 07:29:20 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22285 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhCXL2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 07:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616585329; x=1648121329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ud5YuWGNL9zhwmL+SZrqi6DOJfu/e05ifZBVBs5eVa4=;
  b=I4aISQcHKkvylT6K/WzF+V3qOD5YI86LOl+1F6mdB/QHgB+P/ldrg2EO
   0bfpS2FJ0iPN8X0rb88kr9S2GpqsTmOcs/VmnZNkehgGsoCum1xcQAZPL
   /1xAC08MLA8pmlnOlrN8neOr8jopC6kTMAymf/xapLQ8++01cRL/QfyHF
   0GjPifutePVXzMSMFo2SfBusn46SzEZYw5sux0plm/XlwkQ8IRA7BVUVv
   ZrVVPZPX+fky9FXxuGiqLSbEQvVt2cmT2nuVR43j4kxFCxDf1pZL9Hxc9
   w/UHwxJ91fIYDL7a+raCiUIMO3ZjQh/HN56Vyj+g02y4PA4v3N7iQcUQT
   g==;
IronPort-SDR: Qkbhx9pqHg3ezIp3AwijUUppdC6uF3SnP+p2pvDjXQnVAdok8g+MMbIR/jdDFTxIEO5ls6yA+r
 O1b9IDGhN9/9cb4O8OsEGyAu7ntFT0Ej4ALW0Txuc3O3ZweW+e6ZjFA7tLzqrWtxHA49yd5ATC
 bwIYrBuvDu70J7cxYrbwYujpNgB39pFlsT+r9bAnEkzK9GfQ29yqgRfJbLO+ScGE73rCakEYfZ
 c6JTq9EhhgBo/tDqizzM7KPRaJCSJaXPY21Aqztk8tmBZz81x8x/X9gb/Won+2OjLqC+SWk7TA
 eb8=
X-IronPort-AV: E=Sophos;i="5.81,274,1610380800"; 
   d="scan'208";a="162838229"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 24 Mar 2021 19:28:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lP+eFrrj6BIFC5HRZVcdRLNKk5/2ybdeLOX2DztmptydSvSIsqXz/dRPLmR/Z9GSB68APzQFhW5dxucKKNE/2MDuOvrkLF+cE72YjrvewBoNetxMlGqtzR8PdoHUPdOEIWXG1gF9a1nbqROp5ubR2PVerG3SR/32cQTU9WE8Zb9XNWt1xRoNRxA0Z0pMYkdNs+xImkoAkROsBpZKQ9O2oy1EBzg8pjp3h7O+GYNc3AvDlP/SMphTzV+fQ7guBC3NukH9V6G2NkRmLGqVyzE/Cw2K1x2l3WHRf6fXyAwfKdCDKgXrFP3O1Sqol/UH/5Jsyr4W8NhMPbdpj46ogN58/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXk/7kngnmd5VHaS091Jsc7EcbesvhasDbL3TY0wIEc=;
 b=YA7GoU2yrMJSbMw3Rnq4B0y04O6lcbeBfjVlnortX8kAL2y+IfRlB/blwWjyIXGxyHQn8HNBGRqauF41RF3ah5ggxMTD21aFLf0fnPS/SYBuVERnAnnfD9WNOamk5Zzb0vzofE/2xAVEaCuuWTDWPpExh3h6+3VYQdbVM9Ka7qcnDWq0WV8NQOIhh/xyx2VLoHN8EHRLXAnP8ATAKbmg0us8do5rjSOk/9CeQnM1wfyIqQ5LN2Ub7+KnGX9FvYlpVoo/r986pk0D+kz0DRzkkvQMgvkLl+4N8P85Vs7ZdW4Q0hj48jDzYDpO05jj6gol9O3RE5YkwE8Ojh49B45MtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXk/7kngnmd5VHaS091Jsc7EcbesvhasDbL3TY0wIEc=;
 b=z77POH5hAZ2Sqg2IBowqi3ztMP2V2m09vir0ghmEy7P3wTonyZjSBy5/Vxgl+py0jXOWliSPLFDTAO1pQtpwtoMfdzU8M0FVJUviyzHEfl8osYV5X/vVpPz8e1xqtvXItSwbRKaa9z1NwnhTW9s17SeuH13quoskhWEF0b/0uLA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0538.namprd04.prod.outlook.com (2603:10b6:3:9f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.23; Wed, 24 Mar 2021 11:28:46 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 11:28:46 +0000
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
Subject: RE: [PATCH v6 03/10] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v6 03/10] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXHvL+vc4JYsRlSk+QZni8T9rJ26qS4VeAgAAhScA=
Date:   Wed, 24 Mar 2021 11:28:45 +0000
Message-ID: <DM6PR04MB65752DA7982142B85F82344FFC639@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-4-avri.altman@wdc.com>
 <48758404e172e8faca07c3fab8a3bd5c@codeaurora.org>
In-Reply-To: <48758404e172e8faca07c3fab8a3bd5c@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [192.116.177.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c2915648-60d4-4fb4-cc7b-08d8eeb7fcdd
x-ms-traffictypediagnostic: DM5PR04MB0538:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB0538F90D1C4FF1BD6CC5AC8AFC639@DM5PR04MB0538.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cjT4/hw6QMb62xdEhVCK0F2sIH2EeFMhEf88ra1z0Mg2XGI2USz60P6fAKwKedmShP06er58y231mf47RPfTUpr0G1T2vbf/ZigmXqovOoWdh91jdyOwdMrEAVhrg2r/1aVvx1do/3hIYMeCQDKC9EQ1DD6LJ9tWkA3+OUQSFscQtHgNz6u9Rc9G23A6KiH67JCKlXXKpsxJ434B0wkDiniYrrgj1f5q4RjY4ggwQC3M3CSxlWFOq99RUBO2Qs02bXwtPMxHYmX1VZAvdBVhdDHKWVR5PaCRqdEnC8PziIAXBrRvds/sl6ux2UWqAybj1kVwmWOhwQpeZ7qBW+ZJz2MTxB36u7Ag8gAxqiyTltvPbNmuzAyQrtOU+a/+LEiTDSnxW6NR/uhLLi2plxHEo7zCK1sPO+/16i1vY414/O+GlVezPTiQOsDrhd7cSylydzGgrMrS7+bE9/qKX2WNysdRum9TXDuc7a0+AJWV+QLfmeDLdaoZNBeq4N42xQI5hAXlq5ZWzKKkcQlvPBl9Wn1C8CpjiYNuoPBrT3AzP9v6DbJpPAmFQHsj2JeHhggDAJCOjlONCSyHhPvQK0lfDjpH55xM75dEVC7zsTIHi3g+M8VmmgGPvi1mOAcser5xVT61245MPHqVzMT85vSJF+44sk195BClD5FH011NNVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(8676002)(66556008)(86362001)(66946007)(6506007)(64756008)(478600001)(38100700001)(26005)(5660300002)(7696005)(66476007)(33656002)(66446008)(54906003)(7416002)(4326008)(316002)(55016002)(8936002)(2906002)(52536014)(83380400001)(76116006)(9686003)(186003)(6916009)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+vSdLY3GLlysc9JVtD2WIaedn3vHRBLSeeiAE4Y6zkwFXqJInsuK4whQI7O8?=
 =?us-ascii?Q?Z5hsAYV20RXbGqMEgCdUIVMPsMpF2dX6+OrjI4s5fa5b4aWZuRMqKnEOW2Y+?=
 =?us-ascii?Q?WvCzSOH6mdV2RjvII5/pfqKEZlZa2hq8vQ/EN6DUxWorXqqJG3IXUzHeqIeI?=
 =?us-ascii?Q?4SXHCzl8TJZ8n9UZkijgiAsaXhVJuQLQMjcRjRGQOS0xioKlOdXYnXjKful8?=
 =?us-ascii?Q?o7jLUv9cQvIN6DoLdWzD+AW5ZAIDb0GxUFpoI7uyYmRK5bu8UWEGJgJCYpHE?=
 =?us-ascii?Q?Ig89lifnqqA139XxJaH420nfRbnhcs5uEfGnD0oss0HkSMG4KUA/rgqzTXZh?=
 =?us-ascii?Q?1NlDiK/pKjjVZyfvoPJdLSUGMDeitbQ2FqG8WILDLDheZx+5SyB51OL7x0fE?=
 =?us-ascii?Q?MgzxL5+ITre8vVUWeEbUlEcaGQs/1xjA0oq4JkrIHKd4WyLU7a+XecGoZiKZ?=
 =?us-ascii?Q?JxxNhXdexYS75rzhGmafVJOMcIWpEO2ArjYeFPiFc6nJTc3blBY4N3l9WlUJ?=
 =?us-ascii?Q?2bYibkCHt1q1v584FsmSY2alGwnjX012vP6zrN2gPkCx6dsI997BLA/uFNwB?=
 =?us-ascii?Q?NcjZxwGa0BULAp6sFSOdTG6jBQ3e0hxzXUudtHwJACWEtedilH4ceJfpuHLF?=
 =?us-ascii?Q?zHEj754XFb+DFdbymzS8gfCxsJzzEW1YuGKF5NXgV9tu3Wr7T2AEusEaLZWw?=
 =?us-ascii?Q?t3pEm7EeIeqoivTwkannHs5xLXgAXRWiqauTICayV/SRpdJx3zQgRSHwmzKX?=
 =?us-ascii?Q?x5cEv6suLV4XCnte1z5Cfh+jPJQRUXZE670dmUD3FlKr2OpgyzsTjF/glm2p?=
 =?us-ascii?Q?Ejizr444FxptOb25A5eoGxa7B790APd090TWSldcHDVDTjDMMb1sREGdD+yG?=
 =?us-ascii?Q?mT/CMQhc9quLVHTofpr/p8py8vFoDA/Khp4jmtAgI7CBx7xs20oTyN/FcI+a?=
 =?us-ascii?Q?9E9AjCOM7GBUroDV6x6htugK7KQ4ZCp7ygSpFKjLnIkoE4hDBaRVKO81w6Ti?=
 =?us-ascii?Q?toQctyyASgnBBypJtIj1hYz+mRFet2pnKR2nGsqmMEoMm4gtLECmenx9qTED?=
 =?us-ascii?Q?spfRZifF179L3srWSJiTZYzlfGufGWTHPnHrps+xXl22pxZ/DgA8DPXdFU3X?=
 =?us-ascii?Q?730qt6rEcpPoUr2Ml2OkhUgtaDSyUtjxMc09Wyy8gZXpvf7de5if0id2YQE5?=
 =?us-ascii?Q?aOcuCWmPxeUeIy3ntqrYhvqx9JEH1I3XmXemB9wWZZKKPcajB4d0fg8na0tT?=
 =?us-ascii?Q?BJOeJgnytR6T71Bq5HfZ7fcLpICk7b4ry20XYhAAaOH26AtD+v1+sv6ITDzB?=
 =?us-ascii?Q?5V4DJjfZJ5A/PCJTgaMezCnY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2915648-60d4-4fb4-cc7b-08d8eeb7fcdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 11:28:46.0520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s1UiDaJCtY7Wk5/v7AjG9RGJiO/vr+hC+gjQd4Z6SrlKT/YdVnmMwszLe4+DmVWDSnlUJbG+ptyNJptrrr8kIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0538
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > @@ -596,12 +615,43 @@ int ufshpb_prep(struct ufs_hba *hba, struct
> > ufshcd_lrb *lrbp)
> >               ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> >                                transfer_len);
> >               spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > +
> > +             if (hpb->is_hcm) {
> > +                     spin_lock(&rgn->rgn_lock);
> > +                     rgn->reads =3D 0;
> > +                     spin_unlock(&rgn->rgn_lock);
Here also.

> > +             }
> > +
> >               return 0;
> >       }
> >
> >       if (!ufshpb_is_support_chunk(hpb, transfer_len))
> >               return 0;
> >
> > +     if (hpb->is_hcm) {
> > +             bool activate =3D false;
> > +             /*
> > +              * in host control mode, reads are the main source for
> > +              * activation trials.
> > +              */
> > +             spin_lock(&rgn->rgn_lock);
> > +             rgn->reads++;
> > +             if (rgn->reads =3D=3D ACTIVATION_THRESHOLD)
> > +                     activate =3D true;
> > +             spin_unlock(&rgn->rgn_lock);
> > +             if (activate) {
> > +                     spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> > +                     ufshpb_update_active_info(hpb, rgn_idx, srgn_idx)=
;
>=20
> If a transfer_len (possible with HPB2.0) sits accross two
> regions/sub-regions,
> here it only updates active info of the first region/sub-region.
Yes.  Will fix.

Thanks,
Avri

>=20
> Thanks,
> Can Guo.
>=20
