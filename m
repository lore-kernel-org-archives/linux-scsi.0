Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD854C43603
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 06:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7036822B48
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 06:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mlSxhO4G";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m1UODq//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfLOGGh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 01:06:37 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11500 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfLOGGh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 01:06:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576389997; x=1607925997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8rYYX4vygTB3N0/+YPAYRb6zZBDm490vSGCxfUAgCss=;
  b=mlSxhO4GPQtwRf3js2cFZUWmkEZ7HqvoBKeCUhQf9mihNTKndiS2Esuq
   kM+wSyZPnbfYBd7qdIqSqa9U8tWBadTMART0PGaBjRQ4bsNpBuuuBc40B
   EPUqA8WE+vRwtMc1qIyh1s24VbhpuPodOK1sarlWhBO3rbZ2wTqffjnB2
   kTnd6TFXBRzERxBFGmeSc3VO4ZQv+z6g34b5C036lT97E6RDUHg1Wi1r2
   y5QJRmtxpqZjhTvVcAqNqM1bdEmrdLY1p0kpemEx5dz1d/ahBfmBc8qtL
   F0Z5xlZ4PnYoIMsjPXDjBTFwTQYK4EmZ02fQ2N0FH3FIl14ozHLsIjg85
   w==;
IronPort-SDR: Og9C9MlwUSSgcfJUk/72s7ij2vPD2kkKSKH6ubz73wnmSZ5BD2BT5IBzGy6Zp9mJ4O9frRcRy8
 FVDVZwJ/ozMYTerNONedHIT9VhbJNeRXl/L1ze6nEojNkS2TnDFnOSEs4ggUQ9uZOl85LstN8a
 Owrjv4gO7loRuthRk6FYYpMXDloytMAuT5BG9B0KRboZlqJ8UP47xpKm5xR8yvyUbBVyizwJ/q
 pgGcM//zqn8tmlU4fFjQjBPX/hkM3Ila0stM7pXKipJskh1c2BxNY1w4+EOm3j0Bg2J8ohe11K
 slg=
X-IronPort-AV: E=Sophos;i="5.69,316,1571673600"; 
   d="scan'208";a="129807856"
Received: from mail-co1nam04lp2056.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.56])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2019 14:06:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHCxcTg5oNkjSbZU5a/JhFptL1rTz6XENGpjfOJn/WWBaSss3aI041e6daUiXiZmz09VMhGmt+wAvW5H+K/4f3K0KBM/pPcZq2MY2n5KhJ3zaWQiiaA/9CY+jqNFxJ54LQ5NDFO8MsfFlaMFERiWg+vmuJOsF7ZmIKj6SGIy2Nnf1DSS8Ok7wkLTG9rztaGTz12qTTzSZlWJ+3uBzSi2XEz2m6W0voloIWU2y41oZq16tTROuRmkGlq9xM11VsEhyr2rLIsMtaavQeho9hUtG30H4088C3xcLl0L+qDAeMcTlDDwJphlRh+5orq3NgHO0FCDDHXH1VCqePNBog/UDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70niOLmNCXaoQMsAxghgvfC8Wr7jOrZopcvLNCIzi08=;
 b=DgGyWBX/HbAja9NG0UvJqwa/jag7kNWH+CA+ms0C2iEO1u4IAxgneO70QObwGzCbRTN5ThDjhC3kUGjWLrG9fLUMiMadjLObrS9XADcUVuHMyz5BsuloYN/U/OFNb/UiIFlw9iDbBizsTWRYsum3HLyTAn8pjHLmuJ0hI4NfW4o8edQnh5plMWyDUkTgDYgjZSIrhySt31s9coj/LogsWC/Ie2aTgzFAa0mbQcVanhq/90GAjgOuSqizq7Xkhf4HA+eiuwfnDl7M/6CMwmzUp3VYH6bmsN8mG/c0uLd6cuzOOn4LOVP+qwpd0p+N+eQlOClFul4NUouUp7I36+0/iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70niOLmNCXaoQMsAxghgvfC8Wr7jOrZopcvLNCIzi08=;
 b=m1UODq//YyM4sTJKmXCh6E/6l6d1oiFcykbigxCQEo/tJFYOKja3s4KgLa7ZL8/X1U8MmorlBz6/Zswc3yFkS6pPFpib6KPVvoAOM/DuimiI66KurRUE5LYZLZJYRS2aPKj70aSaCiMUhGd5QEGI8/BSxKuIM3Dt0BoAnPXCv7c=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6464.namprd04.prod.outlook.com (52.132.170.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Sun, 15 Dec 2019 06:06:33 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.019; Sun, 15 Dec 2019
 06:06:33 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>
CC:     Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Simplify a condition
Thread-Topic: [PATCH 2/2] scsi: ufs: Simplify a condition
Thread-Index: AQHVsaNnMibuQ0RuH0C5boyF+d+K9Ke6uBIA
Date:   Sun, 15 Dec 2019 06:06:32 +0000
Message-ID: <MN2PR04MB6991BEAE05458E3C4B079720FC560@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191213104828.7i64cpoof26rc4fw@kili.mountain>
 <20191213104935.wgpq2epaz6zh5zus@kili.mountain>
In-Reply-To: <20191213104935.wgpq2epaz6zh5zus@kili.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 988a0c56-d532-43b5-c07e-08d78124ef55
x-ms-traffictypediagnostic: MN2PR04MB6464:
x-microsoft-antispam-prvs: <MN2PR04MB64649669D2870206040E13E3FC560@MN2PR04MB6464.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(189003)(199004)(9686003)(64756008)(66446008)(66946007)(66556008)(66476007)(76116006)(7416002)(55016002)(316002)(54906003)(110136005)(71200400001)(81166006)(8676002)(7696005)(6506007)(86362001)(4744005)(5660300002)(52536014)(81156014)(186003)(4326008)(478600001)(2906002)(8936002)(26005)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6464;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikEtQm2Il4wWPabxf8iZp7AksWy8/G/1SgrtLllXSPtSVXJs2FvuJ4B+ASGgSXUerJYy0Ym4aSBXrUyMqQjjZMyjAH6n0HeYBWrX4+QBz/OaV+awRdQBIyJCHH0DVrVmBd12rRDuxSHPxuaQRahF0Tc4MYcHojzbx4wheYyt7OFD2fNqWwuePj+7/L4NJhKNjTpJtdNwgKk0bld7G7UljtiDTJ6O5gSO0ohoufraKg47E9zSBfvGa66hJg5FjrbQfNl1bTEGOSoZaWbJ9gj6isIfJc2GPn+oGiFpAhfAleIER9FM4m95CtY6I0+khu18JX1gCKwmmeZJgAAZCycmujteN72OIWCO3+rBUJddBTl3r56BsJ1jR1KoFZiq5NpLS2ylJJYBH62tSgFuFzGj5Cg722XgX2kDB8WVDIvekZa7zqMI1jrGyMkzDfl7zbYH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 988a0c56-d532-43b5-c07e-08d78124ef55
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 06:06:32.9100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vGr+Osd9TDmxyLxLWsSqrgQuHdIvSfqWCk+OPBLyAqe8A4LxDbYVib6hi3EBFPBpdyyt2SLHnF4tdf5oBkKBwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6464
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> We know that "check_for_bkops" is non-zero on this side of the || because=
 it
> was checked on the other side.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> bf981f0ea74c..c299c5feaf1a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7684,8 +7684,7 @@ static int ufshcd_link_state_transition(struct ufs_=
hba
> *hba,
>          * turning off the link would also turn off the device.
>          */
>         else if ((req_link_state =3D=3D UIC_LINK_OFF_STATE) &&
> -                  (!check_for_bkops || (check_for_bkops &&
> -                   !hba->auto_bkops_enabled))) {
> +                (!check_for_bkops || !hba->auto_bkops_enabled)) {
>                 /*
>                  * Let's make sure that link is in low power mode, we are=
 doing
>                  * this currently by putting the link in Hibern8. Otherwa=
y to
> --
> 2.11.0

