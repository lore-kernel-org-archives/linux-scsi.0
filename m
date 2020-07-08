Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074E3C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4ED620720
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kYYf2MAS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XRdfaaBX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgGHGYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:24:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31224 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbgGHGYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:24:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594189473; x=1625725473;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=IfvAKSYYwnabi2+5lnv7vLmYYUe5AZaWcTjttNm+mIo=;
  b=kYYf2MASQc/RrGIRR4Jd3x15iye7sLlcOYI5hCmJoWZhaWQcsVTwBC29
   D/2BDkTPV/S/g1NUEFDJEzNY15lEaVOWX7tPsxPgUqyi62tyZ04rAhYab
   ZhtrTAYzOIxyBoaV9y6ozQqnY4zmaDMpvmfTi3/w552XHChoGFSZnlMjJ
   U106nnoQS+d5Oex063T4rrNxJIwLxa4I3S3qk1EG19T7xxlDp/dgYvBGw
   +BomKzXitQVA3TMq3ycuik5w45CvBlfjA5ETfkbV4+TS6c3hAaM3/xaLq
   AShSnegQ52ceNcVs1zCrb8W6QGJ+xP4WF/aCsKMaE9JbPZ/yhN8Nd+fef
   Q==;
IronPort-SDR: xZBUGiDgtI7irYoyx01Sdb1trAwLd0Bc1d8Do8kL36MbzX2j/8hrsDqLBNT7CC/Y1TFuvkxBGY
 5krwBd9geMG8XhPwgaBw3gTcGy7xx0kDfXa7ZDxs+XhLGeYUI1YgsGWwHhYcW4NbimKLWyT0P/
 afeA+DnEqGF43m1aUQ55Z4mmriZq3uHU4g0NooQPORkEQLM0bqdRTo3edPQ33NMPh87/GEojK1
 PwWT6naWzWNCIGJxDs1/eE9ShK3a4eUZhfOBuZYxf72jg255s0Qvm9ziaQOP27snYV15eNTkHq
 tYQ=
X-IronPort-AV: E=Sophos;i="5.75,326,1589212800"; 
   d="scan'208";a="141895292"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 14:24:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vn0FAIcevQh+c2wD1SIdyVENte726jhVvNhoJa/5xdCtRNeZS46VosdNw64VuJG2ipsHE35Yj8YzPrjmisDnFiZ+RWQxUbZ9rrwH/ps9TbNivEqCIKczGWSYuHIoF5UiLbCFn+F91EN/oBRV4AAm78mYTg3XscKcOwp8LZfB+vGMBE/N6YmykFlJVG6BugiifFsdKcyGrHJAfbxdHUbkoJOsUbs4FgitP7J1B95t1wrfa9gRqMDXQDPAaNTu6s2H7fYc3jobCP25/HIcB4vZXJmYTJwHR/Od+1i1itugofGsnVky931d72SyC6GPvdrt+wM+nXB3PYEZc+6b3aZArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfvAKSYYwnabi2+5lnv7vLmYYUe5AZaWcTjttNm+mIo=;
 b=mEk91ccS+VvWWjpcQ9Sv0upYZU6RGply5hW8i+LVSuLb3xXMiqrGU8M68MckhaywaiqyzBtclV4+mvWkqKb1GTKNEIBHQiQYy06v/jpe2FVI/Go30N3BM22OdINmEDn2VopfK/3c9k6M30EaJdI7bLC9+eynOcNEwmuds6z45T7/NBIl5fQGn87Y1htqcJz8NRs0cCUI5iOe9EUZJtj4XfLL4r85C20VJhwrIDIKzrlpAABnIIQ/SEsqRe1MKwjVMwe6TQsgXEBU+aHG2ck1Yr42Dwp2LlgKHqyt+nWdEzJnjHo6thgZAzLUpv2+rh647an+B78TM7A51q7A7/PBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfvAKSYYwnabi2+5lnv7vLmYYUe5AZaWcTjttNm+mIo=;
 b=XRdfaaBX+kkHuV2roWDv9DifRqKexvzyUxRzvjyPhr+fap39smIV1GJ7DIshDmSNLKkP889ZWdp8Cf4lx2kRXf9erWi5xka8ZlBlZm1j0hJRkT+iyoOXw9YtCW9eTGV6s0SIO2W7q6300SKullM0FHwyweqTo9mF5wsliBeNsIE=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0969.namprd04.prod.outlook.com (2603:10b6:910:55::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 8 Jul
 2020 06:24:32 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Wed, 8 Jul 2020
 06:24:32 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH] Fix compilation warnings
Thread-Topic: [PATCH] Fix compilation warnings
Thread-Index: AQHWVO6lyTJEF+xa70ydBmVTw6k6yQ==
Date:   Wed, 8 Jul 2020 06:24:32 +0000
Message-ID: <CY4PR04MB37514AB91F1C8EFF3411AA2AE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200706123344.451738-1-damien.lemoal@wdc.com>
 <159418844430.5433.1895709179695846503.b4-ty@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95b4c24b-c327-4274-b627-08d8230793d3
x-ms-traffictypediagnostic: CY4PR04MB0969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB096913582EBC2D0048AB7C7AE7670@CY4PR04MB0969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e5no6OaIGRPSF3xo962z8re6cxcgVzfJcTpioydh658ZADirKOQ6dD+EonY/3HyK/7DDFHc5RgFKWdjt1JyAeTmKbMiwjF/TmPwYZmKCAZzrCyJ7p2+OpjE6NenLC97kKZHRKT4cX7tKdLuuBnEXnnVOVInVT5+p75vyHUtVji89gdwFm+JSvB1ZVrDHJHRJTi93rhSxs0dKHRar0FtLrCSdr5qfhY5woeYqX3XxwUstO8zO/4OZOHPve5Mps42AcDRbJC/X9SZlMmTqVCHZQ5BQ1vX4Er7pWG/12oDNRRII40XVk2RUQ68Y5Rmq+ngfJ/v7PJnJ7T431k00WrvLMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(66446008)(4744005)(66476007)(5660300002)(9686003)(55016002)(110136005)(316002)(33656002)(76116006)(8936002)(64756008)(66556008)(86362001)(2906002)(26005)(186003)(71200400001)(91956017)(66946007)(8676002)(52536014)(7696005)(478600001)(53546011)(4326008)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JK2FtHM3IipA1iDZv69B1TIhRZ+1vAuWaDPtgGUbyy7L3R5en4L8hkMmJMIUAHSWZA89q54TJTI8oXLTUujsH+9D+Dtp+Jx6a1VziFnFef14cuG9qW3w8LjM8NRVEaAeRMbtAcY3iwBtjPzkyTRgWI+hSgWbMEEWz4mN/pk2iF3mzXHOpM9U5M82oRQ+1rj2tvN83qKpuIhhdqqXJtxXl8Hqw+ZKv5noNQWx3mku2KuLC9I0erjFvLYpC9CBsaTqT8ndUTSmOT5u5bS05htYMHVaXHpc1ZsunJ6dNcKh5+8Yu+lKt28OyLGOoJQDnJDyGdS2fyK+RAqcu5pSX4Dl1Kg0Q3fRv89SimzpnbsXnkq3n+QdREufUPVCoq4vZykdROKqNVjNlea2WEKxl7XTq3hcax1zXe9bl2uN7wz0MBJi2AxqTKcnVOGlOy2aoZljApaLFyXzV1IZqW9m2mBsFrurUcD/DHaHRcpTtH/niSSm9hcEWj7HGtXoPFYxMr9E
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b4c24b-c327-4274-b627-08d8230793d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 06:24:32.3454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: quFXeN2o/lPZ3fOilpasOcfxE4b4IrYPEI4gkKoZNxOlCtLXrx1XHD+jYES7eMi+IUw+FYb8SD/MwkE4yHoFbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/08 15:11, Martin K. Petersen wrote:=0A=
> On Mon, 6 Jul 2020 09:04:50 +0900, Damien Le Moal wrote:=0A=
> =0A=
>> Commit c7e4dd5d84fc ("scsi: mpt3sas: Fix error returns in=0A=
>> BRM_status_show") introduced a compilation warning:=0A=
>> [...]=0A=
> =0A=
> Not sure what was up with this series. Neither b4, nor lore could=0A=
> figure it out. Had to do each patch individually. In any case: Applied=0A=
> to 5.9/scsi-queue, thanks!=0A=
=0A=
Weird... It was all based on 5.9/scsi-queue and generated with normal git=
=0A=
format-patch + git send-email.=0A=
=0A=
By the way, the patch mentioned above is not part of that series and should=
 go=0A=
in 5.8/scsi-fixes, no ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
