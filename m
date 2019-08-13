Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USB_DRIVES autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E775C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 03:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57BBC20578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 03:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Wfxu1Oau";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="J8i+btKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfHMDrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 23:47:13 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:59466 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMDrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 23:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565668031; x=1597204031;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wd0jLAEkpTE1eco8MznizPbS5zl4YLsBT6KGfzSmZ/I=;
  b=Wfxu1OauFasnMH18eRuXlRP0lg6U70vLgeXUl1oxBj0U483E+IGKNhQW
   t8XwGfGhVGA+ygF2Nk2JqgEYGH82Wl97Yamm1KKMrv3QetQ4IdMybLqVS
   P+GwzuqAlOsN2NlZH6hIWYVt083o40xuE376KvSOQVPA7JYyyZGBTE8S/
   ISQZ0ugHxp/NKArNHMp7Qt3aK5gUprXVVa9HT7QBU9t7mrTEXC/AcF3uQ
   3o/p9BiRpUEciqSHMizhqZYsx5qDD0WwQq9gDZFa19AIhJLUKPIV5CcH2
   C9VSjueFmM+hor40sH+knu2LExnShBn/Ip6R0pA0Sc1/H5PTh1+PBG+7l
   A==;
IronPort-SDR: 9aqHKmCrQKHvtOL42oRZW8N3I+i6/7Acy85xh8lgDd+dprZx1Sm8kEsgofRWpwS8Hd3qVWM+U3
 I+FHlO/6SW9WptLqM8RePkmvPk73RiuDFZGwQhJzDn4KbzOplpL+RjYAmL+EJGN4vAdzocFu6L
 miASWE0vpzxuR51TrukHmwcyCjVqhbeT8pYokkbLPSucKRlBCUEodHuYCZgVEZ2wdOYpKQBVh/
 bAcdRvaUsGMshJs2gLb1LJMVKV6IE4W5qXX84l+jJTEsrRqA+gc+LKrj0Z1fnBprR6P1n1cIZL
 J0k=
X-IronPort-AV: E=Sophos;i="5.64,380,1559491200"; 
   d="scan'208";a="116642671"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2019 11:47:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOwIpcen8GEJnZnH2M7TS6+sl22S5Jv+4C5AkmYGa2PP3VZBeRfc+ONUb3AHztFAqn+fxm/J8P4SbYRe1YQ+52TGds2esbI9y0HoDa5m6jTa2eDwLtZEnfT3jq8Seg84fMaQCTDrUYy6oW86WQTeRniyzLKeWBQb8ct0bN65jj/z1TfZt68rXcH0H484KWW4uKabP+IVtSJuJ4pTb7gaeQ2tT9LGkUxLKDxnHW8Eu8t/w5ss/SVJFPalulTX1ZyXzdqeVjL9mkxEcsgkzQxjpaV5jdl3DYOwXJbDschCU/nJVmjnJo2kCiRhjjMZMs2JM7XBhYMk0FWHbX4xa1qvQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JTWSKsHYs0P4SeKELIUPF/5hKOMKzixNn5AA8ZXqUA=;
 b=clQFJ0OyhaOqlR/seOEfk7Kgt/Qf/zMv5JVNsI1kcIekOdki8T0wsH0u/oDkg8OrIfsgmWCxtSg9cci7BvJ27jL+o6TzMKJ+sdOi4qqWlxNRAZzD5ScXVRB1+RNeoZdqYLyj5Q1/3UgOPsHoDYISTZD4+Bu8IFfV/rqdj4a212iyrY6ugxdHhFzgIxDUYmc8uMIy6X+73bEvLs44W/PjE/8wmRyNTsjt/9zUbEEh4U/qgpr51C6gVn7XwUYuhfRqnRcemZYprZO4Tpvx3GXaoIGLW4LdFI7N48IrCmykpIIempHcvUWGChlR60l6n3iEdXc3HMudbPYIsbhYH2VyQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JTWSKsHYs0P4SeKELIUPF/5hKOMKzixNn5AA8ZXqUA=;
 b=J8i+btKXd/6+mgHEvk8TvsJExX+07sajFy7yOH6W8j4x+bIsvZ+mP6FxKDWE8AgBx79LPRsHUGUWl1yvIDfpEZLB/ELplxXNNZWxAeKDwSL65TnwbndUHJcn2WpS/s1Q2feO9MmlQDTdKcQxWTBG5CsguQ5HITE9cNceaEzqtNI=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB3942.namprd04.prod.outlook.com (52.135.215.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 13 Aug 2019 03:47:09 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc%7]) with mapi id 15.20.2157.020; Tue, 13 Aug 2019
 03:47:09 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
CC:     'LKML' <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
Thread-Topic: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
Thread-Index: AdVJ2z/+9mq0jIkOQpG4zabX2Rwi3A==
Date:   Tue, 13 Aug 2019 03:47:09 +0000
Message-ID: <BYAPR04MB5816F39A6F073D77499B8D85E7D20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
 <yq1ftmcct1j.fsf@oracle.com>
 <002d01d54dc3$17c278c0$47476a40$@lucidpixels.com>
 <yq1r25p7qzp.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd25149d-f910-4736-1432-08d71fa0eb30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB3942;
x-ms-traffictypediagnostic: BYAPR04MB3942:
x-microsoft-antispam-prvs: <BYAPR04MB3942661603C07279E70F33F5E7D20@BYAPR04MB3942.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(51444003)(8936002)(52536014)(8676002)(7736002)(81156014)(74316002)(9686003)(55016002)(81166006)(53936002)(64756008)(66476007)(102836004)(6246003)(478600001)(66446008)(66556008)(6506007)(53546011)(256004)(5024004)(66066001)(3846002)(76176011)(71200400001)(6116002)(14454004)(4326008)(25786009)(14444005)(5660300002)(71190400001)(305945005)(66946007)(99286004)(2906002)(7696005)(6436002)(33656002)(186003)(229853002)(110136005)(316002)(54906003)(476003)(486006)(446003)(76116006)(86362001)(26005)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3942;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ymrUBuaSAPvQpYGXksaCPmB5m3QG1tac3/g7TMpRzf2Jd7O3oIa3kYQx6NN4e7Vf+SEZHPr+U8FWbc6SrqVI+Rf15Fb/4sxAY8abF/OI89zasMwawhCFvZiR7M55vx4YL+BnTg6Irvbsb4iy3ByXwU81uWAXySOA/P5izz3BzvMJIpCEOj2PEj1l6m6Ftaa1MZON4ZuNhrSCvtY/GgOiiWFIQlIHrLR5EnOpZJLoFKAt6SggWb+I8jeyR0GVw+9T944vt61naj31vTE1ASk1KT5bbEUgDZ8kKAgR7vASHPT0/pXfZrFNiK24IyeVhvnzrRnzoRvUJT9P7MVqLd/XMcsGlMEGpfkIe/+C3YYq+M7uYhrO+PQoAqokLxR3kYfqESreoCgY1ShPUWhgZvZKTtJNbpfohgsjYlzLfeeM59E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd25149d-f910-4736-1432-08d71fa0eb30
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 03:47:09.6310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jrfKNRv1mMJJOWG1csEVkXDkymI2yekgZPM/1YP6D/dttdWXpYZ1+cLmzlQ5GX9hMnxaBjLG8hIyGcyYOuow3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3942
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/08/12 19:12, Martin K. Petersen wrote:=0A=
> =0A=
> Justin,=0A=
> =0A=
>>> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back=
=0A=
>>> and ran some file copy tests and was getting these warnings-- is=0A=
>>> there any way to avoid these warnings?  I did confirm with parted=0A=
>>> that the partition was aligned but this appears to be something=0A=
>>> related to the firmware on the device according to [1] and [2]?=0A=
> =0A=
>> sg_vpd_bdc.txt=0A=
>> Block device characteristics VPD page (SBC):=0A=
>>   Nominal rotation rate: 5400 rpm=0A=
>>   Product type: Not specified=0A=
>>   WABEREQ=3D0=0A=
>>   WACEREQ=3D0=0A=
>>   Nominal form factor: 3.5 inch=0A=
>>   ZONED=3D0=0A=
> =0A=
> Damien: What can we do to limit the messages in cases like this? Would=0A=
> it make sense to make the residual warning conditional on sd_is_zoned()?=
=0A=
> =0A=
=0A=
These WD drives are regular disks, not SMR. Making the warning conditional =
on=0A=
sd_is_zoned() will not reduce the amount of messages. REPORT ZONES is the o=
nly=0A=
command that could result in a resid not being aligned to the block size si=
nce=0A=
by definition the command reply is composed of 64B zone descriptors. But th=
at=0A=
command is now processed through a device method and is not a REQ_OP_XXX=0A=
anymore, so as an internal req, it does not go through sd_done() for comple=
tion=0A=
right ? All other zone commands either have no buffer, or the exact same=0A=
requirement as regular disks, expecting a block aligned resid. So I think t=
hat=0A=
using sd_is_zoned() is not relevant to this problem.=0A=
=0A=
Bottom line: this USB adapter is weird and likely triggers all the unaligne=
d=0A=
resid. I do get regularly reports of similar problem with SAS HBAs, all alw=
ays=0A=
fixed with HBA FW updates. Not sure if there is a FW available for these dr=
ives.=0A=
I will ask internally.=0A=
=0A=
In the mean time, rate limiting or removing the sd_printk() call may be the=
 only=0A=
option. Failing all commands with an invalid resid would be safer I guess, =
but=0A=
will at best likely cause a lot of retry on these buggy devices, and break =
the=0A=
drive operation/perfomance completely in the worst case.=0A=
=0A=
Or the usb mass storage device driver could add some silent forced resid=0A=
alignment too.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
