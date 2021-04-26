Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA005C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 13:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B5C861359
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 13:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhDZNRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 09:17:46 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:36696 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233558AbhDZNRp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 09:17:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619443023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fbl08M4+mpu2Qx1cumaS4nej3BezNw1+DeUp+IdDgT0=;
        b=FZaoOcOs3907hMSG4CuRRAORjIIYL8h9b7KJPC8OSiC6f94um7jir1BLqUGOi2EZfdQmJO
        TWrhHlPWrMX9Aag9FoAjsb3IINn+OxsGm+PYCZ+bARH4TIoq5+QKGTrpyTTEEzOh2Fw9hp
        ozFiC9CswDKRHUXyV9AyGiqKk5msUEQ=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-YHU2edWvPvCFWWjT5Os39w-1; Mon, 26 Apr 2021 15:17:01 +0200
X-MC-Unique: YHU2edWvPvCFWWjT5Os39w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLN0XEJf4s/Kw7z6aSaY7pKS9oP7LWIzztzXvI0wqW0Pu0wu19MouqMa0wabicloIAGS2Tnad0UlgVdO1W14ZBRD/A4lATS7fF686ykXM0X681G4WD/8L0aRZRIlY1PoT8VG0FS4a5/CP2jCMYHGwnhfjC5jee00oFOVD9KQ6X6Ag1KNgnAhGZT71rTbtxUlp5mx8jDc0cjNYQTTZ4OFw17YRIKQRXJPmgOc3ImP+owaggM8uT6X08lV3smIm6QIF6Sj0KmIEFRMul3B23qPzme8Vt0o/VzxSypMnFcynv3xGWV0BqiAcCsJe4Vawg+lICUitYD6Nr6aL2iB2hgGLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fbl08M4+mpu2Qx1cumaS4nej3BezNw1+DeUp+IdDgT0=;
 b=T1iaUQEavylAz3ACao+UZx3Jw0jFkfr+GpRW699bosUEnVlnkxGsttk8ADCdAwD78WUp7FCn/7cnGXV0ictMoa9V2wLzxsji9pyb4HLPTys10/TWzEir5X0dcC+lPiz7rRYKz7X3p8Mdlwf1zhQQP34/Vz7T1GcpHgNjayAKkoNtfg0zX9iNXhihYDyiMAn9K1kwK2xS99hWNeHRGaSo3MYo2ftUHuV/XO8b2uvl9jf5fXcD0EHH8wvdbt8TmA2dMwORc0/tlezwsv91okPk5QlrSnL1DtMEptZ25c5qnc71oihD2Fb4xCLpcuN7nidrJzGxHFLbwncwslJIhseZqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB7PR04MB4618.eurprd04.prod.outlook.com (2603:10a6:5:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 13:16:59 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 13:16:59 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "Ulrich.Windl@rz.uni-regensburg.de" 
        <Ulrich.Windl@rz.uni-regensburg.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "bmarzins@redhat.com" <bmarzins@redhat.com>
Subject: Re: RFC: one more time: SCSI device identification
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrg==
Date:   Mon, 26 Apr 2021 13:16:58 +0000
Message-ID: <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
         <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
         <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
         <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
         <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
         <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
         <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
         <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
In-Reply-To: <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 
authentication-results: rz.uni-regensburg.de; dkim=none (message not signed)
 header.d=none;rz.uni-regensburg.de; dmarc=none action=none
 header.from=suse.com;
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e55b656-3a11-40e5-55c5-08d908b5928c
x-ms-traffictypediagnostic: DB7PR04MB4618:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB46182435EDC00C095EABEE19FC429@DB7PR04MB4618.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lRK7FTyG/koDg4KnnBxASO2yX8bFw7YUBhW9saeFCheEj3jJkNq7inKgizeyvOMQZB15KxSIt3wq3n6p7C2vfEYaZGO+FyArfedGLkyWwchbWhOsoPK9XK6+sIwglX71vkLL7sGg/rUqbKxdB+1iUTblkMJKF0KLrdeWFsZViyeFxhp1g7bXFGk5644nB8qcf9RIAYDOQeV9tuWbPxdHyNSLsFaDgDdCdSAFDUzh1EUtMFsDoRrIFWzESCYpHsVxzO+4BosRtpXz7RWCtRzPJuIGoPpIvuGkoS+WQvNmNwrTh/B3iejEEzQIjkpNhsdShTYOme9MoSGlA6Ps0yxYF2e4p6dQYLxSwDkJc0lQ3KgvV7kjmqum1ZNjf7Y3kAGyEHdwPqLG2fBnEtCwG3gUap3ifzICfBY2JpFtyYGtmu0EqGpe/eAcX/IpcsOioB+tLLj7YwKr8lMmg6wMAVeBb9+0wxf9XXvPbQG7dRrQ9cpPVioFn75hsVulfyeljvWpWmQL7wERQf2pPsAY0zoPuW1DopUHRLBtLW3UNDtj5eeFpwflD+41ggos64yw7ww2fe43T6zf1sXUkFbgONl3IDkJlEj5u+lZ7abx+wevE4M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39850400004)(396003)(366004)(54906003)(6506007)(2906002)(110136005)(86362001)(316002)(36756003)(186003)(26005)(71200400001)(2616005)(83380400001)(4326008)(5660300002)(44832011)(122000001)(6486002)(64756008)(478600001)(66556008)(66446008)(66476007)(76116006)(38100700002)(66574015)(91956017)(66946007)(6512007)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?V2HxDLFse0mqDy7Loy8lDpFT3tn12pTq9+Z12vqPcxv7t83dKH4WZSjCO?=
 =?iso-8859-15?Q?R+dgwLO/I8lDju7/1DSFmuAZaJqICE/L2CvO7k5UldM9hgiopMNXf8vrJ?=
 =?iso-8859-15?Q?l1Y4nfGe5uzBq4ZTua5OZb36QP5Gjcv/f4m8AzSKFJ7fCuv8280pMGOBu?=
 =?iso-8859-15?Q?3y4JNM+wrg+BOo0/YE0Ouq2nvviuMG46TNgDVZmNscL4F2hoxbxW6ReMk?=
 =?iso-8859-15?Q?JJ1Xl5KxGdf+G6drrtbwNFTnrJihRazqnAOntVKaX7NVmDnazfPcTxqi9?=
 =?iso-8859-15?Q?DTqKi15Ee1ZR6F1IDLeQeOx81W1/oqOQEJdqrQRlmYPcsKThKVpPX05Tn?=
 =?iso-8859-15?Q?Fm76HN3PoYwKCfKLdskF5oRONIKTbuxCLRPjSZvaQe0OOHReb4BUHFw0X?=
 =?iso-8859-15?Q?luBbjx/kR/PWGgDZLn2P+4+7yVGGe8Ue82A0R4knd6iMlxq9iMQBkVo+k?=
 =?iso-8859-15?Q?9PB2ORK0UxVkgWU0pW+XrNNc5PNjmKOmXEp08z275Wnviz0dWIIqJJtGA?=
 =?iso-8859-15?Q?aQh45bvbl0WtglfFE0GIk53FL314yizXsXALo9qpAEQrN9kO0mcXgesGF?=
 =?iso-8859-15?Q?q6HKLVBmi5MkTgzp5DWi028WNfKgrt1JyXsSzJ03qSIhHxvhGCw/+z2Ny?=
 =?iso-8859-15?Q?0rAf6yMvs/KEDnRsnU3zHq7cpVt7bEyKykjc2oLhfWyTHxIz7b8KVpv09?=
 =?iso-8859-15?Q?KTNUd3ARiOVoB2o9oRgMcllL1wlYpWS/ftQzPpD60NMLYumd6HuV6wb4N?=
 =?iso-8859-15?Q?0ziY8XjaQ5R+1hASQ85GkRcoCatKqixfXVqAkODkMQ7ibqmqlV066Rb2z?=
 =?iso-8859-15?Q?S4+anHcG5LiNqqXeyC8Hn4hNRof16NKJu7wkIZy5zv9+pkE6LCHNNNGvp?=
 =?iso-8859-15?Q?qabxfxMyOkIHCy7yChxpQ1b4IYK49AmGLOPBhDW6Eopq8yXH0ykoQIyFt?=
 =?iso-8859-15?Q?x/TRAfgTLaU59Xdvri3VuXkSJu9RpbUmet7Y0ldABa/jmQ5HVGo64aEDO?=
 =?iso-8859-15?Q?gQ2xAIJH7+c4vPVEJjQmoZ1PMUlmNYEGIz6sLq3KVacuAQii+TetdPk/e?=
 =?iso-8859-15?Q?qXWBWZrTac6jvnkwPUDYM3OsxYBPE9C6FA0rIE/US6vUAlM4l+ps+btkT?=
 =?iso-8859-15?Q?6M4AvCZIrDYolzCbN24UbN1g6tC9AFJGq3VI3IhcMiWyr1FHJoik8btrw?=
 =?iso-8859-15?Q?x3kGTMua+gXp5LzP3phDxprDNReay6wcKrS54mnXNMYGEveLW7l3Tie1O?=
 =?iso-8859-15?Q?yp/rAAMuH7V+opF2mg6ey+CHY5IcNp/dtFxDjl2w+TX6krK1zGsT37Mtd?=
 =?iso-8859-15?Q?dLAAjHQXi4ohf2N7x6OYrE98eBfI3t0Gb+OhQU7aDBNf8QiycDbaDjgRN?=
 =?iso-8859-15?Q?CQ/bptf6WnVHdcdgJbazRJujNhbC+dQ/q?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <F5CFB572D8BA14429034FDCFDD757CDC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e55b656-3a11-40e5-55c5-08d908b5928c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2021 13:16:58.9329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GP/s9mROFEQ1bcmmnCOyTF2fN7MK9Z73ZjZq5V9nznSz9GzVOyow/PBUBxDBAfaEtoG0CqVsQK6FyHIJESUN1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4618
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-04-26 at 13:14 +0200, Ulrich Windl wrote:
> > >=20
> >=20
> > While we're at it, I'd like to mention another issue: WWID changes.
> >=20
> > This is a big problem for multipathd. The gist is that the device
> > identification attributes in sysfs only change after rescanning the
> > device. Thus if a user changes LUN assignments on a storage system,
> > it can happen that a direct INQUIRY returns a different WWID as in
> > sysfs, which is fatal. If we plan to rely more on sysfs for device
> > identification in the future, the problem gets worse.=20
>=20
> I think many devices rely on the fact that they are identified by
> Vendor/model/serial_nr, because in most professional SAN storage
> systems you
> can pre-set the serial number to a custom value; so if you want a new
> disk
> (maybe a snapshot) to be compatible with the old one, just assign the
> same
> serial number. I guess that's the idea behind.

What you are saying sounds dangerous to me. If a snapshot has the same
WWID as the device it's a snapshot of, it must not be exposed to any
host(s) at the same time with its origin, otherwise the host may
happily combine it with the origin into one multipath map, and data
corruption will almost certainly result.=20

My argument is about how the host is supposed to deal with a WWID
change if it happens. Here, "WWID change" means that a given H:C:T:L
suddenly exposes different device designators than it used to, while
this device is in use by a host. Here, too, data corruption is
imminent, and can happen in a blink of an eye. To avoid this, several
things are needed:

 1) the host needs to get notified about the change (likely by an UA of
some sort)
 2) the kernel needs to react to the notification immediately, e.g. by
blocking IO to the device,
 3) userspace tooling such as udev or multipathd need to figure out how
to  how to deal with the situation cleanly, and eventually unblock it.

Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
afaics.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer


