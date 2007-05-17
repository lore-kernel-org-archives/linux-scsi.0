From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cciss: Fix pci_driver.shutdown while device is still
 active
Date: Thu, 17 May 2007 15:15:25 -0700
Message-ID: <20070517151525.00763641.akpm@linux-foundation.org>
References: <20070514175301.GA19871@zante.sekrit.org>
	<1179437592.12356.30.camel@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbXEQWT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 18:19:26 -0400
In-Reply-To: <1179437592.12356.30.camel@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: Gerald Britton <gbritton@alum.mit.edu>, jens.axboe@oracle.com, torvalds@linux-foundation.org, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 17 May 2007 16:33:12 -0500
"MIke Miller (OS Dev)" <mike.miller@hp.com> wrote:

> On Mon, 2007-05-14 at 17:53 +0000, Gerald Britton wrote:
> > Fix an Oops in the cciss driver caused by system shutdown while a filesystem
> > on a cciss device is still active.  The cciss_remove_one function only
> > properly removes the device if the device has been cleanly released by its
> > users, which is not the case when the pci_driver.shutdown method is called.
> > 
> > This patch adds a new cciss_shutdown function to better match the pattern
> > used by various SCSI drivers: deactivate device interrupts and flush caches.
> > It also alters the cciss_remove_one function to match and readds the
> > __devexit annotation that was removed when cciss_remove_one was serving as
> > the pci_driver.shutdown method.
> 
> Sorry I've taken so long to reply. I've been testing this patch with up
> to 512 logical volumes. Looks good. I may make a tweak or 2 after it's
> merged, I have other changes that touch the same code.
> 
> ACKed-by: Mike Miller <mike.miller@hp.com>
> 

Thanks.  I marked this as needed-in-2.6.21.x also.
