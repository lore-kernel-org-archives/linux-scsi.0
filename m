From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix crash in aic79xx probing in scsi-misc when no
	hardware is present
Date: Wed, 31 Aug 2005 08:29:08 -0500
Message-ID: <1125494948.4807.16.camel@mulgrave>
References: <200508311045.54846.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:58795 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964795AbVHaN3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 09:29:18 -0400
In-Reply-To: <200508311045.54846.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-08-31 at 10:45 +0200, Andi Kleen wrote:
> aic79xx in scsi-misc would oops when no hardware was present.
> Reason was a duplicated call to free the spi transport object -
> it was done both in ahd_linux_exit and in the cleanup part
> of ahd_linux_init.
> 
> Just remove the superfluous call.

Actually, the fix is slightly wrong.  The correct thing to do is remove
ahd_linux_exit() (It really does nothing in the failure case except
release the transport) which is an __exit function.

The one I plan to push is here:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=a80b3424d9fde3c4b6d62adaf6dda78128dc5c27

James


