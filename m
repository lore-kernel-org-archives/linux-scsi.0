From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sg MiB writes scheduling while atomic
Date: Tue, 16 Sep 2003 13:58:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030916135843.A15918@infradead.org>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org> <1063217791.3669.43.camel@patehci2> <1063219776.3669.72.camel@patehci2> <1063222216.3669.87.camel@patehci2> <3F66AF1B.5010402@torque.net> <20030916114238.GA21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:50446 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261251AbTIPM6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 08:58:47 -0400
Content-Disposition: inline
In-Reply-To: <20030916114238.GA21596@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Tue, Sep 16, 2003 at 12:42:38PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Douglas Gilbert <dougg@torque.net>, Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

On Tue, Sep 16, 2003 at 12:42:38PM +0100, Matthew Wilcox wrote:
> scsi_device_put() calls down_write() so it needs to be called in process
> context.  Probably the best way to do this is by calling schedule_work().
> An ickier solution would be to hijack an error handling thread ;-)

The down_write was recently introduced and also hurts my scsi_device
refcounting patches badly.  I'll submit a patch make scsi_device_{get,put}
nonblocking again ASAP.

