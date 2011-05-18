From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq isnot atomic
Date: Wed, 18 May 2011 09:04:57 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD3E@saturn3.aculab.com>
References: <1305692584.2580.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:48687 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754697Ab1ERIGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 04:06:16 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 07726-05 for <linux-scsi@vger.kernel.org>;
 Wed, 18 May 2011 09:06:04 +0100 (BST)
Content-class: urn:content-classes:message
In-Reply-To: <1305692584.2580.3.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Desai,Kashyap" <Kashyap.Desai@lsi.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, paulus@samba.org, "Moore,Eric" <Eric.Moore@lsi.com>

 

> > > > static inline void writeq(__u64 val, volatile void __iomem
*addr)
> > > > {
> > > >         writel(val, addr);
> > > >         writel(val >> 32, addr+4);
> > > > }
...
> > > > We need the 64 bit completed in one access pci memory write,
else spin lock is required.
> > > > Since it's going to be difficult to know which writeq was
implemented in the kernel, 
> > > > the driver is going to have to always acquire a spin lock each
time we do 64bit write.
...
> I'm just in the process of finding them now on IRC so I can demand an
> explanation: this is a really serious API problem because writeq is
> supposed to be atomic on 64 bit.

Most 32 bit systems don't have atomic 64bit writes.
I'd also have thought there would be code which wouldn't mind the
write being done as two cycles.

I'm not sure that some of the ppc soc systems are capable of
doing a 64bit data pci/pcie cycle except by dma.
So your driver is probably doomed to require a lock.

	David


