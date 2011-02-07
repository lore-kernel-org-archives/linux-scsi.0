From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Why using configfs as the only interface is wrong for a
 storage target
Date: Mon, 7 Feb 2011 03:53:48 -0800
Message-ID: <20110207115347.GA7503@noexit>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56543 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1BGLx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 06:53:56 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, Feb 07, 2011 at 12:41:18PM +0100, Bart Van Assche wrote:
> On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Please consider the following patch series for mainline target code.
> > It consists of predominately configfs bugfixes uncovered with recent SLUB
> > poison testing, and proper removal of legacy procfs target_core_mib.c code.
> > Note that the complete set of fabric independent statistics (SCSI MIBs) and
> > fabric dependent statistics will be included as native configfs group context
> > 'per value' attribute series during the .39 time frame.
> 
> I'm still not convinced that using configfs in a storage target as the
> only interface between kernel space and user space is a good idea.
> While configfs may satisfy all the needs of an iSCSI target, the use
> of configfs in combination with hot-pluggable HCAs is really awkward.
> Whenever a HCA is plugged in, the user has to issue mkdir commands to
> make these interfaces appear in configfs. And whenever a HCA is
> removed, stale information will remain present in configfs until the
> user issues an rmdir command. As we all know, it is not possible for a
> storage target to make these directories appear / disappear
> automatically in configfs because of basic configfs design choices.

	Any configuration would have to be handled.  We have plenty of
stuff that is handled by userspace hooks out of udev, etc.  That's a
normal hotplug process.
	Essentially, you're not challenging Nick's use of configfs here,
you're challenging his environment of setting up the target stack from
userspace.

Joel

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

			http://www.jlbec.org/
			jlbec@evilplan.org
