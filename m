From: Anton Blanchard <anton@samba.org>
Subject: Re: [2.6.14-rc1] sym scsi boot hang
Date: Fri, 16 Sep 2005 20:28:30 +1000
Message-ID: <20050916102830.GC14962@krispykreme>
References: <20050913124804.GA5008@in.ibm.com> <20050913131739.GD26162@krispykreme> <20050913142939.GE26162@krispykreme> <1126629345.4809.36.camel@mulgrave> <20050914080629.GB19051@krispykreme> <1126717062.4584.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:27059 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S1161157AbVIPKb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 06:31:57 -0400
Content-Disposition: inline
In-Reply-To: <1126717062.4584.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu


Hi,

> OK, my fault.  Your fix is almost correct .. I was going to do this
> eventually, honest, because there's no need to unprep and reprep a
> command that comes in through scsi_queue_insert().
> 
> However, I decided to leave it in to exercise the scsi_unprep_request()
> path just to make sure it was working.  What's happening, I think, is
> that we also use this path for retries.  Since we kill and reget the
> command each time, the retries decrement is never seen, so we're
> retrying forever.
> 
> This should be the correct reversal.

Thanks James, that did the trick.

Anton
