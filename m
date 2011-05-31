From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 04:18:14 -0700
Message-ID: <1306840694.8193.206.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-40-git-send-email-agrover@redhat.com>
	 <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
	 <20110531101755.GA31447@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41281 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1EaL0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 07:26:38 -0400
In-Reply-To: <20110531101755.GA31447@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-05-31 at 12:17 +0200, Christoph Hellwig wrote:
> On Tue, May 31, 2011 at 02:32:47AM -0700, Nicholas A. Bellinger wrote:
> > As Christoph mentioned earler, this original patch to enable your
> > iscsi-target optimization series breaks all non iscsi-target fabrics.
> > But hey, that is easy enough for me to fix now.  ;-)
> 
> I don't think it breaks all of them.  Besides iscsi only tcm_fc (btw, why did
> this one get commited with the stupd tcm prefix that we killed in all other
> places?) and SRP use this function.  FC uses the same scheme as iSCSI
> and should be fine with the direct call.  SRP has a three callers leading
> towards srpt_handle_new_iu, of which two also come from the main handling
> thread, and the third comes from an IB layer callback.  I've not looked
> over the IB code yet, but it appears to either be fine to do the direct
> call here, or easily doable by offloading the IB callback from a higher
> level.
> 

Hmmm yes, tcm_fc is still using transport_generic_handle_cdb() and
should be OK with the direct call here..  I will get this converted
later this afternoon.

Also need to take a deeper look wrt to SRP and see how this conversion
would be possible..

> Doing this would have the huge advantage of greatly simplifying the
> entry points into the command processing - either call transport_new_cmd
> directly, or use the thread for the TRANSPORT_NEW_CMD case.  Mid-term
> getting rid of that entry point also sounds fine, if we replace the
> current main thread with a work queue where frontends can queue their
> own items, and use those for deferring things from IRQ context only
> when needed.  This would also mean we can remove the new_cmd_map callback.
> 
> 

I very much agree with these points, and moving to workqueues for TCM
v4.1 (mainline v3.1) for these reasons makes alot of sense to me.  I
need to get a better idea of how this will actually look, but am eager
to move ahead..

Thanks,

--nab


