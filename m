From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [RFC][PATCH] Direct I/O for the SCSI tapes
Date: Mon, 29 Jul 2002 21:45:02 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207292045040.770-100000@kai.makisara.local>
References: <20020729005940.Q793@nightmaster.csn.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020729005940.Q793@nightmaster.csn.tu-chemnitz.de>
List-Id: linux-scsi@vger.kernel.org
To: Ingo Oeser <ingo.oeser@informatik.tu-chemnitz.de>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Mon, 29 Jul 2002, Ingo Oeser wrote:

> [Please keep me CC'ed on replies, since I'm not subscribed to
> linux-scsi. Thanks for CC'ing me so far!]
...
> Mapping user buffers is one step only. I want mapping of user
> buffers to bus adresses to do scatter-gather. We need it in so
> many places now, so I like the idea of simplifying it the way we
> agree on. The kvecs do only user page pinning.
>
> We need struct scatterlist since we need to get the pages anyway
> (remember: we get a pointer to the struct page, where we easyly
> get to the physical address, which is already the bus adress on
> many arches AFAIR).
>
> With kvecs we get only half the work done.
>
I agree. I have just been exploring the other possibilities if
sgl_map_user_pages() is not accepted into the kernel. map_user_kvec() (at
least in aio-20020619.diff) returns all the information (page pointers,
offset, lengths) that sgl_map_user_pages() puts into the s/g list. Mapping
to a separate s/g list is needed anyway if the user wants to combine
adjacent pages into single s/g entries.

This remapping can, of course, be also made from s/g list to s/g list. If
the user does not need compaction, then nothing has to be done if the
mapping function returns a s/g list. My only valid argument in favour of
kvecs is maintenance of the mm code within the mapping function. If the
kernel contains a maintained function mapping directly to s/g lists,
I will be happy to use it.

> I also would like to see the mapping function entered very early
> in the call chain (my own use is one stack frame after
> the file operations!). That's why I used the stack for the
> temporary buffer (which should be very small anyway, so we don't
> pin too much pages).
>
In st the number of pages can be quite large (256 or even larger) and this
is why I changed the allocation to kmalloc. In a general function this may
also be safer.

...
> > I would like to see the following minimum properties in the mapping
> > function:
> > - it maps all pages or none
> > - it pins the pages into memory
> > - it returns the number of pages or error
> > - it returns the page pointers and page lengths (lengths will be useful if
> >   large pages will be implemented) and offset in first page
> > - it does whatever cache flushing is needed
>   - locks partial pages used (first and/or last might be) to
>     avoid a partial page write for the unused remainder.
>
Is this locking necessary in all cases where the mapping function would be
used? (I am asking because it is not a very light operation in a SMP
system. Also I can see two alternative strategies: some callers would like
to wait until locking succeeds, others (like st) would like to tear down
the mapping if locking fails.)

	Kai


