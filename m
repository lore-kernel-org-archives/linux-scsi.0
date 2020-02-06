Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAF8C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 07:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0F8C21741
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 07:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QmxV4Siu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="X1lIF1fu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgBFH5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 02:57:24 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15553 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgBFH5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 02:57:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580975844; x=1612511844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OqWqgA4vkhWCSHmxCyvVhKgxdCoie0kaRALdfF3IW1A=;
  b=QmxV4Siu16yN031bh/u1d1fdISyTo12glr+hXp/EdMXKZ6U86L9DlNCl
   RaVBzPguIj60FF5wZtOz/YSa160L66+7nf/KlM9dpp0pQMX4C6cgzkV5P
   JgFoyr86vKL9EdoRAmLfQ+p4haRdYqLx+ZBPzDhmxWzhTE4FeSNsOWe6f
   9zyG2bVwBGDqG9YX+LrxS4Y+6aZ/3EyLBG+62BC55oF4nUQUr3Hcuc49F
   P6Klpy7hiHb55HW5TD29l1CZB4tDRoAFydspptZb0ZIyv4u8cD7HkGkTN
   KEjjPmZSPjJ2+9ugMgXFVv5XvVhXHmXctGL86jwRylL71VwdXRQ1A21ty
   A==;
IronPort-SDR: dlM8/DvzkxsFlhPZyXbvzTXEPHeSNuNVD3oYbfYDeKnXXH/XDZscWJSPRUyIwYik6CUrxwK+nt
 QxkderYdgy4BYxTV8ahDEoJTz8SmcNkC52hy3j2bf2sDvq1bSXLdmN3GcaTgth9HcxE77MUoww
 U3qBWpbG83/4qlOXDbXuz+CDw+hbybAi2I9X8xM9aBKfUvZsDkQasueLugdLO1ITFlJYEAlZqp
 PuPlKw9Dp7VyZgZ9RNfSuicHeS3LaqiqOa3B6gitqrW8M3n3/ElgWXKxH885U/csctj3YZ3Hbb
 AKw=
X-IronPort-AV: E=Sophos;i="5.70,408,1574092800"; 
   d="scan'208";a="133580134"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2020 15:57:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6k2Ax3swSBxkYRQZTmZCQy255sS0vGQhj3Spe4LmURI/8cu7BA6nTJbLLSXOo43+DKfHAckqypFJ3hFkSTfPh0VJc5Nj2feCk9vIvzH4+D51um7fx4tuWcZUNaXNF0fqhKRZk+tp1/mxDBLpLhn8zCC2kHv1PxPU7Z22gHihssUq280NFVTKBiA5/42l4bvj594YVAcD3Tuz9eZ9utTrV+Y7nLTEN8gIdMfhgZmFf68mh4LrRzYY3unXcvotoYHTvirLz3FNJ3movacjxPTPE/AgyXF14eJB3BB7U6Yx8GIkZPJf0niQ7S9Bj3js7mgemSjK3rlK0/u7NkFi5oA4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch5RINB89iweU6CZNt3ig4VQ8/G3EvyLjmQ5LuZ6Ptw=;
 b=mF6VHONmRw5PsD84bxMd4ikAzr32A0ahAzpSTZWhQFTjoa/CqxE/f0+975NgEHvaXXNa7/bv4bfIcQMI0c/bhC1ORjqLrqrauwVn3JdTumYKkVNXsXPCsBbz9uO84iAs5BZDSKea+lLMTMKaXfALJsEJXd72p42L7gjHBueeMM+8S0QgcQtncoZTcSCi/1nLSTXclz+WbjXuDQOurDreexOPjRGCIRC/+kpxE3HVEg4Nd0uJQT9QWb183wOzx/bsI8XxfBdP7HJqnNYMRzhcBJAI1YkfJQfl4bNcyTGot2SuL8sQj5S5Ig2Vo/6Eqn53Z8FboMsMuVzNwfXk7d4mNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch5RINB89iweU6CZNt3ig4VQ8/G3EvyLjmQ5LuZ6Ptw=;
 b=X1lIF1fuOgf000OYi2dhnegaAsGGqBeFBce3pESNH1PmfHNW3HRfnlYo5yShMx9kR/bgFDKA7+GtyqrRKopm8/2B9OWBoGmNwYphEc8D1GTHw454YQIUwqQUcGAxZBFWNqKcjZbByWGtg6LrcCiJt1TthVJbArqvEV+f53ljdEg=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5854.namprd04.prod.outlook.com (20.179.21.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 07:57:20 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 07:57:20 +0000
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
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/8] scsi: ufs: Add dev ref clock gating wait time support
Thread-Topic: [PATCH 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
Thread-Index: AQHV3LrFqYJc4q2xTEa994hLDBcv/qgNzFHg
Date:   Thu, 6 Feb 2020 07:57:19 +0000
Message-ID: <MN2PR04MB69914C6980E32674B38F9152FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580972212-29881-1-git-send-email-cang@codeaurora.org>
 <1580972212-29881-7-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580972212-29881-7-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1778fed3-6b43-4dc1-7583-08d7aada3141
x-ms-traffictypediagnostic: MN2PR04MB5854:
x-microsoft-antispam-prvs: <MN2PR04MB5854433EB06A903115BFA8E8FC1D0@MN2PR04MB5854.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(189003)(199004)(55016002)(66446008)(7416002)(9686003)(66946007)(64756008)(66476007)(66556008)(76116006)(7696005)(86362001)(52536014)(5660300002)(478600001)(33656002)(8936002)(110136005)(54906003)(2906002)(26005)(186003)(8676002)(316002)(4326008)(81166006)(81156014)(71200400001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5854;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4jbTSibynyHiFhjXmn4UmXGoffnSZxIdwIJdEy24C9WRbnMQvNLdQhulVnBsRQZs7Bj+EXYV+S8Au5GHFkZjOqZAGz31GJsF57IMID3A97Wt3773JlYhE1JumTat7CW2/uXzYA61KsZy26IT96V2mWm+Ss1acqzRC4JZVQact4Cv5paL6oeOel0zHekQUh+4dnmm73uewxqr93GJVP7eRFqYGnRH84ZNUNSrufeJMf56HQLagtNK4EVDsRSyQxupBXg1+ruIM5nCi3OMFMsBd65w5I7Op2ibWYNwwsVNo31tRLI0KwGWYu2oKbCDQOYC+TNwggR1gkgc/qccHXDpCFeyELIiR1e0c8rhQyFwn2dlvqxNql+pSxrfHqlvyFyBxoVPjkvrlY9rQLuqL+OUnTHh+B0DoeKvDqm0EJIjvzPpXzQsteX8rMWsSeMwOsmg
x-ms-exchange-antispam-messagedata: ebzCKMb0puVZP4RV6nqRTCt9mu7GoonYY+knLBmzCjqEfyT1s/Vae3+aEFmoT6TsdA77rk7M7m8HqHGrRzdeTuspw3ayj94/rL84S0WcdGjvpN60r6CCLLVYxq2xeHmdZjOaLj7+BgW5D7A3/xg3MQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1778fed3-6b43-4dc1-7583-08d7aada3141
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 07:57:19.9980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ElKrv1ezpZDRXKJK8dUxL4BA7t/hkBCdi3AtPVbEBvPcdJwawliGX5jTCEeu5sxIwXb0EDXOvN4Dxw24jeEmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5854
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime defines
> the minimum time for which the reference clock is required by device duri=
ng
> transition to LS-MODE or HIBERN8 state. Make this change to reflect the n=
ew
> requirement by adding delays before turning off the clock.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index cfe3803..990cb48 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -167,6 +167,7 @@ enum attr_idn {
>         QUERY_ATTR_IDN_FFU_STATUS               =3D 0x14,
>         QUERY_ATTR_IDN_PSA_STATE                =3D 0x15,
>         QUERY_ATTR_IDN_PSA_DATA_SIZE            =3D 0x16,
> +       QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME =3D 0x17,
>  };
>=20
>  /* Descriptor idn for Query requests */
> @@ -534,6 +535,8 @@ struct ufs_dev_info {
>         u16 wmanufacturerid;
>         /*UFS device Product Name */
>         u8 *model;
> +       u16 wspecversion;
> +       u32 clk_gating_wait_us;
>  };
>=20
>  /**
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e8f7f9d..76beaf9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -91,6 +91,9 @@
>  /* default delay of autosuspend: 2000 ms */
>  #define RPM_AUTOSUSPEND_DELAY_MS 2000
>=20
> +/* Default value of wait time before gating device ref clock */
> +#define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
> +
>  #define ufshcd_toggle_vreg(_dev, _vreg, _on)                           \
>         ({                                                              \
>                 int _ret;                                               \
> @@ -3281,6 +3284,29 @@ static inline int
> ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>                                       param_offset, param_read_buf, param=
_size);
>  }
>=20
> +static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
> +{
> +       int err =3D 0;
> +       u32 gating_wait =3D UFSHCD_REF_CLK_GATING_WAIT_US;
> +
> +       if (hba->dev_info.wspecversion >=3D 0x300) {
> +               err =3D ufshcd_query_attr_retry(hba,
> UPIU_QUERY_OPCODE_READ_ATTR,
> +                               QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME, =
0, 0,
> +                               &gating_wait);
> +               if (err)
> +                       dev_err(hba->dev, "Failed reading bRefClkGatingWa=
it. err =3D
> %d, use default %uus\n",
> +                                        err, gating_wait);
> +
> +               if (gating_wait =3D=3D 0) {
> +                       gating_wait =3D UFSHCD_REF_CLK_GATING_WAIT_US;
> +                       dev_err(hba->dev, "Undefined ref clk gating wait =
time, use
> default %uus\n",
> +                                        gating_wait);
> +               }

You forgot to set
hba->dev_info.clk_gating_wait_us =3D gating_wait

Thanks,
Avri
