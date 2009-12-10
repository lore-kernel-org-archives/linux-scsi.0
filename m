From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] Always pass result and sense on request completion
Date: Thu, 10 Dec 2009 10:44:17 -0600
Message-ID: <1260463457.2457.80.camel@mulgrave.site>
References: <20091119122454.71A7D3A174@ochil.suse.de>
	 <4B20C417.4020201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49781 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761057AbZLJQoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 11:44:16 -0500
In-Reply-To: <4B20C417.4020201@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Thu, 2009-12-10 at 10:49 +0100, Hannes Reinecke wrote:
> Hi James,
> 
> would you mind commenting on this patch?
> We really need this if we ever want to be able to do proper error code
> handling from multipath.

OK, not keen on the way you're setting req->errors.

Our big problem with FS requests is deferred or corrected errors
(basically we never want the FS to think we had a problem with them).  I
think it's currently OK because block tends to believe the returned
error code rather than req->errors ... I'd just hate it if that changed
and suddenly lots of stuff broke.

I think you're just looking for the sense data, so could you look at
that and not set req->errors?

James


