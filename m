From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] Restart list search after unlock in
 scsi_remove_target
Date: Thu, 05 Nov 2015 09:05:47 -0800
Message-ID: <1446743147.2211.19.camel@HansenPartnership.com>
References: <5633E9F2.5080209@sandisk.com> <5633EA98.8050604@sandisk.com>
	 <563A883C.9060501@sandisk.com>
	 <1446677072.2216.30.camel@HansenPartnership.com>
	 <CAPcyv4iO0iX2_DCSKz8aXSqeu22bO=kq9CtRtH-MSrKm4ouxfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59464 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030726AbbKERFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 12:05:49 -0500
In-Reply-To: <CAPcyv4iO0iX2_DCSKz8aXSqeu22bO=kq9CtRtH-MSrKm4ouxfg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2015-11-05 at 08:55 -0800, Dan Williams wrote:
> On Wed, Nov 4, 2015 at 2:44 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> [..]
> > The fundamental problem with this is how have the conditions that caused
> > us to move away from list restart:
> >
> > commit bc3f02a795d3b4faa99d37390174be2a75d091bd
> > Author: Dan Williams <djbw@fb.com>
> > Date:   Tue Aug 28 22:12:10 2012 -0700
> >
> >     [SCSI] scsi_remove_target: fix softlockup regression on hot remove
> >
> > Which was triggered by this bug report
> >
> > http://thread.gmane.org/gmane.linux.kernel/1348679
> >
> > been mitigated?
> >
> 
> I think it has because the problem that led to that report was the
> fact that scsi_target_destroy() did not advance the target state, but
> we changed that in f2495e228fce.
> 
> http://marc.info/?l=linux-scsi&m=144527527308725&w=2

Great, thanks, we'll put Christoph's version in then, because it can be
cc'd to stable without problems.  Bart, you can redo your state updates
on top of this because that's inessential to the current problem.

James


