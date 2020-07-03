Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B925C433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 12:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A17020BED
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 12:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F+kU3V7m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rQh1beat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgGCMJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 08:09:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49716 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGCMJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 08:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593778172; x=1625314172;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SfS+K5MTPTZIhplI+MGYFH12O6KVup+8QR4l4HmL+eI=;
  b=F+kU3V7mrL53C2sE5D6FxyZ6nTEHJhcsnPatQDQXWDH5llT6TVJK4r1a
   /yojJ37jkwAZ0yWidocdlAK0OYLJC/JamOVPUg5ooAEIHizrOzD8G7aZm
   DXgbbEWHzhE8P5Bda6VzAdL4f+CbSVNrL/ix2fA70vpmEFZb2G5xNnkOT
   rCkRswtqv0ctCo6Fv1jNGzQsD00gl1uv1VB3mKkpURM7jY2MG4Qhonbf2
   nTSuUFkmsiAW5tCfqZU7HSZqYfwfBqdTTZMUN+PN/DF9sKKhjWCJUNdKP
   YQ0kPg1jJSh5ffpLWfMUOz4zYA00GbLX+ZLBA5roQlWlSgRyBIrpcIU5l
   g==;
IronPort-SDR: lmmBmfUOval16CTT4O4qyuLEKa1/vpnl/lrdqaG6i7j6xRningeLYDu9OqSQgh2sqToylvfk5U
 Atjc9SoaHpSgGxSGkDf1D3k/EEjVjMpqKQMr11yROSdboyD0+AcCJzgMimlnRrb8DUR/8pbWRr
 zGMFwuSpksL1YVzyPM9WsIF+XasOjYRyAa2bMvelsAY6BdLl2uhynf8UNjGzHsdiuAtJjEA46l
 W01F4wv1CeGy5hM2UHZSMnFK9p/j+YEBUVmMStVpWAzIbmVGhzW4hjUDWW2rCYa/RXW9sEW7gA
 Bio=
X-IronPort-AV: E=Sophos;i="5.75,308,1589212800"; 
   d="scan'208";a="141580301"
Received: from mail-bn3nam04lp2052.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.52])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 20:09:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n66OSmkv2kEsfM/Ln1ppXocQYO1K0cP/lQJg5oet9ZuhkjZUjECgFQRvM/BM6uoPai+QCzZPM5TDiBjdpJL6DBzICUdcL+Rv8cmi/jWuHCPsVHPzBX9X3aPxUJRkUG9Er5pUZ/TZiyz0WPyzbaClIj4zxwMGThr+RDRHVLUzT5x5idPemeO7l5CG+UkBNSilA7RALsp5sUr4HFKGFaOvA4AmBHjQmO+qq21y3hQ6vBUxyUCi+Azr6R1hO1StSWIE3uR2CQtkiSTYtiGabQyWqdVz8GhhcvqRc+uhneBkNQe3D7uITIuBbChjzXoaxH46onFAI5saazKcPUU4esWw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w10F6oAfULdcNMEWTN0Mi6P5uD958F92baLMWdJeN9c=;
 b=SGg3CPuNvAEPWyZJIoUnQCS/QJe3uefCp6N8cU4j9Xm1WQ1irlpM9EwxwKKMEqO4HvMB8jR4SZAsU4PpReY9MSiu7p9SjGjgHaUUVWATjDWLMdP72wTBX4Tgk+jV6KRkapXgwiyrr+4UNdeZXSVOm96D11YKr1Y/6KObhTTvbWKgQRa6I99gpsXwOChXwH+KI/SNXEr0ZlNjdJ+uye2w5sNP7qiGfT/22pDEgLi0/llGxk5AmJknl+r/4hMiJStosUwinHWi9L0GkvT0inyqB/Al6zlOHbfnkNMLOMxVKR589H7kEr7VbNU8f2pxt4oj5YHrenZuuG83tZnS52mT0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w10F6oAfULdcNMEWTN0Mi6P5uD958F92baLMWdJeN9c=;
 b=rQh1beatMIyGPTumsXODKRT5jr6QFYDbZsEuwyKiHdLZffWbTvf4NdiaDzQIeRUKuUXylDstECKL7Q6b18xmrEUVj2NUPL1MU1aX9MX0lTmwX5Ztg9uKZ++RiWUBAtpNpx8qhfux/UpeDlMh2KQoa2HOuqlnhpi9r/8DIf4eh38=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4461.namprd04.prod.outlook.com
 (2603:10b6:805:ac::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Fri, 3 Jul
 2020 12:09:30 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.028; Fri, 3 Jul 2020
 12:09:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWUJ1laLSAJw11LUObxsrvIlcW1g==
Date:   Fri, 3 Jul 2020 12:09:29 +0000
Message-ID: <SN4PR0401MB359801D165A0B9882B43B3719B6A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
 <20200702181922.24190-2-niklas.cassel@wdc.com>
 <SN4PR0401MB359886C77E3711DAF16D9B9F9B6A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200703092353.GA33841@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3dfaa944-a9a9-4990-bf38-08d81f49f070
x-ms-traffictypediagnostic: SN6PR04MB4461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB44615F2758B78935B11E2E629B6A0@SN6PR04MB4461.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+k/nqfHhf/fHqc0BERP1I/oYmJ5MBxRwkmR/7tBf81qxhYeP786eenYs5EP40kQ5Rcla5+ocqJStMhJg5k8D2/snNtbwB96sA7XGVJPRv2N5kToB+Mz3p1Dl8F0hfyHHbBg0ybDfYaYLlOJ9Xb05xaqjicnv+6h1OIBESTGU+TJtnGppCuCii/AfdYJNLB5OJzrAQnNIZn7/9nwPaK0cv5cFzbL81cFhr15y6nf6ZH1tixpwINtc5G8+obGLwInqVjtC7uvvlG6Bs9zQ+NVUWZEd2l7YhI3HwWP0tmktg4IQNQGWfpk04i5OLfhGoLYju9kgISqoJ9h4VIYf7dsGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(8676002)(8936002)(478600001)(5660300002)(2906002)(52536014)(7416002)(6862004)(71200400001)(76116006)(64756008)(91956017)(66946007)(66476007)(66556008)(66446008)(54906003)(55016002)(9686003)(6636002)(26005)(186003)(86362001)(4326008)(7696005)(316002)(6506007)(53546011)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2mHiQPS5zKMFY6rBZbxLRI429dulqXhIy1G5jRfJ357ZYe6JBvEnWpoR3QYa1AvsODIuIjwGuRr4FgBtO9Hg6lLGgaImENexCfuBDaQCYmtwpI+UPV5Loq1Zc/QN58/6w+SbdhV6ZVdrI25WZSo31Q0hotCXsfKQD/i+MCdG6V6Mb5M9yh0sdQeLHT14pPXwJL3v8gJIc50EVokh0aXsp+W0v5UA2ye4hudYJZ9spQXQAU96x2jDZZk2lExX1NlR6t2J3tIhZ1TdMG/6nFU1GDmRKnp57WdDM8ryzZ1XoFCjn81jnWx+Wg3XkKidvUNPJmIDOwGykpyBFdRYafZTuhInjkFE4gZvt0b4bu+Dh/7xqChdZ9SiRRwzYbzrF+pHKpD6McvezHCMhk5SUiliUoZgsr95IUf3vjDCBgsSfnKmjzmAC892n60mitmAGIlCD/34ybFGLHfXEgKX0abVLrc2KyhgoTdmwcEutE7Q9IaE9hHTjvUojggx6Ci+BFeW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfaa944-a9a9-4990-bf38-08d81f49f070
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 12:09:29.9051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62akM7fmIZD5H6031culOFUlMnyLDYsMJXvB+doiJDaU5oSRad7m83vHtkqWbe/o1wkKUOhzDj+HKuifAJRY7ZKM2EgTB+aN35VU+UZGHOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4461
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 11:23, Niklas Cassel wrote:=0A=
> On Fri, Jul 03, 2020 at 08:22:45AM +0000, Johannes Thumshirn wrote:=0A=
>> On 02/07/2020 20:20, Niklas Cassel wrote:=0A=
>>> Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>>>  block/blk-sysfs.c                   | 15 +++++++++++++++=0A=
>>>  drivers/nvme/host/zns.c             |  1 +=0A=
>>>  drivers/scsi/sd_zbc.c               |  4 ++++=0A=
>>>  include/linux/blkdev.h              | 16 ++++++++++++++++=0A=
>>>  5 files changed, 43 insertions(+)=0A=
>>=0A=
>> Sorry I haven't noticed before, but you forgot null_blk.=0A=
> =0A=
> Hello Johannes,=0A=
> =0A=
> Actually, I haven't forgotten about null_blk :)=0A=
> =0A=
> The problem with null_blk is that, compared to these simple patches that=
=0A=
> simply exposes the Max Open Zones/Max Active Zones, null_blk additionally=
=0A=
> has to keep track of all the zone accounting, and give an error if any=0A=
> of these limits are exceeded.=0A=
> =0A=
> null_blk right now follows neither the ZBC nor the ZNS specification=0A=
> (even though it is almost compliant with ZBC). However, since null_blk=0A=
> is really great to test with, we want it to support Max Active Zones,=0A=
> even if that concept does not exist in the ZBC standard.=0A=
> =0A=
> To add to the problem, open() does not work exactly the same in ZBC and=
=0A=
> ZNS. In ZBC, the device always tries to close an implicit zone to make=0A=
> room for an explicit zone. In ZNS, a controller that doesn't do this is=
=0A=
> fully compliant with the spec.=0A=
> =0A=
> So now for null_blk, you have things like zones being implicit closed whe=
n=0A=
> a new zone is opened. And now we will have an additional limit (Max Activ=
e=0A=
> Zones), that we need to consider before we can even try to close a zone.=
=0A=
> =0A=
> =0A=
> I've spent a couple of days trying to implement this already, and I think=
=0A=
> that I have a way forward. However, considering that vacations are coming=
=0A=
> up, and that I have a bunch of other stuff that I need to do before then,=
=0A=
> I'm not 100% sure that I will be able to finish it in time for the coming=
=0A=
> merge window.=0A=
> =0A=
> Therefore, I was hoping that we could merge this series as is, and I will=
=0A=
> send out the null_blk changes when they are ready, which might or might=
=0A=
> not make it for this merge window.=0A=
=0A=
No problem, I'm just working on MOR support for zonefs and though about how=
=0A=
I'm going to test it. This is where I've noticed null_blk doesn't really =
=0A=
expose a config knob for MOR. I can do some temporary hacks to test my chan=
ges=0A=
and wait for your's to materialize. =0A=
=0A=
=0A=
> In the meantime, MAR/MOR properties for null_blk will be exposed as 0,=0A=
> which means "no limit". (Which is the case when a zoned block device driv=
er=0A=
> doesn't do an explicit call to blk_queue_max_{open,active}_zones()).=0A=
=0A=
