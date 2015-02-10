From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] hpsa: correct compiler warnings introduced by
 hpsa-add-local-workqueue patch
Date: Tue, 10 Feb 2015 12:52:54 -0500
Message-ID: <20150210175254.GL3220@htj.duckdns.org>
References: <20150206234415.23960.78547.stgit@brunhilda>
 <1423587390.2167.21.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:60588 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbBJRw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2015 12:52:58 -0500
Received: by mail-qa0-f45.google.com with SMTP id j7so3813774qaq.4
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2015 09:52:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1423587390.2167.21.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com, keescook@chromium.org, linux-scsi@vger.kernel.org

On Tue, Feb 10, 2015 at 08:56:30AM -0800, James Bottomley wrote:
> > +	wq = alloc_ordered_workqueue("%s_%d_hpsa", 0, name, h->ctlr);
> 
> It's not an objection to your patch, but what idiot did this?  There's
> an extra variable there between the format and the arguments.  That
> makes the pattern counterintuitive (i.e. an interface easy to get wrong)
> because everywhere else, the arguments immediately follow the format
> argument.  Please never, ever do this again.
> 
> By the way, the above is rhetorical ... the culprit is in the cc.

LOL, that idiot would be me.  Well, it has a history.  Those functions
originally only took static names and only way later got augmented to
take printf format and, at that point, only few needed formatting.  I
can argue both sides of changing the parameter order.  It's one of the
easiest mistakes to spot after all.

Thanks.

-- 
tejun
