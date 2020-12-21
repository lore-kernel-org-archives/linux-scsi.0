Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D626CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 20:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC5E22AAA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 20:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgLUUPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 15:15:07 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35094 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUUPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 15:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608581706; x=1640117706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D5+S5v9EK1QILbYgj0gEuR0YcNH37IwgJRZxhFcMaZw=;
  b=oZsk4BmVUwgQ3dyhP32HICEz4oDN7RFseu5Xa+Sx5ZLOlvcqL6olE+YH
   MifeMP1XzeiKsyzXD87daDv3yIcFr5RUn/SnXKoT2XIYhYMmCVGm83uc3
   DQ5IBRlgYGs2CICxvt9s5uju7c9Q1hthilOK4tXVkfIBvM4DjI8r/OBN3
   u3Vq3Ut/s2qJWlvLOM41/czNaQftD7XghYkGsesAYGSy1FRt48lWYisyT
   qfOezy1/xPtY68yQ6bNGGdZnRgUwCvY7RlfeHPrlYG77T7/A8QyJWANoo
   KZLkhj9gYGzBIlS9RKlRzm9twSX6p23wkIPvDm5Y/G1B4teEX2PYTrTda
   Q==;
IronPort-SDR: 0c6TkOU4h/mr3HihAI8iVkbGJZqPQUX67bpGyi1FJA7HqiioxKRLgO1U8tl1aP9j6IFo1N8aJ6
 Fd2BF23f7ep4ofFdxXN0ZUCvHdqgV4mMUCDasYX3s5n0ueTTrq1ljgHU7aQ4O0rCfCSxdmIkZT
 HHnl9a6ROyzeflhM0WnoBjqj8ltVlbT1sNgOQ+ubwqhZnsb/FIN7mIwEZiQeUI/7zK2EZq9v/v
 z4XCrp14EKaBqRh8pgjrFuquxMUkPOpzI5j7P2/S6TNhfhwi5IwlTUp7RC0CppdwiVco2Vr2L2
 aRM=
X-IronPort-AV: E=Sophos;i="5.78,437,1599494400"; 
   d="scan'208";a="160161291"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 22 Dec 2020 04:14:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpBco4JPRdnRIJPKRbFEur+ryBRctdMHG2n/0ZVMOOJfvKDIFgx6UnAyOqrCrVQt1m7lT/X9k14CuBwOKBQChlEKADizaJouJSyFsN7sKsjAlrHjlqinL9l2mYEENbDcBx67rGbwur9FBHJahoAT6gjhhnSa3jtVR/+hgQ4JXM/OHn8aVBE47OpUbPVSXcWbT9jJthbqTOlRpFgXYlMSp+ubQMm4DYDPdMGavN9CWS2wH/+cujG7j6oQxUvzhZufEJMeqehYrDpY87OJeus1MQ0uDbI6XC9G2t9S+QDmDveUswG7rUqOxymCXUelsJGPuHgSNO0pTbseh6MDaLMYqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aBMWWBFD/Ycp5D2xEIFacYtQcDRP+ycqzqho3LbsIs=;
 b=lMQ9keBoplQ7IHGABLv+ZPTeMKozFihW1KV3aFfCUybT+Pm/UV19fENOC3SbAzsQCpXIugiq6Mf75c4Umuh7/o0R58aKatAFDz94LhfPU7NH/+m2IZHKcaTJwIO59S1p/IhcfH6BeAJHWkEi3tjKy7nJWdgoOkw0Mj5zUnoUFvlqJE3pqHThxTw8xIoqHtCB9fFzYhPxu7/UbvEh7yTTcbZJd9WDe7tWJRaFdHojVm4/U37UbHwWEWgzSrRe6PlUBmDXNQE6aq+QLmgaZPPXqvKRljtu1yIu0UDhnNzrMTxLFZ/vXUE1S24oZ/+OyFjOjccQNmN6+S3MonQBk+IZFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aBMWWBFD/Ycp5D2xEIFacYtQcDRP+ycqzqho3LbsIs=;
 b=uRRsvaFbTYd3UTtH2JZcbS7/LAdXYuRn4g4HtgNO5GTAcEYiOt/Bj9RZX6N9ysg8pjdHrC4Qo+y6kWl1B2fOKeLjgkxvBSI+xi4UAmuG0aTJbtnmluPzSakXBxxcmAyzmQan5hGYBkrNPWi00iRB8qwIaSdOdarzDPD7uAYWNzw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0971.namprd04.prod.outlook.com (2603:10b6:4:43::35) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.25; Mon, 21 Dec 2020 20:14:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 20:13:59 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Topic: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Index: AQHW1O5Lq9Xt0bukCk2VnSNzzSWPAqoAjHbQgAEkMYCAABqVAIAABd2AgAAK2YCAABsmAIAACjhw
Date:   Mon, 21 Dec 2020 20:13:59 +0000
Message-ID: <DM6PR04MB65758C12E48BB7FE1D614350FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+C9+1p1CbssKRdO@google.com>
 <DM6PR04MB65753B9D31B3643C757E4E23FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+DZMwSHsskcEgZE@google.com>
 <DM6PR04MB657558D8353199D53586F654FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+D5EhJ8QzNoeHQw@google.com>
In-Reply-To: <X+D5EhJ8QzNoeHQw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9772b06e-ce9b-4eb3-1583-08d8a5ecf425
x-ms-traffictypediagnostic: DM5PR04MB0971:
x-microsoft-antispam-prvs: <DM5PR04MB0971AAD706524657759CD3EFFCC00@DM5PR04MB0971.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wm38KW02Kos6XeqZv3QEr46XwisAM+4r+twvjGkjfCRuifsXjgNjrd0i7EAXTYx3zRkMWq86zoOAKJglSmiJJN6FILR0Dr9Mfyp1hpPMFtUcal54wv4kdx94tEc10iUOFPyPVmWAWstn5r8KEf0hQotoqaruytKTOhljXNCXTU/PwofNqSRm/IX0conB6gRzsEg12JQa1uXZPU3Kx76LZDxNW2Tya0A2FonN1y/c0XNOseKZSEHDU1HQQFcro8vXvJMMEb/bQA9pO/t52beC37j7SNgYlW8wvVbaZz+pGUhpldGQ4e5E0SNRgO1E8T5gH5Z3DilIzY2z9nUQO3tlT5KIv7LCIeP4VmmGrqRVGD4hAknzNKSPZ9uyue93/wcQQZwe9+aFISIP++WK3dTxmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(55016002)(83380400001)(8676002)(9686003)(5660300002)(2906002)(6506007)(7696005)(71200400001)(26005)(4744005)(6916009)(66946007)(64756008)(478600001)(66556008)(186003)(316002)(76116006)(54906003)(86362001)(4326008)(66476007)(33656002)(52536014)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Y9qq7lrWmLJLqPSrrJAdWkAfzPsaxBzdTqZyB4Vr/nhJhOR94ZMVw1zrSexe?=
 =?us-ascii?Q?WuYpfSvDCNF8+yleGPFom2KrGJKkSU1BHfmBQyMkIy6xtXw2HPhLHf+9PXHk?=
 =?us-ascii?Q?Fm/x4mgfJhkckH7szL28896fBCJRAu+FRQjj7xlXSr+cGwE3n/7Uv4xED8zX?=
 =?us-ascii?Q?XTRV2EsV+qM+qhIq2SfdcwFFmnWywY6VdL/WTr1aHSUz3bK7Gz4w0yQp1hV7?=
 =?us-ascii?Q?UV8S5xkgh/Yg5q77vcNQgXBmRxe+Uqz/Vxaok0CpgnWsYrtQpKrBt/37eX+w?=
 =?us-ascii?Q?dJru5TmIDleXTGe26lnOS+gyXQBI6ps0LIZx/QriIGpNrTsFgMagus3Z9QMP?=
 =?us-ascii?Q?5rac/jytkyBaaVek1oIcTL1gYtKMcqIfeCacS6GYExVQaoyGH/XG++aNvqDG?=
 =?us-ascii?Q?LSWsJEVMLQJNr1OZ2n/5DlAB5ACckyuJ8UsRXClNpllinz+x/8HxImoM3tDm?=
 =?us-ascii?Q?klIFxKc0plcQWDKXJK/aShn8LXFgQwwsEXMtgE3wYlrUBSVRAQRX6QXrwipk?=
 =?us-ascii?Q?YPeexKj7inxVSSTMD0uBukbqmkakc1JwPP69dyhXqTEbN0GsMwiLwwnTb/iN?=
 =?us-ascii?Q?XNimxi7IjWY1ssKVuVuTOF/Fwm3f9a0I3+Pbs8paoqxqcRaxMVFxvK6pMA/m?=
 =?us-ascii?Q?cPgVq/cSUME2Mvom4kwCjacNPt9YysZs6BEPYdkZ+yuF5zHM3+VT6e7Ndit7?=
 =?us-ascii?Q?Bn41G4DMyoO5Jvm0yoQC3QvpyWv1lHdwQsM9gPbsBvV1nsEKacxDaRDmWg0x?=
 =?us-ascii?Q?w8NzEWLYeJiXJ9aOhPO8uxnw9fXK5Cty3EArh9YZv7tTTegHWoM9oqGUUq8M?=
 =?us-ascii?Q?+KZbr4xAn0wS4A91sVpHUVeW9bmP4tJO4wBEfdXfc0HNsBSGEEe4DYMHvOFA?=
 =?us-ascii?Q?6hnoSqpSm8txZfIOEtl0cQBM/MAdbnhky1etoeTcocIoJWkV59DSombXrPOG?=
 =?us-ascii?Q?Q7Obc5hiJsIG79honTqtMvZ57WkDNxFKemenrkedUNQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9772b06e-ce9b-4eb3-1583-08d8a5ecf425
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 20:13:59.8925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VeGIzYIllcY1ArLJtMW6HL0c0u/2mKX2V7479cV7hXAEtUt+PmDQVFkIKumHpYo/gPZqrVwCKHrd83TxoQpQcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0971
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > > > > In order to avoid it, ufshcd_clear_ua_wluns() can be called p=
er
> > > recovery
> > > > > > > flows
> > > > > > > such as suspend/resume, link_recovery, and error_handler.
> > > > > > Not sure that suspend/resume are UAC events?
> > > > >
> > > > > Could you elaborate a bit? The goal is to clear UAC after UFS res=
et
> > > happens.
> > > > So why calling it on every suspend and resume?
> > >
> > > 1. If UAC was cleared, there's no impact.
> > But the command is still sent.
>=20
> No, ufshcd_clear_ua_wluns() will return by hba->wlun_dev_clr_ua.
>=20
> >
> > > 2. ufshcd_link_recovery() can reset UFS directly by ufs_mtk_resume().
> > > 3. ufshcd_suspend can call ufshcd_host_reset_and_restore() as well.
> > Seems excessive IMO.
> > Why not selectively send when indeed required, e.g. on reset?
>=20
> I think hba->wlun_dev_clr_ua is the indicator whether there was a reset o=
r
> not.
Ahha - I missed that.  Thanks for clarifying it.
OK Then.

Thanks,
Avri
