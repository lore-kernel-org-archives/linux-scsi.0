From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi
	hotplug model
Date: Tue, 31 Jul 2007 11:17:10 -0500
Message-ID: <1185898630.3468.23.camel@localhost.localdomain>
References: <20070731125510.GN21219@parisc-linux.org>
	 <1185892945.3468.9.camel@localhost.localdomain>
	 <20070731145227.GP21219@parisc-linux.org>
	 <20070731145723.GA18819@infradead.org>
	 <1185894351.3468.17.camel@localhost.localdomain>
	 <20070731160040.GQ21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38966 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759431AbXGaQRO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 12:17:14 -0400
In-Reply-To: <20070731160040.GQ21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, 2007-07-31 at 10:00 -0600, Matthew Wilcox wrote:
> On Tue, Jul 31, 2007 at 10:05:50AM -0500, James Bottomley wrote:
> > I agree the NCR_700_release should be the last method called.  However,
> > the NCR_700_detect() API calls scsi_host_alloc/scsi_add_host() ... the
> > API will be horribly assymetric (and thus prone to misuse) with regard
> > to the host lifetime management if the NCR_700_release() method doesn't
> > tidy up the host.
> > 
> > I can go either way, but either the alloc/add has to come out of the
> > detect method or the put has to go into the release method.
> 
> It's already asymmetric -- scsi_remove_host is called by the front
> end driver, and that's the opposite to scsi_add_host, which is done in
> NCR_700_detect.

In many ways that's paired with the external scsi_scan_host() ...
although they're not true pairs in the model.  I don't really see a
reason to separate NCR_700_release() and scsi_host_put() unless there's
something I'm missing?

James

