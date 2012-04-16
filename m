From: Tejun Heo <tj@kernel.org>
Subject: Re: Problems with sr_get_events
Date: Mon, 16 Apr 2012 15:55:12 -0700
Message-ID: <20120416225512.GH12421@google.com>
References: <Pine.LNX.4.44L0.1204080858300.11397-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41374 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2DPWzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2012 18:55:17 -0400
Received: by pbcun15 with SMTP id un15so6897774pbc.19
        for <linux-scsi@vger.kernel.org>; Mon, 16 Apr 2012 15:55:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204080858300.11397-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Hello, Alan.  Sorry about the delay.

On Sun, Apr 08, 2012 at 09:24:32AM -0400, Alan Stern wrote:
> There are several closely related issues involving sr_get_events().
> 
> The first may just be confusion on my part.  You've got a 
> cd->ignore_get_event flag, whose name seems to mean that the result 
> from sr_get_events() should be ignored.  But the result isn't ignored 
> entirely; only the DISK_EVENT_MEDIA_CHANGE bit is cleared.
>
> Furthermore, if you really do intend to ignore the result from 
> sr_get_events() then why call it in the first place?  Or does the flag 
> actually mean that you want to ignore the media-change bit from 
> get_events while still using the other bits?

The only thing which caused actual problem was media changed
detection.  This being a workaround for badly broken hardware, I think
it would be better to keep the behavior minmially deviated from the
normal path.  Let's say it's abbreviation of
->ignore_media_changed_from_get_event.

> Finally, the GET_EVENT_STATUS_NOTIFICATION command is not present in 
> all versions of SCSI, and not all drives support it.  sr_get_events() 
> should check for an ILLEGAL_REQUEST sense key and stop sending the 
> command if it is found.  Maybe a new flag will be needed for this.

Hmmm... Maybe but we've been sending GET_EVENT without such provision
for very long time now.  I feel reluctant to change something which
seems to work in this area even if that something is technically
wrong.  It's not like cheap USB devices tend to be technically correct
anyway.

Thanks.

-- 
tejun
