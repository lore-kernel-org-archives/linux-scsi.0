From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sun, 8 Feb 2009 13:50:49 -0700
Message-ID: <20090208205049.GG31509@parisc-linux.org>
References: <20090123041558.GC24652@parisc-linux.org> <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org> <498DA052.6090605@redhat.com> <1234019372.4658.9.camel@localhost.localdomain> <20090207225025.GB31509@parisc-linux.org> <498F0C9D.3070601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <498F0C9D.3070601@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 08, 2009 at 11:47:25AM -0500, Ric Wheeler wrote:
> Matthew Wilcox wrote:
> >I thought we had agreed on a plan which satisfied the SSD and insane
> >array vendors.  That is that we would do no tracking of allocation units
> >in the filesystem, but instead extend each trim out to cover the maximum
> >possible size.  I've confirmed with Intel's SSD people that this would
> >cause them no harm at all (trimming already trimmed sectors won't even
> >cause a slowdown).  Whether the filesystem people have taken note of
> >this, I have no idea.
>
> That should be helpful for the array people, but for some of them with 
> really large delete chuck sizes, they will still miss a lot since their 
> size is larger than the average file size :-)  I guess that we could do 
> something to resync - Ted mentioned some ideas for ext4.

I'm not sure I communicated the plan effectively.

Let's consider deleting a 4k file.

The DISCARD that the filesystem sends down does not just cover the 4k
of data.  It covers all adjacent free space to that 4k of data, so it
might end up sending a DISCARD of several megabytes or even gigabytes,
assuming there's that much contiguous free space.

Now, filesystems which fragment their free space will not do well on
thin provisioned devices, but then they won't do well on any devices --
keeping your free space compacted is an essential part of any filesystem's
job, even on SSDs.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
