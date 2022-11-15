Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1316C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 08:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiKOI4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKOI4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 03:56:45 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25D420193
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 00:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668502604; x=1700038604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/ukNYTBIAL1r3D6QLD/JI1E9NL3pwKVFs9oBRmIdOKk=;
  b=cREwPBNSh3knmAC+vjZ2l0tzAH2rTipHOUC7gZOvi5obBbR2vAVfAmqn
   jYWxmPKqOou6VbI1b2wW1rw7ogFKoYdwxXx2D/PI8nmH4LsXHBRHj6nsp
   ZW1lHZu/cHAkDkenN91C5zNsdXCCwd98YrdegTP7Jli7omrJFzZ18P1pv
   TJq/VRkOe76JWXDbAMUS/laONzCLjz37LeGqcsvKiDYaNY502VgyESGyM
   T1Xec8Oj/6TmCtY19GLML++zvTAAU4ZSN/1c1+PxytJnUgw1aoU7t7n5y
   k7VxrcmhhPbMM9O+Ozi/6sqVJmhi3c57h/thyWFHE1k32QiP3gj5bMKZS
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,165,1665417600"; 
   d="scan'208";a="216302387"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 15 Nov 2022 16:56:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRD88Z97UldO4iLXN92tKuZQ90Ncp8D59CtdMGifQLpjuKfJaJteGoAZcdIJXUMRuPKjKf6woIQY4aZGHIsaEPJRcwrE3T3UOp7KsXos4YGoV/zy1D2wX3XiJIpWUr3U31KINaGtW3JwTzecmgcoMbayWRNti0BXgNrtcPAxFSCtQKM27ip89omN5tXx3+DX1IcsFpp9PBlYoIbOvYjK8SwcaSbETNbx7tVxsg/FA8A6MUg05YwpQ5fDAZ3S2Htcslca05gVmE9jHjJHilN5CIuTgQNGTGZ5xTZmVsvkS9wKEG7QTkK5/nGc3OhPgMEx1bjVw7PA71emarwEJlmiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=804yAkTPrOiRribJIsFBQfJ4++aIKZT4MszYnfiTdkc=;
 b=AtpDZtz1S17P/Tx+Qyhyk0a3wK7CgJ8YudPJEwk3i3jOEFiMOWsrT308pCApk+Fa9L50j+qgZDoTn0tlNwUjNV4qFoW4ciXdTkaEc0uRiGmLu+bl+D2dYXmh0P5yz8aSzP2OPO3IerUmBXG+c6A0x8dK1R4xnENsfR4esIl+CMfKMhbZVyjlSL7WAPUmel2f1WmV2w7trHA7tPCbZZcvIk+QOmYCEnX7zwSIOAHTZcGHkfJuQFVBlU3AznMx+Y/tRSdqfYpHfJxjv7xaoVeN4Zg+SM1U//o3P2ide5y7cR8ZRxDedejV8eJ+A/qJE4IqjCb9JHl4lhbhAic85iaBXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=804yAkTPrOiRribJIsFBQfJ4++aIKZT4MszYnfiTdkc=;
 b=s1EHYYLXmPGUwO3871rE+kGYLjTbdCWwynPIPTCdG7A8uh6f2oOMENT2ZDt6Sm0Q7SBwmU7ybSbN6WbGls/dH4t/9g8LLbhW8bzZnCpNv940CM3Zhv1fOwpoLcpRWYBPWJwHeTzXmRGU0YIn8o6Q8RufHnyTDINcXbqEOIWKXzI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CY4PR04MB1033.namprd04.prod.outlook.com (2603:10b6:910:54::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Tue, 15 Nov 2022 08:56:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72%3]) with mapi id 15.20.5813.016; Tue, 15 Nov 2022
 08:56:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "hch@infradead.org" <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Topic: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Index: AQHY+MamVqmOHdmxGkSI0uQCV/pSWq4/rcLw
Date:   Tue, 15 Nov 2022 08:56:39 +0000
Message-ID: <DM6PR04MB657558167A98D2E9C0D63C57FC049@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org> <Y2uechJH/4GFDs8h@infradead.org>
 <e343400f-2c87-8abf-5ebc-9c9a4a9030d4@acm.org>
 <Y3NETRqATLK2Z6LZ@infradead.org>
In-Reply-To: <Y3NETRqATLK2Z6LZ@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CY4PR04MB1033:EE_
x-ms-office365-filtering-correlation-id: eb5b44ea-e21f-4431-a72e-08dac6e74f6d
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ecz0gNnN73+LYAE6ULXL7yBMYYhnt4rxiSmHJWSoP34KCmIJvhZ/eei0/jYLavjycQX38hcBZSQ8OHO01CLxXi5gjpVnHuLITBFt3+XMUcqTv9s1lB0xD2VPXMJ3y6sFXDJhC3ocLkAuzcQk74osQjVFMwZGVScNgrQeeuItXQZuQG+TAZ+0f8jQvtoh8wBSm670y3/aRPgb1Hgl/cbJtHOy5bsNsgpjufRwBA0D54FCSBOCxQoZaF6K1WNkWu292SuX5KLSCY5mq4n3V4W3ZEvveGs9NbSxrMcqmKLryu6S7fT2mxId/HPHpZSWqmRPXa5b/FqbVknDlyMPfEqKw4RZukjqR16IYq9JI82W3pkzhHGSDsr169rl6J8dNdArh0L9+mELBp0e2rzeq0ZxpIOU1tJEMgk0oOsrOqtq+C0RwJXD5JWhgZDGD5bJJbU0O8kTlzBeidLLbVdmokaSrbDuYFBirsdlRGrPZdWZb1dDss9Fydd0xkjreUKRcHQOVjsrrVPR5M3wdU7xj1zzXuB4dkXx96ZKPtx/A+J/qyZcFZbw2HLVIwLGNJ1G5qWcfIsuSM6+Bhz86KxHVL1JxOIpdf84o2op9MlCgcj27wDkPkER2MZJ2FqHOqzSgrFU4qjActqu74Vr/9GmV8e5bzWq/eZ1vffzqcY7uST+Q8Vv4lVUF/Zu7j2edBubc4EX/kXUT2GzyEX8N54VGN4CsK2C1SkwiZfZlc9THTLUr0vEwJiuJHehqlYDccFx87C+LZXEiXeNyzQzqe84wq5iQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199015)(71200400001)(478600001)(38070700005)(110136005)(7696005)(54906003)(6506007)(33656002)(316002)(5660300002)(4326008)(7416002)(8676002)(66446008)(64756008)(9686003)(66556008)(76116006)(66476007)(66946007)(55016003)(26005)(52536014)(41300700001)(8936002)(186003)(2906002)(122000001)(86362001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I2bL9yioV0oByM8KKjQVq6AJQ6LOTOj8d4LfRHi+Pw/YSiUWnkZFfd/tnW3n?=
 =?us-ascii?Q?wYqmVPWu3ze+ByMYgNlD8JBymlNr/wZK2Xr84UWd+5U5J8n2AY2AkdXgTlTo?=
 =?us-ascii?Q?Bo1WtNQKPH8P0TlsQP0Ao3tn7MXxtPaX/Nm77++oixbpsFn+Fb3FgqTRjf6z?=
 =?us-ascii?Q?CYcpJ33lPFghWBuNuZKn3hA7W83V+YTtPrsCX/fRA66B4D2bbiPK7E5GByuI?=
 =?us-ascii?Q?haB18jFi5y6KwnnxuNRuSv5WXJKH/0VU8T63dsopgg/UspK/Mp5e1Uc9mES/?=
 =?us-ascii?Q?H5jCNiB5k7DibnDN1AbYUqv8TRU0ltks/dtLWoGDlahWYYLhbJFvvlrJq80d?=
 =?us-ascii?Q?e0ECR1t3a/QNOXSsRCtfOqaVDF4CPIV2DPLTxMMlRLfQOGpTyj2AOr2djsB+?=
 =?us-ascii?Q?FrMi1PbAwOZIdhowoUtUOmp1zuct3jUcR9l4bNLDqfEHd/N1LeLyVI3ka2kK?=
 =?us-ascii?Q?0mG5M3xe3BB7Fyu9BWgYWeUZ6Ut8CtIJke6vOABdFfDv36/LiU1QS2l6NY23?=
 =?us-ascii?Q?Fv9CN3uhMgk6HR1wkH+JZn7Zj4ky53sE13NUW05cZ6d2z2SxZDBa6TztLa1j?=
 =?us-ascii?Q?L9hNSfhh/TAgwW2qI9DSu6vmZ7D1ALQX/KCbLNn3v2Ts5OkgRQhpCEwC3wpc?=
 =?us-ascii?Q?a0lJRwTqaxNDrL+cLitzmQhznXbX7h81XKe+dNuCdT3fOLE7IVtty/axj2MJ?=
 =?us-ascii?Q?EPQTeo7cM/pmJ8OaFkGdsTkQEHi9I2CuT4oIYGZwbYYm/Pn/bK1/LWD4DtWP?=
 =?us-ascii?Q?qkBjUPFnsm0ApjO9M7vJZXBUxJixUNk06eHfG1qMiQ1xZrKE94zuP6nJ90Cp?=
 =?us-ascii?Q?or6jd2snkEGRp7YlvzKfpGuUJBwdXtFXDIJY2V6VX8uWmvIwsaIkg/7Oa5JF?=
 =?us-ascii?Q?BkgHKKD05IVc6TJRV9R29E9arUkyEk+9oCJYV6x5hEI4aj+nbhRL2YwYGsr8?=
 =?us-ascii?Q?s/Fwiii63gEfyb47KVipOw9bk9N7I0p7pBCoHhrWI7rui8F1vaKInQ1A7Qe5?=
 =?us-ascii?Q?9tTjXiAiKzzuMN1aRZ+7TulOhSN50fy/t+nCElbvcbqrwnbGUh7cm4d1niWb?=
 =?us-ascii?Q?Uc0TG5JAYD1qU12+1xS+8v17loLrWxcH3aclVtUIW8RW71lkevkj2ifr6/tP?=
 =?us-ascii?Q?KpPsKDyMW3cVtdXoAe5ixady3Xzvfx0GxNFq8ER5Lwp/4NlaEhz1dMhLlrBw?=
 =?us-ascii?Q?KYBeq7uc1ECvctVkUiZBiFLKxTNittuZj0oIP6tHjdeDPGI4pK2JZU+vHgoT?=
 =?us-ascii?Q?6eIuwUaeev4uZcFTlA25wdOylglKVTY13FjkY7NPVpmRR5yfFLFk0X4FVNMb?=
 =?us-ascii?Q?Guq7WU+PADeqIrxUsoBoUhS6rqvbYtHb764SsBxywDINJYhAggSkFYAthtTO?=
 =?us-ascii?Q?pnSV33CsEzjShjr7TW4WMuPzbR323nvi2f8uZBbXVXYpHE5NAqhcvicbkFJb?=
 =?us-ascii?Q?8nT02eohVAYVWp0jrs04Ahn56/0Eiy+6VZztCDu1ir/ZsYKK9hbbdRXXJMYx?=
 =?us-ascii?Q?txO5yl7dHCniT8jnGbOFlJm9dUKFCoWqemVJyXJoopTYD/5gNSPl8fTKlT1m?=
 =?us-ascii?Q?13wCxrA8ZXkEh9dHFfAsk1iAHhstPOE/yoXX+WDs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?g5KPeQiX/uB62/q4L/BqG2iJ1u6lANv9GWVMiJB6eqgORMwrkaHc3uJHGRNU?=
 =?us-ascii?Q?reqgKauvQH6lYwsRY/3wFqK+sXrLHi97+cszZDL1iub2KNdy4wRPQTNYtKz8?=
 =?us-ascii?Q?ZpLqYS+fyIdU+ArjVsC0rV9i4WeKVRRcu0q9JBiLDhy/haNjZ5p7ATs2RZPP?=
 =?us-ascii?Q?CicAXThCVV/lfYoCvLZXVZXdnQ7raM0Frc+mp8tCY3DW8CEookrvXlGjC0Mh?=
 =?us-ascii?Q?U/MliznQ7uehtmWoeMUnUUoAQS4lmwY/8Nf4CQX2guii8ANuvuETdPMP8JLC?=
 =?us-ascii?Q?Wvw4pWKpt4vB5x7u1rTAvrgybRC7sqONEBrnIkBWMCNE9aBdPNCFVub62iFz?=
 =?us-ascii?Q?8wwuQxJgb7diQpSNAy6Qa5XLwKLaR3WXvHWFGwjFFi3PnZ3q6pIRAGXYN7sR?=
 =?us-ascii?Q?/n8PuE9wbFHBZSts5F3k9AgLuae5YHmKGgbm89uishdB25asZJml7ZC3SiEU?=
 =?us-ascii?Q?jNUrB4R+BIlSu+QWWMw+QokwAff169FQtKFKXOvs10cVUK9+v0DRjLonqBpA?=
 =?us-ascii?Q?LOFVSRBOm5wXiFUnHyaPkQTZLOup310BRvjUxY8yrs0lVkBFWuH/WNOLwWCp?=
 =?us-ascii?Q?uxkIMO3cnDU1OuP1KX69msX7lGNAEhubdV4/D+ezhX8w2PJ5kwfJRs64E9Xn?=
 =?us-ascii?Q?HGasN/XsqgZyup4QxP0PHTm9mFkM5NNIqUtujcQdkSebf3u5y8at5BR10/zj?=
 =?us-ascii?Q?mabAfD/pHoiiD5lcJNgdYr92qEZorEPkjXWJeUhCxfvutHVTSkSxOMCF6o1m?=
 =?us-ascii?Q?do5BNX/zj3jXsaj1SKpUndhYRIH3qIL1TXBq8l1vLy1VLSvvUlqk+pyeBEiO?=
 =?us-ascii?Q?awk321s01O2+DdMUXmedewk4Wo22y0NlJStqIK5swpIhEXH/hnssrXmbweYQ?=
 =?us-ascii?Q?l815WWXsi9XZAod1JitAEEjXNbBoXC+BezstgV339bxd0jU6IHs6pe6DIBIL?=
 =?us-ascii?Q?4LXGtMKsU3pNf2t7KHxjyf3zsR6OoE8XXfbNpSdJImTyUuOb8Gb90+Cr9KJJ?=
 =?us-ascii?Q?aQpsRcjknVanPWm81HwDuaxd7WYHS+npMSoUubeWMIuIEAiK1GeSbNXB/kRS?=
 =?us-ascii?Q?LK6ByBalchKkERGtIdyKhkRECn58xLH+wB5QRRb1Ote6VHtqOXtuDMVkiiB5?=
 =?us-ascii?Q?sKntHkCZ+y/NlUeuJ+4bR2Yu+L9n6gJwdjxlFCHD8qPWIQ9PHYE6Scecm8fX?=
 =?us-ascii?Q?cs+eC6oiZUgr+QtG?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb5b44ea-e21f-4431-a72e-08dac6e74f6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 08:56:39.8209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oo2mqKXDidUcUH695uSJqEkmXm2CHt+LCAYMYHbCsTTtQSY5paFOQw/KqB4tMbJ5GqREdamWdSNWlpPXTW3+GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Wed, Nov 09, 2022 at 09:29:47AM -0800, Bart Van Assche wrote:
> > I'm not sure how to interpret your reply. Anyway, this patch is
> > required to use the encryption functionality of the UFS Exynos
> > controller. The "vendor-specific fields" text in the patch description
> > refers to the encryption fields since these follow the data buffer
> > when using the Exynos controller. Although it makes me unhappy that
> > the UFS Exynos controller is not compliant with the UFS specification,
> > since it is being used widely I think we need support for this controll=
er in
> the upstream kernel.
>=20
> The fact that in UFS no one sticks to the standard, and not one but us in=
 the
> kernel being more strict and your employer sticking to that can fix it.
This part is usually done by hw.
It is usually acceptable to temporarily use quirks while the hw get fixed.

Thanks,
Avri=20

>=20
> But that's not the point here - the point is that such fields are always
> implementation specific and never vendor specific.  Any particular vendor
> can, and often does, have various different implementation specific
> derivations from or extensions to a spec.
>=20
> Just like there is no 'vendor' driver as there are plenty different drive=
rs for
> the same device class from the same manufacturer.
