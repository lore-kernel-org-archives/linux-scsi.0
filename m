From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Mon, 05 Feb 2007 15:50:18 -0600
Message-ID: <1170712218.4517.16.camel@mulgrave.il.steeleye.com>
References: <1170708540.2573.10.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57180 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933499AbXBEVuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 16:50:25 -0500
In-Reply-To: <1170708540.2573.10.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

On Mon, 2007-02-05 at 12:49 -0800, Mark Haverkamp wrote:
> James,
> 
> Some months ago, I had problems with a mis-behaving disk that failed
> domain validation on a fusion card resulting in an infinite loop of
> domain validation.  At the time Eric proposed a patch to the mptspi
> driver to reload devices with parameters previously negotiated when a
> reset occurred.  You indicated that a more generic solution should be
> done.
> 
> This patch updates spi_dv_device_internal() to check if domain
> validation has already been performed on a device and just sets it
> previously negotiated parameters.  This solved the "infinite domain
> validation" loop for me when a reset is performed as a result of command
> timeout with the mis-behaving device.

Er,but this code basically disabled domain revalidation after a reset,
doesn't it?  If we could do it that way, we could simply take the calls
to spi_dv_device() out of the fusion driver and instead set the
parameters up in its place without having to modify the transport class.

James


