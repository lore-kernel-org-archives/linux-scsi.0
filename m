Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F391ACA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 12:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9FF20B7C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 12:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OdWoJ4dJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iLOYE5Lz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfKDM5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:57:43 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8453 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfKDM5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 07:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572872262; x=1604408262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XLIzUBvcBO9lTrdDOPeXe0al33rVoQWiTjvgAyhlJGA=;
  b=OdWoJ4dJO4Wa+8Z7TMsjG3lJr0LStGmcVwarVxTH6mNI1nA+VkeY6cm/
   byFZUiJzQNnKFD5kBAD/nE+SHwdGaT8i2/tJeBbCLaKqDpuJyqb7i2EqN
   4h8TdZjAtwYiPU+nlMxOeDP8KuU8f48hxa+zuqgYZ99FGYx9fNuq7cmVn
   io3+Wa5k/v1oRvEX/dTncbfdbnte7POJVD6fE9AlvM+2hiABdpcKFlR3k
   KlDO8fRy1rzjwJ6DxoRXvM8yBglmIG2ulyUMSKViGVTlkOpBym/2fDghX
   KhjYTJkltzJnun6HRw0cUp0mb15J3iZEbWS8EpRarYbTm5skVbFrPdjHQ
   Q==;
IronPort-SDR: zoFXwQply8C6UVdNzoipr/IuAgybK1C2Q4uG7r2hrbYQe6Ugu6nBzAxmyCqcUjtsmWPb1tdEQk
 USJzm1CqEsZI5Q2UoBe1mCu0OUX+P+RE2A5ms7xciHT50cOkgkKzO7tVC4ZyD826qcClNlqyjh
 m3Kl5mb17ZHa5kpkfRleFPaoDs54ptumqY+jIxAnCoIYNJzNPXuKjzuwmMKq0PWA3n6fNQSFZ3
 PEH2DO75doTx99IZz67uqY04hYRADi+I/F0/a8hlqTtxafwWvRNsnyiaWHtwdCGWi77guwq2IA
 xwk=
X-IronPort-AV: E=Sophos;i="5.68,267,1569254400"; 
   d="scan'208";a="229279151"
Received: from mail-cys01nam02lp2055.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.55])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2019 20:57:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUKRUNJMBk2AUMyM74bAjdTkA8F4qXi8rKln4YZorSbwKINULlzMCW3YUqDiYCkXZ+zXYxu5+C+3e/hxy1JvBvCGPMB4nDycQv6wSZfDiCDuGbCUgwO+ZA8I7DyZ9BsK1UFe21olQ3l2dXSKDshjY3ykbKawI6Z0jrKULyuni8aOb/j6re+525pSbV8hGhlg4odJ2LGdhxvLGs/CQCOKfOCWHHCJ6lxJI5fWuC+nRIGy33+PRTH9JFHh+wpg8wnmK4asYnxp+9bBIjrpld7TXJeQf5z+bZMvndS3Sr/8Yw4K9EdyDj/dIF7dfwitGnPUbwK7Ns5TXICC8RFGjJI3Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLIzUBvcBO9lTrdDOPeXe0al33rVoQWiTjvgAyhlJGA=;
 b=Q418ZdhfXwKolpLVDIIvOaECXGIzjRFO/kvZJ2jW5izpNeKXepshMYb/9LbjHN6r4itQJ1d62U4doqY08jFC335fo3HOKhQY/MVa401yN8oi2va36cQpSrdDNHYSiOCuKQc0H0rlg1wZmiNUS0mREIstO/MFxuhnj+gqjEa/N1a9WHeL0LdELLWhida4leIcy/4uGFGwiQuaixyt3+moq6U79n2wyB998wXlt3956E8uiRZ7223JDuRpxFcw5hsVK8iYiIm147R4Q6Hm5wtXoRdE+om3CG2twe8ekQX6TEBZjh0cokA7YQ5g0/95BCZ3QHR2+GrK35OKL5tThjxfDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLIzUBvcBO9lTrdDOPeXe0al33rVoQWiTjvgAyhlJGA=;
 b=iLOYE5Lzkm6ooyzte44HFUZd+B0+McaFBD06fqIb7Mdw3ATGDUft8uEmyj1dUKaMUcHHPXPqUTBUN7O/qUXLTbkyOuc0vvXPipyYe5qfBG3lWy/h2XIenDaSRBPYo8QEQeA5Vo/+21eKKiUNnJzCREpfNpT3C4lemTlnMNYPtv0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6880.namprd04.prod.outlook.com (10.186.145.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 12:57:40 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 12:57:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [PATCH 3/3] ufs: Remove .setup_xfer_req()
Thread-Topic: [PATCH 3/3] ufs: Remove .setup_xfer_req()
Thread-Index: AQHVjq2ntzlUV6yyIk+z0Dr18QpBGKdzCcJQgAf3Z3A=
Date:   Mon, 4 Nov 2019 12:57:40 +0000
Message-ID: <MN2PR04MB6991FD5665C0C1E7DEF7854BFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191029230710.211926-1-bvanassche@acm.org>
 <20191029230710.211926-4-bvanassche@acm.org>
 <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 553ead6e-0991-412f-0a84-08d761269321
x-ms-traffictypediagnostic: MN2PR04MB6880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB68803CC528000142FB14AFC1FC7F0@MN2PR04MB6880.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(199004)(189003)(86362001)(256004)(7696005)(486006)(478600001)(14454004)(6116002)(3846002)(186003)(7416002)(26005)(2906002)(74316002)(102836004)(305945005)(7736002)(66476007)(66556008)(64756008)(66446008)(76176011)(66946007)(11346002)(99286004)(71190400001)(71200400001)(6436002)(8936002)(76116006)(9686003)(33656002)(25786009)(6506007)(55016002)(8676002)(66066001)(52536014)(446003)(81166006)(54906003)(229853002)(4326008)(110136005)(81156014)(4744005)(6246003)(5660300002)(476003)(316002)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6880;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4qVEn3fAPwOhRtUBQnFl5J4rDY+IIorptb2U5rW9VddJMvMYaNPrXiqZ4xI6t7PSvyCgw8K3pM6BVyMefpu1/HmlieTQgNw8BbOarPANNCzvtMLmAViL5nNKQD8TjK16BfQXF6lOItn06CoeTvDaMxXcMT02pPMM0Fm2t9qiS55xOz6v4/hFpOs5Sox22Q54Gr0SOj2YbOWH/lw4047Q8PfWhCCrP+sTmsM7Spwog21lyq20NDQYo09oexI6qKgypaTp5KZnZkLwae7ZXM7i61EdSwxq7/kS4jxRW3cZiTHYd3BYns0v5M6fLM82129oE2Ii9UmwWEiHENHvSfESIjB1+MQiJFpi8/YbxxqJHz2etJnQENCCSePKS6Jp/Nsp/weYc5q0dykJTtfIXndRcCIfNPUWHAZ2PH/lh9OI0B2/cx4d5grXREMTqkeK0oOn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553ead6e-0991-412f-0a84-08d761269321
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 12:57:40.0226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zhQvqtAdWcC8fxYIkP8xD1XcvcT0D7GqgDyzOeXnqqD0jetWhrQyBvfqgalS6CqnIC9LWM6dH6rSri/oWFB8mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6880
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As no response from Kiwoong Kim:

>=20
>=20
> + Kiwoong Kim
>=20
> >
> > Since the function ufshcd_vops_setup_xfer_req() is the only user of
> > the setup_xfer_req function pointer and since that function pointer is
> > always zero, remove both this function and the function pointer. This
> > patch does not change any functionality.
> >
> > Cc: Yaniv Gardi <ygardi@codeaurora.org>
> > Cc: Subhash Jadavani <subhashj@codeaurora.org>
> > Cc: Stanley Chu <stanley.chu@mediatek.com>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Since this was introduced only a couple of years ago, Maybe better to CC =
the
> author Kiwoong Kim <kwmad.kim@samsung.com> Before removing this
> altogether.
Reviewed-by: Avri Altman <avri.altman@wdc.com>
