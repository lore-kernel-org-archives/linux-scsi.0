From: Christoph Hellwig <hch@lst.de>
Subject: Re: Fix for aic7xxx problems in BK latest
Date: Mon, 24 Nov 2003 08:18:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124071854.GA32490@lst.de>
References: <1069653204.2066.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:21201 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263600AbTKXHTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 02:19:15 -0500
Content-Disposition: inline
In-Reply-To: <1069653204.2066.25.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Pete Clements <clem@clem.clem-digital.net>, Fabio Coatti <cova@ferrara.linux.it>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>

On Sun, Nov 23, 2003 at 11:53:20PM -0600, James Bottomley wrote:
> It turns out the scsi_device refcounting and list lockdown altered the
> conditions under which scsi_report_bus_reset() works, since it calls
> shost_for_each_device, which now takes the host lock, that lock cannot
> be held while calling the report functions.  However, the assumption by
> aic is that it can.
> 
> I fixed the problem by using the no lock version of the iterator.

Well, that makes the problem go away but adds races again, the right
fix is to rename you versions with an __ and make the normal versions
take the host_lock around that - we don't actually need the refcounting
here because we just set the two flags so holding the lock over it is
fine.

