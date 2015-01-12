From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 9/9] scsi_error: do not display kernel pointer in
 message logs
Date: Mon, 12 Jan 2015 09:57:29 -0500
Message-ID: <1421074649.3891.173.camel@localhost.localdomain>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
	 <1420699430-9492-10-git-send-email-hare@suse.de>
	 <1421068346.3891.163.camel@localhost.localdomain>
	 <54B3CC53.6010909@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbALO5h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2015 09:57:37 -0500
In-Reply-To: <54B3CC53.6010909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, 2015-01-12 at 14:29 +0100, Hannes Reinecke wrote:
> On 01/12/2015 02:12 PM, Ewan Milne wrote:
> > On Thu, 2015-01-08 at 07:43 +0100, Hannes Reinecke wrote:
> >> It is not good practice to display the kernel pointer
> >> in any message logs, and it doesn't display any additional
> >> information. And as we know have block-layer assigned tags
> >> we can use them to differentiate the messages.
> >> So remove any pointer references from the displayed messages.
> >>
> > 
> > I'd actually be sad to see this go -- I have found it useful
> > in the past when debugging crash dumps from customer sites
> > to be able to look in the kernel messages and see that a
> > particular scsi_cmnd had been aborted just before the crash
> > (and then later completed).
> > 
> But that's precisely why we've prefixed the scmd messages with the
> tag number; with that you'll be able to extract the same information.
> 
> And now that hch separated out the block layer tagging from SCSI-2
> TCQ we should have the tag number available for any command, not
> just those from drivers which use TCQ.
> 
> Let me know if that isn't the case; this patch indeed only makes
> sense if the tag number is always available.

Ah, yes, I think you may be right -- I ran into this when debugging some
double completion panics, so my concern is whether the tag field
remains valid after it completes the first time.  I'll check.

-Ewan



