From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Suspected Spam:#] Re: [PATCH] qla2xxx: Fix to allow to reset devices using sg interface (sg_reset)
Date: Sun, 30 Jul 2006 18:18:04 +0100
Message-ID: <20060730171804.GA8082@infradead.org>
References: <44C61AE4.2010600@vlnb.net> <44C8F615.4060902@vlnb.net> <20060727225310.GU2338@jdlab1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20376 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932372AbWG3RSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 13:18:20 -0400
Content-Disposition: inline
In-Reply-To: <20060727225310.GU2338@jdlab1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Thu, Jul 27, 2006 at 03:53:10PM -0700, Andrew Vasquez wrote:
> On Thu, 27 Jul 2006, Vladislav Bolkhovitin wrote:
> 
> > Also I've found that without this patch qla2xxx_eh_device_reset() 
> > refuses to reset the device during normal error recovery carrying out by 
> > SCSI mid-layer as well. I didn't do deeper investigations though, with 
> > this patch the error recovery works as expected.
> 
> The only way I see this happening is if the command completed after
> the abort handler FAILED and before the device reset handler executed.
> Possibly.
> 
> During normal EH routines the driver still hold a reference to the
> command, so the sp should be valid.
> 
> In any case, those codes (referencing SP) are residual left-overs from
> our 'standard' non-upstream driver, and should be clensed.

But it shows a bad problem in the design of those external reset ioctls.
Unlike normal EH commands they never went through ->queuecommand so don't
have private data allocated or other setup done.  This can have pretty
serious consequences.  We probably can't fix it short from redoing the
whole EH entry points, but it at least needs to be documented very carefully.

Anyone volunteering to write up the documentation?

