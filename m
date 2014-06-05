From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] mptfusion: tweak null pointer checks
Date: Thu, 5 Jun 2014 02:44:57 -0700
Message-ID: <20140605094457.GH727@infradead.org>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
 <1401900747-19894-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaFEJo5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 05:44:57 -0400
Content-Disposition: inline
In-Reply-To: <1401900747-19894-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

> JL: Comments on the above warnings, in order:

Can you move these comments into the actual commit message instead of
the part that gets discarded?
> 
>     No-brainer, the enclosing switch statement dereferences 'reply',
>     so we can't get here unless 'reply' is valid.

ok.

>     "Retry target reset" needs to know the target ID and channel, so
>     enclose that entire block inside a if (pScsiTmReply) block.

Reading the code in mptsas_taskmgmt_complete it's pretty obvious
that it can't do anything useful if mr/pScsiTmReply are NULL, so I
suspect it would be best to just return at the beginning of the
function.

I'd love to understand if it actually could ever be zero, which I doubt.
Maybe the LSI people can shed some light on that?

>     The code before the loop checks for 'port_info->phy_info', but not
>     many other places in the driver bother.  Not sure what to do here.

It's pretty obvious from reading mptsas_sas_io_unit_pg0 that we never
register a port_info with a NULL phy_info in the lists, so all NULL
checks on it could be deleted.

>     'hostdata' is checked and then immediately dereferenced after
>     that block.  How about a default return string of "N/A" to indicate
>     one isn't available? 

shost_priv can't return NULL, so the if (h) should be removed.

>     Not sure what to do here.  'vdevice' is needed to "set up the
>     message frame" target ID and channel, so it should probably return
>     an error in in this case.

vdevice can't ever be NULL here, it's allocated in ->slave_alloc and
thus guaranteed to be around when ->queuecommand is called.

