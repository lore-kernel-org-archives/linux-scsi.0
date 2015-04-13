From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: ufs: add ioctl interface for query request
Date: Mon, 13 Apr 2015 14:01:58 +0300
Message-ID: <20150413110158.GO16501@mwanda>
References: <20150409201755.GA9651@mwanda>
 <bad58376cabac273fbe5a8ea22356204.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbbDMLCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 07:02:14 -0400
Content-Disposition: inline
In-Reply-To: <bad58376cabac273fbe5a8ea22356204.squirrel@www.codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: draviv@codeaurora.org, linux-scsi@vger.kernel.org

On Mon, Apr 13, 2015 at 10:55:58AM -0000, Gilad Broner wrote:
> > copy_to/from_user() returns the number of bytes not copied and not an
> > error code.  Printing these error messages in the ioctl means the user
> > can trigger a DoS by filling up /var/log/messages.  They make the code
> > uglier.  We should stop here if the copy fails and goto out_release_mem
> > otherwise we might end up returning success by mistake.
> 
> Thanks for the comment, I will update the code.
> I wanted to clarify about the possibility of a DoS attack:
> - Isn't var/log/messages cyclic or size limited in some way?

Some people limit it some people don't.  To be honest, I'm not really
concerned about this, but I use it as an excuse to remove debug
messages.

> - What determines that dev_err() prints go to /var/log/messages?
>   would it still be the case if dev_dbg() was used instead?

Normally dev_dbg() message are not printed.  But just remove them.  They
make the code uglier.

regards,
dan carpenter

