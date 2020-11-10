Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1547DC55ABD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 07:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996B320829
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 07:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KtF47DDN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GMUopVMc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgKJHwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 02:52:37 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:52936 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJHwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 02:52:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604994757; x=1636530757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N0H+GccD8zRGAfIkKz34yz9knVOvpz0dRSUJHL2woi0=;
  b=KtF47DDNyGZMsbTCK1nSnbPHmr8kxtwng9UO1/KgNohb95IFIXO0Cecy
   4XGbg8io17Q27qTA6ztymvoizPlUOZVwSJvSHC4AoOjhTvpa11CpP6C6y
   Udf9oKLGVB4w9wEQGkSPU1zq81ySVZwDFLsdhrD5xo/uc2ZuGj/zhNodg
   +4brOjii3NgxA5C9WWj9AfW4GNydsBkBS2/GnFfQQHBAiWyGiftlSl95K
   kLIq7hJDHd4btpYIbVga3Oz8K1KaN5R+yPJ9zZxp7eS2TihC5qZQydnZ6
   QUS4M2YKcu5vuDWDdGRyKOOGJlxLWrKxcbgcq1yPti0AbD1ZcxfQISgau
   g==;
IronPort-SDR: tjJgco/qruJ3m2QJa7CgDatar9rXeQJQeNiCPOM1cg8gsI6+FtxVJsnquuXc89PO68NhkbXIif
 0yaIHXFBM8mgWDlxwOKGKngtYX7vh9BEFJFYoWAU9buLncVSwN87ws5co27gyy/seQHgaLUNi1
 WdO3y/xobB0zMepU7bX6F0mFtYukyJG7WsTZ0W+AICGpTUaHz7cDZzraSoBxODLWgV68qTN46m
 01ZCQQisxI6q6B2xF2IQo/GWTsjj3PRT2IXMNNPX69orW9ZvN9e6lnnvI4tZ+bmbx26IW0SzY0
 sFU=
X-IronPort-AV: E=Sophos;i="5.77,465,1596470400"; 
   d="scan'208";a="153459890"
Received: from mail-bn3nam04lp2054.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.54])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2020 15:52:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNhcJuP+puiZB6A0oxnItsIPAxX8Kc8EWNKoOWINMxxPfbEirbumBXbf7nm/E75OPVxbulBlGv8e47Hco16AVcReOTNReIs90b9vHlPloh/MLA2+JsMP20hHWvnrJ0Dfh5206VqkxrDHEG+JewvHQowBE/ZuPCwGf6Fu7M39mF3oSTbKVGLTPCflrQGWQOv8bVkLWtO9aZAIlCA31NNxtFOP/MQFU9Jc5CURDLLhoTE6H7D8ELkOfvpXWSD0YBZbkkUDGobkzVlkyrS8oP3wkZH93U8e1KGoFmR3zJnGM69+EjLIBQvTqfq5AYMpzjMScYV8m40isQL1Iz6BhKLd/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ37Xqc7pZU/Abi+A8Htnl4kji9z0aGuygN375Aj2ec=;
 b=REIYVCYFi95DnST3vFPiJAgs4q2Y9Wu/TnKkslwsJ5XCas5bsa4MmsO0frnw/3MoI5x997WyNXYGF3apuqKn3zHFrd06uNM+S9gGfPSZQYm09hBZ2WaW0M87oq58+n8bLJ0geXPuwfwRzwswKIvYkd3tlCgQnqHr5571dOwLEtSj4XMKKDntP54bJv59BI3LK+hxomNcrq4cRGYTDNI3emN/ISvsiu0JQyeo8fyS+Qx8zwnmgMwTKZKGkK51GMupwUt0ilNwYfaxs6WObOSMDahrALlS2jok0udQ4ZPW42OZqKhBdtQjEU0N9Ns60eY61Q7Sq1Q8tb74Xq49k1/emQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ37Xqc7pZU/Abi+A8Htnl4kji9z0aGuygN375Aj2ec=;
 b=GMUopVMcCLmuDrofs4Fq7XYeREUYMWle1OFyu+CaRXGtK6XLAdVpIX2c2ebaRgRB8L0aeWH1Y3lQZpeKwJEbuu9RFqYaOWBWc2zub3CKvF+fpB5kzHYq8DSDCyFwDV6SLqq6GGqsnLvXOxI8QxoRTFlD0C7fCnNyubdJvp8Rz/U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1133.namprd04.prod.outlook.com (2603:10b6:3:9f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.22; Tue, 10 Nov 2020 07:52:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a%9]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 07:52:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufshcd: fix missing destroy_workqueue()
Thread-Topic: [PATCH v2] scsi: ufshcd: fix missing destroy_workqueue()
Thread-Index: AQHWtzRZqrl014t+eky/0Sg1gjmKMKnA/ekw
Date:   Tue, 10 Nov 2020 07:52:34 +0000
Message-ID: <DM6PR04MB6575DD8902438750B2C2811CFCE90@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201110074223.41280-1-miaoqinglang@huawei.com>
In-Reply-To: <20201110074223.41280-1-miaoqinglang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e3df8e34-3f32-45b8-a2e7-08d8854d95b9
x-ms-traffictypediagnostic: DM5PR04MB1133:
x-microsoft-antispam-prvs: <DM5PR04MB1133617E85D1E33A689BDE95FCE90@DM5PR04MB1133.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:156;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0IOINQ9THW2l/1V0W0wgsL0ceNn+HXt74n/F6ENv1PrPBw3ssfLmb4DLo3YjagFjW0AioWGA2Ko/R2XX9e3hTkoDeCPaIldd1DkEPd3mHoFxcG2o8tUXBgbNQ2+lO4SAmZRNRNoVfAqKMtNMNG6avdmsqa2pzqTLe2j5wlsXr7N8XHLPNAjgnysLiiuoTLIIubAno3oeaVdlXa14PZ6Tnor94pZ/nCHYhXQZcr+ACpGgH6fuET+8Ry9gwpLWvqVuGSA6PmbZd6TQQH8jt+7sVue1W4cr5Q2ckpJZUSLMTbP27tgyB4hFIbdso8rdQ6X5cwoiLqV2LxrWLv2gwR1BvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(7696005)(52536014)(6506007)(71200400001)(26005)(4326008)(8676002)(186003)(5660300002)(86362001)(33656002)(55016002)(316002)(478600001)(8936002)(54906003)(110136005)(9686003)(66446008)(2906002)(66946007)(76116006)(66476007)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KI/2GfQXBlATczHg3yvlnNQJI4lz0SDPQLnK0Fo4639Gu3+ijCJaHte4oCOqYtP+kTku8nCVoFHEV3ZWk5yYoXjEOriA+IoszRSQ/Ag09foSNibq0Vd2XGRkDetZW4L7F4QqkzwjTUg4qoWQckJuXTReQzeUewTOSe/xt22F6qYX9KoKMfZwOFZIl+j9/ZY2z6pngm8UspxcQNF6dtttDfFBiIRWbHzcNzxVRl+JBmSgQE08ndBPM4bTJB7tm9boIZeL5MemDBc+CblZ2kkYoo+UGr9kZhQZy292ySGKCD+j6uOwqo76zwTQMwMC4p4PwDc9qM/XpOYPMhrv61LmTE+1NPe/F9APP+PTF5oGIP5brxLHzqF9TLvWuhTX+w+K02LYK20RVnT0PufxwM0UxS5MN7C9J8/cHaFJ8G2UJMfbE2+JpQQ33BKtzhRmMXEMojLiR7fOZdem/sY4RTJAUfUj0OqCtTBnd4GhaPC8a6H9oIYZ1w9ZOHLdKmbViZeHN5uMjjRQwmP6NYrSom+Z1CkHB2jABf24SKjpi6cjJ/5qJe5JQy1A5smJeXhsifedjSw9yz6BOankKyn/pkHNwb+NozHVIMVsSkf3xGuflQFkBV8IKJ4sEaf67jebnN0YqTkanhs9VvZMmEN59K1bMQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3df8e34-3f32-45b8-a2e7-08d8854d95b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 07:52:34.3424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nG02SNZ4WPcmTlaI9e05nm0LsHvDRIrwvjJiidqGv65WiCgpRqqsuhLYzSAlEcFPRjmDaWw/Nkpi3H3+1x4zxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Add the missing destroy_workqueue() before return from
> ufshcd_init in the error handling case as well as in
> ufshcd_remove.
>=20
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and oth=
er
> error recovery paths")
> Suggested-by: Avri Altman <Avri.Altman@wdc.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  v2: consider missing destroy_workqueue ufshcd_remove either.
>=20
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..adbdda4f556b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8906,6 +8906,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>         blk_mq_free_tag_set(&hba->tmf_tag_set);
>         blk_cleanup_queue(hba->cmd_queue);
>         scsi_remove_host(hba->host);
> +       destroy_workqueue(hba->eh_wq);
>         /* disable interrupts */
>         ufshcd_disable_intr(hba, hba->intr_mask);
>         ufshcd_hba_stop(hba);
> @@ -9206,6 +9207,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  exit_gating:
>         ufshcd_exit_clk_scaling(hba);
>         ufshcd_exit_clk_gating(hba);
> +       destroy_workqueue(hba->eh_wq);
>  out_disable:
>         hba->is_irq_enabled =3D false;
>         ufshcd_hba_exit(hba);
> --
> 2.23.0

