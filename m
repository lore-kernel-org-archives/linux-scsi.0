From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: zalon/ncr53c720 crashes K460  (parisc port) on bootup.
Date: 27 Sep 2003 13:58:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064689088.2002.188.camel@mulgrave>
References: <1064634188.641.27.camel@laptop.bradetich.net>
	<1064677551.2002.20.camel@mulgrave>
	<20030927183756.GT24824@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:42500 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261639AbTI0S6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 14:58:11 -0400
In-Reply-To: <20030927183756.GT24824@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Ryan Bradetich <rbradetich@uswest.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, PARISC list <parisc-linux@lists.parisc-linux.org>

On Sat, 2003-09-27 at 13:37, Matthew Wilcox wrote:
> On Sat, Sep 27, 2003 at 10:45:50AM -0500, James Bottomley wrote:
> > This should fix the panic, but it simply detaches correctly.
> 
> We both missed it.  This is why it's panicing:
> 
>         host = ncr_attach(&zalon7xx_template, unit, &device);
>         if (!host)
>                 goto fail;
>  fail:
>         ncr53c8xx_release(host);
>         return error;
> 
> ie we're calling ncr53c8xx_release(NULL) so both your & my patch fail
> to fix the problem.  This looks best to me:

No, I fixed that...that was changed to goto out; in my patch, and out
was just before the return (i.e. no longer do the release).

James


