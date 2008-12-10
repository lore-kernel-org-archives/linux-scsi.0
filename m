From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: libata / scsi separation
Date: Tue, 9 Dec 2008 20:37:08 -0700
Message-ID: <20081210033708.GV25548@parisc-linux.org>
References: <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain> <20081209222113.GU25548@parisc-linux.org> <1228862287.3263.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1228862287.3263.52.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 09, 2008 at 04:38:07PM -0600, James Bottomley wrote:
> On Tue, 2008-12-09 at 15:21 -0700, Matthew Wilcox wrote:
> > The performance penalty is certainly measurable.  It's about 1 microsecond
> > per request extra to go from userspace -> scsi -> libata -> driver
> > than it is to go from userspace -> scsi -> driver.  If you issue 400
> > commands per second (as you might do with a 15k RPM SCSI drive), that's
> > 400 microseconds.  If you issue 10,000 commands per second (as you might
> > do with an SSD), that's 10ms of additional CPU time spent in the kernel
> > per second (or 1%).
> 
> Um, not quite.  What you're talking about is increased latency.  It's

Tsk.  I was quite clear I wasn't talking about latency or bandwidth.  I
was talking about the amount of CPU used to keep a device busy.

> not cumulative because we use TCQ (well mostly).  The question is really
> how it impacts the benchmarks, which are mostly throughput based (and
> really, our block layer trades latency for throughput anyway, so it's
> not clear what the impact really is).

If 1% of CPU is being used by the kernel, that's 1% of CPU not available
for the user application (or alternatively an extra centisecond the CPU
could be in a low-power state if you're not CPU-bound).

> > (OK, I haven't measured the overhead of the *SCSI* layer, I've measured
> > the overhead of the *libata* layer.  I think the point here is that you
> > can't measure the difference at a macro level unless you're sending a
> > lot of commands.)
> 
> Perhaps one of the things we should agree on is exactly how we want to
> measure things like this.  Making the layering thinner for less latency
> is usually good ... unless there are other tradeoffs.  I think not
> forcing ata disks to go through SCSI will probably be tradeoff free, but
> we need to make sure it is.

That would certainly be a good idea.  I don't think we have a consensus
about what we should be measuring yet ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
