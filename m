From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Wed, 10 Dec 2003 15:09:49 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031210150949.A2855@infradead.org>
References: <OFE5F05878.12C1E995-ONC1256DF8.004D7413-C1256DF8.004E538F@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:5893 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263584AbTLJPJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 10:09:56 -0500
Content-Disposition: inline
In-Reply-To: <OFE5F05878.12C1E995-ONC1256DF8.004D7413-C1256DF8.004E538F@de.ibm.com>; from Heiko.Carstens@de.ibm.com on Wed, Dec 10, 2003 at 03:14:19PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 10, 2003 at 03:14:19PM +0100, Heiko Carstens wrote:
> >Sounds there's a scsi_device_put missing somewherein your driver..
> 
> Why should I be supposed to issue a scsi_device_put or scsi_device_get in 
> my
> device driver?

scsi_remove_device just marks the device deleted, the memory is only freed
after the final scsi_device_put.  That might be the one your driver issues
after it's completly done with the device or for example the one when the last
sysfs file referring to the device is closed.  Lifetime of structscsi_device
is not under control of the driver.

