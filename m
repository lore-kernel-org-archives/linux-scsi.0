From: Doug Ledford <dledford@redhat.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Sat, 26 Oct 2002 12:00:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021026160059.GA6058@redhat.com>
References: <200210210514.g9L5ElYp006401@angle.badbox.com> <20021021163424.GE28914@redhat.com> <20021022032435.GA11986@angle.setup.org> <3DB4E275.BC760EDE@ix.netcom.com> <20021022161644.GA15234@angle.setup.org> <20021022170316.GA31085@redhat.com> <20021022221958.GA17112@angle.setup.org> <20021026145309.GA7695@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021026145309.GA7695@angle.setup.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 26, 2002 at 10:53:09AM -0400, Alexy Khrabrov wrote:
> 
> So I reread the drive manual, which says that 
> Barracuda 50 drives support ANSI SCSI, SCSI-2 and SCSI-3
> (Fast-20 and Fast-40), which it says are the same
> as Ultra-1 and Ultra-2 for Fast-20/40, respectively.
> Mysteriously, Ultra2 is referred to as Ultra80 elsewhere,
> so looks like Fast-40 _is_ 80?  If SCSI veterans could
> clarify this, I'd see how 40=80...  Especially, given
> aic7xxx says something about 80 (40 MHz) in parentheses...

You aren't paying attention to the units of measure.  The 40 in
Ultra2/Fast40 is 40MHz (aka, 40 million cycles per second).  The SCSI bus
itself is either narrow (8 bits) or wide (16 bits).  The speed rating you
are referring to is in Mega*BYTES* per second.  So, to get the total
speed, you multiply the frequency of data transfer (the MHz part) times
how many bytes are transferred in each data transfer operation (aka, there
are 8 bits per byte, so a narrow bus transfers exactly one byte of
information in each transfer cycle, while a wide bus transfers 2 bytes of
information in each cycle).  So, a Wide (16 bit, 2 byte) bus operating at
40MHz transfer frequency is actually transferring data at a rate of 80
MegaBytes of data per second.

> In all cases, seems that it's really the drive, Barracuda 50
> family is Ultra2 <=> Ultra80 (right?) but I was able to
> enable Wide Negotiation and set speed to 80, and aic7xxx v6.2.8
> showed them registered at 80.  I'm just curious if I still could
> kinda spin them up to 160 anyways...  :-)

No.  A drive will *only* do what it is capable of doing, there is no
margin there for overclocking (and in fact the negotiation protocol won't
allow it, on most 80MByte/s drives if you set the Adaptec BIOS to
160MByte/s, the card and drive will still end up at 80MByte/s anyway
because the drive firmware and the controller driver have a message
protocol that they follow to negotiate the best possible speed that both
of them support and obviously if the drive only supports 80MByte/s
transfers, then that's the best that both of them support, but in your
case the drive appears to be locking up during the transfer speed
negotiation phase which could be the fault of the linux scsi driver you
are using or the fault of the drive firmware).

> Hence, so far, both SCA<->68 LVD adapters worked as advertised.
> I'm going to get a real 160 SCA drive and test it further.
> In the same vein, if I do end up getting an Ultra 320 card,
> and I will get an Adaptec one, what should I look for in the
> drive to see if it's capable of supporting 320?

The card and the drive *both* have to support 320 speeds, and you have to 
have a driver for the 320 card.  Justin Gibbs has a driver for the adaptec 
320 cards, but it isn't in all the stock linux kernels yet (I think it's 
in 2.4.19 and later, and should be in the 2.5 kernel series pretty soon).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
