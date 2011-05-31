From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 12:17:55 +0200
Message-ID: <20110531101755.GA31447@lst.de>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com> <1306523240-15543-40-git-send-email-agrover@redhat.com> <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36614 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1EaKR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 06:17:58 -0400
Content-Disposition: inline
In-Reply-To: <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 31, 2011 at 02:32:47AM -0700, Nicholas A. Bellinger wrote:
> As Christoph mentioned earler, this original patch to enable your
> iscsi-target optimization series breaks all non iscsi-target fabrics.
> But hey, that is easy enough for me to fix now.  ;-)

I don't think it breaks all of them.  Besides iscsi only tcm_fc (btw, why did
this one get commited with the stupd tcm prefix that we killed in all other
places?) and SRP use this function.  FC uses the same scheme as iSCSI
and should be fine with the direct call.  SRP has a three callers leading
towards srpt_handle_new_iu, of which two also come from the main handling
thread, and the third comes from an IB layer callback.  I've not looked
over the IB code yet, but it appears to either be fine to do the direct
call here, or easily doable by offloading the IB callback from a higher
level.

Doing this would have the huge advantage of greatly simplifying the
entry points into the command processing - either call transport_new_cmd
directly, or use the thread for the TRANSPORT_NEW_CMD case.  Mid-term
getting rid of that entry point also sounds fine, if we replace the
current main thread with a work queue where frontends can queue their
own items, and use those for deferring things from IRQ context only
when needed.  This would also mean we can remove the new_cmd_map callback.


