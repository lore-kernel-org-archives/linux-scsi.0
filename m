From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 12:35:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120123558.A23985@beaverton.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:61849 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S265751AbUATUhs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 15:37:48 -0500
Content-Disposition: inline
In-Reply-To: <400D5A28.1000301@us.ibm.com>; from brking@us.ibm.com on Tue, Jan 20, 2004 at 10:41:12AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 10:41:12AM -0600, Brian King wrote:
> Christoph Hellwig wrote:

> > We should probably always send a STOP UNIT when unconfiguring devices
> > from the midlayer or and upper driver.
> 
> Sounds reasonable.

That would screw up clustered or shared storage, where there are other
hosts attached, and sending a STOP UNIT would prevent them from talking to
the LUNs. And, on addition of the scsi_host (hot add, reboot, or modprobe)
the drives would have to all be spun up again, and we do not handle that
well at all.

-- Patrick Mansfield
