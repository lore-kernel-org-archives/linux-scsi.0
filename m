Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96833C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 628A1206A3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PVO/Ykgv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m7oP6P7n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKLHHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 02:07:22 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22437 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfKLHHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 02:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573542441; x=1605078441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VhJnDWVFoCbPfsICgrCC26oejgn3yQV+xxo3O6GQqI0=;
  b=PVO/Ykgv4zxRiaIDeqvmg3yjor8F3Z56d6bZNLHiLGLhI0N4muy+rcTz
   wmXS1QkgH2jr/z0xko797KJLt+6sWC0A/5mqrsWIoaCdmsFTzWj7cilBV
   u5p5s0Y/gTSXVR8SiK1UDhuOqw0uL4B5WOKb5myR92jxgpODX3w3RyOhd
   fghd43qN0CrA4PbYZHS6h+dYCpJlY0l1qldcCB0IFmF3+HmRLOdH4EMNU
   8MbkcjULftacLHJthbUSboDNBQUQiTPfJksn038VYAkQu94kc0rPqDl32
   WqJ3DL6zI6D6Dz0NTl1C9q6UqfiIyG8ZbRARYE7BjTXdjHJ9MauO7jXiA
   A==;
IronPort-SDR: V/H8cH3sxviysV/T8yKjVKqUV6xh6RbudyV0iaBIrOVLFlkusvFlcGIxPVzIXjO+ByMWautQgn
 /Mj9VnSL19WLwxCzPVpN2hlil2GYAebZKtE9972IezygpVEsXDPPHdXlmViqWa2X23A2FD/yHW
 JOlqt1IhrMmMkMjWULvQA7B7c9DHCtVOeJ4DGZTK1C4Rsy8MrEdbAERYKUs+CSlo50Y5dDP6VD
 R3rk0luF/y3QtMG2Mslz6Te/25Kb98WaRigahY+h/Pj7Pbq3v5N4JrdEc1gNAMZgk6Q6wkkmc4
 rm0=
X-IronPort-AV: E=Sophos;i="5.68,295,1569254400"; 
   d="scan'208";a="122725019"
Received: from mail-dm3nam05lp2054.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.54])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2019 15:07:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJ29kI14/X7rd6J6bWXvbBLRNAbAxBXi+ijlLNFRTa7eyutV2MERnN5WM/DHTzmGGJBoyRv+llU514/kjC4aHQ/eJz+hzOrqruRP3Qmm/RuvWNYUAYN8o5OWX9acfSqav8KxWNkgdOTYFrhk6rFGEnWrrppgBl6x9iX2m9fzhyEx2eS1IfdhrVTuzz11t+aEgUvaOjSWmYlI1qV1r4NlvQk6BrkmrYjTms7ao4WL93DMTRi7A9l/cl6ET7YSywRr2Drn7XYlLSJe/F+g59oaeguWFdJabptNHYuhWXha7RGA3bDBaHnCIkjt2tK/QAihTHkDWmmQ4/BaOdwqsSn6Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPgA88NtZ2+WOGGlg+4da13CTaO91EXuKZ/WYcTFf0A=;
 b=WmnPJJ/pLJQ11jJTgyJ17OveASisyX5Cj0TVCz3ymGiSHakdlZHiPZy6DwDhnG3Tr5vUQsqm7IuyGXZJVBPBwGcylsDj4c7i/Yv3/YyDQYi4YVN9KrYuRFNh6dOSXaYx4S4putPPk+Qrz2+r0VSOQoRjtkiuj1LszneXRSX0dRqf9EZznqF1g4qSnsiV6+EEm3RUHm5Q5/Aj+iKXXt1rvUv9xseNx2Kq0zXvcmSMRjhoxxwn3WwvA+A6BxP+Hi1v7Sl1e5SV/G7LzSgNukS1HugP3PIuRrC7CJdVfG/jEb8bM6pn0+DPgPA4xdC3EQppASfWxVCP1tjOu6XHT5O1OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPgA88NtZ2+WOGGlg+4da13CTaO91EXuKZ/WYcTFf0A=;
 b=m7oP6P7nxVU94GCpWtZtiwLG4jCrCeRr21AZaAPNfYw3dYFg6uSZSENGlvUEmL6ntFiVQljq7uSD8nLm8kXtHfo7YBY8qlfD4QnhI24y4lHoHNEXlrl8cnjp0rTx3pYQ4CwcLcw7KcK/yiYH2axiXSRTlLElUsCH41ODD0XkkhM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5790.namprd04.prod.outlook.com (20.178.255.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Tue, 12 Nov 2019 07:07:18 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 07:07:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v4 0/3] Simplify and optimize the UFS driver
Thread-Topic: [PATCH v4 0/3] Simplify and optimize the UFS driver
Thread-Index: AQHVmLhJ35KPJCIEEkSKaYC74CNddqeHHgQQ
Date:   Tue, 12 Nov 2019 07:07:18 +0000
Message-ID: <MN2PR04MB6991ECC8CBD1DDAC926FD6E6FC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191111174841.185278-1-bvanassche@acm.org>
In-Reply-To: <20191111174841.185278-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 362c3a3a-5e73-4e02-9560-08d7673ef4c7
x-ms-traffictypediagnostic: MN2PR04MB5790:
x-microsoft-antispam-prvs: <MN2PR04MB57903C447AC0CF0A7F686747FC770@MN2PR04MB5790.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(199004)(189003)(486006)(5660300002)(2906002)(81156014)(14454004)(8936002)(74316002)(186003)(81166006)(33656002)(7736002)(76176011)(110136005)(6246003)(4744005)(7696005)(316002)(305945005)(66066001)(26005)(54906003)(8676002)(6506007)(25786009)(102836004)(99286004)(66946007)(14444005)(66446008)(6116002)(71190400001)(71200400001)(229853002)(446003)(11346002)(64756008)(66476007)(66556008)(478600001)(3846002)(52536014)(4326008)(86362001)(76116006)(9686003)(6436002)(256004)(55016002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5790;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vufv+JHKTRcySwHsj/xyVJZZDH2xmBNRemMg2E4zuMUesWzV1jIhfFG07UnyVpkUE8elLQoJ9q0liP6+PhX3QeFjsKcWlfJYq8Gmy/kdyqtyqI3i6hypiEXfvFDA580SOBVLVCBYOO+x28BJZEbtO0D4QH5ii5S9zHogAZ5eN327qLCrb6WSfcNFR3Zt9wzM7QgpuKX3U7ozJ3HWEVFwpCyZziO4Al7Kyh7rWWLcVeVWQsJBOaBtGp/TCqbugYkzzQtcOaAxZHbkruTwbPy7OFfV6LmSGdPkGqg1zKNvBCvsEJvsSf15ETfo73cj1J/Ku75dTU3c4RXdg6hPJgwnr8vK/le7zIPlaYc17tTDvGg/oLkqhj6tsZGlI2yS9abJ2to8/z9/dAcAY5F06AglZP3+Z/sdvcfjPovzq0yoDSuQbvDGtRjVo8uNIyzabZPA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362c3a3a-5e73-4e02-9560-08d7673ef4c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 07:07:18.8060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k+fC1v9ToFnzR09CgfDq4g1B81LbFFiPD9cs0rxBsM5czjQprzEbjQ/zqzQMkaV1S+15cUncrFl5rKO0n6UcMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5790
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Hello Martin,
>=20
> This patch series that simplifies and optimizes the UFS driver. Please co=
nsider
> this patch series for kernel v5.5.
>=20
> Thanks,
>=20
> Bart.
>=20
> Changes compared to v3:
> - Left out "scsi" from the name of the functions that suspend and resume
>   command processing.

Looks good to me.

Thanks,
Avri
