Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47381C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 14:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317002088E
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 14:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgGCONX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 10:13:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:54936 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgGCONX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 10:13:23 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-232-7a4D6a8JMaaW9UdW1wsuQQ-1; Fri, 03 Jul 2020 15:13:19 +0100
X-MC-Unique: 7a4D6a8JMaaW9UdW1wsuQQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 3 Jul 2020 15:13:18 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 3 Jul 2020 15:13:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Machek' <pavel@ucw.cz>, Ming Lei <tom.leiming@gmail.com>
CC:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Thread-Topic: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Thread-Index: AQHWULYhYreg4fhW4ECsy5wvxicAqqj15X8A
Date:   Fri, 3 Jul 2020 14:13:18 +0000
Message-ID: <2c38b7cd0aad46ec9f8bf03715109f10@AcuMS.aculab.com>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
 <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
 <20200702211653.GB5787@amd>
In-Reply-To: <20200702211653.GB5787@amd>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Pavel Machek
> Sent: 02 July 2020 22:17
> > > during a FLASH write or erase can cause from weakened cells, to much
> > > larger damage.  It is possible to harden the chip or the design against
> > > this, but it is *expensive*.  And even if warded off by hardening and no
> > > FLASH damage happens, an erase/program cycle must be done on the whole
> > > erase block to clean up the incomplete program cycle.
> >
> > It should have been SSD's(including FW) responsibility to avoid data loss when
> > the SSD is doing its own BG writing, because power cut can happen any time
> > from SSD's viewpoint.
> 
> It should be their responsibility. But we know how well that works
> (not well), so we try hard (and should try hard) to power SSDs down
> cleanly.

I hope modern SSD disks are better than very old CF drives.

I had one where the entire contents got scrambled after an unexpected
power removal.
I suspect it was in the middle of a 'wear levelling' activity.
Even though it was only a FAT filesystem I was glad I didn't
actually need to recover any of the data.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

