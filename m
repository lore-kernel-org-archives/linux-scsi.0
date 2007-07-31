From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi
	hotplug model
Date: Tue, 31 Jul 2007 10:05:50 -0500
Message-ID: <1185894351.3468.17.camel@localhost.localdomain>
References: <20070731125510.GN21219@parisc-linux.org>
	 <1185892945.3468.9.camel@localhost.localdomain>
	 <20070731145227.GP21219@parisc-linux.org>
	 <20070731145723.GA18819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56289 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762327AbXGaPFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 11:05:53 -0400
In-Reply-To: <20070731145723.GA18819@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Tue, 2007-07-31 at 15:57 +0100, Christoph Hellwig wrote:
> On Tue, Jul 31, 2007 at 08:52:28AM -0600, Matthew Wilcox wrote:
> > On Tue, Jul 31, 2007 at 09:42:25AM -0500, James Bottomley wrote:
> > > Rather than changing this in every 53c700 based driver, shouldn't it
> > > just be added to NCR_700_release()?
> > 
> > Then I'd have to change the few drivers that weren't leaking scsi_hosts
> > ;-)  But I can, if that's what you prefer.
> 
> I don't think it's a good idea.  scsi_hhost_put should be the very
> last thing in the release method and all the drivers do some kind
> of cleanup after detaching from the generic ncr53c00 driver.

I agree the NCR_700_release should be the last method called.  However,
the NCR_700_detect() API calls scsi_host_alloc/scsi_add_host() ... the
API will be horribly assymetric (and thus prone to misuse) with regard
to the host lifetime management if the NCR_700_release() method doesn't
tidy up the host.

I can go either way, but either the alloc/add has to come out of the
detect method or the put has to go into the release method.

James


