From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Thu, 4 Jan 2007 08:27:48 -0700
Message-ID: <20070104152748.GE24620@parisc-linux.org>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net> <20070104112156.GV11203@kernel.dk> <1167923401.2819.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47060 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbXADP1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 10:27:50 -0500
Content-Disposition: inline
In-Reply-To: <1167923401.2819.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Thu, Jan 04, 2007 at 09:10:01AM -0600, James Bottomley wrote:
> On Thu, 2007-01-04 at 12:21 +0100, Jens Axboe wrote:
> > I guess it's fully up to you how you want to solve it. The scheme seems
> > a little elaborate, but these error conditions are unlikely to ever been
> > seen in the wild, so no objections from me.
> 
> Actually, there's already a DID_ code that does what you want.  Instead
> of DID_ERROR, which will retry immediately, there's DID_REQUEUE which
> will halt the device queue and wait for a returning command to retry.

Any returning command, or a returning command from this device?  We may
be out of memory from a different device, and this may be the only
command being sent to the scsi_debug driver.  Wouldn't we end up
halting the device queue indefinitely then?
