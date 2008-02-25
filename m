From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: Patch added to scsi-rc-fixes-2.6:  [SCSI] arcmsr: fix message allocation
Date: Mon, 25 Feb 2008 18:47:49 +0800
Message-ID: <000401c8779b$de5619c0$8800a8c0@Nick>
References: <47C29506.4000609@gentoo.org>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:25231 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbYBYKsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 05:48:04 -0500
In-Reply-To: <47C29506.4000609@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Daniel Drake' <dsd@gentoo.org>
Cc: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, 'erich' <erich@areca.com.tw>

Sorry, maybe I did not ask distinctly enough.
I mean if I would like to allocate a memory space from ZONE_DMA for ato=
mic
context, why can I not use kmalloc(1032, GFP_ATOMIC|GFP_DMA)?
In case of lack of GFP_DMA, kmalloc would grab the memory from ZONE_HIG=
H or
ZONE_HIGHMEM, isn't it?(I read it from the textbook of Linux Kernel
Development by Robert Love)
Or the basic is that you don't think it is necessary to allocate a memo=
ry
space from DMA area?
Please give me some comments.
Thank you very much, :-=A1^

-----Original Message-----
=46rom: Daniel Drake [mailto:dsd@gentoo.org]=20
Sent: Monday, February 25, 2008 6:15 PM
To: nick.cheng@areca.com.tw
Cc: 'James Bottomley'; linux-scsi@vger.kernel.org
Subject: Re: Patch added to scsi-rc-fixes-2.6: [SCSI] arcmsr: fix messa=
ge
allocation

nickcheng wrote:
> Hi,
> I definitely agree it is in atomic context but why is the memory not =
for
> DMA?
> Would you please show me why?

It would probably be easier if you could explain where you believe the=20
memory IS used for DMA :)

Anyway, looking at ARCMSR_MESSAGE_READ_RQBUFFER
current code does this:
		ver_addr =3D kmalloc(1032, GFP_ATOMIC);

Here are the cases when that buffer is used:

checking for successful malloc: not DMA
		if (!ver_addr) {

copying the address: not DMA
		ptmpQbuffer =3D ver_addr;

memcpying 1 byte into the buffer: not DMA
			memcpy(ptmpQbuffer, pQbuffer, 1);

incrementing address: not DMA
			ptmpQbuffer++;

memcpying from the buffer: not DMA
		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
allxfer_len);

freeing the buffer: not DMA
		kfree(ver_addr);

Daniel

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
