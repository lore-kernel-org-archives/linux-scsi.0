Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942C9C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 597F761289
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhD0ILn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:11:43 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:36107 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhD0ILm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619511058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3t03LgMBsrrWWBM4uKqOwcGPGCBKxOZvjHUeOP+vMxE=;
        b=ILyyLbrPLDLttSF6YNck9xg72du1sVdQkThgTwq40NyNKCjmnvAch52VEOtbnsxHIGHlna
        75lj1Dr5P+pA7UXpuRxigKKRDAccbXqIyRhKIUzBBTxse30c6MeJx9aQpIkEnz79ZWghhz
        o6eHwtIRZNOSRG28/MZwRPi+dl1sduY=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-khlGQZbdPQSsu-mgTM-W-A-2; Tue, 27 Apr 2021 10:10:57 +0200
X-MC-Unique: khlGQZbdPQSsu-mgTM-W-A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktU3ikl3BqUBrJwxh0ct8egaLNAHJvK/DYwd3oY9bCvmwHXsBvpkx6Bd8MOAFBpbmHd1eT8ecU17mrzrRJcl5ahpedlx3HxP75jrB0KwsBJAWa2p5kyv1stv1EQzOgr/BAx8Y72els93Az9yM9y6DwY2sLMmr1YL77Y2Xp5BDk1f3QRU4QvnuW58rHwnpWNlFwT84OVATrn1Op/OaKfXFnBw/xGog4PKX4+jQxIDCCprBScCjhpgDJbcaXFnMGWpdHOqSZnKHcp9YXApAPDHCH/1UwlnabIpMMZcDyICz/Lu/xI+TSQMJwBj+kewUfrR1GCiwTgZ0nIMtTprafYhog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3t03LgMBsrrWWBM4uKqOwcGPGCBKxOZvjHUeOP+vMxE=;
 b=WFnozbsb9sqBmv6y9hbwJEyNh6Sn8CwAloUND1fWofYSdES4xsqnrQ7Cq6tIJS1x8u3p8KVXEPUwjcpkfYMgsQjm4DNqmRfevs7lZI4UbqZKMBlh5bsZTK9/wN9rTkt9pzQU1rMwlL3s4IagsfOLC5uKNKOI1pRo7qNOhGBxCAbksvBlhJCyV4TmFyLhaQQ7ysLKXGGEWsXWsY+yH8vWHZpuhUYnSgQFzDl9YnKX43vcm7iLL8KLYxl5SGRtnN0RM0Y9rlZDhgGzVTDHLFRGQt1AJ7cwf/ZdGej7ivIcpje+Iov8x3xsAVW1LVp5W1ECY2CzsabQ/dH3PmTlL02GjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DBAPR04MB7351.eurprd04.prod.outlook.com (2603:10a6:10:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 08:10:53 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 08:10:53 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
        "Ulrich.Windl@rz.uni-regensburg.de" 
        <Ulrich.Windl@rz.uni-regensburg.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
Thread-Topic: [dm-devel] RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrqrHuyoAgABJRgA=
Date:   Tue, 27 Apr 2021 08:10:53 +0000
Message-ID: <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
         <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
         <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
         <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
         <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
         <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
         <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
         <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
         <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
         <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
In-Reply-To: <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 
authentication-results: erwinvanlonden.net; dkim=none (message not signed)
 header.d=none;erwinvanlonden.net; dmarc=none action=none
 header.from=suse.com;
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5068325c-fee6-40da-9d8b-08d90953fa56
x-ms-traffictypediagnostic: DBAPR04MB7351:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7351FA565CF9E2B05FAB89F8FC419@DBAPR04MB7351.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BEiRdmxBWsbbMTVd2LwrVtI4Wk5ufzmKMb2haN0qkl9cB4DMYBTJUF+XOb0hIl5rdPXb35RYsgWgmYG7P+2CrTHJTKG6Xj6NYh4oqtZVcPGku1jGsrWqlhQif/WWTXHySm9X4OAff6wuvlkrL5vMA6mDBlgFOYnC3thslpTqqfB1btP1bGjNiSZJZLHFbSN/81zZPqwUiNdbg2bLmXITndZkC3r+TehSPsKzfgJuOS1Ne0cOdOSjKO5kyOjxod+0Viz0qQGAXmMzCI1L0yx0RCUTyextg0npdT+Y1tTmlCQ3BM12mAV134Qjlw+c1LKqsVJh5059pPeV6YBPjvnfV8OVGdxqgiUN73MNx9xobBXX9XGlsTjQ04/dLyWfUYtqmYRpsTofY0X/cqTqdez8GOnD5UjU/4/8Q8Bl05V8qtNlq8gM338TJQ09wGw0Q2Fz5qR34mDrtXs0e0u3hQIFz9x/LW9clvTA402WoWGGMWR/8rhyvAy7/7zcBY4ty+A6jB9HfoqqlCcIHIH/LrpEhfxLcijbuS+GVd7K3tN+kaXdrULOnUIxyn21caI7m7seB5ZzaPC1o2fVahBWFHahecUUzS7eJ+s2EBRo+sg0cTbb4wUYY5KbD3z5OAn1zpVQWYtuKZV+R8kahOMfceIt2we4Lcmv21K46B8aCfdt4QzWN8CD+PfbQmGhT6zzmOm6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(76116006)(64756008)(66476007)(66556008)(71200400001)(66446008)(6506007)(966005)(86362001)(8936002)(8676002)(110136005)(44832011)(54906003)(2616005)(66946007)(122000001)(6486002)(316002)(91956017)(5660300002)(38100700002)(4326008)(186003)(478600001)(2906002)(26005)(36756003)(66574015)(4744005)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?zEQ5SVNbkX6HyOhVAsAhxE4+Poe08aucPLSARyS4T/eucbziqeaAqgaFo?=
 =?iso-8859-15?Q?mfOBHsd/O8GZYDXzKZpW7OO7oYSNRnCJGKyH5hSYqepIxcVQcwiKpIpRo?=
 =?iso-8859-15?Q?BVDOReOZpLWXwABwu+BtIPnEL2ptL3GWJTqxksYT4mDuMbkC+iMl9RUyn?=
 =?iso-8859-15?Q?EMlyjKmQoCZB2dfz54ULBvWgPeq06XbZrrW+qy2AFzlQo+Gw62bGTh2PL?=
 =?iso-8859-15?Q?wcamLSiDIAE4cY4jqvZewXVqfTsXtwe1NzA4VBUNMRLgUZzclArlllBQN?=
 =?iso-8859-15?Q?tFKaFjrkwboqNf5Or99EF4UsGPUBt5TMlp4OmQyHuX3iWL//fOoaUYjF0?=
 =?iso-8859-15?Q?N8FkqNpaJy3AiwyNTU77FwN6OOZ+aqg13jCXSMkTWTHS2LIawJtjQQwlV?=
 =?iso-8859-15?Q?A7R4tKouF2Lk0AMcqmoyZ5W+lb1XdZuzm5aepCzb15F35EFKcajNWnKyf?=
 =?iso-8859-15?Q?NsHV1wvcvJHzPwEfd/fAGit8Rlb5sy7jyJGJMBSZMOHul0XEj5PsFce9K?=
 =?iso-8859-15?Q?VCcQJLDPmkESQuTcNZA3epil76pv3GR8XQKWP0BzjAjH+Jwdru8bqsC4n?=
 =?iso-8859-15?Q?vUgq4kAcyM3h2AJUQgBQ+ISRgmDRoj9vTQhKZGQle1hjaLgkiw51oxieg?=
 =?iso-8859-15?Q?/cgkFBVLZMNqMw1ZR6BueBCAGUjm5rXB36alQBJhHGBeYvVQCO9GU4crT?=
 =?iso-8859-15?Q?6n1tgSoJvwPpUhZyKdjzfkVr168lhUSD991+v7hA56frGzB6wR/XNSUC8?=
 =?iso-8859-15?Q?A7e3LoE2OCUqBwsPykh1OqjSyk2fQvjycL6tDIj18j4mYHSPNoVXBfBOO?=
 =?iso-8859-15?Q?xM1SzGXw9Sg+y/UqiVSW2yS5h/6tbCO9UrQu4JhgjSmmqxQcEEs2w2J/H?=
 =?iso-8859-15?Q?vIAV1jHMoQR7LbS5gzs32pLAjK5rga1VjWBBmgyX6VHWuhGTqk62bpfHm?=
 =?iso-8859-15?Q?85kprtyETyIfCfEMhIg9gXuTbZAPKfZB1a9JlO6/Sz3xJM6XKeY+efcwD?=
 =?iso-8859-15?Q?a87IPhFnEPP92EzayL936iTPlwojfnC80qT35eM/6+gZqKdoWMs0gWcWO?=
 =?iso-8859-15?Q?YdnRV7cPWcXnopJTN7B3cwDDmFAESCUmmkcJ7wOWeUDNCK75lO+n3dwpf?=
 =?iso-8859-15?Q?Z208VbJ/ilzLUNZVWTDS1m+OxlAYOy7kUiyjiSTsBAQr5B/hW4CHdTkS0?=
 =?iso-8859-15?Q?KQIFgo5BxbHAiFU590lpTsZoZkTQKWztfEGSfL76uP8OC4kanWRhV16ru?=
 =?iso-8859-15?Q?s0Fb1rkJVnYtqwgxT9k98TxyKWJCrBJ0DkTUH3R/op6+ItEpB1tqhApLM?=
 =?iso-8859-15?Q?KxZGnHyk40VZ5Stj9sqZWzj4r5HSFZvMa9Lzbo9CIlVxM2HNeYttG8vOa?=
 =?iso-8859-15?Q?B+tlJbKH6wbtp/AIVr5RUzkep8nzu7NC9?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <BABDA9403B6BC34E94FCE049E80F757A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5068325c-fee6-40da-9d8b-08d90953fa56
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 08:10:53.5912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F/JzZKcgQHJp5tNYtLPR6dGxMzJFCF6LHQcezUve6j3xMSj7a30TClONtLhOkS8nGg8bU/tMr7QidmZN3xK4EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7351
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-04-27 at 13:48 +1000, Erwin van Londen wrote:
> >=20
> > Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
> > afaics.
> >=20
> In my view the WWID should never change.=A0

In an ideal world, perhaps not. But in the dm-multipath realm, we know
that WWID changes can happen with certain storage arrays. See=A0
https://listman.redhat.com/archives/dm-devel/2021-February/msg00116.html=A0
and follow-ups, for example.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer


