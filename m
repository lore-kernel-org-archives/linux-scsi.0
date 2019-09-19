Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43D1C4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA0CA214AF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PdbIN282";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lFb64aR2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbfISOOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:14:35 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:29413 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388726AbfISOOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 10:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568902474; x=1600438474;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=NbubgLCTmL6es/gYqmIQNB20koxVQAZCrr5OUvudez4=;
  b=PdbIN282p61GbCYSAxfW7s38LXVp5+HETMMserQpfbMRBG7Rabpny9c1
   d0a1PhFclRziiSUYi047HvTuw1ti0hKOwYfOOoMOtHqj/L3DuR66/7aq9
   cLN3Fs1XjTeEFalD6uva4Ja+JPN/FT80HBPM/mveawyqMFGZuDU2i1ULz
   hLH0kefH0FpYVoxXLNZzX0B8OD8sfYUwL6OXfa3Jnqr8Fx5Kwr+AnYwui
   LRG9M5/cgVsBq1lc1lNToTzQ4smzLUPVM8vVQL3s6USAlyHJJB6MeXxqY
   bhSTb2yUtpHq+LyNAWTQ7H4XuewjMUabxDH9bmQCbI57Wl6qxT2rDM66Q
   Q==;
IronPort-SDR: dznRwaHkIrDeqB1irKv0KNeOyeAWD2MTF9c5nLi9ajcdgY/Q+3OF/hWHb3ruiVzs9QW313hjAJ
 YPdo00hPyU6NdtUBREjmceCBSMvCMxKP1sfPiruLn3LZoFDNQlooSkAipWxYn84h2Wkk/NuBpm
 BbN6c48gfWWHe+YDSpUIx88xtBhg/3JGPb80akK/7uIDLTgPc1AieRvlIHEoZhXV7t5pQnizWf
 /WgAhEtoEhnhumBApmb/L0K8qigBMrzUXVhiuMzr76wHs916WGIjNfmuxLIyNSJU/4HYTgsvTt
 Smw=
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="123111947"
Received: from mail-bn3nam01lp2058.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.58])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 22:14:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fuil5SqK3N758LmZaYa1Dn9tRSxww/wZOQzgT+OdPkPkqhoxfeudRTb9+7kv3wCFmREAI+JkIAkLPk0uqz86ufNUghr5oE+Fqjvr0H/pUPTxjrbqBOqmomTh7Ft6KOlccL/uY1HYz+mnMUftdyhEbtabIR7Z7zQJpF8KxsC4iT9gNO5BQTVPVWMk+zh8+jprhLebrLN0AId0fzEyi6AB+VNKjf4+H+8WwEzNFkWbypmAu4Fh2dEi5dAfA+be7ubxxDcdipXp5j2A2jdPPKU5Vi6GeDDTjgB0lDSchfp8Z6alB+sZI4MvAca/Nl5WumV5pzvHr+RDOv/LvfSnLN2EDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwAYDxVB7vGyl1aeF0XqSeJ9s3DdM6bCiU15OwPYRIM=;
 b=M/s991AkFVPF99rdp5/k5Zl1xW430XxWbs+T5+d0i3Qw+xtxS0W8L0myIuTg8s6NbFs1w+PxmJcInvGZgxIGeQwW64fGtILPfq5+o2w5my/aowLnaYf47TnAsS8GCx06r6qUNEeguWcoi0bzVmuLKuTqRY9RcKAan/4DPfxxS6hYNnuNIahMisoLVQz8xudlk4wlL+gEtzlFzJdSpEM5Gpp9qomvttd4N582vDbUpDtL+EMQVml0ljwWmV9pvqwGWaNX6wLTztLRYb6NjqUFofsZ3Zu0YKENOrnrSSPKwj5gTwdQtSX6hdtdNjZqfMUxF5m5TKXkQzZP7C9Jl9n1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwAYDxVB7vGyl1aeF0XqSeJ9s3DdM6bCiU15OwPYRIM=;
 b=lFb64aR2NNvPuN9MgfqTDOix+3+e+X+s9gQZUhAk3JeojJVFJgJBmc0TvuXEETF1L6Jm353yXSCbQcO2Dbw8DFhDGvLqCMGQyh9/rKST5JlOaizIlE9Ay+6fQFCN1ELyXgDF6ybvQo14t93sOqT7nwrYNKk7nfQZ0VBJ1M0jIP0=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4229.namprd04.prod.outlook.com (52.135.202.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Thu, 19 Sep 2019 14:14:30 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 14:14:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Andrea Vai <andrea.vai@unipv.it>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qbTKYWY4pSG0OtJLbZzV/0bg==
Date:   Thu, 19 Sep 2019 14:14:30 +0000
Message-ID: <BYAPR04MB581603F036943752D799AD5CE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1909190958140.1585-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [193.86.95.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c60b252f-1020-46f0-fcd1-08d73d0bb027
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4229;
x-ms-traffictypediagnostic: BYAPR04MB4229:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4229E6B8E829B477463545B1E7890@BYAPR04MB4229.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(199004)(189003)(2171002)(5660300002)(7736002)(14444005)(6306002)(305945005)(256004)(486006)(71190400001)(9686003)(66476007)(66446008)(64756008)(2906002)(66556008)(6506007)(55236004)(33656002)(102836004)(66946007)(14454004)(966005)(91956017)(99286004)(7696005)(316002)(6916009)(6246003)(7416002)(76176011)(74316002)(25786009)(53546011)(186003)(476003)(26005)(478600001)(229853002)(66066001)(4326008)(81156014)(55016002)(446003)(6436002)(54906003)(71200400001)(3846002)(6116002)(8676002)(8936002)(81166006)(86362001)(76116006)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4229;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0wLPrM2nvM60HcqjWbxrA87G8QJlPS1nrGUFp+rJIhf/6OtKO1F2JmSow6T4+4n3ZWQ2kiWr2BHNwyBQSM+PfO9HjzUZc2v419bYmunJkvqCrzYNCBIIcKIpjozOnmZmzSMww8W/ArdHl1d9SLZfOJKBgxV7M4GAJE5GDciyuOeFM6huOVE0qqy0gFLp2l7WNGRC3tI83KndeTtrRA7ihpSOdPWN2mZB8vtthp60oF0VhcfH8LufnlRNVMjrVEfnqxUFRZfFNOAypPkIwW9qMTY1Z8eDvWGQbrDmu6ZrrpDDrnleaXk3olJXXDbjit0ClgaCQtJO1GiKaKrVkuDgujj76C+Sfh8RHxcOaZ3gp6OQhPlwYhrHsnZ9o7d/mgXwqPYZzS3WV5H+Z+almcogMtM4dlKF5mOr/IoEtdcRTLU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60b252f-1020-46f0-fcd1-08d73d0bb027
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 14:14:30.3950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BRpKJm0TmPnJXKiFX7FVpJ1kgsEGqSEYzIEe6KuGwIKScrmju3rbR4CmvHNzINNuBkMxoMo2mdgJDTXYj7/1JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4229
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/19 16:01, Alan Stern wrote:=0A=
> On Thu, 19 Sep 2019, Damien Le Moal wrote:=0A=
> =0A=
>>> This is exactly the sort of difference one might expect to see from=0A=
>>> the commit f664a3cc17b7 ("scsi: kill off the legacy IO path") you=0A=
>>> identified as the cause of the problem.  With multiqueue I/O, it's not =
=0A=
>>> surprising to see multiple sequences of block numbers.=0A=
>>>=0A=
>>> Add it's not at all surprising that a consumer-grade USB storage device=
 =0A=
>>> might do a much worse job of handling non-sequential writes than =0A=
>>> sequential ones.=0A=
>>>=0A=
>>> Which leads to a simple question for the SCSI or block-layer =0A=
>>> maintainers:  Is there a sysfs setting Andrea can tweak which will =0A=
>>> effectively restrict a particular disk device down to a single I/O=0A=
>>> queue, forcing sequential access?=0A=
>>=0A=
>> The scheduling inefficiency you are seeing may be coming from the fact t=
hat the=0A=
>> block layer does a direct issue of requests, bypassing the elevator, und=
er some=0A=
>> conditions. One of these is sync requests on a multiqueue device. We hit=
 this=0A=
>> problem on Zoned disks which can easily return an error for write reques=
ts=0A=
>> without the elevator throttling writes per zones (zone write locking). T=
his=0A=
>> problem was discovered by Hans (on CC).=0A=
> =0A=
> Is there any way for Andrea to check whether this is the underlying=0A=
> cause?>=0A=
>> I discussed this with Hannes yesterday and we think we have a fix, but w=
e'll=0A=
>> need to do a lot of testing as all block devices are potentially impacte=
d by the=0A=
>> change, including stacked drivers (DM). Performance regression is scary =
with any=0A=
>> change in that area (see blk_mq_make_request() and use of=0A=
>> blk_mq_try_issue_directly() vs blk_mq_sched_insert_request()).=0A=
> =0A=
> No doubt Andrea will be happy to test your fix when it's ready.=0A=
=0A=
Hannes posted an RFC series:=0A=
=0A=
https://www.spinics.net/lists/linux-scsi/msg133848.html=0A=
=0A=
Andrea can try it. But If the USB device is not multi-queue, this fix will=
=0A=
probably have no effect.=0A=
=0A=
Andrea,=0A=
=0A=
What is the device in question ? Is it a USB external HDD ? SSD ? Flash key=
 ?=0A=
=0A=
Best regards.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
