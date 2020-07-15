Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FF4C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A7320663
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:56:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AB1It21r";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h3XWzUFC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgGOH43 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:56:29 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:7049 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgGOH42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594799788; x=1626335788;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=AB1It21rYP5IqDBWyU8bQsrWZiGHxhW0qlhp3qUia2AP7Z3tcyMqmdr1
   Rpin1Kr7RRn83mb7bqsCaqaKcAxtWF/MTN1atMwjOajXJLflZGoj+Ugla
   RACyFMLe0yyRlZNe9fgWqicJQ1g2ynqdntNJWPwQwl5tf0sWlE2gUyeiF
   5oBiAgZUP/t7PemqzSDPTEtG4QhAvbOp1rCVRjTg6KvX4Reo8xXqG/5rh
   1SizgSS3TnVQsm2UKm8gIq3PYub6LAVVOQ98HMx5ntlXpqeFwYLMnlmbR
   agCbc6du7oZRFjDM+D2Q6PIJFZK5Ke2LfQeLhTbzB9L7aI0d54MdzPazD
   A==;
IronPort-SDR: cFrZNX8Er5/JdP6cioeU5DNoI8cas+gM6/y0ZbrPS7GbDdOm+MVGf0uF6akAswBbLVmua/K/OP
 IJZn7rr72bXW7x/4X6clILfYuDJ4fz3VE7ib1NhKx5JOOUxEPZ3NyjGj5cQb8AfIvjPo4ArJus
 X1tFOS7qYBZRESIfkr2vw2kK+oa0clQFkmFLWIgZEsw/u9eLt0IlK8Tt0m3uuT7y4uvqDsyZov
 6rgmUTt6gmwPRjPDVm5B4CmVdzf/YsAs1w1vu/ZrUKZijyzTO7+1lZyc6PoZIeM+Dl+F0RxjOc
 b4k=
X-IronPort-AV: E=Sophos;i="5.75,354,1589212800"; 
   d="scan'208";a="251761914"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 15:56:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuKPdxvizNm/1ohNV/QDTNmusGq+Mv8Qxkwqe2VylrThOaEj3qLgMOJwJDLv8mjf4W/pTtwW9lZebX0KU7ZCZxiuSPgurnoNR4aLRdg9dG4NvQrzBpktoSYGFeYhueXmal6F7185hb/idzwCpmNcx0t6FL1YnxDwTY/O7J6hXzytRJ/3WbZ7ePEJruQkB8HHM3veEBK/IaJp5zrauuoAdy6Fb5/r/2in/RCUOM6Ca4nh3vUjBIYT8JagMMDFZ7WgoLdi3NyCuJfGZde5mcB2fz0jplCHNaagXn1mNK3cMREMJAuLF/HEUgOefneFKYJOrvJxv1W+Ip1NnnWcG0bWcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kq/4geSe0aZGRPbB3mRKuNCYoDGThZmh2arz305idF8f6nvfx9csisSpJbHBkEo4ASyGQKEiaX9qvR6ezKKgIETxzvcMT/v44Si7D7jQ+SrNXbp8KyarpFsxYrAL7IAp4wvSZVq9WqIi25mWc5HZ0jmcBCDbcClc8Qy9GkTFkNYzlNsd6rlDr7LO8y/zukdQgDr52sANqFFBSwXvkyatXb7YdBfF+3AQMINGI7t+m4ecZ4XRTEyfwrquKX3QtlUkMLSBpXUbELKVQ26jAhg84DWLXguS5SgrGF+nnJCSg631fZEIqM79G7qHFKzWk8dNw5LTK03PLXMtLc5gGhWYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=h3XWzUFCm6AVr2Z+dxCB2hauURlqIXyaa2tL7mlfuivM0O27RFm8+J4HSo9gfFMaJxuxaGKPe5fio6guOFBfmpDP5wtPgftysZOapEvEA2GjRdHsHcgGIRB1DSWIbUg1blsTXlpm6woZOnqN720WpKOIOGVKnem8jd1knVMyUeI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5248.namprd04.prod.outlook.com
 (2603:10b6:805:fc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 07:56:24 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 07:56:24 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH v3 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWWiRfm0muraPkfkuVjZaSpLS7Lg==
Date:   Wed, 15 Jul 2020 07:56:24 +0000
Message-ID: <SN4PR0401MB359824D7C277AC260D94964B9B7E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200714211824.759224-1-niklas.cassel@wdc.com>
 <20200714211824.759224-2-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:853f:9b43:c773:dd89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ba75393-d640-4107-eab9-08d82894922d
x-ms-traffictypediagnostic: SN6PR04MB5248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5248472BBE4B6184DEE5A7059B7E0@SN6PR04MB5248.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H2gmGJBIn8CoxqAAtBqltrTDIQ9Kh4MTY52a40QLyGEGtEWh+I69b/0Ok8pcB9ykIhe4dbaoRoMecp/D4Efg88oYKgzKZgs6gWxieYbNEsHPBrS/DJk544hazAoTC6yeeFbufHEE/qKSjZ5Gd8On7qUE/snASgNXsGbzAqM1uBaPwPpovjWpEFv2jtMTFnLXsa92XEl/XZ7SBkOOo4wMQfEUxTLQ6Cd2w67QMEsgnCR6G4cE3BsZsF1OmKosXY62D+ogb6b9pXt9aRyDtuv34hmOYki/2vHYcy+Ut4rOf6MtZUkqgKuN+PPosgXbVO4149ihu35/gee05C4LxS1pHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(478600001)(54906003)(8936002)(7696005)(7416002)(186003)(9686003)(110136005)(2906002)(6506007)(4326008)(55016002)(52536014)(33656002)(71200400001)(5660300002)(66446008)(64756008)(558084003)(19618925003)(4270600006)(76116006)(91956017)(66476007)(66556008)(66946007)(86362001)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CwRpI8taTulQlUxEQM8dlryOj2cSydImPu+rh76L71q5Lwf2KSpoHatXrSW/pquPIkBoXlbpbmByqeekDrq+T6gro4vf7l7AMzyv1D0hLeEnucp62Hk/PKwCWllIR3dUJOx1BWjXR/QRpZDHVI5Xn0ZUwJrCcTKIICgZycE2Ggc3WYWSB3xPWnr/Xll0TT8y1UPoLCSlvsfs8DQXPA4DbA9pKi9qI8WaXDm7Qs6n2rIBD14HqxEjUhc5NTlp1J5TZOgYMrGgRqW0F5riJFmq0KtFP99uwARCSI50uSDdeSpPsJpXQ+FPBvEMrGt37bzBWggtHMyfcVyrPjsyBVqUZcf2LoZUdLIbkg8lBZrfrpSVnSry9pWLyoJy5iCDjM7XRzHXfRyA2SfuPFtlROuhkRM1IRbvcl6jb4lnLBvloNmqX9WZ3w5KjIkHQmA1GQAVGsUEtq3i+6MPRtPq4o5Q8BDCgPxwqnxXRmCtW26NrbeI0wI+YJ0rHREV8dQF6f5TFMHiNZ3l0RIPJwjiSFrot7EsqJup1cPfaJuu/9OpripCBHEfuILJnBvx7sHY8yCz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba75393-d640-4107-eab9-08d82894922d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 07:56:24.4879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxVCPzdt/zzfeifdXbGoQn/IFYRDIyqKHlsF+qGd/4LlLYxe4zU9nk4jQWGN7D1idTnE6aH5qUpG5jtIAxUj1jR37cKdewZ5cK7Ah2w/4LE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5248
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
