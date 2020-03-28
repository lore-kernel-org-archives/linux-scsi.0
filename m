Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B264C2D0EC
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D48D12072F
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CdNuwXeI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="s87vGOIB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgC1INb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 04:13:31 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:49311 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgC1INb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 04:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585383219; x=1616919219;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xdfle1pMCuIxWM3wLa1MInTUVf7MjWXyhYnFEiECkr0=;
  b=CdNuwXeI+G7EfJl/9Fu4judClpVRB1o2rf62TzU/lYtcfdDKTB1OWQVl
   23Wa2uZ2nfAUAKqKUaskUuEd9pnEwfWAa8kDCiwevJIr80ixrlKe9+Pe0
   wgPeQKzwbsSdqff3RU0E7XTjH9C+QLgq7FlAOGHvaoHz+kbMKNLRsS7FN
   JR+33g1ZST7o8opLjaeDI4A8SSpwAairwQXNZg/yqhtxsvS9sbBEmi/rm
   mS04wmEuIy0j2H4nePB2ngDLOauGggnICavgjOJJWqME9P3zEf6MtGnzR
   UmzaKQUr8CAl9UNTgGplCWkP27Xg98wVbWrvZKQlgu4JmFGjIIMxa3nbW
   w==;
IronPort-SDR: y9cf8X8k2FzCCwKpwzOogkRV6mC19xXx+aBB4a3MIrHU5GKoZoHAG4jp2vaBUSXEBCpXZnkbhO
 TmbZ1W0XtMVhjziy+IPj/IrV6hhJhiS1BYGmRFN2Be5cfrO6UXKBukVauKE9IurIODWePj2Blq
 us7FDQRw0b60JVPrAO8ASAmBNOYmFbpmKSzzVJx/3tIsIvSf20TBrGOW5ARVim3izspMNZ5c4g
 RWzy37YkpnGx/xx7e6BNnSK/+lvXtW8UuVJn1YKdAoMFsuaZBZtA1RnY7JeEtZKNCo4kSkRPqw
 h2o=
X-IronPort-AV: E=Sophos;i="5.72,315,1580745600"; 
   d="scan'208";a="235999060"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2020 16:13:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5Lo+Q2LG9aU/cyzj6m9ujzjsDOJ+h0IjF3KzxrT8jLvEelXhqUxFBTQwXuZvMVtgkMOP/SwhMeQcj42P3hYICx7vZ9scaz3LcHKWJ4B7jlfoJwro5+nVz83n1OrVp0fLLhcpOgIjeV5pqoGojN/Ch3Mihk2dzNlP8r/fyN2xJVbpu9tuwi6jjYPSGtHztiTqbN73VZuxEWUNssuRA0wAPCY9eFtyunbIJlAQsmqwRO78KYm4cC8gygZUhHCGS5oRlQ1KSwm7hYngI9mg29fqtjoevH7KbzN2LECK3Od/Af5ysH8XR0hbPDQHRG3gCkn2SOZKj0ua8byFvdp6+Rb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=278/iMV7W7Toiq1Ol04AymXjHcVg5CaemGHxshffdH8=;
 b=Z8vxdGwMnzXQ7tHInTfzUL8YVrnjU/18NOr+AjuplQpuCv9MCQjBxG2w1pwgHxrmshwtWVOHm+FUBN/331GWpYyr1u3ca53OSksp8K1Y6kS/G0Eo5SrDKcF811L7HPxcxQNoPZBuGpRI+OF59nHlCI4yOg9E7V/6RVPYPmh7aK+rzIwTUmj9EPxI/5IscWmS/1najbhlhV7RjH3Ow0rZgMrf4FMz6OKi6jQKjV4JkGEYGh3e1+rnrpQqeczND3ioC4b5WZWGYa2RSYsLjmQ1FwkQd/5DCOOw6+xgSROu19VzOSqrWAuVQ8Es1MnF3HsvQix512Z/wtXUrt53qzf5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=278/iMV7W7Toiq1Ol04AymXjHcVg5CaemGHxshffdH8=;
 b=s87vGOIBX9mvFpQ9b8VLlw96jjfLDKIPrnmsOuhqGS/qo9Iex6VyjMMpv4HnY7K3cS4qbF6lAQU7eRtJDpQlLl7pIhwgqrV+dEu6MeYsIPA/xnYjcjqTqJhIzscnfuuT1RUcYxbxFXT4vtm7eJ7ZBoCLI3fxad/Mrs8dp0SwSaU=
Received: from CO2PR04MB2343.namprd04.prod.outlook.com (2603:10b6:102:12::9)
 by CO2PR04MB2263.namprd04.prod.outlook.com (2603:10b6:102:d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Sat, 28 Mar
 2020 08:13:26 +0000
Received: from CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b]) by CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b%7]) with mapi id 15.20.2835.023; Sat, 28 Mar 2020
 08:13:26 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: all zones zone management operations
Thread-Topic: [PATCH] block: all zones zone management operations
Thread-Index: AQHWAydCbik6RfBk9kK4q1a4/Owqqw==
Date:   Sat, 28 Mar 2020 08:13:26 +0000
Message-ID: <CO2PR04MB234368B6701C041B292DC872E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200326043012.600187-1-damien.lemoal@wdc.com>
 <20200326072800.GA21082@infradead.org>
 <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200326093049.GB6478@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8723bac0-c52e-4c4f-403f-08d7d2efe44d
x-ms-traffictypediagnostic: CO2PR04MB2263:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CO2PR04MB22639990126E51EC0B91C19EE7CD0@CO2PR04MB2263.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03569407CC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO2PR04MB2343.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(66946007)(6916009)(478600001)(9686003)(2906002)(54906003)(55016002)(4326008)(64756008)(81156014)(8936002)(186003)(33656002)(66476007)(66556008)(71200400001)(52536014)(66446008)(76116006)(316002)(26005)(91956017)(53546011)(86362001)(5660300002)(7696005)(8676002)(6506007)(81166006);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +LTMiztV/OI03MQMGfIiAVtsVKe+W1tgQen5RY1AQanMpNIO90I01ySnALUQ5KcqAHFYXlKYSj9tB8iW3lzMgp74mmuj1BKTjcwdncvUxfB43XRJEja6TyjuVqR+puxwE8MKX0JVCjZu8SE2m9SldF2tIweVDUv4RvOP0kZb9AFp0Mp9lKhRCWCg5M8seIEVWl0KE9lDlbFxyhfSakvortgVaieuvxSnSj8T6j3Rd/RmL1Hk2cJ6cXPh/lYihhqfZz+6ZPLzOO1S2FwgooF6D4mozZm8/BIxlUVEoUyuAMq/Sd+ea0156cyYTEM7bEv7Z7eWcdMhAyToRssvN0u7x9NRRZynPK65D1i2a2V64Jhy1yF6ifVNyAux7nGXfkJa8V55IgOFWPzWjIBf0jKFphEqCW9SopN64n+0S5xDeh+4t5uZXiN4yG1p5dn2rbm6
x-ms-exchange-antispam-messagedata: zfcxi1Biem1+y0Tlf2apYTw4/s75SCJNbfdwNTI/LJG4PUv85bNJlYFTts5K0UTic0O1yyTZN8M6hPt/s06YyDaEGLP85iX47XGPhB2eb2359wLj1nIcf9adtIHWsoBEcEMN0yIi3IzZwQI2YYHPVw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8723bac0-c52e-4c4f-403f-08d7d2efe44d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2020 08:13:26.3899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x7Pkx/46zOnrvpJdwN1VOg5BeRR3QiQGFIPQpyB0GfaA1MFqOwNCcJVpjildM0oQjBwn3vsPeX92Tfvy1Mae7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2263
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/26 18:30, hch@infradead.org wrote:=0A=
> On Thu, Mar 26, 2020 at 08:23:34AM +0000, Damien Le Moal wrote:=0A=
>> Open & Close all zones are indeed not super useful, at least on SMR driv=
es. But=0A=
>> finishing all zones does have some benefit, namely the ability to quickl=
y change=0A=
>> all incompletely written zones into "read-only" full zones. For drives w=
ith low=0A=
>> zone resources (open or active zones), this can be useful to recover zon=
e=0A=
>> resources. Again, not so much on SMR drives, but this could come in hand=
y for=0A=
>> ZNS drives with low zone resources (max open zones etc).=0A=
> =0A=
> What quantifies the "some benefit"?  If you have an application that=0A=
> micro-manages the zone state it better knows what zones are open.  But=0A=
> even if we want to add a finish all I'd rather wait for ZNS support=0A=
> to land and real use cases, as it sounds all rather dubious.=0A=
=0A=
OK. Sure, we can delay this until ZNS. The use case are indeed not super cl=
ear yet.=0A=
=0A=
In any case, I think that the patch has value as a nice cleanup of the rese=
t vs=0A=
reset all request operations (the latter going away). The side effect of it=
=0A=
being that open/close/finish all come for free with it. I would like to get=
 it=0A=
in just for this nice cleanup.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
