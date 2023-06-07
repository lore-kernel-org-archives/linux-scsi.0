Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A4CC7EE29
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 14:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbjFGOwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbjFGOwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 10:52:12 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87E41702;
        Wed,  7 Jun 2023 07:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686149530; x=1717685530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jg8xsOGleeY1pG+a70K0BbDViEQswcnCv32N8tNkTxw=;
  b=lz33IyKNE3AYud9XvUwxbQII7ZlmbXc3kgaJX8DZvjh7uSdJS40ang4d
   ctyiPdosMXDlC8d07fHrYAkYokogvZ388R139ovkhzc7FHAaUAOmuM0xJ
   AuZxrAP2G8884/ak/kx0N25WAmDBYOEs18M8r10EmrT6r4ewvj31qLivU
   XBche1iR+jyzDMOythfdwIGn9UBFcnl/9msYWCH3PYiy2wXwbcQJN7F5c
   8G0AgWXcXxBtnqLB7ddD4CGNgaFjSqjJAOP9GHWBFMimn4WwzRo1ykC6z
   OZoX2G4/XpeJjGoflazlSLt4WLV66EI7jNQ2M5N5F8jElZ2auccnl6ilM
   A==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="337553524"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 22:52:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=St8nksoOpudRlDORfbQ1fxiPSkoTGKvIvrpFv69RkjFhpNHfKziOzxFHGCrsCn3qQNFg9yQDQRq3aKP8HCe8b2uyVHq+JzO/qR+tX/UqTmVQ7wu15qO1pXe+pb3DiNn0TiGbjqJEa9LmekmmbSDK/irMgSVIdBI1yCldcM6zHR9N+ciJSsrgsfE+K8BOFqxzl7D8iQaghlH1SPqBgC+OYghvdufKAGy1g40TWtJfWPn0TIOMM0vTkHgc6cHkHrGmg1GvFCHx4NB24MNPjN5RJ04B3WEAGtCMNCynmaq04nBx1hFCw1bOdP0Z+Rm1kTTpA4cC46vGS8xwC9US4wLRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDdOdTVSbVSE5EzFlwvlSRawN03FfHoAr+1KxyCEBzQ=;
 b=AW/W5xPL7pYlTVbB3jX6//xVyatSTfYho9uNzI+NaT9lQPsba9StlvEMUaakfREnYkYyG9+k9OBKUFYsxVrKCxpE6JjMWNQ+Qe2tFaY7JycEco35XuUTI20w5RmBcBrvsM1QY0PcBtvDW2iA8HnajJK4W38yeM1JuDQ4/M3FpMtmXvmhu5YiZMESH8iTGyG+0b3Op+41jcckJdFxGmW7cIZfulGZCbj2CMMSHJzMuqi7gNuEjmnrIJm2WG12yab395323pAc38qAguhDaNHbghiAYKrZhb8WohdESovUa9YZs7W0o6SkxR0edAnIs1JCZ7tYDPJ/5Rf4I/xf9iHdhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDdOdTVSbVSE5EzFlwvlSRawN03FfHoAr+1KxyCEBzQ=;
 b=ao6gKK1rvTBxSGRbWrHLKCBhkkq8GUkyA3QCfrm2edOLGUXlGxeOcGw8PVKpiA0zEoSeT/kU5I5In58oeO4HBF/PZ6QSAlvE+jFUERFKNZZn/U7IIE5nxwirO0SGEaRrEpHbvMCdVk2aISrHks+gTC7vbvf55yqUHAnuEsriO/Y=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by MN2PR04MB6927.namprd04.prod.outlook.com (2603:10b6:208:1e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 14:52:06 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 14:52:06 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
CC:     Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 1/19] ioprio: cleanup interface definition
Thread-Topic: [PATCH v7 1/19] ioprio: cleanup interface definition
Thread-Index: AQHZmUGSbVOn3Rtvd0SuFTSJlhu19a9/bLCA
Date:   Wed, 7 Jun 2023 14:52:06 +0000
Message-ID: <ZICZNd6kKG40Lc6W@x1-carbon>
References: <20230511011356.227789-2-nks@flawful.org>
 <ZICB45/Mghr/rr6/@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
In-Reply-To: <ZICB45/Mghr/rr6/@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|MN2PR04MB6927:EE_
x-ms-office365-filtering-correlation-id: 80686a73-ddce-40cd-3f43-08db6766c368
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V9BOm/TAdsgdsTyIabqz0+SNYuPHArKTd+aZhFdnju2bti+Jniym9HgsUG4V2YNpCRm4oN4zyIHn4NwBlOnbXNKK8e/ET9DViSzK47FySN/QGIp0y12PaHQgWxklfEjGFjdz3ybtn9DRUz1Z+PctypcWVsPFxQ/mW2eBx+9O7+Veuh1yNx/YbAW9jP/U2LZaIDtovRH3ElDsPOx2hQaa/pc69+tXSZs7HLLv1UXJY22+FQKwjTt7vHgUK6Eu7XlzVEHSn7LC/7okpE3bE6tbbTl+RNaGKRKBwDfC4fb9IbVguxfTQmwwOekid0KVDZx8QTPbSgxS7DFBtSTzJm+Jf4HBensH7VynJEQR03G/58bh939qpMixPdeTaHLayuGSs+vn2SUch8nEN6QCx23C7haY+w8BXXE96Qm5Da/HnwS1gc7pvgeoEt3m4CaZllRlVTdxbTzd1n8HRWoWlG08zhQoIV5dmh0HzlhcXWH2jtKD+HxWBIfSuOJBxclKg/ZmZNfIUWwsZNlM5TNRnwdsHDaOLxAUS6D3DPZpNtX8NOXXxlur3eFZ11b1JbZP/3fdV0ALPRYixN0BHm3+EqUNZZRfDdDQ/Fc/48HP1HrCUog=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(9686003)(6512007)(6506007)(38100700002)(41300700001)(6486002)(26005)(83380400001)(966005)(186003)(71200400001)(478600001)(82960400001)(54906003)(66946007)(64756008)(91956017)(66476007)(6916009)(66446008)(66556008)(316002)(8936002)(76116006)(4326008)(8676002)(122000001)(5660300002)(2906002)(86362001)(38070700005)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NU9SgDfCLjuk69UvzR5VUhY/RUm1aZr9HHmoEv2JlAIr5/VmzlTmQpKxZHCK?=
 =?us-ascii?Q?cw4IYYzYC/4EoJXl+D7+7dWb8LY5M2cn9RsjIgXZQNoYYc/7i3CkoGEVT0kX?=
 =?us-ascii?Q?1jU2+MwgglzJMfPNqnngxPidlvXzfpRE01ZhAPstl3V/CKQaiHccLiuTuM4Z?=
 =?us-ascii?Q?obbtkytvZv8ycHuEuTJvG+CDzOi901xCQwxazYl5Ylx9jZkuXAHtYXx5zecz?=
 =?us-ascii?Q?1nMFzt4M3hexZJrOo1hxY/4DiKhF99Ap42wgI1JkBdQExqvJFf9zS/qQ6T5n?=
 =?us-ascii?Q?hNV0x2ablraBlXLIywqYt0KLO+sblcMglyw9X8G5pzXmxz7Tis9CRi3CQPEv?=
 =?us-ascii?Q?ByPgFyIO6GhppIdEoUvaC6TjGXPkRwK4BssYGyPRWY6xicsGIwNxcul0qK2e?=
 =?us-ascii?Q?ARafuaNxgRekk9vLhUAmT7ooEc18IATK83gypJuAZVamJqTLR9nXKsibmb3R?=
 =?us-ascii?Q?u5KI0gZrfTBGy/srRGkxJnTN7fGJZuaRQVHl7wrYnurqt4J3wWSuS0gHolVZ?=
 =?us-ascii?Q?AJoGO78IHS8jMeES/yncGMcftMV/sL5Ij2Ni2OiURUxt1mMTTTHBD2C/Mlq6?=
 =?us-ascii?Q?HB9prHDsQK43ZqSue7TMemJGr4m1cU7P7tPs/AxVSZe6p+4sW2Onq2H0XmxM?=
 =?us-ascii?Q?MkSKBPTq+FEtfX4qkRxgNIU5xL9GPPwFou1bSEZJTaEbuiYRDNOQVMB0XDPZ?=
 =?us-ascii?Q?Aa9qOuNYHIEecX06B0NNqQ4KtZDsDy1FJMdsyDpCycNBEOJYoH/r+YXXg34N?=
 =?us-ascii?Q?a61NGu/0iB2nNi6HJWqRuzIkE7tDs9nehkL2SYUybQ1GJN0fTAUyXtdHC/s9?=
 =?us-ascii?Q?6CKaidfupL4dJaaM1qLW++0q1FbhVWzYzkDkFry38we0SUBFCU3ZYsTRqkRD?=
 =?us-ascii?Q?FxLzI/1zTEZF7oq3cwsRIu4a2Tp3/LBW5TKJucvNSR4ZmxfVn7xzoFTuuUD6?=
 =?us-ascii?Q?23Qe1aP8rr98UxWqsln4EgKtB9vGXMpRAbqAKm6MSLrXQG1hY39vB8SPxJvP?=
 =?us-ascii?Q?GdGioMnxf1KmDjfO0dZUKyq9W8kb7KLhLdUiWQDomACeRb3ETd/dY7m4/AVZ?=
 =?us-ascii?Q?GUT/AMyuOQzN9HCVQ7jlK2lRlpARaL8YZOiN6gw/jWPNqvzRgvyQ5B0Y/GX1?=
 =?us-ascii?Q?NDkkhgCeCiXaW36wz99i5RpNvo/YS4TOL5m6U0rYAqApugwDTpW+QqVhg7yE?=
 =?us-ascii?Q?i98dgUJ2m+O51FfWTjqKagV/vfSbO0248yjdUgnGIAOcP3vJy8V/ye5UGZZ7?=
 =?us-ascii?Q?h7NT3oNcMWefIdD0vDmQU6HtDm6q5SCkbiBVofp6Vd8wO4Wm3p2VDham8Jwe?=
 =?us-ascii?Q?ECKlot/Kr3Sb7SkC+CPI5dfSMV4a5S8q29chokP+uIgdHn3GMlnuACW7zpFP?=
 =?us-ascii?Q?STcoF/15hGa+4rBDXDGjyHLrIqV01pGokp/TUNl4mff9roeBnIAPmIsyOLr9?=
 =?us-ascii?Q?YfjGRmQ/LTaTdT3+sCg6B3HWyH5Jh5uCiNk9cWNqzCUnpt/AR5RbuMEmsfPA?=
 =?us-ascii?Q?MkaDkhuThWjDfP7owScDm/jSSa3xgkgX228uL0GnHpO4kqAHLVBuxIcF4lQw?=
 =?us-ascii?Q?mJlRd6+H2ZuacliHyswOAHaP6gFvpxyFZmJGdmtfooEoaKOp+A7LohmgEmJX?=
 =?us-ascii?Q?ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7AE5731D4CF60741A786238A73CCA13F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +MNmVel06YehD14ZBZiDOdJejyyWIrWieZfgVvXweLlkT8jWHjA/CuPET+6l8umYf2F/ldfIWzCgG2pBMzGAPWnOuhcjkH9pzaTEd8k3XD8IUJuW+0cPCIVyOgMV1Olds8eZwJoA+3CD3NbJAvyt58awJyjE45fVapzhUYH511ysQltqe+dC9c2kT1Nnl0zE0+rE4eaa1i0hiHJ+LNVpy6b3IeSjEHl383/xZgZ6hfzGc1M291krH/s+SWdub1sQX+W9glYWYmGGyuHp+yyBll+kIPhQ0HqW9tTWPDbFMBwGmOTZQhjmRuKC0oV8HVGEZtz31n3jw0F7SFd/YCWU0iCLrJ+WUWqFSS1qs0zvuXS9G5wQZx3syNvnDkIBW5VCk/jNm2LuFP08vEynfzAF8inH7SBpey//kZUDAJ+T89ZLLo5JmK8+/A+Y+CzHufPSSw7GbtqsxYn2a5uOo4QuJ5jQG3eZ2JyR/GJL3lW6izg6D4BqMwdJl6Ki/gNIkqpCmUmpBzqEWlprs9F9eKwxJdzfb0KrmKAMxLnHUXeLQ5CdKrw3Iif0ocP/sSzdFD1gl86bsfBzAKVBSwlWDsU+ZggR9AXXtSKXgoCsktbYSOws/bTUbYJ0ROruuYg8Ia3VdmXy+F9IqTFKP9vv4XGM390q1vmOryZ67YdVpxyuX7UbglLq0Lnh+wHsNx9ZOcgQGzOdxrDgJ0azCooETWU99cbyDS8zy+QXSnukIlOMb93iH/uAwtQVkOoijIdM9d36cdCqEciBTClViSF5LcSgy8lzDUqhmfuSK8zoOD/y5ei1fnr/8pipxOsFMCZmp7qahP7jdjl5QT10RPvFehKPEKCZn6ejAhLQ24vk33uS6F8qh1bj2GP28B0gVb4jaJgHEkwnlDB/lietDUlST2+KgYareXgQKmXyfza8Qzvu2oI=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80686a73-ddce-40cd-3f43-08db6766c368
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 14:52:06.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDHd39MEmbY/r2aJRRJu90mLvKnkmNFFs1K703iLLIu76SIqMvG8f0k6vCYIFeKWaZHtfzvEYaq4n7e73h9TRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6927
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 07, 2023 at 03:10:59PM +0200, Alexander Gordeev wrote:
> On Thu, May 11, 2023 at 03:13:34AM +0200, Damien Le Moal wrote:
> ...
> Hi Damien et al,
>=20
> This patch aka commit eca2040972b4 ("scsi: block: ioprio:
> Clean up interface definition") in -next breaks LTP test
> (at least on s390):
>=20
> # ./ioprio_set03
> tst_test.c:1558: TINFO: Timeout per run is 0h 00m 30s
> ioprio_set03.c:39: TFAIL: ioprio_set IOPRIO_CLASS_BE prio 8 should not wo=
rk
> ioprio_set03.c:47: TINFO: tested illegal priority with class NONE
> ioprio_set03.c:50: TPASS: returned correct error for wrong prio: EINVAL (=
22)
>=20
> Summary:
> passed   1
> failed   1
> broken   0
> skipped  0
> warnings 0
>=20
> Thanks!

Hello Alex,

The LTP failure requires the following patches to LTP:
https://lore.kernel.org/ltp/CACRpkdYdtgcLSqovV-HwZ9PvSXFBZv5wdU3KzasMR1wHga=
h4kg@mail.gmail.com/T/#t

Unfortunately, the LTP patches seem to not be available on the archive.


However, considering that the LTP patches decided to keep the test case tha=
t
sets a priority level out of range, they also require this block layer patc=
h:
https://lore.kernel.org/linux-block/20230530061307.525644-1-dlemoal@kernel.=
org/T/

The patch would have to go via Martin's tree, since that is where commit
eca2040972b4 ("scsi: block: ioprio: Clean up interface definition") is queu=
ed.


Kind regards,
Niklas=
