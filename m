Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04855C43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 07:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9486206DB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 07:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cYXUZNfJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uyLBqutA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLDHNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:13:06 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:26016 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfLDHNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 02:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575443585; x=1606979585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zP/QANpMdBLvnNprMnSG+WGFn9a1TbYeLrqVu8MI7uQ=;
  b=cYXUZNfJLLM6Gc+jvMClbwUCTq8FOX2AfRLL26Oih1yFC0gMgeescUzb
   +ls66oQ2x8H27KLDeBb9Z9Nd6tQQ8F5SyFQ44gCW8H0TP/me4K9gvkyWd
   VezGvVuejWrEA+yIDZ9oqbanZK3EHVM3Zx2Vm/q3CtAUpv7VKSXG2c6ZO
   KCzNTMoYFYE46jxbLMOfeAIM78fiquy8eSIa+CIFv2wWMW3NzM5nPgtWQ
   H1wBcKFzU5YicDTmLMhbj1Tvw08pfh2FRrI0cgK9OEQyRvT33pTykosTn
   KGAJeJf0yyOaz9h1/mGi02rJndol/ZbelJ5QYG3rNr3TJjv/UQs9DWaGy
   g==;
IronPort-SDR: OWwmMcgNv92L2tGRe3sXIG+Ykyhd66GWN+EsJOcsQt7UKYItzAai370jvwhnuIWl86nb9u9TMc
 0fLgVx+DXD7PazKKhg4inS8+DfEFZuJeMt1zwvO9063X2Rlq4mM1EOE4RVvs722Hu39HYPKwXL
 vwavUU7Nmm7r+SMXI5LXQE6RxtEvkN1o/cFEJjZlkT9BPUuyNFjSWHx5ZTHVVGZRx3Cgy5vXR4
 wabNHss1NrWG+9OU51LXRsa4xnCuob686lswHZFiGG5eY8m0T/gevXot0FaMnmWHfxueIYkQdl
 W1M=
X-IronPort-AV: E=Sophos;i="5.69,276,1571673600"; 
   d="scan'208";a="129012732"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2019 15:13:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGe7Suzi9QPZfT+KzCXN6ExKhvG2FX9zjoEYQyQ82B0gutsXEq0pSNRU/PsBkURD9VW+ZGaJ4poeeqZJF5hmgfUNuHhRkMK4zeFLraha9Cq9XDLgcmxjrr/5yN5p15oP+6AklNWamNzqMVUzb/2V1hWGTucI49QADWJfPWMDY7IKX06z44addMovd09JZc4A56C9Duu1UB6Pn2OzcgvoMv3764Lg/4kPvY1ZCzfrsvvAPrznbQ40jTfrD8EVx5Pbr/OVyUiGwsFgKRYmGXLDu5mNubiGxhiOzjeH7GM14dvZ4Xq7iHserF99IzZmBsNPGxunsWg3raOfULA+1oB/2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqJm8s1Oj2cJV6Xj/fM7N/M3rOYj4LesTPCWZ3O6xVA=;
 b=j6ujCVuu1pQMIDWGPenEQd3N98Jkaey95Oe/nvypG7FOXFF3IdtoMyvXu3RLM7G98+fxzItHG8EanCTJUdfPvf5sGFBlXPVe+xpsh31clfjxrAkTjRz+B1wNfDZs5ZhPjBJ5pL3sqWw1us5TVaoqx4PgFtuB/aRlPCip4p8rfDi8jYdXh+tS3QUoFicGtztjKMKh+2YnkoTc8CQKJDWRYeNzrKpAWe3R+z7R4D6VTVPyx8/t0uSDqNUitOi2a27VjifRzZj2UQuxrsGos7uFXED+8IHQaRZpepG7qrxBMn82KXEdAZ/RAyfA+UQ7ub0fTBSO8oJtBiXlF8wCTeqwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqJm8s1Oj2cJV6Xj/fM7N/M3rOYj4LesTPCWZ3O6xVA=;
 b=uyLBqutAii7mvI6BrFnkHDBTz7hUrYcCGo4ICAf7+8/FTgaCGrKCjEenKJvv7zPVMbiy6i5f5U/M/SC3ZhgDBAE9QvU6tB8bwguKZk9Y870AlLzr9tBn+aGkV2eIqzMK2j0ssENErENFKo6xq7Ah6fKA1736BcM4uQZUGcisQg0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6846.namprd04.prod.outlook.com (10.186.145.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 07:12:59 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 07:12:59 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND] scsi: ufs: delete unused structure filed tc
Thread-Topic: [PATCH RESEND] scsi: ufs: delete unused structure filed tc
Thread-Index: AQHVqkBQqDGlHgUBgECpOiaklQka/6epj7gQ
Date:   Wed, 4 Dec 2019 07:12:59 +0000
Message-ID: <MN2PR04MB699129A4ADCCA58322AD8EDDFC5D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191204011507.4662-1-huobean@gmail.com>
In-Reply-To: <20191204011507.4662-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 513c29da-054c-47b8-2406-08d778896520
x-ms-traffictypediagnostic: MN2PR04MB6846:
x-microsoft-antispam-prvs: <MN2PR04MB68465D4203E5DA06215E1A3AFC5D0@MN2PR04MB6846.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(189003)(2501003)(6506007)(478600001)(2906002)(229853002)(7736002)(74316002)(305945005)(8936002)(8676002)(81166006)(11346002)(81156014)(25786009)(33656002)(446003)(4326008)(9686003)(55016002)(54906003)(110136005)(6246003)(76116006)(66946007)(64756008)(66476007)(66556008)(66446008)(14444005)(256004)(6436002)(316002)(71190400001)(71200400001)(52536014)(5660300002)(26005)(6116002)(102836004)(186003)(3846002)(76176011)(7696005)(7416002)(86362001)(14454004)(99286004)(2201001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6846;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hRIBWdeWC8zEreyZ4R8PR2yKywSUdDdN3jE0HldyQgIp9Ubnk9TeUC7Y/Yjwo0Wg7nuDuBOuUHzgLJAl3GU6CdZYY+mojUOk86OIHuYzn03/nCi9pvvYph49SISDqOgUQ9egqlNUeXn6phmzaCtO0a5j/zwuPRssrFkycOptU6h5Dm7at95glauOHfEVIrQWeZ9w90+MQQhY5TuamWCLAGsfdJlbwa2Aq1vIk+rJl2DucYPrzmbaBhLzNG6YfIrvt+JLrZ60PkJeVbrdo3bIo1rAmFgx+7q68Kf6eJ2kZtGz4QMVLfwWfINlBED38K8W1v+mj1iolN6w7g3ZJNK+hoaYOIcOvKZF4sYtH9LGwpxOw4Je8BQgJNdZRBc38MbmwyqCShuQeAvyhnQ1joOz3YPbJukN1vR8uFTrZ6n7BL+igk9zM7WWY14UbnNoQrTDYLN563QZNN5cNJvol3RpTIpHHKfOsDwhyZZtyoGz/OS6JTMqQNxTkulaEStW0wEe
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 513c29da-054c-47b8-2406-08d778896520
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 07:12:59.7248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pafZZKEmVqVqRd63QWzawjq4BdrT9LsoxbHc4z2+lH8e8RKsjU5hrbtn/59KHPsDTDryIL6PcYlIQkb0mrgL/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6846
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Bean Huo <beanhuo@micron.com>
>=20
> Delete unused structure field tc in structure utp_upiu_req, since no pers=
on uses
Typo tc -> tr

Thanks,
Avri


> it for task management.
>=20
> Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  include/uapi/scsi/scsi_bsg_ufs.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bs=
g_ufs.h
> index 9988db6ad244..d55f2176dfd4 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -68,14 +68,13 @@ struct utp_upiu_cmd {
>   * @header:UPIU header structure DW-0 to DW-2
>   * @sc: fields structure for scsi command DW-3 to DW-7
>   * @qr: fields structure for query request DW-3 to DW-7
> + * @uc: use utp_upiu_query to host the 4 dwords of uic command
>   */
>  struct utp_upiu_req {
>         struct utp_upiu_header header;
>         union {
>                 struct utp_upiu_cmd             sc;
>                 struct utp_upiu_query           qr;
> -               struct utp_upiu_query           tr;
> -               /* use utp_upiu_query to host the 4 dwords of uic command=
 */
>                 struct utp_upiu_query           uc;
>         };
>  };
> --
> 2.17.1

