Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45C3C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75C562071B
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="imvjiFJD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="I8EvkKya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKNKnm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:43:42 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56214 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfKNKnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:43:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573728223; x=1605264223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iDn5ew0dW9/C84/YcN0UQsh9iyqr9tbPTvn4G1H7JE8=;
  b=imvjiFJDGjqmTPZbUL5Zwv2GBH11C65EI2+/s45gFs6iLuVa9RWZvXZU
   WNq17ql24VMiADfpIYEoihGiefIMaDc8G89z02ZOAQPJX45i/7vd6fLTp
   SeBIoa/DEhrCl2H+itxzaqzxC9IAetUG76UFJjfTU4pVJWwAQCe+eCeGu
   Rc83jqFxU+arTMptv40uCMIR3qgx75tIDN6ZCViEMXDXCt3s8kHVinFrx
   8yG+mL/DBbgny0ZXOTSwnzCacpEuZk9LgwY2G3tzmeJ0+EE0dB2JPshap
   KiRxVkJU5x8a0Zz1U+iyPWBGmuNEkcVXCrCSCyNpPMdeM/3DTx4U07hP4
   Q==;
IronPort-SDR: 7KLujGP4NUyf/AlpRjGxahOXsOdPe5h24LI8+IdyJDsrNzTFMQJ5DJWEuGKWTLBRFTp1H87WYv
 mgPwq3a60Fi5GTcBTQ1gRurP0obaRmDwkJMaI9Y2BfFxrM2gj2Xi13IbOhGb+vMzIhlXLSWOnp
 uANaRWeTzOS+FscGK1uF37XpKd/V95BiHFoIEffeGRUYaJNuRCL+eM/0v+Xl9Fk24jlH8qA7/S
 XsMCC8al9/3TbsUmvosm4E6bZQMcS5vMOJuztk6tPNT2NCfMsobyqLN9wlozD8dFYgdB24DLmT
 yAE=
X-IronPort-AV: E=Sophos;i="5.68,304,1569254400"; 
   d="scan'208";a="123763277"
Received: from mail-dm3nam03lp2055.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.55])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2019 18:43:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/dt7JK06kwWurmrrltkF7IFQtLRt275WUTIXzjISGBUgQxn5FSTVZmNxRtqiWQBWL56yx3JcHmvL42MiWyHSf4hwUGsi8/8Hjpkybr/YNO+6NVpDalMygZ0+pkh16Ro7FAAlcLNH0efWsuDMUHzDKKb2egUYQzYeUlBCjbExLBqoJNVqSouW/8WpaE6gXc+TYQuFiyOosr0Wk5H5qe6IJO0Bwv0xc0hZlxhS7EUL7hZKQB52E+32ThhzeXax0wwfVQhHQaTLiqWNjhJU8Fb5VN+IhWzeE1o5S9jEvI9DNrM5z4gaUVAsyj1Ofq6H8EzXCfT9qAaUnsHsBXbsKGIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s6Lz2ldiRsiXfvMoWCpbXExtXv5NbAr95jcfqtWTNg=;
 b=cj5VxKPhcr5vOwzIOW0Aj9a7j4YTPzEmV47J3/80Qy9EVtjDVK5hQU8QA+utQEdjUzs1Ejcbg4ju1yxpLFqqJtdwPgdrNTEqYXi/9Xzhpq+i5dXUMO28JMCZ6UwWNshccoHCFVPCIkUabJ7Ak2ds5qXryq/N6Xre9y8CGUUKUiCQqm/PTwnnwd8af1Z4cSp4qbw1scZ1VAdq29mCIUhlBfXFfTm5bac4oXpqA2Sua085OZkl4i1q2EDDCBafaE7xOXO2iiCUwHruwdM+OH8jkvgA0hmWCBuWGmgRuiTDt3fgD4NqvlopCunURkBP8plwP0u41/+B26G9dUuKoGBtLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s6Lz2ldiRsiXfvMoWCpbXExtXv5NbAr95jcfqtWTNg=;
 b=I8EvkKyaaySurqapzo57N7EiCInxpBxQm7LBe2al1e6nk6nXzk7zi/iy+rEDdeucHKW7ibvWjGTzh0Sd1IWO6xraZ7s8VV+qYEgAkJR/0HRdUN8yXUYCpc9eV9EFAox6VJz3eFD3V2bHQ+0fdoqgaEwKCAuxod4Q5Jv5Ag4ETdI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6912.namprd04.prod.outlook.com (10.186.144.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 14 Nov 2019 10:43:39 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Thu, 14 Nov 2019
 10:43:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 5/7] scsi: ufs: Fix irq return code
Thread-Topic: [PATCH v4 5/7] scsi: ufs: Fix irq return code
Thread-Index: AQHVme4tLWcA454rdEyTvCpbgBLcVKeKfCcA
Date:   Thu, 14 Nov 2019 10:43:38 +0000
Message-ID: <MN2PR04MB69913709436481CD96F5C3C0FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
 <1573627552-12615-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573627552-12615-6-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7007e1e4-68e1-4e11-c0f7-08d768ef8260
x-ms-traffictypediagnostic: MN2PR04MB6912:
x-microsoft-antispam-prvs: <MN2PR04MB69127C3575378968C94E95CBFC710@MN2PR04MB6912.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(199004)(189003)(66446008)(25786009)(7696005)(76176011)(6246003)(446003)(186003)(11346002)(4326008)(14454004)(66066001)(476003)(229853002)(486006)(3846002)(6116002)(2501003)(6436002)(26005)(478600001)(9686003)(102836004)(71190400001)(71200400001)(2906002)(55016002)(316002)(76116006)(7736002)(52536014)(33656002)(305945005)(66556008)(6506007)(110136005)(54906003)(256004)(14444005)(74316002)(81156014)(81166006)(99286004)(7416002)(5660300002)(8936002)(8676002)(66476007)(86362001)(2201001)(66946007)(64756008)(30864003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6912;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IduXVPQkpNsm6p7wb13KNNVXmhRil2c9YQ3AnIkMI6vDIvKO9MoJaQ5IBxrrCsNLiPQhWmJejJHCla1HB44kVRHOIH97GFUwuqCkJ6dSFypeJS7WqyFAdHAo5MY7R4Plo4A6sZo/5/wWZ83M28lb3Bxlpwrkm9Xpc33cIQzAz2VIBc99o2EkrhL+y1LI5tX0ng3g+upWGIPscfeYopJbvi9CXlFKnHTAP0i8BfMNyzz88kgnbrsjS2m6CImBl16oPtLdYRDwRfPSNCgsczh49a0x0pRK9xHcTRDp7svO1ospZp2aAa/etd43X2VgHwtoyWc/qJtrrIou7XGP9FbphgP4BH0hPlJqsbPaV7XNWxu5NZpMo5SsLK1Ri6KfDCwCrIEXi/tumYZfjET+zD36znJZgO2hu+w9xuNfo1kImO52l3sTY0TcpEAFQOhRUisu
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7007e1e4-68e1-4e11-c0f7-08d768ef8260
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 10:43:38.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bKkrDRoRXAICtistI0TMJrSCiowGXaFbbFr6P24EGAoKWP6k3ipns+3YNpXueMwGj/JSNf0RHXCCStLWSvat3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6912
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>=20
> Return IRQ_HANDLED only if the irq is really handled, this will help in c=
atching
> spurious interrupts that go unhandled.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Interesting enough - did your patch exposed unhandled interrupts?
If it does - maybe you can share some info in your commit log.

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd.c | 134 ++++++++++++++++++++++++++++++++++-----
> -------
>  drivers/scsi/ufs/ufshci.h |   2 +-
>  2 files changed, 100 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 671ea2a..8d1b04f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -240,7 +240,7 @@ struct ufs_pm_lvl_states ufs_pm_lvl_states[] =3D {
>         END_FIX
>  };
>=20
> -static void ufshcd_tmc_handler(struct ufs_hba *hba);
> +static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
>  static void ufshcd_async_scan(void *data, async_cookie_t cookie);  stati=
c int
> ufshcd_reset_and_restore(struct ufs_hba *hba);  static int
> ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd); @@ -4799,19
> +4799,29 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
>   * ufshcd_uic_cmd_compl - handle completion of uic command
>   * @hba: per adapter instance
>   * @intr_status: interrupt status generated by the controller
> + *
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
> -static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
> +static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32
> +intr_status)
>  {
> +       irqreturn_t retval =3D IRQ_NONE;
> +
>         if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
>                 hba->active_uic_cmd->argument2 |=3D
>                         ufshcd_get_uic_cmd_result(hba);
>                 hba->active_uic_cmd->argument3 =3D
>                         ufshcd_get_dme_attr_val(hba);
>                 complete(&hba->active_uic_cmd->done);
> +               retval =3D IRQ_HANDLED;
>         }
>=20
> -       if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done)
> +       if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done)
> + {
>                 complete(hba->uic_async_done);
> +               retval =3D IRQ_HANDLED;
> +       }
> +       return retval;
>  }
>=20
>  /**
> @@ -4867,8 +4877,12 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>  /**
>   * ufshcd_transfer_req_compl - handle SCSI and query command completion
>   * @hba: per adapter instance
> + *
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
> -static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
> +static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  {
>         unsigned long completed_reqs;
>         u32 tr_doorbell;
> @@ -4887,7 +4901,12 @@ static void ufshcd_transfer_req_compl(struct
> ufs_hba *hba)
>         tr_doorbell =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL)=
;
>         completed_reqs =3D tr_doorbell ^ hba->outstanding_reqs;
>=20
> -       __ufshcd_transfer_req_compl(hba, completed_reqs);
> +       if (completed_reqs) {
> +               __ufshcd_transfer_req_compl(hba, completed_reqs);
> +               return IRQ_HANDLED;
> +       } else {
> +               return IRQ_NONE;
> +       }
>  }
>=20
>  /**
> @@ -5406,61 +5425,77 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>  /**
>   * ufshcd_update_uic_error - check and set fatal UIC error flags.
>   * @hba: per-adapter instance
> + *
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
> -static void ufshcd_update_uic_error(struct ufs_hba *hba)
> +static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
>  {
>         u32 reg;
> +       irqreturn_t retval =3D IRQ_NONE;
>=20
>         /* PHY layer lane error */
>         reg =3D ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
>         /* Ignore LINERESET indication, as this is not an error */
>         if ((reg & UIC_PHY_ADAPTER_LAYER_ERROR) &&
> -                       (reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK)) {
> +           (reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK)) {
>                 /*
>                  * To know whether this error is fatal or not, DB timeout
>                  * must be checked but this error is handled separately.
>                  */
>                 dev_dbg(hba->dev, "%s: UIC Lane error reported\n", __func=
__);
>                 ufshcd_update_reg_hist(&hba->ufs_stats.pa_err, reg);
> +               retval |=3D IRQ_HANDLED;
>         }
>=20
>         /* PA_INIT_ERROR is fatal and needs UIC reset */
>         reg =3D ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
> -       if (reg)
> +       if ((reg & UIC_DATA_LINK_LAYER_ERROR) &&
> +           (reg & UIC_DATA_LINK_LAYER_ERROR_CODE_MASK)) {
>                 ufshcd_update_reg_hist(&hba->ufs_stats.dl_err, reg);
>=20
> -       if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> -               hba->uic_error |=3D UFSHCD_UIC_DL_PA_INIT_ERROR;
> -       else if (hba->dev_quirks &
> -                  UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
> -               if (reg & UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED)
> -                       hba->uic_error |=3D
> -                               UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
> -               else if (reg & UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEO=
UT)
> -                       hba->uic_error |=3D UFSHCD_UIC_DL_TCx_REPLAY_ERRO=
R;
> +               if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> +                       hba->uic_error |=3D UFSHCD_UIC_DL_PA_INIT_ERROR;
> +               else if (hba->dev_quirks &
> +                               UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERR=
ORS) {
> +                       if (reg & UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED)
> +                               hba->uic_error |=3D
> +                                       UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
> +                       else if (reg &
> UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT)
> +                               hba->uic_error |=3D UFSHCD_UIC_DL_TCx_REP=
LAY_ERROR;
> +               }
> +               retval |=3D IRQ_HANDLED;
>         }
>=20
>         /* UIC NL/TL/DME errors needs software retry */
>         reg =3D ufshcd_readl(hba, REG_UIC_ERROR_CODE_NETWORK_LAYER);
> -       if (reg) {
> +       if ((reg & UIC_NETWORK_LAYER_ERROR) &&
> +           (reg & UIC_NETWORK_LAYER_ERROR_CODE_MASK)) {
>                 ufshcd_update_reg_hist(&hba->ufs_stats.nl_err, reg);
>                 hba->uic_error |=3D UFSHCD_UIC_NL_ERROR;
> +               retval |=3D IRQ_HANDLED;
>         }
>=20
>         reg =3D ufshcd_readl(hba, REG_UIC_ERROR_CODE_TRANSPORT_LAYER);
> -       if (reg) {
> +       if ((reg & UIC_TRANSPORT_LAYER_ERROR) &&
> +           (reg & UIC_TRANSPORT_LAYER_ERROR_CODE_MASK)) {
>                 ufshcd_update_reg_hist(&hba->ufs_stats.tl_err, reg);
>                 hba->uic_error |=3D UFSHCD_UIC_TL_ERROR;
> +               retval |=3D IRQ_HANDLED;
>         }
>=20
>         reg =3D ufshcd_readl(hba, REG_UIC_ERROR_CODE_DME);
> -       if (reg) {
> +       if ((reg & UIC_DME_ERROR) &&
> +           (reg & UIC_DME_ERROR_CODE_MASK)) {
>                 ufshcd_update_reg_hist(&hba->ufs_stats.dme_err, reg);
>                 hba->uic_error |=3D UFSHCD_UIC_DME_ERROR;
> +               retval |=3D IRQ_HANDLED;
>         }
>=20
>         dev_dbg(hba->dev, "%s: UIC error flags =3D 0x%08x\n",
>                         __func__, hba->uic_error);
> +       return retval;
>  }
>=20
>  static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba, @@ -5483,1=
0
> +5518,15 @@ static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
>  /**
>   * ufshcd_check_errors - Check for errors that need s/w attention
>   * @hba: per-adapter instance
> + *
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
> -static void ufshcd_check_errors(struct ufs_hba *hba)
> +static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
>  {
>         bool queue_eh_work =3D false;
> +       irqreturn_t retval =3D IRQ_NONE;
>=20
>         if (hba->errors & INT_FATAL_ERRORS) {
>                 ufshcd_update_reg_hist(&hba->ufs_stats.fatal_err, hba->er=
rors); @@
> -5495,7 +5535,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
>=20
>         if (hba->errors & UIC_ERROR) {
>                 hba->uic_error =3D 0;
> -               ufshcd_update_uic_error(hba);
> +               retval =3D ufshcd_update_uic_error(hba);
>                 if (hba->uic_error)
>                         queue_eh_work =3D true;
>         }
> @@ -5543,6 +5583,7 @@ static void ufshcd_check_errors(struct ufs_hba
> *hba)
>                         }
>                         schedule_work(&hba->eh_work);
>                 }
> +               retval |=3D IRQ_HANDLED;
>         }
>         /*
>          * if (!queue_eh_work) -
> @@ -5550,44 +5591,62 @@ static void ufshcd_check_errors(struct ufs_hba
> *hba)
>          * itself without s/w intervention or errors that will be
>          * handled by the SCSI core layer.
>          */
> +       return retval;
>  }
>=20
>  /**
>   * ufshcd_tmc_handler - handle task management function completion
>   * @hba: per adapter instance
> + *
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
> -static void ufshcd_tmc_handler(struct ufs_hba *hba)
> +static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
>  {
>         u32 tm_doorbell;
>=20
>         tm_doorbell =3D ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
>         hba->tm_condition =3D tm_doorbell ^ hba->outstanding_tasks;
> -       wake_up(&hba->tm_wq);
> +       if (hba->tm_condition) {
> +               wake_up(&hba->tm_wq);
> +               return IRQ_HANDLED;
> +       } else {
> +               return IRQ_NONE;
> +       }
>  }
>=20
>  /**
>   * ufshcd_sl_intr - Interrupt service routine
>   * @hba: per adapter instance
>   * @intr_status: contains interrupts generated by the controller
> + *
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
> -static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
> +static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>  {
> +       irqreturn_t retval =3D IRQ_NONE;
> +
>         hba->errors =3D UFSHCD_ERROR_MASK & intr_status;
>=20
>         if (ufshcd_is_auto_hibern8_error(hba, intr_status))
>                 hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
>=20
>         if (hba->errors)
> -               ufshcd_check_errors(hba);
> +               retval |=3D ufshcd_check_errors(hba);
>=20
>         if (intr_status & UFSHCD_UIC_MASK)
> -               ufshcd_uic_cmd_compl(hba, intr_status);
> +               retval |=3D ufshcd_uic_cmd_compl(hba, intr_status);
>=20
>         if (intr_status & UTP_TASK_REQ_COMPL)
> -               ufshcd_tmc_handler(hba);
> +               retval |=3D ufshcd_tmc_handler(hba);
>=20
>         if (intr_status & UTP_TRANSFER_REQ_COMPL)
> -               ufshcd_transfer_req_compl(hba);
> +               retval |=3D ufshcd_transfer_req_compl(hba);
> +
> +       return retval;
>  }
>=20
>  /**
> @@ -5595,8 +5654,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32
> intr_status)
>   * @irq: irq number
>   * @__hba: pointer to adapter instance
>   *
> - * Returns IRQ_HANDLED - If interrupt is valid
> - *             IRQ_NONE - If invalid interrupt
> + * Returns
> + *  IRQ_HANDLED - If interrupt is valid
> + *  IRQ_NONE    - If invalid interrupt
>   */
>  static irqreturn_t ufshcd_intr(int irq, void *__hba)  { @@ -5619,14 +567=
9,18
> @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>                         intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENA=
BLE);
>                 if (intr_status)
>                         ufshcd_writel(hba, intr_status, REG_INTERRUPT_STA=
TUS);
> -               if (enabled_intr_status) {
> -                       ufshcd_sl_intr(hba, enabled_intr_status);
> -                       retval =3D IRQ_HANDLED;
> -               }
> +               if (enabled_intr_status)
> +                       retval |=3D ufshcd_sl_intr(hba,
> + enabled_intr_status);
>=20
>                 intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>         } while (intr_status && --retries);
>=20
> +       if (retval =3D=3D IRQ_NONE) {
> +               dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
> +                                       __func__, intr_status);
> +               ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_reg=
s: ");
> +       }
> +
>         spin_unlock(hba->host->host_lock);
>         return retval;
>  }
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
> dbb75cd..c2961d3 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -195,7 +195,7 @@ enum {
>=20
>  /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
>  #define UIC_DATA_LINK_LAYER_ERROR              0x80000000
> -#define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK    0x7FFF
> +#define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK    0xFFFF
>  #define UIC_DATA_LINK_LAYER_ERROR_TCX_REP_TIMER_EXP    0x2
>  #define UIC_DATA_LINK_LAYER_ERROR_AFCX_REQ_TIMER_EXP   0x4
>  #define UIC_DATA_LINK_LAYER_ERROR_FCX_PRO_TIMER_EXP    0x8
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

