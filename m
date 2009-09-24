From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: pmcraid build problem on ppc64
Date: Thu, 24 Sep 2009 12:10:33 -0700
Message-ID: <1253819433.5183.121.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42257 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbZIXTKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 15:10:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

I'm getting this in testing:

drivers/scsi/pmcraid.c: In function 'pmcraid_request_sense':
drivers/scsi/pmcraid.c:2254: warning: large integer implicitly truncated
to unsigned type
drivers/scsi/pmcraid.c: In function 'pmcraid_build_ioadl':
drivers/scsi/pmcraid.c:3020: warning: large integer implicitly truncated
to unsigned type
drivers/scsi/pmcraid.c: In function 'pmcraid_build_passthrough_ioadls':
drivers/scsi/pmcraid.c:3390: warning: large integer implicitly truncated
to unsigned type
drivers/scsi/pmcraid.c: In function 'pmcraid_querycfg':
drivers/scsi/pmcraid.c:5317: warning: large integer implicitly truncated
to unsigned type

It's code like this:

	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);

But ->flags is only u8, so that cpu_to_le32() will cause the flag to be
too big to fit on a BE architecture.

James


