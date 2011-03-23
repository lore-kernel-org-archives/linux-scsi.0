From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 10:16:48 -0500
Message-ID: <1300893408.15899.17.camel@mulgrave.site>
References: <469812.82249.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab1CWPQx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 11:16:53 -0400
In-Reply-To: <469812.82249.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2011-03-23 at 07:06 -0700, Luben Tuikov wrote:
> --- On Mon, 3/21/11, Alan Stern <stern@rowland.harvard.edu> wrote:
> > From: Alan Stern <stern@rowland.harvard.edu>
> > Subject: [PATCH] sd: Fix regression in sd_read_cache_type
> > To: "James Bottomley" <James.Bottomley@suse.de>
> > Cc: "Richard Senior" <richard@r-senior.demon.co.uk>, "Luben Tuikov" <ltuikov@yahoo.com>, "SCSI development list" <linux-scsi@vger.kernel.org>
> > Date: Monday, March 21, 2011, 2:29 PM
> > This patch (as1454) fixes a
> > regression in the sd driver.  Commit
> > 24d720b726c1a85f1962831ac30ad4d2ef8276b1 ([SCSI] Retrieve
> > the Caching
> > mode page) recently introduced the strategy of asking for
> > all pages
> > (page code 0x3F) instead of asking for the caching page
> > (0x08) on
> > devices that might not support it.  This ought to be
> > safe, because sd
> > already uses page code 0x3F when checking for write
> > protection.
> > 
> > Unfortunately, the commit did not copy the checks used by
> > sd_read_write_protect_flag().  Some devices don't
> > support page code
> > 0x3F, and others require a fixed transfer length of 192
> > bytes.  This
> > patch adds those checks into sd_read_cache_type().
> > 
> > Without this fix, some USB mass-storage devices crash when
> > they
> > receive a MODE SENSE command with page code 0x3F asking for
> > only 4
> > bytes of data.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Reported-and-tested-by: Richard Senior <richard@r-senior.demon.co.uk>
> > CC: Luben Tuikov <ltuikov@yahoo.com>
> > CC: <stable@kernel.org>
> 
> Acked-by: Luben Tuikov <ltuikov@yahoo.com>

I put the original patch in on the understanding from both of you that
the chances of finding a USB device which crashed with the change was
very small.

Given that several have been found and we're on the eve of the merge
window closure, I'll just revert the original, and you two can work on
getting a bullet proof version for the next merge window.

James


