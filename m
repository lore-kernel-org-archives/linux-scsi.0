Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BF3C49ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 10:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B12920CC7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 10:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OwwDoQHB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m4WBdDif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfIKKyZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 06:54:25 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61323 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfIKKyY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 06:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568199263; x=1599735263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CC5Exy4T9LaRvxjoABr/mypGNon/iZCItGGBQ0rk6z8=;
  b=OwwDoQHBukHMRX2Ki4jf46CIJH3kolT8yhv2T/mIC2YOWpXJRxUpVqLN
   SNp/JBlDfmbZE2uKFx4DgYlYO1TShCRlK+ZrvdmjQZkbvzjrY0RIpeE8Z
   P7GgTI9+cPh0n9N6XEJ5uukF2UJbxJ88kLcQh3ifXOTX2i3lKgF3TLwaa
   4PNabhxk183VZj/n0sW1J9s1C22Ucez4gKjZb0fmcCwmpnDsw5Xd8oR5D
   Oh8EjkFBqr3pr+NGy8YKhyiR+hGMmZOAZbD5j/MGM+f7t98M2BJAJ59Qe
   4nvsvfaTuoWdsd84/OfAIErGcS+zzaHoAt0YnbB3EuXvlmKQFcufJppK1
   w==;
IronPort-SDR: 4hk014VHGqBGxoNjhObQGXJCGqKayN8az8Miso7rfwFVvqAz5/NQA+ZrcRFHDQ7YFsd5X15fpW
 SY3IliiMG8aTMNXHOEslwShPTnZhN6zT2bXLpYcI6YRZeyFlEDCBAtRrufSom/Is0GUhJ2l/bA
 Au0zjvy5eygkLZoI2ytjTxs0iOnZ+4SnidkZbQp/QV+q9J2pcx01gsU5F7HZYQaqSuyHO4tpO0
 zlz7lAJmu9vddpuImsI5RGMO8hGk6SLBQArrfbR1WRXh+G7vxD9WZG+fvTlDz5fPgRH98auefF
 fnQ=
X-IronPort-AV: E=Sophos;i="5.64,493,1559491200"; 
   d="scan'208";a="224766953"
Received: from mail-dm3nam03lp2050.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.50])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2019 18:54:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxPLFHlumpsVeBFnaWBrp5A3yCCtId6NdpJwOgqlF33hG8zBNjUGep0bmp9dNUJbgBhENIAppE1ajh/Em064hVw6aGGZ+k9jJjvzeTna3LKMk/WoMz4gX1mWcURvUhfrjO37NH8JgKs6zg046ZZvy4mXlWs1BFK2vKbpKl9s9o0NqamPA8aKqRbUNuWBB1NVUHnNrt+oTCd0UWxplxmQ2bI/AuLJSci+Gyk2zXQK1n3PjhPKmj21CgOSqway0f9qqXsM0cLN6lfxCah+IDLt8n7dyimUjJQq+/ciuk42uf/mIJIwYYT6cbqqpEkUirQELjIRgBhxnnVzEkvPolXAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHAy0cSNAo2jAHGV6U2gtiy1ENaUb71RqoSnJG/QWqg=;
 b=Ygwpf+zicdTwTT+ny/Y72CZvQEDZSBYJzIpeGOAREh+vzSpmwGinT93ndiEYnhrhuk3oe2ll/Edoug1SjoSd8cmQeK0kpJw3prvd6Dma2ZjYKPpMIg+qoGkUgz0PJe/4/tBbnvFVmZxL+l76xSuucpYzxps5yHuD0Dpf5a66YCGAo9rhBW4Pe2XmhHpuFF7cYSzgWxIZvQwyeIrhKc5beEuHR+n3Paut5/Y2rwsfffvg62q7Eu1rRzyO2Eu2orcBOgQuCG2AdAWkfIxno/Yqkj/4cyRHpTzxs/9aLcRTh6EZ6OEmMur34ve/omSyw3T/S0kPmJCwdqGiTdCftIUKeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHAy0cSNAo2jAHGV6U2gtiy1ENaUb71RqoSnJG/QWqg=;
 b=m4WBdDifIFofv1Lp7FgEU+pybaxLr20YHKrnB/MmTMB+jbUvHIqISpxgcfUXQQaCjQ/aY6GWu4N4J81Ov4eQAl3BkvlktDRxndZBVjtuqdHSYbruwjvFLK9/q4pTQpM4L0p2UqkZwdAEFNiBlS8/YVfjhmrpXHGdydhC2JBjKTA=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6942.namprd04.prod.outlook.com (10.186.145.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 11 Sep 2019 10:54:19 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371%2]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 10:54:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 1/3] scsi: core: allow auto suspend override by
 low-level driver
Thread-Topic: [PATCH v1 1/3] scsi: core: allow auto suspend override by
 low-level driver
Thread-Index: AQHVaIUe6mw6FARYpEWAZdvT+2XheKcmTCSQ
Date:   Wed, 11 Sep 2019 10:54:19 +0000
Message-ID: <MN2PR04MB6991142450EEF05E2AF2D8DFFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1568194890-24439-1-git-send-email-stanley.chu@mediatek.com>
 <1568194890-24439-2-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1568194890-24439-2-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0e7c1ff-ae7e-4e0e-8210-08d736a665ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6942;
x-ms-traffictypediagnostic: MN2PR04MB6942:
x-microsoft-antispam-prvs: <MN2PR04MB694269662AE31EAC67ACD611FCB10@MN2PR04MB6942.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(199004)(189003)(446003)(476003)(81166006)(81156014)(6116002)(3846002)(186003)(66556008)(66476007)(64756008)(66446008)(229853002)(76116006)(4326008)(86362001)(14444005)(8936002)(66066001)(7416002)(66946007)(8676002)(256004)(26005)(76176011)(55016002)(7736002)(11346002)(305945005)(316002)(53936002)(9686003)(7696005)(74316002)(71190400001)(52536014)(478600001)(486006)(71200400001)(5660300002)(110136005)(54906003)(99286004)(2201001)(6436002)(15650500001)(2906002)(33656002)(102836004)(6246003)(25786009)(2501003)(14454004)(6506007)(48284003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6942;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1ac9yrnLbR8YwITZcvQXai+DYDl0KIj4uwH6Kzq015rpOFrXz4XopqxCGEIoxvi33fvL9gBaGyE/0+JQsqBFvdAWV+xCIducxs1uVb4tkoyBGP6sAhXGYzu76Kwptai961f6FFM8i+m3MeZ8VFumsdKIrc1TaH8ffSwNvbfR52at8aZfMhLmW1DSEykdXVzgTdRH8X4sU5JDGVe87GhOb/lEOuaqqFvAFIzdZtULOE4854fy9Mj4Os1Qovwpu0Hfzcpp3CmEOJyZAsypUu477sZZAb51FUNfJ+t62B3OteYgJsBONtfrlwsGIkLI2LIC5M+Pqr8vsC2qkF5r+7MzIBUXKOnCZK7uYqpvwQHHU0fjQT84UQ0j04QFConxj+n57G7fbX/x6RNjopPNHP5dbIegUUwmW72M8SYGzLfl0nI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e7c1ff-ae7e-4e0e-8210-08d736a665ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 10:54:19.2418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNDtkN4UAD2Q9SvTR1316Tj0RAyZ4b3ZhUxWdRg8z0CGYXV3Y492UVtaZohVJOWazw31q1wEgLpmo5+N1dcPDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6942
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Rework from previous work by:
> Sujit Reddy Thumma <sthumma@codeaurora.org>
>=20
> Until now the scsi mid-layer forbids runtime suspend till userspace enabl=
es it.
> This is mainly to quarantine some disks with broken runtime power
> management or have high latencies executing suspend resume callbacks. If
> the userspace doesn't enable the runtime suspend the underlying hardware
> will be always on even when it is not doing any useful work and thus wast=
ing
> power.
>=20
> Some low-level drivers for the controllers can efficiently use runtime po=
wer
> management to reduce power consumption and improve battery life.
> Allow runtime suspend parameters override within the LLD itself instead o=
f
> waiting for userspace to control the power management.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Stanley hi,
Your series looks fine.
I added some comments/questions - feel free to ignore it.

Thanks,
Avri


> ---
>  drivers/scsi/scsi_sysfs.c  | 3 ++-
>  drivers/scsi/sd.c          | 3 +++
>  include/scsi/scsi_device.h | 2 +-
>  3 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c index
> 64c96c7828ee..66a8a5c74352 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1300,7 +1300,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>         device_enable_async_suspend(&sdev->sdev_gendev);
>         scsi_autopm_get_target(starget);
>         pm_runtime_set_active(&sdev->sdev_gendev);
> -       pm_runtime_forbid(&sdev->sdev_gendev);
> +       if (sdev->rpm_autosuspend_delay <=3D 0)
> +               pm_runtime_forbid(&sdev->sdev_gendev);
>         pm_runtime_enable(&sdev->sdev_gendev);
>         scsi_autopm_put_target(starget);
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> 149d406aacc9..2218d57c4c0c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3371,6 +3371,9 @@ static int sd_probe(struct device *dev)
>         }
>=20
>         blk_pm_runtime_init(sdp->request_queue, dev);
> +       if (sdp->rpm_autosuspend_delay > 0)
> +               pm_runtime_set_autosuspend_delay(dev,=20
> +
Redundant line ?
> + sdp->rpm_autosuspend_delay);
Don't you need to call now pm_runtime_use_autosuspend() ?

>         device_add_disk(dev, gd, NULL);
>         if (sdkp->capacity)
>                 sd_dif_config_host(sdkp); diff --git a/include/scsi/scsi_=
device.h
> b/include/scsi/scsi_device.h index 202f4d6a4342..133b282fae5a 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -199,7 +199,7 @@ struct scsi_device {
>         unsigned broken_fua:1;          /* Don't set FUA bit */
>         unsigned lun_in_cdb:1;          /* Store LUN bits in CDB[1] */
>         unsigned unmap_limit_for_ws:1;  /* Use the UNMAP limit for WRITE
> SAME */
> -
> +       int rpm_autosuspend_delay;
Can suspend be negative?

>         atomic_t disk_events_disable_depth; /* disable depth for disk eve=
nts */
>=20
>         DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /*
> supported events */
> --
> 2.18.0

