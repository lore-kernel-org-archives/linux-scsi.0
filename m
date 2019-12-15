Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8ECC2D0CB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 07:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5479320700
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 07:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Lbsyc7Iu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E9OlW6lp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfLOHil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 02:38:41 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50204 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfLOHil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 02:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576395520; x=1607931520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WD2ZxqTXqKQeq3uAJSRxOpuZSx5zdtnBAKzWn9EO/AU=;
  b=Lbsyc7IuFO4+gEVeM9gbGeWIAFGeisldv+1XRWvC+jD/25MeS1shUVff
   H4C4mlpUsRoqFadUxj8okqeqQp45iwn5XPKvx/l+C/JR+KpbWYDSWgQ5B
   Uy3fH/6jhtDyV/q6iXegbVDtb3y5mPplxaSgSmzamgxms04UswKWzA0cJ
   eyLfKEz7+Cxww+ypbj6gfq1Z4V5oAAFcyxVTp+rwh3uOguMtFrBCDEtno
   ZHZbiwOVAIt+lcfo3qkoWoa4gCKZgpoXVKwkjdLxNG3xtpliPvuUxWNBW
   9tKoalRCmceBPv7MjR7bE/LJ1iY43f37UaeAoIT+6iVEPdBTqq+gTqei3
   Q==;
IronPort-SDR: CYbv4IeHR3zOXVsEd5oFh94N+HTvGoAWV/yUrOcVKwQa52f/jxG48VhgtRbcQl2ADEkgenV4km
 3denafP4e4khS7DZJqnRVgW/sYrHfAxNBX5DMwKxtETjlrcW7mGBGx9rAvKjYOZNbMguju5lzi
 F27pm0GDQjmCN8fFI9upPmmNIL60OEHKEMCcsaBQhed8knGWR09LcAmfasFZXv9PbgAo2A1/eL
 ZLBii/0myZL9UBfGedF651cSz5CuJHDKVvGJ0BZiIAOFAtotIOTZedWti+TdhYW1vvSXpnH9wx
 Pxs=
X-IronPort-AV: E=Sophos;i="5.69,316,1571673600"; 
   d="scan'208";a="232952008"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2019 15:38:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC/vgi8Uxa0kzyHpwi1s4hP6RZlmFmymj4C40t5qdEezrGNo6IfTvaHe5+ZR/HJ535W6uK3hnJzpuwTEMUgSQg45gaWnC0PmAA61+IZBmAEAqEWpMnFMWLomIl9fIBLFywKoiKD3evJ3wYh5dd0Lu9xpYHiHS9dZnAMnhcO4CDx8KUDxKIG7nz9FeCRqNG7FCh2vC4TocK6NBsyqUEAwOnS90YfFu3smOCWdXeednKmfiq5DlEOC+BlE93BnVWVxPWmnAzxzMnfdnuGDtMxAdCoI1K9IvOaUK7Ez2ulhNqLIXzlc3a3gYcC0qUBrb6UTNWQZvRyGiLzp/a9ZJWvq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WD2ZxqTXqKQeq3uAJSRxOpuZSx5zdtnBAKzWn9EO/AU=;
 b=MCWe5NqcvqzX4NjfNiC910p92uRigLm1WDNhb751tiVbhWx66oL6I218c00+0ou9/AJb0BX3/H9QbzFV6Ezuwe/VB/oRQZXHjHJJIIyc6Qj8iH8vCAjEIgIRtl5VpJkG1j7D8myAfmqB6AJoc5jm0I2sF4EOEn1+VBZfWI0eD9Y78UjsJw3PMW1Tjmk7tHoLsG30Cip7vy6hzEapB6oZdYgEPSg+cC657EKuEtY8+DdVU5ILvmAsCUCHJiq0hu4fWWJzKjNQHC4z25fcJrD4F2EXnWsrhKYskwfiyC/brIqOqIL2q1NyoCtReE9Z82s8hq0D7e6qY74uZM6a3g/bvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WD2ZxqTXqKQeq3uAJSRxOpuZSx5zdtnBAKzWn9EO/AU=;
 b=E9OlW6lppdcgnrb1XrIf6JEFts1K1d2+/vLuiKWz2QKivaMEMuP3xjYxSI4MnTHcyiWhQy2sEENlbJl+s+QydeMNC7nXYlMpJN3A4H6XwxKZ3HMgo5qkkAdw5aGFYlgfv0RdF08g1qEXteasyanQ1cBVn7h5Tpu/BMkQBSqkxcw=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5677.namprd04.prod.outlook.com (20.179.21.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Sun, 15 Dec 2019 07:38:21 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.019; Sun, 15 Dec 2019
 07:38:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
Thread-Topic: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
Thread-Index: AQHVr//eTRAsaCi7o0KCA+PFpTUx1Ke18FKAgAAc25KAAAI5UIAAw1gEgALB3gCAAT/UoA==
Date:   Sun, 15 Dec 2019 07:38:21 +0000
Message-ID: <MN2PR04MB6991D105DAA299ABF0A904F0FC560@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <MN2PR04MB69919AA0C345E7D6620C3ADFFC550@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016efb07efac-32cf270a-68dd-455a-b037-9fac2f3834cd-000000@us-west-2.amazonses.com>
 <20191212182411.GE415177@yoga>
 <0baa9d993cf9cb3e6c94f4c4440e9f95@codeaurora.org>
In-Reply-To: <0baa9d993cf9cb3e6c94f4c4440e9f95@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0864a03-7a5e-4d70-3ab5-08d78131c2d7
x-ms-traffictypediagnostic: MN2PR04MB5677:
x-microsoft-antispam-prvs: <MN2PR04MB56777D15B9B63D7AA0706D0DFC560@MN2PR04MB5677.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(199004)(189003)(186003)(6506007)(53546011)(316002)(55016002)(9686003)(52536014)(66556008)(64756008)(66476007)(66446008)(4001150100001)(7696005)(86362001)(26005)(33656002)(5660300002)(2906002)(81166006)(8676002)(8936002)(81156014)(66946007)(76116006)(71200400001)(478600001)(7416002)(54906003)(110136005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5677;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CNiY+S7eygHLmzjHHCtQouG145okQpMGWDpbtwq9iKmwxnEJjUXICgXi5BAdmLb7ZoYf6AwqOdJY/VHC7MN0dXIdDQZ2f2NbsxQ6D+YoYdzLqnBIfggyCzi0JsoF6s8p607BPUdflGxK0vD4SXvk0qylLcjMnrSlWiiwQoJRjU/f7ns9An6DRqP6NXWVvKYpSasovWvd9BuBy6IgyrG4y29plBFuAGbJsFSXdRGmXaJsRSqsBg6PB6zX7iyMvQE8M0LweCl1AuIZJJILZPpEAeLvkIZRBigXLSPoG+c9V7CgfKz7gSkFyxBL2WcbBoECNgjMIUpDRBd8PjdoEWNRcx4c5wVkiXKIahZFli7zc5N+ooCUDGjiw1TuU9nCzLxnGP2GY51/AbUiZ7O1JkK93vrjlQB53N/KH6mVaeb/efwJcvoSNBzl8JZ38dt+52px
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0864a03-7a5e-4d70-3ab5-08d78131c2d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 07:38:21.6887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: My0FNCVfdwH4RFX+3+/NAsyuaX2Ml2Z0J58FJj38t5Mc5OhntQwEsrvRcoESlo0nc/g8bTZTLQbRnXWhjY1rsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5677
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



=20
>=20
> On 2019-12-13 02:24, Bjorn Andersson wrote:
> > On Thu 12 Dec 08:53 PST 2019, cang@codeaurora.org wrote:
> >
> >> On 2019-12-12 15:00, Avri Altman wrote:
> >> > > On Wed 11 Dec 22:01 PST 2019, cang@codeaurora.org wrote:
> >> > > > On 2019-12-12 12:53, Bjorn Andersson wrote:
> >> > > > > On Wed 11 Dec 00:49 PST 2019, Can Guo wrote:
> > [..]
> >> > > > And in real cases, as the UFS is the boot device, UFS driver
> >> > > > will always be probed during bootup.
> >> > > >
> >> > >
> >> > > The UFS driver will load and probe because it's mentioned in the
> >> > > devicetree, but if either the ufs drivers or any of its
> >> > > dependencies (phy, resets, clocks, etc) are built as modules it
> >> > > might very well finish probing after lateinitcall.
> >> > >
> >> > > So in the even that the bsg is =3Dy and any of these drivers are
> >> > > =3Dm, or if you're having bad luck with your timing, the list will
> >> > > be empty.
> >> > >
> >> > > As described below, if bsg=3Dm, then there's nothing that will loa=
d
> >> > > the module and the bsg will not probe...
> >> > Right.
> >> > bsg=3Dy and ufshcd=3Dm is a bad idea, and should be avoided.
> >> >
> >>
> >> Yeah, I will get it addressed in the next patchset.
> >>
> >
> > If you build this around platform_device_register_data() from ufshcd I
> > don't see a reason to add additional restrictions on this combination
> > (even though it might not make much sense for people to use this
> > combination).
> >
> > Regards,
> > Bjorn
>=20
> Agree, thanks.
While at it, maybe you can add few words in the "BSG Support" paragraph,
In Documentation/scsi/ufs.txt.

Thanks,
Avri

