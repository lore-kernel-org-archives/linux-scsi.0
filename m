Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0045C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4917222C2
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ScJ9cIWj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zrRdKhUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfKHInX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:43:23 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48719 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfKHInW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573202712; x=1604738712;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=fzmauGjiIfNg3tqTMLYZBQMfxky7jbRPSg6Dvq16Nqo=;
  b=ScJ9cIWjuN7jekmCyJRyBzD/j5c7Z3h9DorNRbsAMC6saCVo6tCNJXYL
   m9w4XUYiA4NDGjsrOpFlzrSkYfHW94xSq/soJMzhGFnTsUln+g/v/tzo/
   AHsuJZBmZYQTC3KQU2UbTBLwuOeZjnluBF6+UCOW9s7VZZdruAHnU/PIH
   fxUhVtdB8x69luXBfex/cOoVKXilxLw9Wbub3wS1xvQgeJrE0Equoy/rW
   0tsp0+eyyDBEWZ1A6cQ52IMEMzXdWdahdB3wiw/UOjQkENcg08BeWDaxj
   elyj+9sv4IJEmIPfbgvlVXODePNK26yJj64RF1njIEPiogIrMDbxiw0u+
   A==;
IronPort-SDR: kKMXb0+G6kyYrSG6DYwPVdx7mxL1aHofkbmHpCNfU1LZDUZdWZtdGB/d1qQ5Oisur7Yd/76nPp
 JZmjh2GRDvqughsnP7MGsowTS0CN05/UMoKRj4D1ES623U5iG/7zixkejCPUjLUdmsaZpziqG0
 VY0BJDWVI19GS5AykpdnhbuCRMhQ+BdFCRxs0gohFc0lrpZmLePg3YMagcrxVC9LHfmPp05ByJ
 k1atHMegsjJaYZEVhW+mITJEmUZgobOSpoAzI1oBihUN2nm4cPaf59i+/C2w2HpOJ4LXviSTRz
 qiY=
X-IronPort-AV: E=Sophos;i="5.68,280,1569254400"; 
   d="scan'208";a="223682169"
Received: from mail-bl2nam02lp2050.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.50])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 16:44:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPj4kaM6s1i3X21EHjhIvBLwrWMac95ZSpw+BHvhsUYyDG8aH1mBOWZipP89sYmJT+PoQKzWevha3OZvDv+mSZfFHfSAprm4L4TJJ92SuCTIwretmK8X1ZIgyqbERYFgCbifbESEMPomNtlwTYg3+/2T/hxUOOaaIJ3pyaosBfAYGzfT+ST12XsIylW3hXPHtj16GHMrgMtdKZgQao97scqZGsfaSCoMGddXI4HYK9MGGJfTy4rpRyF22696hutZ/6Ndc2F5OD/yK9pYKb0iBCJBCy/z/WePsMFGeLN30D5GvQhqgyrlYtU09vfbi8gWbhASaZIPiUCZr98aNraJkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzmauGjiIfNg3tqTMLYZBQMfxky7jbRPSg6Dvq16Nqo=;
 b=h4L3ve8vlmM0cgO5FbaIbz23sZfqEP8CIIzI4ZAM2/+YlsQp+vHRrpQG9I9cpQEv8+2aQuFHB9OeUgXj+bmPuLyBenDHd/c+jeJOVCtxYk3GfD2J6/9i6kWI+l254WKzeLnForAi2KJbx3m4equA3WKxzadtccn9Vs+P+AK32pvFUGTO5pF0AqrOpeOeHMcXzMsUWgb8OgqOEXgx6xbvoxVEtK94K4V6SnCJz/niY5jwdvQyM7Ii9oGZOAhZc1jPgvmV27JgRDNS8qT0MU1Ccy3m3inEE1rGdC8nkAj7TRrEpgGmxc4FhXdkH6lAPC8iqiymAK/v3n+Vg5ZZB/WhfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzmauGjiIfNg3tqTMLYZBQMfxky7jbRPSg6Dvq16Nqo=;
 b=zrRdKhUdr3nIuzGKqysQHK5o+vii/aJWziUZZGsIbYBP18ApxaDmFcmg/Vw0GIBDpx8UkrE+Ti7TQrvj2IbOUfoDE4NGBmzB0vRC6cgFrytywko/Ib9nRs3GQQMubmTl5LdbMwLHRPaHDezXo9pqkp49WVJg2FjTmQUBISh5ceE=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5544.namprd04.prod.outlook.com (20.178.232.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 08:42:53 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 08:42:53 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Andrea Vai <andrea.vai@unipv.it>
CC:     Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
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
Date:   Fri, 8 Nov 2019 08:42:53 +0000
Message-ID: <BYAPR04MB5816ECD4302AD94338CB9072E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5507ad9e-be4e-4741-9309-08d76427a565
x-ms-traffictypediagnostic: BYAPR04MB5544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB554444E078DED13493B2FC26E77B0@BYAPR04MB5544.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(199004)(189003)(66476007)(229853002)(54906003)(316002)(71200400001)(71190400001)(6116002)(33656002)(2906002)(6506007)(81166006)(53546011)(3846002)(14444005)(25786009)(478600001)(256004)(6916009)(4326008)(52536014)(81156014)(66446008)(305945005)(8676002)(102836004)(486006)(8936002)(7416002)(7696005)(76176011)(55016002)(7736002)(446003)(186003)(6436002)(5660300002)(476003)(26005)(91956017)(66066001)(76116006)(86362001)(99286004)(66946007)(9686003)(74316002)(66556008)(64756008)(14454004)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5544;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbOhCdzZgcgyuzEfkxBy9DM0DX8FwYsrWD1ZRBBxED0S+WKeUbjW5IGXlZdEj3GueeW8LAYL+64XaqwqczQT6HpJCyNwVGbLLcAoOEA1GLFQcgOFZSpnyYIkCWkOrB96HjHHh0N8KBAAPn5f3c3tDWk0Qurn0dXEmZCt6qZAzH0Qlk24/RByqkw2YjjK6luIGngbxWuMweco+iIC/2vkJS/rDWudAzTA+74qT+CZALzzfgLyGNSXBiucBIYRTn7tABFS8yIWiMRBS9iPNat6uA6PwWegv+VB9PsXbjv9PVVzTErAvrVTJiHMoGIjGLpyczzpa61Ofz+lxMrgieSxEtWNhqgtpFk8tqNxeaxBybrb/9Vkyy/lMk8dAVcDWGD5t8lxA/cmRGL9/HFA+Jm1HhLM/0NDhow+9bk32rQNG/zfWyQsqblZTTEs5BBn7eyZ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5507ad9e-be4e-4741-9309-08d76427a565
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 08:42:53.5595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cA5mumSPZa8jvyI8w8aSKP9f2IQZ9kFWB5YfEWyxItqlLBnyJFgfG/qR6vZSNGiPKXDnBXIJ4CxQLlvdxONuFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5544
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/08 4:00, Andrea Vai wrote:=0A=
> [Sorry for the duplicate message, it didn't reach the lists due to=0A=
> html formatting]=0A=
> Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal=0A=
> <Damien.LeMoal@wdc.com> ha scritto:=0A=
>>=0A=
>> On 2019/11/07 16:04, Andrea Vai wrote:=0A=
>>> Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto:=
=0A=
>>>>=0A=
>>>>=0A=
>>>> Please simply try your write tests after doing this:=0A=
>>>>=0A=
>>>> echo mq-deadline > /sys/block/<name of your USB=0A=
>>>> disk>/queue/scheduler=0A=
>>>>=0A=
>>>> And confirm that mq-deadline is selected with:=0A=
>>>>=0A=
>>>> cat /sys/block/<name of your USB disk>/queue/scheduler=0A=
>>>> [mq-deadline] kyber bfq none=0A=
>>>=0A=
>>> ok, which kernel should I test with this: the fresh git cloned, or the=
=0A=
>>> one just patched with Alan's patch, or doesn't matter which one?=0A=
>>=0A=
>> Probably all of them to see if there are any differences.=0A=
> =0A=
> with both kernels, the output of=0A=
> cat /sys/block/sdh/queue/schedule=0A=
> =0A=
> already contains [mq-deadline]: is it correct to assume that the echo=0A=
> command and the subsequent testing is useless? What to do now?=0A=
=0A=
Probably, yes. Have you obtained a blktrace of the workload during these=0A=
tests ? Any significant difference in the IO pattern (IO size and=0A=
randomness) and IO timing (any device idle time where the device has no=0A=
command to process) ? Asking because the problem may be above the block=0A=
layer, with the file system for instance.=0A=
=0A=
> =0A=
> Thanks, and bye=0A=
> Andrea=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
