From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Mon, 28 Oct 2002 02:45:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028024519.A18865@lst.de>
References: <20021027221007.GA28417@win.tue.nl> <200210280005.g9S057Q14567@localhost.localdomain> <20021028005053.GA28587@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021028005053.GA28587@win.tue.nl>; from aebr@win.tue.nl on Mon, Oct 28, 2002 at 01:50:53AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Oct 28, 2002 at 01:50:53AM +0100, Andries Brouwer wrote:
> On Sun, Oct 27, 2002 at 06:05:07PM -0600, James Bottomley wrote:
> 
> > If the return type will be ignored by most applications, I don't see
> > what the problem is.
> 
> There is no problem. My longish reaction was mostly because you used
> "future proofing", that gave the impression that you did not know
> what this is about.
> 
> > (like an obviously wrong truncation)
> 
> No, the code I wrote was optimal.
> If you have 16 bits and the value is 70000, I prefer returning
> 65535 over 4464.

Why didn't you write is as patch?  James, this in Andries code
in patch from, it get's rid of the ugly sector_div so it should
be in if not just because of that.

--- 1.12/drivers/scsi/scsicam.c	Sun Oct 27 11:56:37 2002
+++ edited/drivers/scsi/scsicam.c	Mon Oct 28 01:12:24 2002
@@ -78,15 +78,18 @@
 	/* if something went wrong, then apparently we have to return
 	   a geometry with more than 1024 cylinders */
 	if (ret || ip[0] > 255 || ip[1] > 63) {
-		ip[0] = 64;
-		ip[1] = 32;
-		sector_div(capacity, ip[0] * ip[1]);
-		if (capacity > 65534) {
+		if ((capacity >> 11) > 65534) {
 			ip[0] = 255;
 			ip[1] = 63;
-			sector_div(capacity, ip[0] * ip[1]);
+		} else {
+			ip[0] = 64;
+			ip[1] = 32;
 		}
-		ip[2] = capacity;
+
+		if (capacity > 65535*63*255)
+			ip[2] = 65535;
+		else
+			ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
 	}
 
 	return 0;
