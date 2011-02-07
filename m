From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Why using configfs as the only interface is wrong for a
 storage target
Date: Mon, 07 Feb 2011 08:41:49 -0600
Message-ID: <1297089709.3012.19.camel@mulgrave.site>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	 <20110207115347.GA7503@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab1BGOly (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2011 09:41:54 -0500
In-Reply-To: <20110207115347.GA7503@noexit>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <jlbec@evilplan.org>
Cc: Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2011-02-07 at 03:53 -0800, Joel Becker wrote:
> On Mon, Feb 07, 2011 at 12:41:18PM +0100, Bart Van Assche wrote:
> > On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > > Please consider the following patch series for mainline target code.
> > > It consists of predominately configfs bugfixes uncovered with recent SLUB
> > > poison testing, and proper removal of legacy procfs target_core_mib.c code.
> > > Note that the complete set of fabric independent statistics (SCSI MIBs) and
> > > fabric dependent statistics will be included as native configfs group context
> > > 'per value' attribute series during the .39 time frame.
> > 
> > I'm still not convinced that using configfs in a storage target as the
> > only interface between kernel space and user space is a good idea.
> > While configfs may satisfy all the needs of an iSCSI target, the use
> > of configfs in combination with hot-pluggable HCAs is really awkward.
> > Whenever a HCA is plugged in, the user has to issue mkdir commands to
> > make these interfaces appear in configfs. And whenever a HCA is
> > removed, stale information will remain present in configfs until the
> > user issues an rmdir command. As we all know, it is not possible for a
> > storage target to make these directories appear / disappear
> > automatically in configfs because of basic configfs design choices.
> 
> 	Any configuration would have to be handled.  We have plenty of
> stuff that is handled by userspace hooks out of udev, etc.  That's a
> normal hotplug process.
> 	Essentially, you're not challenging Nick's use of configfs here,
> you're challenging his environment of setting up the target stack from
> userspace.

I think the overall philosophical point here, and it's a good one
because I've heard it from several sources, is that it's not possible to
separate configuration from status completely.  The classic example is
where the kernel has to validate and adjust config information, but the
storage specific one is where events alter the topology.  In either
case, the configfs tree gets out of sync with reality if the kernel does
the adjustment..  Just saying we have to use a user space tool to fix it
up is a bit of a cop out because the kernel has already adjusted its own
configuration, so getting userspace to work out what the kernel's done
and adjust configfs is a bit sub optimal.

James


