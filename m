Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E78AC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8E32068D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fjVubD2F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HpJ3hPr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfKRHVE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:21:04 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10801 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRHVD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 02:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574061663; x=1605597663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J41tXZhOjf8mOzxCr3riOZzOoqFWK4/41RlaDR7CYOg=;
  b=fjVubD2FF+y/ODH/7qxnRG7sIO1bLQsr/PX3GcT+TVTV5zvl1ejVY9St
   G+RT8kbl8iXSvy8gty28NdDnpAvQfsUY3u2NimpnVQnTqe4Al2BzqI/Dd
   1ZEhznS9DAQePF9EoO+cSbyZkfbWobsxF27HxZlfFr4xYAL1JF4C43pC5
   dYO7kTKwEcBdgVyPb1aU3EyAqdXZIm/OWTnm5s1GQjyGnDn3kjlUjOzZt
   K77IW1SjGtE1HjEoCnhENj/L3CPMFwIbc8LE1oyx415cbAp3q4nUMErO1
   QCbGwd0jgiC4qWchMm5zBiiHzXrPSGUX1etjp1gsxb0YLeTQYxmzFHpTV
   w==;
IronPort-SDR: ZK5ier2GwSRo28y5atVp7EKXxphO2ifpKHbbkG68nFkM2UfHc+JR3ISNLpSYFe1r1XeJsxF0VL
 HUi54Ph9/YyWp3SrvMptswuMY72aSVOKePP04JsH6kNqEpYCT5vnii+JxCdtlOxCgdIN0E+qgM
 Fvmz3q286dETnAlhI22JLacG1K6qiPWQxONrhNU1Yqos0FH6fk0L5BPWF98LYM235otqVkfNrx
 /AHALPVjlK1XF9pRPvOpFn9luPQpXOEfvtLSFJ7BGsbAOleUzCLg0IsDqr/Y7irzK0f07MNZ5E
 s5E=
X-IronPort-AV: E=Sophos;i="5.68,319,1569254400"; 
   d="scan'208";a="127721455"
Received: from mail-sn1nam02lp2050.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.50])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2019 15:21:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SylMXs1/JzZz/d0cN7aj8gr/fSMjTg90HQ6gFHrx73LJgtQlgTjOx2xxK/i9+wgG034yRKCsDD1Tl2e2TlfC7KsWLTa0KM5B82CMY/E4H8aJ7MbMqnW5ae/ql11D9RPksKKPiqaPkDbhAgroYAZda4ckcH7DSDVpYwDZNvpRfgozeMtajpo7DmZ2epC2YHhheaDwKwRz6r6PeN61hL/IhcX3McVitI0GH2lsKBuX6e/w/JhTc6+FCG4X+GTdch8Cr58qMikNhCP/Ir4hRQFEZhDuW76m3sTz8RpGbyWmVb3vKJqq0nNXu64+DxEX2sPkIw2w/T+Aozz+XsDz7Gt2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J41tXZhOjf8mOzxCr3riOZzOoqFWK4/41RlaDR7CYOg=;
 b=KDSh99YH0BLZNcO7w22IRljT2M9+5zrlIODZgg9ueAdQfdJo2MLTVnDj+09aj6jo0uzGBveIpYVmq95MunaNLPvmZ6M1bQMCD32MQTvG9Inl2lQnjdxuEx+mhPdfWvMdMo9Ud9Jp5ce7T0jvzZR5aQ7OCwuZJ6LPBizzSN3131UC4bdRUWuShKxdMEZpaib6RXY67kvxEpTNADcx2C8JdqptkCDM5CeO1MzajLeis2Hjo9kL5lK90vuyuqrqk1x6ecpAV1BikCY8fKtG5YgulINzOByetVYWgRwYF44FLS3osJuMZx+6zPOzXTj34zGoB7G93IMoSKZO+6UCyWMn3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J41tXZhOjf8mOzxCr3riOZzOoqFWK4/41RlaDR7CYOg=;
 b=HpJ3hPr3nP3az2FumDkXSRFLfeaeLuhtp1SJTD4HAmWqOgmfVNTyxTTsFpbLBLcjLCjzF0U6iTUZe1fZFaBKJWkjLMjG6A5hBzwAXevPzUBYKPWtl+SZPv58giX+jU7rn042u+WIfyajCfEdhySWqUGAnYoEgigth1g9JCEsQuI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6976.namprd04.prod.outlook.com (10.186.146.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Mon, 18 Nov 2019 07:21:00 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 07:21:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@qti.qualcomm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 4/4] scsi: ufs: Complete pending requests in host reset
 and restore path
Thread-Topic: [PATCH v2 4/4] scsi: ufs: Complete pending requests in host
 reset and restore path
Thread-Index: AQHVncN4zcr808K5tU2/O7vxUpZlnaeQhWUQ
Date:   Mon, 18 Nov 2019 07:21:00 +0000
Message-ID: <MN2PR04MB6991736BCE24A155BFD9A862FC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-5-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574049061-11417-5-git-send-email-cang@qti.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ceecd1f-5b67-48c5-f1cb-08d76bf7dccb
x-ms-traffictypediagnostic: MN2PR04MB6976:
x-microsoft-antispam-prvs: <MN2PR04MB697653F2AFD33D6D86FC7853FC4D0@MN2PR04MB6976.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(199004)(189003)(6506007)(7736002)(478600001)(99286004)(305945005)(7416002)(316002)(7696005)(74316002)(9686003)(6246003)(102836004)(76176011)(26005)(54906003)(110136005)(2501003)(2201001)(14454004)(66946007)(66446008)(64756008)(66556008)(66476007)(8676002)(81166006)(446003)(66066001)(11346002)(86362001)(81156014)(256004)(52536014)(33656002)(76116006)(5660300002)(8936002)(186003)(6436002)(486006)(229853002)(71200400001)(3846002)(71190400001)(6116002)(25786009)(2906002)(55016002)(14444005)(4326008)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6976;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cl/HeLNtIkb2Uswgh7zp9jdL2lZ7zYkc8j+kdGBlxEaR2ZlNNa2tn9NuS6avg2CziiR9OysYulKjUOD3eNhkhD3NDLXxnlmVSd8NUb2w6lLEYjMwiRY4vl3wg9CZ9zytjB6FIT499a6RxOz80Vm/L7z0JFJncWCxg4ryeBmMLsOsNN1LCzUZR4g/wXKAWCH5nKplLly4pBK4Qz4iHd22uq5HSmo5OPe9rRH5AxnknCTja6qZdW8vTGrLWY7B14whTGooA8UphEK7T1Z2Ps4phtcpc5mNnGD8G0LSjx7t+SCh1CTb/URvhrRt8LyA2N2JEJWR90iCVBVqZM/S8rio5mNR7csHVUX4LAF2R+s3b0JanUaNVpvuis1eqqejyQaxF7AKjz/tSNPMauGbnuqBBxQPcpmYdzhOxRnXbmIOlZav1z5WjjUcbpPWq874YiNA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ceecd1f-5b67-48c5-f1cb-08d76bf7dccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 07:21:00.0407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DoFfNZIk3e85lptXmEWLAR0JfwTnLo/cagCrtIuVjYQVJP7+lOrNYMT106L4tOPOeDk7AoHrU3VKb1Lo6j74fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6976
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>=20
>=20
> From: Can Guo <cang@codeaurora.org>
>=20
> In UFS host reset and restore path, before probe, we stop and start the h=
ost
> controller once. After host controller is stopped, the pending requests, =
if any,
> are cleared from the doorbell, but no completion IRQ would be raised due =
to the
> hba is stopped.
> These pending requests shall be completed along with the first NOP_OUT
> command(as it is the first command which can raise a transfer completion
> IRQ) sent during probe.
> Since the OCSs of these pending requests are not SUCCESS(because they are=
 not
> yet literally finished), their UPIUs shall be dumped. When there are mult=
iple
> pending requests, the UPIU dump can be overwhelming and may lead to
> stability issues because it is in atomic context.
> Therefore, before probe, complete these pending requests right after host
> controller is stopped and silence the UPIU dump from them.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Already reviewed by Alim & Bean, and tested by Bean.

Please keep those tag updated - will make it clear what is still required t=
o merge this series.

Thanks,
Avri
