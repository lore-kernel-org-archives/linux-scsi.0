From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 17:23:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027172307.A15930@lst.de>
References: <hch@lst.de> <200210271621.g9RGLik11263@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210271621.g9RGLik11263@localhost.localdomain>; from James.Bottomley@steeleye.com on Sun, Oct 27, 2002 at 10:21:44AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Oct 27, 2002 at 10:21:44AM -0600, James Bottomley wrote:
> hch@lst.de said:
> > sector_div has the same slightly strange calling convention do_div
> > has: it's return value is the modulo of the two operators, the
> > division result is in the first parameter.  Also optimize one of the
> > expensive 64bit division away (okay, okay - it's not exactly an
> > fast-path :)) 
> 
> Oops, I thought the semantics were the other way around...
> 
> > -		ip[2] = sector_div(capacity, ip[0] * ip[1]);
> > +		ip[2] = capacity; 
> 
> This doesn't look right.  We updated the divisors (ip[0] and ip[1]) in the if 
> statement, so surely we have to recalculate the division?

Umm, right.


--- 1.11/drivers/scsi/scsicam.c	Fri Oct 25 13:31:53 2002
+++ edited/drivers/scsi/scsicam.c	Sun Oct 27 15:18:13 2002
@@ -80,11 +80,13 @@
 	if (ret || ip[0] > 255 || ip[1] > 63) {
 		ip[0] = 64;
 		ip[1] = 32;
-		if (sector_div(capacity, ip[0] * ip[1]) > 65534) {
+		sector_div(capacity, ip[0] * ip[1]);
+		if (capacity > 65534) {
 			ip[0] = 255;
 			ip[1] = 63;
 		}
-		ip[2] = sector_div(capacity, ip[0] * ip[1]);
+		sector_div(capacity, ip[0] * ip[1]);
+		ip[2] = capacity;
 	}
 
 	return 0;
