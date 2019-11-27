Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85798C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 08:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 674012070B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 08:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfK0IOu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 03:14:50 -0500
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:25273 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfK0IOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 03:14:50 -0500
IronPort-SDR: vOSqOyXw8HC05bJhzZP6FTTg6h4fSPJPvO1Fb/JUKcrhi9bpGsvBbE7s5YDuAzFxMnG55KrSIv
 Tu/xSe4DvlTNXUfL0f6uhFUnDeLuglWw45XXDkeywb3YTT3sFNbWmuJSrLwmUXIKAPOHx2AsTN
 S6KhqrhjxV2PQhT2Wse1f4PYWwGKo6DcF9rGDN4e5p5o2TliBZF1IRbgDG5g3jZiYpP+vLSj8E
 OmOMOIY4KfGn3yUSpOUraeBNo1arbfG16oii1vzVh/2uwt1NLHhXPoziu73zCAWVI8vUZOBqbQ
 Iqo=
X-IronPort-AV: E=Sophos;i="5.69,248,1571731200"; 
   d="scan'208";a="43556738"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 27 Nov 2019 00:14:49 -0800
IronPort-SDR: BX04e9T2j+gJ4hVUyHYeKaKEEuYFQjU4MfwcvPoT0NPPhyNItdfQayTeyclKm7vY8pxc+SuyYt
 LMTPOnfCybjTbuI2XZOVq6LYbF73aNyNUgGn2v6HUusqVk47dblNyej1Pgjy3X2Z/ZFaCt8n7j
 vb2fLrbqanyEuMzDN+xAHJ90QXdSZ3CM7W9TB9w/Jkx4CLCetFNQBqyghf2YJVIg/4Q/dhU4G4
 QmmQsYmDGnrMeg/ohsZjppVgcW+1+8Enh8sbw7MPQeqCQ3ao4zL278Da2oGzmm9qW2pdtxFahQ
 pIU=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Finn Thain <fthain@telegraphics.com.au>,
        Andrea Vai <andrea.vai@unipv.it>
CC:     Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qcHF7jYFXqX02A+/ZaS0pzdqeAjBMAgANe+wCAFDitAIAAzHgAgACKv4CAAl41gIAAaSkAgAAFKQCAAEsvAIAABMGAgAA8WICAAIDlgIAAV4SAgAEWB4CAAIOAUA==
Date:   Wed, 27 Nov 2019 08:14:43 +0000
Message-ID: <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
References: <20191109222828.GA30568@ming.t460p>
         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
         <20191123072726.GC25356@ming.t460p>
         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
         <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
         <20191125102928.GA20489@ming.t460p>
         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
         <20191125151535.GA8044@ming.t460p>
         <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
         <20191126023253.GA24501@ming.t460p>
 <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
 <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> > Then I started another set of 100 trials and let them run tonight, and
> > the first 10 trials were around 1000s, then gradually decreased to
> > ~300s, and finally settled around 200s with some trials below 70-80s.
> > This to say, times are extremely variable and for the first time I
> > noticed a sort of "performance increase" with time.
> >
> 
> The sheer volume of testing (probably some terabytes by now) would
> exercise the wear leveling algorithm in the FTL.
> 
But with "old kernel" the copy operation still is "fast", as far as i understood.
If FTL (e.g. wear leveling) would slow down, we would see that also in
the old kernel, right?

Andrea, can you confirm that the same device used with the old fast
kernel is still fast today?

BR
Carsten
