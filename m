From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Mon, 3 Jan 2005 22:43:22 +0000
Message-ID: <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk>
References: <1104788704.5506.67.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:17100 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262033AbVACWnZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 17:43:25 -0500
Content-Disposition: inline
In-Reply-To: <1104788704.5506.67.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 03, 2005 at 03:45:04PM -0600, James Bottomley wrote:
> This warning:
> 
> drivers/scsi/gdth.c: In function `gdth_fill_raw_cmd':
> drivers/scsi/gdth.c:2948: warning: cast to pointer from integer of
> different size
> drivers/scsi/gdth.c:2950: warning: cast to pointer from integer of
> different size
> drivers/scsi/gdth.c: In function `gdth_sync_event':
> drivers/scsi/gdth.c:3644: warning: cast from pointer to integer of
> different size
> drivers/scsi/gdth.c:3646: warning: cast from pointer to integer of
> different size
> 
> can be fixed with the following patch.

*UGH*

Why do you play with shoving dma_addr_t into a pair of pointers and
then decoding it when you have ->SCp.dma_handle?
