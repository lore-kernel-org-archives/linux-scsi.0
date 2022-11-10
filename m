Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF44C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 11:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiKJLHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 06:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiKJLHa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 06:07:30 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6B66CA2F
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 03:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668078447; x=1699614447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yMuCnIRQHsaKKd+wPRLuvHMQwr1KQIVHslXwpVBoti8=;
  b=fh6FrWo0sitWUk/528stUwC8EBLZHe0VbOvCvRHVnNA71+xbshoMVhbX
   /BKtaAGzFcE6m6v66Z23vuHr/gCulD3uZukq2zhpfSwl0S8raRmx3h4tN
   HauBVGeJXQGJstv/Ru1L/pTsZflKlSwYB6y7x4mFbKRkhwHHWV/MvrCZK
   eRGp7TV9hQEGanhQAvjND2mZzkldJIfq25pFPZ/AqjQipyzCDs1PHuLcC
   xA/fTEhBGhIXlrpWAb2rsTtd0wasKbMDOL4xOjxo3AISVdHRJNLyAqK81
   l7YAUgOZycvVBqz2m/AuO8ySNsGnR0zmTDgYHilRfLtMJzrSLJsSQGDZO
   A==;
X-IronPort-AV: E=Sophos;i="5.96,153,1665417600"; 
   d="scan'208";a="320286174"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 19:07:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBU3C3hyZsWE3lq+HhMgjn3nzWIgD3F16vQj7+K9/h+nu0vceWvThvDq4x6k4p3xsEgAbjhlN1LuiRyjh+509EOg2hQF57+kWefTWPbxyo8SfO4bOZUclVkHww9EPympijOAcHNPOZdWpgakVgMC+he9660bAMivYPtrQ5TGlM2xnFz6xlWfea5IzlxMbKrrwqu9npkgYi9kiilntl9LDb/odU1Vfbm79IhwuZlMR8cN75+zDd4svrLfcd66/OUS/Vvfo48OCZjqk/OMnW1nQM38p5nvJJqfScspmJ6UP7J3EGjf/EfvC1gykBW9G3dyiWa/V3oOCFU6qs88TuDFlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uISQeLkYT3tIQ4HtQnItFO0sdSGmdF2ZyixAyWC7sxU=;
 b=MYmqfBGTcCI//1pCquP2O0zQT/nv/NbPT75ZkzyUia6G59yX3q+eNQUgybtdG1PYQWSujIjZgD5Za2C4mdf9Qo2kg2COnNxMILK4Le6VWSHIjI2fS9LcWJ+QtmjOze6cA40d1La9nxMSowSS8TwOKjVtzcsTMkMEywmgGHm0nSTUKiGQ238PbNRafpAENryd09wcqpsjABmHM3iqX6x/TvNOOEgq0MfZ/FxioGK2AAgmOwzKmma4nidhEejoTu8b2Z0s1J90m0VHHVW65xF7GCoqn+drm0zkbFE+Iq76/XIypStcOLSNHMTFXJMZOfCwvlCd9Ey4NV0vj4IUhRDHow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uISQeLkYT3tIQ4HtQnItFO0sdSGmdF2ZyixAyWC7sxU=;
 b=rhfxt8EyZPCO7SGbDrHJX1kvzqt5fo/1ylfkjjpJyAYpRsTNJc/35iWeWxjLS7yKAranQffGOwMtX3qg4c6MYb/uJmSBETPztecUww5wXdl5diATCMe7IfCKIf9Ebm/zgcy9NouI0WkmXulBYFImH00Mg6x4b8VMK0WBuH2D15A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN7PR04MB4369.namprd04.prod.outlook.com (2603:10b6:406:fc::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.13; Thu, 10 Nov 2022 11:07:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72%4]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 11:07:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: RE: [PATCH v3 4/5] scsi: ufs: Add suspend/resume SCSI command
 processing support
Thread-Topic: [PATCH v3 4/5] scsi: ufs: Add suspend/resume SCSI command
 processing support
Thread-Index: AQHY88qsAXqduidu106gp3ZHfIIXh644AU/Q
Date:   Thu, 10 Nov 2022 11:07:22 +0000
Message-ID: <DM6PR04MB6575C7BA448A45E6A386EF46FC019@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-5-bvanassche@acm.org>
In-Reply-To: <20221108233339.412808-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BN7PR04MB4369:EE_
x-ms-office365-filtering-correlation-id: 919c1206-f42b-4da0-8410-08dac30bbe13
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qMfXgao/j7Pe0SOob8n24OTbC0lyA6fQeKrNtOHtXyRtEZ5/GZRSakybaZAQTmQvtOyUJUgfHzkU/anjznD8nNKNginmTRO5P/vs85dQXU8+U7cg7oKAJlkoy4x0qHzPfs9TvrrgmToE3uStOSJIac8KR9iYJUVpU0T9TR7+cck8haF8O2xskhvwesegi+2KEcteGrOxaVrD6t/oxBaYo3fGvN6S77tAmpSn+EHkkY1Lc5aHuC7WG1LLgCOyEllF9k09JeFJqPrSSdnp/QWi4lMMjONrn5KhvHVXoFETi1Ai96CC/PGsuyKRDtnSO0urF0ANO9YjdnXiksJHybfeV5jMpZJuWTvIhlRczQlO2a8jaf72N2bPOk7YOZHqEJmKERlUVS8//him/CBSnRxridbgnhM7WCuOfFELY/Qjn86Pz+ZepzZnf02JR6IYjcS34SBcm9Q+aqON08Y5jVYLH9mP6ZEOsodk0zpKfa0S2lOrjQPWZ3X3Mb9N4AzCcN4AjMslxK13AY6mXC6BOKCiweAF7MOWdaq1shmgUEJA4udGcmb5elJxwiY6s24lVREnHErn5qkjA/XpXqC0QRppYUJytbRMyQCmQBRw4mKDX88zw+PLJn8a/6EkPuP+cfCC2sSf7bpaHhqqWey+4WDfoYIwYqxx/rvPTzIlKFojkMwUGBCwqL5V+PLiCKHjHFW9bEGsODyhLI5TceRNNiSOt+m/ouYLZn9Wwsxq2t4k/erTCZdfe5erb59whlK2aL4q4ffMginifDXKo+JBDUlTDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(7416002)(5660300002)(55016003)(478600001)(186003)(15650500001)(8936002)(2906002)(52536014)(33656002)(83380400001)(86362001)(9686003)(122000001)(54906003)(4326008)(8676002)(110136005)(41300700001)(66476007)(66446008)(82960400001)(76116006)(38070700005)(26005)(6506007)(7696005)(64756008)(71200400001)(38100700002)(66556008)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NW5I7JXvgCJkcbEQosFwbmF/FLkbVMr4qzo2J+r1nQMBJfY4Qb8uDsSbG3JE?=
 =?us-ascii?Q?5Y4VYBSBOJaIWKq04ti5Hk5FPISPn8iVh4bU4xSmUifylst2zMYoymmD5zv4?=
 =?us-ascii?Q?Y73Z41z1ygO2owSlgaoI3ZHWoLI4a1MLU40TY1NhklkR0SWaQ/HxrQlGiZ3B?=
 =?us-ascii?Q?Z5CflI4Y2TUVWXJWIwYtrLeS05iYOcnqCoTHShQu/jst6js5Q0jpZZeRX5x4?=
 =?us-ascii?Q?9Nm+304yqRDNew52Nd+v2o6FphEbBVHsxGmAGQ6/iafKkcuBPLY0A1rqs8OV?=
 =?us-ascii?Q?L4qsubrzn9rfhNV5dSXQBTwsIfi8POymU1psZ4N4JIhQIvIgON96H1Zlj+0f?=
 =?us-ascii?Q?WRoZvFuknD2dx/h8z2EHMyNNkEYfY2gSYHZVeL8W0dUAdLIsPLy4Ys95c3Gn?=
 =?us-ascii?Q?1A3HmV9wst5Q+D7osdrQZZWO0qe4JyfBiqeB9QjVunRdATT0pGx7OFevJXS1?=
 =?us-ascii?Q?gRq4yk4wxiquWGx454rN9+HxWXOKvWqPgaFwcmsvxdOhcIYfJlcQp9qI6oUq?=
 =?us-ascii?Q?KApCrPTBMa+P54pv+DUYjZAVur5JOEf+Jyh6cdNGWGPNk4ewhArdJsPS49f5?=
 =?us-ascii?Q?36Xa7A8ZWYeXVP0jngjRb457TBPm/SO2/MqHv0y7zoSlFZ62yX5ucpFVZ71l?=
 =?us-ascii?Q?9AR3f+db/h9GB5SDR7Do4XU7dMRerjh/A8223fUireNJugJ8JY3oEtAaDR9+?=
 =?us-ascii?Q?YA9s6CX5TaN3FXQ8J1gssfhGYSj41makeREnGR4d5zS9FOXS5KBVSyATYGOb?=
 =?us-ascii?Q?bui0sU6UhzXzzq+k2Nk/AZV+k8PfdNWqhCieyIpYIRuxwZbjwfoVFLdIBtUO?=
 =?us-ascii?Q?JWeeajhndnS5EJoJacu7Ldgg5bRYxwmp+8XnpcnOvVrFQ5erbbZ85OGSRLMm?=
 =?us-ascii?Q?fQNt5shkjPDCehN+BIa2tqi6J7i9NOw7NbzVNiqOTdra9y4KB820xAjrdrUc?=
 =?us-ascii?Q?RXEVQYuvBHhx1jr8DZtoppx40dx2rcxEalUbIrgOS+VbV4Sq/BuupcpLooHY?=
 =?us-ascii?Q?sGbbdqJLneruWSmxKzwZhze6jFdQBq4qqStGJrAjI5JYvE1TNJ5ACJvBceVa?=
 =?us-ascii?Q?r4YZpmgZEh9l7/A4e7060YiMf3Ml0QMtLiKVtGTnAEjAlcXTAm9mb+ZBW90L?=
 =?us-ascii?Q?jpTw9uUtNjMJWtWU+NNoZ2e19n18YTmdDCACUlUJNWKgpoegzvd/ropzFUER?=
 =?us-ascii?Q?JiHf+qeb3vraAZOX2xHGFEfr3LwRdVE4NFZKJKcBZGgDxcnE5XZxl8z3Bzgb?=
 =?us-ascii?Q?8xubjp1n/IV9lAVCFEX/H4e4biOMEL06MM+DJv6WqHjgZEPk8459A8ZmMmnu?=
 =?us-ascii?Q?N2Y/J23wwk1WLGgRiwJmfgC7JQFuh3cR2l/yXdhFCeWvkbEpml4siUStUMls?=
 =?us-ascii?Q?1G/uhtdFJCVekxeUs7DoPkT7gMq8WHL9h5/T7c+DI1aNFg4lopp6cR2Pt7bK?=
 =?us-ascii?Q?kvl7mFaqtSn4T0wX2nBCRQvZU+65NjaUIj2wMwWCtwiFiWaPxeF3wOsWlvVf?=
 =?us-ascii?Q?7YkVQHWuwt4UOtA8SEiGxNmp1CpjjX9RIAZQd9Obr7Qi3apd344SS2H9KzA5?=
 =?us-ascii?Q?5PQ73CFGC2XAVeG1dUzGGYqXkMSP8b+nhWX+avvY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919c1206-f42b-4da0-8410-08dac30bbe13
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 11:07:22.6884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lPihoHSLUV8ME2Nw2+gmyZgjIhhsJmbSKb0TY5cY85Il541gpq4I9gguFqnInYYOwmsgHGtIU4mFS++JALMrqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4369
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> This functionality is needed by UFS drivers to e.g. suspend SCSI command
> processing while reprogramming encryption keys if the hardware does not
> support concurrent I/O and key reprogramming. This patch prepares for add=
ing
> support in the upstream kernel for the Pixel 6 and 7 UFS controllers.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
I guess that you are planning to upstream the code that uses it, hence:

Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
>  include/ufs/ufshcd.h      |  3 +++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 7b2948592c4a..fa1c84731b8e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1707,6 +1707,26 @@ static void ufshcd_ungate_work(struct work_struct
> *work)
>         ufshcd_scsi_unblock_requests(hba);
>  }
>=20
> +/*
> + * Block processing of new SCSI commands and wait until pending SCSI
> + * commands and TMFs have finished. ufshcd_exec_dev_cmd() and
> + * ufshcd_issue_devman_upiu_cmd() are not affected by this function.
> + *
> + * Return: 0 upon success; -EBUSY upon timeout.
> + */
> +int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us) {
> +       return ufshcd_clock_scaling_prepare(hba, timeout_us); }
> +EXPORT_SYMBOL_GPL(ufshcd_freeze_scsi_devs);
> +
> +/* Resume processing of SCSI commands. */ void
> +ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba) {
> +       ufshcd_clock_scaling_unprepare(hba, true); }
> +EXPORT_SYMBOL_GPL(ufshcd_unfreeze_scsi_devs);
> +
>  /**
>   * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_rel=
ease.
>   * Also, exit from hibern8 mode and set the link as active.
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> 5cf81dff60aa..bd45818bf0e8 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1186,6 +1186,9 @@ void ufshcd_release(struct ufs_hba *hba);
>=20
>  void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
>=20
> +int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us); void
> +ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba);
> +
>  void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn
> desc_id,
>                                   int *desc_length);

