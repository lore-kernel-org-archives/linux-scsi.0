From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add transport class symlink to device object
Date: Sat, 13 Aug 2005 19:42:23 -0500
Message-ID: <1123980143.5115.27.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com>
	 <20050813213955.GB19235@kroah.com>  <1123976180.5115.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:64188 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751362AbVHNAml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 20:42:41 -0400
In-Reply-To: <1123976180.5115.23.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James.Smart@Emulex.Com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-08-13 at 18:36 -0500, James Bottomley wrote:
> And the reason why yours crashes and James' doesn't is the kobject_name
> ().  Kobject names aren't valid until the object is visible, which is
> long after the class is created in the SCSI case.  The actual panic is
> in removal on a NULL kobject name.
> 
> So, perhaps James' might be the patch you'd prefer to your current one?

OK, should have engaged test apparatus before putting mouth in gear.
Both of these patches fail in the same way.  I'm sure the key is object
visibility.  In the failure case, the object is created, has classes
added and is destroyed without being made visible.

I'll look into it.

James


