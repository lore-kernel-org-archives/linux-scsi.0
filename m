Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36823C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 06:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C6C613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 06:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhD1Gfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 02:35:30 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:33357 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhD1Gf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 02:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619591684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RfqDsENR0IsvXNx8N9GZQptwRsXKZ8RNf6MwOJq5pCQ=;
        b=h/W17a2SGnEj1c3qLvBPv2ANJt01uQDI0rFm3LiIbRjyyYerlkfYEMZdgjbVXE7xvRwadK
        1V+wAKbTjBGQAnsNRtUCSarJe1NER71qR8c5CBlKK4QVQJRGeHKFzGFSA8mXGuLaZ/rR/a
        dWz2+EQis6WE15cp3h1Xaf/raVNf45s=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-0JglE9r4ONyhIgXGgYEieQ-1; Wed, 28 Apr 2021 08:34:43 +0200
X-MC-Unique: 0JglE9r4ONyhIgXGgYEieQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lT0hsNZYM/i9N1Ks3Ztbx8s8JMgkvkAxA7uJJXdTRMbJGE2Qc55PEorxBDKRWK1SngonD37f33KOtpDiXsYUgSCiVZPCpHCqMiyYxgRb2293/u0PPObW84J62cTAHwz5ok+6X6AcjCMytX66otR6Vk5CsbnxPG3kTO6ji8vpwKLsC3GVg4UktRJKKFKTsOWiMjR6gSDFxnwotyKo9kF/2ZrAmYNDybepD+DIIvSmzvC1xui9WymXbBL/JXzDZLvg3VW7ZouKBxERLMil3hP8e3HlX/KVbtr6BEuvmhsc07sKX0m827+i8INYR7cjRyWjjZjx/8avnlsffuLivmvx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfqDsENR0IsvXNx8N9GZQptwRsXKZ8RNf6MwOJq5pCQ=;
 b=KnqI+6OoyjpIIwxjTJ0pXuuGB6aL5HR//2Ium84mHZDqJHCoXfMwtw3HJKQ+FKhknrtS2KIUG9qjd12V/tPL5KJRbazhUetCpxhzkQ/kVmSEe3yLx3LDXmTz+j1tsuoVv21Mn78aLDJFWXpjgszBeoKLeU5JvRPMndpveaYWnwQDHIJibgjEGLiJkWLaUFeUrNa3sqD1fWDb9Wio8JKy0A8Kqojh3xkWQwLIbehSrmzFyyAHUh7RKlzLI+IJiKhuKyQGMsSPPHwlWS+SFzCyJX6defwzRW1A+613E9syAVoUifb7w5MIs7WThNh4VsvTOtYQ7Nk7sOFfh598y+HDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB6PR0402MB2918.eurprd04.prod.outlook.com (2603:10a6:4:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Wed, 28 Apr
 2021 06:34:41 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 06:34:41 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
        "hare@suse.de" <hare@suse.de>,
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
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrqrHuyoAgABJRgCAAALZgIABF3SAgABdJwA=
Date:   Wed, 28 Apr 2021 06:34:41 +0000
Message-ID: <643e5f7eb3e2d48517a3288c07af001b30e22075.camel@suse.com>
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
         <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
         <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
         <ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
In-Reply-To: <ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
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
x-ms-office365-filtering-correlation-id: e10ded24-c0cf-40b9-d4a8-08d90a0fb446
x-ms-traffictypediagnostic: DB6PR0402MB2918:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB29182E363482E4F5F807FB08FC409@DB6PR0402MB2918.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jRXvY6tGTIq61rJLeZbpTD5q0GvYP3qR4isIAssXxUWkUZFOppynf1gMuZs0IwWNPSOte+1RMuex7QuxTiXUl9IWX0ScXFeS06gIBXxxdOI4uFKWr/tzVQxUbNXlVxSpFHWkxjI3CYISJJJ5h9WfK+sNFtMCSF5DtE0SYx2TS3QLNwcx3smGmDYlirxP+5W/NvCFNQi67AFEJ7wCzkD41OaFO8j/yRtIqMvzjjZ7Eyk+JmDKz02F/HFh5iaNfauuAprbJY9ZRVwL9m8ZzD7ukpBNQBkZXT3e1dii1smkHehbkB4aG3jo/CoLfH73QEJvMYRu5C+FpfFlftKeNf0cppQ7o6kGhLruwAdXIjfKE6ioh6RfB0nk3kY+GFoAAIxK352nz49PB++OKRu+pfQn9TvrpLzU+65C70Wm9n5lb2E217J3H66GRA6pdmuRp9b3K/VTg+ai5bJcKTAOdd8k9v9Pl+PWLQQknIAvn6zw+8I97mAq73oVdM+cN1qUdCfviaF85r+1ODno/Vfn3faqY0qKl5dHIdFjEHtO1JZJnghsnADobZeICHkVot3iT/Mxapzt16BIbFg5S02/EWkDBcv0rbHtT2YX2zAUMKKLW8c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(44832011)(6506007)(91956017)(86362001)(26005)(76116006)(8676002)(2906002)(478600001)(66556008)(2616005)(5660300002)(6486002)(122000001)(186003)(64756008)(83380400001)(66446008)(38100700002)(8936002)(36756003)(66574015)(6512007)(66946007)(4326008)(7416002)(110136005)(71200400001)(54906003)(66476007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?HmrwsJfIX2PGjpKLl0DnA33rjQNVMUPRMOHEk8DJZygXSCE75z4rdFIVM?=
 =?iso-8859-15?Q?rp3znzNBey55SiOyDOXFlhtm/weFo4L3BtwAPiyqtrR3heNtYjLiC9EeG?=
 =?iso-8859-15?Q?MltA6niEH8dfUbx5vxH34VTtfnXCZjWs6egKs4Y2WlJnJ9K5SNDtoKm4z?=
 =?iso-8859-15?Q?hxGi8u5sWB04WfVnlspjumyX+wWbvMARezQMyjSvESG4nCZqCX01Y3ZBo?=
 =?iso-8859-15?Q?mrRenOit4NsLBqteA0QQCsZit6MxaabO3iLZKNK4ts68al4oymv6DOUU/?=
 =?iso-8859-15?Q?09s/UQdril0xcyg9MS4OE1aueCzVPjZx6Mlgs//gdjyBTme6JqL29Otl1?=
 =?iso-8859-15?Q?HjVK2lUbemP+cyAOPoZ+g2iPCS9ZiMCFKEg+LLKXUm3QBb+ne50Qzlyir?=
 =?iso-8859-15?Q?W+RPunhO6iihwcEbtAqIBjGXYlzDKXpxxbuieWHMCBZ06IaSGS94aLiGA?=
 =?iso-8859-15?Q?F2rtQXnBZZbyNOyZn041ER7DJzIg0HcSvDPNf7v2bI9eNw47rzGkY0Z4i?=
 =?iso-8859-15?Q?vYYBkO8x+CV9N9bNjWr6qiJtXCphFad6HdkyBt+Hqj6FSGOUaFbKiZK8r?=
 =?iso-8859-15?Q?Emxyk4GnurJZ9Ef2NNdXGf0k+NhJr0dPuwH/5tf+1yScs8KngsYIHrVWM?=
 =?iso-8859-15?Q?ScZYo1Ff5TZbqYxn7oP6We9DbPSq0pBtJBQ0YFOdo2cK69NaJa37beco7?=
 =?iso-8859-15?Q?Zmx7cMoSMH4N7QiryR3Yaw/9m+V/QILuavaS23GRk2vy1LMhs0hFy329G?=
 =?iso-8859-15?Q?VU876667w2k9HW0m4lDfNpYv19RCcU2NbC4a+Or923wx0bkCtVrt+M7OQ?=
 =?iso-8859-15?Q?eUBJEEj4DHgnLlqyOxLjZfXvKEYo1UG0/Hxesaz66hqtBHUvSK/J7Rj1W?=
 =?iso-8859-15?Q?pTydqGr5ktZAeR8vjVOAdR4uMYCwnKmu4MnpQlKmvNRq5GjfGUS9T6oaV?=
 =?iso-8859-15?Q?YhmhpkJdh9yu9u1S5xwyTlHcetlTFaJQcNVt+N3qYM1CEivbb0eZMCIkN?=
 =?iso-8859-15?Q?l8laRHWqCWmseemjsQ0u22/spNmKdvYJWUTFnzEC1NhgrMcOyCVMMf1nh?=
 =?iso-8859-15?Q?5g2nwnRZ6/GnP3qoWxN9koVbEzRixs3Qg3BMf2WEMIyJ9l+fYolVHf428?=
 =?iso-8859-15?Q?I5GZ6af8PEMKTdrgKJLuTHD7SIHqxm0se4sI9g+Q97nmKsyb2XkZyE1mf?=
 =?iso-8859-15?Q?Nrys4+QQfi6euyJBS141OrsMs5Qxa+m4qe2kfZcWYJCoXVW4u6xSIf5fJ?=
 =?iso-8859-15?Q?gUdv/g0rB9GaW1QmFHk3lRy09QPZrujyjj1/1v2v+PMnx2lYnJsX+zeWP?=
 =?iso-8859-15?Q?OTmwi9v9FaiA9sv3DW5Afij8rvPDYG27u6CodXitYR/lUx6bjCpxj8l/f?=
 =?iso-8859-15?Q?jmf6BXLSJYDIqt3sSUpDf+APnKID3EBKn?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <DBACD37E038FFC46B694A487E602089B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10ded24-c0cf-40b9-d4a8-08d90a0fb446
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 06:34:41.4184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAiGi7vpj5cs3LjaAFsRZZBcbc+dLgvBpswnu3tr6mN9GYXkECzNx6ebBTsF2CsgL3XX3kz5Ly2J/fUDh+tvcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2918
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-28 at 11:01 +1000, Erwin van Londen wrote:
>=20
> The way out of this is to chuck the array in the bin. As I mentioned
> in one of my other emails when a scenario happens as you described
> above and the array does not inform the initiator it goes against the
> SAM-5 standard.
>=20
> That standard shows:
> 5.14 Unit attention conditions
> 5.14.1 Unit attention conditions that are not coalesced
> Each logical unit shall establish a unit attention condition whenever
> one of the following events occurs:
> 	a) a power on (see 6.3.1), hard reset (see 6.3.2), logical
> unit reset (see 6.3.3), I_T nexus loss (see 6.3.4), or power loss
> expected (see 6.3.5) occurs;
> 	b) commands received on this I_T nexus have been cleared by
> a command or a task management function associated with another I_T
> nexus and the TAS bit was set to zero in the Control mode page
> associated with this I_T nexus (see 5.6);
> 	c) the portion of the logical unit inventory that consists
> of administrative logical units and hierarchical logical units has
> been changed (see 4.6.18.1); or
> 	d) any other event requiring the attention of the SCSI
> initiator device.
>=20
> Especially the I_T nexus loss under a is an important trigger.
>=20
> ---
> 6.3.4 I_T nexus loss
> An I_T nexus loss is a SCSI device condition resulting from:
>=20
> =A0a) a hard reset condition (see 6.3.2);
> =A0b) an I_T nexus loss event (e.g., logout) indicated by a Nexus Loss
> event notification (see 6.4);
> =A0c) indication that an I_T NEXUS RESET task management request (see
> 7.6) has been processed; or
> =A0d) an indication that a REMOVE I_T NEXUS command (see SPC-4) has
> been processed.
> An I_T nexus loss event is an indication from the SCSI transport
> protocol to the SAL that an I_T nexus no
> longer exists. SCSI transport protocols may define I_T nexus loss
> events.
>=20
> Each SCSI transport protocol standard that defines I_T nexus loss
> events should specify when those events
> result in the delivery of a Nexus Loss event notification to the SAL.
>=20
> The I_T nexus loss condition applies to both SCSI initiator devices
> and SCSI target devices.
>=20
> If a SCSI target port detects an I_T nexus loss, then a Nexus Loss
> event notification shall be delivered to
> each logical unit to which the I_T nexus has access.
>=20
> In response to an I_T nexus loss condition a logical unit shall take
> the following actions:
> a) abort all commands received on the I_T nexus as described in 5.6;
> b) abort all background third-party copy operations (see SPC-4) that
> are using the I_T nexus;
> c) terminate all task management functions received on the I_T nexus;
> d) clear all ACA conditions (see 5.9.5) associated with the I_T
> nexus;
> e) establish a unit attention condition for the SCSI initiator port
> associated with the I_T nexus (see 5.14
> and 6.2); and
> f) perform any additional functions required by the applicable
> command standards.
> ---
>=20
> This does also mean that any underlying transport protocol issues
> like on FC or TCP for iSCSI will very often trigger aborted commands
> or UA's as well which will be picked up by the kernel/respected
> drivers.

Thanks a lot. I'm not quite certain which of these paragraphs would
apply to the situation I had in mind (administrator remapping an
existing LUN on a storage array to a different volume). That scenario
wouldn't necessarily involve transport-level errors, or an I_T nexus
loss. 5.14.1 c) or d) might apply, is that what you meant?

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer


