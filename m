From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Why using configfs as the only interface is wrong for a
 storage target
Date: Mon, 7 Feb 2011 10:45:02 -0800
Message-ID: <20110207184501.GA13518@noexit>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
 <20110207115347.GA7503@noexit>
 <1297089709.3012.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35577 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1BGSpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 13:45:20 -0500
Content-Disposition: inline
In-Reply-To: <1297089709.3012.19.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, Feb 07, 2011 at 08:41:49AM -0600, James Bottomley wrote:
> On Mon, 2011-02-07 at 03:53 -0800, Joel Becker wrote:
> > On Mon, Feb 07, 2011 at 12:41:18PM +0100, Bart Van Assche wrote:
> > > I'm still not convinced that using configfs in a storage target as the
> > > only interface between kernel space and user space is a good idea.

	Two points here.  First, a design principle of configfs is that
it cannot and should not be one-stop shop for all possible userspace
interaction.  If there are things that fit better in sysfs, there is no
reason the target code can't export them via sysfs.  So any contention
that we can't add other pieces of the puzzle in an attempt to shoehorn
everything into configfs is sub-optimal. 

> I think the overall philosophical point here, and it's a good one
> because I've heard it from several sources, is that it's not possible to
> separate configuration from status completely.  The classic example is
> where the kernel has to validate and adjust config information, but the

	Nor should you try.  You can certainly update the attributes of
objects created in configfs via the kernel, and you can certainly use
configfs with sysfs, ioctl, procfs, or netlink in the same subsystem.

Joel


-- 

Life's Little Instruction Book #226

	"When someone hugs you, let them be the first to let go."

			http://www.jlbec.org/
			jlbec@evilplan.org
