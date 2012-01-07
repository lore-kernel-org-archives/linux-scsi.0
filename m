From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: Write protected devices, unexpected dm-multipath queueing
Date: Sat, 07 Jan 2012 10:39:32 +0100
Message-ID: <1325929172.19595.19.camel@lapoo.opensvc.com>
References: <1325878251.19595.13.camel@lapoo.opensvc.com>
	 <20120106223212.GB2393@redhat.com> <20120106225554.GA15329@redhat.com>
	 <20120106232055.GB15329@redhat.com>
Reply-To: christophe.varoqui@opensvc.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62784 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2AGJjm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jan 2012 04:39:42 -0500
Received: by eekc4 with SMTP id c4so1489822eek.19
        for <linux-scsi@vger.kernel.org>; Sat, 07 Jan 2012 01:39:40 -0800 (PST)
In-Reply-To: <20120106232055.GB15329@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "cyril.galibern" <cyril.galibern@opensvc.com>, linux-scsi@vger.kernel.org

On ven., 2012-01-06 at 18:20 -0500, Mike Snitzer wrote:
> On Fri, Jan 06 2012 at  5:55pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Fri, Jan 06 2012 at  5:32pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > On Fri, Jan 06 2012 at  2:30pm -0500,
> > > Christophe Varoqui <christophe.varoqui@gmail.com> wrote:
> > > 
> > > > Hannes, list,
> > > > 
> > > > reading your kernel path there
> > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=63583cca745f440167bf27877182dc13e19d4bcf
> > > > I wonder if this is expected that a write io on a write protected device
> > > > is returned to the queue ? I would have guessed it qualified as
> > > > TARGET_ERROR, hence not retryable (and not causing path invalidation).
> > > > 
> > > > In the following log the sense code is clearly seen as 
> > > > Sense Key : Data Protect [current]
> > > > Add. Sense: Write protected
> > > > 
> > > > The log is grabbed from a el6 kernel rev. 131 which include the
> > > > mentioned patch (since rev. 110 iirc).
> > > > 
> > > > Care to confirm something is fishy there ?
> 
> Aha, now I remember, I applied all the changes for differentiated SCSI
> IO errors for -131.el6 (aka RHEL6.1) _except_ I overlooked one disjoint
> yet crucial commit that went upstream much earlier, see this one-liner:
> http://git.kernel.org/linus/ad63082626f99651d261ccd8698ce4e997362f7e
> 
> So the code for differentiated IO errors was dormant in RHEL6.1, it was
> noticed before 6.1 GA'd but was deemed too risky to enable so late in
> the 6.1 release cycle.  It has since been enabled in RHEL6.2.
> 
> And yes it was a pretty embarassing oversight at the time... now you've
> allowed me to relive that embarassment ;)
> 
> Long story short, apply that patch or upgrade to the RHEL6.2 kernel.

Thank you for the explanation, and sorry for the ambarassment. By bad,
for not having tried the upgrade before nosing around ;)

Regards,
cvaroqui

