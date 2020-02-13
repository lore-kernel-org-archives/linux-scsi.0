Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FEEC2BA83
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 07:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D380218AC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 07:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ILy+97EH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xe4nRG6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgBMHUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 02:20:44 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9824 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgBMHUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 02:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581578443; x=1613114443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qyQy8AemagpSO0efy/WvIwHaciWsWVoG0MNGKey9Wys=;
  b=ILy+97EHqDN61SMgADALadKS3NIaW0dg0UI6RL9wgWI+Us6802wd99L7
   nw+PYZC1e9eGLb9kjIgXPTt8992uQbXNOP/lMiORcDRjmJGjE9dK69M2l
   0C3JmsuinL0Clvk42KpWi4u1PEb9hH2qMUglXSaBeIfWa7mBiHelZxuve
   k+XIcGKDrN8jnuJ9V+AhFgtoJ85NuszcZ2+l47s4EU+Bf3NmHTNNlwc+N
   dyHH8wyIntNfg2Ac1gm0OGYOpQyI8oN5De/Fvn5BEwR9cFmmRSJgLZioi
   Mc5aKfao7OS2qODX57mJ1B2VD+ubFpQycIClsHp8HvVQCf9fitYxlPBfF
   g==;
IronPort-SDR: Wc1K/jLKTUOUSJTQiSshDqvvdlzIxfddEEYIqxkaFx1xr65QvsrxGJA5IPMz42Fgqq57r3NqPm
 DqF2338R1t64hFr2emsIgqUXiF5Bs1H94LsR4IK0bGXda/ZFY5YhUtlaTgP3CwRjazUhDavevp
 smYk2gIQFJzyS8Lu5zOeEOefHno1Wcn4Rz8rA2iqPoxMoJFKjdUnqX/Z/jibQkUyQh/FhMilXP
 vsUkuaZm6QYcwu5nFD3SMY9E3ZsxNClqHda8Ffhhdn7lwDBydgxirdk9Ofl7KUKBigpOZ8EFs1
 ogc=
X-IronPort-AV: E=Sophos;i="5.70,435,1574092800"; 
   d="scan'208";a="237770993"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2020 15:20:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDH2vrBaw2jkNPRAhg3LEzxlJ7tGpxJWdBCLXfUdT6EFYugmktMkmJ8fH8TbGXUbSU9LMzVxt2Cglh0idix/K3kBEBQ8G3Bft5mijPtI1UYq29GvDFDZUBOtEj5r8U6ZhQ7vwx4ldBDvgyWEHvgMbz9zRj2Q+KN0KPYPFhOwczN4qroFe0CBQSE1nYvP8hS9khxBhNgJOizRCAclM97KR8OShglfRoa2WTkuIVn0IcC+Bbz/UJ6Gz//mjlXnoRZVLjl5FMl0eQErDmC7RDd8zjiPdO/S7/PxDZ8KuIi8kZ33BZVy34oini/r+0Nv7RdWdULWpW2o6Fx5LOqmcHFwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyQy8AemagpSO0efy/WvIwHaciWsWVoG0MNGKey9Wys=;
 b=h7GmIueY7WW6BElglRMXAOsJcuudlVIbA7YbVgrtjEyaj2teFhdRKMD+OIWXj/27a7r2IKq2o11eFzZ6p8Z54ScLQR6LWOrkt+zVVMb3VPR9kreFHi/LyZgFTocFGSGEEfDVJwCFH96CJaEKS7gBKoUb5/K3mIjcXY8OgQFxLm/PCTs5I8N4CH5JZ9n6d2qZaRyndR4OwK6k8noDo43NWV1h0wDGjBLgUlqoRdXcu3CPGyAggmrIkx/+l/INYNi2vIdUNOpJXwszRUrLdoU69B5f6u/40t5/rAJpjqsKgV3Xyg45hfa1NUUhTZ47tHqkl902NdLnu4M4aprye9S+2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyQy8AemagpSO0efy/WvIwHaciWsWVoG0MNGKey9Wys=;
 b=xe4nRG6TP2ewSzv0Jd3HEtCWG9YBmpfJOE5TUg3kiPCtPawgI5pPxxnDEPwJFvrzWO7rJy2MTYe8CeUBMEu2mUJb74jyVnLFwg5yP74Uq3AzbN7VXMsUIo2wKxj35k1n0R3yxPkfyE40l3tf0SZLbgzF4KK26477m0Nl3j37OGg=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6399.namprd04.prod.outlook.com (52.132.168.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 07:20:38 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 07:20:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Use ufshcd_config_pwr_mode() when scale
 gear
Thread-Topic: [PATCH v1 1/2] scsi: ufs: Use ufshcd_config_pwr_mode() when
 scale gear
Thread-Index: AQHV4Wa4/7BeUknJikSF1o9Bj2JpaKgXdp1QgAD4DICAAEp8MA==
Date:   Thu, 13 Feb 2020 07:20:38 +0000
Message-ID: <MN2PR04MB699113F7F141DD85B7D15D6CFC1A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
 <1581485910-8307-2-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991136AD340D28D930F27F3FC1B0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <5a54ea8f5c9f24a5c14b022d1d087a6d@codeaurora.org>
In-Reply-To: <5a54ea8f5c9f24a5c14b022d1d087a6d@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5ff2ab3a-0d12-4ea2-946a-08d7b05539f1
x-ms-traffictypediagnostic: MN2PR04MB6399:
x-microsoft-antispam-prvs: <MN2PR04MB639984D3B1B8D10CA624C0ADFC1A0@MN2PR04MB6399.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(478600001)(86362001)(53546011)(66476007)(66946007)(6506007)(64756008)(66446008)(66556008)(71200400001)(186003)(76116006)(2906002)(26005)(54906003)(81166006)(81156014)(8936002)(6916009)(33656002)(8676002)(52536014)(7696005)(4326008)(55016002)(9686003)(7416002)(316002)(5660300002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6399;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tY+F7ceOCG4640zJlJceso6HQKoOtini2yKruuZyyfYF+1Saik9BwVsaNk9NbWz/sxmJLmerFaDOgRC9WcqRUGJ3iTND1ELEtuYbUWHfbfixZ9BcsIIcPzlUE06eL52buEUOFOXH7TARuue+dBd9YbNKPOQhOby53AoXV4SEc3lgTBHSRhQHxNhYL12z6kdSITDjfKUCL1ytkl+0A5N3oXZk6U1FmgFYeMj2tZRiXFQVQATX9rbEgfEr6dmMHkMuWEaMlzgufDKoPFD7mdFgMLNAqShYmqZasnUxZMF0wL8YejDBxm29FgoggcANOF5924+oyeI4NLzkhrUN3lLH8uUdHV10mqxVpO/J3w0OXzcoSDbuU0akD9Q2Uw5diRHzxZ4fh7h8SIfD4XR6o5nGrasm/vwMgrSd0McqHw4Gsx6X0lTxpM6ZkGg0Y/1QhgZk
x-ms-exchange-antispam-messagedata: 8lD35NQRojugvEbMpYQ1kL88OS38wCwVN7P4L8dWBB76oVKCPhIkjeLVS8vVa0CpRAAMNRQgtN8UBL3FsGlMvi6Oo02bB+m4Wis8tO1R/hRNCXOvpcsdo9s/uY0Ye1u0b+CO4r21w9wKR1qnDrhzkg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff2ab3a-0d12-4ea2-946a-08d7b05539f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 07:20:38.6419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWqedBUEdUd6AANyL7yu50AY7TJZURLYsp9qlHV+czugZ00aZrxuvvisoZTpkqhXxJDgmbC0I9DGG0Fpkj9tHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6399
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2020-02-12 20:21, Avri Altman wrote:
> > Hi,
> >
> >>
> >> When scale gear, use ufshcd_config_pwr_mode() instead of
> >> ufshcd_change_power_mode() so that
> >> vops_pwr_change_notify(PRE_CHANGE)
> >> can be utilized to allow vendors use customized settings before change
> >> the power mode.
> >>
> >> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
