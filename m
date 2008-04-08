From: Rakesh <raksac@yahoo.com>
Subject: Re: Help On Adaptec SAS Controller AD-483000
Date: Tue, 8 Apr 2008 14:32:57 -0700 (PDT)
Message-ID: <670091.55923.qm@web30205.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30205.mail.mud.yahoo.com ([209.191.69.52]:23950 "HELO
	web30205.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751632AbYDHVc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2008 17:32:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

IMHO, there are no SAS controller that support PMP's
today. However having said that there are a bunch of
SI & Marvell controllers which work with PMP's

Thanks,
Rakesh

Can anyone please suggest me any SAS raid controller
which supports
hooking up SATA Port multiplier? As I mentioned
earlier, with Adaptec
SAS Controller AD-483000, when I try to send FIS reset
to the SATA Port
Multiplier, I get errors from the Adaptec f/w /
driver. The command I
send out is:

1. Send Nop with SRST bit set to port 15
0x27 0xf 0x0 0x0 0x0 0x0 0x0 0xa0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x4

2. Send Nop with SRST bit clear to port 15
0x27 0xf 0x0 0x0 0x0 0x0 0x0 0xa0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0

At this point, I am expecting the Port Multiplier to
respond with
signature fis.

But I get errors after first command and subsequent
commands don't go
out on the bus.
//sanjay
> -----Original Message-----
> From: linux-scsi-owner@xxxxxxxxxxxxxxx
[mailto:linux-scsi-owner@xxxxxxxxxxxxxxx]
> On Behalf Of Sanjay Gandotra
> Sent: Wednesday, April 02, 2008 5:02 PM
> To: linux-scsi@xxxxxxxxxxxxxxx
> Subject: RE: Help On Adaptec SAS Controller
AD-483000
> 
> 
> Absolutely! I was trying to implement "
sas_discover_stat_pm()" This
is
> where, I wanted to do the SATA Port Multiplier Init
Seuence by sending
> out the soft reset FIS.
> 
> > -----Original Message-----
> > From: James Bottomley
[mailto:James.Bottomley@xxxxxxxxxxxxxxxxxxxxx]
> > Sent: Wednesday, April 02, 2008 4:45 PM
> > To: Sanjay Gandotra
> > Cc: linux-scsi@xxxxxxxxxxxxxxx
> > Subject: Re: Help On Adaptec SAS Controller
AD-483000
> >
> > On Wed, 2008-04-02 at 16:32 -0700, Sanjay Gandotra
wrote:
> > > Hi,
> > >
> > > Ok, the issue I have is the following:
> > >
> > > I have connected a SATA Port Multiplier to
AD-483000. And I have
two
> sata
> > drives connected to the Sata port multiplier (one
at port 0 and
second
> at port 1)
> > > My Linux Kernel is 2.6.24.3. I am using the
drivers in the
kernel..
> aic94xx and
> > libsas
> > >
> > > The drive at port 0 of the sata port multiplier
is detected
nicely.
> The problem is
> > that the second drive on the port multiplier is
not detected.
> > > After investigations.. I figured out that no one
is trying to do
> sata port multiplier
> > initialisation and detection. After reading the
sata spec etc., I
> tried to modify libsas
> > so that before detecting any sata device, it would
send out FIS
(soft
> reset ) to sata
> > port 15 with SRST bit set to 1 followed by another
FIS to sata port
15
> with SRST bit
> > set to 0.
> > >
> > > The first FIS goes out. I can see it on a SATA
analyzer. The
second
> FIS never
> > goes out...
> > > Adaptec's driver.. is giving errors for the
first FIS.
> >
> > I'm afraid the basic source of the problem is that
port multiplier
> > support in libsas is stubbed out.  No-one
developing the driver
> actually
> > has a port multiplier (and we assumed that
everyone would use
> expanders
> > anyway).
> >
> > The place to begin is in
libsas/sas_ata.c:sas_discover_stat_pm()
which
> > basically returns -ENODEV at the moment.
> >
> > James
> --
> To unsubscribe from this list: send the line
"unsubscribe linux-scsi"
in
> the body of a message to majordomo@xxxxxxxxxxxxxxx
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line
"unsubscribe linux-scsi" in
the body of a message to majordomo@xxxxxxxxxxxxxxx
More majordomo info at 
http://vger.kernel.org/majordomo-info.html




      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com
