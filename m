From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Wed, 10 Dec 2003 14:02:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031210140223.A1832@infradead.org>
References: <200312101012.17027.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:33028 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263537AbTLJOCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 09:02:25 -0500
Content-Disposition: inline
In-Reply-To: <200312101012.17027.heiko.carstens@de.ibm.com>; from heiko.carstens@de.ibm.com on Wed, Dec 10, 2003 at 10:12:17AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 10, 2003 at 10:12:17AM +0100, Heiko Carstens wrote:
> Hello all,
> 
> it looks to me as if the SCSI stack has a memory leak. If I have the following
> endless loop in our ZFCP LLD we end up within a very short time in an out
> of memory situation (tested on an S390 virtual machine with 128MB):
> 
> while(1) {
>         scsi_add_device(...)
>         scsi_remove_device(...);
> }
> 
> It takes only about 40 iterations to reach the out of memory situation.
> The device that gets added and removed does respond to Inquiry commands.
> Since I'm not sure what are the pending fixes for the SCSI stack I'm wondering
> if this is a known bug.

Sounds there's a scsi_device_put missing somewherein your driver..

