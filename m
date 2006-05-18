From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] printks in print_inquiry
Date: Thu, 18 May 2006 13:09:57 -0700
Message-ID: <20060518200957.GA29200@us.ibm.com>
References: <20060511150015.GJ12272@parisc-linux.org> <20060512170854.GA11215@us.ibm.com> <20060513050059.GR12272@parisc-linux.org> <20060518183652.GM1604@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:38850 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750799AbWERUKb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 16:10:31 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4IKAFp7028774
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 16:10:15 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4IKAFlD234450
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 14:10:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k4IKAFBE026119
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 14:10:15 -0600
Content-Disposition: inline
In-Reply-To: <20060518183652.GM1604@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, May 18, 2006 at 12:36:52PM -0600, Matthew Wilcox wrote:

> I went for:
> 
> scsi: 2:0:1:0: Vendor: HP 18.2G Model: ATLAS10K3_18_SCA Rev: HP05 ANSI rev: 02  
That is very nice ... as is replacing print_inquiry with one line of code.

> SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)                  
> sda: Write Protect is off                                                  
> SCSI device sda: drive cache: write through w/ FUA                        
>  sda: sda1 sda2 sda3                                                     
> sd 2:0:1:0: Attached scsi disk sda                                      
> sd 2:0:1:0: Attached scsi generic sg0 type 0                           
> 
> 
> wouldn't this look better?
> 
> sda: 35566480 512-byte hdwr sectors (18210 MB)                      
> sda: Write Protect is off                                                       
> sda: drive cache: write through w/ FUA                              
>  sda: sda1 sda2 sda3                                                  
> sd 2:0:1:0: Attached scsi disk sda                                   
> sd 2:0:1:0: Attached scsi generic sg0 type 0                        

Yes, better. I guess those should all be sdev_printk in sd.c.

Funky how loading sd after sg changes the output ... and using the driver
name as a prefix sometimes messes this up for scsi.

i.e. scan without sd_mod or sg loaded (and distro I'm using loads sg
before sd_mod via udev rules):

 0:0:0:0: Attached scsi generic sg0 type 0
 0:0:0:1: Attached scsi generic sg1 type 0

Then remove/add those devices, and sg lines become:

sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:1: Attached scsi generic sg1 type 0

> > > And maybe use printk("%-16s") formatting? But garbage might get printed
> > > for non-ASCII (though the SCSI specs say it is not allowed ...).
> 
> I think you meant %.16s, not %-16s; it's already padded, we just need a
> maximum byte count.

Yes, I was thinking it was not padded.

> Anyway, I noticed that sdev has everything I need in it, and it's
> definitely clearer than using the inquiry data directly.  The one thing
> I don't do this for is scsi_level; we want what the device returned,
> not what we've mangled it to.
> 
> The comment about BLIST_ISROM is a little too terse for me to know what
> to do; can anyone hazard a guess?

It is the only place that we modify the inquiry result, and I thought it
was gross and (a bit) confusing.

That is, after your patch, it could change to (and the no_uld_attach check
should not really be an "else"):

--- inq-print-linux-2.6.17-rc4-git6/drivers/scsi/o-scsi_scan.c	2006-05-18 11:57:28.000000000 -0700
+++ inq-print-linux-2.6.17-rc4-git6/drivers/scsi/scsi_scan.c	2006-05-18 12:06:05.000000000 -0700
@@ -598,18 +598,18 @@ static int scsi_add_lun(struct scsi_devi
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);
 
-	if (*bflags & BLIST_ISROM) {
-		/*
-		 * It would be better to modify sdev->type, and set
-		 * sdev->removable; this can now be done since
-		 * print_inquiry has gone away.
-		 */
-		inq_result[0] = TYPE_ROM;
-		inq_result[1] |= 0x80;	/* removable */
-	} else if (*bflags & BLIST_NO_ULD_ATTACH)
+	if (*bflags & BLIST_NO_ULD_ATTACH)
 		sdev->no_uld_attach = 1;
 
-	switch (sdev->type = (inq_result[0] & 0x1f)) {
+	if (*bflags & BLIST_ISROM) {
+		sdev->type = TYPE_ROM;
+		sdev->removable = 1;
+	} else {
+		sdev->type = (inq_result[0] & 0x1f);
+		sdev->removable = (0x80 & inq_result[1]) >> 7;
+	}
+
+	switch (sdev->type) {
 	case TYPE_TAPE:
 	case TYPE_DISK:
 	case TYPE_PRINTER:
@@ -652,7 +652,6 @@ static int scsi_add_lun(struct scsi_devi
 	 */ 
 
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
-	sdev->removable = (0x80 & inq_result[1]) >> 7;
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
 
-- Patrick Mansfield
