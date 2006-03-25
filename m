From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] sas transport: ref count update
Date: Sat, 25 Mar 2006 10:39:23 -0600
Message-ID: <1143304763.3049.34.camel@mulgrave.il.steeleye.com>
References: <20060322214119.GA661@us.ibm.com>
	 <20060322214221.GB661@us.ibm.com>  <20060325035648.GB19970@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4759 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750744AbWCYTn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Mar 2006 14:43:59 -0500
In-Reply-To: <20060325035648.GB19970@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, 2006-03-24 at 19:56 -0800, Mike Anderson wrote:
> Can I get your comment(s) on this change.

This looks correct as far as it goes, but it's not complete.
sas_phy_free() and sas_rphy_free() now do too many parent puts with this
change (actually, two too many in each case, which looks like a bug in
the original code).  There also looks to be two spurious puts in the
rphy (for expander and end device) allocation error paths (again, a bug
in the original code).

James


