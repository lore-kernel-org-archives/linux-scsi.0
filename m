Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A10BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 06:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B23061422
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 06:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhEMGqw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 02:46:52 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:15054 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhEMGqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 02:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620888342; x=1652424342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CU9FN4kJqYuOxqEZ01+it9PU+UOkG0nCuWXILXQbNrA=;
  b=HWkrcSo1mWyrTYFH+IDq/RfRn/5IVIOuSZW1uJ4QdRhzpJwf9iVDwwlp
   uX3jFRz5QU16hT9RbAAoOLa8Fq9v7zW2N9JV5wUKs/BB+pVDOOefR1s5i
   OyZR4x7ZefuoULtCCfMcE5UIO040yqm9AwoNLJ3jFHn+uEW7T7hp7j8/H
   OIPjkElQ95l+dYVBf4caQZRxh1KPZN1jptAmizefy77zqY0NjObtMz0cu
   fEsXtNPIfC7Vr86IQzFHPyt6FrNW8G7jukHijuTmcRveWgMZLQgaPypK7
   YE32H9l/ttLq5DnoFy4yv1sVrq5251UUWiR/3q1xxvXYu4HddwMjiy3WM
   w==;
IronPort-SDR: BenIwCQeFCLlSBu/MMtBkw0Jv2nvXJbw/02Rw8XmEEiBL7yBGNpbNl3ULKLHOxObx40xjEq5yc
 gL2QnmcwizcI2h/ZJGUKDI3IdrcOWQeLhrvQd5ph9tgT0orokOYFW9Eauo8uRiSUKNuHPuFk0K
 zShQct/Kj3gHkLfvuPkye2MGB5tETaaXHJZyTikgRaxETfKE9ita26HRx6vh+cHyxSpC9MErZY
 L+t3YL8HyTQsOa+DAS/3U6abXQ4Fssjpd263edaLZbEiZhmGMOUfT8Jep97n1nT3xcXzmi3DcO
 pOw=
X-IronPort-AV: E=Sophos;i="5.82,296,1613404800"; 
   d="scan'208";a="168566453"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2021 14:45:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F44186RQV+z1Gp631JisTNNlO8fz5Pma+Qz8m2T56eeVDsZUUQOCxzX/7bOiL6Q0vbVlXNN1SHU/okZsUkTHW+vM5LqM3QhdUHB+U+iNcCzOIdw8qIgu6j5UBqJ6X8KTyT5Ur4yYSyj2Wmmtuq2dd50GF/qn+BaTFp/A0bzMKh0VjnH7crfzpnf3VkbOJTrPBq0v5S89CbOYs+/PDoMd5a2iI6zfRok2R4zWJ4oeBhujjsoGda7nbfqo8ZXHA8fJMNgqYWIU5KbD76u8HT5nXCgGHviqa3xWu67QqV5NsZWLr2Bk8cJSCUc/VjI64hptitjfgJAXfYJD1v/d4F47BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+ry27EoqTNFsee6FNEEbvb4/3hNHS3VXiJYAVmUh2w=;
 b=cbx6uOXlavDtP0xYIP2T3jeEFlGYkdx/7muQueU9/095ySKBS39/5lP8Z1x2DB7uRKUnBLCAPg7qRJmbGdaSfT8mTgyUo5hLvcm3sUwW+Y8A9HB4Mi3ocFxSlH9sKmkACSglYr2W9ebUuPnm7G2n00ExRh8SXd0W4SME0zwgXU+HeG3F7oNrDEVTBfKfqAmbYuH7dK3GhthIJW9rvnhq3P8Z4aYZ3r55gLSqkICk7H3XZvko4dW3Dt12yXtF967fMy8wE+JuM2jzXquP0l6Xb78OR4NqY6YbewBKWPDN0/5mDHLzSi5djO5NTiacKwVUOHP2CogRVPrztXu0BhyKWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+ry27EoqTNFsee6FNEEbvb4/3hNHS3VXiJYAVmUh2w=;
 b=epox0nHDVLrTKZRe7fZ4FMmmIPdVOnpvHF6kdvkiiqU7pDgeXDBL736mP8wuoIK61Ej2CLePiSzkdNPXjxzVqeBww1gABwA1AASrvNioFOgORWq7+e1uq5JmUxBvsUOjyIOPOZ0Dvuo2mPPDTkKkubvp1+A12YA+lBk3axoWGPw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (20.179.166.71) by
 DM6PR04MB3897.namprd04.prod.outlook.com (20.176.86.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.24; Thu, 13 May 2021 06:45:39 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%7]) with mapi id 15.20.4108.031; Thu, 13 May 2021
 06:45:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>
Subject: RE: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs violation
Thread-Topic: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs
 violation
Thread-Index: AQHXRxX/qO2IQ7o8EEGQnGwyYbUniKrg9p3A
Date:   Thu, 13 May 2021 06:45:38 +0000
Message-ID: <DM6PR04MB6575083B2B58587AC14B6F9FFC519@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
In-Reply-To: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 461b15df-2a4e-4358-fbfe-08d915dab86e
x-ms-traffictypediagnostic: DM6PR04MB3897:
x-microsoft-antispam-prvs: <DM6PR04MB389745B9106822E8839B9D8FFC519@DM6PR04MB3897.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:115;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lDb+2sxWxIJOFAx92ubVN0bCmv3YAGNIaOIVDlzBApA7iSzOwF7vLRAyqYfBe4xObEqwWLPGnqB0+wrC9p2Y5qgHRj+3mSxbQVhJROIqUXKmxLYkigGy6PpzvtRt+l0olvvVgGPTV6jsN3iDjk8NMy3ZctZwD0HFnNxBc5qousiu0yfTgmuI7vszAK1mH3EAkDdAqLwQFPaWldAMyKFGR+VIQH9rKxL3EYwGZa4HBU1oYzK4BIfzeJHODTB9Xs6hV2soaVhkOY5EN/gkBgN9diwc2kwz6LCyCnI446uh9CKvRf8LfMCCkRr7ca5JABTSiKi3msEshbP4Om1+rhGyo7BlivOL7QZzUEv7kFYigZd5Vi1U77HMm9GpI78hm/3I0lnlIdh/5bVRd2+v02e3XhSmg31HiuJUmlcngFYDyPCw52ap7zuys8QKU2vXcUSUBBtAY7ag1s8UNzON/1UgyLM9VSYsOpRG2/R0vKLqZaoD/DJegtLSR4Wks0pITrTX148zIRZ+3ZDYFHaHlA24mhmlv/NOWd6bkxvEYycBH4GPmYAocJbS28SHQ3MqyMdXT4B42OXiNAz7ku5Tgvzb057KoyQt2DUzj90sLzLZz1E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(316002)(6506007)(7416002)(186003)(110136005)(54906003)(5660300002)(4326008)(2906002)(83380400001)(26005)(71200400001)(38100700002)(55016002)(66946007)(9686003)(478600001)(66556008)(8676002)(66476007)(76116006)(64756008)(66446008)(52536014)(122000001)(8936002)(86362001)(33656002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?u2CcR7CsD/xlT7X3skJfpcED6DmgqTrjsyC2PoYi4hrqxWGGWWaPy0WQErmq?=
 =?us-ascii?Q?h4sdWyu30tkuQpZiQA/QhwgYLDpjdv6Fe+Je/Cjq89giD5mJFvjxnPJJTlAa?=
 =?us-ascii?Q?RBoCxYPTmQJaEVnkDEqBThFmrs74mXqqd2aIYWFZDMQtxU+9YuNq/Eu9GDHu?=
 =?us-ascii?Q?2VYNT9sTBy1VXmhd7i7RkjkFGDT461h0VU2GUsS0O5GdNgDwZuX3JffckjI9?=
 =?us-ascii?Q?GKcEwAxoHlymlCoWaDF8SOyCqfbUlva0M46XoP+s10rp3U+g2TH/ow6/EuhF?=
 =?us-ascii?Q?MSp33odDzuDWejqlttx9BUiMBHotrlBHFhrSye/BxWOk6eYSpsNhNU8HHbnJ?=
 =?us-ascii?Q?yqMW8uzQczbDefJIq6skrt5aLdPuFuGCUeOoxy1GtN9t8g3RFojYQT1IBQnW?=
 =?us-ascii?Q?yuSzqX/s2I4z/zKfuoPEZ3Mf08DG5Ij4jboNeWbBBghr9i9VcmXVibUh8PR2?=
 =?us-ascii?Q?QUu/7Oku592PN6Vmafp33zgBmsHMZJnMbbGDN9ylbukKSTwzIFL+QPcUad9s?=
 =?us-ascii?Q?ZDOgajrQO80pUpSRQWCBfPOJUphRuhMBkwjO8NPQtDcG4DquY6/EAJ4WKiZx?=
 =?us-ascii?Q?NGMY4DGNGTGjFkuLjY6pZn5M+sUTgcy9O24DOZ1urw4PQMg0FPjQS5HoP77P?=
 =?us-ascii?Q?lVGfvdSvZWmvR/gvS9apOBQMrfeMKv1APPH/7yeO47pI7rDCEkeRy7bKvzhe?=
 =?us-ascii?Q?1zaJ00dhGXxChWtESztAg3YaTibjMjxMbAKtv7GkZnX+uzB/HYZDqo1+9IuX?=
 =?us-ascii?Q?zo7lNyzjOlYc2e0gTiKpiEedx08S+6At4NuAavwpV2Joc56BqfqI1WbSgDeN?=
 =?us-ascii?Q?FqzgzrYHfIT0NZzIn/fR+DXVD1zU3udo3c9FeN5LR4BnUAytkIU4TJPBkjGh?=
 =?us-ascii?Q?fO6e3x0cNSJJhvr93MzjJ+lAZoL6ZnxZ7nul7M/K+T/CLpOJrs3+5+MY1jVS?=
 =?us-ascii?Q?a8VITPPbvkBJSv09nvXdt2FpIKjuJjuH5WOKfYBJhrFhsH5HMtuAb2nIR85x?=
 =?us-ascii?Q?tLJC08zu5aXwu3LRVSZpeS41jgl3Qq6HJ031deKm9wE+1IivXt3ceeT78bZN?=
 =?us-ascii?Q?MZ5DVjc1oI5fEoQIqcix9zqBp1p/B8blj/j0IblJCu8kntqhZGp8Cf1UHYV/?=
 =?us-ascii?Q?gtAdf3OIzkw4SKx+rEqHPYOYjGIdj5EFfQ8mSqme12awOjq81FQF9Qe2OdJx?=
 =?us-ascii?Q?0zMG/HabQA+/XPP/4ocWrvlTVRF8PlwbejxtpG0lzA7VHAdSXZxapfuVUExW?=
 =?us-ascii?Q?HHWI4S/M1VarwJmgZN6H8aemjSE8yQ6B61JMZqMdzde6Fs9qc8JSZfAcRJ0g?=
 =?us-ascii?Q?wwyNtAm0JyXqXQND0Ih6d1ie?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461b15df-2a4e-4358-fbfe-08d915dab86e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 06:45:38.9581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U08SbY8OXOjy7PCAO9kJmVN6BkFkG/51nuXxfHSW1SwV0a+WcVmH+v5cERvSUJ6QY0pJzZA9qyjpLhcozV8ePQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3897
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Peter Wang <peter.wang@mediatek.com>
>=20
> As per specs, e.g, JESD220E chapter 7.2, while powering off
> the ufs device, RST_N signal should be between VSS(Ground)
> and VCCQ/VCCQ2. The power down sequence after fixing as below:
>=20
> Power down:
> 1. Assert RST_N low
> 2. Turn-off VCC
> 3. Turn-off VCCQ/VCCQ2
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c |    4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index c55202b..47b4066 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -922,6 +922,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba
> *hba, bool lpm)
>  static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
>         int err;
> +       struct arm_smccc_res res;
>=20
>         if (ufshcd_is_link_hibern8(hba)) {
>                 err =3D ufs_mtk_link_set_lpm(hba);
> @@ -941,6 +942,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>                         goto fail;
>         }
>=20
> +       if (ufshcd_is_link_off(hba))
> +               ufs_mtk_device_reset_ctrl(0, res);
According to your commit log, you should call reset just before=20
ufs_mtk_vreg_set_lpm, or turn phy off, whichever turn off vcc -=20
Few lines above.

Thanks,
Avri

> +
>         return 0;
>  fail:
>         /*
> --
> 1.7.9.5

