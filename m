From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Mon, 24 Jan 2005 09:31:13 -0600
Message-ID: <1106580673.5513.7.camel@mulgrave>
References: <OF78A719F0.8702D449-ONC1256F93.004FD89C-C1256F93.00516DAD@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31934 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261232AbVAXPbc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 10:31:32 -0500
In-Reply-To: <OF78A719F0.8702D449-ONC1256F93.004FD89C-C1256F93.00516DAD@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, willy@www.linux.org.uk

On Mon, 2005-01-24 at 15:48 +0100, Heiko Carstens wrote:
> > I thought that having release methods that just called kfree() were
> > also verboten?
> 
> We do a kmalloc(sizeof(struce device),...) somewhere and this 
> is how we get rid of it again.
> How are we supposed to free this object otherwise? The release
> function gets called when there is no more reference to this
> object and that's the earliest point we may free it.

Right, but we've said before this is the wrong way to do it.

Originally this generic device was part of your adapter structure.  Now
you're trying to separate it and causing these problems.  What it's
apparently telling us is that you have some problem with the object
lifetime rules in your code.

Why should this generic_services device have different lifetime rules
from the object in which it used to reside?

James


