Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAE1C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 07:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984A82077B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 07:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gl52XjIg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fPxKHcL6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfLLHA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 02:00:58 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17118 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfLLHA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 02:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576134094; x=1607670094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uDUEZfZbjUGc7SHUqhfaGJSVRy2YP98lYH66ThEuBis=;
  b=gl52XjIgkd7vIzg7K3GPvw6hqn816xl3glH2J4iFfjmGrQXgqV9Mbybj
   uKjzQhB69ZjOgDGy9ZZeLDMw2bzYNIWx5D6oqvGb25+A2uk3FvbOaySao
   UBD3XRCcZKFqy+DgfQFhTFZONAJp/Sbh9FJnxgxANdNG+P8qTmk3bzrhq
   5bgJXRZtJpFPhdZNw5Q8gWN474DefOwMspi5og4194PLujXsOaoOJWc6p
   Ovr30Ezmmnue/n896N6CQCHy4I6keA89Hb7UOR6wJjiaz3O2ST/Aa2PSN
   A/PkD7TdeCIr9EbxCrLeX+L1nVoqMdThjoxbwH/gMjpVhvka9UStrE/7o
   g==;
IronPort-SDR: l4EqO1RyPSj6XyheOjjY6x2Y2rz1/j4GoodUQEjpdVarfei35xiT8VaDQS+xLh80gu9tCvy9qr
 TLl2GXEdRfO5lc320/tHe3+CHvEwNWtj4PCEOUzlaeXERzv5Ozfo7GJt+THwQo0qO4x7ppjxyu
 aU2/u6yibMaJ4OPYULFS/ZLDtby8GYIacJKb9HXnlppjEAJEoI2DzNFR/mbDhOpldv0/0qELFD
 MkX0OQ7vWlVNLkxzqzA0pQJ1+lJZO+LUq85WjJMwpeGhImF2/6TvjamcwO8ECYnwThtMtKmvJs
 ij4=
X-URL-LookUp-ScanningError: 1
X-IronPort-AV: E=Sophos;i="5.69,304,1571673600"; 
   d="scan'208";a="226681209"
Received: from mail-sn1nam04lp2051.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.51])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2019 15:01:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmlymjN3lzPrwFzc5nUQILd2llk/pEK7v59SbS4CHlXvZs1eXo932Xvc09KIjnPQrgD7Jrz9pTD4wJxwGgG8ioUYC1ITrurEhCtP1X71LBalsbSYK+daRdpYHahqxdaNkHvyGs7O4KRhsYmW5joN0jpr5I/bRWdHkpinBGHDP8/4CIZGhlI23NM0zqxVJq+1k+C5pjdfdb4O+D9wZRND+A/+Fc6Pbn7T7ExWLk4qXDxlmgE1nglJRBCnGUhsiQYfv1LdUR3ZqdoLrqnVdquaE5r0b7/LHWXdgy9chx8n0KUtyW4IzWRGELWci9a8+a/u8rcNLtbjn8u98k53fCFzCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQmSPWlD37apctsXqbVPGnY36OcBCc35FHt9zXklFVg=;
 b=hoG/U1RK4ZBS8JQqaq5jiOXr0Gfm5UEJ98Ty0JL0QCfmHNiPXzHCalY5OLnTcBYviTCCGpE4Ae1ZSK1tuxqeRVpcWo8qJ9iTTAb+7NTaTcgGMUPuk1gGHWsz/n50Bmod3HfKWQyQCj7Zfm56JUWAqVKCpnWjWAeoETCA3SaEM/F8RJxRkUR6uJ9u9/SV2XFkmnB+YFuuwst/ba6ynccFXdy9WHP8H1WohAzGm4c57uiswUE8cUVd+eFNWTqEUHRjfTMJwFc4khIUeesJU1cGf4Wuq+wbhEMPlS0WdI6qCjKA3Ijw9/6HrN3fvm9yQ7Iz8ViJ5XcMU2k9WAM7mF48dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQmSPWlD37apctsXqbVPGnY36OcBCc35FHt9zXklFVg=;
 b=fPxKHcL634QAjEM2j8UNnzy0SjPfIOB3H8J2Lv/G6KrJrqtP9PlXCo9beU4xQZAjZx1PzCu7g1lzq+YaS/HIuLC/Q69Kr2qQc41v/ctOE/9DNsVDT35QdlO3CZ3M87kbvVXiLfJonjQXC+8ileN297gmdXb0Mnfyovqb1yymQlI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB7022.namprd04.prod.outlook.com (10.186.147.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Thu, 12 Dec 2019 07:00:50 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.012; Thu, 12 Dec 2019
 07:00:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>
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
Thread-Index: AQHVr//eTRAsaCi7o0KCA+PFpTUx1Ke18FKAgAAc25KAAAI5UA==
Date:   Thu, 12 Dec 2019 07:00:50 +0000
Message-ID: <MN2PR04MB69919AA0C345E7D6620C3ADFFC550@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
In-Reply-To: <20191212063703.GC415177@yoga>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec18eeb5-cda9-497d-af88-08d77ed105a2
x-ms-traffictypediagnostic: MN2PR04MB7022:
x-microsoft-antispam-prvs: <MN2PR04MB70224173EA1B0FC4253ED866FC550@MN2PR04MB7022.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(199004)(189003)(8936002)(316002)(76116006)(53546011)(86362001)(478600001)(6506007)(52536014)(7416002)(81156014)(9686003)(5660300002)(66476007)(66946007)(66446008)(26005)(81166006)(4326008)(66556008)(186003)(7696005)(54906003)(2906002)(33656002)(71200400001)(55016002)(8676002)(110136005)(4001150100001)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7022;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gYrew5x9WM36Hm1B6hGocXqcyYcsR6IZsN3GllyyV7F7qt7bwWAVlH2FRMfucdMlav0lyYftzdfPlOY91q5ZzGUOTe7Fj6YKic7hdp3+xe8IMI1HeJS4/cj2hQ9b2yCqaKKY8y6psyTjfMpT71WsHUBZ/hHR5dKfFsg+wnc2d4xOBfpxo9mzvYCroeysottZ+MXcmFSlbeSyQKBc8GtU/+Ky5hv8+f1fUaBF3vXTwT8ilo/h1Em7xEoDT/JJU804GtdnLnPCrs4dQr6bMrEUztdhSLabuZQ9uKmi3t02LcdDm1oOxA0Tr1+gW7snTbGjE26RJph9sMRLuu+FEOcTct1AR1uvCqRUZ3bL5LJvjIQEgPQHEgrIBu0yXINB9h0hgvxf1orC9v2fANvXAt23JGHkqPE1QsVOAI8nOlOC/F3t+RkVe2YaIJzFz+c2RtMIL6sTJSY8YGw6KSElRXSzWCi1povFNKA2DPBUKdJQZJ4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec18eeb5-cda9-497d-af88-08d77ed105a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 07:00:50.0910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uEsKkXgL46Vhu7scVdwBiBqcxIpRXu6HhVL13MpwTeZsfGkYnnrVxxmsx+4pAZA37JwS2FDDIecNa00YdYAhHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>=20
>=20
> On Wed 11 Dec 22:01 PST 2019, cang@codeaurora.org wrote:
>=20
> > On 2019-12-12 12:53, Bjorn Andersson wrote:
> > > On Wed 11 Dec 00:49 PST 2019, Can Guo wrote:
> > >
> > > > In order to improve the flexibility of ufs-bsg, modulizing it is a
> > > > good choice. This change introduces tristate to ufs-bsg to allow
> > > > users compile it as an external module.
> > >
> > > Can you please elaborate on what this "flexibility" is and why it's
> > > a good thing?
> > >
> >
> > ufs-bsg is a helpful gadget for debug/test purpose. But neither
> > disabling it nor enabling it is the best way on a commercialized
> > device. Disabling it means we cannot use it, while enabling it by
> > default will expose all the DEVM/UIC/TM interfaces to user space,
> > which is not "safe" on a commercialized device to let users play with i=
t.
> > Making it a module can resolve this, because only vendors can install
> > it as they have the root permissions.
Agree.
We see that the public ufs-utils (https://github.com/westerndigitalcorporat=
ion/ufs-utils) that uses this infrastructure,
is gaining momentum, and currently being used not only by chipset and flash=
 vendors,
but by end customers as well.
This change will e.g. enable, field application engineers to debug issues i=
n a safer mode.

> >
> > > >
> > > > Signed-off-by: Can Guo <cang@codeaurora.org>
> > > > ---
> > > >  drivers/scsi/ufs/Kconfig   |  3 ++-
> > > >  drivers/scsi/ufs/Makefile  |  2 +-  drivers/scsi/ufs/ufs_bsg.c |
> > > > 49
> > > > +++++++++++++++++++++++++++++++++++++++++++---
> > > >  drivers/scsi/ufs/ufs_bsg.h |  8 --------
> > > > drivers/scsi/ufs/ufshcd.c  | 36 ++++++++++++++++++++++++++++++----
> > > >  drivers/scsi/ufs/ufshcd.h  |  7 ++++++-
> > > >  6 files changed, 87 insertions(+), 18 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> > > > index d14c224..72620ce 100644
> > > > --- a/drivers/scsi/ufs/Kconfig
> > > > +++ b/drivers/scsi/ufs/Kconfig
> > > > @@ -38,6 +38,7 @@ config SCSI_UFSHCD
> > > >   select PM_DEVFREQ
> > > >   select DEVFREQ_GOV_SIMPLE_ONDEMAND
> > > >   select NLS
> > > > + select BLK_DEV_BSGLIB
> > >
> > > Why is this needed?
> > >
> >
> > Because ufshcd.c needs to call some funcs defined in bsg lib.
> >
> > > >   ---help---
> > > >   This selects the support for UFS devices in Linux, say Y and make
> > > >     sure that you know the name of your UFS host adapter (the card
> > > > @@ -143,7 +144,7 @@ config SCSI_UFS_TI_J721E
> > > >     If unsure, say N.
> > > >
> > > >  config SCSI_UFS_BSG
> > > > - bool "Universal Flash Storage BSG device node"
> > > > + tristate "Universal Flash Storage BSG device node"
> > > >   depends on SCSI_UFSHCD
> > > >   select BLK_DEV_BSGLIB
> > > >   help
> > > > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > > > index 94c6c5d..904eff1 100644
> > > > --- a/drivers/scsi/ufs/Makefile
> > > > +++ b/drivers/scsi/ufs/Makefile
> > > > @@ -6,7 +6,7 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D
> > > > cdns-pltfrm.o
> > > >  obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> > > >  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
> > > >  ufshcd-core-y                            +=3D ufshcd.o ufs-sysfs.o
> > > > -ufshcd-core-$(CONFIG_SCSI_UFS_BSG)       +=3D ufs_bsg.o
> > > > +obj-$(CONFIG_SCSI_UFS_BSG)       +=3D ufs_bsg.o
> > > >  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
> > > >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o
> > > >  obj-$(CONFIG_SCSI_UFS_HISI) +=3D ufs-hisi.o diff --git
> > > > a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c index
> > > > 3a2e68f..302222f 100644
> > > > --- a/drivers/scsi/ufs/ufs_bsg.c
> > > > +++ b/drivers/scsi/ufs/ufs_bsg.c
> > > > @@ -164,13 +164,15 @@ static int ufs_bsg_request(struct bsg_job *jo=
b)
> > > >   */
> > > >  void ufs_bsg_remove(struct ufs_hba *hba)  {
> > > > - struct device *bsg_dev =3D &hba->bsg_dev;
> > > > + struct device *bsg_dev =3D hba->bsg_dev;
> > > >
> > > >   if (!hba->bsg_queue)
> > > >           return;
> > > >
> > > >   bsg_remove_queue(hba->bsg_queue);
> > > >
> > > > + hba->bsg_dev =3D NULL;
> > > > + hba->bsg_queue =3D NULL;
> > > >   device_del(bsg_dev);
> > > >   put_device(bsg_dev);
> > > >  }
> > > > @@ -178,6 +180,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
> > > >  static inline void ufs_bsg_node_release(struct device *dev)
> > > >  {
> > > >   put_device(dev->parent);
> > > > + kfree(dev);
> > > >  }
> > > >
> > > >  /**
> > > > @@ -186,14 +189,19 @@ static inline void ufs_bsg_node_release(struc=
t
> > > > device *dev)
> > > >   *
> > > >   * Called during initial loading of the driver, and before
> > > > scsi_scan_host.
> > > >   */
> > > > -int ufs_bsg_probe(struct ufs_hba *hba)
> > > > +static int ufs_bsg_probe(struct ufs_hba *hba)
> > > >  {
> > > > - struct device *bsg_dev =3D &hba->bsg_dev;
> > > > + struct device *bsg_dev;
> > > >   struct Scsi_Host *shost =3D hba->host;
> > > >   struct device *parent =3D &shost->shost_gendev;
> > > >   struct request_queue *q;
> > > >   int ret;
> > > >
> > > > + bsg_dev =3D kzalloc(sizeof(*bsg_dev), GFP_KERNEL);
> > > > + if (!bsg_dev)
> > > > +         return -ENOMEM;
> > > > +
> > > > + hba->bsg_dev =3D bsg_dev;
> > > >   device_initialize(bsg_dev);
> > > >
> > > >   bsg_dev->parent =3D get_device(parent);
> > > > @@ -217,6 +225,41 @@ int ufs_bsg_probe(struct ufs_hba *hba)
> > > >
> > > >  out:
> > > >   dev_err(bsg_dev, "fail to initialize a bsg dev %d\n",
> > > > shost->host_no);
> > > > + hba->bsg_dev =3D NULL;
> > > >   put_device(bsg_dev);
> > > >   return ret;
> > > >  }
> > > > +
> > > > +static int __init ufs_bsg_init(void)
> > > > +{
> > > > + struct list_head *hba_list =3D NULL;
> > > > + struct ufs_hba *hba;
> > > > + int ret =3D 0;
> > > > +
> > > > + ufshcd_get_hba_list_lock(&hba_list);
> > > > + list_for_each_entry(hba, hba_list, list) {
> > > > +         ret =3D ufs_bsg_probe(hba);
> > > > +         if (ret)
> > > > +                 break;
> > > > + }
> > >
> > > So what happens if I go CONFIG_SCSI_UFS_BSG=3Dy and
> > > CONFIG_SCSI_UFS_QCOM=3Dy?
> > >
> > > Wouldn't that mean that ufs_bsg_init() is called before ufshcd_init()
> > > has added the controller to the list? And even in the even that they =
are
> > > both =3Dm, what happens if they are invoked in the "wrong" order?
> > >
> >
> > In the case that CONFIG_SCSI_UFS_BSG=3Dy and CONFIG_SCSI_UFS_QCOM=3Dy,
> > I give late_initcall_sync(ufs_bsg_init) to make sure ufs_bsg_init
> > is invoked only after platform driver is probed. I tested this combinat=
ion.
> >
> > In the case that both of them are "m", installing ufs-bsg before ufs-qc=
om
> > is installed would have no effect as ufs_hba_list is empty, which is
> > expected.
>=20
> Why is it the expected behavior that bsg may or may not probe depending
> on the driver load order and potentially timing of the initialization.
>=20
> > And in real cases, as the UFS is the boot device, UFS driver will alway=
s
> > be probed during bootup.
> >
>=20
> The UFS driver will load and probe because it's mentioned in the
> devicetree, but if either the ufs drivers or any of its dependencies
> (phy, resets, clocks, etc) are built as modules it might very well
> finish probing after lateinitcall.
>=20
> So in the even that the bsg is =3Dy and any of these drivers are =3Dm, or=
 if
> you're having bad luck with your timing, the list will be empty.
>=20
> As described below, if bsg=3Dm, then there's nothing that will load the
> module and the bsg will not probe...
Right.
bsg=3Dy and ufshcd=3Dm is a bad idea, and should be avoided.

>=20
> [..]
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> [..]
> > > >  void ufshcd_remove(struct ufs_hba *hba)
> > > >  {
> > > > - ufs_bsg_remove(hba);
> > > > + struct device *bsg_dev =3D hba->bsg_dev;
> > > > +
> > > > + mutex_lock(&ufs_hba_list_lock);
> > > > + list_del(&hba->list);
> > > > + if (hba->bsg_queue) {
> > > > +         bsg_remove_queue(hba->bsg_queue);
> > > > +         device_del(bsg_dev);
> > >
> > > Am I reading this correct in that you probe the bsg_dev form initcall
> > > and you delete it as the ufshcd instance is removed? That's not okay.
> > >
> > > Regards,
> > > Bjorn
> > >
> >
> > If ufshcd is removed, its ufs-bsg, if exists, should also be removed.
> > Could you please enlighten me a better way to do this? Thanks.
> >
>=20
> It's the asymmetry that I don't like.
>=20
> Perhaps if you instead make ufshcd platform_device_register_data() the
> bsg device you would solve the probe ordering, the remove will be
> symmetric and module autoloading will work as well (although then you
> need a MODULE_ALIAS of platform:device-name).
>=20
> Regards,
> Bjorn
