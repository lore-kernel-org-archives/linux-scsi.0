From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 10:52:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929175230.GC5368@us.ibm.com>
References: <415A67B8.2080003@suse.de> <20040929130332.A11785@infradead.org> <415AAB0F.2080802@suse.de> <20040929171251.GA5368@us.ibm.com> <1096478376.2123.32.camel@mulgrave> <20040929182204.A15308@infradead.org> <20040929173642.GB5368@us.ibm.com> <20040929183858.A15586@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:45192 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S268755AbUI2Rw7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:52:59 -0400
Content-Disposition: inline
In-Reply-To: <20040929183858.A15586@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>

Christoph Hellwig [hch@infradead.org] wrote:
> Well, we're certainly not going to change the scsi_remove_host signature,
> but we could add a separate one.

No we would not want to change the signature of scsi_remove_host. That
is why I tried to come up with the more complicated patch previously,
but as you state below it would be better if the function was more
foolproof

> 
> But I don't like that change at all as we would still have that problem
> with all driver that don't have a way to magically find out.  We should
> really try to make scsi_remove_host foolprof.
> 

Well I believe the issue is not that we sent the command. It is that the
command will not be processed and we start up the error handler. We
could know that we are in the context of scsi_remove_host (possibly with
a state change or other method) and do not start of the error handler. We
would just try to send then and then cancel them with the call to
scsi_host_cancel in scsi_remove_host post the call to scsi_forget_host.

-andmike
--
Michael Anderson
andmike@us.ibm.com

