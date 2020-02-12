Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED55C2BA83
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 12:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AAF820675
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 12:21:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="it8LJrho";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KbHJ/KX5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBLMVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 07:21:47 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52693 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgBLMVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 07:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581510106; x=1613046106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t/zFM9wupqkBBYmHV62dAPwtKvKTv2+xl8snIqkp8YY=;
  b=it8LJrhoMsTHEtBdvnRqzQVTLHJOQqkqsMRvpix6TBxLMxLk4JqLamKH
   ur/IGs21lfkvMOK4bd3dy6Os6Xgr8lgadyow22Rkx878KEVrCS97joHEA
   L7D6z+J894px86z2c7R1ONA3hAvz0TAcR6VBjYCUreSoVgwZflQQcFhkQ
   pCSHDWQySviU0HSnWRKIO8yZxNhZ5870Xm/X1NfoD06t/wdhQ+9A1TUCr
   bGfWuAgdZ6Vy7ZfhEiDiSz+/HmCM+Zz22YRiad91VqnSmoasRj0CeiNT1
   7B/ANAiHSDDsRoSpe/ELks8lXNF5c/wc2/NJvqAqTRY3OSMcZOr2VnGNS
   w==;
IronPort-SDR: 4tDKme4gk+e/6KCjbBhr68l8abtwgE1ipkY75vJzIfbSbYtBuMtgxwTVeZoGa3cieeZzyzll/U
 e0z0MpXvlffbBqdQih21NtvL1zJUNRxKISd7HihnkB+gMD28CudTlXmI6Pt7NYGqmxftzla/Bp
 /jUPAcm9hlriUZ3X4NUZ+UiTgPS35wUuyd1XginGQ3wDChGpUZHpoNYhZUpengC1eo6kGJ0W6I
 +UhInvvtpagIrG3Ca8l/8IlavvkrXrt46PYgCTD1JWo4pkYLJKuWG3lX2hL5/+9OVOhZTr+Ngq
 RY4=
X-IronPort-AV: E=Sophos;i="5.70,428,1574092800"; 
   d="scan'208";a="129668258"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2020 20:21:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NneyyJdfICcPyi+HzwzLzUCSjkqxNvO/zKVfRTGTGlEUSpWK4//AN/pwmBRZL0moMRW+1AFipNSjkTsuKqoagzXYdBaFcGAqunyHiu4eNOWGwKKlX+HfZgIXIDLuIgyjzRicGVgIjVpsOuHekRYcvKFrLrlpMOE8iDrxM81MijrZmEOeLsB57BY/UXrCjYhygmNocZEq2WLJzMvFVp6qvn+s6k2Zp1y6w8UrIqxUEuf0UokoGz8ZpPmdD8ITx4azeCaIeJ8dPrE1Qdo0jAVLkvFQ5aZL6WbSq9KuYieOT6WDR1GiT8e9ScJnd7/5VmQXH0SqI2QutpSrxCDsnAW2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fkx7eYLDraqBmlcrfIlW+uIkUIWNUEKCCn2gZhuLRE=;
 b=SvbyMpSaE/3DGndu9EPprfSmNaK/8h2R1/5VG0inRYg8dOcFunQuz28I00rxA8nRzav1HT0SF3Ua81Rr4FC2NUgkheJZLi16blga2qP07N4ksVgbHCFlzaFI4g9AGMD8cmV429ENid9t7qJYnav51xrzgRRvn4FCmt6DaN15xlUQTZ3yiCwi3x3SmzJDa1IVQR861iRtn5z6J/XA024VnRaG9mmm7URg03P+vjq7XFUR5+FzB04zH1dJzvSpiFLirDNFoqrdA312Qr+9d56HijeyNZttGjazbp1Ajv6uHRR7cDZ5juwHr1KMR4g/3arvgf3VzXq1jYXHmawtqnlTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fkx7eYLDraqBmlcrfIlW+uIkUIWNUEKCCn2gZhuLRE=;
 b=KbHJ/KX567czfFA0eKrytsSZZyeQOhlCwUrKGnSk1GUmuOTxnv/muieLTmXWarcUsMiaynGc28rEh7DRDgSM6FyZooE/i65vDAyh4FlQhUHMPhKuMXYFSRbHnZ7DU2REoEF/+mxX7PHr0WNo/vshCQPJKU5IoYEzlxMM8LS63yQ=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6976.namprd04.prod.outlook.com (10.186.146.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 12:21:44 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 12:21:44 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
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
Thread-Index: AQHV4Wa4/7BeUknJikSF1o9Bj2JpaKgXdp1Q
Date:   Wed, 12 Feb 2020 12:21:43 +0000
Message-ID: <MN2PR04MB6991136AD340D28D930F27F3FC1B0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
 <1581485910-8307-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1581485910-8307-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ed26d036-ac11-489a-a5d3-08d7afb61f4a
x-ms-traffictypediagnostic: MN2PR04MB6976:
x-microsoft-antispam-prvs: <MN2PR04MB6976517096D2FC4350EBCC25FC1B0@MN2PR04MB6976.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:576;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(189003)(199004)(8676002)(110136005)(316002)(54906003)(2906002)(81156014)(7416002)(55016002)(8936002)(9686003)(33656002)(186003)(81166006)(71200400001)(86362001)(4326008)(478600001)(26005)(66556008)(66446008)(66476007)(5660300002)(76116006)(7696005)(64756008)(66946007)(6506007)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6976;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xBiXRpPgjnGTaiz0o21Pz4EZfcuzUTXG8fH44Mqri1aJ4kad2vVIPCO+UVYqdeVyYinw1OCDV3riyKa6vGKEiL2KlDhDZJaQekYyebH9hQnU73C/81YBlPGNfY+IviWCSysfLficRio7SuJ+0c2t4uUbQL6W7WD0VFcxaAgA6kamjfo+QgIP6XEkS/Rc1wQ4+lLssQog1K5VYGh5tipZwctgJNV+OpyLotSSNIx7xtzj9v/7T8HYqdCv51gnaorWRV3tXD3kkqkIMbpJmjT1Qpfx8I8TKHV7gzO+ci/O7ylm67fG1kZaK2//OHJyoYdi3IhAufTBOf8ZH8NeFNYIRR2wxN6SRzhPDGxSwq8PQL341dxJxJGIL9OmB2r8BMR5bDVPtz2H4delkRjA2fsh5svDe+DpW/LL8YL+b7EAHxNc7ahwuPh+zLwYP3Qr7fvC
x-ms-exchange-antispam-messagedata: BZYJvj8/fERvCz69WksrnLvYGzqSIMk96JB//TWP6cKv6NB0vA5Cpk5RryavHkKMpPJoAEZQmp4g5OdNxhTUhMp2KbfY4T/1HVPu7vpsAGjxwgsMtWbljQn2R5TbDc8SyJySWXmaOCLHRKVC1TBD3g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed26d036-ac11-489a-a5d3-08d7afb61f4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 12:21:43.9392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4HuL70Bgzfl0C+fJlE29sBxthKn3qMA8B5ohWtd2Aleu6MIh1DZg0q9f4eFOsnIMVDJiBb2Xwf6CGK8Av6MaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6976
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>=20
> When scale gear, use ufshcd_config_pwr_mode() instead of
> ufshcd_change_power_mode() so that
> vops_pwr_change_notify(PRE_CHANGE)
> can be utilized to allow vendors use customized settings before change
> the power mode.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index adcce41..67bd4f2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1059,8 +1059,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba,
> bool scale_up)
>         }
>=20
>         /* check if the power mode needs to be changed or not? */
> -       ret =3D ufshcd_change_power_mode(hba, &new_pwr_info);
> -
> +       ret =3D ufshcd_config_pwr_mode(hba, &new_pwr_info);

You might want to inform ufshcd_config_pwr_mode() of the caller,
As now it will be called much more frequently, and you want/don't want
To call your vops on probe but not on scale_gear?

Also, Alim exported ufshcd_config_pwr_mode a while ago,
In commit 0d846e703dc8 "scsi: ufs: make ufshcd_config_pwr_mode of non-stati=
c func"),
But nobody uses it outside ufshcd - so maybe revert this commit as part of =
this series?



>         if (ret)
>                 dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d rx=
 %d), new
> gear: (tx %d rx %d)",
>                         __func__, ret,
> @@ -4126,8 +4125,6 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>                 memcpy(&final_params, desired_pwr_mode, sizeof(final_para=
ms));
>=20
>         ret =3D ufshcd_change_power_mode(hba, &final_params);
> -       if (!ret)
> -               ufshcd_print_pwr_info(hba);
>=20
>         return ret;
>  }
> @@ -7157,6 +7154,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool async)
>                                         __func__, ret);
>                         goto out;
>                 }
> +               ufshcd_print_pwr_info(hba);
>         }
>=20
>         /* set the state as operational after switching to desired gear *=
/
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum,
> a Linux Foundation Collaborative Project
