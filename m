From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reports
	wrongdevice size
Date: 24 Mar 2004 17:01:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080165685.1783.142.camel@mulgrave>
References: <200403242153.i2OLrOW19394@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:51866 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262110AbUCXWEp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 17:04:45 -0500
In-Reply-To: <200403242153.i2OLrOW19394@dns1.watkins-home.com>
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Terrence Martin' <tmartin@physics.ucsd.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

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


