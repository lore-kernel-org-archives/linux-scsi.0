From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reportswrongdevice size
Date: Wed, 24 Mar 2004 17:07:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403242207.i2OM7wW19491@dns1.watkins-home.com>
References: <1080165685.1783.142.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:52942 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262153AbUCXWH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 17:07:59 -0500
In-Reply-To: <1080165685.1783.142.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Terrence Martin' <tmartin@physics.ucsd.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Beyond my knowledge...  Wish I was you!  :)

But, if the device has a bug like "bit 33 lopped off".
If he splits the array into 2 luns/devices then it may be fine.
Then create the RAID0 with them.

Guy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Wednesday, March 24, 2004 5:01 PM
To: Guy
Cc: 'Terrence Martin'; 'SCSI Mailing List'
Subject: RE: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver,
reportswrongdevice size

On Wed, 2004-03-24 at 16:53, Guy wrote:
> This is just a guess!!!!!  But I think I am correct.

The standards are very explicit about what READ CAPACITY(10) should
return for a >2TB device.  sd detects this and retries with a READ
CAPACITY(16).

There is no message in the log indicating this happened, so I think the
device reported an incorrect size to READ CAPACITY(10).  It may have
reported its size with bit 33 lopped off, but that's still a device
problem.

James



