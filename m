Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BBBC5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 07:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6032621D7F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 07:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dSClSEgH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LWg/xlw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKGHyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 02:54:09 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26137 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfKGHyJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 02:54:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573113248; x=1604649248;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bzce1HQWI7vuB0PAmvHWX3tkS10mTiClkNMCcbitQwY=;
  b=dSClSEgH+1ohDTc4mGC6VujeQtV5aIQdECexaBuVEio43c/g+TTv0DmJ
   qissh6+xWtr2MRYQLZVcwriD2halT4FxPWfjS7eNzP4m3I1sMPlRO+mKA
   e5LtGH+Q21D6cBi5YQeluT3eCJithP9/TR2f6hYN/h61BDmPwyBdHAR11
   Irgl8CiYNnLZgeTJbigeTeu+mOA6n5mDAA4d/VHj/uL6ggo9ZozsIjh8O
   n7EDOmgA1CIL2ws9ycNFr2PrT9DxEUHngB2SXdcWatCG3g+GWS8qkNLHS
   Dnv1ZvskXAn5DjVZXTFZlA6MlujdwLUzicSm65d9gOgG5b63C7zaEfq63
   A==;
IronPort-SDR: UeXMoIrW8BkPZFfBiussX0Cp8yWbYojmtEDKM+u5RIs7oani2YMY3zW+9u9kERvY6TBkI8tO0Q
 f0ru35PDD9rqq4FGooAAcUi3UY4dcrt15Mfkltu6V6iA6I5ODMzwUdig6ZCpLO8DZ2lD+rdaad
 /Hxb73QTkoPEUu2W5Qie3kjCKL5f1p3LX917G+SIy7FLwea2iHmFPu5UmRzmk+8BWCaxUNlo2Z
 JGanPVffarSKUbQ3cG+lqrBxjlNz7eskAMhj5Uk7bBMh6rwhmtmSrjvn91uw0ieRaTZG1o7n1a
 ivI=
X-IronPort-AV: E=Sophos;i="5.68,277,1569254400"; 
   d="scan'208";a="123095957"
Received: from mail-co1nam03lp2053.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.53])
  by ob1.hgst.iphmx.com with ESMTP; 07 Nov 2019 15:54:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1GUckfTzQW8V/TcCusmH46pQKygn+07GWD9YuZl9zXCWx/GKksSeg/sTNt8/Vy0QCAqr2wCgMRm4Gt3jPxSdb0YO9Z8H2jlf1Mu0wl/1RnXt5SKv7ZTykXGT0/otBLbIoZLFLxyYxrcUgapSsBhhEOBHqI17hTfDJq/QiVwZfOQMJa4FQt3+pujnqqpWwN3jtT5g9bztYPliXF4s0RhcwMiQCWRjcXgCGCrQkG1b0xgaSGYdWF8hXM8KBcNQQq5byUK2rsIGCmBk1+14QPzEBzDpVqe8Zb7TOzeFQGQRmyTntwr0ZgW3j/zcLzj7sGK6E+u2PBVd8EluNyRfUKArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzce1HQWI7vuB0PAmvHWX3tkS10mTiClkNMCcbitQwY=;
 b=My+mHYxZ8lbedg9LKpBknj0LO9b6k3pTwNRTrfIBKqnyOCh5cU9tTEALtprpnmGsT9thdD5HR/CrV0e1BNGnTbvnXF5oGUMT7g1JFu7q80gOeuihkpuUQK/HiS/dR6ZYzOreMK77SBXY3/dgJt121hut0KaaRiTV8jzlQTetwHesieYBVOfZZi6Lf0/PpLgXmLJemcVKFyWFtSxtIcPyxX9S97tiQsrD7cXGAbwaWKiinSdY8170YDoOj9DrqY3xCCFO9MznJkpijt4WwBCYhPyuTJ3dqli3hnRKRIOTncvr7gHZJ/M14jC//67xpCcfgjJwUx6Pq/GtpzidOGBIrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzce1HQWI7vuB0PAmvHWX3tkS10mTiClkNMCcbitQwY=;
 b=LWg/xlw+R/qhdJbJ39vyx5/+pVNKRFkOtyN26nlTvPyRuZhydPnyBCPy+xOmc5DgDLgVhiVIwN1ttjtRNQUIgQz3oXgu0CuwEBlBnsfYNx9nHXEeQvv69LEcY1vxPCdn7wZRZp1vR2d2zf3HTtSoK4iOyZcxEnC1eIEqmKjFCtk=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5814.namprd04.prod.outlook.com (20.179.59.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 07:54:04 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2408.028; Thu, 7 Nov 2019
 07:54:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Andrea Vai <andrea.vai@unipv.it>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>
CC:     Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qbTKYWY4pSG0OtJLbZzV/0bg==
Date:   Thu, 7 Nov 2019 07:54:04 +0000
Message-ID: <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c91f0dae-d85d-4f9a-b394-08d76357a8ea
x-ms-traffictypediagnostic: BYAPR04MB5814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB58141C061ED240B5D42862E6E7780@BYAPR04MB5814.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(199004)(189003)(71190400001)(71200400001)(446003)(110136005)(7416002)(6116002)(7736002)(3846002)(316002)(54906003)(305945005)(476003)(486006)(74316002)(53546011)(6506007)(102836004)(26005)(86362001)(7696005)(76176011)(33656002)(5660300002)(2906002)(52536014)(256004)(14444005)(66066001)(186003)(229853002)(81166006)(478600001)(8676002)(81156014)(25786009)(55016002)(2171002)(6246003)(14454004)(4744005)(66476007)(66556008)(64756008)(91956017)(66446008)(8936002)(4326008)(9686003)(66946007)(6436002)(76116006)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5814;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nmFpDR+pmjpwf22nWW7kL+ke+ZKMZir89DUWH3ieAi99qixikkqfCzlgg5v8FAPAKMoXYwuLS8y2EecwZXD+ktfudibXAY96hJeZysUrTuPMerFcEXyikIF9og6I5Ca+vFJYqm/7pocoSLZnOHZ54NPnNGdeBBmuLyXaIefD0SGZKp5EsYGLVR4ZmCYz26brJZB87wENrYUuK6Qubu164BDt7JhXG5yvjxkSUIgZmHtUA9bs68hMB1Z9t9yMwjMSq9acaVxyKd3vBWdSkILjglvaLTA0xZl5RXX9t7WDo3S537HrMYCa3Q1GYN0hyX1Iz8L3vPognfuqS7AYsBq7j5nyJUmCDutTC/mDYBiFw90uM1idIgN/7MF9h4MCyeiQmOT83gpZdrl/jf4mSQLfl4F8oQW2QwAncK0KjsEuYXDMk9XpDrzpuWZTQpHQP12g
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91f0dae-d85d-4f9a-b394-08d76357a8ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 07:54:04.1993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NEvHkZwqamLEEzISMOD8rBulfc30NjgZbrxll8ll1kfGMydAy2v+9yC0myF4YHZrKQKgAd1q+8ggfgYTXUGZJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5814
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/07 16:04, Andrea Vai wrote:=0A=
> Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto:=0A=
>>=0A=
>>=0A=
>> Please simply try your write tests after doing this:=0A=
>>=0A=
>> echo mq-deadline > /sys/block/<name of your USB=0A=
>> disk>/queue/scheduler=0A=
>>=0A=
>> And confirm that mq-deadline is selected with:=0A=
>>=0A=
>> cat /sys/block/<name of your USB disk>/queue/scheduler=0A=
>> [mq-deadline] kyber bfq none=0A=
> =0A=
> ok, which kernel should I test with this: the fresh git cloned, or the=0A=
> one just patched with Alan's patch, or doesn't matter which one?=0A=
=0A=
Probably all of them to see if there are any differences.=0A=
=0A=
> =0A=
> Thanks, and bye,=0A=
> Andrea=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
