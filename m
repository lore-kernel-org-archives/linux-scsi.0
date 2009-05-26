From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH 4/4] bnx2i: Add bnx2i iSCSI driver.
Date: Tue, 26 May 2009 09:49:01 -0700
Message-ID: <1243356541.29526.27.camel@HP1>
References: <1243113110-29635-1-git-send-email-mchan@broadcom.com>
 <1243113110-29635-5-git-send-email-mchan@broadcom.com>
 <da824cf30905260937s4029fe7crc723da03fba08c7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3946 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbZEZQzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 12:55:33 -0400
In-Reply-To: <da824cf30905260937s4029fe7crc723da03fba08c7b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "davem@davemloft.net" <davem@davemloft.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Tue, 2009-05-26 at 09:37 -0700, Grant Grundler wrote:
> On Sat, May 23, 2009 at 2:11 PM, Michael Chan <mchan@broadcom.com> wrote:
> > New iSCSI driver for Broadcom BNX2 devices.
> ...
> > +/*
> > + * iSCSI Async CQE
> > + */
> > +struct bnx2i_async_msg {
> ...
> > +#if defined(__BIG_ENDIAN)
> > +       u8 async_event;
> > +       u8 async_vcode;
> > +       u16 param1;
> > +#elif defined(__LITTLE_ENDIAN)
> > +       u16 param1;
> > +       u8 async_vcode;
> > +       u8 async_event;
> > +#endif
> ...
> 
> Michael,
> I'm feeling a bit dense and am not seeing why byte data
> would have to worry about the 32-bit word endianess of the CPU.
> Can you give an example of why defined(__BIG_ENDIAN) is needed?
> 
> Normally the _*ENDIAN defines are used for bit fields, not byte fields.
> 
> Byte data addressable by the CPU (e.g. host memory) is at the same offset
> regardless of endianness of the CPU. I feel like I'm missing
> something that should be obvious.

Hi Grant, these are what we call "DMA control structures" as opposed to
DMA packet data.  Our chips are configured to do an additional 32-bit
endian swap on all DMA control structures.  This way, all 32-bit control
fields (such as length, status, etc) will come out right when the driver
reads these fields.

If everything was defined as u32 in all these control structures, we
wouldn't have to add the #ifdef.  u8 and u16 fields have to be defined
this way or else big endian CPUs would read the wrong offset.

If you look at some of the control structures in tg3.h, you'll see the
same thing.

Thanks.


