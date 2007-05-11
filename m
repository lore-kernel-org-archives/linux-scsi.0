From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM
Date: Fri, 11 May 2007 11:18:53 -0500
Message-ID: <1178900333.3692.44.camel@mulgrave.il.steeleye.com>
References: <20070508170335.1b1f844c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50636 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759208AbXEKQS5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 12:18:57 -0400
In-Reply-To: <20070508170335.1b1f844c@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org

On Tue, 2007-05-08 at 17:03 +0100, Alan Cox wrote:
> The CD-ROM layer doesn't bounce requests for old ISA controllers (and
> nor should it). However they get injected into the SCSI layer via
> sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
> along to a device with unchecked_isa_dma set which either panics or
> truncates the buffer to 24bits.
> 
> According to Jens the right long term fix is for the CD layer to route
> the requests differently but in the mean time this has been tested by a
> victim and verified to sort the problem out. For the other 99.9% of users
> it's a no-op and doesn't bounce data.

OK, the alternative fix for this is in the vanilla tree.

Could you make sure it works ... if it does, I think it's a candidate
for 2.6.21 stable as well.

James


