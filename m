From: Matthew Wilcox <matthew@wil.cx>
Subject: libata / scsi separation
Date: Tue, 9 Dec 2008 15:21:13 -0700
Message-ID: <20081209222113.GU25548@parisc-linux.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1228662298.3501.19.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 07, 2008 at 09:04:58AM -0600, James Bottomley wrote:
> Originally I'd been promised that libata would be out of SCSI within a
> year (that was when it went in).  The slight problem is that having all
> the features it needed, SCSI became a very comfortable host. Getting
> libata out of SCSI was also made difficult by the fact that few people
> cared enough to help.  The only significant external problem is the size
> of the stack and the slight performance penalty for SATA disks going
> over SAT.  Unfortunately for the latter, slight turns out to be pretty
> unmeasurable, so the only hope became people who cared about
> footprint ... and there don't seem to be any of those.

The performance penalty is certainly measurable.  It's about 1 microsecond
per request extra to go from userspace -> scsi -> libata -> driver
than it is to go from userspace -> scsi -> driver.  If you issue 400
commands per second (as you might do with a 15k RPM SCSI drive), that's
400 microseconds.  If you issue 10,000 commands per second (as you might
do with an SSD), that's 10ms of additional CPU time spent in the kernel
per second (or 1%).

So it's insignificant overhead ... unless you have an SSD.  I have asked
Tejun if there's anything he wants help with to move the libata-scsi
separation along, but he's not come up with anything yet.  Right now,
I'm investigating a technique that may significantly increase the number
of requests we can do per second without rewriting the whole thing.

(OK, I haven't measured the overhead of the *SCSI* layer, I've measured
the overhead of the *libata* layer.  I think the point here is that you
can't measure the difference at a macro level unless you're sending a
lot of commands.)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
