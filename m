Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AD9C4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 06:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7239460EC0
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 06:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbhHDGir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 02:38:47 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:16860 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbhHDGir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 02:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628059115; x=1659595115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nYxIV+NBTCWjTLi94/suldUwke/rcH2VdKHKBGrlzvU=;
  b=cMCtF8fRszEP3aLVEqpKcQAi6Pjrh27E9jiHYNyJtHSs5chSvQLw8FR7
   2bnga9lGVHhbXntE0N2CyLJv6TQrX2e34NRrFaD0kX5qS+ynqVSX8t+DQ
   PSjG9MsdsEReZkLJJ6r5JYtJIs3YoIqYdw4SZtlaQoQmTtQcwftID1DFv
   17+HAV9/cb8Q6MVBOdzLHHs3/bCyCKpbS0bFStAlmqjU0h25x7n5cq5vg
   gVhFIr8ywBGmZ76/TvFuJQ45cYbrvxOYsJoYg8kiKBqFQWFLeGT+MK3pn
   uM4FoW0H+QyyKw0NUOeGOHxDqaXyDWZSVm9b3hMmjUUDOywMQafR5mOJH
   g==;
X-IronPort-AV: E=Sophos;i="5.84,293,1620662400"; 
   d="scan'208";a="287839708"
Received: from mail-bn1nam07lp2049.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.49])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2021 14:38:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gn57vCetV8R7vywyjMT/Qp+cW/tllZo/MZ47R9aRHWmNfE9BftVhwSGIFd4yts29HSV5Adek7pxvWbCqR6mHmFbdO5pFy6zFF+E4d8IvEAIFE/36ejXYilGy1Iftsscvsv7A9iYKOvWjpN8toRKlq+9ddJUrmeAnEZjJUVvcln3b9NJsm3UeHtIYlIaMSV1hKz/vm4XTfMraDkCqqlFEIMZNRnVNzaGV0i6XSgqVm5lgL5tro4JPTzmuI2lUbjCvG63SFxNVnBx+wjhWYpZWpvkroorEw90KXmF1AB9rJQj2EJF5CBYm57Q3yHzyuPGBRPSxlpkK6u28zq8ABSZppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0ozNMrXhhH/izb5koAe3YDb71giXKh8i3Kk+PS/Yw4=;
 b=ZycObIdM2CdMmq7qIpiheyCe8cJe9Y2lnxvtySSIp9ZzGO+uEDbWDzXTc/5ehzksrgYY3L63O5LpJKEhn590+2IVOg8ESyapSRETjY8LS9i21MiTWhiKE7usM2mUdPnd7vwe4fDaeMJoUYT3XosNrLAwBDQK/zKu0cnNUmIf+xv0dd+UpOUdQ3i8JJKEaShS4JP+z2ZP/Mda5fBMwgFuUsRze8g/8S9NJnA+K+h7ntiH+0QrPONiZNl5sW8R4MBIySchm6tpCs6nhuMWH0a4+S05I5pdc6rg6rNU8Nz1FNbVwmyiEVn86OJWxcYJqRHXqaHt9xISI5SfDfoXYtVVEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0ozNMrXhhH/izb5koAe3YDb71giXKh8i3Kk+PS/Yw4=;
 b=HbNTCQ02IoPH573k8eC5CoM2WFyhW3CQi8z7WCxS+PMrC7X4/P2KO8JZYhtud+Rdu/eiKlFsgIJcbstu3UGm72pY76ehaocF2357goo8SpYl7cRVjayEPXwvwmQtW78JVMR0belZjNXKqO96UzCVCIgZiPoMeAnzyyEES+d1Lkc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6589.namprd04.prod.outlook.com (2603:10b6:5:1ba::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18; Wed, 4 Aug 2021 06:38:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 06:38:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Remove useless if-state in
 ufshcd_add_command_trace
Thread-Topic: [PATCH] scsi: ufs: Remove useless if-state in
 ufshcd_add_command_trace
Thread-Index: AQHXh8ld0Lx2t1dhZ0+LdbWRaSJCIKti5lcg
Date:   Wed, 4 Aug 2021 06:38:32 +0000
Message-ID: <DM6PR04MB65755981B606ECC00D1F198BFCF19@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210802180803.100033-1-huobean@gmail.com>
In-Reply-To: <20210802180803.100033-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1208a3f-71c0-4c29-6f5c-08d957127a96
x-ms-traffictypediagnostic: DM6PR04MB6589:
x-microsoft-antispam-prvs: <DM6PR04MB65893FDC2985097BD701B8BFFCF19@DM6PR04MB6589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:415;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oJ+Vp/TvtGsuUOi7m1Ii7wmGFrQe7RaRbDKKPTH+kG55yCwqX8dxXBxs6gWq699Xpzq/KDgCMBo/Xe9kt9rmsGzV88tPcj04iz9LSylcqF+bWRUEEMysrrvI0ObMY5Z4qGkY4CGr2kjp7VTVc2NzrPymGewShmbETjMNPGHa0SbgRnAAaK0e5Yl0l63tGs+wlByO+Ri6q64zjbWNzsTndkb/qM6rqFKQPRHdtbNyXI1Nbf1D7bAUa/7Paz/TC2swvFhaI38LjZbGgdETVNfJYAzNKQss/88sYc9nimbj09Jfo0EO/Sw27o+sptSSa7EwsJE+eZj8p1sZcUbsS93tgxJazajM4n6E6DtiDser7ljHkJ5ZbrsvpT2umOlGtHiak5hqTN5ayI71TODkTrq9o7/nSqpo5590Xllc312VFaOe21L0pI2etKNwJalfDKTW0Z2/CxB6ytBgf4dlKm6rR4uATJH6fEFWhjiyUdIjPwTRFEAJApWUwkZzNGyguS/9Um3pP0egdRzFttU6QiIs2WzpR5UXuaBiPIQoh3e0W5MyCi/Xj3X2MZDDTXl0jDpFrbsY0b4CuihfxBC1NX2cG9p4+3YkjYLqp55PRY4NQXLK7qs+pS3muXtWTFSFyfqjoEn8WZyJSGZxtCTTIoUIrusxoot2m4VfE3bKA/AkDojxV+Pg4x/sroZpiVCULxN+WfnFtqCnDtlq0ckzRrdTJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(2906002)(83380400001)(478600001)(7696005)(8936002)(110136005)(33656002)(4744005)(54906003)(76116006)(66476007)(5660300002)(8676002)(66556008)(66446008)(66946007)(4326008)(64756008)(55016002)(26005)(38070700005)(71200400001)(6506007)(52536014)(186003)(38100700002)(9686003)(86362001)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A/rAsMlJYJf1H3272KjouGAAnCAq8LtlGojaxoKYvG/BeVLK4sw53T2mALBw?=
 =?us-ascii?Q?jrtR6URHcbaethBzdCi5WNlE2vUe8S/5pFrXAZxX7m+zuPUhXujK3VnVM3Zn?=
 =?us-ascii?Q?qSCmEowIG3SbbPSDQoNEmmTb6RM//rQZ2P61nmiCD5U33rXcgWAwpeL2Ah+v?=
 =?us-ascii?Q?6I8U2G8T/dTHGPP5AVPR74djnAoKN3QLfslS7yrSmxM2O6F3pt1rCtOS4b2k?=
 =?us-ascii?Q?vMKvtsZeMmIVGgMSoNMgToZ6WalZ4VJkP0PyxV+oM8kI0kBXHNPirgr9Mq9d?=
 =?us-ascii?Q?ertNktC55OY8JJcyEyA52XDC07epwHkX0jQksOLTPrQ/5EdfpTTUJ34op7QT?=
 =?us-ascii?Q?FeKrRVJS2KJQp4A8HdowBlqprN9uFq8q+N9aYKzPIP3JHeS9cCDZensQv/LY?=
 =?us-ascii?Q?pzZmZrgXCdTmtCzMGxLQEbIBYNB5qhVFXoLyJh2TQXUFccENJ/VZS65jbpXX?=
 =?us-ascii?Q?wq1rE8bCareApsUK+Cr0mw0X4Xr3t5H4NYIh8SFeuVaz4vIIzomRIjrUvH4V?=
 =?us-ascii?Q?Vo1+t6ffIRNDVLRpa8B6ywl15KL4lQwPfso9W1fU319MnFSzxESq0gjuYQyZ?=
 =?us-ascii?Q?+GO3Tak6VJ8XMuRDt1xu1Hb6Q7GMe+O2/+AcuslON6gPiIp65kp4i8+ReBuU?=
 =?us-ascii?Q?zbNd2kl0L3yabH88jYI2LxEdvJzuCRBmXnaGNFqIOdjCcIt373GwbdWL184e?=
 =?us-ascii?Q?7XmWCEBnjyXmozCgSlr2QG/Kjo0qYPOk0SSTkEpm11pm1W2lC4U8vj1nkTMg?=
 =?us-ascii?Q?X4EFwFDxDHyrAuBO8KdtgXkZ54FpSWtSTnysHWuUzaNsFFuE/PcdSp2h7xMz?=
 =?us-ascii?Q?abE+ZIsJpRKVFbuTzkmFHrXWKXAmlNuFwC81jEYiqmpldi1oMn1My+wBSTYN?=
 =?us-ascii?Q?In34HiIIfVnHDW8b7QLPwu2UnLrDBJRk0k8xyxWU0rF8ZxjIHC0AvfF5yU32?=
 =?us-ascii?Q?5Spue9/SVN8Lpp4y4GIIT32jKoVhihCFmeodfM6nX5bHerm6R7gvpOh/Ws4T?=
 =?us-ascii?Q?mmDs041bGbftJtPS4QLVCjl7pwFPZWwP7IDEpS6ItXb1abICcrCOuzF4G6vW?=
 =?us-ascii?Q?vXSWBatvAFetJo4Hx4HwcnHerYwFkw0ag/BF8QPlfgE77kxgduLB0RaYcCbf?=
 =?us-ascii?Q?CUKkJ3s+JY9Mri7b3kpoAqGbqEnR4UDD7epyzkfkt0CTvLJEclaF6n6eN7ZU?=
 =?us-ascii?Q?eo8dnqqD/3J6j83OwRCUfC4dyFS+fsy+CR0P0Q+XFA9/jrj88tu7gsQUeJXn?=
 =?us-ascii?Q?vlHKk0TukAtwl4Gmk3YazYnsXHIzWlzyHEg7W04SLtmUwCzm6TQ6lTTzo+eN?=
 =?us-ascii?Q?e8MI8brWQoosAIUppyorHC76?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1208a3f-71c0-4c29-6f5c-08d957127a96
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 06:38:32.5550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rL2lgI++KsgE/UAOj5xigtiA4rDdE3KfZz67zv1kxEIRJlN+L6ZfCFxqJGghikjU5Ut8rGwPPWKctT0EphKuCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6589
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> ufshcd_add_cmd_upiu_trace() will be called anyway, so move if-state down,
> make code simpler.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 064a44e628d6..02f54153fd6d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -380,14 +380,11 @@ static void ufshcd_add_command_trace(struct
> ufs_hba *hba, unsigned int tag,
>         if (!cmd)
>                 return;
>=20
> -       if (!trace_ufshcd_command_enabled()) {
> -               /* trace UPIU W/O tracing command */
> -               ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
> -               return;
> -       }
> -
>         /* trace UPIU also */
>         ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
> +       if (!trace_ufshcd_command_enabled())
> +               return;
> +
>         opcode =3D cmd->cmnd[0];
>         lba =3D scsi_get_lba(cmd);
>=20
> --
> 2.25.1

