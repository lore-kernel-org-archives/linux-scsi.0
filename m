From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 14:53:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210272053.g9RKrT612587@localhost.localdomain>
References: <aebr@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA28651
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 12:53:34 -0800
In-Reply-To: Message from Andries Brouwer <aebr@win.tue.nl>
   of "Sun, 27 Oct 2002 20:22:28 +0100." <20021027192228.GA28395@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

aebr@win.tue.nl said:
> I see you trying to get this scsicam code do something that it should
> not. No 64-bit handling required or even desirable. Any use of
> sector_div here is wrong. 

Could you explain why?  Once the disc is too big for the HDIO_GETGEO 
interface, we're returning rubbish anyway.  Whether we overflow or truncate 
seems irrelevant.  The ide code overflows, it doesn't truncate to the maximum, 
so we're at least following existing conventions.

However, should we ever implement the big_geometry interface, then we would 
still be able to use the routine as Christoph has coded it, so the fix looks 
like the correct future proofing to me.

If you really want the truncation, it should probably be done in the sd_ioctl 
code.

James


