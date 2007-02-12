From: Mark Haverkamp <markh@linux-foundation.org>
Subject: RE: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Mon, 12 Feb 2007 08:14:45 -0800
Message-ID: <1171296886.23143.6.camel@markh3.pdx.osdl.net>
References: <20070207235140.GA20920@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60350 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964939AbXBLQOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Feb 2007 11:14:50 -0500
In-Reply-To: <20070207235140.GA20920@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Wed, 2007-02-07 at 16:51 -0700, Eric Moore wrote:
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> > Sent: Monday, February 05, 2007 2:50 PM
> > To: Mark Haverkamp
> > Cc: linux-scsi; Moore, Eric
> > Subject: Re: [PATCH] scsi spi transport: SCSI domain 
> > validation after reset
> > 
> > On Mon, 2007-02-05 at 12:49 -0800, Mark Haverkamp wrote:
> > > James,
> > > 
> > > Some months ago, I had problems with a mis-behaving disk that failed
> > > domain validation on a fusion card resulting in an infinite loop of
> > > domain validation.  At the time Eric proposed a patch to the mptspi
> > > driver to reload devices with parameters previously 
> > negotiated when a
> > > reset occurred.  You indicated that a more generic solution 
> > should be
> > > done.
> > > 
> > > This patch updates spi_dv_device_internal() to check if domain
> > > validation has already been performed on a device and just sets it
> > > previously negotiated parameters.  This solved the "infinite domain
> > > validation" loop for me when a reset is performed as a 
> > result of command
> > > timeout with the mis-behaving device.
> > 
> > Er,but this code basically disabled domain revalidation after a reset,
> > doesn't it?  If we could do it that way, we could simply take 
> > the calls
> > to spi_dv_device() out of the fusion driver and instead set the
> > parameters up in its place without having to modify the 
> > transport class.
> > 
> 
> Here is a patch that does exactly that.
> 
> After host reset, the device are programmed to default asyn narrow nego.
> We need to reprogram the parameter back to previous values.  If the host
> reset is called as a result of spi_dv_device() commands timing out, its
> possible to get into an infinite loop of dv to host reset.  This will
> prevent that case, as we merely program old values.  If host reset is
> called outside context of domain validation, then we can  call
> spi_dv_device. Please apply.
> 
> This applies over scsi-misc tree.
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

[ ... ]

This patch fixed my looping DV problem.

Mark.

-- 
Mark Haverkamp <markh@linux-foundation.org>

