Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560FEC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FF9E61B23
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJCH2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 03:28:10 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:51860 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbhJCH2J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 03:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633245982; x=1664781982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8AwHSLLL+Sq9uNtVjDkpkAmawmqc8eJyxbSm0KlI9jM=;
  b=daLgfuh/EQ9S9OhhXxWykOYu2q+dX7Zw9+NbEm/4gkFR89hZW+HqYCdv
   N9TZHvfoynqhaSHi98D7aJedHLlHSHfqxsAlRk2ombTq2Sp/hBEbtvs8m
   8y/3AiR6EJDFuk9L3i1bNTsuOHYU6onbJkNWKTzGbFO3a75jwf9Q49jGJ
   SCWUFNpwH2cnPxxociSsSqljLBI8aOyuFJ/IrG9hSDFKesNHXR6d0/0t3
   3JGeGF8SSaEnaJDh0nbl4BPAABa4mXhPu61F4f1vo8Df0sIvLeAVleCF6
   kfyRqHEAjjc8VMi8Smd7i1cBpjgOcLDHXEraOAi3iYQ229NHURUsew+YO
   g==;
X-IronPort-AV: E=Sophos;i="5.85,343,1624291200"; 
   d="scan'208";a="180743384"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2021 15:26:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4Dgj5tb8sRRJKh8s4Td/id5bx4uxd9yz+vbpX/DfeL49qM84RnjJt+6G8G66BCepSFkv/ueaKZLZ6JG7Oxqs/Cl4QJW6TO3XSeWdN23tsAswenZjDqoruMrxTE/Az/k9aG2trgAAN7IK1n7DJssI7qN0VgwKYHUmXDNkWAdt2r1k82RrWtacxUKmYF5TJlKRBVBCN+tCAJojhRALG0+RmntloIL9RQd8HEVyCZXQjrdW8oY5i7D0qYXjAq1fUbHpAo51vfLGPw1xkvC2bXF1V2ORvi/A+kUsaV2YDJmzLyikauBZvozQHbQ08QcGD8N3Ldm3puZPGFKp8xetkqpPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mN224e6LkIchtGeSg7HcYr6ry+Jn24br/NEBZ2jefYs=;
 b=PRchul8F3OiRoSOTflrbN8KB1bJb+55U30ZSxo9r5QI8GdODksYTwdgWsiE3YXOKI/KHQfmruhQWdaxxq6YcCT8VCesYYMaCdzuIu4Z/rDH3FQJrqTjUsKp8JKa8UIdmew0cNHUZ5jX3r+4vk8bV8JTiluFV/ssqZRQ0U8kAmE7bf/ttGzyxesQKbjnU35omdR2LhabUniwrXv+l8FBn1DwWPBdbl6Ow0Zt+DnVVDuugrbwQoKuw/yLklUBNAVDkWWw1bP3cnMl0V1DLwBlIylWtu7mlfXmY6cQNcaESBCxR8VnHkboPRYWz8P8FU/rpsRMCZNoiPvSetyX8mDrpjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mN224e6LkIchtGeSg7HcYr6ry+Jn24br/NEBZ2jefYs=;
 b=TIBPouvgPZBelj3BXqNrggoyjkDuZgMd0o2dBaqbwzM8TYo42GhhXr+PpR7NUrtC6o0bgjMSyRc00fsM2ZvZiVLPo97kH4Tq2cOfraq745tJJkUIICzxKm+Qy0uYLGzLjGIPi6bw0/zctB3GNfgLky069VVKdbMuVM9L0neVzNc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1130.namprd04.prod.outlook.com (2603:10b6:3:a5::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.17; Sun, 3 Oct 2021 07:26:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 07:26:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Do not exit ufshcd_reset_and_restore()
 unless operational or dead
Thread-Topic: [PATCH 1/2] scsi: ufs: Do not exit ufshcd_reset_and_restore()
 unless operational or dead
Thread-Index: AQHXt6SfjOui5Ai3+kyXMG+7bjOqPqvA4Hgg
Date:   Sun, 3 Oct 2021 07:26:20 +0000
Message-ID: <DM6PR04MB657575CEE9A23ED407884D3FFCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
 <20211002154550.128511-2-adrian.hunter@intel.com>
In-Reply-To: <20211002154550.128511-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7faaadf7-25d0-42f5-4f63-08d9863f187f
x-ms-traffictypediagnostic: DM5PR04MB1130:
x-microsoft-antispam-prvs: <DM5PR04MB113048833F36D9F18192ADD5FCAD9@DM5PR04MB1130.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jPOLooS1FePbGAMtK10HMzPDb3loCUi+YAJyyMDqSI6bcY1CuxPfHAQlrEtKlEmOO1gKorRtQoy/zzhXMF7UfJFcG/LNfuPXt8gGdBGWYcAc/JnvLW3EXgnzU5FO3lJUf6g3KrbE1mAaKhTDUJUWiMSmMlHVh62G0uxqIsfnvAOeqfPWPOGOX3jPSaAPcoYQbCHmLiikZCBh//EiQrDUNPJnTfdL9VOUFlfv/kbO7E/+bA42SJvibRJ33raKLORURVuJan0UJggN14OcgiDoUfjE+gAnF+KC2YO6QQQs/GakZna1+gLj42xylMehXwLviKXgTOjcL++kOCr/7O2opAzu7mG2597s9H+jORVeDc5uhRL/o5dOsV4BYaDWyxsRPBVDdj7/o46rS1ws4wPBCAepndiN3i6fKerm1oFR/907NRVw02yAiQK7FQAxJKUIonMwyYRNuCUhmxYsAc+5MdanU1nnkYckWFlsA8y1QzSgmkVXeUldPIR85KmqzFY9V74MO1VdrIVLYBbEIGqwAq4pHxPOlulz6EsX4wNYl6x4y/KMcjU4Q+0XuHZRNrB0PYcS0iIv8cS1vMZ8h6DYE2IU9SSAIWlMXTMYLwRc3Eq5eubJrpf/Oovbjj+1YDh/SddlbmKXW/QASfq2r3C6qPWn/OOXAIlgD9837C4ofjZID0SO7s10z2h9AWDRbN8eRRzhe0DjLp8dTyZsb+/Spw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(38100700002)(6506007)(66476007)(66556008)(66446008)(83380400001)(5660300002)(33656002)(26005)(122000001)(508600001)(66946007)(2906002)(9686003)(64756008)(76116006)(316002)(4326008)(54906003)(86362001)(110136005)(52536014)(7696005)(38070700005)(55016002)(8676002)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0U9nQIdzor+SuHKTaldJtS1i0Xet6PijWDKj1uLm9FCppS4kdDLMXCrTXNN6?=
 =?us-ascii?Q?ty4k0+9U3sK6SgzAoePD2q/mDj8h9j1sDRfjYj1RMu6LrkK21E2Qi3wlnL5A?=
 =?us-ascii?Q?wLzUhe8M+RF8vSXWzD4ivx8O9QSZANon3iw4FqXp7LSaiEOJ9jHJtZfLOl2k?=
 =?us-ascii?Q?Ri0SWYfuNUGIHbPK9mBKPUC12fG9uQtTl8P5TK/VwZNl/LRvRlg9H98i5cZJ?=
 =?us-ascii?Q?ion+b+wLoa+JcirvOXf0XXcLVv5djfBQwremq8IWXod7JK6YBd3TpoEs45UK?=
 =?us-ascii?Q?jpsVyO5ZCUfnCB6Ozrm9fEPQGAMW+lPfOEWPBvDYJ3+X+blgoCCCktlHlDYR?=
 =?us-ascii?Q?mcLaZ70vHaTN/OhRB/nxtrywuuZi8WPCmrGQBAkIJEo5iVKLbp7wADKuCEWB?=
 =?us-ascii?Q?YSZfAn2GBjZ8HenvA/FHZesw/MMn7R5ismfVlF5/ZnxakQEGzWkKWFB3iflT?=
 =?us-ascii?Q?baq4ydVHNHm8/ZpmPC28rC4GHh5VcbxilWUdOcvkEdkH3HCXpVYhYnkjFZch?=
 =?us-ascii?Q?9Iqh5wUzSE1DCuxZiQLav+dScUV08DWCFVCq0cZlijHuNgVKZC0hVl2wmLrj?=
 =?us-ascii?Q?SbbFpzpnqYhSyydlgy7GTEkujAGd76zO8xVtSi6TswycOmgy5qFO1nGou7cB?=
 =?us-ascii?Q?x9nfqYWpvQK3NztJak+ScvJ6KcO4tQ5k8ppVkk/U2L0EEQzuRXIgDyXUmk3I?=
 =?us-ascii?Q?6DUyIijA+X+BKJKZ0T/Vb9lZOCZcon7cB8nUHunwUC/7kFehNHzKHBkudiFU?=
 =?us-ascii?Q?xUcEMLwv0wvD4Kz2novr00j3pMIjVArlZbqIjollpFoZfUAfjuueqtH6uj80?=
 =?us-ascii?Q?IzvreD+ASl/vUb8UkcYz/3WF51Eh+X5diQByKBWJkDCs9MtSadzXY4oLS+Am?=
 =?us-ascii?Q?zE6CzDBMwVNZbJxz8q4Hnbo0apBQqyVAtbP7CxdXbarcEt28ICe8gPwEIlkL?=
 =?us-ascii?Q?XI4DME5eoOew5oHkOsKMV1C9rS1QkXPIEgnZch95yvcvJ5ofkDIqKsNupVmA?=
 =?us-ascii?Q?X1z5qu4NxE2iK2RixtRr+tUzu+hbJ89XppMf6M5Q1yptptgqhy7rhQdzuJf3?=
 =?us-ascii?Q?stNfmnYC9AdP50apc/8hK8oZT/ijsOGJTKi1zfTEziAMkxRmiMUWJHA9uLKM?=
 =?us-ascii?Q?zP4IynQFBr68uBtSUVdYWFTXV5GS6rHW/s73hymP06epSqCluJGBwIdYgqau?=
 =?us-ascii?Q?lP0KIaHfPCRF7szu0VAvysu6y57+CuQ/aY2scqbIe+2dFuVRnS6clXpbEg5z?=
 =?us-ascii?Q?duOXXqGU5kYYU+vKIvTL4SOfZTU9zpHe1MJO0y8JCqcwd3r9KVAJK7F4VkzB?=
 =?us-ascii?Q?W3oX1pRrfHmi/o71mkUvEmUR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7faaadf7-25d0-42f5-4f63-08d9863f187f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 07:26:20.0270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elTHCGfbnup/vKDoeCjx2DP6SSzXO0aIWiOxAfwPZWqpCh+Td+gAC3x456C0/sczEYGAAFpxS94IJuCV0xs8Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Callers of ufshcd_reset_and_restore() expect it to return in an operation=
al
> state. However, the code only checks direct errors and so the ufshcd_stat=
e
> may not be UFSHCD_STATE_OPERATIONAL due to error interrupts.
>=20
> Fix by checking also ufshcd_state, still allowing non-fatal errors which =
are left
> for the error handler to deal with.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 9faf02cbb9ad..16492779d3a6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7156,31 +7156,41 @@ static int ufshcd_host_reset_and_restore(struct
> ufs_hba *hba)
>   */
>  static int ufshcd_reset_and_restore(struct ufs_hba *hba)  {
> -       u32 saved_err;
> -       u32 saved_uic_err;
> +       u32 saved_err =3D 0;
> +       u32 saved_uic_err =3D 0;
>         int err =3D 0;
>         unsigned long flags;
>         int retries =3D MAX_HOST_RESET_RETRIES;
>=20
> -       /*
> -        * This is a fresh start, cache and clear saved error first,
> -        * in case new error generated during reset and restore.
> -        */
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       saved_err =3D hba->saved_err;
> -       saved_uic_err =3D hba->saved_uic_err;
> -       hba->saved_err =3D 0;
> -       hba->saved_uic_err =3D 0;
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
>         do {
> +               /*
> +                * This is a fresh start, cache and clear saved error fir=
st,
> +                * in case new error generated during reset and restore.
> +                */
> +               saved_err |=3D hba->saved_err;
> +               saved_uic_err |=3D hba->saved_uic_err;
> +               hba->saved_err =3D 0;
> +               hba->saved_uic_err =3D 0;
> +               hba->force_reset =3D false;
> +               hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
>                 /* Reset the attached device */
>                 ufshcd_device_reset(hba);
>=20
>                 err =3D ufshcd_host_reset_and_restore(hba);
> +
> +               spin_lock_irqsave(hba->host->host_lock, flags);
> +               if (err)
> +                       continue;
> +               /* Do not exit unless operational or dead */
> +               if (hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL &&
> +                   hba->ufshcd_state !=3D UFSHCD_STATE_ERROR &&
> +                   hba->ufshcd_state !=3D
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL)
> +                       err =3D -EAGAIN;
>         } while (err && --retries);
>=20
> -       spin_lock_irqsave(hba->host->host_lock, flags);
>         /*
>          * Inform scsi mid-layer that we did reset and allow to handle
>          * Unit Attention properly.
> --
> 2.25.1

