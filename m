From: Doug Ledford <dledford@redhat.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Wed, 2 Oct 2002 17:44:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002214440.GA30503@redhat.com>
References: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com> <1033588299.23661.34.camel@irongate.swansea.linux.org.uk> <20021002233045.A12192@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021002233045.A12192@bitwizard.nl>
List-Id: linux-scsi@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Henderson <hbryan@us.ibm.com>, Scott Merritt <Scsi@PragmaSoft.com>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 11:30:45PM +0200, Rogier Wolff wrote:
> On Wed, Oct 02, 2002 at 08:51:39PM +0100, Alan Cox wrote:
> > On Wed, 2002-10-02 at 19:10, Bryan Henderson wrote:
> > > But when we speak of inhibiting partition table reading, I think that's
> > > another (missing) feature:  I should be able to control whether Linux
> > > considers there to be partitions on my disk or not (and change the fact
> > 
> > Why do you want to. Linux always offers you the entire disk anyway. 
> 
> Andries has argued this before, but I encountered a real-life example
> today.
> 
> Today I was asked to recover data from a device where reading one
> of the "bad" blocks would cause an immediate "lockup" of the device:
> It would report ALL future blocks as bad as well. Only a power-cycle
> could revert it to reporting other blocks as "working". 
> 
> In this case, the partition table luckily didn't reference any of the
> bad blocks. But if it did, it would have made the recoverable 99% of
> the device unaccessable. 

There's also the additional case of certain drives which may be reserved 
by another initiator in a multi-initiator state which will then return an 
I/O error for attempts to read the partition table (this can also happen 
when certain drives, such as EMC type stuff (I'm not actually implying 
EMC, because I can't remember the brand I saw this on), where the INQUIRY 
data doesn't indicate that the device is actually offline, but it really 
is, so attempts to read from it generate errors).  It's not real urgent 
stuff, but there are a few reasons to not read the partition table nor the 
geometry or capacity of the device until you actually want to use it (for 
example catch the first attempt to open any partition on a device and if 
we haven't read the partition table yet then do so and then determine if 
the open succeeds, something like that).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
