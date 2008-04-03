From: "Sanjay Gandotra" <sanjay.gandotra@exar.com>
Subject: RE: Help On Adaptec SAS Controller AD-483000
Date: Thu, 3 Apr 2008 10:57:09 -0700
Message-ID: <90500F9127D5CC40BE9D712D8ACCB4860864FD@fre1exch00.hq.exar.com>
References: <90500F9127D5CC40BE9D712D8ACCB4860864F6@fre1exch00.hq.exar.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.exar.com ([204.154.183.10]:50750 "EHLO smtp1.exar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYDCR4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 13:56:24 -0400
Content-class: urn:content-classes:message
In-Reply-To: <90500F9127D5CC40BE9D712D8ACCB4860864F6@fre1exch00.hq.exar.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Can anyone please suggest me any SAS raid controller which supports
hooking up SATA Port multiplier? As I mentioned earlier, with Adaptec
SAS Controller AD-483000, when I try to send FIS reset to the SATA Port
Multiplier, I get errors from the Adaptec f/w / driver. The command I
send out is:

1. Send Nop with SRST bit set to port 15
0x27 0xf 0x0 0x0 0x0 0x0 0x0 0xa0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x4

2. Send Nop with SRST bit clear to port 15
0x27 0xf 0x0 0x0 0x0 0x0 0x0 0xa0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0

At this point, I am expecting the Port Multiplier to respond with
signature fis.

But I get errors after first command and subsequent commands don't go
out on the bus.
//sanjay
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]
> On Behalf Of Sanjay Gandotra
> Sent: Wednesday, April 02, 2008 5:02 PM
> To: linux-scsi@vger.kernel.org
> Subject: RE: Help On Adaptec SAS Controller AD-483000
> 
> 
> Absolutely! I was trying to implement " sas_discover_stat_pm()" This
is
> where, I wanted to do the SATA Port Multiplier Init Seuence by sending
> out the soft reset FIS.
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Wednesday, April 02, 2008 4:45 PM
> > To: Sanjay Gandotra
> > Cc: linux-scsi@vger.kernel.org
> > Subject: Re: Help On Adaptec SAS Controller AD-483000
> >
> > On Wed, 2008-04-02 at 16:32 -0700, Sanjay Gandotra wrote:
> > > Hi,
> > >
> > > Ok, the issue I have is the following:
> > >
> > > I have connected a SATA Port Multiplier to AD-483000. And I have
two
> sata
> > drives connected to the Sata port multiplier (one at port 0 and
second
> at port 1)
> > > My Linux Kernel is 2.6.24.3. I am using the drivers in the
kernel..
> aic94xx and
> > libsas
> > >
> > > The drive at port 0 of the sata port multiplier is detected
nicely.
> The problem is
> > that the second drive on the port multiplier is not detected.
> > > After investigations.. I figured out that no one is trying to do
> sata port multiplier
> > initialisation and detection. After reading the sata spec etc., I
> tried to modify libsas
> > so that before detecting any sata device, it would send out FIS
(soft
> reset ) to sata
> > port 15 with SRST bit set to 1 followed by another FIS to sata port
15
> with SRST bit
> > set to 0.
> > >
> > > The first FIS goes out. I can see it on a SATA analyzer. The
second
> FIS never
> > goes out...
> > > Adaptec's driver.. is giving errors for the first FIS.
> >
> > I'm afraid the basic source of the problem is that port multiplier
> > support in libsas is stubbed out.  No-one developing the driver
> actually
> > has a port multiplier (and we assumed that everyone would use
> expanders
> > anyway).
> >
> > The place to begin is in libsas/sas_ata.c:sas_discover_stat_pm()
which
> > basically returns -ENODEV at the moment.
> >
> > James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
