Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13746C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B505764F4F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBBLzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:55:44 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15245 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBBLzm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:55:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612266941; x=1643802941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ob7a/Dl3Anf21UcX9UbsDra7pu8h+06wLgAcuJgPNGE=;
  b=qHrLB3ypYyFLW4XLPCE/BuRGW0K1gLDuCWZdWrKVOEwraTlVZ7/DFfDJ
   GItkmfbp4TeBzLzm7ZGtCvk1wuqDyt2xh2QcaOeiel2r5WaDfWYv/Z/pt
   HzO4V/Ogv9l+1VAwfFXXx9cKzdO99x9WnUM3ztpZZBNLdsieT8fONBEi1
   HUM666wyUEQ0zIjHR2V0Xq7Sh+3dwpGNPqC35C2s9xLyvbB3lUX/YdFAr
   pSrXncjwwS4IKrLE9AYtYsrUOdXriQieZ5Ya5reJ8hV5AvfCv3TVtD5ln
   zBpeIkx5YwSG4X1P6zfwAvJyd4zYLkIVFLaPPLv2Qfu2WF2zn7vRDEKfJ
   Q==;
IronPort-SDR: 425Yz0lugLTIQw4XD/XKWlaiBaXuqlOYysrX8Mpnm6lohteb6EC8vxHfftMIbLjjvUrYdkWucg
 lkiUCRlcG4ifiSoqFNa/WBbA9cOI74Ig9Tj/HiO79warUVjkTENWHuSMBqxxciF2iotX6XZtAZ
 4cW2LIoXLwmEIqMqj1dWS9iGt6Zz4+iQj7mQTC+Ukx+wZPN4qd9ClXgEDkidwapFji23OpOMAi
 YttpXz1vCoJpR1uTxh9CpK/nIjpKxPlxtqMatKahOKoXvP5650Gz9LmjBIms1l8ISNMlygT0yO
 duw=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="163361763"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 19:54:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/VlN8BTlHY4/iR8ZGoZRluZyQnD7ctMzDmIzIsSy6e84pgTQgray69Ll9d/L5HHs9XyVxHOoDw6JpfpuVAooIF09YkSUN1cKt7FrzhrclK+dwM6c9GolvcMNOb1qgxae88AHCamGQMZgRHEfQdf/NN4ght/T1fUi8yl9UiRSbf9ctMVIhoBrJKLi+ksWqRxKEn3f7wMnS/SIK9T0O4aTSnHBBVeMDHiEC5SNgodYWIMT/ue5GhArk3MSq5+u4h9wUSvx/I1qOfwJFPcPEvmEAukkopgyNQ4Lcwn4LosfvX9E930eOUe2diwPF7+7dnCZQyYxvJheG9q455AdwG89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teriWnPCeQ9fitXMTJJYuxOm4W0jykj8UF20VIQ/MqE=;
 b=mp5G+Q7hz+AayBibkGB9TQSHHWEp/5jKUW+8+Lmdh1E6hGjJqiQAYMsFy87mvMiRhPju3+Emw/OTvGlokqnbnxuHc8aVytRYbtlZyYB01tQf5F54YjzO6YfIwcirxdWfWDyg8z+UkaGd+nRfHbG4aro2yiQ5i+8yOIyZv1iBoRt7Yj6FgZFIHxnA0cH8cU4LIAO2vgHnkLVMwPLyVTa93/NBIrojFZplcoZ2guovBFAc3XKdOCDDn+p7AHoPqKNXj7uqgl1HT/7vs2FO8zafCYKfHdJIahFTEsDL2i8a9CRntl0qEmxUdXHF6e5ojo3F7u9Qit+JP4GCOlhxHmBxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teriWnPCeQ9fitXMTJJYuxOm4W0jykj8UF20VIQ/MqE=;
 b=t7NLMHvOqd7ZbpQ3xlUksHwRrA053V2vMeAd0xFGzVtuT4mJ8+pUBPsmZJiKrgDoOZ20dKnI8xae2bgMnqh4wLAOo6pXzuCzRZKS41XKYDX+0tvoyjXlhzFs9VyKdCf+BFlJx+cJSwl6bxDNMyHsUcNFkJqqX5dR5AcCbinJhQo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6139.namprd04.prod.outlook.com (2603:10b6:5:129::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.24; Tue, 2 Feb 2021 11:54:33 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 11:54:33 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 2/9] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Topic: [PATCH v2 2/9] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Index: AQHW+T20gCB3H9uAPUqvS/piDh3jCapEtnsAgAACqhCAAAf6gIAAAHXg
Date:   Tue, 2 Feb 2021 11:54:33 +0000
Message-ID: <DM6PR04MB6575D836D307AA89D77E8640FCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-3-avri.altman@wdc.com> <YBkz7m7uMP4iJ/qn@kroah.com>
 <DM6PR04MB65754BB7B07301D2B35B6490FCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBk827Gh9JU3sNJZ@kroah.com>
In-Reply-To: <YBk827Gh9JU3sNJZ@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02b4cccf-0752-4ee1-c815-08d8c7714e7f
x-ms-traffictypediagnostic: DM6PR04MB6139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB613906A39BE5E167066CCFD6FCB59@DM6PR04MB6139.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:161;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zI0ESmlvacYZaP7ttenVDnxSPo0Yb0U+xycaWb3A5jqYznOGXoC4/+LYChmzoUUubOtObyU+xZJSOpuSd7NNB9D4FGZ160fLige36Oaf3XUsNwamJ20tznFV4r/hmKZTUFJvl7Txal2UlWJH0KFYBOTSMvyQAO9S5QwKifxiAy5Vg8WBjiNZXg+5mBvw1iY3jhWmr+kvZZ9t1e1zbAux5diASV4cvplbcRyt4Ly6ZEIum4Cfzy7kCc496ztFZWBqCuhiAed2gfGDQPLSFrDxh8W+dqh8H1r5KGMevnq3HD0WHxwm3O5R5Z+Csps0nNR+YRsZ01PvRhnqs2oz6p+Hjswrt/CPSypbgS2KG3jyL0dRuVFWVyicqA40LPcVFvDA7/mmucB8pQbthgx+rff0VEqkn3Q1iuQ6RbX+vaIapz0MGzBvyYqBZ56j/PlTgtQHVXHbecM1Eoo+wEG5VC/iS02NKgjHmzbITBdWkMvCxoYnGCPYQOIyswSkn6BNEG1Q4wIwc8+FMkHaA8X6QQy5Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39850400004)(366004)(7696005)(54906003)(71200400001)(2906002)(8936002)(5660300002)(86362001)(66476007)(7416002)(6916009)(186003)(6506007)(26005)(66446008)(9686003)(76116006)(316002)(64756008)(8676002)(4326008)(52536014)(83380400001)(66556008)(66946007)(478600001)(33656002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OLPvWo5CE9YwWCC6FAB6E8bVUhtf8lcgXonJj2cvYdawBYbuLwG5/NUg8iLc?=
 =?us-ascii?Q?MbL0mC2dbG3dP22z/QtNXCe8Ju2zWVexeJQ+8Hi5Z4lkQZogaznNgfAh3qFp?=
 =?us-ascii?Q?zTQKUB3pqVctR7M0/2o2BYuIF32f5RlSwGTlQ5NvsU2eu0oJa1RY4zt/hmYt?=
 =?us-ascii?Q?1th2Mrhs2wYZqah57e71rmAlq6grINtxKg6r97Y2YhLmPSAZg+px/hyexALt?=
 =?us-ascii?Q?MQS68O22ou6K8c6bpD/VHKWYPS9Elytc2VJC9n1hiRdp03pwz/ZHuAuw6ASj?=
 =?us-ascii?Q?jC/+VzbgxdovNYse687nNAkHQLtnMWFznccNkRnwSFTUnWsnvKbXCsQqugH4?=
 =?us-ascii?Q?6j0S3ntE0m0mRskPN1tlzif8eJsyHxRviSLUbeBgndzVgNM1eSlSTp/P3fUr?=
 =?us-ascii?Q?BMd3U22zWASkD/uMpiUAfp1lcNx/blX6+0VNgmlwIO/8nTkFBNoeQNLRZ1lL?=
 =?us-ascii?Q?rY2vHKIFQt+1+F5ad8/XhaGoiUjklvKx1JW3bVOVNZXZCYjQZqrccCsJJlYC?=
 =?us-ascii?Q?CY/OJrtuvqLTV1aKw56PiTfRjTmmpBx7WUC2g9DgWhWe/eHJQNGXQxiCrKxQ?=
 =?us-ascii?Q?jTbpKP47KSzjZUOz+hZqpS4gVZKDgTbHt/SnfF7eHdEAf5WM0AIwBRT8GmT6?=
 =?us-ascii?Q?XN2YqnMn4SwWydnKX5pLVce3OwudsOsvUyekVY/GtBuXW1bdqKb4ur26R0/+?=
 =?us-ascii?Q?ZwsO+bkVp7aCd99KCIoIro6mUub7JqNpHwob9jbPq4tDyV6bij9TlV+uNrlh?=
 =?us-ascii?Q?wFPhD5+BAg2bAz2G4qPWT7K/tYr8b/W4yRtWEF+g8CYbnTuWKyL/6hsVB91A?=
 =?us-ascii?Q?Rl04Z7DLPpMOfxBnVMb08WtBaqjBG6wztkNqfbrnvnWTmieqXJPc9WgyFnRz?=
 =?us-ascii?Q?UhX3Kcl4QkzBRCLSYEDJi1S5aVjEzWpaHsLloPGIX6eG+bcHZKm1WiqsFFdZ?=
 =?us-ascii?Q?OCuT9ARov2yruZx2o4BPlJpvkuK76EyUNrXP4Uf5P+iNnGFRfesmbEYv1CCG?=
 =?us-ascii?Q?x2/vz11KU+3ZkpeGmpW6DMHLzyBFIRB/H+EgE+WJovsCpvl5ea6pZ3Z9wG5v?=
 =?us-ascii?Q?vRg3OyJX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b4cccf-0752-4ee1-c815-08d8c7714e7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:54:33.3780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c2CEJUNHWeI+T3YHfRbz+K8yhuyNNl5/WKzuBraj/QypYZ7HCyOip/FMvSXcvN8gr5emwJDx8L1Gu0jnRSD7zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Tue, Feb 02, 2021 at 11:24:04AM +0000, Avri Altman wrote:
> >
> > >
> > > On Tue, Feb 02, 2021 at 10:30:00AM +0200, Avri Altman wrote:
> > > > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > > > index afeb6365daf8..5ec4023db74d 100644
> > > > --- a/drivers/scsi/ufs/ufshpb.h
> > > > +++ b/drivers/scsi/ufs/ufshpb.h
> > > > @@ -48,6 +48,11 @@ enum UFSHPB_MODE {
> > > >       HPB_DEVICE_CONTROL,
> > > >  };
> > > >
> > > > +enum HPB_RGN_FLAGS {
> > > > +     RGN_FLAG_UPDATE =3D 0,
> > > > +     RGN_FLAG_DIRTY,
> > > > +};
> > > > +
> > > >  enum UFSHPB_STATE {
> > > >       HPB_PRESENT =3D 1,
> > > >       HPB_SUSPEND,
> > > > @@ -109,6 +114,7 @@ struct ufshpb_region {
> > > >
> > > >       /* below information is used by lru */
> > > >       struct list_head list_lru_rgn;
> > > > +     unsigned long rgn_flags;
> > >
> > > Why an unsigned long for a simple enumerated type?  And why not make
> > > this "type safe" by explicitly saying this is an enumerated type
> > > variable?
> > I am using it for atomic bit operations.
>=20
> That's not obvious given you have an enumerated type above.  Seems like
> an odd mix...
Done.
Will make it clear that those are bit indices.

