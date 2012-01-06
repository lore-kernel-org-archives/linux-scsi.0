From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Write protected devices, unexpected dm-multipath queueing
Date: Fri, 6 Jan 2012 18:20:56 -0500
Message-ID: <20120106232055.GB15329@redhat.com>
References: <1325878251.19595.13.camel@lapoo.opensvc.com>
 <20120106223212.GB2393@redhat.com>
 <20120106225554.GA15329@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758857Ab2AFXVE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2012 18:21:04 -0500
Content-Disposition: inline
In-Reply-To: <20120106225554.GA15329@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
Cc: "cyril.galibern" <cyril.galibern@opensvc.com>, linux-scsi@vger.kernel.org

On Fri, Jan 06 2012 at  5:55pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jan 06 2012 at  5:32pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Fri, Jan 06 2012 at  2:30pm -0500,
> > Christophe Varoqui <christophe.varoqui@gmail.com> wrote:
> > 
> > > Hannes, list,
> > > 
> > > reading your kernel path there
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=63583cca745f440167bf27877182dc13e19d4bcf
> > > I wonder if this is expected that a write io on a write protected device
> > > is returned to the queue ? I would have guessed it qualified as
> > > TARGET_ERROR, hence not retryable (and not causing path invalidation).
> > > 
> > > In the following log the sense code is clearly seen as 
> > > Sense Key : Data Protect [current]
> > > Add. Sense: Write protected
> > > 
> > > The log is grabbed from a el6 kernel rev. 131 which include the
> > > mentioned patch (since rev. 110 iirc).
> > > 
> > > Care to confirm something is fishy there ?

Aha, now I remember, I applied all the changes for differentiated SCSI
IO errors for -131.el6 (aka RHEL6.1) _except_ I overlooked one disjoint
yet crucial commit that went upstream much earlier, see this one-liner:
http://git.kernel.org/linus/ad63082626f99651d261ccd8698ce4e997362f7e

So the code for differentiated IO errors was dormant in RHEL6.1, it was
noticed before 6.1 GA'd but was deemed too risky to enable so late in
the 6.1 release cycle.  It has since been enabled in RHEL6.2.

And yes it was a pretty embarassing oversight at the time... now you've
allowed me to relive that embarassment ;)

Long story short, apply that patch or upgrade to the RHEL6.2 kernel.

HTH,
Mike
