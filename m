Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8E6C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5404C20707
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BtM+4fLs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ndD77+6x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgFOHNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:13:12 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:5221 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbgFOHNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 03:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592205189; x=1623741189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XrXQePVHQh8XpeC51qYFRMHa2ZO4E84iBpr4QqIfKvE=;
  b=BtM+4fLsw95GPQV85Bhvjmya3rN0VEUN4fk9Bv8uFIS3BKv/IvNetDeE
   ifpJiaL2Zo3dfN+YKdb/YI4H24/s9BSHDDi0oxdtVnwvn63tznwd02blZ
   G2jjjdPw9VbHl/tn8v6YumhEAm37nWWBH7SEwair24WLQOh8Mp7Kg+gzR
   TKrYO/TSIBsZz1n0bO3lJXvuZ2LrNEA9WgpxDuqZLtlTa1dlOjCkmq3qa
   OMLVZoHnJoxJoSwPnEtouYG7tSpzgakHYv16WbT+1Vkrmnsjdaqukddkv
   qHH68nuS5tmcxaRmgrWaFFktQpgvv8bWMM0V/5ZkK7WhPZFSUn81hJaSK
   Q==;
IronPort-SDR: V6F6tanRWsI22vjGKM0iFubq3FktLsSqdLJ5gYxyyVJmIWq0GwVYEOJELlvfbHPdzwCsYXVtXy
 9XvO4zVy8uil30Rd82oysPHLUwzwu3Ik3usCM30n69whwIJIgc5mWsk00anwMgek5+jI4L1T0n
 fTYWTlTy3NCSBI6mk6mHBVsKeqtat5I4d3+WeSiyMzc/DMerJgMYYfDnwigY8gOHQyTFE/n2cS
 Lu4PQ7pBWMqY5TMqmvEu45xl8bu3Apq94Lw7ExtKKYOOMWpq4380eBCdOlhGx3wjUug5OtaGTd
 0Ao=
X-IronPort-AV: E=Sophos;i="5.73,514,1583164800"; 
   d="scan'208";a="141394461"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jun 2020 15:13:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccoDHVjRUDPmZkSvo0yDV7zuaYlgVtxTTqKLkdDoC8Ie2e6EG8F5muJz+mJ4mHOMB7AHRnSEqFeDPLh5eAVTWojmsQ66pzYHNrq6+xWiZa4yXZuJf0+xgVnT2IEhhyl4fxu98orRFH9rJEhENCeM8lMPkm4WovtW5LK8cWR9HY/sqRcQPFymgLtqE9PoU9s8gpGZs2zb1Nj/87lbSKmb7IP/WSOv404xEepfjw6rt6gB/0rYp34BpzXW+pIYFK1EP+m0mG+IjObQtGY61UPZQBgOg696Q5TXRrrRo/Z6dF95SKJqb99ZRs5voosxaN00sJNMaKcSlqYVCqz12ZVwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDjza1bFlTensGY0L822yDbavh470DuLXjk7QvBLp7s=;
 b=XKSqKxzVLfRsKqY3kL6wIYd2z9eQ5EFB1m9eV43Y16QgIuVTy3OlHwO+t2CULEk8+czL8dElI+baqwaegY7g8wvImyFdcil37KvFxAy1vUsLWj6UzDFUs6B1UMc1DVb6OMBPyZ+Wi42XaBf1/OroiP/cDIycGf5N7wlApstCUTKFlI5fPlvQjOvURoDf6OsnHc1b00iOUplv7tbXSefobJjHtywsqzh0OO36x304wzEB23DQfdrzXS1E/teFkS0DjjTFux7iAQdDaXjvxKZ9zuD9G2IMobr5yRxwAGNozgYjF3h94V+d+K7HLJDNnm+99chdo/uTsXVIr3K1bojF2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDjza1bFlTensGY0L822yDbavh470DuLXjk7QvBLp7s=;
 b=ndD77+6x8Gj9/w5HTom1w8yIrV2RDO647+/TeYuhMPRYqqedl/M9kk6dYumE7zUzEr0YgRXwf6meF4mYIner1GYLI1c9uCwKZsYK5pEEN02vlVOPVZcotgbSHK0//HL69Fe48VUSSLyG1QK0Mgulni8H3fApPQEcCLPO7aa2FKw=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (52.135.119.19) by
 SN6PR04MB4574.namprd04.prod.outlook.com (52.135.120.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3088.18; Mon, 15 Jun 2020 07:13:04 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.028; Mon, 15 Jun 2020
 07:13:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>
Subject: RE: [PATCH v2 2/2] scsi: ufs: Add trace event for UIC commands
Thread-Topic: [PATCH v2 2/2] scsi: ufs: Add trace event for UIC commands
Thread-Index: AQHWQuDrRUZ57LvD6kiE43KBKdsIrajZQg/Q
Date:   Mon, 15 Jun 2020 07:13:04 +0000
Message-ID: <SN6PR04MB46400CE00A5CAF16CE4D4367FC9C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200615064753.20935-1-stanley.chu@mediatek.com>
 <20200615064753.20935-3-stanley.chu@mediatek.com>
In-Reply-To: <20200615064753.20935-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1ea8bc6-3310-421d-90dd-08d810fb8c0d
x-ms-traffictypediagnostic: SN6PR04MB4574:
x-microsoft-antispam-prvs: <SN6PR04MB457447B792F0ED634E2F58C0FC9C0@SN6PR04MB4574.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 04359FAD81
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eizy1Ex9jEY46HVldKsKB7r6rbPtlNTxkYHKq9KlhDiyC5Hxy+5kyBLZIcG3XstvXkI/RZm4c320gzOw/qm1qU3u2UalKiwHOLCw6eCPEnx6d4RvphVs1gQIaybQbAQF5ldNQvGWPYecvgeZXTpmss/TVO1FC0UqGqHXlXmoTBExp3FvFf76TS8sHwAbLfg5zMx9RMmNa75JfF8fX8PuJd4nYs6Si3AM6GurwaDVPV7M3e0XQqS+8slAt6lEGy00X0EzPUuja+mbBB60n4nqbV3AZhb5Fr2cHIzdHF/zniFp0uOrsUS9to6qpGS69o8ED1r4L0SzaaTaB8VL4xr9eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(4744005)(86362001)(7416002)(9686003)(52536014)(5660300002)(55016002)(4326008)(478600001)(110136005)(54906003)(33656002)(316002)(2906002)(7696005)(186003)(6506007)(26005)(66446008)(8676002)(66476007)(8936002)(66946007)(71200400001)(76116006)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bDCGYeHlK9I0yEPEXZG8XcsMyM7h102qMEcxN4AIEgVh+1mmGwulJFzn2VL+QJfjjDLGKefG54oqcVNDvyCmikfUd/hll15XHyIs1CqAAvw73RcWzxpYHxE4kimKL9f8t8F4yQUzWNPHPQd2Z75gIUjaO51N9/aM+Qx977U24oFE4DFlIC/zgR9LIBxp8Gl65D94I5t5I7cjQvefQ491c5sZ4GpgaiRwC0kavnoC2xrMyE5Y55Alffw1smsv9Yvorxz1M03t/XAbJbolUO+v+22An5xVIX2n+FPRwWBKc1rCMNCEa91kdBxcHBTJHrXoc5IiWngnLz0ceixMqHvl1O/cqaohM2lPqLhnTqxsry4ziwxWOuwsK54W+21+vnvFNWhoG5olRJctTMe6F641Zg2JsTGILZ4L7Ayt3By8DXnpWpfcyXHYH+KFxih2D3FNKZBMUh3Kd7jAoOjHQdbb+YCu4rdEX65YnqlOPJpQCX8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ea8bc6-3310-421d-90dd-08d810fb8c0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2020 07:13:04.4060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CYUqtGUueEYCxrSz2Ykj3KVC+FXeAOQ7jUWkGN5ZqTr7nb1B9dN2uOrkf6OhEDsj39Ki7dmd61/QXBqWk6aqPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4574
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>         /* Write UIC Cmd */
>         ufshcd_writel(hba, uic_cmd->command & COMMAND_OPCODE_MASK,
>                       REG_UIC_COMMAND);
> @@ -4825,11 +4847,15 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct
> ufs_hba *hba, u32 intr_status)
>                         ufshcd_get_uic_cmd_result(hba);
>                 hba->active_uic_cmd->argument3 =3D
>                         ufshcd_get_dme_attr_val(hba);
> +               ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
> +                                            "complete");
>                 complete(&hba->active_uic_cmd->done);
>                 retval =3D IRQ_HANDLED;
>         }
>=20
>         if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
> +               ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
> +                                            "complete");
>                 complete(hba->uic_async_done);
>                 retval =3D IRQ_HANDLED;


Why not call ufshcd_add_uic_command_trace once if retval =3D=3D IRQ_HANDLED=
?
Is it that the exact timestamp?
