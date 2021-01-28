Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A5EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D3D64DDE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhA1LTN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:19:13 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60588 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhA1LTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 06:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611832747; x=1643368747;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Ch6ewUuBa2TAX59mt1LzD+cC01Wes4S8a+IMJYTfO0aJ+B+rOKHzzvL4
   kLbD40hhb4I2bOJ2T9yT0+hry8t78VpbaAHKtRXA+b+00DIplZMMS/Eu2
   3HZ5DQIjsmasrt3Ngrll4yzgiBqDgVE8tgJubIsOz86BAM+thWRymKauz
   eeQNFYYptemQ6A6iAqKRebXmXBjy5yrVxjcHnEhcC/6gM+cln3QKsPpQS
   aHJ52lEMUzuwuCSkp00t6IqPHaJozMKZIp4iB1WXSllKvcCe2ZGWROOkk
   1pakm5HfQMSX/a2/61uHYrMel1h2phCC+SB03wVgQpzFFQmMq+4b+MrLe
   Q==;
IronPort-SDR: CCV4ItHhALHKIdcyY6yETU30afV/9/mXma8C3shB9nOT8XeMUM0dH8phHpk6I+MsuhW3ityngA
 xf+K65/FmTr5BhokzRfTP8CS39v6LgB6bCjvXQHG6q4g3IbhFTGAZ373zKCzMINJokXTcDJlQj
 0XeVYHj3khl83ycewB2029hzO2wDNKKYHRFiCxiKbyt/fe9Zrz+HlwID43ZMTqgWrqSH69oOUQ
 ThP2N1xL85uH4o/sdALTk1mQJ16jxmfSGptOnE8YZD8XQf8UolneIiZxlhPNWcGrPoST68D9BI
 +FU=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="159711749"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 19:18:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+v0nC7r7CQEMQttb+0rxhLkNIbW9O398YTaBaodmDmuYVD5e768UhK9VEuQsY0CsZBztdZ0VPfeIVxtTJfK3L38C6wg4sy39krM1AgTNEYy1hj67AF/XbMl5cWKh1l31CWYf7wh/Qnf1FSH7o9YmB+CPkj2FFJaUi/jr8G0wrYxtjC+Y4OcjAz9A1iDLvE/3VcXb7QKrh1GDMiiTcpmx73snDkq+rSXssaIGYXzavFjS13oXCa6xZg0ZTcoKlWXHa/UN9EjD5CY4LHzQMZTxfDlaFBkj86eF29t1hE9C4+zUKxQ7LI6pki9HwEACfjNRPDpB0JT8Et3wuHdItfcDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=KkuVx2RIp2u4xiN7F6hU0XJ1qTV4mK5s9cBmMwv5QY7U2BOvZBeuThAFnkTLIE4D3jugt63V8WFBei3uuGUFPlHo7vXsZAffrdWNofLur4pkivi2NJYjDrN2piMIb8KD3KUc3K+7l/2oCdnAyofyqpzyenFRh+RwMO1gJffZtDYp/CEkuyfGWyWffDOIV07pdwCbXNhESp+PW7BxmXoNTVSBHiIhH42L7z0cnNCf68m3gcQ+m2tssr9FYz4c67Yyhwtdis0TFe2t38pnu0mDqD7P9Jh54UrOt+UjQXIy1GIVIiXHzjYYPj1KXXxQScmR90MlDlRA6f2iXmoQnFp+cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=uksBxf2/X5FJIFhFxWBMavCUzvsnGJuo80ilRknNS3RDGBVC5C1hTfJygaJg5A41rBTleLMDG18c2FFu63k9HVbV3WJGIRITSVbd0KNQ66iz4fQUz8iLY7OOzAqeC+l4FCWiXZ3AfWYwRzYFs3/rX9Q+RR+JO94PXoIBve4VzcI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA2PR04MB7612.namprd04.prod.outlook.com
 (2603:10b6:806:147::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 28 Jan
 2021 11:18:00 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 11:17:59 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 3/8] nullb: use blk_queue_set_zoned() to setup zoned
 devices
Thread-Topic: [PATCH v4 3/8] nullb: use blk_queue_set_zoned() to setup zoned
 devices
Thread-Index: AQHW9TEjxYOLkSBrOEu6ZKQxC1wemw==
Date:   Thu, 28 Jan 2021 11:17:59 +0000
Message-ID: <SN4PR0401MB3598C3C81B68C794535E2C959BBA9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-4-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [62.216.205.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 636979df-19f5-4015-d313-08d8c37e5eeb
x-ms-traffictypediagnostic: SA2PR04MB7612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR04MB761232B1159D36A34390FEE99BBA9@SA2PR04MB7612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bfjUa7nKK6AN7tSYFt3L723cUjeMjpQ+erZoiSXogxO8Bkt7W3RNGmyMb9tLivTMDhhUFr5sZhK3/LopT/jKdgu40ozJyDIklj2Ej25oyc5VersfypebSUDFUgqRnL8wuL2I1sjgv7pdNGejmwFbBhDaWjwOvmLXzNKic3HHck+4w5minKh0apDe0wAtnHLU0dANABh8UCNsXO4+53r2WXx//OrWZKre+S0nBWQUgZ8oismJF38ZSYUCIMs9emihPgJZOXCtgIEz67D+G/ht0PCmxOwVMywW5IOyZxpua96gHUX2EcULACRj7V8uoMeYC9NNWevUV3IXxyyq6sPHUritTh5WlwSXGMionVNWZ2FMvGhCO5P3a2RAwFn1Bp4AmKlr7Uo5W04FBvetYREOVhtyzHTWdvDk/wSvPGBskvdcGewUn3G720DeAcXcUMuSPBiNQO+az7Na4Gl6nLPoh+w74ZBO51IbpAXK+NRs7ogpBYD03Re+FKSdvjv0hIvBCh2XBDZ0uslccaKIHhKU9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(9686003)(76116006)(110136005)(55016002)(8676002)(558084003)(478600001)(316002)(66446008)(7696005)(52536014)(91956017)(2906002)(66946007)(71200400001)(26005)(8936002)(54906003)(5660300002)(4270600006)(186003)(64756008)(4326008)(6506007)(33656002)(66556008)(19618925003)(66476007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QXBOe/bviCp10IrcfLnE71no4GNsj57BP3LVjBXdB5rB3VJcs2KQf1xYj/eG?=
 =?us-ascii?Q?uXVsQ6sQEP5luvlbXM+zI9ON7E3V2WN/5NZ8yw08ojyF6cVhaseEyjX1m6Z9?=
 =?us-ascii?Q?MkKKCAVooWGF2H3O4Ln9L1iTVX54Qj91N4oFptNEzw1Z1hqVgl21w6x1fr3J?=
 =?us-ascii?Q?48vjiDsCMhqkr+s0bW8itBUu8vlF9NdZjQwXkJ3U+fwLd7Wl1dRdY8jvWXy/?=
 =?us-ascii?Q?E3DqypRpFHxqjDy0UlN3zjDuZfo9YQIIYTwQoEeQzs2dHCPHtmqZkHJlaVbn?=
 =?us-ascii?Q?8Wl89X4jFazq/uC4ZaSq167d/t20BluA7FMkWvgOMn8euF0XdKIbUPWnaURj?=
 =?us-ascii?Q?hPuvWPg5yUT/iR86SGa0dbxGJODfTjecz6zUKJAKhe+pbf3XM990yg5uotB6?=
 =?us-ascii?Q?6s7PatQw61hzsEleEPcRScAZZQBAUKETd/cZvgSyydQj+p2yQtQke1Z9q9X4?=
 =?us-ascii?Q?VOZZKrejkZFnmNcfKTCSA+A5czajHIaHvIlGEgxVXyWEQeO8Hc4MSRwKwcRN?=
 =?us-ascii?Q?vO0MB0K2bBpSPQxhaVuab6yZO1gjWiAPTU20KVW8dWMSaUBeq5GHbTZAnxiW?=
 =?us-ascii?Q?YFrdh32vdAlC7sFiFYgADLsqv+Awhc93MC2I8J9FbQpBiQy9apuVUntp8o3N?=
 =?us-ascii?Q?c3VCTPRxVNDdd7JXEr+Eca3EPgLm/Zdhtw3b9nSpTeSrfGYumbTiKWLt2UB8?=
 =?us-ascii?Q?hCpDDplW2dUsUHbBBlKz9sUbTF2kRtOjPcgd2jZlBQ9BOLoHZog7YyMdY9Zx?=
 =?us-ascii?Q?1VwlU7HjAH/VNUilsw9G0/MIqLa9D7o3yT4PfLD8cTTxAjMMqVl0OtSEEL8z?=
 =?us-ascii?Q?di6lh9lQENK19iLO1EzAIQijGazDu6/hLAsgdiLxDk8Ywfc4+/P0ewSWYzvV?=
 =?us-ascii?Q?mocdXjyy80BSm6sg3cE8FukDN4zEgRfbJnTsRwF1KBFLccu4BEZ/LHKp3G9q?=
 =?us-ascii?Q?8OWEvMl5+hNHOvvMoazYXYoVs5g0OCVZn/dWe/KhZb/x8+jUcZEq7Y2LtkrW?=
 =?us-ascii?Q?OsFbxw57KVAVMlewp302lALUX8dvh2FJVE8qBNYX6VP8STrVSVvncq5ELtUL?=
 =?us-ascii?Q?WJqwmgu5SssQQZ6BobARHuvSvkaH5A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636979df-19f5-4015-d313-08d8c37e5eeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 11:17:59.7364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ngp0hiu32mY/kw+mdjWS5dQq0OAkEu4DtneWTlMBUw/28ghNOArZq8ntl+fMPrYHD7jyjjrkYpJVVjWis8UKuijWSmqL8IlM4KkS2ClRQl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7612
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
