From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq isnot atomic
Date: Thu, 19 May 2011 09:35:19 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD41@saturn3.aculab.com>
References: <1305780360.2576.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1305780360.2576.20.camel@mulgrave.site>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hitoshi Mitake <h.mitake@gmail.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, "Prakash,Sathya" <Sathya.Prakash@lsi.com>, Roland Dreier <roland@kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, linux scsi dev <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "Moore, Eric" <Eric.Moore@lsi.com>, linux pci <linux-pci@vger.kernel.org>, linux powerpc dev <linuxppc-dev@lists.ozlabs.org>, Milton Miller <miltonm@bga.com>, linux kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, paulus@samba.org, Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>
List-Id: linux-scsi@vger.kernel.org

 
> The specific mpt2sas problem is that if we write a 64 bit register non
> atomically, we can't allow any interleaving writes for any other
region
> on the chip, otherwise the HW will take the write as complete in the
64
> bit register and latch the wrong value.  The only way to achieve that
> given the semantics of writeq is a global static spinlock.

That sounds like very specific and slightly dodgy hardware.
You don't say what the scope of 'region on the chip' is, but
it looks like you need to disable ALL writes to the memory
area between the first and second writes of the 64bit value
and not just those coming from writeq().
I don't see how this can possibly be done by normal mutexing
around the writeq() sequence, surely you need to lock the bus
between the two transfers.
Even dma writes would be a problem.

The only way I can think to stop other cpus doing writes
is to use IPIs for force them into a busy wait loop.

All rather reminds me of a PCI slave that got things
horribly wrong when a read was done while a write was
still 'posted', or a 2nd master did a cycle did a read
while a read rerun sequence was still in progress.
(required a mutex and dummy cycles).
At least than one wqs confined to one driver.

	David
