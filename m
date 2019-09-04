Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3374AC3A5A7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 13:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01CFD22CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 13:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NyPLmLfa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hkk11b+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfIDNjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 09:39:11 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:47144 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfIDNjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 09:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567604351; x=1599140351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KWivNhFF39wB6nkx48n7f9kHGbJuMqET5rLzzGd/uLE=;
  b=NyPLmLfac1t2BXFAdl9J5Iq3rvBolUfFhRAcbNvj/LOcfdpH67ljOCpc
   TgqQoXjBLy16uQoKkcVGh9+c+q94wlJ1DdEdX8G0gxqNI221Js1M7Z9mw
   ZGdQrKyTtIzr5E2WJMjbCtW/rnR78dfslpL/vzVmmyEPKkJkSw7JOmA8b
   41oXne/Sh1UmAZ+0SpJcVyYkeXFonnayeyiX+B8IibZcVc4NR7FAVi+sA
   Zm5M/f7DkmHEEvpGhlYzaChxIi6/nxMh3iEtWXWVvtk85JlXZMyUzBzmK
   rwPItGKexPrCFPd7wdCJLAyc+Y5TdkwJGpwVUzYq8l3bC4pi1d1g1pF9h
   w==;
IronPort-SDR: uLseBz4zngwVdg2cCvjAMx2IVDNvMhvHGtM9m21lg5X0kgxSfpKwvSEj5IptheeFW1jUkcYcwY
 HLpqdJUubScb6RZcqPqew8NAo5yGIe3L76BifMjNr9LCmAzCvadPnVmz8b5R+tqYnwp5Bp2Jbg
 eAPDKmMh2RtVhMpdDuSIfwCFwX7Z2zjZN5stbe2EN3YOSO82xfdIxQSZ04lY2iKNLpQhS8iwyg
 s7fy75y6GPdFY0FVFjc3+tPPf0MBgx73fCGV17bbINd8TIQuQ39O/gc4ZAVUpZbKq6A2b06QsD
 9OY=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="121971642"
Received: from mail-by2nam03lp2053.outbound.protection.outlook.com (HELO NAM03-BY2-obe.outbound.protection.outlook.com) ([104.47.42.53])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 21:39:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5HzImI8mFdnlsrxtN/r6o9MZyfssJy6TPmvHRaryydMKNA8UE7PFwAPNPT1W+AZjyxib+H2i5oKeZuPFB9ZMvkOnL0cN8phOjbVYoB4HntXX+Axh7kDnk6mr7jVkb4dMsDutS8URWvsX2jc3N4t6yT/5Uh2fw3qqlWZCz7EJEKl8+xGov5WrYhxf8b0KaGWkuoBCfUei2n285wi1jCak1txBx1itjEwg42CCN9kSEBLZnIjgnJb8Qv6BuKHlt1pnVRsjEgY58xDwAKzXXAHkCfV3s4ymBzEtRN7YYoK9pUK9tDgkVsXiFuxfM69mKqF927iTV/G6Owlll+xN6v9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWivNhFF39wB6nkx48n7f9kHGbJuMqET5rLzzGd/uLE=;
 b=AB9ThAK2BiuUhvbj0GFqXV5X0ca4IN/CSRrOxGm8nU3Osc3csHUOhE6Ea28ibPg7tVT9Ju+V/Bnu//ZW/6igdmkkK1n6tURXiw/ksWol+vjhqV+JsJC2epMrxe7MzIYx5Pj5eO2oK968DEXjCpwpi1fBqiIbn9E1vbAiBTAWLn2Sg+uC+gxuF2qL8j36xEtssOKwSTkNgQGNjKWq3idNIBZNIaOEZoT1EDDfcObwhVbTLpM8VQNyc4M2m7p0b0De6qUtDfjG3rSzcf/gWmqAKhd6rjbqj31JwExsQDRakh1xVOqCJlEwpcSEciu6wpqdJgnYV7EEhSbQmcr7aoinLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWivNhFF39wB6nkx48n7f9kHGbJuMqET5rLzzGd/uLE=;
 b=hkk11b+kg/OarL5VKDS0i9VqvwVP9D9txVc5bRoSo5gWYBBjwOndn1jJFXsGjB+antwtdPB+/rgNSDvSrSeU9HiE1eiB0ihT/7RKza2N1uYDq9Hufp0g4RLrPfJbJZwr4SLPzEeb0x7yuF64rQUWoWaj60wWVsHjl1bG19mF1nY=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5951.namprd04.prod.outlook.com (20.179.21.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 13:39:06 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371%2]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 13:39:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "liwei213@huawei.com" <liwei213@huawei.com>,
        "dimitrysh@google.com" <dimitrysh@google.com>,
        "kjlu@umn.edu" <kjlu@umn.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] scsi: ufs-hisi: use
 devm_platform_ioremap_resource() to simplify code
Thread-Topic: [PATCH -next] scsi: ufs-hisi: use
 devm_platform_ioremap_resource() to simplify code
Thread-Index: AQHVYyF9MSck/qid3E6nd7vxCBjsZKcbhdFw
Date:   Wed, 4 Sep 2019 13:39:06 +0000
Message-ID: <MN2PR04MB6991F98C7D36219627AEDE82FCB80@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20190904130457.24744-1-yuehaibing@huawei.com>
In-Reply-To: <20190904130457.24744-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20e677c5-02e2-4b27-5e35-08d7313d41f8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5951;
x-ms-traffictypediagnostic: MN2PR04MB5951:
x-microsoft-antispam-prvs: <MN2PR04MB5951C87E9928707BDAFD8149FCB80@MN2PR04MB5951.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(2501003)(81156014)(99286004)(7736002)(81166006)(8676002)(74316002)(7416002)(305945005)(5660300002)(8936002)(256004)(71200400001)(71190400001)(52536014)(316002)(66946007)(66476007)(66556008)(64756008)(66446008)(2171002)(76116006)(6246003)(4326008)(54906003)(25786009)(110136005)(33656002)(9686003)(53936002)(66066001)(6116002)(3846002)(446003)(11346002)(229853002)(476003)(186003)(486006)(86362001)(7696005)(76176011)(6436002)(478600001)(55016002)(26005)(6506007)(102836004)(558084003)(2906002)(2201001)(14454004)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5951;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q2Viue1ZtgcSlG6oqOZvF794VYBkH4QgxLpR1U3wcWhLtU+KTmkN02wlSnPrU/QSTNZGZC7IihoLbNsmxL9vA8Ma33dUYxvg00r926lRG47cUuWd5YkjIFMVsOXJHMDvD5l7j2aYuzqeo38w+lHxTj9OZ95BqzSfXUSaxDb+9bm+OtlzKPfIGxvzhyzTrJDfweNY+UMVis4mqfwq8BJpxeM6Vvr9Kp0a+VB/41NEpmIeaOAWU2qsSBifCVXEGyxcnDzo8wB8dpPip3qkuTvLC31ocVVbBQ08BVzaH/c88HU1avAAQh1Uay4qW83EyA4T+7jQTFD9+jNSiP4Z8OW5VULBTJOTEEVA2dZSpK52brfCV/iIRFYnlzlerqsc612gGcyiOwR0Ka26/CHWxYkdDaWV9oaFlGYl3CtBgG2m91U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e677c5-02e2-4b27-5e35-08d7313d41f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 13:39:06.4475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a23rOxeznJWi8PGfEzi1t2mvotZatJLHt2o6Ce7Bm5Li0qzVDHDdhcoWWgNtxkEGw/nXw9N92S4om2muPVgpDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5951
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
