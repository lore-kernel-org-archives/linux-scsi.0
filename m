Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AED9C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 06:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3CD206B2
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 06:45:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YuFSVlFI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XZw6jdrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHLGpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 02:45:47 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24782 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgHLGpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 02:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597214746; x=1628750746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b0hnF3YwqyHZUW9Xi9WJt6IEmtEzDhK8ZF+fXwBPi2A=;
  b=YuFSVlFI9TgNbnH99mCaJlVvKAdBskRg2S5FzcCEM5dUodR0brrzkqvm
   nYvsPzY79PEkuIdXYgD+2ZH/psFovHYE3//0bY0yomFvoo4x2s5jToT3k
   U3w35uNSogkTp74dnc5ePw7vpZG4+if67fkFdiScg9WUfTcrix7uZnXkz
   qdCEdsBMCwCai/Ne9l/OBQ3wa8Stp4z5Bneu8oXK4tZRmDvO8gQH4FWCW
   gcOhQZYEKNAwatqkJPUJMN20biHMs8kR3LB68hFx5xpeATlGq7O0q7Dlr
   Tg4YumKZXrI9rg5Rh8pNaI9sHMRa/q2E2FBP1Z/5E3XoCXo6jZ+jmdG+D
   g==;
IronPort-SDR: yjS1B3BeVahR9DQsfSKWZ7W9sqPdIwutkO7tauL9NQrSpUAC+rPalYvd1avco2ga6OGY0MnFEV
 RJ/jY7eA+j8A+45rSWSX800FL/2Vq41FpoLufJsWzZydKlA2MdZM0RemMkGXZF0OiPo2tvAwhf
 L8xUzR7BpC5P2XIiLM++3xFbV3sIQl+sQrEsClzt3888VRJ44TTT+tS7Cs553bJG7NYB9+SMzh
 UM9pntyk5sNv7sXzOKnHP/ROkZPn/dzgNYog+H4Swtur6Vc6nIOoHsVMciT+Sv6p9vgKFta6j5
 EI4=
X-IronPort-AV: E=Sophos;i="5.76,303,1592841600"; 
   d="scan'208";a="145967289"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2020 14:45:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aziecscCKV/jEOKqTk1Kyc9f9RXPBwFLNHO564gq113VhXePnszoSYxl1ZKWHuBGT2QaX5GFJfqmKdJluETMGVUOskF4ZcMU0pFvG+jc+bFUEa+CO4U2vjbiUUgOrOoEr82w5XsDtV5iWk0El+thUDDsox1k4wmFGWVekkp4E4BJjyiFNpmSBQsAX5f8I8uR37I5j1qzYsyerTVkXCD3EnKCkgLWQfdwj0HocdnoRdd18gRJmoi9gj/oV/4F4qKiizjt3x1amC1AofSkNymKJe/XquPkJrsrsy/XOwspFkf2ffX7CKH5hkbk9uj8jfCAIdsE6Tesmydsik3QCjU25g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0hnF3YwqyHZUW9Xi9WJt6IEmtEzDhK8ZF+fXwBPi2A=;
 b=TQIEJT9M4kUO4JTGvZiLxlFwzpr4zVUYh1iIGAw/Fbp5gpcKahraGpoHExZb74Ity8zz4iZaRkMJGmde5bCrGAK++iUSV6Es/yISpodbsohgys3hjFuwYfSNK/jRoAdeFhVMjBBLXx1e+GjWBtzLJiHH8LGqbep36AuMbERiASW42SLeBjMPYG0zZhUGnX8MzvecSnvUfD4U68JnxsixBotOtA3rerCuU3AOCrE+h+hehskSxYQdVde+Ts/Q58lQdXSwzFsssuBv1tfdfcoJZImktRCxwbcrUSzyLxnzFkh7SVa+yl16yYE0HCu8uxVbTWlIXhpbd76YAmzNlDXwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0hnF3YwqyHZUW9Xi9WJt6IEmtEzDhK8ZF+fXwBPi2A=;
 b=XZw6jdrbZB0PIDy8DiscSifPBWTOth0hE9PoZGfI4ZvpJYdZRxiM8vpE7rzNHQFH7BfjgrR1YaTf4givdpmi4Z6aSx+d3XBaOaV4zsfj4j4Q3NzFG32bZIrnvWCCc7WW9fwzwml+TjcPPtEmbeMVlapkRdY7anOFa1xd8ybtbK4=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB4102.namprd04.prod.outlook.com (2603:10b6:a02:ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Wed, 12 Aug
 2020 06:45:42 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386%7]) with mapi id 15.20.3261.024; Wed, 12 Aug 2020
 06:45:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH V2 2/2] scsi: ufs: Improve interrupt handling for shared
 interrupts
Thread-Topic: [PATCH V2 2/2] scsi: ufs: Improve interrupt handling for shared
 interrupts
Thread-Index: AQHWb+TvsvJp/LfZdkaKmEZGsnRbjqk0CGfQ
Date:   Wed, 12 Aug 2020 06:45:41 +0000
Message-ID: <BYAPR04MB462904A08FBCA6C8DE62E29AFC420@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200811133936.19171-1-adrian.hunter@intel.com>
 <20200811133936.19171-2-adrian.hunter@intel.com>
In-Reply-To: <20200811133936.19171-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8402b90-80aa-487b-1d90-08d83e8b54fa
x-ms-traffictypediagnostic: BYAPR04MB4102:
x-microsoft-antispam-prvs: <BYAPR04MB4102058044954901AAEF001DFC420@BYAPR04MB4102.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tY/1+myt+5FjeWtIcXnB8JYabb+Wq78v9SZMRkzS0ynFgyecCE+gpHPTpne50ww75zOb/uOWav+vUpYv8IpJJVYAs3ksSyY7xfS/FNXFrClY3H/L6vU3x9GMYxkEh5CS4W6Vxdl5mJWM5SyDajSUZk3SuI0aTFHmlnNrXV7XcR9p0hkycBjtEBTlSL0x+HTnjafn89/WSO5Kj5+j2Gem+guoesvcW7sj8c6v6BOU1vu0u0fWfQ5TuZEud+czUx26Y1VR2oDDqdE09mD7ifRUYcWQUbs9xRralGcejL8IoUdhSegvgRpsmkeUdpVJSHDp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(8936002)(4326008)(54906003)(55016002)(9686003)(186003)(33656002)(110136005)(66556008)(6506007)(66946007)(64756008)(66446008)(558084003)(66476007)(478600001)(86362001)(26005)(71200400001)(316002)(2906002)(5660300002)(52536014)(7696005)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8Pkb+xRRp9VZ6todl0nWC54+1cN/HEgv1EUBBzIkqZIxai/qGNW5dtwRohY6U2El1uza5JZ431BIWIlVEZTKHlaf7A85p41KnQmqs05uy6+Ad1DMrSYgWw+cBmvpfCHqa6hhSSf6ZsLYRQZP6E7NDLMF6uOWUgt0YVBk76H6W12ZRqx3xwRGpe5TIHxqOcbeY+OCTIoPRtVvtb0Vv+MH5FyZ6NvKJy89daucYTBB3qtweJ0eEk5hcKqlyeOxT3M3+PDmYfAy2ETMdhAGgTOboikWPMtNzHQ336txmPoZnw9+y37/bR2h8Ea8abt8OYWEQl9OBecyypBFqSJ4BFicVHT3L0jT/yPFiv0o/ysQYqXcHyIkvnHekCSdEQXo3zfMskrxgO0LzRqIf6EeEmqbZbsTtA4mFxY3mi6Jlu3yfeAEBRnrSIwgI3YH+DTx8mR34m0zeTjFE95twgOUIjy8hEi1xGeMFcj6kU5xgwtozemG5BKVNBlSK5K6vErkuEPSStbj8tIBKoqV/n88nBcEwyrhTxgRuaH/e8j0xQ7QKXQqmH508N64QirChZeQcfbqMJn/o3/rjiHGoubIzBgh6Hnb10MuqZ8THzDsmkN54oemvkXuAvsZ6bIGwfEIIL6Ur7lxMV+RyvaseShi91gEnw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4629.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8402b90-80aa-487b-1d90-08d83e8b54fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 06:45:41.8180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1bAxuUFLUBWZZVFFPgbWTEt4zXCUujeFXw7T4enD918+m8mXSINYM8nbUS483bD2GHW/8JrnNaWIwO6AtpQpow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4102
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> For shared interrupts, the interrupt status might be zero, so check that
> first.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
