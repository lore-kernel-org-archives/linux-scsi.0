From: Ingo Oeser <ingo.oeser@informatik.tu-chemnitz.de>
Subject: Re: [RFC][PATCH] Direct I/O for the SCSI tapes
Date: Mon, 29 Jul 2002 00:59:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729005940.Q793@nightmaster.csn.tu-chemnitz.de>
References: <3D437590.8D69B132@torque.net> <Pine.LNX.4.44.0207281324590.942-100000@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0207281324590.942-100000@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Sun, Jul 28, 2002 at 02:03:16PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

[Please keep me CC'ed on replies, since I'm not subscribed to
linux-scsi. Thanks for CC'ing me so far!]

On Sun, Jul 28, 2002 at 02:03:16PM +0300, Kai Makisara wrote:
> There have been some indications on lkml that Ben LaHaise's aio and/or
> kvecs would be included in 2.6. As far as I know, kvecs are quite near
> what I want and st should use kvecs if they are included. We don't want
> more functions mapping user buffers than necessary.
 
Mapping user buffers is one step only. I want mapping of user
buffers to bus adresses to do scatter-gather. We need it in so
many places now, so I like the idea of simplifying it the way we
agree on. The kvecs do only user page pinning. 

We need struct scatterlist since we need to get the pages anyway
(remember: we get a pointer to the struct page, where we easyly
get to the physical address, which is already the bus adress on
many arches AFAIR).

With kvecs we get only half the work done.

I also would like to see the mapping function entered very early
in the call chain (my own use is one stack frame after
the file operations!). That's why I used the stack for the
temporary buffer (which should be very small anyway, so we don't
pin too much pages).

> 1. We make functions that all the users want and agree on and try to get
> these into the kernel. These would be either permanent solutions or
> removed if kvecs (or something else) is introduced into the kernel. Linus
> has not always been thrilled with temporary solutions.
 
Even then we would still need sth. which does the physical
mapping and must allocate another array for it. I wanted to unify
this on the argument, that scatter-gather goes together with DMA
an bus adresses in the COMMON case (which we optimize for,
remember ;-)).

I've thought I overlooked sth. important, until Doug fowarded me
your work and testing.

> It would probably be best to do possible locking in a separate function.
> There it would probably be advantageous to stop early if an unlockable
> page is found (or optionally wait until the pages are unlocked). The
> locking and unlocking functions can be left undefined until someone tells
> what he/she needs.
> 
> I would like to see the following minimum properties in the mapping
> function:
> - it maps all pages or none
> - it pins the pages into memory
> - it returns the number of pages or error
> - it returns the page pointers and page lengths (lengths will be useful if
>   large pages will be implemented) and offset in first page
> - it does whatever cache flushing is needed
  - locks partial pages used (first and/or last might be) to
    avoid a partial page write for the unused remainder.
  
I agree completly.

> Is the scatter/gather list the correct way to return the results? It is
> convenient in many cases. 

s/many/the common/

so I would add it to the minimum properties. Otherwise we
allocate just another array again for the scatter-gather list.

> However, if kvecs or something else is used in
> future, mapping from those to scatter/gather list is needed. It might be
> easier to code that now. The mapping function might be made to return the
> results in something that looks exactly like kvecs ;-?

I would prefer 2 seperate functions for the kvec and the
scatterlist cases. My basic idea was to prepare the sg-list from
user space buffers and thus enable very simple user space DMA. 
I don't want it to get lost ;-)


Regards

Ingo Oeser
-- 
Science is what we can tell a computer. Art is everything else. --- D.E.Knuth
