From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] correct module refcounting
Date: 31 Oct 2003 09:00:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067612438.1782.11.camel@mulgrave>
References: <1067377564.1788.39.camel@mulgrave>
	<20031031121841.A16828@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:11525 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263340AbTJaPBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 10:01:15 -0500
In-Reply-To: <20031031121841.A16828@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

On Fri, 2003-10-31 at 06:18, Christoph Hellwig wrote:
> That would mean we can't rmmod a LLDD without first removing all device
> through sysfs, or did I get it completely wrong?

Yes, I was thinking the wrong way around.  I think we need to use the
scsi_get_device() scsi_put_device() to hold a reference to struct
scsi_device in more places than just ULD open/close.  However, obviously
we only need a reference to the module when it shouldn't be removed.


Perhaps all that's really necessary is something like splitting
scsi_device_get() into an __ version that does everything but the module
get.  Then we can use the __scsi_device_get() in the critical sections.

James







