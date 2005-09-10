From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Sat, 10 Sep 2005 12:50:50 -0500
Message-ID: <1126374650.4813.56.camel@mulgrave>
References: <1126212613.7479.20.camel@markh1.pdx.osdl.net>
	 <1126370295.4813.49.camel@mulgrave>  <4323197D.7070401@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52403 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932087AbVIJRuz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 13:50:55 -0400
In-Reply-To: <4323197D.7070401@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Haverkamp <markh@osdl.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Ben Collins <bcollins@debian.org>

On Sat, 2005-09-10 at 19:35 +0200, Stefan Richter wrote:
> James Bottomley wrote:
> > scsi_add_device() returns an sdev on
> > success with the refcount bumped up for you.  If you don't do a put,
> > you'll be stuck with a device you can't get rid of.
> > 
> > However, all other users of scsi_add_device() make the same mistake ...
> 
> Sbp2 was fixed recently, thanks to your advice. (Although the fix did 
> not make it into Linus' tree yet.)

Yes, I forgot about that, we will eventually have one correct user ;-)

> > I'll apply this patch and fix the API to return zero or error and not
> > bump the sdev refcount.
> 
> If you will do this, the now correct scsi_device_put() will become not 
> only incorrect but even dangerous, won't it?

I've cc'd you on the patch (and it fixes sbp2 as it currently stands in
the Linus tree, but it would conflict with the fix you have pending).
It basically makes scsi_add_device return an int rather than a device
pointer, so the compiler will now flag if something actually tries to
use the return as a pointer.

James


