From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 17:37:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027173756.A16077@lst.de>
References: <hch@lst.de> <200210271634.g9RGYAY11441@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210271634.g9RGYAY11441@localhost.localdomain>; from James.Bottomley@steeleye.com on Sun, Oct 27, 2002 at 10:34:09AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sun, Oct 27, 2002 at 10:34:09AM -0600, James Bottomley wrote:
> > -		ip[2] = sector_div(capacity, ip[0] * ip[1]);
> > +		sector_div(capacity, ip[0] * ip[1]);
> > +		ip[2] = capacity;
> 
> Now you've lost your optimisation.  The second sector_div should be inside the 
> if.

Next try:


--- 1.11/drivers/scsi/scsicam.c	Fri Oct 25 13:31:53 2002
+++ edited/drivers/scsi/scsicam.c	Sun Oct 27 16:36:31 2002
@@ -80,11 +80,13 @@
 	if (ret || ip[0] > 255 || ip[1] > 63) {
 		ip[0] = 64;
 		ip[1] = 32;
-		if (sector_div(capacity, ip[0] * ip[1]) > 65534) {
+		sector_div(capacity, ip[0] * ip[1]);
+		if (capacity > 65534) {
 			ip[0] = 255;
 			ip[1] = 63;
+			sector_div(capacity, ip[0] * ip[1]);
 		}
-		ip[2] = sector_div(capacity, ip[0] * ip[1]);
+		ip[2] = capacity;
 	}
 
 	return 0;
