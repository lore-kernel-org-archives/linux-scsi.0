From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Fri, 20 Apr 2012 17:58:26 -0400
Message-ID: <20120420215825.GA10406@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
 <20120405144721.GA18437@redhat.com>
 <20120420144538.GB8155@redhat.com>
 <20120420173405.GA8846@redhat.com>
 <20120420214120.159e2690@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab2DTV6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 17:58:39 -0400
Content-Disposition: inline
In-Reply-To: <20120420214120.159e2690@pyramind.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org

On Fri, Apr 20 2012 at  4:41pm -0400,
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 20 Apr 2012 13:34:05 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Allow a proprietary non-GPL multipath driver, like EMC PowerPath, to
> > detach a scsi_dh using scsi_dh_detach. 
> 
> That I doubt somehow. The GPL covers *all* derivative works.
> EXPORT_SYMBOL doesn't magically make code non-derivative. If you need to
> modify the kernel to make your driver work *and* you want to claim it is
> not derivative then I hope there are good lawyers involved 8-)

Um... now I see that cc'ing LKML was a mistake:

GPL zealots reading into this _way_ more than is warranted... awesome.

> The kernel is GPL, all derived works of a GPL codebase are required to be
> GPL. There is no magic rule about modules. I've stated that repeatedly
> for anything containing a line of code I own. GregKH has made it very
> clear for his code, and so it goes on.

This isn't about adding Linux functionality to a proprietary driver.

It is about the fact that:

1)
Linux's scsi_dh* adds additional SCSI sense processing that conflicts
with processing that a long established competing proprietary driver
also does (and did long before scsi_dh* was introduced).

2)
If Linux is masking SCSI sense that Powerpath needs to see in order to
function then they need a way to shut off that conflicting functionality
in Linux.  What they have enjoyed until now is that Linux has treated
them with kid gloves -- by not always attaching scsi_dh to each SCSI
device during SCSI device scan.

Well it is now time to put Linux (and Linux multipathing) first!  But
doing so while exposing an interface that allows Linux to not have to
make compromises about how good it can be.

> > End result is Linux and PowerPath can coexist without compromising
> > Linux's default handling of multipath LUNs.
> 
> So your specific purpose seems to me to be to enable a third party piece
> of non-free code to hook into a piece of GPL code that it needs (which to
> me implies it is derivative if it does). There is an offence of
> "conspiracy to commit copyright infringement" so merely grinning and
> saying its for a third party doesn't let your company off the hook either.
> 
> You should probably forward it to your legal teams before taking any
> other action. Deleting it won't make it go away. It's up to them to
> decide if they think they can argue properly that the work is not
> derivative. I shall be most intrigued to see anyone make that argument,
> but hey I'm not a lawyer.
> 
> I'm dying to see anyone make the moral argument for it too.

I think you're blinded by some innate violent pain reaction to seeing
s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/

As I said in the header, Linux's ability to properly support scanning
LUNs with multiple paths has been fragile for _years_ purely because we
never had the balls to always attach the scsi_dh which enables Linux to
work well.  We didn't because of fear that we'd break PowerPath.

As a result, Linux has suffered (in the form of reduced functionality).
Now your arguing that the because scsi_dh_detach() will become
EXPORT_SYMBOL it somehow makes PowerPath a derived work if they were to
use it?!? -- even though they clearly cannot use scsi_dh* in their
non-GPL driver because all the other scsi_dh* interfaces (like
scsi_dh_attach!) are _GPL?

The two other people (scsi_dh maintainers) that Acked-by this change
work for companies other than EMC.  James is the SCSI maintainer and
understands what is going on here.  Like me, they are domain experts.

What are you?  You're not a lawyer, you're also clearly uninformed.  So
why even weigh in on something if you cannot understand what the hell is
being proposed?

You're being a troll... sad really.
