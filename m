From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 1/1] scsi: Disable short inquiry log by default
Date: Mon, 02 Apr 2007 16:42:16 -0500
Message-ID: <1175550136.3680.84.camel@mulgrave.il.steeleye.com>
References: <200704022120.l32LKOZU018499@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34031 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965959AbXDBVmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 17:42:20 -0400
In-Reply-To: <200704022120.l32LKOZU018499@d03av02.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-04-02 at 16:20 -0500, brking@linux.vnet.ibm.com wrote:
> If a scsi device reports less than 36 bytes of standard inquiry
> data, scsi core logs a KERN_INFO printk indicating this. It was
> observed that this results in lots of clutter in the log on
> systems with devices that respond to a SCSI Inquiry with PQ=3 or
> PQ=1 with less than 36 bytes of inquiry data, such as ibmvscsi.
> Disable this log by default.

It shouldn't be doing this ... the standards are pretty clear, say SPC-3
section 6.4.2

"The standard INQUIRY data shall contain at least 36 bytes"

Horrible things happen when this rule is violated (as it is by some
badly constructed devices), so I'd really like to leave the print in so
we know what we're debugging.

Can't you fix ibmvscsi to be standards compliant?

James


