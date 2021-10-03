Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE73FC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA950610A3
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhJCH2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 03:28:47 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:51898 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhJCH2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 03:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633246020; x=1664782020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YPUBoVhyZqIyKYIIPTeNTZK/621AVjFsnMmED4qYsug=;
  b=lxaiSuBAovdOCYDJcJ0SMsmFVj+amtV4ka/kLANvzcDVuXVVEkU+WuOt
   jJlnZtp8TzbrEJ1aIS9+PbX8f020RIuXe9MXbvs6yTkbpLUaguXdaE8gj
   rPHxk4ucUNtgkvCTy0cw879Ujmm5wmt7Y7aZ0MxFXvI/J57ODV82HJm6k
   1Re66XX9ADo2eU6euEpTPnXXYx8R9tyU2RH6pijZRU9y5KPzaOCP3oGBS
   E3/WIEdlQF1xem83s9cLP3FfY8AF2K+mDnk3fJo2SL8DFB4atvU3w3IXv
   sF0Q3vOdqINCGT++40/S0if7xbNGHWDGaMfed5UK+M7IiICEHvI5xZWNJ
   A==;
X-IronPort-AV: E=Sophos;i="5.85,343,1624291200"; 
   d="scan'208";a="180743390"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2021 15:26:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6dB1+om4+oSmICiLNQuw52g6YRGglSBF8ftTp7SEoeRiy6hb2p8qZGfSJoLiLSqSJZhZWYpSq0aXkcNBcyvFIA25O1KjFmF4RZ71yNl7o/bE5walTUhcoysiL7O3erTS+FIBtctK0HAAOOLNOhGKbN0ia1IwWUhCqATbL+3NuTCpIX3lhu7bmKaZtf8CLccsisWGxNOb9si+wfUcJsUTUXQadfi2jy+Gy6+T0hHrZPP6R+pCwbY3afn7Lh7cMoJwZ1Si3nHQZEZx7BkA5BQ86C1uPVmEzknLWjLmfo03VAF+7yzewalnSW+5AkagvcaR2IpWAs7cu6BA49vOd83kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnNYQF44rMdkwHFbkPErY2lKQPWMLCNwOOeykx3Q+PY=;
 b=UvdtuJwJVOq/jQdlP31BQ/90U9nVsqQrR0+Z6cfiaQbCQBH71wGQgARS4G812pSDz3S/csGCRN9ScJEoX8WVyCmcFxq5ziVft3n+evErZWsmsCgcJJS+sgZW4hu5jybnxXDM+6JHEaJej9na9TG2ZMracbpH493KzqjnXGvu31Qo5j42uHJ/QzPJjO+JLUkbhJ/SktGlJo1H7VdSVswEmVEKGyaBuPMcHRP97BYjC6plEawNjYwjg7+ge4Fu3sL01MZE6lkKverOIZlTgsnhzTI5MuE1W/QtQ/Rvpc1mmIMp0twrm6Xt1wpjLu8RGLfkoOjACOt2dWHAKtS13ZGuFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnNYQF44rMdkwHFbkPErY2lKQPWMLCNwOOeykx3Q+PY=;
 b=ypU81qAUilbltq8sBScmFHRq4Ce565JyHYYPHJe58I3f78vi0ivipyRXyKK2uSCicHMgDfH9wJ+9Jm5gjJMdqaypNcElFMbH123IqAtVUwFUm97I6dCXuUpV2ZsLbcOydGQ/Of2HtAexopqTiohHnRmEgL/tvTkt5GSq7rfIB30=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1130.namprd04.prod.outlook.com (2603:10b6:3:a5::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.17; Sun, 3 Oct 2021 07:26:57 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 07:26:57 +0000
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
Subject: RE: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
Thread-Topic: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
Thread-Index: AQHXt6SizcPX5XU+gUCAYqEZHVd+nKvA4KYw
Date:   Sun, 3 Oct 2021 07:26:57 +0000
Message-ID: <DM6PR04MB65754883E6974F46D29C7668FCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
 <20211002154550.128511-3-adrian.hunter@intel.com>
In-Reply-To: <20211002154550.128511-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2ef6116-8e6d-452f-7299-08d9863f2efb
x-ms-traffictypediagnostic: DM5PR04MB1130:
x-microsoft-antispam-prvs: <DM5PR04MB1130E4A743019AF77BB61B84FCAD9@DM5PR04MB1130.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m1Wyn3WaJMSR8u4pboWnj2sxHHvmHY9cKQIj2TcGX70+c+CBX6rpnS6yQTN61eP2ApkAj2ZaYP1poZ8eYjMNYEc1VSO6VfPWghqwVIjpwozrowSsmeThx9upqj8vciMquXulpOgd0iqvM+eU9h6s8kNgFauoeNNAJvJXn++pn/9MmzGxh+NXotOLjRpRC0XOp3RktP5WbMkIFUZ5PhXTrKemjkwN2lUPpUurUV+SuX43KzSN+ianTiOc7+jpcXGf/VqCA0mFXVfSrAh0/4UDQ2pCcx5pimWG2yfa1TDtQA49SE4bc4KyQZIl/p7iOiHX0iw8Xs6Dr0bCREh6KTBibgpFjR8NgEaXdJqUN7RtXe/wqCAfhUctknR4F0z+S/aTfFfGF5s7qECQP3SgLYE0xV2PWb2Fa4MMzgQS9btVKbG3oZDBXqMjwCBg7+MXTrA4hnXYQvtH5f3mtXIkyoobBsZQ5kfleKJAhvHPMFiCUyzlJMrl0GzsMq5xslyIWw+7Oy0m+HqulkK4j2OQSI8/zU3dCOjtFA8TZBitonLz/C6tbvdbINk5kzYex9dg6yK4lH3vqmsXDO87tmqU/T1buJNVwVTvqM2VNDSGclzUgTCTd9Mtyp1xCD/DubCbXxGYpXq0TPHJqdYUCgAHOiCFl8gag2B3p71ZwN75byyAAIKqj/BRCMV8BOH5edwAKyBkiDN3vPkhCANIM8aFGHBqVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(38100700002)(6506007)(66476007)(66556008)(66446008)(83380400001)(5660300002)(33656002)(26005)(122000001)(508600001)(66946007)(2906002)(9686003)(64756008)(76116006)(316002)(4326008)(54906003)(86362001)(110136005)(52536014)(7696005)(38070700005)(55016002)(8676002)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RLM1bdM5QOhcyScfbdSuLuf4ZI4TPxkAIkgcPYWifTzoyyITxSHEPYnXpseo?=
 =?us-ascii?Q?r98kfMUGp4FqFAZ+CT7PLUO2q9gp8cCN46Az7wVisy+otwJQV3uy8SJwUqTZ?=
 =?us-ascii?Q?OtlgVADsZ8eeSKZiY3aH4o/So4jxACLxE5VOe6gs79kk3VRp7HfIFkahuylS?=
 =?us-ascii?Q?1EKsjsg1j7quhQhIOBpZ9wtLVRr012R2svV/E1g/IoRLFNp522M5jvCAoMFw?=
 =?us-ascii?Q?vVbLTABVahkNI10S9rzVdyEi8PHDxE+LJCQbiPdWCBB3YObcr9BlcPXQgYhv?=
 =?us-ascii?Q?HVhmVjbeI5F+dpWBJwMgnPy5Vub1S6KlxWqHrITPFf2nd9NOLQGX1hqc6+qN?=
 =?us-ascii?Q?trg3Y7Kj6+ZqhFlGUJTE/pdtJUgV3pgZQnxPwaEk/cUDg1cu8VJ9iFssavCw?=
 =?us-ascii?Q?i5NUf9HAzHt18e3S3Ul23UiUmSP+zcbcHBpO3pi1GmS5sY2tjWJfVWeWSOOT?=
 =?us-ascii?Q?XbQaUjv2Y0YOXH9Ik+8eH+axistP02B1tdR4P73m0XGii2X+7+10PzUHCg9z?=
 =?us-ascii?Q?gqE1ErB3yRWMyrnS6GTJ+wRsfm1WlBtcPCPb0O1t0OxVWpUoHN3dD2ovw0uz?=
 =?us-ascii?Q?/18ZmTzl0NcMF77jTt10qfPPS1TjAIMTeNDaPYkSKBrUiVnzrqfXYT/tBtB8?=
 =?us-ascii?Q?/xJ0Q6iRkgNsXf77ZCc4ZRlGyfm8V8yK5kMLc/kuFa4wDmooz2C/mY6TTCT6?=
 =?us-ascii?Q?dmN44PtMfHH4rrBf6wR7yt0KdkUt6yL7AA59GnMhFw85HwIMjI+WWXYlnbPX?=
 =?us-ascii?Q?/30XAdEk9GbxCNdtRvOMggsgLbUYATfXwrOW4s6n1ORCTpEqK91C2xJO6M4z?=
 =?us-ascii?Q?2tsTDIMZ2QfJQ0kqFyRmCvzlpdhHPrOtpFgAxqqMqwQO5BaVU4tzDY/CtnHb?=
 =?us-ascii?Q?xYXdursEpKlx5v3DamUgIT6pJMvo2twPcLCgQLRWRiWr2dDtEO5ubb2AC/5b?=
 =?us-ascii?Q?Uo6P4eHDw7RoOLsOlMYdo80dqUiBb5mrNPhpd58HsGynGLrOUi3Bq/x+vEJa?=
 =?us-ascii?Q?e6Tq0uUmFdPgpiEohtD1lA9Fo53RdSMsDKesl0LGAzc3G7vukEjYrl54FZvD?=
 =?us-ascii?Q?OhqEaB/dnfZrm+0j04qzGrliQynaeWJuJXHgbHzMFCkx01G+Az9K/6VGlqiu?=
 =?us-ascii?Q?A1YgiOUM9D3XvB6u9RuLqpIv5n6BD12GixMfYAIkYxPW2fE0uw4JMzVQPLvB?=
 =?us-ascii?Q?T1Z6z6oGk27eTev/qG7X2iKm6wgq1RhMaJLLbheISlhjPUwNoxZkVxflNxHU?=
 =?us-ascii?Q?WfCnXNsDEZPpJf5qlFk/sNibrtBgkR41LJmEvj4l7cXn+KJPov8lw+J86ApJ?=
 =?us-ascii?Q?7MJDKYjbudcEedgrBVGV1OYF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ef6116-8e6d-452f-7299-08d9863f2efb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 07:26:57.7823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yqwmv2liEQJpfjO8Sg5nyoDoYz4MTNU8wfSHGdl3SiYROoM4Mkk5/mRQyb2Dd5F1wVfmd+8qQKkBFIaj7wmtTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Callers of ufshcd_err_handler() expect it to return in an operational
> state. However, the code does not check the state before exiting.
>=20
> Add a check for the state and perform retries until either success or the
> maximum number of retries is reached.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 16492779d3a6..33f55ecf43de 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -64,6 +64,9 @@
>  /* maximum number of reset retries before giving up */
>  #define MAX_HOST_RESET_RETRIES 5
>=20
> +/* Maximum number of error handler retries before giving up */
> +#define MAX_ERR_HANDLER_RETRIES 5
> +
>  /* Expose the flag value from utp_upiu_query.value */
>  #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
>=20
> @@ -6070,12 +6073,14 @@ static bool
> ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>  static void ufshcd_err_handler(struct Scsi_Host *host)
>  {
>         struct ufs_hba *hba =3D shost_priv(host);
> +       int retries =3D MAX_ERR_HANDLER_RETRIES;
>         unsigned long flags;
> -       bool err_xfer =3D false;
> -       bool err_tm =3D false;
> -       int err =3D 0, pmc_err;
> -       int tag;
> -       bool needs_reset =3D false, needs_restore =3D false;
> +       bool needs_restore;
> +       bool needs_reset;
> +       bool err_xfer;
> +       bool err_tm;
> +       int pmc_err;
> +       int tag;
>=20
>         down(&hba->host_sem);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -6093,6 +6098,12 @@ static void ufshcd_err_handler(struct Scsi_Host
> *host)
>         /* Complete requests that have door-bell cleared by h/w */
>         ufshcd_complete_requests(hba);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> +again:
> +       needs_restore =3D false;
> +       needs_reset =3D false;
> +       err_xfer =3D false;
> +       err_tm =3D false;
> +
>         if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
>                 hba->ufshcd_state =3D UFSHCD_STATE_RESET;
>         /*
> @@ -6213,6 +6224,8 @@ static void ufshcd_err_handler(struct Scsi_Host
> *host)
>  do_reset:
>         /* Fatal errors need reset */
>         if (needs_reset) {
> +               int err;
> +
>                 hba->force_reset =3D false;
>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>                 err =3D ufshcd_reset_and_restore(hba);
> @@ -6232,6 +6245,13 @@ static void ufshcd_err_handler(struct Scsi_Host
> *host)
>                         dev_err_ratelimited(hba->dev, "%s: exit: saved_er=
r 0x%x
> saved_uic_err 0x%x",
>                             __func__, hba->saved_err, hba->saved_uic_err)=
;
>         }
> +       /* Exit in an operational state or dead */
> +       if (hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL &&
> +           hba->ufshcd_state !=3D UFSHCD_STATE_ERROR) {
> +               if (--retries)
> +                       goto again;
> +               hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> +       }
>         ufshcd_clear_eh_in_progress(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>         ufshcd_err_handling_unprepare(hba);
> --
> 2.25.1

