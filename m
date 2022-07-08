Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EBACCA47B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 04:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbiGHEQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 00:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHEQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 00:16:10 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760D625E98;
        Thu,  7 Jul 2022 21:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657253769; x=1688789769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ygwc1tThcfGKXgAibHVPHIyzgiOlEYO1cEpUxc29sz4=;
  b=lgcG9z+8MoNerIFNJfQaRMih76BXLTAn/Tdmh8Y0qT/IfJmreyFKagpM
   B6lu5w6VyGer6NkE2AmbX9Dh7Fls/bXXxJGNePJUUFI9PnLpXtou9bbPU
   Qx0cuSZBudbTlM2GmqGopn5cGi7OKWAMrfwyMAWw3Dwn/dYozjDMebOGH
   Y7Nmym/iGuaBD5NXdhqZlVilPT6pr7FAOvePtpNl9k2GX7gYrFhb26pVg
   OVtLrCKJdEBpWqhkppiFp9Kr/6xfoZBdsEAm+r+A7fBLDee2DDfpo5bQ3
   lQAOKIHq5zY52TsQgozvRXkhkmLdoyWaQg4Zi9QxUgm7WOkmZ7zEMs2nM
   A==;
X-IronPort-AV: E=Sophos;i="5.92,254,1650902400"; 
   d="scan'208";a="309486087"
Received: from mail-dm6nam04lp2046.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.46])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2022 12:16:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zlb8HWRMmDIH1F+0vG3ikCZJ+JksRbx+S1VTwZuMyVZucLkQVTyu4iWe4yijGR8dwpSf2VJK20XVQNUQpw0wF39NEZGw9pb4nhrvfk+mY5hc/Gn4SsnvmFW/hSiBV0TVOQiyDz2+cq8vFOQ+TEELAC6Ay9DMUDnSplUe5AP9iCfirdPims66eHtCzOoz5W/7lkCep3MEstfP9mZCHM/Mx/wZn/lv7AWetlURInF6Q8m2aT4yEJR+gqStHdRhYz2YAPpVjyWMzzkzxpF+bpGN+R7ig32dyIPFwA0pAbiDd7GreBWDejETgYlp+oDbW7ba0YpKVV+1dZVHa8ZisBzU5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uiJJBAgTaOGnd6jBRDtUwDyKicEznBuNFEUh1zsn9w=;
 b=dQ9H1l0D0Dxz3BOox+SLGIe8MF4Q8offhqd0i8YdnxFWRarRzJB5hn8iTmqtG05rhBuCGdb2tpd20u7iG7/b05kMqKQnOIFds5awUINNkpAfxyX4PaCae+v4n5dtjoGzvn9sfGdpbWpeCbbP4+nk0HuMfHYdTxsoe18CxnbE01mgDl9C4bNz0k6zUGV+uNiQIuxikziXwjiGDM/+GqbvVaX78PWBI6bYsDx2x+qEIVdtH/M/IUbqildh6kLP7LoWIC1jyjhD+TID3o90ng6khPUM9esA//PpzlWs0/H4kIZIulGEws0UpjAQjmWoggjZZSfoxATi8J3WYQ7twqzbCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uiJJBAgTaOGnd6jBRDtUwDyKicEznBuNFEUh1zsn9w=;
 b=VYRTDL2bApj5tmnCj5TABaEJH7NCbRQRFX7yGRHtF1ez/v2mUWBiETl73cIXM/oUdc1otwRWQFf+I3TnDNmoeCiTTBZ+1ATI3nOnxY7DrgTLTDlGjtCPTMSWizbOPH0r3UKPqXfibdapP2KFv6upBf2MpOsSHtis2DHM2ZdCxjQ=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CY4PR0401MB3666.namprd04.prod.outlook.com (2603:10b6:910:8a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Fri, 8 Jul
 2022 04:16:01 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::3cc7:ac84:d443:5833]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::3cc7:ac84:d443:5833%7]) with mapi id 15.20.5395.021; Fri, 8 Jul 2022
 04:16:01 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: clean up zoned device information v2
Thread-Topic: clean up zoned device information v2
Thread-Index: AQHYkoFuwNMgOCV5fUetRXO/+tTtxw==
Date:   Fri, 8 Jul 2022 04:16:01 +0000
Message-ID: <20220708041601.pcefrofpmiw4lht7@shindev>
References: <20220706070350.1703384-1-hch@lst.de>
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae156ea7-edd8-4397-64bd-08da60989179
x-ms-traffictypediagnostic: CY4PR0401MB3666:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ij/k3dkeguR8fWaB4R1JcRJTYvMbAgew0lS7xScUkhomx4n5LW/vXldC/48hxmgyIwMnN0C79JFLbk5/0VYB+Ta5ReM/UmvlH+q0wXF6c8V/znE2L1yshXWR2CVj591+bhOVNyDtwURtQxQpO16I3HuR8gIJbDhJyJ0d6GdGMllnLIVSsLZ6Btcb0q1vmdZECFHjNLEbQBOzCi2nBgLxBe4wMq+mqnw77yZgaCzRgh1mPi2A/TncIh6ZcsMCGHx8/2/2OVXykTD1Fa48jXEe95zwEs0qJhDKDtRGlQPwRSTQUCrr9ZypApq+6uS7HxavSAr8nqxrem+bYucMrfToOZ8f1t1phCs3gQXo+/9QvZJmbkFFdv7yTrOn/C4LuNCzDXh66biG3zP/5gxgTElR4PGUZymepkpeEn8LtoPrijm1pihrJoaSaUKkyoS9OP0hjjiTvncL8MyniKBmIlsZhmTsJExrazLvyBD8sP7enetFLay7k1Ch5AoY4f+7vMuOjzBjlzqq3KQQfBxygAe8+cCrYWJwr/JtPdfFEbvb2iRsdmT/M50DkaU1O9Bcr0PvMdr6eO2BVWSj7EogdIAmDkoWKwEuy1jx9syd0jcnk615gx0rzSVerdn55EXgG0mMS01GHs+kC3oaQYuvu7vtEYzxnnXSpLf+OjPfFwHRim+A8KZSrAtLjTAqSjmZ/pNgE+Foz38A4BtmQBGOjwFVlT+sd5HYYK6Jeh1X3AW/MEeS4EjR1QBlbfgHKcO6LnQ7lY3B3yDt2cf/9PZmM2x5AcNG9z1aQumWq3/Mf3s13hMMkcFBMERsSb+rD2mPWymS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(66446008)(4326008)(38070700005)(8676002)(5660300002)(66946007)(33716001)(66476007)(66556008)(64756008)(4744005)(91956017)(2906002)(6506007)(82960400001)(26005)(76116006)(8936002)(86362001)(44832011)(71200400001)(6486002)(6512007)(9686003)(478600001)(6916009)(54906003)(122000001)(38100700002)(1076003)(41300700001)(83380400001)(316002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9iub5NZi4lsRBhj2r0QoVxmkoYZERlxQCx+AgLAvFr3+9Qhgnnkt0tB1Y4+h?=
 =?us-ascii?Q?9+4XiWHftE2EPGmgEZSobmdxc7dkebEopN8UaW5i7g7GGj/EsXOPuyYk922L?=
 =?us-ascii?Q?Rzul9tfqs9Wk+ERmBhMILBT53Pkp38tpp5bCW5pwivJUdf32mp0e1KbiRjm3?=
 =?us-ascii?Q?e6BzFPE5/KbDXSbGYvJPAq9KcD1C1AXfXXg2tQ658jVoTgMDQNLuBWUXBYaL?=
 =?us-ascii?Q?rSIEfl/rshut5tVHgtljKrYQgrz2xsUqvPp1lbva12VKoJCB0tf1r1Q41nkJ?=
 =?us-ascii?Q?IOvl8AXdn2AJBaozsgVVHcA5FbK2lUpvLKdjPnMs0nKkqprAkzI8wC4d7IEs?=
 =?us-ascii?Q?OD/1YAIUpRl3wI2D+8sa2IQlMs3PxzLdJqK/ANiJakQSfmxEo6b68iTKFAFn?=
 =?us-ascii?Q?4yKsAHOVm4ZOqWo6eHtT32Lba1780DBMTXcAjgIucEEBdeljoD1CSmiV8DQN?=
 =?us-ascii?Q?yYNVsrZN9jm8oc61E74LWdB0BCpJi7UV55tDPvfOv9+yAnvtzQvOnzgNDcev?=
 =?us-ascii?Q?qyZ996tytN03wC4GX/tAZkoKSnhakFAxnfHYA5Kt6puYkgcZKoBuYMrXhbJX?=
 =?us-ascii?Q?fUrKop9+xWKmxU4Wn9mVdr0ZrZ3puhK6Ej+o4jeZKRp0YI2rKiJtn7Y9PNDm?=
 =?us-ascii?Q?/5bHf8XSqhg/ZED1m8/Ys7Jj32FfSgRYM/GvNPNgpLFY9hp06zPjdQ9VzHF4?=
 =?us-ascii?Q?wEOP1fT50GakxxeKOjo20jePe4Ghp4mAmbs8JBZenN2O/QfPRWR/Hu48mLOy?=
 =?us-ascii?Q?m3COcdtifvZBEQOioNuJYvfpqziV0NAUHl2PdVpMlM5KjO5QLuw71ga57p/e?=
 =?us-ascii?Q?MtZWEHK3HvXs7oPwc8J8Kve1hkZerJZdy1AwpVjGahjdmEbfKZ9sUrnj1gua?=
 =?us-ascii?Q?oVQPvrVK4qkGmSggmYCezzpzYda2bhMpPQa7WO9VA03f1AxGWdMj1GM0zuwP?=
 =?us-ascii?Q?/iiXogoK1w9crJ3SGASgfp24Lw4RDdJk5J4LUrx9ScOJDPrI3N7/heFzfMU1?=
 =?us-ascii?Q?bDZV8BiVrV7Dv1XxJeMRXLy2N6fwrlbdjur6vc53PIm22PjTtu9btyBPUct+?=
 =?us-ascii?Q?K1rWMTpQUpsuwI0/dkBXfGZ+TsSbFaHwaM7zz0A04FrumZpLYwAUHYBqChGD?=
 =?us-ascii?Q?gsLtHf2VsdKa3Je1RP3Nq0Q9+93fFGd0grmnHe94SMI9cn5VxOKKHM8yYDdX?=
 =?us-ascii?Q?kk02pZh1zdNzmIziDG90rftWwigkJS+RwJgS8JvwXONaxl1/ocLSrcVDVvro?=
 =?us-ascii?Q?yedRojcVU5ddy8tGmsrhH/shVlkBeS2W8iE2ubdL5gRSIPGguaoDelNsuyFF?=
 =?us-ascii?Q?JaePYKIyDqcTqsbae+KYRuS8kHksCeoTdshAx4bWhWP4yJDTIoGtkGVZB73W?=
 =?us-ascii?Q?YQ3MpjHIYYSDgvr1ldiA931APKjJ3ZA3elxM0eQzD9pQ5agp+vmzpwMJdAf6?=
 =?us-ascii?Q?LuUrkCxGGdponnYK6iYbS7TsWIatYhi/OsbwZN7Ij671wy7e9ApfShUUXvbj?=
 =?us-ascii?Q?NSc6txv1cD5ylXfGi8UsqvOPjYk+UhbGcXQ9gJzcASwXPFdRzofAN0GQS9Mp?=
 =?us-ascii?Q?pNO/1eyM/uN5gbbolr4IC//YOP9hgNn5qJLOSaYsuDsFtshSqmcXCju1sqME?=
 =?us-ascii?Q?onrW+lwZIsPNeZPocwVYXGg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA45823237EDA34CB0734B5D410AF553@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae156ea7-edd8-4397-64bd-08da60989179
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 04:16:01.8137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s9dkYnsGl94sMY7RNZw75Be52OPPuYy2ZqpY9Th8/0s26rR6zQ9kOODGhj+2wCEBizRovrCTqXUPXSxhkHqsQjvet8diAV0KXlFrroKfxKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3666
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Jul 06, 2022 / 09:03, Christoph Hellwig wrote:
> Hi all,
>=20
> this cleans up the block layer zoned device information APIs and
> moves all fields currently in the request_queue to the gendisk as
> they aren't relevant for passthrough I/O.
>=20
> Changes since v1:
>  - drop the blk-zoned/nvmet code sharing for now
>  - use a helper a little earlier
>  - various spelling fixes

This series passed my test set for zoned block devices. It may be late but,

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Shin'ichiro Kawasaki=
