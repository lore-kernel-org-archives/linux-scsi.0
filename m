From: Mark Haverkamp <markh@linux-foundation.org>
Subject: Re: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Mon, 05 Feb 2007 14:01:51 -0800
Message-ID: <1170712911.2573.25.camel@markh3.pdx.osdl.net>
References: <1170708540.2573.10.camel@markh3.pdx.osdl.net>
	 <1170712218.4517.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35770 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964819AbXBEWBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 17:01:55 -0500
In-Reply-To: <1170712218.4517.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

On Mon, 2007-02-05 at 15:50 -0600, James Bottomley wrote:
> On Mon, 2007-02-05 at 12:49 -0800, Mark Haverkamp wrote:
> > James,
> > 
> > Some months ago, I had problems with a mis-behaving disk that failed
> > domain validation on a fusion card resulting in an infinite loop of
> > domain validation.  At the time Eric proposed a patch to the mptspi
> > driver to reload devices with parameters previously negotiated when a
> > reset occurred.  You indicated that a more generic solution should be
> > done.
> > 
> > This patch updates spi_dv_device_internal() to check if domain
> > validation has already been performed on a device and just sets it
> > previously negotiated parameters.  This solved the "infinite domain
> > validation" loop for me when a reset is performed as a result of command
> > timeout with the mis-behaving device.
> 
> Er,but this code basically disabled domain revalidation after a reset,
> doesn't it? 

Yes it does.  The problem I am seeing is that a device that fails
validation can cause a reset to occur.  If it does, then all devices are
now re-validated.  Including any that have failed validation previously.
Which can cause another reset and another validation, etc. forever.  I'm
not sure how else to break out of this cycle.

>  If we could do it that way, we could simply take the calls
> to spi_dv_device() out of the fusion driver and instead set the
> parameters up in its place without having to modify the transport class.

If I understand your comment, I believe that is what Eric proposed at
one point. But it seems other drivers/adapters could have a similar
problem.

Mark.



-- 
Mark Haverkamp <markh@linux-foundation.org>

