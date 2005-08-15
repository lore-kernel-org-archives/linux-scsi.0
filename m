From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] allow building both megaraid and megraid_mbox
Date: Mon, 15 Aug 2005 11:15:35 +0100
Message-ID: <20050815101535.GA590@infradead.org>
References: <1123934582.8173.29.camel@plop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19363 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932616AbVHOKPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 06:15:38 -0400
Content-Disposition: inline
In-Reply-To: <1123934582.8173.29.camel@plop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pascal Terjan <pterjan@mandriva.com>
Cc: linux-scsi@vger.kernel.org, sreenib@lsil.com, sju@lsil.com

On Sat, Aug 13, 2005 at 02:03:01PM +0200, Pascal Terjan wrote:
> Hello,
> here is a small patch that allow building both drivers by removing the
> devices supported by the new driver from the id_table of the old driver
> when you want both.
> It is usefull for distributions wanting to keep supporting legacy
> hardware.
> 
> What's you opinion about that problem and the fix ?

Given that the new megaraid_mbox driver works nicely I suggest to:

 - remove all but the two PCI ids not support by megaraid_mbox from
   the old driver
 - rename the old module to megaraid_legacy so people don't use it by
   accident
 - remove all code dealing with more recent controllers from the old
   driver.  Unfortunately the checks for different types of hardware
   are implicit in the driver and not keyed of the PCI IDs.
   Sreenivas and Seokmann, could you help us with identifying the codepathes
   only used by recent hardware that we can remove from the legacy driver?
