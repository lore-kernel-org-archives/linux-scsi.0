Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9DCC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B27723A52
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgLHMjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:39:02 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:29535 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLHMjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 07:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607431140; x=1638967140;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=W2zyO1+PS3rgLFijaRSiLSV9fbz1lQcBoZRma1016rM=;
  b=MxAyo99EkU2FErWfyrbDm0r0/sOCWB/z6UwhYgKv1PNATh05kiI8YosM
   BkhrUnkTj4xI/DRLOFrHT2qPnXqdgdSqX0J2D2sBMAO0CLgQ7gaCAUwjm
   MKTmBoJmMPZxQTsRD62TELQENxJScww4v+KoMkrCm3PJwIMJuZyaEvsd3
   y3l7pjjzaGPxOORVlQCRUQ6sE2c9TXrGqjYKLpeOsd3ctqqxGYHP8NyNo
   53RnZccR55DCAi+0nhyQ4KYAvDchE4hrZTdDM9bWUfYGCWh09M2NnZGOX
   euj63p1vWsiT7kL6/e4Q4wYDtsJkuTEKnuA+9W4JlM0CyzQRgEQHjpkCq
   Q==;
IronPort-SDR: abtrLtjU8r7qbebe22o6Ui/fBA1/jmjQ0bCFqV/R//d6Gqk952wtTcJQ+4Or5KrWdSZVzgbI1m
 3IHfuQvkX+0Wvnk5+kNPoEfUmrljix8usNCBJL9jpz9awgTPWraxS7uN5CjxUPzqMahhWzgJM7
 iqnZsJjfMQ103kruTfcDAf/Zunf7xPrBXHjDwq5rlFAe9+E5ERT+GsKilfXpmarxpyBg1ThCyR
 r1mXyetvJEsMXzHm8tCjdB8157q68MBtgx+KjndtljSKoF6Lc1NjYtLk9V/lj5x3iDXGRZKCeQ
 Fls=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; 
   d="scan'208";a="159142705"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 20:37:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFiFqWwNEv4UHd1KGTOhKC2sDJ/yWorDW3sS4Eq8dVY34+2Amuq25nG3GfBMd4kj7k5m+JYpWBocdiSgiKlsaKVafW2Qzmwl53Iz8VifsEb1vXM9R4R7q2VcCj5iemtQvGF6/xglRulq+xvYOBrOthsMHGmmEfBMafw/S6Gac1orMkVtCdn8jchr4AlMDF5mCCIZlwerOgfNkb2/6TLsVb1Evzfc4Ws5LFtR2Y6UYBhGelxbATit4r8XDAPb3oQciifxG3f19urd2NUXuEgXEJ63V5sfH7PqUB+HwUkrG5XdAuFZcGCJatWSI9m2YRueEfZx8bEpL15jbFIVv3xLVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2zyO1+PS3rgLFijaRSiLSV9fbz1lQcBoZRma1016rM=;
 b=Un5OMP6Id2nQatrmR1VriyaM3R2H69BySrD6tzUNukCQC6YUBpx0NGddBY1c/4q5gUujnk9kIzKkHvjk8ljCY/jCE1X8Kopq0+vShgE+jombUOpGPlCxYcxYD5bX980ghE6sFCnME/xE8wFPE249+hdWdC4MffCv++TqRpxHIrkajiCS6vkFIdkllp+xALmAQoSzLv14aSfhaUkQcwoOI5HwXrkiOEYvfHgjQ50OHGXqb8ui7LVoMBqAoBx/UgU7mdYXoZtMmzWqTIgcUvFtmZPZn8fpkalaiCxHSma0Hd3DaGBxzfT3l086TqE+r4ffHxVzoY4d2fwpE+XlZNIC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2zyO1+PS3rgLFijaRSiLSV9fbz1lQcBoZRma1016rM=;
 b=HKfMgXX+kRm1FFWZPRaFBCf920OSRnIBmCwBd/27ozutGHRRjz+QqkfmzhxyelWxdf729jc2ysiAGwqzwY2MEY7/caDMnVEsCptRcbnNqozO0aUu/USnb/yhFLO9j+72XMaRCfkamwOuvjhtQ/s0vSmbpFF7/2zsjYyt7Ul/hqI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4688.namprd04.prod.outlook.com
 (2603:10b6:805:ab::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 12:37:52 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038; Tue, 8 Dec 2020
 12:37:52 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
CC:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyi08xMuKL73ZZUaIarInYKlQvg==
Date:   Tue, 8 Dec 2020 12:37:52 +0000
Message-ID: <SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <20201207192453.vc6clbdhz73hzs7l@mpHalley>
 <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20201208122248.utv7pqthmmn6uwv6@mpHalley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: javigon.com; dkim=none (message not signed)
 header.d=none;javigon.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 50276e26-5770-4e9d-ebe9-08d89b76146e
x-ms-traffictypediagnostic: SN6PR04MB4688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4688CEFDCDD615DB1A9649EC9BCD0@SN6PR04MB4688.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83MaK3bxef/YyUz965MJhh0VWCUK1FzEM8xQPMAlBV/PCnpTj4QsfTwxmr/opNxxz7sezpcT0FuFEXE6+fthlJEolJkPnsWmn1IZey+Xm4odGv/RII+Hm6NgpXJbhNM3ZQwkMJcUFz7KV0gkjUMPhwbvjXla521O0krLnuEcJLcOfv6TleG79Rr/Br99TPv0a9i2JlseJNjwFjYhiRNG3ymLLXUHO/gJjSY/cC40C1bDaqNAJdTgFxUvGvbqmJmU7UeBv/OLzF/gKOA63vWYICchEOYXexj0cjxNyH0j88OD+2I4o9N80tC8l4SMd1Ge
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(53546011)(5660300002)(66556008)(7416002)(54906003)(4326008)(26005)(86362001)(8936002)(66446008)(91956017)(66946007)(66476007)(64756008)(71200400001)(76116006)(7696005)(2906002)(83380400001)(498600001)(52536014)(6916009)(8676002)(9686003)(55016002)(33656002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?hXoZZYOsSI1tef74rXtmZ/sr9UvCdM+iSb12WHZ/HirFhds/JrG+gVQp8K?=
 =?iso-8859-1?Q?1glI/qRMoGZ3b2bmWC0GK5xDOGeXnuzNPPfOYwSV5SlwvR0et7XbFSz1h0?=
 =?iso-8859-1?Q?DBqFl6xfVEVu7b8UB4iwNJY3XFJSbYJphjSTZwP41zAs2TGGEwtCmz+1BY?=
 =?iso-8859-1?Q?qrXEWlzC4hPpo3DvOO2IsqJpxSmdMoQxXDVekS4Vp72pAn+cNkyY3wB5sl?=
 =?iso-8859-1?Q?X0AWusHi4rqC0oicsH/ulnsQ92609BZf+wd5lW9VB++Ntlq5TuPgK6Xn7r?=
 =?iso-8859-1?Q?Jt+PZnKUY8baR33lSv54L5L2ETEZWIq53JWD/VyjasGSo3n6kfD+431QvZ?=
 =?iso-8859-1?Q?yjQ/sAHL5NBZ8e5Pt/5vLMK9L572MlsRsGFfIntoGgeWiLtEO02wRNPm59?=
 =?iso-8859-1?Q?IfkaR9sk7EbCd8Hk1YRWutH/yvbopm84LRqJjC8ksQfnAQdVlgDiFTA/H/?=
 =?iso-8859-1?Q?DRSRogmZRhIF1ETPpGi+D+SFuFbgWPJGU4nM2qUovkgJv7heqCC/22QI4V?=
 =?iso-8859-1?Q?l/C09l2QFILoQWpMQ4tH7dutI0DbrUN/6yXmTRpsbpgTThOksvIgfmsaz/?=
 =?iso-8859-1?Q?FTnZ8E3UU3rPFmBCT3kkXYTLFsU4iTHgOgRst8gR9mz5jj7HmmwoVNlWyc?=
 =?iso-8859-1?Q?yvflC6qgTZdINNHn/xZOf9h2vPYLSzq6ZHXBu1uvBWGc3QYdDHps+l0kVI?=
 =?iso-8859-1?Q?jczJE+zROarQdSMlmp42fwpO+DcIRMKfCXJlDNzhA1CXSMIMgM84Z/odho?=
 =?iso-8859-1?Q?iWzlpS4y48WUg1A7YwJSl8pY/KDzEKdHMt+pS9lSh+uGOIBKWf7VKbvqr8?=
 =?iso-8859-1?Q?M2Nm32qO2kqBNIxLDTJo9ANFRImB/vvb1lksDHUsu2IcdjSlRZv8vKeedc?=
 =?iso-8859-1?Q?yUomWavPHWpqUtmEAlPevPwTT+23dL/pDv0xV9UHAjyDIsOPzPXbb6IyYE?=
 =?iso-8859-1?Q?yxL1p8AGGjvMs7wIVFPU8ohUXW60YFbN/VE1Wjxd1W7vhkB0/AZj6TPOcY?=
 =?iso-8859-1?Q?ZPqL7ixekTYyfYd5SjZFoDaFet/MdV4i/Ddn3m?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50276e26-5770-4e9d-ebe9-08d89b76146e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 12:37:52.3295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoDEvVRI6Bu2bCZj2jMSUK1+BhUKw5uR/UrbKbu355p4YOyYZMw11ucxaAxEf80O9Li5EmBhltmcZrcpKJXmMaJJnsWdP+pAGj6XuP3FiAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4688
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/12/2020 13:22, Javier Gonz=E1lez wrote:=0A=
> Good idea. Are you thinking of a sysfs entry to select the backend?=0A=
=0A=
Not sure on this one, initially I thought of a sysfs file, but then=0A=
how would you do it. One "global" sysfs entry is probably a bad idea.=0A=
Having one per block device to select native vs emulation maybe? And=0A=
a good way to benchmark.=0A=
=0A=
The other idea would be a benchmark loop on boot like the raid library=0A=
does.=0A=
=0A=
Then on the other hand, there might be workloads that run faster with =0A=
the emulation and some that run faster with the hardware acceleration.=0A=
=0A=
I think these points are the reason the last attempts got stuck.=0A=
