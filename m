From: Doug Ledford <dledford@redhat.com>
Subject: Re: Whenever two drives plugged in, second drive fails?
Date: Thu, 20 Jun 2002 14:36:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620143612.C9181@redhat.com>
References: <5.1.0.14.0.20020620131337.023d8d40@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5.1.0.14.0.20020620131337.023d8d40@205.233.215.4>; from jhill@hrpost.com on Thu, Jun 20, 2002 at 02:15:36PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Hill <jhill@hrpost.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 20, 2002 at 02:15:36PM -0400, Jeff Hill wrote:
> When I try to add a recently repaired drive to my SCSI chain, the Adaptec 
> 2940U2W controller  times out trying to find it, even reports occasionally 
> a "cable or termination error, please fix."
> 
> Sounds simple, but I don't think it's termination on the drives, since 
> they're an identical pair of Seagate Cheetah LVD drives.

[ snipped description ]

Hmmm...from what you've given I almost wonder if there isn't a termination 
power issue with too many devices providing term power.  I would check the 
drives to make sure they don't have term power enabled since it shouldn't 
be needed.  The other thing that it could be is actually an underpowering 
of term power with the two drives pulling more power from the reset line 
than the term power is capable of providing, resulting in the bus seeing 
infinite resets when both drives are plugged in.

(Note: it's been a long time since I read the electrical specs of the LVD
SPI bus.  Don't flame me too hard on innaccuracies in this bit.  It may
not be technically correct in all places, but the basic information
provided is correct. The reset line on the SCSI cable works by having
something on the bus provide +2v (I think, it may be +1v on LVD, been a
while since I read the electrical specs on LVD) to the terminator which
then connects that power source to the reset line on the bus, pulling the
voltage on the reset line up high.  When the controller or any device on
the bus wants to cause a bus reset, it temporarily connects the reset line
to ground, pulling the voltage low and triggering all the devices to
reset.  However, reading the voltage on the line requires consuming a
small amount of the power provided by the terminator.  So, the more
devices you have on the bus, the more trickle power the terminator has to
supply in order to keep the voltage on the reset line up.  The trickle
power is limited though, or else devices wouldn't be able to pull it low
at will.  So, if the terminator is providing too small of an amount of
power on the line, then two drives can force it low by just reading the
line, resulting in what you are seeing.  On the other hand, it could be
that the terminator is in fact providing all the power it is suppossed to,
but each of the drives you have are pulling way too much power when just
sitting there and as it may work out, each device will work on a bus by
itself but when they are put on a bus together the combined power pull
becomes too much for the terminator and the bus goes into a permanent
reset state.  This would be my actual guess for what's wrong on your bus.)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
