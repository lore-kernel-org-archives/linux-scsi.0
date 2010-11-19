From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/11] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Thu, 18 Nov 2010 16:04:26 -0800
Message-ID: <1290125066.31890.177.camel@haakon2.linux-iscsi.org>
References: <1290032322-4899-1-git-send-email-nab@linux-iscsi.org>
	 <20101117222752.GA26760@infradead.org>
	 <1290032970.31890.61.camel@haakon2.linux-iscsi.org>
	 <20101117223735.GA514@infradead.org>  <4CE4FF2E.1010303@panasas.com>
	 <1290121510.31890.143.camel@haakon2.linux-iscsi.org>
	 <4CE5B374.5050802@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46127 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572Ab0KSAJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 19:09:52 -0500
In-Reply-To: <4CE5B374.5050802@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On Thu, 2010-11-18 at 18:15 -0500, Jeff Garzik wrote:
> On 11/18/2010 06:05 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2010-11-18 at 12:25 +0200, Boaz Harrosh wrote:
> >> On 11/18/2010 12:37 AM, Christoph Hellwig wrote:
> >>> On Wed, Nov 17, 2010 at 02:29:30PM -0800, Nicholas A. Bellinger wrote:
> >>>> Hmmm, this is following jgarzik's recommendation for LLDs that we could
> >>>> not immediately identify a internal spin_lock to disable interrupts
> >>>> upon.  (eg: not libiscsi and libata).
> >>>
> >>> In that case wait for the driver author to identify it.  If there's
> >>> no maintainer in reach chance is the driver doesn't care about the push
> >>> down.  No need to rush any of this, do it one driver at a time and get
> >>> it right.
> >>
> >> I totally agree with Christoph. Patches 5, 6, 8, 11 all change behaviour
> >>
> >> I would like to see an "I audit the driver and ..." Please see my comment
> >> to [patch 6]
> >
> > Just to reiterate the point here..  The only LLDs that have been made
> > 'lock-less' in this first round are LLDs that:
> >
> > *) Where already using the legacy optimization of releasing host_lock,
> > doing lld_work, and reaquring before returning from their
> > lld_queuecommand().
> >
> > *) Have been tested by folks explictly during the various initial
> > attempts at lock_less mode, which still appear to be functionally
> > equivilent minus the precatuion of local_irq_[save,release] usage.
> >
> >>
> >> Do it one by one and open-code the local_irq_save/restore inside the
> >> main function. It's not like you can get away from a total audit and
> >> testing.
> >>
> >
> > Hmmm, I am not sure I agree with open coding these atm.  I would much
> > rather get LLD maintainer feedback first for these initial cases so we
> > can figure out which of these patches can be further optimized along the
> > lines of libiscsi and libata.
> 
> I don't think we'll be able to get around looking at each case 
> individually, therefore I do not see the utility of adding 
> IRQ_DISABLE_SCSI_QCMD().
> 

I am definately not trying to imply that this should be merged as
lock_less without the necessary individual review and maintainer
signoffs.

> If you're looking at each case, then you likely have an idea of exactly 
> how the code should be updated.
> 

Sure, the main purpose of this series is to get the ball rolling on LLDs
that we (you can read this as selfish we ;) collectively care about for
high performance modern lock_less usage..   I am more than happy to get
NACKs on a per LLD basis for hardware that I am not currently able to
test with in order to get the maintainers involved to make the call if
proper semi optimized -> fully optimized lock_less operation is in their
near future.

Best,

--nab

