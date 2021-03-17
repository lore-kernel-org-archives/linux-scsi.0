Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166A0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 13:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE3464F45
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 13:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhCQNUC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 09:20:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:43015 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230507AbhCQNTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 09:19:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-55-3sGq2adXMGirCyN93jbuVw-1; Wed, 17 Mar 2021 13:19:24 +0000
X-MC-Unique: 3sGq2adXMGirCyN93jbuVw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 17 Mar 2021 13:19:23 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 17 Mar 2021 13:19:23 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@kernel.org>
CC:     "Don.Brace@microchip.com" <Don.Brace@microchip.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "storagedev@microchip.com" <storagedev@microchip.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "jszczype@redhat.com" <jszczype@redhat.com>,
        "Scott.Benesh@microchip.com" <Scott.Benesh@microchip.com>,
        "Scott.Teel@microchip.com" <Scott.Teel@microchip.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>
Subject: RE: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Topic: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Index: AQHXGtT0rSNa450uZ0SMu8nCYRzH7aqIKWKQ
Date:   Wed, 17 Mar 2021 13:19:23 +0000
Message-ID: <4b2a64d91c4c478f881d9713cac5001b@AcuMS.aculab.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
        <20210312222718.4117508-1-slyfox@gentoo.org>
        <SN6PR11MB2848561E3D85A8F55EB86977E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
        <CAK8P3a3JYmhbN3TXB2cWGfXGKgsUa9Hg=ZvWckTaL_31OMgbtQ@mail.gmail.com>
 <yq1zgz21rkz.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1zgz21rkz.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin K. Petersen 
> Sent: 17 March 2021 02:26
> 
> Arnd,
> 
> > Actually that still feels wrong: the annotation of the struct is to
> > pack every member, which causes the access to be done in byte units on
> > architectures that do not have hardware unaligned load/store
> > instructions, at least for things like atomic_read() that does not go
> > through a cmpxchg() or ll/sc cycle.
> 
> > This change may fix itanium, but it's still not correct. Other
> > architectures would have already been broken before the recent change,
> > but that's not a reason against fixing them now.
> 
> I agree. I understand why there are restrictions on fields consumed by
> the hardware. But for fields internal to the driver the packing doesn't
> make sense to me.

Jeepers -- that global #pragma pack(1) is bollocks.

I think there are a couple of __u64 that are 32bit aligned.
Just marking those field __packed __aligned(4) should have
the desired effect.
Or use a typedef for '__u64 with 32bit alignment'.
(There probably ought to be one in types.h)

Then add compile-time asserts that any non-trivial structures
the hardware accesses are the right size.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

