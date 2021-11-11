Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD615C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69D661354
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhKKHvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:51:53 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12611 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhKKHvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:51:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636616937; x=1668152937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uBaxG1eYQ3nGlfZUtPzfHZIFL69J70+FKsU4gPRk8l4=;
  b=Ly0Ghv0TmyT7wN9gkH8gsm/wO73u5iaY7CuRJsy4Mvk0e6h6A+i7OLL5
   qc83zUsYexl9JAnbFy6OLemdwdKhf1Wn7Cz0fksh1S5vrlbiLHU6ZViD1
   pnsOlIV41HD/voh6hF8g4duWPYgD5wsGmXuljEESwep4PMzkSAppNTbQx
   gzUBFyt4iwXWPbXLnGfqw+7f8Mf9aErvTODX7VktM4p3B+4wVf9ZnftlN
   Qo9GNtCDBVetcajyt4M7lt+Acfx0Mo5JrTwvbeXNkPT6WT36WX8x7fY6J
   1c2XyS/qyKnqrBLEn9ye5bMSdxSyHjK78gAfV6NwJaRIKsnqp9LpbIJf8
   w==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="184330647"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 15:48:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naC1y8knXM9UuqL5BEdyQYGMCgFepoQ2Wo565ylFwamSKfzaBRayChSKfek/F1t0ADCeoe9HQnejy1Czst88RpN4m2vWCvktECESk9KOBnJNus2mNj3A6hyV4pU0wTDAX9OhVYyaO7oWTZx6nTr7lQlamigm709Qola569tU6fL5EtnBODRo5LJdtnLV+lSHRYRckks+yBm2kDEphidT2Hu3Wfmf3GOaJGJFZOJEq3j6c7EW4zD4PuxCNfg5IcTCwbctshAjzHP5fWHqFd9wzA5HarT04NoWr+IcRbnk9jDp7xaK7/uPqgPAWa7ggovDXguU30c0k85jtrREwDgxqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxoxO9njIHZ5e7uIVuUKIiWsdpEHk6OSaDosgsPfe7c=;
 b=FSepa+AfgHmx+eW7q4HWARDCIJkl8VYKJlF0uCbC6/uOwChQAHdCTryDZF/r6vBbU+ir0MHb57YGDESTaKi8XdljcByXil5iKh6+qH1VZsHaVZd0niL0wANXRP3z+hrc1HdTQ17ZJ8wj6nWe771D7MPQiGQVgQF81yNvxRsgF+g6F5N/j35aAcdqha/cwmdkudAWC5EG9+7I/yfIlN6gY4zCdt8t14BAA9aQfrtOQXQB9TLS/RSiHTDaxwXpkmAmEccQAp+q2ehLUrwzvjUVfZlie2jUQLahaUI4zbUue54zljPw2vI+Miow5NfgvIF3+06AS1+HkiXb644zhAMUBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxoxO9njIHZ5e7uIVuUKIiWsdpEHk6OSaDosgsPfe7c=;
 b=hDyHNMstia/a6oQvhmxMco0bCKK6Tzxjuaek5IxHAO5J1GwkYt3Lat9K4icJBX990pLkazbXZRnLpXb1Tr8+RMkyrclNqkeMq3lyr5vdp2U9DhIC692VIJZKUSsqIz/btbn5+w5QeEdS/o/bellRBtIqq5g6SY+YjIoJIIldVI8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4025.namprd04.prod.outlook.com (2603:10b6:5:b0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Thu, 11 Nov 2021 07:48:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 07:48:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 09/11] scsi: ufs: Fix a kernel crash during shutdown
Thread-Topic: [PATCH 09/11] scsi: ufs: Fix a kernel crash during shutdown
Thread-Index: AQHX1cxN3oDhBbNOA0qfNVcHmXHjWav99GXQ
Date:   Thu, 11 Nov 2021 07:48:53 +0000
Message-ID: <DM6PR04MB6575527579A03182E4AA8F0AFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-10-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78d2d181-6506-4cdf-f212-08d9a4e7b576
x-ms-traffictypediagnostic: DM6PR04MB4025:
x-microsoft-antispam-prvs: <DM6PR04MB402550BF94A3F588242367B3FC949@DM6PR04MB4025.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 742vmeryKJXxUnamH4KWBnhOYSrovLgRCE9/Zq4M8UqSIK3UJ65QqdhetBDJwe2vipn78BpKmWz9LdlJjYi9Nx/OdOgwkBfQwDP2j2I13EY9uYPstV6VpeUenOx1hOaJa1bd/AJCciE8RcOY7yLYvyiFg95fX8eB8X5lz/nRcPv4wG+R6vRRCX0nubQAk9vGbYkuYIZMiOQgzrefPRYzhR25Alk/dRKMgGgdyFhSoymnD4p9mjOZvm9mBWSAxn+RuU2zn48SXmz09+qmGvtUyM2QvJqrIjZDmtENmw65NdBMzXtDhTRvyuKKmZZlpdyT51sUFcdDkEj/R+MT4auBY0ZB4SJcpxd5/0OYRq4PH0OM3qD8zfxrj5/ToTgOvNsuEO17EjT8/Fp8NzclwCdmj8IO6LWIDXVntm06OGhC4ytDU+CqLTj9MXvU1qyk0lyTXkuRpLU1RTixbGE9QI8x6V0UyjdZyxHq+w6qiQpzDJrHJH+94QoVzGbCz+3l0jYKZb77NFSnLGgwpUuCUPaxGS5N7g+IJA+bU7vKDefE3LCRIYrr2Whjj4UzB9psPHa8duhsfBh1mei5ZgOGYFGictl4BLQoNfZ6nYBQ7tJV5UYTzTrZdJjgcrqKj+fq9mQ3Yels2SpL0J0SoZuoEBd5hCIm0vGbuCzVK19bLjF4RfBNL+uV8D164ECnWmSj1Bj+P59+VcIbG86P0AROixmxGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(83380400001)(64756008)(508600001)(6506007)(8676002)(38070700005)(26005)(66446008)(71200400001)(110136005)(7416002)(66946007)(122000001)(38100700002)(316002)(52536014)(4326008)(7696005)(9686003)(66476007)(33656002)(54906003)(2906002)(66556008)(82960400001)(8936002)(186003)(76116006)(55016002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P8wTZn9AkPHT5RVZ9OchRKhrzri8dKHspZRwAWMpfFe/HvUS5tiAqUo3Kv+l?=
 =?us-ascii?Q?Z8qveC5V3jlupxlz6XD6EqquNGwWczg0eOyeoj8nLhiN9xvMcRjV4wV7uSqg?=
 =?us-ascii?Q?vZvxJgB05bkoHCC8n14Oe8MtTjN9HV9zf9tD2y31/nctCKUvSpFYXXPSmDPJ?=
 =?us-ascii?Q?0jAFu4TKcdDH/P0E35JvZSwE9xNfY+U35JiauyA/IWbbMJ3xZmfIV4Pfczah?=
 =?us-ascii?Q?MadV7hWs9FMzyeZAmGKntfwOT+pIl/EjLF2nUyxMLQ5JT6sqPnQSmzJ7H4mJ?=
 =?us-ascii?Q?VtM36wrO4WOy/Ipqxod6CGjTDWy5NqnQKd+jbvOVphMHz5fXRy3RLsYlAt3R?=
 =?us-ascii?Q?ybymTKlhetuslDm0aBmW5ujBdfAK/RVsWkduRyhgCkcojeijuib9HCxDNzyS?=
 =?us-ascii?Q?WZZ08CPLNfiXT9Txe11SiJ1/kRiDcqnL2FUP1R/SqZtY4ZxMoC+592+Bp4UW?=
 =?us-ascii?Q?TEduIll07iRM6uzy+g69QTO0ltPzPmK3MTIxz0g7PJcmGApN45KDPYq5MXE8?=
 =?us-ascii?Q?xei0r237aRJFBzU0gQDqW3EUp4vXx/EqkJ7l+F0ngNT8WfCyjTVPCRnrgsHy?=
 =?us-ascii?Q?JB5N+yO7GqEsG0uhnLAlL3q8CkM+JWmzJRCHbo9Wd3MVjb9mnG93CsFkg1xv?=
 =?us-ascii?Q?JKwm0mO1CejG9ypP5xHbunDAbqC2+0BBg6NU5ivlWH+uDE1m52XBd1+EF4h7?=
 =?us-ascii?Q?ULmLiVzT0q15BrwENE/FNzVM1PVTL6xaPwaGtbtxbeKy/uBXqlJHS+L8hYZl?=
 =?us-ascii?Q?bu8n3HhrH4/Gy9M310Cee12wujnpuE6ccVoP1aWDBQQyRv0Unz6N5/Zu0Hem?=
 =?us-ascii?Q?aApyAdcQxIgxfTfMABG81aG0XPnJl/JL0adZSGCUL1xJwsP0ygIoWlL2sqnI?=
 =?us-ascii?Q?Kz5UYn8sScKV9/LbaWpsluW/0IIpmq5clcnfjZpks1D2yma45+hqHfo+eRzD?=
 =?us-ascii?Q?2DMD+ZimR6N2qCnM6+j3gi5hXqHo1dz6NYv/tTf0RqRyF5xRltqt/0ptaziB?=
 =?us-ascii?Q?D9zUw+gphfSmRBIhawvEiRN8GCfVZ2HMhiuc00FEjaS2Bdb28Yp61ET5lhio?=
 =?us-ascii?Q?7+HstOnaNm6R4WrXDB7BK87B7xjI/p5nL7Nzm2+iMqaiN9fWRlS9SEmFT3Sm?=
 =?us-ascii?Q?ttqK/tI/5lVDEkov33BIFftJEvSoPgw5WdCHVaLT1KvApaqIJp2jJ0h8fScC?=
 =?us-ascii?Q?j8EwFn7etkdFUW2sXbkqFW0EdT2Fk79jc9ag5Zh+wJgf0zzZ8AiH5bzQhIb3?=
 =?us-ascii?Q?XUbVSdp+IGcughNviihKtXwxnfnJZcehSMM7paF0FYzPKljLIzYJc0VUQ3qV?=
 =?us-ascii?Q?wOIDamJ9L/Bz0KiF1KdXZx/o46kbSDLyiJp937uaiFSuMiI1vbXkYEY3P1br?=
 =?us-ascii?Q?JpZlYDoTA08SZ9dPyhuAYmO2X2eglB+yJW00Laj6xzUW/pDC4mPPoMdh74+Z?=
 =?us-ascii?Q?fJaYFuXWw8t9QSDOuQpX07CbG6E0nYflgaYfLeKClAbTEMoYIcBarKels0tl?=
 =?us-ascii?Q?Rdp8s5mFR+HETu+gWN07s8h6SPZ7Q+H/0KlL8azelckn2HFljx2MVCKL8nMV?=
 =?us-ascii?Q?BZJaaQzjA5y3fcUsvLFZbmSnINUNPvraS4Wdrg8qOqamDpfpXweLLNvkUV16?=
 =?us-ascii?Q?Pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d2d181-6506-4cdf-f212-08d9a4e7b576
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 07:48:53.7342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saf+KRSn4/TTOpglLugX1RAFcFoUirYo7dkFmFPM2nq7R5lWHQhYi2Zde4QKZkcq+to0/11hsXrNUGvXEJu5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Fix the following kernel crash:
>=20
> Unable to handle kernel paging request at virtual address ffffffc91e73500=
0 Call
> trace:
>  __queue_work+0x26c/0x624
>  queue_work_on+0x6c/0xf0
>  ufshcd_hold+0x12c/0x210
>  __ufshcd_wl_suspend+0xc0/0x400
>  ufshcd_wl_shutdown+0xb8/0xcc
>  device_shutdown+0x184/0x224
>  kernel_restart+0x4c/0x124
>  __arm64_sys_reboot+0x194/0x264
>  el0_svc_common+0xc8/0x1d4
>  do_el0_svc+0x30/0x8c
>  el0_svc+0x20/0x30
>  el0_sync_handler+0x84/0xe4
>  el0_sync+0x1bc/0x1c0
>=20
> Fix this crash by ungating the clock before destroying the work queue on =
which
> clock gating work is queued.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 1e15ed1f639f..13848e93cda8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1666,7 +1666,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>         bool flush_result;
>         unsigned long flags;
>=20
> -       if (!ufshcd_is_clkgating_allowed(hba))
> +       if (!ufshcd_is_clkgating_allowed(hba) ||
> +           !hba->clk_gating.is_initialized)
>                 goto out;
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         hba->clk_gating.active_reqs++;
> @@ -1826,7 +1827,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
>=20
>         if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended |=
|
>             hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL ||
> -           hba->outstanding_tasks ||
> +           hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
>             hba->active_uic_cmd || hba->uic_async_done ||
>             hba->clk_gating.state =3D=3D CLKS_OFF)
>                 return;
> @@ -1961,11 +1962,15 @@ static void ufshcd_exit_clk_gating(struct ufs_hba
> *hba)  {
>         if (!hba->clk_gating.is_initialized)
>                 return;
> +
>         ufshcd_remove_clk_gating_sysfs(hba);
> -       cancel_work_sync(&hba->clk_gating.ungate_work);
> -       cancel_delayed_work_sync(&hba->clk_gating.gate_work);
> -       destroy_workqueue(hba->clk_gating.clk_gating_workq);
> +
> +       /* Ungate the clock if necessary. */
> +       ufshcd_hold(hba, false);
>         hba->clk_gating.is_initialized =3D false;
> +       ufshcd_release(hba);
Not sure that the symmetry in calling ufshcd_release() is meaningful here?
You don't really want to queue a new gate work, this is why you added !.is_=
initialized to release(),
Or did I get it wrong?

Thanks,
Avri
> +
> +       destroy_workqueue(hba->clk_gating.clk_gating_workq);
>  }
>=20
>  /* Must be called with host lock acquired */
