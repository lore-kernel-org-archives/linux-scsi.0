From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reports wrongdevice size
Date: Wed, 24 Mar 2004 16:53:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403242153.i2OLrOW19394@dns1.watkins-home.com>
References: <1080163517.1783.106.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:49128 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262080AbUCXVx0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 16:53:26 -0500
In-Reply-To: <1080163517.1783.106.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, 'Terrence Martin' <tmartin@physics.ucsd.edu>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

I think you have reached a 4T limit somewhere.
If you take your expected size, 4287645M, subtract 4T you get a number very
close to your reported size!
 4287645M
-4194304M (2^20)
---------
=  93341M

If you can, make the device size 100,000M smaller.

The size is wrapping past zero, I think.
The limit could also be 2T or 1T.
You must try just under 4T, 2T and 1T until you find a size that works.

Once you determine the limit, split the array into equal parts smaller than
the limit.  Then create a RAID0 with the smaller parts.

I hope I made this clear!

This is just a guess!!!!!  But I think I am correct.

Guy


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Wednesday, March 24, 2004 4:25 PM
To: Terrence Martin
Cc: SCSI Mailing List
Subject: Re: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reports
wrongdevice size

On Wed, 2004-03-24 at 15:53, Terrence Martin wrote:
> I have a stock 2.6.4 kernel with CONFIG_LBD=y turned on in my kernel 
> (confirmed via /proc/config.gz) but when the module is loaded I still get
> 
> SCSI device sdb: 191162368 512-byte hdwr sectors (97875 MB)
> SCSI device sdb: drive cache: write through
>  sdb:
> 
> I expect to get 4,287,645MB as that is what my Infortrend RAID array is 
> set up for a partition size. Is there something, in addition to the LBD 
> support in 2.6 that I need to do with the SCSI driver itself, in the 
> case the qla2300 drivers that come with 2.6.4, to allow larger than 2TB 
> block devices?

This looks to be a failure of the device.  It's obviously reporting a
size smaller than it actually is for some reason.

The LDB code has been successfully tested with SCSI on >2TB arrays.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


