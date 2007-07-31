From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi hotplug model
Date: Tue, 31 Jul 2007 10:00:40 -0600
Message-ID: <20070731160040.GQ21219@parisc-linux.org>
References: <20070731125510.GN21219@parisc-linux.org> <1185892945.3468.9.camel@localhost.localdomain> <20070731145227.GP21219@parisc-linux.org> <20070731145723.GA18819@infradead.org> <1185894351.3468.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58090 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXGaQAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 12:00:42 -0400
Content-Disposition: inline
In-Reply-To: <1185894351.3468.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Jul 31, 2007 at 10:05:50AM -0500, James Bottomley wrote:
> I agree the NCR_700_release should be the last method called.  However,
> the NCR_700_detect() API calls scsi_host_alloc/scsi_add_host() ... the
> API will be horribly assymetric (and thus prone to misuse) with regard
> to the host lifetime management if the NCR_700_release() method doesn't
> tidy up the host.
> 
> I can go either way, but either the alloc/add has to come out of the
> detect method or the put has to go into the release method.

It's already asymmetric -- scsi_remove_host is called by the front
end driver, and that's the opposite to scsi_add_host, which is done in
NCR_700_detect.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
